/////////////////////////ADD BY DEEPIKA 08/10/2012 SENT BY AMIT SIR///////////

create procedure cir_gen_statement_no_p
@comp_code			varchar(10),
@unit_code			varchar(10),
@branch_code		varchar(10),
@agcd				varchar(20),
@dpcd				varchar(10),
@processdt			varchar(10),
@freq				varchar(1),
@dateformate		varchar(10),
@extra1				varchar(10),
@extra2				varchar(10),
@extra3				varchar(10),
@extra4				varchar(10),
@extra5				varchar(10)
As
Begin

	declare @vno	as varchar(20)
	declare @lno    as NUMERIC
	declare @vdate  as varchar(20)
	print(@processdt)
			SELECT @freq=AGEING_TYPE from CIR_AGMAST where comp_code=@comp_code and UNIT=@unit_code
			and branch_code=@branch_code and agcd=@agcd and dpcd=@dpcd
	if(@freq='D')
		begin
			select @vno= u_no from CIR_BILL_STATEMENT_NO where comp_code=@comp_code and unit_code=@unit_code
			and branch_code=@branch_code and agcd=@agcd and dpcd=@dpcd and PROCESS_DT=@processdt
			and freq=@freq
			
			SET @vdate=@processdt
		end
	 if(@freq='W')
		begin
			SELECT @vdate=DATEADD(ww, DATEDIFF(ww,0,@processdt), 0)  /*for chek the first day of week*/
			
			select @vno= u_no from CIR_BILL_STATEMENT_NO where comp_code=@comp_code and unit_code=@unit_code
			and branch_code=@branch_code and agcd=@agcd and dpcd=@dpcd and  freq=@freq and PROCESS_DT=@vdate
		end	
	if @freq='M'
	 begin
			
			SELECT @vdate=DATEADD(dd,-(DAY(DATEADD(mm,1,@processdt))-1),DATEADD(mm,-0,@processdt)) /*for chek the first day of month*/
			
			select @vno= u_no from CIR_BILL_STATEMENT_NO where comp_code=@comp_code and unit_code=@unit_code
			and branch_code=@branch_code and agcd=@agcd and dpcd=@dpcd and  freq=@freq and PROCESS_DT=@vdate
	 end
	 print(@vdate)
	 print(@vno)
	if (@vno='' OR @vno IS NULL)
	begin
			select @lno=MAX(substring(u_no,7,13))+1 from CIR_BILL_STATEMENT_NO where comp_code=@comp_code 
			and unit_code=@unit_code and freq=@freq
			print('a')
			if @freq='D'
			begin
					if isnull(@lno,0)=0
					begin
						set @vno='D-'+@unit_code+'-0000001'		
					end
					else
					begin
						set @vno='D-'+@unit_code+'-'+dbo.fnPadLeft('0',7,@lno) 
					end
			end
			if @freq='W'
			begin
					if isnull(@lno,0)=0
					begin
						set @vno='W-'+@unit_code+'-0000001'		
					end
					else
					begin
						set @vno='W-'+@unit_code+'-'+dbo.fnPadLeft('0',7,@lno) 
					end
			end
			if @freq='M'
			begin
					if isnull(@lno,0)=0
					begin
						set @vno='M-'+@unit_code+'-0000001'		
					end
					else
					begin
						set @vno='M-'+@unit_code+'-'+dbo.fnPadLeft('0',7,@lno) 
					end
			end
			insert into CIR_BILL_STATEMENT_NO(COMP_CODE,UNIT_CODE,BRANCH_CODE,AGCD,DPCD,PROCESS_DT,FREQ,U_NO) values(@comp_code,@unit_code,@branch_code,@agcd,@dpcd,@vdate,@freq,@vno)
			
			
		end
		select @vno as U_ID
		end

///////////////////////////////////////////////////////END///////////////////////////////////////////////////

///////////////////////////////add by deepika 08/10/2012 sent by gaurav sir//////////////////


ALTER PROCEDURE [dbo].[cir_fetch_suppliment_data_p]
	@pcompcode                                VARCHAR(40) ,
	@punitcode                                VARCHAR(40) ,
	@pagtype                                  VARCHAR(40) ,
	@pagclass                                 VARCHAR(40) ,
	@psup_type                                VARCHAR(40) ,
	@pagcode                                  VARCHAR(40) ,
	@pdepocode                                VARCHAR(40) ,
	@pcode                                    VARCHAR(4000) ,
	@pprocesstype                             VARCHAR(4000) ,---process by Zone.Region,Branch,District,Route
	@pdatefrom                                datetime ,
	@pdatetill                                datetime ,
	@pedtncode_val                            VARCHAR(4000) ,--for edition code
	@psupdate_val                             VARCHAR(4000) ,--for supply date
	@pinc_rate_val                            VARCHAR(4000) ,--for insertion rate
	@psupl_no_val                             VARCHAR(4000) ,--for no. of insertion
	@psupl_name_val                           VARCHAR(4000) ,--for suppliment name
	@pdelimiter                               VARCHAR(4000) ,
	@puserid                                  VARCHAR(40) ,
	@pdateformat                              VARCHAR(40) ,
	@pextra1                                  VARCHAR(400) ,
	@pextra2                                  VARCHAR(400) ,
	@pextra3                                  VARCHAR(400) ,
	@pextra4                                  VARCHAR(400) ,
	@pextra5                                  VARCHAR(400)
AS 
BEGIN
	DECLARE @vlength                                  NUMERIC(7) 
	DECLARE @vrunval                                  VARCHAR(8000) 
	DECLARE @v_val                                    VARCHAR(800) 
	DECLARE @v_name                                   VARCHAR(8000) 
	DECLARE @v_sname                                  VARCHAR(8000) 
	DECLARE @vno                                      FLOAT                           
	SET @vno = 0 
	DECLARE @v_frdt                                   DATETIME 
	DECLARE @v_todt                                   DATETIME 
	DECLARE @v_doctype                                VARCHAR(10)                     
	SET @v_doctype = 'CN' 
	DECLARE @v_recptdt                                DATETIME 
	DECLARE @v_dt                                     DATETIME 
	DECLARE @v_sess_id                                VARCHAR(30) 

		
	DECLARE @v1                                       VARCHAR(200) 
	DECLARE @v_amt                                    NUMERIC(15,2) 
	DECLARE @v_remark                                 VARCHAR(500) 
	DECLARE @v_recptno                                VARCHAR(50) 
	DECLARE @v_dsign                                  NUMERIC(5) 
	DECLARE @v_bran_code                              VARCHAR(20) 
	DECLARE @v_rec_no                                 NUMERIC(10) 
	DECLARE @v_unsold_copy                            NUMERIC(10) 
	DECLARE @vdistcode                                VARCHAR(4000) 
	DECLARE @vtalukacode                              VARCHAR(4000) 
print ('**')	
	SET @v_recptdt  = @pdatetill--CONVERT(DATETIME, @pdatetill)
	
	CREATE TABLE #CIR_LEDGER_REPORT
	(COMP_CODE		VARCHAR(100),
	 UNIT_CODE		VARCHAR(100),
	 DEBIT_HEAD		VARCHAR(100),
	 REC_SEQNO		INT)

CREATE TABLE #CIR_TEMP_SUPPLIMENT
( COMP_CODE     VARCHAR(10),
  UNIT_CODE     VARCHAR(10),
  SEQ_NO        NUMERIC(5),
  EDITION_CODE  VARCHAR(10),
  SUP_DATE      DATETIME,
  INC_RATE      NUMERIC(10,2),
  NOOF_SUPL     NUMERIC(3),
  SUPL_NAME     VARCHAR(100),
  SESS_ID       INT )

	If @pagtype='' Begin
		set @pagtype=null
	End
	If @pagclass='' Begin
		set @pagclass=null
	End
	If @psup_type='' Begin
		set @psup_type=null
	End
	If @pagcode='' Begin
		set @pagcode=null
	End
	If @pdepocode='' Begin
		set @pdepocode=null
	End
	If @pcode='' Begin
		set @pcode=null
	End
	If @pprocesstype='' Begin
		set @pprocesstype=null
	End

	If @pextra1='' Begin
		set @pextra1=null
	End									
	If @pextra2='' Begin
		set @pextra2=null
	End
	If @pextra3='' Begin
		set @pextra3=null
	End									
	If @pextra4='' Begin
		set @pextra4=null
	End
	If @pextra5='' Begin
		set @pextra5=null
	End
	  	  
	DELETE FROM   cir_supl_process_det_temp WHERE  recptno  = '''' + cast(@@SPID as varchar) + '''' 
	
	
print('8')
print(@@SPID )
		SET @v_sess_id  =  @@SPID
		
		/* for  Edition Code */
		
		SET @vlength  = null SET @vrunval  = null 
		SET @v_val  = REPLACE(@pedtncode_val, @pdelimiter, ',')
		SET @vlength  = LEN(@v_val)SET @vno  = 1
		print(@v_val)
		DECLARE	@i	INT
		SET @i  = 1

		WHILE @i <= @vlength BEGIN
			SET @vrunval  = SUBSTRING(@v_val, @i, 1) 
			print('@vrunval')
			print(@vrunval)
			IF @vrunval != ',' BEGIN 
				SET @v_name  = isnull(@v_name,'') + @vrunval 
			END
			ELSE BEGIN 
			print('@v_name')
			print(@v_name)
				INSERT INTO  #cir_temp_suppliment( comp_code , unit_code , seq_no , edition_code)  
				 VALUES ( @pcompcode , @punitcode , @vno , @v_name)  
				
				SET @vno  = @vno + 1 
				SET @v_name  = '' 
			END
			SET @i = @i + 1
		END
		
		/* for Supply Date */
	
		SET @vrunval	= null 
		SET @v_name		= null SET @v_sname  = null 
		SET @v_val		= REPLACE(@psupdate_val, @pdelimiter, ',')
		SET @vlength	= LEN(@v_val)
		SET @vno  = 1 SET @i = 1 

		WHILE @i <= @vlength BEGIN
		
			SET @vrunval  = SUBSTRING(@v_val, @i, 1)
			IF @vrunval != ',' BEGIN 
				SET @v_name  = isnull(@v_name,'') + @vrunval 
			END
			ELSE 
			BEGIN 
				declare @dd as varchar(2)
				declare @mm as varchar(2)
				declare @yyyy as varchar(4)
				if @pdateformat='dd/mm/yyyy' 
				begin
					set @dd= substring(@v_name,1,2)
					set @mm= substring(@v_name,4,2)
					set @yyyy=substring(@v_name,7,4)
					set @v_name=@mm +'/'+@dd+'/'+@yyyy
				end
				else if @pdateformat='yyyy/mm/dd' 
				begin
					set @yyyy= substring(@v_name,1,4)
					set @mm= substring(@v_name,6,2)
					set @dd=substring(@v_name,9,2)
					set @v_name=@mm +'/'+@dd+'/'+@yyyy
				end
					SET @v_dt  = CONVERT(DATETIME, @v_name)
					UPDATE  #cir_temp_suppliment SET	sup_date = @v_dt WHERE seq_no  = @vno

					SET @vno  = @vno + 1 
					SET @v_name  = '' 
				
			END
			SET @i = @i + 1
		END
		/* for Incanctive Per Copy Rate */
		
		SET @vrunval  = null 
		SET @v_name  = null 
		SET @v_sname  = null 
		SET @v_val  = REPLACE(@pinc_rate_val, @pdelimiter, ',')
		SET @vlength  = LEN(@v_val)
		SET @vno  = 1 SELECT @i = 1 

		WHILE @i <= @vlength BEGIN
			SET @vrunval  = SUBSTRING(@v_val, @i, 1)
			IF @vrunval != ',' BEGIN 
				SET @v_name  = isnull(@v_name,'') + @vrunval 
			END
			ELSE BEGIN 
				UPDATE  #cir_temp_suppliment SET	inc_rate = (@v_name) WHERE  seq_no  = @vno
				
				SET @vno  = @vno + 1 
				SET @v_name  = '' 
			END
			SET @i = @i + 1
		END
	
		/* for No of Supl */
		
		SET @vrunval  = null 
		SET @v_name  = null 
		SET @v_sname	= null 
		SET @v_val		= REPLACE(@psupl_no_val, @pdelimiter, ',')
		SET @vlength	= LEN(@v_val) SET @vno  = 1 SET @i = 1 
		
		WHILE @i <= @vlength BEGIN
			SET @vrunval  = SUBSTRING(@v_val, @i, 1)
			IF @vrunval != ',' 
			BEGIN 
				SET @v_name  = isnull(@v_name,'') + @vrunval 
			END
			ELSE BEGIN 
				UPDATE  #cir_temp_suppliment  SET	noof_supl = (@v_name) WHERE  seq_no  = @vno
				
				SET @vno  = @vno + 1 
				SET @v_name  = '' 
			END
			SET @i = @i + 1
		END
		
		/* for Supl Name*/
		
		SET @v_val  = null SET @vrunval  = null 
		SET @v_name = null SET @v_sname  = null 
		SET @v_val  = REPLACE(@psupl_name_val, @pdelimiter, ',')
		SET @vlength= LEN(@v_val)
		SET @vno	= 1 SET @i = 1 

		WHILE @i <= @vlength BEGIN
			SET @vrunval  = SUBSTRING(@v_val, @i, 1)
			IF @vrunval != ',' BEGIN 
				SET @v_sname  = isnull(@v_sname,'') + @vrunval 
			END
			ELSE BEGIN 
				UPDATE  #cir_temp_suppliment  SET	supl_name = (@v_sname) WHERE  seq_no  = @vno
				
				SET @vno  = @vno + 1 
				SET @v_name  = '' 
			END
			SET @i = @i + 1
		END

		IF @pcode IS NOT NULL or @pcode<>'' BEGIN 
			SET @vdistcode  = @pcode  + ''',''' 
			SET @v_name  = null 
			SET @vrunval  = null 
			SET @v_val  = REPLACE(@vdistcode, ',', ',')
			SET @vlength  = LEN(@v_val)
			SET @vno  = 1 
			SET @i = 1 

			WHILE @i <= @vlength BEGIN
				SET @vrunval  = SUBSTRING(@v_val, @i, 1)
				IF @vrunval != ',' BEGIN 
					SET @v_name  = isnull(@v_name,'') + @vrunval 
				END
				ELSE BEGIN 
					INSERT INTO  #cir_ledger_report   
							( comp_code , unit_code , debit_head, rec_seqno)  
					 VALUES ( @pcompcode , @punitcode , @v_name , @vno)  
					
					SET @vno  = @vno + 1 
					SET @v_name  = '' 
				END
				SET @i = @i + 1
			END
		END
		
		
	DECLARE @c1_comp_code	VARCHAR(40)
	DECLARE @c1_unit_code	VARCHAR(40) 
	DECLARE @c1_publ		VARCHAR(40) 
	DECLARE @c1_edtn		VARCHAR(40) 
	DECLARE @c1_supdate		DATETIME 
	DECLARE @c1_agcd		VARCHAR(40) 
	DECLARE @c1_dpcd		VARCHAR(40) 
	DECLARE @c1_billagcd	VARCHAR(40) 
	DECLARE @c1_billdpcd	VARCHAR(40) 
	DECLARE @c1_inc_rate	NUMERIC(15,2)
	DECLARE @c1_no_of_supl  INT
	DECLARE @c1_supl_name	VARCHAR(400) 
	DECLARE @c1_sup_copy	INT
	
   	 
	DECLARE c1 CURSOR LOCAL FOR 
	SELECT DISTINCT	 a.comp_code comp_code,	 a.unit_code unit_code, a.publ publ,
			 a.edtn edtn, a.supdate supdate, a.agcd agcd, a.dpcd dpcd, a.billagcd billagcd,
			 a.billdpcd billdpcd, b.inc_rate inc_rate, b.noof_supl no_of_supl,b.supl_name supl_name,
			 SUM(a.sup_copy) sup_copy
	FROM  cir_dbksup a, #cir_temp_suppliment b,cir_supply_type_mast c,cir_agmast d 
	WHERE a.comp_code  = @pcompcode AND a.comp_code  = b.comp_code AND a.comp_code  = c.comp_code AND a.comp_code  = d.comp_code
	 AND a.unit_code  = ISNULL(@punitcode, a.unit_code) AND a.unit_code  = d.unit
	 AND a.edtn  = b.edition_code
	 AND a.supdate  >= @pdatefrom AND a.supdate  <= @pdatetill
	 AND a.sup_type_code  = c.sup_ty_code
	 AND (a.sup_type_code  = ISNULL(@psup_type, a.sup_type_code)  OR @psup_type  ='')
	 AND a.agcd  = d.agcd AND a.dpcd  = d.dpcd
	 AND (d.agcd  = ISNULL(@pagcode, d.agcd)  OR @pagcode  ='')
	 AND (d.dpcd  = ISNULL(@pdepocode, d.dpcd) OR @pdepocode  ='')
	 AND (d.ag_type  = @pagtype OR	@pagtype IS NULL)
	 AND (d.ag_class  = @pagclass OR @pagclass  IS NULL)
	 AND (d.dist_code  IN(SELECT debit_head	FROM  #cir_ledger_report) OR @pcode  IS NULL  OR @pcode  ='')
	 --AND b.sess_id  = @@SPID
	 AND a.supdate  = b.sup_date
	 AND a.billagcd  IS NOT NULL
	GROUP BY a.comp_code, a.unit_code, a.publ, a.edtn, a.supdate, a.agcd,a.dpcd,a.billagcd,
		 a.billdpcd,b.inc_rate, b.noof_supl, b.supl_name 
		 ORDER BY a.comp_code,a.unit_code,a.supdate,a.publ,a.edtn 

print('Q')		
		OPEN c1 
		FETCH NEXT FROM c1 INTO @c1_comp_code,@c1_unit_code,@c1_publ,@c1_edtn,@c1_supdate,@c1_agcd,@c1_dpcd,@c1_billagcd,@c1_billdpcd,
		@c1_inc_rate,@c1_no_of_supl,@c1_supl_name,@c1_sup_copy	
			WHILE (@@FETCH_STATUS = 0) 
			BEGIN 
			SET @v_amt  = ( ISNULL( @c1_sup_copy, 0)- ISNULL(@v_unsold_copy, 0)) * ISNULL(@c1_inc_rate, 0)* ISNULL(@c1_no_of_supl, 0)
			print('W')
			IF ISNULL(@v_amt, 0)<> 0 BEGIN 
				INSERT INTO  cir_supl_process_det_temp   
						( comp_code , unit_code , publ_code , edtn_code , supdate , agcd , 
						dpcd , tot_supply , per_copy_rate , no_of_supl , recptdt , recptno , amount , 
						bilagcd , bildpcd , created_by , doctype , supl_name)  
				 
				 VALUES ( @c1_comp_code , @c1_unit_code , @c1_publ , @c1_edtn , @c1_supdate , @c1_agcd , @c1_dpcd , 
						ISNULL(@c1_sup_copy, 0) - ISNULL(@v_unsold_copy, 0) , 
						@c1_inc_rate , @c1_no_of_supl , @v_recptdt , @@SPID , @v_amt , @c1_billagcd , 
						@c1_billdpcd , @puserid , @v_doctype , @c1_supl_name )  
			print('*')print(@c1_comp_code)print(@c1_unit_code)print(@c1_publ)print(@c1_edtn)print(@c1_supdate)print(@c1_agcd)
			print(@c1_dpcd)	print(@c1_sup_copy)print(@v_unsold_copy)print(@c1_inc_rate)
			print(@c1_no_of_supl)	print(@v_doctype)print(@c1_supl_name)print('%')
 			END
		FETCH NEXT FROM c1 INTO @c1_comp_code,@c1_unit_code,@c1_publ,@c1_edtn,@c1_supdate,@c1_agcd,@c1_dpcd,@c1_billagcd,@c1_billdpcd,
		@c1_inc_rate,@c1_no_of_supl,@c1_supl_name,
			@c1_sup_copy
			
		END
		CLOSE c1		
		SET @v_amt  = 0 
print('@v_sess_id')print(@v_sess_id)
		SELECT s.comp_code AS "COMP_CODE",s.unit_code AS "UNIT_CODE",s.recptno AS "RECPTNO",s.recptdt AS "RECPTDT",
				 s.bilagcd AS "AGCD",s.bildpcd AS "DPCD",m.ag_name AS "AG_NAME",
				 DBO.cir_get_drop_point_name(s.comp_code, s.unit_code, m.station_code, 1) AS "DROP_POINT_NAME",
				 DBO.cir_get_city(s.comp_code, m.city_code) AS "CITY_NAME",
				 s.doctype AS "DOCTYPE",SUM(s.tot_supply) AS "SUPPLY",COUNT(s.no_of_supl) AS "NO_OF_INSERTION",SUM(s.amount) AS "AMOUNT"
		FROM  cir_supl_process_det_temp s, cir_agmast m 
		WHERE s.comp_code  = m.comp_code 
		AND s.unit_code  = m.unit 
		 AND s.bilagcd  = m.agcd 
		 AND s.bildpcd  = m.dpcd 
		 and dbo.cir_get_ins_status(s.comp_code,s.bilagcd,s.bildpcd,s.unit_code,'','')='Y'
		 AND s.recptno  = @v_sess_id
		 and s.COMP_CODE+s.UNIT_CODE+s.PUBL_CODE+s.EDTN_CODE+cast(s.SUPDATE as varchar)+s.AGCD+s.DPCD+s.SUPL_NAME
		 not in (Select distinct x.COMP_CODE+x.UNIT_CODE+x.PUBL_CODE+x.EDTN_CODE+cast(x.SUPDATE as varchar)+x.AGCD+x.DPCD+x.SUPL_NAME
		 from cir_supl_process_det x where x.comp_code  = @pcompcode
		 AND x.unit_code  = ISNULL(@punitcode, x.unit_code)
		 AND x.supdate  >= @pdatefrom AND x.supdate  <= @pdatetill
		 AND (x.agcd  = ISNULL(@pagcode, x.agcd)  OR @pagcode  ='')
		 AND (x.dpcd  = ISNULL(@pdepocode, x.dpcd) OR @pdepocode  ='')		 		 		 
		 AND x.agcd  IS NOT NULL ) 
		GROUP BY s.comp_code,s.unit_code,s.recptno,s.recptdt,s.doctype,s.bilagcd,s.bildpcd,m.station_code,m.city_code,m.ag_name 
		HAVING SUM(CONVERT(FLOAT, amount))  > 0  
		ORDER BY comp_code,unit_code,bilagcd,bildpcd 
	DEALLOCATE c1
	--DELETE FROM   cir_supl_process_det_temp   --change by neha 
		DROP TABLE #cir_ledger_report;
	DROP TABLE #cir_temp_suppliment;

END



///////////////////////////////////////////next///


ALTER procedure [dbo].[cir_suppliment_cn_process_p]
    @pcompcode       as varchar(20),
    @punitcode       as varchar(20),
    @pagcode         as varchar(20),
    @pdepocode       as varchar(20),
    @pdatefrom       as varchar(50),
    @pdatetill       as varchar(50),
    @pdoctype        as varchar(20),
    @precptdt        as varchar(50),
    @precptno        as varchar(50),
    @preason         as varchar(50),
    @premark         as varchar(500),
    @puserid         as varchar(20),
    @pdateformat     as varchar(20),
    @pextra1         as varchar(50),
    @pextra2         as varchar(50),
    @pextra3         as varchar(50),
    @pextra4         as varchar(50),
    @pextra5         as varchar(50)
  As
    declare @vlength		numeric(7)
    declare @v_doctype		varchar(10)
    declare @v_dt			datetime
    declare @v_sess_id		varchar(30)
    declare @v2_comp_code	varchar(50)
    declare @v2_unit_code	varchar(50)
    declare @v2_doctype		varchar(50)
    declare @v2_tot_supply  numeric(10)
    declare @v2_recptdt		datetime
    declare @v2_recptno		varchar(50)
    declare @v2_amount		numeric(15,2)
    declare @v2_bilagcd		varchar(50)
    declare @v2_bildpcd		varchar(50)
    declare c2 cursor for
        select s.comp_code,s.unit_code,s.doctype,sum(s.tot_supply) tot_supply,s.recptdt,s.recptno,sum(s.amount) amount,s.bilagcd,s.bildpcd 
        from cir_supl_process_det s,cir_agmast m 
        where s.comp_code=m.comp_code and s.comp_code=@pcompcode and s.unit_code=m.unit and s.unit_code=@punitcode and 
        s.bilagcd=m.agcd and (s.bilagcd=@pagcode or @pagcode is null or @pagcode='') and s.bildpcd=m.dpcd and (s.bildpcd= @pdepocode or @pdepocode is null or @pdepocode='') and
        s.recptno=@precptno and s.recptdt=@precptdt
        group by s.comp_code,s.unit_code,s.doctype,s.recptdt,s.recptno,s.bilagcd,s.bildpcd
        having sum(s.amount)>0
        order by s.comp_code,s.unit_code,s.bilagcd,s.bildpcd
    
    declare @v_amt			numeric(15,2)
    declare @v_remark		varchar(500);
    declare @v_recptno		varchar(50);
    declare @v_dsign		numeric(5);
    
    declare @v_bran_code	varchar(20);
    declare @v_rec_no		numeric(10);  
    declare @v_unsold_copy	numeric(10);
    declare @vdistcode		varchar(4000);
    declare @vtalukacode	varchar(4000);

  Begin
    insert into cir_supl_process_det
        (comp_code, unit_code, publ_code, edtn_code, supdate, agcd, dpcd, tot_supply, per_copy_rate, no_of_supl, doctype, recptdt, recptno, amount, bilagcd, bildpcd, created_by, created_date, updated_by, updated_date, supl_name)
        select comp_code, unit_code, publ_code, edtn_code, supdate, agcd, dpcd, tot_supply, per_copy_rate, no_of_supl, doctype, recptdt, recptno, amount, bilagcd, bildpcd, created_by, created_date, updated_by, updated_date, supl_name 
        from cir_supl_process_det_temp where comp_code=@pcompcode and unit_code=@punitcode and 
            agcd=@pagcode and dpcd= @pdepocode and recptno=@precptno and recptdt=@precptdt
            
    If @pdoctype is null or @pdoctype='' Begin
        set @v_doctype='CN'
    End    
    Else Begin
        set @v_doctype=@pdoctype
    End
        
   set @v_amt=0

   open c2
		fetch NEXT FROM c2 INTO @v2_comp_code,@v2_unit_code,@v2_doctype,@v2_tot_supply,@v2_recptdt,@v2_recptno,@v2_amount,@v2_bilagcd,@v2_bildpcd 
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN
        select @v_bran_code=branch_code from cir_agmast 
            where comp_code=@v2_comp_code and unit=@v2_unit_code and agcd=@v2_bilagcd and dpcd=@v2_bildpcd;
        
        select @v_dsign=Dsign from cir_docmst where Comp_code=@pcompcode AND doc_type=@v_doctype

        If(@v_dsign=-1) Begin
            set @v_amt=@v2_amount*@v_dsign
        End    
        Else Begin
            set @v_amt=@v2_amount*@v_dsign
        End
        
        If @premark is null or @premark='' Begin
            set @v_remark='Being amount auto credited against suppliment charges'
        End    
        Else Begin
            set @v_remark=@premark
        End

		SELECT @v_rec_no  =  CAST( MAX(SUBSTRING(recptno, 5, 8))AS NUMERIC) + 1
		FROM  cir_rcphdr 
		WHERE comp_code  = @pcompcode AND doctype  = @pdoctype
		AND CONVERT(VARCHAR(23), recptdt) = CONVERT(VARCHAR(23), @v2_recptdt) AND branch_code  = @v_bran_code
		
		IF ISNULL(@v_rec_no, 0)= 0 BEGIN 
			SET @v_recptno  = @v_bran_code + '-' + REPLACE(CONVERT(VARCHAR(5), GETDATE(), 2), '.', '')+ '0001' 
		END
		ELSE BEGIN 
			SET @v_recptno  = @v_bran_code + '-' + dbo.fnPadLeft('0',8,@v_rec_no) 
		END
    
          insert into cir_rcphdr(comp_code,unit_code,agcd,dpcd,doctype,
                                 recptno,recptdt,amount,reason,remark,
                                 achd,voucherno,voucherdt,userid,creation_date,branch_code)
                          values(@v2_comp_code, @v2_unit_code,@v2_bilagcd, @v2_bildpcd,@v2_doctype,
                                 @v_recptno,@v2_recptdt,@v_amt,isnull(@preason,'SUPPLIMENT CHARGES'),@v_remark,
                                 'NM',@v_recptno,@v2_recptdt,@puserid,getdate(),@v_bran_code)
          insert into cir_rcpdet(comp_code,unit_code,agcd,dpcd,doctyp,
                                 recptno,recptdt,payfor,achd,amount,
                                 reason,remark,voucherno,voucherdt,usrid,
                                 creation_date,branch_code)
                          values(@v2_comp_code, @v2_unit_code,@v2_bilagcd, @v2_bildpcd,@v2_doctype,
                                 @v_recptno,@v2_recptdt,@v2_unit_code,'NM',@v_amt,
                                 isnull(@preason,'SUPPLIMENT CHARGES'),@v_remark,@v_recptno,@v2_recptdt,@puserid,
                                 getdate(),@v_bran_code);
          insert into cir_outmast(comp_code,unit_code,agcd,dpcd,doctyp,
                                  recptno,recptdt,achd,amount,reason,
                                  remark,voucherno,voucherdt,usrid,creation_date,branch_code)
                           values(@v2_comp_code, @v2_unit_code,@v2_bilagcd, @v2_bildpcd,@v2_doctype,
                                  @v_recptno,@v2_recptdt,'NM',@v_amt,isnull(@preason,'SUPPLIMENT CHARGES'),
                                  @v_remark,@v_recptno,@v2_recptdt,@puserid,getdate(),@v_bran_code)                               
        
          update cir_supl_process_det set recptno=@v_recptno
            where comp_code=@v2_comp_code and unit_code=@v2_unit_code and doctype=@v2_doctype and recptno=@precptno and 
                  recptdt=@v2_recptdt and supdate >= @pdatefrom and supdate <= @pdatetill and bilagcd = @v2_bilagcd and bildpcd = @v2_bildpcd
       fetch NEXT FROM c2 INTO @v2_comp_code,@v2_unit_code,@v2_doctype,@v2_tot_supply,@v2_recptdt,@v2_recptno,@v2_amount,@v2_bilagcd,@v2_bildpcd       
   End
   close c2;
	deallocate c2
   DELETE from cir_supl_process_det_temp where comp_code=@pcompcode and unit_code=@punitcode and 
          AGCD=@pagcode and dpcd= @pdepocode and recptno=@precptno and recptdt=@precptdt;
            
   select getdate() as "CUR_DATE" 
   
End


/////////////////////////////////////////////next


ALTER function [dbo].[cir_bill_outstanding](
@comp_code		as varchar(100),
@unit_code		as varchar(100),
@branch_code	as varchar(100),
@agcd			as varchar(50),
@agdpcd			as varchar(50),
@dateformate	as varchar(50),
@puserid		as  varchar(20),
@extra1			as varchar(50),
@extra2			as varchar(50))returns numeric(25,2)
as
	begin
	
		declare @amount   numeric(25,2)
	
		 select @amount=  sum(x.amt)
		 from (select SUM(amount) as amt from CIR_OUTMAST where COMP_CODE=@comp_code 
		 and UNIT_CODE=@unit_code --AND (BRANCH_CODE=@branch_code OR @branch_code='' OR @branch_code IS NULL)
		 and AGCD=@agcd and DPCD=@agdpcd  and BILLNO is not NULL and  RECPTNO is  null
		 union all
		 select SUM(amount) as amt from CIR_OUTMAST where COMP_CODE=@comp_code and  AGCD=@agcd 
		 and UNIT_CODE=@unit_code --AND (BRANCH_CODE=@branch_code OR @branch_code='' OR @branch_code IS NULL) 
		 and DPCD=@agdpcd  and RECPTNO is not NULL  and BILLNO is not NULL)x 
		 
		 return @amount
	end


////////////////////////////////////next

ALTER PROCEDURE [dbo].[cir_ledger_ageing]
@pcomp_code varchar(20),
@punit_code varchar(20),
@pbran_code varchar(20),
@pzone_code varchar(30),
@pregion_code varchar(30),
@pdist_code varchar(20),
@ptaluka_code varchar(20),
@pagtype varchar(50),
@pagclass varchar(50),
@pag_main_code varchar(50),
@pag_sub_code varchar(50),
@paging_by varchar(50),
@pasondt datetime,
@pdebitupto_date datetime,
@pcreditupto_date datetime,
@pdateformat varchar(20),
@puserid varchar(20),
@pextra1 varchar(20),
@pextra2 varchar(20),
@pextra3 varchar(30),
@pextra4 varchar(30),
@pextra5 varchar(50)
As

--------- slabs end

declare @ptill_days1 as varchar(20)
declare @ptill_days2 as varchar(20)
declare @ptill_days3 as varchar(30)
declare @ptill_days4 as varchar(30)
declare @ptill_days5 as varchar(50)
declare @ptill_days6 as varchar(50)
declare @ptill_current as varchar(50)
---------------- slabs

declare @vtodt as datetime
declare @vasondt as datetime
declare @v_dt as datetime
declare @v_ondt as datetime
declare @v_days numeric(10);
declare @v_pending_rcpt_amt as numeric(14,2)
declare @v_amt as numeric(14,2);
declare @v_amt030 as numeric(14,2);
declare @v_amt3160 as numeric(14,2);
declare @v_amt6190 as numeric(14,2);
declare @v_amt91120 as numeric(14,2);
declare @v_amt121180 as numeric(14,2);
declare @v_amt181 as numeric(14,2);
declare @v_amtcur as numeric(14,2);
declare @debit_amt_030 as numeric(14,2) --debit amt for slab 1 days
declare @debit_amt_3160 as numeric(14,2) --debit amt for slab 2 days
declare @debit_amt_6190 as numeric(14,2) --debit amt for slab 3 days
declare @debit_amt_91120 as numeric(14,2) --debit amt for slab 4 days
declare @debit_amt_121180 as numeric(14,2) --debit amt for >slab 5 days
declare @debit_amt_181 as numeric(14,2) --debit amt for >slab 6 days
declare @debit_amt_cur as numeric(14,2) --debit amt for >current
declare @bill_pending_amt as numeric(14,2)
declare @rcpt_pending_amt as numeric(14,2) --pending receipt amount

CREATE TABLE #cir_temp_ageing
(
	COMP_CODE VARCHAR(8),
	UNIT_CODE VARCHAR(8),
	BRAN_CODE VARCHAR(8),
	AGCD VARCHAR(8),
	DPCD VARCHAR(8),
	AG_NAME VARCHAR(100),
	CITY_NAME VARCHAR(100),
	PENDING_AMT NUMERIC(14,2),
	CUR_AMT NUMERIC(14,2),
	SLAB_1 NUMERIC(14,2),
	SLAB_2 NUMERIC(14,2),
	SLAB_3 NUMERIC(14,2),
	SLAB_4 NUMERIC(14,2),
	SLAB_5 NUMERIC(14,2),
	SLAB_6 NUMERIC(14,2),
	ON_ACAMT NUMERIC(14,2),
	RECT_PENDING NUMERIC(14,2),
	SESSIONID NUMERIC(14),
	PUBNAME VARCHAR(200),
	ageing varchar(1)
)

set @debit_amt_030 =0 --debit amt for slab 1 days
set @debit_amt_3160 =0 --debit amt for slab 2 days
set @debit_amt_6190 =0 --debit amt for slab 3 days
set @debit_amt_91120 =0 --debit amt for slab 4 days
set @debit_amt_121180 =0 --debit amt for >slab 4 days
set @debit_amt_181 =0 --debit amt for >slab 4 days
set @debit_amt_cur =0 --debit amt for >current
set @bill_pending_amt =0
set @rcpt_pending_amt =0 --pending receipt amount
-- cursor cur_agency variables

declare @rec_agency_comp_code as varchar(30)
declare @rec_agency_agcd as varchar(20)
declare @rec_agency_dpcd as varchar(30)
declare @rec_agency_agency_name as varchar(300)
declare @rec_agency_city_code as varchar(200)
declare @rec_agency_city_name as varchar(200)
declare @rec_agency_credit_days as int
declare @rec_agency_branch_name as varchar(50)
declare @rec_agency_ageing_type as varchar(1)
--@rec_agency_comp_code,@rec_agency_agcd,@rec_agency_dpcd,@rec_agency_agency_name,@rec_agency_city_code,@rec_agency_city_name,

--@rec_agency_credit_days,@rec_agency_branch_name,@rec_agency_ageing_type

declare cur_agency_1 cursor for
select m.Comp_Code ,m.agcd ,m.dpcd ,m.ag_name ,m.City_Code,c.city_name,m.credit_days,m.branch_code,m.ageing_type
from cir_agmast m,cir_city_mast c
where m.comp_code=c.comp_code and m.comp_code=@pcomp_code
and m.unit=@punit_code and m.city_code=c.city_code
and (m.Dist_Code=@pdist_code or @pdist_code is null or @pdist_code ='')
and (m.tehsil_taluka=@ptaluka_code or @ptaluka_code is null or @ptaluka_code ='')
and (m.agcd=@pag_main_code or @pag_main_code is null or @pag_main_code ='')
and (m.dpcd=@pag_sub_code or @pag_sub_code is null or @pag_sub_code ='')

if @pdebitupto_date is null or @pdebitupto_date=''
begin
	set @pdebitupto_date =@pasondt
end
if @pcreditupto_date is null or @pcreditupto_date=''
begin
	set @pcreditupto_date =@pasondt
end
if @pasondt is null or @pasondt =''
begin
	set @pasondt=@pcreditupto_date
end

declare @fetch_protype as varchar(20)
declare @fetch_pub as varchar(20)
-- cursor v_bill variables

declare @v_bill_billno as varchar(50)
declare @v_bill_billdt as varchar(30)
declare @v_bill_bill_amt as numeric(15,2)
-- cursor v_pending_rcpt variables

declare @v_pending_rcpt_ag_main_code as varchar(30)
declare @v_pending_rcpt_ag_sub_code as varchar(50)
declare @v_pending_rcpt_amount as numeric(15,2)
declare @fetch_pubname as varchar(200)
declare @fetch_pubtype as varchar(200)
--SELECT 'cursor has ' + CAST(@@CURSOR_ROWS AS VARCHAR) + ' rows'

declare @v_mcnt1 as datetime
declare @v_mcnt2 as datetime
declare @v_mcnt3 as datetime
declare @v_mcnt4 as datetime
declare @v_mcnt5 as datetime
declare @vtill_days1 AS int
declare @vtill_days2 AS int
declare @vtill_days3 AS int
declare @vtill_days4 AS int
declare @vtill_days5 AS int
declare @vrec_agency_ageing_type as varchar(10)

	open cur_agency_1
		fetch NEXT FROM cur_agency_1 INTO @rec_agency_comp_code,@rec_agency_agcd,@rec_agency_dpcd,@rec_agency_agency_name,@rec_agency_city_code,@rec_agency_city_name,@rec_agency_credit_days,@rec_agency_branch_name,@rec_agency_ageing_type
		WHILE (@@FETCH_STATUS = 0)
		begin
			declare @day as int
			
			declare cur_agency cursor for
			select distinct publ from cir_supply where comp_code=@pcomp_code and agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd order by publ
			--select distinct dbo.cir_get_publ_type(comp_code,publ,'C','') publ from cir_supply where comp_code=@pcomp_code and agcd=@pag_main_code and dpcd=@pag_sub_code order by publ
			print
			('@rec_agency_ageing_type')print(@rec_agency_ageing_type)
			open cur_agency
				fetch NEXT FROM cur_agency INTO @fetch_pub
				WHILE (@@FETCH_STATUS = 0)
				BEGIN 
					print('dddddd') print(@fetch_pub)
					
					select distinct @fetch_protype=pro_type,@fetch_pubname=PUBL_NAME,@fetch_pubtype=
					(Select pubname from pub_type_mast where Comp_Code=@pcomp_code and pub_type_mast.pubtypecode=CIR_PUBL_MAST.PRO_TYPE)
					from CIR_PUBL_MAST where COMP_CODE=@pcomp_code and publ=@fetch_pub					
					
					print('@fetch_protype')print(@fetch_protype)
					print('@@fetch_pubname')print(@fetch_pubname)
					print('@fetch_pubtype')print(@fetch_pubtype)
					
					if @fetch_protype ='MA0'
					begin
						set @vrec_agency_ageing_type='M'
					end
					else
					begin
						set @vrec_agency_ageing_type=@rec_agency_ageing_type
					end
					select @ptill_days1=SLAB_TILL1,@ptill_days2=SLAB_TILL2,@ptill_days3=SLAB_TILL3,@ptill_days4=SLAB_TILL4
					,@ptill_days5=SLAB_TILL5,@ptill_days6=SLAB_TILL6--,@rec_agency_ageing_type=AGEING_TYPE
					from CIR_AGEING_SLAB_MAST
					where COMP_CODE=@pcomp_code and PRO_TYPE=@fetch_protype
					
					print ('slab')print(@ptill_days1)print(@ptill_days2)print(@ptill_days3)print(@ptill_days4)print(@ptill_days5)
					print (@ptill_days6)print(@rec_agency_ageing_type)
					print ('gaurav')
					print (@vrec_agency_ageing_type)
					print (@pasondt)
					print (dbo.GetLastDayOfMonth(@pasondt))
					print ('debug')
					
					if upper(@vrec_agency_ageing_type) = 'D'
					begin
						set @vtodt=dateadd(dd,-1,@pasondt)
					end
					else if upper(@vrec_agency_ageing_type) = 'W'
					begin
						select @day=DATEPART(dw,@pasondt)
						print(@day)
						set @vtodt=dateadd(dd,-(@day-1),@pasondt)
					end
					else
					begin
						if dbo.GetLastDayOfMonth(@pasondt)=@pasondt
						begin
							set @vtodt=@pasondt
						end
						else
						begin
							set @vtodt=dbo.GetLastDayOfMonth(dateadd(mm,-1,@pasondt))
						end
					end
					print('come')
					print(@vtodt)
					print('custom')print(@ptill_days1)print(@ptill_days2)print(@ptill_days3)print(@ptill_days4)print(@ptill_days5)

					if @vrec_agency_ageing_type='M' begin print('gks')
						set @v_mcnt1=DATEADD(MM,-1*@ptill_days1,@vtodt+1)
						set @v_mcnt2=DATEADD(MM,-1*@ptill_days2,@vtodt+1)
						set @v_mcnt3=DATEADD(MM,-1*@ptill_days3,@vtodt+1)
						set @v_mcnt4=DATEADD(MM,-1*@ptill_days4,@vtodt+1)
						set @v_mcnt5=DATEADD(MM,-1*@ptill_days5,@vtodt+1)
						--DATEDIFF(dd, dbo.GetFirstDayOfMonth( @vtodt),@vtodt )+1
						set @vtill_days1=DATEDIFF(dd, dbo.GetFirstDayOfMonth( @v_mcnt1),@vtodt )+1
						set @vtill_days2=DATEDIFF(dd, dbo.GetFirstDayOfMonth( @v_mcnt2),@vtodt )+1
						set @vtill_days3=DATEDIFF(dd, dbo.GetFirstDayOfMonth( @v_mcnt3),@vtodt )+1
						set @vtill_days4=DATEDIFF(dd, dbo.GetFirstDayOfMonth( @v_mcnt4),@vtodt )+1
						set @vtill_days5=DATEDIFF(dd, dbo.GetFirstDayOfMonth( @v_mcnt5),@vtodt )+1
					end
					else
					begin
						set @vtill_days1=@ptill_days1
						set @vtill_days2=@ptill_days2
						set @vtill_days3=@ptill_days3
						set @vtill_days4=@ptill_days4
						set @vtill_days5=@ptill_days5
					end
					print ('custom1')print(@vtill_days1)print(@vtill_days2)print(@vtill_days3)print(@vtill_days4)print(@vtill_days5)
					print @rec_agency_dpcd
					set @debit_amt_030 = 0;
					set @debit_amt_3160 = 0;
					set @debit_amt_6190 = 0;
					set @debit_amt_91120 = 0;
					set @debit_amt_121180 = 0;
					set @debit_amt_181 = 0;
					set @rcpt_pending_amt = 0;
					set @bill_pending_amt = 0;
					print('enter first')
					
					declare c_bill cursor for
					select distinct billno,billdt,sum(amount) bill_amt from cir_outmast
					where comp_code=@pcomp_code and unit_code=@punit_code and
					agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
					billdt <=@vtodt and isnull(abs(amount),0)>0
					group by comp_code,billno,billdt having sum(amount)>0
					union all
					select distinct recptno billno,recptdt billdt,sum(amount) bill_amt from cir_outmast
					where comp_code=@pcomp_code and unit_code=@punit_code and
					agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
					recptdt <=@vtodt and isnull(amount,0)>0 and billno is null
					group by comp_code,recptno,recptdt order by 2,1
--having sum(amount)<0
					open c_bill
					fetch NEXT FROM c_bill INTO @v_bill_billno,@v_bill_billdt,@v_bill_bill_amt
						WHILE (@@FETCH_STATUS = 0)
						begin
							print('enter second')
							
							set @v_dt = @v_bill_billdt
							set @v_ondt = @vtodt
							print(@v_dt)
							print(@v_ondt)
							
							if @paging_by='D' begin
								set @v_days=DATEDIFF(dd, @v_dt,@v_ondt )---isnull(pcrdtday,0)+1;
							end
							else
							begin
								set @v_days=DATEDIFF(dd, @v_dt,@v_ondt )+1;
							end
							if @v_days<0 begin
								set @v_days=0;
							end
							print('x')
							print(@v_days)
							set @v_amt =0;
							set @v_amt030 =0;
							set @v_amt3160 =0;
							set @v_amt6190 =0;
							set @v_amt91120 =0;
							set @v_amt121180 =0;
							set @v_amt181 =0;
							
							if @v_days between 0 and @vtill_days1 
							begin
								select @v_amt030=sum(amount) from cir_outmast
								where comp_code=@pcomp_code and unit_code=@punit_code and
								agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
								billno =@v_bill_billno and billdt=@v_bill_billdt and
								recptdt <=@vasondt and amount<0
								set @v_amt030 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt030,0);
								set @debit_amt_030 =isnull(@debit_amt_030,0)+isnull(@v_amt030,0)
							end
							else if @v_days between isnull(@vtill_days1,0)+1 and @vtill_days2 
							begin
								select @v_amt3160=sum(amount) from cir_outmast
								where comp_code=@pcomp_code and unit_code=@punit_code and
								agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
								billno =@v_bill_billno and billdt=@v_bill_billdt and
								recptdt <=@vasondt and amount<0
							--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
								set @v_amt3160 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt3160,0);
								set @debit_amt_3160 =isnull(@debit_amt_3160,0)+isnull(@v_amt3160,0)
							end
							else if @v_days between isnull(@vtill_days2,0)+1 and @vtill_days3 
							begin
								select @v_amt6190=sum(amount) from cir_outmast
								where comp_code=@pcomp_code and unit_code=@punit_code and
								agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
								billno =@v_bill_billno and billdt=@v_bill_billdt and
								recptdt <=@vasondt and amount<0
							--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
								set @v_amt6190 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt6190,0);
								set @debit_amt_6190 =isnull(@debit_amt_6190,0)+isnull(@v_amt6190,0)
							end
							else if @v_days between isnull(@vtill_days3,0)+1 and @vtill_days4 
							begin
								select @v_amt91120=sum(amount) from cir_outmast
								where comp_code=@pcomp_code and unit_code=@punit_code and
								agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
								billno =@v_bill_billno and billdt=@v_bill_billdt and
								recptdt <=@vasondt and amount<0
							--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
								set @v_amt91120 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt91120,0);
								set @debit_amt_91120 =isnull(@debit_amt_91120,0)+isnull(@v_amt91120,0)
							end
							else if @v_days between isnull(@vtill_days4,0)+1 and @vtill_days5 
							begin
								select @v_amt121180=sum(amount) from cir_outmast
								where comp_code=@pcomp_code and unit_code=@punit_code and
								agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
								billno =@v_bill_billno and billdt=@v_bill_billdt and
								recptdt <=@vasondt and amount<0
							--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
								set @v_amt121180 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt121180,0);
								set @debit_amt_121180 =isnull(@debit_amt_121180,0)+isnull(@v_amt121180,0)
							end
							else
							begin
								select @v_amt181=sum(amount) from cir_outmast
								where comp_code=@pcomp_code and unit_code=@punit_code and
								agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
								billno =@v_bill_billno and billdt=@v_bill_billdt and
								recptdt <=@vasondt and amount<0
								--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
								set @v_amt181 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt181,0);
								set @debit_amt_181 =isnull(@debit_amt_181,0)+isnull(@v_amt181,0)
							end
					fetch NEXT FROM c_bill INTO @v_bill_billno,@v_bill_billdt,@v_bill_bill_amt
					end
				close c_bill
				deallocate c_bill

			declare @cur_from_dt as datetime
			print('t')
			print(@punit_code)
			print(@fetch_pub)
			set @cur_from_dt= dateadd(dd,1,@vtodt)
			print(@cur_from_dt)
			print(@pasondt)
			print('W')
			
			select @v_amtcur=sum(amount) from cir_outmast
			where comp_code=@pcomp_code and unit_code=@punit_code and
			agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
			billdt between @cur_from_dt and @pasondt
			--and RECPTNO is null and RECPTDT is null
			print(@fetch_pub)print(@cur_from_dt)print(@pasondt) 
			--and recptdt<=@pasondt and amount<0
			
			select @v_pending_rcpt_amt=sum(amount) from cir_outmast
			where comp_code=@pcomp_code and unit_code=@punit_code and
			agcd =@rec_agency_agcd and dpcd=@rec_agency_dpcd and
			(billno is null or billdt>@pcreditupto_date) and
			recptdt	<=@pcreditupto_date and
			doctyp+recptno+cast(recptdt as varchar) not in
			(select distinct doctyp+recptno+cast(recptdt as varchar) from ad_outstand
			where comp_code=@pcomp_code and unit_code=@punit_code and
			agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
			recptdt<=@vtodt and isnull(amount,0)<0 and billno IS NULL)
		
			set @v_amt=isnull(@v_amtcur,0)+ isnull(@debit_amt_030,0)+isnull(@debit_amt_3160,0)+isnull(@debit_amt_6190,0)+isnull(@debit_amt_91120,0)+isnull(@debit_amt_121180,0)+isnull(@debit_amt_181,0)
			if @v_amt=0 
			begin
				set @debit_amt_030 = 0
				set @debit_amt_3160 = 0
				set @debit_amt_6190 = 0
				set @debit_amt_91120 = 0
				set @debit_amt_121180 = 0
				set @debit_amt_181 = 0
				set @rcpt_pending_amt = 0
			end
			else
			begin
				set @rcpt_pending_amt=isnull(@v_pending_rcpt_amount,0)
				set @bill_pending_amt=isnull(@v_amt,0)
			end
			print('zzz')
		
			insert into #cir_temp_ageing (comp_code,unit_code,agcd,dpcd,ag_name,city_name,pending_amt,CUR_AMT
			, SLAB_1 ,slab_2,slab_3,slab_4,slab_5,slab_6,rect_pending,on_acamt,sessionid,PUBNAME,ageing)
			values (@rec_agency_comp_code,@punit_code,@rec_agency_agcd, @rec_agency_dpcd, @fetch_protype,
			@fetch_pubname	,isnull(@bill_pending_amt,0),isnull(@v_amtcur,0)
			,isnull(@debit_amt_030,0),isnull(@debit_amt_3160,0), isnull(@debit_amt_6190,0)
			,isnull(@debit_amt_91120,0), isnull(@debit_amt_121180,0), isnull(@debit_amt_181,0),
			isnull(@rcpt_pending_amt,0),0,@@spid,@fetch_pubtype,@rec_agency_ageing_type);
			print('xxx')
			fetch NEXT FROM cur_agency INTO @fetch_pub
			set @debit_amt_030 = 0
			set @debit_amt_3160 = 0
			set @debit_amt_6190 = 0
			set @debit_amt_91120 = 0
			set @debit_amt_121180 = 0
			set @debit_amt_181 = 0
			set @rcpt_pending_amt = 0
			set @bill_pending_amt = 0
		end
		close cur_agency;
	deallocate cur_agency

fetch NEXT FROM cur_agency_1 INTO @rec_agency_comp_code,@rec_agency_agcd,@rec_agency_dpcd,@rec_agency_agency_name,@rec_agency_city_code,@rec_agency_city_name,@rec_agency_credit_days,@rec_agency_branch_name,@rec_agency_ageing_type
end 
close cur_agency_1
deallocate cur_agency_1

if(@pextra1='CREDIT') 
begin
	select comp_code,unit_code,agcd,dpcd,ag_name PRO_TYPE,PUBNAME--,city_name PUBL_NAME
	,sum(isnull(pending_amt,0)) pending_amt,sum(isnull(cur_amt,0)) cur_amt,sum(isnull(slab_1,0)) slab_1,sum(isnull(slab_2,0)) slab_2
	,sum(isnull(slab_3,0)) slab_3,sum(isnull(slab_4,0)) slab_4,sum(isnull(slab_5,0)) slab_5,sum(isnull(slab_6,0)) slab_6,sum(isnull(rect_pending,0)) rect_pending
	,ageing
	from #cir_temp_ageing group by #cir_temp_ageing.COMP_CODE,#cir_temp_ageing.UNIT_CODE,#cir_temp_ageing.AGCD,#cir_temp_ageing.DPCD
	,#cir_temp_ageing.AG_NAME,PUBNAME,ageing
	order by PUBNAME;
end
else 
begin
	select comp_code,unit_code,agcd,dpcd,ag_name PRO_TYPE,PUBNAME--,city_name PUBL_NAME
	,sum(isnull(pending_amt,0)) pending_amt,sum(isnull(cur_amt,0)) cur_amt,sum(isnull(slab_1,0)) slab_1,sum(isnull(slab_2,0)) slab_2
	,sum(isnull(slab_3,0)) slab_3,sum(isnull(slab_4,0)) slab_4,sum(isnull(slab_5,0)) slab_5,sum(isnull(slab_6,0)) slab_6,sum(isnull(rect_pending,0)) rect_pending
	,ageing
	from #cir_temp_ageing group by #cir_temp_ageing.COMP_CODE,#cir_temp_ageing.UNIT_CODE,#cir_temp_ageing.AGCD,#cir_temp_ageing.DPCD
	,#cir_temp_ageing.AG_NAME,PUBNAME,ageing
	order by PUBNAME;

	select SUM(abs(isnull(amount,0))) as SEC_ONDT from CIR_RCPHDR where COMP_CODE=@pcomp_code
	and (UNIT_CODE=@punit_code or @punit_code is null or @punit_code ='')
	and (AGCD=@pag_main_code or @pag_main_code is null or @pag_main_code ='')
	and (DPCD=@pag_sub_code or @pag_sub_code is null or @pag_sub_code ='')
	and ACHD='SC'
	group by comp_code,unit_code,agcd,dpcd


	select SUM(abs(isnull(bg_amt,0))) as BG_ONDT from CIR_BANK_GUARANTEE where COMP_CODE=@pcomp_code
	and(UNIT_CODE=@punit_code or @punit_code is null or @punit_code ='')
	and(AGCD=@pag_main_code or @pag_main_code is null or @pag_main_code ='')
	and(DPCD=@pag_sub_code or @pag_sub_code is null or @pag_sub_code ='')
	group by comp_code,unit_code,agcd,dpcd
	drop table #cir_temp_ageing
end

/////////////////////////////////////////////next

ALTER PROCEDURE [dbo].[cir_publwise_outstanding_p]
    @pcompcode       as varchar(20),
    @punitcode       as varchar(20),
    @ppublcode       as varchar(20),
    @pactype         as varchar(20),
    @pagcd           as varchar(20),
    @pdpcd           as varchar(20),
    @pason_date      as datetime,
    @pdateformat     as varchar(20),
    @pextra1         as varchar(20),
    @pextra2         as varchar(20),
    @pextra3         as varchar(20),
    @pextra4         as varchar(20),
    @pextra5         as varchar(20),
    @pextra6         as varchar(20),
    @pextra7         as varchar(20),
    @pextra8         as varchar(20),
    @pextra9         as varchar(20),
    @pextra10        as varchar(20)
As
    declare @v_opdate        datetime
    declare @v_opbal         numeric(15,2)
    declare @v_clbal         numeric(15,2)
    declare @v_amt           numeric(15,2)
    declare @v_publ          varchar(20)
    
    declare @v1_comp_code			varchar(20)	
    declare @v1_unit				varchar(20)
    declare @v1_agcd				varchar(20)
    declare @v1_dpcd				varchar(20)
    declare @v1_ag_name				varchar(200)
    declare @v1_ag_name_oth_lang	varchar(200)
    declare @v1_city_code			varchar(20)
    declare @v1_tehsil_taluka		varchar(20)
    declare @v1_dist_code			varchar(20)
    declare @v1_state_code			varchar(20)
    declare @v1_country_code		varchar(20)
    
		
        DECLARE c1 cursor FOR 
            select distinct comp_code,unit,agcd,dpcd,ag_name,ag_name_oth_lang,city_code,tehsil_taluka,dist_code,state_code,
            country_code from cir_agmast 
                where comp_code=@pcompcode and unit=isnull(@punitcode,unit) 
                and agcd=isnull(@pagcd,agcd) and dpcd=isnull(@pdpcd,dpcd)
                order by ag_name
        
        DECLARE cur_publ cursor for
            select distinct publ from cir_publ_mast where comp_code=@pcompcode and publ=isnull(@ppublcode,publ)
            /*select x.publ from 
            (select distinct publ from cir_publ_mast where comp_code=@pcompcode and publ=isnull(@ppublcode,publ) 
            union all
            select null as publ ) x */
            order by publ;
Begin
    
		CREATE TABLE #CIR_TEMP_OUTSTANDING
		(COMP_CODE       VARCHAR(8),
		UNIT_CODE        VARCHAR(8),
		DT               DATE,
		PUBL_CODE        VARCHAR(8),
		AGCD             VARCHAR(8),
		DPCD             VARCHAR(8),
		BILL_AMT         NUMERIC(15,2)	DEFAULT 0,
		RETURN_AMT       NUMERIC(15,2)  DEFAULT 0,
		DN_AMT           NUMERIC(15,2)  DEFAULT 0,
		CN_AMT           NUMERIC(15,2)  DEFAULT 0,
		REC_AMT          NUMERIC(15,2)  DEFAULT 0,
		AGNAME           VARCHAR(200),
		AGNAME_OTH_LANG  VARCHAR(250),
		CITY_CODE        VARCHAR(20),
		TALUKA_CODE      VARCHAR(20),
		DIST_CODE        VARCHAR(20),
		STATE_CODE       VARCHAR(20),
		COUNTRY_CODE     VARCHAR(20),
		OP_AMT           NUMERIC(15,2));
	
		SET @v_opdate  = DBO.cir_get_finandt(@pcompcode, @pason_date, @pdateformat, '', '')--for financial date
		print(@v_opdate)print('Q')
        delete from #cir_temp_outstanding;

        open c1;
            fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit,@v1_agcd,@v1_dpcd,@v1_ag_name,@v1_ag_name_oth_lang,@v1_city_code,@v1_tehsil_taluka,@v1_dist_code,@v1_state_code,@v1_country_code    
            WHILE (@@FETCH_STATUS = 0) 
			BEGIN 
            
				open cur_publ
                fetch NEXT FROM cur_publ INTO @v_publ
                WHILE (@@FETCH_STATUS = 0) 
				BEGIN     
				print('1')
				
					set @v_opbal     =	dbo.cir_accounts_cir_agency_opbal(@v1_comp_code,@v1_unit,@v_publ,@v1_agcd,@v1_dpcd,@v_opdate,@pactype,@pdateformat,null,null);
	print('@pason_date+1')   print(@pason_date+1)  print(@v_publ)   print(@v_opbal) print('end')    
					--set @v_amt       =	dbo.cir_accounts_cir_agency_ytodt_receipt(@v1_comp_code,@v1_unit,@v_publ,@v1_agcd,@v1_dpcd,@v_opdate,@pason_date+1,@pactype,@pdateformat,null,null)
					set @v_amt       =	dbo.cir_accounts_cir_agency_ytodt(@v1_comp_code,@v1_unit,@v_publ,@v1_agcd,@v1_dpcd,@v_opdate,@pason_date,@pactype,@pdateformat,null,null)
	            
					set @v_clbal=isnull(@v_opbal,0)+isnull(@v_amt,0)
	            print(@v_opbal)print(@v_amt)print(@v_clbal)print('2')
					If @v_clbal<>0 Begin
	            
						insert into #cir_temp_outstanding(comp_code,unit_code,dt,publ_code,agcd,dpcd,bill_amt,
										agname,agname_oth_lang,city_code,taluka_code,dist_code,state_code,country_code)
								 values(@v1_comp_code,@v1_unit,@pason_date,@v_publ,@v1_agcd,@v1_dpcd,@v_clbal,
										@v1_ag_name,@v1_ag_name_oth_lang,@v1_city_code,@v1_tehsil_taluka,@v1_dist_code,@v1_state_code,@v1_country_code)
					End
					set @v_publ=null
				fetch NEXT FROM cur_publ INTO @v_publ
				
				set @v_amt=0 set @v_opbal    =0 set @v_clbal=0 
				End
				close cur_publ
				
				fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit,@v1_agcd,@v1_dpcd,@v1_ag_name,@v1_ag_name_oth_lang,@v1_city_code,@v1_tehsil_taluka,@v1_dist_code,@v1_state_code,@v1_country_code
			End
        close c1
		DEALLOCATE c1
		DEALLOCATE cur_publ
		
        select distinct a.comp_code as "COMP_CODE",a.unit_code as "UNIT_CODE",a.agcd as "AGCD",a.dpcd as "DPCD",
        a.bill_amt as "CL_BAL",a.agname as "AGNAME",a.agname_oth_lang as "AGNAME_OTH_LANG",
        a.city_code as "CITY_CODE",dbo.cir_get_city(a.comp_code,a.city_code) as "CITY_NAME",
        a.publ_code as "PUBL",dbo.cir_get_publ_name(a.comp_code,a.publ_code) as "PUBL_NAME"
        from #cir_temp_outstanding a
        order by comp_code,unit_code,publ_name
        
    select getdate() as "CUR_DATE"
    
	drop table #cir_temp_outstanding
     
End

////////////////////////////////////next

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




////////////////////////////////////////////end//////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////ADD BY DEEPIKA 09/10/2012 SENT BY GAURAV SIR///////////////////

                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE  [dbo].[cir_new_publ_update_in_supply]

  	@pcompcode as varchar(200),
    @pdateformat as	varchar(200),
    @puserid as varchar(200),    
    @punitcode as varchar(200),    
    @pbranch as varchar(200),
    @ppubl   as varchar(200),
    @pedtn   as varchar(20),
    @pextra1 as	varchar(200),
    @pextra2 as varchar(200),
    @pextra3 as	varchar(200),
    @pextra4 as varchar(200),
    @pextra5 as	varchar(200),
    @pextra6 as varchar(200),
    @pextra7 as	varchar(200),
    @pextra8 as varchar(200),
    @pextra9 as	varchar(200),
    @pextra10 as varchar(200)

 AS
   begin
		 declare @countc as numeric(10)
		 declare @countcommcat as numeric(10);
   				select @countcommcat=count(*) from CIR_COMM_CATG_MAST
				select @countc=count(*) from CIR_COMM_MAST where COMP_CODE=@pcompcode 
				and (UNIT_CODE=@punitcode or @punitcode='' or @punitcode is null)
				and PUBL=@ppubl and EDTN= @pedtn
				
		if @countc=0
		begin
		declare @v3_UNIT			as varchar(20)
		declare @v3_COMM_CD			as varchar(20)
		declare @v3_COMM_TYP		as varchar(20)
		declare @v3_VALID_FROM		as datetime
		declare @v3_SUP_FROM		as numeric(10)
		declare @v3_SUP_TO			as numeric(10)
		declare @v3_SUN_COMM		as numeric(10)
		declare @v3_MON_COMM		as numeric(10)
		declare @v3_TUS_COMM		as numeric(10)
		declare @v3_WED_COMM		as numeric(10)
		declare @v3_THU_COMM		as numeric(10)
		declare @v3_FRI_COMM		as numeric(10)
		declare @v3_SAT_COMM		as numeric(10)
		declare @v3_FREEZE_FLG		as varchar(1)
		declare @v3_COMM_CAT_CODE	as varchar(5)
		declare @v3_COMM_CAT_TYP	as varchar(1)
	

		declare comm cursor local for
			select unit_code,COMM_CODE,COMM_TYPE,VALID_FROM,SUP_COPY_FROM,SUP_COPY_TO,SUN_COMM_RATE,MON_COMM_RATE,TUE_COMM_RATE,
			WED_COMM_RATE,THU_COMM_RATE,FRI_COMM_RATE,SAT_COMM_RATE,FREEZE_FLAG,COMM_CATG_CODE,COMM_CATG_TYPE from CIR_COMM_MAST
			where PUBL in(select top 1 publ from CIR_PUBL_MAST where PRO_TYPE in(select PRO_TYPE from CIR_PUBL_MAST 
			where COMP_CODE =@pcompcode and PUBL=@ppubl))and EDTN in (select top 1 EDTN  from CIR_EDTN_MAST where PUBL 
			in(select top 1 publ from CIR_PUBL_MAST where PRO_TYPE in(select PRO_TYPE from CIR_PUBL_MAST where COMP_CODE =@pcompcode
			and PUBL=@ppubl)) and EDTN_TY='S')
		open comm

			fetch  next from comm into  @v3_unit,@v3_COMM_CD,@v3_COMM_TYP,@v3_VALID_FROM,@v3_SUP_FROM,@v3_SUP_TO,@v3_SUN_COMM,@v3_MON_COMM,@v3_TUS_COMM,
			@v3_WED_COMM,@v3_THU_COMM,@v3_FRI_COMM,@v3_SAT_COMM,@v3_FREEZE_FLG,@v3_COMM_CAT_CODE,@v3_COMM_CAT_TYP
				 while (@@fetch_status=0)
				 Begin
			 
					 insert into CIR_COMM_MAST(COMP_CODE,UNIT_CODE,PUBL,EDTN,COMM_CODE,COMM_TYPE,VALID_FROM,SUP_COPY_FROM,SUP_COPY_TO,SUN_COMM_RATE,MON_COMM_RATE,TUE_COMM_RATE,
					 WED_COMM_RATE,THU_COMM_RATE,FRI_COMM_RATE,SAT_COMM_RATE,FREEZE_FLAG,CREATION_DATE, COMM_CATG_CODE,COMM_CATG_TYPE,UPDATED_DT) 
					 values(@pcompcode,@v3_unit,@ppubl,@pedtn,@v3_COMM_CD,@v3_COMM_TYP,@v3_VALID_FROM,@v3_SUP_FROM,@v3_SUP_TO,@v3_SUN_COMM,@v3_MON_COMM,@v3_TUS_COMM,
					 @v3_WED_COMM,@v3_THU_COMM,@v3_FRI_COMM,@v3_SAT_COMM,@v3_FREEZE_FLG,GETDATE(),@v3_COMM_CAT_CODE,@v3_COMM_CAT_TYP,GETDATE())
				
			fetch  next from comm into  @v3_unit,@v3_COMM_CD,@v3_COMM_TYP,@v3_VALID_FROM,@v3_SUP_FROM,@v3_SUP_TO,@v3_SUN_COMM,@v3_MON_COMM,@v3_TUS_COMM,
			@v3_WED_COMM,@v3_THU_COMM,@v3_FRI_COMM,@v3_SAT_COMM,@v3_FREEZE_FLG,@v3_COMM_CAT_CODE,@v3_COMM_CAT_TYP
			end
			close comm
			deallocate comm
			end
				
				
   declare @v1_UNIT as varchar(20)
   declare @v1_AGCD as varchar(20)
   declare @v1_DPCD as varchar(20)
   declare @v1_BILLING_CYCLE as varchar(2)
   declare @v1_INSERTION_FEE as varchar(2)
   declare @v1_LATE_FEE as varchar(2)
   declare @v1_INCENTIVE as varchar(2)
   declare @v_cnt as int
	declare @v2_COMM_FLAG as varchar(20)
	declare @v2_COMM_CODE as varchar(20)
	declare @v2_ROUTE_CODE as varchar(20)
	declare @v2_SUBROUTE_CODE as varchar(20)
	declare @v2_SUB_SUBROUTE_CODE as varchar(20)
	declare @v2_WASTE_CATG_CODE as varchar(20)

   
   DECLARE c1 cursor LOCAL FOR 
    select UNIT,AGCD,DPCD from cir_agmast where COMP_CODE=@pcompcode     
    and (UNIT=@punitcode or @punitcode is null or @punitcode ='')
    and ( agcd+dpcd in(select distinct agcd+dpcd from cir_supply where 
    COMP_CODE=@pcompcode     
    and (UNIT=@punitcode or @punitcode is null or @punitcode ='') ) )
   
	   
	OPEN c1 
	fetch NEXT FROM c1 INTO @v1_UNIT, @v1_AGCD ,@v1_DPCD
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN
			print('A')
			select top 1 @v2_COMM_FLAG=COMM_FLAG,@v2_COMM_CODE=COMM_CODE,@v2_ROUTE_CODE=ROUTE_CODE,@v2_SUBROUTE_CODE=SUBROUTE_CODE
			,@v2_SUB_SUBROUTE_CODE=SUB_SUBROUTE_CODE,@v2_WASTE_CATG_CODE=WASTE_CATG_CODE,@v1_BILLING_CYCLE=BILLING_CYCLE,@v1_INCENTIVE=INCENTIVE
			,@v1_INSERTION_FEE=INSERTION_FEE,@v1_LATE_FEE=LATE_FEE
			from cir_supply
			where COMP_CODE=@pcompcode and agcd=@v1_AGCD and dpcd=@v1_DPCD
			and (UNIT=@punitcode or @punitcode is null or @punitcode ='')
						
			select @v_cnt =count(*) from CIR_SUPPLY where COMP_CODE=@pcompcode 
			and AGCD=@v1_AGCD and DPCD=@v1_DPCD and PUBL=@ppubl and EDTN=@pedtn
			print(@v_cnt)
			
			if(@v_cnt=0)
			begin
				INSERT INTO cir_supply (COMP_CODE,UNIT,AGCD,DPCD,PUBL,EDTN,SUPPLY_FLAG,SUPPLY_TYPE_CODE,BASE_SUPPLY,SUPPLY_SUN
										,SUPPLY_MON,SUPPLY_TUE,SUPPLY_WED,SUPPLY_THU,SUPPLY_FRI,SUPPLY_SAT,DEVATION_SUPPLY
										,COMM_FLAG,COMM_CODE,PACKET_SIZE,ROUTE_CODE,SUBROUTE_CODE,SUB_SUBROUTE_CODE,USERID
										,SUPPLY_SPL1,SUPPLY_SPL2,LBL_PRINTNO,SURCH_CD,BILLING_CYCLE,INSERTION_FEE,WASTE_CATG_CODE
										,SP_SUPPLY_MON1,SP_SUPPLY_TUE1,SP_SUPPLY_WED1,SP_SUPPLY_THU1,SP_SUPPLY_FRI1,SP_SUPPLY_SAT1
										,SP_SUPPLY_SUN1,SP_SUPPLY_MON2,SP_SUPPLY_TUE2,SP_SUPPLY_WED2,SP_SUPPLY_THU2,SP_SUPPLY_FRI2
										,SP_SUPPLY_SAT2,SP_SUPPLY_SUN2,LATE_FEE,INCENTIVE)
				VALUES				   (@pcompcode,@v1_UNIT,@v1_AGCD,@v1_DPCD,@ppubl,@pedtn,'Y','S01',0,0
										,0,0,0,0,0,0,0,
										@v2_COMM_FLAG,@v2_COMM_CODE,0,@v2_ROUTE_CODE,@v2_SUBROUTE_CODE,@v2_SUB_SUBROUTE_CODE,@puserid
										,0,0,0,null,@v1_BILLING_CYCLE,isnull(@v1_INSERTION_FEE,'N'),isnull(@v2_WASTE_CATG_CODE,'N')
										,0,0,0,0,0,0,0,0,0,0,0,0
										,0,0,isnull(@v1_LATE_FEE,'N'),isnull(@v1_INCENTIVE,'N'))
			end
					
				

		fetch NEXT FROM c1 INTO @v1_UNIT, @v1_AGCD ,@v1_DPCD--,@v1_BILLING_CYCLE,@v1_INSERTION_FEE,@v1_LATE_FEE,@v1_INCENTIVE
		END 
	close c1
	DEALLOCATE c1
   
end






///////////////////////////////////////////////END/////////////////////////////////////////////////

************************* rikkee garg 09-10-2012(street saler sql procedure)**************************


ALTER procedure [dbo].[cir_street_sale_ins]
@PCOMP_CODE   as  VARCHAR(100),
	@PUNIT         as  VARCHAR(100),
	@PBRANCH_CODE   as  VARCHAR(100),
	@PAGCD          as  VARCHAR(100),
	@PDPCD         as  VARCHAR(100),
	@PSUP_DATE      as  VARCHAR(100),
	@PPUBL_CODE    as  VARCHAR(100),
	@PEDTN_CODE     as  VARCHAR(100),
	@PSUPPLY_COPY   numeric(20),
	@PSUPPLY_RATE   numeric(20),
	@PSUPPLY_AMT    numeric(20),
	@PAMT_PAID       numeric(20),
	@PTOTAL_PAID_AMOUNT  numeric(20),
	@PUNSOLD_DATE   as  VARCHAR(100),
	@PUNSOLD_COPY   numeric(20),
	@PUNSOLD_RATE    numeric(20),
	@PUNSOLD_AMT     numeric(20),
	@PINSERT_DATE   as  VARCHAR(100),
	@PINSERT_BY     as  VARCHAR(100),
	@PUPDATED_BY    as  VARCHAR(100),
	@PUPDATED_DATE  as  VARCHAR(100),
	@PDATEFORMAT    as  VARCHAR(100),
	@PEXTRA1        as  VARCHAR(100),
	@PEXTRA2        as  VARCHAR(100),
	@PEXTRA3        as  VARCHAR(100),
	@PEXTRA4       as  VARCHAR(100),
	@PEXTRA5       as  VARCHAR(100),
	@PEXTRA6       as  VARCHAR(100),
	@PEXTRA7       as  VARCHAR(100),
	@PEXTRA8       as  VARCHAR(100),
	@PEXTRA9       as  VARCHAR(100),
	@PEXTRA10      as  VARCHAR(100),
	@PEXTRA11      as  VARCHAR(100),
	@PEXTRA12      as  VARCHAR(100),
	@PEXTRA13       as  VARCHAR(100),
	@PEXTRA14       as  VARCHAR(100),
	@PEXTRA15       as  VARCHAR(100)
	
	as
	 
   print('1')
	declare @V_SUP_DATE       datetime
	declare @V_UNSOLD_DATE    datetime
	declare @V_INSERT_DATE    datetime
	declare @V_UPDATED_DATE   datetime
	declare @V_TRN_NO         numeric(20)
	declare @V_TRN_NO_CHAR    varchar(100)
	declare @V_CNT            numeric(20)
	
	
	begin
	
	set @V_SUP_DATE	=	DBO.CONVERT_USER_DATE('/', @PSUP_DATE,@pdateformat)
	set @V_UNSOLD_DATE	=	DBO.CONVERT_USER_DATE('/', @PUNSOLD_DATE,@pdateformat)
	set @V_INSERT_DATE	=	DBO.CONVERT_USER_DATE('/', @PINSERT_DATE,@pdateformat)
	set @V_UPDATED_DATE	=	DBO.CONVERT_USER_DATE('/', @PUPDATED_DATE,@pdateformat)
	  
   
	BEGIN
	  
   
	SELECT @V_CNT =  COUNT(*)  FROM CIR_STREET_SALE 
             WHERE COMP_CODE   = @PCOMP_CODE
               AND UNIT        = @PUNIT
               AND BRANCH_CODE = @PBRANCH_CODE
               AND PUBL_CODE   = @PPUBL_CODE
               AND EDTN_CODE   = @PEDTN_CODE
               AND (AGCD        = @PAGCD OR @PAGCD=NULL OR @PAGCD='')
               AND (DPCD        = @PDPCD OR @PDPCD=NULL OR @PDPCD='')
               AND SUP_DATE    = @V_SUP_DATE
          
            print(@V_CNT) 
             if(@V_CNT is null )begin
            set @V_CNT = 0
            end
   END
print('@V_CNT')print(@V_CNT)
   IF(ISNULL(@V_CNT,0)>0)   
   BEGIN
   print('@V_CNTupdate')print(@V_CNT)
				UPDATE CIR_STREET_SALE SET SUPPLY_COPY = @PSUPPLY_COPY, SUPPLY_RATE = @PSUPPLY_RATE, SUPPLY_AMT = @PSUPPLY_AMT, 
				AMT_PAID = @PAMT_PAID, UNSOLD_DATE = @V_UNSOLD_DATE, UNSOLD_COPY = @PUNSOLD_COPY,
				UNSOLD_RATE = @PUNSOLD_RATE, UNSOLD_AMT = @PUNSOLD_AMT
				WHERE COMP_CODE   = @PCOMP_CODE
				AND UNIT        = @PUNIT
				AND BRANCH_CODE = @PBRANCH_CODE
				AND PUBL_CODE   = @PPUBL_CODE
				AND EDTN_CODE   = @PEDTN_CODE
				AND AGCD        = @PAGCD
				AND DPCD        = @PDPCD
				AND SUP_DATE    = @V_SUP_DATE
               
    END    
    
    ELSE 
    
    BEGIN
 	   print('@V_CNTinsert')print(@V_CNT)
		 SELECT @V_TRN_NO=cast(MAX(substring(TRN_CODE,7,5)) as numeric)FROM CIR_STREET_SALE WHERE COMP_CODE=@PCOMP_CODE AND SUP_DATE=@V_SUP_DATE;
		
       
      
      IF ISNULL(@V_TRN_NO,0)=0 
        BEGIN
           
             SET @V_TRN_NO = 1
        end
        
      else
        BEGIN
        SET  @V_TRN_NO = ISNULL(@V_TRN_NO,0)+1 
        END
    print(@V_TRN_NO)
    
SET  @V_TRN_NO_CHAR = convert(varchar(6),@V_SUP_DATE,12)+replace(replace(str(convert(varchar(6),@V_SUP_DATE,12),9),' ',0),convert(varchar(6),@V_SUP_DATE,12),@V_TRN_NO)
       INSERT INTO CIR_STREET_SALE (COMP_CODE, UNIT, BRANCH_CODE, AGCD, DPCD,
                                        TRN_CODE, SUP_DATE, PUBL_CODE, EDTN_CODE, SUPPLY_COPY, 
                                        SUPPLY_RATE, SUPPLY_AMT, AMT_PAID,TOTAL_PAID_AMOUNT, UNSOLD_DATE, UNSOLD_COPY,
                                        UNSOLD_RATE, UNSOLD_AMT, INSERT_DATE, INSERT_BY, UPDATED_BY, 
                                        UPDATED_DATE)
                                VALUES (@PCOMP_CODE, @PUNIT, @PBRANCH_CODE, @PAGCD, @PDPCD,
                                        @V_TRN_NO_CHAR, @V_SUP_DATE, @PPUBL_CODE, @PEDTN_CODE, @PSUPPLY_COPY, 
                                        @PSUPPLY_RATE, @PSUPPLY_AMT, @PAMT_PAID,@PTOTAL_PAID_AMOUNT ,@V_UNSOLD_DATE, @PUNSOLD_COPY, 
                                        @PUNSOLD_RATE, @PUNSOLD_AMT, ISNULL(@V_INSERT_DATE,GETDATE()), @PINSERT_BY, @PUPDATED_BY, 
                                        ISNULL(@V_UPDATED_DATE,GETDATE()))
                                        
                                        
    end                                
       
       end
            
  
  
              
*****************end *********************************

********************************************************verification of sale- monthly***************************************

ALTER PROCEDURE [dbo].[cir_rep_net_monthly_sale_verification]
	@pcomp_code         as varchar(20),
	@punit_code         as varchar(20),
	@ppubl              as varchar(20),
	@pubtype            as varchar(50),-- for publication type @pubtype
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
	@pbreak_on          as varchar(20),--Region R/State S/District D/Branch B / ZONE Z/ routewise O/ center C /PUBL  P / EDITION E
	@preturn_based      as varchar(20),--it is use for return date or supply date(R/S)		
	@pdateformat        as varchar(20),
	@pcommper           as numeric(14,2), -- for commper  
	@pcomslab           as varchar(50), -- for commision less than or greater than
	@psuptype           as varchar(50),-- for supply type
	@pcopy_amt          as varchar(10),-- for based on copy or amt / C for Copy and A for AMOUNT	
	@pextra1            as varchar(50),
	@pextra2            as varchar(50),
	@pextra3            as varchar(50),		
	@pextra5            as varchar(50),
	@pextra6            as varchar(50),
	@pextra7            as varchar(50),
	@pextra8            as varchar(50),
	@pextra9            as varchar(50),
	@pextra10            as varchar(50)
AS 
		
	DECLARE @v_hdays	AS	NUMERIC(5) 
	DECLARE @v_avg_sale AS  NUMERIC(10) 
	DECLARE @v_reg_code AS  varchar(200)
	DECLARE @v_zone_code varchar(200);
	DECLARE @v_publ_code varchar(200);
	DECLARE @v_route_code varchar(200);

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
    DECLARE @v1_route_code   		as varchar(50)
    DECLARE @v1_route_name			as varchar(150)
    DECLARE @v1_supply_copy			as int
    DECLARE @v1_return_copy			as int
    DECLARE @v1_net_sale_copy		as int
    DECLARE @v1_no_of_days			as int
    DECLARE @v1_unit_name			as varchar(150)
    DECLARE @v1_COM_CAT  			as varchar(150)
    declare @v1_supdate				as datetime


CREATE TABLE #CIR_DBKSUP_temp
(
	COMP_CODE varchar(8) NOT NULL,
	UNIT_CODE varchar(8) NOT NULL,
	PUBL varchar(3) NOT NULL,
	EDTN varchar(3) NOT NULL,
	AGCD varchar(8) NOT NULL,
	DPCD varchar(8) NOT NULL,
	SUPDATE datetime NOT NULL,
	SUP_TYPE_CODE varchar(5) NOT NULL,
	SUP_COPY numeric(10, 0) NULL,
	AGENCY_TY_CODE varchar(8) NULL,
	AGENCY_PKT_SIZE numeric(7, 0) NULL,
	COMM_CODE varchar(6) NULL,
	COMM_FIX_AUTO_SPL varchar(1) NULL,
	SUP_RATE numeric(10, 4) NULL,
	BILLAGCD varchar(8) NULL,
	BILLDPCD varchar(8) NULL,
	ROUTE_CODE varchar(5) NULL,
	SUBROUTE_CODE varchar(5) NULL,
	SUBSUBROUTE_CODE varchar(5) NULL,
	USERID varchar(10) NULL,
	CREATION_DATE datetime NULL,
	SURCH_CD varchar(5) NULL,
	ISSUE_DATE datetime NULL,
	RETURN_COPY_SALE varchar(1) NULL,
	FINAL_SUPPLY_FLAG varchar(1) NULL,
	UPDATED_BY varchar(30) NULL,
	UPDATED_DT datetime NULL,
	PER_COPY_WEIGHT numeric(15, 3) NULL,
	WASTE_CATG_CODE varchar(40) NULL
)

	
	if @pcomslab ='G' 
	begin
	print('1111')
		insert into #CIR_DBKSUP_temp(
		COMP_CODE,UNIT_CODE,PUBL,EDTN,AGCD,DPCD,SUPDATE,SUP_TYPE_CODE,SUP_COPY,AGENCY_TY_CODE,AGENCY_PKT_SIZE,
		COMM_CODE,COMM_FIX_AUTO_SPL,SUP_RATE,BILLAGCD,BILLDPCD,ROUTE_CODE,SUBROUTE_CODE,SUBSUBROUTE_CODE,
		USERID,CREATION_DATE,SURCH_CD,ISSUE_DATE,RETURN_COPY_SALE,FINAL_SUPPLY_FLAG,UPDATED_BY,UPDATED_DT,
		PER_COPY_WEIGHT,WASTE_CATG_CODE
		)
		select COMP_CODE,UNIT_CODE,PUBL,EDTN,AGCD,DPCD,SUPDATE,SUP_TYPE_CODE,SUP_COPY,AGENCY_TY_CODE,AGENCY_PKT_SIZE,
		COMM_CODE,COMM_FIX_AUTO_SPL,SUP_RATE,BILLAGCD,BILLDPCD,ROUTE_CODE,SUBROUTE_CODE,SUBSUBROUTE_CODE,
		USERID,CREATION_DATE,SURCH_CD,ISSUE_DATE,RETURN_COPY_SALE,FINAL_SUPPLY_FLAG,UPDATED_BY,UPDATED_DT,
		PER_COPY_WEIGHT,WASTE_CATG_CODE 
		from cir_dbksup b
		where b.comp_code =@pcomp_code 
		and (b.unit_code=@punit_code or @punit_code is null or @punit_code ='') 
		and (b.publ=isnull(@ppubl,b.publ) or @ppubl='') 
		and (b.edtn=isnull(@pedtn,b.edtn) or @pedtn='') 
		and (b.agcd=isnull(@pagcd,b.agcd) or @pagcd='') 
		and (b.dpcd=isnull(@pdpcd,b.dpcd) or @pdpcd='')
		and b.supdate >= @pfromdate and b.supdate <=@ptilldate
		and (b.comm_code=@pextra3 or @pextra3 is null or @pextra3 ='')
		and (b.sup_type_code=@psuptype or @psuptype is null or @psuptype ='') 
/*and ( cast(substring(cast(dbo.cir_get_commission(b.comp_code,b.unit_code,b.publ,b.edtn,b.COMM_FIX_AUTO_SPL,
b.COMM_CODE,b.SUPDATE,@pdateformat,b.SUP_COPY,'','' ) as varchar),2,
len(cast(dbo.cir_get_commission(b.comp_code,b.unit_code,b.publ,b.edtn,b.COMM_FIX_AUTO_SPL,b.COMM_CODE,b.SUPDATE,
@pdateformat,b.SUP_COPY,'','' ) as varchar)) ) as numeric) > 
cast(@pcommper as numeric) or cast(@pcommper as numeric) is null or cast(@pcommper as numeric) = '0')
*/

and ( (case(isnull(substring(cast(dbo.cir_get_commission(b.comp_code,b.unit_code,b.publ,b.edtn,b.COMM_FIX_AUTO_SPL,
b.COMM_CODE,b.SUPDATE,@pdateformat,b.SUP_COPY,'','' ) as varchar),2,
len(cast(dbo.cir_get_commission(b.comp_code,b.unit_code,b.publ,b.edtn,b.COMM_FIX_AUTO_SPL,b.COMM_CODE,b.SUPDATE,
@pdateformat,b.SUP_COPY,'','' ) as varchar)) ),0)  )
when '' then 0 
else cast(substring(cast(dbo.cir_get_commission(b.comp_code,b.unit_code,b.publ,b.edtn,b.COMM_FIX_AUTO_SPL,
b.COMM_CODE,b.SUPDATE,@pdateformat,b.SUP_COPY,'','' ) as varchar),2,
len(cast(dbo.cir_get_commission(b.comp_code,b.unit_code,b.publ,b.edtn,b.COMM_FIX_AUTO_SPL,b.COMM_CODE,b.SUPDATE,
@pdateformat,b.SUP_COPY,'','' ) as varchar)) ) as numeric) end) 
>cast(@pcommper as numeric) or cast(@pcommper as numeric) is null or cast(@pcommper as numeric) = '0')
		print('2222')
	end
	else
	begin
		insert into #CIR_DBKSUP_temp(
		COMP_CODE,UNIT_CODE,PUBL,EDTN,AGCD,DPCD,SUPDATE,SUP_TYPE_CODE,SUP_COPY,AGENCY_TY_CODE,AGENCY_PKT_SIZE,
		COMM_CODE,COMM_FIX_AUTO_SPL,SUP_RATE,BILLAGCD,BILLDPCD,ROUTE_CODE,SUBROUTE_CODE,SUBSUBROUTE_CODE,
		USERID,CREATION_DATE,SURCH_CD,ISSUE_DATE,RETURN_COPY_SALE,FINAL_SUPPLY_FLAG,UPDATED_BY,UPDATED_DT,
		PER_COPY_WEIGHT,WASTE_CATG_CODE
		)
		select COMP_CODE,UNIT_CODE,PUBL,EDTN,AGCD,DPCD,SUPDATE,SUP_TYPE_CODE,SUP_COPY,AGENCY_TY_CODE,AGENCY_PKT_SIZE,
		COMM_CODE,COMM_FIX_AUTO_SPL,SUP_RATE,BILLAGCD,BILLDPCD,ROUTE_CODE,SUBROUTE_CODE,SUBSUBROUTE_CODE,
		USERID,CREATION_DATE,SURCH_CD,ISSUE_DATE,RETURN_COPY_SALE,FINAL_SUPPLY_FLAG,UPDATED_BY,UPDATED_DT,
		PER_COPY_WEIGHT,WASTE_CATG_CODE 
		from cir_dbksup b
		where b.comp_code =@pcomp_code 
		and (b.unit_code=@punit_code or @punit_code is null or @punit_code ='') 
		and (b.publ=isnull(@ppubl,b.publ) or @ppubl='') 
		and (b.edtn=isnull(@pedtn,b.edtn) or @pedtn='') 
		and (b.agcd=isnull(@pagcd,b.agcd) or @pagcd='') 
		and (b.dpcd=isnull(@pdpcd,b.dpcd) or @pdpcd='')
		and b.supdate >= @pfromdate and b.supdate <=@ptilldate
		and (b.comm_code=@pextra3 or @pextra3 is null or @pextra3 ='')
		and (b.sup_type_code=@psuptype or @psuptype is null or @psuptype ='') 
		and ( cast(substring(cast(dbo.cir_get_commission(b.comp_code,b.unit_code,b.publ,b.edtn,b.COMM_FIX_AUTO_SPL,b.COMM_CODE,b.SUPDATE,@pdateformat,b.SUP_COPY,'','' ) as varchar),2,len(cast(dbo.cir_get_commission(b.comp_code,b.unit_code,b.publ,b.edtn,b.COMM_FIX_AUTO_SPL,b.COMM_CODE,b.SUPDATE,@pdateformat,b.SUP_COPY,'','' ) as varchar)) ) as numeric) < cast(@pcommper as numeric) or cast(@pcommper as numeric) is null or cast(@pcommper as numeric) = '0')
	end
	

	
	if @pcopy_amt ='C' begin	
		DECLARE c1 cursor LOCAL FOR 
		select u.comp_code,u.unit_code,
		u.branch_code branch_code,(select distinct Branch_Name from branch_mst where Branch_Code=u.branch_code) branch_name,
		u.publ,u.publ_name,u.main_edtn,
		dbo.cir_get_edtn_name(u.comp_code,u.main_edtn) main_edtn_name,u.edtn edtn,u.edtn_name,u.copy_rate,
		u.agcd agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang agname_oth_lang,
		u.state_code,dbo.cir_get_state(u.comp_code,u.country_code,u.state_code) state_name,
		u.dist_code ,dbo.cir_get_name_cir_district(u.comp_code,u.dist_code,'1',null,null,null) dist_name,
		u.city_code city_code,dbo.cir_get_name_cir_city(u.comp_code,u.city_code,'1',null,null,null) city_name,
		u.tehsil_taluka,dbo.cir_get_name_cir_taluka(u.comp_code,u.tehsil_taluka,'1',null,null,null) taluka_name,
		u.route_code,dbo.cir_get_route_name(u.comp_code,u.unit_code,u.route_code ) route_name,
		sum(supply_copy) supply_copy,sum(return_copy) return_copy,
		sum(supply_copy)-sum(return_copy) net_sale_copy,sum(no_of_days) no_of_days
		,dbo.cir_get_unit_name(u.comp_code,u.unit_code) as UNIT_NAME
		,u.MON		
		from (
		select b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.sup_rate copy_rate,
		b.agcd,b.dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang
		,a.branch_code,a.city_code,a.dist_code, a.state_code,a.country_code,a.tehsil_taluka, b.route_code, 
		sum(isnull(b.sup_copy,0)) supply_copy,0 return_copy, count(distinct supdate) no_of_days		
		,upper(SUBSTRING(CONVERT(VARCHAR(11), b.supdate, 113), 4, 3)) as MON
		from cir_agmast a,#CIR_DBKSUP_temp b,cir_edtn_mast e,cir_publ_mast p		
		where b.comp_code =a.comp_code and b.comp_code=e.comp_code and b.comp_code=p.comp_code and 
		b.comp_code =@pcomp_code and 
		b.unit_code=a.unit and (b.unit_code=@punit_code or @punit_code is null or @punit_code ='') and 
		b.publ=p.publ and (b.publ=isnull(@ppubl,b.publ) or @ppubl='') and b.edtn=e.edtn and (b.edtn=isnull(@pedtn,b.edtn) or @pedtn='') and
		a.agcd=b.agcd and (b.agcd=isnull(@pagcd,b.agcd) or @pagcd='') and a.dpcd=b.dpcd and (b.dpcd=isnull(@pdpcd,b.dpcd) or @pdpcd='') and
		b.supdate >= @pfromdate and b.supdate <=@ptilldate and 
		(a.ag_type=@pagency_type or @pagency_type is null or @pagency_type='') and(a.ag_class=@pagency_class or @pagency_class is null or @pagency_class='') and
		(a.branch_code=@pbranch or @pbranch is null or @pbranch='') and (a.state_code=@pstatecode or @pstatecode is null or @pstatecode='') and
		(a.dist_code=@pdistcode or @pdistcode is null or @pdistcode='') and (a.tehsil_taluka=@ptaluka or @ptaluka is null or @ptaluka='') and
		(e.main_edtn=@pmainedtn or @pmainedtn is null or @pmainedtn='')
		and (b.comm_code=@pextra3 or @pextra3 is null or @pextra3 ='')
		and (p.pro_type=@pubtype or @pubtype is null or @pubtype ='')
		and (b.sup_type_code=@psuptype or @psuptype is null or @psuptype ='')    
		and (dbo.cir_get_zone_by_city(a.comp_code,a.city_code,'C')=@pextra1 or @pextra1 is null or @pextra1 ='')
		and (dbo.cir_get_region_by_city(a.comp_code,a.city_code,'C')=@pextra2 or @pextra2 is null or @pextra2 ='')
		group by b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.sup_rate,
		b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.branch_code,a.city_code,a.dist_code, a.state_code,
		a.country_code,a.tehsil_taluka,b.route_code,upper(SUBSTRING(CONVERT(VARCHAR(11), b.supdate, 113), 4, 3))
		union all
		select b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.copy_rate,
		b.agcd,b.dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
		a.branch_code,a.city_code,a.dist_code, a.state_code,a.country_code,a.tehsil_taluka,d.route_code,  
		0 supply_copy,sum(isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0)) return_copy,0 no_of_days
		,upper(SUBSTRING(CONVERT(VARCHAR(11), b.supdate, 113), 4, 3)) as MON
		from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e,cir_publ_mast p,cir_dbksup d
		where b.comp_code =a.comp_code and b.comp_code=e.comp_code and b.comp_code=p.comp_code and b.comp_code =@pcomp_code and 
		b.unit_code=a.unit and (b.unit_code=@punit_code or @punit_code is null or @punit_code ='') and  
		b.doctype='UCN' and ((b.recptdt >= @pfromdate and b.recptdt <=@ptilldate and isnull(@preturn_based,'R') ='R') or (b.supdate >= @pfromdate and b.supdate <=@ptilldate and isnull(@preturn_based,'R') ='S')) and 
		b.publ=d.publ and b.edtn=d.edtn and a.agcd=d.agcd and a.dpcd=d.dpcd and
		b.publ=e.publ and b.publ=p.publ and (b.publ=isnull(@ppubl,b.publ) or @ppubl='') and b.edtn=e.edtn and (b.edtn=isnull(@pedtn,b.edtn) or @pedtn='') and 
		a.agcd=b.agcd and (b.agcd=isnull(@pagcd,b.agcd) or @pagcd='') and a.dpcd=b.dpcd and (b.dpcd=isnull(@pdpcd,b.dpcd) or @pdpcd='') and
		(a.ag_type=@pagency_type or @pagency_type is null or @pagency_type='') and(a.ag_class=@pagency_class or @pagency_class is null or @pagency_class='') and
		(a.branch_code=@pbranch or @pbranch is null or @pbranch='') and (a.state_code=@pstatecode or @pstatecode is null or @pstatecode='') and
		(a.dist_code=@pdistcode or @pdistcode is null or @pdistcode='') and (a.tehsil_taluka=@ptaluka or @ptaluka is null or @ptaluka='') and
		(isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))>0 and
		(e.main_edtn=@pmainedtn or @pmainedtn is null)
		and (d.comm_code=@pextra3 or @pextra3 is null or @pextra3 ='')
		and (p.pro_type=@pubtype or @pubtype is null or @pubtype ='')
		and (d.sup_type_code=@psuptype or @psuptype is null or @psuptype ='')
		and (dbo.cir_get_zone_by_city(a.comp_code,a.city_code,'C')=@pextra1 or @pextra1 is null or @pextra1 ='')
		and (dbo.cir_get_region_by_city(a.comp_code,a.city_code,'C')=@pextra2 or @pextra2 is null or @pextra2 ='')
		group by b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.copy_rate,
		b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.branch_code,a.city_code,a.dist_code, a.state_code,
		a.country_code,a.tehsil_taluka,d.route_code,upper(SUBSTRING(CONVERT(VARCHAR(11), b.supdate, 113), 4, 3))) u
		where (u.supply_copy+u.return_copy)>0
		group by u.comp_code,u.unit_code,u.branch_code,u.publ,u.publ_name,u.main_edtn,u.edtn,u.edtn_name,u.copy_rate,
		u.agcd,u.dpcd,u.agname,u.agname_oth_lang,u.state_code,u.dist_code ,u.city_code,u.tehsil_taluka,u.route_code
		,u.country_code,u.MON; 
	end
	else
	begin
		DECLARE c1 cursor LOCAL FOR 
		select u.comp_code,u.unit_code,
		u.branch_code branch_code,(select distinct Branch_Name from branch_mst where Branch_Code=u.branch_code) branch_name,
		u.publ,u.publ_name,u.main_edtn,
		dbo.cir_get_edtn_name(u.comp_code,u.main_edtn) main_edtn_name,u.edtn edtn,u.edtn_name,u.copy_rate,
		u.agcd agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang agname_oth_lang,
		u.state_code,dbo.cir_get_state(u.comp_code,u.country_code,u.state_code) state_name,
		u.dist_code ,dbo.cir_get_name_cir_district(u.comp_code,u.dist_code,'1',null,null,null) dist_name,
		u.city_code city_code,dbo.cir_get_name_cir_city(u.comp_code,u.city_code,'1',null,null,null) city_name,
		u.tehsil_taluka,dbo.cir_get_name_cir_taluka(u.comp_code,u.tehsil_taluka,'1',null,null,null) taluka_name,
		u.route_code,dbo.cir_get_route_name(u.comp_code,u.unit_code,u.route_code ) route_name,
		(sum(supply_copy)* u.copy_rate) supply_copy,(sum(return_copy)* u.copy_rate) return_copy,
		(sum(supply_copy)* u.copy_rate)-(sum(return_copy)* u.copy_rate) net_sale_copy,sum(no_of_days) no_of_days
		,dbo.cir_get_unit_name(u.comp_code,u.unit_code) as UNIT_NAME
		,u.MON as MON
		from (
		select b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.sup_rate copy_rate,
		b.agcd,b.dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
		a.branch_code,a.city_code,a.dist_code, a.state_code,a.country_code,a.tehsil_taluka, b.route_code, 
		sum(isnull(b.sup_copy,0)) supply_copy,0 return_copy, count(distinct supdate) no_of_days		
		,upper(SUBSTRING(CONVERT(VARCHAR(11), b.supdate, 113), 4, 3)) as MON
		from cir_agmast a,#CIR_DBKSUP_temp b,cir_edtn_mast e,cir_publ_mast p
		where b.comp_code =a.comp_code and b.comp_code=e.comp_code and b.comp_code=p.comp_code and 
		b.comp_code =@pcomp_code and 
		b.unit_code=a.unit and (b.unit_code=@punit_code or @punit_code is null or @punit_code ='') and 
		b.publ=p.publ and (b.publ=isnull(@ppubl,b.publ) or @ppubl='') and b.edtn=e.edtn and (b.edtn=isnull(@pedtn,b.edtn) or @pedtn='') and
		a.agcd=b.agcd and (b.agcd=isnull(@pagcd,b.agcd) or @pagcd='') and a.dpcd=b.dpcd and (b.dpcd=isnull(@pdpcd,b.dpcd) or @pdpcd='') and
		b.supdate >= @pfromdate and b.supdate <=@ptilldate and 
		(a.ag_type=@pagency_type or @pagency_type is null or @pagency_type='') and(a.ag_class=@pagency_class or @pagency_class is null or @pagency_class='') and
		(a.branch_code=@pbranch or @pbranch is null or @pbranch='') and (a.state_code=@pstatecode or @pstatecode is null or @pstatecode='') and
		(a.dist_code=@pdistcode or @pdistcode is null or @pdistcode='') and (a.tehsil_taluka=@ptaluka or @ptaluka is null or @ptaluka='') and
		(e.main_edtn=@pmainedtn or @pmainedtn is null or @pmainedtn='')
		and (b.comm_code=@pextra3 or @pextra3 is null or @pextra3 ='')
		and (p.pro_type=@pubtype or @pubtype is null or @pubtype ='')
		and (b.sup_type_code=@psuptype or @psuptype is null or @psuptype ='')    
		and (dbo.cir_get_zone_by_city(a.comp_code,a.city_code,'C')=@pextra1 or @pextra1 is null or @pextra1 ='')
		and (dbo.cir_get_region_by_city(a.comp_code,a.city_code,'C')=@pextra2 or @pextra2 is null or @pextra2 ='')
		group by b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.sup_rate,
		b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.branch_code,a.city_code,a.dist_code, a.state_code,
		a.country_code,a.tehsil_taluka,b.route_code,upper(SUBSTRING(CONVERT(VARCHAR(11), b.supdate, 113), 4, 3))
		union all
		select b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.copy_rate,
		b.agcd,b.dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
		a.branch_code,a.city_code,a.dist_code, a.state_code,a.country_code,a.tehsil_taluka,d.route_code,  
		0 supply_copy,sum(isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0)) return_copy,0 no_of_days
		,upper(SUBSTRING(CONVERT(VARCHAR(11), b.supdate, 113), 4, 3)) as MON
		from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e,cir_publ_mast p,cir_dbksup d
		where b.comp_code =a.comp_code and b.comp_code=e.comp_code and b.comp_code=p.comp_code and b.comp_code =@pcomp_code and 
		b.unit_code=a.unit and (b.unit_code=@punit_code or @punit_code is null or @punit_code ='') and  
		b.doctype='UCN' and ((b.recptdt >= @pfromdate and b.recptdt <=@ptilldate and isnull(@preturn_based,'R') ='R') or (b.supdate >= @pfromdate and b.supdate <=@ptilldate and isnull(@preturn_based,'R') ='S')) and 
		b.publ=d.publ and b.edtn=d.edtn and a.agcd=d.agcd and a.dpcd=d.dpcd and
		b.publ=e.publ and b.publ=p.publ and (b.publ=isnull(@ppubl,b.publ) or @ppubl='') and b.edtn=e.edtn and (b.edtn=isnull(@pedtn,b.edtn) or @pedtn='') and 
		a.agcd=b.agcd and (b.agcd=isnull(@pagcd,b.agcd) or @pagcd='') and a.dpcd=b.dpcd and (b.dpcd=isnull(@pdpcd,b.dpcd) or @pdpcd='') and
		(a.ag_type=@pagency_type or @pagency_type is null or @pagency_type='') and(a.ag_class=@pagency_class or @pagency_class is null or @pagency_class='') and
		(a.branch_code=@pbranch or @pbranch is null or @pbranch='') and (a.state_code=@pstatecode or @pstatecode is null or @pstatecode='') and
		(a.dist_code=@pdistcode or @pdistcode is null or @pdistcode='') and (a.tehsil_taluka=@ptaluka or @ptaluka is null or @ptaluka='') and
		(isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))>0 and
		(e.main_edtn=@pmainedtn or @pmainedtn is null)
		and (d.comm_code=@pextra3 or @pextra3 is null or @pextra3 ='')
		and (p.pro_type=@pubtype or @pubtype is null or @pubtype ='')
		and (d.sup_type_code=@psuptype or @psuptype is null or @psuptype ='')
		and (dbo.cir_get_zone_by_city(a.comp_code,a.city_code,'C')=@pextra1 or @pextra1 is null or @pextra1 ='')
		and (dbo.cir_get_region_by_city(a.comp_code,a.city_code,'C')=@pextra2 or @pextra2 is null or @pextra2 ='')
		group by b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.copy_rate,
		b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.branch_code,a.city_code,a.dist_code, a.state_code,
		a.country_code,a.tehsil_taluka,d.route_code ,upper(SUBSTRING(CONVERT(VARCHAR(11), b.supdate, 113), 4, 3))) u
		where (u.supply_copy+u.return_copy)>0
		group by u.comp_code,u.unit_code,u.branch_code,u.publ,u.publ_name,u.main_edtn,u.edtn,u.edtn_name,u.copy_rate,
		u.agcd,u.dpcd,u.agname,u.agname_oth_lang,u.state_code,u.dist_code ,u.city_code,u.tehsil_taluka,u.route_code,u.country_code,u.MON; 
	end
	
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
	  REGION          VARCHAR(500),
	  RET_COMM_AMT     NUMERIC(15,2),
	  BILL_SEC_AMT     NUMERIC(15,2),
	  SEC_OPBAL        NUMERIC(15,2),
	  zone_code        VARCHAR(200),
	  region_code        VARCHAR(200),
	  pro_type        VARCHAR(200),
	  route_code      VARCHAR(200),
	  copy_rate			numeric(14,2),
	  no_of_days		numeric(10),
	  unit_name			varchar(150),
	  COM_CAT           varchar(150),
	  supdate           datetime
	  )
		
		
		OPEN c1 
        fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit_code, @v1_branch_code, @v1_branch_name,@v1_publ, @v1_publ_name,@v1_main_edtn,@v1_main_edtn_name,@v1_edtn,@v1_edtn_name,@v1_copy_rate, @v1_agcd, @v1_dpcd,@v1_agname,@v1_agname_oth_lang,@v1_state_code,@v1_state_name,@v1_dist_code,@v1_dist_name,@v1_city_code,@v1_city_name, @v1_tehsil_taluka,@v1_taluka_name,@v1_route_code,@v1_route_name,@v1_supply_copy,@v1_return_copy,@v1_net_sale_copy, @v1_no_of_days,@v1_unit_name,@v1_COM_CAT
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN 
		
             
   
			If isnull(@v1_no_of_days,0)>0 Begin
                set @v_avg_sale=round(isnull(@v1_net_sale_copy,0)/(isnull(@v1_no_of_days,0)),0)
            End    
            Else Begin
                set @v_avg_sale=isnull(@v1_net_sale_copy,0)
            End

            select distinct @v_reg_code=region_code,@v_zone_code=zone_code from cir_city_mast where comp_code=@v1_comp_code and city_code=@v1_city_code            
            if(@v_reg_code='')
            begin
				set @v_reg_code=null
            end
           
            if(@v_zone_code='')
            begin
				set @v_zone_code=null
            end
            
            select distinct @v_publ_code=pro_type from cir_publ_mast where comp_code=@v1_comp_code and publ=@v1_publ;
            if(@v_publ_code='')
            begin
				set @v_publ_code=null
            end
            
            select distinct @v1_COM_CAT=COMM_CATG_DESC from CIR_COMM_CATG_MAST where comp_code=@v1_comp_code and COMM_CATG_CODE=@v1_COM_CAT            
            if(@v1_COM_CAT='')
            begin
				set @v1_COM_CAT=null
            end
            
            
            set @v_reg_code=dbo.cir_get_region_name(@v1_comp_code,@v_reg_code)
            set @v_zone_code=dbo.cir_get_zone_name(@v1_comp_code, @v_zone_code); 
			set @v_publ_code=dbo.cir_publ_type(@v1_comp_code,@v_publ_code,null,null);
            
            insert into #cir_temp_bill_collection
				(comp_code, unit_code, billno, publ_code, agcd, dpcd,agname,agname_oth_lang, city_code, 
				taluka_code, dist_code, state_code, REGION,supply_copy, return_copy ,copy_rate,no_of_days,zone_code, region_code,pro_type,route_code
				,unit_name,COM_CAT)
            values(@v1_comp_code,@v1_unit_code,@v1_branch_name,@v1_publ_name,@v1_main_edtn_name,@v1_edtn_name,@v1_agname,@v1_agname_oth_lang,@v1_city_name,
				@v1_taluka_name,@v1_dist_name,@v1_state_name,@v_reg_code,@v1_supply_copy,@v1_return_copy,@v1_copy_rate,@v1_no_of_days,@v_zone_code,@v_reg_code,@v_publ_code,@v1_route_name
				,@v1_unit_name,@v1_COM_CAT)
            
		    fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit_code, @v1_branch_code, @v1_branch_name,@v1_publ, @v1_publ_name,@v1_main_edtn,@v1_main_edtn_name,@v1_edtn,@v1_edtn_name,@v1_copy_rate, @v1_agcd, @v1_dpcd,@v1_agname,@v1_agname_oth_lang,@v1_state_code,@v1_state_name,@v1_dist_code,@v1_dist_name,@v1_city_code,@v1_city_name, @v1_tehsil_taluka,@v1_taluka_name,@v1_route_code,@v1_route_name,@v1_supply_copy,@v1_return_copy,@v1_net_sale_copy, @v1_no_of_days,@v1_unit_name,@v1_COM_CAT
		
		END 
		close c1
		DEALLOCATE c1

            if @pbreak_on='R' Begin -- region wise
                select comp_code AS COMP_CODE,region AS REGION_NAME
                ,COM_CAT AS MON,  sum(no_of_days) AS NO_OF_DAYS               
                ,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,(sum(supply_copy)-sum(return_copy)) AS NET_SALE,
                case when isnull(sum(no_of_days),0)>0 then round((sum(supply_copy)-sum(return_copy))/sum(no_of_days),0) else 0 end AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,COM_CAT,region
                order by region,COM_CAT

                select comp_code AS COMP_CODE,  
                region AS REGION_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE
                from #cir_temp_bill_collection
                group by comp_code,region order by region_name
			End       
            else if @pbreak_on='S' Begin  -- state wise
				select comp_code AS COMP_CODE,STATE_CODE AS STATE_NAME
                ,COM_CAT AS MON,  sum(no_of_days) AS NO_OF_DAYS               
                ,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,(sum(supply_copy)-sum(return_copy)) AS NET_SALE,
                case when isnull(sum(no_of_days),0)>0 then round((sum(supply_copy)-sum(return_copy))/sum(no_of_days),0) else 0 end AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,COM_CAT,STATE_CODE
                order by STATE_CODE,COM_CAT

                select comp_code AS COMP_CODE,  
                STATE_CODE AS STATE_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE
                from #cir_temp_bill_collection
                group by comp_code,STATE_CODE order by STATE_CODE         
                
            End    
            Else if @pbreak_on='D' Begin -- district wise
				select comp_code AS COMP_CODE,dist_code AS DIST_NAME
                ,COM_CAT AS MON,  sum(no_of_days) AS NO_OF_DAYS               
                ,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,(sum(supply_copy)-sum(return_copy)) AS NET_SALE,
                case when isnull(sum(no_of_days),0)>0 then round((sum(supply_copy)-sum(return_copy))/sum(no_of_days),0) else 0 end AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,COM_CAT,dist_code
                order by dist_code,COM_CAT

                select comp_code AS COMP_CODE,  
                dist_code AS DIST_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE
                from #cir_temp_bill_collection
                group by comp_code,dist_code order by dist_code 
                
            End             
            else if @pbreak_on='Z' begin  ---ZONE WISE
				select comp_code AS COMP_CODE,zone_code as ZONE_NAME
                ,COM_CAT AS MON,  sum(no_of_days) AS NO_OF_DAYS               
                ,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,(sum(supply_copy)-sum(return_copy)) AS NET_SALE,
                case when isnull(sum(no_of_days),0)>0 then round((sum(supply_copy)-sum(return_copy))/sum(no_of_days),0) else 0 end AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,COM_CAT,zone_code
                order by zone_code,COM_CAT

                select comp_code AS COMP_CODE,  
                zone_code as ZONE_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE
                from #cir_temp_bill_collection
                group by comp_code,zone_code order by zone_code
                
            end
            else if @pbreak_on='C' begin  ---CENTER WISE
                select comp_code AS COMP_CODE,unit_name as UNIT_NAME
                ,COM_CAT AS MON,  sum(no_of_days) AS NO_OF_DAYS               
                ,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,(sum(supply_copy)-sum(return_copy)) AS NET_SALE,
                case when isnull(sum(no_of_days),0)>0 then round((sum(supply_copy)-sum(return_copy))/sum(no_of_days),0) else 0 end AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,COM_CAT,unit_name
                order by unit_name,COM_CAT

                select comp_code AS COMP_CODE,  
                unit_name as UNIT_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE
                from #cir_temp_bill_collection
                group by comp_code,unit_name order by unit_name
                
			end
			else if @pbreak_on='P' begin  ---PUBLICATION WISE
                select comp_code AS COMP_CODE,publ_code AS PUBL_NAME
                ,COM_CAT AS MON,  sum(no_of_days) AS NO_OF_DAYS               
                ,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,(sum(supply_copy)-sum(return_copy)) AS NET_SALE,
                case when isnull(sum(no_of_days),0)>0 then round((sum(supply_copy)-sum(return_copy))/sum(no_of_days),0) else 0 end AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,COM_CAT,publ_code
                order by publ_code,COM_CAT

                select comp_code AS COMP_CODE,  
                publ_code AS PUBL_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE
                from #cir_temp_bill_collection
                group by comp_code,publ_code order by publ_code                
                
            end
			else if @pbreak_on='O' begin  --- ROUTE WISE
				select comp_code AS COMP_CODE,route_code as ROUTE_NAME
                ,COM_CAT AS MON,  sum(no_of_days) AS NO_OF_DAYS               
                ,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,(sum(supply_copy)-sum(return_copy)) AS NET_SALE,
                case when isnull(sum(no_of_days),0)>0 then round((sum(supply_copy)-sum(return_copy))/sum(no_of_days),0) else 0 end AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,COM_CAT,route_code
                order by route_code,COM_CAT

                select comp_code AS COMP_CODE,  
                route_code as ROUTE_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE
                from #cir_temp_bill_collection
                group by comp_code,route_code order by route_code 
			    
             end
            else if @pbreak_on='B' Begin  ---  Branch Wise
				
				select comp_code AS COMP_CODE,billno AS BRANCH_NAME
                ,COM_CAT AS MON,  sum(no_of_days) AS NO_OF_DAYS               
                ,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,(sum(supply_copy)-sum(return_copy)) AS NET_SALE,
                case when isnull(sum(no_of_days),0)>0 then round((sum(supply_copy)-sum(return_copy))/sum(no_of_days),0) else 0 end AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,COM_CAT,billno
                order by billno,COM_CAT

                select comp_code AS COMP_CODE,  
                billno AS BRANCH_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE
                from #cir_temp_bill_collection
                group by comp_code,billno order by billno 
                   
             End
             else if @pbreak_on='E' Begin  ---  Edition Wise
				select comp_code AS COMP_CODE,dpcd AS SUB_EDTN
                ,COM_CAT AS MON,  sum(no_of_days) AS NO_OF_DAYS               
                ,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,(sum(supply_copy)-sum(return_copy)) AS NET_SALE,
                case when isnull(sum(no_of_days),0)>0 then round((sum(supply_copy)-sum(return_copy))/sum(no_of_days),0) else 0 end AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,COM_CAT,dpcd
                order by dpcd,COM_CAT

                select comp_code AS COMP_CODE,  
                dpcd AS SUB_EDTN,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE
                from #cir_temp_bill_collection
                group by comp_code,dpcd order by dpcd 
               
             End   
        
        select getdate() as CUR_DATE
        select getdate() as CUR_DATE
   drop table #CIR_TEMP_BILL_COLLECTION
   
   drop table #CIR_DBKSUP_temp

********************************************************end*************************************************************



**********************************add by deepika 16\10\2012 sent by Gaurav sir ***********************



ALTER PROCEDURE [dbo].[cir_rep_supply_cir_rep_supply1]
	@pcomp_code			VARCHAR(40) ,
	@punit_code         VARCHAR(40) ,
	@ppubl              VARCHAR(40) ,
	@pmainedtn          VARCHAR(40) ,
	@pedtn              VARCHAR(40) ,
	@proute             VARCHAR(40) ,
	@pfrom_supdate      DATETIME ,
	@ptill_supdate      DATETIME ,
	@pdateformat        VARCHAR(40) ,
    @pextra1            VARCHAR(40) ,--for branch
    @pextra2            VARCHAR(40) ,--for state,
	@pextra3			VARCHAR(40) ,--this is use to final and unfinal po
	@pextra4            VARCHAR(40) ,--for zone,
	@pextra5            VARCHAR(40) ,--for region
	@pextra6            VARCHAR(40) ,--for district
	@pextra7            VARCHAR(40) ,--for taluka
	@pextra8            VARCHAR(40) ,--report type filter 1 for routewise,2 for branchwise,3 for zonewise,4 for regionwise,5 for district,6 for talukaiwse,other than statewise
	@pextra9            VARCHAR(40) ,--for publication type
	@pextra10           VARCHAR(40),--for executive
	@pextra11           VARCHAR(40),-- it is using for standing order / posting
	@pextra12           VARCHAR(40),
	@pextra13           VARCHAR(40),
	@pextra14           VARCHAR(40),
	@pextra15           VARCHAR(40)
AS 
BEGIN
	DECLARE @vfrom_supdate	varchar(20);
	DECLARE @vtill_supdate  varchar(20);
	declare @vsup_seq_no	int
	
	DECLARE @supply_type_name	VARCHAR(4000)
	DECLARE @supply_sum			VARCHAR(4000) 
	DECLARE @vvar               VARCHAR(4000) 
	DECLARE @vvar_sum           VARCHAR(4000) 
	DECLARE @vquery             VARCHAR(8000) 
	DECLARE @vquery1            VARCHAR(8000) 
	DECLARE @vquery2            VARCHAR(8000) 
	DECLARE @vquery3            VARCHAR(8000) 
	DECLARE @vquery4            VARCHAR(8000) 

	SET @vfrom_supdate  = convert(varchar(20),@pfrom_supdate,101)
	SET @vtill_supdate  = convert(varchar(20),@ptill_supdate,101)
	
	if @pextra11 = '2' begin
	DECLARE cur_sup_type cursor LOCAL FOR 
		select distinct ' sum(case supply_type_code when '+''''+sup_ty_code+''''+' then base_supply else 0 end ) "'+sup_ty_name+'",' vty,
		'sum(case supply_type_code when '+''''+sup_ty_code+''''+' then base_supply else 0 end ) +' vty_sum,sup_seq_no
		from cir_supply_type_mast s, cir_supply d,cir_edtn_mast e
		where s.comp_code=@pcomp_code and s.comp_code=d.comp_code and s.comp_code=e.comp_code 
		and s.sup_ty_code =d.supply_type_code and
		(d.unit=isnull(@punit_code,d.unit) or @punit_code='') and d.publ=e.publ and 
		(d.publ=isnull(@ppubl,d.publ) or @ppubl='') and 
		d.edtn=e.edtn and (d.edtn=isnull(@pedtn,d.edtn) or @pedtn='') and 
		(e.main_edtn=isnull(@pmainedtn,e.main_edtn) or @pmainedtn='')
		order by sup_seq_no;
		
		OPEN cur_sup_type 
		fetch NEXT FROM cur_sup_type INTO  @supply_type_name,@supply_sum,@vsup_seq_no
			while(@@FETCH_STATUS = 0) BEGIN
				set @vvar =COALESCE(@vvar+'', SPACE(0)) + '' + COALESCE(@supply_type_name + '', SPACE(0))
				set @vvar_sum=COALESCE(@vvar_sum+'', SPACE(0)) + '' + COALESCE(@supply_sum + '', SPACE(0))

		fetch NEXT from cur_sup_type INTO  @supply_type_name,@supply_sum,@vsup_seq_no
		end
		close cur_sup_type
		
		SET @vvar  = SUBSTRING(@vvar, 1, LEN(@vvar) - 1)
		SET @vvar_sum  = SUBSTRING(@vvar_sum, 1, LEN(@vvar_sum) - 1)
	end
	else
	begin
		DECLARE cur_sup_type cursor LOCAL FOR 
		select distinct ' sum(case sup_type_code when '+''''+sup_ty_code+''''+' then sup_copy else 0 end ) "'+sup_ty_name+'",' vty,
		'sum(case sup_type_code when '+''''+sup_ty_code+''''+' then sup_copy else 0 end ) +' vty_sum,sup_seq_no
		from cir_supply_type_mast s, cir_dbksup d,cir_edtn_mast e
		where s.comp_code=@pcomp_code and s.comp_code=d.comp_code and s.comp_code=e.comp_code 
		and s.sup_ty_code =d.sup_type_code and
		(d.unit_code=isnull(@punit_code,d.unit_code) or @punit_code='') and d.publ=e.publ 
		and (d.publ=isnull(@ppubl,d.publ) or @ppubl='') 
		and d.edtn=e.edtn and (d.edtn=isnull(@pedtn,d.edtn) or @pedtn='') and 
		d.supdate between @pfrom_supdate and @ptill_supdate and
		(e.main_edtn=isnull(@pmainedtn,e.main_edtn) or @pmainedtn='')
		order by sup_seq_no;
		
		OPEN cur_sup_type 
		fetch NEXT FROM cur_sup_type INTO  @supply_type_name,@supply_sum,@vsup_seq_no
			while(@@FETCH_STATUS = 0) BEGIN
				set @vvar =COALESCE(@vvar+'', SPACE(0)) + '' + COALESCE(@supply_type_name + '', SPACE(0))
				set @vvar_sum=COALESCE(@vvar_sum+'', SPACE(0)) + '' + COALESCE(@supply_sum + '', SPACE(0))

		fetch NEXT from cur_sup_type INTO  @supply_type_name,@supply_sum,@vsup_seq_no
		end
		close cur_sup_type
		
		SET @vvar  = SUBSTRING(@vvar, 1, LEN(@vvar) - 1)
		SET @vvar_sum  = SUBSTRING(@vvar_sum, 1, LEN(@vvar_sum) - 1)
	end	
		
		
if @punit_code=null begin
	set @punit_code=''
end
if @ppubl=null begin
	set @ppubl=''
end
if @pmainedtn=null begin
	set @pmainedtn=''
end
if @pedtn=null begin
	set @pedtn=''
end
if @proute=null begin
	set @proute=''
end
if @pextra1=null begin
	set @pextra1=''
end
if @pextra2=null begin
	set @pextra2=''
end
if @pextra3=null begin
	set @pextra3=''
end
if @pextra4=null begin
	set @pextra4=''
end
if @pextra5=null begin
	set @pextra5=''
end
if @pextra6=null begin
	set @pextra6=''
end
if @pextra7=null begin
	set @pextra7=''
end

if @pextra9=null begin
	set @pextra9=''
end
if @pextra10=null begin
	set @pextra10=''
end
if @pextra11=null begin
	set @pextra11=''
end
if @pextra12=null begin
	set @pextra12=''
end
if @pextra13=null begin
	set @pextra13=''
end

if @pextra14=null begin
	set @pextra14=''
end
if @pextra15=null begin
	set @pextra15=''
end

if @pextra11 = '1' 
begin
	if @pextra8='1' 
	Begin--for route
		set @vquery='select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,d.route_code ROUTE_CODE,dbo.cir_get_route_name(d.comp_code,d.unit_code,d.route_code) ROUTE_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
		substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",dbo.cir_get_city(d.comp_code,m.city_code) "CITY NAME",
		isnull(dbo.CIR_GET_NAME_CIR_CITY(d.comp_code,m.city_code,2,null,null,null),''NA'') "CITY ONAME", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) "DROP_POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
		,dbo.cir_get_mode_name(d.comp_code,d.unit_code+d.route_code) as "MODE_NAME"
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code 
		and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
		and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
		and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
		and m.agcd=d.agcd and m.dpcd=d.dpcd 
		and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
		and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
		and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
		and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
		and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
		and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
		and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
		and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
		and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
		and m.city_code=c.city_code 
		and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
		and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
		and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
		group by d.comp_code,d.unit_code,d.publ,d.edtn,d.route_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code 
		order by d.comp_code,d.unit_code,d.publ,d.edtn,d.route_code,d.agcd,d.dpcd'
		    
		print @vquery 
		EXEC (@vquery)
	end
	if @pextra8='2' 
	Begin----for  branch
		set @vquery='select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.branch_code BRANCH_CODE,dbo.cir_get_branch(d.comp_code,m.branch_code) BRANCH_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
		substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",dbo.cir_get_city(d.comp_code,m.city_code) "CITY NAME",
		isnull(dbo.CIR_GET_NAME_CIR_CITY(d.comp_code,m.city_code,2,null,null,null),''NA'') "CITY ONAME", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) "DROP_POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
		and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
		and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
		and m.agcd=d.agcd and m.dpcd=d.dpcd 
		and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
		and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
		and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
		and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
		and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
		and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
		and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
		and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
		and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
		and m.city_code=c.city_code 
		and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
		and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
		and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
		group by d.comp_code,d.unit_code,d.publ,d.edtn,m.branch_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code 
		order by d.comp_code,d.unit_code,d.publ,d.edtn,branch_name,d.agcd,d.dpcd'

		print @vquery 
		EXEC (@vquery)
	end

	if @pextra8='3' 
	Begin----for  zone
		set @vquery='select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,c.zone_code ZONE_CODE,
		dbo.cir_get_zone_name(d.comp_code,c.zone_code) ZONE_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
		substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",dbo.cir_get_city(d.comp_code,m.city_code) "CITY NAME",
		isnull(dbo.CIR_GET_NAME_CIR_CITY(d.comp_code,m.city_code,2,null,null,null),''NA'') "CITY ONAME", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) "DROP_POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
		and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
		and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
		and m.agcd=d.agcd and m.dpcd=d.dpcd 
		and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
		and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
		and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
		and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
		and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
		and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
		and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
		and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
		and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
		and m.city_code=c.city_code 
		and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
		and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
		and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
		group by d.comp_code,d.unit_code,d.publ,d.edtn,c.zone_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code 
		order by d.comp_code,d.unit_code,d.publ,d.edtn,zone_code,d.agcd,d.dpcd'
		    
		print @vquery 
		EXEC (@vquery)
	end

	if @pextra8='4' 
	Begin----for  region
		set @vquery='select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,c.region_code REGION_CODE,dbo.cir_get_region_name(d.comp_code,c.region_code) REGION_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
		substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",dbo.cir_get_city(d.comp_code,m.city_code) "CITY NAME",
		isnull(dbo.CIR_GET_NAME_CIR_CITY(d.comp_code,m.city_code,2,null,null,null),''NA'') "CITY ONAME", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) "DROP_POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
		and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
		and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
		and m.agcd=d.agcd and m.dpcd=d.dpcd 
		and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
		and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
		and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
		and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
		and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
		and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
		and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
		and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
		and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
		and m.city_code=c.city_code 
		and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
		and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
		and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
		group by d.comp_code,d.unit_code,d.publ,d.edtn,c.region_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code 
		order by d.comp_code,d.unit_code,d.publ,d.edtn,c.region_code,d.agcd,d.dpcd'
		    
		print @vquery 
		EXEC (@vquery)
	end

	if @pextra8='5' 
	Begin----for  district
		set @vquery='select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.dist_code DIST_CODE,dbo.cir_get_name_cir_district(d.comp_code,m.dist_code,''1'',null,null,null) DIST_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
		substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",dbo.cir_get_city(d.comp_code,m.city_code) "CITY NAME",
		isnull(dbo.CIR_GET_NAME_CIR_CITY(d.comp_code,m.city_code,2,null,null,null),''NA'') "CITY ONAME", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) "DROP_POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
		and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
		and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
		and m.agcd=d.agcd and m.dpcd=d.dpcd 
		and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
		and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
		and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
		and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
		and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
		and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
		and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
		and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
		and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
		and m.city_code=c.city_code 
		and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
		and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
		and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
		group by d.comp_code,d.unit_code,d.publ,d.edtn,m.dist_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code order by d.comp_code,d.unit_code,d.publ,d.edtn,dist_code,d.agcd,d.dpcd'
		    
		print @vquery 
		EXEC (@vquery)
	end

	if @pextra8='6' 
	Begin----for Taluka
		set @vquery='select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.tehsil_taluka TALUKA_CODE,dbo.cir_get_taluka(d.comp_code,m.tehsil_taluka) TALUKA_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
		substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",dbo.cir_get_city(d.comp_code,m.city_code) "CITY NAME",
		isnull(dbo.CIR_GET_NAME_CIR_CITY(d.comp_code,m.city_code,2,null,null,null),''NA'') "CITY ONAME", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) "DROP_POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
		and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
		and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
		and m.agcd=d.agcd and m.dpcd=d.dpcd 
		and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
		and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
		and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
		and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
		and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
		and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
		and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
		and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
		and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
		and m.city_code=c.city_code 
		and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
		and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
		and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
		group by d.comp_code,d.unit_code,d.publ,d.edtn,m.tehsil_taluka,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code order by d.comp_code,d.unit_code,d.publ,d.edtn,taluka_code,d.agcd,d.dpcd'
		    
		print @vquery 
		EXEC (@vquery)
	end
	if @pextra8='7' 
	Begin----for State
		set @vquery='select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.state_code STATE_CODE,dbo.cir_get_state1(d.comp_code,m.state_code) STATE_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
		substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",c.city_name "CITY NAME",
		c.city_oname "CITY ONAME", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) "DROP_POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
		and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
		and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
		and m.agcd=d.agcd and m.dpcd=d.dpcd 
		and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
		and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
		and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
		and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
		and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
		and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
		and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
		and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
		and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
		and m.city_code=c.city_code 
		and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
		and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
		and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
		group by d.comp_code,d.unit_code,d.publ,d.edtn,m.state_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code,c.city_name,c.city_Oname order by d.comp_code,d.unit_code,d.publ,d.edtn,m.state_code,d.agcd,d.dpcd'
		    
		print @vquery 
		EXEC (@vquery)
	end

	if @pextra8='8' 
	Begin----for Executive
		set @vquery='select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.executive_code EXECUTIVE_CODE,dbo.cir_get_executive(d.comp_code,m.executive_code) EXECUTIVE_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
		substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",c.city_name "CITY NAME",
		c.city_oname "CITY ONAME", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) "DROP_POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
		and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
		and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
		and m.agcd=d.agcd and m.dpcd=d.dpcd 
		and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
		and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
		and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
		and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
		and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
		and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
		and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
		and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
		and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
		and m.city_code=c.city_code 
		and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
		and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
		and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
		group by d.comp_code,d.unit_code,d.publ,d.edtn,m.executive_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code,c.city_name,c.city_Oname order by d.comp_code,d.unit_code,d.publ,d.edtn,m.executive_code,d.agcd,d.dpcd'
		    
		print @vquery 
		EXEC (@vquery)
	end
		SET @vquery1  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
		and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
		and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
		and m.agcd=d.agcd and m.dpcd=d.dpcd 
		and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
		and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
		and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
		and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
		and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
		and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
		and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
		and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
		and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
		and m.city_code=c.city_code 
		and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
		and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
		and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
		group by d.comp_code,d.unit_code order by d.comp_code,d.unit_code'
		print @vquery1
		EXEC (@vquery1)
			
	if @pextra8='1' 
	Begin--for route
		SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,d.route_code ROUTE_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
		and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
		and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
		and m.agcd=d.agcd and m.dpcd=d.dpcd 
		and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
		and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
		and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
		and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
		and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
		and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
		and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
		and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
		and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
		and m.city_code=c.city_code 
		and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
		and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
		and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
		group by d.comp_code,d.unit_code,d.publ,d.edtn,d.route_code order by d.comp_code,d.unit_code,d.publ,d.edtn,d.route_code'
		print @vquery2
		EXEC (@vquery2)
	end

	if @pextra8='2' 
	Begin--for branch
		SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.branch_code BRANCH_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
		and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
		and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
		and m.agcd=d.agcd and m.dpcd=d.dpcd 
		and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
		and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
		and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
		and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
		and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
		and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
		and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
		and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
		and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
		and m.city_code=c.city_code 
		and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
		and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
		and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
		group by d.comp_code,d.unit_code,d.publ,d.edtn,m.branch_code order by d.comp_code,d.unit_code,d.publ,d.edtn,m.branch_code'
		print @vquery2
		EXEC (@vquery2)
	end

	if @pextra8='3' 
	Begin--for Zone
		SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,c.zone_code ZONE_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
		and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
		and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
		and m.agcd=d.agcd and m.dpcd=d.dpcd 
		and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
		and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
		and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
		and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
		and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
		and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
		and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
		and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
		and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
		and m.city_code=c.city_code 
		and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
		and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
		and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
		group by d.comp_code,d.unit_code,d.publ,d.edtn,c.zone_code order by d.comp_code,d.unit_code,d.publ,d.edtn,c.zone_code'
		print @vquery2
		EXEC (@vquery2)
	end

	if @pextra8='4' 
	Begin--for region
		SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,c.region_code REGION_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
		and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
		and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
		and m.agcd=d.agcd and m.dpcd=d.dpcd 
		and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
		and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
		and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
		and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
		and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
		and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
		and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
		and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
		and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
		and m.city_code=c.city_code 
		and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
		and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
		and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
		group by d.comp_code,d.unit_code,d.publ,d.edtn,c.region_code order by d.comp_code,d.unit_code,d.publ,d.edtn,c.region_code'
		print @vquery2
		EXEC (@vquery2)
	end

	if @pextra8='5' 
	Begin--for District
		SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.dist_code DIST_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
		and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
		and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
		and m.agcd=d.agcd and m.dpcd=d.dpcd 
		and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
		and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
		and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
		and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
		and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
		and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
		and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
		and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
		and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
		and m.city_code=c.city_code 
		and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
		and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
		and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
		group by d.comp_code,d.unit_code,d.publ,d.edtn,m.dist_code order by d.comp_code,d.unit_code,d.publ,d.edtn,m.dist_code'
		print @vquery2
		EXEC (@vquery2)
	end

	if @pextra8='6' 
	Begin--for Taluka
		SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.tehsil_taluka TALUKA_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
		and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
		and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
		and m.agcd=d.agcd and m.dpcd=d.dpcd 
		and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
		and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
		and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
		and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
		and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
		and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
		and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
		and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
		and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
		and m.city_code=c.city_code 
		and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
		and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
		and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
		group by d.comp_code,d.unit_code,d.publ,d.edtn,m.tehsil_taluka order by d.comp_code,d.unit_code,d.publ,d.edtn,m.tehsil_taluka'
		print @vquery2
		EXEC (@vquery2)
	end

	if @pextra8='7' 
	Begin--for state
		SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.state_code STATE_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
		and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
		and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
		and m.agcd=d.agcd and m.dpcd=d.dpcd 
		and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
		and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
		and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
		and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
		and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
		and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
		and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
		and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
		and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
		and m.city_code=c.city_code 
		and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
		and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
		and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
		group by d.comp_code,d.unit_code,d.publ,d.edtn,m.state_code order by d.comp_code,d.unit_code,d.publ,d.edtn,m.state_code'
		print @vquery2
		EXEC (@vquery2)
	end

	if @pextra8='8' 
	Begin--for executive
		SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.executive_code EXECUTIVE_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
		and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
		and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
		and m.agcd=d.agcd and m.dpcd=d.dpcd 
		and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
		and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
		and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
		and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
		and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
		and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
		and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
		and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
		and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
		and m.city_code=c.city_code 
		and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
		and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
		and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
		group by d.comp_code,d.unit_code,d.publ,d.edtn,m.executive_code order by d.comp_code,d.unit_code,d.publ,d.edtn,m.executive_code'
		print @vquery2
		EXEC (@vquery2)
	end

		SET @vquery3  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,'+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
		and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
		and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
		and m.agcd=d.agcd and m.dpcd=d.dpcd 
		and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
		and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
		and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
		and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
		and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
		and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
		and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
		and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
		and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
		and m.city_code=c.city_code 
		and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
		and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
		and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
		group by d.comp_code,d.unit_code,d.publ,d.edtn order by d.comp_code,d.unit_code,d.publ,d.edtn'
		print @vquery3
		EXEC (@vquery3)

		SET @vquery4  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,'+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
		and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
		and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
		and m.agcd=d.agcd and m.dpcd=d.dpcd 
		and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
		and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
		and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
		and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
		and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
		and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
		and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
		and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
		and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
		and m.city_code=c.city_code 
		and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
		and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
		and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
		group by d.comp_code,d.unit_code,d.publ order by d.comp_code,d.unit_code,d.publ'
		print @vquery4
		EXEC (@vquery4)
end
else
begin
	if @pextra8='1' 
	Begin--for route
	set @vquery='select d.comp_code COMP_CODE,d.unit UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,d.route_code ROUTE_CODE,dbo.cir_get_route_name(d.comp_code,d.unit,d.route_code) ROUTE_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
	substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",dbo.cir_get_city(d.comp_code,m.city_code) "CITY NAME",
	isnull(dbo.CIR_GET_NAME_CIR_CITY(d.comp_code,m.city_code,2,null,null,null),''NA'') "CITY ONAME", dbo.cir_get_drop_point_name(d.comp_code,d.unit,m.station_code,1) "DROP_POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit,m.station_code,2) "ODROP_POINT"
	, '+@vvar+','+@vvar_sum+' TOTAL 
	,dbo.cir_get_mode_name(d.comp_code,d.unit+d.route_code) as "MODE_NAME"
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code 
	and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and d.unit='''+@punit_code+''' 
	and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
	and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
	and m.agcd=d.agcd and m.dpcd=d.dpcd 
	--and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
	--and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
	and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
	and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
	and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
	and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
	and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
	and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
	and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
	and m.city_code=c.city_code 
	and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
	and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
	and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
	group by d.comp_code,d.unit,d.publ,d.edtn,d.route_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code 
	order by d.comp_code,d.unit,d.publ,d.edtn,d.route_code,d.agcd,d.dpcd'
	    
	print @vquery 
	EXEC (@vquery)
end
if @pextra8='2' 
Begin----for  branch
	set @vquery='select d.comp_code COMP_CODE,d.unit UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.branch_code BRANCH_CODE,dbo.cir_get_branch(d.comp_code,m.branch_code) BRANCH_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
	substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",dbo.cir_get_city(d.comp_code,m.city_code) "CITY NAME",
	isnull(dbo.CIR_GET_NAME_CIR_CITY(d.comp_code,m.city_code,2,null,null,null),''NA'') "CITY ONAME"
	, dbo.cir_get_drop_point_name(d.comp_code,d.unit,m.station_code,1) "DROP_POINT"
	, dbo.cir_get_drop_point_name(d.comp_code,d.unit,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and d.unit='''+@punit_code+''' 
	and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
	and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
	and m.agcd=d.agcd and m.dpcd=d.dpcd 
	--and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
	--and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
	and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
	and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
	and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
	and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
	and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
	and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
	and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
	and m.city_code=c.city_code 
	and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
	and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
	and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
	group by d.comp_code,d.unit,d.publ,d.edtn,m.branch_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code 
	order by d.comp_code,d.unit,d.publ,d.edtn,branch_name,d.agcd,d.dpcd'

	print @vquery 
	EXEC (@vquery)
end

if @pextra8='3' 
Begin----for  zone
	set @vquery='select d.comp_code COMP_CODE,d.unit UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME
	,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,c.zone_code ZONE_CODE,
	dbo.cir_get_zone_name(d.comp_code,c.zone_code) ZONE_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
	substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",dbo.cir_get_city(d.comp_code,m.city_code) "CITY NAME",
	isnull(dbo.CIR_GET_NAME_CIR_CITY(d.comp_code,m.city_code,2,null,null,null),''NA'') "CITY ONAME"
	, dbo.cir_get_drop_point_name(d.comp_code,d.unit,m.station_code,1) "DROP_POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and d.unit='''+@punit_code+''' 
	and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
	and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
	and m.agcd=d.agcd and m.dpcd=d.dpcd 
	--and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
	--and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
	and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
	and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
	and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
	and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
	and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
	and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
	and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
	and m.city_code=c.city_code 
	and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
	and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
	and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
	group by d.comp_code,d.unit,d.publ,d.edtn,c.zone_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code 
	order by d.comp_code,d.unit,d.publ,d.edtn,zone_code,d.agcd,d.dpcd'
	    
	print @vquery 
	EXEC (@vquery)
end

if @pextra8='4' 
Begin----for  region
	set @vquery='select d.comp_code COMP_CODE,d.unit UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn
	,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,c.region_code REGION_CODE,dbo.cir_get_region_name(d.comp_code,c.region_code) REGION_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
	substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",dbo.cir_get_city(d.comp_code,m.city_code) "CITY NAME",
	isnull(dbo.CIR_GET_NAME_CIR_CITY(d.comp_code,m.city_code,2,null,null,null),''NA'') "CITY ONAME"
	, dbo.cir_get_drop_point_name(d.comp_code,d.unit,m.station_code,1) "DROP_POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and d.unit='''+@punit_code+''' 
	and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
	and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
	and m.agcd=d.agcd and m.dpcd=d.dpcd 
	--and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
	--and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
	and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
	and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
	and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
	and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
	and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
	and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
	and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
	and m.city_code=c.city_code 
	and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
	and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
	and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
	group by d.comp_code,d.unit,d.publ,d.edtn,c.region_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code 
	order by d.comp_code,d.unit,d.publ,d.edtn,c.region_code,d.agcd,d.dpcd'
	    
	print @vquery 
	EXEC (@vquery)
end

if @pextra8='5' 
Begin----for  district
	set @vquery='select d.comp_code COMP_CODE,d.unit UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.dist_code DIST_CODE,dbo.cir_get_name_cir_district(d.comp_code,m.dist_code,''1'',null,null,null) DIST_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
	substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",dbo.cir_get_city(d.comp_code,m.city_code) "CITY NAME",
	isnull(dbo.CIR_GET_NAME_CIR_CITY(d.comp_code,m.city_code,2,null,null,null),''NA'') "CITY ONAME"
	, dbo.cir_get_drop_point_name(d.comp_code,d.unit,m.station_code,1) "DROP_POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and d.unit='''+@punit_code+''' 
	and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
	and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
	and m.agcd=d.agcd and m.dpcd=d.dpcd 
	--and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
	--and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
	and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
	and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
	and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
	and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
	and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
	and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
	and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
	and m.city_code=c.city_code 
	and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
	and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
	and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
	group by d.comp_code,d.unit,d.publ,d.edtn,m.dist_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code order by d.comp_code,d.unit,d.publ,d.edtn,dist_code,d.agcd,d.dpcd'
	    
	print @vquery 
	EXEC (@vquery)
end

if @pextra8='6' 
Begin----for Taluka
	set @vquery='select d.comp_code COMP_CODE,d.unit UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.tehsil_taluka TALUKA_CODE,dbo.cir_get_taluka(d.comp_code,m.tehsil_taluka) TALUKA_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
	substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",dbo.cir_get_city(d.comp_code,m.city_code) "CITY NAME",
	isnull(dbo.CIR_GET_NAME_CIR_CITY(d.comp_code,m.city_code,2,null,null,null),''NA'') "CITY ONAME",
	 dbo.cir_get_drop_point_name(d.comp_code,d.unit,m.station_code,1) "DROP_POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and d.unit='''+@punit_code+''' 
	and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
	and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
	and m.agcd=d.agcd and m.dpcd=d.dpcd 
	--and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
	--and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
	and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
	and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
	and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
	and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
	and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
	and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
	and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
	and m.city_code=c.city_code 
	and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
	and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
	and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
	group by d.comp_code,d.unit,d.publ,d.edtn,m.tehsil_taluka,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code order by d.comp_code,d.unit,d.publ,d.edtn,taluka_code,d.agcd,d.dpcd'
	    
	print @vquery 
	EXEC (@vquery)
end
if @pextra8='7' 
Begin----for State
	set @vquery='select d.comp_code COMP_CODE,d.unit UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.state_code STATE_CODE,dbo.cir_get_state1(d.comp_code,m.state_code) STATE_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
	substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",c.city_name "CITY NAME",
	c.city_oname "CITY ONAME", dbo.cir_get_drop_point_name(d.comp_code,d.unit,m.station_code,1) "DROP_POINT",
	 dbo.cir_get_drop_point_name(d.comp_code,d.unit,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and d.unit='''+@punit_code+''' 
	and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
	and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
	and m.agcd=d.agcd and m.dpcd=d.dpcd 
	--and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
	--and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
	and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
	and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
	and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
	and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
	and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
	and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
	and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
	and m.city_code=c.city_code 
	and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
	and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
	and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
	group by d.comp_code,d.unit,d.publ,d.edtn,m.state_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code,c.city_name,c.city_Oname 
	order by d.comp_code,d.unit,d.publ,d.edtn,m.state_code,d.agcd,d.dpcd'
	    
	print @vquery 
	EXEC (@vquery)
end

if @pextra8='8' 
Begin----for Executive
	set @vquery='select d.comp_code COMP_CODE,d.unit UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.executive_code EXECUTIVE_CODE,dbo.cir_get_executive(d.comp_code,m.executive_code) EXECUTIVE_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
	substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",c.city_name "CITY NAME",
	c.city_oname "CITY ONAME", dbo.cir_get_drop_point_name(d.comp_code,d.unit,m.station_code,1) "DROP_POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and d.unit='''+@punit_code+''' 
	and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
	and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
	and m.agcd=d.agcd and m.dpcd=d.dpcd 
	--and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
	--and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
	and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
	and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
	and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
	and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
	and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
	and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
	and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
	and m.city_code=c.city_code 
	and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
	and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
	and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
	group by d.comp_code,d.unit,d.publ,d.edtn,m.executive_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code,c.city_name,c.city_Oname
	order by d.comp_code,d.unit,d.publ,d.edtn,m.executive_code,d.agcd,d.dpcd'
	    
	print @vquery 
	EXEC (@vquery)
end
	SET @vquery1  = ' select d.comp_code COMP_CODE,d.unit UNIT_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and d.unit='''+@punit_code+''' 
	and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
	and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
	and m.agcd=d.agcd and m.dpcd=d.dpcd 
	--and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
	--and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
	and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
	and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
	and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
	and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
	and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
	and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
	and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
	and m.city_code=c.city_code 
	and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
	and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
	and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
	group by d.comp_code,d.unit order by d.comp_code,d.unit_code'
	print @vquery1
	EXEC (@vquery1)
		
if @pextra8='1' 
Begin--for route
	SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,d.route_code ROUTE_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and d.unit='''+@punit_code+''' 
	and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
	and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
	and m.agcd=d.agcd and m.dpcd=d.dpcd 
	--and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
	--and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
	and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
	and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
	and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
	and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
	and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
	and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
	and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
	and m.city_code=c.city_code 
	and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
	and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
	and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
	group by d.comp_code,d.unit,d.publ,d.edtn,d.route_code order by d.comp_code,d.unit_code,d.publ,d.edtn,d.route_code'
	print @vquery2
	EXEC (@vquery2)
end

if @pextra8='2' 
Begin--for branch
	SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME
	,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.branch_code BRANCH_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and d.unit='''+@punit_code+''' 
	and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
	and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
	and m.agcd=d.agcd and m.dpcd=d.dpcd 
	--and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
	--and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
	and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
	and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
	and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
	and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
	and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
	and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
	and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
	and m.city_code=c.city_code 
	and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
	and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
	and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
	group by d.comp_code,d.unit,d.publ,d.edtn,m.branch_code order by d.comp_code,d.unit,d.publ,d.edtn,m.branch_code'
	print @vquery2
	EXEC (@vquery2)
end

if @pextra8='3' 
Begin--for Zone
	SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,c.zone_code ZONE_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and d.unit='''+@punit_code+''' 
	and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
	and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
	and m.agcd=d.agcd and m.dpcd=d.dpcd 
	--and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
	--and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
	and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
	and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
	and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
	and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
	and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
	and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
	and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
	and m.city_code=c.city_code 
	and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
	and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
	and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
	group by d.comp_code,d.unit,d.publ,d.edtn,c.zone_code order by d.comp_code,d.unit,d.publ,d.edtn,c.zone_code'
	print @vquery2
	EXEC (@vquery2)
end

if @pextra8='4' 
Begin--for region
	SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,c.region_code REGION_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and d.unit='''+@punit_code+''' 
	and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
	and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
	and m.agcd=d.agcd and m.dpcd=d.dpcd 
	--and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
	--and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
	and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
	and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
	and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
	and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
	and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
	and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
	and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
	and m.city_code=c.city_code 
	and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
	and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
	and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
	group by d.comp_code,d.unit,d.publ,d.edtn,c.region_code order by d.comp_code,d.unit,d.publ,d.edtn,c.region_code'
	print @vquery2
	EXEC (@vquery2)
end

if @pextra8='5' 
Begin--for District
	SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.dist_code DIST_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and d.unit='''+@punit_code+''' 
	and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
	and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
	and m.agcd=d.agcd and m.dpcd=d.dpcd 
	--and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
	--and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
	and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
	and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
	and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
	and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
	and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
	and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
	and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
	and m.city_code=c.city_code 
	and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
	and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
	and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
	group by d.comp_code,d.unit,d.publ,d.edtn,m.dist_code order by d.comp_code,d.unit,d.publ,d.edtn,m.dist_code'
	print @vquery2
	EXEC (@vquery2)
end

if @pextra8='6' 
Begin--for Taluka
	SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.tehsil_taluka TALUKA_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and d.unit='''+@punit_code+''' 
	and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
	and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
	and m.agcd=d.agcd and m.dpcd=d.dpcd 
	--and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
	--and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
	and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
	and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
	and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
	and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
	and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
	and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
	and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
	and m.city_code=c.city_code 
	and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
	and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
	and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
	group by d.comp_code,d.unit,d.publ,d.edtn,m.tehsil_taluka order by d.comp_code,d.unit,d.publ,d.edtn,m.tehsil_taluka'
	print @vquery2
	EXEC (@vquery2)
end

if @pextra8='7' 
Begin--for state
	SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.state_code STATE_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and d.unit='''+@punit_code+''' 
	and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
	and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
	and m.agcd=d.agcd and m.dpcd=d.dpcd 
	--and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
	--and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
	and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
	and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
	and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
	and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
	and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
	and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
	and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
	and m.city_code=c.city_code 
	and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
	and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
	and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
	group by d.comp_code,d.unit,d.publ,d.edtn,m.state_code order by d.comp_code,d.unit,d.publ,d.edtn,m.state_code'
	print @vquery2
	EXEC (@vquery2)
end

if @pextra8='8' 
Begin--for executive
	SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.executive_code EXECUTIVE_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and d.unit='''+@punit_code+''' 
	and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
	and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
	and m.agcd=d.agcd and m.dpcd=d.dpcd 
	--and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
	--and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
	and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
	and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
	and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
	and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
	and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
	and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
	and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
	and m.city_code=c.city_code 
	and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
	and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
	and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
	group by d.comp_code,d.unit,d.publ,d.edtn,m.executive_code order by d.comp_code,d.unit,d.publ,d.edtn,m.executive_code'
	print @vquery2
	EXEC (@vquery2)
end

	SET @vquery3  = ' select d.comp_code COMP_CODE,d.unit UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,'+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and d.unit='''+@punit_code+''' 
	and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
	and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
	and m.agcd=d.agcd and m.dpcd=d.dpcd 
	--and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
	--and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
	and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
	and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
	and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
	and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
	and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
	and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
	and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
	and m.city_code=c.city_code 
	and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
	and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
	and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
	group by d.comp_code,d.unit,d.publ,d.edtn order by d.comp_code,d.unit,d.publ,d.edtn'
	print @vquery3
	EXEC (@vquery3)

	SET @vquery4  = ' select d.comp_code COMP_CODE,d.unit UNIT_CODE,d.publ PUBL,'+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and d.unit='''+@punit_code+''' 
	and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
	and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
	and m.agcd=d.agcd and m.dpcd=d.dpcd 
	--and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
	--and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
	and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
	and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
	and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
	and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
	and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
	and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
	and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
	and m.city_code=c.city_code 
	and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
	and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
	and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
	group by d.comp_code,d.unit,d.publ order by d.comp_code,d.unit,d.publ'
	print @vquery4
	EXEC (@vquery4)
end

DEALLOCATE cur_sup_type

END


****************************************************************************************************************************


ALTER PROCEDURE [dbo].[cir_rep_supply_temp]
@pcomp_code         as varchar(200),
@punit_code         as varchar(200),
@ppubl              as varchar(200),
@pmainedtn          as varchar(200),
@pedtn              as varchar(200),
@proute             as varchar(200),
@pfrom_supdate      as datetime,
@ptill_supdate      as datetime,
@pdateformat        as varchar(200),
@pextra1            as varchar(200),--for branch
@pextra2            as varchar(200),--for State
@pextra3            as varchar(200),--this is use to final and unfinal po
@pextra4            as varchar(200),--for zone,
@pextra5            as varchar(200),--for region
@pextra6            as varchar(200),--for district
@pextra7            as varchar(200),--for taluka
@pextra8            as varchar(200),--report type filter 1 for routewise,2 for branchwise,3 for zonewise,4 for regionwise,5 for district,6 for talukaiwse,7 for statewise,8 for executive
@pextra9            as varchar(200),--for publication type
@pextra10           as varchar(200),--for executive
@pextra11           as varchar(200),--for based on 1 for supply post and 2 for standing order
@pextra12           as varchar(200),
@pextra13           as varchar(200),
@pextra14           as varchar(200),
@pextra15           as varchar(200)

AS

declare @vfrom_supdate    varchar(20);
declare @vtill_supdate    varchar(20);
declare @rec_sup_type		as varchar(200) 
declare @rec_sup_type_sum	as varchar(200) 
declare @rec_sup_seq_no		as int

if @pextra11 ='2' begin
DECLARE cur_sup_type CURSOR READ_ONLY FOR
	select distinct ' sum(case supply_type_code when '+''''+sup_ty_code+''''+' then base_supply else 0 end ) "'+sup_ty_name+'",' vty,
	'sum(case supply_type_code when '+''''+sup_ty_code+''''+' then base_supply else 0 end ) +' vty_sum,sup_seq_no
	from cir_supply_type_mast s, cir_supply d,cir_edtn_mast e
    where s.comp_code=@pcomp_code and s.comp_code=d.comp_code and s.comp_code=e.comp_code and s.sup_ty_code =d.supply_type_code and
    (d.unit=isnull(@punit_code,d.unit) or @punit_code='') and d.publ=e.publ and 
    (d.publ=isnull(@ppubl,d.publ) or @ppubl='') and 
    d.edtn=e.edtn and (d.edtn=isnull(@pedtn,d.edtn) or @pedtn='') and 
    --d.supdate between @pfrom_supdate and @ptill_supdate and
    (e.main_edtn=isnull(@pmainedtn,e.main_edtn) or @pmainedtn='')
    order by sup_seq_no;
end
else
begin
DECLARE cur_sup_type CURSOR READ_ONLY FOR
	select distinct ' sum(case sup_type_code when '+''''+sup_ty_code+''''+' then sup_copy else 0 end ) "'+sup_ty_name+'",' vty,
	'sum(case sup_type_code when '+''''+sup_ty_code+''''+' then sup_copy else 0 end ) +' vty_sum,sup_seq_no
	from cir_supply_type_mast s, cir_dbksup d,cir_edtn_mast e
    where s.comp_code=@pcomp_code and s.comp_code=d.comp_code and s.comp_code=e.comp_code and s.sup_ty_code =d.sup_type_code and
    (d.unit_code=isnull(@punit_code,d.unit_code) or @punit_code='') and d.publ=e.publ and 
    (d.publ=isnull(@ppubl,d.publ) or @ppubl='') and 
    d.edtn=e.edtn and (d.edtn=isnull(@pedtn,d.edtn) or @pedtn='') and 
    d.supdate between @pfrom_supdate and @ptill_supdate and
    (e.main_edtn=isnull(@pmainedtn,e.main_edtn) or @pmainedtn='')
    order by sup_seq_no;
end
	declare @vvar		varchar(4000)
	declare @vvar_sum	varchar(4000)
	declare @vquery		varchar(8000)

	set @vvar=''
	set @vvar_sum=''
 
	set @vfrom_supdate=convert(varchar(20),@pfrom_supdate,101)
	set @vtill_supdate=convert(varchar(20),@ptill_supdate,101)

	print('@vfrom_supdate')print(@vfrom_supdate);
	print('@vtill_supdate')print(@vtill_supdate);

if @pextra11 ='2' begin
	open cur_sup_type  
		fetch next from cur_sup_type into @rec_sup_type ,@rec_sup_type_sum,@rec_sup_seq_no
		WHILE @@FETCH_STATUS = 0 Begin 	
      		set @vvar		=@vvar+@rec_sup_type          		
      		set  @vvar_sum	=@vvar_sum+@rec_sup_type_sum
      		print('1')
      	fetch next from cur_sup_type into @rec_sup_type ,@rec_sup_type_sum,@rec_sup_seq_no
		end
    close cur_sup_type
	DEALLOCATE cur_sup_type
end
else
begin
	open cur_sup_type  
		fetch next from cur_sup_type into @rec_sup_type ,@rec_sup_type_sum,@rec_sup_seq_no
		WHILE @@FETCH_STATUS = 0 Begin 	
      		set @vvar		=@vvar+@rec_sup_type          		
      		set  @vvar_sum	=@vvar_sum+@rec_sup_type_sum
      		print('1')
      	fetch next from cur_sup_type into @rec_sup_type ,@rec_sup_type_sum,@rec_sup_seq_no
		end
    close cur_sup_type
	DEALLOCATE cur_sup_type
end

	print('@vvar')print(@vvar)
	print('@vvar_sum')print(@vvar_sum)

if @vvar='' or @vvar is null begin
	set @vvar=null
end
else begin
	set @vvar    =substring(@vvar,1,len(@vvar)-1)
	set @vvar_sum=substring(@vvar_sum,1,len(@vvar_sum)-1)
end	
	print('@vvar2')print(@vvar)
	print('@vvar_sum2')print(@vvar_sum)
   
if @punit_code=null begin
	set @punit_code=''
end
if @ppubl=null begin
	set @ppubl=''
end
if @pmainedtn=null begin
	set @pmainedtn=''
end
if @pedtn=null begin
	set @pedtn=''
end
if @proute=null begin
	set @proute=''
end
if @pextra1=null begin
	set @pextra1=''
end
if @pextra2=null begin
	set @pextra2=''
end
if @pextra3=null begin
	set @pextra3=''
end
if @pextra4=null begin
	set @pextra4=''
end
if @pextra5=null begin
	set @pextra5=''
end
if @pextra6=null begin
	set @pextra6=''
end
if @pextra7=null begin
	set @pextra7=''
end

if @pextra9=null begin
	set @pextra9=''
end
if @pextra10=null begin
	set @pextra10=''
end

if @pextra11=null begin
	set @pextra11=''
end
if @pextra12=null begin
	set @pextra12=''
end
if @pextra13=null begin
	set @pextra13=''
end

if @pextra14=null begin
	set @pextra14=''
end
if @pextra15=null begin
	set @pextra15=''
end
if @pextra11 ='2' begin
	if @vvar='' or @vvar is null 
	begin
		set @vquery='select d.comp_code comp_code,d.unit unit_code,d.publ publ,dbo.cir_get_publ_name(d.comp_code,d.publ) publ_name,
		d.route_code route_code,dbo.cir_get_route_name(d.comp_code,d.unit,d.route_code) route_name,
		dbo.cir_get_name_cir_route(d.comp_code,d.unit,d.route_code,''2'',null,null,null) route_oname
		from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit and d.unit='''+@punit_code+''' 
		and d.publ=e.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
		and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
		and m.agcd=d.agcd and m.dpcd=d.dpcd 
		--and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
		--and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
		and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
		and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
		and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
		and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
		and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
		and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
		and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
		and m.city_code=c.city_code 
		and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
		and exists (select ''x'' from cir_publ_mast where comp_code=d.comp_code and publ=d.publ and (pro_type='''+@pextra9+''' or '''+@pextra9+'''=''''))
		and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
		group by d.comp_code,d.unit,d.publ,d.route_code
		order by d.comp_code,d.unit,d.publ,route_name';
	end
	else 
	begin
		if @pextra8='1' 
		begin----for route 
			set @vquery='select d.comp_code comp_code,d.unit unit_code,d.publ publ,dbo.cir_get_publ_name(d.comp_code,d.publ) publ_name,
			d.route_code route_code,dbo.cir_get_route_name(d.comp_code,d.unit,d.route_code) route_name,
			dbo.cir_get_name_cir_route(d.comp_code,d.unit,d.route_code,''2'',null,null,null) route_oname,
			'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit and d.unit='''+@punit_code+''' 
			and d.publ=e.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
			and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
			and m.agcd=d.agcd and m.dpcd=d.dpcd 
			--and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
			--and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
			and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
			and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
			and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
			and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
			and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
			and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
			and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
			and m.city_code=c.city_code 
			and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
			and exists (select ''x'' from cir_publ_mast where comp_code=d.comp_code and publ=d.publ and (pro_type='''+@pextra9+''' or '''+@pextra9+'''=''''))
			and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
			group by d.comp_code,d.unit,d.publ,d.route_code
			order by d.comp_code,d.unit,d.publ,route_name';
		end ------ route	
		else if @pextra8='2' 
		begin----for  branch
			set @vquery='select d.comp_code comp_code,d.unit unit_code,m.branch_code branch_code,
			dbo.cir_get_branch(d.comp_code,m.branch_code) branch_name, 
			'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit and d.unit='''+@punit_code+''' 
			and d.publ=e.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
			and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
			and m.agcd=d.agcd and m.dpcd=d.dpcd 
			--and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
			--and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
			and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
			and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
			and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
			and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
			and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
			and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
			and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
			and m.city_code=c.city_code 
			and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
			and exists (select ''x'' from cir_publ_mast where comp_code=d.comp_code and publ=d.publ and (pro_type='''+@pextra9+''' or '''+@pextra9+'''=''''))
			and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
			group by d.comp_code,d.unit,m.branch_code
			order by d.comp_code,d.unit,branch_name'
		end ---- branch		
		else if @pextra8='3' 
		begin----for  zone
			set @vquery=' select d.comp_code comp_code,d.unit unit_code,c.zone_code,
			dbo.cir_get_zone_name(d.comp_code,c.zone_code) zone_name, 
			'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit and d.unit='''+@punit_code+''' 
			and d.publ=e.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
			and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
			and m.agcd=d.agcd and m.dpcd=d.dpcd 
			--and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
			--and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
			and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
			and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
			and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
			and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
			and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
			and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
			and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
			and m.city_code=c.city_code 
			and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
			and exists (select ''x'' from cir_publ_mast where comp_code=d.comp_code and publ=d.publ and (pro_type='''+@pextra9+''' or '''+@pextra9+'''=''''))
			and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
			group by d.comp_code,d.unit,c.zone_code
			order by d.comp_code,d.unit,zone_name';
		end  ---- zone
		else if @pextra8='4' 
		begin----for  region   
			set @vquery='  select d.comp_code comp_code,d.unit unit_code,c.region_code,
			dbo.cir_get_region_name(d.comp_code,c.region_code) region_name,
			'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit and d.unit='''+@punit_code+''' 
			and d.publ=e.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
			and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
			and m.agcd=d.agcd and m.dpcd=d.dpcd 
			--and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
			--and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
			and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
			and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
			and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
			and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
			and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
			and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
			and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
			and m.city_code=c.city_code 
			and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
			and exists (select ''x'' from cir_publ_mast where comp_code=d.comp_code and publ=d.publ and (pro_type='''+@pextra9+''' or '''+@pextra9+'''=''''))
			and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
			group by d.comp_code,d.unit,c.region_code
			order by d.comp_code,d.unit,region_name';
		end ---- end  region
		else if @pextra8='5' 
		begin----for  district
			set @vquery='select d.comp_code comp_code,d.unit unit_code,m.dist_code dist_code,dbo.cir_get_dist(d.comp_code,m.state_code,m.dist_code) district_name,
			dbo.cir_get_name_cir_district(d.comp_code,m.dist_code,''2'',null,null,null) district_oname, '+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit and d.unit='''+@punit_code+''' 
			and d.publ=e.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
			and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
			and m.agcd=d.agcd and m.dpcd=d.dpcd 
			--and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
			--and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
			and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
			and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
			and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
			and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
			and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
			and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
			and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
			and m.city_code=c.city_code 
			and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
			and exists (select ''x'' from cir_publ_mast where comp_code=d.comp_code and publ=d.publ and (pro_type='''+@pextra9+''' or '''+@pextra9+'''=''''))
			and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
			group by d.comp_code,d.unit,m.state_code,m.dist_code
			order by d.comp_code,d.unit,m.state_code,district_name	'
		end  ---- district
		else if @pextra8='6' 
		begin----for  tehsil_taluka
			set @vquery='  select d.comp_code comp_code,d.unit unit_code,m.tehsil_taluka tehsil_taluka,
			dbo.cir_get_taluka(d.comp_code,m.tehsil_taluka) taluka_name,
			dbo.cir_get_name_cir_taluka(d.comp_code,m.tehsil_taluka,''2'',null,null,null) taluka_oname,
			'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit and d.unit='''+@punit_code+''' 
			and d.publ=e.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
			and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
			and m.agcd=d.agcd and m.dpcd=d.dpcd 
			--and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
			--and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
			and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
			and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
			and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
			and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
			and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
			and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
			and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
			and m.city_code=c.city_code 
			and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
			and exists (select ''x'' from cir_publ_mast where comp_code=d.comp_code and publ=d.publ and (pro_type='''+@pextra9+''' or '''+@pextra9+'''=''''))
			and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
			group by d.comp_code,d.unit,m.tehsil_taluka
			order by d.comp_code,d.unit,taluka_name';
		end  ----for  tehsil_taluka
		else if @pextra8='7' 
		begin----for  State
			set @vquery='select d.comp_code comp_code,d.unit unit_code,m.country_code country_code,
			m.state_code state_code,dbo.cir_get_state(d.comp_code,m.country_code,m.state_code) state_name
			,'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit and d.unit='''+@punit_code+''' 
			and d.publ=e.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
			and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
			and m.agcd=d.agcd and m.dpcd=d.dpcd 
			--and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
			--and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
			and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
			and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
			and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
			and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
			and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
			and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
			and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
			and m.city_code=c.city_code 
			and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
			and exists (select ''x'' from cir_publ_mast where comp_code=d.comp_code and publ=d.publ and (pro_type='''+@pextra9+''' or '''+@pextra9+'''=''''))
			and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
			group by d.comp_code,d.unit,m.country_code,m.state_code
			order by d.comp_code,d.unit,m.country_code,state_name';
		end  ----for  state
		else 
		begin--for executive
			set @vquery='select d.comp_code comp_code,d.unit unit_code,m.country_code country_code,
			m.executive_code executive_code,dbo.cir_get_executive(d.comp_code,m.executive_code) executive_name
			,'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit and d.unit='''+@punit_code+''' 
			and d.publ=e.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
			and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
			and m.agcd=d.agcd and m.dpcd=d.dpcd 
			--and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
			--and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
			and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
			and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
			and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
			and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
			and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
			and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
			and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
			and m.city_code=c.city_code 
			and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
			and exists (select ''x'' from cir_publ_mast where comp_code=d.comp_code and publ=d.publ and (pro_type='''+@pextra9+''' or '''+@pextra9+'''=''''))
			and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
			group by d.comp_code,d.unit,m.country_code,m.executive_code
			order by d.comp_code,d.unit,m.country_code,executive_name';
		end
	end
end
else
begin
	if @vvar='' or @vvar is null 
	begin
		set @vquery='select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,dbo.cir_get_publ_name(d.comp_code,d.publ) publ_name,
		d.route_code route_code,dbo.cir_get_route_name(d.comp_code,d.unit_code,d.route_code) route_name,
		dbo.cir_get_name_cir_route(d.comp_code,d.unit_code,d.route_code,''2'',null,null,null) route_oname
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
		and d.publ=e.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
		and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
		and m.agcd=d.agcd and m.dpcd=d.dpcd 
		and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
		and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
		and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
		and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
		and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
		and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
		and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
		and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
		and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
		and m.city_code=c.city_code 
		and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
		and exists (select ''x'' from cir_publ_mast where comp_code=d.comp_code and publ=d.publ and (pro_type='''+@pextra9+''' or '''+@pextra9+'''=''''))
		and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
		group by d.comp_code,d.unit_code,d.publ,d.route_code
		order by d.comp_code,d.unit_code,d.publ,route_name';
	end
	else 
	begin
		if @pextra8='1' 
		begin----for route 
			set @vquery='select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,dbo.cir_get_publ_name(d.comp_code,d.publ) publ_name,
			d.route_code route_code,dbo.cir_get_route_name(d.comp_code,d.unit_code,d.route_code) route_name,
			dbo.cir_get_name_cir_route(d.comp_code,d.unit_code,d.route_code,''2'',null,null,null) route_oname,
			'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
			and d.publ=e.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
			and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
			and m.agcd=d.agcd and m.dpcd=d.dpcd 
			and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
			and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
			and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
			and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
			and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
			and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
			and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
			and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
			and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
			and m.city_code=c.city_code 
			and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
			and exists (select ''x'' from cir_publ_mast where comp_code=d.comp_code and publ=d.publ and (pro_type='''+@pextra9+''' or '''+@pextra9+'''=''''))
			and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
			group by d.comp_code,d.unit_code,d.publ,d.route_code
			order by d.comp_code,d.unit_code,d.publ,route_name';
		end ------ route	
		else if @pextra8='2' 
		begin----for  branch
			set @vquery='select d.comp_code comp_code,d.unit_code unit_code,m.branch_code branch_code,
			dbo.cir_get_branch(d.comp_code,m.branch_code) branch_name, 
			'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
			and d.publ=e.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
			and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
			and m.agcd=d.agcd and m.dpcd=d.dpcd 
			and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
			and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
			and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
			and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
			and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
			and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
			and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
			and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
			and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
			and m.city_code=c.city_code 
			and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
			and exists (select ''x'' from cir_publ_mast where comp_code=d.comp_code and publ=d.publ and (pro_type='''+@pextra9+''' or '''+@pextra9+'''=''''))
			and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
			group by d.comp_code,d.unit_code,m.branch_code
			order by d.comp_code,d.unit_code,branch_name'
		end ---- branch		
		else if @pextra8='3' 
		begin----for  zone
			set @vquery=' select d.comp_code comp_code,d.unit_code unit_code,c.zone_code,
			dbo.cir_get_zone_name(d.comp_code,c.zone_code) zone_name, 
			'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
			and d.publ=e.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
			and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
			and m.agcd=d.agcd and m.dpcd=d.dpcd 
			and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
			and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
			and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
			and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
			and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
			and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
			and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
			and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
			and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
			and m.city_code=c.city_code 
			and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
			and exists (select ''x'' from cir_publ_mast where comp_code=d.comp_code and publ=d.publ and (pro_type='''+@pextra9+''' or '''+@pextra9+'''=''''))
			and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
			group by d.comp_code,d.unit_code,c.zone_code
			order by d.comp_code,d.unit_code,zone_name';
		end  ---- zone
		else if @pextra8='4' 
		begin----for  region   
			set @vquery='  select d.comp_code comp_code,d.unit_code unit_code,c.region_code,
			dbo.cir_get_region_name(d.comp_code,c.region_code) region_name,
			'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
			and d.publ=e.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
			and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
			and m.agcd=d.agcd and m.dpcd=d.dpcd 
			and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
			and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
			and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
			and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
			and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
			and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
			and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
			and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
			and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
			and m.city_code=c.city_code 
			and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
			and exists (select ''x'' from cir_publ_mast where comp_code=d.comp_code and publ=d.publ and (pro_type='''+@pextra9+''' or '''+@pextra9+'''=''''))
			and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
			group by d.comp_code,d.unit_code,c.region_code
			order by d.comp_code,d.unit_code,region_name';
		end ---- end  region
		else if @pextra8='5' 
		begin----for  district
			set @vquery='select d.comp_code comp_code,d.unit_code unit_code,m.dist_code dist_code,dbo.cir_get_dist(d.comp_code,m.state_code,m.dist_code) district_name,
			dbo.cir_get_name_cir_district(d.comp_code,m.dist_code,''2'',null,null,null) district_oname, '+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
			and d.publ=e.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
			and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
			and m.agcd=d.agcd and m.dpcd=d.dpcd 
			and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
			and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
			and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
			and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
			and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
			and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
			and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
			and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
			and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
			and m.city_code=c.city_code 
			and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
			and exists (select ''x'' from cir_publ_mast where comp_code=d.comp_code and publ=d.publ and (pro_type='''+@pextra9+''' or '''+@pextra9+'''=''''))
			and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
			group by d.comp_code,d.unit_code,m.state_code,m.dist_code
			order by d.comp_code,d.unit_code,m.state_code,district_name	'
		end  ---- district
		else if @pextra8='6' 
		begin----for  tehsil_taluka
			set @vquery='  select d.comp_code comp_code,d.unit_code unit_code,m.tehsil_taluka tehsil_taluka,
			dbo.cir_get_taluka(d.comp_code,m.tehsil_taluka) taluka_name,
			dbo.cir_get_name_cir_taluka(d.comp_code,m.tehsil_taluka,''2'',null,null,null) taluka_oname,
			'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
			and d.publ=e.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
			and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
			and m.agcd=d.agcd and m.dpcd=d.dpcd 
			and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
			and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
			and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
			and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
			and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
			and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
			and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
			and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
			and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
			and m.city_code=c.city_code 
			and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
			and exists (select ''x'' from cir_publ_mast where comp_code=d.comp_code and publ=d.publ and (pro_type='''+@pextra9+''' or '''+@pextra9+'''=''''))
			and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
			group by d.comp_code,d.unit_code,m.tehsil_taluka
			order by d.comp_code,d.unit_code,taluka_name';
		end  ----for  tehsil_taluka
		else if @pextra8='7' 
		begin----for  State
			set @vquery='select d.comp_code comp_code,d.unit_code unit_code,m.country_code country_code,
			m.state_code state_code,dbo.cir_get_state(d.comp_code,m.country_code,m.state_code) state_name
			,'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
			and d.publ=e.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
			and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
			and m.agcd=d.agcd and m.dpcd=d.dpcd 
			and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
			and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
			and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
			and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
			and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
			and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
			and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
			and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
			and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
			and m.city_code=c.city_code 
			and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
			and exists (select ''x'' from cir_publ_mast where comp_code=d.comp_code and publ=d.publ and (pro_type='''+@pextra9+''' or '''+@pextra9+'''=''''))
			and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
			group by d.comp_code,d.unit_code,m.country_code,m.state_code
			order by d.comp_code,d.unit_code,m.country_code,state_name';
		end  ----for  state
		else 
		begin--for executive
			set @vquery='select d.comp_code comp_code,d.unit_code unit_code,m.country_code country_code,
			m.executive_code executive_code,dbo.cir_get_executive(d.comp_code,m.executive_code) executive_name
			,'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
			and d.publ=e.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
			and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
			and m.agcd=d.agcd and m.dpcd=d.dpcd 
			and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
			and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
			and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
			and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
			and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
			and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
			and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
			and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
			and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
			and m.city_code=c.city_code 
			and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
			and exists (select ''x'' from cir_publ_mast where comp_code=d.comp_code and publ=d.publ and (pro_type='''+@pextra9+''' or '''+@pextra9+'''=''''))
			and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
			group by d.comp_code,d.unit_code,m.country_code,m.executive_code
			order by d.comp_code,d.unit_code,m.country_code,executive_name';
		end
	end
end
print(@vquery)
exec(@vquery)



****************************************************************************************************************************


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
	@pextra1            as varchar(200),--for login user id
    @pextra2            as varchar(200),-------supply type
    @pextra3            as varchar(200),-------agency type
    @pextra4            as varchar(200),-------agency class
    @pextra5            as varchar(200), 
    @pextra6            as varchar(200)
AS 

	if(@ppubl = '') begin
	  set @ppubl = null
	end
	if(@pmainedtn = '') begin
	  set @pmainedtn = null
	end
	if(@pedtn = '') begin
	  set @pedtn = null
	end
	if(@proute = '') begin
	  set @proute = null
	end
	if(@pextra1 = '') begin
	  set @pextra1 = null
	end
	if(@pextra2 = '') begin
	  set @pextra2 = null
	end
	if(@pextra3 = '') begin
	  set @pextra3 = null
	end
	if(@pextra4 = '') begin
	  set @pextra4 = null
	end

	select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",
	d.route_code AS "ROUTE_CODE",dbo.cir_get_route_name(d.comp_code,d.unit_code,d.route_code) AS "ROUTE_NAME",
	d.agcd AS "AGCD",d.dpcd AS "DPCD",m.ag_name AS "AG_NAME",m.ag_name_oth_lang AS "AG_NAME_OTH_LANG",sum(d.sup_copy) AS "SUP_COPY",
	dbo.cir_get_route_seqno(d.comp_code,d.unit_code,d.route_code) AS "ROUTE_SEQNO",
	dbo.cir_get_supply_seqno(d.comp_code,d.unit_code,@ppubl,@pedtn,d.agcd,d.dpcd) AS "SUPPLY_SEQNO",
	dbo.cir_get_name_cir_route(d.comp_code,d.unit_code,d.route_code,2,null,null,null) AS "ROUTE_OTH_NAME",
	dbo.cir_get_city(d.comp_code,m.city_code) as "CITY_NAME",
	dbo.cir_get_name_cir_city(d.comp_code,m.city_code,2,null,null,null) as "CITY_ONAME",
	dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) as "DROP_POINT_NAME",
	dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) as "DROP_POINT_ONAME"
	from cir_dbksup d,cir_agmast m,cir_edtn_mast e
	where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
		 d.unit_code    = m.unit and
		 d.agcd         = m.agcd and
		 d.dpcd         = m.dpcd and
		 d.comp_code    = @pcomp_code and
		 d.unit_code    = @punit_code and
		 d.publ         = e.publ and d.publ         = @ppubl and
		 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
		 (d.route_code = @proute or @proute is null) and
		 d.supdate between @pfrom_supdate and @ptill_supdate and
		 (e.main_edtn=@pmainedtn or @pmainedtn is null)
		 and (d.sup_type_code=@pextra2 or @pextra2 is null or @pextra2 ='') and 
         (m.ag_type=@pextra3 or @pextra3 is null or @pextra3 ='') and 
         (m.ag_class=@pextra4 or @pextra4 is null or @pextra4 ='')
	  group by d.comp_code,d.unit_code,d.route_code,
			   d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code
	  order by d.comp_code,d.unit_code,route_seqno,d.route_code,supply_seqno ,d.agcd,d.dpcd
        
		select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",
		d.route_code AS "ROUTE_CODE",dbo.cir_get_route_name(d.comp_code,d.unit_code,d.route_code) AS "ROUTE_NAME",
		sum(d.sup_copy) AS "SUP_COPY",
		dbo.cir_get_route_seqno(d.comp_code,d.unit_code,d.route_code) AS "ROUTE_SEQNO",
		dbo.cir_get_name_cir_route(d.comp_code,d.unit_code,d.route_code,2,null,null,null) AS "ROUTE_OTH_NAME"
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e
		where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
			 d.unit_code    = m.unit and
			 d.agcd         = m.agcd and
			 d.dpcd         = m.dpcd and
			 d.comp_code    = @pcomp_code and
			 d.unit_code    = @punit_code and
			 d.publ         = e.publ and d.publ         = @ppubl and
			 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
			 (d.route_code = @proute or @proute is null) and
			 d.supdate between @pfrom_supdate and @ptill_supdate and
			 (e.main_edtn=@pmainedtn or @pmainedtn is null)
			 and (m.ag_type=@pextra3 or @pextra3 is null or @pextra3 ='') and 
					(m.ag_class=@pextra4 or @pextra4 is null or @pextra4 ='')
		  group by d.comp_code,d.unit_code,d.route_code
		  order by d.comp_code,d.unit_code,route_seqno,d.route_code
		
		select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",sum(d.sup_copy) AS "SUP_COPY"
			from cir_dbksup d,cir_agmast m,cir_edtn_mast e
			where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
				 d.unit_code    = m.unit and
				 d.agcd         = m.agcd and
				 d.dpcd         = m.dpcd and
				 d.comp_code    = @pcomp_code and
				 d.unit_code    = @punit_code and
				 d.publ         = e.publ and d.publ         = @ppubl and
				 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
				 (d.route_code = @proute or @proute is null) and
				 d.supdate between @pfrom_supdate and @ptill_supdate and
				 (e.main_edtn=@pmainedtn or @pmainedtn is null)
				 and (m.ag_type=@pextra3 or @pextra3 is null or @pextra3 ='') and 
					(m.ag_class=@pextra4 or @pextra4 is null or @pextra4 ='')
			  group by d.comp_code,d.unit_code
			  order by d.comp_code,d.unit_code
		
		select d.comp_code as "COMP_CODE",sum(d.sup_copy) AS "SUP_COPY",max(sup_rate) as "COPY_RATE"
			from cir_dbksup d,cir_agmast m,cir_edtn_mast e
			where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
				 d.unit_code    = m.unit and
				 d.agcd         = m.agcd and
				 d.dpcd         = m.dpcd and
				 d.comp_code    = @pcomp_code and
				 d.unit_code    = @punit_code and
				 d.publ         = e.publ and d.publ         = @ppubl and
				 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
				 (d.route_code = @proute or @proute is null) and
				 d.supdate between @pfrom_supdate and @ptill_supdate and
				 (e.main_edtn=@pmainedtn or @pmainedtn is null)
				 and (m.ag_type=@pextra3 or @pextra3 is null or @pextra3 ='') and 
					(m.ag_class=@pextra4 or @pextra4 is null or @pextra4 ='')
			  group by d.comp_code
			  order by d.comp_code


****************************************************************************************************************************


ALTER PROCEDURE [dbo].[cir_rep_supply_cir_dist_wise_supply]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@ppubl                                    VARCHAR(20) ,
	@pmainedtn                                VARCHAR(20) ,
	@pedtn                                    VARCHAR(20) ,
	@proute                                   VARCHAR(20) ,
	@pfrom_supdate                            DATETIME,
	@ptill_supdate                            DATETIME,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(200) ,--for login user id
	@pextra2                                  VARCHAR(200), -------agency class
	@pextra3            as varchar(200),-------supply type 
    @pextra4            as varchar(200)-------agency type
AS 

if(@ppubl = '') begin
  set @ppubl = null
end
if(@pmainedtn = '') begin
  set @pmainedtn = null
end
if(@pedtn = '') begin
  set @pedtn = null
end
if(@proute = '') begin
  set @proute = null
end
if(@pextra1 = '') begin
  set @pextra1 = null
end
if(@pextra2 = '') begin
  set @pextra2 = null
end
if(@pextra3 = '') begin
  set @pextra4 = null
end
if(@pextra4 = '') begin
  set @pextra4 = null
end

	select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",
	m.dist_code AS "DIST_CODE",dbo.cir_get_dist(d.comp_code,m.state_code,m.dist_code) AS "DIST_NAME",
	d.agcd AS "AGCD",d.dpcd AS "DPCD",m.ag_name AS "AG_NAME",m.ag_name_oth_lang AS "AG_NAME_OTH_LANG",sum(d.sup_copy) AS "SUP_COPY",
	dbo.cir_get_name_cir_district(d.comp_code,m.dist_code,2,null,null,null) AS "DIST_OTH_NAME", 
	dbo.cir_get_city(d.comp_code,m.city_code) as "CITY_NAME",
	dbo.cir_get_name_cir_city(d.comp_code,m.city_code,2,null,null,null) as "CITY_ONAME",
	dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) as "DROP_POINT_NAME",
	dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) as "DROP_POINT_ONAME"
	from cir_dbksup d,cir_agmast m,cir_edtn_mast e
	where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code 
	and d.unit_code    = m.unit 
	and d.agcd         = m.agcd 
	 and d.dpcd         = m.dpcd 
	 and d.comp_code    = @pcomp_code 
	 and  d.unit_code    = @punit_code 
	 and d.publ         = e.publ and d.publ         = @ppubl 
	 and d.edtn=e.edtn 
	 and (d.edtn       = @pedtn or @pedtn is null) 
	 and (m.dist_code = @proute or @proute is null) 
	 and d.supdate between @pfrom_supdate and @ptill_supdate 
	 and (e.main_edtn=@pmainedtn or @pmainedtn is null) 
	 and (m.ag_class=@pextra2 or @pextra2 is null) 
	 and (d.sup_type_code=@pextra3 or @pextra3 is null or @pextra3 ='') 
	 and (m.ag_type=@pextra4 or @pextra4 is null)      
	  group by d.comp_code,d.unit_code,m.dist_code,m.state_code,
			   d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code
	  order by comp_code,unit_code,dist_name,ag_name,agcd,dpcd;
		
	select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",
		m.dist_code AS "DIST_CODE",dbo.cir_get_dist(d.comp_code,m.state_code,m.dist_code) AS "DIST_NAME",
		sum(d.sup_copy) AS "SUP_COPY",
		dbo.cir_get_name_cir_district(d.comp_code,m.dist_code,2,null,null,null) AS "DIST_OTH_NAME"
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e
		where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
			 d.unit_code    = m.unit and
			 d.agcd         = m.agcd and
			 d.dpcd         = m.dpcd and
			 d.comp_code    = @pcomp_code and
			 d.unit_code    = @punit_code and
			 d.publ         = e.publ and d.publ         = @ppubl and
			 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
			 (m.dist_code = @proute or @proute is null) and
			 d.supdate between @pfrom_supdate and @ptill_supdate and
			 (e.main_edtn=@pmainedtn or @pmainedtn is null)
			 and (d.sup_type_code=@pextra3 or @pextra3 is null or @pextra3 ='') and 
                    (m.ag_type=@pextra4 or @pextra4 is null)       
		  group by d.comp_code,d.unit_code,m.dist_code,m.state_code
		  order by comp_code,unit_code,dist_name;
	
	select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",sum(d.sup_copy) AS "SUP_COPY"
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e
		where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
			 d.unit_code    = m.unit and
			 d.agcd         = m.agcd and
			 d.dpcd         = m.dpcd and
			 d.comp_code    = @pcomp_code and
			 d.unit_code    = @punit_code and
			 d.publ         = e.publ and d.publ         = @ppubl and
			 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
			 (m.dist_code = @proute or @proute is null) and
			 d.supdate between @pfrom_supdate and @ptill_supdate and
			 (e.main_edtn=@pmainedtn or @pmainedtn is null)
			 and (d.sup_type_code=@pextra3 or @pextra3 is null or @pextra3 ='') and 
                    (m.ag_type=@pextra4 or @pextra4 is null)
		  group by d.comp_code,d.unit_code
		  order by comp_code,unit_code;
		
	select d.comp_code as "COMP_CODE",sum(d.sup_copy) AS "SUP_COPY",max(sup_rate) as "COPY_RATE"
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e
		where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
			 d.unit_code    = m.unit and
			 d.agcd         = m.agcd and
			 d.dpcd         = m.dpcd and
			 d.comp_code    = @pcomp_code and
			 d.unit_code    = @punit_code and
			 d.publ         = e.publ and d.publ         = @ppubl and
			 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
			 (m.dist_code = @proute or @proute is null) and
			 d.supdate between @pfrom_supdate and @ptill_supdate and
			 (e.main_edtn=@pmainedtn or @pmainedtn is null)
			 and (d.sup_type_code=@pextra3 or @pextra3 is null or @pextra3 ='') and 
                    (m.ag_type=@pextra4 or @pextra4 is null)
		  group by d.comp_code
		  order by comp_code;


****************************************************************************************************************************


ALTER PROCEDURE [dbo].[cir_rep_supply_cir_taluka_wise_supply]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@ppubl                                    VARCHAR(20) ,
	@pmainedtn                                VARCHAR(20) ,
	@pedtn                                    VARCHAR(20) ,
	@proute                                   VARCHAR(20) ,
	@pfrom_supdate                            DATETIME ,
	@ptill_supdate                            DATETIME,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(200) ,--for login user id
	@pextra2                                  VARCHAR(200), -------agency class
	@pextra3            as varchar(200),-------supply type 
     @pextra4            as varchar(200)-------agency type

AS 
if(@ppubl = '') begin
  set @ppubl = null
end
if(@pmainedtn = '') begin
  set @pmainedtn = null
end
if(@pedtn = '') begin
  set @pedtn = null
end
if(@proute = '') begin
  set @proute = null
end
if(@pextra1 = '') begin
  set @pextra1 = null
end
if(@pextra2 = '') begin
  set @pextra2 = null
end
if(@pextra3 = '') begin
  set @pextra3 = null
end
if(@pextra4 = '') begin
  set @pextra4 = null
end
		
	select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",
	m.tehsil_taluka AS "TEHSIL_TALUKA",dbo.cir_get_taluka(d.comp_code,m.tehsil_taluka) AS "TALUKA_NAME",
	d.agcd AS "AGCD",d.dpcd AS "DPCD",m.ag_name AS "AG_NAME",m.ag_name_oth_lang AS "AG_NAME_OTH_LANG",sum(d.sup_copy) AS "SUP_COPY",
	dbo.cir_get_name_cir_taluka(d.comp_code,m.tehsil_taluka,2,null,null,null) as "TALUKA_OTH_NAME", 
	dbo.cir_get_city(d.comp_code,m.city_code) as "CITY_NAME",
	dbo.cir_get_name_cir_city(d.comp_code,m.city_code,2,null,null,null) as "CITY_ONAME",
	dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) as "DROP_POINT_NAME",
	dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) as "DROP_POINT_ONAME"
	from cir_dbksup d,cir_agmast m,cir_edtn_mast e
	where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and d.comp_code    = @pcomp_code and
		 d.unit_code    = m.unit and d.unit_code    = @punit_code and
		 d.agcd         = m.agcd and d.dpcd         = m.dpcd and
		 d.publ         = e.publ and d.publ         = @ppubl and
		 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
		 (m.tehsil_taluka = @proute or @proute is null) and d.supdate between @pfrom_supdate and @ptill_supdate and
		 (e.main_edtn=@pmainedtn or @pmainedtn is null)
		 and  (m.ag_class=@pextra2 or @pextra2 is null) and 
                    (d.sup_type_code=@pextra3 or @pextra3 is null) and 
                    (m.ag_type=@pextra4 or @pextra4 is null)         
	  group by d.comp_code,d.unit_code,m.tehsil_taluka,
			   d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code
	  order by comp_code,unit_code,taluka_name,ag_name,agcd,dpcd;
		
	
	select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",
	m.tehsil_taluka AS "TEHSIL_TALUKA",dbo.cir_get_taluka(d.comp_code,m.tehsil_taluka) AS "TALUKA_NAME",
	sum(d.sup_copy) AS "SUP_COPY",
	dbo.cir_get_name_cir_taluka(d.comp_code,m.tehsil_taluka,2,null,null,null) as "TALUKA_OTH_NAME"
	from cir_dbksup d,cir_agmast m,cir_edtn_mast e
	where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and d.comp_code    = @pcomp_code and
		 d.unit_code    = m.unit and d.unit_code    = @punit_code and
		 d.agcd         = m.agcd and d.dpcd         = m.dpcd and
		 d.publ         = e.publ and d.publ         = @ppubl and
		 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
		 (m.tehsil_taluka = @proute or @proute is null) and d.supdate between @pfrom_supdate and @ptill_supdate and
		 (e.main_edtn=@pmainedtn or @pmainedtn is null)
		 and (d.sup_type_code=@pextra3 or @pextra3 is null) and 
                    (m.ag_type=@pextra4 or @pextra4 is null)
	  group by d.comp_code,d.unit_code,m.tehsil_taluka
	  order by comp_code,unit_code,taluka_name;
		
	select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",sum(d.sup_copy) AS "SUP_COPY"
	from cir_dbksup d,cir_agmast m,cir_edtn_mast e
	where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and d.comp_code    = @pcomp_code and
		 d.unit_code    = m.unit and d.unit_code    = @punit_code and
		 d.agcd         = m.agcd and d.dpcd         = m.dpcd and
		 d.publ         = e.publ and d.publ         = @ppubl and
		 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
		 (m.tehsil_taluka = @proute or @proute is null) and d.supdate between @pfrom_supdate and @ptill_supdate and
		 (e.main_edtn=@pmainedtn or @pmainedtn is null)
		and (d.sup_type_code=@pextra3 or @pextra3 is null) and 
                    (m.ag_type=@pextra4 or @pextra4 is null)
	  group by d.comp_code,d.unit_code
	  order by comp_code,unit_code
		

	select d.comp_code as "COMP_CODE",sum(d.sup_copy) AS "SUP_COPY",max(sup_rate) as  "COPY_RATE"
	from cir_dbksup d,cir_agmast m,cir_edtn_mast e
	where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and d.comp_code    = @pcomp_code and
		 d.unit_code    = m.unit and d.unit_code    = @punit_code and
		 d.agcd         = m.agcd and d.dpcd         = m.dpcd and
		 d.publ         = e.publ and d.publ         = @ppubl and
		 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
		 (m.tehsil_taluka = @proute or @proute is null) and d.supdate between @pfrom_supdate and @ptill_supdate and
		 (e.main_edtn=@pmainedtn or @pmainedtn is null)
		 and (d.sup_type_code=@pextra3 or @pextra3 is null) and 
                    (m.ag_type=@pextra4 or @pextra4 is null)
	  group by d.comp_code
	  order by comp_code


****************************************************************************************************************************


ALTER procedure [dbo].[cir_rep_supply_cir_branch_wise_supply]
(
@pcomp_code     as varchar(50),
@punit_code     as varchar(50),
@ppubl          as varchar(50),
@pmainedtn      as varchar(50),
@pedtn          as varchar(50),
@proute         as varchar(50),
@pfrom_supdate  as varchar(50),
@ptill_supdate  as varchar(50),
@pdateformat    as varchar(50),
@pextra1        as varchar(50),--for login user id
@pextra2        as varchar(50),----supply type
@pextra3        as varchar(50),------ for ,ag_class
@pextra4        as varchar(50)


)
as


declare @vfrom_supdate   as  datetime
declare @vtill_supdate   as  datetime


 set @vfrom_supdate=@pfrom_supdate
 set @vtill_supdate=@ptill_supdate

if(@pextra1 = '') begin
  set @pextra1 = null
end
if(@pextra2 = '') begin
  set @pextra2 = null
end
if(@pextra3 = '') begin
  set @pextra4 = null
end
if(@pextra4 = '') begin
  set @pextra4 = null
end

select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",m.branch_code, dbo.cir_get_branch(d.comp_code,m.branch_code) branch_name ,
               d.agcd AS "AGCD",d.dpcd AS "DPCD",m.ag_name AS "AG_NAME",m.ag_name_oth_lang AS "AG_NAME_OTH_LANG",sum(d.sup_copy) AS "SUP_COPY",
               dbo.cir_get_city(d.comp_code,m.city_code) as "CITY_NAME",
               dbo.cir_get_name_cir_city(d.comp_code,m.city_code,2,null,null,null) as "CITY_ONAME",
               dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) as "DROP_POINT_NAME",
               dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) as "DROP_POINT_ONAME"
               from cir_dbksup d,cir_agmast m,cir_edtn_mast e
               where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
                     d.unit_code    = m.unit and
                     d.agcd         = m.agcd and
                     d.dpcd         = m.dpcd and
                     d.comp_code    = @pcomp_code and
                     d.unit_code    = @punit_code and
                     d.publ         = e.publ 
                     
                     and d.publ         = @ppubl 
                    
                     and
                     
                     d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null or @pedtn ='')
                  
                     and
                   (d.route_code = @proute or @proute is null or @proute ='' )
                    
                    and
                     d.supdate between @vfrom_supdate and @vtill_supdate
                    and
                    (e.main_edtn=@pmainedtn or @pmainedtn is null or @pmainedtn ='') 
                  and (d.sup_type_code=@pextra2 or @pextra2 is null) and

					 (m.ag_type=@pextra3 or @pextra3 is null) 
					  and
					 (m.ag_class=@pextra4 or @pextra4 is null)
					
                  group by d.comp_code,d.unit_code,m.branch_code,
                           d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code
                  order by d.comp_code,d.unit_code,d.agcd,d.dpcd;
      
        select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",m.branch_code, dbo.cir_get_branch(d.comp_code,m.branch_code) branch_name ,
               sum(d.sup_copy) AS "SUP_COPY"
               from cir_dbksup d,cir_agmast m,cir_edtn_mast e
               where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
                     d.unit_code    = m.unit and
                     d.agcd         = m.agcd and
                     d.dpcd         = m.dpcd and
                     d.comp_code    = @pcomp_code and
                     d.unit_code    = @punit_code and
                     d.publ         = e.publ and 
                     d.publ         = @ppubl and
                     d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) 
                   and
                   (d.route_code = @proute or @proute is null  or @proute ='') and
                     d.supdate between @vfrom_supdate and @vtill_supdate
                     and
                     (e.main_edtn=@pmainedtn or @pmainedtn is null or  @pmainedtn='')
                      and 
					 (m.ag_type=@pextra3 or @pextra3 is null) and 
					 (m.ag_class=@pextra4 or @pextra4 is null)
                  group by d.comp_code,d.unit_code,m.branch_code
                  order by d.comp_code,d.unit_code,m.branch_code;
     
        select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",m.branch_code, dbo.cir_get_branch(d.comp_code,m.branch_code) branch_name ,
               sum(d.sup_copy) AS "SUP_COPY"
               from cir_dbksup d,cir_agmast m,cir_edtn_mast e
               where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
                     d.unit_code    = m.unit and
                     d.agcd         = m.agcd and
                     d.dpcd         = m.dpcd and
                     d.comp_code    = @pcomp_code and
                     d.unit_code    = @punit_code and
                     d.publ         = e.publ and d.publ         = @ppubl 
                   and
                     d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null)
                      and
                     (d.route_code = @proute or @proute is null or @proute='') and
                     d.supdate between @vfrom_supdate and @vtill_supdate 
                   and
                     (e.main_edtn=@pmainedtn or @pmainedtn is null or @pmainedtn='') 
                   and 
					 (m.ag_type=@pextra3 or @pextra3 is null) and 
					 (m.ag_class=@pextra4 or @pextra4 is null)
                  group by d.comp_code,d.unit_code,m.branch_code
                  order by d.comp_code,d.unit_code,m.branch_code;
     
       select d.comp_code as "COMP_CODE",m.branch_code,dbo.cir_get_branch(d.comp_code,m.branch_code) branch_name ,
	   sum(d.sup_copy) AS "SUP_COPY",max(sup_rate) as "COPY_RATE"
               from cir_dbksup d,cir_agmast m,cir_edtn_mast e
               where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
                     d.unit_code    = m.unit and
                     d.agcd         = m.agcd and
                     d.dpcd         = m.dpcd and
                     d.comp_code    = @pcomp_code and
                     d.unit_code    = @punit_code and
                     d.publ         = e.publ and d.publ         = @ppubl 
                    and
                 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) 
                   and
                     (d.route_code = @proute or @proute is null or @proute='') and
                     d.supdate between @vfrom_supdate and @vtill_supdate 
                     and
                     (e.main_edtn=@pmainedtn or @pmainedtn is null or @pmainedtn='')
                     and 
					 (m.ag_type=@pextra3 or @pextra3 is null) and 
					 (m.ag_class=@pextra4 or @pextra4 is null)
                  group by d.comp_code,m.branch_code
                  order by d.comp_code,m.branch_code;



****************************************************************************************************************************


ALTER PROCEDURE [dbo].[cir_rep_supply_cir_executive_wise_supply]
	@pcomp_code			as VARCHAR(20) ,
	@punit_code         as VARCHAR(20) ,
	@ppubl              as VARCHAR(20) ,
	@pmainedtn          as VARCHAR(20) ,
	@pedtn              as VARCHAR(20) ,
	@proute             as VARCHAR(20) ,
	@pfrom_supdate      as DATETIME ,
	@ptill_supdate      as DATETIME ,
	@pdateformat        as VARCHAR(20) ,
	@pextra1            as varchar(200),--for login user id
    @pextra2            as varchar(200),--supply type
    @pextra3            as varchar(200),--agency type
    @pextra4            as varchar(200),--agency class
    @pextra5            as varchar(200), 
    @pextra6            as varchar(200)
AS 

	if(@ppubl = '') begin
	  set @ppubl = null
	end
	if(@pmainedtn = '') begin
	  set @pmainedtn = null
	end
	if(@pedtn = '') begin
	  set @pedtn = null
	end
	if(@proute = '') begin
	  set @proute = null
	end
	if(@pextra1 = '') begin
	  set @pextra1 = null
	end
	if(@pextra2 = '') begin
	  set @pextra2 = null
	end
	if(@pextra3 = '') begin
	  set @pextra3 = null
	end
	if(@pextra4 = '') begin
	  set @pextra4 = null
	end

	
select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",
m.EXECUTIVE_CODE as "EXECUTIVE_CODE",
(Select executive_desc from cir_executive_mast 
	where COMP_CODE=d.COMP_CODE and EXECUTIVE_CODE=m.executive_code) as "EXECUTIVE_NAME",
	d.agcd AS "AGCD",d.dpcd AS "DPCD",m.ag_name AS "AG_NAME",m.ag_name_oth_lang AS "AG_NAME_OTH_LANG",sum(d.sup_copy) AS "SUP_COPY",
	dbo.cir_get_supply_seqno(d.comp_code,d.unit_code,@ppubl,@pedtn,d.agcd,d.dpcd) AS "SUPPLY_SEQNO",
	dbo.cir_get_city(d.comp_code,m.city_code) as "CITY_NAME",
	dbo.cir_get_name_cir_city(d.comp_code,m.city_code,2,null,null,null) as "CITY_ONAME",
	dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) as "DROP_POINT_NAME",
	dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) as "DROP_POINT_ONAME"
	
	from cir_dbksup d,cir_agmast m,cir_edtn_mast e
	where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
		 d.unit_code    = m.unit and
		 d.agcd         = m.agcd and
		 d.dpcd         = m.dpcd and
		 d.comp_code    = @pcomp_code and
		 d.unit_code    = @punit_code and
		 d.publ         = e.publ and d.publ         = @ppubl and
		 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
		 (d.route_code = @proute or @proute is null) and
		 d.supdate between @pfrom_supdate and @ptill_supdate and
		 (e.main_edtn=@pmainedtn or @pmainedtn is null)
		 and (d.sup_type_code=@pextra2 or @pextra2 is null or @pextra2 ='') and 
         (m.ag_type=@pextra3 or @pextra3 is null or @pextra3 ='') and 
         (m.ag_class=@pextra4 or @pextra4 is null or @pextra4 ='')
	  group by d.comp_code,d.unit_code,m.executive_code,
			   d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code
	  order by d.comp_code,d.unit_code,executive_code,supply_seqno ,d.agcd,d.dpcd
        
		select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",
		
		m.EXECUTIVE_CODE as "EXECUTIVE_CODE",(Select executive_desc from cir_executive_mast 
		where COMP_CODE=d.COMP_CODE and EXECUTIVE_CODE=m.executive_code) as "EXECUTIVE_NAME",
		sum(d.sup_copy) AS "SUP_COPY"
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e
		where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
			 d.unit_code    = m.unit and
			 d.agcd         = m.agcd and
			 d.dpcd         = m.dpcd and
			 d.comp_code    = @pcomp_code and
			 d.unit_code    = @punit_code and
			 d.publ         = e.publ and d.publ         = @ppubl and
			 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
			 (d.route_code = @proute or @proute is null) and
			 d.supdate between @pfrom_supdate and @ptill_supdate and
			 (e.main_edtn=@pmainedtn or @pmainedtn is null)
			 and (m.ag_type=@pextra3 or @pextra3 is null or @pextra3 ='') and 
					(m.ag_class=@pextra4 or @pextra4 is null or @pextra4 ='')
		  group by d.comp_code,d.unit_code,m.executive_code
		  order by d.comp_code,d.unit_code,m.executive_code
		
		select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",sum(d.sup_copy) AS "SUP_COPY"
			from cir_dbksup d,cir_agmast m,cir_edtn_mast e
			where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
				 d.unit_code    = m.unit and
				 d.agcd         = m.agcd and
				 d.dpcd         = m.dpcd and
				 d.comp_code    = @pcomp_code and
				 d.unit_code    = @punit_code and
				 d.publ         = e.publ and d.publ         = @ppubl and
				 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
				 (d.route_code = @proute or @proute is null) and
				 d.supdate between @pfrom_supdate and @ptill_supdate and
				 (e.main_edtn=@pmainedtn or @pmainedtn is null)
				 and (m.ag_type=@pextra3 or @pextra3 is null or @pextra3 ='') and 
					(m.ag_class=@pextra4 or @pextra4 is null or @pextra4 ='')
			  group by d.comp_code,d.unit_code
			  order by d.comp_code,d.unit_code
		
		select d.comp_code as "COMP_CODE",sum(d.sup_copy) AS "SUP_COPY",max(sup_rate) as "COPY_RATE"
			from cir_dbksup d,cir_agmast m,cir_edtn_mast e
			where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
				 d.unit_code    = m.unit and
				 d.agcd         = m.agcd and
				 d.dpcd         = m.dpcd and
				 d.comp_code    = @pcomp_code and
				 d.unit_code    = @punit_code and
				 d.publ         = e.publ and d.publ         = @ppubl and
				 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
				 (d.route_code = @proute or @proute is null) and
				 d.supdate between @pfrom_supdate and @ptill_supdate and
				 (e.main_edtn=@pmainedtn or @pmainedtn is null)
				 and (m.ag_type=@pextra3 or @pextra3 is null or @pextra3 ='') and 
					(m.ag_class=@pextra4 or @pextra4 is null or @pextra4 ='')
			  group by d.comp_code
			  order by d.comp_code


****************************************************************************************************************************


ALTER PROCEDURE [dbo].[cir_rep_supply_cir_dist_taluka_wise_sup]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@ppubl                                    VARCHAR(20) ,
	@pmainedtn                                VARCHAR(20) ,
	@pedtn                                    VARCHAR(20) ,
	@proute                                   VARCHAR(20) ,
	@pfrom_supdate                            DATETIME ,
	@ptill_supdate                            DATETIME,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(200) ,
	@pextra2                                  VARCHAR(200) 
AS 
if(@ppubl = '') begin
  set @ppubl = null
end
if(@pmainedtn = '')begin
  set @pmainedtn = null
end
if(@pedtn = '')begin
  set @pedtn = null
end
if(@proute = '')begin
  set @proute = null
end
if(@pextra1 = '')begin
  set @pextra1 = null
end
if(@pextra2 = '')begin
  set @pextra2 = null
end
		

	select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",
	m.dist_code AS "DIST_CODE",dbo.cir_get_dist(d.comp_code,m.state_code,m.dist_code) AS "DIST_NAME",
	m.tehsil_taluka AS "TEHSIL_TALUKA",dbo.cir_get_taluka(d.comp_code,m.tehsil_taluka) AS "TALUKA_NAME",
	d.agcd AS "AGCD",d.dpcd AS "DPCD",m.ag_name AS "AG_NAME",m.ag_name_oth_lang AS "AG_NAME_OTH_LANG",sum(d.sup_copy) AS "SUP_COPY",
	dbo.cir_get_name_cir_district(d.comp_code,m.dist_code,2,null,null,null) AS "DIST_OTH_NAME",
	dbo.cir_get_name_cir_taluka(d.comp_code,m.tehsil_taluka,2,null,null,null) as "TALUKA_OTH_NAME", 
	dbo.cir_get_city(d.comp_code,m.city_code) as "CITY_NAME",
	dbo.cir_get_name_cir_city(d.comp_code,m.city_code,2,null,null,null) as "CITY_ONAME",
	dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) as "DROP_POINT_NAME",
	dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) as "DROP_POINT_ONAME"
	from cir_dbksup d,cir_agmast m,cir_edtn_mast e
	where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
		 d.unit_code    = m.unit and
		 d.agcd         = m.agcd and
		 d.dpcd         = m.dpcd and
		 d.comp_code    = @pcomp_code and
		 d.unit_code    = @punit_code and
		 d.publ         = e.publ and d.publ         = @ppubl and
		 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
		 (m.tehsil_taluka = @proute or @proute is null) and
		 d.supdate between @pfrom_supdate and @ptill_supdate and
		 (e.main_edtn=@pmainedtn or @pmainedtn is null)
	  group by d.comp_code,d.unit_code,m.dist_code,m.state_code,m.tehsil_taluka,
			   d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code
	  order by comp_code,unit_code,dist_name,taluka_name,ag_name,agcd,dpcd		
		
	
	select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",
	m.dist_code AS "DIST_CODE",dbo.cir_get_dist(d.comp_code,m.state_code,m.dist_code) AS "DIST_NAME",
	m.tehsil_taluka AS "TEHSIL_TALUKA",dbo.cir_get_taluka(d.comp_code,m.tehsil_taluka) AS "TALUKA_NAME",
	sum(d.sup_copy) AS "SUP_COPY",
	dbo.cir_get_name_cir_district(d.comp_code,m.dist_code,2,null,null,null) AS "DIST_OTH_NAME",
	dbo.cir_get_name_cir_taluka(d.comp_code,m.tehsil_taluka,2,null,null,null) as "TALUKA_OTH_NAME"
	from cir_dbksup d,cir_agmast m,cir_edtn_mast e
	where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
		 d.unit_code    = m.unit and
		 d.agcd         = m.agcd and
		 d.dpcd         = m.dpcd and
		 d.comp_code    = @pcomp_code and
		 d.unit_code    = @punit_code and
		 d.publ         = e.publ and d.publ         = @ppubl and
		 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
		 (m.tehsil_taluka = @proute or @proute is null) and
		 d.supdate between @pfrom_supdate and @ptill_supdate and
		 (e.main_edtn=@pmainedtn or @pmainedtn is null)
	  group by d.comp_code,d.unit_code,m.dist_code,m.state_code,m.tehsil_taluka
	  order by comp_code,unit_code,dist_name,taluka_name
		
		
	select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",
	m.dist_code AS "DIST_CODE",dbo.cir_get_dist(d.comp_code,m.state_code,m.dist_code) AS "DIST_NAME",
	sum(d.sup_copy) AS "SUP_COPY",
	dbo.cir_get_name_cir_district(d.comp_code,m.dist_code,2,null,null,null) AS "DIST_OTH_NAME"
	from cir_dbksup d,cir_agmast m,cir_edtn_mast e
	where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
		 d.unit_code    = m.unit and
		 d.agcd         = m.agcd and
		 d.dpcd         = m.dpcd and
		 d.comp_code    = @pcomp_code and
		 d.unit_code    = @punit_code and
		 d.publ         = e.publ and d.publ         = @ppubl and
		 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
		 (m.tehsil_taluka = @proute or @proute is null) and
		 d.supdate between @pfrom_supdate and @ptill_supdate and
		 (e.main_edtn=@pmainedtn or @pmainedtn is null)
	  group by d.comp_code,d.unit_code,m.dist_code,m.state_code
	  order by comp_code,unit_code,dist_name	
		
	select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",sum(d.sup_copy) AS "SUP_COPY"
	from cir_dbksup d,cir_agmast m,cir_edtn_mast e
	where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
		 d.unit_code    = m.unit and
		 d.agcd         = m.agcd and
		 d.dpcd         = m.dpcd and
		 d.comp_code    = @pcomp_code and
		 d.unit_code    = @punit_code and
		 d.publ         = e.publ and d.publ         = @ppubl and
		 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
		 (m.tehsil_taluka = @proute or @proute is null) and
		 d.supdate between @pfrom_supdate and @ptill_supdate and
		 (e.main_edtn=@pmainedtn or @pmainedtn is null)
	  group by d.comp_code,d.unit_code
	  order by comp_code,unit_code

	select d.comp_code as "COMP_CODE",sum(d.sup_copy) AS "SUP_COPY",max(sup_rate) as "COPY_RATE"
	from cir_dbksup d,cir_agmast m,cir_edtn_mast e
	where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
		 d.unit_code    = m.unit and
		 d.agcd         = m.agcd and
		 d.dpcd         = m.dpcd and
		 d.comp_code    = @pcomp_code and
		 d.unit_code    = @punit_code and
		 d.publ         = e.publ and d.publ         = @ppubl and
		 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
		 (m.tehsil_taluka = @proute or @proute is null) and
		 d.supdate between @pfrom_supdate and @ptill_supdate and
		 (e.main_edtn=@pmainedtn or @pmainedtn is null)
	  group by d.comp_code
	  order by comp_code


****************************************************************************************************************************


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

declare @vbase_supply as int
declare @vmon_supply as int
declare @vtue_supply as int
declare @vwed_supply as int
declare @vthu_supply as int
declare @vfri_supply as int
declare @vsat_supply as int
declare @vsun_supply as int
declare @day as varchar(3)
 set @day=upper(datename(dw,@vseconddate))
print(@day)

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
                 (select isnull(sum(base_supply),0) 
                 from cir_supply
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
                           --(a.supdate = @vseconddate) and
                           a.agcd=c.agcd and a.dpcd=c.dpcd and                           
                           (a.route_code=@proute or @proute is null or @proute='') and a.route_code=b.route_code 
                           and (a.AGENCY_TY_CODE=@pextra3 or @pextra3 is null or @pextra3='')
                           and (c.AG_CLASS=@pextra4 or @pextra4 is null or @pextra4='')
                           and (isnull(final_supply_flag,'N') = @pextra5  or @pextra5 is null or @pextra5='')  
                           ) x
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
                                   (a.route_code=@proute or @proute is null or @proute='') and a.route_code=b.route_code 
                                   and (a.AGENCY_TY_CODE=@pextra3 or @pextra3 is null or @pextra3='')
								   and (c.AG_CLASS=@pextra4 or @pextra4 is null or @pextra4='')
								   and (isnull(final_supply_flag,'N') = @pextra5  or @pextra5 is null or @pextra5='')  
								   )x
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
                            --(a.supdate = @vfirstdate or a.supdate = @vseconddate) and
                           (a.supdate = @vseconddate) and
                           a.agcd=c.agcd and a.dpcd=c.dpcd and
                           (a.route_code=@proute or @proute is null or @proute='') and a.route_code=b.route_code 
                           and (a.AGENCY_TY_CODE=@pextra3 or @pextra3 is null or @pextra3='')
                           and (c.AG_CLASS=@pextra4 or @pextra4 is null or @pextra4='')
                           and (isnull(final_supply_flag,'N') = @pextra5  or @pextra5 is null or @pextra5='')  
                           ) x
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
                                   (a.route_code=@proute or @proute is null or @proute='') and a.route_code=b.route_code 
                                   and (a.AGENCY_TY_CODE=@pextra3 or @pextra3 is null or @pextra3='')
									and (c.AG_CLASS=@pextra4 or @pextra4 is null or @pextra4='')
                                   and (isnull(final_supply_flag,'N') = @pextra5  or @pextra5 is null or @pextra5='')  
                                   ) x
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
                           --(a.supdate = @vfirstdate or a.supdate = @vseconddate) and
                           (a.supdate = @vseconddate) and
                           a.agcd=c.agcd and a.dpcd=c.dpcd and
                           (a.route_code=@proute or @proute is null or @proute='') and a.route_code=b.route_code 
							and (a.AGENCY_TY_CODE=@pextra3 or @pextra3 is null or @pextra3='')
                           and (c.AG_CLASS=@pextra4 or @pextra4 is null or @pextra4='')
                           and (isnull(final_supply_flag,'N') = @pextra5  or @pextra5 is null or @pextra5='')  
                           ) x
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
                                       (a.route_code=@proute or @proute is null or @proute='') and a.route_code=b.route_code 
                                       and (a.AGENCY_TY_CODE=@pextra3 or @pextra3 is null or @pextra3='')
										and (c.AG_CLASS=@pextra4 or @pextra4 is null or @pextra4='')
                                       and (isnull(final_supply_flag,'N') = @pextra5  or @pextra5 is null or @pextra5='')  
                                       )x
                                 where isnull(x.second_sup,0)-isnull(x.first_sup,0)<>0
                                       group by comp_code
                                       order by comp_code
        End
		 
End


****************************************************************************************************************************


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
    --    SELECT @vfirstdate  = @pfirstdate
    --    SELECT @vseconddate  =  @pseconddate
    SET @vfirstdate  =  dbo.convert_user_date('/',@pfirstdate,@pdateformat)
    SET @vseconddate  = dbo.convert_user_date('/',@pseconddate,@pdateformat)

print(@vfirstdate)
print(@vseconddate)

if upper(@pextra1)='U' begin       
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
	END "PERCENT_VARIANCE",
	dbo.cir_get_drop_point_name(m.comp_code,unit_code,station_code,1) "DROP POINT NAME",
    dbo.cir_get_drop_point_name(m.comp_code,unit_code,station_code,2) "DROP POINT NAME OTHER LANG",branch_code "BRANCH NAME"
	FROM (    
	SELECT DISTINCT a.comp_code ,a.unit_code ,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang
	,c.city_code,c.dist_code,b.dist_name,b.dist_oname,c.station_code station_code,c.branch_code branch_code,
	 (    SELECT ISNULL(SUM(sup_copy), 0)
	from cir_supply
	WHERE comp_code  = @pcomp_code
	 AND (unit  = @punit_code or @punit_code is null or @punit_code='')
	 AND publ  = @ppublication
	 AND (edtn  = @pedtn OR    @pedtn  is null  OR    @pedtn = '')
	 and isnull(cir_supply.supply_flag,'N') =    'Y' 
	 AND cir_supply.agcd  = a.agcd
	 AND cir_supply.dpcd  = a.dpcd
	 AND cir_supply.edtn  in(
		 SELECT DISTINCT edtn FROM  cir_edtn_mast
		WHERE comp_code  = @pcomp_code
		 AND (edtn  = @pedtn OR    @pedtn  is null OR    @pedtn = '')
		 AND (main_edtn  = @pmainedtn OR    @pmainedtn  is null OR    @pmainedtn = '')
		 and (cir_supply.supply_type_code = @pextra2 or @pextra2 is null  or @pextra2='')
		 ))	 first_sup,
	 (SELECT ISNULL(SUM(sup_copy), 0)
	FROM  cir_dbksup a
	WHERE comp_code  = @pcomp_code AND    (unit_code  = @punit_code or @punit_code is null or @punit_code='')
	 AND publ  = @ppublication
	 AND (edtn  = @pedtn OR @pedtn  is null OR    @pedtn = '')
	 AND supdate  = @vseconddate
	 AND a.agcd  = a.agcd AND    a.dpcd  = a.dpcd
	 AND a.edtn  in
		(SELECT DISTINCT edtn FROM  cir_edtn_mast
		WHERE comp_code  = @pcomp_code
		 AND (edtn  = @pedtn OR    @pedtn  is null OR    @pedtn = '')
		 AND (main_edtn  = @pmainedtn OR    @pmainedtn  is null OR    @pmainedtn = '')
		 and  (a.sup_type_code = @pextra2 or @pextra2 is null or @pextra2 ='')
		 )) second_sup
	FROM  cir_dbksup a,cir_dist_mast b,cir_agmast c
	WHERE a.comp_code  = @pcomp_code AND a.comp_code  = c.comp_code AND b.comp_code  = c.comp_code
	AND (a.unit_code  = @punit_code or @punit_code is null or @punit_code='')
	 AND a.unit_code  = c.unit
	AND (a.supdate  = @vfirstdate OR    a.supdate  = @vseconddate)
	AND a.agcd  = c.agcd AND a.dpcd  = c.dpcd
	AND (c.dist_code  = @pdist OR    @pdist  is null  OR    @pdist = '')
	AND c.dist_code  = b.dist_code
	and (a.AGENCY_TY_CODE=@pextra3 or @pextra3 is null or @pextra3='')
	and (c.AG_CLASS=@pextra4 or @pextra4 is null or @pextra4='')
	and (isnull(final_supply_flag,'N') = @pextra5  or @pextra5 is null or @pextra5='')
	group by a.comp_code ,a.unit_code ,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang,c.city_code,c.dist_code,b.dist_name,b.dist_oname,c.station_code ,c.branch_code 
	) m
	WHERE    ISNULL(second_sup, 0) - ISNULL(first_sup, 0)  <> 0
	GROUP BY m.comp_code,m.unit_code,m.agcd,m.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.dist_code,m.dist_name,m.dist_oname,m.station_code,m.branch_code
	ORDER BY m.comp_code,m.dist_code,m.ag_name
end
else
begin
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
	END "PERCENT_VARIANCE",
	dbo.cir_get_drop_point_name(m.comp_code,m.unit_code,m.station_code,1) "DROP POINT NAME",
    dbo.cir_get_drop_point_name(m.comp_code,unit_code,station_code,2) "DROP POINT NAME OTHER LANG",branch_code "BRANCH NAME"
	FROM (    SELECT DISTINCT
	 a.comp_code comp_code,a.unit_code unit_code,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang,c.city_code,c.dist_code,b.dist_name,b.dist_oname,c.station_code station_code,c.branch_code branch_code,
	 (    SELECT ISNULL(SUM(sup_copy), 0)
	FROM  cir_dbksup
	WHERE comp_code  = @pcomp_code
	 AND (unit_code  = @punit_code or @punit_code is null or @punit_code='')
	 AND publ  = @ppublication
	 AND (edtn  = @pedtn OR    @pedtn  is null  OR    @pedtn = '')
	 AND supdate  = @vfirstdate
	 AND cir_dbksup.agcd  = a.agcd
	 AND cir_dbksup.dpcd  = a.dpcd
	 AND cir_dbksup.edtn  in(
		 SELECT DISTINCT edtn FROM  cir_edtn_mast
		WHERE comp_code  = @pcomp_code
		 AND (edtn  = @pedtn OR    @pedtn  is null OR    @pedtn = '')
		 AND (main_edtn  = @pmainedtn OR    @pmainedtn  is null OR    @pmainedtn = ''))) first_sup,
	 (SELECT ISNULL(SUM(sup_copy), 0)
	FROM  cir_dbksup
	WHERE comp_code  = @pcomp_code AND    (unit_code  = @punit_code or @punit_code is null or @punit_code='')
	 AND publ  = @ppublication
	 AND (edtn  = @pedtn OR @pedtn  is null OR    @pedtn = '')
	 AND supdate  = @vseconddate
	 AND cir_dbksup.agcd  = a.agcd AND    cir_dbksup.dpcd  = a.dpcd
	 AND cir_dbksup.edtn  in
		(SELECT DISTINCT edtn FROM  cir_edtn_mast
		WHERE comp_code  = @pcomp_code
		 AND (edtn  = @pedtn OR    @pedtn  is null OR    @pedtn = '')
		 AND (main_edtn  = @pmainedtn OR    @pmainedtn  is null OR    @pmainedtn = ''))) second_sup	
	FROM  cir_dbksup a,cir_dist_mast b,cir_agmast c
	WHERE a.comp_code  = @pcomp_code AND a.comp_code  = c.comp_code AND b.comp_code  = c.comp_code
	AND (a.unit_code  = @punit_code or @punit_code is null or @punit_code='')
	 AND a.unit_code  = c.unit
	AND (a.supdate  = @vfirstdate OR    a.supdate  = @vseconddate)
	AND a.agcd  = c.agcd AND a.dpcd  = c.dpcd
	AND (c.dist_code  = @pdist OR    @pdist  is null  OR    @pdist = '')
	AND c.dist_code  = b.dist_code
	and (a.AGENCY_TY_CODE=@pextra3 or @pextra3 is null or @pextra3='')
	and (c.AG_CLASS=@pextra4 or @pextra4 is null or @pextra4='')
	and (isnull(final_supply_flag,'N') = @pextra5  or @pextra5 is null or @pextra5='')
	group by a.comp_code ,a.unit_code ,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang,c.city_code,c.dist_code,b.dist_name,b.dist_oname,c.station_code ,c.branch_code ) m
	WHERE    ISNULL(second_sup, 0) - ISNULL(first_sup, 0)  <> 0
	GROUP BY m.comp_code,m.unit_code,m.agcd,m.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.dist_code,m.dist_name,m.dist_oname,m.station_code,m.branch_code
	ORDER BY m.comp_code,m.dist_code,m.ag_name

end


-- district wise
if upper(@pextra1)='U' begin 
	SELECT r.comp_code "COMP CODE", r.dist_code "DISTRICT CODE", r.dist_name "DISTRICT NAME",
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
	FROM (SELECT DISTINCT
	a.comp_code comp_code,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang,c.city_code,c.dist_code,b.dist_name,b.dist_oname,
	(    SELECT ISNULL(SUM(sup_copy), 0)
	from cir_supply
	WHERE comp_code  = @pcomp_code
	 AND (unit = @punit_code or @punit_code is null or @punit_code='')
	 AND publ  = @ppublication
	 AND (edtn  = @pedtn OR    @pedtn  is null  OR    @pedtn = '')
	 and isnull(cir_supply.supply_flag,'N') =    'Y' 
	 AND cir_supply.agcd  = a.agcd
	 AND cir_supply.dpcd  = a.dpcd
	 AND cir_supply.edtn  in(
		 SELECT DISTINCT edtn FROM  cir_edtn_mast
		WHERE comp_code  = @pcomp_code
		 AND (edtn  = @pedtn OR    @pedtn  is null OR    @pedtn = '')
		 AND (main_edtn  = @pmainedtn OR    @pmainedtn  is null OR    @pmainedtn = '')
		 and (cir_supply.supply_type_code = @pextra2 or @pextra2 is null  or @pextra2='')
		 ))	 first_sup ,
	(SELECT ISNULL(SUM(sup_copy), 0)
	FROM  cir_dbksup a
	WHERE comp_code  = @pcomp_code AND    (unit_code  = @punit_code or @punit_code is null or @punit_code='')
	AND publ  = @ppublication
	AND (edtn  = @pedtn OR @pedtn  is null OR    @pedtn = '')
	AND supdate  = @vseconddate
	AND a.agcd  = a.agcd AND    a.dpcd  = a.dpcd
	AND a.edtn  in
	(SELECT DISTINCT edtn FROM  cir_edtn_mast
	WHERE comp_code  = @pcomp_code
	 AND (edtn  = @pedtn OR    @pedtn  is null OR    @pedtn = '')
	 AND (main_edtn  = @pmainedtn OR    @pmainedtn  is null OR    @pmainedtn = '')
	 and  (a.sup_type_code = @pextra2 or @pextra2 is null or @pextra2 ='')
	 )) second_sup 
	FROM  cir_dbksup a,cir_dist_mast b,cir_agmast c
	WHERE a.comp_code  = @pcomp_code
	AND a.comp_code  = c.comp_code
	AND b.comp_code  = c.comp_code
	AND (a.unit_code  = @punit_code or @punit_code is null or @punit_code='')
	AND a.unit_code  = c.unit
	AND (a.supdate  = @vfirstdate OR    a.supdate  = @vseconddate)
	AND a.agcd  = c.agcd AND a.dpcd  = c.dpcd
	AND (c.dist_code  = @pdist OR    @pdist  is null OR    @pdist = '')
	AND c.dist_code  = b.dist_code 
	and (a.AGENCY_TY_CODE=@pextra3 or @pextra3 is null or @pextra3='')
	and (c.AG_CLASS=@pextra4 or @pextra4 is null or @pextra4='')
	and (isnull(final_supply_flag,'N') = @pextra5  or @pextra5 is null or @pextra5='')
	group by a.comp_code ,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang,c.city_code,c.dist_code,b.dist_name,b.dist_oname) r
	WHERE ISNULL(r.second_sup, 0) - ISNULL(r.first_sup, 0)  <> 0
	GROUP BY r.comp_code,r.dist_code,r.dist_name,r.dist_oname
	ORDER BY r.comp_code,r.dist_code
end
else
begin

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
        FROM (    SELECT DISTINCT
                     a.comp_code comp_code,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang,c.city_code,c.dist_code,b.dist_name,b.dist_oname,
                     (SELECT ISNULL(SUM(sup_copy), 0)
                    FROM  cir_dbksup
                    WHERE comp_code  = @pcomp_code
                     AND (unit_code  = @punit_code or @punit_code is null or @punit_code='')
                     AND publ  = @ppublication
                     AND (edtn  = @pedtn OR    @pedtn  is null OR    @pedtn = '')
                     AND supdate  = @vfirstdate
                     AND cir_dbksup.agcd  = a.agcd
                     AND cir_dbksup.dpcd  = a.dpcd
                     AND cir_dbksup.edtn  in
                        (SELECT DISTINCT edtn FROM  cir_edtn_mast
                        WHERE comp_code  = @pcomp_code
                         AND (edtn  = @pedtn OR    @pedtn  is null OR    @pedtn = '')
                         AND (main_edtn  = @pmainedtn OR    @pmainedtn  is null OR    @pmainedtn = ''))) first_sup,
                     (SELECT ISNULL(SUM(sup_copy), 0) FROM  cir_dbksup
                    WHERE comp_code  = @pcomp_code
                     AND (unit_code  = @punit_code or @punit_code is null or @punit_code='')
                     AND publ  = @ppublication
                     AND (edtn  = @pedtn OR    @pedtn  is null)
                     AND supdate  = @vseconddate
                     AND cir_dbksup.agcd  = a.agcd
                     AND cir_dbksup.dpcd  = a.dpcd
                     AND cir_dbksup.edtn  in (SELECT DISTINCT edtn FROM  cir_edtn_mast
                        WHERE comp_code  = @pcomp_code
                         AND (edtn  = @pedtn OR    @pedtn  is null OR    @pedtn = '')
                         AND (main_edtn  = @pmainedtn OR    @pmainedtn  is null OR    @pmainedtn = ''))) second_sup
            FROM  cir_dbksup a,cir_dist_mast b,cir_agmast c
            WHERE a.comp_code  = @pcomp_code
             AND a.comp_code  = c.comp_code
             AND b.comp_code  = c.comp_code
             AND (a.unit_code  = @punit_code or @punit_code is null or @punit_code='')
             AND a.unit_code  = c.unit
             AND (a.supdate  = @vfirstdate OR    a.supdate  = @vseconddate)
             AND a.agcd  = c.agcd AND a.dpcd  = c.dpcd
             AND (c.dist_code  = @pdist OR    @pdist  is null OR    @pdist = '')
             AND c.dist_code  = b.dist_code
             and (a.AGENCY_TY_CODE=@pextra3 or @pextra3 is null or @pextra3='')
	and (c.AG_CLASS=@pextra4 or @pextra4 is null or @pextra4='')
	and (isnull(final_supply_flag,'N') = @pextra5  or @pextra5 is null or @pextra5='')
             ) r
        WHERE ISNULL(second_sup, 0) - ISNULL(first_sup, 0)  <> 0
        GROUP BY r.comp_code,r.dist_code,r.dist_name,r.dist_oname
        ORDER BY r.comp_code,r.dist_code
end
if upper(@pextra1)='U' begin 
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
        END "PERCENT_VARIANCE",
        
        (select isnull(sum(d.sup_copy),0) from cir_dbksup d,cir_agmast m  where d.comp_code = m.comp_code and d.comp_code = @pcomp_code and d.unit_code = m.unit 
        and (d.unit_code = @punit_code or @punit_code is null or @punit_code='') and
                    d.publ = @ppublication and (d.edtn = @pedtn or @pedtn is null or @pedtn ='') 
                    and d.agcd=m.agcd and d.dpcd=m.dpcd and d.supdate = @vfirstdate and
                    (m.dist_code = @pdist or @pdist is null or @pdist='') and d.edtn in
                    (select distinct edtn from cir_edtn_mast
                    where comp_code=d.comp_code and edtn = d.edtn and (main_edtn=@pmainedtn or @pmainedtn is null or @pmainedtn ='')) 
                    and (d.sup_type_code = @pextra2 or @pextra2 is null or @pextra2 ='')) first_total_supply        
			    FROM (SELECT DISTINCT a.comp_code comp_code,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang,c.city_code,c.dist_code,b.dist_name,b.dist_oname,
    (SELECT ISNULL(SUM(sup_copy), 0)
	from cir_supply
	WHERE comp_code  = @pcomp_code
	 AND (unit  = @punit_code or @punit_code is null or @punit_code ='')
	 AND publ  = @ppublication
	 AND (edtn  = @pedtn OR    @pedtn  is null  OR    @pedtn = '')
	 and isnull(cir_supply.supply_flag,'N') =    'Y' 
	 AND cir_supply.agcd  = a.agcd
	 AND cir_supply.dpcd  = a.dpcd
	 AND cir_supply.edtn  in(
		 SELECT DISTINCT edtn FROM  cir_edtn_mast
		WHERE comp_code  = @pcomp_code
		 AND (edtn  = @pedtn OR    @pedtn  is null OR    @pedtn = '')
		 AND (main_edtn  = @pmainedtn OR    @pmainedtn  is null OR    @pmainedtn = '')
		 and (cir_supply.supply_type_code = @pextra2 or @pextra2 is null  or @pextra2='')
		 ))	 first_sup,
	 (SELECT ISNULL(SUM(sup_copy), 0)
	FROM  cir_dbksup a
	WHERE comp_code  = @pcomp_code AND    (unit_code  = @punit_code or @punit_code is null or @punit_code='')
	 AND publ  = @ppublication
	 AND (edtn  = @pedtn OR @pedtn  is null OR    @pedtn = '')
	 AND supdate  = @vseconddate
	 AND a.agcd  = a.agcd AND    a.dpcd  = a.dpcd
	 AND a.edtn  in
		(SELECT DISTINCT edtn FROM  cir_edtn_mast
		WHERE comp_code  = @pcomp_code
		 AND (edtn  = @pedtn OR    @pedtn  is null OR    @pedtn = '')
		 AND (main_edtn  = @pmainedtn OR    @pmainedtn  is null OR    @pmainedtn = '')
		 and  (a.sup_type_code = @pextra2 or @pextra2 is null or @pextra2 ='')
	 )) second_sup
        FROM  cir_dbksup a,cir_dist_mast b,cir_agmast c
        WHERE a.comp_code  = @pcomp_code AND  a.comp_code  = c.comp_code AND b.comp_code  = c.comp_code
         AND (a.unit_code  = @punit_code or @punit_code is null or @punit_code='') AND    a.unit_code  = c.unit
         AND (a.supdate  = @vfirstdate OR    a.supdate  = @vseconddate)
         AND a.agcd  = c.agcd AND a.dpcd  = c.dpcd
         AND (c.dist_code  = @pdist OR    @pdist  is null OR    @pdist = '')
         AND c.dist_code  = b.dist_code
         and (a.AGENCY_TY_CODE=@pextra3 or @pextra3 is null or @pextra3='')
	and (c.AG_CLASS=@pextra4 or @pextra4 is null or @pextra4='')
	and (isnull(final_supply_flag,'N') = @pextra5  or @pextra5 is null or @pextra5='')
         group by a.comp_code ,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang,c.city_code,c.dist_code,b.dist_name,b.dist_oname
         ) q
        WHERE ISNULL(second_sup, 0) - ISNULL(first_sup, 0)  <> 0
        GROUP BY  q.comp_code  ORDER BY q.comp_code
end
else
begin       
       

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
                END "PERCENT_VARIANCE",
                (select isnull(sum(d.sup_copy),0) from cir_dbksup d,cir_agmast m  where d.comp_code = m.comp_code and d.comp_code = @pcomp_code and d.unit_code = m.unit 
        and (d.unit_code = @punit_code or @punit_code is null or @punit_code='') and
                    d.publ = @ppublication and (d.edtn = @pedtn or @pedtn is null or @pedtn ='') 
                    and d.agcd=m.agcd and d.dpcd=m.dpcd and d.supdate = @vfirstdate and
                    (m.dist_code = @pdist or @pdist is null or @pdist='') and d.edtn in
                    (select distinct edtn from cir_edtn_mast
                    where comp_code=d.comp_code and edtn = d.edtn and (main_edtn=@pmainedtn or @pmainedtn is null or @pmainedtn ='')) 
                    and (d.sup_type_code = @pextra2 or @pextra2 is null or @pextra2 ='')) first_total_supply   
                    
        FROM (    SELECT DISTINCT a.comp_code comp_code,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang,c.city_code,c.dist_code,b.dist_name,b.dist_oname,
                     (SELECT ISNULL(SUM(sup_copy), 0)
                    FROM  cir_dbksup
                    WHERE comp_code  = @pcomp_code
                     AND (unit_code  = @punit_code or @punit_code is null or @punit_code='')
                     AND publ  = @ppublication
                     AND (edtn  = @pedtn OR    @pedtn  is null OR    @pedtn = '')
                     AND supdate  = @vfirstdate
                     AND cir_dbksup.agcd  = a.agcd AND    cir_dbksup.dpcd  = a.dpcd
                     AND cir_dbksup.edtn  in
                        (SELECT DISTINCT edtn
                        FROM  cir_edtn_mast
                        WHERE comp_code  = @pcomp_code
                         AND (edtn  = @pedtn OR    @pedtn  is null OR    @pedtn = '')
                         AND (main_edtn  = @pmainedtn OR    @pmainedtn  is null OR    @pmainedtn = ''))) first_sup,
                     (    SELECT ISNULL(SUM(sup_copy), 0)
                    FROM  cir_dbksup
                    WHERE comp_code  = @pcomp_code AND (unit_code  = @punit_code or @punit_code is null or @punit_code='')
                     AND publ  = @ppublication
                     AND (edtn  = @pedtn OR    @pedtn  is null OR    @pedtn = '')
                     AND supdate  = @vseconddate
                     AND cir_dbksup.agcd  = a.agcd AND cir_dbksup.dpcd  = a.dpcd
                     AND cir_dbksup.edtn  in
                        (SELECT DISTINCT edtn
                        FROM  cir_edtn_mast
                        WHERE comp_code  = @pcomp_code
                         AND (edtn  = @pedtn OR    @pedtn  is null OR    @pedtn = '')
                         AND    (main_edtn  = @pmainedtn OR    @pmainedtn  is null OR    @pmainedtn = ''))) second_sup
            FROM  cir_dbksup a,cir_dist_mast b,cir_agmast c
            WHERE a.comp_code  = @pcomp_code AND    a.comp_code  = c.comp_code AND    b.comp_code  = c.comp_code
             AND (a.unit_code  = @punit_code or @punit_code is null or @punit_code='')
              AND    a.unit_code  = c.unit
             AND (a.supdate  = @vfirstdate OR    a.supdate  = @vseconddate)
             AND a.agcd  = c.agcd AND a.dpcd  = c.dpcd
             AND (c.dist_code  = @pdist OR    @pdist  is null OR    @pdist = '')
             AND c.dist_code  = b.dist_code
             and (a.AGENCY_TY_CODE=@pextra3 or @pextra3 is null or @pextra3='')
	and (c.AG_CLASS=@pextra4 or @pextra4 is null or @pextra4='')
	and (isnull(final_supply_flag,'N') = @pextra5  or @pextra5 is null or @pextra5='')
             ) q
        WHERE ISNULL(second_sup, 0) - ISNULL(first_sup, 0)  <> 0
        GROUP BY  q.comp_code         ORDER BY q.comp_code
end        


****************************************************************************************************************************


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
    --    SELECT @vfirstdate  = @pfirstdate
    --    SELECT @vseconddate  =  @pseconddate
    SET @vfirstdate  =  dbo.convert_user_date('/',@pfirstdate,@pdateformat)
    SET @vseconddate  = dbo.convert_user_date('/',@pseconddate,@pdateformat)

print(@vfirstdate)
print(@vseconddate)

if upper(@pextra1)='U' begin       
	SELECT
	m.comp_code "COMP CODE",m.agcd "AGENCY CODE",m.dpcd "AGENCY SUB CODE",
	m.ag_name "AGENCY NAME",m.ag_name_oth_lang "AGENCY OTHER LANG",DBO.cir_get_city(m.comp_code, m.city_code) "CITY NAME",
	m.tehsil_taluka "TALUKA CODE",isnull(m.talu_name,'(blank)') "TALUKA NAME",m.talu_oname "TALUKA NAME OTHER LANG",
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
	END "PERCENT_VARIANCE",
	dbo.cir_get_drop_point_name(m.comp_code,unit_code,station_code,1) "DROP POINT NAME",
    dbo.cir_get_drop_point_name(m.comp_code,unit_code,station_code,2) "DROP POINT NAME OTHER LANG",branch_code "BRANCH NAME"
	FROM (    
	SELECT DISTINCT a.comp_code ,a.unit_code ,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang
	,c.city_code,c.tehsil_taluka,b.talu_name,b.talu_oname,c.station_code station_code,c.branch_code branch_code,
	 (    SELECT ISNULL(SUM(sup_copy), 0)
	from cir_supply
	WHERE comp_code  = @pcomp_code
	 AND (unit  = @punit_code or @punit_code is null or @punit_code='')
	 AND publ  = @ppublication
	 AND (edtn  = @pedtn OR    @pedtn  is null  OR    @pedtn = '')
	 and isnull(cir_supply.supply_flag,'N') =    'Y' 
	 AND cir_supply.agcd  = a.agcd
	 AND cir_supply.dpcd  = a.dpcd
	 AND cir_supply.edtn  in(
		 SELECT DISTINCT edtn FROM  cir_edtn_mast
		WHERE comp_code  = @pcomp_code
		 AND (edtn  = @pedtn OR    @pedtn  is null OR    @pedtn = '')
		 AND (main_edtn  = @pmainedtn OR    @pmainedtn  is null OR    @pmainedtn = '')
		 and (cir_supply.supply_type_code = @pextra2 or @pextra2 is null  or @pextra2='')
		 ))	 first_sup,
	 (SELECT ISNULL(SUM(sup_copy), 0)
	FROM  cir_dbksup a
	WHERE comp_code  = @pcomp_code AND    (unit_code  = @punit_code or @punit_code is null or @punit_code='')
	 AND publ  = @ppublication
	 AND (edtn  = @pedtn OR @pedtn  is null OR    @pedtn = '')
	 AND supdate  = @vseconddate
	 AND a.agcd  = a.agcd AND    a.dpcd  = a.dpcd
	 AND a.edtn  in
		(SELECT DISTINCT edtn FROM  cir_edtn_mast
		WHERE comp_code  = @pcomp_code
		 AND (edtn  = @pedtn OR    @pedtn  is null OR    @pedtn = '')
		 AND (main_edtn  = @pmainedtn OR    @pmainedtn  is null OR    @pmainedtn = '')
		 and  (a.sup_type_code = @pextra2 or @pextra2 is null or @pextra2 ='')
		 )) second_sup
	FROM  cir_dbksup a,cir_taluka_mast b,cir_agmast c
	WHERE a.comp_code  = @pcomp_code AND a.comp_code  = c.comp_code AND b.comp_code  = c.comp_code
	AND (a.unit_code  = @punit_code or @punit_code is null or @punit_code='')
	 AND a.unit_code  = c.unit
	AND (a.supdate  = @vfirstdate OR    a.supdate  = @vseconddate)
	AND a.agcd  = c.agcd AND a.dpcd  = c.dpcd
	AND (c.tehsil_taluka  = @ptaluka OR    @ptaluka  is null  OR    @ptaluka = '')
	AND c.tehsil_taluka=b.talu_code
	and (a.AGENCY_TY_CODE=@pextra3 or @pextra3 is null or @pextra3='')
	and (c.AG_CLASS=@pextra4 or @pextra4 is null or @pextra4='')
	and (isnull(final_supply_flag,'N') = @pextra5  or @pextra5 is null or @pextra5='')
	group by a.comp_code ,a.unit_code ,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang,c.city_code,c.tehsil_taluka,b.talu_name,b.talu_oname,c.station_code ,c.branch_code 
	) m
	WHERE    ISNULL(second_sup, 0) - ISNULL(first_sup, 0)  <> 0
	GROUP BY m.comp_code,m.unit_code,m.agcd,m.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.tehsil_taluka,m.talu_name,m.talu_oname,m.station_code,m.branch_code
	ORDER BY m.comp_code,m.tehsil_taluka,m.ag_name
end
else
begin
SELECT
	m.comp_code "COMP CODE",m.agcd "AGENCY CODE",m.dpcd "AGENCY SUB CODE",
	m.ag_name "AGENCY NAME",m.ag_name_oth_lang "AGENCY OTHER LANG",DBO.cir_get_city(m.comp_code, m.city_code) "CITY NAME",
	m.tehsil_taluka "TALUKA CODE",isnull(m.talu_name,'(blank)') "TALUKA NAME",m.talu_oname "TALUKA NAME OTHER LANG",
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
	END "PERCENT_VARIANCE",
	dbo.cir_get_drop_point_name(m.comp_code,m.unit_code,m.station_code,1) "DROP POINT NAME",
    dbo.cir_get_drop_point_name(m.comp_code,unit_code,station_code,2) "DROP POINT NAME OTHER LANG",branch_code "BRANCH NAME"
	FROM (    SELECT DISTINCT
	 a.comp_code comp_code,a.unit_code unit_code,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang,c.city_code,c.tehsil_taluka,b.talu_name,b.talu_oname,c.station_code station_code,c.branch_code branch_code,
	 (    SELECT ISNULL(SUM(sup_copy), 0)
	FROM  cir_dbksup
	WHERE comp_code  = @pcomp_code
	 AND (unit_code  = @punit_code or @punit_code is null or @punit_code='')
	 AND publ  = @ppublication
	 AND (edtn  = @pedtn OR    @pedtn  is null  OR    @pedtn = '')
	 AND supdate  = @vfirstdate
	 AND cir_dbksup.agcd  = a.agcd
	 AND cir_dbksup.dpcd  = a.dpcd
	 AND cir_dbksup.edtn  in(
		 SELECT DISTINCT edtn FROM  cir_edtn_mast
		WHERE comp_code  = @pcomp_code
		 AND (edtn  = @pedtn OR    @pedtn  is null OR    @pedtn = '')
		 AND (main_edtn  = @pmainedtn OR    @pmainedtn  is null OR    @pmainedtn = ''))) first_sup,
	 (SELECT ISNULL(SUM(sup_copy), 0)
	FROM  cir_dbksup
	WHERE comp_code  = @pcomp_code AND    (unit_code  = @punit_code or @punit_code is null or @punit_code='')
	 AND publ  = @ppublication
	 AND (edtn  = @pedtn OR @pedtn  is null OR    @pedtn = '')
	 AND supdate  = @vseconddate
	 AND cir_dbksup.agcd  = a.agcd AND    cir_dbksup.dpcd  = a.dpcd
	 AND cir_dbksup.edtn  in
		(SELECT DISTINCT edtn FROM  cir_edtn_mast
		WHERE comp_code  = @pcomp_code
		 AND (edtn  = @pedtn OR    @pedtn  is null OR    @pedtn = '')
		 AND (main_edtn  = @pmainedtn OR    @pmainedtn  is null OR    @pmainedtn = ''))) second_sup	
	FROM  cir_dbksup a,cir_taluka_mast b,cir_agmast c
	WHERE a.comp_code  = @pcomp_code AND a.comp_code  = c.comp_code AND b.comp_code  = c.comp_code
	AND (a.unit_code  = @punit_code or @punit_code is null or @punit_code='')
	 AND a.unit_code  = c.unit
	AND (a.supdate  = @vfirstdate OR    a.supdate  = @vseconddate)
	AND a.agcd  = c.agcd AND a.dpcd  = c.dpcd
	AND (c.tehsil_taluka  = @ptaluka OR    @ptaluka  is null  OR    @ptaluka = '')
	AND c.tehsil_taluka=b.talu_code
	and (a.AGENCY_TY_CODE=@pextra3 or @pextra3 is null or @pextra3='')
	and (c.AG_CLASS=@pextra4 or @pextra4 is null or @pextra4='')
	and (isnull(final_supply_flag,'N') = @pextra5  or @pextra5 is null or @pextra5='')
	group by a.comp_code ,a.unit_code ,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang,c.city_code,c.tehsil_taluka,b.talu_name,b.talu_oname,c.station_code ,c.branch_code ) m
	WHERE    ISNULL(second_sup, 0) - ISNULL(first_sup, 0)  <> 0
	GROUP BY m.comp_code,m.unit_code,m.agcd,m.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.tehsil_taluka,m.talu_name,m.talu_oname,m.station_code,m.branch_code
	ORDER BY m.comp_code,m.tehsil_taluka,m.ag_name

end


-- district wise
if upper(@pextra1)='U' begin 
	SELECT r.comp_code "COMP CODE", r.tehsil_taluka "TALUKA CODE",isnull(r.talu_name,'(blank)') "TALUKA NAME",r.talu_oname "TALUKA NAME OTHER LANG",
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
	FROM (SELECT DISTINCT
	a.comp_code comp_code,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang,c.city_code,c.tehsil_taluka,b.talu_name,b.talu_oname,
	(    SELECT ISNULL(SUM(sup_copy), 0)
	from cir_supply
	WHERE comp_code  = @pcomp_code
	 AND (unit = @punit_code or @punit_code is null or @punit_code='')
	 AND publ  = @ppublication
	 AND (edtn  = @pedtn OR    @pedtn  is null  OR    @pedtn = '')
	 and isnull(cir_supply.supply_flag,'N') =    'Y' 
	 AND cir_supply.agcd  = a.agcd
	 AND cir_supply.dpcd  = a.dpcd
	 AND cir_supply.edtn  in(
		 SELECT DISTINCT edtn FROM  cir_edtn_mast
		WHERE comp_code  = @pcomp_code
		 AND (edtn  = @pedtn OR    @pedtn  is null OR    @pedtn = '')
		 AND (main_edtn  = @pmainedtn OR    @pmainedtn  is null OR    @pmainedtn = '')
		 and (cir_supply.supply_type_code = @pextra2 or @pextra2 is null  or @pextra2='')
		 ))	 first_sup ,
	(SELECT ISNULL(SUM(sup_copy), 0)
	FROM  cir_dbksup a
	WHERE comp_code  = @pcomp_code AND    (unit_code  = @punit_code or @punit_code is null or @punit_code='')
	AND publ  = @ppublication
	AND (edtn  = @pedtn OR @pedtn  is null OR    @pedtn = '')
	AND supdate  = @vseconddate
	AND a.agcd  = a.agcd AND    a.dpcd  = a.dpcd
	AND a.edtn  in
	(SELECT DISTINCT edtn FROM  cir_edtn_mast
	WHERE comp_code  = @pcomp_code
	 AND (edtn  = @pedtn OR    @pedtn  is null OR    @pedtn = '')
	 AND (main_edtn  = @pmainedtn OR    @pmainedtn  is null OR    @pmainedtn = '')
	 and  (a.sup_type_code = @pextra2 or @pextra2 is null or @pextra2 ='')
	 )) second_sup 
	FROM  cir_dbksup a,cir_taluka_mast b,cir_agmast c
	WHERE a.comp_code  = @pcomp_code
	AND a.comp_code  = c.comp_code
	AND b.comp_code  = c.comp_code
	AND (a.unit_code  = @punit_code or @punit_code is null or @punit_code='')
	AND a.unit_code  = c.unit
	AND (a.supdate  = @vfirstdate OR    a.supdate  = @vseconddate)
	AND a.agcd  = c.agcd AND a.dpcd  = c.dpcd
	AND (c.tehsil_taluka  = @ptaluka OR    @ptaluka  is null  OR    @ptaluka = '')
	AND c.tehsil_taluka=b.talu_code
	and (a.AGENCY_TY_CODE=@pextra3 or @pextra3 is null or @pextra3='')
	and (c.AG_CLASS=@pextra4 or @pextra4 is null or @pextra4='')
	and (isnull(final_supply_flag,'N') = @pextra5  or @pextra5 is null or @pextra5='')
	group by a.comp_code ,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang,c.city_code,c.tehsil_taluka,b.talu_name,b.talu_oname) r
	WHERE ISNULL(r.second_sup, 0) - ISNULL(r.first_sup, 0)  <> 0
	GROUP BY r.comp_code,r.tehsil_taluka,r.talu_name,r.talu_oname
	ORDER BY r.comp_code,r.tehsil_taluka
end
else
begin

       SELECT
                 r.comp_code "COMP CODE", r.tehsil_taluka "TALUKA CODE",isnull(r.talu_name,'(blank)') "TALUKA NAME",r.talu_oname "TALUKA NAME OTHER LANG",
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
        FROM (    SELECT DISTINCT
                     a.comp_code comp_code,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang,c.city_code,c.tehsil_taluka,b.talu_name,b.talu_oname,
                     (SELECT ISNULL(SUM(sup_copy), 0)
                    FROM  cir_dbksup
                    WHERE comp_code  = @pcomp_code
                     AND (unit_code  = @punit_code or @punit_code is null or @punit_code='')
                     AND publ  = @ppublication
                     AND (edtn  = @pedtn OR    @pedtn  is null OR    @pedtn = '')
                     AND supdate  = @vfirstdate
                     AND cir_dbksup.agcd  = a.agcd
                     AND cir_dbksup.dpcd  = a.dpcd
                     AND cir_dbksup.edtn  in
                        (SELECT DISTINCT edtn FROM  cir_edtn_mast
                        WHERE comp_code  = @pcomp_code
                         AND (edtn  = @pedtn OR    @pedtn  is null OR    @pedtn = '')
                         AND (main_edtn  = @pmainedtn OR    @pmainedtn  is null OR    @pmainedtn = ''))) first_sup,
                     (SELECT ISNULL(SUM(sup_copy), 0) FROM  cir_dbksup
                    WHERE comp_code  = @pcomp_code
                     AND (unit_code  = @punit_code or @punit_code is null or @punit_code='')
                     AND publ  = @ppublication
                     AND (edtn  = @pedtn OR    @pedtn  is null)
                     AND supdate  = @vseconddate
                     AND cir_dbksup.agcd  = a.agcd
                     AND cir_dbksup.dpcd  = a.dpcd
                     AND cir_dbksup.edtn  in (SELECT DISTINCT edtn FROM  cir_edtn_mast
                        WHERE comp_code  = @pcomp_code
                         AND (edtn  = @pedtn OR    @pedtn  is null OR    @pedtn = '')
                         AND (main_edtn  = @pmainedtn OR    @pmainedtn  is null OR    @pmainedtn = ''))) second_sup
            FROM  cir_dbksup a,cir_taluka_mast b,cir_agmast c
            WHERE a.comp_code  = @pcomp_code
             AND a.comp_code  = c.comp_code
             AND b.comp_code  = c.comp_code
             AND (a.unit_code  = @punit_code or @punit_code is null or @punit_code='')
             AND a.unit_code  = c.unit
             AND (a.supdate  = @vfirstdate OR    a.supdate  = @vseconddate)
             AND a.agcd  = c.agcd AND a.dpcd  = c.dpcd
             AND (c.tehsil_taluka  = @ptaluka OR    @ptaluka  is null  OR    @ptaluka = '')
			AND c.tehsil_taluka=b.talu_code
			and (a.AGENCY_TY_CODE=@pextra3 or @pextra3 is null or @pextra3='')
	and (c.AG_CLASS=@pextra4 or @pextra4 is null or @pextra4='')
	and (isnull(final_supply_flag,'N') = @pextra5  or @pextra5 is null or @pextra5='')) r
        WHERE ISNULL(second_sup, 0) - ISNULL(first_sup, 0)  <> 0
        GROUP BY r.comp_code,r.tehsil_taluka,r.talu_name,r.talu_oname
        ORDER BY r.comp_code,r.tehsil_taluka
end
if upper(@pextra1)='U' begin 
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
        END "PERCENT_VARIANCE",
        
        (select isnull(sum(d.sup_copy),0) from cir_dbksup d,cir_agmast m  where d.comp_code = m.comp_code and d.comp_code = @pcomp_code and d.unit_code = m.unit 
        and (d.unit_code = @punit_code or @punit_code is null or @punit_code='') and
                    d.publ = @ppublication and (d.edtn = @pedtn or @pedtn is null or @pedtn ='') 
                    and d.agcd=m.agcd and d.dpcd=m.dpcd and d.supdate = @vfirstdate and
                    (m.tehsil_taluka = @ptaluka or @ptaluka is null or @ptaluka='') and d.edtn in
                    (select distinct edtn from cir_edtn_mast
                    where comp_code=d.comp_code and edtn = d.edtn and (main_edtn=@pmainedtn or @pmainedtn is null or @pmainedtn ='')) 
                    and (d.sup_type_code = @pextra2 or @pextra2 is null or @pextra2 ='')) first_total_supply        
			    FROM (SELECT DISTINCT a.comp_code comp_code,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang,c.city_code,c.tehsil_taluka,b.talu_name,b.talu_oname,
    (SELECT ISNULL(SUM(sup_copy), 0)
	from cir_supply
	WHERE comp_code  = @pcomp_code
	 AND (unit  = @punit_code or @punit_code is null or @punit_code ='')
	 AND publ  = @ppublication
	 AND (edtn  = @pedtn OR    @pedtn  is null  OR    @pedtn = '')
	 and isnull(cir_supply.supply_flag,'N') =    'Y' 
	 AND cir_supply.agcd  = a.agcd
	 AND cir_supply.dpcd  = a.dpcd
	 AND cir_supply.edtn  in(
		 SELECT DISTINCT edtn FROM  cir_edtn_mast
		WHERE comp_code  = @pcomp_code
		 AND (edtn  = @pedtn OR    @pedtn  is null OR    @pedtn = '')
		 AND (main_edtn  = @pmainedtn OR    @pmainedtn  is null OR    @pmainedtn = '')
		 and (cir_supply.supply_type_code = @pextra2 or @pextra2 is null  or @pextra2='')
		 ))	 first_sup,
	 (SELECT ISNULL(SUM(sup_copy), 0)
	FROM  cir_dbksup a
	WHERE comp_code  = @pcomp_code AND    (unit_code  = @punit_code or @punit_code is null or @punit_code='')
	 AND publ  = @ppublication
	 AND (edtn  = @pedtn OR @pedtn  is null OR    @pedtn = '')
	 AND supdate  = @vseconddate
	 AND a.agcd  = a.agcd AND    a.dpcd  = a.dpcd
	 AND a.edtn  in
		(SELECT DISTINCT edtn FROM  cir_edtn_mast
		WHERE comp_code  = @pcomp_code
		 AND (edtn  = @pedtn OR    @pedtn  is null OR    @pedtn = '')
		 AND (main_edtn  = @pmainedtn OR    @pmainedtn  is null OR    @pmainedtn = '')
		 and  (a.sup_type_code = @pextra2 or @pextra2 is null or @pextra2 ='')
	 )) second_sup
        FROM  cir_dbksup a,cir_taluka_mast b,cir_agmast c
        WHERE a.comp_code  = @pcomp_code AND  a.comp_code  = c.comp_code AND b.comp_code  = c.comp_code
         AND (a.unit_code  = @punit_code or @punit_code is null or @punit_code='') AND    a.unit_code  = c.unit
         AND (a.supdate  = @vfirstdate OR    a.supdate  = @vseconddate)
         AND a.agcd  = c.agcd AND a.dpcd  = c.dpcd
         AND (c.tehsil_taluka=    @ptaluka OR    @ptaluka  is null OR    @ptaluka = '')
         AND c.tehsil_taluka=b.talu_code
         and (a.AGENCY_TY_CODE=@pextra3 or @pextra3 is null or @pextra3='')
	and (c.AG_CLASS=@pextra4 or @pextra4 is null or @pextra4='')
	and (isnull(final_supply_flag,'N') = @pextra5  or @pextra5 is null or @pextra5='')
         group by a.comp_code ,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang,c.city_code,c.tehsil_taluka,b.talu_name,b.talu_oname
         ) q
        WHERE ISNULL(second_sup, 0) - ISNULL(first_sup, 0)  <> 0
        GROUP BY  q.comp_code  ORDER BY q.comp_code
end
else
begin       
       

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
                END "PERCENT_VARIANCE",
                (select isnull(sum(d.sup_copy),0) from cir_dbksup d,cir_agmast m  where d.comp_code = m.comp_code and d.comp_code = @pcomp_code and d.unit_code = m.unit 
        and (d.unit_code = @punit_code or @punit_code is null or @punit_code='') and
                    d.publ = @ppublication and (d.edtn = @pedtn or @pedtn is null or @pedtn ='') 
                    and d.agcd=m.agcd and d.dpcd=m.dpcd and d.supdate = @vfirstdate and
                    (m.tehsil_taluka = @ptaluka or @ptaluka is null or @ptaluka='') and d.edtn in
                    (select distinct edtn from cir_edtn_mast
                    where comp_code=d.comp_code and edtn = d.edtn and (main_edtn=@pmainedtn or @pmainedtn is null or @pmainedtn ='')) 
                    and (d.sup_type_code = @pextra2 or @pextra2 is null or @pextra2 ='')) first_total_supply   
                    
        FROM (    SELECT DISTINCT a.comp_code comp_code,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang,c.city_code,c.tehsil_taluka,b.talu_name,b.talu_oname,
                     (SELECT ISNULL(SUM(sup_copy), 0)
                    FROM  cir_dbksup
                    WHERE comp_code  = @pcomp_code
                     AND (unit_code  = @punit_code or @punit_code is null or @punit_code='')
                     AND publ  = @ppublication
                     AND (edtn  = @pedtn OR    @pedtn  is null OR    @pedtn = '')
                     AND supdate  = @vfirstdate
                     AND cir_dbksup.agcd  = a.agcd AND    cir_dbksup.dpcd  = a.dpcd
                     AND cir_dbksup.edtn  in
                        (SELECT DISTINCT edtn
                        FROM  cir_edtn_mast
                        WHERE comp_code  = @pcomp_code
                         AND (edtn  = @pedtn OR    @pedtn  is null OR    @pedtn = '')
                         AND (main_edtn  = @pmainedtn OR    @pmainedtn  is null OR    @pmainedtn = ''))) first_sup,
                     (    SELECT ISNULL(SUM(sup_copy), 0)
                    FROM  cir_dbksup
                    WHERE comp_code  = @pcomp_code AND (unit_code  = @punit_code or @punit_code is null or @punit_code='')
                     AND publ  = @ppublication
                     AND (edtn  = @pedtn OR    @pedtn  is null OR    @pedtn = '')
                     AND supdate  = @vseconddate
                     AND cir_dbksup.agcd  = a.agcd AND cir_dbksup.dpcd  = a.dpcd
                     AND cir_dbksup.edtn  in
                        (SELECT DISTINCT edtn
                        FROM  cir_edtn_mast
                        WHERE comp_code  = @pcomp_code
                         AND (edtn  = @pedtn OR    @pedtn  is null OR    @pedtn = '')
                         AND    (main_edtn  = @pmainedtn OR    @pmainedtn  is null OR    @pmainedtn = ''))) second_sup
            FROM  cir_dbksup a,cir_taluka_mast b,cir_agmast c
            WHERE a.comp_code  = @pcomp_code AND    a.comp_code  = c.comp_code AND    b.comp_code  = c.comp_code
             AND (a.unit_code  = @punit_code or @punit_code is null or @punit_code='')
              AND    a.unit_code  = c.unit
             AND (a.supdate  = @vfirstdate OR    a.supdate  = @vseconddate)
             AND a.agcd  = c.agcd AND a.dpcd  = c.dpcd
             AND (c.tehsil_taluka=    @ptaluka OR    @ptaluka  is null OR    @ptaluka = '')
             AND c.tehsil_taluka=b.talu_code
             and (a.AGENCY_TY_CODE=@pextra3 or @pextra3 is null or @pextra3='')
	and (c.AG_CLASS=@pextra4 or @pextra4 is null or @pextra4='')
	and (isnull(final_supply_flag,'N') = @pextra5  or @pextra5 is null or @pextra5='')) q
        WHERE ISNULL(second_sup, 0) - ISNULL(first_sup, 0)  <> 0
        GROUP BY  q.comp_code         ORDER BY q.comp_code
end        


****************************************************************************************************************************


ALTER PROCEDURE [dbo].[cir_rep_supply_cir_edition_supply_variance_p]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@ppublication                             VARCHAR(20) ,
	@pmainedtn                                VARCHAR(20) ,
	@pedtn                                    VARCHAR(20) ,
	@pfirstdate                               DATETIME,
	@pseconddate                              DATETIME,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(20) ,
	@pextra2                                  VARCHAR(20) 
AS 
	
		
		DECLARE @vfirstdate                               DATETIME 
		DECLARE @vseconddate                              DATETIME 
		SELECT @vfirstdate  = @pfirstdate
		SELECT @vseconddate  = @pseconddate
		
		
		SELECT
				 comp_code "COMP CODE",
				 agcd "AGENCY CODE",
				 dpcd "AGENCY SUB CODE",
				 ag_name "AGENCY NAME",
				 ag_name_oth_lang "AGENCY OTHER LANG",
				 DBO.cir_get_city(comp_code, city_code) "CITY NAME",
				 edtn "EDITION CODE",
				 edtn_name "EDITION NAME",
				 edtn_name_oth_lang "EDITION NAME OTHER LANG",'' as blank,
				 SUM(CONVERT(FLOAT, first_sup)) "FIRST SUPPLY",
				 SUM(CONVERT(FLOAT, second_sup)) "SECOND SUPPLY",
				 
				CASE sign(ISNULL(SUM(CONVERT(FLOAT, second_sup)), 0) - ISNULL(SUM(CONVERT(FLOAT, first_sup)), 0)) 
					WHEN - 1 THEN 0 
					ELSE (ISNULL(SUM(CONVERT(FLOAT, second_sup)), 0) - ISNULL(SUM(CONVERT(FLOAT, first_sup)), 0)) 
				END "INCREASE SUPPLY",
				 
				CASE sign(ISNULL(SUM(CONVERT(FLOAT, second_sup)), 0) - ISNULL(SUM(CONVERT(FLOAT, first_sup)), 0)) 
					WHEN 1 THEN 0 
					ELSE (ISNULL(SUM(CONVERT(FLOAT, second_sup)), 0) - ISNULL(SUM(CONVERT(FLOAT, first_sup)), 0)) 
				END "DECREASE SUPPLY",
				 
				CASE ISNULL(SUM(CONVERT(FLOAT, first_sup)), 0) 
					WHEN 0 THEN 100 
					ELSE ROUND(((ISNULL(SUM(CONVERT(FLOAT, second_sup)), 0) - ISNULL(SUM(CONVERT(FLOAT, first_sup)), 0)) * 100) / CONVERT(FLOAT, 
							CASE sign(SUM(CONVERT(FLOAT, second_sup)) - SUM(CONVERT(FLOAT, first_sup))) 
								WHEN - 1 THEN SUM(CONVERT(FLOAT, first_sup)) 
								ELSE SUM(CONVERT(FLOAT, second_sup)) 
							END), 2) 
				END "PERCENT_VARIANCE"
				
				,dbo.cir_get_drop_point_name(comp_code,@punit_code,STATION_CODE,'1') as drop_point
		FROM (	SELECT DISTINCT
					 a.comp_code comp_code,
					 a.agcd,
					 a.dpcd,
					 c.ag_name,
					 c.ag_name_oth_lang,
					 c.city_code,
					 a.edtn,
					 b.edtn_name,
					 b.edtn_name_oth_lang,
					 (			SELECT ISNULL(SUM(CONVERT(FLOAT, sup_copy)), 0)
					FROM  cir_dbksup 
					WHERE	 comp_code  = @pcomp_code
					 AND	unit_code  = @punit_code
					 AND	publ  = @ppublication
					 AND	(edtn  = @pedtn
					 OR	@pedtn  is null OR	@pedtn = '')
					 AND	cir_dbksup.publ  = b.publ
					 AND	cir_dbksup.edtn  = b.edtn
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
					 AND	cir_dbksup.publ  = b.publ
					 AND	cir_dbksup.edtn  = b.edtn
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
						 OR	@pmainedtn  is null OR	@pmainedtn  = '')
						)
		) second_sup
		,c.STATION_CODE
			FROM  cir_dbksup a,
				 cir_edtn_mast b,
				 cir_agmast c 
			WHERE	 a.comp_code  = @pcomp_code
			 AND	a.comp_code  = b.comp_code
			 AND	a.comp_code  = c.comp_code
			 AND	a.unit_code  = @punit_code
			 AND	a.unit_code  = c.unit
			 AND	(a.supdate  = @vfirstdate
			 OR	a.supdate  = @vseconddate)
			 AND	(a.publ  = b.publ)
			 AND	(a.publ  = @ppublication
			 OR	@ppublication  is null OR	@ppublication  = '')
			 AND	a.edtn  = b.edtn
			 AND	(a.edtn  = @pedtn
			 OR	@pedtn  is null OR	@pedtn = '')
			 AND	a.agcd  = c.agcd
			 AND	a.dpcd  = c.dpcd
		) AdventNet_ALIAS1 
		WHERE	 ISNULL(second_sup, 0) - ISNULL(first_sup, 0)  <> 0
		GROUP BY comp_code,
			 agcd,
			 dpcd,
			 ag_name,
			 ag_name_oth_lang,
			 city_code,
			 edtn,
			 edtn_name,
			  edtn_name_oth_lang ,STATION_CODE
		ORDER BY comp_code,
			 edtn_name,
			 ag_name 
		
		
		



		
		SELECT
				 comp_code "COMP CODE",
				 edtn "EDITION CODE",
				 edtn_name "EDITION NAME",
				 edtn_name_oth_lang "EDITION NAME OTHER LANG",
				 SUM(CONVERT(FLOAT, first_sup)) "FIRST SUPPLY",
				 SUM(CONVERT(FLOAT, second_sup)) "SECOND SUPPLY",
				 
				CASE sign(ISNULL(SUM(CONVERT(FLOAT, second_sup)), 0) - ISNULL(SUM(CONVERT(FLOAT, first_sup)), 0)) 
					WHEN - 1 THEN 0 
					ELSE (ISNULL(SUM(CONVERT(FLOAT, second_sup)), 0) - ISNULL(SUM(CONVERT(FLOAT, first_sup)), 0)) 
				END "INCREASE SUPPLY",
				 
				CASE sign(ISNULL(SUM(CONVERT(FLOAT, second_sup)), 0) - ISNULL(SUM(CONVERT(FLOAT, first_sup)), 0)) 
					WHEN 1 THEN 0 
					ELSE (ISNULL(SUM(CONVERT(FLOAT, second_sup)), 0) - ISNULL(SUM(CONVERT(FLOAT, first_sup)), 0)) 
				END "DECREASE SUPPLY",
				 
				CASE ISNULL(SUM(CONVERT(FLOAT, first_sup)), 0) 
					WHEN 0 THEN 100 
					ELSE ROUND(((ISNULL(SUM(CONVERT(FLOAT, second_sup)), 0) - ISNULL(SUM(CONVERT(FLOAT, first_sup)), 0)) * 100) / CONVERT(FLOAT, 
							CASE sign(SUM(CONVERT(FLOAT, second_sup)) - SUM(CONVERT(FLOAT, first_sup))) 
								WHEN - 1 THEN SUM(CONVERT(FLOAT, first_sup)) 
								ELSE SUM(CONVERT(FLOAT, second_sup)) 
							END), 2) 
				END "PERCENT_VARIANCE"
		FROM (	SELECT DISTINCT
					 a.comp_code comp_code,
					 a.agcd,
					 a.dpcd,
					 c.ag_name,
					 c.ag_name_oth_lang,
					 c.city_code,
					 a.edtn,
					 b.edtn_name,
					 b.edtn_name_oth_lang,
					 (			SELECT ISNULL(SUM(CONVERT(FLOAT, sup_copy)), 0)
					FROM  cir_dbksup 
					WHERE	 comp_code  = @pcomp_code
					 AND	unit_code  = @punit_code
					 AND	publ  = @ppublication
					 AND	(edtn  = @pedtn
					 OR	@pedtn  is null OR	@pedtn = '')
					 AND	cir_dbksup.publ  = b.publ
					 AND	cir_dbksup.edtn  = b.edtn
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
					 OR	@pedtn  is null)
					 AND	cir_dbksup.publ  = b.publ
					 AND	cir_dbksup.edtn  = b.edtn
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
			FROM  cir_dbksup a,
				 cir_edtn_mast b,
				 cir_agmast c 
			WHERE	 a.comp_code  = @pcomp_code
			 AND	a.comp_code  = b.comp_code
			 AND	a.comp_code  = c.comp_code
			 AND	a.unit_code  = @punit_code
			 AND	a.unit_code  = c.unit
			 AND	(a.supdate  = @vfirstdate
			 OR	a.supdate  = @vseconddate)
			 AND	(a.publ  = b.publ)
			 AND	(a.publ  = @ppublication
			 OR	@ppublication  is null OR	@ppublication = '')
			 AND	a.edtn  = b.edtn
			 AND	(a.edtn  = @pedtn
			 OR	@pedtn  is null OR	@pedtn = '')
			 AND	a.agcd  = c.agcd
			 AND	a.dpcd  = c.dpcd
		) AdventNet_ALIAS1 
		WHERE	 ISNULL(second_sup, 0) - ISNULL(first_sup, 0)  <> 0
		GROUP BY comp_code,
			 edtn,
			 edtn_name,
			  edtn_name_oth_lang 
		ORDER BY comp_code,
			 edtn_name 
		
		
	



		
		SELECT
				 comp_code "COMP CODE",
				 SUM(CONVERT(FLOAT, first_sup)) "FIRST SUPPLY",
				 SUM(CONVERT(FLOAT, second_sup)) "SECOND SUPPLY",
				 
				CASE sign(ISNULL(SUM(CONVERT(FLOAT, second_sup)), 0) - ISNULL(SUM(CONVERT(FLOAT, first_sup)), 0)) 
					WHEN - 1 THEN 0 
					ELSE (ISNULL(SUM(CONVERT(FLOAT, second_sup)), 0) - ISNULL(SUM(CONVERT(FLOAT, first_sup)), 0)) 
				END "INCREASE SUPPLY",
				 
				CASE sign(ISNULL(SUM(CONVERT(FLOAT, second_sup)), 0) - ISNULL(SUM(CONVERT(FLOAT, first_sup)), 0)) 
					WHEN 1 THEN 0 
					ELSE (ISNULL(SUM(CONVERT(FLOAT, second_sup)), 0) - ISNULL(SUM(CONVERT(FLOAT, first_sup)), 0)) 
				END "DECREASE SUPPLY",
				 
				CASE ISNULL(SUM(CONVERT(FLOAT, first_sup)), 0) 
					WHEN 0 THEN 100 
					ELSE ROUND(((ISNULL(SUM(CONVERT(FLOAT, second_sup)), 0) - ISNULL(SUM(CONVERT(FLOAT, first_sup)), 0)) * 100) / CONVERT(FLOAT, 
							CASE sign(SUM(CONVERT(FLOAT, second_sup)) - SUM(CONVERT(FLOAT, first_sup))) 
								WHEN - 1 THEN SUM(CONVERT(FLOAT, first_sup)) 
								ELSE SUM(CONVERT(FLOAT, second_sup)) 
							END), 2) 
				END "PERCENT_VARIANCE"
		FROM (	SELECT DISTINCT
					 a.comp_code comp_code,
					 a.agcd,
					 a.dpcd,
					 c.ag_name,
					 c.ag_name_oth_lang,
					 c.city_code,
					 a.edtn,
					 b.edtn_name,
					 b.edtn_name_oth_lang,
					 (			SELECT ISNULL(SUM(CONVERT(FLOAT, sup_copy)), 0)
					FROM  cir_dbksup 
					WHERE	 comp_code  = @pcomp_code
					 AND	unit_code  = @punit_code
					 AND	publ  = @ppublication
					 AND	(edtn  = @pedtn
					 OR	@pedtn  is null OR	@pedtn = '')
					 AND	cir_dbksup.publ  = b.publ
					 AND	cir_dbksup.edtn  = b.edtn
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
					 OR	@pedtn  is null)
					 AND	cir_dbksup.publ  = b.publ
					 AND	cir_dbksup.edtn  = b.edtn
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
			FROM  cir_dbksup a,
				 cir_edtn_mast b,
				 cir_agmast c 
			WHERE	 a.comp_code  = @pcomp_code
			 AND	a.comp_code  = b.comp_code
			 AND	a.comp_code  = c.comp_code
			 AND	a.unit_code  = @punit_code
			 AND	a.unit_code  = c.unit
			 AND	(a.supdate  = @vfirstdate
			 OR	a.supdate  = @vseconddate)
			 AND	(a.publ  = b.publ)
			 AND	(a.publ  = @ppublication
			 OR	@ppublication  is null OR	@ppublication = '')
			 AND	a.edtn  = b.edtn
			 AND	(a.edtn  = @pedtn
			 OR	@pedtn  is null OR	@pedtn = '')
			 AND	a.agcd  = c.agcd
			 AND	a.dpcd  = c.dpcd
		) AdventNet_ALIAS1 
		WHERE	 ISNULL(second_sup, 0) - ISNULL(first_sup, 0)  <> 0
		GROUP BY  comp_code 
		ORDER BY comp_code 



****************************************************************************************************************************


ALTER PROCEDURE [dbo].[cir_get_userlist_]
@pcompcode VARCHAR(20) ,
@punit VARCHAR(20) ,
@pbranch VARCHAR(20) ,
@agcd VARCHAR(20) ,
@dpcd VARCHAR(20) ,
@pfromdate VARCHAR(20) ,
@ptodate VARCHAR(20) ,
@userid VARCHAR(20) ,
@pdateformat VARCHAR(20) ,
@pextra1 varchar(200),
@pextra2 varchar(200),
@pextra3 varchar(200),
@pextra4 varchar(200),
@pextra5 varchar(200),
@pextra6 varchar(200),
@pextra7 varchar(200),
@pextra8 varchar(200),
@pextra9 varchar(200),
@pextra10 varchar(200)

AS
BEGIN

SELECT T.COMP_CODE,UNIT,T.AGCD,T.DPCD,MAX(T.ALTER_ST) ALTER_ST,MAX(T.ALTER_USER) ALTER_USER ,MAX(T.CORRECT_ST) CORRECT_ST
,MAX(T.CORRECT_USER) CORRECT_USER FROM (
select distinct Q.COMP_CODE,Q.UNIT,Q.AGCD,Q.DPCD
,CASE Q.ALTER_ST WHEN 'CORRECT' THEN 'Y' ELSE '' END CORRECT_ST 
,CASE Q.ALTER_ST WHEN 'ALTER' THEN 'Y' ELSE '' END ALTER_ST 
,Q.ALTER_USER,Q.ALTER_USER CORRECT_USER from (

	select z.COMP_CODE,z.UNIT,z.AGCD,z.DPCD,z.ALTER_ST,z.ALTER_USER  from 
	(select x.COMP_CODE,x.UNIT,x.AGCD,x.DPCD,x.ALTER_ST,x.ALTER_USER   from (
	select COMP_CODE,UNIT,AGCD,DPCD,BASE_SUPPLY,SUPPLY_SUN,SUPPLY_MON,SUPPLY_TUE,SUPPLY_WED,SUPPLY_THU
	,SUPPLY_FRI,SUPPLY_SAT,SUPPLY_SPL1,SUPPLY_SPL2,SP_SUPPLY_SUN1,SP_SUPPLY_MON1,SP_SUPPLY_TUE1,SP_SUPPLY_WED1,SP_SUPPLY_THU1
	,SP_SUPPLY_FRI1,SP_SUPPLY_SAT1,SP_SUPPLY_SUN2,SP_SUPPLY_MON2,SP_SUPPLY_TUE2,SP_SUPPLY_WED2,SP_SUPPLY_THU2
	,SP_SUPPLY_FRI2,SP_SUPPLY_SAT2,'ALTER' ALTER_ST ,LOG_USER ALTER_USER  from CIR_SUPPLY_LOG v 
	WHERE COMP_CODE=@pcompcode and LOG_TYPE='N#UPDATE' and cast(LOG_DATE as datetime) between @pfromdate and @ptodate
	and not exists(
	select COMP_CODE,UNIT,AGCD,DPCD,BASE_SUPPLY,SUPPLY_SUN,SUPPLY_MON,SUPPLY_TUE,SUPPLY_WED,SUPPLY_THU
	,SUPPLY_FRI,SUPPLY_SAT,SUPPLY_SPL1,SUPPLY_SPL2,SP_SUPPLY_SUN1,SP_SUPPLY_MON1,SP_SUPPLY_TUE1,SP_SUPPLY_WED1,SP_SUPPLY_THU1
	,SP_SUPPLY_FRI1,SP_SUPPLY_SAT1,SP_SUPPLY_SUN2,SP_SUPPLY_MON2,SP_SUPPLY_TUE2,SP_SUPPLY_WED2,SP_SUPPLY_THU2
	,SP_SUPPLY_FRI2,SP_SUPPLY_SAT2,'ALTER' ALTER_ST,LOG_USER ALTER_USER  from CIR_SUPPLY_LOG t 
	WHERE COMP_CODE=@pcompcode and LOG_TYPE='O#UPDATE'  and cast(LOG_DATE as datetime) between @pfromdate and @ptodate
	and v.COMP_CODE=t.COMP_CODE and v.UNIT=t.UNIT and v.AGCD=t.AGCD and v.DPCD=t.DPCD
	and v.BASE_SUPPLY=t.BASE_SUPPLY and v.SUPPLY_SUN=t.SUPPLY_SUN and v.SUPPLY_MON=t.SUPPLY_MON and v.SUPPLY_TUE=t.SUPPLY_TUE
	and v.SUPPLY_WED=t.SUPPLY_WED and v.SUPPLY_THU=t.SUPPLY_THU and v.SUPPLY_FRI=t.SUPPLY_FRI and v.SUPPLY_SAT =t.SUPPLY_SAT
	and v.SUPPLY_SPL1=t.SUPPLY_SPL1 and v.SUPPLY_SPL2=t.SUPPLY_SPL2 and v.SP_SUPPLY_SUN1 = t.SP_SUPPLY_SUN1 and v.SP_SUPPLY_MON1=t.SP_SUPPLY_MON1
	and v.SP_SUPPLY_TUE1=t.SP_SUPPLY_TUE1 and v.SP_SUPPLY_WED1=t.SP_SUPPLY_WED1 and v.SP_SUPPLY_THU1=t.SP_SUPPLY_THU1
	and v.SP_SUPPLY_FRI1 =t.SP_SUPPLY_FRI1 and v.SP_SUPPLY_SAT1=t.SP_SUPPLY_SAT1 and v.SP_SUPPLY_SUN2 = t.SP_SUPPLY_SUN2 and v.SP_SUPPLY_MON2=t.SP_SUPPLY_MON2
	and v.SP_SUPPLY_TUE2=t.SP_SUPPLY_TUE2 and v.SP_SUPPLY_WED2=t.SP_SUPPLY_WED2 and v.SP_SUPPLY_THU2=t.SP_SUPPLY_THU2
	and v.SP_SUPPLY_FRI2 =t.SP_SUPPLY_FRI2 and v.SP_SUPPLY_SAT2=t.SP_SUPPLY_SAT2)
	) x
	union all
	select y.COMP_CODE,y.UNIT_CODE UNIT,y.AGCD,y.DPCD,y.ALTER_ST,y.ALTER_USER  from
	(select COMP_CODE,UNIT_CODE,AGCD,DPCD,SUP_COPY,'CORRECT' ALTER_ST ,LOG_USER ALTER_USER  
	from cir_dbksup_log v WHERE COMP_CODE=@pcompcode and LOG_TYPE='N#UPDATE' and cast(LOG_DATE as datetime) between @pfromdate and @ptodate
	and not exists(
	select COMP_CODE,UNIT_CODE,AGCD,DPCD,SUP_COPY,'CORRECT' ALTER_ST ,LOG_USER ALTER_USER  
	from cir_dbksup_log t WHERE COMP_CODE=@pcompcode and LOG_TYPE='O#UPDATE' and cast(LOG_DATE as datetime) between @pfromdate and @ptodate
	and v.COMP_CODE=t.COMP_CODE and v.SUP_COPY=t.SUP_COPY and v.UNIT_CODE=t.UNIT_CODE and v.AGCD=t.AGCD and v.DPCD=t.DPCD
	)
	)y )z where z.COMP_CODE=@pcompcode 
	and (z.UNIT =@punit or @punit is null or @punit='')
	--and (branch_code =@pbranch or @pbranch is null or @pbranch ='')
	and (z.AGCD =@agcd or @agcd is null or @agcd='')
	and (z.DPCD=@dpcd or @dpcd is null or @dpcd ='')
	group by z.COMP_CODE,z.UNIT,z.AGCD,z.DPCD,z.ALTER_ST,z.ALTER_USER
) Q ) T
	GROUP BY T.COMP_CODE,T.UNIT,T.AGCD,T.DPCD


END


****************************************************************************************************************************


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
	set @pquery='SELECT COMP_CODE,UNIT_CODE,ISNULL(ROUTE_CODE ,''NA'') "ROUTE CODE",'''' as "EXTRA"
	,substrING(isnull(dbo.cir_get_route_name(d.COMP_CODE,d.UNIT_CODE, d.ROUTE_CODE),''NA''),1,50) "ROUTE NAME",
       substring(isnull(dbo.cir_get_route(d.COMP_CODE,d.UNIT_CODE, d.ROUTE_CODE) ,''NA''),1,50) "ROUTE ONAME",
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
        WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE='''+@PCOMP_CODE+''' AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE='''+@PUNIT_CODE+''' AND
        A.AGCD  = B.AGCD AND (A.AGCD='+''''+@PAGCODE+''''+' OR '+''''+@PAGCODE+'''='''') AND 
		A.DPCD  = B.DPCD AND (A.DPCD='+''''+@PDPCODE+''''+' OR '+''''+@PDPCODE+'''='''') AND A.PUBL='''+@PPUBL+''' AND (A.EDTN='''+@PEDTN+''' or '''+@PEDTN+''' IS NULL OR '''+@PEDTN+''' ='''') AND (B.CITY_CODE='''+@PCITYCD+''' OR '''+@PCITYCD+''' IS NULL or '''+@PCITYCD+''' ='''') AND
        (B.STATE_CODE='''+@PSTATECD+''' OR '''+@PSTATECD+''' IS NULL or '''+@PSTATECD+''' ='''') AND 
        (B.DIST_CODE='''+@PDISTCODE+''' OR '''+@PDISTCODE+''' IS NULL or '''+@PDISTCODE+''' ='''') AND (B.TEHSIL_TALUKA='''+@PTALUKA+''' OR '''+@PTALUKA+''' IS NULL or '''+@PTALUKA+''' ='''') AND 
        (B.BRANCH_CODE='''+@PBRANCH+''' OR '''+@PBRANCH+''' IS NULL or '''+@PBRANCH+''' ='''') AND (B.AG_TYPE='''+@PAGTYPE+''' OR '''+@PAGTYPE+''' IS NULL or '''+@PAGTYPE+''' ='''') AND (B.AG_CLASS='''+@PAGCLASS+''' OR '''+@PAGCLASS+''' IS NULL or '''+@PAGCLASS+''' ='''') AND
        A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE='''+@PEXTRA1+''' OR '''+@PEXTRA1+''' IS NULL or '''+@PEXTRA1+''' ='''') AND 
        A.SUPDATE BETWEEN '''+@VFRDT+''' AND '''+@VTODT+'''    AND A.SUP_COPY>0
        GROUP BY A.COMP_CODE,A.UNIT_CODE,A.ROUTE_CODE,A.SUPDATE,B.CITY_CODE,B.STATE_CODE,B.COUNTRY_CODE) d
        GROUP BY d.COMP_CODE,d.UNIT_CODE,d.ROUTE_CODE,d.EDTN,d.CITY_CODE,d.STATE_CODE,d.COUNTRY_CODE
        ORDER BY d.COMP_CODE,d.UNIT_CODE,d.STATE_CODE,d.CITY_CODE,d.EDTN,d.ROUTE_CODE;'
--print @pquery	
end
else if @pextra2='P'
begin
	set @pquery='SELECT COMP_CODE,UNIT_CODE,PUBL "PUBL CODE",'''' as "EXTRA"
	,substrING(dbo.cir_get_publ_name(d.comp_code,d.PUBL),1,50) "PUBL NAME",
       substring(dbo.cir_get_publ_name_other(d.comp_code,d.PUBL,2,''dd/mm/yyyy'','''',''''),1,50) "PUBL ONAME",
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
		case (select(day(A.SUPDATE))) when  ''30'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p30,
		case (select(day(A.SUPDATE))) when  ''31'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p31
        FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C
        WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE='''+@PCOMP_CODE+''' AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE='''+@PUNIT_CODE+''' AND
        A.AGCD  = B.AGCD AND (A.AGCD='+''''+@PAGCODE+''''+' OR '+''''+@PAGCODE+'''='''') AND 
		A.DPCD  = B.DPCD AND (A.DPCD='+''''+@PDPCODE+''''+' OR '+''''+@PDPCODE+'''='''') AND A.PUBL='''+@PPUBL+''' AND (A.EDTN='''+@PEDTN+''' or '''+@PEDTN+''' IS NULL OR '''+@PEDTN+''' ='''') AND (B.CITY_CODE='''+@PCITYCD+''' OR '''+@PCITYCD+''' IS NULL or '''+@PCITYCD+''' ='''') AND
        (B.STATE_CODE='''+@PSTATECD+''' OR '''+@PSTATECD+''' IS NULL or '''+@PSTATECD+''' ='''') AND 
        (B.DIST_CODE='''+@PDISTCODE+''' OR '''+@PDISTCODE+''' IS NULL or '''+@PDISTCODE+''' ='''') AND (B.TEHSIL_TALUKA='''+@PTALUKA+''' OR '''+@PTALUKA+''' IS NULL or '''+@PTALUKA+''' ='''') AND 
        (B.BRANCH_CODE='''+@PBRANCH+''' OR '''+@PBRANCH+''' IS NULL or '''+@PBRANCH+''' ='''') AND (B.AG_TYPE='''+@PAGTYPE+''' OR '''+@PAGTYPE+''' IS NULL or '''+@PAGTYPE+''' ='''') AND (B.AG_CLASS='''+@PAGCLASS+''' OR '''+@PAGCLASS+''' IS NULL or '''+@PAGCLASS+''' ='''') AND
        A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE='''+@PEXTRA1+''' OR '''+@PEXTRA1+''' IS NULL or '''+@PEXTRA1+''' ='''') AND 
        A.SUPDATE BETWEEN '''+@VFRDT+''' AND '''+@VTODT+'''    AND A.SUP_COPY>0
        GROUP BY A.COMP_CODE,A.UNIT_CODE,A.PUBL,A.SUPDATE,B.CITY_CODE,B.STATE_CODE,B.COUNTRY_CODE) d
        GROUP BY d.COMP_CODE,d.UNIT_CODE,d.PUBL,d.EDTN,d.CITY_CODE,d.STATE_CODE,d.COUNTRY_CODE
        ORDER BY d.COMP_CODE,d.UNIT_CODE,d.STATE_CODE,d.CITY_CODE,d.EDTN,d.PUBL;'
end
else if @pextra2='C'
begin
	set @pquery='SELECT COMP_CODE,UNIT_CODE,substrING(dbo.cir_get_unit_name(d.comp_code,d.UNIT_CODE),1,50) "UNIT NAME",'''' as "EXTRA",'''' as "EXTRA2",
       ''NA'' "UNIT ONAME",
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
        WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE='''+@PCOMP_CODE+''' AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE='''+@PUNIT_CODE+''' AND
        A.AGCD  = B.AGCD AND (A.AGCD='+''''+@PAGCODE+''''+' OR '+''''+@PAGCODE+'''='''') AND 
		A.DPCD  = B.DPCD AND (A.DPCD='+''''+@PDPCODE+''''+' OR '+''''+@PDPCODE+'''='''') AND A.PUBL='''+@PPUBL+''' AND (A.EDTN='''+@PEDTN+''' or '''+@PEDTN+''' IS NULL OR '''+@PEDTN+''' ='''') AND (B.CITY_CODE='''+@PCITYCD+''' OR '''+@PCITYCD+''' IS NULL or '''+@PCITYCD+''' ='''') AND
        (B.STATE_CODE='''+@PSTATECD+''' OR '''+@PSTATECD+''' IS NULL or '''+@PSTATECD+''' ='''') AND 
        (B.DIST_CODE='''+@PDISTCODE+''' OR '''+@PDISTCODE+''' IS NULL or '''+@PDISTCODE+''' ='''') AND (B.TEHSIL_TALUKA='''+@PTALUKA+''' OR '''+@PTALUKA+''' IS NULL or '''+@PTALUKA+''' ='''') AND 
        (B.BRANCH_CODE='''+@PBRANCH+''' OR '''+@PBRANCH+''' IS NULL or '''+@PBRANCH+''' ='''') AND (B.AG_TYPE='''+@PAGTYPE+''' OR '''+@PAGTYPE+''' IS NULL or '''+@PAGTYPE+''' ='''') AND (B.AG_CLASS='''+@PAGCLASS+''' OR '''+@PAGCLASS+''' IS NULL or '''+@PAGCLASS+''' ='''') AND
        A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE='''+@PEXTRA1+''' OR '''+@PEXTRA1+''' IS NULL or '''+@PEXTRA1+''' ='''') AND 
        A.SUPDATE BETWEEN '''+@VFRDT+''' AND '''+@VTODT+'''    AND A.SUP_COPY>0
        GROUP BY A.COMP_CODE,A.UNIT_CODE,A.SUPDATE,B.CITY_CODE,B.STATE_CODE,B.COUNTRY_CODE) d
        GROUP BY d.COMP_CODE,d.UNIT_CODE,d.EDTN,d.CITY_CODE,d.STATE_CODE,d.COUNTRY_CODE
        ORDER BY d.COMP_CODE,d.UNIT_CODE,d.STATE_CODE,d.CITY_CODE,d.EDTN;'
end
else if @pextra2='B'
begin
	set @pquery='SELECT COMP_CODE,UNIT_CODE,BRANCH_CODE "BRANCH CODE",'''' as "EXTRA"
	,substrING(dbo.cir_get_branch(d.comp_code,d.BRANCH_CODE),1,50) "BRANCH NAME",
       ''NA'' "BRANCH ONAME",
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
        WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE='''+@PCOMP_CODE+''' AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE='''+@PUNIT_CODE+''' AND
        A.AGCD  = B.AGCD AND (A.AGCD='+''''+@PAGCODE+''''+' OR '+''''+@PAGCODE+'''='''') AND 
		A.DPCD  = B.DPCD AND (A.DPCD='+''''+@PDPCODE+''''+' OR '+''''+@PDPCODE+'''='''') AND A.PUBL='''+@PPUBL+''' AND (A.EDTN='''+@PEDTN+''' or '''+@PEDTN+''' IS NULL OR '''+@PEDTN+''' ='''') AND (B.CITY_CODE='''+@PCITYCD+''' OR '''+@PCITYCD+''' IS NULL or '''+@PCITYCD+''' ='''') AND
        (B.STATE_CODE='''+@PSTATECD+''' OR '''+@PSTATECD+''' IS NULL or '''+@PSTATECD+''' ='''') AND 
        (B.DIST_CODE='''+@PDISTCODE+''' OR '''+@PDISTCODE+''' IS NULL or '''+@PDISTCODE+''' ='''') AND (B.TEHSIL_TALUKA='''+@PTALUKA+''' OR '''+@PTALUKA+''' IS NULL or '''+@PTALUKA+''' ='''') AND 
        (B.BRANCH_CODE='''+@PBRANCH+''' OR '''+@PBRANCH+''' IS NULL or '''+@PBRANCH+''' ='''') AND (B.AG_TYPE='''+@PAGTYPE+''' OR '''+@PAGTYPE+''' IS NULL or '''+@PAGTYPE+''' ='''') AND (B.AG_CLASS='''+@PAGCLASS+''' OR '''+@PAGCLASS+''' IS NULL or '''+@PAGCLASS+''' ='''') AND
        A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE='''+@PEXTRA1+''' OR '''+@PEXTRA1+''' IS NULL or '''+@PEXTRA1+''' ='''') AND 
        A.SUPDATE BETWEEN '''+@VFRDT+''' AND '''+@VTODT+'''    AND A.SUP_COPY>0
        GROUP BY A.COMP_CODE,A.UNIT_CODE,B.BRANCH_CODE,A.SUPDATE,B.CITY_CODE,B.STATE_CODE,B.COUNTRY_CODE) d
        GROUP BY d.COMP_CODE,d.UNIT_CODE,d.BRANCH_CODE,d.EDTN,d.CITY_CODE,d.STATE_CODE,d.COUNTRY_CODE
        ORDER BY d.COMP_CODE,d.UNIT_CODE,d.STATE_CODE,d.CITY_CODE,d.EDTN,d.BRANCH_CODE;'
end
else if @pextra2='Z'
begin
	set @pquery='SELECT COMP_CODE,UNIT_CODE,ISNULL(d.ZONE_CODE, ''NA'') "ZONE CODE",'''' as "EXTRA"
	,substrING(isnull(dbo.cir_get_zone_name(COMP_CODE, ZONE_CODE),''NA''),1,50) "ZONE NAME",
       ''NA'' "ZONE ONAME",
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
        WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE='''+@PCOMP_CODE+''' AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE='''+@PUNIT_CODE+''' AND
        A.AGCD  = B.AGCD AND (A.AGCD='+''''+@PAGCODE+''''+' OR '+''''+@PAGCODE+'''='''') AND 
		A.DPCD  = B.DPCD AND (A.DPCD='+''''+@PDPCODE+''''+' OR '+''''+@PDPCODE+'''='''') AND A.PUBL='''+@PPUBL+''' AND (A.EDTN='''+@PEDTN+''' or '''+@PEDTN+''' IS NULL OR '''+@PEDTN+''' ='''') AND (B.CITY_CODE='''+@PCITYCD+''' OR '''+@PCITYCD+''' IS NULL or '''+@PCITYCD+''' ='''') AND
        (B.STATE_CODE='''+@PSTATECD+''' OR '''+@PSTATECD+''' IS NULL or '''+@PSTATECD+''' ='''') AND 
        (B.DIST_CODE='''+@PDISTCODE+''' OR '''+@PDISTCODE+''' IS NULL or '''+@PDISTCODE+''' ='''') AND (B.TEHSIL_TALUKA='''+@PTALUKA+''' OR '''+@PTALUKA+''' IS NULL or '''+@PTALUKA+''' ='''') AND 
        (B.BRANCH_CODE='''+@PBRANCH+''' OR '''+@PBRANCH+''' IS NULL or '''+@PBRANCH+''' ='''') AND (B.AG_TYPE='''+@PAGTYPE+''' OR '''+@PAGTYPE+''' IS NULL or '''+@PAGTYPE+''' ='''') AND (B.AG_CLASS='''+@PAGCLASS+''' OR '''+@PAGCLASS+''' IS NULL or '''+@PAGCLASS+''' ='''') AND
        A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE='''+@PEXTRA1+''' OR '''+@PEXTRA1+''' IS NULL or '''+@PEXTRA1+''' ='''') AND 
        A.SUPDATE BETWEEN '''+@VFRDT+''' AND '''+@VTODT+'''    AND A.SUP_COPY>0
        GROUP BY A.COMP_CODE,A.UNIT_CODE, DBO.cir_get_zone_by_city(B.COMP_CODE,B.city_code,''C'')
        ,A.SUPDATE,B.CITY_CODE,B.STATE_CODE,B.COUNTRY_CODE) d
        GROUP BY d.COMP_CODE,d.UNIT_CODE,d.ZONE_CODE,d.EDTN,d.CITY_CODE,d.STATE_CODE,d.COUNTRY_CODE
        ORDER BY d.COMP_CODE,d.UNIT_CODE,d.STATE_CODE,d.CITY_CODE,d.EDTN,d.ZONE_CODE;'
end
else if @pextra2='S'
begin
	set @pquery='SELECT COMP_CODE,UNIT_CODE,'''' as "EXTRA",'''' as "EXTRA2"
		,isnull(STATE_CODE,''NA'') "STATE CODE",isnull(dbo.CIR_GET_STATE(COMP_CODE,COUNTRY_CODE,STATE_CODE),''NA'') "STATE NAME"
	   ,d.EDTN,dbo.cir_get_edtn_name(COMP_CODE,d.EDTN) "EDITION NAME",dbo.cir_get_edtn_name(COMP_CODE,d.EDTN) "EDITION ONAME",
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
		case (select(day(A.SUPDATE))) when  ''27'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p27,
		case (select(day(A.SUPDATE))) when  ''28'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p28,
		case (select(day(A.SUPDATE))) when  ''29'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p29,
		case (select(day(A.SUPDATE))) when  ''30'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p30,
		case (select(day(A.SUPDATE))) when  ''31'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p31
        FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C
        WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE='''+@PCOMP_CODE+''' AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE='''+@PUNIT_CODE+''' AND
        A.AGCD  = B.AGCD AND (A.AGCD='+''''+@PAGCODE+''''+' OR '+''''+@PAGCODE+'''='''') AND 
		A.DPCD  = B.DPCD AND (A.DPCD='+''''+@PDPCODE+''''+' OR '+''''+@PDPCODE+'''='''') AND A.PUBL='''+@PPUBL+''' AND (A.EDTN='''+@PEDTN+''' or '''+@PEDTN+''' IS NULL OR '''+@PEDTN+''' ='''') AND (B.CITY_CODE='''+@PCITYCD+''' OR '''+@PCITYCD+''' IS NULL or '''+@PCITYCD+''' ='''') AND
        (B.STATE_CODE='''+@PSTATECD+''' OR '''+@PSTATECD+''' IS NULL or '''+@PSTATECD+''' ='''') AND 
        (B.DIST_CODE='''+@PDISTCODE+''' OR '''+@PDISTCODE+''' IS NULL or '''+@PDISTCODE+''' ='''') AND (B.TEHSIL_TALUKA='''+@PTALUKA+''' OR '''+@PTALUKA+''' IS NULL or '''+@PTALUKA+''' ='''') AND 
        (B.BRANCH_CODE='''+@PBRANCH+''' OR '''+@PBRANCH+''' IS NULL or '''+@PBRANCH+''' ='''') AND (B.AG_TYPE='''+@PAGTYPE+''' OR '''+@PAGTYPE+''' IS NULL or '''+@PAGTYPE+''' ='''') AND (B.AG_CLASS='''+@PAGCLASS+''' OR '''+@PAGCLASS+''' IS NULL or '''+@PAGCLASS+''' ='''') AND
        A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE='''+@PEXTRA1+''' OR '''+@PEXTRA1+''' IS NULL or '''+@PEXTRA1+''' ='''') AND 
        A.SUPDATE BETWEEN '''+@VFRDT+''' AND '''+@VTODT+'''    AND A.SUP_COPY>0
        GROUP BY A.COMP_CODE,A.UNIT_CODE,A.SUPDATE,B.CITY_CODE,B.STATE_CODE,B.COUNTRY_CODE) d
        GROUP BY d.COMP_CODE,d.UNIT_CODE,d.EDTN,d.CITY_CODE,d.STATE_CODE,d.COUNTRY_CODE
        ORDER BY d.COMP_CODE,d.UNIT_CODE,d.STATE_CODE,d.CITY_CODE,d.EDTN;'
end
else if @pextra2='D'
begin
	set @pquery='SELECT COMP_CODE,UNIT_CODE,'''' as "EXTRA",
	ISNULL(DIST_CODE, ''NA'') DIST_CODE
	,substrING(isnull(dbo.cir_get_dist(COMP_CODE,STATE_CODE, DIST_CODE),''NA''),1,50) "DIST NAME",
       substring(isnull( dbo.cir_get_name_cir_district(COMP_CODE,DIST_CODE,2,'''','''',''''),''NA''),1,50) "DIST ONAME",
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
        WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE='''+@PCOMP_CODE+''' AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE='''+@PUNIT_CODE+''' AND
        A.AGCD  = B.AGCD AND (A.AGCD='+''''+@PAGCODE+''''+' OR '+''''+@PAGCODE+'''='''') AND 
		A.DPCD  = B.DPCD AND (A.DPCD='+''''+@PDPCODE+''''+' OR '+''''+@PDPCODE+'''='''') AND A.PUBL='''+@PPUBL+''' AND (A.EDTN='''+@PEDTN+''' or '''+@PEDTN+''' IS NULL OR '''+@PEDTN+''' ='''') AND (B.CITY_CODE='''+@PCITYCD+''' OR '''+@PCITYCD+''' IS NULL or '''+@PCITYCD+''' ='''') AND
        (B.STATE_CODE='''+@PSTATECD+''' OR '''+@PSTATECD+''' IS NULL or '''+@PSTATECD+''' ='''') AND 
        (B.DIST_CODE='''+@PDISTCODE+''' OR '''+@PDISTCODE+''' IS NULL or '''+@PDISTCODE+''' ='''') AND (B.TEHSIL_TALUKA='''+@PTALUKA+''' OR '''+@PTALUKA+''' IS NULL or '''+@PTALUKA+''' ='''') AND 
        (B.BRANCH_CODE='''+@PBRANCH+''' OR '''+@PBRANCH+''' IS NULL or '''+@PBRANCH+''' ='''') AND (B.AG_TYPE='''+@PAGTYPE+''' OR '''+@PAGTYPE+''' IS NULL or '''+@PAGTYPE+''' ='''') AND (B.AG_CLASS='''+@PAGCLASS+''' OR '''+@PAGCLASS+''' IS NULL or '''+@PAGCLASS+''' ='''') AND
        A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE='''+@PEXTRA1+''' OR '''+@PEXTRA1+''' IS NULL or '''+@PEXTRA1+''' ='''') AND 
        A.SUPDATE BETWEEN '''+@VFRDT+''' AND '''+@VTODT+'''    AND A.SUP_COPY>0
        GROUP BY A.COMP_CODE,A.UNIT_CODE, B.DIST_CODE,A.SUPDATE,B.CITY_CODE,B.STATE_CODE,B.COUNTRY_CODE) d
        GROUP BY d.COMP_CODE,d.UNIT_CODE,d.DIST_CODE,d.EDTN,d.CITY_CODE,d.STATE_CODE,d.COUNTRY_CODE
        ORDER BY d.COMP_CODE,d.UNIT_CODE,d.STATE_CODE,d.CITY_CODE,d.EDTN,d.DIST_CODE'
end
else
begin
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
        A.AGCD  = B.AGCD AND (A.AGCD='+''''+@PAGCODE+''''+' OR '+''''+@PAGCODE+'''='''') AND 
		A.DPCD  = B.DPCD AND (A.DPCD='+''''+@PDPCODE+''''+' OR '+''''+@PDPCODE+'''='''') AND A.PUBL='''+@PPUBL+''' AND (A.EDTN='''+@PEDTN+''' or '''+@PEDTN+''' IS NULL OR '''+@PEDTN+''' ='''') AND (B.CITY_CODE='''+@PCITYCD+''' OR '''+@PCITYCD+''' IS NULL or '''+@PCITYCD+''' ='''') AND
        (B.STATE_CODE='''+@PSTATECD+''' OR '''+@PSTATECD+''' IS NULL or '''+@PSTATECD+''' ='''') AND 
        (B.DIST_CODE='''+@PDISTCODE+''' OR '''+@PDISTCODE+''' IS NULL or '''+@PDISTCODE+''' ='''') AND (B.TEHSIL_TALUKA='''+@PTALUKA+''' OR '''+@PTALUKA+''' IS NULL or '''+@PTALUKA+''' ='''') AND 
        (B.BRANCH_CODE='''+@PBRANCH+''' OR '''+@PBRANCH+''' IS NULL or '''+@PBRANCH+''' ='''') AND (B.AG_TYPE='''+@PAGTYPE+''' OR '''+@PAGTYPE+''' IS NULL or '''+@PAGTYPE+''' ='''') AND (B.AG_CLASS='''+@PAGCLASS+''' OR '''+@PAGCLASS+''' IS NULL or '''+@PAGCLASS+''' ='''') AND
        A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE='''+@PEXTRA1+''' OR '''+@PEXTRA1+''' IS NULL or '''+@PEXTRA1+''' ='''') AND 
        A.SUPDATE BETWEEN '''+@VFRDT+''' AND '''+@VTODT+'''    AND A.SUP_COPY>0
        GROUP BY A.COMP_CODE,A.UNIT_CODE,A.AGCD,A.DPCD,A.SUPDATE,B.CITY_CODE,B.STATE_CODE,B.COUNTRY_CODE) d
        GROUP BY d.COMP_CODE,d.UNIT_CODE,d.AGCD,d.DPCD,d.EDTN,d.CITY_CODE,d.STATE_CODE,d.COUNTRY_CODE
        ORDER BY d.COMP_CODE,d.UNIT_CODE,d.STATE_CODE,d.CITY_CODE,d.EDTN,d.AGCD,d.DPCD;'
end

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
        A.AGCD  = B.AGCD AND (A.AGCD='+''''+@PAGCODE+''''+' OR '+''''+@PAGCODE+'''='''') AND 
		A.DPCD  = B.DPCD AND (A.DPCD='+''''+@PDPCODE+''''+' OR '+''''+@PDPCODE+'''='''') AND A.PUBL='''+@PPUBL+''' AND (A.EDTN='''+@PEDTN+''' OR '''+@PEDTN+''' IS NULL or '''+@PEDTN+'''='''') AND (B.CITY_CODE='''+@PCITYCD+''' OR '''+@PCITYCD+''' IS NULL or '''+@PCITYCD+'''='''') AND
        (B.STATE_CODE='''+@PSTATECD+''' OR '''+@PSTATECD+''' IS NULL or '''+@PSTATECD+'''='''') AND 
        (B.DIST_CODE='''+@PDISTCODE+''' OR '''+@PDISTCODE+''' IS NULL or '''+@PDISTCODE+''' ='''') AND (B.TEHSIL_TALUKA='''+@PTALUKA+''' OR '''+@PTALUKA+''' IS NULL or '''+@PTALUKA+''' ='''') AND 
        (B.BRANCH_CODE='''+@PBRANCH+''' OR '''+@PBRANCH+''' IS NULL or '''+@PBRANCH+''' ='''') AND (B.AG_TYPE='''+@PAGTYPE+''' OR '''+@PAGTYPE+''' IS NULL or '''+@PAGTYPE+''' ='''') AND (B.AG_CLASS='''+@PAGCLASS+''' OR '''+@PAGCLASS+''' IS NULL or '''+@PAGCLASS+''' ='''') AND
        A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE='''+@PEXTRA1+''' OR '''+@PEXTRA1+''' IS NULL or '''+@PEXTRA1+''' ='''') AND 
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
        A.AGCD  = B.AGCD AND (A.AGCD='+''''+@PAGCODE+''''+' OR '+''''+@PAGCODE+'''='''') AND 
		A.DPCD  = B.DPCD AND (A.DPCD='+''''+@PDPCODE+''''+' OR '+''''+@PDPCODE+'''='''') AND A.PUBL='''+@PPUBL+''' AND (A.EDTN='''+@PEDTN+''' OR '''+@PEDTN+''' IS NULL or '''+@PEDTN+'''='''') AND (B.CITY_CODE='''+@PCITYCD+''' OR '''+@PCITYCD+''' IS NULL or '''+@PCITYCD+'''='''') AND
        (B.STATE_CODE='''+@PSTATECD+''' OR '''+@PSTATECD+''' IS NULL OR '''+@PSTATECD+'''='''') AND 
        (B.DIST_CODE='''+@PDISTCODE+''' OR '''+@PDISTCODE+''' IS NULL or '''+@PDISTCODE+''' ='''') AND (B.TEHSIL_TALUKA='''+@PTALUKA+''' OR '''+@PTALUKA+''' IS NULL or '''+@PTALUKA+''' ='''') AND 
        (B.BRANCH_CODE='''+@PBRANCH+''' OR '''+@PBRANCH+''' IS NULL or '''+@PBRANCH+''' ='''') AND (B.AG_TYPE='''+@PAGTYPE+''' OR '''+@PAGTYPE+''' IS NULL or '''+@PAGTYPE+''' ='''') AND (B.AG_CLASS='''+@PAGCLASS+''' OR '''+@PAGCLASS+''' IS NULL or '''+@PAGCLASS+''' ='''') AND
        A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE='''+@PEXTRA1+''' OR '''+@PEXTRA1+''' IS NULL or '''+@PEXTRA1+''' ='''') AND 
        A.SUPDATE BETWEEN '''+@VFRDT+''' AND '''+@VTODT+''' AND isnull(A.SUP_COPY,0)>0
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


****************************************************************************************************************************



ALTER PROCEDURE [dbo].[cir_rep_supply_cir_rep_day_daybook]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@ppubl                                    VARCHAR(20) ,
	@pedtn                                    VARCHAR(20) ,
	@pcitycd                                  VARCHAR(20) ,
	@pstatecd                                 VARCHAR(20) ,
	@pmonth                                   VARCHAR(20) ,
	@pyear                                    VARCHAR(20) ,
	@pday                                     VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pbranch								  varchar(20),
    @pdistcode								  varchar(20),
    @ptaluka								  varchar(20),
    @pagtype								  varchar(20),
    @pagclass								  varchar(20),
    @pagcode								  varchar(20),
    @pdpcode								  varchar(20),
    @pextra1								  varchar(200),
    @pextra2								  varchar(200),
    @pextra3								  varchar(200),
    @pextra4								  varchar(200),
    @pextra5								  varchar(200) 
AS 
	DECLARE @vquery1                                  VARCHAR(8000) 	
	DECLARE @vquery2                                  VARCHAR(8000) 	
	DECLARE @vquery3                                  VARCHAR(8000) 
	DECLARE @vdaysup                                  VARCHAR(2000) 
	DECLARE @vtotsup                                  VARCHAR(1000) 
	DECLARE @v_dt                                     DATETIME 
	DECLARE @v_day                                    VARCHAR(3) 
	DECLARE @v_cnt                                    INT                           
	SET @v_cnt = 0 


    DECLARE @vday11                                    VARCHAR(80)
    DECLARE @vdt11                                     VARCHAR(80) 




	DECLARE c1 cursor LOCAL FOR 

	SELECT dt, UPPER(DATENAME(WEEKDAY, dt)) supply_day	FROM  cir_temp_dt 	ORDER BY sqno, dt 
	


   	DECLARE @vfrdt         VARCHAR(20)
	DECLARE @vtodt         VARCHAR(20)
   	DECLARE @vtodt1         VARCHAR(20)
	DECLAre @pquery         varchar(8000)
	DECLAre @pquery1         varchar(8000)
	DECLAre @pquery2         varchar(8000)
    

print (@pday)

if(@pday = 'sun')
begin
   set  @pday = 'Sunday'
end  
else if(@pday = 'mon')
begin
   set  @pday = 'Monday'
end  
else if(@pday = 'tue')
begin
   set  @pday = 'Tuesday'
end  
else if(@pday = 'wed')
begin
   set  @pday = 'Wednesday'
end  
else if(@pday = 'thu')
begin
   set  @pday = 'Thursday'
end  
else if(@pday = 'fri')
begin
   set  @pday = 'Friday'
end  
else if(@pday = 'sat')
begin
   set  @pday = 'Saturday'
end  
print (@pday)


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




		DELETE FROM   cir_temp_dt    
		
	
		WHILE (0 = 0) 
		BEGIN 
					IF @v_dt >= @vtodt 
					BEGIN 
						    BREAK

					END
					ELSE
					BEGIN 
							IF @v_dt is null 
							BEGIN 
								    SET @v_dt  = @vfrdt 
							END
							ELSE
							BEGIN 
							     	SET @v_dt  = @v_dt + 1 
							END
		   
					END
		   
					IF UPPER(DATENAME(WEEKDAY, @v_dt))= UPPER(@pday)
					BEGIN 
						    INSERT INTO  cir_temp_dt   ( sqno , dt )   VALUES 		( 1 , @v_dt )  
						
					END
					ELSE
					BEGIN 
						    INSERT INTO  cir_temp_dt   ( sqno , dt )   VALUES 		( 2 , 	@v_dt )  
						
					END
   
		
		END 
		
	
	
		OPEN c1 
		
        fetch NEXT FROM c1 INTO @vdt11,@vday11
		
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN 
		 
		

			SET @v_cnt  = @v_cnt + 1 
			IF @vquery1 is null 
			BEGIN 
                	  PRINT('shachi11') 
 PRINT(@vdt11) 
				SET @vquery1  = 'case (select(day(A.SUPDATE)))  when day('''+@vdt11+''') then SUM(isnull(A.SUP_COPY,0)) end P'+dbo.fnPadLeft('0',2,@v_cnt);
             --	print(@v_cnt)

                SET @vdaysup  = 'SUM(isnull(P'+ dbo.fnPadLeft('0',2,@v_cnt)+',0)) AS ' + '"' + dbo.fnPadLeft('0',2,@v_cnt) + '"';
              
             --   print(@vdaysup)

		        SET @vtotsup  = 'isnull(P'+ dbo.fnPadLeft ('0',2,@v_cnt)+',0)';
 --print(@vtotsup)
               
			END
			ELSE
			BEGIN 
				SET @vquery1  = @vquery1 + ',' + 'case (select(day(A.SUPDATE)))  when day('''+@vdt11+''') then SUM(isnull(A.SUP_COPY,0)) end P'+dbo.fnPadLeft('0',2,@v_cnt);
 
				SET @vdaysup  = @vdaysup + ',' + 'SUM(isnull(P'+ dbo.fnPadLeft('0',2,@v_cnt)+',0)) AS ' + '"' + dbo.fnPadLeft('0',2,@v_cnt) + '"';
 
				SET @vtotsup  = @vtotsup + '+' + 'isnull(P'+ dbo.fnPadLeft ('0',2,@v_cnt)+',0)';

			END
   
		fetch NEXT FROM c1 INTO @vdt11,@vday11	
		END 
		
		
		close c1

--print(@vquery1)

	
		SET @vtotsup  = 'SUM(' + @vtotsup + ')' 

		
		SET @vquery3  = 'SELECT COMP_CODE,UNIT_CODE,AGCD "AGENCY CODE",DPCD "AGENCY SUBCODE",substring(dbo.cir_get_agency(comp_code,unit_code,agcd,dpcd),1,50) "AGENCY NAME",substring(dbo.cir_get_name_cir_agname(comp_code,unit_code,agcd,dpcd,2,' + '''' + @pdateformat + '''' + ','''',''''),1,50) "AGENCY ONAME",         EDTN,dbo.CIR_GET_EDTN_NAME(COMP_CODE,EDTN) "EDITION NAME",isnull(dbo.CIR_GET_NAME_CIR_EDTN(COMP_CODE,'''',EDTN,2,' + '''' + @pdateformat + '''' + ','''',''''),''NA'') "EDITION ONAME",         isnull(CITY_CODE,''NA'') "CITY CODE",isnull(dbo.CIR_GET_CITY(COMP_CODE,CITY_CODE),''NA'') "CITY NAME",isnull(dbo.CIR_GET_NAME_CIR_CITY(COMP_CODE,CITY_CODE,2,' + '''' + @pdateformat + '''' + ','''',''''),''NA'') "CITY ONAME",         isnull(STATE_CODE,''NA'') "STATE CODE",isnull(dbo.CIR_GET_STATE(COMP_CODE,COUNTRY_CODE,STATE_CODE),''NA'') "STATE NAME",COUNTRY_CODE "COUNTRY CODE",' + @vdaysup + ',' + @vtotsup + 'AS "TOTAL"' + ' FROM (SELECT     A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.AGCD AGCD,A.DPCD DPCD,A.EDTN EDTN,B.CITY_CODE,B.STATE_CODE STATE_CODE,B.COUNTRY_CODE COUNTRY_CODE,' + @vquery1 
		SET @vquery2  = ' FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C  WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE=''' + @pcomp_code + ''' AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE=''' + @punit_code + ''' AND A.AGCD=B.AGCD AND A.DPCD=B.DPCD AND A.PUBL=''' + @ppubl + ''' AND (A.EDTN=''' + @pedtn + ''' OR''' + @pedtn + ''' IS NULL ' + ' OR ''' + @pedtn + ''' = ''''  ) AND (B.CITY_CODE=''' + @pcitycd + ''' OR''' + @pcitycd + ''' IS NULL ' + ' OR ''' + @pcitycd + ''' = '''') AND (B.STATE_CODE=''' + @pstatecd + ''' OR''' + @pstatecd + ''' IS NULL ' + ' OR ''' + @pstatecd + ''' = '''') AND (B.DIST_CODE='''+@PDISTCODE+''' OR '''+@PDISTCODE+''' IS NULL' + ' OR ''' + @PDISTCODE + ''' = '''') AND 
        (B.TEHSIL_TALUKA='''+@PTALUKA+''' OR '''+@PTALUKA+''' IS NULL'+ ' OR ''' + @PDISTCODE + ''' = '''') AND (B.BRANCH_CODE='''+@PBRANCH+''' OR '''+@PBRANCH+''' IS NULL' + ' OR ''' + @PBRANCH + ''' = '''') AND
        (B.AG_TYPE='''+@PAGTYPE+''' OR '''+@PAGTYPE+''' IS NULL '+ ' OR ''' + @PAGTYPE + ''' = '''') AND (B.AG_CLASS='''+@PAGCLASS+''' OR '''+@PAGCLASS+''' IS NULL '+ ' OR ''' + @PAGCLASS + ''' = '''') AND A.SUP_TYPE_CODE=C.SUP_TY_CODE AND  A.SUPDATE BETWEEN''' + @vfrdt + ''' AND''' + @vtodt + ''' AND isnull(A.SUP_COPY,0)>0 and  upper (CONVERT(VARCHAR(20) , DATENAME(WEEKDAY, A.SUPDATE),20)) =upper(''' + @pday + ''')          GROUP BY A.COMP_CODE,A.UNIT_CODE,A.AGCD,A.DPCD,A.SUPDATE,A.EDTN,B.CITY_CODE,B.STATE_CODE,B.COUNTRY_CODE) m         GROUP BY m.COMP_CODE,m.UNIT_CODE,m.AGCD,m.DPCD,m.EDTN,m.CITY_CODE,m.STATE_CODE,m.COUNTRY_CODE ORDER BY m.COMP_CODE,m.UNIT_CODE,m.STATE_CODE,m.CITY_CODE,m.EDTN,m.AGCD,m.DPCD' 
	
print (@vquery3 + @vquery2)

		EXEC (@vquery3 + @vquery2)
		
	
		SET @vquery3  = 'SELECT COMP_CODE,UNIT_CODE,isnull(STATE_CODE,''NA'') "STATE CODE",isnull(dbo.CIR_GET_STATE(COMP_CODE,COUNTRY_CODE,STATE_CODE),''NA'') "STATE NAME",COUNTRY_CODE "COUNTRY CODE",' + @vdaysup + ',' + @vtotsup + 'AS "TOTAL"' + ' FROM (SELECT     A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,B.STATE_CODE STATE_CODE,B.COUNTRY_CODE COUNTRY_CODE,' + @vquery1 
		SET @vquery2  = '    FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C          WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE=''' + @pcomp_code + ''' AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE=''' + @punit_code + ''' AND          A.AGCD=B.AGCD AND A.DPCD=B.DPCD AND A.PUBL=''' + @ppubl + ''' AND (A.EDTN=''' + @pedtn + ''' OR''' + @pedtn + ''' IS NULL ' + ' OR ''' + @pedtn + ''' = '''') AND (B.CITY_CODE=''' + @pcitycd + ''' OR''' + @pcitycd + ''' IS NULL ' + ' OR ''' + @pcitycd + ''' = '''') AND          (B.STATE_CODE=''' + @pstatecd + ''' OR''' + @pstatecd + ''' IS NULL ' + ' OR ''' + @pstatecd + ''' = '''') AND 
		(B.DIST_CODE='''+@PDISTCODE+''' OR '''+@PDISTCODE+''' IS NULL' + ' OR ''' + @PDISTCODE + ''' = '''') AND 
        (B.TEHSIL_TALUKA='''+@PTALUKA+''' OR '''+@PTALUKA+''' IS NULL'+ ' OR ''' + @PDISTCODE + ''' = '''') AND (B.BRANCH_CODE='''+@PBRANCH+''' OR '''+@PBRANCH+''' IS NULL' + ' OR ''' + @PBRANCH + ''' = '''') AND
        (B.AG_TYPE='''+@PAGTYPE+''' OR '''+@PAGTYPE+''' IS NULL '+ ' OR ''' + @PAGTYPE + ''' = '''') AND (B.AG_CLASS='''+@PAGCLASS+''' OR '''+@PAGCLASS+''' IS NULL '+ ' OR ''' + @PAGCLASS + ''' = '''') and A.SUP_TYPE_CODE=C.SUP_TY_CODE AND          A.SUPDATE BETWEEN''' + @vfrdt + ''' AND''' + @vtodt + ''' AND isnull(A.SUP_COPY,0)>0 AND upper (CONVERT(VARCHAR(20) , DATENAME(WEEKDAY, A.SUPDATE),20))=upper(''' + @pday + ''')          GROUP BY A.COMP_CODE,A.UNIT_CODE,A.SUPDATE,B.STATE_CODE,B.COUNTRY_CODE) o         GROUP BY o.COMP_CODE,o.UNIT_CODE,o.STATE_CODE,o.COUNTRY_CODE ORDER BY o.COMP_CODE,o.UNIT_CODE,o.STATE_CODE' 
		
	
        EXEC (@vquery3 + @vquery2)

		SET @vquery3  = 'SELECT COMP_CODE,UNIT_CODE,' + @vdaysup + ',' + @vtotsup + 'AS "TOTAL"' + ' FROM (SELECT     A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,' + @vquery1 
		SET @vquery2  = ' FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C   WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE=''' + @pcomp_code + ''' AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE=''' + @punit_code + ''' AND          A.AGCD=B.AGCD AND A.DPCD=B.DPCD AND A.PUBL=''' + @ppubl + ''' AND (A.EDTN=''' + @pedtn + ''' OR''' + @pedtn + ''' IS NULL ' + ' OR ''' + @pedtn + ''' = '''') AND (B.CITY_CODE=''' + @pcitycd + ''' OR''' + @pcitycd + ''' IS NULL ' + ' OR ''' + @pcitycd + ''' = '''') AND          (B.STATE_CODE=''' + @pstatecd + ''' OR''' + @pstatecd + ''' IS NULL ' + ' OR ''' + @pstatecd + ''' = '''') AND (B.DIST_CODE='''+@PDISTCODE+''' OR '''+@PDISTCODE+''' IS NULL' + ' OR ''' + @PDISTCODE + ''' = '''') AND 
        (B.TEHSIL_TALUKA='''+@PTALUKA+''' OR '''+@PTALUKA+''' IS NULL'+ ' OR ''' + @PDISTCODE + ''' = '''') AND (B.BRANCH_CODE='''+@PBRANCH+''' OR '''+@PBRANCH+''' IS NULL' + ' OR ''' + @PBRANCH + ''' = '''') AND
        (B.AG_TYPE='''+@PAGTYPE+''' OR '''+@PAGTYPE+''' IS NULL '+ ' OR ''' + @PAGTYPE + ''' = '''') AND (B.AG_CLASS='''+@PAGCLASS+''' OR '''+@PAGCLASS+''' IS NULL '+ ' OR ''' + @PAGCLASS + ''' = '''') and A.SUP_TYPE_CODE=C.SUP_TY_CODE AND          A.SUPDATE BETWEEN''' + @vfrdt + ''' AND''' + @vtodt + ''' AND isnull(A.SUP_COPY,0)>0 AND upper (CONVERT(VARCHAR(20) , DATENAME(WEEKDAY, A.SUPDATE),20))=upper(''' + @pday + ''')          GROUP BY A.COMP_CODE,A.UNIT_CODE,A.SUPDATE)  q        GROUP BY q.COMP_CODE,q.UNIT_CODE   ORDER BY q.COMP_CODE,q.UNIT_CODE' 
		
	
   EXEC (@vquery3 + @vquery2)	
 DEALLOCATE c1



****************************************************************************************************************************


ALTER PROCEDURE [dbo].[cir_rep_supply_cir_route_supply_variance_multiple_p]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@ppublication                             VARCHAR(20) ,
	@pmainedtn                                VARCHAR(20) ,
	@pedtn                                    VARCHAR(20) ,
	@proute                                   VARCHAR(20) ,
	@pfirstdate                               VARCHAR(20) ,
	@pseconddate                              VARCHAR(20) ,
	@pthirddate                               VARCHAR(20) ,
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
	DECLARE @vthirddate                               DATETIME 
Begin		
	SET @vfirstdate  =  dbo.convert_user_date('/',@pfirstdate,@pdateformat)
	SET @vseconddate  = dbo.convert_user_date('/',@pseconddate,@pdateformat)
	SET @vthirddate  = dbo.convert_user_date('/',@pthirddate,@pdateformat)
	print(@vfirstdate)
	print(@vseconddate)
	print(@vthirddate)

	If upper(@pextra1)='U' Begin
         select x.comp_code "COMP CODE",x.agcd "AGENCY CODE",x.dpcd "AGENCY SUB CODE",x.ag_name "AGENCY NAME",x.ag_name_oth_lang "AGENCY OTHER LANG",
         dbo.cir_get_city(x.comp_code,x.city_code) "CITY NAME",
         x.route_code "ROUTE CODE",x.route_name "ROUTE NAME",x.route_name_oth_lang "ROUTE NAME OTHER LANG"
         ,sum(x.first_sup) "FIRST SUPPLY",sum(x.second_sup) "SECOND SUPPLY",sum(x.third_sup) "THIRD SUPPLY",
         -ISNULL(sum(x.first_sup),0) + ISNULL(sum(x.second_sup),0) as "VARIANCE_A-B",
         - ISNULL(sum(x.first_sup),0) + ISNULL(sum(x.third_sup),0) as "VARIANCE_A-C",
        
        CASE SUM(x.first_sup) WHEN 0 THEN 100 
		ELSE ROUND(((ISNULL(SUM(x.second_sup), 0) - ISNULL(SUM(x.first_sup), 0)) * 100) / CASE sign(SUM(x.second_sup) - SUM(x.first_sup)) WHEN - 1 THEN SUM(x.first_sup)ELSE SUM(x.second_sup)END, 2) 
		END "PERCENT_VARIANCE_A-B",		
		
		CASE SUM(x.first_sup) WHEN 0 THEN 100 
		ELSE ROUND(((ISNULL(SUM(x.third_sup), 0) - ISNULL(SUM(x.first_sup), 0)) * 100) / CASE sign(SUM(x.third_sup) - SUM(x.first_sup)) WHEN - 1 THEN SUM(x.first_sup)ELSE SUM(x.third_sup)END, 2) 
		END "PERCENT_VARIANCE_A-C",
		
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
                                 (cir_dbksup.sup_type_code = @pextra2 or @pextra2 is null or @pextra2='')) second_sup,
                      (select isnull(sum(sup_copy),0) from cir_dbksup
                           where comp_code    =    @pcomp_code and unit_code =    @punit_code and
                                 publ         =    @ppublication and (edtn   =    @pedtn or @pedtn is null or @pedtn='') and
                                 supdate         = @vthirddate and cir_dbksup.agcd =    a.agcd and
                                 cir_dbksup.dpcd = a.dpcd and cir_dbksup.route_code =  a.route_code and
                                 cir_dbksup.publ = a.publ and cir_dbksup.edtn =  a.edtn and
                                 (cir_dbksup.route_code= @proute or @proute is null or @proute='') and
                                 cir_dbksup.edtn in(select distinct edtn from cir_edtn_mast where comp_code=@pcomp_code and (edtn = @pedtn or @pedtn is null or @pedtn='') and (main_edtn=@pmainedtn or @pmainedtn is null or @pmainedtn='')) and
                                 (cir_dbksup.sup_type_code = @pextra2 or @pextra2 is null or @pextra2='')) third_sup
                     from cir_dbksup a,cir_route_mast b,cir_agmast c
                     where a.comp_code=@pcomp_code and a.comp_code=b.comp_code and a.comp_code=c.comp_code and
                           a.unit_code=@punit_code and a.unit_code=b.unit and a.unit_code=c.unit and
                           (a.supdate = @vfirstdate or a.supdate = @vseconddate or a.supdate = @vthirddate ) and
                           a.agcd=c.agcd and a.dpcd=c.dpcd and                           
                           (a.route_code=@proute or @proute is null or @proute='') and a.route_code=b.route_code 
                           and (a.AGENCY_TY_CODE=@pextra3 or @pextra3 is null or @pextra3='')
                           and (c.AG_CLASS=@pextra4 or @pextra4 is null or @pextra4='')
                           and (isnull(final_supply_flag,'N') = @pextra5  or @pextra5 is null or @pextra5='')  
                           ) x
                     where isnull(x.second_sup,0)-isnull(x.first_sup,0)<>0
                           group by x.comp_code,x.unit_code,x.agcd,x.dpcd,x.ag_name,x.ag_name_oth_lang,x.city_code,x.route_code,x.route_name,x.route_name_oth_lang,x.station_code,x.branch_code
                           order by comp_code,route_code,ag_name
		End
        else	Begin
				select x.comp_code "COMP CODE",x.agcd "AGENCY CODE",x.dpcd "AGENCY SUB CODE",x.ag_name "AGENCY NAME",x.ag_name_oth_lang "AGENCY OTHER LANG",
				x.route_code "ROUTE CODE",x.route_name "ROUTE NAME",x.route_name_oth_lang "ROUTE NAME OTHER LANG",sum(x.first_sup) "FIRST SUPPLY",sum(x.second_sup) "SECOND SUPPLY",
				sum(x.third_sup) "THIRD SUPPLY",
           -ISNULL(sum(x.first_sup),0) + ISNULL(sum(x.second_sup),0) as "VARIANCE_A-B",
         - ISNULL(sum(x.first_sup),0) + ISNULL(sum(x.third_sup),0) as "VARIANCE_A-C",
        
        CASE SUM(x.first_sup) WHEN 0 THEN 100 
		ELSE ROUND(((ISNULL(SUM(x.second_sup), 0) - ISNULL(SUM(x.first_sup), 0)) * 100) / CASE sign(SUM(x.second_sup) - SUM(x.first_sup)) WHEN - 1 THEN SUM(x.first_sup)ELSE SUM(x.second_sup)END, 2) 
		END "PERCENT_VARIANCE_A-B",		
		
		CASE SUM(x.first_sup) WHEN 0 THEN 100 
		ELSE ROUND(((ISNULL(SUM(x.third_sup), 0) - ISNULL(SUM(x.first_sup), 0)) * 100) / CASE sign(SUM(x.third_sup) - SUM(x.first_sup)) WHEN - 1 THEN SUM(x.first_sup)ELSE SUM(x.third_sup)END, 2) 
		END "PERCENT_VARIANCE_A-C",
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
                                         (cir_dbksup.sup_type_code = @pextra2 or @pextra2 is null or @pextra2='')) second_sup,
                             (select isnull(sum(sup_copy),0) from cir_dbksup
                                   where comp_code    =    @pcomp_code and unit_code =    @punit_code and
                                         publ         =    @ppublication and (edtn   =    @pedtn or @pedtn is null or @pedtn='') and
                                         supdate         = @vthirddate and cir_dbksup.agcd =    a.agcd and
                                         cir_dbksup.dpcd = a.dpcd and cir_dbksup.route_code =  a.route_code and
                                         cir_dbksup.publ = a.publ and cir_dbksup.edtn =  a.edtn and
                                         (cir_dbksup.route_code= @proute or @proute is null or @proute='') and
                                         cir_dbksup.edtn in(select distinct edtn from cir_edtn_mast where comp_code=@pcomp_code and (edtn = @pedtn or @pedtn is null or @pedtn='') and (main_edtn=@pmainedtn or @pmainedtn is null or @pmainedtn='')) and
                                         (cir_dbksup.sup_type_code = @pextra2 or @pextra2 is null or @pextra2='')) third_sup
                             from cir_dbksup a,cir_route_mast b,cir_agmast c
                             where a.comp_code=@pcomp_code and a.comp_code=b.comp_code and a.comp_code=c.comp_code and
                                   a.unit_code=@punit_code and a.unit_code=b.unit and a.unit_code=c.unit and
                                   (a.supdate = @vfirstdate or a.supdate = @vseconddate or a.supdate = @vthirddate ) and
                                   a.agcd=c.agcd and a.dpcd=c.dpcd and
                                   (a.route_code=@proute or @proute is null or @proute='') and a.route_code=b.route_code 
                                   and (a.AGENCY_TY_CODE=@pextra3 or @pextra3 is null or @pextra3='')
								   and (c.AG_CLASS=@pextra4 or @pextra4 is null or @pextra4='')
								   and (isnull(final_supply_flag,'N') = @pextra5  or @pextra5 is null or @pextra5='')  
								   )x
                             where isnull(x.second_sup,0)-isnull(x.first_sup,0)<>0
                                   group by x.comp_code,x.unit_code,x.agcd,x.dpcd,x.ag_name,x.ag_name_oth_lang,x.city_code,x.route_code,
									x.route_name,x.route_name_oth_lang,x.station_code,x.branch_code
                                   order by comp_code,route_code,ag_name
        End
        
        If upper(@pextra1)='U' Begin
				---route wise total
        select x.comp_code "COMP CODE",x.route_code "ROUTE CODE",x.route_name "ROUTE NAME",x.route_name_oth_lang "ROUTE NAME OTHER LANG",
		sum(x.first_sup) "FIRST SUPPLY",sum(x.second_sup) "SECOND SUPPLY"
		,sum(x.third_sup) "THIRD SUPPLY",
          -ISNULL(sum(x.first_sup),0) + ISNULL(sum(x.second_sup),0) as "VARIANCE_A-B",
         - ISNULL(sum(x.first_sup),0) + ISNULL(sum(x.third_sup),0) as "VARIANCE_A-C",
        
        CASE SUM(x.first_sup) WHEN 0 THEN 100 
		ELSE ROUND(((ISNULL(SUM(x.second_sup), 0) - ISNULL(SUM(x.first_sup), 0)) * 100) / CASE sign(SUM(x.second_sup) - SUM(x.first_sup)) WHEN - 1 THEN SUM(x.first_sup)ELSE SUM(x.second_sup)END, 2) 
		END "PERCENT_VARIANCE_A-B",		
		
		CASE SUM(x.first_sup) WHEN 0 THEN 100 
		ELSE ROUND(((ISNULL(SUM(x.third_sup), 0) - ISNULL(SUM(x.first_sup), 0)) * 100) / CASE sign(SUM(x.third_sup) - SUM(x.first_sup)) WHEN - 1 THEN SUM(x.first_sup)ELSE SUM(x.third_sup)END, 2) 
		END "PERCENT_VARIANCE_A-C" from
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
                                 (cir_dbksup.sup_type_code = @pextra2 or @pextra2 is null or @pextra2='')) second_sup,
                     (select isnull(sum(sup_copy),0) from cir_dbksup
                           where comp_code    =    @pcomp_code and unit_code =    @punit_code and
                                 publ         =    @ppublication and (edtn   =    @pedtn or @pedtn is null or @pedtn='') and
                                 supdate         = @vthirddate and cir_dbksup.agcd =    a.agcd and
                                 cir_dbksup.dpcd = a.dpcd and cir_dbksup.route_code =  a.route_code and
                                 cir_dbksup.publ = a.publ and cir_dbksup.edtn =  a.edtn and
                                 (cir_dbksup.route_code= @proute or @proute is null or @proute='') and
                                 cir_dbksup.edtn in(select distinct edtn from cir_edtn_mast where comp_code=@pcomp_code and (edtn = @pedtn or @pedtn is null  or @pedtn='') and 
								(main_edtn=@pmainedtn or @pmainedtn is null  or @pmainedtn='')) and
                                 (cir_dbksup.sup_type_code = @pextra2 or @pextra2 is null or @pextra2='')) third_sup
                     from cir_dbksup a,cir_route_mast b,cir_agmast c
                     where a.comp_code=@pcomp_code and a.comp_code=b.comp_code and a.comp_code=c.comp_code and
                           a.unit_code=@punit_code and a.unit_code=b.unit and a.unit_code=c.unit and
                           (a.supdate = @vfirstdate or a.supdate = @vseconddate or a.supdate = @vthirddate ) and
                           a.agcd=c.agcd and a.dpcd=c.dpcd and
                           (a.route_code=@proute or @proute is null or @proute='') and a.route_code=b.route_code 
                           and (a.AGENCY_TY_CODE=@pextra3 or @pextra3 is null or @pextra3='')
                           and (c.AG_CLASS=@pextra4 or @pextra4 is null or @pextra4='')
                           and (isnull(final_supply_flag,'N') = @pextra5  or @pextra5 is null or @pextra5='')  
                           ) x
                     where isnull(x.second_sup,0)-isnull(x.first_sup,0)<>0
                           group by x.comp_code,x.unit_code,x.route_code,x.route_name,x.route_name_oth_lang
                           order by comp_code,route_code
		End
        else	Begin
				----route wise total
                 select x.comp_code "COMP CODE",x.route_code "ROUTE CODE",x.route_name "ROUTE NAME",x.route_name_oth_lang "ROUTE NAME OTHER LANG",sum(x.first_sup) "FIRST SUPPLY",sum(x.second_sup) "SECOND SUPPLY",
                 sum(x.third_sup) "THIRD SUPPLY",
           -ISNULL(sum(x.first_sup),0) + ISNULL(sum(x.second_sup),0) as "VARIANCE_A-B",
         - ISNULL(sum(x.first_sup),0) + ISNULL(sum(x.third_sup),0) as "VARIANCE_A-C",
        
        CASE SUM(x.first_sup) WHEN 0 THEN 100 
		ELSE ROUND(((ISNULL(SUM(x.second_sup), 0) - ISNULL(SUM(x.first_sup), 0)) * 100) / CASE sign(SUM(x.second_sup) - SUM(x.first_sup)) WHEN - 1 THEN SUM(x.first_sup)ELSE SUM(x.second_sup)END, 2) 
		END "PERCENT_VARIANCE_A-B",		
		
		CASE SUM(x.first_sup) WHEN 0 THEN 100 
		ELSE ROUND(((ISNULL(SUM(x.third_sup), 0) - ISNULL(SUM(x.first_sup), 0)) * 100) / CASE sign(SUM(x.third_sup) - SUM(x.first_sup)) WHEN - 1 THEN SUM(x.first_sup)ELSE SUM(x.third_sup)END, 2) 
		END "PERCENT_VARIANCE_A-C"
		 from
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
                                         (cir_dbksup.sup_type_code = @pextra2 or @pextra2 is null or @pextra2='')) second_sup,
                              (select isnull(sum(sup_copy),0) from cir_dbksup
                                   where comp_code    =    @pcomp_code and unit_code =    @punit_code and
                                         publ         =    @ppublication and (edtn   =    @pedtn or @pedtn is null or @pedtn='') and
                                         supdate         = @vthirddate and cir_dbksup.agcd =    a.agcd and
                                         cir_dbksup.dpcd = a.dpcd and cir_dbksup.route_code =  a.route_code and
                                         cir_dbksup.publ = a.publ and cir_dbksup.edtn =  a.edtn and
                                         (cir_dbksup.route_code= @proute or @proute is null or @proute='') and
                                         cir_dbksup.edtn in(select distinct edtn from cir_edtn_mast where comp_code=@pcomp_code and (edtn = @pedtn or @pedtn is null or @pedtn='') and 
										(main_edtn=@pmainedtn or @pmainedtn is null or @pmainedtn='')) and
                                         (cir_dbksup.sup_type_code = @pextra2 or @pextra2 is null or @pextra2='')) third_sup
                             from cir_dbksup a,cir_route_mast b,cir_agmast c
                             where a.comp_code=@pcomp_code and a.comp_code=b.comp_code and a.comp_code=c.comp_code and
                                   a.unit_code=@punit_code and a.unit_code=b.unit and a.unit_code=c.unit and
                                   (a.supdate = @vfirstdate or a.supdate = @vseconddate or a.supdate = @vthirddate ) and
                                   a.agcd=c.agcd and a.dpcd=c.dpcd and
                                   (a.route_code=@proute or @proute is null or @proute='') and a.route_code=b.route_code 
                                   and (a.AGENCY_TY_CODE=@pextra3 or @pextra3 is null or @pextra3='')
									and (c.AG_CLASS=@pextra4 or @pextra4 is null or @pextra4='')
                                   and (isnull(final_supply_flag,'N') = @pextra5  or @pextra5 is null or @pextra5='')  
                                   ) x
                             where isnull(x.second_sup,0)-isnull(x.first_sup,0)<>0
                                   group by x.comp_code,x.route_code,x.route_name,x.route_name_oth_lang
                                   order by comp_code,route_code
        End
        
        If upper(@pextra1)='U' Begin
				----comp wise total
        select x.comp_code "COMP CODE",
		sum(x.first_sup) "FIRST SUPPLY",sum(x.second_sup) "SECOND SUPPLY",
		sum(x.third_sup) "THIRD SUPPLY",
          -ISNULL(sum(x.first_sup),0) + ISNULL(sum(x.second_sup),0) as "VARIANCE_A-B",
         - ISNULL(sum(x.first_sup),0) + ISNULL(sum(x.third_sup),0) as "VARIANCE_A-C",
        
        CASE SUM(x.first_sup) WHEN 0 THEN 100 
		ELSE ROUND(((ISNULL(SUM(x.second_sup), 0) - ISNULL(SUM(x.first_sup), 0)) * 100) / CASE sign(SUM(x.second_sup) - SUM(x.first_sup)) WHEN - 1 THEN SUM(x.first_sup)ELSE SUM(x.second_sup)END, 2) 
		END "PERCENT_VARIANCE_A-B",		
		
		CASE SUM(x.first_sup) WHEN 0 THEN 100 
		ELSE ROUND(((ISNULL(SUM(x.third_sup), 0) - ISNULL(SUM(x.first_sup), 0)) * 100) / CASE sign(SUM(x.third_sup) - SUM(x.first_sup)) WHEN - 1 THEN SUM(x.first_sup)ELSE SUM(x.third_sup)END, 2) 
		END "PERCENT_VARIANCE_A-C"		,
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
                                 (cir_dbksup.sup_type_code = @pextra2 or @pextra2 is null or @pextra2='')) second_sup,
                     (select isnull(sum(sup_copy),0) from cir_dbksup
                           where comp_code		 = @pcomp_code and unit_code =    @punit_code and
                                 publ			 = @ppublication and (edtn   =    @pedtn or @pedtn is null or @pedtn='') and
                                 supdate         = @vthirddate and cir_dbksup.agcd =    a.agcd and
                                 cir_dbksup.dpcd = a.dpcd and cir_dbksup.route_code =  a.route_code and
                                 cir_dbksup.publ = a.publ and cir_dbksup.edtn =  a.edtn and
                                 (cir_dbksup.route_code= @proute or @proute is null or @proute='') and
                                 cir_dbksup.edtn in(select distinct edtn from cir_edtn_mast where comp_code=@pcomp_code and (edtn = @pedtn or @pedtn is null or @pedtn='') and 
								(main_edtn=@pmainedtn or @pmainedtn is null or @pmainedtn='')) and
                                 (cir_dbksup.sup_type_code = @pextra2 or @pextra2 is null or @pextra2='')) third_sup            
                     from cir_dbksup a,cir_route_mast b,cir_agmast c
                     where a.comp_code=@pcomp_code and a.comp_code=b.comp_code and a.comp_code=c.comp_code and
                           a.unit_code=@punit_code and a.unit_code=b.unit and a.unit_code=c.unit and
                           (a.supdate = @vfirstdate or a.supdate = @vseconddate or a.supdate = @vthirddate ) and
                           a.agcd=c.agcd and a.dpcd=c.dpcd and
                           (a.route_code=@proute or @proute is null or @proute='') and a.route_code=b.route_code 
							and (a.AGENCY_TY_CODE=@pextra3 or @pextra3 is null or @pextra3='')
                           and (c.AG_CLASS=@pextra4 or @pextra4 is null or @pextra4='')
                           and (isnull(final_supply_flag,'N') = @pextra5  or @pextra5 is null or @pextra5='')  
                           ) x
                     where isnull(x.second_sup,0)-isnull(x.first_sup,0)<>0
                           group by x.comp_code
                           order by comp_code
			End
        else	Begin
        ----comp wise total
                     select x.comp_code "COMP CODE",sum(x.first_sup) "FIRST SUPPLY",sum(x.second_sup) "SECOND SUPPLY",
					sum(x.third_sup) "THIRD SUPPLY",
           -ISNULL(sum(x.first_sup),0) + ISNULL(sum(x.second_sup),0) as "VARIANCE_A-B",
         - ISNULL(sum(x.first_sup),0) + ISNULL(sum(x.third_sup),0) as "VARIANCE_A-C",
        
        CASE SUM(x.first_sup) WHEN 0 THEN 100 
		ELSE ROUND(((ISNULL(SUM(x.second_sup), 0) - ISNULL(SUM(x.first_sup), 0)) * 100) / CASE sign(SUM(x.second_sup) - SUM(x.first_sup)) WHEN - 1 THEN SUM(x.first_sup)ELSE SUM(x.second_sup)END, 2) 
		END "PERCENT_VARIANCE_A-B",		
		
		CASE SUM(x.first_sup) WHEN 0 THEN 100 
		ELSE ROUND(((ISNULL(SUM(x.third_sup), 0) - ISNULL(SUM(x.first_sup), 0)) * 100) / CASE sign(SUM(x.third_sup) - SUM(x.first_sup)) WHEN - 1 THEN SUM(x.first_sup)ELSE SUM(x.third_sup)END, 2) 
		END "PERCENT_VARIANCE_A-C"	,
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
                                             (cir_dbksup.sup_type_code = @pextra2 or @pextra2 is null or @pextra2='')) second_sup,
                                (select isnull(sum(sup_copy),0) from cir_dbksup
                                       where comp_code    =    @pcomp_code and unit_code =    @punit_code and
                                             publ         =    @ppublication and (edtn   =    @pedtn or @pedtn is null or @pedtn='') and
                                             supdate      = @vthirddate and cir_dbksup.agcd =    a.agcd and
                                             cir_dbksup.dpcd = a.dpcd and cir_dbksup.route_code =  a.route_code and
                                             cir_dbksup.publ = a.publ and cir_dbksup.edtn =  a.edtn and
                                             (cir_dbksup.route_code= @proute or @proute is null or @proute='') and
                                             cir_dbksup.edtn in(select distinct edtn from cir_edtn_mast where comp_code=@pcomp_code and (edtn = @pedtn or @pedtn is null or @pedtn='') and (main_edtn=@pmainedtn or @pmainedtn is null or @pmainedtn='')) and
                                             (cir_dbksup.sup_type_code = @pextra2 or @pextra2 is null or @pextra2='')) third_sup
                                 from cir_dbksup a,cir_route_mast b,cir_agmast c
                                 where a.comp_code=@pcomp_code and a.comp_code=b.comp_code and a.comp_code=c.comp_code and
                                       a.unit_code=@punit_code and a.unit_code=b.unit and a.unit_code=c.unit and
                                       (a.supdate = @vfirstdate or a.supdate = @vseconddate or a.supdate = @vthirddate ) and
                                       a.agcd=c.agcd and a.dpcd=c.dpcd and
                                       (a.route_code=@proute or @proute is null or @proute='') and a.route_code=b.route_code 
                                       and (a.AGENCY_TY_CODE=@pextra3 or @pextra3 is null or @pextra3='')
										and (c.AG_CLASS=@pextra4 or @pextra4 is null or @pextra4='')
                                       and (isnull(final_supply_flag,'N') = @pextra5  or @pextra5 is null or @pextra5='')  
                                       )x
                                 where isnull(x.second_sup,0)-isnull(x.first_sup,0)<>0
                                       group by comp_code
                                       order by comp_code
        End
		 
End


*******************************************************************end**************************************************

***************************add by Deepika 17/10/2012 sent scripts by Gaurav sir***************

                                                                     
                                                                     
                                                                     
                                             
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
        u.comm_amt comm_amt,u.waste_amt waste_amt,u.total_amt total_amt,u.damage damage,u.paid paid from
   (select b.comp_code comp_code,b.unit_code unit_code,b.doctype doctype,b.recptno recptno,b.recptdt recptdt,
        b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,dbo.cir_get_city(b.comp_code,a.city_code) city_name,
        b.supdate supdate,sum(b.supply_copy) supply_copy,
        sum(b.apr_short_recpt) short_recpt,sum(b.apr_late_recpt) late_recpt,sum(b.apr_bnr) bnr
        ,sum(b.apr_unsold) unsold,
        b.copy_rate copy_rate
        ,b.comm_rate comm_rate
        
        ,b.waste_alw waste_alw,b.waste_rate waste_rate,
        sum(isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0))*b.copy_rate copy_amt
        
        ,round(((sum(b.apr_unsold)* b.copy_rate * b.comm_rate)/100) ,3) comm_amt --sum(b.comm_amt) comm_amt
        
        ,sum(b.waste_amt) waste_amt,sum(isnull(b.copy_amt,0)) total_amt ,sum(isnull(b.apr_damage,0)) damage 
        
        /**********new change***********/
       ,sum(d.sup_copy) PAID 
         /**********new change***********/
         
         
   from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e
   
    /**********new change***********/
   ,CIR_DBKSUP d,CIR_SUPPLY_TYPE_MAST t
    /**********new change***********/
    
   where b.comp_code = a.comp_code and b.comp_code = e.comp_code and b.comp_code =@pcomp_code and 
         b.unit_code=a.unit and b.unit_code=e.unit_code and b.unit_code=@punit_code and 
         b.doctype=@pdoc_type and b.app_dt between @v_frdt and @v_todt and 
         a.agcd=b.agcd and a.dpcd=b.dpcd and (b.agcd=@pagcode or @pagcode is null or @pagcode='') and (b.dpcd=@pdepocode or @pdepocode is null or @pdepocode='') and 
         b.publ=e.publ and (b.publ=@ppubl or @ppubl is null or @ppubl='') and b.edtn=e.edtn and (b.edtn=@pedtn or @pedtn is null or @pedtn='') and
         (a.city_code=@pcity or @pcity is null or @pcity='') and
         (isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0))>0 and 
         (e.main_edtn=@pmainedtn or @pmainedtn is null or @pmainedtn='') and upper(isnull(@papproved_flag,'N'))='Y'
         
         
          /**********new change***********/
         and d.SUP_TYPE_CODE=t.SUP_TY_CODE and isnull(t.bill_pay,'N')='Y' and d.comp_code=t.comp_code
         and d.comp_code=a.comp_code and d.comp_code=b.comp_code and d.comp_code=e.comp_code
         and d.agcd=a.agcd and d.dpcd=a.dpcd and  d.agcd=b.agcd and d.dpcd=b.dpcd and
         d.unit_code=a.unit and d.unit_code=b.unit_code
         and b.SUPDATE=d.SUPDATE
         and d.edtn=e.EDTN
          /**********new change***********/
          
          
         group by b.comp_code,b.unit_code,b.doctype,b.recptno,b.recptdt,b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,
         a.city_code,b.supdate,b.copy_rate,b.comm_rate,b.waste_alw,b.waste_rate
   union all
   select b.comp_code comp_code,b.unit_code unit_code,b.doctype doctype,b.recptno recptno,b.recptdt recptdt,
        b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,dbo.cir_get_city(b.comp_code,a.city_code) city_name,
        b.supdate supdate,sum(b.supply_copy) supply_copy,
        sum(b.short_recpt) short_recpt,sum(b.late_recpt) late_recpt,sum(b.bnr) bnr,sum(b.unsold) unsold,
        b.copy_rate copy_rate,b.comm_rate comm_rate,b.waste_alw waste_alw,b.waste_rate waste_rate,
        sum(isnull(b.short_recpt,0)+isnull(b.late_recpt,0)+isnull(b.bnr,0)+isnull(b.unsold,0))*b.copy_rate copy_amt
        ,round(((sum(b.apr_unsold)* b.copy_rate * b.comm_rate)/100) ,3) comm_amt --sum(b.comm_amt) comm_amt
        ,sum(b.waste_amt) waste_amt,sum(isnull(b.copy_amt,0)) total_amt,sum(isnull(b.damage,0)) damage  
        
        
         /**********new change***********/
         ,sum(d.sup_copy) PAID 
          /**********new change***********/
          
          
   from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e
   
   
    /**********new change***********/
   ,CIR_DBKSUP d,CIR_SUPPLY_TYPE_MAST t
    /**********new change***********/
    
    
   where b.comp_code = a.comp_code and b.comp_code = e.comp_code and b.comp_code =@pcomp_code and 
         b.unit_code=a.unit and b.unit_code=e.unit_code and b.unit_code=@punit_code and 
         b.doctype=@pdoc_type and b.recptdt between @v_frdt and @v_todt and 
         a.agcd=b.agcd and a.dpcd=b.dpcd and (b.agcd=@pagcode or @pagcode is null or @pagcode='') and (b.dpcd=@pdepocode or @pdepocode is null or @pdepocode='') and 
         b.publ=e.publ and (b.publ=@ppubl or @ppubl is null or @ppubl='') and b.edtn=e.edtn and (b.edtn=@pedtn or @pedtn is null or @pedtn='') and
         (a.city_code=@pcity or @pcity is null or @pcity='') and
         (isnull(short_recpt,0)+isnull(late_recpt,0)+isnull(bnr,0)+isnull(unsold,0))>0 and 
         (e.main_edtn=@pmainedtn or @pmainedtn is null or @pmainedtn='') and upper(isnull(@papproved_flag,'N'))='N'
         
         
          /**********new change***********/
          and d.SUP_TYPE_CODE=t.SUP_TY_CODE and isnull(t.bill_pay,'N')='Y' and d.comp_code=t.comp_code
         and d.comp_code=a.comp_code and d.comp_code=b.comp_code and d.comp_code=e.comp_code
         and d.agcd=a.agcd and d.dpcd=a.dpcd and  d.agcd=b.agcd and d.dpcd=b.dpcd and
         d.unit_code=a.unit and d.unit_code=b.unit_code
           and b.SUPDATE=d.SUPDATE
         and d.edtn=e.EDTN
          /**********new change***********/
          
          
         group by b.comp_code,b.unit_code,b.doctype,b.recptno,b.recptdt,b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,
         a.city_code,b.supdate,b.copy_rate,b.comm_rate,b.waste_alw,b.waste_rate) u 
         order by u.comp_code,u.unit_code,u.recptdt,u.recptno,u.agname



//////////////////////////////next/////////////


                                                                     
                                                                     
                                                                     
                                             
ALTER FUNCTION  [dbo].[cir_get_route_by_ag](@pcomp_code  varchar(100),@paagcd_dpcd  varchar(100),@flag varchar(1)) RETURNs char(400) 
AS
	Begin

        DECLARE @vroute_code VARCHAR(400)
        
        if @flag='C' begin
			select @vroute_code= route_code from cir_supply where comp_code=@pcomp_code and agcd+dpcd=@paagcd_dpcd
        end
        else
        begin
			select @vroute_code= z.route_name from cir_route_mast z 
			where z.comp_code= @pcomp_code and z.route_code =
			(select top 1 c.route_code from cir_supply c where c.comp_code= @pcomp_code 
			and c.agcd+c.dpcd=@paagcd_dpcd)
        end
        

	
  return isnull(@vroute_code,'')
END

////////////////////////////////next/////////////////


ALTER PROCEDURE [dbo].[cir_get_userlist_]
@pcompcode VARCHAR(20) ,
@punit VARCHAR(20) ,
@pbranch VARCHAR(20) ,
@agcd VARCHAR(20) ,
@dpcd VARCHAR(20) ,
@pfromdate VARCHAR(20) ,
@ptodate VARCHAR(20) ,
@userid VARCHAR(20) ,
@pdateformat VARCHAR(20) ,
@pextra1 varchar(200),
@pextra2 varchar(200),
@pextra3 varchar(200),
@pextra4 varchar(200),
@pextra5 varchar(200),
@pextra6 varchar(200),
@pextra7 varchar(200),
@pextra8 varchar(200),
@pextra9 varchar(200),
@pextra10 varchar(200)

AS
BEGIN

declare @v_frdate as datetime
declare @v_todate as datetime

set @v_frdate=CAST(@pfromdate as datetime)
set @v_todate=CAST(@ptodate as datetime)

print(@v_frdate)
print(@v_todate)

SELECT T.COMP_CODE,UNIT,T.AGCD,T.DPCD,dbo.cir_get_agency(@pcompcode,@punit,T.AGCD,T.DPCD)as AG_NMAE, MAX(T.ALTER_ST) ALTER_ST,MAX(T.ALTER_USER) ALTER_USER ,MAX(T.CORRECT_ST) CORRECT_ST
,MAX(T.CORRECT_USER) CORRECT_USER ,dbo.get_USER_NAME(MAX(T.CORRECT_USER)) as "USER_NAME",T.ALTER_DATE FROM (
select distinct Q.COMP_CODE,Q.UNIT,Q.AGCD,Q.DPCD
,CASE Q.ALTER_ST WHEN 'CORRECT' THEN 'Y' ELSE '' END CORRECT_ST 
,CASE Q.ALTER_ST WHEN 'ALTER' THEN 'Y' ELSE '' END ALTER_ST 
,Q.ALTER_USER,Q.ALTER_USER CORRECT_USER,Q.ALTER_DATE from (

	select z.COMP_CODE,z.UNIT,z.AGCD,z.DPCD,z.ALTER_ST,z.ALTER_USER ,z.ALTER_DATE from 
	(select x.COMP_CODE,x.UNIT,x.AGCD,x.DPCD,x.ALTER_ST,x.ALTER_USER,x.ALTER_DATE  from (
	select COMP_CODE,UNIT,AGCD,DPCD,BASE_SUPPLY,SUPPLY_SUN,SUPPLY_MON,SUPPLY_TUE,SUPPLY_WED,SUPPLY_THU
	,SUPPLY_FRI,SUPPLY_SAT,SUPPLY_SPL1,SUPPLY_SPL2,SP_SUPPLY_SUN1,SP_SUPPLY_MON1,SP_SUPPLY_TUE1,SP_SUPPLY_WED1,SP_SUPPLY_THU1
	,SP_SUPPLY_FRI1,SP_SUPPLY_SAT1,SP_SUPPLY_SUN2,SP_SUPPLY_MON2,SP_SUPPLY_TUE2,SP_SUPPLY_WED2,SP_SUPPLY_THU2
	,SP_SUPPLY_FRI2,SP_SUPPLY_SAT2,'ALTER' ALTER_ST ,LOG_USER ALTER_USER,LOG_DATE ALTER_DATE from CIR_SUPPLY_LOG v 
	WHERE COMP_CODE=@pcompcode and LOG_TYPE='N#UPDATE' and cast(LOG_DATE as datetime) between @v_frdate and @v_todate
	and not exists(
	select COMP_CODE,UNIT,AGCD,DPCD,BASE_SUPPLY,SUPPLY_SUN,SUPPLY_MON,SUPPLY_TUE,SUPPLY_WED,SUPPLY_THU
	,SUPPLY_FRI,SUPPLY_SAT,SUPPLY_SPL1,SUPPLY_SPL2,SP_SUPPLY_SUN1,SP_SUPPLY_MON1,SP_SUPPLY_TUE1,SP_SUPPLY_WED1,SP_SUPPLY_THU1
	,SP_SUPPLY_FRI1,SP_SUPPLY_SAT1,SP_SUPPLY_SUN2,SP_SUPPLY_MON2,SP_SUPPLY_TUE2,SP_SUPPLY_WED2,SP_SUPPLY_THU2
	,SP_SUPPLY_FRI2,SP_SUPPLY_SAT2,'ALTER' ALTER_ST,LOG_USER ALTER_USER,LOG_DATE ALTER_DATE from CIR_SUPPLY_LOG t 
	WHERE COMP_CODE=@pcompcode and LOG_TYPE='O#UPDATE'  and cast(LOG_DATE as datetime) between @v_frdate and @v_todate
	and v.COMP_CODE=t.COMP_CODE and v.UNIT=t.UNIT and v.AGCD=t.AGCD and v.DPCD=t.DPCD
	and v.BASE_SUPPLY=t.BASE_SUPPLY and v.SUPPLY_SUN=t.SUPPLY_SUN and v.SUPPLY_MON=t.SUPPLY_MON and v.SUPPLY_TUE=t.SUPPLY_TUE
	and v.SUPPLY_WED=t.SUPPLY_WED and v.SUPPLY_THU=t.SUPPLY_THU and v.SUPPLY_FRI=t.SUPPLY_FRI and v.SUPPLY_SAT =t.SUPPLY_SAT
	and v.SUPPLY_SPL1=t.SUPPLY_SPL1 and v.SUPPLY_SPL2=t.SUPPLY_SPL2 and v.SP_SUPPLY_SUN1 = t.SP_SUPPLY_SUN1 and v.SP_SUPPLY_MON1=t.SP_SUPPLY_MON1
	and v.SP_SUPPLY_TUE1=t.SP_SUPPLY_TUE1 and v.SP_SUPPLY_WED1=t.SP_SUPPLY_WED1 and v.SP_SUPPLY_THU1=t.SP_SUPPLY_THU1
	and v.SP_SUPPLY_FRI1 =t.SP_SUPPLY_FRI1 and v.SP_SUPPLY_SAT1=t.SP_SUPPLY_SAT1 and v.SP_SUPPLY_SUN2 = t.SP_SUPPLY_SUN2 and v.SP_SUPPLY_MON2=t.SP_SUPPLY_MON2
	and v.SP_SUPPLY_TUE2=t.SP_SUPPLY_TUE2 and v.SP_SUPPLY_WED2=t.SP_SUPPLY_WED2 and v.SP_SUPPLY_THU2=t.SP_SUPPLY_THU2
	and v.SP_SUPPLY_FRI2 =t.SP_SUPPLY_FRI2 and v.SP_SUPPLY_SAT2=t.SP_SUPPLY_SAT2)
	) x
	union all
	select y.COMP_CODE,y.UNIT_CODE UNIT,y.AGCD,y.DPCD,y.ALTER_ST,y.ALTER_USER ,y.ALTER_DATE from
	(select COMP_CODE,UNIT_CODE,AGCD,DPCD,SUP_COPY,'CORRECT' ALTER_ST ,LOG_USER ALTER_USER,LOG_DATE ALTER_DATE  
	from cir_dbksup_log v WHERE COMP_CODE=@pcompcode and LOG_TYPE='N#UPDATE' and cast(LOG_DATE as datetime) between @v_frdate and @v_todate
	and not exists(
	select COMP_CODE,UNIT_CODE,AGCD,DPCD,SUP_COPY,'CORRECT' ALTER_ST ,LOG_USER ALTER_USER ,LOG_DATE ALTER_DATE 
	from cir_dbksup_log t WHERE COMP_CODE=@pcompcode and LOG_TYPE='O#UPDATE' and cast(LOG_DATE as datetime) between @v_frdate and @v_todate
	and v.COMP_CODE=t.COMP_CODE and v.SUP_COPY=t.SUP_COPY and v.UNIT_CODE=t.UNIT_CODE and v.AGCD=t.AGCD and v.DPCD=t.DPCD
	)
	)y )z where z.COMP_CODE=@pcompcode 
	and (z.UNIT =@punit or @punit is null or @punit='')
	--and (branch_code =@pbranch or @pbranch is null or @pbranch ='')
	and (z.AGCD =@agcd or @agcd is null or @agcd='')
	and (z.DPCD=@dpcd or @dpcd is null or @dpcd ='')
	group by z.COMP_CODE,z.UNIT,z.AGCD,z.DPCD,z.ALTER_ST,z.ALTER_USER,z.ALTER_DATE
) Q ) T
	GROUP BY T.COMP_CODE,T.UNIT,T.AGCD,T.DPCD,T.ALTER_DATE


END

/*select z.COMP_CODE,z.UNIT,z.AGCD,z.DPCD,z.ALTER_ST,z.ALTER_USER,z.CORRECT_ST,z.CORRECT_USER from 
	(select x.COMP_CODE,x.UNIT,x.AGCD,x.DPCD,x.ALTER_ST,x.ALTER_USER,x.CORRECT_ST,x.CORRECT_USER   from (
	select COMP_CODE,UNIT,AGCD,DPCD,BASE_SUPPLY,SUPPLY_SUN,SUPPLY_MON,SUPPLY_TUE,SUPPLY_WED,SUPPLY_THU
	,SUPPLY_FRI,SUPPLY_SAT,SUPPLY_SPL1,SUPPLY_SPL2,SP_SUPPLY_SUN1,SP_SUPPLY_MON1,SP_SUPPLY_TUE1,SP_SUPPLY_WED1,SP_SUPPLY_THU1
	,SP_SUPPLY_FRI1,SP_SUPPLY_SAT1,SP_SUPPLY_SUN2,SP_SUPPLY_MON2,SP_SUPPLY_TUE2,SP_SUPPLY_WED2,SP_SUPPLY_THU2
	,SP_SUPPLY_FRI2,SP_SUPPLY_SAT2,'YES' ALTER_ST ,LOG_USER ALTER_USER ,'NO' CORRECT_ST ,null CORRECT_USER from CIR_SUPPLY_LOG v 
	WHERE COMP_CODE=@pcompcode and LOG_TYPE='N#UPDATE' and cast(LOG_DATE as date) between @pfromdate and @ptodate
	and not exists(
	select COMP_CODE,UNIT,AGCD,DPCD,BASE_SUPPLY,SUPPLY_SUN,SUPPLY_MON,SUPPLY_TUE,SUPPLY_WED,SUPPLY_THU
	,SUPPLY_FRI,SUPPLY_SAT,SUPPLY_SPL1,SUPPLY_SPL2,SP_SUPPLY_SUN1,SP_SUPPLY_MON1,SP_SUPPLY_TUE1,SP_SUPPLY_WED1,SP_SUPPLY_THU1
	,SP_SUPPLY_FRI1,SP_SUPPLY_SAT1,SP_SUPPLY_SUN2,SP_SUPPLY_MON2,SP_SUPPLY_TUE2,SP_SUPPLY_WED2,SP_SUPPLY_THU2
	,SP_SUPPLY_FRI2,SP_SUPPLY_SAT2,'YES' ALTER_ST,LOG_USER ALTER_USER ,'NO' CORRECT_ST ,null CORRECT_USER from CIR_SUPPLY_LOG t 
	WHERE COMP_CODE=@pcompcode and LOG_TYPE='O#UPDATE'  and cast(LOG_DATE as date) between @pfromdate and @ptodate
	and v.COMP_CODE=t.COMP_CODE and v.UNIT=t.UNIT and v.AGCD=t.AGCD and v.DPCD=t.DPCD
	and v.BASE_SUPPLY=t.BASE_SUPPLY and v.SUPPLY_SUN=t.SUPPLY_SUN and v.SUPPLY_MON=t.SUPPLY_MON and v.SUPPLY_TUE=t.SUPPLY_TUE
	and v.SUPPLY_WED=t.SUPPLY_WED and v.SUPPLY_THU=t.SUPPLY_THU and v.SUPPLY_FRI=t.SUPPLY_FRI and v.SUPPLY_SAT =t.SUPPLY_SAT
	and v.SUPPLY_SPL1=t.SUPPLY_SPL1 and v.SUPPLY_SPL2=t.SUPPLY_SPL2 and v.SP_SUPPLY_SUN1 = t.SP_SUPPLY_SUN1 and v.SP_SUPPLY_MON1=t.SP_SUPPLY_MON1
	and v.SP_SUPPLY_TUE1=t.SP_SUPPLY_TUE1 and v.SP_SUPPLY_WED1=t.SP_SUPPLY_WED1 and v.SP_SUPPLY_THU1=t.SP_SUPPLY_THU1
	and v.SP_SUPPLY_FRI1 =t.SP_SUPPLY_FRI1 and v.SP_SUPPLY_SAT1=t.SP_SUPPLY_SAT1 and v.SP_SUPPLY_SUN2 = t.SP_SUPPLY_SUN2 and v.SP_SUPPLY_MON2=t.SP_SUPPLY_MON2
	and v.SP_SUPPLY_TUE2=t.SP_SUPPLY_TUE2 and v.SP_SUPPLY_WED2=t.SP_SUPPLY_WED2 and v.SP_SUPPLY_THU2=t.SP_SUPPLY_THU2
	and v.SP_SUPPLY_FRI2 =t.SP_SUPPLY_FRI2 and v.SP_SUPPLY_SAT2=t.SP_SUPPLY_SAT2)
	) x
	union all
	select y.COMP_CODE,y.UNIT_CODE UNIT,y.AGCD,y.DPCD,y.ALTER_ST,y.ALTER_USER,y.CORRECT_ST,y.CORRECT_USER  from
	(select COMP_CODE,UNIT_CODE,AGCD,DPCD,SUP_COPY,'NO' ALTER_ST ,null ALTER_USER ,'YES' CORRECT_ST ,LOG_USER CORRECT_USER 
	from cir_dbksup_log v WHERE COMP_CODE=@pcompcode and LOG_TYPE='N#UPDATE' and cast(LOG_DATE as date) between @pfromdate and @ptodate
	and not exists(
	select COMP_CODE,UNIT_CODE,AGCD,DPCD,SUP_COPY,'NO' ALTER_ST ,null ALTER_USER ,'YES' CORRECT_ST ,LOG_USER CORRECT_USER 
	from cir_dbksup_log t WHERE COMP_CODE=@pcompcode and LOG_TYPE='O#UPDATE' and cast(LOG_DATE as date) between @pfromdate and @ptodate
	and v.COMP_CODE=t.COMP_CODE and v.SUP_COPY=t.SUP_COPY and v.UNIT_CODE=t.UNIT_CODE and v.AGCD=t.AGCD and v.DPCD=t.DPCD
	)
	)y )z where z.COMP_CODE=@pcompcode 
	and (z.UNIT =@punit or @punit is null or @punit='')
	--and (branch_code =@pbranch or @pbranch is null or @pbranch ='')
	and (z.AGCD =@agcd or @agcd is null or @agcd='')
	and (z.DPCD=@dpcd or @dpcd is null or @dpcd ='')
	group by z.COMP_CODE,z.UNIT,z.AGCD,z.DPCD,z.ALTER_ST,z.ALTER_USER,z.CORRECT_ST,z.CORRECT_USER

*/

******************************************end******************************************************



ALTER FUNCTION  [dbo].[cir_get_route_by_ag](@pcomp_code  varchar(100),@paagcd_dpcd  varchar(100),@flag varchar(1)) RETURNs char(400) 
AS
Begin

        DECLARE @vroute_code VARCHAR(400)
        
        if @flag='C' begin
select @vroute_code= route_code from cir_supply where comp_code=@pcomp_code and agcd+dpcd=@paagcd_dpcd
        end
        else
        begin
select @vroute_code= z.route_name from cir_route_mast z 
where z.comp_code= @pcomp_code and z.route_code =
(select top 1 c.route_code from cir_supply c where c.comp_code= @pcomp_code 
and c.agcd+c.dpcd=@paagcd_dpcd)
        end
        

  return isnull(@vroute_code,'')
END


*****************************************************************************************************************

/////////////////////////add by deepika 18\10\2012send by Gaurav sir ////////////////////////////////

                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE [dbo].[cir_datapos_integration_utusan]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@pfile_type                               VARCHAR(20) ,-- School S/ Others O	
	@ptrn_frdt                                datetime ,
	@ptrn_todt                                datetime ,
	@pbg_exp_frdt                             datetime ,
	@pbg_exp_todt                             datetime ,		
	@psec_exp_dt							  datetime ,	
	@pdateformat                              VARCHAR(20) ,
	@puserid                                  VARCHAR(20) ,
	@pbranch								  VARCHAR(20) ,
	@psup_branch							  VARCHAR(20) ,
	@pagcd_fr   							  VARCHAR(20) ,
	@pagcd_to   							  VARCHAR(20) ,
	@pextra1                                  VARCHAR(400) ,  
	@pextra2                                  VARCHAR(400) ,
	@pextra3                                  VARCHAR(400) ,
	@pextra4                                  VARCHAR(400) ,
	@pextra5                                  VARCHAR(400) ,
	@pextra6                                  VARCHAR(400) 
	
AS 
		DECLARE @vtrn_frdt      DATETIME 
		DECLARE @vtrn_todt      DATETIME 
		DECLARE @vbgexp_frdt    DATETIME 
		DECLARE @vbgexp_todt    DATETIME 
		DECLARE @vsec_expdt     DATETIME 
     	SET @vtrn_frdt  =  @ptrn_frdt--dbo.convert_user_date('/',@pfrdt,@pdateformat)
     	SET @vtrn_todt  =  @ptrn_todt--dbo.convert_user_date('/',@ptodt,@pdateformat)
     	SET @vbgexp_frdt  =  @pbg_exp_frdt--dbo.convert_user_date('/',@pfrdt,@pdateformat)
     	SET @vbgexp_todt  =  @psec_exp_dt--dbo.convert_user_date('/',@ptodt,@pdateformat)
     	SET @vsec_expdt  =  @psec_exp_dt--dbo.convert_user_date('/',@pfrdt,@pdateformat)
 	
	
	if @pfile_type ='S'
	begin
		select ROW_NUMBER() OVER (Order by b.Branch_Name) as FILE_NO
		,b.Branch_Code ,b.Branch_Name,a.SUP_BRANCH_CODE,
		(Select Branch_Name from branch_mst x where x.Comp_Code=a.comp_code and x.Branch_Code=a.SUP_BRANCH_CODE) as SUP_BRANCH_NAME 
		,count(agcd) tot_agent
		from CIR_AGMAST a,branch_mst b where a.COMP_CODE=b.Comp_Code and a.COMP_CODE=@pcomp_code
		and a.BRANCH_CODE=b.Branch_Code 
		and (a.UNIT=@punit_code or @punit_code is null or @punit_code ='')
		and (a.SUP_BRANCH_CODE=@psup_branch or @psup_branch is null or @psup_branch ='')
		and isnull(a.DATA_POST,'N')='Y' and a.AG_TYPE='AT004'
		group by b.Branch_Code ,b.Branch_Name,a.SUP_BRANCH_CODE,a.comp_code

		select x.AG_NAME name,x.H_ADDR1 as company_address1,x.H_ADDR2 as company_address2,x.PIN_CODE as company_zip,x.H_ADDR3 as company_address3
		,dbo.cir_get_state ( x.comp_code,x.country_code, x.STATE_CODE) as state_name,'MY' as compute_0007,x.PHONE_NO1 as phone1,x.FAX_NO as fax1
		,'' as compute_0011,x.AGCD+x.DPCD as code,'' as compute_0013 from CIR_AGMAST x
		where x.COMP_CODE=@pcomp_code and isnull(x.DATA_POST,'N')='Y' and x.AG_TYPE='AT004'
		and (x.UNIT=@punit_code or @punit_code is null or @punit_code ='')
		and (x.SUP_BRANCH_CODE=@psup_branch or @psup_branch is null or @psup_branch ='')
	
	end
	else
	begin
		select ROW_NUMBER() OVER (Order by b.Branch_Name) as FILE_NO
		,b.Branch_Code ,b.Branch_Name,a.SUP_BRANCH_CODE,
		(Select Branch_Name from branch_mst x where x.Comp_Code=a.comp_code and x.Branch_Code=a.SUP_BRANCH_CODE) as SUP_BRANCH_NAME 
		,count(agcd) tot_agent
		from CIR_AGMAST a,branch_mst b where a.COMP_CODE=b.Comp_Code  and a.COMP_CODE=@pcomp_code
		and a.BRANCH_CODE=b.Branch_Code 
		and (a.UNIT=@punit_code or @punit_code is null or @punit_code ='')
		and (a.SUP_BRANCH_CODE=@psup_branch or @psup_branch is null or @psup_branch ='')
		and isnull(a.DATA_POST,'N')='Y' and a.AG_TYPE!='AT004'
		group by b.Branch_Code ,b.Branch_Name,a.SUP_BRANCH_CODE,a.comp_code
		
		select x.AG_NAME name,x.H_ADDR1 as company_address1,x.H_ADDR2 as company_address2,x.PIN_CODE as company_zip,x.H_ADDR3 as company_address3
		,dbo.cir_get_state ( x.comp_code,x.country_code, x.STATE_CODE) as state_name,'MY' as compute_0007,x.PHONE_NO1 as phone1,x.FAX_NO as fax1
		,'' as compute_0011,x.AGCD+x.DPCD as code,'' as compute_0013 from CIR_AGMAST x
		where x.COMP_CODE=@pcomp_code and isnull(x.DATA_POST,'N')='Y' and x.AG_TYPE!='AT004'
		and (x.UNIT=@punit_code or @punit_code is null or @punit_code ='')
		and (x.SUP_BRANCH_CODE=@psup_branch or @psup_branch is null or @psup_branch ='')
	end
	/*
	
	*/

/////////////////////////////////////////////end//////////////////////////////////////////////////////////

**********************add by deepika 30\10\2012 sent by gaurav sir ********************


                                                                     
                                                                     
                                                                     
                                             
ALTER procedure [dbo].[cir_agencywise_product]
    @pcompcode       as varchar(20),
    @punitcode       as varchar(20),
    @pagcd           as varchar(20),
    @pdpcd           as varchar(20),
    @ptype           as varchar(20),--1 for product wise and 2 for publication wise
    @puserid         as varchar(20),
    @pdateformate    as varchar(20),
    @pextra1         as varchar(200),
    @pextra2         as varchar(200),
    @pextra3         as varchar(200),
    @pextra4         as varchar(200),
    @pextra5         as varchar(200)
as
    declare @v_dt    datetime
begin
    set @v_dt=getdate();
    
    If @ptype='2' Begin
    select distinct t.publ_type,t.publ_type_name,min(t.publ_fregquncy)  publ_fregquncy from (
        select distinct p.publ as publ_type, p.publ_name as publ_type_name,min(p.period) as publ_fregquncy 
        from cir_supply s,cir_publ_mast p,pub_type_mast t 
        where s.comp_code=p.comp_code and s.comp_code=@pcompcode and 
        s.unit=@punitcode and s.agcd=@pagcd and s.dpcd=@pdpcd and s.publ=p.publ and p.pro_type=t."pubtypecode"  
        group by p.publ,p.publ_name
        union all
        select distinct p.publ as publ_type, p.publ_name as publ_type_name,min(p.period) as publ_fregquncy 
        from cir_bill_det b,cir_publ_mast p,pub_type_mast t 
        where b.comp_code=p.comp_code and b.comp_code=@pcompcode and b.unit_code=@punitcode and b.billdt<=@v_dt and 
        b.agcd=@pagcd and b.dpcd=@pdpcd and b.publ=p.publ and p.pro_type=t."pubtypecode"  
        group by p.publ,p.publ_name
         ) t group by  t.publ_type,t.publ_type_name
         order by t.publ_type,t.publ_type_name,t.publ_fregquncy

    End
    Else Begin
select t.publ_type,t.publ_type_name,min(t.publ_fregquncy) publ_fregquncy from (
        select distinct p.pro_type as publ_type, t."pubname" as publ_type_name,min(p.period) as publ_fregquncy 
        from cir_supply s,cir_publ_mast p,pub_type_mast t 
        where s.comp_code=p.comp_code and s.comp_code=@pcompcode and 
        s.unit=@punitcode and s.agcd=@pagcd and s.dpcd=@pdpcd and s.publ=p.publ and p.pro_type=t."pubtypecode"  
        group by p.pro_type,t."pubname"
        union all
        select distinct p.pro_type as publ_type, t."pubname" as publ_type_name,min(p.period) as publ_fregquncy 
        from cir_bill_det b,cir_publ_mast p,pub_type_mast t 
        where b.comp_code=p.comp_code and b.comp_code=@pcompcode and b.unit_code=@punitcode and b.billdt<=@v_dt and 
        b.agcd=@pagcd and b.dpcd=@pdpcd and b.publ=p.publ and p.pro_type=t."pubtypecode"  
        group by p.pro_type,t."pubname"
         ) t group by  t.publ_type,t.publ_type_name
         order by t.publ_type,t.publ_type_name,t.publ_fregquncy
    End              
end 

****************************************************end**************************************

**********************add by deepika 06/11/2012 sent by gaurav sir*******

                                                                     
                                                                     
                                                                     
                                             
ALTER procedure [dbo].[cir_gen_statement_no_p]
@comp_code varchar(10),
@unit_code varchar(10),
@branch_code varchar(10), 
@agcd varchar(20),
@dpcd varchar(10),
@processdt varchar(10),
@freq varchar(1),
@dateformate varchar(10),
@extra1 varchar(10),
@extra2 varchar(10),
@extra3 varchar(10),
@extra4 varchar(10),
@extra5 varchar(10)

As
Begin

	declare @vno as varchar(200)
	declare @lno as NUMERIC
	declare @vdate as varchar(20)
	print(@processdt)

	SELECT @freq=AGEING_TYPE from CIR_AGMAST where comp_code=@comp_code and UNIT=@unit_code
	and branch_code=@branch_code and agcd=@agcd and dpcd=@dpcd

	if(@freq='D')
	begin
		select @vno= u_no from CIR_BILL_STATEMENT_NO where comp_code=@comp_code and unit_code=@unit_code
		and branch_code=@branch_code and agcd=@agcd and dpcd=@dpcd and PROCESS_DT=@processdt
		and freq=@freq

		SET @vdate=@processdt
	end
	if(@freq='W')
	begin
		SELECT @vdate=DATEADD(ww, DATEDIFF(ww,0,@processdt), 0) /*for chek the first day of week*/
		select @vno= u_no from CIR_BILL_STATEMENT_NO where comp_code=@comp_code and unit_code=@unit_code
		and branch_code=@branch_code and agcd=@agcd and dpcd=@dpcd and freq=@freq and PROCESS_DT=@vdate
	end

	if @freq='M'
	begin
		SELECT @vdate=DATEADD(dd,-(DAY(DATEADD(mm,1,@processdt))-1),DATEADD(mm,-0,@processdt)) /*for chek the first day of month*/
		select @vno= u_no from CIR_BILL_STATEMENT_NO where comp_code=@comp_code and unit_code=@unit_code
		and branch_code=@branch_code and agcd=@agcd and dpcd=@dpcd and freq=@freq and PROCESS_DT=@vdate
	end
	print('ddddd')
	print(@vdate)
	print(@vno)

	if (@vno='' OR @vno IS NULL)
	begin
		select @lno=MAX(substring(u_no,7,13))+1 from CIR_BILL_STATEMENT_NO where comp_code=@comp_code
		and unit_code=@unit_code and freq=@freq
		print('a')
		if @freq='D'
		begin
			if isnull(@lno,0)=0
			begin
				set @vno='D-'+@unit_code+'-0000001'
			end
			else	
			begin
				set @vno='D-'+@unit_code+'-'+dbo.fnPadLeft('0',7,@lno)
			end
		end
		if @freq='W'
		begin
			if isnull(@lno,0)=0
			begin
				set @vno='W-'+@unit_code+'-0000001'
			end
			else
			begin
				set @vno='W-'+@unit_code+'-'+dbo.fnPadLeft('0',7,@lno)
			end
		end
		if @freq='M'
		begin
			if isnull(@lno,0)=0
			begin
				set @vno='M-'+@unit_code+'-0000001'
			end
			else
			begin
				set @vno='M-'+@unit_code+'-'+dbo.fnPadLeft('0',7,@lno)
			end
		end
		print('val')print(@comp_code)print(@unit_code)print(@branch_code)print(@agcd)print(@dpcd)print(@vdate)print(@freq)print(@vno)print('e')
		insert into CIR_BILL_STATEMENT_NO(COMP_CODE,UNIT_CODE,BRANCH_CODE,AGCD,DPCD,PROCESS_DT,FREQ,U_NO) 
		values(@comp_code,@unit_code,@branch_code,@agcd,@dpcd,@vdate,@freq,@vno)
	end
	select @vno as U_ID
end

select ONLINE_PAY_NO from preferrences where COMP_CODE=@comp_code



/////////////////////////////////next

                                                                     
                                                                     
                                                                     
                                             
                                                                     
                                                                     
                                                                     
                                             
ALTER procedure [dbo].[cir_gen_statement_no_p]
@comp_code varchar(10),
@unit_code varchar(10),
@branch_code varchar(10), 
@agcd varchar(20),
@dpcd varchar(10),
@processdt varchar(10),
@freq varchar(1),
@dateformate varchar(10),
@extra1 varchar(10),
@extra2 varchar(10),
@extra3 varchar(10),
@extra4 varchar(10),
@extra5 varchar(10)

As
Begin

	declare @vno as varchar(200)
	declare @lno as NUMERIC
	declare @vdate as varchar(20)
	print(@processdt)

	SELECT @freq=AGEING_TYPE from CIR_AGMAST where comp_code=@comp_code and UNIT=@unit_code
	and branch_code=@branch_code and agcd=@agcd and dpcd=@dpcd

	if(@freq='D')
	begin
		select @vno= u_no from CIR_BILL_STATEMENT_NO where comp_code=@comp_code and unit_code=@unit_code
		and branch_code=@branch_code and agcd=@agcd and dpcd=@dpcd and PROCESS_DT=@processdt
		and freq=@freq

		SET @vdate=@processdt
	end
	if(@freq='W')
	begin
		SELECT @vdate=DATEADD(ww, DATEDIFF(ww,0,@processdt), 0) /*for chek the first day of week*/
		select @vno= u_no from CIR_BILL_STATEMENT_NO where comp_code=@comp_code and unit_code=@unit_code
		and branch_code=@branch_code and agcd=@agcd and dpcd=@dpcd and freq=@freq and PROCESS_DT=@vdate
	end

	if @freq='M'
	begin
		SELECT @vdate=DATEADD(dd,-(DAY(DATEADD(mm,1,@processdt))-1),DATEADD(mm,-0,@processdt)) /*for chek the first day of month*/
		select @vno= u_no from CIR_BILL_STATEMENT_NO where comp_code=@comp_code and unit_code=@unit_code
		and branch_code=@branch_code and agcd=@agcd and dpcd=@dpcd and freq=@freq and PROCESS_DT=@vdate
	end
	print('ddddd')
	print(@vdate)
	print(@vno)

	if (@vno='' OR @vno IS NULL)
	begin
		select @lno=MAX(substring(u_no,7,13))+1 from CIR_BILL_STATEMENT_NO where comp_code=@comp_code
		and unit_code=@unit_code and freq=@freq
		print('a')
		if @freq='D'
		begin
			if isnull(@lno,0)=0
			begin
				set @vno='D-'+@unit_code+'-0000001'
			end
			else	
			begin
				set @vno='D-'+@unit_code+'-'+dbo.fnPadLeft('0',7,@lno)
			end
		end
		if @freq='W'
		begin
			if isnull(@lno,0)=0
			begin
				set @vno='W-'+@unit_code+'-0000001'
			end
			else
			begin
				set @vno='W-'+@unit_code+'-'+dbo.fnPadLeft('0',7,@lno)
			end
		end
		if @freq='M'
		begin
			if isnull(@lno,0)=0
			begin
				set @vno='M-'+@unit_code+'-0000001'
			end
			else
			begin
				set @vno='M-'+@unit_code+'-'+dbo.fnPadLeft('0',7,@lno)
			end
		end
		print('val')print(@comp_code)print(@unit_code)print(@branch_code)print(@agcd)print(@dpcd)print(@vdate)print(@freq)print(@vno)print('e')
		insert into CIR_BILL_STATEMENT_NO(COMP_CODE,UNIT_CODE,BRANCH_CODE,AGCD,DPCD,PROCESS_DT,FREQ,U_NO) 
		values(@comp_code,@unit_code,@branch_code,@agcd,@dpcd,@vdate,@freq,@vno)
	end
	select @vno as U_ID
end

select ONLINE_PAY_NO from preferrences where COMP_CODE=@comp_code

////////////////////////////////////////////end////////////////////////////////////////////////////////////

/////////////////////////////////add by deepika 09/11/2012 sent by gaurav sir//////


                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE  [dbo].[Cir_Route_Bind]
  	@pcompcode as varchar(200),
   	@punitcode as varchar(200),
    @pdateformat as	varchar(200),
    @pextra1 as	varchar(200),
    @pextra2 as varchar(200)
 AS
	select * from cir_route_mast
	where comp_code=@pcompcode and 
	unit=@punitcode and
	ISNULL(freeze_flag,'N')='N'
	and ((upper(ROUTE_NAME) like upper(@pextra1+'%')) or (@pextra1 = ''))
	order by route_name


///////////////////////////////////////////////////end////////////////////////////////////////

