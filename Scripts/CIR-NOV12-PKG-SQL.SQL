/****9142********/
 ALTER TABLE CIR_EDTN_MAST ADD PRINTING_PRESS_CODE varchar(5)

ALTER FUNCTION  [dbo].[cir_get_locationname]
 (@compcode as varchar(100),@loccode as varchar(100))  returns varchar(200)

AS  

BEGIN 
DECLARE @vloc_name VARCHAR(4000)

SELECT  @vloc_name=PRINTER_NAME 

       +'--'+isnull((Select distinct LOC_NAME from ABC_LOC_MAST where COMP_CODE=X.COMP_CODE AND X.LOC_CODE=LOC_CODE),'')

from ABC_GODOWN_PRINTER_MAST X WHERE COMP_CODE= @compcode and PRINTER_CODE=@loccode
   
RETURN isnull(@vloc_name,'')
END



ALTER procedure [dbo].[get_printer_name_loc]
(    @compcode as varchar(20),
     @userid as varchar(20),
	    
     @pextra1 as varchar(20),
     @pextra2 as varchar(20)) 
as
 begin

    SELECT  DISTINCT X.PRINTER_NAME+'--'+isnull((Select distinct LOC_NAME from ABC_LOC_MAST where COMP_CODE=X.COMP_CODE AND X.LOC_CODE=LOC_CODE),'')
 AS PRINTER_NAME,PRINTER_CODE FROM ABC_GODOWN_PRINTER_MAST X WHERE COMP_CODE= @compcode 



--Agency_Name LIKE '%'+@agency+'%' --ORDER BY Agency_Name


end


/****9142********/

/////////////////////////////////add by deepika 19/11/2012////////////////////////////////

alter table preferrences add  COMMON_EDITION_FOR_UNIT varchar(1)


///////////////////////////////////



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
@P_commedi_forunit as varchar(5) =null
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

 CIR_BARCODE= @P_BAR_CODE,CIR_WIEGHT_CALC_REQ= @P_WEIGHT_CAL,GEN_RCT_TYP = @P_GEN_RCT_NO,PRODUCT_BRAND_REQ=@P_misdata,ALLOWPREM_CARD_DISC_RATE=@P_allowpremium,FINANCE_CADE=@p_financecode,EXECUTIVE_PUBLICATION_VISE=@p_exepub,EXECUTIVECREDITLIMIT=@p_executivecreditlimit,
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
COMMON_EDITION_FOR_UNIT=@P_commedi_forunit
 WHERE comp_code=@compcode




/* ,
',Unsold_Entry_Flag='''+@Unsoldflag+''',Supply_Stop_Percentage='''+@Supplystopper+'''

,ROKEYCHECK='''+@drpRokeychk+''',AGENCYCOMM_SEQ_COM='''+@Agencycomm_seq+''' ,CREDIT_RECIPT='''+@creditreciept+''' where    comp_code='''+@compcode+'''   ' 



--,DISP_CASHBILL='''+@cashindisplay+''',CLA_CASHBILL='''+@cashinclassified+'''
*/

print(@query1)
exec(@query1)




//////////////////////////////next




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


CIR_BARCODE,CIR_WIEGHT_CALC_REQ,GEN_RCT_TYP,PRODUCT_BRAND_REQ,ALLOWPREM_CARD_DISC_RATE,FINANCE_CADE,EXECUTIVE_PUBLICATION_VISE,EXECUTIVECREDITLIMIT,MRV_BASED_ON,
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
	COMMON_EDITION_FOR_UNIT
	
           FROM PREFERRENCES
          WHERE comp_code = @compcode



////////////////////////////////////////////////////////end///////////////////////////////////////////////////



*******************************************************issue no.- 8600*******************************************************


ALTER PROCEDURE [dbo].[cir_rep_datewise_rate_supply]
	@pcompcode           as varchar(20),
	@punitcode           as varchar(20),
	@pdatefrom           as datetime,
	@pdateto             as datetime,
	@ppublcode           as varchar(20),
	@pmedtncode          as varchar(20),
	@pedtncode           as varchar(20),
	@pagtype             as varchar(20),
	@pagclass            as varchar(20),
	@pbill_pay           as varchar(20),--Y for Paid copy,N for Unpaid Copy,Null for All copy
	@puserid             as varchar(20) ,
	@pdateformat         as varchar(20),
	@pextra1             as varchar(200),
	@pextra2             as varchar(200),
	@pextra3             as varchar(200),
	@pextra4             as varchar(200),
	@pextra5             as varchar(200)
AS

