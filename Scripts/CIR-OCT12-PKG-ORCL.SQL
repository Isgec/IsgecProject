********************8-10-2012 updated by rikkee(permission master orcle procedure)**********************
CREATE OR REPLACE PROCEDURE HT18JULY.Cir_insert_group_permission
(

      pcompcode  varchar2,
    pdateformat  varchar2,
    puserid   varchar2,    
    psel_comp   varchar2,
    punitcode   varchar2,
    pbranch   varchar2,
    psel_userid   varchar2,
    psel_role   varchar2,
    pmoduleid   varchar2,
    pformid   varchar2,
    pformname   varchar2,
    puserright   varchar2,
    pdays   varchar2,
    pextra1   varchar2,
    pextra2   varchar2
     )

 is
   
    v1_userid  varchar2(20);
    v1_username  varchar2(2000);
    v_cnt  int;
     cursor c1  is
       select "userid" USERID,"username" from login where com_code=pcompcode 
       and roleid=psel_role and ("userid"=nvl(psel_userid,"userid"));
     rec c1%rowtype;
     begin
    OPEN c1 ;
      loop
        fetch c1 into rec;
      exit when c1%notfound;
        select count(*) into v_cnt from MODULE_USER_RIGHTS where 
            COMP_CODE=pcompcode and UNIT_CODE=punitcode and USER_CODE=rec.USERID and FORM_ID=pformid;
             if(v_cnt>0)
            then
                update MODULE_USER_RIGHTS set 
                                            MODULE_ID=pmoduleid,
                                            FORMNAME=pformname,
                                            USER_RIGHT=puserright,
                                            CREATION_USERID=puserid,
                                            CREATION_DATE=sysdate,
                                            BACK_DAYS=pdays
                where COMP_CODE=pcompcode and UNIT_CODE=punitcode and USER_CODE=rec.USERID and FORM_ID=pformid;
            
            else
            
                INSERT INTO MODULE_USER_RIGHTS (COMP_CODE,UNIT_CODE,USER_CODE,MODULE_ID,FORM_ID,FORMNAME
                            ,USER_RIGHT,CREATION_USERID,CREATION_DATE,BACK_DAYS)
                VALUES    (pcompcode,punitcode,rec.USERID,pmoduleid,pformid,pformname,puserright,puserid,sysdate,pdays);
            end if;
            commit;
            
    end loop;
    close c1;
    
    
   
            
            
          
   
end;
/
**************************** end************************************************************

*****************************add by Deepika 09/11/2012 sent by Naman **********************


                                                                     
                                                                     
                                                                     
                                             

alter table CIR_UNSOLD_APR_PERMISSION add  AG_TYPE varchar(20)
alter table CIR_UNSOLD_APR_PERMISSION add  AG_CLASS varchar(20)



CREATE OR REPLACE FUNCTION cir_get_agtype_name(pcomp_code in varchar2,
pagencytypecode in varchar2) RETURN varchar2 IS
vedtn_name varchar2(500);
BEGIN
   Begin
      select "AGENCY_TYPE_DESC" into vedtn_name from CIR_AGENCY_TYP_MAST where "COMP_CODE"=pcomp_code 
      and 
      "AGENCY_TYPE_CODE"=pagencytypecode;
           exception when others then
            vedtn_name:=null;
  End;
    return nvl(vedtn_name,'');
END;
/




create or replace procedure cir_check_agencyform_p
(
pcomp_code in varchar2,
punit_code in varchar2,
pagcd  in varchar2,
pdpcd in varchar2,
pform_no in varchar2,
pextra1 in varchar2,
pextra2 in varchar2,
p_accounts   OUT   cur_type_new1.cursor_type,
p_accounts1   OUT   cur_type_new1.cursor_type

)
as
--exec cir_check_agencyform_p 'ht001','del','N0007','0001','1200','',''
begin

open p_accounts for 
select count(*) as CNT from cir_agmast
where comp_code=pcomp_code
and unit=punit_code
and agcd=pagcd
and dpcd=pdpcd
and (cast(pform_no as numeric(20)) >=from_booklet
and  cast(pform_no as numeric(20)) <=to_booklet);


open p_accounts1 for 
select count(*) as CNT from cir_unsold_hdr
where comp_code=pcomp_code
and unit_code=punit_code
and agcd=pagcd
and dpcd=pdpcd
and cast(pform_no as numeric(20)) =form_no;


end;




CREATE OR REPLACE FUNCTION cir_get_agclass_name(pcomp_code in varchar2,
pagencyclasscode in varchar2) RETURN varchar2 IS
vedtn_name varchar2(500);
BEGIN
   Begin
      select "CLASS_DESC" into vedtn_name from CIR_AGENCY_CLASS_MAST where "COMP_CODE"=pcomp_code 
      and 
      "CLASS_CODE"=pagencyclasscode;
           exception when others then
            vedtn_name:=null;
  End;
    return nvl(vedtn_name,'');
END;
/


****************************************************end************************************************
