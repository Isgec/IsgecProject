
//////////////////////////////////////////////issue no.6665 13/02/2012///////////////////////////////////////////////////////////////////////

ALTER PROCEDURE cir_rep_billing_cir_billing_outstanding_p
	@pcomp_code			as	varchar(20),
    @punit_code			as	varchar(20),
    @repty				as	varchar(20),
    @pbill_freq			as	varchar(20),
    @pfrom_billdt		as	datetime,
    @ptill_billdt		as	datetime,
    @ppubl				as	varchar(20),
    @pbillagcd			as	varchar(20),
    @pbilldpcd			as	varchar(20),
    @pdateformat		as	varchar(20),
    @pbrancode			as	varchar(20),
    @pdistcode			as	varchar(20),
    @pagclass			as	varchar(20),
    @pextra1			as	varchar(200),--for executive code
    @pextra2			as	varchar(200) 
AS 
	If @pcomp_code ='' Begin
		set @pcomp_code=null
	End
	If @punit_code ='' Begin
		set @punit_code=null
	End
	If @repty ='' Begin
		set @repty=null
	End
	If @pbill_freq ='' Begin
		set @pbill_freq=null
	End
	If @ppubl ='' Begin
		set @ppubl=null
	End
	If @pbillagcd ='' Begin
		set @pbillagcd=null
	End
	If @pbilldpcd ='' Begin
		set @pbilldpcd=null
	End

	If @pbrancode ='' Begin
		set @pbrancode=null
	End
	If @pdistcode ='' Begin
		set @pdistcode=null
	End
	If @pagclass ='' Begin
		set @pagclass=null
	End
	If @pextra1 ='' Begin
		set @pextra1=null
	End
	If @pextra2 ='' Begin
		set @pextra2=null
	End	

	DECLARE @v_dt           DATETIME 
	DECLARE @v_statecode	varchar(200)
    DECLARE @v_distcode		varchar(200)
    DECLARE @v_citycode		varchar(200)
    DECLARE @v_taluka		varchar(200)

	DECLARE @v1_comp_code		varchar(20)
	DECLARE @v1_unit_code		varchar(20)
	DECLARE @v1_publ			varchar(20)
	DECLARE @v1_agcd			varchar(20)
	DECLARE @v1_dpcd			varchar(20)
	DECLARE @v1_ag_name			varchar(200)
	DECLARE @v1_ag_name_oth_lang	varchar(200)
    DECLARE @v1_city_code		varchar(200)
    DECLARE @v1_country_code	varchar(200)
    DECLARE @v1_state_code		varchar(200)
    DECLARE @v1_dist_code		varchar(200)
    DECLARE @v1_taluka_code		varchar(200)
    DECLARE @v1_billno			varchar(200)
    DECLARE @v1_billdt			datetime
    DECLARE @v1_supply_copy		numeric(8)
    DECLARE @v1_gross_amount	numeric(12,2)
    DECLARE @v1_sur_amount		numeric(12,2) 
    DECLARE @v1_comm_amount		numeric(12,2)
    DECLARE @v1_bill_sec_amt	numeric(12,2) 
    DECLARE @v1_drop_point		varchar(200)



		DECLARE cur_bill cursor FOR 
		select distinct a.comp_code comp_code,a.unit_code unit_code,/*a.publ publ,*/a.agcd agcd,a.dpcd dpcd,b.ag_name ag_name,b.ag_name_oth_lang ag_name_oth_lang,
        b.city_code city_code,b.country_code country_code,b.state_code state_code,b.dist_code dist_code,b.tehsil_taluka taluka_code,
        /*a.billno billno,a.billdt billdt,*/sum(a.bill_copy) supply_copy,sum(a.gross_amount) gross_amount,sum(a.sur_amt) sur_amount,sum(a.comm_amt) comm_amount,
        c.bill_sec_amt bill_sec_amt,b.station_code drop_point
        from cir_bill_det a,cir_agmast b,cir_bill c
            where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=@pcomp_code and
                  a.unit_code=b.unit and a.unit_code=c.unit_code and
                  a.unit_code=isnull(@punit_code,a.unit_code) and
                  a.billdt=c.billdt and a.billdt >= @pfrom_billdt and a.billdt<=@ptill_billdt and a.billno=c.billno and
                  (a.bill_flag=@pbill_freq or @pbill_freq is null) and a.publ=isnull(@ppubl,a.publ) and a.agcd=b.agcd and a.dpcd=b.dpcd and
                  a.agcd=c.agcd and a.dpcd=c.dpcd and a.agcd=isnull(@pbillagcd,a.agcd) and a.dpcd=isnull(@pbilldpcd,a.dpcd) and
                  (b.ag_class=@pagclass or @pagclass is null) and
                  (b.state_code=@v_statecode or @v_statecode is null) and (b.dist_code=@v_distcode or @v_distcode is null) and
                  (b.tehsil_taluka=@v_taluka or @v_taluka is null) and (b.branch_code=@pbrancode or @pbrancode is null) and
                  (b.city_code=@v_citycode or @v_citycode is null) and (b.executive_code = @pextra1 or @pextra1 is null)
                  group by a.comp_code,a.unit_code,/*a.publ,*/a.agcd,a.dpcd,b.ag_name,b.ag_name_oth_lang,
                  b.city_code,b.country_code,b.state_code,b.dist_code,b.tehsil_taluka,c.bill_sec_amt,b.station_code /*,a.billno,a.billdt*/
                  order by a.comp_code,a.unit_code,/*a.billdt,a.billno,*/a.agcd,a.dpcd/*,a.publ*/;

		declare @v2_doctyp	varchar(20)
		declare @v2_amount	numeric(15,2)
		declare @v_dsign           numeric(2)
		declare @v_ret_gross       numeric(15,2)
        declare @v_ret_comm        numeric(15,2)
        declare @v_ret_copy        numeric(15)
        declare @v_dn_amt          numeric(15,2)
        declare @v_cn_amt          numeric(15,2)
        declare @v_rec_amt         numeric(15,2)
        declare @v_prev_bal        numeric(15,2)
        declare @v_sec_bal         numeric(15,2)
        declare @v_opdate          datetime
        declare @v_state_name      varchar(200)
        declare @v_dist_name       varchar(200)
        declare @v_taluka_name     varchar(200)
        declare @v_city_name       varchar(200)
        declare @v_drop_point_name varchar(200)
        		
		DECLARE cur_type cursor FOR
        select doctyp,sum(amount) amount from cir_outmast
            where comp_code=@v1_comp_code and unit_code=@v1_unit_code and
                achd='NM' and doctyp not in('BIL','UCN') and recptdt>=@pfrom_billdt and recptdt<=@ptill_billdt and
                agcd=@v1_agcd and dpcd=@v1_dpcd
            group by doctyp;

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
            
		OPEN cur_bill ---main cursor bill

		fetch NEXT FROM cur_bill INTO @v1_comp_code,@v1_unit_code, /*@v1_publ,*/@v1_agcd,@v1_dpcd,@v1_ag_name,@v1_ag_name_oth_lang, @v1_city_code, @v1_country_code, @v1_state_code	,@v1_dist_code, @v1_taluka_code, /*@v1_billno,@v1_billdt,*/@v1_supply_copy,
			@v1_gross_amount, @v1_sur_amount,@v1_comm_amount, @v1_bill_sec_amt,@v1_drop_point

		WHILE (@@FETCH_STATUS = 0) BEGIN 
		SELECT @v_ret_copy  =  SUM(ISNULL(apr_short_recpt, 0) + ISNULL(apr_late_recpt, 0) + ISNULL(apr_bnr, 0) + ISNULL(apr_unsold, 0)),
				@v_ret_gross  =  SUM(ISNULL(copy_amt, 0) + ISNULL(waste_amt, 0)),
				@v_ret_comm  =  ISNULL(SUM(comm_amt), 0)
			FROM  cir_unsold_dtl 
			WHERE comp_code  = @v1_comp_code AND unit_code  = @v1_unit_code
			 AND doctype  = 'UCN' AND app_dt  >= @pfrom_billdt AND app_dt  <= @ptill_billdt
			 AND agcd  = @v1_agcd AND dpcd  = @v1_dpcd /*and publ=@v1_publ*/

			SET @v_prev_bal		= DBO.cir_accounts_cir_agency_opbal(@v1_comp_code, @v1_unit_code, '', @v1_agcd, @v1_dpcd, @v_opdate, 'NM', @pdateformat, @pextra1, @pextra2)
			SET @v_sec_bal		= DBO.cir_accounts_cir_agency_opbal(@v1_comp_code, @v1_unit_code, '', @v1_agcd,@v1_dpcd, @v_opdate, 'SC', @pdateformat, @pextra1, @pextra2)

			SELECT @v_rec_amt  =  ISNULL(SUM(x.amount),0)
			FROM (SELECT SUM(amount) amount
				FROM  cir_outmast 
				WHERE comp_code  = @v1_comp_code AND unit_code  = @v1_unit_code AND achd  = 'NM'
				 AND doctyp  = 'BIL' AND billdt  >= @v_opdate AND billdt  < @pfrom_billdt
				 AND agcd  = @v1_agcd AND dpcd  = @v1_dpcd
				UNION ALL
			 	SELECT SUM(amount) amount
				FROM  cir_outmast 
				WHERE comp_code  = @v1_comp_code AND unit_code  =@v1_unit_code AND achd  = 'NM'
				 AND doctyp  <> 'BIL' AND recptdt  >= @v_opdate AND recptdt  <= @pfrom_billdt
				 AND agcd  = @v1_agcd AND dpcd  = @v1_dpcd) x

			SET @v_prev_bal	= ISNULL(@v_prev_bal, 0)+ ISNULL(@v_rec_amt, 0)
			SET @v_rec_amt  = 0 

			SELECT @v_rec_amt  =  ISNULL(SUM(amount),0) FROM  cir_rcphdr 
			WHERE comp_code  = @v1_comp_code AND unit_code  = @v1_unit_code AND achd  = 'SC'
			 AND recptdt  >= @v_opdate AND recptdt  <= @ptill_billdt
			 AND agcd  = @v1_agcd AND dpcd  = @v1_dpcd
			
			SET @v_sec_bal  = ISNULL(@v_sec_bal, 0)+ ISNULL(@v_rec_amt, 0)
			SET @v_rec_amt  = 0 
													
			OPEN cur_type 
			fetch NEXT FROM cur_type INTO @v2_doctyp,@v2_amount

			WHILE (@@FETCH_STATUS = 0) BEGIN 

				SELECT @v_dsign  =  isnull(dsign,1) FROM  cir_docmst 
				WHERE comp_code  = @v1_comp_code AND doc_type  = @v2_doctyp

				IF @v_dsign > 0 BEGIN 
					SET @v_dn_amt  = ISNULL(@v_dn_amt, 0)+ ISNULL(@v2_amount, 0)
				END
				ELSE BEGIN 
					IF @v2_doctyp = 'RCR' BEGIN 
						SET @v_rec_amt  = ISNULL(@v_rec_amt, 0)+ ISNULL(@v2_amount, 0)
					END
					ELSE BEGIN 
						SET @v_cn_amt  = ISNULL(@v_cn_amt, 0)+ ISNULL(@v2_amount, 0)
					END
				END
   			fetch NEXT FROM cur_type INTO @v2_doctyp,@v2_amount
   			END
			close cur_type
			--deallocate cur_type

			set @v_state_name        =	dbo.cir_get_state(@v1_comp_code,@v1_country_code,@v1_state_code)
            set @v_drop_point_name   =	dbo.cir_get_drop_point_name(@v1_comp_code,@v1_unit_code,@v1_drop_point,1)
            
            If @repty!='S' Begin
                set @v_dist_name		=	dbo.cir_get_name_cir_district(@v1_comp_code,@v1_dist_code,'1','','','')
                If @repty='C' Begin
                    set @v_city_name	=	dbo.cir_get_city(@v1_comp_code,@v1_city_code)
                End    

                If @repty='T' Begin
                   set @v_taluka_name	=	dbo.cir_get_name_cir_taluka(@v1_comp_code,@v1_taluka_code,'1','','','')
                End
            End
            
			insert into #cir_temp_bill_collection(
				comp_code,unit_code,billno,billdt,publ_code,agcd,dpcd,
                supply_copy, gross_amt, comm_amt, sur_amt, return_copy, return_amt,ret_comm_amt, dn_amt, rec_amt, prev_bal,cn_amt,
                agname, agname_oth_lang, city_code, taluka_code, dist_code, state_code, remarks,bill_sec_amt,sec_opbal)
            values(@v1_comp_code,  @v1_unit_code  , null   ,null  , null ,@v1_agcd,@v1_dpcd,
            @v1_supply_copy,@v1_gross_amount,isnull(@v1_comm_amount,0),@v1_sur_amount,@v_ret_copy,@v_ret_gross,@v_ret_comm,
            @v_dn_amt,@v_rec_amt,@v_prev_bal,@v_cn_amt,
            @v1_ag_name,@v1_ag_name_oth_lang,@v_city_name,@v_taluka_name,@v_dist_name,@v_state_name,@v_drop_point_name,
            @v1_bill_sec_amt,@v_sec_bal);

			fetch NEXT FROM cur_bill INTO @v1_comp_code,@v1_unit_code, /*@v1_publ,*/@v1_agcd,@v1_dpcd,@v1_ag_name,@v1_ag_name_oth_lang, @v1_city_code, @v1_country_code, @v1_state_code	,@v1_dist_code, @v1_taluka_code, /*@v1_billno,@v1_billdt,*/@v1_supply_copy,
			@v1_gross_amount, @v1_sur_amount,@v1_comm_amount, @v1_bill_sec_amt,@v1_drop_point
			
			set @v_dsign	=0	set @v_ret_gross=0	set @v_ret_comm	=0 	set @v_ret_copy=0 
			set @v_dn_amt	=0	set @v_cn_amt	=0	set @v_rec_amt	=0  set @v_prev_bal=0 set @v_sec_bal	=0
            set @v_state_name=null set @v_dist_name=null set @v_taluka_name=null set @v_city_name=null
		END 
		Close cur_bill

        If @repty='S' Begin
            SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.AGCD AGCD,A.DPCD DPCD,A.AGNAME AG_NAME,A.AGNAME_OTH_LANG AG_NAME_OTH_LANG,
            A.STATE_CODE STATE_NAME,
            SUM(ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)) BILL_AMT,SUM(A.COMM_AMT) COMM_AMT,SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))) NET_BILL,
            SUM(ISNULL(A.RETURN_AMT,0)+ISNULL(RET_COMM_AMT,0)) RETURN_AMT,SUM(ISNULL(A.RETURN_AMT,0)) NET_RETURN_AMT,
            SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)) TOTAL_BILL,ABS(SUM(ISNULL(A.BILL_SEC_AMT,0))) DEP_ADJ,
            SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0)) TOTAL_NET,
            SUM(A.PREV_BAL) PREV_BAL, ABS(SUM(A.REC_AMT)) REC_AMT,SUM(ISNULL(A.DN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0)) DN_AMT, SUM(A.CN_AMT) CN_AMT,SUM(ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0)) DR_CR_AMT,
            SUM(((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0)+ISNULL(A.PREV_BAL,0)+ISNULL(A.REC_AMT,0)+ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0))) NET_BAL,
            ABS(SUM(ISNULL(A.SEC_OPBAL,0))) DEPOSIT_BALANCE,A.REMARKS DROP_POINT
            from #cir_temp_bill_collection a
            group by a.comp_code,a.unit_code,a.agcd,a.dpcd,a.agname,a.agname_oth_lang,a.state_code,a.remarks
            order by comp_code,unit_code,state_name,ag_name;

            SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.STATE_CODE STATE_NAME,
            SUM(ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)) BILL_AMT,SUM(A.COMM_AMT) COMM_AMT,SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))) NET_BILL,
            SUM(A.RETURN_COPY) RETURN_COPY,SUM(ISNULL(A.RETURN_AMT,0)+ISNULL(RET_COMM_AMT,0)) RETURN_AMT,SUM(ISNULL(A.RETURN_AMT,0))  NET_RETURN_AMT,
            SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)) TOTAL_BILL,ABS(SUM(ISNULL(A.BILL_SEC_AMT,0))) DEP_ADJ,
            SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0)) TOTAL_NET,
            SUM(A.PREV_BAL) PREV_BAL, ABS(SUM(A.REC_AMT)) REC_AMT,SUM(ISNULL(A.DN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0)) DN_AMT, SUM(A.CN_AMT) CN_AMT,SUM(ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0)) DR_CR_AMT,
            SUM(((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0)+ISNULL(A.PREV_BAL,0)+ISNULL(A.REC_AMT,0)+ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0))) NET_BAL,
            ABS(SUM(ISNULL(A.SEC_OPBAL,0))) DEPOSIT_BALANCE
            from #cir_temp_bill_collection a
            group by a.comp_code,a.unit_code,a.state_code
            order by comp_code,unit_code,state_name;
        End    
        If @repty='D' Begin

            SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.AGCD AGCD,A.DPCD DPCD,A.AGNAME AG_NAME,A.AGNAME_OTH_LANG AG_NAME_OTH_LANG,
            A.STATE_CODE STATE_NAME,A.DIST_CODE DISTRICT_NAME,
            SUM(ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)) BILL_AMT,SUM(A.COMM_AMT) COMM_AMT,SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))) NET_BILL,
            SUM(ISNULL(A.RETURN_AMT,0)+ISNULL(A.RET_COMM_AMT,0)) RETURN_AMT,SUM(A.RETURN_AMT) NET_RETURN_AMT,
            SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)) TOTAL_BILL,ABS(SUM(ISNULL(A.BILL_SEC_AMT,0))) DEP_ADJ,
            SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0)) TOTAL_NET,
            SUM(A.PREV_BAL) PREV_BAL, ABS(SUM(A.REC_AMT)) REC_AMT,SUM(ISNULL(A.DN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0)) DN_AMT, SUM(A.CN_AMT) CN_AMT,SUM(ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0)) DR_CR_AMT,
            SUM(((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0)+ISNULL(A.PREV_BAL,0)+ISNULL(A.REC_AMT,0)+ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0))) NET_BAL,
            ABS(SUM(ISNULL(A.SEC_OPBAL,0))) DEPOSIT_BALANCE,A.REMARKS DROP_POINT
            from #cir_temp_bill_collection a
            group by a.comp_code,a.unit_code,a.agcd,a.dpcd,a.agname,a.agname_oth_lang,a.state_code,a.dist_code,a.remarks
            order by comp_code,unit_code,state_name,district_name,ag_name;

            SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.DIST_CODE DISTRICT_NAME,
            A.STATE_CODE STATE_NAME,
            SUM(A.SUPPLY_COPY) SUPPLY_CODE,SUM(ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)) BILL_AMT,SUM(A.COMM_AMT) COMM_AMT,SUM(ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0)) NET_BILL,
            SUM(A.RETURN_COPY) RETURN_COPY,SUM(ISNULL(A.RETURN_AMT,0)+ISNULL(A.RET_COMM_AMT,0)) RETURN_AMT,SUM(A.RETURN_AMT) NET_RETURN_AMT,
            SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)) TOTAL_BILL,ABS(SUM(ISNULL(A.BILL_SEC_AMT,0))) DEP_ADJ,
            SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0)) TOTAL_NET,
            SUM(A.PREV_BAL) PREV_BAL, ABS(SUM(A.REC_AMT)) REC_AMT,SUM(ISNULL(A.DN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0)) DN_AMT, SUM(A.CN_AMT) CN_AMT,SUM(ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0)) DR_CR_AMT,
            SUM(((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0)+ISNULL(A.PREV_BAL,0)+ISNULL(A.REC_AMT,0)+ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0))) NET_BAL,
            ABS(SUM(ISNULL(A.SEC_OPBAL,0))) DEPOSIT_BALANCE
            from #cir_temp_bill_collection a
            group by a.comp_code,a.unit_code,a.state_code,a.dist_code
            order by comp_code,unit_code,state_name,district_name
		End
        If @repty='C' Begin

            SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.AGCD AGCD,A.DPCD DPCD,A.AGNAME AG_NAME,A.AGNAME_OTH_LANG AG_NAME_OTH_LANG,
            A.STATE_CODE STATE_NAME,A.DIST_CODE DISTRICT_NAME,A.CITY_CODE CITY_NAME,
            SUM(ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)) BILL_AMT,SUM(A.COMM_AMT) COMM_AMT,SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))) NET_BILL,
            SUM(ISNULL(A.RETURN_AMT,0)+ISNULL(RET_COMM_AMT,0)) RETURN_AMT,SUM(A.RETURN_AMT) NET_RETURN_AMT,
            SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)) TOTAL_BILL,ABS(SUM(ISNULL(A.BILL_SEC_AMT,0))) DEP_ADJ,
            SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0)) TOTAL_NET,
            SUM(A.PREV_BAL) PREV_BAL, ABS(SUM(A.REC_AMT)) REC_AMT,SUM(ISNULL(A.DN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0)) DN_AMT, SUM(A.CN_AMT) CN_AMT,SUM(ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0)) DR_CR_AMT,
            SUM(((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0)+ISNULL(A.PREV_BAL,0)+ISNULL(A.REC_AMT,0)+ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0))) NET_BAL,
            ABS(SUM(ISNULL(A.SEC_OPBAL,0))) DEPOSIT_BALANCE,A.REMARKS DROP_POINT
            from #cir_temp_bill_collection a
            group by a.comp_code,a.unit_code,a.agcd,a.dpcd,a.agname,a.agname_oth_lang,a.state_code,a.dist_code,a.city_code,a.remarks
            order by comp_code,unit_code,state_name,district_name,city_name,ag_name;

            SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.CITY_CODE CITY_NAME,
            A.DIST_CODE DISTRICT_NAME,A.STATE_CODE STATE_NAME,
            SUM(ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)) BILL_AMT,A.COMM_AMT COMM_AMT,(ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0)) NET_BILL,
            SUM(ISNULL(A.RETURN_AMT,0)+ISNULL(RET_COMM_AMT,0)) RETURN_AMT,SUM(A.RETURN_AMT) NET_RETURN_AMT,
            SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)) TOTAL_BILL,ABS(SUM(ISNULL(A.BILL_SEC_AMT,0))) DEP_ADJ,
            SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0)) TOTAL_NET,
            SUM(A.PREV_BAL) PREV_BAL, ABS(SUM(A.REC_AMT)) REC_AMT,SUM(ISNULL(A.DN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0)) DN_AMT, SUM(A.CN_AMT) CN_AMT,SUM(ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0)) DR_CR_AMT,
            SUM(((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0)+ISNULL(A.PREV_BAL,0)+ISNULL(A.REC_AMT,0)+ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0))) NET_BAL,
            ABS(SUM(ISNULL(A.SEC_OPBAL,0))) DEPOSIT_BALANCE
            from #cir_temp_bill_collection a
            group by a.comp_code,a.unit_code,a.city_code,a.dist_code,a.state_code
            order by comp_code,unit_code,state_name,district_name,city_name;
		End            
        If @repty='T' Begin
            SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.AGCD AGCD,A.DPCD DPCD,A.AGNAME AG_NAME,A.AGNAME_OTH_LANG AG_NAME_OTH_LANG,
            A.STATE_CODE STATE_NAME,A.DIST_CODE DISTRICT_NAME,
            A.TALUKA_CODE+'('+A.DIST_CODE+')' TALUKA_NAME,
            SUM(ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)) BILL_AMT,SUM(A.COMM_AMT) COMM_AMT,SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))) NET_BILL,
            SUM(ISNULL(A.RETURN_AMT,0)+ISNULL(A.RET_COMM_AMT,0)) RETURN_AMT,SUM(A.RETURN_AMT) NET_RETURN_AMT,
            SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)) TOTAL_BILL,ABS(SUM(ISNULL(A.BILL_SEC_AMT,0))) DEP_ADJ,
            SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0)) TOTAL_NET,
            SUM(A.PREV_BAL) PREV_BAL, ABS(SUM(A.REC_AMT)) REC_AMT,SUM(ISNULL(A.DN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0)) DN_AMT, SUM(A.CN_AMT) CN_AMT,SUM(ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0)) DR_CR_AMT,
            SUM(((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0)+ISNULL(A.PREV_BAL,0)+ISNULL(A.REC_AMT,0)+ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0))) NET_BAL,
            ABS(SUM(ISNULL(A.SEC_OPBAL,0))) DEPOSIT_BALANCE,A.REMARKS DROP_POINT
            from #cir_temp_bill_collection a
            group by a.comp_code,a.unit_code,a.agcd,a.dpcd,a.agname,a.agname_oth_lang,a.taluka_code,a.dist_code,a.remarks,a.state_code
            order by comp_code,unit_code,state_name,district_name,taluka_name,ag_name;

            SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.STATE_CODE STATE_NAME,A.DIST_CODE DISTRICT_NAME,
            A.TALUKA_CODE+'('+A.DIST_CODE+')' TALUKA_NAME,
            SUM(ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)) BILL_AMT,SUM(A.COMM_AMT) COMM_AMT,SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))) NET_BILL,
            SUM(ISNULL(A.RETURN_AMT,0)+ISNULL(RET_COMM_AMT,0)) RETURN_AMT,SUM(A.RETURN_AMT) NET_RETURN_AMT,
            SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)) TOTAL_BILL,ABS(SUM(ISNULL(A.BILL_SEC_AMT,0))) DEP_ADJ,
            SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0)) TOTAL_NET,
            SUM(A.PREV_BAL) PREV_BAL, ABS(SUM(A.REC_AMT)) REC_AMT,SUM(ISNULL(A.DN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0)) DN_AMT, SUM(A.CN_AMT) CN_AMT,SUM(ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0)) DR_CR_AMT,
            SUM(((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0)+ISNULL(A.PREV_BAL,0)+ISNULL(A.REC_AMT,0)+ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0))) NET_BAL,
            ABS(SUM(ISNULL(A.SEC_OPBAL,0))) DEPOSIT_BALANCE
            from #cir_temp_bill_collection a
            group by a.comp_code,a.unit_code,a.taluka_code,a.dist_code,a.state_code
            order by comp_code,unit_code,state_name,district_name,taluka_name;
        End	

		
 DEALLOCATE cur_bill
deallocate cur_type




/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////update by Garima isssue number 0006266 
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER procedure [dbo].[cir_rep_abc_cir_monthwise_billing_summary]
        @pcomp_code			as varchar(20),
        @punit_code         as varchar(20),
        @pbrancode			as varchar(20),
        @ppublcode			as varchar(20),
        @pagtype			as varchar(20),
        @pstatecode			as varchar(20),
        @pcitycode			as varchar(20),
        @pfromdate			as datetime,
        @ptilldate			as datetime,
        @pdateformat		as varchar(20),
        @pextra1			as varchar(20),
        @pextra2			as varchar(20)
    As
   Begin
        
        select b.comp_code comp_code,b.unit_code unit_code,dbo.GetLastDayOfMonth(b.billdt) billdt,
		REPLACE(SUBSTRING(CONVERT(VARCHAR(11), dbo.GetLastDayOfMonth(b.billdt), 113), 4, 8),' ' ,'/') month_date,
		sum(b.bill_copy) billing_copy,sum(b.gross_amount) gross_amount,
		sum(b.sur_amt) sur_amount, sum(b.comm_amt) comm_amount,sum(b.bill_amount) bill_amount 
        from cir_agmast a,cir_bill_det b 
        where a.comp_code=b.comp_code and b.comp_code=@pcomp_code
 and a.unit=b.unit_code and b.unit_code=@punit_code 
and         a.agcd=b.agcd and a.dpcd=b.dpcd 
and (a.branch_code=isnull(@pbrancode,a.branch_code) or @pbrancode='') 
and (a.ag_type=isnull(@pagtype,a.ag_type) or @pagtype='') 
and         (b.publ=isnull(@ppublcode,b.publ) or @ppublcode='') 
and b.billdt between @pfromdate and @ptilldate
        group by b.comp_code,b.unit_code,dbo.GetLastDayOfMonth(b.billdt)
        order by comp_code,unit_code,billdt
        
        
   End


///////////////////////////////////////end by Garima 0006266 




