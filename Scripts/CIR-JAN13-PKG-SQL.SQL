************************ADD BY DEEPIKA 07/01/2013***********

ALTER PROCEDURE   [dbo].[wesp_updatedate1]

@compcode as varchar(15),
@userid as varchar(15),
@dateformat as varchar(15),
@code as varchar(4),
@curr as varchar(8),
@ratecode as varchar(8),
@solo as varchar(15),
@breakup as varchar(2),
@bwcode as varchar(8),
@rostatus as varchar(2),
@filename as varchar(2),
@tfn as VARCHAR(4),
@insertbreak as varchar(2),
@prem as varchar(8),
@dealtype as varchar(2),
@pre as varchar(5),
@suff as varchar(5),
@financestatus as  char(2),
@voucherst as varchar(30),
@adcode as varchar(100),
@rodatetime as varchar(8),
@spacearea as varchar(8),
@vat as varchar(50),
@bookstat as varchar(25),
@cio_id as varchar(8),
@receipt_no as varchar(50),
@uom as varchar(8),
@bgcolor as varchar(10),
@validdate as varchar(10),
@agencyratecode as varchar(10),
@audit as varchar(8),
@book_insert_date as varchar(8),
@agencycomm as varchar(8),
@rateaudit as varchar(8),
@billaudit as varchar(8),
@billtype as varchar(8),
@invoice_no as varchar(50),
@copybooking as varchar(8),
@ratecompany as varchar(50),
@addagenycomm as varchar(50),
@agencycommlinkretainer as varchar(50),
@subeditionr as varchar(50),
@displaybilltype as varchar(50),
@classifiedbilltype as varchar(50),
@billformat as varchar(50),
@ratechk as varchar(50),
@allpkg as varchar(50),
@dayrate1 as varchar(50),
@schemetype as varchar(50),
@PIncludeclassi as varchar(50),
@receiptformat as varchar(50),
@cash_receipt as varchar(50),
@bill_orderwiselast as varchar(50),
@floor_chk as varchar(50),
@Unsoldflag as varchar(1),
@Supplystopper as varchar(10),
@drpRokeychk as varchar(1),
@Agencycomm_seq as varchar(1),
@creditreciept as varchar(1),
@cashindisplay as varchar(8),
@cashinclassified as varchar(8),
@rate_audit_pref as varchar(25),
@v_barcoding_allow as varchar(25),
@v_fmgbills AS VARCHAR(25),
@v_billed_cashdis as varchar(25),
@v_billed_cashcls as varchar(25),
@v_drpbackdate as varchar(25),
@dockitbooking as varchar(1),
@allowprevbooking as varchar(1),
@ro_wisecashbill as varchar(50),
@chkval as varchar(5),
@approval1 as varchar(50),
@pckstatus as varchar(3),
@cash_disc as varchar(1),
@cash_amt as varchar(10),
@seperate_cashier1 as varchar(10),
@disp_bill as varchar(1),
@clas_bill as varchar(1),
@mantimepost as varchar(1),
@bkdaypost as int,
@maxterutn as int,
@cir_return as varchar(1),
@noofchkbounc as int,
@noofdaychkrec as int,
@retday as int,
@chngsuppord as int,
@max_publishday as int,
@p_billno_period as varchar(15),
@spl_trans_edit as varchar(5),
@spl_dis_trans_editable as varchar(5),
@mul_pac_sel_trans as varchar(5),
@shmon_minword	as varchar(1),
@tradon_spcrg	as varchar(1),
@rateauth       as varchar(1),
@f2day as int,
@rateauditmodify as varchar(1),
@bindrevenuecenter as varchar(1),
@p_led_allow as varchar(2),
@p_clear_allow as varchar(2),
@repeatday as varchar(2),
@premiumedit as varchar(2),
@P_BILL_GENERATION as varchar(20),
@P_PUBLICATION_CENTER as varchar(50),
@P_allow_discount_prem as varchar(1),
@P_SCHEME_BILLING as varchar(50),
@P_ALLOW_PDC as varchar(50),
@PAD_TYPE_FOR_MANUL_BILL AS VARCHAR(20),
@RO_OUTSTAND_P AS VARCHAR(5),
@genrate_agency_code AS VARCHAR(5),
@p_dispauditbk AS VARCHAR(5),
@p_aotosupply  AS VARCHAR(5),
@p_Authorization as VARCHAR(1),
@p_CIR_AUTO_APPROVAL_UNSOLD AS VARCHAR(5),
@p_CIR_AUTO_PHYSICAL_UNSOLD AS VARCHAR(5),
@p_CIR_UNSOLD_INCLUDE_INCT AS VARCHAR(5),
@p_CIR_UNSOLD_INCLUDE_INSFEE AS VARCHAR(5),
@p_CIR_UNSOLD_ON_RECEIVED_DT AS VARCHAR(5),
@p_AGENCY_UNBLOCK_APPROVAL AS VARCHAR(5),
@p_UNBLOCK_APPROVAL_OUTSIDE_LIMIT AS VARCHAR(5),
@p_CIR_BILL_PUBLWISE AS VARCHAR(5),
@paging         AS VARCHAR(4000) ,
@print          AS VARCHAR(4000) ,
@allowpage      AS VARCHAR(4000) ,
@agency_req     AS VARCHAR(4000) ,
@region_req     AS VARCHAR(4000) ,
@p_ALLOW_FOLLOW_DT_BOOOK as varchar(1),
@p_CRM_SUPPLY_TYPE_PAID   as varchar(10),
@p_CRM_SUPPLY_TYPE_FREE   as varchar(10),
@p_CURRENCY_MEASUREMENT   as varchar(5),


@p_EDITABLE_AGENCY_COMM as varchar(1),
@p_CANCELLATION_CHARGE as varchar(1),
@P_taxi_entry_type     as VARCHAR(1),
@P_ApprovalWith          as VARCHAR(1),
@p_Auto_TDS_Credit_Note as varchar(1),
@p_TDS_Reason as varchar(10),
@p_Debit_Account_Head as varchar(10),
@p_credit_Account_Head as varchar(10),
@p_service_tax_credit_note as varchar(1),
@p_Tax_Reason as varchar(10),
@p_Debit_Account_Service_Tax as varchar(10),
@p_Credit_Account_Service_Tax as varchar(10),
@p_Auto_Patrakar_Credit_Note as varchar(1),
@p_Patrakar_Reason as varchar(10),
@p_Debit_Account_Patrakar as varchar(10),
@p_Credit_Account_Patrakar as varchar(10),
@p_Auto_Bank_Credit_Note as varchar(1),
@p_Bank_Reason as VARCHAR(10),
@p_Debit_Account_Bank as varchar(10),
@p_Credit_Account_Bank as varchar(10),
@P_BAR_CODE as VARCHAR(5),
@P_GEN_RCT_NO as VARCHAR(5),
@P_misdata as VARCHAR(5) =null,
@P_WEIGHT_CAL as VARCHAR(5) =null,
@P_allowpremium as varchar(5) =null,
@p_financecode as varchar(5) =null,
@p_exepub as varchar(5)=null,
@p_executivecreditlimit as varchar(5)=null,
--new add
@P_postdis as varchar(5) =null,
@P_suppdecreselimit as varchar(5) =null,
@P_allowvat as varchar(5) =null,
@P_alterroute as varchar(5) =null,
@P_showrecptag as varchar(5) =null,
@P_allowhoSUN as varchar(5) =null,
@P_allowhoMON as varchar(5) =null,
@P_allowhoTUE as varchar(5) =null,
@P_allowhoWED as varchar(5) =null,
@P_allowhoTHU as varchar(5) =null,
@P_allowhoFRI as varchar(5) =null,
@P_allowhoSAT as varchar(5) =null,
@P_autoinfo   as varchar(20) =null,
@Psap_id	  as varchar(20) =null,
@p_mrv   as varchar(1) =null,
@p_schhr	as	varchar(20)=null,
@p_ret_after_bank as varchar=null,
@P_commedi_forunit as varchar(5) =null,
@p_fixedtransamt as float =null,
@p_tradediscount as  varchar(20)=null,
@generate_account_format as varchar(20)=null,
--new add
@P_min_max_validate_correction as varchar(5) =null,
@P_base_supply_enable_alteration as varchar(5) =null,
@P_UCN_PROCESS as varchar(5) =null,
@P_update_estimation as varchar(1) =null,
@P_email_sms_approval as varchar(1) =null,
@P_UCN_AUTO_ADJUSTMENT as varchar(1) =null




AS
declare @query as varchar(8000)
declare @query1 as varchar(8000)
/*
set @query='update login set date_format='''+@dateformat+''' , Autogenerate='''+@code+''',curr_code='''+@curr+''' where com_code='''+@compcode+'''   '
exec(@query)

set @query1='update preferrences set RATE_COMPANY_AGENCY='''+@ratecompany+''',ADDITIONAL_AGENCY_COMM='''+@addagenycomm+''',
AGENCY_RETAINER_COMM='''+@agencycommlinkretainer+''',SUBEDITIONRATE='''+@subeditionr+''',DIS_BILLTYPE='''+@displaybilltype+''',
CLS_BILLTYPE='''+@classifiedbilltype+''',autogenerated='''+@code+''',currency_code='''+@curr+''' ,rate_gr_code='''+@ratecode+''' , 
date_format='''+@dateformat+''',solo='''+@solo+''',breakup='''+@breakup+''' ,blackwhitecode='''+@bwcode+''',  rostatus='''+@rostatus+''',
File_name='''+@filename+''',Tfn='''+@tfn+''',Insert_breakup='''+@insertbreak+''',Premium_type='''+@prem+''',Deal_type='''+@dealtype+'''  ,    
prefix='''+@pre+''', suffix='''+@suff+'''  ,     financestatus='''+ @financestatus+''' , voucherst='''+@voucherst+''',Ad_category='''+@adcode+''' ,
Ro_datetime='''+@rodatetime+''' ,Space_area='''+@spacearea+''',Vat='''+@vat+''' ,Booking_status='''+@bookstat+''' ,Cio_id='''+@cio_id+''',
Receipt_no='''+@receipt_no+''' ,uom_code='''+@uom+''',Bgcolor_publication='''+@bgcolor+''' ,chkfor_valid_pubdates='''+@validdate+''', 
Agency_ratecode='''+@agencyratecode+''',   audit='''+@audit+''', book_insert_date='''+@book_insert_date+''',agencycomm='''+@agencycomm+''',
rate_audit='''+@rateaudit+''',bill_audit='''+@billaudit+''', billtype='''+@billtype+''', invoice_no='''+@invoice_no+''' , 
copy_booking='''+@copybooking+''', BILLING_FORMAT='''+@billformat+''' , RATE_CHECK='''+@ratechk+''', ALL_PACKAGE='''+@allpkg+''',
DAYRATE='''+@dayrate1+''' ,SCHEME_TYPE='''+@schemetype+'''    ,DISP_CLSBILL='''+@PIncludeclassi+ '''  , RECEIPT_FORMAT ='''+@receiptformat+''',
CASH_RECEIPT_BILL='''+@cash_receipt+''', BILL_ORDERWSLAST='''+@bill_orderwiselast+''',FLOOR_CHK='''+@floor_chk+''' ,
Unsold_Entry_Flag='''+@Unsoldflag+''' ,Supply_Stop_Percentage='''+@Supplystopper+''',ROKEYCHECK='''+@drpRokeychk+''',
AGENCYCOMM_SEQ_COM='''+@Agencycomm_seq+''' ,CREDIT_RECIPT='''+@creditreciept+''',DISP_CASHBILL='''+@cashindisplay+''',
CLA_CASHBILL='''+@cashinclassified+''',RATE_AUDIT_PREF='''+@rate_audit_pref+''',BARCODING_ALLOWED='''+@v_barcoding_allow+''', 
FMG_BILL_DIS='''+@v_fmgbills+''',BILL_DISP_CASHBILL='''+@v_billed_cashdis +''',BILL_CLA_CASHBILL ='''+@v_billed_cashcls+''',
BACKDATERECEIPT='''+@v_drpbackdate+''',DOCKIT_BOOKING='''+@dockitbooking+''',Allowed_old_date='''+@allowprevbooking+''',
ROWISE_CASHBOOKING='''+@ro_wisecashbill+''' where    comp_code='''+@compcode+'''   ' 
*/
/*********************************************************************************************************/
UPDATE LOGIN SET date_format=@dateformat, Autogenerate=@code,curr_code=@curr WHERE COM_CODE=@compcode

UPDATE PREFERRENCES SET  autogenerated=@code,
currency_code=@curr ,
rate_gr_code=@ratecode,
date_format=@dateformat,solo=@solo,breakup=@breakup,
blackwhitecode=@bwcode,rostatus=@rostatus,File_name=@filename,Tfn=@tfn,
Insert_breakup=@insertbreak,Premium_type=@prem,Deal_type=@dealtype  ,
 prefix=@pre, suffix=@suff, financestatus=@financestatus , voucherst=@voucherst,
 Ad_category=@adcode ,Ro_datetime=@rodatetime ,Space_area=@spacearea,Vat=@vat,
 Booking_status=@bookstat,Cio_id=@cio_id,Receipt_no=@receipt_no,uom_code=@uom,
 Bgcolor_publication=@bgcolor ,chkfor_valid_pubdates=@validdate, Agency_ratecode=@agencyratecode,
  audit=@AUDIT,book_insert_date=@book_insert_date,agencycomm=@agencycomm,
  rate_audit=@rateaudit,bill_audit=@billaudit,billtype=@billtype,invoice_no=@invoice_no,
  copy_booking=@copybooking,RATE_COMPANY_AGENCY=@ratecompany, ADDITIONAL_AGENCY_COMM=@addagenycomm ,
  AGENCY_RETAINER_COMM=@agencycommlinkretainer,SUBEDITIONRATE=@subeditionr,
  CLS_BILLTYPE=@classifiedbilltype,DIS_BILLTYPE=@displaybilltype,BILLING_FORMAT=@billformat,
  RATE_CHECK=@ratechk,ALL_PACKAGE=@allpkg,dayrate=@dayrate1,SCHEME_TYPE=@schemetype,DISP_CLSBILL=@PIncludeclassi   ,
  CASH_RECEIPT_BILL=@cash_receipt, BILL_ORDERWSLAST=@bill_orderwiselast, FLOOR_CHK=@floor_chk ,
  Unsold_Entry_Flag=@Unsoldflag ,Supply_Stop_Percentage=@Supplystopper,ROKEYCHECK=@drpRokeychk ,
  AGENCYCOMM_SEQ_COM=@Agencycomm_seq ,CREDIT_RECIPT=@creditreciept,DISP_CASHBILL=@cashindisplay,
  CLA_CASHBILL=@cashinclassified,RATE_AUDIT_PREF=@rate_audit_pref,BARCODING_ALLOWED=@v_barcoding_allow,
  FMG_BILL_DIS =@v_fmgbills, BILL_DISP_CASHBILL=@v_billed_cashdis , BILL_CLA_CASHBILL=@v_billed_cashcls,BACKDATERECEIPT=@v_drpbackdate,DOCKIT_BOOKING=@dockitbooking,Allowed_old_date=@allowprevbooking,ROWISE_CASHBOOKING=@ro_wisecashbill,CUTOFFTIME=@chkval,APPROVAL=@approval1,back_days=@pckstatus,CASH_DISCOUNT=@cash_amt,CASH_DISCOUNTTYPE=@cash_disc,SEPRATE_CASHIER=@seperate_cashier1,
 CIR_MANY_TIME_POSTING=@mantimepost, CIR_BACKDAYS_POSTING=@bkdaypost, CIR_MAX_RETURN_ALLOW=@maxterutn, CIR_RETURN_LIMIT_ALLOW=@cir_return, CIR_NO_OF_CHQBOUNCE=@noofchkbounc, CIR_DAYS_CHQBOUNCE=@noofdaychkrec, CIR_RETURN_DAYS=@retday, CIR_SUP_ORDER_LIMIT=@chngsuppord, DISP_BILLING_CRITERIA=@disp_bill, CLSD_BILLING_CRITERIA=@clas_bill,MAX_PUBLISHDAYS=@max_publishday,
 BILLNO_PERIODICITY=@p_billno_period,SPECIALDISC_TRANS_EDIT=@spl_trans_edit, SHARING_TRANS=@spl_dis_trans_editable, MULTIPACKAGE_SEL_TRANS=@mul_pac_sel_trans,SCHEME_MINWORD=@shmon_minword, TRADE_SPLCHARGE=@tradon_spcrg,RATE_AUTHORIZATION=@rateauth
  ,F2_RECORD=@f2day,PUBLISHAD_EDIT_RATEAUDIT=@rateauditmodify,BINDREVENUE_CENTER=@bindrevenuecenter,
FA_LEDGER_ALLOW=@p_led_allow,CLEARANCE_TYPE_ALLOW=@p_clear_allow,REPEAT_DAY_TYPE=@repeatday,PREMIUM_EDIT=@premiumedit,

BILL_GENERATION_PRIOR=@P_BILL_GENERATION,PUBLICATION_HO=@P_PUBLICATION_CENTER,

SPLDISC_ALLOWPREM=@P_allow_discount_prem,BILL_SCHEME=@P_SCHEME_BILLING,

ALLOWED_PDC_DAYS_RECEIPT=@P_ALLOW_PDC,AD_TYPE_MANUL_BILL=@PAD_TYPE_FOR_MANUL_BILL,OUTSTANDING_AMT_CRITERIA=@RO_OUTSTAND_P,GENRATE_CIR_AGCD=@genrate_agency_code,DISP_AUDITBKG=@p_dispauditbk,CIR_DIS_AUTO_POSTING=@p_aotosupply,RELAUTHREQON=@p_Authorization,
CIR_AUTO_APPROVAL_UNSOLD=@p_CIR_AUTO_APPROVAL_UNSOLD,CIR_AUTO_PHYSICAL_UNSOLD=@p_CIR_AUTO_PHYSICAL_UNSOLD,CIR_UNSOLD_INCLUDE_INCT=@p_CIR_UNSOLD_INCLUDE_INCT,
CIR_UNSOLD_INCLUDE_INSFEE=@p_CIR_UNSOLD_INCLUDE_INSFEE,CIR_UNSOLD_ON_RECEIVED_DT=@p_CIR_UNSOLD_ON_RECEIVED_DT,AGENCY_UNBLOCK_APPROVAL=@p_AGENCY_UNBLOCK_APPROVAL,UNBLOCK_APPROVAL_OUTSIDE_LIMIT=@p_UNBLOCK_APPROVAL_OUTSIDE_LIMIT,CIR_BILL_PUBLWISE=@p_CIR_BILL_PUBLWISE,
RECORDS_ON_PAGE = @paging,RECORDS_ON_PRINT = @print,HEADER_ON_PAGE = @allowpage,AGENCY_REQUIRED = @agency_req,REGION_REQUIRED = @region_req,ALLOW_FOLLOW_DT_BOOOK=@p_ALLOW_FOLLOW_DT_BOOOK,CRM_SUPPLY_TYPE_PAID=@p_CRM_SUPPLY_TYPE_PAID,CRM_SUPPLY_TYPE_FREE=@p_CRM_SUPPLY_TYPE_FREE,CURRENCY_MEASUREMENT=@p_CURRENCY_MEASUREMENT,EDITABLE_AGENCY_COMM =@p_EDITABLE_AGENCY_COMM,CANCELLATION_CHARGE =@p_CANCELLATION_CHARGE,taxi_entry_type=@P_taxi_entry_type,APPROVAL_WITH =@P_ApprovalWith,

TDS_AUTO_CN=@p_Auto_TDS_Credit_Note,
TDS_AUTO_REASON=@p_TDS_Reason ,TDS_DB_CDP=@p_Debit_Account_Head,TDS_CR_CDP=@p_credit_Account_Head,SER_TAX_AUTO_CN=@p_service_tax_credit_note,SER_TAX_AUTO_REASON=@p_Tax_Reason,SER_TAX_DB_CDP=@p_Debit_Account_Service_Tax,SER_TAX_CR_CDP=@p_Credit_Account_Service_Tax,PKK_AUTO_CN=@p_Auto_Patrakar_Credit_Note,PKK_AUTO_REASON=@p_Patrakar_Reason ,PKK_DB_CDP=@p_Debit_Account_Patrakar,PKK_CR_CDP=@p_Credit_Account_Patrakar ,BANK_CHG_AUTO_CN=@p_Auto_Bank_Credit_Note ,
BANK_CHG_AUTO_REASON=@p_Bank_Reason ,BANK_CHG_DB_CDP=@p_Debit_Account_Bank ,BANK_CHG_CR_CDP=@p_Credit_Account_Bank,

 CIR_BARCODE= @P_BAR_CODE,CIR_WIEGHT_CALC_REQ= @P_WEIGHT_CAL,GEN_RCT_TYP = @P_GEN_RCT_NO,PRODUCT_BRAND_REQ=@P_misdata,ALLOWPREM_CARD_DISC_RATE=@P_allowpremium,FINANCE_CADE=@p_financecode,EXECUTIVE_PUBLICATION_VISE=@p_exepub,EXECUTIVECREDITLIMIT=@p_executivecreditlimit,TRADE_DIS_BASED_ON=@p_tradediscount,FIXED_TRANSACTION_AMT=@p_fixedtransamt,amount_formate=@generate_account_format,
--NEW ADD
 CIR_POST_DIS=@P_postdis,
 CIR_VAT_ALLOW=@P_allowvat,
 CIR_SUP_ALT_ROUTE=@P_alterroute,
 SHOW_REC_ALL_AGENCY=@P_showrecptag,
 CIR_SUP_ORDER_DEC_LIMIT=@P_suppdecreselimit,
 CIR_ALLOW_HOLIDAY_SUN=@P_allowhoSUN,
 CIR_ALLOW_HOLIDAY_MON=@P_allowhoMON,       
 CIR_ALLOW_HOLIDAY_TUE=@P_allowhoTUE,
 CIR_ALLOW_HOLIDAY_WED=@P_allowhoWED,
 CIR_ALLOW_HOLIDAY_THU=@P_allowhoTHU,
 CIR_ALLOW_HOLIDAY_FRI=@P_allowhoFRI,
 CIR_ALLOW_HOLIDAY_SAT=@P_allowhoSAT,
 CRM_AUTOINFO=@P_autoinfo,
 SAP_ID=@Psap_id,
 MRV_BASED_ON =@p_mrv,
 SCHEDULING_HOURS=@p_schhr,
ALLOW_RET_AFTER_BANK=@p_ret_after_bank,
COMMON_EDITION_FOR_UNIT=@P_commedi_forunit,
--new add
 MIN_MAX_VALIDATE_IN_CORRECTION=@P_min_max_validate_correction,
 CIR_BASE_SUP_ENBL_SUPALTER=@P_base_supply_enable_alteration,
 CIR_UCN_PUB_DATE_WISE =@P_UCN_PROCESS,
 CIR_UPDATE_ESTIMATION=@P_update_estimation,
 CIR_EMAIL_SMS_IN_APPROVAL=@P_email_sms_approval,
 CIR_UCN_AUTO_ADJUSTMENT=@P_UCN_AUTO_ADJUSTMENT

 WHERE comp_code=@compcode




/* ,
',Unsold_Entry_Flag='''+@Unsoldflag+''',Supply_Stop_Percentage='''+@Supplystopper+'''

,ROKEYCHECK='''+@drpRokeychk+''',AGENCYCOMM_SEQ_COM='''+@Agencycomm_seq+''' ,CREDIT_RECIPT='''+@creditreciept+''' where    comp_code='''+@compcode+'''   ' 



--,DISP_CASHBILL='''+@cashindisplay+''',CLA_CASHBILL='''+@cashinclassified+'''
*/

print(@query1)
exec(@query1)


///////////////////////////////////////////////////

ALTER PROCEDURE [dbo].[currbindpreferpgld]
@compcode as varchar(8)

AS

/*select date_format,autogenerated,currency_code,rate_gr_code,solo,breakup,blackwhitecode,rostatus,File_name,Tfn,Insert_breakup  , prefix,suffix,financestatus,voucherst,Ad_category,Ro_datetime,Vat,Booking_status,Cio_id,Receipt_no,uom_code,Bgcolor_publication,chkfor_valid_pubdates,
Agency_ratecode,audit,book_insert_date,agencycomm,rate_audit,bill_audit,billtype,Premium_type,copy_booking,RATE_COMPANY_AGENCY,ADDITIONAL_AGENCY_COMM,AGENCY_RETAINER_COMM,SUBEDITIONRATE,CLS_BILLTYPE,DIS_BILLTYPE,BILLING_FORMAT,RATE_CHECK,ALL_PACKAGE,DAYRATE,SCHEME_TYPE,DISP_CLSBILL, RECEIPT_FORMAT ,CASH_RECEIPT_BILL, BILL_ORDERWSLAST, FLOOR_CHK,DISP_CASHBILL, CLA_CASHBILL,RATE_AUDIT_PREF ,  FMG_BILL_DIS,BARCODING_ALLOWED,BILL_DISP_CASHBILL,BILL_CLA_CASHBILL ,BACKDATERECEIPT,ROWISE_CASHBOOKING from preferrences where comp_code=@compcode
*/

  SELECT date_format, autogenerated, currency_code,
                rate_gr_code, solo, breakup, blackwhitecode,
                rostatus, File_name, Tfn, Insert_breakup, prefix,
                suffix, financestatus, voucherst, Ad_category,
                Ro_datetime, Vat, Booking_status, Cio_id,
                Receipt_no,uom_code,Bgcolor_publication,chkfor_valid_pubdates,Agency_ratecode,audit,book_insert_date,agencycomm,
                rate_audit,bill_audit,billtype,Premium_type,copy_booking,RATE_COMPANY_AGENCY,ADDITIONAL_AGENCY_COMM,AGENCY_RETAINER_COMM,SUBEDITIONRATE,CLS_BILLTYPE,DIS_BILLTYPE,
				BILLING_FORMAT,RATE_CHECK,ALL_PACKAGE,dayrate,SCHEME_TYPE,DISP_CLSBILL,RECEIPT_FORMAT,CASH_RECEIPT_BILL, BILL_ORDERWSLAST, FLOOR_CHK,
                ROKEYCHECK, AGENCYCOMM_SEQ_COM, CREDIT_RECIPT,  DISP_CASHBILL, CLA_CASHBILL,
				RATE_AUDIT_PREF,BARCODING_ALLOWED, FMG_BILL_DIS,BILL_DISP_CASHBILL, BILL_CLA_CASHBILL,BACKDATERECEIPT,ROWISE_CASHBOOKING,CUTOFFTIME,DOCKIT_BOOKING,APPROVAL,back_days as BACK_DAYS,CASH_DISCOUNT,CASH_DISCOUNTTYPE,Allowed_old_date,SEPRATE_CASHIER,
                CIR_MANY_TIME_POSTING, CIR_BACKDAYS_POSTING, CIR_MAX_RETURN_ALLOW, CIR_RETURN_LIMIT_ALLOW, CIR_NO_OF_CHQBOUNCE, CIR_DAYS_CHQBOUNCE, CIR_RETURN_DAYS, CIR_SUP_ORDER_LIMIT, DISP_BILLING_CRITERIA, CLSD_BILLING_CRITERIA,MAX_PUBLISHDAYS,BILLNO_PERIODICITY, SPECIALDISC_TRANS_EDIT, SHARING_TRANS, MULTIPACKAGE_SEL_TRANS,SCHEME_MINWORD, TRADE_SPLCHARGE,RATE_AUTHORIZATION,F2_RECORD,PUBLISHAD_EDIT_RATEAUDIT,BINDREVENUE_CENTER, FA_LEDGER_ALLOW,CLEARANCE_TYPE_ALLOW,REPEAT_DAY_TYPE,PREMIUM_EDIT,
BILL_GENERATION_PRIOR,PUBLICATION_HO,SPLDISC_ALLOWPREM,BILL_SCHEME,
ALLOWED_PDC_DAYS_RECEIPT,AD_TYPE_MANUL_BILL, OUTSTANDING_AMT_CRITERIA as RO_OUTSTAND,GENRATE_CIR_AGCD,DISP_AUDITBKG,CIR_DIS_AUTO_POSTING,RELAUTHREQON,
CIR_AUTO_APPROVAL_UNSOLD, CIR_AUTO_PHYSICAL_UNSOLD, CIR_UNSOLD_INCLUDE_INCT, CIR_UNSOLD_INCLUDE_INSFEE, CIR_UNSOLD_ON_RECEIVED_DT,AGENCY_UNBLOCK_APPROVAL,UNBLOCK_APPROVAL_OUTSIDE_LIMIT,CIR_BILL_PUBLWISE,RECORDS_ON_PAGE,RECORDS_ON_PRINT,HEADER_ON_PAGE,AGENCY_REQUIRED,REGION_REQUIRED,ALLOW_FOLLOW_DT_BOOOK,CRM_SUPPLY_TYPE_PAID,CRM_SUPPLY_TYPE_FREE,CURRENCY_MEASUREMENT,Space_area,EDITABLE_AGENCY_COMM,CANCELLATION_CHARGE,TAXI_ENTRY_TYPE,APPROVAL_WITH,   TDS_AUTO_CN,TDS_AUTO_REASON,TDS_DB_CDP,TDS_CR_CDP,SER_TAX_AUTO_CN,SER_TAX_AUTO_REASON,SER_TAX_DB_CDP,SER_TAX_CR_CDP,PKK_AUTO_CN,PKK_AUTO_REASON,PKK_DB_CDP,PKK_CR_CDP,BANK_CHG_AUTO_CN,BANK_CHG_AUTO_REASON,BANK_CHG_DB_CDP,BANK_CHG_CR_CDP ,


CIR_BARCODE,CIR_WIEGHT_CALC_REQ,GEN_RCT_TYP,PRODUCT_BRAND_REQ,ALLOWPREM_CARD_DISC_RATE,FINANCE_CADE,EXECUTIVE_PUBLICATION_VISE,EXECUTIVECREDITLIMIT,MRV_BASED_ON,FIXED_TRANSACTION_AMT,TRADE_DIS_BASED_ON,
---NEW ADD
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
	CIR_UCN_POCESS_IN_GROUP,amount_formate
---new add
    CIR_UCN_PUB_DATE_WISE,
	CIR_UPDATE_ESTIMATION,
	CIR_EMAIL_SMS_IN_APPROVAL,
	CIR_UCN_AUTO_ADJUSTMENT 
           FROM PREFERRENCES
          WHERE comp_code = @compcode


**************************************END***********************

*****************************************************add by Deepika 10/01/2013****************************



ALTER PROCEDURE [dbo].[cir_new_pub_sup_update_in_supply]
      @pcomp_code          as varchar(20),
      @punit_code          as varchar(20),
      @ppubl_from          as varchar(20),
      @pedtn_from          as varchar(20),
      @psubedtn_from       as varchar(20),
      @psupplytype_from    as varchar(20),
      @ppubl_to            as varchar(20),
      @pedtn_to            as varchar(20),
      @psubedtn_to         as varchar(20),
      @psupplytype_to      as varchar(20),
      @pstatus             as varchar(1),---FOR FIX F,PERCENTAGE P
      @psupply             as int,
      @puserid             as varchar(20),
      @pdateformat         as varchar(20),
      @pextra1             as varchar(20),
      @pextra2             as varchar(20),
      @pextra3             as varchar(20),
      @pextra4             as varchar(20),
      @pextra5             as varchar(20)
      
AS 
                                    
	declare @v_str as varchar(max)
	
    
	declare c1 cursor for
		select COMP_CODE,UNIT,AGCD,DPCD,PUBL,EDTN,SUPPLY_TYPE_CODE
		,BASE_SUPPLY,SUPPLY_SUN,SUPPLY_MON,SUPPLY_TUE,SUPPLY_WED,SUPPLY_THU,SUPPLY_FRI,SUPPLY_SAT ,SUPPLY_SPL1,SUPPLY_SPL2
		,SP_SUPPLY_MON1,SP_SUPPLY_TUE1,SP_SUPPLY_WED1,SP_SUPPLY_THU1,SP_SUPPLY_FRI1,SP_SUPPLY_SAT1,SP_SUPPLY_SUN1
		,SP_SUPPLY_MON2,SP_SUPPLY_TUE2,SP_SUPPLY_WED2,SP_SUPPLY_THU2,SP_SUPPLY_FRI2,SP_SUPPLY_SAT2,SP_SUPPLY_SUN2
		from cir_supply where comp_code=@pcomp_code and unit=@punit_code and publ=@ppubl_from and edtn=@psubedtn_from  

	DECLARE @v1_COMP_CODE as varchar(200)
	DECLARE @v1_UNIT as varchar(200)
	DECLARE @v1_AGCD as varchar(200)
	DECLARE @v1_DPCD as varchar(200)
	DECLARE @v1_PUBL as varchar(200)
	DECLARE @v1_EDTN as varchar(200)
	DECLARE @v1_SUPPLY_TYPE_CODE as varchar(200)
	DECLARE @v1_BASE_SUPPLY as numeric(12)
	DECLARE @v1_SUPPLY_SUN as numeric(12)
	DECLARE @v1_SUPPLY_MON as numeric(12)
	DECLARE @v1_SUPPLY_TUE as numeric(12)
	DECLARE @v1_SUPPLY_WED as numeric(12)
	DECLARE @v1_SUPPLY_THU as numeric(12)
	DECLARE @v1_SUPPLY_FRI as numeric(12)
	DECLARE @v1_SUPPLY_SAT  as numeric(12)
	DECLARE @v1_SUPPLY_SPL1 as numeric(12)
	DECLARE @v1_SUPPLY_SPL2 as numeric(12)
	DECLARE @v1_SP_SUPPLY_MON1 as numeric(12)
	DECLARE @v1_SP_SUPPLY_TUE1 as numeric(12)
	DECLARE @v1_SP_SUPPLY_WED1 as numeric(12)
	DECLARE @v1_SP_SUPPLY_THU1 as numeric(12)
	DECLARE @v1_SP_SUPPLY_FRI1 as numeric(12)
	DECLARE @v1_SP_SUPPLY_SAT1 as numeric(12)
	DECLARE @v1_SP_SUPPLY_SUN1 as numeric(12)
	DECLARE @v1_SP_SUPPLY_MON2 as numeric(12)
	DECLARE @v1_SP_SUPPLY_TUE2 as numeric(12)
	DECLARE @v1_SP_SUPPLY_WED2 as numeric(12)
	DECLARE @v1_SP_SUPPLY_THU2 as numeric(12)
	DECLARE @v1_SP_SUPPLY_FRI2 as numeric(12)
	DECLARE @v1_SP_SUPPLY_SAT2 as numeric(12)
	DECLARE @v1_SP_SUPPLY_SUN2 as numeric(12)




	open c1  
		fetch next from c1 into @v1_COMP_CODE,@v1_UNIT,@v1_AGCD,@v1_DPCD,@v1_PUBL,@v1_EDTN,@v1_SUPPLY_TYPE_CODE,@v1_BASE_SUPPLY
		,@v1_SUPPLY_SUN,@v1_SUPPLY_MON,@v1_SUPPLY_TUE,@v1_SUPPLY_WED,@v1_SUPPLY_THU,@v1_SUPPLY_FRI,@v1_SUPPLY_SAT,@v1_SUPPLY_SPL1,@v1_SUPPLY_SPL2
		,@v1_SP_SUPPLY_MON1,@v1_SP_SUPPLY_TUE1,@v1_SP_SUPPLY_WED1,@v1_SP_SUPPLY_THU1,@v1_SP_SUPPLY_FRI1,@v1_SP_SUPPLY_SAT1,@v1_SP_SUPPLY_SUN1
		,@v1_SP_SUPPLY_MON2,@v1_SP_SUPPLY_TUE2,@v1_SP_SUPPLY_WED2,@v1_SP_SUPPLY_THU2,@v1_SP_SUPPLY_FRI2,@v1_SP_SUPPLY_SAT2,@v1_SP_SUPPLY_SUN2
		while(@@fetch_status=0)
		begin
			 if @pstatus ='F'
			 begin
					if ISNULL(@psupply,0) !=0
					begin
						if isnull(@pextra1,'A') ='A'
						begin
							update CIR_SUPPLY set BASE_SUPPLY=@v1_BASE_SUPPLY+@psupply,SUPPLY_SUN=@v1_SUPPLY_SUN+@psupply,SUPPLY_MON=@v1_SUPPLY_MON+@psupply
							,SUPPLY_TUE=@v1_SUPPLY_TUE+@psupply,SUPPLY_WED=@v1_SUPPLY_WED+@psupply,SUPPLY_THU=@v1_SUPPLY_THU+@psupply,SUPPLY_FRI=@v1_SUPPLY_FRI+@psupply
							,SUPPLY_SAT=@v1_SUPPLY_SAT+@psupply ,SUPPLY_SPL1=@v1_SUPPLY_SPL1+@psupply,SUPPLY_SPL2=@v1_SUPPLY_SPL2+@psupply
							,SP_SUPPLY_MON1=@v1_SP_SUPPLY_MON1+@psupply,SP_SUPPLY_TUE1=@v1_SP_SUPPLY_TUE1+@psupply,SP_SUPPLY_WED1=@v1_SP_SUPPLY_WED1+@psupply
							,SP_SUPPLY_THU1=@v1_SP_SUPPLY_THU1+@psupply,SP_SUPPLY_FRI1=@v1_SP_SUPPLY_FRI1+@psupply,SP_SUPPLY_SAT1=@v1_SP_SUPPLY_SAT1+@psupply
							,SP_SUPPLY_SUN1=@v1_SP_SUPPLY_SUN1+@psupply,SP_SUPPLY_MON2=@v1_SP_SUPPLY_MON2+@psupply,SP_SUPPLY_TUE2=@v1_SP_SUPPLY_TUE2+@psupply
							,SP_SUPPLY_WED2=@v1_SP_SUPPLY_WED2+@psupply,SP_SUPPLY_THU2=@v1_SP_SUPPLY_THU2+@psupply,SP_SUPPLY_FRI2=@v1_SP_SUPPLY_FRI2+@psupply
							,SP_SUPPLY_SAT2=@v1_SP_SUPPLY_SAT2+@psupply,SP_SUPPLY_SUN2=@v1_SP_SUPPLY_SUN2+@psupply
							 where comp_code=@pcomp_code and unit=@punit_code and publ=@ppubl_to and edtn=@psubedtn_to  and AGCD=@v1_AGCD and DPCD=@v1_DPCD
						end
						else
						begin
							 
							 set @v_str =' update CIR_SUPPLY set ' + @psupplytype_to + ' =(select CAST(isnull('+@psupplytype_from+',0) as varchar) + '+cast(isnull(@psupply,0) AS VARCHAR)+' from CIR_SUPPLY where comp_code='''+@pcomp_code+''' and unit='''+@punit_code+''' and publ='''+@ppubl_from+''' and edtn='''+@psubedtn_from+'''  and AGCD='''+@v1_AGCD+''' and DPCD='''+@v1_DPCD+''' ) 
							 where comp_code='''+@pcomp_code+''' and unit='''+@punit_code+''' and publ='''+@ppubl_to+''' and edtn='''+@psubedtn_to+'''  and AGCD='''+@v1_AGCD+''' and DPCD='''+@v1_DPCD+'''  ' 
							 print(@v_str)
							 exec(@v_str)							
							 
						end	 
					end
					else
					begin
						if isnull(@pextra1,'A') ='A'
						begin
							update CIR_SUPPLY set BASE_SUPPLY=@v1_BASE_SUPPLY,SUPPLY_SUN=@v1_SUPPLY_SUN,SUPPLY_MON=@v1_SUPPLY_MON
							,SUPPLY_TUE=@v1_SUPPLY_TUE,SUPPLY_WED=@v1_SUPPLY_WED,SUPPLY_THU=@v1_SUPPLY_THU,SUPPLY_FRI=@v1_SUPPLY_FRI
							,SUPPLY_SAT=@v1_SUPPLY_SAT ,SUPPLY_SPL1=@v1_SUPPLY_SPL1,SUPPLY_SPL2=@v1_SUPPLY_SPL2
							,SP_SUPPLY_MON1=@v1_SP_SUPPLY_MON1,SP_SUPPLY_TUE1=@v1_SP_SUPPLY_TUE1,SP_SUPPLY_WED1=@v1_SP_SUPPLY_WED1
							,SP_SUPPLY_THU1=@v1_SP_SUPPLY_THU1,SP_SUPPLY_FRI1=@v1_SP_SUPPLY_FRI1,SP_SUPPLY_SAT1=@v1_SP_SUPPLY_SAT1
							,SP_SUPPLY_SUN1=@v1_SP_SUPPLY_SUN1,SP_SUPPLY_MON2=@v1_SP_SUPPLY_MON2,SP_SUPPLY_TUE2=@v1_SP_SUPPLY_TUE2
							,SP_SUPPLY_WED2=@v1_SP_SUPPLY_WED2,SP_SUPPLY_THU2=@v1_SP_SUPPLY_THU2,SP_SUPPLY_FRI2=@v1_SP_SUPPLY_FRI2
							,SP_SUPPLY_SAT2=@v1_SP_SUPPLY_SAT2,SP_SUPPLY_SUN2=@v1_SP_SUPPLY_SUN2
							 where comp_code=@pcomp_code and unit=@punit_code and publ=@ppubl_to and edtn=@psubedtn_to  and AGCD=@v1_AGCD and DPCD=@v1_DPCD
						end
						else
						begin
							 
							 set @v_str =' update CIR_SUPPLY set ' + @psupplytype_to + ' =(select CAST(isnull('+@psupplytype_from+',0) as varchar)  from CIR_SUPPLY where comp_code='''+@pcomp_code+''' and unit='''+@punit_code+''' and publ='''+@ppubl_from+''' and edtn='''+@psubedtn_from+'''  and AGCD='''+@v1_AGCD+''' and DPCD='''+@v1_DPCD+''' ) 
							 where comp_code='''+@pcomp_code+''' and unit='''+@punit_code+''' and publ='''+@ppubl_to+''' and edtn='''+@psubedtn_to+'''  and AGCD='''+@v1_AGCD+''' and DPCD='''+@v1_DPCD+'''  ' 
							 print(@v_str)
							 exec(@v_str)							
							 
						end	 
					end
			 end
			 else -- 'P'
			 begin
					if ISNULL(@psupply,0) !=0
					begin
						if isnull(@pextra1,'A') ='A'
						begin
							update CIR_SUPPLY set BASE_SUPPLY=@v1_BASE_SUPPLY+((@v1_BASE_SUPPLY*@psupply)/100),SUPPLY_SUN=@v1_SUPPLY_SUN+((@v1_SUPPLY_SUN*@psupply)/100),SUPPLY_MON=@v1_SUPPLY_MON+((@v1_SUPPLY_MON*@psupply)/100)
							,SUPPLY_TUE=@v1_SUPPLY_TUE+((@v1_SUPPLY_TUE*@psupply)/100),SUPPLY_WED=@v1_SUPPLY_WED+((@v1_SUPPLY_WED*@psupply)/100),SUPPLY_THU=@v1_SUPPLY_THU+((@v1_SUPPLY_THU*@psupply)/100),SUPPLY_FRI=@v1_SUPPLY_FRI+((@v1_SUPPLY_FRI*@psupply)/100)
							,SUPPLY_SAT=@v1_SUPPLY_SAT+((@v1_SUPPLY_SAT*@psupply)/100) ,SUPPLY_SPL1=@v1_SUPPLY_SPL1+((@v1_SUPPLY_SPL1*@psupply)/100),SUPPLY_SPL2=@v1_SUPPLY_SPL2+((@v1_SUPPLY_SPL2*@psupply)/100)
							,SP_SUPPLY_MON1=@v1_SP_SUPPLY_MON1+((@v1_SP_SUPPLY_MON1*@psupply)/100),SP_SUPPLY_TUE1=@v1_SP_SUPPLY_TUE1+((@v1_SP_SUPPLY_TUE1*@psupply)/100),SP_SUPPLY_WED1=@v1_SP_SUPPLY_WED1+((@v1_SP_SUPPLY_WED1*@psupply)/100)
							,SP_SUPPLY_THU1=@v1_SP_SUPPLY_THU1+((@v1_SP_SUPPLY_THU1*@psupply)/100),SP_SUPPLY_FRI1=@v1_SP_SUPPLY_FRI1+((@v1_SP_SUPPLY_FRI1*@psupply)/100),SP_SUPPLY_SAT1=@v1_SP_SUPPLY_SAT1+((@v1_SP_SUPPLY_SAT1*@psupply)/100)
							,SP_SUPPLY_SUN1=@v1_SP_SUPPLY_SUN1+((@v1_SP_SUPPLY_SUN1*@psupply)/100),SP_SUPPLY_MON2=@v1_SP_SUPPLY_MON2+((@v1_SP_SUPPLY_MON2*@psupply)/100),SP_SUPPLY_TUE2=@v1_SP_SUPPLY_TUE2+((@v1_SP_SUPPLY_TUE2*@psupply)/100)
							,SP_SUPPLY_WED2=@v1_SP_SUPPLY_WED2+((@v1_SP_SUPPLY_WED2*@psupply)/100),SP_SUPPLY_THU2=@v1_SP_SUPPLY_THU2+((@v1_SP_SUPPLY_THU2*@psupply)/100),SP_SUPPLY_FRI2=@v1_SP_SUPPLY_FRI2+((@v1_SP_SUPPLY_FRI2*@psupply)/100)
							,SP_SUPPLY_SAT2=@v1_SP_SUPPLY_SAT2+((@v1_SP_SUPPLY_SAT2*@psupply)/100),SP_SUPPLY_SUN2=@v1_SP_SUPPLY_SUN2+((@v1_SP_SUPPLY_SUN2*@psupply)/100)
							 where comp_code=@pcomp_code and unit=@punit_code and publ=@ppubl_to and edtn=@psubedtn_to   and AGCD=@v1_AGCD and DPCD=@v1_DPCD
						end
						else
						begin
							 /*
							 set @v_str =' update CIR_SUPPLY set ' + @psupplytype_to + ' =(select '+ CAST(isnull(@psupplytype_from,0)  + ( ( isnull(@psupplytype_from,0) * isnull(@psupply,0) )/100 ) AS VARCHAR)+' from CIR_SUPPLY where comp_code='''+@pcomp_code+''' and unit='''+@punit_code+''' and publ='''+@ppubl_from+''' and edtn='''+@psubedtn_from+''' ) 
							 where comp_code='''+@pcomp_code+''' and unit='''+@punit_code+''' and publ='''+@ppubl_to+''' and edtn='''+@psubedtn_to+'''   and AGCD='''+@v1_AGCD+''' and DPCD='''+@v1_DPCD+'''   ' 
							 */
							 
							 set @v_str =' update CIR_SUPPLY set ' + @psupplytype_to + ' =(select CAST(isnull('+@psupplytype_from+',0) as varchar) + ( ( isnull('+@psupplytype_from+',0) * isnull('+cast(@psupply as varchar)+',0) )/100 )  from CIR_SUPPLY where comp_code='''+@pcomp_code+''' and unit='''+@punit_code+''' and publ='''+@ppubl_from+''' and edtn='''+@psubedtn_from+'''  and AGCD='''+@v1_AGCD+''' and DPCD='''+@v1_DPCD+''' ) 
							 where comp_code='''+@pcomp_code+''' and unit='''+@punit_code+''' and publ='''+@ppubl_to+''' and edtn='''+@psubedtn_to+'''  and AGCD='''+@v1_AGCD+''' and DPCD='''+@v1_DPCD+'''  ' 
							 
							 print(@v_str)
							 exec(@v_str)							
							 
						end
					end
					else
					begin
						if isnull(@pextra1,'A') ='A'
						begin
							update CIR_SUPPLY set BASE_SUPPLY=@v1_BASE_SUPPLY,SUPPLY_SUN=@v1_SUPPLY_SUN,SUPPLY_MON=@v1_SUPPLY_MON
							,SUPPLY_TUE=@v1_SUPPLY_TUE,SUPPLY_WED=@v1_SUPPLY_WED,SUPPLY_THU=@v1_SUPPLY_THU,SUPPLY_FRI=@v1_SUPPLY_FRI
							,SUPPLY_SAT=@v1_SUPPLY_SAT,SUPPLY_SPL1=@v1_SUPPLY_SPL1,SUPPLY_SPL2=@v1_SUPPLY_SPL2
							,SP_SUPPLY_MON1=@v1_SP_SUPPLY_MON1,SP_SUPPLY_TUE1=@v1_SP_SUPPLY_TUE1,SP_SUPPLY_WED1=@v1_SP_SUPPLY_WED1
							,SP_SUPPLY_THU1=@v1_SP_SUPPLY_THU1,SP_SUPPLY_FRI1=@v1_SP_SUPPLY_FRI1,SP_SUPPLY_SAT1=@v1_SP_SUPPLY_SAT1
							,SP_SUPPLY_SUN1=@v1_SP_SUPPLY_SUN1,SP_SUPPLY_MON2=@v1_SP_SUPPLY_MON2,SP_SUPPLY_TUE2=@v1_SP_SUPPLY_TUE2
							,SP_SUPPLY_WED2=@v1_SP_SUPPLY_WED2,SP_SUPPLY_THU2=@v1_SP_SUPPLY_THU2,SP_SUPPLY_FRI2=@v1_SP_SUPPLY_FRI2
							,SP_SUPPLY_SAT2=@v1_SP_SUPPLY_SAT2,SP_SUPPLY_SUN2=@v1_SP_SUPPLY_SUN2
							 where comp_code=@pcomp_code and unit=@punit_code and publ=@ppubl_to and edtn=@psubedtn_to   and AGCD=@v1_AGCD and DPCD=@v1_DPCD
						end
						else
						begin
							 /*
							 set @v_str =' update CIR_SUPPLY set ' + @psupplytype_to + ' =(select '+ CAST(isnull(@psupplytype_from,0)  + ( ( isnull(@psupplytype_from,0) * isnull(@psupply,0) )/100 ) AS VARCHAR)+' from CIR_SUPPLY where comp_code='''+@pcomp_code+''' and unit='''+@punit_code+''' and publ='''+@ppubl_from+''' and edtn='''+@psubedtn_from+''' ) 
							 where comp_code='''+@pcomp_code+''' and unit='''+@punit_code+''' and publ='''+@ppubl_to+''' and edtn='''+@psubedtn_to+'''   and AGCD='''+@v1_AGCD+''' and DPCD='''+@v1_DPCD+'''   ' 
							 */
							 
							 set @v_str =' update CIR_SUPPLY set ' + @psupplytype_to + ' =(select CAST(isnull('+@psupplytype_from+',0) as varchar)   from CIR_SUPPLY where comp_code='''+@pcomp_code+''' and unit='''+@punit_code+''' and publ='''+@ppubl_from+''' and edtn='''+@psubedtn_from+'''  and AGCD='''+@v1_AGCD+''' and DPCD='''+@v1_DPCD+''' ) 
							 where comp_code='''+@pcomp_code+''' and unit='''+@punit_code+''' and publ='''+@ppubl_to+''' and edtn='''+@psubedtn_to+'''  and AGCD='''+@v1_AGCD+''' and DPCD='''+@v1_DPCD+'''  ' 
							 
							 print(@v_str)
							 exec(@v_str)							
							 
						end
					end
			 
			 end      


		fetch next from c1 into @v1_COMP_CODE,@v1_UNIT,@v1_AGCD,@v1_DPCD,@v1_PUBL,@v1_EDTN,@v1_SUPPLY_TYPE_CODE,@v1_BASE_SUPPLY
		,@v1_SUPPLY_SUN,@v1_SUPPLY_MON,@v1_SUPPLY_TUE,@v1_SUPPLY_WED,@v1_SUPPLY_THU,@v1_SUPPLY_FRI,@v1_SUPPLY_SAT,@v1_SUPPLY_SPL1,@v1_SUPPLY_SPL2
		,@v1_SP_SUPPLY_MON1,@v1_SP_SUPPLY_TUE1,@v1_SP_SUPPLY_WED1,@v1_SP_SUPPLY_THU1,@v1_SP_SUPPLY_FRI1,@v1_SP_SUPPLY_SAT1,@v1_SP_SUPPLY_SUN1
		,@v1_SP_SUPPLY_MON2,@v1_SP_SUPPLY_TUE2,@v1_SP_SUPPLY_WED2,@v1_SP_SUPPLY_THU2,@v1_SP_SUPPLY_FRI2,@v1_SP_SUPPLY_SAT2,@v1_SP_SUPPLY_SUN2
		end
	close c1
	deallocate c1

*************************************************end*******************************

****************************add by Deepika 19/01/2013 *********************************




ALTER PROCEDURE [dbo].[cir_unsold_credit_note_cir_notapproval_list_p]
    @pcomp_code    as varchar(50),
    @punit_code    as varchar(50),
    @pdoc_type     As varchar(50),
    @pdateformat   as varchar(50),
    @pextra1       as varchar(50),
    @pextra2       As varchar(50),
	@pextra3       as varchar(50), -- for receipt no
	@pextra4       as varchar(50), --Unsold base of Supdate and Publication
	@pextra5       as varchar(50) 
As
Begin
If upper(@pextra4)='Y' Begin

    If upper(@pextra2)='D' Begin
        SELECT DISTINCT H.RECPTDT RECPTDT,H.AGCD AGCD,H.DPCD DPCD,DBO.CIR_GET_AGENCY(H.COMP_CODE,H.UNIT_CODE,H.AGCD,H.DPCD) AGENCY_NAME,
        DBO.CIR_GET_AGENCY_CITY(H.COMP_CODE,H.UNIT_CODE,H.AGCD,H.DPCD) CITY_NAME,H.ENTRYDT ENTRYDT,H.FRDT FRDT,H.TODT TODT,
        H.SUP_AGCD SUP_AGCD,H.SUP_DPCD SUP_DPCD,M.AG_NAME SUP_AGENCY, DBO.CIR_GET_CITY(H.COMP_CODE,M.CITY_CODE) SUP_CITY_NAME
        from cir_unsold_hdr_dis h,cir_agmast_dis m
        where h.comp_code=m.comp_code and h.comp_code=@pcomp_code and h.unit_code=m.unit and h.unit_code=@punit_code and h.doctype=@pdoc_type and
        h.sup_agcd=m.agcd and h.sup_dpcd=m.dpcd and (upper(m.ag_name) like upper(@pextra1)+'%' or @pextra1 is null or @pextra1='') and (h.app_userid is null or h.app_userid='')
		and (H.RECPTNO=@pextra3 or @pextra3='' or @pextra3 is null)
        order by  RECPTDT,agency_name
    End
    Else Begin
        SELECT DISTINCT H.RECPTDT RECPTDT,H.AGCD AGCD,H.DPCD DPCD,DBO.CIR_GET_AGENCY(H.COMP_CODE,H.UNIT_CODE,H.AGCD,H.DPCD) AGENCY_NAME,
        DBO.CIR_GET_AGENCY_CITY(H.COMP_CODE,H.UNIT_CODE,H.AGCD,H.DPCD) CITY_NAME,H.ENTRYDT ENTRYDT,H.FRDT FRDT,H.TODT TODT,
        H.SUP_AGCD SUP_AGCD,H.SUP_DPCD SUP_DPCD,M.AG_NAME SUP_AGENCY, DBO.CIR_GET_CITY(H.COMP_CODE,M.CITY_CODE) SUP_CITY_NAME
        from cir_unsold_hdr h,cir_agmast m
        where h.comp_code=m.comp_code and h.comp_code=@pcomp_code and h.unit_code=m.unit and h.unit_code=@punit_code and h.doctype=@pdoc_type and
        h.sup_agcd=m.agcd and h.sup_dpcd=m.dpcd and (upper(m.ag_name) like upper(@pextra1)+'%' or @pextra1 is null or @pextra1='') and (h.app_userid is null or h.app_userid='')
		and (H.RECPTNO=@pextra3 or @pextra3='' or @pextra3 is null)
        order by RECPTDT,agency_name
      End
      
      end 
       Else Begin
        If upper(@pextra2)='D' Begin
        SELECT DISTINCT H.RECPTNO RECPTNO,H.RECPTDT RECPTDT,H.AGCD AGCD,H.DPCD DPCD,DBO.CIR_GET_AGENCY(H.COMP_CODE,H.UNIT_CODE,H.AGCD,H.DPCD) AGENCY_NAME,
        DBO.CIR_GET_AGENCY_CITY(H.COMP_CODE,H.UNIT_CODE,H.AGCD,H.DPCD) CITY_NAME,H.PUBL PUBL,DBO.CIR_GET_PUBL_NAME(H.COMP_CODE,H.PUBL) PUBL_NAME,H.EDTN EDTN,
        DBO.CIR_GET_EDTN_NAME(H.COMP_CODE,H.EDTN) EDTN_NAME,H.ENTRYDT ENTRYDT,H.FRDT FRDT,H.TODT TODT,
        H.SUP_AGCD SUP_AGCD,H.SUP_DPCD SUP_DPCD,M.AG_NAME SUP_AGENCY, DBO.CIR_GET_CITY(H.COMP_CODE,M.CITY_CODE) SUP_CITY_NAME
        from cir_unsold_hdr_dis h,cir_agmast_dis m
        where h.comp_code=m.comp_code and h.comp_code=@pcomp_code and h.unit_code=m.unit and h.unit_code=@punit_code and h.doctype=@pdoc_type and
        h.sup_agcd=m.agcd and h.sup_dpcd=m.dpcd and (upper(m.ag_name) like upper(@pextra1)+'%' or @pextra1 is null or @pextra1='') and (h.app_userid is null or h.app_userid='')
		and (H.RECPTNO=@pextra3 or @pextra3='' or @pextra3 is null)
        order by recptdt,recptno,agency_name
    End
    Else Begin
        SELECT DISTINCT H.RECPTNO RECPTNO,H.RECPTDT RECPTDT,H.AGCD AGCD,H.DPCD DPCD,DBO.CIR_GET_AGENCY(H.COMP_CODE,H.UNIT_CODE,H.AGCD,H.DPCD) AGENCY_NAME,
        DBO.CIR_GET_AGENCY_CITY(H.COMP_CODE,H.UNIT_CODE,H.AGCD,H.DPCD) CITY_NAME,H.PUBL PUBL,DBO.CIR_GET_PUBL_NAME(H.COMP_CODE,H.PUBL) PUBL_NAME,H.EDTN EDTN,
        DBO.CIR_GET_EDTN_NAME(H.COMP_CODE,H.EDTN) EDTN_NAME,H.ENTRYDT ENTRYDT,H.FRDT FRDT,H.TODT TODT,
        H.SUP_AGCD SUP_AGCD,H.SUP_DPCD SUP_DPCD,M.AG_NAME SUP_AGENCY, DBO.CIR_GET_CITY(H.COMP_CODE,M.CITY_CODE) SUP_CITY_NAME
        from cir_unsold_hdr h,cir_agmast m
        where h.comp_code=m.comp_code and h.comp_code=@pcomp_code and h.unit_code=m.unit and h.unit_code=@punit_code and h.doctype=@pdoc_type and
        h.sup_agcd=m.agcd and h.sup_dpcd=m.dpcd and (upper(m.ag_name) like upper(@pextra1)+'%' or @pextra1 is null or @pextra1='') and (h.app_userid is null or h.app_userid='')
		and (H.RECPTNO=@pextra3 or @pextra3='' or @pextra3 is null)
        order by recptdt,recptno,agency_name
      End
      
      end
end


/////////////////////////////////////////////////////////////////////


ALTER PROCEDURE [dbo].[cir_unsold_credit_note_cir_notapproval_unsold_p]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@pdoc_type                                VARCHAR(20) ,
	@precptno                                 VARCHAR(20) ,
	@pagcd_code                               VARCHAR(20) ,
	@pdpcd_code                               VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(40) ,
	@pextra2                                  VARCHAR(40) ,
	@pextra3                                  VARCHAR(40) ,--Unsold base of Supdate and Publication
	@pextra4                                  VARCHAR(40) ,
	@pextra5                                  VARCHAR(40) 
	
	
AS 
Begin

if UPPER(@pextra3)='Y' Begin

	if UPPER(@pextra2)='D' Begin
		SELECT * FROM  cir_unsold_dtl_dis
		WHERE comp_code  = @pcomp_code AND unit_code  = @punit_code
		 AND doctype  = @pdoc_type AND (recptno  = @precptno OR @precptno='' OR @precptno=NULL)
		 AND agcd  = @pagcd_code AND	dpcd  = @pdpcd_code
		 AND APP_USERID=''
		ORDER BY recptdt, recptno, supdate 
	End
	Else Begin
		SELECT *,cast(round((RETURN_PER*SUPPLY_COPY)/100,0) as int) as RETURNABLE FROM  cir_unsold_dtl 
		WHERE comp_code  = @pcomp_code AND unit_code  = @punit_code
		 AND doctype  = @pdoc_type AND (recptno  = @precptno OR @precptno='' OR @precptno=NULL)
		 AND (agcd  = @pagcd_code or @pagcd_code='' or @pagcd_code is null) 
		 AND (dpcd  = @pdpcd_code or @pdpcd_code='' or @pdpcd_code is null)
		 AND APP_USERID=''
		ORDER BY recptdt,recptno,supdate 
	End
	end
	else Begin
	if UPPER(@pextra2)='D' Begin
		SELECT * FROM  cir_unsold_dtl_dis
		WHERE comp_code  = @pcomp_code AND unit_code  = @punit_code
		 AND doctype  = @pdoc_type AND recptno  = @precptno 
		 AND agcd  = @pagcd_code AND	dpcd  = @pdpcd_code
		ORDER BY recptdt, recptno, supdate 
	End
	Else Begin
		SELECT *,cast(round((RETURN_PER*SUPPLY_COPY)/100,0) as int) as RETURNABLE FROM  cir_unsold_dtl 
		WHERE comp_code  = @pcomp_code AND unit_code  = @punit_code
		 AND doctype  = @pdoc_type AND recptno  = @precptno 
		 --AND (agcd  = @pagcd_code or @pagcd_code='' or @pagcd_code is null) 
		 --AND (dpcd  = @pdpcd_code or @pdpcd_code='' or @pdpcd_code is null)
		 
		ORDER BY recptdt,recptno,supdate 
	End
	end
End


*****************************************************end**************************************


create procedure [dbo].[cir_agent_comm_process] 
(@pcomp_code   varchar(20),
 @punit_code   varchar(20),
 @pfrdate      datetime,
 @ptodate      datetime,
 @pagcd        varchar(20),
 @pdpcd        varchar(20),
 @pdateformate varchar(20),
 @pextra1      varchar(20),
 @pextra2      varchar(20),
 @pextra3      varchar(20),
 @pextra4      varchar(20),
 @pextra5      varchar(20),
 @pextra6      varchar(20),
 @pextra7      varchar(20),
 @pextra8      varchar(20),
 @pextra9      varchar(20),
 @pextra10     varchar(20)) as
 Begin

    --exec cir_agent_comm_process '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''

		 select x.comp_code,x.unit_code,x.publ,x.edtn,x.agcd,x.dpcd,
		        dbo.cir_get_agency(x.comp_code,x.unit_code,x.agcd,'0001') as agent_name,
				cir_agmast.ag_name as outlet_name,sum(x.delivery) delivery,sum(x.unsold) unsold,sum(x.delivery-x.unsold) sale,
				round((100*sum(x.unsold)/sum(x.delivery)),2) unsold_per, 
				replace(isnull(cir_agmast.old_agency,'??'),'','##') old_agency_code from
		(select s.comp_code,s.unit_code,s.publ,s.edtn,s.agcd,s.dpcd,s.supdate,sum(s.sup_copy) delivery,
		(select isnull(sum(isnull(u.short_recpt,0)+isnull(u.late_recpt,0)+isnull(u.bnr,0)+isnull(u.unsold,0)),0) unsold from cir_unsold_dtl u
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
		  and isnull(cir_agmast.to_bill,'N') = 'Y'
		group by x.comp_code,x.unit_code,x.publ,x.edtn,x.agcd,x.dpcd,cir_agmast.ag_name, cir_agmast.old_agency
		having sum(x.delivery)>0
		order by x.comp_code,x.unit_code,x.publ,x.edtn,x.agcd,x.dpcd

 End

create procedure [dbo].[cir_agent_net_sale_Detail]

(

@pcomp_code varchar(20),

@punit_code varchar(20),

@pfrdate datetime,

@ptodate datetime,

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

(select isnull(sum(isnull(u.short_recpt,0)+isnull(u.late_recpt,0)+isnull(u.bnr,0)+isnull(u.unsold,0)),0) unsold from cir_unsold_dtl u

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

End







 
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
	@pextra12           VARCHAR(40),
	@pextra13           VARCHAR(40),
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
		set @vquery='select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,
		             p.publ_name /*dbo.cir_get_publ_name(d.comp_code,d.publ)*/ PUBL_NAME,
					 d.edtn,
					 e.edtn_name /*dbo.cir_get_edtn_name(d.comp_code,d.edtn)*/ EDTN_NAME,
					 d.route_code ROUTE_CODE,
					 r.route_name/*dbo.cir_get_route_name(d.comp_code,d.unit_code,d.route_code)*/ ROUTE_NAME,
					 d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
		substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",dbo.cir_get_city(d.comp_code,m.city_code) "CITY NAME",
		isnull(dbo.CIR_GET_NAME_CIR_CITY(d.comp_code,m.city_code,2,null,null,null),''NA'') "CITY ONAME", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) "DROP POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
		,dbo.cir_get_mode_name(d.comp_code,d.unit_code+d.route_code) as "MODE_NAME"
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p, cir_route_mast r
		where m.comp_code=d.comp_code 
		  and m.comp_code=e.comp_code 
		  and m.comp_code=c.comp_code 
		  and m.comp_code=p.comp_code 
		  and p.comp_code=r.comp_code
		  and d.comp_code='+''''+@pcomp_code+''''+' 
		  and m.unit=d.unit_code 
		  and d.unit_code=r.unit 
		  and d.route_code=r.route_code
		  and d.unit_code='''+@punit_code+''' 
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
		group by d.comp_code,d.unit_code,d.publ,p.publ_name,d.edtn,e.edtn_name,d.route_code,r.route_seq,r.route_name,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code 
		order by d.comp_code,d.unit_code,d.publ,d.edtn,r.route_seq,d.route_code,d.agcd,d.dpcd'
		    
		print @vquery 
		EXEC (@vquery)
	end
	if @pextra8='2' 
	Begin----for  branch
		set @vquery='select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.branch_code BRANCH_CODE,dbo.cir_get_branch(d.comp_code,m.branch_code) BRANCH_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
		substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",dbo.cir_get_city(d.comp_code,m.city_code) "CITY NAME",
		isnull(dbo.CIR_GET_NAME_CIR_CITY(d.comp_code,m.city_code,2,null,null,null),''NA'') "CITY ONAME", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) "DROP POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
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
		group by d.comp_code,d.unit_code,d.publ,d.edtn,m.branch_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code 
		order by d.comp_code,d.unit_code,d.publ,d.edtn,branch_name,d.agcd,d.dpcd'

		print @vquery 
		EXEC (@vquery)
	end

	if @pextra8='3' 
	Begin----for  zone
		set @vquery='select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,c.zone_code ZONE_CODE,
		dbo.cir_get_zone_name(d.comp_code,c.zone_code) ZONE_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
		substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",dbo.cir_get_city(d.comp_code,m.city_code) "CITY NAME",
		isnull(dbo.CIR_GET_NAME_CIR_CITY(d.comp_code,m.city_code,2,null,null,null),''NA'') "CITY ONAME", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) "DROP POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
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
		group by d.comp_code,d.unit_code,d.publ,d.edtn,c.zone_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code 
		order by d.comp_code,d.unit_code,d.publ,d.edtn,zone_code,d.agcd,d.dpcd'
		    
		print @vquery 
		EXEC (@vquery)
	end

	if @pextra8='4' 
	Begin----for  region
		set @vquery='select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,c.region_code REGION_CODE,dbo.cir_get_region_name(d.comp_code,c.region_code) REGION_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
		substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",dbo.cir_get_city(d.comp_code,m.city_code) "CITY NAME",
		isnull(dbo.CIR_GET_NAME_CIR_CITY(d.comp_code,m.city_code,2,null,null,null),''NA'') "CITY ONAME", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) "DROP POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
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
		group by d.comp_code,d.unit_code,d.publ,d.edtn,c.region_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code 
		order by d.comp_code,d.unit_code,d.publ,d.edtn,c.region_code,d.agcd,d.dpcd'
		    
		print @vquery 
		EXEC (@vquery)
	end

	if @pextra8='5' 
	Begin----for  district
		set @vquery='select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.dist_code DIST_CODE,dbo.cir_get_name_cir_district(d.comp_code,m.dist_code,''1'',null,null,null) DIST_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
		substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",dbo.cir_get_city(d.comp_code,m.city_code) "CITY NAME",
		isnull(dbo.CIR_GET_NAME_CIR_CITY(d.comp_code,m.city_code,2,null,null,null),''NA'') "CITY ONAME", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) "DROP POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
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
		group by d.comp_code,d.unit_code,d.publ,d.edtn,m.dist_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code order by d.comp_code,d.unit_code,d.publ,d.edtn,dist_code,d.agcd,d.dpcd'
		    
		print @vquery 
		EXEC (@vquery)
	end

	if @pextra8='6' 
	Begin----for Taluka
		set @vquery='select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.tehsil_taluka TALUKA_CODE,dbo.cir_get_taluka(d.comp_code,m.tehsil_taluka) TALUKA_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
		substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",dbo.cir_get_city(d.comp_code,m.city_code) "CITY NAME",
		isnull(dbo.CIR_GET_NAME_CIR_CITY(d.comp_code,m.city_code,2,null,null,null),''NA'') "CITY ONAME", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) "DROP POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
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
		group by d.comp_code,d.unit_code,d.publ,d.edtn,m.tehsil_taluka,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code order by d.comp_code,d.unit_code,d.publ,d.edtn,taluka_code,d.agcd,d.dpcd'
		    
		print @vquery 
		EXEC (@vquery)
	end
	if @pextra8='7' 
	Begin----for State
		set @vquery='select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.state_code STATE_CODE,dbo.cir_get_state1(d.comp_code,m.state_code) STATE_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
		substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",c.city_name "CITY NAME",
		c.city_oname "CITY ONAME", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) "DROP POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
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
		group by d.comp_code,d.unit_code,d.publ,d.edtn,m.state_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code,c.city_name,c.city_Oname order by d.comp_code,d.unit_code,d.publ,d.edtn,m.state_code,d.agcd,d.dpcd'
		    
		print @vquery 
		EXEC (@vquery)
	end

	if @pextra8='8' 
	Begin----for Executive
		set @vquery='select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.executive_code EXECUTIVE_CODE,dbo.cir_get_executive(d.comp_code,m.executive_code) EXECUTIVE_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
		substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",c.city_name "CITY NAME",
		c.city_oname "CITY ONAME", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) "DROP POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
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
		group by d.comp_code,d.unit_code,d.publ,d.edtn,m.executive_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code,c.city_name,c.city_Oname order by d.comp_code,d.unit_code,d.publ,d.edtn,m.executive_code,d.agcd,d.dpcd'
		    
		print @vquery 
		EXEC (@vquery)
	end
		SET @vquery1  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
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
		group by d.comp_code,d.unit_code order by d.comp_code,d.unit_code'
		print @vquery1
		EXEC (@vquery1)
			
	if @pextra8='1' 
	Begin--for route
		SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,
		                  p.publ_name /*dbo.cir_get_publ_name(d.comp_code,d.publ)*/ PUBL_NAME,
						  d.edtn,
						  e.edtn_name /*dbo.cir_get_edtn_name(d.comp_code,d.edtn)*/ EDTN_NAME,
						  d.route_code ROUTE_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p,cir_route_mast r
		where m.comp_code=d.comp_code 
		  and m.comp_code=e.comp_code 
		  and m.comp_code=c.comp_code 
		  and m.comp_code=p.comp_code 
		  and d.comp_code=r.comp_code 
		  and d.comp_code='+''''+@pcomp_code+''''+' 
		  and m.unit=d.unit_code 
		  and d.unit_code=r.unit 
		  and d.route_code=r.route_code
		  and d.unit_code='''+@punit_code+''' 
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
		group by d.comp_code,d.unit_code,d.publ,p.publ_name,d.edtn,e.edtn_name,d.route_code,r.route_seq 
		order by d.comp_code,d.unit_code,d.publ,d.edtn,r.route_seq,d.route_code'
		print @vquery2
		EXEC (@vquery2)
	end

	if @pextra8='2' 
	Begin--for branch
		SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.branch_code BRANCH_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
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
		group by d.comp_code,d.unit_code,d.publ,d.edtn,m.branch_code order by d.comp_code,d.unit_code,d.publ,d.edtn,m.branch_code'
		print @vquery2
		EXEC (@vquery2)
	end

	if @pextra8='3' 
	Begin--for Zone
		SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,c.zone_code ZONE_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
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
		group by d.comp_code,d.unit_code,d.publ,d.edtn,c.zone_code order by d.comp_code,d.unit_code,d.publ,d.edtn,c.zone_code'
		print @vquery2
		EXEC (@vquery2)
	end

	if @pextra8='4' 
	Begin--for region
		SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,c.region_code REGION_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
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
		group by d.comp_code,d.unit_code,d.publ,d.edtn,c.region_code order by d.comp_code,d.unit_code,d.publ,d.edtn,c.region_code'
		print @vquery2
		EXEC (@vquery2)
	end

	if @pextra8='5' 
	Begin--for District
		SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.dist_code DIST_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
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
		group by d.comp_code,d.unit_code,d.publ,d.edtn,m.dist_code order by d.comp_code,d.unit_code,d.publ,d.edtn,m.dist_code'
		print @vquery2
		EXEC (@vquery2)
	end

	if @pextra8='6' 
	Begin--for Taluka
		SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.tehsil_taluka TALUKA_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
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
		group by d.comp_code,d.unit_code,d.publ,d.edtn,m.tehsil_taluka order by d.comp_code,d.unit_code,d.publ,d.edtn,m.tehsil_taluka'
		print @vquery2
		EXEC (@vquery2)
	end

	if @pextra8='7' 
	Begin--for state
		SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.state_code STATE_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
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
		group by d.comp_code,d.unit_code,d.publ,d.edtn,m.state_code order by d.comp_code,d.unit_code,d.publ,d.edtn,m.state_code'
		print @vquery2
		EXEC (@vquery2)
	end

	if @pextra8='8' 
	Begin--for executive
		SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.executive_code EXECUTIVE_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
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
		group by d.comp_code,d.unit_code,d.publ,d.edtn,m.executive_code order by d.comp_code,d.unit_code,d.publ,d.edtn,m.executive_code'
		print @vquery2
		EXEC (@vquery2)
	end

		SET @vquery3  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,'+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
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
		group by d.comp_code,d.unit_code,d.publ,d.edtn order by d.comp_code,d.unit_code,d.publ,d.edtn'
		print @vquery3
		EXEC (@vquery3)

		SET @vquery4  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,'+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
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
		group by d.comp_code,d.unit_code,d.publ order by d.comp_code,d.unit_code,d.publ'
		print @vquery4
		EXEC (@vquery4)
end
else
begin
	if @pextra8='1' 
	Begin--for route
	set @vquery='select d.comp_code COMP_CODE,d.unit UNIT_CODE,d.publ PUBL,
	             p.publ_name /*dbo.cir_get_publ_name(d.comp_code,d.publ)*/ PUBL_NAME,
				 d.edtn,
				 e.edtn_name /*dbo.cir_get_edtn_name(d.comp_code,d.edtn)*/ EDTN_NAME,
				 d.route_code ROUTE_CODE,
				 r.route_name /*dbo.cir_get_route_name(d.comp_code,d.unit,d.route_code)*/ ROUTE_NAME,
				 d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
	substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",dbo.cir_get_city(d.comp_code,m.city_code) "CITY NAME",
	isnull(dbo.CIR_GET_NAME_CIR_CITY(d.comp_code,m.city_code,2,null,null,null),''NA'') "CITY ONAME", dbo.cir_get_drop_point_name(d.comp_code,d.unit,m.station_code,1) "DROP POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit,m.station_code,2) "ODROP_POINT"
	, '+@vvar+','+@vvar_sum+' TOTAL 
	,dbo.cir_get_mode_name(d.comp_code,d.unit+d.route_code) as "MODE_NAME"
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p, cir_route_mast r
	where m.comp_code=d.comp_code 
	  and m.comp_code=e.comp_code 
	  and m.comp_code=c.comp_code 
	  and m.comp_code=p.comp_code 
	  and d.comp_code=r.comp_code 
	  and d.comp_code='+''''+@pcomp_code+''''+' 
	  and m.unit=d.unit 
	  and d.unit=r.unit_code
	  and d.route_code=r.route_code
	  and d.unit='''+@punit_code+''' 
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
	group by d.comp_code,d.unit,d.publ,p.publ_name,d.edtn,e.edtn_name,d.route_code,r.route_code,r.route_seq,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code 
	order by d.comp_code,d.unit,d.publ,d.edtn,r.route_seq,d.route_code,d.agcd,d.dpcd'
	    
	print @vquery 
	EXEC (@vquery)
end
if @pextra8='2' 
Begin----for  branch
	set @vquery='select d.comp_code COMP_CODE,d.unit UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.branch_code BRANCH_CODE,dbo.cir_get_branch(d.comp_code,m.branch_code) BRANCH_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
	substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",dbo.cir_get_city(d.comp_code,m.city_code) "CITY NAME",
	isnull(dbo.CIR_GET_NAME_CIR_CITY(d.comp_code,m.city_code,2,null,null,null),''NA'') "CITY ONAME"
	, dbo.cir_get_drop_point_name(d.comp_code,d.unit,m.station_code,1) "DROP POINT"
	, dbo.cir_get_drop_point_name(d.comp_code,d.unit,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and d.unit='''+@punit_code+''' 
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
	group by d.comp_code,d.unit,d.publ,d.edtn,m.branch_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code 
	order by d.comp_code,d.unit,d.publ,d.edtn,branch_name,d.agcd,d.dpcd'

	print @vquery 
	EXEC (@vquery)
end

if @pextra8='3' 
Begin----for  zone
	set @vquery='select d.comp_code COMP_CODE,d.unit UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME
	,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,c.zone_code ZONE_CODE,
	dbo.cir_get_zone_name(d.comp_code,c.zone_code) ZONE_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
	substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",dbo.cir_get_city(d.comp_code,m.city_code) "CITY NAME",
	isnull(dbo.CIR_GET_NAME_CIR_CITY(d.comp_code,m.city_code,2,null,null,null),''NA'') "CITY ONAME"
	, dbo.cir_get_drop_point_name(d.comp_code,d.unit,m.station_code,1) "DROP POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and d.unit='''+@punit_code+''' 
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
	group by d.comp_code,d.unit,d.publ,d.edtn,c.zone_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code 
	order by d.comp_code,d.unit,d.publ,d.edtn,zone_code,d.agcd,d.dpcd'
	    
	print @vquery 
	EXEC (@vquery)
end

if @pextra8='4' 
Begin----for  region
	set @vquery='select d.comp_code COMP_CODE,d.unit UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn
	,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,c.region_code REGION_CODE,dbo.cir_get_region_name(d.comp_code,c.region_code) REGION_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
	substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",dbo.cir_get_city(d.comp_code,m.city_code) "CITY NAME",
	isnull(dbo.CIR_GET_NAME_CIR_CITY(d.comp_code,m.city_code,2,null,null,null),''NA'') "CITY ONAME"
	, dbo.cir_get_drop_point_name(d.comp_code,d.unit,m.station_code,1) "DROP POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and d.unit='''+@punit_code+''' 
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
	group by d.comp_code,d.unit,d.publ,d.edtn,c.region_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code 
	order by d.comp_code,d.unit,d.publ,d.edtn,c.region_code,d.agcd,d.dpcd'
	    
	print @vquery 
	EXEC (@vquery)
end

if @pextra8='5' 
Begin----for  district
	set @vquery='select d.comp_code COMP_CODE,d.unit UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.dist_code DIST_CODE,dbo.cir_get_name_cir_district(d.comp_code,m.dist_code,''1'',null,null,null) DIST_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
	substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",dbo.cir_get_city(d.comp_code,m.city_code) "CITY NAME",
	isnull(dbo.CIR_GET_NAME_CIR_CITY(d.comp_code,m.city_code,2,null,null,null),''NA'') "CITY ONAME"
	, dbo.cir_get_drop_point_name(d.comp_code,d.unit,m.station_code,1) "DROP POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and d.unit='''+@punit_code+''' 
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
	group by d.comp_code,d.unit,d.publ,d.edtn,m.dist_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code order by d.comp_code,d.unit,d.publ,d.edtn,dist_code,d.agcd,d.dpcd'
	    
	print @vquery 
	EXEC (@vquery)
end

if @pextra8='6' 
Begin----for Taluka
	set @vquery='select d.comp_code COMP_CODE,d.unit UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.tehsil_taluka TALUKA_CODE,dbo.cir_get_taluka(d.comp_code,m.tehsil_taluka) TALUKA_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
	substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",dbo.cir_get_city(d.comp_code,m.city_code) "CITY NAME",
	isnull(dbo.CIR_GET_NAME_CIR_CITY(d.comp_code,m.city_code,2,null,null,null),''NA'') "CITY ONAME",
	 dbo.cir_get_drop_point_name(d.comp_code,d.unit,m.station_code,1) "DROP POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and d.unit='''+@punit_code+''' 
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
	group by d.comp_code,d.unit,d.publ,d.edtn,m.tehsil_taluka,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code order by d.comp_code,d.unit,d.publ,d.edtn,taluka_code,d.agcd,d.dpcd'
	    
	print @vquery 
	EXEC (@vquery)
end
if @pextra8='7' 
Begin----for State
	set @vquery='select d.comp_code COMP_CODE,d.unit UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.state_code STATE_CODE,dbo.cir_get_state1(d.comp_code,m.state_code) STATE_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
	substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",c.city_name "CITY NAME",
	c.city_oname "CITY ONAME", dbo.cir_get_drop_point_name(d.comp_code,d.unit,m.station_code,1) "DROP POINT",
	 dbo.cir_get_drop_point_name(d.comp_code,d.unit,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and d.unit='''+@punit_code+''' 
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
	group by d.comp_code,d.unit,d.publ,d.edtn,m.state_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code,c.city_name,c.city_Oname 
	order by d.comp_code,d.unit,d.publ,d.edtn,m.state_code,d.agcd,d.dpcd'
	    
	print @vquery 
	EXEC (@vquery)
end

if @pextra8='8' 
Begin----for Executive
	set @vquery='select d.comp_code COMP_CODE,d.unit UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.executive_code EXECUTIVE_CODE,dbo.cir_get_executive(d.comp_code,m.executive_code) EXECUTIVE_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
	substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",c.city_name "CITY NAME",
	c.city_oname "CITY ONAME", dbo.cir_get_drop_point_name(d.comp_code,d.unit,m.station_code,1) "DROP POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and d.unit='''+@punit_code+''' 
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
	group by d.comp_code,d.unit,d.publ,d.edtn,m.executive_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code,c.city_name,c.city_Oname
	order by d.comp_code,d.unit,d.publ,d.edtn,m.executive_code,d.agcd,d.dpcd'
	    
	print @vquery 
	EXEC (@vquery)
end
	SET @vquery1  = ' select d.comp_code COMP_CODE,d.unit UNIT_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and d.unit='''+@punit_code+''' 
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
	group by d.comp_code,d.unit order by d.comp_code,d.unit_code'
	print @vquery1
	EXEC (@vquery1)
		
if @pextra8='1' 
Begin--for route
	SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit UNIT_CODE,d.publ PUBL,
	                  p.publ_name /*dbo.cir_get_publ_name(d.comp_code,d.publ)*/ PUBL_NAME,
					  d.edtn,
					  e.edtn_name  /*dbo.cir_get_edtn_name(d.comp_code,d.edtn)*/ EDTN_NAME,
					  d.route_code ROUTE_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p, cir_route_mast r
	where m.comp_code=d.comp_code 
	  and m.comp_code=e.comp_code 
	  and m.comp_code=c.comp_code 
	  and m.comp_code=p.comp_code 
	  and p.comp_code=r.comp_code 
	  and d.comp_code='+''''+@pcomp_code+''''+' 
	  and m.unit=d.unit 
	  and d.unit=r.unit_code
	  and d.route_code=r.route_code
	  and d.unit='''+@punit_code+''' 
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
	group by d.comp_code,d.unit,d.publ,p.publ_name,d.edtn,e.edtn_name,d.route_code,r.route_seq
	order by d.comp_code,d.unit_code,d.publ,d.edtn,r._route_seq,d.route_code'
	print @vquery2
	EXEC (@vquery2)
end

if @pextra8='2' 
Begin--for branch
	SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME
	,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.branch_code BRANCH_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and d.unit='''+@punit_code+''' 
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
	group by d.comp_code,d.unit,d.publ,d.edtn,m.branch_code order by d.comp_code,d.unit,d.publ,d.edtn,m.branch_code'
	print @vquery2
	EXEC (@vquery2)
end

if @pextra8='3' 
Begin--for Zone
	SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,c.zone_code ZONE_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and d.unit='''+@punit_code+''' 
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
	group by d.comp_code,d.unit,d.publ,d.edtn,c.zone_code order by d.comp_code,d.unit,d.publ,d.edtn,c.zone_code'
	print @vquery2
	EXEC (@vquery2)
end

if @pextra8='4' 
Begin--for region
	SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,c.region_code REGION_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and d.unit='''+@punit_code+''' 
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
	group by d.comp_code,d.unit,d.publ,d.edtn,c.region_code order by d.comp_code,d.unit,d.publ,d.edtn,c.region_code'
	print @vquery2
	EXEC (@vquery2)
end

if @pextra8='5' 
Begin--for District
	SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.dist_code DIST_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and d.unit='''+@punit_code+''' 
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
	group by d.comp_code,d.unit,d.publ,d.edtn,m.dist_code order by d.comp_code,d.unit,d.publ,d.edtn,m.dist_code'
	print @vquery2
	EXEC (@vquery2)
end

if @pextra8='6' 
Begin--for Taluka
	SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.tehsil_taluka TALUKA_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and d.unit='''+@punit_code+''' 
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
	group by d.comp_code,d.unit,d.publ,d.edtn,m.tehsil_taluka order by d.comp_code,d.unit,d.publ,d.edtn,m.tehsil_taluka'
	print @vquery2
	EXEC (@vquery2)
end

if @pextra8='7' 
Begin--for state
	SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.state_code STATE_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and d.unit='''+@punit_code+''' 
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
	group by d.comp_code,d.unit,d.publ,d.edtn,m.state_code order by d.comp_code,d.unit,d.publ,d.edtn,m.state_code'
	print @vquery2
	EXEC (@vquery2)
end

if @pextra8='8' 
Begin--for executive
	SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.executive_code EXECUTIVE_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and d.unit='''+@punit_code+''' 
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
	group by d.comp_code,d.unit,d.publ,d.edtn,m.executive_code order by d.comp_code,d.unit,d.publ,d.edtn,m.executive_code'
	print @vquery2
	EXEC (@vquery2)
end

	SET @vquery3  = ' select d.comp_code COMP_CODE,d.unit UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,'+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and d.unit='''+@punit_code+''' 
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
	group by d.comp_code,d.unit,d.publ,d.edtn order by d.comp_code,d.unit,d.publ,d.edtn'
	print @vquery3
	EXEC (@vquery3)

	SET @vquery4  = ' select d.comp_code COMP_CODE,d.unit UNIT_CODE,d.publ PUBL,'+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and d.unit='''+@punit_code+''' 
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
	group by d.comp_code,d.unit,d.publ order by d.comp_code,d.unit,d.publ'
	print @vquery4
	EXEC (@vquery4)
end

DEALLOCATE cur_sup_type

END


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
    @pextra2        as varchar(500), --------- it is used for posting and standing order 1/2
    @pextra3        as varchar(500),--------supply posted final and un final  Y/N
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

if @pextra2 = '2' begin
declare cur_edtn cursor for
    select distinct d.publ publ,d.edtn edtn,p.edtn_seq_no edtn_seqno,
    case @plangtype when '1' then substring(p.edition_nick,1,15)
    else substring(p.edtn_name_oth_lang,1,20) end edtn_name
    ,0 sup_rate,p.main_edtn main_edtn
    from cir_route_mast m,cir_supply d ,cir_edtn_mast p ,cir_supply_type_mast k
    where m.comp_code=@pcompcode and m.comp_code=d.comp_code and d.comp_code=p.comp_code and m.unit=d.unit and
    d.comp_code=k.comp_code  and d.supply_type_code=k.sup_ty_code and 
    m.unit=p.unit_code and d.unit = @punitcode and
    --d.supdate >= @vsupdate and d.supdate <=@vsupdate1 and
    m.route_code=d.route_code and (m.route_code=@proute or @proute is null)
    and d.publ=isnull(@ppublcode,d.publ) and
    d.publ=p.publ and d.edtn=p.edtn and k.bill_pay='Y'
    order by publ,main_edtn,edtn_seqno,edtn,sup_rate
    
 end
	else
	begin
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
	end   
print('a')
-- cursor variable for cur_edtn
declare @rec_edtn_publ as varchar(200)
declare @rec_edtn_edtn as varchar(200)
declare @rec_edtn_edtn_seqno as numeric(5)
declare @rec_edtn_edtn_name as varchar(500)
declare @rec_edtn_sup_rate as numeric(14,2)
declare @rec_edtn_main_edtn as varchar(200)
-- end here --

if @pextra2 = '2' begin
OPEN cur_edtn 
    fetch NEXT FROM cur_edtn INTO @rec_edtn_publ , @rec_edtn_edtn,@rec_edtn_edtn_seqno,@rec_edtn_edtn_name,@rec_edtn_sup_rate,@rec_edtn_main_edtn
        WHILE (@@FETCH_STATUS = 0) 
        BEGIN
            if (@vvar is null or @vvar = '') begin 
                set @vvar        ='sum(case edtn when '+''''+@rec_edtn_edtn+''''+' then d.base_supply else 0 end) "'+@rec_edtn_edtn_name+'"';
                set @vvar_sum    ='sum('+'"'+@rec_edtn_edtn_name+'") "'+@rec_edtn_edtn_name+'"';
                set @vvar_sum1   ='sum('+'"'+@rec_edtn_edtn_name+'"';
            end
            else
            begin
                set @vvar        =@vvar+','+'sum(case edtn when '+''''+@rec_edtn_edtn+''''+' then d.base_supply else 0 end) "'+@rec_edtn_edtn_name+'"';
                set @vvar_sum    =@vvar_sum+','+'sum('+'"'+@rec_edtn_edtn_name+'") "'+@rec_edtn_edtn_name+'"';
                set @vvar_sum1   =@vvar_sum1+'+"'+@rec_edtn_edtn_name+'"';
            end
                
                
		fetch NEXT FROM cur_edtn INTO @rec_edtn_publ , @rec_edtn_edtn,@rec_edtn_edtn_seqno,@rec_edtn_edtn_name,@rec_edtn_sup_rate,@rec_edtn_main_edtn
	END     
	close cur_edtn
	DEALLOCATE cur_edtn
end
else
begin
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
end

if @vvar_sum1 is not null or @vvar_sum1 !='' begin
    set @vvar_sum1=@vvar_sum1+') "Total"'
end
print(@vvar)
 
 if @pextra2 = '2' begin
	 if @vvar is null or @vvar ='' begin
		set @v_query='select x.comp_code,x.unit_code,x.route_code,x.route_name from
		               (select d.comp_code,d.unit as unit_code,d.route_code,isnull(m.route_seq,0),
				case '''+@plangtype+''' when ''1'' then substring(m.route_name,1,25)
				else substring(m.route_name_oth_lang,1,25) end route_name 
				from cir_supply d,cir_route_mast m ,cir_supply_type_mast k
				where d.comp_code = m.comp_code and d.unit = m.unit 
				and d.comp_code=k.comp_code  and d.supply_type_code=k.sup_ty_code and d.comp_code = '+''''+@pcompcode+''''+' and
				d.unit = '+''''+@punitcode+''''+' and d.publ = isnull('+''''+@ppublcode+''''+',d.publ) and
				d.route_code = m.route_code  
				/* and d.supdate >= '+''''+cast(@vsupdate as varchar)+''''+' and d.supdate <='+''''+cast(@vsupdate1 as varchar)+''''+'  */
				and k.bill_pay=''Y'' 
				--and (d.final_supply_flag='+''''+@pextra3+''''+' or '+''''+@pextra3+''''+' ='''')
				group by d.comp_code,d.unit,d.route_code,m.route_name,isnull(m.route_seq,0)) x
				group by x.comp_code,x.unit_code,x.route_code,x.route_name,x.route_seq
				order by x.comp_code,x.unit_code,x.route_seq,x.route_code,x.route_name';
	end
	else
	begin        
		set @v_query='select x.comp_code,x.unit_code,x.route_code,x.route_name,'+@vvar_sum+','+@vvar_sum1+' from(
		select d.comp_code,d.unit as unit_code,d.route_code route_code,m.route_seq,
				case '''+@plangtype+''' when ''1'' then substring(m.route_name,1,25) 
				else substring(m.route_name_oth_lang,1,25) end route_name
				,'+@vvar+' from cir_supply d,cir_route_mast m,cir_supply_type_mast k
				where d.comp_code = m.comp_code and d.unit = m.unit 
				and d.comp_code=k.comp_code  and d.supply_type_code=k.sup_ty_code  and d.comp_code = '+''''+@pcompcode+''''+' and
				d.unit = '+''''+@punitcode+''''+' and d.publ = isnull('+''''+@ppublcode+''''+',d.publ) and
				d.route_code = m.route_code  
				/* and d.supdate >= '+''''+cast(@vsupdate as varchar)+''''+' and d.supdate <= '+''''+cast(@vsupdate1 as varchar)+''''+' */
				and k.bill_pay=''Y'' 
				--and (d.final_supply_flag='+''''+@pextra3+''''+' or '+''''+@pextra3+''''+' ='''')
				group by d.comp_code,d.unit,m.route_seq,m.route_name,d.route_code) x
				group by x.comp_code,x.unit_code,x.route_seq,x.route_code,x.route_name
				order by x.comp_code,x.unit_code,x.route_seq,x.route_code,x.route_name';       
	end
end
else
begin
if @vvar is null or @vvar ='' begin
		set @v_query='select x.comp_code,x.unit_code,x.route_code,x.route_name from
		               (select d.comp_code,d.unit_code,d.route_code,m.route_seq,
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
				group by d.comp_code,d.unit_code,d.route_code,m.route_seq,m.route_name) x
				group by x.comp_code,x.unit_code,x.route_code,x.route_seq,x.route_name
				order by x.comp_code,x.unit_code,x.route_code,x.route_seq,x.route_name';
	end
	else
	begin        
		set @v_query='select x.comp_code,x.unit_code,x.route_code,x.route_name,'+@vvar_sum+','+@vvar_sum1+' from
		               (select d.comp_code,d.unit_code,m.route_seq,d.route_code route_code,
				       case '''+@plangtype+''' when ''1'' then substring(m.route_name,1,25) 
				       else substring(m.route_name_oth_lang,1,25) end route_name,
					   '+@vvar+' from cir_dbksup d,cir_route_mast m,cir_supply_type_mast k
				where d.comp_code = m.comp_code 
				  and d.unit_code = m.unit 
				  and d.comp_code=k.comp_code 
				  and d.sup_type_code=k.sup_ty_code 
				  and d.comp_code = '+''''+@pcompcode+''''+' 
				  and d.unit_code = '+''''+@punitcode+''''+' 
				  and d.publ = isnull('+''''+@ppublcode+''''+',d.publ) 
				  and d.route_code = m.route_code 
				  and d.supdate >= '+''''+cast(@vsupdate as varchar)+''''+' 
				  and d.supdate <= '+''''+cast(@vsupdate1 as varchar)+''''+' 
				  and k.bill_pay=''Y'' 
				  and (d.final_supply_flag='+''''+@pextra3+''''+' or '+''''+@pextra3+''''+' ='''')
				group by d.comp_code,d.unit_code,m.route_seq,m.route_name,d.route_code) x
				group by x.comp_code,x.unit_code,x.route_seq,x.route_code,x.route_name
				order by x.comp_code,x.unit_code,x.route_seq,x.route_code,x.route_name';       
	end
end



print(@v_query)
exec(@v_query)  
print('q')
-- for free supply
    set @vvar=null
    set @vvar_sum=null
    set @vvar_sum1=null

if @pextra2 = '2' begin  
	declare cur_edtn_free cursor for
		select distinct d.publ publ,d.edtn edtn,p.edtn_seq_no edtn_seqno,
		case @plangtype when '1' then substring(p.edition_nick,1,15)
		else substring(p.edtn_name_oth_lang,1,20) end edtn_name
		,0 sup_rate,p.main_edtn main_edtn
		from cir_supply_type_mast m,cir_supply d ,cir_edtn_mast p 
		where m.comp_code=@pcompcode and m.comp_code=d.comp_code and d.comp_code=p.comp_code and 
		  d.comp_code=m.comp_code  and d.supply_type_code=m.sup_ty_code and 
		  d.unit=p.unit_code and d.unit = @punitcode and
		  --d.supdate >= @vsupdate and d.supdate <=@vsupdate1 and
		  d.publ=isnull(@ppublcode,d.publ) and
		  d.publ=p.publ and d.edtn=p.edtn and m.bill_pay='N'
		  order by publ,main_edtn,edtn_seqno,edtn,sup_rate
end
else
begin
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
end
-- cursor variable for cur_edtn_free
declare @rec_edtn_free_publ as varchar(200)
declare @rec_edtn_free_edtn as varchar(200)
declare @rec_edtn_free_edtn_seqno as numeric(5)
declare @rec_edtn_free_edtn_name as varchar(500)
declare @rec_edtn_free_sup_rate as numeric(14,2)
declare @rec_edtn_free_main_edtn as varchar(200)
-- end here --

if @pextra2 = '2' begin  
	OPEN cur_edtn_free 
		fetch NEXT FROM cur_edtn_free INTO @rec_edtn_free_publ , @rec_edtn_free_edtn,@rec_edtn_free_edtn_seqno,@rec_edtn_free_edtn_name,@rec_edtn_free_sup_rate,@rec_edtn_free_main_edtn
			WHILE (@@FETCH_STATUS = 0) 
			BEGIN
				if (@vvar is null or @vvar = '') begin 
					set @vvar        ='sum(case edtn when '+''''+@rec_edtn_free_edtn+''''+' then d.base_supply else 0 end) "'+@rec_edtn_free_edtn_name+'"';
					set @vvar_sum    ='sum('+'"'+@rec_edtn_free_edtn_name+'") "'+@rec_edtn_free_edtn_name+'"';
					set @vvar_sum1   ='sum('+'"'+@rec_edtn_free_edtn_name+'"';
				end
				else
				begin
					set @vvar        =@vvar+','+'sum(case edtn when '+''''+@rec_edtn_free_edtn+''''+' then d.base_supply else 0 end) "'+@rec_edtn_free_edtn_name+'"';
					set @vvar_sum    =@vvar_sum+','+'sum('+'"'+@rec_edtn_free_edtn_name+'") "'+@rec_edtn_free_edtn_name+'"';
					set @vvar_sum1   =@vvar_sum1+'+"'+@rec_edtn_free_edtn_name+'"';
				end
	                
	                
		fetch NEXT FROM cur_edtn_free INTO @rec_edtn_free_publ , @rec_edtn_free_edtn,@rec_edtn_free_edtn_seqno,@rec_edtn_free_edtn_name,@rec_edtn_free_sup_rate,@rec_edtn_free_main_edtn
	END     
	close cur_edtn_free
	DEALLOCATE cur_edtn_free
end
else
begin
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

end

if @vvar_sum1 is not null or @vvar_sum1 !='' begin
    set @vvar_sum1=@vvar_sum1+') "Total"'
end


if @pextra2 = '2' begin  
        if @vvar is null or @vvar ='' begin
            set @v_query1='select x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name from
            (select d.comp_code,d.unit as unit_code,m.sup_ty_code,
            substring(m.sup_ty_name,1,25) supply_name
            from cir_supply d,cir_supply_type_mast m
            where d.comp_code = m.comp_code 
            and d.supply_type_code=k.sup_ty_code
            and d.comp_code = '+''''+@pcompcode+''''+' and
            d.unit = '+''''+@punitcode+''''+' and d.publ = isnull('+''''+@ppublcode+''''+',d.publ)             
            /* and d.supdate >= '+''''+cast(@vsupdate as varchar)+''''+' and d.supdate <='+''''+cast(@vsupdate1 as varchar)+''''+' */
            and m.bill_pay=''N'' 
            --and (d.final_supply_flag='+''''+@pextra3+''''+' or '+''''+@pextra3+''''+' ='''')
            group by d.comp_code,d.unit,m.sup_ty_code,m.sup_ty_name) x
            group by x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name
            order by x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name';
        end
        else
        begin
            set @v_query1='select x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name,'+@vvar_sum+','+@vvar_sum1+' from
            (select d.comp_code,d.unit as unit_code,m.sup_ty_code sup_ty_code,
            substring(m.sup_ty_name,1,25) supply_name
            ,'+@vvar+' from cir_supply d,cir_supply_type_mast m
            where d.comp_code = m.comp_code
             and d.supply_type_code=m.sup_ty_code
            and d.comp_code = '+''''+@pcompcode+''''+' and
            d.unit = '+''''+@punitcode+''''+' and d.publ = isnull('+''''+@ppublcode+''''+',d.publ)             
             --and d.supdate >= '+''''+cast(@vsupdate as varchar)+''''+' and d.supdate <= '+''''+cast(@vsupdate1 as varchar)+''''+' 
             and m.bill_pay=''N'' ---and (d.final_supply_flag='+''''+@pextra3+''''+' or '+''''+@pextra3+''''+' = '''')
            group by d.comp_code,d.unit,m.sup_ty_code,m.sup_ty_name) x
            group by x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name
            order by x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name';
        end
end
else
begin
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
end
print(@v_query1)
exec(@v_query1)




 set @vvar=null
    set @vvar_sum=null
    set @vvar_sum1=null


-------------------for edition total

if @pextra2 = '2' begin  
declare cur_edtn_total cursor for
    select distinct d.publ publ,d.edtn edtn,p.edtn_seq_no edtn_seqno,
    case @plangtype when '1' then substring(p.edition_nick,1,15)
    else substring(p.edtn_name_oth_lang,1,20) end edtn_name
    ,0 sup_rate,p.main_edtn main_edtn
    from cir_supply_type_mast m,cir_supply d ,cir_edtn_mast p 
    where m.comp_code=@pcompcode and m.comp_code=d.comp_code and d.comp_code=p.comp_code and 
      d.comp_code=m.comp_code  and d.supply_type_code=m.sup_ty_code and 
      d.unit=p.unit_code and d.unit = @punitcode and      
      d.publ=isnull(@ppublcode,d.publ) and
      d.publ=p.publ and d.edtn=p.edtn 
      order by publ,main_edtn,edtn_seqno,edtn,sup_rate
end
else
begin  
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
end 
-- cursor variable for cur_edtn_free
declare @rec_edtn_total_publ as varchar(200)
declare @rec_edtn_total_edtn as varchar(200)
declare @rec_edtn_total_edtn_seqno as numeric(5)
declare @rec_edtn_total_edtn_name as varchar(500)
declare @rec_edtn_total_sup_rate as numeric(14,2)
declare @rec_edtn_total_main_edtn as varchar(200)
-- end here --
if @pextra2 = '2' begin  
OPEN cur_edtn_total 
    fetch NEXT FROM cur_edtn_total INTO @rec_edtn_total_publ , @rec_edtn_total_edtn,@rec_edtn_total_edtn_seqno,@rec_edtn_total_edtn_name,@rec_edtn_total_sup_rate,@rec_edtn_total_main_edtn
        WHILE (@@FETCH_STATUS = 0) 
        BEGIN
        
        print('Deepika11')
        print (@vvar)
            if (@vvar is null or @vvar = '') begin 
                set @vvar        ='sum(case edtn when '+''''+@rec_edtn_total_edtn+''''+' then d.base_supply else 0 end) "'+@rec_edtn_total_edtn_name+'"';
                set @vvar_sum    ='sum('+'"'+@rec_edtn_total_edtn_name+'") "'+@rec_edtn_total_edtn_name+'"';
                set @vvar_sum1   ='sum('+'"'+@rec_edtn_total_edtn_name+'"';
            end
            else
            begin
                set @vvar        =@vvar+','+'sum(case edtn when '+''''+@rec_edtn_total_edtn+''''+' then d.base_supply else 0 end) "'+@rec_edtn_total_edtn_name+'"';
                set @vvar_sum    =@vvar_sum+','+'sum('+'"'+@rec_edtn_total_edtn_name+'") "'+@rec_edtn_total_edtn_name+'"';
                set @vvar_sum1   =@vvar_sum1+'+"'+@rec_edtn_total_edtn_name+'"';
            end
                
                
    fetch NEXT FROM cur_edtn_total INTO @rec_edtn_total_publ , @rec_edtn_total_edtn,@rec_edtn_total_edtn_seqno,@rec_edtn_total_edtn_name,@rec_edtn_total_sup_rate,@rec_edtn_total_main_edtn
END     
close cur_edtn_total
DEALLOCATE cur_edtn_total
end
else
begin
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
end
if @vvar_sum1 is not null or @vvar_sum1 !='' begin
    set @vvar_sum1=@vvar_sum1+') "Total"'
end

if @pextra2 = '2' begin  
        if @vvar is null or @vvar ='' begin
            set @v_query1='select x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name from
            (select d.comp_code,d.unit as unit_code,null as sup_ty_code, null as supply_name
            from cir_supply d
            where d.comp_code = '+''''+@pcompcode+''''+' and
            d.unit = '+''''+@punitcode+''''+' and d.publ = isnull('+''''+@ppublcode+''''+',d.publ) and            
            group by d.comp_code,d.unit) x
            group by x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name
            order by x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name';
        end
        else
        begin
            set @v_query1='select x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name,'+@vvar_sum+','+@vvar_sum1+' from
            (select d.comp_code,d.unit as unit_code   ,null as sup_ty_code, null as supply_name
            ,'+@vvar+' from cir_supply d,cir_supply_type_mast m
            where d.comp_code = m.comp_code
             and d.supply_type_code=m.sup_ty_code 
            and d.comp_code = '+''''+@pcompcode+''''+' and
            d.unit = '+''''+@punitcode+''''+' and d.publ = isnull('+''''+@ppublcode+''''+',d.publ)  
            group by d.comp_code,d.unit) x
            group by x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name
            order by x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name';
        end
 end
else
begin
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
end
print(@v_query1)
exec(@v_query1)











SET CONCAT_NULL_YIELDS_NULL On



/**agency ledger*****/




ALTER PROCEDURE [dbo].[cir_rep_agency_ledger_cir_agency_ledger_utusan]
    @pcompcode       as varchar(20),
    @punitcode       as varchar(20),
    @pactype         as varchar(20),
    @pbranchcode     as varchar(20),
    @pagency_type    as varchar(20),
    @pagcd           as varchar(20),
    @pdpcd           as varchar(20),
    @pstatecode      as varchar(20),
    @pdistcode       as varchar(20),
    @pcitycode       as varchar(20),
    @ptalukacode     as varchar(20),
    @pfrom_date      as datetime,
    @ptill_date      as datetime,
    @pbilladj_flag   as varchar(20),
    @psortedby       as varchar(20),
    @puserid         as varchar(20),
    @prowbreak       as varchar(20),
    @pdateformat     as varchar(20),
    @pextra1         as varchar(200),--it is use for agency class
    @pextra2         as varchar(200)
As
    declare @v_frdt          datetime;
    declare @v_todt          datetime;
    declare @v_opdate        datetime;
   
    declare @v_opbal         decimal(15,2)
    declare @v_opbal_sec     decimal(15,2)
    declare @v_amt           decimal(15,2)
    declare @v_clbal         decimal(15,2)
    declare @v_runbal        decimal(15,2)
    declare @v_billamt       decimal(15,2)
    declare @v_dbcramt       decimal(15,2)
    declare @v_cramt         decimal(15,2)
    declare @v_dbamt         decimal(15,2)
    declare @v_rec_seqno     int
    declare @v_remark_len    int
    declare @v_divident      int
    declare @v_narration     varchar(1000)
    declare @v_runbal_txt    varchar(20)
	
	
	declare @v1_comp_code		varchar(20)
	declare @v1_unit			varchar(20)
	declare @v1_agcd			varchar(20) 
	declare @v1_dpcd			varchar(20) 
	declare @v1_ag_name			varchar(200) 
	declare @v1_ag_name_oth_lang varchar(200)
	declare @v1_city_code		varchar(20)
	declare @v1_tehsil_taluka	varchar(20)
	declare @v1_dist_code		varchar(20)
	declare @v1_state_code		varchar(20)
    declare @v1_country_code	varchar(20)	
	declare @v1_branch_code		varchar(20)
	
	declare @v1_issue_date		datetime
	declare @v1_product_code	varchar(20)
	declare @v1_quantity		int
	declare @v1_unit_price		numeric(8,3)
	declare @v1_addr1	varchar(200)
	declare @v1_ADDR2	varchar(200)
	declare @v1_ADDR3	varchar(200)
	declare @v1_PIN_CODE	numeric(10)



	declare @v2_comp_code		varchar(20)	
	declare @v2_unit_code		varchar(20)
	declare @v2_agcd			varchar(20)
	declare @v2_dpcd			varchar(20)
	declare @v2_doctype			varchar(20)	
	declare @v2_recptno			varchar(20)
	declare @v2_recptdt			datetime
	declare @v2_amount			decimal(15,2)
	declare @v2_chno			varchar(20)
	declare @v2_chdt			datetime
	declare @v2_chbank			varchar(200)
	declare @v2_reason			varchar(200)
	declare @v2_narration		varchar(2000)
	declare @v2_received_from	varchar(200)
        
Begin
	If @punitcode='' Begin
		set @punitcode=null
	End
	If @pactype='' Begin
		set @pactype=null
	End
	If @pbranchcode='' Begin
		set @pbranchcode=null
	End
	If @pagency_type='' Begin
		set @pagency_type=null
	End
	If @pagcd='' Begin
		set @pagcd=null
	End
	If @pdpcd='' Begin
		set @pdpcd=null
	End
	If @pstatecode='' Begin
		set @pstatecode=null
	End
	If @pdistcode='' Begin
		set @pdistcode=null
	End

	If @pcitycode='' Begin
		set @pcitycode=null
	End
	If @ptalukacode='' Begin
		set @ptalukacode=null
	End
	If @pbilladj_flag='' Begin
		set @pbilladj_flag=null
	End
	If @pextra1='' Begin
		set @pextra1=null
	End
	If @pextra2='' Begin
		set @pextra2=null
	End
	If @prowbreak='' Begin
		set @prowbreak=null
	End

	set @v_opdate    =dbo.cir_get_finandt(@pcompcode,@pfrom_date,@pdateformat,null,null)--for financial date
print('%')
print(@prowbreak)
	set @v_frdt      =@pfrom_date
	set @v_todt      =@ptill_date
	set @v_divident  =isnull(@prowbreak,35)

	CREATE TABLE #CIR_LEDGER_REPORT
	( COMP_CODE      VARCHAR(10),
	  UNIT_CODE      VARCHAR(10),
	  BRANCH_CODE    VARCHAR(10),
	  DOCTYPE        VARCHAR(100),
	  AGCD           VARCHAR(50),
	  DPCD           VARCHAR(50),
	  RECPTNO        VARCHAR(50),
	  RECPTDT        DATETIME,
	  AMOUNT         decimal(14,2),
	  CHQNO          VARCHAR(50),
	  CHQDT          DATETIME,
	  CHQ_BANK       VARCHAR(100),
	  EXEC_CODE      VARCHAR(20),
	  REMARKS        VARCHAR(500),
	  REASON         VARCHAR(30),
	  BILLNO         VARCHAR(50),
	  BILLDT         DATETIME,
	  BILLAMT        DECIMAL(14,2),
	  ADJAMT         DECIMAL(14,2),
	  LEFTAMT        DECIMAL(14,2),
	  DEBIT_HEAD     VARCHAR(200),
	  CREDIT_HEAD    VARCHAR(200),
	  REC_SEQNO      INT,
	  RECOVARY_DAYS  INT,
	  AGNAME         VARCHAR(500),
	  OPBAL_SEC      DECIMAL(14,2),
	  NARR_LINE      INT,
	  ISSUE_DATE     DATETIME,
	  PRODUCT        VARCHAR(200),
	  QUANTITY       INT,
	  UNIT_PRICE     NUMERIC(8,3),
	  addr1			 varchar(200),
	  ADDR2			 varchar(200),
	  ADDR3			 varchar(200),
	  PIN_CODE       numeric(10)
	  )
print('8')
create table #cir_summary_statement
(
comp_code varchar(20),
unit_code varchar(20),
PUBL_code varchar(20),
EDTN_code varchar(20),
PUBL_NAME varchar(200),
EDTN_NAME varchar(200),
AGCD varchar(20),
DPCD varchar(20),
INV_QTY  numeric(12),
INV_AMT  numeric(14,2),
RET_QTY  numeric(12),
RET_AMT  numeric(14,2),
INSERT_LATE numeric(14,2),
REMARK    varchar(200),
TOTAL numeric(14,2)
)	
declare @sum_ag_comp_code as varchar(20)
declare @sum_ag_unit as varchar(20)
declare @sum_ag_agcd as varchar(20)
declare @sum_ag_dpcd as varchar(20)
declare @sum_ag_ag_name	 as varchar(200)
declare @sum_publ_publ	 as varchar(200)
declare @sum_edtn	 as varchar(200)
declare @sum_edtn_name	 as varchar(200)

declare @v_invqty as numeric(12)
declare @v_invamt as numeric(14,2)
declare @v_retqty as numeric(12)
declare @v_retamt as numeric(14,2)
declare @v_late_ins as numeric(14,2)
declare @v_publ_tot as numeric(14,2)
declare @v_payment as  numeric(14,2)
declare @v_dn_chq as numeric(14,2)					
declare @v_dn_nom as numeric(14,2)					
declare @v_cn as numeric(14,2)

declare @v_tot_inv as numeric(14,2)
declare @v_tot_ucn as numeric(14,2)
declare @v_close_bal as numeric(14,2)

	if @pextra2 ='S'
	begin
		declare sum_ag cursor for
			select distinct comp_code,unit,agcd,dpcd,ag_name from cir_agmast  
			where comp_code = @pcompcode and (unit=@punitcode or @punitcode is null) 
			and (ag_type=@pagency_type or @pagency_type is null) 
			and agcd+dpcd in(select distinct agcd+dpcd from cir_outmast 
							where comp_code = @pcompcode and (unit_code=@punitcode or @punitcode is null) and achd=@pactype) 
			and (agcd=@pagcd or @pagcd is null) 
			and (dpcd=@pdpcd or @pdpcd is null) 			
			and (branch_code=@pbranchcode or @pbranchcode is null) 
			and (state_code=@pstatecode or @pstatecode is null) 
			and (dist_code=@pdistcode or @pdistcode is null) 
			and (tehsil_taluka=@ptalukacode or @ptalukacode is null) 			
			and (ag_class=@pextra1 or @pextra1 is null)
			order by comp_code,unit,ag_name;
	
	
			open sum_ag
				fetch NEXT FROM sum_ag INTO @sum_ag_comp_code,@sum_ag_unit,@sum_ag_agcd,@sum_ag_dpcd,@sum_ag_ag_name
				WHILE (@@FETCH_STATUS = 0) Begin
					set @v_opbal=0
					set @v_close_bal=0
					set @v_opbal =dbo.cir_accounts_cir_agency_opbal(@pcompcode, @punitcode,null,@sum_ag_agcd, @sum_ag_dpcd, @v_opdate, 'NM',@pdateformat,null,null)
					set @v_dbcramt=0					
				
							select @v_billamt=sum(amount) from cir_outmast
								where comp_code = @pcompcode and unit_code=@punitcode and 
									agcd=@sum_ag_agcd and dpcd=@sum_ag_dpcd and billdt >= @v_opdate and billdt<@v_frdt and 
									achd='NM' and recptno is null

							select @v_dbcramt=sum(amount) from cir_rcpdet
								where comp_code=@pcompcode and unit_code=@punitcode and 
									agcd=@sum_ag_agcd and dpcd=@sum_ag_dpcd and recptdt>= @v_opdate and recptdt<@v_frdt and 
									achd='NM' and billno is null

							set @v_opbal=isnull(@v_opbal,0)+isnull(@v_billamt,0)+isnull(@v_dbcramt,0)
			------------------  insert BF ----------------
			insert into #cir_summary_statement(comp_code,unit_code,PUBL_code,EDTN_code,PUBL_NAME,EDTN_NAME,
						AGCD,DPCD,INV_QTY,INV_AMT,RET_QTY,RET_AMT,INSERT_LATE,REMARK,TOTAL)	
			values (@sum_ag_comp_code,@sum_ag_unit,null,null,'Balance B/F',null,@sum_ag_agcd,@sum_ag_dpcd
					,null,null,null,null,null,null,@v_opbal)
			---------------------------------------------		
			set @v_close_bal=@v_opbal
			set @v_tot_inv =0
			set @v_tot_ucn =0

					declare sum_publ cursor for
						select distinct  publ,pro_type,publ_name from cir_publ_mast
						where comp_code = @pcompcode --and (unit_code=@punitcode or @punitcode is null) 
						order by pro_type
						
						open sum_publ
							fetch NEXT FROM sum_publ INTO @sum_publ_publ,@sum_edtn,@sum_edtn_name
							WHILE (@@FETCH_STATUS = 0) Begin
								select @v_invqty=SUM(isnull(bill_copy,0))
								,@v_invamt=sum(isnull(bill_amount,0))								
								from cir_bill where COMP_CODE=@sum_ag_comp_code
								and UNIT_CODE=@sum_ag_unit and AGCD=@sum_ag_agcd and DPCD=@sum_ag_dpcd
								and BILLDT between @v_frdt and @v_todt
								and PUBL=@sum_publ_publ 
								
								select @v_retqty=sum(ISNULL(APR_BNR,0))+sum(ISNULL(APR_DAMAGE,0))+sum(ISNULL(APR_LATE_RECPT,0))+
								sum(ISNULL(APR_SHORT_RECPT,0))+sum(ISNULL(APR_UNSOLD,0)) 
								,@v_retamt =SUM(isnull(copy_amt,0)) from CIR_UNSOLD_DTL 
								where COMP_CODE=@sum_ag_comp_code and UNIT_CODE=@sum_ag_unit 
								and AGCD=@sum_ag_agcd and DPCD=@sum_ag_dpcd and PUBL=@sum_publ_publ 
								and APP_DT between @v_frdt and @v_todt
								and (PROCESS_CRNO is not null or PROCESS_CRNO!='')
								and (PROCESS_CRDT is not null or PROCESS_CRDT!='')
								
								select @v_late_ins=SUM(isnull(abs(AMOUNT),0)) from cir_rcphdr 
								where COMP_CODE=@sum_ag_comp_code and UNIT_CODE=@sum_ag_unit 
								and AGCD=@sum_ag_agcd and DPCD=@sum_ag_dpcd and PUBL=@sum_publ_publ 
								and RECPTDT between @v_frdt and @v_todt
								
								set @v_publ_tot=isnull(@v_invamt,0)+(-1*ISNULL(@v_retamt,0))+(-1*ISNULL(@v_late_ins,0))
								------------------  insert product summary ----------------
								if isnull(@v_invamt ,0) !=0 or isnull(@v_retamt ,0) !=0 or isnull(@v_late_ins ,0) !=0
								begin
									insert into #cir_summary_statement(comp_code,unit_code,PUBL_code,EDTN_code,PUBL_NAME,EDTN_NAME,
												AGCD,DPCD,INV_QTY,INV_AMT,RET_QTY,RET_AMT,INSERT_LATE,REMARK,TOTAL)	
									values (@sum_ag_comp_code,@sum_ag_unit,@sum_publ_publ,@sum_edtn,@sum_edtn_name,null,@sum_ag_agcd,@sum_ag_dpcd
											,@v_invqty,@v_invamt,@v_retqty,@v_retamt,@v_late_ins,null,@v_publ_tot)
								set @v_close_bal=	@v_close_bal+(@v_publ_tot)
								set @v_tot_inv =@v_tot_inv+@v_invamt
								set @v_tot_ucn =@v_tot_ucn+@v_retamt
								end
								---------------------------------------------
								
								
							fetch NEXT FROM sum_publ INTO @sum_publ_publ,@sum_edtn,@sum_edtn_name
							End

						close sum_publ
						deallocate sum_publ
					------------------------ just for  total----------------
					if isnull(@v_tot_inv ,0) !=0 or isnull(@v_tot_ucn ,0) !=0 
					begin
						insert into #cir_summary_statement(comp_code,unit_code,PUBL_code,EDTN_code,PUBL_NAME,EDTN_NAME,
									AGCD,DPCD,INV_QTY,INV_AMT,RET_QTY,RET_AMT,INSERT_LATE,REMARK,TOTAL)	
						values (@sum_ag_comp_code,@sum_ag_unit,null,null,null,null,@sum_ag_agcd,@sum_ag_dpcd
								,null,@v_tot_inv,null,@v_tot_ucn,null,null,null)
					end
					
					select @v_dn_chq=SUM(isnull(abs(amount),0)) from CIR_RCPHDR 
					where COMP_CODE=@sum_ag_comp_code and UNIT_CODE=@sum_ag_unit 
					and AGCD=@sum_ag_agcd and DPCD=@sum_ag_dpcd and DOCTYPE='DN' and REASON='CH0'
					and RECPTDT between @v_frdt and @v_todt					
									
					------------------  insert DN CHQ Bounce summary ----------------
					if isnull(@v_dn_chq ,0) !=0 
					begin
						insert into #cir_summary_statement(comp_code,unit_code,PUBL_code,EDTN_code,PUBL_NAME,EDTN_NAME,
							AGCD,DPCD,INV_QTY,INV_AMT,RET_QTY,RET_AMT,INSERT_LATE,REMARK,TOTAL)	
						values (@sum_ag_comp_code,@sum_ag_unit,null,null,'CHEQUE BOUNCED',null,@sum_ag_agcd,@sum_ag_dpcd
								,null,null,null,null,null,null,@v_dn_chq)
					set @v_close_bal=	@v_close_bal+(@v_dn_chq)
					end
					
					---------------------------------------------	
					
					select @v_dn_nom=SUM(isnull(abs(amount),0)) from CIR_RCPHDR 
					where COMP_CODE=@sum_ag_comp_code and UNIT_CODE=@sum_ag_unit 
					and AGCD=@sum_ag_agcd and DPCD=@sum_ag_dpcd and DOCTYPE='DN' and REASON!='CH0'					
					and RECPTDT between @v_frdt and @v_todt				
					------------------  insert DN summary ----------------
					if isnull(@v_dn_nom ,0) !=0 
					begin
						insert into #cir_summary_statement(comp_code,unit_code,PUBL_code,EDTN_code,PUBL_NAME,EDTN_NAME,
							AGCD,DPCD,INV_QTY,INV_AMT,RET_QTY,RET_AMT,INSERT_LATE,REMARK,TOTAL)	
						values (@sum_ag_comp_code,@sum_ag_unit,null,null,'DEBIT NOTE',null,@sum_ag_agcd,@sum_ag_dpcd
								,null,null,null,null,null,null,@v_dn_nom)
					set @v_close_bal=	@v_close_bal+(@v_dn_nom)
					end
					
					---------------------------------------------	
					
					select @v_cn=SUM(isnull(abs(amount),0)) from CIR_RCPHDR 
					where COMP_CODE=@sum_ag_comp_code and UNIT_CODE=@sum_ag_unit 
					and AGCD=@sum_ag_agcd and DPCD=@sum_ag_dpcd and DOCTYPE='CN'					
					and RECPTDT between @v_frdt and @v_todt				
					------------------  insert CN summary ----------------
					if isnull(@v_cn ,0) !=0 
					begin
						insert into #cir_summary_statement(comp_code,unit_code,PUBL_code,EDTN_code,PUBL_NAME,EDTN_NAME,
							AGCD,DPCD,INV_QTY,INV_AMT,RET_QTY,RET_AMT,INSERT_LATE,REMARK,TOTAL)	
						values (@sum_ag_comp_code,@sum_ag_unit,null,null,'CREDIT NOTE',null,@sum_ag_agcd,@sum_ag_dpcd
								,null,null,null,null,null,null,@v_cn)
					set @v_close_bal=	@v_close_bal+(-1*@v_cn)
					end
					
					---------------------------------------------
					
					select @v_payment=SUM(isnull(abs(amount),0)) from CIR_RCPHDR 
					where COMP_CODE=@sum_ag_comp_code and UNIT_CODE=@sum_ag_unit 
					and AGCD=@sum_ag_agcd and DPCD=@sum_ag_dpcd and DOCTYPE='RCR' and ACHD	= 'NM'				
					and RECPTDT between @v_frdt and @v_todt				
					------------------  insert PAYMENT summary ----------------
					if isnull(@v_payment ,0) !=0 
					begin
						insert into #cir_summary_statement(comp_code,unit_code,PUBL_code,EDTN_code,PUBL_NAME,EDTN_NAME,
							AGCD,DPCD,INV_QTY,INV_AMT,RET_QTY,RET_AMT,INSERT_LATE,REMARK,TOTAL)	
						values (@sum_ag_comp_code,@sum_ag_unit,null,null,'PAYMENT',null,@sum_ag_agcd,@sum_ag_dpcd
								,null,null,null,null,null,null,@v_payment)
					set @v_close_bal=	@v_close_bal+(-1*@v_payment)
					end
					
					---------------------------------------------	
				
				if isnull(@v_close_bal ,0) !=0 
				begin
					insert into #cir_summary_statement(comp_code,unit_code,PUBL_code,EDTN_code,PUBL_NAME,EDTN_NAME,
						AGCD,DPCD,INV_QTY,INV_AMT,RET_QTY,RET_AMT,INSERT_LATE,REMARK,TOTAL)	
					values (@sum_ag_comp_code,@sum_ag_unit,null,null,'BALANCE C/F',null,@sum_ag_agcd,@sum_ag_dpcd
							,null,null,null,null,null,null,@v_close_bal)
				end
				
				fetch NEXT FROM sum_ag INTO @sum_ag_comp_code,@sum_ag_unit,@sum_ag_agcd,@sum_ag_dpcd,@sum_ag_ag_name
				End

			close sum_ag
			deallocate sum_ag
	
	select *,dbo.cir_get_agency(COMP_CODE,UNIT_CODE,AGCD,DPCD) AS AGENCYNAME	
	,dbo.cir_get_contact_person(COMP_CODE,AGCD,DPCD) AS CONTACT
	,dbo.cir_get_agency_add(COMP_CODE,AGCD,DPCD,'','') AS ADDR
	 from #cir_summary_statement order by AGCD,DPCD
	
	end
	else
	begin
declare @v1_commrate as numeric(14,2)
		declare c1 cursor for
				select distinct comp_code,unit,agcd,dpcd,ag_name,ag_name_oth_lang,city_code,tehsil_taluka,dist_code,state_code,
					country_code,branch_code,addr1,ADDR2,ADDR3,PIN_CODE from cir_agmast 
						where comp_code = @pcompcode and (unit=@punitcode or @punitcode is null) and 
									(ag_type=@pagency_type or @pagency_type is null) and agcd+dpcd in(select distinct agcd+dpcd from cir_outmast 
									where comp_code = @pcompcode and (unit_code=@punitcode or @punitcode is null) and achd=@pactype) and 
									(agcd=@pagcd or @pagcd is null) and (dpcd=@pdpcd or @pdpcd is null) and (branch_code=@pbranchcode or @pbranchcode is null) and
									(state_code=@pstatecode or @pstatecode is null) and (dist_code=@pdistcode or @pdistcode is null) and 
									(tehsil_taluka=@ptalukacode or @ptalukacode is null) and (ag_class=@pextra1 or @pextra1 is null)
									order by branch_code,city_code,ag_name;
		  
				--select distinct a.comp_code,a.unit,a.agcd,a.dpcd,a.ag_name,a.ag_name_oth_lang,a.city_code
				--,a.tehsil_taluka,a.dist_code,a.state_code, a.country_code,a.branch_code 
				--,x.supdate,x.publ,x.sup_copy,x.sup_rate,a.addr1,a.ADDR2,a.ADDR3,a.PIN_CODE
				--from cir_agmast a,cir_dbksup x
				--where a.comp_code=x.comp_code and x.UNIT_CODE=a.UNIT and A.AGCD  = x.AGCD and A.DPCD  = x.DPCD and
				-- a.comp_code = @pcompcode and (a.unit=@punitcode or @punitcode is null) and 
				--(a.ag_type=@pagency_type or @pagency_type is null) and a.agcd+a.dpcd in(select distinct agcd+dpcd from cir_outmast 
				--where comp_code = @pcompcode and (unit_code=@punitcode or @punitcode is null) and achd=@pactype) and 
				--(a.agcd=@pagcd or @pagcd is null) and (a.dpcd=@pdpcd or @pdpcd is null) and (a.branch_code=@pbranchcode or @pbranchcode is null) and
				--(a.state_code=@pstatecode or @pstatecode is null) and (a.dist_code=@pdistcode or @pdistcode is null) and 
				--(a.tehsil_taluka=@ptalukacode or @ptalukacode is null) and (a.ag_class=@pextra1 or @pextra1 is null)
				--order by a.branch_code,a.city_code,a.ag_name;
		  
			open c1
				fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit,@v1_agcd,@v1_dpcd,@v1_ag_name,@v1_ag_name_oth_lang,@v1_city_code,@v1_tehsil_taluka,@v1_dist_code,@v1_state_code,@v1_country_code,@v1_branch_code,@v1_addr1,@v1_ADDR2,@v1_ADDR3,@v1_PIN_CODE
				WHILE (@@FETCH_STATUS = 0)  Begin
				set @v_opbal =dbo.cir_accounts_cir_agency_opbal(@pcompcode, @punitcode,null,@v1_agcd, @v1_dpcd, @v_opdate, @pactype,@pdateformat,null,null)
		print('@')
				----for secutiry outstanding---
				If @pactype='SC' Begin
					set @v_opbal_sec	=dbo.cir_accounts_cir_agency_opbal(@pcompcode, @punitcode,null,@v1_agcd,@v1_dpcd,@v_opdate,'SC',@pdateformat,null,null)

					select @v_dbcramt	=sum(amount) from cir_rcphdr
					where comp_code = @pcompcode and unit_code= @punitcode and 
						agcd=@v1_agcd and dpcd=@v1_dpcd and recptdt>= @v_opdate and recptdt<=@v_todt and achd='SC'

					set @v_opbal_sec=isnull(@v_opbal_sec,0)+isnull(@v_dbcramt,0)
				End
				Else Begin
					set @v_opbal_sec =0
				End

				----for secutiry outstanding---
				set @v_dbcramt=0

				select @v_billamt=sum(amount) from cir_outmast
					where comp_code = @pcompcode and unit_code=@punitcode and 
						agcd=@v1_agcd and dpcd=@v1_dpcd and billdt >= @v_opdate and billdt<@v_frdt and 
						achd=@pactype and recptno is null

				select @v_dbcramt=sum(amount) from cir_rcpdet
					where comp_code=@pcompcode and unit_code=@punitcode and 
						agcd=@v1_agcd and dpcd=@v1_dpcd and recptdt>= @v_opdate and recptdt<@v_frdt and 
						achd=@pactype and billno is null

				set @v_opbal=isnull(@v_opbal,0)+isnull(@v_billamt,0)+isnull(@v_dbcramt,0)

				set @v_rec_seqno=isnull(@v_rec_seqno,0)+1

				insert into #cir_ledger_report
					(comp_code,unit_code,branch_code,agcd,dpcd,doctype,recptno,recptdt,amount,
					exec_code,remarks,chqno,chqdt,chq_bank,reason,debit_head,credit_head,
					billno,billdt,billamt,adjamt,leftamt,agname,rec_seqno,narr_line
					,ISSUE_DATE,PRODUCT,QUANTITY,UNIT_PRICE,addr1,ADDR2,ADDR3,PIN_CODE)
				values(@v1_comp_code,@v1_unit,@v1_branch_code,@v1_agcd,@v1_dpcd,null,null,@v_frdt,@v_opbal_sec,
					null,'Security Balance',null,null,null,null,null,null,
					null,null,null,null,null,@v1_ag_name,@v_rec_seqno,1,null,null,null,null,@v1_addr1,@v1_ADDR2,@v1_ADDR3,@v1_PIN_CODE)

				set @v_rec_seqno = isnull(@v_rec_seqno,0)+1

				set @v_runbal = @v_opbal
		            
				If @v_runbal>=0 Begin
					set @v_runbal_txt= CONVERT(VARCHAR, CONVERT( numeric(14, 2), @v_runbal ))--+' Dr.'
				End
				Else Begin
					set @v_runbal_txt=CONVERT(VARCHAR, CONVERT( numeric(14, 2), ABS(@v_runbal) ))--+' Cr.'
				End
		            
				insert into #cir_ledger_report
					(comp_code,unit_code,branch_code,agcd,dpcd,doctype,recptno,recptdt,amount,
					exec_code,remarks,chqno,chqdt,chq_bank,reason,debit_head,credit_head,
					billno,billdt,billamt,adjamt,leftamt,agname,rec_seqno,narr_line,ISSUE_DATE,PRODUCT,QUANTITY,UNIT_PRICE,addr1,ADDR2,ADDR3,PIN_CODE)
				values(@v1_comp_code,@v1_unit,@v1_branch_code,@v1_agcd,@v1_dpcd,null,null,@v_frdt,@v_opbal,
					null,'Opening Balance',null,null,null,null,null,null,
					null,null,null,null,null,@v1_ag_name,@v_rec_seqno,2,null,null,null,null,@v1_addr1,@v1_ADDR2,@v1_ADDR3,@v1_PIN_CODE)
		 
		 print('set')print(@v1_unit)print(@v1_agcd) print(@v1_dpcd) print(@v_frdt) print(@v_todt) print(@pactype)       

				declare c2 cursor for
					select u.comp_code comp_code,u.unit_code unit_code,u.agcd agcd,u.dpcd dpcd,u.doctype doctype,u.recptno recptno,u.recptdt recptdt,u.amount amount,u.chno chno,u.chdt chdt,u.chbank chbank,u.reason reason,
					u.narration narration,u.received_from received_from from 
					(select comp_code,unit_code,agcd,dpcd,doctype,recptno,recptdt,amount,chno,chdt,chbank,reason,remark narration,received_from from cir_rcphdr
						where comp_code=@v1_comp_code and unit_code=@v1_unit and agcd=@v1_agcd and dpcd=@v1_dpcd and recptdt 
							between @v_frdt and @v_todt and case isnull( achd,'NM')  when '' then 'NM' else achd end=@pactype
					union all
					select comp_code,unit_code,agcd,dpcd,'BIL' doctype,billno recptno,billdt recptdt,sum(bill_amount) amount,null chno,null chdt,null chbnk,'BILL' reason,
					'Bill Copy '+ cast(sum(bill_copy) as VARCHAR)+' Trade Disc. '+cast(sum(comm_amount) as VARCHAR) narration,null received_from from cir_bill
						where comp_code=@v1_comp_code and unit_code=@v1_unit and agcd=@v1_agcd and dpcd=@v1_dpcd and 
							billdt between @v_frdt and @v_todt and (@pactype='NM' or @pactype is null or @pactype ='')
							group by comp_code,unit_code,agcd,dpcd,billno,billdt
					/*union all
					select comp_code,unit_code,agcd,dpcd,doctyp doctype,billno recptno,billdt recptdt,sum(amount) amount,null chno,null chdt,null chbnk, reason,
					remark narration,null received_from from cir_outmast
						where comp_code=@v1_comp_code and unit_code=@v1_unit and agcd=@v1_agcd and dpcd=@v1_dpcd and 
							billdt between @v_frdt and @v_todt and @pactype='NM' and isnull(amount,0)>0 and billno is null 
							group by comp_code,unit_code,agcd,dpcd,billno,billdt,doctyp,reason,remark		*/
							)u
					order by recptdt,doctype,recptno
					

				--------daily transactions------------
					open c2
					fetch NEXT FROM c2 INTO @v2_comp_code,@v2_unit_code,@v2_agcd,@v2_dpcd,@v2_doctype,@v2_recptno,@v2_recptdt,@v2_amount,@v2_chno,@v2_chdt,@v2_chbank,@v2_reason,@v2_narration,@v2_received_from
					WHILE (@@FETCH_STATUS = 0) Begin
						
						If isnull(@v2_amount,0)<>0 Begin
							set @v_rec_seqno=isnull(@v_rec_seqno,0)+1
							set @v_narration=null
								If @v2_doctype='BIL' Begin
									set @v_narration=@v2_narration
									select distinct @v1_issue_date=TODT,@v1_product_code=PUBL,@v1_quantity=sum(BILL_COPY)
									,@v1_unit_price=COPY_RATE,@v1_commrate=COMM_RATE from cir_bill_det
									where COMP_CODE=@pcompcode and UNIT_CODE=@v2_unit_code and BILLNO=@v2_recptno and AGCD=@v2_agcd and DPCD=@v2_dpcd
									group by TODT,PUBL,COPY_RATE,COMM_RATE
								End
								else If @v2_doctype='UCN' Begin
									set @v_narration=@v2_narration
									select distinct @v1_issue_date=SUPDATE,@v1_product_code=PUBL,@v1_quantity=sum(APR_BNR+APR_DAMAGE+APR_LATE_RECPT+APR_SHORT_RECPT+APR_UNSOLD)
									,@v1_unit_price=COPY_RATE,@v1_commrate=COMM_RATE from CIR_UNSOLD_DTL
									where COMP_CODE=@pcompcode and UNIT_CODE=@v2_unit_code and PROCESS_CRNO=@v2_recptno and AGCD=@v2_agcd and DPCD=@v2_dpcd
									group by SUPDATE,PUBL,COPY_RATE,COMM_RATE
								End
								Else  
								Begin
										set @v1_issue_date=null
										set @v1_product_code=null
										set @v1_quantity=null
										set @v1_unit_price=null
										set @v1_commrate=null
									If @v2_narration is not null 
									Begin
										set @v_narration=@v2_narration
													
										If @v2_chno is not null and @v2_chno !=''
										Begin
											set @v_narration=@v_narration+' CHNO# '+@v2_chno
										End
										If @v2_chdt is not null and @v2_chdt !=''
										Begin
											set @v_narration=@v_narration+' CHDT '+ cast(@v2_chdt as varchar)
										End
										If @v2_chbank is not null and @v2_chbank !=''
										Begin
											set @v_narration=@v_narration+' CHBNK '+@v2_chbank
										End
										If @v2_reason='CA0' and @v2_doctype='RCR' 
										Begin
											set @v_narration='By Cash '+@v_narration
										End
									End
								End
						End	
						Else 
						Begin print('test')
							If @v2_chno is not null and @v2_chno !=''
							Begin
								set @v_narration='CHNO# '+@v2_chno
							End
							If @v2_chdt is not null  and @v2_chdt !=''
							Begin
								set @v_narration =@v_narration+' CHDT '+ DBO.convert_user_date('/',@v2_chdt,@pdateformat)  
							End
							If @v2_chbank is not null  and @v2_chbank !=''
							Begin
								set @v_narration=@v_narration+' CHBANK '+@v2_chbank
							End
							If @v2_reason='CA0' and @v2_doctype='RCR' 
							Begin
								set @v_narration='By Cash '+@v_narration
							End
						End

					set @v_remark_len = LEN(ISNULL(LTRIM(RTRIM(@v_narration)), '-'))
					set @v_amt=isnull(@v_amt,0)+isnull(@v2_amount,0)
					                    

					set @v_runbal = @v_runbal+isnull(@v2_amount,0)

					If @v_runbal>=0 Begin
						set @v_runbal_txt= CONVERT(VARCHAR, CONVERT( numeric(14, 2), @v_runbal ))--+' Dr.'
					End
					Else Begin
						set @v_runbal_txt=CONVERT(VARCHAR, CONVERT( numeric(14, 2), (@v_runbal) ))--+' Cr.'
					End
					                                        
					If isnull(@v2_amount,0)>=0 Begin
						set @v_dbamt=isnull(@v_dbamt,0)+isnull(@v2_amount,0)
					End
					If isnull(@v2_amount,0)<0 Begin
						set @v_cramt=isnull(@v_cramt,0)+abs(isnull(@v2_amount,0))
					End

					
					
		print('#')	
		print(@v_remark_len)
		print(@v_divident)	
		
		set @v1_unit_price=round(@v1_unit_price-((isnull(@v1_unit_price,0)*isnull(@v1_commrate,1))/100),3)
			
					insert into #cir_ledger_report
						  (comp_code,unit_code,branch_code,agcd,dpcd,doctype,recptno,recptdt,amount,
						  exec_code,remarks,chqno,chqdt,chq_bank,reason,debit_head,credit_head,
						  billno,billdt,billamt,adjamt,leftamt,agname,rec_seqno,narr_line
						  ,ISSUE_DATE,PRODUCT,QUANTITY,UNIT_PRICE,addr1,ADDR2,ADDR3,PIN_CODE)
					  values(@v1_comp_code, @v1_unit, @v1_branch_code, @v1_agcd, @v1_dpcd, @v2_doctype, @v2_recptno, @v2_recptdt, @v2_amount,
							 @v2_received_from,isnull(ltrim(rtrim(@v_narration)),'-'), @v2_chno, @v2_chdt, @v2_chbank, @v2_reason,null, @v_runbal_txt,
							 null, null, null, null, @v_runbal, @v1_ag_name, @v_rec_seqno, dbo.mod_function(@v_remark_len, @v_divident)
							 ,@v1_issue_date,@v1_product_code,@v1_quantity,@v1_unit_price,@v1_addr1,@v1_ADDR2,@v1_ADDR3,@v1_PIN_CODE)
		print('$')
					fetch NEXT FROM c2 INTO @v2_comp_code,@v2_unit_code,@v2_agcd,@v2_dpcd,@v2_doctype,@v2_recptno,@v2_recptdt,@v2_amount,@v2_chno,@v2_chdt,@v2_chbank,@v2_reason,
					@v2_narration,@v2_received_from
				End

				close c2
				deallocate c2
				
				--------daily transactions------------
		            
				
print('ggg')print(@v_runbal)
				set @v_rec_seqno=isnull(@v_rec_seqno,0)+1
				If @v_runbal>=0 Begin
					set @v_runbal_txt= CONVERT(VARCHAR, CONVERT( numeric(14, 2), @v_runbal )) --+' Dr.'
				End
				Else Begin
					set @v_runbal_txt= CONVERT(VARCHAR, CONVERT( numeric(14, 2), (@v_runbal) )) --+' Cr.'
				End
print('gggqq')print(@v_runbal_txt)
					insert into #cir_ledger_report
					(comp_code,unit_code,branch_code,agcd,dpcd,doctype,recptno,recptdt,amount,
					exec_code,remarks,chqno,chqdt,chq_bank,reason,debit_head,credit_head,
					billno,billdt,billamt,adjamt,leftamt,agname,rec_seqno,narr_line,ISSUE_DATE,PRODUCT,QUANTITY,UNIT_PRICE,addr1,ADDR2,ADDR3,PIN_CODE)
					values(@v1_comp_code, @v1_unit, @v1_branch_code, @v1_agcd, @v1_dpcd, null, null, @v_todt,isnull(@v_clbal,0),
					null,'Closing Balance',null,null,null,null,null,null,
					null,null,null,null,null, @v1_ag_name, @v_rec_seqno,1,@v1_issue_date,@v1_product_code,@v1_quantity,@v1_unit_price,@v1_addr1,@v1_ADDR2,@v1_ADDR3,@v1_PIN_CODE)

				If isnull(@v_opbal_sec,0)=0 and isnull(@v_opbal,0)=0 and @v_cramt=0 and @v_dbamt=0 Begin
				   delete from #cir_ledger_report where comp_code = @v1_comp_code and unit_code = @v1_unit and
					agcd = @v1_agcd and dpcd = @v1_dpcd
				End

				set @v_billamt=0 set @v_dbcramt=0 set @v_opbal=0 set @v_clbal=0 set @v_amt=0 set @v_runbal=0 set @v_cramt=0 set @v_dbamt=0 set @v_runbal_txt=null
		        
				fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit,@v1_agcd,@v1_dpcd,@v1_ag_name,@v1_ag_name_oth_lang,@v1_city_code,@v1_tehsil_taluka,@v1_dist_code,@v1_state_code,
					@v1_country_code,@v1_branch_code,@v1_addr1,@v1_ADDR2,@v1_ADDR3,@v1_PIN_CODE
				End

				close c1
				DEALLOCATE c1
		/*
		SELECT (SELECT distinct Comp_Name FROM  comp_mst WHERE Comp_Code  = a.comp_code) as "CNAME",
		COMP_CODE,UNIT_CODE,BRANCH_CODE,(select distinct "Branch_Name" from branch_mst where Comp_Code=a.Comp_Code and "Branch_Code"=a.BRANCH_CODE) "BRANCH_NAME",
		AGCD,DPCD,AGNAME,DBO.cir_get_agency_city(comp_code,unit_code,agcd,dpcd) CITY_NAME,
		DOCTYPE,RECPTNO,RECPTDT,
		CASE a.debit WHEN 'D' THEN a.amount END as DEBIT,
		CASE a.credit WHEN 'C' THEN a.amount END as CREDIT,
		EXEC_CODE,REMARKS,CHQNO,CHQDT,CHQ_BANK,REASON,DEBIT_HEAD,CREDIT_HEAD,BILLNO,BILLDT,BILLAMT,
		ADJAMT,LEFTAMT,REC_SEQNO,narr_line
		,a.ISSUE_DATE as ISSUE_DATE,(Select distinct PUBL_NAME from CIR_PUBL_MAST p where p.COMP_CODE=@pcompcode and p.PUBL=a.PRODUCT) as PRODUCT
		,a.QUANTITY,a.UNIT_PRICE,a.addr1,a.ADDR2,a.ADDR3,a.PIN_CODE
		FROM (SELECT comp_code,unit_code,branch_code,agcd,dpcd,agname,doctype,recptno,recptdt,
		CASE sign(amount) WHEN 1 THEN 'D' END as debit,
		CASE sign(amount) WHEN - 1 THEN 'C' END as credit,
		 ABS(amount) as amount,exec_code,remarks,chqno,chqdt,chq_bank,reason,debit_head,credit_head,
		 billno,billdt,billamt,adjamt,leftamt,rec_seqno,ISNULL(narr_line, 1) as narr_line
		 ,ISSUE_DATE,PRODUCT,QUANTITY,UNIT_PRICE,addr1,ADDR2,ADDR3,PIN_CODE
		FROM  #cir_ledger_report 
		WHERE comp_code  = @pcompcode AND unit_code  = @punitcode) a 
		ORDER BY rec_seqno 
		*/

			SELECT (SELECT distinct Comp_Name FROM  comp_mst WHERE Comp_Code  = a.comp_code) as "CNAME",
			COMP_CODE,UNIT_CODE,BRANCH_CODE
			,(select distinct "Branch_Name" from branch_mst where Comp_Code=a.Comp_Code and "Branch_Code"=a.BRANCH_CODE) "BRANCH_NAME",
			AGCD,DPCD,AGNAME,DBO.cir_get_agency_city(comp_code,unit_code,agcd,dpcd) CITY_NAME,
			case DOCTYPE
			when 'BIL' then 'INVOICE'
			when 'RCR' then 'PAYMENT'
			when 'UCN' then 
				case REASON 
				when 'NO0' then 'RETURN[Pulangan Biasa]'
				when 'UNSOLD CREDIT NOTE' then 'RETURN[Pulangan Biasa]'
				else isnull((Select reason_name from CIR_REASON_MST t where t.COMP_CODE=a.COMP_CODE and t.REASON_CODE=a.REASON ),'UNSOLD CREDIT NOTE') end
			when 'DN' then 
				case REASON
				when 'CH0' then 'Return Cheque'				
				else isnull(REMARKS,(Select reason_name from CIR_REASON_MST t where t.COMP_CODE=a.COMP_CODE and t.REASON_CODE=a.REASON )) end 	
			when 'CN' then
				case isnull(REMARKS,'~')
				when '' then reason
				when '~' then reason				
				else REMARKS end
			end DOCTYPE
			,RECPTNO,case @pdateformat			
			when 'dd/mm/yyyy' then CONVERT(varchar(10),RECPTDT,103)
			when 'mm/dd/yyyy' then CONVERT(varchar(10),RECPTDT,101)
			when 'yyyy/mm/dd' then CONVERT(varchar(10),RECPTDT,111)
			end  RECPTDT,
			CASE a.debit WHEN 'D' THEN a.amount END as DEBIT,
			CASE a.credit WHEN 'C' THEN a.amount END as CREDIT,
			EXEC_CODE,REMARKS,CHQNO,CHQDT,CHQ_BANK,REASON,DEBIT_HEAD,CREDIT_HEAD,BILLNO,BILLDT,BILLAMT,
			ADJAMT,LEFTAMT,REC_SEQNO,narr_line
			,
			case @pdateformat			
			when 'dd/mm/yyyy' then CONVERT(varchar(10),a.ISSUE_DATE,103)
			when 'mm/dd/yyyy' then CONVERT(varchar(10),a.ISSUE_DATE,101)
			when 'yyyy/mm/dd' then CONVERT(varchar(10),a.ISSUE_DATE,111)
			end  
			 as ISSUE_DATE,(Select distinct PUBL_NAME from CIR_PUBL_MAST p where p.COMP_CODE=@pcompcode and p.PUBL=a.PRODUCT) as PRODUCT
			,a.QUANTITY,a.UNIT_PRICE,a.addr1,a.ADDR2,a.ADDR3,a.PIN_CODE
			FROM (SELECT comp_code,unit_code,branch_code,agcd,dpcd,agname,doctype,recptno,recptdt,
			CASE sign(amount) WHEN 1 THEN 'D' END as debit,
			CASE sign(amount) WHEN - 1 THEN 'C' END as credit,
			 ABS(amount) as amount,exec_code,remarks,chqno,chqdt,chq_bank,reason,debit_head,credit_head,
			 billno,billdt,billamt,adjamt,leftamt,rec_seqno,ISNULL(narr_line, 1) as narr_line
			 ,ISSUE_DATE,PRODUCT,QUANTITY,UNIT_PRICE,addr1,ADDR2,ADDR3,PIN_CODE
			FROM  #cir_ledger_report 
			WHERE comp_code  = @pcompcode AND unit_code  = @punitcode) a 
			ORDER BY rec_seqno 

			SELECT (SELECT Comp_Name FROM  comp_mst WHERE Comp_Code  = a.comp_code) as "CNAME",
			COMP_CODE,AGCD,DPCD,AGNAME,(SELECT COUNT(*) FROM 
			( SELECT     comp_code,     unit_code,     branch_code,     agcd,     dpcd,     agname,     doctype,     recptno,     recptdt,        
			CASE sign(amount)     WHEN 1 THEN 'D' END as DEBIT,
			CASE sign(amount)     WHEN - 1 THEN 'C'    END as CREDIT,ABS(amount) as AMOUNT,     rec_seqno,NARR_LINE
			FROM  #cir_ledger_report   WHERE  comp_code  = @pcompcode   AND unit_code  = @punitcode ) adv_alias_1  
			WHERE  adv_alias_1.comp_code  = a.comp_code  AND adv_alias_1.agcd  = a.agcd  AND adv_alias_1.dpcd  = a.dpcd  AND adv_alias_1.agname  = a.agname ) adv_count_value,
			ISNULL(SUM(CONVERT(FLOAT, narr_line)), 0) sum_narr
			FROM (SELECT comp_code,unit_code,branch_code,agcd,dpcd,agname,doctype,recptno,recptdt,
			CASE sign(amount) WHEN 1 THEN 'D' END as debit,
			CASE sign(amount) WHEN - 1 THEN 'C' END as credit,ABS(amount) as amount,rec_seqno,narr_line
			FROM  #cir_ledger_report 
			WHERE comp_code  = @pcompcode AND unit_code  = @punitcode) a 
			group by a.comp_code,a.agcd,a.dpcd,a.agname
			ORDER BY comp_code,agcd,dpcd,agname 
	end
	select * from #cir_ledger_report
	drop table #cir_ledger_report

	drop table #cir_summary_statement
	
END


**********************************issue no.- 9659*******************************************



ALTER PROCEDURE  [dbo].[cir_area_name_bind]

 @pcomp_code as varchar(200),
 @punit_code as varchar(200),
 @parea_code as varchar(200),
 @pdateformat as varchar(200),
 @pextra1 as varchar(200),
 @pextra2 as varchar(200)

 AS
  select * from cir_area_mast where comp_code=@pcomp_code and
                  unit_code=@punit_code and
                  (area_code=@parea_code or @parea_code is null)
            order by area_code



******************************************end***********************************************


***************************add by Deepika 24/01/2013*************************************

                                                                     
                                                                     
                                                                     
                                             


ALTER PROCEDURE [dbo].[cir_ledger_ageing]
@pcomp_code varchar(20),
@punit_code varchar(20),
@pbran_code varchar(20),
@pzone_code varchar(30),
@pregion_code varchar(30),
@pdist_code varchar(20),
@ptaluka_code varchar(20),
@pagtype varchar(50),
@pagclass varchar(50),
@pag_main_code varchar(50),
@pag_sub_code varchar(50),
@paging_by varchar(50),
@pasondt datetime,
@pdebitupto_date datetime,
@pcreditupto_date datetime,
@pdateformat varchar(20),
@puserid varchar(20),
@pextra1 varchar(20),
@pextra2 varchar(20),
@pextra3 varchar(30),
@pextra4 varchar(30),
@pextra5 varchar(50)
As

--------- slabs end

declare @ptill_days1 as varchar(20)
declare @ptill_days2 as varchar(20)
declare @ptill_days3 as varchar(30)
declare @ptill_days4 as varchar(30)
declare @ptill_days5 as varchar(50)
declare @ptill_days6 as varchar(50)
declare @ptill_current as varchar(50)
---------------- slabs

declare @vtodt as datetime
declare @vasondt as datetime
declare @v_dt as datetime
declare @v_ondt as datetime
declare @v_days numeric(10);
declare @v_pending_rcpt_amt as numeric(14,2)
declare @v_amt as numeric(14,2);
declare @v_amt030 as numeric(14,2);
declare @v_amt3160 as numeric(14,2);
declare @v_amt6190 as numeric(14,2);
declare @v_amt91120 as numeric(14,2);
declare @v_amt121180 as numeric(14,2);
declare @v_amt181 as numeric(14,2);
declare @v_amtcur as numeric(14,2);
declare @debit_amt_030 as numeric(14,2) --debit amt for slab 1 days
declare @debit_amt_3160 as numeric(14,2) --debit amt for slab 2 days
declare @debit_amt_6190 as numeric(14,2) --debit amt for slab 3 days
declare @debit_amt_91120 as numeric(14,2) --debit amt for slab 4 days
declare @debit_amt_121180 as numeric(14,2) --debit amt for >slab 5 days
declare @debit_amt_181 as numeric(14,2) --debit amt for >slab 6 days
declare @debit_amt_cur as numeric(14,2) --debit amt for >current
declare @bill_pending_amt as numeric(14,2)
declare @rcpt_pending_amt as numeric(14,2) --pending receipt amount

CREATE TABLE #cir_temp_ageing
(
	COMP_CODE VARCHAR(8),
	UNIT_CODE VARCHAR(8),
	BRAN_CODE VARCHAR(8),
	AGCD VARCHAR(8),
	DPCD VARCHAR(8),
	AG_NAME VARCHAR(100),
	CITY_NAME VARCHAR(100),
	PENDING_AMT NUMERIC(14,2),
	CUR_AMT NUMERIC(14,2),
	SLAB_1 NUMERIC(14,2),
	SLAB_2 NUMERIC(14,2),
	SLAB_3 NUMERIC(14,2),
	SLAB_4 NUMERIC(14,2),
	SLAB_5 NUMERIC(14,2),
	SLAB_6 NUMERIC(14,2),
	ON_ACAMT NUMERIC(14,2),
	RECT_PENDING NUMERIC(14,2),
	SESSIONID NUMERIC(14),
	PUBNAME VARCHAR(200),
	ageing varchar(1)
)

set @debit_amt_030 =0 --debit amt for slab 1 days
set @debit_amt_3160 =0 --debit amt for slab 2 days
set @debit_amt_6190 =0 --debit amt for slab 3 days
set @debit_amt_91120 =0 --debit amt for slab 4 days
set @debit_amt_121180 =0 --debit amt for >slab 4 days
set @debit_amt_181 =0 --debit amt for >slab 4 days
set @debit_amt_cur =0 --debit amt for >current
set @bill_pending_amt =0
set @rcpt_pending_amt =0 --pending receipt amount
-- cursor cur_agency variables

declare @rec_agency_comp_code as varchar(30)
declare @rec_agency_agcd as varchar(20)
declare @rec_agency_dpcd as varchar(30)
declare @rec_agency_agency_name as varchar(300)
declare @rec_agency_city_code as varchar(200)
declare @rec_agency_city_name as varchar(200)
declare @rec_agency_credit_days as int
declare @rec_agency_branch_name as varchar(50)
declare @rec_agency_ageing_type as varchar(1)
--@rec_agency_comp_code,@rec_agency_agcd,@rec_agency_dpcd,@rec_agency_agency_name,@rec_agency_city_code,@rec_agency_city_name,

--@rec_agency_credit_days,@rec_agency_branch_name,@rec_agency_ageing_type

declare cur_agency_1 cursor for
select m.Comp_Code ,m.agcd ,m.dpcd ,m.ag_name ,m.City_Code,c.city_name,m.credit_days,m.branch_code,m.ageing_type
from cir_agmast m,cir_city_mast c
where m.comp_code=c.comp_code and m.comp_code=@pcomp_code
and m.unit=@punit_code and m.city_code=c.city_code
and (m.Dist_Code=@pdist_code or @pdist_code is null or @pdist_code ='')
and (m.tehsil_taluka=@ptaluka_code or @ptaluka_code is null or @ptaluka_code ='')
and (m.agcd=@pag_main_code or @pag_main_code is null or @pag_main_code ='')
and (m.dpcd=@pag_sub_code or @pag_sub_code is null or @pag_sub_code ='')

if @pdebitupto_date is null or @pdebitupto_date=''
begin
	set @pdebitupto_date =@pasondt
end
if @pcreditupto_date is null or @pcreditupto_date=''
begin
	set @pcreditupto_date =@pasondt
end
if @pasondt is null or @pasondt =''
begin
	set @pasondt=@pcreditupto_date
end

declare @fetch_protype as varchar(20)
declare @fetch_pub as varchar(20)
-- cursor v_bill variables

declare @v_bill_billno as varchar(50)
declare @v_bill_billdt as varchar(30)
declare @v_bill_bill_amt as numeric(15,2)
-- cursor v_pending_rcpt variables

declare @v_pending_rcpt_ag_main_code as varchar(30)
declare @v_pending_rcpt_ag_sub_code as varchar(50)
declare @v_pending_rcpt_amount as numeric(15,2)
declare @fetch_pubname as varchar(200)
declare @fetch_pubtype as varchar(200)
--SELECT 'cursor has ' + CAST(@@CURSOR_ROWS AS VARCHAR) + ' rows'

declare @v_mcnt1 as datetime
declare @v_mcnt2 as datetime
declare @v_mcnt3 as datetime
declare @v_mcnt4 as datetime
declare @v_mcnt5 as datetime
declare @vtill_days1 AS int
declare @vtill_days2 AS int
declare @vtill_days3 AS int
declare @vtill_days4 AS int
declare @vtill_days5 AS int
declare @vrec_agency_ageing_type as varchar(10)

	open cur_agency_1
		fetch NEXT FROM cur_agency_1 INTO @rec_agency_comp_code,@rec_agency_agcd,@rec_agency_dpcd,@rec_agency_agency_name,@rec_agency_city_code,@rec_agency_city_name,@rec_agency_credit_days,@rec_agency_branch_name,@rec_agency_ageing_type
		WHILE (@@FETCH_STATUS = 0)
		begin
			declare @day as int
			
			declare cur_agency cursor for
			select distinct publ from cir_supply where comp_code=@pcomp_code and agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd order by publ
			--select distinct dbo.cir_get_publ_type(comp_code,publ,'C','') publ from cir_supply where comp_code=@pcomp_code and agcd=@pag_main_code and dpcd=@pag_sub_code order by publ
			print
			('@rec_agency_ageing_type')print(@rec_agency_ageing_type)
			open cur_agency
				fetch NEXT FROM cur_agency INTO @fetch_pub
				WHILE (@@FETCH_STATUS = 0)
				BEGIN 
					print('dddddd') print(@fetch_pub)
					
					select distinct @fetch_protype=pro_type,@fetch_pubname=PUBL_NAME,@fetch_pubtype=
					(Select pubname from pub_type_mast where Comp_Code=@pcomp_code and pub_type_mast.pubtypecode=CIR_PUBL_MAST.PRO_TYPE)
					from CIR_PUBL_MAST where COMP_CODE=@pcomp_code and publ=@fetch_pub					
					
					print('@fetch_protype')print(@fetch_protype)
					print('@@fetch_pubname')print(@fetch_pubname)
					print('@fetch_pubtype')print(@fetch_pubtype)
					
					if @fetch_protype ='MA0'
					begin
						set @vrec_agency_ageing_type='M'
					end
					else
					begin
						set @vrec_agency_ageing_type=@rec_agency_ageing_type
					end
					select @ptill_days1=SLAB_TILL1,@ptill_days2=SLAB_TILL2,@ptill_days3=SLAB_TILL3,@ptill_days4=SLAB_TILL4
					,@ptill_days5=SLAB_TILL5,@ptill_days6=SLAB_TILL6--,@rec_agency_ageing_type=AGEING_TYPE
					from CIR_AGEING_SLAB_MAST
					where COMP_CODE=@pcomp_code and PRO_TYPE=@fetch_protype
					
					print ('slab')print(@ptill_days1)print(@ptill_days2)print(@ptill_days3)print(@ptill_days4)print(@ptill_days5)
					print (@ptill_days6)print(@rec_agency_ageing_type)
					print ('gaurav')
					print (@vrec_agency_ageing_type)
					print (@pasondt)
					print (dbo.GetLastDayOfMonth(@pasondt))
					print ('debug')
					
					if upper(@vrec_agency_ageing_type) = 'D'
					begin
						set @vtodt=dateadd(dd,-1,@pasondt)
					end
					else if upper(@vrec_agency_ageing_type) = 'W'
					begin
						select @day=DATEPART(dw,@pasondt)
						print(@day)
						set @vtodt=dateadd(dd,-(@day-1),@pasondt)
					end
					else
					begin
						if dbo.GetLastDayOfMonth(@pasondt)=@pasondt
						begin
							set @vtodt=@pasondt
						end
						else
						begin
							set @vtodt=dbo.GetLastDayOfMonth(dateadd(mm,-1,@pasondt))
						end
					end
					print('come') print(@vrec_agency_ageing_type)
					print(@vtodt)
					print('custom')print(@ptill_days1)print(@ptill_days2)print(@ptill_days3)print(@ptill_days4)print(@ptill_days5)

					if @vrec_agency_ageing_type='M' begin print('gks')
						set @v_mcnt1=DATEADD(MM,-1*@ptill_days1,@vtodt+1)
						set @v_mcnt2=DATEADD(MM,-1*@ptill_days2,@vtodt+1)
						set @v_mcnt3=DATEADD(MM,-1*@ptill_days3,@vtodt+1)
						set @v_mcnt4=DATEADD(MM,-1*@ptill_days4,@vtodt+1)
						set @v_mcnt5=DATEADD(MM,-1*@ptill_days5,@vtodt+1)
						--DATEDIFF(dd, dbo.GetFirstDayOfMonth( @vtodt),@vtodt )+1
						set @vtill_days1=DATEDIFF(dd, dbo.GetFirstDayOfMonth( @v_mcnt1),@vtodt )+1
						set @vtill_days2=DATEDIFF(dd, dbo.GetFirstDayOfMonth( @v_mcnt2),@vtodt )+1
						set @vtill_days3=DATEDIFF(dd, dbo.GetFirstDayOfMonth( @v_mcnt3),@vtodt )+1
						set @vtill_days4=DATEDIFF(dd, dbo.GetFirstDayOfMonth( @v_mcnt4),@vtodt )+1
						set @vtill_days5=DATEDIFF(dd, dbo.GetFirstDayOfMonth( @v_mcnt5),@vtodt )+1
					end
					else if @vrec_agency_ageing_type='W'  
					begin print('weekly')
						--@vtodt
						set @v_mcnt1=DATEADD(ww,-1*@ptill_days1,@vtodt+1)
						set @v_mcnt2=DATEADD(ww,-1*@ptill_days2,@vtodt+1)
						set @v_mcnt3=DATEADD(ww,-1*@ptill_days3,@vtodt+1)
						set @v_mcnt4=DATEADD(ww,-1*@ptill_days4,@vtodt+1)
						set @v_mcnt5=DATEADD(ww,-1*@ptill_days5,@vtodt+1)
						
						set @vtill_days1=DATEDIFF(dd, @v_mcnt1,@vtodt )+1
						set @vtill_days2=DATEDIFF(dd, @v_mcnt2,@vtodt )+1
						set @vtill_days3=DATEDIFF(dd, @v_mcnt3,@vtodt )+1
						set @vtill_days4=DATEDIFF(dd, @v_mcnt4,@vtodt )+1
						set @vtill_days5=DATEDIFF(dd, @v_mcnt5,@vtodt )+1
					end
					else
					begin
						set @vtill_days1=@ptill_days1
						set @vtill_days2=@ptill_days2
						set @vtill_days3=@ptill_days3
						set @vtill_days4=@ptill_days4
						set @vtill_days5=@ptill_days5
					end
					print ('custom1')print(@vtill_days1)print(@vtill_days2)print(@vtill_days3)print(@vtill_days4)print(@vtill_days5)
					print @rec_agency_dpcd
					set @debit_amt_030 = 0;
					set @debit_amt_3160 = 0;
					set @debit_amt_6190 = 0;
					set @debit_amt_91120 = 0;
					set @debit_amt_121180 = 0;
					set @debit_amt_181 = 0;
					set @rcpt_pending_amt = 0;
					set @bill_pending_amt = 0;
					print('enter first')
					
					declare c_bill cursor for
					select distinct billno,billdt,sum(amount) bill_amt from cir_outmast
					where comp_code=@pcomp_code and unit_code=@punit_code and
					agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
					billdt <=@vtodt and isnull(abs(amount),0)>0
					group by comp_code,billno,billdt having sum(amount)>0
					union all
					select distinct recptno billno,recptdt billdt,sum(amount) bill_amt from cir_outmast
					where comp_code=@pcomp_code and unit_code=@punit_code and
					agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
					recptdt <=@vtodt and isnull(amount,0)>0 and billno is null
					group by comp_code,recptno,recptdt order by 2,1
--having sum(amount)<0
					open c_bill
					fetch NEXT FROM c_bill INTO @v_bill_billno,@v_bill_billdt,@v_bill_bill_amt
						WHILE (@@FETCH_STATUS = 0)
						begin
							print('enter second')
							
							set @v_dt = @v_bill_billdt
							set @v_ondt = @vtodt
							print(@v_dt)
							print(@v_ondt)
							
							if @paging_by='D' begin
								set @v_days=DATEDIFF(dd, @v_dt,@v_ondt )---isnull(pcrdtday,0)+1;
							end
							else
							begin
								set @v_days=DATEDIFF(dd, @v_dt,@v_ondt )+1;
							end
							if @v_days<0 begin
								set @v_days=0;
							end
							print('x')
							print(@v_days)
							set @v_amt =0;
							set @v_amt030 =0;
							set @v_amt3160 =0;
							set @v_amt6190 =0;
							set @v_amt91120 =0;
							set @v_amt121180 =0;
							set @v_amt181 =0;
							
							if @v_days between 0 and @vtill_days1 
							begin
								select @v_amt030=sum(amount) from cir_outmast
								where comp_code=@pcomp_code and unit_code=@punit_code and
								agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
								billno =@v_bill_billno and billdt=@v_bill_billdt and
								recptdt <=@vasondt and amount<0
								set @v_amt030 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt030,0);
								set @debit_amt_030 =isnull(@debit_amt_030,0)+isnull(@v_amt030,0)
							end
							else if @v_days between isnull(@vtill_days1,0)+1 and @vtill_days2 
							begin
								select @v_amt3160=sum(amount) from cir_outmast
								where comp_code=@pcomp_code and unit_code=@punit_code and
								agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
								billno =@v_bill_billno and billdt=@v_bill_billdt and
								recptdt <=@vasondt and amount<0
							--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
								set @v_amt3160 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt3160,0);
								set @debit_amt_3160 =isnull(@debit_amt_3160,0)+isnull(@v_amt3160,0)
							end
							else if @v_days between isnull(@vtill_days2,0)+1 and @vtill_days3 
							begin
								select @v_amt6190=sum(amount) from cir_outmast
								where comp_code=@pcomp_code and unit_code=@punit_code and
								agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
								billno =@v_bill_billno and billdt=@v_bill_billdt and
								recptdt <=@vasondt and amount<0
							--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
								set @v_amt6190 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt6190,0);
								set @debit_amt_6190 =isnull(@debit_amt_6190,0)+isnull(@v_amt6190,0)
							end
							else if @v_days between isnull(@vtill_days3,0)+1 and @vtill_days4 
							begin
								select @v_amt91120=sum(amount) from cir_outmast
								where comp_code=@pcomp_code and unit_code=@punit_code and
								agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
								billno =@v_bill_billno and billdt=@v_bill_billdt and
								recptdt <=@vasondt and amount<0
							--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
								set @v_amt91120 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt91120,0);
								set @debit_amt_91120 =isnull(@debit_amt_91120,0)+isnull(@v_amt91120,0)
							end
							else if @v_days between isnull(@vtill_days4,0)+1 and @vtill_days5 
							begin
								select @v_amt121180=sum(amount) from cir_outmast
								where comp_code=@pcomp_code and unit_code=@punit_code and
								agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
								billno =@v_bill_billno and billdt=@v_bill_billdt and
								recptdt <=@vasondt and amount<0
							--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
								set @v_amt121180 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt121180,0);
								set @debit_amt_121180 =isnull(@debit_amt_121180,0)+isnull(@v_amt121180,0)
							end
							else
							begin
								select @v_amt181=sum(amount) from cir_outmast
								where comp_code=@pcomp_code and unit_code=@punit_code and
								agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
								billno =@v_bill_billno and billdt=@v_bill_billdt and
								recptdt <=@vasondt and amount<0
								--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
								set @v_amt181 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt181,0);
								set @debit_amt_181 =isnull(@debit_amt_181,0)+isnull(@v_amt181,0)
							end
					fetch NEXT FROM c_bill INTO @v_bill_billno,@v_bill_billdt,@v_bill_bill_amt
					end
				close c_bill
				deallocate c_bill

			declare @cur_from_dt as datetime
			print('t')
			print(@punit_code)
			print(@fetch_pub)
			set @cur_from_dt= dateadd(dd,1,@vtodt)
			print(@cur_from_dt)
			print(@pasondt)
			print('W')
			
			select @v_amtcur=sum(amount) from cir_outmast
			where comp_code=@pcomp_code and unit_code=@punit_code and
			agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
			billdt between @cur_from_dt and @pasondt
			--and RECPTNO is null and RECPTDT is null
			print(@fetch_pub)print(@cur_from_dt)print(@pasondt) 
			--and recptdt<=@pasondt and amount<0
			
			
		
			set @v_amt=isnull(@v_amtcur,0)+ isnull(@debit_amt_030,0)+isnull(@debit_amt_3160,0)+isnull(@debit_amt_6190,0)+isnull(@debit_amt_91120,0)+isnull(@debit_amt_121180,0)+isnull(@debit_amt_181,0)
			print('@v_amt amount here')print(@v_amt)print('@@v_amt')
			if @v_amt=0 
			begin
				set @debit_amt_030 = 0
				set @debit_amt_3160 = 0
				set @debit_amt_6190 = 0
				set @debit_amt_91120 = 0
				set @debit_amt_121180 = 0
				set @debit_amt_181 = 0				
			end
			else
			begin				
				set @bill_pending_amt=isnull(@v_amt,0)
			end
			print('zzz')
		
			insert into #cir_temp_ageing (comp_code,unit_code,agcd,dpcd,ag_name,city_name,pending_amt,CUR_AMT
			, SLAB_1 ,slab_2,slab_3,slab_4,slab_5,slab_6,rect_pending,on_acamt,sessionid,PUBNAME,ageing)
			values (@rec_agency_comp_code,@punit_code,@rec_agency_agcd, @rec_agency_dpcd, @fetch_protype,
			@fetch_pubname	,isnull(@bill_pending_amt,0),isnull(@v_amtcur,0)
			,isnull(@debit_amt_030,0),isnull(@debit_amt_3160,0), isnull(@debit_amt_6190,0)
			,isnull(@debit_amt_91120,0), isnull(@debit_amt_121180,0), isnull(@debit_amt_181,0),
			isnull(0,0),0,@@spid,@fetch_pubtype,@rec_agency_ageing_type);
			print('xxx')
			fetch NEXT FROM cur_agency INTO @fetch_pub
			set @debit_amt_030 = 0
			set @debit_amt_3160 = 0
			set @debit_amt_6190 = 0
			set @debit_amt_91120 = 0
			set @debit_amt_121180 = 0
			set @debit_amt_181 = 0
			set @rcpt_pending_amt = 0
			set @bill_pending_amt = 0
		end
		close cur_agency;
	deallocate cur_agency
	
			select @v_pending_rcpt_amt=sum(amount) from cir_outmast
			where comp_code=@pcomp_code and unit_code=@punit_code and
			agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd 
			and BILLDT is null and BILLNO is null 			
			
			print('receipt amount here')print(@v_pending_rcpt_amt)print('@v_pending_rcpt_amt')
		
			

			insert into #cir_temp_ageing (comp_code,unit_code,agcd,dpcd,ag_name,city_name,pending_amt,CUR_AMT
			, SLAB_1 ,slab_2,slab_3,slab_4,slab_5,slab_6,rect_pending,on_acamt,sessionid,PUBNAME,ageing)
			values (@rec_agency_comp_code,@punit_code,@rec_agency_agcd, @rec_agency_dpcd, @fetch_protype,
			null	,isnull(0,0),isnull(0,0)
			,isnull(0,0),isnull(0,0), isnull(0,0)
			,isnull(0,0), isnull(0,0), isnull(0,0),
			isnull(@v_pending_rcpt_amt,0),0,@@spid,@fetch_pubtype,@rec_agency_ageing_type);


fetch NEXT FROM cur_agency_1 INTO @rec_agency_comp_code,@rec_agency_agcd,@rec_agency_dpcd,@rec_agency_agency_name,@rec_agency_city_code,@rec_agency_city_name,@rec_agency_credit_days,@rec_agency_branch_name,@rec_agency_ageing_type
end 
close cur_agency_1
deallocate cur_agency_1

if(@pextra1='CREDIT') 
begin
	select comp_code,unit_code,agcd,dpcd,ag_name PRO_TYPE,PUBNAME--,city_name PUBL_NAME
	,(sum(isnull(pending_amt,0)) - abs(max(ISNULL(rect_pending,0)) ) )  pending_amt,sum(isnull(cur_amt,0)) cur_amt,sum(isnull(slab_1,0)) slab_1,sum(isnull(slab_2,0)) slab_2
	,sum(isnull(slab_3,0)) slab_3,sum(isnull(slab_4,0)) slab_4,sum(isnull(slab_5,0)) slab_5,sum(isnull(slab_6,0)) slab_6,sum(isnull(rect_pending,0)) rect_pending
	,ageing
	from #cir_temp_ageing group by #cir_temp_ageing.COMP_CODE,#cir_temp_ageing.UNIT_CODE,#cir_temp_ageing.AGCD,#cir_temp_ageing.DPCD
	,#cir_temp_ageing.AG_NAME,PUBNAME,ageing
	order by PUBNAME;
end
else 
begin

	select comp_code,unit_code,agcd,dpcd,ag_name PRO_TYPE,PUBNAME--,city_name PUBL_NAME
	--,(sum(isnull(pending_amt,0)) - abs(max(ISNULL(rect_pending,0)) ) )  pending_amt
	,sum( isnull(pending_amt,0) ) - ISNULL(max(abs(rect_pending)),0)  pending_amt
	,sum(isnull(cur_amt,0)) cur_amt,sum(isnull(slab_1,0)) slab_1,sum(isnull(slab_2,0)) slab_2
	,sum(isnull(slab_3,0)) slab_3,sum(isnull(slab_4,0)) slab_4,sum(isnull(slab_5,0)) slab_5,sum(isnull(slab_6,0)) slab_6,sum(isnull(rect_pending,0)) rect_pending
	,ageing
	from #cir_temp_ageing group by #cir_temp_ageing.COMP_CODE,#cir_temp_ageing.UNIT_CODE,#cir_temp_ageing.AGCD,#cir_temp_ageing.DPCD
	,#cir_temp_ageing.AG_NAME,PUBNAME,ageing
	order by PUBNAME;

	select SUM(abs(isnull(amount,0))) as SEC_ONDT from CIR_RCPHDR where COMP_CODE=@pcomp_code
	and (UNIT_CODE=@punit_code or @punit_code is null or @punit_code ='')
	and (AGCD=@pag_main_code or @pag_main_code is null or @pag_main_code ='')
	and (DPCD=@pag_sub_code or @pag_sub_code is null or @pag_sub_code ='')
	and ACHD='SC'
	group by comp_code,unit_code,agcd,dpcd


	select SUM(abs(isnull(bg_amt,0))) as BG_ONDT from CIR_BANK_GUARANTEE where COMP_CODE=@pcomp_code
	and(UNIT_CODE=@punit_code or @punit_code is null or @punit_code ='')
	and(AGCD=@pag_main_code or @pag_main_code is null or @pag_main_code ='')
	and(DPCD=@pag_sub_code or @pag_sub_code is null or @pag_sub_code ='')
	group by comp_code,unit_code,agcd,dpcd
	drop table #cir_temp_ageing
end

***************************next

                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE [dbo].[cir_rep_agency_ledger_cir_agency_ledger_utusan]
    @pcompcode       as varchar(20),
    @punitcode       as varchar(20),
    @pactype         as varchar(20),
    @pbranchcode     as varchar(20),
    @pagency_type    as varchar(20),
    @pagcd           as varchar(20),
    @pdpcd           as varchar(20),
    @pstatecode      as varchar(20),
    @pdistcode       as varchar(20),
    @pcitycode       as varchar(20),
    @ptalukacode     as varchar(20),
    @pfrom_date      as datetime,
    @ptill_date      as datetime,
    @pbilladj_flag   as varchar(20),
    @psortedby       as varchar(20),
    @puserid         as varchar(20),
    @prowbreak       as varchar(20),
    @pdateformat     as varchar(20),
    @pextra1         as varchar(200),--it is use for agency class
    @pextra2         as varchar(200)
As
    declare @v_frdt          datetime;
    declare @v_todt          datetime;
    declare @v_opdate        datetime;
   
    declare @v_opbal         decimal(15,2)
    declare @v_opbal_sec     decimal(15,2)
    declare @v_amt           decimal(15,2)
    declare @v_clbal         decimal(15,2)
    declare @v_runbal        decimal(15,2)
    declare @v_billamt       decimal(15,2)
    declare @v_dbcramt       decimal(15,2)
    declare @v_cramt         decimal(15,2)
    declare @v_dbamt         decimal(15,2)
    declare @v_rec_seqno     int
    declare @v_remark_len    int
    declare @v_divident      int
    declare @v_narration     varchar(1000)
    declare @v_runbal_txt    varchar(20)
	
	
	declare @v1_comp_code		varchar(20)
	declare @v1_unit			varchar(20)
	declare @v1_agcd			varchar(20) 
	declare @v1_dpcd			varchar(20) 
	declare @v1_ag_name			varchar(200) 
	declare @v1_ag_name_oth_lang varchar(200)
	declare @v1_city_code		varchar(20)
	declare @v1_tehsil_taluka	varchar(20)
	declare @v1_dist_code		varchar(20)
	declare @v1_state_code		varchar(20)
    declare @v1_country_code	varchar(20)	
	declare @v1_branch_code		varchar(20)
	
	declare @v1_issue_date		datetime
	declare @v1_product_code	varchar(20)
	declare @v1_quantity		int
	declare @v1_unit_price		numeric(8,3)
	declare @v1_addr1	varchar(200)
	declare @v1_ADDR2	varchar(200)
	declare @v1_ADDR3	varchar(200)
	declare @v1_PIN_CODE	numeric(10)



	declare @v2_comp_code		varchar(20)	
	declare @v2_unit_code		varchar(20)
	declare @v2_agcd			varchar(20)
	declare @v2_dpcd			varchar(20)
	declare @v2_doctype			varchar(20)	
	declare @v2_recptno			varchar(20)
	declare @v2_recptdt			datetime
	declare @v2_amount			decimal(15,2)
	declare @v2_chno			varchar(20)
	declare @v2_chdt			datetime
	declare @v2_chbank			varchar(200)
	declare @v2_reason			varchar(200)
	declare @v2_narration		varchar(2000)
	declare @v2_received_from	varchar(200)
        
Begin
	If @punitcode='' Begin
		set @punitcode=null
	End
	If @pactype='' Begin
		set @pactype=null
	End
	If @pbranchcode='' Begin
		set @pbranchcode=null
	End
	If @pagency_type='' Begin
		set @pagency_type=null
	End
	If @pagcd='' Begin
		set @pagcd=null
	End
	If @pdpcd='' Begin
		set @pdpcd=null
	End
	If @pstatecode='' Begin
		set @pstatecode=null
	End
	If @pdistcode='' Begin
		set @pdistcode=null
	End

	If @pcitycode='' Begin
		set @pcitycode=null
	End
	If @ptalukacode='' Begin
		set @ptalukacode=null
	End
	If @pbilladj_flag='' Begin
		set @pbilladj_flag=null
	End
	If @pextra1='' Begin
		set @pextra1=null
	End
	If @pextra2='' Begin
		set @pextra2=null
	End
	If @prowbreak='' Begin
		set @prowbreak=null
	End

	set @v_opdate    =dbo.cir_get_finandt(@pcompcode,@pfrom_date,@pdateformat,null,null)--for financial date
print('%')
print(@prowbreak)
	set @v_frdt      =@pfrom_date
	set @v_todt      =@ptill_date
	set @v_divident  =isnull(@prowbreak,35)

	CREATE TABLE #CIR_LEDGER_REPORT
	( COMP_CODE      VARCHAR(10),
	  UNIT_CODE      VARCHAR(10),
	  BRANCH_CODE    VARCHAR(10),
	  DOCTYPE        VARCHAR(100),
	  AGCD           VARCHAR(50),
	  DPCD           VARCHAR(50),
	  RECPTNO        VARCHAR(50),
	  RECPTDT        DATETIME,
	  AMOUNT         decimal(14,2),
	  CHQNO          VARCHAR(50),
	  CHQDT          DATETIME,
	  CHQ_BANK       VARCHAR(100),
	  EXEC_CODE      VARCHAR(20),
	  REMARKS        VARCHAR(500),
	  REASON         VARCHAR(30),
	  BILLNO         VARCHAR(50),
	  BILLDT         DATETIME,
	  BILLAMT        DECIMAL(14,2),
	  ADJAMT         DECIMAL(14,2),
	  LEFTAMT        DECIMAL(14,2),
	  DEBIT_HEAD     VARCHAR(200),
	  CREDIT_HEAD    VARCHAR(200),
	  REC_SEQNO      INT,
	  RECOVARY_DAYS  INT,
	  AGNAME         VARCHAR(500),
	  OPBAL_SEC      DECIMAL(14,2),
	  NARR_LINE      INT,
	  ISSUE_DATE     DATETIME,
	  PRODUCT        VARCHAR(200),
	  QUANTITY       INT,
	  UNIT_PRICE     NUMERIC(8,3),
	  addr1			 varchar(200),
	  ADDR2			 varchar(200),
	  ADDR3			 varchar(200),
	  PIN_CODE       numeric(10)
	  )
print('8')
create table #cir_summary_statement
(
comp_code varchar(20),
unit_code varchar(20),
PUBL_code varchar(20),
EDTN_code varchar(20),
PUBL_NAME varchar(200),
EDTN_NAME varchar(200),
AGCD varchar(20),
DPCD varchar(20),
INV_QTY  numeric(12),
INV_AMT  numeric(14,2),
RET_QTY  numeric(12),
RET_AMT  numeric(14,2),
INSERT_LATE numeric(14,2),
REMARK    varchar(200),
TOTAL numeric(14,2)
)	
declare @sum_ag_comp_code as varchar(20)
declare @sum_ag_unit as varchar(20)
declare @sum_ag_agcd as varchar(20)
declare @sum_ag_dpcd as varchar(20)
declare @sum_ag_ag_name	 as varchar(200)
declare @sum_publ_publ	 as varchar(200)
declare @sum_edtn	 as varchar(200)
declare @sum_edtn_name	 as varchar(200)

declare @v_invqty as numeric(12)
declare @v_invamt as numeric(14,2)
declare @v_retqty as numeric(12)
declare @v_retamt as numeric(14,2)
declare @v_late_ins as numeric(14,2)
declare @v_publ_tot as numeric(14,2)
declare @v_payment as  numeric(14,2)
declare @v_dn_chq as numeric(14,2)					
declare @v_dn_nom as numeric(14,2)					
declare @v_cn as numeric(14,2)

declare @v_tot_inv as numeric(14,2)
declare @v_tot_ucn as numeric(14,2)
declare @v_close_bal as numeric(14,2)

	if @pextra2 ='S'
	begin
		declare sum_ag cursor for
			select distinct comp_code,unit,agcd,dpcd,ag_name from cir_agmast  
			where comp_code = @pcompcode and (unit=@punitcode or @punitcode is null) 
			and (ag_type=@pagency_type or @pagency_type is null) 
			and agcd+dpcd in(select distinct agcd+dpcd from cir_outmast 
							where comp_code = @pcompcode and (unit_code=@punitcode or @punitcode is null) and achd=@pactype) 
			and (agcd=@pagcd or @pagcd is null) 
			and (dpcd=@pdpcd or @pdpcd is null) 			
			and (branch_code=@pbranchcode or @pbranchcode is null) 
			and (state_code=@pstatecode or @pstatecode is null) 
			and (dist_code=@pdistcode or @pdistcode is null) 
			and (tehsil_taluka=@ptalukacode or @ptalukacode is null) 			
			and (ag_class=@pextra1 or @pextra1 is null)
			order by comp_code,unit,ag_name;
	
	
			open sum_ag
				fetch NEXT FROM sum_ag INTO @sum_ag_comp_code,@sum_ag_unit,@sum_ag_agcd,@sum_ag_dpcd,@sum_ag_ag_name
				WHILE (@@FETCH_STATUS = 0) Begin
					set @v_opbal=0
					set @v_close_bal=0
					set @v_opbal =dbo.cir_accounts_cir_agency_opbal(@pcompcode, @punitcode,null,@sum_ag_agcd, @sum_ag_dpcd, @v_opdate, 'NM',@pdateformat,null,null)
					set @v_dbcramt=0					
				
							select @v_billamt=sum(amount) from cir_outmast
								where comp_code = @pcompcode and unit_code=@punitcode and 
									agcd=@sum_ag_agcd and dpcd=@sum_ag_dpcd and billdt >= @v_opdate and billdt<@v_frdt and 
									achd='NM' and recptno is null

							select @v_dbcramt=sum(amount) from cir_rcpdet
								where comp_code=@pcompcode and unit_code=@punitcode and 
									agcd=@sum_ag_agcd and dpcd=@sum_ag_dpcd and recptdt>= @v_opdate and recptdt<@v_frdt and 
									achd='NM' and billno is null

							set @v_opbal=isnull(@v_opbal,0)+isnull(@v_billamt,0)+isnull(@v_dbcramt,0)
			------------------  insert BF ----------------
			insert into #cir_summary_statement(comp_code,unit_code,PUBL_code,EDTN_code,PUBL_NAME,EDTN_NAME,
						AGCD,DPCD,INV_QTY,INV_AMT,RET_QTY,RET_AMT,INSERT_LATE,REMARK,TOTAL)	
			values (@sum_ag_comp_code,@sum_ag_unit,null,null,'Balance B/F',null,@sum_ag_agcd,@sum_ag_dpcd
					,null,null,null,null,null,null,@v_opbal)
			---------------------------------------------		
			set @v_close_bal=@v_opbal
			set @v_tot_inv =0
			set @v_tot_ucn =0

					declare sum_publ cursor for
						select distinct  publ,pro_type,publ_name from cir_publ_mast
						where comp_code = @pcompcode --and (unit_code=@punitcode or @punitcode is null) 
						order by pro_type
						
						open sum_publ
							fetch NEXT FROM sum_publ INTO @sum_publ_publ,@sum_edtn,@sum_edtn_name
							WHILE (@@FETCH_STATUS = 0) Begin
								select @v_invqty=SUM(isnull(bill_copy,0))
								,@v_invamt=sum(isnull(bill_amount,0))								
								from cir_bill where COMP_CODE=@sum_ag_comp_code
								and UNIT_CODE=@sum_ag_unit and AGCD=@sum_ag_agcd and DPCD=@sum_ag_dpcd
								and BILLDT between @v_frdt and @v_todt
								and PUBL=@sum_publ_publ 
								
								select @v_retqty=sum(ISNULL(APR_BNR,0))+sum(ISNULL(APR_DAMAGE,0))+sum(ISNULL(APR_LATE_RECPT,0))+
								sum(ISNULL(APR_SHORT_RECPT,0))+sum(ISNULL(APR_UNSOLD,0)) 
								,@v_retamt =SUM(isnull(copy_amt,0)) from CIR_UNSOLD_DTL 
								where COMP_CODE=@sum_ag_comp_code and UNIT_CODE=@sum_ag_unit 
								and AGCD=@sum_ag_agcd and DPCD=@sum_ag_dpcd and PUBL=@sum_publ_publ 
								and APP_DT between @v_frdt and @v_todt
								and (PROCESS_CRNO is not null or PROCESS_CRNO!='')
								and (PROCESS_CRDT is not null or PROCESS_CRDT!='')
								
								select @v_late_ins=SUM(isnull(abs(AMOUNT),0)) from cir_rcphdr 
								where COMP_CODE=@sum_ag_comp_code and UNIT_CODE=@sum_ag_unit 
								and AGCD=@sum_ag_agcd and DPCD=@sum_ag_dpcd and PUBL=@sum_publ_publ 
								and RECPTDT between @v_frdt and @v_todt
								
								set @v_publ_tot=isnull(@v_invamt,0)+(-1*ISNULL(@v_retamt,0))+(-1*ISNULL(@v_late_ins,0))
								------------------  insert product summary ----------------
								if isnull(@v_invamt ,0) !=0 or isnull(@v_retamt ,0) !=0 or isnull(@v_late_ins ,0) !=0
								begin
									insert into #cir_summary_statement(comp_code,unit_code,PUBL_code,EDTN_code,PUBL_NAME,EDTN_NAME,
												AGCD,DPCD,INV_QTY,INV_AMT,RET_QTY,RET_AMT,INSERT_LATE,REMARK,TOTAL)	
									values (@sum_ag_comp_code,@sum_ag_unit,@sum_publ_publ,@sum_edtn,@sum_edtn_name,null,@sum_ag_agcd,@sum_ag_dpcd
											,@v_invqty,@v_invamt,@v_retqty,@v_retamt,@v_late_ins,null,@v_publ_tot)
								set @v_close_bal=	@v_close_bal+(@v_publ_tot)
								set @v_tot_inv =@v_tot_inv+@v_invamt
								set @v_tot_ucn =@v_tot_ucn+@v_retamt
								end
								---------------------------------------------
								
								
							fetch NEXT FROM sum_publ INTO @sum_publ_publ,@sum_edtn,@sum_edtn_name
							End

						close sum_publ
						deallocate sum_publ
					------------------------ just for  total----------------
					if isnull(@v_tot_inv ,0) !=0 or isnull(@v_tot_ucn ,0) !=0 
					begin
						insert into #cir_summary_statement(comp_code,unit_code,PUBL_code,EDTN_code,PUBL_NAME,EDTN_NAME,
									AGCD,DPCD,INV_QTY,INV_AMT,RET_QTY,RET_AMT,INSERT_LATE,REMARK,TOTAL)	
						values (@sum_ag_comp_code,@sum_ag_unit,null,null,null,null,@sum_ag_agcd,@sum_ag_dpcd
								,null,@v_tot_inv,null,@v_tot_ucn,null,null,null)
					end
					
					select @v_dn_chq=SUM(isnull(abs(amount),0)) from CIR_RCPHDR 
					where COMP_CODE=@sum_ag_comp_code and UNIT_CODE=@sum_ag_unit 
					and AGCD=@sum_ag_agcd and DPCD=@sum_ag_dpcd and DOCTYPE='DN' and REASON='CH0'
					and RECPTDT between @v_frdt and @v_todt					
									
					------------------  insert DN CHQ Bounce summary ----------------
					if isnull(@v_dn_chq ,0) !=0 
					begin
						insert into #cir_summary_statement(comp_code,unit_code,PUBL_code,EDTN_code,PUBL_NAME,EDTN_NAME,
							AGCD,DPCD,INV_QTY,INV_AMT,RET_QTY,RET_AMT,INSERT_LATE,REMARK,TOTAL)	
						values (@sum_ag_comp_code,@sum_ag_unit,null,null,'CHEQUE BOUNCED',null,@sum_ag_agcd,@sum_ag_dpcd
								,null,null,null,null,null,null,@v_dn_chq)
					set @v_close_bal=	@v_close_bal+(@v_dn_chq)
					end
					
					---------------------------------------------	
					
					select @v_dn_nom=SUM(isnull(abs(amount),0)) from CIR_RCPHDR 
					where COMP_CODE=@sum_ag_comp_code and UNIT_CODE=@sum_ag_unit 
					and AGCD=@sum_ag_agcd and DPCD=@sum_ag_dpcd and DOCTYPE='DN' and REASON!='CH0'					
					and RECPTDT between @v_frdt and @v_todt				
					------------------  insert DN summary ----------------
					if isnull(@v_dn_nom ,0) !=0 
					begin
						insert into #cir_summary_statement(comp_code,unit_code,PUBL_code,EDTN_code,PUBL_NAME,EDTN_NAME,
							AGCD,DPCD,INV_QTY,INV_AMT,RET_QTY,RET_AMT,INSERT_LATE,REMARK,TOTAL)	
						values (@sum_ag_comp_code,@sum_ag_unit,null,null,'DEBIT NOTE',null,@sum_ag_agcd,@sum_ag_dpcd
								,null,null,null,null,null,null,@v_dn_nom)
					set @v_close_bal=	@v_close_bal+(@v_dn_nom)
					end
					
					---------------------------------------------	
					
					select @v_cn=SUM(isnull(abs(amount),0)) from CIR_RCPHDR 
					where COMP_CODE=@sum_ag_comp_code and UNIT_CODE=@sum_ag_unit 
					and AGCD=@sum_ag_agcd and DPCD=@sum_ag_dpcd and DOCTYPE='CN'					
					and RECPTDT between @v_frdt and @v_todt				
					------------------  insert CN summary ----------------
					if isnull(@v_cn ,0) !=0 
					begin
						insert into #cir_summary_statement(comp_code,unit_code,PUBL_code,EDTN_code,PUBL_NAME,EDTN_NAME,
							AGCD,DPCD,INV_QTY,INV_AMT,RET_QTY,RET_AMT,INSERT_LATE,REMARK,TOTAL)	
						values (@sum_ag_comp_code,@sum_ag_unit,null,null,'CREDIT NOTE',null,@sum_ag_agcd,@sum_ag_dpcd
								,null,null,null,null,null,null,@v_cn)
					set @v_close_bal=	@v_close_bal+(-1*@v_cn)
					end
					
					---------------------------------------------
					
					select @v_payment=SUM(isnull(abs(amount),0)) from CIR_RCPHDR 
					where COMP_CODE=@sum_ag_comp_code and UNIT_CODE=@sum_ag_unit 
					and AGCD=@sum_ag_agcd and DPCD=@sum_ag_dpcd and DOCTYPE='RCR' and ACHD	= 'NM'				
					and RECPTDT between @v_frdt and @v_todt				
					------------------  insert PAYMENT summary ----------------
					if isnull(@v_payment ,0) !=0 
					begin
						insert into #cir_summary_statement(comp_code,unit_code,PUBL_code,EDTN_code,PUBL_NAME,EDTN_NAME,
							AGCD,DPCD,INV_QTY,INV_AMT,RET_QTY,RET_AMT,INSERT_LATE,REMARK,TOTAL)	
						values (@sum_ag_comp_code,@sum_ag_unit,null,null,'PAYMENT',null,@sum_ag_agcd,@sum_ag_dpcd
								,null,null,null,null,null,null,@v_payment)
					set @v_close_bal=	@v_close_bal+(-1*@v_payment)
					end
					
					---------------------------------------------	
				
				if isnull(@v_close_bal ,0) !=0 
				begin
					insert into #cir_summary_statement(comp_code,unit_code,PUBL_code,EDTN_code,PUBL_NAME,EDTN_NAME,
						AGCD,DPCD,INV_QTY,INV_AMT,RET_QTY,RET_AMT,INSERT_LATE,REMARK,TOTAL)	
					values (@sum_ag_comp_code,@sum_ag_unit,null,null,'BALANCE C/F',null,@sum_ag_agcd,@sum_ag_dpcd
							,null,null,null,null,null,null,@v_close_bal)
				end
				
				fetch NEXT FROM sum_ag INTO @sum_ag_comp_code,@sum_ag_unit,@sum_ag_agcd,@sum_ag_dpcd,@sum_ag_ag_name
				End

			close sum_ag
			deallocate sum_ag
	
	select *,dbo.cir_get_agency(COMP_CODE,UNIT_CODE,AGCD,DPCD) AS AGENCYNAME	
	,dbo.cir_get_contact_person(COMP_CODE,AGCD,DPCD) AS CONTACT
	,dbo.cir_get_agency_add(COMP_CODE,AGCD,DPCD,'','') AS ADDR
	 from #cir_summary_statement order by AGCD,DPCD
	
	end
	else
	begin
declare @v1_commrate as numeric(14,2)
		declare c1 cursor for
				select distinct comp_code,unit,agcd,dpcd,ag_name,ag_name_oth_lang,city_code,tehsil_taluka,dist_code,state_code,
					country_code,branch_code,addr1,ADDR2,ADDR3,PIN_CODE from cir_agmast 
						where comp_code = @pcompcode and (unit=@punitcode or @punitcode is null) and 
									(ag_type=@pagency_type or @pagency_type is null) and agcd+dpcd in(select distinct agcd+dpcd from cir_outmast 
									where comp_code = @pcompcode and (unit_code=@punitcode or @punitcode is null) and achd=@pactype) and 
									(agcd=@pagcd or @pagcd is null) and (dpcd=@pdpcd or @pdpcd is null) and (branch_code=@pbranchcode or @pbranchcode is null) and
									(state_code=@pstatecode or @pstatecode is null) and (dist_code=@pdistcode or @pdistcode is null) and 
									(tehsil_taluka=@ptalukacode or @ptalukacode is null) and (ag_class=@pextra1 or @pextra1 is null)
									order by branch_code,city_code,ag_name;
		  
				--select distinct a.comp_code,a.unit,a.agcd,a.dpcd,a.ag_name,a.ag_name_oth_lang,a.city_code
				--,a.tehsil_taluka,a.dist_code,a.state_code, a.country_code,a.branch_code 
				--,x.supdate,x.publ,x.sup_copy,x.sup_rate,a.addr1,a.ADDR2,a.ADDR3,a.PIN_CODE
				--from cir_agmast a,cir_dbksup x
				--where a.comp_code=x.comp_code and x.UNIT_CODE=a.UNIT and A.AGCD  = x.AGCD and A.DPCD  = x.DPCD and
				-- a.comp_code = @pcompcode and (a.unit=@punitcode or @punitcode is null) and 
				--(a.ag_type=@pagency_type or @pagency_type is null) and a.agcd+a.dpcd in(select distinct agcd+dpcd from cir_outmast 
				--where comp_code = @pcompcode and (unit_code=@punitcode or @punitcode is null) and achd=@pactype) and 
				--(a.agcd=@pagcd or @pagcd is null) and (a.dpcd=@pdpcd or @pdpcd is null) and (a.branch_code=@pbranchcode or @pbranchcode is null) and
				--(a.state_code=@pstatecode or @pstatecode is null) and (a.dist_code=@pdistcode or @pdistcode is null) and 
				--(a.tehsil_taluka=@ptalukacode or @ptalukacode is null) and (a.ag_class=@pextra1 or @pextra1 is null)
				--order by a.branch_code,a.city_code,a.ag_name;
		  
			open c1
				fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit,@v1_agcd,@v1_dpcd,@v1_ag_name,@v1_ag_name_oth_lang,@v1_city_code,@v1_tehsil_taluka,@v1_dist_code,@v1_state_code,@v1_country_code,@v1_branch_code,@v1_addr1,@v1_ADDR2,@v1_ADDR3,@v1_PIN_CODE
				WHILE (@@FETCH_STATUS = 0)  Begin
				set @v_opbal =dbo.cir_accounts_cir_agency_opbal(@pcompcode, @punitcode,null,@v1_agcd, @v1_dpcd, @v_opdate, @pactype,@pdateformat,null,null)
		print('@')
				----for secutiry outstanding---
				If @pactype='SC' Begin
					set @v_opbal_sec	=dbo.cir_accounts_cir_agency_opbal(@pcompcode, @punitcode,null,@v1_agcd,@v1_dpcd,@v_opdate,'SC',@pdateformat,null,null)

					select @v_dbcramt	=sum(amount) from cir_rcphdr
					where comp_code = @pcompcode and unit_code= @punitcode and 
						agcd=@v1_agcd and dpcd=@v1_dpcd and recptdt>= @v_opdate and recptdt<=@v_todt and achd='SC'

					set @v_opbal_sec=isnull(@v_opbal_sec,0)+isnull(@v_dbcramt,0)
				End
				Else Begin
					set @v_opbal_sec =0
				End

				----for secutiry outstanding---
				set @v_dbcramt=0

				select @v_billamt=sum(amount) from cir_outmast
					where comp_code = @pcompcode and unit_code=@punitcode and 
						agcd=@v1_agcd and dpcd=@v1_dpcd and billdt >= @v_opdate and billdt<@v_frdt and 
						achd=@pactype and recptno is null

				select @v_dbcramt=sum(amount) from cir_rcpdet
					where comp_code=@pcompcode and unit_code=@punitcode and 
						agcd=@v1_agcd and dpcd=@v1_dpcd and recptdt>= @v_opdate and recptdt<@v_frdt and 
						achd=@pactype and billno is null

				set @v_opbal=isnull(@v_opbal,0)+isnull(@v_billamt,0)+isnull(@v_dbcramt,0)

				set @v_rec_seqno=isnull(@v_rec_seqno,0)+1

				insert into #cir_ledger_report
					(comp_code,unit_code,branch_code,agcd,dpcd,doctype,recptno,recptdt,amount,
					exec_code,remarks,chqno,chqdt,chq_bank,reason,debit_head,credit_head,
					billno,billdt,billamt,adjamt,leftamt,agname,rec_seqno,narr_line
					,ISSUE_DATE,PRODUCT,QUANTITY,UNIT_PRICE,addr1,ADDR2,ADDR3,PIN_CODE)
				values(@v1_comp_code,@v1_unit,@v1_branch_code,@v1_agcd,@v1_dpcd,null,null,@v_frdt,@v_opbal_sec,
					null,'Security Balance',null,null,null,null,null,null,
					null,null,null,null,null,@v1_ag_name,@v_rec_seqno,1,null,null,null,null,@v1_addr1,@v1_ADDR2,@v1_ADDR3,@v1_PIN_CODE)

				set @v_rec_seqno = isnull(@v_rec_seqno,0)+1

				set @v_runbal = @v_opbal
		            
				If @v_runbal>=0 Begin
					set @v_runbal_txt= CONVERT(VARCHAR, CONVERT( numeric(14, 2), @v_runbal ))--+' Dr.'
				End
				Else Begin
					set @v_runbal_txt=CONVERT(VARCHAR, CONVERT( numeric(14, 2), ABS(@v_runbal) ))--+' Cr.'
				End
		            
				insert into #cir_ledger_report
					(comp_code,unit_code,branch_code,agcd,dpcd,doctype,recptno,recptdt,amount,
					exec_code,remarks,chqno,chqdt,chq_bank,reason,debit_head,credit_head,
					billno,billdt,billamt,adjamt,leftamt,agname,rec_seqno,narr_line,ISSUE_DATE,PRODUCT,QUANTITY,UNIT_PRICE,addr1,ADDR2,ADDR3,PIN_CODE)
				values(@v1_comp_code,@v1_unit,@v1_branch_code,@v1_agcd,@v1_dpcd,null,null,@v_frdt,@v_opbal,
					null,'Opening Balance',null,null,null,null,null,null,
					null,null,null,null,null,@v1_ag_name,@v_rec_seqno,2,null,null,null,null,@v1_addr1,@v1_ADDR2,@v1_ADDR3,@v1_PIN_CODE)
		 
		 print('set')print(@v1_unit)print(@v1_agcd) print(@v1_dpcd) print(@v_frdt) print(@v_todt) print(@pactype)       

				declare c2 cursor for
					select u.comp_code comp_code,u.unit_code unit_code,u.agcd agcd,u.dpcd dpcd,u.doctype doctype,u.recptno recptno,u.recptdt recptdt,u.amount amount,u.chno chno,u.chdt chdt,u.chbank chbank,u.reason reason,
					u.narration narration,u.received_from received_from from 
					(select comp_code,unit_code,agcd,dpcd,doctype,recptno,recptdt,amount,chno,chdt,chbank,reason,remark narration,received_from from cir_rcphdr
						where comp_code=@v1_comp_code and unit_code=@v1_unit and agcd=@v1_agcd and dpcd=@v1_dpcd and recptdt 
							between @v_frdt and @v_todt and case isnull( achd,'NM')  when '' then 'NM' else achd end=@pactype
					union all
					select comp_code,unit_code,agcd,dpcd,'BIL' doctype,billno recptno,billdt recptdt,sum(bill_amount) amount,null chno,null chdt,null chbnk,'BILL' reason,
					'Bill Copy '+ cast(sum(bill_copy) as VARCHAR)+' Trade Disc. '+cast(sum(comm_amount) as VARCHAR) narration,null received_from from cir_bill
						where comp_code=@v1_comp_code and unit_code=@v1_unit and agcd=@v1_agcd and dpcd=@v1_dpcd and 
							billdt between @v_frdt and @v_todt and (@pactype='NM' or @pactype is null or @pactype ='')
							group by comp_code,unit_code,agcd,dpcd,billno,billdt
					/*union all
					select comp_code,unit_code,agcd,dpcd,doctyp doctype,billno recptno,billdt recptdt,sum(amount) amount,null chno,null chdt,null chbnk, reason,
					remark narration,null received_from from cir_outmast
						where comp_code=@v1_comp_code and unit_code=@v1_unit and agcd=@v1_agcd and dpcd=@v1_dpcd and 
							billdt between @v_frdt and @v_todt and @pactype='NM' and isnull(amount,0)>0 and billno is null 
							group by comp_code,unit_code,agcd,dpcd,billno,billdt,doctyp,reason,remark		*/
							)u
					order by recptdt,doctype,recptno
					
				declare @vbillno_rcr as varchar(40)
				declare @vbilldt_rcr as datetime
				--------daily transactions------------
					open c2
					fetch NEXT FROM c2 INTO @v2_comp_code,@v2_unit_code,@v2_agcd,@v2_dpcd,@v2_doctype,@v2_recptno,@v2_recptdt,@v2_amount,@v2_chno,@v2_chdt,@v2_chbank,@v2_reason,@v2_narration,@v2_received_from
					WHILE (@@FETCH_STATUS = 0) Begin
						
						If isnull(@v2_amount,0)<>0 Begin
							set @v_rec_seqno=isnull(@v_rec_seqno,0)+1
							set @v_narration=null
								If @v2_doctype='BIL' Begin
									set @v_narration=@v2_narration
									select distinct @v1_issue_date=TODT,@v1_product_code=PUBL,@v1_quantity=sum(BILL_COPY)
									,@v1_unit_price=COPY_RATE,@v1_commrate=COMM_RATE from cir_bill_det
									where COMP_CODE=@pcompcode and UNIT_CODE=@v2_unit_code and BILLNO=@v2_recptno and BILLDT=@v2_recptdt and AGCD=@v2_agcd and DPCD=@v2_dpcd
									group by TODT,PUBL,COPY_RATE,COMM_RATE
								End
								else If @v2_doctype='UCN' Begin
									set @v_narration=@v2_narration
									select distinct @v1_issue_date=SUPDATE,@v1_product_code=PUBL,@v1_quantity=sum(APR_BNR+APR_DAMAGE+APR_LATE_RECPT+APR_SHORT_RECPT+APR_UNSOLD)
									,@v1_unit_price=COPY_RATE,@v1_commrate=COMM_RATE from CIR_UNSOLD_DTL
									where COMP_CODE=@pcompcode and UNIT_CODE=@v2_unit_code and PROCESS_CRNO=@v2_recptno and AGCD=@v2_agcd and DPCD=@v2_dpcd
									group by SUPDATE,PUBL,COPY_RATE,COMM_RATE
								End
								else If @v2_doctype='RCR' Begin
									print('Payment received' + @v2_recptno)
									select @vbillno_rcr=max(BILLNO),@vbilldt_rcr=max(BILLDT) from CIR_OUTMAST where RECPTNO='BA1-13010001' and DOCTYP='RCR' and BILLNO is not null and BILLDT is not null 
									select distinct @v1_issue_date=TODT,@v1_product_code=PUBL,@v1_quantity=sum(BILL_COPY)
									,@v1_unit_price=COPY_RATE,@v1_commrate=COMM_RATE from cir_bill_det
									where COMP_CODE=@pcompcode and UNIT_CODE=@v2_unit_code and BILLNO=@vbillno_rcr and BILLDT=@vbilldt_rcr and AGCD=@v2_agcd and DPCD=@v2_dpcd
									group by TODT,PUBL,COPY_RATE,COMM_RATE
									
								end
								Else  
								Begin
										set @v1_issue_date=null
										set @v1_product_code=null
										set @v1_quantity=null
										set @v1_unit_price=null
										set @v1_commrate=null
									If @v2_narration is not null 
									Begin
										set @v_narration=@v2_narration
													
										If @v2_chno is not null and @v2_chno !=''
										Begin
											set @v_narration=@v_narration+' CHNO# '+@v2_chno
										End
										If @v2_chdt is not null and @v2_chdt !=''
										Begin
											set @v_narration=@v_narration+' CHDT '+ cast(@v2_chdt as varchar)
										End
										If @v2_chbank is not null and @v2_chbank !=''
										Begin
											set @v_narration=@v_narration+' CHBNK '+@v2_chbank
										End
										If @v2_reason='CA0' and @v2_doctype='RCR' 
										Begin
											set @v_narration='By Cash '+@v_narration
										End
									End
								End
						End	
						Else 
						Begin print('test')
							If @v2_chno is not null and @v2_chno !=''
							Begin
								set @v_narration='CHNO# '+@v2_chno
							End
							If @v2_chdt is not null  and @v2_chdt !=''
							Begin
								set @v_narration =@v_narration+' CHDT '+ DBO.convert_user_date('/',@v2_chdt,@pdateformat)  
							End
							If @v2_chbank is not null  and @v2_chbank !=''
							Begin
								set @v_narration=@v_narration+' CHBANK '+@v2_chbank
							End
							If @v2_reason='CA0' and @v2_doctype='RCR' 
							Begin
								set @v_narration='By Cash '+@v_narration
							End
						End

					set @v_remark_len = LEN(ISNULL(LTRIM(RTRIM(@v_narration)), '-'))
					set @v_amt=isnull(@v_amt,0)+isnull(@v2_amount,0)
					                    

					set @v_runbal = @v_runbal+isnull(@v2_amount,0)

					If @v_runbal>=0 Begin
						set @v_runbal_txt= CONVERT(VARCHAR, CONVERT( numeric(14, 2), @v_runbal ))--+' Dr.'
					End
					Else Begin
						set @v_runbal_txt=CONVERT(VARCHAR, CONVERT( numeric(14, 2), (@v_runbal) ))--+' Cr.'
					End
					                                        
					If isnull(@v2_amount,0)>=0 Begin
						set @v_dbamt=isnull(@v_dbamt,0)+isnull(@v2_amount,0)
					End
					If isnull(@v2_amount,0)<0 Begin
						set @v_cramt=isnull(@v_cramt,0)+abs(isnull(@v2_amount,0))
					End

					
					
		print('#')	
		print(@v_remark_len)
		print(@v_divident)	
		
		set @v1_unit_price=round(@v1_unit_price-((isnull(@v1_unit_price,0)*isnull(@v1_commrate,1))/100),3)
			
					insert into #cir_ledger_report
						  (comp_code,unit_code,branch_code,agcd,dpcd,doctype,recptno,recptdt,amount,
						  exec_code,remarks,chqno,chqdt,chq_bank,reason,debit_head,credit_head,
						  billno,billdt,billamt,adjamt,leftamt,agname,rec_seqno,narr_line
						  ,ISSUE_DATE,PRODUCT,QUANTITY,UNIT_PRICE,addr1,ADDR2,ADDR3,PIN_CODE)
					  values(@v1_comp_code, @v1_unit, @v1_branch_code, @v1_agcd, @v1_dpcd, @v2_doctype, @v2_recptno, @v2_recptdt, @v2_amount,
							 @v2_received_from,isnull(ltrim(rtrim(@v_narration)),'-'), @v2_chno, @v2_chdt, @v2_chbank, @v2_reason,null, @v_runbal_txt,
							 null, null, null, null, @v_runbal, @v1_ag_name, @v_rec_seqno, dbo.mod_function(@v_remark_len, @v_divident)
							 ,@v1_issue_date,@v1_product_code,@v1_quantity,@v1_unit_price,@v1_addr1,@v1_ADDR2,@v1_ADDR3,@v1_PIN_CODE)
		print('$')
					fetch NEXT FROM c2 INTO @v2_comp_code,@v2_unit_code,@v2_agcd,@v2_dpcd,@v2_doctype,@v2_recptno,@v2_recptdt,@v2_amount,@v2_chno,@v2_chdt,@v2_chbank,@v2_reason,
					@v2_narration,@v2_received_from
				End

				close c2
				deallocate c2
				
				--------daily transactions------------
		            
				
print('ggg')print(@v_runbal)
				set @v_rec_seqno=isnull(@v_rec_seqno,0)+1
				If @v_runbal>=0 Begin
					set @v_runbal_txt= CONVERT(VARCHAR, CONVERT( numeric(14, 2), @v_runbal )) --+' Dr.'
				End
				Else Begin
					set @v_runbal_txt= CONVERT(VARCHAR, CONVERT( numeric(14, 2), (@v_runbal) )) --+' Cr.'
				End
print('gggqq')print(@v_runbal_txt)
					insert into #cir_ledger_report
					(comp_code,unit_code,branch_code,agcd,dpcd,doctype,recptno,recptdt,amount,
					exec_code,remarks,chqno,chqdt,chq_bank,reason,debit_head,credit_head,
					billno,billdt,billamt,adjamt,leftamt,agname,rec_seqno,narr_line,ISSUE_DATE,PRODUCT,QUANTITY,UNIT_PRICE,addr1,ADDR2,ADDR3,PIN_CODE)
					values(@v1_comp_code, @v1_unit, @v1_branch_code, @v1_agcd, @v1_dpcd, null, null, @v_todt,isnull(@v_clbal,0),
					null,'Closing Balance',null,null,null,null,null,null,
					null,null,null,null,null, @v1_ag_name, @v_rec_seqno,1,@v1_issue_date,@v1_product_code,@v1_quantity,@v1_unit_price,@v1_addr1,@v1_ADDR2,@v1_ADDR3,@v1_PIN_CODE)

				If isnull(@v_opbal_sec,0)=0 and isnull(@v_opbal,0)=0 and @v_cramt=0 and @v_dbamt=0 Begin
				   delete from #cir_ledger_report where comp_code = @v1_comp_code and unit_code = @v1_unit and
					agcd = @v1_agcd and dpcd = @v1_dpcd
				End

				set @v_billamt=0 set @v_dbcramt=0 set @v_opbal=0 set @v_clbal=0 set @v_amt=0 set @v_runbal=0 set @v_cramt=0 set @v_dbamt=0 set @v_runbal_txt=null
		        
				fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit,@v1_agcd,@v1_dpcd,@v1_ag_name,@v1_ag_name_oth_lang,@v1_city_code,@v1_tehsil_taluka,@v1_dist_code,@v1_state_code,
					@v1_country_code,@v1_branch_code,@v1_addr1,@v1_ADDR2,@v1_ADDR3,@v1_PIN_CODE
				End

				close c1
				DEALLOCATE c1
		/*
		SELECT (SELECT distinct Comp_Name FROM  comp_mst WHERE Comp_Code  = a.comp_code) as "CNAME",
		COMP_CODE,UNIT_CODE,BRANCH_CODE,(select distinct "Branch_Name" from branch_mst where Comp_Code=a.Comp_Code and "Branch_Code"=a.BRANCH_CODE) "BRANCH_NAME",
		AGCD,DPCD,AGNAME,DBO.cir_get_agency_city(comp_code,unit_code,agcd,dpcd) CITY_NAME,
		DOCTYPE,RECPTNO,RECPTDT,
		CASE a.debit WHEN 'D' THEN a.amount END as DEBIT,
		CASE a.credit WHEN 'C' THEN a.amount END as CREDIT,
		EXEC_CODE,REMARKS,CHQNO,CHQDT,CHQ_BANK,REASON,DEBIT_HEAD,CREDIT_HEAD,BILLNO,BILLDT,BILLAMT,
		ADJAMT,LEFTAMT,REC_SEQNO,narr_line
		,a.ISSUE_DATE as ISSUE_DATE,(Select distinct PUBL_NAME from CIR_PUBL_MAST p where p.COMP_CODE=@pcompcode and p.PUBL=a.PRODUCT) as PRODUCT
		,a.QUANTITY,a.UNIT_PRICE,a.addr1,a.ADDR2,a.ADDR3,a.PIN_CODE
		FROM (SELECT comp_code,unit_code,branch_code,agcd,dpcd,agname,doctype,recptno,recptdt,
		CASE sign(amount) WHEN 1 THEN 'D' END as debit,
		CASE sign(amount) WHEN - 1 THEN 'C' END as credit,
		 ABS(amount) as amount,exec_code,remarks,chqno,chqdt,chq_bank,reason,debit_head,credit_head,
		 billno,billdt,billamt,adjamt,leftamt,rec_seqno,ISNULL(narr_line, 1) as narr_line
		 ,ISSUE_DATE,PRODUCT,QUANTITY,UNIT_PRICE,addr1,ADDR2,ADDR3,PIN_CODE
		FROM  #cir_ledger_report 
		WHERE comp_code  = @pcompcode AND unit_code  = @punitcode) a 
		ORDER BY rec_seqno 
		*/

			SELECT (SELECT distinct Comp_Name FROM  comp_mst WHERE Comp_Code  = a.comp_code) as "CNAME",
			COMP_CODE,UNIT_CODE,BRANCH_CODE
			,(select distinct "Branch_Name" from branch_mst where Comp_Code=a.Comp_Code and "Branch_Code"=a.BRANCH_CODE) "BRANCH_NAME",
			AGCD,DPCD,AGNAME,DBO.cir_get_agency_city(comp_code,unit_code,agcd,dpcd) CITY_NAME,
			case DOCTYPE
			when 'BIL' then 'INVOICE'
			when 'RCR' then 'PAYMENT'
			when 'UCN' then 
				case REASON 
				when 'NO0' then 'RETURN[Pulangan Biasa]'
				when 'UNSOLD CREDIT NOTE' then 'RETURN[Pulangan Biasa]'
				else isnull((Select reason_name from CIR_REASON_MST t where t.COMP_CODE=a.COMP_CODE and t.REASON_CODE=a.REASON ),'UNSOLD CREDIT NOTE') end
			when 'DN' then 
				case REASON
				when 'CH0' then 'Return Cheque'				
				else isnull(REMARKS,(Select reason_name from CIR_REASON_MST t where t.COMP_CODE=a.COMP_CODE and t.REASON_CODE=a.REASON )) end 	
			when 'CN' then
				case isnull(REMARKS,'~')
				when '' then reason
				when '~' then reason				
				else REMARKS end
			end DOCTYPE
			,RECPTNO,case @pdateformat			
			when 'dd/mm/yyyy' then CONVERT(varchar(10),RECPTDT,103)
			when 'mm/dd/yyyy' then CONVERT(varchar(10),RECPTDT,101)
			when 'yyyy/mm/dd' then CONVERT(varchar(10),RECPTDT,111)
			end  RECPTDT,
			CASE a.debit WHEN 'D' THEN a.amount END as DEBIT,
			CASE a.credit WHEN 'C' THEN a.amount END as CREDIT,
			EXEC_CODE,REMARKS,CHQNO,CHQDT,CHQ_BANK,REASON,DEBIT_HEAD,CREDIT_HEAD,BILLNO,BILLDT,BILLAMT,
			ADJAMT,LEFTAMT,REC_SEQNO,narr_line
			,
			case @pdateformat			
			when 'dd/mm/yyyy' then CONVERT(varchar(10),a.ISSUE_DATE,103)
			when 'mm/dd/yyyy' then CONVERT(varchar(10),a.ISSUE_DATE,101)
			when 'yyyy/mm/dd' then CONVERT(varchar(10),a.ISSUE_DATE,111)
			end  
			 as ISSUE_DATE,(Select distinct PUBL_NAME from CIR_PUBL_MAST p where p.COMP_CODE=@pcompcode and p.PUBL=a.PRODUCT) as PRODUCT
			,a.QUANTITY,a.UNIT_PRICE,a.addr1,a.ADDR2,a.ADDR3,a.PIN_CODE
			FROM (SELECT comp_code,unit_code,branch_code,agcd,dpcd,agname,doctype,recptno,recptdt,
			CASE sign(amount) WHEN 1 THEN 'D' END as debit,
			CASE sign(amount) WHEN - 1 THEN 'C' END as credit,
			 ABS(amount) as amount,exec_code,remarks,chqno,chqdt,chq_bank,reason,debit_head,credit_head,
			 billno,billdt,billamt,adjamt,leftamt,rec_seqno,ISNULL(narr_line, 1) as narr_line
			 ,ISSUE_DATE,PRODUCT,QUANTITY,UNIT_PRICE,addr1,ADDR2,ADDR3,PIN_CODE
			FROM  #cir_ledger_report 
			WHERE comp_code  = @pcompcode AND unit_code  = @punitcode) a 
			ORDER BY rec_seqno 

			SELECT (SELECT Comp_Name FROM  comp_mst WHERE Comp_Code  = a.comp_code) as "CNAME",
			COMP_CODE,AGCD,DPCD,AGNAME,(SELECT COUNT(*) FROM 
			( SELECT     comp_code,     unit_code,     branch_code,     agcd,     dpcd,     agname,     doctype,     recptno,     recptdt,        
			CASE sign(amount)     WHEN 1 THEN 'D' END as DEBIT,
			CASE sign(amount)     WHEN - 1 THEN 'C'    END as CREDIT,ABS(amount) as AMOUNT,     rec_seqno,NARR_LINE
			FROM  #cir_ledger_report   WHERE  comp_code  = @pcompcode   AND unit_code  = @punitcode ) adv_alias_1  
			WHERE  adv_alias_1.comp_code  = a.comp_code  AND adv_alias_1.agcd  = a.agcd  AND adv_alias_1.dpcd  = a.dpcd  AND adv_alias_1.agname  = a.agname ) adv_count_value,
			ISNULL(SUM(CONVERT(FLOAT, narr_line)), 0) sum_narr
			FROM (SELECT comp_code,unit_code,branch_code,agcd,dpcd,agname,doctype,recptno,recptdt,
			CASE sign(amount) WHEN 1 THEN 'D' END as debit,
			CASE sign(amount) WHEN - 1 THEN 'C' END as credit,ABS(amount) as amount,rec_seqno,narr_line
			FROM  #cir_ledger_report 
			WHERE comp_code  = @pcompcode AND unit_code  = @punitcode) a 
			group by a.comp_code,a.agcd,a.dpcd,a.agname
			ORDER BY comp_code,agcd,dpcd,agname 
	end
	select * from #cir_ledger_report
	drop table #cir_ledger_report

	drop table #cir_summary_statement
	
END


******************************************************next



ALTER PROCEDURE [dbo].[cir_rep_collection_cir_rep_collection_det_p]
    @pcompcode                                VARCHAR(20) ,
    @punitcode                                VARCHAR(20) ,
    @pbrachcode                               VARCHAR(20) ,
    @pdoctype                                 VARCHAR(20) ,
    @ppaymode                                 VARCHAR(20) ,
    @pactype                                  VARCHAR(20) ,
    @pfromdate                                datetime,
    @ptodate                                  datetime ,
    @pdateformat                              VARCHAR(20),
    @pextra1                                  VARCHAR(200),
    @pextra2                                  VARCHAR(200),
    @pextra3                                  VARCHAR(200) =null,--FOR RECEIPT DETAIL R,PROVISIONAL DETAIL P
    @pextra4                                  VARCHAR(200) =null,
    @pextra5                                  VARCHAR(200)=null 
   
AS
        DECLARE @v_frdt        DATETIME
        DECLARE @v_todt     DATETIME
        DECLARE @A            INT
        DECLARE @v_a        as varchar(1000)
    Begin
        SET @v_frdt  = @pfromdate--DBO.CONVERT_USER_DATE('/', @pfromdate,@pdateformat)
        SET @v_todt  = @ptodate--DBO.CONVERT_USER_DATE('/', @ptodate,@pdateformat)
        create  table #Results(SegmentNum INT, EditionName  VARCHAR(255))
        Begin
            if (@pdoctype is not null and @pdoctype!='') begin
            insert into #Results select * from dbo.Fn_Splitfield(@pdoctype,',')
            End
        End
        
        
        If upper(@pextra3)='P' Begin---For Provisional data
        print ('amit1')
        select A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.RECPTDT RECPTDT,A.RECPTNO RECPTNO,A.DOCTYPE DOCTYP,A.AGCD AGCD,
		A.DPCD DPCD,B.AG_NAME AS AGENCY_NAME,B.AG_NAME_OTH_LANG AGNAME_OTH_LANG,B.CITY_CODE,dbo.CIR_GET_CITY(B.COMP_CODE,B.CITY_CODE) CITY_NAME,
		B.TEHSIL_TALUKA TALUKA_CODE,dbo.CIR_GET_TALUKA(B.COMP_CODE,B.TEHSIL_TALUKA) TALUKA_NAME,A.CHNO CHNO,A.CHDT CHDT,
		SUBSTRING(ISNULL((SELECT BANKNAME AS "bankname" FROM CIR_BANK_MAST WHERE COMP_CODE=A.COMP_CODE AND BANKCODE=A.CHBANK),A.CHBANK),1,15) AS BANK,ABS(A.AMOUNT) AMOUNT,
		dbo.INITCAP(A.REMARK) REMARK,A.ACHD ACHD,
		CASE WHEN A.DOCTYPE='RCR' THEN
		(SELECT "Payment_Mode_Name" FROM PAYMENT_MODE_MAST WHERE "Pay_Mode_Code"=A.REASON)
		ELSE
		(SELECT REASON_NAME FROM CIR_REASON_MST WHERE COMP_CODE=A.COMP_CODE AND REASON_CODE=A.REASON) END AS REASON,
		A.BRANCH_CODE BRANCH_CODE,(SELECT DISTINCT "Branch_Name" FROM BRANCH_MST WHERE "Branch_Code"=A.BRANCH_CODE) BRANCH_NAME,
		SUBSTRING(dbo.FA_GET_ACCOUNT_NAME(A.COMP_CODE,A.RCDP),1,15) DEBIT_HEAD,(SELECT DISTINCT CASE WHEN DSIGN=-1 THEN 'C' ELSE 'D' END DSIGN FROM CIR_DOCMST WHERE DOC_TYPE=A.DOCTYPE) DSIGN,
		A.USERID,(SELECT isnull(FIRSTNAME,"username")+' '+LASTNAME FROM LOGIN WHERE "userid"=A.USERID) CREATED_BY, A.CREATION_DATE CREATION_DATE,
		A.REMARK_OTH REMARK_OTH,A.FLAG FLAG
		from CIR_RCPHDR_PROV a,cir_agmast b
		where a.comp_code=b.comp_code and a.comp_code=@pcompcode  
		and a.unit_code=b.unit and a.unit_code =@punitcode 
		and a.agcd=b.agcd and a.dpcd=b.dpcd and (a.agcd=@pextra1 or @pextra1 is null or @pextra1='') 
		and (a.dpcd=@pextra2 or @pextra2 is null or @pextra2='') 
		and a.recptdt between @v_frdt and @v_todt 
		and (a.doctype in (SELECT EditionName FROM #Results) or @pdoctype is null OR @pdoctype='')
	    and (a.reason =@ppaymode or @ppaymode is null OR    @ppaymode = '') and (ISNULL(a.achd, 'NM')  = @pactype OR    @pactype  is null OR    @pactype = '') 
		and (a.branch_code  = @pbrachcode OR    @pbrachcode  is null  OR    @pbrachcode = '')
		order by comp_code,recptdt,doctype,recptno;
        End
        
        else Begin
		print ('amit')
		
		select A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.RECPTDT RECPTDT,A.RECPTNO RECPTNO,A.DOCTYPE DOCTYP,A.AGCD AGCD,
		A.DPCD DPCD,B.AG_NAME AS AGENCY_NAME,B.AG_NAME_OTH_LANG AGNAME_OTH_LANG,B.CITY_CODE,dbo.CIR_GET_CITY(B.COMP_CODE,B.CITY_CODE) CITY_NAME,
		B.TEHSIL_TALUKA TALUKA_CODE,dbo.CIR_GET_TALUKA(B.COMP_CODE,B.TEHSIL_TALUKA) TALUKA_NAME,A.VOUCHERNO VOUCHERNO,A.CHNO CHNO,A.CHDT CHDT,
		SUBSTRING(ISNULL((SELECT BANKNAME AS "bankname" FROM CIR_BANK_MAST WHERE COMP_CODE=A.COMP_CODE AND BANKCODE=A.CHBANK),A.CHBANK),1,15) AS BANK,ABS(A.AMOUNT) AMOUNT,
		dbo.INITCAP(A.REMARK) REMARK,A.ACHD ACHD,
		CASE WHEN A.DOCTYPE='RCR' THEN
		(SELECT "Payment_Mode_Name" FROM PAYMENT_MODE_MAST WHERE "Pay_Mode_Code"=A.REASON)
		ELSE
		(SELECT REASON_NAME FROM CIR_REASON_MST WHERE COMP_CODE=A.COMP_CODE AND REASON_CODE=A.REASON) END AS REASON,
		A.BRANCH_CODE BRANCH_CODE,(SELECT DISTINCT "Branch_Name" FROM BRANCH_MST WHERE "Branch_Code"=A.BRANCH_CODE) BRANCH_NAME,
		SUBSTRING(dbo.FA_GET_ACCOUNT_NAME(A.COMP_CODE,A.RCDP),1,15) DEBIT_HEAD,(SELECT DISTINCT CASE WHEN DSIGN=-1 THEN 'C' ELSE 'D' END DSIGN FROM CIR_DOCMST WHERE DOC_TYPE=A.DOCTYPE) DSIGN,
		A.USERID,(SELECT isnull(FIRSTNAME,"username")+' '+LASTNAME FROM LOGIN WHERE "userid"=A.USERID) CREATED_BY, A.CREATION_DATE CREATION_DATE, A.PROV_REC_NO PROV_REC_NO, A.PROV_REC_DT PROV_REC_DATE,
		A.REMARK_OTH REMARK_OTH
		from cir_rcphdr a,cir_agmast b
		where a.comp_code=b.comp_code and a.comp_code=@pcompcode  
		and a.unit_code=b.unit and a.unit_code =@punitcode 
		and a.agcd=b.agcd and a.dpcd=b.dpcd and (a.agcd=@pextra1 or @pextra1 is null or @pextra1='') 
		and (a.dpcd=@pextra2 or @pextra2 is null or @pextra2='') 
		and a.recptdt between @v_frdt and @v_todt 
		and (a.doctype in (SELECT EditionName FROM #Results) or @pdoctype is null OR @pdoctype='')
	    and (a.reason =@ppaymode or @ppaymode is null OR    @ppaymode = '') and (ISNULL(a.achd, 'NM')  = @pactype OR    @pactype  is null OR    @pactype = '') 
		and (a.branch_code  = @pbrachcode OR    @pbrachcode  is null  OR    @pbrachcode = '')
		order by comp_code,recptdt,doctype,recptno;
        End
        
        
        
        If upper(@pextra3)='P' Begin
     
      SELECT e.comp_code, e.doctype, e.reason, SUM(CONVERT(FLOAT, e.db_amount)) db_amount,
        SUM(CONVERT(FLOAT, e.cr_amount)) cr_amount  FROM
               (SELECT d.comp_code, d.doctype, d.reason,
                CASE d.debit WHEN 'D' THEN SUM(CONVERT(FLOAT, d.amount)) END db_amount,                 
                CASE d.credit WHEN 'C' THEN SUM(CONVERT(FLOAT, d.amount)) END cr_amount
                FROM (SELECT a.comp_code comp_code, a.doctype doctype, --a.reason reason,
                CASE WHEN A.DOCTYPE='RCR' THEN (SELECT "Payment_Mode_Name" FROM PAYMENT_MODE_MAST WHERE "Pay_Mode_Code"=A.REASON)
        ELSE (SELECT REASON_NAME FROM CIR_REASON_MST WHERE COMP_CODE=A.COMP_CODE AND REASON_CODE=A.REASON) END AS REASON,
             CASE sign(a.amount) WHEN 1 THEN 'D' END as debit,
             CASE sign(a.amount) WHEN - 1 THEN 'C' END as credit,
             ABS(a.amount)  amount
             FROM  CIR_RCPHDR_PROV a, cir_agmast b
            WHERE     a.comp_code  = b.comp_code
                AND    a.comp_code  = @pcompcode
                AND    a.unit_code  = b.unit
                AND    a.unit_code  = @punitcode
                AND    a.agcd  = b.agcd
                AND (a.agcd=@pextra1 or @pextra1 is null or @pextra1='')       
                AND    a.dpcd  = b.dpcd
                AND (a.dpcd=@pextra2 or @pextra2 is null or @pextra2='')
                AND    a.recptdt  between @v_frdt  and  @v_todt
                AND (a.doctype  in (SELECT EditionName FROM #Results) or @pdoctype is null OR @pdoctype='')
                AND    (a.reason  = @ppaymode OR    @ppaymode  is null  OR    @ppaymode  = '')
                AND    (ISNULL(a.achd, 'NM')  = @pactype  OR    @pactype  is null OR    @pactype  = '')
                AND    (a.branch_code  = @pbrachcode OR    @pbrachcode  is null OR     @pbrachcode  = '')) d
                 GROUP BY d.comp_code, d.doctype, d.reason, d.debit, d.credit ) e
        GROUP BY e.comp_code, e.doctype,  e.reason
        ORDER BY e.comp_code, e.doctype, e.reason
      end 
      
        else 
        Begin
        SELECT e.comp_code, e.doctype, e.reason, SUM(CONVERT(FLOAT, e.db_amount)) db_amount,
        SUM(CONVERT(FLOAT, e.cr_amount)) cr_amount  FROM
               (SELECT d.comp_code, d.doctype, d.reason,
                CASE d.debit WHEN 'D' THEN SUM(CONVERT(FLOAT, d.amount)) END db_amount,                 
                CASE d.credit WHEN 'C' THEN SUM(CONVERT(FLOAT, d.amount)) END cr_amount
                FROM (SELECT a.comp_code comp_code, a.doctype doctype, --a.reason reason,
                CASE WHEN A.DOCTYPE='RCR' THEN (SELECT "Payment_Mode_Name" FROM PAYMENT_MODE_MAST WHERE "Pay_Mode_Code"=A.REASON)
        ELSE (SELECT REASON_NAME FROM CIR_REASON_MST WHERE COMP_CODE=A.COMP_CODE AND REASON_CODE=A.REASON) END AS REASON,
             CASE sign(a.amount) WHEN 1 THEN 'D' END as debit,
             CASE sign(a.amount) WHEN - 1 THEN 'C' END as credit,
             ABS(a.amount)  amount
             FROM  cir_rcphdr a, cir_agmast b
            WHERE     a.comp_code  = b.comp_code
                AND    a.comp_code  = @pcompcode
                AND    a.unit_code  = b.unit
                AND    a.unit_code  = @punitcode
                AND    a.agcd  = b.agcd
                AND (a.agcd=@pextra1 or @pextra1 is null or @pextra1='')       
                AND    a.dpcd  = b.dpcd
                AND (a.dpcd=@pextra2 or @pextra2 is null or @pextra2='')
                AND    a.recptdt  between @v_frdt  and  @v_todt
                AND (a.doctype  in (SELECT EditionName FROM #Results) or @pdoctype is null OR @pdoctype='')
                AND    (a.reason  = @ppaymode OR    @ppaymode  is null  OR    @ppaymode  = '')
                AND    (ISNULL(a.achd, 'NM')  = @pactype  OR    @pactype  is null OR    @pactype  = '')
                AND    (a.branch_code  = @pbrachcode OR    @pbrachcode  is null OR     @pbrachcode  = '')) d
                 GROUP BY d.comp_code, d.doctype, d.reason, d.debit, d.credit ) e
        GROUP BY e.comp_code, e.doctype,  e.reason
        ORDER BY e.comp_code, e.doctype, e.reason
     end 
      
        drop table #Results

End


/////////////////////////////////////////////next



ALTER procedure [dbo].[cir_fetch_supplment_rate]
    @pcompcode       as varchar(20),
    @punitcode       as varchar(20),
    @ppublcode       as varchar(20),
    @pfromdate       as datetime, 
    @ptilldate       as datetime,
    @puserid         as varchar(50), 
    @pdateformate    as varchar(50),
    @pextra1         as varchar(50),
    @pextra2         as varchar(50),
    @pextra3         as varchar(50),
    @pextra4         as varchar(50),
    @pextra5         as varchar(50)
as
    declare @v_dt		as	datetime
    declare @v_day		as  varchar(20)
    declare @v_flg      as  varchar(1)
    declare @v_recno    as  int
    declare @v1_comp_code	as varchar(20)
    declare @v1_unit_code	as varchar(20)
    declare @v1_publ_code	as varchar(20)
    declare @v1_publ_name	as varchar(200)
    declare @v1_main_edtn	as varchar(20)
    declare @v1_main_edtn_name as varchar(200)
    declare @v1_edtn		as varchar(20)
    declare @v1_edtn_name	as varchar(200)
    declare @v1_supl_name	as varchar(200)
    declare @v1_valid_from	as datetime
    declare @v1_valid_till	as datetime
    declare @v1_insertion_fee	as numeric(14,2)
    declare @v1_sun_allow	as varchar(20)
    declare @v1_mon_allow	as varchar(20)
    declare @v1_tue_allow	as varchar(20)
    declare @v1_wed_allow	as varchar(20)
    declare @v1_thu_allow	as varchar(20)
    declare @v1_fri_allow	as varchar(20)
    declare @v1_sat_allow	as varchar(20)
    
    
begin
	set @v_flg ='N'
	CREATE TABLE #CIR_TEMP_BILL_COLLECTION
	(COMP_CODE       VARCHAR(100),
	UNIT_CODE        VARCHAR(100),
	BILLNO           VARCHAR(200),
	BILLDT           DATETIME,
	PUBL_CODE        VARCHAR(100),
	AGCD             VARCHAR(100),
	DPCD             VARCHAR(100),
	SUPPLY_COPY      NUMERIC(10)                   DEFAULT 0,
	GROSS_AMT        NUMERIC(15,2)                 DEFAULT 0,
	COMM_AMT         NUMERIC(15,2)                 DEFAULT 0,
	SUR_AMT          NUMERIC(15,2)                 DEFAULT 0,
	RETURN_COPY      NUMERIC(10)                   DEFAULT 0,
	RETURN_AMT       NUMERIC(15,2)                 DEFAULT 0,
	DN_AMT           NUMERIC(15,2)                 DEFAULT 0,
	CN_AMT           NUMERIC(15,2)                 DEFAULT 0,
	REC_AMT          NUMERIC(15,2)                 DEFAULT 0,
	PREV_BAL         NUMERIC(15,2)                 DEFAULT 0,
	CUR_SESSIONID    NUMERIC,
	AGNAME           VARCHAR(200),
	AGNAME_OTH_LANG  VARCHAR(250),
	CITY_CODE        VARCHAR(200),
	TALUKA_CODE      VARCHAR(200),
	DIST_CODE        VARCHAR(200),
	STATE_CODE       VARCHAR(200),
	REMARKS          VARCHAR(500),
	RET_COMM_AMT     NUMERIC(15,2),
	BILL_SEC_AMT     NUMERIC(15,2),
	SEC_OPBAL        NUMERIC(15,2));

declare c1 cursor for
    select s.comp_code comp_code,s.unit_code unit_code,s.publ_code publ_code,p.publ_name publ_name,e.main_edtn main_edtn,dbo.cir_get_edtn_name(s.comp_code,e.main_edtn) main_edtn_name,
    s.edtn_code edtn,e.edtn_name edtn_name,s.supl_name_sun supl_name,max(s.valid_from) valid_from,max(s.valid_till) valid_till,s.insertion_fee,
    s.sun_allow,s.mon_allow,s.tue_allow,s.wed_allow,s.thu_allow,s.fri_allow,s.sat_allow
    from cir_publ_mast p,cir_edtn_mast e,cir_edtn_supl_mast s
    where p.comp_code=e.comp_code and p.comp_code=s.comp_code and p.comp_code=@pcompcode and
        p.publ=e.publ and p.publ=s.publ_code and (p.publ=@ppublcode or @ppublcode is null or @ppublcode='') and (s.unit_code=@punitcode or @punitcode is null or @punitcode='') and e.edtn=s.edtn_code --and
        --v_from_date between valid_from and valid_till  and 
        --v_till_date between valid_from and valid_till
        group by s.comp_code,s.unit_code,s.publ_code,p.publ_name,e.main_edtn,
		s.edtn_code,e.edtn_name,s.supl_name_sun,s.insertion_fee,sun_allow,mon_allow,tue_allow,wed_allow,thu_allow,fri_allow,sat_allow;
	declare @x as int
	set @x=0
    open c1
        fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit_code,@v1_publ_code,@v1_publ_name,@v1_main_edtn,@v1_main_edtn_name,
			@v1_edtn,@v1_edtn_name,@v1_supl_name,@v1_valid_from,@v1_valid_till,@v1_insertion_fee,
			@v1_sun_allow,@v1_mon_allow,@v1_tue_allow,@v1_wed_allow,@v1_thu_allow,@v1_fri_allow,@v1_sat_allow
        WHILE (@@FETCH_STATUS = 0) 
		BEGIN
		set @x=@x+1
        print('@x')print(@x)
        
			set @v_dt=@pfromdate		
			WHILE (@v_dt <= @ptilldate) 
			BEGIN
			
				print('@v_dt1') print(@v_dt)print(@v1_valid_from)print(@v1_valid_till)
				
				if @v_dt between @v1_valid_from and @v1_valid_till 
				Begin
                set @v_day=CONVERT(VARCHAR(20) , DATENAME(WEEKDAY, @v_dt),20)
                
					if @v_day='Sunday' 
					Begin 
						If @v1_sun_allow='Y' 
						Begin
							set @v_flg='Y'
						End    
						Else 
						Begin
							set @v_flg='N'
						End
					End    
					Else if @v_day='Monday' 
					Begin
						If @v1_mon_allow='Y' 
						Begin
							set @v_flg='Y'
						End    
						Else Begin
							set @v_flg='N'
						End
					End    
					Else if @v_day='Tuesday' 
					Begin
						If @v1_tue_allow='Y' 
						Begin
							set @v_flg='Y'
						End    
						Else Begin
							set @v_flg='N'
						End
					End 
					Else If @v_day='Wednesday' 
					Begin
						If @v1_wed_allow='Y' 
						Begin
							set @v_flg='Y'
						End
						Else 
						Begin
							set @v_flg='N'
						End
					End    
					Else If @v_day='Thursday' 
					Begin
						If @v1_thu_allow='Y' 
						Begin
							set @v_flg='Y'
						End    
						Else Begin
							set @v_flg='N'
						End
					End    
					Else if @v_day='Friday' 
					Begin
						If @v1_fri_allow='Y' 
						Begin
							set @v_flg='Y'
						End    
						Else Begin
							set @v_flg='N'
						End    
					End
					Else 
					Begin
						If @v1_sat_allow='Y' 
						Begin
							set @v_flg='Y'
						End    
						Else Begin
							set @v_flg='N'
						End
					End
				print('@v_flg')print(@v_flg)
                If @v_flg='Y' Begin
                    insert into #cir_temp_bill_collection
                        (comp_code, unit_code, billno,publ_code, agcd, dpcd,agname,agname_oth_lang, city_code, 
                        billdt,comm_amt)
                    values(@v1_comp_code,@v1_unit_code,@v1_publ_code,@v1_publ_name,@v1_main_edtn,@v1_edtn,@v1_main_edtn_name,@v1_edtn_name,
                        @v1_supl_name,@v_dt,@v1_insertion_fee)
                End                 
			end
			print('@v_dt = 1')print(@v_dt)
			set @v_dt=DATEADD(dd,1,@v_dt)
			print('@v_dt = 2')print(@v_dt)
            
     End

    fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit_code,@v1_publ_code,@v1_publ_name,@v1_main_edtn,@v1_main_edtn_name,
			@v1_edtn,@v1_edtn_name,@v1_supl_name,@v1_valid_from,@v1_valid_till,@v1_insertion_fee,
			@v1_sun_allow,@v1_mon_allow,@v1_tue_allow,@v1_wed_allow,@v1_thu_allow,@v1_fri_allow,@v1_sat_allow
	End		
    close c1
    deallocate c1
    
    select comp_code AS "COMP_CODE", unit_code AS "UNIT_CODE", billno as "PUBL_CODE",publ_code AS "PUBL_NAME", agcd AS "MAIN_EDTN", dpcd AS "EDTN",
    agname AS "MAIN_EDTN_NAME",agname_oth_lang AS "EDTN_NAME", city_code AS "SUPL_NAME", 
    billdt AS "SUPDATE" ,comm_amt AS "INSERTION_FEE" 
    from #CIR_TEMP_BILL_COLLECTION
    
    drop table #CIR_TEMP_BILL_COLLECTION
End


////////////////////////////////////////////////////////////////////


ALTER PROCEDURE [dbo].[cir_fetch_suppliment_data_p]
	@pcompcode                                VARCHAR(40) ,
	@punitcode                                VARCHAR(40) ,
	@pagtype                                  VARCHAR(40) ,
	@pagclass                                 VARCHAR(40) ,
	@psup_type                                VARCHAR(40) ,
	@pagcode                                  VARCHAR(40) ,
	@pdepocode                                VARCHAR(40) ,
	@pcode                                    VARCHAR(4000) ,
	@pprocesstype                             VARCHAR(4000) ,---process by Zone.Region,Branch,District,Route
	@pdatefrom                                datetime ,
	@pdatetill                                datetime ,
	@pedtncode_val                            VARCHAR(4000) ,--for edition code
	@psupdate_val                             VARCHAR(4000) ,--for supply date
	@pinc_rate_val                            VARCHAR(4000) ,--for insertion rate
	@psupl_no_val                             VARCHAR(4000) ,--for no. of insertion
	@psupl_name_val                           VARCHAR(4000) ,--for suppliment name
	@pdelimiter                               VARCHAR(4000) ,
	@puserid                                  VARCHAR(40) ,
	@pdateformat                              VARCHAR(40) ,
	@pextra1                                  VARCHAR(400) ,
	@pextra2                                  VARCHAR(400) ,
	@pextra3                                  VARCHAR(400) ,
	@pextra4                                  VARCHAR(400) ,
	@pextra5                                  VARCHAR(400)
AS 
BEGIN
	DECLARE @vlength                                  NUMERIC(7) 
	DECLARE @vrunval                                  VARCHAR(8000) 
	DECLARE @v_val                                    VARCHAR(800) 
	DECLARE @v_name                                   VARCHAR(8000) 
	DECLARE @v_sname                                  VARCHAR(8000) 
	DECLARE @vno                                      FLOAT                           
	SET @vno = 0 
	DECLARE @v_frdt                                   DATETIME 
	DECLARE @v_todt                                   DATETIME 
	DECLARE @v_doctype                                VARCHAR(10)                     
	SET @v_doctype = 'CN' 
	DECLARE @v_recptdt                                DATETIME 
	DECLARE @v_dt                                     DATETIME 
	DECLARE @v_sess_id                                VARCHAR(30) 

		
	DECLARE @v1                                       VARCHAR(200) 
	DECLARE @v_amt                                    NUMERIC(15,2) 
	DECLARE @v_remark                                 VARCHAR(500) 
	DECLARE @v_recptno                                VARCHAR(50) 
	DECLARE @v_dsign                                  NUMERIC(5) 
	DECLARE @v_bran_code                              VARCHAR(20) 
	DECLARE @v_rec_no                                 NUMERIC(10) 
	DECLARE @v_unsold_copy                            NUMERIC(10) 
	DECLARE @vdistcode                                VARCHAR(4000) 
	DECLARE @vtalukacode                              VARCHAR(4000) 
print ('**')	
	SET @v_recptdt  = @pdatetill--CONVERT(DATETIME, @pdatetill)
	
	CREATE TABLE #CIR_LEDGER_REPORT
	(COMP_CODE		VARCHAR(100),
	 UNIT_CODE		VARCHAR(100),
	 DEBIT_HEAD		VARCHAR(100),
	 REC_SEQNO		INT)

CREATE TABLE #CIR_TEMP_SUPPLIMENT
( COMP_CODE     VARCHAR(10),
  UNIT_CODE     VARCHAR(10),
  SEQ_NO        NUMERIC(5),
  EDITION_CODE  VARCHAR(10),
  SUP_DATE      DATETIME,
  INC_RATE      NUMERIC(10,2),
  NOOF_SUPL     NUMERIC(3),
  SUPL_NAME     VARCHAR(100),
  SESS_ID       INT )

	If @pagtype='' Begin
		set @pagtype=null
	End
	If @pagclass='' Begin
		set @pagclass=null
	End
	If @psup_type='' Begin
		set @psup_type=null
	End
	If @pagcode='' Begin
		set @pagcode=null
	End
	If @pdepocode='' Begin
		set @pdepocode=null
	End
	If @pcode='' Begin
		set @pcode=null
	End
	If @pprocesstype='' Begin
		set @pprocesstype=null
	End

	If @pextra1='' Begin
		set @pextra1=null
	End									
	If @pextra2='' Begin
		set @pextra2=null
	End
	If @pextra3='' Begin
		set @pextra3=null
	End									
	If @pextra4='' Begin
		set @pextra4=null
	End
	If @pextra5='' Begin
		set @pextra5=null
	End
	  	  
	DELETE FROM   cir_supl_process_det_temp WHERE  recptno  = cast(@@SPID as varchar) 
	--select  * from cir_supl_process_det_temp WHERE  recptno  = cast(@@SPID as varchar) 
	
print('8')
print(@@SPID )
		SET @v_sess_id  =  @@SPID
	
		print('end')
		
		/* for  Edition Code */
		
		SET @vlength  = null SET @vrunval  = null 
		SET @v_val  = REPLACE(@pedtncode_val, @pdelimiter, ',')
		SET @vlength  = LEN(@v_val)SET @vno  = 1
		print(@v_val)
		DECLARE	@i	INT
		SET @i  = 1

		WHILE @i <= @vlength BEGIN
			SET @vrunval  = SUBSTRING(@v_val, @i, 1) 
			print('@vrunval')
			print(@vrunval)
			IF @vrunval != ',' BEGIN 
				SET @v_name  = isnull(@v_name,'') + @vrunval 
			END
			ELSE BEGIN 
			print('@v_name')
			print(@v_name)
				INSERT INTO  #cir_temp_suppliment( comp_code , unit_code , seq_no , edition_code)  
				 VALUES ( @pcompcode , @punitcode , @vno , @v_name)  
				
				SET @vno  = @vno + 1 
				SET @v_name  = '' 
			END
			SET @i = @i + 1
		END
		
		/* for Supply Date */
	
		SET @vrunval	= null 
		SET @v_name		= null SET @v_sname  = null 
		SET @v_val		= REPLACE(@psupdate_val, @pdelimiter, ',')
		SET @vlength	= LEN(@v_val)
		SET @vno  = 1 SET @i = 1 

		WHILE @i <= @vlength BEGIN
		
			SET @vrunval  = SUBSTRING(@v_val, @i, 1)
			IF @vrunval != ',' BEGIN 
				SET @v_name  = isnull(@v_name,'') + @vrunval 
			END
			ELSE 
			BEGIN 
				declare @dd as varchar(2)
				declare @mm as varchar(2)
				declare @yyyy as varchar(4)
				if @pdateformat='dd/mm/yyyy' 
				begin
					set @dd= substring(@v_name,1,2)
					set @mm= substring(@v_name,4,2)
					set @yyyy=substring(@v_name,7,4)
					set @v_name=@mm +'/'+@dd+'/'+@yyyy
				end
				else if @pdateformat='yyyy/mm/dd' 
				begin
					set @yyyy= substring(@v_name,1,4)
					set @mm= substring(@v_name,6,2)
					set @dd=substring(@v_name,9,2)
					set @v_name=@mm +'/'+@dd+'/'+@yyyy
				end
					SET @v_dt  = CONVERT(DATETIME, @v_name)
					UPDATE  #cir_temp_suppliment SET	sup_date = @v_dt WHERE seq_no  = @vno

					SET @vno  = @vno + 1 
					SET @v_name  = '' 
				
			END
			SET @i = @i + 1
		END
		/* for Incanctive Per Copy Rate */
		
		SET @vrunval  = null 
		SET @v_name  = null 
		SET @v_sname  = null 
		SET @v_val  = REPLACE(@pinc_rate_val, @pdelimiter, ',')
		SET @vlength  = LEN(@v_val)
		SET @vno  = 1 SELECT @i = 1 

		WHILE @i <= @vlength BEGIN
			SET @vrunval  = SUBSTRING(@v_val, @i, 1)
			IF @vrunval != ',' BEGIN 
				SET @v_name  = isnull(@v_name,'') + @vrunval 
			END
			ELSE BEGIN 
				UPDATE  #cir_temp_suppliment SET	inc_rate = (@v_name) WHERE  seq_no  = @vno
				
				SET @vno  = @vno + 1 
				SET @v_name  = '' 
			END
			SET @i = @i + 1
		END
	
		/* for No of Supl */
		
		SET @vrunval  = null 
		SET @v_name  = null 
		SET @v_sname	= null 
		SET @v_val		= REPLACE(@psupl_no_val, @pdelimiter, ',')
		SET @vlength	= LEN(@v_val) SET @vno  = 1 SET @i = 1 
		
		WHILE @i <= @vlength BEGIN
			SET @vrunval  = SUBSTRING(@v_val, @i, 1)
			IF @vrunval != ',' 
			BEGIN 
				SET @v_name  = isnull(@v_name,'') + @vrunval 
			END
			ELSE BEGIN 
				UPDATE  #cir_temp_suppliment  SET	noof_supl = (@v_name) WHERE  seq_no  = @vno
				
				SET @vno  = @vno + 1 
				SET @v_name  = '' 
			END
			SET @i = @i + 1
		END
		
		/* for Supl Name*/
		
		SET @v_val  = null SET @vrunval  = null 
		SET @v_name = null SET @v_sname  = null 
		SET @v_val  = REPLACE(@psupl_name_val, @pdelimiter, ',')
		SET @vlength= LEN(@v_val)
		SET @vno	= 1 SET @i = 1 

		WHILE @i <= @vlength BEGIN
			SET @vrunval  = SUBSTRING(@v_val, @i, 1)
			IF @vrunval != ',' BEGIN 
				SET @v_sname  = isnull(@v_sname,'') + @vrunval 
			END
			ELSE BEGIN 
				UPDATE  #cir_temp_suppliment  SET	supl_name = (@v_sname) WHERE  seq_no  = @vno
				
				SET @vno  = @vno + 1 
				SET @v_name  = '' 
			END
			SET @i = @i + 1
		END

		IF @pcode IS NOT NULL or @pcode<>'' BEGIN 
			--SET @vdistcode  = @pcode  + ''',''' 
			SET @vdistcode  = @pcode  + ',' 
			SET @v_name  = null 
			SET @vrunval  = null 
			SET @v_val  = REPLACE(@vdistcode, ',', ',')
			SET @vlength  = LEN(@v_val)
			SET @vno  = 1 
			SET @i = 1 

			WHILE @i <= @vlength BEGIN
				SET @vrunval  = SUBSTRING(@v_val, @i, 1)
				IF @vrunval != ',' BEGIN 
					SET @v_name  = isnull(@v_name,'') + @vrunval 
				END
				ELSE BEGIN 
					INSERT INTO  #cir_ledger_report   
							( comp_code , unit_code , debit_head, rec_seqno)  
					 VALUES ( @pcompcode , @punitcode , @v_name , @vno)  
					
					SET @vno  = @vno + 1 
					SET @v_name  = '' 
				END
				SET @i = @i + 1
			END
		END
		
		
	DECLARE @c1_comp_code	VARCHAR(40)
	DECLARE @c1_unit_code	VARCHAR(40) 
	DECLARE @c1_publ		VARCHAR(40) 
	DECLARE @c1_edtn		VARCHAR(40) 
	DECLARE @c1_supdate		DATETIME 
	DECLARE @c1_agcd		VARCHAR(40) 
	DECLARE @c1_dpcd		VARCHAR(40) 
	DECLARE @c1_billagcd	VARCHAR(40) 
	DECLARE @c1_billdpcd	VARCHAR(40) 
	DECLARE @c1_inc_rate	NUMERIC(15,2)
	DECLARE @c1_no_of_supl  INT
	DECLARE @c1_supl_name	VARCHAR(400) 
	DECLARE @c1_sup_copy	INT
	--	SELECT * FROM #cir_ledger_report
   	--SELECT * FROM #cir_temp_suppliment
	DECLARE c1 CURSOR LOCAL FOR 
	SELECT DISTINCT	 a.comp_code comp_code,	 a.unit_code unit_code, a.publ publ,
			 a.edtn edtn, a.supdate supdate, a.agcd agcd, a.dpcd dpcd, a.billagcd billagcd,
			 a.billdpcd billdpcd, b.inc_rate inc_rate, b.noof_supl no_of_supl,b.supl_name supl_name,
			 SUM(a.sup_copy) sup_copy
	FROM  cir_dbksup a, #cir_temp_suppliment b,cir_supply_type_mast c,cir_agmast d ,CIR_CITY_MAST z
	WHERE a.comp_code  = @pcompcode AND a.comp_code  = b.comp_code AND a.comp_code  = c.comp_code AND a.comp_code  = d.comp_code
	 AND a.unit_code  = ISNULL(@punitcode, a.unit_code) AND a.unit_code  = d.unit
	 AND a.edtn  = b.edition_code
	 AND a.supdate  >= @pdatefrom AND a.supdate  <= @pdatetill
	 AND a.sup_type_code  = c.sup_ty_code
	 AND (a.sup_type_code  = ISNULL(@psup_type, a.sup_type_code)  OR @psup_type  ='')
	 AND a.agcd  = d.agcd AND a.dpcd  = d.dpcd
	 AND (d.agcd  = ISNULL(@pagcode, d.agcd)  OR @pagcode  ='')
	 AND (d.dpcd  = ISNULL(@pdepocode, d.dpcd) OR @pdepocode  ='')
	 AND (d.ag_type  = @pagtype OR	@pagtype IS NULL)
	 AND (d.ag_class  = @pagclass OR @pagclass  IS NULL)
	 --NEW
	 and a.comp_code=z.COMP_CODE
	 and b.comp_code=z.COMP_CODE
	 and c.comp_code=z.COMP_CODE
	 and d.comp_code=z.COMP_CODE
	 and d.DIST_CODE=z.DIST_CODE
	 and d.STATE_CODE=z.STATE_CODE
	 and d.COUNTRY_CODE=z.COUNTRY_CODE
	 and d.CITY_CODE=z.CITY_CODE
	 
	 AND (
	 (d.dist_code  IN(SELECT debit_head	FROM  #cir_ledger_report) OR @pcode  IS NULL  OR @pcode  ='' AND @pprocesstype='D')
	 or (d.BRANCH_code  IN(SELECT debit_head	FROM  #cir_ledger_report) OR @pcode  IS NULL  OR @pcode  ='' AND @pprocesstype='B')
	 or (a.ROUTE_CODE  IN(SELECT debit_head	FROM  #cir_ledger_report) OR @pcode  IS NULL  OR @pcode  ='' AND @pprocesstype='U')
	 or (z.ZONE_CODE  IN(SELECT debit_head	FROM  #cir_ledger_report) OR @pcode  IS NULL  OR @pcode  ='' AND @pprocesstype='Z')
	 or (z.REGION_CODE  IN(SELECT debit_head	FROM  #cir_ledger_report) OR @pcode  IS NULL  OR @pcode  ='' AND @pprocesstype='R') 
	 )
	-- AND (d.dist_code  IN(SELECT debit_head	FROM  #cir_ledger_report) OR @pcode  IS NULL  OR @pcode  ='')
	 --AND b.sess_id  = @@SPID
	 AND a.supdate  = b.sup_date
	 AND a.billagcd  IS NOT NULL
	-- and a.comp_code+a.unit_code+a.publ+a.edtn+convert(varchar(10),a.supdate,101)+a.agcd+a.dpcd not in
	 --(select e.comp_code+e.unit_code+e.publ_code+e.edtn_code+convert(varchar(10),e.supdate,101)+e.agcd+e.dpcd from  cir_supl_process_det e)
	 
	 
	 
	GROUP BY a.comp_code, a.unit_code, a.publ, a.edtn, a.supdate, a.agcd,a.dpcd,a.billagcd,
		 a.billdpcd,b.inc_rate, b.noof_supl, b.supl_name 
		 ORDER BY a.comp_code,a.unit_code,a.supdate,a.publ,a.edtn 
		 
		 
		 

print('Q')		
		OPEN c1 
		FETCH NEXT FROM c1 INTO @c1_comp_code,@c1_unit_code,@c1_publ,@c1_edtn,@c1_supdate,@c1_agcd,@c1_dpcd,@c1_billagcd,@c1_billdpcd,
		@c1_inc_rate,@c1_no_of_supl,@c1_supl_name,@c1_sup_copy	
			WHILE (@@FETCH_STATUS = 0) 
			BEGIN 
			SET @v_amt  = ( ISNULL( @c1_sup_copy, 0)- ISNULL(@v_unsold_copy, 0)) * ISNULL(@c1_inc_rate, 0)* ISNULL(@c1_no_of_supl, 0)
			print('W')
			IF ISNULL(@v_amt, 0)<> 0 BEGIN 
				INSERT INTO  cir_supl_process_det_temp   
						( comp_code , unit_code , publ_code , edtn_code , supdate , agcd , 
						dpcd , tot_supply , per_copy_rate , no_of_supl , recptdt , recptno , amount , 
						bilagcd , bildpcd , created_by , doctype , supl_name)  
				 
				 VALUES ( @c1_comp_code , @c1_unit_code , @c1_publ , @c1_edtn , @c1_supdate , @c1_agcd , @c1_dpcd , 
						ISNULL(@c1_sup_copy, 0) - ISNULL(@v_unsold_copy, 0) , 
						@c1_inc_rate , @c1_no_of_supl , @v_recptdt , @@SPID , @v_amt , @c1_billagcd , 
						@c1_billdpcd , @puserid , @v_doctype , @c1_supl_name )  
			print('*')print(@c1_comp_code)print(@c1_unit_code)print(@c1_publ)print(@c1_edtn)print(@c1_supdate)print(@c1_agcd)
			print(@c1_dpcd)	print(@c1_sup_copy)print(@v_unsold_copy)print(@c1_inc_rate)
			print(@c1_no_of_supl)	print(@v_doctype)print(@c1_supl_name)print('%')
 			END
		FETCH NEXT FROM c1 INTO @c1_comp_code,@c1_unit_code,@c1_publ,@c1_edtn,@c1_supdate,@c1_agcd,@c1_dpcd,@c1_billagcd,@c1_billdpcd,
		@c1_inc_rate,@c1_no_of_supl,@c1_supl_name,
			@c1_sup_copy
			
		END
		CLOSE c1		
		SET @v_amt  = 0 
print('@v_sess_id')print(@v_sess_id)
		SELECT s.comp_code AS "COMP_CODE",s.unit_code AS "UNIT_CODE",s.recptno AS "RECPTNO",s.recptdt AS "RECPTDT",
				 s.bilagcd AS "AGCD",s.bildpcd AS "DPCD",m.ag_name AS "AG_NAME",
				 DBO.cir_get_drop_point_name(s.comp_code, s.unit_code, m.station_code, 1) AS "DROP_POINT_NAME",
				 DBO.cir_get_city(s.comp_code, m.city_code) AS "CITY_NAME",
				 s.doctype AS "DOCTYPE",SUM(s.tot_supply) AS "SUPPLY",COUNT(s.no_of_supl) AS "NO_OF_INSERTION",SUM(s.amount) AS "AMOUNT"
		FROM  cir_supl_process_det_temp s, cir_agmast m ,CIR_CITY_MAST z,CIR_SUPPLY f
		WHERE s.comp_code  = m.comp_code 
		AND s.unit_code  = m.unit 
		 --AND s.bilagcd  = m.agcd 
		 --AND s.bildpcd  = m.dpcd 
		  AND s.agcd  = m.agcd 
		 AND s.dpcd  = m.dpcd 
		 and dbo.cir_get_ins_status(s.comp_code,s.bilagcd,s.bildpcd,s.unit_code,'','')='Y'
		 AND s.recptno  = @v_sess_id
		 and s.COMP_CODE+s.UNIT_CODE+s.PUBL_CODE+s.EDTN_CODE+cast(s.SUPDATE as varchar)+s.AGCD+s.DPCD+s.SUPL_NAME
		 not in (Select distinct x.COMP_CODE+x.UNIT_CODE+x.PUBL_CODE+x.EDTN_CODE+cast(x.SUPDATE as varchar)+x.AGCD+x.DPCD+x.SUPL_NAME
		 from cir_supl_process_det x where x.comp_code  = @pcompcode
		 AND x.unit_code  = ISNULL(@punitcode, x.unit_code)
		 AND x.supdate  >= @pdatefrom AND x.supdate  <= @pdatetill
		 AND (x.agcd  = ISNULL(@pagcode, x.agcd)  OR @pagcode  ='')
		 AND (x.dpcd  = ISNULL(@pdepocode, x.dpcd) OR @pdepocode  ='')		 		 		 
		 AND x.agcd  IS NOT NULL ) 
		 
		 --new 
		 
		  and s.comp_code=f.COMP_CODE
		  AND s.unit_code  =f.unit 
		  AND s.bilagcd  = f.AGCD 
		  AND s.bildpcd  = f.dpcd 
		  AND s.PUBL_CODE=f.PUBL 
		  AND s.EDTN_CODE=f.EDTN
		  and f.comp_code=m.COMP_CODE  
	      and f.UNIT=m.UNIT
	      and f.AGCD=m.AGCD
	      and f.DPCD=m.DPCD
	      
	 and f.comp_code=z.COMP_CODE
	 and s.comp_code=z.COMP_CODE
	 and m.comp_code=z.COMP_CODE
	 
	 and m.DIST_CODE=z.DIST_CODE
	 and m.STATE_CODE=z.STATE_CODE
	 and m.COUNTRY_CODE=z.COUNTRY_CODE
	 and m.CITY_CODE=z.CITY_CODE
		 
		  AND (
	 (m.dist_code  IN(SELECT debit_head	FROM  #cir_ledger_report) OR @pcode  IS NULL  OR @pcode  ='' AND @pprocesstype='D')
	 or (m.BRANCH_code  IN(SELECT debit_head	FROM  #cir_ledger_report) OR @pcode  IS NULL  OR @pcode  ='' AND @pprocesstype='B')
	 or (f.ROUTE_CODE  IN(SELECT debit_head	FROM  #cir_ledger_report) OR @pcode  IS NULL  OR @pcode  ='' AND @pprocesstype='U')
	 or (z.ZONE_CODE  IN(SELECT debit_head	FROM  #cir_ledger_report) OR @pcode  IS NULL  OR @pcode  ='' AND @pprocesstype='Z')
	 or (z.REGION_CODE  IN(SELECT debit_head	FROM  #cir_ledger_report) OR @pcode  IS NULL  OR @pcode  ='' AND @pprocesstype='R') 
	 )
		GROUP BY s.comp_code,s.unit_code,s.recptno,s.recptdt,s.doctype,s.bilagcd,s.bildpcd,m.station_code,m.city_code,m.ag_name 
		HAVING SUM(CONVERT(FLOAT, amount))  > 0  
		ORDER BY comp_code,unit_code,bilagcd,bildpcd 
	DEALLOCATE c1
	--DELETE FROM   cir_supl_process_det_temp   --change by neha 
		DROP TABLE #cir_ledger_report;
	DROP TABLE #cir_temp_suppliment;

END




//////////////////////////////////////////////////////////////////////////////////////////////////





ALTER procedure [dbo].[cir_suppliment_cn_process_p]
    @pcompcode       as varchar(20),
    @punitcode       as varchar(20),
    @pagcode         as varchar(20),
    @pdepocode       as varchar(20),
    @pdatefrom       as varchar(50),
    @pdatetill       as varchar(50),
    @pdoctype        as varchar(20),
    @precptdt        as varchar(50),
    @precptno        as varchar(50),
    @preason         as varchar(50),
    @premark         as varchar(500),
    @puserid         as varchar(20),
    @pdateformat     as varchar(20),
    @pextra1         as varchar(50),
    @pextra2         as varchar(50),
    @pextra3         as varchar(50),
    @pextra4         as varchar(50),
    @pextra5         as varchar(50)
  As
    declare @vlength		numeric(7)
    declare @v_doctype		varchar(10)
    declare @v_dt			datetime
    declare @v_sess_id		varchar(30)
    declare @v2_comp_code	varchar(50)
    declare @v2_unit_code	varchar(50)
    declare @v2_doctype		varchar(50)
    declare @v2_tot_supply  numeric(10)
    declare @v2_recptdt		datetime
    declare @v2_recptno		varchar(50)
    declare @v2_amount		numeric(15,2)
    declare @v2_bilagcd		varchar(50)
    declare @v2_bildpcd		varchar(50)
   
        
    
    declare @v_amt			numeric(15,2)
    declare @v_remark		varchar(500);
    declare @v_recptno		varchar(50);
    declare @v_dsign		numeric(5);
    
    declare @v_bran_code	varchar(20);
    declare @v_rec_no		numeric(10);  
    declare @v_unsold_copy	numeric(10);
    declare @vdistcode		varchar(4000);
    declare @vtalukacode	varchar(4000);

  Begin
    insert into cir_supl_process_det
        (comp_code, unit_code, publ_code, edtn_code, supdate, agcd, dpcd, tot_supply, per_copy_rate, no_of_supl, doctype, recptdt, recptno, amount, bilagcd, bildpcd, created_by, created_date, updated_by, updated_date, supl_name)
        select comp_code, unit_code, publ_code, edtn_code, supdate, agcd, dpcd, tot_supply, per_copy_rate, no_of_supl, doctype, recptdt, recptno, amount, bilagcd, bildpcd, created_by, created_date, updated_by, updated_date, supl_name 
        from cir_supl_process_det_temp 
        where comp_code=@pcompcode and unit_code=@punitcode and 
        agcd=@pagcode and dpcd= @pdepocode and recptno=@precptno and recptdt=@precptdt
           
             declare c2 cursor for
        select s.comp_code,s.unit_code,s.doctype,sum(s.tot_supply) tot_supply,s.recptdt,s.recptno,sum(s.amount) amount,s.bilagcd,s.bildpcd 
        from cir_supl_process_det s,cir_agmast m 
        where s.comp_code=m.comp_code and s.comp_code=@pcompcode and s.unit_code=m.unit and s.unit_code=@punitcode and 
        s.bilagcd=m.agcd and (s.bilagcd=@pagcode or @pagcode is null or @pagcode='') and s.bildpcd=m.dpcd and (s.bildpcd= @pdepocode or @pdepocode is null or @pdepocode='') and
        s.recptno=@precptno and s.recptdt=@precptdt
        group by s.comp_code,s.unit_code,s.doctype,s.recptdt,s.recptno,s.bilagcd,s.bildpcd
        having sum(s.amount)>0
        order by s.comp_code,s.unit_code,s.bilagcd,s.bildpcd
            
    If @pdoctype is null or @pdoctype='' Begin
        set @v_doctype='CN'
    End    
    Else Begin
        set @v_doctype=@pdoctype
    End
        
   set @v_amt=0

   open c2
		fetch NEXT FROM c2 INTO @v2_comp_code,@v2_unit_code,@v2_doctype,@v2_tot_supply,@v2_recptdt,@v2_recptno,@v2_amount,@v2_bilagcd,@v2_bildpcd 
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN
        select @v_bran_code=branch_code from cir_agmast 
            where comp_code=@v2_comp_code and unit=@v2_unit_code and agcd=@v2_bilagcd and dpcd=@v2_bildpcd;
        
        select @v_dsign=Dsign from cir_docmst where Comp_code=@pcompcode AND doc_type=@v_doctype

        If(@v_dsign=-1) Begin
            set @v_amt=@v2_amount*@v_dsign
        End    
        Else Begin
            set @v_amt=@v2_amount*@v_dsign
        End
        
        If @premark is null or @premark='' Begin
            set @v_remark='Being amount auto credited against suppliment charges'
        End    
        Else Begin
            set @v_remark=@premark
        End

		SELECT @v_rec_no  =  CAST( MAX(SUBSTRING(recptno, 5, 8))AS NUMERIC) + 1
		FROM  cir_rcphdr 
		WHERE comp_code  = @pcompcode AND doctype  = @pdoctype
		AND CONVERT(VARCHAR(23), recptdt) = CONVERT(VARCHAR(23), @v2_recptdt) AND branch_code  = @v_bran_code
		
		IF ISNULL(@v_rec_no, 0)= 0 BEGIN 
			SET @v_recptno  = @v_bran_code + '-' + REPLACE(CONVERT(VARCHAR(5), GETDATE(), 2), '.', '')+ '0001' 
		END
		ELSE BEGIN 
			SET @v_recptno  = @v_bran_code + '-' + dbo.fnPadLeft('0',8,@v_rec_no) 
		END
    
          insert into cir_rcphdr(comp_code,unit_code,agcd,dpcd,doctype,
                                 recptno,recptdt,amount,reason,remark,
                                 achd,voucherno,voucherdt,userid,creation_date,branch_code)
                          values(@v2_comp_code, @v2_unit_code,@v2_bilagcd, @v2_bildpcd,@v2_doctype,
                                 @v_recptno,@v2_recptdt,@v_amt,isnull(@preason,'SUPPLIMENT CHARGES'),@v_remark,
                                 'NM',@v_recptno,@v2_recptdt,@puserid,getdate(),@v_bran_code)
          insert into cir_rcpdet(comp_code,unit_code,agcd,dpcd,doctyp,
                                 recptno,recptdt,payfor,achd,amount,
                                 reason,remark,voucherno,voucherdt,usrid,
                                 creation_date,branch_code)
                          values(@v2_comp_code, @v2_unit_code,@v2_bilagcd, @v2_bildpcd,@v2_doctype,
                                 @v_recptno,@v2_recptdt,@v2_unit_code,'NM',@v_amt,
                                 isnull(@preason,'SUPPLIMENT CHARGES'),@v_remark,@v_recptno,@v2_recptdt,@puserid,
                                 getdate(),@v_bran_code);
          insert into cir_outmast(comp_code,unit_code,agcd,dpcd,doctyp,
                                  recptno,recptdt,achd,amount,reason,
                                  remark,voucherno,voucherdt,usrid,creation_date,branch_code)
                           values(@v2_comp_code, @v2_unit_code,@v2_bilagcd, @v2_bildpcd,@v2_doctype,
                                  @v_recptno,@v2_recptdt,'NM',@v_amt,isnull(@preason,'SUPPLIMENT CHARGES'),
                                  @v_remark,@v_recptno,@v2_recptdt,@puserid,getdate(),@v_bran_code)                               
        
          update cir_supl_process_det set recptno=@v_recptno
            where comp_code=@v2_comp_code and unit_code=@v2_unit_code and doctype=@v2_doctype and recptno=@precptno and 
                  recptdt=@v2_recptdt and supdate >= @pdatefrom and supdate <= @pdatetill and bilagcd = @v2_bilagcd and bildpcd = @v2_bildpcd
       fetch NEXT FROM c2 INTO @v2_comp_code,@v2_unit_code,@v2_doctype,@v2_tot_supply,@v2_recptdt,@v2_recptno,@v2_amount,@v2_bilagcd,@v2_bildpcd       
   End
   close c2;
	deallocate c2
   DELETE from cir_supl_process_det_temp where comp_code=@pcompcode and unit_code=@punitcode and 
          AGCD=@pagcode and dpcd= @pdepocode and recptno=@precptno and recptdt=@precptdt;
            
   select getdate() as "CUR_DATE" 
   
End



///////////////////////////////////////////////next

                                    
ALTER  procedure [dbo].[cir_fetch_expenses_data_p]
    @pcompcode       as varchar(20),
    @pagtype         as varchar(20),
    @pagclass        as varchar(20),
    @ppublcode       as varchar(20),
    @pmedtncode      as varchar(20),
    @pedtncode       as varchar(20),
    @psup_type       as varchar(20),
    @pagcd           as varchar(20),
    @pdpcd           as varchar(20),
    @pexptype        as varchar(20),
    @pcode           as varchar(4000),--for related code string 
    @pprocesstype    as varchar(20),--for process by Zone.Region,Branch,District,Route
    @pfreqtype       as varchar(20),--for frequency type (daily/weekly/monthly)
    @pdatefrom       as datetime,
    @pdatetill       as datetime,
    @pdelimiter      as varchar(20),
    @puserid         as varchar(20),
    @pdateformat     as varchar(20),
    @pextra1         as varchar(200),
    @pextra2         as varchar(200),
    @pextra3         as varchar(200),
    @pextra4         as varchar(200),
    @pextra5         as varchar(200)
  As
    declare @vlength     numeric(7);
    declare @vrunval     varchar(8000);
    declare @v_val       varchar(800);
    declare @v_name      varchar(8000);
    declare @v_sname     varchar(8000);
    declare @vno         int
    declare @v_doctype   varchar(10)
    set @v_doctype='CN'
    declare @v_recptdt		as datetime

	If @pagtype='' Begin
		set @pagtype=null
	End
	If @pagclass='' Begin
		set @pagclass=null
	End
	If @psup_type='' Begin
		set @psup_type=null
	End
	If @pagcd='' Begin
		set @pagcd=null
	End
	If @pdpcd='' Begin
		set @pdpcd=null
	End
	If @pcode='' Begin
		set @pcode=null
	End
	If @pprocesstype='' Begin
		set @pprocesstype=null
	End
	If @pfreqtype='' Begin
		set @pfreqtype=null
	End
	If @pextra1='' Begin
		set @pextra1=null
	End									
	If @pextra2='' Begin
		set @pextra2=null
	End
	If @pextra3='' Begin
		set @pextra3=null
	End									
	If @pextra4='' Begin
		set @pextra4=null
	End
	If @pextra5='' Begin
		set @pextra5=null
	End

	CREATE TABLE #CIR_LEDGER_REPORT
	( COMP_CODE			VARCHAR(100),
	  UNIT_CODE			VARCHAR(100),
	  DEBIT_HEAD		VARCHAR(100),
	  REC_SEQNO			INT)
	  	
	declare @v1_comp_code		as varchar(20)
	declare @v1_unit_code		as varchar(20)
	declare @v1_agcd			as varchar(20)
	declare @v1_dpcd			as varchar(20)
	declare @v1_agency_name		as varchar(200)
	declare @v1_station_code	as varchar(20)
	declare @v1_city_code		as varchar(20)
	declare @v1_exp_type_code	as varchar(20)
	declare @v1_exp_type_desc	as varchar(20)
	
    declare @v1_exp_type_mode	as varchar(50)
    declare @v1_exp_calc_type	as varchar(20)
    declare @v1_exp_amount		as numeric(15,2)
    declare @v1_cn_through		as varchar(20)
    declare @v1_valid_days		as int
    declare @v1_sup_copy		as numeric(10)
    declare @v1_publ			as varchar(20)
    declare @v1_edtn			as varchar(20)
    declare @v1_sup_type_code	as varchar(20)
    declare @v1_exp_reason		as varchar(20)
    declare @v1_billagcd		as varchar(20)
    declare @v1_billdpcd		as varchar(20)

    
    DECLARE c1 cursor FOR
        select m.comp_code,d.unit_code,m.agcd,m.dpcd,m.ag_name agency_name,m.station_code,m.city_code,e.exp_type_code,t.exp_type_desc,
        case when e.exp_type_mode='F' then 'Fix' else 'Per' end exp_type_mode,
        case when e.exp_type_mode='F' then 'Fix' else 'Per' end exp_calc_type,
        e.exp_amount exp_amount,
        case when e.cn_through='V' then 'Voucher' else 'Direct' end cn_through
        ,e.valid_days,sum(d.sup_copy) sup_copy, d.publ publ,d.edtn edtn ,d.sup_type_code sup_type_code,t.exp_reason exp_reason,d.billagcd billagcd,
        d.billdpcd billdpcd
        from cir_agmast m,cir_expenses_detail e,cir_expenses_type_mast t,
        cir_dbksup d,cir_edtn_mast c
        where m.comp_code=e.comp_code and m.comp_code=t.comp_code and m.comp_code=d.comp_code and m.comp_code=c.comp_code and m.comp_code=@pcompcode and 
        m.unit=e.unit and m.unit=d.unit_code and m.agcd=e.agcd and m.agcd=d.agcd and m.dpcd=e.dpcd and m.dpcd=d.dpcd and 
        e.exp_type_code=t.exp_type_code and e.publ_code=d.publ and e.publ_code=c.publ 
        and (e.publ_code=isnull('',e.publ_code) or @ppublcode =''  or @ppublcode =' ')
        and e.edtn_code=d.edtn and e.edtn_code=c.edtn 
        and (e.edtn_code=isnull(@pedtncode,e.edtn_code)  or @pedtncode =''  or @pedtncode =' ')
        and (c.main_edtn=isnull(@pmedtncode,c.main_edtn)  or @pmedtncode =''  or @pmedtncode =' ')
        and e.supply_type=d.sup_type_code 
        and (e.supply_type=isnull(@psup_type,e.supply_type) or @psup_type =''  or @psup_type =' ')
        and (e.exp_frequency=isnull(@pfreqtype,e.exp_frequency) or @pfreqtype =''  or @pfreqtype =' ')
        and d.supdate between @pdatefrom and @pdatetill 
		and isnull(e.freeze_flag,'N')='N'
		--new add
		AND e.COMP_CODE+e.UNIT+e.AGCD+e.DPCD+e.PUBL_code+e.EDTN_code+e.EXP_TYPE_CODE
        NOT IN(SELECT p.COMP_CODE+p.UNIT_CODE+p.AGCD+p.DPCD+p.PUBL_code+p.EDTN_code+p.EXP_TYPE_CODE FROM cir_inct_process_det p
        WHERE TRAN_TYPE='EXP')
        
        group by m.comp_code,d.unit_code,m.agcd,m.dpcd,m.ag_name,m.station_code,m.city_code,e.exp_type_code,t.exp_type_desc,
        e.exp_type_mode,e.exp_type_mode,e.exp_amount,e.cn_through,e.valid_days,d.publ,d.edtn,t.exp_reason,d.sup_type_code,d.billagcd,d.billdpcd
        order by agency_name,exp_type_desc,publ,edtn,sup_type_code;

    declare @v_amt           numeric(15,2)
    declare @v_remark        varchar(500)
    declare @v_recptno       varchar(50)
    declare @v_dsign         numeric(5)
    
    declare @v_bran_code     varchar(20)
    declare @v_rec_no        numeric(10)  
    declare @v_unsold_copy   numeric(10)
    declare @vdistcode       varchar(4000)
    declare @v_process_id    numeric(30)

    set @v_recptdt   =@pdatetill
  
    /*if @pcode is not null Begin
        set @vdistcode=@pcode+',';

        set @vlength =null set @v_val =null set @v_name=null set @vrunval =null set @vno=null
        set @v_val   =replace(@vdistcode,',',',')
        set @vlength =length(@v_val)
        set @vno=1

        for i in 1.. vlength loop
            set @vrunval=substring(@v_val,i,1)
            If @vrunval!=',' Begin
                set @v_name:=@v_name+@vrunval
            End    
            Else Begin
                insert into CIR_LEDGER_REPORT(comp_code ,unit_code ,debit_head,credit_head,rec_seqno,sess_id)
                        values (pcompcode,null,v_name,null,vno,userenv('sessionid'));
                set @vno=@vno+1
                set @v_name=''
            End
        End
    End*/
    
    exec cir_generate_processid @pcompcode,@puserid,@pdateformat,null,null,null,null,null,@v_process_id OUTPUT
 
    open c1
    
        fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit_code,@v1_agcd,@v1_dpcd,@v1_agency_name,@v1_station_code,@v1_city_code,@v1_exp_type_code,@v1_exp_type_desc,
			@v1_exp_type_mode,@v1_exp_calc_type,@v1_exp_amount,@v1_cn_through,@v1_valid_days,@v1_sup_copy, @v1_publ,@v1_edtn ,@v1_sup_type_code,@v1_exp_reason,@v1_billagcd,@v1_billdpcd
        WHILE (@@FETCH_STATUS = 0) BEGIN 
     
        PRINT(@v1_cn_through)
			If @v1_exp_type_mode='P' Begin
			
				set @v_amt=round(isnull(@v1_sup_copy,0)*(isnull(@v1_exp_amount,0)/100),2)
				print(@v_amt)
				
			End	
			Else Begin
			set @v_amt=round(isnull(@v1_exp_amount,0),2)
				--set @v_amt=round(isnull(@v1_sup_copy,0)+isnull(@v1_exp_amount,0),2)
			End
			If isnull(@v_amt,0)<>0 Begin
				insert into cir_inct_process_det_temp(comp_code,unit_code,publ_code,edtn_code,sup_type_code,from_pdate,till_pdate,
								agcd,dpcd,tot_supply,from_supply,till_supply,inct_rate,calc_type,amount,
								doctype,recptdt,recptno,bilagcd,bildpcd,created_by,tran_type,reason,exp_type_code,CN_THROUGH,EXP_TYPE_DESC)
						values(@v1_comp_code,@v1_unit_code,@v1_publ,@v1_edtn,@v1_sup_type_code,@pdatefrom,@pdatetill,
								@v1_agcd,@v1_dpcd,isnull(@v1_sup_copy,0),@v1_valid_days,0,@v1_exp_amount,@v1_exp_type_mode,@v_amt,
								@v_doctype,@v_recptdt,@v_process_id,@v1_billagcd,@v1_billdpcd,@puserid,'EXP',@v1_exp_reason,@v1_exp_type_code,@v1_cn_through,@v1_exp_type_desc);
			End
		fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit_code,@v1_agcd,@v1_dpcd,@v1_agency_name,@v1_station_code,@v1_city_code,@v1_exp_type_code,@v1_exp_type_desc,
			@v1_exp_type_mode,@v1_exp_calc_type,@v1_exp_amount,@v1_cn_through,@v1_valid_days,@v1_sup_copy, @v1_publ,@v1_edtn ,@v1_sup_type_code,@v1_exp_reason,@v1_billagcd,@v1_billdpcd
		End
   close c1
   deallocate c1

   set @v_amt=0
PRINT('DDD')
PRINT(@v_process_id)
    select s.comp_code as "COMP_CODE",s.unit_code AS "UNIT_CODE",s.recptno as "RECPTNO",s.recptdt as "RECPTDT",
    s.doctype as "DOCTYPE", s.bilagcd AS "AGCD",s.bildpcd AS "DPCD",m.ag_name AS "AG_NAME",
    dbo.cir_get_drop_point_name(s.comp_code,s.unit_code,m.station_code,1) as "DROP_POINT_NAME",
    dbo.cir_get_city(s.comp_code,m.city_code) as "CITY_NAME", sum(s.tot_supply) as "SUPPLY",
    s.publ_code as "PUBL_CODE" ,dbo.cir_get_publ_name(s.comp_Code,s.publ_code) as "PUBL_NAME",
    s.inct_rate AS "EXP_RATE",s.calc_type as "CALC_TYPE",
    case s.calc_type when 'Fix' then  sum(s.amount) 
    else sum(isnull(s.inct_rate,0))* sum(isnull(s.tot_supply,0)) end
    as "AMOUNT",    
    s.from_supply as "VALID_DAYS",s.cn_through as "CN_THROUGH",
    dbo.cir_get_payreason(s.comp_code,'',s.reason,'','','','','','') as "REASON",EXP_TYPE_DESC ,
    s.EXP_TYPE_CODE EXP_TYPE_CODE,s.reason REASON_CODE
    from cir_inct_process_det_temp s,cir_agmast m,cir_edtn_mast e
    where s.comp_code=m.comp_code and s.comp_code=e.comp_code and s.edtn_code=e.edtn and 
    s.unit_code=m.unit and s.bilagcd=m.agcd and s.bildpcd=m.dpcd and s.recptno=@v_process_id and tran_type='EXP'
    group by s.comp_code,s.unit_code,s.recptno,s.recptdt,s.doctype,s.inct_rate,s.calc_type,
    s.bilagcd,s.bildpcd,m.station_code,m.city_code,m.ag_name,s.publ_code,s.EXP_TYPE_DESC,s.from_supply
    ,s.cn_through,s.reason,s.EXP_TYPE_CODE,s.reason  having sum(amount)>0  order by comp_code,unit_code,bilagcd,bildpcd,publ_name
   
   
   select getdate() as "CUR_DATE"
   
   drop table #cir_ledger_report;





///////////////////////////////////////////////////////////////////////////////////////


                                        
ALTER procedure [dbo].[cir_expenses_cn_process_p]
    @pcompcode       as varchar(20),
    @punitcode       as varchar(20),
    @ppublcode       as varchar(20),
    @pagcode         as varchar(20),
    @pdepocode       as varchar(20),
    @pdatefrom       as datetime,
    @pdatetill       as datetime,
    @pdoctype        as varchar(20),
    @precptdt        as datetime,
    @precptno        as varchar(50),
    @preason         as varchar(50),
    @pexp_type_code  as varchar(50),
    @ptot_supply     as numeric(6),
    @premark         as varchar(500),
    @puserid         as varchar(20),
    @pdateformat     as varchar(20),
    @pextra1         as varchar(50),
    @pextra2         as varchar(50),
    @pextra3         as varchar(50),
    @pextra4         as varchar(50),
    @pextra5         as varchar(50)
  As
    declare @v_doctype		varchar(10)
    declare @v_dt			datetime
    declare @v_sess_id		varchar(30)
    declare @v2_comp_code	varchar(50)
    declare @v2_unit_code	varchar(50)
    declare @v2_publ_code	varchar(50)
    declare @v2_doctype		varchar(50)
    declare @v2_tot_supply  numeric(10)
    declare @v2_recptdt		datetime
    declare @v2_recptno		varchar(50)
    declare @v2_amount		numeric(15,2)
    declare @v2_bilagcd		varchar(50)
    declare @v2_bildpcd		varchar(50)
    declare @v2_exp_type_code	varchar(50)
    declare @v2_valid_days	numeric(10)
    declare @v2_cn_through	varchar(50)
    declare @v2_calc_type   varchar(50)
    declare @v2_inct_rate   varchar(50)
    
    
    declare @v_amt			numeric(15,2)
    declare @v_remark		varchar(500);
    declare @v_recptno		varchar(50);
    declare @v_dsign		numeric(5);
    
    declare @v_bran_code	varchar(20);
    declare @v_rec_no		numeric(10);  
    declare @v_unsold_copy	numeric(10);
    declare @vdistcode		varchar(4000);
    declare @vtalukacode	varchar(4000);

  Begin
  
   If @pdoctype is null or @pdoctype='' Begin
        set @v_doctype='CN'
    End    
    Else Begin
        set @v_doctype=@pdoctype
    End
        
   set @v_amt=0
  
    insert into cir_inct_process_det
        (comp_code, unit_code, publ_code, edtn_code,sup_type_code, from_pdate,till_pdate, agcd, dpcd, tot_supply, inct_rate,calc_type, doctype, recptdt, recptno, amount, bilagcd, bildpcd, created_by, created_date, updated_by, updated_date, 
        exp_type_code,reason,tran_type,from_supply,cn_through)
        select comp_code, unit_code, publ_code, edtn_code,sup_type_code, from_pdate,till_pdate, agcd, dpcd, @ptot_supply tot_supply, inct_rate,calc_type, doctype, recptdt, recptno, case when calc_type='P' then round(isnull(@ptot_supply,0)*isnull(inct_rate,0),2) else isnull(inct_rate,0) end amount, 
        bilagcd, bildpcd, created_by, created_date, updated_by, updated_date,
        exp_type_code,reason,tran_type,from_supply,cn_through
        from cir_inct_process_det_temp where comp_code=@pcompcode and unit_code=@punitcode and 
            bilagcd=@pagcode and bildpcd= @pdepocode and recptno=@precptno and recptdt=@precptdt and exp_type_code=@pexp_type_code and publ_code=@ppublcode and tran_type='EXP' and @ptot_supply>0

	declare c2 cursor for
        select s.comp_code,s.unit_code,s.publ_code,s.doctype,s.exp_type_code exp_type_code,sum(s.tot_supply) tot_supply,s.recptdt,s.recptno,sum(s.amount) amount,
        s.bilagcd,s.bildpcd ,s.from_supply valid_days,s.cn_through cn_through,s.calc_type ,s.inct_rate
        from cir_inct_process_det s,cir_agmast m 
        where s.comp_code=m.comp_code and s.comp_code=@pcompcode and s.unit_code=m.unit and s.unit_code=@punitcode and 
        s.bilagcd=m.agcd and (s.bilagcd=@pagcode or @pagcode is null or @pagcode='') and s.bildpcd=m.dpcd and (s.bildpcd= @pdepocode or @pdepocode is null or @pdepocode='') and
        s.recptno=@precptno and s.recptdt=@precptdt and s.exp_type_code=@pexp_type_code and s.tran_type='EXP'
        group by s.comp_code,s.unit_code,s.doctype,s.exp_type_code,s.recptdt,s.recptno,s.bilagcd,s.bildpcd,s.publ_code,s.from_supply,s.cn_through,s.calc_type ,s.inct_rate
        having sum(s.amount)>0
        order by s.comp_code,s.unit_code,s.bilagcd,s.bildpcd

   open c2
		fetch NEXT FROM c2 INTO @v2_comp_code,@v2_unit_code,@v2_publ_code,@v2_doctype,@v2_exp_type_code,@v2_tot_supply,@v2_recptdt,@v2_recptno,@v2_amount,@v2_bilagcd,@v2_bildpcd,@v2_valid_days,@v2_cn_through ,@v2_calc_type,@v2_inct_rate
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN
		print(@@cursor_rows)
        select @v_bran_code=branch_code from cir_agmast 
            where comp_code=@v2_comp_code and unit=@v2_unit_code and agcd=@v2_bilagcd and dpcd=@v2_bildpcd;
        
        select @v_dsign=Dsign from cir_docmst where Comp_code=@pcompcode AND doc_type=@v_doctype
print('@v2_calc_type') print(@v2_calc_type)
		if @v2_calc_type !='Fix'
		begin
			set @v2_amount=isnull(@v2_tot_supply,0)*isnull(@v2_inct_rate,0)
		end		

        If(@v_dsign=-1) Begin
            set @v_amt=@v2_amount*@v_dsign
        End    
        Else Begin
            set @v_amt=@v2_amount*@v_dsign
        End
        
        If @premark is null or @premark='' Begin
            set @v_remark='Being amount auto credited against Expenses charges'
        End    
        Else Begin
            set @v_remark=@premark
        End
        
        
		print('@v2_cn_through')print(@v2_cn_through)
		If @v2_cn_through='Direct' Begin
			SELECT @v_rec_no  =  CAST( MAX(SUBSTRING(recptno, 5, 8))AS NUMERIC) + 1 FROM  cir_rcphdr 
			WHERE comp_code  = @pcompcode AND doctype  = @pdoctype
			AND CONVERT(VARCHAR(23), recptdt) = CONVERT(VARCHAR(23), @v2_recptdt) AND branch_code  = @v_bran_code
			
			IF ISNULL(@v_rec_no, 0)= 0 BEGIN 
				SET @v_recptno  = @v_bran_code + '-' + REPLACE(CONVERT(VARCHAR(5), GETDATE(), 2), '.', '')+ '0001' 
			END
			ELSE BEGIN 
				SET @v_recptno  = @v_bran_code + '-' + dbo.fnPadLeft('0',8,@v_rec_no) 
			END
			print('@v_recptno1')print(@v_recptno)
			  insert into cir_rcphdr(comp_code,unit_code,agcd,dpcd,doctype,
									 recptno,recptdt,amount,reason,remark,
									 achd,voucherno,voucherdt,userid,creation_date,branch_code)
							  values(@v2_comp_code, @v2_unit_code,@v2_bilagcd, @v2_bildpcd,@v2_doctype,
									 @v_recptno,@v2_recptdt,@v_amt,isnull(@preason,'EXPENSES CHARGES'),@v_remark,
									 'NM',@v_recptno,@v2_recptdt,@puserid,getdate(),@v_bran_code)
			  insert into cir_rcpdet(comp_code,unit_code,agcd,dpcd,doctyp,publ,
									 recptno,recptdt,payfor,achd,amount,
									 reason,remark,voucherno,voucherdt,usrid,
									 creation_date,branch_code)
							  values(@v2_comp_code, @v2_unit_code,@v2_bilagcd, @v2_bildpcd,@v2_doctype,@v2_publ_code,
									 @v_recptno,@v2_recptdt,@v2_unit_code,'NM',@v_amt,
									 isnull(@preason,'EXPENSES CHARGES'),@v_remark,@v_recptno,@v2_recptdt,@puserid,
									 getdate(),@v_bran_code);
			  insert into cir_outmast(comp_code,unit_code,agcd,dpcd,doctyp,publ,
									  recptno,recptdt,achd,amount,reason,
									  remark,voucherno,voucherdt,usrid,creation_date,branch_code)
							   values(@v2_comp_code, @v2_unit_code,@v2_bilagcd, @v2_bildpcd,@v2_doctype,@v2_publ_code,
									  @v_recptno,@v2_recptdt,'NM',@v_amt,isnull(@preason,'EXPENSES CHARGES'),
									  @v_remark,@v_recptno,@v2_recptdt,@puserid,getdate(),@v_bran_code)                               

			End
			Else Begin print('Q')
				SELECT @v_rec_no  =  CAST( MAX(SUBSTRING(recptno, 5, 8))AS NUMERIC) + 1
				FROM  cir_rcphdr_prov
				WHERE comp_code  = @pcompcode AND doctype  = @pdoctype
				AND CONVERT(VARCHAR(23), recptdt) = CONVERT(VARCHAR(23), @v2_recptdt) AND branch_code  = @v_bran_code
				
				IF ISNULL(@v_rec_no, 0)= 0 BEGIN 
					SET @v_recptno  = @v_bran_code + '-P' + REPLACE(CONVERT(VARCHAR(5), GETDATE(), 2), '.', '')+ '0001' 
				END
				ELSE BEGIN 
					SET @v_recptno  = @v_bran_code + '-P' + dbo.fnPadLeft('0',8,@v_rec_no) 
				END
		    print('@v_recptno')print(@v_recptno)
				  insert into cir_rcphdr_prov(comp_code,unit_code,agcd,dpcd,doctype,
										 recptno,recptdt,amount,reason,remark,
										 achd,userid,creation_date,branch_code,ocds)
								  values(@v2_comp_code, @v2_unit_code,@v2_bilagcd, @v2_bildpcd,@v2_doctype,
										 @v_recptno,@v2_recptdt,@v_amt,isnull(@preason,'EXPENSES CHARGES'),@v_remark,
										 'NM',@puserid,getdate(),@v_bran_code,cast(@v2_valid_days as numeric))			
			End
			
			update cir_inct_process_det set recptno=@v_recptno
				where comp_code=@v2_comp_code and unit_code=@v2_unit_code and doctype=@v2_doctype and recptno=@precptno and 
                  recptdt=@v2_recptdt and from_pdate = @pdatefrom and till_pdate = @pdatetill and bilagcd = @v2_bilagcd and bildpcd = @v2_bildpcd and publ_code=@v2_publ_code and exp_type_code=@v2_exp_type_code and tran_type='EXP';
    
	        delete from cir_inct_process_det_temp        
		        where comp_code=@v2_comp_code and unit_code=@v2_unit_code and doctype=@v2_doctype and recptno=@precptno and 
			          recptdt=@v2_recptdt and from_pdate = @pdatefrom and till_pdate = @pdatetill and bilagcd = @v2_bilagcd and bildpcd = @v2_bildpcd and publ_code=@v2_publ_code and exp_type_code=@v2_exp_type_code and tran_type='EXP';
       fetch NEXT FROM c2 INTO @v2_comp_code,@v2_unit_code,@v2_publ_code,@v2_doctype,@v2_exp_type_code,@v2_tot_supply,@v2_recptdt,@v2_recptno,@v2_amount,@v2_bilagcd,@v2_bildpcd,@v2_valid_days,@v2_cn_through,@v2_calc_type,@v2_inct_rate
   End
   close c2;
	deallocate c2
   delete from cir_inct_process_det_temp where comp_code=@pcompcode and unit_code=@punitcode and 
            bilagcd=@pagcode and bildpcd= @pdepocode and recptno=@precptno and recptdt=@precptdt and publ_code=@ppublcode and exp_type_code=@pexp_type_code and tran_type='EXP';
            
   select getdate() as "CUR_DATE" 
   
End


/////////////////////////////////////////////////////next



create FUNCTION [dbo].[cir_get_bankname](@pcomp_code VARCHAR(20),@pbankcode VARCHAR(50)) RETURNS VARCHAR (200)
BEGIN
declare @v_nm as VARCHAR(200);

	SELECT @v_nm=bankname  FROM CIR_BANK_MAST
		WHERE bankcode =@pbankcode and comp_code = @pcomp_code;

	RETURN @v_nm;
	
END

/////////////////////////////////////


ALTER procedure [dbo].[cir_pending_bills_for_inst]
    @pcompcode       as varchar(50),
    @punitcode       as varchar(50),
    @pagcd           as varchar(50),
    @pdpcd           as varchar(50),   
    @ppubltype       as varchar(50),
    @ppublcode       as varchar(50),
    @pfromdate       as datetime, 
    @ptilldate       as datetime,
    @puserid         as varchar(50), 
    @pdateformate    as varchar(50),
    @pextra1         as varchar(50),
    @pextra2         as varchar(50),
    @pextra3         as varchar(50),
    @pextra4         as varchar(50),
    @pextra5         as varchar(50),
    @pextra6         as varchar(50),
    @pextra7         as varchar(50),
    @pextra8         as varchar(50),
    @pextra9         as varchar(50),
    @pextra10        as varchar(50)
as

begin
	If @punitcode='' Begin
		set @punitcode=null
	End
	If @pagcd='' Begin
		set @pagcd=null
	End
	If @pdpcd='' Begin
		set @pdpcd=null
	End
	If @ppubltype='' Begin
		set @ppubltype=null
	End
	If @ppublcode='' Begin
		set @ppublcode=null
	End
	If @pextra1='' Begin
		set @pextra1=null
	End
	If @pextra2='' Begin
		set @pextra2=null
	End
	If @pextra3='' Begin
		set @pextra3=null
	End
	If @pextra4='' Begin
		set @pextra4=null
	End
	If @pextra5='' Begin
		set @pextra5=null
	End
	If @pextra6='' Begin
		set @pextra6=null
	End
	If @pextra7='' Begin
		set @pextra7=null
	End
	If @pextra8='' Begin
		set @pextra8=null
	End
	If @pextra9='' Begin
		set @pextra9=null
	End
		If @pextra10='' Begin
		set @pextra10=null
	End

        if @ppubltype is null and @ppublcode is null Begin
            select o.comp_code AS "COMP_CODE",o.unit_code AS "UNIT_CODE",o.agcd as "AGCD",o.dpcd as "DPCD", m.ag_name as "AGENCY_NAME",
            m.station_code as "DROP_POINT",dbo.cir_get_drop_point_name(o.comp_code,o.unit_code,m.station_code,1) as "DROP_POINT_NAME", 
            m.city_code as "CITY_CODE",dbo.cir_get_city(o.comp_code,m.city_code) as "CITY_NAME",  
            o.billno as "BILLNO", o.billdt as "BILLDT" ,dbo.cir_get_publ_type(o.comp_code,o.publ,null,null) as "PUBL_TYPE_NAME",
            o.publ as "PUBL" ,dbo.cir_get_publ_name(o.comp_code,o.publ) as "PUBL_NAME",
            b.amount as "BILL_AMOUNT",
            --sum(o.amount) as "DUE_AMOUNT" 
             sum(o.amount)-isnull((select sum(i.INST_DUE_AMT)    from  CIR_INST_BILL_DET i where i.COMP_CODE=o.comp_code
             and  i.UNIT_CODE=o.unit_code and i.INST_BILLNO= o.billno and  convert(varchar(10),i.INST_BILLDT,101) =convert(varchar(10),o.billdt,101)
            ),0)
           
             as "DUE_AMOUNT" 
   
            from cir_outmast o,cir_agmast m,cir_outmast b 
                where o.comp_code=m.comp_code and o.comp_code=b.comp_code and o.comp_code=@pcompcode and 
                     o.unit_code=m.unit and o.unit_code=b.unit_code and o.unit_code=@punitcode and o.doctyp=b.doctyp and o.doctyp='BIL' and 
                    o.agcd=m.agcd and o.agcd=b.agcd and o.agcd =isnull(@pagcd,o.agcd) and o.dpcd=m.dpcd and o.dpcd=b.dpcd and o.dpcd =isnull(@pdpcd,o.dpcd) and 
                    o.billdt=b.billdt and o.billdt between @pfromdate and @ptilldate and (o.publ = @ppublcode or @ppublcode is null) and 
                    o.billno=b.billno and o.billno  is not null and isnull(b.dispute_flag,'N')='N'
                
                group by  o.comp_code,o.unit_code,o.agcd,o.dpcd,m.ag_name,m.station_code,m.city_code,o.billno, o.billdt, o.publ,b.amount,isnull(b.dispute_flag,'N')
                having (sum( o.amount )-isnull((select sum(i.INST_DUE_AMT)    from  CIR_INST_BILL_DET i where i.COMP_CODE=o.comp_code
             and  i.UNIT_CODE=o.unit_code and i.INST_BILLNO= o.billno and  convert(varchar(10),i.INST_BILLDT,101) =convert(varchar(10),o.billdt,101)
            ),0))>0
                order by PUBL_TYPE_NAME,agency_name,billdt,billno
		End                
        Else Begin
            select o.comp_code AS "COMP_CODE",o.unit_code AS "UNIT_CODE",o.agcd as "AGCD",o.dpcd as "DPCD", m.ag_name as "AGENCY_NAME",
            m.station_code as "DROP_POINT",dbo.cir_get_drop_point_name(o.comp_code,o.unit_code,m.station_code,1) as "DROP_POINT_NAME", 
            m.city_code as "CITY_CODE",dbo.cir_get_city(o.comp_code,m.city_code) as "CITY_NAME",  
            o.billno as "BILLNO", o.billdt as "BILLDT" ,dbo.cir_get_publ_type(o.comp_code,o.publ,null,null) as "PUBL_TYPE_NAME",
            o.publ as "PUBL" ,dbo.cir_get_publ_name(o.comp_code,o.publ) as "PUBL_NAME",
            b.amount as "BILL_AMOUNT",
            --sum(o.amount) as "DUE_AMOUNT" 
             sum(o.amount)-isnull((select sum(i.INST_DUE_AMT)    from  CIR_INST_BILL_DET i where i.COMP_CODE=o.comp_code
             and  i.UNIT_CODE=o.unit_code and i.INST_BILLNO= o.billno and  convert(varchar(10),i.INST_BILLDT,101) =convert(varchar(10),o.billdt,101)
            ),0)
           
             as "DUE_AMOUNT" 
            
            from cir_outmast o,cir_agmast m,cir_outmast b 
                where o.comp_code=m.comp_code and o.comp_code=b.comp_code and o.comp_code=@pcompcode and 
                     o.unit_code=m.unit and o.unit_code=b.unit_code and o.unit_code=@punitcode and o.doctyp=b.doctyp and o.doctyp='BIL' and 
                    o.agcd=m.agcd and o.agcd=b.agcd and o.agcd =isnull(@pagcd,o.agcd) and o.dpcd=m.dpcd and o.dpcd=b.dpcd and o.dpcd =isnull(@pdpcd,o.dpcd) and 
                    o.billdt=b.billdt and o.billdt between @pfromdate and @ptilldate and (o.publ = @ppublcode or @ppublcode is null) and 
                    o.billno=b.billno and o.billno  is not null and isnull(b.dispute_flag,'N')='N' and 
                    b.publ in(select publ from cir_publ_mast where comp_code=@pcompcode and publ=isnull(@ppublcode,publ) and pro_type=isnull(@ppubltype,pro_type)) 
              
                group by  o.comp_code,o.unit_code,o.agcd,o.dpcd,m.ag_name,m.station_code,m.city_code,o.billno, o.billdt, o.publ,b.amount,isnull(b.dispute_flag,'N')
                having (sum( o.amount )-isnull((select sum(i.INST_DUE_AMT)    from  CIR_INST_BILL_DET i where i.COMP_CODE=o.comp_code
             and  i.UNIT_CODE=o.unit_code and i.INST_BILLNO= o.billno and  convert(varchar(10),i.INST_BILLDT,101) =convert(varchar(10),o.billdt,101)
            ),0))>0
                order by PUBL_TYPE_NAME,agency_name,billdt,billno;
         End
    
	select getdate() as "CUR_DATE"
    
End


//////////////////////////////////////////////






alter PROCEDURE [dbo].[cir_pendind_installment]
	@pcompcode                                VARCHAR(20) ,
	@punitcode                                VARCHAR(20) ,
	@pinst_code                               VARCHAR(400) ,
	@pinst_no                                  VARCHAR(400) 
AS 
	
	
	select SUM(INST_DUE_AMT) as INST_DUE_AMT
    from CIR_INST_BILL_DET where 
    comp_code  = @pcompcode and  unit_code  = @punitcode
    and INST_NO=@pinst_no and INST_CODE=@pinst_code 
		



//////////////////////////////////////////////



ALTER PROCEDURE [dbo].[cir_agency_bind_branchwise]
    @pcompcode            VARCHAR(20) ,
    @punit              VARCHAR(20) ,
    @pdateformat        VARCHAR(20) ,
    @pdistcode          VARCHAR(20)=null,  
    @pextra1            VARCHAR(4000) ,
    @pextra2            VARCHAR(4000), -- for branchwise or main receipt entry
    @pextra3            VARCHAR(4000),-- for all agency or main agency
    @pextra4            VARCHAR(4000),
    @pextra5            VARCHAR(4000)
AS 
BEGIN
	
	if ISNULL(@pextra3,'A')='A'
    begin
		SELECT cir_agmast.*,dbo.cir_get_city(cir_agmast.comp_code,cir_agmast.city_code) "CITY_NAME",
		dbo.cir_get_agency(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.agcd,cir_agmast.dpcd) "BILL_AGENCY",
		dbo.cir_get_agency_city(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.agcd,cir_agmast.dpcd) "BILL_AGENCY_CITY",
		dbo.cir_get_drop_point_name(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.station_code,1) as "DROP_POINT_NAME"
		FROM  cir_agmast 
		WHERE comp_code  = @pcompcode AND unit  = @punit 
		AND ((UPPER(ag_name)  like UPPER(CAST(@pextra1 AS VARCHAR) + '%')) OR    (@pextra1  is null) OR    (@pextra1  = ''))
		and isnull(TO_BILL,'N')='Y'
		and (BRANCH_CODE =isnull(@pextra2,'') or isnull(@pextra2,'') is null or isnull(@pextra2,'') ='')
		union
		SELECT cir_agmast.*,dbo.cir_get_city(cir_agmast.comp_code,cir_agmast.city_code) "CITY_NAME",
		dbo.cir_get_agency(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.agcd,cir_agmast.dpcd) "BILL_AGENCY",
		dbo.cir_get_agency_city(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.agcd,cir_agmast.dpcd) "BILL_AGENCY_CITY",
		dbo.cir_get_drop_point_name(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.station_code,1) as "DROP_POINT_NAME"
		FROM  cir_agmast 
		WHERE comp_code  = @pcompcode AND unit  = @punit 	
		AND ((UPPER(agcd)  like UPPER(CAST(@pextra1 AS VARCHAR) + '%')) OR    (@pextra1  is null) OR    (@pextra1  = ''))
		and isnull(TO_BILL,'N')='Y'
		and (BRANCH_CODE =isnull(@pextra2,'') or isnull(@pextra2,'') is null or isnull(@pextra2,'') ='')
		ORDER BY 5
	end
	else
	begin
		SELECT cir_agmast.*,dbo.cir_get_city(cir_agmast.comp_code,cir_agmast.city_code) "CITY_NAME",
		dbo.cir_get_agency(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.agcd,cir_agmast.dpcd) "BILL_AGENCY",
		dbo.cir_get_agency_city(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.agcd,cir_agmast.dpcd) "BILL_AGENCY_CITY",
		dbo.cir_get_drop_point_name(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.station_code,1) as "DROP_POINT_NAME"
		FROM  cir_agmast 
		WHERE comp_code  = @pcompcode AND unit  = @punit 
		AND ((UPPER(ag_name)  like UPPER(CAST(@pextra1 AS VARCHAR) + '%')) OR    (@pextra1  is null) OR    (@pextra1  = ''))
		and isnull(TO_BILL,'N')='Y'
		and (BRANCH_CODE =isnull(@pextra2,'') or isnull(@pextra2,'') is null or isnull(@pextra2,'') ='')
		and (DPCD='0001')
		union
		SELECT cir_agmast.*,dbo.cir_get_city(cir_agmast.comp_code,cir_agmast.city_code) "CITY_NAME",
		dbo.cir_get_agency(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.agcd,cir_agmast.dpcd) "BILL_AGENCY",
		dbo.cir_get_agency_city(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.agcd,cir_agmast.dpcd) "BILL_AGENCY_CITY",
		dbo.cir_get_drop_point_name(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.station_code,1) as "DROP_POINT_NAME"
		FROM  cir_agmast 
		WHERE comp_code  = @pcompcode AND unit  = @punit 	
		AND ((UPPER(agcd)  like UPPER(CAST(@pextra1 AS VARCHAR) + '%')) OR    (@pextra1  is null) OR    (@pextra1  = ''))
		and isnull(TO_BILL,'N')='Y'
		and (BRANCH_CODE =isnull(@pextra2,'') or isnull(@pextra2,'') is null or isnull(@pextra2,'') ='')
		and (DPCD='0001')
		ORDER BY 5
	end	

END


////////////////////////////////////////////////next




ALTER PROCEDURE [dbo].[cir_unsold_credit_note_cir_notapproval_list_p]
    @pcomp_code    as varchar(50),
    @punit_code    as varchar(50),
    @pdoc_type     As varchar(50),
    @pdateformat   as varchar(50),
    @pextra1       as varchar(50),
    @pextra2       As varchar(50),
	@pextra3       as varchar(50), -- for receipt no
	@pextra4       as varchar(50), --Unsold base of Supdate and Publication
	@pextra5       as varchar(50) 
As
Begin
If upper(@pextra4)='Y' Begin

    If upper(@pextra2)='D' Begin
        SELECT DISTINCT H.RECPTDT RECPTDT,H.AGCD AGCD,H.DPCD DPCD,DBO.CIR_GET_AGENCY(H.COMP_CODE,H.UNIT_CODE,H.AGCD,H.DPCD) AGENCY_NAME,
        DBO.CIR_GET_AGENCY_CITY(H.COMP_CODE,H.UNIT_CODE,H.AGCD,H.DPCD) CITY_NAME,H.ENTRYDT ENTRYDT,H.FRDT FRDT,H.TODT TODT,
        H.SUP_AGCD SUP_AGCD,H.SUP_DPCD SUP_DPCD,M.AG_NAME SUP_AGENCY, DBO.CIR_GET_CITY(H.COMP_CODE,M.CITY_CODE) SUP_CITY_NAME
        from cir_unsold_hdr_dis h,cir_agmast_dis m
        where h.comp_code=m.comp_code and h.comp_code=@pcomp_code and h.unit_code=m.unit and h.unit_code=@punit_code and h.doctype=@pdoc_type and
        h.sup_agcd=m.agcd and h.sup_dpcd=m.dpcd and (upper(m.ag_name) like upper(@pextra1)+'%' or @pextra1 is null or @pextra1='') and (h.app_userid is null or h.app_userid='')
		and (H.RECPTNO=@pextra3 or @pextra3='' or @pextra3 is null)
        order by  RECPTDT,agency_name
    End
    Else Begin
        SELECT DISTINCT H.RECPTDT RECPTDT,H.AGCD AGCD,H.DPCD DPCD,DBO.CIR_GET_AGENCY(H.COMP_CODE,H.UNIT_CODE,H.AGCD,H.DPCD) AGENCY_NAME,
        DBO.CIR_GET_AGENCY_CITY(H.COMP_CODE,H.UNIT_CODE,H.AGCD,H.DPCD) CITY_NAME,H.ENTRYDT ENTRYDT,H.FRDT FRDT,H.TODT TODT,
        H.SUP_AGCD SUP_AGCD,H.SUP_DPCD SUP_DPCD,M.AG_NAME SUP_AGENCY, DBO.CIR_GET_CITY(H.COMP_CODE,M.CITY_CODE) SUP_CITY_NAME
        from cir_unsold_hdr h,cir_agmast m
        where h.comp_code=m.comp_code and h.comp_code=@pcomp_code and h.unit_code=m.unit and h.unit_code=@punit_code and h.doctype=@pdoc_type and
        h.sup_agcd=m.agcd and h.sup_dpcd=m.dpcd and (upper(m.ag_name) like upper(@pextra1)+'%' or @pextra1 is null or @pextra1='') and (h.app_userid is null or h.app_userid='')
		and (H.RECPTNO=@pextra3 or @pextra3='' or @pextra3 is null)
        order by RECPTDT,agency_name
      End
      
      end 
       Else Begin
        If upper(@pextra2)='D' Begin
        SELECT DISTINCT H.RECPTNO RECPTNO,H.RECPTDT RECPTDT,H.AGCD AGCD,H.DPCD DPCD,DBO.CIR_GET_AGENCY(H.COMP_CODE,H.UNIT_CODE,H.AGCD,H.DPCD) AGENCY_NAME,
        DBO.CIR_GET_AGENCY_CITY(H.COMP_CODE,H.UNIT_CODE,H.AGCD,H.DPCD) CITY_NAME,H.PUBL PUBL,DBO.CIR_GET_PUBL_NAME(H.COMP_CODE,H.PUBL) PUBL_NAME,H.EDTN EDTN,
        DBO.CIR_GET_EDTN_NAME(H.COMP_CODE,H.EDTN) EDTN_NAME,H.ENTRYDT ENTRYDT,H.FRDT FRDT,H.TODT TODT,
        H.SUP_AGCD SUP_AGCD,H.SUP_DPCD SUP_DPCD,M.AG_NAME SUP_AGENCY, DBO.CIR_GET_CITY(H.COMP_CODE,M.CITY_CODE) SUP_CITY_NAME
        from cir_unsold_hdr_dis h,cir_agmast_dis m
        where h.comp_code=m.comp_code and h.comp_code=@pcomp_code and h.unit_code=m.unit and h.unit_code=@punit_code and h.doctype=@pdoc_type and
        h.sup_agcd=m.agcd and h.sup_dpcd=m.dpcd and (upper(m.ag_name) like upper(@pextra1)+'%' or @pextra1 is null or @pextra1='') and (h.app_userid is null or h.app_userid='')
		and (H.RECPTNO=@pextra3 or @pextra3='' or @pextra3 is null)
        order by recptdt,recptno,agency_name
    End
    Else Begin
        SELECT DISTINCT H.RECPTNO RECPTNO,H.RECPTDT RECPTDT,H.AGCD AGCD,H.DPCD DPCD,DBO.CIR_GET_AGENCY(H.COMP_CODE,H.UNIT_CODE,H.AGCD,H.DPCD) AGENCY_NAME,
        DBO.CIR_GET_AGENCY_CITY(H.COMP_CODE,H.UNIT_CODE,H.AGCD,H.DPCD) CITY_NAME,H.PUBL PUBL,DBO.CIR_GET_PUBL_NAME(H.COMP_CODE,H.PUBL) PUBL_NAME,H.EDTN EDTN,
        DBO.CIR_GET_EDTN_NAME(H.COMP_CODE,H.EDTN) EDTN_NAME,H.ENTRYDT ENTRYDT,H.FRDT FRDT,H.TODT TODT,
        H.SUP_AGCD SUP_AGCD,H.SUP_DPCD SUP_DPCD,M.AG_NAME SUP_AGENCY, DBO.CIR_GET_CITY(H.COMP_CODE,M.CITY_CODE) SUP_CITY_NAME
        from cir_unsold_hdr h,cir_agmast m
        where h.comp_code=m.comp_code and h.comp_code=@pcomp_code and h.unit_code=m.unit and h.unit_code=@punit_code and h.doctype=@pdoc_type and
        h.sup_agcd=m.agcd and h.sup_dpcd=m.dpcd and (upper(m.ag_name) like upper(@pextra1)+'%' or @pextra1 is null or @pextra1='') and (h.app_userid is null or h.app_userid='')
		and (H.RECPTNO=@pextra3 or @pextra3='' or @pextra3 is null)
        order by recptdt,recptno,agency_name
      End
      
      end
end


/////////////////////////////////////////////////////////////////////


ALTER PROCEDURE [dbo].[cir_unsold_credit_note_cir_notapproval_unsold_p]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@pdoc_type                                VARCHAR(20) ,
	@precptno                                 VARCHAR(20) ,
	@pagcd_code                               VARCHAR(20) ,
	@pdpcd_code                               VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(40) ,
	@pextra2                                  VARCHAR(40) ,
	@pextra3                                  VARCHAR(40) ,--Unsold base of Supdate and Publication
	@pextra4                                  VARCHAR(40) ,
	@pextra5                                  VARCHAR(40) 
	
	
AS 
Begin

if UPPER(@pextra3)='Y' Begin

	if UPPER(@pextra2)='D' Begin
		SELECT * FROM  cir_unsold_dtl_dis
		WHERE comp_code  = @pcomp_code AND unit_code  = @punit_code
		 AND doctype  = @pdoc_type AND (recptno  = @precptno OR @precptno='' OR @precptno=NULL)
		 AND agcd  = @pagcd_code AND	dpcd  = @pdpcd_code
		 AND APP_USERID=''
		ORDER BY recptdt, recptno, supdate 
	End
	Else Begin
		SELECT *,cast(round((RETURN_PER*SUPPLY_COPY)/100,0) as int) as RETURNABLE FROM  cir_unsold_dtl 
		WHERE comp_code  = @pcomp_code AND unit_code  = @punit_code
		 AND doctype  = @pdoc_type AND (recptno  = @precptno OR @precptno='' OR @precptno=NULL)
		 AND (agcd  = @pagcd_code or @pagcd_code='' or @pagcd_code is null) 
		 AND (dpcd  = @pdpcd_code or @pdpcd_code='' or @pdpcd_code is null)
		 AND APP_USERID=''
		ORDER BY recptdt,recptno,supdate 
	End
	end
	else Begin
	if UPPER(@pextra2)='D' Begin
		SELECT * FROM  cir_unsold_dtl_dis
		WHERE comp_code  = @pcomp_code AND unit_code  = @punit_code
		 AND doctype  = @pdoc_type AND recptno  = @precptno 
		 AND agcd  = @pagcd_code AND	dpcd  = @pdpcd_code
		ORDER BY recptdt, recptno, supdate 
	End
	Else Begin
		SELECT *,cast(round((RETURN_PER*SUPPLY_COPY)/100,0) as int) as RETURNABLE FROM  cir_unsold_dtl 
		WHERE comp_code  = @pcomp_code AND unit_code  = @punit_code
		 AND doctype  = @pdoc_type AND recptno  = @precptno 
		 --AND (agcd  = @pagcd_code or @pagcd_code='' or @pagcd_code is null) 
		 --AND (dpcd  = @pdpcd_code or @pdpcd_code='' or @pdpcd_code is null)
		 
		ORDER BY recptdt,recptno,supdate 
	End
	end
End



//////////////////////////////////////////////////next

ALTER procedure [dbo].[cir_credit_rating_report]
(
	@pcomp_code         as varchar(20),
	@punit_code         as varchar(20),
	@ppubl              as varchar(20),	
	@pmonth             as varchar(20),
	@pyear              as varchar(20),
	@pagency_type       as varchar(20),
	@pagency_class      as varchar(20),	
	@pbranch            as varchar(20),
	@pagcd              as varchar(20),
	@pdpcd              as varchar(20),	
	@pdateformat        as varchar(20),
	@pmonth_bg        as int
	
)
as
--cir_credit_rating_report 'HT001','DEL','','08','2012','','','','','','','2'

begin
declare @pfromdate varchar(10)
declare @ptilldate varchar(10)
declare @pdate varchar(10)
declare @preturn_based varchar(1)
declare @plangtype varchar(1)
declare @ptodate varchar(10)
set @preturn_based='R'
set @plangtype='1'
set @pdate=@pmonth+'/01/'+@pyear
SET @ptodate=convert(varchar(10),DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@pdate)+1,0)),101)

/*TABLE 0      agency detail 00*/
select distinct top 1 a.* ,
b.route_code,
dbo.cir_get_city(a.comp_code,a.city_code) city_name,
dbo.cir_get_route_name(a.comp_code,a.unit,b.route_code) route_name
,dbo.cir_get_drop_point_name(a.comp_code,a.unit,a.station_code,1) drop_point_name,
dbo.cir_get_agency_type(a.comp_code,a.ag_type) agent_type
,dbo.cir_get_state(a.comp_code,a.country_code,a.state_code)state_name,
dbo.cir_get_name_cir_district(a.comp_code,a.dist_code,1,@pdateformat,'','') dist_name
,dbo.cir_get_country(a.comp_code,a.country_code)country_name,
(select max(zone_code) from cir_city_mast where cir_city_mast.comp_code=a.comp_code
and cir_city_mast.city_code=a.city_code ) zone_code,dbo.cir_get_zone_name(a.comp_code,(select max(zone_code) from cir_city_mast where cir_city_mast.comp_code=a.comp_code
and cir_city_mast.city_code=a.city_code )) zone_name,(select max(region_code) from cir_city_mast where cir_city_mast.comp_code=a.comp_code
and cir_city_mast.city_code=a.city_code ) region_code,dbo.cir_get_region_name(a.comp_code,(select max(region_code) from cir_city_mast where cir_city_mast.comp_code=a.comp_code
and cir_city_mast.city_code=a.city_code )) region_name,
(select max(c.name) from  cir_ag_con_per c where a.comp_code=c.comp_code and b.comp_code=c.comp_code and a.unit=c.unit and b.unit=c.unit
and a.agcd=c.agcd and b.agcd=c.agcd and a.dpcd=c.dpcd and b.dpcd=c.dpcd )cont_person_name
,dbo.cir_get_branch(a.comp_code,a.branch_code) branch_name
,case isnull(agreement_expiry,'1900-01-01 00:00:00.000')
when '1900-01-01 00:00:00.000' then ''
else agreement_expiry end AS AGREEMENT_EXPIRY
,isnull(ctos_status,'N') AS CTOS_STATUS

 from cir_agmast a ,cir_supply b
where a.comp_code=b.comp_code and a.unit=b.unit and a.agcd=b.agcd and a.dpcd=b.dpcd and
a.comp_code=@pcomp_code and a.unit=@punit_code and a.agcd=@pagcd and a.dpcd=@pdpcd
and (a.branch_code=@pbranch  or @pbranch is null or @pbranch='') and (a.ag_type=@pagency_type 
or @pagency_type is null or @pagency_type='') and (a.ag_class=@pagency_class or @pagency_class is null or @pagency_class='') 

/*TABLE 1      sales performance 1 month 01*/
set @pfromdate=@pmonth+'/01/'+@pyear
set @ptilldate=convert(varchar(10),DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@pdate)+1,0)),101)
exec  cir_credit_rating_sale @pcomp_code,@punit_code,@ppubl,@pfromdate,@ptilldate,@pagency_type,@pagency_class,	@pbranch,@pagcd,@pdpcd,		@preturn_based,	@plangtype,	@pdateformat

/*TABLE 2      sales performance 3 month 02*/
set @pfromdate=CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,@pdate))-1),DATEADD(mm,-2,@pdate)),101)
set @ptilldate=convert(varchar(10),DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@pdate)+1,0)),101)
exec  cir_credit_rating_sale @pcomp_code,@punit_code,@ppubl,@pfromdate,@ptilldate,@pagency_type,@pagency_class,	@pbranch,@pagcd,@pdpcd,		@preturn_based,	@plangtype,	@pdateformat

/*TABLE 3      sales performance 1 year 03*/
set @pfromdate='01/01/'+@pyear
print('@pfromdate')
print(@pfromdate)
set @ptilldate='12/31/'+@pyear
exec  cir_credit_rating_sale @pcomp_code,@punit_code,@ppubl,@pfromdate,@ptilldate,@pagency_type,@pagency_class,	@pbranch,@pagcd,@pdpcd,		@preturn_based,	@plangtype,	@pdateformat

/*TABLE 4      ageing report ONLY FOR NEWSPAPER*/
--exec cir_credit_rating_ageing  @pcomp_code,@punit_code,@pbranch,@pagency_type,	@pagency_class,@pagcd,	@pdpcd,'B',@ptodate,@ptodate,'1','2','3','5','6',null,@ppubl
exec cir_ledger_ageing @pcomp_code,@punit_code,@pbranch,null,null,null,null,@pagency_type,	@pagency_class,@pagcd,	@pdpcd,'B',@ptodate,@ptodate,@ptodate,'mm/dd/yyyy' ,null,'CREDIT',null,null,null,null

/*TABLE 5      blocking history 05*/
--exec cir_credit_rating_block @pcomp_code,@punit_code,@pbranch,'B',@pagcd,	@pdpcd,@pfromdate,@ptilldate,@pdateformat
exec cir_rep_ag_block_unblock_reasonwise  @pcomp_code,@punit_code,@pbranch,'','B','',@pagcd,	@pdpcd,'',@pfromdate,@ptilldate,'','',@pdateformat,'CREDIT',''

/*TABLE 6      return cheque 06*/
select o.comp_code,o.unit_code,o.agcd,o.dpcd,o.chno,o.chdt,o.chbnk,o.amount,
'Cleared' STATUS
 from cir_outmast o,cir_reason_mst r where o.doctyp='DN' and o.comp_code=r.comp_code
and o.reason=r.reason_code and  o.billno is not null and chq_return_flag='Y'
AND o.comp_code=@pcomp_code and (o.unit_code=@punit_code ) and o.agcd =@pagcd and 
o.dpcd =@pdpcd  and  o.chdt between  @pfromdate and @ptilldate

/*TABLE 7      bank guarantee FOR EXPIRY LIST*/
SELECT b.COMP_CODE, b.UNIT_CODE, b.AGCD, b.DPCD,m.ag_name AG_NAME,
DBO.CIR_GET_DROP_POINT_NAME(B.COMP_CODE,B.UNIT_CODE,M.STATION_CODE,1) DROP_POINT_NAME,
    DBO.CIR_GET_CITY(B.COMP_CODE,M.CITY_CODE) CITY_NAME, 
    b.BG_NO, b.BG_AMT, b.BG_DATE, b.BG_VALID, b.BANK_DESC, 
    b.CREATED_BY, b.CREATED_DT, b.UPDATED_BY, b.UPDATED_DT, b.BG_TYPE
    FROM cir_bank_guarantee b,cir_agmast m
    where m.comp_code =b.comp_code and m.comp_code = @pcomp_code and b.unit_code=m.unit  
    and m.unit=@punit_code
    and b.agcd=m.agcd and b.agcd    = ISNULL(@pagcd,b.agcd) 
    and b.dpcd=m.dpcd and b.dpcd    = ISNULL(@pdpcd,b.dpcd)
   -- and b.bg_valid between @pfromdate and @ptilldate
    and b.bg_valid between @pfromdate and dateadd(mm,@pmonth_bg,@pfromdate) 
    ORDER BY AG_NAME
    
    /*TABLE 8      PAYMENT HISTORY 08*/
select TOP 5 o.comp_code,o.unit_code,o.agcd,o.dpcd,o.RECPTNO,o.RECPTDT,o.amount,
o.REASON,dbo.cir_get_payreason(o.comp_code,o.DOCTYP,o.REASON,@pdateformat,'','','','','')as REASON_NAME
 from cir_outmast o where o.doctyp='RCR' 
AND o.comp_code=@pcomp_code and (o.unit_code=@punit_code ) and o.agcd =@pagcd and 
o.dpcd =@pdpcd  and  o.RECPTDT between  @pfromdate and @ptilldate
ORDER BY o.RECPTDT DESC
   
     /*TABLE 9+10     target bank guarantee (returns 2 table----- 2-req security,1-dep security && bank guarantee)*/ 
   declare @v_dt varchar(200)
   set @v_dt=convert(varchar(10),DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@pdate)+1,0)),101) 
  -- exec cir_credit_rating_security_report @pcomp_code ,@punit_code,@pbranch,@ppubl,null,@pagcd,@pdpcd,@v_dt,'mm/dd/yyyy',null,@pagency_class,@pagency_type,null,null,null
exec cir_security_report @pcomp_code ,@punit_code,@pbranch,@ppubl,null,@pagcd,@pdpcd,@v_dt,'mm/dd/yyyy',null,@pagency_class,@pagency_type,null,'CREDIT',null
print('@v_dt') 
print(@v_dt) 
print(@pagcd)
print(@pdpcd)
print(@pagency_class)
print(@pagency_type)

/*TABLE 11      collection report/index 10*/	
 exec  cir_credit_rating_overdue @pcomp_code,@punit_code,ppubl,@pagency_type,@pagency_class,@pagcd,@pdpcd,@v_dt,@v_dt,'mm/dd/yyyy'

/*TABLE 12      ageing report magzine month wise*/
--exec cir_credit_rating_monthly_ageing  @pcomp_code,@punit_code,@pbranch,@ppubl,@pagency_type,@pagency_class,@pagcd,	@pdpcd,'B',@v_dt,@v_dt,'30','60','90','120','150',null,'N'
/*table 13      ageing report total installment and total amt*/
--exec cir_credit_rating_monthly_ageing  @pcomp_code,@punit_code,@pbranch,@ppubl,@pagency_type,@pagency_class,@pagcd,	@pdpcd,'B',@v_dt,@v_dt,'30','60','90','120','150',null,''
   


end

/******************end************/






////////////////////////////////////next



ALTER PROCEDURE [dbo].[cir_rep_ag_block_unblock_reasonwise]
		@pcompcode               as varchar(20),
		@punitcode               as varchar(20),
		@pbranchcode             as varchar(20),
		@pblock_unblock_type     as varchar(20), 
		@pstatus                 as varchar(20), --   U/B
		@pblock_unblock_by       as varchar(20),
		@pagcd                   as varchar(20),   
		@pdpcd                   as varchar(20),
		@pb_ub_reason            as varchar(20),
		@pfrom_date              as datetime,
		@ptill_date              as datetime,
		@papproved               as varchar(20),-- A/U
		@puserid                 as varchar(20),
		@pdateformat             as varchar(20),
		@pextra1                 as varchar(200),
		@pextra2                 as varchar(200)

AS 
SET CONCAT_NULL_YIELDS_NULL OFF
	declare @vvar       varchar(8000)
	declare @tot_vvar   varchar(8000)
	declare @vtot_publ  varchar(8000)
	declare @v_cnt      int
	declare @rec_susp_code	as varchar(20) 
	declare @rec_susp_name	as varchar(200)
    declare @pvar as varchar(20)
----- parameters for execution------------
-- exec cir_rep_ag_block_unblock_reasonwise 'UM001','BA0','','','U','','','','','05/01/2012','05/31/2012','U','A01','dd/mm/yyyy','',''
-------------------------------------------
	if @pstatus = 'B'
	begin
		declare cur_reason cursor for			
			select suspend_type_code,suspend_desc from CIR_SUSPEND_TYPE_MAST s where s.COMP_CODE=@pcompcode-- and s.block_reason='Y'
	
    open cur_reason
        fetch NEXT FROM cur_reason INTO @rec_susp_code,@rec_susp_name
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN
          set @v_cnt =isnull(@v_cnt,0)+1
			  if @vvar is null 
				Begin
				  set @vvar      ='case when s.suspty='+''''+@rec_susp_code+''''+' then ''Y'' else ''N'' end "'+@rec_susp_name+'"';
				End
			  else
				Begin
				  set @vvar      =@vvar+',case when s.suspty='+''''+@rec_susp_code+''''+' then ''Y'' else ''N'' end "'+@rec_susp_name+'"'
				End	
		
			fetch NEXT FROM cur_reason INTO @rec_susp_code,@rec_susp_name
		End
    close cur_reason
    deallocate cur_reason
     
declare @pquery as varchar(max)	
if(@pextra1='CREDIT')BEGIN
set @pquery='select a.AGCD dealer_code,a.AG_NAME dealer_name,a.AGEING_TYPE,isnull(s.AGENCY_UNBLOCK_TYPE,''A'') as auto_manual,substring(CONVERT(VARCHAR(12), s.TRN_DATE, 114),1,5) as time,
			s.TRN_DATE tran_date ,'+@vvar+'
		,(SELECT COUNT(*) FROM  CIR_SUSPEND_TRAN t where 
		t.COMP_CODE='''+@pcompcode+'''
		and t.COMP_CODE=a.COMP_CODE and t.AGCD=a.AGCD and t.DPCD=a.dpcd
		and t.COMP_CODE=s.COMP_CODE and t.AGCD=s.AGCD and t.DPCD=s.dpcd
		and (Select l.block_reason from CIR_SUSPEND_TYPE_MAST l where l.COMp_CODE='''+@pcompcode+''' and l.SUSPEND_TYPE_CODE=t.SUSPTY )=''Y''
		and (t.UNIT=isnull('''+@punitcode+''',t.UNIT) or '''+@punitcode+''' ='''')
		and (a.BRANCH_CODE=ISNULL('''+@pbranchcode+''',a.BRANCH_CODE) or '''+@pbranchcode+''' ='''')
		and (t.AGCD=ISNULL('''+@pagcd+''',t.agcd) or '''+@pagcd+'''='''') 
		and (t.dpcd=ISNULL('''+@pdpcd+''',t.dpcd) or '''+@pdpcd+'''='''')
		and (t.TRN_DATE between '''+cast(@pfrom_date as varchar)+''' and '''+cast(@ptill_date as varchar)+''')
		) NO_OF_TIMES_BLOCK
		from CIR_SUSPEND_TRAN s, CIR_AGMAST a where s.COMP_CODE='''+@pcompcode+'''
		and s.COMP_CODE=a.COMP_CODE and s.AGCD=a.AGCD and s.DPCD=a.dpcd
		and (Select l.block_reason from CIR_SUSPEND_TYPE_MAST l where l.COMp_CODE='''+@pcompcode+''' and l.SUSPEND_TYPE_CODE=s.SUSPTY )=''Y''
		and (s.UNIT=isnull('''+@punitcode+''',s.UNIT) or '''+@punitcode+''' ='''')
		and (a.BRANCH_CODE=ISNULL('''+@pbranchcode+''',a.BRANCH_CODE) or '''+@pbranchcode+''' ='''')
		and (s.AGENCY_UNBLOCK_APPROVAL=ISNULL( '''+@pblock_unblock_type+''' ,s.AGENCY_UNBLOCK_APPROVAL) or  '''+@pblock_unblock_type+'''  ='''')
		and (s.USERID=isnull('''+@pblock_unblock_by+''',s.USERID) or '''+@pblock_unblock_by+'''='''')
		and (s.AGCD=ISNULL('''+@pagcd+''',s.agcd) or '''+@pagcd+'''='''') and (s.dpcd=ISNULL('''+@pdpcd+''',s.dpcd) or '''+@pdpcd+'''='''')
		and (s.SUSPTY=ISNULL('''+@pb_ub_reason+''',s.suspty) or '''+@pb_ub_reason+''' ='''')
		and (s.TRN_DATE between '''+cast(@pfrom_date as varchar)+''' and '''+cast(@ptill_date as varchar)+''')
		and (ISNULL(s.AGENCY_UNBLOCK_APPROVAL,''U'') ='''+@papproved+''' or '''+@papproved+''' ='''')
		group by a.AGCD,a.AG_NAME,a.AGEING_TYPE,s.AGENCY_UNBLOCK_TYPE,s.USERID,s.SUSPTY,s.TRN_DATE ,
		a.comp_code ,a.dpcd,s.comp_code,s.agcd,s.dpcd,a.BRANCH_CODE 
		order by s.TRN_DATE'
END
ELSE BEGIN
set @pquery='select a.AGCD dealer_code,a.AG_NAME dealer_name,a.AGEING_TYPE,isnull(s.AGENCY_UNBLOCK_TYPE,''A'') as auto_manual,substring(CONVERT(VARCHAR(12), s.TRN_DATE, 114),1,5) as time
		,'+@vvar+'
		from CIR_SUSPEND_TRAN s, CIR_AGMAST a where s.COMP_CODE='''+@pcompcode+'''
		and s.COMP_CODE=a.COMP_CODE and s.AGCD=a.AGCD and s.DPCD=a.dpcd
		and (Select l.block_reason from CIR_SUSPEND_TYPE_MAST l where l.COMp_CODE='''+@pcompcode+''' and l.SUSPEND_TYPE_CODE=s.SUSPTY )=''Y''
		and (s.UNIT=isnull('''+@punitcode+''',s.UNIT) or '''+@punitcode+''' ='''')
		and (a.BRANCH_CODE=ISNULL('''+@pbranchcode+''',a.BRANCH_CODE) or '''+@pbranchcode+''' ='''')
		and (s.AGENCY_UNBLOCK_APPROVAL=ISNULL( '''+@pblock_unblock_type+''' ,s.AGENCY_UNBLOCK_APPROVAL) or  '''+@pblock_unblock_type+'''  ='''')
		and (s.USERID=isnull('''+@pblock_unblock_by+''',s.USERID) or '''+@pblock_unblock_by+'''='''')
		and (s.AGCD=ISNULL('''+@pagcd+''',s.agcd) or '''+@pagcd+'''='''') and (s.dpcd=ISNULL('''+@pdpcd+''',s.dpcd) or '''+@pdpcd+'''='''')
		and (s.SUSPTY=ISNULL('''+@pb_ub_reason+''',s.suspty) or '''+@pb_ub_reason+''' ='''')
		and (s.TRN_DATE between '''+cast(@pfrom_date as varchar)+''' and '''+cast(@ptill_date as varchar)+''')
		and (ISNULL(s.AGENCY_UNBLOCK_APPROVAL,''U'') ='''+@papproved+''' or '''+@papproved+''' ='''')
		group by a.AGCD,a.AG_NAME,a.AGEING_TYPE,s.AGENCY_UNBLOCK_TYPE,s.USERID,s.SUSPTY,s.TRN_DATE 
		order by s.TRN_DATE'
END
		
		
		print(@pquery)
		exec(@pquery)
	
	end
	else
	begin

		select a.AGCD dealer_code,a.AG_NAME dealer_name,a.AGEING_TYPE,isnull(s.AGENCY_UNBLOCK_TYPE,'A') as auto_manual,substring(CONVERT(VARCHAR(12), s.TRN_DATE, 114),1,5) as time
		,(Select l.ROLE from login l where l.COM_CODE=@pcompcode and l.userid=s.USERID ) as user_group
		,(Select l.username from login l where l.COM_CODE=@pcompcode and l.userid=s.USERID ) as unblockby
		,(Select l.SUSPEND_DESC from CIR_SUSPEND_TYPE_MAST l where l.COMp_CODE=@pcompcode and l.SUSPEND_TYPE_CODE=s.SUSPTY ) as ub_reason
		from CIR_SUSPEND_TRAN s, CIR_AGMAST a where s.COMP_CODE=@pcompcode
		and s.COMP_CODE=a.COMP_CODE and s.AGCD=a.AGCD and s.DPCD=a.dpcd
		and (Select l.block_reason from CIR_SUSPEND_TYPE_MAST l where l.COMp_CODE=@pcompcode and l.SUSPEND_TYPE_CODE=s.SUSPTY )!='Y'
		and (s.UNIT=isnull(@punitcode,s.UNIT) or @punitcode ='')
		and (a.BRANCH_CODE=ISNULL(@pbranchcode,a.BRANCH_CODE) or @pbranchcode ='')
		and (s.AGENCY_UNBLOCK_APPROVAL=ISNULL( @pblock_unblock_type ,s.AGENCY_UNBLOCK_APPROVAL) or  @pblock_unblock_type  ='')
		and (s.USERID=isnull(@pblock_unblock_by,s.USERID) or @pblock_unblock_by='')
		and (s.AGCD=ISNULL(@pagcd,s.agcd) or @pagcd='') and (s.dpcd=ISNULL(@pdpcd,s.dpcd) or @pdpcd='')
		and (s.SUSPTY=ISNULL(@pb_ub_reason,s.suspty) or @pb_ub_reason ='')
		and (s.TRN_DATE between @pfrom_date and @ptill_date)
		and (ISNULL(s.AGENCY_UNBLOCK_APPROVAL,'U') =@papproved or @papproved ='')
		group by a.AGCD,a.AG_NAME,a.AGEING_TYPE,s.AGENCY_UNBLOCK_TYPE,s.USERID,s.SUSPTY,s.TRN_DATE 
		order by s.TRN_DATE
		
		
	end
	
	SET CONCAT_NULL_YIELDS_NULL ON
	
	
	
	/*select distinct suspty,(select l.SUSPEND_DESC from CIR_SUSPEND_TYPE_MAST l where l.COMp_CODE=@pcompcode and l.SUSPEND_TYPE_CODE=s.SUSPTY) as SUSP_DESC
			from CIR_SUSPEND_TRAN s where s.COMP_CODE=@pcompcode			
			and (Select l.block_reason from CIR_SUSPEND_TYPE_MAST l where l.COMp_CODE=@pcompcode and l.SUSPEND_TYPE_CODE=s.SUSPTY )='Y'
			and (s.UNIT=isnull(@punitcode,s.UNIT) or @punitcode ='')			
			and (s.AGENCY_UNBLOCK_APPROVAL=ISNULL( @pblock_unblock_type ,s.AGENCY_UNBLOCK_APPROVAL) or  @pblock_unblock_type  ='')
			and (s.USERID=isnull(@pblock_unblock_by,s.USERID) or @pblock_unblock_by='')
			and (s.AGCD=ISNULL(@pagcd,s.agcd) or @pagcd='') and (s.dpcd=ISNULL(@pdpcd,s.dpcd) or @pdpcd='')
			and (s.SUSPTY=ISNULL(@pb_ub_reason,s.suspty) or @pb_ub_reason ='')
			and (s.TRN_DATE between @pfrom_date and @ptill_date)
			and (ISNULL(s.AGENCY_UNBLOCK_APPROVAL,'U') =@papproved)
			order by 2
			*/








****************************************************end********************************************************



**********************************add by Deepika 31-01-2013 sent by amit sir*****************************


ALTER PROCEDURE [dbo].[cir_pending_installment]
   @pcompcode      as	VARCHAR(20),
   @punitcode      as	VARCHAR(20),
   @pagcd          as	VARCHAR(20),
   @pdpcd          as	VARCHAR(20),
   @pachd          as	VARCHAR(20),
   @pdateformat    as	VARCHAR(20),
   @pextra         as	VARCHAR(20),
   @pextra1        as	VARCHAR(200),
   @pextra2        as	VARCHAR(200),
   @pextra3        as	VARCHAR(200),
   @pextra4        as	VARCHAR(200),   
   @pextra5        as	VARCHAR(200),
   @pextra6        as	VARCHAR(200),
   @pextra7        as	VARCHAR(200),
   @pextra8        as	VARCHAR(200),   
   @pextra9        as	VARCHAR(200),
   @pextra10       as	VARCHAR(200)

AS

	declare @v_dt		datetime    
	declare @v_expdt	datetime
BEGIN

    select m.comp_code as"COMP_CODE",m.unit_code as "UNIT_CODE",m.inst_code as "INST_CODE",m.inst_date as "INST_DATE",
    m.agcd as "AGCD",m.dpcd as "DPCD",a.ag_name as "AG_NAME",dbo.cir_get_drop_point_name(m.comp_code,m.unit_code,a.station_code,1) as "DROP_POINT_NAME",
    dbo.cir_get_city(m.comp_code,a.city_code) as "CITY_NAME"
    ,d.inst_duedt as "INST_DUEDT",d.inst_amt as "INST_AMT"
    , d.INST_CHQNO as "INST_CHQNO",
     case d.INST_CHQDT when '1900-01-01 00:00:00.000' then null else d.INST_CHQDT end as "INST_CHQDT",d.BANK_CODE as "BANK_CODE",
    (select sum(inst_due_amt)from cir_inst_bill_det 
    where comp_code=m.comp_code and inst_code=m.inst_code and agcd=m.agcd and dpcd=m.dpcd and 
    inst_billdt=d.inst_duedt and INST_NO=d.INST_NO) as "INST_DUE_AMT",d.INST_NO 
    from cir_installment_mast m,cir_installment_det d,cir_agmast a
    where m.comp_code=d.comp_code and m.comp_code=a.comp_code and m.comp_code=@pcompcode and 
    m.unit_code=d.unit_code and m.unit_code=a.unit and m.unit_code=isnull(@punitcode,m.unit_code) and
    m.agcd=d.agcd and m.agcd=a.agcd and m.agcd=isnull(@pagcd,m.agcd) and m.dpcd=d.dpcd and m.dpcd=a.dpcd and m.dpcd=isnull(@pdpcd,m.dpcd) and 
    m.inst_code=d.inst_code and m.achd=@pachd
    order by comp_code,unit_code,ag_name,inst_duedt
    
END



create PROCEDURE [dbo].[cir_circulation_accounts_cir_pendingbills_p2]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@pagcd                                    VARCHAR(20) ,
	@pdpcd                                    VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS 


select o.comp_code as "COMP_CODE",o.billno as "BILLNO" , o.billdt as "BILLDT" ,o.publ as "PUBL",dbo.cir_get_publ_name(o.comp_code,o.publ) as "PUBL_NAME",
dbo.cir_get_publ_type(o.comp_code,o.publ,null,null) as "PUBL_TYPE",sum(o.amount) as "AMOUNT"
from cir_outmast o 
where o.comp_code=@pcomp_code and (o.unit_code=@punit_code ) and o.agcd =@pagcd and 
o.dpcd =@pdpcd  and  o.billno is not null
group by o.comp_code,o.billno, o.billdt, o.publ
having sum( o.amount )>0 order by billdt,BILLNO,publ_type,publ_name;



///////////////////////////////////////////

create FUNCTION [dbo].[udf_CurrencyToWordsSub](@Input varchar(3),@Group tinyint,@Currency tinyint)
RETURNS varchar(8000)
AS
BEGIN

SET @Input = right('000' + @Input,3)

DECLARE @Groups TABLE
([Group] tinyint
,Currency tinyint
,Word varchar(10))

INSERT INTO @Groups
SELECT 5,NULL,'Billion '
UNION
SELECT 4,NULL,'Million '
UNION
SELECT 3,NULL,'Thousand '
UNION
SELECT 2,1,'Pound# '
UNION
SELECT 2,2,'Euro# '
UNION
SELECT 2,3,'Dollar# '
UNION
SELECT 2,4,'Rinngit# '
UNION
SELECT 1,1,'Pence '
UNION
SELECT 1,2,'Cent~ '
UNION
SELECT 1,3,'Cent~ '
UNION
SELECT 1,4,'Cent~ '

DECLARE @Numbers TABLE
(Number char(2)
,Word varchar(10))

INSERT INTO @Numbers
SELECT '01','One ' UNION SELECT '02','Two ' UNION SELECT '03','Three ' UNION SELECT '04','Four ' UNION SELECT '05','Five ' UNION SELECT '06','Six ' UNION SELECT '07','Seven ' UNION SELECT '08','Eight ' UNION SELECT '09','Nine ' UNION SELECT '10','Ten ' UNION
SELECT '11','Eleven ' UNION SELECT '12','Twelve ' UNION SELECT '13','Thirteen ' UNION SELECT '14','Fourteen ' UNION SELECT '15','Fifteen ' UNION SELECT '16','Sixteen ' UNION SELECT '17','Seventeen ' UNION SELECT '18','Eighteen ' UNION SELECT '19','Nineteen ' UNION SELECT '20','Twenty ' UNION
SELECT '30','Thirty ' UNION SELECT '40','Forty ' UNION SELECT '50','Fifty ' UNION SELECT '60','Sixty ' UNION SELECT '70','Seventy ' UNION SELECT '80','Eighty ' UNION SELECT '90','Ninety '

DECLARE @Output varchar(100)

SET @Output = 
CASE --Hundreds
WHEN left(@Input,1) <> 0 THEN (SELECT Word FROM @Numbers WHERE Number = '0' + left(@Input,1)) + 'Hundred '
ELSE ''
END +
CASE --And
WHEN @Group <> 1 AND right(@Input,2) <> 0 AND @Input > 100 THEN 'And '
ELSE ''
END +
CASE --Units
WHEN @Input = 0 AND @Group = 1 THEN 'Zero '
WHEN right(@Input,2) BETWEEN 1 AND 20 THEN (SELECT Word FROM @Numbers WHERE Number = right(@Input,2))
WHEN right(@Input,2) > 20 THEN (SELECT Word FROM @Numbers WHERE Number = left(right(@Input,2),1) + '0') + ISNULL((SELECT Word FROM @Numbers WHERE Number = '0' + right(@Input,1)),'')
ELSE ''
END +
CASE
WHEN @Group = 2 OR (@Group <> 2 AND @Input <> 0) THEN (SELECT Word FROM @Groups WHERE [Group] = @Group AND ISNULL(Currency,@Currency) = @Currency)
ELSE ''
END

RETURN @Output

END

create FUNCTION [dbo].[udf_CurrencyToWords] (@Input numeric(15,2),@Currency tinyint) 
RETURNS varchar (8000) 
AS 
BEGIN 

DECLARE @CharInput char(15) 
--Pad the input
SET @CharInput = RIGHT('0000000000000' + convert(varchar(15),@Input),15) 

DECLARE @Counter tinyint
SET @Counter = 1

DECLARE @InputSub varchar(3)
DECLARE @Group tinyint
DECLARE @Output varchar (8000)

--Get words for each group with some logic for concatenation
WHILE @Counter <= len(@CharInput)-2
BEGIN
SET @InputSub = replace(substring(@CharInput,@Counter,3),'.','')
SET @Group = (len(@CharInput)-@Counter+1)/3

SET @Output = ISNULL(@Output,'')+ CASE WHEN (@Group = 1 AND @InputSub <> 0 AND @Input >= 1.00) OR (@Group = 2 AND @InputSub BETWEEN 1 AND 99 AND @Input > 1000) THEN 'And '
ELSE ''
END + CASE WHEN (@Group = 1 AND @InputSub = 0 AND @Input >= 1.00) OR (@Group = 2 AND @InputSub = 0 AND @Input < 1.00) THEN ''
ELSE [dbo].[udf_CurrencyToWordsSub](@InputSub,@Group,@Currency)
END

SET @Counter = @Counter + 3
CONTINUE
END

--Fix plurals and return a plain Zero if required
SET @Output = 
CASE 
WHEN right(@CharInput,2) = '01' THEN replace(@Output,'~','')
ELSE replace(@Output,'~','s')
END
SET @Output = 
CASE 
WHEN @Input < 2 THEN replace(@Output,'#','')
ELSE replace(@Output,'#','s')
END

RETURN ltrim(rtrim(@Output))
END
**************************************************end******************************************************




//===================================add by deepika 05/02/2012=======================================




ALTER procedure [dbo].[cir_supply_estimation]
      @pcomp_code        as varchar(20),
      @punit_code        as varchar(20),
      @ppubl_code        as varchar(20),
      @pmedtn_code       as varchar(20),
      @pedtn_code        as varchar(20),
      @psup_type         as varchar(20),
      @pstate            as varchar(20),
      @pdistcode         as varchar(20),
      @ptaluka           as varchar(20),
      @pcitycode         as varchar(20),
      @pregcode          as varchar(20), 
      @pzonecode         as varchar(20),
      @pbrancode         as varchar(20),
      @proutecode        as varchar(20),
      @pagcd_code        as varchar(20),
      @pdpcd_code        as varchar(20),      
      @pdateformat       as varchar(20),
      @puserid			 as varchar(20),
      @pagtype           as varchar(200),
      @pagclasss         as varchar(200),
      @psuspend          as varchar(200),
      @pcomcat           as varchar(200),      
      @punsold_per       as numeric(5,2),
      @pinc_unsold_per   as numeric(5,2),
      @pinputdt          as varchar(200), 
      @pprevtype         as varchar(1), -- in case of date D/ in case of Weekdays W
      @pprevval          as int, -- bydefault 3      
      @pextra1           as varchar(200),
      @pextra2           as varchar(200),
      @pextra3           as varchar(200),
      @pextra4           as varchar(200),
      @pextra5           as varchar(200),
      @pextra6           as varchar(200),
      @pextra7           as varchar(200),
      @pextra8           as varchar(200),
      @pextra9           as varchar(200),
      @pextra10          as varchar(200)
 As
	
Begin
---------------parameters ---------------
--exec cir_supply_estimation 'UM001','BA0','','','','','','','','','','','','','','','dd/mm/yyyy','A01','','',
--'','','0','0','06/11/2012','D','5','','','','','','','','','',''
------------------------------------------------------------------


declare @v_supdates as varchar(max)
declare @v_retdates as varchar(max)
declare @v_union_var as varchar(max)
declare @v_datevar as datetime
declare @v_avg_qty as varchar(max)
declare @i as int

if @pprevval is null or @pprevval =''
	set @pprevval=3
set @i=@pprevval
	
if @pprevtype = 'D'
begin
	while @i > 0
	begin
		set @v_datevar=dateadd(dd,@i*-1, @pinputdt)
	--print(@v_datevar)
		if @v_supdates is null or @v_supdates =''
		begin                                                                                                         -- +  +  +  +
			set @v_supdates=' case convert(varchar(10),a.supdate,101) when '''  + convert(varchar(10),@v_datevar,101) + '''  then sum(isnull(a.sup_copy,0)) end as "SUP_' + convert(varchar(10),  @v_datevar  ,101) + '" ,0 as  "RET_' + convert(varchar(10),  @v_datevar  ,101) + '" '
			set @v_retdates=' case convert(varchar(10),a.supdate,101) when '''  + convert(varchar(10),@v_datevar,101) + '''  then sum(isnull(a.APR_BNR,0)+isnull(a.APR_DAMAGE,0)+isnull(a.APR_LATE_RECPT,0)+isnull(a.APR_SHORT_RECPT,0)+isnull(a.APR_UNSOLD,0)) end as "RET_' + convert(varchar(10),  @v_datevar  ,101) + '" ,0 as "SUP_' + convert(varchar(10),  @v_datevar  ,101) + '" '
			set @v_union_var=' sum(isnull(z."SUP_' + convert(varchar(10),  @v_datevar  ,101) + '",0)) "SUP_' + convert(varchar(10),  @v_datevar  ,101) + '" ,sum(isnull(z."RET_' + convert(varchar(10),  @v_datevar  ,101) + '",0))  "RET_' + convert(varchar(10),  @v_datevar  ,101) + '"  , sum(isnull(z."SUP_' + convert(varchar(10),  @v_datevar  ,101) + '",0)) -  sum(isnull(z."RET_' + convert(varchar(10),  @v_datevar  ,101) + '",0))  "NET_' + convert(varchar(10),  @v_datevar  ,101) + '"  ' 
			set @v_avg_qty = ' sum(isnull(z."SUP_' + convert(varchar(10),  @v_datevar  ,101) + '",0)) -  sum(isnull(z."RET_' + convert(varchar(10),  @v_datevar  ,101) + '",0)) '
		end
		else
		begin
			set @v_supdates= @v_supdates + ', case convert(varchar(10),a.supdate,101) when '''  + convert(varchar(10),@v_datevar,101) + '''  then sum(isnull(a.sup_copy,0)) end as "SUP_' + convert(varchar(10),  @v_datevar  ,101) + '"  ,0 as  "RET_' + convert(varchar(10),  @v_datevar  ,101) + '" '
			set @v_retdates= @v_retdates + ', case convert(varchar(10),a.supdate,101) when '''  + convert(varchar(10),@v_datevar,101) + '''  then sum(isnull(a.APR_BNR,0)+isnull(a.APR_DAMAGE,0)+isnull(a.APR_LATE_RECPT,0)+isnull(a.APR_SHORT_RECPT,0)+isnull(a.APR_UNSOLD,0)) end as "RET_' + convert(varchar(10),  @v_datevar  ,101) + '" ,0 as "SUP_' + convert(varchar(10),  @v_datevar  ,101) + '" '
			set @v_union_var=@v_union_var+', sum(isnull(z."SUP_' + convert(varchar(10),  @v_datevar  ,101) + '",0)) "SUP_' + convert(varchar(10),  @v_datevar  ,101) + '" ,sum(isnull(z."RET_' + convert(varchar(10),  @v_datevar  ,101) + '",0))  "RET_' + convert(varchar(10),  @v_datevar  ,101) + '"  , sum(isnull(z."SUP_' + convert(varchar(10),  @v_datevar  ,101) + '",0)) -  sum(isnull(z."RET_' + convert(varchar(10),  @v_datevar  ,101) + '",0))  "NET_' + convert(varchar(10),  @v_datevar  ,101) + '"  ' 
			set @v_avg_qty =@v_avg_qty + ' + sum(isnull(z."SUP_' + convert(varchar(10),  @v_datevar  ,101) + '",0)) -  sum(isnull(z."RET_' + convert(varchar(10),  @v_datevar  ,101) + '",0))  '
		end
		set @i=@i-1
	end
end
else if @pprevtype = 'W'
begin
	while @i > 0
	begin
		set @v_datevar=dateadd(dd,@i*-7, @pinputdt)
	
		--print(@v_datevar)
		if @v_supdates is null or @v_supdates =''
		begin                                                                                                         -- +  +  +  +
			set @v_supdates=' case convert(varchar(10),a.supdate,101) when '''  + convert(varchar(10),@v_datevar,101) + '''  then sum(isnull(a.sup_copy,0)) end as "SUP_' + convert(varchar(10),  @v_datevar  ,101) + '"  , 0 as "RET_' + convert(varchar(10),  @v_datevar  ,101) + '"'
			set @v_retdates=' case convert(varchar(10),a.supdate,101) when '''  + convert(varchar(10),@v_datevar,101) + '''  then sum(isnull(a.APR_BNR,0)+isnull(a.APR_DAMAGE,0)+isnull(a.APR_LATE_RECPT,0)+isnull(a.APR_SHORT_RECPT,0)+isnull(a.APR_UNSOLD,0)) end as "RET_' + convert(varchar(10),  @v_datevar  ,101) + '"  , 0 as "SUP_' + convert(varchar(10),  @v_datevar  ,101) + '" '
			set @v_union_var=' sum(isnull(z."SUP_' + convert(varchar(10),  @v_datevar  ,101) + '",0)) "SUP_' + convert(varchar(10),  @v_datevar  ,101) + '" ,sum(isnull(z."RET_' + convert(varchar(10),  @v_datevar  ,101) + '",0))  "RET_' + convert(varchar(10),  @v_datevar  ,101) + '"  , sum(isnull(z."SUP_' + convert(varchar(10),  @v_datevar  ,101) + '",0)) -  sum(isnull(z."RET_' + convert(varchar(10),  @v_datevar  ,101) + '",0))  "NET_' + convert(varchar(10),  @v_datevar  ,101) + '" ' 
			set @v_avg_qty = ' sum(isnull(z."SUP_' + convert(varchar(10),  @v_datevar  ,101) + '",0)) -  sum(isnull(z."RET_' + convert(varchar(10),  @v_datevar  ,101) + '",0)) '
		end
		else
		begin
			set @v_supdates= @v_supdates + ', case convert(varchar(10),a.supdate,101) when '''  + convert(varchar(10),@v_datevar,101) + '''  then sum(isnull(a.sup_copy,0)) end as "SUP_' + convert(varchar(10),  @v_datevar  ,101) + '"  , 0 as "RET_' + convert(varchar(10),  @v_datevar  ,101) + '"'
			set @v_retdates= @v_retdates + ', case convert(varchar(10),a.supdate,101) when '''  + convert(varchar(10),@v_datevar,101) + '''  then sum(isnull(a.APR_BNR,0)+isnull(a.APR_DAMAGE,0)+isnull(a.APR_LATE_RECPT,0)+isnull(a.APR_SHORT_RECPT,0)+isnull(a.APR_UNSOLD,0)) end as "RET_' + convert(varchar(10),  @v_datevar  ,101) + '"  , 0 as "SUP_' + convert(varchar(10),  @v_datevar  ,101) + '" '
			set @v_union_var=@v_union_var+', sum(isnull(z."SUP_' + convert(varchar(10),  @v_datevar  ,101) + '",0)) "SUP_' + convert(varchar(10),  @v_datevar  ,101) + '" ,sum(isnull(z."RET_' + convert(varchar(10),  @v_datevar  ,101) + '",0))  "RET_' + convert(varchar(10),  @v_datevar  ,101) + '"  , sum(isnull(z."SUP_' + convert(varchar(10),  @v_datevar  ,101) + '",0)) -  sum(isnull(z."RET_' + convert(varchar(10),  @v_datevar  ,101) + '",0))  "NET_' + convert(varchar(10),  @v_datevar  ,101) + '"  ' 
			set @v_avg_qty =@v_avg_qty + ' + sum(isnull(z."SUP_' + convert(varchar(10),  @v_datevar  ,101) + '",0)) -  sum(isnull(z."RET_' + convert(varchar(10),  @v_datevar  ,101) + '",0))  '
		end
		set @i=@i-1
	end
end
ELSE
begin
	while @i > 0
	begin
		--set @v_datevar=dateadd(dd,@i*-30, @pinputdt)
		set @v_datevar=dateadd(mm,@i*-1, @pinputdt)
	
		--print(@v_datevar)
		if @v_supdates is null or @v_supdates =''
		begin                                                                                                         -- +  +  +  +
			set @v_supdates=' case convert(varchar(10),a.supdate,101) when '''  + convert(varchar(10),@v_datevar,101) + '''  then sum(isnull(a.sup_copy,0)) end as "SUP_' + convert(varchar(10),  @v_datevar  ,101) + '"  , 0 as "RET_' + convert(varchar(10),  @v_datevar  ,101) + '"'
			set @v_retdates=' case convert(varchar(10),a.supdate,101) when '''  + convert(varchar(10),@v_datevar,101) + '''  then sum(isnull(a.APR_BNR,0)+isnull(a.APR_DAMAGE,0)+isnull(a.APR_LATE_RECPT,0)+isnull(a.APR_SHORT_RECPT,0)+isnull(a.APR_UNSOLD,0)) end as "RET_' + convert(varchar(10),  @v_datevar  ,101) + '"  , 0 as "SUP_' + convert(varchar(10),  @v_datevar  ,101) + '" '
			set @v_union_var=' sum(isnull(z."SUP_' + convert(varchar(10),  @v_datevar  ,101) + '",0)) "SUP_' + convert(varchar(10),  @v_datevar  ,101) + '" ,sum(isnull(z."RET_' + convert(varchar(10),  @v_datevar  ,101) + '",0))  "RET_' + convert(varchar(10),  @v_datevar  ,101) + '"  , sum(isnull(z."SUP_' + convert(varchar(10),  @v_datevar  ,101) + '",0)) -  sum(isnull(z."RET_' + convert(varchar(10),  @v_datevar  ,101) + '",0))  "NET_' + convert(varchar(10),  @v_datevar  ,101) + '" ' 
			set @v_avg_qty = ' sum(isnull(z."SUP_' + convert(varchar(10),  @v_datevar  ,101) + '",0)) -  sum(isnull(z."RET_' + convert(varchar(10),  @v_datevar  ,101) + '",0)) '
		end
		else
		begin
			set @v_supdates= @v_supdates + ', case convert(varchar(10),a.supdate,101) when '''  + convert(varchar(10),@v_datevar,101) + '''  then sum(isnull(a.sup_copy,0)) end as "SUP_' + convert(varchar(10),  @v_datevar  ,101) + '"  , 0 as "RET_' + convert(varchar(10),  @v_datevar  ,101) + '"'
			set @v_retdates= @v_retdates + ', case convert(varchar(10),a.supdate,101) when '''  + convert(varchar(10),@v_datevar,101) + '''  then sum(isnull(a.APR_BNR,0)+isnull(a.APR_DAMAGE,0)+isnull(a.APR_LATE_RECPT,0)+isnull(a.APR_SHORT_RECPT,0)+isnull(a.APR_UNSOLD,0)) end as "RET_' + convert(varchar(10),  @v_datevar  ,101) + '"  , 0 as "SUP_' + convert(varchar(10),  @v_datevar  ,101) + '" '
			set @v_union_var=@v_union_var+', sum(isnull(z."SUP_' + convert(varchar(10),  @v_datevar  ,101) + '",0)) "SUP_' + convert(varchar(10),  @v_datevar  ,101) + '" ,sum(isnull(z."RET_' + convert(varchar(10),  @v_datevar  ,101) + '",0))  "RET_' + convert(varchar(10),  @v_datevar  ,101) + '"  , sum(isnull(z."SUP_' + convert(varchar(10),  @v_datevar  ,101) + '",0)) -  sum(isnull(z."RET_' + convert(varchar(10),  @v_datevar  ,101) + '",0))  "NET_' + convert(varchar(10),  @v_datevar  ,101) + '"  ' 
			set @v_avg_qty =@v_avg_qty + ' + sum(isnull(z."SUP_' + convert(varchar(10),  @v_datevar  ,101) + '",0)) -  sum(isnull(z."RET_' + convert(varchar(10),  @v_datevar  ,101) + '",0))  '
		end
		set @i=@i-1
	end
end

	--print(@v_supdates)
	--print(@v_retdates)

print('prachi')
print(@v_supdates)
print(@v_retdates)
print(@v_union_var)
print(@v_avg_qty)
print('khare')
	declare @v_query_sup_select as varchar(max)
	declare @v_query1_sup_where as varchar(max)

	declare @v_query_unsold_select as varchar(max)
	declare @v_query1_unsold_where as varchar(max)

	declare @v_query_union_select as varchar(max)
	declare @v_query1_union_where as varchar(max)
	
	set @v_query_sup_select=' select a.comp_code,a.unit_code,a.agcd,a.dpcd,b.ag_name , b.city_code,b.state_code,b.country_code, '
	set @v_query1_sup_where=' from cir_dbksup a , cir_agmast b,cir_edtn_mast e,cir_publ_mast p 
	where a.comp_code=b.comp_code and a.comp_code=e.comp_code and a.comp_code=p.comp_code 
	and a.comp_code= '''+ @pcomp_code +'''	
	and a.agcd=b.agcd and (a.agcd='''+@pagcd_code+''' or '''+@pagcd_code+''' is null or '''+@pagcd_code+''' ='''')
	and a.dpcd= b.dpcd and (a.dpcd='''+@pdpcd_code+''' or '''+@pdpcd_code+''' is null or '''+@pdpcd_code+''' ='''')
	and a.unit_code=b.unit and a.unit_code='''+ @punit_code + '''
	and a.publ=p.publ and (a.publ=isnull('''+@ppubl_code+''',a.publ) or '''+@ppubl_code+'''='''') 	
	and a.edtn=e.edtn and (a.edtn=isnull('''+@pedtn_code+''',a.edtn)+'''' or '''+@pedtn_code+'''='''')
	and (b.ag_type='''+@pagtype+''' or '''+@pagtype+''' is null or '''+@pagtype+'''='''') 
	and (b.ag_class='''+@pagclasss+''' or '''+@pagclasss+''' is null or '''+@pagclasss+'''='''')
    and (b.branch_code='''+@pbrancode+''' or '''+@pbrancode+''' is null or '''+@pbrancode+'''='''') 
    and (b.city_code='''+@pcitycode+''' or '''+@pcitycode+''' is null or '''+@pcitycode+'''='''') 
    and (b.state_code='''+@pstate+''' or '''+@pstate+''' is null or '''+@pstate+'''='''')
    and (b.dist_code='''+@pdistcode+''' or '''+@pdistcode+''' is null or '''+@pdistcode+'''='''') 
    and (b.tehsil_taluka='''+@ptaluka+''' or '''+@ptaluka+''' is null or '''+@ptaluka+'''='''')
    and (dbo.cir_get_region_by_city(a.comp_code,b.city_code,''C'')='''+@pregcode+''' or '''+@pregcode+''' is null or '''+@pregcode+'''='''') 
    and (dbo.cir_get_zone_by_city(a.comp_code,b.city_code,''C'')='''+@pzonecode+''' or '''+@pzonecode+''' is null or '''+@pzonecode+'''='''') 
    and (dbo.cir_get_route_by_ag(a.comp_code,a.agcd+a.dpcd,''C'')='''+@proutecode+''' or '''+@proutecode+''' is null or '''+@proutecode+'''='''') 
	and (a.sup_type_code ='''+@psup_type+''' or '''+@psup_type+''' is null or '''+@psup_type+''' ='''')
	and (isnull(b.suspend,''N'')=isnull('''+@psuspend+''',''N'') or '''+@psuspend+''' is null or '''+@psuspend+'''='''')
	and ((a.comm_code = '''+@pcomcat+''') or ('''+@pcomcat+''' is null) or ('''+@pcomcat+''' = ''''))
	group by a.supdate,a.comp_code,a.unit_code,a.agcd,a.dpcd,b.ag_name , b.city_code,b.state_code ,b.country_code   '

	

	set @v_query_unsold_select=' select a.comp_code,a.unit_code,a.agcd,a.dpcd,b.ag_name ,  b.city_code,b.state_code ,b.country_code,'
	set @v_query1_unsold_where=' from cir_unsold_dtl a , cir_agmast b,cir_edtn_mast e,cir_publ_mast p 
	where a.comp_code=b.comp_code and a.comp_code=e.comp_code and a.comp_code=p.comp_code 
	and a.comp_code= '''+ @pcomp_code +'''	
	and a.agcd=b.agcd and (a.agcd='''+@pagcd_code+''' or '''+@pagcd_code+''' is null or '''+@pagcd_code+''' ='''')
	and a.dpcd= b.dpcd and (a.dpcd='''+@pdpcd_code+''' or '''+@pdpcd_code+''' is null or '''+@pdpcd_code+''' ='''')
	and a.unit_code=b.unit and a.unit_code='''+ @punit_code + '''
	and a.publ=p.publ and (a.publ=isnull('''+@ppubl_code+''',a.publ) or '''+@ppubl_code+'''='''')	
	and a.edtn=e.edtn and (a.edtn=isnull('''+@pedtn_code+''',a.edtn)+'''' or '''+@pedtn_code+'''='''')
	and (b.ag_type='''+@pagtype+''' or '''+@pagtype+''' is null or '''+@pagtype+'''='''') 
	and (b.ag_class='''+@pagclasss+''' or '''+@pagclasss+''' is null or '''+@pagclasss+'''='''')
    and (b.branch_code='''+@pbrancode+''' or '''+@pbrancode+''' is null or '''+@pbrancode+'''='''') 
    and (b.city_code='''+@pcitycode+''' or '''+@pcitycode+''' is null or '''+@pcitycode+'''='''') 
    and (b.state_code='''+@pstate+''' or '''+@pstate+''' is null or '''+@pstate+'''='''')
    and (b.dist_code='''+@pdistcode+''' or '''+@pdistcode+''' is null or '''+@pdistcode+'''='''') 
    and (b.tehsil_taluka='''+@ptaluka+''' or '''+@ptaluka+''' is null or '''+@ptaluka+'''='''')
    and (dbo.cir_get_region_by_city(a.comp_code,b.city_code,''C'')='''+@pregcode+''' or '''+@pregcode+''' is null or '''+@pregcode+'''='''') 
    and (dbo.cir_get_zone_by_city(a.comp_code,b.city_code,''C'')='''+@pzonecode+''' or '''+@pzonecode+''' is null or '''+@pzonecode+'''='''') 
    and (dbo.cir_get_route_by_ag(a.comp_code,a.agcd+a.dpcd,''C'')='''+@proutecode+''' or '''+@proutecode+''' is null or '''+@proutecode+'''='''') 
	and (isnull(b.suspend,''N'')=isnull('''+@psuspend+''',''N'') or '''+@psuspend+''' is null or '''+@psuspend+'''='''')
	group by a.supdate,a.comp_code,a.unit_code,a.agcd,a.dpcd,b.ag_name , b.city_code,b.state_code ,b.country_code  '

	set @v_query_union_select=' select z.comp_code COMP_CODE,z.unit_code UNIT_CODE,z.agcd AGCD, z.dpcd DPCD,z.ag_name AG_NAME, z.city_code,z.state_code, z.country_code,'
	set @v_query1_union_where = ' ) z group by z.comp_code,z.unit_code,z.agcd,z.dpcd,z.ag_name , z.city_code,z.state_code ,z.country_code	'
	
	print(@v_avg_qty)
	--print(@v_query_sup_select+@v_supdates + @v_query1_sup_where)	
	--print(@v_query_unsold_select+@v_retdates + @v_query1_unsold_where)
	set @v_avg_qty= 'cast(round((('+@v_avg_qty+')' + '/' + cast(@pprevval as varchar)+'),0) as int)'
	print(@v_avg_qty)
	print('s')

	
	if @pextra1='C'
	begin
		exec(@v_query_union_select + @v_union_var + ','+ @v_avg_qty + '"AVG_QTY"' +' from ( '+
		@v_query_sup_select+@v_supdates + @v_query1_sup_where +
		'union all' + @v_query_unsold_select+@v_retdates + @v_query1_unsold_where
		+ @v_query1_union_where + ' order by z.comp_code ,dbo.cir_get_name_cir_city(z.comp_code,z.city_code,''1'','''+@pdateformat+''','''',''''),z.ag_name '
		)
	end
	else if @pextra1='S'
	begin
		exec(@v_query_union_select + @v_union_var + ','+ @v_avg_qty + '"AVG_QTY"' +' from ( '+
		@v_query_sup_select+@v_supdates + @v_query1_sup_where +
		'union all' + @v_query_unsold_select+@v_retdates + @v_query1_unsold_where
		+ @v_query1_union_where + ' order by z.comp_code ,dbo.cir_get_state(z.comp_code,z.country_code,z.state_code),z.ag_name '
		)
	end
	else -- 'A'
	begin
		exec(@v_query_union_select + @v_union_var + ','+ @v_avg_qty + '"AVG_QTY"' +' from ( '+
		@v_query_sup_select+@v_supdates + @v_query1_sup_where +
		'union all' + @v_query_unsold_select+@v_retdates + @v_query1_unsold_where
		+ @v_query1_union_where + ' order by z.comp_code,z.ag_name '
		)
	end

End


//////////////////////////////////////////////////////////////////////////////




ALTER PROCEDURE [dbo].[cir_branch_bind_p2]
	@pcompcode                                VARCHAR(20) ,
	@puserid                                  VARCHAR(20) ,
	@pubcenter                                VARCHAR(200) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS 
	
		SELECT DISTINCT
				 b.Branch_Code,
				 b.Branch_Name
		FROM  login_branch_mast a,
			 branch_mst b 
		WHERE	-- b.pub_center  = @pubcenter
		          (b.pub_center=@pubcenter or @pubcenter is null or @pubcenter='')
		 AND	ISNULL(a.user_flag, 'N')  = 'Y'
		 AND (UPPER(b.Branch_Name)  like UPPER(CAST(@pextra1 AS VARCHAR) + '%') OR (@pextra1  is null) OR (@pextra1  = ''))
		 --AND	((UPPER(b.Branch_Name)  like UPPER(CAST(@pextra1 AS VARCHAR) + '%'))
		 --OR	(@pextra1  is null))
		 
		 
		

////////////////////////////////////////////////////////////



ALTER PROCEDURE  [dbo].[Cir_Route_Bind]
  	@pcompcode as varchar(200),
   	@punitcode as varchar(200),
    @pdateformat as	varchar(200),
    @pextra1 as	varchar(200),
    @pextra2 as varchar(200)
 AS
	select * from cir_route_mast
	where comp_code=@pcompcode and 
	(unit=@punitcode or @punitcode is null or @punitcode='')and
	ISNULL(freeze_flag,'N')='N'
	and ((upper(ROUTE_NAME) like upper(@pextra1+'%')) or (@pextra1 = ''))
	order by route_name

///////////////////////////////////////////////////////////



ALTER PROCEDURE [dbo].[cir_agency_bind_cir_agency_bind_p]
	@pcompcode			VARCHAR(20) ,
	@punit              VARCHAR(20) ,
	@pdateformat        VARCHAR(20) ,
    @pdistcode          VARCHAR(20)=null,  
	@pextra1            VARCHAR(4000) ,
	@pextra2            VARCHAR(4000) 
AS 
BEGIN
	If UPPER(@pextra2)='D' Begin
			
		SELECT cir_agmast_dis.*,dbo.cir_get_city(cir_agmast_dis.comp_code,cir_agmast_dis.city_code) "CITY_NAME",
		dbo.cir_get_agency(cir_agmast_dis.comp_code,cir_agmast_dis.unit,cir_agmast_dis.BILL_AGCD,cir_agmast_dis.BILL_AGCD) "BILL_AGENCY",
		dbo.cir_get_agency_city(cir_agmast_dis.comp_code,cir_agmast_dis.unit,cir_agmast_dis.agcd,cir_agmast_dis.dpcd) "BILL_AGENCY_CITY",
		dbo.cir_get_drop_point_name(cir_agmast_dis.comp_code,cir_agmast_dis.unit,cir_agmast_dis.station_code,1) as "DROP_POINT_NAME"
		FROM  cir_agmast_dis 
		WHERE comp_code  = @pcompcode AND
		(unit  = @punit  or @punit is null or @punit='')
		and(dist_code =@pdistcode or @pdistcode is null or @pdistcode ='')
		 AND ((UPPER(ag_name)  like UPPER(CAST(@pextra1 AS VARCHAR) + '%')) OR	(@pextra1  is null) OR	(@pextra1  = ''))
		 /*AND ISNULL(freeze_flag, 'N')  = 'N'*/
		union
		SELECT cir_agmast_dis.*,dbo.cir_get_city(cir_agmast_dis.comp_code,cir_agmast_dis.city_code) "CITY_NAME",
		dbo.cir_get_agency(cir_agmast_dis.comp_code,cir_agmast_dis.unit,cir_agmast_dis.BILL_AGCD,cir_agmast_dis.BILL_AGCD) "BILL_AGENCY",
		dbo.cir_get_agency_city(cir_agmast_dis.comp_code,cir_agmast_dis.unit,cir_agmast_dis.agcd,cir_agmast_dis.dpcd) "BILL_AGENCY_CITY",
		dbo.cir_get_drop_point_name(cir_agmast_dis.comp_code,cir_agmast_dis.unit,cir_agmast_dis.station_code,1) as "DROP_POINT_NAME"
		FROM  cir_agmast_dis 
		WHERE comp_code  = @pcompcode 
		AND 
		(unit  = @punit  or @punit is null or @punit='')
		and(dist_code =@pdistcode or @pdistcode is null or @pdistcode ='')
		 AND ((UPPER(ag_name)  like UPPER(CAST(@pextra1 AS VARCHAR) + '%')) OR	(@pextra1  is null) OR	(@pextra1  = ''))
		 /*AND ISNULL(freeze_flag, 'N')  = 'N'*/
		ORDER BY 5
	End
	Else Begin
		SELECT cir_agmast.*,dbo.cir_get_city(cir_agmast.comp_code,cir_agmast.city_code) "CITY_NAME",
		dbo.cir_get_agency(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.BILL_AGCD,cir_agmast.BILL_DPCD) "BILL_AGENCY",
		dbo.cir_get_agency_city(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.agcd,cir_agmast.dpcd) "BILL_AGENCY_CITY",
		dbo.cir_get_drop_point_name(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.station_code,1) as "DROP_POINT_NAME"
			FROM  cir_agmast 
			WHERE comp_code  = @pcompcode AND 
			(unit  = @punit  or @punit is null or @punit='')
			and(dist_code =@pdistcode or @pdistcode is null or @pdistcode ='')
			 AND ((UPPER(ag_name)  like UPPER(CAST(@pextra1 AS VARCHAR) + '%')) OR	(@pextra1  is null) OR	(@pextra1  = ''))
			 /*AND ISNULL(freeze_flag, 'N')  = 'N'*/
		union
		SELECT cir_agmast.*,dbo.cir_get_city(cir_agmast.comp_code,cir_agmast.city_code) "CITY_NAME",
		dbo.cir_get_agency(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.BILL_AGCD,cir_agmast.BILL_DPCD) "BILL_AGENCY",
		dbo.cir_get_agency_city(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.agcd,cir_agmast.dpcd) "BILL_AGENCY_CITY",
		dbo.cir_get_drop_point_name(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.station_code,1) as "DROP_POINT_NAME"
			FROM  cir_agmast 
			WHERE comp_code  = @pcompcode AND 
			(unit  = @punit  or @punit is null or @punit='')
			and(dist_code =@pdistcode or @pdistcode is null or @pdistcode ='')
			 AND ((UPPER(agcd)  like UPPER(CAST(@pextra1 AS VARCHAR) + '%')) OR	(@pextra1  is null) OR	(@pextra1  = ''))
			 /*AND ISNULL(freeze_flag, 'N')  = 'N'*/			 
			ORDER BY 5
	End
END


///////////////////////////////////////////////////////////////////////////////


ALTER procedure [dbo].[cir_late_factor_aglist]
    @pcompcode       as varchar(200),
    @punitcode       as varchar(200),
    @ppublcode       as varchar(200),
    @pissuedate      as datetime, 
    @platerate			 as numeric(14,2), 
    @puserid         as varchar(200), 
    @pdateformate    as varchar(200),
    @processby       as varchar(200),---- 1/branch , 2/route , 3/zone , 4/region , 5/district
    @pvar_sel		 as varchar(max),---- value in ['a','b','c','d'] format
    @pagcd			 as varchar(20),
    @pdpcd			 as varchar(20),
    @pagtype		 as varchar(20),
    @pagclass    	 as varchar(20),
    @psuptype		 as varchar(20),
    @preason 		 as varchar(20),
    @pextra1         as varchar(200),
    @pextra2         as varchar(200),
    @pextra3         as varchar(200),
    @pextra4         as varchar(200),
    @pextra5         as varchar(200)
as
    
begin

declare @v1_agcd as varchar(20)
declare @v1_dpcd as varchar(20)
declare @v1_branch_code as varchar(20)
declare @v1_ag_type as varchar(20)
declare @v1_ag_class as varchar(20)
declare @v1_ag_name as varchar(200)
declare @v1_station_code as varchar(20)
declare @v1_route_code as varchar(20)
declare @v1_billagcd as varchar(20)
create table #Results(SegmentNum INT, Edition_Name  VARCHAR(255))

insert into #Results select * from dbo.Fn_Splitfield(@pvar_sel,',')

    declare c1 cursor for
		select distinct a.agcd,a.dpcd,dbo.cir_get_agency(@pcompcode,@punitcode,a.BILL_AGCD,a.BILL_DPCD)as billagname,a.branch_code,a.ag_type,a.ag_class,a.ag_name,a.station_code,b.route_code 
		from cir_agmast a,cir_supply b
		where a.comp_code=@pcompcode 
		and a.comp_code=b.comp_code and a.agcd=b.agcd and a.dpcd=b.dpcd --and a.unit=b.unit
		and isnull(b.late_fee,'N')='Y'
		and (a.unit= @punitcode or @punitcode is null or @punitcode ='')    
		and (
			(@processby='1' and a.branch_code in (select Edition_Name from #Results) ) or
			(@processby='2' and b.route_code in (select Edition_Name from #Results)  ) or
			(@processby='3' and dbo.cir_get_zone_by_city(a.comp_code,a.city_code,'C') in (select Edition_Name from #Results) ) or
			(@processby='4' and dbo.cir_get_region_by_city(a.comp_code,a.city_code,'C') in (select Edition_Name from #Results) ) or
			(@processby='5' and a.dist_code   in (select Edition_Name from #Results) )
			)
		and (a.agcd=@pagcd or @pagcd is null or @pagcd ='')
		and (a.dpcd=@pdpcd or @pdpcd is null or @pdpcd ='')
		and (a.ag_type=@pagtype or @pagtype is null or @pagtype ='')
		and (a.ag_class=@pagclass or @pagclass is null or @pagclass ='')
		and (b.publ=@ppublcode or @ppublcode is null or @ppublcode='')
    


   CREATE TABLE #CIR_late_factor_fee
	(COMP_CODE       VARCHAR(100),
	UNIT_CODE        VARCHAR(100),	
	BRANCH_CODE      varchar(200),
	AGCD             VARCHAR(100),
	DPCD             VARCHAR(100),
	BILL_AGNAME        VARCHAR(100),
	AGNAME           VARCHAR(250),
	AG_TYPE          VARCHAR(20),
	AG_CLASS         VARCHAR(20),
	AG_DROP          VARCHAR(20),
	AG_ROUTE         VARCHAR(20),
	ISSUE_DAY        VARCHAR(20),	
	ISSUE_DT         DATETIME,
	SUPPLY_COPY      NUMERIC(10)                   DEFAULT 0,
	LATE_RATE        NUMERIC(15,2)                 DEFAULT 0,
	LATE_AMT         NUMERIC(15,2)                 DEFAULT 0,
	lateby			 varchar(5),
	dep_time		 varchar(5),
	act_dep_time     varchar(5)
	)

    
declare @vsecond as numeric(14)
declare @v_time_line as varchar(20)
declare @v_supply as numeric(14)
declare @v_day as varchar(20)
declare @v_dep_time as varchar(5)
declare @v_exp_dep as varchar(5)
declare @vtimediff as varchar(6)
set @v_day=CONVERT(VARCHAR(20) , DATENAME(WEEKDAY, @pissuedate),20)


open c1
        fetch NEXT FROM c1 INTO @v1_agcd,@v1_dpcd,@v1_billagcd,@v1_branch_code,@v1_ag_type,@v1_ag_class,@v1_ag_name,@v1_station_code,@v1_route_code
     
        WHILE (@@FETCH_STATUS = 0) 
		BEGIN
		print(@v1_route_code)
		print(@pissuedate)
		
		select @v_time_line=isnull(time_line,'00:00') from cir_route_mast where comp_code=@pcompcode 
		and unit=@punitcode and route_code=@v1_route_code
			
		select distinct @v_exp_dep=EXP_DEP_TIME,@v_dep_time=DEP_TIME, @vtimediff=replace(DBO.time_diff(dep_time, exp_dep_time),'S','') from CIR_ROUTE_TAXI_MAST
		where comp_code=@pcompcode and (unit_code=@punitcode or @punitcode is null or @punitcode='')
		and route_code=	@v1_route_code and dep_date= @pissuedate
		
		print(@v_time_line)	
		print(@v_exp_dep)	
		print(@v_dep_time)
		print(@vtimediff)
		print('22222222222')
		print(@v_day)
		if @v_day='Sunday' Begin 
		   select distinct @v_supply=sum(isnull(base_supply,0))+sum(isnull(supply_sun,0)) from cir_supply 
		   where comp_code=@pcompcode and (unit=@punitcode or @punitcode is null or @punitcode='')
		   and agcd=@v1_agcd and dpcd=@v1_dpcd 
		   and (publ=@ppublcode or @ppublcode is null or @ppublcode ='')
		   and (SUPPLY_TYPE_CODE=@psuptype or @psuptype is null or @psuptype ='')
		   
		End    
		Else if @v_day='Monday' Begin
			select distinct @v_supply=sum(isnull(base_supply,0))+sum(isnull(supply_mon,0)) from cir_supply 
		   where comp_code=@pcompcode and (unit=@punitcode or @punitcode is null or @punitcode='')
		   and agcd=@v1_agcd and dpcd=@v1_dpcd 
		   and (publ=@ppublcode or @ppublcode is null or @ppublcode ='')
		   and (SUPPLY_TYPE_CODE=@psuptype or @psuptype is null or @psuptype ='')
		End    
		Else if @v_day='Tuesday' Begin
			select distinct @v_supply=sum(isnull(base_supply,0))+sum(isnull(supply_tue,0)) from cir_supply 
		   where comp_code=@pcompcode and (unit=@punitcode or @punitcode is null or @punitcode='')
		   and agcd=@v1_agcd and dpcd=@v1_dpcd 
		   and (publ=@ppublcode or @ppublcode is null or @ppublcode ='')
		   and (SUPPLY_TYPE_CODE=@psuptype or @psuptype is null or @psuptype ='')
		End 
		Else If @v_day='Wednesday' Begin
			select distinct @v_supply=sum(isnull(base_supply,0))+sum(isnull(supply_wed,0)) from cir_supply 
		   where comp_code=@pcompcode and (unit=@punitcode or @punitcode is null or @punitcode='')
		   and agcd=@v1_agcd and dpcd=@v1_dpcd 
		   and (publ=@ppublcode or @ppublcode is null or @ppublcode ='')
		   and (SUPPLY_TYPE_CODE=@psuptype or @psuptype is null or @psuptype ='')
		End    
		Else If @v_day='Thursday' Begin
			select distinct @v_supply=sum(isnull(base_supply,0))+sum(isnull(supply_thu,0)) from cir_supply 
		   where comp_code=@pcompcode and (unit=@punitcode or @punitcode is null or @punitcode='')
		   and agcd=@v1_agcd and dpcd=@v1_dpcd 
		   and (publ=@ppublcode or @ppublcode is null or @ppublcode ='')
		   and (SUPPLY_TYPE_CODE=@psuptype or @psuptype is null or @psuptype ='')
		End    
		Else if @v_day='Friday' Begin
			select distinct @v_supply=sum(isnull(base_supply,0))+sum(isnull(supply_fri,0)) from cir_supply 
		   where comp_code=@pcompcode and (unit=@punitcode or @punitcode is null or @punitcode='')
		   and agcd=@v1_agcd and dpcd=@v1_dpcd 
		   and (publ=@ppublcode or @ppublcode is null or @ppublcode ='')
		   and (SUPPLY_TYPE_CODE=@psuptype or @psuptype is null or @psuptype ='')
		End
		Else Begin
			select distinct @v_supply=sum(isnull(base_supply,0))+sum(isnull(supply_sat,0)) from cir_supply 
		   where comp_code=@pcompcode and (unit=@punitcode or @punitcode is null or @punitcode='')
		   and agcd=@v1_agcd and dpcd=@v1_dpcd 
		   and (publ=@ppublcode or @ppublcode is null or @ppublcode ='')
		   and (SUPPLY_TYPE_CODE=@psuptype or @psuptype is null or @psuptype ='')
		End
		print('X')print(@v_dep_time)print(@v_time_line)print('Z')
		set @vsecond=datediff(ss,@v_time_line,@v_dep_time )	
		
		print('debug')

		print(@v_supply)
		print('3434')
		print(@vsecond)
		print('end')
		
		if @vsecond >0 begin
			insert into #CIR_late_factor_fee
				(COMP_CODE, UNIT_CODE, BRANCH_CODE,AGCD, DPCD,BILL_AGNAME, AGNAME,AG_TYPE,AG_CLASS, 
			AG_DROP,AG_ROUTE,ISSUE_DAY,ISSUE_DT,SUPPLY_COPY,LATE_RATE,LATE_AMT,lateby,dep_time,act_dep_time)
			values(@pcompcode,@punitcode,@v1_branch_code,@v1_agcd,@v1_dpcd,@v1_billagcd,@v1_ag_name,@v1_ag_type,@v1_ag_class,
			@v1_station_code,@v1_route_code,upper(@v_day),@pissuedate,@v_supply,@platerate,isnull(@v_supply,0)*isnull(@platerate,0)
			,@vtimediff,@v_dep_time,@v_exp_dep)
		end
			
        fetch NEXT FROM c1 INTO @v1_agcd,@v1_dpcd,@v1_billagcd,@v1_branch_code,@v1_ag_type,@v1_ag_class,@v1_ag_name,@v1_station_code,@v1_route_code
    end
    close c1;
    deallocate c1
     
     select * from #CIR_late_factor_fee
           
select COMP_CODE, UNIT_CODE,--dbo.cir_get_unit_name(COMP_CODE,UNIT_CODE) as UNIT, 
BRANCH_CODE,dbo.cir_get_branch(COMP_CODE,BRANCH_CODE) BRANCH ,
AGCD, DPCD,BILL_AGNAME, AGNAME,AG_TYPE,AG_CLASS, 
AG_DROP,AG_ROUTE,dbo.cir_get_route_name(COMP_CODE,UNIT_CODE,AG_ROUTE) ROUTE
,ISSUE_DAY,ISSUE_DT,SUPPLY_COPY,LATE_RATE,LATE_AMT,lateby 
,dep_time,act_dep_time,dbo.cir_get_drop_point_name(COMP_CODE,UNIT_CODE,AG_DROP,'1') AG_DROP_NAME
from #CIR_late_factor_fee x
where x.comp_code+x.AGCD+x.DPCD--+CAST(ISSUE_DT as varchar) 
not in
(select t.comp_code+t.AGCD+t.DPCD from cir_late_factor_fee_process t --+CAST(ISSUE_DT as varchar)
where t.comp_code=@pcompcode and t.docno is not null and t.docdt is not null and t.flag='Y' )


drop table #CIR_late_factor_fee
drop table #Results
End


/////////////////////////////////////////////////////


                             
ALTER procedure [dbo].[cir_rep_unsold_supply_cir_rep_unsold_challan]
     @pcompcode 		as varchar(20),
     @punitcode 		as varchar(20),
     @pdoctype			as varchar(20),
     @pagcode			as varchar(20),
     @pagsubcode		as varchar(20),
     @pfrom_recdate 	as datetime,
     @ptill_recdate     as datetime,
     @precptno          as varchar(2000),
     @papproved_flag    as varchar(20),
     @pdateformat       as varchar(20),
     @pextra1           as varchar(2000),---Unsold History Y
     @pextra2           as varchar(2000)
  As
  Begin
    create table #Results(SegmentNum INT, Edition_Name  VARCHAR(255))
       insert into #Results select * from dbo.Fn_Splitfield(@precptno,',')
       
      -- select edition_name from #Results
    if @pextra1='Y' 
    Begin
    select d.comp_code as COMP_CODE,d.unit_code as UNIT_CODE,d.branch_code BRANCH_CODE,
    dbo.get_branch_name(d.branch_code) BRANCH_NAME,d.agcd AGCD,d.dpcd DPCD,
    m.AG_NAME,d.recptdt RECPTDT,d.recptno RECPTNO ,d.publ PUBL,dbo.cir_get_name_cir_publ(d.comp_code,d.publ,1,'','','') PUBL_NAME, 
    e.main_edtn MAIN_EDTN,dbo.cir_get_name_cir_edtn(d.comp_code,d.unit_code,e.main_edtn,1,'','','') MAIN_EDTNNAME,d.edtn EDTN,e.EDTN_NAME,
    d.copy_rate COPY_RATE,
    sum(isnull(d.short_recpt,0)+isnull(d.late_recpt,0)+isnull(d.bnr,0)+isnull(d.unsold,0)) RETURN_COPY,
    sum(isnull(d.DAMAGE,0)+isnull(d.late_recpt,0)+isnull(d.unsold,0)) QTY,
    d.SUPDATE,h.FORM_NO
    from cir_agmast_dis m, cir_unsold_hdr_dis h,cir_unsold_dtl_dis d,cir_edtn_mast e
    where m.comp_code=d.comp_code and d.comp_code=h.comp_code and m.comp_code=e.comp_code and m.comp_code=@pcompcode and 
    m.unit=d.unit_code and d.unit_code=h.unit_code and m.unit=e.unit_code and m.unit=@punitcode and 
    m.agcd=d.agcd and m.agcd=isnull(@pagcode,m.agcd) and m.dpcd=d.dpcd and m.dpcd=isnull(@pagsubcode,m.dpcd) and 
    d.doctype=h.doctype and d.doctype=isnull(@pdoctype,d.doctype) and d.recptdt=h.recptdt 
    and 
    --d.recptdt between @pfrom_recdate and @ptill_recdate and 
    d.recptno=h.recptno and 
    --d.recptno =isnull(@precptno,d.recptno) and 
     (d.recptno in ( select edition_name from #Results) or @precptno is null or @precptno='' ) and
    d.publ=e.publ and d.edtn=e.edtn and @pextra2='D'
    group by d.comp_code,d.unit_code,d.agcd,d.dpcd ,m.ag_name,d.recptdt,d.recptno ,d.publ,d.edtn,
    d.copy_rate,e.main_edtn,d.branch_code,e.edtn_name,d.SUPDATE,h.FORM_NO
    union
    select d.comp_code as COMP_CODE,d.unit_code as UNIT_CODE,d.branch_code BRANCH_CODE,
    dbo.get_branch_name(d.branch_code) BRANCH_NAME,d.agcd AGCD,d.dpcd DPCD,
    m.AG_NAME,d.recptdt RECPTDT,d.recptno RECPTNO ,d.publ PUBL,dbo.cir_get_name_cir_publ(d.comp_code,d.publ,1,'','','') PUBL_NAME, 
    e.main_edtn MAIN_EDTN,dbo.cir_get_name_cir_edtn(d.comp_code,d.unit_code,e.main_edtn,1,'','','') MAIN_EDTNNAME,d.edtn EDTN,e.EDTN_NAME,
    d.copy_rate COPY_RATE,
    sum(isnull(d.short_recpt,0)+isnull(d.late_recpt,0)+isnull(d.bnr,0)+isnull(d.unsold,0)) RETURN_COPY,
      sum(isnull(d.DAMAGE,0)+isnull(d.late_recpt,0)+isnull(d.unsold,0)) QTY,
    d.SUPDATE, h.FORM_NO
   
    from cir_agmast m, cir_unsold_hdr h,cir_unsold_dtl d,cir_edtn_mast e
    where m.comp_code=d.comp_code and d.comp_code=h.comp_code and m.comp_code=e.comp_code and m.comp_code=@pcompcode and 
    m.unit=d.unit_code and d.unit_code=h.unit_code and m.unit=e.unit_code and m.unit=@punitcode and 
    m.agcd=d.agcd and m.agcd=isnull(@pagcode,m.agcd) and m.dpcd=d.dpcd and m.dpcd=isnull(@pagsubcode,m.dpcd) and 
    d.doctype=h.doctype and d.doctype=isnull(@pdoctype,d.doctype) 
    and d.recptdt=h.recptdt 
    and 
    --d.recptdt between @pfrom_recdate and @ptill_recdate and 
    d.recptno=h.recptno 
    --and d.recptno =isnull(@precptno,d.recptno)  
    and(d.recptno in ( select edition_name from #Results) or @precptno is null or @precptno='' ) and
    d.publ=e.publ and d.edtn=e.edtn and (@pextra2!='D' or @pextra2='' or @pextra2 is null)
    group by d.comp_code,d.unit_code,d.agcd,d.dpcd ,m.ag_name,d.recptdt,d.recptno ,d.publ,d.edtn,
    d.copy_rate,e.main_edtn,d.branch_code,e.edtn_name,d.SUPDATE,h.FORM_NO
    order by comp_code,unit_code,recptdt,recptno,publ_name,main_edtnname,edtn_name
    
  End
    else
		Begin
    select d.comp_code as COMP_CODE,d.unit_code as UNIT_CODE,d.branch_code BRANCH_CODE,
    dbo.get_branch_name(d.branch_code) BRANCH_NAME,d.agcd AGCD,d.dpcd DPCD,
    m.AG_NAME,d.recptdt RECPTDT,d.recptno RECPTNO ,d.publ PUBL,dbo.cir_get_name_cir_publ(d.comp_code,d.publ,1,'','','') PUBL_NAME, 
    e.main_edtn MAIN_EDTN,dbo.cir_get_name_cir_edtn(d.comp_code,d.unit_code,e.main_edtn,1,'','','') MAIN_EDTNNAME,d.edtn EDTN,e.EDTN_NAME,
    d.copy_rate COPY_RATE,
    sum(isnull(d.short_recpt,0)+isnull(d.late_recpt,0)+isnull(d.bnr,0)+isnull(d.unsold,0)) RETURN_COPY,
    sum(isnull(d.DAMAGE,0)+isnull(d.late_recpt,0)+isnull(d.unsold,0)) QTY,
    d.SUPDATE,h.FORM_NO
    from cir_agmast_dis m, cir_unsold_hdr_dis h,cir_unsold_dtl_dis d,cir_edtn_mast e
    where m.comp_code=d.comp_code and d.comp_code=h.comp_code and m.comp_code=e.comp_code and m.comp_code=@pcompcode and 
    m.unit=d.unit_code and d.unit_code=h.unit_code and m.unit=e.unit_code and m.unit=@punitcode and 
    m.agcd=d.agcd and m.agcd=isnull(@pagcode,m.agcd) and m.dpcd=d.dpcd and m.dpcd=isnull(@pagsubcode,m.dpcd) and 
    d.doctype=h.doctype and d.doctype=isnull(@pdoctype,d.doctype) and d.recptdt=h.recptdt 
    and d.recptdt between @pfrom_recdate and @ptill_recdate and 
    d.recptno=h.recptno and 
    --d.recptno =isnull(@precptno,d.recptno) and 
     (d.recptno in ( select edition_name from #Results) or @precptno is null or @precptno='' ) and
    d.publ=e.publ and d.edtn=e.edtn and @pextra2='D'
    group by d.comp_code,d.unit_code,d.agcd,d.dpcd ,m.ag_name,d.recptdt,d.recptno ,d.publ,d.edtn,
    d.copy_rate,e.main_edtn,d.branch_code,e.edtn_name,d.SUPDATE,h.FORM_NO
    union
    select d.comp_code as COMP_CODE,d.unit_code as UNIT_CODE,d.branch_code BRANCH_CODE,
    dbo.get_branch_name(d.branch_code) BRANCH_NAME,d.agcd AGCD,d.dpcd DPCD,
    m.AG_NAME,d.recptdt RECPTDT,d.recptno RECPTNO ,d.publ PUBL,dbo.cir_get_name_cir_publ(d.comp_code,d.publ,1,'','','') PUBL_NAME, 
    e.main_edtn MAIN_EDTN,dbo.cir_get_name_cir_edtn(d.comp_code,d.unit_code,e.main_edtn,1,'','','') MAIN_EDTNNAME,d.edtn EDTN,e.EDTN_NAME,
    d.copy_rate COPY_RATE,
    sum(isnull(d.short_recpt,0)+isnull(d.late_recpt,0)+isnull(d.bnr,0)+isnull(d.unsold,0)) RETURN_COPY,
      sum(isnull(d.DAMAGE,0)+isnull(d.late_recpt,0)+isnull(d.unsold,0)) QTY,
    d.SUPDATE, h.FORM_NO
   
    from cir_agmast m, cir_unsold_hdr h,cir_unsold_dtl d,cir_edtn_mast e
    where m.comp_code=d.comp_code and d.comp_code=h.comp_code and m.comp_code=e.comp_code and m.comp_code=@pcompcode and 
    m.unit=d.unit_code and d.unit_code=h.unit_code and m.unit=e.unit_code and m.unit=@punitcode and 
    m.agcd=d.agcd and m.agcd=isnull(@pagcode,m.agcd) and m.dpcd=d.dpcd and m.dpcd=isnull(@pagsubcode,m.dpcd) and 
    d.doctype=h.doctype and d.doctype=isnull(@pdoctype,d.doctype) 
    and d.recptdt=h.recptdt 
    and d.recptdt between @pfrom_recdate and @ptill_recdate and 
    d.recptno=h.recptno 
    --and d.recptno =isnull(@precptno,d.recptno)  
    and(d.recptno in ( select edition_name from #Results) or @precptno is null or @precptno='' ) and
    d.publ=e.publ and d.edtn=e.edtn and (@pextra2!='D' or @pextra2='' or @pextra2 is null)
    group by d.comp_code,d.unit_code,d.agcd,d.dpcd ,m.ag_name,d.recptdt,d.recptno ,d.publ,d.edtn,
    d.copy_rate,e.main_edtn,d.branch_code,e.edtn_name,d.SUPDATE,h.FORM_NO
    order by comp_code,unit_code,recptdt,recptno,publ_name,main_edtnname,edtn_name
    
  End  
End
       



/////////////////////////////////////////////////////////


                             
ALTER procedure [dbo].[cir_rep_unsold_supply_cir_rep_unsold_challan]
     @pcompcode 		as varchar(20),
     @punitcode 		as varchar(20),
     @pdoctype			as varchar(20),
     @pagcode			as varchar(20),
     @pagsubcode		as varchar(20),
     @pfrom_recdate 	as datetime,
     @ptill_recdate     as datetime,
     @precptno          as varchar(2000),
     @papproved_flag    as varchar(20),
     @pdateformat       as varchar(20),
     @pextra1           as varchar(2000),---Unsold History Y
     @pextra2           as varchar(2000)
  As
  Begin
    create table #Results(SegmentNum INT, Edition_Name  VARCHAR(255))
       insert into #Results select * from dbo.Fn_Splitfield(@precptno,',')
       
      -- select edition_name from #Results
    if @pextra1='Y' 
    Begin
    select d.comp_code as COMP_CODE,d.unit_code as UNIT_CODE,d.branch_code BRANCH_CODE,
    dbo.get_branch_name(d.branch_code) BRANCH_NAME,d.agcd AGCD,d.dpcd DPCD,
    m.AG_NAME,d.recptdt RECPTDT,d.recptno RECPTNO ,d.publ PUBL,dbo.cir_get_name_cir_publ(d.comp_code,d.publ,1,'','','') PUBL_NAME, 
    e.main_edtn MAIN_EDTN,dbo.cir_get_name_cir_edtn(d.comp_code,d.unit_code,e.main_edtn,1,'','','') MAIN_EDTNNAME,d.edtn EDTN,e.EDTN_NAME,
    d.copy_rate COPY_RATE,
    sum(isnull(d.short_recpt,0)+isnull(d.late_recpt,0)+isnull(d.bnr,0)+isnull(d.unsold,0)) RETURN_COPY,
    sum(isnull(d.DAMAGE,0)+isnull(d.late_recpt,0)+isnull(d.unsold,0)) QTY,
    d.SUPDATE,h.FORM_NO
    from cir_agmast_dis m, cir_unsold_hdr_dis h,cir_unsold_dtl_dis d,cir_edtn_mast e
    where m.comp_code=d.comp_code and d.comp_code=h.comp_code and m.comp_code=e.comp_code and m.comp_code=@pcompcode and 
    m.unit=d.unit_code and d.unit_code=h.unit_code and m.unit=e.unit_code and m.unit=@punitcode and 
    m.agcd=d.agcd and m.agcd=isnull(@pagcode,m.agcd) and m.dpcd=d.dpcd and m.dpcd=isnull(@pagsubcode,m.dpcd) and 
    d.doctype=h.doctype and d.doctype=isnull(@pdoctype,d.doctype) and d.recptdt=h.recptdt 
    and 
    --d.recptdt between @pfrom_recdate and @ptill_recdate and 
    d.recptno=h.recptno and 
    --d.recptno =isnull(@precptno,d.recptno) and 
     (d.recptno in ( select edition_name from #Results) or @precptno is null or @precptno='' ) and
    d.publ=e.publ and d.edtn=e.edtn and @pextra2='D'
    group by d.comp_code,d.unit_code,d.agcd,d.dpcd ,m.ag_name,d.recptdt,d.recptno ,d.publ,d.edtn,
    d.copy_rate,e.main_edtn,d.branch_code,e.edtn_name,d.SUPDATE,h.FORM_NO
    union
    select d.comp_code as COMP_CODE,d.unit_code as UNIT_CODE,d.branch_code BRANCH_CODE,
    dbo.get_branch_name(d.branch_code) BRANCH_NAME,d.agcd AGCD,d.dpcd DPCD,
    m.AG_NAME,d.recptdt RECPTDT,d.recptno RECPTNO ,d.publ PUBL,dbo.cir_get_name_cir_publ(d.comp_code,d.publ,1,'','','') PUBL_NAME, 
    e.main_edtn MAIN_EDTN,dbo.cir_get_name_cir_edtn(d.comp_code,d.unit_code,e.main_edtn,1,'','','') MAIN_EDTNNAME,d.edtn EDTN,e.EDTN_NAME,
    d.copy_rate COPY_RATE,
    sum(isnull(d.short_recpt,0)+isnull(d.late_recpt,0)+isnull(d.bnr,0)+isnull(d.unsold,0)) RETURN_COPY,
      sum(isnull(d.DAMAGE,0)+isnull(d.late_recpt,0)+isnull(d.unsold,0)) QTY,
    d.SUPDATE, h.FORM_NO
   
    from cir_agmast m, cir_unsold_hdr h,cir_unsold_dtl d,cir_edtn_mast e
    where m.comp_code=d.comp_code and d.comp_code=h.comp_code and m.comp_code=e.comp_code and m.comp_code=@pcompcode and 
    m.unit=d.unit_code and d.unit_code=h.unit_code and m.unit=e.unit_code and m.unit=@punitcode and 
    m.agcd=d.agcd and m.agcd=isnull(@pagcode,m.agcd) and m.dpcd=d.dpcd and m.dpcd=isnull(@pagsubcode,m.dpcd) and 
    d.doctype=h.doctype and d.doctype=isnull(@pdoctype,d.doctype) 
    and d.recptdt=h.recptdt 
    and 
    --d.recptdt between @pfrom_recdate and @ptill_recdate and 
    d.recptno=h.recptno 
    --and d.recptno =isnull(@precptno,d.recptno)  
    and(d.recptno in ( select edition_name from #Results) or @precptno is null or @precptno='' ) and
    d.publ=e.publ and d.edtn=e.edtn and (@pextra2!='D' or @pextra2='' or @pextra2 is null)
    group by d.comp_code,d.unit_code,d.agcd,d.dpcd ,m.ag_name,d.recptdt,d.recptno ,d.publ,d.edtn,
    d.copy_rate,e.main_edtn,d.branch_code,e.edtn_name,d.SUPDATE,h.FORM_NO
    order by comp_code,unit_code,recptdt,recptno,publ_name,main_edtnname,edtn_name
    
  End
    else
		Begin
    select d.comp_code as COMP_CODE,d.unit_code as UNIT_CODE,d.branch_code BRANCH_CODE,
    dbo.get_branch_name(d.branch_code) BRANCH_NAME,d.agcd AGCD,d.dpcd DPCD,
    m.AG_NAME,d.recptdt RECPTDT,d.recptno RECPTNO ,d.publ PUBL,dbo.cir_get_name_cir_publ(d.comp_code,d.publ,1,'','','') PUBL_NAME, 
    e.main_edtn MAIN_EDTN,dbo.cir_get_name_cir_edtn(d.comp_code,d.unit_code,e.main_edtn,1,'','','') MAIN_EDTNNAME,d.edtn EDTN,e.EDTN_NAME,
    d.copy_rate COPY_RATE,
    sum(isnull(d.short_recpt,0)+isnull(d.late_recpt,0)+isnull(d.bnr,0)+isnull(d.unsold,0)) RETURN_COPY,
    sum(isnull(d.DAMAGE,0)+isnull(d.late_recpt,0)+isnull(d.unsold,0)) QTY,
    d.SUPDATE,h.FORM_NO
    from cir_agmast_dis m, cir_unsold_hdr_dis h,cir_unsold_dtl_dis d,cir_edtn_mast e
    where m.comp_code=d.comp_code and d.comp_code=h.comp_code and m.comp_code=e.comp_code and m.comp_code=@pcompcode and 
    m.unit=d.unit_code and d.unit_code=h.unit_code and m.unit=e.unit_code and m.unit=@punitcode and 
    m.agcd=d.agcd and m.agcd=isnull(@pagcode,m.agcd) and m.dpcd=d.dpcd and m.dpcd=isnull(@pagsubcode,m.dpcd) and 
    d.doctype=h.doctype and d.doctype=isnull(@pdoctype,d.doctype) and d.recptdt=h.recptdt 
    and d.recptdt between @pfrom_recdate and @ptill_recdate and 
    d.recptno=h.recptno and 
    --d.recptno =isnull(@precptno,d.recptno) and 
     (d.recptno in ( select edition_name from #Results) or @precptno is null or @precptno='' ) and
    d.publ=e.publ and d.edtn=e.edtn and @pextra2='D'
    group by d.comp_code,d.unit_code,d.agcd,d.dpcd ,m.ag_name,d.recptdt,d.recptno ,d.publ,d.edtn,
    d.copy_rate,e.main_edtn,d.branch_code,e.edtn_name,d.SUPDATE,h.FORM_NO
    union
    select d.comp_code as COMP_CODE,d.unit_code as UNIT_CODE,d.branch_code BRANCH_CODE,
    dbo.get_branch_name(d.branch_code) BRANCH_NAME,d.agcd AGCD,d.dpcd DPCD,
    m.AG_NAME,d.recptdt RECPTDT,d.recptno RECPTNO ,d.publ PUBL,dbo.cir_get_name_cir_publ(d.comp_code,d.publ,1,'','','') PUBL_NAME, 
    e.main_edtn MAIN_EDTN,dbo.cir_get_name_cir_edtn(d.comp_code,d.unit_code,e.main_edtn,1,'','','') MAIN_EDTNNAME,d.edtn EDTN,e.EDTN_NAME,
    d.copy_rate COPY_RATE,
    sum(isnull(d.short_recpt,0)+isnull(d.late_recpt,0)+isnull(d.bnr,0)+isnull(d.unsold,0)) RETURN_COPY,
      sum(isnull(d.DAMAGE,0)+isnull(d.late_recpt,0)+isnull(d.unsold,0)) QTY,
    d.SUPDATE, h.FORM_NO
   
    from cir_agmast m, cir_unsold_hdr h,cir_unsold_dtl d,cir_edtn_mast e
    where m.comp_code=d.comp_code and d.comp_code=h.comp_code and m.comp_code=e.comp_code and m.comp_code=@pcompcode and 
    m.unit=d.unit_code and d.unit_code=h.unit_code and m.unit=e.unit_code and m.unit=@punitcode and 
    m.agcd=d.agcd and m.agcd=isnull(@pagcode,m.agcd) and m.dpcd=d.dpcd and m.dpcd=isnull(@pagsubcode,m.dpcd) and 
    d.doctype=h.doctype and d.doctype=isnull(@pdoctype,d.doctype) 
    and d.recptdt=h.recptdt 
    and d.recptdt between @pfrom_recdate and @ptill_recdate and 
    d.recptno=h.recptno 
    --and d.recptno =isnull(@precptno,d.recptno)  
    and(d.recptno in ( select edition_name from #Results) or @precptno is null or @precptno='' ) and
    d.publ=e.publ and d.edtn=e.edtn and (@pextra2!='D' or @pextra2='' or @pextra2 is null)
    group by d.comp_code,d.unit_code,d.agcd,d.dpcd ,m.ag_name,d.recptdt,d.recptno ,d.publ,d.edtn,
    d.copy_rate,e.main_edtn,d.branch_code,e.edtn_name,d.SUPDATE,h.FORM_NO
    order by comp_code,unit_code,recptdt,recptno,publ_name,main_edtnname,edtn_name
    
  End  
End
       

/////////////////////////////////////////////////////end/////////////////////////////////////////



///////////////////////////////////////ADD BY DEEPIKA 05-02-2013 SENT BY gAURAV SIR//////////////////////////////


                                                                     
                                                                     
                                                                     
                                             
ALTER procedure [dbo].[cir_agencywise_product]
@pcompcode as varchar(20),
@punitcode  as varchar(20),
@pagcd as varchar(20),
@pdpcd as varchar(20),
@ptype as varchar(20),--1 for product wise and 2 for publication wise
@puserid as varchar(20),
@pdateformate as varchar(20),
@pextra1 as varchar(200),
@pextra2 as varchar(200),
@pextra3 as varchar(200),
@pextra4 as varchar(200),
@pextra5 as varchar(200)
as

declare @v_dt datetime

begin

set @v_dt=getdate();
If @ptype='2' Begin
	select distinct t.publ_type,t.publ_type_name,min(t.publ_fregquncy) publ_fregquncy from (
	select distinct p.publ as publ_type, p.publ_name as publ_type_name,min(p.period) as publ_fregquncy
	from cir_supply s,cir_publ_mast p,pub_type_mast t
	where s.comp_code=p.comp_code and s.comp_code=@pcompcode and
	s.unit=@punitcode and s.agcd=@pagcd and s.dpcd=@pdpcd and s.publ=p.publ and p.pro_type=t."pubtypecode"
	group by p.publ,p.publ_name
	union all
	select distinct p.publ as publ_type, p.publ_name as publ_type_name,min(p.period) as publ_fregquncy
	from cir_bill_det b,cir_publ_mast p,pub_type_mast t
	where b.comp_code=p.comp_code and b.comp_code=@pcompcode and b.unit_code=@punitcode and b.billdt<=@v_dt and
	b.agcd=@pagcd and b.dpcd=@pdpcd and b.publ=p.publ and p.pro_type=t."pubtypecode"
	group by p.publ,p.publ_name
	) t group by t.publ_type,t.publ_type_name
	order by t.publ_type,t.publ_type_name,publ_fregquncy
End
Else Begin
	select t.publ_type,t.publ_type_name,min(t.publ_fregquncy) publ_fregquncy from (
	select distinct p.pro_type as publ_type, t."pubname" as publ_type_name,min(p.period) as publ_fregquncy
	from cir_supply s,cir_publ_mast p,pub_type_mast t
	where s.comp_code=p.comp_code and s.comp_code=@pcompcode and
	s.unit=@punitcode and s.agcd=@pagcd and s.dpcd=@pdpcd and s.publ=p.publ and p.pro_type=t."pubtypecode"
	group by p.pro_type,t."pubname"
	union all
	select distinct p.pro_type as publ_type, t."pubname" as publ_type_name,min(p.period) as publ_fregquncy
	from cir_bill_det b,cir_publ_mast p,pub_type_mast t
	where b.comp_code=p.comp_code and b.comp_code=@pcompcode and b.unit_code=@punitcode and b.billdt<=@v_dt and
	b.agcd=@pagcd and b.dpcd=@pdpcd and b.publ=p.publ and p.pro_type=t."pubtypecode"
	group by p.pro_type,t."pubname"
	) t group by t.publ_type,t.publ_type_name
	order by t.publ_type,t.publ_type_name,publ_fregquncy
End
end

//////////////////////////////////////////////////NEXT//////////////////

                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE [dbo].[cir_ledger_ageing]
@pcomp_code varchar(20),
@punit_code varchar(20),
@pbran_code varchar(20),
@pzone_code varchar(30),
@pregion_code varchar(30),
@pdist_code varchar(20),
@ptaluka_code varchar(20),
@pagtype varchar(50),
@pagclass varchar(50),
@pag_main_code varchar(50),
@pag_sub_code varchar(50),
@paging_by varchar(50),
@pasondt datetime,
@pdebitupto_date datetime,
@pcreditupto_date datetime,
@pdateformat varchar(20),
@puserid varchar(20),
@pextra1 varchar(20),
@pextra2 varchar(20),
@pextra3 varchar(30),
@pextra4 varchar(30),
@pextra5 varchar(50)
As

--------- slabs end

declare @ptill_days1 as varchar(20)
declare @ptill_days2 as varchar(20)
declare @ptill_days3 as varchar(30)
declare @ptill_days4 as varchar(30)
declare @ptill_days5 as varchar(50)
declare @ptill_days6 as varchar(50)
declare @ptill_current as varchar(50)
---------------- slabs

declare @vtodt as datetime
declare @vasondt as datetime
declare @v_dt as datetime
declare @v_ondt as datetime
declare @v_days numeric(10);
declare @v_pending_rcpt_amt as numeric(14,2)
declare @v_amt as numeric(14,2);
declare @v_amt030 as numeric(14,2);
declare @v_amt3160 as numeric(14,2);
declare @v_amt6190 as numeric(14,2);
declare @v_amt91120 as numeric(14,2);
declare @v_amt121180 as numeric(14,2);
declare @v_amt181 as numeric(14,2);
declare @v_amtcur as numeric(14,2);
declare @debit_amt_030 as numeric(14,2) --debit amt for slab 1 days
declare @debit_amt_3160 as numeric(14,2) --debit amt for slab 2 days
declare @debit_amt_6190 as numeric(14,2) --debit amt for slab 3 days
declare @debit_amt_91120 as numeric(14,2) --debit amt for slab 4 days
declare @debit_amt_121180 as numeric(14,2) --debit amt for >slab 5 days
declare @debit_amt_181 as numeric(14,2) --debit amt for >slab 6 days
declare @debit_amt_cur as numeric(14,2) --debit amt for >current
declare @bill_pending_amt as numeric(14,2)
declare @rcpt_pending_amt as numeric(14,2) --pending receipt amount

CREATE TABLE #cir_temp_ageing
(
	COMP_CODE VARCHAR(8),
	UNIT_CODE VARCHAR(8),
	BRAN_CODE VARCHAR(8),
	AGCD VARCHAR(8),
	DPCD VARCHAR(8),
	AG_NAME VARCHAR(100),
	CITY_NAME VARCHAR(100),
	PENDING_AMT NUMERIC(14,2),
	CUR_AMT NUMERIC(14,2),
	SLAB_1 NUMERIC(14,2),
	SLAB_2 NUMERIC(14,2),
	SLAB_3 NUMERIC(14,2),
	SLAB_4 NUMERIC(14,2),
	SLAB_5 NUMERIC(14,2),
	SLAB_6 NUMERIC(14,2),
	ON_ACAMT NUMERIC(14,2),
	RECT_PENDING NUMERIC(14,2),
	SESSIONID NUMERIC(14),
	PUBNAME VARCHAR(200),
	ageing varchar(1)
)

set @debit_amt_030 =0 --debit amt for slab 1 days
set @debit_amt_3160 =0 --debit amt for slab 2 days
set @debit_amt_6190 =0 --debit amt for slab 3 days
set @debit_amt_91120 =0 --debit amt for slab 4 days
set @debit_amt_121180 =0 --debit amt for >slab 4 days
set @debit_amt_181 =0 --debit amt for >slab 4 days
set @debit_amt_cur =0 --debit amt for >current
set @bill_pending_amt =0
set @rcpt_pending_amt =0 --pending receipt amount
-- cursor cur_agency variables

declare @rec_agency_comp_code as varchar(30)
declare @rec_agency_agcd as varchar(20)
declare @rec_agency_dpcd as varchar(30)
declare @rec_agency_agency_name as varchar(300)
declare @rec_agency_city_code as varchar(200)
declare @rec_agency_city_name as varchar(200)
declare @rec_agency_credit_days as int
declare @rec_agency_branch_name as varchar(50)
declare @rec_agency_ageing_type as varchar(1)
--@rec_agency_comp_code,@rec_agency_agcd,@rec_agency_dpcd,@rec_agency_agency_name,@rec_agency_city_code,@rec_agency_city_name,

--@rec_agency_credit_days,@rec_agency_branch_name,@rec_agency_ageing_type

declare cur_agency_1 cursor for
select m.Comp_Code ,m.agcd ,m.dpcd ,m.ag_name ,m.City_Code,c.city_name,m.credit_days,m.branch_code,m.ageing_type
from cir_agmast m,cir_city_mast c
where m.comp_code=c.comp_code and m.comp_code=@pcomp_code
and m.unit=@punit_code and m.city_code=c.city_code
and (m.Dist_Code=@pdist_code or @pdist_code is null or @pdist_code ='')
and (m.tehsil_taluka=@ptaluka_code or @ptaluka_code is null or @ptaluka_code ='')
and (m.agcd=@pag_main_code or @pag_main_code is null or @pag_main_code ='')
and (m.dpcd=@pag_sub_code or @pag_sub_code is null or @pag_sub_code ='')

if @pdebitupto_date is null or @pdebitupto_date=''
begin
	set @pdebitupto_date =@pasondt
end
if @pcreditupto_date is null or @pcreditupto_date=''
begin
	set @pcreditupto_date =@pasondt
end
if @pasondt is null or @pasondt =''
begin
	set @pasondt=@pcreditupto_date
end

declare @fetch_protype as varchar(20)
declare @fetch_pub as varchar(20)
-- cursor v_bill variables

declare @v_bill_billno as varchar(50)
declare @v_bill_billdt as varchar(30)
declare @v_bill_bill_amt as numeric(15,2)
-- cursor v_pending_rcpt variables

declare @v_pending_rcpt_ag_main_code as varchar(30)
declare @v_pending_rcpt_ag_sub_code as varchar(50)
declare @v_pending_rcpt_amount as numeric(15,2)
declare @fetch_pubname as varchar(200)
declare @fetch_pubtype as varchar(200)
--SELECT 'cursor has ' + CAST(@@CURSOR_ROWS AS VARCHAR) + ' rows'

declare @v_mcnt1 as datetime
declare @v_mcnt2 as datetime
declare @v_mcnt3 as datetime
declare @v_mcnt4 as datetime
declare @v_mcnt5 as datetime
declare @vtill_days1 AS int
declare @vtill_days2 AS int
declare @vtill_days3 AS int
declare @vtill_days4 AS int
declare @vtill_days5 AS int
declare @vrec_agency_ageing_type as varchar(10)

	open cur_agency_1
		fetch NEXT FROM cur_agency_1 INTO @rec_agency_comp_code,@rec_agency_agcd,@rec_agency_dpcd,@rec_agency_agency_name,@rec_agency_city_code,@rec_agency_city_name,@rec_agency_credit_days,@rec_agency_branch_name,@rec_agency_ageing_type
		WHILE (@@FETCH_STATUS = 0)
		begin
			declare @day as int
			
			declare cur_agency cursor for
			select distinct publ from cir_supply where comp_code=@pcomp_code and agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd order by publ
			--select distinct dbo.cir_get_publ_type(comp_code,publ,'C','') publ from cir_supply where comp_code=@pcomp_code and agcd=@pag_main_code and dpcd=@pag_sub_code order by publ
			print
			('@rec_agency_ageing_type')print(@rec_agency_ageing_type)
			open cur_agency
				fetch NEXT FROM cur_agency INTO @fetch_pub
				WHILE (@@FETCH_STATUS = 0)
				BEGIN 
					print('dddddd') print(@fetch_pub)
					
					select distinct @fetch_protype=pro_type,@fetch_pubname=PUBL_NAME,@fetch_pubtype=
					(Select pubname from pub_type_mast where Comp_Code=@pcomp_code and pub_type_mast.pubtypecode=CIR_PUBL_MAST.PRO_TYPE)
					from CIR_PUBL_MAST where COMP_CODE=@pcomp_code and publ=@fetch_pub					
					
					print('@fetch_protype')print(@fetch_protype)
					print('@@fetch_pubname')print(@fetch_pubname)
					print('@fetch_pubtype')print(@fetch_pubtype)
					
					if @fetch_protype ='MA0'
					begin
						set @vrec_agency_ageing_type='M'
					end
					else
					begin
						set @vrec_agency_ageing_type=@rec_agency_ageing_type
					end
					select @ptill_days1=SLAB_TILL1,@ptill_days2=SLAB_TILL2,@ptill_days3=SLAB_TILL3,@ptill_days4=SLAB_TILL4
					,@ptill_days5=SLAB_TILL5,@ptill_days6=SLAB_TILL6--,@rec_agency_ageing_type=AGEING_TYPE
					from CIR_AGEING_SLAB_MAST
					where COMP_CODE=@pcomp_code and PRO_TYPE=@fetch_protype
					
					print ('slab')print(@ptill_days1)print(@ptill_days2)print(@ptill_days3)print(@ptill_days4)print(@ptill_days5)
					print (@ptill_days6)print(@rec_agency_ageing_type)
					print ('gaurav')
					print (@vrec_agency_ageing_type)
					print (@pasondt)
					print (dbo.GetLastDayOfMonth(@pasondt))
					print ('debug')
					
					if upper(@vrec_agency_ageing_type) = 'D'
					begin
						set @vtodt=dateadd(dd,-1,@pasondt)
					end
					else if upper(@vrec_agency_ageing_type) = 'W'
					begin
						select @day=DATEPART(dw,@pasondt)
						print(@day)
						set @vtodt=dateadd(dd,-(@day-1),@pasondt)
					end
					else
					begin
						if dbo.GetLastDayOfMonth(@pasondt)=@pasondt
						begin
							set @vtodt=@pasondt
						end
						else
						begin
							set @vtodt=dbo.GetLastDayOfMonth(dateadd(mm,-1,@pasondt))
						end
					end
					print('come') print(@vrec_agency_ageing_type)
					print(@vtodt)
					print('custom')print(@ptill_days1)print(@ptill_days2)print(@ptill_days3)print(@ptill_days4)print(@ptill_days5)

					if @vrec_agency_ageing_type='M' begin print('gks')
						set @v_mcnt1=DATEADD(MM,-1*@ptill_days1,@vtodt+1)
						set @v_mcnt2=DATEADD(MM,-1*@ptill_days2,@vtodt+1)
						set @v_mcnt3=DATEADD(MM,-1*@ptill_days3,@vtodt+1)
						set @v_mcnt4=DATEADD(MM,-1*@ptill_days4,@vtodt+1)
						set @v_mcnt5=DATEADD(MM,-1*@ptill_days5,@vtodt+1)
						--DATEDIFF(dd, dbo.GetFirstDayOfMonth( @vtodt),@vtodt )+1
						set @vtill_days1=DATEDIFF(dd, dbo.GetFirstDayOfMonth( @v_mcnt1),@vtodt )+1
						set @vtill_days2=DATEDIFF(dd, dbo.GetFirstDayOfMonth( @v_mcnt2),@vtodt )+1
						set @vtill_days3=DATEDIFF(dd, dbo.GetFirstDayOfMonth( @v_mcnt3),@vtodt )+1
						set @vtill_days4=DATEDIFF(dd, dbo.GetFirstDayOfMonth( @v_mcnt4),@vtodt )+1
						set @vtill_days5=DATEDIFF(dd, dbo.GetFirstDayOfMonth( @v_mcnt5),@vtodt )+1
					end
					else if @vrec_agency_ageing_type='W'  
					begin print('weekly')
						--@vtodt
						set @v_mcnt1=DATEADD(ww,-1*@ptill_days1,@vtodt+1)
						set @v_mcnt2=DATEADD(ww,-1*@ptill_days2,@vtodt+1)
						set @v_mcnt3=DATEADD(ww,-1*@ptill_days3,@vtodt+1)
						set @v_mcnt4=DATEADD(ww,-1*@ptill_days4,@vtodt+1)
						set @v_mcnt5=DATEADD(ww,-1*@ptill_days5,@vtodt+1)
						
						set @vtill_days1=DATEDIFF(dd, @v_mcnt1,@vtodt )+1
						set @vtill_days2=DATEDIFF(dd, @v_mcnt2,@vtodt )+1
						set @vtill_days3=DATEDIFF(dd, @v_mcnt3,@vtodt )+1
						set @vtill_days4=DATEDIFF(dd, @v_mcnt4,@vtodt )+1
						set @vtill_days5=DATEDIFF(dd, @v_mcnt5,@vtodt )+1
					end
					else
					begin
						set @vtill_days1=@ptill_days1
						set @vtill_days2=@ptill_days2
						set @vtill_days3=@ptill_days3
						set @vtill_days4=@ptill_days4
						set @vtill_days5=@ptill_days5
					end
					print ('custom1')print(@vtill_days1)print(@vtill_days2)print(@vtill_days3)print(@vtill_days4)print(@vtill_days5)
					print @rec_agency_dpcd
					set @debit_amt_030 = 0;
					set @debit_amt_3160 = 0;
					set @debit_amt_6190 = 0;
					set @debit_amt_91120 = 0;
					set @debit_amt_121180 = 0;
					set @debit_amt_181 = 0;
					set @rcpt_pending_amt = 0;
					set @bill_pending_amt = 0;
					print('enter first')
					
					declare c_bill cursor for
					select distinct billno,billdt,sum(amount) bill_amt from cir_outmast
					where comp_code=@pcomp_code and unit_code=@punit_code and
					agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
					billdt <=@vtodt and isnull(abs(amount),0)>0
					group by comp_code,billno,billdt having sum(amount)>0
					union all
					select distinct recptno billno,recptdt billdt,sum(amount) bill_amt from cir_outmast
					where comp_code=@pcomp_code and unit_code=@punit_code and
					agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
					recptdt <=@vtodt and isnull(amount,0)>0 and billno is null
					group by comp_code,recptno,recptdt order by 2,1
--having sum(amount)<0
					open c_bill
					fetch NEXT FROM c_bill INTO @v_bill_billno,@v_bill_billdt,@v_bill_bill_amt
						WHILE (@@FETCH_STATUS = 0)
						begin
							print('enter second')
							
							set @v_dt = @v_bill_billdt
							set @v_ondt = @vtodt
							print(@v_dt)
							print(@v_ondt)
							
							if @paging_by='D' begin
								set @v_days=DATEDIFF(dd, @v_dt,@v_ondt )---isnull(pcrdtday,0)+1;
							end
							else
							begin
								set @v_days=DATEDIFF(dd, @v_dt,@v_ondt )+1;
							end
							if @v_days<0 begin
								set @v_days=0;
							end
							print('x')
							print(@v_days)
							set @v_amt =0;
							set @v_amt030 =0;
							set @v_amt3160 =0;
							set @v_amt6190 =0;
							set @v_amt91120 =0;
							set @v_amt121180 =0;
							set @v_amt181 =0;
							
							if @v_days between 0 and @vtill_days1 
							begin
								select @v_amt030=sum(amount) from cir_outmast
								where comp_code=@pcomp_code and unit_code=@punit_code and
								agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
								billno =@v_bill_billno and billdt=@v_bill_billdt and
								recptdt <=@vasondt and amount<0
								set @v_amt030 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt030,0);
								set @debit_amt_030 =isnull(@debit_amt_030,0)+isnull(@v_amt030,0)
							end
							else if @v_days between isnull(@vtill_days1,0)+1 and @vtill_days2 
							begin
								select @v_amt3160=sum(amount) from cir_outmast
								where comp_code=@pcomp_code and unit_code=@punit_code and
								agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
								billno =@v_bill_billno and billdt=@v_bill_billdt and
								recptdt <=@vasondt and amount<0
							--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
								set @v_amt3160 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt3160,0);
								set @debit_amt_3160 =isnull(@debit_amt_3160,0)+isnull(@v_amt3160,0)
							end
							else if @v_days between isnull(@vtill_days2,0)+1 and @vtill_days3 
							begin
								select @v_amt6190=sum(amount) from cir_outmast
								where comp_code=@pcomp_code and unit_code=@punit_code and
								agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
								billno =@v_bill_billno and billdt=@v_bill_billdt and
								recptdt <=@vasondt and amount<0
							--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
								set @v_amt6190 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt6190,0);
								set @debit_amt_6190 =isnull(@debit_amt_6190,0)+isnull(@v_amt6190,0)
							end
							else if @v_days between isnull(@vtill_days3,0)+1 and @vtill_days4 
							begin
								select @v_amt91120=sum(amount) from cir_outmast
								where comp_code=@pcomp_code and unit_code=@punit_code and
								agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
								billno =@v_bill_billno and billdt=@v_bill_billdt and
								recptdt <=@vasondt and amount<0
							--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
								set @v_amt91120 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt91120,0);
								set @debit_amt_91120 =isnull(@debit_amt_91120,0)+isnull(@v_amt91120,0)
							end
							else if @v_days between isnull(@vtill_days4,0)+1 and @vtill_days5 
							begin
								select @v_amt121180=sum(amount) from cir_outmast
								where comp_code=@pcomp_code and unit_code=@punit_code and
								agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
								billno =@v_bill_billno and billdt=@v_bill_billdt and
								recptdt <=@vasondt and amount<0
							--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
								set @v_amt121180 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt121180,0);
								set @debit_amt_121180 =isnull(@debit_amt_121180,0)+isnull(@v_amt121180,0)
							end
							else
							begin
								select @v_amt181=sum(amount) from cir_outmast
								where comp_code=@pcomp_code and unit_code=@punit_code and
								agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
								billno =@v_bill_billno and billdt=@v_bill_billdt and
								recptdt <=@vasondt and amount<0
								--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
								set @v_amt181 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt181,0);
								set @debit_amt_181 =isnull(@debit_amt_181,0)+isnull(@v_amt181,0)
							end
					fetch NEXT FROM c_bill INTO @v_bill_billno,@v_bill_billdt,@v_bill_bill_amt
					end
				close c_bill
				deallocate c_bill

			declare @cur_from_dt as datetime
			print('t')
			print(@punit_code)
			print(@fetch_pub)
			set @cur_from_dt= dateadd(dd,1,@vtodt)
			print(@cur_from_dt)
			print(@pasondt)
			print('W')
			
			select @v_amtcur=sum(amount) from cir_outmast
			where comp_code=@pcomp_code and unit_code=@punit_code and
			agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
			billdt between @cur_from_dt and @pasondt
			--and RECPTNO is null and RECPTDT is null
			print(@fetch_pub)print(@cur_from_dt)print(@pasondt) 
			--and recptdt<=@pasondt and amount<0
			
			
		
			set @v_amt=isnull(@v_amtcur,0)+ isnull(@debit_amt_030,0)+isnull(@debit_amt_3160,0)+isnull(@debit_amt_6190,0)+isnull(@debit_amt_91120,0)+isnull(@debit_amt_121180,0)+isnull(@debit_amt_181,0)
			print('@v_amt amount here')print(@v_amt)print('@@v_amt')
			if @v_amt=0 
			begin
				set @debit_amt_030 = 0
				set @debit_amt_3160 = 0
				set @debit_amt_6190 = 0
				set @debit_amt_91120 = 0
				set @debit_amt_121180 = 0
				set @debit_amt_181 = 0				
			end
			else
			begin				
				set @bill_pending_amt=isnull(@v_amt,0)
			end
			print('zzz')
		
			insert into #cir_temp_ageing (comp_code,unit_code,agcd,dpcd,ag_name,city_name,pending_amt,CUR_AMT
			, SLAB_1 ,slab_2,slab_3,slab_4,slab_5,slab_6,rect_pending,on_acamt,sessionid,PUBNAME,ageing)
			values (@rec_agency_comp_code,@punit_code,@rec_agency_agcd, @rec_agency_dpcd, @fetch_protype,
			@fetch_pubname	,isnull(@bill_pending_amt,0),isnull(@v_amtcur,0)
			,isnull(@debit_amt_030,0),isnull(@debit_amt_3160,0), isnull(@debit_amt_6190,0)
			,isnull(@debit_amt_91120,0), isnull(@debit_amt_121180,0), isnull(@debit_amt_181,0),
			isnull(0,0),0,@@spid,@fetch_pubtype,@rec_agency_ageing_type);
			print('xxx')
			fetch NEXT FROM cur_agency INTO @fetch_pub
			set @debit_amt_030 = 0
			set @debit_amt_3160 = 0
			set @debit_amt_6190 = 0
			set @debit_amt_91120 = 0
			set @debit_amt_121180 = 0
			set @debit_amt_181 = 0
			set @rcpt_pending_amt = 0
			set @bill_pending_amt = 0
		end
		close cur_agency;
	deallocate cur_agency
	
			select @v_pending_rcpt_amt=sum(amount) from cir_outmast
			where comp_code=@pcomp_code and unit_code=@punit_code and
			agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd 
			and BILLDT is null and BILLNO is null 			
			
			print('receipt amount here')print(@v_pending_rcpt_amt)print('@v_pending_rcpt_amt')
		
			

			insert into #cir_temp_ageing (comp_code,unit_code,agcd,dpcd,ag_name,city_name,pending_amt,CUR_AMT
			, SLAB_1 ,slab_2,slab_3,slab_4,slab_5,slab_6,rect_pending,on_acamt,sessionid,PUBNAME,ageing)
			values (@rec_agency_comp_code,@punit_code,@rec_agency_agcd, @rec_agency_dpcd, @fetch_protype,
			null	,isnull(0,0),isnull(0,0)
			,isnull(0,0),isnull(0,0), isnull(0,0)
			,isnull(0,0), isnull(0,0), isnull(0,0),
			isnull(@v_pending_rcpt_amt,0),0,@@spid,@fetch_pubtype,@rec_agency_ageing_type);


fetch NEXT FROM cur_agency_1 INTO @rec_agency_comp_code,@rec_agency_agcd,@rec_agency_dpcd,@rec_agency_agency_name,@rec_agency_city_code,@rec_agency_city_name,@rec_agency_credit_days,@rec_agency_branch_name,@rec_agency_ageing_type
end 
close cur_agency_1
deallocate cur_agency_1

--5select * from #cir_temp_ageing

if(@pextra1='CREDIT') 
begin
	select comp_code,unit_code,agcd,dpcd,ag_name PRO_TYPE,PUBNAME--,city_name PUBL_NAME
	,(sum(isnull(pending_amt,0)) - abs(max(ISNULL(rect_pending,0)) ) )  pending_amt,sum(isnull(cur_amt,0)) cur_amt,sum(isnull(slab_1,0)) slab_1,sum(isnull(slab_2,0)) slab_2
	,sum(isnull(slab_3,0)) slab_3,sum(isnull(slab_4,0)) slab_4,sum(isnull(slab_5,0)) slab_5,sum(isnull(slab_6,0)) slab_6,sum(isnull(rect_pending,0)) rect_pending
	,ageing
	from #cir_temp_ageing group by #cir_temp_ageing.COMP_CODE,#cir_temp_ageing.UNIT_CODE,#cir_temp_ageing.AGCD,#cir_temp_ageing.DPCD
	,#cir_temp_ageing.AG_NAME,PUBNAME,ageing
	order by PUBNAME;
end
else 
begin

	select comp_code,unit_code,agcd,dpcd,ag_name PRO_TYPE,PUBNAME--,city_name PUBL_NAME
	--,(sum(isnull(pending_amt,0)) - abs(max(ISNULL(rect_pending,0)) ) )  pending_amt
	,sum( isnull(pending_amt,0) ) - ISNULL(max(abs(rect_pending)),0)  pending_amt
	,sum(isnull(cur_amt,0)) cur_amt,sum(isnull(slab_1,0)) slab_1,sum(isnull(slab_2,0)) slab_2
	,sum(isnull(slab_3,0)) slab_3,sum(isnull(slab_4,0)) slab_4,sum(isnull(slab_5,0)) slab_5,sum(isnull(slab_6,0)) slab_6,sum(isnull(rect_pending,0)) rect_pending
	,ageing
	from #cir_temp_ageing group by #cir_temp_ageing.COMP_CODE,#cir_temp_ageing.UNIT_CODE,#cir_temp_ageing.AGCD,#cir_temp_ageing.DPCD
	,#cir_temp_ageing.AG_NAME,PUBNAME,ageing
	order by PUBNAME;

	select SUM(abs(isnull(amount,0))) as SEC_ONDT from CIR_RCPHDR where COMP_CODE=@pcomp_code
	and (UNIT_CODE=@punit_code or @punit_code is null or @punit_code ='')
	and (AGCD=@pag_main_code or @pag_main_code is null or @pag_main_code ='')
	and (DPCD=@pag_sub_code or @pag_sub_code is null or @pag_sub_code ='')
	and ACHD='SC'
	group by comp_code,unit_code,agcd,dpcd


	select SUM(abs(isnull(bg_amt,0))) as BG_ONDT from CIR_BANK_GUARANTEE where COMP_CODE=@pcomp_code
	and(UNIT_CODE=@punit_code or @punit_code is null or @punit_code ='')
	and(AGCD=@pag_main_code or @pag_main_code is null or @pag_main_code ='')
	and(DPCD=@pag_sub_code or @pag_sub_code is null or @pag_sub_code ='')
	group by comp_code,unit_code,agcd,dpcd
	drop table #cir_temp_ageing
end






/////////////////////////////////////////////ADD BY DEEPIKA 05-FEN-2013//////////////////////////////





ALTER PROCEDURE  [dbo].[Cir_Comm_Bind]
  @pcompcode as varchar(200),
  @punitcode as varchar(200),
  @ppublcode as varchar(200),
  @pedtncode as varchar(200),
  @pcommty as varchar(200),
  @pdateformat as varchar(200),
  @pextra1 as varchar(200),
  @pextra2 as varchar(200)

 AS
  	select distinct B.COMM_CATG_CODE COMM_CODE,B.COMM_CATG_DESC
                               from cir_comm_mast a,cir_comm_catg_mast b
                                   where a.comp_code=b.comp_code and
                                         a.comm_catg_code=b.comm_catg_code and
                                         a.comp_code=@pcompcode and
                                         ((case(isnull(@pextra1,'S'))
		                                  WHEN 'A' THEN @punitcode
		                                  ELSE a.UNIT_CODE END)= @punitcode  or @punitcode is null or @punitcode='')
                                         --a.unit_code=@punitcode 
                                         and a.publ=@ppublcode and
                                        -- a.edtn	=@pedtncode and
                                         a.comm_type=@pcommty and 
                                         	ISNULL(a.freeze_flag,'N')='N' and
                                          	ISNULL(b.freeze_flag,'N')='N'




///////////////////////////////////////////////////////////////////////////////////////////////////////////////





ALTER procedure [dbo].[cir_get_pubedtn]
(
@pcomp_code varchar(200),
@punit_code varchar(200)
)
as
begin
SELECT X.* FROM(
SELECT  COMP_CODE,UNIT_CODE,PUBL,DBO.CIR_GET_PUBL_NAME(COMP_CODE,PUBL) PUBL_NAME,ISNULL(MAIN_EDTN,EDTN) MAIN_EDTN ,
DBO.CIR_GET_EDTN_NAME(COMP_CODE,ISNULL(MAIN_EDTN,EDTN)) MAIN_EDTN_NAME,
EDTN,
NULL SUB_EDTN_NAME
,isnull(EDTN_FOR_UNIT,'S')EDTN_FOR_UNIT
 FROM CIR_EDTN_MAST  
WHERE EDTN_TY='M' AND COMP_CODE=@pcomp_code  
AND
		((case(isnull(EDTN_FOR_UNIT,'S'))
		WHEN 'A' THEN @punit_code
		ELSE UNIT_CODE END)= @punit_code  or @punit_code is null or @punit_code='')
        --(UNIT_CODE=@punit_code or @punit_code is null or @punit_code='')
      
UNION ALL
SELECT  COMP_CODE,UNIT_CODE,PUBL,DBO.CIR_GET_PUBL_NAME(COMP_CODE,PUBL) PUBL_NAME,ISNULL(MAIN_EDTN,EDTN) MAIN_EDTN,
DBO.CIR_GET_EDTN_NAME(COMP_CODE,ISNULL(MAIN_EDTN,EDTN)) MAIN_EDTN_NAME,
EDTN,
 EDTN_NAME SUB_EDTN_NAME
 ,isnull(EDTN_FOR_UNIT,'S')EDTN_FOR_UNIT
  FROM CIR_EDTN_MAST  
 WHERE EDTN_TY='S'  AND COMP_CODE=@pcomp_code AND
 ((case(isnull(EDTN_FOR_UNIT,'S'))
		WHEN 'A' THEN @punit_code
		ELSE UNIT_CODE END)= @punit_code  or @punit_code is null or @punit_code='')
        --(UNIT_CODE=@punit_code or @punit_code is null or @punit_code='')
)X 


WHERE SUB_EDTN_NAME IS NOT NULL 
and x.publ in( select distinct a.publ from cir_comm_mast a,cir_comm_catg_mast b
where a.comp_code=b.comp_code and a.comm_catg_code=b.comm_catg_code and a.comp_code=@pcomp_code and

((case(isnull(X.EDTN_FOR_UNIT,'S'))
		WHEN 'A' THEN @punit_code
		ELSE a.UNIT_CODE END)= @punit_code  or @punit_code is null or @punit_code='')
--a.unit_code=@punit_code 


and a.comm_type='F' and 
ISNULL(a.freeze_flag,'N')='N' and ISNULL(b.freeze_flag,'N')='N' )
and x.edtn in( select distinct a.EDTN from cir_comm_mast a,cir_comm_catg_mast b
where a.comp_code=b.comp_code and a.comm_catg_code=b.comm_catg_code and a.comp_code=@pcomp_code and

((case(isnull(X.EDTN_FOR_UNIT,'S'))
		WHEN 'A' THEN @punit_code
		ELSE a.UNIT_CODE END)= @punit_code  or @punit_code is null or @punit_code='')
--a.unit_code=@punit_code 

and a.comm_type='F' and 
ISNULL(a.freeze_flag,'N')='N' and ISNULL(b.freeze_flag,'N')='N' )
ORDER BY COMP_CODE,UNIT_CODE,PUBL,EDTN
end 


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


ALTER PROCEDURE [dbo].[cir_agency_bind_cir_agency_bind_p]
	@pcompcode			VARCHAR(20) ,
	@punit              VARCHAR(20) ,
	@pdateformat        VARCHAR(20) ,
    @pdistcode          VARCHAR(20)=null,  
	@pextra1            VARCHAR(4000) ,
	@pextra2            VARCHAR(4000) 
AS 
DECLARE @vSHOW_ALL_UNIT varchar(1) ;  
BEGIN

    select @vSHOW_ALL_UNIT=CIR_ALL_UNIT from preferrences where comp_code=@pcompcode
	If UPPER(@pextra2)='D' Begin
			
		SELECT cir_agmast_dis.*,dbo.cir_get_city(cir_agmast_dis.comp_code,cir_agmast_dis.city_code) "CITY_NAME",
		dbo.cir_get_agency(cir_agmast_dis.comp_code,cir_agmast_dis.unit,cir_agmast_dis.BILL_AGCD,cir_agmast_dis.BILL_AGCD) "BILL_AGENCY",
		dbo.cir_get_agency_city(cir_agmast_dis.comp_code,cir_agmast_dis.unit,cir_agmast_dis.agcd,cir_agmast_dis.dpcd) "BILL_AGENCY_CITY",
		dbo.cir_get_drop_point_name(cir_agmast_dis.comp_code,cir_agmast_dis.unit,cir_agmast_dis.station_code,1) as "DROP_POINT_NAME"
		FROM  cir_agmast_dis 
		WHERE comp_code  = @pcompcode 
		AND
			((case isnull(@vSHOW_ALL_UNIT,'N')
		WHEN 'Y' THEN @punit
		ELSE unit END)= @punit  or @punit is null or @punit='')
		
		 and (dist_code =@pdistcode or @pdistcode is null or @pdistcode ='')
		 AND ((UPPER(ag_name)  like UPPER(CAST(@pextra1 AS VARCHAR) + '%')) OR	(@pextra1  is null) OR	(@pextra1  = ''))
		 /*AND ISNULL(freeze_flag, 'N')  = 'N'*/
		union
		SELECT cir_agmast_dis.*,dbo.cir_get_city(cir_agmast_dis.comp_code,cir_agmast_dis.city_code) "CITY_NAME",
		dbo.cir_get_agency(cir_agmast_dis.comp_code,cir_agmast_dis.unit,cir_agmast_dis.BILL_AGCD,cir_agmast_dis.BILL_AGCD) "BILL_AGENCY",
		dbo.cir_get_agency_city(cir_agmast_dis.comp_code,cir_agmast_dis.unit,cir_agmast_dis.agcd,cir_agmast_dis.dpcd) "BILL_AGENCY_CITY",
		dbo.cir_get_drop_point_name(cir_agmast_dis.comp_code,cir_agmast_dis.unit,cir_agmast_dis.station_code,1) as "DROP_POINT_NAME"
		FROM  cir_agmast_dis 
		WHERE comp_code  = @pcompcode 
		AND 
			((case isnull(@vSHOW_ALL_UNIT,'N')
		WHEN 'Y' THEN @punit
		ELSE unit    END)= @punit  or @punit is null or @punit='')
		
		and(dist_code =@pdistcode or @pdistcode is null or @pdistcode ='')
		 AND ((UPPER(ag_name)  like UPPER(CAST(@pextra1 AS VARCHAR) + '%')) OR	(@pextra1  is null) OR	(@pextra1  = ''))
		 /*AND ISNULL(freeze_flag, 'N')  = 'N'*/
		ORDER BY 5
	End
	Else Begin
		SELECT cir_agmast.*,dbo.cir_get_city(cir_agmast.comp_code,cir_agmast.city_code) "CITY_NAME",
		dbo.cir_get_agency(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.BILL_AGCD,cir_agmast.BILL_DPCD) "BILL_AGENCY",
		dbo.cir_get_agency_city(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.agcd,cir_agmast.dpcd) "BILL_AGENCY_CITY",
		dbo.cir_get_drop_point_name(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.station_code,1) as "DROP_POINT_NAME"
			FROM  cir_agmast 
			WHERE comp_code  = @pcompcode AND 
				((case isnull(@vSHOW_ALL_UNIT,'N')
		WHEN 'Y' THEN @punit
		ELSE unit    END)= @punit  or @punit is null or @punit='')
			and(dist_code =@pdistcode or @pdistcode is null or @pdistcode ='')
			 AND ((UPPER(ag_name)  like UPPER(CAST(@pextra1 AS VARCHAR) + '%')) OR	(@pextra1  is null) OR	(@pextra1  = ''))
			 /*AND ISNULL(freeze_flag, 'N')  = 'N'*/
		union
		SELECT cir_agmast.*,dbo.cir_get_city(cir_agmast.comp_code,cir_agmast.city_code) "CITY_NAME",
		dbo.cir_get_agency(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.BILL_AGCD,cir_agmast.BILL_DPCD) "BILL_AGENCY",
		dbo.cir_get_agency_city(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.agcd,cir_agmast.dpcd) "BILL_AGENCY_CITY",
		dbo.cir_get_drop_point_name(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.station_code,1) as "DROP_POINT_NAME"
			FROM  cir_agmast 
			WHERE comp_code  = @pcompcode AND 
				((case isnull(@vSHOW_ALL_UNIT,'N')
		WHEN 'Y' THEN @punit
		ELSE unit    END)= @punit  or @punit is null or @punit='')
		
			and(dist_code =@pdistcode or @pdistcode is null or @pdistcode ='')
			 AND ((UPPER(agcd)  like UPPER(CAST(@pextra1 AS VARCHAR) + '%')) OR	(@pextra1  is null) OR	(@pextra1  = ''))
			 /*AND ISNULL(freeze_flag, 'N')  = 'N'*/			 
			ORDER BY 5
	End
END






///////////////////////////////////////////////////END///////////////////////////////////////////////////////////


//====================================ADD BY DEEPIKA SENT BY gAURAV SIR 05-FEB-2013======================



ALTER procedure [dbo].[CIR_RECEIPT_DATA_MOVE]
    @pcompcode       as varchar(200),
    @punitcode       as varchar(200),
    @pdoctype        as varchar(200),
    @precptdt        as varchar(200),
    @precptno        as varchar(200),
    @pdateformate    as varchar(200),
    @puserid         as varchar(200),
    @prectype        as varchar(200),--it is for agency receipt or distraibution receipt
    @pextra1         as varchar(200),
    @pextra2         as varchar(200),
    @pextra3         as varchar(200),
    @pextra4         as varchar(200),
    @pextra5         as varchar(200)
as
declare @v_recno numeric(10)
declare @v_dt    datetime
begin
    set @v_dt=dbo.convert_user_date('/', @precptdt,@pdateformate)
    
    if upper(@prectype)='D' Begin
        insert into cir_rcphdr_dis(comp_code,unit_code,doctype,agcd,dpcd,recptno,
            recptdt,chno,chdt,chbank,amount,oth_amount,ccdp,ccds,rcdp,rcds,ocdp,ocds,reason,
            remark,achd,voucherno,voucherdt,vchtype,publ,received_from,tdsrate,tdsamt,staxrate,
              staxamt,status,ref_recptno,ref_recptdt,ref_amount,ref_doctype,cancel_user,cancel_datetime,
              cancel_remark,userid,creation_datetime,branch_code,prov_rec_no,prov_rec_dt,remark_oth,MANNUALRECPTNO)
          select comp_code,unit_code,doctype,agcd,dpcd,recptno,
          recptdt,chno,
          CASE chdt WHEN '1900-01-01 00:00:00.000' THEN NULL else chdt END chdt,
          chbank,amount,oth_amount,ccdp,ccds,rcdp,rcds,ocdp,ocds,reason,
          remark,achd,voucherno,voucherdt,vchtype,publ,received_from,tdsrate,tdsamt,staxrate,
          staxamt,status,ref_recptno,
          CASE ref_recptdt WHEN '1900-01-01 00:00:00.000' THEN NULL else ref_recptdt END ref_recptdt,
          ref_amount,ref_doctype,cancel_user,cancel_date,
          cancel_remark,userid,creation_date,branch_code,prov_rec_no,
          CASE prov_rec_dt WHEN '1900-01-01 00:00:00.000' THEN NULL else prov_rec_dt END prov_rec_dt,
          remark_oth,MANNUALRECPTNO from cir_rcphdr_dis_temp
            where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
                    recptno=@precptno and recptdt=@v_dt
      
      delete from CIR_RCPHDR_DIS_TEMP where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
                    recptno=@precptno and recptdt=@v_dt
      
          insert into cir_rcpdet_dis(comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, recptno, recptdt, 
                            payfor, achd, publ, chno, chbnk, chdt, amount, reason, remark, voucherno, voucherdt, 
                            tds, stax, status, usrid, creation_datetime, branch_code)
          select comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, recptno, recptdt, 
                            payfor, achd, publ, chno, chbnk, 
                            CASE chdt WHEN '1900-01-01 00:00:00.000' THEN NULL else chdt END chdt, 
                            amount, reason, remark, voucherno, voucherdt, 
                            tds, stax, status, usrid, creation_date, branch_code from cir_rcpdet_dis_temp
            where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and 
                    recptno=@precptno and recptdt=@v_dt

		delete from cir_rcpdet_dis_temp
            where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and 
                    recptno=@precptno and recptdt=@v_dt

        insert into cir_outmast_dis (comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, recptno, recptdt, 
                        achd, publ, chno, chbnk, chdt, amount, reason, remark, voucherno, voucherdt, balance, 
                        tds, stax, status, cancel_userid, cancel_dt, cancel_remark, usrid, creation_datetime, bill_sec_amt, branch_code)
        select comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, recptno, recptdt, 
                        achd, publ, chno, chbnk, 
                        CASE chdt WHEN '1900-01-01 00:00:00.000' THEN NULL else chdt END chdt, 
                        amount, reason, remark, voucherno, voucherdt, balance, 
                        tds, stax, status, cancel_userid, cancel_dt, cancel_remark, usrid, creation_date, bill_sec_amt, branch_code from cir_outmast_dis_temp
             where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and 
                    recptno=@precptno and recptdt=@v_dt
		
		 delete from cir_outmast_dis_temp
             where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and 
                    recptno=@precptno and recptdt=@v_dt
		
			select @v_recno=count(*) from cir_rcpt_document_dis_temp
			where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
						recptno=@precptno and recptdt=@v_dt
			If @v_recno>0 Begin		                    
				insert into cir_rcpt_document_dis(comp_code, unit_code, doctype, recptno, recptdt, filename, created_by, created_dt)
				select comp_code, unit_code, doctype, recptno, recptdt, filename, created_by, created_dt from cir_rcpt_document_dis_temp
				where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
							recptno=@precptno and recptdt=@v_dt
			End

			
			insert into cir_rcp_unadj_dis(comp_code,unit_code,agcd,dpcd,doctyp,recptno,recptdt,publ,amount,created_by,created_date,updated_by,updated_date)
			select comp_code,unit_code,agcd,dpcd,doctyp,recptno,recptdt,publ,amount,created_by,created_date,updated_by,updated_date from cir_rcp_unadj_temp_dis
			where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and recptno=@precptno
			
			delete from cir_rcp_unadj_temp_dis
			where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and recptno=@precptno
			
		End
    else Begin
        insert into cir_rcphdr(comp_code,unit_code,doctype,agcd,dpcd,recptno,
            recptdt,chno,chdt,chbank,amount,oth_amount,ccdp,ccds,rcdp,rcds,ocdp,ocds,reason,
            remark,achd,voucherno,voucherdt,vchtype,publ,received_from,tdsrate,tdsamt,staxrate,
              staxamt,status,ref_recptno,
              ref_recptdt,
              ref_amount,ref_doctype,cancel_user,cancel_date,
              cancel_remark,userid,creation_date,branch_code,prov_rec_no,prov_rec_dt,remark_oth,MANNUALRECPTNO)
          select comp_code,unit_code,doctype,agcd,dpcd,recptno,
          recptdt,chno,
          CASE chdt WHEN '1900-01-01 00:00:00.000' THEN NULL else chdt END chdt,
          chbank,amount,oth_amount,ccdp,ccds,rcdp,rcds,ocdp,ocds,reason,
          remark,achd,voucherno,voucherdt,vchtype,publ,received_from,tdsrate,tdsamt,staxrate,
          staxamt,status,ref_recptno,
          CASE ref_recptdt WHEN '1900-01-01 00:00:00.000' THEN NULL else ref_recptdt END  ref_recptdt,
          ref_amount,ref_doctype,cancel_user,cancel_date,
          cancel_remark,userid,creation_date,branch_code,prov_rec_no,
          CASE prov_rec_dt WHEN '1900-01-01 00:00:00.000' THEN NULL else prov_rec_dt END prov_rec_dt,remark_oth,MANNUALRECPTNO from cir_rcphdr_temp
            where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
                    recptno=@precptno and recptdt=@v_dt
      
          insert into cir_rcpdet(comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, recptno, recptdt, 
                            payfor, achd, publ, chno, chbnk, chdt, amount, reason, remark, voucherno, voucherdt, 
                            tds, stax, status, usrid, creation_date, branch_code)
          select comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, recptno, recptdt, 
                            payfor, achd, publ, chno, chbnk, 
                            CASE chdt WHEN '1900-01-01 00:00:00.000' THEN NULL else chdt END chdt, 
                            amount, reason, remark, voucherno, voucherdt, 
                            tds, stax, status, usrid, creation_date, branch_code from cir_rcpdet_temp
            where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and 
                    recptno=@precptno and recptdt=@v_dt

        insert into cir_outmast (comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, recptno, recptdt, 
                        achd, publ, chno, chbnk, chdt, amount, reason, remark, voucherno, voucherdt, balance, 
                        tds, stax, status, cancel_userid, cancel_dt, cancel_remark, usrid, creation_date, bill_sec_amt, branch_code)
        select comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, recptno, recptdt, 
                        achd, publ, chno, chbnk, 
                        CASE chdt WHEN '1900-01-01 00:00:00.000' THEN NULL else chdt END chdt, 
                        amount, reason, remark, voucherno, voucherdt, balance, 
                        tds, stax, status, cancel_userid, cancel_dt, cancel_remark, usrid, creation_date, bill_sec_amt, branch_code from cir_outmast_temp
             where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and 
                    recptno=@precptno and recptdt=@v_dt
	
		insert into cir_rcpt_document(comp_code, unit_code, doctype, recptno, recptdt, filename, created_by, created_dt)
		select comp_code, unit_code, doctype, recptno, recptdt, filename, created_by, created_dt from cir_rcpt_document_temp
		where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
     	recptno=@precptno and recptdt=@v_dt
		
		insert into cir_rcp_unadj(comp_code,unit_code,agcd,dpcd,doctyp,recptno,recptdt,publ,amount,created_by,created_date,updated_by,updated_date)
		select comp_code,unit_code,agcd,dpcd,doctyp,recptno,recptdt,publ,amount,created_by,created_date,updated_by,updated_date from cir_rcp_unadj_temp
		where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and recptno=@precptno
		
		delete from cir_rcphdr_temp where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
		recptno=@precptno and recptdt=@v_dt
		    
		delete from cir_rcpdet_temp
		where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and 
		recptno=@precptno and recptdt=@v_dt

		delete from cir_outmast_temp
		where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and 
		recptno=@precptno and recptdt=@v_dt

		delete from cir_rcpt_document_temp
		where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
		recptno=@precptno and recptdt=@v_dt

		delete from cir_rcp_unadj_temp
		where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and recptno=@precptno
	
    end           
    
-----  this part starts from here for blocking agency for debit note-----------------
	declare @v_doctype_BU as varchar(10) -- rcpt_hdr table 
	declare @v_reason_BU as varchar(10) -- rcpt_hdr table 
	declare @v_agcd_BU as varchar(10) -- rcpt_hdr table 
	declare @v_dpcd_BU as varchar(10) -- rcpt_hdr table 
	declare @v_nooftimes_BU as int  -- reason_mast	
	declare @v_noofdays_BU as int  -- reason_mast
	declare @v_NO_OF_CHQbnc_pref as int  -- preference table
	declare @v_CIR_DAYS_CHQ_pref as int  -- preference table
	
	declare @v_cnt_specific_reason as int	
	declare @vod_payment as varchar(3)	
	declare @no_of_days_pref as int-- for preferrence / anniversary date
	
	set @vod_payment='N'
	set @no_of_days_pref=365
	
	select @v_doctype_BU = DOCTYPE,@v_agcd_BU=agcd,@v_dpcd_BU=DPCD from cir_rcphdr where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
	recptno=@precptno and recptdt=@v_dt
	
	if @v_doctype_BU ='DN' begin	
		
		select @v_reason_BU = REASON from cir_rcphdr where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
		recptno=@precptno and recptdt=@v_dt
		select @v_nooftimes_BU=isnull(no_of_times,0),@v_noofdays_BU=isnull(VALID_DAYS,0) from CIR_REASON_MST where REASON_CODE=@v_reason_BU and DOC_TYPE='DN'
		select @v_NO_OF_CHQbnc_pref=isnull(CIR_NO_OF_CHQBOUNCE,0),@v_CIR_DAYS_CHQ_pref=isnull(CIR_DAYS_CHQBOUNCE,0) from preferrences where comp_code=@pcompcode
		
		if @v_nooftimes_BU ='' 
		begin
			set @v_nooftimes_BU=0
		end	
		if @v_noofdays_BU ='' 
		begin
			set @v_noofdays_BU=0
		end
		if @v_NO_OF_CHQbnc_pref ='' 
		begin
			set @v_NO_OF_CHQbnc_pref=0
		end
		if @v_CIR_DAYS_CHQ_pref ='' 
		begin
			set @v_CIR_DAYS_CHQ_pref=0
		end
		----------------- in case of immediate effect of any reason to suspend the agency---------------
		select @v_cnt_specific_reason=count(*) from cir_rcphdr where comp_code=@pcompcode 
		and unit_code=@punitcode and doctype=@pdoctype and REASON=@v_reason_BU and
		recptno=@precptno and recptdt between dateadd(dd,-1*@v_noofdays_BU,@v_dt) and @v_dt
		
		if @v_nooftimes_BU =0 or @vod_payment='Y' -- 0 for stop payment and over due payment
		begin
					
			update cir_agmast set SUSPEND='Y',SUSPEND_DATE=GETDATE(),SUSPEND_TYPE='CH0' where COMP_CODE=@pcompcode 
			and AGCD=@v_agcd_BU and DPCD=@v_dpcd_BU			
			update CIR_AGENCY_PAYMODE set PAYMODE_ACTIVE='N',BLOCK_BY_A_M=null,UPDATED_DT = getdate()  where COMP_CODE=@pcompcode and AGCD=@v_agcd_BU and DPCD=@v_dpcd_BU
			and PAYMODE='CH0'
		end
		else if @v_nooftimes_BU < ISNULL(@v_cnt_specific_reason,0) or @vod_payment='Y' -- 0 for stop payment and over due payment
		begin
						
			update cir_agmast set SUSPEND='Y',SUSPEND_DATE=GETDATE(),SUSPEND_TYPE='CH0' where COMP_CODE=@pcompcode 
			and AGCD=@v_agcd_BU and DPCD=@v_dpcd_BU			
			update CIR_AGENCY_PAYMODE set PAYMODE_ACTIVE='N',BLOCK_BY_A_M=null,UPDATED_DT = getdate()  where COMP_CODE=@pcompcode and AGCD=@v_agcd_BU and DPCD=@v_dpcd_BU
			and PAYMODE='CH0'
		end
		-------------  end here ------------------------
		declare @v_cnt_specific_period as int
		----------------- in case of cheque bounce specific times in specic period block chq payments only for tht period---------------
		select @v_cnt_specific_period=count(*) from cir_rcphdr where comp_code=@pcompcode 
		and unit_code=@punitcode and doctype=@pdoctype and
		recptno=@precptno and recptdt between dateadd(dd,-1*@v_CIR_DAYS_CHQ_pref,@v_dt) and @v_dt
		
		if @v_NO_OF_CHQbnc_pref < ISNULL(@v_cnt_specific_period,0) 
		begin
						
			update CIR_AGENCY_PAYMODE set PAYMODE_ACTIVE='N',BLOCK_BY_A_M='A',UPDATED_DT = getdate() where COMP_CODE=@pcompcode and AGCD=@v_agcd_BU and DPCD=@v_dpcd_BU
			and PAYMODE='CH0'
		end
		---------------  end here -----------------------
	end
       
-----  this part ends here for blocking agency for debit note  ----------------------


-----  this part starts from here for cheque dishonoured  debit note reverse entry-----------------       

declare @v_refrecnum as varchar(20)
declare @v_refrecdt  as datetime 
declare @v_refrecamt  as numeric(14,2)
declare @vrefdoctype as varchar(20)
declare @v_doctype as varchar(20)
declare @v_reason as varchar(20)

declare @rec_count as int
declare @rec_count1 as int
declare @vag_main_code as varchar(30)
declare @vag_sub_code as varchar(30)
declare @vunit as varchar(30)
declare @rec_amount as numeric(14,2)
declare @rem_amount as numeric(14,2)


/******************************  parameters for cursor*******************************/
declare @c1_branch			as varchar(20)
declare @c1_billno			as varchar(50)
declare @c1_billdt			as datetime
declare @c1_amount			as float
declare @c1_unit			as varchar(20)
declare @c1_agcode			as varchar(30)
declare @c1_doctype			as varchar(20)
declare @c1_reason			as varchar(20)
declare @c1_recptno			as varchar(50)
declare @c1_recptdt			as datetime
declare @c1_chno			as varchar(30)
declare @c1_chdt			as datetime
declare @c1_bank			as varchar(20)
declare @c1_voucherno		as varchar(30)
declare @c1_voucherdate		as datetime
declare @c1_comp_code		as varchar(20)
declare @c1_userid			as varchar(20)
declare @c1_pripub			as varchar(20)
declare @c1_tds				as float
declare @c1_received_region as varchar(30)
declare @c1_stax				as float
declare @c1_ag_main_code	as varchar(20)
declare @c1_ag_sub_code		as varchar(30)
declare @c1_remark			as varchar(200)
declare @v_print_center as varchar(8)

select @v_refrecnum= REF_RECPTNO, @v_refrecdt=REF_RECPTDT,@v_refrecamt=AMOUNT,@v_doctype=DOCTYPE,@v_reason=REASON,
@vag_main_code=AGCD ,@vag_sub_code=DPCD,@vunit=UNIT_CODE,@vrefdoctype=REF_DOCTYPE
from CIR_RCPHDR where COMP_CODE=@pcompcode and RECPTNO=@precptno and RECPTDT=@v_dt and DOCTYPE='DN'
print('***')
print(@precptno)print(@v_dt)print(@v_refrecamt)print(@v_doctype)print(@v_reason)print(@v_refrecnum)print(@v_refrecdt)
print('start')
if isnull(@v_refrecamt,0)>0 and @v_doctype ='DN' and  @v_reason='CH0' and @v_refrecnum is not null and @v_refrecdt is not null 
begin
		select @rec_count=count(*) from cir_rcphdr where comp_code=@pcompcode and UNIT_CODE=@vunit  and recptno=@v_refrecnum and
        AGCD=@vag_main_code and DPCD=@vag_sub_code and amount<>0
		
		print(@vunit)print(@vrefdoctype)print(@v_refrecnum)print(@vag_sub_code)print(@vag_main_code)
        
        select @rec_count1=count(*) from CIR_OUTMAST where comp_code=@pcompcode and UNIT_CODE=@vunit and doctyp=@vrefdoctype and recptno=@v_refrecnum and
        agcd=@vag_main_code and DPCD=@vag_sub_code and billno is not null and amount<>0
		print('start_1')		
		if isnull(@rec_count,0)>0
		begin
			print('start_2')
			print(@vunit)print(@vrefdoctype)print(@v_refrecnum)print(@vag_sub_code)print(@vag_main_code)
			
			select @rec_amount=abs(amount) from cir_rcphdr where comp_code=@pcompcode and UNIT_CODE=@vunit and recptno=@v_refrecnum and
			agcd=@vag_main_code and dpcd=@vag_sub_code and amount<>0
			
			declare c1 cursor for
				select branch_code,billno,billdt,amount,unit_code,'',doctyp,reason,recptno,recptdt							
				,chno,chdt,chbnk,voucherno,voucherdt,comp_code,usrid,publ,tds						
				,'',stax,agcd,dpcd,remark from cir_outmast
				where comp_code=@pcompcode and unit_code=@vunit and recptno=@v_refrecnum and
				agcd=@vag_main_code and dpcd=@vag_sub_code --and amount<>0 
				order by recptdt,recptno,billdt,billno
			
			if @rec_amount=@v_refrecamt 
			begin --3
                set @rem_amount=@v_refrecamt
                print('start_3')
                OPEN c1 
				fetch NEXT FROM c1 INTO	@c1_branch,@c1_billno,@c1_billdt,@c1_amount,@c1_unit,@c1_agcode,@c1_doctype,@c1_reason,@c1_recptno,@c1_recptdt,@c1_chno,@c1_chdt,@c1_bank,@c1_voucherno,@c1_voucherdate,@c1_comp_code,@c1_userid,@c1_pripub,@c1_tds,@c1_received_region,@c1_stax,@c1_ag_main_code,@c1_ag_sub_code,@c1_remark
                WHILE (@@FETCH_STATUS = 0) 
				BEGIN
					 --set @vbillamt=abs(@c1_amount)
					 print('start_4')
					 if @c1_billno is not null and @c1_billdt is not null 
					 begin --4
					 print('start_5')print(@c1_billno)print(@c1_billdt)print('AAA')
						delete from CIR_OUTMAST where comp_code=@c1_comp_code and unit_code=@c1_unit 
						and agcd=@c1_ag_main_code and dpcd=@c1_ag_sub_code and BILLNO=@c1_billno and BILLDT=@c1_billdt and RECPTNO is not null
						and RECPTNO=@v_refrecnum					
						delete from CIR_RCPDET where comp_code=@c1_comp_code and unit_code=@c1_unit 
						and agcd=@c1_ag_main_code and dpcd=@c1_ag_sub_code and BILLNO=@c1_billno and BILLDT=@c1_billdt and RECPTNO is not null					
						and RECPTNO=@v_refrecnum
					 end
					 else --if abs(@c1_amount)=ABS(@v_refrecamt) --4
					 begin
						/*---if ref recipt amount in hand greater than zero amount---*/
						print('start_6')
                        insert into cir_outmast (UNIT_CODE,doctyp,reason , BRANCH_CODE , billno , billdt , recptno , recptdt ,
                                                 chno , chdt , chbnk , voucherno , voucherdt , amount , comp_code , USRID ,
                                                 publ , tds , stax,agcd,dpcd,remark)
                                          values(@c1_unit,@c1_doctype,@c1_reason,@c1_branch,@precptno,@v_dt,@c1_recptno,@c1_recptdt,
                                                 @c1_chno , @c1_chdt ,@c1_bank,@c1_voucherno,@c1_voucherdate,-1*@v_refrecamt,@c1_comp_code,@c1_userid,
                                                 @c1_pripub,@c1_tds,@c1_stax,@c1_ag_main_code,@c1_ag_sub_code,@c1_remark)                                                 
                        
                        update cir_outmast set amount=0 where comp_code=@c1_comp_code and unit_code=@c1_unit and recptno=@c1_recptno
                        and recptdt=@c1_recptdt and billno is null and billdt is null
                        
                        insert into cir_rcpdet(UNIT_CODE,doctyp,reason , BRANCH_CODE , billno , billdt , recptno , recptdt ,
                                                 chno , chdt , chbnk , voucherno , voucherdt , amount , comp_code , USRID ,
                                                 publ , tds , stax,agcd,dpcd,remark)
                                          values(@c1_unit,@c1_doctype,@c1_reason,@c1_branch,@precptno,@v_dt,@c1_recptno,@c1_recptdt,
                                                 @c1_chno , @c1_chdt ,@c1_bank,@c1_voucherno,@c1_voucherdate,-1*@v_refrecamt,@c1_comp_code,@c1_userid,
                                                 @c1_pripub,@c1_tds,@c1_stax,@c1_ag_main_code,@c1_ag_sub_code,@c1_remark)
                        print('@v_refrecamt')print(@v_refrecamt)
                        /*---if ref recipt amount in hand greater than zero amount---*/
					 end
					 
				
				fetch NEXT FROM c1 INTO	@c1_branch,@c1_billno,@c1_billdt,@c1_amount,@c1_unit,@c1_agcode,@c1_doctype,@c1_reason,@c1_recptno,@c1_recptdt,@c1_chno,@c1_chdt,@c1_bank,@c1_voucherno,@c1_voucherdate,@c1_comp_code,@c1_userid,@c1_pripub,@c1_tds,@c1_received_region,@c1_stax,@c1_ag_main_code,@c1_ag_sub_code,@c1_remark
				END
				close c1
				deallocate c1
                print('start_7')
                
                
			end
			print('start_8')
		end
	print('start_9')
end



-----  this part ends here for cheque dishonoured  debit note reverse entry -----------------
    if upper(@prectype)='D' Begin
        select @v_recno=count(*) from cir_rcphdr_dis 
            where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
                recptno=@precptno
		End
    else Begin
        select @v_recno=count(*) from cir_rcphdr 
            where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
                recptno=@precptno 
    End

    if isnull(@v_recno,0)>0 Begin		
        select @v_recno as "RECNO"
		End
     else Begin
        select 0 as "RECNO"
     End

end

///////////////////////////////////////////////////////////////////////////////

ALTER PROCEDURE [dbo].[cir_rep_agency_ledger_cir_agency_ledger_utusan]
    @pcompcode       as varchar(20),
    @punitcode       as varchar(20),
    @pactype         as varchar(20),
    @pbranchcode     as varchar(20),
    @pagency_type    as varchar(20),
    @pagcd           as varchar(20),
    @pdpcd           as varchar(20),
    @pstatecode      as varchar(20),
    @pdistcode       as varchar(20),
    @pcitycode       as varchar(20),
    @ptalukacode     as varchar(20),
    @pfrom_date      as datetime,
    @ptill_date      as datetime,
    @pbilladj_flag   as varchar(20),
    @psortedby       as varchar(20),
    @puserid         as varchar(20),
    @prowbreak       as varchar(20),
    @pdateformat     as varchar(20),
    @pextra1         as varchar(200),--it is use for agency class
    @pextra2         as varchar(200)
As
    declare @v_frdt          datetime;
    declare @v_todt          datetime;
    declare @v_opdate        datetime;
   
    declare @v_opbal         decimal(15,2)
    declare @v_opbal_sec     decimal(15,2)
    declare @v_amt           decimal(15,2)
    declare @v_clbal         decimal(15,2)
    declare @v_runbal        decimal(15,2)
    declare @v_billamt       decimal(15,2)
    declare @v_dbcramt       decimal(15,2)
    declare @v_cramt         decimal(15,2)
    declare @v_dbamt         decimal(15,2)
    declare @v_rec_seqno     int
    declare @v_remark_len    int
    declare @v_divident      int
    declare @v_narration     varchar(1000)
    declare @v_runbal_txt    varchar(20)
	
	
	declare @v1_comp_code		varchar(20)
	declare @v1_unit			varchar(20)
	declare @v1_agcd			varchar(20) 
	declare @v1_dpcd			varchar(20) 
	declare @v1_ag_name			varchar(200) 
	declare @v1_ag_name_oth_lang varchar(200)
	declare @v1_city_code		varchar(20)
	declare @v1_tehsil_taluka	varchar(20)
	declare @v1_dist_code		varchar(20)
	declare @v1_state_code		varchar(20)
    declare @v1_country_code	varchar(20)	
	declare @v1_branch_code		varchar(20)
	
	declare @v1_issue_date		datetime
	declare @v1_product_code	varchar(20)
	declare @v1_quantity		int
	declare @v1_unit_price		numeric(8,3)
	declare @v1_addr1	varchar(200)
	declare @v1_ADDR2	varchar(200)
	declare @v1_ADDR3	varchar(200)
	declare @v1_PIN_CODE	numeric(10)



	declare @v2_comp_code		varchar(20)	
	declare @v2_unit_code		varchar(20)
	declare @v2_agcd			varchar(20)
	declare @v2_dpcd			varchar(20)
	declare @v2_doctype			varchar(20)	
	declare @v2_recptno			varchar(20)
	declare @v2_recptdt			datetime
	declare @v2_amount			decimal(15,2)
	declare @v2_chno			varchar(20)
	declare @v2_chdt			datetime
	declare @v2_chbank			varchar(200)
	declare @v2_reason			varchar(200)
	declare @v2_narration		varchar(2000)
	declare @v2_received_from	varchar(200)
        
Begin
	If @punitcode='' Begin
		set @punitcode=null
	End
	If @pactype='' Begin
		set @pactype=null
	End
	If @pbranchcode='' Begin
		set @pbranchcode=null
	End
	If @pagency_type='' Begin
		set @pagency_type=null
	End
	If @pagcd='' Begin
		set @pagcd=null
	End
	If @pdpcd='' Begin
		set @pdpcd=null
	End
	If @pstatecode='' Begin
		set @pstatecode=null
	End
	If @pdistcode='' Begin
		set @pdistcode=null
	End

	If @pcitycode='' Begin
		set @pcitycode=null
	End
	If @ptalukacode='' Begin
		set @ptalukacode=null
	End
	If @pbilladj_flag='' Begin
		set @pbilladj_flag=null
	End
	If @pextra1='' Begin
		set @pextra1=null
	End
	If @pextra2='' Begin
		set @pextra2=null
	End
	If @prowbreak='' Begin
		set @prowbreak=null
	End

	set @v_opdate    =dbo.cir_get_finandt(@pcompcode,@pfrom_date,@pdateformat,null,null)--for financial date
print('%')
print(@prowbreak)
	set @v_frdt      =@pfrom_date
	set @v_todt      =@ptill_date
	set @v_divident  =isnull(@prowbreak,35)

	CREATE TABLE #CIR_LEDGER_REPORT
	( COMP_CODE      VARCHAR(10),
	  UNIT_CODE      VARCHAR(10),
	  BRANCH_CODE    VARCHAR(10),
	  DOCTYPE        VARCHAR(100),
	  AGCD           VARCHAR(50),
	  DPCD           VARCHAR(50),
	  RECPTNO        VARCHAR(50),
	  RECPTDT        DATETIME,
	  AMOUNT         decimal(14,2),
	  CHQNO          VARCHAR(50),
	  CHQDT          DATETIME,
	  CHQ_BANK       VARCHAR(100),
	  EXEC_CODE      VARCHAR(20),
	  REMARKS        VARCHAR(500),
	  REASON         VARCHAR(30),
	  BILLNO         VARCHAR(50),
	  BILLDT         DATETIME,
	  BILLAMT        DECIMAL(14,2),
	  ADJAMT         DECIMAL(14,2),
	  LEFTAMT        DECIMAL(14,2),
	  DEBIT_HEAD     VARCHAR(200),
	  CREDIT_HEAD    VARCHAR(200),
	  REC_SEQNO      INT,
	  RECOVARY_DAYS  INT,
	  AGNAME         VARCHAR(500),
	  OPBAL_SEC      DECIMAL(14,2),
	  NARR_LINE      INT,
	  ISSUE_DATE     DATETIME,
	  PRODUCT        VARCHAR(200),
	  QUANTITY       INT,
	  UNIT_PRICE     NUMERIC(8,3),
	  addr1			 varchar(200),
	  ADDR2			 varchar(200),
	  ADDR3			 varchar(200),
	  PIN_CODE       numeric(10)
	  )
print('8')
create table #cir_summary_statement
(
comp_code varchar(20),
unit_code varchar(20),
PUBL_code varchar(20),
EDTN_code varchar(20),
PUBL_NAME varchar(200),
EDTN_NAME varchar(200),
AGCD varchar(20),
DPCD varchar(20),
INV_QTY  numeric(12),
INV_AMT  numeric(14,2),
RET_QTY  numeric(12),
RET_AMT  numeric(14,2),
INSERT_LATE numeric(14,2),
REMARK    varchar(200),
TOTAL numeric(14,2)
)	
declare @sum_ag_comp_code as varchar(20)
declare @sum_ag_unit as varchar(20)
declare @sum_ag_agcd as varchar(20)
declare @sum_ag_dpcd as varchar(20)
declare @sum_ag_ag_name	 as varchar(200)
declare @sum_publ_publ	 as varchar(200)
declare @sum_edtn	 as varchar(200)
declare @sum_edtn_name	 as varchar(200)

declare @v_invqty as numeric(12)
declare @v_invamt as numeric(14,2)
declare @v_retqty as numeric(12)
declare @v_retamt as numeric(14,2)
declare @v_late_ins as numeric(14,2)
declare @v_publ_tot as numeric(14,2)
declare @v_payment as  numeric(14,2)
declare @v_dn_chq as numeric(14,2)					
declare @v_dn_nom as numeric(14,2)					
declare @v_cn as numeric(14,2)

declare @v_tot_inv as numeric(14,2)
declare @v_tot_ucn as numeric(14,2)
declare @v_close_bal as numeric(14,2)

	if @pextra2 ='S'
	begin
		declare sum_ag cursor for
			select distinct comp_code,unit,agcd,dpcd,ag_name from cir_agmast  
			where comp_code = @pcompcode and (unit=@punitcode or @punitcode is null) 
			and (ag_type=@pagency_type or @pagency_type is null) 
			and agcd+dpcd in(select distinct agcd+dpcd from cir_outmast 
							where comp_code = @pcompcode and (unit_code=@punitcode or @punitcode is null) and achd=@pactype) 
			and (agcd=@pagcd or @pagcd is null) 
			and (dpcd=@pdpcd or @pdpcd is null) 			
			and (branch_code=@pbranchcode or @pbranchcode is null) 
			and (state_code=@pstatecode or @pstatecode is null) 
			and (dist_code=@pdistcode or @pdistcode is null) 
			and (tehsil_taluka=@ptalukacode or @ptalukacode is null) 			
			and (ag_class=@pextra1 or @pextra1 is null)
			order by comp_code,unit,ag_name;
	
	
			open sum_ag
				fetch NEXT FROM sum_ag INTO @sum_ag_comp_code,@sum_ag_unit,@sum_ag_agcd,@sum_ag_dpcd,@sum_ag_ag_name
				WHILE (@@FETCH_STATUS = 0) Begin
					set @v_opbal=0
					set @v_close_bal=0
					set @v_opbal =dbo.cir_accounts_cir_agency_opbal(@pcompcode, @punitcode,null,@sum_ag_agcd, @sum_ag_dpcd, @v_opdate, 'NM',@pdateformat,null,null)
					set @v_dbcramt=0					
				
							select @v_billamt=sum(amount) from cir_outmast
								where comp_code = @pcompcode and unit_code=@punitcode and 
									agcd=@sum_ag_agcd and dpcd=@sum_ag_dpcd and billdt >= @v_opdate and billdt<@v_frdt and 
									achd='NM' and recptno is null

							select @v_dbcramt=sum(amount) from cir_rcpdet
								where comp_code=@pcompcode and unit_code=@punitcode and 
									agcd=@sum_ag_agcd and dpcd=@sum_ag_dpcd and recptdt>= @v_opdate and recptdt<@v_frdt and 
									achd='NM' and billno is null

							set @v_opbal=isnull(@v_opbal,0)+isnull(@v_billamt,0)+isnull(@v_dbcramt,0)
			------------------  insert BF ----------------
			insert into #cir_summary_statement(comp_code,unit_code,PUBL_code,EDTN_code,PUBL_NAME,EDTN_NAME,
						AGCD,DPCD,INV_QTY,INV_AMT,RET_QTY,RET_AMT,INSERT_LATE,REMARK,TOTAL)	
			values (@sum_ag_comp_code,@sum_ag_unit,null,null,'Balance B/F',null,@sum_ag_agcd,@sum_ag_dpcd
					,null,null,null,null,null,null,@v_opbal)
			---------------------------------------------		
			set @v_close_bal=@v_opbal
			set @v_tot_inv =0
			set @v_tot_ucn =0

					declare sum_publ cursor for
						select distinct  publ,pro_type,publ_name from cir_publ_mast
						where comp_code = @pcompcode --and (unit_code=@punitcode or @punitcode is null) 
						order by pro_type
						
						open sum_publ
							fetch NEXT FROM sum_publ INTO @sum_publ_publ,@sum_edtn,@sum_edtn_name
							WHILE (@@FETCH_STATUS = 0) Begin
								select @v_invqty=SUM(isnull(bill_copy,0))
								,@v_invamt=sum(isnull(bill_amount,0))								
								from cir_bill where COMP_CODE=@sum_ag_comp_code
								and UNIT_CODE=@sum_ag_unit and AGCD=@sum_ag_agcd and DPCD=@sum_ag_dpcd
								and BILLDT between @v_frdt and @v_todt
								and PUBL=@sum_publ_publ 
								
								select @v_retqty=sum(ISNULL(APR_BNR,0))+sum(ISNULL(APR_DAMAGE,0))+sum(ISNULL(APR_LATE_RECPT,0))+
								sum(ISNULL(APR_SHORT_RECPT,0))+sum(ISNULL(APR_UNSOLD,0)) 
								,@v_retamt =SUM(isnull(copy_amt,0)) from CIR_UNSOLD_DTL 
								where COMP_CODE=@sum_ag_comp_code and UNIT_CODE=@sum_ag_unit 
								and AGCD=@sum_ag_agcd and DPCD=@sum_ag_dpcd and PUBL=@sum_publ_publ 
								and APP_DT between @v_frdt and @v_todt
								and (PROCESS_CRNO is not null or PROCESS_CRNO!='')
								and (PROCESS_CRDT is not null or PROCESS_CRDT!='')
								
								select @v_late_ins=SUM(isnull(abs(AMOUNT),0)) from cir_rcphdr 
								where COMP_CODE=@sum_ag_comp_code and UNIT_CODE=@sum_ag_unit 
								and AGCD=@sum_ag_agcd and DPCD=@sum_ag_dpcd and PUBL=@sum_publ_publ 
								and RECPTDT between @v_frdt and @v_todt
								
								set @v_publ_tot=isnull(@v_invamt,0)+(-1*ISNULL(@v_retamt,0))+(-1*ISNULL(@v_late_ins,0))
								------------------  insert product summary ----------------
								if isnull(@v_invamt ,0) !=0 or isnull(@v_retamt ,0) !=0 or isnull(@v_late_ins ,0) !=0
								begin
									insert into #cir_summary_statement(comp_code,unit_code,PUBL_code,EDTN_code,PUBL_NAME,EDTN_NAME,
												AGCD,DPCD,INV_QTY,INV_AMT,RET_QTY,RET_AMT,INSERT_LATE,REMARK,TOTAL)	
									values (@sum_ag_comp_code,@sum_ag_unit,@sum_publ_publ,@sum_edtn,@sum_edtn_name,null,@sum_ag_agcd,@sum_ag_dpcd
											,@v_invqty,@v_invamt,@v_retqty,@v_retamt,@v_late_ins,null,@v_publ_tot)
								set @v_close_bal=	@v_close_bal+(@v_publ_tot)
								set @v_tot_inv =@v_tot_inv+@v_invamt
								set @v_tot_ucn =@v_tot_ucn+@v_retamt
								end
								---------------------------------------------
								
								
							fetch NEXT FROM sum_publ INTO @sum_publ_publ,@sum_edtn,@sum_edtn_name
							End

						close sum_publ
						deallocate sum_publ
					------------------------ just for  total----------------
					if isnull(@v_tot_inv ,0) !=0 or isnull(@v_tot_ucn ,0) !=0 
					begin
						insert into #cir_summary_statement(comp_code,unit_code,PUBL_code,EDTN_code,PUBL_NAME,EDTN_NAME,
									AGCD,DPCD,INV_QTY,INV_AMT,RET_QTY,RET_AMT,INSERT_LATE,REMARK,TOTAL)	
						values (@sum_ag_comp_code,@sum_ag_unit,null,null,null,null,@sum_ag_agcd,@sum_ag_dpcd
								,null,@v_tot_inv,null,@v_tot_ucn,null,null,null)
					end
					
					select @v_dn_chq=SUM(isnull(abs(amount),0)) from CIR_RCPHDR 
					where COMP_CODE=@sum_ag_comp_code and UNIT_CODE=@sum_ag_unit 
					and AGCD=@sum_ag_agcd and DPCD=@sum_ag_dpcd and DOCTYPE='DN' and REASON='CH0'
					and RECPTDT between @v_frdt and @v_todt					
									
					------------------  insert DN CHQ Bounce summary ----------------
					if isnull(@v_dn_chq ,0) !=0 
					begin
						insert into #cir_summary_statement(comp_code,unit_code,PUBL_code,EDTN_code,PUBL_NAME,EDTN_NAME,
							AGCD,DPCD,INV_QTY,INV_AMT,RET_QTY,RET_AMT,INSERT_LATE,REMARK,TOTAL)	
						values (@sum_ag_comp_code,@sum_ag_unit,null,null,'CHEQUE BOUNCED',null,@sum_ag_agcd,@sum_ag_dpcd
								,null,null,null,null,null,null,@v_dn_chq)
					set @v_close_bal=	@v_close_bal+(@v_dn_chq)
					end
					
					---------------------------------------------	
					
					select @v_dn_nom=SUM(isnull(abs(amount),0)) from CIR_RCPHDR 
					where COMP_CODE=@sum_ag_comp_code and UNIT_CODE=@sum_ag_unit 
					and AGCD=@sum_ag_agcd and DPCD=@sum_ag_dpcd and DOCTYPE='DN' and REASON!='CH0'					
					and RECPTDT between @v_frdt and @v_todt				
					------------------  insert DN summary ----------------
					if isnull(@v_dn_nom ,0) !=0 
					begin
						insert into #cir_summary_statement(comp_code,unit_code,PUBL_code,EDTN_code,PUBL_NAME,EDTN_NAME,
							AGCD,DPCD,INV_QTY,INV_AMT,RET_QTY,RET_AMT,INSERT_LATE,REMARK,TOTAL)	
						values (@sum_ag_comp_code,@sum_ag_unit,null,null,'DEBIT NOTE',null,@sum_ag_agcd,@sum_ag_dpcd
								,null,null,null,null,null,null,@v_dn_nom)
					set @v_close_bal=	@v_close_bal+(@v_dn_nom)
					end
					
					---------------------------------------------	
					
					select @v_cn=SUM(isnull(abs(amount),0)) from CIR_RCPHDR 
					where COMP_CODE=@sum_ag_comp_code and UNIT_CODE=@sum_ag_unit 
					and AGCD=@sum_ag_agcd and DPCD=@sum_ag_dpcd and DOCTYPE='CN'					
					and RECPTDT between @v_frdt and @v_todt				
					------------------  insert CN summary ----------------
					if isnull(@v_cn ,0) !=0 
					begin
						insert into #cir_summary_statement(comp_code,unit_code,PUBL_code,EDTN_code,PUBL_NAME,EDTN_NAME,
							AGCD,DPCD,INV_QTY,INV_AMT,RET_QTY,RET_AMT,INSERT_LATE,REMARK,TOTAL)	
						values (@sum_ag_comp_code,@sum_ag_unit,null,null,'CREDIT NOTE',null,@sum_ag_agcd,@sum_ag_dpcd
								,null,null,null,null,null,null,@v_cn)
					set @v_close_bal=	@v_close_bal+(-1*@v_cn)
					end
					
					---------------------------------------------
					
					select @v_payment=SUM(isnull(abs(amount),0)) from CIR_RCPHDR 
					where COMP_CODE=@sum_ag_comp_code and UNIT_CODE=@sum_ag_unit 
					and AGCD=@sum_ag_agcd and DPCD=@sum_ag_dpcd and DOCTYPE='RCR' and ACHD	= 'NM'				
					and RECPTDT between @v_frdt and @v_todt				
					------------------  insert PAYMENT summary ----------------
					if isnull(@v_payment ,0) !=0 
					begin
						insert into #cir_summary_statement(comp_code,unit_code,PUBL_code,EDTN_code,PUBL_NAME,EDTN_NAME,
							AGCD,DPCD,INV_QTY,INV_AMT,RET_QTY,RET_AMT,INSERT_LATE,REMARK,TOTAL)	
						values (@sum_ag_comp_code,@sum_ag_unit,null,null,'PAYMENT',null,@sum_ag_agcd,@sum_ag_dpcd
								,null,null,null,null,null,null,@v_payment)
					set @v_close_bal=	@v_close_bal+(-1*@v_payment)
					end
					
					---------------------------------------------	
				
				if isnull(@v_close_bal ,0) !=0 
				begin
					insert into #cir_summary_statement(comp_code,unit_code,PUBL_code,EDTN_code,PUBL_NAME,EDTN_NAME,
						AGCD,DPCD,INV_QTY,INV_AMT,RET_QTY,RET_AMT,INSERT_LATE,REMARK,TOTAL)	
					values (@sum_ag_comp_code,@sum_ag_unit,null,null,'BALANCE C/F',null,@sum_ag_agcd,@sum_ag_dpcd
							,null,null,null,null,null,null,@v_close_bal)
				end
				
				fetch NEXT FROM sum_ag INTO @sum_ag_comp_code,@sum_ag_unit,@sum_ag_agcd,@sum_ag_dpcd,@sum_ag_ag_name
				End

			close sum_ag
			deallocate sum_ag
	
	select *,dbo.cir_get_agency(COMP_CODE,UNIT_CODE,AGCD,DPCD) AS AGENCYNAME	
	,dbo.cir_get_contact_person(COMP_CODE,AGCD,DPCD) AS CONTACT
	,dbo.cir_get_agency_add(COMP_CODE,AGCD,DPCD,'','') AS ADDR
	 from #cir_summary_statement order by AGCD,DPCD
	
	end
	else
	begin
declare @v1_commrate as numeric(14,2)
		declare c1 cursor for
				select distinct comp_code,unit,agcd,dpcd,ag_name,ag_name_oth_lang,city_code,tehsil_taluka,dist_code,state_code,
					country_code,branch_code,addr1,ADDR2,ADDR3,PIN_CODE from cir_agmast 
						where comp_code = @pcompcode and (unit=@punitcode or @punitcode is null) and 
									(ag_type=@pagency_type or @pagency_type is null) and agcd+dpcd in(select distinct agcd+dpcd from cir_outmast 
									where comp_code = @pcompcode and (unit_code=@punitcode or @punitcode is null) and achd=@pactype) and 
									(agcd=@pagcd or @pagcd is null) and (dpcd=@pdpcd or @pdpcd is null) and (branch_code=@pbranchcode or @pbranchcode is null) and
									(state_code=@pstatecode or @pstatecode is null) and (dist_code=@pdistcode or @pdistcode is null) and 
									(tehsil_taluka=@ptalukacode or @ptalukacode is null) and (ag_class=@pextra1 or @pextra1 is null)
									order by branch_code,city_code,ag_name;
		  
				--select distinct a.comp_code,a.unit,a.agcd,a.dpcd,a.ag_name,a.ag_name_oth_lang,a.city_code
				--,a.tehsil_taluka,a.dist_code,a.state_code, a.country_code,a.branch_code 
				--,x.supdate,x.publ,x.sup_copy,x.sup_rate,a.addr1,a.ADDR2,a.ADDR3,a.PIN_CODE
				--from cir_agmast a,cir_dbksup x
				--where a.comp_code=x.comp_code and x.UNIT_CODE=a.UNIT and A.AGCD  = x.AGCD and A.DPCD  = x.DPCD and
				-- a.comp_code = @pcompcode and (a.unit=@punitcode or @punitcode is null) and 
				--(a.ag_type=@pagency_type or @pagency_type is null) and a.agcd+a.dpcd in(select distinct agcd+dpcd from cir_outmast 
				--where comp_code = @pcompcode and (unit_code=@punitcode or @punitcode is null) and achd=@pactype) and 
				--(a.agcd=@pagcd or @pagcd is null) and (a.dpcd=@pdpcd or @pdpcd is null) and (a.branch_code=@pbranchcode or @pbranchcode is null) and
				--(a.state_code=@pstatecode or @pstatecode is null) and (a.dist_code=@pdistcode or @pdistcode is null) and 
				--(a.tehsil_taluka=@ptalukacode or @ptalukacode is null) and (a.ag_class=@pextra1 or @pextra1 is null)
				--order by a.branch_code,a.city_code,a.ag_name;
		  
			open c1
				fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit,@v1_agcd,@v1_dpcd,@v1_ag_name,@v1_ag_name_oth_lang,@v1_city_code,@v1_tehsil_taluka,@v1_dist_code,@v1_state_code,@v1_country_code,@v1_branch_code,@v1_addr1,@v1_ADDR2,@v1_ADDR3,@v1_PIN_CODE
				WHILE (@@FETCH_STATUS = 0)  Begin
				set @v_opbal =dbo.cir_accounts_cir_agency_opbal(@pcompcode, @punitcode,null,@v1_agcd, @v1_dpcd, @v_opdate, @pactype,@pdateformat,null,null)
		print('@')
				----for secutiry outstanding---
				If @pactype='SC' Begin
					set @v_opbal_sec	=dbo.cir_accounts_cir_agency_opbal(@pcompcode, @punitcode,null,@v1_agcd,@v1_dpcd,@v_opdate,'SC',@pdateformat,null,null)

					select @v_dbcramt	=sum(amount) from cir_rcphdr
					where comp_code = @pcompcode and unit_code= @punitcode and 
						agcd=@v1_agcd and dpcd=@v1_dpcd and recptdt>= @v_opdate and recptdt<=@v_todt and achd='SC'

					set @v_opbal_sec=isnull(@v_opbal_sec,0)+isnull(@v_dbcramt,0)
				End
				Else Begin
					set @v_opbal_sec =0
				End

				----for secutiry outstanding---
				set @v_dbcramt=0

				select @v_billamt=sum(amount) from cir_outmast
					where comp_code = @pcompcode and unit_code=@punitcode and 
						agcd=@v1_agcd and dpcd=@v1_dpcd and billdt >= @v_opdate and billdt<@v_frdt and 
						achd=@pactype and recptno is null

				select @v_dbcramt=sum(amount) from cir_rcpdet
					where comp_code=@pcompcode and unit_code=@punitcode and 
						agcd=@v1_agcd and dpcd=@v1_dpcd and recptdt>= @v_opdate and recptdt<@v_frdt and 
						achd=@pactype and billno is null

				set @v_opbal=isnull(@v_opbal,0)+isnull(@v_billamt,0)+isnull(@v_dbcramt,0)

				set @v_rec_seqno=isnull(@v_rec_seqno,0)+1

				insert into #cir_ledger_report
					(comp_code,unit_code,branch_code,agcd,dpcd,doctype,recptno,recptdt,amount,
					exec_code,remarks,chqno,chqdt,chq_bank,reason,debit_head,credit_head,
					billno,billdt,billamt,adjamt,leftamt,agname,rec_seqno,narr_line
					,ISSUE_DATE,PRODUCT,QUANTITY,UNIT_PRICE,addr1,ADDR2,ADDR3,PIN_CODE)
				values(@v1_comp_code,@v1_unit,@v1_branch_code,@v1_agcd,@v1_dpcd,null,null,@v_frdt,@v_opbal_sec,
					null,'Security Balance',null,null,null,null,null,null,
					null,null,null,null,null,@v1_ag_name,@v_rec_seqno,1,null,null,null,null,@v1_addr1,@v1_ADDR2,@v1_ADDR3,@v1_PIN_CODE)

				set @v_rec_seqno = isnull(@v_rec_seqno,0)+1

				set @v_runbal = @v_opbal
		            
				If @v_runbal>=0 Begin
					set @v_runbal_txt= CONVERT(VARCHAR, CONVERT( numeric(14, 2), @v_runbal ))--+' Dr.'
				End
				Else Begin
					set @v_runbal_txt=CONVERT(VARCHAR, CONVERT( numeric(14, 2), ABS(@v_runbal) ))--+' Cr.'
				End
		            
				insert into #cir_ledger_report
					(comp_code,unit_code,branch_code,agcd,dpcd,doctype,recptno,recptdt,amount,
					exec_code,remarks,chqno,chqdt,chq_bank,reason,debit_head,credit_head,
					billno,billdt,billamt,adjamt,leftamt,agname,rec_seqno,narr_line,ISSUE_DATE,PRODUCT,QUANTITY,UNIT_PRICE,addr1,ADDR2,ADDR3,PIN_CODE)
				values(@v1_comp_code,@v1_unit,@v1_branch_code,@v1_agcd,@v1_dpcd,null,null,@v_frdt,@v_opbal,
					null,'Opening Balance',null,null,null,null,null,null,
					null,null,null,null,null,@v1_ag_name,@v_rec_seqno,2,null,null,null,null,@v1_addr1,@v1_ADDR2,@v1_ADDR3,@v1_PIN_CODE)
		 
		 print('set')print(@v1_unit)print(@v1_agcd) print(@v1_dpcd) print(@v_frdt) print(@v_todt) print(@pactype)       

				declare c2 cursor for
					select u.comp_code comp_code,u.unit_code unit_code,u.agcd agcd,u.dpcd dpcd,u.doctype doctype,u.recptno recptno,u.recptdt recptdt,u.amount amount,u.chno chno,u.chdt chdt,u.chbank chbank,u.reason reason,
					u.narration narration,u.received_from received_from from 
					(select comp_code,unit_code,agcd,dpcd,doctype,recptno,recptdt,amount,chno,chdt,chbank,reason,remark narration,received_from from cir_rcphdr
						where comp_code=@v1_comp_code and unit_code=@v1_unit and agcd=@v1_agcd and dpcd=@v1_dpcd and recptdt 
							between @v_frdt and @v_todt and case isnull( achd,'NM')  when '' then 'NM' else achd end=@pactype
					union all
					select comp_code,unit_code,agcd,dpcd,'BIL' doctype,billno recptno,billdt recptdt,sum(bill_amount) amount,null chno,null chdt,null chbnk,'BILL' reason,
					'Bill Copy '+ cast(sum(bill_copy) as VARCHAR)+' Trade Disc. '+cast(sum(comm_amount) as VARCHAR) narration,null received_from from cir_bill
						where comp_code=@v1_comp_code and unit_code=@v1_unit and agcd=@v1_agcd and dpcd=@v1_dpcd and 
							billdt between @v_frdt and @v_todt and (@pactype='NM' or @pactype is null or @pactype ='')
							group by comp_code,unit_code,agcd,dpcd,billno,billdt
					/*union all
					select comp_code,unit_code,agcd,dpcd,doctyp doctype,billno recptno,billdt recptdt,sum(amount) amount,null chno,null chdt,null chbnk, reason,
					remark narration,null received_from from cir_outmast
						where comp_code=@v1_comp_code and unit_code=@v1_unit and agcd=@v1_agcd and dpcd=@v1_dpcd and 
							billdt between @v_frdt and @v_todt and @pactype='NM' and isnull(amount,0)>0 and billno is null 
							group by comp_code,unit_code,agcd,dpcd,billno,billdt,doctyp,reason,remark		*/
							)u
					order by recptdt,doctype,recptno
					
				declare @vbillno_rcr as varchar(40)
				declare @vbilldt_rcr as datetime
				--------daily transactions------------
					open c2
					fetch NEXT FROM c2 INTO @v2_comp_code,@v2_unit_code,@v2_agcd,@v2_dpcd,@v2_doctype,@v2_recptno,@v2_recptdt,@v2_amount,@v2_chno,@v2_chdt,@v2_chbank,@v2_reason,@v2_narration,@v2_received_from
					WHILE (@@FETCH_STATUS = 0) Begin
						
						If isnull(@v2_amount,0)<>0 Begin
							set @v_rec_seqno=isnull(@v_rec_seqno,0)+1
							set @v_narration=null
								If @v2_doctype='BIL' Begin
									set @v_narration=@v2_narration
									select distinct @v1_issue_date=TODT,@v1_product_code=PUBL,@v1_quantity=sum(BILL_COPY)
									,@v1_unit_price=COPY_RATE,@v1_commrate=COMM_RATE from cir_bill_det
									where COMP_CODE=@pcompcode and UNIT_CODE=@v2_unit_code and BILLNO=@v2_recptno and BILLDT=@v2_recptdt and AGCD=@v2_agcd and DPCD=@v2_dpcd
									group by TODT,PUBL,COPY_RATE,COMM_RATE
								End
								else If @v2_doctype='UCN' Begin
									set @v_narration=@v2_narration
									select distinct @v1_issue_date=SUPDATE,@v1_product_code=PUBL,@v1_quantity=sum(APR_BNR+APR_DAMAGE+APR_LATE_RECPT+APR_SHORT_RECPT+APR_UNSOLD)
									,@v1_unit_price=COPY_RATE,@v1_commrate=COMM_RATE from CIR_UNSOLD_DTL
									where COMP_CODE=@pcompcode and UNIT_CODE=@v2_unit_code and PROCESS_CRNO=@v2_recptno and AGCD=@v2_agcd and DPCD=@v2_dpcd
									group by SUPDATE,PUBL,COPY_RATE,COMM_RATE
								End
								else If @v2_doctype='RCR' Begin
									print('Payment received' + @v2_recptno)
									select @vbillno_rcr=max(BILLNO),@vbilldt_rcr=max(BILLDT) from CIR_OUTMAST where RECPTNO='BA1-13010001' and DOCTYP='RCR' and BILLNO is not null and BILLDT is not null 
									select distinct @v1_issue_date=TODT,@v1_product_code=PUBL,@v1_quantity=sum(BILL_COPY)
									,@v1_unit_price=COPY_RATE,@v1_commrate=COMM_RATE from cir_bill_det
									where COMP_CODE=@pcompcode and UNIT_CODE=@v2_unit_code and BILLNO=@vbillno_rcr and BILLDT=@vbilldt_rcr and AGCD=@v2_agcd and DPCD=@v2_dpcd
									group by TODT,PUBL,COPY_RATE,COMM_RATE
									
								end
								Else  
								Begin
										set @v1_issue_date=null
										set @v1_product_code=null
										set @v1_quantity=null
										set @v1_unit_price=null
										set @v1_commrate=null
									If @v2_narration is not null 
									Begin
										set @v_narration=@v2_narration
													
										If @v2_chno is not null and @v2_chno !=''
										Begin
											set @v_narration=@v_narration+' CHNO: '+@v2_chno
										End
										If @v2_chdt is not null and @v2_chdt !=''
										Begin
											set @v_narration=@v_narration+' CHDT: '+ 
											case @pdateformat when 'dd/mm/yyyy' then convert(varchar(10),@v2_chdt,103)  when 'mm/dd/yyyy' then convert(varchar(10),@v2_chdt,101) when 'yyyy/mm/dd' then convert(varchar(10),@v2_chdt,111) end
										End
										If @v2_chbank is not null and @v2_chbank !=''
										Begin
										select @v2_chbank=BANKNAME  from CIR_BANK_MAST where COMP_CODE=@pcompcode and BANKCODE=@v2_chbank
											set @v_narration=@v_narration+' CHBNK: '+@v2_chbank
										End
										If @v2_reason='CA0' and @v2_doctype='RCR' 
										Begin
											set @v_narration='By Cash '+@v_narration
										End
									End
								End
						End	
						Else 
						Begin print('test')
							If @v2_chno is not null and @v2_chno !=''
							Begin
								set @v_narration='CHNO: '+@v2_chno
							End
							If @v2_chdt is not null and @v2_chdt !=''
										Begin
											set @v_narration=@v_narration+' CHDT: '+ 
											case @pdateformat when 'dd/mm/yyyy' then convert(varchar(10),@v2_chdt,103)  when 'mm/dd/yyyy' then convert(varchar(10),@v2_chdt,101) when 'yyyy/mm/dd' then convert(varchar(10),@v2_chdt,111) end
										End
										If @v2_chbank is not null and @v2_chbank !=''
										Begin
										select @v2_chbank=BANKNAME  from CIR_BANK_MAST where COMP_CODE=@pcompcode and BANKCODE=@v2_chbank
											set @v_narration=@v_narration+' CHBNK: '+@v2_chbank
										End
							If @v2_reason='CA0' and @v2_doctype='RCR' 
							Begin
								set @v_narration='By Cash '+@v_narration
							End
						End

					set @v_remark_len = LEN(ISNULL(LTRIM(RTRIM(@v_narration)), '-'))
					set @v_amt=isnull(@v_amt,0)+isnull(@v2_amount,0)
					                    

					set @v_runbal = @v_runbal+isnull(@v2_amount,0)

					If @v_runbal>=0 Begin
						set @v_runbal_txt= CONVERT(VARCHAR, CONVERT( numeric(14, 2), @v_runbal ))--+' Dr.'
					End
					Else Begin
						set @v_runbal_txt=CONVERT(VARCHAR, CONVERT( numeric(14, 2), (@v_runbal) ))--+' Cr.'
					End
					                                        
					If isnull(@v2_amount,0)>=0 Begin
						set @v_dbamt=isnull(@v_dbamt,0)+isnull(@v2_amount,0)
					End
					If isnull(@v2_amount,0)<0 Begin
						set @v_cramt=isnull(@v_cramt,0)+abs(isnull(@v2_amount,0))
					End

					
					
		print('#')	
		print(@v_remark_len)
		print(@v_divident)	
		
		set @v1_unit_price=round(@v1_unit_price-((isnull(@v1_unit_price,0)*isnull(@v1_commrate,1))/100),3)
			
					insert into #cir_ledger_report
						  (comp_code,unit_code,branch_code,agcd,dpcd,doctype,recptno,recptdt,amount,
						  exec_code,remarks,chqno,chqdt,chq_bank,reason,debit_head,credit_head,
						  billno,billdt,billamt,adjamt,leftamt,agname,rec_seqno,narr_line
						  ,ISSUE_DATE,PRODUCT,QUANTITY,UNIT_PRICE,addr1,ADDR2,ADDR3,PIN_CODE)
					  values(@v1_comp_code, @v1_unit, @v1_branch_code, @v1_agcd, @v1_dpcd, @v2_doctype, @v2_recptno, @v2_recptdt, @v2_amount,
							 @v2_received_from,isnull(ltrim(rtrim(@v_narration)),'-'), @v2_chno, @v2_chdt, @v2_chbank, @v2_reason,null, @v_runbal_txt,
							 null, null, null, null, @v_runbal, @v1_ag_name, @v_rec_seqno, dbo.mod_function(@v_remark_len, @v_divident)
							 ,@v1_issue_date,@v1_product_code,@v1_quantity,@v1_unit_price,@v1_addr1,@v1_ADDR2,@v1_ADDR3,@v1_PIN_CODE)
		print('$')
					fetch NEXT FROM c2 INTO @v2_comp_code,@v2_unit_code,@v2_agcd,@v2_dpcd,@v2_doctype,@v2_recptno,@v2_recptdt,@v2_amount,@v2_chno,@v2_chdt,@v2_chbank,@v2_reason,
					@v2_narration,@v2_received_from
				End

				close c2
				deallocate c2
				
				--------daily transactions------------
		            
				
print('ggg')print(@v_runbal)
				set @v_rec_seqno=isnull(@v_rec_seqno,0)+1
				If @v_runbal>=0 Begin
					set @v_runbal_txt= CONVERT(VARCHAR, CONVERT( numeric(14, 2), @v_runbal )) --+' Dr.'
				End
				Else Begin
					set @v_runbal_txt= CONVERT(VARCHAR, CONVERT( numeric(14, 2), (@v_runbal) )) --+' Cr.'
				End
print('gggqq')print(@v_runbal_txt)
					insert into #cir_ledger_report
					(comp_code,unit_code,branch_code,agcd,dpcd,doctype,recptno,recptdt,amount,
					exec_code,remarks,chqno,chqdt,chq_bank,reason,debit_head,credit_head,
					billno,billdt,billamt,adjamt,leftamt,agname,rec_seqno,narr_line,ISSUE_DATE,PRODUCT,QUANTITY,UNIT_PRICE,addr1,ADDR2,ADDR3,PIN_CODE)
					values(@v1_comp_code, @v1_unit, @v1_branch_code, @v1_agcd, @v1_dpcd, null, null, @v_todt,isnull(@v_clbal,0),
					null,'Closing Balance',null,null,null,null,null,null,
					null,null,null,null,null, @v1_ag_name, @v_rec_seqno,1,@v1_issue_date,@v1_product_code,@v1_quantity,@v1_unit_price,@v1_addr1,@v1_ADDR2,@v1_ADDR3,@v1_PIN_CODE)

				If isnull(@v_opbal_sec,0)=0 and isnull(@v_opbal,0)=0 and @v_cramt=0 and @v_dbamt=0 Begin
				   delete from #cir_ledger_report where comp_code = @v1_comp_code and unit_code = @v1_unit and
					agcd = @v1_agcd and dpcd = @v1_dpcd
				End

				set @v_billamt=0 set @v_dbcramt=0 set @v_opbal=0 set @v_clbal=0 set @v_amt=0 set @v_runbal=0 set @v_cramt=0 set @v_dbamt=0 set @v_runbal_txt=null
		        
				fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit,@v1_agcd,@v1_dpcd,@v1_ag_name,@v1_ag_name_oth_lang,@v1_city_code,@v1_tehsil_taluka,@v1_dist_code,@v1_state_code,
					@v1_country_code,@v1_branch_code,@v1_addr1,@v1_ADDR2,@v1_ADDR3,@v1_PIN_CODE
				End

				close c1
				DEALLOCATE c1
		/*
		SELECT (SELECT distinct Comp_Name FROM  comp_mst WHERE Comp_Code  = a.comp_code) as "CNAME",
		COMP_CODE,UNIT_CODE,BRANCH_CODE,(select distinct "Branch_Name" from branch_mst where Comp_Code=a.Comp_Code and "Branch_Code"=a.BRANCH_CODE) "BRANCH_NAME",
		AGCD,DPCD,AGNAME,DBO.cir_get_agency_city(comp_code,unit_code,agcd,dpcd) CITY_NAME,
		DOCTYPE,RECPTNO,RECPTDT,
		CASE a.debit WHEN 'D' THEN a.amount END as DEBIT,
		CASE a.credit WHEN 'C' THEN a.amount END as CREDIT,
		EXEC_CODE,REMARKS,CHQNO,CHQDT,CHQ_BANK,REASON,DEBIT_HEAD,CREDIT_HEAD,BILLNO,BILLDT,BILLAMT,
		ADJAMT,LEFTAMT,REC_SEQNO,narr_line
		,a.ISSUE_DATE as ISSUE_DATE,(Select distinct PUBL_NAME from CIR_PUBL_MAST p where p.COMP_CODE=@pcompcode and p.PUBL=a.PRODUCT) as PRODUCT
		,a.QUANTITY,a.UNIT_PRICE,a.addr1,a.ADDR2,a.ADDR3,a.PIN_CODE
		FROM (SELECT comp_code,unit_code,branch_code,agcd,dpcd,agname,doctype,recptno,recptdt,
		CASE sign(amount) WHEN 1 THEN 'D' END as debit,
		CASE sign(amount) WHEN - 1 THEN 'C' END as credit,
		 ABS(amount) as amount,exec_code,remarks,chqno,chqdt,chq_bank,reason,debit_head,credit_head,
		 billno,billdt,billamt,adjamt,leftamt,rec_seqno,ISNULL(narr_line, 1) as narr_line
		 ,ISSUE_DATE,PRODUCT,QUANTITY,UNIT_PRICE,addr1,ADDR2,ADDR3,PIN_CODE
		FROM  #cir_ledger_report 
		WHERE comp_code  = @pcompcode AND unit_code  = @punitcode) a 
		ORDER BY rec_seqno 
		*/

			SELECT (SELECT distinct Comp_Name FROM  comp_mst WHERE Comp_Code  = a.comp_code) as "CNAME",
			COMP_CODE,UNIT_CODE,BRANCH_CODE
			,(select distinct "Branch_Name" from branch_mst where Comp_Code=a.Comp_Code and "Branch_Code"=a.BRANCH_CODE) "BRANCH_NAME",
			AGCD,DPCD,AGNAME,DBO.cir_get_agency_city(comp_code,unit_code,agcd,dpcd) CITY_NAME,
			case DOCTYPE
			when 'BIL' then 'INVOICE'
			when 'RCR' then 'PAYMENT'
			when 'UCN' then 
				case REASON 
				when 'NO0' then 'RETURN[Pulangan Biasa]'
				when 'UNSOLD CREDIT NOTE' then 'RETURN[Pulangan Biasa]'
				else isnull((Select reason_name from CIR_REASON_MST t where t.COMP_CODE=a.COMP_CODE and t.REASON_CODE=a.REASON ),'UNSOLD CREDIT NOTE') end
			when 'DN' then 
				case REASON
				when 'CH0' then 'Return '+remarks--'Return Cheque'				
				else isnull(REMARKS,(Select reason_name from CIR_REASON_MST t where t.COMP_CODE=a.COMP_CODE and t.REASON_CODE=a.REASON )) end 	
			when 'CN' then
				case isnull(REMARKS,'~')
				when '' then reason
				when '~' then reason				
				else REMARKS end
			end DOCTYPE
			,RECPTNO,case @pdateformat			
			when 'dd/mm/yyyy' then CONVERT(varchar(10),RECPTDT,103)
			when 'mm/dd/yyyy' then CONVERT(varchar(10),RECPTDT,101)
			when 'yyyy/mm/dd' then CONVERT(varchar(10),RECPTDT,111)
			end  RECPTDT,
			CASE a.debit WHEN 'D' THEN a.amount END as DEBIT,
			CASE a.credit WHEN 'C' THEN a.amount END as CREDIT,
			EXEC_CODE,REMARKS,CHQNO,CHQDT,CHQ_BANK,REASON,DEBIT_HEAD,CREDIT_HEAD,BILLNO,BILLDT,BILLAMT,
			ADJAMT,LEFTAMT,REC_SEQNO,narr_line
			,
			case @pdateformat			
			when 'dd/mm/yyyy' then CONVERT(varchar(10),a.ISSUE_DATE,103)
			when 'mm/dd/yyyy' then CONVERT(varchar(10),a.ISSUE_DATE,101)
			when 'yyyy/mm/dd' then CONVERT(varchar(10),a.ISSUE_DATE,111)
			end  
			 as ISSUE_DATE,(Select distinct PUBL_NAME from CIR_PUBL_MAST p where p.COMP_CODE=@pcompcode and p.PUBL=a.PRODUCT) as PRODUCT
			,a.QUANTITY,a.UNIT_PRICE,a.addr1,a.ADDR2,a.ADDR3,a.PIN_CODE
			FROM (SELECT comp_code,unit_code,branch_code,agcd,dpcd,agname,doctype,recptno,recptdt,
			CASE sign(amount) WHEN 1 THEN 'D' END as debit,
			CASE sign(amount) WHEN - 1 THEN 'C' END as credit,
			 ABS(amount) as amount,exec_code,remarks,chqno,chqdt,chq_bank,reason,debit_head,credit_head,
			 billno,billdt,billamt,adjamt,leftamt,rec_seqno,ISNULL(narr_line, 1) as narr_line
			 ,ISSUE_DATE,PRODUCT,QUANTITY,UNIT_PRICE,addr1,ADDR2,ADDR3,PIN_CODE
			FROM  #cir_ledger_report 
			WHERE comp_code  = @pcompcode AND unit_code  = @punitcode) a 
			ORDER BY rec_seqno 

			SELECT (SELECT Comp_Name FROM  comp_mst WHERE Comp_Code  = a.comp_code) as "CNAME",
			COMP_CODE,AGCD,DPCD,AGNAME,(SELECT COUNT(*) FROM 
			( SELECT     comp_code,     unit_code,     branch_code,     agcd,     dpcd,     agname,     doctype,     recptno,     recptdt,        
			CASE sign(amount)     WHEN 1 THEN 'D' END as DEBIT,
			CASE sign(amount)     WHEN - 1 THEN 'C'    END as CREDIT,ABS(amount) as AMOUNT,     rec_seqno,NARR_LINE
			FROM  #cir_ledger_report   WHERE  comp_code  = @pcompcode   AND unit_code  = @punitcode ) adv_alias_1  
			WHERE  adv_alias_1.comp_code  = a.comp_code  AND adv_alias_1.agcd  = a.agcd  AND adv_alias_1.dpcd  = a.dpcd  AND adv_alias_1.agname  = a.agname ) adv_count_value,
			ISNULL(SUM(CONVERT(FLOAT, narr_line)), 0) sum_narr
			FROM (SELECT comp_code,unit_code,branch_code,agcd,dpcd,agname,doctype,recptno,recptdt,
			CASE sign(amount) WHEN 1 THEN 'D' END as debit,
			CASE sign(amount) WHEN - 1 THEN 'C' END as credit,ABS(amount) as amount,rec_seqno,narr_line
			FROM  #cir_ledger_report 
			WHERE comp_code  = @pcompcode AND unit_code  = @punitcode) a 
			group by a.comp_code,a.agcd,a.dpcd,a.agname
			ORDER BY comp_code,agcd,dpcd,agname 
	end
	select * from #cir_ledger_report
	drop table #cir_ledger_report

	drop table #cir_summary_statement
	
END



/////////////////////////////////////////////////////////////////////END/////////////////////////////////////////////





                                                                     
        /**6 feb***/                                                                
                                                                     
                                                                                
                                                                     
                                                                     
                                             
ALTER procedure [dbo].[CIR_RECEIPT_DATA_MOVE]
    @pcompcode       as varchar(200),
    @punitcode       as varchar(200),
    @pdoctype        as varchar(200),
    @precptdt        as varchar(200),
    @precptno        as varchar(200),
    @pdateformate    as varchar(200),
    @puserid         as varchar(200),
    @prectype        as varchar(200),--it is for agency receipt or distraibution receipt
    @pextra1         as varchar(200),
    @pextra2         as varchar(200),
    @pextra3         as varchar(200),
    @pextra4         as varchar(200),
    @pextra5         as varchar(200)
as
declare @v_recno numeric(10)
declare @v_dt    datetime
begin
    set @v_dt=dbo.convert_user_date('/', @precptdt,@pdateformate)
    
    if upper(@prectype)='D' Begin
        insert into cir_rcphdr_dis(comp_code,unit_code,doctype,agcd,dpcd,recptno,
            recptdt,chno,chdt,chbank,amount,oth_amount,ccdp,ccds,rcdp,rcds,ocdp,ocds,reason,
            remark,achd,voucherno,voucherdt,vchtype,publ,received_from,tdsrate,tdsamt,staxrate,
              staxamt,status,ref_recptno,ref_recptdt,ref_amount,ref_doctype,cancel_user,cancel_datetime,
              cancel_remark,userid,creation_datetime,branch_code,prov_rec_no,prov_rec_dt,remark_oth,MANNUALRECPTNO)
          select comp_code,unit_code,doctype,agcd,dpcd,recptno,
          recptdt,chno,
          CASE chdt WHEN '1900-01-01 00:00:00.000' THEN NULL else chdt END chdt,
          chbank,amount,oth_amount,ccdp,ccds,rcdp,rcds,ocdp,ocds,reason,
          remark,achd,voucherno,voucherdt,vchtype,publ,received_from,tdsrate,tdsamt,staxrate,
          staxamt,status,ref_recptno,
          CASE ref_recptdt WHEN '1900-01-01 00:00:00.000' THEN NULL else ref_recptdt END ref_recptdt,
          ref_amount,ref_doctype,cancel_user,cancel_date,
          cancel_remark,userid,creation_date,branch_code,prov_rec_no,
          CASE prov_rec_dt WHEN '1900-01-01 00:00:00.000' THEN NULL else prov_rec_dt END prov_rec_dt,
          remark_oth,MANNUALRECPTNO from cir_rcphdr_dis_temp
            where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
                    recptno=@precptno and recptdt=@v_dt
      
      delete from CIR_RCPHDR_DIS_TEMP where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
                    recptno=@precptno and recptdt=@v_dt
      
          insert into cir_rcpdet_dis(comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, recptno, recptdt, 
                            payfor, achd, publ, chno, chbnk, chdt, amount, reason, remark, voucherno, voucherdt, 
                            tds, stax, status, usrid, creation_datetime, branch_code)
          select comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, recptno, recptdt, 
                            payfor, achd, publ, chno, chbnk, 
                            CASE chdt WHEN '1900-01-01 00:00:00.000' THEN NULL else chdt END chdt, 
                            amount, reason, remark, voucherno, voucherdt, 
                            tds, stax, status, usrid, creation_date, branch_code from cir_rcpdet_dis_temp
            where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and 
                    recptno=@precptno and recptdt=@v_dt

		delete from cir_rcpdet_dis_temp
            where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and 
                    recptno=@precptno and recptdt=@v_dt

        insert into cir_outmast_dis (comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, recptno, recptdt, 
                        achd, publ, chno, chbnk, chdt, amount, reason, remark, voucherno, voucherdt, balance, 
                        tds, stax, status, cancel_userid, cancel_dt, cancel_remark, usrid, creation_datetime, bill_sec_amt, branch_code)
        select comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, recptno, recptdt, 
                        achd, publ, chno, chbnk, 
                        CASE chdt WHEN '1900-01-01 00:00:00.000' THEN NULL else chdt END chdt, 
                        amount, reason, remark, voucherno, voucherdt, balance, 
                        tds, stax, status, cancel_userid, cancel_dt, cancel_remark, usrid, creation_date, bill_sec_amt, branch_code from cir_outmast_dis_temp
             where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and 
                    recptno=@precptno and recptdt=@v_dt
		
		 delete from cir_outmast_dis_temp
             where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and 
                    recptno=@precptno and recptdt=@v_dt
		
			select @v_recno=count(*) from cir_rcpt_document_dis_temp
			where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
						recptno=@precptno and recptdt=@v_dt
			If @v_recno>0 Begin		                    
				insert into cir_rcpt_document_dis(comp_code, unit_code, doctype, recptno, recptdt, filename, created_by, created_dt)
				select comp_code, unit_code, doctype, recptno, recptdt, filename, created_by, created_dt from cir_rcpt_document_dis_temp
				where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
							recptno=@precptno and recptdt=@v_dt
			End

			
			insert into cir_rcp_unadj_dis(comp_code,unit_code,agcd,dpcd,doctyp,recptno,recptdt,publ,amount,created_by,created_date,updated_by,updated_date)
			select comp_code,unit_code,agcd,dpcd,doctyp,recptno,recptdt,publ,amount,created_by,created_date,updated_by,updated_date from cir_rcp_unadj_temp_dis
			where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and recptno=@precptno
			
			delete from cir_rcp_unadj_temp_dis
			where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and recptno=@precptno
			
		End
    else Begin
        insert into cir_rcphdr(comp_code,unit_code,doctype,agcd,dpcd,recptno,
            recptdt,chno,chdt,chbank,amount,oth_amount,ccdp,ccds,rcdp,rcds,ocdp,ocds,reason,
            remark,achd,voucherno,voucherdt,vchtype,publ,received_from,tdsrate,tdsamt,staxrate,
              staxamt,status,ref_recptno,
              ref_recptdt,
              ref_amount,ref_doctype,cancel_user,cancel_date,
              cancel_remark,userid,creation_date,branch_code,prov_rec_no,prov_rec_dt,remark_oth,MANNUALRECPTNO)
          select comp_code,unit_code,doctype,agcd,dpcd,recptno,
          recptdt,chno,
          CASE chdt WHEN '1900-01-01 00:00:00.000' THEN NULL else chdt END chdt,
          chbank,amount,oth_amount,ccdp,ccds,rcdp,rcds,ocdp,ocds,reason,
          remark,achd,voucherno,voucherdt,vchtype,publ,received_from,tdsrate,tdsamt,staxrate,
          staxamt,status,ref_recptno,
          CASE ref_recptdt WHEN '1900-01-01 00:00:00.000' THEN NULL else ref_recptdt END  ref_recptdt,
          ref_amount,ref_doctype,cancel_user,cancel_date,
          cancel_remark,userid,creation_date,branch_code,prov_rec_no,
          CASE prov_rec_dt WHEN '1900-01-01 00:00:00.000' THEN NULL else prov_rec_dt END prov_rec_dt,remark_oth,MANNUALRECPTNO from cir_rcphdr_temp
            where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
                    recptno=@precptno and recptdt=@v_dt
      
          insert into cir_rcpdet(comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, recptno, recptdt, 
                            payfor, achd, publ, chno, chbnk, chdt, amount, reason, remark, voucherno, voucherdt, 
                            tds, stax, status, usrid, creation_date, branch_code)
          select comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, recptno, recptdt, 
                            payfor, achd, publ, chno, chbnk, 
                            CASE chdt WHEN '1900-01-01 00:00:00.000' THEN NULL else chdt END chdt, 
                            amount, reason, remark, voucherno, voucherdt, 
                            tds, stax, status, usrid, creation_date, branch_code from cir_rcpdet_temp
            where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and 
                    recptno=@precptno and recptdt=@v_dt

        insert into cir_outmast (comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, recptno, recptdt, 
                        achd, publ, chno, chbnk, chdt, amount, reason, remark, voucherno, voucherdt, balance, 
                        tds, stax, status, cancel_userid, cancel_dt, cancel_remark, usrid, creation_date, bill_sec_amt, branch_code)
        select comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, recptno, recptdt, 
                        achd, publ, chno, chbnk, 
                        CASE chdt WHEN '1900-01-01 00:00:00.000' THEN NULL else chdt END chdt, 
                        amount, reason, remark, voucherno, voucherdt, balance, 
                        tds, stax, status, cancel_userid, cancel_dt, cancel_remark, usrid, creation_date, bill_sec_amt, branch_code from cir_outmast_temp
             where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and 
                    recptno=@precptno and recptdt=@v_dt
	
		insert into cir_rcpt_document(comp_code, unit_code, doctype, recptno, recptdt, filename, created_by, created_dt)
		select comp_code, unit_code, doctype, recptno, recptdt, filename, created_by, created_dt from cir_rcpt_document_temp
		where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
     	recptno=@precptno and recptdt=@v_dt
		
		insert into cir_rcp_unadj(comp_code,unit_code,agcd,dpcd,doctyp,recptno,recptdt,publ,amount,created_by,created_date,updated_by,updated_date)
		select comp_code,unit_code,agcd,dpcd,doctyp,recptno,recptdt,publ,amount,created_by,created_date,updated_by,updated_date from cir_rcp_unadj_temp
		where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and recptno=@precptno
		
		delete from cir_rcphdr_temp where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
		recptno=@precptno and recptdt=@v_dt
		    
		delete from cir_rcpdet_temp
		where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and 
		recptno=@precptno and recptdt=@v_dt

		delete from cir_outmast_temp
		where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and 
		recptno=@precptno and recptdt=@v_dt

		delete from cir_rcpt_document_temp
		where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
		recptno=@precptno and recptdt=@v_dt

		delete from cir_rcp_unadj_temp
		where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and recptno=@precptno
	
    end           
    
-----  this part starts from here for blocking agency for debit note-----------------
	declare @v_doctype_BU as varchar(10) -- rcpt_hdr table 
	declare @v_reason_BU as varchar(10) -- rcpt_hdr table 
	declare @v_agcd_BU as varchar(10) -- rcpt_hdr table 
	declare @v_dpcd_BU as varchar(10) -- rcpt_hdr table 
	declare @v_nooftimes_BU as int  -- reason_mast	
	declare @v_noofdays_BU as int  -- reason_mast
	declare @v_NO_OF_CHQbnc_pref as int  -- preference table
	declare @v_CIR_DAYS_CHQ_pref as int  -- preference table
	
	declare @v_cnt_specific_reason as int	
	declare @vod_payment as varchar(3)	
	declare @no_of_days_pref as int-- for preferrence / anniversary date
	
	set @vod_payment='N'
	set @no_of_days_pref=365
	
	select @v_doctype_BU = DOCTYPE,@v_agcd_BU=agcd,@v_dpcd_BU=DPCD from cir_rcphdr where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
	recptno=@precptno and recptdt=@v_dt
	
	if @v_doctype_BU ='DN' begin	
		
		select @v_reason_BU = REASON from cir_rcphdr where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
		recptno=@precptno and recptdt=@v_dt
		select @v_nooftimes_BU=isnull(no_of_times,0),@v_noofdays_BU=isnull(VALID_DAYS,0) from CIR_REASON_MST where REASON_CODE=@v_reason_BU and DOC_TYPE='DN'
		select @v_NO_OF_CHQbnc_pref=isnull(CIR_NO_OF_CHQBOUNCE,0),@v_CIR_DAYS_CHQ_pref=isnull(CIR_DAYS_CHQBOUNCE,0) from preferrences where comp_code=@pcompcode
		
		if @v_nooftimes_BU ='' 
		begin
			set @v_nooftimes_BU=0
		end	
		if @v_noofdays_BU ='' 
		begin
			set @v_noofdays_BU=0
		end
		if @v_NO_OF_CHQbnc_pref ='' 
		begin
			set @v_NO_OF_CHQbnc_pref=0
		end
		if @v_CIR_DAYS_CHQ_pref ='' 
		begin
			set @v_CIR_DAYS_CHQ_pref=0
		end
		----------------- in case of immediate effect of any reason to suspend the agency---------------
		select @v_cnt_specific_reason=count(*) from cir_rcphdr where comp_code=@pcompcode 
		and unit_code=@punitcode and doctype=@pdoctype and REASON=@v_reason_BU and
		recptno=@precptno and recptdt between dateadd(dd,-1*@v_noofdays_BU,@v_dt) and @v_dt
		
		if @v_nooftimes_BU =0 or @vod_payment='Y' -- 0 for stop payment and over due payment
		begin
					
			update cir_agmast set SUSPEND='Y',SUSPEND_DATE=GETDATE(),SUSPEND_TYPE='CH0' where COMP_CODE=@pcompcode 
			and AGCD=@v_agcd_BU and DPCD=@v_dpcd_BU			
			update CIR_AGENCY_PAYMODE set PAYMODE_ACTIVE='N',BLOCK_BY_A_M=null,UPDATED_DT = getdate()  where COMP_CODE=@pcompcode and AGCD=@v_agcd_BU and DPCD=@v_dpcd_BU
			and PAYMODE='CH0'
		end
		else if @v_nooftimes_BU < ISNULL(@v_cnt_specific_reason,0) or @vod_payment='Y' -- 0 for stop payment and over due payment
		begin
						
			update cir_agmast set SUSPEND='Y',SUSPEND_DATE=GETDATE(),SUSPEND_TYPE='CH0' where COMP_CODE=@pcompcode 
			and AGCD=@v_agcd_BU and DPCD=@v_dpcd_BU			
			update CIR_AGENCY_PAYMODE set PAYMODE_ACTIVE='N',BLOCK_BY_A_M=null,UPDATED_DT = getdate()  where COMP_CODE=@pcompcode and AGCD=@v_agcd_BU and DPCD=@v_dpcd_BU
			and PAYMODE='CH0'
		end
		-------------  end here ------------------------
		declare @v_cnt_specific_period as int
		----------------- in case of cheque bounce specific times in specic period block chq payments only for tht period---------------
		select @v_cnt_specific_period=count(*) from cir_rcphdr where comp_code=@pcompcode 
		and unit_code=@punitcode and doctype=@pdoctype and
		recptno=@precptno and recptdt between dateadd(dd,-1*@v_CIR_DAYS_CHQ_pref,@v_dt) and @v_dt
		
		if @v_NO_OF_CHQbnc_pref < ISNULL(@v_cnt_specific_period,0) 
		begin
						
			update CIR_AGENCY_PAYMODE set PAYMODE_ACTIVE='N',BLOCK_BY_A_M='A',UPDATED_DT = getdate() where COMP_CODE=@pcompcode and AGCD=@v_agcd_BU and DPCD=@v_dpcd_BU
			and PAYMODE='CH0'
		end
		---------------  end here -----------------------
	end
       
-----  this part ends here for blocking agency for debit note  ----------------------


-----  this part starts from here for cheque dishonoured  debit note reverse entry-----------------       

declare @v_refrecnum as varchar(20)
declare @v_refrecdt  as datetime 
declare @v_refrecamt  as numeric(14,2)
declare @vrefdoctype as varchar(20)
declare @v_doctype as varchar(20)
declare @v_reason as varchar(20)

declare @rec_count as int
declare @rec_count1 as int
declare @vag_main_code as varchar(30)
declare @vag_sub_code as varchar(30)
declare @vunit as varchar(30)
declare @rec_amount as numeric(14,2)
declare @rem_amount as numeric(14,2)


/******************************  parameters for cursor*******************************/
declare @c1_branch			as varchar(20)
declare @c1_billno			as varchar(50)
declare @c1_billdt			as datetime
declare @c1_amount			as float
declare @c1_unit			as varchar(20)
declare @c1_agcode			as varchar(30)
declare @c1_doctype			as varchar(20)
declare @c1_reason			as varchar(20)
declare @c1_recptno			as varchar(50)
declare @c1_recptdt			as datetime
declare @c1_chno			as varchar(30)
declare @c1_chdt			as datetime
declare @c1_bank			as varchar(20)
declare @c1_voucherno		as varchar(30)
declare @c1_voucherdate		as datetime
declare @c1_comp_code		as varchar(20)
declare @c1_userid			as varchar(20)
declare @c1_pripub			as varchar(20)
declare @c1_tds				as float
declare @c1_received_region as varchar(30)
declare @c1_stax				as float
declare @c1_ag_main_code	as varchar(20)
declare @c1_ag_sub_code		as varchar(30)
declare @c1_remark			as varchar(200)
declare @v_print_center as varchar(8)

select @v_refrecnum= REF_RECPTNO, @v_refrecdt=REF_RECPTDT,@v_refrecamt=AMOUNT,@v_doctype=DOCTYPE,@v_reason=REASON,
@vag_main_code=AGCD ,@vag_sub_code=DPCD,@vunit=UNIT_CODE,@vrefdoctype=REF_DOCTYPE
from CIR_RCPHDR where COMP_CODE=@pcompcode and RECPTNO=@precptno and RECPTDT=@v_dt and DOCTYPE='DN'
print('***')
print(@precptno)print(@v_dt)print(@v_refrecamt)print(@v_doctype)print(@v_reason)print(@v_refrecnum)print(@v_refrecdt)
print('start')
if isnull(@v_refrecamt,0)>0 and @v_doctype ='DN' and  @v_reason='CH0' and @v_refrecnum is not null and @v_refrecdt is not null 
begin
		select @rec_count=count(*) from cir_rcphdr where comp_code=@pcompcode and UNIT_CODE=@vunit  and recptno=@v_refrecnum and
        AGCD=@vag_main_code and DPCD=@vag_sub_code and amount<>0
		
		print(@vunit)print(@vrefdoctype)print(@v_refrecnum)print(@vag_sub_code)print(@vag_main_code)
        
        select @rec_count1=count(*) from CIR_OUTMAST where comp_code=@pcompcode and UNIT_CODE=@vunit and doctyp=@vrefdoctype and recptno=@v_refrecnum and
        agcd=@vag_main_code and DPCD=@vag_sub_code and billno is not null and amount<>0
		print('start_1')		
		if isnull(@rec_count,0)>0
		begin
			print('start_2')
			print(@vunit)print(@vrefdoctype)print(@v_refrecnum)print(@vag_sub_code)print(@vag_main_code)
			
			select @rec_amount=abs(amount) from cir_rcphdr where comp_code=@pcompcode and UNIT_CODE=@vunit and recptno=@v_refrecnum and
			agcd=@vag_main_code and dpcd=@vag_sub_code and amount<>0
			
			declare c1 cursor for
				select branch_code,billno,billdt,amount,unit_code,'',doctyp,reason,recptno,recptdt							
				,chno,chdt,chbnk,voucherno,voucherdt,comp_code,usrid,publ,tds						
				,'',stax,agcd,dpcd,remark from cir_outmast
				where comp_code=@pcompcode and unit_code=@vunit and recptno=@v_refrecnum and
				agcd=@vag_main_code and dpcd=@vag_sub_code AND DOCTYP !='DN'--and amount<>0 
				order by recptdt,recptno,billdt,billno
			
			if @rec_amount=@v_refrecamt 
			begin --3
                set @rem_amount=@v_refrecamt
                print('start_3')
                OPEN c1 
				fetch NEXT FROM c1 INTO	@c1_branch,@c1_billno,@c1_billdt,@c1_amount,@c1_unit,@c1_agcode,@c1_doctype,@c1_reason,@c1_recptno,@c1_recptdt,@c1_chno,@c1_chdt,@c1_bank,@c1_voucherno,@c1_voucherdate,@c1_comp_code,@c1_userid,@c1_pripub,@c1_tds,@c1_received_region,@c1_stax,@c1_ag_main_code,@c1_ag_sub_code,@c1_remark
                WHILE (@@FETCH_STATUS = 0) 
				BEGIN
					 --set @vbillamt=abs(@c1_amount)
					 print('start_4')
					 if @c1_billno is not null and @c1_billdt is not null 
					 begin --4
					 print('start_5')print(@c1_billno)print(@c1_billdt)print('AAA')
						delete from CIR_OUTMAST where comp_code=@c1_comp_code and unit_code=@c1_unit 
						and agcd=@c1_ag_main_code and dpcd=@c1_ag_sub_code and BILLNO=@c1_billno and BILLDT=@c1_billdt and RECPTNO is not null
						and RECPTNO=@v_refrecnum					
						delete from CIR_RCPDET where comp_code=@c1_comp_code and unit_code=@c1_unit 
						and agcd=@c1_ag_main_code and dpcd=@c1_ag_sub_code and BILLNO=@c1_billno and BILLDT=@c1_billdt and RECPTNO is not null					
						and RECPTNO=@v_refrecnum
					 end
					 else --if abs(@c1_amount)=ABS(@v_refrecamt) --4
					 begin
						/*---if ref recipt amount in hand greater than zero amount---*/
						print('start_6')
                        insert into cir_outmast (UNIT_CODE,doctyp,reason , BRANCH_CODE , billno , billdt , recptno , recptdt ,
                                                 chno , chdt , chbnk , voucherno , voucherdt , amount , comp_code , USRID ,
                                                 publ , tds , stax,agcd,dpcd,remark)
                                          values(@c1_unit,'RCR',@c1_reason,@c1_branch,@precptno,@v_dt,@c1_recptno,@c1_recptdt,
                                                 @c1_chno , @c1_chdt ,@c1_bank,@c1_voucherno,@c1_voucherdate,-1*@v_refrecamt,@c1_comp_code,@c1_userid,
                                                 @c1_pripub,@c1_tds,@c1_stax,@c1_ag_main_code,@c1_ag_sub_code,@c1_remark)                                                 
                        
                        --update cir_outmast set amount=0 where comp_code=@c1_comp_code and unit_code=@c1_unit and recptno=@c1_recptno
                        --and recptdt=@c1_recptdt and doctyp='RCR' and billno is null and billdt is null
                        
                        insert into cir_rcpdet(UNIT_CODE,doctyp,reason , BRANCH_CODE , billno , billdt , recptno , recptdt ,
                                                 chno , chdt , chbnk , voucherno , voucherdt , amount , comp_code , USRID ,
                                                 publ , tds , stax,agcd,dpcd,remark)
                                          values(@c1_unit,'RCR',@c1_reason,@c1_branch,@precptno,@v_dt,@c1_recptno,@c1_recptdt,
                                                 @c1_chno , @c1_chdt ,@c1_bank,@c1_voucherno,@c1_voucherdate,-1*@v_refrecamt,@c1_comp_code,@c1_userid,
                                                 @c1_pripub,@c1_tds,@c1_stax,@c1_ag_main_code,@c1_ag_sub_code,@c1_remark)
                        print('@v_refrecamt')print(@v_refrecamt)
                        /*---if ref recipt amount in hand greater than zero amount---*/
					 end
					 
				
				fetch NEXT FROM c1 INTO	@c1_branch,@c1_billno,@c1_billdt,@c1_amount,@c1_unit,@c1_agcode,@c1_doctype,@c1_reason,@c1_recptno,@c1_recptdt,@c1_chno,@c1_chdt,@c1_bank,@c1_voucherno,@c1_voucherdate,@c1_comp_code,@c1_userid,@c1_pripub,@c1_tds,@c1_received_region,@c1_stax,@c1_ag_main_code,@c1_ag_sub_code,@c1_remark
				END
				close c1
				deallocate c1
                print('start_7')
                
                
			end
			print('start_8')
		end
	print('start_9')
end



-----  this part ends here for cheque dishonoured  debit note reverse entry -----------------
    if upper(@prectype)='D' Begin
        select @v_recno=count(*) from cir_rcphdr_dis 
            where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
                recptno=@precptno
		End
    else Begin
        select @v_recno=count(*) from cir_rcphdr 
            where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
                recptno=@precptno 
    End

    if isnull(@v_recno,0)>0 Begin		
        select @v_recno as "RECNO"
		End
     else Begin
        select 0 as "RECNO"
     End

end


                                                              
                                             
ALTER PROCEDURE [dbo].[cir_ledger_ageing]
@pcomp_code varchar(20),
@punit_code varchar(20),
@pbran_code varchar(20),
@pzone_code varchar(30),
@pregion_code varchar(30),
@pdist_code varchar(20),
@ptaluka_code varchar(20),
@pagtype varchar(50),
@pagclass varchar(50),
@pag_main_code varchar(50),
@pag_sub_code varchar(50),
@paging_by varchar(50),
@pasondt datetime,
@pdebitupto_date datetime,
@pcreditupto_date datetime,
@pdateformat varchar(20),
@puserid varchar(20),
@pextra1 varchar(20),
@pextra2 varchar(20),
@pextra3 varchar(30),
@pextra4 varchar(30),
@pextra5 varchar(50)
As

--------- slabs end

declare @ptill_days1 as varchar(20)
declare @ptill_days2 as varchar(20)
declare @ptill_days3 as varchar(30)
declare @ptill_days4 as varchar(30)
declare @ptill_days5 as varchar(50)
declare @ptill_days6 as varchar(50)
declare @ptill_current as varchar(50)
---------------- slabs

declare @vtodt as datetime
declare @vasondt as datetime
declare @v_dt as datetime
declare @v_ondt as datetime
declare @v_days numeric(10);
declare @v_pending_rcpt_amt as numeric(14,2)
declare @v_amt as numeric(14,2);
declare @v_amt030 as numeric(14,2);
declare @v_amt3160 as numeric(14,2);
declare @v_amt6190 as numeric(14,2);
declare @v_amt91120 as numeric(14,2);
declare @v_amt121180 as numeric(14,2);
declare @v_amt181 as numeric(14,2);
declare @v_amtcur as numeric(14,2);
declare @debit_amt_030 as numeric(14,2) --debit amt for slab 1 days
declare @debit_amt_3160 as numeric(14,2) --debit amt for slab 2 days
declare @debit_amt_6190 as numeric(14,2) --debit amt for slab 3 days
declare @debit_amt_91120 as numeric(14,2) --debit amt for slab 4 days
declare @debit_amt_121180 as numeric(14,2) --debit amt for >slab 5 days
declare @debit_amt_181 as numeric(14,2) --debit amt for >slab 6 days
declare @debit_amt_cur as numeric(14,2) --debit amt for >current
declare @bill_pending_amt as numeric(14,2)
declare @rcpt_pending_amt as numeric(14,2) --pending receipt amount

CREATE TABLE #cir_temp_ageing
(
	COMP_CODE VARCHAR(8),
	UNIT_CODE VARCHAR(8),
	BRAN_CODE VARCHAR(8),
	AGCD VARCHAR(8),
	DPCD VARCHAR(8),
	AG_NAME VARCHAR(100),
	CITY_NAME VARCHAR(100),
	PENDING_AMT NUMERIC(14,2),
	CUR_AMT NUMERIC(14,2),
	SLAB_1 NUMERIC(14,2),
	SLAB_2 NUMERIC(14,2),
	SLAB_3 NUMERIC(14,2),
	SLAB_4 NUMERIC(14,2),
	SLAB_5 NUMERIC(14,2),
	SLAB_6 NUMERIC(14,2),
	ON_ACAMT NUMERIC(14,2),
	RECT_PENDING NUMERIC(14,2),
	SESSIONID NUMERIC(14),
	PUBNAME VARCHAR(200),
	ageing varchar(1)
)

set @debit_amt_030 =0 --debit amt for slab 1 days
set @debit_amt_3160 =0 --debit amt for slab 2 days
set @debit_amt_6190 =0 --debit amt for slab 3 days
set @debit_amt_91120 =0 --debit amt for slab 4 days
set @debit_amt_121180 =0 --debit amt for >slab 4 days
set @debit_amt_181 =0 --debit amt for >slab 4 days
set @debit_amt_cur =0 --debit amt for >current
set @bill_pending_amt =0
set @rcpt_pending_amt =0 --pending receipt amount
-- cursor cur_agency variables

declare @rec_agency_comp_code as varchar(30)
declare @rec_agency_agcd as varchar(20)
declare @rec_agency_dpcd as varchar(30)
declare @rec_agency_agency_name as varchar(300)
declare @rec_agency_city_code as varchar(200)
declare @rec_agency_city_name as varchar(200)
declare @rec_agency_credit_days as int
declare @rec_agency_branch_name as varchar(50)
declare @rec_agency_ageing_type as varchar(1)
--@rec_agency_comp_code,@rec_agency_agcd,@rec_agency_dpcd,@rec_agency_agency_name,@rec_agency_city_code,@rec_agency_city_name,

--@rec_agency_credit_days,@rec_agency_branch_name,@rec_agency_ageing_type

declare cur_agency_1 cursor for
select m.Comp_Code ,m.agcd ,m.dpcd ,m.ag_name ,m.City_Code,c.city_name,m.credit_days,m.branch_code,m.ageing_type
from cir_agmast m,cir_city_mast c
where m.comp_code=c.comp_code and m.comp_code=@pcomp_code
and m.unit=@punit_code and m.city_code=c.city_code
and (m.Dist_Code=@pdist_code or @pdist_code is null or @pdist_code ='')
and (m.tehsil_taluka=@ptaluka_code or @ptaluka_code is null or @ptaluka_code ='')
and (m.agcd=@pag_main_code or @pag_main_code is null or @pag_main_code ='')
and (m.dpcd=@pag_sub_code or @pag_sub_code is null or @pag_sub_code ='')

if @pdebitupto_date is null or @pdebitupto_date=''
begin
	set @pdebitupto_date =@pasondt
end
if @pcreditupto_date is null or @pcreditupto_date=''
begin
	set @pcreditupto_date =@pasondt
end
if @pasondt is null or @pasondt =''
begin
	set @pasondt=@pcreditupto_date
end

declare @fetch_protype as varchar(20)
declare @fetch_pub as varchar(20)
-- cursor v_bill variables

declare @v_bill_billno as varchar(50)
declare @v_bill_billdt as varchar(30)
declare @v_bill_bill_amt as numeric(15,2)
-- cursor v_pending_rcpt variables

declare @v_pending_rcpt_ag_main_code as varchar(30)
declare @v_pending_rcpt_ag_sub_code as varchar(50)
declare @v_pending_rcpt_amount as numeric(15,2)
declare @fetch_pubname as varchar(200)
declare @fetch_pubtype as varchar(200)
--SELECT 'cursor has ' + CAST(@@CURSOR_ROWS AS VARCHAR) + ' rows'

declare @v_mcnt1 as datetime
declare @v_mcnt2 as datetime
declare @v_mcnt3 as datetime
declare @v_mcnt4 as datetime
declare @v_mcnt5 as datetime
declare @vtill_days1 AS int
declare @vtill_days2 AS int
declare @vtill_days3 AS int
declare @vtill_days4 AS int
declare @vtill_days5 AS int
declare @vrec_agency_ageing_type as varchar(10)

	open cur_agency_1
		fetch NEXT FROM cur_agency_1 INTO @rec_agency_comp_code,@rec_agency_agcd,@rec_agency_dpcd,@rec_agency_agency_name,@rec_agency_city_code,@rec_agency_city_name,@rec_agency_credit_days,@rec_agency_branch_name,@rec_agency_ageing_type
		WHILE (@@FETCH_STATUS = 0)
		begin
			declare @day as int
			
			declare cur_agency cursor for
			select distinct publ from cir_supply where comp_code=@pcomp_code and agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd order by publ
			--select distinct dbo.cir_get_publ_type(comp_code,publ,'C','') publ from cir_supply where comp_code=@pcomp_code and agcd=@pag_main_code and dpcd=@pag_sub_code order by publ
			print
			('@rec_agency_ageing_type')print(@rec_agency_ageing_type)
			open cur_agency
				fetch NEXT FROM cur_agency INTO @fetch_pub
				WHILE (@@FETCH_STATUS = 0)
				BEGIN 
					print('dddddd') print(@fetch_pub)
					
					select distinct @fetch_protype=pro_type,@fetch_pubname=PUBL_NAME,@fetch_pubtype=
					(Select pubname from pub_type_mast where Comp_Code=@pcomp_code and pub_type_mast.pubtypecode=CIR_PUBL_MAST.PRO_TYPE)
					from CIR_PUBL_MAST where COMP_CODE=@pcomp_code and publ=@fetch_pub					
					
					print('@fetch_protype')print(@fetch_protype)
					print('@@fetch_pubname')print(@fetch_pubname)
					print('@fetch_pubtype')print(@fetch_pubtype)
					
					if @fetch_protype ='MA0'
					begin
						set @vrec_agency_ageing_type='M'
					end
					else
					begin
						set @vrec_agency_ageing_type=@rec_agency_ageing_type
					end
					select @ptill_days1=SLAB_TILL1,@ptill_days2=SLAB_TILL2,@ptill_days3=SLAB_TILL3,@ptill_days4=SLAB_TILL4
					,@ptill_days5=SLAB_TILL5,@ptill_days6=SLAB_TILL6--,@rec_agency_ageing_type=AGEING_TYPE
					from CIR_AGEING_SLAB_MAST
					where COMP_CODE=@pcomp_code and PRO_TYPE=@fetch_protype
					
					print ('slab')print(@ptill_days1)print(@ptill_days2)print(@ptill_days3)print(@ptill_days4)print(@ptill_days5)
					print (@ptill_days6)print(@rec_agency_ageing_type)
					print ('gaurav')
					print (@vrec_agency_ageing_type)
					print (@pasondt)
					print (dbo.GetLastDayOfMonth(@pasondt))
					print ('debug')
					
					if upper(@vrec_agency_ageing_type) = 'D'
					begin
						set @vtodt=dateadd(dd,-1,@pasondt)
					end
					else if upper(@vrec_agency_ageing_type) = 'W'
					begin
						select @day=DATEPART(dw,@pasondt)
						print(@day)
						set @vtodt=dateadd(dd,-(@day-1),@pasondt)
					end
					else
					begin
						if dbo.GetLastDayOfMonth(@pasondt)=@pasondt
						begin
							set @vtodt=@pasondt
						end
						else
						begin
							set @vtodt=dbo.GetLastDayOfMonth(dateadd(mm,-1,@pasondt))
						end
					end
					print('come') print(@vrec_agency_ageing_type)
					print(@vtodt)
					print('custom')print(@ptill_days1)print(@ptill_days2)print(@ptill_days3)print(@ptill_days4)print(@ptill_days5)

					if @vrec_agency_ageing_type='M' begin print('gks')
						set @v_mcnt1=DATEADD(MM,-1*@ptill_days1,@vtodt+1)
						set @v_mcnt2=DATEADD(MM,-1*@ptill_days2,@vtodt+1)
						set @v_mcnt3=DATEADD(MM,-1*@ptill_days3,@vtodt+1)
						set @v_mcnt4=DATEADD(MM,-1*@ptill_days4,@vtodt+1)
						set @v_mcnt5=DATEADD(MM,-1*@ptill_days5,@vtodt+1)
						--DATEDIFF(dd, dbo.GetFirstDayOfMonth( @vtodt),@vtodt )+1
						set @vtill_days1=DATEDIFF(dd, dbo.GetFirstDayOfMonth( @v_mcnt1),@vtodt )+1
						set @vtill_days2=DATEDIFF(dd, dbo.GetFirstDayOfMonth( @v_mcnt2),@vtodt )+1
						set @vtill_days3=DATEDIFF(dd, dbo.GetFirstDayOfMonth( @v_mcnt3),@vtodt )+1
						set @vtill_days4=DATEDIFF(dd, dbo.GetFirstDayOfMonth( @v_mcnt4),@vtodt )+1
						set @vtill_days5=DATEDIFF(dd, dbo.GetFirstDayOfMonth( @v_mcnt5),@vtodt )+1
					end
					else if @vrec_agency_ageing_type='W'  
					begin print('weekly')
						--@vtodt
						set @v_mcnt1=DATEADD(ww,-1*@ptill_days1,@vtodt+1)
						set @v_mcnt2=DATEADD(ww,-1*@ptill_days2,@vtodt+1)
						set @v_mcnt3=DATEADD(ww,-1*@ptill_days3,@vtodt+1)
						set @v_mcnt4=DATEADD(ww,-1*@ptill_days4,@vtodt+1)
						set @v_mcnt5=DATEADD(ww,-1*@ptill_days5,@vtodt+1)
						
						set @vtill_days1=DATEDIFF(dd, @v_mcnt1,@vtodt )+1
						set @vtill_days2=DATEDIFF(dd, @v_mcnt2,@vtodt )+1
						set @vtill_days3=DATEDIFF(dd, @v_mcnt3,@vtodt )+1
						set @vtill_days4=DATEDIFF(dd, @v_mcnt4,@vtodt )+1
						set @vtill_days5=DATEDIFF(dd, @v_mcnt5,@vtodt )+1
					end
					else
					begin
						set @vtill_days1=@ptill_days1
						set @vtill_days2=@ptill_days2
						set @vtill_days3=@ptill_days3
						set @vtill_days4=@ptill_days4
						set @vtill_days5=@ptill_days5
					end
					print ('custom1')print(@vtill_days1)print(@vtill_days2)print(@vtill_days3)print(@vtill_days4)print(@vtill_days5)
					print @rec_agency_dpcd
					set @debit_amt_030 = 0;
					set @debit_amt_3160 = 0;
					set @debit_amt_6190 = 0;
					set @debit_amt_91120 = 0;
					set @debit_amt_121180 = 0;
					set @debit_amt_181 = 0;
					set @rcpt_pending_amt = 0;
					set @bill_pending_amt = 0;
					print('enter first')
					
					declare c_bill cursor for
					select distinct billno,billdt,sum(amount) bill_amt from cir_outmast
					where comp_code=@pcomp_code and unit_code=@punit_code and
					agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
					billdt <=@vtodt and isnull(abs(amount),0)>0
					group by comp_code,billno,billdt having sum(amount)>0
					union all
					select distinct recptno billno,recptdt billdt,sum(amount) bill_amt from cir_outmast
					where comp_code=@pcomp_code and unit_code=@punit_code and
					agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
					recptdt <=@vtodt and isnull(amount,0)>0 and billno is null
					group by comp_code,recptno,recptdt order by 2,1
--having sum(amount)<0
					open c_bill
					fetch NEXT FROM c_bill INTO @v_bill_billno,@v_bill_billdt,@v_bill_bill_amt
						WHILE (@@FETCH_STATUS = 0)
						begin
							print('enter second')
							
							set @v_dt = @v_bill_billdt
							set @v_ondt = @vtodt
							print(@v_dt)
							print(@v_ondt)
							
							if @paging_by='D' begin
								set @v_days=DATEDIFF(dd, @v_dt,@v_ondt )---isnull(pcrdtday,0)+1;
							end
							else
							begin
								set @v_days=DATEDIFF(dd, @v_dt,@v_ondt )+1;
							end
							if @v_days<0 begin
								set @v_days=0;
							end
							print('x')
							print(@v_days)
							set @v_amt =0;
							set @v_amt030 =0;
							set @v_amt3160 =0;
							set @v_amt6190 =0;
							set @v_amt91120 =0;
							set @v_amt121180 =0;
							set @v_amt181 =0;
							
							if @v_days between 0 and @vtill_days1 
							begin
								select @v_amt030=sum(amount) from cir_outmast
								where comp_code=@pcomp_code and unit_code=@punit_code and
								agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
								billno =@v_bill_billno and billdt=@v_bill_billdt and
								recptdt <=@vasondt and amount<0
								set @v_amt030 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt030,0);
								set @debit_amt_030 =isnull(@debit_amt_030,0)+isnull(@v_amt030,0)
							end
							else if @v_days between isnull(@vtill_days1,0)+1 and @vtill_days2 
							begin
								select @v_amt3160=sum(amount) from cir_outmast
								where comp_code=@pcomp_code and unit_code=@punit_code and
								agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
								billno =@v_bill_billno and billdt=@v_bill_billdt and
								recptdt <=@vasondt and amount<0
							--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
								set @v_amt3160 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt3160,0);
								set @debit_amt_3160 =isnull(@debit_amt_3160,0)+isnull(@v_amt3160,0)
							end
							else if @v_days between isnull(@vtill_days2,0)+1 and @vtill_days3 
							begin
								select @v_amt6190=sum(amount) from cir_outmast
								where comp_code=@pcomp_code and unit_code=@punit_code and
								agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
								billno =@v_bill_billno and billdt=@v_bill_billdt and
								recptdt <=@vasondt and amount<0
							--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
								set @v_amt6190 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt6190,0);
								set @debit_amt_6190 =isnull(@debit_amt_6190,0)+isnull(@v_amt6190,0)
							end
							else if @v_days between isnull(@vtill_days3,0)+1 and @vtill_days4 
							begin
								select @v_amt91120=sum(amount) from cir_outmast
								where comp_code=@pcomp_code and unit_code=@punit_code and
								agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
								billno =@v_bill_billno and billdt=@v_bill_billdt and
								recptdt <=@vasondt and amount<0
							--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
								set @v_amt91120 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt91120,0);
								set @debit_amt_91120 =isnull(@debit_amt_91120,0)+isnull(@v_amt91120,0)
							end
							else if @v_days between isnull(@vtill_days4,0)+1 and @vtill_days5 
							begin
								select @v_amt121180=sum(amount) from cir_outmast
								where comp_code=@pcomp_code and unit_code=@punit_code and
								agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
								billno =@v_bill_billno and billdt=@v_bill_billdt and
								recptdt <=@vasondt and amount<0
							--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
								set @v_amt121180 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt121180,0);
								set @debit_amt_121180 =isnull(@debit_amt_121180,0)+isnull(@v_amt121180,0)
							end
							else
							begin
								select @v_amt181=sum(amount) from cir_outmast
								where comp_code=@pcomp_code and unit_code=@punit_code and
								agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
								billno =@v_bill_billno and billdt=@v_bill_billdt and
								recptdt <=@vasondt and amount<0
								--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
								set @v_amt181 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt181,0);
								set @debit_amt_181 =isnull(@debit_amt_181,0)+isnull(@v_amt181,0)
							end
					fetch NEXT FROM c_bill INTO @v_bill_billno,@v_bill_billdt,@v_bill_bill_amt
					end
				close c_bill
				deallocate c_bill

			declare @cur_from_dt as datetime
			print('t')
			print(@punit_code)
			print(@fetch_pub)
			set @cur_from_dt= dateadd(dd,1,@vtodt)
			print(@cur_from_dt)
			print(@pasondt)
			print('W')
			
			select @v_amtcur=sum(amount) from cir_outmast
			where comp_code=@pcomp_code and unit_code=@punit_code and
			agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
			billdt between @cur_from_dt and @pasondt
			--and RECPTNO is null and RECPTDT is null
			print(@fetch_pub)print(@cur_from_dt)print(@pasondt) 
			--and recptdt<=@pasondt and amount<0
			
			
		
			set @v_amt=isnull(@v_amtcur,0)+ isnull(@debit_amt_030,0)+isnull(@debit_amt_3160,0)+isnull(@debit_amt_6190,0)+isnull(@debit_amt_91120,0)+isnull(@debit_amt_121180,0)+isnull(@debit_amt_181,0)
			print('@v_amt amount here')print(@v_amt)print('@@v_amt')
			if @v_amt=0 
			begin
				set @debit_amt_030 = 0
				set @debit_amt_3160 = 0
				set @debit_amt_6190 = 0
				set @debit_amt_91120 = 0
				set @debit_amt_121180 = 0
				set @debit_amt_181 = 0				
			end
			else
			begin				
				set @bill_pending_amt=isnull(@v_amt,0)
			end
			print('zzz')
		
			insert into #cir_temp_ageing (comp_code,unit_code,agcd,dpcd,ag_name,city_name,pending_amt,CUR_AMT
			, SLAB_1 ,slab_2,slab_3,slab_4,slab_5,slab_6,rect_pending,on_acamt,sessionid,PUBNAME,ageing)
			values (@rec_agency_comp_code,@punit_code,@rec_agency_agcd, @rec_agency_dpcd, @fetch_protype,
			@fetch_pubname	,isnull(@bill_pending_amt,0),isnull(@v_amtcur,0)
			,isnull(@debit_amt_030,0),isnull(@debit_amt_3160,0), isnull(@debit_amt_6190,0)
			,isnull(@debit_amt_91120,0), isnull(@debit_amt_121180,0), isnull(@debit_amt_181,0),
			isnull(0,0),0,@@spid,@fetch_pubtype,@rec_agency_ageing_type);
			print('xxx')
			fetch NEXT FROM cur_agency INTO @fetch_pub
			set @debit_amt_030 = 0
			set @debit_amt_3160 = 0
			set @debit_amt_6190 = 0
			set @debit_amt_91120 = 0
			set @debit_amt_121180 = 0
			set @debit_amt_181 = 0
			set @rcpt_pending_amt = 0
			set @bill_pending_amt = 0
		end
		close cur_agency;
	deallocate cur_agency
	
			select @v_pending_rcpt_amt=sum(amount) from cir_outmast
			where comp_code=@pcomp_code and unit_code=@punit_code and
			agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd 
			and BILLDT is null and BILLNO is null  and AMOUNT < 0			
			
			print('receipt amount here')print(@v_pending_rcpt_amt)print('@v_pending_rcpt_amt')
		
			

			insert into #cir_temp_ageing (comp_code,unit_code,agcd,dpcd,ag_name,city_name,pending_amt,CUR_AMT
			, SLAB_1 ,slab_2,slab_3,slab_4,slab_5,slab_6,rect_pending,on_acamt,sessionid,PUBNAME,ageing)
			values (@rec_agency_comp_code,@punit_code,@rec_agency_agcd, @rec_agency_dpcd, @fetch_protype,
			null	,isnull(0,0),isnull(0,0)
			,isnull(0,0),isnull(0,0), isnull(0,0)
			,isnull(0,0), isnull(0,0), isnull(0,0),
			isnull(@v_pending_rcpt_amt,0),0,@@spid,@fetch_pubtype,@rec_agency_ageing_type);


fetch NEXT FROM cur_agency_1 INTO @rec_agency_comp_code,@rec_agency_agcd,@rec_agency_dpcd,@rec_agency_agency_name,@rec_agency_city_code,@rec_agency_city_name,@rec_agency_credit_days,@rec_agency_branch_name,@rec_agency_ageing_type
end 
close cur_agency_1
deallocate cur_agency_1

--5select * from #cir_temp_ageing

if(@pextra1='CREDIT') 
begin
	select comp_code,unit_code,agcd,dpcd,ag_name PRO_TYPE,PUBNAME--,city_name PUBL_NAME
	,(sum(isnull(pending_amt,0)) - abs(max(ISNULL(rect_pending,0)) ) )  pending_amt,sum(isnull(cur_amt,0)) cur_amt,sum(isnull(slab_1,0)) slab_1,sum(isnull(slab_2,0)) slab_2
	,sum(isnull(slab_3,0)) slab_3,sum(isnull(slab_4,0)) slab_4,sum(isnull(slab_5,0)) slab_5,sum(isnull(slab_6,0)) slab_6,sum(isnull(rect_pending,0)) rect_pending
	,ageing
	from #cir_temp_ageing group by #cir_temp_ageing.COMP_CODE,#cir_temp_ageing.UNIT_CODE,#cir_temp_ageing.AGCD,#cir_temp_ageing.DPCD
	,#cir_temp_ageing.AG_NAME,PUBNAME,ageing
	order by PUBNAME;
end
else 
begin

	select comp_code,unit_code,agcd,dpcd,ag_name PRO_TYPE,PUBNAME--,city_name PUBL_NAME
	--,(sum(isnull(pending_amt,0)) - abs(max(ISNULL(rect_pending,0)) ) )  pending_amt
	,sum( isnull(pending_amt,0) ) - ISNULL(max(abs(rect_pending)),0)  pending_amt
	,sum(isnull(cur_amt,0)) cur_amt,sum(isnull(slab_1,0)) slab_1,sum(isnull(slab_2,0)) slab_2
	,sum(isnull(slab_3,0)) slab_3,sum(isnull(slab_4,0)) slab_4,sum(isnull(slab_5,0)) slab_5,sum(isnull(slab_6,0)) slab_6,sum(isnull(rect_pending,0)) rect_pending
	,ageing
	from #cir_temp_ageing group by #cir_temp_ageing.COMP_CODE,#cir_temp_ageing.UNIT_CODE,#cir_temp_ageing.AGCD,#cir_temp_ageing.DPCD
	,#cir_temp_ageing.AG_NAME,PUBNAME,ageing
	order by PUBNAME;

	select SUM(abs(isnull(amount,0))) as SEC_ONDT from CIR_RCPHDR where COMP_CODE=@pcomp_code
	and (UNIT_CODE=@punit_code or @punit_code is null or @punit_code ='')
	and (AGCD=@pag_main_code or @pag_main_code is null or @pag_main_code ='')
	and (DPCD=@pag_sub_code or @pag_sub_code is null or @pag_sub_code ='')
	and ACHD='SC'
	group by comp_code,unit_code,agcd,dpcd


	select SUM(abs(isnull(bg_amt,0))) as BG_ONDT from CIR_BANK_GUARANTEE where COMP_CODE=@pcomp_code
	and(UNIT_CODE=@punit_code or @punit_code is null or @punit_code ='')
	and(AGCD=@pag_main_code or @pag_main_code is null or @pag_main_code ='')
	and(DPCD=@pag_sub_code or @pag_sub_code is null or @pag_sub_code ='')
	group by comp_code,unit_code,agcd,dpcd
	
	
	select * from #cir_temp_ageing
	drop table #cir_temp_ageing
end

/**6feb*/
/**9 feb**/                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE [dbo].[cir_rep_agency_ledger_cir_agency_ledger_utusan]
    @pcompcode       as varchar(20),
    @punitcode       as varchar(20),
    @pactype         as varchar(20),
    @pbranchcode     as varchar(20),
    @pagency_type    as varchar(20),
    @pagcd           as varchar(20),
    @pdpcd           as varchar(20),
    @pstatecode      as varchar(20),
    @pdistcode       as varchar(20),
    @pcitycode       as varchar(20),
    @ptalukacode     as varchar(20),
    @pfrom_date      as datetime,
    @ptill_date      as datetime,
    @pbilladj_flag   as varchar(20),
    @psortedby       as varchar(20),
    @puserid         as varchar(20),
    @prowbreak       as varchar(20),
    @pdateformat     as varchar(20),
    @pextra1         as varchar(200),--it is use for agency class
    @pextra2         as varchar(200)
As
    declare @v_frdt          datetime;
    declare @v_todt          datetime;
    declare @v_opdate        datetime;
   
    declare @v_opbal         decimal(15,2)
    declare @v_opbal_sec     decimal(15,2)
    declare @v_amt           decimal(15,2)
    declare @v_clbal         decimal(15,2)
    declare @v_runbal        decimal(15,2)
    declare @v_billamt       decimal(15,2)
    declare @v_dbcramt       decimal(15,2)
    declare @v_cramt         decimal(15,2)
    declare @v_dbamt         decimal(15,2)
    declare @v_rec_seqno     int
    declare @v_remark_len    int
    declare @v_divident      int
    declare @v_narration     varchar(1000)
    declare @v_runbal_txt    varchar(20)
	
	
	declare @v1_comp_code		varchar(20)
	declare @v1_unit			varchar(20)
	declare @v1_agcd			varchar(20) 
	declare @v1_dpcd			varchar(20) 
	declare @v1_ag_name			varchar(200) 
	declare @v1_ag_name_oth_lang varchar(200)
	declare @v1_city_code		varchar(20)
	declare @v1_tehsil_taluka	varchar(20)
	declare @v1_dist_code		varchar(20)
	declare @v1_state_code		varchar(20)
    declare @v1_country_code	varchar(20)	
	declare @v1_branch_code		varchar(20)
	
	declare @v1_issue_date		datetime
	declare @v1_product_code	varchar(20)
	declare @v1_quantity		int
	declare @v1_unit_price		numeric(8,3)
	declare @v1_addr1	varchar(200)
	declare @v1_ADDR2	varchar(200)
	declare @v1_ADDR3	varchar(200)
	declare @v1_PIN_CODE	numeric(10)



	declare @v2_comp_code		varchar(20)	
	declare @v2_unit_code		varchar(20)
	declare @v2_agcd			varchar(20)
	declare @v2_dpcd			varchar(20)
	declare @v2_doctype			varchar(20)	
	declare @v2_recptno			varchar(20)
	declare @v2_recptdt			datetime
	declare @v2_amount			decimal(15,2)
	declare @v2_chno			varchar(20)
	declare @v2_chdt			datetime
	declare @v2_chbank			varchar(200)
	declare @v2_reason			varchar(200)
	declare @v2_narration		varchar(2000)
	declare @v2_received_from	varchar(200)
        
Begin
	If @punitcode='' Begin
		set @punitcode=null
	End
	If @pactype='' Begin
		set @pactype=null
	End
	If @pbranchcode='' Begin
		set @pbranchcode=null
	End
	If @pagency_type='' Begin
		set @pagency_type=null
	End
	If @pagcd='' Begin
		set @pagcd=null
	End
	If @pdpcd='' Begin
		set @pdpcd=null
	End
	If @pstatecode='' Begin
		set @pstatecode=null
	End
	If @pdistcode='' Begin
		set @pdistcode=null
	End

	If @pcitycode='' Begin
		set @pcitycode=null
	End
	If @ptalukacode='' Begin
		set @ptalukacode=null
	End
	If @pbilladj_flag='' Begin
		set @pbilladj_flag=null
	End
	If @pextra1='' Begin
		set @pextra1=null
	End
	If @pextra2='' Begin
		set @pextra2=null
	End
	If @prowbreak='' Begin
		set @prowbreak=null
	End

	set @v_opdate    =dbo.cir_get_finandt(@pcompcode,@pfrom_date,@pdateformat,null,null)--for financial date
print('%')
print(@prowbreak)
	set @v_frdt      =@pfrom_date
	set @v_todt      =@ptill_date
	set @v_divident  =isnull(@prowbreak,35)

	CREATE TABLE #CIR_LEDGER_REPORT
	( COMP_CODE      VARCHAR(10),
	  UNIT_CODE      VARCHAR(10),
	  BRANCH_CODE    VARCHAR(10),
	  DOCTYPE        VARCHAR(100),
	  AGCD           VARCHAR(50),
	  DPCD           VARCHAR(50),
	  RECPTNO        VARCHAR(50),
	  RECPTDT        DATETIME,
	  AMOUNT         decimal(14,2),
	  CHQNO          VARCHAR(50),
	  CHQDT          DATETIME,
	  CHQ_BANK       VARCHAR(100),
	  EXEC_CODE      VARCHAR(20),
	  REMARKS        VARCHAR(500),
	  REASON         VARCHAR(30),
	  BILLNO         VARCHAR(50),
	  BILLDT         DATETIME,
	  BILLAMT        DECIMAL(14,2),
	  ADJAMT         DECIMAL(14,2),
	  LEFTAMT        DECIMAL(14,2),
	  DEBIT_HEAD     VARCHAR(200),
	  CREDIT_HEAD    VARCHAR(200),
	  REC_SEQNO      INT,
	  RECOVARY_DAYS  INT,
	  AGNAME         VARCHAR(500),
	  OPBAL_SEC      DECIMAL(14,2),
	  NARR_LINE      INT,
	  ISSUE_DATE     DATETIME,
	  PRODUCT        VARCHAR(200),
	  QUANTITY       INT,
	  UNIT_PRICE     NUMERIC(8,3),
	  addr1			 varchar(200),
	  ADDR2			 varchar(200),
	  ADDR3			 varchar(200),
	  PIN_CODE       numeric(10)
	  )
print('8')
create table #cir_summary_statement
(
comp_code varchar(20),
unit_code varchar(20),
PUBL_code varchar(20),
EDTN_code varchar(20),
PUBL_NAME varchar(200),
EDTN_NAME varchar(200),
AGCD varchar(20),
DPCD varchar(20),
INV_QTY  numeric(12),
INV_AMT  numeric(14,2),
RET_QTY  numeric(12),
RET_AMT  numeric(14,2),
INSERT_LATE numeric(14,2),
REMARK    varchar(200),
TOTAL numeric(14,2)
)	
declare @sum_ag_comp_code as varchar(20)
declare @sum_ag_unit as varchar(20)
declare @sum_ag_agcd as varchar(20)
declare @sum_ag_dpcd as varchar(20)
declare @sum_ag_ag_name	 as varchar(200)
declare @sum_publ_publ	 as varchar(200)
declare @sum_edtn	 as varchar(200)
declare @sum_edtn_name	 as varchar(200)

declare @v_invqty as numeric(12)
declare @v_invamt as numeric(14,2)
declare @v_retqty as numeric(12)
declare @v_retamt as numeric(14,2)
declare @v_late_ins as numeric(14,2)
declare @v_publ_tot as numeric(14,2)
declare @v_payment as  numeric(14,2)
declare @v_dn_chq as numeric(14,2)					
declare @v_dn_nom as numeric(14,2)					
declare @v_cn as numeric(14,2)

declare @v_tot_inv as numeric(14,2)
declare @v_tot_ucn as numeric(14,2)
declare @v_close_bal as numeric(14,2)

	if @pextra2 ='S'
	begin
		declare sum_ag cursor for
			select distinct comp_code,unit,agcd,dpcd,ag_name from cir_agmast  
			where comp_code = @pcompcode and (unit=@punitcode or @punitcode is null) 
			and (ag_type=@pagency_type or @pagency_type is null) 
			and agcd+dpcd in(select distinct agcd+dpcd from cir_outmast 
							where comp_code = @pcompcode and (unit_code=@punitcode or @punitcode is null) and achd=@pactype) 
			and (agcd=@pagcd or @pagcd is null) 
			and (dpcd=@pdpcd or @pdpcd is null) 			
			and (branch_code=@pbranchcode or @pbranchcode is null) 
			and (state_code=@pstatecode or @pstatecode is null) 
			and (dist_code=@pdistcode or @pdistcode is null) 
			and (tehsil_taluka=@ptalukacode or @ptalukacode is null) 			
			and (ag_class=@pextra1 or @pextra1 is null)
			order by comp_code,unit,ag_name;
	
	
			open sum_ag
				fetch NEXT FROM sum_ag INTO @sum_ag_comp_code,@sum_ag_unit,@sum_ag_agcd,@sum_ag_dpcd,@sum_ag_ag_name
				WHILE (@@FETCH_STATUS = 0) Begin
					set @v_opbal=0
					set @v_close_bal=0
					set @v_opbal =dbo.cir_accounts_cir_agency_opbal(@pcompcode, @punitcode,null,@sum_ag_agcd, @sum_ag_dpcd, @v_opdate, 'NM',@pdateformat,null,null)
					set @v_dbcramt=0					
				
							select @v_billamt=sum(amount) from cir_outmast
								where comp_code = @pcompcode and unit_code=@punitcode and 
									agcd=@sum_ag_agcd and dpcd=@sum_ag_dpcd and billdt >= @v_opdate and billdt<@v_frdt and 
									achd='NM' and recptno is null

							select @v_dbcramt=sum(amount) from cir_rcpdet
								where comp_code=@pcompcode and unit_code=@punitcode and 
									agcd=@sum_ag_agcd and dpcd=@sum_ag_dpcd and recptdt>= @v_opdate and recptdt<@v_frdt and 
									achd='NM' and billno is null

							set @v_opbal=isnull(@v_opbal,0)+isnull(@v_billamt,0)+isnull(@v_dbcramt,0)
			------------------  insert BF ----------------
			insert into #cir_summary_statement(comp_code,unit_code,PUBL_code,EDTN_code,PUBL_NAME,EDTN_NAME,
						AGCD,DPCD,INV_QTY,INV_AMT,RET_QTY,RET_AMT,INSERT_LATE,REMARK,TOTAL)	
			values (@sum_ag_comp_code,@sum_ag_unit,null,null,'Balance B/F',null,@sum_ag_agcd,@sum_ag_dpcd
					,null,null,null,null,null,null,@v_opbal)
			---------------------------------------------		
			set @v_close_bal=@v_opbal
			set @v_tot_inv =0
			set @v_tot_ucn =0

					declare sum_publ cursor for
						select distinct  publ,pro_type,publ_name from cir_publ_mast
						where comp_code = @pcompcode --and (unit_code=@punitcode or @punitcode is null) 
						order by pro_type
						
						open sum_publ
							fetch NEXT FROM sum_publ INTO @sum_publ_publ,@sum_edtn,@sum_edtn_name
							WHILE (@@FETCH_STATUS = 0) Begin
								select @v_invqty=SUM(isnull(bill_copy,0))
								,@v_invamt=sum(isnull(bill_amount,0))								
								from cir_bill where COMP_CODE=@sum_ag_comp_code
								and UNIT_CODE=@sum_ag_unit and AGCD=@sum_ag_agcd and DPCD=@sum_ag_dpcd
								and BILLDT between @v_frdt and @v_todt
								and PUBL=@sum_publ_publ 
								
								select @v_retqty=sum(ISNULL(APR_BNR,0))+sum(ISNULL(APR_DAMAGE,0))+sum(ISNULL(APR_LATE_RECPT,0))+
								sum(ISNULL(APR_SHORT_RECPT,0))+sum(ISNULL(APR_UNSOLD,0)) 
								,@v_retamt =SUM(isnull(copy_amt,0)) from CIR_UNSOLD_DTL 
								where COMP_CODE=@sum_ag_comp_code and UNIT_CODE=@sum_ag_unit 
								and AGCD=@sum_ag_agcd and DPCD=@sum_ag_dpcd and PUBL=@sum_publ_publ 
								and APP_DT between @v_frdt and @v_todt
								and (PROCESS_CRNO is not null or PROCESS_CRNO!='')
								and (PROCESS_CRDT is not null or PROCESS_CRDT!='')
								
								select @v_late_ins=SUM(isnull(abs(AMOUNT),0)) from cir_rcphdr 
								where COMP_CODE=@sum_ag_comp_code and UNIT_CODE=@sum_ag_unit 
								and AGCD=@sum_ag_agcd and DPCD=@sum_ag_dpcd and PUBL=@sum_publ_publ 
								and RECPTDT between @v_frdt and @v_todt
								
								set @v_publ_tot=isnull(@v_invamt,0)+(-1*ISNULL(@v_retamt,0))+(-1*ISNULL(@v_late_ins,0))
								------------------  insert product summary ----------------
								if isnull(@v_invamt ,0) !=0 or isnull(@v_retamt ,0) !=0 or isnull(@v_late_ins ,0) !=0
								begin
									insert into #cir_summary_statement(comp_code,unit_code,PUBL_code,EDTN_code,PUBL_NAME,EDTN_NAME,
												AGCD,DPCD,INV_QTY,INV_AMT,RET_QTY,RET_AMT,INSERT_LATE,REMARK,TOTAL)	
									values (@sum_ag_comp_code,@sum_ag_unit,@sum_publ_publ,@sum_edtn,@sum_edtn_name,null,@sum_ag_agcd,@sum_ag_dpcd
											,@v_invqty,@v_invamt,@v_retqty,@v_retamt,@v_late_ins,null,@v_publ_tot)
								set @v_close_bal=	@v_close_bal+(@v_publ_tot)
								set @v_tot_inv =@v_tot_inv+@v_invamt
								set @v_tot_ucn =@v_tot_ucn+@v_retamt
								end
								---------------------------------------------
								
								
							fetch NEXT FROM sum_publ INTO @sum_publ_publ,@sum_edtn,@sum_edtn_name
							End

						close sum_publ
						deallocate sum_publ
					------------------------ just for  total----------------
					if isnull(@v_tot_inv ,0) !=0 or isnull(@v_tot_ucn ,0) !=0 
					begin
						insert into #cir_summary_statement(comp_code,unit_code,PUBL_code,EDTN_code,PUBL_NAME,EDTN_NAME,
									AGCD,DPCD,INV_QTY,INV_AMT,RET_QTY,RET_AMT,INSERT_LATE,REMARK,TOTAL)	
						values (@sum_ag_comp_code,@sum_ag_unit,null,null,null,null,@sum_ag_agcd,@sum_ag_dpcd
								,null,@v_tot_inv,null,@v_tot_ucn,null,null,null)
					end
					
					select @v_dn_chq=SUM(isnull(abs(amount),0)) from CIR_RCPHDR 
					where COMP_CODE=@sum_ag_comp_code and UNIT_CODE=@sum_ag_unit 
					and AGCD=@sum_ag_agcd and DPCD=@sum_ag_dpcd and DOCTYPE='DN' and REASON='CH0'
					and RECPTDT between @v_frdt and @v_todt					
									
					------------------  insert DN CHQ Bounce summary ----------------
					if isnull(@v_dn_chq ,0) !=0 
					begin
						insert into #cir_summary_statement(comp_code,unit_code,PUBL_code,EDTN_code,PUBL_NAME,EDTN_NAME,
							AGCD,DPCD,INV_QTY,INV_AMT,RET_QTY,RET_AMT,INSERT_LATE,REMARK,TOTAL)	
						values (@sum_ag_comp_code,@sum_ag_unit,null,null,'CHEQUE BOUNCED',null,@sum_ag_agcd,@sum_ag_dpcd
								,null,null,null,null,null,null,@v_dn_chq)
					set @v_close_bal=	@v_close_bal+(@v_dn_chq)
					end
					
					---------------------------------------------	
					
					select @v_dn_nom=SUM(isnull(abs(amount),0)) from CIR_RCPHDR 
					where COMP_CODE=@sum_ag_comp_code and UNIT_CODE=@sum_ag_unit 
					and AGCD=@sum_ag_agcd and DPCD=@sum_ag_dpcd and DOCTYPE='DN' and REASON!='CH0'					
					and RECPTDT between @v_frdt and @v_todt				
					------------------  insert DN summary ----------------
					if isnull(@v_dn_nom ,0) !=0 
					begin
						insert into #cir_summary_statement(comp_code,unit_code,PUBL_code,EDTN_code,PUBL_NAME,EDTN_NAME,
							AGCD,DPCD,INV_QTY,INV_AMT,RET_QTY,RET_AMT,INSERT_LATE,REMARK,TOTAL)	
						values (@sum_ag_comp_code,@sum_ag_unit,null,null,'DEBIT NOTE',null,@sum_ag_agcd,@sum_ag_dpcd
								,null,null,null,null,null,null,@v_dn_nom)
					set @v_close_bal=	@v_close_bal+(@v_dn_nom)
					end
					
					---------------------------------------------	
					
					select @v_cn=SUM(isnull(abs(amount),0)) from CIR_RCPHDR 
					where COMP_CODE=@sum_ag_comp_code and UNIT_CODE=@sum_ag_unit 
					and AGCD=@sum_ag_agcd and DPCD=@sum_ag_dpcd and DOCTYPE='CN'					
					and RECPTDT between @v_frdt and @v_todt				
					------------------  insert CN summary ----------------
					if isnull(@v_cn ,0) !=0 
					begin
						insert into #cir_summary_statement(comp_code,unit_code,PUBL_code,EDTN_code,PUBL_NAME,EDTN_NAME,
							AGCD,DPCD,INV_QTY,INV_AMT,RET_QTY,RET_AMT,INSERT_LATE,REMARK,TOTAL)	
						values (@sum_ag_comp_code,@sum_ag_unit,null,null,'CREDIT NOTE',null,@sum_ag_agcd,@sum_ag_dpcd
								,null,null,null,null,null,null,@v_cn)
					set @v_close_bal=	@v_close_bal+(-1*@v_cn)
					end
					
					---------------------------------------------
					
					select @v_payment=SUM(isnull(abs(amount),0)) from CIR_RCPHDR 
					where COMP_CODE=@sum_ag_comp_code and UNIT_CODE=@sum_ag_unit 
					and AGCD=@sum_ag_agcd and DPCD=@sum_ag_dpcd and DOCTYPE='RCR' and ACHD	= 'NM'				
					and RECPTDT between @v_frdt and @v_todt				
					------------------  insert PAYMENT summary ----------------
					if isnull(@v_payment ,0) !=0 
					begin
						insert into #cir_summary_statement(comp_code,unit_code,PUBL_code,EDTN_code,PUBL_NAME,EDTN_NAME,
							AGCD,DPCD,INV_QTY,INV_AMT,RET_QTY,RET_AMT,INSERT_LATE,REMARK,TOTAL)	
						values (@sum_ag_comp_code,@sum_ag_unit,null,null,'PAYMENT',null,@sum_ag_agcd,@sum_ag_dpcd
								,null,null,null,null,null,null,@v_payment)
					set @v_close_bal=	@v_close_bal+(-1*@v_payment)
					end
					
					---------------------------------------------	
				
				if isnull(@v_close_bal ,0) !=0 
				begin
					insert into #cir_summary_statement(comp_code,unit_code,PUBL_code,EDTN_code,PUBL_NAME,EDTN_NAME,
						AGCD,DPCD,INV_QTY,INV_AMT,RET_QTY,RET_AMT,INSERT_LATE,REMARK,TOTAL)	
					values (@sum_ag_comp_code,@sum_ag_unit,null,null,'BALANCE C/F',null,@sum_ag_agcd,@sum_ag_dpcd
							,null,null,null,null,null,null,@v_close_bal)
				end
				
				fetch NEXT FROM sum_ag INTO @sum_ag_comp_code,@sum_ag_unit,@sum_ag_agcd,@sum_ag_dpcd,@sum_ag_ag_name
				End

			close sum_ag
			deallocate sum_ag
	
	select *,dbo.cir_get_agency(COMP_CODE,UNIT_CODE,AGCD,DPCD) AS AGENCYNAME	
	,dbo.cir_get_contact_person(COMP_CODE,AGCD,DPCD) AS CONTACT
	,dbo.cir_get_agency_add(COMP_CODE,AGCD,DPCD,'','') AS ADDR
	 from #cir_summary_statement order by AGCD,DPCD
	
	end
	else
	begin
declare @v1_commrate as numeric(14,2)
		declare c1 cursor for
				select distinct comp_code,unit,agcd,dpcd,ag_name,ag_name_oth_lang,city_code,tehsil_taluka,dist_code,state_code,
					country_code,branch_code,addr1,ADDR2,ADDR3,PIN_CODE from cir_agmast 
						where comp_code = @pcompcode and (unit=@punitcode or @punitcode is null) and 
									(ag_type=@pagency_type or @pagency_type is null) and agcd+dpcd in(select distinct agcd+dpcd from cir_outmast 
									where comp_code = @pcompcode and (unit_code=@punitcode or @punitcode is null) and achd=@pactype) and 
									(agcd=@pagcd or @pagcd is null) and (dpcd=@pdpcd or @pdpcd is null) and (branch_code=@pbranchcode or @pbranchcode is null) and
									(state_code=@pstatecode or @pstatecode is null) and (dist_code=@pdistcode or @pdistcode is null) and 
									(tehsil_taluka=@ptalukacode or @ptalukacode is null) and (ag_class=@pextra1 or @pextra1 is null)
									order by branch_code,city_code,ag_name;
		  
				--select distinct a.comp_code,a.unit,a.agcd,a.dpcd,a.ag_name,a.ag_name_oth_lang,a.city_code
				--,a.tehsil_taluka,a.dist_code,a.state_code, a.country_code,a.branch_code 
				--,x.supdate,x.publ,x.sup_copy,x.sup_rate,a.addr1,a.ADDR2,a.ADDR3,a.PIN_CODE
				--from cir_agmast a,cir_dbksup x
				--where a.comp_code=x.comp_code and x.UNIT_CODE=a.UNIT and A.AGCD  = x.AGCD and A.DPCD  = x.DPCD and
				-- a.comp_code = @pcompcode and (a.unit=@punitcode or @punitcode is null) and 
				--(a.ag_type=@pagency_type or @pagency_type is null) and a.agcd+a.dpcd in(select distinct agcd+dpcd from cir_outmast 
				--where comp_code = @pcompcode and (unit_code=@punitcode or @punitcode is null) and achd=@pactype) and 
				--(a.agcd=@pagcd or @pagcd is null) and (a.dpcd=@pdpcd or @pdpcd is null) and (a.branch_code=@pbranchcode or @pbranchcode is null) and
				--(a.state_code=@pstatecode or @pstatecode is null) and (a.dist_code=@pdistcode or @pdistcode is null) and 
				--(a.tehsil_taluka=@ptalukacode or @ptalukacode is null) and (a.ag_class=@pextra1 or @pextra1 is null)
				--order by a.branch_code,a.city_code,a.ag_name;
		  
			open c1
				fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit,@v1_agcd,@v1_dpcd,@v1_ag_name,@v1_ag_name_oth_lang,@v1_city_code,@v1_tehsil_taluka,@v1_dist_code,@v1_state_code,@v1_country_code,@v1_branch_code,@v1_addr1,@v1_ADDR2,@v1_ADDR3,@v1_PIN_CODE
				WHILE (@@FETCH_STATUS = 0)  Begin
				set @v_opbal =dbo.cir_accounts_cir_agency_opbal(@pcompcode, @punitcode,null,@v1_agcd, @v1_dpcd, @v_opdate, @pactype,@pdateformat,null,null)
		print('@')
				----for secutiry outstanding---
				If @pactype='SC' Begin
					set @v_opbal_sec	=dbo.cir_accounts_cir_agency_opbal(@pcompcode, @punitcode,null,@v1_agcd,@v1_dpcd,@v_opdate,'SC',@pdateformat,null,null)

					select @v_dbcramt	=sum(amount) from cir_rcphdr
					where comp_code = @pcompcode and unit_code= @punitcode and 
						agcd=@v1_agcd and dpcd=@v1_dpcd and recptdt>= @v_opdate and recptdt<=@v_todt and achd='SC'

					set @v_opbal_sec=isnull(@v_opbal_sec,0)+isnull(@v_dbcramt,0)
				End
				Else Begin
					set @v_opbal_sec =0
				End

				----for secutiry outstanding---
				set @v_dbcramt=0

				select @v_billamt=sum(amount) from cir_outmast
					where comp_code = @pcompcode and unit_code=@punitcode and 
						agcd=@v1_agcd and dpcd=@v1_dpcd and billdt >= @v_opdate and billdt<@v_frdt and 
						achd=@pactype and recptno is null

				select @v_dbcramt=sum(amount) from cir_rcpdet
					where comp_code=@pcompcode and unit_code=@punitcode and 
						agcd=@v1_agcd and dpcd=@v1_dpcd and recptdt>= @v_opdate and recptdt<@v_frdt and 
						achd=@pactype and billno is null

				set @v_opbal=isnull(@v_opbal,0)+isnull(@v_billamt,0)+isnull(@v_dbcramt,0)

				set @v_rec_seqno=isnull(@v_rec_seqno,0)+1

				insert into #cir_ledger_report
					(comp_code,unit_code,branch_code,agcd,dpcd,doctype,recptno,recptdt,amount,
					exec_code,remarks,chqno,chqdt,chq_bank,reason,debit_head,credit_head,
					billno,billdt,billamt,adjamt,leftamt,agname,rec_seqno,narr_line
					,ISSUE_DATE,PRODUCT,QUANTITY,UNIT_PRICE,addr1,ADDR2,ADDR3,PIN_CODE)
				values(@v1_comp_code,@v1_unit,@v1_branch_code,@v1_agcd,@v1_dpcd,null,null,@v_frdt,@v_opbal_sec,
					null,'Security Balance',null,null,null,null,null,null,
					null,null,null,null,null,@v1_ag_name,@v_rec_seqno,1,null,null,null,null,@v1_addr1,@v1_ADDR2,@v1_ADDR3,@v1_PIN_CODE)

				set @v_rec_seqno = isnull(@v_rec_seqno,0)+1

				set @v_runbal = @v_opbal
		            
				If @v_runbal>=0 Begin
					set @v_runbal_txt= CONVERT(VARCHAR, CONVERT( numeric(14, 2), @v_runbal ))--+' Dr.'
				End
				Else Begin
					set @v_runbal_txt=CONVERT(VARCHAR, CONVERT( numeric(14, 2), ABS(@v_runbal) ))--+' Cr.'
				End
		            
				insert into #cir_ledger_report
					(comp_code,unit_code,branch_code,agcd,dpcd,doctype,recptno,recptdt,amount,
					exec_code,remarks,chqno,chqdt,chq_bank,reason,debit_head,credit_head,
					billno,billdt,billamt,adjamt,leftamt,agname,rec_seqno,narr_line,ISSUE_DATE,PRODUCT,QUANTITY,UNIT_PRICE,addr1,ADDR2,ADDR3,PIN_CODE)
				values(@v1_comp_code,@v1_unit,@v1_branch_code,@v1_agcd,@v1_dpcd,null,null,@v_frdt,@v_opbal,
					null,'Opening Balance',null,null,null,null,null,null,
					null,null,null,null,null,@v1_ag_name,@v_rec_seqno,2,null,null,null,null,@v1_addr1,@v1_ADDR2,@v1_ADDR3,@v1_PIN_CODE)
		 
		 print('set')print(@v1_unit)print(@v1_agcd) print(@v1_dpcd) print(@v_frdt) print(@v_todt) print(@pactype)       

				declare c2 cursor for
					select u.comp_code comp_code,u.unit_code unit_code,u.agcd agcd,u.dpcd dpcd,u.doctype doctype,u.recptno recptno,u.recptdt recptdt,u.amount amount,u.chno chno,u.chdt chdt,u.chbank chbank,u.reason reason,
					u.narration narration,u.received_from received_from from 
					(select comp_code,unit_code,agcd,dpcd,doctype,recptno,recptdt,amount,chno,chdt,chbank,reason,remark narration,received_from from cir_rcphdr
						where comp_code=@v1_comp_code and unit_code=@v1_unit and agcd=@v1_agcd and dpcd=@v1_dpcd and recptdt 
							between @v_frdt and @v_todt and case isnull( achd,'NM')  when '' then 'NM' else achd end=@pactype
					union all
					select comp_code,unit_code,agcd,dpcd,'BIL' doctype,billno recptno,billdt recptdt,sum(bill_amount) amount,null chno,null chdt,null chbnk,'BILL' reason,
					'Bill Copy '+ cast(sum(bill_copy) as VARCHAR)+' Trade Disc. '+cast(sum(comm_amount) as VARCHAR) narration,null received_from from cir_bill
						where comp_code=@v1_comp_code and unit_code=@v1_unit and agcd=@v1_agcd and dpcd=@v1_dpcd and 
							billdt between @v_frdt and @v_todt and (@pactype='NM' or @pactype is null or @pactype ='')
							group by comp_code,unit_code,agcd,dpcd,billno,billdt
					/*union all
					select comp_code,unit_code,agcd,dpcd,doctyp doctype,billno recptno,billdt recptdt,sum(amount) amount,null chno,null chdt,null chbnk, reason,
					remark narration,null received_from from cir_outmast
						where comp_code=@v1_comp_code and unit_code=@v1_unit and agcd=@v1_agcd and dpcd=@v1_dpcd and 
							billdt between @v_frdt and @v_todt and @pactype='NM' and isnull(amount,0)>0 and billno is null 
							group by comp_code,unit_code,agcd,dpcd,billno,billdt,doctyp,reason,remark		*/
							)u
					order by recptdt,doctype,recptno
					
				declare @vbillno_rcr as varchar(40)
				declare @vbilldt_rcr as datetime
				--------daily transactions------------
					open c2
					fetch NEXT FROM c2 INTO @v2_comp_code,@v2_unit_code,@v2_agcd,@v2_dpcd,@v2_doctype,@v2_recptno,@v2_recptdt,@v2_amount,@v2_chno,@v2_chdt,@v2_chbank,@v2_reason,@v2_narration,@v2_received_from
					WHILE (@@FETCH_STATUS = 0) Begin
						
						If isnull(@v2_amount,0)<>0 Begin
							set @v_rec_seqno=isnull(@v_rec_seqno,0)+1
							set @v_narration=null
								If @v2_doctype='BIL' Begin
									set @v_narration=@v2_narration
									select distinct @v1_issue_date=TODT,@v1_product_code=PUBL,@v1_quantity=sum(BILL_COPY)
									,@v1_unit_price=COPY_RATE,@v1_commrate=COMM_RATE from cir_bill_det
									where COMP_CODE=@pcompcode and UNIT_CODE=@v2_unit_code and BILLNO=@v2_recptno and BILLDT=@v2_recptdt and AGCD=@v2_agcd and DPCD=@v2_dpcd
									group by TODT,PUBL,COPY_RATE,COMM_RATE
								End
								else If @v2_doctype='UCN' Begin
									set @v_narration=@v2_narration
									select distinct @v1_issue_date=SUPDATE,@v1_product_code=PUBL,@v1_quantity=sum(APR_BNR+APR_DAMAGE+APR_LATE_RECPT+APR_SHORT_RECPT+APR_UNSOLD)
									,@v1_unit_price=COPY_RATE,@v1_commrate=COMM_RATE from CIR_UNSOLD_DTL
									where COMP_CODE=@pcompcode and UNIT_CODE=@v2_unit_code and PROCESS_CRNO=@v2_recptno and AGCD=@v2_agcd and DPCD=@v2_dpcd
									group by SUPDATE,PUBL,COPY_RATE,COMM_RATE
								End
								else If @v2_doctype='RCR' Begin
									print('Payment received' + @v2_recptno)
									
									select @vbillno_rcr=max(BILLNO),@vbilldt_rcr=max(BILLDT) from CIR_OUTMAST 
									where RECPTNO=@v2_recptno and DOCTYP='RCR' and BILLNO is not null and BILLDT is not null 
									and AGCD=@v2_agcd and DPCD=@v2_dpcd
									
									select distinct @v1_issue_date=TODT,@v1_product_code=PUBL,@v1_quantity=sum(BILL_COPY)
									,@v1_unit_price=COPY_RATE,@v1_commrate=COMM_RATE from cir_bill_det
									where COMP_CODE=@pcompcode and UNIT_CODE=@v2_unit_code and BILLNO=@vbillno_rcr 
									and BILLDT=@vbilldt_rcr and AGCD=@v2_agcd and DPCD=@v2_dpcd
									group by TODT,PUBL,COPY_RATE,COMM_RATE
									
									if @v1_issue_date is null or @v1_issue_date ='' begin
										select @v1_issue_date=RECPTDT,@v1_product_code='DN' from CIR_RCPHDR where COMP_CODE=@pcompcode and UNIT_CODE=@v2_unit_code 
										and RECPTNO=@vbillno_rcr and RECPTDT=@vbilldt_rcr 
										and AGCD=@v2_agcd and DPCD=@v2_dpcd and DOCTYPE='DN'
									end
									
								end
								Else  
								Begin
										set @v1_issue_date=null
										set @v1_product_code=null
										set @v1_quantity=null
										set @v1_unit_price=null
										set @v1_commrate=null
									If @v2_narration is not null 
									Begin
										set @v_narration=@v2_narration
													
										If @v2_chno is not null and @v2_chno !=''
										Begin
											set @v_narration=@v_narration+' CHNO: '+@v2_chno
										End
										If @v2_chdt is not null and @v2_chdt !=''
										Begin
											set @v_narration=@v_narration+' CHDT: '+ 
											case @pdateformat when 'dd/mm/yyyy' then convert(varchar(10),@v2_chdt,103)  when 'mm/dd/yyyy' then convert(varchar(10),@v2_chdt,101) when 'yyyy/mm/dd' then convert(varchar(10),@v2_chdt,111) end
										End
										If @v2_chbank is not null and @v2_chbank !=''
										Begin
										select @v2_chbank=BANKNAME  from CIR_BANK_MAST where COMP_CODE=@pcompcode and BANKCODE=@v2_chbank
											set @v_narration=@v_narration+' CHBNK: '+@v2_chbank
										End
										If @v2_reason='CA0' and @v2_doctype='RCR' 
										Begin
											set @v_narration='By Cash '+@v_narration
										End
									End
								End
						End	
						Else 
						Begin print('test')
							If @v2_chno is not null and @v2_chno !=''
							Begin
								set @v_narration='CHNO: '+@v2_chno
							End
							If @v2_chdt is not null and @v2_chdt !=''
										Begin
											set @v_narration=@v_narration+' CHDT: '+ 
											case @pdateformat when 'dd/mm/yyyy' then convert(varchar(10),@v2_chdt,103)  when 'mm/dd/yyyy' then convert(varchar(10),@v2_chdt,101) when 'yyyy/mm/dd' then convert(varchar(10),@v2_chdt,111) end
										End
										If @v2_chbank is not null and @v2_chbank !=''
										Begin
										select @v2_chbank=BANKNAME  from CIR_BANK_MAST where COMP_CODE=@pcompcode and BANKCODE=@v2_chbank
											set @v_narration=@v_narration+' CHBNK: '+@v2_chbank
										End
							If @v2_reason='CA0' and @v2_doctype='RCR' 
							Begin
								set @v_narration='By Cash '+@v_narration
							End
						End

					set @v_remark_len = LEN(ISNULL(LTRIM(RTRIM(@v_narration)), '-'))
					set @v_amt=isnull(@v_amt,0)+isnull(@v2_amount,0)
					                    

					set @v_runbal = @v_runbal+isnull(@v2_amount,0)

					If @v_runbal>=0 Begin
						set @v_runbal_txt= CONVERT(VARCHAR, CONVERT( numeric(14, 2), @v_runbal ))--+' Dr.'
					End
					Else Begin
						set @v_runbal_txt=CONVERT(VARCHAR, CONVERT( numeric(14, 2), (@v_runbal) ))--+' Cr.'
					End
					                                        
					If isnull(@v2_amount,0)>=0 Begin
						set @v_dbamt=isnull(@v_dbamt,0)+isnull(@v2_amount,0)
					End
					If isnull(@v2_amount,0)<0 Begin
						set @v_cramt=isnull(@v_cramt,0)+abs(isnull(@v2_amount,0))
					End

					
					
		print('#')	
		print(@v_remark_len)
		print(@v_divident)	
		
		set @v1_unit_price=round(@v1_unit_price-((isnull(@v1_unit_price,0)*isnull(@v1_commrate,1))/100),3)
			
					insert into #cir_ledger_report
						  (comp_code,unit_code,branch_code,agcd,dpcd,doctype,recptno,recptdt,amount,
						  exec_code,remarks,chqno,chqdt,chq_bank,reason,debit_head,credit_head,
						  billno,billdt,billamt,adjamt,leftamt,agname,rec_seqno,narr_line
						  ,ISSUE_DATE,PRODUCT,QUANTITY,UNIT_PRICE,addr1,ADDR2,ADDR3,PIN_CODE)
					  values(@v1_comp_code, @v1_unit, @v1_branch_code, @v1_agcd, @v1_dpcd, @v2_doctype, @v2_recptno, @v2_recptdt, @v2_amount,
							 @v2_received_from,isnull(ltrim(rtrim(@v_narration)),'-'), @v2_chno, @v2_chdt, @v2_chbank, @v2_reason,null, @v_runbal_txt,
							 null, null, null, null, @v_runbal, @v1_ag_name, @v_rec_seqno, dbo.mod_function(@v_remark_len, @v_divident)
							 ,@v1_issue_date,@v1_product_code,@v1_quantity,@v1_unit_price,@v1_addr1,@v1_ADDR2,@v1_ADDR3,@v1_PIN_CODE)
		print('$')
					fetch NEXT FROM c2 INTO @v2_comp_code,@v2_unit_code,@v2_agcd,@v2_dpcd,@v2_doctype,@v2_recptno,@v2_recptdt,@v2_amount,@v2_chno,@v2_chdt,@v2_chbank,@v2_reason,
					@v2_narration,@v2_received_from
				End

				close c2
				deallocate c2
				
				--------daily transactions------------
		            
				
				print('ggg')print(@v_runbal)
				set @v_rec_seqno=isnull(@v_rec_seqno,0)+1
				If @v_runbal>=0 Begin
					set @v_runbal_txt= CONVERT(VARCHAR, CONVERT( numeric(14, 2), @v_runbal )) --+' Dr.'
				End
				Else Begin
					set @v_runbal_txt= CONVERT(VARCHAR, CONVERT( numeric(14, 2), (@v_runbal) )) --+' Cr.'
				End
					print('gggqq')print(@v_runbal_txt)
					insert into #cir_ledger_report
					(comp_code,unit_code,branch_code,agcd,dpcd,doctype,recptno,recptdt,amount,
					exec_code,remarks,chqno,chqdt,chq_bank,reason,debit_head,credit_head,
					billno,billdt,billamt,adjamt,leftamt,agname,rec_seqno,narr_line,ISSUE_DATE,PRODUCT,QUANTITY,UNIT_PRICE,addr1,ADDR2,ADDR3,PIN_CODE)
					values(@v1_comp_code, @v1_unit, @v1_branch_code, @v1_agcd, @v1_dpcd, null, null, @v_todt,isnull(@v_clbal,0),
					null,'Closing Balance',null,null,null,null,null,null,
					null,null,null,null,null, @v1_ag_name, @v_rec_seqno,1,@v1_issue_date,@v1_product_code,@v1_quantity,@v1_unit_price,@v1_addr1,@v1_ADDR2,@v1_ADDR3,@v1_PIN_CODE)

				If isnull(@v_opbal_sec,0)=0 and isnull(@v_opbal,0)=0 and @v_cramt=0 and @v_dbamt=0 Begin
				   delete from #cir_ledger_report where comp_code = @v1_comp_code and unit_code = @v1_unit and
					agcd = @v1_agcd and dpcd = @v1_dpcd
				End

				set @v_billamt=0 set @v_dbcramt=0 set @v_opbal=0 set @v_clbal=0 set @v_amt=0 set @v_runbal=0 set @v_cramt=0 set @v_dbamt=0 set @v_runbal_txt=null
		        
				fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit,@v1_agcd,@v1_dpcd,@v1_ag_name,@v1_ag_name_oth_lang,@v1_city_code,@v1_tehsil_taluka,@v1_dist_code,@v1_state_code,
					@v1_country_code,@v1_branch_code,@v1_addr1,@v1_ADDR2,@v1_ADDR3,@v1_PIN_CODE
				End

				close c1
				DEALLOCATE c1
		/*
		SELECT (SELECT distinct Comp_Name FROM  comp_mst WHERE Comp_Code  = a.comp_code) as "CNAME",
		COMP_CODE,UNIT_CODE,BRANCH_CODE,(select distinct "Branch_Name" from branch_mst where Comp_Code=a.Comp_Code and "Branch_Code"=a.BRANCH_CODE) "BRANCH_NAME",
		AGCD,DPCD,AGNAME,DBO.cir_get_agency_city(comp_code,unit_code,agcd,dpcd) CITY_NAME,
		DOCTYPE,RECPTNO,RECPTDT,
		CASE a.debit WHEN 'D' THEN a.amount END as DEBIT,
		CASE a.credit WHEN 'C' THEN a.amount END as CREDIT,
		EXEC_CODE,REMARKS,CHQNO,CHQDT,CHQ_BANK,REASON,DEBIT_HEAD,CREDIT_HEAD,BILLNO,BILLDT,BILLAMT,
		ADJAMT,LEFTAMT,REC_SEQNO,narr_line
		,a.ISSUE_DATE as ISSUE_DATE,(Select distinct PUBL_NAME from CIR_PUBL_MAST p where p.COMP_CODE=@pcompcode and p.PUBL=a.PRODUCT) as PRODUCT
		,a.QUANTITY,a.UNIT_PRICE,a.addr1,a.ADDR2,a.ADDR3,a.PIN_CODE
		FROM (SELECT comp_code,unit_code,branch_code,agcd,dpcd,agname,doctype,recptno,recptdt,
		CASE sign(amount) WHEN 1 THEN 'D' END as debit,
		CASE sign(amount) WHEN - 1 THEN 'C' END as credit,
		 ABS(amount) as amount,exec_code,remarks,chqno,chqdt,chq_bank,reason,debit_head,credit_head,
		 billno,billdt,billamt,adjamt,leftamt,rec_seqno,ISNULL(narr_line, 1) as narr_line
		 ,ISSUE_DATE,PRODUCT,QUANTITY,UNIT_PRICE,addr1,ADDR2,ADDR3,PIN_CODE
		FROM  #cir_ledger_report 
		WHERE comp_code  = @pcompcode AND unit_code  = @punitcode) a 
		ORDER BY rec_seqno 
		*/

			SELECT (SELECT distinct Comp_Name FROM  comp_mst WHERE Comp_Code  = a.comp_code) as "CNAME",
			COMP_CODE,UNIT_CODE,BRANCH_CODE
			,(select distinct "Branch_Name" from branch_mst where Comp_Code=a.Comp_Code and "Branch_Code"=a.BRANCH_CODE) "BRANCH_NAME",
			AGCD,DPCD,AGNAME,DBO.cir_get_agency_city(comp_code,unit_code,agcd,dpcd) CITY_NAME,
			case DOCTYPE
			when 'BIL' then 'INVOICE'
			when 'RCR' then 'PAYMENT'
			when 'UCN' then 
				case REASON 
				when 'NO0' then 'RETURN[Pulangan Biasa]'
				when 'UNSOLD CREDIT NOTE' then 'RETURN[Pulangan Biasa]'
				else isnull((Select reason_name from CIR_REASON_MST t where t.COMP_CODE=a.COMP_CODE and t.REASON_CODE=a.REASON ),'UNSOLD CREDIT NOTE') end
			when 'DN' then 
				case REASON
				when 'CH0' then 'Return '+remarks--'Return Cheque'				
				else isnull(REMARKS,(Select reason_name from CIR_REASON_MST t where t.COMP_CODE=a.COMP_CODE and t.REASON_CODE=a.REASON )) end 	
			when 'CN' then
				case isnull(REMARKS,'~')
				when '' then reason
				when '~' then reason				
				else REMARKS end
			end DOCTYPE
			,RECPTNO,case @pdateformat			
			when 'dd/mm/yyyy' then CONVERT(varchar(10),RECPTDT,103)
			when 'mm/dd/yyyy' then CONVERT(varchar(10),RECPTDT,101)
			when 'yyyy/mm/dd' then CONVERT(varchar(10),RECPTDT,111)
			end  RECPTDT,
			CASE a.debit WHEN 'D' THEN a.amount END as DEBIT,
			CASE a.credit WHEN 'C' THEN a.amount END as CREDIT,
			EXEC_CODE,REMARKS,CHQNO,CHQDT,CHQ_BANK,REASON,DEBIT_HEAD,CREDIT_HEAD,BILLNO,BILLDT,BILLAMT,
			ADJAMT,LEFTAMT,REC_SEQNO,narr_line,
			case @pdateformat			
			when 'dd/mm/yyyy' then CONVERT(varchar(10),a.ISSUE_DATE,103)
			when 'mm/dd/yyyy' then CONVERT(varchar(10),a.ISSUE_DATE,101)
			when 'yyyy/mm/dd' then CONVERT(varchar(10),a.ISSUE_DATE,111)
			end  
			 as ISSUE_DATE
			 ,case a.PRODUCT when 'DN' then 'Debit Note' else
			 (Select distinct PUBL_NAME from CIR_PUBL_MAST p where p.COMP_CODE=@pcompcode and p.PUBL=a.PRODUCT) end as PRODUCT
			,a.QUANTITY,a.UNIT_PRICE,a.addr1,a.ADDR2,a.ADDR3,a.PIN_CODE
			FROM (SELECT comp_code,unit_code,branch_code,agcd,dpcd,agname,doctype,recptno,recptdt,
			CASE sign(amount) WHEN 1 THEN 'D' END as debit,
			CASE sign(amount) WHEN - 1 THEN 'C' END as credit,
			 ABS(amount) as amount,exec_code,remarks,chqno,chqdt,chq_bank,reason,debit_head,credit_head,
			 billno,billdt,billamt,adjamt,leftamt,rec_seqno,ISNULL(narr_line, 1) as narr_line
			 ,ISSUE_DATE,PRODUCT,QUANTITY,UNIT_PRICE,addr1,ADDR2,ADDR3,PIN_CODE
			FROM  #cir_ledger_report 
			WHERE comp_code  = @pcompcode AND unit_code  = @punitcode) a 
			ORDER BY rec_seqno 

			SELECT (SELECT Comp_Name FROM  comp_mst WHERE Comp_Code  = a.comp_code) as "CNAME",
			COMP_CODE,AGCD,DPCD,AGNAME,(SELECT COUNT(*) FROM 
			( SELECT     comp_code,     unit_code,     branch_code,     agcd,     dpcd,     agname,     doctype,     recptno,     recptdt,        
			CASE sign(amount)     WHEN 1 THEN 'D' END as DEBIT,
			CASE sign(amount)     WHEN - 1 THEN 'C'    END as CREDIT,ABS(amount) as AMOUNT,     rec_seqno,NARR_LINE
			FROM  #cir_ledger_report   WHERE  comp_code  = @pcompcode   AND unit_code  = @punitcode ) adv_alias_1  
			WHERE  adv_alias_1.comp_code  = a.comp_code  AND adv_alias_1.agcd  = a.agcd  AND adv_alias_1.dpcd  = a.dpcd  AND adv_alias_1.agname  = a.agname ) adv_count_value,
			ISNULL(SUM(CONVERT(FLOAT, narr_line)), 0) sum_narr
			FROM (SELECT comp_code,unit_code,branch_code,agcd,dpcd,agname,doctype,recptno,recptdt,
			CASE sign(amount) WHEN 1 THEN 'D' END as debit,
			CASE sign(amount) WHEN - 1 THEN 'C' END as credit,ABS(amount) as amount,rec_seqno,narr_line
			FROM  #cir_ledger_report 
			WHERE comp_code  = @pcompcode AND unit_code  = @punitcode) a 
			group by a.comp_code,a.agcd,a.dpcd,a.agname
			ORDER BY comp_code,agcd,dpcd,agname 
	end
	drop table #cir_ledger_report

	drop table #cir_summary_statement
	
END


/**9 feb**/  
/**21 feb*/                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE [dbo].[cir_ledger_ageing]
@pcomp_code varchar(20),
@punit_code varchar(20),
@pbran_code varchar(20),
@pzone_code varchar(30),
@pregion_code varchar(30),
@pdist_code varchar(20),
@ptaluka_code varchar(20),
@pagtype varchar(50),
@pagclass varchar(50),
@pag_main_code varchar(50),
@pag_sub_code varchar(50),
@paging_by varchar(50),
@pasondt datetime,
@pdebitupto_date datetime,
@pcreditupto_date datetime,
@pdateformat varchar(20),
@puserid varchar(20),
@pextra1 varchar(20),
@pextra2 varchar(20),
@pextra3 varchar(30),
@pextra4 varchar(30),
@pextra5 varchar(50)
As

--------- slabs end

declare @ptill_days1 as varchar(20)
declare @ptill_days2 as varchar(20)
declare @ptill_days3 as varchar(30)
declare @ptill_days4 as varchar(30)
declare @ptill_days5 as varchar(50)
declare @ptill_days6 as varchar(50)
declare @ptill_current as varchar(50)
---------------- slabs

declare @vtodt as datetime
declare @vasondt as datetime
declare @v_dt as datetime
declare @v_ondt as datetime
declare @v_days numeric(10);
declare @v_pending_rcpt_amt as numeric(14,2)
declare @v_amt as numeric(14,2);
declare @v_amt030 as numeric(14,2);
declare @v_amt3160 as numeric(14,2);
declare @v_amt6190 as numeric(14,2);
declare @v_amt91120 as numeric(14,2);
declare @v_amt121180 as numeric(14,2);
declare @v_amt181 as numeric(14,2);
declare @v_amtcur as numeric(14,2);
declare @debit_amt_030 as numeric(14,2) --debit amt for slab 1 days
declare @debit_amt_3160 as numeric(14,2) --debit amt for slab 2 days
declare @debit_amt_6190 as numeric(14,2) --debit amt for slab 3 days
declare @debit_amt_91120 as numeric(14,2) --debit amt for slab 4 days
declare @debit_amt_121180 as numeric(14,2) --debit amt for >slab 5 days
declare @debit_amt_181 as numeric(14,2) --debit amt for >slab 6 days
declare @debit_amt_cur as numeric(14,2) --debit amt for >current
declare @bill_pending_amt as numeric(14,2)
declare @rcpt_pending_amt as numeric(14,2) --pending receipt amount

CREATE TABLE #cir_temp_ageing
(
	COMP_CODE VARCHAR(8),
	UNIT_CODE VARCHAR(8),
	BRAN_CODE VARCHAR(8),
	AGCD VARCHAR(8),
	DPCD VARCHAR(8),
	AG_NAME VARCHAR(100),
	CITY_NAME VARCHAR(100),
	PENDING_AMT NUMERIC(14,2),
	CUR_AMT NUMERIC(14,2),
	SLAB_1 NUMERIC(14,2),
	SLAB_2 NUMERIC(14,2),
	SLAB_3 NUMERIC(14,2),
	SLAB_4 NUMERIC(14,2),
	SLAB_5 NUMERIC(14,2),
	SLAB_6 NUMERIC(14,2),
	ON_ACAMT NUMERIC(14,2),
	RECT_PENDING NUMERIC(14,2),
	SESSIONID NUMERIC(14),
	PUBNAME VARCHAR(200),
	ageing varchar(1),
	deb_adj_amt numeric(14,2)
)

set @debit_amt_030 =0 --debit amt for slab 1 days
set @debit_amt_3160 =0 --debit amt for slab 2 days
set @debit_amt_6190 =0 --debit amt for slab 3 days
set @debit_amt_91120 =0 --debit amt for slab 4 days
set @debit_amt_121180 =0 --debit amt for >slab 4 days
set @debit_amt_181 =0 --debit amt for >slab 4 days
set @debit_amt_cur =0 --debit amt for >current
set @bill_pending_amt =0
set @rcpt_pending_amt =0 --pending receipt amount
-- cursor cur_agency variables

declare @rec_agency_comp_code as varchar(30)
declare @rec_agency_agcd as varchar(20)
declare @rec_agency_dpcd as varchar(30)
declare @rec_agency_agency_name as varchar(300)
declare @rec_agency_city_code as varchar(200)
declare @rec_agency_city_name as varchar(200)
declare @rec_agency_credit_days as int
declare @rec_agency_branch_name as varchar(50)
declare @rec_agency_ageing_type as varchar(1)
--@rec_agency_comp_code,@rec_agency_agcd,@rec_agency_dpcd,@rec_agency_agency_name,@rec_agency_city_code,@rec_agency_city_name,

--@rec_agency_credit_days,@rec_agency_branch_name,@rec_agency_ageing_type

declare cur_agency_1 cursor for
select m.Comp_Code ,m.agcd ,m.dpcd ,m.ag_name ,m.City_Code,c.city_name,m.credit_days,m.branch_code,m.ageing_type
from cir_agmast m,cir_city_mast c
where m.comp_code=c.comp_code and m.comp_code=@pcomp_code
and m.unit=@punit_code and m.city_code=c.city_code
and (m.Dist_Code=@pdist_code or @pdist_code is null or @pdist_code ='')
and (m.tehsil_taluka=@ptaluka_code or @ptaluka_code is null or @ptaluka_code ='')
and (m.agcd=@pag_main_code or @pag_main_code is null or @pag_main_code ='')
and (m.dpcd=@pag_sub_code or @pag_sub_code is null or @pag_sub_code ='')

if @pdebitupto_date is null or @pdebitupto_date=''
begin
	set @pdebitupto_date =@pasondt
end
if @pcreditupto_date is null or @pcreditupto_date=''
begin
	set @pcreditupto_date =@pasondt
end
if @pasondt is null or @pasondt =''
begin
	set @pasondt=@pcreditupto_date
end

declare @fetch_protype as varchar(20)
declare @fetch_pub as varchar(20)
-- cursor v_bill variables

declare @v_bill_billno as varchar(50)
declare @v_bill_billdt as varchar(30)
declare @v_bill_bill_amt as numeric(15,2)
-- cursor v_pending_rcpt variables

declare @v_pending_rcpt_ag_main_code as varchar(30)
declare @v_pending_rcpt_ag_sub_code as varchar(50)
declare @v_pending_rcpt_amount as numeric(15,2)
declare @fetch_pubname as varchar(200)
declare @fetch_pubtype as varchar(200)
--SELECT 'cursor has ' + CAST(@@CURSOR_ROWS AS VARCHAR) + ' rows'

declare @v_mcnt1 as datetime
declare @v_mcnt2 as datetime
declare @v_mcnt3 as datetime
declare @v_mcnt4 as datetime
declare @v_mcnt5 as datetime
declare @vtill_days1 AS int
declare @vtill_days2 AS int
declare @vtill_days3 AS int
declare @vtill_days4 AS int
declare @vtill_days5 AS int
declare @vrec_agency_ageing_type as varchar(10)

	open cur_agency_1
		fetch NEXT FROM cur_agency_1 INTO @rec_agency_comp_code,@rec_agency_agcd,@rec_agency_dpcd,@rec_agency_agency_name,@rec_agency_city_code,@rec_agency_city_name,@rec_agency_credit_days,@rec_agency_branch_name,@rec_agency_ageing_type
		WHILE (@@FETCH_STATUS = 0)
		begin
			declare @day as int
			
			declare cur_agency cursor for
			select distinct publ from cir_supply where comp_code=@pcomp_code and agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd order by publ
			--select distinct dbo.cir_get_publ_type(comp_code,publ,'C','') publ from cir_supply where comp_code=@pcomp_code and agcd=@pag_main_code and dpcd=@pag_sub_code order by publ
			print
			('@rec_agency_ageing_type')print(@rec_agency_ageing_type)
			open cur_agency
				fetch NEXT FROM cur_agency INTO @fetch_pub
				WHILE (@@FETCH_STATUS = 0)
				BEGIN 
					print('dddddd') print(@fetch_pub)
					
					select distinct @fetch_protype=pro_type,@fetch_pubname=PUBL_NAME,@fetch_pubtype=
					(Select pubname from pub_type_mast where Comp_Code=@pcomp_code and pub_type_mast.pubtypecode=CIR_PUBL_MAST.PRO_TYPE)
					from CIR_PUBL_MAST where COMP_CODE=@pcomp_code and publ=@fetch_pub					
					
					print('@fetch_protype')print(@fetch_protype)
					print('@@fetch_pubname')print(@fetch_pubname)
					print('@fetch_pubtype')print(@fetch_pubtype)
					
					if @fetch_protype ='MA0'
					begin
						set @vrec_agency_ageing_type='M'
					end
					else
					begin
						set @vrec_agency_ageing_type=@rec_agency_ageing_type
					end
					select @ptill_days1=SLAB_TILL1,@ptill_days2=SLAB_TILL2,@ptill_days3=SLAB_TILL3,@ptill_days4=SLAB_TILL4
					,@ptill_days5=SLAB_TILL5,@ptill_days6=SLAB_TILL6--,@rec_agency_ageing_type=AGEING_TYPE
					from CIR_AGEING_SLAB_MAST
					where COMP_CODE=@pcomp_code and PRO_TYPE=@fetch_protype
					
					print ('slab')print(@ptill_days1)print(@ptill_days2)print(@ptill_days3)print(@ptill_days4)print(@ptill_days5)
					print (@ptill_days6)print(@rec_agency_ageing_type)
					print ('gaurav')
					print (@vrec_agency_ageing_type)
					print (@pasondt)
					print (dbo.GetLastDayOfMonth(@pasondt))
					print ('debug')
					
					if upper(@vrec_agency_ageing_type) = 'D'
					begin
						set @vtodt=dateadd(dd,-1,@pasondt)
					end
					else if upper(@vrec_agency_ageing_type) = 'W'
					begin
						select @day=DATEPART(dw,@pasondt)
						print(@day)
						set @vtodt=dateadd(dd,-(@day-1),@pasondt)
					end
					else
					begin
						if dbo.GetLastDayOfMonth(@pasondt)=@pasondt
						begin
							set @vtodt=@pasondt
						end
						else
						begin
							set @vtodt=dbo.GetLastDayOfMonth(dateadd(mm,-1,@pasondt))
						end
					end
					print('come') print(@vrec_agency_ageing_type)
					print(@vtodt)
					print('custom')print(@ptill_days1)print(@ptill_days2)print(@ptill_days3)print(@ptill_days4)print(@ptill_days5)

					if @vrec_agency_ageing_type='M' begin print('gks')
						set @v_mcnt1=DATEADD(MM,-1*@ptill_days1,@vtodt+1)
						set @v_mcnt2=DATEADD(MM,-1*@ptill_days2,@vtodt+1)
						set @v_mcnt3=DATEADD(MM,-1*@ptill_days3,@vtodt+1)
						set @v_mcnt4=DATEADD(MM,-1*@ptill_days4,@vtodt+1)
						set @v_mcnt5=DATEADD(MM,-1*@ptill_days5,@vtodt+1)
						--DATEDIFF(dd, dbo.GetFirstDayOfMonth( @vtodt),@vtodt )+1
						set @vtill_days1=DATEDIFF(dd, dbo.GetFirstDayOfMonth( @v_mcnt1),@vtodt )+1
						set @vtill_days2=DATEDIFF(dd, dbo.GetFirstDayOfMonth( @v_mcnt2),@vtodt )+1
						set @vtill_days3=DATEDIFF(dd, dbo.GetFirstDayOfMonth( @v_mcnt3),@vtodt )+1
						set @vtill_days4=DATEDIFF(dd, dbo.GetFirstDayOfMonth( @v_mcnt4),@vtodt )+1
						set @vtill_days5=DATEDIFF(dd, dbo.GetFirstDayOfMonth( @v_mcnt5),@vtodt )+1
					end
					else if @vrec_agency_ageing_type='W'  
					begin print('weekly')
						--@vtodt
						set @v_mcnt1=DATEADD(ww,-1*@ptill_days1,@vtodt+1)
						set @v_mcnt2=DATEADD(ww,-1*@ptill_days2,@vtodt+1)
						set @v_mcnt3=DATEADD(ww,-1*@ptill_days3,@vtodt+1)
						set @v_mcnt4=DATEADD(ww,-1*@ptill_days4,@vtodt+1)
						set @v_mcnt5=DATEADD(ww,-1*@ptill_days5,@vtodt+1)
						
						set @vtill_days1=DATEDIFF(dd, @v_mcnt1,@vtodt )+1
						set @vtill_days2=DATEDIFF(dd, @v_mcnt2,@vtodt )+1
						set @vtill_days3=DATEDIFF(dd, @v_mcnt3,@vtodt )+1
						set @vtill_days4=DATEDIFF(dd, @v_mcnt4,@vtodt )+1
						set @vtill_days5=DATEDIFF(dd, @v_mcnt5,@vtodt )+1
					end
					else
					begin
						set @vtill_days1=@ptill_days1
						set @vtill_days2=@ptill_days2
						set @vtill_days3=@ptill_days3
						set @vtill_days4=@ptill_days4
						set @vtill_days5=@ptill_days5
					end
					print ('custom1')print(@vtill_days1)print(@vtill_days2)print(@vtill_days3)print(@vtill_days4)print(@vtill_days5)
					print @rec_agency_dpcd
					set @debit_amt_030 = 0;
					set @debit_amt_3160 = 0;
					set @debit_amt_6190 = 0;
					set @debit_amt_91120 = 0;
					set @debit_amt_121180 = 0;
					set @debit_amt_181 = 0;
					set @rcpt_pending_amt = 0;
					set @bill_pending_amt = 0;
					print('enter first')
					
					declare c_bill cursor for
					/*select distinct billno,billdt,sum(amount) bill_amt from cir_outmast
					where comp_code=@pcomp_code and unit_code=@punit_code and
					agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
					billdt <=@vtodt and isnull(abs(amount),0)>0
					group by comp_code,billno,billdt having sum(amount)>0 */
					-------------- this is for installment amount ------------------
					select distinct billno,billdt,isnull(sum(amount) -
					(SELECt INST_DUE_AMT from  CIR_INST_BILL_DET  
					where CIR_INST_BILL_DET.INST_BILLNO=CIR_OUTMAST.BILLNO 
					and CIR_INST_BILL_DET.INST_BILLDT=CIR_OUTMAST.BILLDT 
					and (CIR_INST_BILL_DET.recptno is null or CIR_INST_BILL_DET.recptno = '' )
					and (CIR_INST_BILL_DET.recptdt is null or CIR_INST_BILL_DET.recptdt = '' )
					) , sum(amount) ) bill_amt
					from cir_outmast
					where comp_code=@pcomp_code and unit_code=@punit_code and
					agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
					billdt <=@vtodt and isnull(abs(amount),0)>0
					group by comp_code,billno,billdt having sum(amount)>0
					
print('having sum(amount)<0') print(@vtodt)
					open c_bill
					fetch NEXT FROM c_bill INTO @v_bill_billno,@v_bill_billdt,@v_bill_bill_amt
						WHILE (@@FETCH_STATUS = 0)
						begin
							print('enter second')
							
							set @v_dt = @v_bill_billdt
							set @v_ondt = @vtodt
							print(@v_dt)
							print(@v_ondt)
							
							if @paging_by='D' begin
								set @v_days=DATEDIFF(dd, @v_dt,@v_ondt )---isnull(pcrdtday,0)+1;
							end
							else
							begin
								set @v_days=DATEDIFF(dd, @v_dt,@v_ondt )+1;
							end
							if @v_days<0 begin
								set @v_days=0;
							end
							print('x')
							print(@v_days)
							set @v_amt =0;
							set @v_amt030 =0;
							set @v_amt3160 =0;
							set @v_amt6190 =0;
							set @v_amt91120 =0;
							set @v_amt121180 =0;
							set @v_amt181 =0;
							
							if @v_days between 0 and @vtill_days1 
							begin
								select @v_amt030=sum(amount) from cir_outmast
								where comp_code=@pcomp_code and unit_code=@punit_code and
								agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
								billno =@v_bill_billno and billdt=@v_bill_billdt and
								recptdt <=@vasondt and amount<0
								set @v_amt030 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt030,0);
								set @debit_amt_030 =isnull(@debit_amt_030,0)+isnull(@v_amt030,0)
							end
							else if @v_days between isnull(@vtill_days1,0)+1 and @vtill_days2 
							begin
								select @v_amt3160=sum(amount) from cir_outmast
								where comp_code=@pcomp_code and unit_code=@punit_code and
								agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
								billno =@v_bill_billno and billdt=@v_bill_billdt and
								recptdt <=@vasondt and amount<0
							--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
								set @v_amt3160 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt3160,0);
								set @debit_amt_3160 =isnull(@debit_amt_3160,0)+isnull(@v_amt3160,0)
							end
							else if @v_days between isnull(@vtill_days2,0)+1 and @vtill_days3 
							begin
								select @v_amt6190=sum(amount) from cir_outmast
								where comp_code=@pcomp_code and unit_code=@punit_code and
								agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
								billno =@v_bill_billno and billdt=@v_bill_billdt and
								recptdt <=@vasondt and amount<0
							--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
								set @v_amt6190 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt6190,0);
								set @debit_amt_6190 =isnull(@debit_amt_6190,0)+isnull(@v_amt6190,0)
							end
							else if @v_days between isnull(@vtill_days3,0)+1 and @vtill_days4 
							begin
								select @v_amt91120=sum(amount) from cir_outmast
								where comp_code=@pcomp_code and unit_code=@punit_code and
								agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
								billno =@v_bill_billno and billdt=@v_bill_billdt and
								recptdt <=@vasondt and amount<0
							--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
								set @v_amt91120 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt91120,0);
								set @debit_amt_91120 =isnull(@debit_amt_91120,0)+isnull(@v_amt91120,0)
							end
							else if @v_days between isnull(@vtill_days4,0)+1 and @vtill_days5 
							begin
								select @v_amt121180=sum(amount) from cir_outmast
								where comp_code=@pcomp_code and unit_code=@punit_code and
								agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
								billno =@v_bill_billno and billdt=@v_bill_billdt and
								recptdt <=@vasondt and amount<0
							--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
								set @v_amt121180 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt121180,0);
								set @debit_amt_121180 =isnull(@debit_amt_121180,0)+isnull(@v_amt121180,0)
							end
							else
							begin
								select @v_amt181=sum(amount) from cir_outmast
								where comp_code=@pcomp_code and unit_code=@punit_code and
								agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
								billno =@v_bill_billno and billdt=@v_bill_billdt and
								recptdt <=@vasondt and amount<0
								--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
								set @v_amt181 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt181,0);
								set @debit_amt_181 =isnull(@debit_amt_181,0)+isnull(@v_amt181,0)
							end
					fetch NEXT FROM c_bill INTO @v_bill_billno,@v_bill_billdt,@v_bill_bill_amt
					end
				close c_bill
				deallocate c_bill

			declare @cur_from_dt as datetime
			print('t')
			print(@punit_code)
			print(@fetch_pub)
			set @cur_from_dt= dateadd(dd,1,@vtodt)
			print(@cur_from_dt)
			print(@pasondt)
			print('W')
			
			select @v_amtcur=sum(amount) from cir_outmast
			where comp_code=@pcomp_code and unit_code=@punit_code and
			agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
			billdt between @cur_from_dt and @pasondt
			--and RECPTNO is null and RECPTDT is null
			print(@fetch_pub)print(@cur_from_dt)print(@pasondt) 
			--and recptdt<=@pasondt and amount<0
			
			
		
			set @v_amt=isnull(@v_amtcur,0)+ isnull(@debit_amt_030,0)+isnull(@debit_amt_3160,0)+isnull(@debit_amt_6190,0)+isnull(@debit_amt_91120,0)+isnull(@debit_amt_121180,0)+isnull(@debit_amt_181,0)
			print('@v_amt amount here')print(@v_amt)print('@@v_amt')
			if @v_amt=0 
			begin
				set @debit_amt_030 = 0
				set @debit_amt_3160 = 0
				set @debit_amt_6190 = 0
				set @debit_amt_91120 = 0
				set @debit_amt_121180 = 0
				set @debit_amt_181 = 0				
			end
			else
			begin				
				set @bill_pending_amt=isnull(@v_amt,0)
			end
			print('zzz')
		
			insert into #cir_temp_ageing (comp_code,unit_code,agcd,dpcd,ag_name,city_name,pending_amt,CUR_AMT
			, SLAB_1 ,slab_2,slab_3,slab_4,slab_5,slab_6,rect_pending,on_acamt,sessionid,PUBNAME,ageing)
			values (@rec_agency_comp_code,@punit_code,@rec_agency_agcd, @rec_agency_dpcd, @fetch_protype,
			@fetch_pubname	,isnull(@bill_pending_amt,0),isnull(@v_amtcur,0)
			,isnull(@debit_amt_030,0),isnull(@debit_amt_3160,0), isnull(@debit_amt_6190,0)
			,isnull(@debit_amt_91120,0), isnull(@debit_amt_121180,0), isnull(@debit_amt_181,0),
			isnull(0,0),0,@@spid,@fetch_pubtype,@rec_agency_ageing_type);
			print('xxx')
			fetch NEXT FROM cur_agency INTO @fetch_pub
			set @debit_amt_030 = 0
			set @debit_amt_3160 = 0
			set @debit_amt_6190 = 0
			set @debit_amt_91120 = 0
			set @debit_amt_121180 = 0
			set @debit_amt_181 = 0
			set @rcpt_pending_amt = 0
			set @bill_pending_amt = 0
		end
		close cur_agency;
	deallocate cur_agency
	
			select @v_pending_rcpt_amt=sum(amount) from cir_outmast
			where comp_code=@pcomp_code and unit_code=@punit_code and
			agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd and ACHD='NM' and RECPTDT<@pcreditupto_date
			and BILLDT is null and BILLNO is null  and AMOUNT < 0			
declare @v_deb_anadjust as numeric(14,2)			
			
			/*select @v_deb_anadjust=sum(amount) from cir_outmast
			where comp_code=@pcomp_code and unit_code=@punit_code and
			agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd and ACHD='NM' and RECPTDT<@pcreditupto_date
			and BILLDT is null and BILLNO is null and amount > 0			*/
			select @v_deb_anadjust=SUM(amount) from CIR_OUTMAST a where DOCTYP='DN' 
			and a.comp_code=@pcomp_code and a.unit_code=@punit_code and
			a.agcd =@rec_agency_agcd and a.dpcd=@rec_agency_dpcd and a.ACHD='NM' and a.RECPTDT<@pcreditupto_date
			and not exists(
			SELECT * from CIR_OUTMAST b where  a.comp_code =b.COMP_CODE and a.UNIT_CODE=b.UNIT_CODE 
			and a.AGCD=b.AGCD and a.DPCD=b.DPCD and a.RECPTNO =b.BILLNO
			and b.comp_code=@pcomp_code and b.unit_code=@punit_code and
			b.agcd =@rec_agency_agcd and b.dpcd=@rec_agency_dpcd and b.ACHD='NM' and b.RECPTDT<@pcreditupto_date)
	
	--set @v_pending_rcpt_amt=(@v_deb_anadjust- ABS(@v_pending_rcpt_amt))
			print('receipt amount here')print(@v_pending_rcpt_amt) print(@v_deb_anadjust)print('@v_pending_rcpt_amt')
		
			

			insert into #cir_temp_ageing (comp_code,unit_code,agcd,dpcd,ag_name,city_name,pending_amt,CUR_AMT
			, SLAB_1 ,slab_2,slab_3,slab_4,slab_5,slab_6,rect_pending,on_acamt,sessionid,PUBNAME,ageing,deb_adj_amt)
			values (@rec_agency_comp_code,@punit_code,@rec_agency_agcd, @rec_agency_dpcd, @fetch_protype,
			null	,isnull(0,0),isnull(0,0)
			,isnull(0,0),isnull(0,0), isnull(0,0)
			,isnull(0,0), isnull(0,0), isnull(0,0),
			isnull(@v_pending_rcpt_amt,0),0,@@spid,@fetch_pubtype,@rec_agency_ageing_type,isnull(@v_deb_anadjust,0));


fetch NEXT FROM cur_agency_1 INTO @rec_agency_comp_code,@rec_agency_agcd,@rec_agency_dpcd,@rec_agency_agency_name,@rec_agency_city_code,@rec_agency_city_name,@rec_agency_credit_days,@rec_agency_branch_name,@rec_agency_ageing_type
end 
close cur_agency_1
deallocate cur_agency_1

--5select * from #cir_temp_ageing

if(@pextra1='CREDIT') 
begin
	select comp_code,unit_code,agcd,dpcd,ag_name PRO_TYPE,PUBNAME--,city_name PUBL_NAME
	,(sum( isnull(pending_amt,0) ) + (isnull(max(deb_adj_amt),0)) - ISNULL(max(abs(rect_pending)),0)  )  pending_amt
	,sum(isnull(cur_amt,0)) cur_amt,sum(isnull(slab_1,0)) slab_1,sum(isnull(slab_2,0)) slab_2
	,sum(isnull(slab_3,0)) slab_3,sum(isnull(slab_4,0)) slab_4,sum(isnull(slab_5,0)) slab_5,sum(isnull(slab_6,0)) slab_6,sum(isnull(rect_pending,0)) rect_pending
	,ageing
	from #cir_temp_ageing group by #cir_temp_ageing.COMP_CODE,#cir_temp_ageing.UNIT_CODE,#cir_temp_ageing.AGCD,#cir_temp_ageing.DPCD
	,#cir_temp_ageing.AG_NAME,PUBNAME,ageing
	order by PUBNAME;
end
else 
begin

	select comp_code,unit_code,agcd,dpcd,ag_name PRO_TYPE,PUBNAME--,city_name PUBL_NAME
	,(sum( isnull(pending_amt,0) ) + (isnull(max(deb_adj_amt),0)) - ISNULL(max(abs(rect_pending)),0)  )  pending_amt
	,sum(isnull(cur_amt,0)) cur_amt,sum(isnull(slab_1,0)) slab_1,sum(isnull(slab_2,0)) slab_2
	,sum(isnull(slab_3,0)) slab_3,sum(isnull(slab_4,0)) slab_4,sum(isnull(slab_5,0)) slab_5,sum(isnull(slab_6,0)) slab_6,sum(isnull(rect_pending,0)) rect_pending
	,ageing
	from #cir_temp_ageing group by #cir_temp_ageing.COMP_CODE,#cir_temp_ageing.UNIT_CODE,#cir_temp_ageing.AGCD,#cir_temp_ageing.DPCD
	,#cir_temp_ageing.AG_NAME,PUBNAME,ageing
	order by PUBNAME;

	select SUM(abs(isnull(amount,0))) as SEC_ONDT from CIR_RCPHDR where COMP_CODE=@pcomp_code
	and (UNIT_CODE=@punit_code or @punit_code is null or @punit_code ='')
	and (AGCD=@pag_main_code or @pag_main_code is null or @pag_main_code ='')
	and (DPCD=@pag_sub_code or @pag_sub_code is null or @pag_sub_code ='')
	and ACHD='SC'
	group by comp_code,unit_code,agcd,dpcd


	select SUM(abs(isnull(bg_amt,0))) as BG_ONDT from CIR_BANK_GUARANTEE where COMP_CODE=@pcomp_code
	and(UNIT_CODE=@punit_code or @punit_code is null or @punit_code ='')
	and(AGCD=@pag_main_code or @pag_main_code is null or @pag_main_code ='')
	and(DPCD=@pag_sub_code or @pag_sub_code is null or @pag_sub_code ='')
	group by comp_code,unit_code,agcd,dpcd
	
	SELECt sum(INST_DUE_AMT) as INST_AMT from  CIR_INST_BILL_DET  
	where COMP_CODE=@pcomp_code
	and(UNIT_CODE=@punit_code or @punit_code is null or @punit_code ='')
	and(AGCD=@pag_main_code or @pag_main_code is null or @pag_main_code ='')
	and(DPCD=@pag_sub_code or @pag_sub_code is null or @pag_sub_code ='')	
	and (CIR_INST_BILL_DET.recptno is null or CIR_INST_BILL_DET.recptno = '' )
	and (CIR_INST_BILL_DET.recptdt is null or CIR_INST_BILL_DET.recptdt = '' )
	group by comp_code,unit_code,agcd,dpcd
	
	drop table #cir_temp_ageing
end
/**21 feb*/





**************************************sap interface report**********************************




ALTER procedure [dbo].[cir_sap_interface_p]
      @pcompcode                            VARCHAR(20),
      @pdateformat                          VARCHAR(20),
      @pextra1                              VARCHAR(20),
	  @pextra2                              VARCHAR(20),
	  @pextra3                              VARCHAR(20) 
As

	select CDP,ACC_NAME,OLD_ACC_CODE from FA_ACC_MAST
	WHERE
 comp_code  = @pcompcode










********************************************************************************************