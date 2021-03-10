------------------------------------Updated by  Nitish----------------------------------------/////////////////////////////////////////----------------------------------


ALTER TABLE PREFERRENCES ADD CIR_WIEGHT_CALC_REQ    VARCHAR2(1)



---------------------------------------=========================------------------------------------------------------------
//////////////////////start By Garima
///////////////////////////update by Garima//////////add filter for weight
ALTER TABLE PREFERRENCES ADD CIR_WIEGHT_CALC_REQ    VARCHAR2(1) DEFAULT 'N';
ALTER TABLE CIR_DBKSUP ADD PER_COPY_WEIGHT  NUMBER(15,3);
ALTER TABLE CIR_DBKSUP_DIS ADD PER_COPY_WEIGHT  NUMBER(15,3);
ALTER TABLE CIR_LBLMAST ADD PER_COPY_WEIGHT  NUMBER(15,3),PKT_WEIGHT  NUMBER(15,3);
ALTER TABLE CIR_UNSOLD_DTL ADD PER_COPY_WT  NUMBER(15,3),UNSOLD_WT  NUMBER(15,3);

----------------------for Waste wise Category
CREATE TABLE CIR_WASTE_CATG_MAST
(COMP_CODE      VARCHAR2(8) ,
 CATG_CODE      NUMBER(5),
 CATEG_DESC     VARCHAR2(20),
 CREATED_BY     VARCHAR2(20),
 CREATED_DT     DATE    DEFAULT SYSDATE,
 UPDATED_BY     VARCHAR2(20),
 UPDATED_DT     DATE,
 CONSTRAINT CIR_WASTE_CATG_PK
 PRIMARY KEY (COMP_CODE, CATG_CODE));
 
ALTER TABLE    CIR_SUPPLY  ADD WASTE_CATG_CODE NUMBER(5);
ALTER TABLE    CIR_SUPPLY_dis  ADD WASTE_CATG_CODE NUMBER(5);
ALTER TABLE    CIR_WASTE_RATE_MAST  ADD WASTE_CATG_CODE NUMBER(5);
///////////////////////////////////////////////////////////End By Garima


//----------------------------------start 10/04/2012-----------------------//

create table auto_process_log
(
process_name varchar2(500),
frequency varchar2(1),
process_dt date,
tasq_time varchar2(20)
)
--select * from auto_process_parameters
create table auto_process_parameters
(
process_name varchar2(500),
comp_code varchar2(8),
unit_code varchar2(20),
pub_code varchar2(20),
edtn_code varchar2(20),
pdateformat varchar2(10),
creation_dt date default sysdate
)

alter table auto_process_parameters add pub_type varchar2(20)

//----------------------------------end---------------------------------//

///////////////////////issue number   7180 & 7178 update by Garima


                           alter table  retainermaster add ( cdp varchar2(8),cds varchar2(8))
                           alter table cir_edtn_mast add(seg_code  varchar2(10 ))
/////////////////////////////////////////


//////////////////NEHA 17-04-2012//////////////////////////////

alter table cir_reason_mst add (DR_CDP VARCHAR2(20),CR_CDP VARCHAR2(20))

ALTER TABLE cir_expenses_type_mast ADD CR_CDP VARCHAR2(20) 
alter table cir_expenses_type_mast rename column EXP_ACC_CDP to DR_CDP;
alter table cir_expenses_type_mast drop column exp_acc_cds


 ////////////////////////////////////Deepika 18/04/2012 sent by Laxman Sir/////////////////////////////////////

ALTER TABLE CIR_DBKSUP ADD WASTE_CATG_CODE NUMBER(5)
ALTER TABLE CIR_DBKSUP_DIS ADD WASTE_CATG_CODE NUMBER(5)
ALTER TABLE CIR_DBKSUP_RESALE ADD WASTE_CATG_CODE NUMBER(5)

ALTER TABLE    CIR_SUPPLY  ADD WASTE_CATG_CODE NUMBER(5);
ALTER TABLE    CIR_SUPPLY_dis  ADD WASTE_CATG_CODE NUMBER(5);
ALTER TABLE    CIR_WASTE_RATE_MAST  ADD WASTE_CATG_CODE NUMBER(5);



ALTER TABLE PREFERRENCES ADD CIR_WIEGHT_CALC_REQ    VARCHAR2(1) DEFAULT 'N';
ALTER TABLE CIR_DBKSUP ADD PER_COPY_WEIGHT  NUMBER(15,3);
ALTER TABLE CIR_DBKSUP_DIS ADD PER_COPY_WEIGHT  NUMBER(15,3);
ALTER TABLE CIR_LBLMAST ADD PER_COPY_WEIGHT  NUMBER(15,3),PKT_WEIGHT  NUMBER(15,3);
ALTER TABLE CIR_UNSOLD_DTL ADD PER_COPY_WT  NUMBER(15,3),UNSOLD_WT  NUMBER(15,3);


alter table CIR_WASTE_CATG_MAST add STATUS varchar(1)



ALTER TABLE CIR_WASTE_RATE_MAST drop CONSTRAINT CIR_WASTE_RATE_PK
ALTER TABLE CIR_WASTE_RATE_MAST ADD CONSTRAINT CIR_WASTE_RATE_PK PRIMARY KEY (COMP_CODE, UNIT_CODE, PUBL, EDTN,,WASTE_CATG_CODE)

/////////////////////////////////////


CREATE TABLE CIR_WASTE_CATG_MAST
(COMP_CODE      VARCHAR2(8) ,
 CATG_CODE      NUMBER(5),
 CATEG_DESC     VARCHAR2(20),
 CREATED_BY     VARCHAR2(20),
 CREATED_DT     DATE    DEFAULT SYSDATE,
 UPDATED_BY     VARCHAR2(20),
 UPDATED_DT     DATE,
 CONSTRAINT CIR_WASTE_CATG_PK
 PRIMARY KEY (COMP_CODE, CATG_CODE));

/////////////////////////////////////////////////end/////////////////////////////////////////////////////

/********************Neha**18-04-20112*******************************************************/

ALTER TABLE CIR_BANK_GUARANTEE
drop CONSTRAINT SYS_C00246775


ALTER TABLE CIR_BANK_GUARANTEE_dis
drop CONSTRAINT SYS_C00246785

////////////////////garima 7332
alter table cir_supply modify WASTE_CATG_CODE varchar2(10)
///////////////////////


////////////////////////////////////////////add by deepika 04/05/2012 sent by Laxman sir////////////////////////

ALTER TABLE CIR_DBKSUP  modify FINAL_SUPPLY_FLAG DEFAULT 'N'


////////////////////////////////////////end/////////////////////////////////////////////////




/*****prachi 6591    7-may-2012************************/
CREATE OR REPLACE PACKAGE cir_branch_received is
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
CREATE OR REPLACE PACKAGE BODY cir_branch_received is
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



/*****prachi 6591    7-may-2012************************/





***********************naman**************************************************
alter table cir_rate_mast add CURR_CODE VARCHAR(20)
********************NAMAN*******************************************************



alter PROCEDURE [dbo].[CIR_REP_SUPPLY_cir_rep_daybook]      
 @pcomp_code      varchar(20),      
 @punit_code      varchar(20),      
 @ppubl           varchar(20),      
 @pedtn           varchar(20),      
 @pcitycd         varchar(20),      
 @pstatecd        varchar(20),      
 @pmonth          varchar(20),      
 @pyear           varchar(20),      
 @pdateformat     varchar(20),      
 @pbranch         varchar(20),      
 @pdistcode       varchar(20),      
 @ptaluka         varchar(20),      
 @pagtype         varchar(20),      
 @pagclass        varchar(20),      
 @pagcode         varchar(20),      
 @pdpcode         varchar(20),      
 @pextra1         varchar(200),--it is used for supply type      
 @pextra2         varchar(200), -- it is used for Report type Agency(A)/Publication(P)/Center(C)/Branch(B)/Zone(Z)/State(S)/District(D)/Route(R)      
 @pextra3         varchar(200),      
 @pextra4         varchar(200),      
 @pextra5         varchar(200)      
AS      
BEGIN      
 DECLARE @vfrdt         VARCHAR(20)      
 DECLARE @vtodt         VARCHAR(20)      
 DECLARE @vtodt1         VARCHAR(20)      
 DECLAre @pquery         varchar(8000)      
 DECLAre @pquery1         varchar(8000)      
 DECLAre @pquery2         varchar(8000)      
 declare @v_SUN_COPY_TOT  numeric(20)      
 declare @v_WEEK_COPY_TOT numeric(20)      
 set @v_SUN_COPY_TOT=0      
 set @v_WEEK_COPY_TOT=0      
      
PRINT('2')      
      
if(@pmonth = 'jan')      
begin      
   set  @pmonth = '01'      
end        
else if(@pmonth = 'feb')      
begin      
   set  @pmonth = '02'      
end        
else if(@pmonth = 'mar')      
begin      
   set  @pmonth = '03'      
end        
else if(@pmonth = 'apr')      
begin      
   set  @pmonth = '04'      
end        
else if(@pmonth = 'may')      
begin      
   set  @pmonth = '05'      
end        
else if(@pmonth = 'jun')      
begin      
   set  @pmonth = '06'      
end        
else if(@pmonth = 'jul')      
begin      
   set  @pmonth = '07'      
end        
else if(@pmonth = 'aug')      
begin      
   set  @pmonth = '08'      
end        
else if(@pmonth = 'sep')      
begin      
   set  @pmonth = '09'      
end        
else if(@pmonth = 'oct')      
begin      
   set  @pmonth = '10'      
end       
else if(@pmonth = 'nov')      
begin      
   set  @pmonth = '11'      
end       
else if(@pmonth = 'dec')      
begin      
   set  @pmonth = '12'      
end        
else       
begin      
   set  @pmonth = '00'      
end         
      
SET @vfrdt=(@pmonth+'/'+'01/'+@pyear)       
PRINT( @vfrdt)       
SET @vtodt1=([dbo].[GetLastDayOfMonth](@vfrdt))      
PRINT('2')       
set @vtodt=SUBSTRING(@vtodt1,5,2)      
print @vtodt1      
SET @vtodt=(@pmonth+'/'+@vtodt+'/'+@pyear)       
PRINT @vtodt      
      
