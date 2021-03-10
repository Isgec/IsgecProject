
************************ADD BY DEEPIKA 07/01/2013********************

alter table preferrences add CIR_UPDATE_ESTIMATION VARCHAR(1) 
alter table preferrences add CIR_EMAIL_SMS_IN_APPROVAL VARCHAR(1) 

alter table preferrences add CIR_UCN_AUTO_ADJUSTMENT VARCHAR(1)
alter table preferrences add MIN_MAX_VALIDATE_IN_CORRECTION VARCHAR(5) 
alter table preferrences add CIR_UCN_PUB_DATE_WISE VARCHAR(5)
*******************************************************************


************************ADD BY DEEPIKA 05/02/2013********************

alter table CIR_EDTN_MAST add EDTN_FOR_UNIT VARCHAR(10)
alter table preferrences add CIR_UNSOLD_HISTORY VARCHAR(10)