/******************mimoh 17/feb/2012*****************6736***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[cir_agency_unblock_approval]
    @pcomp_code         as varchar(200),
    @punit_code         as varchar(200),
    @pbran_code         as varchar(200),
    @pstatus            as varchar(200),
    @pfrdt              as datetime,
    @ptodt              as datetime,
    @pagcd              as varchar(200),
    @pdpcd              as varchar(200),
    @psuspty            as varchar(200),
    @puserid            as varchar(200) 
    as
Begin
	If @punit_code='' Begin
		set @punit_code=null
	End	
	If @pbran_code='' Begin
		set @pbran_code=null
	End	
	If @pstatus='' Begin
		set @pstatus=null
	End	
	If @pagcd='' Begin
		set @pagcd=null
	End					
	If @pdpcd='' Begin
		set @pdpcd=null
	End	
	If @psuspty='' Begin
		set @psuspty=null
	End		
	If @puserid='' Begin
		set @puserid=null
	End	

select s.comp_code as "COMP_CODE",s.unit as "UNIT",s.agcd as "AGCD",s.dpcd as "DPCD",m.ag_name as "AGENCY_NAME",
dbo.cir_get_drop_point_name(s.comp_code,s.unit,m.station_code,1) as "DROP_POINT_NAME",dbo.cir_get_city(s.comp_code,m.city_code) as "CITY_NAME",
s.SUSP_DATE as "BLOCK_UNBLOCK_DATE",convert(varchar(25),s.CREATION_DATE,108) as "BLOCK_UNBLOCK_TIME",
         (SELECT SUSPEND_DESC FROM CIR_SUSPEND_TYPE_MAST WHERE COMP_CODE=s.COMP_CODE AND SUSPEND_TYPE_CODE=s.suspty) as "BLOCK_REASON",s.suspty as "SUSPTY",
         (SELECT max("username") from login where com_code = s.comp_code  and "userid"=s.userid) as "UNBLOCK_BY",s.suspty as "SUSPEND_TYPE",
         s.agency_unblock_approval as "AGENCY_UNBLOCK_APPROVAL",s.userid as "USERID",isnull(s.trn_date,convert(varchar(20),creation_date,103)) as "TRN_DATE" 
         from cir_suspend_tran s,cir_agmast m
      where s.comp_code = m.comp_code and s.comp_code = @pcomp_code
		  and s.SUSPTY=isnull(@psuspty,s.SUSPTY)
		  and m.BRANCH_CODE=isnull(@pbran_code,m.BRANCH_CODE)
        and s.unit=m.unit and s.unit      = isnull(@punit_code,s.unit)
        and s.susp      = @pstatus
        and s.trn_date between @pfrdt and @ptodt
        and s.agcd=m.agcd and s.agcd    = isnull(@pagcd,s.agcd)
        and s.dpcd=m.dpcd and s.dpcd    = isnull(@pdpcd,s.dpcd)
        and s.userid  = isnull(@puserid,s.userid)
        and isnull(s.agency_unblock_approval,'N')='N'    
  
End 



/******************mimoh 17/feb/2012*****************6736***********/

change by Garima

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




ALTER procedure [dbo].[cir_rep_abc_cir_rate_comm_supply_unsold]
     @pcomp_code 		as varchar(20),
     @punit_code 		as varchar(20),
     @pbrancode         as varchar(20),
     @ppublcode         as varchar(20),
     @pagtype 			as varchar(20),
     @pfrom_supdate 	as datetime,
     @ptill_supdate 	as datetime,
     @preptype          as varchar(20),--for comm & rate wise supply & unsold--
     @pdateformat 		as varchar(20),
     @pextra1 			as varchar(20),
     @pextra2           as varchar(20)
    As
     declare @vfrdt    datetime
     declare @vtodt    datetime
     declare @v_dt     datetime
     declare @v_cnt    INT
     declare @vvar     varchar(8000)
     declare @vvar_sum  varchar(8000)
     declare @vvar_sum1 varchar(8000)
     declare @v_query   varchar(8000)
     declare @v_query1  varchar(8000)
       
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
				set @v_cnt        = @v_cnt+1
				if @preptype in('CS','RS') 
					Begin--comm. wise & Rate wise supply--
						if @vvar is null 
							Begin
								set @vvar        ='case CONVERT(VARCHAR(10), dbo.GetlastDayOfMonth(b.billdt), 101) when '+''''+CONVERT(VARCHAR(10), @V_DT, 101)+''''+' then sum(b.bill_copy) else sum(0) end "'+SUBSTRING(CONVERT(VARCHAR(11), @V_DT, 113), 4, 8) +'"'
								--set @vvar        ='sum(decode(dbo.GetFirstDayOfMonth(b.billdt),'+''''+CONVERT(VARCHAR(11), @V_DT, 103)+''''+',b.bill_copy,0))"'+SUBSTRING(CONVERT(VARCHAR(11), @V_DT, 113), 4, 8) +'"'
								set @vvar_sum    ='sum('+'"'+SUBSTRING(CONVERT(VARCHAR(11), @V_DT, 113), 4, 8)+'") "'+SUBSTRING(CONVERT(VARCHAR(11), @V_DT, 113), 4, 8)+'"'
								set @vvar_sum1   ='sum('+'"'+SUBSTRING(CONVERT(VARCHAR(11), @V_DT, 113), 4, 8)+'"'
							End
						else
							Begin
								set @vvar        =	@vvar+','+'case CONVERT(VARCHAR(10), dbo.GetlastDayOfMonth(b.billdt), 101) when '+''''+CONVERT(VARCHAR(10), @V_DT, 101)+''''+' then sum(b.bill_copy) else sum(0) end "'+SUBSTRING(CONVERT(VARCHAR(11), @V_DT, 113), 4, 8) +'"'
								set @vvar_sum    =	@vvar_sum+','+'sum('+'"'+SUBSTRING(CONVERT(VARCHAR(11), @V_DT, 113), 4, 8)+'") "'+SUBSTRING(CONVERT(VARCHAR(11), @V_DT, 113), 4, 8)+'"'
								set @vvar_sum1   =	@vvar_sum1+'+"'+SUBSTRING(CONVERT(VARCHAR(11), @V_DT, 113), 4, 8)+'"'
							End
					End
				else if @preptype in('CU','RU') --comm. wise & Rate wise unsold--
					Begin
						if @vvar is null 
							Begin
												--case dbo.GetFirstDayOfMonth(b.app_dt) when '+''''+CONVERT(VARCHAR(11), @V_DT, 103)+''''+' then sum(isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0)) else sum(0) end "'+SUBSTRING(CONVERT(VARCHAR(11), @V_DT, 113), 4, 8) +'"'
								set @vvar        ='case CONVERT(VARCHAR(10), dbo.GetlastDayOfMonth(b.app_dt), 101) when '+''''+CONVERT(VARCHAR(11), @V_DT, 103)+''''+' then sum(isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0)) else sum(0) end "'+SUBSTRING(CONVERT(VARCHAR(11), @V_DT, 113), 4, 8) +'"'
								set @vvar_sum    ='sum('+'"'+SUBSTRING(CONVERT(VARCHAR(11), @V_DT, 113), 4, 8)+'") "'+SUBSTRING(CONVERT(VARCHAR(11), @V_DT, 113), 4, 8)+'"';
								set @vvar_sum1   ='sum('+'"'+SUBSTRING(CONVERT(VARCHAR(11), @V_DT, 113), 4, 8)+'"';
							End
						else
							Begin
								set @vvar        =@vvar+','+'case CONVERT(VARCHAR(10), dbo.GetlastDayOfMonth(b.app_dt), 101) when '+''''+CONVERT(VARCHAR(11), @V_DT, 103)+''''+' then sum(isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0)) else sum(0) end "'+SUBSTRING(CONVERT(VARCHAR(11), @V_DT, 113), 4, 8) +'"'
								set @vvar_sum    =@vvar_sum+','+'sum('+'"'+SUBSTRING(CONVERT(VARCHAR(11), @V_DT, 113), 4, 8)+'") "'+SUBSTRING(CONVERT(VARCHAR(11), @V_DT, 113), 4, 8)+'"';
								set @vvar_sum1   =@vvar_sum1+'+"'+SUBSTRING(CONVERT(VARCHAR(11), @V_DT, 113), 4, 8)+'"';
							End
					End
					
					fetch NEXT FROM c1 INTO @v_dt
			End
		close c1
		deallocate c1

		if @vvar_sum1 is not null 
			Begin
				set @vvar_sum1=@vvar_sum1+') "Total"'
			End

		if @preptype='CS' --comm. wise supply-- 
			Begin
				set @v_query='select comp_code,unit_code,comm_rate ,'+@vvar_sum+','+@vvar_sum1+' from (select b.comp_code comp_code,b.unit_code unit_code,isnull(b.comm_rate,0) comm_rate, '+@vvar+' from cir_agmast a, cir_bill_det b
				where a.comp_code=b.comp_code and b.comp_code='+''''+@pcomp_code+''''+' and a.unit=b.unit_code and b.unit_code='+''''+@punit_code+''''+' and 
				a.agcd=b.agcd and a.dpcd=b.dpcd and (a.branch_code=isnull('+''''+@pbrancode+''''+',a.branch_code) or '''+@pbrancode+''' ='''') and (a.ag_type=isnull('+''''+@pagtype+''''+',a.ag_type) or '''+@pagtype+''' ='''') and (b.publ=isnull('+''''+@ppublcode+''''+',b.publ) or '''+@ppublcode+''' ='''') and
				b.billdt between '+''''+CONVERT(VARCHAR(11), @VFRDT, 101)+''''+' and '+''''+CONVERT(VARCHAR(11), @VTODT, 101)+''''+' group by b.comp_code,b.unit_code,b.billdt,b.comm_rate) x
				group by comp_code,unit_code,comm_rate order by comp_code,unit_code,comm_rate'
        
				set @v_query1='select comp_code,unit_code,'+@vvar_sum+','+@vvar_sum1+' from 
				(select b.comp_code comp_code,b.unit_code unit_code,isnull(b.comm_rate,0) comm_rate, '+@vvar+' from cir_agmast a, cir_bill_det b
				where a.comp_code=b.comp_code and b.comp_code='+''''+@pcomp_code+''''+' and a.unit=b.unit_code and b.unit_code='+''''+@punit_code+''''+' and 
				a.agcd=b.agcd and a.dpcd=b.dpcd and (a.branch_code=isnull('+''''+@pbrancode+''''+',a.branch_code) or '''+@pbrancode+''' ='''') and (a.ag_type=isnull('+''''+@pagtype+''''+',a.ag_type) or '''+@pagtype+''' ='''') and (b.publ=isnull('+''''+@ppublcode+''''+',b.publ) or '''+@ppublcode+''' ='''') and
				b.billdt between '+''''+CONVERT(VARCHAR(11), @VFRDT, 101)+''''+' and '+''''+CONVERT(VARCHAR(11), @VTODT, 101)+''''+' group by b.comp_code,b.unit_code,b.billdt,b.comm_rate) x
				group by comp_code,unit_code order by comp_code,unit_code' 

			End
		else if @preptype='RS' -- Edition Rate wise supply-- 
			Begin	
				set @v_query='select comp_code,unit_code,publ,dbo.cir_get_publ_name(comp_code,publ) publ_name,dbo.cir_get_publ_seqno(comp_code,publ) publ_seqno,edtn,dbo.cir_get_edtn_name(comp_code,edtn) edtn_name,dbo.cir_get_edtn_seqno(comp_code,edtn) edtn_seqno,copy_rate ,'+@vvar_sum+','+@vvar_sum1+' 
				from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,isnull(b.copy_rate,0) copy_rate, '+@vvar+' from cir_agmast a, cir_bill_det b
				where a.comp_code=b.comp_code and b.comp_code='+''''+@pcomp_code+''''+' and a.unit=b.unit_code and b.unit_code='+''''+@punit_code+''''+' and 
				a.agcd=b.agcd and a.dpcd=b.dpcd and (a.branch_code=isnull('+''''+@pbrancode+''''+',a.branch_code) or '''+@pbrancode+''' ='''')and (a.ag_type=isnull('+''''+@pagtype+''''+',a.ag_type) or '''+@pagtype+''' ='''') and (b.publ=isnull('+''''+@ppublcode+''''+',b.publ) or '''+@ppublcode+''' ='''') and
				b.billdt between '+''''+CONVERT(VARCHAR(11), @VFRDT, 101)+''''+' and '+''''+CONVERT(VARCHAR(11), @VTODT, 101)+''''+' group by b.comp_code,b.unit_code,b.billdt,b.publ,b.edtn,b.copy_rate) x
				group by comp_code,unit_code,publ,edtn,copy_rate order by comp_code,unit_code,publ_seqno,publ,edtn_seqno,edtn,copy_rate'

				set @v_query1='select comp_code,unit_code,'+@vvar_sum+','+@vvar_sum1+' 
				from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,isnull(b.copy_rate,0) copy_rate, '+@vvar+' from cir_agmast a, cir_bill_det b
				where a.comp_code=b.comp_code and b.comp_code='+''''+@pcomp_code+''''+' and a.unit=b.unit_code and b.unit_code='+''''+@punit_code+''''+' and 
				a.agcd=b.agcd and a.dpcd=b.dpcd and (a.branch_code=isnull('+''''+@pbrancode+''''+',a.branch_code) or '''+@pbrancode+''' ='''') and (a.ag_type=isnull('+''''+@pagtype+''''+',a.ag_type) or '''+@pagtype+''' ='''') and (b.publ=isnull('+''''+@ppublcode+''''+',b.publ) or '''+@ppublcode+''' ='''') and
				b.billdt between '+''''+CONVERT(VARCHAR(11), @VFRDT, 101)+''''+' and '+''''+CONVERT(VARCHAR(11), @VTODT, 101)+''''+' group by b.comp_code,b.unit_code,b.billdt,b.publ,b.edtn,b.copy_rate) x
				group by comp_code,unit_code order by comp_code,unit_code'
			End
		else if @preptype='CU' --comm. wise unsold-- 
			Begin
				set @v_query='select comp_code,unit_code,comm_rate ,'+@vvar_sum+','+@vvar_sum1+' from (select b.comp_code comp_code,b.unit_code unit_code,isnull(b.comm_rate,0) comm_rate, '+@vvar+' from cir_agmast a, cir_unsold_dtl b
				where a.comp_code=b.comp_code and b.comp_code='+''''+@pcomp_code+''''+' and a.unit=b.unit_code and b.unit_code='+''''+@punit_code+''''+' and 
				a.agcd=b.agcd and a.dpcd=b.dpcd and (a.branch_code=isnull('+''''+@pbrancode+''''+',a.branch_code) or '''+@pbrancode+''' ='''') and (a.ag_type=isnull('+''''+@pagtype+''''+',a.ag_type) or '''+@pagtype+''' ='''') and (b.publ=isnull('+''''+@ppublcode+''''+',b.publ) or '''+@ppublcode+''' ='''') and
				b.app_dt between '+''''+CONVERT(VARCHAR(11), @VFRDT, 101)+''''+' and '+''''+CONVERT(VARCHAR(11), @VTODT, 101)+''''+' group by b.comp_code,b.unit_code,b.app_dt,b.comm_rate) x
				group by comp_code,unit_code,comm_rate order by comp_code,unit_code,comm_rate'; 
		        
				set @v_query1='select comp_code,unit_code,'+@vvar_sum+','+@vvar_sum1+' from (select b.comp_code comp_code,b.unit_code unit_code,isnull(b.comm_rate,0) comm_rate, '+@vvar+' from cir_agmast a, cir_unsold_dtl b
				where a.comp_code=b.comp_code and b.comp_code='+''''+@pcomp_code+''''+' and a.unit=b.unit_code and b.unit_code='+''''+@punit_code+''''+' and 
				a.agcd=b.agcd and a.dpcd=b.dpcd and (a.branch_code=isnull('+''''+@pbrancode+''''+',a.branch_code) or '''+@pbrancode+''' ='''') and (a.ag_type=isnull('+''''+@pagtype+''''+',a.ag_type) or '''+@pagtype+''' ='''') and (b.publ=isnull('+''''+@ppublcode+''''+',b.publ) or '''+@ppublcode+''' ='''') and
				b.app_dt between '+''''+CONVERT(VARCHAR(11), @VFRDT, 101)+''''+' and '+''''+CONVERT(VARCHAR(11), @VTODT, 101)+''''+' group by b.comp_code,b.unit_code,b.app_dt,b.comm_rate) x
				group by comp_code,unit_code order by comp_code,unit_code'
			End
		else if @preptype='RU' -- Edition Rate wise Unsold-- 
			Begin
				set @v_query='select comp_code,unit_code,publ,dbo.cir_get_publ_name(comp_code,publ) publ_name,dbo.cir_get_publ_seqno(comp_code,publ) publ_seqno,edtn,dbo.cir_get_edtn_name(comp_code,edtn) edtn_name,dbo.cir_get_edtn_seqno(comp_code,edtn) edtn_seqno,copy_rate ,'+@vvar_sum+','+@vvar_sum1+' 
				from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,isnull(b.copy_rate,0) copy_rate, '+@vvar+' from cir_agmast a, cir_unsold_dtl b
				where a.comp_code=b.comp_code and b.comp_code='+''''+@pcomp_code+''''+' and a.unit=b.unit_code and b.unit_code='+''''+@punit_code+''''+' and 
				a.agcd=b.agcd and a.dpcd=b.dpcd and (a.branch_code=isnull('+''''+@pbrancode+''''+',a.branch_code) or '''+@pbrancode+''' ='''') and (a.ag_type=isnull('+''''+@pagtype+''''+',a.ag_type) or '''+@pagtype+''' ='''') and (b.publ=isnull('+''''+@ppublcode+''''+',b.publ) or '''+@ppublcode+''' ='''') and
				b.app_dt between '+''''+CONVERT(VARCHAR(11), @VFRDT, 101)+''''+' and '+''''+CONVERT(VARCHAR(11), @VTODT, 101)+''''+' group by b.comp_code,b.unit_code,b.app_dt,b.publ,b.edtn,b.copy_rate) x
				group by comp_code,unit_code,publ,edtn,copy_rate order by comp_code,unit_code,publ_seqno,publ,edtn_seqno,edtn,copy_rate'
	        
				set @v_query1='select comp_code,unit_code,'+@vvar_sum+','+@vvar_sum1+' 
				from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,isnull(b.copy_rate,0) copy_rate, '+@vvar+' from cir_agmast a, cir_unsold_dtl b
				where a.comp_code=b.comp_code and b.comp_code='+''''+@pcomp_code+''''+' and a.unit=b.unit_code and b.unit_code='+''''+@punit_code+''''+' and 
				a.agcd=b.agcd and a.dpcd=b.dpcd and (a.branch_code=isnull('+''''+@pbrancode+''''+',a.branch_code) or '''+@pbrancode+''' ='''') and (a.ag_type=isnull('+''''+@pagtype+''''+',a.ag_type) or '''+@pagtype+''' ='''') and (b.publ=isnull('+''''+@ppublcode+''''+',b.publ) or '''+@ppublcode+''' ='''') and
				b.app_dt between '+''''+CONVERT(VARCHAR(11), @VFRDT, 101)+''''+' and '+''''+CONVERT(VARCHAR(11), @VTODT, 101)+''''+' group by b.comp_code,b.unit_code,b.app_dt,b.publ,b.edtn,b.copy_rate) x
				group by comp_code,unit_code order by comp_code,unit_code'
			End
    

print(@v_query)    

	exec (@v_query)
    --print('v_query')
	--print(@v_query)
 --print('v_query1')
--print(@v_query1)

print(@v_query1)   
    exec (@v_query1)
        
    End





//////////////////end by Garima

///////////
update by Garima
alter procedure cir_rep_inst_agency_wise(
      @pcompcode         as varchar(50),
      @punitcode         as varchar(50),
      @pbrancode         as varchar(50),
      @pagcd             as varchar(50),
      @pdpcd             as varchar(50),
      @pac_type          as varchar(50),
      @pfrom_dt          as varchar(50),
      @ptill_dt          as varchar(50),
      @ppaymode          as varchar(50),
      @preptype          as varchar(50),--D for Detail ,S for Summary
      @pdateformat       as varchar(50),
      @puserid           as varchar(50),
      @pextra1           as varchar(50),
      @pextra2           as varchar(50),
      @pextra3           as varchar(50),
      @pextra4           as varchar(50),
      @pextra5           as varchar,
      @pextra6           as varchar(50),
      @pextra7           as varchar(50),
      @pextra8           as varchar(50),
      @pextra9           as varchar(50),
      @pextra10          as varchar(50)     
     
      )
As

declare @v_frdt  as       datetime;
declare  @v_todt  as       datetime;


set @v_frdt=@pfrom_dt;
set @v_todt=@ptill_dt;

if (@preptype='D') begin--details
                    
      
        select x.comp_code as "COMP_CODE", x.unit_code as "UNIT_CODE", x.inst_date as "INST_DATE", x.inst_code as "INST_CODE",
        x.agcd as "AGCD", x.dpcd as "DPCD",x.ag_name as "AG_NAME",x.branch_code as "BRANCH_CODE",(select "Branch_Name" from branch_mst where "Branch_Code"=x.branch_code) as "BRANCH_NAME",
        x.drop_point_name as "DROP_POINT_NAME", x.city_name as "CITY_NAME",x.state_name as "STATE_NAME",
        x.dist_name as "DIST_NAME",x.ag_type as "AG_TYPE",x.agency_type_name as "AGENCY_TYPE_NAME",
        x.inst_no as "INST_NO",x.inst_duedt as "INST_DUEDT" ,x.inst_enddt as "INST_ENDDT",
        x.inst_chqno as "INST_CHQNO",x.inst_chqdt as "INST_CHQDT",x.inst_chqamt as "INST_CHQAMT",x.inst_status as "INST_STATUS",
        x.inst_stdt as "INST_STDT", x.no_of_inst as "NO_OF_INST", x.tot_instamt as "TOT_INSTAMT", x.inst_freq as "INST_FREQ",
        x.inst_amt as "INST_AMT",x.paid_amt as "PAID_AMT",(isnull(x.inst_amt,0)-abs(isnull(x.paid_amt,0))) as "INST_BAL"
        FROM(select d.comp_code, d.unit_code, m.inst_date, d.inst_code,
        d.agcd, d.dpcd ,a.ag_name ,a.branch_code ,(select "Branch_Name" from branch_mst where "Branch_Code"=a.branch_code) as "BRANCH_NAME",
        dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,a.station_code,1) as "DROP_POINT_NAME", 
        dbo.cir_get_city(d.comp_code,a.city_code) as "CITY_NAME",dbo.cir_get_state(d.comp_code,a.country_code, a.state_code) as "STATE_NAME",
       dbo. cir_get_dist(d.comp_code,a.state_code,a.dist_code) as "DIST_NAME",
        a.ag_type ,(select agency_type_desc from cir_agency_typ_mast where comp_code=d.comp_code and agency_type_code=a.ag_type) as "AGENCY_TYPE_NAME",
        d.inst_no,d.inst_duedt ,d.inst_enddt,
        d.inst_chqno ,d.inst_chqdt,d.inst_chqamt ,d.inst_status ,m.inst_stdt , m.no_of_inst , m.tot_instamt , m.inst_freq ,
        d.inst_amt,(select abs(sum(inst_due_amt)) from cir_inst_bill_det where comp_code=m.comp_code and inst_code=m.inst_code and agcd=m.agcd and dpcd=m.dpcd and
        recptno is not null and recptdt<=@v_todt) as "PAID_AMT"
        from cir_installment_mast m,cir_installment_det d,cir_agmast a
        where d.comp_code=m.comp_code and d.comp_code=a.comp_code and d.comp_code=@pcompcode and d.unit_code=m.unit_code and d.unit_code=a.unit and 
        d.unit_code=isnull(@punitcode,d.unit_code) and 
        d.agcd=m.agcd and d.agcd=a.agcd and d.agcd=isnull(@pagcd,d.agcd) and d.dpcd=m.dpcd and d.dpcd=a.dpcd and d.dpcd=isnull(@pdpcd,d.dpcd) and m.achd=isnull(@pac_type,m.achd) and 
        m.inst_date between @v_frdt and @v_todt and (m.paymode=@ppaymode or @ppaymode is null)) x
          
        order by comp_code,unit_code,branch_name,ag_name,inst_date,inst_no;

end 



     else--for summrey
       begin
        select x.comp_code as "COMP_CODE", x.unit_code as "UNIT_CODE", x.agcd as "AGCD", x.dpcd as "DPCD",
        x.ag_name as "AG_NAME",x.branch_code as "BRANCH_CODE",x.branch_code as "BRANCH_NAME",
        x.drop_point_name as "DROP_POINT_NAME", x.city_name as "CITY_NAME",x.state_name as "STATE_NAME",x.dist_name as "DIST_NAME",
        x.ag_type as "AG_TYPE",x.agency_type_name as "AGENCY_TYPE_NAME",
        x.inst_freq as "INST_FREQ",x.inst_stdt as "INST_STDT",x.inst_enddt as "INST_ENDDT",
        x.inst_amt as "INST_AMT",x.paid_amt as "PAID_AMT",isnull(x.inst_amt,0)-isnull(x.paid_amt,0) as "BAL_AMT" from
        (select d.comp_code as "COMP_CODE", d.unit_code as "UNIT_CODE", d.agcd as "AGCD", d.dpcd as "DPCD",
        a.ag_name as "AG_NAME",a.branch_code as "BRANCH_CODE",(select "Branch_Name" from branch_mst where "Branch_Code"=a.branch_code) as "BRANCH_NAME",
        dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,a.station_code,1) as "DROP_POINT_NAME", 
        dbo.cir_get_city(d.comp_code,a.city_code) as "CITY_NAME",dbo.cir_get_state(d.comp_code,a.country_code, a.state_code) as "STATE_NAME",
        dbo.cir_get_dist(d.comp_code,a.state_code,a.dist_code) as "DIST_NAME",
        a.ag_type as "AG_TYPE",(select agency_type_desc from cir_agency_typ_mast where comp_code=d.comp_code and agency_type_code=a.ag_type) as "AGENCY_TYPE_NAME",
        m.inst_freq as "INST_FREQ",min(m.inst_stdt) as "INST_STDT",max(d.inst_enddt) as "INST_ENDDT",
        sum(d.inst_amt) as "INST_AMT",(select abs(sum(inst_due_amt)) from cir_inst_bill_det where comp_code=m.comp_code and inst_code=m.inst_code and agcd=m.agcd and dpcd=m.dpcd and
        recptno is not null and recptdt<=@v_todt) as "PAID_AMT"
        from cir_installment_mast m,cir_installment_det d,cir_agmast a
        where d.comp_code=m.comp_code and d.comp_code=a.comp_code and d.comp_code=@pcompcode and d.unit_code=m.unit_code and d.unit_code=a.unit and 
        d.unit_code=isnull(@punitcode,d.unit_code) and 
        d.agcd=m.agcd and d.agcd=a.agcd and d.agcd=isnull(@pagcd,d.agcd) and d.dpcd=m.dpcd and d.dpcd=a.dpcd and d.dpcd=isnull(@pdpcd,d.dpcd) and m.achd=isnull(@pac_type,m.achd) and 
        m.inst_date<=@v_todt and (m.paymode=@ppaymode or @ppaymode is null)  

        group by 
m.comp_code,
m.INST_CODE,
m.AGCD,
m.DPCD,
d.comp_code, d.unit_code, d.agcd, d.dpcd,a.ag_name,a.branch_code,a.station_code,
        a.city_code,a.country_code, a.state_code,a.dist_code,a.ag_type,m.inst_freq) x
        where isnull(x.inst_amt,0)-isnull(x.paid_amt,0)>0
        order by comp_code,unit_code,branch_name,ag_name;
     end 

/////////////////////end by Garima

////////start By Garima
alter procedure cir_rep_inst_overall
(
@pcompcode         as varchar(50),
@punitcode         as varchar(50),
@pbrancode         as varchar(50),
@pagcd             as varchar(50),
@pdpcd             as varchar(50),
@pac_type          as varchar(50),
@pfrom_dt          as varchar(50),
@ptill_dt          as varchar(50),
@ppaymode          as varchar(50),
@preptype          as varchar(50),--D for Detail ,S for Summary
@pdateformat       as varchar(50),
@puserid           as varchar(50),
@pextra1           as varchar(50),
@pextra2           as varchar(50),
@pextra3           as varchar(50),
@pextra4           as varchar(50),
@pextra5           as varchar(50),
@pextra6           as varchar(50),
@pextra7           as varchar(50),
@pextra8           as varchar(50),
@pextra9           as varchar(50)
)

