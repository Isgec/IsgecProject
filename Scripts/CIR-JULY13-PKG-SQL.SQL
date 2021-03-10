//===ADD BY DEEPIKA 07-JULY-2013 SENT BY SHUSHIL SIR



ALTER PROCEDURE [dbo].[cir_writeoff_debit_note]
	@pcomp_code                               VARCHAR(4000) ,	--company code	
	@punit_code                               VARCHAR(4000) ,	--unit code
	@pbranch_code                               VARCHAR(4000) ,	--branch code
	@pjv_type                                 VARCHAR(4000) ,	--Debit/Credit	
	@preason                                  VARCHAR(4000) ,	--for reason code	
	@pfrdt                                    VARCHAR(4000) ,	--for from date	
	@ptodt                                    VARCHAR(4000) ,	--for till date
	@pwcdp                                    VARCHAR(4000) ,	--for writeoff account head	
	@paccode                                  VARCHAR(4000) ,	--for other account head	
	@pamountupto                              FLOAT ,	        --for amount upto	
	@puserid                                  VARCHAR(4000) ,	--for create userid	
	@pprocessdt                               VARCHAR(4000) ,	--process date	
	@prowidno                                 int ,	            --for unique ID number	
	@pdateformat                              VARCHAR(4000) ,	--for date format	
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS 
	BEGIN
		SET NOCOUNT ON		
		--declare @vprocessdt as datetime
		set @pdateformat='mm/dd/yyyy'
		-- cursor c1----------
		DECLARE @v1_row_idno as int
		DECLARE @v1_comp_code VARCHAR(50)
		DECLARE @v1_unit VARCHAR(50)
		DECLARE @v1_branch VARCHAR(50)
		DECLARE @v1_ag_main_code VARCHAR(50)
		DECLARE @v1_ag_sub_code VARCHAR(50)
		DECLARE @v1_agency_name VARCHAR(500)
		DECLARE @v1_region VARCHAR(50)
		DECLARE @v1_city_code VARCHAR(50)
		DECLARE @v1_dist_code VARCHAR(50)
		DECLARE @v1_credit_days as int
		DECLARE @v1_amount as float
		-- cursor c1 --- @v1_row_idno,@comp_code,@unit,@ag_main_code,@ag_sub_code,@agency_name,@region,@city_code,@dist_code,@credit_days,@amount
		-- cursor c2--
		declare @v2_ROW_IDNO int
		declare @v2_COMP_CODE varchar(50)
		declare @v2_UNIT  varchar(50)
		declare @v2_BRANCH  varchar(50)
		declare @v2_DOCTYPE  varchar(50)
		declare @v2_DOCNO  varchar(50)
		declare @v2_DOCDT datetime
		declare @v2_PRIPUB  varchar(50)
		declare @v2_AG_MAIN_CODE  varchar(50)
		declare @v2_AG_SUB_CODE  varchar(50)
		declare @v2_CHNO  varchar(50)
		declare @v2_CHDT datetime
		declare @v2_BANK  varchar(100)
		declare @v2_AMOUNT decimal(15,2)
		declare @v2_REASON  varchar(50)
		declare @v2_VOUCHERNO  varchar(50)
		declare @v2_VOUCHERDATE datetime
		declare @v2_RECEIPT_NO  varchar(50)
		declare @v2_PRIPROCTG  varchar(50)
		declare @v2_REF_RECPTNO  varchar(50)
		declare @v2_REF_RECPTDT datetime
		declare @v2_REF_AMOUNT decimal(15,2)
		declare @v2_REF_DOCTYP  varchar(50)
		declare @v2_RECEIVED_REGION  varchar(50)
		declare @v2_REMARK  varchar(2000)
		declare @v2_RETAINER_CODE  varchar(50)
		declare @v2_EXEC_CODE  varchar(50)
		declare @v2_AD_TYPE  varchar(50)
		declare @v2_PREV_CIOID  varchar(50)
		declare @v2_SESS_ID int
		--cursor c2--  @v2_ROW_IDNO, @v2_COMP_CODE , @v2_UNIT , @v2_DOCTYPE , @v2_DOCNO , @v2_DOCDT , @v2_PRIPUB , @v2_AG_MAIN_CODE , @v2_AG_SUB_CODE , @v2_CHNO , @v2_CHDT , @v2_BANK , @v2_AMOUNT , @v2_REASON , @v2_VOUCHERNO , @v2_VOUCHERDATE , @v2_RECEIPT_NO , @v2_PRIPROCTG , @v2_REF_RECPTNO , @v2_REF_RECPTDT , @v2_REF_AMOUNT , @v2_REF_DOCTYP , @v2_RECEIVED_REGION , @v2_REMARK , @v2_RETAINER_CODE , @v2_EXEC_CODE , @v2_AD_TYPE , @v2_PREV_CIOID , @v2_SESS_ID
		-- cursor c3 --
		declare @v3_UNIT    varchar(50)
		declare @v3_BRANCH  varchar(50)
		declare @v3_AGCODE    varchar(50)
		declare @v3_DOCTYPE    varchar(50)
		declare @v3_ROIDNUM    varchar(50)
		declare @v3_PRIPUB    varchar(50)
		declare @v3_BKFOR    varchar(50)
		declare @v3_BILLNO    varchar(50)
		declare @v3_BILLDT  datetime
		declare @v3_RECPTNO    varchar(50)
		declare @v3_RECPTDT  datetime
		declare @v3_CHNO    varchar(50)
		declare @v3_CHDT datetime
		declare @v3_BANK    varchar(100)
		declare @v3_AMOUNT  decimal(15,2)
		declare @v3_REASON    varchar(50)
		declare @v3_BK_AGCODE    varchar(50)
		declare @v3_BK_AGSUBCODE    varchar(50)
		declare @v3_VOUCHERNO    varchar(50)
		declare @v3_SHRTFRDT    datetime
		declare @v3_BALANCE  decimal(15,2)
		declare @v3_CENDES    varchar(50)
		declare @v3_NOOFINSRT    varchar(50)
		declare @v3_TDS  decimal(15,2)
		declare @v3_RECEIPT_NO    varchar(50)
		declare @v3_BK_CHNO    varchar(50)
		declare @v3_MRVDATE  datetime
		declare @v3_PRIPROCTG    varchar(50)
		declare @v3_INSDATE  datetime
		declare @v3_REF_RECPTNO    varchar(50)
		declare @v3_REF_RECPTDT  datetime
		declare @v3_REF_AMOUNT  decimal(15,2)
		declare @v3_REF_DOCTYP    varchar(50)
		declare @v3_ROWIDENTIFIER    varchar(50)
		declare @v3_BKUP_SNO    varchar(50)
		declare @v3_COMP_CODE    varchar(50)
		declare @v3_USERID    varchar(50)
		declare @v3_CREATION_DATETIME  datetime
		declare @v3_RECEIVED_REGION    varchar(50)
		declare @v3_VOUCHERDATE  datetime
		declare @v3_ST  decimal(15,2)
		declare @v3_AG_MAIN_CODE    varchar(50)
		declare @v3_AG_SUB_CODE    varchar(50)
		declare @v3_REMARK    varchar(2000)
		declare @v3_RETAINER_CODE    varchar(50)
		declare @v3_EXEC_CODE    varchar(50)
		declare @v3_AD_TYPE    varchar(50)
		declare @v3_PREV_CIOID   varchar(50)
		-- cursor c3--  @v3_UNIT   ,@v3_AGCODE   ,@v3_DOCTYPE   ,@v3_ROIDNUM   ,@v3_PRIPUB   ,@v3_BKFOR   ,@v3_BILLNO   ,@v3_BILLDT   ,@v3_RECPTNO   ,@v3_RECPTDT   ,@v3_CHNO   ,@v3_CHDT   ,@v3_BANK   ,@v3_AMOUNT   ,@v3_REASON   ,@v3_BK_AGCODE   ,@v3_BK_AGSUBCODE   ,@v3_VOUCHERNO   ,@v3_SHRTFRDT   ,@v3_BALANCE   ,@v3_CENDES   ,@v3_NOOFINSRT   ,@v3_TDS   ,@v3_RECEIPT_NO   ,@v3_BK_CHNO   ,@v3_MRVDATE   ,@v3_PRIPROCTG   ,@v3_INSDATE   ,@v3_REF_RECPTNO   ,@v3_REF_RECPTDT   ,@v3_REF_AMOUNT   ,@v3_REF_DOCTYP   ,@v3_ROWIDENTIFIER   ,@v3_BKUP_SNO   ,@v3_COMP_CODE   ,@v3_USERID   ,@v3_CREATION_DATETIME   ,@v3_RECEIVED_REGION   ,@v3_VOUCHERDATE   ,@v3_ST   ,@v3_AG_MAIN_CODE   ,@v3_AG_SUB_CODE   ,@v3_REMARK   ,@v3_RETAINER_CODE   ,@v3_EXEC_CODE   ,@v3_AD_TYPE   ,@v3_PREV_CIOID
		
		DECLARE @v_recptno                                VARCHAR(50)                     
				SET @v_recptno = 1 
		DECLARE @v_vchno                                  VARCHAR(50)                     
				SET @v_vchno = 1 
		DECLARE @v_doctype                                VARCHAR(10) 
		DECLARE @v_remark                                 VARCHAR(500) 
		DECLARE @vfrdt                                    DATETIME 
		DECLARE @vtodt                                    DATETIME 
		DECLARE @v_pprocessdt                             DATETIME 
		DECLARE @V_CNT                                    FLOAT                           
				SET @V_CNT = 0 
		DECLARE @vquery                                   FLOAT 
		DECLARE @v_prefix                                 VARCHAR(30) 
		declare @v_repcode								varchar(30)
		declare @v_branchnm		varchar(20)		
		
		SELECT @vfrdt  = dbo.convert_user_date('/',@pfrdt,@pdateformat)--CONVERT(DATETIME, @pfrdt)
		SELECT @vtodt  = dbo.convert_user_date('/',@ptodt,@pdateformat)--CONVERT(DATETIME, @ptodt)
		SELECT @v_pprocessdt  =dbo.convert_user_date('/',@pprocessdt,@pdateformat)-- CONVERT(DATETIME, @pprocessdt)
		SELECT @v_remark  = 'Credit Amount Write Off' 
		SELECT @v_doctype  = 'DN' 
-----------
declare @ag_cnt as int
-----------

		DECLARE c1 cursor LOCAL FOR 
				SELECT DISTINCT a.row_idno row_idno, a.comp_code comp_code, a.branch_code unit,a.unit branch_code, a.ag_main_code ag_main_code, 
				a.ag_sub_code ag_sub_code,dbo.cir_get_agency( a.comp_code,a.branch_code, a.ag_main_code,a.ag_sub_code) agency_name, '' region, b.City_Code city_code, b.Dist_Code dist_code
				, b.Credit_Days credit_days, ABS(SUM(CONVERT(FLOAT, a.amount))) amount
				FROM  CIR_WRITEOFF_PROCESS_DATA a,cir_agmast b 
				WHERE	 a.row_idno  = @prowidno AND a.comp_code = b.Comp_Code AND a.ag_main_code = b.agcd AND a.ag_sub_code = b.dpcd
				GROUP BY a.row_idno, a.comp_code, a.unit,a.branch_code, a.ag_main_code, a.ag_sub_code, b.ag_Name, b.City_Code, b.Dist_Code, b.Credit_Days
		
		OPEN C1			
			FETCH NEXT FROM C1 INTO @v1_row_idno,@v1_comp_code,@v1_unit,@v1_branch,@v1_ag_main_code,@v1_ag_sub_code,@v1_agency_name,@v1_region,@v1_city_code,@v1_dist_code,@v1_credit_days,@v1_amount
			WHILE (@@FETCH_STATUS = 0) 
			BEGIN
				print(@@FETCH_STATUS)
				IF (@@FETCH_STATUS = -1) 
					BREAK

			set @V_CNT  = ISNULL(@V_CNT, 0)+ 1 
			print('rec_no')print(@v1_comp_code)print(@v_doctype)print(@v_pprocessdt)print(@v1_unit)print('recno_')
			
			SELECT @v_recptno  =  CAST( MAX(SUBSTRING(recptno, 5, 8))AS NUMERIC) + 1
			FROM  cir_rcphdr 
			WHERE comp_code  = @v1_comp_code AND doctype  = @v_doctype
			AND CONVERT(VARCHAR(23), recptdt) = CONVERT(VARCHAR(23), @v_pprocessdt) AND unit_code  = @v1_unit

