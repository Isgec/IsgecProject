/********************Laxman ************************/
ALTER TABLE CIR_INST_BILL_DET  ADD(DOCTYPE  VARCHAR2(3),RECPTNO  VARCHAR2(20),RECPTDT  DATE)
/********************Laxman ************************/
///////////////////////////////////////////////updated by  Garima

alter table cir_dbksup_dis add (FINAL_SUPPLY_FLAG varchar2(1),UPDATED_BY varchar2(30),UPDATED_DT date)


alter table cir_dbksup add (FINAL_SUPPLY_FLAG varchar2(1),UPDATED_BY varchar2(30),UPDATED_DT date)alter table cir_dbksup_dis add (FINAL_SUPPLY_FLAG varchar2(1),UPDATED_BY varchar2(30),UPDATED_DT date)
////////////////////////update by garima

/***********************Laxman *****************/
alter table cir_unsold_hdr add (ref_doctype  varchar2(8),ref_recptno  varchar2(20) ,ref_recptdt date)
alter table cir_unsold_dtl add (ref_doctype  varchar2(8),ref_recptno  varchar2(20) ,ref_recptdt date)
alter table cir_unsold_hdr_dis add (ref_doctype  varchar2(8),ref_recptno  varchar2(20) ,ref_recptdt date)
alter table cir_unsold_dtl_dis add (ref_doctype  varchar2(8),ref_recptno  varchar2(20) ,ref_recptdt date)
/***********************Laxman *****************/
///////////////////////////garima*******************
alter table cir_inct_process_det_temp add sess_id number (15)

alter table cir_inct_process_det_temp  add exp_type_name varchar2(100)