as

declare  @v_frdt  as datetime;
declare  @v_todt  as datetime;

set @v_frdt    =@pfrom_dt;
set @v_todt    =@ptill_dt;


select x.comp_code as "COMP_CODE", x.unit_code as "UNIT_CODE",x.branch_code as "BRANCH_CODE",
                    (select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=x.unit_code) as "PUB_CENT_NAME",
                    (select "Branch_Name" from branch_mst where "Branch_Code"=x.branch_code) as "BRANCH_NAME",
                    sum(x.tot_instamt) as "TOT_INSTAMT",
                    sum(x.inst_amt) as "INST_AMT",sum(x.paid_amt) as "PAID_AMT",(sum(isnull(x.inst_amt,0))-sum(abs(isnull(x.paid_amt,0)))) as "INST_BAL"
                    FROM(select d.comp_code, d.unit_code, m.inst_date, d.inst_code,
                    a.branch_code ,(select "Branch_Name" from branch_mst where "Branch_Code"=a.branch_code) as "BRANCH_NAME",
                    m.tot_instamt ,d.inst_amt,(select abs(sum(inst_due_amt)) from cir_inst_bill_det
                    where comp_code=m.comp_code and inst_code=m.inst_code and agcd=m.agcd and dpcd=m.dpcd and
                    recptno is not null ) as "PAID_AMT"
                    from cir_installment_mast m,cir_installment_det d,cir_agmast a
                    where d.comp_code=m.comp_code and d.comp_code=a.comp_code
                    and d.comp_code=@pcompcode
                    and d.unit_code=m.unit_code and d.unit_code=a.unit
                    and  d.unit_code=isnull(@punitcode,d.unit_code)
                    and m.inst_date between @v_frdt and @v_todt
                    ) x group by  x.comp_code, x.unit_code,x.branch_code ;
                    /////////////////////////////////end By Garima

//-------------------------------------issue 6631-----------------


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[websp_pubcenter] 
 AS
select Pub_cent_Code,pub_cent_name + '(' +city_name + ')' as center from 
pub_cent_mast,city_mst where city_mst.city_code=pub_cent_mast.city_code and 
 isnull(PUB_CENT_MAST.PRINT_CENT,'Y') != 'N' ORDER BY "center"

select agency_name,code_subcode from agency_mast  ORDER BY Agency_Name;

//----------------------------------------------------------
/////////////////////start By Garima
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




ALTER procedure [dbo].[cir_rep_abc_cir_monthwise_billing_summary]
        @pcomp_code			as varchar(20),
        @punit_code         as varchar(20),
        @pbrancode			as varchar(20),
        @ppublcode			as varchar(20),
        @pagtype			as varchar(20),
        @pstatecode			as varchar(20),
        @pcitycode			as varchar(20),
        @pfromdate			as datetime,
        @ptilldate			as datetime,
        @pdateformat		as varchar(20),
        @pextra1			as varchar(20),
        @pextra2			as varchar(20)
    As
   Begin
        
        select b.comp_code comp_code,b.unit_code unit_code,dbo.GetLastDayOfMonth(b.billdt) billdt,
		REPLACE(SUBSTRING(CONVERT(VARCHAR(11), dbo.GetLastDayOfMonth(b.billdt), 113), 4, 8),' ' ,'/') month_date,
		sum(b.bill_copy) billing_copy,sum(b.gross_amount) gross_amount,
		sum(b.sur_amt) sur_amount, sum(b.comm_amt) comm_amount,sum(b.bill_amount) bill_amount 
        from cir_agmast a,cir_bill_det b 
        where a.comp_code=b.comp_code and b.comp_code=@pcomp_code
 and a.unit=b.unit_code and b.unit_code=@punit_code 
and         a.agcd=b.agcd and a.dpcd=b.dpcd 
and (a.branch_code=isnull(@pbrancode,a.branch_code) or @pbrancode='') 
and (a.ag_type=isnull(@pagtype,a.ag_type) or @pagtype='') 
and         (b.publ=isnull(@ppublcode,b.publ) or @ppublcode='') 
and b.billdt between @pfromdate and @ptilldate
        group by b.comp_code,b.unit_code,dbo.GetLastDayOfMonth(b.billdt)
        order by comp_code,unit_code,billdt
        
        
   End

//////////////////////////////////////////End By Garima

//---------------------------issue no. 6319--------------------------//

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[wesp_ModultPrevDisp]
@compcode        as varchar(8),
@userid            as varchar(20)=null,
@userhome        as varchar(20)=null,
@admin            as varchar(20)=null,
@retainer_code    as varchar(20)
AS
declare @agename  varchar(15)
--select distinct a.username,b.userid from module_detail b,login a where a.userid=b.userid

if(@admin='yes' and @userhome='Agency')
    begin
        select @agename=agency_code from login where  userid =@userid

        select distinct username,userid,(select "Agency_Role_Name" from agency_role_master where "Agency_Role_Code"=roleid) as "ROLE_NAME" from login
            where com_code=@compcode and company_user='Agency'  and agency_code=@agename order by username
    end
else
    begin
        select distinct username,userid,admin,company_user,(select "Agency_Role_Name" from agency_role_master where "Agency_Role_Code"=roleid) as "ROLE_NAME" from login
        where com_code=@compcode and retainer_code=@retainer_code  order by username
    end

//--------------------------------------------end of issue 6319--------


////////////////////////////////////////Sent by ashok sahani sir 21/02/2112///////////////////////////////////

ALTER PROCEDURE CIR_SUPPLY_POST_FOR_NEXT_DAY_cir_check_supply_posting_p
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@ppubl_code                               VARCHAR(20) ,
	@pedtn_code                               VARCHAR(20) ,
	@pagcd                                    VARCHAR(20) ,
	@pdpcd                                    VARCHAR(20) ,
	@psup_date                                DATETIME,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(40) ,
	@pextra2                                  VARCHAR(40) 
  
AS 
    declare @v_many_time_posting	varchar(1)
    declare @v_backdays_posting		numeric(10)
    declare @v_days					numeric(10)
    declare @v_bill_exist			numeric(10)
    declare @v_sup_copy				numeric(1)
  Begin	

    set @v_days=DATEDIFF(day,@psup_date,GETDATE())
    print('@v_days')
	print(@v_days)	

    select @v_bill_exist=count(*) from cir_bill_det d,cir_publ_mast p,cir_edtn_mast e
        where d.comp_code = p.comp_code and d.comp_code = e.comp_code and d.comp_code=@pcomp_code and d.unit_code=@punit_code and
        @psup_date between fromdt and todt and d.publ=p.publ and d.publ = @ppubl_code and d.edtn=e.edtn and e.main_edtn = isnull(@pedtn_code,e.main_edtn)
        	
    print('@v_bill_exist')
	print(@v_bill_exist)	
	
    select @v_many_time_posting=cir_many_time_posting,@v_backdays_posting=cir_backdays_posting from preferrences 
        where "comp_code"=@pcomp_code
    
    print('@v_many_time_posting')
    print(@v_many_time_posting)
    print('@v_backdays_posting')
    print(@v_backdays_posting)
    
	If @v_bill_exist=0 Begin
		if @psup_date-1>(GETDATE()) Begin
			print('1')
			if isnull(@v_many_time_posting,'N')='N' Begin
				print('2')
				select @v_sup_copy=isnull(sum(a.sup_copy),0) --as "SUP_COPY"
					from cir_dbksup a,cir_edtn_mast e
						where a.comp_code=@pcomp_code and a.comp_code=e.comp_code and a.unit_code=@punit_code and 
							a.publ=@ppubl_code and a.publ = e.publ and a.edtn= e.edtn and 
							a.supdate=@psup_date and a.agcd=isnull(@pagcd,a.agcd) and a.dpcd=isnull(@pdpcd,a.dpcd) and
							e.main_edtn = isnull(@pedtn_code,e.main_edtn)
			End
			Else Begin
				print('3')
				set @v_sup_copy=0
			End
		End    
		else Begin
			print('4')
			if isnull(@v_many_time_posting,'N')='N' Begin
				select @v_sup_copy=isnull(sum(a.sup_copy),0) --as "SUP_COPY"
					from cir_dbksup a,cir_edtn_mast e
						where a.comp_code=@pcomp_code and a.comp_code=e.comp_code and a.unit_code=@punit_code and 
							a.publ=@ppubl_code and a.publ = e.publ and a.edtn= e.edtn and 
							a.supdate=@psup_date and a.agcd=isnull(@pagcd,a.agcd) and a.dpcd=isnull(@pdpcd,a.dpcd) and
							e.main_edtn = isnull(@pedtn_code,e.main_edtn)
			End
			Else Begin
				if isnull(@v_backdays_posting,0)>0 Begin
					print('5')
					if @v_days>=@v_backdays_posting Begin
						print('6')
						set @v_sup_copy=0
					End
					else Begin
						print('7')
						set @v_sup_copy=1
					End
				End    
				else Begin
					print('8')
					set @v_sup_copy=0
				End
			End	
		End
	End	
	Else Begin
		set @v_sup_copy=1
	End
	select @v_sup_copy as "SUP_COPY"
 End
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

create function cir_get_edtn_rate(
  @pcomp_code	as varchar(20),
  @punit_code	as varchar(20),
  @pedtn_code	as varchar(20),
  @psup_date	as varchar(20),
  @pdateformat	as varchar(20)) returns numeric(10,4) as

Begin
	declare	@vsup_date		datetime
	declare @v_publ			varchar(10)
	declare @v_supday		varchar(10)
	declare @v_sun_rate		numeric(10,4)
	declare @v_mon_rate		numeric(10,4)
	declare @v_tue_rate		numeric(10,4)
	declare @v_wed_rate		numeric(10,4)
	declare @v_thu_rate		numeric(10,4)
	declare @v_fri_rate		numeric(10,4)
	declare @v_sat_rate		numeric(10,4)
	declare @v_edtn_rate	numeric(10,4)

	set @vsup_date=dbo.convert_user_date('/',@psup_date,@pdateformat)
	
	select distinct @v_publ=publ from cir_edtn_mast
		where comp_code=@pcomp_code and edtn=@pedtn_code

	select @v_edtn_rate=spl_day_rate from cir_special_rate_mast
		where comp_code=@pcomp_code and unit=@punit_code and
		publ=@v_publ and edtn=@pedtn_code and spl_day_date=@vsup_date;
								
    If @v_edtn_rate=0 Begin
	   select distinct @v_sun_rate=sun_rate,@v_mon_rate=mon_rate,@v_tue_rate=tue_rate,@v_wed_rate=wed_rate,@v_thu_rate=thu_rate,
		@v_fri_rate=fri_rate,@v_sat_rate=sat_rate from cir_rate_mast
	   where comp_code=@pcomp_code and unit=@punit_code and publ=@v_publ and edtn=@pedtn_code and
			   valid_from=(select max(valid_from) from cir_rate_mast where comp_code=@pcomp_code and
			   unit=@punit_code and publ=@v_publ and edtn=@pedtn_code and valid_from<=@vsup_date)
           
		set @v_supday=upper(substring(CONVERT(VARCHAR(20) , DATENAME(WEEKDAY, @psup_date),20),1,3))
	
		if @v_supday = 'SUN' Begin   ---for sunday edition rate
		  set @v_edtn_rate  = @v_sun_rate
		End
		Else if @v_supday = 'MON' Begin ---for monday edition rate
			set @v_edtn_rate  = @v_mon_rate
		End
		Else if @v_supday = 'TUE' Begin ---for tueday edition rate
			set @v_edtn_rate  = @v_tue_rate;
		End
		Else if @v_supday = 'WED' Begin ---for wednesday edition rate
			set @v_edtn_rate  = @v_wed_rate;
		End
		Else if @v_supday = 'THU' Begin ---for Thursday edition rate
			set @v_edtn_rate  = @v_thu_rate;
		End
		Else if @v_supday = 'FRI' Begin ---for friday edition rate
			set @v_edtn_rate  = @v_fri_rate
		End    
		Else if @v_supday = 'SAT' Begin ---for saturday edition rate
			set @v_edtn_rate  = @v_sat_rate
		End    
		Else Begin
			set @v_edtn_rate  = 0
		End
    End
    
    return @v_edtn_rate
END


////////////////////////////////////////////end////////////////////////////////////////////////////////////////////////////

//--------------------------------------6440----------------------//

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
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
		dbo.cir_get_agency(cir_agmast_dis.comp_code,cir_agmast_dis.unit,cir_agmast_dis.agcd,cir_agmast_dis.dpcd) "BILL_AGENCY",
		dbo.cir_get_agency_city(cir_agmast_dis.comp_code,cir_agmast_dis.unit,cir_agmast_dis.agcd,cir_agmast_dis.dpcd) "BILL_AGENCY_CITY",
		dbo.cir_get_drop_point_name(cir_agmast_dis.comp_code,cir_agmast_dis.unit,cir_agmast_dis.station_code,1) as "DROP_POINT_NAME"
		FROM  cir_agmast_dis 
		WHERE comp_code  = @pcompcode AND unit  = @punit and(dist_code =@pdistcode or @pdistcode is null)
		 AND ((UPPER(ag_name)  like UPPER(CAST(@pextra1 AS VARCHAR) + '%')) OR	(@pextra1  is null) OR	(@pextra1  = ''))
		 /*AND ISNULL(freeze_flag, 'N')  = 'N'*/
		union
		SELECT cir_agmast_dis.*,dbo.cir_get_city(cir_agmast_dis.comp_code,cir_agmast_dis.city_code) "CITY_NAME",
		dbo.cir_get_agency(cir_agmast_dis.comp_code,cir_agmast_dis.unit,cir_agmast_dis.agcd,cir_agmast_dis.dpcd) "BILL_AGENCY",
		dbo.cir_get_agency_city(cir_agmast_dis.comp_code,cir_agmast_dis.unit,cir_agmast_dis.agcd,cir_agmast_dis.dpcd) "BILL_AGENCY_CITY",
		dbo.cir_get_drop_point_name(cir_agmast_dis.comp_code,cir_agmast_dis.unit,cir_agmast_dis.station_code,1) as "DROP_POINT_NAME"
		FROM  cir_agmast_dis 
		WHERE comp_code  = @pcompcode AND unit  = @punit and(dist_code =@pdistcode or @pdistcode is null)
		 AND ((UPPER(agcd)  like UPPER(CAST(@pextra1 AS VARCHAR) + '%')) OR	(@pextra1  is null) OR	(@pextra1  = ''))
		 /*AND ISNULL(freeze_flag, 'N')  = 'N'*/
		ORDER BY 5
	End
	Else Begin
		SELECT cir_agmast.*,dbo.cir_get_city(cir_agmast.comp_code,cir_agmast.city_code) "CITY_NAME",
		dbo.cir_get_agency(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.agcd,cir_agmast.dpcd) "BILL_AGENCY",
		dbo.cir_get_agency_city(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.agcd,cir_agmast.dpcd) "BILL_AGENCY_CITY",
		dbo.cir_get_drop_point_name(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.station_code,1) as "DROP_POINT_NAME"
			FROM  cir_agmast 
			WHERE comp_code  = @pcompcode AND unit  = @punit and(dist_code =@pdistcode or @pdistcode is null)
			 AND ((UPPER(ag_name)  like UPPER(CAST(@pextra1 AS VARCHAR) + '%')) OR	(@pextra1  is null) OR	(@pextra1  = ''))
			 /*AND ISNULL(freeze_flag, 'N')  = 'N'*/
		union
		SELECT cir_agmast.*,dbo.cir_get_city(cir_agmast.comp_code,cir_agmast.city_code) "CITY_NAME",
		dbo.cir_get_agency(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.agcd,cir_agmast.dpcd) "BILL_AGENCY",
		dbo.cir_get_agency_city(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.agcd,cir_agmast.dpcd) "BILL_AGENCY_CITY",
		dbo.cir_get_drop_point_name(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.station_code,1) as "DROP_POINT_NAME"
			FROM  cir_agmast 
			WHERE comp_code  = @pcompcode AND unit  = @punit and(dist_code =@pdistcode or @pdistcode is null)
			 AND ((UPPER(agcd)  like UPPER(CAST(@pextra1 AS VARCHAR) + '%')) OR	(@pextra1  is null) OR	(@pextra1  = ''))
			 /*AND ISNULL(freeze_flag, 'N')  = 'N'*/			 
			ORDER BY 5
	End
END





//-------------------------------end of 6440--------------------------//


//////////////////////////////////sent by Laxman Sir 22/02/2012////////////////////////////////////////////////////////////

alter function cir_get_edtn_rate(
  @pcomp_code	as varchar(20),
  @punit_code	as varchar(20),
  @pedtn_code	as varchar(20),
  @psup_date	as varchar(20),--datetime,
  @pdateformat	as varchar(20)) returns numeric(10,4) as

Begin
	declare	@vsup_date		datetime
	declare @v_publ			varchar(10)
	declare @v_supday		varchar(10)
	declare @v_sun_rate		numeric(10,4)
	declare @v_mon_rate		numeric(10,4)
	declare @v_tue_rate		numeric(10,4)
	declare @v_wed_rate		numeric(10,4)
	declare @v_thu_rate		numeric(10,4)
	declare @v_fri_rate		numeric(10,4)
	declare @v_sat_rate		numeric(10,4)
	declare @v_edtn_rate	numeric(10,4)

	set @vsup_date=dbo.convert_user_date('/',@psup_date,@pdateformat)
	
	select distinct @v_publ=publ from cir_edtn_mast
		where comp_code=@pcomp_code and edtn=@pedtn_code

	select @v_edtn_rate=spl_day_rate from cir_special_rate_mast
		where comp_code=@pcomp_code and unit=@punit_code and
		publ=@v_publ and edtn=@pedtn_code and spl_day_date=@vsup_date
		
    If isnull(@v_edtn_rate,0)=0 Begin

	   select distinct @v_sun_rate=sun_rate,@v_mon_rate=mon_rate,@v_tue_rate=tue_rate,@v_wed_rate=wed_rate,@v_thu_rate=thu_rate,
		@v_fri_rate=fri_rate,@v_sat_rate=sat_rate from cir_rate_mast
	   where comp_code=@pcomp_code and unit=@punit_code and publ=@v_publ and edtn=@pedtn_code and
			   valid_from=(select max(valid_from) from cir_rate_mast where comp_code=@pcomp_code and
			   unit=@punit_code and publ=@v_publ and edtn=@pedtn_code and valid_from<=@vsup_date)

		
		set @v_supday=upper(substring(CONVERT(VARCHAR(20) , DATENAME(WEEKDAY, @vsup_date),20),1,3))
			
		if @v_supday = 'SUN' Begin   ---for sunday edition rate
		  set @v_edtn_rate  = @v_sun_rate
		End
		
		if @v_supday = 'MON' Begin ---for monday edition rate
			set @v_edtn_rate  = @v_mon_rate
		End
		
		if @v_supday = 'TUE' Begin ---for tueday edition rate
			set @v_edtn_rate  = @v_tue_rate;
		End
		if @v_supday = 'WED' Begin ---for wednesday edition rate
			set @v_edtn_rate  = @v_wed_rate;
		End
		if @v_supday = 'THU' Begin ---for Thursday edition rate
			set @v_edtn_rate  = @v_thu_rate;
		End
		if @v_supday = 'FRI' Begin ---for friday edition rate
			set @v_edtn_rate  = @v_fri_rate
		End    
		if @v_supday = 'SAT' Begin ---for saturday edition rate
			set @v_edtn_rate  = @v_sat_rate
		End    
    End
    
    return isnull(@v_edtn_rate,0)
END

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////update by Garima(Start)
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


                                                                     
                                                                     
                                                                     
                                             
ALTER procedure [dbo].[cir_rep_unsold_supply_cir_rep_unsold_slip]
	@pcompcode       as varchar(200),
	@punitcode       as varchar(200),
	@pbrancode       as varchar(200),
	@pdoctype        as varchar(200),
	@pdistcode       as varchar(200),
	@ptalukacode     as varchar(200),
	@pagcode         as varchar(200),
	@pagsubcode      as varchar(200),
	@pfrom_recdate   as varchar(200),
	@ptill_recdate   as varchar(200),
	@papproved_flag  as varchar(200),
	@pdateformat     as varchar(200),
	@pextra1         as varchar(200),
	@pextra2         as varchar(200)
  As
       declare @v_frdt as datetime
       declare @v_todt as datetime
  Begin
       set @v_frdt=DBO.CONVERT_USER_DATE('/',@pfrom_recdate,@pdateformat)
       set @v_todt=DBO.CONVERT_USER_DATE('/',@ptill_recdate,@pdateformat)
       
        if upper(isnull(@papproved_flag,'N'))='Y' Begin
            if @pextra2='D' Begin
               SELECT B.COMP_CODE COMP_CODE,B.UNIT_CODE UNIT_CODE,B.DOCTYPE DOCTYPE,B.PUBL PUBL,DBO.CIR_GET_NAME_CIR_PUBL(B.COMP_CODE,B.PUBL,'1','dd/mm/yyyy','','') PUBL_NAME,
                      B.EDTN EDTN,DBO.CIR_GET_NAME_CIR_EDTN(B.COMP_CODE,B.UNIT_CODE,B.EDTN,'1','dd/mm/yyyy','','') EDTN_NAME,
                      B.RECPTNO RECPTNO,B.RECPTDT RECPTDT,
                      B.AGCD AGCD,B.DPCD DPCD,A.AG_NAME AGNAME,A.AG_NAME_OTH_LANG AGNAME_OTH_LANG,DBO.CIR_GET_CITY(B.COMP_CODE,A.CITY_CODE) CITY_NAME,
                      B.COPY_RATE COPY_RATE,H.FRDT FRDT,H.TODT TODT,
                      SUM(B.APR_SHORT_RECPT) SHORT_RECPT,SUM(B.APR_LATE_RECPT) LATE_RECPT,SUM(B.APR_BNR) BNR,SUM(B.APR_UNSOLD) UNSOLD,
                      SUM(ISNULL(B.COPY_RATE,0)*(ISNULL(B.APR_SHORT_RECPT,0)+ISNULL(B.APR_LATE_RECPT,0)+ISNULL(B.APR_BNR,0)+ISNULL(B.APR_UNSOLD,0))) GROSS_AMT,
                      SUM(B.COMM_AMT) COMM_AMT,SUM(B.WASTE_AMT) WASTE_AMT,ISNULL(SUM(B.COPY_AMT),0) AMOUNT,
                      ISNULL(SUM(B.COPY_AMT),0)-ISNULL(SUM(B.WASTE_AMT),0)NET_AMT,SUM(B.APR_DAMAGE) DAMAGE 
                   from cir_agmast_dis a,cir_unsold_dtl_dis b,cir_unsold_hdr_dis h
                   where b.comp_code =a.comp_code and b.comp_code =@pcompcode and b.comp_code =h.comp_code and 
                        b.unit_code=a.unit and b.unit_code=h.unit_code and b.unit_code=@punitcode and 
                        b.doctype=@pdoctype and b.doctype=h.doctype and b.recptdt between @v_frdt and @v_todt and
                        b.recptno=h.recptno and a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd=@pagcode) or (@pagcode is null) or (@pagcode='')) and 
                        ((b.dpcd=@pagsubcode) or (@pagsubcode is null)or (@pagsubcode='')) and ((a.dist_code=@pdistcode) or (@pdistcode is null) or (@pdistcode='')) and
                        ((a.tehsil_taluka=@ptalukacode) or (@ptalukacode is null) or (@ptalukacode='')) and (a.branch_code=@pbrancode or @pbrancode is null or @pbrancode='') and
                        (isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))>0
                        group by b.comp_code,b.unit_code,b.doctype,b.publ,b.edtn,b.recptno,b.recptdt,h.frdt,h.todt,
                                 b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.city_code,b.copy_rate 
                        order by b.agcd,b.dpcd,b.recptdt,b.recptno,b.publ,b.edtn;
				End
            else Begin
               SELECT B.COMP_CODE COMP_CODE,B.UNIT_CODE UNIT_CODE,B.DOCTYPE DOCTYPE,B.PUBL PUBL,DBO.CIR_GET_NAME_CIR_PUBL(B.COMP_CODE,B.PUBL,'1','dd/mm/yyyy','','') PUBL_NAME,
                      B.EDTN EDTN,DBO.CIR_GET_NAME_CIR_EDTN(B.COMP_CODE,B.UNIT_CODE,B.EDTN,'1','dd/mm/yyyy','','') EDTN_NAME,
                      B.RECPTNO RECPTNO,B.RECPTDT RECPTDT,
                      B.AGCD AGCD,B.DPCD DPCD,A.AG_NAME AGNAME,A.AG_NAME_OTH_LANG AGNAME_OTH_LANG,DBO.CIR_GET_CITY(B.COMP_CODE,A.CITY_CODE) CITY_NAME,
                      B.COPY_RATE COPY_RATE,H.FRDT FRDT,H.TODT TODT,
                      SUM(B.APR_SHORT_RECPT) SHORT_RECPT,SUM(B.APR_LATE_RECPT) LATE_RECPT,SUM(B.APR_BNR) BNR,SUM(B.APR_UNSOLD) UNSOLD,
                      SUM(ISNULL(B.COPY_RATE,0)*(ISNULL(B.APR_SHORT_RECPT,0)+ISNULL(B.APR_LATE_RECPT,0)+ISNULL(B.APR_BNR,0)+ISNULL(B.APR_UNSOLD,0))) GROSS_AMT,
                      SUM(B.COMM_AMT) COMM_AMT,SUM(B.WASTE_AMT) WASTE_AMT,ISNULL(SUM(B.COPY_AMT),0) AMOUNT,
                      ISNULL(SUM(B.COPY_AMT),0)-ISNULL(SUM(B.WASTE_AMT),0)NET_AMT,SUM(B.DAMAGE) DAMAGE 
                   from cir_agmast a,cir_unsold_dtl b,cir_unsold_hdr h
                   where b.comp_code =a.comp_code and b.comp_code =@pcompcode and b.comp_code =h.comp_code and 
                        b.unit_code=a.unit and b.unit_code=h.unit_code and b.unit_code=@punitcode and 
                        b.doctype=@pdoctype and b.doctype=h.doctype and b.recptdt between @v_frdt and @v_todt and
                        b.recptno=h.recptno and a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd=@pagcode) or (@pagcode is null) or (@pagcode ='')) and 
                        ((b.dpcd=@pagsubcode) or (@pagsubcode is null) or (@pagsubcode='')) and ((a.dist_code=@pdistcode) or (@pdistcode is null) or (@pdistcode='')) and
                        ((a.tehsil_taluka=@ptalukacode) or (@ptalukacode is null)) and (a.branch_code=@pbrancode or @pbrancode is null or @pbrancode='') and
                        (isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))>0
                        group by b.comp_code,b.unit_code,b.doctype,b.publ,b.edtn,b.recptno,b.recptdt,h.frdt,h.todt,
                                 b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.city_code,b.copy_rate 
                        order by b.agcd,b.dpcd,b.recptdt,b.recptno,b.publ,b.edtn;            
				End
			End
        else Begin
            if @pextra2='D' Begin
               SELECT B.COMP_CODE COMP_CODE,B.UNIT_CODE UNIT_CODE,B.DOCTYPE DOCTYPE,B.PUBL PUBL,DBO.CIR_GET_NAME_CIR_PUBL(B.COMP_CODE,B.PUBL,'1','dd/mm/yyyy','','') PUBL_NAME,
                      B.EDTN EDTN,DBO.CIR_GET_NAME_CIR_EDTN(B.COMP_CODE,B.UNIT_CODE,B.EDTN,'1','dd/mm/yyyy','','') EDTN_NAME,B.RECPTNO RECPTNO,B.RECPTDT RECPTDT,
                      B.AGCD AGCD,B.DPCD DPCD,A.AG_NAME AGNAME,A.AG_NAME_OTH_LANG AGNAME_OTH_LANG,DBO.CIR_GET_CITY(B.COMP_CODE,A.CITY_CODE) CITY_NAME,
                      B.COPY_RATE COPY_RATE,H.FRDT FRDT,H.TODT TODT,
                      SUM(B.SHORT_RECPT) SHORT_RECPT,SUM(B.LATE_RECPT) LATE_RECPT,SUM(B.BNR) BNR,SUM(B.UNSOLD) UNSOLD,
                      SUM(ISNULL(B.COPY_RATE,0)*(ISNULL(B.SHORT_RECPT,0)+ISNULL(B.LATE_RECPT,0)+ISNULL(B.BNR,0)+ISNULL(B.UNSOLD,0))) GROSS_AMT,SUM(B.COMM_AMT) COMM_AMT,
                      SUM(B.WASTE_AMT) WASTE_AMT,ISNULL(SUM(B.COPY_AMT),0) AMOUNT,
                      ISNULL(SUM(B.COPY_AMT),0)-ISNULL(SUM(B.WASTE_AMT),0) NET_AMT,SUM(B.APR_DAMAGE) DAMAGE 
                   from cir_agmast_dis a,cir_unsold_dtl_dis b,cir_unsold_hdr_dis h
                   where b.comp_code =a.comp_code and b.comp_code =@pcompcode and b.comp_code =h.comp_code and 
                        b.unit_code=a.unit and b.unit_code=h.unit_code and b.unit_code=@punitcode and 
                        b.doctype=@pdoctype and b.doctype=h.doctype and b.recptdt between @v_frdt and @v_todt and
                        b.recptno=h.recptno and a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd=@pagcode) or (@pagcode is null)) and 
                        ((b.dpcd=@pagsubcode) or (@pagsubcode is null) or (@pagsubcode='')) and ((a.dist_code=@pdistcode) or (@pdistcode is null)) and
                        ((a.tehsil_taluka=@ptalukacode) or (@ptalukacode is null) or (@ptalukacode='')) and (a.branch_code=@pbrancode or @pbrancode is null or @pbrancode='') and
                        (isnull(short_recpt,0)+isnull(late_recpt,0)+isnull(bnr,0)+isnull(unsold,0))>0
                        group by b.comp_code,b.unit_code,b.doctype,b.publ,b.edtn,b.recptno,b.recptdt,h.frdt,h.todt,
                                 b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.city_code,b.copy_rate 
                        order by b.agcd,b.dpcd,b.recptdt,b.recptno,b.publ,b.edtn
				End
            else Begin
               SELECT B.COMP_CODE COMP_CODE,B.UNIT_CODE UNIT_CODE,B.DOCTYPE DOCTYPE,B.PUBL PUBL,DBO.CIR_GET_NAME_CIR_PUBL(B.COMP_CODE,B.PUBL,'1','dd/mm/yyyy','','') PUBL_NAME,
                      B.EDTN EDTN,DBO.CIR_GET_NAME_CIR_EDTN(B.COMP_CODE,B.UNIT_CODE,B.EDTN,'1','dd/mm/yyyy','','') EDTN_NAME,B.RECPTNO RECPTNO,B.RECPTDT RECPTDT,
                      B.AGCD AGCD,B.DPCD DPCD,A.AG_NAME AGNAME,A.AG_NAME_OTH_LANG AGNAME_OTH_LANG,DBO.CIR_GET_CITY(B.COMP_CODE,A.CITY_CODE) CITY_NAME,
                      B.COPY_RATE COPY_RATE,H.FRDT FRDT,H.TODT TODT,
                      SUM(B.SHORT_RECPT) SHORT_RECPT,SUM(B.LATE_RECPT) LATE_RECPT,SUM(B.BNR) BNR,SUM(B.UNSOLD) UNSOLD,
                      SUM(ISNULL(B.COPY_RATE,0)*(ISNULL(B.SHORT_RECPT,0)+ISNULL(B.LATE_RECPT,0)+ISNULL(B.BNR,0)+ISNULL(B.UNSOLD,0))) GROSS_AMT,SUM(B.COMM_AMT) COMM_AMT,
                      SUM(B.WASTE_AMT) WASTE_AMT,ISNULL(SUM(B.COPY_AMT),0) AMOUNT,
                      ISNULL(SUM(B.COPY_AMT),0)-ISNULL(SUM(B.WASTE_AMT),0) NET_AMT,SUM(B.DAMAGE) DAMAGE  
                   from cir_agmast a,cir_unsold_dtl b,cir_unsold_hdr h
                   where b.comp_code =a.comp_code and b.comp_code =@pcompcode and b.comp_code =h.comp_code and 
                        b.unit_code=a.unit and b.unit_code=h.unit_code and b.unit_code=@punitcode and 
                        b.doctype=@pdoctype and b.doctype=h.doctype and b.recptdt between @v_frdt and @v_todt and
                        b.recptno=h.recptno and a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd=@pagcode) or (@pagcode is null) or (@pagcode='')) and 
                        ((b.dpcd=@pagsubcode) or (@pagsubcode is null) or (@pagsubcode='')) and ((a.dist_code=@pdistcode) or (@pdistcode is null) or (@pdistcode='')) and
                        ((a.tehsil_taluka=@ptalukacode) or (@ptalukacode is null) or (@ptalukacode='')) and (a.branch_code=@pbrancode or @pbrancode is null or @pbrancode='') and
                        (isnull(short_recpt,0)+isnull(late_recpt,0)+isnull(bnr,0)+isnull(unsold,0))>0
                        group by b.comp_code,b.unit_code,b.doctype,b.publ,b.edtn,b.recptno,b.recptdt,h.frdt,h.todt,
                                 b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.city_code,b.copy_rate 
                        order by b.agcd,b.dpcd,b.recptdt,b.recptno,b.publ,b.edtn;            
            End
		End
  End