print('so')
print(@v_recptno)

			
			IF ISNULL(@v_recptno, 0)= 0 BEGIN 
				SET @v_recptno  = @v1_branch + '-' + REPLACE(CONVERT(VARCHAR(5), GETDATE(), 2), '.', '')+ '0001' 
			END
			ELSE BEGIN 
				SET @v_recptno  = @v1_branch + '-' + dbo.fnPadLeft('0',8,@v_recptno) 
			END
			
			
			print(@v1_row_idno)print(@v1_comp_code)print(@v1_unit)print(@v1_ag_main_code)print(@v1_ag_sub_code)print(@v1_agency_name)print(@v1_region)print(@v1_city_code)
			print(@v1_dist_code)print(@v1_credit_days)print(@v1_amount)print(@v_recptno)print(@v_pprocessdt)print(@preason)print(@v_vchno)print(@v_remark)print(@pwcdp)print(@paccode)
			--select @v_repcode=max(rep_code) from rep_mast 

			/*--------------- this is for copy the transaction in another database --------------------------------
			DELETE FROM [utusan16].[dbo].[CIR_EXPENSES_DETAIL] WHERE COMP_CODE=@v1_comp_code and UNIT	=@v1_unit 
			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code
			
			DELETE FROM [utusan16].[dbo].[CIR_AG_CON_PER] WHERE COMP_CODE=@v1_comp_code and UNIT	=@v1_unit 
			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code
			
			DELETE FROM [utusan16].[dbo].[CIR_SUPPLY] WHERE COMP_CODE=@v1_comp_code and UNIT	=@v1_unit 
			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code
			
			DELETE FROM [utusan16].[dbo].[CIR_SUSPEND_TRAN] WHERE COMP_CODE=@v1_comp_code and UNIT	=@v1_unit 
			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code
			
			DELETE FROM [utusan16].[dbo].[CIR_BANK_GUARANTEE] WHERE COMP_CODE=@v1_comp_code and UNIT_CODE	=@v1_unit 
			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code
			
			DELETE FROM [utusan16].[dbo].[CIR_AGENCY_REMARK] WHERE COMP_CODE=@v1_comp_code and UNIT_CODE=@v1_unit 
			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code
			
			DELETE FROM [utusan16].[dbo].[CIR_AGENCY_CREDIT] WHERE COMP_CODE=@v1_comp_code and UNIT_CODE	=@v1_unit 
			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code
			
			DELETE FROM [utusan16].[dbo].[CIR_AGENCY_PAYMODE]  WHERE COMP_CODE=@v1_comp_code and UNIT_CODE	=@v1_unit 
			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code
				
			DELETE FROM [utusan16].[dbo].[CIR_AGENCY_FESTIVAL] WHERE COMP_CODE=@v1_comp_code and UNIT_CODE	=@v1_unit 
			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code
			
			DELETE FROM [utusan16].[dbo].[CIR_GMAP] WHERE COMP_CODE=@v1_comp_code and UNIT_CODE	=@v1_unit 
			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code
			
			DELETE FROM utusan16.DBO.CIR_AGOMAST where COMP_CODE=@v1_comp_code and UNIT_CODE	=@v1_unit 
			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code
				
			DELETE FROM utusan16.DBO.CIR_BILL_DET WHERE COMP_CODE=@v1_comp_code and UNIT_CODE	=@v1_unit 
			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code				
			DELETE FROM [utusan16].[dbo].[CIR_OUTMAST] WHERE COMP_CODE=@v1_comp_code and UNIT_CODE	=@v1_unit 
			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code
			DELETE FROM utusan16.DBO.CIR_BILL WHERE COMP_CODE=@v1_comp_code and UNIT_CODE	=@v1_unit 
			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code
			DELETE FROM [utusan16].[dbo].[CIR_RCPDET] WHERE COMP_CODE=@v1_comp_code and UNIT_CODE	=@v1_unit 
			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code
			DELETE FROM [utusan16].[dbo].[CIR_RCPHDR] WHERE COMP_CODE=@v1_comp_code and UNIT_CODE=@v1_unit 
			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code

			DELETE FROM [utusan16].[dbo].[CIR_AGMAST] WHERE COMP_CODE=@v1_comp_code and UNIT	=@v1_unit 
			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code
				
			INSERT INTO [utusan16].[dbo].[CIR_AGMAST]([COMP_CODE],[UNIT],[AGCD],[DPCD],[AG_NAME],[AG_NAME_OTH_LANG],[AG_TYPE],[AG_CLASS]
			,[EXECUTIVE_CODE],[SUPPLY_START_DT],[ADDR1],[ADDR2],[ADDR3],[CITY_CODE],[DIST_CODE],[STATE_CODE],[COUNTRY_CODE],[TEHSIL_TALUKA]
			,[STATION_CODE],[AREA_CODE],[PHONE_NO1],[PHONE_NO2],[MOBILE_NO1],[MOBILE_NO2],[EMAIL_ID],[SUSPEND],[SUSPEND_TYPE],[SUSPEND_DATE]
			,[TO_BILL],[BILL_AGCD],[BILL_DPCD],[PAYMODE],[CREDIT_DAYS],[PRINT_LABEL],[PIN_PACKET],[PIN_AGCD],[PIN_DPCD],[PIN_OPEN_INSIDE]
			,[LBL_LN1],[LBL_LN2],[LBL_LN3],[LBL_LN4],[LBL_LN5],[LBL_LN6],[LBL_LN7],[LBL_LN8],[LBL_ATR1],[LBL_ATR2],[LBL_ATR3],[LBL_ATR4]
			,[LBL_ATR5],[LBL_ATR6],[LBL_ATR7],[LBL_ATR8],[ALERT_TEXT],[USERID],[CREATION_datetime],[NAME_ON_LABEL],[PRINT_SEQ]
			,[ALERT_VALID_DATE],[PIN_CODE],[FREEZE_FLAG],[FAX_NO],[BRANCH_CODE],[UNSOLD_VALID_FLAG],[SECURITY_PER],[SEC_AMT_LIMT]
			,[SUPPLY_STOP_FLAG],[SUPPLY_STOP_PER],[ABC_CITYCODE],[UPDATED_BY],[UPDATED_DT],[SUPPLY_SUBAGENCY],[AGEING_TYPE],[LABEL_TYPE]
			,[H_ADDR1],[H_ADDR2],[H_ADDR3],[H_CITY_CODE],[H_TEHSIL_TALUKA],[H_DIST_CODE],[H_STATE_CODE],[H_COUNTRY_CODE],[H_PIN_CODE]
			,[H_PHONE_NO1],[H_PHONE_NO2],[H_MOBILE_NO1],[H_MOBILE_NO2],[H_EMAIL_ID],[BILL_REMARK],[SUP_BRANCH_CODE],[SUP_STATE_CODE]
			,[ACCOUNT_AGCD],[ACCOUNT_DPCD],[ROC_NO],[PAN_NO],[TAN_NO],[SER_TAX_NO],[OLD_AGENCY],[CLOSE_AGENCY_REASON],[SAP_ID],[FROM_BOOKLET]
			,[TO_BOOKLET],[DATA_POST])
			(SELECT [COMP_CODE],[UNIT],[AGCD],[DPCD],[AG_NAME],[AG_NAME_OTH_LANG],[AG_TYPE],[AG_CLASS]
			,[EXECUTIVE_CODE],[SUPPLY_START_DT],[ADDR1],[ADDR2],[ADDR3],[CITY_CODE],[DIST_CODE],[STATE_CODE],[COUNTRY_CODE],[TEHSIL_TALUKA]
			,[STATION_CODE],[AREA_CODE],[PHONE_NO1],[PHONE_NO2],[MOBILE_NO1],[MOBILE_NO2],[EMAIL_ID],[SUSPEND],[SUSPEND_TYPE],[SUSPEND_DATE]
			,[TO_BILL],[BILL_AGCD],[BILL_DPCD],[PAYMODE],[CREDIT_DAYS],[PRINT_LABEL],[PIN_PACKET],[PIN_AGCD],[PIN_DPCD],[PIN_OPEN_INSIDE]
			,[LBL_LN1],[LBL_LN2],[LBL_LN3],[LBL_LN4],[LBL_LN5],[LBL_LN6],[LBL_LN7],[LBL_LN8],[LBL_ATR1],[LBL_ATR2],[LBL_ATR3],[LBL_ATR4]
			,[LBL_ATR5],[LBL_ATR6],[LBL_ATR7],[LBL_ATR8],[ALERT_TEXT],[USERID],[CREATION_datetime],[NAME_ON_LABEL],[PRINT_SEQ]
			,[ALERT_VALID_DATE],[PIN_CODE],[FREEZE_FLAG],[FAX_NO],[BRANCH_CODE],[UNSOLD_VALID_FLAG],[SECURITY_PER],[SEC_AMT_LIMT]
			,[SUPPLY_STOP_FLAG],[SUPPLY_STOP_PER],[ABC_CITYCODE],[UPDATED_BY],[UPDATED_DT],[SUPPLY_SUBAGENCY],[AGEING_TYPE],[LABEL_TYPE]
			,[H_ADDR1],[H_ADDR2],[H_ADDR3],[H_CITY_CODE],[H_TEHSIL_TALUKA],[H_DIST_CODE],[H_STATE_CODE],[H_COUNTRY_CODE],[H_PIN_CODE]
			,[H_PHONE_NO1],[H_PHONE_NO2],[H_MOBILE_NO1],[H_MOBILE_NO2],[H_EMAIL_ID],[BILL_REMARK],[SUP_BRANCH_CODE],[SUP_STATE_CODE]
			,[ACCOUNT_AGCD],[ACCOUNT_DPCD],[ROC_NO],[PAN_NO],[TAN_NO],[SER_TAX_NO],[OLD_AGENCY],[CLOSE_AGENCY_REASON],[SAP_ID],[FROM_BOOKLET]
			,[TO_BOOKLET],[DATA_POST] FROM CIR_AGMAST WHERE COMP_CODE=@v1_comp_code and UNIT	=@v1_unit 
			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code)			
			INSERT INTO [utusan16].[dbo].[CIR_EXPENSES_DETAIL]
			([COMP_CODE],[UNIT],[AGCD],[DPCD],[EXP_TYPE_CODE],[EXP_TYPE_MODE]
			,[EXP_FREQUENCY],[EXP_AMOUNT],[FREEZE_FLAG],[USERID],[CREATION_DATE],[PUBL_CODE],[EDTN_CODE]
			,[SUPPLY_TYPE],[CN_THROUGH],[VALID_DAYS])
			(SELECT [COMP_CODE],[UNIT],[AGCD],[DPCD],[EXP_TYPE_CODE],[EXP_TYPE_MODE]
			,[EXP_FREQUENCY],[EXP_AMOUNT],[FREEZE_FLAG],[USERID],[CREATION_DATE],[PUBL_CODE],[EDTN_CODE],[SUPPLY_TYPE],[CN_THROUGH]
			,[VALID_DAYS] FROM CIR_EXPENSES_DETAIL WHERE COMP_CODE=@v1_comp_code and UNIT	=@v1_unit 
			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code)	
			
			INSERT INTO [utusan16].[dbo].[CIR_AG_CON_PER]([COMP_CODE],[UNIT],[AGCD],[DPCD],[NAME],[DESIG],[PER_ROLE],[DATE_OF_BIRTH]
			,[PHONE_NO1],[PHONE_NO2],[MOBILE_NO1],[MOBILE_NO2],[FAX_NO],[EMAIL_ID],[USERID],[CREATION_DATE],[SEQ_NO],[RACE_CODE]
			,[NEW_IC_NO],[OLD_IC_NO])
			(SELECT [COMP_CODE],[UNIT],[AGCD],[DPCD],[NAME],[DESIG],[PER_ROLE],[DATE_OF_BIRTH]
			,[PHONE_NO1],[PHONE_NO2],[MOBILE_NO1],[MOBILE_NO2],[FAX_NO],[EMAIL_ID],[USERID],[CREATION_DATE],[SEQ_NO],[RACE_CODE]
			,[NEW_IC_NO],[OLD_IC_NO] FROM CIR_AG_CON_PER WHERE COMP_CODE=@v1_comp_code and UNIT	=@v1_unit 
			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code )
			
			INSERT INTO [utusan16].[dbo].[CIR_SUPPLY]([COMP_CODE],[UNIT],[AGCD],[DPCD],[PUBL],[EDTN],[SUPPLY_FLAG],[SUPPLY_TYPE_CODE]
			,[BASE_SUPPLY],[SUPPLY_SUN],[SUPPLY_MON],[SUPPLY_TUE],[SUPPLY_WED],[SUPPLY_THU],[SUPPLY_FRI],[SUPPLY_SAT],[DEVATION_SUPPLY]
			,[COMM_FLAG],[COMM_CODE],[PACKET_SIZE],[ROUTE_CODE],[SUBROUTE_CODE],[SUB_SUBROUTE_CODE],[USERID],[CREATION_DATE],[SUPPLY_SPL1]
			,[SUPPLY_SPL2],[SURCH_CD],[SUB_EDTN],[LBL_PRINTNO],[UPDATED_BY],[UPDATED_DT],[BILLING_CYCLE],[INSERTION_FEE],[WASTE_CATG_CODE]
			,[SP_SUPPLY_MON1],[SP_SUPPLY_TUE1],[SP_SUPPLY_WED1],[SP_SUPPLY_THU1],[SP_SUPPLY_FRI1],[SP_SUPPLY_SAT1],[SP_SUPPLY_SUN1],[SP_SUPPLY_MON2]
			,[SP_SUPPLY_TUE2],[SP_SUPPLY_WED2],[SP_SUPPLY_THU2],[SP_SUPPLY_FRI2],[SP_SUPPLY_SAT2],[SP_SUPPLY_SUN2],[LATE_FEE],[INCENTIVE])
			(SELECT [COMP_CODE],[UNIT],[AGCD],[DPCD],[PUBL],[EDTN],[SUPPLY_FLAG],[SUPPLY_TYPE_CODE]
			,[BASE_SUPPLY],[SUPPLY_SUN],[SUPPLY_MON],[SUPPLY_TUE],[SUPPLY_WED],[SUPPLY_THU],[SUPPLY_FRI],[SUPPLY_SAT],[DEVATION_SUPPLY]
			,[COMM_FLAG],[COMM_CODE],[PACKET_SIZE],[ROUTE_CODE],[SUBROUTE_CODE],[SUB_SUBROUTE_CODE],[USERID],[CREATION_DATE],[SUPPLY_SPL1]
			,[SUPPLY_SPL2],[SURCH_CD],[SUB_EDTN],[LBL_PRINTNO],[UPDATED_BY],[UPDATED_DT],[BILLING_CYCLE],[INSERTION_FEE],[WASTE_CATG_CODE]
			,[SP_SUPPLY_MON1],[SP_SUPPLY_TUE1],[SP_SUPPLY_WED1],[SP_SUPPLY_THU1],[SP_SUPPLY_FRI1],[SP_SUPPLY_SAT1],[SP_SUPPLY_SUN1],[SP_SUPPLY_MON2]
			,[SP_SUPPLY_TUE2],[SP_SUPPLY_WED2],[SP_SUPPLY_THU2],[SP_SUPPLY_FRI2],[SP_SUPPLY_SAT2],[SP_SUPPLY_SUN2],[LATE_FEE],[INCENTIVE]
			FROM CIR_SUPPLY WHERE COMP_CODE=@v1_comp_code and UNIT	=@v1_unit 
			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code)
			
			INSERT INTO [utusan16].[dbo].[CIR_SUSPEND_TRAN]([COMP_CODE],[UNIT],[AGCD],[DPCD],[TRN_DATE],[SUSP],[SUSPTY],[SUSP_DATE]
			,[START_DATE],[USERID],[CREATION_DATE],[FREEZE_FLAG],[AGENCY_UNBLOCK_TYPE],[AGENCY_UNBLOCK_APPROVAL])
			(SELECT [COMP_CODE],[UNIT],[AGCD],[DPCD],[TRN_DATE],[SUSP],[SUSPTY],[SUSP_DATE]
			,[START_DATE],[USERID],[CREATION_DATE],[FREEZE_FLAG],[AGENCY_UNBLOCK_TYPE],[AGENCY_UNBLOCK_APPROVAL] FROM
			CIR_SUSPEND_TRAN WHERE COMP_CODE=@v1_comp_code and UNIT	=@v1_unit 
			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code)
			
			INSERT INTO [utusan16].[dbo].[CIR_BANK_GUARANTEE]([COMP_CODE],[UNIT_CODE],[AGCD],[DPCD],[BG_NO],[BG_AMT],[BG_DATE],[BG_VALID]
			,[BANK_DESC],[CREATED_BY],[CREATED_DT],[UPDATED_BY],[UPDATED_DT],[BG_TYPE],[BG_ATTACH])
			(SELECT [COMP_CODE],[UNIT_CODE],[AGCD],[DPCD],[BG_NO],[BG_AMT],[BG_DATE],[BG_VALID]
			,[BANK_DESC],[CREATED_BY],[CREATED_DT],[UPDATED_BY],[UPDATED_DT],[BG_TYPE],[BG_ATTACH] FROM CIR_BANK_GUARANTEE
			 WHERE COMP_CODE=@v1_comp_code and UNIT_CODE =@v1_unit and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code)
			
			INSERT INTO [utusan16].[dbo].[CIR_AGENCY_REMARK]([COMP_CODE],[UNIT_CODE],[AGCD],[DPCD],[RMRK_TYPE],[EFFECTIVE_FROM]
			,[RMRK],[CREATE_BY],[CREATED_DT],[UPDATED_BY],[UPDATED_DT],[EFFECTIVE_TILL])
			(SELECT [COMP_CODE],[UNIT_CODE],[AGCD],[DPCD],[RMRK_TYPE],[EFFECTIVE_FROM]
			,[RMRK],[CREATE_BY],[CREATED_DT],[UPDATED_BY],[UPDATED_DT],[EFFECTIVE_TILL] FROM CIR_AGENCY_REMARK 
			 WHERE COMP_CODE=@v1_comp_code and UNIT_CODE=@v1_unit and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code)
			
			INSERT INTO [utusan16].[dbo].[CIR_AGENCY_CREDIT] ([COMP_CODE],[UNIT_CODE],[AGCD],[DPCD],[PUBL_CODE],[CREDIT_DAYS],[CREDIT_LIMIT]
			,[CREATE_BY],[CREATED_DT],[UPDATED_BY],[UPDATED_DT] )
			(SELECT [COMP_CODE],[UNIT_CODE],[AGCD],[DPCD],[PUBL_CODE],[CREDIT_DAYS],[CREDIT_LIMIT]
			,[CREATE_BY],[CREATED_DT],[UPDATED_BY],[UPDATED_DT] FROM CIR_AGENCY_CREDIT 
			WHERE COMP_CODE=@v1_comp_code and UNIT_CODE	=@v1_unit and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code )
			
			INSERT INTO [utusan16].[dbo].[CIR_AGENCY_PAYMODE]([COMP_CODE],[UNIT_CODE],[AGCD],[DPCD],[PAYMODE],[PAYMODE_ACTIVE]
			,[CREATED_BY],[CREATED_DT],[UPDATED_BY],[UPDATED_DT],[BKUP_SNO],[BLOCK_BY_A_M])
			(SELECT [COMP_CODE],[UNIT_CODE],[AGCD],[DPCD],[PAYMODE],[PAYMODE_ACTIVE]
			,[CREATED_BY],[CREATED_DT],[UPDATED_BY],[UPDATED_DT],[BKUP_SNO],[BLOCK_BY_A_M] FROM CIR_AGENCY_PAYMODE
			WHERE COMP_CODE=@v1_comp_code and UNIT_CODE	=@v1_unit 	and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code)
			
			INSERT INTO [utusan16].[dbo].[CIR_AGENCY_FESTIVAL]([COMP_CODE],[UNIT_CODE],[AGCD],[DPCD],[FEST_CODE],[CREATE_BY]
			,[CREATED_DT],[UPDATED_BY],[UPDATED_DT])
			(SELECT [COMP_CODE],[UNIT_CODE],[AGCD],[DPCD],[FEST_CODE],[CREATE_BY] ,[CREATED_DT],[UPDATED_BY],[UPDATED_DT] 
			FROM CIR_AGENCY_FESTIVAL WHERE COMP_CODE=@v1_comp_code and UNIT_CODE=@v1_unit 
			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code )
			
			INSERT INTO [utusan16].[dbo].[CIR_GMAP]([CITY_NAME],[LATITUDE],[LONGITUDE],[AGCD],[DPCD],[UNIT_CODE],[COMP_CODE])
			(SELECT [CITY_NAME],[LATITUDE],[LONGITUDE],[AGCD],[DPCD],[UNIT_CODE],[COMP_CODE]
			FROM CIR_GMAP WHERE COMP_CODE=@v1_comp_code and UNIT_CODE	=@v1_unit 
			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code)

				------------ FIRST FOR OPENING BALANCE
				
				INSERT INTO utusan16.DBO.CIR_AGOMAST (COMP_CODE,UNIT_CODE,PUBL,AGCD,DPCD,FOR_MONTH,OPBAL,SEC_OPBAL,CREATION_DATE,CREATION_USERID,LAST_UPDATED_DATE,LAST_UPDATED_USERID)
				(SELECT COMP_CODE,UNIT_CODE,PUBL,AGCD,DPCD,FOR_MONTH,OPBAL,SEC_OPBAL,CREATION_DATE,CREATION_USERID,LAST_UPDATED_DATE,LAST_UPDATED_USERID FROM CIR_AGOMAST
				where COMP_CODE=@v1_comp_code and UNIT_CODE	=@v1_unit 
				and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code)
				
				-------------  FIRST FOR BILL					
					
				INSERT INTO [utusan16].[dbo].[CIR_BILL]([COMP_CODE],[UNIT_CODE],[BILLNO],[BILLDT],[AGCD],[DPCD],[PUBL],[BILL_COPY],[GROSS_AMOUNT]
				,[SUR_AMOUNT],[COMM_AMOUNT],[BILL_AMOUNT],[BILL_FRDT],[BILL_TODT],[BILL_FLAG],[BILL_REMARK],[USERID],[CREATION_DATE],[BILL_SEC_AMT]
				,[EXCOMM_RECPTNO],[EXCOMM_RECPTDT],[EXCOMM_AMT],[BRANCH_CODE],[SEC_PER_RATE],[ROUTE_CODE],[BILL_COUNT],[CN_COMM_COPY]
				,[TAX_RATE],[TAX_AMT],[ACCAGCD],[ACCDPCD],[TAX_CALC_TYPE])
				(SELECT [COMP_CODE],[UNIT_CODE],[BILLNO],[BILLDT],[AGCD],[DPCD],[PUBL],[BILL_COPY],[GROSS_AMOUNT]
				,[SUR_AMOUNT],[COMM_AMOUNT],[BILL_AMOUNT],[BILL_FRDT],[BILL_TODT],[BILL_FLAG],[BILL_REMARK],[USERID],[CREATION_DATE],[BILL_SEC_AMT]
				,[EXCOMM_RECPTNO],[EXCOMM_RECPTDT],[EXCOMM_AMT],[BRANCH_CODE],[SEC_PER_RATE],[ROUTE_CODE],[BILL_COUNT],[CN_COMM_COPY]
				,[TAX_RATE],[TAX_AMT],[ACCAGCD],[ACCDPCD],[TAX_CALC_TYPE] FROM CIR_BILL 
				WHERE COMP_CODE=@v1_comp_code and UNIT_CODE	=@v1_unit 
				and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code)
											
				INSERT INTO [utusan16].[dbo].[CIR_BILL_DET]([COMP_CODE],[UNIT_CODE],[BILLNO],[BILLDT],[AGCD],[DPCD],[PUBL],[EDTN],[BILL_COPY]
				,[COPY_RATE],[COMM_FLAG],[COMM_RATE],[SUR_RATE],[GROSS_AMOUNT],[BILL_AMOUNT],[FROMDT],[TODT],[COAG],[CODP],[REMARKS],[USERID]
				,[CREATION_DATE],[COMM_AMT],[SUR_AMT],[BILL_FLAG],[BRANCH_CODE],[COMM_TYPE],[ACCAGCD],[ACCDPCD])
				(SELECT [COMP_CODE],[UNIT_CODE],[BILLNO],[BILLDT],[AGCD],[DPCD],[PUBL],[EDTN],[BILL_COPY]
				,[COPY_RATE],[COMM_FLAG],[COMM_RATE],[SUR_RATE],[GROSS_AMOUNT],[BILL_AMOUNT],[FROMDT],[TODT],[COAG],[CODP],[REMARKS],[USERID]
				,[CREATION_DATE],[COMM_AMT],[SUR_AMT],[BILL_FLAG],[BRANCH_CODE],[COMM_TYPE],[ACCAGCD],[ACCDPCD] FROM CIR_BILL_DET
				WHERE COMP_CODE=@v1_comp_code and UNIT_CODE	=@v1_unit 
				and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code)
				
				INSERT INTO [utusan16].[dbo].[CIR_RCPHDR]([COMP_CODE],[UNIT_CODE],[DOCTYPE],[AGCD],[DPCD],[RECPTNO],[RECPTDT],[CHNO],[CHDT]
				,[CHBANK],[AMOUNT],[OTH_AMOUNT],[CCDP],[CCDS],[RCDP],[RCDS],[OCDP],[OCDS],[REASON],[REMARK],[ACHD],[VOUCHERNO],[VOUCHERDT]
				,[VCHTYPE],[PUBL],[RECEIVED_FROM],[TDSRATE],[TDSAMT],[STAXRATE],[STAXAMT],[STATUS],[REF_RECPTNO],[REF_RECPTDT],[REF_AMOUNT]
				,[REF_DOCTYPE],[CANCEL_USER],[CANCEL_DATE],[CANCEL_REMARK],[USERID],[CREATION_DATE],[BRANCH_CODE],[PROV_REC_NO],[PROV_REC_DT]
				,[bkup_sno],[REMARK_OTH],[TRF_NOTE_TYPE],[MANNUALRECPTNO])
				(SELECT [COMP_CODE],[UNIT_CODE],[DOCTYPE],[AGCD],[DPCD],[RECPTNO],[RECPTDT],[CHNO],[CHDT]
				,[CHBANK],[AMOUNT],[OTH_AMOUNT],[CCDP],[CCDS],[RCDP],[RCDS],[OCDP],[OCDS],[REASON],[REMARK],[ACHD],[VOUCHERNO],[VOUCHERDT]
				,[VCHTYPE],[PUBL],[RECEIVED_FROM],[TDSRATE],[TDSAMT],[STAXRATE],[STAXAMT],[STATUS],[REF_RECPTNO],[REF_RECPTDT],[REF_AMOUNT]
				,[REF_DOCTYPE],[CANCEL_USER],[CANCEL_DATE],[CANCEL_REMARK],[USERID],[CREATION_DATE],[BRANCH_CODE],[PROV_REC_NO],[PROV_REC_DT]
				,[bkup_sno],[REMARK_OTH],[TRF_NOTE_TYPE],[MANNUALRECPTNO] FROM CIR_RCPHDR 
				 WHERE COMP_CODE=@v1_comp_code and UNIT_CODE=@v1_unit and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code )
				 
				 INSERT INTO [utusan16].[dbo].[CIR_RCPDET]([COMP_CODE],[UNIT_CODE],[AGCD],[DPCD],[DOCTYP],[BILLNO],[BILLDT],[RECPTNO]
				,[RECPTDT],[PAYFOR],[ACHD],[PUBL],[CHNO],[CHBNK],[CHDT],[AMOUNT],[REASON],[REMARK],[VOUCHERNO],[VOUCHERDT],[TDS],[STAX]
				,[STATUS],[USRID],[CREATION_DATE],[BRANCH_CODE],[bkup_sno])
				(SELECT [COMP_CODE],[UNIT_CODE],[AGCD],[DPCD],[DOCTYP],[BILLNO],[BILLDT],[RECPTNO]
				,[RECPTDT],[PAYFOR],[ACHD],[PUBL],[CHNO],[CHBNK],[CHDT],[AMOUNT],[REASON],[REMARK],[VOUCHERNO],[VOUCHERDT],[TDS],[STAX]
				,[STATUS],[USRID],[CREATION_DATE],[BRANCH_CODE],[bkup_sno] FROM CIR_RCPDET
				 WHERE COMP_CODE=@v1_comp_code and UNIT_CODE=@v1_unit and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code)
				 
				INSERT INTO [utusan16].[dbo].[CIR_OUTMAST]([COMP_CODE],[UNIT_CODE],[AGCD],[DPCD],[DOCTYP],[BILLNO],[BILLDT],[RECPTNO]
				,[RECPTDT],[ACHD],[PUBL],[CHNO],[CHBNK],[CHDT],[AMOUNT],[REASON],[REMARK],[VOUCHERNO],[VOUCHERDT],[BALANCE],[TDS],[STAX]
				,[STATUS],[CANCEL_USERID],[CANCEL_DT],[CANCEL_REMARK],[USRID],[CREATION_DATE],[BILL_SEC_AMT],[BRANCH_CODE],[bkup_sno]
				,[DISPUTE_FLAG],[DISPUTE_USER_CODE],[DISPUTE_DT],[DISPUTE_RMRK])
				(SELECT [COMP_CODE],[UNIT_CODE],[AGCD],[DPCD],[DOCTYP],[BILLNO],[BILLDT],[RECPTNO]
				,[RECPTDT],[ACHD],[PUBL],[CHNO],[CHBNK],[CHDT],[AMOUNT],[REASON],[REMARK],[VOUCHERNO],[VOUCHERDT],[BALANCE],[TDS],[STAX]
				,[STATUS],[CANCEL_USERID],[CANCEL_DT],[CANCEL_REMARK],[USRID],[CREATION_DATE],[BILL_SEC_AMT],[BRANCH_CODE],[bkup_sno]
				,[DISPUTE_FLAG],[DISPUTE_USER_CODE],[DISPUTE_DT],[DISPUTE_RMRK] FROM CIR_OUTMAST  
				WHERE COMP_CODE=@v1_comp_code and UNIT_CODE	=@v1_unit and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code )
				
			
			--------------- this is for copy the transaction in another database --------------------------------*/