set concat_null_yields_null off

	declare @v_query varchar(8000)
     
	declare cur_edtn cursor for
		select distinct isnull(d.sup_rate,0) edtn_rate
		--case isnull(cast(d.sup_rate as varchar(50)),0) when '' then 0 else  isnull(d.sup_rate,0)  end edtn_rate
		from cir_agmast m,cir_dbksup d ,cir_edtn_mast p,cir_supply_type_mast s
		where m.comp_code=@pcompcode and m.comp_code=d.comp_code and d.comp_code=p.comp_code and d.comp_code=s.comp_code and 
			m.unit=d.unit_code and m.unit=p.unit_code and d.unit_code = @punitcode and
			  d.supdate >= @pdatefrom and d.supdate <=@pdateto and
			  m.agcd=d.agcd and m.dpcd=d.dpcd and d.publ=p.publ and (d.publ=@ppublcode or @ppublcode is null or @ppublcode='') and 
			  d.publ=p.publ and 
			  (p.main_edtn=@pmedtncode or @pmedtncode is null or @pmedtncode='' ) and 
			  (d.edtn=@pedtncode or @pedtncode is null or @pedtncode='') and d.edtn=p.edtn and
			  d.sup_type_code=s.sup_ty_code and (s.bill_pay=@pbill_pay or @pbill_pay is null or @pbill_pay='')
			 
		order by edtn_rate

	declare @rec_edtn_edtn_rate	varchar(20)
	 
	declare @vvar       varchar(4000)
	declare @vvar_sum   varchar(4000)
	declare @vvar_sum1  varchar(4000)
	declare @vquery     varchar(8000)

	Begin
		PRINT(@pcompcode)
		PRINT(@pUNITcode)
		PRINT(@pdatefrom)
		PRINT(@pdateto)
		PRINT(@ppublcode)
		open cur_edtn
			fetch NEXT FROM cur_edtn INTO @rec_edtn_edtn_rate
			WHILE (@@FETCH_STATUS = 0)
			Begin
				if @vvar is null 
					Begin
						set @vvar        ='case when d.sup_rate='+''''+@rec_edtn_edtn_rate+''''+' then d.sup_copy else 0 end "'+@rec_edtn_edtn_rate+'"'
						set @vvar_sum    ='sum('+'u."'+@rec_edtn_edtn_rate+'") "'+@rec_edtn_edtn_rate+'"'
					End
				else
					Begin
						set @vvar        =@vvar+','+' case when d.sup_rate='+''''+@rec_edtn_edtn_rate+''''+' then d.sup_copy else 0 end "'+@rec_edtn_edtn_rate+'"';
						set @vvar_sum    =@vvar_sum+','+'sum('+'u."'+@rec_edtn_edtn_rate+'") "'+@rec_edtn_edtn_rate+'"';
					End
			fetch NEXT FROM cur_edtn INTO @rec_edtn_edtn_rate
			End
		close cur_edtn
		deallocate cur_edtn
		/*print('1')
		print(@vvar)
		print(@vvar_sum)
		print('2')*/
		if @vvar is null 
			Begin
				set @v_query='select distinct u.comp_code COMP_CODE,u.unit_code UNIT_CODE,u.supdate SUPDATE, sum(supply_copy) TOTAL
					from(select d.comp_code,d.unit_code,d.agcd agcd,d.dpcd dpcd,d.supdate supdate,
					substring(m.ag_name,1,25) agency_name,d.sup_copy supply_copy from cir_dbksup d,cir_agmast m,cir_edtn_mast p,cir_supply_type_mast s
					where d.comp_code = m.comp_code and d.comp_code=p.comp_code and d.comp_code=s.comp_code and d.unit_code = m.unit and d.comp_code = '+''''+@pcompcode+''''+' and
					m.unit=p.unit_code and d.unit_code = '+''''+@punitcode+''''+' and d.publ=p.publ and 
					(d.publ = '+''''+@ppublcode+''''+' or '+''''+@ppublcode+''''+' is null or '+''''+@ppublcode+''''+'='''') and
					d.agcd = m.agcd and d.dpcd = m.dpcd and  
					d.supdate >= '+''''+convert(varchar(20),@pdatefrom,101)+''''+' and d.supdate <='+''''+convert(varchar(20),@pdateto,101)+''''+' and
					(p.main_edtn='+''''+@pmedtncode+''''+' or '+''''+@pmedtncode+''''+' is null or '+''''+@pmedtncode+''''+'='''') and 
					(d.edtn='+''''+@pedtncode+''''+' or '+''''+@pedtncode+''''+' is null or '+''''+@pedtncode+''''+'='''') and 
					d.edtn=p.edtn and d.sup_type_code=s.sup_ty_code and (s.bill_pay='+''''+@pbill_pay+''''+' or '+''''+@pbill_pay+''''+' is null or '+''''+@pbill_pay+''''+'=''''))u
					group by u.comp_code,u.unit_code,u.supdate
					order by u.comp_code,u.unit_code,u.supdate'
			End
		else
			Begin
				set @v_query='select distinct u.comp_code COMP_CODE,u.unit_code UNIT_CODE,u.supdate SUPDATE, 
				'+@vvar_sum+', sum(u.supply_copy) TOTAL from(select d.comp_code,d.unit_code,d.supdate supdate,d.agcd agcd,d.dpcd dpcd,
				substring(m.ag_name,1,25) agency_name,d.sup_copy supply_copy,'+@vvar+' from cir_dbksup d,cir_agmast m,cir_edtn_mast p,cir_supply_type_mast s
				where d.comp_code = m.comp_code and d.comp_code=p.comp_code and d.comp_code=s.comp_code and d.unit_code = m.unit and d.comp_code = '+''''+@pcompcode+''''+' and
				d.unit_code = '+''''+@punitcode+''''+' and d.publ=p.publ and d.publ = isnull('+''''+@ppublcode+''''+',d.publ) and
				m.unit=p.unit_code and d.agcd = m.agcd and d.dpcd = m.dpcd and  
				d.supdate >= '+''''+convert(varchar(20),@pdatefrom,101)+''''+' and d.supdate <= '+''''+convert(varchar(20),@pdateto,101)+''''+' and 
				(p.main_edtn='+''''+@pmedtncode+''''+' or '+''''+@pmedtncode+''''+' is null or '+''''+@pmedtncode+''''+'='''') and 
				(d.edtn='+''''+@pedtncode+''''+' or '+''''+@pedtncode+''''+' is null or '+''''+@pedtncode+''''+'='''') and 
				d.edtn=p.edtn and d.sup_type_code=s.sup_ty_code and (s.bill_pay='+''''+@pbill_pay+''''+' or '+''''+@pbill_pay+''''+' is null or '+''''+@pbill_pay+''''+'=''''))u
				group by u.comp_code,u.unit_code,u.supdate
				order by u.comp_code,u.unit_code,u.supdate'
		end
		print('query')
		print (@v_query)
		exec (@v_query)
End












ALTER PROCEDURE [dbo].[cir_rep_comm_edtnrate_supply]
    @pcompcode			as varchar(20),
    @punitcode          as varchar(20),
    @pdatefrom          as varchar(20),
    @pdateto            as varchar(20),
    @ppublcode          as varchar(20),
    @pmedtncode         as varchar(20),
    @pedtncode          as varchar(20),
    @pagtype            as varchar(20),
    @pagclass           as varchar(20),
    @pbill_pay          as varchar(20),--Y for Paid copy,N for Unpaid Copy,Null for All copy
    @puserid            as varchar(20),
    @pdateformat        as varchar(20),
    @pextra1            as varchar(20),
    @pextra2            as varchar(20),
    @pextra3            as varchar(20),
    @pextra4            as varchar(20),
    @pextra5            as varchar(20)
  As
  
  SET CONCAT_NULL_YIELDS_NULL OFF
       declare @v_frdt    datetime;
       declare @v_todt    datetime;
       declare @v_query1  varchar(max);
       declare @v_query2  varchar(max);
      
      declare cur_edtn cursor for 
        select distinct x.comm_rate,substring(x.comm_rate,1,1) comm_type,substring(x.comm_rate,2,len(x.comm_rate)) comm_act_rate,x.edtn_rate edtn_rate
        from
        (select distinct d.comp_code,d.unit_code,d.publ,d.edtn,d.sup_rate edtn_rate,d.comm_code, d.comm_fix_auto_spl,
        dbo.cir_get_commission(d.comp_code ,d.unit_code ,d.publ,d.edtn,d.comm_fix_auto_spl,d.comm_code,convert(varchar(20),d.supdate,101),@pdateformat,0,null,null) comm_rate
        from cir_agmast m,cir_dbksup d ,cir_edtn_mast p,cir_supply_type_mast s
        where m.comp_code=@pcompcode and m.comp_code=d.comp_code and d.comp_code=p.comp_code and d.comp_code=s.comp_code and 
                m.unit=d.unit_code and m.unit=p.unit_code and d.unit_code = @punitcode and
              d.supdate >= @pdatefrom and d.supdate <=@pdateto and
              m.agcd=d.agcd and m.dpcd=d.dpcd and d.publ=p.publ and (d.publ=isnull(@ppublcode,d.publ) or @ppublcode='') and d.publ=p.publ and 
              (p.main_edtn=isnull(@pmedtncode,p.main_edtn) or @pmedtncode='') and (d.edtn=isnull(@pedtncode,d.edtn) or @pedtncode='') and d.edtn=p.edtn and
              (m.ag_type=@pagtype or @pagtype is null or @pagtype='') and (m.ag_class=@pagclass or @pagclass is null or @pagclass='') and
              d.sup_type_code=s.sup_ty_code and (s.bill_pay=@pbill_pay or @pbill_pay is null or @pbill_pay=''))x
        order by comm_act_rate desc ,edtn_rate asc;

     declare @rec_edtn_comm_rate			varchar(20)
     declare @rec_edtn_comm_type			varchar(10)
     declare @rec_edtn_comm_act_rate		varchar(20)--numeric(12,4)
     declare @rec_edtn_edtn_rate			varchar(20)--numeric(12,4)
     declare @vvar       varchar(max);
     declare @tot_vvar   varchar(max);
     declare @vtot_publ  varchar(max);
     declare @v_cnt      int
     set @v_cnt=0
Begin
       set @v_frdt   =@pdatefrom;
       set @v_todt   =@pdateto;

    open cur_edtn;
        fetch NEXT FROM cur_edtn INTO @rec_edtn_comm_rate,@rec_edtn_comm_type,@rec_edtn_comm_act_rate,@rec_edtn_edtn_rate;
        print(@rec_edtn_comm_rate)
        print(@rec_edtn_comm_type)
        print(@rec_edtn_comm_act_rate)
        print(@rec_edtn_edtn_rate)
        WHILE (@@FETCH_STATUS = 0) BEGIN
          set @v_cnt =isnull(@v_cnt,0)+1;
         
          if @vvar is null Begin
              set @vvar      ='case when x.comm_rate+cast(x.edtn_rate as varchar)='+''''+cast(@rec_edtn_comm_act_rate as varchar(20)) +cast(@rec_edtn_edtn_rate as varchar(20))+''''+' then sum(x.sup_copy) else 0 end "'+cast(@rec_edtn_comm_act_rate  as varchar(20))+'#'+cast(@rec_edtn_edtn_rate  as varchar(20))+'"';
              set @tot_vvar  =@tot_vvar+',sum("'+cast(@rec_edtn_comm_act_rate as varchar(20))+'#'+cast(@rec_edtn_edtn_rate as varchar(20))+'") "'+cast(@rec_edtn_comm_rate as varchar(20))+'#'+cast(@rec_edtn_edtn_rate as varchar(20))+'"';
          end
          else begin
              set @vvar      =@vvar+',case when x.comm_rate+cast(x.edtn_rate as varchar)='+''''+cast(@rec_edtn_comm_act_rate as varchar(20)) +cast(@rec_edtn_edtn_rate as varchar(20))+''''+' then sum(x.sup_copy) else 0 end "'+cast(@rec_edtn_comm_act_rate as varchar(20))+'#'+cast(@rec_edtn_edtn_rate as varchar(20))+'"';
              set @tot_vvar  =@tot_vvar+',sum("'+cast(@rec_edtn_comm_act_rate as varchar(20))+'#'+cast(@rec_edtn_edtn_rate as varchar(20))+'") "'+cast(@rec_edtn_comm_act_rate as varchar(20))+'#'+cast(@rec_edtn_edtn_rate as varchar(20))+'"';
          end
		fetch NEXT FROM cur_edtn INTO @rec_edtn_comm_rate,@rec_edtn_comm_type,@rec_edtn_comm_act_rate,@rec_edtn_edtn_rate;
		end
    close cur_edtn;
deallocate cur_edtn
print('@vvar')
print(@vvar)
print('@tot_vvar')
print(@tot_vvar)
    if @vvar is not null or @vvar !='' 
    Begin
            set @v_query1='select distinct u.comp_code,u.unit_code,u.publ,u.main_edtn,dbo.cir_get_edtn_name(u.comp_code,u.main_edtn) main_edtn_name,
            u.edtn,u.edtn_name '+@tot_vvar+',sum(u.sup_copy) tot_copy
                    from(select distinct x.comp_code,x.unit_code,x.publ,x.main_edtn,x.edtn,x.edtn_name,x.comm_rate,x.edtn_rate edtn_rate,
            sum(x.sup_copy) sup_copy ,'+@vvar+'
                    from(select distinct d.comp_code,d.unit_code,d.publ,p.main_edtn,d.edtn,p.edtn_name,d.sup_rate edtn_rate,d.comm_code, d.comm_fix_auto_spl,
        dbo.cir_get_commission(d.comp_code ,d.unit_code ,d.publ,d.edtn,d.comm_fix_auto_spl,d.comm_code,convert(varchar(20),d.supdate,101),'''+@pdateformat+''',0,null,null) comm_rate,d.sup_copy
        from cir_agmast m,cir_dbksup d ,cir_edtn_mast p,cir_supply_type_mast s '
        
        set @v_query2 ='where m.comp_code='''+@pcompcode+''' and m.comp_code=d.comp_code and d.comp_code=p.comp_code and d.comp_code=s.comp_code and 
                m.unit=d.unit_code and m.unit=p.unit_code and d.unit_code = '''+@punitcode+''' and
              convert(varchar(10),d.supdate ,101) >='''+ @pdatefrom+''' and convert(varchar(10),d.supdate ,101) <='''+@pdateto+''' and
              m.agcd=d.agcd and m.dpcd=d.dpcd and d.publ=p.publ and (d.publ=isnull('''+@ppublcode+''',d.publ) or '''+@ppublcode+'''='''') and d.publ=p.publ and 
              (p.main_edtn=isnull('''+@pmedtncode+''',p.main_edtn) or '''+@pmedtncode+'''='''') and (d.edtn=isnull('''+@pedtncode+''',d.edtn) or '''+@pedtncode+'''='''') and d.edtn=p.edtn and
              (m.ag_type='''+@pagtype+''' or '''+@pagtype+''' is null or '''+@pagtype+'''='''') and (m.ag_class='''+@pagclass+''' or '''+@pagclass+''' is null or '''+@pagclass+'''='''') and
              d.sup_type_code=s.sup_ty_code and (s.bill_pay='''+@pbill_pay+''' or '''+@pbill_pay+''' is null or '''+@pbill_pay+'''=''''))x
              group by x.comp_code,x.unit_code,x.publ,x.main_edtn,x.edtn,x.edtn_name,x.comm_rate,x.edtn_rate)u
              group by u.comp_code,u.unit_code,u.publ,u.main_edtn,u.edtn,u.edtn_name
        order by publ,main_edtn_name,edtn_name';
print('@v_query1+@v_query2')
		print(@v_query1+@v_query2)
		exec(@v_query1+@v_query2)
                   
                   set @v_query1='select distinct u.comp_code,u.unit_code,u.publ,u.main_edtn,dbo.cir_get_edtn_name(u.comp_code,u.main_edtn) main_edtn_name
                     '+@tot_vvar+',sum(u.sup_copy) tot_copy '
                    set @v_query2 =' from(select distinct x.comp_code,x.unit_code,x.publ,x.main_edtn,x.edtn,x.edtn_name,x.comm_rate,x.edtn_rate edtn_rate,
            sum(x.sup_copy) sup_copy ,'+@vvar+'
                    from(select distinct d.comp_code,d.unit_code,d.publ,p.main_edtn,d.edtn,p.edtn_name,d.sup_rate edtn_rate,d.comm_code, d.comm_fix_auto_spl,
        dbo.cir_get_commission(d.comp_code ,d.unit_code ,d.publ,d.edtn,d.comm_fix_auto_spl,d.comm_code,convert(varchar(20),d.supdate,101),'''+@pdateformat+''',0,null,null) comm_rate,d.sup_copy
        from cir_agmast m,cir_dbksup d ,cir_edtn_mast p,cir_supply_type_mast s        
        where m.comp_code='''+@pcompcode+''' and m.comp_code=d.comp_code and d.comp_code=p.comp_code and d.comp_code=s.comp_code and 
                m.unit=d.unit_code and m.unit=p.unit_code and d.unit_code = '''+@punitcode+''' and
              convert(varchar(10),d.supdate ,101) >='''+ @pdatefrom+''' and convert(varchar(10),d.supdate ,101) <='''+@pdateto+''' and
              m.agcd=d.agcd and m.dpcd=d.dpcd and d.publ=p.publ and (d.publ=isnull('''+@ppublcode+''',d.publ) or '''+@ppublcode+'''='''') and d.publ=p.publ and 
              (p.main_edtn=isnull('''+@pmedtncode+''',p.main_edtn) or '''+@pmedtncode+''' ='''') and (d.edtn=isnull('''+@pedtncode+''',d.edtn) or '''+@pedtncode+'''='''') and d.edtn=p.edtn and
              (m.ag_type='''+@pagtype+''' or '''+@pagtype+''' is null or '''+@pagtype+'''='''') and (m.ag_class='''+@pagclass+''' or '''+@pagclass+''' is null or '''+@pagclass+'''='''') and
              d.sup_type_code=s.sup_ty_code and (s.bill_pay='''+@pbill_pay+''' or '''+@pbill_pay+''' is null or '''+@pbill_pay+'''=''''))x
              group by x.comp_code,x.unit_code,x.publ,x.main_edtn,x.edtn,x.edtn_name,x.comm_rate,x.edtn_rate)u
              group by u.comp_code,u.unit_code,u.publ,u.main_edtn
                order by publ,main_edtn_name';
                print('@v_query1+@v_query2')
                print(@v_query1+@v_query2);
                exec(@v_query1+@v_query2);
		End
        Else 
        begin
            set @v_query1='select distinct u.comp_code,u.unit_code,u.publ,u.main_edtn,dbo.cir_get_edtn_name(u.comp_code,u.main_edtn) main_edtn_name,
            u.edtn,u.edtn_name ,sum(u.sup_copy) tot_copy
                    from(select distinct x.comp_code,x.unit_code,x.publ,x.main_edtn,x.edtn,x.edtn_name,x.comm_rate,x.edtn_rate edtn_rate,
            sum(x.sup_copy) sup_copy 
                    from(select distinct d.comp_code,d.unit_code,d.publ,p.main_edtn,d.edtn,p.edtn_name,d.sup_rate edtn_rate,d.comm_code, d.comm_fix_auto_spl,
        dbo.cir_get_commission(d.comp_code ,d.unit_code ,d.publ,d.edtn,d.comm_fix_auto_spl,d.comm_code,convert(varchar(20),d.supdate,101),'''+@pdateformat+''',0,null,null) comm_rate,d.sup_copy
        from cir_agmast m,cir_dbksup d ,cir_edtn_mast p,cir_supply_type_mast s '
        
        set @v_query2 ='where m.comp_code='''+@pcompcode+''' and m.comp_code=d.comp_code and d.comp_code=p.comp_code and d.comp_code=s.comp_code and 
                m.unit=d.unit_code and m.unit=p.unit_code and d.unit_code = '''+@punitcode+''' and
              convert(varchar(10),d.supdate ,101) >='''+ @pdatefrom+''' and convert(varchar(10),d.supdate ,101) <='''+@pdateto+''' and
              m.agcd=d.agcd and m.dpcd=d.dpcd and d.publ=p.publ and (d.publ=isnull('''+@ppublcode+''',d.publ) or '''+@ppublcode+'''='''') and d.publ=p.publ and 
              (p.main_edtn=isnull('''+@pmedtncode+''',p.main_edtn) or '''+@pmedtncode+'''='''') and (d.edtn=isnull('''+@pedtncode+''',d.edtn) or '''+@pedtncode+'''='''') and d.edtn=p.edtn and
              (m.ag_type='''+@pagtype+''' or '''+@pagtype+''' is null  or '''+@pagtype+'''='''') and (m.ag_class='''+@pagclass+''' or '''+@pagclass+''' is null or '''+@pagclass+'''='''') and
              d.sup_type_code=s.sup_ty_code and (s.bill_pay='''+@pbill_pay+''' or '''+@pbill_pay+''' is null or '''+@pbill_pay+'''=''''))x
              group by x.comp_code,x.unit_code,x.publ,x.main_edtn,x.edtn,x.edtn_name,x.comm_rate,x.edtn_rate)u
              group by u.comp_code,u.unit_code,u.publ,u.main_edtn,u.edtn,u.edtn_name
        order by publ,main_edtn_name,edtn_name';
print('@v_query1+@v_query2')
                print(@v_query1+@v_query2);
                exec(@v_query1+@v_query2);

                   set @v_query1='select distinct u.comp_code,u.unit_code,u.publ,u.main_edtn,dbo.cir_get_edtn_name(u.comp_code,u.main_edtn) main_edtn_name,
                     sum(u.sup_copy) tot_copy
                    from(select distinct x.comp_code,x.unit_code,x.publ,x.main_edtn,x.edtn,x.edtn_name,x.comm_rate,x.edtn_rate edtn_rate,
            sum(x.sup_copy) sup_copy  '
                    
                   set @v_query2 =' from(select distinct d.comp_code,d.unit_code,d.publ,p.main_edtn,d.edtn,p.edtn_name,d.sup_rate edtn_rate,d.comm_code, d.comm_fix_auto_spl,
        dbo.cir_get_commission(d.comp_code ,d.unit_code ,d.publ,d.edtn,d.comm_fix_auto_spl,d.comm_code,convert(varchar(20),d.supdate,101),'''+@pdateformat+''',0,null,null) comm_rate,d.sup_copy
        from cir_agmast m,cir_dbksup d ,cir_edtn_mast p,cir_supply_type_mast s         
        where m.comp_code='''+@pcompcode+''' and m.comp_code=d.comp_code and d.comp_code=p.comp_code and d.comp_code=s.comp_code and 
                m.unit=d.unit_code and m.unit=p.unit_code and d.unit_code = '''+@punitcode+''' and
              convert(varchar(10),d.supdate ,101) >='''+ @pdatefrom+''' and convert(varchar(10),d.supdate ,101) <='''+@pdateto+''' and
              m.agcd=d.agcd and m.dpcd=d.dpcd and d.publ=p.publ and (d.publ=isnull('''+@ppublcode+''',d.publ) or '''+@ppublcode+'''='''') and d.publ=p.publ and 
              (p.main_edtn=isnull('''+@pmedtncode+''',p.main_edtn) or '''+@pmedtncode+'''='''') and (d.edtn=isnull('''+@pedtncode+''',d.edtn) or '''+@pmedtncode+'''='''') and d.edtn=p.edtn and
              (m.ag_type='''+@pagtype+''' or '''+@pagtype+''' is null or '''+@pagtype+'''='''') and (m.ag_class='''+@pagclass+''' or '''+@pagclass+''' is null or '''+@ppublcode+'''='''') and
              d.sup_type_code=s.sup_ty_code and (s.bill_pay='''+@pbill_pay+''' or '''+@pbill_pay+''' is null or '''+@pbill_pay+'''=''''))x
              group by x.comp_code,x.unit_code,x.publ,x.main_edtn,x.edtn,x.edtn_name,x.comm_rate,x.edtn_rate)u
              group by u.comp_code,u.unit_code,u.publ,u.main_edtn
                order by publ,main_edtn_name';
                print('@v_query1+@v_query2')
                print(@v_query1+@v_query2);
                exec(@v_query1+@v_query2)

        End
SET CONCAT_NULL_YIELDS_NULL on
End


*******************************************************issue no.- 8600 end***********************************************



***********************************add by Deepika 26-nov-2012 sent by Amit sir********************


ALTER PROCEDURE [dbo].[Cir_Route_Taxi_Bind_p]
	@pcompcode                                VARCHAR(20) ,
	@punitcode                                VARCHAR(20) ,
	@proutecode                               VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS 

		SELECT
				 a.comp_code COMP_CODE,
				 a.unit_code UNIT_CODE,
				 a.TPT_CODE TRANS_CODE,
                 b.transporter_name TRANSPORTER_NAME,
                 a.vehicle_no VEHICLE_NO,
                 a.vehicle_name VEHICLE_NAME,
                 a.VEHICLE_MODEL VEHICLE_MODEL_NO,
                 a.VEHICLE_OWNER VEHICLE_OWNER_NAME,
                 a.START_DATE_FROM VEHICLE_START_DATE
		FROM  cir_taxi_mast a,
			 cir_transporter_mast b 
		WHERE	 a.comp_code  = b.comp_code
		 AND	a.comp_code  = @pcompcode
		 AND	a.unit_code  = @punitcode
		 AND	a.TPT_CODE  = b.transporter_code
		 AND	(a.RT_CODE  = @proutecode
		 OR	@proutecode  is null)
		ORDER BY vehicle_start_date,
			 b.transporter_name,
			 a.vehicle_no 


////////////////////////////////////////////////


ALTER PROCEDURE [dbo].[Cir_Route_Taxi_Bind_p1]
	@pcompcode                                VARCHAR(20) ,
	@punitcode                                VARCHAR(20) ,
	@proutecode                               VARCHAR(20) ,
	@psubrtcode                               VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS 
	
		SELECT
				 a.comp_code comp_code,
				 a.unit_code unit_code,
				 a.TPT_CODE trans_code,
				 b.TRANSPORTER_NAME TRANSPORTER_NAME,
				 a.VEHICLE_NO VEHICLE_NO,
				 a.VEHICLE_NAME VEHICLE_NAME,
				 a.VEHICLE_MODEL VEHICLE_MODEL,
				 a.VEHICLE_OWNER VEHICLE_OWNER_NAME,
				 a.START_DATE_FROM VEHICLE_START_DATE
		FROM  cir_taxi_mast a,
			 cir_transporter_mast b 
		WHERE	 a.comp_code  = b.comp_code
		 AND	a.comp_code  = @pcompcode
		 AND	a.unit_code  = @punitcode
		 AND	a.TPT_CODE  = b.transporter_code
		 AND	(a.RT_CODE  = @proutecode
		 OR @proutecode  is null or @proutecode='' )
		 AND	(a.SUBRT_CODE  = @psubrtcode
		 OR	@psubrtcode  is null or @proutecode='')
		ORDER BY VEHICLE_START_DATE,
			 b.transporter_name,
			 a.vehicle_no 
		

////////////////////////////////////////////////////



ALTER PROCEDURE  [dbo].[Cir_Route_Droppoint_Bind1]

  	@pcompcode as varchar(200),
   	@punitcode as varchar(200),
    @proutecode as varchar(200),
    @psubrtcode as varchar(200),
    @pdateformat as	varchar(200),
    @pextra1 as	varchar(200),
    @pextra2 as varchar(200)

 AS
   
   select distinct a.station_code DROP_POINT_CODE,c.DROP_POINT_NAME DROP_POINT_NAME
  	         from cir_agmast a,cir_supply b,cir_drop_point_mast c
		        where a.comp_code=b.comp_code
		       and 
                        a.comp_code=c.comp_code and 
                        a.comp_code=@pcompcode and 
                        a.unit=b.unit and
					    a.unit=c.unit_code and 
                        a.unit=@punitcode and 
                        a.agcd=b.agcd and 
                        a.dpcd=b.dpcd and
					    a.station_code=c.drop_point and 
                        b.route_code=@proutecode and 
                        b.subroute_code=@psubrtcode 
                        and
					   ISNULL(a.suspend,'N')='N' and
                        ISNULL(a.freeze_flag,'N')='N' and
                       ISNULL(c.freeze_flag,'N')='N'
				  order by c.drop_point_name

//////////////////////////////////////////////////


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
	@pextra1            VARCHAR(400) ,--from date and to date is supdate?(Y/N)
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
	DECLARE @agency_rec_agcd		varchar(20)
	DECLARE @agency_rec_dpcd		varchar(20)
	DECLARE @agency_rec_route_code	varchar(20)
	
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
	
	declare @v_bill_exist	numeric(10)
	declare @v_vat_allow    varchar(1);
	declare @v_tax_calc_type    varchar(1);
	declare @v_tax_amt      numeric(15,2);
	declare @v_tax_prate    numeric(15,3);   
	declare @v_tax_frate    numeric(15,3);

	SET @v_frdt		=	@pfrdt
	SET @v_todt		=	@ptodt	
	 SET @v_billdt	=	@v_todt
	 
	  if( @pextra1='Y')begin
	  SET @pbilldt	=	@pbilldt
	  end
	  else begin
	  SET @pbilldt	=	@v_billdt
	  end
       
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
    
    select @vbill_publwise=cir_bill_publwise,@v_vat_allow=cir_vat_allow from preferrences where "comp_code"=@pcomp_code

    select @v_bill_exist=count(*) from cir_bill_det d,cir_publ_mast p
        where d.comp_code = p.comp_code and d.comp_code=@pcomp_code and d.unit_code=@punit_code and        
        (case @pextra1
        when 'Y' then (d.billdt-1) else d.billdt end ) between @v_frdt and @v_todt 
        and d.publ=p.publ and(p.PUBL=@ppubl   or @ppubl ='' or @ppubl is null) 
        and (p.pro_type = @ppubl_freq or @ppubl_freq is null)
		and (d.bill_flag = @pbill_freq or @pbill_freq is null);
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
			m.ag_name ag_name,m.print_seq print_seqno,@vrec_publ agbill_publ,
			a.acc_agcd acc_agcd,a.acc_dpcd acc_dpcd,a.route_code route_code
			from
			(select distinct a.comp_code,a.unit,a.bill_agcd,a.bill_dpcd,
			isnull(a.account_agcd,a.bill_agcd) acc_agcd,isnull(a.account_dpcd,a.bill_dpcd) acc_dpcd,
			max(s.route_code) route_code
			from cir_agmast a,cir_supply s
			where  a.comp_code = @pcomp_code and a.comp_code = s.comp_code and a.unit  = s.unit and a.unit  = @punit_code and
			a.agcd=s.agcd and a.dpcd=s.dpcd and a.agcd+a.dpcd in (select distinct CAST(x.agcddpcd AS VARCHAR) from
			(select distinct CAST(d.agcd AS VARCHAR) + CAST(d.dpcd AS VARCHAR)as agcddpcd from cir_dbksup d,cir_publ_mast p
			where d.comp_code = @pcomp_code and d.comp_code = p.comp_code and d.unit_code = @punit_code and
			d.publ = isnull(@vrec_publ,d.publ) and d.publ = p.publ and
			d.supdate between @v_frdt  and  @v_todt and isnull(d.sup_copy,0)>0 
			and ((case final_supply_flag when '' then 'N' else isnull(final_supply_flag,'N')end)='Y')
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
			group by a.comp_code,a.unit,a.bill_agcd,a.bill_dpcd,
                isnull(a.account_agcd,a.bill_agcd),isnull(a.account_dpcd,a.bill_dpcd)) a,cir_agmast m
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
		fetch NEXT FROM agency_cur INTO @vcomp_code1 , @vunit1 ,@vbill_agcd1, @vbill_dpcd1 , @vbranch_code1, @vcity_name1, @vag_name1,@vprint_seqno1,@vagbill_publ1,@agency_rec_agcd,@agency_rec_dpcd,@agency_rec_route_code
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
			and ((case final_supply_flag when '' then 'N' else isnull(final_supply_flag,'N')end)='Y')
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
										VALUES ( @vcomp_code11 ,@vunit_code11 , @pbilldt , @vbill_agcd1,@vbill_dpcd1 ,@vpubl11 , @vedtn11,@sup_copy11, 
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

				SET @vbill_no  = DBO.cir_generate_billno( @vcomp_code1, @vunit1, @pbilldt, @pdateformat, '', '')

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
					
					declare @rec_tax_tax_rate		numeric(15,3)
					declare @rec_tax_tax_calc_type	varchar(1)
					
					

                if @v_vat_allow='Y' begin
                
                declare cur_tax cursor for
						select tax_rate,tax_calc_type from cir_tax_mast 
							where comp_code=@pcomp_code and tax_type_id=1 and tax_status='Y' and 
								valid_from=(select max(valid_from) from cir_tax_mast
								where comp_code=@pcomp_code and tax_type_id=1 and tax_status='Y' and 
								valid_from<=@ptodt);
								
								
                    open cur_tax
                    fetch NEXT FROM cur_tax INTO @rec_tax_tax_rate,@rec_tax_tax_calc_type
						WHILE (@@FETCH_STATUS = 0) begin
                        if @rec_tax_tax_calc_type='P' begin
                            set @v_tax_amt	=isnull(@v_tax_amt,0)+round((isnull(@daily_net_amount,0)*isnull(@rec_tax_tax_rate,0))/100,2);
                            set @v_tax_prate=isnull(@v_tax_prate,0)+isnull(@rec_tax_tax_rate,0);
                            set @v_tax_calc_type=@rec_tax_tax_calc_type
                        end
                        else begin
                            set @v_tax_amt=isnull(@v_tax_amt,0)+round(isnull(@daily_net_amount,0)+isnull(@rec_tax_tax_rate,0),2);
                            set @v_tax_frate=isnull(@v_tax_frate,0)+isnull(@rec_tax_tax_rate,0);
                              set @v_tax_calc_type=@rec_tax_tax_calc_type
                        end
						fetch NEXT FROM cur_tax INTO @rec_tax_tax_rate,@rec_tax_tax_calc_type
                    end
                    close cur_tax
deallocate  cur_tax
                end
                else begin
                    set @v_tax_amt   =0;
                    set @v_tax_prate =0;
                    set @v_tax_frate =0;
                end

					INSERT INTO  cir_bill(comp_code , unit_code ,billno , 	billdt , agcd , dpcd , publ , bill_copy , gross_amount , 
					sur_amount , comm_amount, bill_amount , bill_frdt ,bill_todt , bill_flag , bill_remark , userid , creation_date , bill_sec_amt , branch_code,sec_per_rate,
					route_code,tax_rate,tax_amt,accagcd,accdpcd,tax_calc_type)
					VALUES (@vcomp_code1 , @vunit1 , @vbill_no , @pbilldt , @vbill_agcd1 , @vbill_dpcd1 ,@vpubl11 , isnull(@tot_copy, 0) , 
					isnull(@daily_gross_amount, 0)+isnull(@v_tax_amt, 0) , isnull(@tot_surcharge_amt, 0) , isnull(@vcomm_amt, 0) , @daily_net_amount , 
					@v_frdt , @v_todt , @pbill_freq , CAST(CONVERT(VARCHAR(23), @pbilldt) AS VARCHAR) + ' Billing' , @puserid , 
					GETDATE() , isnull(@v_bill_sec_amt, 0) , @v_bran_code,@v_agcd_sec_per,
					@agency_rec_route_code,isnull(@v_tax_prate,isnull(@v_tax_frate,0)),@v_tax_amt,@agency_rec_agcd,@agency_rec_dpcd,@v_tax_calc_type) 
					

					INSERT INTO  cir_outmast( comp_code , unit_code , agcd , dpcd , doctyp , billno , billdt , publ , amount , 
					remark , voucherno , usrid , creation_date , bill_sec_amt , branch_code )  
					VALUES ( @vcomp_code1 , @vunit1, @vbill_agcd1 , @vbill_dpcd1 , 'BIL' , @vbill_no , @pbilldt , @vpubl11 , 
					isnull(@daily_net_amount, 0)+isnull(@v_tax_amt, 0) , CAST(CONVERT(VARCHAR(23), @pbilldt) AS VARCHAR) + ' Billing' , @vbill_no , @puserid , 
					GETDATE() , isnull(@v_bill_sec_amt, 0) , @v_bran_code )
					
					INSERT INTO  cir_bill_det   ( comp_code , unit_code , billno , billdt ,agcd , dpcd ,coag , 	codp , publ , edtn , 
					copy_rate , comm_flag , comm_rate , sur_rate , fromdt , todt , bill_copy , gross_amount , comm_amt , sur_amt , 
					bill_amount , bill_flag , branch_code,comm_type,accagcd,accdpcd )  
					SELECT comp_code, unit_code, @vbill_no billno, billdt, agcd, dpcd, agcd, dpcd, publ, edtn, copy_rate, comm_flag,
					comm_rate, sur_rate, MIN(fromdt) fromdt, MAX(todt) todt, SUM(bill_copy) bill_copy,
					SUM(CONVERT(FLOAT, gross_amount)) gross_amount,SUM(CONVERT(FLOAT, comm_amt)) comm_amt,SUM(CONVERT(FLOAT, sur_amt)) sur_amt,
					SUM(CONVERT(FLOAT, bill_amount)) bill_amount, @pbill_freq, @v_bran_code,comm_type,@agency_rec_agcd,@agency_rec_dpcd
					FROM  #cir_bill_det_temp 
					GROUP BY comp_code, unit_code, billdt, agcd, dpcd, publ, edtn, copy_rate, comm_flag, comm_rate,  sur_rate ,comm_type
					
					delete FROM  #cir_bill_det_temp;
					
					IF isnull(@v_bill_sec_amt, 0)> 0 BEGIN 
                                 
						SET @v_remark  = 'Being amount auto debited against security deposit against bill number' + @vbill_no + ' dated' + CONVERT(VARCHAR(23), @pbilldt)
									
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
                         values( @vcomp_code1 , @vunit1  , @vbill_agcd1 , @vbill_dpcd1 , 'DN' , @v_reptno , @pbilldt , 
							isnull(@v_bill_sec_amt, 0) , 'SEC DEBIT',@v_remark,
                         'NM',@v_reptno,@pbilldt,@puserid,GETDATE(),@v_bran_code);
							
							
						insert into cir_rcpdet(comp_code,unit_code,agcd,dpcd,doctyp,
							recptno,recptdt,payfor,achd,amount,
							reason,remark,voucherno,voucherdt,usrid,
							creation_date,branch_code)
						values(@vcomp_code1, @vunit1,@vbill_agcd1 , @vbill_dpcd1 ,'DN',
							@v_reptno,@pbilldt,@vunit1,'NM',isnull(@v_bill_sec_amt, 0),
							'SEC DEBIT',@v_remark,@v_reptno,@pbilldt,@puserid,
							GETDATE(),@v_bran_code);    
							
							PRINT('25')

							INSERT INTO  cir_outmast ( comp_code , unit_code , agcd , dpcd , doctyp , recptno , recptdt , achd , amount , 
							reason , remark , voucherno , voucherdt , usrid , creation_date , branch_code )  
							VALUES ( @vcomp_code1 ,  @vunit1 , @vbill_agcd1, @vbill_dpcd1 , 'DN' , @v_reptno , @pbilldt , 'NM' , 
							isnull(@v_bill_sec_amt, 0) , 'SEC DEBIT' , @v_remark , @v_reptno , @pbilldt , @puserid , GETDATE() , @v_bran_code )  
								
							SET @v_remark  = 'Being amount auto credited against security deposit against bill number' + @vbill_no + ' dated' + CONVERT(VARCHAR(23), @pbilldt)+ ' and debit note number' + @v_reptno 
								
							SELECT @v_rec_no  =  max(convert(int,SUBSTRING(RECPTNO,(len(RECPTNO) -7),len(RECPTNO)))) + 1  FROM  cir_rcphdr 	WHERE	 comp_code  = @vcomp_code1 AND	doctype  = 'CN'
						
							IF @v_rec_no is null or @v_rec_no = '0' BEGIN 
								SET @v_reptno  =   @v_bran_code + '-' + REPLACE(CONVERT(VARCHAR(5), GETDATE(), 2), '.', '')+ '0001'   --'DN' + '0001' 
							END
							ELSE BEGIN 
								SET @v_reptno  =   @v_bran_code + '-' + dbo.fnPadLeft('0',8,@v_rec_no)   -- 'DN ' + CASE WHEN LEN(@v_rec_no) >= 4 THEN SUBSTRING(CONVERT(VARCHAR(4000), @v_rec_no),1,4) ELSE SUBSTRING(REPLICATE('0',4),1,4-LEN(@v_rec_no)) + CONVERT(VARCHAR(4000),@v_rec_no) END  
							END

							INSERT INTO  cir_rcphdr ( comp_code , unit_code , agcd , dpcd , doctype , recptno , recptdt , amount , reason , remark , 
							achd , voucherno , voucherdt , userid , creation_date , branch_code )  
							 VALUES ( @vcomp_code1 , @vunit1 , @vbill_agcd1, @vbill_dpcd1, 'CN' , @v_reptno , @pbilldt , 
							- 1 * isnull(@v_bill_sec_amt, 0) , 'SEC DEBIT' , @v_remark , 'SC' , @v_reptno , @pbilldt , @puserid , GETDATE() , @v_bran_code )  
								
							INSERT INTO  cir_rcpdet( comp_code , unit_code , agcd , dpcd , doctyp , recptno , recptdt , payfor , achd , amount , reason , 
							remark , voucherno , voucherdt , usrid , creation_date , branch_code )  
							VALUES 	( @vcomp_code1 , @vunit1 , @vbill_agcd1 , @vbill_dpcd1 , 'CN' , @v_reptno , @pbilldt , 
							@vunit1 , 'SC' , - 1 * isnull(@v_bill_sec_amt, 0) , 'SEC DEBIT' , @v_remark , @v_reptno , @pbilldt , @puserid , GETDATE() , @v_bran_code )  

							INSERT INTO  cir_outmast   ( comp_code , unit_code , agcd , dpcd , doctyp , recptno , recptdt , achd , amount , 
							reason , remark , voucherno , voucherdt , usrid , creation_date , branch_code )  
							VALUES 	( @vcomp_code1 , @vunit1 , @vbill_agcd1 , @vbill_dpcd1 , 'CN' , @v_reptno , @pbilldt , 'SC' , - 1 * isnull(@v_bill_sec_amt, 0) , 
							'SEC DEBIT' , @v_remark , @v_reptno , @pbilldt , @puserid , GETDATE() , @v_bran_code )  
			
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
						SET @v_tax_amt   =0
						SET @v_tax_prate =NULL
						SET @v_tax_frate =NULL
			    END
   
			fetch NEXT FROM agency_cur INTO @vcomp_code1 , @vunit1 ,@vbill_agcd1, @vbill_dpcd1 , @vbranch_code1, @vcity_name1, @vag_name1,@vprint_seqno1,@vagbill_publ1,@agency_rec_agcd,@agency_rec_dpcd,@agency_rec_route_code
		
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


///////////////////////////////////////////

ALTER PROCEDURE  [dbo].[Cir_user_privilege]
  	@puserid as varchar(100),
	@pcompcode as varchar(10),
    @punitcode as varchar(10),
    @pbranch as varchar(200),
    @ppub as	varchar(30),
	@pedn as	varchar(30),
    @pextra1 as	varchar(100),
    @pextra2 as varchar(100)

 AS   
	SELECT approval_per as "APPROVAL_PER" FROM cir_unsold_apr_permission 
	WHERE user_id = @puserid and comp_code=@pcompcode and printing_center=@punitcode 
	--and (branch_code=@pbranch or @pbranch =''or @pbranch is null) 
	and publ=@ppub and sub_edtn=@pedn


//////////////////////////////////////////////////end////////////////////////////////////////////////////////////////////


//////////////////add by deepika 27-nov-2012///////////////////


alter table preferrences add MIN_MAX_VALIDATE_IN_CORRECTION varchar(1)
alter table preferrences add CIR_BASE_SUP_ENBL_SUPALTER varchar(1)
alter table preferrences add CIR_UCN_POCESS_IN_GROUP varchar(1)


///////////////////////////////////////////////////next




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


CIR_BARCODE,CIR_WIEGHT_CALC_REQ,GEN_RCT_TYP,PRODUCT_BRAND_REQ,ALLOWPREM_CARD_DISC_RATE,FINANCE_CADE,EXECUTIVE_PUBLICATION_VISE,EXECUTIVECREDITLIMIT,MRV_BASED_ON,
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
	CIR_UCN_POCESS_IN_GROUP
           FROM PREFERRENCES
          WHERE comp_code = @compcode


//////////////////////////////////////next


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
@P_min_max_validate_correction as varchar(5) =null,
@P_base_supply_enable_alteration as varchar(5) =null,
@P_UCN_PROCESS as varchar(5) =null
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

 CIR_BARCODE= @P_BAR_CODE,CIR_WIEGHT_CALC_REQ= @P_WEIGHT_CAL,GEN_RCT_TYP = @P_GEN_RCT_NO,PRODUCT_BRAND_REQ=@P_misdata,ALLOWPREM_CARD_DISC_RATE=@P_allowpremium,FINANCE_CADE=@p_financecode,EXECUTIVE_PUBLICATION_VISE=@p_exepub,EXECUTIVECREDITLIMIT=@p_executivecreditlimit,
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
MIN_MAX_VALIDATE_IN_CORRECTION=@P_min_max_validate_correction,
 CIR_BASE_SUP_ENBL_SUPALTER=@P_base_supply_enable_alteration,
 CIR_UCN_POCESS_IN_GROUP=@P_UCN_PROCESS

 WHERE comp_code=@compcode




/* ,
',Unsold_Entry_Flag='''+@Unsoldflag+''',Supply_Stop_Percentage='''+@Supplystopper+'''

,ROKEYCHECK='''+@drpRokeychk+''',AGENCYCOMM_SEQ_COM='''+@Agencycomm_seq+''' ,CREDIT_RECIPT='''+@creditreciept+''' where    comp_code='''+@compcode+'''   ' 



--,DISP_CASHBILL='''+@cashindisplay+''',CLA_CASHBILL='''+@cashinclassified+'''
*/

print(@query1)
exec(@query1)






//////////////////////////////////////////end//////////////////////////////////////////////////////////////







********************************************zone region permission**************************


ALTER PROCEDURE [dbo].[cir_region_bind_newp]
@pcompcode as varchar(20),
--@pzonecode as varchar(1000),
@preg_code as varchar(1000),
@pdateformat as varchar(20),
@puserid as varchar(20),
@pextra1 as varchar(20),
@pextra2 as varchar(20)
as
begin
declare @v_str	 varchar(4000)
declare @v_regcode varchar(1000)
print(@preg_code)

If @preg_code is not null or @preg_code<>'' Begin
set @v_regcode=''''+replace(@preg_code,',',''',''')+''''
End


 Begin
print(@preg_code)
set @v_str='select LOGIN_REGION_MAST.*
from LOGIN_REGION_MAST
where comp_code='+''''+@pcompcode+''''+' and REGION_CODE in ('+@v_regcode+') 
and USER_CODE='+''''+@puserid+''''+'
order by LOGIN_REGION_MAST.REGION_CODE'



print (@v_str)
End
print(@v_str)
exec(@v_str)
End



*******************************************************************************************


**************************add by Deepika 29/11/2012///////////////////////////////////////


                   
ALTER PROCEDURE [dbo].[cir_unsold_credit_note_process]
	  @pcomp_code 		as varchar(20),
	  @punit_code 		as varchar(20),
	  @prec_fromdate    as varchar(20),
	  @prec_todate 	    as varchar(20),
	  @pagtype_code     as varchar(20),
      @pagcd_code 		as varchar(20),
	  @pdpcd_code 		as varchar(20),
	  @puserid          as varchar(20),
      @pdateformat 	    as varchar(20),
	  @pextra1 			as varchar(20),
	  @pextra2 			as varchar(20)
AS 
	declare @v_frdt		datetime                                  
	declare @v_todt		datetime                          
	declare @v_doctype  varchar(5)                                 
	declare @v_tot_amt  numeric(15,2)                                  
	declare @v_count	numeric
	declare @v_dsign	numeric
	declare @v_recptdt  datetime
	declare @v_amt		numeric(15,2)                  

	set @v_doctype='UCN'
	set @v_tot_amt=0
	set @v_count = 0 
	set @v_frdt  = dbo.convert_user_date('/',@prec_fromdate,@pdateformat)
	set @v_todt  = dbo.convert_user_date('/', @prec_todate,@pdateformat)
	set @v_recptdt  = @v_todt

print(@v_frdt)
print(@v_todt)

create table #print_cn_data
(
AGCD  varchar(20),
DPCD varchar(20),
RECPTNO varchar(50),
RECPTDT datetime,
DOCTYPE varchar(20),
PROCESS_CRNO varchar(50),
PROCESS_CRDT  datetime
)
		declare @v_recptno varchar(20)
		declare @v_remark varchar(200)
--		variable for cursor
		declare @v1_comp_code varchar(20)
		declare @v1_unit_code varchar(20)
		declare @v1_branch_code varchar(20)
		declare @v1_agcd varchar(20)
		declare @v1_dpcd varchar(20)
		declare @v1_unsold_copy		numeric(8)
		declare @v1_missing_copy	numeric(8)
		declare @v1_late_copy		numeric(8)
		declare @v1_short_copy		numeric(8)
		declare @v1_damage_copy		numeric(8)
		declare @v1_amount			numeric(15,2)
		declare @v_rcdt				varchar(10)		
		declare @v_rcdp				varchar(20)
		declare @v_ccdp				varchar(20)
		declare c1 cursor for
			select h.comp_code comp_code,h.unit_code unit_code,m.branch_code branch_code,h.agcd agcd,h.dpcd dpcd,sum(isnull(apr_unsold,0)) unsold_copy,sum(isnull(d.apr_bnr,0)) missing_copy , sum(isnull(apr_late_recpt,0)) late_copy,sum(isnull(d.apr_short_recpt,0)) short_copy,sum(isnull(d.apr_damage,0)) damage_copy,
            ---change here
           sum(((isnull(apr_unsold,0)+isnull(d.apr_bnr,0)+isnull(apr_late_recpt,0)+
           isnull(d.apr_short_recpt,0)+isnull(d.apr_damage,0))*isnull(copy_rate,0))
           
           -((((isnull(apr_unsold,0)+isnull(d.apr_bnr,0)+isnull(apr_late_recpt,0)+
           isnull(d.apr_short_recpt,0)+isnull(d.apr_damage,0))*isnull(copy_rate,0))*isnull(comm_rate,0))/100)
           
           -((((isnull(apr_unsold,0)+isnull(d.apr_bnr,0)+isnull(apr_late_recpt,0)+
           isnull(d.apr_short_recpt,0)+isnull(d.apr_damage,0))*isnull(copy_rate,0))*isnull(waste_rate,0))/100)
          ) amount 
            
            --sum(((isnull(apr_unsold,0)+isnull(d.apr_bnr,0)+isnull(apr_late_recpt,0)+
           -- isnull(d.apr_short_recpt,0)+isnull(d.apr_damage,0))*isnull(copy_rate,0))-
           -- isnull(comm_amt,0)-isnull(waste_amt,0)) amount 
           
             ---change here
            
            from cir_unsold_hdr_dis h,cir_unsold_dtl_dis d,cir_agmast_dis m
            where h.comp_code=@pcomp_code and h.comp_code=d.comp_code and h.comp_code=m.comp_code and
            h.unit_code=@punit_code and h.unit_code=d.unit_code and h.unit_code=m.unit and 
            --h.doctype=@v_doctype and
             h.doctype IN('UCN','SCN')and
             --h.doctype=d.doctype and 
            h.recptno=d.recptno and h.recptdt=d.recptdt and 
            (h.agcd=@pagcd_code or @pagcd_code is null) and (h.dpcd=@pdpcd_code or @pdpcd_code is null) and 
            h.agcd=d.agcd and h.dpcd=d.dpcd and h.agcd=m.agcd and h.dpcd=m.dpcd and (m.ag_type=@pagtype_code or @pagtype_code is null or @pagtype_code ='') and
            h.app_dt between @v_frdt and @v_todt and (h.app_userid is not null or h.app_userid<>'') and (h.process_crno is null or h.process_crno='') and 
            (isnull(apr_unsold,0)+isnull(d.apr_bnr,0)+isnull(apr_late_recpt,0)+isnull(d.apr_short_recpt,0)+isnull(d.apr_damage,0))>0 and upper(isnull(@pextra2,'/'))='D'
            group by h.comp_code,h.unit_code,m.branch_code,h.agcd,h.dpcd
			union
			select h.comp_code comp_code,h.unit_code unit_code,m.branch_code branch_code,h.agcd agcd,h.dpcd dpcd,sum(isnull(apr_unsold,0)) unsold_copy,sum(isnull(d.apr_bnr,0)) missing_copy , sum(isnull(apr_late_recpt,0)) late_copy,sum(isnull(d.apr_short_recpt,0)) short_copy,sum(isnull(d.apr_damage,0)) damage_copy,
						 ---change here
						--sum(((isnull(apr_unsold,0)+isnull(d.apr_bnr,0)+isnull(apr_late_recpt,0)+
						--isnull(d.apr_short_recpt,0)+isnull(d.apr_damage,0))*isnull(copy_rate,0))-
						--isnull(comm_amt,0)-isnull(waste_amt,0)) amount 
						 sum(((isnull(apr_unsold,0)+isnull(d.apr_bnr,0)+isnull(apr_late_recpt,0)+
           isnull(d.apr_short_recpt,0)+isnull(d.apr_damage,0))*isnull(copy_rate,0))
           
           -((((isnull(apr_unsold,0)+isnull(d.apr_bnr,0)+isnull(apr_late_recpt,0)+
           isnull(d.apr_short_recpt,0)+isnull(d.apr_damage,0))*isnull(copy_rate,0))*isnull(comm_rate,0))/100)
           
           -((((isnull(apr_unsold,0)+isnull(d.apr_bnr,0)+isnull(apr_late_recpt,0)+
           isnull(d.apr_short_recpt,0)+isnull(d.apr_damage,0))*isnull(copy_rate,0))*isnull(waste_rate,0))/100)
          ) amount 
					 ---change here	
						from cir_unsold_hdr h,cir_unsold_dtl d,cir_agmast m
						where h.comp_code=@pcomp_code and h.comp_code=d.comp_code and h.comp_code=m.comp_code and
						h.unit_code=@punit_code and h.unit_code=d.unit_code and h.unit_code=m.unit 
						--and h.doctype=@v_doctype 
						and h.doctype IN('UCN','SCN')
						--and h.doctype=d.doctype 
						and 
						h.recptno=d.recptno and h.recptdt=d.recptdt and 
						(h.agcd=@pagcd_code or @pagcd_code is null) and (h.dpcd=@pdpcd_code or @pdpcd_code is null) and 
						h.agcd=d.agcd and h.dpcd=d.dpcd and h.agcd=m.agcd and h.dpcd=m.dpcd and (m.ag_type=@pagtype_code or @pagtype_code is null or @pagtype_code ='') and
						h.app_dt between @v_frdt and @v_todt and (h.app_userid is not null or h.app_userid<>'') and (h.process_crno is null or h.process_crno='') and 
						(isnull(apr_unsold,0)+isnull(d.apr_bnr,0)+isnull(apr_late_recpt,0)+isnull(d.apr_short_recpt,0)+isnull(d.apr_damage,0))>0 and upper(isnull(@pextra2,'/'))!='D'
						group by h.comp_code,h.unit_code,m.branch_code,h.agcd,h.dpcd
						order by comp_code,unit_code,branch_code,agcd,dpcd
						
						
					
						
						
					
						
		open c1
		fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit_code,@v1_branch_code,@v1_agcd,@v1_dpcd,@v1_unsold_copy,@v1_missing_copy,@v1_late_copy,@v1_short_copy,@v1_damage_copy,@v1_amount
			print(@@FETCH_STATUS)
		WHILE (@@FETCH_STATUS = 0) BEGIN
			print(@v1_agcd)print(@v1_dpcd)print(@v1_amount)
				
			if(@@FETCH_STATUS=-1)
				break;
				select @v_dsign=Dsign from cir_docmst where Comp_code=@pcomp_code AND doc_type=@v_doctype;

				set @v_amt=@v1_amount*@v_dsign;
		            
				select distinct @v_rcdp=dr_cdp,@v_ccdp=cr_cdp from FA_FIN_LINK_MAST where comp_code=@v1_comp_code and unit_code=@v1_unit_code and 
					branch_code=@v1_branch_code and modual_alias='CCOL' and doctype=@v_doctype and getdate() BETWEEN ISNULL(EFF_FR_DATE,GETDATE()) AND ISNULL(EFF_TO_DATE,GETDATE())
					
				set @v_remark='Being amount credited against unsold return';
					
				if isnull(@v1_unsold_copy,0)>0 begin
					set @v_remark=@v_remark+' Unsold Copy:- '+ cast(@v1_unsold_copy as varchar);
				end
					
				if isnull(@v1_missing_copy,0)>0 begin
					set @v_remark=@v_remark+' Missing Copy:- '+cast(@v1_missing_copy as varchar);
				end
					
				if isnull(@v1_late_copy,0)>0 begin
					set @v_remark=@v_remark+' Late Copy:- '+cast(@v1_late_copy as varchar);
				end
					
				if isnull(@v1_short_copy,0)>0 begin
					set @v_remark=@v_remark+' Short Copy:- '+cast(@v1_short_copy as varchar);
				end
				
				if isnull(@v1_damage_copy,0)>0 begin
					set @v_remark=@v_remark+' Damage Copy:- '+cast(@v1_damage_copy as varchar);
				end
				print('3')print(@v_remark)
				--set @v_rcdt='10/29/2010'
				
				set @v_rcdt= case @pdateformat when 'mm/dd/yyyy' then convert(varchar(10), @v_recptdt,101)
											   when 'dd/mm/yyyy' then convert(varchar(10), @v_recptdt,103)			
											   when 'yyyy/mm/dd' then convert(varchar(10), @v_recptdt,111) end
				print('4')print(@v_rcdt)print(@v1_comp_code)print(@v1_branch_code)print(@v_doctype)


				if upper(@pextra2)='D' begin
	                select @v_recptno = CONVERT(NUMERIC(10), MAX(SUBSTRING(recptno,charindex('-',recptno)+1, 8)))+1 from cir_rcphdr_dis 
		            where comp_code=@v1_comp_code  and doctype=@v_doctype AND  
		            replace(substring(CONVERT(VARCHAR(10), recptdt,2),1,5),'.','') = replace(substring(CONVERT(VARCHAR(10), @v_recptdt,2),1,5),'.','') and 
                    branch_code=@v1_branch_code
				end

				else begin
					select @v_recptno = CONVERT(NUMERIC(10), MAX(SUBSTRING(recptno,charindex('-',recptno)+1, 8))) + 1 from cir_rcphdr 
					where comp_code=@v1_comp_code  and doctype=@v_doctype AND 
					replace(substring(CONVERT(VARCHAR(10), recptdt,2),1,5),'.','') = replace(substring(CONVERT(VARCHAR(10), @v_recptdt,2),1,5),'.','') and 
					branch_code=@v1_branch_code             
				end
					print('5')print(@v_recptno)
					
					If isnull(@v_recptno,0)=0 Begin
					  set @v_recptno=@v1_branch_code+'-'+replace(substring(CONVERT(VARCHAR(10), @v_recptdt,2),1,5),'.','')+'0001'
					End  
					Else Begin
					  set @v_recptno=@v1_branch_code+'-'+RIGHT ('00000000'+ CAST (@v_recptno AS varchar), 8)
					End
					
					--set @v_recptno=dbo.Cir_Genrate_Id_receipt_cndn_id_p (@pcomp_code,@v_doctype,@punit_code,@v_rcdt,@pdateformat,@pextra1,@pextra2)
					if upper(@pextra2)='D' begin
						if @v_recptno is not null and isnull(@v_amt,0)<>0 begin

						insert into cir_rcphdr_dis(comp_code,unit_code,agcd,dpcd,doctype,
									 recptno,recptdt,amount,reason,remark,
									 achd,voucherno,voucherdt,userid,creation_datetime,branch_code,CCDP,RCDP)
								values(@v1_comp_code, @v1_unit_code,@v1_agcd, @v1_dpcd,@v_doctype,
									 @v_recptno,@v_recptdt,@v_amt,'UNSOLD CREDIT NOTE',@v_remark,
									 'NM',@v_recptno,@v_recptdt,@puserid,getdate(),@v1_branch_code,@v_CCDP,@v_RCDP);
						insert into cir_rcpdet_dis(comp_code,unit_code,agcd,dpcd,doctyp,
									 recptno,recptdt,payfor,achd,amount,
									 reason,remark,voucherno,voucherdt,usrid,
									 creation_datetime,branch_code)
							  values(@v1_comp_code, @v1_unit_code,@v1_agcd, @v1_dpcd,@v_doctype,
									 @v_recptno,@v_recptdt,@v1_branch_code,'NM',@v_amt,
									 'UNSOLD CREDIT NOTE',@v_remark,@v_recptno,@v_recptdt,@puserid,
									 getdate(),@v1_branch_code);
						insert into cir_outmast_dis(comp_code,unit_code,agcd,dpcd,doctyp,
									  recptno,recptdt,achd,amount,reason,
									  remark,voucherno,voucherdt,usrid,creation_datetime,branch_code)
							   values(@v1_comp_code, @v1_unit_code,@v1_agcd, @v1_dpcd,@v_doctype,
									  @v_recptno,@v_recptdt,'NM',@v_amt,'UNSOLD CREDIT NOTE',
									  @v_remark,@v_recptno,@v_recptdt,@puserid,getdate(),@v1_branch_code);
						
						set @v_count     =isnull(@v_count,0)+1;
						set @v_tot_amt   =isnull(@v_tot_amt,0)+isnull(@v1_amount,0);
						
						update cir_unsold_hdr_dis set process_crno=@v_recptno,process_crdt=@v_recptdt
							where comp_code=@v1_comp_code and unit_code=@v1_unit_code and doctype=@v_doctype and 
							recptdt between @v_frdt and @v_todt and app_userid is not null and agcd=@v1_agcd and dpcd=@v1_dpcd and 
							process_crno is null and process_crdt is null;
	            
						update cir_unsold_dtl_dis set process_crno=@v_recptno,process_crdt=@v_recptdt
							where comp_code=@v1_comp_code and unit_code=@v1_unit_code 
							--and doctype=@v_doctype 
							and doctype IN('UCN','SCN')
							and 
							recptdt between @v_frdt and @v_todt and agcd=@v1_agcd and dpcd=@v1_dpcd and 
							process_crno is null and process_crdt is null and recptno in(select distinct recptno from cir_unsold_hdr 
							where comp_code=@v1_comp_code and unit_code=@v1_unit_code and doctype=@v_doctype and 
							recptdt between @v_frdt and @v_todt and app_userid is not null and agcd=@v1_agcd and dpcd=@v1_dpcd and 
							process_crno is null and process_crdt is null);               
						
							
insert into #print_cn_data(AGCD,DPCD,RECPTNO,RECPTDT,DOCTYPE,PROCESS_CRNO,PROCESS_CRDT)
select top 1 agcd,dpcd,recptno,recptdt,doctype,process_crno,process_crdt from   cir_unsold_dtl_dis
where    comp_code=@v1_comp_code and unit_code=@v1_unit_code 
and doctype IN('UCN','SCN')
and recptdt between @v_frdt and @v_todt and agcd=@v1_agcd and dpcd=@v1_dpcd and 
process_crno=@v_recptno and process_crdt=@v_recptdt and recptno in(select distinct recptno from cir_unsold_hdr 
where comp_code=@v1_comp_code and unit_code=@v1_unit_code and doctype IN('UCN','SCN') and 
recptdt between @v_frdt and @v_todt and app_userid is not null and agcd=@v1_agcd and dpcd=@v1_dpcd and 
process_crno=@v_recptno and process_crdt=@v_recptdt); 
							
					end
				end
				else begin
					if @v_recptno is not null and isnull(@v_amt,0)<>0 begin
print('222222')
						insert into cir_rcphdr(comp_code,unit_code,agcd,dpcd,doctype,
									 recptno,recptdt,amount,reason,remark,
									 achd,voucherno,voucherdt,userid,creation_date,branch_code,CCDP,RCDP)
								values(@v1_comp_code, @v1_unit_code,@v1_agcd, @v1_dpcd,@v_doctype,
									 @v_recptno,@v_recptdt,@v_amt,'UNSOLD CREDIT NOTE',@v_remark,
									 'NM',@v_recptno,@v_recptdt,@puserid,getdate(),@v1_branch_code,@v_CCDP,@v_RCDP);
						insert into cir_rcpdet(comp_code,unit_code,agcd,dpcd,doctyp,
									 recptno,recptdt,payfor,achd,amount,
									 reason,remark,voucherno,voucherdt,usrid,
									 creation_date,branch_code)
							  values(@v1_comp_code, @v1_unit_code,@v1_agcd, @v1_dpcd,@v_doctype,
									 @v_recptno,@v_recptdt,@v1_branch_code,'NM',@v_amt,
									 'UNSOLD CREDIT NOTE',@v_remark,@v_recptno,@v_recptdt,@puserid,
									 getdate(),@v1_branch_code);
						insert into cir_outmast(comp_code,unit_code,agcd,dpcd,doctyp,
									  recptno,recptdt,achd,amount,reason,
									  remark,voucherno,voucherdt,usrid,creation_date,branch_code)
							   values(@v1_comp_code, @v1_unit_code,@v1_agcd, @v1_dpcd,@v_doctype,
									  @v_recptno,@v_recptdt,'NM',@v_amt,'UNSOLD CREDIT NOTE',
									  @v_remark,@v_recptno,@v_recptdt,@puserid,getdate(),@v1_branch_code);
						set @v_count     =isnull(@v_count,0)+1;
						set @v_tot_amt   =isnull(@v_tot_amt,0)+isnull(@v1_amount,0);

												update cir_unsold_hdr set process_crno=@v_recptno,process_crdt=@v_recptdt
							where comp_code=@v1_comp_code and unit_code=@v1_unit_code 
							--and doctype=@v_doctype 
							and doctype IN('UCN','SCN')
							and 
							recptdt between @v_frdt and @v_todt AND
					        (app_userid is not null or app_userid<>'') 
							and agcd=@v1_agcd and dpcd=@v1_dpcd and 
							(process_crno is null or process_crno='') and process_crdt is null;
	            
						update cir_unsold_dtl set process_crno=@v_recptno,process_crdt=@v_recptdt
							where comp_code=@v1_comp_code and unit_code=@v1_unit_code 
							--and doctype=@v_doctype
							and doctype IN('UCN','SCN')
							 and 
							recptdt between @v_frdt and @v_todt and agcd=@v1_agcd and dpcd=@v1_dpcd and 
							(process_crno is null or process_crno='') and process_crdt is null and 
							recptno in(select distinct recptno from cir_unsold_hdr 
							where comp_code=@v1_comp_code and unit_code=@v1_unit_code 
							--and doctype=@v_doctype 
							and doctype IN('UCN','SCN')
							and 
							recptdt between @v_frdt and @v_todt 
							and (app_userid is not null or app_userid<>'') 
							
							and 
							agcd=@v1_agcd and dpcd=@v1_dpcd and 
							(process_crno is not null or process_crno<>''));
						print('@v_doctype')	
						print(@v_doctype)
						

						insert into #print_cn_data(AGCD,DPCD,RECPTNO,RECPTDT,DOCTYPE,PROCESS_CRNO,PROCESS_CRDT)
select top 1 agcd,dpcd,recptno,recptdt,doctype,process_crno,process_crdt from   cir_unsold_dtl
where    comp_code=@v1_comp_code and unit_code=@v1_unit_code 
and doctype IN('UCN','SCN')
and recptdt between @v_frdt and @v_todt and agcd=@v1_agcd and dpcd=@v1_dpcd and 
process_crno=@v_recptno and process_crdt=@v_recptdt and recptno in(select distinct recptno from cir_unsold_hdr 
where comp_code=@v1_comp_code and unit_code=@v1_unit_code and doctype IN('UCN','SCN') and 
recptdt between @v_frdt and @v_todt and app_userid is not null and agcd=@v1_agcd and dpcd=@v1_dpcd and 
process_crno=@v_recptno and process_crdt=@v_recptdt);  
					end
				end
				set @v1_comp_code=null
				set @v1_unit_code=null
				set @v1_branch_code=null
				set @v1_agcd=null
				set @v1_dpcd=null
				set @v1_unsold_copy=0
				set @v1_missing_copy=0
				set @v1_late_copy=0
				set @v1_short_copy=0
				set @v1_damage_copy=0
				set @v1_amount=0
				set @v_remark=null
				set @v_recptno=null
				set @v1_branch_code=null
			fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit_code,@v1_branch_code,@v1_agcd,@v1_dpcd,@v1_unsold_copy,@v1_missing_copy,@v1_late_copy,@v1_short_copy,@v1_damage_copy,@v1_amount
			end
		close c1
		deallocate c1

        select @v_count as "TOTAL_CREDIT_NOTE",@v_tot_amt as "TOTAL_CREDIT_NOTE_AMOUNT"
        
        select  distinct * from #print_cn_data
						


///////////////////////////////////////////next



create PROCEDURE [dbo].[cir_fetch_unsold_adjustment_detail]
	  @pcomp_code 		as varchar(20),
	  @punit_code 		as varchar(20),
	  @pagcd_code 		as varchar(20),
	  @pdpcd_code 		as varchar(20),
	  @ppubl            as varchar(20),
	  @pedtn            as varchar(20),
	  @psubedtn         as varchar(20),
	  @pbranch_code     as varchar(20),
	  @prec_fromdate    as varchar(20),
	  @prec_todate 	    as varchar(20), 
	  @pdateformat 	    as varchar(20),
      @puserid 	       as varchar(20),
	  @pextra1 			as varchar(20),
	  @pextra2 			as varchar(20),
	  @pextra3 			as varchar(20),
	  @pextra4 			as varchar(20),
	  @pextra5 			as varchar(20),
	  @pextra6 			as varchar(20),
	  @pextra7 			as varchar(20),
	  @pextra8 			as varchar(20),
	  @pextra9 			as varchar(20),
	  @pextra10 			as varchar(20)
AS 
	declare @v_frdt		datetime                                  
	declare @v_todt		datetime                          
	              
	set @v_frdt  = dbo.convert_user_date('/',@prec_fromdate,@pdateformat)
	set @v_todt  = dbo.convert_user_date('/', @prec_todate,@pdateformat)
	

print(@v_frdt)
print(@v_todt)



select d.UNIT_CODE,dbo.cir_get_pubcenter(d.COMP_CODE,d.UNIT_CODE,@puserid,@pdateformat,'','') 
as UNIT_NAME,d.BRANCH_CODE,dbo.cir_get_branch(d.COMP_CODE,d.BRANCH_CODE) 
as BRANCH_NAME,d.RECPTNO,d.RECPTDT,d.AGCD,d.DPCD,dbo.cir_get_agency(d.COMP_CODE,d.UNIT_CODE,d.AGCD,d.DPCD) as AG_NAME
,x.AMOUNT
from CIR_RCPHDR d , CIR_OUTMAST x
WHERE  d.COMP_CODE=@pcomp_code 
and d.comp_code=x.COMP_CODE
AND d.UNIT_CODE=@punit_code
and d.UNIT_CODE=x.UNIT_CODE 
and d.RECPTNO=x.RECPTNO
and d.RECPTDT=x.RECPTDT
and d.AGCD=x.AGCD
and d.DPCD=x.DPCD
AND (d.AGCD=@pagcd_code or @pagcd_code='' or @pagcd_code=NULL)
AND (d.DPCD=@pdpcd_code or @pdpcd_code='' or @pdpcd_code=NULL)
AND (d.PUBL=@ppubl  or  @ppubl='' or @ppubl=NULL)
AND (d.BRANCH_CODE=@pbranch_code or  @pbranch_code='' or @pbranch_code=NULL)
AND d.RECPTDT BETWEEN @v_frdt AND @v_todt AND DOCTYPE='UCN'
and (x.BILLNO is null or x.BILLNO ='') 
and (x.BILLdt is null or x.BILLdt ='') 
AND (x.AMOUNT)< 0;




------------------------------next



ALTER PROCEDURE [dbo].[cir_unsold_credit_note_adjustment]
      @pcomp_code         as varchar(20),
      @punit_code         as varchar(20),
      @pagcd_code         as varchar(20),
      @pdpcd_code         as varchar(20),
      @precptno           as varchar(20),
      @precptdt           as varchar(20),
      @pbranch_code       as varchar(20),
      @pamount            as varchar(80),
      @puserid             as varchar(20),
      @pdateformat         as varchar(20),
      @pextra1             as varchar(20),
      @pextra2             as varchar(20),
      @pextra3             as varchar(20),
      @pextra4             as varchar(20),
      @pextra5             as varchar(20),
      @pextra6             as varchar(20),
      @pextra7             as varchar(20),
      @pextra8             as varchar(20),
      @pextra9             as varchar(20),
      @pextra10             as varchar(20)
AS
begin

    declare @v_recdt        datetime                                     
    set @v_recdt  = dbo.convert_user_date('/',@precptdt,@pdateformat)
    declare @v_amt as numeric(14,2)
    set @v_amt=cast(abs(isnull(@pamount,0)) as numeric)

	declare @v2_UNIT_CODE  varchar(50)
	declare @v2_SUPDATE varchar(10)
	declare @v2_PUBL  varchar(50)
	declare @v2_EDTN  varchar(50)
	declare @v2_UNSOLD_COPY  numeric(14,2)
	declare @v2_COPY_RATE  numeric(14,2)
	declare @v2_COMM_RATE  numeric(14,2)
	declare @v2_COPY_AMT  numeric(14,2)
	declare @v2_branch_code as varchar(50)

	
    DECLARE c2 cursor LOCAL FOR
		select x.UNIT_CODE,x.SUPDATE,x.PUBL,x.EDTN,sum(x.UNSOLD_COPY) UNSOLD_COPY,x.COPY_RATE,x.COMM_RATE, x.COPY_AMT ,x.branch_code from
		(select d.UNIT_CODE,convert(varchar(10),d.SUPDATE,101) as SUPDATE ,d.PUBL,d.EDTN
		,SUM(isnull(apr_short_recpt,0) + isnull(apr_late_recpt,0) + isnull(APR_BNR,0) + isnull(apr_unsold,0) + isnull(apr_damage,0)) UNSOLD_COPY
		,d.COPY_RATE,d.COMM_RATE, d.COPY_AMT ,d.branch_code
		from CIR_UNSOLD_HDR h,CIR_UNSOLD_DTL d where h.COMP_CODE=d.COMP_CODE
		and d.comp_code=@pcomp_code and d.unit_code=@punit_code
		and h.UNIT_CODE=d.UNIT_CODE and h.AGCD=d.AGCD and h.DPCD=d.DPCD
		and h.PROCESS_CRNO=d.PROCESS_CRNO and h.PROCESS_CRDT=d.PROCESS_CRDT
		and h.PROCESS_CRDT is not null and h.PROCESS_CRDT!='' 
		and h.PROCESS_CRNO is not null and h.PROCESS_CRNO!='' 
		and d.PROCESS_CRNO=@precptno and d.PROCESS_CRDT=@v_recdt	
		and d.doctype='UCN' and h.DOCTYPE=d.DOCTYPE
		group by d.UNIT_CODE,d.SUPDATE ,d.PUBL,d.EDTN,d.COPY_RATE,d.COMM_RATE, d.COPY_AMT,d.branch_code
		having SUM(isnull(apr_short_recpt,0) + isnull(apr_late_recpt,0) + isnull(APR_BNR,0) + isnull(apr_unsold,0) + isnull(apr_damage,0)) >0
		union all
		select d.UNIT_CODE,convert(varchar(10),d.SUPDATE,101) as SUPDATE ,d.PUBL,d.EDTN
		,SUM(isnull(apr_short_recpt,0) + isnull(apr_late_recpt,0) + isnull(APR_BNR,0) + isnull(apr_unsold,0) + isnull(apr_damage,0)) UNSOLD_COPY
		,d.COPY_RATE,d.COMM_RATE, d.COPY_AMT ,d.branch_code
		from CIR_UNSOLD_HDR h,CIR_UNSOLD_DTL d where h.COMP_CODE=d.COMP_CODE
		and d.comp_code=@pcomp_code and d.unit_code=@punit_code
		and h.UNIT_CODE=d.UNIT_CODE and h.AGCD=d.AGCD and h.DPCD=d.DPCD
		and h.PROCESS_CRNO=d.PROCESS_CRNO and h.PROCESS_CRDT=d.PROCESS_CRDT
		and h.PROCESS_CRDT is not null and h.PROCESS_CRDT!='' 
		and h.PROCESS_CRNO is not null and h.PROCESS_CRNO!='' 
		and d.PROCESS_CRNO=@precptno and d.PROCESS_CRDT=@v_recdt	
		and d.doctype='SCN' and h.DOCTYPE=d.DOCTYPE
		group by d.UNIT_CODE,d.SUPDATE ,d.PUBL,d.EDTN,d.COPY_RATE,d.COMM_RATE, d.COPY_AMT,d.branch_code
		having SUM(isnull(apr_short_recpt,0) + isnull(apr_late_recpt,0) + isnull(APR_BNR,0) + isnull(apr_unsold,0) + isnull(apr_damage,0)) >0
		) x
		group by x.UNIT_CODE,x.SUPDATE,x.PUBL,x.EDTN,x.COPY_RATE,x.COMM_RATE, x.COPY_AMT ,x.branch_code
	
	declare @adj_billno as varchar(50)	
	declare @adj_billdt as datetime
	declare @vtotamt as numeric(14,2)
	declare @adj_amt as numeric(14,2)
	declare @vadjcomamt as numeric(14,2)
	declare @vbal_amt as numeric(14,2)
	declare @v_bal_bill_amt as numeric(14,2)
	declare @v_bal_ucn_amt as numeric(14,2)
	
	
		OPEN c2 
			fetch NEXT FROM c2 INTO @v2_UNIT_CODE, @v2_SUPDATE , @v2_PUBL,@v2_EDTN , @v2_UNSOLD_COPY , @v2_COPY_RATE , @v2_COMM_RATE , @v2_COPY_AMT,@v2_branch_code
			WHILE (@@FETCH_STATUS = 0) 
			BEGIN	print('OPEN c2 ')
				IF (@@FETCH_STATUS = -1) 
					BREAK

				select @adj_billno=max(b.billno),@adj_billdt=max(b.billdt) from cir_bill b,cir_bill_det c 
				where b.comp_code=	@pcomp_code and b.comp_code=c.comp_code
				and b.unit_code=@v2_UNIT_CODE and b.unit_code=c.unit_code
				and b.agcd=@pagcd_code and b.agcd=c.agcd
				and b.dpcd=@pdpcd_code and b.dpcd=c.dpcd
				and b.billno=c.billno and b.billdt=c.billdt
				and convert(varchar(10),c.FROMDT,101)=@v2_SUPDATE
				and b.publ=@v2_PUBL and c.edtn=@v2_EDTN				
				
				set @vtotamt=  ( isnull(@v2_UNSOLD_COPY,0) * isnull(@v2_COPY_RATE,0))   -- 
				set @vadjcomamt= ( ( isnull(@vtotamt,0) * isnull(@v2_COMM_RATE,0)  ) /100 )
				set @adj_amt= ( isnull(@vtotamt,0)  - isnull(@vadjcomamt,0) )
				set @vbal_amt=(abs(isnull(@v_amt,0)) - isnull(@adj_amt,0))
				
				print('***')print('@v_amt')print(@v_amt)print(@vadjcomamt)print(@adj_amt)print(@vbal_amt)print('@')
				
				print('@adj_billno')print(@adj_billno)print('@adj_billdt')print(@adj_billdt)
				if isnull(@adj_billno,'') !='' and isnull(@adj_billdt,'') !='' and ( isnull(@adj_amt,0) <= abs(ISNULL(@pamount,0)) )
				begin
						select @v_bal_bill_amt=SUM(amount) from CIR_OUTMAST where comp_code=@pcomp_code and UNIT_CODE =@v2_UNIT_CODE
						and billno =@adj_billno and billdt=@adj_billdt 
						
						select @v_bal_ucn_amt=SUM(abs(amount)) from CIR_OUTMAST where comp_code=@pcomp_code and UNIT_CODE =@v2_UNIT_CODE
						and RECPTNO =@precptno and RECPTDT=@v_recdt and BILLNO is null and BILLDT is null
						
						print('@v_bal_bill_amt')print(@v_bal_bill_amt) print('@v_bal_ucn_amt')print(@v_bal_ucn_amt)
						print('@v_amt')print(@v_amt)
						
						if(ISNULL(@v_bal_bill_amt,0) > 0  and ISNULL(@v_bal_ucn_amt,0) > 0 )
						begin
							INSERT INTO  cir_outmast( comp_code , UNIT_CODE	, doctyp , reason , BRANCH_CODE , billno , billdt , recptno , recptdt , 
							voucherno , voucherdt , amount , usrid , AGCD , DPCD , remark ,PUBL)  
							VALUES(@pcomp_code,@v2_UNIT_CODE,'UCN','NO0',@v2_branch_code,@adj_billno,@adj_billdt,@precptno,@v_recdt
								 , @precptno , @v_recdt ,-1*@adj_amt , @puserid ,@pagcd_code , @pdpcd_code , 'Auto Adjust With Unsold' ,@v2_PUBL)  
								 
							INSERT INTO  CIR_RCPDET( comp_code , UNIT_CODE	, doctyp , reason , BRANCH_CODE , billno , billdt , recptno , recptdt , 
							voucherno , voucherdt , amount , usrid , AGCD , DPCD , remark,PUBL )  
							VALUES(@pcomp_code,@v2_UNIT_CODE,'UCN','NO0',@v2_branch_code,@adj_billno,@adj_billdt,@precptno,@v_recdt
								 , @precptno , @v_recdt ,-1*@adj_amt , @puserid ,@pagcd_code , @pdpcd_code , 'Auto Adjust With Unsold' ,@v2_PUBL)
								 
							update cir_outmast set amount=	-1*@vbal_amt where comp_code=@pcomp_code and unit_code=@v2_UNIT_CODE
							and recptno=@precptno and recptdt=@v_recdt
							and agcd=@pagcd_code and dpcd=@pdpcd_code
							and billno is null and billdt is null 
							set @v_amt=-1*@vbal_amt
							print('O')
						end     
				end
					
			fetch NEXT FROM c2 INTO @v2_UNIT_CODE, @v2_SUPDATE , @v2_PUBL,@v2_EDTN , @v2_UNSOLD_COPY , @v2_COPY_RATE , @v2_COMM_RATE , @v2_COPY_AMT,@v2_branch_code
			END 			
		close c2
		DEALLOCATE c2	
	
	

end

////////////////////////////////////////////////end////////////////////////////////////////////////////////////////

///////////////////////////add by Deepika 06-dec-2012 for new report( branch date wise summary report)//////////////


create PROCEDURE [dbo].[cir_branch_summary]
      @pcomp_code         as varchar(20),
      @punit_code         as varchar(20),
      @pbranch_code     as varchar(20),
      @pdate            as varchar(20),
      @pdateformat         as varchar(20),
      @puserid             as varchar(20),
      @pextra1             as varchar(20),
      @pextra2             as varchar(20),
      @pextra3             as varchar(20),
      @pextra4             as varchar(20),
      @pextra5             as varchar(20),
      @pextra6             as varchar(20),
      @pextra7             as varchar(20),
      @pextra8             as varchar(20),
      @pextra9             as varchar(20),
      @pextra10             as varchar(20)
AS 
begin
    declare @v_dt        datetime                                  
    declare @v_opdate datetime    
    declare @vfrdt datetime              
    declare @vtodt datetime   
    
	create table #cir_branch_bill_dn_summary
	(
		comp_code varchar(20),
		unit_code varchar(20),
		PUBL_code varchar(20),
		PUBL_TYPE varchar(20),
		BRANCH_CODE varchar(20),
		INV_AMT  numeric(14,2),
		COM_AMT  numeric(14,2),		
		NET_AMT numeric(14,2),
		REMARKS varchar(200),
		DOCTYPE varchar(200)
	)
	create table #cir_branch_unsold_summary
	(
		comp_code varchar(20),
		unit_code varchar(20),
		PUBL_code varchar(20),
		PUBL_TYPE varchar(20),
		BRANCH_CODE varchar(20),
		INV_AMT  numeric(14,2),
		COM_AMT  numeric(14,2),		
		NET_AMT numeric(14,2),
		REMARKS varchar(200),
		DOCTYPE varchar(200)
	)
	create table #cir_branch_payment_cn_summary
	(
		comp_code varchar(20),
		unit_code varchar(20),
		PUBL_code varchar(20),
		PUBL_TYPE varchar(20),
		BRANCH_CODE varchar(20),
		INV_AMT  numeric(14,2),
		COM_AMT  numeric(14,2),		
		NET_AMT numeric(14,2),
		REMARKS varchar(200),
		DOCTYPE varchar(200)
	)
    -- sum_branch cursor variables
    declare @sum_branch_comp_code as varchar(20)          
    declare @sum_branch_unit_code as varchar(20)
    declare @sum_branch_branch_code as varchar(20)
    
	declare @sum_publ_publ	 as varchar(200)
	declare @sum_edtn	 as varchar(200)
	declare @sum_edtn_name	 as varchar(200)

    declare @v_opbal as numeric(18,2)
    declare @v_close_bal as numeric(18,2)
    declare @v_billamt as numeric(14,2)
    declare @v_dbcramt as numeric(14,2)
    declare @v_INV_AMT as numeric(14,2)
    declare @v_COM_AMT as numeric(14,2)
    declare @v_NET_AMT as numeric(14,2)
    declare @v_dn_amt as numeric(14,2)
    declare @v_late_ins as numeric(14,2)
    declare @sum_reason_pay_code as varchar(200)
    declare @sum_reason_pay_name as varchar(200)
                  
    set @v_dt  = dbo.convert_user_date('/',@pdate,@pdateformat)
    set @v_opdate =dbo.cir_get_finandt(@pcomp_code,@v_dt,@pdateformat,null,null)--for financial date
    
    set @vfrdt=@v_opdate
    set @vtodt=DATEADD(dd,-1,@v_dt)
    
    declare sum_branch cursor for
			select distinct comp_code,pub_center ,branch_code  from branch_mst  
			where comp_code = @pcomp_code 
			and (pub_center=@punit_code or @punit_code is null or @punit_code ='') 
			and (branch_code=@pbranch_code or @pbranch_code is null or @pbranch_code ='') 			
			order by comp_code,pub_center ,branch_code
			
	open sum_branch
		fetch NEXT FROM sum_branch INTO @sum_branch_comp_code,@sum_branch_unit_code,@sum_branch_branch_code
		WHILE (@@FETCH_STATUS = 0) Begin
			set @v_opbal=0
			set @v_close_bal=0
			set @v_opbal =dbo.cir_accounts_cir_branch_opbal(@pcomp_code, @punit_code,null,null, null, @v_opdate, 'NM',@pdateformat,@sum_branch_branch_code,null)		
			
			select @v_billamt=sum(amount) from cir_outmast
			where comp_code = @pcomp_code and unit_code=@punit_code and 
				BRANCH_CODE=@sum_branch_branch_code and billdt >= @v_opdate and billdt<@v_dt and 
				achd='NM' and recptno is null

			select @v_dbcramt=sum(amount) from cir_rcpdet
				where comp_code=@pcomp_code and unit_code=@punit_code and 
					BRANCH_CODE=@sum_branch_branch_code and recptdt>= @v_opdate and recptdt<@v_dt and 
					achd='NM' and billno is null

			set @v_opbal=isnull(@v_opbal,0)+isnull(@v_billamt,0)+isnull(@v_dbcramt,0)
			
			------------------  insert BF ----------------
			insert into #cir_branch_bill_dn_summary(comp_code,unit_code,PUBL_code,PUBL_TYPE,BRANCH_CODE
			,INV_AMT,COM_AMT,NET_AMT,REMARKS,DOCTYPE)	
			values (@pcomp_code,@sum_branch_unit_code,null,'BBF',@sum_branch_branch_code,
			null,null,@v_opbal,'Balance B/F','BBF')
			---------------------------------------------	
			declare sum_publ cursor for
						select distinct  publ,pro_type,publ_name from cir_publ_mast
						where comp_code = @pcomp_code --and (unit_code=@punitcode or @punitcode is null) 
						order by pro_type
				open sum_publ
						fetch NEXT FROM sum_publ INTO @sum_publ_publ,@sum_edtn,@sum_edtn_name
						WHILE (@@FETCH_STATUS = 0) Begin

							select @v_INV_AMT=sum(isnull(GROSS_AMOUNT,0))
							,@v_COM_AMT=sum(isnull(GROSS_AMOUNT,0))-sum(isnull(BILL_AMOUNT,0))	
							,@v_NET_AMT=sum(isnull(BILL_AMOUNT,0))							
							from cir_bill_det where COMP_CODE=@pcomp_code
							and UNIT_CODE=@sum_branch_unit_code 
							and BRANCH_CODE=@sum_branch_branch_code
							and BILLDT =@v_dt and PUBL=@sum_publ_publ 
						
							if ISNULL(@v_INV_AMT,0) >0 and ISNULL(@v_NET_AMT,0)>0
							begin
								------------------  insert BILL ----------------
								insert into #cir_branch_bill_dn_summary(comp_code,unit_code,PUBL_code,PUBL_TYPE,BRANCH_CODE
								,INV_AMT,COM_AMT,NET_AMT,REMARKS,DOCTYPE)	
								values (@pcomp_code,@sum_branch_unit_code,@sum_publ_publ,@sum_edtn,@sum_branch_branch_code,
								@v_INV_AMT,@v_COM_AMT,@v_NET_AMT,'Bill For '+@sum_publ_publ ,'BIL')
								---------------------------------------------	
							end
							
							set @v_INV_AMT=0
							set @v_COM_AMT=0
							set @v_NET_AMT=0
							
							select @v_INV_AMT =SUM(isnull(copy_amt,0))+SUM(isnull(COMM_AMT,0)) 							
							, @v_COM_AMT=SUM(isnull(COMM_AMT,0)), @v_NET_AMT=SUM(isnull(copy_amt,0))
							from CIR_UNSOLD_DTL 
							where COMP_CODE=@pcomp_code and UNIT_CODE=@sum_branch_unit_code 
							and BRANCH_CODE=@sum_branch_branch_code
							and PUBL=@sum_publ_publ 
							and APP_DT = @v_dt
							and (PROCESS_CRNO is not null or PROCESS_CRNO!='')
							and (PROCESS_CRDT is not null or PROCESS_CRDT!='')
							
							if ISNULL(@v_INV_AMT,0) >0 and ISNULL(@v_NET_AMT,0)>0
							begin
								------------------  insert UCN ----------------
								insert into #cir_branch_bill_dn_summary(comp_code,unit_code,PUBL_code,PUBL_TYPE,BRANCH_CODE
								,INV_AMT,COM_AMT,NET_AMT,REMARKS,DOCTYPE)	
								values (@pcomp_code,@sum_branch_unit_code,@sum_publ_publ,@sum_edtn,@sum_branch_branch_code,
								@v_INV_AMT,@v_COM_AMT,@v_NET_AMT,'UCN For '+@sum_publ_publ ,'UCN')
								---------------------------------------------	
							end
						fetch NEXT FROM sum_publ INTO @sum_publ_publ,@sum_edtn,@sum_edtn_name
					End

				close sum_publ
				deallocate sum_publ
				
				set @v_dn_amt=0
				select @v_dn_amt=SUM(isnull(abs(amount),0)) from CIR_RCPHDR 
				where COMP_CODE=@sum_branch_comp_code and UNIT_CODE=@sum_branch_unit_code 
				and BRANCH_CODE=@sum_branch_branch_code and DOCTYPE='DN'
				and RECPTDT =@v_dt
				
				------------------  insert DN ----------------
				insert into #cir_branch_bill_dn_summary(comp_code,unit_code,PUBL_code,PUBL_TYPE,BRANCH_CODE
				,INV_AMT,COM_AMT,NET_AMT,REMARKS,DOCTYPE)	
				values (@pcomp_code,@sum_branch_unit_code,null,'DN',@sum_branch_branch_code,
				null,null,isnull(@v_dn_amt,0),'Debit Note','DN')
				---------------------------------------------
				
				set @v_late_ins=0
				select @v_late_ins=SUM(isnull(abs(amount),0)) from CIR_RCPHDR 
				where COMP_CODE=@sum_branch_comp_code and UNIT_CODE=@sum_branch_unit_code 
				and BRANCH_CODE=@sum_branch_branch_code and DOCTYPE='CN' and achd='NM'  and REASON='IN0'
				and RECPTDT =@v_dt
				
				------------------  insert CN FOR IN0 ----------------
				insert into #cir_branch_bill_dn_summary(comp_code,unit_code,PUBL_code,PUBL_TYPE,BRANCH_CODE
				,INV_AMT,COM_AMT,NET_AMT,REMARKS,DOCTYPE)	
				values (@pcomp_code,@sum_branch_unit_code,null,'IN0',@sum_branch_branch_code,
				null,null,isnull(@v_late_ins,0),'INSERTION FEE','CN')
				---------------------------------------------
				
				set @v_late_ins=0
				select @v_late_ins=SUM(isnull(abs(amount),0)) from CIR_RCPHDR 
				where COMP_CODE=@sum_branch_comp_code and UNIT_CODE=@sum_branch_unit_code 
				and BRANCH_CODE=@sum_branch_branch_code and DOCTYPE='CN' and achd='NM'  and REASON='LA0'
				and RECPTDT =@v_dt
				
				------------------  insert CN FOR LA0 ----------------
				insert into #cir_branch_bill_dn_summary(comp_code,unit_code,PUBL_code,PUBL_TYPE,BRANCH_CODE
				,INV_AMT,COM_AMT,NET_AMT,REMARKS,DOCTYPE)	
				values (@pcomp_code,@sum_branch_unit_code,null,'LA0',@sum_branch_branch_code,
				null,null,isnull(@v_late_ins,0),'LATE FACTOR FEE','CN')
				---------------------------------------------
				
				set @v_late_ins=0
				select @v_late_ins=SUM(isnull(abs(amount),0)) from CIR_RCPHDR 
				where COMP_CODE=@sum_branch_comp_code and UNIT_CODE=@sum_branch_unit_code 
				and BRANCH_CODE=@sum_branch_branch_code and DOCTYPE='CN' and achd='NM'  and REASON='TR0'
				and RECPTDT =@v_dt
				
				------------------  insert CN FOR TR0 ----------------
				insert into #cir_branch_bill_dn_summary(comp_code,unit_code,PUBL_code,PUBL_TYPE,BRANCH_CODE
				,INV_AMT,COM_AMT,NET_AMT,REMARKS,DOCTYPE)	
				values (@pcomp_code,@sum_branch_unit_code,null,'TR0',@sum_branch_branch_code,
				null,null,isnull(@v_late_ins,0),'TRANSPORT ALLOWANCE FEE','CN')
				---------------------------------------------
				
				declare sum_reason cursor for
						select distinct  pay_mode_code,payment_mode_name from PAYMENT_MODE_MAST
						where comp_code = @pcomp_code --and (unit_code=@punitcode or @punitcode is null) 
						order by payment_mode_name
				
				open sum_reason
						fetch NEXT FROM sum_reason INTO @sum_reason_pay_code,@sum_reason_pay_name
						WHILE (@@FETCH_STATUS = 0) Begin
							
							set @v_late_ins=0
							select @v_late_ins=SUM(isnull(abs(amount),0)) from CIR_RCPHDR 
							where COMP_CODE=@sum_branch_comp_code and UNIT_CODE=@sum_branch_unit_code 
							and BRANCH_CODE=@sum_branch_branch_code and DOCTYPE='RCR'  and ACHD='NM'  and REASON=@sum_reason_pay_code
							and RECPTDT =@v_dt
							
							------------------  insert CN FOR TR0 ----------------
							insert into #cir_branch_bill_dn_summary(comp_code,unit_code,PUBL_code,PUBL_TYPE,BRANCH_CODE
							,INV_AMT,COM_AMT,NET_AMT,REMARKS,DOCTYPE)	
							values (@pcomp_code,@sum_branch_unit_code,null,@sum_reason_pay_code,@sum_branch_branch_code,
							null,null,isnull(@v_late_ins,0),'PAYMENT RECEIVED BY '+@sum_reason_pay_name ,'RCR')
							---------------------------------------------
							
						fetch NEXT FROM sum_reason INTO @sum_reason_pay_code,@sum_reason_pay_name
					End
				close sum_reason
				deallocate sum_reason
				
				set @v_late_ins=0
				select @v_late_ins=SUM(isnull(abs(amount),0)) from CIR_RCPHDR 
				where COMP_CODE=@sum_branch_comp_code and UNIT_CODE=@sum_branch_unit_code 
				and BRANCH_CODE=@sum_branch_branch_code and DOCTYPE='CN' and achd='NM'  and REASON not in ('LA0','TR0','IN0')
				and RECPTDT =@v_dt
				
				------------------  insert CN FOR CN ----------------
				insert into #cir_branch_bill_dn_summary(comp_code,unit_code,PUBL_code,PUBL_TYPE,BRANCH_CODE
				,INV_AMT,COM_AMT,NET_AMT,REMARKS,DOCTYPE)	
				values (@pcomp_code,@sum_branch_unit_code,null,'CN',@sum_branch_branch_code,
				null,null,isnull(@v_late_ins,0),'CREDIT NOTE ADJUSTMENT ','CN')
				---------------------------------------------	
					
		fetch NEXT FROM sum_branch INTO @sum_branch_comp_code,@sum_branch_unit_code,@sum_branch_branch_code
		End
	close sum_branch
	deallocate sum_branch	

	select comp_code,dbo.cir_get_unit_name(comp_code,unit_code) as UNIT,dbo.cir_get_branch(comp_code,branch_code) as BRANCH ,'BALANCE BROUGHT FORWARD' as REMARK 
	,INV_AMT,COM_AMT,NET_AMT from #cir_branch_bill_dn_summary  where DOCTYPE='BBF'
	
	
	select comp_code,dbo.cir_get_unit_name(comp_code,unit_code) as UNIT,dbo.cir_get_branch(comp_code,branch_code) as BRANCH 
	,(SELECT pubname from pub_type_mast p where p.Comp_Code= comp_code and p.pubtypecode=PUBL_TYPE) as REMARK  
	,DOCTYPE
	,sum(isnull(INV_AMT,0)) INV_AMT,sum(isnull(COM_AMT,0)) COM_AMT,sum(isnull(NET_AMT,0)) NET_AMT
	from #cir_branch_bill_dn_summary where DOCTYPE ='BIL'
	group by comp_code,unit_code,branch_code,PUBL_TYPE,DOCTYPE
	union all
	select comp_code,dbo.cir_get_unit_name(comp_code,unit_code) as UNIT,dbo.cir_get_branch(comp_code,branch_code) as BRANCH 
	,'DEBIT NOTE ADJUSTMENT' as REMARK  
	,DOCTYPE
	,sum(isnull(INV_AMT,0)) INV_AMT,sum(isnull(COM_AMT,0)) COM_AMT,sum(isnull(NET_AMT,0)) NET_AMT
	from #cir_branch_bill_dn_summary where DOCTYPE ='DN'
	group by comp_code,unit_code,branch_code,PUBL_TYPE,DOCTYPE
	
	select comp_code,dbo.cir_get_unit_name(comp_code,unit_code) as UNIT,dbo.cir_get_branch(comp_code,branch_code) as BRANCH
	,(SELECT pubname from pub_type_mast p where p.Comp_Code= comp_code and p.pubtypecode=PUBL_TYPE)
	as REMARK  
	,sum(isnull(INV_AMT,0)) INV_AMT,sum(isnull(COM_AMT,0)) COM_AMT,sum(isnull(NET_AMT,0)) NET_AMT
	,DOCTYPE
	from #cir_branch_bill_dn_summary where DOCTYPE ='UCN'  
	group by comp_code,unit_code,branch_code,PUBL_TYPE,DOCTYPE
	union all
	select comp_code,dbo.cir_get_unit_name(comp_code,unit_code) as UNIT,dbo.cir_get_branch(comp_code,branch_code) as BRANCH 
	,(SELECT REASON_NAME from CIR_REASON_MST p where p.Comp_Code= comp_code and p.REASON_CODE=PUBL_TYPE) 
	as REMARK  
	,sum(isnull(INV_AMT,0)) INV_AMT,sum(isnull(COM_AMT,0)) COM_AMT,sum(isnull(NET_AMT,0)) NET_AMT
	,DOCTYPE
	from #cir_branch_bill_dn_summary where DOCTYPE ='CN'  and PUBL_TYPE in ('LA0','TR0','IN0')
	group by comp_code,unit_code,branch_code,PUBL_TYPE,DOCTYPE
	
	
	
	select comp_code,dbo.cir_get_unit_name(comp_code,unit_code) as UNIT,dbo.cir_get_branch(comp_code,branch_code) as BRANCH 
	,	(SELECT PAYMENT_MODE_NAME from payment_mode_mast p where p.Comp_Code= comp_code and p.Pay_Mode_Code=PUBL_TYPE) 
	as REMARK  
	,sum(isnull(INV_AMT,0)) INV_AMT,sum(isnull(COM_AMT,0)) COM_AMT,sum(isnull(NET_AMT,0)) NET_AMT
	,DOCTYPE
	from #cir_branch_bill_dn_summary where DOCTYPE in ('RCR') 
	group by comp_code,unit_code,branch_code,PUBL_TYPE,DOCTYPE
	union all
	select comp_code,dbo.cir_get_unit_name(comp_code,unit_code) as UNIT,dbo.cir_get_branch(comp_code,branch_code) as BRANCH 
	,isnull(
	(SELECT REASON_NAME from CIR_REASON_MST p where p.Comp_Code= comp_code and p.REASON_CODE=PUBL_TYPE) 
	,(SELECT PAYMENT_MODE_NAME from payment_mode_mast p where p.Comp_Code= comp_code and p.Pay_Mode_Code=PUBL_TYPE)
	) 
	as REMARK  
	,sum(isnull(INV_AMT,0)) INV_AMT,sum(isnull(COM_AMT,0)) COM_AMT,sum(isnull(NET_AMT,0)) NET_AMT
	,DOCTYPE
	from #cir_branch_bill_dn_summary where DOCTYPE in ('CN')  and PUBL_TYPE not in ('LA0','TR0','IN0')
	group by comp_code,unit_code,branch_code,PUBL_TYPE,DOCTYPE
	
	declare @v_cl as numeric(14,2)
	select @v_cl=SUM(isnull(NET_AMT,0)) from #cir_branch_bill_dn_summary where DOCTYPE='BBF'
	group by comp_code,unit_code,branch_code
	
	select x.comp_code,dbo.cir_get_unit_name(x.comp_code,x.unit_code) as UNIT,dbo.cir_get_branch(x.comp_code,x.branch_code) as BRANCH ,'BALANCE CARRY FORWARD' as REMARK 
	,sum(isnull(x.INV_AMT,0)) INV_AMT,sum(isnull(x.COM_AMT,0)) COM_AMT,isnull(@v_cl,0) + sum(isnull(x.db_amt,0)) as NET_AMT from (	
	select comp_code,unit_code,branch_code,sum(isnull(INV_AMT,0)) INV_AMT ,sum(isnull(COM_AMT,0)) COM_AMT, sum(isnull(NET_AMT,0)) DB_AMT from #cir_branch_bill_dn_summary 
	where DOCTYPE in ('BIL','DN') group by comp_code,unit_code,branch_code
	union all
	select comp_code,unit_code,branch_code,sum(isnull(INV_AMT,0)) INV_AMT ,sum(isnull(COM_AMT,0)) COM_AMT, sum(-1*isnull(NET_AMT,0)) DB_AMT from #cir_branch_bill_dn_summary 
	where DOCTYPE in ('RCR','UCN','CN') group by comp_code,unit_code,branch_code ) x
	group by x.comp_code,x.unit_code,x.branch_code
	
	select x.COMP_CODE,dbo.cir_get_unit_name(x.comp_code,x.unit_code) as UNIT,dbo.cir_get_branch(x.comp_code,x.branch_code) as BRANCH 
	,'BALANCE CARRY FORWARD' as REMARK ,isnull(SUM(isnull(abs(amount),0)),0) as SC_AMT from CIR_RCPHDR x
	where COMP_CODE=@pcomp_code and UNIT_CODE=@punit_code and DOCTYPE='RCR' and ACHD='SC' and RECPTDT =@v_dt
	group by x.comp_code,x.unit_code,x.branch_code
	
	--select * from #cir_branch_bill_dn_summary
end

////////////////////////////////////////////////////next



create FUNCTION [dbo].[cir_accounts_cir_branch_opbal]
(
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@ppubl                                    VARCHAR(20) ,
	@pagcd                                    VARCHAR(20) ,
	@pdpcd                                    VARCHAR(20) ,
	@popdate                                  DATETIME ,
	@pactype                                  VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) , -- for branch
	@pextra2                                  VARCHAR(4000) 
)
RETURNS FLOAT 
AS 
	BEGIN
		
		DECLARE @v_opbal                                  FLOAT                           
		SET @v_opbal = 0 
		DECLARE @v_findt                                  DATETIME 
		
		SET @v_findt  = @popdate 
		IF @pactype = 'SC' 
		BEGIN 
			SELECT @v_opbal  =  sec_opbal FROM  cir_agomast  WHERE	 comp_code  = @pcomp_code
			AND	(unit_code  = @punit_code OR	@punit_code  is null  OR	@punit_code = '')
			AND	(publ  = @ppubl OR	@ppubl  is null OR	@ppubl = '')
			AND	agcd+dpcd in( SELECt distinct AGCD+dpcd from cir_agmast where COMP_CODE=@pcomp_code 
			and UNIT_CODE=@punit_code and BRANCH_CODE=@pextra1 )			
			AND	for_month  = @v_findt

            IF(@@ROWCOUNT = 0)
            BEGIN
               SET @v_opbal  = 0
            END			
		END
		ELSE
		BEGIN 
			SELECT @v_opbal  =  opbal FROM  cir_agomast  WHERE	 comp_code  = @pcomp_code
			AND	(unit_code  = @punit_code  OR	@punit_code  is null OR	@punit_code = '')
			AND	(publ  = @ppubl OR	@ppubl  is null OR	@ppubl = '')
			AND	agcd+dpcd in( SELECt distinct AGCD+dpcd from cir_agmast where COMP_CODE=@pcomp_code 
			and UNIT_CODE=@punit_code and BRANCH_CODE=@pextra1 )
			AND	for_month  = @v_findt

            IF(@@ROWCOUNT = 0)
            BEGIN
               SET @v_opbal  = 0
            END			
		END
		
		return @v_opbal

	END



////////////////////////////////////////////////end//////////////////////////////////////////////////////////////

///////////////////////////////////for brach unsold entry/////////////////////////



ALTER TABLE CIR_UNSOLD_HDR_DIS ADD FORM_NO numeric(15, 0) NULL

//////////////////////////////////////////////next          


                            
                                      
ALTER procedure [dbo].[cir_rep_unsold_supply_cir_rep_unsold_challan]
     @pcompcode 		as varchar(20),
     @punitcode 		as varchar(20),
     @pdoctype			as varchar(20),
     @pagcode			as varchar(20),
     @pagsubcode		as varchar(20),
     @pfrom_recdate 	as datetime,
     @ptill_recdate     as datetime,
     @precptno          as varchar(20),
     @papproved_flag    as varchar(20),
     @pdateformat       as varchar(20),
     @pextra1           as varchar(2000),
     @pextra2           as varchar(2000)
  As
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
    d.doctype=h.doctype and d.doctype=isnull(@pdoctype,d.doctype) and d.recptdt=h.recptdt and d.recptdt between @pfrom_recdate and @ptill_recdate and 
    d.recptno=h.recptno and d.recptno =isnull(@precptno,d.recptno) and 
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
    d.doctype=h.doctype and d.doctype=isnull(@pdoctype,d.doctype) and d.recptdt=h.recptdt and d.recptdt between @pfrom_recdate and @ptill_recdate and 
    d.recptno=h.recptno and d.recptno =isnull(@precptno,d.recptno) and 
    d.publ=e.publ and d.edtn=e.edtn and (@pextra2!='D' or @pextra2='' or @pextra2 is null)
    group by d.comp_code,d.unit_code,d.agcd,d.dpcd ,m.ag_name,d.recptdt,d.recptno ,d.publ,d.edtn,
    d.copy_rate,e.main_edtn,d.branch_code,e.edtn_name,d.SUPDATE,h.FORM_NO
    order by comp_code,unit_code,recptdt,recptno,publ_name,main_edtnname,edtn_name
    
  End






////////////////////////////////////////////next



ALTER PROCEDURE [dbo].[cir_unsold_credit_note_cir_unsold_supply_p]
	@pcomp_code			as varchar(40),
	@punit_code			as varchar(40),
	@ppubl_code			as varchar(40),
	@pedtn_code			as varchar(40),
	@psup_fromdate		as datetime,
	@psup_todate        as datetime,
	@pagcd_code			as varchar(20),
	@pdpcd_code			as varchar(20),
	@pdateformat        as varchar(20),
	@preceiptdt         as datetime,
	@pextra1            as varchar(20),--it is use for datewise or ratewise
	@pextra2            as varchar(20),
	@pextra3            as varchar(20),--unsold after bill must(y/n)
	@pextra4            as varchar(20),--from date like sup date and next date is bill date(y/n)
	@pextra5            as varchar(20)
	
As
Begin
	if upper(@pextra2)='D' Begin
	PRINT 'A'
 
		select z.comp_code AS "COMP_CODE",z.unit_code AS "UNIT_CODE",z.publ AS "PUBL",z.publ_name AS "PUBL_NAME",z.edtn AS "EDTN" , z.edtn_name AS "EDTN_NAME",
		z.supply_date AS "SUPPLY_DATE", z.supply_date AS "SUPPLY_DATEMON",z.copy_rate AS "COPY_RATE",z.comm_fix_auto_spl AS "COMM_FIX_AUTO_SPL" ,z.comm_code AS "COMM_CODE",z.waste_rate AS "WASTE_RATE",
        substring(z.comm_rate,1,1) AS "COMM_CATEG_TYPE",substring(z.comm_rate,2,len(z.comm_rate)-1) AS "COMM_RATE",z.supply_copy AS "SUPPLY_COPY",z.rate_supply AS "RATE_SUPPLY", 
        z.RETURNABLE as "RETURNABLE",z.per_copy_weight PER_COPY_WEIGHT 
        ,z.RETURNABLEper
            as "RETURNABLEper" from--P30,C0.5
        (select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,p.publ_name publ_name,
        d.edtn edtn,edition_nick edtn_name,d.supdate supply_date,
        d.sup_rate copy_rate,d.comm_fix_auto_spl comm_fix_auto_spl,d.comm_code comm_code,
		dbo.cir_get_waste_rate_catg(d.comp_code,d.unit_code,d.edtn,supdate,''''+@pdateformat+'''',d.waste_catg_code,null,null) waste_rate,
        dbo.cir_get_commission(d.comp_code,d.unit_code,d.publ,d.edtn,d.comm_fix_auto_spl ,d.comm_code,d.supdate,''''+@pdateformat+'''',sum(d.sup_copy),'','') comm_rate,
		'P' comm_catg_type, sum(d.sup_copy) supply_copy,sum(d.sup_copy) rate_supply,
		d.per_copy_weight per_copy_weight,d.waste_catg_code waste_catg_code
		,dbo.cir_get_unsold_returnable(d.comp_code,d.publ,sum(d.sup_copy),'A01',@pagcd_code,@pdpcd_code,'Q',d.edtn,'')  as "RETURNABLE" 
		,dbo.cir_get_unsold_returnable(d.comp_code,d.publ,sum(d.sup_copy),'A01',@pagcd_code,@pdpcd_code,'P',d.edtn,'')   as "RETURNABLEper"
        from cir_dbksup_dis d,cir_publ_mast p,cir_edtn_mast e
        where d.comp_code=@pcomp_code and d.comp_code=p.comp_code and d.comp_code=e.comp_code and
              d.unit_code=@punit_code and d.publ=p.publ and d.publ=e.publ and
              (d.publ=@ppubl_code or @ppubl_code is null or @ppubl_code='') and
              d.edtn=e.edtn and (d.edtn = @pedtn_code or @pedtn_code is null or @pedtn_code='') and
            d.supdate between @psup_fromdate and @psup_todate and
            d.billagcd=@pagcd_code and d.billdpcd=@pdpcd_code and upper(isnull(@pextra1,'D'))='D'
            group by d.comp_code,d.unit_code,d.publ,p.publ_name,e.edition_nick,d.edtn,d.supdate,
            d.sup_rate,d.comm_fix_auto_spl,d.comm_code,d.per_copy_weight,d.waste_catg_code)z
     union all
        select distinct z.comp_code AS "COMP_CODE",z.unit_code AS "UNIT_CODE",z.publ AS "PUBL",z.publ_name AS "PUBL_NAME",z.edtn AS "EDTN",z.edtn_name AS "EDTN_NAME",
		MAX(z.supply_date) AS "SUPPLY_DATE",dbo.GetLastDayOfMonth(z.supply_date) AS "SUPPLY_DATEMON",
        z.copy_rate AS "COPY_RATE",z.comm_fix_auto_spl AS "COMM_FIX_AUTO_SPL",z.comm_code AS "COMM_CODE",z.waste_rate AS "WASTE_RATE",
        z.comm_catg_type AS "COMM_CATEG_TYPE",z.comm_rate AS "COMM_RATE",sum(z.supply_copy) AS "SUPPLY_COPY",sum(z.supply_copy) rate_supply,
        dbo.cir_get_unsold_returnable(z.comp_code,z.publ,sum(z.supply_copy),'A01',@pagcd_code,@pdpcd_code,'Q',z.edtn,'')  RETURNABLE,
        max(z.per_copy_weight) PER_COPY_WEIGHT 
        ,dbo.cir_get_unsold_returnable(z.comp_code,z.publ,sum(z.supply_copy),'A01',@pagcd_code,@pdpcd_code,'P',z.edtn,'') as "RETURNABLEper"  
        from (select distinct y.comp_code,y.unit_code,y.publ,y.publ_name,y.edtn,y.edtn_name,y.supply_date,y.copy_rate,y.comm_fix_auto_spl,y.comm_code,y.waste_rate,
        substring(y.comm_rate,1,1) comm_catg_type,substring(y.comm_rate,2,len(y.comm_rate)-1) comm_rate,y.supply_copy,y.rate_supply ,
        y.per_copy_weight per_copy_weight from--P30,C0.5
        (select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,p.publ_name publ_name,
        d.edtn edtn,edition_nick edtn_name,d.supdate supply_date,
        d.sup_rate copy_rate,d.comm_fix_auto_spl comm_fix_auto_spl,d.comm_code comm_code,
		dbo.cir_get_waste_rate_catg(d.comp_code,d.unit_code,d.edtn,d.supdate,''''+@pdateformat+'''',d.waste_catg_code,null,null) waste_rate,
        dbo.cir_get_commission(d.comp_code,d.unit_code,d.publ,d.edtn,d.comm_fix_auto_spl ,d.comm_code,d.supdate,''''+@pdateformat+'''',sum(d.sup_copy),'','') comm_rate,'P' comm_catg_type, 
		sum(d.sup_copy) supply_copy,
        (select sum(u.sup_copy) from cir_dbksup_dis u where u.comp_code=d.comp_code and u.unit_code=d.unit_code and 
        (u.publ=d.publ) and u.edtn=d.edtn and u.supdate between @psup_fromdate and @psup_todate and 
        u.billagcd=@pagcd_code and u.billdpcd=@pdpcd_code and u.sup_rate=d.sup_rate) rate_supply,
        d.per_copy_weight per_copy_weight,d.waste_catg_code waste_catg_code
        from cir_dbksup_dis d,cir_publ_mast p,cir_edtn_mast e
        where d.comp_code=@pcomp_code and d.comp_code=p.comp_code and d.comp_code=e.comp_code and
              d.unit_code=@punit_code and d.publ=p.publ and d.publ=e.publ and
              (d.publ=@ppubl_code or @ppubl_code is null or @ppubl_code='') and
              d.edtn=e.edtn and (d.edtn = @pedtn_code or @pedtn_code is null or @pedtn_code='') and
            d.supdate between @psup_fromdate and @psup_todate and
            d.billagcd=@pagcd_code and d.billdpcd=@pdpcd_code and upper(isnull(@pextra1,'D'))='R'
            group by d.comp_code,d.unit_code,d.publ,p.publ_name,e.edition_nick,d.edtn,d.supdate,d.sup_rate,d.comm_fix_auto_spl,d.comm_code,d.per_copy_weight,d.waste_catg_code)y) z
            group by z.comp_code,z.unit_code,z.publ,z.publ_name,z.edtn,z.edtn_name,dbo.GetLastDayOfMonth(z.supply_date),
                z.copy_rate,z.comm_fix_auto_spl,z.comm_code,z.waste_rate,z.comm_catg_type,z.comm_rate
			order by supply_date,publ_name,edtn
	End
	Else Begin
	PRINT 'B'
            select z.comp_code AS "COMP_CODE",z.unit_code AS "UNIT_CODE",z.publ AS "PUBL",z.publ_name AS "PUBL_NAME",z.edtn AS "EDTN",z.edtn_name AS "EDTN_NAME",
			z.supply_date AS "SUPPLY_DATE",z.supply_date AS "SUPPLY_DATEMON",
            z.copy_rate AS "COPY_RATE",z.comm_fix_auto_spl AS "COMM_FIX_AUTO_SPL",z.comm_code AS "COMM_CODE",z.waste_rate AS "WASTE_RATE",
            substring(z.comm_rate,1,1) AS "COMM_CATEG_TYPE",substring(z.comm_rate,2,len(z.comm_rate)-1) AS "COMM_RATE",z.supply_copy AS "SUPPLY_COPY",z.rate_supply AS "RATE_SUPPLY",
           z.RETURNABLE
            as "RETURNABLE" ,z.per_copy_weight PER_COPY_WEIGHT 
            ,z.RETURNABLEper
            as "RETURNABLEper"  from--P30,C0.5
            (select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,p.publ_name publ_name,
            d.edtn edtn,edition_nick edtn_name,d.supdate supply_date,
            d.sup_rate copy_rate,d.comm_fix_auto_spl comm_fix_auto_spl,d.comm_code comm_code,
			dbo.cir_get_waste_rate_catg(d.comp_code,d.unit_code,d.edtn,supdate,''''+@pdateformat+'''',d.waste_catg_code,null,null) waste_rate,
            dbo.cir_get_commission(d.comp_code,d.unit_code,d.publ,d.edtn,d.comm_fix_auto_spl ,d.comm_code,d.supdate,''''+@pdateformat+'''',sum(d.sup_copy),'','') comm_rate,
			'P' comm_catg_type, sum(d.sup_copy) supply_copy,sum(d.sup_copy) rate_supply,
			d.per_copy_weight per_copy_weight,d.waste_catg_code waste_catg_code,
			dbo.cir_get_unsold_returnable(d.comp_code,d.publ,sum(d.sup_copy),'A01',@pagcd_code,@pdpcd_code,'Q',d.edtn,'')  
            as "RETURNABLE"
            ,dbo.cir_get_unsold_returnable(d.comp_code,d.publ,sum(d.sup_copy),'A01',@pagcd_code,@pdpcd_code,'P',d.edtn,'')   as "RETURNABLEper"
            from cir_dbksup d,cir_publ_mast p,cir_edtn_mast e
            where d.comp_code=@pcomp_code and d.comp_code=p.comp_code and d.comp_code=e.comp_code and
                d.unit_code=@punit_code and d.publ=p.publ and d.publ=e.publ and
                  (d.publ=@ppubl_code or @ppubl_code is null or @ppubl_code='') and
                  d.edtn=e.edtn and (d.edtn = @pedtn_code or @pedtn_code is null or @pedtn_code='') and
                d.supdate between @psup_fromdate and @psup_todate and
                d.billagcd=@pagcd_code and d.billdpcd=@pdpcd_code and upper(isnull(@pextra1,'D'))='D'
                /*new added*/
                 and ( (@pextra3='Y' AND d.comp_code+d.unit_code+d.billagcd+d.billdpcd  in
                (select b.comp_code+b.unit_code+b.agcd+b.dpcd from cir_bill_det b
                where  b.comp_code=@pcomp_code  and b.unit_code=@punit_code and 
                (b.publ=@ppubl_code or @ppubl_code is null or @ppubl_code='') and
                (b.edtn = @pedtn_code or @pedtn_code is null or @pedtn_code='') and
                (case @pextra4 when 'Y' then (b.billdt-1) else b.billdt end )  between @psup_fromdate and @psup_todate and
                b.agcd=@pagcd_code and b.dpcd=@pdpcd_code))
                OR @pextra3='N'
                )
                 
                 /*new added*/
                group by d.comp_code,d.unit_code,d.publ,p.publ_name,e.edition_nick,d.edtn,d.supdate,d.sup_rate,d.comm_fix_auto_spl,d.comm_code,d.per_copy_weight,d.waste_catg_code) z
            union
            select distinct z.comp_code AS "COMP_CODE",z.unit_code AS "UNIT_CODE",z.publ AS "PUBL",z.publ_name AS "PUBL_NAME",z.edtn AS "EDTN",z.edtn_name AS "EDTN_NAME",
			MAX(z.supply_date) AS "SUPPLY_DATE",dbo.GetLastDayOfMonth(z.supply_date) AS "SUPPLY_DATEMON",
            z.copy_rate AS "COPY_RATE",z.comm_fix_auto_spl AS "COMM_FIX_AUTO_SPL",z.comm_code AS "COMM_CODE",z.waste_rate AS "WASTE_RATE",
            z.comm_catg_type AS "COMM_CATEG_TYPE",z.comm_rate AS "COMM_RATE",sum(z.supply_copy) AS "SUPPLY_COPY",sum(z.supply_copy) AS "RATE_SUPPLY" ,
            dbo.cir_get_unsold_returnable(z.comp_code,z.publ,sum(z.supply_copy),'A01',@pagcd_code,@pdpcd_code,'Q',z.edtn,'') 
            as "RETURNABLE",max(z.per_copy_weight) PER_COPY_WEIGHT 
            ,dbo.cir_get_unsold_returnable(z.comp_code,z.publ,sum(z.supply_copy),'A01',@pagcd_code,@pdpcd_code,'P',z.edtn,'') as "RETURNABLEper" from
            (select distinct y.comp_code,y.unit_code,y.publ,y.publ_name,y.edtn,y.edtn_name,y.supply_date,y.copy_rate,y.comm_fix_auto_spl,y.comm_code,y.waste_rate,
            substring(y.comm_rate,1,1) comm_catg_type,substring(y.comm_rate,2,len(y.comm_rate)-1) comm_rate,y.supply_copy,y.rate_supply,
            y.per_copy_weight per_copy_weight from--P30,C0.5
            (select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,p.publ_name publ_name,d.edtn edtn,edition_nick edtn_name,d.supdate supply_date,
            d.sup_rate copy_rate,d.comm_fix_auto_spl comm_fix_auto_spl,d.comm_code comm_code,
			dbo.cir_get_waste_rate_catg(d.comp_code,d.unit_code,d.edtn,d.supdate,''''+@pdateformat+'''',d.waste_catg_code,null,null) waste_rate,
            dbo.cir_get_commission(d.comp_code,d.unit_code,d.publ,d.edtn,d.comm_fix_auto_spl ,d.comm_code,d.supdate,''''+@pdateformat+'''',sum(d.sup_copy),'','') comm_rate,
			'P' comm_catg_type, sum(d.sup_copy) supply_copy,
            (select sum(u.sup_copy) from cir_dbksup u where u.comp_code=d.comp_code and u.unit_code=d.unit_code and 
            (u.publ=d.publ) and u.edtn=d.edtn and u.supdate between @psup_fromdate and @psup_todate and 
            u.billagcd=@pagcd_code and u.billdpcd=@pdpcd_code and u.sup_rate=d.sup_rate) rate_supply,
            d.per_copy_weight per_copy_weight,d.waste_catg_code waste_catg_code
            from cir_dbksup d,cir_publ_mast p,cir_edtn_mast e
            where d.comp_code=@pcomp_code and d.comp_code=p.comp_code and d.comp_code=e.comp_code and
                  d.unit_code=@punit_code and d.publ=p.publ and d.publ=e.publ and
                  (d.publ=@ppubl_code or @ppubl_code is null or @ppubl_code='') and
                  d.edtn=e.edtn and (d.edtn = @pedtn_code or @pedtn_code is null or @pedtn_code='') and
                d.supdate between @psup_fromdate and @psup_todate and
                d.billagcd=@pagcd_code and d.billdpcd=@pdpcd_code and upper(isnull(@pextra1,'D'))='R'
                
                 /*new added*/
                and ( (@pextra3='Y' AND d.comp_code+d.unit_code+d.billagcd+d.billdpcd  in
                (select b.comp_code+b.unit_code+b.agcd+b.dpcd from cir_bill_det b
                where  b.comp_code=@pcomp_code  and b.unit_code=@punit_code and 
                (b.publ=@ppubl_code or @ppubl_code is null or @ppubl_code='') and
                (b.edtn = @pedtn_code or @pedtn_code is null or @pedtn_code='') and
                (case @pextra4 when 'Y' then (b.billdt-1) else b.billdt end )  between @psup_fromdate and @psup_todate and
                b.agcd=@pagcd_code and b.dpcd=@pdpcd_code))
                OR @pextra3='N'
                )
                 /*new added*/
                
                
                group by d.comp_code,d.unit_code,d.publ,p.publ_name,e.edition_nick,d.edtn,d.supdate,d.sup_rate,d.comm_fix_auto_spl,d.comm_code,d.per_copy_weight,d.waste_catg_code) y) z
                group by z.comp_code,z.unit_code,z.publ,z.publ_name,z.edtn,z.edtn_name,dbo.GetLastDayOfMonth(z.supply_date),
                    z.copy_rate,z.comm_fix_auto_spl,z.comm_code,z.waste_rate,z.comm_catg_type,z.comm_rate
                order by supply_date,publ_name,edtn
	End
	
	--  this table for permissable days---------
	print('q')
	print(@pcomp_code)
	print(@ppubl_code)
	print(@pagcd_code)
	print(@pdpcd_code)
	print(@preceiptdt)
	print(@psup_fromdate)

	select top 1 ISNULL(z.output,'OK') as OUTPUT from(	
	select distinct dbo.cir_get_unsold_permissable_days
	(@pcomp_code,isnull(@ppubl_code,d.PUBL),'A01',@pagcd_code,@pdpcd_code,'D',@preceiptdt,@psup_fromdate,d.EDTN,'') as output
	,publ,d.EDTN from cir_dbksup d 
	where d.comp_code=@pcomp_code and
	d.unit_code=@punit_code and
	(d.publ=@ppubl_code or @ppubl_code is null or @ppubl_code='')  
	and (d.edtn = @pedtn_code or @pedtn_code is null or @pedtn_code='') 
	and d.supdate between @psup_fromdate and @psup_todate and
	d.billagcd=@pagcd_code and d.billdpcd=@pdpcd_code
	group by d.PUBL,d.EDTN) z where z.output not like 'OK%'
	

                
End




/////////////////////////////////////////////////end///////////////////////////////////////////////////////

/////////////////////////////////////add by deepika 07/12/2012 for agency Master///////////////



ALTER procedure [dbo].[cir_agmast_exec]
(
@pcomp_code    varchar(200),
@punit  varchar(200),
@pagcd  varchar(200),
@pdpcd  varchar(200),
@pag_name  varchar(200),
@pag_name_oth_lang                  varchar(200),
@pag_type                  varchar(200),
@pag_class                  varchar(200),
@pexecutive_code                  varchar(200),
@psupply_start_dt                  varchar(200),
@paddr1                  varchar(200),
@paddr2                  varchar(200),
@paddr3                  varchar(200),
@pcity_code                  varchar(200),
@pdist_code                  varchar(200),
@pstate_code                  varchar(200),
@pcountry_code                  varchar(200),
@ptehsil_taluka                  varchar(200),
@pstation_code                  varchar(200),
@parea_code                  varchar(200),
@pphone_no1                  varchar(200),
@pphone_no2                  varchar(200),
@pmobile_no1                  varchar(200),
@pmobile_no2                  varchar(200),
@pemail_id                  varchar(200),
@psuspend                  varchar(200),
@psuspend_type                  varchar(200),
@psuspend_date                  varchar(200),
@pto_bill                  varchar(200),
@pbill_agcd                  varchar(200),
@pbill_dpcd                  varchar(200),
@ppaymode                  varchar(200),
@pcredit_days                  varchar(200),
@pprint_label                  varchar(200),
@ppin_packet                  varchar(200),
@ppin_agcd                  varchar(200),
@ppin_dpcd                  varchar(200),
@ppin_open_inside                  varchar(200),
@plbl_ln1                  varchar(200),
@plbl_ln2                  varchar(200),
@plbl_ln3                  varchar(200),
@plbl_ln4                  varchar(200),
@plbl_ln5                  varchar(200),
@plbl_ln6                  varchar(200),
@plbl_ln7                  varchar(200),
@plbl_ln8                  varchar(200),
@plbl_atr1                  varchar(200),
@plbl_atr2                  varchar(200),
@plbl_atr3                  varchar(200),
@plbl_atr4                  varchar(200),
@plbl_atr5                  varchar(200),
@plbl_atr6                  varchar(200),
@plbl_atr7                  varchar(200),
@plbl_atr8                  varchar(200),
@palert_text                  varchar(200),
@pname_on_label                  varchar(200),
@pprint_seq                  varchar(200),
@palert_valid_date                  varchar(200),
@ppin_code                  varchar(200),
@pfax_no                  varchar(200),
@pbranch_code                  varchar(200),
@punsold_valid_flag                  varchar(200),
@psecurity_per                  varchar(200),
@psec_amt_limt                  varchar(200),
@psupply_stop_flag                  varchar(200),
@psupply_stop_per                  varchar(200),
@pabc_citycode                  varchar(200),
@psupply_subagency                  varchar(200),
@pageing_type                  varchar(200),
@plabel_type                  varchar(200),
@pbill_remark                  varchar(200),
@ph_addr1                  varchar(200),
@ph_addr2                  varchar(200),
@ph_addr3                  varchar(200),
@ph_city_code                  varchar(200),
@ph_dist_code                  varchar(200),
@ph_state_code                  varchar(200),
@ph_country_code                  varchar(200),
@ph_tehsil_taluka                  varchar(200),
@ph_pin_code                  varchar(200),
@ph_phone_no1                  varchar(200),
@ph_phone_no2                  varchar(200),
@ph_mobile_no1                  varchar(200),
@ph_mobile_no2                  varchar(200),
@ph_email_id                  varchar(200),
@psup_branch_code                  varchar(200),
@psup_state_code                  varchar(200),
@pfreeze_flag                  varchar(200),
@proc_no                  varchar(200),
@paccount_agcd                  varchar(200),
@paccount_dpcd                  varchar(200),
@ppan_no                  varchar(200),
@ptan_no                  varchar(200),
@pser_tax_no                  varchar(200),
@pclose_agency_reason                  varchar(200),
@pold_agency    varchar(200),
@psap_id    varchar(200),
@pfrom_booklet    varchar(200),
@pto_booklet    varchar(200),
@pdatapost    varchar(200),
@pagreementexpiry    varchar(200),
@pctos_status    varchar(200),
@pdateformat    varchar(200)
)

as
begin

DECLARE @v_supply_start_dt   DATETIME 
DECLARE @v_suspend_date      DATETIME
declare @v_alert_valid_date datetime
declare @v_agreement_expiry datetime
if(@psupply_start_dt is null or @psupply_start_dt='')begin
SET @v_supply_start_dt =null
end
else begin
SET @v_supply_start_dt  = DBO.CONVERT_USER_DATE('/', @psupply_start_dt,@pdateformat)
end

if(@psuspend_date is null or @psuspend_date='')begin
SET @v_supply_start_dt =null
end
else begin
SET @v_supply_start_dt  = DBO.CONVERT_USER_DATE('/', @psuspend_date,@pdateformat)
end

if(@palert_valid_date is null or @palert_valid_date='')begin
SET @v_alert_valid_date =null
end
else begin
SET @v_alert_valid_date  = DBO.CONVERT_USER_DATE('/', @palert_valid_date,@pdateformat)
end

if(@pagreementexpiry is null or @pagreementexpiry='')begin
SET @v_agreement_expiry =null
end
else begin
SET @v_agreement_expiry  = DBO.CONVERT_USER_DATE('/', @pagreementexpiry,@pdateformat)
end

print(@v_supply_start_dt)
print(@v_supply_start_dt)
print(@v_alert_valid_date)
select * from cir_agmast where
(comp_code=@pcomp_code   or @pcomp_code is null or @pcomp_code='')
and (unit=@punit   or @punit is null or @punit='')
and (agcd =@pagcd or @pagcd is null or @pagcd='' )
and (dpcd= @pdpcd or @pdpcd is null or @pdpcd=''  )
and (ag_name=@pag_name or @pag_name is null or @pag_name=''  )
and (ag_name_oth_lang=@pag_name_oth_lang or @pag_name_oth_lang is null or @pag_name_oth_lang=''  )
and (ag_type=@pag_type or @pag_type is null or @pag_type='' )
and (ag_class=@pag_class or @pag_class is null or @pag_class='' )
and (executive_code=@pexecutive_code or @pexecutive_code is null or @pexecutive_code='' )
and (supply_start_dt=@v_supply_start_dt or @v_supply_start_dt is null or @v_supply_start_dt=''                  )
and (addr1=@paddr1 or @paddr1 is null or @paddr1=''                  )
and (addr2=@paddr2   or @paddr2 is null or @paddr2=''                )
and (addr3=@paddr3   or @paddr3 is null or @paddr3=''                )
and (city_code=@pcity_code or @pcity_code is null or @pcity_code =''                 )
and (dist_code=@pdist_code  or @pdist_code is null or @pdist_code=''                )
and (state_code=@pstate_code   or @pstate_code is null or @pstate_code=''               )
and (country_code=@pcountry_code   or @pcountry_code is null or @pcountry_code=''               )
and (tehsil_taluka=@ptehsil_taluka or @ptehsil_taluka is null or @ptehsil_taluka=''                 )
and (station_code=@pstation_code  or @pstation_code is null or @pstation_code=''                )
and (area_code=@parea_code or @parea_code is null or @parea_code=''                 )
and (phone_no1=@pphone_no1   or @pphone_no1 is null or @pphone_no1=''               )
and (phone_no2=@pphone_no2  or @pphone_no2 is null or @pphone_no2=''                )
and (mobile_no1=@pmobile_no1   or @pmobile_no1 is null or @pmobile_no1=''               )
and (mobile_no2=@pmobile_no2     or @pmobile_no2 is null or @pmobile_no2=''             )
and (email_id=@pemail_id    or @pemail_id is null or @pemail_id=''              )
and (suspend=@psuspend    or @psuspend is null or @psuspend=''              )
and (suspend_type=@psuspend_type  or @psuspend_type is null or @psuspend_type=''                 )
and (suspend_date=@v_supply_start_dt  or @v_supply_start_dt is null or @v_supply_start_dt=''                )
and (to_bill=@pto_bill   or @pto_bill is null or @pto_bill=''               )
and (bill_agcd=@pbill_agcd or @pbill_agcd is null or @pbill_agcd=''                  )
and (bill_dpcd=@pbill_dpcd or @pbill_dpcd is null or @pbill_dpcd=''                  )
and (paymode =@ppaymode or @ppaymode is null or @ppaymode=''                  )
and (credit_days=@pcredit_days or @pcredit_days is null or @pcredit_days=''                  )
and (print_label=@pprint_label or @pprint_label is null or @pprint_label=''                  )
and (pin_packet=@ppin_packet or @ppin_packet is null or @ppin_packet=''                  )
and (pin_agcd=@ppin_agcd or @ppin_agcd is null or @ppin_agcd=''                  )
and (pin_dpcd=@ppin_dpcd or @ppin_dpcd is null or @ppin_dpcd=''                  )
and (pin_open_inside=@ppin_open_inside or @ppin_open_inside is null or @ppin_open_inside=''                  )
and (lbl_ln1=@plbl_ln1 or @plbl_ln1 is null or @plbl_ln1=''                  )
and (lbl_ln2=@plbl_ln2 or @plbl_ln2 is null or @plbl_ln2=''                  )
and (lbl_ln3=@plbl_ln3 or @plbl_ln3 is null or @plbl_ln3=''                  )
and (lbl_ln4=@plbl_ln4 or @plbl_ln4 is null or @plbl_ln4=''                  )
and (lbl_ln5=@plbl_ln5 or @plbl_ln5 is null or @plbl_ln5=''                  )
and (lbl_ln6=@plbl_ln6 or @plbl_ln6 is null or @plbl_ln6=''                  )
and (lbl_ln7=@plbl_ln7 or @plbl_ln7 is null or @plbl_ln7=''                  )
and (lbl_ln8=@plbl_ln8 or @plbl_ln8 is null or @plbl_ln8=''                  )
and (lbl_atr1=@plbl_atr1 or @plbl_atr1 is null or @plbl_atr1=''                  )
and (lbl_atr2=@plbl_atr2             or @plbl_atr2 is null or @plbl_atr2=''      )
and (lbl_atr3=@plbl_atr3            or @plbl_atr3 is null or @plbl_atr3=''       )
and (lbl_atr4=@plbl_atr4              or @plbl_atr4 is null or @plbl_atr4=''     )
and (lbl_atr5=@plbl_atr5                     or @plbl_atr5 is null or @plbl_atr5='' )
and (lbl_atr6=@plbl_atr6                     or @plbl_atr6 is null or @plbl_atr6='' )
and (lbl_atr7=@plbl_atr7                     or @plbl_atr7 is null or @plbl_atr7='' )
and (lbl_atr8=@plbl_atr8                     or @plbl_atr8 is null or @plbl_atr8='' )
and (alert_text=@palert_text                     or @palert_text is null or @palert_text='' )
and (name_on_label=@pname_on_label                     or @pname_on_label is null or @pname_on_label='' )
and (print_seq=@pprint_seq                     or @pprint_seq is null or @pprint_seq='' )
and (alert_valid_date=@v_alert_valid_date                     or @v_alert_valid_date is null or @v_alert_valid_date='' )
and (pin_code=@ppin_code                     or @ppin_code is null or @ppin_code='' )
and (fax_no=@pfax_no                     or @pfax_no is null or @pfax_no='' )
and (branch_code=@pbranch_code                     or @pbranch_code is null or @pbranch_code='' )
and (unsold_valid_flag=@punsold_valid_flag                     or @punsold_valid_flag is null or @punsold_valid_flag='' )
and (security_per=@psecurity_per                     or @psecurity_per is null or @psecurity_per='' )
and (sec_amt_limt=@psec_amt_limt                     or @psec_amt_limt is null or @psec_amt_limt='' )
and (supply_stop_flag=@psupply_stop_flag                     or @psupply_stop_flag is null or @psupply_stop_flag='' )
and (supply_stop_per=@psupply_stop_per                     or @psupply_stop_per is null or @psupply_stop_per='' )
and (abc_citycode=@pabc_citycode                     or @pabc_citycode is null or @pabc_citycode='' )
and (supply_subagency=@psupply_subagency                     or @psupply_subagency is null or @psupply_subagency='' )
and (ageing_type=@pageing_type                     or @pageing_type is null or @pageing_type='' )
and (label_type=@plabel_type                     or @plabel_type is null or @plabel_type='' )
and (bill_remark=@pbill_remark                     or @pbill_remark is null or @pbill_remark='' )
and (h_addr1 =@ph_addr1                     or @ph_addr1 is null or @ph_addr1='' )
and (h_addr2=@ph_addr2                     or @ph_addr2 is null or @ph_addr2='' )
and (h_addr3 =@ph_addr3                     or @ph_addr3 is null or @ph_addr3='' )
and (h_city_code=@ph_city_code                     or @ph_city_code is null or @ph_city_code='' )
and (h_dist_code=@ph_dist_code                     or @ph_dist_code is null or @ph_dist_code='' )
and (h_state_code=@ph_state_code                     or @ph_state_code is null or @ph_state_code='' )
and (h_country_code=@ph_country_code                     or @ph_country_code is null or @ph_country_code='' )
and (h_tehsil_taluka=@ph_tehsil_taluka                     or @ph_tehsil_taluka is null or @ph_tehsil_taluka='' )
and (h_pin_code=@ph_pin_code                     or @ph_pin_code is null or @ph_pin_code='' )
and (h_phone_no1=@ph_phone_no1                     or @ph_phone_no1 is null or @ph_phone_no1='' )
and (h_phone_no2=@ph_phone_no2                     or @ph_phone_no2 is null or @ph_phone_no2='' )
and (h_mobile_no1=@ph_mobile_no1                     or @ph_mobile_no1 is null or @ph_mobile_no1='' )
and (h_mobile_no2=@ph_mobile_no2                     or @ph_mobile_no2 is null or @ph_mobile_no2='' )
and (h_email_id=@ph_email_id                     or @ph_email_id is null or @ph_email_id='' )
and (sup_branch_code=@psup_branch_code                     or @psup_branch_code is null or @psup_branch_code='' )
and (sup_state_code=@psup_state_code                     or @psup_state_code is null or @psup_state_code='' )
and (freeze_flag=@pfreeze_flag                     or @pfreeze_flag is null or @pfreeze_flag='' )
and (roc_no=@proc_no                     or @proc_no is null or @proc_no='' )
and (account_agcd=@paccount_agcd                     or @paccount_agcd is null or @paccount_agcd='' )
and (account_dpcd=@paccount_dpcd                     or @paccount_dpcd is null or @paccount_dpcd='' )
and (pan_no=@ppan_no                     or @ppan_no is null or @ppan_no='' )
and (tan_no=@ptan_no                     or @ptan_no is null or @ptan_no='' )
and (ser_tax_no=@pser_tax_no                     or @pser_tax_no is null or @pser_tax_no='' )
and (close_agency_reason=@pclose_agency_reason                     or @pclose_agency_reason is null or @pclose_agency_reason='' )
and (old_agency=@pold_agency       or @pold_agency is null or @pold_agency='' )
and (sap_id=@psap_id or @psap_id is null or @psap_id='')

and (from_booklet=@pfrom_booklet       or @pfrom_booklet is null or @pfrom_booklet='' )
and (to_booklet=@pto_booklet or @pto_booklet is null or @pto_booklet='')
and (data_post=@pdatapost or @pdatapost is null or @pdatapost='')
and (AGREEMENT_EXPIRY=@v_agreement_expiry or @v_agreement_expiry is null or @v_agreement_expiry='' )
and (CTOS_STATUS=@pctos_status or @pctos_status is null or @pctos_status='')

end




///////////////////////////////////next

alter table cir_agmast add AGREEMENT_EXPIRY datetime NULL
alter table cir_agmast add CTOS_STATUS varchar(1) NULL


/////////////////////////////////////////////////////////end///////////////////////////////////////


/***by sushil sir 18 dec**/






ALTER PROCEDURE [dbo].[CIR_PRINTERS_LISTING] (@PCOMP_CODE      VARCHAR(50),
                                       @PUNIT_CODE     VARCHAR(50),
                                       @PPRINTER_AGCD  VARCHAR(50),
                                       @PPRINTER_DPCD  VARCHAR(50),
                                       @PFR_ISSUE_DATE DATETIME,
                                       @PTO_ISSUE_DATE DATETIME,
                                       @PPUBL_CODE     VARCHAR(50),
									   @PEDTN_CODE     VARCHAR(50),
                                       @PDATEFORMAT    VARCHAR(50),
                                       @PEXTRA1        VARCHAR(50),
                                       @PEXTRA2        VARCHAR(50),
                                       @PEXTRA3        VARCHAR(50),
                                       @PEXTRA4        VARCHAR(50),
                                       @PEXTRA5        VARCHAR(50),
                                       @PEXTRA6        VARCHAR(50),
                                       @PEXTRA7        VARCHAR(50),
                                       @PEXTRA8        VARCHAR(50),
                                       @PEXTRA9        VARCHAR(50),
                                       @PEXTRA10       VARCHAR(50)) AS
BEGIN
  DECLARE @vvar         VARCHAR(4000);
  DECLARE @vvar_1       VARCHAR(4000);
  DECLARE @vQUERY       VARCHAR(4000);
  DECLARE @rec_TRN_type VARCHAR(4000);
  DECLARE @rec_REASON   VARCHAR(4000);
  DECLARE @VFR_ISSUE_DATE   datetime;
  DECLARE @VTO_ISSUE_DATE   datetime;
  


  SET @VFR_ISSUE_DATE =  @PFR_ISSUE_DATE;
  SET @VTO_ISSUE_DATE =  @PTO_ISSUE_DATE;
  
  DECLARE cur_TRN_type CURSOR LOCAL FOR
     select ' CASE WHEN TRN_TYPE='+RES_ID+' THEN SUPPLY ELSE 0 END "'+REASON+'",','SUM("'+REASON+'") AS "'+REASON+'",'
                               from CRM_MISC_MASTER_TAB 
                               where COMPCODE = @PCOMP_CODE
                                 AND RTYPE    = 'PTT' 
                                ORDER BY RES_ID;
                                
     Begin
		open cur_TRN_type
       		fetch cur_TRN_type into @rec_TRN_type,@rec_REASON
       		while(@@FETCH_STATUS = 0) BEGIN
       		 PRINT '@rec_TRN_type'
       		 PRINT @@FETCH_STATUS
       		 PRINT @rec_TRN_type
       		 	
         		  set @vvar   = ISNULL(@vvar,'')+ISNULL(@rec_TRN_type,'')
         		  set @vvar_1 = ISNULL(@vvar_1,'')+ISNULL(@rec_REASON,'')
		     fetch cur_TRN_type into @rec_TRN_type,@rec_REASON 
		     END  
		close cur_TRN_type

		SET @vvar   = substring(@vvar,1,len(@vvar)-1)
		SET @vvar_1 = substring(@vvar_1,1,len(@vvar_1)-1) 
PRINT '@vvar-- IN' 
  PRINT @vvar
		DEALLOCATE cur_TRN_type
     End                                 
 
  PRINT '@vvar' 
  PRINT @vvar
  print @PFR_ISSUE_DATE
  print @PTO_ISSUE_DATE
  
  SET @vQUERY = 'SELECT COMP_CODE,(SELECT COMP_NAME FROM COMP_MST WHERE COMP_CODE = TRN.COMP_CODE) AS COMP_NAME,
                        UNIT_CODE,(SELECT PUB_CENT_NAME FROM PUB_CENT_MAST WHERE COMP_CODE = TRN.COMP_CODE AND PUB_CENT_CODE = TRN.UNIT_CODE) PRINTING_CENTER_NAME,
                        PRINTER_AGCD, PRINTER_DPCD, DBO.CIR_GET_AGENCY(TRN.COMP_CODE,TRN.UNIT_CODE,TRN.PRINTER_AGCD,TRN.PRINTER_DPCD) AGENCY_NAME,
                        PUBL_CODE, dbo.cir_get_publ_name(trn.comp_code,trn.publ_code) PUBL_NAME,
						EDTN_CODE, dbo.cir_get_edtn_name(trn.comp_code, trn.edtn_code) as EDTN_CODE,
                         ISSUE_DATE,'+@vvar_1+'
                         FROM (SELECT COMP_CODE,UNIT_CODE,PRINTER_AGCD,PRINTER_DPCD,PUBL_CODE, EDTN_CODE,
										ISSUE_DATE,'+ISNULL(@vvar,'')+' FROM CIR_PRINTERS_SUPPLY 
									WHERE  COMP_CODE    = '''+@PCOMP_CODE+'''
									  AND  UNIT_CODE    = '''+@PUNIT_CODE+'''
									  AND  PRINTER_AGCD = '''+@PPRINTER_AGCD+'''
									  AND  PRINTER_DPCD = '''+@PPRINTER_DPCD+'''
									  AND  PUBL_CODE    = '''+@PPUBL_CODE+'''
									  AND  ((EDTN_CODE   = '''+@PEDTN_CODE+''') OR ('''+@PEDTN_CODE+''' IS NULL) OR ('''+@PEDTN_CODE+'''=''''))
									  AND  ISSUE_DATE BETWEEN '''+convert(varchar(10),@VFR_ISSUE_DATE,101)+''' AND '''+convert(varchar(10),@VTO_ISSUE_DATE,101)+''') TRN
									  GROUP BY COMP_CODE,UNIT_CODE,PRINTER_AGCD,PRINTER_DPCD,PUBL_CODE,
										 ISSUE_DATE, EDTN_CODE'
  PRINT '(@VQUERY)'
  PRINT (@VQUERY)
  exec (@VQUERY)
END   

**************************************      



//***********************************add by deepika 20-dec-2012 sent by amit sir



USE
[UMERP]

GO

/****** Object: StoredProcedure [dbo].[cir_pending_installment] Script Date: 12/20/2012 15:15:21 ******/

SET
ANSI_NULLS ON

GO

SET
QUOTED_IDENTIFIER ON

GO

ALTER
PROCEDURE [dbo].[cir_pending_installment]

@pcompcode
as VARCHAR(20),

@punitcode
as VARCHAR(20),

@pagcd
as VARCHAR(20),

@pdpcd
as VARCHAR(20),

@pachd
as VARCHAR(20),

@pdateformat
as VARCHAR(20),

@pextra
as VARCHAR(20),

@pextra1
as VARCHAR(200),

@pextra2
as VARCHAR(200),

@pextra3
as VARCHAR(200),

@pextra4
as VARCHAR(200),

@pextra5
as VARCHAR(200),

@pextra6
as VARCHAR(200),

@pextra7
as VARCHAR(200),

@pextra8
as VARCHAR(200),

@pextra9
as VARCHAR(200),

@pextra10
as VARCHAR(200)

AS

declare @v_dt datetime

declare @v_expdt datetime

BEGIN

select m.comp_code as"COMP_CODE",m.unit_code as "UNIT_CODE",m.inst_code as "INST_CODE",m.inst_date as "INST_DATE",

m
.agcd as "AGCD",m.dpcd as "DPCD",a.ag_name as "AG_NAME",dbo.cir_get_drop_point_name(m.comp_code,m.unit_code,a.station_code,1) as "DROP_POINT_NAME",

dbo
.cir_get_city(m.comp_code,a.city_code) as "CITY_NAME"

,d.inst_duedt as "INST_DUEDT",d.inst_amt as "INST_AMT"

, d.INST_CHQNO as "INST_CHQNO",d.INST_NO as "INST_NO",

case d.INST_CHQDT when '1900-01-01 00:00:00.000' then null else d.INST_CHQDT end as "INST_CHQDT",d.BANK_CODE as "BANK_CODE",

(select sum(inst_due_amt)from cir_inst_bill_det

where comp_code=m.comp_code and inst_code=m.inst_code and agcd=m.agcd and dpcd=m.dpcd and

inst_billdt
=d.inst_duedt and INST_NO=d.INST_NO) as "INST_DUE_AMT"

from cir_installment_mast m,cir_installment_det d,cir_agmast a

where m.comp_code=d.comp_code and m.comp_code=a.comp_code and m.comp_code=@pcompcode and

m
.unit_code=d.unit_code and m.unit_code=a.unit and m.unit_code=isnull(@punitcode,m.unit_code) and

m
.agcd=d.agcd and m.agcd=a.agcd and m.agcd=isnull(@pagcd,m.agcd) and m.dpcd=d.dpcd and m.dpcd=a.dpcd and m.dpcd=isnull(@pdpcd,m.dpcd) and

m
.inst_code=d.inst_code and m.achd=@pachd

order by comp_code,unit_code,ag_name,inst_duedt

END

/////////////////////////////////////////next



ALTER
PROCEDURE [dbo].[Cir_Gen_Code_edtn_mast_p]

@pcompcode
VARCHAR(20) ,

@ppubl_code
VARCHAR(20) ,

@pdateformat
VARCHAR(20) ,

@pextra1
VARCHAR(4000) ,

@pextra2
VARCHAR(4000)

AS

DECLARE @vno NUMERIC(5)

DECLARE @vedtn_code VARCHAR(15)

DECLARE @v_sess_id NUMERIC(20)

set @v_sess_id=(SELECT top 1 session_id FROM sys.dm_exec_requests where sql_handle is not null);

SELECT @vno = MAX(SUBSTRING(edtn, 1, LEN(edtn))) + 1

FROM cir_edtn_mast

WHERE comp_code = @pcompcode /*and publ=ppubl_code*/

IF ISNULL(@vno, 0)= 0

BEGIN

SET @vedtn_code = '0001'

END

ELSE

BEGIN

SET @vedtn_code = dbo.fnPadLeft('0',3,@vno)

END

SELECT @vedtn_code as VAR_CODE 



/////////////////////////////////////////////////////end/////////////////////////////////////////////////   


////////////////////////////////add by deepika sent by Gaurav sir 25/12/2012///////////////////////




                                                                     
                                                                     
                                                                     
                                             
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








///////////////////////////////////////////////////////end////////////////////////////////////                           