if @pextra2='R'        
begin      
 set @pquery='SELECT COMP_CODE,UNIT_CODE,dbo.cir_get_unit_name(COMP_CODE,UNIT_CODE) UNIT_NAME,      
  ISNULL(ROUTE_CODE ,''NA'') "ROUTE CODE",'''' as "EXTRA"      
  ,substrING(isnull(dbo.cir_get_route_name(d.COMP_CODE,d.UNIT_CODE, d.ROUTE_CODE),''NA''),1,50) "ROUTE NAME",      
       substring(isnull(dbo.cir_get_route(d.COMP_CODE,d.UNIT_CODE, d.ROUTE_CODE) ,''NA''),1,50) "ROUTE ONAME",      
       d.EDTN,dbo.cir_get_edtn_name(COMP_CODE,d.EDTN) "EDITION NAME",dbo.cir_get_edtn_name(COMP_CODE,d.EDTN) "EDITION ONAME",      
       --CITY_CODE "CITY CODE",dbo.cir_get_city(COMP_CODE,CITY_CODE) "CITY NAME",      
       --dbo.cir_get_name_cir_city(COMP_CODE,CITY_CODE,2,'''','''','''') "CITY ONAME",      
       isnull(STATE_CODE,''NA'') "STATE CODE",isnull(dbo.CIR_GET_STATE(COMP_CODE,COUNTRY_CODE,STATE_CODE),''NA'') "STATE NAME",COUNTRY_CODE,      
    SUM(p01) as  "01",SUM(p02) AS "02",SUM(p03) AS "03",SUM(p04) AS "04",SUM(p05) AS "05",      
       SUM(p06) AS "06",SUM(p07) AS "07",SUM(p08) AS "08",SUM(p09) AS "09",SUM(p10) AS "10",      
       SUM(p11) AS "11",SUM(p12) AS "12",SUM(p13) AS "13",SUM(p14) AS "14",SUM(p15) AS "15",      
       SUM(p16) AS "16",SUM(p17) AS "17",SUM(p18) AS "18",SUM(p19) AS "19",SUM(p20) AS "20",      
       SUM(p21) AS "21",SUM(p22) AS "22",SUM(p23) AS "23",SUM(p24) AS "24",SUM(p25) AS "25",      
       SUM(p26) AS "26",SUM(p27) AS "27",SUM(p28) AS "28",SUM(p29) AS "29",SUM(p30) AS "30",      
  SUM(p31) AS "31",      
       SUM(isnull(p01,0)+isnull(p02,0)+isnull(p03,0)+isnull(p04,0)+isnull(p05,0)+isnull(p06,0)+isnull(p07,0)+isnull(p08,0)+isnull(p09,0)+isnull(p10,0)+      
            isnull(p11,0)+isnull(p12,0)+isnull(p13,0)+isnull(p14,0)+isnull(p15,0)+isnull(p16,0)+isnull(p17,0)+isnull(p18,0)+isnull(p19,0)+isnull(p20,0)+      
            isnull(p21,0)+isnull(p22,0)+isnull(p23,0)+isnull(p24,0)+isnull(p25,0)+isnull(p26,0)+isnull(p27,0)+isnull(p28,0)+isnull(p29,0)+isnull(p30,0)+isnull(p31,0)) AS "TOTAL"      
        FROM (      
        SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.ROUTE_CODE ROUTE_CODE,null EDTN,B.CITY_CODE,B.STATE_CODE STATE_CODE,B.COUNTRY_CODE COUNTRY_CODE,      
        case (select(day(A.SUPDATE))) when  ''1'' then SUM(isnull(A.SUP_COPY,0))  else 0 end as p01,      
  case (select(day(A.SUPDATE))) when  ''02'' then SUM(isnull(A.SUP_COPY,0))else 0 end as p02,      
        case (select(day(A.SUPDATE))) when  ''03'' then SUM(isnull(A.SUP_COPY,0))  else 0 end as p03,      
  case (select(day(A.SUPDATE))) when  ''04'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p04,      
        case (select(day(A.SUPDATE))) when  ''05'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p05,      
        case (select(day(A.SUPDATE))) when  ''06'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p06,      
        case (select(day(A.SUPDATE))) when  ''07'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p07,      
        case (select(day(A.SUPDATE))) when  ''08'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p08,      
        case (select(day(A.SUPDATE))) when  ''09'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p09,      
        case (select(day(A.SUPDATE))) when  ''10'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p10,      
        case (select(day(A.SUPDATE))) when  ''11'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p11,      
        case (select(day(A.SUPDATE))) when  ''12'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p12,      
        case (select(day(A.SUPDATE))) when  ''13'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p13,      
        case (select(day(A.SUPDATE))) when  ''14'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p14,      
        case (select(day(A.SUPDATE))) when  ''15'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p15,      
        case (select(day(A.SUPDATE))) when  ''16'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p16,      
        case (select(day(A.SUPDATE))) when  ''17'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p17,      
        case (select(day(A.SUPDATE))) when  ''18'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p18,      
  case (select(day(A.SUPDATE))) when  ''19'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p19,      
  case (select(day(A.SUPDATE))) when  ''20'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p20,      
  case (select(day(A.SUPDATE))) when  ''21'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p21,      
  case (select(day(A.SUPDATE))) when  ''22'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p22,      
  case (select(day(A.SUPDATE))) when  ''23'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p23,      
  case (select(day(A.SUPDATE))) when  ''24'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p24,      
  case (select(day(A.SUPDATE))) when  ''25'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p25,      
  case (select(day(A.SUPDATE))) when  ''26'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p26,      
  case (select(day(A.SUPDATE))) when  ''27'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p27,      
  case (select(day(A.SUPDATE))) when  ''28'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p28,      
  case (select(day(A.SUPDATE))) when  ''29'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p29,      
  case (select(day(A.SUPDATE))) when  ''30'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p30,      
  case (select(day(A.SUPDATE))) when  ''31'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p31      
        FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C      
        WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE='''+@PCOMP_CODE+''' AND A.UNIT_CODE=B.UNIT AND (A.UNIT_CODE='''+@PUNIT_CODE+''' or '''+@PUNIT_CODE+''' is null or '''+@PUNIT_CODE+'''='''') AND      
        A.AGCD  = B.AGCD AND (A.AGCD='+''''+@PAGCODE+''''+' OR '+''''+@PAGCODE+'''='''') AND       
  A.DPCD  = B.DPCD AND (A.DPCD='+''''+@PDPCODE+''''+' OR '+''''+@PDPCODE+'''='''') AND (A.PUBL='''+@PPUBL+''' or '''+@PPUBL+''' is null or '''+@PPUBL+'''='''') AND (A.EDTN='''+@PEDTN+''' or '''+@PEDTN+''' IS NULL OR '''+@PEDTN+''' ='''') AND (B.CITY_CODE=
  
    
'''+@PCITYCD+''' OR '''+@PCITYCD+''' IS NULL or '''+@PCITYCD+''' ='''') AND      
        (B.STATE_CODE='''+@PSTATECD+''' OR '''+@PSTATECD+''' IS NULL or '''+@PSTATECD+''' ='''') AND       
        (B.DIST_CODE='''+@PDISTCODE+''' OR '''+@PDISTCODE+''' IS NULL or '''+@PDISTCODE+''' ='''') AND (B.TEHSIL_TALUKA='''+@PTALUKA+''' OR '''+@PTALUKA+''' IS NULL or '''+@PTALUKA+''' ='''') AND       
        (B.BRANCH_CODE='''+@PBRANCH+''' OR '''+@PBRANCH+''' IS NULL or '''+@PBRANCH+''' ='''') AND (B.AG_TYPE='''+@PAGTYPE+''' OR '''+@PAGTYPE+''' IS NULL or '''+@PAGTYPE+''' ='''') AND (B.AG_CLASS='''+@PAGCLASS+''' OR '''+@PAGCLASS+''' IS NULL or '''+@PAGCLASS+''' ='''') AND      
        A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE='''+@PEXTRA1+''' OR '''+@PEXTRA1+''' IS NULL or '''+@PEXTRA1+''' ='''') AND       
        A.SUPDATE BETWEEN '''+@VFRDT+''' AND '''+@VTODT+'''    AND A.SUP_COPY>0      
        GROUP BY A.COMP_CODE,A.UNIT_CODE,A.ROUTE_CODE,A.SUPDATE,B.CITY_CODE,B.STATE_CODE,B.COUNTRY_CODE) d      
        GROUP BY d.COMP_CODE,d.UNIT_CODE,d.ROUTE_CODE,d.EDTN,d.STATE_CODE,d.COUNTRY_CODE      
        ORDER BY d.COMP_CODE,d.UNIT_CODE,d.STATE_CODE,d.ROUTE_CODE,d.EDTN'      
              
--print @pquery       
end      
else if @pextra2='P'      
begin      
 set @pquery='SELECT COMP_CODE,UNIT_CODE,dbo.cir_get_unit_name(COMP_CODE,UNIT_CODE) UNIT_NAME,      
  '''' as "EXTRA",PUBL "PUBL CODE"      
 ,substrING(dbo.cir_get_publ_name(d.comp_code,d.PUBL),1,50) "PUBL NAME",      
       substring(dbo.cir_get_publ_name_other(d.comp_code,d.PUBL,2,''dd/mm/yyyy'','''',''''),1,50) "PUBL ONAME",      
       d.EDTN,dbo.cir_get_edtn_name(COMP_CODE,d.EDTN) "EDITION NAME",dbo.cir_get_edtn_name(COMP_CODE,d.EDTN) "EDITION ONAME",      
       --CITY_CODE "CITY CODE",dbo.cir_get_city(COMP_CODE,CITY_CODE) "CITY NAME",      
       --dbo.cir_get_name_cir_city(COMP_CODE,CITY_CODE,2,'''','''','''') "CITY ONAME",      
       isnull(STATE_CODE,''NA'') "STATE CODE",isnull(dbo.CIR_GET_STATE(COMP_CODE,COUNTRY_CODE,STATE_CODE),''NA'') "STATE NAME",COUNTRY_CODE,      
    dbo.fn_FormatWithCommas(SUM(p01)) as "01",dbo.fn_FormatWithCommas(SUM(p02)) AS "02",      
    dbo.fn_FormatWithCommas(SUM(p03)) AS "03",dbo.fn_FormatWithCommas(SUM(p04)) AS "04",      
    dbo.fn_FormatWithCommas(SUM(p05)) AS "05",dbo.fn_FormatWithCommas(SUM(p06)) AS "06",      
    dbo.fn_FormatWithCommas(SUM(p07)) AS "07",dbo.fn_FormatWithCommas(SUM(p08)) AS "08",      
    dbo.fn_FormatWithCommas(SUM(p09)) AS "09",dbo.fn_FormatWithCommas(SUM(p10)) AS "10",      
       dbo.fn_FormatWithCommas(SUM(p11)) AS "11",dbo.fn_FormatWithCommas(SUM(p12)) AS "12",SUM(p13) AS "13",      
       dbo.fn_FormatWithCommas(SUM(p14)) AS "14",dbo.fn_FormatWithCommas(SUM(p15)) AS "15",      
       dbo.fn_FormatWithCommas(SUM(p16)) AS "16",dbo.fn_FormatWithCommas(SUM(p17)) AS "17",      
       dbo.fn_FormatWithCommas(SUM(p18)) AS "18",dbo.fn_FormatWithCommas(SUM(p19)) AS "19",      
       dbo.fn_FormatWithCommas(SUM(p20)) AS "20",dbo.fn_FormatWithCommas(SUM(p21)) AS "21",      
       dbo.fn_FormatWithCommas(SUM(p22)) AS "22",dbo.fn_FormatWithCommas(SUM(p23)) AS "23",      
       dbo.fn_FormatWithCommas(SUM(p24)) AS "24",dbo.fn_FormatWithCommas(SUM(p25)) AS "25",      
       dbo.fn_FormatWithCommas(SUM(p26)) AS "26",dbo.fn_FormatWithCommas(SUM(p27)) AS "27",      
       dbo.fn_FormatWithCommas(SUM(p28)) AS "28",dbo.fn_FormatWithCommas(SUM(p29)) AS "29",      
       dbo.fn_FormatWithCommas(SUM(p30)) AS "30",dbo.fn_FormatWithCommas(SUM(p31)) AS "31",      
       dbo.fn_FormatWithCommas(SUM(isnull(p01,0)+isnull(p02,0)+isnull(p03,0)+isnull(p04,0)+isnull(p05,0)+isnull(p06,0)+isnull(p07,0)+isnull(p08,0)+isnull(p09,0)+isnull(p10,0)+      
            isnull(p11,0)+isnull(p12,0)+isnull(p13,0)+isnull(p14,0)+isnull(p15,0)+isnull(p16,0)+isnull(p17,0)+isnull(p18,0)+isnull(p19,0)+isnull(p20,0)+      
            isnull(p21,0)+isnull(p22,0)+isnull(p23,0)+isnull(p24,0)+isnull(p25,0)+isnull(p26,0)+isnull(p27,0)+isnull(p28,0)+isnull(p29,0)+isnull(p30,0)+isnull(p31,0))) AS "TOTAL"      
                  
        FROM (      
        SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.PUBL PUBL,null EDTN      
        ,B.CITY_CODE,B.STATE_CODE STATE_CODE,B.COUNTRY_CODE COUNTRY_CODE,      
        case (select(day(A.SUPDATE))) when  ''1'' then SUM(isnull(A.SUP_COPY,0))  else 0 end as p01,      
  case (select(day(A.SUPDATE))) when  ''02'' then SUM(isnull(A.SUP_COPY,0))else 0 end as p02,      
        case (select(day(A.SUPDATE))) when  ''03'' then SUM(isnull(A.SUP_COPY,0))  else 0 end as p03,      
  case (select(day(A.SUPDATE))) when  ''04'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p04,      
        case (select(day(A.SUPDATE))) when  ''05'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p05,      
        case (select(day(A.SUPDATE))) when  ''06'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p06,      
        case (select(day(A.SUPDATE))) when  ''07'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p07,      
        case (select(day(A.SUPDATE))) when  ''08'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p08,      
        case (select(day(A.SUPDATE))) when  ''09'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p09,      
        case (select(day(A.SUPDATE))) when  ''10'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p10,      
        case (select(day(A.SUPDATE))) when  ''11'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p11,      
        case (select(day(A.SUPDATE))) when  ''12'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p12,      
        case (select(day(A.SUPDATE))) when  ''13'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p13,      
        case (select(day(A.SUPDATE))) when  ''14'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p14,      
        case (select(day(A.SUPDATE))) when  ''15'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p15,      
        case (select(day(A.SUPDATE))) when  ''16'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p16,      
        case (select(day(A.SUPDATE))) when  ''17'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p17,      
        case (select(day(A.SUPDATE))) when  ''18'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p18,      
  case (select(day(A.SUPDATE))) when  ''19'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p19,      
  case (select(day(A.SUPDATE))) when  ''20'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p20,      
  case (select(day(A.SUPDATE))) when  ''21'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p21,      
  case (select(day(A.SUPDATE))) when  ''22'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p22,      
  case (select(day(A.SUPDATE))) when  ''23'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p23,      
  case (select(day(A.SUPDATE))) when  ''24'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p24,      
  case (select(day(A.SUPDATE))) when  ''25'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p25,      
  case (select(day(A.SUPDATE))) when  ''26'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p26,      
  case (select(day(A.SUPDATE))) when  ''27'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p27,      
  case (select(day(A.SUPDATE))) when  ''28'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p28,      
  case (select(day(A.SUPDATE))) when  ''29'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p29,      
  case (select(day(A.SUPDATE))) when ''30'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p30,      
  case (select(day(A.SUPDATE))) when  ''31'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p31      
        FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C      
        WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE='''+@PCOMP_CODE+''' AND A.UNIT_CODE=B.UNIT AND (A.UNIT_CODE='''+@PUNIT_CODE+''' or '''+@PUNIT_CODE+''' is null or '''+@PUNIT_CODE+'''='''') AND      
        A.AGCD  = B.AGCD AND (A.AGCD='+''''+@PAGCODE+''''+' OR '+''''+@PAGCODE+'''='''') AND       
  A.DPCD  = B.DPCD AND (A.DPCD='+''''+@PDPCODE+''''+' OR '+''''+@PDPCODE+'''='''') AND (A.PUBL='''+@PPUBL+''' or '''+@PPUBL+''' is null or '''+@PPUBL+'''='''') AND (A.EDTN='''+@PEDTN+''' or '''+@PEDTN+''' IS NULL OR '''+@PEDTN+''' ='''') AND (B.CITY_CODE
=  
    
'''+@PCITYCD+''' OR '''+@PCITYCD+''' IS NULL or '''+@PCITYCD+''' ='''') AND      
        (B.STATE_CODE='''+@PSTATECD+''' OR '''+@PSTATECD+''' IS NULL or '''+@PSTATECD+''' ='''') AND       
        (B.DIST_CODE='''+@PDISTCODE+''' OR '''+@PDISTCODE+''' IS NULL or '''+@PDISTCODE+''' ='''') AND (B.TEHSIL_TALUKA='''+@PTALUKA+''' OR '''+@PTALUKA+''' IS NULL or '''+@PTALUKA+''' ='''') AND       
        (B.BRANCH_CODE='''+@PBRANCH+''' OR '''+@PBRANCH+''' IS NULL or '''+@PBRANCH+''' ='''') AND (B.AG_TYPE='''+@PAGTYPE+''' OR '''+@PAGTYPE+''' IS NULL or '''+@PAGTYPE+''' ='''') AND (B.AG_CLASS='''+@PAGCLASS+''' OR '''+@PAGCLASS+''' IS NULL or '''+@PAGCLASS+''' ='''') AND      
        A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE='''+@PEXTRA1+''' OR '''+@PEXTRA1+''' IS NULL or '''+@PEXTRA1+''' ='''') AND       
        A.SUPDATE BETWEEN '''+@VFRDT+''' AND '''+@VTODT+'''    AND A.SUP_COPY>0      
        GROUP BY A.COMP_CODE,A.UNIT_CODE,A.PUBL,A.SUPDATE,B.CITY_CODE,B.STATE_CODE,B.COUNTRY_CODE) d      
        GROUP BY d.COMP_CODE,d.UNIT_CODE,d.PUBL,d.EDTN,d.STATE_CODE,d.COUNTRY_CODE      
        ORDER BY d.COMP_CODE,d.UNIT_CODE,d.STATE_CODE,d.PUBL,d.EDTN'       
                      
        print('ss')      
        print(@pquery)      
end      
else if @pextra2='C'      
begin      
 set @pquery='SELECT COMP_CODE,UNIT_CODE,dbo.cir_get_unit_name(COMP_CODE,UNIT_CODE) UNIT_NAME,      
  substrING(dbo.cir_get_unit_name(d.comp_code,d.UNIT_CODE),1,50) "UNIT NAME",'''' as "EXTRA",'''' as "EXTRA2",      
       ''NA'' "UNIT ONAME",      
       d.EDTN,dbo.cir_get_edtn_name(COMP_CODE,d.EDTN) "EDITION NAME",dbo.cir_get_edtn_name(COMP_CODE,d.EDTN) "EDITION ONAME",      
       --CITY_CODE "CITY CODE",dbo.cir_get_city(COMP_CODE,CITY_CODE) "CITY NAME",      
       --dbo.cir_get_name_cir_city(COMP_CODE,CITY_CODE,2,'''','''','''') "CITY ONAME",      
       isnull(STATE_CODE,''NA'') "STATE CODE",isnull(dbo.CIR_GET_STATE(COMP_CODE,COUNTRY_CODE,STATE_CODE),''NA'') "STATE NAME",COUNTRY_CODE,      
    dbo.fn_FormatWithCommas(SUM(p01)) as "01",dbo.fn_FormatWithCommas(SUM(p02)) AS "02",      
    dbo.fn_FormatWithCommas(SUM(p03)) AS "03",dbo.fn_FormatWithCommas(SUM(p04)) AS "04",      
    dbo.fn_FormatWithCommas(SUM(p05)) AS "05",dbo.fn_FormatWithCommas(SUM(p06)) AS "06",      
       dbo.fn_FormatWithCommas(SUM(p07)) AS "07",dbo.fn_FormatWithCommas(SUM(p08)) AS "08",      
       dbo.fn_FormatWithCommas(SUM(p09)) AS "09",dbo.fn_FormatWithCommas(SUM(p10)) AS "10",      
       dbo.fn_FormatWithCommas(SUM(p11)) AS "11",dbo.fn_FormatWithCommas(SUM(p12)) AS "12",      
       dbo.fn_FormatWithCommas(SUM(p13)) AS "13",dbo.fn_FormatWithCommas(SUM(p14)) AS "14",      
       dbo.fn_FormatWithCommas(SUM(p15)) AS "15",dbo.fn_FormatWithCommas(SUM(p16)) AS "16",      
       dbo.fn_FormatWithCommas(SUM(p17)) AS "17",dbo.fn_FormatWithCommas(SUM(p18)) AS "18",      
       dbo.fn_FormatWithCommas(SUM(p19)) AS "19",dbo.fn_FormatWithCommas(SUM(p20)) AS "20",      
       dbo.fn_FormatWithCommas(SUM(p21)) AS "21",dbo.fn_FormatWithCommas(SUM(p22)) AS "22",      
       dbo.fn_FormatWithCommas(SUM(p23)) AS "23",dbo.fn_FormatWithCommas(SUM(p24)) AS "24",      
       dbo.fn_FormatWithCommas(SUM(p25)) AS "25",dbo.fn_FormatWithCommas(SUM(p26)) AS "26",      
       dbo.fn_FormatWithCommas(SUM(p27)) AS "27",dbo.fn_FormatWithCommas(SUM(p28)) AS "28",      
       dbo.fn_FormatWithCommas(SUM(p29)) AS "29",dbo.fn_FormatWithCommas(SUM(p30)) AS "30",      
    dbo.fn_FormatWithCommas(SUM(p31)) AS "31",      
       dbo.fn_FormatWithCommas(SUM(isnull(p01,0)+isnull(p02,0)+isnull(p03,0)+isnull(p04,0)+isnull(p05,0)+isnull(p06,0)+isnull(p07,0)+isnull(p08,0)+isnull(p09,0)+isnull(p10,0)+      
            isnull(p11,0)+isnull(p12,0)+isnull(p13,0)+isnull(p14,0)+isnull(p15,0)+isnull(p16,0)+isnull(p17,0)+isnull(p18,0)+isnull(p19,0)+isnull(p20,0)+      
            isnull(p21,0)+isnull(p22,0)+isnull(p23,0)+isnull(p24,0)+isnull(p25,0)+isnull(p26,0)+isnull(p27,0)+isnull(p28,0)+isnull(p29,0)+isnull(p30,0)+isnull(p31,0))) AS "TOTAL"      
        FROM (      
        SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,null EDTN      
        ,B.CITY_CODE,B.STATE_CODE STATE_CODE,B.COUNTRY_CODE COUNTRY_CODE,      
        case (select(day(A.SUPDATE))) when  ''1'' then SUM(isnull(A.SUP_COPY,0))  else 0 end as p01,      
  case (select(day(A.SUPDATE))) when  ''02'' then SUM(isnull(A.SUP_COPY,0))else 0 end as p02,      
        case (select(day(A.SUPDATE))) when  ''03'' then SUM(isnull(A.SUP_COPY,0))  else 0 end as p03,      
  case (select(day(A.SUPDATE))) when  ''04'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p04,      
        case (select(day(A.SUPDATE))) when  ''05'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p05,      
        case (select(day(A.SUPDATE))) when  ''06'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p06,      
        case (select(day(A.SUPDATE))) when  ''07'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p07,      
        case (select(day(A.SUPDATE))) when  ''08'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p08,      
        case (select(day(A.SUPDATE))) when  ''09'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p09,      
        case (select(day(A.SUPDATE))) when  ''10'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p10,      
        case (select(day(A.SUPDATE))) when  ''11'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p11,      
        case (select(day(A.SUPDATE))) when  ''12'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p12,      
        case (select(day(A.SUPDATE))) when  ''13'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p13,      
        case (select(day(A.SUPDATE))) when  ''14'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p14,      
        case (select(day(A.SUPDATE))) when  ''15'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p15,      
        case (select(day(A.SUPDATE))) when  ''16'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p16,      
        case (select(day(A.SUPDATE))) when  ''17'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p17,      
        case (select(day(A.SUPDATE))) when  ''18'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p18,      
  case (select(day(A.SUPDATE))) when  ''19'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p19,      
  case (select(day(A.SUPDATE))) when  ''20'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p20,      
  case (select(day(A.SUPDATE))) when  ''21'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p21,      
  case (select(day(A.SUPDATE))) when  ''22'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p22,      
  case (select(day(A.SUPDATE))) when  ''23'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p23,      
  case (select(day(A.SUPDATE))) when  ''24'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p24,      
  case (select(day(A.SUPDATE))) when  ''25'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p25,      
  case (select(day(A.SUPDATE))) when  ''26'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p26,      
  case (select(day(A.SUPDATE))) when  ''27'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p27,      
  case (select(day(A.SUPDATE))) when  ''28'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p28,      
  case (select(day(A.SUPDATE))) when  ''29'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p29,   
  case (select(day(A.SUPDATE))) when  ''30'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p30,      
  case (select(day(A.SUPDATE))) when  ''31'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p31      
        FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C      
        WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE='''+@PCOMP_CODE+''' AND A.UNIT_CODE=B.UNIT AND (A.UNIT_CODE='''+@PUNIT_CODE+''' or '''+@PUNIT_CODE+''' is null or '''+@PUNIT_CODE+'''='''') AND      
        A.AGCD  = B.AGCD AND (A.AGCD='+''''+@PAGCODE+''''+' OR '+''''+@PAGCODE+'''='''') AND       
  A.DPCD  = B.DPCD AND (A.DPCD='+''''+@PDPCODE+''''+' OR '+''''+@PDPCODE+'''='''') AND (A.PUBL='''+@PPUBL+''' or '''+@PPUBL+''' is null or '''+@PPUBL+'''='''') AND (A.EDTN='''+@PEDTN+''' or '''+@PEDTN+''' IS NULL OR '''+@PEDTN+''' ='''') AND (B.CITY_CODE
=  
    
'''+@PCITYCD+''' OR '''+@PCITYCD+''' IS NULL or '''+@PCITYCD+''' ='''') AND      
        (B.STATE_CODE='''+@PSTATECD+''' OR '''+@PSTATECD+''' IS NULL or '''+@PSTATECD+''' ='''') AND       
        (B.DIST_CODE='''+@PDISTCODE+''' OR '''+@PDISTCODE+''' IS NULL or '''+@PDISTCODE+''' ='''') AND (B.TEHSIL_TALUKA='''+@PTALUKA+''' OR '''+@PTALUKA+''' IS NULL or '''+@PTALUKA+''' ='''') AND       
        (B.BRANCH_CODE='''+@PBRANCH+''' OR '''+@PBRANCH+''' IS NULL or '''+@PBRANCH+''' ='''') AND (B.AG_TYPE='''+@PAGTYPE+''' OR '''+@PAGTYPE+''' IS NULL or '''+@PAGTYPE+''' ='''') AND (B.AG_CLASS='''+@PAGCLASS+''' OR '''+@PAGCLASS+''' IS NULL or '''+@PAGCLASS+''' ='''') AND      
        A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE='''+@PEXTRA1+''' OR '''+@PEXTRA1+''' IS NULL or '''+@PEXTRA1+''' ='''') AND       
        A.SUPDATE BETWEEN '''+@VFRDT+''' AND '''+@VTODT+'''    AND A.SUP_COPY>0      
        GROUP BY A.COMP_CODE,A.UNIT_CODE,A.SUPDATE,B.CITY_CODE,B.STATE_CODE,B.COUNTRY_CODE) d      
        GROUP BY d.COMP_CODE,d.UNIT_CODE,d.EDTN,d.STATE_CODE,d.COUNTRY_CODE      
        ORDER BY d.COMP_CODE,d.UNIT_CODE,d.STATE_CODE,d.EDTN'      
              
end      
else if @pextra2='B'      
begin      
 set @pquery='SELECT COMP_CODE,UNIT_CODE,dbo.cir_get_unit_name(COMP_CODE,UNIT_CODE) UNIT_NAME,      
  BRANCH_CODE "BRANCH CODE",'''' as "EXTRA"      
 ,substrING(dbo.cir_get_branch(d.comp_code,d.BRANCH_CODE),1,50) "BRANCH NAME",      
       ''NA'' "BRANCH ONAME",      
       d.EDTN,dbo.cir_get_edtn_name(COMP_CODE,d.EDTN) "EDITION NAME",dbo.cir_get_edtn_name(COMP_CODE,d.EDTN) "EDITION ONAME",      
       --CITY_CODE "CITY CODE",dbo.cir_get_city(COMP_CODE,CITY_CODE) "CITY NAME",      
       --dbo.cir_get_name_cir_city(COMP_CODE,CITY_CODE,2,'''','''','''') "CITY ONAME",      
       isnull(STATE_CODE,''NA'') "STATE CODE",isnull(dbo.CIR_GET_STATE(COMP_CODE,COUNTRY_CODE,STATE_CODE),''NA'') "STATE NAME",COUNTRY_CODE,      
    dbo.fn_FormatWithCommas(SUM(p01)) as "01",dbo.fn_FormatWithCommas(SUM(p02)) AS "02",      
    dbo.fn_FormatWithCommas(SUM(p03)) AS "03",dbo.fn_FormatWithCommas(SUM(p04)) AS "04",      
    dbo.fn_FormatWithCommas(SUM(p05)) AS "05",dbo.fn_FormatWithCommas(SUM(p06)) AS "06",      
       dbo.fn_FormatWithCommas(SUM(p07)) AS "07",dbo.fn_FormatWithCommas(SUM(p08)) AS "08",      
       dbo.fn_FormatWithCommas(SUM(p09)) AS "09",dbo.fn_FormatWithCommas(SUM(p10)) AS "10",      
       dbo.fn_FormatWithCommas(SUM(p11)) AS "11",dbo.fn_FormatWithCommas(SUM(p12)) AS "12",      
       dbo.fn_FormatWithCommas(SUM(p13)) AS "13",dbo.fn_FormatWithCommas(SUM(p14)) AS "14",      
       dbo.fn_FormatWithCommas(SUM(p15)) AS "15",dbo.fn_FormatWithCommas(SUM(p16)) AS "16",      
       dbo.fn_FormatWithCommas(SUM(p17)) AS "17",dbo.fn_FormatWithCommas(SUM(p18)) AS "18",      
       dbo.fn_FormatWithCommas(SUM(p19)) AS "19",dbo.fn_FormatWithCommas(SUM(p20)) AS "20",      
       dbo.fn_FormatWithCommas(SUM(p21)) AS "21",dbo.fn_FormatWithCommas(SUM(p22)) AS "22",      
       dbo.fn_FormatWithCommas(SUM(p23)) AS "23",dbo.fn_FormatWithCommas(SUM(p24)) AS "24",      
       dbo.fn_FormatWithCommas(SUM(p25)) AS "25",dbo.fn_FormatWithCommas(SUM(p26)) AS "26",      
       dbo.fn_FormatWithCommas(SUM(p27)) AS "27",dbo.fn_FormatWithCommas(SUM(p28)) AS "28",      
       dbo.fn_FormatWithCommas(SUM(p29)) AS "29",dbo.fn_FormatWithCommas(SUM(p30)) AS "30",      
    dbo.fn_FormatWithCommas(SUM(p31)) AS "31",      
       dbo.fn_FormatWithCommas(SUM(isnull(p01,0)+isnull(p02,0)+isnull(p03,0)+isnull(p04,0)+isnull(p05,0)+isnull(p06,0)+isnull(p07,0)+isnull(p08,0)+isnull(p09,0)+isnull(p10,0)+      
            isnull(p11,0)+isnull(p12,0)+isnull(p13,0)+isnull(p14,0)+isnull(p15,0)+isnull(p16,0)+isnull(p17,0)+isnull(p18,0)+isnull(p19,0)+isnull(p20,0)+      
            isnull(p21,0)+isnull(p22,0)+isnull(p23,0)+isnull(p24,0)+isnull(p25,0)+isnull(p26,0)+isnull(p27,0)+isnull(p28,0)+isnull(p29,0)+isnull(p30,0)+isnull(p31,0))) AS "TOTAL"      
        FROM (      
        SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,B.BRANCH_CODE BRANCH_CODE,null EDTN      
        ,B.CITY_CODE,B.STATE_CODE STATE_CODE,B.COUNTRY_CODE COUNTRY_CODE,      
        case (select(day(A.SUPDATE))) when  ''1'' then SUM(isnull(A.SUP_COPY,0))  else 0 end as p01,      
  case (select(day(A.SUPDATE))) when  ''02'' then SUM(isnull(A.SUP_COPY,0))else 0 end as p02,      
        case (select(day(A.SUPDATE))) when  ''03'' then SUM(isnull(A.SUP_COPY,0))  else 0 end as p03,      
  case (select(day(A.SUPDATE))) when  ''04'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p04,      
        case (select(day(A.SUPDATE))) when  ''05'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p05,      
        case (select(day(A.SUPDATE))) when  ''06'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p06,      
        case (select(day(A.SUPDATE))) when  ''07'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p07,      
        case (select(day(A.SUPDATE))) when  ''08'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p08,      
        case (select(day(A.SUPDATE))) when  ''09'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p09,      
        case (select(day(A.SUPDATE))) when  ''10'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p10,      
        case (select(day(A.SUPDATE))) when  ''11'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p11,      
        case (select(day(A.SUPDATE))) when  ''12'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p12,      
        case (select(day(A.SUPDATE))) when  ''13'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p13,      
        case (select(day(A.SUPDATE))) when  ''14'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p14,      
        case (select(day(A.SUPDATE))) when  ''15'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p15,      
        case (select(day(A.SUPDATE))) when  ''16'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p16,      
        case (select(day(A.SUPDATE))) when  ''17'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p17,      
        case (select(day(A.SUPDATE))) when  ''18'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p18,      
  case (select(day(A.SUPDATE))) when  ''19'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p19,      
  case (select(day(A.SUPDATE))) when  ''20'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p20,      
  case (select(day(A.SUPDATE))) when  ''21'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p21,      
  case (select(day(A.SUPDATE))) when  ''22'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p22,      
  case (select(day(A.SUPDATE))) when  ''23'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p23,      
  case (select(day(A.SUPDATE))) when  ''24'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p24,      
  case (select(day(A.SUPDATE))) when  ''25'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p25,      
  case (select(day(A.SUPDATE))) when  ''26'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p26,      
  case (select(day(A.SUPDATE))) when  ''27'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p27,      
  case (select(day(A.SUPDATE))) when  ''28'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p28,      
  case (select(day(A.SUPDATE))) when  ''29'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p29,     
  case (select(day(A.SUPDATE))) when  ''30'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p30,      
  case (select(day(A.SUPDATE))) when  ''31'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p31      
        FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C      
        WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE='''+@PCOMP_CODE+''' AND A.UNIT_CODE=B.UNIT AND (A.UNIT_CODE='''+@PUNIT_CODE+''' or '''+@PUNIT_CODE+''' is null or '''+@PUNIT_CODE+'''='''') AND      
        A.AGCD  = B.AGCD AND (A.AGCD='+''''+@PAGCODE+''''+' OR '+''''+@PAGCODE+'''='''') AND       
  A.DPCD  = B.DPCD AND (A.DPCD='+''''+@PDPCODE+''''+' OR '+''''+@PDPCODE+'''='''') AND (A.PUBL='''+@PPUBL+''' or '''+@PPUBL+''' is null or '''+@PPUBL+'''='''') AND (A.EDTN='''+@PEDTN+''' or '''+@PEDTN+''' IS NULL OR '''+@PEDTN+''' ='''') AND (B.CITY_CODE
=  
    
'''+@PCITYCD+''' OR '''+@PCITYCD+''' IS NULL or '''+@PCITYCD+''' ='''') AND      
        (B.STATE_CODE='''+@PSTATECD+''' OR '''+@PSTATECD+''' IS NULL or '''+@PSTATECD+''' ='''') AND       
        (B.DIST_CODE='''+@PDISTCODE+''' OR '''+@PDISTCODE+''' IS NULL or '''+@PDISTCODE+''' ='''') AND (B.TEHSIL_TALUKA='''+@PTALUKA+''' OR '''+@PTALUKA+''' IS NULL or '''+@PTALUKA+''' ='''') AND       
        (B.BRANCH_CODE='''+@PBRANCH+''' OR '''+@PBRANCH+''' IS NULL or '''+@PBRANCH+''' ='''') AND (B.AG_TYPE='''+@PAGTYPE+''' OR '''+@PAGTYPE+''' IS NULL or '''+@PAGTYPE+''' ='''') AND (B.AG_CLASS='''+@PAGCLASS+''' OR '''+@PAGCLASS+''' IS NULL or '''+@PAGCLASS+''' ='''') AND      
        A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE='''+@PEXTRA1+''' OR '''+@PEXTRA1+''' IS NULL or '''+@PEXTRA1+''' ='''') AND       
        A.SUPDATE BETWEEN '''+@VFRDT+''' AND '''+@VTODT+'''    AND A.SUP_COPY>0      
        GROUP BY A.COMP_CODE,A.UNIT_CODE,B.BRANCH_CODE,A.SUPDATE,B.CITY_CODE,B.STATE_CODE,B.COUNTRY_CODE) d      
        GROUP BY d.COMP_CODE,d.UNIT_CODE,d.BRANCH_CODE,d.EDTN,d.STATE_CODE,d.COUNTRY_CODE      
        ORDER BY d.COMP_CODE,d.UNIT_CODE,d.STATE_CODE,d.BRANCH_CODE,d.EDTN'      
              
end      
else if @pextra2='Z'      
begin      
 set @pquery='SELECT COMP_CODE,UNIT_CODE,dbo.cir_get_unit_name(COMP_CODE,UNIT_CODE) UNIT_NAME,      
  ISNULL(d.ZONE_CODE, ''NA'') "ZONE CODE",'''' as "EXTRA"      
  ,substrING(isnull(dbo.cir_get_zone_name(COMP_CODE, ZONE_CODE),''NA''),1,50) "ZONE NAME",      
       ''NA'' "ZONE ONAME",      
       d.EDTN,dbo.cir_get_edtn_name(COMP_CODE,d.EDTN) "EDITION NAME",dbo.cir_get_edtn_name(COMP_CODE,d.EDTN) "EDITION ONAME",      
       --CITY_CODE "CITY CODE",dbo.cir_get_city(COMP_CODE,CITY_CODE) "CITY NAME",      
       --dbo.cir_get_name_cir_city(COMP_CODE,CITY_CODE,2,'''','''','''') "CITY ONAME",      
       isnull(STATE_CODE,''NA'') "STATE CODE",isnull(dbo.CIR_GET_STATE(COMP_CODE,COUNTRY_CODE,STATE_CODE),''NA'') "STATE NAME",COUNTRY_CODE,      
    dbo.fn_FormatWithCommas(SUM(p01)) as "01",dbo.fn_FormatWithCommas(SUM(p02)) AS "02",      
    dbo.fn_FormatWithCommas(SUM(p03)) AS "03",dbo.fn_FormatWithCommas(SUM(p04)) AS "04",      
    dbo.fn_FormatWithCommas(SUM(p05)) AS "05",dbo.fn_FormatWithCommas(SUM(p06)) AS "06",      
       dbo.fn_FormatWithCommas(SUM(p07)) AS "07",dbo.fn_FormatWithCommas(SUM(p08)) AS "08",      
       dbo.fn_FormatWithCommas(SUM(p09)) AS "09",dbo.fn_FormatWithCommas(SUM(p10)) AS "10",      
       dbo.fn_FormatWithCommas(SUM(p11)) AS "11",dbo.fn_FormatWithCommas(SUM(p12)) AS "12",      
       dbo.fn_FormatWithCommas(SUM(p13)) AS "13",dbo.fn_FormatWithCommas(SUM(p14)) AS "14",      
       dbo.fn_FormatWithCommas(SUM(p15)) AS "15",dbo.fn_FormatWithCommas(SUM(p16)) AS "16",      
       dbo.fn_FormatWithCommas(SUM(p17)) AS "17",dbo.fn_FormatWithCommas(SUM(p18)) AS "18",      
       dbo.fn_FormatWithCommas(SUM(p19)) AS "19",dbo.fn_FormatWithCommas(SUM(p20)) AS "20",      
       dbo.fn_FormatWithCommas(SUM(p21)) AS "21",dbo.fn_FormatWithCommas(SUM(p22)) AS "22",      
       dbo.fn_FormatWithCommas(SUM(p23)) AS "23",dbo.fn_FormatWithCommas(SUM(p24)) AS "24",      
       dbo.fn_FormatWithCommas(SUM(p25)) AS "25",dbo.fn_FormatWithCommas(SUM(p26)) AS "26",      
       dbo.fn_FormatWithCommas(SUM(p27)) AS "27",dbo.fn_FormatWithCommas(SUM(p28)) AS "28",      
       dbo.fn_FormatWithCommas(SUM(p29)) AS "29",dbo.fn_FormatWithCommas(SUM(p30)) AS "30",      
    dbo.fn_FormatWithCommas(SUM(p31)) AS "31",      
       dbo.fn_FormatWithCommas(SUM(isnull(p01,0)+isnull(p02,0)+isnull(p03,0)+isnull(p04,0)+isnull(p05,0)+isnull(p06,0)+isnull(p07,0)+isnull(p08,0)+isnull(p09,0)+isnull(p10,0)+      
            isnull(p11,0)+isnull(p12,0)+isnull(p13,0)+isnull(p14,0)+isnull(p15,0)+isnull(p16,0)+isnull(p17,0)+isnull(p18,0)+isnull(p19,0)+isnull(p20,0)+      
            isnull(p21,0)+isnull(p22,0)+isnull(p23,0)+isnull(p24,0)+isnull(p25,0)+isnull(p26,0)+isnull(p27,0)+isnull(p28,0)+isnull(p29,0)+isnull(p30,0)+isnull(p31,0))) AS "TOTAL"      
        FROM (      
        SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE      
        , DBO.cir_get_zone_by_city(B.COMP_CODE,B.city_code,''C'') ZONE_CODE      
        ,null EDTN,B.CITY_CODE,B.STATE_CODE STATE_CODE,B.COUNTRY_CODE COUNTRY_CODE,      
        case (select(day(A.SUPDATE))) when  ''1'' then SUM(isnull(A.SUP_COPY,0))  else 0 end as p01,      
  case (select(day(A.SUPDATE))) when  ''02'' then SUM(isnull(A.SUP_COPY,0))else 0 end as p02,      
        case (select(day(A.SUPDATE))) when  ''03'' then SUM(isnull(A.SUP_COPY,0))  else 0 end as p03,      
  case (select(day(A.SUPDATE))) when  ''04'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p04,      
        case (select(day(A.SUPDATE))) when  ''05'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p05,      
        case (select(day(A.SUPDATE))) when  ''06'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p06,      
        case (select(day(A.SUPDATE))) when  ''07'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p07,      
        case (select(day(A.SUPDATE))) when  ''08'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p08,      
        case (select(day(A.SUPDATE))) when  ''09'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p09,      
        case (select(day(A.SUPDATE))) when  ''10'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p10,      
        case (select(day(A.SUPDATE))) when  ''11'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p11,      
        case (select(day(A.SUPDATE))) when  ''12'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p12,      
        case (select(day(A.SUPDATE))) when  ''13'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p13,      
        case (select(day(A.SUPDATE))) when  ''14'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p14,      
        case (select(day(A.SUPDATE))) when  ''15'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p15,      
        case (select(day(A.SUPDATE))) when  ''16'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p16,      
        case (select(day(A.SUPDATE))) when  ''17'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p17,      
        case (select(day(A.SUPDATE))) when  ''18'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p18,      
  case (select(day(A.SUPDATE))) when  ''19'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p19,      
  case (select(day(A.SUPDATE))) when  ''20'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p20,      
  case (select(day(A.SUPDATE))) when  ''21'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p21,      
  case (select(day(A.SUPDATE))) when  ''22'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p22,      
  case (select(day(A.SUPDATE))) when  ''23'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p23,      
  case (select(day(A.SUPDATE))) when  ''24'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p24,      
  case (select(day(A.SUPDATE))) when  ''25'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p25,      
  case (select(day(A.SUPDATE))) when  ''26'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p26,      
  case (select(day(A.SUPDATE))) when  ''27'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p27,      
  case (select(day(A.SUPDATE))) when  ''28'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p28,      
  case (select(day(A.SUPDATE))) when  ''29'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p29,      
  case (select(day(A.SUPDATE))) when  ''30'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p30,      
  case (select(day(A.SUPDATE))) when  ''31'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p31      
        FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C      
        WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE='''+@PCOMP_CODE+''' AND A.UNIT_CODE=B.UNIT AND (A.UNIT_CODE='''+@PUNIT_CODE+''' or '''+@PUNIT_CODE+''' is null or '''+@PUNIT_CODE+'''='''') AND      
        A.AGCD  = B.AGCD AND (A.AGCD='+''''+@PAGCODE+''''+' OR '+''''+@PAGCODE+'''='''') AND       
  A.DPCD  = B.DPCD AND (A.DPCD='+''''+@PDPCODE+''''+' OR '+''''+@PDPCODE+'''='''') AND (A.PUBL='''+@PPUBL+''' or '''+@PPUBL+''' is null or '''+@PPUBL+'''='''') AND (A.EDTN='''+@PEDTN+''' or '''+@PEDTN+''' IS NULL OR '''+@PEDTN+''' ='''') AND (B.CITY_CODE
=  
    
'''+@PCITYCD+''' OR '''+@PCITYCD+''' IS NULL or '''+@PCITYCD+''' ='''') AND      
        (B.STATE_CODE='''+@PSTATECD+''' OR '''+@PSTATECD+''' IS NULL or '''+@PSTATECD+''' ='''') AND       
        (B.DIST_CODE='''+@PDISTCODE+''' OR '''+@PDISTCODE+''' IS NULL or '''+@PDISTCODE+''' ='''') AND (B.TEHSIL_TALUKA='''+@PTALUKA+''' OR '''+@PTALUKA+''' IS NULL or '''+@PTALUKA+''' ='''') AND       
        (B.BRANCH_CODE='''+@PBRANCH+''' OR '''+@PBRANCH+''' IS NULL or '''+@PBRANCH+''' ='''') AND (B.AG_TYPE='''+@PAGTYPE+''' OR '''+@PAGTYPE+''' IS NULL or '''+@PAGTYPE+''' ='''') AND (B.AG_CLASS='''+@PAGCLASS+''' OR '''+@PAGCLASS+''' IS NULL or '''+@PAGCLASS+''' ='''') AND      
        A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE='''+@PEXTRA1+''' OR '''+@PEXTRA1+''' IS NULL or '''+@PEXTRA1+''' ='''') AND       
        A.SUPDATE BETWEEN '''+@VFRDT+''' AND '''+@VTODT+'''    AND A.SUP_COPY>0      
        GROUP BY A.COMP_CODE,A.UNIT_CODE, DBO.cir_get_zone_by_city(B.COMP_CODE,B.city_code,''C'')      
        ,A.SUPDATE,B.CITY_CODE,B.STATE_CODE,B.COUNTRY_CODE) d      
        GROUP BY d.COMP_CODE,d.UNIT_CODE,d.ZONE_CODE,d.EDTN,d.STATE_CODE,d.COUNTRY_CODE      
        ORDER BY d.COMP_CODE,d.UNIT_CODE,d.STATE_CODE,d.ZONE_CODE,d.EDTN'      
              
end      
else if @pextra2='S'      
begin      
 set @pquery='SELECT COMP_CODE,UNIT_CODE,'''' as "EXTRA11",dbo.cir_get_unit_name(COMP_CODE,UNIT_CODE) UNIT_NAME,      
  '''' as "EXTRA",'''' as "EXTRA2"      
  ,isnull(STATE_CODE,''NA'') "STATE CODE",isnull(dbo.CIR_GET_STATE(COMP_CODE,COUNTRY_CODE,STATE_CODE),''NA'') "STATE NAME"      
    ,d.EDTN,dbo.cir_get_edtn_name(COMP_CODE,d.EDTN) "EDITION NAME",dbo.cir_get_edtn_name(COMP_CODE,d.EDTN) "EDITION ONAME",      
       --CITY_CODE "CITY CODE",dbo.cir_get_city(COMP_CODE,CITY_CODE) "CITY NAME",      
       --dbo.cir_get_name_cir_city(COMP_CODE,CITY_CODE,2,'''','''','''') "CITY ONAME",      
       isnull(STATE_CODE,''NA'') "STATE CODE",isnull(dbo.CIR_GET_STATE(COMP_CODE,COUNTRY_CODE,STATE_CODE),''NA'') "STATE NAME",      
    dbo.fn_FormatWithCommas(SUM(p01)) as "01",dbo.fn_FormatWithCommas(SUM(p02)) AS "02",      
    dbo.fn_FormatWithCommas(SUM(p03)) AS "03",dbo.fn_FormatWithCommas(SUM(p04)) AS "04",      
    dbo.fn_FormatWithCommas(SUM(p05)) AS "05",dbo.fn_FormatWithCommas(SUM(p06)) AS "06",      
       dbo.fn_FormatWithCommas(SUM(p07)) AS "07",dbo.fn_FormatWithCommas(SUM(p08)) AS "08",      
       dbo.fn_FormatWithCommas(SUM(p09)) AS "09",dbo.fn_FormatWithCommas(SUM(p10)) AS "10",      
       dbo.fn_FormatWithCommas(SUM(p11)) AS "11",dbo.fn_FormatWithCommas(SUM(p12)) AS "12",      
       dbo.fn_FormatWithCommas(SUM(p13)) AS "13",dbo.fn_FormatWithCommas(SUM(p14)) AS "14",      
       dbo.fn_FormatWithCommas(SUM(p15)) AS "15",dbo.fn_FormatWithCommas(SUM(p16)) AS "16",      
       dbo.fn_FormatWithCommas(SUM(p17)) AS "17",dbo.fn_FormatWithCommas(SUM(p18)) AS "18",      
       dbo.fn_FormatWithCommas(SUM(p19)) AS "19",dbo.fn_FormatWithCommas(SUM(p20)) AS "20",      
       dbo.fn_FormatWithCommas(SUM(p21)) AS "21",dbo.fn_FormatWithCommas(SUM(p22)) AS "22",      
       dbo.fn_FormatWithCommas(SUM(p23)) AS "23",dbo.fn_FormatWithCommas(SUM(p24)) AS "24",      
       dbo.fn_FormatWithCommas(SUM(p25)) AS "25",dbo.fn_FormatWithCommas(SUM(p26)) AS "26",      
       dbo.fn_FormatWithCommas(SUM(p27)) AS "27",dbo.fn_FormatWithCommas(SUM(p28)) AS "28",      
       dbo.fn_FormatWithCommas(SUM(p29)) AS "29",dbo.fn_FormatWithCommas(SUM(p30)) AS "30",      
    dbo.fn_FormatWithCommas(SUM(p31)) AS "31",      
       dbo.fn_FormatWithCommas(SUM(isnull(p01,0)+isnull(p02,0)+isnull(p03,0)+isnull(p04,0)+isnull(p05,0)+isnull(p06,0)+isnull(p07,0)+isnull(p08,0)+isnull(p09,0)+isnull(p10,0)+      
            isnull(p11,0)+isnull(p12,0)+isnull(p13,0)+isnull(p14,0)+isnull(p15,0)+isnull(p16,0)+isnull(p17,0)+isnull(p18,0)+isnull(p19,0)+isnull(p20,0)+      
            isnull(p21,0)+isnull(p22,0)+isnull(p23,0)+isnull(p24,0)+isnull(p25,0)+isnull(p26,0)+isnull(p27,0)+isnull(p28,0)+isnull(p29,0)+isnull(p30,0)+isnull(p31,0))) AS "TOTAL"      
        FROM (      
        SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE      
        ,null EDTN,B.CITY_CODE,B.STATE_CODE STATE_CODE,B.COUNTRY_CODE COUNTRY_CODE,      
        case (select(day(A.SUPDATE))) when  ''1'' then SUM(isnull(A.SUP_COPY,0))  else 0 end as p01,      
  case (select(day(A.SUPDATE))) when  ''02'' then SUM(isnull(A.SUP_COPY,0))else 0 end as p02,      
        case (select(day(A.SUPDATE))) when  ''03'' then SUM(isnull(A.SUP_COPY,0))  else 0 end as p03,      
  case (select(day(A.SUPDATE))) when  ''04'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p04,      
        case (select(day(A.SUPDATE))) when  ''05'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p05,      
        case (select(day(A.SUPDATE))) when  ''06'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p06,      
        case (select(day(A.SUPDATE))) when  ''07'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p07,      
        case (select(day(A.SUPDATE))) when  ''08'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p08,      
        case (select(day(A.SUPDATE))) when  ''09'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p09,      
        case (select(day(A.SUPDATE))) when  ''10'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p10,      
        case (select(day(A.SUPDATE))) when  ''11'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p11,      
        case (select(day(A.SUPDATE))) when  ''12'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p12,      
        case (select(day(A.SUPDATE))) when  ''13'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p13,      
        case (select(day(A.SUPDATE))) when  ''14'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p14,      
        case (select(day(A.SUPDATE))) when  ''15'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p15,      
        case (select(day(A.SUPDATE))) when  ''16'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p16,      
        case (select(day(A.SUPDATE))) when  ''17'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p17,      
        case (select(day(A.SUPDATE))) when  ''18'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p18,      
  case (select(day(A.SUPDATE))) when  ''19'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p19,      
  case (select(day(A.SUPDATE))) when  ''20'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p20,      
  case (select(day(A.SUPDATE))) when  ''21'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p21,      
  case (select(day(A.SUPDATE))) when  ''22'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p22,      
  case (select(day(A.SUPDATE))) when  ''23'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p23,      
  case (select(day(A.SUPDATE))) when  ''24'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p24,      
  case (select(day(A.SUPDATE))) when  ''25'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p25,      
  case (select(day(A.SUPDATE))) when  ''26'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p26,      
  case (select(day(A.SUPDATE))) when  ''27'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p27,        case (select(day(A.SUPDATE))) when  ''28'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p28,      
  case (select(day(A.SUPDATE))) when  ''29'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p29,      
  case (select(day(A.SUPDATE))) when  ''30'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p30,      
  case (select(day(A.SUPDATE))) when  ''31'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p31      
        FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C      
        WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE='''+@PCOMP_CODE+''' AND A.UNIT_CODE=B.UNIT AND (A.UNIT_CODE='''+@PUNIT_CODE+''' or '''+@PUNIT_CODE+''' is null or '''+@PUNIT_CODE+'''='''') AND      
        A.AGCD  = B.AGCD AND (A.AGCD='+''''+@PAGCODE+''''+' OR '+''''+@PAGCODE+'''='''') AND       
  A.DPCD  = B.DPCD AND (A.DPCD='+''''+@PDPCODE+''''+' OR '+''''+@PDPCODE+'''='''') AND (A.PUBL='''+@PPUBL+''' or '''+@PPUBL+''' is null or '''+@PPUBL+'''='''') AND (A.EDTN='''+@PEDTN+''' or '''+@PEDTN+''' IS NULL OR '''+@PEDTN+''' ='''') AND (B.CITY_CODE=
  
    
'''+@PCITYCD+''' OR '''+@PCITYCD+''' IS NULL or '''+@PCITYCD+''' ='''') AND      
        (B.STATE_CODE='''+@PSTATECD+''' OR '''+@PSTATECD+''' IS NULL or '''+@PSTATECD+''' ='''') AND       
        (B.DIST_CODE='''+@PDISTCODE+''' OR '''+@PDISTCODE+''' IS NULL or '''+@PDISTCODE+''' ='''') AND (B.TEHSIL_TALUKA='''+@PTALUKA+''' OR '''+@PTALUKA+''' IS NULL or '''+@PTALUKA+''' ='''') AND       
        (B.BRANCH_CODE='''+@PBRANCH+''' OR '''+@PBRANCH+''' IS NULL or '''+@PBRANCH+''' ='''') AND (B.AG_TYPE='''+@PAGTYPE+''' OR '''+@PAGTYPE+''' IS NULL or '''+@PAGTYPE+''' ='''') AND (B.AG_CLASS='''+@PAGCLASS+''' OR '''+@PAGCLASS+''' IS NULL or '''+@PAGCLASS+''' ='''') AND      
        A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE='''+@PEXTRA1+''' OR '''+@PEXTRA1+''' IS NULL or '''+@PEXTRA1+''' ='''') AND       
        A.SUPDATE BETWEEN '''+@VFRDT+''' AND '''+@VTODT+'''    AND A.SUP_COPY>0      
        GROUP BY A.COMP_CODE,A.UNIT_CODE,A.SUPDATE,B.CITY_CODE,B.STATE_CODE,B.COUNTRY_CODE) d      
        GROUP BY d.COMP_CODE,d.UNIT_CODE,d.EDTN,d.STATE_CODE,d.COUNTRY_CODE      
        ORDER BY d.COMP_CODE,d.UNIT_CODE,d.STATE_CODE,d.EDTN'      
              
end      
else if @pextra2='D'      
begin      
 set @pquery='SELECT COMP_CODE,UNIT_CODE,dbo.cir_get_unit_name(COMP_CODE,UNIT_CODE) UNIT_NAME,      
  '''' as "EXTRA",      
  ISNULL(DIST_CODE, ''NA'') DIST_CODE      
  ,substrING(isnull(dbo.cir_get_dist(COMP_CODE,STATE_CODE, DIST_CODE),''NA''),1,50) "DIST NAME",      
       substring(isnull( dbo.cir_get_name_cir_district(COMP_CODE,DIST_CODE,2,'''','''',''''),''NA''),1,50) "DIST ONAME",      
       d.EDTN,dbo.cir_get_edtn_name(COMP_CODE,d.EDTN) "EDITION NAME",dbo.cir_get_edtn_name(COMP_CODE,d.EDTN) "EDITION ONAME",      
       --CITY_CODE "CITY CODE",dbo.cir_get_city(COMP_CODE,CITY_CODE) "CITY NAME",      
       --dbo.cir_get_name_cir_city(COMP_CODE,CITY_CODE,2,'''','''','''') "CITY ONAME",      
       isnull(STATE_CODE,''NA'') "STATE CODE",isnull(dbo.CIR_GET_STATE(COMP_CODE,COUNTRY_CODE,STATE_CODE),''NA'') "STATE NAME",COUNTRY_CODE,      
    dbo.fn_FormatWithCommas(SUM(p01)) as "01",dbo.fn_FormatWithCommas(SUM(p02)) AS "02",      
    dbo.fn_FormatWithCommas(SUM(p03)) AS "03",dbo.fn_FormatWithCommas(SUM(p04)) AS "04",      
    dbo.fn_FormatWithCommas(SUM(p05)) AS "05",dbo.fn_FormatWithCommas(SUM(p06)) AS "06",      
       dbo.fn_FormatWithCommas(SUM(p07)) AS "07",dbo.fn_FormatWithCommas(SUM(p08)) AS "08",      
       dbo.fn_FormatWithCommas(SUM(p09)) AS "09",dbo.fn_FormatWithCommas(SUM(p10)) AS "10",      
       dbo.fn_FormatWithCommas(SUM(p11)) AS "11",dbo.fn_FormatWithCommas(SUM(p12)) AS "12",      
       dbo.fn_FormatWithCommas(SUM(p13)) AS "13",dbo.fn_FormatWithCommas(SUM(p14)) AS "14",      
       dbo.fn_FormatWithCommas(SUM(p15)) AS "15",dbo.fn_FormatWithCommas(SUM(p16)) AS "16",      
       dbo.fn_FormatWithCommas(SUM(p17)) AS "17",dbo.fn_FormatWithCommas(SUM(p18)) AS "18",      
       dbo.fn_FormatWithCommas(SUM(p19)) AS "19",dbo.fn_FormatWithCommas(SUM(p20)) AS "20",      
       dbo.fn_FormatWithCommas(SUM(p21)) AS "21",dbo.fn_FormatWithCommas(SUM(p22)) AS "22",      
       dbo.fn_FormatWithCommas(SUM(p23)) AS "23",dbo.fn_FormatWithCommas(SUM(p24)) AS "24",      
       dbo.fn_FormatWithCommas(SUM(p25)) AS "25",dbo.fn_FormatWithCommas(SUM(p26)) AS "26",      
       dbo.fn_FormatWithCommas(SUM(p27)) AS "27",dbo.fn_FormatWithCommas(SUM(p28)) AS "28",      
       dbo.fn_FormatWithCommas(SUM(p29)) AS "29",dbo.fn_FormatWithCommas(SUM(p30)) AS "30",      
    dbo.fn_FormatWithCommas(SUM(p31)) AS "31",      
       dbo.fn_FormatWithCommas(SUM(isnull(p01,0)+isnull(p02,0)+isnull(p03,0)+isnull(p04,0)+isnull(p05,0)+isnull(p06,0)+isnull(p07,0)+isnull(p08,0)+isnull(p09,0)+isnull(p10,0)+      
            isnull(p11,0)+isnull(p12,0)+isnull(p13,0)+isnull(p14,0)+isnull(p15,0)+isnull(p16,0)+isnull(p17,0)+isnull(p18,0)+isnull(p19,0)+isnull(p20,0)+      
            isnull(p21,0)+isnull(p22,0)+isnull(p23,0)+isnull(p24,0)+isnull(p25,0)+isnull(p26,0)+isnull(p27,0)+isnull(p28,0)+isnull(p29,0)+isnull(p30,0)+isnull(p31,0))) AS "TOTAL"      
        FROM (      
        SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE      
        , B.DIST_CODE DIST_CODE, null EDTN,B.CITY_CODE,B.STATE_CODE STATE_CODE,B.COUNTRY_CODE COUNTRY_CODE,      
        case (select(day(A.SUPDATE))) when  ''1'' then SUM(isnull(A.SUP_COPY,0))  else 0 end as p01,      
  case (select(day(A.SUPDATE))) when  ''02'' then SUM(isnull(A.SUP_COPY,0))else 0 end as p02,      
        case (select(day(A.SUPDATE))) when  ''03'' then SUM(isnull(A.SUP_COPY,0))  else 0 end as p03,      
  case (select(day(A.SUPDATE))) when  ''04'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p04,      
        case (select(day(A.SUPDATE))) when  ''05'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p05,      
        case (select(day(A.SUPDATE))) when  ''06'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p06,      
        case (select(day(A.SUPDATE))) when  ''07'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p07,      
        case (select(day(A.SUPDATE))) when  ''08'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p08,      
        case (select(day(A.SUPDATE))) when  ''09'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p09,      
        case (select(day(A.SUPDATE))) when  ''10'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p10,      
        case (select(day(A.SUPDATE))) when  ''11'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p11,      
        case (select(day(A.SUPDATE))) when  ''12'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p12,      
        case (select(day(A.SUPDATE))) when  ''13'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p13,      
        case (select(day(A.SUPDATE))) when  ''14'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p14,      
        case (select(day(A.SUPDATE))) when  ''15'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p15,      
        case (select(day(A.SUPDATE))) when  ''16'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p16,      
        case (select(day(A.SUPDATE))) when  ''17'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p17,      
        case (select(day(A.SUPDATE))) when  ''18'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p18,      
  case (select(day(A.SUPDATE))) when  ''19'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p19,      
  case (select(day(A.SUPDATE))) when  ''20'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p20,      
  case (select(day(A.SUPDATE))) when  ''21'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p21,      
  case (select(day(A.SUPDATE))) when  ''22'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p22,      
  case (select(day(A.SUPDATE))) when  ''23'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p23,      
  case (select(day(A.SUPDATE))) when  ''24'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p24,      
  case (select(day(A.SUPDATE))) when  ''25'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p25,      
  case (select(day(A.SUPDATE))) when  ''26'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p26,      
  case (select(day(A.SUPDATE))) when  ''27'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p27,      
  case (select(day(A.SUPDATE))) when  ''28'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p28,      
  case (select(day(A.SUPDATE))) when  ''29'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p29,      
  case (select(day(A.SUPDATE))) when  ''30'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p30,      
  case (select(day(A.SUPDATE))) when  ''31'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p31      
        FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C      
        WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE='''+@PCOMP_CODE+''' AND A.UNIT_CODE=B.UNIT AND (A.UNIT_CODE='''+@PUNIT_CODE+''' or '''+@PUNIT_CODE+''' is null or '''+@PUNIT_CODE+'''='''') AND      
        A.AGCD  = B.AGCD AND (A.AGCD='+''''+@PAGCODE+''''+' OR '+''''+@PAGCODE+'''='''') AND       
  A.DPCD  = B.DPCD AND (A.DPCD='+''''+@PDPCODE+''''+' OR '+''''+@PDPCODE+'''='''') AND (A.PUBL='''+@PPUBL+''' or '''+@PPUBL+''' is null or '''+@PPUBL+'''='''') AND (A.EDTN='''+@PEDTN+''' or '''+@PEDTN+''' IS NULL OR '''+@PEDTN+''' ='''') AND (B.CITY_CODE 
 
=    
'''+@PCITYCD+''' OR '''+@PCITYCD+''' IS NULL or '''+@PCITYCD+''' ='''') AND      
        (B.STATE_CODE='''+@PSTATECD+''' OR '''+@PSTATECD+''' IS NULL or '''+@PSTATECD+''' ='''') AND       
        (B.DIST_CODE='''+@PDISTCODE+''' OR '''+@PDISTCODE+''' IS NULL or '''+@PDISTCODE+''' ='''') AND (B.TEHSIL_TALUKA='''+@PTALUKA+''' OR '''+@PTALUKA+''' IS NULL or '''+@PTALUKA+''' ='''') AND       
        (B.BRANCH_CODE='''+@PBRANCH+''' OR '''+@PBRANCH+''' IS NULL or '''+@PBRANCH+''' ='''') AND (B.AG_TYPE='''+@PAGTYPE+''' OR '''+@PAGTYPE+''' IS NULL or '''+@PAGTYPE+''' ='''') AND (B.AG_CLASS='''+@PAGCLASS+''' OR '''+@PAGCLASS+''' IS NULL or '''+@PAGCLASS+''' ='''') AND      
        A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE='''+@PEXTRA1+''' OR '''+@PEXTRA1+''' IS NULL or '''+@PEXTRA1+''' ='''') AND       
        A.SUPDATE BETWEEN '''+@VFRDT+''' AND '''+@VTODT+'''    AND A.SUP_COPY>0      
        GROUP BY A.COMP_CODE,A.UNIT_CODE, B.DIST_CODE,A.SUPDATE,B.CITY_CODE,B.STATE_CODE,B.COUNTRY_CODE) d      
        GROUP BY d.COMP_CODE,d.UNIT_CODE,d.DIST_CODE,d.EDTN,d.STATE_CODE,d.COUNTRY_CODE      
        ORDER BY d.COMP_CODE,d.UNIT_CODE,d.STATE_CODE,d.DIST_CODE,d.EDTN'      
              
end      
else      
begin      
 set @pquery='SELECT COMP_CODE,UNIT_CODE,dbo.cir_get_unit_name(COMP_CODE,UNIT_CODE) UNIT_NAME,      
  AGCD "AGENCY CODE",DPCD "AGENCY SUBCODE",substrING(dbo.cir_get_name_cir_agname(comp_code,unit_code,agcd,dpcd,1,'''','''',''''),1,50) "AGENCY NAME",      
       substring(dbo.cir_get_name_cir_agname(comp_code,unit_code,agcd,dpcd,2,'''','''',''''),1,50) "AGENCY ONAME",      
       d.EDTN,dbo.cir_get_edtn_name(COMP_CODE,d.EDTN) "EDITION NAME",dbo.cir_get_edtn_name(COMP_CODE,d.EDTN) "EDITION ONAME",      
       CITY_CODE "CITY CODE",dbo.cir_get_city(COMP_CODE,CITY_CODE) "CITY NAME",      
       dbo.cir_get_name_cir_city(COMP_CODE,CITY_CODE,2,'''','''','''') "CITY ONAME",      
       isnull(STATE_CODE,''NA'') "STATE CODE",isnull(dbo.CIR_GET_STATE(COMP_CODE,COUNTRY_CODE,STATE_CODE),''NA'') "STATE NAME",COUNTRY_CODE,      
    dbo.fn_FormatWithCommas(SUM(p01)) as "01",dbo.fn_FormatWithCommas(SUM(p02)) AS "02",      
    dbo.fn_FormatWithCommas(SUM(p03)) AS "03",dbo.fn_FormatWithCommas(SUM(p04)) AS "04",      
    dbo.fn_FormatWithCommas(SUM(p05)) AS "05",dbo.fn_FormatWithCommas(SUM(p06)) AS "06",      
       dbo.fn_FormatWithCommas(SUM(p07)) AS "07",dbo.fn_FormatWithCommas(SUM(p08)) AS "08",      
       dbo.fn_FormatWithCommas(SUM(p09)) AS "09",dbo.fn_FormatWithCommas(SUM(p10)) AS "10",      
       dbo.fn_FormatWithCommas(SUM(p11)) AS "11",dbo.fn_FormatWithCommas(SUM(p12)) AS "12",      
       dbo.fn_FormatWithCommas(SUM(p13)) AS "13",dbo.fn_FormatWithCommas(SUM(p14)) AS "14",      
       dbo.fn_FormatWithCommas(SUM(p15)) AS "15",dbo.fn_FormatWithCommas(SUM(p16)) AS "16",      
       dbo.fn_FormatWithCommas(SUM(p17)) AS "17",dbo.fn_FormatWithCommas(SUM(p18)) AS "18",      
       dbo.fn_FormatWithCommas(SUM(p19)) AS "19",dbo.fn_FormatWithCommas(SUM(p20)) AS "20",      
       dbo.fn_FormatWithCommas(SUM(p21)) AS "21",dbo.fn_FormatWithCommas(SUM(p22)) AS "22",      
       dbo.fn_FormatWithCommas(SUM(p23)) AS "23",dbo.fn_FormatWithCommas(SUM(p24)) AS "24",      
       dbo.fn_FormatWithCommas(SUM(p25)) AS "25",dbo.fn_FormatWithCommas(SUM(p26)) AS "26",      
       dbo.fn_FormatWithCommas(SUM(p27)) AS "27",dbo.fn_FormatWithCommas(SUM(p28)) AS "28",      
       dbo.fn_FormatWithCommas(SUM(p29)) AS "29",dbo.fn_FormatWithCommas(SUM(p30)) AS "30",      
    dbo.fn_FormatWithCommas(SUM(p31)) AS "31",      
       dbo.fn_FormatWithCommas(SUM(isnull(p01,0)+isnull(p02,0)+isnull(p03,0)+isnull(p04,0)+isnull(p05,0)+isnull(p06,0)+isnull(p07,0)+isnull(p08,0)+isnull(p09,0)+isnull(p10,0)+      
            isnull(p11,0)+isnull(p12,0)+isnull(p13,0)+isnull(p14,0)+isnull(p15,0)+isnull(p16,0)+isnull(p17,0)+isnull(p18,0)+isnull(p19,0)+isnull(p20,0)+      
            isnull(p21,0)+isnull(p22,0)+isnull(p23,0)+isnull(p24,0)+isnull(p25,0)+isnull(p26,0)+isnull(p27,0)+isnull(p28,0)+isnull(p29,0)+isnull(p30,0)+isnull(p31,0))) AS "TOTAL"      
        FROM (SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.AGCD AGCD,A.DPCD DPCD,null EDTN,B.CITY_CODE,B.STATE_CODE STATE_CODE,B.COUNTRY_CODE COUNTRY_CODE,      
        case (select(day(A.SUPDATE))) when  ''1'' then SUM(isnull(A.SUP_COPY,0))  else 0 end as p01,      
  case (select(day(A.SUPDATE))) when  ''02'' then SUM(isnull(A.SUP_COPY,0))else 0 end as p02,      
        case (select(day(A.SUPDATE))) when  ''03'' then SUM(isnull(A.SUP_COPY,0))  else 0 end as p03,      
  case (select(day(A.SUPDATE))) when  ''04'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p04,      
        case (select(day(A.SUPDATE))) when  ''05'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p05,      
        case (select(day(A.SUPDATE))) when  ''06'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p06,      
        case (select(day(A.SUPDATE))) when  ''07'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p07,      
        case (select(day(A.SUPDATE))) when  ''08'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p08,      
        case (select(day(A.SUPDATE))) when  ''09'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p09,      
        case (select(day(A.SUPDATE))) when  ''10'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p10,      
        case (select(day(A.SUPDATE))) when  ''11'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p11,      
        case (select(day(A.SUPDATE))) when  ''12'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p12,      
      case (select(day(A.SUPDATE))) when  ''13'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p13,      
        case (select(day(A.SUPDATE))) when  ''14'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p14,      
        case (select(day(A.SUPDATE))) when  ''15'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p15,      
        case (select(day(A.SUPDATE))) when  ''16'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p16,      
        case (select(day(A.SUPDATE))) when  ''17'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p17,      
        case (select(day(A.SUPDATE))) when  ''18'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p18,      
  case (select(day(A.SUPDATE))) when  ''19'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p19,      
  case (select(day(A.SUPDATE))) when  ''20'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p20,      
  case (select(day(A.SUPDATE))) when  ''21'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p21,      
  case (select(day(A.SUPDATE))) when  ''22'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p22,      
  case (select(day(A.SUPDATE))) when  ''23'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p23,      
  case (select(day(A.SUPDATE))) when  ''24'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p24,      
  case (select(day(A.SUPDATE))) when  ''25'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p25,      
  case (select(day(A.SUPDATE))) when  ''26'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p26,      
  case (select(day(A.SUPDATE))) when  ''27'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p27,      
  case (select(day(A.SUPDATE))) when  ''28'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p28,      
  case (select(day(A.SUPDATE))) when  ''29'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p29,      
  case (select(day(A.SUPDATE))) when  ''30'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p30,      
  case (select(day(A.SUPDATE))) when  ''31'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p31      
        FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C      
        WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE='''+@PCOMP_CODE+''' AND A.UNIT_CODE=B.UNIT AND (A.UNIT_CODE='''+@PUNIT_CODE+''' or '''+@PUNIT_CODE+''' is null or '''+@PUNIT_CODE+'''='''') AND      
        A.AGCD  = B.AGCD AND (A.AGCD='+''''+@PAGCODE+''''+' OR '+''''+@PAGCODE+'''='''') AND       
  A.DPCD  = B.DPCD AND (A.DPCD='+''''+@PDPCODE+''''+' OR '+''''+@PDPCODE+'''='''') AND (A.PUBL='''+@PPUBL+''' or '''+@PPUBL+''' is null or '''+@PPUBL+'''='''') AND (A.EDTN='''+@PEDTN+''' or '''+@PEDTN+''' IS NULL OR '''+@PEDTN+''' ='''') AND (B.CITY_CODE
=  
    
'''+@PCITYCD+''' OR '''+@PCITYCD+''' IS NULL or '''+@PCITYCD+''' ='''') AND      
        (B.STATE_CODE='''+@PSTATECD+''' OR '''+@PSTATECD+''' IS NULL or '''+@PSTATECD+''' ='''') AND       
        (B.DIST_CODE='''+@PDISTCODE+''' OR '''+@PDISTCODE+''' IS NULL or '''+@PDISTCODE+''' ='''') AND (B.TEHSIL_TALUKA='''+@PTALUKA+''' OR '''+@PTALUKA+''' IS NULL or '''+@PTALUKA+''' ='''') AND       
        (B.BRANCH_CODE='''+@PBRANCH+''' OR '''+@PBRANCH+''' IS NULL or '''+@PBRANCH+''' ='''') AND (B.AG_TYPE='''+@PAGTYPE+''' OR '''+@PAGTYPE+''' IS NULL or '''+@PAGTYPE+''' ='''') AND (B.AG_CLASS='''+@PAGCLASS+''' OR '''+@PAGCLASS+''' IS NULL or '''+@PAGCLASS+''' ='''') AND      
        A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE='''+@PEXTRA1+''' OR '''+@PEXTRA1+''' IS NULL or '''+@PEXTRA1+''' ='''') AND       
        A.SUPDATE BETWEEN '''+@VFRDT+''' AND '''+@VTODT+'''    AND A.SUP_COPY>0      
        GROUP BY A.COMP_CODE,A.UNIT_CODE,A.AGCD,A.DPCD,A.SUPDATE,B.CITY_CODE,B.STATE_CODE,B.COUNTRY_CODE) d      
        GROUP BY d.COMP_CODE,d.UNIT_CODE,d.AGCD,d.DPCD,d.EDTN,d.CITY_CODE,d.STATE_CODE,d.COUNTRY_CODE      
        ORDER BY d.COMP_CODE,d.UNIT_CODE,d.STATE_CODE,d.AGCD,d.DPCD,d.EDTN,d.CITY_CODE'              
end      
print('table0')      
print(@pextra2)      
print(@pquery)      
      
 set @pquery1='SELECT COMP_CODE,UNIT_CODE,isnull(STATE_CODE,''NA'') "STATE CODE",isnull(dbo.CIR_GET_STATE(COMP_CODE,COUNTRY_CODE,STATE_CODE),''NA'') "STATE NAME",COUNTRY_CODE,      
        dbo.fn_FormatWithCommas(SUM(p01)) AS "01",dbo.fn_FormatWithCommas(SUM(p02)) AS "02",      
        dbo.fn_FormatWithCommas(SUM(p03)) AS "03",dbo.fn_FormatWithCommas(SUM(p04)) AS "04",      
        dbo.fn_FormatWithCommas(SUM(p05)) AS "05",dbo.fn_FormatWithCommas(SUM(p06)) AS "06",      
        dbo.fn_FormatWithCommas(SUM(p07)) AS "07",dbo.fn_FormatWithCommas(SUM(p08)) AS "08",      
        dbo.fn_FormatWithCommas(SUM(p09)) AS "09",dbo.fn_FormatWithCommas(SUM(p10)) AS "10",      
        dbo.fn_FormatWithCommas(SUM(p11)) AS "11",dbo.fn_FormatWithCommas(SUM(p12)) AS "12",      
        dbo.fn_FormatWithCommas(SUM(p13)) AS "13",dbo.fn_FormatWithCommas(SUM(p14)) AS "14",      
        dbo.fn_FormatWithCommas(SUM(p15)) AS "15",dbo.fn_FormatWithCommas(SUM(p16)) AS "16",      
        dbo.fn_FormatWithCommas(SUM(p17)) AS "17",dbo.fn_FormatWithCommas(SUM(p18)) AS "18",      
        dbo.fn_FormatWithCommas(SUM(p19)) AS "19",dbo.fn_FormatWithCommas(SUM(p20)) AS "20",      
        dbo.fn_FormatWithCommas(SUM(p21)) AS "21",dbo.fn_FormatWithCommas(SUM(p22)) AS "22",      
        dbo.fn_FormatWithCommas(SUM(p23)) AS "23",dbo.fn_FormatWithCommas(SUM(p24)) AS "24",      
        dbo.fn_FormatWithCommas(SUM(p25)) AS "25",dbo.fn_FormatWithCommas(SUM(p26)) AS "26",      
        dbo.fn_FormatWithCommas(SUM(p27)) AS "27",dbo.fn_FormatWithCommas(SUM(p28)) AS "28",      
        dbo.fn_FormatWithCommas(SUM(p29)) AS "29",dbo.fn_FormatWithCommas(SUM(p30)) AS "30",      
        dbo.fn_FormatWithCommas(SUM(p31)) AS "31",      
        dbo.fn_FormatWithCommas(SUM(isnull(p01,0)+isnull(p02,0)+isnull(p03,0)+isnull(p04,0)+isnull(p05,0)+isnull(p06,0)+isnull(p07,0)+isnull(p08,0)+isnull(p09,0)+isnull(p10,0)+      
        isnull(p11,0)+isnull(p12,0)+isnull(p13,0)+isnull(p14,0)+isnull(p15,0)+isnull(p16,0)+isnull(p17,0)+isnull(p18,0)+isnull(p19,0)+isnull(p20,0)+      
        isnull(p21,0)+isnull(p22,0)+isnull(p23,0)+isnull(p24,0)+isnull(p25,0)+isnull(p26,0)+isnull(p27,0)+isnull(p28,0)+isnull(p29,0)+isnull(p30,0)+isnull(p31,0))) AS "TOTAL"      
        --,publ      
        FROM (SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,a.PUBL,B.STATE_CODE STATE_CODE,B.COUNTRY_CODE COUNTRY_CODE,      
  case (select(day(A.SUPDATE))) when  ''1'' then SUM(isnull(A.SUP_COPY,0))  else 0 end as p01,      
  case (select(day(A.SUPDATE))) when  ''02'' then SUM(isnull(A.SUP_COPY,0))else 0 end as p02,      
        case (select(day(A.SUPDATE))) when  ''03'' then SUM(isnull(A.SUP_COPY,0))  else 0 end as p03,      
  case (select(day(A.SUPDATE))) when  ''04'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p04,      
        case (select(day(A.SUPDATE))) when  ''05'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p05,            case (select(day(A.SUPDATE))) when  ''06'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p06,      
        case (select(day(A.SUPDATE))) when  ''07'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p07,      
        case (select(day(A.SUPDATE))) when  ''08'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p08,      
        case (select(day(A.SUPDATE))) when  ''09'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p09,      
        case (select(day(A.SUPDATE))) when  ''10'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p10,      
        case (select(day(A.SUPDATE))) when  ''11'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p11,      
        case (select(day(A.SUPDATE))) when  ''12'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p12,      
        case (select(day(A.SUPDATE))) when  ''13'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p13,      
        case (select(day(A.SUPDATE))) when  ''14'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p14,      
        case (select(day(A.SUPDATE))) when  ''15'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p15,      
        case (select(day(A.SUPDATE))) when  ''16'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p16,      
        case (select(day(A.SUPDATE))) when  ''17'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p17,      
        case (select(day(A.SUPDATE))) when  ''18'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p18,      
  case (select(day(A.SUPDATE))) when  ''19'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p19,      
  case (select(day(A.SUPDATE))) when  ''20'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p20,      
  case (select(day(A.SUPDATE))) when  ''21'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p21,      
  case (select(day(A.SUPDATE))) when  ''22'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p22,      
  case (select(day(A.SUPDATE))) when  ''23'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p23,      
  case (select(day(A.SUPDATE))) when  ''24'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p24,      
  case (select(day(A.SUPDATE))) when  ''25'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p25,      
  case (select(day(A.SUPDATE))) when  ''26'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p26,      
  case (select(day(A.SUPDATE))) when  ''27'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p27,      
  case (select(day(A.SUPDATE))) when  ''28'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p28,      
  case (select(day(A.SUPDATE))) when  ''29'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p29,      
  case (select(day(A.SUPDATE))) when  ''30'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p30,      
  case (select(day(A.SUPDATE))) when  ''31'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p31             
        FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C      
        WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE='''+@PCOMP_CODE+''' AND A.UNIT_CODE=B.UNIT AND (A.UNIT_CODE='''+@PUNIT_CODE+''' or '''+@PUNIT_CODE+''' is null or '''+@PUNIT_CODE+'''='''') AND      
        A.AGCD  = B.AGCD AND (A.AGCD='+''''+@PAGCODE+''''+' OR '+''''+@PAGCODE+'''='''') AND       
  A.DPCD  = B.DPCD AND (A.DPCD='+''''+@PDPCODE+''''+' OR '+''''+@PDPCODE+'''='''') AND (A.PUBL='''+@PPUBL+''' or '''+@PPUBL+''' is null or '''+@PPUBL+'''='''') AND (A.EDTN='''+@PEDTN+''' OR '''+@PEDTN+''' IS NULL or '''+@PEDTN+'''='''') AND (B.CITY_CODE='''+@PCITYCD+''' OR '''+@PCITYCD+''' IS NULL or '''+@PCITYCD+'''='''') AND      
        (B.STATE_CODE='''+@PSTATECD+''' OR '''+@PSTATECD+''' IS NULL or '''+@PSTATECD+'''='''') AND       
        (B.DIST_CODE='''+@PDISTCODE+''' OR '''+@PDISTCODE+''' IS NULL or '''+@PDISTCODE+''' ='''') AND (B.TEHSIL_TALUKA='''+@PTALUKA+''' OR '''+@PTALUKA+''' IS NULL or '''+@PTALUKA+''' ='''') AND       
        (B.BRANCH_CODE='''+@PBRANCH+''' OR '''+@PBRANCH+''' IS NULL or '''+@PBRANCH+''' ='''') AND (B.AG_TYPE='''+@PAGTYPE+''' OR '''+@PAGTYPE+''' IS NULL or '''+@PAGTYPE+''' ='''') AND (B.AG_CLASS='''+@PAGCLASS+''' OR '''+@PAGCLASS+''' IS NULL or '''+@PAGCLASS+''' ='''') AND      
        A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE='''+@PEXTRA1+''' OR '''+@PEXTRA1+''' IS NULL or '''+@PEXTRA1+''' ='''') AND       
        A.SUPDATE BETWEEN '''+@VFRDT+''' AND '''+@VTODT+'''    AND isnull(A.SUP_COPY,0)>0      
        GROUP BY A.COMP_CODE,A.UNIT_CODE,a.PUBL,A.SUPDATE,B.STATE_CODE,B.COUNTRY_CODE) d      
        GROUP BY d.COMP_CODE,d.UNIT_CODE,d.STATE_CODE,d.COUNTRY_CODE      
        ORDER BY d.COMP_CODE,d.UNIT_CODE,d.STATE_CODE;'      
              
        print('table1')      
        print(@pquery1)      
      
set @pquery2='SELECT COMP_CODE,      
  dbo.fn_FormatWithCommas(SUM(p01)) AS "01",dbo.fn_FormatWithCommas(SUM(p02)) AS "02",      
  dbo.fn_FormatWithCommas(SUM(p03)) AS "03",dbo.fn_FormatWithCommas(SUM(p04)) AS "04",      
  dbo.fn_FormatWithCommas(SUM(p05)) AS "05",dbo.fn_FormatWithCommas(SUM(p06)) AS "06",      
        dbo.fn_FormatWithCommas(SUM(p07)) AS "07",dbo.fn_FormatWithCommas(SUM(p08)) AS "08",      
        dbo.fn_FormatWithCommas(SUM(p09)) AS "09",dbo.fn_FormatWithCommas(SUM(p10)) AS "10",      
        dbo.fn_FormatWithCommas(SUM(p11)) AS "11",dbo.fn_FormatWithCommas(SUM(p12)) AS "12",      
        dbo.fn_FormatWithCommas(SUM(p13)) AS "13",dbo.fn_FormatWithCommas(SUM(p14)) AS "14",      
        dbo.fn_FormatWithCommas(SUM(p15)) AS "15",dbo.fn_FormatWithCommas(SUM(p16)) AS "16",      
        dbo.fn_FormatWithCommas(SUM(p17)) AS "17",dbo.fn_FormatWithCommas(SUM(p18)) AS "18",      
        dbo.fn_FormatWithCommas(SUM(p19)) AS "19",dbo.fn_FormatWithCommas(SUM(p20)) AS "20",      
        dbo.fn_FormatWithCommas(SUM(p21)) AS "21",dbo.fn_FormatWithCommas(SUM(p22)) AS "22",      
        dbo.fn_FormatWithCommas(SUM(p23)) AS "23",dbo.fn_FormatWithCommas(SUM(p24)) AS "24",      
        dbo.fn_FormatWithCommas(SUM(p25)) AS "25",dbo.fn_FormatWithCommas(SUM(p26)) AS "26",      
        dbo.fn_FormatWithCommas(SUM(p27)) AS "27",dbo.fn_FormatWithCommas(SUM(p28)) AS "28",      
        dbo.fn_FormatWithCommas(SUM(p29)) AS "29",dbo.fn_FormatWithCommas(SUM(p30)) AS "30",      
        dbo.fn_FormatWithCommas(SUM(p31)) AS "31",      
        dbo.fn_FormatWithCommas(SUM(isnull(p01,0)+isnull(p02,0)+isnull(p03,0)+isnull(p04,0)+isnull(p05,0)+isnull(p06,0)+isnull(p07,0)+isnull(p08,0)+isnull(p09,0)+isnull(p10,0)+      
        isnull(p11,0)+isnull(p12,0)+isnull(p13,0)+isnull(p14,0)+isnull(p15,0)+isnull(p16,0)+isnull(p17,0)+isnull(p18,0)+isnull(p19,0)+isnull(p20,0)+      
        isnull(p21,0)+isnull(p22,0)+isnull(p23,0)+isnull(p24,0)+isnull(p25,0)+isnull(p26,0)+isnull(p27,0)+isnull(p28,0)+isnull(p29,0)+isnull(p30,0)+isnull(p31,0))) AS "TOTAL"      
        
        FROM (SELECT     A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,      
  case (select(day(A.SUPDATE))) when  ''1'' then SUM(isnull(A.SUP_COPY,0))  else 0 end as p01,      
  case (select(day(A.SUPDATE))) when  ''02'' then SUM(isnull(A.SUP_COPY,0))else 0 end as p02,      
        case (select(day(A.SUPDATE))) when  ''03'' then SUM(isnull(A.SUP_COPY,0))  else 0 end as p03,      
  case (select(day(A.SUPDATE))) when  ''04'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p04,      
        case (select(day(A.SUPDATE))) when  ''05'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p05,      
        case (select(day(A.SUPDATE))) when  ''06'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p06,      
        case (select(day(A.SUPDATE))) when  ''07'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p07,      
        case (select(day(A.SUPDATE))) when  ''08'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p08,      
        case (select(day(A.SUPDATE))) when  ''09'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p09,      
        case (select(day(A.SUPDATE))) when  ''10'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p10,      
        case (select(day(A.SUPDATE))) when  ''11'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p11,      
        case (select(day(A.SUPDATE))) when  ''12'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p12,      
        case (select(day(A.SUPDATE))) when  ''13'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p13,      
        case (select(day(A.SUPDATE))) when  ''14'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p14,      
        case (select(day(A.SUPDATE))) when  ''15'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p15,      
        case (select(day(A.SUPDATE))) when  ''16'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p16,      
        case (select(day(A.SUPDATE))) when  ''17'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p17,      
        case (select(day(A.SUPDATE))) when  ''18'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p18,      
  case (select(day(A.SUPDATE))) when  ''19'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p19,      
  case (select(day(A.SUPDATE))) when  ''20'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p20,      
  case (select(day(A.SUPDATE))) when  ''21'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p21,      
  case (select(day(A.SUPDATE))) when  ''22'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p22,      
  case (select(day(A.SUPDATE))) when  ''23'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p23,      
  case (select(day(A.SUPDATE))) when  ''24'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p24,      
  case (select(day(A.SUPDATE))) when  ''25'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p25,      
  case (select(day(A.SUPDATE))) when  ''26'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p26,      
  case (select(day(A.SUPDATE))) when  ''27'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p27,      
  case (select(day(A.SUPDATE))) when  ''28'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p28,      
  case (select(day(A.SUPDATE))) when  ''29'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p29,      
  case (select(day(A.SUPDATE))) when  ''30'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p30,      
  case (select(day(A.SUPDATE))) when  ''31'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p31      
        FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C      
        WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE='''+@PCOMP_CODE+''' AND A.UNIT_CODE=B.UNIT AND (A.UNIT_CODE='''+@PUNIT_CODE+''' or '''+@PUNIT_CODE+''' is null or '''+@PUNIT_CODE+'''='''') AND      
        A.AGCD  = B.AGCD AND (A.AGCD='+''''+@PAGCODE+''''+' OR '+''''+@PAGCODE+'''='''') AND       
  A.DPCD  = B.DPCD AND (A.DPCD='+''''+@PDPCODE+''''+' OR '+''''+@PDPCODE+'''='''') AND (A.PUBL='''+@PPUBL+''' or '''+@PPUBL+''' is null or '''+@PPUBL+'''='''') AND (A.EDTN='''+@PEDTN+''' OR '''+@PEDTN+''' IS NULL or '''+@PEDTN+'''='''') AND (B.CITY_CODE= 
 
'''+@PCITYCD+''' OR '''+@PCITYCD+''' IS NULL or '''+@PCITYCD+'''='''') AND      
        (B.STATE_CODE='''+@PSTATECD+''' OR '''+@PSTATECD+''' IS NULL OR '''+@PSTATECD+'''='''') AND       
        (B.DIST_CODE='''+@PDISTCODE+''' OR '''+@PDISTCODE+''' IS NULL or '''+@PDISTCODE+''' ='''') AND (B.TEHSIL_TALUKA='''+@PTALUKA+''' OR '''+@PTALUKA+''' IS NULL or '''+@PTALUKA+''' ='''') AND       
        (B.BRANCH_CODE='''+@PBRANCH+''' OR '''+@PBRANCH+''' IS NULL or '''+@PBRANCH+''' ='''') AND (B.AG_TYPE='''+@PAGTYPE+''' OR '''+@PAGTYPE+''' IS NULL or '''+@PAGTYPE+''' ='''') AND (B.AG_CLASS='''+@PAGCLASS+''' OR '''+@PAGCLASS+''' IS NULL or '''+@PAGCLASS+''' ='''') AND      
        A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE='''+@PEXTRA1+''' OR '''+@PEXTRA1+''' IS NULL or '''+@PEXTRA1+''' ='''') AND       
        A.SUPDATE BETWEEN '''+@VFRDT+''' AND '''+@VTODT+''' AND isnull(A.SUP_COPY,0)>0      
        GROUP BY A.COMP_CODE,A.UNIT_CODE,A.SUPDATE) d      
        GROUP BY d.COMP_CODE      
        ORDER BY d.COMP_CODE'      
      
 PRINT @pquery      
 PRINT @pquery1      
 PRINT @pquery2      
      
 exec(@pquery)      
 exec(@pquery1)      
 exec(@pquery2)       
    
 if @pextra2='S'  begin      
    
 SELECT x.COMP_CODE,x.UNIT_CODE,x.PUBL,ISNULL(SUM(ISNULL(x.SUN_COPY,0)),0)  AS 'SUN_COPY',x.STATE_CODE                 
 FROM(SELECT a.COMP_CODE,a.UNIT_CODE,a.PUBL,              
 ISNULL(SUM(a.SUP_COPY),0)  AS 'SUN_COPY' ,B.STATE_CODE                               
 FROM CIR_DBKSUP a,CIR_AGMAST B  WHERE    
 A.COMP_CODE=B.COMP_CODE and  a.comp_code=@pcomp_code and      
 A.UNIT_CODE=B.UNIT and a.unit_code=@punit_code        
 and A.AGCD  = B.AGCD  and   A.DPCD  = B.DPCD           
 and a.supdate   between @VFRDT and @VTODT      
 and (a.agcd = isnull(@PAGCODE,a.agcd) OR @PAGCODE='')       
 and (a.dpcd = isnull(@PDPCODE,a.dpcd) OR @PDPCODE='')     
 and (B.STATE_CODE=isnull(@PSTATECD,B.STATE_CODE) OR @PSTATECD='')     
 and (B.DIST_CODE=isnull(@PDISTCODE,B.DIST_CODE) OR @PDISTCODE='')      
 AND (B.CITY_CODE=isnull(@PCITYCD,B.CITY_CODE) OR @PCITYCD='')    
 and (B.BRANCH_CODE=isnull(@PBRANCH,B.DIST_CODE) OR @PBRANCH='')     
 and (B.AG_TYPE=isnull(@PAGTYPE,B.AG_TYPE) OR @PAGTYPE='')    
 and DATENAME(DW,SUPDATE ) = 'SUNDAY'            
 GROUP BY a.COMP_CODE,a.UNIT_CODE,a.PUBL,B.STATE_CODE)X              
 group by x.COMP_CODE,x.UNIT_CODE,x.PUBL,x.STATE_CODE      
 ORDER BY x.COMP_CODE,x.UNIT_CODE,x.PUBL,x.STATE_CODE    
    
 end    
 else begin    
 SELECT x.COMP_CODE,x.UNIT_CODE,x.PUBL,x.agcd,x.dpcd,ISNULL(SUM(ISNULL(x.SUN_COPY,0)),0)  AS 'SUN_COPY'                 
 FROM(SELECT a.COMP_CODE,a.UNIT_CODE,a.PUBL,a.agcd,a.dpcd,              
 ISNULL(SUM(a.SUP_COPY),0)  AS 'SUN_COPY'                  
 FROM CIR_DBKSUP a,CIR_AGMAST B  WHERE    
 A.COMP_CODE=B.COMP_CODE and  a.comp_code=@pcomp_code and      
 A.UNIT_CODE=B.UNIT and a.unit_code=@punit_code        
 and A.AGCD  = B.AGCD  and   A.DPCD  = B.DPCD           
 and a.supdate   between @VFRDT and @VTODT        
 and (a.agcd = isnull(@PAGCODE,a.agcd) OR @PAGCODE='')       
 and (a.dpcd = isnull(@PDPCODE,a.dpcd) OR @PDPCODE='')     
 and (B.STATE_CODE=isnull(@PSTATECD,B.STATE_CODE) OR @PSTATECD='')     
 and (B.DIST_CODE=isnull(@PDISTCODE,B.DIST_CODE) OR @PDISTCODE='')      
 AND (B.CITY_CODE=isnull(@PCITYCD,B.CITY_CODE) OR @PCITYCD='')    
 and (B.BRANCH_CODE=isnull(@PBRANCH,B.DIST_CODE) OR @PBRANCH='')     
 and (B.AG_TYPE=isnull(@PAGTYPE,B.AG_TYPE) OR @PAGTYPE='')     
 and DATENAME(DW,SUPDATE ) = 'SUNDAY'            
 GROUP BY A.COMP_CODE,A.UNIT_CODE,A.PUBL,A.agcd,A.dpcd)X              
 group by x.COMP_CODE,x.UNIT_CODE,x.PUBL,x.agcd,x.dpcd      
 ORDER BY x.COMP_CODE,x.UNIT_CODE,x.PUBL,x.agcd,x.dpcd         
  end    
       
      
      
        
    
 if @pextra2='S'  begin      
    
 SELECT x.COMP_CODE,x.UNIT_CODE,x.PUBL,ISNULL(SUM(ISNULL(x.WEEK_COPY,0)),0)  AS 'WEEK_COPY',x.STATE_CODE                       
 FROM(SELECT a.COMP_CODE,a.UNIT_CODE,a.PUBL,            
 ISNULL(SUM(a.SUP_COPY),0)  AS 'WEEK_COPY' ,B.STATE_CODE                 
 FROM CIR_DBKSUP a,CIR_AGMAST B  WHERE    
 A.COMP_CODE=B.COMP_CODE and  a.comp_code=@pcomp_code and      
 A.UNIT_CODE=B.UNIT and a.unit_code=@punit_code        
 and A.AGCD  = B.AGCD  and   A.DPCD  = B.DPCD           
 and a.supdate   between @VFRDT and @VTODT        
 and (a.agcd = isnull(@PAGCODE,a.agcd) OR @PAGCODE='')       
 and (a.dpcd = isnull(@PDPCODE,a.dpcd) OR @PDPCODE='')     
 and (B.STATE_CODE=isnull(@PSTATECD,B.STATE_CODE) OR @PSTATECD='')     
 and (B.DIST_CODE=isnull(@PDISTCODE,B.DIST_CODE) OR @PDISTCODE='')      
 AND (B.CITY_CODE=isnull(@PCITYCD,B.CITY_CODE) OR @PCITYCD='')    
 and (B.BRANCH_CODE=isnull(@PBRANCH,B.DIST_CODE) OR @PBRANCH='')     
 and (B.AG_TYPE=isnull(@PAGTYPE,B.AG_TYPE) OR @PAGTYPE='')    
 and DATENAME(DW,SUPDATE )! = 'SUNDAY'            
 GROUP BY a.COMP_CODE,a.UNIT_CODE,a.PUBL,B.STATE_CODE)X              
 group by x.COMP_CODE,x.UNIT_CODE,x.PUBL,x.STATE_CODE    
 ORDER BY x.COMP_CODE,x.UNIT_CODE,x.PUBL,x.STATE_CODE     
    
 end    
 else begin    
 SELECT x.COMP_CODE,x.UNIT_CODE,x.PUBL,x.agcd,x.dpcd,ISNULL(SUM(ISNULL(x.WEEK_COPY,0)),0)  AS 'WEEK_COPY'                 
 FROM(SELECT a.COMP_CODE,a.UNIT_CODE,a.PUBL,a.agcd,a.dpcd,              
 ISNULL(SUM(a.SUP_COPY),0)  AS 'WEEK_COPY'                  
 FROM CIR_DBKSUP a,CIR_AGMAST B  WHERE    
 A.COMP_CODE=B.COMP_CODE and  a.comp_code=@pcomp_code and      
 A.UNIT_CODE=B.UNIT and a.unit_code=@punit_code        
 and A.AGCD  = B.AGCD  and   A.DPCD  = B.DPCD           
 and a.supdate   between @VFRDT and @VTODT        
 and (a.agcd = isnull(@PAGCODE,a.agcd) OR @PAGCODE='')       
 and (a.dpcd = isnull(@PDPCODE,a.dpcd) OR @PDPCODE='')     
 and (B.STATE_CODE=isnull(@PSTATECD,B.STATE_CODE) OR @PSTATECD='')     
 and (B.DIST_CODE=isnull(@PDISTCODE,B.DIST_CODE) OR @PDISTCODE='')      
 AND (B.CITY_CODE=isnull(@PCITYCD,B.CITY_CODE) OR @PCITYCD='')    
 and (B.BRANCH_CODE=isnull(@PBRANCH,B.DIST_CODE) OR @PBRANCH='')     
 and (B.AG_TYPE=isnull(@PAGTYPE,B.AG_TYPE) OR @PAGTYPE='')     
 and DATENAME(DW,SUPDATE ) != 'SUNDAY'            
 GROUP BY A.COMP_CODE,A.UNIT_CODE,A.PUBL,A.agcd,A.dpcd)X              
 group by x.COMP_CODE,x.UNIT_CODE,x.PUBL,x.agcd,x.dpcd      
 ORDER BY x.COMP_CODE,x.UNIT_CODE,x.PUBL,x.agcd,x.dpcd         
  end    
       
        
      
       
SELECT ISNULL(SUM(ISNULL(A.SUP_COPY,0)),0)  AS 'SUN_COPY_TOT'  ,COUNT(DISTINCT A.SUPDATE ) AS SUNDAY,       
ROUND(ISNULL(SUM(ISNULL(A.SUP_COPY,0)),0)/COUNT(DISTINCT A.SUPDATE ),0) AS SUN_COPY_TOT_PER      
  FROM CIR_DBKSUP a,CIR_AGMAST B  WHERE    
 A.COMP_CODE=B.COMP_CODE and  a.comp_code=@pcomp_code and      
 A.UNIT_CODE=B.UNIT and a.unit_code=@punit_code        
 and A.AGCD  = B.AGCD  and   A.DPCD  = B.DPCD           
 and a.supdate   between @VFRDT and @VTODT        
 and (a.agcd = isnull(@PAGCODE,a.agcd) OR @PAGCODE='')       
 and (a.dpcd = isnull(@PDPCODE,a.dpcd) OR @PDPCODE='')     
 and (B.STATE_CODE=isnull(@PSTATECD,B.STATE_CODE) OR @PSTATECD='')     
 and (B.DIST_CODE=isnull(@PDISTCODE,B.DIST_CODE) OR @PDISTCODE='')      
 AND (B.CITY_CODE=isnull(@PCITYCD,B.CITY_CODE) OR @PCITYCD='')    
 and (B.BRANCH_CODE=isnull(@PBRANCH,B.DIST_CODE) OR @PBRANCH='')     
 and (B.AG_TYPE=isnull(@PAGTYPE,B.AG_TYPE) OR @PAGTYPE='')    
 and DATENAME(DW,SUPDATE ) = 'SUNDAY'            
            
       
      
      
SELECT               
 ISNULL(SUM(ISNULL(A.SUP_COPY,0)),0)  as   'WEEK_COPY_TOT' ,COUNT(DISTINCT A.SUPDATE ) AS WEEK_DAY ,      
 ROUND(ISNULL(SUM(ISNULL(A.SUP_COPY,0)),0) /COUNT(DISTINCT A.SUPDATE ),0) WEEK_COPY_TOT_PER         
  FROM CIR_DBKSUP a,CIR_AGMAST B  WHERE    
 A.COMP_CODE=B.COMP_CODE and  a.comp_code=@pcomp_code and      
 A.UNIT_CODE=B.UNIT and a.unit_code=@punit_code        
 and A.AGCD  = B.AGCD  and   A.DPCD  = B.DPCD           
 and a.supdate   between @VFRDT and @VTODT        
 and (a.agcd = isnull(@PAGCODE,a.agcd) OR @PAGCODE='')       
 and (a.dpcd = isnull(@PDPCODE,a.dpcd) OR @PDPCODE='')     
 and (B.STATE_CODE=isnull(@PSTATECD,B.STATE_CODE) OR @PSTATECD='')     
 and (B.DIST_CODE=isnull(@PDISTCODE,B.DIST_CODE) OR @PDISTCODE='')      
 AND (B.CITY_CODE=isnull(@PCITYCD,B.CITY_CODE) OR @PCITYCD='')    
 and (B.BRANCH_CODE=isnull(@PBRANCH,B.DIST_CODE) OR @PBRANCH='')     
 and (B.AG_TYPE=isnull(@PAGTYPE,B.AG_TYPE) OR @PAGTYPE='')    
 and DATENAME(DW,SUPDATE ) != 'SUNDAY'            
                   
      
SELECT SUM( ISNULL(A.apr_late_recpt, 0) + ISNULL(A.apr_short_recpt, 0)       
+ ISNULL(A.apr_bnr, 0) + ISNULL(A.apr_unsold, 0)) AS 'SUN_RET_COPY_TOT',COUNT(DISTINCT A.SUPDATE ) AS SUN_DAY ,      
ROUND(SUM( ISNULL(A.apr_late_recpt, 0) + ISNULL(A.apr_short_recpt, 0)       
+ ISNULL(A.apr_bnr, 0) + ISNULL(A.apr_unsold, 0)) /COUNT(DISTINCT A.SUPDATE ),0) AS SUN_RET_COPY_TOT_PER                 
FROM cir_unsold_dtl A,CIR_AGMAST B  WHERE    
 A.COMP_CODE=B.COMP_CODE and  a.comp_code=@pcomp_code and      
 A.UNIT_CODE=B.UNIT and a.unit_code=@punit_code        
 and A.AGCD  = B.AGCD  and   A.DPCD  = B.DPCD           
 and a.supdate   between @VFRDT and @VTODT        
 and (a.agcd = isnull(@PAGCODE,a.agcd) OR @PAGCODE='')       
 and (a.dpcd = isnull(@PDPCODE,a.dpcd) OR @PDPCODE='')     
 and (B.STATE_CODE=isnull(@PSTATECD,B.STATE_CODE) OR @PSTATECD='')     
 and (B.DIST_CODE=isnull(@PDISTCODE,B.DIST_CODE) OR @PDISTCODE='')      
 AND (B.CITY_CODE=isnull(@PCITYCD,B.CITY_CODE) OR @PCITYCD='')    
 and (B.BRANCH_CODE=isnull(@PBRANCH,B.DIST_CODE) OR @PBRANCH='')     
 and (B.AG_TYPE=isnull(@PAGTYPE,B.AG_TYPE) OR @PAGTYPE='')    
 and DATENAME(DW,SUPDATE ) = 'SUNDAY'           
      
      
SELECT SUM( ISNULL(A.apr_late_recpt, 0) + ISNULL(A.apr_short_recpt, 0)       
+ ISNULL(A.apr_bnr, 0) + ISNULL(A.apr_unsold, 0)) AS 'WEEK_RET_COPY_TOT' ,COUNT(DISTINCT A.SUPDATE ) AS WEEY_DAY ,      
ROUND(SUM( ISNULL(A.apr_late_recpt, 0) + ISNULL(A.apr_short_recpt, 0)       
+ ISNULL(A.apr_bnr, 0) + ISNULL(A.apr_unsold, 0)) /COUNT(DISTINCT A.SUPDATE ),0) AS WEEK_RET_COPY_PER           
FROM cir_unsold_dtl A,CIR_AGMAST B  WHERE    
 A.COMP_CODE=B.COMP_CODE and  a.comp_code=@pcomp_code and      
 A.UNIT_CODE=B.UNIT and a.unit_code=@punit_code        
 and A.AGCD  = B.AGCD  and   A.DPCD  = B.DPCD           
 and a.supdate   between @VFRDT and @VTODT        
 and (a.agcd = isnull(@PAGCODE,a.agcd) OR @PAGCODE='')       
 and (a.dpcd = isnull(@PDPCODE,a.dpcd) OR @PDPCODE='')     
 and (B.STATE_CODE=isnull(@PSTATECD,B.STATE_CODE) OR @PSTATECD='')     
 and (B.DIST_CODE=isnull(@PDISTCODE,B.DIST_CODE) OR @PDISTCODE='')      
 AND (B.CITY_CODE=isnull(@PCITYCD,B.CITY_CODE) OR @PCITYCD='')    
 and (B.BRANCH_CODE=isnull(@PBRANCH,B.DIST_CODE) OR @PBRANCH='')     
 and (B.AG_TYPE=isnull(@PAGTYPE,B.AG_TYPE) OR @PAGTYPE='')    
 and DATENAME(DW,SUPDATE ) != 'SUNDAY'               
      
      
END      
      