print('x_test')print(@v1_unit)print(@v_doctype)print(@v_recptno)print(@v_pprocessdt)print('a_t')
print(cast (@v_recptno as varchar) +'_start')
			insert into cir_rcphdr(comp_code,unit_code,agcd,dpcd,doctype,recptno,recptdt,amount,reason,remark,
								   achd,voucherno,voucherdt,userid,creation_date,branch_code)
			VALUES (@v1_comp_code,@v1_unit,@v1_ag_main_code,@v1_ag_sub_code,@v_doctype,@v_recptno,@v_pprocessdt,@v1_amount,@preason,@v_remark
					,'NM',@v_recptno,@v_pprocessdt,@puserid,getdate(),@v1_branch)  
print(cast (@v_recptno as varchar) +'_start_2')			
			insert into cir_rcpdet(comp_code,unit_code,agcd,dpcd,doctyp,publ,recptno,recptdt,payfor,achd,amount,
								  reason,remark,voucherno,voucherdt,usrid,creation_date,branch_code)
			VALUES (@v1_comp_code,@v1_unit,@v1_ag_main_code,@v1_ag_sub_code,@v_doctype,null,@v_recptno,@v_pprocessdt,@v1_unit,'NM',@v1_amount
			,@preason,@v_remark,@v_recptno,@v_pprocessdt,@puserid,getdate(),@v1_branch)  
print(cast (@v_recptno as varchar) +'_start_3')				
			/*INSERT INTO  ad_outstand ( comp_code ,userid , unit , doctype , recptno ,recptdt , reason , received_region , voucherno ,amount , 
									agcode , remark , voucherdate , ag_main_code , ag_sub_code )  
					VALUES ( @v1_comp_code , @puserid ,@v1_unit , @v_doctype ,@v_recptno ,@v_pprocessdt , @preason , @v1_region , @v_vchno , 0 , 
							@v1_ag_main_code+ @v1_ag_sub_code , @v_remark , @v_pprocessdt , @v1_ag_main_code , @v1_ag_sub_code )  
			*/
			insert into cir_outmast(comp_code,unit_code,agcd,dpcd,doctyp,publ,recptno,recptdt,achd,amount,
									reason,remark,voucherno,voucherdt,usrid,creation_date,branch_code)
			values(@v1_comp_code, @v1_unit,@v1_ag_main_code, @v1_ag_sub_code,@v_doctype,null,@v_recptno ,@v_pprocessdt,'NM',ABS(@v1_amount),
					@preason,@v_remark,@v_recptno ,@v_pprocessdt,@puserid,getdate(),@v1_branch)                               
print(cast (@v_recptno as varchar) +'_end')			
			DECLARE c2 cursor LOCAL FOR 
					SELECT ROW_IDNO, COMP_CODE, UNIT,BRANCH_CODE, DOCTYPE, DOCNO, DOCDT, PRIPUB, AG_MAIN_CODE, AG_SUB_CODE, CHNO, CHDT, BANK, AMOUNT, REASON, 
					VOUCHERNO, VOUCHERDATE, RECEIPT_NO, PRIPROCTG, REF_RECPTNO, REF_RECPTDT, REF_AMOUNT, REF_DOCTYP, RECEIVED_REGION, REMARK, 
					RETAINER_CODE, EXEC_CODE, AD_TYPE, PREV_CIOID FROM  CIR_WRITEOFF_PROCESS_DATA 
					WHERE row_idno  = @prowidno AND	comp_code  = @v1_comp_code AND	branch_code  = @v1_unit
					AND	ag_main_code  = @v1_ag_main_code AND	ag_sub_code  = @v1_ag_sub_code
			
			OPEN c2 
				fetch NEXT FROM c2 INTO @v2_ROW_IDNO, @v2_COMP_CODE , @v2_UNIT,@v2_BRANCH , @v2_DOCTYPE , @v2_DOCNO , @v2_DOCDT , @v2_PRIPUB , @v2_AG_MAIN_CODE , @v2_AG_SUB_CODE , @v2_CHNO , @v2_CHDT , @v2_BANK , @v2_AMOUNT , @v2_REASON , @v2_VOUCHERNO , @v2_VOUCHERDATE , @v2_RECEIPT_NO , @v2_PRIPROCTG , @v2_REF_RECPTNO , @v2_REF_RECPTDT , @v2_REF_AMOUNT , @v2_REF_DOCTYP , @v2_RECEIVED_REGION , @v2_REMARK , @v2_RETAINER_CODE , @v2_EXEC_CODE , @v2_AD_TYPE , @v2_PREV_CIOID 
				WHILE (@@FETCH_STATUS = 0) 
				BEGIN	
					IF (@@FETCH_STATUS = -1) 
						BREAK
print('C@')
					DECLARE c3 cursor LOCAL FOR 
					SELECT UNIT_code, DOCTYP, PUBL, BRANCH_CODE, BILLNO, BILLDT, RECPTNO, RECPTDT
					, CHNO, CHDT, CHBNK, AMOUNT, REASON, AGCD, DPCD, VOUCHERNO,VOUCHERDT, BALANCE, TDS, 
					COMP_CODE, USRID, CREATION_DATE, STAX, REMARK FROM  cir_outmast
					WHERE comp_code  = @v1_comp_code AND	unit_code  = @v1_unit AND	doctyp  = @v2_doctype 
					AND	recptno  = @v2_docno AND	recptdt  = @v2_docdt 
					AND	agcd  = @v2_ag_main_code AND	dpcd  = @v2_ag_sub_code AND	billno  is null
			
					OPEN c3 
					
					fetch NEXT FROM c3 INTO @v3_UNIT,@v3_DOCTYPE,@v3_pripub,@v3_BRANCH,@v3_BILLNO,@v3_BILLDT,@v3_RECPTNO,@v3_RECPTDT,@v3_CHNO,@v3_CHDT,@v3_BANK,@v3_AMOUNT,@v3_REASON,@v3_AG_MAIN_CODE,@v3_AG_SUB_CODE,@v3_VOUCHERNO,@v3_VOUCHERDATE,@v3_BALANCE,@v3_TDS,@v3_COMP_CODE,@v3_USERID,@v3_CREATION_DATETIME,@v3_ST,@v3_REMARK
					WHILE (@@FETCH_STATUS = 0) 
					BEGIN
					print('****')
					print('X1')print(@@cursor_rows)
					print(@v_doctype)
					print(@v_recptno)print(@v_pprocessdt)print(@v3_RECPTNO)print(@v3_RECPTDT)
					
						INSERT INTO  cir_outmast( comp_code , UNIT_CODE	, doctyp , reason , BRANCH_CODE , billno , billdt , recptno , recptdt , chno , chdt , 
												CHBNK ,voucherno , voucherdt , amount , usrid , AGCD , DPCD , remark )  
						VALUES(@v1_comp_code,@v1_unit,@v3_DOCTYPE,@v3_reason,@v1_branch,@v_recptno,@v_pprocessdt,@v3_RECPTNO,@v3_RECPTDT,@v3_chno ,@v3_chdt
							 , @v3_bank , @v3_voucherno , @v3_voucherdate ,@v2_amount , @puserid ,@v1_ag_main_code , @v1_ag_sub_code , null ) 
							  
				print('update_')print(@v1_comp_code)print(@v1_unit)print(@v_doctype)print(@v3_recptdt)print(@v3_recptno)print(@v1_ag_main_code)print(@v1_ag_sub_code)print('upppppppppppp;')
				
						UPDATE  CIR_OUTMAST SET	amount = 0 WHERE  comp_code  =@v1_comp_code AND	UNIT_CODE  = @v1_unit
						AND	doctyp  = @v3_DOCTYPE AND	recptdt  = @v3_recptdt AND	recptno  = @v3_recptno AND	AGCD	  = @v1_ag_main_code
						AND	DPCD  = @v1_ag_sub_code AND	billno  is null 
				 
						INSERT INTO  CIR_RCPDET( comp_code , UNIT_CODE	, doctyp , reason , BRANCH_CODE , billno , billdt , recptno , recptdt , chno , chdt , 
												CHBNK ,voucherno , voucherdt , amount , usrid , AGCD , DPCD , remark )  
						VALUES(@v1_comp_code,@v1_unit,@v3_DOCTYPE,@v3_reason,@v1_branch,@v_recptno,@v_pprocessdt,@v3_RECPTNO,@v3_RECPTDT,@v3_chno ,@v3_chdt
							 , @v3_bank , @v3_voucherno , @v3_voucherdate ,@v2_amount , @puserid ,@v1_ag_main_code , @v1_ag_sub_code , null )  
			print('DDDDDD')
				
				fetch NEXT FROM c3 INTO @v3_UNIT,@v3_DOCTYPE,@v3_pripub,@v3_BRANCH,@v3_BILLNO,@v3_BILLDT,@v3_RECPTNO,@v3_RECPTDT,@v3_CHNO,@v3_CHDT,@v3_BANK,@v3_AMOUNT,@v3_REASON,@v3_AG_MAIN_CODE,@v3_AG_SUB_CODE,@v3_VOUCHERNO,@v3_VOUCHERDATE,@v3_BALANCE,@v3_TDS,@v3_COMP_CODE,@v3_USERID,@v3_CREATION_DATETIME,@v3_ST,@v3_REMARK
				END
				close c3
			DEALLOCATE c3				
			
			fetch NEXT FROM c2 INTO @v2_ROW_IDNO, @v2_COMP_CODE , @v2_UNIT,@v2_BRANCH , @v2_DOCTYPE , @v2_DOCNO , @v2_DOCDT , @v2_PRIPUB , @v2_AG_MAIN_CODE , @v2_AG_SUB_CODE , @v2_CHNO , @v2_CHDT , @v2_BANK , @v2_AMOUNT , @v2_REASON , @v2_VOUCHERNO , @v2_VOUCHERDATE , @v2_RECEIPT_NO , @v2_PRIPROCTG , @v2_REF_RECPTNO , @v2_REF_RECPTDT , @v2_REF_AMOUNT , @v2_REF_DOCTYP , @v2_RECEIVED_REGION , @v2_REMARK , @v2_RETAINER_CODE , @v2_EXEC_CODE , @v2_AD_TYPE , @v2_PREV_CIOID 
			END --) 			
			close c2
			DEALLOCATE c2			
			
		FETCH NEXT FROM C1 INTO @v1_row_idno,@v1_comp_code,@v1_unit,@v1_branch,@v1_ag_main_code,@v1_ag_sub_code,@v1_agency_name,@v1_region,@v1_city_code,@v1_dist_code,@v1_credit_days,@v1_amount
		end
close c1;
		
		
		-- IMPLICIT_TRANSACTIONS is set to OFF
 DEALLOCATE c1



		SET NOCOUNT OFF

	END


//////////////////////////////




