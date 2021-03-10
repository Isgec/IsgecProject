///////////////////////update by Garima
CREATE OR REPLACE procedure cir_check_duplicacy_late_fee(
    pcompcode       in varchar2,
    punitcode       in varchar2,
    ppublcode       in varchar2,
    pedtncode       in varchar2,
    peffdate        in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    p_accounts    out cur_type_new1.cursor_type)
as
    v_dt date;
begin
    v_dt :=to_date(peffdate,''''||pdateformat||'''');

    open p_accounts for
    select count(*) "REC_COUNT" from cir_late_fee_mast 
    where comp_code=pcompcode and unit_code=punitcode and publ_code=ppublcode and 
    edtn_code=pedtncode and valid_from=v_dt;

 
end cir_check_duplicacy_late_fee;
/


////////////////////////////////////////////////Issue No. 6216 10/01/2012//////////////////////////////////////////////////////////

CREATE OR REPLACE procedure cir_rep_lbl_prn_utusan_p(
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
    p_accounts     OUT Cur_Type_New1.cursor_type)
As
    vlbldt date;
Begin
    vlbldt:=to_date(plbldt,''''||pdateformat||'''');
    
       open p_accounts for
          select cir_lblmast.*,cir_get_mode_name(comp_code,unit_code||route) mode_name,
          SUBSTR(cir_get_name.cir_edtn(comp_code,unit_code,edtn  ,'1',''''||pdateformat||'''','',''),1,30) edtn_name,
          (select distinct reg_no from cir_edtn_mast where comp_code = pcomp_code and edtn=cir_lblmast.edtn_1) AS "REG_NO",
          ((cir_lblmast.lbl_tno*pkt_size)+nvl(supply_1,0)) as "TOTAL_SUPPLY_COPY",(select station_code from cir_agmast where cir_agmast.comp_code=cir_lblmast.comp_code and
          cir_agmast.unit=cir_lblmast.unit_code and cir_agmast.agcd=cir_lblmast.agcd  and cir_agmast.dpcd=cir_lblmast.dpcd) as "STATION_CODE"
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
                   ((dpcd    = pdpcd) or (pdpcd is null));
 
End cir_rep_lbl_prn_utusan_p;
/
CREATE OR REPLACE PACKAGE Cir_Genrate_Code IS
type p_circul_cursor is ref cursor;
PROCEDURE agency_type_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor);

PROCEDURE agency_class_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor);

PROCEDURE suspend_type_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor);

PROCEDURE area_type_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor);

PROCEDURE publ_mast_p(
   pcompcode    in varchar2,
   pdateformat  in varchar2,
   pextra1      in varchar2,
   pextra2      in varchar2,
   ppubl_code   out p_circul_cursor);

PROCEDURE edtn_mast_p (
    pcompcode   in varchar2,
    ppubl_code  in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    pedtn_code  out p_circul_cursor);

PROCEDURE agmast_P (
    pcompcode   in varchar2,
    punitcode   in varchar2,
    pprefix     in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    pag_code    out p_circul_cursor);

PROCEDURE agsubcode_P (
    pcompcode       in varchar2,
    punitcode       in varchar2,
    pagcode         in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    pag_code        out p_circul_cursor);

PROCEDURE areacode_P (
    pcompcode       in varchar2,
    punitcode       in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    parea_code      out p_circul_cursor);

PROCEDURE drop_point_code_P (
    pcompcode           in varchar2,
    punitcode           in varchar2,
    pdateformat         in varchar2,
    pextra1             in varchar2,
    pextra2             in varchar2,
    pdrop_point_code    out p_circul_cursor);

Procedure executive_code_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    pexe_code   out p_circul_cursor);

PROCEDURE routecode_P (
    pcompcode   in varchar2,
    punitcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    prt_code    out p_circul_cursor);

PROCEDURE subroutecode_P (
    pcompcode   in varchar2,
    punitcode   in varchar2,
    prtcode     in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    psubrt_code out p_circul_cursor);

PROCEDURE subsubroutecode_P (
    pcompcode       in varchar2,
    punitcode       in varchar2,
    prtcode         in varchar2,
    psubrtcode      in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    psubsubrt_code  out p_circul_cursor);

PROCEDURE transportercode_P (
    pcompcode   in varchar2,
    pprefix     in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptp_code    out p_circul_cursor);

PROCEDURE districtcode_P (
    pcompcode   in varchar2,
    pstatecode  in varchar2,
    pprefix     in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    pdist_code  out p_circul_cursor);

PROCEDURE comm_catg_p (
    pcompcode   in varchar2,
    pcomm_type  in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor);

PROCEDURE comm_p (
    pcompcode   in varchar2,
    pcomm_type  in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor);

PROCEDURE zone_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor);

PROCEDURE taluka_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor);

PROCEDURE receipt_p (
    pcompcode   in varchar2,
    pbranchcode in varchar2,
    pdoctype    in varchar2,
    precptdt    in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor);

PROCEDURE mode_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor);

PROCEDURE supply_type_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor);

PROCEDURE expenses_type_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor);

PROCEDURE city_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor);

PROCEDURE cir_region_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    preg_code   out p_circul_cursor);

PROCEDURE cir_unsold_receipt_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    preceipt_no out p_circul_cursor);

PROCEDURE cir_surcharge_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    psurch_cd   out p_circul_cursor);

PROCEDURE cir_roleMatser_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    psurch_cd   out p_circul_cursor);

PROCEDURE cir_narr_p (
    pcompcode       in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    pnarr_cd        out p_circul_cursor);

Procedure cir_taxi_code_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptaxi_code  out p_circul_cursor);

PROCEDURE cir_lable_htmlformatid_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    pformat_id  out p_circul_cursor);
PROCEDURE cir_installment_code_p (
    pcompcode   in varchar2,
    punitcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    pcode       out p_circul_cursor);
PROCEDURE race_code_P (
    pcompcode     in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code     out p_circul_cursor);  
    
PROCEDURE inct_slab_code_P (
    pcompcode     in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code     out p_circul_cursor);
PROCEDURE festival_code_P (
    pcompcode       in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    ptype_code      out p_circul_cursor); 
PROCEDURE mach_config_code_P (
    pcompcode 	in varchar2,
    pdateformat in varchar2,
    pextra1 	in varchar2,
    pextra2 	in varchar2,
    ptype_code 	out p_circul_cursor);
    
PROCEDURE spons_code_P (
    pcompcode 	in varchar2,
    pdateformat in varchar2,
    pextra1 	in varchar2,
    pextra2 	in varchar2,
    ptype_code 	out p_circul_cursor);
    
PROCEDURE cir_unsold_scnction_p (
    pcompcode   in varchar2,
    pdoctype    in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    preceipt_no out p_circul_cursor);    
END Cir_Genrate_Code;
/
CREATE OR REPLACE PACKAGE BODY Cir_Genrate_Code IS
PROCEDURE agency_type_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor) as
    vno         number(5);
    vtype_code  varchar2(15);

BEGIN

    Begin
       select max(substr(agency_type_code,3,5))+1 into vno from cir_agency_typ_mast where comp_code=pcompcode;
    Exception When Others Then
        vno:=null;
    End;
     If nvl(vno,0)=0 Then
      vtype_code:='AT'||'001';
     Else
    vtype_code:='AT'||lpad(vno,3,'0');
     End if;

  open ptype_code for select vtype_code as "VAR_CODE" from dual;

End agency_type_p;

PROCEDURE agency_class_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor) as
    vno         number(8);
    vtype_code  varchar2(15);

BEGIN

    Begin
       select to_number(max(substr(class_code,3,5)))+1 into vno from cir_agency_class_mast where comp_code=pcompcode;
    Exception When Others Then
        vno:=null;
    End;
     If nvl(vno,0)=0 Then
        vtype_code:='AC'||'001';
     Else
        vtype_code:='AC'||lpad(vno,3,'0');
     End if;

    open ptype_code for select vtype_code as "VAR_CODE" from dual;

End agency_class_p;

PROCEDURE suspend_type_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor) as
    vno         number(5);
    vtype_code  varchar2(15);

BEGIN

    Begin
       select max(substr(suspend_type_code,3,5))+1 into vno from cir_suspend_type_mast where comp_code=pcompcode;
    Exception When Others Then
        vno:=null;
    End;
     If nvl(vno,0)=0 Then
        vtype_code:='ST'||'001';
     Else
        vtype_code:='ST'||lpad(vno,3,'0');
     End if;

    open ptype_code for select vtype_code as "VAR_CODE" from dual;

End suspend_type_p;

PROCEDURE area_type_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor) as
    vno         number(5);
    vtype_code  varchar2(15);

BEGIN

    Begin
       select max(substr(area_type,3,5))+1 into vno from cir_area_type_mast where comp_code=pcompcode;
    Exception When Others Then
        vno:=null;
    End;
    If nvl(vno,0)=0 Then
    vtype_code:='AR'||'001';
    Else
    vtype_code:='AR'||lpad(vno,3,'0');
    End if;

     open ptype_code for select vtype_code as "VAR_CODE" from dual;

End area_type_p;

PROCEDURE publ_mast_p(
   pcompcode    in varchar2,
   pdateformat  in varchar2,
   pextra1      in varchar2,
   pextra2      in varchar2,
   ppubl_code   out p_circul_cursor) as
    vno         number(5);
    vpubl_code  varchar2(15);

BEGIN

    Begin
       select max(to_number(substr(publ,2)))+1 into vno from cir_publ_mast where comp_code=pcompcode;
    Exception When Others Then
        vno:=null;
    End;
    If nvl(vno,0)=0 Then
        vpubl_code:='P'||'01';
    Else
        vpubl_code:='P'||lpad(vno,2,'0');
    End if;

    open ppubl_code for  select vpubl_code as "VAR_CODE" from dual;

End publ_mast_p;

PROCEDURE edtn_mast_p (
    pcompcode   in varchar2,
    ppubl_code  in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    pedtn_code  out p_circul_cursor) as
    vno         number(5);
    vedtn_code  varchar2(15);
BEGIN

    Begin
       select max(substr(edtn,2))+1 into vno from cir_edtn_mast where comp_code=pcompcode /*and publ=ppubl_code*/;
    Exception When Others Then
        vno:=null;
    End;
    If nvl(vno,0)=0 Then
        vedtn_code:=/*'E'||*/'001';
    Else
        vedtn_code:=/*'E'||*/lpad(vno,3,'0');
    End if;

    open pedtn_code for select vedtn_code as "VAR_CODE" from dual;

End edtn_mast_p;

PROCEDURE agmast_P (
    pcompcode   in varchar2,
    punitcode   in varchar2,
    pprefix     in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    pag_code    out p_circul_cursor) as
    vno         number(8);
    vag_code    varchar2(8);
    v_prefix    varchar2(20);
Begin

    Begin
        if upper(pextra2)='D' then
          v_prefix:='D'||upper(pprefix);
          select max(substr(agcd,length(v_prefix)+1))+1 into vno from cir_agmast_dis
              where comp_code=pcompcode and unit=punitcode and upper(substr(agcd,1,length(v_prefix)))=upper(v_prefix);
        else
            v_prefix:=upper(pprefix);
            select max(substr(agcd,length(v_prefix)+1))+1 into vno from cir_agmast
                  where comp_code=pcompcode and unit=punitcode and upper(substr(agcd,1,length(v_prefix)))=upper(v_prefix);
        end if;
    Exception when others then
         vno:=0;
    End;
    if nvl(vno,0)=0 then
       vag_code:=upper(v_prefix)||'0001';
    else
       vag_code:=upper(v_prefix)||lpad(vno,4,'0');
    end if;

    open pag_code for select vag_code as "VAR_CODE" from dual;

End agmast_P;

PROCEDURE agsubcode_P (
    pcompcode       in varchar2,
    punitcode       in varchar2,
    pagcode         in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    pag_code        out p_circul_cursor) as
    vno             number(8);
    vag_code        varchar2(8);

BEGIN

    Begin
        if upper(pextra2)='D' then
            select to_number(max(dpcd))+1 into vno from cir_agmast_dis
                where comp_code=pcompcode and unit=punitcode and upper(agcd)=upper(pagcode);
        else
            select to_number(max(dpcd))+1 into vno from cir_agmast
                where comp_code=pcompcode and unit=punitcode and upper(agcd)=upper(pagcode);
        end if;
    Exception when others then
      vno:=0;
    End;
    if nvl(vno,0)=0 then
       vag_code:='0001';
    else
       vag_code:=lpad(vno,4,'0');
    end if;

    open pag_code for select vag_code as "VAR_CODE" from dual;

End agsubcode_P;

PROCEDURE areacode_P (
    pcompcode       in varchar2,
    punitcode       in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    parea_code      out p_circul_cursor) as
    vno             number(8);
    varea_code      varchar2(15);

BEGIN

    Begin
       select max(substr(area_code,2,5))+1 into vno from cir_area_mast where comp_code=pcompcode and unit_code=punitcode;
    Exception When Others Then
        vno:=null;
    End;
     If nvl(vno,0)=0 Then
        varea_code:='A'||'0001';
     Else
        varea_code:='A'||lpad(vno,4,'0');
     End if;

    open parea_code for select varea_code as "VAR_CODE" from dual;

End areacode_P;

PROCEDURE drop_point_code_P (
    pcompcode           in varchar2,
    punitcode           in varchar2,
    pdateformat         in varchar2,
    pextra1             in varchar2,
    pextra2             in varchar2,
    pdrop_point_code    out p_circul_cursor) as
    vno         number(8);
    vdrop_point varchar2(15);

BEGIN

    Begin
        select max(substr(drop_point,2,5))+1 into vno from cir_drop_point_mast where comp_code=pcompcode and unit_code=punitcode;
    Exception When Others Then
        vno:=null;
    End;
    If nvl(vno,0)=0 Then
        vdrop_point:='D'||'0001';
    Else
        vdrop_point:='D'||lpad(vno,4,'0');
    End if;

    open pdrop_point_code for select vdrop_point as "VAR_CODE" from dual;

End drop_point_code_P;

Procedure executive_code_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    pexe_code   out p_circul_cursor) as
    vno         number(8);
    v_code      varchar2(15);

Begin

    Begin
       select max(substr(executive_code,2,5))+1 into vno from cir_executive_mast where comp_code=pcompcode;
    Exception When Others Then
        vno:=null;
    End;
    If nvl(vno,0)=0 Then
        v_code:='E'||'00001';
    Else
        v_code:='E'||lpad(vno,5,'0');
    End if;

    open pexe_code for select v_code as "VAR_CODE" from dual;

End executive_code_p;

PROCEDURE routecode_P (
    pcompcode   in varchar2,
    punitcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    prt_code    out p_circul_cursor) As
    vno         number(8);
    vrt_code    varchar2(15);
BEGIN
    Begin
       select max(substr(route_code,3,5))+1 into vno from cir_route_mast where comp_code=pcompcode and unit=punitcode;
    Exception When Others Then
        vno:=null;
    End;
    If nvl(vno,0)=0 Then
        vrt_code:='RT'||'001';
    Else
        vrt_code:='RT'||lpad(vno,3,'0');
    End if;

    open prt_code for select vrt_code as "VAR_CODE" from dual;

End routecode_P;

PROCEDURE subroutecode_P (
    pcompcode   in varchar2,
    punitcode   in varchar2,
    prtcode     in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    psubrt_code out p_circul_cursor) as
    vno         number(8);
    vsubrt_code varchar2(15);
BEGIN
    Begin
        select max(substr(subrt_code,3,5))+1 into vno from cir_sub_route_mast where comp_code=pcompcode and unit=punitcode and route_code=prtcode;
    Exception When Others Then
        vno:=null;
    End;
    If nvl(vno,0)=0 Then
        vsubrt_code:='SR'||'001';
    Else
        vsubrt_code:='SR'||lpad(vno,3,'0');
    End if;

    open psubrt_code for select vsubrt_code as "VAR_CODE" from dual;

End subroutecode_P;

PROCEDURE subsubroutecode_P (
    pcompcode       in varchar2,
    punitcode       in varchar2,
    prtcode         in varchar2,
    psubrtcode      in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    psubsubrt_code  out p_circul_cursor) as
    vno             number(8);
    vsubsubrt_code  varchar2(15);
BEGIN
    Begin
        select max(substr(sub_subrt_code,3,5))+1 into vno from cir_sub_subroute_mast
            where comp_code=pcompcode and unit=punitcode and route_code=prtcode and
                    subrt_code=psubrtcode;
    Exception When Others Then
       vno:=null;
    End;
    If nvl(vno,0)=0 Then
        vsubsubrt_code:='SS'||'001';
    Else
        vsubsubrt_code:='SS'||lpad(vno,3,'0');
    End if;
    open psubsubrt_code for select vsubsubrt_code as "VAR_CODE" from dual;

End subsubroutecode_P;

PROCEDURE transportercode_P (
    pcompcode   in varchar2,
    pprefix     in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptp_code    out p_circul_cursor) as
    vno         number(8);
    vtp_code    varchar2(8);

Begin

    Begin
        select max(substr(transporter_code,2))+1 into vno from cir_transporter_mast
            where comp_code=pcompcode and upper(substr(transporter_code,1,1))=upper(pprefix);
    Exception when others then
        vno:=0;
    End;

    if nvl(vno,0)=0 then
        vtp_code:=upper(pprefix)||'0001';
    else
        vtp_code:=upper(pprefix)||lpad(vno,4,'0');
    end if;

    open ptp_code for select vtp_code as "VAR_CODE" from dual;
End transportercode_P;

PROCEDURE districtcode_P (
    pcompcode   in varchar2,
    pstatecode  in varchar2,
    pprefix     in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    pdist_code  out p_circul_cursor) as
    vno         number(8);
    vdist_code  varchar2(8);

Begin

    Begin
        select max(substr(dist_code,3))+1 into vno from cir_dist_mast
            where comp_code=pcompcode and upper(substr(dist_code,1,2))=upper(pprefix);
    Exception when others then
    vno:=0;
    End;
    if nvl(vno,0)=0 then
        vdist_code:=upper(pprefix)||'0001';
    else
        vdist_code:=upper(pprefix)||lpad(vno,4,'0');
    end if;

    open pdist_code for select vdist_code as "VAR_CODE" from dual;

End districtcode_P;

PROCEDURE comm_catg_p (
    pcompcode   in varchar2,
    pcomm_type  in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor) as
    vno         number(5);
    vtype_code  varchar2(15);
    vcomm_type  varchar2(1);
BEGIN

    Begin
        select max(substr(comm_catg_code,3,5))+1 into vno from cir_comm_catg_mast where comp_code=pcompcode;
    Exception When Others Then
        vno:=null;
    End;
    If pcomm_type is null then
        vcomm_type:='C';
    Else
        vcomm_type:=pcomm_type;
    End if;
    If nvl(vno,0)=0 Then
        vtype_code:='C'||pcomm_type||'001';
    Else
        vtype_code:='C'||pcomm_type||lpad(vno,3,'0');
    End if;

    open ptype_code for select vtype_code as "VAR_CODE" from dual;

End comm_catg_p;

PROCEDURE comm_p (
    pcompcode   in varchar2,
    pcomm_type  in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor) as
    vno         number(5);
    vtype_code  varchar2(15);

    vcomm_type  varchar2(1);
BEGIN

    Begin
        select max(substr(comm_code,3,5))+1 into vno from cir_comm_mast where comp_code=pcompcode;
    Exception When Others Then
        vno:=null;
    End;
    If pcomm_type is null then
        vcomm_type:='F';
    Else
        vcomm_type:=pcomm_type;
    End if;
    If nvl(vno,0)=0 Then
        vtype_code:='C'||pcomm_type||'001';
    Else
        vtype_code:='C'||pcomm_type||lpad(vno,3,'0');
    End if;

    open ptype_code for select vtype_code as "VAR_CODE" from dual;

End comm_p;

PROCEDURE zone_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor) as
    vno         number(5);
    vtype_code  varchar2(15);

BEGIN

    Begin
       select max(substr(zone_code,3,5))+1 into vno from cir_zone_mast where comp_code=pcompcode;
    Exception When Others Then
        vno:=null;
    End;
    If nvl(vno,0)=0 Then
        vtype_code:='ZN'||'001';
    Else
        vtype_code:='ZN'||lpad(vno,3,'0');
    End if;

    open ptype_code for select vtype_code as "VAR_CODE" from dual;

End zone_p;

PROCEDURE taluka_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor)
as
    vno         number(5);
    vtype_code  varchar2(15);

BEGIN

    Begin
       select max(substr(talu_code,3,6))+1 into vno from cir_taluka_mast where comp_code=pcompcode;
    Exception When Others Then
        vno:=null;
    End;
    If nvl(vno,0)=0 Then
        vtype_code:='TK'||'0001';
    Else
        vtype_code:='TK'||lpad(vno,4,'0');
    End if;

    open ptype_code for select vtype_code as "VAR_CODE" from dual;

End taluka_p;

PROCEDURE receipt_p (
    pcompcode   in varchar2,
    pbranchcode in varchar2,
    pdoctype    in varchar2,
    precptdt    in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor)
    as
    vno         number(20);
    vrecptno  varchar2(15);
    v_dt date;
BEGIN

    v_dt:=to_date(precptdt,''''||pdateformat||'''');

    Begin
       if upper(pextra2)='D' then
        select max(to_number(substr(recptno,-8)))+1 into vno from cir_rcphdr_dis
            where comp_code=pcompcode and doctype=pdoctype and to_char(recptdt,'yymm')=to_char(v_dt,'yymm') and branch_code=pbranchcode;
       else
        select max(to_number(substr(recptno,-8)))+1 into vno from cir_rcphdr
            where comp_code=pcompcode and doctype=pdoctype and to_char(recptdt,'yymm')=to_char(v_dt,'yymm') and branch_code=pbranchcode;
       end if;
    Exception When Others Then
       vno:=null;
    End;

    If nvl(vno,0)=0 Then
      vrecptno:=pbranchcode||'-'||to_char(v_dt,'yymm')||'0001';
    Else
      vrecptno:=pbranchcode||'-'||lpad(vno,8,'0');
    End if;

    open ptype_code for select vrecptno as "VAR_CODE" from dual;

End receipt_p;

PROCEDURE mode_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor)
    as
    vno         number(5);
    vtype_code  varchar2(15);

BEGIN

    Begin
       select max(substr(mode_code,3,3))+1 into vno from cir_route_mode_mast where comp_code=pcompcode;
    Exception When Others Then
        vno:=null;
    End;
    If nvl(vno,0)=0 Then
        vtype_code:='RM'||'001';
    Else
        vtype_code:='RM'||lpad(vno,3,'0');
    End if;

    open ptype_code for select vtype_code as "VAR_CODE" from dual;

End mode_p;

PROCEDURE supply_type_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor)
    as
    vno         number(5);
    vtype_code  varchar2(15);

BEGIN

    Begin
       select max(substr(sup_ty_code,2,2))+1 into vno from cir_supply_type_mast where comp_code=pcompcode;
    Exception When Others Then
        vno:=null;
    End;
    If nvl(vno,0)=0 Then
        vtype_code:='S'||'01';
    Else
        vtype_code:='S'||lpad(vno,2,'0');
    End if;

    open ptype_code for select vtype_code as "VAR_CODE" from dual;

End supply_type_p;

PROCEDURE expenses_type_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor)
    as
    vno         number(5);
    vtype_code  varchar2(15);

BEGIN

    Begin
       select max(substr(exp_type_code,2,3))+1 into vno from cir_expenses_type_mast where comp_code=pcompcode;
    Exception When Others Then
        vno:=null;
    End;
    If nvl(vno,0)=0 Then
        vtype_code:='E'||'001';
    Else
        vtype_code:='E'||lpad(vno,3,'0');
    End if;

    open ptype_code for select vtype_code as "VAR_CODE" from dual;

End expenses_type_p;

PROCEDURE city_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor)
    as
    vno         number(5);
    vtype_code  varchar2(15);

BEGIN

    Begin
       select max(substr(city_code,3,6))+1 into vno from cir_city_mast where comp_code=pcompcode;
    Exception When Others Then
        vno:=null;
    End;

    If nvl(vno,0)=0 then
        vtype_code:='CT'||'0001';
    Else
        vtype_code:='CT'||lpad(vno,4,'0');
    End if;

    open ptype_code for select vtype_code as "VAR_CODE" from dual;

End city_p;

PROCEDURE cir_region_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    preg_code   out p_circul_cursor)
    as
    vno         number(5);
    vreg_code   varchar2(15);
BEGIN

    Begin
       select max(substr(reg_code,3,6))+1 into vno from cir_region_mast where comp_code=pcompcode;
    Exception When Others Then
        vno:=null;
    End;
    If nvl(vno,0)=0 Then
        vreg_code:='RG'||'0001';
    Else
        vreg_code:='RG'||lpad(vno,4,'0');
    End if;

    open preg_code for select vreg_code as "VAR_CODE" from dual;

End cir_region_p;

PROCEDURE cir_unsold_receipt_p (
    pcompcode       in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    preceipt_no     out p_circul_cursor)
    As
    vno number(5);
    vtype_code  varchar2(15);
    v_sess_id   number(20);
    v_prefix    varchar2(20);
    v_no        varchar2(20);
    v_dt        date;
    v_chkdt     date;
BEGIN
    /*loop
     begin
        select gen_unsold_rec_yn into v_gen_unsold_rec_yn from cir_control;
        if nvl(v_gen_unsold_rec_yn,'N')  = 'N' then
           exit;
        end if;
        exception when no_data_found then
            insert into cir_control values('Y');
            exit;
     end;
    end loop;
    update cir_control set GEN_UNSOLD_REC_YN='Y';commit;*/

    /*Begin
        if upper(pextra2)='D' then
            select max(substr(RECPTNO,3,8))+1 into vno from cir_unsold_hdr_dis where comp_code=pcompcode;
        else
            select max(substr(RECPTNO,3,8))+1 into vno from cir_unsold_hdr where comp_code=pcompcode;
        end if;
    Exception When Others Then
        vno:=null;
    End;
    If nvl(vno,0)=0 Then
        vtype_code:='UN'||'000001';
    Else
        vtype_code:='UN'||lpad(vno,6,'0');
    End if;

    open preceipt_no for
    select vtype_code as "VAR_CODE" from dual;
    */

    v_dt    :=to_date(pextra1,''''||pdateformat||'''');
    v_prefix:='UN'||to_char(v_dt,'yymm');

    select trunc(v_dt,'mm') into v_chkdt from dual;

    begin
        select curr_no into v_no from cir_series
        where comp_code=pcompcode and ty='UCN' and trunc(year_monid,'mm')=v_chkdt and prefix=v_prefix;
    exception when no_data_found then
        v_no:=null;
    end;

    if v_no is null or v_no='0' then
        vtype_code:=v_prefix||'00001';
        insert into cir_series(comp_code,unit_code,branch_code,ty,year_monid,prefix, curr_no)
        values(pcompcode,null,null,'UCN',trunc(v_dt,'mm'),v_prefix,1);
    else
        v_no        :=to_number(v_no)+1;
        vtype_code  :=v_prefix||lpad(v_no,5,'0');
        update cir_series set curr_no=nvl(curr_no,0)+1
            where comp_code=pcompcode and ty='UCN' and trunc(year_monid,'mm')=v_chkdt and prefix=v_prefix;
    end if;
    commit;

    open preceipt_no for
    select vtype_code as "VAR_CODE" from dual;
End cir_unsold_receipt_p;

PROCEDURE cir_surcharge_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    psurch_cd   out p_circul_cursor)
    as
    vno         number(5);
    vsurch_cd   varchar2(15);

BEGIN

    Begin
            select max(substr(surch_cd,2,3))+1 into vno from cir_surcharge_mast where comp_code=pcompcode;
    Exception When Others Then
        vno:=null;
    End;
    If nvl(vno,0)=0 Then
        vsurch_cd:='S'||'001';
    Else
        vsurch_cd:='S'||lpad(vno,3,'0');
    End if;

    open psurch_cd for select vsurch_cd as "VAR_CODE" from dual;

End cir_surcharge_p;

PROCEDURE cir_roleMatser_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    psurch_cd   out p_circul_cursor)
    as
    vno         number(5);
    vsurch_cd   varchar2(15);

BEGIN

    Begin
       select max(substr(role_code,2,3))+1 into vno from cir_role_mast where comp_code=pcompcode;
          Exception When Others Then
               vno:=null;
    End;
    If nvl(vno,0)=0 Then
        vsurch_cd:='R'||'001';
    Else
        vsurch_cd:='R'||lpad(vno,3,'0');
    End if;

    open psurch_cd for select vsurch_cd as "VAR_CODE" from dual;

End cir_roleMatser_p;

PROCEDURE cir_narr_p (
    pcompcode       in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    pnarr_cd        out p_circul_cursor)
    as
    vno             number(5);
    vsurch_cd       varchar2(15);
BEGIN
    Begin
        select max(substr(na_code,3,4))+1 into vno from fa_vch_narration_mast where comp_code=pcompcode;
    Exception When Others Then
        vno:=null;
    End;

    If nvl(vno,0)=0 Then
        vsurch_cd:='N'||'001';
    Else
        vsurch_cd:='N'||lpad(vno,3,'0');
    End if;

    open pnarr_cd for select vsurch_cd as "VAR_CODE" from dual;

End cir_narr_p;

Procedure cir_taxi_code_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptaxi_code  out p_circul_cursor) as

    vno         number(8);
    v_code      varchar2(15);

Begin

    Begin
        select max(substr(taxi_id,2,4))+1 into vno from cir_taxi_mast where comp_code=pcompcode;
    Exception When Others Then
        vno:=null;
    End;

    If nvl(vno,0)=0 Then
        v_code:='V'||'0001';
    Else
        v_code:='V'||lpad(vno,4,'0');
    End if;

    open ptaxi_code for select v_code as "VAR_CODE" from dual;

End cir_taxi_code_p;

PROCEDURE cir_lable_htmlformatid_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    pformat_id  out p_circul_cursor)
    As
    vno         number(8);
    v_code      varchar2(15);
    v_sess_id   number(20);
Begin
    Begin
        select max(formatid)+1 into vno from cir_lable_htmlformat;
    Exception When Others Then
        vno:=null;
    End;

    If nvl(vno,0)=0 Then
        v_code:=1;
    Else
        v_code:=vno;
    End if;
    insert into cir_lable_htmlformat(comp_code,formatid,format_desc) values(pcompcode,v_code,pextra1);commit;
    open pformat_id for select v_code as "FORMAT_ID" from dual;

End cir_lable_htmlformatid_p;
PROCEDURE cir_installment_code_p (
        pcompcode   in varchar2,
        punitcode   in varchar2,
        pdateformat in varchar2,
        pextra1     in varchar2,
        pextra2     in varchar2,
        pcode       out p_circul_cursor) as
    vno         number(10);
    v_code      varchar2(15);
    Begin

    Begin
        select max(substr(inst_code,2,7))+1 into vno from cir_installment_mast where comp_code=pcompcode;
        Exception When Others Then
            vno:=null;
    End;

    If nvl(vno,0)=0 Then
        v_code:='I'||'0000001';
    Else
        v_code:='I'||lpad(vno,7,'0');
    End if;

    open pcode for select v_code as "VAR_CODE" from dual;

    End cir_installment_code_p;
PROCEDURE race_code_P (
    pcompcode 	in varchar2,
    pdateformat in varchar2,
    pextra1 	in varchar2,
    pextra2 	in varchar2,
    ptype_code 	out p_circul_cursor) as
    
    vno         number(8);
    vtype_code  varchar2(25);
BEGIN
    Begin
       select to_number(max(substr(race_code,3,5)))+1 into vno from cir_race_mast;
    Exception When Others Then
        vno:=null;
    End;
    
    If nvl(vno,0)=0 Then
        vtype_code:='RC'||'001';
    Else
        vtype_code:='RC'||lpad(vno,3,'0');
    End if;
    open ptype_code for select vtype_code as "VAR_CODE" from dual;
    
End race_code_P; 

PROCEDURE inct_slab_code_P (
    pcompcode 	in varchar2,
    pdateformat in varchar2,
    pextra1 	in varchar2,
    pextra2 	in varchar2,
    ptype_code 	out p_circul_cursor) as
    
    vno         number(8);
    vtype_code  varchar2(25);
BEGIN

    select nvl(max(inct_slab_id),0)+1 into vno from cir_inct_slab_hdr;
    

    open ptype_code for select vno as "VAR_CODE" from dual;
    
End inct_slab_code_p;   

PROCEDURE festival_code_P (
    pcompcode 	in varchar2,
    pdateformat in varchar2,
    pextra1 	in varchar2,
    pextra2 	in varchar2,
    ptype_code 	out p_circul_cursor) as
    
    vno         number(8);
    vtype_code  varchar2(25);
BEGIN

    select nvl(max(fest_code),0)+1 into vno from cir_festival_mast;
    

    open ptype_code for select vno as "VAR_CODE" from dual;
    
End festival_code_p;

PROCEDURE mach_config_code_P (
    pcompcode 	in varchar2,
    pdateformat in varchar2,
    pextra1 	in varchar2,
    pextra2 	in varchar2,
    ptype_code 	out p_circul_cursor) as
    
    vno         number(8);
BEGIN

    select nvl(max(MACH_ID),0)+1 into vno from cir_mach_config_mast;
    

    open ptype_code for select vno as "VAR_CODE" from dual;
    
End mach_config_code_p;

PROCEDURE spons_code_P (
    pcompcode 	in varchar2,
    pdateformat in varchar2,
    pextra1 	in varchar2,
    pextra2 	in varchar2,
    ptype_code 	out p_circul_cursor) as
    
    vno         number(8);
BEGIN

    select nvl(max(SPONS_ID),0)+1 into vno from CIR_SPONS_HDR;
    

    open ptype_code for select vno as "VAR_CODE" from dual;
    
End spons_code_P;

PROCEDURE cir_unsold_scnction_p (
    pcompcode       in varchar2,
    pdoctype        in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    preceipt_no     out p_circul_cursor)
    As
    vno number(5);
    vtype_code  varchar2(15);
    v_sess_id   number(20);
    v_prefix    varchar2(20);
    v_no        varchar2(20);
    v_dt        date;
    v_chkdt     date;
BEGIN

    v_dt    :=to_date(pextra1,''''||pdateformat||'''');
    v_prefix:='SN'||to_char(v_dt,'yymm');

    select trunc(v_dt,'mm') into v_chkdt from dual;

    begin
        select curr_no into v_no from cir_series
        where comp_code=pcompcode and ty=nvl(pdoctype,'SCN') and trunc(year_monid,'mm')=v_chkdt and prefix=v_prefix;
    exception when no_data_found then
        v_no:=null;
    end;

    if v_no is null or v_no='0' then
        vtype_code:=v_prefix||'00001';
        insert into cir_series(comp_code,unit_code,branch_code,ty,year_monid,prefix, curr_no)
        values(pcompcode,null,null,nvl(pdoctype,'SCN'),trunc(v_dt,'mm'),v_prefix,1);
    else
        v_no        :=to_number(v_no)+1;
        vtype_code  :=v_prefix||lpad(v_no,5,'0');
        update cir_series set curr_no=nvl(curr_no,0)+1
            where comp_code=pcompcode and ty=nvl(pdoctype,'SCN') and trunc(year_monid,'mm')=v_chkdt and prefix=v_prefix;
    end if;
    commit;

    open preceipt_no for
    select vtype_code as "VAR_CODE" from dual;
    
End cir_unsold_scnction_p;
END Cir_Genrate_Code;
/


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////garima


CREATE OR REPLACE PROCEDURE Websp_Bindcioidnew1
(
fromdate IN VARCHAR2,
todate IN VARCHAR2,
date1 IN VARCHAR2,
publication IN VARCHAR2,
bookingcenter IN VARCHAR2,
revenuecenter IN VARCHAR2,
agencytype IN VARCHAR2,

PACKAGE1 IN VARCHAR2,
adtype1 IN VARCHAR2,
agency IN VARCHAR2,
client IN VARCHAR2,
billstatus IN VARCHAR2,
rate_audit IN VARCHAR2,
billmode IN VARCHAR2,
billcycle IN VARCHAR2,

v_retainer_name in varchar2,
v_executive_name in varchar2,
v_branch_name in varchar2,
v_ad_category in varchar2,
v_district in varchar2,
v_taluka in varchar2,
pcompcode  IN  varchar2,
P_BILLNO IN VARCHAR2,
P_BILL_GEN_PRIOR IN VARCHAR2,
P_CENTERLOGIN IN VARCHAR2,
P_PUB_CENT_HO IN VARCHAR2,
P_FMG_BILL IN VARCHAR2,
P_SCHEME_TYPE in varchar2,
pto_bill_no in varchar2,

p_recordset OUT Cur_Type_New1.cursor_type

)

IS

query1 VARCHAR2(10000);


v_bill_criteria varchar2(10);

BEGIN
    if adtype1='DI0' then
        select disp_billing_criteria into v_bill_criteria from preferrences where "comp_code"=pcompcode;
    else
        select clsd_billing_criteria into v_bill_criteria from preferrences where "comp_code"=pcompcode;
    end if;
    
   IF(billstatus='3' AND rate_audit='n')
   THEN

      query1:='SELECT  DISTINCT  TBL_BOOKING_INSERT."Cio_Booking_Id", "No_Insert" AS "no_of_insertion" ,TBL_BOOKING_MAST."Package_code"  AS "edition",


      nvl((select distinct cust_mast."Cust_Alias" from cust_mast  where

cust_mast."Cust_Code"=tbl_booking_mast."Client_code"),"Client_code") as "client",


      AGENCY_MAST."Agency_Name" AS "Agency",sum(TBL_BOOKING_INSERT."Gross_Rate") as "Gross_Rate",TBL_BOOKING_MAST."Trade_disc" AS "Commission",tbl_booking_insert."Insert_Date" as "pub_date",
      TBL_BOOKING_INSERT."Insert_Status" AS "status",TBL_BOOKING_MAST."No_of_insertion" AS "total",TBL_BOOKING_MAST."Bill_remarks",
       tbl_booking_insert.BILL_NO
       ,(select max(nvl(ad_bills.PRINT_COUNT,0)) from ad_bills  where  tbl_booking_insert."Comp_Code"=ad_bills.COMP_CODE_V and ad_bills.BILNO=tbl_booking_insert.BILL_NO) as "PrintCount"
      FROM TBL_BOOKING_INSERT,TBL_BOOKING_MAST,AGENCY_MAST WHERE TBL_BOOKING_MAST."cio_booking_id"=TBL_BOOKING_INSERT."Cio_Booking_Id"  AND
       TBL_BOOKING_INSERT."Insert_Status"=''publish'' AND AGENCY_MAST."code_subcode"=TBL_BOOKING_MAST."Agency_sub_code"' ;
   END IF;


 IF(billstatus='3' AND rate_audit='y')
THEN

      query1:='SELECT  DISTINCT  TBL_BOOKING_INSERT."Cio_Booking_Id", "No_Insert" AS "no_of_insertion" ,TBL_BOOKING_MAST."Package_code"  AS "edition",
 nvl((select distinct cust_mast."Cust_Alias" from cust_mast  where

cust_mast."Cust_Code"=tbl_booking_mast."Client_code"),"Client_code") as "client",
      AGENCY_MAST."Agency_Name" AS "Agency",sum(TBL_BOOKING_INSERT."Gross_Rate") as "Gross_Rate",TBL_BOOKING_MAST."Trade_disc" AS "Commission",tbl_booking_insert."Insert_Date" as "pub_date",
      TBL_BOOKING_INSERT."Insert_Status" AS "status",TBL_BOOKING_MAST."No_of_insertion" AS "total",TBL_BOOKING_MAST."Bill_remarks",
       tbl_booking_insert.BILL_NO
       ,(select max(nvl(ad_bills.PRINT_COUNT,0)) from ad_bills  where  tbl_booking_insert."Comp_Code"=ad_bills.COMP_CODE_V and ad_bills.BILNO=tbl_booking_insert.BILL_NO) as "PrintCount"

      FROM TBL_BOOKING_INSERT,TBL_BOOKING_MAST,AGENCY_MAST WHERE TBL_BOOKING_MAST."cio_booking_id"=TBL_BOOKING_INSERT."Cio_Booking_Id"  AND
       TBL_BOOKING_INSERT."Insert_Status"=''audit by rate'' AND AGENCY_MAST."code_subcode"=TBL_BOOKING_MAST."Agency_sub_code"' ;
END IF;
IF(billstatus='1' AND rate_audit='y'AND billmode='2')
THEN

 query1:='SELECT  DISTINCT  TBL_BOOKING_INSERT."Cio_Booking_Id", "No_Insert" AS "no_of_insertion" ,TBL_BOOKING_MAST."Package_code"  AS "edition",
 nvl((select distinct cust_mast."Cust_Alias" from cust_mast  where

cust_mast."Cust_Code"=tbl_booking_mast."Client_code"),"Client_code") as "client",
      AGENCY_MAST."Agency_Name" AS "Agency",sum(TBL_BOOKING_INSERT."Gross_Rate") as "Gross_Rate",TBL_BOOKING_MAST."Trade_disc" AS "Commission",tbl_booking_insert."Insert_Date" as "pub_date",
      TBL_BOOKING_INSERT."Insert_Status" AS "status",TBL_BOOKING_MAST."No_of_insertion" AS "total",TBL_BOOKING_MAST."Bill_remarks",
       tbl_booking_insert.BILL_NO
       ,(select max(nvl(ad_bills.PRINT_COUNT,0)) from ad_bills  where  tbl_booking_insert."Comp_Code"=ad_bills.COMP_CODE_V and ad_bills.BILNO=tbl_booking_insert.BILL_NO) as "PrintCount"
      FROM TBL_BOOKING_INSERT,TBL_BOOKING_MAST,AGENCY_MAST WHERE TBL_BOOKING_MAST."cio_booking_id"=TBL_BOOKING_INSERT."Cio_Booking_Id"
AND AGENCY_MAST."code_subcode"=TBL_BOOKING_MAST."Agency_sub_code"  AND (TBL_BOOKING_INSERT."Insert_Status" =''AUDIT BY rate'' OR TBL_BOOKING_INSERT."Insert_Status"=''billed'')' ;
END IF;
IF(billstatus='1' AND rate_audit='n' AND billmode='2')
THEN

 query1:='SELECT  DISTINCT  TBL_BOOKING_INSERT."Cio_Booking_Id", "No_Insert" AS "no_of_insertion" ,TBL_BOOKING_MAST."Package_code"  AS "edition",
      (SELECT CUST_MAST."Cust_Alias" FROM CUST_MAST  WHERE CUST_MAST."Cust_Code" = TBL_BOOKING_MAST."Client_code") AS "client",
      AGENCY_MAST."Agency_Name" AS "Agency",sum(TBL_BOOKING_INSERT."Gross_Rate") as "Gross_Rate",TBL_BOOKING_MAST."Trade_disc" AS "Commission",tbl_booking_insert."Insert_Date" as "pub_date",
      TBL_BOOKING_INSERT."Insert_Status" AS "status",TBL_BOOKING_MAST."No_of_insertion" AS "total",TBL_BOOKING_MAST."Bill_remarks",
       tbl_booking_insert.BILL_NO
       ,(select max(nvl(ad_bills.PRINT_COUNT,0)) from ad_bills  where  tbl_booking_insert."Comp_Code"=ad_bills.COMP_CODE_V and ad_bills.BILNO=tbl_booking_insert.BILL_NO) as "PrintCount"
      FROM TBL_BOOKING_INSERT,TBL_BOOKING_MAST,AGENCY_MAST WHERE TBL_BOOKING_MAST."cio_booking_id"=TBL_BOOKING_INSERT."Cio_Booking_Id"
 AND AGENCY_MAST."code_subcode"=TBL_BOOKING_MAST."Agency_sub_code"  AND (TBL_BOOKING_INSERT."Insert_Status" =''publish'' OR TBL_BOOKING_INSERT."Insert_Status"=''billed'')' ;
END IF;

IF(billstatus='1' AND rate_audit='n' AND (billmode='1' OR billmode='3'))
THEN
 query1:='SELECT  DISTINCT  TBL_BOOKING_INSERT."Cio_Booking_Id", "No_Insert" AS "no_of_insertion" ,TBL_BOOKING_MAST."Package_code"  AS "edition",
      (SELECT CUST_MAST."Cust_Alias" FROM CUST_MAST  WHERE CUST_MAST."Cust_Code" = TBL_BOOKING_MAST."Client_code") AS "client",
      AGENCY_MAST."Agency_Name" AS "Agency",sum(TBL_BOOKING_INSERT."Gross_Rate") as "Gross_Rate",TBL_BOOKING_MAST."Trade_disc" AS "Commission",tbl_booking_insert."Insert_Date" as "pub_date",
      TBL_BOOKING_INSERT."Insert_Status" AS "status",TBL_BOOKING_MAST."No_of_insertion" AS "total",TBL_BOOKING_MAST."Bill_remarks",

      tbl_booking_insert.BILL_NO
      ,(select max(nvl(ad_bills.PRINT_COUNT,0)) from ad_bills  where  tbl_booking_insert."Comp_Code"=ad_bills.COMP_CODE_V and ad_bills.BILNO=tbl_booking_insert.BILL_NO) as "PrintCount"

      FROM TBL_BOOKING_INSERT,TBL_BOOKING_MAST,AGENCY_MAST WHERE TBL_BOOKING_MAST."cio_booking_id"=TBL_BOOKING_INSERT."Cio_Booking_Id"
 AND AGENCY_MAST."code_subcode"=TBL_BOOKING_MAST."Agency_sub_code"  AND (TBL_BOOKING_INSERT."Insert_Status"=''billed'')' ;
END IF;

IF(billstatus='1' AND rate_audit='y' AND (billmode='1' OR billmode='3'))
THEN

 query1:='SELECT  DISTINCT  TBL_BOOKING_INSERT."Cio_Booking_Id", "No_Insert" AS "no_of_insertion" ,TBL_BOOKING_MAST."Package_code"  AS "edition",
      (SELECT CUST_MAST."Cust_Alias" FROM CUST_MAST  WHERE CUST_MAST."Cust_Code" = TBL_BOOKING_MAST."Client_code") AS "client",
      AGENCY_MAST."Agency_Name" AS "Agency",sum(TBL_BOOKING_INSERT."Gross_Rate") as "Gross_Rate",TBL_BOOKING_MAST."Trade_disc" AS "Commission",tbl_booking_insert."Insert_Date" as "pub_date",
      TBL_BOOKING_INSERT."Insert_Status" AS "status",TBL_BOOKING_MAST."No_of_insertion" AS "total",TBL_BOOKING_MAST."Bill_remarks",
      tbl_booking_insert.BILL_NO
      ,(select max(nvl(ad_bills.PRINT_COUNT,0)) from ad_bills  where  tbl_booking_insert."Comp_Code"=ad_bills.COMP_CODE_V and ad_bills.BILNO=tbl_booking_insert.BILL_NO) as "PrintCount"
      FROM TBL_BOOKING_INSERT,TBL_BOOKING_MAST,AGENCY_MAST WHERE TBL_BOOKING_MAST."cio_booking_id"=TBL_BOOKING_INSERT."Cio_Booking_Id"
 AND AGENCY_MAST."code_subcode"=TBL_BOOKING_MAST."Agency_sub_code"  AND (TBL_BOOKING_INSERT."Insert_Status"=''billed'')' ;
END IF;

IF(billstatus='3' AND rate_audit='n' AND (billmode='1' OR billmode='3'))
THEN

 query1:='SELECT  DISTINCT  TBL_BOOKING_INSERT."Cio_Booking_Id", "No_Insert" AS "no_of_insertion" ,TBL_BOOKING_MAST."Package_code"  AS "edition",
      (SELECT CUST_MAST."Cust_Alias" FROM CUST_MAST  WHERE CUST_MAST."Cust_Code" = TBL_BOOKING_MAST."Client_code") AS "client",
      AGENCY_MAST."Agency_Name" AS "Agency",sum(TBL_BOOKING_INSERT."Gross_Rate") as "Gross_Rate",TBL_BOOKING_MAST."Trade_disc" AS "Commission",tbl_booking_insert."Insert_Date" as "pub_date",
      TBL_BOOKING_INSERT."Insert_Status" AS "status",TBL_BOOKING_MAST."No_of_insertion" AS "total",TBL_BOOKING_MAST."Bill_remarks",
      tbl_booking_insert.BILL_NO
      ,(select max(nvl(ad_bills.PRINT_COUNT,0)) from ad_bills  where  tbl_booking_insert."Comp_Code"=ad_bills.COMP_CODE_V and ad_bills.BILNO=tbl_booking_insert.BILL_NO) as "PrintCount"
      FROM TBL_BOOKING_INSERT,TBL_BOOKING_MAST,AGENCY_MAST WHERE TBL_BOOKING_MAST."cio_booking_id"=TBL_BOOKING_INSERT."Cio_Booking_Id"
 AND AGENCY_MAST."code_subcode"=TBL_BOOKING_MAST."Agency_sub_code"  AND (TBL_BOOKING_INSERT."Insert_Status"=''billed'')' ;
END IF;
IF(billstatus='3' AND rate_audit='y' AND (billmode='1' OR billmode='3'))
THEN

 query1:='SELECT  DISTINCT  TBL_BOOKING_INSERT."Cio_Booking_Id", "No_Insert" AS "no_of_insertion" ,TBL_BOOKING_MAST."Package_code"  AS "edition",
      (SELECT CUST_MAST."Cust_Alias" FROM CUST_MAST  WHERE CUST_MAST."Cust_Code" = TBL_BOOKING_MAST."Client_code") AS "client",
      AGENCY_MAST."Agency_Name" AS "Agency",sum(TBL_BOOKING_INSERT."Gross_Rate") as "Gross_Rate",TBL_BOOKING_MAST."Trade_disc" AS "Commission",tbl_booking_insert."Insert_Date" as "pub_date",
      TBL_BOOKING_INSERT."Insert_Status" AS "status",TBL_BOOKING_MAST."No_of_insertion" AS "total",TBL_BOOKING_MAST."Bill_remarks",
      tbl_booking_insert.BILL_NO
      ,(select max(nvl(ad_bills.PRINT_COUNT,0)) from ad_bills  where  tbl_booking_insert."Comp_Code"=ad_bills.COMP_CODE_V and ad_bills.BILNO=tbl_booking_insert.BILL_NO) as "PrintCount"
      FROM TBL_BOOKING_INSERT,TBL_BOOKING_MAST,AGENCY_MAST WHERE TBL_BOOKING_MAST."cio_booking_id"=TBL_BOOKING_INSERT."Cio_Booking_Id"
 AND AGENCY_MAST."code_subcode"=TBL_BOOKING_MAST."Agency_sub_code"  AND (TBL_BOOKING_INSERT."Insert_Status"=''billed'')' ;
END IF;
IF(billstatus=2)
THEN
 query1:=' SELECT DISTINCT  TBL_BOOKING_INSERT."Cio_Booking_Id","No_Insert" AS "no_of_insertion" ,TBL_BOOKING_MAST."Package_code" AS "edition" ,
(SELECT CUST_MAST."Cust_Alias" FROM CUST_MAST  WHERE CUST_MAST."Cust_Code" = TBL_BOOKING_MAST."Client_code") AS "client",
AGENCY_MAST."Agency_Name" AS "Agency",sum(TBL_BOOKING_INSERT."Gross_Rate") as "Gross_Rate",TBL_BOOKING_MAST."Trade_disc" AS "Commission",tbl_booking_insert."Insert_Date" as "pub_date",
TBL_BOOKING_INSERT."Insert_Status" AS "status",TBL_BOOKING_MAST."No_of_insertion" AS  "total",TBL_BOOKING_MAST."Bill_remarks",
tbl_booking_insert.BILL_NO
,(select max(nvl(ad_bills.PRINT_COUNT,0)) from ad_bills  where  tbl_booking_insert."Comp_Code"=ad_bills.COMP_CODE_V and ad_bills.BILNO=tbl_booking_insert.BILL_NO) as "PrintCount"
FROM TBL_BOOKING_INSERT,TBL_BOOKING_MAST,AGENCY_MAST WHERE TBL_BOOKING_MAST."cio_booking_id"=TBL_BOOKING_INSERT."Cio_Booking_Id"  AND
 TBL_BOOKING_INSERT."Insert_Status"=''billed'' AND AGENCY_MAST."code_subcode"=TBL_BOOKING_MAST."Agency_sub_code" ';
END IF;



   IF(billstatus='5')
   THEN

      query1:='SELECT  DISTINCT  TBL_BOOKING_INSERT."Cio_Booking_Id", "No_Insert" AS "no_of_insertion" ,TBL_BOOKING_MAST."Package_code"  AS "edition",
      (SELECT CUST_MAST."Cust_Alias" FROM CUST_MAST  WHERE CUST_MAST."Cust_Code" = TBL_BOOKING_MAST."Client_code") AS "client",
      AGENCY_MAST."Agency_Name" AS "Agency",sum(TBL_BOOKING_INSERT."Gross_Rate") as "Gross_Rate",TBL_BOOKING_MAST."Trade_disc" AS "Commission",tbl_booking_insert."Insert_Date" as "pub_date",
      TBL_BOOKING_INSERT."Insert_Status" AS "status",TBL_BOOKING_MAST."No_of_insertion" AS "total",TBL_BOOKING_MAST."Bill_remarks",
      tbl_booking_insert.BILL_NO
      ,(select max(nvl(ad_bills.PRINT_COUNT,0)) from ad_bills  where  tbl_booking_insert."Comp_Code"=ad_bills.COMP_CODE_V and ad_bills.BILNO=tbl_booking_insert.BILL_NO) as "PrintCount"
      FROM TBL_BOOKING_INSERT,TBL_BOOKING_MAST,AGENCY_MAST WHERE TBL_BOOKING_MAST."cio_booking_id"=TBL_BOOKING_INSERT."Cio_Booking_Id"  AND
       TBL_BOOKING_INSERT."Insert_Status"=''publish'' AND AGENCY_MAST."code_subcode"=TBL_BOOKING_MAST."Agency_sub_code"' ;
   END IF;


IF(billstatus=6)
THEN
 query1:=' SELECT DISTINCT  TBL_BOOKING_INSERT."Cio_Booking_Id","No_Insert" AS "no_of_insertion" ,TBL_BOOKING_MAST."Package_code" AS "edition" ,
(SELECT CUST_MAST."Cust_Alias" FROM CUST_MAST  WHERE CUST_MAST."Cust_Code" = TBL_BOOKING_MAST."Client_code") AS "client",
TBL_BOOKING_INSERT."Insert_Status" AS "status",TBL_BOOKING_MAST."No_of_insertion" AS  "total",TBL_BOOKING_MAST."Bill_remarks",
tbl_booking_insert.BILL_NO
,(select max(nvl(ad_bills.PRINT_COUNT,0)) from ad_bills  where  tbl_booking_insert."Comp_Code"=ad_bills.COMP_CODE_V and ad_bills.BILNO=tbl_booking_insert.BILL_NO) as "PrintCount"
FROM TBL_BOOKING_INSERT,TBL_BOOKING_MAST,AGENCY_MAST WHERE TBL_BOOKING_MAST."cio_booking_id"=TBL_BOOKING_INSERT."Cio_Booking_Id"  AND
 TBL_BOOKING_INSERT."Insert_Status"=''booked'' AND AGENCY_MAST."code_subcode"=TBL_BOOKING_MAST."Agency_sub_code" ';
END IF;








    IF(v_retainer_name  IS NOT NULL)
THEN
 query1:= query1 ||' and TBL_BOOKING_MAST ."RETAINER" ='''||v_retainer_name ||'''';
END IF;




        IF(v_executive_name IS NOT NULL)
THEN
 query1:= query1||' and TBL_BOOKING_MAST  ."Executive_code" ='''||v_executive_name ||'''';
END IF;



IF(v_branch_name  IS NOT NULL)
THEN
 query1:= query1 ||' and TBL_BOOKING_MAST ."branch" ='''||v_branch_name ||'''';
END IF;



IF(v_ad_category  IS NOT NULL)
THEN
 query1:= query1 ||' and TBL_BOOKING_MAST ."Ad_cat_code" ='''||v_ad_category||'''';
END IF;


IF(v_district  IS NOT NULL)
THEN
 query1:= query1 ||' and TBL_BOOKING_MAST."Agency_sub_code"  in (select AGENCY_MAST."code_subcode" from agency_mast where AGENCY_MAST."Dist_Code" ='''||v_district||''' or '''||v_district||''' is null)';
END IF;



IF(v_taluka IS NOT NULL)
THEN
 query1:= query1||'  AND TBL_BOOKING_MAST."Agency_sub_code"  in (select AGENCY_MAST."code_subcode" from agency_mast where (AGENCY_MAST."Dist_Code"  in(select DIST_CODE from taluka_mast where   TALU_CODE='''||v_taluka||''' or '''||v_taluka||''' is null) )  AND AGENCY_MAST."Dist_Code"='''||v_district||''' OR '''||v_district||'''  IS NULL   )';
END IF;

/*if v_bill_criteria='A' then
    IF(billcycle IS NOT NULL)
    THEN
        query1:=query1 ||' AND AGENCY_MAST."BILL_FREQUENCY"='''||billcycle ||'''';
    END IF;
elsif v_bill_criteria='R' then

    IF(billcycle IS NOT NULL)
    THEN
        query1:=query1 ||' AND TBL_BOOKING_MAST."Bill_cycle" ='''||billcycle ||'''';
    END IF;
end if;*/
IF(agency IS NOT NULL)
THEN
query1:=query1 ||' AND TBL_BOOKING_MAST."Agency_sub_code" ='''||agency ||'''';
END IF;

IF(client IS NOT NULL)
THEN
query1:=query1 ||' AND TBL_BOOKING_MAST."Client_code" ='''||client ||'''';
END IF;


IF(agencytype IS NOT NULL)
THEN
query1:=query1 ||' AND TBL_BOOKING_MAST."Agency_type"  ='''||trim(agencytype)||'''';
END IF;
IF(adtype1 IS NOT NULL)
THEN
query1:=query1 ||' AND TBL_BOOKING_MAST. "Ad_type_code" ='''||adtype1||''' ';
END IF;


IF(bookingcenter  IS NOT NULL)
THEN

query1:=query1 ||' AND TBL_BOOKING_MAST. "branch" ='''||bookingcenter||''' ';
END IF;




if (P_FMG_BILL !='Include')
then

query1:=query1 ||' AND tbl_booking_mast."Booking_type" not in (''2'',''4'',''5'')';

end if;

if(P_SCHEME_TYPE='EXCLUDE')
THEN

query1:=query1 ||' AND tbl_booking_INSERT ."Pai_Free_Ins"  in (''Y'')';

END IF;




IF(revenuecenter IS NOT NULL)
THEN

query1:=query1 ||' AND TBL_BOOKING_MAST. "branch" ='''||revenuecenter||''' ';
END IF;

IF(publication IS NOT NULL)
THEN
query1:=query1 ||'AND  TBL_BOOKING_INSERT."Publication_Code"='''||publication ||'''';
END IF;

if (P_BILLNO is not null) and (pto_bill_no is not null) then
   query1:=query1 ||'AND  tbl_booking_insert.BILL_NO between '''||P_BILLNO||''' and '''||pto_bill_no||'''';
END IF;



IF(fromdate IS NOT NULL AND todate IS NOT NULL )
THEN
 query1:=query1 ||'  AND "Insert_Date" BETWEEN  '''||fromdate ||''' AND  '''||todate ||''' ';
END IF;



IF(PACKAGE1 IS NOT  NULL)
THEN
query1:=query1 ||' AND  TBL_BOOKING_INSERT."Edition" ='''||PACKAGE1 ||'''';
END IF;

query1:=query1 ||'group by TBL_BOOKING_INSERT."Cio_Booking_Id",tbl_booking_insert."No_Insert" ,TBL_BOOKING_MAST."Package_code"
 , AGENCY_MAST."Agency_Name",TBL_BOOKING_MAST."Trade_disc",TBL_BOOKING_INSERT."Insert_Status",TBL_BOOKING_MAST."No_of_insertion"
 ,TBL_BOOKING_MAST."Bill_remarks",TBL_BOOKING_MAST."Client_code",tbl_booking_insert.BILL_NO, tbl_booking_insert."Comp_Code",tbl_booking_insert."Insert_Date"  order by TBL_BOOKING_INSERT."Cio_Booking_Id", tbl_booking_insert."No_Insert"';


 delete from ank_search_new;
insert into ank_search_new values(query1);
commit;



 OPEN p_recordset FOR

 query1;

END ;
/

/////////////////////////issue nuumber 6026
CREATE OR REPLACE procedure cir_rep_supply_detail_p(
    pcomp_code      in varchar2,
    punit_code      in varchar2,
    ppubl           in varchar2,
    pdateformat     in varchar2,
    puserid         in varchar2,
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
As
Begin
    
    open p_accounts for
    select m.comp_code as "COMP_CODE", m.unit as "UNIT", m.agcd as "AGCD", m.dpcd as "DPCD",m.ag_name as "AG_NAME",
    m.station_code as "DROP_POINT",cir_get_drop_point_name(m.comp_code,m.unit,m.station_code,1) as "DROP_POINT_NAME", 
    m.city_code as "CITY_CODE", cir_get_city(m.comp_code,m.city_code) as "CITY_NAME", s.publ as "PUBL",p.publ_name as "PUBL_NAME", 
    e.main_edtn as "MAIN_EDTN",cir_get_edtn_name(m.comp_code,e.main_edtn) as "MAIN_EDTN_NAME", 
    s.edtn as "EDTN",e.edtn_name as "EDTN_NAME", 
    s.supply_flag as "SUPPLY_FLAG", s.supply_type_code as "SUPPLY_TYPE_CODE",t.sup_ty_name as "SUP_TY_NAME", 
    s.base_supply as "BASE_SUPPLY", s.supply_sun as "SUPPLY_SUN", s.supply_mon as "SUPPLY_MON", s.supply_tue as "SUPPLY_TUE", s.supply_wed as "SUPPLY_WED",
    s.supply_thu as "SUPPLY_THU", s.supply_fri as "SUPPLY_FRI", s.supply_sat as "SUPPLY_SAT", s.supply_spl1 as "SUPPLY_SPL1", s.supply_spl2 as "SUPPLY_SPL2",
    m.SUSPEND_DATE as"SUSPEND_DATE"  
    from cir_supply s,cir_agmast m,cir_publ_mast p,cir_edtn_mast e,cir_supply_type_mast t
    where m.comp_code=s.comp_code and m.comp_code=p.comp_code and m.comp_code=e.comp_code and m.comp_code=t.comp_code and m.comp_code=nvl(pcomp_code,m.comp_code) and
    m.unit=s.unit and m.unit=nvl(punit_code,m.unit) and m.agcd=s.agcd and  m.dpcd=s.dpcd and s.publ=p.publ and s.publ=nvl(ppubl,s.publ) and 
    s.edtn=e.edtn and s.supply_type_code=t.sup_ty_code 
    --and nvl(m.freeze_flag,'N') ='N' and nvl(m.suspend,'N')='Y'
    order by comp_code,unit,city_name,drop_point_name,ag_name,publ_name,main_edtn_name,edtn_name,sup_ty_name; 
    
End cir_rep_supply_detail_p;
/
//////////////////////////////////////// updated by Anurag
///////////////////////issue number 5451 update by garima

CREATE OR REPLACE PACKAGE cir_one_day_supply_change IS
  TYPE T_Circul_Cursor is Ref Cursor;
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
   pextra2        in varchar2,
   pextra3        in varchar2,
   pextra4        in varchar2,
   pextra5        in varchar2,
   pextra6        in varchar2,
   pextra7        in varchar2,
   pextra8        in varchar2,
   pextra9        in varchar2,
   pextra10       in varchar2,
   p_circuls      out T_Circul_Cursor);

END cir_one_day_supply_change;
/
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
   pextra2        in varchar2,
   pextra3        in varchar2,
   pextra4        in varchar2,
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
         (a.branch_code = pbran_code or pbran_code is null) and
         a.city_code in (select city_code from cir_city_mast where a.comp_code=pcomp_code and city_code = nvl(pcity_code,city_code) and 
         (zone_code = pzone_code or pzone_code is null) and (region_code = pregion_code or pregion_code is null))
         order by route_seq,supply_seq,agency_name;
  else
      if pextra1=2 then---for edition district and agency wise
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
         (a.branch_code = pbran_code or pbran_code is null) and
         a.city_code in (select city_code from cir_city_mast where a.comp_code=pcomp_code and city_code = nvl(pcity_code,city_code) and 
         (zone_code = pzone_code or pzone_code is null) and (region_code = pregion_code or pregion_code is null))
         order by dist_name,agency_name,supply_seq;
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
         (a.branch_code = pbran_code or pbran_code is null) and
         a.city_code in (select city_code from cir_city_mast where a.comp_code=pcomp_code and city_code = nvl(pcity_code,city_code) and 
         (zone_code = pzone_code or pzone_code is null) and (region_code = pregion_code or pregion_code is null))
         order by route_seq,supply_seq,agency_name;
      end if;
   end if;
 End cir_one_day_supply_change_p;
END cir_one_day_supply_change;
/
**************************************************************************issue no 6089 start**********************************************

CREATE OR REPLACE PACKAGE BODY Cir_Dynamic_DML IS
PROCEDURE variable_insert_stmt(
    ptable_name     in varchar2,
    pcolname        in varchar2,
    pcolvalue       in varchar2,
    pdelimiter      in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2) as

    pstmt_str   varchar2(4000);
    v_sess_id   number;
cursor cur_stmt is

--delete from temp_col_ins;
--commit;
    select * from temp_col_ins  where session_id=v_sess_id order by sqno;
    rec_stmt cur_stmt%rowtype;

    vlength     number(5);
    vcolval     varchar2(4000);
    vrunval     varchar2(1);
    vcol_name     varchar2(500);
    vno         number(5);
    vrec         varchar2(4000);
    vrec_upd     varchar2(4000);
    vformat     varchar2(20);
    v_col_exists number(5);
Begin
    --insert into test1(vstring) values (pcolname||'33333'||pcolvalue);commit;
    dbg('vrec:');
   -- delete from
    insert into searchtbl(search) values ('neha');commit;


    Begin
        select userenv('sessionid') into v_sess_id from dual;
          delete from temp_col_ins where session_id=v_sess_id;
        vlength    :=null;    vcolval:=null;    vrunval:=null;    vcol_name:=null;vno:=null;

        vcolval    :=replace(pcolname,pdelimiter,',');
        vlength    :=length(vcolval);
        vno            :=1;

        for i in 1.. vlength loop
          vrunval:=substr(vcolval,i,1);
          if vrunval!=',' then
              vcol_name:=vcol_name||vrunval;
          else
            --insert into test1(vstring2) values (vno||','||upper(ltrim(rtrim(vcol_name)))||','||v_sess_id);
            --commit;
              insert into temp_col_ins (sqno,col_name,session_id) values (vno,upper(ltrim(rtrim(vcol_name))),v_sess_id);
              vno:=vno+1;
            vcol_name:='';
          end if;
        end loop;

         insert into searchtbl(search) values ('neha_1');commit;
        /*select count(*) into v_col_exists from col where tname=upper(ltrim(rtrim(ptable_name))) and
                cname=upper(ltrim(rtrim(vcol_name)));*/
        select count(*) into v_col_exists from temp_col_ins where session_id=v_sess_id and
            col_name=upper(ltrim(rtrim(vcol_name)));
        if nvl(v_col_exists,0)=0 then
            insert into temp_col_ins(sqno,col_name,session_id) values (vno,upper(vcol_name),v_sess_id);
        end if;
        commit;
        vlength:=null;    vcolval:=null;     vrunval:=null;    vcol_name:=null;    vno:=null;
        if instr(pcolvalue,',')>0 or instr(pcolvalue,'''')>0 then
           vcolval:=replace(pcolvalue,',','~~~');
        else
             vcolval:=pcolvalue;
        end if;
        vcolval:=replace(vcolval,pdelimiter,',');
        vlength:=length(vcolval);
        vno:=1;
        for i in 1.. vlength loop
          vrunval            :=substr(vcolval,i,1);
          if vrunval    !=',' then
              vcol_name    :=vcol_name||vrunval;
          else
              vcol_name    :=replace(vcol_name,'~~~',',');
            update temp_col_ins set col_value=vcol_name where sqno=vno and session_id=v_sess_id;
              vno:=vno+1;
            vcol_name:='';
          end if;
        end loop;
        if vcol_name is not null then
            update temp_col_ins set col_value=vcol_name where sqno=vno and session_id=v_sess_id;
        end if;
        update temp_col_ins set col_data_type=(select coltype from col where tname = upper(ltrim(rtrim(ptable_name))) and cname = upper(ltrim(rtrim(temp_col_ins.col_name))))
            where session_id=v_sess_id;
        commit;
         insert into searchtbl(search) values ('neha_2');commit;
        vrec:='insert into '||ptable_name||'('||replace(pcolname,pdelimiter,',')||') values ( ';

        insert into searchtbl(search) values (vrec);commit;

        --select "date_format" into vformat from preferrences;
          vformat:=pdateformat;
        open cur_stmt;
          loop
            fetch cur_stmt into rec_stmt;
               exit when cur_stmt%notfound;
               if rec_stmt.col_data_type='DATE' then
                    vrec:=vrec||'to_date('||rec_stmt.col_value||','||''''||vformat||''''||')'||',';
               else
                    vrec:=vrec||rec_stmt.col_value||',';
               end if;
          end loop;
        vrec        :=substr(vrec,1,length(vrec)-1)||')';
        vlength    :=null;
        vcolval    :=null;
        vrunval    :=null;
        vcol_name:=null;
        vno:=null;
        /*vcolval:=replace(pcond_colname,pdelimiter,',');
        vlength:=length(vcolval);
        for i in 1.. vlength loop
          vrunval:=substr(vcolval,i,1);
          if vrunval!=',' then
                   vcol_name:=vcol_name||vrunval;
          else
                 update temp_col_ins set upd_flag='I' where col_name=vcol_name and session_id=userenv('sessionid');
               vcol_name:='';
          end if;
        end loop;
        commit;
     close cur_stmt; */
     update temp_col_ins set upd_str=vrec where session_id=v_sess_id and rownum<2;
     --update temp_col_ins1 set upd_str=vrec where session_id=v_sess_id and rownum<2;
     --insert into test1(vstring) values (pcolname||'33333'||vrec);
     commit;

    End;
    dbg('vrec:'||vrec);
    execute immediate vrec;
    commit;
     --delete from temp_col_ins where session_id=userenv('sessionid');
    commit;
End variable_insert_stmt;

PROCEDURE variable_update_stmt(
   ptable_name      in varchar2,
   pcolname         in varchar2,
   pcolvalue        in varchar2,
   pcond_colname    in varchar2,
   pdelimiter       in varchar2,
   pdateformat      in varchar2,
   pextra1          in varchar2,
   pextra2          in varchar2) as

pstmt_str varchar2(4000);
cursor cur_stmt is select * from temp_col_ins  where session_id=userenv('sessionid') order by sqno;
    rec_stmt cur_stmt%rowtype;
cursor cur_upd_stmt is select * from temp_col_ins  where nvl(upd_flag,'N')='U' and session_id=userenv('sessionid');
    rec_upd_stmt cur_upd_stmt%rowtype;

    vlength     number(5);
    vcolval     varchar2(4000);
    vrunval     varchar2(1);
    vcol_name     varchar2(500);
    vno         number(5);
    vrec         varchar2(4000);
    vrec_upd     varchar2(4000);
    vpextra1     varchar2(4000);
    vformat     varchar2(20);
Begin
insert into searchtbl values('tblname-'|| ptable_name||'colname-'|| pcolname||'colvalue-'|| pcolvalue|| 'condname-' || pcond_colname|| 'delimeter-'|| pdelimiter || 'dateformat-'|| pdateformat || 'pextra1-'||pextra1||'pextra2-'|| pextra2);commit;






    --insert into test1(vstring) values (vrec||vrec_upd||ptable_name||','||pcolname||','||pcolvalue||','||pcond_colname||','||pdelimiter||','||pdateformat||','||pextra1||','||pextra2);
    Begin
        delete from temp_col_ins where session_id=userenv('sessionid');
        vlength        :=null;    vcolval:=null;    vrunval:=null;    vcol_name    :=null;    vno:=null;

        vcolval        :=replace(pcolname,pdelimiter,',');    vlength        :=length(vcolval);    vno:=1;
        for i in 1.. vlength loop
          vrunval:=substr(vcolval,i,1);
          if vrunval!=',' then
              vcol_name:=vcol_name||vrunval;
          else
              insert into temp_col_ins (sqno,col_name,session_id) values (vno,vcol_name,userenv('sessionid'));
              vno                :=vno+1;
            vcol_name    :='';
          end if;
        end loop;
        commit;
        vlength:=null;    vcolval:=null;    vrunval:=null;    vcol_name:=null;    vno:=null;

        if instr(pcolvalue,',')>0 then
            vcolval:=replace(pcolvalue,',','~~~');
        else
            vcolval:=pcolvalue;
        end if;

        vcolval:=replace(vcolval,pdelimiter,',');    vlength:=length(vcolval);    vno:=1;
        for i in 1.. vlength loop
          vrunval:=substr(vcolval,i,1);
          if vrunval!=',' then
                   vcol_name:=vcol_name||vrunval;
          else
                 vcol_name:=replace(vcol_name,'~~~',',');
               update temp_col_ins set col_value=vcol_name where sqno=vno and session_id=userenv('sessionid');
                 vno:=vno+1;
               vcol_name:='';
          end if;
        end loop;
        /*Start New Change For Old and New Concept */
        if pextra1='' or pextra1 is null then
             vpextra1:=pcolvalue;
        else
             vpextra1:=pextra1;
        end if;
        vlength:=null;    vcolval:=null;    vrunval:=null;    vcol_name:=null;    vno:=null;

        if instr(vpextra1,',')>0 then
            vcolval:=replace(vpextra1,',','~~~');
        else
            vcolval:=vpextra1;
        end if;

        vcolval:=replace(vcolval,pdelimiter,',');    vlength:=length(vcolval);    vno:=1;
        for i in 1.. vlength loop
          vrunval:=substr(vcolval,i,1);
          if vrunval!=',' then
                   vcol_name:=vcol_name||vrunval;
          else
                 vcol_name:=replace(vcol_name,'~~~',',');
               update temp_col_ins set col_value_old=vcol_name where sqno=vno and session_id=userenv('sessionid');
                 vno:=vno+1;
               vcol_name:='';
          end if;
        end loop;
        /*End New Change For Old and New Concept */
        update temp_col_ins set temp_col_ins.col_data_type=(select col.coltype from col where col.tname = upper(ltrim(rtrim(ptable_name))) and col.cname = upper(ltrim(rtrim(temp_col_ins.col_name))))
            where session_id=userenv('sessionid');
        commit;
        vrec:='update '||ptable_name||' set ';
        --select "date_format" into vformat from preferrences;
          vformat:=pdateformat;
        open cur_stmt;
          loop
            fetch cur_stmt into rec_stmt;
               exit when cur_stmt%notfound;
               if rec_stmt.col_data_type='DATE' then
                    vrec:=vrec||rec_stmt.col_name||'=to_date('||rec_stmt.col_value||','||''''||vformat||''''||')'||',';
               else
                    vrec:=vrec||rec_stmt.col_name||'='||replace(rec_stmt.col_value,'null','')||',';
               end if;
          end loop;
          vrec:=substr(vrec,1,length(vrec)-1);
        vlength:=null;    vcolval:=null;    vrunval:=null;    vcol_name:=null;    vno:=null;

        vcolval:=replace(pcond_colname,pdelimiter,',');    vlength:=length(vcolval);

        for i in 1.. vlength loop
          vrunval:=substr(vcolval,i,1);
          if vrunval!=',' then
              vcol_name:=vcol_name||vrunval;
          else
              update temp_col_ins set upd_flag='U' where col_name=vcol_name and session_id=userenv('sessionid');
            vcol_name:='';
          end if;
        end loop;
        commit;
      close cur_stmt;
        if pcond_colname is not null then
             vrec_upd:=' where ';
        else
             vrec_upd:='';
        end if;

        open cur_upd_stmt;
          loop
            fetch cur_upd_stmt into rec_upd_stmt;
               exit when cur_upd_stmt%notfound;
               if rec_upd_stmt.col_data_type='DATE' then
                    vrec_upd:=vrec_upd||rec_upd_stmt.col_name||'=to_date('||rec_upd_stmt.col_value_old||','||''''||vformat||''''||')'||' and ';
               else
                    vrec_upd:=vrec_upd||rec_upd_stmt.col_name||'='||rec_upd_stmt.col_value_old||' and ';
               end if;
          end loop;
         close cur_upd_stmt;
         vrec_upd:=substr(vrec_upd,1,length(vrec_upd)-5);
         update temp_col_ins set upd_str=vrec||vrec_upd where session_id=userenv('sessionid') and rownum<2;
         commit;

    End;
     insert into test1(vstring) values (vrec||vrec_upd);commit;
    execute immediate vrec||vrec_upd;
   -- insert into temp_col_ins1 values (vrec||vrec_upd);
    commit;
       --delete from temp_col_ins where session_id=userenv('sessionid');commit;

End variable_update_stmt;

procedure variable_delete_stmt(
  ptable_name   in varchar2,
  pcond_colname in varchar2,
  pcond_colval  in varchar2,
  pdelimiter    in varchar2,
  pdateformat   in varchar2,
  pextra1       in varchar2,
  pextra2       in varchar2) as

  pstmt_str varchar2(4000);
cursor cur_stmt is select * from temp_col_ins  where session_id=userenv('sessionid') order by sqno;
    rec_stmt cur_stmt%rowtype;

cursor cur_upd_stmt is select * from temp_col_ins  where nvl(upd_flag,'N')='U' and session_id=userenv('sessionid');
    rec_upd_stmt cur_upd_stmt%rowtype;

    vlength     number(5);
    vcolval     varchar2(4000);
    vrunval     varchar2(1);
    vcol_name   varchar2(500);
    vno         number(5);
    vrec        varchar2(4000);
    vformat     varchar2(20);
Begin
    Begin
        delete from temp_col_ins where session_id=userenv('sessionid');
        vlength:=null;
        vcolval:=null;
        vrunval:=null;
        vcol_name:=null;
        vno:=null;
        vcolval:=replace(pcond_colname,pdelimiter,',');
        vlength:=length(vcolval);
        vno:=1;
        for i in 1.. vlength loop
          vrunval:=substr(vcolval,i,1);
          if vrunval!=',' then
                   vcol_name:=vcol_name||vrunval;
          else
                 insert into temp_col_ins (sqno,col_name,upd_flag,session_id,upd_str) values (vno,vcol_name,'U',userenv('sessionid'),pcond_colval);
                 vno:=vno+1;
               vcol_name:='';
          end if;
        end loop;
        commit;
        vlength:=null;
        vcolval:=null;
        vrunval:=null;
        vcol_name:=null;
        vno:=null;
        if instr(pcond_colval,',')>0 then
           vcolval:=replace(pcond_colval,',','~~~');
        else
             vcolval:=pcond_colval;
        end if;
        vcolval:=replace(vcolval,pdelimiter,',');
        vlength:=length(vcolval);
        vno:=1;
        for i in 1.. vlength loop
          vrunval:=substr(vcolval,i,1);
          if vrunval!=',' then
                   vcol_name:=vcol_name||vrunval;
          else
                 --vcol_name:=replace(vcol_name,'~~~',',');
               update temp_col_ins set col_value=vcol_name where sqno=vno and session_id=userenv('sessionid');
                 vno:=vno+1;
               vcol_name:='';
          end if;
        end loop;
        update temp_col_ins set temp_col_ins.col_data_type=(select col.coltype from col where col.tname = upper(ltrim(rtrim(ptable_name))) and cname = upper(ltrim(rtrim(temp_col_ins.col_name))))
            where session_id=userenv('sessionid');
        commit;
        vrec:='delete from '||ptable_name||' where ';
        --select "date_format" into vformat from preferrences;
        vformat:=pdateformat;
        open cur_stmt;
          loop
            fetch cur_stmt into rec_stmt;
               exit when cur_stmt%notfound;
               if rec_stmt.col_data_type='DATE' then
                    vrec:=vrec||rec_stmt.col_name||'=to_date('||rec_stmt.col_value||','||''''||vformat||''''||')'||' and ';
               else
                    vrec:=vrec||rec_stmt.col_name||'='||rec_stmt.col_value||' and ';
               end if;
          end loop;
         vrec:=substr(vrec,1,length(vrec)-5);
         --update temp_col_ins set upd_str=vrec where session_id=userenv('sessionid') and rownum<2;
         --commit;

    End;
    insert  into temp_col_ins_c (vstr) values (vrec);
    commit;
    execute immediate vrec;
    commit;
    delete from temp_col_ins where session_id=userenv('sessionid');
    commit;

End variable_delete_stmt;

procedure variable_execute_stmt(
  ptable_name   in varchar2,
  pcond_colname in varchar2,
  pcond_colval  in varchar2,
  pdelimiter    in varchar2,
  pdateformat   in varchar2,
  pextra1       in varchar2,
  pextra2       in varchar2,
  p_accounts    out t_accounts_type) as

  pstmt_str varchar2(4000);
cursor cur_stmt is select * from temp_col_ins  where session_id=userenv('sessionid');
	rec_stmt cur_stmt%rowtype;

/*cursor cur_upd_stmt is select * from temp_col_ins  where nvl(upd_flag,'N')='U' and session_id=userenv('sessionid');
	rec_upd_stmt cur_upd_stmt%rowtype;*/

	vlength     number(5);
	vcolval     varchar2(4000);
	vrunval     varchar2(1);
	vcol_name   varchar2(100);
	vno         number(5);
	vrec        varchar2(4000);
	vformat     varchar2(20);
Begin
	 insert into temp_col_ins1 (sqno,col_name,upd_str,session_id) values (9999,'',sysdate||pcond_colname||'#'||pcond_colval||'#'||vrec,userenv('sessionid'));
    Begin
		delete from temp_col_ins where session_id=userenv('sessionid');
        delete from temp_col_ins1 where session_id=userenv('sessionid');
		vlength	:=null;	vcolval	:=null;	vrunval	:=null;	vcol_name	:=null;vno:=null;
		vcolval	:=replace(pcond_colname,pdelimiter,',');
		vlength	:=length(vcolval);vno:=1;

		for i in 1.. vlength loop
		  vrunval:=substr(vcolval,i,1);
		  if vrunval!=',' then
		  	vcol_name:=vcol_name||vrunval;
		  else
		  	insert into temp_col_ins (sqno,col_name,upd_flag,session_id) values (vno,vcol_name,'U',userenv('sessionid'));
            insert into temp_col_ins1 (sqno,col_name,upd_flag,session_id) values (vno,vcol_name,'U',userenv('sessionid'));
            vno:=vno+1;
		    vcol_name:='';
		  end if;
		end loop;
		commit;
		vlength:=null;
		vcolval:=null;
		vrunval:=null;
		vcol_name:=null;
		vno:=null;
		vcolval:=replace(replace(pcond_colval,',','^'),pdelimiter,',');
		vlength:=length(vcolval);
		vno:=1;
		for i in 1.. vlength loop
		  vrunval:=substr(vcolval,i,1);
		  if vrunval!=',' then
		  		 vcol_name:=vcol_name||vrunval;
		  else
		       update temp_col_ins set col_value=vcol_name where sqno=vno and session_id=userenv('sessionid');
               vno:=vno+1;
		       vcol_name:='';
		  end if;
		end loop;
		update temp_col_ins set temp_col_ins.col_data_type=(select col.coltype from col where col.tname = upper(ltrim(rtrim(ptable_name))) and cname = upper(ltrim(rtrim(temp_col_ins.col_name))))
			where session_id=userenv('sessionid');
       		delete from temp_col_ins where col_value=''''||'''' and session_id=userenv('sessionid');
		commit;
		vrec:='select * from '||ptable_name||' where ';
		--select "date_format" into vformat from preferrences;
          vformat:=pdateformat;
		open cur_stmt;
		  loop
		    fetch cur_stmt into rec_stmt;
		       exit when cur_stmt%notfound;
		       if rec_stmt.col_data_type='DATE' then
		       	 vrec:=vrec||rec_stmt.col_name||'=to_date('||replace(rec_stmt.col_value,'^',',')||','||''''||vformat||''''||')'||' and   ';
		       else
		       	 --vrec:=vrec||rec_stmt.col_name||'='||rec_stmt.col_value||' and ';
		       	 vrec:=vrec||'(('||rec_stmt.col_name||'='||replace(rec_stmt.col_value,'^',',')||') or ('||rec_stmt.col_name||' like '||rec_stmt.col_value||'))'||' and   ';
		       end if;
		  end loop;
          /*if substr(vrec,length(vrec)-5,5)=' and ' then
		     vrec:=substr(vrec,1,length(vrec)-4);
          elsif substr(vrec,length(vrec)-7,7)=' where ' then
             vrec:=substr(vrec,1,length(vrec)-6);
          end if;*/
             vrec:=substr(vrec,1,length(vrec)-7);
             --insert into test1(vstring) values(vrec);
		 update temp_col_ins set upd_str=vrec where session_id=userenv('sessionid') and rownum<2;
		 commit;

	End;
    delete from searchtbl;
    insert into searchtbl values(pextra1);commit;
    
    if pextra1 is not null then
       vrec:=vrec||' order by '||pextra1;
       insert into temp_col_ins1 (sqno,col_name,upd_str,session_id) values (1234,'',pcond_colname||'#'||pcond_colval||'#'||vrec,userenv('sessionid'));
    else
       vrec:=vrec||' order by rowid ';
    end if;
    insert into searchtbl values(vrec);commit;
    
    --insert into temp_col_ins1 values (vrec);
    insert into temp_col_ins1 (sqno,col_name,upd_str,session_id) values (9999,'',pcond_colname||'#'||pcond_colval||'#'||vrec,userenv('sessionid'));
	open p_accounts for vrec;
	--delete from temp_col_ins where session_id=userenv('sessionid');
	commit;
End variable_execute_stmt;

--var a refcursor;
--exec CIR_DYNAMIC_DML.variable_order('','','','','ABC_CHARGE_MAST','CHG_CODE','ASC','','','',:A);
--var a refcursor;
--exec CIR_DYNAMIC_DML.variable_order('','','','','ABC_CHARGE_MAST','CHG_CODE','ASC','','','',:A);

procedure variable_order(
 pcomp_code     in varchar2,
 pcomp_val         in varchar2,
 punit_code     in varchar2,
 punit_val         in varchar2,
 ptable_name     in varchar2,
 pcolname         in varchar2,
 porder         in varchar2,
 pdateformat     in varchar2,
 pextra1         in varchar2,
 pextra2         in varchar2,
 p_accounts     out t_accounts) as
Begin


   if punit_code is null and pcomp_code is not null then
      open p_accounts for ' select * from '||ptable_name||' where '||pcomp_code||'='||''''||pcomp_val||''''||' order by '||pcolname||' '||porder;
   elsif pcomp_code is null and punit_code is not null then
      open p_accounts for ' select * from '||ptable_name||' where '||punit_code||'='||''''||punit_val||''''||' order by '||pcolname||' '||porder;
   elsif pcomp_code is null and punit_code is null then
      open p_accounts for ' select * from '||ptable_name||' order by '||pcolname||' '||porder;
   else
         open p_accounts for ' select * from '||ptable_name||' where '||pcomp_code||'='||''''||pcomp_val||''''||' and '||punit_code||'='||''''||punit_val||''''||' order by '||pcolname||' '||porder;
   end if;
End variable_order;

PROCEDURE variable_insert_stmt(
    ptable_name     in varchar2,
    pcolname        in varchar2,
    pcolvalue       in varchar2,
    pdelimiter      in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    p_error_text    out varchar2) as

    pstmt_str   varchar2(4000);
    v_sess_id   number;
cursor cur_stmt is
    select * from temp_col_ins  where session_id=v_sess_id order by sqno;
    rec_stmt cur_stmt%rowtype;
/*cursor cur_upd_stmt is
    select * from temp_col_ins  where nvl(upd_flag,'N')='I' and session_id=v_sess_id;
    rec_upd_stmt cur_upd_stmt%rowtype;*/
    vlength     number(5);
    vcolval     varchar2(4000);
    vrunval     varchar2(1);
    vcol_name     varchar2(100);
    vno         number(5);
    vrec         varchar2(4000);
    vrec_upd     varchar2(4000);
    vformat     varchar2(20);
    v_col_exists number(5);
Begin
    --insert into test1(vstring) values (pcolname||'33333'||pcolvalue);commit;
    Begin
        select userenv('sessionid') into v_sess_id from dual;
        delete from temp_col_ins where session_id=v_sess_id;
        vlength    :=null;    vcolval:=null;    vrunval:=null;    vcol_name:=null;vno:=null;

        vcolval    :=replace(pcolname,pdelimiter,',');
        vlength    :=length(vcolval);
        vno            :=1;

        for i in 1.. vlength loop
          vrunval:=substr(vcolval,i,1);
          if vrunval!=',' then
              vcol_name:=vcol_name||vrunval;
          else
            --insert into test1(vstring2) values (vno||','||upper(ltrim(rtrim(vcol_name)))||','||v_sess_id);
            --commit;
              insert into temp_col_ins (sqno,col_name,session_id) values (vno,upper(ltrim(rtrim(vcol_name))),v_sess_id);
              vno:=vno+1;
            vcol_name:='';
          end if;
        end loop;
        /*select count(*) into v_col_exists from col where tname=upper(ltrim(rtrim(ptable_name))) and
                cname=upper(ltrim(rtrim(vcol_name)));*/
        select count(*) into v_col_exists from temp_col_ins where session_id=v_sess_id and
            col_name=upper(ltrim(rtrim(vcol_name)));
        if nvl(v_col_exists,0)=0 then
            insert into temp_col_ins(sqno,col_name,session_id) values (vno,upper(vcol_name),v_sess_id);
        end if;
        commit;
        vlength:=null;    vcolval:=null;     vrunval:=null;    vcol_name:=null;    vno:=null;
        if instr(pcolvalue,',')>0 or instr(pcolvalue,'''')>0 then
           vcolval:=replace(pcolvalue,',','~~~');
        else
             vcolval:=pcolvalue;
        end if;
        vcolval:=replace(vcolval,pdelimiter,',');
        vlength:=length(vcolval);
        vno:=1;
        for i in 1.. vlength loop
          vrunval            :=substr(vcolval,i,1);
          if vrunval    !=',' then
              vcol_name    :=vcol_name||vrunval;
          else
              vcol_name    :=replace(vcol_name,'~~~',',');
            update temp_col_ins set col_value=vcol_name where sqno=vno and session_id=v_sess_id;
              vno:=vno+1;
            vcol_name:='';
          end if;
        end loop;
        if vcol_name is not null then
            update temp_col_ins set col_value=vcol_name where sqno=vno and session_id=v_sess_id;
        end if;
        update temp_col_ins set col_data_type=(select coltype from col where tname = upper(ltrim(rtrim(ptable_name))) and cname = upper(ltrim(rtrim(temp_col_ins.col_name))))
            where session_id=v_sess_id;
        commit;
        vrec:='insert into '||ptable_name||'('||replace(pcolname,pdelimiter,',')||') values ( ';

        --select "date_format" into vformat from preferrences;
          vformat:=pdateformat;
        open cur_stmt;
          loop
            fetch cur_stmt into rec_stmt;
               exit when cur_stmt%notfound;
               if rec_stmt.col_data_type='DATE' then
                    vrec:=vrec||'to_date('||rec_stmt.col_value||','||''''||vformat||''''||')'||',';
               else
                    vrec:=vrec||rec_stmt.col_value||',';
               end if;
          end loop;
        vrec        :=substr(vrec,1,length(vrec)-1)||')';
        vlength    :=null;
        vcolval    :=null;
        vrunval    :=null;
        vcol_name:=null;
        vno:=null;
        /*vcolval:=replace(pcond_colname,pdelimiter,',');
        vlength:=length(vcolval);
        for i in 1.. vlength loop
          vrunval:=substr(vcolval,i,1);
          if vrunval!=',' then
                   vcol_name:=vcol_name||vrunval;
          else
                 update temp_col_ins set upd_flag='I' where col_name=vcol_name and session_id=userenv('sessionid');
               vcol_name:='';
          end if;
        end loop;
        commit;
     close cur_stmt; */
     update temp_col_ins set upd_str=vrec where session_id=v_sess_id and rownum<2;
     --update temp_col_ins1 set upd_str=vrec where session_id=v_sess_id and rownum<2;
     --insert into test1(vstring) values (pcolname||'33333'||vrec);
     commit;

    End;
    execute immediate vrec;
    commit;
     --delete from temp_col_ins where session_id=userenv('sessionid');
    commit;
    exception
       when others then
            p_error_text := 'Error:'||sqlerrm;
End variable_insert_stmt;

END Cir_Dynamic_DML;
/
******************************************************************************************
CREATE OR REPLACE PACKAGE Cir_Dynamic_DML IS
  procedure variable_insert_stmt(
      ptable_name in varchar2,
      pcolname in varchar2,
      pcolvalue in varchar2,
      pdelimiter in varchar2,
      pdateformat in varchar2,
      pextra1 in varchar2,
      pextra2 in varchar2);
  /*procedure variable_insert_stmt(
      ptable_name in varchar2,
      pcolname in varchar2,
      pcolvalue in varchar2,
      pdelimiter in varchar2,
      pdateformat in varchar2,
      pextra1 in varchar2,
      pextra2 in varchar2,
      p_error_text out varchar2);*/

  procedure variable_update_stmt(
      ptable_name in varchar2,
      pcolname in varchar2,
      pcolvalue in varchar2,
      pcond_colname in varchar2,
      pdelimiter in varchar2,
      pdateformat in varchar2,
      pextra1 in varchar2,
      pextra2 in varchar2);
  procedure variable_delete_stmt(
      ptable_name in varchar2,
      pcond_colname in varchar2,
      pcond_colval in varchar2,
      pdelimiter in varchar2,
      pdateformat in varchar2,
      pextra1 in varchar2,
      pextra2 in varchar2);
      type t_accounts_type is ref cursor;
  procedure variable_execute_stmt(
      ptable_name in varchar2,
      pcond_colname in varchar2,
      pcond_colval in varchar2,
      pdelimiter in varchar2,
      pdateformat in varchar2,
      pextra1 in varchar2,
      pextra2 in varchar2,
      p_accounts out t_accounts_type);
      type t_accounts is ref cursor;
   
   procedure variable_order(
      pcomp_code in varchar2,
      pcomp_val in varchar2,
      punit_code in varchar2,
      punit_val in varchar2,
      ptable_name in varchar2,
      pcolname in varchar2,
      porder in varchar2,
      pdateformat in varchar2,
      pextra1 in varchar2,
      pextra2 in varchar2,
      p_accounts out t_accounts);
END Cir_Dynamic_DML;
/
**********************************************************************end issue no 6089**************************************************


/***********************************mimoh******6136**********************************/




CREATE OR REPLACE PROCEDURE cir_agency_unblock_approval (
    pcomp_code         in varchar2,
    punit_code         in varchar2,
    pbran_code         in varchar2,
    pstatus            in varchar2,
    pfrdt              in date,
    ptodt              in date,
    pagcd              in varchar2,
    pdpcd              in varchar2,
    psuspty            in varchar2,
    puserid            in varchar2,
    p_accounts         OUT cur_type_new1.cursor_type) as
Begin

open p_accounts for
  select s.comp_code as "COMP_CODE",s.unit as "UNIT",s.agcd as "AGCD",s.dpcd as "DPCD",m.ag_name as "AGENCY_NAME",
  cir_get_drop_point_name(s.comp_code,s.unit,m.station_code,1) as "DROP_POINT_NAME",cir_get_city(s.comp_code,m.city_code) as "CITY_NAME",
  s.start_date as "BLOCK_UNBLOCK_DATE",TO_CHAR(s.CREATION_DATE,'hh:mi:ss') as "BLOCK_UNBLOCK_TIME",
         (SELECT SUSPEND_DESC FROM CIR_SUSPEND_TYPE_MAST WHERE COMP_CODE=s.COMP_CODE AND SUSPEND_TYPE_CODE=s.suspty) AS "BLOCK_REASON",s.suspty as "SUSPTY",
         (SELECT max("username") from login where com_code = s.comp_code  and "userid"=s.userid) as unblock_by,s.suspty as "SUSPEND_TYPE",
         s.agency_unblock_approval as "AGENCY_UNBLOCK_APPROVAL",s.userid as "USERID",nvl(s.trn_date,trunc(s.creation_date)) as "TRN_DATE" 
         from cir_suspend_tran s,cir_agmast m
      where s.comp_code = m.comp_code and s.comp_code = pcomp_code
        and s.unit=m.unit and s.unit      = nvl(punit_code,s.unit)
        and s.susp      = pstatus
        and s.trn_date between pfrdt and ptodt
        and s.agcd=m.agcd and s.agcd    = nvl(pagcd,s.agcd)
        and s.dpcd=m.dpcd and s.dpcd    = nvl(pdpcd,s.dpcd)
        and s.userid  = nvl(puserid,s.userid)
        and nvl(s.agency_unblock_approval,'N')='N';
    
  
End cir_agency_unblock_approval;
/

/***********************************mimoh******6136**********************************/

//*********************************by nand on 19th Jan ************************************************************
CREATE OR REPLACE PACKAGE Cir_Genrate_Code IS
	type p_circul_cursor is ref cursor;
PROCEDURE agency_type_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor);

PROCEDURE agency_class_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor);

PROCEDURE suspend_type_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor);

PROCEDURE area_type_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor);

PROCEDURE publ_mast_p(
   pcompcode    in varchar2,
   pdateformat  in varchar2,
   pextra1      in varchar2,
   pextra2      in varchar2,
   ppubl_code   out p_circul_cursor);

PROCEDURE edtn_mast_p (
    pcompcode   in varchar2,
    ppubl_code  in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    pedtn_code  out p_circul_cursor);

PROCEDURE agmast_P (
    pcompcode   in varchar2,
    punitcode   in varchar2,
    pprefix     in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    pag_code    out p_circul_cursor);

PROCEDURE agsubcode_P (
    pcompcode       in varchar2,
    punitcode       in varchar2,
    pagcode         in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    pag_code        out p_circul_cursor);

PROCEDURE areacode_P (
    pcompcode       in varchar2,
    punitcode       in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    parea_code      out p_circul_cursor);

PROCEDURE drop_point_code_P (
    pcompcode           in varchar2,
    punitcode           in varchar2,
    pdateformat         in varchar2,
    pextra1             in varchar2,
    pextra2             in varchar2,
    pdrop_point_code    out p_circul_cursor);

Procedure executive_code_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    pexe_code   out p_circul_cursor);

PROCEDURE routecode_P (
    pcompcode   in varchar2,
    punitcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    prt_code    out p_circul_cursor);

PROCEDURE subroutecode_P (
    pcompcode   in varchar2,
    punitcode   in varchar2,
    prtcode     in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    psubrt_code out p_circul_cursor);

PROCEDURE subsubroutecode_P (
    pcompcode       in varchar2,
    punitcode       in varchar2,
    prtcode         in varchar2,
    psubrtcode      in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    psubsubrt_code  out p_circul_cursor);

PROCEDURE transportercode_P (
    pcompcode   in varchar2,
    pprefix     in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptp_code    out p_circul_cursor);

PROCEDURE districtcode_P (
    pcompcode   in varchar2,
    pstatecode  in varchar2,
    pprefix     in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    pdist_code  out p_circul_cursor);

PROCEDURE comm_catg_p (
    pcompcode   in varchar2,
    pcomm_type  in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor);

PROCEDURE comm_p (
    pcompcode   in varchar2,
    pcomm_type  in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor);

PROCEDURE zone_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor);

PROCEDURE taluka_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor);

PROCEDURE receipt_p (
    pcompcode   in varchar2,
    pbranchcode in varchar2,
    pdoctype    in varchar2,
    precptdt    in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor);

PROCEDURE mode_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor);

PROCEDURE supply_type_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor);

PROCEDURE expenses_type_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor);

PROCEDURE city_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor);

PROCEDURE cir_region_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    preg_code   out p_circul_cursor);

PROCEDURE cir_unsold_receipt_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    preceipt_no out p_circul_cursor);

PROCEDURE cir_surcharge_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    psurch_cd   out p_circul_cursor);

PROCEDURE cir_roleMatser_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    psurch_cd   out p_circul_cursor);

PROCEDURE cir_narr_p (
    pcompcode       in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    pnarr_cd        out p_circul_cursor);

Procedure cir_taxi_code_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptaxi_code  out p_circul_cursor);

PROCEDURE cir_lable_htmlformatid_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    pformat_id  out p_circul_cursor);
PROCEDURE cir_installment_code_p (
    pcompcode   in varchar2,
    punitcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    pcode       out p_circul_cursor);
PROCEDURE race_code_P (
    pcompcode     in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code     out p_circul_cursor);  
    
PROCEDURE inct_slab_code_P (
    pcompcode     in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code     out p_circul_cursor);
PROCEDURE festival_code_P (
    pcompcode       in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    ptype_code      out p_circul_cursor); 
PROCEDURE mach_config_code_P (
    pcompcode 	in varchar2,
    pdateformat in varchar2,
    pextra1 	in varchar2,
    pextra2 	in varchar2,
    ptype_code 	out p_circul_cursor);
    
PROCEDURE spons_code_P (
    pcompcode 	in varchar2,
    pdateformat in varchar2,
    pextra1 	in varchar2,
    pextra2 	in varchar2,
    ptype_code 	out p_circul_cursor);
    
PROCEDURE cir_unsold_scnction_p (
    pcompcode   in varchar2,
    pdoctype    in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    preceipt_no out p_circul_cursor);    
END Cir_Genrate_Code;
/
CREATE OR REPLACE PACKAGE BODY Cir_Genrate_Code IS
PROCEDURE agency_type_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor) as
    vno         number(5);
    vtype_code  varchar2(15);

BEGIN

    Begin
       select max(substr(agency_type_code,3,5))+1 into vno from cir_agency_typ_mast where comp_code=pcompcode;
    Exception When Others Then
        vno:=null;
    End;
     If nvl(vno,0)=0 Then
      vtype_code:='AT'||'001';
     Else
    vtype_code:='AT'||lpad(vno,3,'0');
     End if;

  open ptype_code for select vtype_code as "VAR_CODE" from dual;

End agency_type_p;

PROCEDURE agency_class_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor) as
    vno         number(8);
    vtype_code  varchar2(15);

BEGIN

    Begin
       select to_number(max(substr(class_code,3,5)))+1 into vno from cir_agency_class_mast where comp_code=pcompcode;
    Exception When Others Then
        vno:=null;
    End;
     If nvl(vno,0)=0 Then
        vtype_code:='AC'||'001';
     Else
        vtype_code:='AC'||lpad(vno,3,'0');
     End if;

    open ptype_code for select vtype_code as "VAR_CODE" from dual;

End agency_class_p;

PROCEDURE suspend_type_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor) as
    vno         number(5);
    vtype_code  varchar2(15);

BEGIN

    Begin
       select max(substr(suspend_type_code,3,5))+1 into vno from cir_suspend_type_mast where comp_code=pcompcode;
    Exception When Others Then
        vno:=null;
    End;
     If nvl(vno,0)=0 Then
        vtype_code:='ST'||'001';
     Else
        vtype_code:='ST'||lpad(vno,3,'0');
     End if;

    open ptype_code for select vtype_code as "VAR_CODE" from dual;

End suspend_type_p;

PROCEDURE area_type_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor) as
    vno         number(5);
    vtype_code  varchar2(15);

BEGIN

    Begin
       select max(substr(area_type,3,5))+1 into vno from cir_area_type_mast where comp_code=pcompcode;
    Exception When Others Then
        vno:=null;
    End;
    If nvl(vno,0)=0 Then
    vtype_code:='AR'||'001';
    Else
    vtype_code:='AR'||lpad(vno,3,'0');
    End if;

     open ptype_code for select vtype_code as "VAR_CODE" from dual;

End area_type_p;

PROCEDURE publ_mast_p(
   pcompcode    in varchar2,
   pdateformat  in varchar2,
   pextra1      in varchar2,
   pextra2      in varchar2,
   ppubl_code   out p_circul_cursor) as
    vno         number(5);
    vpubl_code  varchar2(15);

BEGIN

    Begin
       select max(to_number(substr(publ,2)))+1 into vno from cir_publ_mast where comp_code=pcompcode;
    Exception When Others Then
        vno:=null;
    End;
    If nvl(vno,0)=0 Then
        vpubl_code:='P'||'01';
    Else
        vpubl_code:='P'||lpad(vno,2,'0');
    End if;

    open ppubl_code for  select vpubl_code as "VAR_CODE" from dual;

End publ_mast_p;

PROCEDURE edtn_mast_p (
    pcompcode   in varchar2,
    ppubl_code  in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    pedtn_code  out p_circul_cursor) as
    vno         number(5);
    vedtn_code  varchar2(15);
BEGIN

    Begin
       select max(substr(edtn,2))+1 into vno from cir_edtn_mast where comp_code=pcompcode /*and publ=ppubl_code*/;
    Exception When Others Then
        vno:=null;
    End;
    If nvl(vno,0)=0 Then
        vedtn_code:=/*'E'||*/'001';
    Else
        vedtn_code:=/*'E'||*/lpad(vno,3,'0');
    End if;

    open pedtn_code for select vedtn_code as "VAR_CODE" from dual;

End edtn_mast_p;

PROCEDURE agmast_P (
    pcompcode   in varchar2,
    punitcode   in varchar2,
    pprefix     in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    pag_code    out p_circul_cursor) as
    vno         number(8);
    vag_code    varchar2(8);
    v_prefix    varchar2(20);
Begin

    Begin
        if upper(pextra2)='D' then
          v_prefix:='D'||upper(pprefix);
          select max(substr(agcd,length(v_prefix)+1))+1 into vno from cir_agmast_dis
              where comp_code=pcompcode and unit=punitcode and upper(substr(agcd,1,length(v_prefix)))=upper(v_prefix);
        else
            v_prefix:=upper(pprefix);
            select max(substr(agcd,length(v_prefix)+1))+1 into vno from cir_agmast
                  where comp_code=pcompcode and unit=punitcode and upper(substr(agcd,1,length(v_prefix)))=upper(v_prefix);
        end if;
    Exception when others then
         vno:=0;
    End;
    if nvl(vno,0)=0 then
       vag_code:=upper(v_prefix)||'0001';
    else
       vag_code:=upper(v_prefix)||lpad(vno,4,'0');
    end if;

    open pag_code for select vag_code as "VAR_CODE" from dual;

End agmast_P;

PROCEDURE agsubcode_P (
    pcompcode       in varchar2,
    punitcode       in varchar2,
    pagcode         in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    pag_code        out p_circul_cursor) as
    vno             number(8);
    vag_code        varchar2(8);

BEGIN

    Begin
        if upper(pextra2)='D' then
            select to_number(max(dpcd))+1 into vno from cir_agmast_dis
                where comp_code=pcompcode and unit=punitcode and upper(agcd)=upper(pagcode);
        else
            select to_number(max(dpcd))+1 into vno from cir_agmast
                where comp_code=pcompcode and unit=punitcode and upper(agcd)=upper(pagcode);
        end if;
    Exception when others then
      vno:=0;
    End;
    if nvl(vno,0)=0 then
       vag_code:='0001';
    else
       vag_code:=lpad(vno,4,'0');
    end if;

    open pag_code for select vag_code as "VAR_CODE" from dual;

End agsubcode_P;

PROCEDURE areacode_P (
    pcompcode       in varchar2,
    punitcode       in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    parea_code      out p_circul_cursor) as
    vno             number(8);
    varea_code      varchar2(15);

BEGIN

    Begin
       select max(substr(area_code,2,5))+1 into vno from cir_area_mast where comp_code=pcompcode and unit_code=punitcode;
    Exception When Others Then
        vno:=null;
    End;
     If nvl(vno,0)=0 Then
        varea_code:='A'||'0001';
     Else
        varea_code:='A'||lpad(vno,4,'0');
     End if;

    open parea_code for select varea_code as "VAR_CODE" from dual;

End areacode_P;

PROCEDURE drop_point_code_P (
    pcompcode           in varchar2,
    punitcode           in varchar2,
    pdateformat         in varchar2,
    pextra1             in varchar2,
    pextra2             in varchar2,
    pdrop_point_code    out p_circul_cursor) as
    vno         number(8);
    vdrop_point varchar2(15);

BEGIN

    Begin
        select max(substr(drop_point,2,5))+1 into vno from cir_drop_point_mast where comp_code=pcompcode and unit_code=punitcode;
    Exception When Others Then
        vno:=null;
    End;
    If nvl(vno,0)=0 Then
        vdrop_point:='D'||'0001';
    Else
        vdrop_point:='D'||lpad(vno,4,'0');
    End if;

    open pdrop_point_code for select vdrop_point as "VAR_CODE" from dual;

End drop_point_code_P;

Procedure executive_code_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    pexe_code   out p_circul_cursor) as
    vno         number(8);
    v_code      varchar2(15);

Begin

    Begin
       select max(substr(executive_code,2,5))+1 into vno from cir_executive_mast where comp_code=pcompcode;
    Exception When Others Then
        vno:=null;
    End;
    If nvl(vno,0)=0 Then
        v_code:='E'||'00001';
    Else
        v_code:='E'||lpad(vno,5,'0');
    End if;

    open pexe_code for select v_code as "VAR_CODE" from dual;

End executive_code_p;

PROCEDURE routecode_P (
    pcompcode   in varchar2,
    punitcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    prt_code    out p_circul_cursor) As
    vno         number(8);
    vrt_code    varchar2(15);
BEGIN
    Begin
       select max(substr(route_code,3,5))+1 into vno from cir_route_mast where comp_code=pcompcode and unit=punitcode;
    Exception When Others Then
        vno:=null;
    End;
    If nvl(vno,0)=0 Then
        vrt_code:='RT'||'001';
    Else
        vrt_code:='RT'||lpad(vno,3,'0');
    End if;

    open prt_code for select vrt_code as "VAR_CODE" from dual;

End routecode_P;

PROCEDURE subroutecode_P (
    pcompcode   in varchar2,
    punitcode   in varchar2,
    prtcode     in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    psubrt_code out p_circul_cursor) as
    vno         number(8);
    vsubrt_code varchar2(15);
BEGIN
    Begin
        select max(substr(subrt_code,3,5))+1 into vno from cir_sub_route_mast where comp_code=pcompcode and unit=punitcode and route_code=prtcode;
    Exception When Others Then
        vno:=null;
    End;
    If nvl(vno,0)=0 Then
        vsubrt_code:='SR'||'001';
    Else
        vsubrt_code:='SR'||lpad(vno,3,'0');
    End if;

    open psubrt_code for select vsubrt_code as "VAR_CODE" from dual;

End subroutecode_P;

PROCEDURE subsubroutecode_P (
    pcompcode       in varchar2,
    punitcode       in varchar2,
    prtcode         in varchar2,
    psubrtcode      in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    psubsubrt_code  out p_circul_cursor) as
    vno             number(8);
    vsubsubrt_code  varchar2(15);
BEGIN
    Begin
        select max(substr(sub_subrt_code,3,5))+1 into vno from cir_sub_subroute_mast
            where comp_code=pcompcode and unit=punitcode and route_code=prtcode and
                    subrt_code=psubrtcode;
    Exception When Others Then
       vno:=null;
    End;
    If nvl(vno,0)=0 Then
        vsubsubrt_code:='SS'||'001';
    Else
        vsubsubrt_code:='SS'||lpad(vno,3,'0');
    End if;
    open psubsubrt_code for select vsubsubrt_code as "VAR_CODE" from dual;

End subsubroutecode_P;

PROCEDURE transportercode_P (
    pcompcode   in varchar2,
    pprefix     in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptp_code    out p_circul_cursor) as
    vno         number(8);
    vtp_code    varchar2(8);

Begin

    Begin
        select max(substr(transporter_code,2))+1 into vno from cir_transporter_mast
            where comp_code=pcompcode and upper(substr(transporter_code,1,1))=upper(pprefix);
    Exception when others then
        vno:=0;
    End;

    if nvl(vno,0)=0 then
        vtp_code:=upper(pprefix)||'0001';
    else
        vtp_code:=upper(pprefix)||lpad(vno,4,'0');
    end if;

    open ptp_code for select vtp_code as "VAR_CODE" from dual;
End transportercode_P;

PROCEDURE districtcode_P (
    pcompcode   in varchar2,
    pstatecode  in varchar2,
    pprefix     in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    pdist_code  out p_circul_cursor) as
    vno         number(8);
    vdist_code  varchar2(8);

Begin

    Begin
        select max(substr(dist_code,3))+1 into vno from cir_dist_mast
            where comp_code=pcompcode and upper(substr(dist_code,1,2))=upper(pprefix);
    Exception when others then
    vno:=0;
    End;
    if nvl(vno,0)=0 then
        vdist_code:=upper(pprefix)||'0001';
    else
        vdist_code:=upper(pprefix)||lpad(vno,4,'0');
    end if;

    open pdist_code for select vdist_code as "VAR_CODE" from dual;

End districtcode_P;

PROCEDURE comm_catg_p (
    pcompcode   in varchar2,
    pcomm_type  in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor) as
    vno         number(5);
    vtype_code  varchar2(15);
    vcomm_type  varchar2(1);
BEGIN

    Begin
        select max(substr(comm_catg_code,3,5))+1 into vno from cir_comm_catg_mast where comp_code=pcompcode;
    Exception When Others Then
        vno:=null;
    End;
    If pcomm_type is null then
        vcomm_type:='C';
    Else
        vcomm_type:=pcomm_type;
    End if;
    If nvl(vno,0)=0 Then
        vtype_code:='C'||pcomm_type||'001';
    Else
        vtype_code:='C'||pcomm_type||lpad(vno,3,'0');
    End if;

    open ptype_code for select vtype_code as "VAR_CODE" from dual;

End comm_catg_p;

PROCEDURE comm_p (
    pcompcode   in varchar2,
    pcomm_type  in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor) as
    vno         number(5);
    vtype_code  varchar2(15);

    vcomm_type  varchar2(1);
BEGIN

    Begin
        select max(substr(comm_code,3,5))+1 into vno from cir_comm_mast where comp_code=pcompcode;
    Exception When Others Then
        vno:=null;
    End;
    If pcomm_type is null then
        vcomm_type:='F';
    Else
        vcomm_type:=pcomm_type;
    End if;
    If nvl(vno,0)=0 Then
        vtype_code:='C'||pcomm_type||'001';
    Else
        vtype_code:='C'||pcomm_type||lpad(vno,3,'0');
    End if;

    open ptype_code for select vtype_code as "VAR_CODE" from dual;

End comm_p;

PROCEDURE zone_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor) as
    vno         number(5);
    vtype_code  varchar2(15);

BEGIN

    Begin
       select max(substr(zone_code,3,5))+1 into vno from cir_zone_mast where comp_code=pcompcode;
    Exception When Others Then
        vno:=null;
    End;
    If nvl(vno,0)=0 Then
        vtype_code:='ZN'||'001';
    Else
        vtype_code:='ZN'||lpad(vno,3,'0');
    End if;

    open ptype_code for select vtype_code as "VAR_CODE" from dual;

End zone_p;

PROCEDURE taluka_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor)
as
    vno         number(5);
    vtype_code  varchar2(15);

BEGIN

    Begin
       select max(substr(talu_code,3,6))+1 into vno from cir_taluka_mast where comp_code=pcompcode;
    Exception When Others Then
        vno:=null;
    End;
    If nvl(vno,0)=0 Then
        vtype_code:='TK'||'0001';
    Else
        vtype_code:='TK'||lpad(vno,4,'0');
    End if;

    open ptype_code for select vtype_code as "VAR_CODE" from dual;

End taluka_p;

PROCEDURE receipt_p (
    pcompcode   in varchar2,
    pbranchcode in varchar2,
    pdoctype    in varchar2,
    precptdt    in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor)
    as
    vno         number(20);
    vrecptno  varchar2(15);
    v_dt date;
BEGIN

    v_dt:=to_date(precptdt,''''||pdateformat||'''');

    Begin
       if upper(pextra2)='D' then
        select max(to_number(substr(recptno,-8)))+1 into vno from cir_rcphdr_dis
            where comp_code=pcompcode and doctype=pdoctype and to_char(recptdt,'yymm')=to_char(v_dt,'yymm') and branch_code=pbranchcode;
       else
        select max(to_number(substr(recptno,-8)))+1 into vno from cir_rcphdr
            where comp_code=pcompcode and doctype=pdoctype and to_char(recptdt,'yymm')=to_char(v_dt,'yymm') and branch_code=pbranchcode;
       end if;
    Exception When Others Then
       vno:=null;
    End;

    If nvl(vno,0)=0 Then
      vrecptno:=pbranchcode||'-'||to_char(v_dt,'yymm')||'0001';
    Else
      vrecptno:=pbranchcode||'-'||lpad(vno,8,'0');
    End if;

    open ptype_code for select vrecptno as "VAR_CODE" from dual;

End receipt_p;

PROCEDURE mode_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor)
    as
    vno         number(5);
    vtype_code  varchar2(15);

BEGIN

    Begin
       select max(substr(mode_code,3,3))+1 into vno from cir_route_mode_mast where comp_code=pcompcode;
    Exception When Others Then
        vno:=null;
    End;
    If nvl(vno,0)=0 Then
        vtype_code:='RM'||'001';
    Else
        vtype_code:='RM'||lpad(vno,3,'0');
    End if;

    open ptype_code for select vtype_code as "VAR_CODE" from dual;

End mode_p;

PROCEDURE supply_type_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor)
    as
    vno         number(5);
    vtype_code  varchar2(15);

BEGIN

    Begin
       select max(substr(sup_ty_code,2,2))+1 into vno from cir_supply_type_mast where comp_code=pcompcode;
    Exception When Others Then
        vno:=null;
    End;
    If nvl(vno,0)=0 Then
        vtype_code:='S'||'01';
    Else
        vtype_code:='S'||lpad(vno,2,'0');
    End if;

    open ptype_code for select vtype_code as "VAR_CODE" from dual;

End supply_type_p;

PROCEDURE expenses_type_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor)
    as
    vno         number(5);
    vtype_code  varchar2(15);

BEGIN

    Begin
       select max(substr(exp_type_code,2,3))+1 into vno from cir_expenses_type_mast where comp_code=pcompcode;
    Exception When Others Then
        vno:=null;
    End;
    If nvl(vno,0)=0 Then
        vtype_code:='E'||'001';
    Else
        vtype_code:='E'||lpad(vno,3,'0');
    End if;

    open ptype_code for select vtype_code as "VAR_CODE" from dual;

End expenses_type_p;

PROCEDURE city_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptype_code  out p_circul_cursor)
    as
    vno         number(5);
    vtype_code  varchar2(15);

BEGIN

    Begin
       select max(substr(city_code,3,6))+1 into vno from cir_city_mast where comp_code=pcompcode;
    Exception When Others Then
        vno:=null;
    End;

    If nvl(vno,0)=0 then
        vtype_code:='CT'||'0001';
    Else
        vtype_code:='CT'||lpad(vno,4,'0');
    End if;

    open ptype_code for select vtype_code as "VAR_CODE" from dual;

End city_p;

PROCEDURE cir_region_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    preg_code   out p_circul_cursor)
    as
    vno         number(5);
    vreg_code   varchar2(15);
BEGIN

    Begin
       select max(substr(reg_code,3,6))+1 into vno from cir_region_mast where comp_code=pcompcode;
    Exception When Others Then
        vno:=null;
    End;
    If nvl(vno,0)=0 Then
        vreg_code:='RG'||'0001';
    Else
        vreg_code:='RG'||lpad(vno,4,'0');
    End if;

    open preg_code for select vreg_code as "VAR_CODE" from dual;

End cir_region_p;

PROCEDURE cir_unsold_receipt_p (
    pcompcode       in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    preceipt_no     out p_circul_cursor)
    As
    vno number(5);
    vtype_code  varchar2(15);
    v_sess_id   number(20);
    v_prefix    varchar2(20);
    v_no        varchar2(20);
    v_dt        date;
    v_chkdt     date;
BEGIN
    /*loop
     begin
        select gen_unsold_rec_yn into v_gen_unsold_rec_yn from cir_control;
        if nvl(v_gen_unsold_rec_yn,'N')  = 'N' then
           exit;
        end if;
        exception when no_data_found then
            insert into cir_control values('Y');
            exit;
     end;
    end loop;
    update cir_control set GEN_UNSOLD_REC_YN='Y';commit;*/

    /*Begin
        if upper(pextra2)='D' then
            select max(substr(RECPTNO,3,8))+1 into vno from cir_unsold_hdr_dis where comp_code=pcompcode;
        else
            select max(substr(RECPTNO,3,8))+1 into vno from cir_unsold_hdr where comp_code=pcompcode;
        end if;
    Exception When Others Then
        vno:=null;
    End;
    If nvl(vno,0)=0 Then
        vtype_code:='UN'||'000001';
    Else
        vtype_code:='UN'||lpad(vno,6,'0');
    End if;

    open preceipt_no for
    select vtype_code as "VAR_CODE" from dual;
    */

    v_dt    :=to_date(pextra1,''''||pdateformat||'''');
    v_prefix:='UN'||to_char(v_dt,'yymm');

    select trunc(v_dt,'mm') into v_chkdt from dual;

    begin
        select curr_no into v_no from cir_series
        where comp_code=pcompcode and ty='UCN' and trunc(year_monid,'mm')=v_chkdt and prefix=v_prefix;
    exception when no_data_found then
        v_no:=null;
    end;

    if v_no is null or v_no='0' then
        vtype_code:=v_prefix||'00001';
        insert into cir_series(comp_code,unit_code,branch_code,ty,year_monid,prefix, curr_no)
        values(pcompcode,null,null,'UCN',trunc(v_dt,'mm'),v_prefix,1);
    else
        v_no        :=to_number(v_no)+1;
        vtype_code  :=v_prefix||lpad(v_no,5,'0');
        update cir_series set curr_no=nvl(curr_no,0)+1
            where comp_code=pcompcode and ty='UCN' and trunc(year_monid,'mm')=v_chkdt and prefix=v_prefix;
    end if;
    commit;

    open preceipt_no for
    select vtype_code as "VAR_CODE" from dual;
End cir_unsold_receipt_p;

PROCEDURE cir_surcharge_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    psurch_cd   out p_circul_cursor)
    as
    vno         number(5);
    vsurch_cd   varchar2(15);

BEGIN

    Begin
            select max(substr(surch_cd,2,3))+1 into vno from cir_surcharge_mast where comp_code=pcompcode;
    Exception When Others Then
        vno:=null;
    End;
    If nvl(vno,0)=0 Then
        vsurch_cd:='S'||'001';
    Else
        vsurch_cd:='S'||lpad(vno,3,'0');
    End if;

    open psurch_cd for select vsurch_cd as "VAR_CODE" from dual;

End cir_surcharge_p;

PROCEDURE cir_roleMatser_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    psurch_cd   out p_circul_cursor)
    as
    vno         number(5);
    vsurch_cd   varchar2(15);

BEGIN

    Begin
       select max(substr(role_code,2,3))+1 into vno from cir_role_mast where comp_code=pcompcode;
          Exception When Others Then
               vno:=null;
    End;
    If nvl(vno,0)=0 Then
        vsurch_cd:='R'||'001';
    Else
        vsurch_cd:='R'||lpad(vno,3,'0');
    End if;

    open psurch_cd for select vsurch_cd as "VAR_CODE" from dual;

End cir_roleMatser_p;

PROCEDURE cir_narr_p (
    pcompcode       in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    pnarr_cd        out p_circul_cursor)
    as
    vno             number(5);
    vsurch_cd       varchar2(15);
BEGIN
    Begin
        select max(substr(na_code,3,4))+1 into vno from fa_vch_narration_mast where comp_code=pcompcode;
    Exception When Others Then
        vno:=null;
    End;

    If nvl(vno,0)=0 Then
        vsurch_cd:='N'||'001';
    Else
        vsurch_cd:='N'||lpad(vno,3,'0');
    End if;

    open pnarr_cd for select vsurch_cd as "VAR_CODE" from dual;

End cir_narr_p;

Procedure cir_taxi_code_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    ptaxi_code  out p_circul_cursor) as

    vno         number(8);
    v_code      varchar2(15);

Begin

    Begin
        select max(substr(taxi_id,2,4))+1 into vno from cir_taxi_mast where comp_code=pcompcode;
    Exception When Others Then
        vno:=null;
    End;

    If nvl(vno,0)=0 Then
        v_code:='V'||'0001';
    Else
        v_code:='V'||lpad(vno,4,'0');
    End if;

    open ptaxi_code for select v_code as "VAR_CODE" from dual;

End cir_taxi_code_p;

PROCEDURE cir_lable_htmlformatid_p (
    pcompcode   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    pformat_id  out p_circul_cursor)
    As
    vno         number(8);
    v_code      varchar2(15);
    v_sess_id   number(20);
Begin
    Begin
        select max(formatid)+1 into vno from cir_lable_htmlformat;
    Exception When Others Then
        vno:=null;
    End;

    If nvl(vno,0)=0 Then
        v_code:=1;
    Else
        v_code:=vno;
    End if;
    insert into cir_lable_htmlformat(comp_code,formatid,format_desc) values(pcompcode,v_code,pextra1);commit;
    open pformat_id for select v_code as "FORMAT_ID" from dual;

End cir_lable_htmlformatid_p;
PROCEDURE cir_installment_code_p (
        pcompcode   in varchar2,
        punitcode   in varchar2,
        pdateformat in varchar2,
        pextra1     in varchar2,
        pextra2     in varchar2,
        pcode       out p_circul_cursor) as
    vno         number(10);
    v_code      varchar2(15);
    Begin

    Begin
        select max(substr(inst_code,2,7))+1 into vno from cir_installment_mast where comp_code=pcompcode;
        Exception When Others Then
            vno:=null;
    End;

    If nvl(vno,0)=0 Then
        v_code:='I'||'0000001';
    Else
        v_code:='I'||lpad(vno,7,'0');
    End if;

    open pcode for select v_code as "VAR_CODE" from dual;

    End cir_installment_code_p;
PROCEDURE race_code_P (
    pcompcode 	in varchar2,
    pdateformat in varchar2,
    pextra1 	in varchar2,
    pextra2 	in varchar2,
    ptype_code 	out p_circul_cursor) as
    
    vno         number(8);
    vtype_code  varchar2(25);
BEGIN
    Begin
       select to_number(max(substr(race_code,3,5)))+1 into vno from cir_race_mast;
    Exception When Others Then
        vno:=null;
    End;
    
    If nvl(vno,0)=0 Then
        vtype_code:='RC'||'001';
    Else
        vtype_code:='RC'||lpad(vno,3,'0');
    End if;
    open ptype_code for select vtype_code as "VAR_CODE" from dual;
    
End race_code_P; 

PROCEDURE inct_slab_code_P (
    pcompcode 	in varchar2,
    pdateformat in varchar2,
    pextra1 	in varchar2,
    pextra2 	in varchar2,
    ptype_code 	out p_circul_cursor) as
    
    vno         number(8);
    vtype_code  varchar2(25);
BEGIN

    select nvl(max(inct_slab_id),0)+1 into vno from cir_inct_slab_hdr;
    

    open ptype_code for select vno as "VAR_CODE" from dual;
    
End inct_slab_code_p;   

PROCEDURE festival_code_P (
    pcompcode 	in varchar2,
    pdateformat in varchar2,
    pextra1 	in varchar2,
    pextra2 	in varchar2,
    ptype_code 	out p_circul_cursor) as
    
    vno         number(8);
    vtype_code  varchar2(25);
BEGIN

    select nvl(max(fest_code),0)+1 into vno from cir_festival_mast;
    

    open ptype_code for select vno as "VAR_CODE" from dual;
    
End festival_code_p;

PROCEDURE mach_config_code_P (
    pcompcode 	in varchar2,
    pdateformat in varchar2,
    pextra1 	in varchar2,
    pextra2 	in varchar2,
    ptype_code 	out p_circul_cursor) as
    
    vno         number(8);
BEGIN

    select nvl(max(MACH_ID),0)+1 into vno from cir_mach_config_mast;
    

    open ptype_code for select vno as "VAR_CODE" from dual;
    
End mach_config_code_p;

PROCEDURE spons_code_P (
    pcompcode 	in varchar2,
    pdateformat in varchar2,
    pextra1 	in varchar2,
    pextra2 	in varchar2,
    ptype_code 	out p_circul_cursor) as
    
    vno         number(8);
BEGIN

    select nvl(max(SPONS_ID),0)+1 into vno from CIR_SPONS_HDR;
    

    open ptype_code for select vno as "VAR_CODE" from dual;
    
End spons_code_P;

PROCEDURE cir_unsold_scnction_p (
    pcompcode       in varchar2,
    pdoctype        in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    preceipt_no     out p_circul_cursor)
    As
    vno number(5);
    vtype_code  varchar2(15);
    v_sess_id   number(20);
    v_prefix    varchar2(20);
    v_no        varchar2(20);
    v_dt        date;
    v_chkdt     date;
BEGIN

    v_dt    :=to_date(pextra1,''''||pdateformat||'''');
    v_prefix:='SN'||to_char(v_dt,'yymm');

    select trunc(v_dt,'mm') into v_chkdt from dual;

    begin
        select curr_no into v_no from cir_series
        where comp_code=pcompcode and ty=nvl(pdoctype,'SCN') and trunc(year_monid,'mm')=v_chkdt and prefix=v_prefix;
    exception when no_data_found then
        v_no:=null;
    end;

    if v_no is null or v_no='0' then
        vtype_code:=v_prefix||'00001';
        insert into cir_series(comp_code,unit_code,branch_code,ty,year_monid,prefix, curr_no)
        values(pcompcode,null,null,nvl(pdoctype,'SCN'),trunc(v_dt,'mm'),v_prefix,1);
    else
        v_no        :=to_number(v_no)+1;
        vtype_code  :=v_prefix||lpad(v_no,5,'0');
        update cir_series set curr_no=nvl(curr_no,0)+1
            where comp_code=pcompcode and ty=nvl(pdoctype,'SCN') and trunc(year_monid,'mm')=v_chkdt and prefix=v_prefix;
    end if;
    commit;

    open preceipt_no for
    select vtype_code as "VAR_CODE" from dual;
    
End cir_unsold_scnction_p;
END Cir_Genrate_Code;
/

----------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE procedure cir_unapproved_unsold_receipt(
    pcompcode       in  varchar2,
    punitcode       in  varchar2,
    pbrancode       in  varchar2,
    pagcd           in  varchar2,
    pdpcd           in  varchar2,
    puserid         in  varchar2, 
    pdateformate    in  varchar2,
    pextra1         in  varchar2,
    pextra2         in  varchar2,--it is used for agency or distribution
    pextra3         in  varchar2,
    pextra4         in  varchar2,
    pextra5         in  varchar2,
    pextra6         in  varchar2,
    pextra7         in  varchar2,
    pextra8         in  varchar2,
    pextra9         in  varchar2,
    pextra10        in  varchar2,
    p_accounts      OUT cur_type_new1.cursor_type)
is

begin
    if upper(pextra2)='D' then
        open p_accounts for
        select distinct d.comp_code as "COMP_CODE",d.unit_code as "UNIT_CODE",d.recptno as "RECPTNO",d.recptdt as "RECPTDT",h.doctype as "DOCTYPE",
        h.app_dt as "APP_DT", sysdate as "ENTRYDT",h.frdt as "FRDT",h.todt as "TODT",h.agcd as "AGCD",h.dpcd as "DPCD",
		h.publ as "PUBL",h.edtn as "EDTN",puserid as "APP_USERID",puserid as "VAR_USERID"
        from cir_unsold_hdr_dis h,cir_unsold_dtl_dis d
        where h.comp_code=d.comp_code and h.comp_code=pcompcode and h.unit_code=d.unit_code and 
        h.unit_code=punitcode and h.doctype='UCN' and h.doctype=d.doctype and h.recptno=d.recptno and h.recptdt=d.recptdt and
        h.agcd=d.agcd and h.sup_agcd=pagcd and h.dpcd=d.dpcd and h.sup_dpcd=pdpcd and 
        (nvl(var_short_recpt,0)+nvl(var_late_recpt,0)+nvl(var_bnr,0)+nvl(var_unsold,0)+nvl(var_damage,0))-
        (nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0)+nvl(apr_damage,0))>0 and
        (h.recptno like pextra1||'%' or pextra1 is null)
        order by recptdt,recptno;
     else
        open p_accounts for
        select distinct d.comp_code as "COMP_CODE",d.unit_code as "UNIT_CODE",d.recptno as "RECPTNO",d.recptdt as "RECPTDT",h.doctype as "DOCTYPE",
        h.app_dt as "APP_DT", sysdate as "ENTRYDT",h.frdt as "FRDT",h.todt as "TODT",h.agcd as "AGCD",h.dpcd as "DPCD",
		h.publ as "PUBL",h.edtn as "EDTN",puserid as "APP_USERID",puserid as "VAR_USERID"
        from cir_unsold_hdr h,cir_unsold_dtl d
        where h.comp_code=d.comp_code and h.comp_code=pcompcode and h.unit_code=d.unit_code and 
        h.unit_code=punitcode and h.doctype='UCN' and h.doctype=d.doctype and h.recptno=d.recptno and h.recptdt=d.recptdt and
        h.agcd=d.agcd and h.sup_agcd=pagcd and h.dpcd=d.dpcd and h.sup_dpcd=pdpcd and 
        (nvl(var_short_recpt,0)+nvl(var_late_recpt,0)+nvl(var_bnr,0)+nvl(var_unsold,0)+nvl(var_damage,0))-
        (nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0)+nvl(apr_damage,0))>0 and
        (h.recptno like pextra1||'%' or pextra1 is null)
        order by recptdt,recptno;
     end if;      
            

End cir_unapproved_unsold_receipt;
/

---------------------------------------------------------------------------------------------------------
CREATE OR REPLACE procedure Cir_unsold_breakup_details
(
    puserid         in  varchar2, 
    pcompcode       in  varchar2,
    punitcode       in  varchar2,
    pd_branch        in varchar2,
    pd_rcptno        in varchar2,
    pd_rcptdate    in varchar2,
    pd_supdate     in varchar2,
    pd_agcode       in  varchar2,
    pd_agsubcode    in  varchar2,
    pdoctype        in varchar2,
    pdateformat    in  varchar2,
    pextra1         in  varchar2,
    pextra2         in  varchar2,    --it is used for agency or distribution
    p_accounts      OUT cur_type_new1.cursor_type
 )
   
is
    v_recptdt   date;
    v_supdt     date;
    
begin
     v_recptdt:=to_date(pd_rcptdate,''''||pdateformat||'''');
     v_supdt:=to_date(pd_supdate,''''||pdateformat||'''');
        
    If upper(pextra2)='D' then
        open p_accounts for
        select distinct nvl(var_unsold,0) as "V_UNSOLD",nvl(var_short_recpt,0) as "V_SHORT",
        nvl(var_damage,0) as "V_DAMAGE",nvl(var_late_recpt,0) as "V_LATEREC",nvl(var_bnr,0) as "V_BNR",
        nvl(apr_unsold,0) as "A_UNSOLD",nvl(apr_short_recpt,0) as "A_SHORT",
        nvl(apr_damage,0) as "A_DAMAGE",nvl(apr_late_recpt,0) as "A_LATEREC",nvl(apr_bnr,0) as "A_BNR"
        from cir_unsold_dtl_dis
        where comp_code=pcompcode and unit_code=punitcode and doctype=pdoctype and supdate=v_supdt
        and recptno=pd_rcptno and recptdt=v_recptdt and agcd=pd_agcode and dpcd=pd_agsubcode;
    
    Else 
        open p_accounts for
        select distinct nvl(var_unsold,0) as "V_UNSOLD",nvl(var_short_recpt,0) as "V_SHORT",
        nvl(var_damage,0) as "V_DAMAGE",nvl(var_late_recpt,0) as "V_LATEREC",nvl(var_bnr,0) as "V_BNR",
        nvl(apr_unsold,0) as "A_UNSOLD",nvl(apr_short_recpt,0) as "A_SHORT",
        nvl(apr_damage,0) as "A_DAMAGE",nvl(apr_late_recpt,0) as "A_LATEREC",nvl(apr_bnr,0) as "A_BNR"
        from cir_unsold_dtl
        where comp_code=pcompcode and unit_code=punitcode and doctype=pdoctype and supdate=v_supdt
        and recptno=pd_rcptno and recptdt=v_recptdt and agcd=pd_agcode and dpcd=pd_agsubcode;
     end if;

End;
/

-----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE procedure cir_unsold_detail_for_sanction(
    pcompcode       in  varchar2,
    punitcode       in  varchar2,
    pagcd           in  varchar2,
    pdpcd           in  varchar2,
    precptno        in  varchar2,
    precptdt        in  varchar2,    
    puserid         in  varchar2, 
    pdateformate    in  varchar2,
    pextra1         in  varchar2,
    pextra2         in  varchar2,--it is used for agency or distribution
    pextra3         in  varchar2,
    pextra4         in  varchar2,
    pextra5         in  varchar2,
    pextra6         in  varchar2,
    pextra7         in  varchar2,
    pextra8         in  varchar2,
    pextra9         in  varchar2,
    pextra10        in  varchar2,
    p_accounts      OUT cur_type_new1.cursor_type)
is
v_recptdt   date;
begin
    v_recptdt:=to_date(precptdt,''''||pdateformate||'''');
    
    if upper(pextra2)='D' then
        open p_accounts for
        select distinct d.comp_code as "COMP_CODE",d.unit_code as "UNIT_CODE",d.recptno as "RECPTNO",d.recptdt as "RECPTDT",h.doctype as "DOCTYPE",
        d.agcd as "AGCD",d.dpcd as "DPCD", d.branch_code as "BRANCH_CODE",d.publ as "PUBL", d.edtn as "EDTN",
        d.supdate as "SUPDATE", d.supply_copy as "SUPPLY_COPY", d."RATE_SUPPLY" as "RATE_SUPPLY", 
        d.var_short_recpt as "SHORT_RECPT", d.var_late_recpt as "LATE_RECPT",d.damage as "DAMAGE", 
        d."VAR_BNR" as "BNR", d.var_unsold as "UNSOLD", d.apr_short_recpt as "APR_SHORT_RECPT", d.apr_late_recpt as "APR_LATE_RECPT", d.apr_bnr as "APR_BNR",
        d.apr_unsold as "APR_UNSOLD",d.apr_damage as "APR_DAMAGE",d.copy_rate as "COPY_RATE",d.comm_rate as "COMM_RATE", d.waste_alw as "WASTE_ALW", d.waste_rate as "WASTE_RATE", 
        d.comm_catg_type as "COMM_CATG_TYPE", d.return_per as "RETURN_PER", d.sup_agcd as "SUP_AGCD", d.sup_dpcd as "SUP_DPCD",
        nvl(d.var_short_recpt,0)+nvl(d.var_late_recpt,0)+nvl(d.var_bnr,0)+nvl(d.var_unsold,0)+nvl(d.var_damage,0) as "NET_UNSOLD",
        nvl(d.apr_short_recpt,0)+nvl(d.apr_late_recpt,0)+nvl(d.apr_bnr,0)+nvl(d.apr_unsold,0)+nvl(d.apr_damage,0) as "NET_APPROVED"
        from cir_unsold_hdr_dis h,cir_unsold_dtl_dis d
        where h.comp_code=d.comp_code and h.comp_code=pcompcode and h.unit_code=d.unit_code and 
        h.unit_code=punitcode and h.doctype='UCN' and h.doctype=d.doctype and h.recptno=d.recptno and h.recptno=nvl(precptno,h.recptno) and
        h.recptdt=d.recptdt and h.recptdt=nvl(v_recptdt,h.recptdt) and
        h.agcd=d.agcd and h.agcd=pagcd and h.dpcd=d.dpcd and h.dpcd=pdpcd and 
        (nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0)+nvl(apr_damage,0))-
        (nvl(var_short_recpt,0)+nvl(var_late_recpt,0)+nvl(var_bnr,0)+nvl(var_unsold,0)+nvl(var_damage,0))>0
        order by recptdt,recptno,publ,edtn,supdate;
     else
        open p_accounts for
        select distinct d.comp_code as "COMP_CODE",d.unit_code as "UNIT_CODE",d.recptno as "RECPTNO",d.recptdt as "RECPTDT",h.doctype as "DOCTYPE", 
        d.agcd as "AGCD",d.dpcd as "DPCD", d.branch_code as "BRANCH_CODE",d.publ as "PUBL", d.edtn as "EDTN",
        d.supdate as "SUPDATE", d.supply_copy as "SUPPLY_COPY", d."RATE_SUPPLY" as "RATE_SUPPLY", 
        d.var_short_recpt as "SHORT_RECPT", d.var_late_recpt as "LATE_RECPT",d.damage as "DAMAGE", 
        d."VAR_BNR" as bnr, d.var_unsold as "UNSOLD", d.apr_short_recpt as "APR_SHORT_RECPT", d.apr_late_recpt as "APR_LATE_RECPT", d.apr_bnr as "APR_BNR",
        d.apr_unsold as "APR_UNSOLD",d.apr_damage as "APR_DAMAGE",d.copy_rate as "COPY_RATE",d.comm_rate as "COMM_RATE", d.waste_alw as "WASTE_ALW", d.waste_rate as "WASTE_RATE", 
        d.comm_catg_type as "COMM_CATG_TYPE", d.return_per as "RETURN_PER", d.sup_agcd as "SUP_AGCD", d.sup_dpcd as "SUP_DPCD",
        nvl(d.var_short_recpt,0)+nvl(d.var_late_recpt,0)+nvl(d.var_bnr,0)+nvl(d.var_unsold,0)+nvl(d.var_damage,0) as "NET_UNSOLD",
        nvl(d.apr_short_recpt,0)+nvl(d.apr_late_recpt,0)+nvl(d.apr_bnr,0)+nvl(d.apr_unsold,0)+nvl(d.apr_damage,0) as "NET_APPROVED"
        from cir_unsold_hdr h,cir_unsold_dtl d
        where h.comp_code=d.comp_code and h.comp_code=pcompcode and h.unit_code=d.unit_code and 
        h.unit_code=punitcode and h.doctype='UCN' and h.doctype=d.doctype and h.recptno=d.recptno and h.recptno=nvl(precptno,h.recptno) and 
        h.recptdt=d.recptdt and h.recptdt=nvl(v_recptdt,h.recptdt) and h.agcd=d.agcd and h.agcd=pagcd and h.dpcd=d.dpcd and h.dpcd=pdpcd and 
        (nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0)+nvl(apr_damage,0))-
        (nvl(var_short_recpt,0)+nvl(var_late_recpt,0)+nvl(var_bnr,0)+nvl(var_unsold,0)+nvl(var_damage,0))>0
        order by recptdt,recptno,publ,edtn,supdate;
     end if;
            

End cir_unsold_detail_for_sanction;
/

---------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE Cir_update_sanction_details
(
    puserid in varchar2,
    pcompcode in varchar2,
    punitcode in varchar2,
    psup_agcode in varchar2,
    psup_agsubcode in varchar2,
    pbranch in varchar2,
    preceiptno in varchar2,
    preceiptdate in varchar2,
    psup_date in varchar2,
    pa_unsold in    varchar2,
    pa_short in   varchar2,
    pa_damage in    varchar2,
    pa_bnr in  varchar2,
    pa_laterec in   varchar2,
    pdoctype in varchar2,
    pdateformat in varchar2,
    pextra1 in  varchar2,
    pextra2 in varchar2
) 

 is
    v_recptdt   date;
    v_supdt     date;
    
begin
     v_recptdt:=to_date(preceiptdate,''''||pdateformat||'''');
     v_supdt:=to_date(psup_date,''''||pdateformat||''''); 
    

    if upper(pextra2)='D' then
        UPDATE cir_unsold_dtl_dis set apr_short_recpt=apr_short_recpt+pa_short,apr_late_recpt=apr_late_recpt+pa_laterec,
        apr_bnr=apr_bnr+pa_bnr,apr_unsold=apr_unsold+pa_unsold,apr_damage=apr_damage+pa_damage,userid=puserid  
        WHERE comp_code=pcompcode and unit_code=punitcode and doctype=pdoctype
        and branch_code=pbranch and recptno=preceiptno and recptdt=v_recptdt
        and supdate=v_supdt and agcd=psup_agcode and dpcd=psup_agsubcode;
        commit;
    else
        UPDATE cir_unsold_dtl set apr_short_recpt=apr_short_recpt+pa_short,apr_late_recpt=apr_late_recpt+pa_laterec,
        apr_bnr=apr_bnr+pa_bnr,apr_unsold=apr_unsold+pa_unsold,apr_damage=apr_damage+pa_damage,userid=puserid  
        WHERE comp_code=pcompcode and unit_code=punitcode and doctype=pdoctype
        and branch_code=pbranch and recptno=preceiptno and recptdt=v_recptdt
        and supdate=v_supdt and agcd=psup_agcode and dpcd=psup_agsubcode;
        commit;
    end if;
end;
/

-----------------------------------------------------------------------------------------------
CREATE OR REPLACE procedure Cir_user_privilege(
    puserid in varchar2,
    pcompcode in varchar2,
    punitcode in varchar2,
    pbranch in varchar2,
    ppub in varchar2,
    pedn in varchar2,
    pextra1 in varchar2,
    pextra2 in varchar2,
    p_Accounts OUT Cur_Type_New1.cursor_type)
as

begin
    open p_Accounts for
    SELECT approval_per as "APPROVAL_PER" FROM cir_unsold_apr_permission 
    WHERE user_id = puserid and comp_code=pcompcode and printing_center=punitcode 
    and branch_code=pbranch and publ=ppub and sub_edtn=pedn;

end Cir_user_privilege;
/

//*****************************************end of 19th Jan***********************************************************************



/***********************issue no. 6357**********************start of 23 jan by rahul********************************************/
CREATE OR REPLACE FUNCTION HT18JULY.cir_get_state(pcomp_code in varchar2,pcount_code in varchar2,pstate_code in varchar2) RETURN varchar2 IS
vstate_name state_mst."State_Name"%type;
BEGIN
	Begin
    SELECT "State_Name" into vstate_name FROM state_mst where "Comp_Code"=pcomp_code and "Country_Code"=pcount_code and "State_Code"=pstate_code;
      exception when others then
	        vstate_name:=null;
	End;
  return nvl(vstate_name,'');
END;
/


CREATE OR REPLACE function HT18JULY.cir_get_dist(pcomp_code in varchar2,pstate_code in varchar2,pdist_code in varchar2) return varchar2 IS
vdist_name cir_dist_mast.dist_name%type;
BEGIN
	Begin
     select dist_name into vdist_name from cir_dist_mast where comp_code=pcomp_code and state_code=pstate_code and dist_code=pdist_code;
	      exception when others then
	                     vdist_name:=null;
	End;
  return nvl(vdist_name,'');
END;
/













/*******************************************end**************************************************************/



///===============================================Issue No. 6388 and 5550 30 jan 2012============================


///////////////////////////////////////////////body/////////////////////////////////////////////////////////////////

CREATE OR REPLACE PACKAGE BODY HT18JULY.cir_gen_lbl IS
procedure gen_lbl_print_no(
    pcomp_code        in varchar2,
    punit_code        in varchar2,
    pagcd             in varchar2,
    pdpcd             in varchar2,
    pedtn             in varchar2,
    proute            in varchar2,
    plbldt            in date,
    ppubl             in varchar2)
    As
    v_cnt             number:=0;
    v_tot_page         number:=0;
    v_lbl_no         number:=0;
    v_lbl_first     number:=0;
    v_lbl_second     number:=0;
    v_lbl_third     number:=0;
    v_last_lbl         number:=0;
    v_seq_no         number;

cursor c_lbl_first is
        select seq_no from cir_lblmast
             where comp_code = pcomp_code and
                   unit_code = punit_code and
                   ((agcd    = pagcd) or (pagcd is null)) and
                   ((dpcd    = pdpcd) or (pdpcd is null)) and
                   lbl_dt    = plbldt and
                   seq_no   <= v_lbl_first and
                   ((publ_1  = ppubl) or (ppubl is null)) and
                   ((edtn    = pedtn) or (pedtn is null)) and
                   ((route   = proute) or (proute is null)) and
                   lblty     = 'Y' and
                   ((edtn    = pedtn) or (pedtn is null))
       order by seq_no;

cursor c_lbl_second is
            select seq_no from cir_lblmast
                 where comp_code = pcomp_code and
                       unit_code = punit_code and
                      ((agcd     = pagcd) or (pagcd is null)) and
                      ((dpcd     = pdpcd) or (pdpcd is null)) and
                      lbl_dt     = plbldt and
                      seq_no    >= v_lbl_first+1 and
                      seq_no    <= v_lbl_first+v_lbl_second and
              ((publ_1   = ppubl) or (ppubl is null)) and
              ((edtn     = pedtn) or (pedtn is null)) and
              ((route    = proute) or (proute is null)) and
              lblty      = 'Y' and
              ((edtn     = pedtn) or (pedtn is null))
              order by seq_no;
cursor c_lbl_third is
            select seq_no from cir_lblmast
                where comp_code = pcomp_code and
                      unit_code = punit_code and
                            ((agcd    = pagcd) or (pagcd is null)) and
                            ((dpcd    = pdpcd) or (pdpcd is null)) and
                            lbl_dt    = plbldt and
                            seq_no   >= v_lbl_first+v_lbl_second+1 and
                            seq_no   <= v_lbl_first+v_lbl_second+v_lbl_third and
                            ((publ_1  = ppubl) or (ppubl is null)) and
                            ((edtn    = pedtn) or (pedtn is null)) and
                            ((route   = proute) or (proute is null)) and
                            lblty     = 'Y' and
                            ((edtn    = pedtn) or (pedtn is null))
               order by seq_no;
begin
--insert into test1 (vstring) values ('1upd_first_sequence('||pcomp_code||','||punit_code||','||pedtn||','||plbldt||','||pagcd||','||pdpcd||')');
  upd_first_sequence(pcomp_code,punit_code,pedtn,plbldt,pagcd,pdpcd);
--insert into test1 (vstring) values ('2upd_first_sequence('||pcomp_code||','||punit_code||','||pedtn||','||plbldt||','||pagcd||','||pdpcd||')');
commit;
     select count(*) into v_cnt from cir_lblmast
       where comp_code = pcomp_code and
             unit_code = punit_code and
             ((agcd    = pagcd) or (pagcd is null)) and
                   ((dpcd    = pdpcd) or (pdpcd is null)) and
                   lbl_dt    = plbldt and
                   ((publ_1  = ppubl) or (ppubl is null)) and
                   ((edtn    = pedtn) or (pedtn is null)) and
                   ((route   = proute) or (proute is null)) and
                     lblty     = 'Y' and
             ((edtn    = pedtn) or (pedtn is null));

  if nvl(v_cnt,0)>0 then
       select floor(v_cnt/3),decode(mod(v_cnt,3),0,0,1,1,2,1) into v_tot_page,v_lbl_no from dual;

          if v_lbl_no>0 then
              v_lbl_first:= v_tot_page+1;
          else
              v_lbl_first:= v_tot_page;
          end if;

          if v_lbl_no>1 then
              v_lbl_second:= v_tot_page+1;
          else
              v_lbl_second:= v_tot_page;
          end if;

          v_lbl_third:= v_tot_page;
        /* For Lable FIRST */
          v_last_lbl:=1;
          open c_lbl_first;
            loop
               fetch c_lbl_first into v_seq_no;
                   exit when c_lbl_first%notfound;
                         update cir_lblmast set lbl_print_no=v_last_lbl
                              where comp_code = pcomp_code and
                                    unit_code = punit_code and
                                    ((agcd    = pagcd) or (pagcd is null)) and
                                    ((dpcd    = pdpcd) or (pdpcd is null))    and
                                    lbl_dt    = plbldt and
                                    seq_no    = v_seq_no and
                                    ((publ_1  = ppubl) or (ppubl is null)) and
                                    lblty     = 'Y' and
                                    ((edtn    = pedtn) or (pedtn is null));
                        v_last_lbl:=v_last_lbl+3;
          end loop;
          close c_lbl_first;

         /* For Lable SECOND */
          v_last_lbl:=2;
          open c_lbl_second;
              loop
                  fetch c_lbl_second into v_seq_no;
                     exit when c_lbl_second%notfound;
                              update cir_lblmast set lbl_print_no=v_last_lbl
                                   where comp_code = pcomp_code and
                                         unit_code = punit_code and
                                         ((agcd    = pagcd) or (pagcd is null)) and
                                         ((dpcd    = pdpcd) or (pdpcd is null)) and
                                         lbl_dt    = plbldt and
                                         seq_no    = v_seq_no and
                                         ((publ_1  = ppubl) or (ppubl is null)) and
                                         lblty     = 'Y' and
                                         ((edtn    = pedtn) or (pedtn is null));
                         v_last_lbl:=v_last_lbl+3;
              end loop;
          close c_lbl_second;

            /* For Lable THIRD */
        v_last_lbl:=3;
            open c_lbl_third;
              loop
                 fetch c_lbl_third into v_seq_no;
                     exit when c_lbl_third%notfound;
                              update cir_lblmast set lbl_print_no=v_last_lbl
                                 where comp_code = pcomp_code and
                                       unit_code = punit_code and
                                       ((agcd    = pagcd) or (pagcd is null)) and
                                       ((dpcd    = pdpcd) or (pdpcd is null)) and
                                       lbl_dt    = plbldt and
                                       seq_no    = v_seq_no and
                                       ((publ_1  = ppubl) or (ppubl is null)) and
                                       lblty     = 'Y' and
                                       ((edtn    = pedtn) or (pedtn is null));
                       v_last_lbl:=v_last_lbl+3;
              end loop;
            close c_lbl_third;
  end if;
end gen_lbl_print_no;

procedure upd_first_sequence(
    pcomp_code     in varchar2,
    punit_code     in varchar2,
    pedtn         in varchar2,
    psupdate     in date,
    pagcd         in varchar2,
    pdpcd         in varchar2)
    As

cursor c_lblmst is
      select route,subrt,sub_subrt,agcd,dpcd,edtn,trunc(lbl_dt),lbl_sno,lbl_tno,lbl_lno,
           publ_1,edtn_1,supply_1
      from cir_lblmast
      where comp_code = pcomp_code and unit_code = punit_code and
            lbl_dt    = psupdate and edtn      = pedtn and
             ((agcd    = pagcd) or (pagcd is null)) and lblty     = 'Y'
         order by to_number(route_seqno),agcd,dpcd,lbl_sno,lbl_tno;
v_route           cir_lblmast.route%type;
v_subrt             cir_lblmast.subrt%type;
v_subsubrt          cir_lblmast.sub_subrt%type;
v_agcd            varchar2(10);
v_dpcd            varchar2(10);
v_lbl_dt             date;
v_lbl_sno         number;
v_lbl_tno         number;
v_lbl_lno         number;
v_publ_1             varchar2(3);
v_edtn_1             varchar2(3);
v_edtn            varchar2(3);
v_supply_1        number;
v_seq_no          number:=1;
v_lbl_tno_null     number:=0;
begin
  open c_lblmst;
  loop
      fetch c_lblmst into v_route,v_subrt,v_subsubrt,v_agcd,v_dpcd,v_edtn,v_lbl_dt,v_lbl_sno,v_lbl_tno,v_lbl_lno,
           v_publ_1,v_edtn_1,v_supply_1;
    exit when c_lblmst%notfound;
    update cir_lblmast set seq_no=v_seq_no
        where comp_code       =    pcomp_code and
              unit_code       = punit_code and
              lbl_dt            =    psupdate and
                     edtn                 = pedtn and
                     agcd                =    v_agcd and
                   dpcd                =    v_dpcd and
                     lbl_sno            =    v_lbl_sno and
                     lblty           = 'Y';
              v_lbl_tno_null := 0;
          select count(*) into v_lbl_tno_null
              from cir_lblmast
                 where comp_code = pcomp_code and
                       unit_code = punit_code and
                   lbl_dt    = psupdate and
                                    edtn      = pedtn and
                                    agcd      = v_agcd and
                                    dpcd      = v_dpcd    and
                                    lblty     = 'Y';
      if nvl(v_lbl_tno_null,0)>0 then
            update cir_lblmast set lbl_tno=v_lbl_tno_null
                  where comp_code = pcomp_code and
                        unit_code = punit_code and
                        lbl_dt    = psupdate and
                                   edtn      = pedtn and
                                   agcd      = v_agcd and
                                   dpcd      = v_dpcd and
                                   lbl_tno is null    and
                                   lblty     = 'Y';
          end if;
      v_seq_no    :=nvl(v_seq_no,0)+1;
      v_route        :=null; v_subrt        :=null;v_agcd        :=null; v_dpcd        :=null;v_edtn        :=null;
      v_lbl_dt    :=null; v_lbl_sno    :=null;v_lbl_tno    :=null;v_lbl_lno    :=null;v_publ_1    :=null;
      v_edtn_1    :=null; v_supply_1:=null;
   end loop;
  close c_lblmst;
end upd_first_sequence;

Procedure update_rec(
    pcomp_code         in varchar2,
    punit_code         in varchar2,
    ppubl             in varchar2,
    pedtn             in varchar2,
    psupdate         in date,
    pactual_sup     in number,
    pcount_pub         in varchar2,
    pseq_no         in number)
    As
begin
--_rec(ppub,pedtn,pactual_sup,pcount_pub,pseq_no)
     if pcount_pub = 1 then
           update cir_lblmast set publ_1 = ppubl,edtn_1 = pedtn,supply_1 = pactual_sup
               where comp_code = pcomp_code and
                     unit_code = punit_code and
                     lbl_dt    = psupdate and
                     seq_no    = pseq_no and
                     ((edtn    = pedtn) or (pedtn is null));
     elsif pcount_pub = 2 then
           update cir_lblmast set publ_2 = ppubl,edtn_2 = pedtn,supply_2 = pactual_sup
               where comp_code = pcomp_code and
                     unit_code = punit_code and
                     lbl_dt    = psupdate and
                     seq_no    = pseq_no and
                     ((edtn    = pedtn) or (pedtn is null));
     elsif pcount_pub = 3 then
           update cir_lblmast set publ_3 = ppubl,edtn_3 = pedtn,supply_3 = pactual_sup
               where comp_code = pcomp_code and
                     unit_code = punit_code and
                     lbl_dt    = psupdate and
                     seq_no    = pseq_no and
                     ((edtn    = pedtn) or (pedtn is null));
     elsif pcount_pub = 4 then
           update cir_lblmast set publ_4 = ppubl,edtn_4 = pedtn,supply_4 = pactual_sup
               where comp_code = pcomp_code and
                     unit_code = punit_code and
                     lbl_dt    = psupdate and
                     seq_no    = pseq_no and
                     ((edtn    = pedtn) or (pedtn is null));
     end if;
end update_rec;

procedure ad_lblmst(
    magcd           in varchar2,
    mdpcd           in varchar2,
    medtn           in varchar2,
    mroute          in varchar2,
    msubrt          in varchar2,
    msubsubrt       in varchar2,
    mname           in varchar2,
    mhname          in varchar2,
    mastn           in varchar2,
    p_ldt           in date,
    p_rtnm          in varchar2,
    p_rthnm         in varchar2,
    p_sno           in number,
    p_tno           in number,
    p_msg1          in varchar2,
    p_msg2          in varchar2,
    p_msg3          in varchar2,
    p_tcp1          in number,
    p_tcp2          in number,
    p_tcp3          in number,
    p_cp1           in number,
    p_cp2           in number,
    p_cp3           in number,
    rem_copy        in number,
    pkt_size        in number,
    mlblln7         in varchar2,
    ppub            in varchar2,
    pedtn           in varchar2,
    pactual_sup     in number,
    pseq_no         in number,
    pcount_pub      in number,
    ppubl           in varchar2,
    p_coag          in varchar2,
    p_codp          in varchar2,
    p_agty          in varchar2,
    pweek_dl        in varchar2,
    proute_print_slno   in number,
    pastn_print_slno    in number,
    plblty              in varchar2,
    punit_code          in varchar2,
    pcomp_code          in varchar2,
    psubrtnm            in varchar2,
    psubrtonm           in varchar2,
    psubsubrtnm         in varchar2,
    psubsubrtonm        in varchar2,
    pcity_oname         in varchar2,
    pstation_name       in varchar2,
    pstation_oname      in varchar2,
    ppubl_name          in varchar2,
    psup_rate           in number,
    ppin_open_in        in varchar2,
    plbl_printno        in number,
    pdistseqno          in number,
    pdistcode           in varchar2,
    punpaid_copy        in number,
    psup_name           in varchar2) is

    v_edtnonm varchar2(200);
    mdistnm  cir_lblmast.distname%type;
    mdistonm cir_lblmast.distoname%type;
BEGIN
    begin
        select nvl(edtn_name_oth_lang,edtn_name) into v_edtnonm from cir_edtn_mast
            where comp_code=pcomp_code and edtn=pedtn;
    exception when others then
       v_edtnonm:=ppubl_name;
    end;
    begin
        select nvl(dist_alias,dist_name),dist_oname into mdistnm,mdistonm from cir_dist_mast where comp_code=pcomp_code  and dist_code=pdistcode;
    exception when others then
     mdistnm:=null;mdistonm:=null;
    end;
    /*insert into test1 (vstring) values (pcount_pub||','||punit_code||','||magcd||','||mdpcd||','||p_ldt||','||medtn||','||
                                 mroute||','||msubrt||','||msubsubrt||','||p_rtnm||','||p_rthnm||','||p_sno||','||
                                 p_tno||','||p_msg1||','||p_msg2||','||p_msg3||','||mname||','||mhname||','||
                                 mastn||','||p_tcp1||','||p_tcp2||','||p_tcp3||','||p_cp1||','||p_cp2||','||p_cp3||','||
                                 rem_copy||','||pkt_size||','||mlblln7||','||
                                 ppub||','||pedtn||','||pactual_sup||','||pseq_no||','||
                                 ppubl||','||p_coag||','||p_codp||','||p_agty||','||pweek_dl||','||
                                 proute_print_slno||','||pastn_print_slno||','||plblty||','||pcomp_code||','||
                                 psubrtnm||','||psubrtonm||','||psubsubrtnm||','||psubsubrtonm||' ppin_open_in '||ppin_open_in);commit;*/
     if pcount_pub = 1 then
        /*insert into test1 (vstring) values (punit_code||','||magcd||','||mdpcd||','||p_ldt||','||medtn||','||
                                 mroute||','||msubrt||','||msubsubrt||','||p_rtnm||','||p_rthnm||','||p_sno||','||
                                 p_tno||'p_tno,'||p_msg1||','||p_msg2||','||p_msg3||','||mname||','||mhname||','||
                                 mastn||','||p_tcp1||','||p_tcp2||','||p_tcp3||','||p_cp1||','||p_cp2||','||p_cp3||','||
                                 rem_copy||','||pkt_size||','||mlblln7||','||
                                 ppub||','||pedtn||','||pactual_sup||','||pseq_no||','||
                                 ppubl||','||p_coag||','||p_codp||','||p_agty||','||pweek_dl||','||
                                 proute_print_slno||','||pastn_print_slno||','||plblty||','||pcomp_code||','||
                                 psubrtnm||','||psubrtonm||','||psubsubrtnm||','||psubsubrtonm);*/
           insert into cir_lblmast (unit_code,agcd,dpcd,lbl_dt,edtn,
                                 route,subrt,sub_subrt,rtnm,rtonm,
                                 lbl_sno,lbl_tno,msg_1,msg_2,msg_3,
                                 agname,agoname,city_name,tcp1,tcp2,
                                 tcp3,cp1,cp2,cp3,lbl_lno,
                                 pkt_size,lblln5,publ_1,edtn_1,supply_1,
                                 seq_no,publ,coag,codp,agty,
                                 period,route_seqno,city_seqno,lblty,comp_code,
                                 subrtnm,subrtonm,subsubrtnm,subsubrtonm,city_oname,
                                 station_name,station_oname,publ_name,sup_rate,pin_open_inside,lbl_print_no,
                                 dist_seqno,distname,distoname,distcode,unpaid_copy,supply_type)
                          values(punit_code,magcd,mdpcd,to_date(to_char(p_ldt),'dd-mon-yy'),medtn,
                                 mroute,msubrt,msubsubrt,p_rtnm,p_rthnm,
                                 p_sno,p_tno,p_msg1,p_msg2,p_msg3,
                                 mname,mhname,mastn,p_tcp1,p_tcp2,
                                 p_tcp3,p_cp1,p_cp2,p_cp3,rem_copy,
                                 pkt_size,mlblln7,ppub,pedtn,pactual_sup,
                                 pseq_no,ppubl,p_coag,p_codp,p_agty,
                                 pweek_dl,proute_print_slno,pastn_print_slno,plblty,pcomp_code,
                                 psubrtnm,psubrtonm,psubsubrtnm,psubsubrtonm,pcity_oname,
                                 pstation_name,pstation_oname,v_edtnonm,psup_rate,ppin_open_in,plbl_printno,
                                 pdistseqno,mdistnm,mdistonm,pdistcode,punpaid_copy,psup_name);
           commit;
     elsif pcount_pub = 2 then

        insert into cir_lblmast (unit_code,agcd,dpcd,lbl_dt,edtn,
                                 route,subrt,sub_subrt,rtnm,rtonm,lbl_sno,
                                 lbl_tno,msg_1,msg_2,msg_3,agname,agoname,
                                 city_name,tcp1,tcp2,tcp3,cp1,cp2,cp3,
                                 LBL_LNO,pkt_size,lblln5,
                                 publ_2,edtn_2,supply_2,seq_no,
                                 publ,coag,codp,agty,period,route_seqno,city_seqno,lblty,comp_code,
                                 subrtnm,subrtonm,subsubrtnm,subsubrtonm,city_oname,
                                 station_name,station_oname,publ_name,sup_rate,pin_open_inside,lbl_print_no,
                                 dist_seqno,distname,distoname,distcode,unpaid_copy,supply_type)
                         values (punit_code,magcd,mdpcd,to_date(to_char(p_ldt),'dd-mon-yy'),medtn,
                                 mroute,msubrt,msubsubrt,p_rtnm,p_rthnm,p_sno,
                                 p_tno,p_msg1,p_msg2,p_msg3,mname,mhname,
                                 mastn,p_tcp1,p_tcp2,p_tcp3,p_cp1,p_cp2,p_cp3,
                                 rem_copy,pkt_size,mlblln7,
                                 ppub,pedtn,pactual_sup,pseq_no,
                                 ppubl,p_coag,p_codp,p_agty,pweek_dl,
                                 proute_print_slno,pastn_print_slno,plblty,pcomp_code,
                                 psubrtnm,psubrtonm,psubsubrtnm,psubsubrtonm,pcity_oname,
                                 pstation_name,pstation_oname,v_edtnonm,psup_rate,ppin_open_in,plbl_printno,
                                 pdistseqno,mdistnm,mdistonm,pdistcode,punpaid_copy,psup_name);
           commit;
     elsif pcount_pub = 3 then

        insert into cir_lblmast (unit_code,agcd,dpcd,lbl_dt,edtn,
                                 route,subrt,sub_subrt,rtnm,rtonm,lbl_sno,
                                 lbl_tno,msg_1,msg_2,msg_3,agname,agoname,
                                 city_name,tcp1,tcp2,tcp3,cp1,cp2,cp3,
                                 LBL_LNO,pkt_size,lblln5,
                                 publ_3,edtn_3,supply_3,seq_no,
                                 publ,coag,codp,agty,period,route_seqno,city_seqno,lblty,comp_code,
                                 subrtnm,subrtonm,subsubrtnm,subsubrtonm,city_oname,
                                 station_name,station_oname,publ_name,sup_rate,pin_open_inside,lbl_print_no,
                                 dist_seqno,distname,distoname,distcode,unpaid_copy,supply_type)
                         values (punit_code,magcd,mdpcd,to_date(to_char(p_ldt),'dd-mon-yy'),medtn,
                                 mroute,msubrt,msubsubrt,p_rtnm,p_rthnm,p_sno,
                                 p_tno,p_msg1,p_msg2,p_msg3,mname,mhname,
                                 mastn,p_tcp1,p_tcp2,p_tcp3,p_cp1,p_cp2,p_cp3,
                                 rem_copy,pkt_size,mlblln7,
                                 ppub,pedtn,pactual_sup,pseq_no,
                                 ppubl,p_coag,p_codp,p_agty,pweek_dl,
                                 proute_print_slno,pastn_print_slno,plblty,pcomp_code,
                                 psubrtnm,psubrtonm,psubsubrtnm,psubsubrtonm,pcity_oname,
                                 pstation_name,pstation_oname,v_edtnonm,psup_rate,ppin_open_in,plbl_printno,
                                 pdistseqno,mdistnm,mdistonm,pdistcode,punpaid_copy,psup_name);
           commit;
     elsif pcount_pub = 4 then
        insert into cir_lblmast (unit_code,agcd,dpcd,lbl_dt,edtn,
                                 route,subrt,sub_subrt,rtnm,rtonm,lbl_sno,
                                 lbl_tno,msg_1,msg_2,msg_3,agname,agoname,
                                 city_name,tcp1,tcp2,tcp3,cp1,cp2,cp3,
                                 LBL_LNO,pkt_size,lblln5,
                                 publ_4,edtn_4,supply_4,seq_no,
                                 publ,coag,codp,agty,period,route_seqno,city_seqno,lblty,comp_code,
                                 subrtnm,subrtonm,subsubrtnm,subsubrtonm,city_oname,
                                 station_name,station_oname,publ_name,sup_rate,pin_open_inside,lbl_print_no,
                                 dist_seqno,distname,distoname,distcode,unpaid_copy,supply_type)
                         values (punit_code,magcd,mdpcd,to_date(to_char(p_ldt),'dd-mon-yy'),medtn,
                                 mroute,msubrt,msubsubrt,p_rtnm,p_rthnm,p_sno,
                                 p_tno,p_msg1,p_msg2,p_msg3,mname,mhname,
                                 mastn,p_tcp1,p_tcp2,p_tcp3,p_cp1,p_cp2,p_cp3,
                                 rem_copy,pkt_size,mlblln7,
                                 ppub,pedtn,pactual_sup,pseq_no,
                                 ppubl,p_coag,p_codp,p_agty,pweek_dl,
                                 proute_print_slno,pastn_print_slno,plblty,pcomp_code,
                                 psubrtnm,psubrtonm,psubsubrtnm,psubsubrtonm,pcity_oname,
                                 pstation_name,pstation_oname,v_edtnonm,psup_rate,ppin_open_in,plbl_printno,
                                 pdistseqno,mdistnm,mdistonm,pdistcode,punpaid_copy,psup_name);
           commit;
     end if;
     if psup_name is null then
         update cir_lblmast set lbl_tno=(select count(*) from cir_lblmast
                                                where comp_code=pcomp_code and
                                                      unit_code=punit_code and
                                                      --publ=ppubl and
                                                      edtn=medtn and
                                                      agcd=magcd and
                                                      dpcd=mdpcd and
                                                      lbl_dt=to_date(to_char(p_ldt),'dd-mon-yy'))
                             where comp_code=pcomp_code and
                                  unit_code=punit_code and
                                  --publ=ppubl and
                                  edtn=medtn and
                                  agcd=magcd and
                                  dpcd=mdpcd and
                                  lbl_dt=to_date(to_char(p_ldt),'dd-mon-yy');
    else
        update cir_lblmast set lbl_tno=(select count(*) from cir_lblmast
                                            where comp_code=pcomp_code and
                                                  unit_code=punit_code and
                                                  --publ=ppubl and
                                                  edtn=medtn and
                                                  agcd=magcd and
                                                  dpcd=mdpcd and
                                                  lbl_dt=to_date(to_char(p_ldt),'dd-mon-yy') and
                                                  supply_type=psup_name)
                         where comp_code=pcomp_code and
                              unit_code=punit_code and
                              --publ=ppubl and
                              edtn=medtn and
                              agcd=magcd and
                              dpcd=mdpcd and
                              lbl_dt=to_date(to_char(p_ldt),'dd-mon-yy') and
                              supply_type=psup_name;
    end if;
END ad_lblmst;

procedure cir_gen_lbl_p(
    pcomp_code      in varchar2,
    punit_code      in varchar2,
    ppubl_code      in varchar2,
    pedtn_code      in varchar2,
    proute_code     in varchar2,
    pagcd           in varchar2,
    pdpcd           in varchar2,
    psupdate        in varchar2,
    ppkt_size       in number,
    padjust_copy    in number,
    pperiod         in number,
    pdateformat     in varchar2,
    pextra1         in varchar2,--it is used for lable type ---Combined(C)/Supply Type Wise(S)
    pextra2         in varchar2) --for sub  edition
As
Begin
    --insert into test1 (vstring) values ('Sushil'||pcomp_code||',1,'||punit_code||',2,'||ppubl_code||',3,'||pedtn_code||',4,'||
      --                              pagcd||',5,'||pdpcd||',6,'||psupdate||',7,'||ppkt_size||',8,'||pperiod||',9,'||pdateformat||',10,'||
        --                          pextra1||',11,'||pextra2);commit;
     declare
          test_pub_before varchar2(10);
          test_pub_after  varchar2(10);
          mroute          cir_lblmast.route%type;
          msubrt          cir_lblmast.subrt%type;
          msubsubrt       cir_lblmast.sub_subrt%type;
          t_rtnm          cir_lblmast.rtnm%type;
          t_hrtnm         cir_lblmast.rtonm%type;
          t_subrtnm       cir_lblmast.subrtnm%type;
          t_subrtonm      cir_lblmast.subrtonm%type;
          t_subsubrtnm    cir_lblmast.subsubrtnm%type;
          t_subsubrtonm   cir_lblmast.subsubrtonm%type;
          mname           cir_lblmast.agname%type;
          mastn           cir_lblmast.city_name%type;
          vcity_oname     cir_lblmast.city_oname%type;
          vstation_name   cir_lblmast.station_name%type;
          vstation_oname  cir_lblmast.station_oname%type;
          mpin            cir_agmast.pin_packet%type;
          mpinag          cir_agmast.pin_agcd%type;
          mpindp          cir_agmast.pin_dpcd%type;
          vcoag           varchar2(10);
          vcodp           varchar2(10);
          vagty           varchar2(20);
          vpin_name       varchar2(40) := ' ';
          vmessage        varchar2(50) := ' ';
          msupflg         varchar2(1);
          mpkt            number;
          mlblln7         varchar2(35);
          msusp           varchar2(1);
          vsupdate        date;
  cursor sup_cur is
        select distinct x.comp_code comp_code,x.unit_code unit_code,x.publ publ,x.edtn edtn,x.route_code route_code,x.subroute_code subroute_code,x.subsubroute_code subsubroute_code,
           x.supdate supdate,x.agcd agcd,x.dpcd dpcd,x.agency_ty_code agency_ty_code,sum(x.rsup) as rsup,x.sup_rate sup_rate,
           x.supply_seqno supply_seqno, x.route_seqno route_seqno,x.edtn_seqno edtn_seqno,x.dist_seqno dist_seqno,x.dist_code dist_code,
           x.print_seq print_seq,x.sup_type_code sup_type_code from
        (select distinct d.comp_code comp_code,d.unit_code unit_code,d.publ publ,d.edtn edtn,d.route_code route_code,d.subroute_code subroute_code,d.subsubroute_code subsubroute_code,
           d.supdate supdate,d.agcd agcd,d.dpcd dpcd,d.agency_ty_code agency_ty_code,sum(nvl(d.sup_copy,0)) as rsup,d.sup_rate,
           cir_get_supply_seqno(d.comp_code,d.unit_code,d.publ,d.edtn,d.agcd,d.dpcd) supply_seqno,
           cir_get_route_seqno(d.comp_code,d.unit_code,d.route_code) route_seqno,cir_get_edtn_seqno(d.comp_code,d.edtn) edtn_seqno,
           cir_get_dist_seqno(d.comp_code,m.dist_code) dist_seqno,m.dist_code dist_code,m.print_seq print_seq,null sup_type_code
                      from cir_dbksup d,cir_agmast m
                         where d.comp_code=pcomp_code and d.comp_code=m.comp_code and d.unit_code = punit_code and d.unit_code=m.unit and
                               d.supdate = vsupdate and d.edtn in (select distinct edtn from cir_edtn_mast
                               where comp_code=d.comp_code and publ = d.publ and edtn=d.edtn and edtn=nvl(pextra2,edtn) and
                               ((nvl(main_edtn,edtn) = pedtn_code ) or (pedtn_code  is null))) and
                               d.publ in (select distinct publ from cir_publ_mast
                                   where comp_code=d.comp_code and (publ = ppubl_code  or ppubl_code is null) and period=pperiod) and
                               d.agcd=m.agcd and d.dpcd=m.dpcd and nvl(m.print_label,'N') = 'Y' and (d.agcd =pagcd or pagcd is null) and
                               (d.dpcd =pdpcd or pdpcd is null) and nvl(d.sup_copy,0)>0 and (route_code=proute_code or proute_code is null) and nvl(pextra1,'C')='C'
                         group by d.comp_code,d.unit_code,d.publ,d.edtn,d.route_code,d.subroute_code,d.subsubroute_code,d.supdate,d.agcd,d.dpcd,d.agency_ty_code,d.sup_rate,m.dist_code,m.print_seq
        union
        select distinct d.comp_code comp_code,d.unit_code unit_code,d.publ publ,d.edtn edtn,d.route_code route_code,d.subroute_code subroute_code,d.subsubroute_code subsubroute_code,
           d.supdate supdate,d.agcd agcd,d.dpcd dpcd,d.agency_ty_code agency_ty_code,sum(nvl(d.sup_copy,0)) as rsup,d.sup_rate,
           cir_get_supply_seqno(d.comp_code,d.unit_code,d.publ,d.edtn,d.agcd,d.dpcd) supply_seqno,
           cir_get_route_seqno(d.comp_code,d.unit_code,d.route_code) route_seqno,cir_get_edtn_seqno(d.comp_code,d.edtn) edtn_seqno,
           cir_get_dist_seqno(d.comp_code,m.dist_code) dist_seqno,m.dist_code dist_code,m.print_seq print_seq,d.sup_type_code sup_type_code
                      from cir_dbksup d,cir_agmast m
                         where d.comp_code=pcomp_code and d.comp_code=m.comp_code and d.unit_code = punit_code and d.unit_code=m.unit and
                               d.supdate = vsupdate and d.edtn in (select distinct edtn from cir_edtn_mast
                               where comp_code=d.comp_code and publ = d.publ and edtn=d.edtn and edtn=nvl(pextra2,edtn) and
                               ((nvl(main_edtn,edtn) = pedtn_code ) or (pedtn_code  is null))) and
                               d.publ in (select distinct publ from cir_publ_mast
                                   where comp_code=d.comp_code and (publ = ppubl_code  or ppubl_code is null) and period=pperiod) and
                               d.agcd=m.agcd and d.dpcd=m.dpcd and nvl(m.print_label,'N') = 'Y' and (d.agcd =pagcd or pagcd is null) and
                               (d.dpcd =pdpcd or pdpcd is null) and nvl(d.sup_copy,0)>0 and (route_code=proute_code or proute_code is null) and nvl(pextra1,'C')='S'
                         group by d.comp_code,d.unit_code,d.publ,d.edtn,d.route_code,d.subroute_code,d.subsubroute_code,d.supdate,d.agcd,d.dpcd,d.agency_ty_code,d.sup_rate,m.dist_code,m.print_seq,d.sup_type_code) x
                         group by x.comp_code ,x.unit_code,x.publ,x.edtn ,x.route_code ,x.subroute_code ,x.subsubroute_code,
           x.supdate,x.agcd,x.dpcd,x.agency_ty_code,x.sup_rate,x.supply_seqno,x.route_seqno,x.edtn_seqno,x.dist_seqno,x.dist_code,x.print_seq,x.sup_type_code
                         order by comp_code,unit_code,publ,edtn_seqno,edtn,route_seqno,route_code,supply_seqno,print_seq,agcd,dpcd;

    sup_rec sup_cur%rowtype;
    vseq_no           number := 0;
    curr_agcd         varchar2(30) := 'dummy_curr'; -- both should have diff. values initially so that we can enter 1st time in if
    prev_agcd         varchar2(30) := 'dummy_prev';

    cursor cr_pin_cur is
     select substr(ag_name,1,40) name
         from cir_agmast
           where comp_code = pcomp_code and
                 unit      = punit_code and
                 agcd      = mpinag and
                 dpcd      = mpindp;

    cursor con_sup_cur is
         select (nvl(supply_1,0) + nvl(supply_2,0) +nvl(supply_3,0) +nvl(supply_4,0))
               from cir_lblmast
                 where comp_code  = pcomp_code and
                       unit_code  =  punit_code and
                       lbl_dt     = vsupdate and
                       agcd||dpcd = prev_agcd and
                       seq_no     = vseq_no
                       /*and (FEDN=pedtn_code OR pedtn_code IS NULL)*/;
    cursor sum_cur is
    select nvl(supply_1,0),nvl(supply_2,0),nvl(supply_3,0),nvl(supply_4,0),publ_1,publ_2,publ_3,publ_4,agcd,dpcd
        from cir_lblmast
               where  comp_code  = pcomp_code and
                      unit_code  = punit_code and
                      lbl_dt     = vsupdate and
                      agcd||dpcd = prev_agcd and
                      seq_no     = vseq_no
                      /*and (FEDN=pedtn_code OR pedtn_code IS NULL)*/;

    cursor daily_publ_cur is  -- cursor of record to be updated
    select publ_1,publ_2,publ_3,publ_4,agcd,dpcd
         from cir_lblmast
           where comp_code  = pcomp_code and
                 unit_code  = punit_code and
                 lbl_dt     = vsupdate and
                 agcd||dpcd = prev_agcd and
                 seq_no     = vseq_no - 1
         /*and (FEDN=pedtn_code OR pedtn_code IS NULL)*/;

    cursor sum_week_cur is
    select nvl(supply_1,0),nvl(supply_2,0),nvl(supply_3,0),nvl(supply_4,0)
      from cir_lblmast
             where comp_code  = pcomp_code and
                   unit_code  = punit_code and
                   lbl_dt     = vsupdate and
                   agcd||dpcd||publ = prev_agcd  and
                   seq_no           = vseq_no
           /*and (FEDN=pedtn_code OR pedtn_code IS NULL)*/;
    cursor packet is
    select  distinct nvl(packet_size,0),lbl_printno
       from cir_supply
        where comp_code  = pcomp_code and
              unit       = punit_code and
              publ       = sup_rec.publ and
              edtn       = sup_rec.edtn and
              agcd       = sup_rec.agcd and
              dpcd       = sup_rec.dpcd;

    cursor master is
         select * from cir_agmast a
            where a.comp_code = pcomp_code and a.unit = punit_code and
                  a.agcd = sup_rec.agcd and a.dpcd = sup_rec.dpcd;
    rec_master master%rowtype;
  vlblty                varchar2(1);
  bal_pktsize           number:=0;
  count_pub             number:=0;
  count_lbl             number:=0;
  actual_sup            number:=0;
  bal_sup               number:=0;
  consumed_sup          number:=0;
  last_label_copy       number;
  total_supply          number;
  vsup_1                number;
  vsup_2                number;
  vsup_3                number;
  vsup_4                number;
  vpubl_1               varchar2(20);
  vpubl_2               varchar2(20);
  vpubl_3               varchar2(20);
  vpubl_4               varchar2(20);
  current_publ_1        varchar2(20);
  current_publ_2        varchar2(20);
  current_publ_3        varchar2(20);
  current_publ_4        varchar2(20);
  vpacket_size          number;
  abcd                  number;
  AGCD1                 varchar2(8);
  AGCD2                 varchar2(8);
  DPCD1                 varchar2(8);
  DPCD2                 varchar2(8);
  tot_count_rec         number := 0;
  pktsize               number;
  mhname                varchar2(100);
  route_print_slno      varchar2(100);
  astn_print_slno       varchar2(100);
  vdist_seqno           varchar2(100);
  mlblty                varchar2(100);
  vpin_open_in             varchar2(10);
  v_alert_text          cir_agmast.alert_text%type;
      cursor c_route is
          select route_seqno,route,publ,edtn,agcd,dpcd,seq_no from cir_lblmast
              where comp_code=pcomp_code and unit_code=punit_code and
              lbl_dt = vsupdate and (publ  = ppubl_code or ppubl_code is null)
              order by route_seqno,route,publ,seq_no,agcd,dpcd;
  v_route c_route%rowtype;

  v_lbl_printno number:=1;
  v_lbl_lno number:=0;
  v_unpaid_copy number(6);
  v_unpaid_bal  number(6);
  v_sup_name    varchar(40);
  BEGIN
   vsupdate:=to_date(psupdate,''''||pdateformat||'''');
   --vsupdate:='16-SEP-2009';

   delete from cir_lblmast
       where comp_code = pcomp_code and unit_code=punit_code and
             lbl_dt = vsupdate and (publ  = ppubl_code or ppubl_code is null) and
             (edtn = pextra2 or pextra2 is null) and publ in (select distinct publ from cir_publ_mast
              where comp_code=pcomp_code and (publ = ppubl_code  or ppubl_code is null) and period=pperiod);
   open sup_cur;
   loop
     fetch sup_cur into sup_rec;
     exit when sup_cur%notfound;

        --if define packet size in agency master
        open packet;
        fetch packet into pktsize,v_lbl_printno;
        close packet;

        if nvl(pktsize,0)<=0 then
           vpacket_size := nvl(ppkt_size,0);
        else
           vpacket_size := nvl(pktsize,0);
        end if;

        if pperiod = 7 then
           curr_agcd     := sup_rec.agcd||sup_rec.dpcd;
        else
           curr_agcd     := sup_rec.agcd||sup_rec.dpcd||sup_rec.edtn||sup_rec.sup_type_code||sup_rec.dist_seqno;
           --insert into test1 (vstring) values (psupdate||vsupdate||pdateformat||'1Sushil'||sup_rec.agcd||sup_rec.dpcd||sup_rec.publ||','||pcomp_code||',1,'||punit_code||',2,'||ppubl_code||',3,'||pedtn_code||',4,'||pagcd||',5,'||pdpcd||',6,'||psupdate||',7,'||ppkt_size||',8,'||pperiod||',9,'||pdateformat||',10,'||pextra1||',11,'||pextra2);commit;
        end if;

        if curr_agcd <> prev_agcd then --1st time
            mpin := null;
            open master;
            fetch master into rec_master;
            close master;
            Begin
                mroute          :=sup_rec.route_code;
                t_rtnm          :=cir_get_route(pcomp_code,punit_code,sup_rec.route_code,t_hrtnm);
                msubrt          :=sup_rec.subroute_code;
                t_subrtnm       :=cir_get_subroute(pcomp_code,punit_code,sup_rec.route_code,sup_rec.subroute_code,t_subrtonm);
                msubsubrt       :=sup_rec.subsubroute_code;
                t_subsubrtnm    :=cir_get_sub_subroute(pcomp_code,punit_code,sup_rec.route_code,sup_rec.subroute_code,sup_rec.subsubroute_code,t_subsubrtonm);
                mname           :=rec_master.ag_name;
                --mhname          :=nvl(rec_master.name_on_label,rec_master.ag_name_oth_lang);
                mhname          :=rec_master.name_on_label;
                mastn           :=cir_get_city_name(pcomp_code,rec_master.city_code,vcity_oname);
                mlblty          :=rec_master.print_label;
                vstation_name   :=cir_get_drop_point_name(pcomp_code,punit_code,rec_master.station_code,1);
                vstation_oname  :=cir_get_drop_point_name(pcomp_code,punit_code,rec_master.station_code,2);
                route_print_slno:=sup_rec.route_seqno;
                astn_print_slno :=cir_get_drop_seqno(pcomp_code,punit_code,rec_master.station_code);
                vdist_seqno     :=sup_rec.dist_seqno;
                vagty           :=sup_rec.agency_ty_code;
                v_alert_text    :=rec_master.alert_text;
                v_sup_name      :=cir_get_supply_name(pcomp_code,sup_rec.sup_type_code);
            Exception when others then
               Null;
            End;
            vpin_open_in    :=rec_master.pin_open_inside;
            --INSERT INTO TEST1(VSTRING,VSTRING2) VALUES(' rec_master '||sup_rec.agcd||' , '||sup_rec.dpcd||' , '||rec_master.pin_open_inside,'vpin_open_in '||vpin_open_in);

            if vlblty = 'O' then
                pktsize := 99999;  ---for open packet
            else
                pktsize := nvl(vpacket_size,0);
            end if;
            --update for a agcd and dpcd;  -- will not be useful 1st time

            if pperiod = 7 then
                vsup_1  := 0;
                vsup_2  := 0;
                vsup_3  := 0;
                vsup_4  := 0;
                vpubl_1 := null;
                vpubl_2 := null;
                vpubl_3 := null;
                vpubl_4 := null;

                open sum_cur;
                fetch sum_cur into vsup_1,vsup_2,vsup_3,vsup_4,vpubl_1,vpubl_2,vpubl_3,vpubl_4,AGCD1,DPCD1;
                close sum_cur;

                current_publ_1 := null;
                current_publ_2 := null;
                current_publ_3 := null;
                current_publ_4 := null;

                open daily_publ_cur;
                fetch daily_publ_cur into current_publ_1,current_publ_2,current_publ_3,current_publ_4,AGCD2,DPCD2;
                close daily_publ_cur;
            else
                open sum_week_cur;
                fetch sum_week_cur into vsup_1,vsup_2,vsup_3,vsup_4;
                close sum_week_cur;
            end if;

        ------CASE 1 :  WRITE
               last_label_copy := nvl(vsup_1,0)+nvl(vsup_2,0)+nvl(vsup_3,0)+nvl(vsup_4,0);
            tot_count_rec   := 0 ;
            select count(*) into tot_count_rec
                  from cir_lblmast
                    where comp_code    = comp_code and
                          unit_code    = punit_code and
                          agcd||dpcd   = prev_agcd  and
                          lbl_dt = vsupdate;
            if (nvl(last_label_copy,0) > 0 and nvl(last_label_copy,0) <25) and nvl(tot_count_rec,0) > 1 then
                if pperiod = 7 then
                    NULL;
                    if vpubl_1 is null then
                        vpubl_1 := current_publ_1;
                    end if;

                    if vpubl_2 is null then
                        vpubl_2 := current_publ_2;
                    end if;

                    if vpubl_3 is null then
                        vpubl_3 := current_publ_3;
                    end if;

                    if vpubl_4 is null then
                        vpubl_4 := current_publ_4;
                    end if;

                    update cir_lblmast
                        set  supply_1     = nvl(supply_1,0) + vsup_1,
                             supply_2     = nvl(supply_2,0) + vsup_2,
                             supply_3     = nvl(supply_3,0) + vsup_3,
                             supply_4     = nvl(supply_4,0) + vsup_4,
                             publ_1      = vpubl_1,
                             publ_2     = vpubl_2,
                             publ_3       = vpubl_3,
                             publ_4       = vpubl_4
                    where comp_code  = pcomp_code and
                          unit_code  = punit_code and
                          lbl_dt     = vsupdate and
                          agcd||dpcd = prev_agcd and
                          ((edtn     = pedtn_code) or (pedtn_code is null)) and
                          seq_no     = vseq_no - 1 /*week_dl = :week_daily and */
                          ;
                  if sql%found then
                     delete from cir_lblmast
                            where comp_code  = pcomp_code and
                                  unit_code  = punit_code and
                                  lbl_dt     = vsupdate and
                                  agcd||dpcd = prev_agcd and
                                  seq_no     = vseq_no
                                   /*and (FEDN=pedtn_code OR pedtn_code is null)*/;
                     vseq_no     := nvl(vseq_no,0)- 1;
                     count_lbl:= nvl(count_lbl,0) -    1;
                  end if;
                else
                    update cir_lblmast
                        set  supply_1 = nvl(supply_1,0) + nvl(vsup_1,0),
                             supply_2 = nvl(supply_2,0) + nvl(vsup_2,0),
                             supply_3 = nvl(supply_3,0) + nvl(vsup_3,0),
                             supply_4 = nvl(supply_4,0) + nvl(vsup_4,0)
                      where comp_code  = pcomp_code and
                            unit_code  = punit_code and
                            lbl_dt     = vsupdate and
                            agcd||dpcd = prev_agcd and
                            seq_no     = nvl(vseq_no,0) - 1
                             /*and (FEDN=pedtn_code OR pedtn_code IS NULL)*/;
                    if sql%found then
                        delete from cir_lblmast
                            where comp_code  = pcomp_code and
                                  unit_code  = punit_code and
                                  lbl_dt     = vsupdate and
                                  agcd||dpcd = prev_agcd and
                                  seq_no     = vseq_no
                               /*and (FEDN=pedtn_code OR pedtn_code IS NULL)*/;
                        vseq_no       := nvl(vseq_no,0) - 1;
                        count_lbl     := nvl(count_lbl,0) -1;
                    end if;
                end if;
            end if;
            if mpin = 'Y' then
                vseq_no := nvl(vseq_no,0) + 1;

                ad_lblmst(sup_rec.agcd,sup_rec.dpcd,sup_rec.edtn,mroute,msubrt,msubsubrt,mname,mhname,
                      mastn,vsupdate,t_rtnm, t_hrtnm,'1','1','PIN   ',null,null,
                      nvl(pktsize,0),0,0,nvl(pktsize,0),v_alert_text,0, 0 ,nvl(pktsize,0),mlblln7,
                      null,null,null,NULL,1,null,vcoag,vcodp,vagty,pperiod,ROUTE_PRINT_SLNO,ASTN_PRINT_SLNO,mlblty,punit_code,pcomp_code,
                      t_subrtnm,t_subrtonm,t_subsubrtnm,t_subsubrtonm,vcity_oname,
                      vstation_name,vstation_oname,cir_get_publ_name(pcomp_code,sup_rec.publ),sup_rec.sup_rate,
                      vpin_open_in,v_lbl_printno,vdist_seqno,sup_rec.dist_code,0,v_sup_name);
            end if;
            vmessage := '';
            if mpinag is not null then --or mpin = 'Y' then
                open cr_pin_cur;
                fetch cr_pin_cur into vpin_name;
                close cr_pin_cur;
                vmessage := 'PIN WITH '||ltrim(vpin_name);
            end if;

            if pperiod = 7 then
                update cir_lblmast
                    set lbl_tno = count_lbl
                    where comp_code  = pcomp_code and
                         unit_code  = punit_code and
                         lbl_dt     = vsupdate and
                         agcd||dpcd = prev_agcd and
                        ((edtn     = pedtn_code) or (pedtn_code is null));
            else
                update cir_lblmast
                    set lbl_tno = nvl(count_lbl,0)
                    where comp_code  = pcomp_code and
                         unit_code  = punit_code and
                         lbl_dt     = vsupdate and
                         agcd||dpcd = prev_agcd and
                        ((edtn     = pedtn_code) or (pedtn_code is null));
            end if;

               count_pub := 1;
              count_lbl := 0;
               bal_sup := sup_rec.rsup;
            --------for unpaid copy
            select sum(sup_copy) into v_unpaid_copy from cir_dbksup a,cir_supply_type_mast b
                where a.comp_code=pcomp_code and a.comp_code=b.comp_code and a.unit_code=punit_code and agcd=sup_rec.agcd and dpcd=sup_rec.dpcd and
                    a.publ= sup_rec.publ and a.edtn=sup_rec.edtn and a.supdate=vsupdate and a.sup_type_code=b.sup_ty_code and b.bill_pay='N';
            v_unpaid_bal    :=v_unpaid_copy;
            --------for unpaid copy
            loop
                exit when bal_sup <= 0;
                if bal_sup > nvl(pktsize,0) then
                      actual_sup:= nvl(pktsize,0);
                    bal_sup     := bal_sup - nvl(pktsize,0);
                    if bal_sup<=padjust_copy then
                          actual_sup:= actual_sup+bal_sup;
                        bal_sup     := 0;
                    end if;
                else
                      actual_sup:= bal_sup;
                    bal_sup     := 0; -- pub completely consumed
                end if;
                vseq_no   := nvl(vseq_no,0) + 1;
                count_lbl := nvl(count_lbl,0) + 1;
                --inserting record;

                --------for unpaid copy
                if nvl(v_unpaid_bal,0)>0 then
                    if nvl(v_unpaid_bal,0)>actual_sup then
                        v_unpaid_bal    :=v_unpaid_bal-actual_sup;
                        v_unpaid_copy   :=actual_sup;
                    else
                        v_unpaid_copy   :=v_unpaid_bal;
                        v_unpaid_bal    :=0;
                    end if;
                else
                    v_unpaid_copy:=0;
                    v_unpaid_bal :=0;
                end if;
                --------for unpaid copy
                
                --insert into test1(vstring,vstring2) values('lbl gen ',
                --'sup_rec.agcd='||sup_rec.agcd||' , '||'sup_rec.dpcd='||sup_rec.dpcd||' , '||'sup_rec.edtn='||sup_rec.edtn||' , '||'mroute,msubrt='||mroute,msubrt||' , '||'msubsubrt='||msubsubrt||' , '||
                --'mname='||mname||' , '||'mhname='||mhname||' , '||'mastn='||mastn||' , '||'vsupdate='||vsupdate||' , '||
                         --'t_rtnm='||t_rtnm||' , '||'t_hrtnm='||t_hrtnm||' , '||'count_lbl='||count_lbl||' , '||'vmessage='||vmessage||v_alert_text,0, 0 /*REM_CP*/,nvl(pktsize,0),mlblln7,
                         --sup_rec.publ,sup_rec.edtn,actual_sup,vseq_no,count_pub,sup_rec.publ,vcoag,vcodp,vagty,
                         --pperiod,ROUTE_PRINT_SLNO,ASTN_PRINT_SLNO,mlblty,punit_code,pcomp_code,
                         --t_subrtnm,t_subrtonm,t_subsubrtnm,t_subsubrtonm,vcity_oname,
                         --vstation_name,vstation_oname,cir_get_publ_name(pcomp_code,sup_rec.publ),sup_rec.sup_rate,
                         --vpin_open_in,v_lbl_printno,vdist_seqno,sup_rec.dist_code,v_unpaid_copy,v_sup_name)
                         
               ad_lblmst( sup_rec.agcd,sup_rec.dpcd,sup_rec.edtn,mroute,msubrt,msubsubrt,mname,mhname,
                         mastn,vsupdate,
                         t_rtnm, t_hrtnm,count_lbl,null /* to be update laster on */,vmessage,null,null,
                         --nvl(pktsize,0),0,0,nvl(pktsize,0),v_alert_text,0, 0 /*REM_CP*/,nvl(pktsize,0),mlblln7,
                         nvl(pktsize,0),0,0,nvl(pktsize,0),0,0, 0 /*REM_CP*/,nvl(pktsize,0),mlblln7,
                         sup_rec.publ,sup_rec.edtn,actual_sup,vseq_no,count_pub,sup_rec.publ,vcoag,vcodp,vagty,
                         pperiod,ROUTE_PRINT_SLNO,ASTN_PRINT_SLNO,mlblty,punit_code,pcomp_code,
                         t_subrtnm,t_subrtonm,t_subsubrtnm,t_subsubrtonm,vcity_oname,
                         vstation_name,vstation_oname,cir_get_publ_name(pcomp_code,sup_rec.publ),sup_rec.sup_rate,
                         vpin_open_in,v_lbl_printno,vdist_seqno,sup_rec.dist_code,v_unpaid_copy,v_sup_name);
                         
                         
            end loop;
     else -- 2nd time onwards
             count_pub := nvl(count_pub,0) + 1;
            bal_sup     := sup_rec.rsup;
            loop
                 exit when bal_sup <= 0;
                   --consumed_sup should come by cursor;
                  open con_sup_cur;
                  fetch con_sup_cur into consumed_sup;
                  close con_sup_cur;
                  bal_pktsize := nvl(pktsize,0) - consumed_sup;
                  if bal_sup > bal_pktsize then
                     actual_sup := bal_pktsize;
                     bal_sup :=  bal_sup - bal_pktsize;
                        if bal_sup<=padjust_copy then
                              actual_sup:= actual_sup+bal_sup;
                            bal_sup     := 0;
                        end if;
                  else
                     actual_sup := bal_sup;
                     bal_sup :=  0; -- pub completely consumed
                  end if;
                  if consumed_sup < nvl(pktsize,0) then
                      update_rec(pcomp_code,punit_code,sup_rec.publ,sup_rec.edtn,vsupdate,actual_sup,count_pub,vseq_no); --lblmst set sup2 = actual_sup where seq_no = vseq_no;
                      null;
                  else
                      if bal_pktsize = 0 then
                         if bal_sup > nvl(pktsize,0) then
                             actual_sup:= nvl(pktsize,0);
                             bal_sup     := bal_sup - nvl(pktsize,0);
                                        if bal_sup<=padjust_copy then
                                              actual_sup:= actual_sup+bal_sup;
                                            bal_sup     := 0;
                                        end if;
                          else
                             actual_sup:= bal_sup;
                             bal_sup   := 0; -- pub completely consumed
                          end if;
                      end if;
                    vseq_no   := nvl(vseq_no,0) + 1;
                    count_lbl := nvl(count_lbl,0) + 1;
                                --message('before insert last111 ');
              ad_lblmst(sup_rec.agcd,sup_rec.dpcd,sup_rec.edtn,mroute,msubrt,msubsubrt,mname,mhname,
                        mastn,vsupdate,
                        t_rtnm, t_hrtnm,count_lbl,null /* to be update laster on */,vmessage,null,null,
                        --nvl(pktsize,0),0,0,nvl(pktsize,0),v_alert_text,0, 0 /*REM_CP*/,nvl(pktsize,0),mlblln7,
                        nvl(pktsize,0),0,0,nvl(pktsize,0),0,0, 0 /*REM_CP*/,nvl(pktsize,0),mlblln7,
                        sup_rec.publ,sup_rec.edtn,actual_sup,vseq_no,count_pub,sup_rec.publ,vcoag,vcodp,vagty,
                        pperiod,ROUTE_PRINT_SLNO,ASTN_PRINT_SLNO,mlblty,punit_code,pcomp_code,
                        t_subrtnm,t_subrtonm,t_subsubrtnm,t_subsubrtonm,vcity_oname,
                         vstation_name,vstation_oname,cir_get_edtn_name(pcomp_code,sup_rec.edtn),sup_rec.sup_rate,
                         vpin_open_in,v_lbl_printno,vdist_seqno,sup_rec.dist_code,0,v_sup_name);
                  end if;
            end loop;
     end if;
          if pperiod = 7 then
            prev_agcd := sup_rec.agcd||sup_rec.dpcd;
          else
            prev_agcd := sup_rec.agcd||sup_rec.dpcd||sup_rec.edtn||sup_rec.dist_seqno;
          end if;
          v_lbl_printno:=1;
          commit;
          --message('last ');message('last ');
          --gen_lbl_print_no(pcomp_code,punit_code,sup_rec.agcd,sup_rec.dpcd,sup_rec.edtn,sup_rec.route_code,sup_rec.supdate,sup_rec.publ);-----for lable print no
   end loop;
  close sup_cur;
  v_lbl_lno:=1;
  open c_route;
  loop
      fetch c_route into v_route;
      exit when c_route%notfound;
      curr_agcd:=v_route.route||v_route.publ;
      if curr_agcd <> prev_agcd then
          v_lbl_lno:=1;
          prev_agcd:=v_route.route||v_route.publ;
      else
          v_lbl_lno:=nvl(v_lbl_lno,0)+1;
      end if;
      update cir_lblmast set lbl_lno=v_lbl_lno
          where comp_code=pcomp_code and unit_code=punit_code and lbl_dt=vsupdate and agcd=v_route.agcd and dpcd=v_route.dpcd and
                      publ=v_route.publ and route=v_route.route and seq_no=v_route.seq_no;
  end loop;
  close c_route;
  commit;
  --MESSAGE('JOB OVER');
    end;
End cir_gen_lbl_p;


END cir_gen_lbl;
/

////////////////////////////////////////////////////////description/////////////////////////////////////////


CREATE OR REPLACE PACKAGE HT18JULY.cir_gen_lbl IS
    
  procedure upd_first_sequence(
    pcomp_code         in varchar2,
    punit_code      in varchar2,
    pedtn           in varchar2,
    psupdate        in date,
    pagcd           in varchar2,
    pdpcd           in varchar2);
    
  procedure gen_lbl_print_no(
    pcomp_code      in varchar2,
    punit_code      in varchar2,
    pagcd           in varchar2,
    pdpcd           in varchar2,
    pedtn           in varchar2,
    proute          in varchar2,
    plbldt          in date,
    ppubl           in varchar2);
    
  procedure update_rec(
    pcomp_code      in varchar2,
    punit_code      in varchar2,
    ppubl           in varchar2,
    pedtn           in varchar2,
    psupdate        in date,
    pactual_sup     in number,
    pcount_pub      in varchar2,
    pseq_no         in number);
  procedure ad_lblmst(
    magcd           in varchar2,
    mdpcd           in varchar2,
    medtn           in varchar2,
    mroute          in varchar2,
    msubrt          in varchar2,
    msubsubrt       in varchar2,
    mname           in varchar2,
    mhname          in varchar2,
    mastn           in varchar2,
    p_ldt           in date,
    p_rtnm          in varchar2,
    p_rthnm         in varchar2,
    p_sno           in number,
    p_tno           in number,
    p_msg1          in varchar2,
    p_msg2          in varchar2,
    p_msg3          in varchar2,
    p_tcp1          in number,
    p_tcp2          in number,
    p_tcp3          in number,
    p_cp1           in number,
    p_cp2           in number,
    p_cp3           in number,
    rem_copy        in number,
    pkt_size        in number,
    mlblln7         in varchar2,
    ppub            in varchar2,
    pedtn           in varchar2,
    pactual_sup     in number,
    pseq_no         in number,
    pcount_pub      in number,
    ppubl           in varchar2,
    p_coag          in varchar2,
    p_codp          in varchar2,
    p_agty          in varchar2,
    pweek_dl        in varchar2,
    proute_print_slno   in number,
    pastn_print_slno    in number,
    plblty              in varchar2,
    punit_code          in varchar2,
    pcomp_code          in varchar2,
    psubrtnm            in varchar2,
    psubrtonm           in varchar2,
    psubsubrtnm         in varchar2,
    psubsubrtonm        in varchar2,
    pcity_oname         in varchar2,
    pstation_name       in varchar2,
    pstation_oname      in varchar2,
    ppubl_name          in varchar2,
    psup_rate           in number,
    ppin_open_in        in varchar2,
    plbl_printno        in number,
    pdistseqno          in number,
    pdistcode           in varchar2,
    punpaid_copy        in number,
    psup_name           in varchar2);
    
  procedure cir_gen_lbl_p(
    pcomp_code          in varchar2,
    punit_code          in varchar2,
    ppubl_code          in varchar2,
    pedtn_code          in varchar2,
    proute_code         in varchar2,
    pagcd               in varchar2,
    pdpcd               in varchar2,
    psupdate            in varchar2,
    ppkt_size           in number,
    padjust_copy        in number,
    pperiod             in number,
    pdateformat         in varchar2,
    pextra1             in varchar2,
    pextra2             in varchar2);
  
END cir_gen_lbl;
/


/////////////////////////////////////////////end///////////////////////////////////////////////////////////////////


//



******************************************************* 2 feb 2012**********************************************

 CREATE OR REPLACE FUNCTION HT18JULY.cir_get_route_name(pcomp_code in varchar2,punit_code in varchar2,proute in varchar2) RETURN varchar2 IS
vroute_name cir_route_mast.route_name%type;
BEGIN
   Begin
     select route_name into vroute_name from cir_route_mast
            where comp_code=pcomp_code and unit=punit_code and route_code=proute;
   Exception when others then
         vroute_name:=null;
   End;
    Return nvl(vroute_name,'');
END;
/
*********************************************************end****************************************************
////////////////////////////////update by Garima fore abc reports

                                                                     
                                                                     
                                                                     
                                             
CREATE OR REPLACE procedure cir_rep_abc_supply_summ(
    pcompcode          in varchar2,
    punitcode          in varchar2,
    pbrancode          in varchar2,
    ppublcode          in varchar2, 
    pmedtncode         in varchar2,
    pedtncode          in varchar2,
    pagtype            in varchar2,
    pagclass           in varchar2,     
    pfromdate          in varchar2,
    ptilldate          in varchar2,
    preptype           in varchar2,--1 for pcentre wise branch wise report 2 for State wise city wise
    pdateformat        in varchar2,
    puserid            in varchar2,     
    pextra1            in varchar2,
    pextra2            in varchar2,
    pextra3            in varchar2,
    pextra4            in varchar2,
    pextra5            in varchar2,
    p_accounts         OUT Cur_Type_New1.cursor_type,
    p_accounts1        OUT Cur_Type_New1.cursor_type,
    p_accounts2        OUT Cur_Type_New1.cursor_type)
As
    v_frdt    date;
    v_todt    date;

    v_comp_code     varchar2(50);
    v_unit_code     varchar2(50);
    v_publ          varchar2(50);
    v_medtn         varchar2(50);
    v_edtn          varchar2(50);
    v_edtn_name     varchar2(50);
    v_state_code    varchar2(50);
    v_dist_code     varchar2(50);
    v_tehsil_taluka varchar2(50);
    v_city_code     varchar2(50);
    v_city_name     varchar2(50);
    v_zone_code     varchar2(50);
    v_region_code   varchar2(50);
    v_branch_code   varchar2(50);
    v_sup_copy      number(10);
    v_supdate       date;
    v_bill_pay      varchar2(20);
    
    cursor cur_data is
        select x.comp_code,x.unit_code,x.publ,x.main_edtn,x.edtn,x.edtn_name,x.state_name, 
        x.dist_code,x.tehsil_taluka,x.city_code,x.city_name,x.zone_code,x.region_code,x.branch_code,
        x.bill_pay,x.supdate, sum(x.sup_copy) sup_copy
        from(
        select b.comp_code,b.unit_code,b.publ,e.main_edtn,b.edtn,e.edtn_name,cir_get_state(b.comp_code,m.country_code,m.state_code) state_name, 
        m.dist_code,m.tehsil_taluka,m.city_code,c.city_name,c.zone_code,c.region_code,m.branch_code,
        b.supdate ,case when nvl(s.bill_pay,'N')='Y' then 'BILLED' else 'UNBILLED' END bill_pay, 
        sum(b.sup_copy) sup_copy
        from cir_dbksup b,cir_agmast m,cir_edtn_mast e ,cir_city_mast c,cir_supply_type_mast s
        where b.comp_code=pcompcode and b.comp_code=m.comp_code and b.comp_code=e.comp_code and b.comp_code=c.comp_code and b.comp_code=s.comp_code and
        b.unit_code=nvl(punitcode,b.unit_code) and b.unit_code=m.unit and b.agcd=m.agcd and b.dpcd=m.dpcd and 
        b.publ=e.publ and b.publ=nvl(ppublcode,b.publ) and b.edtn=e.edtn and b.edtn=nvl(pedtncode,b.edtn) and  
        b.supdate between v_frdt and v_todt and b.sup_type_code=s.sup_ty_code and  
        e.main_edtn=nvl(pmedtncode,e.main_edtn) and (m.ag_type=pagtype or pagtype is null) and (m.ag_class=pagclass or pagclass is null) and 
        (m.branch_code=pbrancode or pbrancode is null) and m.city_code=c.city_code 
        group by b.comp_code,b.unit_code,b.publ,e.main_edtn,b.edtn,m.state_code,m.country_code,m.dist_code,m.tehsil_taluka,
        e.edtn_name,b.edtn,b.supdate ,nvl(s.bill_pay,'N'),
        m.city_code,c.city_name,c.zone_code,c.region_code,m.branch_code) x
        group by x.comp_code,x.unit_code,x.publ,x.main_edtn,x.edtn,x.edtn_name,x.state_name, 
        x.dist_code,x.tehsil_taluka,x.city_code,x.city_name,x.zone_code,x.region_code,x.branch_code,
        x.bill_pay,supdate;


     v_cnt      number:=0;
Begin
    v_frdt   :=to_date(pfromdate,''''||pdateformat||'''');
    v_todt   :=to_date(ptilldate,''''||pdateformat||'''');
    
    delete from cir_ledger_report where sess_id=userenv('sessionid');
    
    open cur_data;
    loop
        fetch cur_data into v_comp_code,v_unit_code,v_publ,v_medtn,v_edtn,v_edtn_name,v_state_code,v_dist_code,v_tehsil_taluka,v_city_code,
            v_city_name,v_zone_code,v_region_code,v_branch_code, 
            v_bill_pay,v_supdate,v_sup_copy;
        exit when cur_data%notfound;
        
            insert into cir_ledger_report
            (comp_code, unit_code, branch_code, doctype,agcd, dpcd,billno, recptno, debit_head,chqno,chq_bank, exec_code, remarks,  
                reason,rec_seqno,billdt,sess_id)
            values
            (v_comp_code,v_unit_code,v_branch_code,v_publ,v_medtn,v_edtn,v_edtn_name,v_state_code,v_dist_code,v_tehsil_taluka,v_zone_code,v_region_code,v_city_name,
            v_bill_pay,v_sup_copy, v_supdate,userenv('sessionid'));

           
    end loop;
    close cur_data;
    commit;
    
    if preptype='1' then--for Pcenter wise
            open p_accounts for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            a.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=a.unit_code) as "UNIT_NAME", 
            a.branch_code as "BRANCH_CODE",(select "Branch_Name" from branch_mst where "Branch_Code"=a.branch_code) as "BRANCH_NAME", 
            sum(a.rec_seqno) as "SUP_COPY",a.reason as "BILL_PAY"
            from cir_ledger_report a 
            where sess_id=userenv('sessionid') 
            group by a.comp_code ,a.unit_code, a.branch_code,a.reason
            order by comp_name,bill_pay,unit_name,branch_name;
            
            open p_accounts1 for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            a.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=a.unit_code) as "UNIT_NAME", 
            sum(a.rec_seqno) as "SUP_COPY",a.reason as "BILL_PAY"
            from cir_ledger_report a 
            where sess_id=userenv('sessionid') 
            group by a.comp_code ,a.unit_code, a.reason
            order by comp_name,bill_pay,unit_name;

            open p_accounts2 for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            sum(a.rec_seqno) as "SUP_COPY",a.reason as "BILL_PAY"
            from cir_ledger_report a 
            where sess_id=userenv('sessionid') 
            group by a.comp_code ,a.reason
            order by comp_name,bill_pay;
                        
    else
            open p_accounts for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            a.recptno as "STATE_NAME", a.city_code as "CITY_CODE", a.remarks as "CITY_NAME",   
            sum(a.rec_seqno) as "SUP_COPY",a.reason as "BILL_PAY"
            from cir_ledger_report a 
            where sess_id=userenv('sessionid') 
            group by a.comp_code ,a.recptno,a.city_code,a.remarks,a.reason
            order by comp_name,bill_pay,state_name,city_name;
            
            open p_accounts1 for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            a.recptno as "STATE_NAME",sum(a.rec_seqno) as "SUP_COPY",a.reason as "BILL_PAY"
            from cir_ledger_report a 
            where sess_id=userenv('sessionid') 
            group by a.comp_code ,a.recptno,a.reason
            order by comp_name,bill_pay,state_name;

            open p_accounts2 for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            sum(a.rec_seqno) as "SUP_COPY",a.reason as "BILL_PAY"
            from cir_ledger_report a 
            where sess_id=userenv('sessionid') 
            group by a.comp_code , a.reason
            order by comp_name,bill_pay;
    End if;
    
    delete from cir_ledger_report where sess_id=userenv('sessionid');commit;
    
End cir_rep_abc_supply_summ;
/




/////////////////////////////////////////////////
CREATE OR REPLACE procedure cir_rep_abc_supply_bill_return(
    pcompcode          in varchar2,
    punitcode          in varchar2,
    pbrancode          in varchar2,
    ppublcode          in varchar2, 
    pmedtncode         in varchar2,
    pedtncode          in varchar2,
    pagtype            in varchar2,
    pagclass           in varchar2,     
    pfromdate          in varchar2,
    ptilldate          in varchar2,
    pbreakon           in varchar2,--It is used for report break on 1 for State,2 for District , 3 for Taluka, 4 for zone,5 Region
    preptype           in varchar2,--1 for OK Bill report 2 for OK Bill By commission
    pdateformat        in varchar2,    
    puserid            in varchar2, 
    pextra1            in varchar2,
    pextra2            in varchar2,
    pextra3            in varchar2,
    pextra4            in varchar2,
    pextra5            in varchar2,
    p_accounts         OUT Cur_Type_New1.cursor_type,
    p_accounts1        OUT Cur_Type_New1.cursor_type)
As
    v_frdt    date;
    v_todt    date;

    v_comp_code     varchar2(50);
    v_unit_code     varchar2(50);
    v_publ          varchar2(50);
    v_medtn         varchar2(50);
    v_edtn          varchar2(50);
    v_edtn_name     varchar2(50);
    v_state_code    varchar2(50);
    v_dist_code     varchar2(50);
    v_tehsil_taluka varchar2(50);
    v_city_code     varchar2(50);
    v_city_name     varchar2(50);
    v_zone_code     varchar2(50);
    v_region_code   varchar2(50);
    v_sup_rate      number(15,4);
    v_comm_rate     number(15,4);
    v_comm_type     varchar2(1);
    v_bill_copy     number(10);
    v_gross_amt     number(15,2);
    v_comm_amt      number(15,2);
    v_sur_amt       number(15,2);
    v_bill_amt      number(15,2);
    
    v_apr_unsold        number(15);
    v_apr_short_recpt   number(15); 
    v_apr_late_recpt    number(15);
    v_apr_bnr           number(15);
    v_apr_damage        number(15);    
    
    
 
    cursor cur_data is
        select x.comp_code,x.unit_code,x.publ,x.main_edtn,x.edtn,x.edtn_name,x.state_name, 
        x.dist_code,x.tehsil_taluka,x.city_code,x.city_name,x.zone_code,x.region_code,
        x.copy_rate,x.comm_rate,x.comm_type, 
        sum(x.bill_copy) bill_copy, sum(x.gross_amt) gross_amt, sum(x.comm_amt) comm_amt, sum(x.sur_amt) sur_amt,sum(x.bill_amt) bill_amt,
        sum(x.apr_unsold) apr_unsold ,sum(x.apr_short_recpt) apr_short_recpt, sum(x.apr_late_recpt) apr_late_recpt,sum(x.apr_bnr) apr_bnr,sum(x.apr_damage) apr_damage
        from(
        select b.comp_code,b.unit_code,b.publ,e.main_edtn,b.edtn,e.edtn_name,cir_get_state(b.comp_code,m.country_code,m.state_code) state_name, 
        m.dist_code,m.tehsil_taluka,m.city_code,c.city_name,c.zone_code,c.region_code,
        b.copy_rate,b.comm_rate,nvl(b.comm_type,case when b.copy_rate>b.comm_rate then 'C' else 'P' end) comm_type,  
        sum(b.bill_copy) bill_copy, sum(b.gross_amount) gross_amt, sum(b.comm_amt) comm_amt, sum(b.sur_amt) sur_amt,sum(b.bill_amount) bill_amt,
        0 apr_unsold ,0 apr_short_recpt, 0 apr_late_recpt,0 apr_bnr,0 apr_damage
        from cir_bill_det b,cir_agmast m,cir_edtn_mast e ,cir_city_mast c
        where b.comp_code=pcompcode and b.comp_code=m.comp_code and b.comp_code=e.comp_code and b.comp_code=c.comp_code and 
        b.unit_code=nvl(punitcode,b.unit_code) and b.unit_code=m.unit 
        and b.billdt between v_frdt and v_todt 
        and b.agcd=m.agcd and b.dpcd=m.dpcd and
        b.publ=e.publ and b.publ=nvl(ppublcode,b.publ) and b.edtn=e.edtn and b.edtn=nvl(pedtncode,b.edtn) and e.main_edtn=nvl(pmedtncode,e.main_edtn) and 
        (m.ag_type=pagtype or pagtype is null) and (m.ag_class=pagclass or pagclass is null) and (m.branch_code=pbrancode or pbrancode is null) and 
        m.city_code=c.city_code 
        group by b.comp_code,b.unit_code,b.publ,e.main_edtn,b.edtn,m.state_code,m.country_code,m.dist_code,m.tehsil_taluka,
        e.edtn_name,b.edtn,
        m.city_code,c.city_name,c.zone_code,c.region_code,b.copy_rate,b.comm_rate,b.comm_type
        union all
        select b.comp_code,b.unit_code,b.publ,e.main_edtn,b.edtn,e.edtn_name,cir_get_state(b.comp_code,m.country_code,m.state_code) state_name, 
        m.dist_code,m.tehsil_taluka,m.city_code,c.city_name,c.zone_code,c.region_code,
        b.copy_rate,b.comm_rate,nvl(b.comm_catg_type,case when b.copy_rate>b.comm_rate then 'C' else 'P' end) comm_type, 
        0 bill_copy, 0 gross_amt, 0 comm_amt, 0 sur_amt,0 bill_amt,
        sum(nvl(b.apr_unsold,0)) apr_unsold ,sum(nvl(b.apr_short_recpt,0)) apr_short_recpt, sum(nvl(b.apr_late_recpt,0)) apr_late_recpt,
        sum(nvl(b.apr_bnr,0)) apr_bnr,sum(nvl(b.apr_damage,0)) apr_damage
        from cir_unsold_dtl b,cir_agmast m,cir_edtn_mast e ,cir_city_mast c
        where b.comp_code=pcompcode and b.comp_code=m.comp_code and b.comp_code=e.comp_code and b.comp_code=c.comp_code and 
        b.unit_code=nvl(punitcode,b.unit_code) and b.unit_code=m.unit 
        and b.app_dt between v_frdt and v_todt 
        and b.agcd=m.agcd and b.dpcd=m.dpcd and
        b.publ=e.publ and b.publ=nvl(ppublcode,b.publ) and b.edtn=e.edtn and b.edtn=nvl(pedtncode,b.edtn) and e.main_edtn=nvl(pmedtncode,e.main_edtn) and 
        (m.ag_type=pagtype or pagtype is null) and (m.ag_class=pagclass or pagclass is null) and (m.branch_code=pbrancode or pbrancode is null) and 
        m.city_code=c.city_code 
        group by b.comp_code,b.unit_code,b.publ,e.main_edtn,b.edtn,m.state_code,m.country_code,m.dist_code,m.tehsil_taluka,
        e.edtn_name,b.edtn,
        m.city_code,c.city_name,c.zone_code,c.region_code,b.copy_rate,b.comm_rate,b.comm_catg_type) x
        group by x.comp_code,x.unit_code,x.publ,x.main_edtn,x.edtn,x.edtn_name,x.state_name, 
        x.dist_code,x.tehsil_taluka,x.city_code,x.city_name,x.zone_code,x.region_code,x.copy_rate,x.comm_rate,x.comm_type;


     v_cnt      number:=0;
Begin
    v_frdt   :=to_date(pfromdate,''''||pdateformat||'''');
    v_todt   :=to_date(ptilldate,''''||pdateformat||'''');
    
    

    delete from cir_ledger_report where sess_id=userenv('sessionid');
    
    open cur_data;
    loop
        fetch cur_data into v_comp_code,v_unit_code,v_publ,v_medtn,v_edtn,v_edtn_name,v_state_code,v_dist_code,v_tehsil_taluka,v_city_code,
            v_city_name,v_zone_code,v_region_code,v_sup_rate,v_comm_rate,v_comm_type, 
            v_bill_copy, v_gross_amt, v_comm_amt, v_sur_amt,v_bill_amt,v_apr_unsold,
            v_apr_short_recpt,v_apr_late_recpt,v_apr_bnr,v_apr_damage;
        exit when cur_data%notfound;
        
        if preptype='1' then
            insert into cir_ledger_report
            (comp_code, unit_code, branch_code, agcd, dpcd,billno, recptno, debit_head,chqno,chq_bank, exec_code, remarks,  
                rec_seqno,opbal_sec,amount, billamt, adjamt, leftamt,city_code,sess_id)
            values
            (v_comp_code,v_unit_code,v_publ,v_medtn,v_edtn,v_edtn_name,v_state_code,v_dist_code,v_tehsil_taluka,v_zone_code,v_region_code,v_city_name,
            v_bill_copy, v_apr_unsold,v_apr_short_recpt,v_apr_late_recpt,v_apr_bnr,v_apr_damage,v_city_code,userenv('sessionid'));
        else
            
            insert into cir_ledger_report
            (comp_code, unit_code, branch_code, agcd, dpcd,billno, recptno, debit_head,chqno,chq_bank, exec_code, remarks,  
                rec_seqno,amount, billamt, adjamt, leftamt,city_code,sess_id,
                opbal_sec, reason,doctype)
            values
            (v_comp_code,v_unit_code,v_publ,v_medtn,v_edtn,v_edtn_name,v_state_code,v_dist_code,v_tehsil_taluka,v_zone_code,v_region_code,v_city_name,
            v_bill_copy, v_gross_amt,v_bill_amt,v_comm_amt,v_sur_amt,v_city_code,userenv('sessionid'),
            v_sup_rate,v_comm_rate,v_comm_type);        
        end if;            
    end loop;
    close cur_data;
    commit;
    
    if preptype='1' then
        If pbreakon='1' then--for State
            open p_accounts for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            a.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=a.unit_code) as "UNIT_NAME", 
            a.branch_code as "PUBL_CODE",cir_get_publ_name(a.comp_code,a.branch_code) as "PUBL_NAME", a.agcd as "MEDTN",cir_get_edtn_name(a.comp_code,a.agcd) as "MEDTN_NAME", 
            a.dpcd as "EDTN", a.billno as "EDTN_NAME",a.recptno as "STATE_NAME", a.debit_head as "DIST_CODE",cir_get_name.cir_district(a.comp_code,a.debit_head,'1',pdateformat,null,null) as "DIST_NAME",
            a.city_code as "CITY_CODE", a.remarks as "CITY_NAME",a.chqno as "TALUKA_CODE",cir_get_taluka(a.comp_code,a.chqno) as "TALUKA_NAME", 
            a.chq_bank as "ZONE_CODE",cir_get_zone_name(a.comp_code,a.chq_bank) as "ZONE_NAME", 
            a.exec_code as "REGION_CODE",cir_get_zone_name(a.comp_code,a.exec_code) as "REGION_NAME",   
            sum(a.rec_seqno) as "BILL_COPY",sum(a.opbal_sec) as "UNSOLD",sum(a.amount) as "SHORT", sum(a.adjamt) as "LATE", sum(a.leftamt) as "MISSING", sum(a.billamt) as "DAMAGE",
            sum(nvl(a.rec_seqno,0)-(nvl(a.opbal_sec,0)+nvl(a.amount,0)+nvl(a.adjamt,0)+nvl(a.leftamt,0)+nvl(a.billamt,0))) as "TOTAL"
            from cir_ledger_report a 
            where sess_id=userenv('sessionid') 
            group by a.comp_code ,a.unit_code, a.branch_code,a.agcd, a.dpcd, a.billno,a.recptno, a.debit_head,
            a.city_code,a.remarks,a.chqno, a.chq_bank,a.exec_code
            order by comp_name,unit_name,state_name,publ_name,medtn_name,edtn_name;
            
            open p_accounts1 for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            a.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=a.unit_code) as "UNIT_NAME", 
            a.recptno as "STATE_NAME", sum(a.rec_seqno) as "BILL_COPY",sum(a.opbal_sec) as "UNSOLD",sum(a.amount) as "SHORT", sum(a.adjamt) as "LATE", 
            sum(a.leftamt) as "MISSING", sum(a.billamt) as "DAMAGE",
            sum(nvl(a.rec_seqno,0)-(nvl(a.opbal_sec,0)+nvl(a.amount,0)+nvl(a.adjamt,0)+nvl(a.leftamt,0)+nvl(a.billamt,0))) as "TOTAL" 
            from cir_ledger_report a 
            where sess_id=userenv('sessionid')
            group by a.comp_code ,a.unit_code , a.recptno
            order by comp_name,unit_name,state_name;
            
        Elsif pbreakon='2' then--for District
            open p_accounts for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            a.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=a.unit_code) as "UNIT_NAME", 
            a.branch_code as "PUBL_CODE",cir_get_publ_name(a.comp_code,a.branch_code) as "PUBL_NAME", a.agcd as "MEDTN",cir_get_edtn_name(a.comp_code,a.agcd) as "MEDTN_NAME", 
            a.dpcd as "EDTN", a.billno as "EDTN_NAME",a.recptno as "STATE_NAME", a.debit_head as "DIST_CODE",cir_get_name.cir_district(a.comp_code,a.debit_head,'1',pdateformat,null,null) as "DIST_NAME",
            a.city_code as "CITY_CODE", a.remarks as "CITY_NAME",a.chqno as "TALUKA_CODE",cir_get_taluka(a.comp_code,a.chqno) as "TALUKA_NAME", 
            a.chq_bank as "ZONE_CODE",cir_get_zone_name(a.comp_code,a.chq_bank) as "ZONE_NAME", 
            a.exec_code as "REGION_CODE",cir_get_zone_name(a.comp_code,a.exec_code) as "REGION_NAME",   
            sum(a.rec_seqno) as "BILL_COPY",sum(a.opbal_sec) as "UNSOLD",sum(a.amount) as "SHORT", sum(a.adjamt) as "LATE", sum(a.leftamt) as "MISSING", sum(a.billamt) as "DAMAGE",
            sum(nvl(a.rec_seqno,0)-(nvl(a.opbal_sec,0)+nvl(a.amount,0)+nvl(a.adjamt,0)+nvl(a.leftamt,0)+nvl(a.billamt,0))) as "TOTAL" 
            from cir_ledger_report a 
            where sess_id=userenv('sessionid') 
            group by a.comp_code ,a.unit_code, a.branch_code,a.agcd, a.dpcd, a.billno,a.recptno,a.debit_head,
            a.city_code, a.remarks,a.chqno,a.chq_bank, a.exec_code 
            order by comp_name,unit_name,state_name,dist_name,publ_name,medtn_name,edtn_name;
            
            open p_accounts1 for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            a.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=a.unit_code) as "UNIT_NAME", 
            a.recptno as "STATE_NAME",a.debit_head as "DIST_CODE",cir_get_name.cir_district(a.comp_code,a.debit_head,'1',pdateformat,null,null) as "DIST_NAME", 
            sum(a.rec_seqno) as "BILL_COPY",sum(a.opbal_sec) as "UNSOLD",sum(a.amount) as "SHORT", sum(a.adjamt) as "LATE", 
            sum(a.leftamt) as "MISSING", sum(a.billamt) as "DAMAGE",
            sum(nvl(a.rec_seqno,0)-(nvl(a.opbal_sec,0)+nvl(a.amount,0)+nvl(a.adjamt,0)+nvl(a.leftamt,0)+nvl(a.billamt,0))) as "TOTAL" 
            from cir_ledger_report a 
            where sess_id=userenv('sessionid')
            group by a.comp_code ,a.unit_code , a.recptno,a.debit_head
            order by comp_name,unit_name,state_name,dist_name;
            
        Elsif pbreakon='3' then--for Taluka
            open p_accounts for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            a.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=a.unit_code) as "UNIT_NAME", 
            a.branch_code as "PUBL_CODE",cir_get_publ_name(a.comp_code,a.branch_code) as "PUBL_NAME", a.agcd as "MEDTN",cir_get_edtn_name(a.comp_code,a.agcd) as "MEDTN_NAME", 
            a.dpcd as "EDTN", a.billno as "EDTN_NAME",a.recptno as "STATE_NAME", a.debit_head as "DIST_CODE",cir_get_name.cir_district(a.comp_code,a.debit_head,'1',pdateformat,null,null) as "DIST_NAME",
            a.city_code as "CITY_CODE", a.remarks as "CITY_NAME",a.chqno as "TALUKA_CODE",cir_get_taluka(a.comp_code,a.chqno) as "TALUKA_NAME", 
            a.chq_bank as "ZONE_CODE",cir_get_zone_name(a.comp_code,a.chq_bank) as "ZONE_NAME", 
            a.exec_code as "REGION_CODE",cir_get_zone_name(a.comp_code,a.exec_code) as "REGION_NAME",   
            sum(a.rec_seqno) as "BILL_COPY",sum(a.opbal_sec) as "UNSOLD",sum(a.amount) as "SHORT", sum(a.adjamt) as "LATE", 
            sum(a.leftamt) as "MISSING", sum(a.billamt) as "DAMAGE",
            sum(nvl(a.rec_seqno,0)-(nvl(a.opbal_sec,0)+nvl(a.amount,0)+nvl(a.adjamt,0)+nvl(a.leftamt,0)+nvl(a.billamt,0))) as "TOTAL" 
            from cir_ledger_report a 
            where sess_id=userenv('sessionid') 
            group by a.comp_code,a.unit_code, a.branch_code, a.agcd ,a.dpcd, a.billno,a.recptno, a.debit_head,
            a.city_code, a.remarks,a.chqno,a.chq_bank,a.exec_code 
            order by comp_name,unit_name,state_name,dist_name,taluka_name,publ_name,medtn_name,edtn_name;
            
            open p_accounts1 for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            a.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=a.unit_code) as "UNIT_NAME", 
            a.recptno as "STATE_NAME",a.debit_head as "DIST_CODE",cir_get_name.cir_district(a.comp_code,a.debit_head,'1',pdateformat,null,null) as "DIST_NAME",
            a.chqno as "TALUKA_CODE",cir_get_taluka(a.comp_code,a.chqno) as "TALUKA_NAME", 
            sum(a.rec_seqno) as "BILL_COPY",sum(a.opbal_sec) as "UNSOLD",sum(a.amount) as "SHORT", sum(a.adjamt) as "LATE", 
            sum(a.leftamt) as "MISSING", sum(a.billamt) as "DAMAGE",
            sum(nvl(a.rec_seqno,0)-(nvl(a.opbal_sec,0)+nvl(a.amount,0)+nvl(a.adjamt,0)+nvl(a.leftamt,0)+nvl(a.billamt,0))) as "TOTAL" 
            from cir_ledger_report a 
            where sess_id=userenv('sessionid')
            group by a.comp_code ,a.unit_code , a.recptno,a.debit_head,a.chqno
            order by comp_name,unit_name,state_name,dist_name,taluka_name;
            
        Elsif pbreakon='4' then--for Zone
            open p_accounts for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            a.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=a.unit_code) as "UNIT_NAME", 
            a.branch_code as "PUBL_CODE",cir_get_publ_name(a.comp_code,a.branch_code) as "PUBL_NAME", a.agcd as "MEDTN",cir_get_edtn_name(a.comp_code,a.agcd) as "MEDTN_NAME", 
            a.dpcd as "EDTN", a.billno as "EDTN_NAME",a.recptno as "STATE_NAME", a.debit_head as "DIST_CODE",cir_get_name.cir_district(a.comp_code,a.debit_head,'1',pdateformat,null,null) as "DIST_NAME",
            a.city_code as "CITY_CODE", a.remarks as "CITY_NAME",a.chqno as "TALUKA_CODE",cir_get_taluka(a.comp_code,a.chqno) as "TALUKA_NAME", 
            a.chq_bank as "ZONE_CODE",cir_get_zone_name(a.comp_code,a.chq_bank) as "ZONE_NAME", 
            a.exec_code as "REGION_CODE",cir_get_zone_name(a.comp_code,a.exec_code) as "REGION_NAME",   
            sum(a.rec_seqno) as "BILL_COPY",sum(a.opbal_sec) as "UNSOLD",sum(a.amount) as "SHORT", sum(a.adjamt) as "LATE", 
            sum(a.leftamt) as "MISSING", sum(a.billamt) as "DAMAGE",
            sum(nvl(a.rec_seqno,0)-(nvl(a.opbal_sec,0)+nvl(a.amount,0)+nvl(a.adjamt,0)+nvl(a.leftamt,0)+nvl(a.billamt,0))) as "TOTAL" 
            from cir_ledger_report a 
            where sess_id=userenv('sessionid') 
            group by a.comp_code,a.unit_code, a.branch_code, a.agcd, a.dpcd ,a.recptno, a.debit_head,
            a.city_code, a.remarks,a.chqno, a.chq_bank, a.exec_code 
            order by comp_name,unit_name,zone_name,publ_name,medtn_name,edtn_name;
            
            open p_accounts1 for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            a.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=a.unit_code) as "UNIT_NAME", 
            a.chq_bank as "ZONE_CODE",cir_get_zone_name(a.comp_code,a.chq_bank) as "ZONE_NAME",
            sum(a.rec_seqno) as "BILL_COPY",sum(a.opbal_sec) as "UNSOLD",sum(a.amount) as "SHORT", sum(a.adjamt) as "LATE", 
            sum(a.leftamt) as "MISSING", sum(a.billamt) as "DAMAGE",
            sum(nvl(a.rec_seqno,0)-(nvl(a.opbal_sec,0)+nvl(a.amount,0)+nvl(a.adjamt,0)+nvl(a.leftamt,0)+nvl(a.billamt,0))) as "TOTAL" 
            from cir_ledger_report a 
            where sess_id=userenv('sessionid')
            group by a.comp_code ,a.unit_code , a.chq_bank
            order by comp_name,unit_name,zone_name;
        Else--for Region Wise                
            open p_accounts for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            a.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=a.unit_code) as "UNIT_NAME", 
            a.branch_code as "PUBL_CODE",cir_get_publ_name(a.comp_code,a.branch_code) as "PUBL_NAME", a.agcd as "MEDTN",cir_get_edtn_name(a.comp_code,a.agcd) as "MEDTN_NAME", 
            a.dpcd as "EDTN", a.billno as "EDTN_NAME",a.recptno as "STATE_NAME", a.debit_head as "DIST_CODE",cir_get_name.cir_district(a.comp_code,a.debit_head,'1',pdateformat,null,null) as "DIST_NAME",
            a.city_code as "CITY_CODE", a.remarks as "CITY_NAME",a.chqno as "TALUKA_CODE",cir_get_taluka(a.comp_code,a.chqno) as "TALUKA_NAME", 
            a.chq_bank as "ZONE_CODE",cir_get_zone_name(a.comp_code,a.chq_bank) as "ZONE_NAME", 
            a.exec_code as "REGION_CODE",cir_get_zone_name(a.comp_code,a.exec_code) as "REGION_NAME",   
            sum(a.rec_seqno) as "BILL_COPY",sum(a.opbal_sec) as "UNSOLD",sum(a.amount) as "SHORT", sum(a.adjamt) as "LATE", 
            sum(a.leftamt) as "MISSING", sum(a.billamt) as "DAMAGE",
            sum(nvl(a.rec_seqno,0)-(nvl(a.opbal_sec,0)+nvl(a.amount,0)+nvl(a.adjamt,0)+nvl(a.leftamt,0)+nvl(a.billamt,0))) as "TOTAL" 
            from cir_ledger_report a 
            where sess_id=userenv('sessionid') 
            group by a.comp_code,a.unit_code, a.branch_code, a.agcd, a.dpcd,a.recptno, a.debit_head,
            a.city_code, a.remarks,a.chqno,a.chq_bank,a.exec_code
            order by comp_name,unit_name,zone_name,region_name,publ_name,medtn_name,edtn_name;
            
            open p_accounts1 for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            a.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=a.unit_code) as "UNIT_NAME", 
            a.chq_bank as "ZONE_CODE",cir_get_zone_name(a.comp_code,a.chq_bank) as "ZONE_NAME",
            a.exec_code as "REGION_CODE",cir_get_zone_name(a.comp_code,a.exec_code) as "REGION_NAME",
            sum(a.rec_seqno) as "BILL_COPY",sum(a.opbal_sec) as "UNSOLD",sum(a.amount) as "SHORT", sum(a.adjamt) as "LATE", 
            sum(a.leftamt) as "MISSING", sum(a.billamt) as "DAMAGE",
            sum(nvl(a.rec_seqno,0)-(nvl(a.opbal_sec,0)+nvl(a.amount,0)+nvl(a.adjamt,0)+nvl(a.leftamt,0)+nvl(a.billamt,0))) as "TOTAL" 
            from cir_ledger_report a 
            where sess_id=userenv('sessionid')
            group by a.comp_code ,a.unit_code , a.chq_bank,a.exec_code
            order by comp_name,unit_name,zone_name,region_name;
        End if;
    Else
        If pbreakon='1' then--for State
            open p_accounts for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            a.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=a.unit_code) as "UNIT_NAME", 
            a.branch_code as "PUBL_CODE",cir_get_publ_name(a.comp_code,a.branch_code) as "PUBL_NAME", a.agcd as "MEDTN",cir_get_edtn_name(a.comp_code,a.agcd) as "MEDTN_NAME", 
            a.dpcd as "EDTN", a.billno as "EDTN_NAME",a.recptno as "STATE_NAME", a.debit_head as "DIST_CODE",cir_get_name.cir_district(a.comp_code,a.debit_head,'1',pdateformat,null,null) as "DIST_NAME",
            a.city_code as "CITY_CODE", a.remarks as "CITY_NAME",a.chqno as "TALUKA_CODE",cir_get_taluka(a.comp_code,a.chqno) as "TALUKA_NAME", 
            a.chq_bank as "ZONE_CODE",cir_get_zone_name(a.comp_code,a.chq_bank) as "ZONE_NAME", 
            a.exec_code as "REGION_CODE",cir_get_zone_name(a.comp_code,a.exec_code) as "REGION_NAME",   
            sum(a.rec_seqno) as "BILL_COPY",to_number(a.reason) as "COMM_RATE",a.doctype as "COMM_TYPE",a.opbal_sec as "COPY_RATE",
            case when a.doctype='P' then round(to_number(a.reason)/100,2) else to_number(a.reason) end as "NET_RATE",
            nvl(sum(a.amount),0)-nvl(sum(a.adjamt),0) as "TOTAL",
            sum(a.amount) as "GROSS_AMT", sum(a.adjamt) as "COMM_AMT", sum(a.leftamt) as "SUR_AMT", sum(a.billamt) as "BILL_AMT"
            from cir_ledger_report a 
            where sess_id=userenv('sessionid') 
            group by a.comp_code ,a.unit_code , a.branch_code , a.agcd , a.dpcd, a.billno,a.recptno, a.debit_head,
            a.city_code, a.remarks,a.chqno, a.chq_bank, a.exec_code,to_number(a.reason),a.doctype,a.opbal_sec
            order by comp_name,unit_name,state_name,publ_name,medtn_name,edtn_name;
            
            open p_accounts1 for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            a.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=a.unit_code) as "UNIT_NAME", 
            a.recptno as "STATE_NAME", 
            sum(a.rec_seqno) as "BILL_COPY",nvl(sum(a.amount),0)-nvl(sum(a.adjamt),0) as "TOTAL",
            sum(a.amount) as "GROSS_AMT", sum(a.adjamt) as "COMM_AMT", sum(a.leftamt) as "SUR_AMT", sum(a.billamt) as "BILL_AMT" 
            from cir_ledger_report a 
            where sess_id=userenv('sessionid')
            group by a.comp_code ,a.unit_code , a.recptno
            order by comp_name,unit_name,state_name;
            
        Elsif pbreakon='2' then--for District
            open p_accounts for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            a.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=a.unit_code) as "UNIT_NAME", 
            a.branch_code as "PUBL_CODE",cir_get_publ_name(a.comp_code,a.branch_code) as "PUBL_NAME", a.agcd as "MEDTN",cir_get_edtn_name(a.comp_code,a.agcd) as "MEDTN_NAME", 
            a.dpcd as "EDTN", a.billno as "EDTN_NAME",a.recptno as "STATE_NAME", a.debit_head as "DIST_CODE",cir_get_name.cir_district(a.comp_code,a.debit_head,'1',pdateformat,null,null) as "DIST_NAME",
            a.city_code as "CITY_CODE", a.remarks as "CITY_NAME",a.chqno as "TALUKA_CODE",cir_get_taluka(a.comp_code,a.chqno) as "TALUKA_NAME", 
            a.chq_bank as "ZONE_CODE",cir_get_zone_name(a.comp_code,a.chq_bank) as "ZONE_NAME", 
            a.exec_code as "REGION_CODE",cir_get_zone_name(a.comp_code,a.exec_code) as "REGION_NAME",   
            sum(a.rec_seqno) as "BILL_COPY",to_number(a.reason) as "COMM_RATE",a.doctype as "COMM_TYPE",a.opbal_sec as "COPY_RATE",
            case when a.doctype='P' then round(to_number(a.reason)/100,2) else to_number(a.reason) end as "NET_RATE",
            nvl(sum(a.amount),0)-nvl(sum(a.adjamt),0) as "TOTAL",
            sum(a.amount) as "GROSS_AMT", sum(a.adjamt) as "COMM_AMT", sum(a.leftamt) as "SUR_AMT", sum(a.billamt) as "BILL_AMT"
            from cir_ledger_report a 
            where sess_id=userenv('sessionid') order by comp_name,unit_name,state_name,dist_name,publ_name,medtn_name,edtn_name;
            
            open p_accounts1 for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            a.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=a.unit_code) as "UNIT_NAME", 
            a.recptno as "STATE_NAME",a.debit_head as "DIST_CODE",cir_get_name.cir_district(a.comp_code,a.debit_head,'1',pdateformat,null,null) as "DIST_NAME", 
            sum(a.rec_seqno) as "BILL_COPY",nvl(sum(a.amount),0)-nvl(sum(a.adjamt),0) as "TOTAL",
            sum(a.amount) as "GROSS_AMT", sum(a.adjamt) as "COMM_AMT", sum(a.leftamt) as "SUR_AMT", sum(a.billamt) as "BILL_AMT" 
            from cir_ledger_report a 
            where sess_id=userenv('sessionid')
            group by a.comp_code ,a.unit_code , a.recptno,a.debit_head
            order by comp_name,unit_name,state_name,dist_name;
            
        Elsif pbreakon='3' then--for Taluka
            open p_accounts for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            a.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=a.unit_code) as "UNIT_NAME", 
            a.branch_code as "PUBL_CODE",cir_get_publ_name(a.comp_code,a.branch_code) as "PUBL_NAME", a.agcd as "MEDTN",cir_get_edtn_name(a.comp_code,a.agcd) as "MEDTN_NAME", 
            a.dpcd as "EDTN", a.billno as "EDTN_NAME",a.recptno as "STATE_NAME", a.debit_head as "DIST_CODE",cir_get_name.cir_district(a.comp_code,a.debit_head,'1',pdateformat,null,null) as "DIST_NAME",
            a.city_code as "CITY_CODE", a.remarks as "CITY_NAME",a.chqno as "TALUKA_CODE",cir_get_taluka(a.comp_code,a.chqno) as "TALUKA_NAME", 
            a.chq_bank as "ZONE_CODE",cir_get_zone_name(a.comp_code,a.chq_bank) as "ZONE_NAME", 
            a.exec_code as "REGION_CODE",cir_get_zone_name(a.comp_code,a.exec_code) as "REGION_NAME",   
            sum(a.rec_seqno) as "BILL_COPY",to_number(a.reason) as "COMM_RATE",a.doctype as "COMM_TYPE",a.opbal_sec as "COPY_RATE",
            case when a.doctype='P' then round(to_number(a.reason)/100,2) else to_number(a.reason) end as "NET_RATE",
            nvl(sum(a.amount),0)-nvl(sum(a.adjamt),0) as "TOTAL",
            sum(a.amount) as "GROSS_AMT", sum(a.adjamt) as "COMM_AMT", sum(a.leftamt) as "SUR_AMT", sum(a.billamt) as "BILL_AMT" 
            from cir_ledger_report a 
            where sess_id=userenv('sessionid') 
            group by a.comp_code ,a.unit_code , a.branch_code, a.agcd , a.dpcd, a.billno ,a.recptno , a.debit_head ,
            a.city_code , a.remarks,a.chqno , a.chq_bank, a.exec_code 
            order by comp_name,unit_name,state_name,dist_name,taluka_name,publ_name,medtn_name,edtn_name;
            
            open p_accounts1 for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            a.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=a.unit_code) as "UNIT_NAME", 
            a.recptno as "STATE_NAME",a.debit_head as "DIST_CODE",cir_get_name.cir_district(a.comp_code,a.debit_head,'1',pdateformat,null,null) as "DIST_NAME",
            a.chqno as "TALUKA_CODE",cir_get_taluka(a.comp_code,a.chqno) as "TALUKA_NAME", 
            sum(a.rec_seqno) as "BILL_COPY",nvl(sum(a.amount),0)-nvl(sum(a.adjamt),0) as "TOTAL",
            sum(a.amount) as "GROSS_AMT", sum(a.adjamt) as "COMM_AMT", sum(a.leftamt) as "SUR_AMT", sum(a.billamt) as "BILL_AMT" 
            from cir_ledger_report a 
            where sess_id=userenv('sessionid')
            group by a.comp_code ,a.unit_code , a.recptno,a.debit_head,a.chqno
            order by comp_name,unit_name,state_name,dist_name,taluka_name;
            
        Elsif pbreakon='4' then--for Zone
            open p_accounts for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            a.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=a.unit_code) as "UNIT_NAME", 
            a.branch_code as "PUBL_CODE",cir_get_publ_name(a.comp_code,a.branch_code) as "PUBL_NAME", a.agcd as "MEDTN",cir_get_edtn_name(a.comp_code,a.agcd) as "MEDTN_NAME", 
            a.dpcd as "EDTN", a.billno as "EDTN_NAME",a.recptno as "STATE_NAME", a.debit_head as "DIST_CODE",cir_get_name.cir_district(a.comp_code,a.debit_head,'1',pdateformat,null,null) as "DIST_NAME",
            a.city_code as "CITY_CODE", a.remarks as "CITY_NAME",a.chqno as "TALUKA_CODE",cir_get_taluka(a.comp_code,a.chqno) as "TALUKA_NAME", 
            a.chq_bank as "ZONE_CODE",cir_get_zone_name(a.comp_code,a.chq_bank) as "ZONE_NAME", 
            a.exec_code as "REGION_CODE",cir_get_zone_name(a.comp_code,a.exec_code) as "REGION_NAME",   
            sum(a.rec_seqno) as "BILL_COPY",to_number(a.reason) as "COMM_RATE",a.doctype as "COMM_TYPE",a.opbal_sec as "COPY_RATE",
            case when a.doctype='P' then round(to_number(a.reason)/100,2) else to_number(a.reason) end as "NET_RATE",
            nvl(sum(a.amount),0)-nvl(sum(a.adjamt),0) as "TOTAL",
            sum(a.amount) as "GROSS_AMT", sum(a.adjamt) as "COMM_AMT", sum(a.leftamt) as "SUR_AMT", sum(a.billamt) as "BILL_AMT" 
            from cir_ledger_report a 
            where sess_id=userenv('sessionid') 
            group by a.comp_code ,a.unit_code , a.branch_code , a.agcd , a.dpcd, a.billno ,a.recptno , a.debit_head ,
            a.city_code , a.remarks,a.chqno , a.chq_bank, a.exec_code 
            order by comp_name,unit_name,zone_name,publ_name,medtn_name,edtn_name;
            
            open p_accounts1 for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            a.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=a.unit_code) as "UNIT_NAME", 
            a.chq_bank as "ZONE_CODE",cir_get_zone_name(a.comp_code,a.chq_bank) as "ZONE_NAME",
            sum(a.rec_seqno) as "BILL_COPY",nvl(sum(a.amount),0)-nvl(sum(a.adjamt),0) as "TOTAL",
            sum(a.amount) as "GROSS_AMT", sum(a.adjamt) as "COMM_AMT", sum(a.leftamt) as "SUR_AMT", sum(a.billamt) as "BILL_AMT" 
            from cir_ledger_report a 
            where sess_id=userenv('sessionid')
            group by a.comp_code ,a.unit_code , a.chq_bank
            order by comp_name,unit_name,zone_name;
        Else--for Region Wise                
            open p_accounts for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            a.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=a.unit_code) as "UNIT_NAME", 
            a.branch_code as "PUBL_CODE",cir_get_publ_name(a.comp_code,a.branch_code) as "PUBL_NAME", a.agcd as "MEDTN",cir_get_edtn_name(a.comp_code,a.agcd) as "MEDTN_NAME", 
            a.dpcd as "EDTN", a.billno as "EDTN_NAME",a.recptno as "STATE_NAME", a.debit_head as "DIST_CODE",cir_get_name.cir_district(a.comp_code,a.debit_head,'1',pdateformat,null,null) as "DIST_NAME",
            a.city_code as "CITY_CODE", a.remarks as "CITY_NAME",a.chqno as "TALUKA_CODE",cir_get_taluka(a.comp_code,a.chqno) as "TALUKA_NAME", 
            a.chq_bank as "ZONE_CODE",cir_get_zone_name(a.comp_code,a.chq_bank) as "ZONE_NAME", 
            a.exec_code as "REGION_CODE",cir_get_zone_name(a.comp_code,a.exec_code) as "REGION_NAME",   
            sum(a.rec_seqno) as "BILL_COPY",to_number(a.reason) as "COMM_RATE",a.doctype as "COMM_TYPE",a.opbal_sec as "COPY_RATE",
            case when a.doctype='P' then round(to_number(a.reason)/100,2) else to_number(a.reason) end as "NET_RATE",
            nvl(sum(a.amount),0)-nvl(sum(a.adjamt),0) as "TOTAL",
            sum(a.amount) as "GROSS_AMT", sum(a.adjamt) as "COMM_AMT", sum(a.leftamt) as "SUR_AMT", sum(a.billamt) as "BILL_AMT" 
            from cir_ledger_report a 
            where sess_id=userenv('sessionid') 
            group by a.comp_code ,a.unit_code , a.branch_code , a.agcd , 
            a.dpcd , a.billno ,a.recptno , a.debit_head ,a.city_code, a.remarks ,a.chqno , a.chq_bank  ,a.exec_code 
            order by comp_name,unit_name,zone_name,region_name,publ_name,medtn_name,edtn_name;
            
            open p_accounts1 for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            a.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=a.unit_code) as "UNIT_NAME", 
            a.chq_bank as "ZONE_CODE",cir_get_zone_name(a.comp_code,a.chq_bank) as "ZONE_NAME",
            a.exec_code as "REGION_CODE",cir_get_zone_name(a.comp_code,a.exec_code) as "REGION_NAME",
            sum(a.rec_seqno) as "BILL_COPY",nvl(sum(a.amount),0)-nvl(sum(a.adjamt),0) as "TOTAL",
            sum(a.amount) as "GROSS_AMT", sum(a.adjamt) as "COMM_AMT", sum(a.leftamt) as "SUR_AMT", sum(a.billamt) as "BILL_AMT" 
            from cir_ledger_report a 
            where sess_id=userenv('sessionid')
            group by a.comp_code ,a.unit_code , a.chq_bank,a.exec_code
            order by comp_name,unit_name,zone_name,region_name;
        End if;            
    End if;
    
    delete from cir_ledger_report where sess_id=userenv('sessionid');commit;
    
End cir_rep_abc_supply_bill_return;
/


/////////////////////////////////////update by Garima

CREATE OR REPLACE procedure cir_rep_abc_daybook_summ(
    pcompcode           in varchar2,
    punitcode           in varchar2,
    pbrancode           in varchar2,
    ppublcode           in varchar2,
    pmedtncode          in varchar2,
    pedtncode           in varchar2,
    pagtype             in varchar2,
    pagclass            in varchar2,     
    pmonth              in varchar2,
    pyear               in number,
    pday_period         in varchar2,--1 for 1 to 15,2 for 16 to last month of day, 3 for 1 to last month of day
    ppaid_free          in varchar2,--P for paid supply,F for Free supply and blank for All
    preptype            in varchar2,--1 for pcentre wise summary report,2 for pcentre wise branch wise report, 3 for Zone wise ,4 for zone wise region wise,5 for state wise, 6 state wise district wise
    pdateformat         in varchar2,
    puserid             in varchar2,     
    pextra1             in varchar2,
    pextra2             in varchar2,
    pextra3             in varchar2,
    pextra4             in varchar2,
    pextra5             in varchar2,
    p_accounts          OUT Cur_Type_New1.cursor_type,
    p_accounts1         OUT Cur_Type_New1.cursor_type
    ,
       p_accounts2         OUT Cur_Type_New1.cursor_type
    
    )
As
    v_frdt    date;
    v_todt    date;

    v_comp_code     varchar2(50);
    v_comp_name     varchar2(50);
    v_unit_code     varchar2(50);
    v_unit_name     varchar2(50);    
    v_publ          varchar2(50);
    v_medtn         varchar2(50);
    v_edtn          varchar2(50);
    v_edtn_name     varchar2(50);
    v_state_code    varchar2(50);
    v_dist_code     varchar2(50);
    v_tehsil_taluka varchar2(50);
    v_city_code     varchar2(50);
    v_city_name     varchar2(50);
    v_zone_code     varchar2(50);
    v_zone_name     varchar2(50);
    v_region_code   varchar2(50);
    v_region_name   varchar2(50);
    v_branch_code   varchar2(50);
    v_sup_copy      number(10);
    v_supdate       date;
    v_bill_pay      varchar2(20);
    v_sday          varchar2(2);
    vvar            varchar2(2000);
    tot_vvar        varchar2(2000);
    
    v_query1        varchar2(8000);
    v_query2        varchar2(8000);
    v_query3        varchar2(8000);
    v_query4        varchar2(8000);
    v_query5        varchar2(8000);
    v_query6        varchar2(8000);
            
    cursor cur_data is
        select x.comp_code,(select "Comp_Name" from comp_mst where "Comp_Code"=x.comp_code) as comp_name,
        x.unit_code,(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=x.unit_code) as unit_name,
        x.state_name,x.dist_name,x.taluka_name,x.city_code,x.city_name,x.zone_code,x.region_code,x.branch_code,
        (select "Branch_Name" from branch_mst where "Branch_Code"=x.branch_code) as branch_name,
        x.bill_pay,x.supdate, sum(x.sup_copy) sup_copy
        from(
        select b.comp_code,b.unit_code,b.publ,e.main_edtn,b.edtn,e.edtn_name,cir_get_state(b.comp_code,m.country_code,m.state_code) state_name,
        cir_get_dist(b.comp_code,m.state_code,m.dist_code) as dist_name,
        cir_get_taluka(b.comp_code,m.tehsil_taluka) taluka_name,m.city_code,c.city_name,
        c.zone_code, c.region_code,m.branch_code,
        b.supdate ,case when nvl(s.bill_pay,'N')='Y' then 'BILLED' else 'UNBILLED' END bill_pay,
        sum(b.sup_copy) sup_copy
        from cir_dbksup b,cir_agmast m,cir_edtn_mast e ,cir_city_mast c,cir_supply_type_mast s
        where b.comp_code=pcompcode and b.comp_code=m.comp_code and b.comp_code=e.comp_code and b.comp_code=c.comp_code and b.comp_code=s.comp_code and
        b.unit_code=nvl(punitcode,b.unit_code) and b.unit_code=m.unit and b.agcd=m.agcd and b.dpcd=m.dpcd and
        b.publ=e.publ and b.publ=nvl(ppublcode,b.publ) and b.edtn=e.edtn and b.edtn=nvl(pedtncode,b.edtn) and  
        b.supdate between v_frdt and v_todt and b.sup_type_code=s.sup_ty_code and  
        e.main_edtn=nvl(pmedtncode,e.main_edtn) and (m.ag_type=pagtype or pagtype is null) and (m.ag_class=pagclass or pagclass is null) and
        (m.branch_code=pbrancode or pbrancode is null) and m.city_code=c.city_code
        group by b.comp_code,b.unit_code,b.publ,e.main_edtn,b.edtn,m.state_code,m.country_code,m.dist_code,m.tehsil_taluka,
        e.edtn_name,b.edtn,b.supdate ,nvl(s.bill_pay,'N'),
        m.city_code,c.city_name,c.zone_code,c.region_code,m.branch_code) x
        group by x.comp_code,x.unit_code,x.publ,x.main_edtn,x.edtn,x.edtn_name,x.state_name,
        x.dist_name,x.taluka_name,x.city_code,x.city_name,x.zone_code,x.region_code,x.branch_code,
        x.bill_pay,supdate;

    cursor c1 is
    select distinct billdt,to_char(billdt,'dd') sday from cir_ledger_report
    where sess_id=userenv('sessionid') order by billdt;
    
    
    v_cnt       number:=0;
    v_sess_id   number;
Begin
    select userenv('sessionid') into v_sess_id from dual;
    
    if pday_period='1' then--for 1 to 15
        v_frdt   :=to_date('01/'||pmonth||'/'||pyear,pdateformat);
        v_todt   :=to_date('15/'||pmonth||'/'||pyear,pdateformat);
    elsif pday_period='2' then--for 16 to last day of month
        v_frdt   :=to_date('16/'||pmonth||'/'||pyear,pdateformat);
        v_todt   :=last_day(v_frdt);
    else        
        v_frdt   :=to_date('01/'||pmonth||'/'||pyear,pdateformat);
        v_todt   :=last_day(v_frdt);
    end if;    

    delete from cir_ledger_report where sess_id=v_sess_id;
    
    open cur_data;
    loop
        fetch cur_data into v_comp_code,v_comp_name,v_unit_code,v_unit_name,v_state_code,v_dist_code,v_tehsil_taluka,v_city_code,
            v_city_name,v_zone_code,v_region_code,v_branch_code,v_edtn_name,
            v_bill_pay,v_supdate,v_sup_copy;
        exit when cur_data%notfound;
                
                v_zone_name     :=cir_get_zone_name(v_comp_code,v_zone_code);
                v_region_name   :=cir_get_region_name(v_comp_code,v_region_code);
                
            insert into cir_ledger_report
            (comp_code, credit_head,unit_code,agname, branch_code, billno, recptno, debit_head,chqno,chq_bank, agcd, remarks,  
                reason,rec_seqno,billdt,sess_id)
            values
            (v_comp_code,v_comp_name,v_unit_code,v_unit_name,v_branch_code,nvl(v_edtn_name,'NOT DEFINE'),nvl(v_state_code,'NOT DEFINE'),nvl(v_dist_code,'NOT DEFINE'),nvl(v_tehsil_taluka,'NOT DEFINE'),nvl(v_zone_name,'NOT DEFINE'),nvl(v_region_name,'NOT DEFINE'),nvl(v_city_name,'NOT DEFINE'),
            v_bill_pay,v_sup_copy, v_supdate,v_sess_id);

    end loop;
    close cur_data;
    commit;
    
    v_supdate:=null;

    open c1;
    loop
        fetch c1 into v_supdate,v_sday;
        exit when c1%notfound;
          if vvar is null then
              vvar      :='case when to_char(a.billdt,''dd'')='||''''||v_sday||''''||' then a.rec_seqno else 0 end "'||v_sday||'"';
              tot_vvar  :='sum("'||v_sday||'") "'||v_sday||'"';
          else
              vvar      :=vvar||',case when to_char(a.billdt,''dd'')='||''''||v_sday||''''||' then a.rec_seqno else 0 end "'||v_sday||'"';
              tot_vvar  :=tot_vvar||',sum("'||v_sday||'") "'||v_sday||'"';
          end if;
    end loop;
    close c1;
    
    If vvar is null then
        v_query1:='(select a.comp_code as comp_code, a.credit_head as comp_name,a.unit_code as unit_code,a.agname as unit_name,
                    a.branch_code as branch_code,a.billno as branch_name,a.reason as reason, a.rec_seqno as "TOTAL"
                    from cir_ledger_report a
                    where sess_id='||v_sess_id||') x
                    group by x.comp_code, x.comp_name,x.unit_code,x.unit_name, x.branch_code,x.branch_name,x.reason
                    order by x.comp_code, x.comp_name,x.unit_code,x.unit_name,x.reason,x.branch_code,x.branch_name';
                    
        v_query2:='select x.comp_code as comp_code, x.comp_name as comp_name,x.unit_code as unit_code,x.unit_name as unit_name,
                 x.branch_code as branch_code,x.branch_name as branch_name,x.reason, sum(x.TOTAL) as "TOTAL" from';            
            
        open p_accounts for v_query2||v_query1;
            
        v_query3:='(select a.comp_code as comp_code, a.credit_head as comp_name,a.unit_code as unit_code,a.agname as unit_name,
                    a.branch_code as branch_code,a.billno as branch_name,a.reason as reason, a.rec_seqno as "TOTAL"
                    from cir_ledger_report a
                    where sess_id='||v_sess_id||') x
                    group by x.comp_code, x.comp_name,x.unit_code,x.unit_name,x.reason
                    order by x.comp_code, x.comp_name,x.unit_code,x.unit_name,x.reason';
                    
        v_query4:='select x.comp_code as comp_code, x.comp_name as comp_name,x.unit_code as unit_code,x.unit_name as unit_name,
                 x.reason, sum(x.TOTAL) as "TOTAL" from';
            
        open p_accounts1 for v_query4||v_query3;
            
        v_query5:='(select a.comp_code as comp_code, a.credit_head as comp_name,a.unit_code as unit_code,a.agname as unit_name,
                    a.branch_code as branch_code,a.billno as branch_name,a.reason as reason, a.rec_seqno as "TOTAL"
                    from cir_ledger_report a
                    where sess_id='||v_sess_id||') x
                    group by x.comp_code, x.comp_name,x.unit_code,x.unit_name
                    order by x.comp_code, x.comp_name,x.unit_code,x.unit_name';
                    
        v_query6:='select x.comp_code as comp_code, x.comp_name as comp_name,x.unit_code as unit_code,x.unit_name as unit_name,
                   sum(x.TOTAL) as "TOTAL" from';




        open p_accounts2 for v_query6||v_query5;    
    Else
        if preptype='1' then--for Pcenter wise
            v_query1:='(select a.comp_code as comp_code, a.credit_head as comp_name,a.unit_code as unit_code,a.agname as unit_name,
                        a.branch_code as branch_code,a.billno as branch_name,a.reason as reason, '||vvar||', a.rec_seqno as "TOTAL"
                        from cir_ledger_report a
                        where sess_id='||v_sess_id||') x
                        group by x.comp_code, x.comp_name,x.unit_code,x.unit_name,x.reason
                        order by x.comp_code, x.comp_name,x.unit_code,x.unit_name,x.reason';
                        
            v_query2:='select x.comp_code as comp_code, x.comp_name as comp_name,x.unit_code as unit_code,x.unit_name as unit_name,
                     x.reason, '||tot_vvar||', sum(x.TOTAL) as "TOTAL" from';            
                
            v_query3:='(select a.comp_code as comp_code, a.credit_head as comp_name,a.unit_code as unit_code,a.agname as unit_name,
                        a.branch_code as branch_code,a.billno as branch_name,a.reason as reason, '||vvar||', a.rec_seqno as "TOTAL"
                        from cir_ledger_report a
                        where sess_id='||v_sess_id||') x
                        group by x.comp_code, x.comp_name,x.reason
                        order by x.comp_code, x.comp_name,x.reason';
                        
            v_query4:='select x.comp_code as comp_code, x.comp_name as comp_name,
                     x.reason, '||tot_vvar||', sum(x.TOTAL) as "TOTAL" from';
                
            v_query5:='(select a.comp_code as comp_code, a.credit_head as comp_name,a.unit_code as unit_code,a.agname as unit_name,
                        a.branch_code as branch_code,a.billno as branch_name,a.reason as reason, '||vvar||', a.rec_seqno as "TOTAL"
                        from cir_ledger_report a
                        where sess_id='||v_sess_id||') x
                        group by x.comp_code, x.comp_name
                        order by x.comp_code, x.comp_name';
                        
            v_query6:='select x.comp_code as comp_code, x.comp_name as comp_name,
                     '||tot_vvar||', sum(x.TOTAL) as "TOTAL" from';            

        Elsif preptype='2' then--for Pcenter wise branch wise
            v_query1:='(select a.comp_code as comp_code, a.credit_head as comp_name,a.unit_code as unit_code,a.agname as unit_name,
                        a.branch_code as branch_code,a.billno as branch_name,a.reason as reason, '||vvar||', a.rec_seqno as "TOTAL"
                        from cir_ledger_report a
                        where sess_id='||v_sess_id||') x
                        group by x.comp_code, x.comp_name,x.unit_code,x.unit_name, x.branch_code,x.branch_name,x.reason
                        order by x.comp_code, x.comp_name,x.unit_code,x.unit_name,x.reason,x.branch_code,x.branch_name';
                        
            v_query2:='select x.comp_code as comp_code, x.comp_name as comp_name,x.unit_code as unit_code,x.unit_name as unit_name,
                     x.branch_code as branch_code,x.branch_name as branch_name,x.reason, '||tot_vvar||', sum(x.TOTAL) as "TOTAL" from';            
                
            v_query3:='(select a.comp_code as comp_code, a.credit_head as comp_name,a.unit_code as unit_code,a.agname as unit_name,
                        a.branch_code as branch_code,a.billno as branch_name,a.reason as reason, '||vvar||', a.rec_seqno as "TOTAL"
                        from cir_ledger_report a
                        where sess_id='||v_sess_id||') x
                        group by x.comp_code, x.comp_name,x.unit_code,x.unit_name,x.reason
                        order by x.comp_code, x.comp_name,x.unit_code,x.unit_name,x.reason';
                        
            v_query4:='select x.comp_code as comp_code, x.comp_name as comp_name,x.unit_code as unit_code,x.unit_name as unit_name,
                     x.reason, '||tot_vvar||', sum(x.TOTAL) as "TOTAL" from';
                
            v_query5:='(select a.comp_code as comp_code, a.credit_head as comp_name,a.unit_code as unit_code,a.agname as unit_name,
                        a.branch_code as branch_code,a.billno as branch_name,a.reason as reason, '||vvar||', a.rec_seqno as "TOTAL"
                        from cir_ledger_report a
                        where sess_id='||v_sess_id||') x
                        group by x.comp_code, x.comp_name,x.unit_code,x.unit_name
                        order by x.comp_code, x.comp_name,x.unit_code,x.unit_name';
                        
            v_query6:='select x.comp_code as comp_code, x.comp_name as comp_name,x.unit_code as unit_code,x.unit_name as unit_name,
                     '||tot_vvar||', sum(x.TOTAL) as "TOTAL" from';            
            
        Elsif preptype='3' then--for Zone wise
            v_query1:='(select a.comp_code as comp_code, a.credit_head as comp_name,a.chq_bank as zone_name,
                        a.reason as reason, '||vvar||', a.rec_seqno as "TOTAL"
                        from cir_ledger_report a
                        where sess_id='||v_sess_id||') x
                        group by x.comp_code, x.comp_name,x.zone_name,x.reason
                        order by x.comp_code, x.comp_name,x.zone_name,x.reason';
                        
            v_query2:='select x.comp_code as comp_code, x.comp_name as comp_name,x.zone_name as zone_name,
                     x.reason, '||tot_vvar||', sum(x.TOTAL) as "TOTAL" from';            
                
            v_query3:='(select a.comp_code as comp_code, a.credit_head as comp_name,a.chq_bank as zone_name,
                        a.reason as reason, '||vvar||', a.rec_seqno as "TOTAL"
                        from cir_ledger_report a
                        where sess_id='||v_sess_id||') x
                        group by x.comp_code, x.comp_name,x.reason
                        order by x.comp_code, x.comp_name,x.reason';
                        
            v_query4:='select x.comp_code as comp_code, x.comp_name as comp_name,
                     x.reason, '||tot_vvar||', sum(x.TOTAL) as "TOTAL" from';
                
            v_query5:='(select a.comp_code as comp_code, a.credit_head as comp_name,a.chq_bank as zone_name,
                        a.reason as reason, '||vvar||', a.rec_seqno as "TOTAL"
                        from cir_ledger_report a
                        where sess_id='||v_sess_id||') x
                        group by x.comp_code, x.comp_name
                        order by x.comp_code, x.comp_name';
                        
            v_query6:='select x.comp_code as comp_code, x.comp_name as comp_name,
                     '||tot_vvar||', sum(x.TOTAL) as "TOTAL" from';

            
        Elsif preptype='4' then--for Zone wise Region wise
            v_query1:='(select a.comp_code as comp_code, a.credit_head as comp_name,a.chq_bank as zone_name,a.exec_code as region_name,
                        a.reason as reason, '||vvar||', a.rec_seqno as "TOTAL"
                        from cir_ledger_report a
                        where sess_id='||v_sess_id||') x
                        group by x.comp_code, x.comp_name,x.zone_name,x.reason,x.region_name
                        order by x.comp_code, x.comp_name,x.zone_name,x.reason,x.region_name';
                        
            v_query2:='select x.comp_code as comp_code, x.comp_name as comp_name,x.zone_name as zone_name,x.region_name as region_name,
                     x.reason, '||tot_vvar||', sum(x.TOTAL) as "TOTAL" from';            
                
            v_query3:='(select a.comp_code as comp_code, a.credit_head as comp_name,a.chq_bank as zone_name,a.exec_code as region_name,
                        a.reason as reason, '||vvar||', a.rec_seqno as "TOTAL"
                        from cir_ledger_report a
                        where sess_id='||v_sess_id||') x
                        group by x.comp_code, x.comp_name,x.zone_name,x.reason
                        order by x.comp_code, x.comp_name,x.zone_name,x.reason';
                        
            v_query4:='select x.comp_code as comp_code, x.comp_name as comp_name,x.zone_name,
                     x.reason, '||tot_vvar||', sum(x.TOTAL) as "TOTAL" from';
                
            v_query5:='(select a.comp_code as comp_code, a.credit_head as comp_name,a.chq_bank as zone_name, a.exec_code as region_name,
                        a.reason as reason, '||vvar||', a.rec_seqno as "TOTAL"
                        from cir_ledger_report a
                        where sess_id='||v_sess_id||') x
                        group by x.comp_code, x.comp_name,x.zone_name
                        order by x.comp_code, x.comp_name,x.zone_name';
                        
            v_query6:='select x.comp_code as comp_code, x.comp_name as comp_name,x.zone_name,
                     '||tot_vvar||', sum(x.TOTAL) as "TOTAL" from';

        Elsif preptype='5' then--for State wise
            v_query1:='(select a.comp_code as comp_code, a.credit_head as comp_name,a.recptno as state_name,
                        a.debit_head as dist_name,a.reason as reason, '||vvar||', a.rec_seqno as "TOTAL"
                        from cir_ledger_report a
                        where sess_id='||v_sess_id||') x
                        group by x.comp_code, x.comp_name,x.state_name,x.reason
                        order by x.comp_code, x.comp_name,x.state_name,x.reason';
                        
            v_query2:='select x.comp_code as comp_code, x.comp_name as comp_name,x.state_name as state_name,
                      x.reason, '||tot_vvar||', sum(x.TOTAL) as "TOTAL" from';
                
            v_query3:='(select a.comp_code as comp_code, a.credit_head as comp_name,a.recptno as state_name,
                        a.debit_head as dist_name,a.reason as reason, '||vvar||', a.rec_seqno as "TOTAL"
                        from cir_ledger_report a
                        where sess_id='||v_sess_id||') x
                        group by x.comp_code, x.comp_name,x.state_name
                        order by x.comp_code, x.comp_name,x.state_name';
                        
            v_query4:='select x.comp_code as comp_code, x.comp_name as comp_name,x.state_name as state_name,
                       '||tot_vvar||', sum(x.TOTAL) as "TOTAL" from';
                
            v_query5:='(select a.comp_code as comp_code, a.credit_head as comp_name,a.recptno as state_name,
                        a.debit_head as dist_name,a.reason as reason, '||vvar||', a.rec_seqno as "TOTAL"
                        from cir_ledger_report a
                        where sess_id='||v_sess_id||') x
                        group by x.comp_code, x.comp_name
                        order by x.comp_code, x.comp_name';
                        
            v_query6:='select x.comp_code as comp_code, x.comp_name as comp_name,
                     '||tot_vvar||', sum(x.TOTAL) as "TOTAL" from';

        else--for State wise district wise
            v_query1:='(select a.comp_code as comp_code, a.credit_head as comp_name,a.recptno as state_name,
                        a.debit_head as dist_name,a.reason as reason, '||vvar||', a.rec_seqno as "TOTAL"
                        from cir_ledger_report a
                        where sess_id='||v_sess_id||') x
                        group by x.comp_code, x.comp_name,x.state_name, x.dist_name,x.reason
                        order by x.comp_code, x.comp_name,x.state_name,x.reason,x.dist_name';
                        
            v_query2:='select x.comp_code as comp_code, x.comp_name as comp_name,x.state_name as state_name,
                     x.dist_name as dist_name,x.reason, '||tot_vvar||', sum(x.TOTAL) as "TOTAL" from';            
                
            v_query3:='(select a.comp_code as comp_code, a.credit_head as comp_name,a.recptno as state_name,
                        a.debit_head as dist_name,a.reason as reason, '||vvar||', a.rec_seqno as "TOTAL"
                        from cir_ledger_report a
                        where sess_id='||v_sess_id||') x
                        group by x.comp_code, x.comp_name,x.state_name, x.reason
                        order by x.comp_code, x.comp_name,x.state_name,x.reason';
                        
            v_query4:='select x.comp_code as comp_code, x.comp_name as comp_name,x.state_name as state_name,
                     x.reason, '||tot_vvar||', sum(x.TOTAL) as "TOTAL" from';
                
            v_query5:='(select a.comp_code as comp_code, a.credit_head as comp_name,a.recptno as state_name,
                        a.debit_head as dist_name,a.reason as reason, '||vvar||', a.rec_seqno as "TOTAL"
                        from cir_ledger_report a
                        where sess_id='||v_sess_id||') x
                        group by x.comp_code, x.comp_name,x.state_name
                        order by x.comp_code, x.comp_name,x.state_name';
                        
            v_query6:='select x.comp_code as comp_code, x.comp_name as comp_name,x.state_name as state_name,
                     '||tot_vvar||', sum(x.TOTAL) as "TOTAL" from';            

        End if;
       
    End if;
    

    delete from test1;
    insert into test1(vstring,vstring2) values('cir_rep_abc_daybook_summ1',v_query2||v_query1);commit;
    insert into test1(vstring,vstring2) values('cir_rep_abc_daybook_summ2',v_query4||v_query3);commit;
    insert into test1(vstring,vstring2) values('cir_rep_abc_daybook_summ3',v_query6||v_query5);commit;
                               
    open p_accounts for v_query2||v_query1;
    
    open p_accounts1 for v_query4||v_query3;
    
    open p_accounts2 for v_query6||v_query5;
    delete from cir_ledger_report where sess_id=userenv('sessionid');commit;
    
End cir_rep_abc_daybook_summ;
/
/////////////////////////////////////end update by Garima
//////////////////////////update by Garima


                                                                     
                                                                     
                                                                     
                                             
CREATE OR REPLACE procedure cir_rep_abc_supply_summ(
    pcompcode           in varchar2,
    punitcode           in varchar2,
    pbrancode           in varchar2,
    ppublcode           in varchar2, 
    pmedtncode          in varchar2,
    pedtncode           in varchar2,
    pagtype             in varchar2,
    pagclass            in varchar2,
    pstatecode          in varchar2,      
    pdistcode           in varchar2,
    ptalukacode         in varchar2,
    pcitycode           in varchar2,
    pfromdate           in varchar2,
    ptilldate           in varchar2,
    ppaid_free          in varchar2,-- P for paid supply,F for Free supply and blank for All
    preptype            in varchar2,--1 for pcentre wise branch wise report 2 for State wise city wise
    pdateformat         in varchar2,
    puserid             in varchar2,     
    pextra1             in varchar2,
    pextra2             in varchar2,
    pextra3             in varchar2,
    pextra4             in varchar2,
    pextra5             in varchar2,
    p_accounts          OUT Cur_Type_New1.cursor_type,
    p_accounts1         OUT Cur_Type_New1.cursor_type,
    p_accounts2         OUT Cur_Type_New1.cursor_type)
As
    v_frdt    date;
    v_todt    date;

    v_comp_code     varchar2(50);
    v_unit_code     varchar2(50);
    v_publ          varchar2(50);
    v_medtn         varchar2(50);
    v_edtn          varchar2(50);
    v_edtn_name     varchar2(50);
    v_state_code    varchar2(50);
    v_dist_code     varchar2(50);
    v_tehsil_taluka varchar2(50);
    v_city_code     varchar2(50);
    v_city_name     varchar2(50);
    v_zone_code     varchar2(50);
    v_region_code   varchar2(50);
    v_branch_code   varchar2(50);
    v_sup_copy      number(10);
    v_supdate       date;
    v_bill_pay      varchar2(20);
    
    cursor cur_data is
        select x.comp_code,x.unit_code,x.publ,x.main_edtn,x.edtn,x.edtn_name,x.state_name, 
        x.dist_code,x.tehsil_taluka,x.city_code,x.city_name,x.zone_code,x.region_code,x.branch_code,
        x.bill_pay,x.supdate, sum(x.sup_copy) sup_copy
        from(
        select b.comp_code,b.unit_code,b.publ,e.main_edtn,b.edtn,e.edtn_name,cir_get_state(b.comp_code,m.country_code,m.state_code) state_name, 
        m.dist_code,m.tehsil_taluka,m.city_code,c.city_name,c.zone_code,c.region_code,m.branch_code,
        b.supdate ,case when nvl(s.bill_pay,'N')='Y' then 'BILLED' else 'UNBILLED' END bill_pay, 
        sum(b.sup_copy) sup_copy
        from cir_dbksup b,cir_agmast m,cir_edtn_mast e ,cir_city_mast c,cir_supply_type_mast s
        where b.comp_code=pcompcode and b.comp_code=m.comp_code and b.comp_code=e.comp_code and b.comp_code=c.comp_code and b.comp_code=s.comp_code and
        b.unit_code=nvl(punitcode,b.unit_code) and b.unit_code=m.unit and b.agcd=m.agcd and b.dpcd=m.dpcd and 
        b.publ=e.publ and b.publ=nvl(ppublcode,b.publ) and b.edtn=e.edtn and b.edtn=nvl(pedtncode,b.edtn) and  
        b.supdate between v_frdt and v_todt and b.sup_type_code=s.sup_ty_code and  
        e.main_edtn=nvl(pmedtncode,e.main_edtn) and (m.ag_type=pagtype or pagtype is null) and (m.ag_class=pagclass or pagclass is null) and 
        (m.branch_code=pbrancode or pbrancode is null) and m.city_code=c.city_code and m.city_code=nvl(pcitycode,m.city_code) and
        (m.state_code=pstatecode or pstatecode is null) and (m.dist_code=pdistcode or pdistcode is null) and 
        (m.tehsil_taluka=ptalukacode or ptalukacode is null) and s.bill_pay=nvl(ppaid_free,s.bill_pay)
        group by b.comp_code,b.unit_code,b.publ,e.main_edtn,b.edtn,m.state_code,m.country_code,m.dist_code,m.tehsil_taluka,
        e.edtn_name,b.edtn,b.supdate ,nvl(s.bill_pay,'N'),
        m.city_code,c.city_name,c.zone_code,c.region_code,m.branch_code) x
        group by x.comp_code,x.unit_code,x.publ,x.main_edtn,x.edtn,x.edtn_name,x.state_name, 
        x.dist_code,x.tehsil_taluka,x.city_code,x.city_name,x.zone_code,x.region_code,x.branch_code,
        x.bill_pay,supdate;


     v_cnt      number:=0;
Begin
    v_frdt   :=to_date(pfromdate,''''||pdateformat||'''');
    v_todt   :=to_date(ptilldate,''''||pdateformat||'''');
    
    delete from cir_ledger_report where sess_id=userenv('sessionid');
    
    open cur_data;
    loop
        fetch cur_data into v_comp_code,v_unit_code,v_publ,v_medtn,v_edtn,v_edtn_name,v_state_code,v_dist_code,v_tehsil_taluka,v_city_code,
            v_city_name,v_zone_code,v_region_code,v_branch_code, 
            v_bill_pay,v_supdate,v_sup_copy;
        exit when cur_data%notfound;
        
            insert into cir_ledger_report
            (comp_code, unit_code, branch_code, doctype,agcd, dpcd,billno, recptno, debit_head,chqno,chq_bank, exec_code, remarks,  
                reason,rec_seqno,billdt,sess_id)
            values
            (v_comp_code,v_unit_code,v_branch_code,v_publ,v_medtn,v_edtn,v_edtn_name,v_state_code,v_dist_code,v_tehsil_taluka,v_zone_code,v_region_code,v_city_name,
            v_bill_pay,v_sup_copy, v_supdate,userenv('sessionid'));

           
    end loop;
    close cur_data;
    commit;
    
    if preptype='1' then--for Pcenter wise
            open p_accounts for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            a.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=a.unit_code) as "UNIT_NAME", 
            a.branch_code as "BRANCH_CODE",(select "Branch_Name" from branch_mst where "Branch_Code"=a.branch_code) as "BRANCH_NAME", 
            sum(a.rec_seqno) as "SUP_COPY",a.reason as "BILL_PAY"
            from cir_ledger_report a 
            where sess_id=userenv('sessionid') 
            group by a.comp_code ,a.unit_code, a.branch_code,a.reason
            order by comp_name,bill_pay,unit_name,branch_name;
            
            open p_accounts1 for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            a.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=a.unit_code) as "UNIT_NAME", 
            sum(a.rec_seqno) as "SUP_COPY",a.reason as "BILL_PAY"
            from cir_ledger_report a 
            where sess_id=userenv('sessionid') 
            group by a.comp_code ,a.unit_code, a.reason
            order by comp_name,bill_pay,unit_name;

            open p_accounts2 for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            sum(a.rec_seqno) as "SUP_COPY",a.reason as "BILL_PAY"
            from cir_ledger_report a 
            where sess_id=userenv('sessionid') 
            group by a.comp_code ,a.reason
            order by comp_name,bill_pay;
                        
    else
            open p_accounts for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            a.recptno as "STATE_NAME", a.city_code as "CITY_CODE", a.remarks as "CITY_NAME",   
            sum(a.rec_seqno) as "SUP_COPY",a.reason as "BILL_PAY"
            from cir_ledger_report a 
            where sess_id=userenv('sessionid') 
            group by a.comp_code ,a.recptno,a.city_code,a.remarks,a.reason
            order by comp_name,bill_pay,state_name,city_name;
            
            open p_accounts1 for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            a.recptno as "STATE_NAME",sum(a.rec_seqno) as "SUP_COPY",a.reason as "BILL_PAY"
            from cir_ledger_report a 
            where sess_id=userenv('sessionid') 
            group by a.comp_code ,a.recptno,a.reason
            order by comp_name,bill_pay,state_name;

            open p_accounts2 for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            sum(a.rec_seqno) as "SUP_COPY",a.reason as "BILL_PAY"
            from cir_ledger_report a 
            where sess_id=userenv('sessionid') 
            group by a.comp_code , a.reason
            order by comp_name,bill_pay;
    End if;
    
    delete from cir_ledger_report where sess_id=userenv('sessionid');commit;
    
End cir_rep_abc_supply_summ;
/

///////////////////////////////////////////////////////end by Garima


                                                                     
                                                                     
                                                                     
                                             
CREATE OR REPLACE procedure cir_rep_abc_supply_bill_return(
    pcompcode          in varchar2,
    punitcode          in varchar2,
    pbrancode          in varchar2,
    ppublcode          in varchar2, 
    pmedtncode         in varchar2,
    pedtncode          in varchar2,
    pagtype            in varchar2,
    pagclass           in varchar2,     
    pfromdate          in varchar2,
    ptilldate          in varchar2,
    pbreakon           in varchar2,--It is used for report break on 1 for State,2 for District , 3 for Taluka, 4 for zone,5 Region
    preptype           in varchar2,--1 for OK Bill report 2 for OK Bill By commission
    pdateformat        in varchar2,    
    puserid            in varchar2, 
    pextra1            in varchar2,
    pextra2            in varchar2,
    pextra3            in varchar2,
    pextra4            in varchar2,
    pextra5            in varchar2,
    p_accounts         OUT Cur_Type_New1.cursor_type,
    p_accounts1        OUT Cur_Type_New1.cursor_type)
As
    v_frdt    date;
    v_todt    date;

    v_comp_code     varchar2(50);
    v_unit_code     varchar2(50);
    v_publ          varchar2(50);
    v_medtn         varchar2(50);
    v_edtn          varchar2(50);
    v_edtn_name     varchar2(50);
    v_state_code    varchar2(50);
    v_dist_code     varchar2(50);
    v_tehsil_taluka varchar2(50);
    v_city_code     varchar2(50);
    v_city_name     varchar2(50);
    v_zone_code     varchar2(50);
    v_region_code   varchar2(50);
    v_sup_rate      number(15,4);
    v_comm_rate     number(15,4);
    v_comm_type     varchar2(1);
    v_bill_copy     number(10);
    v_gross_amt     number(15,2);
    v_comm_amt      number(15,2);
    v_sur_amt       number(15,2);
    v_bill_amt      number(15,2);
    
    v_apr_unsold        number(15);
    v_apr_short_recpt   number(15); 
    v_apr_late_recpt    number(15);
    v_apr_bnr           number(15);
    v_apr_damage        number(15);    
    
    
 
    cursor cur_data is
        select x.comp_code,x.unit_code,x.publ,x.main_edtn,x.edtn,x.edtn_name,x.state_name, 
        x.dist_code,x.tehsil_taluka,x.city_code,x.city_name,x.zone_code,x.region_code,
        x.copy_rate,x.comm_rate,x.comm_type, 
        sum(x.bill_copy) bill_copy, sum(x.gross_amt) gross_amt, sum(x.comm_amt) comm_amt, sum(x.sur_amt) sur_amt,sum(x.bill_amt) bill_amt,
        sum(x.apr_unsold) apr_unsold ,sum(x.apr_short_recpt) apr_short_recpt, sum(x.apr_late_recpt) apr_late_recpt,sum(x.apr_bnr) apr_bnr,sum(x.apr_damage) apr_damage
        from(
        select b.comp_code,b.unit_code,b.publ,e.main_edtn,b.edtn,e.edtn_name,cir_get_state(b.comp_code,m.country_code,m.state_code) state_name, 
        m.dist_code,m.tehsil_taluka,m.city_code,c.city_name,c.zone_code,c.region_code,
        b.copy_rate,b.comm_rate,nvl(b.comm_type,case when b.copy_rate>b.comm_rate then 'C' else 'P' end) comm_type,  
        sum(b.bill_copy) bill_copy, sum(b.gross_amount) gross_amt, sum(b.comm_amt) comm_amt, sum(b.sur_amt) sur_amt,sum(b.bill_amount) bill_amt,
        0 apr_unsold ,0 apr_short_recpt, 0 apr_late_recpt,0 apr_bnr,0 apr_damage
        from cir_bill_det b,cir_agmast m,cir_edtn_mast e ,cir_city_mast c
        where b.comp_code=pcompcode and b.comp_code=m.comp_code and b.comp_code=e.comp_code and b.comp_code=c.comp_code and 
        b.unit_code=nvl(punitcode,b.unit_code) and b.unit_code=m.unit 
        and b.billdt between v_frdt and v_todt 
        and b.agcd=m.agcd and b.dpcd=m.dpcd and
        b.publ=e.publ and b.publ=nvl(ppublcode,b.publ) and b.edtn=e.edtn and b.edtn=nvl(pedtncode,b.edtn) and e.main_edtn=nvl(pmedtncode,e.main_edtn) and 
        (m.ag_type=pagtype or pagtype is null) and (m.ag_class=pagclass or pagclass is null) and (m.branch_code=pbrancode or pbrancode is null) and 
        m.city_code=c.city_code 
        group by b.comp_code,b.unit_code,b.publ,e.main_edtn,b.edtn,m.state_code,m.country_code,m.dist_code,m.tehsil_taluka,
        e.edtn_name,b.edtn,
        m.city_code,c.city_name,c.zone_code,c.region_code,b.copy_rate,b.comm_rate,b.comm_type
        union all
        select b.comp_code,b.unit_code,b.publ,e.main_edtn,b.edtn,e.edtn_name,cir_get_state(b.comp_code,m.country_code,m.state_code) state_name, 
        m.dist_code,m.tehsil_taluka,m.city_code,c.city_name,c.zone_code,c.region_code,
        b.copy_rate,b.comm_rate,nvl(b.comm_catg_type,case when b.copy_rate>b.comm_rate then 'C' else 'P' end) comm_type, 
        0 bill_copy, 0 gross_amt, 0 comm_amt, 0 sur_amt,0 bill_amt,
        sum(nvl(b.apr_unsold,0)) apr_unsold ,sum(nvl(b.apr_short_recpt,0)) apr_short_recpt, sum(nvl(b.apr_late_recpt,0)) apr_late_recpt,
        sum(nvl(b.apr_bnr,0)) apr_bnr,sum(nvl(b.apr_damage,0)) apr_damage
        from cir_unsold_dtl b,cir_agmast m,cir_edtn_mast e ,cir_city_mast c
        where b.comp_code=pcompcode and b.comp_code=m.comp_code and b.comp_code=e.comp_code and b.comp_code=c.comp_code and 
        b.unit_code=nvl(punitcode,b.unit_code) and b.unit_code=m.unit 
        and b.app_dt between v_frdt and v_todt 
        and b.agcd=m.agcd and b.dpcd=m.dpcd and
        b.publ=e.publ and b.publ=nvl(ppublcode,b.publ) and b.edtn=e.edtn and b.edtn=nvl(pedtncode,b.edtn) and e.main_edtn=nvl(pmedtncode,e.main_edtn) and 
        (m.ag_type=pagtype or pagtype is null) and (m.ag_class=pagclass or pagclass is null) and (m.branch_code=pbrancode or pbrancode is null) and 
        m.city_code=c.city_code 
        group by b.comp_code,b.unit_code,b.publ,e.main_edtn,b.edtn,m.state_code,m.country_code,m.dist_code,m.tehsil_taluka,
        e.edtn_name,b.edtn,
        m.city_code,c.city_name,c.zone_code,c.region_code,b.copy_rate,b.comm_rate,b.comm_catg_type) x
        group by x.comp_code,x.unit_code,x.publ,x.main_edtn,x.edtn,x.edtn_name,x.state_name, 
        x.dist_code,x.tehsil_taluka,x.city_code,x.city_name,x.zone_code,x.region_code,x.copy_rate,x.comm_rate,x.comm_type;


     v_cnt      number:=0;
Begin
    v_frdt   :=to_date(pfromdate,''''||pdateformat||'''');
    v_todt   :=to_date(ptilldate,''''||pdateformat||'''');
    
    

    delete from cir_ledger_report where sess_id=userenv('sessionid');
    
    open cur_data;
    loop
        fetch cur_data into v_comp_code,v_unit_code,v_publ,v_medtn,v_edtn,v_edtn_name,v_state_code,v_dist_code,v_tehsil_taluka,v_city_code,
            v_city_name,v_zone_code,v_region_code,v_sup_rate,v_comm_rate,v_comm_type, 
            v_bill_copy, v_gross_amt, v_comm_amt, v_sur_amt,v_bill_amt,v_apr_unsold,
            v_apr_short_recpt,v_apr_late_recpt,v_apr_bnr,v_apr_damage;
        exit when cur_data%notfound;
        
        if preptype='1' then
            insert into cir_ledger_report
            (comp_code, unit_code, branch_code, agcd, dpcd,billno, recptno, debit_head,chqno,chq_bank, exec_code, remarks,  
                rec_seqno,opbal_sec,amount, billamt, adjamt, leftamt,city_code,sess_id)
            values
            (v_comp_code,v_unit_code,v_publ,v_medtn,v_edtn,v_edtn_name,v_state_code,v_dist_code,v_tehsil_taluka,v_zone_code,v_region_code,v_city_name,
            v_bill_copy, v_apr_unsold,v_apr_short_recpt,v_apr_late_recpt,v_apr_bnr,v_apr_damage,v_city_code,userenv('sessionid'));
        else
            
            insert into cir_ledger_report
            (comp_code, unit_code, branch_code, agcd, dpcd,billno, recptno, debit_head,chqno,chq_bank, exec_code, remarks,  
                rec_seqno,amount, billamt, adjamt, leftamt,city_code,sess_id,
                opbal_sec, reason,doctype)
            values
            (v_comp_code,v_unit_code,v_publ,v_medtn,v_edtn,v_edtn_name,v_state_code,v_dist_code,v_tehsil_taluka,v_zone_code,v_region_code,v_city_name,
            v_bill_copy, v_gross_amt,v_bill_amt,v_comm_amt,v_sur_amt,v_city_code,userenv('sessionid'),
            v_sup_rate,v_comm_rate,v_comm_type);        
        end if;            
    end loop;
    close cur_data;
    commit;
    
    if preptype='1' then
        If pbreakon='1' then--for State
            open p_accounts for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            a.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=a.unit_code) as "UNIT_NAME", 
            a.branch_code as "PUBL_CODE",cir_get_publ_name(a.comp_code,a.branch_code) as "PUBL_NAME", a.agcd as "MEDTN",cir_get_edtn_name(a.comp_code,a.agcd) as "MEDTN_NAME", 
            a.dpcd as "EDTN", a.billno as "EDTN_NAME",a.recptno as "STATE_NAME", a.debit_head as "DIST_CODE",cir_get_name.cir_district(a.comp_code,a.debit_head,'1',pdateformat,null,null) as "DIST_NAME",
            a.city_code as "CITY_CODE", a.remarks as "CITY_NAME",a.chqno as "TALUKA_CODE",cir_get_taluka(a.comp_code,a.chqno) as "TALUKA_NAME", 
            a.chq_bank as "ZONE_CODE",cir_get_zone_name(a.comp_code,a.chq_bank) as "ZONE_NAME", 
            a.exec_code as "REGION_CODE",cir_get_zone_name(a.comp_code,a.exec_code) as "REGION_NAME",   
            sum(a.rec_seqno) as "BILL_COPY",sum(a.opbal_sec) as "UNSOLD",sum(a.amount) as "SHORT", sum(a.adjamt) as "LATE", sum(a.leftamt) as "MISSING", sum(a.billamt) as "DAMAGE",
            sum(nvl(a.rec_seqno,0)-(nvl(a.opbal_sec,0)+nvl(a.amount,0)+nvl(a.adjamt,0)+nvl(a.leftamt,0)+nvl(a.billamt,0))) as "TOTAL"
            from cir_ledger_report a 
            where sess_id=userenv('sessionid') 
            group by a.comp_code ,a.unit_code, a.branch_code,a.agcd, a.dpcd, a.billno,a.recptno, a.debit_head,
            a.city_code,a.remarks,a.chqno, a.chq_bank,a.exec_code
            order by comp_name,unit_name,state_name,publ_name,medtn_name,edtn_name;
            
            open p_accounts1 for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            a.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=a.unit_code) as "UNIT_NAME", 
            a.recptno as "STATE_NAME", sum(a.rec_seqno) as "BILL_COPY",sum(a.opbal_sec) as "UNSOLD",sum(a.amount) as "SHORT", sum(a.adjamt) as "LATE", 
            sum(a.leftamt) as "MISSING", sum(a.billamt) as "DAMAGE",
            sum(nvl(a.rec_seqno,0)-(nvl(a.opbal_sec,0)+nvl(a.amount,0)+nvl(a.adjamt,0)+nvl(a.leftamt,0)+nvl(a.billamt,0))) as "TOTAL" 
            from cir_ledger_report a 
            where sess_id=userenv('sessionid')
            group by a.comp_code ,a.unit_code , a.recptno
            order by comp_name,unit_name,state_name;
            
        Elsif pbreakon='2' then--for District
            open p_accounts for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            a.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=a.unit_code) as "UNIT_NAME", 
            a.branch_code as "PUBL_CODE",cir_get_publ_name(a.comp_code,a.branch_code) as "PUBL_NAME", a.agcd as "MEDTN",cir_get_edtn_name(a.comp_code,a.agcd) as "MEDTN_NAME", 
            a.dpcd as "EDTN", a.billno as "EDTN_NAME",a.recptno as "STATE_NAME", a.debit_head as "DIST_CODE",cir_get_name.cir_district(a.comp_code,a.debit_head,'1',pdateformat,null,null) as "DIST_NAME",
            a.city_code as "CITY_CODE", a.remarks as "CITY_NAME",a.chqno as "TALUKA_CODE",cir_get_taluka(a.comp_code,a.chqno) as "TALUKA_NAME", 
            a.chq_bank as "ZONE_CODE",cir_get_zone_name(a.comp_code,a.chq_bank) as "ZONE_NAME", 
            a.exec_code as "REGION_CODE",cir_get_zone_name(a.comp_code,a.exec_code) as "REGION_NAME",   
            sum(a.rec_seqno) as "BILL_COPY",sum(a.opbal_sec) as "UNSOLD",sum(a.amount) as "SHORT", sum(a.adjamt) as "LATE", sum(a.leftamt) as "MISSING", sum(a.billamt) as "DAMAGE",
            sum(nvl(a.rec_seqno,0)-(nvl(a.opbal_sec,0)+nvl(a.amount,0)+nvl(a.adjamt,0)+nvl(a.leftamt,0)+nvl(a.billamt,0))) as "TOTAL" 
            from cir_ledger_report a 
            where sess_id=userenv('sessionid') 
            group by a.comp_code ,a.unit_code, a.branch_code,a.agcd, a.dpcd, a.billno,a.recptno,a.debit_head,
            a.city_code, a.remarks,a.chqno,a.chq_bank, a.exec_code 
            order by comp_name,unit_name,state_name,dist_name,publ_name,medtn_name,edtn_name;
            
            open p_accounts1 for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            a.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=a.unit_code) as "UNIT_NAME", 
            a.recptno as "STATE_NAME",a.debit_head as "DIST_CODE",cir_get_name.cir_district(a.comp_code,a.debit_head,'1',pdateformat,null,null) as "DIST_NAME", 
            sum(a.rec_seqno) as "BILL_COPY",sum(a.opbal_sec) as "UNSOLD",sum(a.amount) as "SHORT", sum(a.adjamt) as "LATE", 
            sum(a.leftamt) as "MISSING", sum(a.billamt) as "DAMAGE",
            sum(nvl(a.rec_seqno,0)-(nvl(a.opbal_sec,0)+nvl(a.amount,0)+nvl(a.adjamt,0)+nvl(a.leftamt,0)+nvl(a.billamt,0))) as "TOTAL" 
            from cir_ledger_report a 
            where sess_id=userenv('sessionid')
            group by a.comp_code ,a.unit_code , a.recptno,a.debit_head
            order by comp_name,unit_name,state_name,dist_name;
            
        Elsif pbreakon='3' then--for Taluka
            open p_accounts for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            a.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=a.unit_code) as "UNIT_NAME", 
            a.branch_code as "PUBL_CODE",cir_get_publ_name(a.comp_code,a.branch_code) as "PUBL_NAME", a.agcd as "MEDTN",cir_get_edtn_name(a.comp_code,a.agcd) as "MEDTN_NAME", 
            a.dpcd as "EDTN", a.billno as "EDTN_NAME",a.recptno as "STATE_NAME", a.debit_head as "DIST_CODE",cir_get_name.cir_district(a.comp_code,a.debit_head,'1',pdateformat,null,null) as "DIST_NAME",
            a.city_code as "CITY_CODE", a.remarks as "CITY_NAME",a.chqno as "TALUKA_CODE",cir_get_taluka(a.comp_code,a.chqno) as "TALUKA_NAME", 
            a.chq_bank as "ZONE_CODE",cir_get_zone_name(a.comp_code,a.chq_bank) as "ZONE_NAME", 
            a.exec_code as "REGION_CODE",cir_get_zone_name(a.comp_code,a.exec_code) as "REGION_NAME",   
            sum(a.rec_seqno) as "BILL_COPY",sum(a.opbal_sec) as "UNSOLD",sum(a.amount) as "SHORT", sum(a.adjamt) as "LATE", 
            sum(a.leftamt) as "MISSING", sum(a.billamt) as "DAMAGE",
            sum(nvl(a.rec_seqno,0)-(nvl(a.opbal_sec,0)+nvl(a.amount,0)+nvl(a.adjamt,0)+nvl(a.leftamt,0)+nvl(a.billamt,0))) as "TOTAL" 
            from cir_ledger_report a 
            where sess_id=userenv('sessionid') 
            group by a.comp_code,a.unit_code, a.branch_code, a.agcd ,a.dpcd, a.billno,a.recptno, a.debit_head,
            a.city_code, a.remarks,a.chqno,a.chq_bank,a.exec_code 
            order by comp_name,unit_name,state_name,dist_name,taluka_name,publ_name,medtn_name,edtn_name;
            
            open p_accounts1 for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            a.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=a.unit_code) as "UNIT_NAME", 
            a.recptno as "STATE_NAME",a.debit_head as "DIST_CODE",cir_get_name.cir_district(a.comp_code,a.debit_head,'1',pdateformat,null,null) as "DIST_NAME",
            a.chqno as "TALUKA_CODE",cir_get_taluka(a.comp_code,a.chqno) as "TALUKA_NAME", 
            sum(a.rec_seqno) as "BILL_COPY",sum(a.opbal_sec) as "UNSOLD",sum(a.amount) as "SHORT", sum(a.adjamt) as "LATE", 
            sum(a.leftamt) as "MISSING", sum(a.billamt) as "DAMAGE",
            sum(nvl(a.rec_seqno,0)-(nvl(a.opbal_sec,0)+nvl(a.amount,0)+nvl(a.adjamt,0)+nvl(a.leftamt,0)+nvl(a.billamt,0))) as "TOTAL" 
            from cir_ledger_report a 
            where sess_id=userenv('sessionid')
            group by a.comp_code ,a.unit_code , a.recptno,a.debit_head,a.chqno
            order by comp_name,unit_name,state_name,dist_name,taluka_name;
            
        Elsif pbreakon='4' then--for Zone
            open p_accounts for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            a.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=a.unit_code) as "UNIT_NAME", 
            a.branch_code as "PUBL_CODE",cir_get_publ_name(a.comp_code,a.branch_code) as "PUBL_NAME", a.agcd as "MEDTN",cir_get_edtn_name(a.comp_code,a.agcd) as "MEDTN_NAME", 
            a.dpcd as "EDTN", a.billno as "EDTN_NAME",a.recptno as "STATE_NAME", a.debit_head as "DIST_CODE",cir_get_name.cir_district(a.comp_code,a.debit_head,'1',pdateformat,null,null) as "DIST_NAME",
            a.city_code as "CITY_CODE", a.remarks as "CITY_NAME",a.chqno as "TALUKA_CODE",cir_get_taluka(a.comp_code,a.chqno) as "TALUKA_NAME", 
            a.chq_bank as "ZONE_CODE",cir_get_zone_name(a.comp_code,a.chq_bank) as "ZONE_NAME", 
            a.exec_code as "REGION_CODE",cir_get_zone_name(a.comp_code,a.exec_code) as "REGION_NAME",   
            sum(a.rec_seqno) as "BILL_COPY",sum(a.opbal_sec) as "UNSOLD",sum(a.amount) as "SHORT", sum(a.adjamt) as "LATE", 
            sum(a.leftamt) as "MISSING", sum(a.billamt) as "DAMAGE",
            sum(nvl(a.rec_seqno,0)-(nvl(a.opbal_sec,0)+nvl(a.amount,0)+nvl(a.adjamt,0)+nvl(a.leftamt,0)+nvl(a.billamt,0))) as "TOTAL" 
            from cir_ledger_report a 
            where sess_id=userenv('sessionid') 
            group by a.comp_code,a.unit_code, a.branch_code, a.agcd, a.dpcd ,a.recptno, a.debit_head,
            a.city_code, a.remarks,a.chqno, a.chq_bank, a.exec_code 
            order by comp_name,unit_name,zone_name,publ_name,medtn_name,edtn_name;
            
            open p_accounts1 for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            a.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=a.unit_code) as "UNIT_NAME", 
            a.chq_bank as "ZONE_CODE",cir_get_zone_name(a.comp_code,a.chq_bank) as "ZONE_NAME",
            sum(a.rec_seqno) as "BILL_COPY",sum(a.opbal_sec) as "UNSOLD",sum(a.amount) as "SHORT", sum(a.adjamt) as "LATE", 
            sum(a.leftamt) as "MISSING", sum(a.billamt) as "DAMAGE",
            sum(nvl(a.rec_seqno,0)-(nvl(a.opbal_sec,0)+nvl(a.amount,0)+nvl(a.adjamt,0)+nvl(a.leftamt,0)+nvl(a.billamt,0))) as "TOTAL" 
            from cir_ledger_report a 
            where sess_id=userenv('sessionid')
            group by a.comp_code ,a.unit_code , a.chq_bank
            order by comp_name,unit_name,zone_name;
        Else--for Region Wise                
            open p_accounts for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            a.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=a.unit_code) as "UNIT_NAME", 
            a.branch_code as "PUBL_CODE",cir_get_publ_name(a.comp_code,a.branch_code) as "PUBL_NAME", a.agcd as "MEDTN",cir_get_edtn_name(a.comp_code,a.agcd) as "MEDTN_NAME", 
            a.dpcd as "EDTN", a.billno as "EDTN_NAME",a.recptno as "STATE_NAME", a.debit_head as "DIST_CODE",cir_get_name.cir_district(a.comp_code,a.debit_head,'1',pdateformat,null,null) as "DIST_NAME",
            a.city_code as "CITY_CODE", a.remarks as "CITY_NAME",a.chqno as "TALUKA_CODE",cir_get_taluka(a.comp_code,a.chqno) as "TALUKA_NAME", 
            a.chq_bank as "ZONE_CODE",cir_get_zone_name(a.comp_code,a.chq_bank) as "ZONE_NAME", 
            a.exec_code as "REGION_CODE",cir_get_zone_name(a.comp_code,a.exec_code) as "REGION_NAME",   
            sum(a.rec_seqno) as "BILL_COPY",sum(a.opbal_sec) as "UNSOLD",sum(a.amount) as "SHORT", sum(a.adjamt) as "LATE", 
            sum(a.leftamt) as "MISSING", sum(a.billamt) as "DAMAGE",
            sum(nvl(a.rec_seqno,0)-(nvl(a.opbal_sec,0)+nvl(a.amount,0)+nvl(a.adjamt,0)+nvl(a.leftamt,0)+nvl(a.billamt,0))) as "TOTAL" 
            from cir_ledger_report a 
            where sess_id=userenv('sessionid') 
            group by a.comp_code,a.unit_code, a.branch_code, a.agcd, a.dpcd,a.recptno, a.debit_head,
            a.city_code, a.remarks,a.chqno,a.chq_bank,a.exec_code
            order by comp_name,unit_name,zone_name,region_name,publ_name,medtn_name,edtn_name;
            
            open p_accounts1 for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            a.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=a.unit_code) as "UNIT_NAME", 
            a.chq_bank as "ZONE_CODE",cir_get_zone_name(a.comp_code,a.chq_bank) as "ZONE_NAME",
            a.exec_code as "REGION_CODE",cir_get_zone_name(a.comp_code,a.exec_code) as "REGION_NAME",
            sum(a.rec_seqno) as "BILL_COPY",sum(a.opbal_sec) as "UNSOLD",sum(a.amount) as "SHORT", sum(a.adjamt) as "LATE", 
            sum(a.leftamt) as "MISSING", sum(a.billamt) as "DAMAGE",
            sum(nvl(a.rec_seqno,0)-(nvl(a.opbal_sec,0)+nvl(a.amount,0)+nvl(a.adjamt,0)+nvl(a.leftamt,0)+nvl(a.billamt,0))) as "TOTAL" 
            from cir_ledger_report a 
            where sess_id=userenv('sessionid')
            group by a.comp_code ,a.unit_code , a.chq_bank,a.exec_code
            order by comp_name,unit_name,zone_name,region_name;
        End if;
    Else
        If pbreakon='1' then--for State
            open p_accounts for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            a.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=a.unit_code) as "UNIT_NAME", 
            a.branch_code as "PUBL_CODE",cir_get_publ_name(a.comp_code,a.branch_code) as "PUBL_NAME", a.agcd as "MEDTN",cir_get_edtn_name(a.comp_code,a.agcd) as "MEDTN_NAME", 
            a.dpcd as "EDTN", a.billno as "EDTN_NAME",a.recptno as "STATE_NAME", a.debit_head as "DIST_CODE",cir_get_name.cir_district(a.comp_code,a.debit_head,'1',pdateformat,null,null) as "DIST_NAME",
            a.city_code as "CITY_CODE", a.remarks as "CITY_NAME",a.chqno as "TALUKA_CODE",cir_get_taluka(a.comp_code,a.chqno) as "TALUKA_NAME", 
            a.chq_bank as "ZONE_CODE",cir_get_zone_name(a.comp_code,a.chq_bank) as "ZONE_NAME", 
            a.exec_code as "REGION_CODE",cir_get_zone_name(a.comp_code,a.exec_code) as "REGION_NAME",   
            sum(a.rec_seqno) as "BILL_COPY",to_number(a.reason) as "COMM_RATE",a.doctype as "COMM_TYPE",a.opbal_sec as "COPY_RATE",
            case when a.doctype='P' then round(to_number(a.reason)/100,2) else to_number(a.reason) end as "NET_RATE",
            nvl(sum(a.amount),0)-nvl(sum(a.adjamt),0) as "TOTAL",
            sum(a.amount) as "GROSS_AMT", sum(a.adjamt) as "COMM_AMT", sum(a.leftamt) as "SUR_AMT", sum(a.billamt) as "BILL_AMT"
            from cir_ledger_report a 
            where sess_id=userenv('sessionid') 
            group by a.comp_code ,a.unit_code , a.branch_code , a.agcd , a.dpcd, a.billno,a.recptno, a.debit_head,
            a.city_code, a.remarks,a.chqno, a.chq_bank, a.exec_code,to_number(a.reason),a.doctype,a.opbal_sec
            order by comp_name,unit_name,state_name,publ_name,medtn_name,edtn_name;
            
            open p_accounts1 for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            a.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=a.unit_code) as "UNIT_NAME", 
            a.recptno as "STATE_NAME", 
            sum(a.rec_seqno) as "BILL_COPY",nvl(sum(a.amount),0)-nvl(sum(a.adjamt),0) as "TOTAL",
            sum(a.amount) as "GROSS_AMT", sum(a.adjamt) as "COMM_AMT", sum(a.leftamt) as "SUR_AMT", sum(a.billamt) as "BILL_AMT" 
            from cir_ledger_report a 
            where sess_id=userenv('sessionid')
            group by a.comp_code ,a.unit_code , a.recptno
            order by comp_name,unit_name,state_name;
            
        Elsif pbreakon='2' then--for District
            open p_accounts for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            a.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=a.unit_code) as "UNIT_NAME", 
            a.branch_code as "PUBL_CODE",cir_get_publ_name(a.comp_code,a.branch_code) as "PUBL_NAME", a.agcd as "MEDTN",cir_get_edtn_name(a.comp_code,a.agcd) as "MEDTN_NAME", 
            a.dpcd as "EDTN", a.billno as "EDTN_NAME",a.recptno as "STATE_NAME", a.debit_head as "DIST_CODE",cir_get_name.cir_district(a.comp_code,a.debit_head,'1',pdateformat,null,null) as "DIST_NAME",
            a.city_code as "CITY_CODE", a.remarks as "CITY_NAME",a.chqno as "TALUKA_CODE",cir_get_taluka(a.comp_code,a.chqno) as "TALUKA_NAME", 
            a.chq_bank as "ZONE_CODE",cir_get_zone_name(a.comp_code,a.chq_bank) as "ZONE_NAME", 
            a.exec_code as "REGION_CODE",cir_get_zone_name(a.comp_code,a.exec_code) as "REGION_NAME",   
            sum(a.rec_seqno) as "BILL_COPY",to_number(a.reason) as "COMM_RATE",a.doctype as "COMM_TYPE",a.opbal_sec as "COPY_RATE",
            case when a.doctype='P' then round(to_number(a.reason)/100,2) else to_number(a.reason) end as "NET_RATE",
            nvl(sum(a.amount),0)-nvl(sum(a.adjamt),0) as "TOTAL",
            sum(a.amount) as "GROSS_AMT", sum(a.adjamt) as "COMM_AMT", sum(a.leftamt) as "SUR_AMT", sum(a.billamt) as "BILL_AMT"
            from cir_ledger_report a 
            where sess_id=userenv('sessionid') order by comp_name,unit_name,state_name,dist_name,publ_name,medtn_name,edtn_name;
            
            open p_accounts1 for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            a.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=a.unit_code) as "UNIT_NAME", 
            a.recptno as "STATE_NAME",a.debit_head as "DIST_CODE",cir_get_name.cir_district(a.comp_code,a.debit_head,'1',pdateformat,null,null) as "DIST_NAME", 
            sum(a.rec_seqno) as "BILL_COPY",nvl(sum(a.amount),0)-nvl(sum(a.adjamt),0) as "TOTAL",
            sum(a.amount) as "GROSS_AMT", sum(a.adjamt) as "COMM_AMT", sum(a.leftamt) as "SUR_AMT", sum(a.billamt) as "BILL_AMT" 
            from cir_ledger_report a 
            where sess_id=userenv('sessionid')
            group by a.comp_code ,a.unit_code , a.recptno,a.debit_head
            order by comp_name,unit_name,state_name,dist_name;
            
        Elsif pbreakon='3' then--for Taluka
            open p_accounts for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            a.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=a.unit_code) as "UNIT_NAME", 
            a.branch_code as "PUBL_CODE",cir_get_publ_name(a.comp_code,a.branch_code) as "PUBL_NAME", a.agcd as "MEDTN",cir_get_edtn_name(a.comp_code,a.agcd) as "MEDTN_NAME", 
            a.dpcd as "EDTN", a.billno as "EDTN_NAME",a.recptno as "STATE_NAME", a.debit_head as "DIST_CODE",cir_get_name.cir_district(a.comp_code,a.debit_head,'1',pdateformat,null,null) as "DIST_NAME",
            a.city_code as "CITY_CODE", a.remarks as "CITY_NAME",a.chqno as "TALUKA_CODE",cir_get_taluka(a.comp_code,a.chqno) as "TALUKA_NAME", 
            a.chq_bank as "ZONE_CODE",cir_get_zone_name(a.comp_code,a.chq_bank) as "ZONE_NAME", 
            a.exec_code as "REGION_CODE",cir_get_zone_name(a.comp_code,a.exec_code) as "REGION_NAME",   
            sum(a.rec_seqno) as "BILL_COPY",to_number(a.reason) as "COMM_RATE",a.doctype as "COMM_TYPE",a.opbal_sec as "COPY_RATE",
            case when a.doctype='P' then round(to_number(a.reason)/100,2) else to_number(a.reason) end as "NET_RATE",
            nvl(sum(a.amount),0)-nvl(sum(a.adjamt),0) as "TOTAL",
            sum(a.amount) as "GROSS_AMT", sum(a.adjamt) as "COMM_AMT", sum(a.leftamt) as "SUR_AMT", sum(a.billamt) as "BILL_AMT" 
            from cir_ledger_report a 
            where sess_id=userenv('sessionid') 
            group by a.comp_code ,a.unit_code , a.branch_code, a.agcd , a.dpcd, a.billno ,a.recptno , a.debit_head ,
            a.city_code , a.remarks,a.chqno , a.chq_bank, a.exec_code 
            order by comp_name,unit_name,state_name,dist_name,taluka_name,publ_name,medtn_name,edtn_name;
            
            open p_accounts1 for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            a.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=a.unit_code) as "UNIT_NAME", 
            a.recptno as "STATE_NAME",a.debit_head as "DIST_CODE",cir_get_name.cir_district(a.comp_code,a.debit_head,'1',pdateformat,null,null) as "DIST_NAME",
            a.chqno as "TALUKA_CODE",cir_get_taluka(a.comp_code,a.chqno) as "TALUKA_NAME", 
            sum(a.rec_seqno) as "BILL_COPY",nvl(sum(a.amount),0)-nvl(sum(a.adjamt),0) as "TOTAL",
            sum(a.amount) as "GROSS_AMT", sum(a.adjamt) as "COMM_AMT", sum(a.leftamt) as "SUR_AMT", sum(a.billamt) as "BILL_AMT" 
            from cir_ledger_report a 
            where sess_id=userenv('sessionid')
            group by a.comp_code ,a.unit_code , a.recptno,a.debit_head,a.chqno
            order by comp_name,unit_name,state_name,dist_name,taluka_name;
            
        Elsif pbreakon='4' then--for Zone
            open p_accounts for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            a.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=a.unit_code) as "UNIT_NAME", 
            a.branch_code as "PUBL_CODE",cir_get_publ_name(a.comp_code,a.branch_code) as "PUBL_NAME", a.agcd as "MEDTN",cir_get_edtn_name(a.comp_code,a.agcd) as "MEDTN_NAME", 
            a.dpcd as "EDTN", a.billno as "EDTN_NAME",a.recptno as "STATE_NAME", a.debit_head as "DIST_CODE",cir_get_name.cir_district(a.comp_code,a.debit_head,'1',pdateformat,null,null) as "DIST_NAME",
            a.city_code as "CITY_CODE", a.remarks as "CITY_NAME",a.chqno as "TALUKA_CODE",cir_get_taluka(a.comp_code,a.chqno) as "TALUKA_NAME", 
            a.chq_bank as "ZONE_CODE",cir_get_zone_name(a.comp_code,a.chq_bank) as "ZONE_NAME", 
            a.exec_code as "REGION_CODE",cir_get_zone_name(a.comp_code,a.exec_code) as "REGION_NAME",   
            sum(a.rec_seqno) as "BILL_COPY",to_number(a.reason) as "COMM_RATE",a.doctype as "COMM_TYPE",a.opbal_sec as "COPY_RATE",
            case when a.doctype='P' then round(to_number(a.reason)/100,2) else to_number(a.reason) end as "NET_RATE",
            nvl(sum(a.amount),0)-nvl(sum(a.adjamt),0) as "TOTAL",
            sum(a.amount) as "GROSS_AMT", sum(a.adjamt) as "COMM_AMT", sum(a.leftamt) as "SUR_AMT", sum(a.billamt) as "BILL_AMT" 
            from cir_ledger_report a 
            where sess_id=userenv('sessionid') 
            group by a.comp_code ,a.unit_code , a.branch_code , a.agcd , a.dpcd, a.billno ,a.recptno , a.debit_head ,
            a.city_code , a.remarks,a.chqno , a.chq_bank, a.exec_code 
            order by comp_name,unit_name,zone_name,publ_name,medtn_name,edtn_name;
            
            open p_accounts1 for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            a.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=a.unit_code) as "UNIT_NAME", 
            a.chq_bank as "ZONE_CODE",cir_get_zone_name(a.comp_code,a.chq_bank) as "ZONE_NAME",
            sum(a.rec_seqno) as "BILL_COPY",nvl(sum(a.amount),0)-nvl(sum(a.adjamt),0) as "TOTAL",
            sum(a.amount) as "GROSS_AMT", sum(a.adjamt) as "COMM_AMT", sum(a.leftamt) as "SUR_AMT", sum(a.billamt) as "BILL_AMT" 
            from cir_ledger_report a 
            where sess_id=userenv('sessionid')
            group by a.comp_code ,a.unit_code , a.chq_bank
            order by comp_name,unit_name,zone_name;
        Else--for Region Wise                
            open p_accounts for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            a.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=a.unit_code) as "UNIT_NAME", 
            a.branch_code as "PUBL_CODE",cir_get_publ_name(a.comp_code,a.branch_code) as "PUBL_NAME", a.agcd as "MEDTN",cir_get_edtn_name(a.comp_code,a.agcd) as "MEDTN_NAME", 
            a.dpcd as "EDTN", a.billno as "EDTN_NAME",a.recptno as "STATE_NAME", a.debit_head as "DIST_CODE",cir_get_name.cir_district(a.comp_code,a.debit_head,'1',pdateformat,null,null) as "DIST_NAME",
            a.city_code as "CITY_CODE", a.remarks as "CITY_NAME",a.chqno as "TALUKA_CODE",cir_get_taluka(a.comp_code,a.chqno) as "TALUKA_NAME", 
            a.chq_bank as "ZONE_CODE",cir_get_zone_name(a.comp_code,a.chq_bank) as "ZONE_NAME", 
            a.exec_code as "REGION_CODE",cir_get_zone_name(a.comp_code,a.exec_code) as "REGION_NAME",   
            sum(a.rec_seqno) as "BILL_COPY",to_number(a.reason) as "COMM_RATE",a.doctype as "COMM_TYPE",a.opbal_sec as "COPY_RATE",
            case when a.doctype='P' then round(to_number(a.reason)/100,2) else to_number(a.reason) end as "NET_RATE",
            nvl(sum(a.amount),0)-nvl(sum(a.adjamt),0) as "TOTAL",
            sum(a.amount) as "GROSS_AMT", sum(a.adjamt) as "COMM_AMT", sum(a.leftamt) as "SUR_AMT", sum(a.billamt) as "BILL_AMT" 
            from cir_ledger_report a 
            where sess_id=userenv('sessionid') 
            group by a.comp_code ,a.unit_code , a.branch_code , a.agcd , 
            a.dpcd , a.billno ,a.recptno , a.debit_head ,a.city_code, a.remarks ,a.chqno , a.chq_bank  ,a.exec_code 
            order by comp_name,unit_name,zone_name,region_name,publ_name,medtn_name,edtn_name;
            
            open p_accounts1 for 
            select a.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code) as "COMP_NAME",
            a.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=a.unit_code) as "UNIT_NAME", 
            a.chq_bank as "ZONE_CODE",cir_get_zone_name(a.comp_code,a.chq_bank) as "ZONE_NAME",
            a.exec_code as "REGION_CODE",cir_get_zone_name(a.comp_code,a.exec_code) as "REGION_NAME",
            sum(a.rec_seqno) as "BILL_COPY",nvl(sum(a.amount),0)-nvl(sum(a.adjamt),0) as "TOTAL",
            sum(a.amount) as "GROSS_AMT", sum(a.adjamt) as "COMM_AMT", sum(a.leftamt) as "SUR_AMT", sum(a.billamt) as "BILL_AMT" 
            from cir_ledger_report a 
            where sess_id=userenv('sessionid')
            group by a.comp_code ,a.unit_code , a.chq_bank,a.exec_code
            order by comp_name,unit_name,zone_name,region_name;
        End if;            
    End if;
    
    delete from cir_ledger_report where sess_id=userenv('sessionid');commit;
    
End cir_rep_abc_supply_bill_return;
/


//////////////////////////////////////////////////updated by Garima


//////////////// ISSUE 6405/// Holiday Master///ONE COLUMN ADD STATE_CODE/////



alter table cir_holiday_mast add STATE_CODE VARCHER(8)

//////////////////////////////////////////////////////////////////////