///////////////////////////////////////////////////////////

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROCEDURE [dbo].[cir_rep_unsold_supply_cir_rep_unsold_detail]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@pdoc_type                                VARCHAR(20) ,
	@ppubl                                    VARCHAR(20) ,
	@pmainedtn                                VARCHAR(20) ,
	@pedtn                                    VARCHAR(20) ,
	@pcity                                    VARCHAR(20) ,
	@pagcode                                  VARCHAR(20) ,
	@pdepocode                                VARCHAR(20) ,
	@pfrom_recdate                            VARCHAR(20) ,
	@ptill_recdate                            VARCHAR(20) ,
	@papproved_flag                           VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000)
AS 
	DECLARE @v_frdt			DATETIME 
	DECLARE @v_todt         DATETIME 
	SET @v_frdt  = dbo.convert_user_date('/', @pfrom_recdate,@pdateformat)
	SET @v_todt  = dbo.convert_user_date('/', @ptill_recdate,@pdateformat)

	print(@v_frdt)
	print(@v_todt)

	select u.comp_code comp_code,u.unit_code unit_code,u.doctype doctype,u.recptno recptno,u.recptdt recptdt,
        u.agcd agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang agname_oth_lang,u.city_name city_name,
        u.supdate supdate,u.supply_copy supply_copy,
        u.short_recpt short_recpt,u.late_recpt late_recpt,u.bnr bnr,u.unsold unsold,
        u.copy_rate copy_rate,u.comm_rate comm_rate,u.waste_alw waste_alw,u.waste_rate waste_rate,u.copy_amt copy_amt,
        u.comm_amt comm_amt,u.waste_amt waste_amt,u.total_amt total_amt,u.damage damage from
   (select b.comp_code comp_code,b.unit_code unit_code,b.doctype doctype,b.recptno recptno,b.recptdt recptdt,
        b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,dbo.cir_get_city(b.comp_code,a.city_code) city_name,
        b.supdate supdate,sum(b.supply_copy) supply_copy,
        sum(b.apr_short_recpt) short_recpt,sum(b.apr_late_recpt) late_recpt,sum(b.apr_bnr) bnr,sum(b.apr_unsold) unsold,
        b.copy_rate copy_rate,b.comm_rate comm_rate,b.waste_alw waste_alw,b.waste_rate waste_rate,
        sum(isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0))*b.copy_rate copy_amt,
        sum(b.comm_amt) comm_amt,sum(b.waste_amt) waste_amt,sum(isnull(b.copy_amt,0)) total_amt ,sum(isnull(b.apr_damage,0)) damage 
   from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e
   where b.comp_code = a.comp_code and b.comp_code = e.comp_code and b.comp_code =@pcomp_code and 
         b.unit_code=a.unit and b.unit_code=e.unit_code and b.unit_code=@punit_code and 
         b.doctype=@pdoc_type and b.app_dt between @v_frdt and @v_todt and 
         a.agcd=b.agcd and a.dpcd=b.dpcd and (b.agcd=@pagcode or @pagcode is null or @pagcode='') and (b.dpcd=@pdepocode or @pdepocode is null or @pdepocode='') and 
         b.publ=e.publ and (b.publ=@ppubl or @ppubl is null or @ppubl='') and b.edtn=e.edtn and (b.edtn=@pedtn or @pedtn is null or @pedtn='') and
         (a.city_code=@pcity or @pcity is null or @pcity='') and
         (isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0))>0 and 
         (e.main_edtn=@pmainedtn or @pmainedtn is null or @pmainedtn='') and upper(isnull(@papproved_flag,'N'))='Y'
         group by b.comp_code,b.unit_code,b.doctype,b.recptno,b.recptdt,b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,
         a.city_code,b.supdate,b.copy_rate,b.comm_rate,b.waste_alw,b.waste_rate
   union
   select b.comp_code comp_code,b.unit_code unit_code,b.doctype doctype,b.recptno recptno,b.recptdt recptdt,
        b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,dbo.cir_get_city(b.comp_code,a.city_code) city_name,
        b.supdate supdate,sum(b.supply_copy) supply_copy,
        sum(b.short_recpt) short_recpt,sum(b.late_recpt) late_recpt,sum(b.bnr) bnr,sum(b.unsold) unsold,
        b.copy_rate copy_rate,b.comm_rate comm_rate,b.waste_alw waste_alw,b.waste_rate waste_rate,
        sum(isnull(b.short_recpt,0)+isnull(b.late_recpt,0)+isnull(b.bnr,0)+isnull(b.unsold,0))*b.copy_rate copy_amt,
        sum(b.comm_amt) comm_amt,sum(b.waste_amt) waste_amt,sum(isnull(b.copy_amt,0)) total_amt,sum(isnull(b.damage,0)) damage  
   from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e
   where b.comp_code = a.comp_code and b.comp_code = e.comp_code and b.comp_code =@pcomp_code and 
         b.unit_code=a.unit and b.unit_code=e.unit_code and b.unit_code=@punit_code and 
         b.doctype=@pdoc_type and b.recptdt between @v_frdt and @v_todt and 
         a.agcd=b.agcd and a.dpcd=b.dpcd and (b.agcd=@pagcode or @pagcode is null or @pagcode='') and (b.dpcd=@pdepocode or @pdepocode is null or @pdepocode='') and 
         b.publ=e.publ and (b.publ=@ppubl or @ppubl is null or @ppubl='') and b.edtn=e.edtn and (b.edtn=@pedtn or @pedtn is null or @pedtn='') and
         (a.city_code=@pcity or @pcity is null or @pcity='') and
         (isnull(short_recpt,0)+isnull(late_recpt,0)+isnull(bnr,0)+isnull(unsold,0))>0 and 
         (e.main_edtn=@pmainedtn or @pmainedtn is null or @pmainedtn='') and upper(isnull(@papproved_flag,'N'))='N'
         group by b.comp_code,b.unit_code,b.doctype,b.recptno,b.recptdt,b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,
         a.city_code,b.supdate,b.copy_rate,b.comm_rate,b.waste_alw,b.waste_rate) u 
         order by u.comp_code,u.unit_code,u.recptdt,u.recptno,u.agname




/////////////////////////////////////////////////////

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROCEDURE [dbo].[cir_rep_unsold_supply_cir_rep_unsold_summary]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@pdoc_type                                VARCHAR(20) ,
	@ppubl                                    VARCHAR(20) ,
	@pmainedtn                                VARCHAR(20) ,
	@pedtn                                    VARCHAR(20) ,
	@pcity                                    VARCHAR(20) ,
	@pagcode                                  VARCHAR(20) ,
	@pdepocode                                VARCHAR(20) ,
	@pfrom_recdate                            DATETIME ,
	@ptill_recdate                            DATETIME ,
	@papproved_flag                           VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(200) ,
	@pextra2                                  VARCHAR(200) 
AS 
	
		
		DECLARE @v_frdt                                   DATETIME 
		DECLARE @v_todt                                   DATETIME 
		SELECT @v_frdt  =  @pfrom_recdate
		SELECT @v_todt  = @ptill_recdate
		IF UPPER(ISNULL(@papproved_flag, 'N'))= 'Y' 
		BEGIN 
			
			
		           	 SELECT
					 b.comp_code comp_code,
					 b.unit_code unit_code,
					 b.doctype doctype,
					 b.publ publ,
					 b.edtn edtn,
					 b.recptno recptno,
					 b.recptdt recptdt,
					 b.agcd agcd,
					 b.dpcd dpcd,
					 a.ag_name agname,
					 a.ag_name_oth_lang agname_oth_lang,
					 DBO.cir_get_city(a.comp_code, a.city_code) city_name,
					 SUM(CONVERT(FLOAT, b.apr_short_recpt)) short_recpt,
					 SUM(CONVERT(FLOAT, b.apr_late_recpt)) late_recpt,
					 SUM(CONVERT(FLOAT, b.apr_bnr)) bnr,
					 SUM(CONVERT(FLOAT, b.apr_unsold)) unsold,
					 SUM(CONVERT(FLOAT, b.copy_amt)) copy_amt,
					 SUM(CONVERT(FLOAT, b.comm_amt)) comm_amt,
					 SUM(CONVERT(FLOAT, b.waste_amt)) waste_amt,
					 SUM(CONVERT(FLOAT, ISNULL(b.copy_amt, 0) - ISNULL(b.comm_amt, 0) - ISNULL(b.waste_amt, 0))) total_amt,
                     SUM(CONVERT(FLOAT, b.apr_damage)) damage
			FROM  cir_agmast a,
				 cir_unsold_dtl b 
			WHERE	 b.comp_code  = a.comp_code
			 AND	b.comp_code  = @pcomp_code
			 AND	b.unit_code  = a.unit
			 AND	b.unit_code  = @punit_code
			 AND	b.doctype  = @pdoc_type
			 AND	b.recptdt  between @v_frdt  and  @v_todt
			 AND	((b.publ  = @ppubl)
			 OR	(@ppubl  is null))
			 AND	((b.edtn  = @pedtn)
			 OR	(@pedtn  is null))
			 AND	a.agcd  = b.agcd
			 AND	a.dpcd  = b.dpcd
			 AND	((b.agcd  = @pagcode)
			 OR	(@pagcode  is null))
			 AND	((b.dpcd  = @pdepocode)
			 OR	(@pdepocode  is null))
			 AND	((a.city_code  = @pcity)
			 OR	(@pcity  is null))
			 AND	(ISNULL(apr_short_recpt, 0) + ISNULL(apr_late_recpt, 0) + ISNULL(apr_bnr, 0) + ISNULL(apr_unsold, 0))  > 0
			 AND	b.edtn  in
				(
			 	SELECT DISTINCT edtn
				FROM  cir_edtn_mast 
				WHERE	 comp_code  = @pcomp_code
				 AND	(edtn  = @pedtn
				 OR	@pedtn  is null)
				 AND	(main_edtn  = @pmainedtn
				 OR	@pmainedtn  is null)
				)
			GROUP BY b.comp_code,
				 b.unit_code,
				 b.doctype,
				 b.publ,
				 b.edtn,
				 b.recptno,
				 b.recptdt,
				 b.agcd,
				 b.dpcd,
				 a.ag_name,
				 a.ag_name_oth_lang,
				  DBO.cir_get_city(a.comp_code, a.city_code) 
			ORDER BY b.recptdt,
				 b.recptno 
			
		END
		ELSE
		BEGIN 
			print('1')
			
			         SELECT
					 b.comp_code comp_code,
					 b.unit_code unit_code,
					 b.doctype doctype,
					 b.publ publ,
					 b.edtn edtn,
					 b.recptno recptno,
					 b.recptdt recptdt,
					 b.agcd agcd,
					 b.dpcd dpcd,
					 a.ag_name agname,
					 a.ag_name_oth_lang agname_oth_lang,
					 DBO.cir_get_city(a.comp_code, a.city_code) city_name,
					 SUM(CONVERT(FLOAT, b.short_recpt)) short_recpt,
					 SUM(CONVERT(FLOAT, b.late_recpt)) late_recpt,
					 SUM(CONVERT(FLOAT, b.bnr)) bnr,
					 SUM(CONVERT(FLOAT, b.unsold)) unsold,
					 SUM(CONVERT(FLOAT, b.copy_amt)) copy_amt,
					 SUM(CONVERT(FLOAT, b.comm_amt)) comm_amt,
					 SUM(CONVERT(FLOAT, b.waste_amt)) waste_amt,
					 SUM(CONVERT(FLOAT, ISNULL(b.copy_amt, 0) - ISNULL(b.comm_amt, 0) - ISNULL(b.waste_amt, 0))) total_amt,
                     SUM(CONVERT(FLOAT, b.damage)) damage
			FROM  cir_agmast a,
				 cir_unsold_dtl b 
			WHERE	 b.comp_code  = a.comp_code
			 AND	b.comp_code  = @pcomp_code
			 AND	b.unit_code  = a.unit
			 AND	b.unit_code  = @punit_code
			 AND	b.doctype  = @pdoc_type
			 AND	b.recptdt  between @v_frdt  and  @v_todt
			 AND	((b.publ  = @ppubl)
			 OR	(@ppubl  is null))
			 AND	((b.edtn  = @pedtn)
			 OR	(@pedtn  is null))
			 AND	a.agcd  = b.agcd
			 AND	a.dpcd  = b.dpcd
			 AND	((b.agcd  = @pagcode)
			 OR	(@pagcode  is null))
			 AND	((b.dpcd  = @pdepocode)
			 OR	(@pdepocode  is null))
			 AND	(ISNULL(short_recpt, 0) + ISNULL(late_recpt, 0) + ISNULL(bnr, 0) + ISNULL(unsold, 0))  > 0
			 AND	b.edtn  in
				(
			 	SELECT DISTINCT edtn
				FROM  cir_edtn_mast 
				WHERE	 comp_code  = @pcomp_code
				 AND	(edtn  = @pedtn
				 OR	@pedtn  is null)
				 AND	(main_edtn  = @pmainedtn
				 OR	@pmainedtn  is null)
				)
			GROUP BY b.comp_code,
				 b.unit_code,
				 b.doctype,
				 b.publ,
				 b.edtn,
				 b.recptno,
				 b.recptdt,
				 b.agcd,
				 b.dpcd,
				 a.ag_name,
				 a.ag_name_oth_lang,
				 DBO.cir_get_city(a.comp_code, a.city_code) 
			     ORDER BY b.recptdt,
				 b.recptno
				-- b.supdate 
			
		END
   
////////////////////////////////////////////end by Garima
/////////////////////////////start by Garima
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROCEDURE [dbo].[cir_rep_supply_cir_taluka_supply_variance_p]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@ppublication                             VARCHAR(20) ,
	@pmainedtn                                VARCHAR(20) ,
	@pedtn                                    VARCHAR(20) ,
	@ptaluka                                  VARCHAR(20) ,
	@pfirstdate                               VARCHAR(20) ,
	@pseconddate                              VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) ,
    @pextra3             as varchar(200),--agency type
	@pextra4             as varchar(200),-- agency class
	@pextra5             as varchar(200),--final.unfinal
	@pextra6             as varchar(200),
	@pextra7             as varchar(200),
	@pextra8             as varchar(200),
	@pextra9             as varchar(200),
	@pextra10            as varchar(200)
AS 
	
		
		DECLARE @vfirstdate                               DATETIME 
		DECLARE @vseconddate                              DATETIME 
	--	SELECT @vfirstdate  =  @pfirstdate
	--	SELECT @vseconddate  =  @pseconddate

	SET @vfirstdate  =  dbo.convert_user_date('/',@pfirstdate,@pdateformat)
    SET @vseconddate  = dbo.convert_user_date('/',@pseconddate,@pdateformat)

print(@vfirstdate)
print(@vseconddate)
		
	
		SELECT
				 m.comp_code "COMP CODE",
				 m.agcd "AGENCY CODE",
				 m.dpcd "AGENCY SUB CODE",
				 m.ag_name "AGENCY NAME",
				 m.ag_name_oth_lang "AGENCY OTHER LANG",
				 DBO.cir_get_city(m.comp_code, m.city_code) "CITY NAME",
				 m.tehsil_taluka "TALUKA CODE",
				 ISNULL(m.talu_name, '(blank)') "TALUKA NAME",
				 m.talu_oname "TALUKA NAME OTHER LANG",
				 SUM(CONVERT(FLOAT, m.first_sup)) "FIRST SUPPLY",
				 SUM(CONVERT(FLOAT, m.second_sup)) "SECOND SUPPLY",
				 
				CASE sign(ISNULL(SUM(CONVERT(FLOAT, m.second_sup)), 0) - ISNULL(SUM(CONVERT(FLOAT, m.first_sup)), 0)) 
					WHEN - 1 THEN 0 
					ELSE (ISNULL(SUM(CONVERT(FLOAT, m.second_sup)), 0) - ISNULL(SUM(CONVERT(FLOAT, m.first_sup)), 0)) 
				END "INCREASE SUPPLY",
				 
				CASE sign(ISNULL(SUM(CONVERT(FLOAT, m.second_sup)), 0) - ISNULL(SUM(CONVERT(FLOAT, m.first_sup)), 0)) 
					WHEN 1 THEN 0 
					ELSE (ISNULL(SUM(CONVERT(FLOAT, m.second_sup)), 0) - ISNULL(SUM(CONVERT(FLOAT, m.first_sup)), 0)) 
				END "DECREASE SUPPLY",
				 
				CASE ISNULL(SUM(CONVERT(FLOAT, m.first_sup)), 0) 
					WHEN 0 THEN 100 
					ELSE ROUND(((ISNULL(SUM(CONVERT(FLOAT, m.second_sup)), 0) - ISNULL(SUM(CONVERT(FLOAT, m.first_sup)), 0)) * 100) / CONVERT(FLOAT, 
							CASE sign(SUM(CONVERT(FLOAT, m.second_sup)) - SUM(CONVERT(FLOAT, m.first_sup))) 
								WHEN - 1 THEN SUM(CONVERT(FLOAT, m.first_sup)) 
								ELSE SUM(CONVERT(FLOAT, m.second_sup)) 
							END), 2) 
				END "PERCENT_VARIANCE"
		FROM (	SELECT DISTINCT
					 a.comp_code comp_code,
					 a.agcd,
					 a.dpcd,
					 c.ag_name,
					 c.ag_name_oth_lang,
					 c.city_code,
					 c.tehsil_taluka,
					 b.talu_name,
					 b.talu_oname,
					 (			SELECT ISNULL(SUM(CONVERT(FLOAT, sup_copy)), 0)
					FROM  cir_dbksup 
					WHERE	 comp_code  = @pcomp_code
					 AND	unit_code  = @punit_code
					 AND	publ  = @ppublication
					 AND	(edtn  = @pedtn
					 OR	@pedtn  is null  OR	@pedtn = '')
					 AND	supdate  = @vfirstdate
					 AND	cir_dbksup.agcd  = a.agcd
					 AND	cir_dbksup.dpcd  = a.dpcd
					 AND	cir_dbksup.edtn  in
						(
		 				SELECT DISTINCT edtn
						FROM  cir_edtn_mast 
						WHERE	 comp_code  = @pcomp_code
						 AND	(edtn  = @pedtn
						 OR	@pedtn  is null OR	@pedtn = '')
						 AND	(main_edtn  = @pmainedtn
						 OR	@pmainedtn  is null OR	@pmainedtn = '')
						)
		) first_sup,
					 (			SELECT ISNULL(SUM(CONVERT(FLOAT, sup_copy)), 0)
					FROM  cir_dbksup 
					WHERE	 comp_code  = @pcomp_code
					 AND	unit_code  = @punit_code
					 AND	publ  = @ppublication
					 AND	(edtn  = @pedtn
					 OR	@pedtn  is null OR	@pedtn = '')
					 AND	supdate  = @vseconddate
					 AND	cir_dbksup.agcd  = a.agcd
					 AND	cir_dbksup.dpcd  = a.dpcd
					 AND	cir_dbksup.edtn  in
						(
		 				SELECT DISTINCT edtn
						FROM  cir_edtn_mast 
						WHERE	 comp_code  = @pcomp_code
						 AND	(edtn  = @pedtn
						 OR	@pedtn  is null OR	@pedtn = '')
						 AND	(main_edtn  = @pmainedtn
						 OR	@pmainedtn  is null OR	@pmainedtn = '')
						)
		) second_sup
			FROM cir_dbksup a,  cir_taluka_mast b  , cir_agmast c 
				 
			WHERE	 a.comp_code  = @pcomp_code
			 AND	a.comp_code  = c.comp_code
             and b.comp_code    =    c.comp_code
			 AND	a.unit_code  = @punit_code
			 AND	a.unit_code  = c.unit
			 AND	(a.supdate  = @vfirstdate
			 OR	a.supdate  = @vseconddate)
			 AND	a.agcd  = c.agcd
			 AND	a.dpcd  = c.dpcd
			 AND	(c.tehsil_taluka  = @ptaluka
			 OR	@ptaluka  is null OR	@ptaluka = '')
             and c.tehsil_taluka=b.talu_code
		) m
		WHERE	 ISNULL(second_sup, 0) - ISNULL(first_sup, 0)  <> 0
		GROUP BY m.comp_code,
			 m.agcd,
			 m.dpcd,
			 m.ag_name,
			 m.ag_name_oth_lang,
			 m.city_code,
			 m.tehsil_taluka,
			 m.talu_name,
			  m.talu_oname 
		ORDER BY m.comp_code,
			 m.tehsil_taluka,
			 m.ag_name 
		
		

		
		SELECT
				 r.comp_code "COMP CODE",
				 r.tehsil_taluka "TALUKA CODE",
				 ISNULL(r.talu_name, '(blank)') "TALUKA NAME",
				 r.talu_oname "TALUKA NAME OTHER LANG",
				 SUM(CONVERT(FLOAT, r.first_sup)) "FIRST SUPPLY",
				 SUM(CONVERT(FLOAT, r.second_sup)) "SECOND SUPPLY",
				 
				CASE sign(ISNULL(SUM(CONVERT(FLOAT, r.second_sup)), 0) - ISNULL(SUM(CONVERT(FLOAT, r.first_sup)), 0)) 
					WHEN - 1 THEN 0 
					ELSE (ISNULL(SUM(CONVERT(FLOAT, r.second_sup)), 0) - ISNULL(SUM(CONVERT(FLOAT, r.first_sup)), 0)) 
				END "INCREASE SUPPLY",
				 
				CASE sign(ISNULL(SUM(CONVERT(FLOAT, r.second_sup)), 0) - ISNULL(SUM(CONVERT(FLOAT, r.first_sup)), 0)) 
					WHEN 1 THEN 0 
					ELSE (ISNULL(SUM(CONVERT(FLOAT, r.second_sup)), 0) - ISNULL(SUM(CONVERT(FLOAT, r.first_sup)), 0)) 
				END "DECREASE SUPPLY",
				 
				CASE ISNULL(SUM(CONVERT(FLOAT, r.first_sup)), 0) 
					WHEN 0 THEN 100 
					ELSE ROUND(((ISNULL(SUM(CONVERT(FLOAT, r.second_sup)), 0) - ISNULL(SUM(CONVERT(FLOAT, r.first_sup)), 0)) * 100) / CONVERT(FLOAT, 
							CASE sign(SUM(CONVERT(FLOAT, r.second_sup)) - SUM(CONVERT(FLOAT, r.first_sup))) 
								WHEN - 1 THEN SUM(CONVERT(FLOAT, r.first_sup)) 
								ELSE SUM(CONVERT(FLOAT, r.second_sup)) 
							END), 2) 
				END "PERCENT_VARIANCE"
		FROM (	SELECT DISTINCT
					 a.comp_code comp_code,
					 a.agcd,
					 a.dpcd,
					 c.ag_name,
					 c.ag_name_oth_lang,
					 c.city_code,
					 c.tehsil_taluka,
					 b.talu_name,
					 b.talu_oname,
					 (			SELECT ISNULL(SUM(CONVERT(FLOAT, sup_copy)), 0)
					FROM  cir_dbksup 
					WHERE	 comp_code  = @pcomp_code
					 AND	unit_code  = @punit_code
					 AND	publ  = @ppublication
					 AND	(edtn  = @pedtn
					 OR	@pedtn  is null OR	@pedtn  = '')
					 AND	supdate  = @vfirstdate
					 AND	cir_dbksup.agcd  = a.agcd
					 AND	cir_dbksup.dpcd  = a.dpcd
					 AND	cir_dbksup.edtn  in
						(
		 				SELECT DISTINCT edtn
						FROM  cir_edtn_mast 
						WHERE	 comp_code  = @pcomp_code
						 AND	(edtn  = @pedtn
						 OR	@pedtn  is null OR	@pedtn = '')
						 AND	(main_edtn  = @pmainedtn
						 OR	@pmainedtn  is null OR	@pmainedtn = '')
						)
		) first_sup,
					 (			SELECT ISNULL(SUM(CONVERT(FLOAT, sup_copy)), 0)
					FROM  cir_dbksup 
					WHERE	 comp_code  = @pcomp_code
					 AND	unit_code  = @punit_code
					 AND	publ  = @ppublication
					 AND	(edtn  = @pedtn
					 OR	@pedtn  is null OR	@pedtn = '')
					 AND	supdate  = @vseconddate
					 AND	cir_dbksup.agcd  = a.agcd
					 AND	cir_dbksup.dpcd  = a.dpcd
					 AND	cir_dbksup.edtn  in
						(
		 				SELECT DISTINCT edtn
						FROM  cir_edtn_mast 
						WHERE	 comp_code  = @pcomp_code
						 AND	(edtn  = @pedtn
						 OR	@pedtn  is null OR	@pedtn = '')
						 AND	(main_edtn  = @pmainedtn
						 OR	@pmainedtn  is null OR	@pmainedtn = '')
						)
		) second_sup
			FROM   cir_dbksup a, cir_taluka_mast b ,   cir_agmast c   
				
			
			WHERE	 a.comp_code  = @pcomp_code
			 AND	a.comp_code  = c.comp_code
             AND	 b.comp_code  = c.comp_code
			 AND	a.unit_code  = @punit_code
			 AND	a.unit_code  = c.unit
			 AND	(a.supdate  = @vfirstdate
			 OR	a.supdate  = @vseconddate)
			 AND	a.agcd  = c.agcd
			 AND	a.dpcd  = c.dpcd
			 AND	(c.tehsil_taluka  = @ptaluka
			 OR	@ptaluka  is null OR	@ptaluka = '')
              AND	c.tehsil_taluka  = b.talu_code 
		) r
		WHERE	 ISNULL(second_sup, 0) - ISNULL(first_sup, 0)  <> 0
		GROUP BY r.comp_code,
			 r.tehsil_taluka,
			 r.talu_name,
			  r.talu_oname 
		ORDER BY r.comp_code,
			 r.tehsil_taluka 
		
		
		
		
		SELECT
				 q.comp_code "COMP CODE",
				 SUM(CONVERT(FLOAT, q.first_sup)) "FIRST SUPPLY",
				 SUM(CONVERT(FLOAT, q.second_sup)) "SECOND SUPPLY",
				 
				CASE sign(ISNULL(SUM(CONVERT(FLOAT, q.second_sup)), 0) - ISNULL(SUM(CONVERT(FLOAT, q.first_sup)), 0)) 
					WHEN - 1 THEN 0 
					ELSE (ISNULL(SUM(CONVERT(FLOAT, q.second_sup)), 0) - ISNULL(SUM(CONVERT(FLOAT, q.first_sup)), 0)) 
				END "INCREASE SUPPLY",
				 
				CASE sign(ISNULL(SUM(CONVERT(FLOAT, q.second_sup)), 0) - ISNULL(SUM(CONVERT(FLOAT, q.first_sup)), 0)) 
					WHEN 1 THEN 0 
					ELSE (ISNULL(SUM(CONVERT(FLOAT, q.second_sup)), 0) - ISNULL(SUM(CONVERT(FLOAT, q.first_sup)), 0)) 
				END "DECREASE SUPPLY",
				 
				CASE ISNULL(SUM(CONVERT(FLOAT, q.first_sup)), 0) 
					WHEN 0 THEN 100 
					ELSE ROUND(((ISNULL(SUM(CONVERT(FLOAT, q.second_sup)), 0) - ISNULL(SUM(CONVERT(FLOAT, q.first_sup)), 0)) * 100) / CONVERT(FLOAT, 
							CASE sign(SUM(CONVERT(FLOAT, q.second_sup)) - SUM(CONVERT(FLOAT, q.first_sup))) 
								WHEN - 1 THEN SUM(CONVERT(FLOAT, q.first_sup)) 
								ELSE SUM(CONVERT(FLOAT, q.second_sup)) 
							END), 2) 
				END "PERCENT_VARIANCE"
		FROM (	SELECT DISTINCT
					 a.comp_code comp_code,
					 a.agcd,
					 a.dpcd,
					 c.ag_name,
					 c.ag_name_oth_lang,
					 c.city_code,
					 c.tehsil_taluka,
					 b.talu_name,
					 b.talu_oname,
					 (			SELECT ISNULL(SUM(CONVERT(FLOAT, sup_copy)), 0)
					FROM  cir_dbksup 
					WHERE	 comp_code  = @pcomp_code
					 AND	unit_code  = @punit_code
					 AND	publ  = @ppublication
					 AND	(edtn  = @pedtn
					 OR	@pedtn  is null OR	@pedtn = '')
					 AND	supdate  = @vfirstdate
					 AND	cir_dbksup.agcd  = a.agcd
					 AND	cir_dbksup.dpcd  = a.dpcd
					 AND	cir_dbksup.edtn  in
						(
		 				SELECT DISTINCT edtn
						FROM  cir_edtn_mast 
						WHERE	 comp_code  = @pcomp_code
						 AND	(edtn  = @pedtn
						 OR	@pedtn  is null OR	@pedtn = '')
						 AND	(main_edtn  = @pmainedtn
						 OR	@pmainedtn  is null  OR	@pmainedtn = '')
						)
		) first_sup,
					 (			SELECT ISNULL(SUM(CONVERT(FLOAT, sup_copy)), 0)
					FROM  cir_dbksup 
					WHERE	 comp_code  = @pcomp_code
					 AND	unit_code  = @punit_code
					 AND	publ  = @ppublication
					 AND	(edtn  = @pedtn
					 OR	@pedtn  is null OR	@pedtn = '')
					 AND	supdate  = @vseconddate
					 AND	cir_dbksup.agcd  = a.agcd
					 AND	cir_dbksup.dpcd  = a.dpcd
					 AND	cir_dbksup.edtn  in
						(
		 				SELECT DISTINCT edtn
						FROM  cir_edtn_mast 
						WHERE	 comp_code  = @pcomp_code
						 AND	(edtn  = @pedtn
						 OR	@pedtn  is null OR	@pedtn = '')
						 AND	(main_edtn  = @pmainedtn
						 OR	@pmainedtn  is null OR	@pmainedtn = '')
						)
		) second_sup
			FROM  cir_dbksup a , cir_taluka_mast b  ,  cir_agmast c   
				
				
			WHERE	 a.comp_code  = @pcomp_code
			 AND	a.comp_code  = c.comp_code
             and  b.comp_code  = c.comp_code
			 AND	a.unit_code  = @punit_code
			 AND	a.unit_code  = c.unit
			 AND	(a.supdate  = @vfirstdate
			 OR	a.supdate  = @vseconddate)
			 AND	a.agcd  = c.agcd
			 AND	a.dpcd  = c.dpcd
			 AND	(c.tehsil_taluka  = @ptaluka
			 OR	@ptaluka  is null  OR	@ptaluka = '')
             AND	c.tehsil_taluka  = b.talu_code 
		) q
		WHERE	 ISNULL(second_sup, 0) - ISNULL(first_sup, 0)  <> 0
		GROUP BY  q.comp_code 
		ORDER BY q.comp_code 
		