ALTER PROCEDURE [dbo].[cir_writeoff_credit_note]
	@pcomp_code                               VARCHAR(4000) ,	--company code	
	@punit_code                               VARCHAR(4000) ,	--unit code
	@pbranch_code                               VARCHAR(4000) ,	--branch code
	@pjv_type                                 VARCHAR(4000) ,	--Debit/Credit	
	@preason                                  VARCHAR(4000) ,	--for reason code	
	@pfrdt                                    VARCHAR(4000) ,	--for from date	
	@ptodt                                    VARCHAR(4000) ,	--for till date
	@pwcdp                                    VARCHAR(4000) ,	--for writeoff account head	
	@paccode                                  VARCHAR(4000) ,	--for other account head	
	@pamountupto                              FLOAT ,	        --for amount upto	
	@puserid                                  VARCHAR(4000) ,	--for create userid	
	@pprocessdt                               VARCHAR(4000) ,	--process date	
	@prowidno                                 int ,	            --for unique ID number	
	@pdateformat                              VARCHAR(4000) ,	--for date format	
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS 
	BEGIN
		SET NOCOUNT ON		
		set @pdateformat='mm/dd/yyyy'
		-- cursor c1----------
		DECLARE @v1_row_idno as int
		DECLARE @v1_comp_code VARCHAR(50)
		DECLARE @v1_unit VARCHAR(50)
		DECLARE @v1_branch VARCHAR(50)
		DECLARE @v1_ag_main_code VARCHAR(50)
		DECLARE @v1_ag_sub_code VARCHAR(50)
		DECLARE @v1_agency_name VARCHAR(500)
		DECLARE @v1_region VARCHAR(50)
		DECLARE @v1_city_code VARCHAR(50)
		DECLARE @v1_dist_code VARCHAR(50)
		DECLARE @v1_credit_days as int
		DECLARE @v1_amount as float
		-- cursor c1 --- @v1_row_idno,@comp_code,@unit,@ag_main_code,@ag_sub_code,@agency_name,@region,@city_code,@dist_code,@credit_days,@amount
		-- cursor c2--
		declare @v2_ROW_IDNO int
		declare @v2_COMP_CODE varchar(50)
		declare @v2_UNIT  varchar(50)
		declare @v2_BRANCH  varchar(50)
		declare @v2_DOCTYPE  varchar(50)
		declare @v2_DOCNO  varchar(50)
		declare @v2_DOCDT datetime
		declare @v2_PRIPUB  varchar(50)
		declare @v2_AG_MAIN_CODE  varchar(50)
		declare @v2_AG_SUB_CODE  varchar(50)
		declare @v2_CHNO  varchar(50)
		declare @v2_CHDT datetime
		declare @v2_BANK  varchar(100)
		declare @v2_AMOUNT decimal(15,2)
		declare @v2_REASON  varchar(50)
		declare @v2_VOUCHERNO  varchar(50)
		declare @v2_VOUCHERDATE datetime
		declare @v2_RECEIPT_NO  varchar(50)
		declare @v2_PRIPROCTG  varchar(50)
		declare @v2_REF_RECPTNO  varchar(50)
		declare @v2_REF_RECPTDT datetime
		declare @v2_REF_AMOUNT decimal(15,2)
		declare @v2_REF_DOCTYP  varchar(50)
		declare @v2_RECEIVED_REGION  varchar(50)
		declare @v2_REMARK  varchar(2000)
		declare @v2_RETAINER_CODE  varchar(50)
		declare @v2_EXEC_CODE  varchar(50)
		declare @v2_AD_TYPE  varchar(50)
		declare @v2_PREV_CIOID  varchar(50)
		declare @v2_SESS_ID int
		--cursor c2--  @v2_ROW_IDNO, @v2_COMP_CODE , @v2_UNIT , @v2_DOCTYPE , @v2_DOCNO , @v2_DOCDT , @v2_PRIPUB , @v2_AG_MAIN_CODE , @v2_AG_SUB_CODE , @v2_CHNO , @v2_CHDT , @v2_BANK , @v2_AMOUNT , @v2_REASON , @v2_VOUCHERNO , @v2_VOUCHERDATE , @v2_RECEIPT_NO , @v2_PRIPROCTG , @v2_REF_RECPTNO , @v2_REF_RECPTDT , @v2_REF_AMOUNT , @v2_REF_DOCTYP , @v2_RECEIVED_REGION , @v2_REMARK , @v2_RETAINER_CODE , @v2_EXEC_CODE , @v2_AD_TYPE , @v2_PREV_CIOID , @v2_SESS_ID
		-- cursor c3 --
		declare @v3_UNIT    varchar(50)
		declare @v3_BRANCH  varchar(50)
		declare @v3_AGCODE    varchar(50)
		declare @v3_DOCTYPE    varchar(50)
		declare @v3_ROIDNUM    varchar(50)
		declare @v3_PRIPUB    varchar(50)
		declare @v3_BKFOR    varchar(50)
		declare @v3_BILLNO    varchar(50)
		declare @v3_BILLDT  datetime
		declare @v3_RECPTNO    varchar(50)
		declare @v3_RECPTDT  datetime
		declare @v3_CHNO    varchar(50)
		declare @v3_CHDT datetime
		declare @v3_BANK    varchar(100)
		declare @v3_AMOUNT  decimal(15,2)
		declare @v3_REASON    varchar(50)
		declare @v3_BK_AGCODE    varchar(50)
		declare @v3_BK_AGSUBCODE    varchar(50)
		declare @v3_VOUCHERNO    varchar(50)
		declare @v3_SHRTFRDT    datetime
		declare @v3_BALANCE  decimal(15,2)
		declare @v3_CENDES    varchar(50)
		declare @v3_NOOFINSRT    varchar(50)
		declare @v3_TDS  decimal(15,2)
		declare @v3_RECEIPT_NO    varchar(50)
		declare @v3_BK_CHNO    varchar(50)
		declare @v3_MRVDATE  datetime
		declare @v3_PRIPROCTG    varchar(50)
		declare @v3_INSDATE  datetime
		declare @v3_REF_RECPTNO    varchar(50)
		declare @v3_REF_RECPTDT  datetime
		declare @v3_REF_AMOUNT  decimal(15,2)
		declare @v3_REF_DOCTYP    varchar(50)
		declare @v3_ROWIDENTIFIER    varchar(50)
		declare @v3_BKUP_SNO    varchar(50)
		declare @v3_COMP_CODE    varchar(50)
		declare @v3_USERID    varchar(50)
		declare @v3_CREATION_DATETIME  datetime
		declare @v3_RECEIVED_REGION    varchar(50)
		declare @v3_VOUCHERDATE  datetime
		declare @v3_ST  decimal(15,2)
		declare @v3_AG_MAIN_CODE    varchar(50)
		declare @v3_AG_SUB_CODE    varchar(50)
		declare @v3_REMARK    varchar(2000)
		declare @v3_RETAINER_CODE    varchar(50)
		declare @v3_EXEC_CODE    varchar(50)
		declare @v3_AD_TYPE    varchar(50)
		declare @v3_PREV_CIOID   varchar(50)
		-- cursor c3--  @v3_UNIT   ,@v3_AGCODE   ,@v3_DOCTYPE   ,@v3_ROIDNUM   ,@v3_PRIPUB   ,@v3_BKFOR   ,@v3_BILLNO   ,@v3_BILLDT   ,@v3_RECPTNO   ,@v3_RECPTDT   ,@v3_CHNO   ,@v3_CHDT   ,@v3_BANK   ,@v3_AMOUNT   ,@v3_REASON   ,@v3_BK_AGCODE   ,@v3_BK_AGSUBCODE   ,@v3_VOUCHERNO   ,@v3_SHRTFRDT   ,@v3_BALANCE   ,@v3_CENDES   ,@v3_NOOFINSRT   ,@v3_TDS   ,@v3_RECEIPT_NO   ,@v3_BK_CHNO   ,@v3_MRVDATE   ,@v3_PRIPROCTG   ,@v3_INSDATE   ,@v3_REF_RECPTNO   ,@v3_REF_RECPTDT   ,@v3_REF_AMOUNT   ,@v3_REF_DOCTYP   ,@v3_ROWIDENTIFIER   ,@v3_BKUP_SNO   ,@v3_COMP_CODE   ,@v3_USERID   ,@v3_CREATION_DATETIME   ,@v3_RECEIVED_REGION   ,@v3_VOUCHERDATE   ,@v3_ST   ,@v3_AG_MAIN_CODE   ,@v3_AG_SUB_CODE   ,@v3_REMARK   ,@v3_RETAINER_CODE   ,@v3_EXEC_CODE   ,@v3_AD_TYPE   ,@v3_PREV_CIOID
		
		DECLARE @v_recptno                                VARCHAR(50)                     
				SET @v_recptno = 1 
		DECLARE @v_vchno                                  VARCHAR(50)                     
				SET @v_vchno = 1 
		DECLARE @v_doctype                                VARCHAR(10) 
		DECLARE @v_remark                                 VARCHAR(500) 
		DECLARE @vfrdt                                    DATETIME 
		DECLARE @vtodt                                    DATETIME 
		DECLARE @v_pprocessdt                             DATETIME 
		DECLARE @V_CNT                                    FLOAT                           
				SET @V_CNT = 0 
		DECLARE @vquery                                   FLOAT 
		DECLARE @v_prefix                                 VARCHAR(30) 
		declare @v_repcode								varchar(30)
		declare @v_branchnm		varchar(20)		
		
		SELECT @vfrdt  = dbo.convert_user_date('/',@pfrdt,@pdateformat)--CONVERT(DATETIME, @pfrdt)
		SELECT @vtodt  = dbo.convert_user_date('/',@ptodt,@pdateformat)--CONVERT(DATETIME, @ptodt)
		SELECT @v_pprocessdt  =dbo.convert_user_date('/',@pprocessdt,@pdateformat)-- CONVERT(DATETIME, @pprocessdt)
		SELECT @v_remark  = 'Debit Amount Write Off' 
		SELECT @v_doctype  = 'CN' 


		DECLARE c1 cursor LOCAL FOR 
				SELECT DISTINCT a.row_idno row_idno, a.comp_code comp_code, a.branch_code unit,a.unit branch_code, a.ag_main_code ag_main_code, 
				a.ag_sub_code ag_sub_code,b.ag_name agency_name, '' region, b.City_Code city_code, b.Dist_Code dist_code
				, b.Credit_Days credit_days, ABS(SUM(CONVERT(FLOAT, a.amount))) amount
				FROM  CIR_WRITEOFF_PROCESS_DATA a,cir_agmast b 
				WHERE	 a.row_idno  = @prowidno AND a.comp_code = b.Comp_Code AND a.ag_main_code = b.agcd AND a.ag_sub_code = b.dpcd
				GROUP BY a.row_idno, a.comp_code, a.unit,a.branch_code, a.ag_main_code, a.ag_sub_code, b.ag_Name, b.City_Code, b.Dist_Code, b.Credit_Days
		
		OPEN C1			
			FETCH NEXT FROM C1 INTO @v1_row_idno,@v1_comp_code,@v1_unit,@v1_branch,@v1_ag_main_code,@v1_ag_sub_code,@v1_agency_name,@v1_region,@v1_city_code,@v1_dist_code,@v1_credit_days,@v1_amount
			WHILE (@@FETCH_STATUS = 0) 
			BEGIN
				print(@@FETCH_STATUS)
				IF (@@FETCH_STATUS = -1) 
					BREAK
			
			set @V_CNT  = ISNULL(@V_CNT, 0)+ 1 
			
			SELECT @v_recptno  =  CAST( MAX(SUBSTRING(recptno, 5, 8))AS NUMERIC) + 1
			FROM  cir_rcphdr 
			WHERE comp_code  = @v1_comp_code AND doctype  = @v_doctype
			AND CONVERT(VARCHAR(23), recptdt) = CONVERT(VARCHAR(23), @v_pprocessdt) AND unit_code  = @v1_branch
			
			IF ISNULL(@v_recptno, 0)= 0 BEGIN 
				SET @v_recptno  = @v1_branch + '-' + REPLACE(CONVERT(VARCHAR(5), GETDATE(), 2), '.', '')+ '0001' 
			END
			ELSE BEGIN 
				SET @v_recptno  = @v1_branch + '-' + dbo.fnPadLeft('0',8,@v_recptno) 
			END
			
			/*--------------- this is for copy the transaction in another database --------------------------------
--			DELETE FROM [utusan16].[dbo].[CIR_EXPENSES_DETAIL] WHERE COMP_CODE=@v1_comp_code and UNIT	=@v1_unit 
--			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code
			
			INSERT INTO [utusan16].[dbo].[CIR_EXPENSES_DETAIL]
			([COMP_CODE],[UNIT],[AGCD],[DPCD],[EXP_TYPE_CODE],[EXP_TYPE_MODE]
			,[EXP_FREQUENCY],[EXP_AMOUNT],[FREEZE_FLAG],[USERID],[CREATION_DATE],[PUBL_CODE],[EDTN_CODE]
			,[SUPPLY_TYPE],[CN_THROUGH],[VALID_DAYS])
			(SELECT [COMP_CODE],[UNIT],[AGCD],[DPCD],[EXP_TYPE_CODE],[EXP_TYPE_MODE]
			,[EXP_FREQUENCY],[EXP_AMOUNT],[FREEZE_FLAG],[USERID],[CREATION_DATE],[PUBL_CODE],[EDTN_CODE],[SUPPLY_TYPE],[CN_THROUGH]
			,[VALID_DAYS] FROM CIR_EXPENSES_DETAIL WHERE COMP_CODE=@v1_comp_code and UNIT	=@v1_unit 
			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code)
			
			--DELETE FROM [utusan16].[dbo].[CIR_AG_CON_PER] WHERE COMP_CODE=@v1_comp_code and UNIT	=@v1_unit 
			--and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code

			DELETE FROM [utusan16].[dbo].[CIR_EXPENSES_DETAIL] WHERE COMP_CODE=@v1_comp_code and UNIT	=@v1_unit 
			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code
			
			DELETE FROM [utusan16].[dbo].[CIR_AG_CON_PER] WHERE COMP_CODE=@v1_comp_code and UNIT	=@v1_unit 
			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code
			
			DELETE FROM [utusan16].[dbo].[CIR_SUPPLY] WHERE COMP_CODE=@v1_comp_code and UNIT	=@v1_unit 
			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code
			
			DELETE FROM [utusan16].[dbo].[CIR_SUSPEND_TRAN] WHERE COMP_CODE=@v1_comp_code and UNIT	=@v1_unit 
			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code
			
			DELETE FROM [utusan16].[dbo].[CIR_BANK_GUARANTEE] WHERE COMP_CODE=@v1_comp_code and UNIT_CODE	=@v1_unit 
			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code
			
			DELETE FROM [utusan16].[dbo].[CIR_AGENCY_REMARK] WHERE COMP_CODE=@v1_comp_code and UNIT_CODE=@v1_unit 
			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code
			
			DELETE FROM [utusan16].[dbo].[CIR_AGENCY_CREDIT] WHERE COMP_CODE=@v1_comp_code and UNIT_CODE	=@v1_unit 
			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code
			
			DELETE FROM [utusan16].[dbo].[CIR_AGENCY_PAYMODE]  WHERE COMP_CODE=@v1_comp_code and UNIT_CODE	=@v1_unit 
			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code
				
			DELETE FROM [utusan16].[dbo].[CIR_AGENCY_FESTIVAL] WHERE COMP_CODE=@v1_comp_code and UNIT_CODE	=@v1_unit 
			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code
			
			DELETE FROM [utusan16].[dbo].[CIR_GMAP] WHERE COMP_CODE=@v1_comp_code and UNIT_CODE	=@v1_unit 
			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code
			
			DELETE FROM utusan16.DBO.CIR_AGOMAST where COMP_CODE=@v1_comp_code and UNIT_CODE	=@v1_unit 
			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code
				
			DELETE FROM utusan16.DBO.CIR_BILL_DET WHERE COMP_CODE=@v1_comp_code and UNIT_CODE	=@v1_unit 
			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code				
			DELETE FROM [utusan16].[dbo].[CIR_OUTMAST] WHERE COMP_CODE=@v1_comp_code and UNIT_CODE	=@v1_unit 
			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code
			DELETE FROM utusan16.DBO.CIR_BILL WHERE COMP_CODE=@v1_comp_code and UNIT_CODE	=@v1_unit 
			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code
			DELETE FROM [utusan16].[dbo].[CIR_RCPDET] WHERE COMP_CODE=@v1_comp_code and UNIT_CODE	=@v1_unit 
			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code
			DELETE FROM [utusan16].[dbo].[CIR_RCPHDR] WHERE COMP_CODE=@v1_comp_code and UNIT_CODE=@v1_unit 
			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code

			DELETE FROM [utusan16].[dbo].[CIR_AGMAST] WHERE COMP_CODE=@v1_comp_code and UNIT	=@v1_unit 
			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code

			INSERT INTO [utusan16].[dbo].[CIR_AGMAST]([COMP_CODE],[UNIT],[AGCD],[DPCD],[AG_NAME],[AG_NAME_OTH_LANG],[AG_TYPE],[AG_CLASS]
			,[EXECUTIVE_CODE],[SUPPLY_START_DT],[ADDR1],[ADDR2],[ADDR3],[CITY_CODE],[DIST_CODE],[STATE_CODE],[COUNTRY_CODE],[TEHSIL_TALUKA]
			,[STATION_CODE],[AREA_CODE],[PHONE_NO1],[PHONE_NO2],[MOBILE_NO1],[MOBILE_NO2],[EMAIL_ID],[SUSPEND],[SUSPEND_TYPE],[SUSPEND_DATE]
			,[TO_BILL],[BILL_AGCD],[BILL_DPCD],[PAYMODE],[CREDIT_DAYS],[PRINT_LABEL],[PIN_PACKET],[PIN_AGCD],[PIN_DPCD],[PIN_OPEN_INSIDE]
			,[LBL_LN1],[LBL_LN2],[LBL_LN3],[LBL_LN4],[LBL_LN5],[LBL_LN6],[LBL_LN7],[LBL_LN8],[LBL_ATR1],[LBL_ATR2],[LBL_ATR3],[LBL_ATR4]
			,[LBL_ATR5],[LBL_ATR6],[LBL_ATR7],[LBL_ATR8],[ALERT_TEXT],[USERID],[CREATION_datetime],[NAME_ON_LABEL],[PRINT_SEQ]
			,[ALERT_VALID_DATE],[PIN_CODE],[FREEZE_FLAG],[FAX_NO],[BRANCH_CODE],[UNSOLD_VALID_FLAG],[SECURITY_PER],[SEC_AMT_LIMT]
			,[SUPPLY_STOP_FLAG],[SUPPLY_STOP_PER],[ABC_CITYCODE],[UPDATED_BY],[UPDATED_DT],[SUPPLY_SUBAGENCY],[AGEING_TYPE],[LABEL_TYPE]
			,[H_ADDR1],[H_ADDR2],[H_ADDR3],[H_CITY_CODE],[H_TEHSIL_TALUKA],[H_DIST_CODE],[H_STATE_CODE],[H_COUNTRY_CODE],[H_PIN_CODE]
			,[H_PHONE_NO1],[H_PHONE_NO2],[H_MOBILE_NO1],[H_MOBILE_NO2],[H_EMAIL_ID],[BILL_REMARK],[SUP_BRANCH_CODE],[SUP_STATE_CODE]
			,[ACCOUNT_AGCD],[ACCOUNT_DPCD],[ROC_NO],[PAN_NO],[TAN_NO],[SER_TAX_NO],[OLD_AGENCY],[CLOSE_AGENCY_REASON],[SAP_ID],[FROM_BOOKLET]
			,[TO_BOOKLET],[DATA_POST])
			(SELECT [COMP_CODE],[UNIT],[AGCD],[DPCD],[AG_NAME],[AG_NAME_OTH_LANG],[AG_TYPE],[AG_CLASS]
			,[EXECUTIVE_CODE],[SUPPLY_START_DT],[ADDR1],[ADDR2],[ADDR3],[CITY_CODE],[DIST_CODE],[STATE_CODE],[COUNTRY_CODE],[TEHSIL_TALUKA]
			,[STATION_CODE],[AREA_CODE],[PHONE_NO1],[PHONE_NO2],[MOBILE_NO1],[MOBILE_NO2],[EMAIL_ID],[SUSPEND],[SUSPEND_TYPE],[SUSPEND_DATE]
			,[TO_BILL],[BILL_AGCD],[BILL_DPCD],[PAYMODE],[CREDIT_DAYS],[PRINT_LABEL],[PIN_PACKET],[PIN_AGCD],[PIN_DPCD],[PIN_OPEN_INSIDE]
			,[LBL_LN1],[LBL_LN2],[LBL_LN3],[LBL_LN4],[LBL_LN5],[LBL_LN6],[LBL_LN7],[LBL_LN8],[LBL_ATR1],[LBL_ATR2],[LBL_ATR3],[LBL_ATR4]
			,[LBL_ATR5],[LBL_ATR6],[LBL_ATR7],[LBL_ATR8],[ALERT_TEXT],[USERID],[CREATION_datetime],[NAME_ON_LABEL],[PRINT_SEQ]
			,[ALERT_VALID_DATE],[PIN_CODE],[FREEZE_FLAG],[FAX_NO],[BRANCH_CODE],[UNSOLD_VALID_FLAG],[SECURITY_PER],[SEC_AMT_LIMT]
			,[SUPPLY_STOP_FLAG],[SUPPLY_STOP_PER],[ABC_CITYCODE],[UPDATED_BY],[UPDATED_DT],[SUPPLY_SUBAGENCY],[AGEING_TYPE],[LABEL_TYPE]
			,[H_ADDR1],[H_ADDR2],[H_ADDR3],[H_CITY_CODE],[H_TEHSIL_TALUKA],[H_DIST_CODE],[H_STATE_CODE],[H_COUNTRY_CODE],[H_PIN_CODE]
			,[H_PHONE_NO1],[H_PHONE_NO2],[H_MOBILE_NO1],[H_MOBILE_NO2],[H_EMAIL_ID],[BILL_REMARK],[SUP_BRANCH_CODE],[SUP_STATE_CODE]
			,[ACCOUNT_AGCD],[ACCOUNT_DPCD],[ROC_NO],[PAN_NO],[TAN_NO],[SER_TAX_NO],[OLD_AGENCY],[CLOSE_AGENCY_REASON],[SAP_ID],[FROM_BOOKLET]
			,[TO_BOOKLET],[DATA_POST] FROM CIR_AGMAST WHERE COMP_CODE=@v1_comp_code and UNIT	=@v1_unit 
			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code)
			
			INSERT INTO [utusan16].[dbo].[CIR_AG_CON_PER]([COMP_CODE],[UNIT],[AGCD],[DPCD],[NAME],[DESIG],[PER_ROLE],[DATE_OF_BIRTH]
			,[PHONE_NO1],[PHONE_NO2],[MOBILE_NO1],[MOBILE_NO2],[FAX_NO],[EMAIL_ID],[USERID],[CREATION_DATE],[SEQ_NO],[RACE_CODE]
			,[NEW_IC_NO],[OLD_IC_NO])
			(SELECT [COMP_CODE],[UNIT],[AGCD],[DPCD],[NAME],[DESIG],[PER_ROLE],[DATE_OF_BIRTH]
			,[PHONE_NO1],[PHONE_NO2],[MOBILE_NO1],[MOBILE_NO2],[FAX_NO],[EMAIL_ID],[USERID],[CREATION_DATE],[SEQ_NO],[RACE_CODE]
			,[NEW_IC_NO],[OLD_IC_NO] FROM CIR_AG_CON_PER WHERE COMP_CODE=@v1_comp_code and UNIT	=@v1_unit 
			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code )
			
--			DELETE FROM [utusan16].[dbo].[CIR_SUPPLY] WHERE COMP_CODE=@v1_comp_code and UNIT	=@v1_unit 
--			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code
			
			INSERT INTO [utusan16].[dbo].[CIR_SUPPLY]([COMP_CODE],[UNIT],[AGCD],[DPCD],[PUBL],[EDTN],[SUPPLY_FLAG],[SUPPLY_TYPE_CODE]
			,[BASE_SUPPLY],[SUPPLY_SUN],[SUPPLY_MON],[SUPPLY_TUE],[SUPPLY_WED],[SUPPLY_THU],[SUPPLY_FRI],[SUPPLY_SAT],[DEVATION_SUPPLY]
			,[COMM_FLAG],[COMM_CODE],[PACKET_SIZE],[ROUTE_CODE],[SUBROUTE_CODE],[SUB_SUBROUTE_CODE],[USERID],[CREATION_DATE],[SUPPLY_SPL1]
			,[SUPPLY_SPL2],[SURCH_CD],[SUB_EDTN],[LBL_PRINTNO],[UPDATED_BY],[UPDATED_DT],[BILLING_CYCLE],[INSERTION_FEE],[WASTE_CATG_CODE]
			,[SP_SUPPLY_MON1],[SP_SUPPLY_TUE1],[SP_SUPPLY_WED1],[SP_SUPPLY_THU1],[SP_SUPPLY_FRI1],[SP_SUPPLY_SAT1],[SP_SUPPLY_SUN1],[SP_SUPPLY_MON2]
			,[SP_SUPPLY_TUE2],[SP_SUPPLY_WED2],[SP_SUPPLY_THU2],[SP_SUPPLY_FRI2],[SP_SUPPLY_SAT2],[SP_SUPPLY_SUN2],[LATE_FEE],[INCENTIVE])
			(SELECT [COMP_CODE],[UNIT],[AGCD],[DPCD],[PUBL],[EDTN],[SUPPLY_FLAG],[SUPPLY_TYPE_CODE]
			,[BASE_SUPPLY],[SUPPLY_SUN],[SUPPLY_MON],[SUPPLY_TUE],[SUPPLY_WED],[SUPPLY_THU],[SUPPLY_FRI],[SUPPLY_SAT],[DEVATION_SUPPLY]
			,[COMM_FLAG],[COMM_CODE],[PACKET_SIZE],[ROUTE_CODE],[SUBROUTE_CODE],[SUB_SUBROUTE_CODE],[USERID],[CREATION_DATE],[SUPPLY_SPL1]
			,[SUPPLY_SPL2],[SURCH_CD],[SUB_EDTN],[LBL_PRINTNO],[UPDATED_BY],[UPDATED_DT],[BILLING_CYCLE],[INSERTION_FEE],[WASTE_CATG_CODE]
			,[SP_SUPPLY_MON1],[SP_SUPPLY_TUE1],[SP_SUPPLY_WED1],[SP_SUPPLY_THU1],[SP_SUPPLY_FRI1],[SP_SUPPLY_SAT1],[SP_SUPPLY_SUN1],[SP_SUPPLY_MON2]
			,[SP_SUPPLY_TUE2],[SP_SUPPLY_WED2],[SP_SUPPLY_THU2],[SP_SUPPLY_FRI2],[SP_SUPPLY_SAT2],[SP_SUPPLY_SUN2],[LATE_FEE],[INCENTIVE]
			FROM CIR_SUPPLY WHERE COMP_CODE=@v1_comp_code and UNIT	=@v1_unit 
			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code)
			
--			DELETE FROM [utusan16].[dbo].[CIR_SUSPEND_TRAN] WHERE COMP_CODE=@v1_comp_code and UNIT	=@v1_unit 
--			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code
			
			INSERT INTO [utusan16].[dbo].[CIR_SUSPEND_TRAN]([COMP_CODE],[UNIT],[AGCD],[DPCD],[TRN_DATE],[SUSP],[SUSPTY],[SUSP_DATE]
			,[START_DATE],[USERID],[CREATION_DATE],[FREEZE_FLAG],[AGENCY_UNBLOCK_TYPE],[AGENCY_UNBLOCK_APPROVAL])
			(SELECT [COMP_CODE],[UNIT],[AGCD],[DPCD],[TRN_DATE],[SUSP],[SUSPTY],[SUSP_DATE]
			,[START_DATE],[USERID],[CREATION_DATE],[FREEZE_FLAG],[AGENCY_UNBLOCK_TYPE],[AGENCY_UNBLOCK_APPROVAL] FROM
			CIR_SUSPEND_TRAN WHERE COMP_CODE=@v1_comp_code and UNIT	=@v1_unit 
			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code)
			
--			DELETE FROM [utusan16].[dbo].[CIR_BANK_GUARANTEE] WHERE COMP_CODE=@v1_comp_code and UNIT_CODE	=@v1_unit 
--			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code
			
			INSERT INTO [utusan16].[dbo].[CIR_BANK_GUARANTEE]([COMP_CODE],[UNIT_CODE],[AGCD],[DPCD],[BG_NO],[BG_AMT],[BG_DATE],[BG_VALID]
			,[BANK_DESC],[CREATED_BY],[CREATED_DT],[UPDATED_BY],[UPDATED_DT],[BG_TYPE],[BG_ATTACH])
			(SELECT [COMP_CODE],[UNIT_CODE],[AGCD],[DPCD],[BG_NO],[BG_AMT],[BG_DATE],[BG_VALID]
			,[BANK_DESC],[CREATED_BY],[CREATED_DT],[UPDATED_BY],[UPDATED_DT],[BG_TYPE],[BG_ATTACH] FROM CIR_BANK_GUARANTEE
			 WHERE COMP_CODE=@v1_comp_code and UNIT_CODE =@v1_unit and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code)
			
--			DELETE FROM [utusan16].[dbo].[CIR_AGENCY_REMARK] WHERE COMP_CODE=@v1_comp_code and UNIT_CODE=@v1_unit 
--			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code
			
			INSERT INTO [utusan16].[dbo].[CIR_AGENCY_REMARK]([COMP_CODE],[UNIT_CODE],[AGCD],[DPCD],[RMRK_TYPE],[EFFECTIVE_FROM]
			,[RMRK],[CREATE_BY],[CREATED_DT],[UPDATED_BY],[UPDATED_DT],[EFFECTIVE_TILL])
			(SELECT [COMP_CODE],[UNIT_CODE],[AGCD],[DPCD],[RMRK_TYPE],[EFFECTIVE_FROM]
			,[RMRK],[CREATE_BY],[CREATED_DT],[UPDATED_BY],[UPDATED_DT],[EFFECTIVE_TILL] FROM CIR_AGENCY_REMARK 
			 WHERE COMP_CODE=@v1_comp_code and UNIT_CODE=@v1_unit and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code)
			
--			DELETE FROM [utusan16].[dbo].[CIR_AGENCY_CREDIT] WHERE COMP_CODE=@v1_comp_code and UNIT_CODE	=@v1_unit 
--			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code
			
			INSERT INTO [utusan16].[dbo].[CIR_AGENCY_CREDIT] ([COMP_CODE],[UNIT_CODE],[AGCD],[DPCD],[PUBL_CODE],[CREDIT_DAYS],[CREDIT_LIMIT]
			,[CREATE_BY],[CREATED_DT],[UPDATED_BY],[UPDATED_DT] )
			(SELECT [COMP_CODE],[UNIT_CODE],[AGCD],[DPCD],[PUBL_CODE],[CREDIT_DAYS],[CREDIT_LIMIT]
			,[CREATE_BY],[CREATED_DT],[UPDATED_BY],[UPDATED_DT] FROM CIR_AGENCY_CREDIT 
			WHERE COMP_CODE=@v1_comp_code and UNIT_CODE	=@v1_unit and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code )
			
--			DELETE FROM [utusan16].[dbo].[CIR_AGENCY_PAYMODE]  WHERE COMP_CODE=@v1_comp_code and UNIT_CODE	=@v1_unit 
--			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code
			
			INSERT INTO [utusan16].[dbo].[CIR_AGENCY_PAYMODE]([COMP_CODE],[UNIT_CODE],[AGCD],[DPCD],[PAYMODE],[PAYMODE_ACTIVE]
			,[CREATED_BY],[CREATED_DT],[UPDATED_BY],[UPDATED_DT],[BKUP_SNO],[BLOCK_BY_A_M])
			(SELECT [COMP_CODE],[UNIT_CODE],[AGCD],[DPCD],[PAYMODE],[PAYMODE_ACTIVE]
			,[CREATED_BY],[CREATED_DT],[UPDATED_BY],[UPDATED_DT],[BKUP_SNO],[BLOCK_BY_A_M] FROM CIR_AGENCY_PAYMODE
			WHERE COMP_CODE=@v1_comp_code and UNIT_CODE	=@v1_unit 	and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code)
			
--			DELETE FROM [utusan16].[dbo].[CIR_AGENCY_FESTIVAL] WHERE COMP_CODE=@v1_comp_code and UNIT_CODE	=@v1_unit 
--			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code
			
			INSERT INTO [utusan16].[dbo].[CIR_AGENCY_FESTIVAL]([COMP_CODE],[UNIT_CODE],[AGCD],[DPCD],[FEST_CODE],[CREATE_BY]
			,[CREATED_DT],[UPDATED_BY],[UPDATED_DT])
			(SELECT [COMP_CODE],[UNIT_CODE],[AGCD],[DPCD],[FEST_CODE],[CREATE_BY] ,[CREATED_DT],[UPDATED_BY],[UPDATED_DT] 
			FROM CIR_AGENCY_FESTIVAL WHERE COMP_CODE=@v1_comp_code and UNIT_CODE=@v1_unit 
			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code )
			
--			DELETE FROM [utusan16].[dbo].[CIR_GMAP] WHERE COMP_CODE=@v1_comp_code and UNIT_CODE	=@v1_unit 
--			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code
			
			INSERT INTO [utusan16].[dbo].[CIR_GMAP]([CITY_NAME],[LATITUDE],[LONGITUDE],[AGCD],[DPCD],[UNIT_CODE],[COMP_CODE])
			(SELECT [CITY_NAME],[LATITUDE],[LONGITUDE],[AGCD],[DPCD],[UNIT_CODE],[COMP_CODE]
			FROM CIR_GMAP WHERE COMP_CODE=@v1_comp_code and UNIT_CODE	=@v1_unit 
			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code)
			
--			DELETE FROM [utusan16].[dbo].[CIR_AGMAST] WHERE COMP_CODE=@v1_comp_code and UNIT	=@v1_unit 
--			and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code
				
			

				------------ FIRST FOR OPENING BALANCE
--				DELETE FROM utusan16.DBO.CIR_AGOMAST where COMP_CODE=@v1_comp_code and UNIT_CODE	=@v1_unit 
--				and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code
				
				INSERT INTO utusan16.DBO.CIR_AGOMAST (COMP_CODE,UNIT_CODE,PUBL,AGCD,DPCD,FOR_MONTH,OPBAL,SEC_OPBAL,CREATION_DATE,CREATION_USERID,LAST_UPDATED_DATE,LAST_UPDATED_USERID)
				(SELECT COMP_CODE,UNIT_CODE,PUBL,AGCD,DPCD,FOR_MONTH,OPBAL,SEC_OPBAL,CREATION_DATE,CREATION_USERID,LAST_UPDATED_DATE,LAST_UPDATED_USERID FROM CIR_AGOMAST
				where COMP_CODE=@v1_comp_code and UNIT_CODE	=@v1_unit 
				and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code)
				
				-------------  FIRST FOR BILL	
--				DELETE FROM utusan16.DBO.CIR_BILL_DET WHERE COMP_CODE=@v1_comp_code and UNIT_CODE	=@v1_unit 
--				and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code				
--				DELETE FROM [utusan16].[dbo].[CIR_OUTMAST] WHERE COMP_CODE=@v1_comp_code and UNIT_CODE	=@v1_unit 
--				and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code
--				DELETE FROM utusan16.DBO.CIR_BILL WHERE COMP_CODE=@v1_comp_code and UNIT_CODE	=@v1_unit 
--				and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code
--				DELETE FROM [utusan16].[dbo].[CIR_RCPDET] WHERE COMP_CODE=@v1_comp_code and UNIT_CODE	=@v1_unit 
--				and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code
--				DELETE FROM [utusan16].[dbo].[CIR_RCPHDR] WHERE COMP_CODE=@v1_comp_code and UNIT_CODE=@v1_unit 
--				and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code
				
					
					
				INSERT INTO [utusan16].[dbo].[CIR_BILL]([COMP_CODE],[UNIT_CODE],[BILLNO],[BILLDT],[AGCD],[DPCD],[PUBL],[BILL_COPY],[GROSS_AMOUNT]
				,[SUR_AMOUNT],[COMM_AMOUNT],[BILL_AMOUNT],[BILL_FRDT],[BILL_TODT],[BILL_FLAG],[BILL_REMARK],[USERID],[CREATION_DATE],[BILL_SEC_AMT]
				,[EXCOMM_RECPTNO],[EXCOMM_RECPTDT],[EXCOMM_AMT],[BRANCH_CODE],[SEC_PER_RATE],[ROUTE_CODE],[BILL_COUNT],[CN_COMM_COPY]
				,[TAX_RATE],[TAX_AMT],[ACCAGCD],[ACCDPCD],[TAX_CALC_TYPE])
				(SELECT [COMP_CODE],[UNIT_CODE],[BILLNO],[BILLDT],[AGCD],[DPCD],[PUBL],[BILL_COPY],[GROSS_AMOUNT]
				,[SUR_AMOUNT],[COMM_AMOUNT],[BILL_AMOUNT],[BILL_FRDT],[BILL_TODT],[BILL_FLAG],[BILL_REMARK],[USERID],[CREATION_DATE],[BILL_SEC_AMT]
				,[EXCOMM_RECPTNO],[EXCOMM_RECPTDT],[EXCOMM_AMT],[BRANCH_CODE],[SEC_PER_RATE],[ROUTE_CODE],[BILL_COUNT],[CN_COMM_COPY]
				,[TAX_RATE],[TAX_AMT],[ACCAGCD],[ACCDPCD],[TAX_CALC_TYPE] FROM CIR_BILL 
				WHERE COMP_CODE=@v1_comp_code and UNIT_CODE	=@v1_unit 
				and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code)
											
				INSERT INTO [utusan16].[dbo].[CIR_BILL_DET]([COMP_CODE],[UNIT_CODE],[BILLNO],[BILLDT],[AGCD],[DPCD],[PUBL],[EDTN],[BILL_COPY]
				,[COPY_RATE],[COMM_FLAG],[COMM_RATE],[SUR_RATE],[GROSS_AMOUNT],[BILL_AMOUNT],[FROMDT],[TODT],[COAG],[CODP],[REMARKS],[USERID]
				,[CREATION_DATE],[COMM_AMT],[SUR_AMT],[BILL_FLAG],[BRANCH_CODE],[COMM_TYPE],[ACCAGCD],[ACCDPCD])
				(SELECT [COMP_CODE],[UNIT_CODE],[BILLNO],[BILLDT],[AGCD],[DPCD],[PUBL],[EDTN],[BILL_COPY]
				,[COPY_RATE],[COMM_FLAG],[COMM_RATE],[SUR_RATE],[GROSS_AMOUNT],[BILL_AMOUNT],[FROMDT],[TODT],[COAG],[CODP],[REMARKS],[USERID]
				,[CREATION_DATE],[COMM_AMT],[SUR_AMT],[BILL_FLAG],[BRANCH_CODE],[COMM_TYPE],[ACCAGCD],[ACCDPCD] FROM CIR_BILL_DET
				WHERE COMP_CODE=@v1_comp_code and UNIT_CODE	=@v1_unit 
				and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code)
				
				INSERT INTO [utusan16].[dbo].[CIR_RCPHDR]([COMP_CODE],[UNIT_CODE],[DOCTYPE],[AGCD],[DPCD],[RECPTNO],[RECPTDT],[CHNO],[CHDT]
				,[CHBANK],[AMOUNT],[OTH_AMOUNT],[CCDP],[CCDS],[RCDP],[RCDS],[OCDP],[OCDS],[REASON],[REMARK],[ACHD],[VOUCHERNO],[VOUCHERDT]
				,[VCHTYPE],[PUBL],[RECEIVED_FROM],[TDSRATE],[TDSAMT],[STAXRATE],[STAXAMT],[STATUS],[REF_RECPTNO],[REF_RECPTDT],[REF_AMOUNT]
				,[REF_DOCTYPE],[CANCEL_USER],[CANCEL_DATE],[CANCEL_REMARK],[USERID],[CREATION_DATE],[BRANCH_CODE],[PROV_REC_NO],[PROV_REC_DT]
				,[bkup_sno],[REMARK_OTH],[TRF_NOTE_TYPE],[MANNUALRECPTNO])
				(SELECT [COMP_CODE],[UNIT_CODE],[DOCTYPE],[AGCD],[DPCD],[RECPTNO],[RECPTDT],[CHNO],[CHDT]
				,[CHBANK],[AMOUNT],[OTH_AMOUNT],[CCDP],[CCDS],[RCDP],[RCDS],[OCDP],[OCDS],[REASON],[REMARK],[ACHD],[VOUCHERNO],[VOUCHERDT]
				,[VCHTYPE],[PUBL],[RECEIVED_FROM],[TDSRATE],[TDSAMT],[STAXRATE],[STAXAMT],[STATUS],[REF_RECPTNO],[REF_RECPTDT],[REF_AMOUNT]
				,[REF_DOCTYPE],[CANCEL_USER],[CANCEL_DATE],[CANCEL_REMARK],[USERID],[CREATION_DATE],[BRANCH_CODE],[PROV_REC_NO],[PROV_REC_DT]
				,[bkup_sno],[REMARK_OTH],[TRF_NOTE_TYPE],[MANNUALRECPTNO] FROM CIR_RCPHDR 
				 WHERE COMP_CODE=@v1_comp_code and UNIT_CODE=@v1_unit and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code )
				 
				 INSERT INTO [utusan16].[dbo].[CIR_RCPDET]([COMP_CODE],[UNIT_CODE],[AGCD],[DPCD],[DOCTYP],[BILLNO],[BILLDT],[RECPTNO]
				,[RECPTDT],[PAYFOR],[ACHD],[PUBL],[CHNO],[CHBNK],[CHDT],[AMOUNT],[REASON],[REMARK],[VOUCHERNO],[VOUCHERDT],[TDS],[STAX]
				,[STATUS],[USRID],[CREATION_DATE],[BRANCH_CODE],[bkup_sno])
				(SELECT [COMP_CODE],[UNIT_CODE],[AGCD],[DPCD],[DOCTYP],[BILLNO],[BILLDT],[RECPTNO]
				,[RECPTDT],[PAYFOR],[ACHD],[PUBL],[CHNO],[CHBNK],[CHDT],[AMOUNT],[REASON],[REMARK],[VOUCHERNO],[VOUCHERDT],[TDS],[STAX]
				,[STATUS],[USRID],[CREATION_DATE],[BRANCH_CODE],[bkup_sno] FROM CIR_RCPDET
				 WHERE COMP_CODE=@v1_comp_code and UNIT_CODE=@v1_unit and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code)
				 
				INSERT INTO [utusan16].[dbo].[CIR_OUTMAST]([COMP_CODE],[UNIT_CODE],[AGCD],[DPCD],[DOCTYP],[BILLNO],[BILLDT],[RECPTNO]
				,[RECPTDT],[ACHD],[PUBL],[CHNO],[CHBNK],[CHDT],[AMOUNT],[REASON],[REMARK],[VOUCHERNO],[VOUCHERDT],[BALANCE],[TDS],[STAX]
				,[STATUS],[CANCEL_USERID],[CANCEL_DT],[CANCEL_REMARK],[USRID],[CREATION_DATE],[BILL_SEC_AMT],[BRANCH_CODE],[bkup_sno]
				,[DISPUTE_FLAG],[DISPUTE_USER_CODE],[DISPUTE_DT],[DISPUTE_RMRK])
				(SELECT [COMP_CODE],[UNIT_CODE],[AGCD],[DPCD],[DOCTYP],[BILLNO],[BILLDT],[RECPTNO]
				,[RECPTDT],[ACHD],[PUBL],[CHNO],[CHBNK],[CHDT],[AMOUNT],[REASON],[REMARK],[VOUCHERNO],[VOUCHERDT],[BALANCE],[TDS],[STAX]
				,[STATUS],[CANCEL_USERID],[CANCEL_DT],[CANCEL_REMARK],[USRID],[CREATION_DATE],[BILL_SEC_AMT],[BRANCH_CODE],[bkup_sno]
				,[DISPUTE_FLAG],[DISPUTE_USER_CODE],[DISPUTE_DT],[DISPUTE_RMRK] FROM CIR_OUTMAST  
				WHERE COMP_CODE=@v1_comp_code and UNIT_CODE	=@v1_unit and AGCD=@v1_ag_main_code and DPCD=@v1_ag_sub_code )
				
			
			--------------- this is for copy the transaction in another database --------------------------------
			*/
			
			
			print(@v1_row_idno)print(@v1_comp_code)print(@v1_unit)print(@v1_ag_main_code)print(@v1_ag_sub_code)print(@v1_agency_name)print(@v1_region)print(@v1_city_code)
			print(@v1_dist_code)print(@v1_credit_days)print(@v1_amount)print(@v_recptno)print(@v_pprocessdt)print(@preason)print(@v_vchno)print(@v_remark)print(@pwcdp)print(@paccode)

			insert into cir_rcphdr(comp_code,unit_code,agcd,dpcd,doctype,recptno,recptdt,amount,reason,remark,
								   achd,voucherno,voucherdt,userid,creation_date,branch_code)
			VALUES (@v1_comp_code,@v1_unit,@v1_ag_main_code,@v1_ag_sub_code,@v_doctype,@v_recptno,@v_pprocessdt,-1*@v1_amount,@preason,@v_remark
					,'NM',@v_recptno,@v_pprocessdt,@puserid,getdate(),@v1_branch)  
			
			insert into cir_rcpdet(comp_code,unit_code,agcd,dpcd,doctyp,publ,recptno,recptdt,payfor,achd,amount,
								  reason,remark,voucherno,voucherdt,usrid,creation_date,branch_code)
			VALUES (@v1_comp_code,@v1_unit,@v1_ag_main_code,@v1_ag_sub_code,@v_doctype,null,@v_recptno,@v_pprocessdt,@v1_unit,'NM',-1*@v1_amount
			,@preason,@v_remark,@v_recptno,@v_pprocessdt,@puserid,getdate(),@v1_branch)  
			
			insert into cir_outmast(comp_code,unit_code,agcd,dpcd,doctyp,publ,recptno,recptdt,achd,amount,
									reason,remark,voucherno,voucherdt,usrid,creation_date,branch_code)
			values(@v1_comp_code, @v1_unit,@v1_ag_main_code, @v1_ag_sub_code,@v_doctype,null,@v_recptno ,@v_pprocessdt,'NM',0,
					@preason,@v_remark,@v_recptno ,@v_pprocessdt,@puserid,getdate(),@v1_branch)                               
			
			DECLARE c2 cursor LOCAL FOR 
					SELECT ROW_IDNO, COMP_CODE, UNIT,BRANCH_CODE, DOCTYPE, DOCNO, DOCDT, PRIPUB, AG_MAIN_CODE, AG_SUB_CODE, CHNO, CHDT, BANK, AMOUNT, REASON, 
					VOUCHERNO, VOUCHERDATE, RECEIPT_NO, PRIPROCTG, REF_RECPTNO, REF_RECPTDT, REF_AMOUNT, REF_DOCTYP, RECEIVED_REGION, REMARK, 
					RETAINER_CODE, EXEC_CODE, AD_TYPE, PREV_CIOID FROM  CIR_WRITEOFF_PROCESS_DATA 
					WHERE row_idno  = @prowidno AND	comp_code  = @v1_comp_code AND	branch_code  = @v1_unit
					AND	ag_main_code  = @v1_ag_main_code AND	ag_sub_code  = @v1_ag_sub_code
			
			OPEN c2 
				fetch NEXT FROM c2 INTO @v2_ROW_IDNO, @v2_COMP_CODE , @v2_UNIT,@v2_BRANCH , @v2_DOCTYPE , @v2_DOCNO , @v2_DOCDT , @v2_PRIPUB , @v2_AG_MAIN_CODE , @v2_AG_SUB_CODE , @v2_CHNO , @v2_CHDT , @v2_BANK , @v2_AMOUNT , @v2_REASON , @v2_VOUCHERNO , @v2_VOUCHERDATE , @v2_RECEIPT_NO , @v2_PRIPROCTG , @v2_REF_RECPTNO , @v2_REF_RECPTDT , @v2_REF_AMOUNT , @v2_REF_DOCTYP , @v2_RECEIVED_REGION , @v2_REMARK , @v2_RETAINER_CODE , @v2_EXEC_CODE , @v2_AD_TYPE , @v2_PREV_CIOID 
				WHILE (@@FETCH_STATUS = 0) 
				BEGIN	print('OPEN c2 ')
					IF (@@FETCH_STATUS = -1) 
						BREAK
						print(@v2_docno) print(@v2_docdt) print(@v2_ag_main_code) print(@v2_ag_sub_code) print('c3')
					
					DECLARE c3 cursor LOCAL FOR 
						SELECT UNIT_code, DOCTYP, PUBL, BRANCH_CODE, BILLNO, BILLDT, RECPTNO, RECPTDT
						, CHNO, CHDT, CHBNK, AMOUNT, REASON, AGCD, DPCD, VOUCHERNO,VOUCHERDT, BALANCE, TDS, 
						COMP_CODE, USRID, CREATION_DATE, STAX, REMARK FROM  cir_outmast
						WHERE comp_code  = @v1_comp_code AND	unit_code  = @v1_unit 
						AND((doctyp='BIL' and billno is null) or (doctyp!='BIL' and billno is not null)) 
						AND	billno  = @v2_docno AND	billdt  = @v2_docdt AND	agcd  = @v2_ag_main_code AND dpcd = @v2_ag_sub_code 
			
					OPEN c3 					
					fetch NEXT FROM c3 INTO @v3_UNIT,@v3_DOCTYPE,@v3_PRIPUB,@v3_BRANCH,@v3_BILLNO,@v3_BILLDT,@v3_RECPTNO,@v3_RECPTDT,@v3_CHNO,@v3_CHDT,@v3_BANK,@v3_AMOUNT,@v3_REASON,@v3_AG_MAIN_CODE,@v3_AG_SUB_CODE,@v3_VOUCHERNO,@v3_VOUCHERDATE,@v3_BALANCE,@v3_TDS,@v3_COMP_CODE,@v3_USERID,@v3_CREATION_DATETIME,@v3_ST,@v3_REMARK
					WHILE (@@FETCH_STATUS = 0) 
					BEGIN 
					
					print('X1')print(@@cursor_rows)
					print(@v1_comp_code)print(@v1_unit)print(@v3_doctype)print(@v3_reason)
					print(@v1_branch)
					print(@v3_BILLNO)print(@v3_BILLDT)print(@v_recptno)print(@v_pprocessdt)
					print(@v3_voucherno)print(@v3_voucherdate)print(@v2_amount)print(@puserid) print(@v1_ag_main_code)
					print(@v1_ag_sub_code)print(@v3_PRIPUB)
						INSERT INTO  cir_outmast( comp_code , UNIT_CODE	, doctyp , reason , BRANCH_CODE , billno , billdt , recptno , recptdt , 
						voucherno , voucherdt , amount , usrid , AGCD , DPCD , remark ,PUBL)  
						VALUES(@v1_comp_code,@v1_unit,@v_doctype,@v3_reason,@v1_branch,@v3_BILLNO,@v3_BILLDT,@v_recptno,@v_pprocessdt
							 , @v3_voucherno , @v3_voucherdate ,-1*@v2_amount , @puserid ,@v1_ag_main_code , @v1_ag_sub_code , null ,@v3_PRIPUB)  
							 
						INSERT INTO  CIR_RCPDET( comp_code , UNIT_CODE	, doctyp , reason , BRANCH_CODE , billno , billdt , recptno , recptdt , 
						voucherno , voucherdt , amount , usrid , AGCD , DPCD , remark,PUBL )  
						VALUES(@v1_comp_code,@v1_unit,@v_doctype,@v3_reason,@v1_branch,@v3_BILLNO,@v3_BILLDT,@v_recptno,@v_pprocessdt
							 , @v3_voucherno , @v3_voucherdate ,-1*@v2_amount , @puserid ,@v1_ag_main_code , @v1_ag_sub_code , null ,@v3_PRIPUB)  					
				
				print('S')
				
				fetch NEXT FROM c3 INTO @v3_UNIT,@v3_DOCTYPE,@v3_PRIPUB,@v3_BRANCH,@v3_BILLNO,@v3_BILLDT,@v3_RECPTNO,@v3_RECPTDT,@v3_CHNO,@v3_CHDT,@v3_BANK,@v3_AMOUNT,@v3_REASON,@v3_AG_MAIN_CODE,@v3_AG_SUB_CODE,@v3_VOUCHERNO,@v3_VOUCHERDATE,@v3_BALANCE,@v3_TDS,@v3_COMP_CODE,@v3_USERID,@v3_CREATION_DATETIME,@v3_ST,@v3_REMARK
				END
				close c3
			DEALLOCATE c3				
			
			fetch NEXT FROM c2 INTO @v2_ROW_IDNO, @v2_COMP_CODE , @v2_UNIT,@v2_BRANCH , @v2_DOCTYPE , @v2_DOCNO , @v2_DOCDT , @v2_PRIPUB , @v2_AG_MAIN_CODE , @v2_AG_SUB_CODE , @v2_CHNO , @v2_CHDT , @v2_BANK , @v2_AMOUNT , @v2_REASON , @v2_VOUCHERNO , @v2_VOUCHERDATE , @v2_RECEIPT_NO , @v2_PRIPROCTG , @v2_REF_RECPTNO , @v2_REF_RECPTDT , @v2_REF_AMOUNT , @v2_REF_DOCTYP , @v2_RECEIVED_REGION , @v2_REMARK , @v2_RETAINER_CODE , @v2_EXEC_CODE , @v2_AD_TYPE , @v2_PREV_CIOID 
			END --) 			
			close c2
			DEALLOCATE c2			
			
		FETCH NEXT FROM C1 INTO @v1_row_idno,@v1_comp_code,@v1_unit,@v1_branch,@v1_ag_main_code,@v1_ag_sub_code,@v1_agency_name,@v1_region,@v1_city_code,@v1_dist_code,@v1_credit_days,@v1_amount
		end
