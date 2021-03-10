
/******************************************Code sent by Luxman on 8/9/2011 *******************************/
CREATE procedure CIR_RECEIPT_DATA_MOVE
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
              cancel_remark,userid,creation_datetime,branch_code,prov_rec_no,prov_rec_dt,remark_oth)
          select comp_code,unit_code,doctype,agcd,dpcd,recptno,
          recptdt,chno,chdt,chbank,amount,oth_amount,ccdp,ccds,rcdp,rcds,ocdp,ocds,reason,
          remark,achd,voucherno,voucherdt,vchtype,publ,received_from,tdsrate,tdsamt,staxrate,
          staxamt,status,ref_recptno,ref_recptdt,ref_amount,ref_doctype,cancel_user,cancel_date,
          cancel_remark,userid,creation_date,branch_code,prov_rec_no,prov_rec_dt,remark_oth from cir_rcphdr_dis_temp
            where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
                    recptno=@precptno and recptdt=@v_dt
      
          insert into cir_rcpdet_dis(comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, recptno, recptdt, 
                            payfor, achd, publ, chno, chbnk, chdt, amount, reason, remark, voucherno, voucherdt, 
                            tds, stax, status, usrid, creation_datetime, branch_code)
          select comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, recptno, recptdt, 
                            payfor, achd, publ, chno, chbnk, chdt, amount, reason, remark, voucherno, voucherdt, 
                            tds, stax, status, usrid, creation_date, branch_code from cir_rcpdet_dis_temp
            where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and 
                    recptno=@precptno and recptdt=@v_dt

        insert into cir_outmast_dis (comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, recptno, recptdt, 
                        achd, publ, chno, chbnk, chdt, amount, reason, remark, voucherno, voucherdt, balance, 
                        tds, stax, status, cancel_userid, cancel_dt, cancel_remark, usrid, creation_datetime, bill_sec_amt, branch_code)
        select comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, recptno, recptdt, 
                        achd, publ, chno, chbnk, chdt, amount, reason, remark, voucherno, voucherdt, balance, 
                        tds, stax, status, cancel_userid, cancel_dt, cancel_remark, usrid, creation_date, bill_sec_amt, branch_code from cir_outmast_dis_temp
             where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and 
                    recptno=@precptno and recptdt=@v_dt
		End
    else Begin
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
            where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
                    recptno=@precptno and recptdt=@v_dt
      
          insert into cir_rcpdet(comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, recptno, recptdt, 
                            payfor, achd, publ, chno, chbnk, chdt, amount, reason, remark, voucherno, voucherdt, 
                            tds, stax, status, usrid, creation_date, branch_code)
          select comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, recptno, recptdt, 
                            payfor, achd, publ, chno, chbnk, chdt, amount, reason, remark, voucherno, voucherdt, 
                            tds, stax, status, usrid, creation_date, branch_code from cir_rcpdet_temp
            where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and 
                    recptno=@precptno and recptdt=@v_dt

        insert into cir_outmast (comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, recptno, recptdt, 
                        achd, publ, chno, chbnk, chdt, amount, reason, remark, voucherno, voucherdt, balance, 
                        tds, stax, status, cancel_userid, cancel_dt, cancel_remark, usrid, creation_date, bill_sec_amt, branch_code)
        select comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, recptno, recptdt, 
                        achd, publ, chno, chbnk, chdt, amount, reason, remark, voucherno, voucherdt, balance, 
                        tds, stax, status, cancel_userid, cancel_dt, cancel_remark, usrid, creation_date, bill_sec_amt, branch_code from cir_outmast_temp
             where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and 
                    recptno=@precptno and recptdt=@v_dt
    end           
    
    if upper(@prectype)='D' Begin
        select @v_recno=count(*) from cir_rcphdr_dis 
            where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
                recptno=@precptno and recptdt=@v_dt
		End
    else Begin
        select @v_recno=count(*) from cir_rcphdr 
            where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
                recptno=@precptno and recptdt=@v_dt
    End

    if isnull(@v_recno,0)>0 Begin
        select @v_recno as "RECNO"
		End
     else Begin
        select 0 as "RECNO"
     End

end

/******************************************Code sent by Luxman on 8/9/2011 *******************************/




/******************laxman sir  16-sept*****************************************/
                                                                     
     ------------------------sa                                                                
                                                                            
                                                                     
                                                                     
                                             
ALTER PROCEDURE CIR_SUPPLY_POST_FOR_NEXT_DAY_cir_supply_posting_resale_p
	@pcomp_code		VARCHAR(20) ,
	@punit_code     VARCHAR(20) ,
	@ppubl_code     VARCHAR(20) ,
	@pedtn_code     VARCHAR(20) ,
	@pagcd          VARCHAR(20) ,
	@pdpcd          VARCHAR(20) ,
	@puserid        VARCHAR(20) ,
	@psup_date      DATETIME ,
	@psup_ty        VARCHAR(20) ,
	@pissue_date    DATETIME ,--from preiodical issue master---
	@pdateformat    VARCHAR(20) ,
	@pextra1        varchar(2000),--for supply type code
	@pextra2        varchar(2000),--for supply copy
	@pextra3        varchar(2000),--for login branch code
	@pextra4        varchar(2000),
	@pextra5        varchar(2000)
AS 
    DECLARE  @vsup_date     DATETIME
    DECLARE  @vedtn1        VARCHAR(500)
    DECLARE  @vedtn_name1   VARCHAR(500)

       DECLARE cir_edtn_cur cursor LOCAL FOR 
                    select distinct edtn,edtn_name from cir_edtn_mast
                    where comp_code=@pcomp_code and publ = @ppubl_code and
                    (edtn = @pedtn_code or @pedtn_code is null or @pedtn_code='') and
                     ISNULL(freeze_flag,'N')='N'
 
    DECLARE  @vunit1			VARCHAR(500)
    DECLARE  @vagcd1			VARCHAR(500)
    DECLARE  @vdpcd1			VARCHAR(500)
    DECLARE  @vpubl1			VARCHAR(500)
    DECLARE  @vedtn11			VARCHAR(500)
    DECLARE  @vsupply_type_code1    VARCHAR(500)
    DECLARE  @vbase_supply1		VARCHAR(500)
    DECLARE  @vsupply_sun1		VARCHAR(500)
    DECLARE  @vsupply_mon1		VARCHAR(500)
    DECLARE  @vsupply_tue1		VARCHAR(500)
    DECLARE  @vsupply_wed1		VARCHAR(500)
    DECLARE  @vsupply_thu1		VARCHAR(500)
    DECLARE  @vsupply_fri1		VARCHAR(500)
    DECLARE  @vsupply_sat1		VARCHAR(500)
    DECLARE  @vsupply_spl11		VARCHAR(500)
    DECLARE  @vsupply_spl21		VARCHAR(500)
    DECLARE  @vag_type1			VARCHAR(500)
    DECLARE  @vsupply_start_dt1 VARCHAR(500)
    DECLARE  @vsuspend_date1    VARCHAR(500)
    DECLARE  @vpacket_size1		VARCHAR(500)
    DECLARE  @vcomm_code1		VARCHAR(500)
    DECLARE  @vcomm_flag1		VARCHAR(500)
    DECLARE  @vbill_agcd1		VARCHAR(500)
    DECLARE  @vroute_code1		VARCHAR(500)
    DECLARE  @vsubroute_code1   VARCHAR(500)
    DECLARE  @vsub_subroute_code1    VARCHAR(500)
    DECLARE  @vsurch_cd1		VARCHAR(500)

    DECLARE  @vbill_dpcd1		VARCHAR(500)
	DECLARE  @v_sup_copy		NUMERIC(7)
	DECLARE  @v_edtn_rate		NUMERIC(10,4)
	DECLARE  @vreccnt			NUMERIC(5,0)    


	SET  @vsup_date = @psup_date
	open cir_edtn_cur
	fetch NEXT FROM cir_edtn_cur into @vedtn1 , @vedtn_name1
	
	WHILE @@FETCH_STATUS = 0
	BEGIN

		delete from cir_dbksup_resale where comp_code=@pcomp_code and unit_code=@punit_code and
		publ=@ppubl_code and edtn=@vedtn1 and supdate=@psup_date and 
		(agcd=@pagcd or @pagcd is null or @pagcd='') and (dpcd=@pdpcd or @pdpcd is null or @pdpcd='')
	            
		begin
			select @v_edtn_rate=isnull(issue_price,0) from cir_priodical_issue_mast 
				where comp_code=@pcomp_code and unit_code=@punit_code and publ_code=@ppubl_code and 
					edtn_code=@vedtn1 and issue_date=@pissue_date
		end

		if (@v_edtn_rate=0)
		begin
			print('Please Check,The Rate Today Is not Define for '+' '+  @vedtn_name1)
		end 
	
		DECLARE  cur_supply cursor LOCAL FOR 
			select a.unit unit,a.agcd agcd,a.dpcd dpcd,a.publ publ,a.edtn edtn,a.supply_type_code supply_type_code,a.base_supply base_supply,a.supply_sun supply_sun,
			  a.supply_mon supply_mon,a.supply_tue supply_tue,a.supply_wed supply_wed,
			  a.supply_thu supply_thu,a.supply_fri supply_fri,a.supply_sat supply_sat,
			  b.ag_type ag_type,b.supply_start_dt    supply_start_dt,b.suspend_date suspend_date, ISNULL(a.packet_size,0) packet_size,
			  a.comm_code comm_code,a.comm_flag comm_flag,b.bill_agcd bill_agcd,b.bill_dpcd bill_dpcd,
			  a.route_code route_code,a.subroute_code subroute_code,a.sub_subroute_code sub_subroute_code,
			  a.surch_cd surch_cd
			  from cir_supply a,cir_agmast b
			  where a.comp_code=b.comp_code and a.comp_code=@pcomp_code and a.unit=b.unit and a.unit=@punit_code and 
				a.agcd=b.agcd and a.dpcd=b.dpcd and (a.agcd=@pagcd or @pagcd is null) 
				and (a.dpcd=@pdpcd or @pdpcd is null) and 
				a.publ=@ppubl_code and ISNULL(base_supply,0)>0 and
				a.edtn=@vedtn1 and
				ISNULL(a.supply_flag,'N')='Y' and ISNULL(b.suspend,'N')='N'
				order by a.agcd,a.dpcd,a.edtn,a.supply_type_code

		open cur_supply 
		fetch next from cur_supply into @vunit1 ,@vagcd1 ,@vdpcd1 ,@vpubl1 ,@vedtn11 ,@vsupply_type_code1,@vbase_supply1,
			@vsupply_sun1 ,@vsupply_mon1 ,@vsupply_tue1 ,@vsupply_wed1 ,@vsupply_thu1 ,@vsupply_fri1,@vsupply_sat1 ,
			@vag_type1 ,@vsupply_start_dt1, @vsuspend_date1 ,@vpacket_size1 ,@vcomm_code1 ,@vcomm_flag1 ,@vbill_agcd1 ,@vbill_dpcd1,
			@vroute_code1 ,@vsubroute_code1 ,@vsub_subroute_code1 ,@vsurch_cd1 
        WHILE @@FETCH_STATUS = 0
        Begin
        
			if (@vsup_date>=@vsupply_start_dt1 or @vsupply_start_dt1 is null) and (@vsup_date<=@vsuspend_date1 or @vsuspend_date1 is null) 
			Begin 
				set @v_sup_copy=@pextra2
				if ISNULL(@v_sup_copy,0)>0 
				Begin
					 insert into cir_dbksup_resale (comp_code,unit_code,publ,edtn,agcd,dpcd,supdate,sup_type_code,sup_copy,agency_ty_code,
							agency_pkt_size,comm_code,comm_fix_auto_spl,sup_rate,billagcd,billdpcd,
							route_code,subroute_code,subsubroute_code,userid,surch_cd,issue_date,return_copy_sale,RESALE_BRANCH)
					 values (@pcomp_code,@punit_code,@ppubl_code,@vedtn11,@vagcd1,@vdpcd1,@vsup_date,
							 @vsupply_type_code1,
							 @v_sup_copy,@vag_type1,@vpacket_size1,@vcomm_code1,@vcomm_flag1,
							 @v_edtn_rate,@vbill_agcd1,@vbill_dpcd1,@vroute_code1,
							 @vsubroute_code1,@vsub_subroute_code1,@puserid,@vsurch_cd1,@pissue_date,'Y',@pextra3);

							 select @vreccnt    = count(*)  from cir_dbksup_resale where comp_code=@pcomp_code and unit_code=@punit_code and 
							 publ=@ppubl_code and edtn=@vedtn1 and supdate=@vsup_date and (agcd=@pagcd or @pagcd is null) and (dpcd=@pdpcd or @pdpcd is null);
	                                   
				End
			End 
		fetch next from cur_supply into @vunit1 ,@vagcd1 ,@vdpcd1 ,@vpubl1 ,@vedtn11 ,@vsupply_type_code1,@vbase_supply1,
			@vsupply_sun1 ,@vsupply_mon1 ,@vsupply_tue1 ,@vsupply_wed1 ,@vsupply_thu1 ,@vsupply_fri1,@vsupply_sat1 ,
			@vag_type1 ,@vsupply_start_dt1, @vsuspend_date1 ,@vpacket_size1 ,@vcomm_code1 ,@vcomm_flag1 ,@vbill_agcd1 ,@vbill_dpcd1,
			@vroute_code1 ,@vsubroute_code1 ,@vsub_subroute_code1 ,@vsurch_cd1 
		End 
		close cur_supply;
	fetch NEXT FROM cir_edtn_cur into @vedtn1 , @vedtn_name1
	set  @v_edtn_rate = 0    set  @vedtn1=NULL
end
close cir_edtn_cur   

select case b.bill_pay
              when 'Y' then 'PAID'
              when 'N' then 'UNPAID'
              else  'UNPAID' 
              end  BILL_PAY,sum(a.sup_copy) SUP_COPY
from cir_dbksup_resale a,cir_supply_type_mast b
where a.comp_code=@pcomp_code and a.comp_code=b.comp_code and a.unit_code=@punit_code and 
      a.publ=@ppubl_code and (a.edtn=@pedtn_code or @pedtn_code is null or @pedtn_code='') and 
      a.sup_type_code=b.sup_ty_code and a.supdate=@vsup_date and 
      (a.agcd=@pagcd or @pagcd is null or @pagcd='') and (a.dpcd=@pdpcd or @pdpcd is null or @pdpcd='')
group by b.bill_pay
order by b.bill_pay desc
  
deallocate cir_edtn_cur
deallocate cur_supply

                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE cir_supply_populate_p
    @pcomp_code                               VARCHAR(20) ,
    @punit                                    VARCHAR(20) ,
    @pagcd                                    VARCHAR(20) ,
    @pdpcd                                    VARCHAR(20) ,
    @ppubl                                    VARCHAR(20) ,
    @pedtn                                    VARCHAR(20) ,
    @pdateformat                              VARCHAR(20) ,
    @pextra1                                  VARCHAR(4000) ,
    @pextra2                                  VARCHAR(4000) 
AS 
Begin
	if upper(@pextra2)='D' Begin
         select SUPPLY_TYPE_CODE,DBO.CIR_GET_SUPPLY_NAME(COMP_CODE,SUPPLY_TYPE_CODE) SUPPLY_TYPE_NAME,BASE_SUPPLY,SUPPLY_SUN,SUPPLY_MON,SUPPLY_TUE,
                SUPPLY_WED,SUPPLY_THU,SUPPLY_FRI,SUPPLY_SAT,SUPPLY_SPL1,SUPPLY_SPL2,SUPPLY_FLAG,BASE_SUPPLY,PACKET_SIZE,COMM_CODE,COMM_FLAG,
                LBL_PRINTNO SUPPLY_SEQ,ROUTE_CODE,DBO.CIR_GET_NAME_CIR_ROUTE(COMP_CODE,UNIT,ROUTE_CODE,1,@PDATEFORMAT,'','') ROUTE_NAME, 
                SUBROUTE_CODE ,DBO.CIR_GET_NAME_CIR_SUBROUTE(COMP_CODE,UNIT,ROUTE_CODE,SUBROUTE_CODE,1,@PDATEFORMAT,'','') SUBROUTE_NAME,
                SUB_SUBROUTE_CODE,DBO.CIR_GET_NAME_CIR_SUBSUBROUTE(COMP_CODE,UNIT,ROUTE_CODE,SUBROUTE_CODE,SUB_SUBROUTE_CODE,1,@PDATEFORMAT,'','') SUBSUBROUTE_NAME
                from cir_supply_dis
              where comp_code=@pcomp_code and unit=@punit and agcd=@pagcd and dpcd=@pdpcd and publ=@ppubl and edtn=@pedtn
              order by supply_type_name
		End
    else Begin
         select SUPPLY_TYPE_CODE,DBO.CIR_GET_SUPPLY_NAME(COMP_CODE,SUPPLY_TYPE_CODE) SUPPLY_TYPE_NAME,BASE_SUPPLY,SUPPLY_SUN,SUPPLY_MON,SUPPLY_TUE,
                SUPPLY_WED,SUPPLY_THU,SUPPLY_FRI,SUPPLY_SAT,SUPPLY_SPL1,SUPPLY_SPL2,SUPPLY_FLAG,BASE_SUPPLY,PACKET_SIZE,COMM_CODE,COMM_FLAG,
                LBL_PRINTNO SUPPLY_SEQ,ROUTE_CODE,DBO.CIR_GET_NAME_CIR_ROUTE(COMP_CODE,UNIT,ROUTE_CODE,1,@PDATEFORMAT,'','') ROUTE_NAME, 
                SUBROUTE_CODE ,DBO.CIR_GET_NAME_CIR_SUBROUTE(COMP_CODE,UNIT,ROUTE_CODE,SUBROUTE_CODE,1,@PDATEFORMAT,'','') SUBROUTE_NAME,
                SUB_SUBROUTE_CODE,DBO.CIR_GET_NAME_CIR_SUBSUBROUTE(COMP_CODE,UNIT,ROUTE_CODE,SUBROUTE_CODE,SUB_SUBROUTE_CODE,1,@PDATEFORMAT,'','') SUBSUBROUTE_NAME
                from cir_supply
              where comp_code=@pcomp_code and unit=@punit and agcd=@pagcd and dpcd=@pdpcd and publ=@ppubl and edtn=@pedtn
              order by supply_type_name
	End
End

                                                                     
                                                                     
                                                                     
                                             
ALTER FUNCTION cir_get_commission
(	@pcomp_code			VARCHAR(40) ,
	@punit_code         VARCHAR(40) ,
	@ppubl_cd           VARCHAR(40) ,
	@pedtn_cd           VARCHAR(40) ,
	@pcomm_ty           VARCHAR(40) ,
	@pcomm_catg_cd      VARCHAR(40) ,
	@pvaild_from        DATETIME,
	@pdateformat        VARCHAR(40) ,
	@pavg_copy          NUMERIC(20,0),
	@pextra1            VARCHAR(40) ,
	@pextra2            VARCHAR(40))
RETURNS VARCHAR(100) AS 
BEGIN
	declare @v_comp_code1			VARCHAR(20)
	declare @v_unit_code1			VARCHAR(20)
	declare @v_publ1				VARCHAR(20)
	declare @v_edtn1				VARCHAR(20)
	declare @v_comm_code1			VARCHAR(20)
	declare @v_comm_type1			VARCHAR(20)
	declare @v_valid_form1			DATETIME
	declare @v_sup_copy_from1		NUMERIC(20,0)
	declare @v_sup_copy_to1			NUMERIC(20,0)
	declare @v_sun_comm_rate1		NUMERIC(20,4)
	declare @v_mon_comm_rate1		NUMERIC(20,4)
	declare @v_tue_comm_rate1		NUMERIC(20,4)
	declare @v_wed_comm_rate1		NUMERIC(20,4)
	declare @v_thu_comm_rate1		NUMERIC(20,4)
	declare @v_fri_comm_rate1		NUMERIC(20,4)
	declare @v_sat_comm_rate1		NUMERIC(20,4)
	declare @v_userid1				VARCHAR(20)
	declare @v_freezeflag1			VARCHAR(20)
	declare @v_creation_date1		DATETIME
	declare @v_comm_catg_code1		VARCHAR(20)
	declare @v_comm_catg_type1		VARCHAR(20)

	DECLARE comm_fix_spl cursor LOCAL FOR 
	SELECT comp_code, unit_code, publ, edtn, comm_code, comm_type, valid_from, sup_copy_from, sup_copy_to, sun_comm_rate, mon_comm_rate, tue_comm_rate, wed_comm_rate, thu_comm_rate, fri_comm_rate, sat_comm_rate, 
		userid, freeze_flag, creation_date, comm_catg_code, comm_catg_type
	 FROM  cir_comm_mast 
	WHERE comp_code  = @pcomp_code AND unit_code  = @punit_code AND publ  = @ppubl_cd AND 
		edtn  = @pedtn_cd AND comm_type  = @pcomm_ty AND comm_catg_code  = @pcomm_catg_cd AND 
		valid_from  =(SELECT MAX(valid_from) FROM  cir_comm_mast 
		WHERE comp_code  = @pcomp_code AND	unit_code  = @punit_code AND 
			publ  = @ppubl_cd AND	edtn  = @pedtn_cd AND comm_type  = @pcomm_ty AND 
			comm_catg_code  = @pcomm_catg_cd AND valid_from  <= @pvaild_from)

	DECLARE @rec_comm_fix_spl	VARCHAR(200) 
	DECLARE @vcomm_per          FLOAT                           
	SET @vcomm_per = 0 
	DECLARE @avg_sup            INT 

	declare @v_comp_code2         VARCHAR(20)
	declare @v_unit_code2         VARCHAR(20)
	declare @v_publ2              VARCHAR(20)
	declare @v_edtn2              VARCHAR(20)
	declare @v_comm_code2         VARCHAR(20)
	declare @v_comm_type2         VARCHAR(20)
	declare @v_valid_form2        DATETIME
	declare @v_sup_copy_from2     NUMERIC(20,0)
	declare @v_sup_copy_to2       NUMERIC(20,0)
	declare @v_sun_comm_rate2     NUMERIC(20,4)
	declare @v_mon_comm_rate2     NUMERIC(20,4)
	declare @v_tue_comm_rate2     NUMERIC(20,4)
	declare @v_wed_comm_rate2     NUMERIC(20,4)
	declare @v_thu_comm_rate2     NUMERIC(20,4)
	declare @v_fri_comm_rate2     NUMERIC(20,4)
	declare @v_sat_comm_rate2     NUMERIC(20,4)
	declare @v_userid2            VARCHAR(20)
	declare @v_freezeflag2        VARCHAR(20)
	declare @v_creation_date2     DATETIME
	declare @v_comm_catg_code2    VARCHAR(20)
	declare @v_comm_catg_type2    VARCHAR(20)

	DECLARE comm_auto cursor LOCAL FOR 
	SELECT * FROM  cir_comm_mast 
	WHERE comp_code  = @pcomp_code AND unit_code  = @punit_code
	 AND publ  = @ppubl_cd AND edtn  = @pedtn_cd
	 AND comm_type  = @pcomm_ty AND comm_catg_code  = @pcomm_catg_cd
	 AND valid_from  =( SELECT MAX(valid_from) FROM  cir_comm_mast 
		WHERE comp_code  = @pcomp_code AND unit_code  = @punit_code AND publ  = @ppubl_cd
		 AND edtn  = @pedtn_cd AND comm_type  = @pcomm_ty AND comm_catg_code  = @pcomm_catg_cd
		 AND valid_from  <= @pvaild_from AND @avg_sup  between ISNULL(sup_copy_from, 0)  and  ISNULL(sup_copy_to, 0))
		AND	@avg_sup  between ISNULL(sup_copy_from, 0)  and  ISNULL(sup_copy_to, 0)
		
		DECLARE @rec_comm_auto		VARCHAR(200)
		DECLARE @v_comm             VARCHAR(20) 

		DECLARE @SUP_DAY11  varchar(20)
		SET  @SUP_DAY11 = CONVERT(VARCHAR(20) , DATENAME(WEEKDAY, @pvaild_from),20)
		IF UPPER(@pcomm_ty)= 'A' BEGIN 
			SET @avg_sup  = @pavg_copy 
			IF @avg_sup > 0 BEGIN 

				OPEN comm_auto 
				fetch NEXT FROM comm_auto INTO  @v_comp_code2 ,@v_unit_code2, @v_publ2,@v_edtn2,
                @v_comm_code2,@v_comm_type2,@v_valid_form2,@v_sup_copy_from2 , @v_sup_copy_to2 ,@v_sun_comm_rate2 ,
                @v_mon_comm_rate2, @v_tue_comm_rate2,@v_wed_comm_rate2,@v_thu_comm_rate2, @v_fri_comm_rate2,@v_sat_comm_rate2,
				@v_userid2,@v_freezeflag2 ,@v_creation_date2 ,@v_comm_catg_code2 , @v_comm_catg_type2
			
				IF (@SUP_DAY11 = 'Sunday' ) BEGIN 
					---for sunday commition rate
					SET @vcomm_per  =  @v_sun_comm_rate2
				END
				ELSE IF (@SUP_DAY11 = 'Monday') BEGIN 
					---for monday commition rate
					SET @vcomm_per  =  @v_mon_comm_rate2
				END
				ELSE IF (@SUP_DAY11 = 'Tuesday') BEGIN 
					---for tueday commition rate
					SET @vcomm_per  =  @v_tue_comm_rate2
				END
				ELSE IF (@SUP_DAY11 = 'Wednesday') BEGIN 
					---for wednesday commition rate
					SET @vcomm_per  =   @v_wed_comm_rate2
				END
				ELSE IF (@SUP_DAY11 = 'Thursday') BEGIN 
					---for Thursday commition rate
					SET @vcomm_per  =   @v_thu_comm_rate2
				END
				ELSE IF (@SUP_DAY11 = 'Friday' ) BEGIN 
					---for friday commition rate
					SET @vcomm_per  =   @v_fri_comm_rate2
				END
				ELSE IF (@SUP_DAY11 = 'Saturday') BEGIN 
					---for saturday commition rate
					SET @vcomm_per  =  @v_sat_comm_rate2
				END
				ELSE BEGIN 
					SET @vcomm_per  = 0 
				END
   				close comm_auto
			END
			SET @v_comm  =   @v_comm_catg_type2 + ISNULL(@vcomm_per, 0)
		END
		ELSE BEGIN 
			OPEN comm_fix_spl 
			fetch NEXT FROM comm_fix_spl INTO  @v_comp_code1 ,@v_unit_code1, @v_publ1,@v_edtn1,@v_comm_code1,@v_comm_type1,
                @v_valid_form1, @v_sup_copy_from1 , @v_sup_copy_to1 ,@v_sun_comm_rate1 ,@v_mon_comm_rate1, 
                @v_tue_comm_rate1,
                @v_wed_comm_rate1,@v_thu_comm_rate1,@v_fri_comm_rate1,@v_sat_comm_rate1,@v_userid1,@v_freezeflag1 ,@v_creation_date1 ,
                @v_comm_catg_code1 , @v_comm_catg_type1

				IF (@SUP_DAY11 = 'Sunday' ) BEGIN 
					---for sunday commition rate
					SET @vcomm_per  =  @v_sun_comm_rate1
				END
				ELSE IF (@SUP_DAY11 = 'Monday') BEGIN 
					---for monday commition rate
					SET @vcomm_per  =  @v_mon_comm_rate1
				END
				ELSE IF (@SUP_DAY11 = 'Tuesday') BEGIN
					---for tueday commition rate
					SET @vcomm_per  =  @v_tue_comm_rate1
				END
				ELSE IF (@SUP_DAY11 = 'Wednesday') BEGIN 
					---for wednesday commition rate
					SET @vcomm_per  =   @v_wed_comm_rate1
				END
				ELSE IF (@SUP_DAY11 = 'Thursday') BEGIN 
					---for Thursday commition rate
					SET @vcomm_per  =   @v_thu_comm_rate1
				END
				ELSE IF (@SUP_DAY11 = 'Friday' ) BEGIN 
					---for friday commition rate
					SET @vcomm_per  =   @v_fri_comm_rate1
				END
				ELSE IF (@SUP_DAY11 = 'Saturday') BEGIN 
					---for saturday commition rate
					SET @vcomm_per  =  @v_sat_comm_rate1
				END
				ELSE BEGIN 
					SET @vcomm_per  = 0 
				END
			close comm_fix_spl
			SET @v_comm  =   @v_comm_catg_type1 + CONVERT(VARCHAR(20),ISNULL(@vcomm_per, 0))
		END
	DEALLOCATE comm_auto      
	DEALLOCATE comm_fix_spl

	return isnull(@v_comm,0)
END


                                                                     
    /***************************4603*********************************/                                                                 
                                                                     
                                             
ALTER procedure advt_tally_xml
    @pcompcode       as varchar(20),
    @ppcenter        as varchar(20),
    @pbrancode       as varchar(20),
    @pdoctype        as varchar(20),
    @ppaymode        as varchar(20),
    @pfromdate       as datetime,
    @ptodate         as datetime,
    @pagency         as varchar(50),
    @pdateformate    as varchar(20),
    @prcpt_type      as varchar(50),--ADB for ad recept and CIR for circulation recpt
    @pagname_code    as varchar(50),--Agency name or Code(A/C)
    @pfreq_type      as varchar(20),--one by  one(1)/Daily(2)/Agency wise(3)/single(4)
    @pagency_head    as varchar(200),--Agency A/c Head
    @pother_head1    as varchar(200),--Other1 A/c Head 
    @pother_head2    as varchar(200),--Other2 A/c Head
    @pactype         as varchar(20),--it is used for a/c type
    @pbran_based_on  as varchar(20),--it is used for branch based on agency master/Transaction(M/T)
    @pextra1         as varchar(200),
    @pextra2         as varchar(200),
    @pextra3         as varchar(200),
    @pextra4         as varchar(200),
    @pextra5         as varchar(200)
as

declare @v_frdt as datetime;
declare @v_todt as datetime;
declare @rec_adb_comp_code			as varchar(20)
declare @rec_adb_pcenter			as varchar(200)
declare @rec_adb_pcenter_name		as varchar(200)
declare @rec_adb_unit				as varchar(20)
declare @rec_adb_branch_name		as varchar(200)
declare @rec_adb_doctype			as varchar(20)
declare @rec_adb_recptno			as varchar(50)
declare @rec_adb_recptdt			as datetime
declare @rec_adb_recptdt1			as varchar(50)
declare @rec_adb_ag_main_code		as varchar(20)
declare @rec_adb_ag_sub_code		as varchar(20)
declare @rec_adb_agency_name		as varchar(200)
declare @rec_adb_amount				as numeric(15,2)
declare @rec_adb_chdt				as datetime
declare @rec_adb_chno				as varchar(50)
declare @rec_adb_bank				as varchar(50)
declare @rec_adb_reason				as varchar(100)	
declare @rec_adb_narration			as varchar(500)
declare @rec_adb_prov_rec_no		as varchar(50)
declare @rec_adb_prov_rec_dt		as datetime
declare @rec_adb_ad_unique_number	as int

    declare cur_adb cursor for
        select x.comp_code as comp_code,c."pub_center" pcenter,d."Pub_Cent_name" pcenter_name, x.unit as unit,c."Branch_Name" as branch_name,x.doctype as doctype,
        x.recptno as recptno,x.recptdt as recptdt,x.recptdt1 as recptdt1,x.ag_main_code as ag_main_code,x.ag_sub_code as ag_sub_code,x.agency_name as agency_name,x.amount amount,
        x.chdt as chdt,x.chno chno,x.bank bank,x."reason" reason,
        x.narration as narration,
        x.prov_rec_no as prov_rec_no,x.prov_rec_dt as prov_rec_dt,x.ad_unique_number as ad_unique_number,trade_discount as trade_discount
        from (select a."comp_code" as comp_code,
        case when @pbran_based_on='M' then isnull(b."Branch_code",a."unit") else a."unit" end as unit,a."doctype" as doctype,
        a."recptno" as recptno,a."recptdt" as recptdt,replace(convert(varchar(10),a.recptdt,102),'.','') as recptdt1,a."ag_main_code" as ag_main_code,a."ag_sub_code" as ag_sub_code,b."Agency_Name" as agency_name,a."amount" amount,
        a."chdt" as chdt,a."chno" chno,a."bank" bank,a."reason",
        case when a."chno" is not null then
            isnull(a."remark",a."roidnum")+' CHNO# '+a."chno"+' CHDT# '+CAST(DAY(a.chdt) AS VARCHAR(2)) + ' ' + DATENAME(MM, a.chdt)+' CHQBANK# '+(select "bankname" from bank_master_collection where "comp_code"=a."comp_code" and "bankcode"=a."bank")+' AGENCY# '+b."Agency_Name"
        else
            isnull(a."remark",a."roidnum")
        end as narration,
        a."prov_rec_no" as prov_rec_no,a."prov_rec_dt" as prov_rec_dt,a.ad_unique_number as ad_unique_number,0 as trade_discount
        from ad_rcpthdr a,agency_mast b
        where a."comp_code"=b."Comp_Code" and a."comp_code"=@pcompcode and a."ag_main_code"=b."Agency_Code" and a."ag_sub_code"=b."SUB_Agency_Code" and 
		(a."ag_main_code"+a."ag_sub_code"=@pagency or @pagency is null or @pagency='') and
        a."doctype"!= 'BILL' and a."doctype"= @pdoctype and a."recptdt" >=@pfromdate and a."recptdt" <=@ptodate and (a."reason"=@ppaymode or @ppaymode is null or @ppaymode='')
        union
        select a.comp_code as comp_code,case when @pbran_based_on='M' then isnull(b."Branch_code",a.unit) else a.unit end as unit, a.doctype as doctype,
        a.billno as recptno,a.billdt as recptdt,replace(convert(varchar(10),a.billdt,102),'.','') as recptdt1,a.ag_main_code as ag_main_code,a.ag_sub_code as ag_sub_code,b."Agency_Name" as agency_name,a.amount amount,
        a.chdt as chdt,a.chno chno,a.bank bank,a.reason,
        case when a.chno is not null then
            isnull(a.remark,a.receipt_no)+' RONO# '+a.chno+' RODT# '+CAST(DAY(a.chdt) AS VARCHAR(2)) + ' ' + DATENAME(MM, a.chdt)
        else
            isnull(a.remark,a.receipt_no)
        end as narration,
        null as prov_rec_no,null as prov_rec_dt,'1' as ad_unique_number,
		(select case when isnull(ad_bills.discount,0)<=0 then 0 else round((ad_bills.gross_amt*ad_bills.discount)/100,0) end as trade_dis 
        from ad_bills where ad_bills.unit=a.unit and ad_bills.bildt=a.billdt and ad_bills.bilno=a.billno) as trade_discount
        from ad_outstand a,agency_mast b
        where a.comp_code=b."Comp_Code" and a.comp_code=@pcompcode and a.ag_main_code=b."Agency_Code" and a.ag_sub_code=b."SUB_Agency_Code" and 
		(a.ag_main_code+a.ag_sub_code=@pagency or @pagency is null or @pagency='') and
        a.doctype= 'BILL' and a.doctype= @pdoctype and a.billdt >=@pfromdate and a.billdt <=@ptodate and (a.reason=@ppaymode or @ppaymode is null or @ppaymode='')) x,branch_mst c,pub_cent_mast d
        where x.unit=c."Branch_Code" and (x.unit=@pbrancode or @pbrancode is null or @pbrancode='') and c."pub_center"=d."Pub_cent_Code" and (c."pub_center"=@ppcenter or @ppcenter is null or @ppcenter='')
        order by comp_code,pcenter,branch_name,recptdt,recptno;
       
	

	declare @rec_cir_comp_code			as varchar(20)
	declare @rec_cir_pcenter			as varchar(200)
	declare @rec_cir_pcenter_name		as varchar(200)
	declare @rec_cir_unit				as varchar(20)
	declare @rec_cir_branch_name		as varchar(200)
	declare @rec_cir_doctype			as varchar(20)
    declare @rec_cir_recptno			as varchar(50)
	declare @rec_cir_recptdt			as datetime
	declare @rec_cir_recptdt1			as varchar(50)
	declare @rec_cir_ag_main_code		as varchar(20)
	declare @rec_cir_ag_sub_code		as varchar(20)
	declare @rec_cir_agency_name		as varchar(200)
	declare @rec_cir_amount				as numeric(15,2)
    declare @rec_cir_chdt				as datetime
	declare @rec_cir_chno				as varchar(50)
	declare @rec_cir_bank				as varchar(50)
	declare @rec_cir_reason				as varchar(100)	
    declare @rec_cir_narration			as varchar(500)
    declare @rec_cir_prov_rec_no		as varchar(50)
	declare @rec_cir_prov_rec_dt		as datetime
	declare @rec_cir_ad_unique_number	as int
    declare @rec_cir_comm_amt			as numeric(15,2)
	declare @rec_adb_trade_discount		as numeric(15,2)
    declare cur_cir cursor for
        select distinct x.comp_code as comp_code,x.pcenter pcenter,x.pcenter_name pcenter_name, x.unit as unit,
        x.branch_name as branch_name,x.doctype as doctype,
        x.recptno as recptno,x.recptdt as recptdt,replace(convert(varchar(10),x.recptdt,102),'.','') as recptdt1,x.ag_main_code as ag_main_code,
        x.ag_sub_code as ag_sub_code,x.agency_name as agency_name,x.amount amount,
        x.chdt as chdt,x.chno chno,x.bank bank,x.reason,
        x.narration narration, x.prov_rec_no as prov_rec_no,x.prov_rec_dt as prov_rec_dt,x.ad_unique_number ad_unique_number,
        x.comm_amt comm_amt from
        (select distinct a.comp_code as comp_code,a.unit_code pcenter,d."Pub_Cent_name" pcenter_name, a.branch_code as unit,
        c."Branch_Name" as branch_name,a.doctype as doctype,
        a.recptno as recptno,a.recptdt as recptdt,replace(convert(varchar(10),a.recptdt,102),'.','') as recptdt1,a.agcd as ag_main_code,a.dpcd as ag_sub_code,b.ag_name as agency_name,a.amount amount,
        a.chdt as chdt,a.chno chno,a.chbank bank,a.reason,
        case when a.chno is not null then
            a.remark+' CHQNO# '+a.chno+' CHQDT# '+CAST(DAY(a.chdt) AS VARCHAR(2)) + ' ' + DATENAME(MM, a.chdt)+' CHQBANK# '+(select bankname from cir_bank_mast where comp_code=a.comp_code and bankcode=a.chbank)+' AGENCY# '+b.ag_name
        else
            a.remark
        end as narration,
        a.prov_rec_no as prov_rec_no,a.prov_rec_dt as prov_rec_dt,a.bkup_sno as ad_unique_number,
        (select sum(comm_amt) from cir_unsold_dtl where comp_code=@pcompcode and unit_code=a.unit_code and doctype= @pdoctype and agcd=a.agcd and dpcd=a.dpcd and 
        process_crdt=a.recptdt and process_crno=a.recptno and (isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))>0 and @pactype='NM') comm_amt
        from cir_rcphdr a,cir_agmast b,branch_mst c,pub_cent_mast d
        where a.comp_code=b.Comp_Code and a.comp_code=@pcompcode and a.unit_code=b.unit and a.agcd=b.agcd and a.dpcd=b.dpcd and 
		(a.agcd+a.dpcd=@pagency or @pagency is null or @pagency='') and
        a.branch_code=c."Branch_Code" and (a.branch_code=@pbrancode or @pbrancode is null or @pbrancode='') and a.unit_code=d."Pub_cent_Code" and (a.unit_code=@ppcenter or @ppcenter is null or @ppcenter='') and
        a.doctype= @pdoctype and a.recptdt >=@pfromdate and a.recptdt <=@ptodate and isnull(a.achd,'NM')=@pactype and  (a.reason in(select reason_name from cir_reason_mst where reason_code=@ppaymode
          union select "Payment_Mode_Name" from payment_mode_mast where "Pay_Mode_Code"=@ppaymode) or @ppaymode is null or @ppaymode='')
        union
        select distinct a.comp_code as comp_code,a.unit_code pcenter,d."Pub_Cent_name" pcenter_name, a.branch_code as unit,
        c."Branch_Name" as branch_name,'BIL' as doctype,
        a.billno as recptno,a.billdt as recptdt,replace(convert(varchar(10),a.billdt,102),'.','') as recptdt1,a.agcd as ag_main_code,a.dpcd as ag_sub_code,b.ag_name as agency_name,a.bill_amount amount,
        null as chdt,null chno,null bank,'BILL' reason,
         a.bill_remark+' BILL COPY# '+a.bill_copy as narration,null as prov_rec_no,null as prov_rec_dt,1 as ad_unique_number,a.comm_amount comm_amt
        from cir_bill a,cir_agmast b,branch_mst c,pub_cent_mast d
        where a.comp_code=b.Comp_Code and a.comp_code=@pcompcode and a.unit_code=b.unit and a.agcd=b.agcd and a.dpcd=b.dpcd and 
		(a.agcd+a.dpcd=@pagency or @pagency is null or @pagency='') and
        a.branch_code=c."Branch_Code" and (a.branch_code=@pbrancode or @pbrancode is null or @pbrancode='') and a.unit_code=d."Pub_cent_Code" and (a.unit_code=@ppcenter or @ppcenter is null or @ppcenter='') and
        @pdoctype= 'BIL' and a.billdt >=@v_frdt and a.billdt <=@v_todt and @pactype='NM') x  
        order by comp_code,pcenter,branch_name,recptdt,recptno;
   
       
       declare @v_rec_count          int
       declare @v_remoteid           varchar(100)
       declare @v_dsign              int
       declare @v_partyledger        varchar(200)
       declare @v_partyledger_amt    numeric(15,2)
       declare @v_ledger1            varchar(200)
       declare @v_ledgeramt1         numeric(15,2)
       declare @v_ledger2            varchar(200)
       declare @v_ledgeramt2         numeric(15,2)
begin
    set @v_frdt=@pfromdate
    set @v_todt=@ptodate
CREATE TABLE #TEMP_AD_RECEIPT_REPORT
(COMP_CODE         VARCHAR(10),
  UNIT_CODE         VARCHAR(10),
  PCENTRE_CODE      VARCHAR(10),
  AGCODE            VARCHAR(50),
  RECPTNO           VARCHAR(50),
  RECPTDT           DATETIME,
  AMOUNT            NUMERIC(14,2)                DEFAULT 0,
  REP_CODE          VARCHAR(20),
  REMARKS           VARCHAR(600),
  CHQNO             VARCHAR(50),
  CHQDT             DATETIME,
  CHQ_BANK          VARCHAR(100),
  REASON            VARCHAR(30),
  BILLNO            VARCHAR(50),
  BILLDT            DATETIME,
  BILLAMT           NUMERIC(14,2)                DEFAULT 0,
  ADJAMT            NUMERIC(14,2)                DEFAULT 0,
  LEFTAMT           NUMERIC(14,2)                DEFAULT 0,
  RET_CODE          VARCHAR(200),
  EXE_CODE          VARCHAR(200),
  DEBIT_HEAD        VARCHAR(200),
  CREDIT_HEAD       VARCHAR(200),
  AG_MAIN_CODE      VARCHAR(20),
  AG_SUB_CODE       VARCHAR(20),
  DOCTYPE           VARCHAR(10),
  REC_SEQNO         INT,
  RECOVARY_DAYS     INT,
  AGNAME            VARCHAR(500),
  AD_RATE           NUMERIC(7,2),
  AD_SIZE           NUMERIC(12,2),
  AD_COLOR          VARCHAR(5),
  AD_SUB_CATEGORY   VARCHAR(200),
  AD_PACKAGE        VARCHAR(500),
  INSDATE           DATETIME,
  CLIENT            VARCHAR(200),
  AD_MAIN_CATEGORY  VARCHAR(200),
  NARR_LINE         INT);

	If @prcpt_type='ADB' Begin
		open cur_adb
        fetch NEXT FROM cur_adb into @rec_adb_comp_code, @rec_adb_pcenter, @rec_adb_pcenter_name	, @rec_adb_unit	, @rec_adb_branch_name, @rec_adb_doctype, @rec_adb_recptno, @rec_adb_recptdt, @rec_adb_recptdt1,
			 @rec_adb_ag_main_code, @rec_adb_ag_sub_code, @rec_adb_agency_name	, @rec_adb_amount , @rec_adb_chdt, @rec_adb_chno, @rec_adb_bank	, @rec_adb_reason,
			 @rec_adb_narration , @rec_adb_prov_rec_no, @rec_adb_prov_rec_dt, @rec_adb_ad_unique_number,@rec_adb_trade_discount
		WHILE (@@FETCH_STATUS = 0)  
		Begin
			set @v_rec_count =isnull(@v_rec_count,0)+1
            set @v_remoteid  =convert(varchar(40),getdate(),102)+convert(varchar(20),@v_rec_count)--'ddmmyyyyhh24miss',
            print('@rec_adb_doctype')print(@rec_adb_doctype)
            select distinct @v_dsign="Dsign"  from fa_docmst where "doc_type"=@rec_adb_doctype
            If @v_dsign=0 Begin
                set @v_dsign=1
            End
			print('@v_dsign')print(@v_dsign)
			If @v_dsign<0 Begin print('xx1')
				If @pagency_head is not null 
				Begin print('xx2')
					set @v_partyledger=@pagency_head
				End
                Else Begin print('xx3')
                    If @pagname_code='C' Begin print('xx4')
                        set @v_partyledger=@rec_adb_ag_main_code+@rec_adb_ag_sub_code
					End
					Else Begin print('xx5')
						set @v_partyledger=@rec_adb_agency_name
					End
				End
                set @v_ledger1        =@pother_head1   
                set @v_partyledger_amt=@v_dsign*@rec_adb_amount
                set @v_ledgeramt1     =@rec_adb_amount
			End
            Else Begin print('xx6')
                if (ISNULL(@pagency_head,'?')<>'?' AND @pagency_head<>'') Begin print('xx7')
                    set @v_partyledger=@pagency_head
				End
				Else Begin print('xx8')
                    if @pagname_code='C' Begin print('xx9')
                        set @v_partyledger=@rec_adb_ag_main_code
					End
                    Else Begin print('xx10')
                        set @v_partyledger=@rec_adb_agency_name
                    End
                End
                set @v_ledger1        =@pother_head1
				print('xx11')print(@rec_adb_trade_discount)print(@pother_head2)
				If isnull(@rec_adb_trade_discount,0)>0 and (ISNULL(@pother_head2,'?')<>'?' AND @pother_head2<>'') Begin--for billing
			        set @v_partyledger_amt=-1*@rec_adb_amount
				    set @v_ledgeramt1     =@rec_adb_amount+@rec_adb_trade_discount
					set @v_ledgeramt2     =-1*@rec_adb_trade_discount
					set @v_ledger2        =@pother_head2
				End
				Else Begin
					set @v_partyledger_amt=-1*@rec_adb_amount
					set @v_ledgeramt1     =@rec_adb_amount
				End
			End
                
            insert into #TEMP_AD_RECEIPT_REPORT
                (ad_main_category,comp_code,unit_code,pcentre_code,agcode,ag_main_code,ag_sub_code ,agname,
                doctype ,recptno,recptdt,amount, remarks ,chqno ,chqdt,chq_bank ,
                reason,debit_head,credit_head,billamt,adjamt ,leftamt,rec_seqno)
            values(@v_remoteid,@rec_adb_comp_code,@rec_adb_unit,@rec_adb_pcenter,@rec_adb_ag_main_code+@rec_adb_ag_sub_code,@rec_adb_ag_main_code,@rec_adb_ag_sub_code,@v_partyledger,
                @rec_adb_doctype,@rec_adb_recptno,@rec_adb_recptdt,@rec_adb_amount,substring(@rec_adb_narration,1,600),@rec_adb_chno,@rec_adb_chdt,@rec_adb_bank,
                @rec_adb_reason,@v_ledger1,@v_ledger2,@v_partyledger_amt,@v_ledgeramt1,@v_ledgeramt2,@v_rec_count);
			set @v_partyledger_amt=0
			set @v_ledgeramt1=0 
			set @v_ledgeramt2=0
			set @v_ledger2=null			
			fetch NEXT FROM cur_adb into @rec_adb_comp_code, @rec_adb_pcenter, @rec_adb_pcenter_name	, @rec_adb_unit	, @rec_adb_branch_name, @rec_adb_doctype, @rec_adb_recptno, @rec_adb_recptdt, @rec_adb_recptdt1,
				@rec_adb_ag_main_code, @rec_adb_ag_sub_code, @rec_adb_agency_name	, @rec_adb_amount , @rec_adb_chdt, @rec_adb_chno, @rec_adb_bank	, @rec_adb_reason,
				@rec_adb_narration , @rec_adb_prov_rec_no, @rec_adb_prov_rec_dt, @rec_adb_ad_unique_number,@rec_adb_trade_discount
        End
        Close cur_adb
		
	End
	deallocate cur_adb
	If @prcpt_type!='ADB' Begin--for circulation
		open cur_cir
        fetch next from cur_cir into @rec_cir_comp_code, @rec_cir_pcenter	, @rec_cir_pcenter_name	, @rec_cir_unit	, @rec_cir_branch_name, @rec_cir_doctype , @rec_cir_recptno	, @rec_cir_recptdt, @rec_cir_recptdt1	, @rec_cir_ag_main_code	, @rec_cir_ag_sub_code	, @rec_cir_agency_name	, @rec_cir_amount , @rec_cir_chdt, @rec_cir_chno	, @rec_cir_bank	, @rec_cir_reason , @rec_cir_narration , @rec_cir_prov_rec_no, @rec_cir_prov_rec_dt, @rec_cir_ad_unique_number , @rec_cir_comm_amt
		WHILE (@@FETCH_STATUS = 0)  
		Begin
			set @v_rec_count =isnull(@v_rec_count,0)+1
			set @v_remoteid  =replace(replace(replace(convert(varchar(40),getdate(),120),'-',''),':',''),' ','')+convert(varchar(20),@v_rec_count)--'ddmmyyyyhh24miss',
        
			select distinct @v_dsign=Dsign from cir_docmst where doc_type=@rec_cir_doctype
			If @v_dsign=0 Begin
				set @v_dsign=1
			End             

			If @v_dsign<0 Begin
				If @pagency_head is not null Begin
					set @v_partyledger=@pagency_head
				End
				Else Begin
					If @pagname_code='C' Begin
						set @v_partyledger=@rec_cir_pcenter+@rec_cir_ag_main_code+'('+@pactype+')'
					End
					Else Begin
						set @v_partyledger=@rec_cir_agency_name+'('+@pactype+')'
					End
				End
                set @v_ledger1        =@pother_head1
				If isnull(@rec_cir_comm_amt,0)>0 Begin--for unsold 
					set @v_partyledger_amt=@v_dsign*@rec_cir_amount
					set @v_ledgeramt1     =(@rec_cir_amount-@rec_cir_comm_amt)
					set @v_ledgeramt2     =@rec_cir_comm_amt
					set @v_ledger2        =@pother_head2
				End
				Else Begin
					set @v_partyledger_amt=@v_dsign*@rec_cir_amount
					set @v_ledgeramt1     =@rec_cir_amount
				End
			End
			Else Begin
				If @pagency_head is not null Begin
					set @v_partyledger=@pagency_head
				End
				Else Begin
					If @pagname_code='C' Begin
						set @v_partyledger=@rec_cir_pcenter+@rec_cir_ag_main_code+'('+@pactype+')'
					End
					Else Begin
						set @v_partyledger=@rec_cir_agency_name+'('+@pactype+')'
					End
				End
				set @v_ledger1            =@pother_head1
		        If isnull(@rec_cir_comm_amt,0)>0 Begin--for billing
			        set @v_partyledger_amt=-1*@rec_cir_amount
				    set @v_ledgeramt1     =@rec_cir_amount+@rec_cir_comm_amt
					set @v_ledgeramt2     =-1*@rec_cir_comm_amt
					set @v_ledger2        =@pother_head2
				End
				Else Begin
					set @v_partyledger_amt=-1*@rec_cir_amount
					set @v_ledgeramt1     =@rec_cir_amount
				End
			End
				insert into #TEMP_AD_RECEIPT_REPORT
					(ad_main_category,comp_code,unit_code,pcentre_code,agcode,ag_main_code,ag_sub_code ,agname,
					doctype ,recptno,recptdt,amount, remarks ,chqno ,chqdt,chq_bank ,   
					reason,debit_head,credit_head,billamt,adjamt ,leftamt,rec_seqno)
				values(@v_remoteid,@rec_cir_comp_code,@rec_cir_unit,@rec_cir_pcenter,@rec_cir_ag_main_code+@rec_cir_ag_sub_code,@rec_cir_ag_main_code,@rec_cir_ag_sub_code,@v_partyledger,
					@rec_cir_doctype,@rec_cir_recptno,@rec_cir_recptdt,@rec_cir_amount,substring(@rec_cir_narration,1,600),@rec_cir_chno,@rec_cir_chdt,@rec_cir_bank,
					@rec_cir_reason,@v_ledger1,@v_ledger2,@v_partyledger_amt,@v_ledgeramt1,@v_ledgeramt2,@v_rec_count)
	        set @v_partyledger_amt=0
			set @v_ledgeramt1=0 
			set @v_ledgeramt2=0
			set @v_ledger2=null
			fetch next from cur_cir into @rec_cir_comp_code, @rec_cir_pcenter	, @rec_cir_pcenter_name	, @rec_cir_unit	, @rec_cir_branch_name, @rec_cir_doctype , @rec_cir_recptno	, @rec_cir_recptdt, @rec_cir_recptdt1	, @rec_cir_ag_main_code	, @rec_cir_ag_sub_code	, @rec_cir_agency_name	, @rec_cir_amount , @rec_cir_chdt, @rec_cir_chno	, @rec_cir_bank	, @rec_cir_reason , @rec_cir_narration , @rec_cir_prov_rec_no, @rec_cir_prov_rec_dt, @rec_cir_ad_unique_number , @rec_cir_comm_amt
		End
        Close cur_cir
		
    End
    deallocate cur_cir
    if @pfreq_type='2' Begin print('xxtype 2')--for daily
        select min(ad_main_category) as ad_unique_number,comp_code as comp_code,null as unit,pcentre_code as pcenter,null as agcode,null as ag_main_code,
            null as ag_sub_code,replace(agname,'&','&amp;') as party_ledger,
            doctype as doctype,min(recptno) as recptno,recptdt as recptdt,replace(convert(varchar(10),recptdt,102),'.','') as recptdt1,sum(amount) as amount, min(replace(remarks,'&','&amp;')) as narration,null as chno,null as chdt,null as bank,   
            null as reason,replace(debit_head,'&','&amp;') as ledger_name1,replace(credit_head,'&','&amp;') as ledger_name2,sum(billamt) as partyledger_amt,sum(adjamt) as v_ledgeramt1,sum(leftamt) as v_ledgeramt2,min(rec_seqno) as rec_seqno 
            from #TEMP_AD_RECEIPT_REPORT 
            group by comp_code,pcentre_code,replace(agname,'&','&amp;'),doctype,recptdt,replace(debit_head,'&','&amp;'),replace(credit_head,'&','&amp;')
            order by recptdt,recptno
		End
    else if @pfreq_type='3' Begin print('xxtype 3')--for agency wise
        select min(ad_main_category) as ad_unique_number,comp_code as comp_code,null as unit,pcentre_code as pcenter,agcode as agcode,ag_main_code as ag_main_code,
            ag_sub_code as ag_sub_code,replace(agname,'&','&amp;') as party_ledger,
            doctype as doctype,min(recptno) as recptno,min(recptdt) as recptdt,replace(convert(varchar(10),min(recptdt),102),'.','') as recptdt1,sum(amount) as amount, min(replace(remarks,'&','&amp;')) as narration,min(chqno) as chno,min(chqdt) as chdt,min(chq_bank) as bank,   
            min(reason) as reason,replace(debit_head,'&','&amp;') as ledger_name1,replace(credit_head,'&','&amp;') as ledger_name2,sum(billamt) as partyledger_amt,sum(adjamt) as v_ledgeramt1,sum(leftamt) as v_ledgeramt2,min(rec_seqno) as rec_seqno 
            from #TEMP_AD_RECEIPT_REPORT 
            group by comp_code,pcentre_code,agcode,ag_main_code,ag_sub_code,replace(agname,'&','&amp;'),doctype,replace(debit_head,'&','&amp;'),replace(credit_head,'&','&amp;')
            order by recptdt,recptno
		End
    else if @pfreq_type='4' Begin print('xxtype 4')--for single
        select min(ad_main_category) as ad_unique_number,comp_code as comp_code,null as unit,pcentre_code as pcenter,null as agcode,null as ag_main_code,
            null as ag_sub_code,min(replace(agname,'&','&amp;')) as party_ledger,
            doctype as doctype,min(recptno) as recptno,min(recptdt) as recptdt,replace(convert(varchar(10),min(recptdt),102),'.','') as recptdt1,sum(amount) as amount, '0' as narration,min(chqno) as chno,min(chqdt) as chdt,min(chq_bank) as bank,   
            min(reason) as reason,min(replace(debit_head,'&','&amp;')) as ledger_name1,min(replace(credit_head,'&','&amp;')) as ledger_name2,sum(billamt) as partyledger_amt,sum(adjamt) as v_ledgeramt1,sum(leftamt) as v_ledgeramt2,min(rec_seqno) as rec_seqno 
            from #TEMP_AD_RECEIPT_REPORT 
            group by comp_code,pcentre_code,doctype
            order by recptdt,recptno
		End
    else--for one by one
		Begin print ('xxtype 5')
        select ad_main_category as ad_unique_number,comp_code as comp_code,unit_code as unit,pcentre_code as pcenter,agcode as agcode,ag_main_code as ag_main_code,
			ag_sub_code as ag_sub_code,replace(agname,'&','&amp;') as party_ledger,
			doctype as doctype,recptno as recptno,recptdt as recptdt,replace(convert(varchar(10),recptdt,102),'.','') as recptdt1,amount as amount, replace(remarks,'&','&amp;') as narration,chqno as chno,chqdt as chdt,chq_bank as bank,   
			reason as reason,replace(debit_head,'&','&amp;') as ledger_name1,replace(credit_head,'&','&amp;') as ledger_name2,billamt as partyledger_amt,adjamt as v_ledgeramt1,leftamt as v_ledgeramt2,rec_seqno as rec_seqno 
			from #TEMP_AD_RECEIPT_REPORT 
			order by rec_seqno
    end
    drop table #TEMP_AD_RECEIPT_REPORT
     
end
/************************************4603******************/
                                                                     
                                                                     
                /********************4689******************/                                                        
                                             
alter PROCEDURE rpt_publwise_billing_summ
    @pcompcode           as varchar(200),
    @pcenter             as varchar(200),
    @pbranchcode         as varchar(200),
    @ppublcode           as varchar(200),
    @padtype             as varchar(200),
    @pcatgcode           as varchar(200),
    @pdatefrom           as datetime,
    @pdateto             as datetime,
    @puserid             as varchar(200),
    @pdateformat         as varchar(200),
    @pextra1             as varchar(200),
    @pextra2             as varchar(200),
    @pextra3             as varchar(200),
    @pextra4             as varchar(200),
    @pextra5             as varchar(200)
AS
        
    declare @v_query             varchar(8000)
    declare @rec_v1_comp_code    varchar(200)
	declare @rec_v1_pcenter	     varchar(200)
	declare @rec_v1_bill_date    datetime
    declare @rec_v1_publ_code    varchar(200)
    declare @rec_v1_publ_name    varchar(200)
    declare @rec_v1_edtn_code    varchar(200)
    declare @rec_v1_edtn_name	 varchar(200)
    declare @rec_v1_amount       numeric(18,2)
    
     declare c1 cursor for
        select x.comp_code comp_code,x.bill_date bill_date,x.publ_code publ_code,x.publ_name publ_name,
        x.edtn_code edtn_code,x.edtn_name edtn_name,isnull(x.amount,0) amount from
        (select m."Comp_code" comp_code,i.bill_date bill_date,
        i."Publication_Code" publ_code,(select pub_mast."Pub_Name" from pub_mast where 
        pub_mast."Pub_Code"=i."Publication_Code") publ_name,i."Edition_Code" edtn_code,
        (select distinct "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=e."City_Code")  edtn_name,
        round(Sum(i."Bill_Amt"),2) amount
        from agency_mast a,tbl_booking_mast m,tbl_booking_insert i,branch_mst b,adv_cat_mast c,edition_mast e
        where m."Comp_code"=i."Comp_Code" and m."Comp_code"=@pcompcode and c."Comp_Code"=m."Comp_code" and e."Comp_Code"=m."Comp_code" and 
        c."Adv_Cat_Code"=i."Ad_Cat" and 
        m."cio_booking_id"=i."Cio_Booking_Id" and a."Agency_Code"+a."SUB_Agency_Code"=m."Agency_sub_code" and 
        i.bill_date between @pdatefrom and @pdateto and (m."Ad_type_code"=@padtype or @padtype is null or @padtype='') and
        (i."Ad_Cat"=@pcatgcode or @pcatgcode is null or @pcatgcode='') and 
        m."branch"=b."Branch_Code" and
        (b."Branch_Code"=@pbranchcode or @pbranchcode is null or @pbranchcode='') and (b."pub_center"=@pcenter or @pcenter is null or @pcenter='') and
        (i."Publication_Code"=@ppublcode or @ppublcode is null or @ppublcode='') and e."Edition_Code"=i."Edition_Code" and i."Bill_Amt">0
        group by m."Comp_code",i.bill_date,i."Publication_Code",i."Edition_Code",e."City_Code" ) x        
        order by comp_code,publ_name,edtn_name,bill_date;

    declare @v_rec_seqno numeric(10)         
    
    declare @v_var       varchar(4000)
    declare @v_var_sum   varchar(4000)
Begin

CREATE TABLE #TEMP_AD_RECEIPT_REPORT
( COMP_CODE         VARCHAR(10),
  UNIT_CODE         VARCHAR(10),
  PCENTRE_CODE      VARCHAR(10),
  AGCODE            VARCHAR(50),
  RECPTNO           VARCHAR(50),
  RECPTDT           DATEtime,
  AMOUNT            float,
  REP_CODE          VARCHAR(20),
  REMARKS           VARCHAR(500),
  CHQNO             VARCHAR(50),
  CHQDT             DATEtime,
  CHQ_BANK          VARCHAR(100),
  REASON            VARCHAR(30),
  BILLNO            VARCHAR(50),
  BILLDT            DATEtime,
  BILLAMT           float,
  ADJAMT            float,
  LEFTAMT           float,
  RET_CODE          VARCHAR(200),
  EXE_CODE          VARCHAR(200),
  SESS_ID           int         ,
  DEBIT_HEAD        VARCHAR(200),
  CREDIT_HEAD       VARCHAR(200),
  AG_MAIN_CODE      VARCHAR(20),
  AG_SUB_CODE       VARCHAR(20),
  DOCTYPE           VARCHAR(10),
  REC_SEQNO         int,
  RECOVARY_DAYS     int,
  AGNAME            VARCHAR(500),
  AD_RATE           float,
  AD_SIZE           float,
  AD_COLOR          VARCHAR(5),
  AD_SUB_CATEGORY   VARCHAR(200),
  AD_PACKAGE        VARCHAR(500),
  INSDATE           DATEtime,
  CLIENT            VARCHAR(200),
  AD_MAIN_CATEGORY  VARCHAR(200),
  RECOVERY_DAYS		VARCHAR(200),
  ADDR				VARCHAR(500))

    open c1
    fetch NEXT FROM C1 INTO @rec_v1_comp_code,@rec_v1_bill_date,@rec_v1_publ_code,@rec_v1_publ_name,@rec_v1_edtn_code,@rec_v1_edtn_name,@rec_v1_amount
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN

        SET @v_rec_seqno=ISNULL(@v_rec_seqno,0)+1
        
        insert into #temp_ad_receipt_report
                (comp_code,pcentre_code,recptdt,exe_code,ad_main_category,ret_code,ad_sub_category,
                amount,rec_seqno)
          values(@rec_v1_comp_code,@rec_v1_pcenter,@rec_v1_bill_date,@rec_v1_publ_code,@rec_v1_publ_name,@rec_v1_edtn_code,@rec_v1_edtn_name,
                @rec_v1_amount,@v_rec_seqno)
    fetch NEXT FROM C1 INTO @rec_v1_comp_code,@rec_v1_bill_date,@rec_v1_publ_code,@rec_v1_publ_name,@rec_v1_edtn_code,@rec_v1_edtn_name,@rec_v1_amount
	End
	close c1
	deallocate c1



    declare c11 cursor for
            select distinct exe_code publ_code, ad_main_category publ_name,ad_sub_category edtn_name from #temp_ad_receipt_report 
			order by publ_name,edtn_name

    open c11
		fetch NEXT FROM C11 INTO @rec_v1_publ_code,@rec_v1_publ_name,@rec_v1_edtn_name
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN
            if @v_var is null or @v_var='' Begin
                set @v_var       ='case when d.exe_code+''#''+d.ad_sub_category='+''''+@rec_v1_publ_code+'#'+@rec_v1_edtn_name+''''+' then d.amount else 0 end "'+@rec_v1_publ_code+'#'+@rec_v1_edtn_name+'"';
                set @v_var_sum   ='round(sum("'+@rec_v1_publ_code+'#'+@rec_v1_edtn_name+'"),2)'+' "'+@rec_v1_publ_code+'#'+@rec_v1_edtn_name+'"'
				End
            else Begin
                set @v_var       =@v_var+','+'case when d.exe_code+''#''+d.ad_sub_category='+''''+@rec_v1_publ_code+'#'+@rec_v1_edtn_name+''''+' then d.amount else 0 end "'+@rec_v1_publ_code+'#'+@rec_v1_edtn_name+'"'
                set @v_var_sum   =@v_var_sum+','+'round(sum("'+@rec_v1_publ_code+'#'+@rec_v1_edtn_name+'"),2)'+' "'+@rec_v1_publ_code+'#'+@rec_v1_edtn_name+'"'
            End 
		fetch NEXT FROM C11 INTO @rec_v1_publ_code,@rec_v1_publ_name,@rec_v1_edtn_name
		End
	close c11
	 
	if @v_var is null or @v_var='' Begin
       set @v_query='select x.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=x.comp_code) COMP_NAME,
		x.bill_date as "BILL_DATE", x.publ_code as "PUBL_CODE",x.publ_name AS "PUBL_NAME",
        x.edtn_name AS "EDTN_NAME",round(sum("AMOUNT"),2) as "TOTOL" from
        (select d.comp_code,d.recptdt bill_date,d.exe_code publ_code,d.ad_main_category publ_name, 
        d.ad_sub_category edtn_name,isnull(d.amount,0) amount from #temp_ad_receipt_report d ) x 
        group by x.comp_code,x.publ_code,x.publ_name,x.edtn_name,x.bill_date order by x.comp_code,x.publ_name,x.publ_code,x.edtn_name,x.bill_date';
		End
    else Begin
       set @v_query='select x.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=x.comp_code) COMP_NAME,x.bill_date as "BILL_DATE", 
        '+@v_var_sum+' ,round(sum("AMOUNT"),2) as "TOTOL" from
        (select d.comp_code,d.recptdt bill_date,d.exe_code publ_code,d.ad_main_category publ_name,d.ad_sub_category edtn_name,
       '+@v_var+',isnull(d.amount,0) amount from #temp_ad_receipt_report d) x 
       group by x.comp_code,x.bill_date order by x.comp_code,x.bill_date';
    End
        
	print(@v_query)
	exec(@v_query)
        
    if @v_var is null or @v_var='' Begin
       set @v_query='select x.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=x.comp_code) COMP_NAME,round(sum("AMOUNT"),2) as "TOTOL" from
        (select d.comp_code,d.recptdt bill_date,d.exe_code publ_code,d.ad_main_category publ_name,d.ad_sub_category edtn_name,
        isnull(d.amount,0) amount from #temp_ad_receipt_report d) x 
        group by x.comp_code order by x.comp_code'
		End
    else Begin
       set @v_query='select x.comp_code as "COMP_CODE",(select "Comp_Name" from comp_mst where "Comp_Code"=x.comp_code) COMP_NAME,
        '+@v_var_sum+' ,round(sum("AMOUNT"),2) as "TOTOL" from
        (select d.comp_code,d.recptdt bill_date,d.exe_code publ_code,d.ad_main_category publ_name,d.ret_code edtn_code,d.ad_sub_category edtn_name,
       '+@v_var+',isnull(d.amount,0) amount from #temp_ad_receipt_report d ) x 
        group by x.comp_code order by x.comp_code';
    End

	print(@v_query)
	exec(@v_query)
	deallocate c11
    drop table #temp_ad_receipt_report
End

 /********************4689******************/  

/******************laxman sir  16-sept*****************************************/
/***** bill register 4822    19-sept*************************************************/
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
              ((upper(a.ag_name) like upper(pextra1)||'%') or (pextra1 is null));

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
        select min(billno) MIN_BILLNO,max(billno) MAX_BILLNO from cir_bill_det
            where comp_code=pcomp_code and unit_code=punit_code and billdt >= v_bill_frdt and billdt<=v_bill_todt and
            agcd=nvl(pbillagcd,agcd) and dpcd=nvl(pbilldpcd,dpcd) and publ=nvl(ppubl,publ) and bill_flag=nvl(pbill_freq,bill_flag);
            
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
      p_accounts12     out t_accounts)
    As
      v_bill_frdt         date;
      v_bill_todt         date;
          v_dt            date;
         v_query1        varchar2(8000);
      v_query2        varchar2(8000);
    cursor cur_bill is
        select distinct comp_code,unit_code,publ,agcd,dpcd,billno,billdt,min(bill_frdt) frdt,max(bill_todt) todt from cir_bill
                where comp_code=pcomp_code and ((unit_code=punit_code) or (punit_code is null)) and billdt between v_bill_frdt and v_bill_todt and
                            bill_flag=pbill_freq and ((billno between pfrom_billno and ptill_billno) or (pfrom_billno is null)) and
                            ((publ=ppubl) or (ppubl is null)) and (agcd=pbillagcd or pbillagcd is null) and
                            (dpcd=pbilldpcd or pbilldpcd is null)
            group by comp_code,unit_code,publ,agcd,dpcd,billno,billdt
            order by comp_code,unit_code,publ,billdt,billno,agcd,dpcd;
rec_bill cur_bill%rowtype;

    cursor cur_dbksup is
        select comp_code,unit_code,publ,edtn,supdate,sup_rate copy_rate,comm_fix_auto_spl,comm_code,sum(sup_copy) supply_copy
        from cir_dbksup
        where comp_code=rec_bill.comp_code and unit_code=rec_bill.unit_code and publ=rec_bill.publ and
              supdate=v_dt and billagcd=rec_bill.agcd and billdpcd=rec_bill.dpcd and
              sup_type_code in(select sup_ty_code from cir_supply_type_mast
              where cir_dbksup.comp_code=cir_supply_type_mast.comp_code and upper(cir_supply_type_mast.bill_pay)='Y')
    group by comp_code,unit_code,publ,edtn,supdate,sup_rate,comm_fix_auto_spl,comm_code
    order by comp_code,unit_code,publ,edtn,supdate;
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
        where a.comp_code=pcomp_code and a.unit=b.unit_code and ((b.unit_code=punit_code) or (punit_code is null)) and b.billdt between v_bill_frdt and v_bill_todt and
                    b.bill_flag=pbill_freq and ((b.billno between pfrom_billno and ptill_billno) or (pfrom_billno is null)) and
                    ((b.publ=ppubl) or (ppubl is null)) and a.agcd=b.agcd and a.dpcd=b.dpcd and
                    (b.agcd=pbillagcd or pbillagcd is null) and (b.dpcd=pbilldpcd or pbilldpcd is null)
        group by b.comp_code,b.unit_code,b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.addr1,a.addr2,a.addr3,
                        cir_get_city(b.comp_code,a.city_code),b.billno,b.billdt
        order by b.comp_code,b.unit_code,b.billdt,b.billno,b.agcd,b.dpcd;

        open p_accounts1 for 
        select comp_code,unit_code,billno,billdt,agcd,dpcd,supdate,supply_rate copy_rate,sum(supply_copy) supply from 
        (select u.comp_code comp_code,u.unit_code unit_code,u.billno billno,u.billdt billdt,u.agcd agcd,u.dpcd dpcd,u.supply_date supdate,u.supply_rate supply_rate,sum(u.supply_copy) supply_copy
        from cir_bill_print u
        where u.comp_code=pcomp_code and u.unit_code=punit_code and cur_sessionid=userenv('sessionid')
        group by u.comp_code,u.unit_code,u.agcd,u.dpcd,u.supply_date,u.billno,u.billdt,u.supply_rate) --WHERE ROWNUM<6
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
        (select nvl(sum(a.sup_copy),0) from cir_dbksup a where b.comp_code=a.comp_code and a.unit_code=b.unit_code and b.publ=a.publ and
        a.edtn =b.edtn and a.sup_type_code in (select cir_supply_type_mast.sup_ty_code from cir_supply_type_mast 
        where cir_supply_type_mast.comp_code=a.comp_code and cir_supply_type_mast.bill_pay='N') and 
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

        /*open p_accounts for
        select cir_bill.*,(select cir_get_city(m.comp_code,m.city_code) city_name from cir_agmast m
        where m.comp_code=cir_bill.comp_code and m.unit=cir_bill.unit_code and m.agcd=cir_bill.agcd and m.dpcd=cir_bill.dpcd) "CITY NAME" 
        from cir_bill
        where comp_code   = pcomp_code and unit_code = nvl(punit_code,unit_code) and
        billdt >= vfrdt and billdt <=vtodt and
        agcd = nvl(pbillagcd,agcd) and
        dpcd = nvl(pbilldpcd,dpcd) and
        bill_flag = nvl(pbill_freq,bill_flag) and
        ((publ      = ppubl) or (ppubl is null));*/
        open p_accounts for
        select b.comp_code comp_code, b.unit_code unit_code, b.billno billno, b.billdt billdt, b.agcd agcd, b.dpcd dpcd, 
        min(b.publ) publ, sum(b.bill_copy) bill_copy, sum(b.gross_amount) gross_amount, sum(b.sur_amt) sur_amount, sum(b.comm_amt) comm_amount, 
        sum(b.bill_amount) bill_amount,max(b.bill_flag) bill_flag,null as  bill_remark, max(b.userid) userid, max(b.creation_date) creation_date, 
        b.branch_code branch_code,m.ag_name agency_name,cir_get_city(b.comp_code,m.city_code) as "CITY NAME" 
        from cir_bill_det b,cir_agmast m
        where b.comp_code = pcomp_code and m.comp_code=b.comp_code and b.unit_code = nvl(punit_code,b.unit_code) and 
        m.unit=b.unit_code and b.agcd = nvl(pbillagcd,b.agcd) and m.agcd=b.agcd and b.dpcd = nvl(pbilldpcd,b.dpcd) and  
        m.dpcd=b.dpcd and b.billdt >= vfrdt and billdt <=vtodt and b.bill_flag = nvl(pbill_freq,b.bill_flag) and 
        b.publ = nvl(ppubl,b.publ) and (m.state_code=v_statecode or v_statecode is null) and (m.dist_code=v_distcode or v_distcode is null) and 
        (m.tehsil_taluka=v_taluka or v_taluka is null) and (m.city_code=v_citycode or v_citycode is null)
        group by b.comp_code, b.unit_code, b.billno ,b.billdt,b.agcd, b.dpcd,m.ag_name,b.branch_code,m.city_code
        order by b.comp_code, b.unit_code, b.billdt,b.billno,m.ag_name;
        
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
            p_accounts      out t_accounts,
            p_accounts1     out t_accounts)
    As
      v_bill_frdt   date;
      v_bill_todt   date;
      v_dt          date;
      v_query1      varchar2(8000);
      v_query2      varchar2(8000);
      v_statecode   varchar2(20);
      v_distcode    varchar2(20);
      v_citycode    varchar2(20);
      v_taluka      varchar2(20);
      
    cursor cur_bill is
        select distinct a.comp_code comp_code,a.unit_code unit_code,/*a.publ publ,*/a.agcd agcd,a.dpcd dpcd,b.ag_name ag_name,b.ag_name_oth_lang ag_name_oth_lang,
        b.city_code city_code,b.country_code country_code,b.state_code state_code,b.dist_code dist_code,b.tehsil_taluka taluka_code,
        /*a.billno billno,a.billdt billdt,*/sum(a.bill_copy) supply_copy,sum(a.gross_amount) gross_amount,sum(a.sur_amt) sur_amount,sum(a.comm_amt) comm_amount,
        c.bill_sec_amt bill_sec_amt
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
                  b.city_code,b.country_code,b.state_code,b.dist_code,b.tehsil_taluka,c.bill_sec_amt/*,a.billno,a.billdt*/
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
            agname, agname_oth_lang, city_code, taluka_code, dist_code, state_code, remarks,bill_sec_amt,sec_opbal)
               values(v1.comp_code,  v1.unit_code  , null   ,null  , ''    ,v1.agcd,v1.dpcd,
            v1.supply_copy,v1.gross_amount,nvl(v1.comm_amount,0),v1.sur_amount,v_ret_copy,v_ret_gross,v_ret_comm,
            v_dn_amt,v_rec_amt,v_prev_bal,v_cn_amt,userenv('sessionid'),
            v1.ag_name,v1.ag_name_oth_lang,v_city_name,v_taluka_name,v_dist_name,v_state_name,v1.country_code,v1.bill_sec_amt,v_sec_bal);
    
            v_dsign:=0;v_ret_gross:=0;v_ret_comm:=0; v_ret_copy:=0; v_dn_amt:=0; v_cn_amt:=0; v_rec_amt:=0; v_prev_bal:=0;v_sec_bal:=0;
            v_state_name:=null;v_dist_name:=null;v_taluka_name:=null;v_city_name:=null;
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
            sum(a.prev_bal) prev_bal, abs(sum(a.rec_amt)) rec_amt,sum(nvl(a.dn_amt,0)-nvl(a.bill_sec_amt,0)) dn_amt, sum(a.cn_amt) cn_amt,sum(nvl(a.dn_amt,0)+nvl(a.cn_amt,0)-nvl(a.bill_sec_amt,0)) dr_cr_amt,
            sum(((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))-nvl(a.return_amt,0)+nvl(a.bill_sec_amt,0)+nvl(a.prev_bal,0)+nvl(a.rec_amt,0)+nvl(a.dn_amt,0)+nvl(a.cn_amt,0)-nvl(a.bill_sec_amt,0))) net_bal,
            abs(sum(nvl(a.sec_opbal,0))) deposit_balance
            from cir_temp_bill_collection a
            where cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.agcd,a.dpcd,a.agname,a.agname_oth_lang,a.remarks,a.state_code
            order by comp_code,unit_code,state_name,ag_name;

            open p_accounts1 for
            select a.comp_code comp_code,a.unit_code unit_code,a.state_code state_name,
            sum(nvl(a.gross_amt,0)+nvl(a.sur_amt,0)) bill_amt,sum(a.comm_amt) comm_amt,sum((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))) net_bill,
            sum(a.return_copy) return_copy,sum(nvl(a.return_amt,0)+nvl(ret_comm_amt,0)) return_amt,sum(nvl(a.return_amt,0))  net_return_amt,
            sum((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))-nvl(a.return_amt,0)) total_bill,abs(sum(nvl(a.bill_sec_amt,0))) dep_adj, 
            sum((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))-nvl(a.return_amt,0)+nvl(a.bill_sec_amt,0)) total_net,
            sum(a.prev_bal) prev_bal, abs(sum(a.rec_amt)) rec_amt,sum(nvl(a.dn_amt,0)-nvl(a.bill_sec_amt,0)) dn_amt, sum(a.cn_amt) cn_amt,sum(nvl(a.dn_amt,0)+nvl(a.cn_amt,0)-nvl(a.bill_sec_amt,0)) dr_cr_amt,
            sum(((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))-nvl(a.return_amt,0)+nvl(a.bill_sec_amt,0)+nvl(a.prev_bal,0)+nvl(a.rec_amt,0)+nvl(a.dn_amt,0)+nvl(a.cn_amt,0)-nvl(a.bill_sec_amt,0))) net_bal,
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
            sum(nvl(a.return_amt,0)+nvl(ret_comm_amt,0)) return_amt,sum(a.return_amt) net_return_amt,
            sum((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))-nvl(a.return_amt,0)) total_bill,abs(sum(nvl(a.bill_sec_amt,0))) dep_adj, 
            sum((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))-nvl(a.return_amt,0)+nvl(a.bill_sec_amt,0)) total_net,
            sum(a.prev_bal) prev_bal, abs(sum(a.rec_amt)) rec_amt,sum(nvl(a.dn_amt,0)-nvl(a.bill_sec_amt,0)) dn_amt, sum(a.cn_amt) cn_amt,sum(nvl(a.dn_amt,0)+nvl(a.cn_amt,0)-nvl(a.bill_sec_amt,0)) dr_cr_amt,
            sum(((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))-nvl(a.return_amt,0)+nvl(a.bill_sec_amt,0)+nvl(a.prev_bal,0)+nvl(a.rec_amt,0)+nvl(a.dn_amt,0)+nvl(a.cn_amt,0)-nvl(a.bill_sec_amt,0))) net_bal,
            abs(sum(nvl(a.sec_opbal,0))) deposit_balance
            from cir_temp_bill_collection a
            where cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.agcd,a.dpcd,a.agname,a.agname_oth_lang,a.remarks,a.state_code,a.dist_code
            order by comp_code,unit_code,state_name,district_name,ag_name;     

            open p_accounts1 for
            select a.comp_code comp_code,a.unit_code unit_code,a.dist_code district_name,
            a.state_code state_name,
            sum(a.supply_copy) supply_code,sum(nvl(a.gross_amt,0)+nvl(a.sur_amt,0)) bill_amt,sum(a.comm_amt) comm_amt,sum(nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0)) net_bill,
            sum(a.return_copy) return_copy,sum(nvl(a.return_amt,0)+nvl(ret_comm_amt,0)) return_amt,sum(a.return_amt) net_return_amt,
            sum((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))-nvl(a.return_amt,0)) total_bill,abs(sum(nvl(a.bill_sec_amt,0))) dep_adj, 
            sum((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))-nvl(a.return_amt,0)+nvl(a.bill_sec_amt,0)) total_net,
            sum(a.prev_bal) prev_bal, abs(sum(a.rec_amt)) rec_amt,sum(nvl(a.dn_amt,0)-nvl(a.bill_sec_amt,0)) dn_amt, sum(a.cn_amt) cn_amt,sum(nvl(a.dn_amt,0)+nvl(a.cn_amt,0)-nvl(a.bill_sec_amt,0)) dr_cr_amt,
            sum(((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))-nvl(a.return_amt,0)+nvl(a.bill_sec_amt,0)+nvl(a.prev_bal,0)+nvl(a.rec_amt,0)+nvl(a.dn_amt,0)+nvl(a.cn_amt,0)-nvl(a.bill_sec_amt,0))) net_bal,
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
            sum(nvl(a.return_amt,0)+nvl(ret_comm_amt,0)) return_amt,sum(a.return_amt) net_return_amt,
            sum((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))-nvl(a.return_amt,0)) total_bill,abs(sum(nvl(a.bill_sec_amt,0))) dep_adj, 
            sum((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))-nvl(a.return_amt,0)+nvl(a.bill_sec_amt,0)) total_net,
            sum(a.prev_bal) prev_bal, abs(sum(a.rec_amt)) rec_amt,sum(nvl(a.dn_amt,0)-nvl(a.bill_sec_amt,0)) dn_amt, sum(a.cn_amt) cn_amt,sum(nvl(a.dn_amt,0)+nvl(a.cn_amt,0)-nvl(a.bill_sec_amt,0)) dr_cr_amt,
            sum(((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))-nvl(a.return_amt,0)+nvl(a.bill_sec_amt,0)+nvl(a.prev_bal,0)+nvl(a.rec_amt,0)+nvl(a.dn_amt,0)+nvl(a.cn_amt,0)-nvl(a.bill_sec_amt,0))) net_bal,
            abs(sum(nvl(a.sec_opbal,0))) deposit_balance
            from cir_temp_bill_collection a
            where cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.agcd,a.dpcd,a.agname,a.agname_oth_lang,a.remarks,a.state_code,a.dist_code,a.city_code
            order by comp_code,unit_code,state_name,district_name,city_name,ag_name;  
            
            open p_accounts1 for
            select a.comp_code comp_code,a.unit_code unit_code,a.city_code city_name,
            a.dist_code district_name,a.state_code state_name,
            sum(nvl(a.gross_amt,0)+nvl(a.sur_amt,0)) bill_amt,a.comm_amt comm_amt,(nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0)) net_bill,
            sum(nvl(a.return_amt,0)+nvl(ret_comm_amt,0)) return_amt,sum(a.return_amt) net_return_amt,
            sum((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))-nvl(a.return_amt,0)) total_bill,abs(sum(nvl(a.bill_sec_amt,0))) dep_adj, 
            sum((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))-nvl(a.return_amt,0)+nvl(a.bill_sec_amt,0)) total_net,
            sum(a.prev_bal) prev_bal, abs(sum(a.rec_amt)) rec_amt,sum(nvl(a.dn_amt,0)-nvl(a.bill_sec_amt,0)) dn_amt, sum(a.cn_amt) cn_amt,sum(nvl(a.dn_amt,0)+nvl(a.cn_amt,0)-nvl(a.bill_sec_amt,0)) dr_cr_amt,
            sum(((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))-nvl(a.return_amt,0)+nvl(a.bill_sec_amt,0)+nvl(a.prev_bal,0)+nvl(a.rec_amt,0)+nvl(a.dn_amt,0)+nvl(a.cn_amt,0)-nvl(a.bill_sec_amt,0))) net_bal,
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
            sum(nvl(a.return_amt,0)+nvl(ret_comm_amt,0)) return_amt,sum(a.return_amt) net_return_amt,
            sum((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))-nvl(a.return_amt,0)) total_bill,abs(sum(nvl(a.bill_sec_amt,0))) dep_adj, 
            sum((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))-nvl(a.return_amt,0)+nvl(a.bill_sec_amt,0)) total_net,
            sum(a.prev_bal) prev_bal, abs(sum(a.rec_amt)) rec_amt,sum(nvl(a.dn_amt,0)-nvl(a.bill_sec_amt,0)) dn_amt, sum(a.cn_amt) cn_amt,sum(nvl(a.dn_amt,0)+nvl(a.cn_amt,0)-nvl(a.bill_sec_amt,0)) dr_cr_amt,
            sum(((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))-nvl(a.return_amt,0)+nvl(a.bill_sec_amt,0)+nvl(a.prev_bal,0)+nvl(a.rec_amt,0)+nvl(a.dn_amt,0)+nvl(a.cn_amt,0)-nvl(a.bill_sec_amt,0))) net_bal,
            abs(sum(nvl(a.sec_opbal,0))) deposit_balance
            from cir_temp_bill_collection a
            where cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.agcd,a.dpcd,a.agname,a.agname_oth_lang,a.taluka_code,a.dist_code,a.remarks,a.state_code
            order by comp_code,unit_code,state_name,district_name,taluka_name,ag_name;   

            open p_accounts1 for
            select a.comp_code comp_code,a.unit_code unit_code,a.state_code state_name,a.dist_code district_name,
            a.taluka_code||'('||a.dist_code||')' taluka_name,
            sum(nvl(a.gross_amt,0)+nvl(a.sur_amt,0)) bill_amt,sum(a.comm_amt) comm_amt,sum((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))) net_bill,
            sum(nvl(a.return_amt,0)+nvl(ret_comm_amt,0)) return_amt,sum(a.return_amt) net_return_amt,
            sum((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))-nvl(a.return_amt,0)) total_bill,abs(sum(nvl(a.bill_sec_amt,0))) dep_adj, 
            sum((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))-nvl(a.return_amt,0)+nvl(a.bill_sec_amt,0)) total_net,
            sum(a.prev_bal) prev_bal, abs(sum(a.rec_amt)) rec_amt,sum(nvl(a.dn_amt,0)-nvl(a.bill_sec_amt,0)) dn_amt, sum(a.cn_amt) cn_amt,sum(nvl(a.dn_amt,0)+nvl(a.cn_amt,0)-nvl(a.bill_sec_amt,0)) dr_cr_amt,
            sum(((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))-nvl(a.return_amt,0)+nvl(a.bill_sec_amt,0)+nvl(a.prev_bal,0)+nvl(a.rec_amt,0)+nvl(a.dn_amt,0)+nvl(a.cn_amt,0)-nvl(a.bill_sec_amt,0))) net_bal,
            abs(sum(nvl(a.sec_opbal,0))) deposit_balance
            from cir_temp_bill_collection a
            where cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.taluka_code,a.dist_code,a.remarks,a.state_code
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
        v_bill_dbn_amt  number(10,2);
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
/***************************************4822************************************/

/*************************Anupama 4649 19/9/11********************/

alter procedure CIR_OPENING_BIND_ORDER_BY(
    @pcomp_code  as varchar(10),
    @punit_code  as varchar(10),
    @pdateformat as varchar(20),
    @pcolname as varchar(100),
    @porder 		as varchar(50),
    @pextra1     as varchar(50),
    @pextra2     as varchar(50)
    )
AS
declare @str as varchar(4000)
  Begin
        set @str ='select * from (select a.comp_code COMP_CODE,a.unit_code UNIT_CODE,a.publ PUBL,a.agcd AGCD,a.dpcd DPCD,a.for_month FOR_MONTH,a.opbal OPBAL,
        a.sec_opbal SEC_OPBAL,a.creation_date CREATION_DATE,a.creation_userid CREATION_USERID,a.last_updated_date LAST_UPDATED_DATE,
        a.last_updated_userid LAST_UPDATE_USERID,dbo.cir_get_agency(a.comp_code,a.unit_code,a.agcd,a.dpcd) AGENCY_NAME,dbo.cir_get_city(a.comp_code,b.city_code) CITY_NAME 
        from cir_agomast a,cir_agmast b
        where a.comp_code = '''+@pcomp_code+''' and a.comp_code=b.comp_code and
              a.unit_code = '''+@punit_code+''' and a.unit_code=b.unit and a.agcd=b.agcd and a.dpcd=b.dpcd)c
            order by c.' +@pcolname+' '+@porder;

print(@str) 
exec(@str)
    
  End 


/*************************Anupama 4649 19/9/11********************/

/****************prachi 4848    19/9/2011**********************************/
ALTER PROCEDURE [dbo].[cir_rolename_p]
	@compcode                                 VARCHAR(20) 
AS 
	
		SELECT
				 Agency_Role_Name as ROLE_DESC,
				 Agency_Role_Code as ROLE_CODE
		FROM  agency_role_master 
		WHERE	 Comp_code  = @compcode
		ORDER BY Agency_Role_Name ASC 
		
/****************prachi 4848    19/9/2011**********************************/

/*********************Laxman Sir 4760 20/9/2011********************************/

                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE cir_rep_collection_cir_rep_collection_det_p
	@pcompcode                                VARCHAR(20) ,
	@punitcode                                VARCHAR(20) ,
	@pbrachcode                               VARCHAR(20) ,
	@pdoctype                                 VARCHAR(20) ,
	@ppaymode                                 VARCHAR(20) ,
	@pactype                                  VARCHAR(20) ,
	@pfromdate                                VARCHAR(20) ,
	@ptodate                                  VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(200) ,
	@pextra2                                  VARCHAR(200) 
AS 
		DECLARE @v_frdt		DATETIME 
		DECLARE @v_todt     DATETIME 
		DECLARE	@A			INT
		DECLARE	@v_a		as varchar(1000)
	Begin
		SET @v_frdt  = DBO.CONVERT_USER_DATE('/', @pfromdate,@pdateformat)
		SET @v_todt  = DBO.CONVERT_USER_DATE('/', @ptodate,@pdateformat)
		/*if @pdoctype is not null Begin
            SET @a=dbo.FN_SPLITFIELD(@pdoctype ,',')
        end*/
		create  table #Results(SegmentNum INT, EditionName  VARCHAR(255))
		Begin
			if (@pdoctype is not null) begin
			insert into #Results select * from dbo.Fn_Splitfield(@pdoctype,',')
			End
		End

        select A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.RECPTDT RECPTDT,A.RECPTNO RECPTNO,A.DOCTYPE DOCTYP,A.AGCD AGCD,
        A.DPCD DPCD,B.AG_NAME AS AGENCY_NAME,B.AG_NAME_OTH_LANG AGNAME_OTH_LANG,B.CITY_CODE,dbo.CIR_GET_CITY(B.COMP_CODE,B.CITY_CODE) CITY_NAME,
        B.TEHSIL_TALUKA TALUKA_CODE,dbo.CIR_GET_TALUKA(B.COMP_CODE,B.TEHSIL_TALUKA) TALUKA_NAME,A.VOUCHERNO VOUCHERNO,A.CHNO CHNO,A.CHDT CHDT,
        SUBSTRING(ISNULL((SELECT BANKNAME AS "bankname" FROM CIR_BANK_MAST WHERE COMP_CODE=A.COMP_CODE AND BANKCODE=A.CHBANK),A.CHBANK),1,15) AS BANK,ABS(A.AMOUNT) AMOUNT,
        dbo.INITCAP(A.REMARK) REMARK,A.ACHD ACHD,
        CASE WHEN A.DOCTYPE='RCR' THEN (SELECT "Payment_Mode_Name" FROM PAYMENT_MODE_MAST WHERE "Pay_Mode_Code"=A.REASON)
        ELSE (SELECT REASON_NAME FROM CIR_REASON_MST WHERE COMP_CODE=A.COMP_CODE AND REASON_CODE=A.REASON) END AS REASON,
        A.BRANCH_CODE BRANCH_CODE,(SELECT DISTINCT "Branch_Name" FROM BRANCH_MST WHERE "Branch_Code"=A.BRANCH_CODE) BRANCH_NAME,
        SUBSTRING(dbo.FA_GET_ACCOUNT_NAME(A.COMP_CODE,A.RCDP),1,15) DEBIT_HEAD,(SELECT DISTINCT CASE WHEN DSIGN=-1 THEN 'C' ELSE 'D' END DSIGN FROM CIR_DOCMST WHERE DOC_TYPE=A.DOCTYPE) DSIGN,
        A.USERID,(SELECT isnull(FIRSTNAME,"username")+' '+LASTNAME FROM LOGIN WHERE "userid"=A.USERID) CREATED_BY, A.CREATION_DATE CREATION_DATE, A.PROV_REC_NO PROV_REC_NO, A.PROV_REC_DT PROV_REC_DATE,
        A.REMARK_OTH REMARK_OTH
        from cir_rcphdr a,cir_agmast b
        where a.comp_code=b.comp_code and a.comp_code=@pcompcode  and a.unit_code=b.unit and a.unit_code =@punitcode and
              a.agcd=b.agcd and a.dpcd=b.dpcd and (a.agcd=@pextra1 or @pextra1 is null or @pextra1='') and (a.dpcd=@pextra2 or @pextra2 is null or @pextra2='') and
              a.recptdt between @v_frdt and @v_todt and --(a.doctype  = @pdoctype or @pdoctype is null or @pdoctype='' )
			  (a.doctype  in (SELECT EditionName FROM #Results) or @pdoctype is null OR @pdoctype='') and
              (a.reason =@ppaymode or @ppaymode is null OR	@ppaymode = '') and (ISNULL(a.achd, 'NM')  = @pactype OR	@pactype  is null OR	@pactype = '') and
              (a.branch_code  = @pbrachcode OR	@pbrachcode  is null  OR	@pbrachcode = '')
        order by comp_code,recptdt,doctype,recptno;

		/*SELECT a.comp_code comp_code, a.unit_code unit_code, a.recptdt recptdt, a.recptno recptno, a.doctype doctyp, a.agcd agcd,
		a.dpcd dpcd, b.ag_name  AGENCY_NAME, b.ag_name_oth_lang agname_oth_lang, b.city_code, DBO.cir_get_city(b.comp_code, b.city_code) city_name,
		b.tehsil_taluka taluka_code, DBO.cir_get_taluka(b.comp_code, b.tehsil_taluka) taluka_name, a.voucherno voucherno,
		a.chno chno, a.chdt chdt,
		SUBSTRING(ISNULL((SELECT bankname bankname  FROM  cir_bank_mast 	WHERE	 comp_code  = @pcompcode AND	bankcode  = a.chbank), a.chbank), 1, 15)  BANK,
		ABS(a.amount) amount, dbo.InitCap(a.remark) remark, a.achd achd,a.reason reason, a.branch_code branch_code,
		(SELECT DISTINCT Branch_Name FROM  branch_mst 	WHERE  Branch_Code  = a.branch_code) branch_name,
		SUBSTRING(DBO.fa_get_account_name(a.comp_code, a.rcdp), 1, 15) debit_head,
       (select distinct case when dsign=-1 then 'C' else 'D' end dsign 
		from cir_docmst where doc_type=a.doctype) dsign	,
		a.userid userid,(select ISNULL(FIRSTNAME,"username")+' '+LASTNAME from login where "userid"=a.userid) created_by, 
		a.creation_date creation_date, a.prov_rec_no prov_rec_no, a.prov_rec_dt prov_rec_date
        FROM  cir_rcphdr a, cir_agmast b 
		WHERE	 a.comp_code  = b.comp_code AND	a.comp_code  = @pcompcode
			AND	a.unit_code  = b.unit AND	a.unit_code  = @punitcode
			AND	a.agcd  = b.agcd
			AND (a.agcd=@pextra1 or @pextra1 is null or @pextra1='')
			AND	a.dpcd  = b.dpcd
			AND (a.dpcd=@pextra2 or @pextra2 is null or @pextra2='') 
			AND	a.recptdt  between @v_frdt  and  @v_todt
			--AND	(a.doctype  = @pdoctype or @pdoctype is null or @pdoctype='' )
			AND (a.doctype  in (SELECT EditionName FROM #Results) or @pdoctype is null OR @pdoctype='')
			AND	(a.reason  = @ppaymode OR	@ppaymode  is null OR	@ppaymode = '')
			AND	(ISNULL(a.achd, 'NM')  = @pactype OR	@pactype  is null OR	@pactype = '')
			AND	(a.branch_code  = @pbrachcode OR	@pbrachcode  is null  OR	@pbrachcode = '')
		 ORDER BY a.comp_code, a.recptdt,a.doctype, a.recptno */
		
		
		SELECT e.comp_code, e.doctype, e.reason, SUM(CONVERT(FLOAT, e.db_amount)) db_amount, 
        SUM(CONVERT(FLOAT, e.cr_amount)) cr_amount  FROM 
               (SELECT d.comp_code, d.doctype, d.reason,
		        CASE d.debit WHEN 'D' THEN SUM(CONVERT(FLOAT, d.amount)) END db_amount,				 
		        CASE d.credit WHEN 'C' THEN SUM(CONVERT(FLOAT, d.amount)) END cr_amount
		        FROM (SELECT a.comp_code comp_code, a.doctype doctype, a.reason reason,
             CASE sign(a.amount) WHEN 1 THEN 'D' END as debit,
             CASE sign(a.amount) WHEN - 1 THEN 'C' END as credit,
             ABS(a.amount)  amount
             FROM  cir_rcphdr a, cir_agmast b 
			WHERE	 a.comp_code  = b.comp_code
				AND	a.comp_code  = @pcompcode
				AND	a.unit_code  = b.unit
				AND	a.unit_code  = @punitcode
				AND	a.agcd  = b.agcd
				AND (a.agcd=@pextra1 or @pextra1 is null or @pextra1='')		
				AND	a.dpcd  = b.dpcd
				AND (a.dpcd=@pextra2 or @pextra2 is null or @pextra2='') 
				AND	a.recptdt  between @v_frdt  and  @v_todt
				--AND	(a.doctype  = @pdoctype OR	@pdoctype  is null OR	@pdoctype = '')
				AND (a.doctype  in (SELECT EditionName FROM #Results) or @pdoctype is null OR @pdoctype='')
				AND	(a.reason  = @ppaymode OR	@ppaymode  is null  OR	@ppaymode  = '')
				AND	(ISNULL(a.achd, 'NM')  = @pactype  OR	@pactype  is null OR	@pactype  = '')
				AND	(a.branch_code  = @pbrachcode OR	@pbrachcode  is null OR	 @pbrachcode  = '')) d
                 GROUP BY d.comp_code, d.doctype, d.reason, d.debit, d.credit ) e
		GROUP BY e.comp_code, e.doctype,  e.reason 
		ORDER BY e.comp_code, e.doctype, e.reason 
		
		drop table #Results

End

/*********************Laxman Sir 4760 20/9/2011********************************/



//-------------------------------------issue no 4867-----------------------------------

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROCEDURE [dbo].[cir_taxi_bind_p]
	@pcompcode                                VARCHAR(20) ,
	@punit                                    VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS 
	
		SELECT
				 cir_taxi_mast.*,
				 cir_route_mast.arr_time ARR_TIME,
				 cir_route_mast.dep_time DEP_TIME,
				 cir_route_mast.route_dist ROUTE_DIST,
				 cir_route_mast.route_name nm
		FROM  cir_taxi_mast,
			 cir_route_mast 
		WHERE	 cir_taxi_mast.comp_code  = cir_route_mast.comp_code
		 AND	cir_taxi_mast.unit_code  = cir_route_mast.unit
		 AND	cir_taxi_mast.rt_code  = cir_route_mast.route_code
		 AND	((cir_taxi_mast.subrt_code  is null) or (cir_taxi_mast.subrt_code = ''))
		 AND	((cir_taxi_mast.sub_subrt_code  is null) or (cir_taxi_mast.sub_subrt_code = ''))
		 AND	cir_taxi_mast.comp_code  = @pcompcode
		 AND	cir_taxi_mast.unit_code  = @punit
		 AND	((UPPER(cir_taxi_mast.vehicle_name)  like @pextra1 + '%')
		 OR	(@pextra1  is null) OR	(@pextra1  = '')) 
		UNION
		 SELECT
				 cir_taxi_mast.*,
				 cir_sub_route_mast.arr_time,
				 cir_sub_route_mast.dep_time,
				 cir_sub_route_mast.subrt_dist,
				 cir_sub_route_mast.subrt_name nm
		FROM  cir_taxi_mast,
			 cir_sub_route_mast 
		WHERE	 cir_taxi_mast.comp_code  = cir_sub_route_mast.comp_code
		 AND	cir_taxi_mast.unit_code  = cir_sub_route_mast.unit
		 AND	cir_taxi_mast.rt_code  = cir_sub_route_mast.route_code
		 AND	cir_taxi_mast.subrt_code  = cir_sub_route_mast.subrt_code
		 AND	((cir_taxi_mast.sub_subrt_code  is null) or (cir_taxi_mast.sub_subrt_code = ''))
		 AND	cir_taxi_mast.comp_code  = @pcompcode
		 AND	cir_taxi_mast.unit_code  = @punit
		 AND	((UPPER(cir_taxi_mast.vehicle_name)  like @pextra1 + '%')
		 OR	(@pextra1  is null) OR	(@pextra1  = ''))
		UNION
		 SELECT
				 cir_taxi_mast.*,
				 cir_sub_subroute_mast.arr_time,
				 cir_sub_subroute_mast.dep_time,
				 cir_sub_subroute_mast.sub_subrt_dist,
				 cir_sub_subroute_mast.sub_subrt_name nm
		FROM  cir_taxi_mast,
			 cir_sub_subroute_mast 
		WHERE	 cir_taxi_mast.comp_code  = cir_sub_subroute_mast.comp_code
		 AND	cir_taxi_mast.unit_code  = cir_sub_subroute_mast.unit
		 AND	cir_taxi_mast.rt_code  = cir_sub_subroute_mast.route_code
		 AND	cir_taxi_mast.subrt_code  = cir_sub_subroute_mast.subrt_code
		 AND	cir_taxi_mast.sub_subrt_code  = cir_sub_subroute_mast.sub_subrt_code
		 AND	cir_taxi_mast.comp_code  = @pcompcode
		 AND	cir_taxi_mast.unit_code  = @punit
		 AND	((UPPER(cir_taxi_mast.vehicle_name)  like @pextra1 + '%')
		 OR	(@pextra1  is null)  OR	(@pextra1  = '')) ORDER BY VEHICLE_NAME
		 
		//============================================================================ 
		

/***************************laxman sir 4768    21/09/2011*******************************************/

                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE cir_rep_supply_cir_rep_supply_unit
	@pcomp_code			VARCHAR(20) ,
	@punit_code         VARCHAR(20) ,
	@ppubl              VARCHAR(20) ,
	@pfrom_supdate      VARCHAR(20) ,
	@ptill_supdate      VARCHAR(20) ,
	@pdateformat        VARCHAR(20) ,
	@pextra1            VARCHAR(40) ,
	@pextra2            VARCHAR(40) 
AS 
	DECLARE @vfrom_supdate      VARCHAR(20) 
	DECLARE @vtill_supdate      VARCHAR(20) 
	declare @supply_type_name	varchar(4000)
	declare @supply_sum			varchar(4000)

	DECLARE cur_sup_type cursor LOCAL FOR 
		SELECT 'sum( case sup_type_code when ' + '''' + CAST(sup_ty_code AS VARCHAR) + '''' + ' then sup_copy else 0 end) "' + CAST(sup_ty_name AS VARCHAR) + '",' vty,
				 'sum(case sup_type_code when ' + '''' + CAST(sup_ty_code AS VARCHAR) + '''' + 'then sup_copy else 0 end) +' vty_sum
		FROM  cir_supply_type_mast 
		WHERE comp_code  = @pcomp_code 
		ORDER BY sup_seq_no 

		DECLARE @vvar		VARCHAR(4000) 
		DECLARE @vvar_sum   VARCHAR(4000) 
		DECLARE @vquery     VARCHAR(4000) 
		DECLARE @vquery1    VARCHAR(4000) 

		DECLARE @vquery2    VARCHAR(4000) 
		DECLARE @vquery12   VARCHAR(4000) 
print('13')

		SET @vfrom_supdate  = dbo.convert_user_date('/', @pfrom_supdate,@pdateformat)
		SET @vtill_supdate  = dbo.convert_user_date('/', @ptill_supdate,@pdateformat)
print('1311')		
		OPEN cur_sup_type 
			fetch NEXT from  cur_sup_type into @supply_type_name,@supply_sum

			WHILE (@@FETCH_STATUS = 0) 
			BEGIN 
			   set @vvar =COALESCE(@vvar+'', SPACE(0)) + '' + COALESCE(@supply_type_name + '', SPACE(0))
		       set @vvar_sum=COALESCE(@vvar_sum+'', SPACE(0)) + '' + COALESCE(@supply_sum + '', SPACE(0))
		    fetch NEXT from  cur_sup_type into @supply_type_name,@supply_sum
        END 
		close cur_sup_type
		
		SET @vvar  = SUBSTRING(@vvar, 1, LEN(@vvar) - 1)
		SET @vvar_sum  = SUBSTRING(@vvar_sum, 1, LEN(@vvar_sum) - 1)
		--insert into test1(vstring) values (vquery);
		
		SET @vquery  = ' select comp_code AS "COMP_CODE",unit_code AS "UNIT_CODE",publ AS "PUBL", dbo.cir_get_publ_name(comp_code,publ) AS "PUBL_NAME",sup_rate as "SUP_RATE", supdate AS "SUPDATE",' + @vvar + ',' 
        SET @vquery2  = @vvar_sum + ' TOTAL from cir_dbksup where comp_code=' + '''' + @pcomp_code + '''' + ' and 
        ((unit_code=' + '''' + @punit_code + '''' + ') or (' + '''' + @punit_code + '''' + ' is null)) and ((publ=' + '''' + @ppubl + '''' + ') or (' + '''' + @ppubl + '''' + ' is null)) and  supdate between ' + ''''  + @vfrom_supdate + ''''  + '  and ' + '''' + @vtill_supdate +'''' + '  group by comp_code,unit_code,sup_rate,supdate,publ order by comp_code,unit_code,publ_name,supdate,sup_rate' 
		--insert into test1(vstring) values ('11'||vquery);commit;
		print(@vquery)print(@vquery2)
		EXEC (@vquery + @vquery2) 
		print('5656')

		SET @vquery1  = ' select comp_code AS "COMP_CODE",sup_rate as "SUP_RATE",' + @vvar + ',' 
        SET @vquery12  = @vvar_sum + ' TOTAL from cir_dbksup where comp_code=' + '''' + @pcomp_code + '''' + ' and ((unit_code=' + '''' + @punit_code + '''' + ') or (' + '''' +@punit_code + '''' + ' is null)) and ((publ=' + '''' + @ppubl + '''' + ') or (' + '''' + @ppubl + '''' + ' is null)) and  supdate between' +  '''' + @vfrom_supdate + '''' +'  and ' + '''' + @vtill_supdate + '''' + ' group by comp_code,sup_rate order by comp_code,sup_rate' 
		--insert into test1(vstring) values ('22'||vquery1);commit;
		--	print(@vquery1)
		EXEC (@vquery1 + @vquery12) 
	DEALLOCATE cur_sup_type

                                                                     
                                                                     
                                                                     
                                             
ALTER procedure cir_supply_alteration_p
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
      @pbrancode         as varchar(20),
      @proutecode        as varchar(20),
      @pagcd_code        as varchar(20),
      @pdpcd_code        as varchar(20),
      @psorted_by        as varchar(20),---1 for  edition route wise,2 for edition district wise
      @pdateformat       as varchar(20),
      @pextra1           as varchar(200),--agency type
      @pextra2           as varchar(200),--for agency--A and distribution--D
      @pextra3           as varchar(200),--agency class
      @pextra4           as varchar(200),
      @pextra5           as varchar(200)
 As
	
 Begin
  if upper(@pextra2)='D' Begin
      if @psorted_by='2' Begin---for edition district and agency wise
            SELECT A.COMP_CODE COMP_CODE,A.UNIT UNIT,A.AGCD AGCD,A.DPCD DPCD,A.AG_NAME AGENCY_NAME,A.AG_NAME_OTH_LANG AGENCY_NAME_OTHER_LANG,A.CITY_CODE CITY_CODE,
            DBO.CIR_GET_CITY(A.COMP_CODE,A.CITY_CODE) CITY_NAME,A.STATION_CODE DROP_POINT_CODE,DBO.CIR_GET_DROP_POINT_NAME(A.COMP_CODE,A.UNIT,A.STATION_CODE,'1') DROP_POINT_NAME,
            ISNULL(C.BASE_SUPPLY,0) BASE_SUPPLY,ISNULL(C.SUPPLY_SUN,0) SUPPLY_SUN,ISNULL(C.SUPPLY_MON,0) SUPPLY_MON,ISNULL(C.SUPPLY_TUE,0) SUPPLY_TUE,ISNULL(C.SUPPLY_WED,0) SUPPLY_WED,
            ISNULL(C.SUPPLY_THU,0) SUPPLY_THU,ISNULL(C.SUPPLY_FRI,0) SUPPLY_FRI,ISNULL(C.SUPPLY_SAT,0) SUPPLY_SAT,ISNULL(C.SUPPLY_SPL1,0) SUPPLY_SPL1,ISNULL(C.SUPPLY_SPL2,0) SUPPLY_SPL2,
            C.LBL_PRINTNO SUPPLY_SEQ,DBO.CIR_GET_ROUTE_SEQNO(C.COMP_CODE,C.UNIT,C.ROUTE_CODE) ROUTE_SEQ,
            C.ROUTE_CODE,DBO.CIR_GET_NAME_CIR_ROUTE(A.COMP_CODE,A.UNIT,C.ROUTE_CODE,1,@PDATEFORMAT,'','') ROUTE_NAME, 
            C.SUBROUTE_CODE,DBO.CIR_GET_NAME_CIR_SUBROUTE(A.COMP_CODE,A.UNIT,C.ROUTE_CODE,C.SUBROUTE_CODE,1,@PDATEFORMAT,'','') SUBROUTE_NAME,
            C.SUB_SUBROUTE_CODE,DBO.CIR_GET_NAME_CIR_SUBSUBROUTE(A.COMP_CODE,A.UNIT,C.ROUTE_CODE,C.SUBROUTE_CODE,C.SUB_SUBROUTE_CODE,1,@PDATEFORMAT,'','') SUBSUBROUTE_NAME,
            D.DIST_NAME DIST_NAME,ISNULL(P.CIR_SUP_ORDER_LIMIT,0) CIR_SUP_ORDER_LIMIT,C.SUPPLY_TYPE_CODE SUPPLY_TYPE_CODE,B.SUP_TY_NAME SUPPLY_TYPE_NAME,
			C.EDTN EDTN,E.EDTN_NAME EDTN_NAME,B.SUP_SEQ_NO SUP_SEQ_NO
            from cir_agmast_dis a left outer join cir_dist_mast d on a.comp_code=d.comp_code and a.dist_code=d.dist_code,cir_supply_type_mast b,cir_supply c,cir_edtn_mast e,preferrences p
            where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=e.comp_code and  a.comp_code= @pcomp_code and p.comp_code= @pcomp_code and
            a.unit=c.unit and a.unit=e.unit_code and a.unit= @punit_code and b.sup_ty_code=c.supply_type_code and
            c.publ=e.publ and c.publ= @ppubl_code and c.edtn=e.edtn and (c.edtn = isnull(@pedtn_code,c.edtn) or @pedtn_code='') and (e.main_edtn = isnull(@pmedtn_code,e.main_edtn) or @pmedtn_code='') and 
            a.agcd=c.agcd and (a.bill_agcd=isnull(@pagcd_code,a.bill_agcd) or @pagcd_code='') and a.dpcd=c.dpcd and (a.bill_dpcd=isnull(@pdpcd_code,a.bill_dpcd) or @pdpcd_code='') and (c.supply_type_code= @psup_type or @psup_type is null or @psup_type='') and 
			(a.state_code=@pstate or @pstate is null or @pstate='') and
            (a.dist_code=@pdistcode or @pdistcode is null  or @pdistcode='') and (a.tehsil_taluka = @ptaluka or @ptaluka is null or @ptaluka='') and
            (a.city_code=@pcitycode or @pcitycode is null) and (a.branch_code = @pbrancode or @pbrancode is null or @pbrancode='') and
            (c.route_code=@proutecode or @proutecode is null) and isnull(c.supply_flag,'N') ='Y' and isnull(a.suspend,'N')='N' and
			(a.ag_type=@pextra1 or @pextra1 is null or @pextra1='') and (a.ag_class=@pextra3 or @pextra3 is null or @pextra3='')
            order by dist_name,agency_name,edtn_name,sup_seq_no,supply_type_name,supply_seq
		End
      else Begin
          SELECT A.COMP_CODE COMP_CODE,A.UNIT UNIT,A.AGCD AGCD,A.DPCD DPCD,A.AG_NAME AGENCY_NAME,A.AG_NAME_OTH_LANG AGENCY_NAME_OTHER_LANG,A.CITY_CODE CITY_CODE,
            DBO.CIR_GET_CITY(A.COMP_CODE,A.CITY_CODE) CITY_NAME,A.STATION_CODE DROP_POINT_CODE,DBO.CIR_GET_DROP_POINT_NAME(A.COMP_CODE,A.UNIT,A.STATION_CODE,'1') DROP_POINT_NAME,
            ISNULL(C.BASE_SUPPLY,0) BASE_SUPPLY,ISNULL(C.SUPPLY_SUN,0) SUPPLY_SUN,ISNULL(C.SUPPLY_MON,0) SUPPLY_MON,ISNULL(C.SUPPLY_TUE,0) SUPPLY_TUE,ISNULL(C.SUPPLY_WED,0) SUPPLY_WED,
            ISNULL(C.SUPPLY_THU,0) SUPPLY_THU,ISNULL(C.SUPPLY_FRI,0) SUPPLY_FRI,ISNULL(C.SUPPLY_SAT,0) SUPPLY_SAT,ISNULL(C.SUPPLY_SPL1,0) SUPPLY_SPL1,ISNULL(C.SUPPLY_SPL2,0) SUPPLY_SPL2,
            C.LBL_PRINTNO SUPPLY_SEQ,DBO.CIR_GET_ROUTE_SEQNO(C.COMP_CODE,C.UNIT,C.ROUTE_CODE) ROUTE_SEQ,
            C.ROUTE_CODE,DBO.CIR_GET_NAME_CIR_ROUTE(A.COMP_CODE,A.UNIT,C.ROUTE_CODE,1,@PDATEFORMAT,'','') ROUTE_NAME, 
            C.SUBROUTE_CODE,DBO.CIR_GET_NAME_CIR_SUBROUTE(A.COMP_CODE,A.UNIT,C.ROUTE_CODE,C.SUBROUTE_CODE,1,@PDATEFORMAT,'','') SUBROUTE_NAME,
            C.SUB_SUBROUTE_CODE,DBO.CIR_GET_NAME_CIR_SUBSUBROUTE(A.COMP_CODE,A.UNIT,C.ROUTE_CODE,C.SUBROUTE_CODE,C.SUB_SUBROUTE_CODE,1,@PDATEFORMAT,'','') SUBSUBROUTE_NAME,
            D.DIST_NAME DIST_NAME,ISNULL(P.CIR_SUP_ORDER_LIMIT,0) CIR_SUP_ORDER_LIMIT,C.SUPPLY_TYPE_CODE SUPPLY_TYPE_CODE,B.SUP_TY_NAME SUPPLY_TYPE_NAME,
			C.EDTN EDTN,E.EDTN_NAME EDTN_NAME,B.SUP_SEQ_NO SUP_SEQ_NO
            from cir_agmast_dis a left outer join cir_dist_mast d on a.comp_code=d.comp_code and a.dist_code=d.dist_code,cir_supply_type_mast b,cir_supply c,cir_edtn_mast e,preferrences p
            where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=e.comp_code and  a.comp_code= @pcomp_code and p.comp_code= @pcomp_code and
            a.unit=c.unit and a.unit=e.unit_code and a.unit= @punit_code and b.sup_ty_code=c.supply_type_code and
            c.publ=e.publ and c.publ= @ppubl_code and c.edtn=e.edtn and (c.edtn = isnull(@pedtn_code,c.edtn) or @pedtn_code='') and (e.main_edtn = isnull(@pmedtn_code,e.main_edtn) or @pmedtn_code='') and 
            a.agcd=c.agcd and (a.bill_agcd=isnull(@pagcd_code,a.bill_agcd) or @pagcd_code='') and a.dpcd=c.dpcd and (a.bill_dpcd=isnull(@pdpcd_code,a.bill_dpcd) or @pdpcd_code='') and (c.supply_type_code= @psup_type or @psup_type is null or @psup_type='') and 
			(a.state_code=@pstate or @pstate is null or @pstate='') and
            (a.dist_code=@pdistcode or @pdistcode is null  or @pdistcode='') and (a.tehsil_taluka = @ptaluka or @ptaluka is null or @ptaluka='') and
            (a.city_code=@pcitycode or @pcitycode is null) and (a.branch_code = @pbrancode or @pbrancode is null or @pbrancode='') and
            (c.route_code=@proutecode or @proutecode is null) and isnull(c.supply_flag,'N') ='Y' and isnull(a.suspend,'N')='N' and
			(a.ag_type=@pextra1 or @pextra1 is null or @pextra1='') and (a.ag_class=@pextra3 or @pextra3 is null or @pextra3='')
             order by route_seq,supply_seq,agency_name,edtn_name,sup_seq_no,supply_type_name
	End
	end
  else	Begin
      if @psorted_by='2' Begin---for edition district and agency wise
            SELECT A.COMP_CODE COMP_CODE,A.UNIT UNIT,A.AGCD AGCD,A.DPCD DPCD,A.AG_NAME AGENCY_NAME,A.AG_NAME_OTH_LANG AGENCY_NAME_OTHER_LANG,A.CITY_CODE CITY_CODE,
            DBO.CIR_GET_CITY(A.COMP_CODE,A.CITY_CODE) CITY_NAME,A.STATION_CODE DROP_POINT_CODE,DBO.CIR_GET_DROP_POINT_NAME(A.COMP_CODE,A.UNIT,A.STATION_CODE,'1') DROP_POINT_NAME,
            ISNULL(C.BASE_SUPPLY,0) BASE_SUPPLY,ISNULL(C.SUPPLY_SUN,0) SUPPLY_SUN,ISNULL(C.SUPPLY_MON,0) SUPPLY_MON,ISNULL(C.SUPPLY_TUE,0) SUPPLY_TUE,ISNULL(C.SUPPLY_WED,0) SUPPLY_WED,
            ISNULL(C.SUPPLY_THU,0) SUPPLY_THU,ISNULL(C.SUPPLY_FRI,0) SUPPLY_FRI,ISNULL(C.SUPPLY_SAT,0) SUPPLY_SAT,ISNULL(C.SUPPLY_SPL1,0) SUPPLY_SPL1,ISNULL(C.SUPPLY_SPL2,0) SUPPLY_SPL2,
            C.LBL_PRINTNO SUPPLY_SEQ,DBO.CIR_GET_ROUTE_SEQNO(C.COMP_CODE,C.UNIT,C.ROUTE_CODE) ROUTE_SEQ,
            C.ROUTE_CODE,DBO.CIR_GET_NAME_CIR_ROUTE(A.COMP_CODE,A.UNIT,C.ROUTE_CODE,1,@PDATEFORMAT,'','') ROUTE_NAME, 
            C.SUBROUTE_CODE,DBO.CIR_GET_NAME_CIR_SUBROUTE(A.COMP_CODE,A.UNIT,C.ROUTE_CODE,C.SUBROUTE_CODE,1,@PDATEFORMAT,'','') SUBROUTE_NAME,
            C.SUB_SUBROUTE_CODE,DBO.CIR_GET_NAME_CIR_SUBSUBROUTE(A.COMP_CODE,A.UNIT,C.ROUTE_CODE,C.SUBROUTE_CODE,C.SUB_SUBROUTE_CODE,1,@PDATEFORMAT,'','') SUBSUBROUTE_NAME,
            D.DIST_NAME DIST_NAME,ISNULL(P.CIR_SUP_ORDER_LIMIT,0) CIR_SUP_ORDER_LIMIT,C.SUPPLY_TYPE_CODE SUPPLY_TYPE_CODE,B.SUP_TY_NAME SUPPLY_TYPE_NAME,
			C.EDTN EDTN,E.EDTN_NAME EDTN_NAME,B.SUP_SEQ_NO SUP_SEQ_NO
            from cir_agmast a left outer join cir_dist_mast d on a.comp_code=d.comp_code and a.dist_code=d.dist_code,
            cir_supply_type_mast b,cir_supply c,cir_edtn_mast e,preferrences p
            where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=e.comp_code and  a.comp_code= @pcomp_code and p.comp_code= @pcomp_code and
            a.unit=c.unit and a.unit=e.unit_code and a.unit= @punit_code and b.sup_ty_code=c.supply_type_code and
            c.publ=e.publ and c.publ= @ppubl_code and c.edtn=e.edtn and (c.edtn = isnull(@pedtn_code,c.edtn) or @pedtn_code='') and (e.main_edtn = isnull(@pmedtn_code,e.main_edtn) or @pmedtn_code='') and 
            a.agcd=c.agcd and (a.bill_agcd=isnull(@pagcd_code,a.bill_agcd) or @pagcd_code='') and a.dpcd=c.dpcd and (a.bill_dpcd=isnull(@pdpcd_code,a.bill_dpcd) or @pdpcd_code='') and (c.supply_type_code= @psup_type or @psup_type is null or @psup_type='') and 
			(a.state_code=@pstate or @pstate is null or @pstate='') and
            (a.dist_code=@pdistcode or @pdistcode is null  or @pdistcode='') and (a.tehsil_taluka = @ptaluka or @ptaluka is null or @ptaluka='') and
            (a.city_code=@pcitycode or @pcitycode is null) and (a.branch_code = @pbrancode or @pbrancode is null or @pbrancode='') and
            (c.route_code=@proutecode or @proutecode is null) and isnull(c.supply_flag,'N') ='Y' and isnull(a.suspend,'N')='N' and
			(a.ag_type=@pextra1 or @pextra1 is null or @pextra1='') and (a.ag_class=@pextra3 or @pextra3 is null or @pextra3='')
            order by dist_name,agency_name,edtn_name,sup_seq_no,supply_type_name,supply_seq
	End
      else	Begin
          SELECT A.COMP_CODE COMP_CODE,A.UNIT UNIT,A.AGCD AGCD,A.DPCD DPCD,A.AG_NAME AGENCY_NAME,A.AG_NAME_OTH_LANG AGENCY_NAME_OTHER_LANG,A.CITY_CODE CITY_CODE,
            DBO.CIR_GET_CITY(A.COMP_CODE,A.CITY_CODE) CITY_NAME,A.STATION_CODE DROP_POINT_CODE,DBO.CIR_GET_DROP_POINT_NAME(A.COMP_CODE,A.UNIT,A.STATION_CODE,'1') DROP_POINT_NAME,
            ISNULL(C.BASE_SUPPLY,0) BASE_SUPPLY,ISNULL(C.SUPPLY_SUN,0) SUPPLY_SUN,ISNULL(C.SUPPLY_MON,0) SUPPLY_MON,ISNULL(C.SUPPLY_TUE,0) SUPPLY_TUE,ISNULL(C.SUPPLY_WED,0) SUPPLY_WED,
            ISNULL(C.SUPPLY_THU,0) SUPPLY_THU,ISNULL(C.SUPPLY_FRI,0) SUPPLY_FRI,ISNULL(C.SUPPLY_SAT,0) SUPPLY_SAT,ISNULL(C.SUPPLY_SPL1,0) SUPPLY_SPL1,ISNULL(C.SUPPLY_SPL2,0) SUPPLY_SPL2,
            C.LBL_PRINTNO SUPPLY_SEQ,DBO.CIR_GET_ROUTE_SEQNO(C.COMP_CODE,C.UNIT,C.ROUTE_CODE) ROUTE_SEQ,
            C.ROUTE_CODE,DBO.CIR_GET_NAME_CIR_ROUTE(A.COMP_CODE,A.UNIT,C.ROUTE_CODE,1,@PDATEFORMAT,'','') ROUTE_NAME, 
            C.SUBROUTE_CODE,DBO.CIR_GET_NAME_CIR_SUBROUTE(A.COMP_CODE,A.UNIT,C.ROUTE_CODE,C.SUBROUTE_CODE,1,@PDATEFORMAT,'','') SUBROUTE_NAME,
            C.SUB_SUBROUTE_CODE,DBO.CIR_GET_NAME_CIR_SUBSUBROUTE(A.COMP_CODE,A.UNIT,C.ROUTE_CODE,C.SUBROUTE_CODE,C.SUB_SUBROUTE_CODE,1,@PDATEFORMAT,'','') SUBSUBROUTE_NAME,
            D.DIST_NAME DIST_NAME,ISNULL(P.CIR_SUP_ORDER_LIMIT,0) CIR_SUP_ORDER_LIMIT,C.SUPPLY_TYPE_CODE SUPPLY_TYPE_CODE,B.SUP_TY_NAME SUPPLY_TYPE_NAME,
			C.EDTN EDTN,E.EDTN_NAME EDTN_NAME,B.SUP_SEQ_NO SUP_SEQ_NO
            from cir_agmast a left outer join cir_dist_mast d on a.comp_code=d.comp_code and a.dist_code=d.dist_code,cir_supply_type_mast b,cir_supply c,cir_edtn_mast e,preferrences p
			where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=e.comp_code and  a.comp_code= @pcomp_code and p.comp_code= @pcomp_code and
            a.unit=c.unit and a.unit=e.unit_code and a.unit= @punit_code and b.sup_ty_code=c.supply_type_code and
            c.publ=e.publ and c.publ= @ppubl_code and c.edtn=e.edtn and (c.edtn = isnull(@pedtn_code,c.edtn) or @pedtn_code='') and (e.main_edtn = isnull(@pmedtn_code,e.main_edtn) or @pmedtn_code='') and 
            a.agcd=c.agcd and (a.bill_agcd=isnull(@pagcd_code,a.bill_agcd) or @pagcd_code='') and a.dpcd=c.dpcd and (a.bill_dpcd=isnull(@pdpcd_code,a.bill_dpcd) or @pdpcd_code='') and (c.supply_type_code= @psup_type or @psup_type is null or @psup_type='') and 
			(a.state_code=@pstate or @pstate is null or @pstate='') and
            (a.dist_code=@pdistcode or @pdistcode is null  or @pdistcode='') and (a.tehsil_taluka = @ptaluka or @ptaluka is null or @ptaluka='') and
            (a.city_code=@pcitycode or @pcitycode is null) and (a.branch_code = @pbrancode or @pbrancode is null or @pbrancode='') and
            (c.route_code=@proutecode or @proutecode is null) and isnull(c.supply_flag,'N') ='Y' and isnull(a.suspend,'N')='N' and
			(a.ag_type=@pextra1 or @pextra1 is null or @pextra1='') and (a.ag_class=@pextra3 or @pextra3 is null or @pextra3='')
             order by route_seq,supply_seq,agency_name,edtn_name,sup_seq_no,supply_type_name
	End
End
End

                                                                     
                                                                     
                                                                     
                                             
ALTER procedure cir_pending_unsold_approval
    @pcompcode       as varchar(200),
    @punitcode       as varchar(200),
    @pbrancode       as varchar(200),
    @pagcd           as varchar(200),
    @pdpcd           as varchar(200),
    @precptno        as varchar(200), 
    @precptdt        as datetime,
    @puserid         as varchar(200), 
    @pdateformate    as varchar(200),
    @pextra1         as varchar(200),
    @pextra2         as varchar(200),--it is used for agency or distribution
    @pextra3         as varchar(200),
    @pextra4         as varchar(200),
    @pextra5         as varchar(200)
as
    declare @v_recpt_date	datetime;

	declare @v1_recpt_date	datetime;
	declare @v1_supdate		datetime;
	declare @v1_publ		varchar(20)
	declare @v1_edtn		varchar(20)
	declare @v1_copy_rate	numeric(18,2)
	declare @v1_comm_rate	numeric(18,2)
	declare @v1_comm_type	varchar(20)
    declare @v1_waste_alw	varchar(20)
	declare @v1_waste_rate	numeric(18,2) 
	declare @v1_short_recpt	int 
	declare @v1_late_recpt	int 
	declare @v1_bnr			int 
	declare @v1_unsold		int

	declare @v_cnt			int
	declare @v_tot_copy		int
	declare @v_waste_amt	numeric(18,2)
	declare	@v_comm_amt		numeric(18,2)
	declare @v_gross_amt	numeric(18,2)
	declare @v_total_amt	numeric(18,2)
	declare c1 cursor for
	select x.supdate supdate,x.publ publ,x.edtn edtn,x.copy_rate copy_rate,x.comm_rate comm_rate,x.comm_type comm_type,
        x.waste_alw waste_alw,x.waste_rate waste_rate,x.short_recpt short_recpt,x.late_recpt late_recpt,x.bnr bnr,x.unsold unsold 
        from(select supdate,publ,edtn,copy_rate,comm_rate,comm_catg_type comm_type,waste_alw,waste_rate,short_recpt,late_recpt,bnr,unsold 
        from cir_unsold_dtl_dis
        where comp_code=@pcompcode and unit_code=@punitcode and doctype='UCN' and agcd=@pagcd and dpcd=@pdpcd and recptno=@precptno and
        recptdt=@v_recpt_date and (app_userid is null or app_userid='') and (isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))=0 and 
        upper(isnull(@pextra2,'/'))='D'
        union
        select supdate,publ,edtn,copy_rate,comm_rate,comm_catg_type comm_type,waste_alw,waste_rate,short_recpt,late_recpt,bnr,unsold 
        from cir_unsold_dtl 
        where comp_code=@pcompcode and unit_code=@punitcode and doctype='UCN' and agcd=@pagcd and dpcd=@pdpcd and recptno=@precptno and
        recptdt=@v_recpt_date and app_userid is null and (isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))=0 and
        upper(isnull(@pextra2,'/'))!='D') x
        order by supdate,publ,edtn,copy_rate
begin
    set @v_recpt_date=@precptdt
	open c1
	fetch NEXT FROM c1 INTO @v1_recpt_date,@v1_supdate,@v1_publ,@v1_edtn, @v1_copy_rate, @v1_comm_rate,
		@v1_comm_type,@v1_waste_alw,@v1_waste_rate,@v1_short_recpt,@v1_late_recpt,@v1_bnr,@v1_unsold

	WHILE (@@FETCH_STATUS = 0) 
	BEGIN
		set @v_cnt=isnull(@v_cnt,0)+1

        if isnull(@v1_waste_alw,'N')='Y' Begin
            set @v_waste_amt=round((isnull(@v1_unsold,0)*isnull(@v1_waste_rate,0)),2)
			End
        else
			Begin
				set @v_waste_amt=0
			End
        
        set @v_tot_copy=isnull(@v1_short_recpt,0)+isnull(@v1_late_recpt,0)+isnull(@v1_bnr,0)+isnull(@v1_unsold,0);
        
        set @v_gross_amt =isnull(@v_tot_copy,0)*isnull(@v1_copy_rate,0);
        
        if @v1_comm_type='C' Begin--for per copy rate
            set @v_comm_amt  =round((@v_tot_copy*isnull(@v1_comm_rate,0)),2)
			End
        else Begin
            set @v_comm_amt  =round((@v_gross_amt*isnull(@v1_comm_rate,0)/100),2)
        End 

        set @v_total_amt =round((@v_gross_amt-@v_comm_amt-@v_waste_amt),2)
	
		if upper(isnull(@pextra2,'/'))='D' Begin
            update cir_unsold_dtl_dis set apr_short_recpt=isnull(@v1_short_recpt,0), apr_late_recpt=isnull(@v1_late_recpt,0), apr_bnr=isnull(@v1_bnr,0), apr_unsold=isnull(@v1_unsold,0), 
                app_userid=@puserid,app_dt=@v_recpt_date,comm_amt=@v_comm_amt,waste_amt=@v_waste_amt,copy_amt=@v_total_amt
            where comp_code=@pcompcode and unit_code=@punitcode and doctype='UCN' and agcd=@pagcd and dpcd=@pdpcd and recptno=@precptno and
            recptdt=@v_recpt_date and supdate=@v1_supdate and publ=@v1_publ and edtn=@v1_edtn and copy_rate=@v1_copy_rate and 
            (app_userid is null or app_userid='') and (isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))=0
		End
		Else Begin
            update cir_unsold_dtl set apr_short_recpt=isnull(@v1_short_recpt,0), apr_late_recpt=isnull(@v1_late_recpt,0), apr_bnr=isnull(@v1_bnr,0), apr_unsold=isnull(@v1_unsold,0), 
                app_userid=@puserid,app_dt=@v_recpt_date,comm_amt=@v_comm_amt,waste_amt=@v_waste_amt,copy_amt=@v_total_amt
            where comp_code=@pcompcode and unit_code=@punitcode and doctype='UCN' and agcd=@pagcd and dpcd=@pdpcd and recptno=@precptno and
            recptdt=@v_recpt_date and supdate=@v1_supdate and publ=@v1_publ and edtn=@v1_edtn and copy_rate=@v1_copy_rate and 
            (app_userid is null or app_userid='') and (isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))=0
		End
	
	fetch NEXT FROM c1 INTO @v1_recpt_date,@v1_supdate,@v1_publ,@v1_edtn, @v1_copy_rate, @v1_comm_rate,
		@v1_comm_type,@v1_waste_alw,@v1_waste_rate,@v1_short_recpt,@v1_late_recpt,@v1_bnr,@v1_unsold
	End
	Close c1
	if upper(isnull(@pextra2,'/'))='D' Begin
		update cir_unsold_hdr_dis set app_userid=@puserid,app_dt=@v_recpt_date
                where comp_code=@pcompcode and unit_code=@punitcode and doctype='UCN' and agcd=@pagcd and dpcd=@pdpcd and recptno=@precptno and
                recptdt=@v_recpt_date and (app_userid is null or app_userid='')
	End
	Else Begin
		update cir_unsold_hdr set app_userid=@puserid,app_dt=@v_recpt_date
                where comp_code=@pcompcode and unit_code=@punitcode and doctype='UCN' and agcd=@pagcd and dpcd=@pdpcd and recptno=@precptno and
                recptdt=@v_recpt_date and (app_userid is null or app_userid='')
	End
	deallocate c1
end



                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE cir_unsold_credit_note_cir_unsold_calculation_p
      @pcomp_code        as varchar(20),
      @punit_code        as varchar(20),
      @ppubl_code        as varchar(20),
      @pedtn_code        as varchar(20),
      @pmissing_recpt    as numeric(10),
      @plate_recpt       as numeric(10),
      @pbnr_recpt        as numeric(10),
      @punsold           as numeric(10),
      @pcopy_rate        as float,
      @pcomm_per         as float,
      @pcomm_type        as varchar(20),
      @pwaste_flag       as varchar(20),
      @pwaste_rate       as float,
      @pdateformat       as varchar(20),
      @pextra1           as varchar(50),
      @pextra2           as varchar(50)
AS 
Begin
	DECLARE @v_tot_copy			NUMERIC(10)
	DECLARE @v_waste_amt        NUMERIC(15,2)
	DECLARE @v_gross_amt        NUMERIC(15,2)
	DECLARE @v_comm_amt         NUMERIC(15,2)
	DECLARE @v_total_amt        NUMERIC(15,2)
    If isnull(@pwaste_flag,'N')='Y' Begin
        set @v_waste_amt=round((isnull(@punsold,0)*isnull(@pwaste_rate,0)),2)
	End
    Else Begin
        set @v_waste_amt=0
    End
    
    set @v_tot_copy=isnull(@pmissing_recpt,0)+isnull(@plate_recpt,0)+isnull(@pbnr_recpt,0)+isnull(@punsold,0)
    
    set @v_gross_amt =isnull(@v_tot_copy,0)*isnull(@pcopy_rate,0)

    If @pcomm_type='C' Begin--for per copy rate
        set @v_comm_amt  =round((@v_tot_copy*isnull(@pcomm_per,0)),2)
	End
    Else Begin
        set @v_comm_amt  =round((@v_gross_amt*isnull(@pcomm_per,0)/100),2)
    End

    set @v_total_amt =round((@v_gross_amt-@v_comm_amt-@v_waste_amt),2)
    
    SELECT @v_tot_copy as "TOTAL_COPY" ,@v_waste_amt as "WASTE_AMOUNT" ,@v_comm_amt as "COMM_AMOUNT" ,@v_total_amt as "TOTAL_AMOUNT"
	--SET @v_query  = 'SELECT' + @v_tot_copy + 'as "TOTAL_COPY" ,' + @v_waste_amt + ' as "WASTE_AMOUNT" ,' + @v_comm_amt + ' as "COMM_AMOUNT" ,' + @v_total_amt + ' as "TOTAL_AMOUNT"' + ' FROM DUAL' 
	--PRINT (@v_query) 
    --EXEC (@v_query) 

End
                                                                     
                                                                     
                                                                     
                                             
ALTER procedure cir_pending_unsold_supply
    @pcompcode       as varchar(200),
    @punitcode       as varchar(200),
    @pbrancode       as varchar(200),
    @pagcd           as varchar(200),
    @pdpcd           as varchar(200),
    @pfromdate       as varchar(200), 
    @ptilldate       as varchar(200),
    @puserid         as varchar(200), 
    @pdateformate    as varchar(200),
    @pextra1         as varchar(200),
    @pextra2         as varchar(200),--it is used for agency or distribution
    @pextra3         as varchar(200),
    @pextra4         as varchar(200),
    @pextra5         as varchar(200)
as
    declare @v_from_date     datetime
    declare @v_till_date     datetime
begin
    set @v_from_date=DBO.CONVERT_USER_DATE('/', @pfromdate,@pdateformate)
    set @v_till_date=DBO.CONVERT_USER_DATE('/', @ptilldate,@pdateformate)
    
    if upper(isnull(@pextra2,'/'))='D' Begin
		select h.comp_code comp_code,h.unit_code unit_code,h.agcd agcd,h.dpcd dpcd,m.ag_name agency_name,m.city_code city_code,
			dbo.cir_get_city(h.comp_code,m.city_code) city_name,h.doctype doctype,h.recptno recptno,h.recptdt recptdt,
			sum(d.copy_amt) net_amt,sum(isnull(d.short_recpt,0)+isnull(d.late_recpt,0)+isnull(d.bnr,0)+isnull(d.unsold,0)) net_unsold
			from cir_unsold_hdr_dis h,cir_unsold_dtl_dis d,cir_agmast_dis m
			where h.comp_code=d.comp_code and h.comp_code=m.comp_code and h.comp_code=@pcompcode and 
				h.unit_code=d.unit_code and h.unit_code=m.unit and h.unit_code=@punitcode and h.doctype=d.doctype and h.agcd=d.agcd and h.agcd=m.agcd and 
				h.dpcd=d.dpcd and h.dpcd=m.dpcd and (h.agcd=@pagcd or @pagcd is null or @pagcd='') and (h.dpcd=@pdpcd or @pdpcd is null or @pdpcd='') and
				h.recptdt=d.recptdt and h.recptdt>=@v_from_date and h.recptdt<=@v_till_date and h.recptno=d.recptno and (d.branch_code=@pbrancode or @pbrancode is null or @pbrancode='') and
				(d.app_userid is null or d.app_userid='') and (isnull(d.apr_short_recpt,0)+isnull(d.apr_late_recpt,0)+isnull(d.apr_bnr,0)+isnull(d.apr_unsold,0))=0
			group by h.comp_code,h.unit_code,h.agcd,h.dpcd,m.ag_name,m.city_code,h.doctype,h.recptno,h.recptdt
			order by h.recptdt,h.recptno,agency_name;       
	End
	Else Begin
		select h.comp_code comp_code,h.unit_code unit_code,h.agcd agcd,h.dpcd dpcd,m.ag_name agency_name,m.city_code city_code,
			dbo.cir_get_city(h.comp_code,m.city_code) city_name,h.doctype doctype,h.recptno recptno,h.recptdt recptdt,
			sum(d.copy_amt) net_amt,sum(isnull(d.short_recpt,0)+isnull(d.late_recpt,0)+isnull(d.bnr,0)+isnull(d.unsold,0)) net_unsold
			from cir_unsold_hdr h,cir_unsold_dtl d,cir_agmast m
			where h.comp_code=d.comp_code and h.comp_code=m.comp_code and h.comp_code=@pcompcode and 
				h.unit_code=d.unit_code and h.unit_code=m.unit and h.unit_code=@punitcode and h.doctype=d.doctype and h.agcd=d.agcd and h.agcd=m.agcd and 
				h.dpcd=d.dpcd and h.dpcd=m.dpcd and (h.agcd=@pagcd or @pagcd is null or @pagcd='') and (h.dpcd=@pdpcd or @pdpcd is null or @pdpcd='') and
				h.recptdt=d.recptdt and h.recptdt>=@v_from_date and h.recptdt<=@v_till_date and h.recptno=d.recptno and (d.branch_code=@pbrancode or @pbrancode is null or @pbrancode='') and
				(d.app_userid is null or d.app_userid='') and (isnull(d.apr_short_recpt,0)+isnull(d.apr_late_recpt,0)+isnull(d.apr_bnr,0)+isnull(d.apr_unsold,0))=0
			group by h.comp_code,h.unit_code,h.agcd,h.dpcd,m.ag_name,m.city_code,h.doctype,h.recptno,h.recptdt
			order by h.recptdt,h.recptno,agency_name
	End
End
                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE cir_unsold_credit_note_cir_notapproval_unsold_p
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@pdoc_type                                VARCHAR(20) ,
	@precptno                                 VARCHAR(20) ,
	@pagcd_code                               VARCHAR(20) ,
	@pdpcd_code                               VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(40) ,
	@pextra2                                  VARCHAR(40) 
AS 
Begin
	if UPPER(@pextra2)='D' Begin
		SELECT * FROM  cir_unsold_dtl_dis
		WHERE comp_code  = @pcomp_code AND unit_code  = @punit_code
		 AND doctype  = @pdoc_type AND	recptno  = @precptno
		 AND agcd  = @pagcd_code AND	dpcd  = @pdpcd_code
		ORDER BY recptdt, recptno, supdate 
	End
	Else Begin
		SELECT * FROM  cir_unsold_dtl 
		WHERE comp_code  = @pcomp_code AND unit_code  = @punit_code
		 AND doctype  = @pdoc_type AND recptno  = @precptno
		 AND agcd  = @pagcd_code AND dpcd  = @pdpcd_code
		ORDER BY recptdt,recptno,supdate 
	End
End

                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE cir_unsold_credit_note_cir_notapproval_list_p
	@pcomp_code    as varchar(50),
	@punit_code    as varchar(50),
	@pdoc_type     As varchar(50),
	@pdateformat   as varchar(50),
	@pextra1       as varchar(50),
	@pextra2       As varchar(50)
As
Begin
    If upper(@pextra2)='D' Begin
        SELECT DISTINCT H.RECPTNO RECPTNO,H.RECPTDT RECPTDT,H.AGCD AGCD,H.DPCD DPCD,M.AG_NAME AGENCY_NAME,
        DBO.CIR_GET_CITY(H.COMP_CODE,M.CITY_CODE) CITY_NAME,H.PUBL PUBL,DBO.CIR_GET_PUBL_NAME(H.COMP_CODE,H.PUBL) PUBL_NAME,H.EDTN EDTN,
        DBO.CIR_GET_EDTN_NAME(H.COMP_CODE,H.EDTN) EDTN_NAME,H.ENTRYDT ENTRYDT,H.FRDT FRDT,H.TODT TODT
        from cir_unsold_hdr_dis h,cir_agmast_dis m
        where h.comp_code=m.comp_code and h.comp_code=@pcomp_code and h.unit_code=m.unit and h.unit_code=@punit_code and h.doctype=@pdoc_type and 
        h.agcd=m.agcd and h.dpcd=m.dpcd and (upper(m.ag_name) like upper(@pextra1)+'%' or @pextra1 is null or @pextra1='') and (h.app_userid is null or h.app_userid='')
        order by recptdt,recptno,agency_name
	End
    Else Begin
        SELECT DISTINCT H.RECPTNO RECPTNO,H.RECPTDT RECPTDT,H.AGCD AGCD,H.DPCD DPCD,M.AG_NAME AGENCY_NAME,
        DBO.CIR_GET_CITY(H.COMP_CODE,M.CITY_CODE) CITY_NAME,H.PUBL PUBL,DBO.CIR_GET_PUBL_NAME(H.COMP_CODE,H.PUBL) PUBL_NAME,H.EDTN EDTN,
        DBO.CIR_GET_EDTN_NAME(H.COMP_CODE,H.EDTN) EDTN_NAME,H.ENTRYDT ENTRYDT,H.FRDT FRDT,H.TODT TODT
        from cir_unsold_hdr h,cir_agmast m
        where h.comp_code=m.comp_code and h.comp_code=@pcomp_code and h.unit_code=m.unit and h.unit_code=@punit_code and h.doctype=@pdoc_type and 
        h.agcd=m.agcd and h.dpcd=m.dpcd and (upper(m.ag_name) like upper(@pextra1)+'%' or @pextra1 is null or @pextra1='') and (h.app_userid is null or h.app_userid='')
        order by recptdt,recptno,agency_name
      End
end

                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE  cir_supply_edtnbind
	@pcompcode		as varchar(200),
	@punitcode		as varchar(200),
	@ppublcode		as varchar(200),
	@pagencycode	as varchar(200),
	@pagencysubcode as varchar(200),
	@pdateformat	as	varchar(200),
	@pextra1		as	varchar(200),
	@pextra2		as varchar(200)
AS
	if UPPER(@pextra2)='D' Begin
		select distinct a.publ PUBL,b.publ_name PUBL_NAME,a.edtn EDTN,c.edtn_name EDTN_NAME
  		     from cir_supply_dis a,cir_publ_mast b ,cir_edtn_mast c
  		          where a.comp_code=b.comp_code and a.comp_code=c.comp_code and 
						a.comp_code=@pcompcode and
  					    a.unit=c.unit_code and a.unit=@punitcode and 
                        a.publ=b.publ and a.publ=c.publ and 
                        (a.publ=@ppublcode or @ppublcode is null) and
						a.edtn=c.edtn and 
  					    a.agcd=@pagencycode and a.dpcd=@pagencysubcode and
                         ISNULL(b.freeze_flag,'N')='N' and ISNULL(c.freeze_flag,'N')='N'
	End
    Else Begin
		select distinct a.publ PUBL,b.publ_name PUBL_NAME,a.edtn EDTN,c.edtn_name EDTN_NAME
  		     from cir_supply a,cir_publ_mast b ,cir_edtn_mast c
  		          where a.comp_code=b.comp_code and a.comp_code=c.comp_code and 
						a.comp_code=@pcompcode and
  					    a.unit=c.unit_code and a.unit=@punitcode and 
                        a.publ=b.publ and a.publ=c.publ and 
                        (a.publ=@ppublcode or @ppublcode is null) and
						a.edtn=c.edtn and 
  					    a.agcd=@pagencycode and a.dpcd=@pagencysubcode and
                         ISNULL(b.freeze_flag,'N')='N' and ISNULL(c.freeze_flag,'N')='N'

	End

                                                                     


/***************************laxman sir 4768    21/09/2011*******************************************/



                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE cir_unsold_credit_note_cir_unsold_supply_p
	@pcomp_code			as varchar(40),
	@punit_code			as varchar(40),
	@ppubl_code			as varchar(40),
	@pedtn_code			as varchar(40),
	@psup_fromdate		as datetime,
	@psup_todate        as datetime,
	@pagcd_code			as varchar(20),
	@pdpcd_code			as varchar(20),
	@pdateformat        as varchar(20),
	@pextra1            as varchar(20),--it is use for datewise or ratewise
	@pextra2            as varchar(20)
As
Begin
	if upper(@pextra2)='D' Begin
		select z.comp_code AS "COMP_CODE",z.unit_code AS "UNIT_CODE",z.publ AS "PUBL",z.publ_name AS "PUBL_NAME",z.edtn AS "EDTN" , z.edtn_name AS "EDTN_NAME",
		z.supply_date AS "SUPPLY_DATE", z.supply_date AS "SUPPLY_DATEMON",z.copy_rate AS "COPY_RATE",z.comm_fix_auto_spl AS "COMM_FIX_AUTO_SPL" ,z.comm_code AS "COMM_CODE",z.waste_rate AS "WASTE_RATE",
        substring(z.comm_rate,1,1) AS "COMM_CATEG_TYPE",substring(z.comm_rate,2,len(z.comm_rate)-1) AS "COMM_RATE",z.supply_copy AS "SUPPLY_COPY",z.rate_supply AS "RATE_SUPPLY" from--P30,C0.5
        (select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,p.publ_name publ_name,
        d.edtn edtn,edition_nick edtn_name,d.supdate supply_date,
        d.sup_rate copy_rate,d.comm_fix_auto_spl comm_fix_auto_spl,d.comm_code comm_code,
		dbo.cir_get_waste_rate(d.comp_code,d.unit_code,d.edtn,supdate,''''+@pdateformat+'''') waste_rate,
        dbo.cir_get_commission(d.comp_code,d.unit_code,d.publ,d.edtn,d.comm_fix_auto_spl ,d.comm_code,d.supdate,''''+@pdateformat+'''',sum(d.sup_copy),'','') comm_rate,
		'P' comm_catg_type, sum(d.sup_copy) supply_copy,sum(d.sup_copy) rate_supply
        from cir_dbksup_dis d,cir_publ_mast p,cir_edtn_mast e
        where d.comp_code=@pcomp_code and d.comp_code=p.comp_code and d.comp_code=e.comp_code and
              d.unit_code=@punit_code and d.publ=p.publ and d.publ=e.publ and
              (d.publ=@ppubl_code or @ppubl_code is null or @ppubl_code='') and
              d.edtn=e.edtn and (d.edtn = @pedtn_code or @pedtn_code is null or @pedtn_code='') and
            d.supdate between @psup_fromdate and @psup_todate and
            d.billagcd=@pagcd_code and d.billdpcd=@pdpcd_code and upper(isnull(@pextra1,'D'))='D'
            group by d.comp_code,d.unit_code,d.publ,p.publ_name,e.edition_nick,d.edtn,d.supdate,d.sup_rate,d.comm_fix_auto_spl,d.comm_code)z
        union
        select distinct z.comp_code AS "COMP_CODE",z.unit_code AS "UNIT_CODE",z.publ AS "PUBL",z.publ_name AS "PUBL_NAME",z.edtn AS "EDTN",z.edtn_name AS "EDTN_NAME",
		MAX(z.supply_date) AS "SUPPLY_DATE",dbo.GetLastDayOfMonth(z.supply_date) AS "SUPPLY_DATEMON",
        z.copy_rate AS "COPY_RATE",z.comm_fix_auto_spl AS "COMM_FIX_AUTO_SPL",z.comm_code AS "COMM_CODE",z.waste_rate AS "WASTE_RATE",
        z.comm_catg_type AS "COMM_CATEG_TYPE",z.comm_rate AS "COMM_RATE",sum(z.supply_copy) AS "SUPPLY_COPY",sum(z.supply_copy) rate_supply from
        (select distinct y.comp_code,y.unit_code,y.publ,y.publ_name,y.edtn,y.edtn_name,y.supply_date,y.copy_rate,y.comm_fix_auto_spl,y.comm_code,y.waste_rate,
        substring(y.comm_rate,1,1) comm_catg_type,substring(y.comm_rate,2,len(y.comm_rate)-1) comm_rate,y.supply_copy,y.rate_supply from--P30,C0.5
        (select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,p.publ_name publ_name,
        d.edtn edtn,edition_nick edtn_name,d.supdate supply_date,
        d.sup_rate copy_rate,d.comm_fix_auto_spl comm_fix_auto_spl,d.comm_code comm_code,
		dbo.cir_get_waste_rate(d.comp_code,d.unit_code,d.edtn,d.supdate,''''+@pdateformat+'''') waste_rate,
        dbo.cir_get_commission(d.comp_code,d.unit_code,d.publ,d.edtn,d.comm_fix_auto_spl ,d.comm_code,d.supdate,''''+@pdateformat+'''',sum(d.sup_copy),'','') comm_rate,'P' comm_catg_type, 
		sum(d.sup_copy) supply_copy,
        (select sum(u.sup_copy) from cir_dbksup_dis u where u.comp_code=d.comp_code and u.unit_code=d.unit_code and 
        (u.publ=d.publ) and u.edtn=d.edtn and u.supdate between @psup_fromdate and @psup_todate and 
        u.billagcd=@pagcd_code and u.billdpcd=@pdpcd_code and u.sup_rate=d.sup_rate) rate_supply
        from cir_dbksup_dis d,cir_publ_mast p,cir_edtn_mast e
        where d.comp_code=@pcomp_code and d.comp_code=p.comp_code and d.comp_code=e.comp_code and
              d.unit_code=@punit_code and d.publ=p.publ and d.publ=e.publ and
              (d.publ=@ppubl_code or @ppubl_code is null or @ppubl_code='') and
              d.edtn=e.edtn and (d.edtn = @pedtn_code or @pedtn_code is null or @pedtn_code='') and
            d.supdate between @psup_fromdate and @psup_todate and
            d.billagcd=@pagcd_code and d.billdpcd=@pdpcd_code and upper(isnull(@pextra1,'D'))='R'
            group by d.comp_code,d.unit_code,d.publ,p.publ_name,e.edition_nick,d.edtn,d.supdate,d.sup_rate,d.comm_fix_auto_spl,d.comm_code)y) z
            group by z.comp_code,z.unit_code,z.publ,z.publ_name,z.edtn,z.edtn_name,dbo.GetLastDayOfMonth(z.supply_date),
                z.copy_rate,z.comm_fix_auto_spl,z.comm_code,z.waste_rate,z.comm_catg_type,z.comm_rate
			order by publ_name,edtn,supply_date
	End
	Else Begin
            select z.comp_code AS "COMP_CODE",z.unit_code AS "UNIT_CODE",z.publ AS "PUBL",z.publ_name AS "PUBL_NAME",z.edtn AS "EDTN",z.edtn_name AS "EDTN_NAME",
			z.supply_date AS "SUPPLY_DATE",z.supply_date AS "SUPPLY_DATEMON",
            z.copy_rate AS "COPY_RATE",z.comm_fix_auto_spl AS "COMM_FIX_AUTO_SPL",z.comm_code AS "COMM_CODE",z.waste_rate AS "WASTE_RATE",
            substring(z.comm_rate,1,1) AS "COMM_CATEG_TYPE",substring(z.comm_rate,2,len(z.comm_rate)-1) AS "COMM_RATE",z.supply_copy AS "SUPPLY_COPY",z.rate_supply AS "RATE_SUPPLY" from--P30,C0.5
            (select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,p.publ_name publ_name,
            d.edtn edtn,edition_nick edtn_name,d.supdate supply_date,
            d.sup_rate copy_rate,d.comm_fix_auto_spl comm_fix_auto_spl,d.comm_code comm_code,
			dbo.cir_get_waste_rate(d.comp_code,d.unit_code,d.edtn,supdate,''''+@pdateformat+'''') waste_rate,
            dbo.cir_get_commission(d.comp_code,d.unit_code,d.publ,d.edtn,d.comm_fix_auto_spl ,d.comm_code,d.supdate,''''+@pdateformat+'''',sum(d.sup_copy),'','') comm_rate,
			'P' comm_catg_type, sum(d.sup_copy) supply_copy,sum(d.sup_copy) rate_supply
            from cir_dbksup d,cir_publ_mast p,cir_edtn_mast e
            where d.comp_code=@pcomp_code and d.comp_code=p.comp_code and d.comp_code=e.comp_code and
                  d.unit_code=@punit_code and d.publ=p.publ and d.publ=e.publ and
                  (d.publ=@ppubl_code or @ppubl_code is null or @ppubl_code='') and
                  d.edtn=e.edtn and (d.edtn = @pedtn_code or @pedtn_code is null or @pedtn_code='') and
                d.supdate between @psup_fromdate and @psup_todate and
                d.billagcd=@pagcd_code and d.billdpcd=@pdpcd_code and upper(isnull(@pextra1,'D'))='D'
                group by d.comp_code,d.unit_code,d.publ,p.publ_name,e.edition_nick,d.edtn,d.supdate,d.sup_rate,d.comm_fix_auto_spl,d.comm_code) z
            union
            select distinct z.comp_code AS "COMP_CODE",z.unit_code AS "UNIT_CODE",z.publ AS "PUBL",z.publ_name AS "PUBL_NAME",z.edtn AS "EDTN",z.edtn_name AS "EDTN_NAME",
			MAX(z.supply_date) AS "SUPPLY_DATE",dbo.GetLastDayOfMonth(z.supply_date) AS "SUPPLY_DATEMON",
            z.copy_rate AS "COPY_RATE",z.comm_fix_auto_spl AS "COMM_FIX_AUTO_SPL",z.comm_code AS "COMM_CODE",z.waste_rate AS "WASTE_RATE",
            z.comm_catg_type AS "COMM_CATEG_TYPE",z.comm_rate AS "COMM_RATE",sum(z.supply_copy) AS "SUPPLY_COPY",sum(z.supply_copy) AS "RATE_SUPPLY" from
            (select distinct y.comp_code,y.unit_code,y.publ,y.publ_name,y.edtn,y.edtn_name,y.supply_date,y.copy_rate,y.comm_fix_auto_spl,y.comm_code,y.waste_rate,
            substring(y.comm_rate,1,1) comm_catg_type,substring(y.comm_rate,2,len(y.comm_rate)-1) comm_rate,y.supply_copy,y.rate_supply from--P30,C0.5
            (select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,p.publ_name publ_name,d.edtn edtn,edition_nick edtn_name,d.supdate supply_date,
            d.sup_rate copy_rate,d.comm_fix_auto_spl comm_fix_auto_spl,d.comm_code comm_code,
			dbo.cir_get_waste_rate(d.comp_code,d.unit_code,d.edtn,d.supdate,''''+@pdateformat+'''') waste_rate,
            dbo.cir_get_commission(d.comp_code,d.unit_code,d.publ,d.edtn,d.comm_fix_auto_spl ,d.comm_code,d.supdate,''''+@pdateformat+'''',sum(d.sup_copy),'','') comm_rate,
			'P' comm_catg_type, sum(d.sup_copy) supply_copy,
            (select sum(u.sup_copy) from cir_dbksup u where u.comp_code=d.comp_code and u.unit_code=d.unit_code and 
            (u.publ=d.publ) and u.edtn=d.edtn and u.supdate between @psup_fromdate and @psup_todate and 
            u.billagcd=@pagcd_code and u.billdpcd=@pdpcd_code and u.sup_rate=d.sup_rate) rate_supply
            from cir_dbksup d,cir_publ_mast p,cir_edtn_mast e
            where d.comp_code=@pcomp_code and d.comp_code=p.comp_code and d.comp_code=e.comp_code and
                  d.unit_code=@punit_code and d.publ=p.publ and d.publ=e.publ and
                  (d.publ=@ppubl_code or @ppubl_code is null or @ppubl_code='') and
                  d.edtn=e.edtn and (d.edtn = @pedtn_code or @pedtn_code is null or @pedtn_code='') and
                d.supdate between @psup_fromdate and @psup_todate and
                d.billagcd=@pagcd_code and d.billdpcd=@pdpcd_code and upper(isnull(@pextra1,'D'))='R'
                group by d.comp_code,d.unit_code,d.publ,p.publ_name,e.edition_nick,d.edtn,d.supdate,d.sup_rate,d.comm_fix_auto_spl,d.comm_code) y) z
                group by z.comp_code,z.unit_code,z.publ,z.publ_name,z.edtn,z.edtn_name,dbo.GetLastDayOfMonth(z.supply_date),
                    z.copy_rate,z.comm_fix_auto_spl,z.comm_code,z.waste_rate,z.comm_catg_type,z.comm_rate
                order by publ_name,edtn,supply_date
	End
End

                                                                     
                                                                     
                                                                     
                                             
ALTER FUNCTION cir_get_waste_rate
(@pcomp_code                               VARCHAR(20) ,
 @punit_code                               VARCHAR(20) ,
 @pedtn_code                               VARCHAR(20) ,
 @psup_date                                DATETIME  ,
 @pdateformat                              VARCHAR(20) )
RETURNS  NUMERIC(10,4) 
AS 

BEGIN
	DECLARE @v_publ		VARCHAR(20) 
	
	SELECT DISTINCT @v_publ=publ FROM  cir_edtn_mast WHERE comp_code  = @pcomp_code AND	edtn  = @pedtn_code

	DECLARE @Vsun_rate1    NUMERIC(15,4)
	DECLARE @Vmon_rate1    NUMERIC(15,4)
	DECLARE @Vtue_rate1    NUMERIC(15,4)
	DECLARE @Vwed_rate1    NUMERIC(15,4)
	DECLARE @Vthu_rate1    NUMERIC(15,4)
	DECLARE @Vfri_rate1    NUMERIC(15,4)
	DECLARE @Vsat_rate1    NUMERIC(15,4)
	DECLARE @v_edtn_rate   NUMERIC(15,4) 

	DECLARE cur_rate cursor FOR 
    	SELECT sun_rate, mon_rate, tue_rate, wed_rate, thu_rate, fri_rate, sat_rate
		FROM  cir_waste_rate_mast WHERE comp_code  = @pcomp_code AND unit_code = @punit_code AND publ  = @v_publ
		AND	edtn  = @pedtn_code AND	valid_from  =(SELECT MAX(valid_from) FROM  cir_waste_rate_mast 
		WHERE comp_code  = @pcomp_code AND	unit_code  = @punit_code AND 
			publ  = @v_publ AND	edtn  = @pedtn_code AND	valid_from  <= @psup_date)

	set @v_edtn_rate=0

	OPEN cur_rate 
	fetch NEXT FROM cur_rate INTO @Vsun_rate1,@Vmon_rate1, @Vtue_rate1,@Vwed_rate1,@Vthu_rate1 ,@Vfri_rate1 ,@Vsat_rate1
	close cur_rate
		
    DECLARE @SUP_DAY    varchar(20)
														 
	SET  @SUP_DAY = CONVERT(VARCHAR(20) , DATENAME(WEEKDAY, @psup_date),20)

	IF (@SUP_DAY = 'Sunday' ) BEGIN 
			---for sunday edition rate
			SET @v_edtn_rate  =  @Vsun_rate1 
	END
	ELSE IF (@SUP_DAY = 'Monday') BEGIN 
			---for monday edition rate
			SET @v_edtn_rate  =   @Vmon_rate1
	END
	ELSE IF (@SUP_DAY = 'Tuesday') BEGIN 
			---for tueday edition rate
			SET @v_edtn_rate  =   @Vtue_rate1
	END
	ELSE IF (@SUP_DAY = 'Wednesday') BEGIN 
			---for wednesday edition rate
			SET @v_edtn_rate  =   @Vwed_rate1
	END
	ELSE IF (@SUP_DAY = 'Thursday') BEGIN 
			---for Thursday edition rate
			SET @v_edtn_rate  =  @Vthu_rate1
	END
	ELSE IF (@SUP_DAY = 'Friday' ) BEGIN 
			---for friday edition rate
			SET @v_edtn_rate  =  @Vfri_rate1
	END
	ELSE IF (@SUP_DAY = 'Saturday') BEGIN 
			---for saturday edition rate
			SET @v_edtn_rate  =   @Vsat_rate1
	END
	ELSE BEGIN 
			SET @v_edtn_rate  = 0 
	END
	
	DEALLOCATE cur_rate

	return @v_edtn_rate
END

                                                                     
                                                                     
                                                                     
                                             
ALTER FUNCTION cir_get_commission
(	@pcomp_code			VARCHAR(40) ,
	@punit_code         VARCHAR(40) ,
	@ppubl_cd           VARCHAR(40) ,
	@pedtn_cd           VARCHAR(40) ,
	@pcomm_ty           VARCHAR(40) ,
	@pcomm_catg_cd      VARCHAR(40) ,
	@pvaild_from        DATETIME,
	@pdateformat        VARCHAR(40) ,
	@pavg_copy          NUMERIC(20,0),
	@pextra1            VARCHAR(40) ,
	@pextra2            VARCHAR(40))
RETURNS VARCHAR(100) AS 
BEGIN
	declare @v_comp_code1			VARCHAR(20)
	declare @v_unit_code1			VARCHAR(20)
	declare @v_publ1				VARCHAR(20)
	declare @v_edtn1				VARCHAR(20)
	declare @v_comm_code1			VARCHAR(20)
	declare @v_comm_type1			VARCHAR(20)
	declare @v_valid_form1			DATETIME
	declare @v_sup_copy_from1		NUMERIC(20,0)
	declare @v_sup_copy_to1			NUMERIC(20,0)
	declare @v_sun_comm_rate1		NUMERIC(20,4)
	declare @v_mon_comm_rate1		NUMERIC(20,4)
	declare @v_tue_comm_rate1		NUMERIC(20,4)
	declare @v_wed_comm_rate1		NUMERIC(20,4)
	declare @v_thu_comm_rate1		NUMERIC(20,4)
	declare @v_fri_comm_rate1		NUMERIC(20,4)
	declare @v_sat_comm_rate1		NUMERIC(20,4)
	declare @v_userid1				VARCHAR(20)
	declare @v_freezeflag1			VARCHAR(20)
	declare @v_creation_date1		DATETIME
	declare @v_comm_catg_code1		VARCHAR(20)
	declare @v_comm_catg_type1		VARCHAR(20)

	DECLARE comm_fix_spl cursor LOCAL FOR 
	SELECT comp_code, unit_code, publ, edtn, comm_code, comm_type, valid_from, sup_copy_from, sup_copy_to, sun_comm_rate, mon_comm_rate, tue_comm_rate, wed_comm_rate, thu_comm_rate, fri_comm_rate, sat_comm_rate, 
		userid, freeze_flag, creation_date, comm_catg_code, comm_catg_type
	 FROM  cir_comm_mast 
	WHERE comp_code  = @pcomp_code AND unit_code  = @punit_code AND publ  = @ppubl_cd AND 
		edtn  = @pedtn_cd AND comm_type  = @pcomm_ty AND comm_catg_code  = @pcomm_catg_cd AND 
		valid_from  =(SELECT MAX(valid_from) FROM  cir_comm_mast 
		WHERE comp_code  = @pcomp_code AND	unit_code  = @punit_code AND 
			publ  = @ppubl_cd AND	edtn  = @pedtn_cd AND comm_type  = @pcomm_ty AND 
			comm_catg_code  = @pcomm_catg_cd AND valid_from  <= @pvaild_from)

	DECLARE @rec_comm_fix_spl	VARCHAR(200) 
	DECLARE @vcomm_per          FLOAT                           
	SET @vcomm_per = 0 
	DECLARE @avg_sup            INT 

	declare @v_comp_code2         VARCHAR(20)
	declare @v_unit_code2         VARCHAR(20)
	declare @v_publ2              VARCHAR(20)
	declare @v_edtn2              VARCHAR(20)
	declare @v_comm_code2         VARCHAR(20)
	declare @v_comm_type2         VARCHAR(20)
	declare @v_valid_form2        DATETIME
	declare @v_sup_copy_from2     NUMERIC(20,0)
	declare @v_sup_copy_to2       NUMERIC(20,0)
	declare @v_sun_comm_rate2     NUMERIC(20,4)
	declare @v_mon_comm_rate2     NUMERIC(20,4)
	declare @v_tue_comm_rate2     NUMERIC(20,4)
	declare @v_wed_comm_rate2     NUMERIC(20,4)
	declare @v_thu_comm_rate2     NUMERIC(20,4)
	declare @v_fri_comm_rate2     NUMERIC(20,4)
	declare @v_sat_comm_rate2     NUMERIC(20,4)
	declare @v_userid2            VARCHAR(20)
	declare @v_freezeflag2        VARCHAR(20)
	declare @v_creation_date2     DATETIME
	declare @v_comm_catg_code2    VARCHAR(20)
	declare @v_comm_catg_type2    VARCHAR(20)

	DECLARE comm_auto cursor LOCAL FOR 
	SELECT * FROM  cir_comm_mast 
	WHERE comp_code  = @pcomp_code AND unit_code  = @punit_code
	 AND publ  = @ppubl_cd AND edtn  = @pedtn_cd
	 AND comm_type  = @pcomm_ty AND comm_catg_code  = @pcomm_catg_cd
	 AND valid_from  =( SELECT MAX(valid_from) FROM  cir_comm_mast 
		WHERE comp_code  = @pcomp_code AND unit_code  = @punit_code AND publ  = @ppubl_cd
		 AND edtn  = @pedtn_cd AND comm_type  = @pcomm_ty AND comm_catg_code  = @pcomm_catg_cd
		 AND valid_from  <= @pvaild_from AND @avg_sup  between ISNULL(sup_copy_from, 0)  and  ISNULL(sup_copy_to, 0))
		AND	@avg_sup  between ISNULL(sup_copy_from, 0)  and  ISNULL(sup_copy_to, 0)
		
		DECLARE @rec_comm_auto		VARCHAR(200)
		DECLARE @v_comm             VARCHAR(20) 

		DECLARE @SUP_DAY11  varchar(20)
		SET  @SUP_DAY11 = CONVERT(VARCHAR(20) , DATENAME(WEEKDAY, @pvaild_from),20)
		IF UPPER(@pcomm_ty)= 'A' BEGIN 
			SET @avg_sup  = @pavg_copy 
			IF @avg_sup > 0 BEGIN 

				OPEN comm_auto 
				fetch NEXT FROM comm_auto INTO  @v_comp_code2 ,@v_unit_code2, @v_publ2,@v_edtn2,
                @v_comm_code2,@v_comm_type2,@v_valid_form2,@v_sup_copy_from2 , @v_sup_copy_to2 ,@v_sun_comm_rate2 ,
                @v_mon_comm_rate2, @v_tue_comm_rate2,@v_wed_comm_rate2,@v_thu_comm_rate2, @v_fri_comm_rate2,@v_sat_comm_rate2,
				@v_userid2,@v_freezeflag2 ,@v_creation_date2 ,@v_comm_catg_code2 , @v_comm_catg_type2
			
				IF (@SUP_DAY11 = 'Sunday' ) BEGIN 
					---for sunday commition rate
					SET @vcomm_per  =  @v_sun_comm_rate2
				END
				ELSE IF (@SUP_DAY11 = 'Monday') BEGIN 
					---for monday commition rate
					SET @vcomm_per  =  @v_mon_comm_rate2
				END
				ELSE IF (@SUP_DAY11 = 'Tuesday') BEGIN 
					---for tueday commition rate
					SET @vcomm_per  =  @v_tue_comm_rate2
				END
				ELSE IF (@SUP_DAY11 = 'Wednesday') BEGIN 
					---for wednesday commition rate
					SET @vcomm_per  =   @v_wed_comm_rate2
				END
				ELSE IF (@SUP_DAY11 = 'Thursday') BEGIN 
					---for Thursday commition rate
					SET @vcomm_per  =   @v_thu_comm_rate2
				END
				ELSE IF (@SUP_DAY11 = 'Friday' ) BEGIN 
					---for friday commition rate
					SET @vcomm_per  =   @v_fri_comm_rate2
				END
				ELSE IF (@SUP_DAY11 = 'Saturday') BEGIN 
					---for saturday commition rate
					SET @vcomm_per  =  @v_sat_comm_rate2
				END
				ELSE BEGIN 
					SET @vcomm_per  = 0 
				END
   				close comm_auto
			END
			SET @v_comm  =   @v_comm_catg_type2 + ISNULL(@vcomm_per, 0)
		END
		ELSE BEGIN 
			OPEN comm_fix_spl 
			fetch NEXT FROM comm_fix_spl INTO  @v_comp_code1 ,@v_unit_code1, @v_publ1,@v_edtn1,@v_comm_code1,@v_comm_type1,
                @v_valid_form1, @v_sup_copy_from1 , @v_sup_copy_to1 ,@v_sun_comm_rate1 ,@v_mon_comm_rate1, 
                @v_tue_comm_rate1,
                @v_wed_comm_rate1,@v_thu_comm_rate1,@v_fri_comm_rate1,@v_sat_comm_rate1,@v_userid1,@v_freezeflag1 ,@v_creation_date1 ,
                @v_comm_catg_code1 , @v_comm_catg_type1

				IF (@SUP_DAY11 = 'Sunday' ) BEGIN 
					---for sunday commition rate
					SET @vcomm_per  =  @v_sun_comm_rate1
				END
				ELSE IF (@SUP_DAY11 = 'Monday') BEGIN 
					---for monday commition rate
					SET @vcomm_per  =  @v_mon_comm_rate1
				END
				ELSE IF (@SUP_DAY11 = 'Tuesday') BEGIN
					---for tueday commition rate
					SET @vcomm_per  =  @v_tue_comm_rate1
				END
				ELSE IF (@SUP_DAY11 = 'Wednesday') BEGIN 
					---for wednesday commition rate
					SET @vcomm_per  =   @v_wed_comm_rate1
				END
				ELSE IF (@SUP_DAY11 = 'Thursday') BEGIN 
					---for Thursday commition rate
					SET @vcomm_per  =   @v_thu_comm_rate1
				END
				ELSE IF (@SUP_DAY11 = 'Friday' ) BEGIN 
					---for friday commition rate
					SET @vcomm_per  =   @v_fri_comm_rate1
				END
				ELSE IF (@SUP_DAY11 = 'Saturday') BEGIN 
					---for saturday commition rate
					SET @vcomm_per  =  @v_sat_comm_rate1
				END
				ELSE BEGIN 
					SET @vcomm_per  = 0 
				END
			close comm_fix_spl
			SET @v_comm  =   @v_comm_catg_type1 + CONVERT(VARCHAR(20),ISNULL(@vcomm_per, 0))
		END
	DEALLOCATE comm_auto      
	DEALLOCATE comm_fix_spl

	return isnull(@v_comm,0)
END
/********************************laxman sir***************************/


/**********************************issue no. 4653 21/9/11***********************/

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO













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
@RO_OUTSTAND_P AS VARCHAR(5)
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

ALLOWED_PDC_DAYS_RECEIPT=@P_ALLOW_PDC,AD_TYPE_MANUL_BILL=@PAD_TYPE_FOR_MANUL_BILL,OUTSTANDING_AMT_CRITERIA=@RO_OUTSTAND_P

 WHERE comp_code=@compcode




/* ,
',Unsold_Entry_Flag='''+@Unsoldflag+''',Supply_Stop_Percentage='''+@Supplystopper+'''

,ROKEYCHECK='''+@drpRokeychk+''',AGENCYCOMM_SEQ_COM='''+@Agencycomm_seq+''' ,CREDIT_RECIPT='''+@creditreciept+''' where    comp_code='''+@compcode+'''   ' 



--,DISP_CASHBILL='''+@cashindisplay+''',CLA_CASHBILL='''+@cashinclassified+'''
*/

print(@query1)
exec(@query1)

/**********************************issue no. 4653 21/9/11***********************/





/***************************laxman sir 4768 21/09/2011 ***************************************/

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE [dbo].[cir_rep_supply_cir_rep_supply_unit]
	@pcomp_code			VARCHAR(20) ,
	@punit_code         VARCHAR(20) ,
	@ppubl              VARCHAR(20) ,
	@pfrom_supdate      VARCHAR(20) ,
	@ptill_supdate      VARCHAR(20) ,
	@pdateformat        VARCHAR(20) ,
	@pextra1            VARCHAR(40) ,
	@pextra2            VARCHAR(40) 
AS 
	DECLARE @vfrom_supdate      VARCHAR(20) 
	DECLARE @vtill_supdate      VARCHAR(20) 
	declare @supply_type_name	varchar(4000)
	declare @supply_sum			varchar(4000)

	DECLARE cur_sup_type cursor LOCAL FOR 
		SELECT 'sum( case sup_type_code when ' + '''' + CAST(sup_ty_code AS VARCHAR) + '''' + ' then sup_copy else 0 end) "' + CAST(sup_ty_name AS VARCHAR) + '",' vty,
				 'sum(case sup_type_code when ' + '''' + CAST(sup_ty_code AS VARCHAR) + '''' + 'then sup_copy else 0 end) +' vty_sum
		FROM  cir_supply_type_mast 
		WHERE comp_code  = @pcomp_code 
		ORDER BY sup_seq_no 

		DECLARE @vvar		VARCHAR(4000) 
		DECLARE @vvar_sum   VARCHAR(4000) 
		DECLARE @vquery     VARCHAR(4000) 
		DECLARE @vquery1    VARCHAR(4000) 

		DECLARE @vquery2    VARCHAR(4000) 
		DECLARE @vquery12   VARCHAR(4000) 
print('13')

		SET @vfrom_supdate  = dbo.convert_user_date('/', @pfrom_supdate,@pdateformat)
		SET @vtill_supdate  = dbo.convert_user_date('/', @ptill_supdate,@pdateformat)
print('1311')		
		OPEN cur_sup_type 
			fetch NEXT from  cur_sup_type into @supply_type_name,@supply_sum

			WHILE (@@FETCH_STATUS = 0) 
			BEGIN 
			   set @vvar =COALESCE(@vvar+'', SPACE(0)) + '' + COALESCE(@supply_type_name + '', SPACE(0))
		       set @vvar_sum=COALESCE(@vvar_sum+'', SPACE(0)) + '' + COALESCE(@supply_sum + '', SPACE(0))
		    fetch NEXT from  cur_sup_type into @supply_type_name,@supply_sum
        END 
		close cur_sup_type
		
		SET @vvar  = SUBSTRING(@vvar, 1, LEN(@vvar) - 1)
		SET @vvar_sum  = SUBSTRING(@vvar_sum, 1, LEN(@vvar_sum) - 1)
		--insert into test1(vstring) values (vquery);
		
		SET @vquery  = ' select comp_code AS "COMP_CODE",unit_code AS "UNIT_CODE",publ AS "PUBL", dbo.cir_get_publ_name(comp_code,publ) AS "PUBL_NAME",sup_rate as "SUP_RATE", supdate AS "SUPDATE",' + @vvar + ',' 
        SET @vquery2  = @vvar_sum + ' TOTAL from cir_dbksup where comp_code=' + '''' + @pcomp_code + '''' + ' and 
        ((unit_code=' + '''' + @punit_code + '''' + ') or (' + '''' + @punit_code + '''' + ' is null)) and ((publ=' + '''' + @ppubl + '''' + ') or (' + '''' + @ppubl + '''' + ' is null)) and  supdate between ' + ''''  + @vfrom_supdate + ''''  + '  and ' + '''' + @vtill_supdate +'''' + '  group by comp_code,unit_code,sup_rate,supdate,publ order by comp_code,unit_code,publ_name,supdate,sup_rate' 
		--insert into test1(vstring) values ('11'||vquery);commit;
		print(@vquery)print(@vquery2)
		EXEC (@vquery + @vquery2) 
		print('5656')

		SET @vquery1  = ' select comp_code AS "COMP_CODE",sup_rate as "SUP_RATE",' + @vvar + ',' 
        SET @vquery12  = @vvar_sum + ' TOTAL from cir_dbksup where comp_code=' + '''' + @pcomp_code + '''' + ' and ((unit_code=' + '''' + @punit_code + '''' + ') or (' + '''' +@punit_code + '''' + ' is null)) and ((publ=' + '''' + @ppubl + '''' + ') or (' + '''' + @ppubl + '''' + ' is null)) and  supdate between' +  '''' + @vfrom_supdate + '''' +'  and ' + '''' + @vtill_supdate + '''' + ' group by comp_code,sup_rate order by comp_code,sup_rate' 
		--insert into test1(vstring) values ('22'||vquery1);commit;
		--	print(@vquery1)
		EXEC (@vquery1 + @vquery12) 
	DEALLOCATE cur_sup_type

//=============================================================================================================================
  




//========================================= issue no.   4768 change by dhama sir==================================================


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROCEDURE [dbo].[websp_pubcenter_newnew] 
@pextra1 as varchar(4000)

 AS
select Pub_cent_Code,pub_cent_name + '(' +city_name + ')' as center from 
pub_cent_mast,city_mst where city_mst.city_code=pub_cent_mast.city_code and 
 isnull(PUB_CENT_MAST.PRINT_CENT,'Y') != 'N' and 
(pub_cent_name like @pextra1+'%' or @pextra1 is null )
ORDER BY "center"

select agency_name,code_subcode from agency_mast  ORDER BY Agency_Name;




select * from login




//=========================================================================================================================


/*****************************************issue no 4653 22/9/11*************************************/

ALTER PROCEDURE currbindpreferpgld
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
ALLOWED_PDC_DAYS_RECEIPT,AD_TYPE_MANUL_BILL, OUTSTANDING_AMT_CRITERIA as RO_OUTSTAND
           FROM PREFERRENCES
          WHERE comp_code = @compcode


/*****************************************issue no 4653 22/9/11*************************************/







//================================================issue no 4660-------------------------------------------------------------


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER PROCEDURE [dbo].[cir_agency_bind_cir_branch_billagency_p]
	@pcompcode                                VARCHAR(20) ,
	@punit                                    VARCHAR(20) ,
	@pbranchcode                              VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS 
	

DECLARE @VQUERY1              varchar(4000)
if UPPER(@pextra2)='D'
begin
		set  @VQUERY1 = 'SELECT
				 cir_agmast_dis.*,
				 DBO.cir_get_city(cir_agmast_dis.comp_code, cir_agmast_dis.city_code) "CITY_NAME" 
		FROM  cir_agmast_dis 
		WHERE	 comp_code  = '+''''+@pcompcode+''''+'
		 AND	unit  = '+''''+@punit+''''
end
else
begin
set  @VQUERY1 = 'SELECT
				 cir_agmast.*,
				 DBO.cir_get_city(cir_agmast.comp_code, cir_agmast.city_code) "CITY_NAME" 
		FROM  cir_agmast 
		WHERE	 comp_code  = '+''''+@pcompcode+''''+'
		 AND	unit  = '+''''+@punit+''''
end
if( @pbranchcode != '')
begin
set  @VQUERY1 =  @VQUERY1 + ' AND BRANCH_CODE  = '+''''+@pbranchcode+''''
end

print(@pextra1)

if( @pextra1 != '')
begin
print('12')

set  @VQUERY1 =  @VQUERY1 + ' AND UPPER(ag_name)  like UPPER( '+''''+@pextra1+'''' + '+' +'''' + '%'+ ''''+')'
end


set  @VQUERY1 =  @VQUERY1 + '	AND	ISNULL(freeze_flag, ''N'')  = ''N''	 	ORDER BY ag_name '
	
	
print(@VQUERY1)
exec(@VQUERY1)


//------------------------------------------------next procedure-------------------


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

                                                                     
                                                                     
                                                                     
                                             
ALTER procedure [dbo].[cir_pending_unsold_supply]
    @pcompcode       as varchar(200),
    @punitcode       as varchar(200),
    @pbrancode       as varchar(200),
    @pagcd           as varchar(200),
    @pdpcd           as varchar(200),
    @pfromdate       as varchar(200), 
    @ptilldate       as varchar(200),
    @puserid         as varchar(200), 
    @pdateformate    as varchar(200),
    @pextra1         as varchar(200),
    @pextra2         as varchar(200),--it is used for agency or distribution
    @pextra3         as varchar(200),
    @pextra4         as varchar(200),
    @pextra5         as varchar(200)
as
    declare @v_from_date     datetime
    declare @v_till_date     datetime
begin
    set @v_from_date=DBO.CONVERT_USER_DATE('/', @pfromdate,@pdateformate)
    set @v_till_date=DBO.CONVERT_USER_DATE('/', @ptilldate,@pdateformate)
    
    if upper(isnull(@pextra2,'/'))='D' Begin
		select h.comp_code comp_code,h.unit_code unit_code,h.agcd agcd,h.dpcd dpcd,m.ag_name agency_name,m.city_code city_code,
			dbo.cir_get_city(h.comp_code,m.city_code) city_name,h.doctype doctype,h.recptno recptno,h.recptdt recptdt,
			sum(d.copy_amt) net_amt,sum(isnull(d.short_recpt,0)+isnull(d.late_recpt,0)+isnull(d.bnr,0)+isnull(d.unsold,0)) net_unsold
			from cir_unsold_hdr_dis h,cir_unsold_dtl_dis d,cir_agmast_dis m
			where h.comp_code=d.comp_code and h.comp_code=m.comp_code and h.comp_code=@pcompcode and 
				h.unit_code=d.unit_code and h.unit_code=m.unit and h.unit_code=@punitcode and h.doctype=d.doctype and h.agcd=d.agcd and h.agcd=m.agcd and 
				h.dpcd=d.dpcd and h.dpcd=m.dpcd and (h.agcd=@pagcd or @pagcd is null or @pagcd='') and (h.dpcd=@pdpcd or @pdpcd is null or @pdpcd='') and
				h.recptdt=d.recptdt and h.recptdt>=@v_from_date and h.recptdt<=@v_till_date and h.recptno=d.recptno and (d.branch_code=@pbrancode or @pbrancode is null or @pbrancode='') and
				(d.app_userid is null or d.app_userid='') and (isnull(d.apr_short_recpt,0)+isnull(d.apr_late_recpt,0)+isnull(d.apr_bnr,0)+isnull(d.apr_unsold,0))=0
			group by h.comp_code,h.unit_code,h.agcd,h.dpcd,m.ag_name,m.city_code,h.doctype,h.recptno,h.recptdt
			order by h.recptdt,h.recptno,agency_name;       
	End
	Else Begin
		select h.comp_code comp_code,h.unit_code unit_code,h.agcd agcd,h.dpcd dpcd,m.ag_name agency_name,m.city_code city_code,
			dbo.cir_get_city(h.comp_code,m.city_code) city_name,h.doctype doctype,h.recptno recptno,h.recptdt recptdt,
			sum(d.copy_amt) net_amt,sum(isnull(d.short_recpt,0)+isnull(d.late_recpt,0)+isnull(d.bnr,0)+isnull(d.unsold,0)) net_unsold
			from cir_unsold_hdr h,cir_unsold_dtl d,cir_agmast m
			where h.comp_code=d.comp_code and h.comp_code=m.comp_code and h.comp_code=@pcompcode and 
				h.unit_code=d.unit_code and h.unit_code=m.unit and h.unit_code=@punitcode and h.doctype=d.doctype and h.agcd=d.agcd and h.agcd=m.agcd and 
				h.dpcd=d.dpcd and h.dpcd=m.dpcd and (h.agcd=@pagcd or @pagcd is null or @pagcd='') and (h.dpcd=@pdpcd or @pdpcd is null or @pdpcd='') and
				h.recptdt=d.recptdt and h.recptdt>=@v_from_date and h.recptdt<=@v_till_date and h.recptno=d.recptno and (d.branch_code=@pbrancode or @pbrancode is null or @pbrancode='') and
				(d.app_userid is null or d.app_userid='') and (isnull(d.apr_short_recpt,0)+isnull(d.apr_late_recpt,0)+isnull(d.apr_bnr,0)+isnull(d.apr_unsold,0))=0
			group by h.comp_code,h.unit_code,h.agcd,h.dpcd,m.ag_name,m.city_code,h.doctype,h.recptno,h.recptdt
			order by h.recptdt,h.recptno,agency_name
	End
End


//////////////////////////////////////////////////next procedure--------------------------


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER procedure [dbo].[cir_pending_unsold_approval]
    @pcompcode       as varchar(200),
    @punitcode       as varchar(200),
    @pbrancode       as varchar(200),
    @pagcd           as varchar(200),
    @pdpcd           as varchar(200),
    @precptno        as varchar(200), 
    @precptdt        as datetime,
    @puserid         as varchar(200), 
    @pdateformate    as varchar(200),
    @pextra1         as varchar(200),
    @pextra2         as varchar(200),--it is used for agency or distribution
    @pextra3         as varchar(200),
    @pextra4         as varchar(200),
    @pextra5         as varchar(200)
as
    declare @v_recpt_date	datetime;

	declare @v1_recpt_date	datetime;
	declare @v1_supdate		datetime;
	declare @v1_publ		varchar(20)
	declare @v1_edtn		varchar(20)
	declare @v1_copy_rate	numeric(18,2)
	declare @v1_comm_rate	numeric(18,2)
	declare @v1_comm_type	varchar(20)
    declare @v1_waste_alw	varchar(20)
	declare @v1_waste_rate	numeric(18,2) 
	declare @v1_short_recpt	int 
	declare @v1_late_recpt	int 
	declare @v1_bnr			int 
	declare @v1_unsold		int

	declare @v_cnt			int
	declare @v_tot_copy		int
	declare @v_waste_amt	numeric(18,2)
	declare	@v_comm_amt		numeric(18,2)
	declare @v_gross_amt	numeric(18,2)
	declare @v_total_amt	numeric(18,2)
	declare c1 cursor for
	select x.recptdt,x.supdate supdate,x.publ publ,x.edtn edtn,x.copy_rate copy_rate,x.comm_rate comm_rate,x.comm_type comm_type,
        x.waste_alw waste_alw,x.waste_rate waste_rate,x.short_recpt short_recpt,x.late_recpt late_recpt,x.bnr bnr,x.unsold unsold 
        from(select recptdt,supdate,publ,edtn,copy_rate,comm_rate,comm_catg_type comm_type,waste_alw,waste_rate,short_recpt,late_recpt,bnr,unsold 
        from cir_unsold_dtl_dis
        where comp_code=@pcompcode and unit_code=@punitcode and doctype='UCN' and agcd=@pagcd and dpcd=@pdpcd and recptno=@precptno and
        recptdt=@precptdt and (app_userid is null or app_userid='') and (isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))=0 and 
        upper(isnull(@pextra2,'/'))='D'
        union
        select recptdt,supdate,publ,edtn,copy_rate,comm_rate,comm_catg_type comm_type,waste_alw,waste_rate,short_recpt,late_recpt,bnr,unsold 
        from cir_unsold_dtl 
        where comp_code=@pcompcode and unit_code=@punitcode and doctype='UCN' and agcd=@pagcd and dpcd=@pdpcd and recptno=@precptno and
        recptdt=@precptdt and (app_userid is null or app_userid='') and (isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))=0 and
        upper(isnull(@pextra2,'/'))!='D') x
        order by supdate,publ,edtn,copy_rate
begin
    set @v_recpt_date=@precptdt
	open c1
	fetch NEXT FROM c1 INTO @v1_recpt_date,@v1_supdate,@v1_publ,@v1_edtn, @v1_copy_rate, @v1_comm_rate,
		@v1_comm_type,@v1_waste_alw,@v1_waste_rate,@v1_short_recpt,@v1_late_recpt,@v1_bnr,@v1_unsold

	WHILE (@@FETCH_STATUS = 0) 
	BEGIN
		set @v_cnt=isnull(@v_cnt,0)+1

        if isnull(@v1_waste_alw,'N')='Y' Begin
            set @v_waste_amt=round((isnull(@v1_unsold,0)*isnull(@v1_waste_rate,0)),2)
			End
        else
			Begin
				set @v_waste_amt=0
			End
        
        set @v_tot_copy=isnull(@v1_short_recpt,0)+isnull(@v1_late_recpt,0)+isnull(@v1_bnr,0)+isnull(@v1_unsold,0);
        
        set @v_gross_amt =isnull(@v_tot_copy,0)*isnull(@v1_copy_rate,0);
        
        if @v1_comm_type='C' Begin--for per copy rate
            set @v_comm_amt  =round((@v_tot_copy*isnull(@v1_comm_rate,0)),2)
			End
        else Begin
            set @v_comm_amt  =round((@v_gross_amt*isnull(@v1_comm_rate,0)/100),2)
        End 

        set @v_total_amt =round((@v_gross_amt-@v_comm_amt-@v_waste_amt),2)
	
		if upper(isnull(@pextra2,'/'))='D' Begin
            update cir_unsold_dtl_dis set apr_short_recpt=isnull(@v1_short_recpt,0), apr_late_recpt=isnull(@v1_late_recpt,0), apr_bnr=isnull(@v1_bnr,0), apr_unsold=isnull(@v1_unsold,0), 
                app_userid=@puserid,app_dt=@v_recpt_date,comm_amt=@v_comm_amt,waste_amt=@v_waste_amt,copy_amt=@v_total_amt
            where comp_code=@pcompcode and unit_code=@punitcode and doctype='UCN' and agcd=@pagcd and dpcd=@pdpcd and recptno=@precptno and
            recptdt=@precptdt and supdate=@v1_supdate and publ=@v1_publ and edtn=@v1_edtn and copy_rate=@v1_copy_rate and 
            (app_userid is null or app_userid='') and (isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))=0
		End
		Else Begin
            update cir_unsold_dtl set apr_short_recpt=isnull(@v1_short_recpt,0), apr_late_recpt=isnull(@v1_late_recpt,0), apr_bnr=isnull(@v1_bnr,0), apr_unsold=isnull(@v1_unsold,0), 
                app_userid=@puserid,app_dt=@v_recpt_date,comm_amt=@v_comm_amt,waste_amt=@v_waste_amt,copy_amt=@v_total_amt
            where comp_code=@pcompcode and unit_code=@punitcode and doctype='UCN' and agcd=@pagcd and dpcd=@pdpcd and recptno=@precptno and
            recptdt=@precptdt and supdate=@v1_supdate and publ=@v1_publ and edtn=@v1_edtn and copy_rate=@v1_copy_rate and 
            (app_userid is null or app_userid='') and (isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))=0
		End
	
	fetch NEXT FROM c1 INTO @v1_recpt_date,@v1_supdate,@v1_publ,@v1_edtn, @v1_copy_rate, @v1_comm_rate,
		@v1_comm_type,@v1_waste_alw,@v1_waste_rate,@v1_short_recpt,@v1_late_recpt,@v1_bnr,@v1_unsold

	End
	Close c1
	if upper(isnull(@pextra2,'/'))='D' Begin
		update cir_unsold_hdr_dis set app_userid=@puserid,app_dt=@v_recpt_date
                where comp_code=@pcompcode and unit_code=@punitcode and doctype='UCN' and agcd=@pagcd and dpcd=@pdpcd and recptno=@precptno and
                recptdt=@precptdt and (app_userid is null or app_userid='')
	End
	Else Begin
		update cir_unsold_hdr set app_userid=@puserid,app_dt=@v_recpt_date
                where comp_code=@pcompcode and unit_code=@punitcode and doctype='UCN' and agcd=@pagcd and dpcd=@pdpcd and recptno=@precptno and
                recptdt=@precptdt and (app_userid is null or app_userid='')
	End
	deallocate c1
end



////////////////////////////////////////////end of issue no. 4660/////////////////////////////////////////////////////////

/*******************************************Laxman Sir issue no 4761 26/sep/11*****************************/

                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE cir_rep_collection_cir_rep_datewise_monthwise_p
	@pcompcode			VARCHAR(40) ,
	@punitcode          VARCHAR(40) ,
	@pdoctype           VARCHAR(400) ,
	@ppaymode_reason    VARCHAR(40) ,
	@pactype            VARCHAR(40) ,
	@pagency_type       VARCHAR(40) ,
	@pfromdate          VARCHAR(40) ,
	@ptodate            VARCHAR(40) ,
	@pdateformat        VARCHAR(40) ,
	@prep               VARCHAR(40) ,--this is used for datewise(D) or monthwise(M)
	@pextra1            VARCHAR(40) ,--FOR BRANCH
	@pextra2            VARCHAR(40) --FOR DISTRICT
AS 
	DECLARE @v_frdt		DATETIME 
	DECLARE @v_todt		DATETIME 
	declare @vreason	varchar(1000)
	declare @reason		varchar(400)

	DECLARE @v_frdt11  varchar(40) 
	DECLARE @v_todt11  varchar(40) 

	SET @v_frdt  = dbo.convert_user_date('/', @pfromdate,@pdateformat)
	SET @v_todt  = dbo.convert_user_date('/', @ptodate,@pdateformat)

	set @v_frdt11 = cast (@v_frdt as varchar)
	set @v_todt11 = cast (@v_todt as varchar)

	PRINT(@v_frdt)
	PRINT(@v_todt)
	
	DECLARE cur_reason cursor LOCAL FOR 
		SELECT DISTINCT 
			--'sum( case a.reason when ' + '''' + CAST(a.reason AS VARCHAR) + '''' + ' then a.amount else 0 end ) "'+  CAST(reason AS VARCHAR) + '"' ,
			'CASE WHEN A.DOCTYPE+''#''+A.REASON='+''''+A.DOCTYPE+'#'+A.REASON+''''+' THEN ABS(SUM(A.AMOUNT)) ELSE 0 END "'+a.doctype+'#'+reason+'"' vreason,
				 a.doctype+'#'+a.reason REASON
		FROM  cir_rcphdr a,	 cir_agmast b 
		WHERE a.comp_code  = @pcompcode AND a.comp_code  = b.comp_code
		 AND a.unit_code  = b.unit AND (a.unit_code  = @punitcode OR	@punitcode  is null OR	@punitcode = '')
		 AND a.agcd  = b.agcd AND a.dpcd  = b.dpcd
		 AND (b.ag_type  = @pagency_type OR	@pagency_type  is null OR	@pagency_type = '')
		 AND (a.doctype  = @pdoctype OR	@pdoctype  is null OR	@pdoctype = '')
		 AND a.recptdt  between @v_frdt  and  @v_todt
		 AND (a.reason  = @ppaymode_reason OR @ppaymode_reason  is null OR	@ppaymode_reason = '')
		 AND (a.achd  = @pactype OR	@pactype is null OR @pactype = '')
         AND (a.branch_code=@pextra1 or @pextra1 is null or @pextra1='') and (b.dist_code=@pextra2 or @pextra2 is null or @pextra2='')
		ORDER BY reason 
		
		DECLARE @rec_reason		VARCHAR(400) 
        DECLARE @vrec_reason    VARCHAR(400)  

		DECLARE @vvar			VARCHAR(4000) 
		DECLARE @vvar_sum       VARCHAR(4000) 
		DECLARE @vquery         VARCHAR(4000) 

		OPEN cur_reason 
			fetch NEXT FROM cur_reason INTO  @vreason,@reason
			WHILE (@@FETCH_STATUS = 0) 
			BEGIN 
				IF @vvar is null BEGIN 
						SET @vvar  =@vreason
						SET @vvar_sum  = 'sum("'+@reason+'") "'+@reason+'"';
				END
				ELSE BEGIN 
					SET @vvar  = @vvar + ',' + @vreason
					SET @vvar_sum  = @vvar_sum + ',sum("'+@reason+'") "'+@reason+'"';
				END
   			fetch NEXT FROM cur_reason INTO  @vreason,@reason
			END 
		close cur_reason

		IF @vvar is not null and @prep in ( 'D' , 'M' ) BEGIN 
			IF @prep = 'D' BEGIN 
				SET @vquery  = 'select comp_code as "COMP_CODE",unit_code AS "UNIT_CODE",recptdt AS "RECPTDT",' + @vvar_sum + ' from (select a.comp_code comp_code,a.unit_code unit_code,a.recptdt recptdt,' + @vvar + ' from cir_rcphdr a,cir_agmast b where a.comp_code=b.comp_code and a.comp_code=' + '''' + @pcompcode + '''' + ' and a.unit_code=b.unit and (a.unit_code=' + '''' + @punitcode + '''' + ' or' + '''' + @punitcode + '''' + ' is null ' + ' or  ' + '''' + @punitcode + '''' + ' = '''') and a.agcd=b.agcd and a.dpcd=b.dpcd and (b.ag_type=' + '''' + @pagency_type + '''' + ' or' + '''' + @pagency_type + '''' + ' is null ' + ' or  ' + '''' + @pagency_type + '''' + ' = '''') and (a.doctype=' + '''' + @pdoctype + '''' + ' or' + '''' + @pdoctype + '''' + ' is null ' + ' or  ' + '''' + @pdoctype + '''' + ' = '''') and a.recptdt between' + '''' + @v_frdt11 + '''' + ' and' + '''' + @v_todt11 + '''' + ' and 
				(a.reason=' + '''' + @ppaymode_reason + '''' + ' or' + '''' + @ppaymode_reason + '''' + ' is null ' + ' or  ' + '''' + @ppaymode_reason + '''' + ' = '''') and (a.achd=' + '''' + @pactype + '''' + ' or' + '''' + @pactype + '''' + ' is null ' + ' or  ' + '''' + @pactype + '''' + ' = '''') and (a.branch_code=' + '''' + @pextra1 + '''' + ' or' + '''' + @pextra1 + '''' + ' is null ' + ' or  ' + '''' + @pextra1 + '''' + ' = '''')  and (b.dist_code=' + '''' + @pextra2 + '''' + ' or' + '''' + @pextra2 + '''' + ' is null ' + ' or  ' + '''' + @pextra2 + '''' + ' = '''') group by a.comp_code,a.unit_code,a.recptdt,a.reason,a.doctype) m group by m.comp_code,m.unit_code,m.recptdt  order by comp_code,unit_code,recptdt' 
                print(@vquery)
				
				EXEC (@vquery) 
				SET @vquery  = 'select comp_code as "COMP_CODE",unit_code AS "UNIT_CODE",' + @vvar_sum + ' from  (select a.comp_code comp_code,a.unit_code unit_code,a.recptdt recptdt,' + @vvar + ' from cir_rcphdr a,cir_agmast b  where a.comp_code=b.comp_code and a.comp_code=' + '''' + @pcompcode + '''' + ' and a.unit_code=b.unit and (a.unit_code=' + '''' + @punitcode + '''' + ' or' + '''' + @punitcode + '''' + ' is null ' + ' or  ' + '''' + @punitcode + '''' + ' = '''') and  a.agcd=b.agcd and a.dpcd=b.dpcd and (b.ag_type=' + '''' + @pagency_type + '''' + ' or' + '''' + @pagency_type + '''' + ' is null ' + ' or  ' + '''' + @pagency_type + '''' + ' = '''') and  (a.doctype=' + '''' + @pdoctype + '''' + ' or' + '''' + @pdoctype + '''' + ' is null ' + ' or  ' + '''' + @pdoctype + '''' + ' = '''') and a.recptdt between' + '''' + @v_frdt11 + '''' + ' and' + '''' + @v_todt11 + '''' + ' and 
				(a.reason=' + '''' + @ppaymode_reason + '''' + ' or' + '''' + @ppaymode_reason + '''' + ' is null ' + ' or  ' + '''' + @ppaymode_reason + '''' + ' = '''') and (a.achd=' + '''' + @pactype + '''' + ' or' + '''' + @pactype + '''' + ' is null' + ' or  ' + '''' + @pactype + '''' + ' = '''') and (a.branch_code=' + '''' + @pextra1 + '''' + ' or' + '''' + @pextra1 + '''' + ' is null ' + ' or  ' + '''' + @pextra1 + '''' + ' = '''')  and (b.dist_code=' + '''' + @pextra2 + '''' + ' or' + '''' + @pextra2 + '''' + ' is null ' + ' or  ' + '''' + @pextra2 + '''' + ' = '''')  group by a.comp_code,a.unit_code,a.recptdt,a.reason,a.doctype)n  group by n.comp_code,n.unit_code order by comp_code,unit_code' 
				EXEC (@vquery) 
			END
			ELSE BEGIN 
				SET @vquery  = 'select comp_code as "COMP_CODE",unit_code AS "UNIT_CODE", CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(recptdt)-1),recptdt),101) as "DT", (DATENAME(MM, recptdt) '+ ' + '+ '''' +'-' +''''+ ' + ' + 'CAST(YEAR(recptdt) AS VARCHAR(4))) AS "RECPTDT" ,' + @vvar_sum + ' from  (select a.comp_code comp_code,a.unit_code unit_code,a.recptdt recptdt,' + @vvar + ' from cir_rcphdr a,cir_agmast b  where a.comp_code=b.comp_code and a.comp_code=' + '''' + @pcompcode + '''' + ' and a.unit_code=b.unit and (a.unit_code=' + '''' + @punitcode + '''' + ' or' + '''' + @punitcode + '''' + ' is null' + ' or  ' + '''' + @punitcode + '''' + ' = '''') and  a.agcd=b.agcd and a.dpcd=b.dpcd and (b.ag_type=' + '''' + @pagency_type + '''' + ' or' + '''' + @pagency_type + '''' + ' is null ' + ' or  ' + '''' + @pagency_type + '''' + ' = '''') and  (a.doctype=' + '''' + @pdoctype + '''' + ' or' + '''' + @pdoctype + '''' + ' is null ' + ' or  ' + '''' + @pdoctype + '''' + ' = '''') and a.recptdt between' + '''' + @v_frdt11 + '''' + ' and' + '''' + @v_todt11 + '''' + ' and  
				(a.reason=' + '''' + @ppaymode_reason + '''' + ' or' + '''' + @ppaymode_reason + '''' + ' is null ' + ' or  ' + '''' + @ppaymode_reason + '''' + ' = '''') and (a.achd=' + '''' + @pactype + '''' + ' or' + '''' + @pactype + '''' + ' is null' + ' or  ' + '''' + @pactype + '''' + ' = '''') and (a.branch_code=' + '''' + @pextra1 + '''' + ' or' + '''' + @pextra1 + '''' + ' is null ' + ' or  ' + '''' + @pextra1 + '''' + ' = '''')  and (b.dist_code=' + '''' + @pextra2 + '''' + ' or' + '''' + @pextra2 + '''' + ' is null ' + ' or  ' + '''' + @pextra2 + '''' + ' = '''') group by a.comp_code,a.unit_code,a.recptdt,a.reason,a.doctype) v  group by v.comp_code,v.unit_code,CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(v.recptdt)-1),v.recptdt),101) , (DATENAME(MM, v.recptdt)' + '+ ' +'''' +'-' +''''+ '+' + 'CAST(YEAR(v.recptdt) AS VARCHAR(4)))   order by comp_code,unit_code' 
		    	EXEC (@vquery) 
				SET @vquery  = 'select comp_code as "COMP_CODE",unit_code AS "UNIT_CODE",' + @vvar_sum + ' from  (select a.comp_code comp_code,a.unit_code unit_code,a.recptdt recptdt,' + @vvar + ' from cir_rcphdr a,cir_agmast b  where a.comp_code=' + '''' + @pcompcode + '''' + ' and (a.unit_code=' + '''' + @punitcode + '''' + ' or' + '''' + @punitcode + '''' + ' is null' + ' or  ' + '''' + @punitcode + '''' + ' = '''') and   a.agcd=b.agcd and a.dpcd=b.dpcd and (b.ag_type=' + '''' + @pagency_type + '''' + ' or' + '''' + @pagency_type + '''' + ' is null ' + ' or  ' + '''' + @pagency_type + '''' + ' = '''') and  (a.doctype=' + '''' + @pdoctype + '''' + ' or' + '''' + @pdoctype + '''' + ' is null ' + ' or  ' + '''' + @pdoctype + '''' + ' = '''') and a.recptdt between' + '''' + @v_frdt11 + '''' + ' and' + '''' + @v_todt11 + '''' + ' and 
				(a.reason=' + '''' + @ppaymode_reason + '''' + ' or' + '''' + @ppaymode_reason + '''' + ' is null ' + ' or  ' + '''' + @ppaymode_reason + '''' + ' = '''') and (a.achd=' + '''' + @pactype + '''' + ' or' + '''' + @pactype + '''' + ' is null ' + ' or  ' + '''' + @pactype + '''' + ' = '''') and (a.branch_code=' + '''' + @pextra1 + '''' + ' or' + '''' + @pextra1 + '''' + ' is null ' + ' or  ' + '''' + @pextra1 + '''' + ' = '''')  and (b.dist_code=' + '''' + @pextra2 + '''' + ' or' + '''' + @pextra2 + '''' + ' is null ' + ' or  ' + '''' + @pextra2 + '''' + ' = '''') group by a.comp_code,a.unit_code,a.recptdt,a.reason,a.doctype) w  group by w.comp_code,w.unit_code  order by comp_code,unit_code' 
				EXEC (@vquery) 
			END
		END
		ELSE BEGIN 
			SET @vquery  = 'select' + '''' + @pcompcode + '''' + ' "COMP_CODE",' + '''' + @punitcode + '''' + ' "unit_code",' + '''' + convert(varchar(10),getdate(),101)+ '''' + ' "recptdt"  where 1=2' 
			EXEC (@vquery) 
			SET @vquery  = 'select' + '''' + @pcompcode + '''' + ' "COMP_CODE",' + '''' + @punitcode + '''' + ' "unit_code"  where 1=2' 
			EXEC (@vquery)
		END
		DEALLOCATE cur_reason


/**********************************************end of issue no.4761 26/sep/11***************************************************************/
/***********prachi  4968     26-sept**************/
                                        
create procedure [dbo].[cir_pending_unsold_supply]
    @pcompcode       as varchar(200),
    @punitcode       as varchar(200),
    @pbrancode       as varchar(200),
    @pagcd           as varchar(200),
    @pdpcd           as varchar(200),
    @pfromdate       as varchar(200), 
    @ptilldate       as varchar(200),
    @puserid         as varchar(200), 
    @pdateformate    as varchar(200),
    @pextra1         as varchar(200),
    @pextra2         as varchar(200),--it is used for agency or distribution
    @pextra3         as varchar(200),
    @pextra4         as varchar(200),
    @pextra5         as varchar(200)
as
    declare @v_from_date     datetime
    declare @v_till_date     datetime
begin
    set @v_from_date=DBO.CONVERT_USER_DATE('/', @pfromdate,@pdateformate)
    set @v_till_date=DBO.CONVERT_USER_DATE('/', @ptilldate,@pdateformate)
     if upper(isnull(@pextra2,'/'))='D' Begin
        select h.comp_code COMP_CODE,h.unit_code UNIT_CODE,h.agcd AGCD,h.dpcd DPCD,m.ag_name AGENCY_NAME,m.city_code CITY_CODE,
            dbo.cir_get_city(h.comp_code,m.city_code) CITY_NAME,h.doctype DOCTYPE,h.recptno RECPTNO,h.recptdt RECPTDT,
            sum(d.copy_amt) NET_AMT,sum(isnull(d.short_recpt,0)+isnull(d.late_recpt,0)+isnull(d.bnr,0)+isnull(d.unsold,0)) NET_UNSOLD
            from cir_unsold_hdr_dis h,cir_unsold_dtl_dis d,cir_agmast_dis m
            where h.comp_code=d.comp_code and h.comp_code=m.comp_code and h.comp_code=@pcompcode and 
                h.unit_code=d.unit_code and h.unit_code=m.unit and h.unit_code=@punitcode and h.doctype=d.doctype and h.agcd=d.agcd and h.agcd=m.agcd and 
                h.dpcd=d.dpcd and h.dpcd=m.dpcd and (h.agcd=@pagcd or @pagcd is null or @pagcd='') and (h.dpcd=@pdpcd or @pdpcd is null or @pdpcd='') and
                h.recptdt=d.recptdt and h.recptdt>=@v_from_date and h.recptdt<=@v_till_date and h.recptno=d.recptno and (d.branch_code=@pbrancode or @pbrancode is null or @pbrancode='') and
                (d.app_userid is null or d.app_userid='') and (isnull(d.apr_short_recpt,0)+isnull(d.apr_late_recpt,0)+isnull(d.apr_bnr,0)+isnull(d.apr_unsold,0))=0
            group by h.comp_code,h.unit_code,h.agcd,h.dpcd,m.ag_name,m.city_code,h.doctype,h.recptno,h.recptdt
            order by h.recptdt,h.recptno,agency_name;       
    End
    Else Begin
        select h.comp_code COMP_CODE,h.unit_code UNIT_CODE,h.agcd AGCD,h.dpcd DPCD,m.ag_name AGENCY_NAME,m.city_code CITY_CODE,
            dbo.cir_get_city(h.comp_code,m.city_code) CITY_NAME,h.doctype DOCTYPE,h.recptno RECPTNO,h.recptdt RECPTDT,
            sum(d.copy_amt) NET_AMT,sum(isnull(d.short_recpt,0)+isnull(d.late_recpt,0)+isnull(d.bnr,0)+isnull(d.unsold,0)) NET_UNSOLD
            from cir_unsold_hdr h,cir_unsold_dtl d,cir_agmast m
            where h.comp_code=d.comp_code and h.comp_code=m.comp_code and h.comp_code=@pcompcode and 
                h.unit_code=d.unit_code and h.unit_code=m.unit and h.unit_code=@punitcode and h.doctype=d.doctype and h.agcd=d.agcd and h.agcd=m.agcd and 
                h.dpcd=d.dpcd and h.dpcd=m.dpcd and (h.agcd=@pagcd or @pagcd is null or @pagcd='') and (h.dpcd=@pdpcd or @pdpcd is null or @pdpcd='') and
                h.recptdt=d.recptdt and h.recptdt>=@v_from_date and h.recptdt<=@v_till_date and h.recptno=d.recptno and (d.branch_code=@pbrancode or @pbrancode is null or @pbrancode='') and
                (d.app_userid is null or d.app_userid='') and (isnull(d.apr_short_recpt,0)+isnull(d.apr_late_recpt,0)+isnull(d.apr_bnr,0)+isnull(d.apr_unsold,0))=0
            group by h.comp_code,h.unit_code,h.agcd,h.dpcd,m.ag_name,m.city_code,h.doctype,h.recptno,h.recptdt
            order by h.recptdt,h.recptno,agency_name
    End
End



create procedure [dbo].[cir_pending_unsold_approval]
    @pcompcode       as varchar(200),
    @punitcode       as varchar(200),
    @pbrancode       as varchar(200),
    @pagcd           as varchar(200),
    @pdpcd           as varchar(200),
    @precptno        as varchar(200), 
    @precptdt        as datetime,
    @puserid         as varchar(200), 
    @pdateformate    as varchar(200),
    @pextra1         as varchar(200),
    @pextra2         as varchar(200),--it is used for agency or distribution
    @pextra3         as varchar(200),
    @pextra4         as varchar(200),
    @pextra5         as varchar(200)
as
    declare @v_recpt_date	datetime;

	declare @v1_recpt_date	datetime;
	declare @v1_supdate		datetime;
	declare @v1_publ		varchar(20)
	declare @v1_edtn		varchar(20)
	declare @v1_copy_rate	numeric(18,2)
	declare @v1_comm_rate	numeric(18,2)
	declare @v1_comm_type	varchar(20)
    declare @v1_waste_alw	varchar(20)
	declare @v1_waste_rate	numeric(18,2) 
	declare @v1_short_recpt	int 
	declare @v1_late_recpt	int 
	declare @v1_bnr			int 
	declare @v1_unsold		int

	declare @v_cnt			int
	declare @v_tot_copy		int
	declare @v_waste_amt	numeric(18,2)
	declare	@v_comm_amt		numeric(18,2)
	declare @v_gross_amt	numeric(18,2)
	declare @v_total_amt	numeric(18,2)
	declare c1 cursor for
	select x.recptdt,x.supdate supdate,x.publ publ,x.edtn edtn,x.copy_rate copy_rate,x.comm_rate comm_rate,x.comm_type comm_type,
        x.waste_alw waste_alw,x.waste_rate waste_rate,x.short_recpt short_recpt,x.late_recpt late_recpt,x.bnr bnr,x.unsold unsold 
        from(select recptdt,supdate,publ,edtn,copy_rate,comm_rate,comm_catg_type comm_type,waste_alw,waste_rate,short_recpt,late_recpt,bnr,unsold 
        from cir_unsold_dtl_dis
        where comp_code=@pcompcode and unit_code=@punitcode and doctype='UCN' and agcd=@pagcd and dpcd=@pdpcd and recptno=@precptno and
        recptdt=@precptdt and (app_userid is null or app_userid='') and (isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))=0 and 
        upper(isnull(@pextra2,'/'))='D'
        union
        select recptdt,supdate,publ,edtn,copy_rate,comm_rate,comm_catg_type comm_type,waste_alw,waste_rate,short_recpt,late_recpt,bnr,unsold 
        from cir_unsold_dtl 
        where comp_code=@pcompcode and unit_code=@punitcode and doctype='UCN' and agcd=@pagcd and dpcd=@pdpcd and recptno=@precptno and
        recptdt=@precptdt and (app_userid is null or app_userid='') and (isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))=0 and
        upper(isnull(@pextra2,'/'))!='D') x
        order by supdate,publ,edtn,copy_rate
begin
    set @v_recpt_date=@precptdt
	open c1
	fetch NEXT FROM c1 INTO @v1_recpt_date,@v1_supdate,@v1_publ,@v1_edtn, @v1_copy_rate, @v1_comm_rate,
		@v1_comm_type,@v1_waste_alw,@v1_waste_rate,@v1_short_recpt,@v1_late_recpt,@v1_bnr,@v1_unsold

	WHILE (@@FETCH_STATUS = 0) 
	BEGIN
		set @v_cnt=isnull(@v_cnt,0)+1

        if isnull(@v1_waste_alw,'N')='Y' Begin
            set @v_waste_amt=round((isnull(@v1_unsold,0)*isnull(@v1_waste_rate,0)),2)
			End
        else
			Begin
				set @v_waste_amt=0
			End
        
        set @v_tot_copy=isnull(@v1_short_recpt,0)+isnull(@v1_late_recpt,0)+isnull(@v1_bnr,0)+isnull(@v1_unsold,0);
        
        set @v_gross_amt =isnull(@v_tot_copy,0)*isnull(@v1_copy_rate,0);
        
        if @v1_comm_type='C' Begin--for per copy rate
            set @v_comm_amt  =round((@v_tot_copy*isnull(@v1_comm_rate,0)),2)
			End
        else Begin
            set @v_comm_amt  =round((@v_gross_amt*isnull(@v1_comm_rate,0)/100),2)
        End 

        set @v_total_amt =round((@v_gross_amt-@v_comm_amt-@v_waste_amt),2)
	
		if upper(isnull(@pextra2,'/'))='D' Begin
            update cir_unsold_dtl_dis set apr_short_recpt=isnull(@v1_short_recpt,0), apr_late_recpt=isnull(@v1_late_recpt,0), apr_bnr=isnull(@v1_bnr,0), apr_unsold=isnull(@v1_unsold,0), 
                app_userid=@puserid,app_dt=@v_recpt_date,comm_amt=@v_comm_amt,waste_amt=@v_waste_amt,copy_amt=@v_total_amt
            where comp_code=@pcompcode and unit_code=@punitcode and doctype='UCN' and agcd=@pagcd and dpcd=@pdpcd and recptno=@precptno and
            recptdt=@precptdt and supdate=@v1_supdate and publ=@v1_publ and edtn=@v1_edtn and copy_rate=@v1_copy_rate and 
            (app_userid is null or app_userid='') and (isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))=0
		End
		Else Begin
            update cir_unsold_dtl set apr_short_recpt=isnull(@v1_short_recpt,0), apr_late_recpt=isnull(@v1_late_recpt,0), apr_bnr=isnull(@v1_bnr,0), apr_unsold=isnull(@v1_unsold,0), 
                app_userid=@puserid,app_dt=@v_recpt_date,comm_amt=@v_comm_amt,waste_amt=@v_waste_amt,copy_amt=@v_total_amt
            where comp_code=@pcompcode and unit_code=@punitcode and doctype='UCN' and agcd=@pagcd and dpcd=@pdpcd and recptno=@precptno and
            recptdt=@precptdt and supdate=@v1_supdate and publ=@v1_publ and edtn=@v1_edtn and copy_rate=@v1_copy_rate and 
            (app_userid is null or app_userid='') and (isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))=0
		End
	
	fetch NEXT FROM c1 INTO @v1_recpt_date,@v1_supdate,@v1_publ,@v1_edtn, @v1_copy_rate, @v1_comm_rate,
		@v1_comm_type,@v1_waste_alw,@v1_waste_rate,@v1_short_recpt,@v1_late_recpt,@v1_bnr,@v1_unsold

	End
	Close c1
	if upper(isnull(@pextra2,'/'))='D' Begin
		update cir_unsold_hdr_dis set app_userid=@puserid,app_dt=@v_recpt_date
                where comp_code=@pcompcode and unit_code=@punitcode and doctype='UCN' and agcd=@pagcd and dpcd=@pdpcd and recptno=@precptno and
                recptdt=@precptdt and (app_userid is null or app_userid='')
	End
	Else Begin
		update cir_unsold_hdr set app_userid=@puserid,app_dt=@v_recpt_date
                where comp_code=@pcompcode and unit_code=@punitcode and doctype='UCN' and agcd=@pagcd and dpcd=@pdpcd and recptno=@precptno and
                recptdt=@precptdt and (app_userid is null or app_userid='')
	End
	deallocate c1
end




/***********prachi  4968     26-sept**************/
/********prachi 4963   28-sept*****************/
                                                                    
                                             
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
    sum(isnull(d.short_recpt,0)+isnull(d.late_recpt,0)+isnull(d.bnr,0)+isnull(d.unsold,0)) RETURN_COPY
    from cir_agmast_dis m, cir_unsold_hdr_dis h,cir_unsold_dtl_dis d,cir_edtn_mast e
    where m.comp_code=d.comp_code and d.comp_code=h.comp_code and m.comp_code=e.comp_code and m.comp_code=@pcompcode and 
    m.unit=d.unit_code and d.unit_code=h.unit_code and m.unit=e.unit_code and m.unit=@punitcode and 
    m.agcd=d.agcd and m.agcd=isnull(@pagcode,m.agcd) and m.dpcd=d.dpcd and m.dpcd=isnull(@pagsubcode,m.dpcd) and 
    d.doctype=h.doctype and d.doctype=isnull(@pdoctype,d.doctype) and d.recptdt=h.recptdt and d.recptdt between @pfrom_recdate and @ptill_recdate and 
    d.recptno=h.recptno and d.recptno =isnull(@precptno,d.recptno) and 
    d.publ=e.publ and d.edtn=e.edtn and @pextra2='D'
    group by d.comp_code,d.unit_code,d.agcd,d.dpcd ,m.ag_name,d.recptdt,d.recptno ,d.publ,d.edtn,
    d.copy_rate,e.main_edtn,d.branch_code,e.edtn_name
    union
    select d.comp_code as COMP_CODE,d.unit_code as UNIT_CODE,d.branch_code BRANCH_CODE,
    dbo.get_branch_name(d.branch_code) BRANCH_NAME,d.agcd AGCD,d.dpcd DPCD,
    m.AG_NAME,d.recptdt RECPTDT,d.recptno RECPTNO ,d.publ PUBL,dbo.cir_get_name_cir_publ(d.comp_code,d.publ,1,'','','') PUBL_NAME, 
    e.main_edtn MAIN_EDTN,dbo.cir_get_name_cir_edtn(d.comp_code,d.unit_code,e.main_edtn,1,'','','') MAIN_EDTNNAME,d.edtn EDTN,e.EDTN_NAME,
    d.copy_rate COPY_RATE,
    sum(isnull(d.short_recpt,0)+isnull(d.late_recpt,0)+isnull(d.bnr,0)+isnull(d.unsold,0)) RETURN_COPY
    from cir_agmast m, cir_unsold_hdr h,cir_unsold_dtl d,cir_edtn_mast e
    where m.comp_code=d.comp_code and d.comp_code=h.comp_code and m.comp_code=e.comp_code and m.comp_code=@pcompcode and 
    m.unit=d.unit_code and d.unit_code=h.unit_code and m.unit=e.unit_code and m.unit=@punitcode and 
    m.agcd=d.agcd and m.agcd=isnull(@pagcode,m.agcd) and m.dpcd=d.dpcd and m.dpcd=isnull(@pagsubcode,m.dpcd) and 
    d.doctype=h.doctype and d.doctype=isnull(@pdoctype,d.doctype) and d.recptdt=h.recptdt and d.recptdt between @pfrom_recdate and @ptill_recdate and 
    d.recptno=h.recptno and d.recptno =isnull(@precptno,d.recptno) and 
    d.publ=e.publ and d.edtn=e.edtn and (@pextra2!='D' or @pextra2='' or @pextra2 is null)
    group by d.comp_code,d.unit_code,d.agcd,d.dpcd ,m.ag_name,d.recptdt,d.recptno ,d.publ,d.edtn,
    d.copy_rate,e.main_edtn,d.branch_code,e.edtn_name
    order by comp_code,unit_code,recptdt,recptno,publ_name,main_edtnname,edtn_name
    
  End



/********prachi 4963   28-sept*****************/
                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE cir_rep_supply_cir_rep_supply_unit
	@pcomp_code			VARCHAR(20) ,
	@punit_code         VARCHAR(20) ,
	@ppubl              VARCHAR(20) ,
	@pfrom_supdate      datetime ,
	@ptill_supdate      datetime ,
	@pdateformat        VARCHAR(20) ,
	@pextra1            VARCHAR(40) ,
	@pextra2            VARCHAR(40) 
AS

declare @supply_type_name	varchar(400)
declare @supply_sum			varchar(400)
declare @supply_seqno		int
declare @vfrom_supdate      varchar(40)
declare @vtill_supdate      varchar(40)

	DECLARE cur_sup_type cursor LOCAL FOR 
		SELECT distinct 'sum( case sup_type_code when ' + '''' + 

CAST(s.sup_ty_code AS VARCHAR) + '''' + ' then sup_copy else 0 end) "' + 

CAST(s.sup_ty_name AS VARCHAR) + '",' vty,
				 'sum(case sup_type_code when ' + '''' + 

CAST(s.sup_ty_code AS VARCHAR) + '''' + 'then sup_copy else 0 end) +' 

vty_sum,s.sup_seq_no sup_seq_no
		from cir_supply_type_mast s,cir_dbksup d
        where s.comp_code=d.comp_code and s.comp_code=@pcomp_code and 

(d.unit_code=isnull(@punit_code,d.unit_code) or @punit_code is null or 

@punit_code='') and 
            (d.publ=isnull(@ppubl,d.publ) or @ppubl='') and d.supdate between 

@pfrom_supdate and @ptill_supdate and
            s.sup_ty_code=d.sup_type_code
			order by sup_seq_no
			
	DECLARE @vvar		VARCHAR(4000) 
	DECLARE @vvar_sum   VARCHAR(4000) 
	DECLARE @vquery     VARCHAR(4000) 
	DECLARE @vquery1    VARCHAR(4000) 

	DECLARE @vquery2    VARCHAR(4000) 
	DECLARE @vquery12   VARCHAR(4000) 

	set @vfrom_supdate =convert(varchar(20),@pfrom_supdate,101)
	set @vtill_supdate =convert(varchar(20),@ptill_supdate,101)

	OPEN cur_sup_type
	fetch NEXT from  cur_sup_type into 

@supply_type_name,@supply_sum,@supply_seqno

			WHILE (@@FETCH_STATUS = 0) 
			BEGIN 
			   set @vvar =COALESCE(@vvar+'', SPACE(0)) + '' + 

COALESCE(@supply_type_name + '', SPACE(0))
		       set @vvar_sum=COALESCE(@vvar_sum+'', SPACE(0)) + '' + 

COALESCE(@supply_sum + '', SPACE(0))
			fetch NEXT from  cur_sup_type into 

@supply_type_name,@supply_sum,@supply_seqno
			END 
	close cur_sup_type

	SET @vvar		= SUBSTRING(@vvar, 1, LEN(@vvar) - 1)
	SET @vvar_sum	= SUBSTRING(@vvar_sum, 1, LEN(@vvar_sum) - 1)

	If @vvar is null or @vvar='' Begin
		SET @vquery  = ' select comp_code AS "COMP_CODE",(select 

distinct "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=unit_code) AS 

"UNIT_CODE",publ AS "PUBL", dbo.cir_get_publ_name(comp_code,publ) AS 

"PUBL_NAME",sup_rate as "SUP_RATE", supdate AS "SUPDATE",sum(sup_copy) ' 
		SET @vquery2  = ' TOTAL from cir_dbksup where comp_code=' + 

'''' + @pcomp_code + '''' + ' and 
			((unit_code=' + '''' + @punit_code + '''' + ') or (' + 

'''' + @punit_code + '''' + ' is null)) and (publ=' + '''' + @ppubl + '''' + ' 

or ' + '''' + @ppubl + '''' + ' is null  or ' + '''' + @ppubl + '''' + 

'='+''''+''''+') and  supdate between ' + ''''  + @vfrom_supdate + ''''  + '  

and ' + '''' + @vtill_supdate +'''' + '  group by 

comp_code,unit_code,sup_rate,supdate,publ order by 

comp_code,unit_code,publ_name,supdate,sup_rate' 
	End
	Else Begin
		SET @vquery  = ' select comp_code AS "COMP_CODE",(select 

distinct "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=unit_code) AS 

"UNIT_CODE",publ AS "PUBL", dbo.cir_get_publ_name(comp_code,publ) AS 

"PUBL_NAME",sup_rate as "SUP_RATE", supdate AS "SUPDATE",' + @vvar + ',' 
		SET @vquery2  = @vvar_sum + ' TOTAL from cir_dbksup where 

comp_code=' + '''' + @pcomp_code + '''' + ' and 
			((unit_code=' + '''' + @punit_code + '''' + ') or (' + 

'''' + @punit_code + '''' + ' is null)) and (publ=' + '''' + @ppubl + '''' + ' 

or ' + '''' + @ppubl + '''' + ' is null  or ' + '''' + @ppubl + '''' + 

'='+''''+''''+') and  supdate between ' + ''''  + @vfrom_supdate + ''''  + '  

and ' + '''' + @vtill_supdate +'''' + '  group by 

comp_code,unit_code,sup_rate,supdate,publ order by 

comp_code,unit_code,publ_name,supdate,sup_rate' 
	End
	
	print(@vquery)print(@vquery2)
	EXEC (@vquery + @vquery2) 
	print('1')
	If @vvar is null or @vvar='' Begin
		SET @vquery1  = ' select comp_code AS "COMP_CODE",sup_rate as 

"SUP_RATE",sum(sup_copy)' 
		SET @vquery12  =' TOTAL from cir_dbksup where comp_code=' + 

'''' + @pcomp_code + '''' + ' and (unit_code=' + '''' + @punit_code + '''' + ' 

or ' + '''' +@punit_code + '''' + ' is null) and (publ=' + '''' + @ppubl + '''' 

+ ' or ' + '''' + @ppubl + '''' + ' is null  or ' + '''' + @ppubl + '''' + 

'='+''''+''''+') and  supdate between' +  '''' + @vfrom_supdate + '''' +'  and 

' + '''' + @vtill_supdate + '''' + ' group by comp_code,sup_rate order by 

comp_code,sup_rate' 
		End
	Else Begin
		SET @vquery1  = ' select comp_code AS "COMP_CODE",sup_rate as 

"SUP_RATE",' + @vvar + ',' 
		SET @vquery12  = @vvar_sum + ' TOTAL from cir_dbksup where 

comp_code=' + '''' + @pcomp_code + '''' + ' and (unit_code=' + '''' + 

@punit_code + '''' + ' or ' + '''' +@punit_code + '''' + ' is null) and (publ=' 

+ '''' + @ppubl + '''' + ' or ' + '''' + @ppubl + '''' + ' is null  or ' + '''' 

+ @ppubl + '''' + '='+''''+''''+') and  supdate between' +  '''' + 

@vfrom_supdate + '''' +'  and ' + '''' + @vtill_supdate + '''' + ' group by 

comp_code,sup_rate order by comp_code,sup_rate' 
	END
	print(@vquery1 + @vquery12) 
	EXEC (@vquery1 + @vquery12) 
DEALLOCATE cur_sup_type


                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE cir_rep_billing_cir_billing_agency_list_p
	@pcomp_code			VARCHAR(20) ,
	@punit_code         VARCHAR(20) ,
	@ppubl              VARCHAR(20) ,
	@pfrom_billdt       VARCHAR(20) ,
	@ptill_billdt       VARCHAR(20) ,
	@pdateformat        VARCHAR(20) ,
	@pextra1            VARCHAR(40) ,
	@pextra2            VARCHAR(40) 
AS 
	DECLARE @v_bill_frdt                              DATETIME 
	DECLARE @v_bill_todt                              DATETIME 
	SET @v_bill_frdt  = dbo.convert_user_date('/', 

@pfrom_billdt,@pdateformat)
	SET @v_bill_todt  = dbo.convert_user_date('/', 

@ptill_billdt,@pdateformat)
	
	SELECT a.agcd AGCD, a.dpcd DPCD, a.ag_name AG_NAME, a.ag_name_oth_lang 

AG_NAME_OTH_LANG ,
	a.city_code CITY_CODE, DBO.cir_get_city(a.comp_code, a.city_code) 

CITY_NAME,
	a.tehsil_taluka TEHSIL_TALUKA, DBO.cir_get_taluka(a.comp_code, 

a.tehsil_taluka) TALUKA_NAME
	from cir_agmast a,cir_bill_det b
		where a.comp_code=@pcomp_code and a.comp_code=b.comp_code and 

a.unit=b.unit_code and a.unit=@punit_code and 
              b.billdt >=@v_bill_frdt and b.billdt<=@v_bill_todt and 

a.agcd=b.agcd and a.dpcd=b.dpcd and 
              (b.publ=isnull(@ppubl,b.publ) or @ppubl='') and 
              ((upper(a.ag_name) like upper(@pextra1)+'%') or (@pextra1 is 

null) or (@pextra1=''))
	union
	SELECT a.agcd AGCD, a.dpcd DPCD, a.ag_name AG_NAME, a.ag_name_oth_lang 

AG_NAME_OTH_LANG ,
	a.city_code CITY_CODE, DBO.cir_get_city(a.comp_code, a.city_code) 

CITY_NAME,
	a.tehsil_taluka TEHSIL_TALUKA, DBO.cir_get_taluka(a.comp_code, 

a.tehsil_taluka) TALUKA_NAME
	from cir_agmast a,cir_bill_det b
		where a.comp_code=@pcomp_code and a.comp_code=b.comp_code and 

a.unit=b.unit_code and a.unit=@punit_code and 
              b.billdt >=@v_bill_frdt and b.billdt<=@v_bill_todt and 

a.agcd=b.agcd and a.dpcd=b.dpcd and 
              (b.publ=isnull(@ppubl,b.publ) or @ppubl='') and 
              upper(a.agcd) = upper(@pextra1) order by ag_name,city_name
 

                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE cir_billing_agency_bind_p
	@pcompcode			VARCHAR(20) ,
	@punit				VARCHAR(20) ,
	@pdateformat		VARCHAR(20) ,
	@pextra1			VARCHAR(4000) ,
	@pextra2			VARCHAR(4000) 
AS 
	If UPPER(@pextra2)='D' Begin
		SELECT cir_agmast_dis.*,
			 DBO.cir_get_area(cir_agmast_dis.comp_code, 

cir_agmast_dis.area_code) "AREA_NAME",
			 DBO.cir_get_city(cir_agmast_dis.comp_code, 

cir_agmast_dis.city_code) "CITY_NAME"
		FROM cir_agmast_dis
		WHERE comp_code  = @pcompcode AND	unit  = @punit AND 
			(ag_name  like CAST(@pextra1 AS VARCHAR) + '%' OR 

@pextra1  is null)
		union
		SELECT cir_agmast_dis.*,
			 DBO.cir_get_area(cir_agmast_dis.comp_code, 

cir_agmast_dis.area_code) "AREA_NAME",
			 DBO.cir_get_city(cir_agmast_dis.comp_code, 

cir_agmast_dis.city_code) "CITY_NAME"
		FROM cir_agmast_dis
		WHERE comp_code  = @pcompcode AND	unit  = @punit AND 
			upper(agcd)=upper(@pextra1)
		ORDER BY 5
	End
	Else Begin
		SELECT cir_agmast.*,
			 DBO.cir_get_area(cir_agmast.comp_code, 

cir_agmast.area_code) "AREA_NAME",
			 DBO.cir_get_city(cir_agmast.comp_code, 

cir_agmast.city_code) "CITY_NAME"
		FROM cir_agmast
		WHERE comp_code  = @pcompcode AND	unit  = @punit AND 
			(ag_name  like CAST(@pextra1 AS VARCHAR) + '%' OR 

@pextra1  is null)
		union
		SELECT cir_agmast.*,
			 DBO.cir_get_area(cir_agmast.comp_code, 

cir_agmast.area_code) "AREA_NAME",
			 DBO.cir_get_city(cir_agmast.comp_code, 

cir_agmast.city_code) "CITY_NAME"
		FROM cir_agmast
		WHERE comp_code  = @pcompcode AND	unit  = @punit AND 
			upper(agcd)=upper(@pextra1)
		ORDER BY 5
end


                                                                     
                                                                     
                                                                     
                                             
ALTER procedure cir_billing_agency_list_p (
	@pcomp_code			varchar(10),
	@punit_code         varchar(10),
	@ppubl				varchar(10),
	@pfrom_billdt		datetime,
	@ptill_billdt		datetime,
	@pdateformat		varchar(10),
	@pextra1			varchar(10),
	@pextra2			varchar(10)) as
Begin

	SELECT a.agcd AGCD, a.dpcd DPCD, a.ag_name AG_NAME, a.ag_name_oth_lang 

AG_NAME_OTH_LANG ,
	a.city_code CITY_CODE, DBO.cir_get_city(a.comp_code, a.city_code) 

CITY_NAME,
	a.tehsil_taluka TEHSIL_TALUKA, DBO.cir_get_taluka(a.comp_code, 

a.tehsil_taluka) TALUKA_NAME
	from cir_agmast a,cir_bill_det b
		where a.comp_code=@pcomp_code and a.comp_code=b.comp_code and 

a.unit=b.unit_code and a.unit=@punit_code and 
              b.billdt >=@pfrom_billdt and b.billdt<=@ptill_billdt and 

a.agcd=b.agcd and a.dpcd=b.dpcd and 
              (b.publ=isnull(@ppubl,b.publ) or @ppubl='') and 
              ((upper(a.ag_name) like upper(@pextra1)+'%') or (@pextra1 is 

null) or (@pextra1=''))
	union
	SELECT a.agcd AGCD, a.dpcd DPCD, a.ag_name AG_NAME, a.ag_name_oth_lang 

AG_NAME_OTH_LANG ,
	a.city_code CITY_CODE, DBO.cir_get_city(a.comp_code, a.city_code) 

CITY_NAME,
	a.tehsil_taluka TEHSIL_TALUKA, DBO.cir_get_taluka(a.comp_code, 

a.tehsil_taluka) TALUKA_NAME
	from cir_agmast a,cir_bill_det b
		where a.comp_code=@pcomp_code and a.comp_code=b.comp_code and 

a.unit=b.unit_code and a.unit=@punit_code and 
              b.billdt >=@pfrom_billdt and b.billdt<=@ptill_billdt and 

a.agcd=b.agcd and a.dpcd=b.dpcd and 
              (b.publ=isnull(@ppubl,b.publ) or @ppubl='') and 
              upper(a.agcd) =upper(@pextra1) order by ag_name,city_name
End
                                                                     
                                                                     
                                                                     
                                             
ALTER procedure CIR_RECEIPT_DATA_MOVE
    @pcompcode       as varchar(200),
    @punitcode       as varchar(200),
    @pdoctype        as varchar(200),
    @precptdt        as varchar(200),
    @precptno        as varchar(200),
    @pdateformate    as varchar(200),
    @puserid         as varchar(200),
    @prectype        as varchar(200),--it is for agency receipt or 

distraibution receipt
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
        insert into 

cir_rcphdr_dis(comp_code,unit_code,doctype,agcd,dpcd,recptno,
            

recptdt,chno,chdt,chbank,amount,oth_amount,ccdp,ccds,rcdp,rcds,ocdp,ocds,reason

,
            

remark,achd,voucherno,voucherdt,vchtype,publ,received_from,tdsrate,tdsamt,staxr

ate,
              

staxamt,status,ref_recptno,ref_recptdt,ref_amount,ref_doctype,cancel_user,cance

l_datetime,
              

cancel_remark,userid,creation_datetime,branch_code,prov_rec_no,prov_rec_dt,rema

rk_oth)
          select comp_code,unit_code,doctype,agcd,dpcd,recptno,
          

recptdt,chno,chdt,chbank,amount,oth_amount,ccdp,ccds,rcdp,rcds,ocdp,ocds,reason

,
          

remark,achd,voucherno,voucherdt,vchtype,publ,received_from,tdsrate,tdsamt,staxr

ate,
          

staxamt,status,ref_recptno,ref_recptdt,ref_amount,ref_doctype,cancel_user,cance

l_date,
          

cancel_remark,userid,creation_date,branch_code,prov_rec_no,prov_rec_dt,remark_o

th from cir_rcphdr_dis_temp
            where comp_code=@pcompcode and unit_code=@punitcode and 

doctype=@pdoctype and 
                    recptno=@precptno and recptdt=@v_dt
      
          insert into cir_rcpdet_dis(comp_code, unit_code, agcd, dpcd, doctyp, 

billno, billdt, recptno, recptdt, 
                            payfor, achd, publ, chno, chbnk, chdt, amount, 

reason, remark, voucherno, voucherdt, 
                            tds, stax, status, usrid, creation_datetime, 

branch_code)
          select comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, 

recptno, recptdt, 
                            payfor, achd, publ, chno, chbnk, chdt, amount, 

reason, remark, voucherno, voucherdt, 
                            tds, stax, status, usrid, creation_date, 

branch_code from cir_rcpdet_dis_temp
            where comp_code=@pcompcode and unit_code=@punitcode and 

doctyp=@pdoctype and 
                    recptno=@precptno and recptdt=@v_dt

        insert into cir_outmast_dis (comp_code, unit_code, agcd, dpcd, doctyp, 

billno, billdt, recptno, recptdt, 
                        achd, publ, chno, chbnk, chdt, amount, reason, remark, 

voucherno, voucherdt, balance, 
                        tds, stax, status, cancel_userid, cancel_dt, 

cancel_remark, usrid, creation_datetime, bill_sec_amt, branch_code)
        select comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, 

recptno, recptdt, 
                        achd, publ, chno, chbnk, chdt, amount, reason, remark, 

voucherno, voucherdt, balance, 
                        tds, stax, status, cancel_userid, cancel_dt, 

cancel_remark, usrid, creation_date, bill_sec_amt, branch_code from 

cir_outmast_dis_temp
             where comp_code=@pcompcode and unit_code=@punitcode and 

doctyp=@pdoctype and 
                    recptno=@precptno and recptdt=@v_dt
		End
    else Begin
        insert into cir_rcphdr(comp_code,unit_code,doctype,agcd,dpcd,recptno,
            

recptdt,chno,chdt,chbank,amount,oth_amount,ccdp,ccds,rcdp,rcds,ocdp,ocds,reason

,
            

remark,achd,voucherno,voucherdt,vchtype,publ,received_from,tdsrate,tdsamt,staxr

ate,
              

staxamt,status,ref_recptno,ref_recptdt,ref_amount,ref_doctype,cancel_user,cance

l_date,
              

cancel_remark,userid,creation_date,branch_code,prov_rec_no,prov_rec_dt,remark_o

th)
          select comp_code,unit_code,doctype,agcd,dpcd,recptno,
          

recptdt,chno,chdt,chbank,amount,oth_amount,ccdp,ccds,rcdp,rcds,ocdp,ocds,reason

,
          

remark,achd,voucherno,voucherdt,vchtype,publ,received_from,tdsrate,tdsamt,staxr

ate,
          

staxamt,status,ref_recptno,ref_recptdt,ref_amount,ref_doctype,cancel_user,cance

l_date,
          

cancel_remark,userid,creation_date,branch_code,prov_rec_no,prov_rec_dt,remark_o

th from cir_rcphdr_temp
            where comp_code=@pcompcode and unit_code=@punitcode and 

doctype=@pdoctype and 
                    recptno=@precptno and recptdt=@v_dt
      
          insert into cir_rcpdet(comp_code, unit_code, agcd, dpcd, doctyp, 

billno, billdt, recptno, recptdt, 
                            payfor, achd, publ, chno, chbnk, chdt, amount, 

reason, remark, voucherno, voucherdt, 
                            tds, stax, status, usrid, creation_date, 

branch_code)
          select comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, 

recptno, recptdt, 
                            payfor, achd, publ, chno, chbnk, chdt, amount, 

reason, remark, voucherno, voucherdt, 
                            tds, stax, status, usrid, creation_date, 

branch_code from cir_rcpdet_temp
            where comp_code=@pcompcode and unit_code=@punitcode and 

doctyp=@pdoctype and 
                    recptno=@precptno and recptdt=@v_dt

        insert into cir_outmast (comp_code, unit_code, agcd, dpcd, doctyp, 

billno, billdt, recptno, recptdt, 
                        achd, publ, chno, chbnk, chdt, amount, reason, remark, 

voucherno, voucherdt, balance, 
                        tds, stax, status, cancel_userid, cancel_dt, 

cancel_remark, usrid, creation_date, bill_sec_amt, branch_code)
        select comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, 

recptno, recptdt, 
                        achd, publ, chno, chbnk, chdt, amount, reason, remark, 

voucherno, voucherdt, balance, 
                        tds, stax, status, cancel_userid, cancel_dt, 

cancel_remark, usrid, creation_date, bill_sec_amt, branch_code from 

cir_outmast_temp
             where comp_code=@pcompcode and unit_code=@punitcode and 

doctyp=@pdoctype and 
                    recptno=@precptno and recptdt=@v_dt
    end           
    
    if upper(@prectype)='D' Begin
        select @v_recno=count(*) from cir_rcphdr_dis 
            where comp_code=@pcompcode and unit_code=@punitcode and 

doctype=@pdoctype and 
                recptno=@precptno and recptdt=@v_dt
		End
    else Begin
        select @v_recno=count(*) from cir_rcphdr 
            where comp_code=@pcompcode and unit_code=@punitcode and 

doctype=@pdoctype and 
                recptno=@precptno and recptdt=@v_dt
    End

    if isnull(@v_recno,0)>0 Begin
		if upper(@prectype)='D' Begin
			delete from cir_rcphdr_dis_temp 
				where comp_code=@pcompcode and 

unit_code=@punitcode and doctype=@pdoctype and 
					recptno=@precptno and recptdt=@v_dt
			End
		else Begin
			delete from cir_rcphdr_temp 
				where comp_code=@pcompcode and 

unit_code=@punitcode and doctype=@pdoctype and 
					recptno=@precptno and recptdt=@v_dt
		End
        select @v_recno as "RECNO"
		End
     else Begin
        select 0 as "RECNO"
     End

end
                                                                     
                                                                     
                                                                     
                                             
CREATE OR REPLACE PACKAGE cir_rep_unsold_return is
   TYPE T_Circul_Cursor is Ref Cursor;
   procedure cir_unsold_return_p (
   pcompcode    in varchar2,
   punitcode    in varchar2,
   ppublcode    in varchar2,
   pedtncode    in varchar2,
   pagclass     in varchar2,
   psupdate     in varchar2,
   preturn_date in varchar2,
   pdateformat  in varchar2,
   pextra1      in varchar2,
   pextra2      in varchar2,
   p_circuls    out T_Circul_Cursor);

   procedure cir_unsold_short_excess_p (
   pcompcode    in varchar2,
   punitcode    in varchar2,
   pbrancode    in varchar2,
   pdoctype     in varchar2,
   pfromdate    in varchar2,
   ptilldate    in varchar2,
   pvertype     in varchar2,
   pdateformat  in varchar2,
   pextra1      in varchar2,
   pextra2      in varchar2,
   p_circuls    out T_Circul_Cursor);

procedure cir_daily_return_p (
    pcompcode    in varchar2,
    punitcode    in varchar2,
    ppublcode    in varchar2,
    pagclass     in varchar2,
    pdistcode    in varchar2,
    ptaluka      in varchar2,
    preturn_date in varchar2,
    plangtype    in varchar2,
    pdateformat  in varchar2,
    pextra1      in varchar2,
    pextra2      in varchar2,
    p_circuls    out T_Circul_Cursor);
End cir_rep_unsold_return;
/
CREATE OR REPLACE PACKAGE BODY cir_rep_unsold_return is
procedure cir_unsold_return_p (
    pcompcode    in varchar2,
    punitcode    in varchar2,
    ppublcode    in varchar2,
    pedtncode    in varchar2,
    pagclass     in varchar2,
    psupdate     in varchar2,
    preturn_date in varchar2,
    pdateformat  in varchar2,
    pextra1      in varchar2,
    pextra2      in varchar2,
    p_circuls    out T_Circul_Cursor)
As
    v_dt        date;
    v_return_dt date;
Begin
    v_dt        :=to_date(psupdate,''''||pdateformat||'''');
    v_return_dt :=to_date(preturn_date,''''||pdateformat||'''');

    open p_circuls for
    select 

rec_type,comp_code,unit_code,publ,edtn,agcd,dpcd,agname,ag_name_oth_lang,
    

cir_get_name.cir_drop_point(comp_code,unit_code,drop_point,1,''''||pdateformat|

|'''','','') drop_point_name,
    cir_get_name.cir_city(comp_code,city_code,1,''''||pdateformat||'''','','') 

city_name,
    supdate,supply,new_unsold,old_unsold from
    (select 'I' rec_type,a.comp_code comp_code,a.unit_code unit_code,a.publ 

publ,a.edtn edtn,a.agcd agcd,a.dpcd dpcd,b.ag_name agname,
    b.ag_name_oth_lang ag_name_oth_lang,b.station_code drop_point,b.city_code 

city_code,
    a.supdate supdate,sum(a.sup_copy) supply, null new_unsold,null old_unsold 

from cir_dbksup a,cir_agmast b
    where a.comp_code=pcompcode and a.comp_code=b.comp_code and 

a.unit_code=punitcode and a.unit_code=b.unit and (a.publ=ppublcode or ppublcode 

is null)
    and (a.edtn=pedtncode or pedtncode is null) and a.supdate =v_dt and 

a.agcd=b.agcd and a.dpcd=b.dpcd and (b.ag_class=pagclass or pagclass is null) 

and
    a.agcd||a.dpcd not in(select agcd||dpcd from cir_unsdtl_loc u where 

a.comp_code= u.comp_code and a.unit_code=u.unit_code and
    a.publ= u.publ_code and a.edtn=u.edtn_code and a.supdate=u.supply_dt and 

u.return_dt=v_return_dt and nvl(a.sup_copy,0)>0)
    group by 

a.comp_code,a.unit_code,a.publ,a.edtn,a.agcd,a.dpcd,b.ag_name,b.ag_name_oth_lan

g,b.station_code,b.city_code,a.supdate
    union
    select 'U' rec_type, a.comp_code comp_code,a.unit_code unit_code,a.publ 

publ,a.edtn edtn,a.agcd agcd,a.dpcd dpcd,b.ag_name agname,
    b.ag_name_oth_lang ag_name_oth_lang,b.station_code drop_point,b.city_code 

city_code,
    a.supdate supdate,sum(a.sup_copy) supply, sum(u.new_unsold) 

new_unsold,sum(u.old_unsold) old_unsold from cir_dbksup a,cir_agmast 

b,cir_unsdtl_loc u
    where a.comp_code=pcompcode and a.comp_code= u.comp_code and 

a.comp_code=b.comp_code and a.unit_code=punitcode and a.unit_code=u.unit_code 

and a.unit_code=b.unit and
    (a.publ=ppublcode or ppublcode is null) and a.publ= u.publ_code and 

(a.edtn=pedtncode or pedtncode is null) and a.edtn=u.edtn_code and 

a.supdate=u.supply_dt and
    a.supdate =v_dt and a.agcd=b.agcd and a.dpcd=b.dpcd and a.agcd=u.agcd and 

a.dpcd=u.dpcd and (b.ag_class=pagclass or pagclass is null) and 

u.return_dt=v_return_dt
    group by 

a.comp_code,a.unit_code,a.publ,a.edtn,a.agcd,a.dpcd,b.ag_name,b.ag_name_oth_lan

g,b.station_code,b.city_code,a.supdate)
    order by 

comp_code,unit_code,publ,edtn,city_name,drop_point_name,agname,supdate ;
End cir_unsold_return_p;

procedure cir_unsold_short_excess_p (
    pcompcode    in varchar2,
    punitcode    in varchar2,
    pbrancode    in varchar2,
    pdoctype     in varchar2,
    pfromdate    in varchar2,
    ptilldate    in varchar2,
    pvertype     in varchar2,
    pdateformat  in varchar2,
    pextra1      in varchar2,
    pextra2      in varchar2,
    p_circuls    out T_Circul_Cursor)
As
    v_frdt  date;
    v_todt  date;
Begin
    v_frdt:=to_date(pfromdate,''''||pdateformat||'''');
    v_todt:=to_date(ptilldate,''''||pdateformat||'''');
    --DELETE FROM TEST1;INSERT INTO TEST1(VSTRING,VSTRING2) VALUES('pfromdate 

'||pfromdate||' ptilldate '||ptilldate,'pdateformat '||pdateformat);COMMIT;
    open p_circuls for
    select h.comp_code comp_code,h.unit_code unit_code,h.branch_code 

branch_code,h.recptdt recptdt,h.recptno recptno,h.ver_type ver_type,d.publ_code 

publ_code,
    cir_get_name.cir_publ(h.comp_code,d.publ_code,'1','','','') 

publ_name,h.oth_branch,(select "Branch_Name" from branch_mst where 

"Branch_Code"=h.oth_branch) branch_name,
    d.edtn_code 

edtn_code,cir_get_name.cir_edtn(h.comp_code,h.unit_code,d.edtn_code,'1','','','

') edtn_name,nvl(d.edtn_rate,0) edtn_rate,
    nvl(sum(nvl(d.short_excess,0)*nvl(d.no_of_copy,0)),0) no_of_copy,
    nvl(d.edtn_rate,0)*nvl(sum(nvl(d.short_excess,0)*nvl(d.no_of_copy,0)),0) 

amount,NVL(sum(d.copy_weight),0) copy_weight,NVL(d.copy_rate,0) copy_rate
    from cir_physical_ver_hdr h,cir_physical_ver_det d
    where h.comp_code=d.comp_code and h.comp_code=pcompcode and 

h.unit_code=d.unit_code and h.unit_code=punitcode and
    h.recptno=d.recptno and h.recptdt between v_frdt and v_todt and 

h.doctype=pdoctype and h.doctype=d.doctype and
    (h.branch_code=pbrancode or pbrancode is null) and (h.ver_type=pvertype or 

pvertype is null)
    group by 

h.comp_code,h.unit_code,h.branch_code,h.recptdt,h.recptno,h.ver_type,h.oth_bran

ch,d.publ_code,d.edtn_code,d.edtn_rate,d.copy_rate
    order by comp_code,unit_code,recptdt,recptno,publ_code,edtn_code;
End cir_unsold_short_excess_p;

procedure cir_daily_return_p (
    pcompcode    in varchar2,
    punitcode    in varchar2,
    ppublcode    in varchar2,
    pagclass     in varchar2,
    pdistcode    in varchar2,
    ptaluka      in varchar2,
    preturn_date in varchar2,
    plangtype    in varchar2,
    pdateformat  in varchar2,
    pextra1      in varchar2,--for state code
    pextra2      in varchar2,
    p_circuls    out T_Circul_Cursor)
As
    v_retdt date;
    v_query1     varchar2(32000);
    v_cnt number(10);
      cursor cur_publ is
        select distinct d.comp_code comp_code,d.unit_code unit_code,d.publ_code 

publ,
        

cir_get_name.cir_publ(d.comp_code,d.publ_code,plangtype,pdateformat,'','') 

publ_name,
        cir_get_publ_seqno(d.comp_code,d.publ_code) publ_seqno ,d.supply_dt 

supply_dt
        from cir_agmast m,cir_unsdtl_loc d
        where d.comp_code=pcompcode and d.comp_code=d.comp_code and 

d.unit_code=punitcode and d.unit_code=m.unit and
        m.agcd=d.agcd and m.dpcd=d.dpcd and (d.publ_code=ppublcode or ppublcode 

is null) and  (m.ag_class=pagclass or pagclass is null) and
        (m.state_code=pextra2 or pextra2 is null) and (m.dist_code=pdistcode or 

pdistcode is null) and (m.tehsil_taluka=ptaluka or ptaluka is null) and
        d.return_dt=v_retdt
        group by d.comp_code,d.unit_code,d.publ_code,d.supply_dt
        order by comp_code,unit_code,publ_seqno,publ;

     v1 cur_publ%rowtype;
     vvar       varchar2(8000);
     vvar1      varchar2(8000);
     vtot_publ  varchar2(2000);
Begin
    v_retdt :=to_date(preturn_date,''''||pdateformat||'''');
    insert into test1(vstring,vstring2) values('unsold daily return v_retdt 

',v_retdt||' pcompcode '||pcompcode||' punitcode '||punitcode||' ppublcode 

'||ppublcode||pagclass||','||pdistcode||','||ptaluka||','||preturn_date||','||p

langtype||','||pdateformat||','||pextra1||','||pextra2);commit;
    open cur_publ;
    loop
      fetch cur_publ into v1;
      exit when cur_publ%notfound;
        v_cnt :=nvl(v_cnt,0)+1;
        if vvar is null then
            vvar        

:='decode(u.publ,'||''''||v1.publ||''''||','||''''||v1.publ_name||''''||')"'||s

ubstr(v1.publ_name,1,30)||'",decode(u.publ,'||''''||v1.publ||''''||',sum(u.supp

ly_copy))"'||v1.publ||'_SUPPLY"';
            --vvar      

:='decode(u.publ,'||''''||v1.publ||''''||',sum(u.supply_copy))"'||v1.publ||'_Su

pply"';
            vvar        

:=vvar||',decode(u.publ,'||''''||v1.publ||''''||',sum(u.new_unsold))"'||v1.publ

||'_NU"';
            vvar        

:=vvar||',decode(u.publ,'||''''||v1.publ||''''||',sum(u.old_unsold))"'||v1.publ

||'_OU"';
            vvar        

:=vvar||',round((decode(u.publ,'||''''||v1.publ||''''||',sum(u.old_unsold))*100

)/decode(u.publ,'||''''||v1.publ||''''||',sum(u.supply_copy)),2)"'||v1.publ||'_

PER"';
            vvar1       :='sum("'||v1.publ||'_SUPPLY") 

"'||v1.publ||'_SUPPLY_'||to_char(v1.supply_dt,''||pdateformat||'')||'",sum("'||

v1.publ||'_NU") "'||v1.publ||'_NU",sum("'||v1.publ||'_OU") 

"'||v1.publ||'_OU",sum("'||v1.publ||'_PER") "'||v1.publ||'_PER"';
            vtot_publ   :=substr(v1.publ_name,1,30);
          else
              vvar      

:=vvar||',decode(u.publ,'||''''||v1.publ||''''||','||''''||v1.publ_name||''''||

')"'||substr(v1.publ_name,1,30)||'",decode(u.publ,'||''''||v1.publ||''''||',sum

(u.supply_copy))"'||v1.publ||'_SUPPLY"';
              --vvar    

:=vvar||',decode(u.publ,'||''''||v1.publ||''''||',sum(u.supply_copy))"'||v1.pub

l||'_Supply"';
              vvar      

:=vvar||',decode(u.publ,'||''''||v1.publ||''''||',sum(u.new_unsold))"'||v1.publ

||'_NU"';
              vvar      

:=vvar||',decode(u.publ,'||''''||v1.publ||''''||',sum(u.old_unsold))"'||v1.publ

||'_OU"';
              vvar      

:=vvar||',round((decode(u.publ,'||''''||v1.publ||''''||',sum(u.old_unsold))*100

)/decode(u.publ,'||''''||v1.publ||''''||',sum(u.supply_copy)),2)"'||v1.publ||'_

PER"';
              --vvar1   

:=vvar1||',"'||v1.publ_name||'"'||',sum("'||v1.publ||'_SUPPLY") 

"'||v1.publ||'_SUPPLY",sum("'||v1.publ||'_RETURN") 

"'||v1.publ||'_RETURN",sum("'||v1.publ||'_RETURN_PER") 

"'||v1.publ||'_RETURN_PER"';
              vvar1     :=vvar1||',sum("'||v1.publ||'_SUPPLY") 

"'||v1.publ||'_SUPPLY_'||to_char(v1.supply_dt,''||pdateformat||'')||'",sum("'||

v1.publ||'_NU") "'||v1.publ||'_NU",sum("'||v1.publ||'_OU") 

"'||v1.publ||'_OU",sum("'||v1.publ||'_PER") "'||v1.publ||'_PER"';
              vtot_publ:=vtot_publ||''''||','||''''||substr(v1.publ_name,1,30);
          end if;
    end loop;
    close cur_publ;
        insert into test1(vstring,vstring2) values('unsold daily return vvar1 

',vvar1);commit;
    if vvar is not null and vvar1 is not null then
        v_query1:='select 

comp_code,unit_code,agcd,dpcd,agname,agname_oth_lang,city_name,taluka_name,stat

e_name,dist_name,'||vvar1 ||'
                from (select u.comp_code comp_code,u.unit_code unit_code,u.agcd 

agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang agname_oth_lang,
               

nvl(cir_get_state(u.comp_code,u.country_code,u.state_code),''NA'') state_name,
               nvl(cir_get_dist(u.comp_code,u.state_code,u.dist_code),''NA'') 

dist_name,
               nvl(cir_get_city(u.comp_code,u.city_code),''NA'') city_name,
               nvl(cir_get_taluka(u.comp_code,u.taluka_code),''NA'') 

taluka_name,
               u.publ publ,'||vvar
               ||' from (select b.comp_code comp_code,b.unit_code 

unit_code,b.publ_code publ,
                    b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang 

agname_oth_lang,a.country_code country_code, a.state_code 

state_code,a.city_code city_code,a.dist_code dist_code,a.tehsil_taluka 

taluka_code,
                    (select sum(sup_copy) from cir_dbksup where 

comp_code=b.comp_code and unit_code=b.unit_code and agcd=b.agcd and dpcd=b.dpcd 

and publ=b.publ_code and edtn=b.edtn_code and supdate=b.supply_dt) supply_copy,
                    b.new_unsold new_unsold,b.old_unsold old_unsold
                   from cir_agmast a,cir_unsdtl_loc b
                   where b.comp_code    =a.comp_code and b.comp_code    

='||''''||pcompcode||''''||' and
                         b.unit_code=a.unit and 

b.unit_code='||''''||punitcode||''''||' and
                         (b.publ_code='||''''||ppublcode||''''||' or 

'||''''||ppublcode||''''||' is null) and
                         a.agcd=b.agcd and a.dpcd=b.dpcd and b.return_dt 

='||''''||v_retdt||''''||' and
                         (a.ag_class='||''''||pagclass||''''||' or 

'||''''||pagclass||''''||' is null) and
                         (a.state_code='||''''||pextra2||''''||' or 

'||''''||pextra2||''''||' is null) and
                         (a.dist_code='||''''||pdistcode||''''||' or 

'||''''||pdistcode||''''||' is null) and 

(a.tehsil_taluka='||''''||ptaluka||''''||' or '||''''||ptaluka||''''||' is 

null)) u
                         where u.supply_copy>0
               group by 

u.comp_code,u.unit_code,u.publ,u.agcd,u.dpcd,u.agname,u.agname_oth_lang,u.count

ry_code,u.state_code,u.dist_code,u.city_code,u.taluka_code)
               group by 

comp_code,unit_code,agcd,dpcd,agname,agname_oth_lang,state_name,dist_name,city_

name,taluka_name
               order by 

comp_code,unit_code,state_name,dist_name,taluka_name,agname';
               insert into test1(vstring,vstring2) values('unsold daily return 

vquery1 ',v_query1);commit;
               Begin
                  open p_circuls for v_query1;
                     exception when others then
                          p_circuls:=null;
               End;
       else
        v_query1:='select 

comp_code,unit_code,agcd,dpcd,agname,agname_oth_lang,city_name,taluka_name,dist

_name
                        from (select u.comp_code comp_code,u.unit_code 

unit_code,u.agcd agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang 

agname_oth_lang,
                       

nvl(cir_get_state(u.comp_code,u.country_code,u.state_code),''NA'') state_name,
                       

nvl(cir_get_dist(u.comp_code,u.state_code,u.dist_code),''NA'') dist_name,
                       nvl(cir_get_city(u.comp_code,u.city_code),''NA'') 

city_name,
                       nvl(cir_get_taluka(u.comp_code,u.taluka_code),''NA'') 

taluka_name,
                       u.publ publ from (select b.comp_code 

comp_code,b.unit_code unit_code,b.publ_code publ,
                            b.agcd agcd,b.dpcd dpcd,a.ag_name 

agname,a.ag_name_oth_lang agname_oth_lang,a.country_code country_code, 
                            a.state_code state_code,a.city_code 

city_code,a.dist_code dist_code,a.tehsil_taluka taluka_code,
                            (select sum(sup_copy) from cir_dbksup where 

comp_code=b.comp_code and unit_code=b.unit_code and agcd=b.agcd and dpcd=b.dpcd 

and publ=b.publ_code and edtn=b.edtn_code and supdate=b.supply_dt) supply_copy,
                            b.new_unsold new_unsold,b.old_unsold old_unsold
                           from cir_agmast a,cir_unsdtl_loc b
                           where b.comp_code    =a.comp_code and b.comp_code    

='||''''||pcompcode||''''||' and
                                 b.unit_code=a.unit and 

b.unit_code='||''''||punitcode||''''||' and
                                 (b.publ_code='||''''||ppublcode||''''||' or 

'||''''||ppublcode||''''||' is null) and
                                 a.agcd=b.agcd and a.dpcd=b.dpcd and 

b.return_dt ='||''''||v_retdt||''''||' and
                                 (a.ag_class='||''''||pagclass||''''||' or 

'||''''||pagclass||''''||' is null) and
                                 (a.state_code='||''''||pextra2||''''||' or 

'||''''||pextra2||''''||' is null) and
                                 (a.dist_code='||''''||pdistcode||''''||' or 

'||''''||pdistcode||''''||' is null) and 

(a.tehsil_taluka='||''''||ptaluka||''''||' or '||''''||ptaluka||''''||' is 

null)) u
                                 where u.supply_copy>0
                       group by 

u.comp_code,u.unit_code,u.publ,u.agcd,u.dpcd,u.agname,u.agname_oth_lang,u.count

ry_code,u.state_code,u.dist_code,u.city_code,u.taluka_code)
                       group by 

comp_code,unit_code,agcd,dpcd,agname,agname_oth_lang,state_name,dist_name,city_

name,taluka_name
                       order by 

comp_code,unit_code,dist_name,taluka_name,agname';
           insert into test1(vstring,vstring2) values('unsold daily return 

vquery1 ',v_query1);commit;
           Begin
              open p_circuls for v_query1;
                 exception when others then
                      p_circuls:=null;
           End;
       end if;
End cir_daily_return_p;
End cir_rep_unsold_return;
/

/**********laxman sir 28-sept*******************/


/**********laxman sir 28-sept*******************/


/////////////////////////////////////////////NEW PROCEDURE UPDATED FOR ISSUE NO 4768 29/09/2011=========================
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER PROCEDURE [dbo].[cir_rep_supply_cir_rep_supply_unit]
	@pcomp_code			VARCHAR(20) ,
	@punit_code         VARCHAR(20) ,
	@ppubl              VARCHAR(20) ,
	@pfrom_supdate      datetime ,
	@ptill_supdate      datetime ,
	@pdateformat        VARCHAR(20) ,
	@pextra1            VARCHAR(40) ,
	@pextra2            VARCHAR(40) 
AS

declare @supply_type_name	varchar(400)
declare @supply_sum			varchar(400)
declare @supply_seqno		int
declare @vfrom_supdate      varchar(40)
declare @vtill_supdate      varchar(40)

	DECLARE cur_sup_type cursor LOCAL FOR 
		SELECT distinct 'sum( case sup_type_code when ' + '''' + CAST(s.sup_ty_code AS VARCHAR) + '''' + ' then sup_copy else 0 end) "' + CAST(s.sup_ty_name AS VARCHAR) + '",' vty,
				 'sum(case sup_type_code when ' + '''' + CAST(s.sup_ty_code AS VARCHAR) + '''' + 'then sup_copy else 0 end) +' vty_sum,s.sup_seq_no sup_seq_no
		from cir_supply_type_mast s,cir_dbksup d
        where s.comp_code=d.comp_code and s.comp_code=@pcomp_code and (d.unit_code=isnull(@punit_code,d.unit_code) or @punit_code is null or @punit_code='') and 
            (d.publ=isnull(@ppubl,d.publ) or @ppubl='') and d.supdate between @pfrom_supdate and @ptill_supdate and
            s.sup_ty_code=d.sup_type_code
			order by sup_seq_no
			
	DECLARE @vvar		VARCHAR(4000) 
	DECLARE @vvar_sum   VARCHAR(4000) 
	DECLARE @vquery     VARCHAR(4000) 
	DECLARE @vquery1    VARCHAR(4000) 

	DECLARE @vquery2    VARCHAR(4000) 
	DECLARE @vquery12   VARCHAR(4000) 

	set @vfrom_supdate =convert(varchar(20),@pfrom_supdate,101)
	set @vtill_supdate =convert(varchar(20),@ptill_supdate,101)

	OPEN cur_sup_type
	fetch NEXT from  cur_sup_type into @supply_type_name,@supply_sum,@supply_seqno

			WHILE (@@FETCH_STATUS = 0) 
			BEGIN 
			   set @vvar =COALESCE(@vvar+'', SPACE(0)) + '' + COALESCE(@supply_type_name + '', SPACE(0))
		       set @vvar_sum=COALESCE(@vvar_sum+'', SPACE(0)) + '' + COALESCE(@supply_sum + '', SPACE(0))
			fetch NEXT from  cur_sup_type into @supply_type_name,@supply_sum,@supply_seqno
			END 
	close cur_sup_type

	SET @vvar		= SUBSTRING(@vvar, 1, LEN(@vvar) - 1)
	SET @vvar_sum	= SUBSTRING(@vvar_sum, 1, LEN(@vvar_sum) - 1)

	If @vvar is null or @vvar='' Begin
		SET @vquery  = ' select comp_code AS "COMP_CODE",(select distinct "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=unit_code) AS "UNIT_CODE",publ AS "PUBL", dbo.cir_get_publ_name(comp_code,publ) AS "PUBL_NAME",sup_rate as "SUP_RATE", supdate AS "SUPDATE",sum(sup_copy) ' 
		SET @vquery2  = ' TOTAL from cir_dbksup where comp_code=' + '''' + @pcomp_code + '''' + ' and 
			((unit_code=' + '''' + @punit_code + '''' + ') or (' + '''' + @punit_code + '''' + ' is null)) and (publ=' + '''' + @ppubl + '''' + ' or ' + '''' + @ppubl + '''' + ' is null  or ' + '''' + @ppubl + '''' + '='+''''+''''+') and  supdate between ' + ''''  + @vfrom_supdate + ''''  + '  and ' + '''' + @vtill_supdate +'''' + '  group by comp_code,unit_code,sup_rate,supdate,publ order by comp_code,unit_code,publ_name,supdate,sup_rate' 
	End
	Else Begin
		SET @vquery  = ' select comp_code AS "COMP_CODE",(select distinct "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=unit_code) AS "UNIT_CODE",publ AS "PUBL", dbo.cir_get_publ_name(comp_code,publ) AS "PUBL_NAME",sup_rate as "SUP_RATE", supdate AS "SUPDATE",' + @vvar + ',' 
		SET @vquery2  = @vvar_sum + ' TOTAL from cir_dbksup where comp_code=' + '''' + @pcomp_code + '''' + ' and 
			((unit_code=' + '''' + @punit_code + '''' + ') or (' + '''' + @punit_code + '''' + ' is null)) and (publ=' + '''' + @ppubl + '''' + ' or ' + '''' + @ppubl + '''' + ' is null  or ' + '''' + @ppubl + '''' + '='+''''+''''+') and  supdate between ' + ''''  + @vfrom_supdate + ''''  + '  and ' + '''' + @vtill_supdate +'''' + '  group by comp_code,unit_code,sup_rate,supdate,publ order by comp_code,unit_code,publ_name,supdate,sup_rate' 
	End
	
	print(@vquery)print(@vquery2)
	EXEC (@vquery + @vquery2) 
	print('1')
	If @vvar is null or @vvar='' Begin
		SET @vquery1  = ' select comp_code AS "COMP_CODE",sup_rate as "SUP_RATE",sum(sup_copy)' 
		SET @vquery12  =' TOTAL from cir_dbksup where comp_code=' + '''' + @pcomp_code + '''' + ' and (unit_code=' + '''' + @punit_code + '''' + ' or ' + '''' +@punit_code + '''' + ' is null) and (publ=' + '''' + @ppubl + '''' + ' or ' + '''' + @ppubl + '''' + ' is null  or ' + '''' + @ppubl + '''' + '='+''''+''''+') and  supdate between' +  '''' + @vfrom_supdate + '''' +'  and ' + '''' + @vtill_supdate + '''' + ' group by comp_code,sup_rate order by comp_code,sup_rate' 
		End
	Else Begin
		SET @vquery1  = ' select comp_code AS "COMP_CODE",sup_rate as "SUP_RATE",' + @vvar + ',' 
		SET @vquery12  = @vvar_sum + ' TOTAL from cir_dbksup where comp_code=' + '''' + @pcomp_code + '''' + ' and (unit_code=' + '''' + @punit_code + '''' + ' or ' + '''' +@punit_code + '''' + ' is null) and (publ=' + '''' + @ppubl + '''' + ' or ' + '''' + @ppubl + '''' + ' is null  or ' + '''' + @ppubl + '''' + '='+''''+''''+') and  supdate between' +  '''' + @vfrom_supdate + '''' +'  and ' + '''' + @vtill_supdate + '''' + ' group by comp_code,sup_rate order by comp_code,sup_rate' 
	END
	print(@vquery1 + @vquery12) 
	EXEC (@vquery1 + @vquery12) 
DEALLOCATE cur_sup_type

////////////////////////////////////////////  end of NEW PROCEDURE UPDATED FOR ISSUE NO 4768 29/09/2011=============
/*************prachi       5106     30-sept***************/


                                             
ALTER PROCEDURE cir_demographic_cir_city_bind1
	@pcomp_code		VARCHAR(20) ,
	@pdateformat    VARCHAR(20) ,
	@pextra1        VARCHAR(400) ,
	@pextra2        VARCHAR(400) 
AS 
	SELECT
         CAST(city_name AS VARCHAR) + '-' + CAST(DBO.cir_get_dist(cir_city_mast.comp_code, 
         cir_city_mast.state_code, cir_city_mast.dist_code) AS VARCHAR) + '(' + CAST(DBO.cir_get_state(cir_city_mast.comp_code, cir_city_mast.country_code, cir_city_mast.state_code) AS VARCHAR) + ')' CITY_NAME,
         city_code  CITY_CODE,
         dist_code DIST_CODE,
         DBO.cir_get_dist(cir_city_mast.comp_code, cir_city_mast.state_code, cir_city_mast.dist_code) DIST_NAME,
         state_code STATE_CODE,
         DBO.cir_get_state(cir_city_mast.comp_code, cir_city_mast.country_code, cir_city_mast.state_code) STATE_NAME,
         country_code COUNTRY_CODE,
         DBO.cir_get_country(cir_city_mast.comp_code, cir_city_mast.country_code) COUNTRY_NAME,
         zone_code ZONE_CODE,dbo.cir_get_zone_name(cir_city_mast.comp_code,cir_city_mast.zone_code) ZONE_NAME
		FROM  cir_city_mast 
		WHERE comp_code  = @pcomp_code AND 
			((UPPER(city_name)  like UPPER(@pextra1) + '%') OR	(@pextra1  is null) OR	(@pextra1 =''))
		ORDER BY city_name 

                                                                     
                                                                     
                                                                     
ALTER PROCEDURE [dbo].[cir_demographic_cir_city_bind2]
	@pcomp_code			VARCHAR(20) ,
	@pcity_code         VARCHAR(20) ,
	@pdateformat        VARCHAR(20) ,
	@pextra1            VARCHAR(400) ,
	@pextra2            VARCHAR(400) 
AS 
	SELECT
             CAST(city_name AS VARCHAR) + '-' + CAST(DBO.cir_get_dist(cir_city_mast.comp_code, cir_city_mast.state_code, cir_city_mast.dist_code) AS VARCHAR) + ' (' + CAST(DBO.cir_get_state(cir_city_mast.comp_code, cir_city_mast.country_code, cir_city_mast.state_code) AS VARCHAR) + ')' CITY_NAME,
             CITY_CODE,
             DIST_CODE,
             DBO.cir_get_dist(cir_city_mast.comp_code, cir_city_mast.state_code, cir_city_mast.dist_code) DIST_NAME,
             STATE_CODE,
             DBO.cir_get_state(cir_city_mast.comp_code, cir_city_mast.country_code, cir_city_mast.state_code) STATE_NAME,
             COUNTRY_CODE,
             DBO.cir_get_country(cir_city_mast.comp_code, cir_city_mast.country_code) COUNTRY_NAME,
             '' TALUKA_NAME,
             zone_code ZONE_CODE,DBO.cir_get_zone_name(cir_city_mast.comp_code,cir_city_mast.zone_code) ZONE_NAME
    FROM  cir_city_mast 
	WHERE comp_code  = @pcomp_code
	 AND (city_code  = @pcity_code OR	@pcity_code  is null  OR	@pcity_code = '')
	 AND ((UPPER(city_name)  like UPPER(@pextra1) + '%') OR	(@pextra1  is null)  OR	(@pextra1  = ''))
	ORDER BY city_name 


ALTER procedure [dbo].[cir_reason_bind_p]
	@pcomp_code       VARCHAR(20),
    @preason_code     VARCHAR(20),
    @pdateformat      VARCHAR(20),
    @pextra1          VARCHAR(200),
    @pextra2          VARCHAR(200) 
AS 
  
  select * from cir_reason_mst
  where comp_code=@pcomp_code and (reason_code=@preason_code or @preason_code is null or @preason_code = '' )
  order by reason_name;



/*************prachi       5106     30-sept***************/
/**************prachi 4992       30-sept********************/
                                       
ALTER PROCEDURE [dbo].[cir_supply_populate_p]
    @pcomp_code                               VARCHAR(20) ,
    @punit                                    VARCHAR(20) ,
    @pagcd                                    VARCHAR(20) ,
    @pdpcd                                    VARCHAR(20) ,
    @ppubl                                    VARCHAR(20) ,
    @pedtn                                    VARCHAR(20) ,
    @pdateformat                              VARCHAR(20) ,
    @pextra1                                  VARCHAR(4000) ,
    @pextra2                                  VARCHAR(4000) 
AS 
Begin
	if upper(@pextra2)='D' Begin
         select SUPPLY_TYPE_CODE,DBO.CIR_GET_SUPPLY_NAME(COMP_CODE,SUPPLY_TYPE_CODE) SUPPLY_TYPE_NAME,BASE_SUPPLY,SUPPLY_SUN,SUPPLY_MON,SUPPLY_TUE,
                SUPPLY_WED,SUPPLY_THU,SUPPLY_FRI,SUPPLY_SAT,SUPPLY_SPL1,SUPPLY_SPL2,SUPPLY_FLAG,BASE_SUPPLY,PACKET_SIZE,COMM_CODE,COMM_FLAG,
                LBL_PRINTNO SUPPLY_SEQ,ROUTE_CODE,DBO.CIR_GET_NAME_CIR_ROUTE(COMP_CODE,UNIT,ROUTE_CODE,1,@PDATEFORMAT,'','') ROUTE_NAME, 
                SUBROUTE_CODE ,DBO.CIR_GET_NAME_CIR_SUBROUTE(COMP_CODE,UNIT,ROUTE_CODE,SUBROUTE_CODE,1,@PDATEFORMAT,'','') SUBROUTE_NAME,
                SUB_SUBROUTE_CODE,DBO.CIR_GET_NAME_CIR_SUBSUBROUTE(COMP_CODE,UNIT,ROUTE_CODE,SUBROUTE_CODE,SUB_SUBROUTE_CODE,1,@PDATEFORMAT,'','') SUBSUBROUTE_NAME
                from cir_supply_dis
              where comp_code=@pcomp_code and unit=@punit and agcd=@pagcd and dpcd=@pdpcd and publ=@ppubl and edtn=@pedtn
              order by supply_type_name
		End
    else Begin
         select SUPPLY_TYPE_CODE,DBO.CIR_GET_SUPPLY_NAME(COMP_CODE,SUPPLY_TYPE_CODE) SUPPLY_TYPE_NAME,BASE_SUPPLY,SUPPLY_SUN,SUPPLY_MON,SUPPLY_TUE,
                SUPPLY_WED,SUPPLY_THU,SUPPLY_FRI,SUPPLY_SAT,SUPPLY_SPL1,SUPPLY_SPL2,SUPPLY_FLAG,BASE_SUPPLY,PACKET_SIZE,COMM_CODE,COMM_FLAG,
                LBL_PRINTNO SUPPLY_SEQ,ROUTE_CODE,DBO.CIR_GET_NAME_CIR_ROUTE(COMP_CODE,UNIT,ROUTE_CODE,1,@PDATEFORMAT,'','') ROUTE_NAME, 
                SUBROUTE_CODE ,DBO.CIR_GET_NAME_CIR_SUBROUTE(COMP_CODE,UNIT,ROUTE_CODE,SUBROUTE_CODE,1,@PDATEFORMAT,'','') SUBROUTE_NAME,
                SUB_SUBROUTE_CODE,DBO.CIR_GET_NAME_CIR_SUBSUBROUTE(COMP_CODE,UNIT,ROUTE_CODE,SUBROUTE_CODE,SUB_SUBROUTE_CODE,1,@PDATEFORMAT,'','') SUBSUBROUTE_NAME
                from cir_supply
              where comp_code=@pcomp_code and unit=@punit and agcd=@pagcd and dpcd=@pdpcd and publ=@ppubl and edtn=@pedtn
              order by supply_type_name
	End
End

                                                            
                                             
ALTER procedure [dbo].[cir_supply_alteration_p]
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
      @pbrancode         as varchar(20),
      @proutecode        as varchar(20),
      @pagcd_code        as varchar(20),
      @pdpcd_code        as varchar(20),
      @psorted_by        as varchar(20),---1 for  edition route wise,2 for edition district wise
      @pdateformat       as varchar(20),
      @pextra1           as varchar(200),--agency type
      @pextra2           as varchar(200),--for agency--A and distribution--D
      @pextra3           as varchar(200),--agency class
      @pextra4           as varchar(200),
      @pextra5           as varchar(200)
 As
	
 Begin
  if upper(@pextra2)='D' Begin
      if @psorted_by='2' Begin---for edition district and agency wise
            SELECT A.COMP_CODE COMP_CODE,A.UNIT UNIT,A.AGCD AGCD,A.DPCD DPCD,A.AG_NAME AGENCY_NAME,A.AG_NAME_OTH_LANG AGENCY_NAME_OTHER_LANG,A.CITY_CODE CITY_CODE,
            DBO.CIR_GET_CITY(A.COMP_CODE,A.CITY_CODE) CITY_NAME,A.STATION_CODE DROP_POINT_CODE,DBO.CIR_GET_DROP_POINT_NAME(A.COMP_CODE,A.UNIT,A.STATION_CODE,'1') DROP_POINT_NAME,
            ISNULL(C.BASE_SUPPLY,0) BASE_SUPPLY,ISNULL(C.SUPPLY_SUN,0) SUPPLY_SUN,ISNULL(C.SUPPLY_MON,0) SUPPLY_MON,ISNULL(C.SUPPLY_TUE,0) SUPPLY_TUE,ISNULL(C.SUPPLY_WED,0) SUPPLY_WED,
            ISNULL(C.SUPPLY_THU,0) SUPPLY_THU,ISNULL(C.SUPPLY_FRI,0) SUPPLY_FRI,ISNULL(C.SUPPLY_SAT,0) SUPPLY_SAT,ISNULL(C.SUPPLY_SPL1,0) SUPPLY_SPL1,ISNULL(C.SUPPLY_SPL2,0) SUPPLY_SPL2,
            C.LBL_PRINTNO SUPPLY_SEQ,DBO.CIR_GET_ROUTE_SEQNO(C.COMP_CODE,C.UNIT,C.ROUTE_CODE) ROUTE_SEQ,
            C.ROUTE_CODE,DBO.CIR_GET_NAME_CIR_ROUTE(A.COMP_CODE,A.UNIT,C.ROUTE_CODE,1,@PDATEFORMAT,'','') ROUTE_NAME, 
            C.SUBROUTE_CODE,DBO.CIR_GET_NAME_CIR_SUBROUTE(A.COMP_CODE,A.UNIT,C.ROUTE_CODE,C.SUBROUTE_CODE,1,@PDATEFORMAT,'','') SUBROUTE_NAME,
            C.SUB_SUBROUTE_CODE,DBO.CIR_GET_NAME_CIR_SUBSUBROUTE(A.COMP_CODE,A.UNIT,C.ROUTE_CODE,C.SUBROUTE_CODE,C.SUB_SUBROUTE_CODE,1,@PDATEFORMAT,'','') SUBSUBROUTE_NAME,
            D.DIST_NAME DIST_NAME,ISNULL(P.CIR_SUP_ORDER_LIMIT,0) CIR_SUP_ORDER_LIMIT,C.SUPPLY_TYPE_CODE SUPPLY_TYPE_CODE,B.SUP_TY_NAME SUPPLY_TYPE_NAME,
			C.EDTN EDTN,E.EDTN_NAME EDTN_NAME,B.SUP_SEQ_NO SUP_SEQ_NO
            from cir_agmast_dis a left outer join cir_dist_mast d on a.comp_code=d.comp_code and a.dist_code=d.dist_code,cir_supply_type_mast b,cir_supply c,cir_edtn_mast e,preferrences p
            where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=e.comp_code and  a.comp_code= @pcomp_code and p.comp_code= @pcomp_code and
            a.unit=c.unit and a.unit=e.unit_code and a.unit= @punit_code and b.sup_ty_code=c.supply_type_code and
            c.publ=e.publ and c.publ= @ppubl_code and c.edtn=e.edtn and (c.edtn = isnull(@pedtn_code,c.edtn) or @pedtn_code='') and (e.main_edtn = isnull(@pmedtn_code,e.main_edtn) or @pmedtn_code='') and 
            a.agcd=c.agcd and (a.bill_agcd=isnull(@pagcd_code,a.bill_agcd) or @pagcd_code='') and a.dpcd=c.dpcd and (a.bill_dpcd=isnull(@pdpcd_code,a.bill_dpcd) or @pdpcd_code='') and (c.supply_type_code= @psup_type or @psup_type is null or @psup_type='') and 
			(a.state_code=@pstate or @pstate is null or @pstate='') and
            (a.dist_code=@pdistcode or @pdistcode is null  or @pdistcode='') and (a.tehsil_taluka = @ptaluka or @ptaluka is null or @ptaluka='') and
            (a.city_code=@pcitycode or @pcitycode is null) and (a.branch_code = @pbrancode or @pbrancode is null or @pbrancode='') and
            (c.route_code=@proutecode or @proutecode is null) and isnull(c.supply_flag,'N') ='Y' and isnull(a.suspend,'N')='N' and
			(a.ag_type=@pextra1 or @pextra1 is null or @pextra1='') and (a.ag_class=@pextra3 or @pextra3 is null or @pextra3='')
            order by dist_name,agency_name,edtn_name,sup_seq_no,supply_type_name,supply_seq
		End
      else Begin
          SELECT A.COMP_CODE COMP_CODE,A.UNIT UNIT,A.AGCD AGCD,A.DPCD DPCD,A.AG_NAME AGENCY_NAME,A.AG_NAME_OTH_LANG AGENCY_NAME_OTHER_LANG,A.CITY_CODE CITY_CODE,
            DBO.CIR_GET_CITY(A.COMP_CODE,A.CITY_CODE) CITY_NAME,A.STATION_CODE DROP_POINT_CODE,DBO.CIR_GET_DROP_POINT_NAME(A.COMP_CODE,A.UNIT,A.STATION_CODE,'1') DROP_POINT_NAME,
            ISNULL(C.BASE_SUPPLY,0) BASE_SUPPLY,ISNULL(C.SUPPLY_SUN,0) SUPPLY_SUN,ISNULL(C.SUPPLY_MON,0) SUPPLY_MON,ISNULL(C.SUPPLY_TUE,0) SUPPLY_TUE,ISNULL(C.SUPPLY_WED,0) SUPPLY_WED,
            ISNULL(C.SUPPLY_THU,0) SUPPLY_THU,ISNULL(C.SUPPLY_FRI,0) SUPPLY_FRI,ISNULL(C.SUPPLY_SAT,0) SUPPLY_SAT,ISNULL(C.SUPPLY_SPL1,0) SUPPLY_SPL1,ISNULL(C.SUPPLY_SPL2,0) SUPPLY_SPL2,
            C.LBL_PRINTNO SUPPLY_SEQ,DBO.CIR_GET_ROUTE_SEQNO(C.COMP_CODE,C.UNIT,C.ROUTE_CODE) ROUTE_SEQ,
            C.ROUTE_CODE,DBO.CIR_GET_NAME_CIR_ROUTE(A.COMP_CODE,A.UNIT,C.ROUTE_CODE,1,@PDATEFORMAT,'','') ROUTE_NAME, 
            C.SUBROUTE_CODE,DBO.CIR_GET_NAME_CIR_SUBROUTE(A.COMP_CODE,A.UNIT,C.ROUTE_CODE,C.SUBROUTE_CODE,1,@PDATEFORMAT,'','') SUBROUTE_NAME,
            C.SUB_SUBROUTE_CODE,DBO.CIR_GET_NAME_CIR_SUBSUBROUTE(A.COMP_CODE,A.UNIT,C.ROUTE_CODE,C.SUBROUTE_CODE,C.SUB_SUBROUTE_CODE,1,@PDATEFORMAT,'','') SUBSUBROUTE_NAME,
            D.DIST_NAME DIST_NAME,ISNULL(P.CIR_SUP_ORDER_LIMIT,0) CIR_SUP_ORDER_LIMIT,C.SUPPLY_TYPE_CODE SUPPLY_TYPE_CODE,B.SUP_TY_NAME SUPPLY_TYPE_NAME,
			C.EDTN EDTN,E.EDTN_NAME EDTN_NAME,B.SUP_SEQ_NO SUP_SEQ_NO
            from cir_agmast_dis a left outer join cir_dist_mast d on a.comp_code=d.comp_code and a.dist_code=d.dist_code,cir_supply_type_mast b,cir_supply c,cir_edtn_mast e,preferrences p
            where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=e.comp_code and  a.comp_code= @pcomp_code and p.comp_code= @pcomp_code and
            a.unit=c.unit and a.unit=e.unit_code and a.unit= @punit_code and b.sup_ty_code=c.supply_type_code and
            c.publ=e.publ and c.publ= @ppubl_code and c.edtn=e.edtn and (c.edtn = isnull(@pedtn_code,c.edtn) or @pedtn_code='') and (e.main_edtn = isnull(@pmedtn_code,e.main_edtn) or @pmedtn_code='') and 
            a.agcd=c.agcd and (a.bill_agcd=isnull(@pagcd_code,a.bill_agcd) or @pagcd_code='') and a.dpcd=c.dpcd and (a.bill_dpcd=isnull(@pdpcd_code,a.bill_dpcd) or @pdpcd_code='') and (c.supply_type_code= @psup_type or @psup_type is null or @psup_type='') and 
			(a.state_code=@pstate or @pstate is null or @pstate='') and
            (a.dist_code=@pdistcode or @pdistcode is null  or @pdistcode='') and (a.tehsil_taluka = @ptaluka or @ptaluka is null or @ptaluka='') and
            (a.city_code=@pcitycode or @pcitycode is null) and (a.branch_code = @pbrancode or @pbrancode is null or @pbrancode='') and
            (c.route_code=@proutecode or @proutecode is null) and isnull(c.supply_flag,'N') ='Y' and isnull(a.suspend,'N')='N' and
			(a.ag_type=@pextra1 or @pextra1 is null or @pextra1='') and (a.ag_class=@pextra3 or @pextra3 is null or @pextra3='')
             order by route_seq,supply_seq,agency_name,edtn_name,sup_seq_no,supply_type_name
	End
	end
  else	Begin
      if @psorted_by='2' Begin---for edition district and agency wise
            SELECT A.COMP_CODE COMP_CODE,A.UNIT UNIT,A.AGCD AGCD,A.DPCD DPCD,A.AG_NAME AGENCY_NAME,A.AG_NAME_OTH_LANG AGENCY_NAME_OTHER_LANG,A.CITY_CODE CITY_CODE,
            DBO.CIR_GET_CITY(A.COMP_CODE,A.CITY_CODE) CITY_NAME,A.STATION_CODE DROP_POINT_CODE,DBO.CIR_GET_DROP_POINT_NAME(A.COMP_CODE,A.UNIT,A.STATION_CODE,'1') DROP_POINT_NAME,
            ISNULL(C.BASE_SUPPLY,0) BASE_SUPPLY,ISNULL(C.SUPPLY_SUN,0) SUPPLY_SUN,ISNULL(C.SUPPLY_MON,0) SUPPLY_MON,ISNULL(C.SUPPLY_TUE,0) SUPPLY_TUE,ISNULL(C.SUPPLY_WED,0) SUPPLY_WED,
            ISNULL(C.SUPPLY_THU,0) SUPPLY_THU,ISNULL(C.SUPPLY_FRI,0) SUPPLY_FRI,ISNULL(C.SUPPLY_SAT,0) SUPPLY_SAT,ISNULL(C.SUPPLY_SPL1,0) SUPPLY_SPL1,ISNULL(C.SUPPLY_SPL2,0) SUPPLY_SPL2,
            C.LBL_PRINTNO SUPPLY_SEQ,DBO.CIR_GET_ROUTE_SEQNO(C.COMP_CODE,C.UNIT,C.ROUTE_CODE) ROUTE_SEQ,
            C.ROUTE_CODE,DBO.CIR_GET_NAME_CIR_ROUTE(A.COMP_CODE,A.UNIT,C.ROUTE_CODE,1,@PDATEFORMAT,'','') ROUTE_NAME, 
            C.SUBROUTE_CODE,DBO.CIR_GET_NAME_CIR_SUBROUTE(A.COMP_CODE,A.UNIT,C.ROUTE_CODE,C.SUBROUTE_CODE,1,@PDATEFORMAT,'','') SUBROUTE_NAME,
            C.SUB_SUBROUTE_CODE,DBO.CIR_GET_NAME_CIR_SUBSUBROUTE(A.COMP_CODE,A.UNIT,C.ROUTE_CODE,C.SUBROUTE_CODE,C.SUB_SUBROUTE_CODE,1,@PDATEFORMAT,'','') SUBSUBROUTE_NAME,
            D.DIST_NAME DIST_NAME,ISNULL(P.CIR_SUP_ORDER_LIMIT,0) CIR_SUP_ORDER_LIMIT,C.SUPPLY_TYPE_CODE SUPPLY_TYPE_CODE,B.SUP_TY_NAME SUPPLY_TYPE_NAME,
			C.EDTN EDTN,E.EDTN_NAME EDTN_NAME,B.SUP_SEQ_NO SUP_SEQ_NO
            from cir_agmast a left outer join cir_dist_mast d on a.comp_code=d.comp_code and a.dist_code=d.dist_code,
            cir_supply_type_mast b,cir_supply c,cir_edtn_mast e,preferrences p
            where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=e.comp_code and  a.comp_code= @pcomp_code and p.comp_code= @pcomp_code and
            a.unit=c.unit and a.unit=e.unit_code and a.unit= @punit_code and b.sup_ty_code=c.supply_type_code and
            c.publ=e.publ and c.publ= @ppubl_code and c.edtn=e.edtn and (c.edtn = isnull(@pedtn_code,c.edtn) or @pedtn_code='') and (e.main_edtn = isnull(@pmedtn_code,e.main_edtn) or @pmedtn_code='') and 
            a.agcd=c.agcd and (a.bill_agcd=isnull(@pagcd_code,a.bill_agcd) or @pagcd_code='') and a.dpcd=c.dpcd and (a.bill_dpcd=isnull(@pdpcd_code,a.bill_dpcd) or @pdpcd_code='') and (c.supply_type_code= @psup_type or @psup_type is null or @psup_type='') and 
			(a.state_code=@pstate or @pstate is null or @pstate='') and
            (a.dist_code=@pdistcode or @pdistcode is null  or @pdistcode='') and (a.tehsil_taluka = @ptaluka or @ptaluka is null or @ptaluka='') and
            (a.city_code=@pcitycode or @pcitycode is null) and (a.branch_code = @pbrancode or @pbrancode is null or @pbrancode='') and
            (c.route_code=@proutecode or @proutecode is null) and isnull(c.supply_flag,'N') ='Y' and isnull(a.suspend,'N')='N' and
			(a.ag_type=@pextra1 or @pextra1 is null or @pextra1='') and (a.ag_class=@pextra3 or @pextra3 is null or @pextra3='')
            order by dist_name,agency_name,edtn_name,sup_seq_no,supply_type_name,supply_seq
	End
      else	Begin
          SELECT A.COMP_CODE COMP_CODE,A.UNIT UNIT,A.AGCD AGCD,A.DPCD DPCD,A.AG_NAME AGENCY_NAME,A.AG_NAME_OTH_LANG AGENCY_NAME_OTHER_LANG,A.CITY_CODE CITY_CODE,
            DBO.CIR_GET_CITY(A.COMP_CODE,A.CITY_CODE) CITY_NAME,A.STATION_CODE DROP_POINT_CODE,DBO.CIR_GET_DROP_POINT_NAME(A.COMP_CODE,A.UNIT,A.STATION_CODE,'1') DROP_POINT_NAME,
            ISNULL(C.BASE_SUPPLY,0) BASE_SUPPLY,ISNULL(C.SUPPLY_SUN,0) SUPPLY_SUN,ISNULL(C.SUPPLY_MON,0) SUPPLY_MON,ISNULL(C.SUPPLY_TUE,0) SUPPLY_TUE,ISNULL(C.SUPPLY_WED,0) SUPPLY_WED,
            ISNULL(C.SUPPLY_THU,0) SUPPLY_THU,ISNULL(C.SUPPLY_FRI,0) SUPPLY_FRI,ISNULL(C.SUPPLY_SAT,0) SUPPLY_SAT,ISNULL(C.SUPPLY_SPL1,0) SUPPLY_SPL1,ISNULL(C.SUPPLY_SPL2,0) SUPPLY_SPL2,
            C.LBL_PRINTNO SUPPLY_SEQ,DBO.CIR_GET_ROUTE_SEQNO(C.COMP_CODE,C.UNIT,C.ROUTE_CODE) ROUTE_SEQ,
            C.ROUTE_CODE,DBO.CIR_GET_NAME_CIR_ROUTE(A.COMP_CODE,A.UNIT,C.ROUTE_CODE,1,@PDATEFORMAT,'','') ROUTE_NAME, 
            C.SUBROUTE_CODE,DBO.CIR_GET_NAME_CIR_SUBROUTE(A.COMP_CODE,A.UNIT,C.ROUTE_CODE,C.SUBROUTE_CODE,1,@PDATEFORMAT,'','') SUBROUTE_NAME,
            C.SUB_SUBROUTE_CODE,DBO.CIR_GET_NAME_CIR_SUBSUBROUTE(A.COMP_CODE,A.UNIT,C.ROUTE_CODE,C.SUBROUTE_CODE,C.SUB_SUBROUTE_CODE,1,@PDATEFORMAT,'','') SUBSUBROUTE_NAME,
            D.DIST_NAME DIST_NAME,ISNULL(P.CIR_SUP_ORDER_LIMIT,0) CIR_SUP_ORDER_LIMIT,C.SUPPLY_TYPE_CODE SUPPLY_TYPE_CODE,B.SUP_TY_NAME SUPPLY_TYPE_NAME,
			C.EDTN EDTN,E.EDTN_NAME EDTN_NAME,B.SUP_SEQ_NO SUP_SEQ_NO
            from cir_agmast a left outer join cir_dist_mast d on a.comp_code=d.comp_code and a.dist_code=d.dist_code,cir_supply_type_mast b,cir_supply c,cir_edtn_mast e,preferrences p
			where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=e.comp_code and  a.comp_code= @pcomp_code and p.comp_code= @pcomp_code and
            a.unit=c.unit and a.unit=e.unit_code and a.unit= @punit_code and b.sup_ty_code=c.supply_type_code and
            c.publ=e.publ and c.publ= @ppubl_code and c.edtn=e.edtn and (c.edtn = isnull(@pedtn_code,c.edtn) or @pedtn_code='') and (e.main_edtn = isnull(@pmedtn_code,e.main_edtn) or @pmedtn_code='') and 
            a.agcd=c.agcd and (a.bill_agcd=isnull(@pagcd_code,a.bill_agcd) or @pagcd_code='') and a.dpcd=c.dpcd and (a.bill_dpcd=isnull(@pdpcd_code,a.bill_dpcd) or @pdpcd_code='') and (c.supply_type_code= @psup_type or @psup_type is null or @psup_type='') and 
			(a.state_code=@pstate or @pstate is null or @pstate='') and
            (a.dist_code=@pdistcode or @pdistcode is null  or @pdistcode='') and (a.tehsil_taluka = @ptaluka or @ptaluka is null or @ptaluka='') and
            (a.city_code=@pcitycode or @pcitycode is null) and (a.branch_code = @pbrancode or @pbrancode is null or @pbrancode='') and
            (c.route_code=@proutecode or @proutecode is null) and isnull(c.supply_flag,'N') ='Y' and isnull(a.suspend,'N')='N' and
			(a.ag_type=@pextra1 or @pextra1 is null or @pextra1='') and (a.ag_class=@pextra3 or @pextra3 is null or @pextra3='')
             order by route_seq,supply_seq,agency_name,edtn_name,sup_seq_no,supply_type_name
	End
End
End

/**************prachi 4992       30-sept********************/


/**************************issue no. 4761 30/sep/2011 Sushil Sir***********************************/

                                                        
                                             
ALTER PROCEDURE cir_rep_collection_cir_rep_datewise_monthwise_p
	@pcompcode			VARCHAR(40) ,
	@punitcode          VARCHAR(40) ,
	@pdoctype           VARCHAR(400) ,
	@ppaymode_reason    VARCHAR(40) ,
	@pactype            VARCHAR(40) ,
	@pagency_type       VARCHAR(40) ,
	@pfromdate          VARCHAR(40) ,
	@ptodate            VARCHAR(40) ,
	@pdateformat        VARCHAR(40) ,
	@prep               VARCHAR(40) ,--this is used for datewise(D) or monthwise(M)
	@pextra1            VARCHAR(40) ,--FOR BRANCH
	@pextra2            VARCHAR(40) --FOR DISTRICT
AS 
	DECLARE @v_frdt		DATETIME 
	DECLARE @v_todt		DATETIME 
	declare @vreason	varchar(1000)
	declare @reason		varchar(400)

	DECLARE @v_frdt11  varchar(40) 
	DECLARE @v_todt11  varchar(40) 

	SET @v_frdt  = dbo.convert_user_date('/', @pfromdate,@pdateformat)
	SET @v_todt  = dbo.convert_user_date('/', @ptodate,@pdateformat)

	set @v_frdt11 = cast (@v_frdt as varchar)
	set @v_todt11 = cast (@v_todt as varchar)

	PRINT(@v_frdt)
	PRINT(@v_todt)
	
	DECLARE cur_reason cursor LOCAL FOR 
		SELECT DISTINCT 
			--'sum( case a.reason when ' + '''' + CAST(a.reason AS VARCHAR) + '''' + ' then a.amount else 0 end ) "'+  CAST(reason AS VARCHAR) + '"' ,
			'CASE WHEN A.DOCTYPE+''#''+A.REASON='+''''+A.DOCTYPE+'#'+A.REASON+''''+' THEN ABS(SUM(A.AMOUNT)) ELSE 0 END "'+a.doctype+'#'+reason+'"' vreason,
				 a.doctype+'#'+a.reason REASON
		FROM  cir_rcphdr a,	 cir_agmast b 
		WHERE a.comp_code  = @pcompcode AND a.comp_code  = b.comp_code
		 AND a.unit_code  = b.unit AND (a.unit_code  = @punitcode OR	@punitcode  is null OR	@punitcode = '')
		 AND a.agcd  = b.agcd AND a.dpcd  = b.dpcd
		 AND (b.ag_type  = @pagency_type OR	@pagency_type  is null OR	@pagency_type = '')
		 AND (a.doctype  = @pdoctype OR	@pdoctype  is null OR	@pdoctype = '')
		 AND a.recptdt  between @v_frdt  and  @v_todt
		 AND (a.reason  = @ppaymode_reason OR @ppaymode_reason  is null OR	@ppaymode_reason = '')
		 AND (a.achd  = @pactype OR	@pactype is null OR @pactype = '')
         AND (a.branch_code=@pextra1 or @pextra1 is null or @pextra1='') and (b.dist_code=@pextra2 or @pextra2 is null or @pextra2='')
		ORDER BY reason 
		
		DECLARE @rec_reason		VARCHAR(400) 
        DECLARE @vrec_reason    VARCHAR(400)  

		DECLARE @vvar			VARCHAR(4000) 
		DECLARE @vvar_sum       VARCHAR(4000) 
		DECLARE @vquery         VARCHAR(4000) 

		OPEN cur_reason 
			fetch NEXT FROM cur_reason INTO  @vreason,@reason
			WHILE (@@FETCH_STATUS = 0) 
			BEGIN 
				IF @vvar is null BEGIN 
						SET @vvar  =@vreason
						SET @vvar_sum  = 'sum("'+@reason+'") "'+@reason+'"';
				END
				ELSE BEGIN 
					SET @vvar  = @vvar + ',' + @vreason
					SET @vvar_sum  = @vvar_sum + ',sum("'+@reason+'") "'+@reason+'"';
				END
   			fetch NEXT FROM cur_reason INTO  @vreason,@reason
			END 
		close cur_reason

		IF @vvar is not null and @prep in ( 'D' , 'M' ) BEGIN 
			IF @prep = 'D' BEGIN 
				SET @vquery  = 'select comp_code as "COMP_CODE",unit_code AS "UNIT_CODE",recptdt AS "RECPTDT",' + @vvar_sum + ' from (select a.comp_code comp_code,a.unit_code unit_code,a.recptdt recptdt,' + @vvar + ' from cir_rcphdr a,cir_agmast b where a.comp_code=b.comp_code and a.comp_code=' + '''' + @pcompcode + '''' + ' and a.unit_code=b.unit and (a.unit_code=' + '''' + @punitcode + '''' + ' or' + '''' + @punitcode + '''' + ' is null ' + ' or  ' + '''' + @punitcode + '''' + ' = '''') and a.agcd=b.agcd and a.dpcd=b.dpcd and (b.ag_type=' + '''' + @pagency_type + '''' + ' or' + '''' + @pagency_type + '''' + ' is null ' + ' or  ' + '''' + @pagency_type + '''' + ' = '''') and (a.doctype=' + '''' + @pdoctype + '''' + ' or' + '''' + @pdoctype + '''' + ' is null ' + ' or  ' + '''' + @pdoctype + '''' + ' = '''') and a.recptdt between' + '''' + @v_frdt11 + '''' + ' and' + '''' + @v_todt11 + '''' + ' and 
				(a.reason=' + '''' + @ppaymode_reason + '''' + ' or' + '''' + @ppaymode_reason + '''' + ' is null ' + ' or  ' + '''' + @ppaymode_reason + '''' + ' = '''') and (a.achd=' + '''' + @pactype + '''' + ' or' + '''' + @pactype + '''' + ' is null ' + ' or  ' + '''' + @pactype + '''' + ' = '''') and (a.branch_code=' + '''' + @pextra1 + '''' + ' or' + '''' + @pextra1 + '''' + ' is null ' + ' or  ' + '''' + @pextra1 + '''' + ' = '''')  and (b.dist_code=' + '''' + @pextra2 + '''' + ' or' + '''' + @pextra2 + '''' + ' is null ' + ' or  ' + '''' + @pextra2 + '''' + ' = '''') group by a.comp_code,a.unit_code,a.recptdt,a.reason,a.doctype) m group by m.comp_code,m.unit_code,m.recptdt  order by comp_code,unit_code,recptdt' 
                print(@vquery)
				
				EXEC (@vquery) 
				SET @vquery  = 'select comp_code as "COMP_CODE",unit_code AS "UNIT_CODE",' + @vvar_sum + ' from  (select a.comp_code comp_code,a.unit_code unit_code,a.recptdt recptdt,' + @vvar + ' from cir_rcphdr a,cir_agmast b  where a.comp_code=b.comp_code and a.comp_code=' + '''' + @pcompcode + '''' + ' and a.unit_code=b.unit and (a.unit_code=' + '''' + @punitcode + '''' + ' or' + '''' + @punitcode + '''' + ' is null ' + ' or  ' + '''' + @punitcode + '''' + ' = '''') and  a.agcd=b.agcd and a.dpcd=b.dpcd and (b.ag_type=' + '''' + @pagency_type + '''' + ' or' + '''' + @pagency_type + '''' + ' is null ' + ' or  ' + '''' + @pagency_type + '''' + ' = '''') and  (a.doctype=' + '''' + @pdoctype + '''' + ' or' + '''' + @pdoctype + '''' + ' is null ' + ' or  ' + '''' + @pdoctype + '''' + ' = '''') and a.recptdt between' + '''' + @v_frdt11 + '''' + ' and' + '''' + @v_todt11 + '''' + ' and 
				(a.reason=' + '''' + @ppaymode_reason + '''' + ' or' + '''' + @ppaymode_reason + '''' + ' is null ' + ' or  ' + '''' + @ppaymode_reason + '''' + ' = '''') and (a.achd=' + '''' + @pactype + '''' + ' or' + '''' + @pactype + '''' + ' is null' + ' or  ' + '''' + @pactype + '''' + ' = '''') and (a.branch_code=' + '''' + @pextra1 + '''' + ' or' + '''' + @pextra1 + '''' + ' is null ' + ' or  ' + '''' + @pextra1 + '''' + ' = '''')  and (b.dist_code=' + '''' + @pextra2 + '''' + ' or' + '''' + @pextra2 + '''' + ' is null ' + ' or  ' + '''' + @pextra2 + '''' + ' = '''')  group by a.comp_code,a.unit_code,a.recptdt,a.reason,a.doctype)n  group by n.comp_code,n.unit_code order by comp_code,unit_code' 
				EXEC (@vquery) 
			END
			ELSE BEGIN 
				SET @vquery  = 'select comp_code as "COMP_CODE",unit_code AS "UNIT_CODE", CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(recptdt)-1),recptdt),101) as "DT", (DATENAME(MM, recptdt) '+ ' + '+ '''' +'-' +''''+ ' + ' + 'CAST(YEAR(recptdt) AS VARCHAR(4))) AS "RECPTDT" ,' + @vvar_sum + ' from  (select a.comp_code comp_code,a.unit_code unit_code,a.recptdt recptdt,' + @vvar + ' from cir_rcphdr a,cir_agmast b  where a.comp_code=b.comp_code and a.comp_code=' + '''' + @pcompcode + '''' + ' and a.unit_code=b.unit and (a.unit_code=' + '''' + @punitcode + '''' + ' or' + '''' + @punitcode + '''' + ' is null' + ' or  ' + '''' + @punitcode + '''' + ' = '''') and  a.agcd=b.agcd and a.dpcd=b.dpcd and (b.ag_type=' + '''' + @pagency_type + '''' + ' or' + '''' + @pagency_type + '''' + ' is null ' + ' or  ' + '''' + @pagency_type + '''' + ' = '''') and  (a.doctype=' + '''' + @pdoctype + '''' + ' or' + '''' + @pdoctype + '''' + ' is null ' + ' or  ' + '''' + @pdoctype + '''' + ' = '''') and a.recptdt between' + '''' + @v_frdt11 + '''' + ' and' + '''' + @v_todt11 + '''' + ' and  
				(a.reason=' + '''' + @ppaymode_reason + '''' + ' or' + '''' + @ppaymode_reason + '''' + ' is null ' + ' or  ' + '''' + @ppaymode_reason + '''' + ' = '''') and (a.achd=' + '''' + @pactype + '''' + ' or' + '''' + @pactype + '''' + ' is null' + ' or  ' + '''' + @pactype + '''' + ' = '''') and (a.branch_code=' + '''' + @pextra1 + '''' + ' or' + '''' + @pextra1 + '''' + ' is null ' + ' or  ' + '''' + @pextra1 + '''' + ' = '''')  and (b.dist_code=' + '''' + @pextra2 + '''' + ' or' + '''' + @pextra2 + '''' + ' is null ' + ' or  ' + '''' + @pextra2 + '''' + ' = '''') group by a.comp_code,a.unit_code,a.recptdt,a.reason,a.doctype) v  group by v.comp_code,v.unit_code,CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(v.recptdt)-1),v.recptdt),101) , (DATENAME(MM, v.recptdt)' + '+ ' +'''' +'-' +''''+ '+' + 'CAST(YEAR(v.recptdt) AS VARCHAR(4)))   order by comp_code,unit_code' 
		    	EXEC (@vquery) 
				SET @vquery  = 'select comp_code as "COMP_CODE",unit_code AS "UNIT_CODE",' + @vvar_sum + ' from  (select a.comp_code comp_code,a.unit_code unit_code,a.recptdt recptdt,' + @vvar + ' from cir_rcphdr a,cir_agmast b  where a.comp_code=b.comp_code and a.comp_code=' + '''' + @pcompcode + '''' + ' and a.unit_code=b.unit and (a.unit_code=' + '''' + @punitcode + '''' + ' or' + '''' + @punitcode + '''' + ' is null' + ' or  ' + '''' + @punitcode + '''' + ' = '''') and   a.agcd=b.agcd and a.dpcd=b.dpcd and (b.ag_type=' + '''' + @pagency_type + '''' + ' or' + '''' + @pagency_type + '''' + ' is null ' + ' or  ' + '''' + @pagency_type + '''' + ' = '''') and  (a.doctype=' + '''' + @pdoctype + '''' + ' or' + '''' + @pdoctype + '''' + ' is null ' + ' or  ' + '''' + @pdoctype + '''' + ' = '''') and a.recptdt between' + '''' + @v_frdt11 + '''' + ' and' + '''' + @v_todt11 + '''' + ' and 
				(a.reason=' + '''' + @ppaymode_reason + '''' + ' or' + '''' + @ppaymode_reason + '''' + ' is null ' + ' or  ' + '''' + @ppaymode_reason + '''' + ' = '''') and (a.achd=' + '''' + @pactype + '''' + ' or' + '''' + @pactype + '''' + ' is null ' + ' or  ' + '''' + @pactype + '''' + ' = '''') and (a.branch_code=' + '''' + @pextra1 + '''' + ' or' + '''' + @pextra1 + '''' + ' is null ' + ' or  ' + '''' + @pextra1 + '''' + ' = '''')  and (b.dist_code=' + '''' + @pextra2 + '''' + ' or' + '''' + @pextra2 + '''' + ' is null ' + ' or  ' + '''' + @pextra2 + '''' + ' = '''') group by a.comp_code,a.unit_code,a.recptdt,a.reason,a.doctype) w  group by w.comp_code,w.unit_code  order by comp_code,unit_code' 
				EXEC (@vquery) 
			END
		END
		ELSE BEGIN 
			SET @vquery  = 'select' + '''' + @pcompcode + '''' + ' "COMP_CODE",' + '''' + @punitcode + '''' + ' "unit_code",' + '''' + convert(varchar(10),getdate(),101)+ '''' + ' "recptdt"  where 1=2' 
print(@vquery)
			EXEC (@vquery) 
			SET @vquery  = 'select' + '''' + @pcompcode + '''' + ' "COMP_CODE",' + '''' + @punitcode + '''' + ' "unit_code"  where 1=2' 
print(@vquery)
			EXEC (@vquery)
		END

print(@vquery)
		DEALLOCATE cur_reason



/**************************end of issue no. 4761 30/sep/2011 Sushil Sir***********************************/

/**********************************************START OF ISSUE NO.0004828 ......07/10/2011....************************************/


USE [abhi]
GO
/****** Object:  StoredProcedure [dbo].[Cir_SubSubRoute_Bind1]    Script Date: 10/07/2011 17:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE  [dbo].[Cir_SubSubRoute_Bind1]
  	@pcompcode as varchar(200),
    @punitcode as varchar(200),
    @proutecode as varchar(200),
    @psubrtcode as varchar(200),
    @psubsubrtcode as varchar(200),
    @pdateformat as	varchar(200),
    @pextra1 as	varchar(200),
    @pextra2 as varchar(200)

 AS

 select cir_sub_subroute_mast.*,dbo.cir_get_route_name(cir_sub_subroute_mast.comp_code,cir_sub_subroute_mast.unit,cir_sub_subroute_mast.route_code) "ROUTE NAME",
  	    dbo.cir_get_subroute_name(cir_sub_subroute_mast.comp_code,cir_sub_subroute_mast.unit,cir_sub_subroute_mast.route_code,cir_sub_subroute_mast.subrt_code) "SUBROUTE NAME",
  	    dbo.cir_get_drop_point_name(cir_sub_subroute_mast.comp_code,cir_sub_subroute_mast.unit,cir_sub_subroute_mast.start_point,1) START_DROP_POINT_NAME,
   	    dbo.cir_get_drop_point_name(cir_sub_subroute_mast.comp_code,cir_sub_subroute_mast.unit,cir_sub_subroute_mast.end_point,1) END_DROP_POINT_NAME,
   	    sub_subrt_mode SUB_SUBRT_MODE, (select b.mode_desc from cir_route_mode_mast b where b.comp_code=cir_sub_subroute_mast.comp_code and b.mode_code=cir_sub_subroute_mast.sub_subrt_mode) as MODE_NAME
  	    from cir_sub_subroute_mast
              where comp_code=@pcompcode and
                    unit=@punitcode and
  	                (route_code=@proutecode OR @proutecode is null or @proutecode='') and
                    (subrt_code=@psubrtcode or @psubrtcode is null or @psubrtcode='') and
                    (sub_subrt_code=@psubsubrtcode or isnull(@psubsubrtcode,'0')='0' or @psubsubrtcode='') 
                    and (sub_subrt_mode=@pextra2 or @pextra2 is null or @pextra2='')
                    /*and
                    nvl(freeze_flag,'N')='N'*/
  	          order by route_code,subrt_code,sub_subrt_code;



/**********************************************END OF ISSUE NO.0004828 ......07/10/2011....************************************/

/***********sub route for issue 4827******************/

ALTER PROCEDURE  [dbo].[Cir_SubRoute_Bind1]
  	@pcompcode		as	varchar(200),
    @punitcode		as	varchar(200),
    @proutecode		as	varchar(200),
    @psubrtcode		as	varchar(200),
    @pdateformat	as	varchar(200),
    @pextra1		as	varchar(200),
    @pextra2		as	varchar(200)
 AS
   select a.comp_code COMP_CODE,a.unit UNIT,a.route_code ROUTE_CODE,dbo.cir_get_route_name(a.comp_code,a.unit,a.route_code) ROUTE_NAME,a.subrt_code SUBRT_CODE,
           a.subrt_name SUBRT_NAME,a.subrt_name_oth_lang SUBRT_NAME_OTH_LANG,a.subrt_mode SUBRT_MODE,
           (select b.mode_desc from cir_route_mode_mast b where b.comp_code=a.comp_code and b.mode_code=a.subrt_mode) as MODE_NAME,
           a.start_point START_POINT,a.end_point END_POINT,a.subrt_dist SUBRT_DIST,a.subrt_seq SUBRT_SEQ,
           (select c.drop_point_name from cir_drop_point_mast c	where a.comp_code=c.comp_code and a.unit=c.unit_code and a.start_point=c.drop_point) START_DROP_POINT_NAME,
           (select d.drop_point_name from cir_drop_point_mast d	where a.comp_code=d.comp_code and a.unit=d.unit_code and a.end_point=d.drop_point) END_DROP_POINT_NAME
       from cir_sub_route_mast a
       where a.comp_code=@pcompcode and
             a.unit=@punitcode and
             (a.route_code=@proutecode or isnull(@proutecode,'0')='0' or @proutecode='') and
             (a.subrt_code=@psubrtcode or isnull(@psubrtcode,'0')='0' or @psubrtcode='')
              and ((upper(subrt_name) like upper(@pextra1)+'%') or (@pextra1 is null) or (@pextra1=''))
              and (a.subrt_mode=@pextra2 or @pextra2 is null or @pextra2='')
             --and nvl(a.freeze_flag,'N')='N'
       order by route_name,subrt_name;

/***********sub route for issue 4827******************/

/*******************for issue 5118**********************/
ALTER PROCEDURE [dbo].[cir_rep_supply_cir_rep_supply_po]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@ppubl                                    VARCHAR(20) ,
	@pedtn                                    VARCHAR(20) ,
	@psupdate                                 VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000),--it is use for finalised or unfinalised
	@pextra2                                  VARCHAR(4000) 
AS
	DECLARE @vvty11				VARCHAR(2000)  
	DECLARE @vvty_sum11         VARCHAR(2000)  
	DECLARE @vvar               VARCHAR(4000) 
	DECLARE @vvar_sum           VARCHAR(4000) 
	DECLARE @vquery             VARCHAR(4000) 
	DECLARE @vquery1            VARCHAR(4000) 	
	DECLARE @vquery2            VARCHAR(4000) 
	DECLARE @vquery3            VARCHAR(4000) 	
    DECLARE @user_pfrom			VARCHAR(100)
	DECLARE @vsup_seq_no			INT
	DECLARE cur_sup_type cursor LOCAL FOR 
		select z.vty vty,z.vty_sum vty_sum,z.sup_seq_no sup_seq_no from 
		(SELECT 'SUM(CASE SUP_TYPE_CODE WHEN  '+''''+sup_ty_code+''''+' then sup_copy else 0 end) "'+sup_ty_name+'",' vty,
				'sum(case sup_type_code	when '+''''+sup_ty_code+''''+' then '+' sup_copy '+' else 0 end) +' vty_sum,sup_seq_no from cir_supply_type_mast 
		WHERE comp_code  = @pcomp_code /*and (upper(@pextra1)!='U' or @pextra1 is null)
		union
		SELECT 'SUM(CASE SUPPLY_TYPE_CODE WHEN  '+''''+sup_ty_code+''''+' then isnull(d.base_supply,0) else 0 end) "'+sup_ty_name+'",' vty,
				'sum(case supply_type_code	when '+''''+sup_ty_code+''''+' then '+' isnull(d.base_supply,0) '+' else 0 end) +' vty_sum,sup_seq_no from cir_supply_type_mast 
		WHERE comp_code  = @pcomp_code and upper(@pextra1)='U'*/)z
		order by sup_seq_no
		
		OPEN cur_sup_type 
			fetch NEXT FROM cur_sup_type INTO @vvty11 , @vvty_sum11,@vsup_seq_no
				WHILE (@@FETCH_STATUS = 0) 
				  BEGIN 
				   set @vvar =COALESCE(@vvar+'', SPACE(0)) + '' + COALESCE(@vvty11 + '', SPACE(0))
				   set @vvar_sum=COALESCE(@vvar_sum+'', SPACE(0)) + '' + COALESCE(@vvty_sum11 + '', SPACE(0))					
			fetch NEXT FROM cur_sup_type INTO @vvty11 , @vvty_sum11,@vsup_seq_no
		 END 
		close cur_sup_type

		SET @vvar  = SUBSTRING(@vvar, 1, LEN(@vvar) - 1)
		SET @vvar_sum  = SUBSTRING(@vvar_sum, 1, LEN(@vvar_sum) - 1)

        set @user_pfrom=(select dbo.convert_user_date('/',@psupdate,@pdateformat))

print(@psupdate)
print(@user_pfrom)
print(@pdateformat)
		
--SET @vquery='select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,
--         dbo.cir_get_publ_name(d.comp_code,d.publ) publ_name,d.edtn EDTN,
--         dbo.cir_get_edtn_name(d.comp_code,d.edtn) "EDITION NAME", 
--         DBO.CONVERT_USER_DATE(''/'',d.supdate,'''+@pdateformat+''') SUPDATE,' + @vvar + ',' + @vvar_sum +' TOTAL,
--         dbo.cir_get_edtn_name(d.comp_code,e.main_edtn) MAINEDTN_NAME,
--         dbo.cir_get_edtn_seqno(d.comp_code,d.edtn) EDTN_SEQNO,
--         dbo.cir_get_edtn_seqno(d.comp_code,e.main_edtn) MAIN_EDTN_SEQNO from cir_dbksup d,cir_edtn_mast e
--         where d.comp_code=' + '''' + @pcomp_code + '''' + ' and d.comp_code=e.comp_code 
--         and d.unit_code=' + '''' + @punit_code + '''' + ' and d.unit_code=e.unit_code AND 
--         (d.publ='+''''+@ppubl+''''+' OR '+''''+@ppubl+''''+' IS NULL OR '+''''+@ppubl+''''+' ='''')  and d.publ=e.publ 
--         and d.supdate='+''''+@user_pfrom+''''+' and 
--         d.edtn=e.edtn 
--         group by d.comp_code,d.unit_code,d.publ,e.main_edtn,d.edtn,d.supdate 
--         order by d.comp_code,d.unit_code,d.publ,main_edtn_seqno,mainedtn_name,edtn_seqno,d.edtn,d.supdate' 

	SET @vquery='select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,
         dbo.cir_get_publ_name(d.comp_code,d.publ) publ_name,d.edtn EDTN,
         dbo.cir_get_edtn_name(d.comp_code,d.edtn) "EDITION NAME", 
         DBO.CONVERT_USER_DATE(''/'',d.supdate,'''+@pdateformat+''') SUPDATE,' + @vvar + ',' 
         
	SET @vquery2=  @vvar_sum +' TOTAL,
         dbo.cir_get_edtn_name(d.comp_code,e.main_edtn) MAINEDTN_NAME,
         dbo.cir_get_edtn_seqno(d.comp_code,d.edtn) EDTN_SEQNO,
         dbo.cir_get_edtn_seqno(d.comp_code,e.main_edtn) MAIN_EDTN_SEQNO,'''' SUPL_NAME from cir_dbksup d,cir_edtn_mast e
         where d.comp_code=' + '''' + @pcomp_code + '''' + ' and d.comp_code=e.comp_code 
         and d.unit_code=' + '''' + @punit_code + '''' + ' and d.unit_code=e.unit_code AND 
         (d.publ='+''''+@ppubl+''''+' OR '+''''+@ppubl+''''+' IS NULL OR '+''''+@ppubl+''''+' ='''')  and d.publ=e.publ 
         and d.supdate='+''''+@user_pfrom+''''+' and 
         d.edtn=e.edtn 
         group by d.comp_code,d.unit_code,d.publ,e.main_edtn,d.edtn,d.supdate 
         order by d.comp_code,d.unit_code,d.publ,main_edtn_seqno,mainedtn_name,edtn_seqno,d.edtn,d.supdate' 

        --SET @vquery1  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,
        -- dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,' + @vvar + ',' + @vvar_sum + 'TOTAL from cir_dbksup d where 
        -- d.comp_code=' + '''' + @pcomp_code + '''' + ' and d.unit_code=' + '''' + @punit_code + '''' + ' 
        -- and (d.publ='+''''+@ppubl+''''+' OR '+''''+@ppubl+''''+' IS NULL OR '+''''+@ppubl+''''+' ='''')
        --and d.supdate='+''''+@user_pfrom+''''+'         
        -- group by d.comp_code,d.unit_code,d.publ order by d.comp_code,d.unit_code,d.publ' 
        
	SET @vquery1  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,
         dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,' + @vvar + ',' 
          SET @vquery3  = @vvar_sum + 'TOTAL from cir_dbksup d where 
         d.comp_code=' + '''' + @pcomp_code + '''' + ' and d.unit_code=' + '''' + @punit_code + '''' + ' 
         and (d.publ='+''''+@ppubl+''''+' OR '+''''+@ppubl+''''+' IS NULL OR '+''''+@ppubl+''''+' ='''')
        and d.supdate='+''''+@user_pfrom+''''+'         
         group by d.comp_code,d.unit_code,d.publ order by d.comp_code,d.unit_code,d.publ' 
 
		print (@vquery + @vquery2)
		print (@vquery1 + @vquery3) 
		EXEC (@vquery + @vquery2)
		EXEC (@vquery1 + @vquery3) 

DEALLOCATE cur_sup_type
 





ALTER PROCEDURE [dbo].[CIR_REP_SUPPLY_cir_rep_daybook]
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
	@pextra2         varchar(200),
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
		

	set @pquery='SELECT COMP_CODE,UNIT_CODE,AGCD "AGENCY CODE",DPCD "AGENCY SUBCODE",substrING(dbo.cir_get_name_cir_agname(comp_code,unit_code,agcd,dpcd,1,'''','''',''''),1,50) "AGENCY NAME",
       substring(dbo.cir_get_name_cir_agname(comp_code,unit_code,agcd,dpcd,2,'''','''',''''),1,50) "AGENCY ONAME",
       d.EDTN,dbo.cir_get_edtn_name(COMP_CODE,d.EDTN) "EDITION NAME",dbo.cir_get_edtn_name(COMP_CODE,d.EDTN) "EDITION ONAME",
       CITY_CODE "CITY CODE",dbo.cir_get_city(COMP_CODE,CITY_CODE) "CITY NAME",
       dbo.cir_get_name_cir_city(COMP_CODE,CITY_CODE,2,'''','''','''') "CITY ONAME",
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
        WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE='''+@PCOMP_CODE+''' AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE='''+@PUNIT_CODE+''' AND
        A.AGCD=B.AGCD AND A.DPCD=B.DPCD AND A.PUBL='''+@PPUBL+''' AND (A.EDTN='''+@PEDTN+''' or '''+@PEDTN+''' IS NULL OR '''+@PEDTN+''' ='''') AND (B.CITY_CODE='''+@PCITYCD+''' OR '''+@PCITYCD+''' IS NULL or '''+@PCITYCD+''' ='''') AND
        (B.STATE_CODE='''+@PSTATECD+''' OR '''+@PSTATECD+''' IS NULL or '''+@PSTATECD+''' ='''') AND A.SUP_TYPE_CODE=C.SUP_TY_CODE AND
        A.SUPDATE BETWEEN '''+@VFRDT+''' AND '''+@VTODT+'''    AND A.SUP_COPY>0
        GROUP BY A.COMP_CODE,A.UNIT_CODE,A.AGCD,A.DPCD,A.SUPDATE,B.CITY_CODE,B.STATE_CODE,B.COUNTRY_CODE) d
        GROUP BY d.COMP_CODE,d.UNIT_CODE,d.AGCD,d.DPCD,d.EDTN,d.CITY_CODE,d.STATE_CODE,d.COUNTRY_CODE
        ORDER BY d.COMP_CODE,d.UNIT_CODE,d.STATE_CODE,d.CITY_CODE,d.EDTN,d.AGCD,d.DPCD;'
--print @pquery	


	set @pquery1='SELECT COMP_CODE,UNIT_CODE,isnull(STATE_CODE,''NA'') "STATE CODE",isnull(dbo.CIR_GET_STATE(COMP_CODE,COUNTRY_CODE,STATE_CODE),''NA'') "STATE NAME",COUNTRY_CODE,
        SUM(p01) AS "01",SUM(p02) AS "02",SUM(p03) AS "03",SUM(p04) AS "04",SUM(p05) AS "05",
        SUM(p06) AS "06",SUM(p07) AS "07",SUM(p08) AS "08",SUM(p09) AS "09",SUM(p10) AS "10",
        SUM(p11) AS "11",SUM(p12) AS "12",SUM(p13) AS "13",SUM(p14) AS "14",SUM(p15) AS "15",
        SUM(p16) AS "16",SUM(p17) AS "17",SUM(p18) AS "18",SUM(p19) AS "19",SUM(p20) AS "20",
        SUM(p21) AS "21",SUM(p22) AS "22",SUM(p23) AS "23",SUM(p24) AS "24",SUM(p25) AS "25",
        SUM(p26) AS "26",SUM(p27) AS "27",SUM(p28) AS "28",SUM(p29) AS "29",SUM(p30) AS "30",SUM(p31) AS "31",
        SUM(isnull(p01,0)+isnull(p02,0)+isnull(p03,0)+isnull(p04,0)+isnull(p05,0)+isnull(p06,0)+isnull(p07,0)+isnull(p08,0)+isnull(p09,0)+isnull(p10,0)+
        isnull(p11,0)+isnull(p12,0)+isnull(p13,0)+isnull(p14,0)+isnull(p15,0)+isnull(p16,0)+isnull(p17,0)+isnull(p18,0)+isnull(p19,0)+isnull(p20,0)+
        isnull(p21,0)+isnull(p22,0)+isnull(p23,0)+isnull(p24,0)+isnull(p25,0)+isnull(p26,0)+isnull(p27,0)+isnull(p28,0)+isnull(p29,0)+isnull(p30,0)+isnull(p31,0)) AS "TOTAL"
        FROM (SELECT     A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,B.STATE_CODE STATE_CODE,B.COUNTRY_CODE COUNTRY_CODE,
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
        WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE='''+@PCOMP_CODE+''' AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE='''+@PUNIT_CODE+''' AND
        A.AGCD=B.AGCD AND A.DPCD=B.DPCD AND A.PUBL='''+@PPUBL+''' AND (A.EDTN='''+@PEDTN+''' OR '''+@PEDTN+''' IS NULL or '''+@PEDTN+'''='''') AND (B.CITY_CODE='''+@PCITYCD+''' OR '''+@PCITYCD+''' IS NULL or '''+@PCITYCD+'''='''') AND
        (B.STATE_CODE='''+@PSTATECD+''' OR '''+@PSTATECD+''' IS NULL or '''+@PSTATECD+'''='''') AND A.SUP_TYPE_CODE=C.SUP_TY_CODE AND
        A.SUPDATE BETWEEN '''+@VFRDT+''' AND '''+@VTODT+'''    AND isnull(A.SUP_COPY,0)>0
        GROUP BY A.COMP_CODE,A.UNIT_CODE,A.SUPDATE,B.STATE_CODE,B.COUNTRY_CODE) d
        GROUP BY d.COMP_CODE,d.UNIT_CODE,d.STATE_CODE,d.COUNTRY_CODE
        ORDER BY d.COMP_CODE,d.UNIT_CODE,d.STATE_CODE;'

set @pquery2='SELECT COMP_CODE,UNIT_CODE,SUM(p01) AS "01",SUM(p02) AS "02",SUM(p03) AS "03",SUM(p04) AS "04",SUM(p05) AS "05",
        SUM(p06) AS "06",SUM(p07) AS "07",SUM(p08) AS "08",SUM(p09) AS "09",SUM(p10) AS "10",
        SUM(p11) AS "11",SUM(p12) AS "12",SUM(p13) AS "13",SUM(p14) AS "14",SUM(p15) AS "15",
        SUM(p16) AS "16",SUM(p17) AS "17",SUM(p18) AS "18",SUM(p19) AS "19",SUM(p20) AS "20",
        SUM(p21) AS "21",SUM(p22) AS "22",SUM(p23) AS "23",SUM(p24) AS "24",SUM(p25) AS "25",
        SUM(p26) AS "26",SUM(p27) AS "27",SUM(p28) AS "28",SUM(p29) AS "29",SUM(p30) AS "30",SUM(p31) AS "31",
        SUM(isnull(p01,0)+isnull(p02,0)+isnull(p03,0)+isnull(p04,0)+isnull(p05,0)+isnull(p06,0)+isnull(p07,0)+isnull(p08,0)+isnull(p09,0)+isnull(p10,0)+
        isnull(p11,0)+isnull(p12,0)+isnull(p13,0)+isnull(p14,0)+isnull(p15,0)+isnull(p16,0)+isnull(p17,0)+isnull(p18,0)+isnull(p19,0)+isnull(p20,0)+
        isnull(p21,0)+isnull(p22,0)+isnull(p23,0)+isnull(p24,0)+isnull(p25,0)+isnull(p26,0)+isnull(p27,0)+isnull(p28,0)+isnull(p29,0)+isnull(p30,0)+isnull(p31,0)) AS "TOTAL"
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
        WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE='''+@PCOMP_CODE+''' AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE='''+@PUNIT_CODE+''' AND
        A.AGCD=B.AGCD AND A.DPCD=B.DPCD AND A.PUBL='''+@PPUBL+''' AND (A.EDTN='''+@PEDTN+''' OR '''+@PEDTN+''' IS NULL or '''+@PEDTN+'''='''') AND (B.CITY_CODE='''+@PCITYCD+''' OR '''+@PCITYCD+''' IS NULL or '''+@PCITYCD+'''='''') AND
        (B.STATE_CODE='''+@PSTATECD+''' OR '''+@PSTATECD+''' IS NULL OR '''+@PSTATECD+'''='''') AND A.SUP_TYPE_CODE=C.SUP_TY_CODE AND
        A.SUPDATE BETWEEN '''+@VFRDT+''' AND '''+@VTODT+'''    AND isnull(A.SUP_COPY,0)>0
        GROUP BY A.COMP_CODE,A.UNIT_CODE,A.SUPDATE) d
        GROUP BY d.COMP_CODE,d.UNIT_CODE
        ORDER BY d.COMP_CODE,d.UNIT_CODE;'

	PRINT @pquery
	PRINT @pquery1
	PRINT @pquery2

	exec(@pquery)
	exec(@pquery1)
	exec(@pquery2)
	
END


                                                                   
                                             
ALTER PROCEDURE [dbo].[cir_rep_supply_cir_route_supply_variance_p]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@ppublication                             VARCHAR(20) ,
	@pmainedtn                                VARCHAR(20) ,
	@pedtn                                    VARCHAR(20) ,
	@proute                                   VARCHAR(20) ,
	@pfirstdate                               VARCHAR(20) ,
	@pseconddate                              VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(200),--it is use for finalised or unfinalised
	@pextra2                                  VARCHAR(200)--it is used for supply type 
AS 

	DECLARE @vfirstdate                               DATETIME 
	DECLARE @vseconddate                              DATETIME 
Begin		
	SET @vfirstdate  =  dbo.convert_user_date('/',@pfirstdate,@pdateformat)
	SET @vseconddate  = dbo.convert_user_date('/',@pseconddate,@pdateformat)
	print(@vfirstdate)
	print(@vseconddate)

	If upper(@pextra1)='U' Begin
         select x.comp_code "COMP CODE",x.agcd "AGENCY CODE",x.dpcd "AGENCY SUB CODE",x.ag_name "AGENCY NAME",x.ag_name_oth_lang "AGENCY OTHER LANG",
         dbo.cir_get_city(x.comp_code,x.city_code) "CITY NAME",
         x.route_code "ROUTE CODE",x.route_name "ROUTE NAME",x.route_name_oth_lang "ROUTE NAME OTHER LANG",sum(x.first_sup) "FIRST SUPPLY",sum(x.second_sup) "SECOND SUPPLY",
		CASE sign(ISNULL(SUM(x.second_sup), 0) - ISNULL(SUM(x.first_sup), 0)) WHEN - 1 THEN 0 
		ELSE (ISNULL(SUM(x.second_sup), 0) - ISNULL(SUM(x.first_sup), 0)) 
		END "INCREASE SUPPLY",

		CASE sign(ISNULL(SUM(x.second_sup), 0) - ISNULL(SUM(x.first_sup), 0)) WHEN 1 THEN 0 
		ELSE (ISNULL(SUM(x.second_sup), 0) - ISNULL(SUM(x.first_sup), 0)) 
		END "DECREASE SUPPLY",

		CASE SUM(x.first_sup) WHEN 0 THEN 100 
		ELSE ROUND(((ISNULL(SUM(x.second_sup), 0) - ISNULL(SUM(x.first_sup), 0)) * 100) / CASE sign(SUM(x.second_sup) - SUM(x.first_sup)) WHEN - 1 THEN SUM(x.first_sup)ELSE SUM(x.second_sup)END, 2) 
		END "PERCENT_VARIANCE",
         dbo.cir_get_drop_point_name(x.comp_code,x.unit_code,x.station_code,1) "DROP POINT NAME",
         dbo.cir_get_drop_point_name(x.comp_code,x.unit_code,x.station_code,2) "DROP POINT NAME OTHER LANG",x.branch_code "BRANCH NAME" from
                        (select distinct a.comp_code comp_code,a.unit_code unit_code,a.agcd,a.dpcd,a.publ,a.edtn,c.ag_name,c.ag_name_oth_lang,c.city_code,a.route_code,b.route_name,b.route_name_oth_lang,c.station_code station_code,c.branch_code branch_code,
                (select isnull(sum(base_supply),0) from cir_supply
                           where cir_supply.comp_code     =   @pcomp_code and unit =   @punit_code and
                                 cir_supply.publ          =   @ppublication and (edtn   =   @pedtn or @pedtn is null or @pedtn='') and
                                 isnull(cir_supply.supply_flag,'N') =   'Y' and cir_supply.comp_code = b.comp_code and
                                 cir_supply.unit          =   b.unit and cir_supply.agcd          = a.agcd and
                                 cir_supply.dpcd          =   a.dpcd and cir_supply.route_code    = b.route_code and
                                 cir_supply.publ          =   a.publ and cir_supply.edtn          = a.edtn and
                                 (cir_supply.route_code   =   @proute or @proute is null or @proute='') and
                                 cir_supply.edtn in(select distinct edtn from cir_edtn_mast where comp_code=@pcomp_code and
                                 (edtn = @pedtn or @pedtn is null or @pedtn='') and (main_edtn=@pmainedtn or @pmainedtn is null or @pmainedtn='')) and
                                 (cir_supply.supply_type_code = @pextra2 or @pextra2 is null or @pextra2='')) first_sup,
                      (select isnull(sum(sup_copy),0) from cir_dbksup
                           where comp_code    =    @pcomp_code and unit_code =    @punit_code and
                                 publ         =    @ppublication and (edtn   =    @pedtn or @pedtn is null or @pedtn='') and
                                 supdate         = @vseconddate and cir_dbksup.agcd =    a.agcd and
                                 cir_dbksup.dpcd = a.dpcd and cir_dbksup.route_code =  a.route_code and
                                 cir_dbksup.publ = a.publ and cir_dbksup.edtn =  a.edtn and
                                 (cir_dbksup.route_code= @proute or @proute is null or @proute='') and
                                 cir_dbksup.edtn in(select distinct edtn from cir_edtn_mast where comp_code=@pcomp_code and (edtn = @pedtn or @pedtn is null or @pedtn='') and (main_edtn=@pmainedtn or @pmainedtn is null or @pmainedtn='')) and
                                 (cir_dbksup.sup_type_code = @pextra2 or @pextra2 is null or @pextra2='')) second_sup
                     from cir_dbksup a,cir_route_mast b,cir_agmast c
                     where a.comp_code=@pcomp_code and a.comp_code=b.comp_code and a.comp_code=c.comp_code and
                           a.unit_code=@punit_code and a.unit_code=b.unit and a.unit_code=c.unit and
                           (a.supdate = @vfirstdate or a.supdate = @vseconddate) and
                           a.agcd=c.agcd and a.dpcd=c.dpcd and
                           (a.route_code=@proute or @proute is null or @proute='') and a.route_code=b.route_code ) x
                     where isnull(x.second_sup,0)-isnull(x.first_sup,0)<>0
                           group by x.comp_code,x.unit_code,x.agcd,x.dpcd,x.ag_name,x.ag_name_oth_lang,x.city_code,x.route_code,x.route_name,x.route_name_oth_lang,x.station_code,x.branch_code
                           order by comp_code,route_code,ag_name
		End
        else	Begin
				select x.comp_code "COMP CODE",x.agcd "AGENCY CODE",x.dpcd "AGENCY SUB CODE",x.ag_name "AGENCY NAME",x.ag_name_oth_lang "AGENCY OTHER LANG",
				x.route_code "ROUTE CODE",x.route_name "ROUTE NAME",x.route_name_oth_lang "ROUTE NAME OTHER LANG",sum(x.first_sup) "FIRST SUPPLY",sum(x.second_sup) "SECOND SUPPLY",
				CASE sign(ISNULL(SUM(x.second_sup), 0) - ISNULL(SUM(x.first_sup), 0)) WHEN - 1 THEN 0 
				ELSE (ISNULL(SUM(x.second_sup), 0) - ISNULL(SUM(x.first_sup), 0)) 
				END "INCREASE SUPPLY",

				CASE sign(ISNULL(SUM(x.second_sup), 0) - ISNULL(SUM(x.first_sup), 0)) WHEN 1 THEN 0 
				ELSE (ISNULL(SUM(x.second_sup), 0) - ISNULL(SUM(x.first_sup), 0)) 
				END "DECREASE SUPPLY",

				CASE SUM(x.first_sup) WHEN 0 THEN 100 
				ELSE ROUND(((ISNULL(SUM(x.second_sup), 0) - ISNULL(SUM(x.first_sup), 0)) * 100) / CASE sign(SUM(x.second_sup) - SUM(x.first_sup)) WHEN - 1 THEN SUM(x.first_sup)ELSE SUM(x.second_sup)END, 2) 
				END "PERCENT_VARIANCE",
                 dbo.cir_get_drop_point_name(x.comp_code,x.unit_code,x.station_code,1) "DROP POINT NAME",
                 dbo.cir_get_drop_point_name(x.comp_code,x.unit_code,x.station_code,2) "DROP POINT NAME OTHER LANG",x.branch_code "BRANCH NAME" from
                                (select distinct a.comp_code comp_code,a.unit_code unit_code,a.agcd,a.dpcd,a.publ,a.edtn,c.ag_name,c.ag_name_oth_lang,c.city_code,a.route_code,b.route_name,b.route_name_oth_lang,c.station_code station_code,c.branch_code branch_code,
                        (select isnull(sum(sup_copy),0) from cir_dbksup
                                   where comp_code                =   @pcomp_code and unit_code =   @punit_code and
                                         publ                     =   @ppublication and (edtn   =   @pedtn or @pedtn is null or @pedtn='') and
                                         supdate                  =   @vfirstdate and cir_dbksup.comp_code =     b.comp_code and
                                         cir_dbksup.unit_code     =   b.unit and cir_dbksup.agcd      =   a.agcd and
                                         cir_dbksup.dpcd          =   a.dpcd and cir_dbksup.route_code=   b.route_code and
                                         cir_dbksup.publ          =   a.publ and cir_dbksup.edtn      =   a.edtn and
                                         (cir_dbksup.route_code   =   @proute or @proute is null or @proute='') and
                                         cir_dbksup.edtn in(select distinct edtn from cir_edtn_mast where comp_code=@pcomp_code and
                                         (edtn = @pedtn or @pedtn is null or @pedtn='') and (main_edtn=@pmainedtn or @pmainedtn is null or @pmainedtn='')) and 
                                         (cir_dbksup.sup_type_code = @pextra2 or @pextra2 is null or @pextra2='')) first_sup,
                              (select isnull(sum(sup_copy),0) from cir_dbksup
                                   where comp_code    =    @pcomp_code and unit_code =    @punit_code and
                                         publ         =    @ppublication and (edtn   =    @pedtn or @pedtn is null or @pedtn='') and
                                         supdate         = @vseconddate and cir_dbksup.agcd =    a.agcd and
                                         cir_dbksup.dpcd = a.dpcd and cir_dbksup.route_code =  a.route_code and
                                         cir_dbksup.publ = a.publ and cir_dbksup.edtn =  a.edtn and
                                         (cir_dbksup.route_code= @proute or @proute is null or @proute='') and
                                         cir_dbksup.edtn in(select distinct edtn from cir_edtn_mast where comp_code=@pcomp_code and (edtn = @pedtn or @pedtn is null or @pedtn='') and (main_edtn=@pmainedtn or @pmainedtn is null or @pmainedtn='')) and
                                         (cir_dbksup.sup_type_code = @pextra2 or @pextra2 is null or @pextra2='')) second_sup
                             from cir_dbksup a,cir_route_mast b,cir_agmast c
                             where a.comp_code=@pcomp_code and a.comp_code=b.comp_code and a.comp_code=c.comp_code and
                                   a.unit_code=@punit_code and a.unit_code=b.unit and a.unit_code=c.unit and
                                   (a.supdate = @vfirstdate or a.supdate = @vseconddate) and
                                   a.agcd=c.agcd and a.dpcd=c.dpcd and
                                   (a.route_code=@proute or @proute is null or @proute='') and a.route_code=b.route_code )x
                             where isnull(x.second_sup,0)-isnull(x.first_sup,0)<>0
                                   group by x.comp_code,x.unit_code,x.agcd,x.dpcd,x.ag_name,x.ag_name_oth_lang,x.city_code,x.route_code,
									x.route_name,x.route_name_oth_lang,x.station_code,x.branch_code
                                   order by comp_code,route_code,ag_name
        End
        
        If upper(@pextra1)='U' Begin
				---route wise total
        select x.comp_code "COMP CODE",x.route_code "ROUTE CODE",x.route_name "ROUTE NAME",x.route_name_oth_lang "ROUTE NAME OTHER LANG",
		sum(x.first_sup) "FIRST SUPPLY",sum(x.second_sup) "SECOND SUPPLY",
		CASE sign(ISNULL(SUM(x.second_sup), 0) - ISNULL(SUM(x.first_sup), 0)) WHEN - 1 THEN 0 
		ELSE (ISNULL(SUM(x.second_sup), 0) - ISNULL(SUM(x.first_sup), 0)) 
		END "INCREASE SUPPLY",
		CASE sign(ISNULL(SUM(x.second_sup), 0) - ISNULL(SUM(x.first_sup), 0)) WHEN 1 THEN 0 
		ELSE (ISNULL(SUM(x.second_sup), 0) - ISNULL(SUM(x.first_sup), 0)) 
		END "DECREASE SUPPLY",
		CASE SUM(x.first_sup) WHEN 0 THEN 100 
		ELSE ROUND(((ISNULL(SUM(x.second_sup), 0) - ISNULL(SUM(x.first_sup), 0)) * 100) / CASE sign(SUM(x.second_sup) - SUM(x.first_sup)) WHEN - 1 THEN SUM(x.first_sup)ELSE SUM(x.second_sup)END, 2) 
		END "PERCENT_VARIANCE" from
                        (select distinct a.comp_code comp_code,a.unit_code unit_code,a.agcd,a.dpcd,a.publ,a.edtn,c.ag_name,c.ag_name_oth_lang,c.city_code,a.route_code,b.route_name,b.route_name_oth_lang,c.station_code station_code,c.branch_code branch_code,
                (select isnull(sum(base_supply),0) from cir_supply
                           where cir_supply.comp_code     =   @pcomp_code and unit =   @punit_code and
                                 cir_supply.publ          =   @ppublication and (edtn   =   @pedtn or @pedtn is null or @pedtn='') and
                                 isnull(cir_supply.supply_flag,'N') =   'Y' and cir_supply.comp_code = b.comp_code and
                                 cir_supply.unit          =   b.unit and cir_supply.agcd          = a.agcd and
                                 cir_supply.dpcd          =   a.dpcd and cir_supply.route_code    = b.route_code and
                                 cir_supply.publ          =   a.publ and cir_supply.edtn          = a.edtn and
                                 (cir_supply.route_code   =   @proute or @proute is null or @proute='') and
                                 cir_supply.edtn in(select distinct edtn from cir_edtn_mast where comp_code=@pcomp_code and
                                 (edtn = @pedtn or @pedtn is null or @pedtn='' ) and (main_edtn=@pmainedtn or @pmainedtn is null or @pmainedtn='')) and
                                 (cir_supply.supply_type_code = @pextra2 or @pextra2 is null or @pextra2='')) first_sup,
                      (select isnull(sum(sup_copy),0) from cir_dbksup
                           where comp_code    =    @pcomp_code and unit_code =    @punit_code and
                                 publ         =    @ppublication and (edtn   =    @pedtn or @pedtn is null or @pedtn='') and
                                 supdate         = @vseconddate and cir_dbksup.agcd =    a.agcd and
                                 cir_dbksup.dpcd = a.dpcd and cir_dbksup.route_code =  a.route_code and
                                 cir_dbksup.publ = a.publ and cir_dbksup.edtn =  a.edtn and
                                 (cir_dbksup.route_code= @proute or @proute is null or @proute='') and
                                 cir_dbksup.edtn in(select distinct edtn from cir_edtn_mast where comp_code=@pcomp_code and (edtn = @pedtn or @pedtn is null  or @pedtn='') and 
								(main_edtn=@pmainedtn or @pmainedtn is null  or @pmainedtn='')) and
                                 (cir_dbksup.sup_type_code = @pextra2 or @pextra2 is null or @pextra2='')) second_sup
                     from cir_dbksup a,cir_route_mast b,cir_agmast c
                     where a.comp_code=@pcomp_code and a.comp_code=b.comp_code and a.comp_code=c.comp_code and
                           a.unit_code=@punit_code and a.unit_code=b.unit and a.unit_code=c.unit and
                           (a.supdate = @vfirstdate or a.supdate = @vseconddate) and
                           a.agcd=c.agcd and a.dpcd=c.dpcd and
                           (a.route_code=@proute or @proute is null or @proute='') and a.route_code=b.route_code ) x
                     where isnull(x.second_sup,0)-isnull(x.first_sup,0)<>0
                           group by x.comp_code,x.unit_code,x.route_code,x.route_name,x.route_name_oth_lang
                           order by comp_code,route_code
		End
        else	Begin
				----route wise total
                 select x.comp_code "COMP CODE",x.route_code "ROUTE CODE",x.route_name "ROUTE NAME",x.route_name_oth_lang "ROUTE NAME OTHER LANG",sum(x.first_sup) "FIRST SUPPLY",sum(x.second_sup) "SECOND SUPPLY",
				CASE sign(ISNULL(SUM(x.second_sup), 0) - ISNULL(SUM(x.first_sup), 0)) WHEN - 1 THEN 0 
				ELSE (ISNULL(SUM(x.second_sup), 0) - ISNULL(SUM(x.first_sup), 0)) 
				END "INCREASE SUPPLY",
				CASE sign(ISNULL(SUM(x.second_sup), 0) - ISNULL(SUM(x.first_sup), 0)) WHEN 1 THEN 0 
				ELSE (ISNULL(SUM(x.second_sup), 0) - ISNULL(SUM(x.first_sup), 0)) 
				END "DECREASE SUPPLY",
				CASE SUM(x.first_sup) WHEN 0 THEN 100 
				ELSE ROUND(((ISNULL(SUM(x.second_sup), 0) - ISNULL(SUM(x.first_sup), 0)) * 100) / CASE sign(SUM(x.second_sup) - SUM(x.first_sup)) WHEN - 1 THEN SUM(x.first_sup)ELSE SUM(x.second_sup)END, 2) 
				END "PERCENT_VARIANCE" from
                (select distinct a.comp_code comp_code,a.agcd,a.dpcd,a.publ,a.edtn,c.ag_name,c.ag_name_oth_lang,c.city_code,a.route_code,b.route_name,b.route_name_oth_lang,
                        (select isnull(sum(sup_copy),0) from cir_dbksup
                                   where comp_code                =   @pcomp_code and unit_code =   @punit_code and
                                         publ                     =   @ppublication and (edtn   =   @pedtn or @pedtn is null or @pedtn='') and
                                         supdate                  =   @vfirstdate and cir_dbksup.comp_code=     b.comp_code and
                                         cir_dbksup.unit_code     =   b.unit and cir_dbksup.agcd          =   a.agcd and
                                         cir_dbksup.dpcd          =   a.dpcd and cir_dbksup.route_code    =     b.route_code and
                                         cir_dbksup.publ          =   a.publ and cir_dbksup.edtn          =      a.edtn and
                                         (cir_dbksup.route_code   =   @proute or @proute is null or @proute='') and
                                         cir_dbksup.edtn in(select distinct edtn from cir_edtn_mast where comp_code=@pcomp_code and
                                         (edtn = @pedtn or @pedtn is null or @pedtn='') and (main_edtn=@pmainedtn or @pmainedtn is null or @pmainedtn='')) and
                                         (cir_dbksup.sup_type_code = @pextra2 or @pextra2 is null or @pextra2='')) first_sup,
                              (select isnull(sum(sup_copy),0) from cir_dbksup
                                   where comp_code    =    @pcomp_code and unit_code =    @punit_code and
                                         publ         =    @ppublication and (edtn   =    @pedtn or @pedtn is null or @pedtn='') and
                                         supdate         = @vseconddate and cir_dbksup.agcd =    a.agcd and
                                         cir_dbksup.dpcd = a.dpcd and cir_dbksup.route_code =  a.route_code and
                                         cir_dbksup.publ = a.publ and cir_dbksup.edtn =  a.edtn and
                                         (cir_dbksup.route_code= @proute or @proute is null or @proute='') and
                                         cir_dbksup.edtn in(select distinct edtn from cir_edtn_mast where comp_code=@pcomp_code and (edtn = @pedtn or @pedtn is null or @pedtn='') and 
										(main_edtn=@pmainedtn or @pmainedtn is null or @pmainedtn='')) and
                                         (cir_dbksup.sup_type_code = @pextra2 or @pextra2 is null or @pextra2='')) second_sup
                             from cir_dbksup a,cir_route_mast b,cir_agmast c
                             where a.comp_code=@pcomp_code and a.comp_code=b.comp_code and a.comp_code=c.comp_code and
                                   a.unit_code=@punit_code and a.unit_code=b.unit and a.unit_code=c.unit and
                                   (a.supdate = @vfirstdate or a.supdate = @vseconddate) and
                                   a.agcd=c.agcd and a.dpcd=c.dpcd and
                                   (a.route_code=@proute or @proute is null or @proute='') and a.route_code=b.route_code ) x
                             where isnull(x.second_sup,0)-isnull(x.first_sup,0)<>0
                                   group by x.comp_code,x.route_code,x.route_name,x.route_name_oth_lang
                                   order by comp_code,route_code
        End
        
        If upper(@pextra1)='U' Begin
				----comp wise total
        select x.comp_code "COMP CODE",
		sum(x.first_sup) "FIRST SUPPLY",sum(x.second_sup) "SECOND SUPPLY",
		CASE sign(ISNULL(SUM(x.second_sup), 0) - ISNULL(SUM(x.first_sup), 0)) WHEN - 1 THEN 0 
		ELSE (ISNULL(SUM(x.second_sup), 0) - ISNULL(SUM(x.first_sup), 0)) 
		END "INCREASE SUPPLY",
		CASE sign(ISNULL(SUM(x.second_sup), 0) - ISNULL(SUM(x.first_sup), 0)) WHEN 1 THEN 0 
		ELSE (ISNULL(SUM(x.second_sup), 0) - ISNULL(SUM(x.first_sup), 0)) 
		END "DECREASE SUPPLY",
		CASE SUM(x.first_sup) WHEN 0 THEN 100 
		ELSE ROUND(((ISNULL(SUM(x.second_sup), 0) - ISNULL(SUM(x.first_sup), 0)) * 100) / CASE sign(SUM(x.second_sup) - SUM(x.first_sup)) WHEN - 1 THEN SUM(x.first_sup)ELSE SUM(x.second_sup)END, 2) 
		END "PERCENT_VARIANCE",
		(select isnull(sum(d.sup_copy),0) from cir_dbksup d,cir_agmast m  where d.comp_code = m.comp_code and d.comp_code = @pcomp_code and d.unit_code = m.unit and d.unit_code = @punit_code and
        d.publ = @ppublication and (d.edtn = @pedtn or @pedtn is null) and d.agcd=m.agcd and d.dpcd=m.dpcd and d.supdate = @vfirstdate and
        (m.dist_code = @proute or @proute is null or @proute='') and d.edtn in(select distinct edtn from cir_edtn_mast
        where comp_code=d.comp_code and edtn = d.edtn and (main_edtn=@pmainedtn or @pmainedtn is null or @pmainedtn='')) and
        (d.sup_type_code = @pextra2 or @pextra2 is null or @pextra2='')) first_total_supply from
		(select distinct a.comp_code comp_code,a.unit_code unit_code,a.agcd,a.dpcd,a.publ,a.edtn,c.ag_name,c.ag_name_oth_lang,c.city_code,a.route_code,b.route_name,b.route_name_oth_lang,c.station_code station_code,c.branch_code branch_code,
          (select isnull(sum(base_supply),0) from cir_supply
                           where cir_supply.comp_code     =   @pcomp_code and unit =   @punit_code and
                                 cir_supply.publ          =   @ppublication and (edtn   =   @pedtn or @pedtn is null or @pedtn='') and
                                 isnull(cir_supply.supply_flag,'N') =   'Y' and cir_supply.comp_code = b.comp_code and
                                 cir_supply.unit          =   b.unit and cir_supply.agcd          = a.agcd and
                                 cir_supply.dpcd          =   a.dpcd and cir_supply.route_code    = b.route_code and
                                 cir_supply.publ          =   a.publ and cir_supply.edtn          = a.edtn and
                                 (cir_supply.route_code   =   @proute or @proute is null or @proute='') and
                                 cir_supply.edtn in(select distinct edtn from cir_edtn_mast where comp_code=@pcomp_code and
                                 (edtn = @pedtn or @pedtn is null or @pedtn='') and (main_edtn=@pmainedtn or @pmainedtn is null or @pmainedtn='')) and
                                 (cir_supply.supply_type_code = @pextra2 or @pextra2 is null or @pextra2='')) first_sup,
                      (select isnull(sum(sup_copy),0) from cir_dbksup
                           where comp_code		 = @pcomp_code and unit_code =    @punit_code and
                                 publ			 = @ppublication and (edtn   =    @pedtn or @pedtn is null or @pedtn='') and
                                 supdate         = @vseconddate and cir_dbksup.agcd =    a.agcd and
                                 cir_dbksup.dpcd = a.dpcd and cir_dbksup.route_code =  a.route_code and
                                 cir_dbksup.publ = a.publ and cir_dbksup.edtn =  a.edtn and
                                 (cir_dbksup.route_code= @proute or @proute is null or @proute='') and
                                 cir_dbksup.edtn in(select distinct edtn from cir_edtn_mast where comp_code=@pcomp_code and (edtn = @pedtn or @pedtn is null or @pedtn='') and 
								(main_edtn=@pmainedtn or @pmainedtn is null or @pmainedtn='')) and
                                 (cir_dbksup.sup_type_code = @pextra2 or @pextra2 is null or @pextra2='')) second_sup
                     from cir_dbksup a,cir_route_mast b,cir_agmast c
                     where a.comp_code=@pcomp_code and a.comp_code=b.comp_code and a.comp_code=c.comp_code and
                           a.unit_code=@punit_code and a.unit_code=b.unit and a.unit_code=c.unit and
                           (a.supdate = @vfirstdate or a.supdate = @vseconddate) and
                           a.agcd=c.agcd and a.dpcd=c.dpcd and
                           (a.route_code=@proute or @proute is null or @proute='') and a.route_code=b.route_code ) x
                     where isnull(x.second_sup,0)-isnull(x.first_sup,0)<>0
                           group by x.comp_code
                           order by comp_code
			End
        else	Begin
        ----comp wise total
                     select x.comp_code "COMP CODE",sum(x.first_sup) "FIRST SUPPLY",sum(x.second_sup) "SECOND SUPPLY",
					CASE sign(ISNULL(SUM(x.second_sup), 0) - ISNULL(SUM(x.first_sup), 0)) WHEN - 1 THEN 0 
					ELSE (ISNULL(SUM(x.second_sup), 0) - ISNULL(SUM(x.first_sup), 0)) 
					END "INCREASE SUPPLY",

					CASE sign(ISNULL(SUM(x.second_sup), 0) - ISNULL(SUM(x.first_sup), 0)) WHEN 1 THEN 0 
					ELSE (ISNULL(SUM(x.second_sup), 0) - ISNULL(SUM(x.first_sup), 0)) 
					END "DECREASE SUPPLY",

					CASE SUM(x.first_sup) WHEN 0 THEN 100 
					ELSE ROUND(((ISNULL(SUM(x.second_sup), 0) - ISNULL(SUM(x.first_sup), 0)) * 100) / CASE sign(SUM(x.second_sup) - SUM(x.first_sup)) WHEN - 1 THEN SUM(x.first_sup)ELSE SUM(x.second_sup)END, 2) 
					END "PERCENT_VARIANCE",
                     (select isnull(sum(d.sup_copy),0) from cir_dbksup d,cir_agmast m  where d.comp_code = m.comp_code and d.comp_code = @pcomp_code and d.unit_code = m.unit and d.unit_code = @punit_code and
                            d.publ = @ppublication and (d.edtn = @pedtn or @pedtn is null or @pedtn='') and d.agcd=m.agcd and d.dpcd=m.dpcd and d.supdate = @vfirstdate and
                            (m.dist_code = @proute or @proute is null  or @proute='') and d.edtn in(select distinct edtn from cir_edtn_mast
                            where comp_code=d.comp_code and edtn = d.edtn and (main_edtn=@pmainedtn or @pmainedtn is null or @pmainedtn='')) and
                            (d.sup_type_code = @pextra2 or @pextra2 is null or @pextra2='')) first_total_supply from
                    (select distinct a.comp_code comp_code,a.agcd,a.dpcd,a.publ,a.edtn,c.ag_name,c.ag_name_oth_lang,c.city_code,a.route_code,b.route_name,b.route_name_oth_lang,
                            (select isnull(sum(sup_copy),0) from cir_dbksup
                                       where comp_code                =   @pcomp_code and unit_code =   @punit_code and
                                             publ                     =   @ppublication and (edtn   =   @pedtn or @pedtn is null or @pedtn='') and
                                             supdate                  =   @vfirstdate and cir_dbksup.comp_code =    b.comp_code and
                                             cir_dbksup.unit_code     =   b.unit and cir_dbksup.agcd          =     a.agcd and
                                             cir_dbksup.dpcd          =   a.dpcd and cir_dbksup.route_code    =     b.route_code and
                                             cir_dbksup.publ          =   a.publ and cir_dbksup.edtn          =     a.edtn and
                                             (cir_dbksup.route_code   =   @proute or @proute is null or @proute='') and
                                             cir_dbksup.edtn in(select distinct edtn from cir_edtn_mast where comp_code=@pcomp_code and
                                             (edtn = @pedtn or @pedtn is null or @pedtn='') and (main_edtn=@pmainedtn or @pmainedtn is null or @pmainedtn='')) and
                                             (cir_dbksup.sup_type_code = @pextra2 or @pextra2 is null or @pextra2='')) first_sup,
                                  (select isnull(sum(sup_copy),0) from cir_dbksup
                                       where comp_code    =    @pcomp_code and unit_code =    @punit_code and
                                             publ         =    @ppublication and (edtn   =    @pedtn or @pedtn is null or @pedtn='') and
                                             supdate      = @vseconddate and cir_dbksup.agcd =    a.agcd and
                                             cir_dbksup.dpcd = a.dpcd and cir_dbksup.route_code =  a.route_code and
                                             cir_dbksup.publ = a.publ and cir_dbksup.edtn =  a.edtn and
                                             (cir_dbksup.route_code= @proute or @proute is null or @proute='') and
                                             cir_dbksup.edtn in(select distinct edtn from cir_edtn_mast where comp_code=@pcomp_code and (edtn = @pedtn or @pedtn is null or @pedtn='') and (main_edtn=@pmainedtn or @pmainedtn is null or @pmainedtn='')) and
                                             (cir_dbksup.sup_type_code = @pextra2 or @pextra2 is null or @pextra2='')) second_sup
                                 from cir_dbksup a,cir_route_mast b,cir_agmast c
                                 where a.comp_code=@pcomp_code and a.comp_code=b.comp_code and a.comp_code=c.comp_code and
                                       a.unit_code=@punit_code and a.unit_code=b.unit and a.unit_code=c.unit and
                                       (a.supdate = @vfirstdate or a.supdate = @vseconddate) and
                                       a.agcd=c.agcd and a.dpcd=c.dpcd and
                                       (a.route_code=@proute or @proute is null or @proute='') and a.route_code=b.route_code )x
                                 where isnull(x.second_sup,0)-isnull(x.first_sup,0)<>0
                                       group by comp_code
                                       order by comp_code
        End
		 
End



ALTER PROCEDURE [dbo].[cir_rep_unsold_supply_cir_monthly_net_paid_sale]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@ppubl                                    VARCHAR(20) ,
	@pmainedtn                                VARCHAR(20) ,
	@pedtn                                    VARCHAR(20) ,
	@pfromdate                                DATETIME  ,
	@ptilldate                                DATETIME  ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(200) ,
	@pextra2                                  VARCHAR(200) 
AS 
		
	DECLARE @v_frdt		AS	DATETIME 
	DECLARE @v_todt		AS	DATETIME 
	DECLARE @vvar		AS	VARCHAR(8000) 
	DECLARE @vvar_sum	AS	VARCHAR(8000) 
	DECLARE @v_query	AS	VARCHAR(8000) 
	DECLARE @v_hdays	AS	NUMERIC(5) 
	DECLARE @v_avg_sale AS  NUMERIC(10) 


	DECLARE @vcomp_code1                                       VARCHAR(20)  
	DECLARE @vunit_code1                                       VARCHAR(20)  
	DECLARE @vmon1                                             VARCHAR(200) 
	DECLARE @vdays1                                            NUMERIC(8, 0)
	DECLARE @vsupply_copy1                                     FLOAT 
	DECLARE @vunsold_copy1                                     FLOAT 
	DECLARE @vnet_sale_copy1                                   FLOAT 
      
      

		DECLARE c1 cursor LOCAL FOR 
		SELECT u.comp_code comp_code, u.unit_code unit_code, 
        CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(supdate)-1),supdate),101) mon,
		CONVERT(NUMERIC(8, 0), DATEPART(DD, DATEADD(D, -DAY(DATEADD(M, 1, u.supdate)), DATEADD(M, 1, u.supdate)))) days,
		SUM(CONVERT(FLOAT, u.supply_copy)) supply_copy,
		ISNULL(SUM(CONVERT(FLOAT, u.unsold_copy)), 0) unsold_copy,
		SUM(CONVERT(FLOAT, ISNULL(u.supply_copy, 0) - ISNULL(u.unsold_copy, 0))) net_sale_copy
		FROM (	SELECT a.comp_code comp_code, a.unit_code unit_code, a.agcd, a.dpcd, a.publ, a.edtn, a.supdate,
		SUM(CONVERT(FLOAT, a.sup_copy)) supply_copy,
		(SELECT SUM(CONVERT(FLOAT, ISNULL(apr_short_recpt, 0) + ISNULL(apr_late_recpt, 0) + ISNULL(apr_bnr, 0) + ISNULL(apr_unsold, 0)))
		FROM cir_unsold_dtl b 
		WHERE a.comp_code  = b.comp_code AND a.unit_code  = b.unit_code AND	a.agcd  = b.agcd 
        AND	a.dpcd  = b.dpcd AND a.publ  = b.publ
		AND	a.edtn  = b.edtn AND b.doctype  = 'UCN' AND	b.recptdt  between @v_frdt  and  @v_todt) unsold_copy
		FROM  cir_dbksup a 
		WHERE a.comp_code  = @pcomp_code AND	(a.unit_code  = @punit_code OR	@punit_code  is null) AND	(a.publ  = @ppubl OR	@ppubl  is null)
		AND	a.supdate  between @v_frdt  and  @v_todt AND	a.sup_type_code  in
		( SELECT sup_ty_code FROM  cir_supply_type_mast 
		WHERE comp_code  = @pcomp_code AND	UPPER(ISNULL(bill_pay, 'N'))  = 'Y')
		AND	(a.edtn  = @pedtn OR	@pedtn  is null) AND	a.edtn  in
		( SELECT DISTINCT edtn FROM  cir_edtn_mast 
		WHERE comp_code  = @pcomp_code AND	(edtn  = @pedtn OR	@pedtn  is null) AND	(main_edtn  = @pmainedtn OR	@pmainedtn  is null))
		GROUP BY a.comp_code, a.unit_code, a.agcd, a.dpcd, a.publ, a.edtn,  supdate) u WHERE @pextra1='R'
		GROUP BY u.comp_code,  u.unit_code,
	    CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(u.supdate)-1),u.supdate),101),
		CONVERT(NUMERIC(8, 0), DATEPART(DD, DATEADD(D, -DAY(DATEADD(M, 1, u.supdate)), DATEADD(M, 1, u.supdate))))
		UNION
		SELECT u.comp_code comp_code, u.unit_code unit_code, 
        CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(supdate)-1),supdate),101) mon,
		CONVERT(NUMERIC(8, 0), DATEPART(DD, DATEADD(D, -DAY(DATEADD(M, 1, u.supdate)), DATEADD(M, 1, u.supdate)))) days,
		SUM(CONVERT(FLOAT, u.supply_copy)) supply_copy,
		ISNULL(SUM(CONVERT(FLOAT, u.unsold_copy)), 0) unsold_copy,
		SUM(CONVERT(FLOAT, ISNULL(u.supply_copy, 0) - ISNULL(u.unsold_copy, 0))) net_sale_copy
		FROM (	SELECT a.comp_code comp_code, a.unit_code unit_code, a.agcd, a.dpcd, a.publ, a.edtn, a.supdate,
		SUM(CONVERT(FLOAT, a.sup_copy)) supply_copy,
		(SELECT SUM(CONVERT(FLOAT, ISNULL(apr_short_recpt, 0) + ISNULL(apr_late_recpt, 0) + ISNULL(apr_bnr, 0) + ISNULL(apr_unsold, 0)))
		FROM  cir_unsold_dtl b 
		WHERE	 a.comp_code  = b.comp_code AND	a.unit_code  = b.unit_code AND	a.agcd  = b.agcd 
        AND	a.dpcd  = b.dpcd AND	a.publ  = b.publ
		AND	a.edtn  = b.edtn AND	b.doctype  = 'UCN' AND	b.SUPDATE  between @v_frdt  and  @v_todt) unsold_copy
		FROM  cir_dbksup a 
		WHERE	 a.comp_code  = @pcomp_code AND	(a.unit_code  = @punit_code OR	@punit_code  is null) AND	(a.publ  = @ppubl OR	@ppubl  is null)
		AND	a.supdate  between @v_frdt  and  @v_todt AND	a.sup_type_code  in
		( SELECT sup_ty_code FROM  cir_supply_type_mast 
		WHERE	 comp_code  = @pcomp_code AND	UPPER(ISNULL(bill_pay, 'N'))  = 'Y')
		AND	(a.edtn  = @pedtn OR	@pedtn  is null) AND	a.edtn  in
		( SELECT DISTINCT edtn FROM  cir_edtn_mast 
		WHERE	 comp_code  = @pcomp_code AND	(edtn  = @pedtn OR	@pedtn  is null) AND	(main_edtn  = @pmainedtn
		OR	@pmainedtn  is null))
		GROUP BY a.comp_code, a.unit_code, a.agcd, a.dpcd, a.publ, a.edtn,  supdate 
		) u WHERE @pextra1='S'
		GROUP BY u.comp_code,  u.unit_code,
	    CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(u.supdate)-1),u.supdate),101),
		CONVERT(NUMERIC(8, 0), DATEPART(DD, DATEADD(D, -DAY(DATEADD(M, 1, u.supdate)), DATEADD(M, 1, u.supdate))))
		ORDER BY u.comp_code, u.unit_code,
		CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(u.supdate)-1),u.supdate),101) 
		
		


        DECLARE @vcomp_code2                                       VARCHAR(20)  
        DECLARE @vunit_code2                                       VARCHAR(20)  
        DECLARE @vunit_name2                                       VARCHAR(200) 
        DECLARE @vmon_dt2                                          DATETIME



		DECLARE c2 cursor LOCAL FOR 
		SELECT DISTINCT comp_code, unit_code, unit_code unit_name, mon_dt
		FROM  #cir_temp_net_sale 
		WHERE	 comp_code  = @pcomp_code AND	(unit_code  = @punit_code OR	@punit_code  is null)
		ORDER BY comp_code, 3, mon_dt 
		
	 
		SELECT @v_frdt  = @pfromdate
		SELECT @v_todt  =  @ptilldate
		DELETE FROM   #cir_temp_net_sale    
		
	CREATE  TABLE #CIR_TEMP_NET_SALE
(
  COMP_CODE    VARCHAR(8 ),
  UNIT_CODE    VARCHAR(8 ),
  MON_DT       DATEtime,
  DESCP_SNO    numeric(3),
  DESCP        VARCHAR(50 ),
  DESCP_VALUE  numeric(10)
)	
		
		
		OPEN c1 
        fetch NEXT FROM c1 INTO @vcomp_code1 ,@vunit_code1,@vmon1 ,@vdays1 ,@vsupply_copy1 ,@vunsold_copy1 ,@vnet_sale_copy1
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN 
			
			
			SELECT @v_hdays  =  COUNT(*)
			FROM  cir_holiday_mast 
			WHERE	 comp_code  = @vcomp_code1
			 AND	unit  = @vunit_code1
			 AND	(h_publ  = @ppubl
			 OR	@ppubl  is null)
			 AND	CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(h_date)-1),h_date),101)  = @vmon1
			
			IF ( ISNULL( @vdays1, 0)- ISNULL(@v_hdays, 0)) > 0 
			BEGIN 
				SELECT @v_avg_sale  = CAST(ROUND(ISNULL( @vnet_sale_copy1, 0) / CONVERT(FLOAT, (ISNULL( @vdays1, 0) - ISNULL(@v_hdays, 0))),0) AS INT)
			END
			ELSE
			BEGIN 
				IF ISNULL(@vmon1, 0)> 0 
				BEGIN 
					SELECT @v_avg_sale  = CAST(ROUND(ISNULL( @vnet_sale_copy1, 0) / CONVERT(FLOAT, (ISNULL( @vdays1, 0) - ISNULL(@v_hdays, 0))),0) AS INT)
				END
				ELSE
				BEGIN 
					SELECT @v_avg_sale  = ISNULL(@vnet_sale_copy1, 0)
				END
   
			END
   
			INSERT INTO  #cir_temp_net_sale   ( comp_code , unit_code , mon_dt , descp_sno , descp , descp_value )  
			VALUES 	( @vcomp_code1 , @vunit_code1 , @vmon1 , 1 , 'Days Published' , ISNULL(@vdays1, 0) - ISNULL(@v_hdays, 0) )  
			
			

            INSERT INTO  #cir_temp_net_sale   ( comp_code , unit_code , mon_dt , descp_sno , descp , descp_value )  
			VALUES ( @vcomp_code1 , @vunit_code1 , @vmon1 , 2 , 'Sale Copies' , @vsupply_copy1)  
		

	
			INSERT INTO  #cir_temp_net_sale   ( comp_code , unit_code ,mon_dt , descp_sno , descp , descp_value )  
			VALUES 	(@vcomp_code1 , @vunit_code1 , @vmon1 , 3 , 'UnSold Copies' , @vunsold_copy1 )  
			


			INSERT INTO  #cir_temp_net_sale   ( comp_code , unit_code , mon_dt , descp_sno , descp , descp_value )  
			VALUES ( @vcomp_code1 ,@vunit_code1 ,@vmon1 , 4 , 'Net Sale' , @vnet_sale_copy1)  
			


			INSERT INTO  #cir_temp_net_sale   ( comp_code ,unit_code , mon_dt , descp_sno , descp , descp_value )  
			VALUES ( @vcomp_code1 , @vunit_code1 , @vmon1 , 5 , 'Average Sale' , @v_avg_sale )  



		    fetch NEXT FROM c1 INTO @vcomp_code1 ,@vunit_code1,@vmon1 ,@vdays1 ,@vsupply_copy1 ,@vunsold_copy1 ,@vnet_sale_copy1
		
		END 
		
		
		close c1
		
		
	
		
		OPEN c2 
 
        fetch NEXT FROM c2 INTO @vcomp_code2  ,@vunit_code2 ,@vunit_name2 ,@vmon_dt2		
		
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN 
			
			
			

			IF @vvar is null 
			BEGIN 
				SELECT @vvar  = 'sum(case a.mon_dt when' + '''' +  @vmon_dt2 + '''' + ' then a.descp_value else 0 end) "' + CONVERT(VARCHAR(23), @vmon_dt2)+ '"' 
				SELECT @vvar_sum  = 'case a.mon_dt when' + '''' +  @vmon_dt2 + '''' + ' then a.descp_value else 0 end' 
			END
			ELSE
			BEGIN 
				SELECT @vvar  = @vvar + ',sum(case when a.mon_dt ' + '''' +   @vmon_dt2 + '''' + 'then a.descp_value else 0 end) "' + CONVERT(VARCHAR(23),  @vmon_dt2)+ '"' 
				SELECT @vvar_sum  = @vvar_sum + '+' + 'case when a.mon_dt' + '''' +   @vmon_dt2 + '''' + 'then a.descp_value else 0 end' 
			END
         
           fetch NEXT FROM c2 INTO @vcomp_code2  ,@vunit_code2 ,@vunit_name2 ,@vmon_dt2
			
		END
		
		
		close c2
		
		SELECT @vvar_sum  = 'sum(' + @vvar_sum + ') "TOTAL"' 
		SELECT @v_query  = 'select a.comp_code comp_code,a.unit_code unit_code,a.unit_code unit_name,a.descp_sno descp_sno,a.descp descp,' + @vvar + ',' + @vvar_sum + ' from #cir_temp_net_sale a        where a.comp_code=' + '''' + @pcomp_code + '''' + ' and (a.unit_code=' + '''' + @punit_code + '''' + ' or' + '''' + @punit_code + '''' + ' is null)        group by a.comp_code,a.unit_code,a.unit_code,a.descp_sno,a.descp        order by a.comp_code,3,a.descp_sno' 
		IF @vvar is not null and @vvar_sum is not null 
		BEGIN 
			EXEC @v_query 
		END
		ELSE
		BEGIN 
			SELECT @v_query  = 'select' + '''' + @pcomp_code + '''' + ' comp_code,' + '''' + @punit_code + '''' + ' unit_code from dual' 
			EXEC @v_query 
		END
   
 DEALLOCATE c1
 DEALLOCATE c2




ALTER PROCEDURE  [dbo].[Cir_SubSubRoute_Bind1]

  	@pcompcode as varchar(200),
    @punitcode as varchar(200),
    @proutecode as varchar(200),
    @psubrtcode as varchar(200),
    @psubsubrtcode as varchar(200),
    @pdateformat as	varchar(200),
    @pextra1 as	varchar(200),
    @pextra2 as varchar(200)

 AS
   
     /* select * from cir_sub_subroute_mast 
              where comp_code=@pcompcode and 
                    unit=@punitcode and
  	                route_code=@proutecode or @proutecode=null or @proutecode ='' and 
                    subrt_code=@psubrtcode or @psubrtcode=null or @psubrtcode ='' and 
                    (sub_subrt_code=@psubsubrtcode or @psubsubrtcode=null or @psubsubrtcode='') and
                     ISNULL(freeze_flag,'N')='N'
  	          order by route_code,subrt_code,sub_subrt_code

*/
 select cir_sub_subroute_mast.*,dbo.cir_get_route_name(cir_sub_subroute_mast.comp_code,cir_sub_subroute_mast.unit,cir_sub_subroute_mast.route_code) "ROUTE NAME",
  	    dbo.cir_get_subroute_name(cir_sub_subroute_mast.comp_code,cir_sub_subroute_mast.unit,cir_sub_subroute_mast.route_code,cir_sub_subroute_mast.subrt_code) "SUBROUTE NAME",
  	    dbo.cir_get_drop_point_name(cir_sub_subroute_mast.comp_code,cir_sub_subroute_mast.unit,cir_sub_subroute_mast.start_point,1) start_drop_point_name,
   	     dbo.cir_get_drop_point_name(cir_sub_subroute_mast.comp_code,cir_sub_subroute_mast.unit,cir_sub_subroute_mast.end_point,1) end_drop_point_name
  	    from cir_sub_subroute_mast
              where comp_code=@pcompcode and
                    unit=@punitcode and
  	                (route_code=@proutecode OR @proutecode is null or @proutecode='') and
                    (subrt_code=@psubrtcode or @psubrtcode is null or @psubrtcode='') and
                    (sub_subrt_code=@psubsubrtcode or isnull(@psubsubrtcode,'0')='0' or @psubsubrtcode='') /*and
                    nvl(freeze_flag,'N')='N'*/
  	          order by route_code,subrt_code,sub_subrt_code;





CREATE procedure cir_agency_class_bind_p 
 
     @pcomp_code as varchar(200),
     @pdateformat as varchar(200),
     @pextra1 as varchar(200),
     @pextra2 as varchar(200)
  as   
 Begin
 
            select * from cir_agency_class_mast
                  where comp_code=@pcomp_code 
                  order by class_code;

END



ALTER PROCEDURE  [dbo].[Cir_Route_Droppoint_Bind]

  	@pcompcode as varchar(200),
   	@punitcode as varchar(200),
    @proutecode as varchar(200),
    @pdateformat as	varchar(200),
    @pextra1 as	varchar(200),
    @pextra2 as varchar(200)

 AS
   
  select distinct a.station_code DROP_POINT_CODE,c.drop_point_name DROP_POINT_NAME
  	         from cir_agmast a,cir_supply b,cir_drop_point_mast c
		         where a.comp_code=b.comp_code and 
                       a.comp_code=c.comp_code and 
                       a.comp_code=@pcompcode and 
                       a.unit=b.unit and
					   a.unit=c.unit_code and 
                       a.unit=@punitcode and 
                       a.agcd=b.agcd and 
                       a.dpcd=b.dpcd and
					   a.station_code=c.drop_point and 
                       b.route_code=@proutecode and 
                        ISNULL(a.suspend,'N')='N' and
                        ISNULL(a.freeze_flag,'N')='N' and
                        ISNULL(c.freeze_flag,'N')='N' 
				 order by c.drop_point_name





//////more

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
				 a.trans_code TRANS_CODE,
                 b.transporter_name TRANSPORTER_NAME,
                 a.vehicle_no VEHICLE_NO,
                 a.vehicle_name VEHICLE_NAME,
                 a.vehicle_model_no VEHICLE_MODEL_NO,
                 a.vehicle_owner_name VEHICLE_OWNER_NAME,
                 a.vehicle_start_date VEHICLE_START_DATE
		FROM  cir_route_taxi_mast a,
			 cir_transporter_mast b 
		WHERE	 a.comp_code  = b.comp_code
		 AND	a.comp_code  = @pcompcode
		 AND	a.unit_code  = @punitcode
		 AND	a.trans_code  = b.transporter_code
		 AND	(a.route_code  = @proutecode
		 OR	@proutecode  is null)
		ORDER BY vehicle_start_date,
			 b.transporter_name,
			 a.vehicle_no 



CREATE 
  PROCEDURE cir_exe_unsold_apr_grid_P(

    @loginid            as varchar(50)   
    ) as
    
begin    
    
    select * from CIR_UNSOLD_APR_PERMISSION where (USER_ID=@loginid OR @loginid IS NULL);
    
 
    select  "Branch_Code","Branch_Name" from branch_mst order by  "Branch_Name";
    
   
    select  "Comp_Code","Comp_Name" from comp_mst order by "Comp_Name";
    
  
    select  "doc_type","doc_Name" from fa_docmst where "doc_type" in ('RCR','DN','CN') order by "doc_Name";  


    select MAX(INSERT_ID) INSERT_ID from CIR_UNSOLD_APR_PERMISSION where (USER_ID=@loginid OR @loginid IS NULL);
End 


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER PROCEDURE  [dbo].[Cir_SubRoute_Bind1]

  	@pcompcode as varchar(200),
    @punitcode as varchar(200),
    @proutecode as varchar(200),
    @psubrtcode as varchar(200),
    @pdateformat as	varchar(200),
    @pextra1 as	varchar(200),
    @pextra2 as varchar(200)

 AS
   
   select a.comp_code COMP_CODE,a.unit UNIT,a.route_code ROUTE_CODE,a.subrt_code SUBRT_CODE,
               a.subrt_name SUBRT_NAME,a.subrt_name_oth_lang SUBRT_NAME_OTH_LANG,a.subrt_mode SUBRT_MODE,b.mode_desc MODE_NAME,
               a.start_point START_POINT,a.end_point END_POINT,a.subrt_dist SUBRT_DIST,a.subrt_seq SUBRT_SEQ,
               (select TOP 1 c.drop_point_name from cir_drop_point_mast c    where a.comp_code=c.comp_code and a.start_point=c.drop_point) START_DROP_POINT_NAME,
               (select TOP 1 d.drop_point_name from cir_drop_point_mast d    where a.comp_code=d.comp_code and a.end_point=d.drop_point) END_DROP_POINT_NAME
           from cir_sub_route_mast a,cir_route_mode_mast b
           where a.comp_code=b.comp_code and 
                 a.comp_code=@pcompcode and 
                 a.unit=@punitcode and
                 (a.subrt_code=@psubrtcode or  ISNULL(@psubrtcode,'0')='0' or @psubrtcode = '' ) 
                 --and ISNULL(a.freeze_flag,'N')='N'
 and ((upper("SUBRT_NAME") like upper(@pextra1)+'%') or (@pextra1 is null) or(@pextra1=''))
                  and (a.SUBRT_MODE=@pextra2 or @pextra2 is null or @pextra2='')
           order by route_code,subrt_code







CREATE 
  procedure cir_extra_rate_bind_p(
    @pcomp_code             as varchar(200),
    @punit_code             as varchar(200),
    @ppubl                     as varchar(200),
    @pedtn                     as varchar(200),
    @pdateformat         as varchar(200),
    @porderby                 as varchar(200),
    @pextra1                 as varchar(200),
    @pextra2                 as varchar(200)
    ) 
    As
  declare @vquery        varchar(4000);  
  Begin
    set @vquery=' select cir_extra_rate_mast.*,
                    dbo.cir_get_publ_name(cir_extra_rate_mast.comp_code,cir_extra_rate_mast.publ) publ_name,
                    dbo.cir_get_edtn_name(cir_extra_rate_mast.comp_code,cir_extra_rate_mast.edtn) edtn_name
        from cir_extra_rate_mast
           where comp_code='+''''+@pcomp_code+''''+' and
                 unit='+''''+@punit_code+''''+' and
                ((publ='+''''+@ppubl+''''+') or ('+''''+@ppubl+''''+' is null)) and
                ((edtn='+''''+@pedtn+''''+') or ('+''''+@pedtn+''''+' is null))
                 order by '+@porderby;
   print(@vquery)
exec(@vquery)
     
  End 

CREATE 
  PROCEDURE cir_execute_unsoldapr_per_P(

    @loginid            as varchar(50)    
    ) as
    
begin    
  
    select distinct USER_ID,(select "username" from login where "userid"=user_id) as "USERNAME" from CIR_UNSOLD_APR_PERMISSION where (USER_ID=@loginid OR @loginid IS NULL);   

End 


ALTER PROCEDURE [dbo].[cir_supply_apr_cir_supply_apr_p]
	@pcompcode                                VARCHAR(4000) ,
	@punit                                    VARCHAR(4000) ,
	@pagcd                                    VARCHAR(4000) ,
	@pdpcd                                    VARCHAR(4000) ,
	@pdateformat                              VARCHAR(4000) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
	
AS 
	BEGIN
		SELECT
				 a.comp_code AS COMP_CODE,
				 a.unit AS UNIT,
				 a.branch_code AS BRANCH_CODE,
				 c.branch_name AS BRANCH_NAME,
				 a.agcd	AS AGCD,
				 a.dpcd	AS DPCD,
				 a.ag_name	AS AG_NAME,
				 a.ag_name_oth_lang AS AG_NAME_OTH_LANG,
				 b.publ	AS PUBL,
				 DBO.cir_get_publ_name(a.comp_code, b.publ) AS PUBL_NAME,
				 d.main_edtn AS MAIN_EDTN,
				 DBO.cir_get_edtn_name(a.comp_code, d.main_edtn) AS EDTN_NAME,
				 b.edtn AS EDTN,
				 d.edtn_name AS SUB_EDTN_NAME,
				 b.supply_flag AS SUPPLY_FLAG,
				 b.supply_type_code AS SUPPLY_TYPE_CODE,
				 DBO.cir_get_supply_name(b.comp_code, b.supply_type_code) SUPPLY_TYPE_NAME,
				 isnull(b.base_supply,0) AS BASE_SUPPLY,
				 isnull(b.supply_sun,0) as SUPPLY_SUN,
				 isnull(b.supply_mon,0) AS SUPPLY_MON,
				 isnull(b.supply_tue,0) AS SUPPLY_TUE,
				 isnull(b.supply_wed,0) AS SUPPLY_WED,
				 isnull(b.supply_thu,0) AS SUPPLY_THU,
				 isnull(b.supply_fri,0) AS SUPPLY_FRI,
				 isnull(b.supply_sat,0) AS SUPPLY_SAT
		FROM  cir_agmast a,
			 cir_supply b,
			 branch_mst c,
			 cir_edtn_mast d 
		WHERE	 a.comp_code  = b.comp_code
		 AND	a.comp_code  = d.comp_code
		 AND	a.comp_code  = ISNULL(@pcompcode, a.comp_code)
		 AND	a.unit  = b.unit
		 AND	a.unit  = d.unit_code
		 AND	a.unit  = ISNULL(@punit, a.unit)
		 AND	a.agcd  = b.agcd
		 AND	a.agcd  = ISNULL(@pagcd, a.agcd)
		 AND	a.dpcd  = b.dpcd
		 AND	a.dpcd  = ISNULL(@pdpcd, a.agcd)
		 AND	a.branch_code  = c.Branch_Code
		 AND	b.publ  = d.publ
		 AND	b.edtn  = d.edtn
		ORDER BY a.comp_code,
			 a.unit,
			 a.ag_name,
			 b.publ,
			 main_edtn,
			 edtn 


	END











ALTER PROCEDURE [dbo].[cir_special_supply_upd_cir_special_supply_upd_p]
	@pcompcode                                VARCHAR(20) ,
	@punitcode                                VARCHAR(20) ,
	@ppublcode                                VARCHAR(20) ,
	@pedtncode                                VARCHAR(20) ,
	@psup_type                                VARCHAR(20) ,
	@pag_type                                 VARCHAR(20) ,
	@pag_class                                VARCHAR(20) ,
	@pdistcode                                VARCHAR(20) ,
	@ptalukacode                              VARCHAR(20) ,
	@pusercode                                VARCHAR(20) ,
	@pspl_type                                VARCHAR(20) ,
	@pcopy_percent_flag                       VARCHAR(20) ,
	@pcopy_percent                            FLOAT ,
	@psupply_from                             FLOAT ,
	@psupply_till                             FLOAT ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,------for edition code------
	@pextra2                                  VARCHAR(4000),------for particuler day-----
	@pstate									  VARCHAR(20) ,
    @proute									  VARCHAR(20) ,
    @pextra3								  VARCHAR(4000),
    @pextra4								  VARCHAR(4000),
    @pextra5								  VARCHAR(4000)
AS 

DECLARE c1 cursor LOCAL FOR 
 select distinct z.agcd agcd,z.dpcd dpcd from
    (select distinct a.agcd agcd,a.dpcd dpcd from cir_agmast a,cir_supply b,cir_edtn_mast c
    where a.comp_code = @pcompcode and a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.unit= @punitcode and 
    a.unit=b.unit and a.unit=c.unit_code and 
    (a.ag_type = @pag_type or @pag_type is null) and (a.ag_class=  @pag_class or  @pag_class is null) and 
    (a.state_code= @pstate or @pstate is null) and (a.dist_code=  @pdistcode or  @pdistcode is null) and (a.tehsil_taluka= @ptalukacode or  @ptalukacode is null) and 
    a.agcd=b.agcd and a.dpcd=b.dpcd and b.publ=c.publ and b.edtn=c.edtn and 
    b.edtn=isnull( @pextra1,b.edtn) and c.main_edtn=isnull( @pedtncode,c.main_edtn) and 
    b.supply_type_code= @psup_type and isnull(b.supply_flag,'N')='Y' and 
    isnull(b.base_supply,0)+isnull(b.supply_sun,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_sun,0)<=isnull( @psupply_till,0) and
    (b.route_code= @proute or  @proute is null) and
    isnull(a.suspend,'N')='N' and upper(@pextra2)='SUN'
    union
    select distinct a.agcd agcd,a.dpcd dpcd from cir_agmast a,cir_supply b,cir_edtn_mast c
    where a.comp_code = @pcompcode and a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.unit= @punitcode and 
    a.unit=b.unit and a.unit=c.unit_code and 
    (a.ag_type= @pag_type or @pag_type is null) and (a.ag_class= @pag_class or  @pag_class is null) and 
    (a.state_code=@pstate or @pstate is null) and (a.dist_code= @pdistcode or  @pdistcode is null) and (a.tehsil_taluka= @ptalukacode or  @ptalukacode is null) and 
    a.agcd=b.agcd and a.dpcd=b.dpcd and b.publ=c.publ and b.edtn=c.edtn and 
    b.edtn=isnull( @pextra1,b.edtn) and c.main_edtn=isnull( @pedtncode,c.main_edtn) and 
    b.supply_type_code= @psup_type and isnull(b.supply_flag,'N')='Y' and 
    isnull(b.base_supply,0)+isnull(b.supply_mon,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_mon,0)<=isnull( @psupply_till,0) and
    (b.route_code= @proute or  @proute is null) and isnull(a.suspend,'N')='N' and upper( @pextra2)='MON'
    union
    select distinct a.agcd agcd,a.dpcd dpcd from cir_agmast a,cir_supply b,cir_edtn_mast c
    where a.comp_code = @pcompcode and a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.unit= @punitcode and 
    a.unit=b.unit and a.unit=c.unit_code and 
    (a.ag_type= @pag_type or @pag_type is null) and (a.ag_class= @pag_class or  @pag_class is null) and 
    (a.state_code=@pstate or @pstate is null) and (a.dist_code= @pdistcode or  @pdistcode is null) and (a.tehsil_taluka= @ptalukacode or  @ptalukacode is null) and 
    a.agcd=b.agcd and a.dpcd=b.dpcd and b.publ=c.publ and b.edtn=c.edtn and 
    b.edtn=isnull( @pextra1,b.edtn) and c.main_edtn=isnull( @pedtncode,c.main_edtn) and 
    b.supply_type_code= @psup_type and isnull(b.supply_flag,'N')='Y' and 
    isnull(b.base_supply,0)+isnull(b.supply_tue,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_tue,0)<=isnull( @psupply_till,0) and
    (b.route_code= @proute or  @proute is null) and isnull(a.suspend,'N')='N' and upper( @pextra2)='TUE'
    union
    select distinct a.agcd agcd,a.dpcd dpcd from cir_agmast a,cir_supply b,cir_edtn_mast c
    where a.comp_code = @pcompcode and a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.unit= @punitcode and 
    a.unit=b.unit and a.unit=c.unit_code and 
    (a.ag_type= @pag_type or @pag_type is null) and (a.ag_class= @pag_class or  @pag_class is null) and 
    (a.state_code=@pstate or @pstate is null) and (a.dist_code= @pdistcode or  @pdistcode is null) and (a.tehsil_taluka= @ptalukacode or  @ptalukacode is null) and 
    a.agcd=b.agcd and a.dpcd=b.dpcd and b.publ=c.publ and b.edtn=c.edtn and 
    b.edtn=isnull( @pextra1,b.edtn) and c.main_edtn=isnull( @pedtncode,c.main_edtn) and 
    b.supply_type_code= @psup_type and isnull(b.supply_flag,'N')='Y' and 
    isnull(b.base_supply,0)+isnull(b.supply_wed,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_wed,0)<=isnull( @psupply_till,0) and
    (b.route_code= @proute or  @proute is null) and isnull(a.suspend,'N')='N' and upper( @pextra2)='WED'
    union
    select distinct a.agcd agcd,a.dpcd dpcd from cir_agmast a,cir_supply b,cir_edtn_mast c
    where a.comp_code = @pcompcode and a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.unit= @punitcode and 
    a.unit=b.unit and a.unit=c.unit_code and 
    (a.ag_type= @pag_type or @pag_type is null) and (a.ag_class= @pag_class or  @pag_class is null) and 
    (a.state_code= @pstate or  @pstate is null) and (a.dist_code= @pdistcode or  @pdistcode is null) and (a.tehsil_taluka= @ptalukacode or  @ptalukacode is null) and 
    a.agcd=b.agcd and a.dpcd=b.dpcd and b.publ=c.publ and b.edtn=c.edtn and 
    b.edtn=isnull( @pextra1,b.edtn) and c.main_edtn=isnull( @pedtncode,c.main_edtn) and 
    b.supply_type_code= @psup_type and isnull(b.supply_flag,'N')='Y' and 
    isnull(b.base_supply,0)+isnull(b.supply_thu,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_thu,0)<=isnull( @psupply_till,0) and
    (b.route_code= @proute or  @proute is null) and isnull(a.suspend,'N')='N' and upper( @pextra2)='THU'
    union
    select distinct a.agcd agcd,a.dpcd dpcd from cir_agmast a,cir_supply b,cir_edtn_mast c
    where a.comp_code = @pcompcode and a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.unit= @punitcode and 
    a.unit=b.unit and a.unit=c.unit_code and 
    (a.ag_type= @pag_type or @pag_type is null) and (a.ag_class= @pag_class or  @pag_class is null) and 
    (a.state_code= @pstate or  @pstate is null) and (a.dist_code= @pdistcode or  @pdistcode is null) and (a.tehsil_taluka= @ptalukacode or  @ptalukacode is null) and 
    a.agcd=b.agcd and a.dpcd=b.dpcd and b.publ=c.publ and b.edtn=c.edtn and 
    b.edtn=isnull( @pextra1,b.edtn) and c.main_edtn=isnull( @pedtncode,c.main_edtn) and 
    b.supply_type_code= @psup_type and isnull(b.supply_flag,'N')='Y' and 
    isnull(b.base_supply,0)+isnull(b.supply_fri,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_fri,0)<=isnull( @psupply_till,0) and
    (b.route_code= @proute or  @proute is null) and isnull(a.suspend,'N')='N' and upper( @pextra2)='FRI'
    union
    select distinct a.agcd agcd,a.dpcd dpcd from cir_agmast a,cir_supply b,cir_edtn_mast c
    where a.comp_code = @pcompcode and a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.unit= @punitcode and 
    a.unit=b.unit and a.unit=c.unit_code and 
    (a.ag_type= @pag_type or @pag_type is null) and (a.ag_class= @pag_class or  @pag_class is null) and 
    (a.state_code= @pstate or  @pstate is null) and (a.dist_code= @pdistcode or  @pdistcode is null) and (a.tehsil_taluka= @ptalukacode or  @ptalukacode is null) and 
    a.agcd=b.agcd and a.dpcd=b.dpcd and b.publ=c.publ and b.edtn=c.edtn and 
    b.edtn=isnull( @pextra1,b.edtn) and c.main_edtn=isnull( @pedtncode,c.main_edtn) and 
    b.supply_type_code= @psup_type and isnull(b.supply_flag,'N')='Y' and 
    isnull(b.base_supply,0)+isnull(b.supply_sat,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_sat,0)<=isnull( @psupply_till,0) and
    (b.route_code= @proute or  @proute is null) and isnull(a.suspend,'N')='N' and upper( @pextra2)='SAT') z
    order by agcd,dpcd

 DECLARE @vagcd1   VARCHAR(200)  
 DECLARE @vdpcd1   VARCHAR(200)  
		
print(@pspl_type)

OPEN c1 
	fetch NEXT FROM c1 INTO @vagcd1, @vdpcd1 
	WHILE @@FETCH_STATUS = 0
    begin 
    print(@pspl_type)
		IF (@pspl_type = '1' )
		BEGIN 
			IF upper(@pextra2)='SUN' 
			BEGIN
				IF @pcopy_percent_flag = 'C' 
				BEGIN 
					update cir_supply set cir_supply.supply_spl1=isnull(cir_supply.supply_sun,0)+isnull(@pcopy_percent,0)
						where cir_supply.comp_code= @pcompcode and cir_supply.unit= @punitcode and cir_supply.publ= @ppublcode and cir_supply.edtn in(select e.edtn from cir_edtn_mast e 
							where e.comp_code=cir_supply.comp_code and e.unit_code=cir_supply.unit and e.publ=cir_supply.publ and e.main_edtn=isnull(@pedtncode,e.main_edtn)) and
						cir_supply.edtn=isnull(@pextra1,cir_supply.edtn) and 
						cir_supply.supply_type_code= @psup_type and cir_supply.agcd=@vagcd1 and cir_supply.dpcd=@vdpcd1 and isnull(cir_supply.supply_flag,'N')='Y' and 
						(cir_supply.route_code= @proute or @proute is null) and   
						isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_sun,0)>=isnull(@psupply_from,0) and isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_sun,0)<=isnull(@psupply_till,0)
				END
				
				IF (@pcopy_percent_flag = 'P' )
				BEGIN 
					update cir_supply set cir_supply.supply_spl1=isnull(cir_supply.supply_sun,0)+cast(round(isnull(cir_supply.base_supply,0)*(isnull(@pcopy_percent,0)/convert(float,100)),0) as integer)
						where cir_supply.comp_code= @pcompcode and cir_supply.unit=@punitcode and cir_supply.publ= @ppublcode and cir_supply.edtn in(select e.edtn from cir_edtn_mast e 
							where e.comp_code=cir_supply.comp_code and e.unit_code=cir_supply.unit and e.publ=cir_supply.publ and e.main_edtn=isnull(@pedtncode,e.main_edtn)) and 
						cir_supply.edtn=isnull(@pextra1,cir_supply.edtn) and
						cir_supply.supply_type_code= @psup_type and cir_supply.agcd=@vagcd1 and cir_supply.dpcd=@vdpcd1 and isnull(cir_supply.supply_flag,'N')='Y' and 
						(cir_supply.route_code= @proute or @proute is null) and 
						isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_sun,0)>=isnull(@psupply_from,0) and isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_sun,0)<=isnull(@psupply_till,0)
				END
			END

			IF upper(@pextra2)='MON' 
			BEGIN
				IF @pcopy_percent_flag = 'C' 
				BEGIN 
					update cir_supply set cir_supply.supply_spl1=isnull(cir_supply.supply_mon,0)+isnull(@pcopy_percent,0)
						where cir_supply.comp_code= @pcompcode and cir_supply.unit= @punitcode and cir_supply.publ= @ppublcode and cir_supply.edtn in(select e.edtn from cir_edtn_mast e 
							where e.comp_code=cir_supply.comp_code and e.unit_code=cir_supply.unit and e.publ=cir_supply.publ and e.main_edtn=isnull(@pedtncode,e.main_edtn)) and
						cir_supply.edtn=isnull(@pextra1,cir_supply.edtn) and 
						cir_supply.supply_type_code= @psup_type and cir_supply.agcd=@vagcd1 and cir_supply.dpcd=@vdpcd1 and isnull(cir_supply.supply_flag,'N')='Y' and 
						(cir_supply.route_code= @proute or @proute is null) and   
						isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_mon,0)>=isnull(@psupply_from,0) and isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_mon,0)<=isnull(@psupply_till,0)
				END
				
				IF (@pcopy_percent_flag = 'P' )
				BEGIN 
					update cir_supply set cir_supply.supply_spl1=isnull(cir_supply.supply_mon,0)+cast(round(isnull(cir_supply.base_supply,0)*(isnull(@pcopy_percent,0)/convert(float,100)),0) as integer)
						where cir_supply.comp_code= @pcompcode and cir_supply.unit=@punitcode and cir_supply.publ= @ppublcode and cir_supply.edtn in(select e.edtn from cir_edtn_mast e 
							where e.comp_code=cir_supply.comp_code and e.unit_code=cir_supply.unit and e.publ=cir_supply.publ and e.main_edtn=isnull(@pedtncode,e.main_edtn)) and 
						cir_supply.edtn=isnull(@pextra1,cir_supply.edtn) and
						cir_supply.supply_type_code= @psup_type and cir_supply.agcd=@vagcd1 and cir_supply.dpcd=@vdpcd1 and isnull(cir_supply.supply_flag,'N')='Y' and 
						(cir_supply.route_code= @proute or @proute is null) and 
						isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_mon,0)>=isnull(@psupply_from,0) and isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_mon,0)<=isnull(@psupply_till,0)
				END
			END

			IF upper(@pextra2)='TUE' 
			BEGIN
				IF @pcopy_percent_flag = 'C' 
				BEGIN 
					update cir_supply set cir_supply.supply_spl1=isnull(cir_supply.supply_tue,0)+isnull(@pcopy_percent,0)
						where cir_supply.comp_code= @pcompcode and cir_supply.unit= @punitcode and cir_supply.publ= @ppublcode and cir_supply.edtn in(select e.edtn from cir_edtn_mast e 
							where e.comp_code=cir_supply.comp_code and e.unit_code=cir_supply.unit and e.publ=cir_supply.publ and e.main_edtn=isnull(@pedtncode,e.main_edtn)) and
						cir_supply.edtn=isnull(@pextra1,cir_supply.edtn) and 
						cir_supply.supply_type_code= @psup_type and cir_supply.agcd=@vagcd1 and cir_supply.dpcd=@vdpcd1 and isnull(cir_supply.supply_flag,'N')='Y' and 
						(cir_supply.route_code= @proute or @proute is null) and   
						isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_tue,0)>=isnull(@psupply_from,0) and isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_tue,0)<=isnull(@psupply_till,0)
				END
				
				IF (@pcopy_percent_flag = 'P' )
				BEGIN 
					update cir_supply set cir_supply.supply_spl1=isnull(cir_supply.supply_tue,0)+cast(round(isnull(cir_supply.base_supply,0)*(isnull(@pcopy_percent,0)/convert(float,100)),0) as integer)
						where cir_supply.comp_code= @pcompcode and cir_supply.unit=@punitcode and cir_supply.publ= @ppublcode and cir_supply.edtn in(select e.edtn from cir_edtn_mast e 
							where e.comp_code=cir_supply.comp_code and e.unit_code=cir_supply.unit and e.publ=cir_supply.publ and e.main_edtn=isnull(@pedtncode,e.main_edtn)) and 
						cir_supply.edtn=isnull(@pextra1,cir_supply.edtn) and
						cir_supply.supply_type_code= @psup_type and cir_supply.agcd=@vagcd1 and cir_supply.dpcd=@vdpcd1 and isnull(cir_supply.supply_flag,'N')='Y' and 
						(cir_supply.route_code= @proute or @proute is null) and 
						isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_tue,0)>=isnull(@psupply_from,0) and isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_tue,0)<=isnull(@psupply_till,0)
				END
			END

			IF upper(@pextra2)='WED' 
			BEGIN
				IF @pcopy_percent_flag = 'C' 
				BEGIN 
					update cir_supply set cir_supply.supply_spl1=isnull(cir_supply.supply_wed,0)+isnull(@pcopy_percent,0)
						where cir_supply.comp_code= @pcompcode and cir_supply.unit= @punitcode and cir_supply.publ= @ppublcode and cir_supply.edtn in(select e.edtn from cir_edtn_mast e 
							where e.comp_code=cir_supply.comp_code and e.unit_code=cir_supply.unit and e.publ=cir_supply.publ and e.main_edtn=isnull(@pedtncode,e.main_edtn)) and
						cir_supply.edtn=isnull(@pextra1,cir_supply.edtn) and 
						cir_supply.supply_type_code= @psup_type and cir_supply.agcd=@vagcd1 and cir_supply.dpcd=@vdpcd1 and isnull(cir_supply.supply_flag,'N')='Y' and 
						(cir_supply.route_code= @proute or @proute is null) and   
						isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_wed,0)>=isnull(@psupply_from,0) and isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_wed,0)<=isnull(@psupply_till,0)
				END
				
				IF (@pcopy_percent_flag = 'P' )
				BEGIN 
					update cir_supply set cir_supply.supply_spl1=isnull(cir_supply.supply_wed,0)+cast(round(isnull(cir_supply.base_supply,0)*(isnull(@pcopy_percent,0)/convert(float,100)),0) as integer)
						where cir_supply.comp_code= @pcompcode and cir_supply.unit=@punitcode and cir_supply.publ= @ppublcode and cir_supply.edtn in(select e.edtn from cir_edtn_mast e 
							where e.comp_code=cir_supply.comp_code and e.unit_code=cir_supply.unit and e.publ=cir_supply.publ and e.main_edtn=isnull(@pedtncode,e.main_edtn)) and 
						cir_supply.edtn=isnull(@pextra1,cir_supply.edtn) and
						cir_supply.supply_type_code= @psup_type and cir_supply.agcd=@vagcd1 and cir_supply.dpcd=@vdpcd1 and isnull(cir_supply.supply_flag,'N')='Y' and 
						(cir_supply.route_code= @proute or @proute is null) and 
						isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_wed,0)>=isnull(@psupply_from,0) and isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_wed,0)<=isnull(@psupply_till,0)
				END
			END

			IF upper(@pextra2)='THU' 
			BEGIN
				IF @pcopy_percent_flag = 'C' 
				BEGIN 
					update cir_supply set cir_supply.supply_spl1=isnull(cir_supply.supply_thu,0)+isnull(@pcopy_percent,0)
						where cir_supply.comp_code= @pcompcode and cir_supply.unit= @punitcode and cir_supply.publ= @ppublcode and cir_supply.edtn in(select e.edtn from cir_edtn_mast e 
							where e.comp_code=cir_supply.comp_code and e.unit_code=cir_supply.unit and e.publ=cir_supply.publ and e.main_edtn=isnull(@pedtncode,e.main_edtn)) and
						cir_supply.edtn=isnull(@pextra1,cir_supply.edtn) and 
						cir_supply.supply_type_code= @psup_type and cir_supply.agcd=@vagcd1 and cir_supply.dpcd=@vdpcd1 and isnull(cir_supply.supply_flag,'N')='Y' and 
						(cir_supply.route_code= @proute or @proute is null) and   
						isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_thu,0)>=isnull(@psupply_from,0) and isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_thu,0)<=isnull(@psupply_till,0)
				END
				
				IF (@pcopy_percent_flag = 'P' )
				BEGIN 
					update cir_supply set cir_supply.supply_spl1=isnull(cir_supply.supply_thu,0)+cast(round(isnull(cir_supply.base_supply,0)*(isnull(@pcopy_percent,0)/convert(float,100)),0) as integer)
						where cir_supply.comp_code= @pcompcode and cir_supply.unit=@punitcode and cir_supply.publ= @ppublcode and cir_supply.edtn in(select e.edtn from cir_edtn_mast e 
							where e.comp_code=cir_supply.comp_code and e.unit_code=cir_supply.unit and e.publ=cir_supply.publ and e.main_edtn=isnull(@pedtncode,e.main_edtn)) and 
						cir_supply.edtn=isnull(@pextra1,cir_supply.edtn) and
						cir_supply.supply_type_code= @psup_type and cir_supply.agcd=@vagcd1 and cir_supply.dpcd=@vdpcd1 and isnull(cir_supply.supply_flag,'N')='Y' and 
						(cir_supply.route_code= @proute or @proute is null) and 
						isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_thu,0)>=isnull(@psupply_from,0) and isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_thu,0)<=isnull(@psupply_till,0)
				END
			END

			IF upper(@pextra2)='FRI' 
			BEGIN
				IF @pcopy_percent_flag = 'C' 
				BEGIN 
					update cir_supply set cir_supply.supply_spl1=isnull(cir_supply.supply_fri,0)+isnull(@pcopy_percent,0)
						where cir_supply.comp_code= @pcompcode and cir_supply.unit= @punitcode and cir_supply.publ= @ppublcode and cir_supply.edtn in(select e.edtn from cir_edtn_mast e 
							where e.comp_code=cir_supply.comp_code and e.unit_code=cir_supply.unit and e.publ=cir_supply.publ and e.main_edtn=isnull(@pedtncode,e.main_edtn)) and
						cir_supply.edtn=isnull(@pextra1,cir_supply.edtn) and 
						cir_supply.supply_type_code= @psup_type and cir_supply.agcd=@vagcd1 and cir_supply.dpcd=@vdpcd1 and isnull(cir_supply.supply_flag,'N')='Y' and 
						(cir_supply.route_code= @proute or @proute is null) and   
						isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_fri,0)>=isnull(@psupply_from,0) and isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_fri,0)<=isnull(@psupply_till,0)
				END
				
				IF (@pcopy_percent_flag = 'P' )
				BEGIN 
					update cir_supply set cir_supply.supply_spl1=isnull(cir_supply.supply_fri,0)+cast(round(isnull(cir_supply.base_supply,0)*(isnull(@pcopy_percent,0)/convert(float,100)),0) as integer)
						where cir_supply.comp_code= @pcompcode and cir_supply.unit=@punitcode and cir_supply.publ= @ppublcode and cir_supply.edtn in(select e.edtn from cir_edtn_mast e 
							where e.comp_code=cir_supply.comp_code and e.unit_code=cir_supply.unit and e.publ=cir_supply.publ and e.main_edtn=isnull(@pedtncode,e.main_edtn)) and 
						cir_supply.edtn=isnull(@pextra1,cir_supply.edtn) and
						cir_supply.supply_type_code= @psup_type and cir_supply.agcd=@vagcd1 and cir_supply.dpcd=@vdpcd1 and isnull(cir_supply.supply_flag,'N')='Y' and 
						(cir_supply.route_code= @proute or @proute is null) and 
						isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_fri,0)>=isnull(@psupply_from,0) and isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_fri,0)<=isnull(@psupply_till,0)
				END
			END

			IF upper(@pextra2)='SAT' 
			BEGIN
				IF @pcopy_percent_flag = 'C' 
				BEGIN 
					update cir_supply set cir_supply.supply_spl1=isnull(cir_supply.supply_sat,0)+isnull(@pcopy_percent,0)
						where cir_supply.comp_code= @pcompcode and cir_supply.unit= @punitcode and cir_supply.publ= @ppublcode and cir_supply.edtn in(select e.edtn from cir_edtn_mast e 
							where e.comp_code=cir_supply.comp_code and e.unit_code=cir_supply.unit and e.publ=cir_supply.publ and e.main_edtn=isnull(@pedtncode,e.main_edtn)) and
						cir_supply.edtn=isnull(@pextra1,cir_supply.edtn) and 
						cir_supply.supply_type_code= @psup_type and cir_supply.agcd=@vagcd1 and cir_supply.dpcd=@vdpcd1 and isnull(cir_supply.supply_flag,'N')='Y' and 
						(cir_supply.route_code= @proute or @proute is null) and   
						isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_sat,0)>=isnull(@psupply_from,0) and isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_sat,0)<=isnull(@psupply_till,0)
				END
				
				IF (@pcopy_percent_flag = 'P' )
				BEGIN 
					update cir_supply set cir_supply.supply_spl1=isnull(cir_supply.supply_sat,0)+cast(round(isnull(cir_supply.base_supply,0)*(isnull(@pcopy_percent,0)/convert(float,100)),0) as integer)
						where cir_supply.comp_code= @pcompcode and cir_supply.unit=@punitcode and cir_supply.publ= @ppublcode and cir_supply.edtn in(select e.edtn from cir_edtn_mast e 
							where e.comp_code=cir_supply.comp_code and e.unit_code=cir_supply.unit and e.publ=cir_supply.publ and e.main_edtn=isnull(@pedtncode,e.main_edtn)) and 
						cir_supply.edtn=isnull(@pextra1,cir_supply.edtn) and
						cir_supply.supply_type_code= @psup_type and cir_supply.agcd=@vagcd1 and cir_supply.dpcd=@vdpcd1 and isnull(cir_supply.supply_flag,'N')='Y' and 
						(cir_supply.route_code= @proute or @proute is null) and 
						isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_sat,0)>=isnull(@psupply_from,0) and isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_sat,0)<=isnull(@psupply_till,0)
				END
			END

		END
		ELSE--for special supply 2
		BEGIN 
			IF upper(@pextra2)='SUN' 
			BEGIN
				IF @pcopy_percent_flag = 'C' 
				BEGIN 
					update cir_supply set cir_supply.supply_spl2=isnull(cir_supply.supply_sun,0)+isnull(@pcopy_percent,0)
						where cir_supply.comp_code= @pcompcode and cir_supply.unit= @punitcode and cir_supply.publ= @ppublcode and cir_supply.edtn in(select e.edtn from cir_edtn_mast e 
							where e.comp_code=cir_supply.comp_code and e.unit_code=cir_supply.unit and e.publ=cir_supply.publ and e.main_edtn=isnull(@pedtncode,e.main_edtn)) and
						cir_supply.edtn=isnull(@pextra1,cir_supply.edtn) and 
						cir_supply.supply_type_code= @psup_type and cir_supply.agcd=@vagcd1 and cir_supply.dpcd=@vdpcd1 and isnull(cir_supply.supply_flag,'N')='Y' and 
						(cir_supply.route_code= @proute or @proute is null) and   
						isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_sun,0)>=isnull(@psupply_from,0) and isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_sun,0)<=isnull(@psupply_till,0)
				END
				
				IF (@pcopy_percent_flag = 'P' )
				BEGIN 
					update cir_supply set cir_supply.supply_spl2=isnull(cir_supply.supply_sun,0)+cast(round(isnull(cir_supply.base_supply,0)*(isnull(@pcopy_percent,0)/convert(float,100)),0) as integer)
						where cir_supply.comp_code= @pcompcode and cir_supply.unit=@punitcode and cir_supply.publ= @ppublcode and cir_supply.edtn in(select e.edtn from cir_edtn_mast e 
							where e.comp_code=cir_supply.comp_code and e.unit_code=cir_supply.unit and e.publ=cir_supply.publ and e.main_edtn=isnull(@pedtncode,e.main_edtn)) and 
						cir_supply.edtn=isnull(@pextra1,cir_supply.edtn) and
						cir_supply.supply_type_code= @psup_type and cir_supply.agcd=@vagcd1 and cir_supply.dpcd=@vdpcd1 and isnull(cir_supply.supply_flag,'N')='Y' and 
						(cir_supply.route_code= @proute or @proute is null) and 
						isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_sun,0)>=isnull(@psupply_from,0) and isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_sun,0)<=isnull(@psupply_till,0)
				END
			END

			IF upper(@pextra2)='MON' 
			BEGIN
				IF @pcopy_percent_flag = 'C' 
				BEGIN 
					update cir_supply set cir_supply.supply_spl2=isnull(cir_supply.supply_mon,0)+isnull(@pcopy_percent,0)
						where cir_supply.comp_code= @pcompcode and cir_supply.unit= @punitcode and cir_supply.publ= @ppublcode and cir_supply.edtn in(select e.edtn from cir_edtn_mast e 
							where e.comp_code=cir_supply.comp_code and e.unit_code=cir_supply.unit and e.publ=cir_supply.publ and e.main_edtn=isnull(@pedtncode,e.main_edtn)) and
						cir_supply.edtn=isnull(@pextra1,cir_supply.edtn) and 
						cir_supply.supply_type_code= @psup_type and cir_supply.agcd=@vagcd1 and cir_supply.dpcd=@vdpcd1 and isnull(cir_supply.supply_flag,'N')='Y' and 
						(cir_supply.route_code= @proute or @proute is null) and   
						isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_mon,0)>=isnull(@psupply_from,0) and isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_mon,0)<=isnull(@psupply_till,0)
				END
				
				IF (@pcopy_percent_flag = 'P' )
				BEGIN 
					update cir_supply set cir_supply.supply_spl2=isnull(cir_supply.supply_mon,0)+cast(round(isnull(cir_supply.base_supply,0)*(isnull(@pcopy_percent,0)/convert(float,100)),0) as integer)
						where cir_supply.comp_code= @pcompcode and cir_supply.unit=@punitcode and cir_supply.publ= @ppublcode and cir_supply.edtn in(select e.edtn from cir_edtn_mast e 
							where e.comp_code=cir_supply.comp_code and e.unit_code=cir_supply.unit and e.publ=cir_supply.publ and e.main_edtn=isnull(@pedtncode,e.main_edtn)) and 
						cir_supply.edtn=isnull(@pextra1,cir_supply.edtn) and
						cir_supply.supply_type_code= @psup_type and cir_supply.agcd=@vagcd1 and cir_supply.dpcd=@vdpcd1 and isnull(cir_supply.supply_flag,'N')='Y' and 
						(cir_supply.route_code= @proute or @proute is null) and 
						isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_mon,0)>=isnull(@psupply_from,0) and isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_mon,0)<=isnull(@psupply_till,0)
				END
			END

			IF upper(@pextra2)='TUE' 
			BEGIN
				IF @pcopy_percent_flag = 'C' 
				BEGIN 
					update cir_supply set cir_supply.supply_spl2=isnull(cir_supply.supply_tue,0)+isnull(@pcopy_percent,0)
						where cir_supply.comp_code= @pcompcode and cir_supply.unit= @punitcode and cir_supply.publ= @ppublcode and cir_supply.edtn in(select e.edtn from cir_edtn_mast e 
							where e.comp_code=cir_supply.comp_code and e.unit_code=cir_supply.unit and e.publ=cir_supply.publ and e.main_edtn=isnull(@pedtncode,e.main_edtn)) and
						cir_supply.edtn=isnull(@pextra1,cir_supply.edtn) and 
						cir_supply.supply_type_code= @psup_type and cir_supply.agcd=@vagcd1 and cir_supply.dpcd=@vdpcd1 and isnull(cir_supply.supply_flag,'N')='Y' and 
						(cir_supply.route_code= @proute or @proute is null) and   
						isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_tue,0)>=isnull(@psupply_from,0) and isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_tue,0)<=isnull(@psupply_till,0)
				END
				
				IF (@pcopy_percent_flag = 'P' )
				BEGIN 
					update cir_supply set cir_supply.supply_spl2=isnull(cir_supply.supply_tue,0)+cast(round(isnull(cir_supply.base_supply,0)*(isnull(@pcopy_percent,0)/convert(float,100)),0) as integer)
						where cir_supply.comp_code= @pcompcode and cir_supply.unit=@punitcode and cir_supply.publ= @ppublcode and cir_supply.edtn in(select e.edtn from cir_edtn_mast e 
							where e.comp_code=cir_supply.comp_code and e.unit_code=cir_supply.unit and e.publ=cir_supply.publ and e.main_edtn=isnull(@pedtncode,e.main_edtn)) and 
						cir_supply.edtn=isnull(@pextra1,cir_supply.edtn) and
						cir_supply.supply_type_code= @psup_type and cir_supply.agcd=@vagcd1 and cir_supply.dpcd=@vdpcd1 and isnull(cir_supply.supply_flag,'N')='Y' and 
						(cir_supply.route_code= @proute or @proute is null) and 
						isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_tue,0)>=isnull(@psupply_from,0) and isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_tue,0)<=isnull(@psupply_till,0)
				END
			END

			IF upper(@pextra2)='WED' 
			BEGIN
				IF @pcopy_percent_flag = 'C' 
				BEGIN 
					update cir_supply set cir_supply.supply_spl2=isnull(cir_supply.supply_wed,0)+isnull(@pcopy_percent,0)
						where cir_supply.comp_code= @pcompcode and cir_supply.unit= @punitcode and cir_supply.publ= @ppublcode and cir_supply.edtn in(select e.edtn from cir_edtn_mast e 
							where e.comp_code=cir_supply.comp_code and e.unit_code=cir_supply.unit and e.publ=cir_supply.publ and e.main_edtn=isnull(@pedtncode,e.main_edtn)) and
						cir_supply.edtn=isnull(@pextra1,cir_supply.edtn) and 
						cir_supply.supply_type_code= @psup_type and cir_supply.agcd=@vagcd1 and cir_supply.dpcd=@vdpcd1 and isnull(cir_supply.supply_flag,'N')='Y' and 
						(cir_supply.route_code= @proute or @proute is null) and   
						isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_wed,0)>=isnull(@psupply_from,0) and isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_wed,0)<=isnull(@psupply_till,0)
				END
				
				IF (@pcopy_percent_flag = 'P' )
				BEGIN 
					update cir_supply set cir_supply.supply_spl2=isnull(cir_supply.supply_wed,0)+cast(round(isnull(cir_supply.base_supply,0)*(isnull(@pcopy_percent,0)/convert(float,100)),0) as integer)
						where cir_supply.comp_code= @pcompcode and cir_supply.unit=@punitcode and cir_supply.publ= @ppublcode and cir_supply.edtn in(select e.edtn from cir_edtn_mast e 
							where e.comp_code=cir_supply.comp_code and e.unit_code=cir_supply.unit and e.publ=cir_supply.publ and e.main_edtn=isnull(@pedtncode,e.main_edtn)) and 
						cir_supply.edtn=isnull(@pextra1,cir_supply.edtn) and
						cir_supply.supply_type_code= @psup_type and cir_supply.agcd=@vagcd1 and cir_supply.dpcd=@vdpcd1 and isnull(cir_supply.supply_flag,'N')='Y' and 
						(cir_supply.route_code= @proute or @proute is null) and 
						isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_wed,0)>=isnull(@psupply_from,0) and isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_wed,0)<=isnull(@psupply_till,0)
				END
			END

			IF upper(@pextra2)='THU' 
			BEGIN
				IF @pcopy_percent_flag = 'C' 
				BEGIN 
					update cir_supply set cir_supply.supply_spl2=isnull(cir_supply.supply_thu,0)+isnull(@pcopy_percent,0)
						where cir_supply.comp_code= @pcompcode and cir_supply.unit= @punitcode and cir_supply.publ= @ppublcode and cir_supply.edtn in(select e.edtn from cir_edtn_mast e 
							where e.comp_code=cir_supply.comp_code and e.unit_code=cir_supply.unit and e.publ=cir_supply.publ and e.main_edtn=isnull(@pedtncode,e.main_edtn)) and
						cir_supply.edtn=isnull(@pextra1,cir_supply.edtn) and 
						cir_supply.supply_type_code= @psup_type and cir_supply.agcd=@vagcd1 and cir_supply.dpcd=@vdpcd1 and isnull(cir_supply.supply_flag,'N')='Y' and 
						(cir_supply.route_code= @proute or @proute is null) and   
						isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_thu,0)>=isnull(@psupply_from,0) and isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_thu,0)<=isnull(@psupply_till,0)
				END
				
				IF (@pcopy_percent_flag = 'P' )
				BEGIN 
					update cir_supply set cir_supply.supply_spl2=isnull(cir_supply.supply_thu,0)+cast(round(isnull(cir_supply.base_supply,0)*(isnull(@pcopy_percent,0)/convert(float,100)),0) as integer)
						where cir_supply.comp_code= @pcompcode and cir_supply.unit=@punitcode and cir_supply.publ= @ppublcode and cir_supply.edtn in(select e.edtn from cir_edtn_mast e 
							where e.comp_code=cir_supply.comp_code and e.unit_code=cir_supply.unit and e.publ=cir_supply.publ and e.main_edtn=isnull(@pedtncode,e.main_edtn)) and 
						cir_supply.edtn=isnull(@pextra1,cir_supply.edtn) and
						cir_supply.supply_type_code= @psup_type and cir_supply.agcd=@vagcd1 and cir_supply.dpcd=@vdpcd1 and isnull(cir_supply.supply_flag,'N')='Y' and 
						(cir_supply.route_code= @proute or @proute is null) and 
						isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_thu,0)>=isnull(@psupply_from,0) and isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_thu,0)<=isnull(@psupply_till,0)
				END
			END

			IF upper(@pextra2)='FRI' 
			BEGIN
				IF @pcopy_percent_flag = 'C' 
				BEGIN 
					update cir_supply set cir_supply.supply_spl2=isnull(cir_supply.supply_fri,0)+isnull(@pcopy_percent,0)
						where cir_supply.comp_code= @pcompcode and cir_supply.unit= @punitcode and cir_supply.publ= @ppublcode and cir_supply.edtn in(select e.edtn from cir_edtn_mast e 
							where e.comp_code=cir_supply.comp_code and e.unit_code=cir_supply.unit and e.publ=cir_supply.publ and e.main_edtn=isnull(@pedtncode,e.main_edtn)) and
						cir_supply.edtn=isnull(@pextra1,cir_supply.edtn) and 
						cir_supply.supply_type_code= @psup_type and cir_supply.agcd=@vagcd1 and cir_supply.dpcd=@vdpcd1 and isnull(cir_supply.supply_flag,'N')='Y' and 
						(cir_supply.route_code= @proute or @proute is null) and   
						isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_fri,0)>=isnull(@psupply_from,0) and isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_fri,0)<=isnull(@psupply_till,0)
				END
				
				IF (@pcopy_percent_flag = 'P' )
				BEGIN 
					update cir_supply set cir_supply.supply_spl2=isnull(cir_supply.supply_fri,0)+cast(round(isnull(cir_supply.base_supply,0)*(isnull(@pcopy_percent,0)/convert(float,100)),0) as integer)
						where cir_supply.comp_code= @pcompcode and cir_supply.unit=@punitcode and cir_supply.publ= @ppublcode and cir_supply.edtn in(select e.edtn from cir_edtn_mast e 
							where e.comp_code=cir_supply.comp_code and e.unit_code=cir_supply.unit and e.publ=cir_supply.publ and e.main_edtn=isnull(@pedtncode,e.main_edtn)) and 
						cir_supply.edtn=isnull(@pextra1,cir_supply.edtn) and
						cir_supply.supply_type_code= @psup_type and cir_supply.agcd=@vagcd1 and cir_supply.dpcd=@vdpcd1 and isnull(cir_supply.supply_flag,'N')='Y' and 
						(cir_supply.route_code= @proute or @proute is null) and 
						isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_fri,0)>=isnull(@psupply_from,0) and isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_fri,0)<=isnull(@psupply_till,0)
				END
			END

			IF upper(@pextra2)='SAT' 
			BEGIN
				IF @pcopy_percent_flag = 'C' 
				BEGIN 
					update cir_supply set cir_supply.supply_spl2=isnull(cir_supply.supply_sat,0)+isnull(@pcopy_percent,0)
						where cir_supply.comp_code= @pcompcode and cir_supply.unit= @punitcode and cir_supply.publ= @ppublcode and cir_supply.edtn in(select e.edtn from cir_edtn_mast e 
							where e.comp_code=cir_supply.comp_code and e.unit_code=cir_supply.unit and e.publ=cir_supply.publ and e.main_edtn=isnull(@pedtncode,e.main_edtn)) and
						cir_supply.edtn=isnull(@pextra1,cir_supply.edtn) and 
						cir_supply.supply_type_code= @psup_type and cir_supply.agcd=@vagcd1 and cir_supply.dpcd=@vdpcd1 and isnull(cir_supply.supply_flag,'N')='Y' and 
						(cir_supply.route_code= @proute or @proute is null) and   
						isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_sat,0)>=isnull(@psupply_from,0) and isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_sat,0)<=isnull(@psupply_till,0)
				END
				
				IF (@pcopy_percent_flag = 'P' )
				BEGIN 
					update cir_supply set cir_supply.supply_spl2=isnull(cir_supply.supply_sat,0)+cast(round(isnull(cir_supply.base_supply,0)*(isnull(@pcopy_percent,0)/convert(float,100)),0) as integer)
						where cir_supply.comp_code= @pcompcode and cir_supply.unit=@punitcode and cir_supply.publ= @ppublcode and cir_supply.edtn in(select e.edtn from cir_edtn_mast e 
							where e.comp_code=cir_supply.comp_code and e.unit_code=cir_supply.unit and e.publ=cir_supply.publ and e.main_edtn=isnull(@pedtncode,e.main_edtn)) and 
						cir_supply.edtn=isnull(@pextra1,cir_supply.edtn) and
						cir_supply.supply_type_code= @psup_type and cir_supply.agcd=@vagcd1 and cir_supply.dpcd=@vdpcd1 and isnull(cir_supply.supply_flag,'N')='Y' and 
						(cir_supply.route_code= @proute or @proute is null) and 
						isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_sat,0)>=isnull(@psupply_from,0) and isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_sat,0)<=isnull(@psupply_till,0)
				END
			END
		END

		   
		fetch NEXT FROM c1 INTO @vagcd1, @vdpcd1 
		END  
		
		close c1
		
		SELECT Z.COMP_CODE COMP_CODE,Z.UNIT UNIT,Z.PUBL PUBL,Z.EDTN EDTN,Z.EDTN_NAME EDTN_NAME,
             Z.SUPPLY_TYPE_CODE SUPPLY_TYPE_CODE,Z.AGCD AGCD,Z.DPCD,
             Z.AGENCY_NAME AGENCY_NAME,Z.CITY_NAME CITY_NAME,Z.BASE_SUPPLY BASE_SUPPLY,Z.SPECIAL_SUPPLY SPECIAL_SUPPLY,
             Z.ROUTE_SEQ ROUTE_SEQ,Z.SUPPLY_SEQ SUPPLY_SEQ
			 from(select b.comp_code comp_code,b.unit unit,b.publ publ,b.edtn edtn,e.edtn_name edtn_name,
             b.supply_type_code supply_type_code,b.agcd agcd,b.dpcd,
             a.ag_name agency_name,dbo.cir_get_city(a.comp_code,a.city_code) city_name,b.base_supply base_supply,b.supply_spl1 special_supply,
             isnull(c.route_seq,1) route_seq,b.lbl_printno supply_seq 
             from cir_agmast a,cir_supply b,cir_route_mast c ,cir_edtn_mast e
             where a.comp_code= @pcompcode and a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=e.comp_code and a.unit= @punitcode and a.unit=b.unit and a.unit=c.unit and a.unit=e.unit_code and 
                   a.agcd=b.agcd and a.dpcd=b.dpcd and
                   b.publ= @ppublcode and b.publ=e.publ and b.edtn=e.edtn and b.edtn=isnull(@pextra1,b.edtn) and e.main_edtn=isnull( @pedtncode,e.main_edtn) and b.supply_type_code= @psup_type and isnull(b.supply_flag,'N')='Y' and
                   b.route_code=c.route_code and (b.route_code= @proute or @proute is null) and 
                   isnull(a.suspend,'N')='N' and (a.ag_type= @pag_type or @pag_type is null) and (a.ag_class= @pag_class or  @pag_class is null) and 
                   (a.state_code= @pstate or @pstate is null) and (a.dist_code= @pdistcode or  @pdistcode is null) and (a.tehsil_taluka= @ptalukacode or  @ptalukacode is null) and 
                   isnull(b.supply_spl1,0)>0 and @pspl_type='1' and 
                   ((isnull(b.base_supply,0)+isnull(b.supply_sun,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_sun,0)<=isnull( @psupply_till,0) and upper( @pextra2)='SUN') or
                    (isnull(b.base_supply,0)+isnull(b.supply_mon,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_mon,0)<=isnull( @psupply_till,0) and upper( @pextra2)='MON') or
                    (isnull(b.base_supply,0)+isnull(b.supply_tue,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_tue,0)<=isnull( @psupply_till,0) and upper( @pextra2)='TUE') or
                    (isnull(b.base_supply,0)+isnull(b.supply_wed,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_wed,0)<=isnull( @psupply_till,0) and upper( @pextra2)='WED') or
                    (isnull(b.base_supply,0)+isnull(b.supply_thu,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_thu,0)<=isnull( @psupply_till,0) and upper( @pextra2)='THU') or
                    (isnull(b.base_supply,0)+isnull(b.supply_fri,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_fri,0)<=isnull( @psupply_till,0) and upper( @pextra2)='FRI') or
                    (isnull(b.base_supply,0)+isnull(b.supply_sat,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_sat,0)<=isnull( @psupply_till,0) and upper( @pextra2)='SAT'))
             union
             select b.comp_code comp_code,b.unit unit,b.publ publ,b.edtn edtn,e.edtn_name edtn_name,
             b.supply_type_code supply_type_code,b.agcd agcd,b.dpcd,
             a.ag_name agency_name,dbo.cir_get_city(a.comp_code,a.city_code) city_name,b.base_supply base_supply,b.supply_spl2 special_supply,
             isnull(c.route_seq,1) route_seq,b.lbl_printno supply_seq 
             from cir_agmast a,cir_supply b ,cir_route_mast c ,cir_edtn_mast e
             where a.comp_code= @pcompcode and a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=e.comp_code and a.unit= @punitcode and a.unit=b.unit and a.unit=c.unit and a.unit=e.unit_code and 
                   a.agcd=b.agcd and a.dpcd=b.dpcd and
                   b.publ= @ppublcode and b.publ=e.publ and b.edtn=e.edtn and b.edtn=isnull( @pextra1,b.edtn) and e.main_edtn=isnull( @pedtncode,e.main_edtn) and b.supply_type_code= @psup_type and isnull(b.supply_flag,'N')='Y' and
                   b.route_code=c.route_code and (b.route_code= @proute or  @proute is null) and 
                   isnull(a.suspend,'N')='N' and (a.ag_type= @pag_type or  @pag_type is null) and (a.ag_class= @pag_class or  @pag_class is null) and 
                   (a.state_code= @pstate or  @pstate is null) and (a.dist_code= @pdistcode or  @pdistcode is null) and (a.tehsil_taluka= @ptalukacode or  @ptalukacode is null) and 
                   isnull(b.supply_spl2,0)>0 and @pspl_type='2' and
                   ((isnull(b.base_supply,0)+isnull(b.supply_sun,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_sun,0)<=isnull( @psupply_till,0) and upper( @pextra2)='SUN') or
                    (isnull(b.base_supply,0)+isnull(b.supply_mon,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_mon,0)<=isnull( @psupply_till,0) and upper( @pextra2)='MON') or
                    (isnull(b.base_supply,0)+isnull(b.supply_tue,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_tue,0)<=isnull( @psupply_till,0) and upper( @pextra2)='TUE') or
                    (isnull(b.base_supply,0)+isnull(b.supply_wed,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_wed,0)<=isnull( @psupply_till,0) and upper( @pextra2)='WED') or
                    (isnull(b.base_supply,0)+isnull(b.supply_thu,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_thu,0)<=isnull( @psupply_till,0) and upper( @pextra2)='THU') or
                    (isnull(b.base_supply,0)+isnull(b.supply_fri,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_fri,0)<=isnull( @psupply_till,0) and upper( @pextra2)='FRI') or
                    (isnull(b.base_supply,0)+isnull(b.supply_sat,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_sat,0)<=isnull( @psupply_till,0) and upper( @pextra2)='SAT'))) z
             order by route_seq,supply_seq,edtn_name,city_name,agency_name
		
 DEALLOCATE c1






ALTER PROCEDURE [dbo].[cir_special_supply_upd_cir_special_supply_view_p]
	@pcompcode                                VARCHAR(20) ,
	@punitcode                                VARCHAR(20) ,
	@ppublcode                                VARCHAR(20) ,
	@pedtncode                                VARCHAR(20) ,
	@psup_type                                VARCHAR(20) ,
	@pag_type                                 VARCHAR(20) ,
	@pag_class                                VARCHAR(20) ,
	@pdistcode                                VARCHAR(20) ,
	@ptalukacode                              VARCHAR(20) ,
	@pusercode                                VARCHAR(20) ,
	@pspl_type                                VARCHAR(20) ,
	@psupply_from                             VARCHAR(20),  ---       SEND IN VARCHAR FROM SQL CLASS
	@psupply_till                             VARCHAR(20) ,   ---       SEND IN VARCHAR FROM SQL CLASS
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,------for edition code------
	@pextra2                                  VARCHAR(4000),------for particuler day-----
	@pstate									  VARCHAR(20) ,
    @proute									  VARCHAR(20) ,
    @pextra3								  VARCHAR(4000),
    @pextra4								  VARCHAR(4000),
    @pextra5								  VARCHAR(4000)
AS 


	
		SELECT Z.COMP_CODE COMP_CODE,Z.UNIT UNIT,Z.PUBL PUBL,Z.EDTN EDTN,Z.EDTN_NAME EDTN_NAME,
             Z.SUPPLY_TYPE_CODE SUPPLY_TYPE_CODE,Z.AGCD AGCD,Z.DPCD,
             Z.AGENCY_NAME AGENCY_NAME,Z.CITY_NAME CITY_NAME,Z.BASE_SUPPLY BASE_SUPPLY,Z.SPECIAL_SUPPLY SPECIAL_SUPPLY,
             Z.ROUTE_SEQ ROUTE_SEQ,Z.SUPPLY_SEQ SUPPLY_SEQ
			 from(select b.comp_code comp_code,b.unit unit,b.publ publ,b.edtn edtn,e.edtn_name edtn_name,
             b.supply_type_code supply_type_code,b.agcd agcd,b.dpcd,
             a.ag_name agency_name,dbo.cir_get_city(a.comp_code,a.city_code) city_name,b.base_supply base_supply,b.supply_spl1 special_supply,
             isnull(c.route_seq,1) route_seq,b.lbl_printno supply_seq 
             from cir_agmast a,cir_supply b,cir_route_mast c ,cir_edtn_mast e
             where a.comp_code= @pcompcode and a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=e.comp_code and a.unit= @punitcode and a.unit=b.unit and a.unit=c.unit and a.unit=e.unit_code and 
                   a.agcd=b.agcd and a.dpcd=b.dpcd and
                   b.publ= @ppublcode and b.publ=e.publ and b.edtn=e.edtn and b.edtn=isnull(@pextra1,b.edtn) and e.main_edtn=isnull( @pedtncode,e.main_edtn) and b.supply_type_code= @psup_type and isnull(b.supply_flag,'N')='Y' and
                   b.route_code=c.route_code and (b.route_code= @proute or @proute is null) and 
                   isnull(a.suspend,'N')='N' and (a.ag_type= @pag_type or @pag_type is null) and (a.ag_class= @pag_class or  @pag_class is null) and 
                   (a.state_code= @pstate or @pstate is null) and (a.dist_code= @pdistcode or  @pdistcode is null) and (a.tehsil_taluka= @ptalukacode or  @ptalukacode is null) and 
                   isnull(b.supply_spl1,0)>0 and @pspl_type='1' and 
                   ((isnull(b.base_supply,0)+isnull(b.supply_sun,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_sun,0)<=isnull( @psupply_till,0) and upper( @pextra2)='SUN') or
                    (isnull(b.base_supply,0)+isnull(b.supply_mon,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_mon,0)<=isnull( @psupply_till,0) and upper( @pextra2)='MON') or
                    (isnull(b.base_supply,0)+isnull(b.supply_tue,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_tue,0)<=isnull( @psupply_till,0) and upper( @pextra2)='TUE') or
                    (isnull(b.base_supply,0)+isnull(b.supply_wed,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_wed,0)<=isnull( @psupply_till,0) and upper( @pextra2)='WED') or
                    (isnull(b.base_supply,0)+isnull(b.supply_thu,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_thu,0)<=isnull( @psupply_till,0) and upper( @pextra2)='THU') or
                    (isnull(b.base_supply,0)+isnull(b.supply_fri,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_fri,0)<=isnull( @psupply_till,0) and upper( @pextra2)='FRI') or
                    (isnull(b.base_supply,0)+isnull(b.supply_sat,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_sat,0)<=isnull( @psupply_till,0) and upper( @pextra2)='SAT'))
             union
             select b.comp_code comp_code,b.unit unit,b.publ publ,b.edtn edtn,e.edtn_name edtn_name,
             b.supply_type_code supply_type_code,b.agcd agcd,b.dpcd,
             a.ag_name agency_name,dbo.cir_get_city(a.comp_code,a.city_code) city_name,b.base_supply base_supply,b.supply_spl2 special_supply,
             isnull(c.route_seq,1) route_seq,b.lbl_printno supply_seq 
             from cir_agmast a,cir_supply b ,cir_route_mast c ,cir_edtn_mast e
             where a.comp_code= @pcompcode and a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=e.comp_code and a.unit= @punitcode and a.unit=b.unit and a.unit=c.unit and a.unit=e.unit_code and 
                   a.agcd=b.agcd and a.dpcd=b.dpcd and
                   b.publ= @ppublcode and b.publ=e.publ and b.edtn=e.edtn and b.edtn=isnull( @pextra1,b.edtn) and e.main_edtn=isnull( @pedtncode,e.main_edtn) and b.supply_type_code= @psup_type and isnull(b.supply_flag,'N')='Y' and
                   b.route_code=c.route_code and (b.route_code= @proute or  @proute is null) and 
                   isnull(a.suspend,'N')='N' and (a.ag_type= @pag_type or  @pag_type is null) and (a.ag_class= @pag_class or  @pag_class is null) and 
                   (a.state_code= @pstate or  @pstate is null) and (a.dist_code= @pdistcode or  @pdistcode is null) and (a.tehsil_taluka= @ptalukacode or  @ptalukacode is null) and 
                   isnull(b.supply_spl2,0)>0 and @pspl_type='2' and
                   ((isnull(b.base_supply,0)+isnull(b.supply_sun,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_sun,0)<=isnull( @psupply_till,0) and upper( @pextra2)='SUN') or
                    (isnull(b.base_supply,0)+isnull(b.supply_mon,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_mon,0)<=isnull( @psupply_till,0) and upper( @pextra2)='MON') or
                    (isnull(b.base_supply,0)+isnull(b.supply_tue,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_tue,0)<=isnull( @psupply_till,0) and upper( @pextra2)='TUE') or
                    (isnull(b.base_supply,0)+isnull(b.supply_wed,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_wed,0)<=isnull( @psupply_till,0) and upper( @pextra2)='WED') or
                    (isnull(b.base_supply,0)+isnull(b.supply_thu,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_thu,0)<=isnull( @psupply_till,0) and upper( @pextra2)='THU') or
                    (isnull(b.base_supply,0)+isnull(b.supply_fri,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_fri,0)<=isnull( @psupply_till,0) and upper( @pextra2)='FRI') or
                    (isnull(b.base_supply,0)+isnull(b.supply_sat,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_sat,0)<=isnull( @psupply_till,0) and upper( @pextra2)='SAT'))) z
             order by route_seq,supply_seq,edtn_name,city_name,agency_name






ALTER procedure [dbo].[cir_fin_year_bind_p]
     @pcomp_code     as varchar(20),
     @punit_code     as varchar(20),
     @puserid        as varchar(20),
     @pdateformat    as varchar(20),
     @pextra1        as varchar(20),
     @pextra2        as varchar(20) as
  Begin
    
     select COMP_CODE, FINYEAR_CODE, FINYEAR_FROM, FINYEAR_TO, FINYEAR_DESC, FINYEAR_ALIAS, FINYEAR_LOCK_STATUS, FINYEAR_LOCK_REMARK 
		from fa_fin_year_mast
        where comp_code=@pcomp_code order by finyear_from
  End


ALTER PROCEDURE [dbo].[cir_interest_process]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@ppubl_code                               VARCHAR(20) ,
	@pfrom_date                                 VARCHAR(20) ,
	@pto_date                                 VARCHAR(20) ,
	@pagcd                                    VARCHAR(20) ,
	@pdpcd                                    VARCHAR(20) ,
	@pint_rate                                FLOAT ,
	@ptds_rate                                FLOAT ,
	@ptds_limit                               FLOAT ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS 
	
		
		DECLARE @v_cnt                                    FLOAT                           
		SET @v_cnt = 0 
		DECLARE @v_findt                                  DATETIME 
		DECLARE @v_from_date                              DATETIME 
		DECLARE @v_to_date                                DATETIME 
		DECLARE @v_userid                                 VARCHAR(10) 




        DECLARE  @vcomp_code1      VARCHAR(100)  
        DECLARE  @vunit1      VARCHAR(100) 
        DECLARE  @vagcd1      VARCHAR(100) 
        DECLARE  @vdpcd1      VARCHAR(100) 	

        
        DECLARE  @vrecptdt1     DATETIME 	
        DECLARE  @vgamt1        FLOAT 	





		DECLARE c_agency cursor LOCAL FOR
 
		SELECT DISTINCT comp_code, unit, agcd, dpcd
		FROM  cIr_agmast WHERE	 comp_code  = @pcomp_code AND	(unit  = @punit_code OR	@punit_code  is null) AND	(agcd  = @pagcd
		OR	@pagcd  is null) AND	(dpcd  = @pdpcd OR	@pdpcd  is null)
		ORDER BY unit, agcd, dpcd 
		
		

   --     DECLARE @v_agency                                 VARCHAR(200)  

		

    
		
		

   --     DECLARE @v1                                       VARCHAR(200)  
		DECLARE @v_opbal                                  NUMERIC(15,2)                   
		SET @v_opbal = 0 
		DECLARE @v_opdt                                   DATETIME 
		DECLARE @v_amt                                    NUMERIC(15,4)                   
		SET @v_amt = 0 
		DECLARE @v_bal                                    NUMERIC(15,4)                   
		SET @v_bal = 0 
		DECLARE @v_days                                   FLOAT 
		DECLARE @v_rate                                   FLOAT                           
		SET @v_rate = @pint_rate / 100 
		DECLARE @v_int_amt                                NUMERIC(15,4)                   
		SET @v_int_amt = 0 


		DECLARE @v_frdt                                   DATETIME 
		DECLARE @v_todt                                   DATETIME 

  /*******************        send converted date from sql class       ****************/

		--SET @v_from_date  =cast(@pfrom_date as varchar(20))
		--SET @v_to_date  =  cast(@pto_date as varchar(20))


   /************************************************************************************/


		SET @v_findt  = DBO.cir_get_finandt( '', @v_from_date, @pdateformat, '', '')

print(@v_findt)
      
	

		OPEN c_agency 

          --   print('1')
		     fetch NEXT FROM c_agency INTO @vcomp_code1 , @vunit1 , @vagcd1,  @vdpcd1   
		     WHILE @@FETCH_STATUS = 0

             begin 
			
 -- print('2')
								DELETE FROM   cir_interest_cal    WHERE  comp_code  = @vcomp_code1 AND	unit_code  = @vunit1 AND	agcd  = @vagcd1
								AND	dpcd  = @vdpcd1 AND	(publ_code  = @ppubl_code OR	@ppubl_code  is null)AND	frdt  between @v_findt  and  @v_to_date AND	ISNULL(post_flag, 'N')  = 'N' 
								
								SELECT @v_cnt  =  COUNT(*) FROM  cir_interest_cal 	WHERE	 comp_code  = @vcomp_code1 AND	unit_code  = @vunit1 AND	agcd  = @vagcd1
								AND	(publ_code  = @ppubl_code OR	@ppubl_code  is null) AND	frdt  between @v_findt  and  @v_to_date AND	ISNULL(post_flag, 'N')  = 'N'
						 print(@v_cnt)
								IF ISNULL(@v_cnt, 0)= 0 
								BEGIN 

                                        --       print('3')
													SET @v_opbal  = DBO.cir_accounts_cir_agency_opbal(@vcomp_code1, @vunit1, @ppubl_code,  @vagcd1, @vdpcd1, @v_findt, 'SC', @pdateformat, '', '')+ DBO.cir_accounts_cir_agency_ytodt( @vcomp_code1, @vunit1, @ppubl_code,  @vagcd1, @vdpcd1, @v_from_date, @v_to_date, 'SC', @pdateformat, '', '')
													SET @v_opdt  = @v_findt 
										
							--		 print(@vcomp_code1)
                            --            print(@vunit1 )
                            --         print(@v_from_date)
                            --          print(@v_to_date)
                            --           print(@vagcd1)
 -- print(@vdpcd1)


												    DECLARE c1 cursor LOCAL FOR 


													SELECT recptdt, SUM(CONVERT(FLOAT, amount)) gamt FROM  cir_rcphdr 
													WHERE	 comp_code  = @vcomp_code1 AND	unit_code  = @vunit1 AND	recptdt  between @v_from_date  and  @v_to_date
													AND	agcd  = @vagcd1 AND	dpcd  = @vdpcd1 AND	achd  = 'SC' AND	(publ  = @ppubl_code OR	@ppubl_code  is null)
													AND	ISNULL(amount, 0)  <> 0 AND	status  is null
													GROUP BY  recptdt ORDER BY recptdt 



                									OPEN c1 
                                                   print('31')
														  fetch NEXT FROM c1 INTO @vrecptdt1 ,@vgamt1  
               --     print(@vrecptdt1)
                --   print(@vgamt1)
														  WHILE (@@FETCH_STATUS = 0)
												
														  begin 
													
  --  print('4')
																SET @v_bal  = ISNULL(@v_bal, 0)+ ISNULL(@v_amt, 0)+ ISNULL(@v_opbal, 0)
				            									SET @v_frdt  = @v_opdt 
				            									SET @v_todt  = @vrecptdt1 - 1 
																SET @v_days  = CONVERT(INT, @v_todt) - CONVERT(INT, @v_frdt) + 1 
				            									SET @v_int_amt  = ( @v_bal * @v_rate * @v_days ) / 365 
																IF ISNULL(@v_int_amt, 0)<> 0 and ISNULL(@v_days, 0)> 0 
				                    									BEGIN 
																			  INSERT INTO  cir_interest_cal    
						  													  ( comp_code , unit_code , publ_code , agcd , dpcd , frdt , todt , todt_bal , 
																			  intt_days , intt_rate , intt_amt , tds_rate , tds_limit , created_dt )
                                                                              values(@vcomp_code1,@vunit1,'P01',@vagcd1,@vdpcd1,@v_frdt,
                                                                              @v_todt,@v_bal,@v_days,@pint_rate,@v_int_amt,@ptds_rate,@ptds_limit,getdate());  
														
																			  SET @v_cnt  = ISNULL(@v_cnt, 0)+ 1 
				                    									END
								   
																		SET @v_opbal  = 0 
																		SET @v_opdt  =  @vrecptdt1
																		SET @v_amt  =   @vgamt1 
																		SET @v_days  = 0 
																		SET @v_int_amt  = 0 
										
															fetch NEXT FROM c1 INTO @vrecptdt1 ,@vgamt1
															END  
										
										
												 --   close c1



			    										   IF @v_todt <> @v_to_date and ( ISNULL(@v_bal, 0)+ ISNULL(@v_amt, 0)) <> 0 
														   BEGIN 
													
													 print('5')
																	SET @v_bal  = ISNULL(@v_bal, 0)+ ISNULL(@v_amt, 0)
																	SET @v_frdt  = @v_opdt 
																	SET @v_todt  = @v_to_date 
																	SET @v_days  = CONVERT(INT, @v_todt) - CONVERT(INT, @v_frdt) + 1 
																	SET @v_int_amt  = ( @v_bal * @v_rate * @v_days ) / 365 
				                									IF (ISNULL(@v_int_amt, 0)<> 0 and ISNULL(@v_days, 0)> 0) 
																	BEGIN 
					                										  INSERT INTO  cir_interest_cal    ( comp_code , unit_code , publ_code , agcd , dpcd , 
																			  frdt , todt , todt_bal , intt_days , intt_rate , intt_amt , tds_rate , tds_limit , created_dt )
                                                                              values(@vcomp_code1,@vunit1,'P01',@vagcd1,@vdpcd1,@v_frdt,@v_todt,
                                                                              @v_bal,@v_days,@pint_rate,@v_int_amt,@ptds_rate,@ptds_limit,getdate());  
															
																			  SET @v_cnt  = ISNULL(@v_cnt, 0)+ 1 
																	END
								   
														   END
								   
												
												close c1
                                               
                                                deallocate c1
												
--print(@v_cnt)
--print(@v_opbal)

												IF ISNULL(@v_cnt, 0)= 0 and ISNULL(@v_opbal, 0)<> 0 
												BEGIN 
													---if opening but no any transaction
													-- print('6')
															SET @v_bal  = ISNULL(@v_opbal, 0)
															SET @v_frdt  = @v_opdt 
															SET @v_todt  = @v_to_date 
															SET @v_days  = CONVERT(INT, @v_todt) - CONVERT(INT, @v_frdt) + 1 
															SET @v_int_amt  = ( @v_bal * @v_rate * @v_days ) / 365 
															INSERT INTO  cir_interest_cal    ( comp_code , unit_code , publ_code , agcd , dpcd , frdt , 
															todt , todt_bal , intt_days , intt_rate , intt_amt , tds_rate , tds_limit , created_dt ) 
                                                            values(@vcomp_code1,@vunit1,'P01',@vagcd1,@vdpcd1,@v_frdt,@v_todt,
                                                            @v_bal,@v_days,@pint_rate,@v_int_amt,@ptds_rate,@ptds_limit,getdate()); 
													
												END
   
			                END
   
							SET @v_cnt  = 0 
							SET @v_opbal  = 0 
							SET @v_opdt  = null 
							SET @v_bal  = 0 
							SET @v_amt  = 0 
							SET @v_days  = 0 
							SET @v_int_amt  = 0 
							SET @v_frdt  = null 
							SET @v_todt  = null 
						
		   END 
		
		
		   close c_agency
		
		
		-- IMPLICIT_TRANSACTIONS is set to OFF
 DEALLOCATE c_agency
 --DEALLOCATE c1






ALTER PROCEDURE [dbo].[Cir_Gen_Code_subroutecode_P]
	@pcompcode                                VARCHAR(20) ,
	@punitcode                                VARCHAR(20) ,
	@prtcode                                  VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS 

		DECLARE @vno                                      NUMERIC(8) 
		DECLARE @vsubrt_code                              VARCHAR(15) 
        DECLARE @v_sess_id                                NUMERIC(20) 

		set @v_sess_id=(SELECT top 1 session_id  FROM sys.dm_exec_requests where sql_handle is not null);
	
		SELECT @vno  =  MAX(SUBSTRING(subrt_code, 3, 5)) + 1
		FROM  cir_sub_route_mast 
		WHERE	 comp_code  = @pcompcode
		 AND	unit  = @punitcode
		 AND	route_code  = @prtcode
		

		
		IF ISNULL(@vno, 0)= 0 
		BEGIN 
			SET @vsubrt_code  = 'SR' + '001' 
		END
		ELSE
		BEGIN 
			SET @vsubrt_code  = 'SR' + dbo.fnPadLeft('0',3,@vno)  
		END
	
		SELECT @vsubrt_code as VAR_CODE




ALTER PROCEDURE [dbo].[cir_edtion_bind_cir_edtion_bind_p1]

	@pcomp_code                               VARCHAR(20) ,
	@ppubl_code                               VARCHAR(20) ,
	@pedtn_code                               VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000)
AS 
	
		SELECT *
		FROM  cir_edtn_mast 
		WHERE	 comp_code  = @pcomp_code
		 AND	publ  = @ppubl_code
		 AND	(edtn  = @pedtn_code
		 OR	@pedtn_code  is null or @pedtn_code='')
		 AND	ISNULL(freeze_flag, 'N')  = 'N'
and (unit_code=@pextra2 or @pextra2 is null or @pextra2='')
		ORDER BY edtn_name 
		





ALTER PROCEDURE [dbo].[cir_execute_doctype_grid](

    @loginid            as varchar(50)    
  ) as
    
begin    
   
    select * from CIR_DOCTYP_PERMISSION where (USER_ID=@loginid OR @loginid IS NULL);
    
    
    select  "Branch_Code","Branch_Name" from branch_mst order by  "Branch_Name";
    
   
    select  "Comp_Code","Comp_Name" from comp_mst order by "Comp_Name";
    
   
    select  "doc_type","doc_Name" from fa_docmst where "doc_type" in ('RCR','DN','CN') order by "doc_Name";  
select MAX(INSERT_ID) INSERT_ID from CIR_DOCTYP_PERMISSION where (USER_ID=@loginid OR @loginid IS NULL);
end



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER PROCEDURE [dbo].[cir_branch_received_p1]
	@pcompcode                                VARCHAR(20) ,
	@punitcode                                VARCHAR(20) ,
	@pbranchcode                              VARCHAR(20) ,
	@pfrombranch                              VARCHAR(20) ,
	@pdoctypeout                              VARCHAR(20) ,
	@pdoctypein                               VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS 
	
		/*SELECT DISTINCT
				 comp_code COMP_CODE,
				 unit_code UNIT_CODE,
				 branch_code OTH_BRANCH,
				 recptno REF_RECPTNO,
				 recptdt  REF_RECPTDT
		FROM  cir_branch_return_det 
		WHERE	 comp_code  = @pcompcode
		 AND	unit_code  = @punitcode
		 AND	branch_code  = @pfrombranch
		 AND	oth_branch_code  = @pbranchcode
		 AND	doctype  = @pdoctypeout
		 AND	recptno + recptdt  not in
			(
		 	SELECT CAST(branch_refno AS VARCHAR) + CAST(branch_refdt AS VARCHAR)
			FROM  cir_branch_return_hdr 
			WHERE	 comp_code  = @pcompcode
			 AND	unit_code  = @punitcode
			 AND	doctype  = @pdoctypein
			)
		ORDER BY comp_code,
			 unit_code,
			 recptdt,
			 recptno */


       select distinct H.COMP_CODE COMP_CODE,H.UNIT_CODE UNIT_CODE,D.BRANCH_CODE BRANCH_CODE,D.OTH_BRANCH_CODE OTH_BRANCH,
        D.RECPTNO REF_RECPTNO,D.RECPTDT REF_RECPTDT,H.TAXI_ROUTE_NAME, H.TAXI_NO
        from cir_branch_return_det d,cir_branch_return_hdr h 
        where h.comp_code=@pcompcode and h.comp_code=d.comp_code and h.unit_code=@punitcode and h.unit_code=d.unit_code and 
        h.doctype=d.doctype and h.recptno=d.recptno and d.branch_code=@pfrombranch and 
        d.oth_branch_code=@pbranchcode and d.doctype=@pdoctypeout and d.recptno+d.recptdt not in(select branch_refno+branch_refdt from cir_branch_return_hdr 
        where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctypein)
        order by comp_code,unit_code,ref_recptdt,ref_recptno;

/***********************for issue 5118*****************************/
/******** laxman sir***********************/
                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE cir_rep_billing_cir_billno_list_p
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@ppubl                                    VARCHAR(20) ,
	@pbillagcd                                VARCHAR(20) ,
	@pbilldpcd                                VARCHAR(20) ,
	@pbill_freq                               VARCHAR(20) ,
	@pfrom_billdt                             VARCHAR(20) ,
	@ptill_billdt                             VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS 
		
	DECLARE @v_bill_frdt                              DATETIME 
	DECLARE @v_bill_todt                              DATETIME 
	SET @v_bill_frdt  = DBO.CONVERT_USER_DATE('/', @pfrom_billdt,@pdateformat)
	SET @v_bill_todt  = DBO.CONVERT_USER_DATE('/', @ptill_billdt,@pdateformat)
		
	SELECT MIN(billno) MIN_BILLNO, MAX(billno) MAX_BILLNO
	FROM  cir_bill 
	WHERE comp_code  = @pcomp_code AND unit_code  = @punit_code
	 AND billdt  between @v_bill_frdt  and  @v_bill_todt
	 AND (publ  = @ppubl OR @ppubl  is null OR @ppubl = '')
	 AND (agcd  = @pbillagcd OR @pbillagcd  is null OR @pbillagcd  = '')
	 AND (dpcd  = @pbilldpcd OR @pbilldpcd  is null OR @pbilldpcd  = '')
	 AND (bill_flag  = @pbill_freq OR @pbill_freq  is null OR @pbill_freq  = '')
                                                                     
                                                                     
                                                                     
                                             
ALTER FUNCTION  cir_get_state(@pcomp_code as varchar(100),@pcount_code as varchar(100),@pstate_code as varchar(100))  returns varchar(200) 
AS  
BEGIN 
DECLARE @vstate_name VARCHAR(4000)
select @vstate_name=State_Name FROM state_mst where Comp_Code=@pcomp_code and Country_Code=@pcount_code and State_Code=@pstate_code
	   
RETURN isnull(@vstate_name,'NA')
END

                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE cir_rep_billing_cir_bill_register_p
	@pcomp_code			VARCHAR(20) ,
	@punit_code         VARCHAR(20) ,
	@ppubl              VARCHAR(20) ,
	@repty              VARCHAR(20) ,
	@pbill_freq         VARCHAR(20) ,
	@pfrom_billdt       VARCHAR(20) ,
	@ptill_billdt       VARCHAR(20) ,
	@pbillagcd          VARCHAR(20) ,
	@pbilldpcd          VARCHAR(20) ,
	@pdateformat        VARCHAR(20) ,
	@pextra1            VARCHAR(400) ,
	@pextra2            VARCHAR(400) 
AS 
select getdate()

	DECLARE @vfrdt			DATETIME 
	DECLARE @vtodt			DATETIME 
	declare @v_statecode	VARCHAR(20)
	declare @v_distcode		VARCHAR(20)
	declare @v_citycode		VARCHAR(20)
	declare @v_taluka		VARCHAR(20)

	SET @vfrdt  = dbo.convert_user_date('/', @pfrom_billdt,@pdateformat)
	SET @vtodt  = dbo.convert_user_date('/', @ptill_billdt,@pdateformat)
	If @repty='1' Begin--State
        set @v_statecode=@pextra1
	End
    Else if @repty='2' Begin    --District
        set @v_distcode=@pextra1
    End
    Else if @repty='3' Begin    --Taluka
        set @v_taluka=@pextra1
    End
    Else Begin--City
        set @v_citycode=@pextra1
	End
   
	IF ISNULL(@repty, 'N')= '1' BEGIN --FOR STATE
		select b.comp_code AS "COMP_CODE", b.unit_code AS "UNIT_CODE", b.billno AS "BILLNO", b.billdt AS "BILLDT", b.agcd AS "AGCD", b.dpcd AS "DPCD", 
		min(b.publ) AS "PUBL", sum(b.bill_copy) AS "BILL_COPY", sum(b.gross_amount) AS "GROSS_AMOUNT", sum(b.sur_amt) AS "SUR_AMOUNT", sum(b.comm_amt) AS "COMM_AMOUNT",
		sum(b.bill_amount) AS "BILL_AMOUNT",max(b.bill_flag) AS "BILL_FLAG",null as  "BILL_REMARK", max(b.userid) AS "USERID", max(b.creation_date) AS "CREATION_DATE", 
		b.branch_code AS "BRANCH_CODE",m.ag_name AS "AGENCY_NAME",DBO.cir_get_city(b.comp_code,m.city_code) as "CITY NAME" ,
		DBO.cir_get_state(b.comp_code, m.country_code, m.state_code) as "STATE_NAME"
		from cir_bill_det b,cir_agmast m
		where b.comp_code = @pcomp_code and m.comp_code=b.comp_code and (b.unit_code = isnull(@punit_code,b.unit_code) OR @punit_code='') and 
		m.unit=b.unit_code and (b.agcd = isnull(@pbillagcd,b.agcd) OR @pbillagcd='') and m.agcd=b.agcd and (b.dpcd = isnull(@pbilldpcd,b.dpcd) OR @pbilldpcd='') and  
		m.dpcd=b.dpcd and b.billdt >= @vfrdt and billdt <=@vtodt and (b.bill_flag = isnull(@pbill_freq,b.bill_flag) OR @pbill_freq='') and 
		(b.publ = isnull(@ppubl,b.publ) OR @ppubl='') and (m.state_code=@v_statecode or @v_statecode is null OR @v_statecode='') and (m.dist_code=@v_distcode or @v_distcode is null OR @v_distcode='') and 
		(m.tehsil_taluka=@v_taluka or @v_taluka is null or @v_taluka='') and (m.city_code=@v_citycode or @v_citycode is null or @v_citycode='')
		group by b.comp_code, b.unit_code, b.billno ,b.billdt,b.agcd, b.dpcd,m.ag_name,b.branch_code,m.city_code,m.country_code,m.state_code
		order by comp_code, state_name,agency_name,billdt,billno
	END	
    IF ISNULL(@repty, 'N')= '2'  BEGIN--FOR DISTRICT
		select b.comp_code AS "COMP_CODE", b.unit_code AS "UNIT_CODE", b.billno AS "BILLNO", b.billdt AS "BILLDT", b.agcd AS "AGCD", b.dpcd AS "DPCD", 
		min(b.publ) AS "PUBL", sum(b.bill_copy) AS "BILL_COPY", sum(b.gross_amount) AS "GROSS_AMOUNT", sum(b.sur_amt) AS "SUR_AMOUNT", sum(b.comm_amt) AS "COMM_AMOUNT",
		sum(b.bill_amount) AS "BILL_AMOUNT",max(b.bill_flag) AS "BILL_FLAG",null as  "BILL_REMARK", max(b.userid) AS "USERID", max(b.creation_date) AS "CREATION_DATE", 
		b.branch_code AS "BRANCH_CODE",m.ag_name AS "AGENCY_NAME",DBO.cir_get_city(b.comp_code,m.city_code) as "CITY NAME" ,
		DBO.cir_get_state(b.comp_code, m.country_code, m.state_code) as "STATE_NAME",
		DBO.cir_get_dist(b.comp_code, m.state_code, m.dist_code) as "DIST_NAME"
		from cir_bill_det b,cir_agmast m
		where b.comp_code = @pcomp_code and m.comp_code=b.comp_code and (b.unit_code = isnull(@punit_code,b.unit_code) OR @punit_code='') and 
		m.unit=b.unit_code and (b.agcd = isnull(@pbillagcd,b.agcd) OR @pbillagcd='') and m.agcd=b.agcd and (b.dpcd = isnull(@pbilldpcd,b.dpcd) OR @pbilldpcd='') and  
		m.dpcd=b.dpcd and b.billdt >= @vfrdt and billdt <=@vtodt and (b.bill_flag = isnull(@pbill_freq,b.bill_flag) OR @pbill_freq='') and 
		(b.publ = isnull(@ppubl,b.publ) OR @ppubl='') and (m.state_code=@v_statecode or @v_statecode is null OR @v_statecode='') and (m.dist_code=@v_distcode or @v_distcode is null OR @v_distcode='') and 
		(m.tehsil_taluka=@v_taluka or @v_taluka is null or @v_taluka='') and (m.city_code=@v_citycode or @v_citycode is null or @v_citycode='')
		group by b.comp_code, b.unit_code, b.billno ,b.billdt,b.agcd, b.dpcd,m.ag_name,b.branch_code,m.city_code,m.country_code,m.state_code,m.dist_code
		order by comp_code, state_name,dist_name,agency_name,billdt,billno
	END
	IF ISNULL(@repty, 'N')= '3' BEGIN 		
		select b.comp_code AS "COMP_CODE", b.unit_code AS "UNIT_CODE", b.billno AS "BILLNO", b.billdt AS "BILLDT", b.agcd AS "AGCD", b.dpcd AS "DPCD", 
		min(b.publ) AS "PUBL", sum(b.bill_copy) AS "BILL_COPY", sum(b.gross_amount) AS "GROSS_AMOUNT", sum(b.sur_amt) AS "SUR_AMOUNT", sum(b.comm_amt) AS "COMM_AMOUNT",
		sum(b.bill_amount) AS "BILL_AMOUNT",max(b.bill_flag) AS "BILL_FLAG",null as  "BILL_REMARK", max(b.userid) AS "USERID", max(b.creation_date) AS "CREATION_DATE", 
		b.branch_code AS "BRANCH_CODE",m.ag_name AS "AGENCY_NAME",DBO.cir_get_city(b.comp_code,m.city_code) as "CITY NAME" ,
		DBO.cir_get_state(b.comp_code, m.country_code, m.state_code) as "STATE_NAME",
		DBO.cir_get_taluka(b.comp_code, m.tehsil_taluka) as "TALUKA_NAME"
		from cir_bill_det b,cir_agmast m
		where b.comp_code = @pcomp_code and m.comp_code=b.comp_code and (b.unit_code = isnull(@punit_code,b.unit_code) OR @punit_code='') and 
		m.unit=b.unit_code and (b.agcd = isnull(@pbillagcd,b.agcd) OR @pbillagcd='') and m.agcd=b.agcd and (b.dpcd = isnull(@pbilldpcd,b.dpcd) OR @pbilldpcd='') and  
		m.dpcd=b.dpcd and b.billdt >= @vfrdt and billdt <=@vtodt and (b.bill_flag = isnull(@pbill_freq,b.bill_flag) OR @pbill_freq='') and 
		(b.publ = isnull(@ppubl,b.publ) OR @ppubl='') and (m.state_code=@v_statecode or @v_statecode is null OR @v_statecode='') and (m.dist_code=@v_distcode or @v_distcode is null OR @v_distcode='') and 
		(m.tehsil_taluka=@v_taluka or @v_taluka is null or @v_taluka='') and (m.city_code=@v_citycode or @v_citycode is null or @v_citycode='')
		group by b.comp_code, b.unit_code, b.billno ,b.billdt,b.agcd, b.dpcd,m.ag_name,b.branch_code,m.city_code,m.country_code,m.state_code,m.tehsil_taluka
		order by comp_code, state_name,taluka_name,agency_name,billdt,billno
	END	
	ELSE BEGIN
		select b.comp_code AS "COMP_CODE", b.unit_code AS "UNIT_CODE", b.billno AS "BILLNO", b.billdt AS "BILLDT", b.agcd AS "AGCD", b.dpcd AS "DPCD", 
		min(b.publ) AS "PUBL", sum(b.bill_copy) AS "BILL_COPY", sum(b.gross_amount) AS "GROSS_AMOUNT", sum(b.sur_amt) AS "SUR_AMOUNT", sum(b.comm_amt) AS "COMM_AMOUNT",
		sum(b.bill_amount) AS "BILL_AMOUNT",max(b.bill_flag) AS "BILL_FLAG",null as  "BILL_REMARK", max(b.userid) AS "USERID", max(b.creation_date) AS "CREATION_DATE", 
		b.branch_code AS "BRANCH_CODE",m.ag_name AS "AGENCY_NAME",DBO.cir_get_city(b.comp_code,m.city_code) as "CITY NAME" ,
		DBO.cir_get_state(b.comp_code, m.country_code, m.state_code) as "STATE_NAME"
		from cir_bill_det b,cir_agmast m
		where b.comp_code = @pcomp_code and m.comp_code=b.comp_code and (b.unit_code = isnull(@punit_code,b.unit_code) OR @punit_code='') and 
		m.unit=b.unit_code and (b.agcd = isnull(@pbillagcd,b.agcd) OR @pbillagcd='') and m.agcd=b.agcd and (b.dpcd = isnull(@pbilldpcd,b.dpcd) OR @pbilldpcd='') and  
		m.dpcd=b.dpcd and b.billdt >= @vfrdt and billdt <=@vtodt and (b.bill_flag = isnull(@pbill_freq,b.bill_flag) OR @pbill_freq='') and 
		(b.publ = isnull(@ppubl,b.publ) OR @ppubl='') and (m.state_code=@v_statecode or @v_statecode is null OR @v_statecode='') and (m.dist_code=@v_distcode or @v_distcode is null OR @v_distcode='') and 
		(m.tehsil_taluka=@v_taluka or @v_taluka is null or @v_taluka='') and (m.city_code=@v_citycode or @v_citycode is null or @v_citycode='')
		group by b.comp_code, b.unit_code, b.billno ,b.billdt,b.agcd, b.dpcd,m.ag_name,b.branch_code,m.city_code,m.country_code,m.state_code
		order by comp_code, state_name,"CITY NAME",agency_name,billdt,billno	
	END	

                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE  Cir_SubRoute_Bind1
  	@pcompcode		as	varchar(200),
    @punitcode		as	varchar(200),
    @proutecode		as	varchar(200),
    @psubrtcode		as	varchar(200),
    @pdateformat	as	varchar(200),
    @pextra1		as	varchar(200),
    @pextra2		as	varchar(200)
 AS
   select a.comp_code COMP_CODE,a.unit UNIT,a.route_code ROUTE_CODE,dbo.cir_get_route_name(a.comp_code,a.unit,a.route_code) ROUTE_NAME,a.subrt_code SUBRT_CODE,
           a.subrt_name SUBRT_NAME,a.subrt_name_oth_lang SUBRT_NAME_OTH_LANG,a.subrt_mode SUBRT_MODE,
           (select b.mode_desc from cir_route_mode_mast b where b.comp_code=a.comp_code and b.mode_code=a.subrt_mode) as MODE_NAME,
           a.start_point START_POINT,a.end_point END_POINT,a.subrt_dist SUBRT_DIST,a.subrt_seq SUBRT_SEQ,
           (select c.drop_point_name from cir_drop_point_mast c	where a.comp_code=c.comp_code and a.unit=c.unit_code and a.start_point=c.drop_point) START_DROP_POINT_NAME,
           (select d.drop_point_name from cir_drop_point_mast d	where a.comp_code=d.comp_code and a.unit=d.unit_code and a.end_point=d.drop_point) END_DROP_POINT_NAME
       from cir_sub_route_mast a
       where a.comp_code=@pcompcode and
             a.unit=@punitcode and
             (a.route_code=@proutecode or isnull(@proutecode,'0')='0' or @proutecode='') and
             (a.subrt_code=@psubrtcode or isnull(@psubrtcode,'0')='0' or @psubrtcode='')
              and ((upper(subrt_name) like upper(@pextra1)+'%') or (@pextra1 is null) or (@pextra1=''))
              and (a.subrt_mode=@pextra2 or @pextra2 is null or @pextra2='')
             --and nvl(a.freeze_flag,'N')='N'
       order by route_name,subrt_name;

                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE  Cir_SubSubRoute_Bind1
  	@pcompcode as varchar(200),
    @punitcode as varchar(200),
    @proutecode as varchar(200),
    @psubrtcode as varchar(200),
    @psubsubrtcode as varchar(200),
    @pdateformat as	varchar(200),
    @pextra1 as	varchar(200),
    @pextra2 as varchar(200)

 AS

 select cir_sub_subroute_mast.*,dbo.cir_get_route_name(cir_sub_subroute_mast.comp_code,cir_sub_subroute_mast.unit,cir_sub_subroute_mast.route_code) "ROUTE NAME",
  	    dbo.cir_get_subroute_name(cir_sub_subroute_mast.comp_code,cir_sub_subroute_mast.unit,cir_sub_subroute_mast.route_code,cir_sub_subroute_mast.subrt_code) "SUBROUTE NAME",
  	    dbo.cir_get_drop_point_name(cir_sub_subroute_mast.comp_code,cir_sub_subroute_mast.unit,cir_sub_subroute_mast.start_point,1) START_DROP_POINT_NAME,
   	    dbo.cir_get_drop_point_name(cir_sub_subroute_mast.comp_code,cir_sub_subroute_mast.unit,cir_sub_subroute_mast.end_point,1) END_DROP_POINT_NAME,
   	    sub_subrt_mode SUB_SUBRT_MODE, (select b.mode_desc from cir_route_mode_mast b where b.comp_code=cir_sub_subroute_mast.comp_code and b.mode_code=cir_sub_subroute_mast.sub_subrt_mode) as MODE_NAME
  	    from cir_sub_subroute_mast
              where comp_code=@pcompcode and
                    unit=@punitcode and
  	                (route_code=@proutecode OR @proutecode is null or @proutecode='') and
                    (subrt_code=@psubrtcode or @psubrtcode is null or @psubrtcode='') and
                    (sub_subrt_code=@psubsubrtcode or isnull(@psubsubrtcode,'0')='0' or @psubsubrtcode='') 
                    and (sub_subrt_mode=@pextra2 or @pextra2 is null or @pextra2='')
                    /*and
                    nvl(freeze_flag,'N')='N'*/
  	          order by route_code,subrt_code,sub_subrt_code;





                                                                     
                                                                     
                                                                     
                                             
ALTER procedure cir_agency_bind_pd (
	@pcompcode  varchar(10),
	@punit		varchar(10),
	@pname		varchar(10),
	@pdateformat  varchar(10),
	@pextra1	varchar(10),
	@pextra2	varchar(10)) 
As
  Begin
         select * from cir_agmast
           where comp_code = @pcompcode and
                    unit = @punit and
              ((upper(ag_name)=upper(@pname)) or (upper(ag_name) like upper(@pname+'%'))) and
              isnull(freeze_flag,'N')='N'
         union
         select * from cir_agmast
           where comp_code = @pcompcode and
                    unit = @punit and
              ((upper(agcd)=upper(@pname)) or (upper(ag_name) like upper(@pname+'%'))) and
              isnull(freeze_flag,'N')='N'              
         order by ag_name
  End 


                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE cir_agency_bind_cir_branch_billagency_p
	@pcompcode				VARCHAR(20) ,
	@punit                  VARCHAR(20) ,
	@pbranchcode            VARCHAR(20) ,
	@pdateformat            VARCHAR(20) ,
	@pextra1                VARCHAR(400) ,
	@pextra2                VARCHAR(400) 
AS 
	If upper(@pextra2)='D' Begin
            select cir_agmast_dis.* ,dbo.cir_get_city(cir_agmast_dis.comp_code,cir_agmast_dis.city_code) "CITY_NAME" from cir_agmast_dis
              where comp_code = @pcompcode and unit = @punit and
                        (branch_code=@pbranchcode or @pbranchcode is null or @pbranchcode='') and
                        ((upper(ag_name) like upper(@pextra1+'%')) or (@pextra1 is null) or (@pextra1='')) and
                  isnull(freeze_flag,'N')='N'
            union
            select cir_agmast_dis.* ,dbo.cir_get_city(cir_agmast_dis.comp_code,cir_agmast_dis.city_code) "CITY_NAME" from cir_agmast_dis
              where comp_code = @pcompcode and
                        unit = @punit and
                        (branch_code=@pbranchcode or @pbranchcode is null or @pbranchcode='') and
                        ((upper(agcd) like upper(@pextra1+'%')) or (@pextra1 is null) or (@pextra1='')) and
                  isnull(freeze_flag,'N')='N'      
            order by 5
       End     
       Else Begin
            select cir_agmast.* ,dbo.cir_get_city(cir_agmast.comp_code,cir_agmast.city_code) "CITY_NAME" from cir_agmast
              where comp_code = @pcompcode and
                        unit = @punit and
                        (branch_code=@pbranchcode or @pbranchcode is null or @pbranchcode='') and
                        ((upper(ag_name) like upper(@pextra1+'%')) or (@pextra1 is null) or (@pextra1='')) and
                  isnull(freeze_flag,'N')='N'
            union
            select cir_agmast.* ,dbo.cir_get_city(cir_agmast.comp_code,cir_agmast.city_code) "CITY_NAME" from cir_agmast
              where comp_code = @pcompcode and
                        unit = @punit and
                        (branch_code=@pbranchcode or @pbranchcode is null or @pbranchcode='') and
                        ((upper(agcd) like upper(@pextra1+'%')) or (@pextra1 is null) or (@pextra1='')) and
                  isnull(freeze_flag,'N')='N'      
            order by 5
       End
                                                                     
                                                                     
                                                                     
                                             
ALTER procedure cir_agency_bind_cir_agency_extraLabel_p
	@pcompcode				VARCHAR(20) ,
	@punit                  VARCHAR(20) ,
	@pdateformat            VARCHAR(20) ,
	@pextra1                VARCHAR(400) ,
	@pextra2                VARCHAR(400) 
AS 
		SELECT cir_agmast.*,
			   DBO.cir_get_area(cir_agmast.comp_code, cir_agmast.area_code) "AREA_NAME",
			   DBO.cir_get_city(cir_agmast.comp_code, cir_agmast.city_code) "CITY_NAME"
		FROM  cir_agmast 
		WHERE	 comp_code  = @pcompcode AND	unit  = @punit
		 AND	(PRINT_LABEL  = 'N' OR	PRINT_LABEL  is null OR	PRINT_LABEL = '')
		 AND	(SUSPEND_TYPE  = 'N' OR	SUSPEND_TYPE  is null OR	SUSPEND_TYPE = '')
		 AND	((UPPER(ag_name)  like UPPER(CAST(@pextra1 AS VARCHAR) + '%')) OR	(@pextra1  is null) OR	(@pextra1  = ''))
		union
		SELECT cir_agmast.*,
			   DBO.cir_get_area(cir_agmast.comp_code, cir_agmast.area_code) "AREA_NAME",
			   DBO.cir_get_city(cir_agmast.comp_code, cir_agmast.city_code) "CITY_NAME"
		FROM  cir_agmast 
		WHERE comp_code  = @pcompcode AND	unit  = @punit
		 AND (PRINT_LABEL  = 'N' OR	PRINT_LABEL  is null OR	PRINT_LABEL = '')
		 AND (SUSPEND_TYPE  = 'N' OR	SUSPEND_TYPE  is null OR	SUSPEND_TYPE = '')
		 AND ((UPPER(agcd)  like UPPER(CAST(@pextra1 AS VARCHAR) + '%')) OR	(@pextra1  is null) OR	(@pextra1  = ''))				 
		ORDER BY 7,5

                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE cir_agency_bind_cir_agency_bind_pd
	@pcompcode			VARCHAR(20) ,
	@punit              VARCHAR(20) ,
	@pname              VARCHAR(20) ,
	@pdateformat        VARCHAR(20) ,
	@pextra1            VARCHAR(400) ,
	@pextra2            VARCHAR(400) 
AS 
		SELECT *
		FROM  cir_agmast 
		WHERE comp_code  = @pcompcode AND unit  = @punit
		 AND ((UPPER(ag_name)  = UPPER(@pname)) OR	(UPPER(ag_name)  like UPPER(CAST(@pname AS VARCHAR) + '%')))
		 AND ISNULL(freeze_flag, 'N')  = 'N'
		union 
		SELECT *
		FROM  cir_agmast 
		WHERE comp_code  = @pcompcode AND unit  = @punit
		 AND ((UPPER(agcd)  = UPPER(@pname)) OR	(UPPER(ag_name)  like UPPER(CAST(@pname AS VARCHAR) + '%')))
		 AND ISNULL(freeze_flag, 'N')  = 'N'		
		ORDER BY 5 

                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE cir_agency_bind_cir_agency_bind_p
	@pcompcode			VARCHAR(20) ,
	@punit              VARCHAR(20) ,
	@pdateformat        VARCHAR(20) ,
	@pextra1            VARCHAR(4000) ,
	@pextra2            VARCHAR(4000) 
AS 
BEGIN
	If UPPER(@pextra2)='D'
	Begin
			
		SELECT *,dbo.cir_get_city(cir_agmast_dis.comp_code,cir_agmast_dis.city_code) "CITY_NAME"
		FROM  cir_agmast_dis 
		WHERE comp_code  = @pcompcode AND unit  = @punit
		 AND ((UPPER(ag_name)  like UPPER(CAST(@pextra1 AS VARCHAR) + '%')) OR	(@pextra1  is null) OR	(@pextra1  = ''))
		 AND	ISNULL(freeze_flag, 'N')  = 'N'
		union
		SELECT *,dbo.cir_get_city(cir_agmast_dis.comp_code,cir_agmast_dis.city_code) "CITY_NAME"
		FROM  cir_agmast_dis 
		WHERE comp_code  = @pcompcode AND unit  = @punit
		 AND ((UPPER(agcd)  like UPPER(CAST(@pextra1 AS VARCHAR) + '%')) OR	(@pextra1  is null) OR	(@pextra1  = ''))
		 AND ISNULL(freeze_flag, 'N')  = 'N'				 
		ORDER BY 5
	End
	Else
	Begin
		SELECT *,dbo.cir_get_city(cir_agmast.comp_code,cir_agmast.city_code) "CITY_NAME"
			FROM  cir_agmast 
			WHERE comp_code  = @pcompcode
			 AND unit  = @punit
			 AND ((UPPER(ag_name)  like UPPER(CAST(@pextra1 AS VARCHAR) + '%')) OR	(@pextra1  is null) OR	(@pextra1  = ''))
			 AND ISNULL(freeze_flag, 'N')  = 'N'
		union
		SELECT *,dbo.cir_get_city(cir_agmast.comp_code,cir_agmast.city_code) "CITY_NAME"
			FROM  cir_agmast 
			WHERE comp_code  = @pcompcode
			 AND unit  = @punit
			 AND ((UPPER(agcd)  like UPPER(CAST(@pextra1 AS VARCHAR) + '%')) OR	(@pextra1  is null) OR	(@pextra1  = ''))
			 AND ISNULL(freeze_flag, 'N')  = 'N'			 
			ORDER BY 5
	End
END
                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE cir_agency_bind_cir_agency_area_p
	@pcompcode			VARCHAR(20) ,
	@punit              VARCHAR(20) ,
	@pdateformat        VARCHAR(20) ,
	@pextra1            VARCHAR(400) ,
	@pextra2            VARCHAR(400) 
AS 
if UPPER(@pextra2)='D'
Begin
	SELECT	 cir_agmast_dis.*,
			 DBO.cir_get_area(cir_agmast_dis.comp_code, cir_agmast_dis.area_code) "AREA_NAME",
			 DBO.cir_get_city(cir_agmast_dis.comp_code, cir_agmast_dis.city_code) "CITY_NAME"
	FROM  cir_agmast_dis
	WHERE comp_code  = @pcompcode
	 AND unit  = @punit
	 AND (ag_name  like CAST(@pextra1 AS VARCHAR) + '%' OR @pextra1  is null OR @pextra1='')
	union
	SELECT	 cir_agmast_dis.*,
			 DBO.cir_get_area(cir_agmast_dis.comp_code, cir_agmast_dis.area_code) "AREA_NAME",
			 DBO.cir_get_city(cir_agmast_dis.comp_code, cir_agmast_dis.city_code) "CITY_NAME"
	FROM  cir_agmast_dis
	WHERE comp_code  = @pcompcode
	 AND unit  = @punit
	 AND (agcd  like CAST(@pextra1 AS VARCHAR) + '%' OR @pextra1  is null OR @pextra1='') 
	ORDER BY 7,5 
End
else
Begin
	SELECT   cir_agmast.*,
		 DBO.cir_get_area(cir_agmast.comp_code, cir_agmast.area_code) "AREA_NAME",
		 DBO.cir_get_city(cir_agmast.comp_code, cir_agmast.city_code) "CITY_NAME"
		FROM  cir_agmast 
		WHERE comp_code  = @pcompcode AND unit  = @punit
		 AND (ag_name  like CAST(@pextra1 AS VARCHAR) + '%' OR @pextra1  is null OR @pextra1='')
	union
	SELECT   cir_agmast.*,
		 DBO.cir_get_area(cir_agmast.comp_code, cir_agmast.area_code) "AREA_NAME",
		 DBO.cir_get_city(cir_agmast.comp_code, cir_agmast.city_code) "CITY_NAME"
		FROM  cir_agmast 
		WHERE comp_code  = @pcompcode AND unit  = @punit
		 AND (agcd  like CAST(@pextra1 AS VARCHAR) + '%' OR @pextra1  is null OR @pextra1='')	 
		ORDER BY 7,5
		
End
                                                                     
                                                                     
                                                                     
                                             
ALTER FUNCTION cir_get_receipt_exist
    (@pcomp_code     as varchar(200),
     @punit_code     as varchar(200),
	 @pbran_code     AS varchar(200),
     @precptno       as varchar(200),
     @pdoctype       as varchar(20),
     @pagcd          as varchar(20),
     @pdpcd          as varchar(20),
     @pextra1        as varchar(200),
     @pextra2        as varchar(200),
     @pextra3        as varchar(200),
     @pextra4        as varchar(200),
     @pextra5        as varchar(200)) RETURNS int AS
	
BEGIN
declare @v_rec_exist int
set @v_rec_exist=0
	if upper(@pextra2)='D' Begin
		select @v_rec_exist = count(*) from cir_rcphdr_dis where comp_code=@pcomp_code and unit_code=@punit_code and 
		doctype=@pdoctype and recptno=@precptno and agcd=@pagcd and dpcd=@pdpcd and branch_code=@pbran_code
	End	
	else Begin
	select @v_rec_exist = count(*) from cir_rcphdr where comp_code=@pcomp_code and unit_code=@punit_code and 
		doctype=@pdoctype and recptno=@precptno and agcd=@pagcd and dpcd=@pdpcd and branch_code=@pbran_code	
	End     
  return @v_rec_exist;
END

/******** laxman sir***********************/


/*************************************************ISSUE NO.0004816 *******************************************/

USE [abhi]
GO
/****** Object:  StoredProcedure [dbo].[cir_edtion_bind_cir_mian_edtion_bind_p]    Script Date: 10/10/2011 20:24:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[cir_edtion_bind_cir_mian_edtion_bind_p]

	@pcomp_code                               VARCHAR(20) ,
	@ppubl_code                               VARCHAR(20) ,
	@pedtn_code                               VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS 
	
		SELECT *
		FROM  cir_edtn_mast 
		WHERE	 comp_code  = @pcomp_code
         and (unit_code=@pextra1 or @pextra1 is null or @pextra1 = '')
		 AND	publ  = @ppubl_code
		 AND	(edtn  = @pedtn_code
		 OR	@pedtn_code  is null  OR	@pedtn_code = '')
		 AND	edtn  = main_edtn
         AND ( edtn_name like @pextra2+'%' or @pextra2 is null)
		 AND	ISNULL(freeze_flag, 'N')  = 'N'
		ORDER BY edtn_name 



USE [abhi]
GO
/****** Object:  StoredProcedure [dbo].[cir_edtion_bind_cir_sub_edtion_bind_p]    Script Date: 10/10/2011 20:24:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[cir_edtion_bind_cir_sub_edtion_bind_p]
	@pcomp_code                               VARCHAR(20) ,
	@ppubl_code                               VARCHAR(20) ,
	@pedtn_code                               VARCHAR(20) ,
	@psubedtn_code                            VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS 
BEGIN

select * from cir_edtn_mast
where comp_code = @pcomp_code and publ = @ppubl_code 
and (edtn=@psubedtn_code or @psubedtn_code is null OR @psubedtn_code = '' ) and (main_edtn=@pedtn_code or @pedtn_code is null OR  @pedtn_code = '')
and edtn<>main_edtn and ISNULL(freeze_flag,'N')='N'   and (unit_code=@pextra2 or @pextra2 is null or  @pextra2 = '')
order by edtn_name;

END




/************************************************* END OF ISSUE NO.0004816 *******************************************/


/*****************5268   11-oct************************/

ALTER PROCEDURE [dbo].[Cir_Gen_Code_agmast_P]
	@pcompcode                                VARCHAR(20) ,
	@punitcode                                VARCHAR(20) ,
	@pprefix                                  VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS 
	DECLARE @vno            NUMERIC(8) 
	DECLARE @vag_code       VARCHAR(20) 
	DECLARE @v_prefix		varchar(30); 

	if UPPER(@pextra2)='D'
		
		begin
			set @v_prefix='D' + upper(@pprefix)
			SELECT @vno  =  MAX(SUBSTRING(agcd, LEN(agcd)+1, LEN(agcd))) + 1
			FROM  cir_agmast_dis 
			WHERE	 comp_code  = @pcompcode AND	unit  = @punitcode AND	UPPER(SUBSTRING(agcd, 1, LEN(agcd)))  = UPPER(@v_prefix)
		end

	else		
		begin
			set @v_prefix= upper(@pprefix)
			SELECT @vno  =  MAX(SUBSTRING(agcd, LEN(agcd)+1, LEN(agcd))) + 1
			FROM  cir_agmast 
			WHERE	 comp_code  = @pcompcode AND	unit  = @punitcode AND	UPPER(SUBSTRING(agcd, 1, LEN(agcd)))  = UPPER(@v_prefix)
		end

	IF (ISNULL(@vno, 0)= 0  OR @vno='' )
		BEGIN 
			SET @vag_code  = UPPER(@v_prefix)+ '0001' 
		END
	ELSE
		BEGIN 
			SET @vag_code  = UPPER(@v_prefix)+ dbo.fnPadLeft('0',4,@vno)  
		END

	SELECT @vag_code AS VAR_CODE



ALTER FUNCTION [dbo].[cir_get_genrate_agcd](@pcomp_code as varchar(20),@punit_code as varchar(20),@pextra1 as varchar(20),@pextra2 as varchar(20)) RETURNs int AS

BEGIN
declare @v_name int
    
    select @v_name=GENRATE_CIR_AGCD from preferrences where "comp_code"=@pcomp_code
    
  return isnull(@v_name,1)
END

CREATE  FUNCTION cir_get_taluka_seqno
(@pcompcode  varchar(20),@ptalukacode  varchar(20)) 
RETURNS numeric(5,0)
AS 
	BEGIN
		
		DECLARE @v_seqno         numeric(5,0)

    
        select distinct @v_seqno=taluka_seqno  from cir_taluka_mast
            where comp_code=@pcompcode and talu_code=@ptalukacode;
    
   return ISNULL(@v_seqno, 1) 

	END

/*****************5268   11-oct************************/




//==============================================issue no.5258  12/10/2011 updted by laxman sir--------------------------------------------



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER procedure [dbo].[cir_agencywise_supply]
    @pcomp_code			as varchar(20),
    @punit_code         as varchar(20),
    @pbrancode			as varchar(20),
    @ppublcode			as varchar(20),
    @pmedtncode			as varchar(20),
    @pedtncode			as varchar(20),
    @pagcd				as varchar(20),
    @pdpcd				as varchar(20),
    @pagtype			as varchar(20),
    @pstatecode			as varchar(20),
    @pcitycode			as varchar(20),
    @pfrom_supdate		as datetime,
    @ptill_supdate		as datetime,
    @psortedby			as varchar(20),
    @pdateformat		as varchar(20),
    @pextra1			as varchar(20),--for supply -->S,Unsold -->U
    @pextra2			as varchar(20),
    @pextra3			as varchar(20),
    @pextra4			as varchar(20),
    @pextra5			as varchar(20)
    As
     declare @vfrdt    as datetime
     declare @vtodt    as datetime
     declare @v_dt     as datetime
     declare @v_cnt    as int
     declare @vvar     as varchar(4000)
     declare @vvar_sum as varchar(4000)
     declare @vvar_sum1 as varchar(4000)
     declare @v_query1   as varchar(8000)
     declare @v_query2   as varchar(8000)
   Begin
		SET CONCAT_NULL_YIELDS_NULL OFF
        set @vfrdt=dbo.GetFirstDayOfMonth(@pfrom_supdate)
        set @vtodt=dbo.GetLastDayOfMonth(@ptill_supdate)   
		
		CREATE TABLE #CIR_TEMP_DT(SEQNO INT,DT	DATETIME)
		declare @month_count as numeric(6)
		declare @loopval as numeric(6)
		declare @dynamic_month_last as datetime 

		set @loopval=0
		set @month_count=DATEDIFF(month, @vfrdt, @vtodt)+1
		while(@month_count !=0)
		begin

			set @dynamic_month_last=DATEADD(mm, @loopval, isnull(@dynamic_month_last,@vfrdt))
			set @v_cnt=isnull(@v_cnt,0)+1

			insert into #cir_temp_dt(SEQNO,dt) 
			values(@v_cnt,dbo.GetLastDayOfMonth(@dynamic_month_last))

			set @loopval=@loopval+1
			set @month_count=@month_count-1
		end
--select * from #cir_temp_dt

declare c1 cursor for
           select dt from #cir_temp_dt order by SEQNO,dt

		open c1
			fetch NEXT FROM c1 INTO @v_dt
			WHILE (@@FETCH_STATUS = 0)  

			Begin
				set @v_cnt        = isnull(@v_cnt,0)+1

				if @vvar is null 
					Begin
						if upper(@pextra1)='U' Begin
							set @vvar        ='case CONVERT(VARCHAR(10), dbo.GetlastDayOfMonth(b.app_dt), 101) when '+''''+CONVERT(VARCHAR(10), @V_DT, 101)+''''+' then sum(isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0)) else sum(0) end "'+SUBSTRING(CONVERT(VARCHAR(11), @V_DT, 113), 4, 8) +'"'
						End
						Else Begin
							set @vvar        ='case CONVERT(VARCHAR(10), dbo.GetlastDayOfMonth(b.billdt), 101) when '+''''+CONVERT(VARCHAR(10), @V_DT, 101)+''''+' then sum(b.bill_copy) else sum(0) end "'+SUBSTRING(CONVERT(VARCHAR(11), @V_DT, 113), 4, 8) +'"'
						End
							
						set @vvar_sum    ='sum('+'"'+SUBSTRING(CONVERT(VARCHAR(11), @V_DT, 113), 4, 8)+'") "'+SUBSTRING(CONVERT(VARCHAR(11), @V_DT, 113), 4, 8)+'"'
						set @vvar_sum1   ='sum('+'"'+SUBSTRING(CONVERT(VARCHAR(11), @V_DT, 113), 4, 8)+'"'
					End
				else
					Begin
						if upper(@pextra1)='U' Begin
							set @vvar        =	@vvar+','+'case CONVERT(VARCHAR(10), dbo.GetlastDayOfMonth(b.app_dt), 101) when '+''''+CONVERT(VARCHAR(10), @V_DT, 101)+''''+' then sum(isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0)) else sum(0) end "'+SUBSTRING(CONVERT(VARCHAR(11), @V_DT, 113), 4, 8) +'"'
						End
						Else Begin
							set @vvar        =	@vvar+','+'case CONVERT(VARCHAR(10), dbo.GetlastDayOfMonth(b.billdt), 101) when '+''''+CONVERT(VARCHAR(10), @V_DT, 101)+''''+' then sum(b.bill_copy) else sum(0) end "'+SUBSTRING(CONVERT(VARCHAR(11), @V_DT, 113), 4, 8) +'"'
						End	
						set @vvar_sum    =	@vvar_sum+','+'sum('+'"'+SUBSTRING(CONVERT(VARCHAR(11), @V_DT, 113), 4, 8)+'") "'+SUBSTRING(CONVERT(VARCHAR(11), @V_DT, 113), 4, 8)+'"'
						set @vvar_sum1   =	@vvar_sum1+'+"'+SUBSTRING(CONVERT(VARCHAR(11), @V_DT, 113), 4, 8)+'"'
					End
				fetch NEXT FROM c1 INTO @v_dt
			End

		close c1
		deallocate c1

		if @vvar_sum1 is not null 
			Begin
				set @vvar_sum1=@vvar_sum1+') "Total"'
			End
		if upper(@pextra1)='U' Begin
			set @v_query1='SELECT COMP_CODE,UNIT_CODE,COMM_RATE ,AG_NAME,DBO.CIR_GET_CITY(COMP_CODE,CITY_CODE) CITY_NAME,'+@vvar_sum+','+@vvar_sum1+' from (select b.comp_code comp_code,b.unit_code unit_code,isnull(b.comm_catg_type,''P'')+''-''+convert(varchar(20),isnull(b.comm_rate,0)) comm_rate,a.agcd agcd,b.dpcd dpcd,
			a.ag_name ag_name,a.city_code city_code,'+@vvar+' '
			
			set @v_query2=' from cir_agmast a, cir_unsold_dtl b,cir_edtn_mast e
			where a.comp_code=b.comp_code and a.comp_code=e.comp_code and b.comp_code='+''''+@pcomp_code+''''+' and a.unit=b.unit_code and a.unit=e.unit_code and b.unit_code='+''''+@punit_code+''''+' and 
			a.agcd=b.agcd and a.dpcd=b.dpcd and (a.agcd=isnull('+''''+@pagcd+''''+',a.agcd) or '''+@pagcd+''' ='''') and (a.dpcd=isnull('+''''+@pdpcd+''''+',a.dpcd)or '''+@pdpcd+''' ='''') and (a.branch_code=isnull('+''''+@pbrancode+''''+',a.branch_code) or '''+@pbrancode+''' ='''') and (a.ag_type=isnull('+''''+@pagtype+''''+',a.ag_type) or '''+@pagtype+''' ='''') and b.publ=e.publ and (b.publ=isnull('+''''+@ppublcode+''''+',b.publ) or '''+@ppublcode+''' ='''') and
			b.app_dt between '+''''+CONVERT(VARCHAR(11), @VFRDT, 101)+''''+' and '+''''+CONVERT(VARCHAR(11), @VTODT, 101)+''''+' and b.edtn=e.edtn and (b.edtn=isnull('+''''+@pedtncode+''''+',b.edtn)or '''+@pedtncode+''' ='''') and  (e.main_edtn=isnull('+''''+@pmedtncode+''''+',e.main_edtn)or '''+@pmedtncode+''' ='''') and (a.state_code=isnull('+''''+@pstatecode+''''+',a.state_code)  or '''+@pstatecode+''' ='''') and (a.city_code=isnull('+''''+@pcitycode+''''+',a.city_code)  or '''+@pcitycode+''' ='''') group by b.comp_code,b.unit_code,b.app_dt,isnull(b.comm_catg_type,''P''),b.comm_rate,a.city_code,a.agcd,b.dpcd,a.ag_name) x
			group by comp_code,unit_code,comm_rate,city_code,ag_name order by comp_code,unit_code,comm_rate,ag_name'
		End
		Else Begin
			set @v_query1='SELECT COMP_CODE,UNIT_CODE,COMM_RATE ,AG_NAME,DBO.CIR_GET_CITY(COMP_CODE,CITY_CODE) CITY_NAME,'+@vvar_sum+','+@vvar_sum1+' from (select b.comp_code comp_code,b.unit_code unit_code,isnull(b.comm_type,''P'')+''-''+convert(varchar(20),isnull(b.comm_rate,0)) comm_rate,a.agcd agcd,b.dpcd dpcd,
			a.ag_name ag_name,a.city_code city_code,'+@vvar+' '
			set @v_query2=' from cir_agmast a, cir_bill_det b,cir_edtn_mast e
			where a.comp_code=b.comp_code and a.comp_code=e.comp_code and b.comp_code='+''''+@pcomp_code+''''+' and a.unit=b.unit_code and a.unit=e.unit_code and b.unit_code='+''''+@punit_code+''''+' and 
			a.agcd=b.agcd and a.dpcd=b.dpcd and (a.agcd=isnull('+''''+@pagcd+''''+',a.agcd) or '''+@pagcd+''' ='''') and (a.dpcd=isnull('+''''+@pdpcd+''''+',a.dpcd)or '''+@pdpcd+''' ='''') and (a.branch_code=isnull('+''''+@pbrancode+''''+',a.branch_code) or '''+@pbrancode+''' ='''') and (a.ag_type=isnull('+''''+@pagtype+''''+',a.ag_type) or '''+@pagtype+''' ='''') and (b.publ=isnull('+''''+@ppublcode+''''+',b.publ) or '''+@ppublcode+''' ='''') and
			b.billdt between '+''''+CONVERT(VARCHAR(11), @VFRDT, 101)+''''+' and '+''''+CONVERT(VARCHAR(11), @VTODT, 101)+''''+' and b.edtn=e.edtn and (b.edtn=isnull('+''''+@pedtncode+''''+',b.edtn)or '''+@pedtncode+''' ='''') and  (e.main_edtn=isnull('+''''+@pmedtncode+''''+',e.main_edtn)or '''+@pmedtncode+''' ='''') and (a.state_code=isnull('+''''+@pstatecode+''''+',a.state_code)  or '''+@pstatecode+''' ='''') and (a.city_code=isnull('+''''+@pcitycode+''''+',a.city_code)  or '''+@pcitycode+''' ='''') group by b.comp_code,b.unit_code,b.billdt,isnull(b.comm_type,''P''),b.comm_rate,a.city_code,a.agcd,b.dpcd,a.ag_name) x
			group by comp_code,unit_code,comm_rate,city_code,ag_name order by comp_code,unit_code,comm_rate,ag_name'
        End			
    
    print('@v_query1')
	print(@v_query1)print(@v_query2)
	exec (@v_query1+@v_query2)
        
    End
    

==================================================================end of 5258-------------------------------------------------


************satrt mimoh mahajan-18/oct/2011******0005354***********************************************************
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER PROCEDURE [dbo].[Cir_Gen_Code_race_code_p]
	@pcompcode                                VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS 
	DECLARE @vno          INT 
	DECLARE @vtype_code   VARCHAR(15) 

	SELECT @vno  =  CONVERT(NUMERIC(8, 2), MAX(SUBSTRING(race_code, 3, 5))) + 1
	FROM  cir_race_mast 
	
	IF ISNULL(@vno, 0)= 0 
		BEGIN 
			SET @vtype_code  = 'RC' + '001' 
		END
	ELSE
		BEGIN 
			SET @vtype_code  = 'RC' + dbo.fnPadLeft('0',3,@vno)  
		END

	SELECT @vtype_code AS "VAR_CODE"



****************************************************************************************************
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER PROCEDURE [dbo].[Cir_Dynamic_DML_variable_insert_stmt]
	@ptable_name                              VARCHAR(4000) ,
	@pcolname                                 VARCHAR(4000) ,
	@pcolvalue                                VARCHAR(4000) ,
	@pdelimiter                               VARCHAR(4000) ,
	@pdateformat                              VARCHAR(4000) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS
    	DECLARE @pstmt_str                                VARCHAR(4000) 
		DECLARE @v_sess_id                                FLOAT 
		DECLARE @rec_stmt								  VARCHAR(4000)		
		DECLARE @vlength                                  NUMERIC(5) 
		DECLARE @vcolval                                  VARCHAR(4000) 
		DECLARE @vrunval                                  VARCHAR(1) 
		DECLARE @vcol_name                                VARCHAR(4000) 
		DECLARE @vno                                      NUMERIC(5) 
		DECLARE @vrec                                     VARCHAR(4000) 
		DECLARE @vrec_upd                                 VARCHAR(4000) 
		DECLARE @vformat                                  VARCHAR(20) 
		DECLARE @v_col_exists                             NUMERIC(5) 
        DECLARE	 @COL_DATA_TYPE1						  VARCHAR(4000) 
        DECLARE	 @COL_VALUE1							  VARCHAR(4000) 
		declare @ss numeric(8)
		declare @vrec_val varchar(4000)
		declare @abj numeric(8)
		declare @col_val varchar(4000)
		declare @col_val1 varchar(4000)
	    declare @user_date varchar(4000)
		declare @item varchar(4000)
		declare @day varchar(4000)
		declare @month varchar(4000)
		declare @year varchar(4000)

		set @v_sess_id = (select @@spid)
		DELETE FROM   temp_col_ins   WHERE  session_id  = (select @@spid)
		SET @vlength  = null 
		SET @vcolval  = null 
		SET @vrunval  = null 
		SET @vcol_name  = null 
		SET @vno  = null 
		SET @vcolval  = REPLACE(@pcolname, @pdelimiter, ',')
print(@vcolval)
		SET @vlength  = LEN(@vcolval)
		SET @vno  = 1 
		SET  @ss  = 1
		set @vrec_val =null

        DECLARE @i INT

		SET  @i  = 1 

		WHILE @i <= @vlength 
		  BEGIN			
			SET @vrunval  = SUBSTRING(@vcolval, @i, 1)
			IF @vrunval != ',' 
			  BEGIN 
				SET @vcol_name  =  RTRIM(LTRIM(COALESCE(@vcol_name,space(0)) +  COALESCE(@vrunval,space(0))))
			  END
			ELSE
			 BEGIN				

				INSERT INTO  temp_col_ins  ( sqno , col_name , session_id )  
				 VALUES ( @vno , LTRIM(RTRIM(@vcol_name)) , @v_sess_id )  				
				SET @vno  = @vno + 1 
				SET @vcol_name  = '' 
			END
			SET @i = @i + 1
		END 
		SELECT @v_col_exists  =  COUNT(*) FROM  temp_col_ins WHERE	 session_id  = @v_sess_id AND	col_name  = LTRIM(RTRIM(@vcol_name))
		IF ISNULL(@v_col_exists, 0)= 0 
		BEGIN 
			INSERT INTO  temp_col_ins   ( sqno , col_name , session_id )   VALUES ( @vno ,	rtrim(ltrim(@vcol_name)) , @v_sess_id )			
		END
		SET @vlength  = null 
		SET @vcolval  = null 
		SET @vrunval  = null 
		SET @vcol_name  = null 
		SET @vno  = null 
		IF CHARINDEX(',', @pcolvalue)> 0 or CHARINDEX('''', @pcolvalue)> 0 
    		BEGIN 
	    		SET @vcolval  = REPLACE(@pcolvalue, ',', '~~~')
		END
		ELSE
		 BEGIN 
			SET @vcolval  = @pcolvalue 
		END
   
		SET @vcolval  = REPLACE(@vcolval, @pdelimiter, ',')
		SET @vlength  = LEN(@vcolval)
		SET @vno  = 1 
        SET @i = 1 
		print (@vlength)
		WHILE @i <= @vlength 
		BEGIN
		SET @vrunval  = SUBSTRING(@vcolval, @i, 1)
			IF @vrunval != ',' 
			BEGIN 
				SELECT @vcol_name  = COALESCE(@vcol_name,space(0)) + COALESCE(@vrunval,space(0))
			END
			ELSE
			BEGIN 
				SELECT @vcol_name  = REPLACE(@vcol_name, '~~~', ',')
				UPDATE  temp_col_ins   
				SET	col_value = COALESCE(@vcol_name,space(0))
				WHERE  sqno  = @vno
				 AND	session_id  = @v_sess_id 
				
				SET @vno  = @vno + 1 
				SET @vcol_name  = '' 
print 'update'
			END

			SET @i = @i + 1
print (@i)
		END

		IF @vcol_name is not null 
		BEGIN 
			UPDATE  temp_col_ins   
			SET	col_value = COALESCE(@vcol_name,space(0))
			WHERE  sqno  = @vno
			 AND	session_id  = @v_sess_id 
		END
   
		UPDATE  temp_col_ins   
		SET	col_data_type = (SELECT DATA_TYPE
			FROM  INFORMATION_SCHEMA.COLUMNS
			WHERE	 TABLE_NAME  = LTRIM(RTRIM(@ptable_name))
			 AND	column_name  = LTRIM(RTRIM(temp_col_ins.col_name))
		) 
		WHERE  session_id  = @v_sess_id 

		SET @vrec  = 'insert into ' + @ptable_name + '(' + REPLACE(@pcolname, @pdelimiter, ',')+ ') values (' 
print('rinki')			
print(@vrec)	
		SET @vformat  = @pdateformat 

		DECLARE cur_stmt cursor  FOR 
		SELECT COL_DATA_TYPE,COL_VALUE  FROM  temp_col_ins WHERE	 session_id  = @v_sess_id ORDER BY sqno 


    OPEN cur_stmt 
		fetch NEXT FROM cur_stmt INTO @COL_DATA_TYPE1,@COL_VALUE1
         while(@@FETCH_STATUS = 0)
			BEGIN  
		print(@COL_DATA_TYPE1)
print(@COL_VALUE1)
				IF  ( @COL_DATA_TYPE1 = 'datetime') 
					BEGIN 
						declare @finaldate varchar(4000)
						declare @count_dat int
						set @count_dat=0
						print 'aa'
						print @COL_VALUE1
						if @COL_VALUE1!='' or @COL_VALUE1 !=null or @COL_VALUE1 !='null'
						begin
							print '1ankur_test'
print('datetime') print(@COL_VALUE1)print(@pdateformat)print (@finaldate)
							set @finaldate=(select dbo.convert_user_date('/',@COL_VALUE1,@pdateformat))
							print '21ankur_test'
							print @finaldate
print 'ankur_testrr'
end
						if @finaldate='/'
begin
					set @finaldate=''''
end
						set @finaldate=''''+replace(@finaldate,'''','')+''''
			SET @col_val = COALESCE(@col_val + ',', SPACE(0)) + '' + COALESCE(@finaldate + '', SPACE(0))
			print @col_val
					END;
				else if(@COL_DATA_TYPE1 = 'numeric') OR (@COL_DATA_TYPE1 = 'decimal')
					begin						
							SET @col_val = COALESCE(@col_val + ',', SPACE(0)) + '' + 'convert( float,' + COALESCE(@COL_VALUE1 + '', SPACE(0))+')'
					end
				ELSE
					BEGIN
						SET @vrec = @vrec
						SET @col_val = COALESCE(@col_val + ',', SPACE(0)) + '' + COALESCE(@COL_VALUE1 + '', SPACE(0))
						END;
				fetch NEXT FROM cur_stmt INTO @COL_DATA_TYPE1,@COL_VALUE1
			END 
print'asdf'
			SET @col_val =COALESCE(substring(@col_val,1,len(@col_val)),SPACE(0))
			SET @vrec=  COALESCE(@vrec,SPACE(0)) + COALESCE(@col_val,SPACE(0)) + ')'
			SET @vlength  = null 
			SET @vcolval  = null 
			SET @vrunval  = null 
			SET @vcol_name  = null 
			SET @vno  = null 
		
		UPDATE   temp_col_ins   
		SET	upd_str = @vrec 
		WHERE  session_id  = @v_sess_id
             
        print(@vrec)
		EXEC (@vrec)
 DEALLOCATE cur_stmt 


















******************************************************************************************************
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




ALTER PROCEDURE [dbo].[cir_dynamic_execute_stmt]
	@ptable_name                              VARCHAR(4000) ,
	@pcond_colname                                 VARCHAR(4000) ,
	@pcond_colval                                VARCHAR(4000) ,
	@pdelimiter                               VARCHAR(4000) ,
	@pdateformat                              VARCHAR(4000) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS
    	DECLARE @pstmt_str                                VARCHAR(4000) 
		DECLARE @v_sess_id                                FLOAT 
		DECLARE @rec_stmt    VARCHAR(200)		
		DECLARE @vlength                                  NUMERIC(5) 
		DECLARE @vcolval                                  VARCHAR(4000) 
		DECLARE @vrunval                                  VARCHAR(1) 
		DECLARE @vcol_name                                VARCHAR(100) 
		DECLARE @vno                                      NUMERIC(5) 
		DECLARE @vrec                                     VARCHAR(4000) 
		DECLARE @vrec_upd                                 VARCHAR(4000) 
		DECLARE @vformat                                  VARCHAR(20) 
		DECLARE @v_col_exists                             NUMERIC(5) 
        DECLARE	 @COL_NAME    VARCHAR(200) 
        DECLARE	 @COL_VALUE1    VARCHAR(2000) 
		DECLARE @COL_DATATYPE VARCHAR(4000)
		declare @ss numeric(8)
		declare @vrec_val varchar(4000)
		declare @abj numeric(8)
		declare @col_val varchar(4000)
		declare @col_val1 varchar(4000)
declare @item varchar(4000)
declare @day varchar(4000)
declare @month varchar(4000)
declare @year varchar(4000)

		INSERT INTO  test1   ( vstring )   VALUES 	( CAST(@pcond_colname AS VARCHAR) + '33333' + CAST(@pcond_colval AS VARCHAR) )  
		set @v_sess_id = (select @@spid)
		DELETE FROM   temp_col_ins   WHERE  session_id  = (select @@spid)
		SET @vlength  = null 
		SET @vcolval  = null 
		SET @vrunval  = null 
		SET @vcol_name  = null 
		SET @vno  = null 
		SET @vcolval  = REPLACE(@pcond_colname, @pdelimiter, ',')
		SET @vlength  = LEN(@vcolval)
		SET @vno  = 1 
		SET  @ss  = 1
		set @vrec_val =null

        DECLARE @i INT

		SET  @i  = 1 

		WHILE @i <= @vlength 
		  BEGIN			
			SET @vrunval  = SUBSTRING(@vcolval, @i, 1)
			IF @vrunval != ',' 
			  BEGIN 
				SET @vcol_name  =  COALESCE(@vcol_name,space(0)) +  COALESCE(@vrunval,space(0))				
			  END
			ELSE
			 BEGIN				
				INSERT INTO  temp_col_ins  ( sqno , col_name , session_id )  
				 VALUES ( @vno , UPPER(LTRIM(RTRIM(@vcol_name))) , @v_sess_id )  				
				SET @vno  = @vno + 1 
				SET @vcol_name  = '' 
			END
			SET @i = @i + 1
		END 
		SELECT @v_col_exists  =  COUNT(*) FROM  temp_col_ins WHERE	 session_id  = @v_sess_id AND	col_name  = UPPER(LTRIM(RTRIM(@vcol_name)))		
		IF ISNULL(@v_col_exists, 0)= 0 
		BEGIN 
			INSERT INTO  temp_col_ins   ( sqno , col_name , session_id )   VALUES ( @vno , UPPER(@vcol_name) , @v_sess_id )			
		END
		SET @vlength  = null 
		SET @vcolval  = null 
		SET @vrunval  = null 
		SET @vcol_name  = null 
		SET @vno  = null 

		IF CHARINDEX(',', @pcond_colval)> 0 or CHARINDEX('''', @pcond_colval)> 0 
    		BEGIN 
	    		SET @vcolval  = REPLACE(@pcond_colval, ',', '~~~')
		END
		ELSE
		 BEGIN 
			SET @vcolval  = @pcond_colval 
		END
   
		SET @vcolval  = REPLACE(@vcolval, @pdelimiter, ',')
		SET @vlength  = LEN(@vcolval)
		SET @vno  = 1 
        SET @i = 1 
		
		WHILE @i <= @vlength 
		BEGIN
		SET @vrunval  = SUBSTRING(@vcolval, @i, 1)
			IF @vrunval != ',' 
			BEGIN 
				SELECT @vcol_name  = COALESCE(@vcol_name,space(0)) + COALESCE(@vrunval,space(0))
			END
			ELSE
			BEGIN 
				SELECT @vcol_name  = REPLACE(@vcol_name, '~~~', ',')
				UPDATE  temp_col_ins   
				SET	col_value = COALESCE(@vcol_name,space(0))
				WHERE  sqno  = @vno
				 AND	session_id  = @v_sess_id 
				
				SET @vno  = @vno + 1 
				SET @vcol_name  = '' 
			END

			SET @i = @i + 1

		END
		IF @vcol_name is not null 
		BEGIN 
			UPDATE  temp_col_ins   
			SET	col_value = COALESCE(@vcol_name,space(0))
			WHERE  sqno  = @vno
			 AND	session_id  = @v_sess_id 
		END
   
		UPDATE  temp_col_ins   
		SET	col_data_type = (SELECT DATA_TYPE
			FROM  INFORMATION_SCHEMA.COLUMNS
			WHERE	 TABLE_NAME  = UPPER(LTRIM(RTRIM(@ptable_name)))
			 AND	column_name  = UPPER(LTRIM(RTRIM(temp_col_ins.col_name)))
		) 
		WHERE  session_id  = @v_sess_id 
		
		delete from temp_col_ins where col_value='''''' or col_value=''  and session_id=@v_sess_id 

		SET @vrec='select * from '+@ptable_name+' where ';

		SET @vformat  = @pdateformat 

		DECLARE cur_stmt cursor  FOR 
		SELECT COL_NAME,COL_VALUE,COL_DATA_TYPE  FROM  temp_col_ins WHERE	 session_id  = @v_sess_id ORDER BY sqno 
		

    OPEN cur_stmt 
		fetch NEXT FROM cur_stmt INTO @COL_NAME,@COL_VALUE1,@COL_DATATYPE
         while(@@FETCH_STATUS = 0)
			BEGIN 
               print(@COL_NAME) 
                print(@COL_VALUE1) 
                print(@COL_DATATYPE) 

				IF  ( @COL_DATATYPE = 'DATETIME') 
					BEGIN 
--                            print('11')
--                           print(@COL_NAME) 
--                print(@COL_VALUE1) 
--                print(@COL_DATATYPE) 
                         
						declare @finaldate varchar(4000)
						declare @count_dat int
						set @count_dat=0
						declare cur_date cursor for

						select item from Split_date(@COL_VALUE1,'/')
                     --   print(item)
						 open cur_date

						fetch NEXT FROM cur_date into @item
						while(@@FETCH_STATUS = 0)

							BEGIN  
							IF(LOWER(@pdateformat)='mm/dd/yyyy')
								begin
--                                print(@item)
								if @count_dat=0
									set @month= @item
								else if @count_dat=1
									set @day= @item
								else  
									set @year= @item
								  fetch NEXT FROM cur_date into @item
								  set @count_dat=@count_dat+1
								  
								end

					
							IF(LOWER(@pdateformat)='dd/mm/yyyy')
								begin
--                                  print(@item)
								if @count_dat=0
									set @day= @item
								else if @count_dat=1
									set @month= @item
								else  
									set @year= @item
								  fetch NEXT FROM cur_date into @item
								  set @count_dat=@count_dat+1
--								   print(@item)
--                                   print('22')
--                                    print(@day)
--                                     print(@month)
--                                       print(@year)
								end
						
							IF(LOWER(@pdateformat)='yyyy/mm/dd')
								begin
								if @count_dat=0
									set @year= @item
								else if @count_dat=1
									set @month= @item
								else  
									set @day= @item
								  fetch NEXT FROM cur_date into @item
								  set @count_dat=@count_dat+1
								  
								end
							end
						CLOSE cur_date
						DEALLOCATE cur_date 

 
                           

set @day =  replace(@day,'''','')
set @month =  replace(@month,'''','')
set @year =  replace(@year,'''','')

 

--						IF(LOWER(@pdateformat)='dd/mm/yyyy')
--							set @finaldate=COALESCE(@day + '/', SPACE(0))  + COALESCE(@month + '/', SPACE(0))+COALESCE(@year + '', SPACE(0))

						--IF(LOWER(@pdateformat)='mm/dd/yyyy')
							set @finaldate=COALESCE(@month + '/', SPACE(0))  + COALESCE(@day + '/', SPACE(0))+COALESCE(@year + '', SPACE(0))

--						IF(LOWER(@pdateformat)='yyyy/mm/dd')
--							set @finaldate=COALESCE(@year + '/', SPACE(0))  + COALESCE(@month + '/', SPACE(0))+COALESCE(@day + '', SPACE(0))



						set @finaldate=replace(@finaldate,'''','')
                              print('4440')
                             print(@col_val)
						--	SET @col_val = COALESCE(@col_val + ',', SPACE(0)) + '' + COALESCE(@finaldate + '', SPACE(0))
                              SET @vrec=@vrec + @COL_NAME+'='+''''+@finaldate+''''+ ' and  ';
                            print(@vrec)
			
					END;
					else if(@COL_DATATYPE = 'numeric')
					begin
                            print('333')
                            print(@COL_NAME) 
							print(@COL_VALUE1) 
							print(@COL_DATATYPE) 

SET @col_val = COALESCE(@col_val + '', SPACE(0)) + '' + 'convert( int,' + COALESCE(@COL_VALUE1 + '', SPACE(0))+')'						
--							SET @col_val = COALESCE(@col_val + ',', SPACE(0)) + '' + 'convert( int,' + COALESCE(@COL_VALUE1 + '', SPACE(0))+')'
                             print(@col_val)
                              SET @vrec=@vrec + @COL_NAME+'='+@col_val+ ' and  ';
                               print(@vrec)
                              SET @col_val = '';

					end
				ELSE
					BEGIN
					      SET @vrec=@vrec + '(('+@COL_NAME+'='+@COL_VALUE1+') or ('+@COL_NAME +' like '+@COL_VALUE1+')) and   ';
                       
                          print(@vrec);
						END;   
				fetch NEXT FROM cur_stmt INTO @COL_NAME,@COL_VALUE1,@COL_DATATYPE
			END 

--print @vrec;
              
			SET @col_val =COALESCE(substring(@col_val,1,len(@col_val)),SPACE(0))
			SET @vrec=  COALESCE(@vrec,SPACE(0)) + COALESCE(@col_val,SPACE(0)) + ')'
            declare   @len11 INT;
               print('444'); 
              print(@col_val); 
             print('4441'); 
              print(@vrec)
            SET @len11= LEN(@vrec)

            print(@len11)

            SET @len11= @len11 - 6; 

           SET @vrec=SUBSTRING(@vrec,0,@len11)

             print(@vrec)
             

			SET @vlength  = null 
			SET @vcolval  = null 
			SET @vrunval  = null 
			SET @vcol_name  = null 
			SET @vno  = null 
						
--		UPDATE   temp_col_ins   
--		SET	upd_str = @vrec 
--		WHERE  session_id  = @v_sess_id
		if @pextra1 is null or @pextra1='' or @pextra1=null
			begin
				set @vrec=@vrec +' order by 1'
			end
        else
			begin
				set @vrec=@vrec +' order by '+ @pextra1
			end

PRINT (@vrec)
EXEC (@vrec)
 DEALLOCATE cur_stmt 














******************************************************************************************************************************************************************************************
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROCEDURE [dbo].[cir_dynamic_update_stmt] 
   @ptable_name  varchar(2000),
   @pcolname  varchar(2000),
   @pcolvalue  varchar(2000),
   @pcond_colname  varchar(2000),
   @pdelimiter  varchar(2000),
   @pdateformat  varchar(2000),
   @pextra1  varchar(2000),
   @pextra2  varchar(2000)

as 
--	rec_stmt cur_stmt%rowtype;

--	rec_upd_stmt cur_upd_stmt%rowtype;

	DECLARE @vcol_name                            VARCHAR(100) 
	DECLARE @v_sess_id                            FLOAT 
	declare @pstmt_str							  varchar(4000);
	declare @vlength 							  int;
	declare @vcolval 							  varchar(4000);
	declare @vrunval 							  varchar(1);	
	declare @vno 								  int;
	declare @vrec 							      varchar(4000);
	declare @vrec_upd 							  varchar(4000);
	declare @vpextra1 							  varchar(4000);
	declare @vformat 							  varchar(20);
	DECLARE	 @COL_DATA_TYPE1					  VARCHAR(200);
    DECLARE	 @COL_VALUE1						  VARCHAR(2000);
	DECLARE	 @COL_NAME							  VARCHAR(2000);
	declare @col_val							  varchar(4000);
	declare @upd_col_val						  varchar(4000);
	DECLARE	 @UPD_COL_NAME						  VARCHAR(2000);
	DECLARE	 @UPD_COL_DATA_TYPE1				  VARCHAR(200);
    DECLARE	 @UPD_COL_VALUE1					  VARCHAR(2000);
	DECLARE @i									  INT

		SET  @i  = 1 
Begin
set @v_sess_id = (select @@spid)
SET @vcol_name  = null 
delete from test1
	insert into test1(vstring) values (@vrec+@vrec_upd+@ptable_name+','+@pcolname+','+
                                       @pcolvalue+','+@pcond_colname+','+@pdelimiter+','+
                                       @pdateformat+','+@pextra1+','+@pextra2);
	Begin
		delete from temp_col_ins where session_id=@@spid;

	set	@vlength=null;	set @vcolval=null; set	@vrunval=null;	set @vcol_name=null;	set @vno=null;

		set @vcolval=replace(@pcolname,@pdelimiter,',');	set @vlength=len(@vcolval);	set @vno=1;
		WHILE @i <= @vlength 
		  BEGIN			
			SET @vrunval  = SUBSTRING(@vcolval, @i, 1)
			IF @vrunval != ',' 
			  BEGIN 
				SET @vcol_name  =  RTRIM(LTRIM(COALESCE(@vcol_name,space(0)) +  COALESCE(@vrunval,space(0))))
			  END
			ELSE
			 BEGIN
				INSERT INTO  temp_col_ins  ( sqno , col_name , session_id )  
				 VALUES ( @vno , LTRIM(RTRIM(@vcol_name)) , @v_sess_id )  				
				SET @vno  = @vno + 1 
				SET @vcol_name  = '' 
			END
			SET @i = @i + 1
		END

		set @vlength=null;	set @vcolval=null;	set @vrunval=null;	set @vcol_name=null;	set @vno=null;
		
		set @vcolval=replace(@pcolvalue,',','~~~');

		set @vcolval=replace(@vcolval,@pdelimiter,',');	
		set @vlength=len(@vcolval);	
		set @vno =1;
		set @i=1;
		

set @i=1
		while @i<=@vlength
		  begin

			set @vrunval=substring(@vcolval,@i,1);
			 if @vrunval!=','

				begin

					set @vcol_name= COALESCE(@vcol_name + '', SPACE(0))+COALESCE(@vrunval + '', SPACE(0));
				end
			 else
				begin
					set @vcol_name=replace(@vcol_name,'~~~',',');

				   update temp_col_ins set col_value=@vcol_name where sqno=@vno and session_id=@@spid;
		  		   set @vno=@vno+1;
				   set @vcol_name='';
				end
			SET @i = @i + 1
		  end
		
		
/*Start New Change For Old and New Concept */
		if @pextra1='' or @pextra1 is null
			begin			 
              
         --   print('1')
			set @vpextra1=@pcolvalue;
			end
		else
			begin
           --   print('2')
           ---     print(@pextra1)
              --    print('2243')
			 set @vpextra1=@pextra1;
			end
		
		set @vlength=null;	
        set @vcolval=null;	
        set @vrunval=null;	
        set @vcol_name=null;	
        set @vno=null;

		print(@vpextra1)
		set @vcolval=replace(@vpextra1,',','~~~');
		
	print(@pdelimiter)
		set @vcolval=replace(@vcolval,@pdelimiter,',');	
	print(@vcolval)
		set @vlength=len(@vcolval);	
		set @vno=1;
set @i=1;
		while @i <=@vlength
			begin
              set @vrunval = substring(@vcolval,@i,1);
            
			if @vrunval!=','
				begin

                 
  
					set @vcol_name=COALESCE(@vcol_name + '', SPACE(0))+COALESCE(@vrunval + '', SPACE(0));
                     
                 
				end
		  		 
				else	
				 begin

                  
					set @vcol_name=replace(@vcol_name,'~~~',',');
              
					update temp_col_ins set col_value_old=@vcol_name where sqno=@vno and session_id=@@spid;
		  			set @vno=@vno+1;
					set @vcol_name='';
				 end
SET @i = @i + 1
			end
		
		/*End New Change For Old and New Concept */
		update temp_col_ins set col_data_type=(select DATA_TYPE from INFORMATION_SCHEMA.COLUMNS
		 where TABLE_NAME = upper(ltrim(rtrim(@ptable_name))) and column_name = upper(ltrim(rtrim(temp_col_ins.col_name))))
			where session_id=@@spid;
declare  cur_stmt cursor for  select COL_NAME,COL_VALUE,COL_DATA_TYPE from temp_col_ins  where session_id=@@spid order by sqno;
		
		set @vrec='update '+@ptable_name+' set ';
		--select "date_format" into vformat from preferrences;
          set @vformat=@pdateformat;
		OPEN cur_stmt 
		fetch NEXT FROM cur_stmt INTO @COL_NAME,@COL_VALUE1,@COL_DATA_TYPE1
         while(@@FETCH_STATUS = 0)
			BEGIN  
				
				IF  ( @COL_DATA_TYPE1 = 'datetime') 
					BEGIN 
						declare @finaldate varchar(4000)
						declare @count_dat int
						set @count_dat=0
				
						if @COL_VALUE1!=''
						begin
							set @finaldate=(select dbo.convert_user_date('/',@COL_VALUE1,@pdateformat))
				
						 end
						if @finaldate='/'
						 begin
					      set @finaldate=''''
						end
						set @finaldate=''''+replace(@finaldate,'''','')+''''
						
					SET @col_val = COALESCE(@col_val + ',', SPACE(0)) + ''+ @COL_NAME+'='+ COALESCE(@finaldate + '', SPACE(0))
					
print('asada')
print(@finaldate)
					END;
				else if(@COL_DATA_TYPE1 = 'numeric')
					begin	
                            declare @len112 int
                            set @len112 = len(@COL_VALUE1)	
                            if(@len112 > 9)

                            begin 
                             
                                 SET @col_val = COALESCE(@col_val + ',', SPACE(0)) + ''+ @COL_NAME+'=' + 'cast( ' + COALESCE(@COL_VALUE1 + '', SPACE(0))+' as varchar )'
                            end

                            else

                            begin		
                                
							    SET @col_val = COALESCE(@col_val + ',', SPACE(0)) + ''+ @COL_NAME+'=' + 'convert( float,' + COALESCE(@COL_VALUE1 + '', SPACE(0))+')'
                            end
							
					end
				ELSE
					BEGIN						
						SET @col_val = COALESCE(@col_val + ',', SPACE(0)) + '' + @COL_NAME+'='+ COALESCE(@COL_VALUE1 + '', SPACE(0))
						

						END;   
				fetch NEXT FROM cur_stmt INTO @COL_NAME,@COL_VALUE1,@COL_DATA_TYPE1
			END 
		  --set @vrec=substring(@vrec,1,len(@vrec)-1);
		  set @vlength=null;	set @vcolval=null;	set @vrunval=null;	set @vcol_name=null;	set @vno=null;

		set @vcolval=replace(@pcond_colname,@pdelimiter,',');	
		
set @vlength=len(@vcolval);
	set @i=1
		while @i<= @vlength
			begin
		set @vrunval=substring(@vcolval,@i,1);
				if @vrunval!=','
					begin		
						set @vcol_name=COALESCE(@vcol_name + '', SPACE(0))+COALESCE(@vrunval + '', SPACE(0));						
					end
				else
					begin
						
						update temp_col_ins set upd_flag='U' where col_name=@vcol_name and session_id=@@spid;
						set @vcol_name='';
					end
				SET @i = @i + 1
			end
		
	  close cur_stmt;

		if @pcond_colname is not null

			begin
		 		set @vrec_upd=' where ';
			end
		else
			begin
		 	set @vrec_upd='';
		end
	declare cur_upd_stmt cursor for   select COL_NAME,COL_VALUE_OLD,COL_DATA_TYPE from temp_col_ins  where isnull(upd_flag,'N')='U' and session_id=@@spid;
		open cur_upd_stmt	
		  fetch Next from cur_upd_stmt into @UPD_COL_NAME,@UPD_COL_VALUE1,@UPD_COL_DATA_TYPE1
		while(@@FETCH_STATUS = 0)
			BEGIN  
				IF(@UPD_COL_DATA_TYPE1 = 'datetime') 
					BEGIN						
						set @count_dat=0		
						
						if @UPD_COL_VALUE1!=''
						begin
							set @finaldate=(select dbo.convert_user_date('/',@UPD_COL_VALUE1,@pdateformat))
						 end
						if @finaldate='/'
						 begin
					      set @finaldate=''''
						end
						set @finaldate=''''+replace(@finaldate,'''','')+''''
						SET @upd_col_val = COALESCE(@upd_col_val + ' ', SPACE(0)) + ' ' + @UPD_COL_NAME+'='+ COALESCE(@finaldate + ' ', SPACE(0)) +' and'
						
					END;
				else if(@UPD_COL_DATA_TYPE1 = 'numeric')
					begin
                           
							SET @upd_col_val = COALESCE(@upd_col_val + ' ', SPACE(0)) + ' '+ @UPD_COL_NAME+'=' + 'convert( int,' + COALESCE(@UPD_COL_VALUE1 +  '', SPACE(0))+')'+' and'
							
					end
				ELSE
					BEGIN
						
						SET @upd_col_val = COALESCE(@upd_col_val + ' ', SPACE(0)) + ' ' + @UPD_COL_NAME+'='+ COALESCE(@UPD_COL_VALUE1 + ' ', SPACE(0))+ ' and'
						
						END;   
				fetch NEXT FROM cur_upd_stmt INTO @UPD_COL_NAME,@UPD_COL_VALUE1,@UPD_COL_DATA_TYPE1
			END 
		 close cur_upd_stmt;
		 set @upd_col_val=substring(@upd_col_val,1,len(@upd_col_val)-4);
		set @upd_col_val=COALESCE(@vrec_upd + '', SPACE(0))+ COALESCE(@upd_col_val + '', SPACE(0))
    declare @query1 varchar(2000)
set @query1 =COALESCE(@vrec + '', SPACE(0))+COALESCE(@col_val+ '', SPACE(0))+COALESCE(@upd_col_val+ '', SPACE(0));

	 update temp_col_ins set upd_str=COALESCE(@vrec + '', SPACE(0))+COALESCE(@col_val+ '', SPACE(0))+COALESCE(@upd_col_val+ '', SPACE(0)) where session_id=@@spid --and rownum<2;
		 
	End;
	 insert into test1(vstring) values (COALESCE(@vrec + '', SPACE(0))+COALESCE(@col_val+ '', SPACE(0))+COALESCE(@upd_col_val+ '', SPACE(0)));     
	   
print (@query1)
exec (@query1)
DEALLOCATE cur_stmt
DEALLOCATE cur_UPD_stmt
End 







************************************************************************************************************************************************************
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER PROCEDURE [dbo].[cir_dynamic_dml_variable_delete_stmt]
	@ptable_name                              VARCHAR(4000) ,
	@pcond_colname                                 VARCHAR(4000) ,
	@pcond_colval                                VARCHAR(4000) ,
	@pdelimiter                               VARCHAR(4000) ,
	@pdateformat                              VARCHAR(4000) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS
    	DECLARE @pstmt_str                                VARCHAR(4000) 
		DECLARE @v_sess_id                                FLOAT 
		DECLARE @rec_stmt    VARCHAR(200)		
		DECLARE @vlength                                  NUMERIC(5) 
		DECLARE @vcolval                                  VARCHAR(4000) 
		DECLARE @vrunval                                  VARCHAR(1) 
		DECLARE @vcol_name                                VARCHAR(100) 
		DECLARE @vno                                      NUMERIC(5) 
		DECLARE @vrec                                     VARCHAR(4000) 
		DECLARE @vrec_upd                                 VARCHAR(4000) 
		DECLARE @vformat                                  VARCHAR(20) 
		DECLARE @v_col_exists                             NUMERIC(5) 
        DECLARE	 @COL_NAME    VARCHAR(200) 
        DECLARE	 @COL_VALUE1    VARCHAR(2000) 
		DECLARE @COL_DATA_TYPE1 VARCHAR(4000)
		declare @item varchar(4000)
		declare @day varchar(4000)
		declare @month varchar(4000)
		declare @year varchar(4000)
		declare @ss numeric(8)
		declare @vrec_val varchar(4000)
		declare @abj numeric(8)
		declare @col_val varchar(4000)
		declare @col_val1 varchar(4000)
		INSERT INTO  test1   ( vstring )   VALUES 	( CAST(@pcond_colname AS VARCHAR) + '33333' + CAST(@pcond_colval AS VARCHAR) )  
		set @v_sess_id = (select @@spid)
		DELETE FROM   temp_col_ins   WHERE  session_id  = (select @@spid)
		SET @vlength  = null 
		SET @vcolval  = null 
		SET @vrunval  = null 
		SET @vcol_name  = null 
		SET @vno  = null 
		SET @vcolval  = REPLACE(@pcond_colname, @pdelimiter, ',')
		SET @vlength  = LEN(@vcolval)
		SET @vno  = 1 
		SET  @ss  = 1
		set @vrec_val =null

        DECLARE @i INT

		SET  @i  = 1 

		WHILE @i <= @vlength 
		  BEGIN			
			SET @vrunval  = SUBSTRING(@vcolval, @i, 1)
			IF @vrunval != ',' 
			  BEGIN 
				SET @vcol_name  =  COALESCE(@vcol_name,space(0)) +  COALESCE(@vrunval,space(0))				
			  END
			ELSE
			 BEGIN				
				INSERT INTO  temp_col_ins  ( sqno , col_name , session_id )  
				 VALUES ( @vno , UPPER(LTRIM(RTRIM(@vcol_name))) , @v_sess_id )  				
				SET @vno  = @vno + 1 
				SET @vcol_name  = '' 
			END
			SET @i = @i + 1
		END 
		SELECT @v_col_exists  =  COUNT(*) FROM  temp_col_ins WHERE	 session_id  = @v_sess_id AND	col_name  = UPPER(LTRIM(RTRIM(@vcol_name)))		
		IF ISNULL(@v_col_exists, 0)= 0 
		BEGIN 
			INSERT INTO  temp_col_ins   ( sqno , col_name , session_id )   VALUES ( @vno , UPPER(@vcol_name) , @v_sess_id )			
		END
		SET @vlength  = null 
		SET @vcolval  = null 
		SET @vrunval  = null 
		SET @vcol_name  = null 
		SET @vno  = null 

		IF CHARINDEX(',', @pcond_colval)> 0 or CHARINDEX('''', @pcond_colval)> 0 
    		BEGIN 
	    		SET @vcolval  = REPLACE(@pcond_colval, ',', '~~~')
		END
		ELSE
		 BEGIN 
			SET @vcolval  = @pcond_colval 
		END
   
		SET @vcolval  = REPLACE(@vcolval, @pdelimiter, ',')
		SET @vlength  = LEN(@vcolval)
		SET @vno  = 1 
        SET @i = 1 
		
		WHILE @i <= @vlength 
		BEGIN
		SET @vrunval  = SUBSTRING(@vcolval, @i, 1)
			IF @vrunval != ',' 
			BEGIN 
				SELECT @vcol_name  = COALESCE(@vcol_name,space(0)) + COALESCE(@vrunval,space(0))
			END
			ELSE
			BEGIN 
				SELECT @vcol_name  = REPLACE(@vcol_name, '~~~', ',')
				UPDATE  temp_col_ins   
				SET	col_value = COALESCE(@vcol_name,space(0))
				WHERE  sqno  = @vno
				 AND	session_id  = @v_sess_id 
				
				SET @vno  = @vno + 1 
				SET @vcol_name  = '' 
			END

			SET @i = @i + 1

		END
		IF @vcol_name is not null 
		BEGIN 
			UPDATE  temp_col_ins   
			SET	col_value = COALESCE(@vcol_name,space(0))
			WHERE  sqno  = @vno
			 AND	session_id  = @v_sess_id 
		END
   
		UPDATE  temp_col_ins   
		SET	col_data_type = (SELECT DATA_TYPE
			FROM  INFORMATION_SCHEMA.COLUMNS
			WHERE	 TABLE_NAME  = UPPER(LTRIM(RTRIM(@ptable_name)))
			 AND	column_name  = UPPER(LTRIM(RTRIM(temp_col_ins.col_name)))
		) 
		WHERE  session_id  = @v_sess_id 
		
		delete from temp_col_ins where col_value='''''' or col_value=''  and session_id=@v_sess_id 

		SET @vrec='delete from '+@ptable_name+' where ';

		SET @vformat  = @pdateformat 

		DECLARE cur_stmt cursor  FOR 
		SELECT COL_NAME,COL_VALUE,COL_DATA_TYPE  FROM  temp_col_ins WHERE	 session_id  = @v_sess_id AND COL_NAME!='' ORDER BY sqno 
		

    OPEN cur_stmt 
		fetch NEXT FROM cur_stmt INTO @COL_NAME,@COL_VALUE1,@COL_DATA_TYPE1
         while(@@FETCH_STATUS = 0)
			BEGIN  
				IF  ( @COL_DATA_TYPE1 = 'datetime') 
					BEGIN 
						declare @finaldate varchar(4000)
						declare @count_dat int
						set @count_dat=0
						
						
						if @COL_VALUE1!=''
						begin
							set @finaldate=(select dbo.convert_user_date('/',@COL_VALUE1,@pdateformat))
							
						end
						if @finaldate='/'
						begin
							set @finaldate=''''
						end
						set @finaldate=''''+replace(@finaldate,'''','')+''''
						
						print @finaldate
						
					--SET @col_val = COALESCE(@col_val + ',', SPACE(0)) + '' + COALESCE(@finaldate + '', SPACE(0))
						SET @vrec=@vrec +@COL_NAME+'='+COALESCE(@finaldate + '', SPACE(0))+' and   ';
					end
				else if(@COL_DATA_TYPE1 = 'numeric')
					begin
						SET @col_val = COALESCE(@col_val + ',', SPACE(0)) + '' + 'convert( int,' + COALESCE(@COL_VALUE1 + '', SPACE(0))+')'
						SET @vrec=@vrec +@COL_NAME+'='+COALESCE(@COL_VALUE1 + '', SPACE(0))+' and   ';
					end
				ELSE
					BEGIN
						PRINT @COL_NAME
					    SET @vrec=@vrec +@COL_NAME+'='+COALESCE(@COL_VALUE1 + '', SPACE(0))+' and   ';
                          
					END;   
				fetch NEXT FROM cur_stmt INTO @COL_NAME,@COL_VALUE1,@COL_DATA_TYPE1
			END 


			--SET @col_val =COALESCE(substring(@col_val,1,len(@col_val)),SPACE(0))
			--SET @vrec=  COALESCE(@vrec,SPACE(0)) + COALESCE(@col_val,SPACE(0)) + ')'
 declare   @len11 INT;
              
         SET @len11= LEN(@vrec)
          print(@len11)

          SET @len11= @len11 - 3; 

         SET @vrec=SUBSTRING(@vrec,0,@len11)

             print(@vrec)
             

			SET @vlength  = null 
			SET @vcolval  = null 
			SET @vrunval  = null 
			SET @vcol_name  = null 
			SET @vno  = null 
						
--		UPDATE   temp_col_ins   
--		SET	upd_str = @vrec 
--		WHERE  session_id  = @v_sess_id

     PRINT @vrec
		EXEC (@vrec)
 DEALLOCATE cur_stmt 



***********************************************************************************************************************************************************************************************************************************
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go






ALTER PROCEDURE [dbo].[fa_check_duplicacy_fa_check_duplicacy_p]
	@pcomp_col         as                       VARCHAR(4000) ,
	@pcomp_val         as                       VARCHAR(4000) ,
	@punit_col         as                       VARCHAR(4000) ,
	@punit_val         as                       VARCHAR(4000) ,
	@ptbl_name         as                       VARCHAR(4000) ,
	@pdesc_col         as                       VARCHAR(4000) ,
	@pdesc_val         as                       VARCHAR(4000) ,
	@palias_col        as                       VARCHAR(4000) ,
	@palias_val        as                       VARCHAR(4000) ,
	@pdateformat       as                       VARCHAR(4000) ,
	@pextra1           as                       VARCHAR(4000) ,
	@pextra2           as                       VARCHAR(4000) 
AS 
	

		
		
		DECLARE @v_str1        as                           VARCHAR(2000) 
		DECLARE @v_str2        as                           VARCHAR(2000) 
		DECLARE @v_cnt1        as                           NUMERIC(5)                      
		SET @v_cnt1 = 0 
		DECLARE @v_cnt2        as                           NUMERIC(5)                      
		SET @v_cnt2 = 0 
		DECLARE @v_comp_exists  as                          NUMERIC(1)                      
		SET @v_comp_exists = 0 
		DECLARE @v_unit_exists  as                          NUMERIC(1)                      
		SET @v_unit_exists = 0 
		

        print('1')       

        SELECT @v_str1  = 'pcomp_col' + @pcomp_col + ' pcomp_val' + @pcomp_val + ' punit_col' + @punit_col + ' punit_val' + @punit_val + ' ptbl_name' + @ptbl_name + ' pdesc_col' + @pdesc_col + ' pdesc_val' + @pdesc_val + ' palias_col' + @palias_col + ' palias_val' + @palias_val 
		INSERT INTO  test1   ( vstring , vstring2 )  VALUES ( ' duplicacy ' , @v_str1 )  
		
         print(@v_str1)     		

		-- IMPLICIT_TRANSACTIONS is set to OFF
		DELETE FROM   cir_chk_duplicacy1   WHERE  1  = 1 
		
		SELECT @v_comp_exists  =  COUNT(*) FROM   INFORMATION_SCHEMA.COLUMNS WHERE	 TABLE_NAME  = @ptbl_name AND	column_name  = @pcomp_col
		
		INSERT INTO  test1   ( vstring , vstring2 )   VALUES ( ' v_comp_exists ' , @v_comp_exists )  
		
		
		-- IMPLICIT_TRANSACTIONS is set to OFF
		SELECT @v_unit_exists  =  COUNT(*) FROM   INFORMATION_SCHEMA.COLUMNS WHERE	 TABLE_NAME  = @ptbl_name AND	column_name  = @punit_col
		
		INSERT INTO  test1   ( vstring , vstring2 )   VALUES ( ' v_unit_exists ' , @v_unit_exists )  
		
		
		-- IMPLICIT_TRANSACTIONS is set to OFF
		SELECT @v_cnt1  =  COUNT(*) FROM   INFORMATION_SCHEMA.COLUMNS WHERE	 TABLE_NAME  = @ptbl_name AND	column_name  = @pdesc_col
		
		INSERT INTO  test1  ( vstring , vstring2 )   VALUES ( ' v_cnt1 ' , @v_cnt1 )  
		
		
		-- IMPLICIT_TRANSACTIONS is set to OFF
		SELECT @v_cnt2  =  COUNT(*) FROM   INFORMATION_SCHEMA.COLUMNS WHERE	 TABLE_NAME  = @ptbl_name AND	column_name  = @palias_col
		
		INSERT INTO  test1   ( vstring , vstring2 )  VALUES ( ' v_cnt2 ' , @v_cnt2 )  
		
		
		-- IMPLICIT_TRANSACTIONS is set to OFF
		
		IF (@v_cnt1 = 1 and @v_cnt2 = 0 )
		BEGIN 
			
			IF (@v_comp_exists = 1 and @v_unit_exists = 0 )
				BEGIN 
					--if comp code exists and unit code not exists in table
					--v_str1:=' insert into cir_chk_duplicacy(rec_name1) select count(*) from '||ptbl_name||' where '||pcomp_col||'='||''''||pcomp_val||''''||' and '||pdesc_col||'='||''''||pdesc_val||'''';
					
					SELECT @v_str1  = ' insert into cir_chk_duplicacy1(rec_name1) select count(*) from ' + @ptbl_name + ' where  ' + @pcomp_col + '=' + @pcomp_val + ' and upper(' + @pdesc_col + ')= upper(' + @pdesc_val + ')' 
					
				END
			ELSE IF (@v_comp_exists = 1 and @v_unit_exists = 1 )
				BEGIN 
					--if both are existng in table
					--v_str1:=' insert into cir_chk_duplicacy(rec_name1) select count(*) from '||ptbl_name||' where '||pcomp_col||'='||''''||pcomp_val||''''||' and '||punit_col||'='||''''||punit_val||''''||' and '||pdesc_col||'='||''''||pdesc_val||'''';
					
					SELECT @v_str1  = ' insert into cir_chk_duplicacy1(rec_name1) select count(*) from ' + @ptbl_name + ' where  ' + @pcomp_col + '=' + @pcomp_val + ' and ' + @punit_col + '=' + @punit_val + ' and upper(' + @pdesc_col + ')= upper(' + @pdesc_val + ')' 
					
				END
			ELSE 
				BEGIN 
					--if both are not existng in table
					--v_str1:=' insert into cir_chk_duplicacy(rec_name1) select count(*) from '||ptbl_name||' where '||pdesc_col||'='||''''||pdesc_val||'''';
					
					SELECT @v_str1  = ' insert into cir_chk_duplicacy1(rec_name1) select count(*) from ' + @ptbl_name + ' where upper(' + @pdesc_col + ')= upper(' + @pdesc_val + ')' 
				END
   
			INSERT INTO  test1   ( vstring , vstring2 )   VALUES 		( ' 1duplicacy ' , @v_str1 )  
			
			
			-- IMPLICIT_TRANSACTIONS is set to OFF
			
			--SELECT @v_str1  = insert into cir_chk_duplicacy(rec_name1) select count(*) from
print(@v_str1)
			EXEC (@v_str1)

			
		END
		ELSE IF (@v_cnt1 = 0 and @v_cnt2 = 1)
		BEGIN 
print('garima')
print(@v_comp_exists)
print(@v_unit_exists)			

			IF (@v_comp_exists = 1 and @v_unit_exists = 0) 
				BEGIN 
					--if comp code exists and unit code not exists in table
					--v_str2:=' insert into cir_chk_duplicacy(rec_name2) select count(*) from '||ptbl_name||' where '||pcomp_col||'='||''''||pcomp_val||''''||' and '||palias_col||'='||''''||palias_val||'''';
					
					SELECT @v_str2  = ' insert into cir_chk_duplicacy1(rec_name2) select count(*) from ' + @ptbl_name + ' where  ' + @pcomp_col + '=' + @pcomp_val + ' and upper(' + @pdesc_col + ')=upper(' + @pdesc_val + ')' 
					
				END
			ELSE IF (@v_comp_exists = 1 and @v_unit_exists = 1) 
				BEGIN 
					--if both are existng in table
					--v_str2:=' insert into cir_chk_duplicacy(rec_name2) select count(*) from '||ptbl_name||' where '||pcomp_col||'='||''''||pcomp_val||''''||' and '||punit_col||'='||''''||punit_val||''''||' and '||palias_col||'='||''''||palias_val||'''';
					
					SELECT @v_str2  = ' insert into cir_chk_duplicacy1(rec_name2) select count(*) from ' + @ptbl_name + ' where  ' + @pcomp_col + '=' + @pcomp_val + ' and ' + @punit_col + '=' + @punit_val + ' and upper(' + @pdesc_col + ')=upper(' + @pdesc_val + ')' 
				
				END
			ELSE
				BEGIN 
					--if both are not existng in table
					--v_str2:=' insert into cir_chk_duplicacy(rec_name2) select count(*) from '||ptbl_name||' where '||palias_col||'='||''''||palias_val||'''';
					
					SELECT @v_str2  = ' insert into cir_chk_duplicacy1(rec_name2) select count(*) from ' + @ptbl_name + ' where upper(' + @pdesc_col + ')=upper(' + @pdesc_val + ')' 
				END
   
			INSERT INTO  test1   ( vstring , vstring2 )   VALUES ( ' 2duplicacy ' , @v_str2 )  
			
			
			-- IMPLICIT_TRANSACTIONS is set to OFF
			
			--SELECT @v_str2  = insert into cir_chk_duplicacy(rec_name2) select count(*) from
print(@v_str2)
			EXEC (@v_str2)
			
		END
		ELSE IF (@v_cnt1 = 1 and @v_cnt2 = 1) 
		BEGIN 
			
			IF (@v_comp_exists = 1 and @v_unit_exists = 0 )
			BEGIN 
				--if comp code exists and unit code not exists in table
				--v_str1:=' insert into cir_chk_duplicacy(rec_name1) select count(*) from '||ptbl_name||' where '||pcomp_col||'='||''''||pcomp_val||''''||' and '||pdesc_col||'='||''''||pdesc_val||'''';
				
				SELECT @v_str1  = ' insert into cir_chk_duplicacy1(rec_name1) select count(*) from ' + @ptbl_name + ' where  ' + @pcomp_col + '=' + @pcomp_val + ' and upper(' + @pdesc_col + ')=upper(' + @pdesc_val + ')' 
				 	print(@v_str1);
			END
			ELSE IF (@v_comp_exists = 1 and @v_unit_exists = 1 )
			BEGIN 
				--if both are existng in table
				--v_str1:=' insert into cir_chk_duplicacy(rec_name1) select count(*) from '||ptbl_name||' where '||pcomp_col||'='||''''||pcomp_val||''''||' and '||punit_col||'='||''''||punit_val||''''||' and '||pdesc_col||'='||''''||pdesc_val||'''';
				
				SELECT @v_str1  = ' insert into cir_chk_duplicacy1(rec_name1) select count(*) from ' + @ptbl_name + ' where  ' + @pcomp_col + '=' + @pcomp_val + ' and ' + @punit_col + '=' + @punit_val + ' and upper(' + @pdesc_col + ')=upper(' + @pdesc_val + ')' 
				 	print(@v_str1);
			END
			ELSE
			BEGIN 
				--if both are not existng in table
				--v_str1:=' insert into cir_chk_duplicacy(rec_name1) select count(*) from '||ptbl_name||' where '||pdesc_col||'='||''''||pdesc_val||'''';
				
				SELECT @v_str1  = ' insert into cir_chk_duplicacy1(rec_name1) select count(*) from ' + @ptbl_name + ' where upper(' + @pdesc_col + ')=upper(' + @pdesc_val + ')' 
		       	print(@v_str1);
            END
   
			INSERT INTO  test1   ( vstring , vstring2 )   VALUES ( ' 3duplicacy ' , @v_str1 )  
			
			
			-- IMPLICIT_TRANSACTIONS is set to OFF
			
		--	SELECT @v_str1  = insert into cir_chk_duplicacy(rec_name1) select count(*) from
			EXEC (@v_str1)
		
			IF (@v_comp_exists = 1 and @v_unit_exists = 0 )
			BEGIN 
				--if comp code exists and unit code not exists in table
				--v_str2:=' update cir_chk_duplicacy set rec_name2=(select count(*) from '||ptbl_name||' where '||pcomp_col||'='||''''||pcomp_val||''''||' and '||palias_col||'='||''''||palias_val||''''||')';
				
				SELECT @v_str2  = ' update cir_chk_duplicacy1 set rec_name2=(select count(*) from ' + @ptbl_name + ' where  ' + @pcomp_col + ' = ' + @pcomp_val + ' and upper(' + @palias_col + ') = upper(' + @palias_val + ')' + ')' 
				print(@v_str2);
			END
			ELSE IF (@v_comp_exists = 1 and @v_unit_exists = 1)
			BEGIN 
				--if both are existng in table
				--v_str2:=' update cir_chk_duplicacy set rec_name2=(select count(*) from '||ptbl_name||' where '||pcomp_col||'='||''''||pcomp_val||''''||' and '||punit_col||'='||''''||punit_val||''''||' and '||palias_col||'='||''''||palias_val||''''||')';
				
				SELECT @v_str2  = ' update cir_chk_duplicacy1 set rec_name2 = (select count(*) from ' + @ptbl_name + ' where  ' + @pcomp_col + ' = ' + @pcomp_val + ' and ' + @punit_col + '=' + @punit_val + ' and upper(' + @palias_col + ')= upper(' + @palias_val + ')' + ')' 
				print(@v_str2);
			END
			ELSE
			BEGIN 
				--if both are not existng in table
				--v_str2:=' update cir_chk_duplicacy set rec_name2=(select count(*) from '||ptbl_name||' where '||palias_col||'='||''''||palias_val||''''||')';
				
				SELECT @v_str2  = ' update cir_chk_duplicacy1 set rec_name2 = (select count(*) from ' + @ptbl_name + ' where upper ( ' + @palias_col + ') = upper ( ' + @palias_val + ')' + ')' 
		        print(@v_str2);
         	END
   
			INSERT INTO  test1   ( vstring , vstring2 )   VALUES ( ' 4duplicacy ' , @v_str2 )  
			
			
			-- IMPLICIT_TRANSACTIONS is set to OFF
			
			--SELECT @v_str2  = update cir_chk_duplicacy set rec_name2=(select count(*) from
			EXEC (@v_str2)
			
		END
		ELSE
		BEGIN 
			INSERT INTO  cir_chk_duplicacy1   ( rec_name1 , rec_name2 )   VALUES ( 0 , 0 )  
			
		END
   
		
		-- IMPLICIT_TRANSACTIONS is set to OFF
		print('aa')

	
		SELECT DISTINCT ISNULL(rec_name1, 0) 'NAME' , ISNULL(rec_name2, 0) 'ALIAS' FROM  cir_chk_duplicacy1 WHERE	 1  = 1



************end mimoh mahajan-18/oct/2011******0005354*************************************************************************************


/*********prachi 18-oct**************/
                                                                 
                                             
ALTER PROCEDURE [dbo].[cir_chk_doc_permission](
    @loginid            as varchar(50),    
    @pcompany         as varchar(50), 
    @pbranch         as varchar(50),    
    @pdoctypes       as varchar(50)
    ) 
as
begin
      
 declare @vcount as int; 

	select @vcount=count(*)  from CIR_DOCTYP_PERMISSION where COMP_CODE=@pcompany and BRANCH_CODE=@pbranch and 
		DOCTYPE=@pdoctypes and USER_ID=@loginid;
       
      if(  @vcount='' or @vcount is null)begin
		set @vcount=0
		end
  

    if(@vcount=0) begin
     
        select 'ok' as "output" 
	end
    else begin
       
        select 'novalue' as "output" 
    end 
end





/*********prachi 18-oct**************/

*******************mimoh 19*oct*2011*****************************************************
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROCEDURE [dbo].[Cir_Table_Column_Detail_p]
	@ptable_name                              VARCHAR(4000) ,
	@pcolumn_name                             VARCHAR(4000) 
AS 
	
		
		DECLARE @vquery                      VARCHAR(2000) 
--		SELECT @vquery  = ' select TABLE_NAME tablename,COLUMN_NAME colname,DATA_TYPE coltype,case DATA_TYPE 
--when ''DATE'' then  CHARACTER_MAXIMUM_LENGTH+5
--when ''NUMBER'' then  NUMERIC_PRECISION
--else  CHARACTER_MAXIMUM_LENGTH end
-- colwidth,IS_NULLABLE colcondition,COLUMN_DEFAULT default_value ,NUMERIC_SCALE   FROM 
--   INFORMATION_SCHEMA.COLUMNS 
--where upper(ltrim(rtrim(TABLE_NAME))) in (' + '''' + REPLACE(@ptable_name, ',', '''' + ',' + '''')+ '''' + ')
-- and  (upper(ltrim(rtrim(COLUMN_NAME)))=' + '''' + UPPER(LTRIM(RTRIM(@pcolumn_name)))+ '''' + ' or' + '''' + @pcolumn_name + '''' + ' is null) order by TABLE_NAME,ORDINAL_POSITION' 
--		

SET @vquery  ='select TABLE_NAME tablename,COLUMN_NAME colname, DATA_TYPE coltype,
case DATA_TYPE 
when ''DATETIME'' then  ''10''
when ''numeric'' then  NUMERIC_PRECISION
when ''int'' then  NUMERIC_PRECISION
when ''decimal'' then  NUMERIC_PRECISION
else  CHARACTER_MAXIMUM_LENGTH end
 colwidth,IS_NULLABLE colcondition,COLUMN_DEFAULT default_value,NUMERIC_SCALE 
  		from  INFORMATION_SCHEMA.COLUMNS
 where upper(ltrim(rtrim(TABLE_NAME))) in ('+''''+ replace(@ptable_name,',',''''+','+'''')+''''+') and 
  									 (upper(ltrim(rtrim(COLUMN_NAME)))='+''''+upper(ltrim(rtrim(@pcolumn_name)))+''''+' or '+''''+@pcolumn_name+''''+' is null '+ ' or ' + ''''+@pcolumn_name+'''' +' =  '''''+') order by TABLE_NAME,ORDINAL_POSITION';

		


PRINT(@vquery)
		EXEC (@vquery) 

		

	







*********************mimoh/******19*oct*****2011*********************************************



///////////////////////issue no-4820/////////////////
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE [dbo].[cir_chk_doc_permission](
    @loginid            as varchar(50),    
    @pcompany         as varchar(50), 
    @pbranch         as varchar(50),    
    @pdoctypes       as varchar(50),
    @pamount         as varchar(50)
    ) 
as
begin
      
 declare @vcount as int; 

	select @vcount=count(*)  from CIR_DOCTYP_PERMISSION where COMP_CODE=@pcompany and BRANCH_CODE=@pbranch and 
		DOCTYPE=@pdoctypes and USER_ID=@loginid and (AMOUNT<@pamount or @pamount is null or @pamount='');
       
      if(  @vcount='' or @vcount is null)begin
		set @vcount=0
		end
  

    if(@vcount=0) begin
     
        select 'ok' as "output" 
	end
    else begin
       
        select 'novalue' as "output" 
    end 
end

///////////////end of 4820/////////////////////








////////////////////////////////issue no. 5361//////////////////////////////////////////////////////////


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER procedure [dbo].[addpublicationtype]
 as 
select pubtypecode,pubname from pub_type_mast order by pubname




///////////////////////////////////////end///////////////////////////////////////////////



/////////////////////issue no -4676////////////////////////////////////
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROCEDURE [dbo].[cir_agency_bind_cir_agency_bind_p1]
	@pcompcode			VARCHAR(20) ,
	@punit              VARCHAR(20) ,
	@pagcd              VARCHAR(20) ,
	@pdpcd              VARCHAR(20) ,
	@pdateformat        VARCHAR(20) ,
	@pextra1            VARCHAR(400) ,
	@pextra2            VARCHAR(400) 
AS 
BEGIN
	
 if upper(@pextra2)='D' begin
      
            select * from cir_agmast_dis
             where comp_code = @pcompcode and
                   unit = @punit and 
                   agcd=@pagcd and 
                   dpcd=@pdpcd and
                   ISNULL(freeze_flag,'N')='N'
             order by ag_name;
   end  else
        begin
            select * from cir_agmast
             where comp_code = @pcompcode and
                   unit = @punit and 
                   agcd=@pagcd and 
                   dpcd=@pdpcd and
                   ISNULL(freeze_flag,'N')='N'
             order by ag_name;
     end 	
END



//////////////////////end of issue///////////////////////////////////



**********mimoh 24oct2011***********************0005364**********************************start
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER procedure [dbo].[cir_overdue_bind]
    @pcompcode       as varchar(20),
    @pbill_cycle     as varchar(20),
    @pdateformat     as varchar(20),
    @puserid         as varchar(20),
    @pextra1         as varchar(20),
    @pextra2         as varchar(20)
as

begin
    select trans_ty AS "TRANS_TY", comp_code AS "COMP_CODE", publ AS "PUBL", publ_name AS "PUBL_NAME", pnick AS "PNICK", publ_frequancy AS "PUBL_FREQUANCY",
     product AS "PRODUCT",credit_days AS "CREDIT_DAYS",credit_limit  AS "CREDIT_LIMIT" from
    (select 'I' trans_ty,comp_code, publ, publ_name, pnick, 
    case when period='1' then 'Daily' when period='7' then 'Weekly' when period='30' then 'Monthly' 
    when period='15' then 'Fortnightly'
    when period='365' then 'Yearly' else convert(varchar(50),period) end publ_frequancy,
    case when pro_type='N' then 'Newspaper' when pro_type='M' then 'Magzine' else pro_type end product,0 credit_days,0 credit_limit
    from cir_publ_mast 
    where comp_code=@pcompcode and publ not in(select publ_code from cir_overdue_mast where comp_code=@pcompcode and 
    bill_cycle=@pbill_cycle)
    union all
    select 'U' trans_ty,p.comp_code comp_code, p.publ publ, p.publ_name publ_name, p.pnick pnick, 
    case when p.period='1' then 'Daily' when p.period='7' then 'Weekly' when p.period='30' then 'Monthly' 
    when p.period='15' then 'Fortnightly'
    when p.period='365' then 'Yearly' else convert(varchar(50),p.period) end publ_frequancy,
    case when p.pro_type='N' then 'Newspaper' when p.pro_type='M' then 'Magzine' else p.pro_type end product,
    o.credit_days credit_days,o.credit_limit credit_limit
    from cir_publ_mast p,cir_overdue_mast o
    where p.comp_code=o.comp_code and p.comp_code=@pcompcode and o.bill_cycle=@pbill_cycle) x 
    order by comp_code,publ_name

end 
**************************************************************************************************
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER PROCEDURE [dbo].[Cir_Dynamic_DML_variable_insert_stmt]
	@ptable_name                              VARCHAR(4000) ,
	@pcolname                                 VARCHAR(4000) ,
	@pcolvalue                                VARCHAR(4000) ,
	@pdelimiter                               VARCHAR(4000) ,
	@pdateformat                              VARCHAR(4000) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS
    	DECLARE @pstmt_str                                VARCHAR(4000) 
		DECLARE @v_sess_id                                FLOAT 
		DECLARE @rec_stmt								  VARCHAR(4000)		
		DECLARE @vlength                                  NUMERIC(5) 
		DECLARE @vcolval                                  VARCHAR(4000) 
		DECLARE @vrunval                                  VARCHAR(1) 
		DECLARE @vcol_name                                VARCHAR(4000) 
		DECLARE @vno                                      NUMERIC(5) 
		DECLARE @vrec                                     VARCHAR(4000) 
		DECLARE @vrec_upd                                 VARCHAR(4000) 
		DECLARE @vformat                                  VARCHAR(20) 
		DECLARE @v_col_exists                             NUMERIC(5) 
        DECLARE	 @COL_DATA_TYPE1						  VARCHAR(4000) 
        DECLARE	 @COL_VALUE1							  VARCHAR(4000) 
		declare @ss numeric(8)
		declare @vrec_val varchar(4000)
		declare @abj numeric(8)
		declare @col_val varchar(4000)
		declare @col_val1 varchar(4000)
	    declare @user_date varchar(4000)
		declare @item varchar(4000)
		declare @day varchar(4000)
		declare @month varchar(4000)
		declare @year varchar(4000)

		set @v_sess_id = (select @@spid)
		DELETE FROM   temp_col_ins   WHERE  session_id  = (select @@spid)
		SET @vlength  = null 
		SET @vcolval  = null 
		SET @vrunval  = null 
		SET @vcol_name  = null 
		SET @vno  = null 
		SET @vcolval  = REPLACE(@pcolname, @pdelimiter, ',')
print(@vcolval)
		SET @vlength  = LEN(@vcolval)
		SET @vno  = 1 
		SET  @ss  = 1
		set @vrec_val =null

        DECLARE @i INT

		SET  @i  = 1 

		WHILE @i <= @vlength 
		  BEGIN			
			SET @vrunval  = SUBSTRING(@vcolval, @i, 1)
			IF @vrunval != ',' 
			  BEGIN 
				SET @vcol_name  =  RTRIM(LTRIM(COALESCE(@vcol_name,space(0)) +  COALESCE(@vrunval,space(0))))
			  END
			ELSE
			 BEGIN				

				INSERT INTO  temp_col_ins  ( sqno , col_name , session_id )  
				 VALUES ( @vno , LTRIM(RTRIM(@vcol_name)) , @v_sess_id )  				
				SET @vno  = @vno + 1 
				SET @vcol_name  = '' 
			END
			SET @i = @i + 1
		END 
		SELECT @v_col_exists  =  COUNT(*) FROM  temp_col_ins WHERE	 session_id  = @v_sess_id AND	col_name  = LTRIM(RTRIM(@vcol_name))
		IF ISNULL(@v_col_exists, 0)= 0 
		BEGIN 
			INSERT INTO  temp_col_ins   ( sqno , col_name , session_id )   VALUES ( @vno ,	rtrim(ltrim(@vcol_name)) , @v_sess_id )			
		END
		SET @vlength  = null 
		SET @vcolval  = null 
		SET @vrunval  = null 
		SET @vcol_name  = null 
		SET @vno  = null 
		IF CHARINDEX(',', @pcolvalue)> 0 or CHARINDEX('''', @pcolvalue)> 0 
    		BEGIN 
	    		SET @vcolval  = REPLACE(@pcolvalue, ',', '~~~')
		END
		ELSE
		 BEGIN 
			SET @vcolval  = @pcolvalue 
		END
   
		SET @vcolval  = REPLACE(@vcolval, @pdelimiter, ',')
		SET @vlength  = LEN(@vcolval)
		SET @vno  = 1 
        SET @i = 1 
		print (@vlength)
		WHILE @i <= @vlength 
		BEGIN
		SET @vrunval  = SUBSTRING(@vcolval, @i, 1)
			IF @vrunval != ',' 
			BEGIN 
				SELECT @vcol_name  = COALESCE(@vcol_name,space(0)) + COALESCE(@vrunval,space(0))
			END
			ELSE
			BEGIN 
				SELECT @vcol_name  = REPLACE(@vcol_name, '~~~', ',')
				UPDATE  temp_col_ins   
				SET	col_value = COALESCE(@vcol_name,space(0))
				WHERE  sqno  = @vno
				 AND	session_id  = @v_sess_id 
				
				SET @vno  = @vno + 1 
				SET @vcol_name  = '' 
print 'update'
			END

			SET @i = @i + 1
print (@i)
		END

		IF @vcol_name is not null 
		BEGIN 
			UPDATE  temp_col_ins   
			SET	col_value = COALESCE(@vcol_name,space(0))
			WHERE  sqno  = @vno
			 AND	session_id  = @v_sess_id 
		END
   
		UPDATE  temp_col_ins   
		SET	col_data_type = (SELECT DATA_TYPE
			FROM  INFORMATION_SCHEMA.COLUMNS
			WHERE	 TABLE_NAME  = LTRIM(RTRIM(@ptable_name))
			 AND	column_name  = LTRIM(RTRIM(temp_col_ins.col_name))
		) 
		WHERE  session_id  = @v_sess_id 

		SET @vrec  = 'insert into ' + @ptable_name + '(' + REPLACE(@pcolname, @pdelimiter, ',')+ ') values (' 
print('rinki')			
print(@vrec)	
		SET @vformat  = @pdateformat 

		DECLARE cur_stmt cursor  FOR 
		SELECT COL_DATA_TYPE,COL_VALUE  FROM  temp_col_ins WHERE	 session_id  = @v_sess_id ORDER BY sqno 


    OPEN cur_stmt 
		fetch NEXT FROM cur_stmt INTO @COL_DATA_TYPE1,@COL_VALUE1
         while(@@FETCH_STATUS = 0)
			BEGIN  
		print(@COL_DATA_TYPE1)
print(@COL_VALUE1)
				IF  ( @COL_DATA_TYPE1 = 'datetime') 
					BEGIN 
						declare @finaldate varchar(4000)
						declare @count_dat int
						set @count_dat=0
						print 'aa'
						print @COL_VALUE1
						if @COL_VALUE1!='' or @COL_VALUE1 !=null or @COL_VALUE1 !='null'
						begin
							print '1ankur_test'
print('datetime') print(@COL_VALUE1)print(@pdateformat)print (@finaldate)
							set @finaldate=(select dbo.convert_user_date('/',@COL_VALUE1,@pdateformat))
							print '21ankur_test'
							print @finaldate
print 'ankur_testrr'
end
						if @finaldate='/'
begin
					set @finaldate=''''
end
						set @finaldate=''''+replace(@finaldate,'''','')+''''
			SET @col_val = COALESCE(@col_val + ',', SPACE(0)) + '' + COALESCE(@finaldate + '', SPACE(0))
			print @col_val
					END;
				else if(@COL_DATA_TYPE1 = 'numeric') OR (@COL_DATA_TYPE1 = 'decimal')
					begin						
							SET @col_val = COALESCE(@col_val + ',', SPACE(0)) + '' + 'convert( float,' + COALESCE(@COL_VALUE1 + '', SPACE(0))+')'
					end
				ELSE
					BEGIN
						SET @vrec = @vrec
						SET @col_val = COALESCE(@col_val + ',', SPACE(0)) + '' + COALESCE(@COL_VALUE1 + '', SPACE(0))
						END;
				fetch NEXT FROM cur_stmt INTO @COL_DATA_TYPE1,@COL_VALUE1
			END 
print'asdf'
			SET @col_val =COALESCE(substring(@col_val,1,len(@col_val)),SPACE(0))
			SET @vrec=  COALESCE(@vrec,SPACE(0)) + COALESCE(@col_val,SPACE(0)) + ')'
			SET @vlength  = null 
			SET @vcolval  = null 
			SET @vrunval  = null 
			SET @vcol_name  = null 
			SET @vno  = null 
		
		UPDATE   temp_col_ins   
		SET	upd_str = @vrec 
		WHERE  session_id  = @v_sess_id
             
        print(@vrec)
		EXEC (@vrec)
 DEALLOCATE cur_stmt 

















**********************************************************************************************************************
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROCEDURE [dbo].[cir_dynamic_update_stmt] 
   @ptable_name  varchar(2000),
   @pcolname  varchar(2000),
   @pcolvalue  varchar(2000),
   @pcond_colname  varchar(2000),
   @pdelimiter  varchar(2000),
   @pdateformat  varchar(2000),
   @pextra1  varchar(2000),
   @pextra2  varchar(2000)

as 
--	rec_stmt cur_stmt%rowtype;

--	rec_upd_stmt cur_upd_stmt%rowtype;

	DECLARE @vcol_name                            VARCHAR(100) 
	DECLARE @v_sess_id                            FLOAT 
	declare @pstmt_str							  varchar(4000);
	declare @vlength 							  int;
	declare @vcolval 							  varchar(4000);
	declare @vrunval 							  varchar(1);	
	declare @vno 								  int;
	declare @vrec 							      varchar(4000);
	declare @vrec_upd 							  varchar(4000);
	declare @vpextra1 							  varchar(4000);
	declare @vformat 							  varchar(20);
	DECLARE	 @COL_DATA_TYPE1					  VARCHAR(200);
    DECLARE	 @COL_VALUE1						  VARCHAR(2000);
	DECLARE	 @COL_NAME							  VARCHAR(2000);
	declare @col_val							  varchar(4000);
	declare @upd_col_val						  varchar(4000);
	DECLARE	 @UPD_COL_NAME						  VARCHAR(2000);
	DECLARE	 @UPD_COL_DATA_TYPE1				  VARCHAR(200);
    DECLARE	 @UPD_COL_VALUE1					  VARCHAR(2000);
	DECLARE @i									  INT

		SET  @i  = 1 
Begin
set @v_sess_id = (select @@spid)
SET @vcol_name  = null 
delete from test1
	insert into test1(vstring) values (@vrec+@vrec_upd+@ptable_name+','+@pcolname+','+
                                       @pcolvalue+','+@pcond_colname+','+@pdelimiter+','+
                                       @pdateformat+','+@pextra1+','+@pextra2);
	Begin
		delete from temp_col_ins where session_id=@@spid;

	set	@vlength=null;	set @vcolval=null; set	@vrunval=null;	set @vcol_name=null;	set @vno=null;

		set @vcolval=replace(@pcolname,@pdelimiter,',');	set @vlength=len(@vcolval);	set @vno=1;
		WHILE @i <= @vlength 
		  BEGIN			
			SET @vrunval  = SUBSTRING(@vcolval, @i, 1)
			IF @vrunval != ',' 
			  BEGIN 
				SET @vcol_name  =  RTRIM(LTRIM(COALESCE(@vcol_name,space(0)) +  COALESCE(@vrunval,space(0))))
			  END
			ELSE
			 BEGIN
				INSERT INTO  temp_col_ins  ( sqno , col_name , session_id )  
				 VALUES ( @vno , LTRIM(RTRIM(@vcol_name)) , @v_sess_id )  				
				SET @vno  = @vno + 1 
				SET @vcol_name  = '' 
			END
			SET @i = @i + 1
		END

		set @vlength=null;	set @vcolval=null;	set @vrunval=null;	set @vcol_name=null;	set @vno=null;
		
		set @vcolval=replace(@pcolvalue,',','~~~');

		set @vcolval=replace(@vcolval,@pdelimiter,',');	
		set @vlength=len(@vcolval);	
		set @vno =1;
		set @i=1;
		

set @i=1
		while @i<=@vlength
		  begin

			set @vrunval=substring(@vcolval,@i,1);
			 if @vrunval!=','

				begin

					set @vcol_name= COALESCE(@vcol_name + '', SPACE(0))+COALESCE(@vrunval + '', SPACE(0));
				end
			 else
				begin
					set @vcol_name=replace(@vcol_name,'~~~',',');

				   update temp_col_ins set col_value=@vcol_name where sqno=@vno and session_id=@@spid;
		  		   set @vno=@vno+1;
				   set @vcol_name='';
				end
			SET @i = @i + 1
		  end
		
		
/*Start New Change For Old and New Concept */
		if @pextra1='' or @pextra1 is null
			begin			 
              
         --   print('1')
			set @vpextra1=@pcolvalue;
			end
		else
			begin
           --   print('2')
           ---     print(@pextra1)
              --    print('2243')
			 set @vpextra1=@pextra1;
			end
		
		set @vlength=null;	
        set @vcolval=null;	
        set @vrunval=null;	
        set @vcol_name=null;	
        set @vno=null;

		print(@vpextra1)
		set @vcolval=replace(@vpextra1,',','~~~');
		
	print(@pdelimiter)
		set @vcolval=replace(@vcolval,@pdelimiter,',');	
	print(@vcolval)
		set @vlength=len(@vcolval);	
		set @vno=1;
set @i=1;
		while @i <=@vlength
			begin
              set @vrunval = substring(@vcolval,@i,1);
            
			if @vrunval!=','
				begin

                 
  
					set @vcol_name=COALESCE(@vcol_name + '', SPACE(0))+COALESCE(@vrunval + '', SPACE(0));
                     
                 
				end
		  		 
				else	
				 begin

                  
					set @vcol_name=replace(@vcol_name,'~~~',',');
              
					update temp_col_ins set col_value_old=@vcol_name where sqno=@vno and session_id=@@spid;
		  			set @vno=@vno+1;
					set @vcol_name='';
				 end
SET @i = @i + 1
			end
		
		/*End New Change For Old and New Concept */
		update temp_col_ins set col_data_type=(select DATA_TYPE from INFORMATION_SCHEMA.COLUMNS
		 where TABLE_NAME = upper(ltrim(rtrim(@ptable_name))) and column_name = upper(ltrim(rtrim(temp_col_ins.col_name))))
			where session_id=@@spid;
declare  cur_stmt cursor for  select COL_NAME,COL_VALUE,COL_DATA_TYPE from temp_col_ins  where session_id=@@spid order by sqno;
		
		set @vrec='update '+@ptable_name+' set ';
		--select "date_format" into vformat from preferrences;
          set @vformat=@pdateformat;
		OPEN cur_stmt 
		fetch NEXT FROM cur_stmt INTO @COL_NAME,@COL_VALUE1,@COL_DATA_TYPE1
         while(@@FETCH_STATUS = 0)
			BEGIN  
				
				IF  ( @COL_DATA_TYPE1 = 'datetime') 
					BEGIN 
						declare @finaldate varchar(4000)
						declare @count_dat int
						set @count_dat=0
				
						if @COL_VALUE1!=''
						begin
							set @finaldate=(select dbo.convert_user_date('/',@COL_VALUE1,@pdateformat))
				
						 end
						if @finaldate='/'
						 begin
					      set @finaldate=''''
						end
						set @finaldate=''''+replace(@finaldate,'''','')+''''
						
					SET @col_val = COALESCE(@col_val + ',', SPACE(0)) + ''+ @COL_NAME+'='+ COALESCE(@finaldate + '', SPACE(0))
					
print('asada')
print(@finaldate)
					END;
				else if(@COL_DATA_TYPE1 = 'numeric')
					begin	
                            declare @len112 int
                            set @len112 = len(@COL_VALUE1)	
                            if(@len112 > 9)

                            begin 
                             
                                 SET @col_val = COALESCE(@col_val + ',', SPACE(0)) + ''+ @COL_NAME+'=' + 'cast( ' + COALESCE(@COL_VALUE1 + '', SPACE(0))+' as varchar )'
                            end

                            else

                            begin		
                                
							    SET @col_val = COALESCE(@col_val + ',', SPACE(0)) + ''+ @COL_NAME+'=' + 'convert( float,' + COALESCE(@COL_VALUE1 + '', SPACE(0))+')'
                            end
							
					end
				ELSE
					BEGIN						
						SET @col_val = COALESCE(@col_val + ',', SPACE(0)) + '' + @COL_NAME+'='+ COALESCE(@COL_VALUE1 + '', SPACE(0))
						

						END;   
				fetch NEXT FROM cur_stmt INTO @COL_NAME,@COL_VALUE1,@COL_DATA_TYPE1
			END 
		  --set @vrec=substring(@vrec,1,len(@vrec)-1);
		  set @vlength=null;	set @vcolval=null;	set @vrunval=null;	set @vcol_name=null;	set @vno=null;

		set @vcolval=replace(@pcond_colname,@pdelimiter,',');	
		
set @vlength=len(@vcolval);
	set @i=1
		while @i<= @vlength
			begin
		set @vrunval=substring(@vcolval,@i,1);
				if @vrunval!=','
					begin		
						set @vcol_name=COALESCE(@vcol_name + '', SPACE(0))+COALESCE(@vrunval + '', SPACE(0));						
					end
				else
					begin
						
						update temp_col_ins set upd_flag='U' where col_name=@vcol_name and session_id=@@spid;
						set @vcol_name='';
					end
				SET @i = @i + 1
			end
		
	  close cur_stmt;

		if @pcond_colname is not null

			begin
		 		set @vrec_upd=' where ';
			end
		else
			begin
		 	set @vrec_upd='';
		end
	declare cur_upd_stmt cursor for   select COL_NAME,COL_VALUE_OLD,COL_DATA_TYPE from temp_col_ins  where isnull(upd_flag,'N')='U' and session_id=@@spid;
		open cur_upd_stmt	
		  fetch Next from cur_upd_stmt into @UPD_COL_NAME,@UPD_COL_VALUE1,@UPD_COL_DATA_TYPE1
		while(@@FETCH_STATUS = 0)
			BEGIN  
				IF(@UPD_COL_DATA_TYPE1 = 'datetime') 
					BEGIN						
						set @count_dat=0		
						
						if @UPD_COL_VALUE1!=''
						begin
							set @finaldate=(select dbo.convert_user_date('/',@UPD_COL_VALUE1,@pdateformat))
						 end
						if @finaldate='/'
						 begin
					      set @finaldate=''''
						end
						set @finaldate=''''+replace(@finaldate,'''','')+''''
						SET @upd_col_val = COALESCE(@upd_col_val + ' ', SPACE(0)) + ' ' + @UPD_COL_NAME+'='+ COALESCE(@finaldate + ' ', SPACE(0)) +' and'
						
					END;
				else if(@UPD_COL_DATA_TYPE1 = 'numeric')
					begin
                           
							SET @upd_col_val = COALESCE(@upd_col_val + ' ', SPACE(0)) + ' '+ @UPD_COL_NAME+'=' + 'convert( int,' + COALESCE(@UPD_COL_VALUE1 +  '', SPACE(0))+')'+' and'
							
					end
				ELSE
					BEGIN
						
						SET @upd_col_val = COALESCE(@upd_col_val + ' ', SPACE(0)) + ' ' + @UPD_COL_NAME+'='+ COALESCE(@UPD_COL_VALUE1 + ' ', SPACE(0))+ ' and'
						
						END;   
				fetch NEXT FROM cur_upd_stmt INTO @UPD_COL_NAME,@UPD_COL_VALUE1,@UPD_COL_DATA_TYPE1
			END 
		 close cur_upd_stmt;
		 set @upd_col_val=substring(@upd_col_val,1,len(@upd_col_val)-4);
		set @upd_col_val=COALESCE(@vrec_upd + '', SPACE(0))+ COALESCE(@upd_col_val + '', SPACE(0))
    declare @query1 varchar(2000)
set @query1 =COALESCE(@vrec + '', SPACE(0))+COALESCE(@col_val+ '', SPACE(0))+COALESCE(@upd_col_val+ '', SPACE(0));

	 update temp_col_ins set upd_str=COALESCE(@vrec + '', SPACE(0))+COALESCE(@col_val+ '', SPACE(0))+COALESCE(@upd_col_val+ '', SPACE(0)) where session_id=@@spid --and rownum<2;
		 
	End;
	 insert into test1(vstring) values (COALESCE(@vrec + '', SPACE(0))+COALESCE(@col_val+ '', SPACE(0))+COALESCE(@upd_col_val+ '', SPACE(0)));     
	   
print (@query1)
exec (@query1)
DEALLOCATE cur_stmt
DEALLOCATE cur_UPD_stmt
End 












**********mimoh 24oct2011***********************0005364**********************************end




//////////////procedure for code generate  issue no-4676////////////////////////
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROCEDURE [dbo].[Cir_Gen_Code_cir_installment_code_p]
	@pcompcode                                VARCHAR(20) ,
	@punitcode                                VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS 
	
	DECLARE @vno                                      VARCHAR(8) 
	DECLARE @v_code                                   VARCHAR(15) 

		SELECT @vno  =  MAX(SUBSTRING(inst_code, 2, 7)) + 1
		FROM  cir_installment_mast WHERE comp_code  = @pcompcode and unit_code  = @punitcode
		
		IF ISNULL(@vno, '0')= '0' or @vno=''
			BEGIN 
				SET @v_code  = 'I' + '0000001' 
			END
		ELSE
			BEGIN 
				SET @v_code  = 'I' + dbo.fnPadLeft('0',7,@vno)  
			END
   
		SELECT @v_code as VAR_CODE





////////////////end procedure///////////////////

//////////////////grid procedure issue no-4676/////////////
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

   ALTER procedure [dbo].[cir_installment_bind_cir_installment_bind_p]
    @pcomp_code 	as varchar(200),
    @punit_code 	as varchar(200),
    @pinst_code 	as varchar(200),
    @pagcd 	        as varchar(200),
    @pdpcd 	        as varchar(200),
    @pdateformat 	as varchar(200),
    @pextra1 		as varchar(200),
    @pextra2 		as varchar(200),
    @pextra3 		as varchar(200),
    @pextra4 		as varchar(200),
    @pextra5 		as varchar(200)
   As
   Begin
		select * from cir_installment_mast
		where comp_code=@pcomp_code and (unit_code=@punit_code or @punit_code is null or @punit_code='') and
        (inst_code=@pinst_code or @pinst_code is null or @pinst_code='') and
        (agcd=@pagcd or @pagcd is null or @pagcd='') and (dpcd=@pdpcd or @pdpcd is null or @pdpcd='') 
          order by INST_CODE
   End

////////end issue no-4676/////////////////////////////



=============================================================issue no. 4763-----------------------------

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER PROCEDURE [dbo].[cir_rep_supply_cir_dist_taluka_wise_sup]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@ppubl                                    VARCHAR(20) ,
	@pmainedtn                                VARCHAR(20) ,
	@pedtn                                    VARCHAR(20) ,
	@proute                                   VARCHAR(20) ,
	@pfrom_supdate                            VARCHAR(20) ,
	@ptill_supdate                            VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(200) ,
	@pextra2                                  VARCHAR(200) 
AS 
	
		
		DECLARE @vsupdate                                 DATETIME 
		DECLARE @vsupdate1                                DATETIME 
--		SELECT @vsupdate  = @pfrom_supdate
--		SELECT @vsupdate1  =  @ptill_supdate

SET @vsupdate  = dbo.convert_user_date('/', @pfrom_supdate,@pdateformat)
		SET @vsupdate1  = dbo.convert_user_date('/', @ptill_supdate,@pdateformat)

if(@ppubl = '')
begin
  set @ppubl = null
end
if(@pmainedtn = '')
begin
  set @pmainedtn = null
end
if(@pedtn = '')
begin
  set @pedtn = null
end
if(@proute = '')
begin
  set @proute = null
end
if(@pextra1 = '')
begin
  set @pextra1 = null
end
if(@pextra2 = '')
begin
  set @pextra2 = null
end
		

		
	
		SELECT
				 cir_dbksup.comp_code,
				 cir_dbksup.unit_code,
				 cir_agmast.dist_code,
				 DBO.cir_get_dist(cir_dbksup.comp_code, cir_agmast.state_code, cir_agmast.dist_code) dist_name,
				 cir_agmast.tehsil_taluka,
				 DBO.cir_get_taluka(cir_dbksup.comp_code, cir_agmast.tehsil_taluka) taluka_name,
				 cir_dbksup.agcd,
				 cir_dbksup.dpcd,
				 cir_agmast.ag_name,
				 cir_agmast.ag_name_oth_lang,
				 SUM(CONVERT(FLOAT, sup_copy)) as "SUM(SUP_COPY)"
		FROM  cir_dbksup,
			 cir_agmast 
		WHERE	 cir_dbksup.comp_code  = cir_agmast.comp_code
		 AND	cir_dbksup.unit_code  = cir_agmast.unit
		 AND	cir_dbksup.agcd  = cir_agmast.agcd
		 AND	cir_dbksup.dpcd  = cir_agmast.dpcd
		 AND	cir_dbksup.comp_code  = @pcomp_code
		 AND	cir_dbksup.unit_code  = @punit_code
		 AND	cir_dbksup.publ  = @ppubl
		 AND	((cir_dbksup.edtn  = @pedtn)
		 OR	(@pedtn  is null))
		 AND	((cir_agmast.tehsil_taluka  = @proute)
		 OR	(@proute  is null))
		 AND	cir_dbksup.supdate  between @vsupdate  and  @vsupdate1
		 AND	cir_dbksup.edtn  in
			(
		 	SELECT DISTINCT edtn
			FROM  cir_edtn_mast 
			WHERE	 comp_code  = @pcomp_code
			 AND	(edtn  = @pedtn
			 OR	@pedtn  is null)
			 AND	(main_edtn  = @pmainedtn
			 OR	@pmainedtn  is null)
			)
		GROUP BY cir_dbksup.comp_code,
			 cir_dbksup.unit_code,
			 cir_agmast.state_code,
			 cir_agmast.dist_code,
			 cir_agmast.tehsil_taluka,
			 cir_dbksup.agcd,
			 cir_dbksup.dpcd,
			 cir_agmast.ag_name,
			  cir_agmast.ag_name_oth_lang 
		ORDER BY cir_dbksup.comp_code,
			 cir_dbksup.unit_code,
			 dist_name,
			 taluka_name 
		
		
	
		SELECT
				 cir_dbksup.comp_code,
				 cir_dbksup.unit_code,
				 cir_agmast.dist_code,
				 DBO.cir_get_dist(cir_dbksup.comp_code, cir_agmast.state_code, cir_agmast.dist_code) dist_name,
				 cir_agmast.tehsil_taluka,
				 DBO.cir_get_taluka(cir_dbksup.comp_code, cir_agmast.tehsil_taluka) taluka_name,
				 SUM(CONVERT(FLOAT, sup_copy)) as "SUM(SUP_COPY)"
		FROM  cir_dbksup,
			 cir_agmast 
		WHERE	 cir_dbksup.comp_code  = cir_agmast.comp_code
		 AND	cir_dbksup.unit_code  = cir_agmast.unit
		 AND	cir_dbksup.agcd  = cir_agmast.agcd
		 AND	cir_dbksup.dpcd  = cir_agmast.dpcd
		 AND	cir_dbksup.comp_code  = @pcomp_code
		 AND	cir_dbksup.unit_code  = @punit_code
		 AND	cir_dbksup.publ  = @ppubl
		 AND	((cir_agmast.tehsil_taluka  = @proute)
		 OR	(@proute  is null))
		 AND	cir_dbksup.supdate  between @vsupdate  and  @vsupdate1
		 AND	cir_dbksup.edtn  in
			(
		 	SELECT DISTINCT edtn
			FROM  cir_edtn_mast 
			WHERE	 comp_code  = @pcomp_code
			 AND	(edtn  = @pedtn
			 OR	@pedtn  is null)
			 AND	(main_edtn  = @pmainedtn
			 OR	@pmainedtn  is null)
			)
		GROUP BY cir_dbksup.comp_code,
			 cir_dbksup.unit_code,
			 cir_agmast.state_code,
			 cir_agmast.dist_code,
			  cir_agmast.tehsil_taluka 
		ORDER BY cir_dbksup.comp_code,
			 cir_dbksup.unit_code,
			 dist_name,
			 taluka_name 
		
		
	
		SELECT
				 cir_dbksup.comp_code,
				 cir_dbksup.unit_code,
				 cir_agmast.dist_code,
				 DBO.cir_get_dist(cir_dbksup.comp_code, cir_agmast.state_code, cir_agmast.dist_code) dist_name,
				 SUM(CONVERT(FLOAT, sup_copy)) as "SUM(SUP_COPY)"
		FROM  cir_dbksup,
			 cir_agmast 
		WHERE	 cir_dbksup.comp_code  = cir_agmast.comp_code
		 AND	cir_dbksup.unit_code  = cir_agmast.unit
		 AND	cir_dbksup.agcd  = cir_agmast.agcd
		 AND	cir_dbksup.dpcd  = cir_agmast.dpcd
		 AND	cir_dbksup.comp_code  = @pcomp_code
		 AND	cir_dbksup.unit_code  = @punit_code
		 AND	cir_dbksup.publ  = @ppubl
		 AND	((cir_agmast.tehsil_taluka  = @proute)
		 OR	(@proute  is null))
		 AND	cir_dbksup.supdate  between @vsupdate  and  @vsupdate1
		 AND	cir_dbksup.edtn  in
			(
		 	SELECT DISTINCT edtn
			FROM  cir_edtn_mast 
			WHERE	 comp_code  = @pcomp_code
			 AND	(edtn  = @pedtn
			 OR	@pedtn  is null)
			 AND	(main_edtn  = @pmainedtn
			 OR	@pmainedtn  is null)
			)
		GROUP BY cir_dbksup.comp_code,
			 cir_dbksup.unit_code,
			 cir_agmast.state_code,
			  cir_agmast.dist_code 
		ORDER BY cir_dbksup.comp_code,
			 cir_dbksup.unit_code,
			 dist_name 
		
		
		
		SELECT
				 cir_dbksup.comp_code,
				 cir_dbksup.unit_code,
				 SUM(CONVERT(FLOAT, sup_copy)) as "SUM(SUP_COPY)"
		FROM  cir_dbksup,
			 cir_agmast 
		WHERE	 cir_dbksup.comp_code  = cir_agmast.comp_code
		 AND	cir_dbksup.unit_code  = cir_agmast.unit
		 AND	cir_dbksup.agcd  = cir_agmast.agcd
		 AND	cir_dbksup.dpcd  = cir_agmast.dpcd
		 AND	cir_dbksup.comp_code  = @pcomp_code
		 AND	cir_dbksup.unit_code  = @punit_code
		 AND	cir_dbksup.publ  = @ppubl
		 AND	((cir_agmast.tehsil_taluka  = @proute)
		 OR	(@proute  is null))
		 AND	cir_dbksup.supdate  between @vsupdate  and  @vsupdate1
		 AND	cir_dbksup.edtn  in
			(
		 	SELECT DISTINCT edtn
			FROM  cir_edtn_mast 
			WHERE	 comp_code  = @pcomp_code
			 AND	(edtn  = @pedtn
			 OR	@pedtn  is null)
			 AND	(main_edtn  = @pmainedtn
			 OR	@pmainedtn  is null)
			)
		GROUP BY cir_dbksup.comp_code,
			  cir_dbksup.unit_code 
		ORDER BY cir_dbksup.comp_code,
			 cir_dbksup.unit_code 
		
		

		SELECT
				 cir_dbksup.comp_code comp_code,
				 SUM(CONVERT(FLOAT, sup_copy)) SUP_COPY,
				 MAX(sup_rate) copy_rate
		FROM  cir_dbksup,
			 cir_agmast 
		WHERE	 cir_dbksup.comp_code  = cir_agmast.comp_code
		 AND	cir_dbksup.unit_code  = cir_agmast.unit
		 AND	cir_dbksup.agcd  = cir_agmast.agcd
		 AND	cir_dbksup.dpcd  = cir_agmast.dpcd
		 AND	cir_dbksup.comp_code  = @pcomp_code
		 AND	cir_dbksup.unit_code  = @punit_code
		 AND	cir_dbksup.publ  = @ppubl
		 AND	((cir_agmast.tehsil_taluka  = @proute)
		 OR	(@proute  is null))
		 AND	cir_dbksup.supdate  between @vsupdate  and  @vsupdate1
		 AND	cir_dbksup.edtn  in
			(
		 	SELECT DISTINCT edtn
			FROM  cir_edtn_mast 
			WHERE	 comp_code  = @pcomp_code
			 AND	(edtn  = @pedtn
			 OR	@pedtn  is null)
			 AND	(main_edtn  = @pmainedtn
			 OR	@pmainedtn  is null)
			)
		GROUP BY  cir_dbksup.comp_code 
		ORDER BY comp_code 
		



////////////////////////////////////////////////////////////////////////////////////////////////////////////////

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROCEDURE [dbo].[cir_rep_supply_cir_route_wise_supply]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@ppubl                                    VARCHAR(20) ,
	@pmainedtn                                VARCHAR(20) ,
	@pedtn                                    VARCHAR(20) ,
	@proute                                   VARCHAR(20) ,
	@pfrom_supdate                            DATETIME ,
	@ptill_supdate                            DATETIME ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(200) ,
	@pextra2                                  VARCHAR(200) 
AS 
	
		
		DECLARE @vfrom_supdate                            DATETIME 
		DECLARE @vtill_supdate                            DATETIME 
		SELECT @vfrom_supdate  = @pfrom_supdate
		SELECT @vtill_supdate  =  @ptill_supdate


if(@ppubl = '')
begin
  set @ppubl = null
end
if(@pmainedtn = '')
begin
  set @pmainedtn = null
end
if(@pedtn = '')
begin
  set @pedtn = null
end
if(@proute = '')
begin
  set @proute = null
end
if(@pextra1 = '')
begin
  set @pextra1 = null
end
if(@pextra2 = '')
begin
  set @pextra2 = null
end

		
		
		SELECT cir_dbksup.comp_code  COMP_CODE, cir_dbksup.unit_code UNIT_CODE, cir_dbksup.route_code ROUTE_CODE,
        DBO.cir_get_route_name(cir_dbksup.comp_code, cir_dbksup.unit_code, cir_dbksup.route_code) ROUTE_NAME,
        cir_dbksup.agcd AGCD, cir_dbksup.dpcd DPCD, cir_agmast.ag_name AG_NAME, cir_agmast.ag_name_oth_lang AG_NAME_OTH_LANG,
        SUM(CONVERT(FLOAT, SUP_COPY)) as "SUM(SUP_COPY)",
        DBO.cir_get_route_seqno(cir_dbksup.comp_code, cir_dbksup.unit_code, cir_dbksup.route_code) ROUTE_SEQNO,
        DBO.cir_get_supply_seqno(cir_dbksup.comp_code, cir_dbksup.unit_code, @ppubl, @pedtn, cir_dbksup.agcd, cir_dbksup.dpcd) SUPPLY_SEQNO
        FROM  cir_dbksup, cir_agmast 
        WHERE     cir_dbksup.comp_code  = cir_agmast.comp_code AND    cir_dbksup.unit_code  = cir_agmast.unit AND    cir_dbksup.agcd  = cir_agmast.agcd
        AND    cir_dbksup.dpcd  = cir_agmast.dpcd AND    cir_dbksup.comp_code  = @pcomp_code AND    cir_dbksup.unit_code  = @punit_code
        AND    cir_dbksup.publ  = @ppubl AND    ((cir_dbksup.edtn  = @pedtn) OR    (@pedtn  is null))
        AND    ((cir_dbksup.route_code  = @proute) OR    (@proute  is null)) AND    cir_dbksup.supdate  between @vfrom_supdate  and  @vtill_supdate
        AND    cir_dbksup.edtn  in(SELECT DISTINCT edtn FROM  cir_edtn_mast WHERE     comp_code  = @pcomp_code AND    (edtn  = @pedtn
        OR    @pedtn  is null) AND    (main_edtn  = @pmainedtn OR    @pmainedtn  is null))
        GROUP BY cir_dbksup.comp_code, cir_dbksup.unit_code, cir_dbksup.route_code, cir_dbksup.agcd, cir_dbksup.dpcd,
        cir_agmast.ag_name,  cir_agmast.ag_name_oth_lang 
        ORDER BY cir_dbksup.comp_code, cir_dbksup.unit_code, route_seqno, cir_dbksup.route_code, supply_seqno, cir_dbksup.agcd, cir_dbksup.dpcd 
        
		
		
		SELECT cir_dbksup.comp_code, cir_dbksup.unit_code, cir_dbksup.route_code, DBO.cir_get_route_name(cir_dbksup.comp_code, cir_dbksup.unit_code, cir_dbksup.route_code) route_name,
		SUM(CONVERT(FLOAT, sup_copy)) as "SUM(SUP_COPY)", DBO.cir_get_route_seqno(cir_dbksup.comp_code, cir_dbksup.unit_code, cir_dbksup.route_code) route_seqno
		FROM  cir_dbksup, cir_agmast 
		WHERE	 cir_dbksup.comp_code  = cir_agmast.comp_code AND	cir_dbksup.unit_code  = cir_agmast.unit AND	cir_dbksup.agcd  = cir_agmast.agcd
		AND	cir_dbksup.dpcd  = cir_agmast.dpcd AND	cir_dbksup.comp_code  = @pcomp_code AND	cir_dbksup.unit_code  = @punit_code
		AND	cir_dbksup.publ  = @ppubl AND	((cir_dbksup.route_code  = @proute) OR	(@proute  is null)) AND	cir_dbksup.supdate  between @vfrom_supdate  and  @vtill_supdate
		AND	cir_dbksup.edtn  in(SELECT DISTINCT edtn FROM  cir_edtn_mast 
		WHERE	 comp_code  = @pcomp_code AND	(edtn  = @pedtn OR	@pedtn  is null) AND	(main_edtn  = @pmainedtn OR	@pmainedtn  is null))
		GROUP BY cir_dbksup.comp_code, cir_dbksup.unit_code,  cir_dbksup.route_code 
		ORDER BY cir_dbksup.comp_code, cir_dbksup.unit_code, route_seqno, cir_dbksup.route_code 
		
		
		
		SELECT cir_dbksup.comp_code,	 cir_dbksup.unit_code,	 SUM(CONVERT(FLOAT, sup_copy)) as "SUM(SUP_COPY)"
		FROM  cir_dbksup, cir_agmast 
		WHERE	 cir_dbksup.comp_code  = cir_agmast.comp_code
		 AND	cir_dbksup.unit_code  = cir_agmast.unit
		 AND	cir_dbksup.agcd  = cir_agmast.agcd
		 AND	cir_dbksup.dpcd  = cir_agmast.dpcd
		 AND	cir_dbksup.comp_code  = @pcomp_code
		 AND	cir_dbksup.unit_code  = @punit_code
		 AND	cir_dbksup.publ  = @ppubl
		 AND	((cir_dbksup.route_code  = @proute)
		 OR	(@proute  is null))
		 AND	cir_dbksup.supdate  between @vfrom_supdate  and  @vtill_supdate
		 AND	cir_dbksup.edtn  in
			(
		 	SELECT DISTINCT edtn
			FROM  cir_edtn_mast 
			WHERE	 comp_code  = @pcomp_code
			 AND	(edtn  = @pedtn
			 OR	@pedtn  is null)
			 AND	(main_edtn  = @pmainedtn
			 OR	@pmainedtn  is null)
			)
		GROUP BY cir_dbksup.comp_code,
			  cir_dbksup.unit_code 
		ORDER BY cir_dbksup.comp_code,
			 cir_dbksup.unit_code 
		
		
		
		SELECT
				 cir_dbksup.comp_code comp_code,
				 SUM(CONVERT(FLOAT, sup_copy)) SUP_COPY ,
				 MAX(sup_rate) copy_rate
		FROM  cir_dbksup,
			 cir_agmast 
		WHERE	 cir_dbksup.comp_code  = cir_agmast.comp_code
		 AND	cir_dbksup.unit_code  = cir_agmast.unit
		 AND	cir_dbksup.agcd  = cir_agmast.agcd
		 AND	cir_dbksup.dpcd  = cir_agmast.dpcd
		 AND	cir_dbksup.comp_code  = @pcomp_code
		 AND	cir_dbksup.unit_code  = @punit_code
		 AND	cir_dbksup.publ  = @ppubl
		 AND	((cir_dbksup.route_code  = @proute)
		 OR	(@proute  is null))
		 AND	cir_dbksup.supdate  between @vfrom_supdate  and  @vtill_supdate
		 AND	cir_dbksup.edtn  in
			(
		 	SELECT DISTINCT edtn
			FROM  cir_edtn_mast 
			WHERE	 comp_code  = @pcomp_code
			 AND	(edtn  = @pedtn
			 OR	@pedtn  is null)
			 AND	(main_edtn  = @pmainedtn
			 OR	@pmainedtn  is null)
			)
		GROUP BY  cir_dbksup.comp_code 
		ORDER BY comp_code 
		


////////////////////////////////////////////////////////////////////////////////////////////////////////

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




ALTER PROCEDURE [dbo].[cir_rep_supply_cir_dist_wise_supply]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@ppubl                                    VARCHAR(20) ,
	@pmainedtn                                VARCHAR(20) ,
	@pedtn                                    VARCHAR(20) ,
	@proute                                   VARCHAR(20) ,
	@pfrom_supdate                            VARCHAR(20) ,
	@ptill_supdate                            VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS 
	
		
		DECLARE @vfrom_supdate                            DATETIME 
		DECLARE @vtill_supdate                            DATETIME 
		--SELECT @vfrom_supdate  =  @pfrom_supdate
		--SELECT @vtill_supdate  = @ptill_supdate

	SET @vfrom_supdate  = dbo.convert_user_date('/', @pfrom_supdate,@pdateformat)
		SET @vtill_supdate  = dbo.convert_user_date('/', @ptill_supdate,@pdateformat)


if(@ppubl = '')
begin
  set @ppubl = null
end
if(@pmainedtn = '')
begin
  set @pmainedtn = null
end
if(@pedtn = '')
begin
  set @pedtn = null
end
if(@proute = '')
begin
  set @proute = null
end
if(@pextra1 = '')
begin
  set @pextra1 = null
end
if(@pextra2 = '')
begin
  set @pextra2 = null
end


PRINT('1')		
		
		SELECT
				 cir_dbksup.comp_code,
				 cir_dbksup.unit_code,
				 cir_agmast.dist_code,
				 DBO.cir_get_dist(cir_dbksup.comp_code, cir_agmast.state_code, cir_agmast.dist_code) dist_name,
				 cir_dbksup.agcd,
				 cir_dbksup.dpcd,
				 cir_agmast.ag_name,
				 cir_agmast.ag_name_oth_lang,
				 SUM(CONVERT(FLOAT, sup_copy)) as "SUM(SUP_COPY)"
		FROM  cir_dbksup,
			 cir_agmast 
		WHERE	 cir_dbksup.comp_code  = cir_agmast.comp_code
		 AND	cir_dbksup.unit_code  = cir_agmast.unit
		 AND	cir_dbksup.agcd  = cir_agmast.agcd
		 AND	cir_dbksup.dpcd  = cir_agmast.dpcd
		 AND	cir_dbksup.comp_code  = @pcomp_code
		 AND	cir_dbksup.unit_code  = @punit_code
		 AND	cir_dbksup.publ  = @ppubl
		 AND	((cir_dbksup.edtn  = @pedtn)
		 OR	(@pedtn  is null))
		 AND	((cir_agmast.dist_code  = @proute)
		 OR	(@proute  is null))
		 AND	cir_dbksup.supdate  between @vfrom_supdate  and  @vtill_supdate
		 AND	cir_dbksup.edtn  in
			(
		 	SELECT DISTINCT edtn
			FROM  cir_edtn_mast 
			WHERE	 comp_code  = @pcomp_code
			 AND	(edtn  = @pedtn
			 OR	@pedtn  is null)
			 AND	(main_edtn  = @pmainedtn
			 OR	@pmainedtn  is null)
			)
		GROUP BY cir_dbksup.comp_code,
			 cir_dbksup.unit_code,
			 cir_agmast.dist_code,
			 cir_agmast.state_code,
			 cir_dbksup.agcd,
			 cir_dbksup.dpcd,
			 cir_agmast.ag_name,
			  cir_agmast.ag_name_oth_lang 
		ORDER BY cir_dbksup.comp_code,
			 cir_dbksup.unit_code,
			 dist_name,
			 cir_dbksup.agcd,
			 cir_dbksup.dpcd 
		
		
		
		SELECT
				 cir_dbksup.comp_code,
				 cir_dbksup.unit_code,
				 cir_agmast.dist_code,
				 DBO.cir_get_dist(cir_dbksup.comp_code, cir_agmast.state_code, cir_agmast.dist_code) dist_name,
				 SUM(CONVERT(FLOAT, sup_copy)) as "SUM(SUP_COPY)"
		FROM  cir_dbksup,
			 cir_agmast 
		WHERE	 cir_dbksup.comp_code  = cir_agmast.comp_code
		 AND	cir_dbksup.unit_code  = cir_agmast.unit
		 AND	cir_dbksup.agcd  = cir_agmast.agcd
		 AND	cir_dbksup.dpcd  = cir_agmast.dpcd
		 AND	cir_dbksup.comp_code  = @pcomp_code
		 AND	cir_dbksup.unit_code  = @punit_code
		 AND	cir_dbksup.publ  = @ppubl
		 AND	((cir_agmast.dist_code  = @proute)
		 OR	(@proute  is null))
		 AND	cir_dbksup.supdate  between @vfrom_supdate  and  @vtill_supdate
		 AND	cir_dbksup.edtn  in
			(
		 	SELECT DISTINCT edtn
			FROM  cir_edtn_mast 
			WHERE	 comp_code  = @pcomp_code
			 AND	(edtn  = @pedtn
			 OR	@pedtn  is null)
			 AND	(main_edtn  = @pmainedtn
			 OR	@pmainedtn  is null)
			)
		GROUP BY cir_dbksup.comp_code,
			 cir_dbksup.unit_code,
			 cir_agmast.dist_code,
			  cir_agmast.state_code 
		ORDER BY cir_dbksup.comp_code,
			 cir_dbksup.unit_code,
			 dist_name 
		
		
	
		SELECT
				 cir_dbksup.comp_code,
				 cir_dbksup.unit_code,
				 SUM(CONVERT(FLOAT, sup_copy)) as "SUM(SUP_COPY)"
		FROM  cir_dbksup,
			 cir_agmast 
		WHERE	 cir_dbksup.comp_code  = cir_agmast.comp_code
		 AND	cir_dbksup.unit_code  = cir_agmast.unit
		 AND	cir_dbksup.agcd  = cir_agmast.agcd
		 AND	cir_dbksup.dpcd  = cir_agmast.dpcd
		 AND	cir_dbksup.comp_code  = @pcomp_code
		 AND	cir_dbksup.unit_code  = @punit_code
		 AND	cir_dbksup.publ  = @ppubl
		 AND	((cir_agmast.dist_code  = @proute)
		 OR	(@proute  is null))
		 AND	cir_dbksup.supdate  between @vfrom_supdate  and  @vtill_supdate
		 AND	cir_dbksup.edtn  in
			(
		 	SELECT DISTINCT edtn
			FROM  cir_edtn_mast 
			WHERE	 comp_code  = @pcomp_code
			 AND	(edtn  = @pedtn
			 OR	@pedtn  is null)
			 AND	(main_edtn  = @pmainedtn
			 OR	@pmainedtn  is null)
			)
		GROUP BY cir_dbksup.comp_code,
			  cir_dbksup.unit_code 
		ORDER BY cir_dbksup.comp_code,
			 cir_dbksup.unit_code 
		
		
	
		SELECT
				 cir_dbksup.comp_code comp_code,
				 SUM(CONVERT(FLOAT, sup_copy)) SUP_COPY ,
				 MAX(sup_rate) copy_rate
		FROM  cir_dbksup,
			 cir_agmast 
		WHERE	 cir_dbksup.comp_code  = cir_agmast.comp_code
		 AND	cir_dbksup.unit_code  = cir_agmast.unit
		 AND	cir_dbksup.agcd  = cir_agmast.agcd
		 AND	cir_dbksup.dpcd  = cir_agmast.dpcd
		 AND	cir_dbksup.comp_code  = @pcomp_code
		 AND	cir_dbksup.unit_code  = @punit_code
		 AND	cir_dbksup.publ  = @ppubl
		 AND	((cir_agmast.dist_code  = @proute)
		 OR	(@proute  is null))
		 AND	cir_dbksup.supdate  between @vfrom_supdate  and  @vtill_supdate
		 AND	cir_dbksup.edtn  in
			(
		 	SELECT DISTINCT edtn
			FROM  cir_edtn_mast 
			WHERE	 comp_code  = @pcomp_code
			 AND	(edtn  = @pedtn
			 OR	@pedtn  is null)
			 AND	(main_edtn  = @pmainedtn
			 OR	@pmainedtn  is null)
			)
		GROUP BY  cir_dbksup.comp_code 
		ORDER BY comp_code 
		




//////////////////////////////////////////////////////////////////////////////////////////////////////////



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




ALTER PROCEDURE [dbo].[cir_rep_supply_cir_taluka_wise_supply]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@ppubl                                    VARCHAR(20) ,
	@pmainedtn                                VARCHAR(20) ,
	@pedtn                                    VARCHAR(20) ,
	@proute                                   VARCHAR(20) ,
	@pfrom_supdate                            VARCHAR(20) ,
	@ptill_supdate                            VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(20) ,
	@pextra2                                  VARCHAR(20) 

AS 

		
		DECLARE @vsupdate                                 DATETIME 
		DECLARE @vsupdate1                                DATETIME 
--		SELECT @vsupdate  = @pfrom_supdate
--		SELECT @vsupdate1  =  @ptill_supdate
	

SET @vsupdate  = dbo.convert_user_date('/', @pfrom_supdate,@pdateformat)
		SET @vsupdate1  = dbo.convert_user_date('/', @ptill_supdate,@pdateformat)

if(@ppubl = '')
begin
  set @ppubl = null
end
if(@pmainedtn = '')
begin
  set @pmainedtn = null
end
if(@pedtn = '')
begin
  set @pedtn = null
end
if(@proute = '')
begin
  set @proute = null
end
if(@pextra1 = '')
begin
  set @pextra1 = null
end
if(@pextra2 = '')
begin
  set @pextra2 = null
end
		
	
		
		SELECT
				 cir_dbksup.comp_code,
				 cir_dbksup.unit_code,
				 cir_agmast.tehsil_taluka,
				 DBO.cir_get_taluka(cir_dbksup.comp_code, cir_agmast.tehsil_taluka) taluka_name,
				 cir_dbksup.agcd,
				 cir_dbksup.dpcd,
				 cir_agmast.ag_name,
				 cir_agmast.ag_name_oth_lang,
				 SUM(CONVERT(FLOAT, sup_copy)) as "SUM(SUP_COPY)"
		FROM  cir_dbksup,
			 cir_agmast 
		WHERE	 cir_dbksup.comp_code  = cir_agmast.comp_code
		 AND	cir_dbksup.unit_code  = cir_agmast.unit
		 AND	cir_dbksup.agcd  = cir_agmast.agcd
		 AND	cir_dbksup.dpcd  = cir_agmast.dpcd
		 AND	cir_dbksup.comp_code  = @pcomp_code
		 AND	cir_dbksup.unit_code  = @punit_code
		 AND	cir_dbksup.publ  = @ppubl
		 AND	((cir_dbksup.edtn  = @pedtn)
		 OR	(@pedtn  is null))
		 AND	((cir_agmast.tehsil_taluka  = @proute)
		 OR	(@proute  is null))
		 AND	cir_dbksup.supdate  between @vsupdate  and  @vsupdate1
		 AND	cir_dbksup.edtn  in
			(
		 	SELECT DISTINCT edtn
			FROM  cir_edtn_mast 
			WHERE	 comp_code  = @pcomp_code
			 AND	(edtn  = @pedtn
			 OR	@pedtn  is null)
			 AND	(main_edtn  = @pmainedtn
			 OR	@pmainedtn  is null)
			)
		GROUP BY cir_dbksup.comp_code,
			 cir_dbksup.unit_code,
			 cir_agmast.tehsil_taluka,
			 cir_dbksup.agcd,
			 cir_dbksup.dpcd,
			 cir_agmast.ag_name,
			  cir_agmast.ag_name_oth_lang 
		ORDER BY cir_dbksup.comp_code,
			 cir_dbksup.unit_code,
			 taluka_name 
		
		
	
		SELECT
				 cir_dbksup.comp_code,
				 cir_dbksup.unit_code,
				 cir_agmast.tehsil_taluka,
				 DBO.cir_get_taluka(cir_dbksup.comp_code, cir_agmast.tehsil_taluka) taluka_name,
				 SUM(CONVERT(FLOAT, sup_copy)) as "SUM(SUP_COPY)"
		FROM  cir_dbksup,
			 cir_agmast 
		WHERE	 cir_dbksup.comp_code  = cir_agmast.comp_code
		 AND	cir_dbksup.unit_code  = cir_agmast.unit
		 AND	cir_dbksup.agcd  = cir_agmast.agcd
		 AND	cir_dbksup.dpcd  = cir_agmast.dpcd
		 AND	cir_dbksup.comp_code  = @pcomp_code
		 AND	cir_dbksup.unit_code  = @punit_code
		 AND	cir_dbksup.publ  = @ppubl
		 AND	((cir_agmast.tehsil_taluka  = @proute)
		 OR	(@proute  is null))
		 AND	cir_dbksup.supdate  between @vsupdate  and  @vsupdate1
		 AND	cir_dbksup.edtn  in
			(
		 	SELECT DISTINCT edtn
			FROM  cir_edtn_mast 
			WHERE	 comp_code  = @pcomp_code
			 AND	(edtn  = @pedtn
			 OR	@pedtn  is null)
			 AND	(main_edtn  = @pmainedtn
			 OR	@pmainedtn  is null)
			)
		GROUP BY cir_dbksup.comp_code,
			 cir_dbksup.unit_code,
			  cir_agmast.tehsil_taluka 
		ORDER BY cir_dbksup.comp_code,
			 cir_dbksup.unit_code,
			 taluka_name 
		
		
	
		SELECT
				 cir_dbksup.comp_code,
				 cir_dbksup.unit_code,
				 SUM(CONVERT(FLOAT, sup_copy)) as "SUM(SUP_COPY)"
		FROM  cir_dbksup,
			 cir_agmast 
		WHERE	 cir_dbksup.comp_code  = cir_agmast.comp_code
		 AND	cir_dbksup.unit_code  = cir_agmast.unit
		 AND	cir_dbksup.agcd  = cir_agmast.agcd
		 AND	cir_dbksup.dpcd  = cir_agmast.dpcd
		 AND	cir_dbksup.comp_code  = @pcomp_code
		 AND	cir_dbksup.unit_code  = @punit_code
		 AND	cir_dbksup.publ  = @ppubl
		 AND	((cir_agmast.tehsil_taluka  = @proute)
		 OR	(@proute  is null))
		 AND	cir_dbksup.supdate  between @vsupdate  and  @vsupdate1
		 AND	cir_dbksup.edtn  in
			(
		 	SELECT DISTINCT edtn
			FROM  cir_edtn_mast 
			WHERE	 comp_code  = @pcomp_code
			 AND	(edtn  = @pedtn
			 OR	@pedtn  is null)
			 AND	(main_edtn  = @pmainedtn
			 OR	@pmainedtn  is null)
			)
		GROUP BY cir_dbksup.comp_code,
			  cir_dbksup.unit_code 
		ORDER BY cir_dbksup.comp_code,
			 cir_dbksup.unit_code 
		
		

		SELECT
				 cir_dbksup.comp_code comp_code,
				 SUM(CONVERT(FLOAT, sup_copy)) SUP_COPY,
				 MAX(sup_rate) copy_rate
		FROM  cir_dbksup,
			 cir_agmast 
		WHERE	 cir_dbksup.comp_code  = cir_agmast.comp_code
		 AND	cir_dbksup.unit_code  = cir_agmast.unit
		 AND	cir_dbksup.agcd  = cir_agmast.agcd
		 AND	cir_dbksup.dpcd  = cir_agmast.dpcd
		 AND	cir_dbksup.comp_code  = @pcomp_code
		 AND	cir_dbksup.unit_code  = @punit_code
		 AND	cir_dbksup.publ  = @ppubl
		 AND	((cir_agmast.tehsil_taluka  = @proute)
		 OR	(@proute  is null))
		 AND	cir_dbksup.supdate  between @vsupdate  and  @vsupdate1
		 AND	cir_dbksup.edtn  in
			(
		 	SELECT DISTINCT edtn
			FROM  cir_edtn_mast 
			WHERE	 comp_code  = @pcomp_code
			 AND	(edtn  = @pedtn
			 OR	@pedtn  is null)
			 AND	(main_edtn  = @pmainedtn
			 OR	@pmainedtn  is null)
			)
		GROUP BY  cir_dbksup.comp_code 
		ORDER BY comp_code 
		




//////////////////////////////////////////////end of issue 4763 ///////////////////////////////////////////////////////





///////////////////////////////////////////////issue no.4488 30/10/2011//////////////////////////////////////////////////////

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROCEDURE [dbo].[cir_rep_unsold_supply_cir_monthly_net_paid_sale]
	@pcomp_code         as varchar(20),
	@punit_code         as varchar(20),
	@ppubl              as varchar(20),
	@pmainedtn          as varchar(20),
	@pedtn              as varchar(20),
	@pfromdate          as datetime,
	@ptilldate          as datetime,
	@pagency_type       as varchar(20),
	@pagency_class      as varchar(20),
	@pstatecode         as varchar(20),
	@pdistcode          as varchar(20),
	@ptaluka            as varchar(20),
	@pbranch            as varchar(20),
	@pagcd              as varchar(20),
	@pdpcd              as varchar(20),
	@preptype           as int,		   --1 for Agency Wise,2 for Main Edition wise,3 for District Taluka wise
	@pbreak_on          as varchar(20),--Region R/State S/District D/Branch B
	@preturn_based      as varchar(20),--it is use for return date or supply date(R/S)
	@plangtype          as varchar(20),
	@pdateformat        as varchar(20),
	@pextra1            as varchar(50),
	@pextra2            as varchar(50),
	@pextra3            as varchar(50),
	@pextra4            as varchar(50),
	@pextra5            as varchar(50)
AS 
		
	DECLARE @v_hdays	AS	NUMERIC(5) 
	DECLARE @v_avg_sale AS  NUMERIC(10) 
	DECLARE @v_reg_code AS  varchar(200)

	DECLARE @v1_comp_code	as varchar(50)
	DECLARE @v1_unit_code			as varchar(50)
    DECLARE @v1_branch_code			as varchar(50)
    DECLARE @v1_branch_name			as varchar(100)
    DECLARE @v1_publ				as varchar(50)
    DECLARE @v1_publ_name			as varchar(100)
    DECLARE @v1_main_edtn			as varchar(50)
    DECLARE @v1_main_edtn_name		as varchar(100)
    DECLARE @v1_edtn				as varchar(50)
    DECLARE @v1_edtn_name			as varchar(100)
    DECLARE @v1_copy_rate			as numeric(12,2)
    DECLARE @v1_agcd				as varchar(50)
    DECLARE @v1_dpcd				as varchar(50)
    DECLARE @v1_agname				as varchar(500)
    DECLARE @v1_agname_oth_lang		as varchar(500)
    DECLARE @v1_state_code			as varchar(50)
    DECLARE @v1_state_name			as varchar(500)
    DECLARE @v1_dist_code			as varchar(50)
    DECLARE @v1_dist_name			as varchar(100)
    DECLARE @v1_city_code			as varchar(50)
    DECLARE @v1_city_name			as varchar(150)
    DECLARE @v1_tehsil_taluka		as varchar(50)
    DECLARE @v1_taluka_name			as varchar(150)
    DECLARE @v1_supply_copy			as int
    DECLARE @v1_return_copy			as int
    DECLARE @v1_net_sale_copy		as int
    DECLARE @v1_no_of_days			as int

	
	DECLARE c1 cursor LOCAL FOR 
	select u.comp_code,u.unit_code,
    u.branch_code branch_code,(select distinct "Branch_Name" from branch_mst where "Branch_Code"=u.branch_code) branch_name,
    u.publ,u.publ_name,u.main_edtn,
    dbo.cir_get_edtn_name(u.comp_code,u.main_edtn) main_edtn_name,u.edtn edtn,u.edtn_name,u.copy_rate,
    u.agcd agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang agname_oth_lang,
    u.state_code,dbo.cir_get_state(u.comp_code,u.country_code,u.state_code) state_name,
    u.dist_code ,dbo.cir_get_name_cir_district(u.comp_code,u.dist_code,@plangtype,null,null,null) dist_name,
    u.city_code city_code,dbo.cir_get_name_cir_city(u.comp_code,u.city_code,@plangtype,null,null,null) city_name,
    u.tehsil_taluka,dbo.cir_get_name_cir_taluka(u.comp_code,u.tehsil_taluka,@plangtype,null,null,null) taluka_name,
    sum(supply_copy) supply_copy,sum(return_copy) return_copy,
    sum(supply_copy)-sum(return_copy) net_sale_copy,sum(no_of_days) no_of_days
    from (
    select b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.sup_rate copy_rate,
    b.agcd,b.dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
    a.branch_code,a.city_code,a.dist_code, a.state_code,a.country_code,a.tehsil_taluka, 
    sum(isnull(b.sup_copy,0)) supply_copy,0 return_copy, count(distinct supdate) no_of_days
    from cir_agmast a,cir_dbksup b,cir_edtn_mast e,cir_publ_mast p
    where b.comp_code =a.comp_code and b.comp_code=e.comp_code and b.comp_code=p.comp_code and 
    b.comp_code =@pcomp_code and 
    b.unit_code=a.unit and b.unit_code=@punit_code and 
    b.publ=p.publ and (b.publ=isnull(@ppubl,b.publ) or @ppubl='') and b.edtn=e.edtn and (b.edtn=isnull(@pedtn,b.edtn) or @pedtn='') and
    a.agcd=b.agcd and (b.agcd=isnull(@pagcd,b.agcd) or @pagcd='') and a.dpcd=b.dpcd and (b.dpcd=isnull(@pdpcd,b.dpcd) or @pdpcd='') and
    b.supdate >= @pfromdate and b.supdate <=@ptilldate and 
    (a.ag_type=@pagency_type or @pagency_type is null or @pagency_type='') and(a.ag_class=@pagency_class or @pagency_class is null or @pagency_class='') and
    (a.branch_code=@pbranch or @pbranch is null or @pbranch='') and (a.state_code=@pstatecode or @pstatecode is null or @pstatecode='') and
    (a.dist_code=@pdistcode or @pdistcode is null or @pdistcode='') and (a.tehsil_taluka=@ptaluka or @ptaluka is null or @ptaluka='') and
    (e.main_edtn=@pmainedtn or @pmainedtn is null or @pmainedtn='')
    group by b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.sup_rate,
    b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.branch_code,a.city_code,a.dist_code, a.state_code,
    a.country_code,a.tehsil_taluka
    union all
    select b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.copy_rate,
    b.agcd,b.dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
    a.branch_code,a.city_code,a.dist_code, a.state_code,a.country_code,a.tehsil_taluka, 
    0 supply_copy,sum(isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0)) return_copy,0 no_of_days
    from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e,cir_publ_mast p
    where b.comp_code =a.comp_code and b.comp_code=e.comp_code and b.comp_code=p.comp_code and b.comp_code =@pcomp_code and 
    b.unit_code=a.unit and b.unit_code=@punit_code and 
    b.doctype='UCN' and b.recptdt >= @pfromdate and b.recptdt <=@ptilldate and 
    b.publ=e.publ and b.publ=p.publ and (b.publ=isnull(@ppubl,b.publ) or @ppubl='') and b.edtn=e.edtn and (b.edtn=isnull(@pedtn,b.edtn) or @pedtn='') and 
    a.agcd=b.agcd and (b.agcd=isnull(@pagcd,b.agcd) or @pagcd='') and a.dpcd=b.dpcd and (b.dpcd=isnull(@pdpcd,b.dpcd) or @pdpcd='') and
    (a.ag_type=@pagency_type or @pagency_type is null or @pagency_type='') and(a.ag_class=@pagency_class or @pagency_class is null or @pagency_class='') and
    (a.branch_code=@pbranch or @pbranch is null or @pbranch='') and (a.state_code=@pstatecode or @pstatecode is null or @pstatecode='') and
    (a.dist_code=@pdistcode or @pdistcode is null or @pdistcode='') and (a.tehsil_taluka=@ptaluka or @ptaluka is null or @ptaluka='') and
    (isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))>0 and
    (e.main_edtn=@pmainedtn or @pmainedtn is null)
    group by b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.copy_rate,
    b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.branch_code,a.city_code,a.dist_code, a.state_code,
    a.country_code,a.tehsil_taluka) u
    where (u.supply_copy+u.return_copy)>0
    group by u.comp_code,u.unit_code,u.branch_code,u.publ,u.publ_name,u.main_edtn,u.edtn,u.edtn_name,u.copy_rate,
    u.agcd,u.dpcd,u.agname,u.agname_oth_lang,u.state_code,u.dist_code ,u.city_code,u.tehsil_taluka,u.country_code; 

		
	CREATE TABLE #CIR_TEMP_BILL_COLLECTION
	( COMP_CODE        VARCHAR(100),
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
	  SEC_OPBAL        NUMERIC(15,2))
		
		
		OPEN c1 
        fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit_code, @v1_branch_code, @v1_branch_name,@v1_publ, @v1_publ_name,@v1_main_edtn,@v1_main_edtn_name,@v1_edtn,@v1_edtn_name,@v1_copy_rate, @v1_agcd, @v1_dpcd,@v1_agname,@v1_agname_oth_lang,@v1_state_code,@v1_state_name,@v1_dist_code,@v1_dist_name,@v1_city_code,@v1_city_name, @v1_tehsil_taluka,@v1_taluka_name,@v1_supply_copy,@v1_return_copy,@v1_net_sale_copy, @v1_no_of_days
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN 
   
			If isnull(@v1_no_of_days,0)>0 Begin
                set @v_avg_sale=round(isnull(@v1_net_sale_copy,0)/(isnull(@v1_no_of_days,0)),0)
            End    
            Else Begin
                set @v_avg_sale=isnull(@v1_net_sale_copy,0)
            End

            select distinct @v_reg_code=region_code from cir_city_mast where comp_code=@v1_comp_code and city_code=@v1_city_code
            
            set @v_reg_code=dbo.cir_get_region_name(@v1_comp_code,@v_reg_code)
            
            insert into #cir_temp_bill_collection
				(comp_code, unit_code, billno, publ_code, agcd, dpcd,agname,agname_oth_lang, city_code, 
				taluka_code, dist_code, state_code, remarks,supply_copy, return_copy ,comm_amt,gross_amt)
            values(@v1_comp_code,@v1_unit_code,@v1_branch_name,@v1_publ_name,@v1_main_edtn_name,@v1_edtn_name,@v1_agname,@v1_agname_oth_lang,@v1_city_name,
				@v1_taluka_name,@v1_dist_name,@v1_state_name,@v_reg_code,@v1_supply_copy,@v1_return_copy,@v1_copy_rate,@v1_no_of_days)
            
		    fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit_code, @v1_branch_code, @v1_branch_name,@v1_publ, @v1_publ_name,@v1_main_edtn,@v1_main_edtn_name,@v1_edtn,@v1_edtn_name,@v1_copy_rate, @v1_agcd, @v1_dpcd,@v1_agname,@v1_agname_oth_lang,@v1_state_code,@v1_state_name,@v1_dist_code,@v1_dist_name,@v1_city_code,@v1_city_name, @v1_tehsil_taluka,@v1_taluka_name,@v1_supply_copy,@v1_return_copy,@v1_net_sale_copy, @v1_no_of_days
		
		END 
		close c1
		DEALLOCATE c1
		
        if @preptype=1 Begin
            if @pbreak_on='R' Begin
                select comp_code AS "COMP_CODE", unit_code AS "UNIT",agname AS "AGNAME",agname_oth_lang AS "AGNAME_OTH_LANG",city_code as "CITY_NAME", 
                remarks AS "REGION_NAME",supply_copy AS "SUPPLY_COPY", return_copy AS "RETURN_COPY" ,(supply_copy-return_copy) AS "NET_SALE",0 "NET_PER",
                gross_amt AS "NO_OF_DAYS",0 AS "AVG_NET_SALE" 
                from #cir_temp_bill_collection order by remarks,agname,city_name;

                select comp_code AS "COMP_CODE",  
                remarks AS "REGION_NAME",sum(supply_copy) AS "SUPPLY_COPY", sum(return_copy) AS "RETURN_COPY" ,sum(supply_copy-return_copy) AS "NET_SALE",0 "NET_PER",
                0 AS "NO_OF_DAYS",0 AS "AVG_NET_SALE" 
                from #cir_temp_bill_collection
                group by comp_code,remarks order by region_name
			End       
            else if @pbreak_on='S' Begin
                select comp_code AS "COMP_CODE", unit_code AS "UNIT",agname AS "AGNAME",agname_oth_lang AS "AGNAME_OTH_LANG",city_code as "CITY_NAME", 
                state_code AS "STATE_NAME",supply_copy AS "SUPPLY_COPY", return_copy AS "RETURN_COPY" ,(supply_copy-return_copy) AS "NET_SALE",0 "NET_PER",
                gross_amt AS "NO_OF_DAYS",0 AS "AVG_NET_SALE" 
                from #cir_temp_bill_collection order by state_name,agname,city_name

                select comp_code AS "COMP_CODE",  
                state_code AS "STATE_NAME",sum(supply_copy) AS "SUPPLY_COPY", sum(return_copy) AS "RETURN_COPY" ,sum(supply_copy-return_copy) AS "NET_SALE",0 "NET_PER",
                0 AS "NO_OF_DAYS",0 AS "AVG_NET_SALE" 
                from #cir_temp_bill_collection  
                group by comp_code,state_code order by state_name
            End    
            Else if @pbreak_on='D' Begin
                select comp_code AS "COMP_CODE", unit_code AS "UNIT",agname AS "AGNAME",agname_oth_lang AS "AGNAME_OTH_LANG",city_code as "CITY_NAME", 
                state_code AS "STATE_NAME",dist_code AS "DIST_NAME",supply_copy AS "SUPPLY_COPY", return_copy AS "RETURN_COPY" ,(supply_copy-return_copy) AS "NET_SALE",0 "NET_PER",
                gross_amt AS "NO_OF_DAYS",0 AS "AVG_NET_SALE" 
                from #cir_temp_bill_collection order by state_name,dist_name,agname,city_name

                select comp_code AS "COMP_CODE",  
                state_code AS "STATE_NAME",dist_code AS "DIST_NAME",sum(supply_copy) AS "SUPPLY_COPY", sum(return_copy) AS "RETURN_COPY" ,sum(supply_copy-return_copy) AS "NET_SALE",0 "NET_PER",
                0 AS "NO_OF_DAYS",0 AS "AVG_NET_SALE" 
                from #cir_temp_bill_collection 
                group by comp_code,state_code,dist_code order by state_name,dist_name
            End    
            else if @pbreak_on='B' Begin

                select comp_code AS "COMP_CODE", unit_code AS "UNIT",agname AS "AGNAME",agname_oth_lang AS "AGNAME_OTH_LANG",city_code as "CITY_NAME", 
                billno AS "BRANCH_NAME",supply_copy AS "SUPPLY_COPY", return_copy AS "RETURN_COPY" ,(supply_copy-return_copy) AS "NET_SALE",0 "NET_PER",
                gross_amt AS "NO_OF_DAYS",0 AS "AVG_NET_SALE" 
                from #cir_temp_bill_collection order by branch_name,agname,city_name

                select comp_code AS "COMP_CODE",  
                billno AS "BRANCH_NAME",sum(supply_copy) AS "SUPPLY_COPY", sum(return_copy) AS "RETURN_COPY" ,sum(supply_copy-return_copy) AS "NET_SALE",0 "NET_PER",
                0 AS "NO_OF_DAYS",0 AS "AVG_NET_SALE" 
                from #cir_temp_bill_collection 
                group by comp_code,billno order by branch_name
             End   
            End
        Else if @preptype=2 Begin--for edition wise

                select comp_code AS "COMP_CODE",  publ_code AS "PUBL_NAME",agcd AS "MAIN_EDTN_NAME",dpcd AS "EDTN_NAME",sum(supply_copy) AS "SUPPLY_COPY", 
                sum(return_copy) AS "RETURN_COPY" ,sum(supply_copy-return_copy) AS "NET_SALE",0 "NET_PER",
                0 AS "NO_OF_DAYS",0 AS "AVG_NET_SALE" 
                from #cir_temp_bill_collection group by comp_code,publ_code,agcd,dpcd order by publ_name,main_edtn_name,edtn_name;

                select comp_code AS "COMP_CODE",  publ_code AS "PUBL_NAME",agcd AS "MAIN_EDTN_NAME",sum(supply_copy) AS "SUPPLY_COPY", 
                sum(return_copy) AS "RETURN_COPY" ,sum(supply_copy-return_copy) AS "NET_SALE",0 "NET_PER",
                0 AS "NO_OF_DAYS",0 AS "AVG_NET_SALE" 
                from #cir_temp_bill_collection group by comp_code,publ_code,agcd order by publ_name,main_edtn_name;
		End                
        Else Begin

                select comp_code AS "COMP_CODE", 
                state_code AS "STATE_NAME",dist_code AS "DIST_NAME",taluka_code AS "TALUKA_NAME",
                sum(supply_copy) AS "SUPPLY_COPY", sum(return_copy) AS "RETURN_COPY" ,sum(supply_copy-return_copy) AS "NET_SALE",0 "NET_PER",
                0 AS "NO_OF_DAYS",0 AS "AVG_NET_SALE" 
                from #cir_temp_bill_collection 
                group by comp_code,state_code,dist_code,taluka_code order by state_name,dist_name,taluka_name;

                select comp_code AS "COMP_CODE", 
                state_code AS "STATE_NAME",dist_code AS "DIST_NAME",
                sum(supply_copy) AS "SUPPLY_COPY", sum(return_copy) AS "RETURN_COPY" ,sum(supply_copy-return_copy) AS "NET_SALE",0 "NET_PER",
                0 AS "NO_OF_DAYS",0 AS "AVG_NET_SALE" 
                from #cir_temp_bill_collection
                group by comp_code,state_code,dist_code order by state_name,dist_name
        End
        
        select getdate() as "CUR_DATE"
        select getdate() as "CUR_DATE"
   drop table #cir_temp_bill_collection

 

////////////////////////////////////////////////////procedure end///////////////////////////////////////



/////////////////////////////////////////////////function/////////////////////////////////////////////////////

CREATE FUNCTION cir_get_region_name(@pcomp_code AS varchar(20),@pregion_code AS varchar(20)) RETURNs varchar(200) AS

BEGIN
DECLARE @vreg_name VARCHAR(200)

select @vreg_name=reg_desc from cir_region_mast where comp_code=@pcomp_code and reg_code=@pregion_code

	return ISNULL(@vreg_name,'NA')
END

///////////////////////////////////////////////////function end////////////////////////////////////////



////////////////////////////////////////////////////end of isssue no.4488////////////////////////////////



///////////////////////////////////////////////issue no.5380 01/11/2011//////////////////////////////////////////////////////

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROCEDURE [dbo].[cir_rep_lbl_prn_cir_rep_lbl_prn_bhaskar_p]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@ppubl                                    VARCHAR(20) ,
	@pmainedtn                                VARCHAR(20) ,
	@pedtn                                    VARCHAR(20) ,
	@proute                                   VARCHAR(20) ,
	@pagcd                                    VARCHAR(20) ,
	@pdpcd                                    VARCHAR(20) ,
	@plbldt                                   VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS 
		DECLARE @vdate      DATETIME 
     	SET @vdate  =  dbo.convert_user_date('/',@plbldt,@pdateformat)

		/*SELECT
				 cir_lblmast.*,
				 DBO.cir_get_mode_name(comp_code, route1) MODE_NAME
		FROM  cir_lblmast 
		WHERE	 comp_code  = @pcomp_code
		 AND	unit_code  = @punit_code
		 AND	lbl_dt  = CONVERT(DATETIME, @plbldt)
		 AND	((publ  = @ppubl)
		 OR	(@ppubl  is null))
		 AND	((ISNULL(edtn, edtn_1)  = @pedtn)
		 OR	(@pedtn  is null))
		 AND	ISNULL(edtn, edtn_1)  in
			(
		 	SELECT edtn
			FROM  cir_edtn_mast 
			WHERE	 comp_code  = @pcomp_code
			 AND	(unit_code  = @punit_code
			 OR	@punit_code  is null)
			 AND	((edtn  = @pedtn)
			 OR	(@pedtn  is null))
			 AND	(main_edtn  = @pmainedtn
			 OR	@pmainedtn  is null)
			)
		 AND	((route1  = @proute)
		 OR	(@proute  is null))
		 AND	((agcd  = @pagcd)
		 OR	(@pagcd  is null))
		 AND	((dpcd  = @pdpcd)
		 OR	(@pdpcd  is null))
		ORDER BY unit_code,
			 seq_no,
			 route1,
			 edtn,
			 agname */
		

select cir_lblmast.*,DBO.cir_get_mode_name(comp_code, route1) MODE_NAME,
          SUBSTRING(DBO.cir_get_name_cir_edtn(comp_code,unit_code,edtn  ,'1',@pdateformat,'',''),1,30) EDTN_NAME,
          (select distinct reg_no from cir_edtn_mast where comp_code = @pcomp_code and edtn=cir_lblmast.edtn_1) AS "REG_NO" 
           from cir_lblMAST
             where comp_code = @pcomp_code and 
                   unit_code = @punit_code and 
                   lbl_dt    =@vdate and 
                   ((publ    = @ppubl) or (@ppubl is null) or (@ppubl ='')) and 
                   ((isnull(edtn,edtn_1)    = @pedtn) or (@pedtn is null) or (@pedtn='')) and
                   isnull(edtn,edtn_1) in(select edtn from cir_edtn_mast where comp_code=@pcomp_code and 
                   (unit_code=@punit_code or @punit_code is null or @punit_code='') and ((edtn = @pedtn) or (@pedtn is null) or (@pedtn='')) and 
					(main_edtn=@pmainedtn or @pmainedtn is null) or @pmainedtn ='') and
                   ((route1   = @proute) or (@proute is null) or (@proute='')) and 
                   ((agcd    = @pagcd) or (@pagcd is null) or (@pagcd='')) and 
                   ((dpcd    = @pdpcd) or (@pdpcd is null) or (@pdpcd=''))
					ORDER BY unit_code,
								 seq_no,
								 route1,
								 edtn,
								 agname

////////////////////////////////////////////////////end of isssue no.5380////////////////////////////////