///////////////////////////////////end by Garima
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROCEDURE [dbo].[cir_rep_supply_cir_dist_supply_variance_p]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@ppublication                             VARCHAR(20) ,
	@pmainedtn                                VARCHAR(20) ,
	@pedtn                                    VARCHAR(20) ,
	@pdist                                    VARCHAR(20) ,
	@pfirstdate                                VARCHAR(20),
	@pseconddate                               VARCHAR(20),
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(200) ,
	@pextra2                                  VARCHAR(200) ,
    @pextra3             as varchar(200),--agency type
	@pextra4             as varchar(200),-- agency class
	@pextra5             as varchar(200),--final.unfinal
	@pextra6             as varchar(200),
	@pextra7             as varchar(200),
	@pextra8             as varchar(200),
	@pextra9             as varchar(200),
	@pextra10            as varchar(200)
AS 

	DECLARE @vfirstdate                               DATETIME 
	DECLARE @vseconddate                              DATETIME 
	--	SELECT @vfirstdate  = @pfirstdate
	--	SELECT @vseconddate  =  @pseconddate
	SET @vfirstdate  =  dbo.convert_user_date('/',@pfirstdate,@pdateformat)
	SET @vseconddate  = dbo.convert_user_date('/',@pseconddate,@pdateformat)

print(@vfirstdate)
print(@vseconddate)
		
		SELECT
				 m.comp_code "COMP CODE",m.agcd "AGENCY CODE",m.dpcd "AGENCY SUB CODE",
				 m.ag_name "AGENCY NAME",m.ag_name_oth_lang "AGENCY OTHER LANG",DBO.cir_get_city(m.comp_code, m.city_code) "CITY NAME",
				 m.dist_code "DISTRICT CODE",m.dist_name "DISTRICT NAME",m.dist_oname "DISTRICT NAME OTHER LANG",
				 SUM(m.first_sup) "FIRST SUPPLY",SUM(m.second_sup) "SECOND SUPPLY",

				CASE sign(ISNULL(SUM(m.second_sup), 0) - ISNULL(SUM(m.first_sup), 0)) WHEN - 1 THEN 0 
				ELSE (ISNULL(SUM(m.second_sup), 0) - ISNULL(SUM(m.first_sup), 0)) 
				END "INCREASE SUPPLY",
				 
				CASE sign(ISNULL(SUM(m.second_sup), 0) - ISNULL(SUM(m.first_sup), 0)) WHEN 1 THEN 0 
				ELSE (ISNULL(SUM(m.second_sup), 0) - ISNULL(SUM(m.first_sup), 0)) 
				END "DECREASE SUPPLY",
				 
				CASE ISNULL(SUM(m.first_sup), 0) WHEN 0 THEN 100 
				ELSE ROUND(((ISNULL(SUM(m.second_sup), 0) - ISNULL(SUM(m.first_sup), 0)) * 100) / CONVERT(FLOAT, 
				CASE sign(SUM(m.second_sup) - SUM(m.first_sup)) WHEN - 1 THEN SUM(m.first_sup) 
				ELSE SUM(m.second_sup) END), 2) 
				END "PERCENT_VARIANCE"
		FROM (	SELECT DISTINCT
					 a.comp_code comp_code,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang,c.city_code,
					c.dist_code,b.dist_name,b.dist_oname,
					 (	SELECT ISNULL(SUM(sup_copy), 0)
					FROM  cir_dbksup 
					WHERE comp_code  = @pcomp_code
					 AND unit_code  = @punit_code
					 AND publ  = @ppublication
					 AND (edtn  = @pedtn OR	@pedtn  is null  OR	@pedtn = '')
					 AND supdate  = @vfirstdate
					 AND cir_dbksup.agcd  = a.agcd
					 AND cir_dbksup.dpcd  = a.dpcd
					 AND cir_dbksup.edtn  in(
		 				SELECT DISTINCT edtn FROM  cir_edtn_mast 
						WHERE comp_code  = @pcomp_code
						 AND (edtn  = @pedtn OR	@pedtn  is null OR	@pedtn = '')
						 AND (main_edtn  = @pmainedtn OR	@pmainedtn  is null OR	@pmainedtn = ''))) first_sup,
					 (SELECT ISNULL(SUM(sup_copy), 0)
					FROM  cir_dbksup 
					WHERE comp_code  = @pcomp_code AND	unit_code  = @punit_code
					 AND publ  = @ppublication
					 AND (edtn  = @pedtn OR @pedtn  is null OR	@pedtn = '')
					 AND supdate  = @vseconddate
					 AND cir_dbksup.agcd  = a.agcd AND	cir_dbksup.dpcd  = a.dpcd
					 AND cir_dbksup.edtn  in
						(SELECT DISTINCT edtn FROM  cir_edtn_mast 
						WHERE comp_code  = @pcomp_code
						 AND (edtn  = @pedtn OR	@pedtn  is null OR	@pedtn = '')
						 AND (main_edtn  = @pmainedtn OR	@pmainedtn  is null OR	@pmainedtn = ''))) second_sup
			FROM  cir_dbksup a,cir_dist_mast b,cir_agmast c 
			WHERE a.comp_code  = @pcomp_code AND a.comp_code  = c.comp_code AND b.comp_code  = c.comp_code
			 AND a.unit_code  = @punit_code AND a.unit_code  = c.unit
			 AND (a.supdate  = @vfirstdate OR	a.supdate  = @vseconddate)
			 AND a.agcd  = c.agcd AND a.dpcd  = c.dpcd
			 AND (c.dist_code  = @pdist OR	@pdist  is null  OR	@pdist = '')
			 AND c.dist_code  = b.dist_code) m
		WHERE	ISNULL(second_sup, 0) - ISNULL(first_sup, 0)  <> 0
		GROUP BY m.comp_code,m.agcd,m.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.dist_code,m.dist_name,m.dist_oname 
		ORDER BY m.comp_code,m.dist_code,m.ag_name 
		
		SELECT
				 r.comp_code "COMP CODE", r.dist_code "DISTRICT CODE", r.dist_name "DISTRICT NAME",
				 r.dist_oname "DISTRICT NAME OTHER LANG",
				 SUM(r.first_sup) "FIRST SUPPLY",
				 SUM(r.second_sup) "SECOND SUPPLY",
				CASE sign(ISNULL(SUM(r.second_sup), 0) - ISNULL(SUM(r.first_sup), 0)) WHEN - 1 THEN 0 
				ELSE (ISNULL(SUM(r.second_sup), 0) - ISNULL(SUM(r.first_sup), 0)) 
				END "INCREASE SUPPLY",
				 
				CASE sign(ISNULL(SUM(r.second_sup), 0) - ISNULL(SUM(r.first_sup), 0)) WHEN 1 THEN 0 
				ELSE (ISNULL(SUM(r.second_sup), 0) - ISNULL(SUM(r.first_sup), 0)) 
				END "DECREASE SUPPLY",
				 
				CASE ISNULL(SUM(r.first_sup), 0) WHEN 0 THEN 100 
				ELSE ROUND(((ISNULL(SUM(r.second_sup), 0) - ISNULL(SUM(r.first_sup), 0)) * 100) / CONVERT(FLOAT, 
				CASE sign(SUM(r.second_sup) - SUM(r.first_sup)) WHEN - 1 THEN SUM(r.first_sup)
				ELSE SUM(r.second_sup)END), 2) 
				END "PERCENT_VARIANCE"
		FROM (	SELECT DISTINCT
					 a.comp_code comp_code,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang,c.city_code,c.dist_code,b.dist_name,b.dist_oname,
					 (SELECT ISNULL(SUM(sup_copy), 0)
					FROM  cir_dbksup 
					WHERE comp_code  = @pcomp_code
					 AND unit_code  = @punit_code
					 AND publ  = @ppublication
					 AND (edtn  = @pedtn OR	@pedtn  is null OR	@pedtn = '')
					 AND supdate  = @vfirstdate
					 AND cir_dbksup.agcd  = a.agcd
					 AND cir_dbksup.dpcd  = a.dpcd
					 AND cir_dbksup.edtn  in
						(SELECT DISTINCT edtn FROM  cir_edtn_mast 
						WHERE comp_code  = @pcomp_code
						 AND (edtn  = @pedtn OR	@pedtn  is null OR	@pedtn = '')
						 AND (main_edtn  = @pmainedtn OR	@pmainedtn  is null OR	@pmainedtn = ''))) first_sup,
					 (SELECT ISNULL(SUM(sup_copy), 0) FROM  cir_dbksup 
					WHERE comp_code  = @pcomp_code
					 AND unit_code  = @punit_code
					 AND publ  = @ppublication
					 AND (edtn  = @pedtn OR	@pedtn  is null)
					 AND supdate  = @vseconddate
					 AND cir_dbksup.agcd  = a.agcd
					 AND cir_dbksup.dpcd  = a.dpcd
					 AND cir_dbksup.edtn  in (SELECT DISTINCT edtn FROM  cir_edtn_mast 
						WHERE comp_code  = @pcomp_code
						 AND (edtn  = @pedtn OR	@pedtn  is null OR	@pedtn = '')
						 AND (main_edtn  = @pmainedtn OR	@pmainedtn  is null OR	@pmainedtn = ''))) second_sup
			FROM  cir_dbksup a,cir_dist_mast b,cir_agmast c 
			WHERE a.comp_code  = @pcomp_code
			 AND a.comp_code  = c.comp_code
			 AND b.comp_code  = c.comp_code
			 AND a.unit_code  = @punit_code
			 AND a.unit_code  = c.unit
			 AND (a.supdate  = @vfirstdate OR	a.supdate  = @vseconddate)
			 AND a.agcd  = c.agcd AND a.dpcd  = c.dpcd
			 AND (c.dist_code  = @pdist OR	@pdist  is null OR	@pdist = '')
			 AND c.dist_code  = b.dist_code) r
		WHERE ISNULL(second_sup, 0) - ISNULL(first_sup, 0)  <> 0
		GROUP BY r.comp_code,r.dist_code,r.dist_name,r.dist_oname 
		ORDER BY r.comp_code,r.dist_code 
		
		

		SELECT
				 q.comp_code "COMP CODE",
				 SUM(q.first_sup) "FIRST SUPPLY",
				 SUM(q.second_sup) "SECOND SUPPLY",
				CASE sign(ISNULL(SUM(q.second_sup), 0) - ISNULL(SUM(q.first_sup), 0)) WHEN - 1 THEN 0 
				ELSE (ISNULL(SUM(q.second_sup), 0) - ISNULL(SUM(q.first_sup), 0)) 
				END "INCREASE SUPPLY",
				 
				CASE sign(ISNULL(SUM(q.second_sup), 0) - ISNULL(SUM(q.first_sup), 0)) WHEN 1 THEN 0 
				ELSE (ISNULL(SUM(q.second_sup), 0) - ISNULL(SUM(q.first_sup), 0)) 
				END "DECREASE SUPPLY",
				 
				CASE ISNULL(SUM(q.first_sup), 0) WHEN 0 THEN 100 
				ELSE ROUND(((ISNULL(SUM(q.second_sup), 0) - ISNULL(SUM(q.first_sup), 0)) * 100) / CASE sign(SUM(q.second_sup) - SUM(q.first_sup)) WHEN - 1 THEN SUM(q.first_sup) ELSE SUM(q.second_sup) END, 2) 
				END "PERCENT_VARIANCE"
		FROM (	SELECT DISTINCT a.comp_code comp_code,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang,c.city_code,c.dist_code,b.dist_name,b.dist_oname,
					 (SELECT ISNULL(SUM(sup_copy), 0)
					FROM  cir_dbksup 
					WHERE comp_code  = @pcomp_code
					 AND unit_code  = @punit_code
					 AND publ  = @ppublication
					 AND (edtn  = @pedtn OR	@pedtn  is null OR	@pedtn = '')
					 AND supdate  = @vfirstdate
					 AND cir_dbksup.agcd  = a.agcd AND	cir_dbksup.dpcd  = a.dpcd
					 AND cir_dbksup.edtn  in
						(SELECT DISTINCT edtn
						FROM  cir_edtn_mast 
						WHERE comp_code  = @pcomp_code
						 AND (edtn  = @pedtn OR	@pedtn  is null OR	@pedtn = '')
						 AND (main_edtn  = @pmainedtn OR	@pmainedtn  is null OR	@pmainedtn = ''))) first_sup,
					 (	SELECT ISNULL(SUM(sup_copy), 0)
					FROM  cir_dbksup 
					WHERE comp_code  = @pcomp_code AND unit_code  = @punit_code
					 AND publ  = @ppublication
					 AND (edtn  = @pedtn OR	@pedtn  is null OR	@pedtn = '')
					 AND supdate  = @vseconddate
					 AND cir_dbksup.agcd  = a.agcd AND cir_dbksup.dpcd  = a.dpcd
					 AND cir_dbksup.edtn  in
						(SELECT DISTINCT edtn
						FROM  cir_edtn_mast 
						WHERE comp_code  = @pcomp_code
						 AND (edtn  = @pedtn OR	@pedtn  is null OR	@pedtn = '')
						 AND	(main_edtn  = @pmainedtn OR	@pmainedtn  is null OR	@pmainedtn = ''))) second_sup
			FROM  cir_dbksup a,cir_dist_mast b,cir_agmast c 
			WHERE a.comp_code  = @pcomp_code AND	a.comp_code  = c.comp_code AND	b.comp_code  = c.comp_code
			 AND a.unit_code  = @punit_code AND	a.unit_code  = c.unit
			 AND (a.supdate  = @vfirstdate OR	a.supdate  = @vseconddate)
			 AND a.agcd  = c.agcd AND a.dpcd  = c.dpcd
			 AND (c.dist_code  = @pdist OR	@pdist  is null OR	@pdist = '')
			 AND c.dist_code  = b.dist_code) q
		WHERE ISNULL(second_sup, 0) - ISNULL(first_sup, 0)  <> 0
		GROUP BY  q.comp_code 
		ORDER BY q.comp_code 
		

/////////////////////////////////////////////////////////////










set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROCEDURE [dbo].[cir_rep_supply_cir_dist_supply_variance_p]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@ppublication                             VARCHAR(20) ,
	@pmainedtn                                VARCHAR(20) ,
	@pedtn                                    VARCHAR(20) ,
	@pdist                                    VARCHAR(20) ,
	@pfirstdate                                VARCHAR(20),
	@pseconddate                               VARCHAR(20),
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(200) ,
	@pextra2                                  VARCHAR(200) ,
    @pextra3             as varchar(200),--agency type
	@pextra4             as varchar(200),-- agency class
	@pextra5             as varchar(200),--final.unfinal
	@pextra6             as varchar(200),
	@pextra7             as varchar(200),
	@pextra8             as varchar(200),
	@pextra9             as varchar(200),
	@pextra10            as varchar(200)
AS 

	DECLARE @vfirstdate                               DATETIME 
	DECLARE @vseconddate                              DATETIME 
	--	SELECT @vfirstdate  = @pfirstdate
	--	SELECT @vseconddate  =  @pseconddate
	SET @vfirstdate  =  dbo.convert_user_date('/',@pfirstdate,@pdateformat)
	SET @vseconddate  = dbo.convert_user_date('/',@pseconddate,@pdateformat)