close c1;
		
		
		-- IMPLICIT_TRANSACTIONS is set to OFF
 DEALLOCATE c1



		SET NOCOUNT OFF

	END


/////////////////////////////////////////



ALTER
PROCEDURE [dbo].[cir_smallamt_writeoff_proc_data]

@pcomp_code
VARCHAR(4000) , --company code

@punit_code
VARCHAR(4000) , --unit code

@pbranch_code
VARCHAR(4000) , --branch code

@pjv_type
VARCHAR(4000) , --Debit/Credit

@pfrdt
VARCHAR(4000) , --from date

@ptodt
VARCHAR(4000) , --till date

@pwcdp
VARCHAR(4000) , --writeoff account head

@paccode
VARCHAR(4000) , --other account head

@preason
VARCHAR(4000) , --reason code

@pamountupto
FLOAT , --amount upto

@pdoctyp
VARCHAR(4000) , --transaction type

@pdocdt
VARCHAR(4000) , --transaction date

@pdocno
VARCHAR(4000) , --transaction no

@pag_main_code
VARCHAR(4000) , --agency main code

@pag_sub_code
VARCHAR(4000) , --agency sub code

@ppubl
VARCHAR(4000) , --publication

@pamount
FLOAT , --transaction amount

@puserid
VARCHAR(4000) , --userid

