/********************Laxman ************************/
ALTER TABLE CIR_INST_BILL_DET  ADD DOCTYPE  VARCHAR(3),RECPTNO  VARCHAR(20),RECPTDT  DATETIME

/********************Laxman ************************/

/////////////////////////////////update by garima


alter table cir_dbksup_dis add FINAL_SUPPLY_FLAG varchar(1),UPDATED_BY varchar(30),UPDATED_DT datetime)


alter table cir_dbksup add (FINAL_SUPPLY_FLAG varchar(1),UPDATED_BY varchar(30),UPDATED_DT datetime)

/***********************Laxman *****************/
alter table cir_unsold_hdr add ref_doctype  varchar(8),ref_recptno  varchar(20) ,ref_recptdt datetime
alter table cir_unsold_dtl add ref_doctype  varchar(8),ref_recptno  varchar(20) ,ref_recptdt datetime
alter table cir_unsold_hdr_dis add ref_doctype  varchar(8),ref_recptno  varchar(20) ,ref_recptdt datetime
alter table cir_unsold_dtl_dis add ref_doctype  varchar(8),ref_recptno  varchar(20) ,ref_recptdt datetime
/***********************Laxman *****************/
/*****************************Neha**************************************************/
alter table CIR_INSTALLMENT_MAST alter column pro_type varchar(8)