print(@vfirstdate)
print(@vseconddate)
		
		SELECT
				 m.comp_code "COMP CODE",m.agcd "AGENCY CODE",m.dpcd "AGENCY SUB CODE",
				 m.ag_name "AGENCY NAME",m.ag_name_oth_lang "AGENCY OTHER LANG",DBO.cir_get_city(m.comp_code, m.city_code) "CITY NAME",
				 m.dist_code "DISTRICT CODE",m.dist_name "DISTRICT NAME",m.dist_oname "DISTRICT NAME OTHER LANG",
				 SUM(m.first_sup) "FIRST SUPPLY",SUM(m.second_sup) "SECOND SUPPLY",

				CASE sign(ISNULL(SUM(m.second_sup), 0) - ISNULL(SUM(m.first_sup), 0)) WHEN - 1 THEN 0 
				ELSE (ISNULL(SUM(m.second_sup), 0) - ISNULL(SUM(m.first_sup), 0)) 
				END "INCREASE SUPPLY",
				 
				CASE sign(ISNULL(SUM(m.second_sup), 0) - ISNULL(SUM(m.first_sup), 0)) WHEN 1 THEN 0 
				ELSE (ISNULL(SUM(m.second_sup), 0) - ISNULL(SUM(m.first_sup), 0)) 
				END "DECREASE SUPPLY",
				 
				CASE ISNULL(SUM(m.first_sup), 0) WHEN 0 THEN 100 
				ELSE ROUND(((ISNULL(SUM(m.second_sup), 0) - ISNULL(SUM(m.first_sup), 0)) * 100) / CONVERT(FLOAT, 
				CASE sign(SUM(m.second_sup) - SUM(m.first_sup)) WHEN - 1 THEN SUM(m.first_sup) 
				ELSE SUM(m.second_sup) END), 2) 
				END "PERCENT_VARIANCE"
		FROM (	SELECT DISTINCT
					 a.comp_code comp_code,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang,c.city_code,
					c.dist_code,b.dist_name,b.dist_oname,
					 (	SELECT ISNULL(SUM(sup_copy), 0)
					FROM  cir_dbksup 
					WHERE comp_code  = @pcomp_code
					 AND unit_code  = @punit_code
					 AND publ  = @ppublication
					 AND (edtn  = @pedtn OR	@pedtn  is null  OR	@pedtn = '')
					 AND supdate  = @vfirstdate
					 AND cir_dbksup.agcd  = a.agcd
					 AND cir_dbksup.dpcd  = a.dpcd
					 AND cir_dbksup.edtn  in(
		 				SELECT DISTINCT edtn FROM  cir_edtn_mast 
						WHERE comp_code  = @pcomp_code
						 AND (edtn  = @pedtn OR	@pedtn  is null OR	@pedtn = '')
						 AND (main_edtn  = @pmainedtn OR	@pmainedtn  is null OR	@pmainedtn = ''))) first_sup,
					 (SELECT ISNULL(SUM(sup_copy), 0)
					FROM  cir_dbksup 
					WHERE comp_code  = @pcomp_code AND	unit_code  = @punit_code
					 AND publ  = @ppublication
					 AND (edtn  = @pedtn OR @pedtn  is null OR	@pedtn = '')
					 AND supdate  = @vseconddate
					 AND cir_dbksup.agcd  = a.agcd AND	cir_dbksup.dpcd  = a.dpcd
					 AND cir_dbksup.edtn  in
						(SELECT DISTINCT edtn FROM  cir_edtn_mast 
						WHERE comp_code  = @pcomp_code
						 AND (edtn  = @pedtn OR	@pedtn  is null OR	@pedtn = '')
						 AND (main_edtn  = @pmainedtn OR	@pmainedtn  is null OR	@pmainedtn = ''))) second_sup
			FROM  cir_dbksup a,cir_dist_mast b,cir_agmast c 
			WHERE a.comp_code  = @pcomp_code AND a.comp_code  = c.comp_code AND b.comp_code  = c.comp_code
			 AND a.unit_code  = @punit_code AND a.unit_code  = c.unit
			 AND (a.supdate  = @vfirstdate OR	a.supdate  = @vseconddate)
			 AND a.agcd  = c.agcd AND a.dpcd  = c.dpcd
			 AND (c.dist_code  = @pdist OR	@pdist  is null  OR	@pdist = '')
			 AND c.dist_code  = b.dist_code) m
		WHERE	ISNULL(second_sup, 0) - ISNULL(first_sup, 0)  <> 0
		GROUP BY m.comp_code,m.agcd,m.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.dist_code,m.dist_name,m.dist_oname 
		ORDER BY m.comp_code,m.dist_code,m.ag_name 
		
		SELECT
				 r.comp_code "COMP CODE", r.dist_code "DISTRICT CODE", r.dist_name "DISTRICT NAME",
				 r.dist_oname "DISTRICT NAME OTHER LANG",
				 SUM(r.first_sup) "FIRST SUPPLY",
				 SUM(r.second_sup) "SECOND SUPPLY",
				CASE sign(ISNULL(SUM(r.second_sup), 0) - ISNULL(SUM(r.first_sup), 0)) WHEN - 1 THEN 0 
				ELSE (ISNULL(SUM(r.second_sup), 0) - ISNULL(SUM(r.first_sup), 0)) 
				END "INCREASE SUPPLY",
				 
				CASE sign(ISNULL(SUM(r.second_sup), 0) - ISNULL(SUM(r.first_sup), 0)) WHEN 1 THEN 0 
				ELSE (ISNULL(SUM(r.second_sup), 0) - ISNULL(SUM(r.first_sup), 0)) 
				END "DECREASE SUPPLY",
				 
				CASE ISNULL(SUM(r.first_sup), 0) WHEN 0 THEN 100 
				ELSE ROUND(((ISNULL(SUM(r.second_sup), 0) - ISNULL(SUM(r.first_sup), 0)) * 100) / CONVERT(FLOAT, 
				CASE sign(SUM(r.second_sup) - SUM(r.first_sup)) WHEN - 1 THEN SUM(r.first_sup)
				ELSE SUM(r.second_sup)END), 2) 
				END "PERCENT_VARIANCE"
		FROM (	SELECT DISTINCT
					 a.comp_code comp_code,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang,c.city_code,c.dist_code,b.dist_name,b.dist_oname,
					 (SELECT ISNULL(SUM(sup_copy), 0)
					FROM  cir_dbksup 
					WHERE comp_code  = @pcomp_code
					 AND unit_code  = @punit_code
					 AND publ  = @ppublication
					 AND (edtn  = @pedtn OR	@pedtn  is null OR	@pedtn = '')
					 AND supdate  = @vfirstdate
					 AND cir_dbksup.agcd  = a.agcd
					 AND cir_dbksup.dpcd  = a.dpcd
					 AND cir_dbksup.edtn  in
						(SELECT DISTINCT edtn FROM  cir_edtn_mast 
						WHERE comp_code  = @pcomp_code
						 AND (edtn  = @pedtn OR	@pedtn  is null OR	@pedtn = '')
						 AND (main_edtn  = @pmainedtn OR	@pmainedtn  is null OR	@pmainedtn = ''))) first_sup,
					 (SELECT ISNULL(SUM(sup_copy), 0) FROM  cir_dbksup 
					WHERE comp_code  = @pcomp_code
					 AND unit_code  = @punit_code
					 AND publ  = @ppublication
					 AND (edtn  = @pedtn OR	@pedtn  is null)
					 AND supdate  = @vseconddate
					 AND cir_dbksup.agcd  = a.agcd
					 AND cir_dbksup.dpcd  = a.dpcd
					 AND cir_dbksup.edtn  in (SELECT DISTINCT edtn FROM  cir_edtn_mast 
						WHERE comp_code  = @pcomp_code
						 AND (edtn  = @pedtn OR	@pedtn  is null OR	@pedtn = '')
						 AND (main_edtn  = @pmainedtn OR	@pmainedtn  is null OR	@pmainedtn = ''))) second_sup
			FROM  cir_dbksup a,cir_dist_mast b,cir_agmast c 
			WHERE a.comp_code  = @pcomp_code
			 AND a.comp_code  = c.comp_code
			 AND b.comp_code  = c.comp_code
			 AND a.unit_code  = @punit_code
			 AND a.unit_code  = c.unit
			 AND (a.supdate  = @vfirstdate OR	a.supdate  = @vseconddate)
			 AND a.agcd  = c.agcd AND a.dpcd  = c.dpcd
			 AND (c.dist_code  = @pdist OR	@pdist  is null OR	@pdist = '')
			 AND c.dist_code  = b.dist_code) r
		WHERE ISNULL(second_sup, 0) - ISNULL(first_sup, 0)  <> 0
		GROUP BY r.comp_code,r.dist_code,r.dist_name,r.dist_oname 
		ORDER BY r.comp_code,r.dist_code 
		
		

		SELECT
				 q.comp_code "COMP CODE",
				 SUM(q.first_sup) "FIRST SUPPLY",
				 SUM(q.second_sup) "SECOND SUPPLY",
				CASE sign(ISNULL(SUM(q.second_sup), 0) - ISNULL(SUM(q.first_sup), 0)) WHEN - 1 THEN 0 
				ELSE (ISNULL(SUM(q.second_sup), 0) - ISNULL(SUM(q.first_sup), 0)) 
				END "INCREASE SUPPLY",
				 
				CASE sign(ISNULL(SUM(q.second_sup), 0) - ISNULL(SUM(q.first_sup), 0)) WHEN 1 THEN 0 
				ELSE (ISNULL(SUM(q.second_sup), 0) - ISNULL(SUM(q.first_sup), 0)) 
				END "DECREASE SUPPLY",
				 
				CASE ISNULL(SUM(q.first_sup), 0) WHEN 0 THEN 100 
				ELSE ROUND(((ISNULL(SUM(q.second_sup), 0) - ISNULL(SUM(q.first_sup), 0)) * 100) / CASE sign(SUM(q.second_sup) - SUM(q.first_sup)) WHEN - 1 THEN SUM(q.first_sup) ELSE SUM(q.second_sup) END, 2) 
				END "PERCENT_VARIANCE"
		FROM (	SELECT DISTINCT a.comp_code comp_code,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang,c.city_code,c.dist_code,b.dist_name,b.dist_oname,
					 (SELECT ISNULL(SUM(sup_copy), 0)
					FROM  cir_dbksup 
					WHERE comp_code  = @pcomp_code
					 AND unit_code  = @punit_code
					 AND publ  = @ppublication
					 AND (edtn  = @pedtn OR	@pedtn  is null OR	@pedtn = '')
					 AND supdate  = @vfirstdate
					 AND cir_dbksup.agcd  = a.agcd AND	cir_dbksup.dpcd  = a.dpcd
					 AND cir_dbksup.edtn  in
						(SELECT DISTINCT edtn
						FROM  cir_edtn_mast 
						WHERE comp_code  = @pcomp_code
						 AND (edtn  = @pedtn OR	@pedtn  is null OR	@pedtn = '')
						 AND (main_edtn  = @pmainedtn OR	@pmainedtn  is null OR	@pmainedtn = ''))) first_sup,
					 (	SELECT ISNULL(SUM(sup_copy), 0)
					FROM  cir_dbksup 
					WHERE comp_code  = @pcomp_code AND unit_code  = @punit_code
					 AND publ  = @ppublication
					 AND (edtn  = @pedtn OR	@pedtn  is null OR	@pedtn = '')
					 AND supdate  = @vseconddate
					 AND cir_dbksup.agcd  = a.agcd AND cir_dbksup.dpcd  = a.dpcd
					 AND cir_dbksup.edtn  in
						(SELECT DISTINCT edtn
						FROM  cir_edtn_mast 
						WHERE comp_code  = @pcomp_code
						 AND (edtn  = @pedtn OR	@pedtn  is null OR	@pedtn = '')
						 AND	(main_edtn  = @pmainedtn OR	@pmainedtn  is null OR	@pmainedtn = ''))) second_sup
			FROM  cir_dbksup a,cir_dist_mast b,cir_agmast c 
			WHERE a.comp_code  = @pcomp_code AND	a.comp_code  = c.comp_code AND	b.comp_code  = c.comp_code
			 AND a.unit_code  = @punit_code AND	a.unit_code  = c.unit
			 AND (a.supdate  = @vfirstdate OR	a.supdate  = @vseconddate)
			 AND a.agcd  = c.agcd AND a.dpcd  = c.dpcd
			 AND (c.dist_code  = @pdist OR	@pdist  is null OR	@pdist = '')
			 AND c.dist_code  = b.dist_code) q
		WHERE ISNULL(second_sup, 0) - ISNULL(first_sup, 0)  <> 0
		GROUP BY  q.comp_code 
		ORDER BY q.comp_code 
		




////////////////////////////////////////////////////////////////////////
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


                                                                     
                                                                     
                                                                     
                                             
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
	@pextra2                                  VARCHAR(200),--it is used for supply type 

	@pextra3             as varchar(200),--agency type
	@pextra4             as varchar(200),-- agency class
	@pextra5             as varchar(200),--final.unfinal
	@pextra6             as varchar(200),
	@pextra7             as varchar(200),
	@pextra8             as varchar(200),
	@pextra9             as varchar(200),
	@pextra10            as varchar(200)
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






/////////////////////////end by Garima

//////////////////////////////////////////////Start By  Garima

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER  FUNCTION [dbo].[get_suspend_type](@Psuspend_type_code AS varchar(50))RETURNs VARCHAR(50) as


BEGIN

  declare @vsuspend_desc varchar(200)
select @vsuspend_desc= suspend_desc   from cir_suspend_type_mast where suspend_type_code=@Psuspend_type_code;
  return isnull(@vsuspend_desc,null)

end


////////////////////////////////////////


........................................................

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER procedure [dbo].[cir_rep_supply_detail_p]
    @pcomp_code      as varchar(200),
    @punit_code      as varchar(200),
    @ppubl           as varchar(200),
    @pdateformat     as varchar(200),
    @puserid         as varchar(200),
    @pextra1         as varchar(200),
    @pextra2         as varchar(200),
    @pextra3         as varchar(200),
    @pextra4         as varchar(200),
    @pextra5         as varchar(200),
    @pextra6         as varchar(200),
    @pextra7         as varchar(200),
    @pextra8         as varchar(200),
    @pextra9         as varchar(200),
    @pextra10        as varchar(200)
As
Begin
    
select m.comp_code as "COMP_CODE", m.unit as "UNIT", m.agcd as "AGCD", m.dpcd as "DPCD",m.ag_name as "AG_NAME",
    m.station_code as "DROP_POINT",dbo.cir_get_drop_point_name(m.comp_code,m.unit,m.station_code,1) as "DROP_POINT_NAME", 
    m.city_code as "CITY_CODE", dbo.cir_get_city(m.comp_code,m.city_code) as "CITY_NAME", s.publ as "PUBL",p.publ_name as "PUBL_NAME", 
    e.main_edtn as "MAIN_EDTN",dbo.cir_get_edtn_name(m.comp_code,e.main_edtn) as "MAIN_EDTN_NAME", 
    s.edtn as "EDTN",e.edtn_name as "EDTN_NAME", 
    s.supply_flag as "SUPPLY_FLAG", s.supply_type_code as "SUPPLY_TYPE_CODE",t.sup_ty_name as "SUP_TY_NAME", 
    s.base_supply as "BASE_SUPPLY", s.supply_sun as "SUPPLY_SUN", s.supply_mon as "SUPPLY_MON", s.supply_tue as "SUPPLY_TUE", s.supply_wed as "SUPPLY_WED",
    s.supply_thu as "SUPPLY_THU", s.supply_fri as "SUPPLY_FRI", s.supply_sat as "SUPPLY_SAT", s.supply_spl1 as "SUPPLY_SPL1", s.supply_spl2 as "SUPPLY_SPL2",

   

case @pdateformat

 when 'mm/dd/yyyy' then convert(varchar(10),m.SUSPEND_DATE,101) 

when 'dd/mm/yyyy' then convert(varchar(10),m.SUSPEND_DATE,103) 
when 'yyyy/mm/dd' then convert(varchar(10),m.SUSPEND_DATE,111)  end as "SUSPEND_DATE" ,

dbo.get_suspend_type(m.suspend_type) as"SUSPEND_TYPE"




    from cir_supply s,cir_agmast m,cir_publ_mast p,cir_edtn_mast e,cir_supply_type_mast t
    where m.comp_code=s.comp_code and m.comp_code=p.comp_code and m.comp_code=e.comp_code and m.comp_code=t.comp_code and m.comp_code=isnull(@pcomp_code,m.comp_code) 
and    m.unit=s.unit 
and m.unit=isnull(@punit_code,m.unit) 
and m.agcd=s.agcd and  m.dpcd=s.dpcd and s.publ=p.publ 
and s.publ=isnull(@ppubl,s.publ) 
and 
   s.edtn=e.edtn 
and s.supply_type_code=t.sup_ty_code 
and isnull(m.freeze_flag,'N') ='N' and isnull(m.suspend,'N')='Y'
    order by comp_code,unit,city_name,drop_point_name,ag_name,publ_name,main_edtn_name,edtn_name,sup_ty_name;    
End


//////////////////////////////////////End by Garima