@pprocessdt
VARCHAR(4000) , --process date

@pflg
VARCHAR(4000) , --for delete or insert

@prowidno
FLOAT , --for unique ID number

@pdateformat
VARCHAR(4000) , --date format

@pextra1
VARCHAR(4000) ,

@pextra2
VARCHAR(4000)

AS

BEGIN

SET NOCOUNT ON

DECLARE @vfrdt DATETIME

DECLARE @vtodt DATETIME

DECLARE @v_docdt DATETIME

DECLARE @v_pprocessdt DATETIME

SELECT @vfrdt = CONVERT(DATETIME, @pfrdt)

SELECT @vtodt = CONVERT(DATETIME, @ptodt)

SELECT @v_docdt = CONVERT(DATETIME, @pdocdt)

SELECT @v_pprocessdt = CONVERT(DATETIME, @pprocessdt)

IF @pflg = 'D'

BEGIN

DELETE FROM CIR_WRITEOFF_PROCESS_DATA

WHERE row_idno = @prowidno

END

ELSE

BEGIN

INSERT INTO CIR_WRITEOFF_PROCESS_DATA(row_idno,comp_code,branch_code,unit,doctype,docno,docdt,pripub,ag_main_code,ag_sub_code,amount,reason )

VALUES ( @prowidno , @pcomp_code ,@punit_code,@pbranch_code , @pdoctyp , @pdocno ,@v_docdt ,@ppubl ,@pag_main_code ,@pag_sub_code ,@pamount , @preason )

END

/* IF @pflg != 'D'

begin

if @pdoctyp ='BIL'

begin

insert into amit.dbo.CIR_OUTMAST ([COMP_CODE],[UNIT_CODE],[AGCD],[DPCD],[DOCTYP],[BILLNO],[BILLDT],[RECPTNO],[RECPTDT],[ACHD],[PUBL],[CHNO]

,[CHBNK],[CHDT],[AMOUNT],[REASON],[REMARK],[VOUCHERNO],[VOUCHERDT],[BALANCE],[TDS],[STAX],[STATUS],[CANCEL_USERID],[CANCEL_DT],[CANCEL_REMARK]

,[USRID],[CREATION_DATE],[BILL_SEC_AMT],[BRANCH_CODE],[bkup_sno],[DISPUTE_FLAG],[DISPUTE_USER_CODE],[DISPUTE_DT],[DISPUTE_RMRK])

(select [COMP_CODE],[UNIT_CODE],[AGCD],[DPCD],[DOCTYP],[BILLNO],[BILLDT],[RECPTNO],[RECPTDT],[ACHD],[PUBL],[CHNO],[CHBNK],[CHDT],[AMOUNT]

,[REASON],[REMARK],[VOUCHERNO],[VOUCHERDT],[BALANCE],[TDS],[STAX],[STATUS],[CANCEL_USERID],[CANCEL_DT],[CANCEL_REMARK],[USRID],[CREATION_DATE]

,[BILL_SEC_AMT],[BRANCH_CODE],[bkup_sno],[DISPUTE_FLAG],[DISPUTE_USER_CODE],[DISPUTE_DT],[DISPUTE_RMRK] from cir_outmast

where comp_code=@pcomp_code and DOCTYP=@pdoctyp and BILLNO=@pdocno and BILLDT=@pdocdt and RECPTNO is null and RECPTDT is null)

end

else

begin

insert into amit.dbo.CIR_RCPHDR

([COMP_CODE],[UNIT_CODE],[DOCTYPE],[AGCD],[DPCD],[RECPTNO],[RECPTDT],[CHNO],[CHDT],[CHBANK],[AMOUNT]

,[OTH_AMOUNT],[CCDP],[CCDS],[RCDP],[RCDS],[OCDP],[OCDS],[REASON],[REMARK],[ACHD],[VOUCHERNO],[VOUCHERDT]

,[VCHTYPE],[PUBL],[RECEIVED_FROM],[TDSRATE],[TDSAMT],[STAXRATE],[STAXAMT],[STATUS],[REF_RECPTNO]

,[REF_RECPTDT],[REF_AMOUNT],[REF_DOCTYPE],[CANCEL_USER],[CANCEL_DATE],[CANCEL_REMARK],[USERID]

,[CREATION_DATE],[BRANCH_CODE],[PROV_REC_NO],[PROV_REC_DT],[bkup_sno],[REMARK_OTH],[TRF_NOTE_TYPE],[MANNUALRECPTNO])

(select [COMP_CODE],[UNIT_CODE],[DOCTYPE],[AGCD],[DPCD],[RECPTNO],[RECPTDT],[CHNO],[CHDT],[CHBANK],[AMOUNT]

,[OTH_AMOUNT],[CCDP],[CCDS],[RCDP],[RCDS],[OCDP],[OCDS],[REASON],[REMARK],[ACHD],[VOUCHERNO],[VOUCHERDT]

,[VCHTYPE],[PUBL],[RECEIVED_FROM],[TDSRATE],[TDSAMT],[STAXRATE],[STAXAMT],[STATUS],[REF_RECPTNO]

,[REF_RECPTDT],[REF_AMOUNT],[REF_DOCTYPE],[CANCEL_USER],[CANCEL_DATE],[CANCEL_REMARK],[USERID]

,[CREATION_DATE],[BRANCH_CODE],[PROV_REC_NO],[PROV_REC_DT],[bkup_sno],[REMARK_OTH],[TRF_NOTE_TYPE],[MANNUALRECPTNO] from CIR_RCPHDR

where comp_code=@pcomp_code and DOCTYPE=@pdoctyp and RECPTNO=@pdocno and RECPTDT=@pdocdt)

insert into amit.dbo.CIR_RCPDET

([COMP_CODE],[UNIT_CODE],[AGCD],[DPCD],[DOCTYP],[BILLNO],[BILLDT],[RECPTNO],[RECPTDT],[PAYFOR],[ACHD],[PUBL],[CHNO]

,[CHBNK],[CHDT],[AMOUNT],[REASON],[REMARK],[VOUCHERNO],[VOUCHERDT],[TDS],[STAX],[STATUS],[USRID],[CREATION_DATE]

,[BRANCH_CODE],[bkup_sno])

(select [COMP_CODE],[UNIT_CODE],[AGCD],[DPCD],[DOCTYP],[BILLNO],[BILLDT],[RECPTNO],[RECPTDT],[PAYFOR],[ACHD],[PUBL],[CHNO]

,[CHBNK],[CHDT],[AMOUNT],[REASON],[REMARK],[VOUCHERNO],[VOUCHERDT],[TDS],[STAX],[STATUS],[USRID],[CREATION_DATE]

,[BRANCH_CODE],[bkup_sno] from CIR_RCPDET

where comp_code=@pcomp_code and DOCTYP=@pdoctyp and RECPTNO=@pdocno and RECPTDT=@pdocdt and billno is null and billdt is null)

insert into amit.dbo.CIR_OUTMAST ([COMP_CODE],[UNIT_CODE],[AGCD],[DPCD],[DOCTYP],[BILLNO],[BILLDT],[RECPTNO],[RECPTDT],[ACHD],[PUBL],[CHNO]

,[CHBNK],[CHDT],[AMOUNT],[REASON],[REMARK],[VOUCHERNO],[VOUCHERDT],[BALANCE],[TDS],[STAX],[STATUS],[CANCEL_USERID],[CANCEL_DT],[CANCEL_REMARK]

,[USRID],[CREATION_DATE],[BILL_SEC_AMT],[BRANCH_CODE],[bkup_sno],[DISPUTE_FLAG],[DISPUTE_USER_CODE],[DISPUTE_DT],[DISPUTE_RMRK])

(select [COMP_CODE],[UNIT_CODE],[AGCD],[DPCD],[DOCTYP],[BILLNO],[BILLDT],[RECPTNO],[RECPTDT],[ACHD],[PUBL],[CHNO],[CHBNK],[CHDT],[AMOUNT]

,[REASON],[REMARK],[VOUCHERNO],[VOUCHERDT],[BALANCE],[TDS],[STAX],[STATUS],[CANCEL_USERID],[CANCEL_DT],[CANCEL_REMARK],[USRID],[CREATION_DATE]

,[BILL_SEC_AMT],[BRANCH_CODE],[bkup_sno],[DISPUTE_FLAG],[DISPUTE_USER_CODE],[DISPUTE_DT],[DISPUTE_RMRK] from cir_outmast

where comp_code=@pcomp_code and DOCTYP=@pdoctyp and RECPTNO=@pdocno and RECPTDT=@pdocdt and billno is null and billdt is null)

end

end */

SET NOCOUNT OFF

END 

///////////////////////////////





ALTER
PROCEDURE [dbo].[cir_small_amt_writeoff_grid]

@pcomp_code
VARCHAR(4000) , --company code

@punit_code
VARCHAR(4000) , --printing center code

@Pbranch_code
VARCHAR(4000) , --branch code

@pjv_type
VARCHAR(4000) , --Debit/Credit

@pfrdt
VARCHAR(4000) , --from date

@ptodt
VARCHAR(4000) , --till date

@pag_main_code
VARCHAR(4000) , --agency main code

@pag_sub_code
VARCHAR(4000) , --agency sub code

@ppubl
VARCHAR(4000) , --publication

@pamount
FLOAT , --transaction amount

@pdateformat
VARCHAR(4000) , --date format

@puserid
VARCHAR(4000) ,

@pextra1
VARCHAR(4000) ,-- Agency Type

@pextra2
VARCHAR(4000) ,

@pextra3
VARCHAR(4000) ,

@pextra4
VARCHAR(4000) ,

@pextra5
VARCHAR(4000)

AS

BEGIN

SET NOCOUNT ON

DECLARE @vfrdt DATETIME

DECLARE @vtodt DATETIME

declare @vrec_message VARCHAR (500)

declare @v_idno decimal(5);

SELECT @vfrdt = CONVERT(DATETIME, @pfrdt)

SELECT @vtodt = CONVERT(DATETIME, @ptodt)

declare @cnt as int

select @cnt=count(*) from AD_WRITEOFF_SEQ

print(@cnt)

if(@cnt =0) begin

insert into AD_WRITEOFF_SEQ values(0)

end

else

begin

update AD_WRITEOFF_SEQ set nextval=isnull(nextval,0)+1

end

select @v_idno=nextval from AD_WRITEOFF_SEQ

IF isnull (@pjv_type, 'D') = 'D'

begin

print('hi')

SELECT d.comp_code comp_code, d.unit unit, d.unit_name unit_name, d.branch_code, d.branch_name,
       d.ag_main_code ag_main_code, d.ag_sub_code ag_sub_code, d.agency_name agency_name, d.doctype,
       dbo.ad_get_execname(d.comp_code, d.exec_code) executive_name,
       dbo.ad_get_retainer(d.comp_code, d.retainer_code) retainer_name,
       e.billno recptno, e.billdt recptdt, e.amount amount, d.agcode agcode, d.idno,
       d.docdt docdt, d.act_amt act_amt FROM ( SELECT a.comp_code comp_code,a.UNIT_CODE unit,
                                                  dbo.cir_get_unit_name(a.comp_code,a.unit_code) as UNIT_NAME,
                                                  a.BRANCH_CODE branch_code, c.Branch_Name branch_name, a.agcd ag_main_code,
                                                  a.dpcd ag_sub_code, b.AG_NAME agency_name, a.RECPTNO recptno,
                                                  a.RECPTDT recptdt, '' exec_code, '' retainer_code,
                                                  a.agcd + '`' + a.dpcd agcode, @v_idno as idno,
                                                  case @pdateformat when 'dd/mm/yyyy' then convert (varchar(10),a.RECPTDT,103)
                                                                    when 'mm/dd/yyyy' then convert (varchar(10),a.RECPTDT,101)
                                                                    when 'yyyy/mm/dd' then convert (varchar(10),a.RECPTDT,111) end as docdt ,
                                                  a.doctyp doctype, (select SUM(t.AMOUNT ) from CIR_RCPHDR t 
                                                                        where t.comp_code = @pcomp_code and t.recptdt=a.recptdt
                                                                          and t.recptno=a.recptno 
                                                                          and t.DOCTYPE=a.DOCTYP 
                                                                          and t.agcd=a.agcd 
                                                                          and t.dpcd=a.DPCD) act_amt
                                               FROM CIR_OUTMAST a,CIR_AGMAST b,branch_mst c
                                               WHERE a.comp_code = @pcomp_code 
                                                 AND a.comp_code = b.Comp_Code
                                                 AND (a.BRANCH_CODE = @Pbranch_code or @Pbranch_code is null or @Pbranch_code='')
                                                 AND a.BRANCH_CODE = c.Branch_Code 
                                                 AND a.RECPTDT >= @vfrdt 
                                                 AND a.RECPTDT <= @vtodt
                                                 AND (a.AGCD = ISNULL(@pag_main_code, a.agcd) or @pag_main_code='') 
                                                 AND a.AGCD = b.AGCD
                                                 AND (a.DPCD = ISNULL(@pag_sub_code, a.DPCD) or @pag_sub_code ='') 
                                                 AND a.DPCD = b.DPCD
                                                 and ((b.ag_type = @pextra1) or (@pextra1 is null) or (@pextra1=''))
                                                 AND ABS(a.amount) <= @pamount 
                                                 AND ISNULL(a.amount, 0) < 0 
                                                 AND a.billno is null
                                                group by a.comp_code,a.UNIT_CODE, a.BRANCH_CODE,
                                                         c.Branch_Name,a.AGCD,a.DPCD,
                                                         b.AG_NAME,a.billno,a.billdt,
                                                         a.doctyp,a.recptdt,a.recptno) d,
   (SELECT o.comp_code comp_code, o.RECPTDT billdt, o.RECPTNO billno,
           o.DOCTYP ,SUM(cast(o.amount as FLOAT)) amount FROM cir_outmast o
     WHERE o.comp_code = @pcomp_code
      AND (o.BRANCH_CODE = @Pbranch_code or @Pbranch_code is null or @Pbranch_code='')
      AND o.RECPTDT >= @vfrdt AND o.RECPTDT <= @vtodt
      AND (o.agcd = ISNULL(@pag_main_code, o.agcd) or @pag_main_code='')
      AND (o.dpcd = ISNULL(@pag_sub_code, o.dpcd) or @pag_sub_code ='') AND o.BILLNO is null
   GROUP BY o.comp_code, o.RECPTNO,o.RECPTDT ,o.DOCTYP
   HAVING SUM(abs(cast(o.amount as FLOAT))) <= @pamount 
   AND SUM(CONVERT(FLOAT, o.amount)) < 0 ) e
WHERE d.comp_code = e.comp_code AND d.recptno = e.billno AND d.recptdt = e.billdt AND e.amount < 0
--AND	abs(ISNULL(e.amount, 0))  > 0.01 
ORDER BY comp_code,ag_main_code,ag_sub_code,recptdt,recptno

end

ELSe IF isnull (@pjv_type, 'C') = 'C'

begin

print('hi2')

SELECT d.comp_code comp_code, d.unit unit, d.unit_name unit_name,d.branch_code,d.branch_name,d.ag_main_code ag_main_code,d.ag_sub_code ag_sub_code,d.agency_name agency_name

,d.doctype,dbo.ad_get_execname(d.comp_code, d.exec_code) executive_name,dbo.ad_get_retainer(d.comp_code, d.retainer_code) retainer_name

,e.billno recptno,e.billdt recptdt,e.amount amount,d.agcode agcode,d.idno,d.docdt docdt,d.act_amt act_amt

FROM (

SELECT a.comp_code comp_code,a.UNIT_CODE unit,dbo.cir_get_unit_name(a.comp_code,a.unit_code) as UNIT_NAME

,a.BRANCH_CODE branch_code,c.Branch_Name branch_name,

a
.agcd ag_main_code,a.dpcd ag_sub_code,b.AG_NAME agency_name,

a
.billno recptno,a.billdt recptdt,'' exec_code,'' retainer_code,a.agcd + '`' + a.dpcd agcode,@v_idno as idno,

case @pdateformat

when 'dd/mm/yyyy' then convert (varchar(10),a.billdt,103)

when 'mm/dd/yyyy' then convert (varchar(10),a.billdt,101)

when 'yyyy/mm/dd' then convert (varchar(10),a.billdt,111) end as docdt ,

a
.doctyp doctype ,

(case when a.doctyp='BIL' then

(select SUM(t.BILL_AMOUNT) from CIR_BILL t where t.comp_code = @pcomp_code

and t.BILLDT=a.billdt and t.billno=a.billno and t.agcd=a.agcd and t.DPCD=a.DPCD)

else

(select SUM(t.AMOUNT ) from CIR_RCPHDR t where t.comp_code = @pcomp_code and t.recptdt=a.recptdt

and t.recptno=a.recptno and t.DOCTYPE=a.DOCTYP and t.agcd=a.agcd and t.dpcd=a.DPCD)

end ) act_amt

FROM CIR_OUTMAST a,CIR_AGMAST b,branch_mst c

WHERE a.comp_code = @pcomp_code AND a.comp_code = b.Comp_Code

AND (a.BRANCH_CODE = @Pbranch_code or @Pbranch_code is null or @Pbranch_code='')

AND a.BRANCH_CODE = c.Branch_Code AND a.billdt >= @vfrdt AND a.billdt <= @vtodt
and ((b.ag_type = @pextra1) or (@pextra1 is null) or (@pextra1=''))
AND (a.AGCD = ISNULL(@pag_main_code, a.agcd) or @pag_main_code='') AND a.AGCD = b.AGCD

AND (a.DPCD = ISNULL(@pag_sub_code, a.DPCD) or @pag_sub_code ='') AND a.DPCD = b.DPCD

AND a.billno is not null AND ISNULL(a.amount, 0) > 0

group by a.comp_code,a.UNIT_CODE, a.BRANCH_CODE,c.Branch_Name,a.AGCD,a.DPCD,b.AG_NAME,a.billno,a.billdt,a.doctyp,a.recptdt,a.recptno

) d,

(SELECT o.comp_code comp_code,o.billdt billdt,o.billno billno,SUM(cast(o.amount as FLOAT)) amount FROM cir_outmast o

WHERE o.comp_code = @pcomp_code

AND (o.BRANCH_CODE = @Pbranch_code or @Pbranch_code is null or @Pbranch_code='')

AND o.billdt >= @vfrdt AND o.billdt <= @vtodt

AND (o.agcd = ISNULL(@pag_main_code, o.agcd) or @pag_main_code='')

AND (o.dpcd = ISNULL(@pag_sub_code, o.dpcd) or @pag_sub_code ='') AND o.billno is not null

GROUP BY o.comp_code, o.billno,o.billdt

HAVING SUM(cast(o.amount as FLOAT)) <= @pamount AND SUM(CONVERT(FLOAT, o.amount)) > 0 ) e

WHERE d.comp_code = e.comp_code AND d.recptno = e.billno AND d.recptdt = e.billdt 
--AND e.amount > 0
and ROUND((e.amount),2)>=0.01
ORDER BY comp_code,ag_main_code,ag_sub_code,recptdt,recptno

end

else

begin

set @vrec_message = 'Please select proper JV Type from List'

select @vrec_message

end

END 


/////////////////////////////////////END/////////////////////////

//=================add by Deepika 20/07/2013 sent by shushil sir////////////


ALTER PROCEDURE [dbo].[cir_agency_bind_cir_agency_listing_p]
@pcompcode

VARCHAR(20) ,
@punit

VARCHAR(20) ,
@pagty

VARCHAR(20) ,
@agcd

VARCHAR(20) ,
@dpcd

VARCHAR(20) ,
@pdateformat

VARCHAR(20) ,
@pextra1

varchar(200),----------agency class
@pextra2

varchar(200),---------- comm category
@pextra3

varchar(200),
@pextra4

varchar(200),
@pextra5

varchar(200),
@pextra6

varchar(200),
@pextra7

varchar(200),
@pextra8

varchar(200),
@pextra9

varchar(200),
@pextra10

varchar(200)
AS


select A.COMP_CODE,A.UNIT,A.BRANCH_CODE,C."Branch_Name" BRANCH_NAME, A.AGCD,A.DPCD,A.AG_NAME,A.AG_NAME_OTH_LANG,
A.AG_CLASS,(SELECT CLASS_DESC FROM CIR_AGENCY_CLASS_MAST WHERE CIR_AGENCY_CLASS_MAST.COMP_CODE=A.COMP_CODE AND CIR_AGENCY_CLASS_MAST.CLASS_CODE=A.AG_CLASS) AG_CLASS_NAME,
A.AG_TYPE,dbo.CIR_GET_AGENCY_TYPE(A.COMP_CODE,A.AG_TYPE) AG_TYPE_NAME, A.SUPPLY_START_DT,A.CITY_CODE,dbo.CIR_GET_CITY(A.COMP_CODE,A.CITY_CODE)CITY_NAME,

----CHANGE HERE
(A.ADDR1 + ',' + A.ADDR2+ ',' + A.ADDR3+ ',' + dbo.CIR_GET_CITY(A.COMP_CODE,A.CITY_CODE) + ',' + cast(A.PIN_CODE as varchar)) AS ALL_ADDRESS, 

A.DIST_CODE,DBO.CIR_GET_DIST(A.COMP_CODE,A.STATE_CODE,A.DIST_CODE) DIST_NAME,
A.STATE_CODE,DBO.CIR_GET_STATE(A.COMP_CODE,A.COUNTRY_CODE,A.STATE_CODE) STATE_NAME, A.TEHSIL_TALUKA TALUKA_CODE,DBO.CIR_GET_TALUKA(A.COMP_CODE,A.TEHSIL_TALUKA) TALUKA_NAME,
A.STATION_CODE,DBO.CIR_GET_DROP_POINT_NAME(A.COMP_CODE,A.UNIT,A.STATION_CODE,1) DROP_POINT_NAME,
A.AREA_CODE,DBO.CIR_GET_AREA(A.COMP_CODE,A.AREA_CODE) AREA_NAME, A.PHONE_NO1, A.PHONE_NO2, A.MOBILE_NO1, A.MOBILE_NO2,A.FAX_NO, A.EMAIL_ID, A.SUSPEND, A.SUSPEND_TYPE, A.SUSPEND_DATE,
A.TO_BILL, A.BILL_AGCD, A.BILL_DPCD,DBO.CIR_GET_AGENCY(A.COMP_CODE,A.UNIT,A.BILL_AGCD,A.BILL_DPCD) BILL_AGENCY, A.PAYMODE, A.CREDIT_DAYS, A.PRINT_LABEL, A.PIN_PACKET,
A.PIN_AGCD, A.PIN_DPCD,DBO.CIR_GET_AGENCY(A.COMP_CODE,A.UNIT,A.PIN_AGCD,A.PIN_DPCD) PIN_AGENCY, A.PIN_OPEN_INSIDE,
A.NAME_ON_LABEL, A.PRINT_SEQ,CASE WHEN A.UNSOLD_VALID_FLAG='D' THEN 'Daily' WHEN A.UNSOLD_VALID_FLAG='W' THEN 'Weekly' ELSE 'Monthly' END BILL_CYCLE,
A.SECURITY_PER, A.SEC_AMT_LIMT, A.SUPPLY_STOP_FLAG, A.SUPPLY_STOP_PER, A.ABC_CITYCODE,DBO.CIR_GET_CITY(A.COMP_CODE,A.ABC_CITYCODE) ABC_CITY_NAME,
B.NAME CON_PER_NAME,B.DESIG CON_PER_DESIG,B.PER_ROLE CON_PER_PER_ROLE,B.DATE_OF_BIRTH DATE_OF_BIRTH, B.PHONE_NO1 CON_PER_PHONE_NO1, B.PHONE_NO2 CON_PER_PHONE_NO2,
B.MOBILE_NO1 CON_PER_MOBILE_NO1, B.MOBILE_NO2 CON_PER_MOBILE_NO2, B.FAX_NO CON_PER_FAX_NO, B.EMAIL_ID CON_PER_EMAIL_ID