//////////////////////////////// deepika For Provisional receipt entry 29/02/2012 ///////////////////////////////////////////////
USE [abhi]
GO
/****** Object:  StoredProcedure [dbo].[cir_prov_receipt_id]    Script Date: 02/29/2012 13:45:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[cir_prov_receipt_id]
    @pcompcode		as	VARCHAR(40) ,
    @pbranchcode    as	VARCHAR(40) ,
    @pdoctype       as	VARCHAR(40) ,
    @precptdt       as	VARCHAR(40) ,
    @pdateformat    as	VARCHAR(40) ,
    @pextra1        as	VARCHAR(40) ,
    @pextra2        as	VARCHAR(40),
    @pextra3        as	varchar(40),
    @pextra4        as	varchar(40),
    @pextra5        as	varchar(40) 
AS 
        DECLARE @vno			NUMERIC(20) 
        DECLARE @vrecptno       VARCHAR(15) 
        DECLARE @v_dt           DATETIME 

        SET @v_dt  =   dbo.convert_user_date('/', @precptdt,@pdateformat) 

		SELECT @vno  =  CAST( MAX(SUBSTRING(recptno, 5, 8))AS NUMERIC) + 1
		FROM  cir_rcphdr_prov 
		WHERE comp_code  = @pcompcode AND doctype  = @pdoctype
		--AND  CONVERT(VARCHAR(23), recptdt)  = CONVERT(VARCHAR(23), @v_dt)
		AND  branch_code  = @pbranchcode
        
        IF ISNULL(@vno, 0)= 0 
			BEGIN 
				SET @vrecptno  = @pbranchcode + '-' + REPLACE(CONVERT(VARCHAR(5), @v_dt, 2), '.', '')+ '0001' 
			END
        ELSE
			BEGIN 
				SET @vrecptno  = @pbranchcode + '-' + dbo.fnPadLeft('0',8,@vno) 
			END
   
        SELECT @vrecptno as VAR_CODE

///////////////////////////////////////////////end/////////////////////////////////////////////////////////////////////////



/////////////////////////////////////deepika for Area comparision report 29/02/2012 ///////////////////////////////////////


USE [abhi]
GO
/****** Object:  StoredProcedure [dbo].[cir_rep_outstanding_cir_agency_prevbal_comp_p]    Script Date: 02/29/2012 14:18:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[cir_rep_outstanding_cir_agency_prevbal_comp_p]
    @pcompcode       as varchar(200),
    @punitcode       as varchar(200),
    @pbranchcode     as varchar(200),
    @pagency_type    as varchar(200),
    @pagency_class   as varchar(200),
    @pagcd           as varchar(200),
    @pdpcd           as varchar(200),
    @pstatecode      as varchar(200),
    @pdistcode       as varchar(200),
    @pcitycode       as varchar(200),
    @ptalukacode     as varchar(200),
    @pfrom_date      as datetime,
    @ptill_date      as datetime,
    @prcpt_date      as datetime,
    @pdateformat     as varchar(200),
    @pbreakon        as varchar(20),--State(S)/District(D)/Taluka(T)/Branch(B)
    @prep_type       as varchar(20),--Detail(D)/Summary(S)
    @pbilltype       as varchar(20),--Weekly(W)/Monthly(M)
    @plangtype       as varchar(20),--Enlish(1)/Other Language(2)
    @pbilldata       as varchar(20),--All(Blank)/Billing Data(B)/Without Billing Data(W)       
    @pextra1         as varchar(200),
    @pextra2         as varchar(200),
    @pextra3         as varchar(200),
    @pextra4         as varchar(200),
    @pextra5         as varchar(200)
As

	declare @v_recfrdt	as datetime
    declare @v_rectodt  as datetime
    declare @v_opdate   as datetime
    
	declare @v_amt       numeric(15,2)
    declare @v_opbal     numeric(15,2)
    declare @v_clbal     numeric(15,2)
    declare @v_billamt   numeric(15,2)
    declare @v_dbcramt   numeric(15,2)
    declare @v_recamt    numeric(15,2)
    declare @v_othdbamt  numeric(15,2)
    declare @v_othcramt  numeric(15,2)
    declare @v_secbal    numeric(15,2)
	set @v_opbal	=0
    set @v_clbal    =0
    set @v_billamt  =0
    set @v_dbcramt  =0
    set @v_recamt   =0
    set @v_othdbamt =0
    set @v_othcramt =0
    set @v_secbal   =0
    
    CREATE TABLE #CIR_BILL_PRINT
( COMP_CODE      VARCHAR(100),
  UNIT_CODE      VARCHAR(100),
  BILLNO         VARCHAR(200),
  BILLDT         DATETIME,
  PUBL_CODE      VARCHAR(100),
  EDTN_CODE      VARCHAR(100),
  AGCD           VARCHAR(100),
  DPCD           VARCHAR(100),
  SUPPLY_DATE    DATETIME,
  SUPPLY_COPY    NUMERIC(10),
  SUPPLY_RATE    NUMERIC(10,2),
  COMM_RATE      NUMERIC(12,2),
  SUR_RATE       NUMERIC(10,2),
  RETURN_COPY    NUMERIC(10),
  RETURN_AMT     NUMERIC(14,2),
  GROSS_AMT      NUMERIC(15,2)	DEFAULT 0,
  COMM_AMT       NUMERIC(15,5)  DEFAULT 0,
  SUR_AMT        NUMERIC(15,2),
  SEC_AMT        NUMERIC(15,2)  DEFAULT 0,
  BRANCH_CODE    VARCHAR(8),
  REC_AMT        NUMERIC(15,2)  DEFAULT 0)  

	declare @v1_comp_code	as varchar(20)
	declare @v1_unit	as varchar(20)
	declare @v1_agcd	as varchar(20)
	declare @v1_dpcd	as varchar(20)
	declare @v1_ag_name	as varchar(200)
	declare @v1_ag_name_oth_lang	as varchar(500)
	declare @v1_city_code		as varchar(200)
	declare @v1_tehsil_taluka	as varchar(200)
	declare @v1_dist_code		as varchar(200)
	declare @v1_state_code		as varchar(200)
	declare @v1_country_code	as varchar(200)
	declare @v1_branch_code		as varchar(200)
Begin

CREATE TABLE #CIR_TEMP_OUTSTANDING
( COMP_CODE        VARCHAR(100),
  UNIT_CODE        VARCHAR(100),
  DT               DATETIME,
  PUBL_CODE        VARCHAR(100),
  AGCD             VARCHAR(100),
  DPCD             VARCHAR(100),
  BILL_AMT         NUMERIC(15,2)	DEFAULT 0,
  RETURN_AMT       NUMERIC(15,2)    DEFAULT 0,
  DN_AMT           NUMERIC(15,2)    DEFAULT 0,
  CN_AMT           NUMERIC(15,2)    DEFAULT 0,
  REC_AMT          NUMERIC(15,2)    DEFAULT 0,
  AGNAME           VARCHAR(200),
  AGNAME_OTH_LANG  VARCHAR(250),
  CITY_CODE        VARCHAR(200),
  TALUKA_CODE      VARCHAR(200),
  DIST_CODE        VARCHAR(200),
  STATE_CODE       VARCHAR(200),
  COUNTRY_CODE     VARCHAR(200),
  OP_AMT           NUMERIC(15,2))
  

          
	--SET @v_opdate  = DBO.cir_get_finandt(@pcompcode, dbo.convert_user_date('/', @pfrom_date , @pdateformat), @pdateformat, '', '')
	SET @v_opdate  = DBO.cir_get_finandt(@pcompcode, @pfrom_date, @pdateformat, '', '')
		--for financial date
print(@v_opdate)
    SET @v_recfrdt	= DATEADD(D, 1, @ptill_date)
	SET @v_rectodt	= @prcpt_date

		
  print('q')
 DECLARE c1 cursor LOCAL FOR 
            select distinct x.comp_code comp_code,x.unit unit,x.agcd agcd,x.dpcd dpcd,x.ag_name ag_name,x.ag_name_oth_lang ag_name_oth_lang,
            x.city_code city_code,x.branch_code branch_code,x.tehsil_taluka tehsil_taluka,x.dist_code dist_code,x.state_code state_code,x.country_code country_code
            from
            (select distinct a.comp_code comp_code,a.unit unit,a.agcd agcd,a.dpcd dpcd,a.ag_name ag_name,a.ag_name_oth_lang ag_name_oth_lang,
            a.city_code city_code,a.branch_code branch_code,a.tehsil_taluka tehsil_taluka,a.dist_code dist_code,a.state_code state_code,a.country_code country_code
            from cir_agmast a
                where a.comp_code=@pcompcode and a.unit=@punitcode and
                a.agcd=isnull(@pagcd,a.agcd) and a.dpcd=isnull(@pdpcd,a.dpcd) and
                (a.ag_type=@pagency_type or @pagency_type is null) and (a.ag_class= @pagency_class or @pagency_class is null) and
                (a.state_code=@pstatecode or @pstatecode is null) and (a.dist_code=@pdistcode or @pdistcode is null) and
                (a.tehsil_taluka=@ptalukacode or @ptalukacode is null) and (a.branch_code=@pbranchcode or @pbranchcode is null) and
                (a.executive_code =@pextra1 or @pextra1 is null) and @pbilldata is null
            union
            select distinct a.comp_code comp_code,a.unit unit,a.agcd agcd,a.dpcd dpcd,a.ag_name ag_name,a.ag_name_oth_lang ag_name_oth_lang,
            a.city_code city_code,a.branch_code branch_code,a.tehsil_taluka tehsil_taluka,a.dist_code dist_code,a.state_code state_code,a.country_code country_code
            from cir_agmast a
                where a.comp_code=@pcompcode and a.unit=@punitcode and
                a.agcd=isnull(@pagcd,a.agcd) and a.dpcd=isnull(@pdpcd,a.dpcd) and
                (a.ag_type=@pagency_type or @pagency_type is null) and (a.ag_class= @pagency_class or @pagency_class is null) and
                (a.state_code=@pstatecode or @pstatecode is null) and (a.dist_code=@pdistcode or @pdistcode is null) and
                (a.tehsil_taluka=@ptalukacode or @ptalukacode is null) and (a.branch_code=@pbranchcode or @pbranchcode is null) and
                exists (select 'x' from cir_bill where cir_bill.comp_code=a.comp_code and cir_bill.unit_code=a.unit and cir_bill.agcd=a.agcd and
                cir_bill.dpcd=a.dpcd and billdt >= @pfrom_date and billdt<=@ptill_date) and
                (a.executive_code =@pextra1 or @pextra1 is null) and @pbilldata='B' and  @pbilltype='M'
            union
            select distinct a.comp_code comp_code,a.unit unit,a.agcd agcd,a.dpcd dpcd,a.ag_name ag_name,a.ag_name_oth_lang ag_name_oth_lang,
            a.city_code city_code,a.branch_code branch_code,a.tehsil_taluka tehsil_taluka,a.dist_code dist_code,a.state_code state_code,a.country_code country_code
            from cir_agmast a
                where a.comp_code=@pcompcode and a.unit=@punitcode and
                a.agcd=isnull(@pagcd,a.agcd) and a.dpcd=isnull(@pdpcd,a.dpcd) and
                (a.ag_type=@pagency_type or @pagency_type is null) and (a.ag_class= @pagency_class or @pagency_class is null) and
                (a.state_code=@pstatecode or @pstatecode is null) and (a.dist_code=@pdistcode or @pdistcode is null) and
                (a.tehsil_taluka=@ptalukacode or @ptalukacode is null) and (a.branch_code=@pbranchcode or @pbranchcode is null) and
                not exists (select 'x' from cir_bill where cir_bill.comp_code=a.comp_code and cir_bill.unit_code=a.unit and cir_bill.agcd=a.agcd and
                cir_bill.dpcd=a.dpcd and billdt >= @pfrom_date and billdt<=@ptill_date) and
                (a.executive_code =@pextra1 or @pextra1 is null) and @pbilldata='W' and  @pbilltype='M'
                union
            select distinct a.comp_code comp_code,a.unit unit,a.agcd agcd,a.dpcd dpcd,a.ag_name ag_name,a.ag_name_oth_lang ag_name_oth_lang,
            a.city_code city_code,a.branch_code branch_code,a.tehsil_taluka tehsil_taluka,a.dist_code dist_code,a.state_code state_code,a.country_code country_code
            from cir_agmast a
                where a.comp_code=@pcompcode and a.unit=@punitcode and
                a.agcd=isnull(@pagcd,a.agcd) and a.dpcd=isnull(@pdpcd,a.dpcd) and
                (a.ag_type=@pagency_type or @pagency_type is null) and (a.ag_class= @pagency_class or @pagency_class is null) and
                (a.state_code=@pstatecode or @pstatecode is null) and (a.dist_code=@pdistcode or @pdistcode is null) and
                (a.tehsil_taluka=@ptalukacode or @ptalukacode is null) and (a.branch_code=@pbranchcode or @pbranchcode is null) and
                exists (select 'x' from #cir_bill_print) and
                (a.executive_code =@pextra1 or @pextra1 is null) and @pbilldata='B' and  @pbilltype='W') x
               order by x.ag_name;

        
        open c1
            fetch NEXT FROM c1 INTO @v1_comp_code ,@v1_unit, @v1_agcd,@v1_dpcd ,@v1_ag_name,@v1_ag_name_oth_lang,@v1_city_code,
            @v1_branch_code,@v1_tehsil_taluka, @v1_dist_code, @v1_state_code,@v1_country_code
            WHILE (@@FETCH_STATUS = 0) BEGIN 

            set @v_opbal        =dbo.cir_accounts_cir_agency_opbal(@pcompcode,@punitcode,'',@v1_agcd,@v1_dpcd,@v_opdate,'NM',@pdateformat,null,null)
			set @v_amt          =dbo.cir_accounts_cir_agency_ytodt(@pcompcode,@punitcode,'',@v1_agcd,@v1_dpcd,@v_opdate,@v_rectodt,'NM',@pdateformat,null,null)
            set @v_opbal        =isnull(@v_opbal,0)+isnull(@v_amt,0)
			set @v_amt			=0

			set @v_secbal       =dbo.cir_accounts_cir_agency_opbal(@pcompcode,@punitcode,'',@v1_agcd,@v1_dpcd,@v_opdate,'SC',@pdateformat,null,null)
			set @v_amt          =dbo.cir_accounts_cir_agency_ytodt(@pcompcode,@punitcode,'',@v1_agcd,@v1_dpcd,@v_opdate,@v_rectodt,'SC',@pdateformat,null,null)
			set	@v_secbal       =isnull(@v_secbal,0)+isnull(@v_amt,0)

            set @v_billamt=0
            PRINT('11')
            select @v_billamt=SUM(amount) from cir_outmast
                where comp_code=@pcompcode and unit_code=@punitcode and 
                    agcd=@v1_agcd and dpcd=@v1_dpcd and billdt >= @pfrom_date and billdt<=@ptill_date and 
                    achd='NM' and recptno is null
            
            select @v_recamt=SUM(amount)  from cir_rcphdr
                where comp_code=@pcompcode and unit_code=@punitcode and 
                    agcd=@v1_agcd and dpcd=@v1_dpcd and recptdt>= @v_recfrdt and recptdt<=@v_rectodt and doctype='RCR' and 
                    achd='NM'

            select @v_othdbamt=SUM(amount) from cir_rcphdr a
                where a.comp_code=@pcompcode and a.unit_code=@punitcode and 
                    a.agcd=@v1_agcd and dpcd=@v1_dpcd and a.recptdt>= @v_recfrdt and a.recptdt<=@v_rectodt and 
                    a.achd='NM' and a.amount>0

            select @v_othcramt=SUM(amount) from cir_rcphdr a
                where a.comp_code=@pcompcode and a.unit_code=@punitcode and 
                    a.agcd=@v1_agcd and a.dpcd=@v1_dpcd and a.recptdt>= @v_recfrdt and a.recptdt<=@v_rectodt and 
                    a.doctype<>'RCR' and a.achd='NM' and a.amount<0
            
				set @v_clbal =isnull(@v_opbal,0)+isnull(@v_recamt,0)+isnull(@v_othdbamt,0)+isnull(@v_othcramt,0)
				PRINT('P')    
				PRINT(@v_secbal)
				PRINT(@v_clbal)
				PRINT(@v_opbal)
				PRINT(@v_billamt)
				PRINT(@v_othdbamt)
				PRINT(@v_recamt)
				PRINT(@v_othcramt)
				If (@v_secbal<>0 or @v_clbal<>0  or @v_opbal<>0 or @v_billamt<>0 or @v_othdbamt<>0 or @v_recamt<>0 or @v_othcramt<>0) Begin
					insert into #cir_temp_outstanding(comp_code,unit_code,dt,publ_code,agcd,dpcd,op_amt,bill_amt,dn_amt,rec_amt,cn_amt,return_amt,
								agname,agname_oth_lang,city_code,taluka_code,dist_code,state_code,country_code)
                            values(@v1_comp_code,@v1_unit,@pfrom_date,'',@v1_agcd,@v1_dpcd,isnull(@v_opbal,0),isnull(@v_billamt,0),isnull(@v_othdbamt,0),isnull(@v_recamt,0),isnull(@v_othcramt,0),isnull(@v_secbal,0),
								@v1_ag_name,@v1_ag_name_oth_lang,@v1_city_code,@v1_tehsil_taluka,@v1_dist_code,@v1_state_code,@v1_country_code)
					print('g')
				End
        set @v_billamt	=0
	    set @v_dbcramt	=0
	    set @v_opbal	=0
	    set @v_clbal	=0
	    set @v_recamt	=0
	    set @v_othdbamt	=0
	    set @v_othcramt	=0
		set @v_amt		=0
	
		fetch NEXT FROM c1 INTO @v1_comp_code ,@v1_unit, @v1_agcd,@v1_dpcd ,@v1_ag_name,@v1_ag_name_oth_lang,@v1_city_code,
            @v1_branch_code,@v1_tehsil_taluka, @v1_dist_code, @v1_state_code,@v1_country_code
        end
        close c1
        
        select a.comp_code AS "COMP_CODE",a.unit_code AS "UNIT_CODE",a.state_code AS "STATE_CODE",substring(dbo.cir_get_state(a.comp_code,a.country_code,a.state_code),1,30) AS "STATE_NAME",
		a.agcd AS "AGCD",a.dpcd AS "DPCD",a.return_amt AS "DEPOSIT_BAL",a.bill_amt AS "BILLAMT",a.op_amt AS "PREV_BAL",a.dn_amt AS "OTHER_DEBIT",abs(a.rec_amt) AS "RECAMT",abs(a.cn_amt) AS "OTHER_CREDIT",
		a.agname AS "AGNAME",a.agname_oth_lang AS "AGNAME_OTH_LANG",
		a.city_code AS "CITY_CODE",substring(dbo.cir_get_city(a.comp_code,a.city_code),1,30) AS "CITY_NAME",
		(isnull(a.op_amt,0)+isnull(a.dn_amt,0)+isnull(a.rec_amt,0)+isnull(a.cn_amt,0)) AS "BALANCE",
		b.branch_code AS "BRANCH_CODE",isnull((select Branch_Name from branch_mst where Branch_Code=b.branch_code),b.branch_code) AS "BRANCH_NAME"
        from #cir_temp_outstanding a,cir_agmast b
        where a.comp_code=@pcompcode and a.comp_code=b.comp_code and a.unit_code=b.unit and a.unit_code=@punitcode and 
        a.agcd=b.agcd and a.dpcd=b.dpcd 
        order by a.comp_code,a.unit_code,branch_name,a.agname

End


////////////////////////////////////////////////////end////////////////////////////////////////////////////////////////


////////////////////////////////Send by Laxman sir 29/02/2012/ updated by deepika/////////////////////////////////


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
              cancel_remark,userid,creation_datetime,branch_code,prov_rec_no,prov_rec_dt,remark_oth)
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
          remark_oth from cir_rcphdr_dis_temp
            where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
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
		
			select @v_recno=count(*) from cir_rcpt_document_dis_temp
			where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
						recptno=@precptno and recptdt=@v_dt
			If @v_recno>0 Begin		                    
				insert into cir_rcpt_document_dis(comp_code, unit_code, doctype, recptno, recptdt, filename, created_by, created_dt)
				select comp_code, unit_code, doctype, recptno, recptdt, filename, created_by, created_dt from cir_rcpt_document_dis_temp
				where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
							recptno=@precptno and recptdt=@v_dt
			End

			select @v_recno=count(*) from cir_rcp_unadj_dis_temp
			where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
						recptno=@precptno and recptdt=@v_dt

			If @v_recno>0 Begin		                    
				insert into cir_rcp_unadj_dis(comp_code,unit_code,agcd,dpcd,doctyp,recptno,recptdt,publ,amount,created_by,created_date,updated_by,updated_date)
				select comp_code,unit_code,agcd,dpcd,doctyp,recptno,recptdt,publ,amount,created_by,created_date,updated_by,updated_date from cir_rcp_unadj_temp_dis
				where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and recptno=@precptno
			End				
		End
    else Begin
        insert into cir_rcphdr(comp_code,unit_code,doctype,agcd,dpcd,recptno,
            recptdt,chno,chdt,chbank,amount,oth_amount,ccdp,ccds,rcdp,rcds,ocdp,ocds,reason,
            remark,achd,voucherno,voucherdt,vchtype,publ,received_from,tdsrate,tdsamt,staxrate,
              staxamt,status,ref_recptno,
              ref_recptdt,
              ref_amount,ref_doctype,cancel_user,cancel_date,
              cancel_remark,userid,creation_date,branch_code,prov_rec_no,prov_rec_dt,remark_oth)
          select comp_code,unit_code,doctype,agcd,dpcd,recptno,
          recptdt,chno,
          CASE chdt WHEN '1900-01-01 00:00:00.000' THEN NULL else chdt END chdt,
          chbank,amount,oth_amount,ccdp,ccds,rcdp,rcds,ocdp,ocds,reason,
          remark,achd,voucherno,voucherdt,vchtype,publ,received_from,tdsrate,tdsamt,staxrate,
          staxamt,status,ref_recptno,
          CASE ref_recptdt WHEN '1900-01-01 00:00:00.000' THEN NULL else ref_recptdt END  ref_recptdt,
          ref_amount,ref_doctype,cancel_user,cancel_date,
          cancel_remark,userid,creation_date,branch_code,prov_rec_no,
          CASE prov_rec_dt WHEN '1900-01-01 00:00:00.000' THEN NULL else prov_rec_dt END prov_rec_dt,remark_oth from cir_rcphdr_temp
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
		
		select @v_recno=count(*) from cir_rcpt_document_temp
        where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
                    recptno=@precptno and recptdt=@v_dt
        If @v_recno>0 Begin            		
			insert into cir_rcpt_document(comp_code, unit_code, doctype, recptno, recptdt, filename, created_by, created_dt)
			select comp_code, unit_code, doctype, recptno, recptdt, filename, created_by, created_dt from cir_rcpt_document_temp
			where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
						recptno=@precptno and recptdt=@v_dt
		End
			select @v_recno=count(*) from cir_rcp_unadj_temp
			where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and 
						recptno=@precptno and recptdt=@v_dt

			If @v_recno>0 Begin		                    
				insert into cir_rcp_unadj(comp_code,unit_code,agcd,dpcd,doctyp,recptno,recptdt,publ,amount,created_by,created_date,updated_by,updated_date)
				select comp_code,unit_code,agcd,dpcd,doctyp,recptno,recptdt,publ,amount,created_by,created_date,updated_by,updated_date from cir_rcp_unadj_temp
				where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and recptno=@precptno
			End		
    end           
    
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
		if upper(@prectype)='D' Begin
			delete from cir_rcphdr_dis_temp 
				where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
					recptno=@precptno
			End
		else Begin
			delete from cir_rcphdr_temp 
				where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
					recptno=@precptno 
		End
        select @v_recno as "RECNO"
		End
     else Begin
        select 0 as "RECNO"
     End

end


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


create procedure cir_rep_do_agencywise_p
     @pcompcode          as varchar(20),
     @punitcode          as varchar(20),
     @pbrancode          as varchar(20),
     @proutemode         as varchar(20),
     @proute             as varchar(200),
     @psubroute          as varchar(200),
     @psubsub_route      as varchar(200),
     @ppubl              as varchar(20),
     @pagtype            as varchar(20),
     @pagclass           as varchar(20),
     @pagcd              as varchar(20),
     @pdpcd              as varchar(20),
     @pdistcode          as varchar(20),
     @plbldt             as datetime,
     @preptype           as varchar(20),
     @puserid            as varchar(20),
     @pdateformat        as varchar(20),
     @pextra1            as varchar(200),
     @pextra2            as varchar(200),
     @pextra3            as varchar(200),
     @pextra4            as varchar(200),
     @pextra5            as varchar(200)
As
    declare @vlbldt datetime
Begin
    If @pbrancode='' Begin
		set @pbrancode=null
	End	
    If @proutemode  ='' Begin
		set @proutemode=null
	End
	If @proute='' Begin		
		set @proute=null
	End
    If @psubroute='' Begin
		set @psubroute=null
	End	
    If @psubsub_route  ='' Begin
		set @psubsub_route=null
	End
	If @ppubl='' Begin		
		set @ppubl=null
	End

    If @pagtype  ='' Begin
		set @pagtype=null
	End
	If @pagclass='' Begin		
		set @pagclass=null
	End
    If @pagcd='' Begin
		set @pagcd=null
	End	
    If @pdpcd  ='' Begin
		set @pdpcd=null
	End
	If @pdistcode='' Begin		
		set @pdistcode=null
	End
	
    select distinct l.comp_code as "COMP_CODE",l.unit_code as "UNIT_CODE",l.agcd as "AGCD", l.dpcd as "DPCD",l.lbl_dt as "LBL_DT",
    l.route1 as "ROUTE_CODE",l.rtnm as "RTNM",l.rtonm as "RTONM",l.subrt as "SUBROUTE_CODE",l.subrtnm as "SUBRTNM",l.subrtonm as "SUBRTONM",
    l.sub_subrt as "SUB_SUBROUTE_CODE",l.subsubrtnm as "SUBSUBRTNM",l.subsubrtonm as "SUBSUBRTONM",l.pkt_size as "PACKET_SIZE", 
    l.lbl_tno as "NO_OF_PACKET",m.mode_desc as "MODE_NAME",
    l.agname as "AGNAME",l.agoname as "AGONAME", l.city_name as "CITY_NAME", l.city_oname as "CITY_ONAME", 
    a.station_code as "DROP_POINT", l.station_name as "DROP_POINT_NAME", l.station_oname as "DROP_POINT_ONAME", l.publ as "PUBL",dbo.cir_get_publ_name(l.comp_code,l.publ) as "PUBL_NAME", 
    l.edtn as "EDTN",dbo.cir_get_edtn_name(l.comp_code,l.edtn) as "EDTN_NAME", 
    sum(l.supply_1) as "NO_OF_COPY",case when l.lbl_tno<=1 then 0 else l.lbl_tno-1 end "STD_PACKET",
    case when l.lbl_tno<=1 then sum(l.supply_1) else sum(l.supply_1)-((l.lbl_tno-1)*l.PKT_SIZE) end as "END_PACKET_COPY",
    l.sup_rate as "SUP_RATE", l.distname as "DISTNAME", l.distoname as "DISTONAME"
    from cir_agmast a,cir_lblmast l,cir_route_mast r,cir_route_mode_mast m
    where a.comp_code=l.comp_code and a.comp_code=r.comp_code and a.comp_code=m.comp_code and a.comp_code=@pcompcode and 
    a.unit=l.unit_code and a.unit=r.unit and a.unit=@punitcode and a.agcd=l.agcd and a.agcd=isnull(@pagcd,l.agcd) and a.dpcd=l.dpcd and a.dpcd=isnull(@pdpcd,l.dpcd) and
    r.route_code=l.route1 and r.route_code=isnull(@proute,r.route_code) and (l.subrt=@psubroute or @psubroute is null) and
    (l.sub_subrt=@psubsub_route or @psubsub_route is null) and r.route_mode=m.mode_code and r.route_mode=isnull(@proutemode,r.route_mode) and 
    l.lbl_dt=@plbldt and (a.ag_type=@pagtype or @pagtype is null) and (a.ag_class=@pagclass or @pagclass is null) and 
    (a.branch_code=@pbrancode or @pbrancode is null) and (a.dist_code=@pdistcode or @pdistcode is null)
    group by l.comp_code,l.unit_code,l.agcd, l.dpcd,l.lbl_dt,l.route1,l.rtnm,l.rtonm,l.subrt,l.subrtnm,l.subrtonm,
    l.sub_subrt,l.subsubrtnm,l.subsubrtonm,l.pkt_size,l.lbl_tno,m.mode_desc,l.agname,l.agoname, l.city_name, l.city_oname, 
    a.station_code,l.station_name, l.station_oname,publ,edtn,l.sup_rate, l.publ_name, l.distname, l.distoname
    order by comp_code,unit_code,rtnm,subrtnm,subsubrtnm,agname;
    
    select getdate() as "CUR_DATE"
End
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

create PROCEDURE cir_route_drop_point_detail_p
    @pcomp_code          as varchar(200),
    @punit_code          as varchar(200),
    @ptaxi_code          as varchar(200),
    @proute_code         as varchar(200),
    @psubroutecode       as varchar(200),
    @psub_subroutecode   as varchar(200),
    @puserid             as varchar(200),
    @pdateformat         as varchar(200),
    @pextra1             as varchar(200),
    @pextra2             as varchar(200),
    @pextra3             as varchar(200),
    @pextra4             as varchar(200),
    @pextra5             as varchar(200)
  As
Begin
    If @proute_code='' Begin
		set @proute_code=null
	End	
    If @psubroutecode  ='' Begin
		set @psubroutecode=null
	End
	If @psub_subroutecode='' Begin		
		set @psub_subroutecode=null
	End
	
    if @proute_code is not null and @psubroutecode is null Begin

        select distinct x.comp_code comp_code, x.unit_code unit_code, x.tpt_code tpt_code,x.tpt_name tpt_name,
        x.rt_code rt_code,x.rt_name rt_name,x.subrt_code subrt_code, x.subrt_name subrt_name,x.sub_subrt_code sub_subrt_code,x.sub_subrt_name sub_subrt_name,
        x.taxi_id taxi_id, x.vehicle_name vehicle_name, x.vehicle_no vehicle_no,
        y.drop_point_code drop_point_code,y.drop_point_name drop_point_name,y.latitude latitude,y.lognitude lognitude,
        min(y.lbl_printno) lbl_printno 
        from
        (select t.comp_code comp_code, t.unit_code unit_code, t.tpt_code tpt_code,(select transporter_name from cir_transporter_mast where comp_code=t.comp_code and transporter_code=t.tpt_code) tpt_name,
        t.rt_code rt_code,r.route_name rt_name,   
        t.subrt_code subrt_code,(select subrt_name from cir_sub_route_mast where comp_code=t.comp_code and unit=t.unit_code and route_code=t.rt_code and subrt_code=t.subrt_code) subrt_name, 
        t.sub_subrt_code sub_subrt_code,(select sub_subrt_name from cir_sub_subroute_mast where comp_code=t.comp_code and unit=t.unit_code and route_code=t.rt_code and subrt_code=t.subrt_code and sub_subrt_code=t.sub_subrt_code) sub_subrt_name,
        t.taxi_id ,t.vehicle_name vehicle_name, t.vehicle_no vehicle_no
        from cir_taxi_mast t,cir_route_mast r
        where t.comp_code=r.comp_code and t.comp_code=@pcomp_code and t.unit_code=r.unit and (t.unit_code=@punit_code or @punit_code is null) and 
        t.rt_code=r.route_code and (t.rt_code=@proute_code or @proute_code is null) and taxi_id=@ptaxi_code) x,
        (select distinct b.comp_code comp_code,b.unit unit_code,b.route_code route_code,b.subroute_code subroute_code,
        b.sub_subroute_code sub_subroute_code,a.station_code drop_point_code,c.drop_point_name drop_point_name,
        c.latitude latitude,c.lognitude lognitude,b.lbl_printno lbl_printno
        from cir_agmast a,cir_supply b,cir_drop_point_mast c
        where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=@pcomp_code and a.unit=b.unit and
        a.unit=c.unit_code and (a.unit=@punit_code or  @punit_code is null) and a.agcd=b.agcd and a.dpcd=b.dpcd and
        a.station_code=c.drop_point and (b.route_code=@proute_code or @proute_code is null) and 
        isnull(a.suspend,'N')='N' and isnull(a.freeze_flag,'N')='N' and isnull(c.freeze_flag,'N')='N') y
        where x.comp_code=y.comp_code and x.unit_code=y.unit_code and x.rt_code=y.route_code and y.subroute_code is null
        group by x.comp_code, x.unit_code, x.tpt_code,x.tpt_name,
        x.rt_code,x.rt_name,x.subrt_code, x.subrt_name,x.sub_subrt_code,x.sub_subrt_name,
        x.taxi_id, x.vehicle_name, x.vehicle_no,
        y.drop_point_code,y.drop_point_name,y.latitude,y.lognitude 
        order by x.comp_code, x.unit_code,x.taxi_id,lbl_printno,y.drop_point_name;
	End
    else if @psubroutecode is not null and @psub_subroutecode is null Begin
        select distinct x.comp_code comp_code, x.unit_code unit_code, x.tpt_code tpt_code,x.tpt_name tpt_name,
        x.rt_code rt_code,x.rt_name rt_name,x.subrt_code subrt_code, x.subrt_name subrt_name,x.sub_subrt_code sub_subrt_code,x.sub_subrt_name sub_subrt_name,
        x.taxi_id taxi_id, x.vehicle_name vehicle_name, x.vehicle_no vehicle_no,
        y.drop_point_code drop_point_code,y.drop_point_name drop_point_name,y.latitude latitude,y.lognitude lognitude,
        min(y.lbl_printno) lbl_printno 
        from
        (select t.comp_code comp_code, t.unit_code unit_code, t.tpt_code tpt_code,(select transporter_name from cir_transporter_mast where comp_code=t.comp_code and transporter_code=t.tpt_code) tpt_name,
        t.rt_code rt_code,r.route_name rt_name,  
        t.subrt_code subrt_code,(select subrt_name from cir_sub_route_mast where comp_code=t.comp_code and unit=t.unit_code and route_code=t.rt_code and subrt_code=t.subrt_code) subrt_name, 
        t.sub_subrt_code sub_subrt_code,(select sub_subrt_name from cir_sub_subroute_mast where comp_code=t.comp_code and unit=t.unit_code and route_code=t.rt_code and subrt_code=t.subrt_code and sub_subrt_code=t.sub_subrt_code) sub_subrt_name,
        t.taxi_id ,t.vehicle_name vehicle_name, t.vehicle_no vehicle_no
        from cir_taxi_mast t,cir_route_mast r
        where t.comp_code=r.comp_code and t.comp_code=@pcomp_code and t.unit_code=r.unit and (t.unit_code=@punit_code or @punit_code is null) and 
        t.rt_code=r.route_code and (t.rt_code=@proute_code or @proute_code is null) and taxi_id=@ptaxi_code) x,
        (select distinct b.comp_code comp_code,b.unit unit_code,b.route_code route_code,b.subroute_code subroute_code,
        b.sub_subroute_code sub_subroute_code,a.station_code drop_point_code,c.drop_point_name drop_point_name,
        c.latitude latitude,c.lognitude lognitude,b.lbl_printno lbl_printno
        from cir_agmast a,cir_supply b,cir_drop_point_mast c
        where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=@pcomp_code and a.unit=b.unit and
        a.unit=c.unit_code and (a.unit=@punit_code or @punit_code is null) and a.agcd=b.agcd and a.dpcd=b.dpcd and
        a.station_code=c.drop_point and (b.route_code=@proute_code or @proute_code is null) and 
        isnull(a.suspend,'N')='N' and isnull(a.freeze_flag,'N')='N' and isnull(c.freeze_flag,'N')='N') y
        where x.comp_code=y.comp_code and x.unit_code=y.unit_code and x.rt_code=y.route_code and 
        x.subrt_code=y.subroute_code and (x.subrt_code=@psubroutecode or @psubroutecode is null) and y.subroute_code is not null and y.sub_subroute_code is null
        group by x.comp_code, x.unit_code, x.tpt_code,x.tpt_name,
        x.rt_code,x.rt_name,x.subrt_code, x.subrt_name,x.sub_subrt_code,x.sub_subrt_name,
        x.taxi_id, x.vehicle_name, x.vehicle_no,
        y.drop_point_code,y.drop_point_name,y.latitude,y.lognitude 
        order by x.comp_code, x.unit_code,x.taxi_id,y.drop_point_name;
	End
    else Begin
        select distinct x.comp_code comp_code, x.unit_code unit_code, x.tpt_code tpt_code,x.tpt_name tpt_name,
        x.rt_code rt_code,x.rt_name rt_name,x.subrt_code subrt_code, x.subrt_name subrt_name,x.sub_subrt_code sub_subrt_code,x.sub_subrt_name sub_subrt_name,
        x.taxi_id taxi_id, x.vehicle_name vehicle_name, x.vehicle_no vehicle_no,
        y.drop_point_code drop_point_code,y.drop_point_name drop_point_name,y.latitude latitude,y.lognitude lognitude,
        min(y.lbl_printno) lbl_printno 
        from
        (select t.comp_code comp_code, t.unit_code unit_code, t.tpt_code tpt_code,(select transporter_name from cir_transporter_mast where comp_code=t.comp_code and transporter_code=t.tpt_code) tpt_name,
        t.rt_code rt_code,r.route_name rt_name, 
        t.subrt_code subrt_code,(select subrt_name from cir_sub_route_mast where comp_code=t.comp_code and unit=t.unit_code and route_code=t.rt_code and subrt_code=t.subrt_code) subrt_name, 
        t.sub_subrt_code sub_subrt_code,(select sub_subrt_name from cir_sub_subroute_mast where comp_code=t.comp_code and unit=t.unit_code and route_code=t.rt_code and subrt_code=t.subrt_code and sub_subrt_code=t.sub_subrt_code) sub_subrt_name,
        t.taxi_id, t.vehicle_name vehicle_name, t.vehicle_no vehicle_no 
        from cir_taxi_mast t,cir_route_mast r
        where t.comp_code=r.comp_code and t.comp_code=@pcomp_code and t.unit_code=r.unit and (t.unit_code=@punit_code or @punit_code is null) and 
        t.rt_code=r.route_code and (t.rt_code=@proute_code or @proute_code is null) and taxi_id=@ptaxi_code) x,
        (select distinct b.comp_code comp_code,b.unit unit_code,b.route_code route_code,b.subroute_code subroute_code,
        b.sub_subroute_code sub_subroute_code,a.station_code drop_point_code,c.drop_point_name drop_point_name,
        c.latitude latitude,c.lognitude lognitude,b.lbl_printno lbl_printno
        from cir_agmast a,cir_supply b,cir_drop_point_mast c
        where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=@pcomp_code and a.unit=b.unit and
        a.unit=c.unit_code and (a.unit=@punit_code or @punit_code is null) and a.agcd=b.agcd and a.dpcd=b.dpcd and
        a.station_code=c.drop_point and (b.route_code=@proute_code or @proute_code is null) and 
        isnull(a.suspend,'N')='N' and isnull(a.freeze_flag,'N')='N' and isnull(c.freeze_flag,'N')='N') y
        where x.comp_code=y.comp_code and x.unit_code=y.unit_code and x.rt_code=y.route_code and 
        x.subrt_code=y.subroute_code and (x.subrt_code=@psubroutecode or @psubroutecode is null) and 
        x.sub_subrt_code=y.sub_subroute_code and (x.sub_subrt_code=@psub_subroutecode or @psub_subroutecode is null) and 
        y.subroute_code is not null and y.sub_subroute_code is not null
        group by x.comp_code, x.unit_code, x.tpt_code,x.tpt_name,
        x.rt_code,x.rt_name,x.subrt_code, x.subrt_name,x.sub_subrt_code,x.sub_subrt_name,
        x.taxi_id, x.vehicle_name, x.vehicle_no,y.drop_point_code,y.drop_point_name,y.latitude,y.lognitude 
        order by x.comp_code, x.unit_code,x.taxi_id,y.drop_point_name;       
    End
End
//////////////////////////////////////////////////end of procedures/////////////////////////////////////////////////////////////////////

//--------------------------------29 feb 2012--------------------
ALTER PROCEDURE [dbo].[cir_rep_abc_cir_billing_outstanding]

(
     @pcomp_code         as varchar(100),
     @punit_code         as varchar(100),
     @pbrancode          as varchar(100),
     @pagcd              as varchar(100),
     @pdpcd              as varchar(100),
     @pagtype             as varchar(100),
     @pstatecode        as varchar(100),
     @pcitycode          as varchar(100),
     @pason_date         as varchar(100),
     @pdateformat         as varchar(100),
     @pextra1             as varchar(100),
     @pextra2            as varchar(100)

)
AS 



 declare  @v_ason    as     datetime;
 declare  @v_opdate  as   datetime;
 declare  @v_opbal   as    numeric(15,2)
 declare  @v_clbal   as    numeric(15,2)
 declare  @v_billamt as   numeric
 declare  @v_dbcramt as   numeric
 declare  @v_diff    as    numeric



declare @v1_comp_code as varchar(50)
declare @v1_unit as varchar(50)
declare @v1_agcd as varchar(50)
declare @v1_dpcd as varchar(50)
declare @v1_ag_name as varchar(50)
declare @v1_ag_name_oth_lang as varchar(50)
declare @v1_city_code as varchar(50)
declare @v1_tehsil_taluka as varchar(50)
declare @v1_dist_code as varchar(50)
declare @v1_state_code as varchar(50)
declare @v1_country_code as varchar(50)





declare c1 cursor for

select distinct comp_code,unit,agcd,dpcd,ag_name,ag_name_oth_lang,city_code,tehsil_taluka,dist_code,state_code,
country_code from cir_agmast 
where comp_code=@pcomp_code and unit=@punit_code and 
(ag_type=@pagtype or @pagtype is null) and agcd+dpcd in(select distinct agcd+dpcd from cir_outmast 
where comp_code=@pcomp_code and (unit_code=@punit_code or @punit_code is null) and achd='NM')


open c1
			
fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit,@v1_agcd,@v1_dpcd,@v1_ag_name,@v1_ag_name_oth_lang,
@v1_city_code,@v1_tehsil_taluka,@v1_dist_code,@v1_state_code,@v1_country_code


	WHILE (@@FETCH_STATUS = 0) 
		BEGIN 



select  @v_billamt =sum(amount)  from cir_outmast
where comp_code=@pcomp_code and (unit_code=@punit_code or @punit_code is null) 
and agcd=@v1_agcd and dpcd=@v1_dpcd and billdt >= @v_opdate and billdt<=@v_ason 
and  achd='NM' and recptno is null; 


           
select  @v_dbcramt= sum(amount)   from cir_rcphdr
where comp_code=@pcomp_code and (unit_code=@punit_code or @punit_code is null) 
and agcd=@v1_agcd and dpcd=@v1_dpcd 
and recptdt>= @v_opdate and recptdt<=@v_ason and 
achd='NM';

            




set @v_clbal=isnull(@v_opbal,0)+isnull(@v_billamt,0)+isnull(@v_dbcramt,0);
set @v_billamt=0;
set @v_dbcramt=0;
            select  @v_dbcramt= sum(bill_amount)  from cir_bill ----previous bill amount
                where comp_code=@pcomp_code and unit_code=@punit_code 
--and       billdt between trunc(add_months(v_ason,-1)) 
--and last_day(add_months(v_ason,-1)) 
and  agcd=@v1_agcd and dpcd=@v1_dpcd;


            select @v_billamt= sum(bill_amount)   from cir_bill--------current bill amount 
                where comp_code=@pcomp_code and unit_code=@punit_code 
--and  billdt=last_day(v_ason) 
and agcd=@v1_agcd  and dpcd=@v1_dpcd;





if (@v_clbal<>0 or isnull(@v_billamt,0)<>0 or isnull(@v_dbcramt,0)<>0 )
begin

set @v_diff=(isnull(@v_clbal,0)-isnull(@v_billamt,0)-isnull(@v_dbcramt,0));

if (@v_diff<=0) 
begin
set @v_diff=0;
end

else 
begin           
set @v_diff=@v_diff;
end    

insert into cir_temp_outstanding(comp_code,unit_code,dt,publ_code,agcd,dpcd,op_amt,bill_amt,dn_amt,cn_amt,
        agname,agname_oth_lang,city_code,taluka_code,dist_code,state_code,country_code)
        values(@v1_comp_code,@v1_unit,@v_ason,'',@v1_agcd,@v1_dpcd,@v_clbal,@v_billamt,@v_dbcramt,@v_diff,
        @v1_ag_name,@v1_ag_name_oth_lang,@v1_city_code,@v1_tehsil_taluka,@v1_dist_code,@v1_state_code,@v1_country_code);
end 
set @v_billamt=0;
set @v_dbcramt=0;
set @v_opbal=0;
set @v_clbal=0;
set @v_diff=0;




	fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit,@v1_agcd,@v1_dpcd,@v1_ag_name,@v1_ag_name_oth_lang,
@v1_city_code,@v1_tehsil_taluka,@v1_dist_code,@v1_state_code,@v1_country_code
			End
		close c1
		deallocate c1

 select comp_code,unit_code,dt,publ_code,agcd,dpcd,agname,agname_oth_lang,
        op_amt as outstanding_amt,bill_amt as curr_billamt,dn_amt as prev_billamt,cn_amt as diff_amt,
        city_code,dbo.cir_get_city(comp_code,city_code) city_name,taluka_code,dbo.cir_get_taluka(comp_code,taluka_code) taluka_name,
        dist_code,dbo.cir_get_dist(comp_code,state_code,dist_code) dist_name, state_code,country_code 
        from cir_temp_outstanding
        where comp_code=@pcomp_code and unit_code=@punit_code
        order by comp_code,unit_code,city_name,agname


//--------------------------------end---------------------------------//

//------------------------------------------sapna 29/02/2012--------------------//
ALTER procedure [dbo].[cir_area_break_down]

(
     @pcomp_code         as varchar(100),
    @punit_code         as varchar(100),
    @pbrancode          as varchar(100),
    @ppublcode          as varchar(100),
    @pmedtncode         as varchar(100),
    @pedtncode          as varchar(100),
    @pagtype            as varchar(100),

    @pzonecode          as varchar(100),
    @pregioncode        as varchar(100),
    @pstatecode         as varchar(100),
    @pdistcode          as varchar(100),

    @pfromdate          as varchar(100),
    @ptilldate          as varchar(100),
    @psup_copy          as NUMERIC,
    @psup_baseon        as varchar(100),--it is used for Gross(G)/Average(A)
    @pdateformat        as varchar(100),
    @puserid            as varchar(100),
    @pbreakon           as NUMERIC,--it is used for Grouping on Zone(1)/Region(2)/State(3)/Branch(4)/District(5)/Taluka(6)
    @pdatashow          as NUMERIC,--it is used for data show Agency(1)/City(2)
    @pextra1            as varchar(100),
    @pextra2            as varchar(100),
    @pextra3            as varchar(100),
    @pextra4            as varchar(100),
    @pextra5            as varchar(100)

)


  As



declare @v_zero as     int;
declare @v_comp_code  as     varchar(800);
declare @v_unit  as     varchar(800);
declare @v_agcd as     varchar(800);
declare @v_dpcd as     varchar(800);
declare @v_agency_name as    varchar(800);
declare @v_zone_name as     varchar(800);
declare @v_region_name as     varchar(800);
declare @v_state_name as     varchar(800);
declare @v_branch_name as     varchar(800);
declare @v_dist_name as    varchar(800);
declare @v_taluka_name as     varchar(800);
declare @v_city_name as     varchar(800);
declare @v_sup_copy as     varchar(800);
declare @v_null as      varchar(800);


CREATE TABLE #CIR_TEMP_BILL_COLLECTION
(
  COMP_CODE        VARCHAR(100),
  UNIT_CODE        VARCHAR(100),
  BILLNO           VARCHAR(200),
  BILLDT           DATETIME,
  PUBL_CODE        VARCHAR(100),
  AGCD             VARCHAR(100 ),
  DPCD             VARCHAR(100 ),
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
  AGNAME           VARCHAR(200 ),
  AGNAME_OTH_LANG  VARCHAR(250 ),
  CITY_CODE        VARCHAR(200 ),
  TALUKA_CODE      VARCHAR(200 ),
  DIST_CODE        VARCHAR(200 ),
  STATE_CODE       VARCHAR(200 ),
  REMARKS          VARCHAR(500 ),
  RET_COMM_AMT     NUMERIC(15,2),
  BILL_SEC_AMT     NUMERIC(15,2),
  SEC_OPBAL        NUMERIC(15,2)

)


declare @v_frdt    as  datetime;
declare @v_todt    as  datetime;



declare cur_supply cursor for


    select a.comp_code comp_code,
a.unit unit,
a.agcd agcd,
a.dpcd dpcd,
a.ag_name agency_name,

    --d.zone_code zone_code,
dbo.cir_get_zone_name(a.comp_code,d.zone_code) zone_name,
    --d.region_code region,
dbo.cir_get_region_name(a.comp_code,d.region_code) region_name,
    --a.state_code state_code,
dbo.cir_get_state(a.comp_code,a.country_code,a.state_code) state_name,
    --a.dist_code dist_code,
dbo.cir_get_dist(a.comp_code,a.state_code,a.dist_code) dist_name,
   -- isnull(a.abc_citycode,a.city_code) city_code,
d.city_name city_name,
    a.tehsil_taluka taluka_code,
dbo.cir_get_taluka(a.comp_code,a.tehsil_taluka) taluka_name,
    a.branch_code branch_code,
null branch_name,
    sum(b.sup_copy) sup_copy
    from cir_agmast a,cir_dbksup b,cir_edtn_mast c,cir_city_mast d
    where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=d.comp_code and a.comp_code=@pcomp_code 
and        a.unit=@punit_code and a.unit=b.unit_code 
and a.unit=c.unit_code and a.agcd=b.agcd and a.dpcd=b.dpcd 
--and        b.supdate>=@v_frdt and b.supdate<=@v_todt 
--and b.publ=c.publ and b.publ=isnull(@ppublcode,b.publ) 
and b.edtn=c.edtn and  b.edtn=isnull(@pedtncode, b.edtn) 
and c.main_edtn=isnull(@pmedtncode, c.main_edtn) 
--and        isnull(a.abc_citycode,a.city_code)=d.city_code 
and (d.zone_code=@pzonecode or @pzonecode is null) 
and (d.region_code=@pregioncode  or @pregioncode is null)
        group by a.comp_code,a.unit,a.agcd,a.dpcd,a.ag_name,a.country_code,a.state_code,a.dist_code,isnull(a.abc_citycode,a.city_code),d.city_name,d.zone_code,d.region_code,a.tehsil_taluka,a.branch_code;
 



begin

set @v_frdt   =@pfromdate
set @v_todt   =@ptilldate
set @v_null= null
set @v_zero=0


open cur_supply

fetch next from  cur_supply INTO 

@v_comp_code,@v_unit,@v_agcd,@v_dpcd,@v_agency_name,@v_zone_name,@v_region_name,@v_state_name,
            @v_branch_name,@v_dist_name,@v_taluka_name,@v_city_name,@v_null,@v_sup_copy,@v_zero


WHILE (@@FETCH_STATUS = 0) 
	BEGIN  

        insert into #cir_temp_bill_collection(comp_code,unit_code,agcd,dpcd,agname, agname_oth_lang ,remarks ,state_code,
            billno,dist_code,taluka_code,city_code,publ_code,supply_copy,return_copy)
        values(@v_comp_code,@v_unit,@v_agcd,@v_dpcd,@v_agency_name,@v_zone_name,@v_region_name,@v_state_name,
            @v_branch_name,@v_dist_name,@v_taluka_name,@v_city_name,null,@v_sup_copy,0);






fetch next from  cur_supply INTO 

@v_comp_code,@v_unit,@v_agcd,@v_dpcd,@v_agency_name,@v_zone_name,@v_region_name,@v_state_name,
            @v_branch_name,@v_dist_name,@v_taluka_name,@v_city_name,@v_null,@v_sup_copy,@v_zero




END


	close cur_supply
	deallocate cur_supply



if (@pbreakon='1') begin --zone wise
        
        select a.comp_code comp_code,a.unit_code unit_code,
        a.agname_oth_lang zone_code,a.city_code city_name,
        sum(a.supply_copy) gross_copy,
        0 less_copy,0 Above_copy
        from #cir_temp_bill_collection a 

        group by a.comp_code,a.unit_code,a.agname_oth_lang,a.city_code
        order by comp_code,unit_code,zone_code,city_name;

       
        select a.comp_code comp_code,a.unit_code unit_code,
        a.agname_oth_lang zone_code,sum(a.supply_copy) gross_copy,
        0 less_copy,0 Above_copy
        from #cir_temp_bill_collection a 
        group by a.comp_code,a.unit_code,a.agname_oth_lang
        order by comp_code,unit_code,agname_oth_lang;

end

   if (@pbreakon='2')
 begin --region wise
        
        select a.comp_code comp_code,a.unit_code unit_code,
        a.remarks region_name,
        a.city_code city_name,
        sum(a.supply_copy) gross_copy,
        0 less_copy,0 Above_copy
        from #cir_temp_bill_collection a 

        group by a.comp_code,a.unit_code,a.remarks,a.city_code
        order by comp_code,unit_code,region_name,city_name;

        
        select a.comp_code comp_code,a.unit_code unit_code,
        a.remarks region_name,sum(a.supply_copy) gross_copy,
        0 less_copy,0 Above_copy
        from #cir_temp_bill_collection a 

        group by a.comp_code,a.unit_code,a.remarks
        order by comp_code,unit_code,region_name;

end
   
if (@pbreakon='3')
 begin --state wise
       
        select a.comp_code comp_code,a.unit_code unit_code,
        a.state_code state_name,
        a.dist_code dist_name,
        a.city_code city_name,
        a.taluka_code taluka_name,sum(a.supply_copy) gross_copy,
        0 less_copy,0 Above_copy
        from #cir_temp_bill_collection a 

        group by a.comp_code,a.unit_code,a.state_code,a.city_code
        order by comp_code,unit_code,state_name,city_name;

       
        select a.comp_code comp_code,a.unit_code unit_code,
        a.state_code state_name,sum(a.supply_copy) gross_copy,
        0 less_copy,0 Above_copy
        from #cir_temp_bill_collection a 

        group by a.comp_code,a.unit_code,a.state_code
        order by comp_code,unit_code,state_name;
end

    if (@pbreakon='4')
    begin --Branch wise

        select a.comp_code comp_code,a.unit_code unit_code,
        a.billno branch_name,
        a.city_code city_name,
        sum(a.supply_copy) gross_copy,
        0 less_copy,0 Above_copy
        from #cir_temp_bill_collection a 
        group by a.comp_code,a.unit_code,a.billno,a.city_code
        order by comp_code,unit_code,branch_name,city_name;

       
        select a.comp_code comp_code,a.unit_code unit_code,
        a.billno branch_name,sum(a.supply_copy) gross_copy,
        0 less_copy,0 Above_copy
        from #cir_temp_bill_collection a 

        group by a.comp_code,a.unit_code,a.billno
        order by comp_code,unit_code,branch_name;
end
    if (@pbreakon='5') begin --District wise

        select a.comp_code comp_code,a.unit_code unit_code, a.dist_code dist_name,
        a.city_code city_name,  sum(a.supply_copy) gross_copy,  0 less_copy,0 Above_copy
        from #cir_temp_bill_collection a 

        group by a.comp_code,a.unit_code,a.dist_code,a.city_code
        order by comp_code,unit_code,dist_name,city_name;

       
        select a.comp_code comp_code,a.unit_code unit_code,
        a.dist_code dist_name, sum(a.supply_copy) gross_copy,
        0 less_copy,0 Above_copy
        from #cir_temp_bill_collection a 

        group by a.comp_code,a.unit_code,a.dist_code
        order by comp_code,unit_code,dist_name;

end
    if(@pbreakon='6')
 begin --Taluka wise
       
        select a.comp_code comp_code,a.unit_code unit_code, a.taluka_code taluka_name,
        a.city_code city_name, sum(a.supply_copy) gross_copy,        0 less_copy,0 Above_copy
        from #cir_temp_bill_collection a 
        group by a.comp_code,a.unit_code,a.taluka_code,a.city_code
        order by comp_code,unit_code,taluka_name,city_name;


        select a.comp_code comp_code,a.unit_code unit_code, a.taluka_code taluka_name, sum(a.supply_copy) gross_copy,
        0 less_copy,0 Above_copy
        from #cir_temp_bill_collection a 

        group by a.comp_code,a.unit_code,a.taluka_code
        order by comp_code,unit_code,taluka_name;
     end ;


delete from #cir_temp_bill_collection
end

//---------------------------------------------end----------------------//


//------------------------------------------------------

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[websp_pubcenter_new]
	@pextra1                                  VARCHAR(4000)AS 
	BEGIN
		SET NOCOUNT ON
		
		
		SELECT
				 Pub_cent_Code,
				 Pub_Cent_name + '(' + CAST(City_Name AS VARCHAR) + ')' AS "center"
		FROM  pub_cent_mast,
			 city_mst 
		WHERE	 city_mst.City_Code  = pub_cent_mast.City_Code
		 AND	ISNULL(pub_cent_mast.print_cent, 'Y')  != 'N'
		 AND	((UPPER(Pub_Cent_name)  LIKE UPPER(@pextra1) + '%')
		 OR	(@pextra1  IS NULL))
		ORDER BY center 
		
		
		SELECT
				 Agency_Name,
				 code_subcode
		FROM  agency_mast 
		ORDER BY Agency_Name 
		

		SET NOCOUNT OFF

	END
//-----------------------------------------------------------------
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[cir_gen_code_spons_code_P] 
    @pcompcode 		AS varchar(20),
    @pdateformat	AS varchar(20),
    @pextra1 		AS varchar(200),
    @pextra2 		AS varchar(200) 
    As
    
BEGIN
	declare @vno         numeric(8);
    
    select @vno=isnull(max(SPONS_ID),0)+1 from CIR_SPONS_HDR

    select @vno as "VAR_CODE"
End


//-----------------------------------------------------------

ALTER PROCEDURE [dbo].[cir_taxi_billing_p]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@pbilldt_fr                               datetime ,
	@pbilldt_to                              datetime ,
	@pbill_dt                                 datetime ,
	@ptrans_code                              VARCHAR(20) ,
	@ptds_rate                                FLOAT ,
	@p_user_id                                VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS 


 
		
		DECLARE @v_billdt_fr                              DATETIME 
		DECLARE @v_billdt_to                              DATETIME 
		DECLARE @v_billdt                                 DATETIME 

declare @billdate_to_v as datetime


		SET @v_billdt_fr  = @pbilldt_fr--dbo.CONVERT_USER_DATE('/', @pbilldt_fr,@pdateformat)
		set @billdate_to_v=dbo.GetLastDayOfMonth(@v_billdt_fr)
		print(@v_billdt_fr)
		SET @v_billdt_to  =@billdate_to_v-- dbo.CONVERT_USER_DATE('/', @billdate_to_v,@pdateformat)
		print(@v_billdt_to)
		SET @v_billdt  =  @billdate_to_v--@pbill_dt--dbo.CONVERT_USER_DATE('/', @pbill_dt, @pdateformat)

--print(@v_billdt_fr)
--print(@v_billdt_to)
--print(@v_billdt)


/***********************************************************/
DECLARE @v_comp_code1                              VARCHAR(4000) 
DECLARE @v_unit_code1                              VARCHAR(4000) 
DECLARE @v_taxi_id1                                VARCHAR(4000) 