------new add

,(A.H_ADDR1 + ',' + A.H_ADDR2+ ',' + A.H_ADDR3+ ',' + dbo.CIR_GET_CITY(A.COMP_CODE,A.H_CITY_CODE)) AS H_ALL_ADDRESS ,A.PIN_CODE as PIN_CODE
---new add
,(select DBO.cir_get_supply_name(A.COMP_CODE,MAX(supply_type_code)) from CIR_SUPPLY where comp_code = a.comp_code and unit = a.unit and agcd = a.agcd and dpcd = a.dpcd) as SUPPLY_TYPE


FROM cir_agmast a LEFT OUTER JOIN cir_ag_con_per b ON a.comp_code = b.comp_code
AND a.unit = b.unit
AND a.agcd = b.agcd
AND a.dpcd = b.dpcd ,
--LEFT OUTER JOIN cir_supply d ON a.comp_code = d.comp_code
--AND a.unit = d.unit
--AND a.agcd = d.agcd
--AND a.dpcd = d.dpcd ,
branch_mst c

WHERE a.comp_code = @pcompcode
AND (a.unit = @punit OR @punit is null OR @punit ='')
AND (a.AGCD =@agcd OR @agcd IS NULL OR @agcd='')
AND (a.DPCD=@dpcd or @dpcd is null or @dpcd='')
AND a.branch_code = c.Branch_Code
AND (ag_type = @pagty OR @pagty is null OR @pagty ='')
AND (ag_class = @pextra1 OR @pextra1 is null OR @pextra1 ='')
--AND (d.comm_code = @pextra2 OR @pextra2 is null OR @pextra2 ='')
order by a.comp_code,a.unit,a.ag_name, b.name


///////////////////////////




create PROCEDURE [dbo].[CIR_CIRCULATION_FINANCE_RECON] (@PCOMP_CODE  VARCHAR(50),
                                                @PUNIT_CODE  VARCHAR(50),
												@PBRAN_CODE  VARCHAR(50),
												@PPUBL_CODE  VARCHAR(50),
												@PEDTN_CODE  VARCHAR(50),
												@PAG_TYPE    VARCHAR(50),
												@PAG_CLASS   VARCHAR(50),
												@PAGCD       VARCHAR(50),
                                                @PDPCD       VARCHAR(50),
												@PFRDATE     DATETIME,
												@PTODATE     DATETIME,
												@PDATEFORMAT VARCHAR(50),
												@PUSERID     VARCHAR(50),
												@PEXTRA1     VARCHAR(50),
												@PEXTRA2     VARCHAR(50),
												@PEXTRA3     VARCHAR(50),
												@PEXTRA4     VARCHAR(50),
												@PEXTRA5     VARCHAR(50)) AS
BEGIN
 
  --EXEC CIR_CIRCULATION_FINANCE_RECON ('TN001','WIN','WIN','','','','','','','05/01/2013','05/31/2013','MM/DD/YYYY','AD01','','','','',''

  SELECT * FROM CIRCULATION_FINANCE_BILLING 
     WHERE COMP_CODE = @PCOMP_CODE
	   AND ((UNIT_CODE = @PUNIT_CODE) OR (@PUNIT_CODE IS NULL) OR (@PUNIT_CODE=''))
	   AND ((BRANCH_CODE = @PBRAN_CODE) OR (@PBRAN_CODE IS NULL) OR (@PBRAN_CODE=''))
	   AND ((PUBL = @PPUBL_CODE) OR (@PPUBL_CODE IS NULL) OR (@PPUBL_CODE=''))
	   AND ((AG_TYPE = @PAG_TYPE) OR (@PAG_TYPE IS NULL) OR (@PAG_TYPE=''))
	   AND ((AG_CLASS = @PAG_CLASS) OR (@PAG_CLASS IS NULL) OR (@PAG_CLASS=''))
	   AND ((AGCD = @PAGCD) OR (@PAGCD IS NULL) OR (@PAGCD=''))
	   AND ((AGCD = @PDPCD) OR (@PDPCD IS NULL) OR (@PDPCD=''))
	   AND BILLDT BETWEEN @PFRDATE AND @PTODATE
	 ORDER BY 1
END



///////////////////////////////

ALTER procedure [dbo].[Cir_Agencywise_Receipt_untag]

@pcompcode varchar(8),
@pfrom_date varchar(30),
@pto_date varchar(30),
@pdoctype varchar(20),
@pagency varchar(25),
@punit    varchar(50),
@pdateformat   VARCHAR(20),
@pdpcd   VARCHAR(20)

AS

declare @v_val as float
declare @query1 as varchar(2000)
if @punit is null
   set @punit = ''
if @pdoctype is null
   set @pdoctype = ''   
  Begin
		set @query1='SELECT AGCD as agcode,AGCD as ag_main_code,DPCD as ag_sub_code,doctyp AS DOCTYPE,recptno AS RECEIPT_NO,
		case '''+@pdateformat+'''
		when ''mm/dd/yyyy'' then convert(varchar(10),recptdt,101)
		when ''dd/mm/yyyy'' then convert(varchar(10),recptdt,103)
		when ''yyyy/mm/dd'' then convert(varchar(10),recptdt,111) end AS RECEIPT_DATE,chno AS CHEQUE_NO ,
		case '''+@pdateformat+'''
		when ''mm/dd/yyyy'' then convert(varchar(10),chdt,101)
		when ''dd/mm/yyyy'' then convert(varchar(10),chdt,103)
		when ''yyyy/mm/dd'' then convert(varchar(10),chdt,111) end  AS CHEQUE_DATE,
		billno AS BILL_NO,
		case '''+@pdateformat+'''
		when ''mm/dd/yyyy'' then convert(varchar(10),billdt,101)
		when ''dd/mm/yyyy'' then convert(varchar(10),billdt,103)
		when ''yyyy/mm/dd'' then convert(varchar(10),billdt,111) end   AS BILL_DATE,
		round(ABS(amount),2) AS AMOUNT, 
		dbo.cir_get_agency('''+@pcompcode+''','''+@punit+''',agcd,dpcd) as "agname"
		,(select abs(sum(amount)) from cir_rcphdr b where b.comp_code=a.comp_code 
		and b.unit_code=a.unit_code and b.recptno=a.recptno) as "total_amount" 
,a.unit_code,(select top 1"remark" from cir_rcphdr where "recptno"=a.recptno)AS "remark",
(select "Branch_Name" from branch_mst where "Branch_Code"=a.UNIT_CODE )AS "Branch_Name"
		FROM cir_outmast a
		WHERE  recptno  IS NOT NULL AND  recptdt  IS NOT NULL 
		and billno is null and billdt is null and amount != ''0''
		AND (comp_code='''+@pcompcode+''' OR '''+@pcompcode+''' IS NULL) 
		AND ( doctyp ='''+@pdoctype+''' OR '''+@pdoctype+''' IS NULL OR '''+@pdoctype+'''='''+''+''') 
		
		AND  recptdt  BETWEEN '''+@pfrom_date+''' AND '''+@pto_date+''' 
		AND (unit_code ='''+@punit+''' OR '''+@punit+''' IS NULL OR '''+@punit+'''='''+''+''')'
    End 
	
print @pagency

if(@pagency is not null and @pagency !='')
begin
set @query1=@query1+ 'AND ( agcd = '''+@pagency+''' OR '''+@pagency+''' IS NULL) AND ( dpcd = '''+@pdpcd+''' OR '''+@pdpcd+''' IS NULL)'

end

set @query1=@query1+ ' ORDER BY  recptdt,doctype,recptno' ; 

exec(@query1);
print(@query1)







////////////////////////////////////////////////////end///////////////////////////////////////////




//====================add by deepika 29-aug-2013============







create procedure cir_get_unsold_receiptno
(
@pcomp_code         varchar(50),
@punit_code         varchar(50),
@pbranch_code       varchar(50),
@pdoctype           varchar(50),
@pagcd              varchar(50),
@pdpcd              varchar(50),
@precptdt           datetime,
@pextra1             varchar(10),
@pextra2             varchar(10),
@pextra3            varchar(10),
@pextra4            varchar(10),
@pextra5            varchar(10))
as
begin

select distinct RECPTNO,RECPTDT from cir_unsold_dtl
 where  comp_code    = @pcomp_code
    and UNIT_CODE    = @punit_code
	and DOCTYPE      = @pdoctype
	and agcd         = @pagcd
	and dpcd         = @pdpcd
	and RECPTDT      = @precptdt
  

end




create procedure cir_unapproved_approved_unsol (@pcomp_code varchar(50),
                                                @punit_code varchar(50),
												@pbranch_code varchar(50),
									            @pdoctype   varchar(50),
									            @pagcd      varchar(50),
									            @pdpcd      varchar(50),
									            @precptdt   datetime,
												@precptno   varchar(50),
												@pextra1    varchar(10),
												@pextra2    varchar(10),
												@pextra3    varchar(10),
												@pextra4    varchar(10),
												@pextra5    varchar(10)) as
Begin
  Declare @v_cond_no    int
  Declare @v_bill_exist int
  Declare @v_message    varchar(1000)
  Declare @v_frdt       datetime
  Declare @v_todt       datetime
  Begin
    
	 if @precptno is null or @precptno = '' or len(@precptno)<2
	    Begin
		   set @v_message = 'Please Select the proper Receipt No.'
		   set @v_cond_no = 1
		End
     Else
        Begin
		   set @v_message = null
		End
    select @v_frdt = min(frdt), @v_todt = max(todt) from cir_unsold_hdr
	  where comp_code = @pcomp_code
	    and unit_code = @punit_code
		and agcd      = @pagcd
		and dpcd      = @pdpcd
		and recptdt   = @precptdt 
		and recptno   = @precptno
   
    select @v_bill_exist = count(*) from cir_bill
	  where comp_code = @pcomp_code
	    and unit_code = @punit_code
		and agcd      = @pagcd
		and dpcd      = @pdpcd
		and bill_frdt = @v_frdt
		and bill_todt = @v_todt

    if isnull(@v_bill_exist,0)>0
	    Begin
		   set @v_message = 'Invoice Already Generated Against This Receipt. So That You Can not Un-Approved This Receipt.'
		   set @v_cond_no = isnull(@v_cond_no,0)+1
		End

    If isnull(@v_cond_no,0)=0 
	   Begin
	     update cir_unsold_hdr set APP_DT=null,APP_USERID=null 
		   where comp_code = @pcomp_code
	         and unit_code = @punit_code
		     and agcd      = @pagcd
		     and dpcd      = @pdpcd
		     and recptdt   = @precptdt 
		     and recptno   = @precptno

         update cir_unsold_dtl set apr_short_recpt = 0, apr_late_recpt = 0, apr_bnr = 0, apr_unsold = 0, APP_DT = null, APP_USERID = null 
		   where comp_code = @pcomp_code
	         and unit_code = @punit_code
		     and agcd      = @pagcd
		     and dpcd      = @pdpcd
		     and recptdt   = @precptdt 
		     and recptno   = @precptno

         set @v_message = 'Unsold Un-Approved Successfully.'
		 
	   End
	   select @v_message as MASSEGE
  End


End


///////////////////////////////////end/////////////////////////

///=============add by deepika 09/sep-2013






create procedure [dbo].[cir_update_supply] (@pcomp_code     as varchar(50),
                                                                         @punit_code     as varchar(50),
                                                                         @ppubl          as varchar(50),
                                                                         @pedtn          as varchar(50),
                                                                         @pagcd          as varchar(50),
                                                                         @pdpcd          as varchar(50),
                                                                         @psup_type_code as varchar(50),
                                                                         @psupdate       as datetime,
                                                                         @psup_copy      as int,
                                                                         @pdateformat    as varchar(50),
																		 @check_type    as varchar(20), -- CHECKSUPPLY for count, SUPPLYUPDATE for  supply update
                                                                         @pextra1        as varchar(50),
                                                                         @pextra2        as varchar(50),
                                                                         @pextra3        as varchar(50),
                                                                         @pextra4        as varchar(50),
                                                                         @pextra5        as varchar(50)) as



	 DECLARE @v_count  		NUMERIC(7)	
	  DECLARE @v_massege    varchar(100)																
 Begin  

 if(isnull(@check_type,'')='CHECKSUPPLY')
	 BEGIN
		 select @v_count= count(*) from  cir_dbksup 
                       where comp_code     = @pcomp_code
                         and unit_code     = @punit_code
                         and publ          = @ppubl
                         and edtn          = @pedtn
                         and agcd          = @pagcd
                         and dpcd          = @pdpcd
                         and sup_type_code = @psup_type_code
                         and supdate       = @psupdate

				if(isnull(@v_count,0)>0)
						begin
						  set @v_massege = 'This Agency Supply is already Posted for this Date '
						  select ISNULL(@v_count,0) as REC_COUNT,@v_massege as MASSEGE
						end
				else
						begin
						  set @v_massege = ''
						  select  ISNULL(@v_count,0) as REC_COUNT,@v_massege as MASSEGE
						end 
    
		END

	if(isnull(@check_type,'')='SUPPLYUPDATE')
		BEGIN
	
                update cir_dbksup set sup_copy = @psup_copy
                       where comp_code     = @pcomp_code
                         and unit_code     = @punit_code
                         and publ          = @ppubl
                         and edtn          = @pedtn
                         and agcd          = @pagcd
                         and dpcd          = @pdpcd
                         and sup_type_code = @psup_type_code
                         and supdate       = @psupdate

						 set @v_massege = 'Supply Posted Successfully'
						   select @v_massege as MASSEGE
	     
		END
			
  End

*******************************************************




create FUNCTION [dbo].[cir_get_backdays_validate1](
    @pcomp_code  as varchar(20),
    @punit_code  as varchar(20),
    @pmodule_id  as varchar(20),
    @pformname   as varchar(100),
    @puserid     as varchar(50),
    @pentry_date as datetime,
    @pdateformat as varchar(50),
    @pextra1     as varchar(200),
    @pextra2     as varchar(200),
    @pextra3     as varchar(200),
    @pextra4     as varchar(200),
    @pextra5     as varchar(200)) returns varchar(1) as
Begin
    declare @v_user_backdays int
    declare @v_comp_backdays int
    declare @v_backdays      int
    declare @v_dt            datetime
    declare @v_curr_dt       datetime
    declare @v_validate      varchar(1)
	declare @v_rec_count	 int

	set @v_validate      ='N'
    set @v_dt=@pentry_date
	set @v_curr_dt= CONVERT(VARCHAR(10), GETDATE(), 101)

	IF @v_curr_dt >= @v_dt and @v_dt is not null 
	Begin
		--set @v_backdays  = DATEDIFF(dd,@v_curr_dt , @v_dt )
		set @v_backdays  = DATEDIFF(dd,@v_dt , @v_curr_dt )

		select @v_comp_backdays=back_days from preferrences where "comp_code"=@pcomp_code

		select @v_rec_count=count(*) from module_user_rights r,module_form_mast m 
		where r.comp_code=@pcomp_code and r.unit_code=@punit_code and r.user_code=@puserid and r.module_id=m.module_id and 
		r.module_id=@pmodule_id and r.form_id=m.form_id and form_name=@pformname
		
		If @v_rec_count=0 
			Begin
				set @v_user_backdays=@v_comp_backdays
			End
		Else 
			Begin
				select @v_user_backdays=back_days from module_user_rights r,module_form_mast m 
				where r.comp_code=@pcomp_code and r.unit_code=@punit_code and r.user_code=@puserid and r.module_id=m.module_id and 
					r.module_id=@pmodule_id and r.form_id=m.form_id and form_name=@pformname
			End	

		If isnull(@v_user_backdays,0)>= @v_backdays 
			Begin
				return 'Y'
			End
	    Else 
			Begin
				return 'N'
			End
	End
    Else 
	Begin
        If upper(@pformname)=upper('cir_supplyposting') 
			Begin
				return 'Y'
			End
        Else 
			Begin
				return 'N'
			End
    End
	return 'N'
End

********************************




create PROCEDURE [dbo].[cir_publ_bind_for_agency]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@pbran_code                               VARCHAR(20) ,
	@pagcd                                    VARCHAR(20) ,
	@pdpcd                                    VARCHAR(20) ,
	@ppubl                                    VARCHAR(20) ,
	@pedtn                                    VARCHAR(20) ,
	@ptype                                    VARCHAR(50) ,-- For Publication 'PUBLICATION' For Edition 'EDITION' For Supply Type 'SUPPLYTYPE'
	@puserid                                  VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
	
AS 
BEGIN	
	if isnull(@ptype,'?') = 'PUBLICATION'
	   Begin
			SELECT * FROM cir_publ_mast 
			  WHERE comp_code  = @pcomp_code
				AND	((UPPER(publ_name)  like UPPER(@pextra1) + '%')	 OR	(@pextra1  is null) OR (@pextra1='')) 
				and publ in (select publ from cir_supply 
							   where comp_code = @pcomp_code
								 and unit      = @punit_code
								 and agcd      = @pagcd
								 and dpcd      = @pdpcd)
       End

    if isnull(@ptype,'?') = 'EDITION'
	   Begin
			SELECT * FROM cir_edtn_mast 
			  WHERE comp_code  = @pcomp_code
			    and publ       = @ppubl
				AND	((UPPER(edtn_name)  like UPPER(@pextra1) + '%')	 OR	(@pextra1  is null) OR (@pextra1='')) 
				and edtn in (select edtn from cir_supply 
							   where comp_code = @pcomp_code
								 and unit      = @punit_code
								 and publ      = @ppubl
								 and agcd      = @pagcd
								 and dpcd      = @pdpcd)
       End
    if isnull(@ptype,'?') = 'SUPPLYTYPE'
	   Begin
			SELECT * FROM cir_supply_type_mast
			  WHERE comp_code  = @pcomp_code
			   	AND	((UPPER(sup_ty_name)  like UPPER(@pextra1) + '%')	 OR	(@pextra1  is null) OR (@pextra1='')) 
				and sup_ty_code in (select supPLY_tyPE_code from cir_supply 
									   where comp_code = @pcomp_code
										 and unit      = @punit_code
										 and publ      = @ppubl
										 and EDTN      = @pedtn
										 and agcd      = @pagcd
								         and dpcd      = @pdpcd)
       End

END


////////////////////////////////ens/////////////////