/**************************************************************/

		DECLARE cur_taxi_mast cursor LOCAL FOR 
				SELECT DISTINCT comp_code, unit_code, taxi_id	FROM  cir_route_taxi_mast 
				WHERE	 comp_code  = @pcomp_code AND	unit_code  = @punit_code
				AND (CAST( FLOOR( CAST(  dep_date AS FLOAT ) ) AS DATETIME ))	  between @v_billdt_fr  and  @v_billdt_to 
				AND	((trans_code  = @ptrans_code) OR	(@ptrans_code  is null) OR	(@ptrans_code  = ''))
			    AND	ISNULL(bill_flag, 'N')  = 'N'
				AND	((bill_no  is null) or (bill_no = ''))
			    AND	((bill_dt  is null) or (bill_dt = ''))
                ORDER BY taxi_id 



		
	--	DECLARE @v_taxi                                   VARCHAR(200) /* SwisSQL (Oracle To SQL Server) : Table used in Cursor referenced here is not found in Metadata or Metadata not Updated*/ 

	--	DECLARE cur_taxi_tran cursor LOCAL FOR 





		
	--	DECLARE @rec_taxi_tran                            VARCHAR(200) /* SwisSQL (Oracle To SQL Server) : Table used in Cursor referenced here is not found in Metadata or Metadata not Updated*/ 
		DECLARE @v_bill_no                                VARCHAR(15) 
		DECLARE @v_amt                                    NUMERIC(10,2) 
		DECLARE @v_gross_amt                              NUMERIC(10,2) 
		DECLARE @v_tds_amt                                NUMERIC(10,2) 
		DECLARE @v_bill_amt                               NUMERIC(10,2) 
		DECLARE @v_tot_dist                               NUMERIC(10,2) 
		DECLARE @v_tot_days                               NUMERIC(10,2) 
		DECLARE @billdays                                 NUMERIC(5) 
		DECLARE @v_rate                                   NUMERIC(10,2)                   
		SET @v_rate = 0 
		DECLARE @v_tot_gross_amt                          NUMERIC(12,2) 
		DECLARE @v_tot_tds_amt                            NUMERIC(12,2) 
		DECLARE @v_tot_bills                              NUMERIC(5) 




	--	SELECT @billdays  =  DATEPART(DD, DATEADD(D, -DAY(DATEADD(M, 1, @v_billdt_fr)), DATEADD(M, 1, @v_billdt_fr)))
		
        SET @billdays  = day(CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,@v_billdt_fr))),DATEADD(mm,1,@v_billdt_fr)),101))

print(@billdays)
		
		OPEN cur_taxi_mast 
		
        fetch NEXT FROM cur_taxi_mast INTO @v_comp_code1 ,@v_unit_code1 ,@v_taxi_id1




		WHILE (@@FETCH_STATUS = 0) 
		BEGIN 
			
--print('2')		
--        print @v_comp_code1
-- print @v_unit_code1
-- print @v_taxi_id1


             /***********************************************************/
DECLARE @v_comp_code2                              VARCHAR(4000) 
DECLARE @v_unit_code2                              VARCHAR(4000) 
DECLARE @v_trans_code2                                VARCHAR(4000) 
DECLARE @v_route_code2                                VARCHAR(4000) 
DECLARE @v_vehicle_no2                                VARCHAR(4000) 
DECLARE @v_vehicle_name2                              VARCHAR(4000) 
DECLARE @v_vehicle_model_no2                          VARCHAR(4000) 
DECLARE @v_vehicle_owner_name2                        VARCHAR(4000) 
DECLARE @v_vehicle_addr12                           VARCHAR(4000) 
DECLARE @v_vehicle_addr22                           VARCHAR(4000) 
DECLARE @v_vehicle_start_date2                      DATETIME
DECLARE @v_vehicle_capacity2                        VARCHAR(4000) 
DECLARE @v_rate_freq2                               VARCHAR(4000) 
DECLARE @v_rate_type2                               VARCHAR(4000) 
DECLARE @v_rate_amt2                                numeric(18,2) 
DECLARE @v_freezze_flag2                            VARCHAR(4000) 
DECLARE @v_sub_routecode2                           VARCHAR(4000) 
DECLARE @v_sub_subroute_code2                       VARCHAR(4000) 
DECLARE @v_arr_time2                                VARCHAR(4000) 
DECLARE @v_dep_time2                                VARCHAR(4000) 
DECLARE @v_dep_date2                                DATETIME 
DECLARE @v_arr_date2                                DATETIME
DECLARE @v_act_dist2                                VARCHAR(4000)
DECLARE @v_exp_arr_time2                            VARCHAR(4000) 
DECLARE @v_exp_dep_time2                            VARCHAR(4000) 
DECLARE @v_bill_flag2                               VARCHAR(4000) 
DECLARE @v_taxi_id2                                 VARCHAR(4000)  
DECLARE @v_bill_no2                                 VARCHAR(4000)  
DECLARE @v_bill_dt2                                 DATETIME 

/**************************************************************/
	DECLARE cur_taxi_tran cursor LOCAL FOR 

			SELECT comp_code, unit_code, trans_code, route_code, vehicle_no, vehicle_name, vehicle_model_no, vehicle_owner_name,
		    vehicle_addr1, vehicle_addr2, vehicle_start_date, vehicle_capacity, rate_freq, rate_type, rate_amt,
		    freezze_flag, sub_routecode, sub_subroute_code, arr_time, dep_time, dep_date, arr_date, act_dist,
		    exp_arr_time, exp_dep_time, bill_flag, taxi_id, bill_no, bill_dt
			FROM  cir_route_taxi_mast 
            WHERE	 comp_code  = @v_comp_code1
		    AND	unit_code  = @v_unit_code1
			AND	(CAST( FLOOR( CAST(  dep_date AS FLOAT ) ) AS DATETIME ))  between @v_billdt_fr  and  @v_billdt_to
			AND	((trans_code  = @ptrans_code) OR	(@ptrans_code  is null) OR	(@ptrans_code  = ''))
			AND	taxi_id  = @v_taxi_id1
			AND	ISNULL(bill_flag, 'N')  = 'N'
			AND	((bill_no  is null) or (bill_no = ''))
			AND	((bill_dt  is null) or (bill_dt = ''))
		    ORDER BY dep_date, trans_code 




			
			  OPEN cur_taxi_tran 
				
	print('2')		 
			  fetch NEXT FROM cur_taxi_tran INTO  @v_comp_code2 , @v_unit_code2 ,@v_trans_code2 ,@v_route_code2,   
              @v_vehicle_no2 , @v_vehicle_name2,@v_vehicle_model_no2 ,@v_vehicle_owner_name2,@v_vehicle_addr12 , 
              @v_vehicle_addr22,@v_vehicle_start_date2,@v_vehicle_capacity2,@v_rate_freq2,@v_rate_type2,@v_rate_amt2, 
              @v_freezze_flag2,@v_sub_routecode2 ,@v_sub_subroute_code2 ,@v_arr_time2,@v_dep_time2,@v_dep_date2 ,@v_arr_date2 ,
              @v_act_dist2 ,@v_exp_arr_time2,@v_exp_dep_time2,@v_bill_flag2,@v_taxi_id2 ,@v_bill_no2,@v_bill_dt2 


	          WHILE (@@FETCH_STATUS = 0) 
			  BEGIN 

print('3')
print(@v_rate_type2)

				IF   @v_rate_type2 = 'R' 
				BEGIN 
					-- for on rate
					
				
					IF @v_rate_freq2 = 'D' 
					BEGIN 
						--for daily
						
						SET @v_rate  =  @v_rate_amt2
						
					END
					IF   @v_rate_freq2 = 'M'  
					BEGIN 
						--for monthly
						
						SET @v_rate  = ROUND( @v_rate_amt2 / CONVERT(FLOAT, @billdays), 2)
					END
   
					SET @v_amt  = @v_rate * ISNULL( @v_act_dist2, 0)
					SET @v_gross_amt  = ISNULL(@v_gross_amt, 0)+ ISNULL(@v_amt, 0)
				END
				ELSE
				BEGIN 
					---for fixed amount
					
				
					IF  @v_rate_freq2 = 'D' 
					BEGIN 
						--for daily
						
						SET @v_rate  =  @v_rate_amt2
						
					END
					IF   @v_rate_freq2 = 'M'  
					BEGIN 
						--for monthly
						
						SET @v_rate  = ROUND(ISNULL( @v_rate_amt2, 0) / CONVERT(FLOAT, @billdays), 2)
					END
   
					SET @v_amt  = @v_rate 
					SET @v_gross_amt  = ISNULL(@v_gross_amt, 0)+ ISNULL(@v_amt, 0)
				END
   
				SET @v_tot_dist  = ISNULL(@v_tot_dist, 0)+ ISNULL(@v_act_dist2, 0)
				SET @v_tot_days  = ISNULL(@v_tot_days, 0)+ 1 
			

              fetch NEXT FROM cur_taxi_tran INTO  @v_comp_code2 , @v_unit_code2 ,@v_trans_code2 ,@v_route_code2,   
              @v_vehicle_no2 , @v_vehicle_name2,@v_vehicle_model_no2 ,@v_vehicle_owner_name2,@v_vehicle_addr12 , 
              @v_vehicle_addr22,@v_vehicle_start_date2,@v_vehicle_capacity2,@v_rate_freq2,@v_rate_type2,@v_rate_amt2, 
              @v_freezze_flag2,@v_sub_routecode2 ,@v_sub_subroute_code2 ,@v_arr_time2,@v_dep_time2,@v_dep_date2 ,@v_arr_date2 ,
              @v_act_dist2 ,@v_exp_arr_time2,@v_exp_dep_time2,@v_bill_flag2,@v_taxi_id2 ,@v_bill_no2,@v_bill_dt2 



			END 
			
			
			close cur_taxi_tran
        

			
			SET @v_tds_amt  = ISNULL(@v_gross_amt, 0)* ISNULL(@ptds_rate, 0)/ 100 
			SET @v_bill_amt  = ISNULL(@v_gross_amt, 0)- ISNULL(@v_tds_amt, 0)
			--if nvl(v_bill_amt,0)>0 then
			

       --     declare @v_bill_no as  varchar(200)

		    set @v_bill_no =	dbo.cir_taxi_billing_p_cir_taxi_billno_p (  @v_comp_code1  ,   @v_unit_code1 ,  @v_billdt  ,  @pdateformat  ,  @pextra1  ,  @pextra2 )   
			


            INSERT INTO  cir_taxi_bill   ( comp_code , unit_code , trans_code , taxi_id , billno , billdt , rate_type , 
			rate_freq , rate_amt , created_by , tds_rate , tds_amt , 	bill_amt , 	tot_distance , 	tot_days , gross_amt )  
			 VALUES 	( @v_comp_code1 , @v_unit_code1 , @v_trans_code2 , @v_taxi_id1 , @v_bill_no , 
			@v_billdt , @v_rate_type2, @v_rate_freq2 , 	@v_rate , 
			@p_user_id ,@ptds_rate , @v_tds_amt , @v_bill_amt , @v_tot_dist , @v_tot_days , @v_gross_amt )  



			
			UPDATE  cir_route_taxi_mast   
			SET	bill_flag = 'Y',	 bill_no = @v_bill_no,	  bill_dt = @v_billdt 
			WHERE  comp_code  = @v_comp_code1 AND	unit_code  = @v_unit_code1
		    AND	(CAST( FLOOR( CAST(  dep_date AS FLOAT ) ) AS DATETIME ))  between @v_billdt_fr  and  @v_billdt_to
			AND	trans_code  = @v_trans_code2
		    AND	taxi_id  = @v_taxi_id1
			AND	ISNULL(bill_flag, 'N')  = 'N'
			AND	((bill_no  is null) or (bill_no = ''))
			AND	((bill_dt  is null) or (bill_dt = ''))
			
			SET @v_tot_gross_amt  = ISNULL(@v_tot_gross_amt, 0)+ ISNULL(@v_gross_amt, 0)
			SET @v_tot_tds_amt  = ISNULL(@v_tot_tds_amt, 0)+ ISNULL(@v_tds_amt, 0)
			SET @v_tot_bills  = ISNULL(@v_tot_bills, 0)+ 1 
			--end if;
			
			SET @v_tot_dist  = 0 
			SET @v_tot_days  = 0 
			SET @v_amt  = 0 
			SET @v_gross_amt  = 0 
			SET @v_tds_amt  = 0 
			SET @v_bill_amt  = 0 
			SET @v_bill_no  = null 
			SET @v_rate  = 0 

   DEALLOCATE cur_taxi_tran

  fetch NEXT FROM cur_taxi_mast INTO @v_comp_code1 ,@v_unit_code1 ,@v_taxi_id1

			
		END 
		
		
		close cur_taxi_mast
		
		
	
	SELECT @v_tot_bills as TOTAL_BILLS, @v_tot_gross_amt as GROSS_AMOUNT,
	    @v_tot_tds_amt TDS_AMOUNT,
	    ISNULL(@v_tot_gross_amt, 0) - ISNULL(@v_tot_tds_amt, 0) as BILL_AMOUNT
		
 DEALLOCATE cur_taxi_mast
 
 ----------------------------------------------------------------------

