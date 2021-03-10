////////////////////////////////////////6999///////////////ANKIT//////////////////////////


USE [abhi]
GO
/****** Object:  StoredProcedure [dbo].[cir_branch_bind_p1]    Script Date: 04/04/2012 17:57:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[cir_branch_bind_p1]
	@pcompcode                                VARCHAR(20) ,
	@pbranchcode                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(400)
AS 

		select "Branch_Code" , "Branch_Name" from branch_mst 
		where --("Comp_Code"=pcompcode or pcompcode is null) and  
       ( Branch_Name  like('%'+@pbranchcode+'%') or @pbranchcode is null or @pbranchcode='')



and ((upper(Branch_Name) like upper('%'+@pextra1+'%')) or (@pextra1 = ''))
	




///////////////////////////END/////////////////////////////////////////////////
///////////////////////////issue number 6824
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER procedure [dbo].[cir_fetch_incentive_data_p]
    @pcompcode       AS varchar(20),
    @punitcode       AS varchar(20),
    @pagtype         AS varchar(20),
    @pagclass        AS varchar(20),
    @psup_type       AS varchar(20),
    @pagcode         AS varchar(20),
    @pdepocode       AS varchar(20),
    @pcode           AS varchar(2000),
    @pprocesstype    AS varchar(20),--process by Zone.Region,Branch,District,Route
    @pdatefrom       AS datetime,
    @pdatetill       AS datetime,
    @pinct_type      AS varchar(20),--for supply or growth
    @pprocess_type   AS varchar(20),--for daily,weekly or monthly
    @psupply_days    AS numeric(5),--for auto or manual
    @pprocessid      AS numeric(30),
    @pdelimiter      AS varchar(20),
    @puserid         AS varchar(20),
    @pdateformat     AS varchar(20),
    @pextra1         AS varchar(200),
    @pextra2         AS varchar(200),
    @pextra3         AS varchar(200),
    @pextra4         AS varchar(200),
    @pextra5         AS varchar(200)
  As
	If @punitcode='' Begin
		set @punitcode=null
	End	
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
	If @pinct_type='' Begin
		set @pinct_type=null
	End
	If @pprocess_type='' Begin
		set @pprocess_type=null
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

	CREATE TABLE #CIR_LEDGER_REPORT
	( COMP_CODE			VARCHAR(100),
	  UNIT_CODE			VARCHAR(100),
	  DEBIT_HEAD		VARCHAR(100),
	  REC_SEQNO			INT)

	declare @vlength		numeric(7);
	declare @vrunval		varchar(4000);
	declare @v_val			varchar(800);
	declare @v_name			varchar(8000);
	declare @v_sname		varchar(4000);
	declare @vno			numeric(10)
	declare @v_doctype		varchar(10)
	set @v_doctype='CN'
	declare @v_recptdt		datetime
	declare @v_dt			datetime
	declare @v1_comp_code	varchar(20)
	declare @v1_unit_code	varchar(20)
	declare @v1_publ		varchar(20)
	declare @v1_edtn		varchar(20)
	declare @v1_sup_type_code	varchar(20)
	declare @v1_supdate		datetime
	declare @v1_agcd		varchar(20)
	declare @v1_dpcd		varchar(20)
	declare @v1_billagcd	varchar(20)
	declare @v1_billdpcd	varchar(20)
	declare @v1_ag_type		varchar(20)
	declare @v1_branch_code	varchar(20)
	declare @v1_sup_copy	numeric(10)
	declare	@i				int
	declare @v_sup_on_calc  numeric(8)
    declare @v_days         numeric(5)
    declare @v1_no_of_days	numeric(5)
    declare c1 cursor for
        select distinct a.comp_code comp_code,a.unit_code unit_code,a.publ publ,a.edtn edtn,a.sup_type_code sup_type_code,
        a.supdate supdate,a.agcd agcd,a.dpcd dpcd,a.billagcd billagcd,a.billdpcd billdpcd,d.ag_type ag_type,d.branch_code branch_code, 
        sum(a.sup_copy) sup_copy,count(distinct a.supdate) no_of_days
        from cir_dbksup a,cir_supply_type_mast c,cir_agmast d
        where a.comp_code = @pcompcode and a.comp_code = c.comp_code 
and a.comp_code = d.comp_code 
and               a.unit_code=isnull(@punitcode,a.unit_code) 
and a.unit_code=d.unit 
and        a.supdate >= @pdatefrom and a.supdate <=@pdatetill and a.sup_type_code =c.sup_ty_code and
              a.sup_type_code=isnull(@psup_type,a.sup_type_code) and  
              a.agcd = d.agcd and a.dpcd = d.dpcd and d.agcd = ISNULL(@pagcode,d.agcd) and d.dpcd = ISNULL(@pdepocode,d.dpcd) and 
              (d.ag_type =@pagtype or @pagtype is null) and (d.ag_class =@pagclass or @pagclass is null) and 
              ((d.dist_code in(select debit_head from #CIR_LEDGER_REPORT)) or @pcode is null) and 
              (a.billagcd is not null or a.billagcd<>'')
              group by a.comp_code,a.unit_code,a.publ,a.edtn,a.sup_type_code,a.supdate,a.agcd,a.dpcd,a.billagcd,a.billdpcd,d.ag_type,d.branch_code              
              order by a.comp_code,a.unit_code,a.supdate,a.publ,a.edtn,a.sup_type_code;
    
    declare @v_amt			numeric(15,2);
    declare @v_remark		varchar(500);
    declare @v_recptno		varchar(50);
    declare @v_dsign		numeric(5);
    
    declare @v_bran_code	varchar(20);
    declare @v_rec_no		numeric(10);  
    declare @v_unsold_copy	numeric(10);
    declare @vdistcode		varchar(4000);

    set @v_recptdt =  @pdatetill
    declare @v2_calc_type	varchar(20)
    declare @v2_inct_amt	numeric(15,2)
    declare @v2_supply_from	numeric(10)
    declare @v2_supply_till numeric(10)
    
    set @v_days=DATEDIFF(day,@pdatetill,@pdatefrom)
    
    set @v_days=@v_days+1
    /*if @pcode is not null Begin
        set @vdistcode=@pcode+','

        vlength :=null; v_val :=null; v_name:=null;vrunval :=null; vno:=null;
        v_val   :=replace(vdistcode,',',',');
        vlength :=length(v_val);vno:=1;

        for i in 1.. vlength loop
            vrunval:=substr(v_val,i,1);
            if vrunval!=',' then
                v_name:=v_name||vrunval;
            else
                insert into #CIR_LEDGER_REPORT(comp_code ,unit_code ,debit_head,credit_head,rec_seqno,sess_id)
                        values (pcompcode,punitcode,v_name,null,vno,userenv('sessionid'));
                vno:=vno+1;
                v_name:='';
            end if;
        end loop;
    end if;*/
	/*If @pcode is not null Begin 
		print('1')print(@pcode)
		set @vdistcode	= @pcode+@pdelimiter
		set @v_name		= null set @vrunval	= null set @vno		= 1
		set @v_val		= replace(@vdistcode,@pdelimiter,',')
		set @vlength	= len(@v_val) set @i = 1 
		print('2')
		WHILE @i <= @vlength Begin
			set @vrunval  = substring(@v_val, @i, 1)
			If @vrunval != ',' Begin
				set @v_name  = @v_name + @vrunval 
			End
			Else Begin 
				INSERT INTO #cir_ledger_report(comp_code,unit_code,debit_head,rec_seqno)  
				VALUES(@pcompcode,@punitcode,@v_name,@vno)  
				
				set @vno  = @vno + 1 
				set @v_name  = '' 
			End

			set @i = @i + 1
		End
	End*/
    open c1;
    fetch NEXT FROM c1 INTO @v1_comp_code, @v1_unit_code,@v1_publ,@v1_edtn,@v1_sup_type_code,@v1_supdate,@v1_agcd,@v1_dpcd,@v1_billagcd,@v1_billdpcd,@v1_ag_type,@v1_branch_code, @v1_sup_copy,@v1_no_of_days
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN

PRINT('FIRST')	
			If @psupply_days>0 Begin
				set @v_sup_on_calc=round((@v1_sup_copy/@v1_no_of_days),0)*@v_days
			End    
			else Begin
				set @v_sup_on_calc=@v1_sup_copy
			End
        
			select @v2_calc_type=calc_type,@v2_inct_amt=inct_amt,@v2_supply_from=supply_from,@v2_supply_till=supply_till
			from cir_inct_slab_temp where process_id=@pprocessid and comp_code=@v1_comp_code and unit_code=@v1_unit_code 
				and publ_code=@v1_publ and edtn_code=@v1_edtn
				and supply_type=@v1_sup_type_code and agency_type=@v1_ag_type -- and eff_date<=v1.supdate 
				and process_type=@pprocess_type and inct_type=@pinct_type 
				and ((branch_code is null or branch_code='' ) or (branch_code=@v1_branch_code))
				and @v_sup_on_calc between supply_from and supply_till


       
        If isnull(@v2_calc_type,'F')='P' Begin
			set @v_amt=(isnull(@v1_sup_copy,0)-isnull(@v_unsold_copy,0))*(isnull(@v2_inct_amt,0)/100)
        End    
        Else Begin
            set @v_amt=(isnull(@v1_sup_copy,0)-isnull(@v_unsold_copy,0))*isnull(@v2_inct_amt,0)
        End
        
        If isnull(@v_amt,0)<>0 and @v2_calc_type is not null Begin 
            insert into cir_inct_process_det_temp(comp_code,unit_code,publ_code,edtn_code,sup_type_code,from_pdate,till_pdate,
                            agcd,dpcd,tot_supply,from_supply,till_supply,inct_rate,calc_type,amount,
                            doctype,recptdt,recptno,bilagcd,bildpcd,created_by,tran_type,supply_on_calc,no_of_days)
                    values(@v1_comp_code,@v1_unit_code,@v1_publ,@v1_edtn,@v1_sup_type_code,@pdatefrom,@pdatetill,
                            @v1_agcd,@v1_dpcd,isnull(@v1_sup_copy,0),@v2_supply_from,@v2_supply_till,@v2_inct_amt,@v2_calc_type,@v_amt,
                            @v_doctype,@v_recptdt,@pprocessid,@v1_billagcd,@v1_billdpcd,@puserid,'INC',@v_sup_on_calc,@v1_no_of_days)
        End
        set @v_amt=0 set @v2_calc_type=null set @v2_inct_amt=0
		fetch NEXT FROM c1 INTO @v1_comp_code, @v1_unit_code,@v1_publ,@v1_edtn,@v1_sup_type_code,@v1_supdate,@v1_agcd,@v1_dpcd,@v1_billagcd,@v1_billdpcd,@v1_ag_type,@v1_branch_code, @v1_sup_copy,@v1_no_of_days
	End
	close c1
	deallocate c1
	

    select s.comp_code as "COMP_CODE",s.unit_code AS "UNIT_CODE",s.recptno as "RECPTNO",s.recptdt as "RECPTDT", s.bilagcd AS "AGCD",s.bildpcd AS "DPCD",m.ag_name AS "AG_NAME",
    dbo.cir_get_drop_point_name(s.comp_code,s.unit_code,m.station_code,1) as "DROP_POINT_NAME",dbo.cir_get_city(s.comp_code,m.city_code) as "CITY_NAME",
    s.doctype as "DOCTYPE",sum(s.tot_supply) as "SUPPLY",s.from_supply as "FROM_SUPPLY",s.till_supply AS "TILL_SUPPLY",
    s.publ_code as "PUBL_CODE" ,dbo.cir_get_publ_name(s.comp_Code,s.publ_code) as "PUBL_NAME",
    e.main_edtn AS "MAIN_EDTN", dbo.cir_get_edtn_name(s.comp_code,e.main_edtn) as "MAIN_EDTN_NAME",
    s.inct_rate AS "INCT_RATE",s.calc_type as "CALC_TYPE",sum(s.amount) as "AMOUNT",
    s.sup_type_code as "SUP_TYPE_CODE",dbo.cir_get_supply_name(s.comp_code,s.sup_type_code) as "SUP_TYPE_NAME",
    s.supply_on_calc as "SUPPLY_ON_CALC",s.no_of_days as "NO_OF_DAYS"
    from cir_inct_process_det_temp s,cir_agmast m,cir_edtn_mast e
    where s.comp_code=m.comp_code and s.comp_code=e.comp_code and s.edtn_code=e.edtn and 
    s.unit_code=m.unit and s.bilagcd=m.agcd and s.bildpcd=m.dpcd and s.recptno=@pprocessid and tran_type='INC'
    group by s.comp_code,s.unit_code,s.recptno,s.recptdt,s.doctype,s.inct_rate,s.calc_type,s.from_supply,s.till_supply,
    e.main_edtn,s.bilagcd,s.bildpcd,m.station_code,m.city_code,m.ag_name,s.sup_type_code,s.publ_code,
    s.supply_on_calc ,s.no_of_days
    having sum(amount)>0
    order by comp_code,unit_code,bilagcd,bildpcd,publ_name,main_edtn_name,sup_type_name
	
	delete from cir_inct_slab_temp where process_id=@pprocessid;      
	drop table #cir_ledger_report









///////////////////////////////////////////////////
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER procedure [dbo].[cir_expenses_cn_process_p]
    @pcompcode       as varchar(20),
    @punitcode       as varchar(20),
    @ppublcode       as varchar(20),
    @pagcode         as varchar(20),
    @pdepocode       as varchar(20),
    @pdatefrom       as datetime,
    @pdatetill       as datetime,
    @pdoctype        as varchar(20),
    @precptdt        as datetime,
    @precptno        as varchar(50),
    @preason         as varchar(50),
    @pexp_type_code  as varchar(50),
    @ptot_supply     as numeric(6),
    @premark         as varchar(500),
    @puserid         as varchar(20),
    @pdateformat     as varchar(20),
    @pextra1         as varchar(50),
    @pextra2         as varchar(50),
    @pextra3         as varchar(50),
    @pextra4         as varchar(50),
    @pextra5         as varchar(50)
  As
    declare @v_doctype		varchar(10)
    declare @v_dt			datetime
    declare @v_sess_id		varchar(30)
    declare @v2_comp_code	varchar(50)
    declare @v2_unit_code	varchar(50)
    declare @v2_publ_code	varchar(50)
    declare @v2_doctype		varchar(50)
    declare @v2_tot_supply  numeric(10)
    declare @v2_recptdt		datetime
    declare @v2_recptno		varchar(50)
    declare @v2_amount		numeric(15,2)
    declare @v2_bilagcd		varchar(50)
    declare @v2_bildpcd		varchar(50)
    declare @v2_exp_type_code	varchar(50)
    declare @v2_valid_days	numeric(10)
    declare @v2_cn_through	varchar(50)
    declare c2 cursor for
        select s.comp_code,s.unit_code,s.publ_code,s.doctype,s.exp_type_code exp_type_code,sum(s.tot_supply) tot_supply,s.recptdt,s.recptno,sum(s.amount) amount,
        s.bilagcd,s.bildpcd ,s.from_supply valid_days,s.cn_through cn_through 
        from cir_inct_process_det s,cir_agmast m 
        where s.comp_code=m.comp_code and s.comp_code=@pcompcode and s.unit_code=m.unit and s.unit_code=@punitcode and 
        s.bilagcd=m.agcd and (s.bilagcd=@pagcode or @pagcode is null or @pagcode='') and s.bildpcd=m.dpcd and (s.bildpcd= @pdepocode or @pdepocode is null or @pdepocode='') and
        s.recptno=@precptno and s.recptdt=@precptdt and s.exp_type_code=@pexp_type_code and s.tran_type='EXP'
        group by s.comp_code,s.unit_code,s.doctype,s.exp_type_code,s.recptdt,s.recptno,s.bilagcd,s.bildpcd,s.publ_code,s.from_supply,s.cn_through
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
    insert into cir_inct_process_det
        (comp_code, unit_code, publ_code, edtn_code,sup_type_code, from_pdate,till_pdate, agcd, dpcd, tot_supply, inct_rate,calc_type, doctype, recptdt, recptno, amount, bilagcd, bildpcd, created_by, created_date, updated_by, updated_date, 
        exp_type_code,reason,tran_type,from_supply,cn_through)
        select comp_code, unit_code, publ_code, edtn_code,sup_type_code, from_pdate,till_pdate, agcd, dpcd, @ptot_supply tot_supply, inct_rate,calc_type, doctype, recptdt, recptno, case when calc_type='P' then round(isnull(@ptot_supply,0)*isnull(inct_rate,0),2) else isnull(inct_rate,0) end amount, 
        bilagcd, bildpcd, created_by, created_date, updated_by, updated_date,
        exp_type_code,reason,tran_type,from_supply,cn_through
        from cir_inct_process_det_temp where comp_code=@pcompcode and unit_code=@punitcode and 
            bilagcd=@pagcode and bildpcd= @pdepocode and recptno=@precptno and recptdt=@precptdt and exp_type_code=@pexp_type_code and publ_code=@ppublcode and tran_type='EXP' and @ptot_supply>0
            
    If @pdoctype is null or @pdoctype='' Begin
        set @v_doctype='CN'
    End    
    Else Begin
        set @v_doctype=@pdoctype
    End
        
   set @v_amt=0

   open c2
		fetch NEXT FROM c2 INTO @v2_comp_code,@v2_unit_code,@v2_publ_code,@v2_doctype,@v2_exp_type_code,@v2_tot_supply,@v2_recptdt,@v2_recptno,@v2_amount,@v2_bilagcd,@v2_bildpcd,@v2_valid_days,@v2_cn_through 
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
            set @v_remark='Being amount auto credited against Expenses charges'
        End    
        Else Begin
            set @v_remark=@premark
        End
		
		If @v2_cn_through='D' Begin
			SELECT @v_rec_no  =  CAST( MAX(SUBSTRING(recptno, 5, 8))AS NUMERIC) + 1 FROM  cir_rcphdr 
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
									 @v_recptno,@v2_recptdt,@v_amt,isnull(@preason,'EXPENSES CHARGES'),@v_remark,
									 'NM',@v_recptno,@v2_recptdt,@puserid,getdate(),@v_bran_code)
			  insert into cir_rcpdet(comp_code,unit_code,agcd,dpcd,doctyp,publ,
									 recptno,recptdt,payfor,achd,amount,
									 reason,remark,voucherno,voucherdt,usrid,
									 creation_date,branch_code)
							  values(@v2_comp_code, @v2_unit_code,@v2_bilagcd, @v2_bildpcd,@v2_doctype,@v2_publ_code,
									 @v_recptno,@v2_recptdt,@v2_unit_code,'NM',@v_amt,
									 isnull(@preason,'EXPENSES CHARGES'),@v_remark,@v_recptno,@v2_recptdt,@puserid,
									 getdate(),@v_bran_code);
			  insert into cir_outmast(comp_code,unit_code,agcd,dpcd,doctyp,publ,
									  recptno,recptdt,achd,amount,reason,
									  remark,voucherno,voucherdt,usrid,creation_date,branch_code)
							   values(@v2_comp_code, @v2_unit_code,@v2_bilagcd, @v2_bildpcd,@v2_doctype,@v2_publ_code,
									  @v_recptno,@v2_recptdt,'NM',@v_amt,isnull(@preason,'EXPENSES CHARGES'),
									  @v_remark,@v_recptno,@v2_recptdt,@puserid,getdate(),@v_bran_code)                               
			End
			Else Begin
				SELECT @v_rec_no  =  CAST( MAX(SUBSTRING(recptno, 5, 8))AS NUMERIC) + 1
				FROM  cir_rcphdr_prov
				WHERE comp_code  = @pcompcode AND doctype  = @pdoctype
				AND CONVERT(VARCHAR(23), recptdt) = CONVERT(VARCHAR(23), @v2_recptdt) AND branch_code  = @v_bran_code
				
				IF ISNULL(@v_rec_no, 0)= 0 BEGIN 
					SET @v_recptno  = @v_bran_code + '-P' + REPLACE(CONVERT(VARCHAR(5), GETDATE(), 2), '.', '')+ '0001' 
				END
				ELSE BEGIN 
					SET @v_recptno  = @v_bran_code + '-P' + dbo.fnPadLeft('0',8,@v_rec_no) 
				END
		    
				  insert into cir_rcphdr_prov(comp_code,unit_code,agcd,dpcd,doctype,
										 recptno,recptdt,amount,reason,remark,
										 achd,userid,creation_date,branch_code,ocds)
								  values(@v2_comp_code, @v2_unit_code,@v2_bilagcd, @v2_bildpcd,@v2_doctype,
										 @v_recptno,@v2_recptdt,@v_amt,isnull(@preason,'EXPENSES CHARGES'),@v_remark,
										 'NM',@puserid,getdate(),@v_bran_code,cast(@v2_valid_days as numeric))			
			End
			
			update cir_inct_process_det set recptno=@v_recptno
				where comp_code=@v2_comp_code and unit_code=@v2_unit_code and doctype=@v2_doctype and recptno=@precptno and 
                  recptdt=@v2_recptdt and from_pdate = @pdatefrom and till_pdate = @pdatetill and bilagcd = @v2_bilagcd and bildpcd = @v2_bildpcd and publ_code=@v2_publ_code and exp_type_code=@v2_exp_type_code and tran_type='EXP';
    
	        delete from cir_inct_process_det_temp        
		        where comp_code=@v2_comp_code and unit_code=@v2_unit_code and doctype=@v2_doctype and recptno=@precptno and 
			          recptdt=@v2_recptdt and from_pdate = @pdatefrom and till_pdate = @pdatetill and bilagcd = @v2_bilagcd and bildpcd = @v2_bildpcd and publ_code=@v2_publ_code and exp_type_code=@v2_exp_type_code and tran_type='EXP';
                  
       fetch NEXT FROM c2 INTO @v2_comp_code,@v2_unit_code,@v2_publ_code,@v2_doctype,@v2_exp_type_code,@v2_tot_supply,@v2_recptdt,@v2_recptno,@v2_amount,@v2_bilagcd,@v2_bildpcd,@v2_valid_days,@v2_cn_through
   End
   close c2;
	deallocate c2
   delete from cir_inct_process_det_temp where comp_code=@pcompcode and unit_code=@punitcode and 
            bilagcd=@pagcode and bildpcd= @pdepocode and recptno=@precptno and recptdt=@precptdt and publ_code=@ppublcode and exp_type_code=@pexp_type_code and tran_type='EXP';
            
   select getdate() as "CUR_DATE" 
   
End

///////////////////////////////////////end of 6824



------------------------------------------------- UPDATED BY NITISH -----------------------------------


-----------------------------
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


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
@RO_OUTSTAND_P AS VARCHAR(5),
@genrate_agency_code AS VARCHAR(5),
@p_dispauditbk AS VARCHAR(5),
@p_aotosupply  AS VARCHAR(5),
@p_Authorization as VARCHAR(1),
@p_CIR_AUTO_APPROVAL_UNSOLD AS VARCHAR(5),
@p_CIR_AUTO_PHYSICAL_UNSOLD AS VARCHAR(5),
@p_CIR_UNSOLD_INCLUDE_INCT AS VARCHAR(5),
@p_CIR_UNSOLD_INCLUDE_INSFEE AS VARCHAR(5),
@p_CIR_UNSOLD_ON_RECEIVED_DT AS VARCHAR(5),
@p_AGENCY_UNBLOCK_APPROVAL AS VARCHAR(5),
@p_UNBLOCK_APPROVAL_OUTSIDE_LIMIT AS VARCHAR(5),
@p_CIR_BILL_PUBLWISE AS VARCHAR(5),
@paging         AS VARCHAR(4000) ,
@print          AS VARCHAR(4000) ,
@allowpage      AS VARCHAR(4000) ,
@agency_req     AS VARCHAR(4000) ,
@region_req     AS VARCHAR(4000) ,
@p_ALLOW_FOLLOW_DT_BOOOK as varchar(1),
@p_CRM_SUPPLY_TYPE_PAID   as varchar(10),
@p_CRM_SUPPLY_TYPE_FREE   as varchar(10),
@p_CURRENCY_MEASUREMENT   as varchar(5),

@p_EDITABLE_AGENCY_COMM as varchar(1),
@p_CANCELLATION_CHARGE as varchar(1),
@P_taxi_entry_type     as VARCHAR(1),
@P_ApprovalWith          as VARCHAR(1),
@p_Auto_TDS_Credit_Note as varchar(1),
@p_TDS_Reason as varchar(10),
@p_Debit_Account_Head as varchar(10),
@p_credit_Account_Head as varchar(10),
@p_service_tax_credit_note as varchar(1),
@p_Tax_Reason as varchar(10),
@p_Debit_Account_Service_Tax as varchar(10),
@p_Credit_Account_Service_Tax as varchar(10),
@p_Auto_Patrakar_Credit_Note as varchar(1),
@p_Patrakar_Reason as varchar(10),
@p_Debit_Account_Patrakar as varchar(10),
@p_Credit_Account_Patrakar as varchar(10),
@p_Auto_Bank_Credit_Note as varchar(1),
@p_Bank_Reason as VARCHAR(10),
@p_Debit_Account_Bank as varchar(10),
@p_Credit_Account_Bank as varchar(10),
@P_BAR_CODE as VARCHAR(5),
@P_WEIGHT_CAL as VARCHAR(5)

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

ALLOWED_PDC_DAYS_RECEIPT=@P_ALLOW_PDC,AD_TYPE_MANUL_BILL=@PAD_TYPE_FOR_MANUL_BILL,OUTSTANDING_AMT_CRITERIA=@RO_OUTSTAND_P,GENRATE_CIR_AGCD=@genrate_agency_code,DISP_AUDITBKG=@p_dispauditbk,CIR_DIS_AUTO_POSTING=@p_aotosupply,RELAUTHREQON=@p_Authorization,
CIR_AUTO_APPROVAL_UNSOLD=@p_CIR_AUTO_APPROVAL_UNSOLD,CIR_AUTO_PHYSICAL_UNSOLD=@p_CIR_AUTO_PHYSICAL_UNSOLD,CIR_UNSOLD_INCLUDE_INCT=@p_CIR_UNSOLD_INCLUDE_INCT,
CIR_UNSOLD_INCLUDE_INSFEE=@p_CIR_UNSOLD_INCLUDE_INSFEE,CIR_UNSOLD_ON_RECEIVED_DT=@p_CIR_UNSOLD_ON_RECEIVED_DT,AGENCY_UNBLOCK_APPROVAL=@p_AGENCY_UNBLOCK_APPROVAL,UNBLOCK_APPROVAL_OUTSIDE_LIMIT=@p_UNBLOCK_APPROVAL_OUTSIDE_LIMIT,CIR_BILL_PUBLWISE=@p_CIR_BILL_PUBLWISE,
RECORDS_ON_PAGE = @paging,RECORDS_ON_PRINT = @print,HEADER_ON_PAGE = @allowpage,AGENCY_REQUIRED = @agency_req,REGION_REQUIRED = @region_req,ALLOW_FOLLOW_DT_BOOOK=@p_ALLOW_FOLLOW_DT_BOOOK,CRM_SUPPLY_TYPE_PAID=@p_CRM_SUPPLY_TYPE_PAID,CRM_SUPPLY_TYPE_FREE=@p_CRM_SUPPLY_TYPE_FREE,CURRENCY_MEASUREMENT=@p_CURRENCY_MEASUREMENT,EDITABLE_AGENCY_COMM =@p_EDITABLE_AGENCY_COMM,CANCELLATION_CHARGE =@p_CANCELLATION_CHARGE,taxi_entry_type=@P_taxi_entry_type,APPROVAL_WITH =@P_ApprovalWith,

TDS_AUTO_CN=@p_Auto_TDS_Credit_Note,
TDS_AUTO_REASON=@p_TDS_Reason ,TDS_DB_CDP=@p_Debit_Account_Head,TDS_CR_CDP=@p_credit_Account_Head,SER_TAX_AUTO_CN=@p_service_tax_credit_note,SER_TAX_AUTO_REASON=@p_Tax_Reason,SER_TAX_DB_CDP=@p_Debit_Account_Service_Tax,SER_TAX_CR_CDP=@p_Credit_Account_Service_Tax,PKK_AUTO_CN=@p_Auto_Patrakar_Credit_Note,PKK_AUTO_REASON=@p_Patrakar_Reason ,PKK_DB_CDP=@p_Debit_Account_Patrakar,PKK_CR_CDP=@p_Credit_Account_Patrakar ,BANK_CHG_AUTO_CN=@p_Auto_Bank_Credit_Note ,
BANK_CHG_AUTO_REASON=@p_Bank_Reason ,BANK_CHG_DB_CDP=@p_Debit_Account_Bank ,BANK_CHG_CR_CDP=@p_Credit_Account_Bank,

 CIR_BARCODE= @P_BAR_CODE,CIR_WIEGHT_CALC_REQ= @P_WEIGHT_CAL

 
 WHERE comp_code=@compcode




/* ,
',Unsold_Entry_Flag='''+@Unsoldflag+''',Supply_Stop_Percentage='''+@Supplystopper+'''

,ROKEYCHECK='''+@drpRokeychk+''',AGENCYCOMM_SEQ_COM='''+@Agencycomm_seq+''' ,CREDIT_RECIPT='''+@creditreciept+''' where    comp_code='''+@compcode+'''   ' 



--,DISP_CASHBILL='''+@cashindisplay+''',CLA_CASHBILL='''+@cashinclassified+'''
*/

print(@query1)
exec(@query1)

-----------------------------------------

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER PROCEDURE [dbo].[currbindpreferpgld]
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
ALLOWED_PDC_DAYS_RECEIPT,AD_TYPE_MANUL_BILL, OUTSTANDING_AMT_CRITERIA as RO_OUTSTAND,GENRATE_CIR_AGCD,DISP_AUDITBKG,CIR_DIS_AUTO_POSTING,RELAUTHREQON,
CIR_AUTO_APPROVAL_UNSOLD, CIR_AUTO_PHYSICAL_UNSOLD, CIR_UNSOLD_INCLUDE_INCT, CIR_UNSOLD_INCLUDE_INSFEE, CIR_UNSOLD_ON_RECEIVED_DT,AGENCY_UNBLOCK_APPROVAL,UNBLOCK_APPROVAL_OUTSIDE_LIMIT,CIR_BILL_PUBLWISE,RECORDS_ON_PAGE,RECORDS_ON_PRINT,HEADER_ON_PAGE,AGENCY_REQUIRED,REGION_REQUIRED,ALLOW_FOLLOW_DT_BOOOK,CRM_SUPPLY_TYPE_PAID,CRM_SUPPLY_TYPE_FREE,CURRENCY_MEASUREMENT,Space_area,EDITABLE_AGENCY_COMM,CANCELLATION_CHARGE,TAXI_ENTRY_TYPE,APPROVAL_WITH,   TDS_AUTO_CN,TDS_AUTO_REASON,TDS_DB_CDP,TDS_CR_CDP,SER_TAX_AUTO_CN,SER_TAX_AUTO_REASON,SER_TAX_DB_CDP,SER_TAX_CR_CDP,PKK_AUTO_CN,PKK_AUTO_REASON,PKK_DB_CDP,PKK_CR_CDP,BANK_CHG_AUTO_CN,BANK_CHG_AUTO_REASON,BANK_CHG_DB_CDP,BANK_CHG_CR_CDP ,


CIR_BARCODE,CIR_WIEGHT_CALC_REQ

           FROM PREFERRENCES
          WHERE comp_code = @compcode


=========================================================== END BY NITISH ==================================

---------------------updated by shipra---------

USE [abhi]
GO
/****** Object:  StoredProcedure [dbo].[websp_loginemployee]    Script Date: 04/06/2012 19:24:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









ALTER  PROCEDURE [dbo].[websp_loginemployee]
@username varchar(50),
@password varchar(10),
@qbc varchar(8)=null

AS
declare @query as varchar(2000)
declare @count as varchar(100)
declare @query1 as varchar(2000)
declare @query2 as varchar(2000)
declare @userid varchar(100)

if(@qbc=null or @qbc='')
begin
set @query='select username,password,userid,date_format,com_code,autogenerate,curr_code  ,comp_name, datediff(dd,creation_datetime,getdate()) as diff,DISCOUNT,FILTER,ROLEID,retainer_code AS RETAINER          from login where userid='''+@username+''' and password='''+@password+''' and STATUS ! = ''I'''

select @count=com_code from login where userid=@username and password=@password
/*new change ankur for agency*/
set @query1='SELECT rate_gr_code,autogenerated,currency_code,date_format,solo,No_of_Decimal,
        breakup,blackwhitecode,uom_code,rostatus,Tfn,Insert_breakup,Premium_type,Deal_type     ,
        prefix,suffix,financestatus,voucherst,Ad_category,Ro_datetime,Space_area,Vat,Booking_status,Cio_id,Receipt_no,Bgcolor_publication, chkfor_valid_pubdates,Agency_ratecode,audit,copy_booking,RATE_COMPANY_AGENCY,SUBEDITIONRATE,ADDITIONAL_AGENCY_COMM,AGENCY_RETAINER_COMM,

        invoice_no,rate_audit,CLS_BILLTYPE,DIS_BILLTYPE,BILLING_FORMAT, RATE_CHECK, ALL_PACKAGE,DAYRATE,SCHEME_TYPE,DISP_CLSBILL,RECEIPT_FORMAT,CASH_RECEIPT_BILL, BILL_ORDERWSLAST, FLOOR_CHK,ROKEYCHECK,
		DISP_CASHBILL, CLA_CASHBILL,RATE_AUDIT_PREF,FA_LEDGER_ALLOW,CLEARANCE_TYPE_ALLOW,DISP_AUDITBKG,CIR_AUTO_PHYSICAL_UNSOLD,ALLOW_FOLLOW_DT_BOOOK

  from preferrences where comp_code= '''+@count+'''' 
select @userid=userid from login where username=@username and  password=@password  and com_code=@count

set @query2='select company_user,Admin from login where userid='''+@username+''''

end
else
begin
set @query='select username,password,userid,date_format,com_code,autogenerate,curr_code  ,comp_name  , datediff(dd,creation_datetime,getdate()) as diff,DISCOUNT,FILTER ,ROLEID ,retainer_code   AS RETAINER     from login where userid='''+@username+''' and password='''+@password+''' and retainer_code='''+@qbc+''' and STATUS ! = ''I'''

select @count=com_code from login where userid=@username and password=@password and retainer_code=@qbc

/*new change ankur for agency*/
set @query1='SELECT rate_gr_code,autogenerated,currency_code,date_format,solo,No_of_Decimal,
        breakup,blackwhitecode,uom_code,rostatus,Tfn,Insert_breakup,Premium_type,Deal_type     ,
        prefix,suffix,financestatus,voucherst,Ad_category,Ro_datetime,Space_area,Vat,Booking_status,Cio_id,Receipt_no,Bgcolor_publication, chkfor_valid_pubdates,Agency_ratecode,audit,copy_booking,RATE_COMPANY_AGENCY,SUBEDITIONRATE,ADDITIONAL_AGENCY_COMM,AGENCY_RETAINER_COMM,

        invoice_no,rate_audit,CLS_BILLTYPE,DIS_BILLTYPE,BILLING_FORMAT, RATE_CHECK, ALL_PACKAGE,DAYRATE,SCHEME_TYPE,DISP_CLSBILL,RECEIPT_FORMAT,CASH_RECEIPT_BILL, BILL_ORDERWSLAST, FLOOR_CHK,ROKEYCHECK,
		DISP_CASHBILL, CLA_CASHBILL,RATE_AUDIT_PREF,FA_LEDGER_ALLOW,CLEARANCE_TYPE_ALLOW,DISP_AUDITBKG,CIR_AUTO_PHYSICAL_UNSOLD,ALLOW_FOLLOW_DT_BOOOK,CIR_BARCODE,CIR_WIEGHT_CALC_REQ
		 from preferrences where comp_code= '''+@count+''''

select @userid=userid from login where username=@username and  password=@password  and com_code=@count

set @query2='select company_user,Admin from login where userid='''+@username+''''
end


print(@query)
exec(@query)

print(@query1)
exec(@query1)


print(@query2)
exec(@query2)

------------------------------end by shipra-----------------------------------------------------------------------------------------

///////////////ISSUE NUMBER 7179
                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE [dbo].[CIR_SUPPLY_POST_FOR_NEXT_DAY_cir_supply_posting_p]
	@pcomp_code			VARCHAR(20) ,
	@punit_code			VARCHAR(20) ,
	@ppubl_code         VARCHAR(20) ,
	@pedtn_code         VARCHAR(20) ,
	@pagcd				VARCHAR(20) ,
	@pdpcd				VARCHAR(20) ,
	@puserid			VARCHAR(20) ,
	@psup_date			varchar(500) ,
	--@psup_date1       VARCHAR(20),
	@psup_ty			VARCHAR(20) ,
	@pdateformat		VARCHAR(20) ,
	@pextra1			VARCHAR(20) ,
	@pextra2			VARCHAR(20), --issue date
	@pper_copy_wt		numeric(15,3)
AS 
DECLARE  @vsup_date   DATETIME
DECLARE  @vh_date1    DATETIME
DECLARE  @vh_name1    VARCHAR(500)

DECLARE cur_holiday cursor  LOCAL FOR 
		select h_date,h_name from cir_holiday_mast
			where comp_code=@pcomp_code and unit=@punit_code and 
				h_publ=@ppubl_code and h_date=@vsup_date and 
				ISNULL(freeze_flag,'N')='N';

DECLARE @vedtn1			VARCHAR(500)
DECLARE @vedtn_name1    VARCHAR(500)

DECLARE	@v_spl_rate    NUMERIC(10,4)
SET @v_spl_rate = 0

   
/*************        DECLARE VARIABLES FOR cur_supply  CURSOR        *****************/

DECLARE  @vunit1				VARCHAR(500)
DECLARE  @vagcd1				VARCHAR(500)
DECLARE  @vdpcd1				VARCHAR(500)
DECLARE  @vpubl1				VARCHAR(500)
DECLARE  @vedtn11				VARCHAR(500)
DECLARE  @vsupply_type_code1	VARCHAR(500)
DECLARE  @vbase_supply1			numeric(7,0)
DECLARE  @vsupply_sun1			numeric(7,0)
DECLARE  @vsupply_mon1			numeric(7,0)
DECLARE  @vsupply_tue1			numeric(7,0)
DECLARE  @vsupply_wed1			numeric(7,0)
DECLARE  @vsupply_thu1			numeric(7,0)
DECLARE  @vsupply_fri1			numeric(7,0)
DECLARE  @vsupply_sat1			numeric(7,0)
DECLARE  @vsupply_spl11			numeric(7,0)
DECLARE  @vsupply_spl21			numeric(7,0)
DECLARE  @vag_type1				VARCHAR(500)
DECLARE  @vsupply_start_dt1		VARCHAR(500)
DECLARE  @vsuspend_date1		VARCHAR(500)
DECLARE  @vpacket_size1			VARCHAR(500)
DECLARE  @vcomm_code1			VARCHAR(500)
DECLARE  @vcomm_flag1			VARCHAR(500)
DECLARE  @vbill_agcd1			VARCHAR(500)
DECLARE  @vroute_code1			VARCHAR(500)
DECLARE  @vsubroute_code1		VARCHAR(500)
DECLARE  @vsub_subroute_code1	VARCHAR(500)
DECLARE  @vsurch_cd1			VARCHAR(500)

DECLARE  @vbill_dpcd1			VARCHAR(500)
DECLARE @v_supply_copy_dt		varchar(20)
/*****************************************************************************************/

set @psup_date	=dbo.convert_user_date('/',@psup_date,@pdateformat)
set @pextra2	=dbo.convert_user_date('/',@pextra2,@pdateformat)

if @pextra1 is not null begin
	set @v_supply_copy_dt=dbo.convert_user_date('/',@pextra1,@pdateformat)
end


DECLARE cur_surcharge cursor LOCAL FOR 
            select * from cir_surcharge_mast 
            where comp_code  =@pcomp_code and 
                  unit       =@punit_code and
                  publ       =@ppubl_code and
                  edtn       =@vedtn1 and
                  surch_cd   =@vsurch_cd1 and 
                  valid_from = (select max(valid_from) from cir_surcharge_mast 
                                            where comp_code  =@pcomp_code and 
                                                  unit       =@punit_code and
                                                  publ       =@ppubl_code and
                                                  edtn       =@vedtn1 and
                                                  surch_cd   =@vsurch_cd1 and
                                                  valid_from<=@psup_date);
DECLARE	@v_sup_copy			NUMERIC(7)
DECLARE @v_edtn_rate		NUMERIC(10,4)
DECLARE @vreccnt			NUMERIC(5,0)
DECLARE @v_old_sup_copy		NUMERIC(7)

   
/*********************       SEND CONVERTED DATE FROM SQL CLASS     ************/
-- vsup_date:=to_date(psup_date,''''||pdateformat||'''');
SET  @vsup_date = @psup_date

/*******************************************************************************/

open cur_holiday;
fetch NEXT FROM cur_holiday into @vh_date1 , @vh_name1
close cur_holiday
    
if (@vsup_date=@vh_date1) BEGIN
	PRINT('Please Check The  Holiday Today Is  '+' '+   @vh_name1)
	PRINT('Please Check The  Holiday Today Is  '+' '+   @vh_name1)
end 
    
if ((@vsup_date<>@vh_date1) or @vh_date1 is null) BEGIN

	DECLARE cir_edtn_cur cursor LOCAL FOR 
          select distinct edtn,edtn_name from cir_edtn_mast 
			where comp_code=@pcomp_code and publ = @ppubl_code and
		     ((ISNULL(main_edtn,edtn) = @pedtn_code) or (@pedtn_code is null) or (@pedtn_code='')) and ISNULL(freeze_flag,'N')='N'
  
		open cir_edtn_cur
		fetch NEXT FROM cir_edtn_cur into @vedtn1 , @vedtn_name1
		WHILE @@FETCH_STATUS = 0 BEGIN
              
        delete from cir_dbksup where comp_code=@pcomp_code and unit_code=@punit_code and
			publ=@ppubl_code and edtn=@vedtn1 and supdate=@vsup_date and 
			(agcd=@pagcd or @pagcd is null OR @pagcd='') and (dpcd=@pdpcd or @pdpcd is null OR @pdpcd='')

		/*************DECLARE VARIABLES FOR cur_spl_rate  CURSOR        *****************/

		DECLARE  @vspl_day_rate1    FLOAT

		/*****************************************************************************************/     
					        
		DECLARE cur_spl_rate cursor LOCAL FOR
			select spl_day_rate from cir_special_rate_mast
			where comp_code=@pcomp_code and unit=@punit_code and
				publ=@ppubl_code and edtn=@vedtn1 and spl_day_date=@vsup_date;


		open cur_spl_rate
		fetch NEXT FROM cur_spl_rate into @vspl_day_rate1;
		close cur_spl_rate;
        
        deallocate cur_spl_rate
        
  		if (ISNULL(@vspl_day_rate1,0)=0 )BEGIN

			 DECLARE  @vsun_rate1   FLOAT
			 DECLARE  @vmon_rate1   FLOAT
			 DECLARE  @vtue_rate1   FLOAT
			 DECLARE  @vwed_rate1   FLOAT
			 DECLARE  @vthu_rate1   FLOAT
			 DECLARE  @vfri_rate1   FLOAT
			 DECLARE  @vsat_rate1   FLOAT
							 

			DECLARE cur_rate cursor LOCAL FOR 
				select sun_rate,mon_rate,tue_rate,wed_rate,thu_rate,fri_rate,sat_rate from cir_rate_mast
				where comp_code=@pcomp_code and unit=@punit_code and publ=@ppubl_code and edtn=@vedtn1 and
				valid_from=(select max(valid_from) from cir_rate_mast where comp_code=@pcomp_code and
				unit=@punit_code and publ=@ppubl_code and edtn=@vedtn1 and valid_from<=@vsup_date and 
				ISNULL(freeze_flag,'N')='N');
			
			open cur_rate;
			fetch NEXT FROM cur_rate into @vsun_rate1, @vmon_rate1, @vtue_rate1, @vwed_rate1, @vthu_rate1, @vfri_rate1, @vsat_rate1
			close cur_rate;
					
			deallocate  cur_rate;
                  
			DECLARE @SUP_DAY11    varchar(20)
			SET @SUP_DAY11 = CONVERT(VARCHAR(20) , DATENAME(WEEKDAY, @psup_date),20)

			if (@SUP_DAY11 = 'Sunday' )begin          
				set  @v_edtn_rate      =    @vsun_rate1 ;
            end

			else if (@SUP_DAY11 = 'Monday') begin
				set  @v_edtn_rate      =    @vmon_rate1;
			end
			else if (@SUP_DAY11 = 'Tuesday')begin 
				set  @v_edtn_rate      =    @vtue_rate1;
			end
			else if (@SUP_DAY11 = 'Wednesday') begin
				set  @v_edtn_rate      =    @vwed_rate1;
            end
			else if (@SUP_DAY11 = 'Thursday')begin
				set  @v_edtn_rate      =    @vthu_rate1;
			end
			else if (@SUP_DAY11 = 'Friday' )begin
				set  @v_edtn_rate      =    @vfri_rate1;
			end
			else if (@SUP_DAY11 = 'Saturday')begin
				set  @v_edtn_rate      =    @vsat_rate1;
			end
			else begin
				set @v_edtn_rate        =    0
			end 
		end
		else begin
			set @v_edtn_rate  =  @v_spl_rate;
		end 
		
		if (@v_edtn_rate=0)begin
			print('Please Check,The Rate Today Is not Define for '+' '+  @vedtn_name1)
		end 

		DECLARE  cur_supply cursor LOCAL FOR 
		select a.unit unit,a.agcd agcd,a.dpcd dpcd,a.publ publ,a.edtn edtn,a.supply_type_code supply_type_code,a.base_supply base_supply,a.supply_sun supply_sun,
		a.supply_mon supply_mon,a.supply_tue supply_tue,a.supply_wed supply_wed,
		a.supply_thu supply_thu,a.supply_fri supply_fri,a.supply_sat supply_sat,a.supply_spl1 supply_spl1,
		a.supply_spl2 supply_spl2, b.ag_type ag_type,b.supply_start_dt    supply_start_dt,b.suspend_date suspend_date, ISNULL(a.packet_size,0) packet_size,
		a.comm_code comm_code,a.comm_flag comm_flag,b.bill_agcd bill_agcd,b.bill_dpcd bill_dpcd,
		a.route_code route_code,a.subroute_code subroute_code,a.sub_subroute_code sub_subroute_code,
		a.surch_cd surch_cd
		from cir_supply a,cir_agmast b
		where a.comp_code=b.comp_code and a.unit=b.unit and 
				  a.agcd=b.agcd and a.dpcd=b.dpcd and (a.agcd=@pagcd or @pagcd is null or @pagcd='') 
				  and (a.dpcd=@pdpcd or @pdpcd is null OR @pdpcd='') and 
				  a.unit=@punit_code and (a.publ=@ppubl_code) and
				  ISNULL(base_supply,0)>0 and
				  a.edtn=@vedtn1 and
				  ISNULL(a.supply_flag,'N')='Y' and ISNULL(b.suspend,'N')='N'
		order by a.agcd,a.dpcd,a.edtn,a.supply_type_code;


		 open cur_supply 

		 fetch next from cur_supply into @vunit1 ,@vagcd1 ,@vdpcd1 ,@vpubl1 ,@vedtn11 ,@vsupply_type_code1,@vbase_supply1,
		 @vsupply_sun1 ,@vsupply_mon1 ,@vsupply_tue1 ,@vsupply_wed1 ,@vsupply_thu1 ,@vsupply_fri1,@vsupply_sat1 ,@vsupply_spl11,
		 @vsupply_spl21, @vag_type1 ,@vsupply_start_dt1, @vsuspend_date1 ,@vpacket_size1 ,@vcomm_code1 ,@vcomm_flag1 ,@vbill_agcd1 ,@vbill_dpcd1,
		 @vroute_code1 ,@vsubroute_code1 ,@vsub_subroute_code1 ,@vsurch_cd1 
	       
         
		SET @vsup_date= CONVERT(VARCHAR(10),@vsup_date,10)
                 
		WHILE @@FETCH_STATUS = 0 begin
			
			DECLARE @SUP_DAY112    varchar(20)
 
            SET  @SUP_DAY112 = CONVERT(VARCHAR(20) , DATENAME(WEEKDAY, @vsup_date),20)
			
			if (@vsup_date>=@vsupply_start_dt1 or @vsupply_start_dt1 is null) and (@vsup_date<=@vsuspend_date1 or @vsuspend_date1 is null) begin 
				if (@psup_ty='R' and @SUP_DAY112 = 'Sunday' ) begin   
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_sun1,0)>0  begin
					
						set @v_sup_copy   =  ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_sun1,0);
													    
                    end
					else begin
						set @v_sup_copy   = 0;
					end 
				end
				else if (@psup_ty='R' and @SUP_DAY112 = 'Monday') begin    
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_mon1,0)>0 begin
					
						set @v_sup_copy    =     ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_mon1,0);
					
					end
					else begin
						set @v_sup_copy    = 0
					end
				end
				else if (@psup_ty='R' and @SUP_DAY112 = 'Tuesday')begin  
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_tue1,0)>0 begin
						set  @v_sup_copy  =  ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_tue1,0);
					end
					else begin
						set @v_sup_copy       = 0;
                    end 
				end
				else if (@psup_ty='R' and @SUP_DAY112 = 'Wednesday') begin   
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_wed1,0)>0 begin 
						
						set @v_sup_copy =  ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_wed1,0)
						
	                end
					else begin
						set @v_sup_copy  = 0
					end 
				end 
				else if (@psup_ty='R' and @SUP_DAY112 = 'Thursday')begin   
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_thu1,0)>0 begin
						set @v_sup_copy  = ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_thu1,0)
					end
                    else begin
						set @v_sup_copy  = 0
                    end 
				end   
				else if (@psup_ty='R' and @SUP_DAY112 = 'Friday' )begin   
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_fri1,0)>0 begin
				
						set @v_sup_copy   =  ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_fri1,0);
                
                    end                
					else
						set @v_sup_copy   = 0
                    end 
				else if (@psup_ty='R' and @SUP_DAY112 = 'Saturday') begin    
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_sat1,0)>0 begin
						set @v_sup_copy   =  ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_sat1,0);
                    end
					else begin
						set @v_sup_copy   = 0
					end
				end 
				else if @psup_ty='S1' begin    
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_spl11,0)>0 begin
						
						set @v_sup_copy   =     ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_spl11,0);
                                                              
					end
					else begin
						set @v_sup_copy   = 0
                                                               													end
					end 
				else if @psup_ty='S2' begin    
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_spl21,0)>0 begin
					
						set @v_sup_copy   =     ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_spl21,0);
                    
                    end
                    else begin
						set @v_sup_copy   = 0
                    end 
				end

			--------change for supply copy--------
					           
            if @psup_ty='R' and @v_supply_copy_dt is not null begin
                set @v_old_sup_copy=0;
                select @v_old_sup_copy = sum(sup_copy) from cir_dbksup where comp_code=@pcomp_code and unit_code=@punit_code and publ=@ppubl_code and edtn=@vedtn11 and
                    agcd=@vagcd1 and dpcd=@vdpcd1 and supdate=@v_supply_copy_dt and sup_type_code=@vsupply_type_code1;
   
            end

            if isnull(@v_old_sup_copy,0)>0 begin
                set @v_sup_copy=@v_old_sup_copy;
            end
           
            --------change for supply copy--------
					            
			if ISNULL(@v_sup_copy,0)>0 Begin
				print('22tytr')
				print( @v_sup_copy)
				
				insert into cir_dbksup (comp_code,unit_code,publ,edtn,agcd,dpcd,supdate,sup_type_code,sup_copy,agency_ty_code,
										agency_pkt_size,comm_code,comm_fix_auto_spl,sup_rate,billagcd,billdpcd,
										route_code,subroute_code,subsubroute_code,userid,surch_cd,issue_date,per_copy_weight)
								values (@pcomp_code,@punit_code,@ppubl_code,@vedtn11,@vagcd1,@vdpcd1,@vsup_date,
									 @vsupply_type_code1,
									 @v_sup_copy,@vag_type1,@vpacket_size1,@vcomm_code1,@vcomm_flag1,
									 @v_edtn_rate,@vbill_agcd1,@vbill_dpcd1,@vroute_code1,
									 @vsubroute_code1,@vsub_subroute_code1,@puserid,@vsurch_cd1,@pextra2,@pper_copy_wt);

				select @vreccnt	= count(*)  from cir_dbksup where comp_code=@pcomp_code and unit_code=@punit_code 
				and publ=@ppubl_code and edtn=@vedtn1 and supdate=@vsup_date and (agcd=@pagcd or @pagcd is null) and (dpcd=@pdpcd or @pdpcd is null);
					               
			End;                     
		end 

         fetch next from cur_supply into @vunit1 ,@vagcd1 ,@vdpcd1 ,@vpubl1 ,@vedtn11 ,@vsupply_type_code1,@vbase_supply1,
		 @vsupply_sun1 ,@vsupply_mon1 ,@vsupply_tue1 ,@vsupply_wed1 ,@vsupply_thu1 ,@vsupply_fri1,@vsupply_sat1 ,@vsupply_spl11,
		 @vsupply_spl21, @vag_type1 ,@vsupply_start_dt1, @vsuspend_date1 ,@vpacket_size1 ,@vcomm_code1 ,@vcomm_flag1 ,@vbill_agcd1 ,@vbill_dpcd1,
		 @vroute_code1 ,@vsubroute_code1 ,@vsub_subroute_code1 ,@vsurch_cd1 

	end 
	close cur_supply;
	deallocate cur_supply
	   
	set @v_edtn_rate = 0;
	set @v_spl_rate  =0;
	set @vedtn1=NULL;

fetch NEXT FROM cir_edtn_cur into @vedtn1 , @vedtn_name1
end
close cir_edtn_cur
deallocate  cir_edtn_cur  
end 
  
    select case b.bill_pay
              when 'Y' then 'PAID'
              when 'N' then 'UNPAID'
              else  'UNPAID' 
              end  BILL_PAY,
   sum(a.sup_copy) SUP_COPY
    from cir_dbksup a,cir_supply_type_mast b,CIR_EDTN_MAST e
    where a.comp_code=@pcomp_code and a.comp_code=b.comp_code and a.comp_code=e.comp_code and  a.unit_code=@punit_code and 
          a.publ=@ppubl_code and a.publ = e.publ and a.edtn= e.edtn and 
          (ISNULL(e.main_edtn,e.edtn) = @pedtn_code or @pedtn_code is null OR  @pedtn_code='') and 
          a.sup_type_code=b.sup_ty_code and a.supdate=@vsup_date and 
          (a.agcd=@pagcd or @pagcd is null OR @pagcd='') and (a.dpcd=@pdpcd or @pdpcd is null or @pdpcd ='')
    group by b.bill_pay
    order by b.bill_pay desc
  
deallocate cur_holiday
deallocate cur_surcharge 

///////////////////END OF ISSUE NUMBER 7179/////////////UPDATEBY Garima


//-----------------------------------start 10/04/2012--------------------------------//

create procedure [dbo].[cir_auto_process_supply_final](
       @pcompcode     as varchar(20),
       @punit		  as varchar(20),
       @ppub          as varchar(20),
       @pedtn         as varchar(20),
       @puserid		  as varchar(20),
       @pdateformat   as varchar(20),
       @pextra1		  as varchar(20),
	   @pextra2		  as varchar(20),
	   @pextra3		  as varchar(20),
	   @pextra4		  as varchar(20),
	   @pextra5		  as varchar(20),
	   @pextra6		  as varchar(20),
	   @pextra7		  as varchar(20),
	   @pextra8		  as varchar(20),
       @pextra9		  as varchar(20),
       @pextra10	  as varchar(20)
       )
   As
Begin
declare @psupdate as datetime 
 
 set @psupdate=convert(varchar(10),getdate(),101)
 set @psupdate=convert(varchar(10),'01/22/2012',101)
	print(@psupdate)
	
	
	--select * from cir_dbksup where comp_code=@pcompcode 
	--and (publ=@ppub or @ppub is null or @ppub ='')
	--and (unit_code=@punit or @punit is null or @punit ='')
	--and (edtn=@pedtn or @pedtn is null or @pedtn ='')
	--and supdate=@psupdate
	
	update cir_dbksup set final_supply_flag ='Y' where comp_code=@pcompcode 
	and (publ=@ppub or @ppub is null or @ppub ='')
	and (unit_code=@punit or @punit is null or @punit ='')
	and (edtn=@pedtn or @pedtn is null or @pedtn ='')
	and supdate=@psupdate 



End  


//----------------------------------end--------------------------------------//

////////////////////////////////update by Garima ///////////7182
                                                                     
                                                                     
                                                                     
                                             
create procedure cir_rep_weekly_bill_print
    @pcompcode        as varchar(20),
    @punitcode        as varchar(20),
    @pagencytype      as varchar(20),
    @pagencyclass     as varchar(20),
    @pbranchcode      as varchar(20),
    @pdistcode        as varchar(20),
    @ptaluka          as varchar(20),
    @pbillagcd        as varchar(20),
    @pbilldpcd        as varchar(20),
    @pfrom_date       as datetime,
    @ptill_date       as datetime,
    @plangtype        as varchar(20),
    @pdateformat      as varchar(20),
    @pextra1          as varchar(200),
    @pextra2          as varchar(200)
As
    declare @v_dt    datetime
    
	declare @rec_bill_comp_code		varchar(20)
	declare @rec_bill_unit_code		varchar(20)
	declare @rec_bill_billdt		datetime
	declare @rec_bill_billno		varchar(30)
	declare @rec_bill_publ			varchar(20)
	declare @rec_bill_billagcd		varchar(20)
	declare @rec_bill_billdpcd		varchar(20)
	declare @rec_bill_frdt			datetime
	declare @rec_bill_todt			datetime

    DECLARE cur_agcd CURSOR FOR
        select distinct d.comp_code comp_code,d.unit_code unit_code,d.billdt billdt,d.billno billno,null publ,d.agcd billagcd,d.dpcd billdpcd,bill_frdt frdt,bill_todt todt  
        from cir_agmast m,cir_bill d 
        where d.comp_code=@pcompcode and d.comp_code=m.comp_code and d.unit_code=m.unit and d.unit_code=@punitcode and 
        d.billdt between @pfrom_date and @ptill_date and 
        m.agcd=d.agcd and m.dpcd=d.dpcd and d.agcd=isnull(@pbillagcd,d.agcd) and d.dpcd=isnull(@pbilldpcd,d.dpcd) and 
        (m.ag_type=@pagencytype or @pagencytype is null) and (m.ag_class=@pagencyclass or @pagencyclass is null) and (m.dist_code=@pdistcode or @pdistcode is null) and 
        (m.tehsil_taluka=@ptaluka or @ptaluka is null) 
        group by d.comp_code,d.unit_code,d.agcd,d.dpcd,d.billdt,d.billno,d.bill_frdt,d.bill_todt
        order by d.comp_code,d.unit_code,d.billdt,d.billno,d.agcd,d.dpcd;       
    
    declare @v_return_copy     int
    declare @v_return_amt      numeric(14,2)
    declare @v_gross_amt       numeric(15,2)
	declare @v_comm_rate       numeric(15,6)
    declare @v_comm_amt        numeric(15,2)
	declare @v_sur_rate        numeric(15,6)
    declare @v_sur_amt         numeric(15,2)    
	declare @v_opdate          datetime;
	declare @v_opbal           numeric(14,2)
	declare @v_billamt         numeric(14,2)
    declare @v_dbcramt         numeric(14,2)
	declare @v_dbamt           numeric(14,2)
	declare @v_cramt           numeric(14,2)
	declare @v_recamt          numeric(14,2)   
	declare @v_secamt          numeric(14,2)
	declare @v_psecamt         numeric(14,2)
	declare @v_csecamt         numeric(14,2)
Begin
    If @punitcode='' Begin
		set @punitcode=null
	End
    If @pagencytype='' Begin
		set @pagencytype=null
	End
    If @pagencyclass='' Begin
		set @pagencyclass=null
	End
    If @pbranchcode='' Begin
		set @pbranchcode=null
	End
    If @pdistcode='' Begin
		set @pdistcode=null
	End
    If @ptaluka='' Begin
		set @ptaluka=null
	End
    If @pbillagcd='' Begin
		set @pbillagcd=null
	End							
    If @pbilldpcd='' Begin
		set @pbilldpcd=null
	End
    If @pextra1='' Begin
		set @pextra1=null
	End
    If @pextra2='' Begin
		set @pextra2=null
	End

	CREATE TABLE #CIR_TEMP_OUTSTANDING(
	COMP_CODE	varchar(8) ,
	UNIT_CODE	varchar(8) ,
	DT			datetime ,
	PUBL_CODE	varchar(8) ,
	AGCD		varchar(8) ,
	DPCD		varchar(8) ,
	BILL_AMT	numeric(15, 2) DEFAULT ((0)),
	RETURN_AMT	numeric(15, 2) DEFAULT ((0)),
	DN_AMT		numeric(15, 2) DEFAULT ((0)),
	CN_AMT		numeric(15, 2) DEFAULT ((0)),
	REC_AMT		numeric(15, 2) DEFAULT ((0)),
	AGNAME		varchar(200) ,
	AGNAME_OTH_LANG varchar(250),
	CITY_CODE	varchar(20),
	TALUKA_CODE varchar(20),
	DIST_CODE	varchar(20),
	STATE_CODE	varchar(20),
	COUNTRY_CODE varchar(20),
	OP_AMT		numeric(15, 2))
	CREATE TABLE #CIR_BILL_PRINT 
	(COMP_CODE	VARCHAR (8) , 
	UNIT_CODE	VARCHAR (8) , 
	BILLNO		VARCHAR (20) , 
	BILLDT		DATETIME  , 
	PUBL_CODE	VARCHAR (8) , 
	EDTN_CODE	VARCHAR (8) , 
	AGCD		VARCHAR (8) , 
	DPCD		VARCHAR (8) , 
	SUPPLY_DATE DATETIME  , 
	SUPPLY_COPY NUMERIC (10) , 
	SUPPLY_RATE NUMERIC (10, 2) , 
	COMM_RATE	NUMERIC (12, 2) , 
	SUR_RATE	NUMERIC (10, 2) , 
	RETURN_COPY NUMERIC (10) , 
	RETURN_AMT	NUMERIC (14, 2) , 
	CUR_SESSIONID NUMERIC  , 
	GROSS_AMT	NUMERIC (15, 2) DEFAULT  0 , 
	COMM_AMT	NUMERIC (15, 5) DEFAULT  0 , 
	SUR_AMT		NUMERIC (15, 2) , 
	SEC_AMT		NUMERIC (15, 2) DEFAULT  0 , 
	BRANCH_CODE VARCHAR (8) , 
	REC_AMT		NUMERIC (15, 2) DEFAULT  0 )
	
	CREATE TABLE #CIR_BILL_RETURN_PRINT 
	(COMP_CODE		VARCHAR (8) , 
	 UNIT_CODE		VARCHAR (8) , 
	 BRANCH_CODE	VARCHAR (8) , 
	 BILLNO			VARCHAR (20) , 
	 BILLDT			DATETIME  , 
	 PUBL_CODE		VARCHAR (8) , 
	 EDTN_CODE		VARCHAR (8) , 
	 AGCD			VARCHAR (8) , 
	 DPCD			VARCHAR (8) , 
	 RECEIPT_DATE	DATETIME  , 
	 RETURN_COPY	NUMERIC (10) , 
	 SUPPLY_RATE	NUMERIC (10, 2) , 
	 COMM_RATE		NUMERIC (12, 2) , 
	 SUR_RATE		NUMERIC (10, 2) , 
	 GROSS_AMT		NUMERIC (15, 2) DEFAULT  0 , 
	 COMM_AMT		NUMERIC (15, 5) DEFAULT  0 , 
	 SUR_AMT		NUMERIC (15, 2) DEFAULT  0 , 
	 CUR_SESSIONID	NUMERIC  DEFAULT  @@SPID )

    set @v_opdate  =dbo.cir_get_finandt(@pcompcode,@pfrom_date,@pdateformat,null,null);

    open cur_agcd
        FETCH NEXT FROM cur_agcd into @rec_bill_comp_code,@rec_bill_unit_code,@rec_bill_billdt,@rec_bill_billno,@rec_bill_publ,@rec_bill_billagcd,@rec_bill_billdpcd,	@rec_bill_frdt,	@rec_bill_todt
		WHILE (@@FETCH_STATUS = 0) BEGIN
            set @v_opbal	=0
            set @v_billamt	=0
            set @v_dbcramt	=0 
            set @v_dbamt	=0 
            set @v_cramt	=0 
            set @v_recamt	=0
            set @v_secamt	=0
            set @v_psecamt	=0
            set @v_csecamt	=0

            set @v_opbal =dbo.cir_accounts_cir_agency_opbal(@rec_bill_comp_code,@rec_bill_unit_code,null,@rec_bill_billagcd,@rec_bill_billdpcd,@v_opdate,'NM',@pdateformat,null,null);
            
            select @v_billamt=sum(bill_amount) from cir_bill
                where comp_code=@rec_bill_comp_code and unit_code=@rec_bill_unit_code and
                      agcd=@rec_bill_billagcd and dpcd=@rec_bill_billdpcd and billdt >= @v_opdate and billdt<@pfrom_date;

            select @v_dbcramt=sum(amount) from cir_rcphdr
                where comp_code=@rec_bill_comp_code and unit_code=@rec_bill_unit_code and achd='NM' and doctype<>'BIL' and 
                      recptdt>= @v_opdate and recptdt<@pfrom_date and agcd=@rec_bill_billagcd and dpcd=@rec_bill_billdpcd;

            select @v_dbamt=sum(amount) from cir_rcphdr
                where comp_code=@rec_bill_comp_code and unit_code=@rec_bill_unit_code and achd='NM' and doctype not in('RCR','UCN') and
                      recptdt>= @pfrom_date and recptdt<=@ptill_date and agcd=@rec_bill_billagcd and dpcd=@rec_bill_billdpcd and amount>0;

            select @v_cramt=sum(amount) from cir_rcphdr
                where comp_code=@rec_bill_comp_code and unit_code=@rec_bill_unit_code and achd='NM' and doctype not in('RCR','UCN') and
                      recptdt>= @pfrom_date and recptdt<=@ptill_date and agcd=@rec_bill_billagcd and dpcd=@rec_bill_billdpcd and amount<0;

            select @v_recamt=sum(amount) from cir_rcphdr
                where comp_code=@rec_bill_comp_code and unit_code=@rec_bill_unit_code and achd='NM' and doctype='RCR' and 
                      recptdt>= @pfrom_date and recptdt<=@ptill_date and agcd=@rec_bill_billagcd and dpcd=@rec_bill_billdpcd;

            set @v_opbal=isnull(@v_opbal,0)+isnull(@v_billamt,0)+isnull(@v_dbcramt,0);
            set @v_dbcramt=0
            
            ----for secutiry opening balance---
            set @v_dbcramt =dbo.cir_accounts_cir_agency_opbal(@rec_bill_comp_code,@rec_bill_unit_code,null,@rec_bill_billagcd,@rec_bill_billdpcd,@v_opdate,'SC',@pdateformat,null,null);
            
            select @v_psecamt=sum(amount) from cir_rcphdr
                where comp_code=@rec_bill_comp_code and unit_code=@rec_bill_unit_code and achd='SC' and
                      recptdt>=@v_opdate and recptdt<=@ptill_date and agcd=@rec_bill_billagcd and dpcd=@rec_bill_billdpcd;
            
            set @v_secamt=isnull(@v_dbcramt,0)+isnull(@v_psecamt,0)
            
            select @v_csecamt=abs(SUM(sec_amt)) from cir_bill_print
                where comp_code=@rec_bill_comp_code and unit_code=@rec_bill_unit_code and agcd=@rec_bill_billagcd and dpcd=@rec_bill_billdpcd and 
                supply_date >= @pfrom_date and supply_date<=@ptill_date;
            
            set @v_secamt=isnull(@v_secamt,0)-isnull(@v_csecamt,0)
            set @v_dbcramt=0
            
            select @v_dbcramt=SUM(isnull(gross_amt,0)-isnull(comm_amt,0)+isnull(sur_amt,0)-isnull(return_amt,0)+isnull(sec_amt,0)) from #cir_bill_print
                where comp_code=@rec_bill_comp_code and unit_code=@rec_bill_unit_code and agcd=@rec_bill_billagcd and dpcd=@rec_bill_billdpcd and 
                supply_date >= @pfrom_date and supply_date<@ptill_date;            
            
            set @v_opbal=isnull(@v_opbal,0)+isnull(@v_dbcramt,0)
            
            insert into cir_temp_outstanding(comp_code,unit_code,dt,agname,publ_code,
            agcd,dpcd,dn_amt,cn_amt,rec_amt,op_amt,return_amt)
            values(@rec_bill_comp_code,@rec_bill_unit_code,@ptill_date,dbo.cir_get_name_cir_agname(@rec_bill_comp_code,@rec_bill_unit_code,@rec_bill_billagcd,@rec_bill_billdpcd,1,@pdateformat,null,null) ,@rec_bill_publ,
            @rec_bill_billagcd,@rec_bill_billdpcd,@v_dbamt,@v_cramt,@v_recamt,@v_opbal,@v_secamt);

            --set @v_dt=@rec_bill_frdt
            /*Loop
                if v_dt>@rec_bill_todt Begin
                    exit;
                end*/

			WHILE (0 = 0)
				BEGIN 
					IF @v_dt >= @rec_bill_todt BEGIN 
						BREAK
					END
					ELSE BEGIN 
						IF @v_dt is null BEGIN 
							SET @v_dt  = @rec_bill_frdt 
						END
						ELSE BEGIN 
							SET @v_dt  = @v_dt + 1 
						END
		   			END            

				declare @rec_edtn_publ	varchar(20)
				declare @rec_edtn_edtn	varchar(20)
			    
				DECLARE cur_edtn CURSOR FOR
				select x.publ publ,x.edtn edtn from(select distinct publ,edtn from cir_bill_det
					where comp_code=@rec_bill_comp_code and unit_code=@rec_bill_unit_code and billdt=@rec_bill_billdt and billno=@rec_bill_billno and
						  agcd=@rec_bill_billagcd and dpcd=@rec_bill_billdpcd
					union
					select distinct publ,edtn
					from cir_unsold_dtl
					where comp_code=@rec_bill_comp_code and unit_code=@rec_bill_unit_code and 
						  app_dt>=@pfrom_date and app_dt<=@ptill_date and agcd=@rec_bill_billagcd and dpcd=@rec_bill_billdpcd and (isnull(apr_late_recpt,0)+isnull(apr_short_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))>0)x
						  order by publ,edtn;
						  
					open cur_edtn;
						FETCH NEXT FROM cur_edtn into @rec_edtn_publ,@rec_edtn_edtn
						WHILE (@@FETCH_STATUS = 0) BEGIN

						declare @rec_dbksup_comp_code	varchar(20)
						declare @rec_dbksup_unit_code	varchar(20)
						declare @rec_dbksup_publ		varchar(20)
						declare @rec_dbksup_edtn		varchar(20)
						declare @rec_dbksup_copy_rate	numeric(15,4)
						declare @rec_dbksup_supdate		datetime
						declare @rec_dbksup_supply_copy	int
						
						DECLARE cur_dbksup cursor for
							select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,d.edtn edtn,d.sup_rate copy_rate,d.supdate,sum(d.sup_copy) supply_copy
							from cir_dbksup d,cir_supply_type_mast t 
							where d.comp_code=@rec_bill_comp_code and d.comp_code=t.comp_code and d.unit_code=@rec_bill_unit_code and 
								  d.supdate=@v_dt and d.sup_type_code=t.sup_ty_code and upper(t.bill_pay)='Y' and d.billagcd=@rec_bill_billagcd and 
								  d.billdpcd=@rec_bill_billdpcd and isnull(d.sup_copy,0)>0 and d.edtn=@rec_edtn_edtn
						group by d.comp_code,d.unit_code,d.publ,d.edtn,d.sup_rate,d.supdate
						order by d.comp_code,d.unit_code,d.publ,d.edtn,d.supdate;
					    
						Open cur_dbksup;
						FETCH NEXT FROM cur_dbksup into @rec_dbksup_comp_code,@rec_dbksup_unit_code,@rec_dbksup_publ,@rec_dbksup_edtn,
							@rec_dbksup_copy_rate,@rec_dbksup_supdate,@rec_dbksup_supply_copy
						WHILE (@@FETCH_STATUS = 0) BEGIN
							If @rec_dbksup_comp_code is null or @rec_dbksup_comp_code='' Begin
								set @v_comm_rate   =0 
								set @v_sur_rate    =0
								set @v_gross_amt   =0
								set @v_comm_amt    =0
								set @v_sur_amt     =0

								insert into #cir_bill_print(comp_code,unit_code,billno,billdt,publ_code,edtn_code,agcd,dpcd,
														   supply_date,supply_copy,supply_rate,gross_amt,comm_rate,comm_amt,sur_rate,sur_amt,
														   return_copy,return_amt)
								 values(@rec_bill_comp_code,@rec_bill_unit_code,@rec_bill_billno,@rec_bill_billdt,@rec_dbksup_publ,@rec_dbksup_edtn,@rec_bill_billagcd,@rec_bill_billdpcd,
											 @v_dt,0,0,@v_gross_amt,@v_comm_rate,@v_comm_amt,@v_sur_rate,@v_sur_amt,
											 isnull(@v_return_copy,0),isnull(@v_return_amt,0));
											 set @v_return_copy=0
											 set @v_return_amt=0
							End                                     
						else Begin
							set @v_comm_rate   =0
							set @v_sur_rate    =0

							set @v_gross_amt   =isnull((@rec_dbksup_supply_copy*@rec_dbksup_copy_rate),0)
							set @v_comm_amt    =isnull((@rec_dbksup_supply_copy*(@v_comm_rate/100)),0)
							set @v_sur_amt     =isnull((@rec_dbksup_supply_copy*@v_sur_rate),0)

							insert into #cir_bill_print(comp_code,unit_code,billno,billdt,publ_code,edtn_code,agcd,dpcd,
													   supply_date,supply_copy,supply_rate,gross_amt,comm_rate,comm_amt,sur_rate,sur_amt,
													   return_copy,return_amt)
							 values(@rec_bill_comp_code,@rec_bill_unit_code,@rec_bill_billno,@rec_bill_billdt,@rec_dbksup_publ,@rec_dbksup_edtn,@rec_bill_billagcd,@rec_bill_billdpcd,
										 @rec_dbksup_supdate,@rec_dbksup_supply_copy,@rec_dbksup_copy_rate,@v_gross_amt,@v_comm_rate,@v_comm_amt,@v_sur_rate,@v_sur_amt,
										 isnull(@v_return_copy,0),isnull(@v_return_amt,0));
										 set @v_return_copy=0
										 set @v_return_amt=0
						End                                     
						   FETCH NEXT FROM cur_dbksup into @rec_dbksup_comp_code,@rec_dbksup_unit_code,@rec_dbksup_publ,@rec_dbksup_edtn,
							@rec_dbksup_copy_rate,@rec_dbksup_supdate,@rec_dbksup_supply_copy
						end
					Close cur_dbksup;

					declare @rec_unsold_comp_code	varchar(20)
					declare @rec_unsold_unit_code	varchar(20)
					declare @rec_unsold_publ		varchar(20)
					declare @rec_unsold_edtn		varchar(20)
					declare @rec_unsold_recptdt		datetime
					declare @rec_unsold_copy_rate	numeric(15,4)
					declare @rec_unsold_return_copy	int
					declare @rec_unsold_return_comm	numeric(15,2)
					declare @rec_unsold_return_gross	numeric(15,2)
					DECLARE cur_unsold cursor for
						select comp_code,unit_code,publ,edtn,recptdt,copy_rate,sum(isnull(apr_late_recpt,0)+isnull(apr_short_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0)) return_copy,
						sum(isnull(copy_amt,0)+isnull(comm_amt,0)) return_gross,sum(isnull(comm_amt,0)) return_comm
						from cir_unsold_dtl
						where comp_code=@rec_bill_comp_code and unit_code=@rec_bill_unit_code and publ=@rec_edtn_publ and edtn=@rec_edtn_edtn and
							  app_dt=@v_dt and agcd=@rec_bill_billagcd and dpcd=@rec_bill_billdpcd and (isnull(apr_late_recpt,0)+isnull(apr_short_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))>0
					group by comp_code,unit_code,recptdt,publ,edtn,copy_rate
					order by comp_code,unit_code,recptdt,publ,edtn,copy_rate;
	    

	                
					Open cur_unsold;
						FETCH NEXT FROM cur_unsold into @rec_unsold_comp_code,@rec_unsold_unit_code,@rec_unsold_publ,@rec_unsold_edtn,
						@rec_unsold_recptdt,@rec_unsold_copy_rate,@rec_unsold_return_copy,@rec_unsold_return_comm
						WHILE (@@FETCH_STATUS = 0) BEGIN
	                    
							insert into cir_bill_return_print(comp_code,unit_code,billno,billdt,publ_code,edtn_code,agcd,dpcd,
													   receipt_date,return_copy,supply_rate,gross_amt,comm_rate,comm_amt,sur_rate,sur_amt)
							 values(@rec_bill_comp_code,@rec_bill_unit_code,@rec_bill_billno,@rec_bill_billdt,@rec_edtn_publ,@rec_edtn_edtn,@rec_bill_billagcd,@rec_bill_billdpcd,
										 @rec_unsold_recptdt,@rec_unsold_return_copy,@rec_unsold_copy_rate,@rec_unsold_return_gross,0,@rec_unsold_return_comm,0,0);
	                                     
										 set @v_return_copy=isnull(@v_return_copy,0)+isnull(@rec_unsold_return_copy,0)
	                                     
										 set @rec_unsold_recptdt	=null
										 set @rec_unsold_return_copy=null
										 set @rec_unsold_copy_rate	=null
						FETCH NEXT FROM cur_unsold into @rec_unsold_comp_code,@rec_unsold_unit_code,@rec_unsold_publ,@rec_unsold_edtn,
						@rec_unsold_recptdt,@rec_unsold_copy_rate,@rec_unsold_return_copy,@rec_unsold_return_comm                        
					end
					Close cur_unsold;
	                
					if isnull(@v_return_copy,0)=0 Begin
						insert into cir_bill_return_print(comp_code,unit_code,billno,billdt,publ_code,edtn_code,agcd,dpcd,
									receipt_date,return_copy,supply_rate,gross_amt,comm_rate,comm_amt,sur_rate,sur_amt)
						 values(@rec_bill_comp_code,@rec_bill_unit_code,@rec_bill_billno,@rec_bill_billdt,@rec_edtn_publ,@rec_edtn_edtn,@rec_bill_billagcd,@rec_bill_billdpcd,
									 @v_dt,0,0,0,0,0,0,0);     
	                        
					end
	                
					set @v_return_copy=0 set @v_return_amt=0
					FETCH NEXT FROM cur_edtn into @rec_edtn_publ,@rec_edtn_edtn
				  end
				  close cur_edtn
	              
				--set @v_dt=@v_dt+1
			End--close loop for date
			
			FETCH NEXT FROM cur_agcd into @rec_bill_comp_code,@rec_bill_unit_code,@rec_bill_billdt,@rec_bill_billno,@rec_bill_publ,@rec_bill_billagcd,@rec_bill_billdpcd,	@rec_bill_frdt,	@rec_bill_todt
        End
        Close cur_agcd;    
        
        select z.comp_code comp_code,z.unit_code unit_code,z.publ publ,z.edtn edtn,z.edition_name edition_name,
        z.edtn_rate edtn_rate,z.billagcd billagcd,z.billdpcd billdpcd,
        z.agency_name agency_name,y.addr1+' Tal.'+(dbo.cir_get_taluka(y.comp_code,y.tehsil_taluka))+' Dist.'+(dbo.cir_get_dist(y.comp_code,y.state_code,y.dist_code))+' Pin '+y.pin_code addr,
        z.sun as "SUN",z.mon as "MON",z.tue as "TUE",z.wed as "WED",z.thu as "THU",z.fri as "FRI",z.sat as "SAT",z.total_amt as "TOTAL_AMT"
        from(
        select x.comp_code,x.unit_code,x.publ,x.edtn,dbo.cir_get_name_cir_edtn(comp_code,unit_code,edtn,@plangtype,''''+@pdateformat+'''',null,null) edition_name,
        x.sup_rate edtn_rate,x.billagcd,x.billdpcd,
        dbo.cir_get_name_cir_agname(x.comp_code,x.unit_code,x.billagcd,x.billdpcd,@plangtype,''''+@pdateformat+'''',null,null) agency_name,
        sum(p01) as "SUN",sum(p02) as "MON",sum(p03) as "TUE",sum(p04) as "WED",sum(p05) as "THU",sum(p06) as "FRI",sum(p07) as "SAT",sum(gross_amt) as "TOTAL_AMT"
        from(select d.comp_code comp_code,d.unit_code unit_code,d.publ_code publ,d.edtn_code edtn,d.agcd billagcd,d.dpcd billdpcd,
        d.supply_date supdate,d.supply_rate sup_rate,
        case dbo.get_week_day(d.supply_date) when 'SUN' then sum(isnull(d.supply_copy,0)) else 0 end p01,
        case dbo.get_week_day(d.supply_date) when 'MON' then sum(isnull(d.supply_copy,0)) else 0 end p02,
        case dbo.get_week_day(d.supply_date) when 'TUE' then sum(isnull(d.supply_copy,0)) else 0 end p03,
        case dbo.get_week_day(d.supply_date) when 'WED' then sum(isnull(d.supply_copy,0)) else 0 end p04,
        case dbo.get_week_day(d.supply_date) when 'THU' then sum(isnull(d.supply_copy,0)) else 0 end p05,
        case dbo.get_week_day(d.supply_date) when 'FRI' then sum(isnull(d.supply_copy,0)) else 0 end p06,
        case dbo.get_week_day(d.supply_date) when 'SAT' then sum(isnull(d.supply_copy,0)) else 0 end p07,
        sum(isnull(d.supply_copy,0)*isnull(d.supply_rate,0)) gross_amt
        from cir_agmast m,cir_bill_print d 
        where d.comp_code=@pcompcode and d.comp_code=m.comp_code and d.unit_code=m.unit and d.unit_code=@punitcode and d.supply_date >= @pfrom_date and d.supply_date <=@ptill_date and 
        m.agcd=d.agcd and m.dpcd=d.dpcd and d.agcd=isnull(@pbillagcd,d.agcd) and d.dpcd=isnull(@pbilldpcd,d.dpcd) and (m.ag_type=@pagencytype or @pagencytype is null) and 
        (m.ag_class=@pagencyclass or @pagencyclass is null) and (m.dist_code=@pdistcode or @pdistcode is null) and (m.tehsil_taluka=@ptaluka or @ptaluka is null)--d.supply_copy>0)
        group by d.comp_code,d.unit_code,d.publ_code,d.edtn_code,d.agcd,d.dpcd,d.supply_date,d.supply_rate)x
        group by comp_code,unit_code,publ,edtn,billagcd,billdpcd,sup_rate) z,cir_agmast y
        where z.comp_code=y.comp_code and z.unit_code=y.unit and z.billagcd=y.agcd and z.billdpcd=y.dpcd
        order by comp_code,unit_code,billagcd,billdpcd,agency_name,publ,edtn;
    
        select comp_code,unit_code,dt billdt,agname billno,publ_code publ,agcd,dpcd,
        dn_amt as "Debit Amt",cn_amt as "Credit Amt",isnull(dn_amt,0)+isnull(cn_amt,0) as "Db_Cr Amt",ABS(rec_amt) as "Receipt Amount",op_amt as "Previous Balance",
        return_amt as "Deposit Balance"
        from cir_temp_outstanding
        order by comp_code,unit_code,agcd,dpcd,agname;    

        select distinct h.comp_code comp_code,h.unit_code unit_code,h.doctype+'\'+h.recptno recptno,h.recptdt recptdt,h.agcd agcd,h.dpcd dpcd,abs(h.amount) amount,
        case when h.doctype='RCR' then (select "Payment_Mode_Name" from payment_mode_mast where "Pay_Mode_Code"=h.reason)
        else (select reason_name from cir_reason_mst where comp_code=h.comp_code and reason_code=h.reason) end as reason,
        h.remark remark,h.chno chno,h.chdt chdt,(select bankname from cir_bank_mast where comp_code= h.comp_code and bankcode=h.chbank) bank_name
        from cir_rcphdr h,cir_bill_print d
        where h.comp_code=d.comp_code and h.comp_code=@pcompcode and h.unit_code=@punitcode  and h.unit_code=d.unit_code and h.recptdt >= @pfrom_date and h.recptdt<=@ptill_date and h.achd='NM' and h.amount<>0 and
        h.doctype in('RCR') and h.agcd=d.agcd and h.dpcd=d.dpcd and h.agcd=isnull(@pbillagcd,h.agcd) and h.dpcd=isnull(@pbilldpcd,h.dpcd) and h.branch_code=isnull(@pbranchcode,h.branch_code) and 
        d.supply_date >= @pfrom_date and d.supply_date<=@ptill_date
        order by agcd,dpcd,recptdt,recptno;
    
        select distinct d.comp_code comp_code,d.unit_code unit_code,d.agcd billagcd,d.dpcd billdpcd,
        DBO.cir_get_name_cir_agname(d.comp_code,d.unit_code,d.agcd,d.dpcd,@plangtype,''+@pdateformat+'',null,null) agency_name,
        sum(d.gross_amount) gross_amt,sum(d.comm_amt) comm_amt,sum(d.bill_amount) bill_amt
        from cir_agmast m,cir_bill_det d
        where d.comp_code=@pcompcode and d.comp_code=m.comp_code and d.unit_code=m.unit and d.unit_code=@punitcode and 
        d.billdt >= @pfrom_date and d.billdt <=@ptill_date and 
        m.agcd=d.agcd and m.dpcd=d.dpcd and d.agcd=isnull(@pbillagcd,d.agcd) and d.dpcd=isnull(@pbilldpcd,d.dpcd) and 
        (m.ag_type=@pagencytype or @pagencytype is null) and (m.ag_class=@pagencyclass or @pagencyclass is null) and (m.dist_code=@pdistcode or @pdistcode is null) and 
        (m.tehsil_taluka=@ptaluka or @ptaluka is null) 
        group by d.comp_code,d.unit_code,d.agcd,d.dpcd
        order by d.comp_code,d.unit_code,d.agcd,d.dpcd;
        
        select comp_code,unit_code,publ,edtn,DBO.cir_get_name_cir_edtn(comp_code,unit_code,edtn,@plangtype,''+@pdateformat+'','','') edition_name,sup_rate edtn_rate,billagcd,billdpcd,
        DBO.cir_get_name_cir_agname(comp_code,unit_code,billagcd,billdpcd,@plangtype,''+@pdateformat+'','','D') agency_name,
        sum(u01) as "SUN_RET",sum(u02) as "MON_RET",sum(u03) as "TUE_RET",sum(u04) as "WED_RET",sum(u05) as "THU_RET",sum(u06) as "FRI_RET",sum(u07) as "SAT_RET",
        sum(return_gross_amt) as "RET_GROSS_AMT",sum(ret_comm_amt) as "RET_COMM_AMT",isnull(sum(return_gross_amt),0)-isnull(sum(ret_comm_amt),0) as "RET_AMT"
        from(select d.comp_code comp_code,d.unit_code unit_code,d.publ_code publ,d.edtn_code edtn,d.agcd billagcd,d.dpcd billdpcd,
        d.receipt_date supdate,d.supply_rate sup_rate,
        case dbo.get_week_day(d.receipt_date) when 'SUN' then sum(isnull(d.return_copy,0)) else 0 end u01,
        case dbo.get_week_day(d.receipt_date) when 'MON' then sum(isnull(d.return_copy,0)) else 0 end u02,
        case dbo.get_week_day(d.receipt_date) when 'TUE' then sum(isnull(d.return_copy,0)) else 0 end u03,
        case dbo.get_week_day(d.receipt_date) when 'WED' then sum(isnull(d.return_copy,0)) else 0 end u04,
        case dbo.get_week_day(d.receipt_date) when 'THU' then sum(isnull(d.return_copy,0)) else 0 end u05,
        case dbo.get_week_day(d.receipt_date) when 'FRI' then sum(isnull(d.return_copy,0)) else 0 end u06,
        case dbo.get_week_day(d.receipt_date) when 'SAT' then sum(isnull(d.return_copy,0)) else 0 end u07,
        sum(isnull(d.return_copy,0)*isnull(d.supply_rate,0)) return_gross_amt,sum(comm_amt) ret_comm_amt
        from cir_agmast m,cir_bill_return_print d 
        where d.comp_code=@pcompcode and d.comp_code=m.comp_code and d.unit_code=m.unit and d.unit_code=@punitcode and d.receipt_date >= @pfrom_date and d.receipt_date <=@ptill_date and 
        m.agcd=d.agcd and m.dpcd=d.dpcd and d.agcd=isnull(@pbillagcd,d.agcd) and d.dpcd=isnull(@pbilldpcd,d.dpcd) and (m.ag_type=@pagencytype or @pagencytype is null) and 
        (m.ag_class=@pagencyclass or @pagencyclass is null) and (m.dist_code=@pdistcode or @pdistcode is null) and (m.tehsil_taluka=@ptaluka or @ptaluka is null)--d.supply_copy>0 and 
        group by d.comp_code,d.unit_code,d.publ_code,d.edtn_code,d.agcd,d.dpcd,d.receipt_date,d.supply_rate) x
        --where (isnull(u01,0)+isnull(u02,0)+isnull(u03,0)+isnull(u04,0)+isnull(u05,0)+isnull(u06,0)+isnull(u07,0))>0
        group by comp_code,unit_code,publ,edtn,billagcd,billdpcd,sup_rate
        order by comp_code,unit_code,billagcd,billdpcd,publ,edtn;

        select distinct d.comp_code comp_code,d.unit_code unit_code,d.agcd billagcd,d.dpcd billdpcd,min(bill_frdt) frdt,max(bill_todt) todt,
        m.addr1 addr1,m.addr2 addr2,m.addr3 addr3,m.city_code city_code,dbo.cir_get_city(d.comp_code,m.city_code) city_name,m.dist_code dist_code,
        dbo.cir_get_dist(d.comp_code,m.state_code,m.dist_code) dist_name, 
        m.state_code state_code,dbo.cir_get_state(d.comp_code,m.country_code,m.state_code)state_name, m.pin_code pin_code,m.country_code country_code  
        from cir_agmast m,cir_bill d 
        where d.comp_code=@pcompcode and d.comp_code=m.comp_code and d.unit_code=m.unit and d.unit_code=@punitcode and 
        d.billdt between @pfrom_date and @ptill_date and 
        m.agcd=d.agcd and m.dpcd=d.dpcd and d.agcd=isnull(@pbillagcd,d.agcd) and d.dpcd=isnull(@pbilldpcd,d.dpcd) and 
        (m.ag_type=@pagencytype or @pagencytype is null) and (m.ag_class=@pagencyclass or @pagencyclass is null) and (m.dist_code=@pdistcode or @pdistcode is null) and 
        (m.tehsil_taluka=@ptaluka or @ptaluka is null) 
        group by d.comp_code,d.unit_code,d.agcd,d.dpcd,m.addr1,m.addr2,m.addr3,m.city_code,m.dist_code,m.state_code,m.pin_code,m.country_code
        order by d.comp_code,d.unit_code,d.agcd,d.dpcd;
        
        select GETDATE() 
        select GETDATE() 
        select GETDATE() 
        select GETDATE() 
        select GETDATE() 
            
        DROP TABLE #cir_bill_print
        DROP TABLE #cir_bill_return_print
		DROP TABLE #CIR_TEMP_OUTSTANDING
End

///////////////////////////////////issue number 7182//////////////////////////////update by garima///////////////////end




//////////////////////issue number 7210///////////update by Garima////start
                                                                     
                                                                     
                                                                     
                                             
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
        substring(z.comm_rate,1,1) AS "COMM_CATEG_TYPE",substring(z.comm_rate,2,len(z.comm_rate)-1) AS "COMM_RATE",z.supply_copy AS "SUPPLY_COPY",z.rate_supply AS "RATE_SUPPLY", 
        z.RETURNABLE as "RETURNABLE",z.per_copy_weight per_copy_weight from--P30,C0.5
        (select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,p.publ_name publ_name,
        d.edtn edtn,edition_nick edtn_name,d.supdate supply_date,
        d.sup_rate copy_rate,d.comm_fix_auto_spl comm_fix_auto_spl,d.comm_code comm_code,
		dbo.cir_get_waste_rate(d.comp_code,d.unit_code,d.edtn,supdate,''''+@pdateformat+'''') waste_rate,
        dbo.cir_get_commission(d.comp_code,d.unit_code,d.publ,d.edtn,d.comm_fix_auto_spl ,d.comm_code,d.supdate,''''+@pdateformat+'''',sum(d.sup_copy),'','') comm_rate,
		'P' comm_catg_type, sum(d.sup_copy) supply_copy,sum(d.sup_copy) rate_supply,
		0 as RETURNABLE,d.per_copy_weight per_copy_weight
        from cir_dbksup_dis d,cir_publ_mast p,cir_edtn_mast e
        where d.comp_code=@pcomp_code and d.comp_code=p.comp_code and d.comp_code=e.comp_code and
              d.unit_code=@punit_code and d.publ=p.publ and d.publ=e.publ and
              (d.publ=@ppubl_code or @ppubl_code is null or @ppubl_code='') and
              d.edtn=e.edtn and (d.edtn = @pedtn_code or @pedtn_code is null or @pedtn_code='') and
            d.supdate between @psup_fromdate and @psup_todate and
            d.billagcd=@pagcd_code and d.billdpcd=@pdpcd_code and upper(isnull(@pextra1,'D'))='D'
            group by d.comp_code,d.unit_code,d.publ,p.publ_name,e.edition_nick,d.edtn,d.supdate,d.sup_rate,d.comm_fix_auto_spl,d.comm_code,d.per_copy_weight)z
        union
        select distinct z.comp_code AS "COMP_CODE",z.unit_code AS "UNIT_CODE",z.publ AS "PUBL",z.publ_name AS "PUBL_NAME",z.edtn AS "EDTN",z.edtn_name AS "EDTN_NAME",
		MAX(z.supply_date) AS "SUPPLY_DATE",dbo.GetLastDayOfMonth(z.supply_date) AS "SUPPLY_DATEMON",
        z.copy_rate AS "COPY_RATE",z.comm_fix_auto_spl AS "COMM_FIX_AUTO_SPL",z.comm_code AS "COMM_CODE",z.waste_rate AS "WASTE_RATE",
        z.comm_catg_type AS "COMM_CATEG_TYPE",z.comm_rate AS "COMM_RATE",sum(z.supply_copy) AS "SUPPLY_COPY",sum(z.supply_copy) rate_supply,
        z.RETURNABLE RETURNABLE,max(z.per_copy_weight) per_copy_weight from
        (select distinct y.comp_code,y.unit_code,y.publ,y.publ_name,y.edtn,y.edtn_name,y.supply_date,y.copy_rate,y.comm_fix_auto_spl,y.comm_code,y.waste_rate,
        substring(y.comm_rate,1,1) comm_catg_type,substring(y.comm_rate,2,len(y.comm_rate)-1) comm_rate,y.supply_copy,y.rate_supply ,
        y.RETURNABLE RETURNABLE,y.per_copy_weight per_copy_weight from--P30,C0.5
        (select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,p.publ_name publ_name,
        d.edtn edtn,edition_nick edtn_name,d.supdate supply_date,
        d.sup_rate copy_rate,d.comm_fix_auto_spl comm_fix_auto_spl,d.comm_code comm_code,
		dbo.cir_get_waste_rate(d.comp_code,d.unit_code,d.edtn,d.supdate,''''+@pdateformat+'''') waste_rate,
        dbo.cir_get_commission(d.comp_code,d.unit_code,d.publ,d.edtn,d.comm_fix_auto_spl ,d.comm_code,d.supdate,''''+@pdateformat+'''',sum(d.sup_copy),'','') comm_rate,'P' comm_catg_type, 
		sum(d.sup_copy) supply_copy,
        (select sum(u.sup_copy) from cir_dbksup_dis u where u.comp_code=d.comp_code and u.unit_code=d.unit_code and 
        (u.publ=d.publ) and u.edtn=d.edtn and u.supdate between @psup_fromdate and @psup_todate and 
        u.billagcd=@pagcd_code and u.billdpcd=@pdpcd_code and u.sup_rate=d.sup_rate) rate_supply,
        0 as RETURNABLE,d.per_copy_weight per_copy_weight
        from cir_dbksup_dis d,cir_publ_mast p,cir_edtn_mast e
        where d.comp_code=@pcomp_code and d.comp_code=p.comp_code and d.comp_code=e.comp_code and
              d.unit_code=@punit_code and d.publ=p.publ and d.publ=e.publ and
              (d.publ=@ppubl_code or @ppubl_code is null or @ppubl_code='') and
              d.edtn=e.edtn and (d.edtn = @pedtn_code or @pedtn_code is null or @pedtn_code='') and
            d.supdate between @psup_fromdate and @psup_todate and
            d.billagcd=@pagcd_code and d.billdpcd=@pdpcd_code and upper(isnull(@pextra1,'D'))='R'
            group by d.comp_code,d.unit_code,d.publ,p.publ_name,e.edition_nick,d.edtn,d.supdate,d.sup_rate,d.comm_fix_auto_spl,d.comm_code,d.per_copy_weight)y) z
            group by z.comp_code,z.unit_code,z.publ,z.publ_name,z.edtn,z.edtn_name,dbo.GetLastDayOfMonth(z.supply_date),
                z.copy_rate,z.comm_fix_auto_spl,z.comm_code,z.waste_rate,z.comm_catg_type,z.comm_rate,z.RETURNABLE
			order by publ_name,edtn,supply_date
	End
	Else Begin
            select z.comp_code AS "COMP_CODE",z.unit_code AS "UNIT_CODE",z.publ AS "PUBL",z.publ_name AS "PUBL_NAME",z.edtn AS "EDTN",z.edtn_name AS "EDTN_NAME",
			z.supply_date AS "SUPPLY_DATE",z.supply_date AS "SUPPLY_DATEMON",
            z.copy_rate AS "COPY_RATE",z.comm_fix_auto_spl AS "COMM_FIX_AUTO_SPL",z.comm_code AS "COMM_CODE",z.waste_rate AS "WASTE_RATE",
            substring(z.comm_rate,1,1) AS "COMM_CATEG_TYPE",substring(z.comm_rate,2,len(z.comm_rate)-1) AS "COMM_RATE",z.supply_copy AS "SUPPLY_COPY",z.rate_supply AS "RATE_SUPPLY",
            z.RETURNABLE as "RETURNABLE",z.per_copy_weight per_copy_weight from--P30,C0.5
            (select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,p.publ_name publ_name,
            d.edtn edtn,edition_nick edtn_name,d.supdate supply_date,
            d.sup_rate copy_rate,d.comm_fix_auto_spl comm_fix_auto_spl,d.comm_code comm_code,
			dbo.cir_get_waste_rate(d.comp_code,d.unit_code,d.edtn,supdate,''''+@pdateformat+'''') waste_rate,
            dbo.cir_get_commission(d.comp_code,d.unit_code,d.publ,d.edtn,d.comm_fix_auto_spl ,d.comm_code,d.supdate,''''+@pdateformat+'''',sum(d.sup_copy),'','') comm_rate,
			'P' comm_catg_type, sum(d.sup_copy) supply_copy,sum(d.sup_copy) rate_supply,
			0 as RETURNABLE,d.per_copy_weight per_copy_weight
            from cir_dbksup d,cir_publ_mast p,cir_edtn_mast e
            where d.comp_code=@pcomp_code and d.comp_code=p.comp_code and d.comp_code=e.comp_code and
                  d.unit_code=@punit_code and d.publ=p.publ and d.publ=e.publ and
                  (d.publ=@ppubl_code or @ppubl_code is null or @ppubl_code='') and
                  d.edtn=e.edtn and (d.edtn = @pedtn_code or @pedtn_code is null or @pedtn_code='') and
                d.supdate between @psup_fromdate and @psup_todate and
                d.billagcd=@pagcd_code and d.billdpcd=@pdpcd_code and upper(isnull(@pextra1,'D'))='D'
                group by d.comp_code,d.unit_code,d.publ,p.publ_name,e.edition_nick,d.edtn,d.supdate,d.sup_rate,d.comm_fix_auto_spl,d.comm_code,d.per_copy_weight) z
            union
            select distinct z.comp_code AS "COMP_CODE",z.unit_code AS "UNIT_CODE",z.publ AS "PUBL",z.publ_name AS "PUBL_NAME",z.edtn AS "EDTN",z.edtn_name AS "EDTN_NAME",
			MAX(z.supply_date) AS "SUPPLY_DATE",dbo.GetLastDayOfMonth(z.supply_date) AS "SUPPLY_DATEMON",
            z.copy_rate AS "COPY_RATE",z.comm_fix_auto_spl AS "COMM_FIX_AUTO_SPL",z.comm_code AS "COMM_CODE",z.waste_rate AS "WASTE_RATE",
            z.comm_catg_type AS "COMM_CATEG_TYPE",z.comm_rate AS "COMM_RATE",sum(z.supply_copy) AS "SUPPLY_COPY",sum(z.supply_copy) AS "RATE_SUPPLY" ,
            z.RETURNABLE as "RETURNABLE",max(z.per_copy_weight) per_copy_weight from
            (select distinct y.comp_code,y.unit_code,y.publ,y.publ_name,y.edtn,y.edtn_name,y.supply_date,y.copy_rate,y.comm_fix_auto_spl,y.comm_code,y.waste_rate,
            substring(y.comm_rate,1,1) comm_catg_type,substring(y.comm_rate,2,len(y.comm_rate)-1) comm_rate,y.supply_copy,y.rate_supply,
            y.RETURNABLE RETURNABLE,y.per_copy_weight per_copy_weight from--P30,C0.5
            (select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,p.publ_name publ_name,d.edtn edtn,edition_nick edtn_name,d.supdate supply_date,
            d.sup_rate copy_rate,d.comm_fix_auto_spl comm_fix_auto_spl,d.comm_code comm_code,
			dbo.cir_get_waste_rate(d.comp_code,d.unit_code,d.edtn,d.supdate,''''+@pdateformat+'''') waste_rate,
            dbo.cir_get_commission(d.comp_code,d.unit_code,d.publ,d.edtn,d.comm_fix_auto_spl ,d.comm_code,d.supdate,''''+@pdateformat+'''',sum(d.sup_copy),'','') comm_rate,
			'P' comm_catg_type, sum(d.sup_copy) supply_copy,
            (select sum(u.sup_copy) from cir_dbksup u where u.comp_code=d.comp_code and u.unit_code=d.unit_code and 
            (u.publ=d.publ) and u.edtn=d.edtn and u.supdate between @psup_fromdate and @psup_todate and 
            u.billagcd=@pagcd_code and u.billdpcd=@pdpcd_code and u.sup_rate=d.sup_rate) rate_supply,
            0 as RETURNABLE,d.per_copy_weight per_copy_weight
            from cir_dbksup d,cir_publ_mast p,cir_edtn_mast e
            where d.comp_code=@pcomp_code and d.comp_code=p.comp_code and d.comp_code=e.comp_code and
                  d.unit_code=@punit_code and d.publ=p.publ and d.publ=e.publ and
                  (d.publ=@ppubl_code or @ppubl_code is null or @ppubl_code='') and
                  d.edtn=e.edtn and (d.edtn = @pedtn_code or @pedtn_code is null or @pedtn_code='') and
                d.supdate between @psup_fromdate and @psup_todate and
                d.billagcd=@pagcd_code and d.billdpcd=@pdpcd_code and upper(isnull(@pextra1,'D'))='R'
                group by d.comp_code,d.unit_code,d.publ,p.publ_name,e.edition_nick,d.edtn,d.supdate,d.sup_rate,d.comm_fix_auto_spl,d.comm_code,d.per_copy_weight) y) z
                group by z.comp_code,z.unit_code,z.publ,z.publ_name,z.edtn,z.edtn_name,dbo.GetLastDayOfMonth(z.supply_date),
                    z.copy_rate,z.comm_fix_auto_spl,z.comm_code,z.waste_rate,z.comm_catg_type,z.comm_rate,z.RETURNABLE
                order by publ_name,edtn,supply_date
	End
End
/////////////////////////////////////////////////////////


////////////////////////////////////// Deepika For Voucher Deletion and receipt cancellation form  16/04/2012/////////////////




ALTER PROCEDURE [dbo].[websp_pubcenter] 
 AS
select Pub_cent_Code,pub_cent_name + '(' +city_name + ')' as center from 
pub_cent_mast,city_mst where city_mst.city_code=pub_cent_mast.city_code and 
 isnull(PUB_CENT_MAST.PRINT_CENT,'Y') != 'N' ORDER BY "center"

select agency_name,code_subcode from agency_mast  ORDER BY Agency_Name;


//////////////////////////////////////


ALTER PROCEDURE [dbo].[cir_doc_bind_cir_doc_view_p]
	@pcompcode                                 VARCHAR(20) ,
	@pdoctyp                                  VARCHAR(20) ,
	@pdateformat                               VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS 

		SELECT
				 comp_code COMP_CODE,
				 doc_type DOC_TYPE,
				 doc_name DOC_NAME,
				 dsign DSIGN,
				 creation_datetime CREATION_DATETIME,
				 userid USERID,
				 flagforreceiptentry FLAGFORRECEIPTENTRY
		FROM  cir_docmst 
		WHERE	 Comp_code  = @pcompcode
		 AND	(doc_type  = @pdoctyp
		 OR	@pdoctyp  is null  OR	@pdoctyp  = '')
		 AND	((UPPER(doc_Name)  like UPPER(@pextra1) + '%')
		 OR	(@pextra1  is null)  OR	(@pextra1  = '' ))
		


///////////////////////////////////////////////


ALTER  procedure [dbo].[cir_voucherno_List_bind_p](
   @pcompcode         varchar(50),
   @punit            varchar(50),
       @pdoctyp      varchar(50),
       @precptdt     varchar(50),
       @pdateformat      varchar(50)
   ) as
   
   
begin

   select VOUCHERNO ,VOUCHERDT ,RECPTNO ,RECPTDT 
from cir_rcphdr
where COMP_CODE=@pcompcode and UNIT_CODE=@punit and DOCTYPE= @pdoctyp and RECPTDT=@precptdt
order by VOUCHERNO,VOUCHERDT;
End 



//////////////////////////////////////////////


ALTER procedure [dbo].[cir_vch_delete_bind_p](
       @pcompcode         varchar(50),
       @punit            varchar(50),
       @pdoctyp          varchar(50),
       @pvoucherno       varchar(50),
       @precptdt         varchar(50),
       @precptno         varchar(50),
       @pdateformat      varchar(50)
   ) as
   

  declare @cnt varchar(2000);


begin


                           
         select @cnt=count(*)  from cir_rcpdet
   where COMP_CODE=@pcompcode and isnull(UNIT_CODE,'/')=isnull(@punit,'/') and DOCTYP=@pdoctyp 
   and isnull(VOUCHERNO,'/')=isnull( @pvoucherno,'/') and VOUCHERDT= @precptdt 
   and isnull(RECPTNO,'/')=isnull(@precptno,'/') 
   and BILLNO is not null;
   
   if isnull(@cnt,0)>0 BEGIN
           select 'Bills are Tagged with this receipt first untag them' AS MESSAGE
            
   END
else
BEGIN
   
   
   delete from cir_rcphdr  
   where COMP_CODE=@pcompcode and isnull(UNIT_CODE,'/')=isnull(@punit,'/') and DOCTYPE=@pdoctyp 
   and isnull(VOUCHERNO,'/')=isnull( @pvoucherno,'/') and VOUCHERDT= @precptdt 
   and isnull(RECPTNO,'/')=isnull(@precptno,'/') ;
   
               delete from cir_rcpdet  
   where COMP_CODE=@pcompcode and isnull(UNIT_CODE,'/')=isnull(@punit,'/') and DOCTYP=@pdoctyp 
   and isnull(VOUCHERNO,'/')=isnull( @pvoucherno,'/') and VOUCHERDT= @precptdt 
   and isnull(RECPTNO,'/')=isnull(@precptno,'/') ;
               
               delete from cir_outmast  
   where COMP_CODE=@pcompcode and isnull(UNIT_CODE,'/')=isnull(@punit,'/') and DOCTYP=@pdoctyp 
   and isnull(VOUCHERNO,'/')=isnull( @pvoucherno,'/') and VOUCHERDT= @precptdt 
   and isnull(RECPTNO,'/')=isnull(@precptno,'/') ;                        
   
SELECT 'Cir. Receipt has been Deleted Successfully' AS MESSAGE
           
 end 
 end 

/////////////////////////////////////////////////////


ALTER  procedure [dbo].[cir_vch_detail_List_bind_p](
       @pcompcode         varchar(50),
       @punit            varchar(50),
       @pdoctyp          varchar(50),
       @pvoucherno       varchar(50),
       @precptdt         varchar(50),
       @precptno         varchar(50),
       @pdateformat      varchar(50)
  ) as
   
   

begin

select COMP_CODE ,UNIT_CODE ,AGCD  ,DPCD ,
dbo.cir_get_agency(COMP_CODE,UNIT_CODE,AGCD,DPCD) AGENCY
,VOUCHERNO ,VOUCHERDT ,RECPTNO ,RECPTDT ,DOCTYPE ,REASON ,AMOUNT  
from  cir_rcphdr
where COMP_CODE=@pcompcode and isnull(UNIT_CODE,'/')=isnull(@punit,'/') and isnull(DOCTYPE,'/')= isnull(@pdoctyp,'/')
and (VOUCHERNO = @pvoucherno or @pvoucherno is null) and VOUCHERDT=@precptdt
and (RECPTNO = @precptno or @precptno is null);

End 

//////////////////////////////////////////

ALTER  procedure [dbo].[cir_bills_List_bind_p](
       @pcompcode         varchar(50),
       @punit            varchar(50),
       @pdoctyp          varchar(50),
       @pbildt           varchar(50),
       @pdateformat      varchar(50)
       ) as
  

begin

                select distinct BILLNO ,BILLDT  from cir_bill_det  
               where COMP_CODE=@pcompcode and UNIT_CODE=@punit and BILLDT=@pbildt
                order by BILLNO,BILLDT;                 
End 

///////////////////////////////////////////

ALTER procedure [dbo].[cir_bills_detail_List_bind_p](
       @pcompcode        varchar(50),
       @punit            varchar(50),
       @pdoctyp          varchar(50),
       @pbillno          varchar(50),
       @pbildt           varchar(50),
       @pdateformat      varchar(50)
       ) as
  
  
begin

               select distinct COMP_CODE ,UNIT_CODE ,
               BILLNO  ,BILLDT ,AGCD ,
                    DPCD ,
                     DBO.cir_get_agency(COMP_CODE,UNIT_CODE,AGCD,DPCD) AGENCY,
                     sum(BILL_AMOUNT) BILL_AMOUNT
               from cir_bill_det 
               where COMP_CODE=@pcompcode and UNIT_CODE=@punit and BILLDT=@pbildt and BILLNO=@pbillno
               group by  COMP_CODE,UNIT_CODE,BILLNO,BILLDT,
              AGCD,DPCD order by BILLNO,BILLDT;                 
End 


/////////////////////////////////////////////////////////

ALTER  procedure [dbo].[cir_bills_delete_p](
               @pcompcode         varchar(50),
               @punit            varchar(50),
               @pdoctyp          varchar(50),
               @pbilldt          varchar(50),
               @pbillno          varchar(50),
               @pdateformat      varchar(50)) as
  
  
 DECLARE  @cnt varchar(2000)


begin

               select @cnt=count(*) from cir_outmast 
                       where COMP_CODE=@pcompcode and isnull(UNIT_CODE,'/')=isnull(@punit,'/') 
                            and BILLNO=@pbillno and BILLDT=@pbilldt and RECPTNO is not null ;

               if isnull(@cnt,0)>0 BEGIN
                     
                      
                      SELECT 'Bill has already adjusted from Collection,plz untag bill then Cancel' AS "Column1" 
                       
             END
  else
BEGIN

               delete cir_bill_det 
               where COMP_CODE=@pcompcode and isnull(UNIT_CODE,'/')=isnull(@punit,'/') 
            and isnull(BILLNO,'/')=isnull( @pbillno,'/') and BILLDT= @pbilldt ;

               delete  cir_bill 
               where COMP_CODE=@pcompcode and isnull(UNIT_CODE,'/')=isnull(@punit,'/') 
            and isnull(BILLNO,'/')=isnull( @pbillno,'/') and BILLDT= @pbilldt ;

               delete  cir_outmast
                where COMP_CODE=@pcompcode and isnull(UNIT_CODE,'/')=isnull(@punit,'/') and DOCTYP=@pdoctyp 
            and isnull(BILLNO,'/')=isnull( @pbillno,'/') and BILLDT= @pbilldt ; 

       
     
                      SELECT 'BILL SUCCESSFULLY CANCELED !!! ' AS "Column1" 
       
       
end 
End 

/////////////////////////////////////////////////////////////

ALTER  PROCEDURE [dbo].[cir_bill_unadjusted]
   (@pcompcode            varchar(50),
    @pbilldate            varchar(50),
    @pbillno              varchar(50),
    @puserid              varchar(50),
    @pdateformat          varchar(50),
    @pextra1              varchar(50),
    @pextra2              varchar(50))
AS
  
    DECLARE   @v_bill_cheque_bounce    NUMERIC;
    DECLARE   @rec_count               NUMERIC;
    DECLARE   @v_count                 NUMERIC;
    DECLARE   @v_outamt                NUMERIC;
    DECLARE   @v_hdramt                NUMERIC;

-- cursor c1 variable
declare @v1_comp_code as varchar(20)
declare @v1_unit as varchar(20)
declare @v1_doctype as varchar(20)
declare @v1_billno as varchar(20)
declare @v1_billdt as datetime
declare @v1_recptno as varchar(20)
declare @v1_recptdt as datetime
declare @v1_amount as numeric(14,2)
declare @v1_voucherno as varchar(50)
declare @v1_voucherdt as datetime
 SET @rec_count     =0;
    SET    @v_count               =0;
    SET    @v_outamt                =0;
    SET    @v_hdramt                =0;
      DECLARE c1 cursor LOCAL FOR 
            select comp_code,unit_code,doctyp,billno,billdt,recptno,recptdt,amount,reason,voucherno,voucherdt from cir_outmast where COMP_CODE=@pcompcode and BILLDT=@pbilldate and BILLNO =@pbillno and RECPTNO is not null and AMOUNT<0
            order by DOCTYP,RECPTDT,recptno;
    
    open c1;
   
        fetch NEXT FROM c1 into @v1_comp_code,@v1_unit,@v1_doctype,@v1_billno,@v1_billdt,@v1_recptno,@v1_recptdt,@v1_amount,@v1_voucherno,@v1_voucherdt
        WHILE (@@FETCH_STATUS = 0) 
	BEGIN      
        select @v_bill_cheque_bounce=count(*)   from cir_outmast 
        where comp_code=@v1_comp_code and billno=@v1_billno and billdt=@v1_billdt and 
        recptno is not null and amount>0;
                
        if isnull(@v_bill_cheque_bounce,0)=0 begin--checking for v_bill_cheque_bounce--

            delete from cir_outmast 
                where comp_code=@v1_comp_code and doctyp=@v1_doctype and recptno=@v1_recptno and recptdt=@v1_recptdt and billno=@v1_billno and billdt=@v1_billdt;

            delete from cir_rcpdet 
                where COMP_CODE=@v1_comp_code and DOCTYP=@v1_doctype and RECPTNO=@v1_recptno and RECPTDT=@v1_recptdt and BILLNO=@v1_billno and BILLDT=@v1_billdt;
                                                 
            update cir_outmast set amount=isnull(amount,0)+isnull(@v1_amount,0)
                where   comp_code      =    @v1_comp_code and
                        unit_code     =    @v1_unit and 
                        doctyp        =    @v1_doctype and 
                        recptno        =    @v1_recptno and 
                        recptdt        =    @v1_recptdt and 
                        billno is null;
            ---for amount checking---
            select @v_outamt=sum(amount) from cir_outmast
            where   comp_code      =    @v1_comp_code and
                        unit_code           =    @v1_unit and 
                        doctyp        =    @v1_doctype and 
                        recptno        =    @v1_recptno and 
                        recptdt        =    @v1_recptdt;

            select @v_hdramt=sum(AMOUNT)  from cir_rcphdr
            where   COMP_CODE      =    @v1_comp_code and
                    UNIT_CODE          =    @v1_unit and 
                    DOCTYPE      =    @v1_doctype and 
                    RECPTNO       =    @v1_recptno and 
                    RECPTDT       =    @v1_recptdt;
            if @v_outamt=@v_hdramt begin                                            
               set @rec_count=isnull(@rec_count,0)+1;
            end 
        end 
       set  @v_count=isnull(@v_count,0)+1;
        set @v_bill_cheque_bounce=0;
set @v_outamt =0;
set @v_hdramt =0;
   fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit,@v1_doctype,@v1_billno,@v1_billdt,@v1_recptno,@v1_recptdt,@v1_amount,@v1_voucherno,@v1_voucherdt
	END 
	close c1
	deallocate c1
    
   /* if isnull(@rec_count,0)>0 begin
        commit;
    else
        rollback;
    end 
*/

/////////////////////////////////////////////////end of procedures for voucher deletion and Invoice Cancellation////////////////////////////////////////////////////////////////////

//-------------------------------------------16/04/2012---------------------//

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[cir_agency_bind_cir_agency_area_p]
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


//----------------------------------------------add by ritu--------------------------//


//--------------------------------------16/04/2012-----------------------------------------//


alter PROCEDURE [dbo].[cir_agency_bind_cir_agency_area_p_new]
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
	 AND unit  = @punit AND DPCD='0001'
	 AND (ag_name  like CAST(@pextra1 AS VARCHAR) + '%' OR @pextra1  is null OR @pextra1='')
	union
	SELECT	 cir_agmast_dis.*,
			 DBO.cir_get_area(cir_agmast_dis.comp_code, cir_agmast_dis.area_code) "AREA_NAME",
			 DBO.cir_get_city(cir_agmast_dis.comp_code, cir_agmast_dis.city_code) "CITY_NAME"
	FROM  cir_agmast_dis
	WHERE comp_code  = @pcompcode
	 AND unit  = @punit AND DPCD='0001'
	 AND (agcd  like CAST(@pextra1 AS VARCHAR) + '%' OR @pextra1  is null OR @pextra1='') 
	ORDER BY 7,5 
End
else
Begin
	SELECT   cir_agmast.*,
		 DBO.cir_get_area(cir_agmast.comp_code, cir_agmast.area_code) "AREA_NAME",
		 DBO.cir_get_city(cir_agmast.comp_code, cir_agmast.city_code) "CITY_NAME"
		FROM  cir_agmast 
		WHERE comp_code  = @pcompcode AND unit  = @punit AND DPCD='0001'
		 AND (ag_name  like CAST(@pextra1 AS VARCHAR) + '%' OR @pextra1  is null OR @pextra1='')
	union
	SELECT   cir_agmast.*,
		 DBO.cir_get_area(cir_agmast.comp_code, cir_agmast.area_code) "AREA_NAME",
		 DBO.cir_get_city(cir_agmast.comp_code, cir_agmast.city_code) "CITY_NAME"
		FROM  cir_agmast 
		WHERE comp_code  = @pcompcode AND unit  = @punit AND DPCD='0001'
		 AND (agcd  like CAST(@pextra1 AS VARCHAR) + '%' OR @pextra1  is null OR @pextra1='')	 
		ORDER BY 7,5
		
End


//-------------------------------------add by ritu---------------------------------------//
///////////////issue number 7232
                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE cir_gen_lbl_cir_gen_lbl_p
	@pcomp_code			VARCHAR(20) ,
	@punit_code         VARCHAR(20) ,
	@ppubl_code         VARCHAR(20) ,
	@pedtn_code         VARCHAR(20) ,
	@proute_code        VARCHAR(20) ,
	@pagcd              VARCHAR(20) ,
	@pdpcd              VARCHAR(20) ,
	@psupdate           datetime ,
	@ppkt_size          int ,
	@padjust_copy       int ,
	@pperiod            int ,
	@pdateformat        VARCHAR(20) ,
	@pextra1            VARCHAR(20) ,--it is used for lable type ---Combined(C)/Supply Type Wise(S)
	@pextra2            VARCHAR(20),  --for sub edition
	@ppkt_copy_wt		varchar(20),
    @pextra3			VARCHAR(20),
    @pextra4			VARCHAR(20),
    @pextra5			VARCHAR(20)
AS 
	DECLARE @test_pub_before                          VARCHAR(10) 		
	DECLARE @test_pub_after                           VARCHAR(10) 		
	DECLARE @mroute                                   VARCHAR (5) 		
	DECLARE @msubrt                                   VARCHAR (5) 		
	DECLARE @msubsubrt                                VARCHAR (5) 	
	DECLARE @t_rtnm                                   VARCHAR (50) 		
	DECLARE @t_hrtnm                                  VARCHAR (100) 		
	DECLARE @t_subrtnm                                VARCHAR (50) 		
	DECLARE @t_subrtonm                               VARCHAR (100) 		
	DECLARE @t_subsubrtnm                             VARCHAR (50) 		
	DECLARE @t_subsubrtonm                            VARCHAR (100)		
	DECLARE @mname                                    VARCHAR (50)		
	DECLARE @mastn                                    VARCHAR (50)		
	DECLARE @vcity_oname                              VARCHAR (100)		
	DECLARE @vstation_name                            VARCHAR (50)		
	DECLARE @vstation_oname                           VARCHAR (100)		
	DECLARE @mpin                                     VARCHAR (1)		
	DECLARE @mpinag                                   VARCHAR (8)		
	DECLARE @mpindp                                   VARCHAR (8)		
	DECLARE @vcoag                                    VARCHAR(10) 		
	DECLARE @vcodp                                    VARCHAR(10) 		
	DECLARE @vagty                                    VARCHAR(20) 		
	DECLARE @vpin_name                                VARCHAR(40)                     
	SET @vpin_name = '''''' 		
	DECLARE @vmessage                                 VARCHAR(50)                     
	SET @vmessage = '''''' 		
	DECLARE @msupflg                                  VARCHAR(1) 		
	DECLARE @mpkt                                     int 		
	DECLARE @mlblln7                                  VARCHAR(35) 		
	DECLARE @msusp                                    VARCHAR(1) 		
	DECLARE @vsupdate                                 DATETIME 
	declare @taluka_name                              varchar(200)
	declare @taluka_code                              varchar(200)
		
/*************        DECLARE VARIABLES FOR sup_cur  CURSOR        *****************/

	DECLARE  @vcomp_code1		VARCHAR(20)
	DECLARE  @vunit_code1		VARCHAR(20)
	DECLARE  @vpubl1			VARCHAR(500)
	DECLARE  @vedtn1			VARCHAR(500)
	DECLARE  @vroute_code1		VARCHAR(20)
	DECLARE  @vsubroute_code1   VARCHAR(20)
	DECLARE  @vsubsubroute_code1    VARCHAR(20)
	DECLARE  @vsupdate1			datetime
	DECLARE  @vagcd1			VARCHAR(20)
	DECLARE  @vdpcd1			VARCHAR(20)
	DECLARE  @vagency_ty_code1  VARCHAR(20)
	DECLARE  @vrsup1			int
	DECLARE  @vsup_rate1		int
	DECLARE  @vsupply_seqno1    VARCHAR(20)
	DECLARE  @vroute_seqno1		VARCHAR(20)
	DECLARE  @vedtn_seqno1		VARCHAR(20)
	DECLARE  @vdist_seqno1		VARCHAR(20)
	DECLARE  @vdist_code1		VARCHAR(20)
	DECLARE  @vprint_seq1		VARCHAR(20)
	DECLARE @v_unpaid_copy		int
	DECLARE @v_unpaid_bal		int
	DECLARE @sup_rec_per_copy_weight numeric(15,3)
/*****************************************************************************************/
		
	DECLARE @vseq_no                                  int                           
	SET @vseq_no = 0 

	DECLARE @curr_agcd                                VARCHAR(30)                     
	SET @curr_agcd = 'dummy_curr' 

	DECLARE @prev_agcd                                VARCHAR(30)                     
	SET @prev_agcd = 'dummy_prev' 



	DECLARE @vlblty                                   VARCHAR(1) 		
	DECLARE @bal_pktsize                              int                           
	SET @bal_pktsize = 0 		
	DECLARE @count_pub                                int                           
	SET @count_pub = 0 		
	DECLARE @count_lbl                                int                           
	SET @count_lbl = 0 		
	DECLARE @actual_sup                               int                           
	SET @actual_sup = 0 		
	DECLARE @bal_sup                                  int                           
	SET @bal_sup = 0 		
	DECLARE @consumed_sup                             int                           
	SET @consumed_sup = 0 		
	DECLARE @last_label_copy                          int 	
	DECLARE @total_supply                             int 		
	DECLARE @vsup_1                                   int 		
	DECLARE @vsup_2                                   int 		
	DECLARE @vsup_3                                   int 		
	DECLARE @vsup_4                                   int 		
	DECLARE @vpubl_1                                  VARCHAR(20) 		
	DECLARE @vpubl_2                                  VARCHAR(20) 		
	DECLARE @vpubl_3                                  VARCHAR(20) 		
	DECLARE @vpubl_4                                  VARCHAR(20) 		
	DECLARE @current_publ_1                           VARCHAR(20) 		
	DECLARE @current_publ_2                           VARCHAR(20) 		
	DECLARE @current_publ_3                           VARCHAR(20) 		
	DECLARE @current_publ_4                           VARCHAR(20) 		
	DECLARE @vpacket_size                             int 		
	DECLARE @abcd                                     int 		
	DECLARE @AGCD1                                    VARCHAR(8) 		
	DECLARE @AGCD2                                    VARCHAR(8) 		
	DECLARE @DPCD1                                    VARCHAR(8) 		
	DECLARE @DPCD2                                    VARCHAR(8) 		
	DECLARE @tot_count_rec                            int                           
	SET @tot_count_rec = 0 		
	DECLARE @pktsize                                  int 		
	DECLARE @mhname                                   VARCHAR(100) 		
	DECLARE @route_print_slno                         int 		
	DECLARE @astn_print_slno                          int 		
	DECLARE @vdist_seqno                              int		
	DECLARE @mlblty                                   VARCHAR(100) 		
	DECLARE @vpin_open_in                             VARCHAR(10) 	
	DECLARE @v_alert_text                             VARCHAR(2000) 		
	DECLARE @v_route                                  VARCHAR(200) 		
	DECLARE @v_lbl_printno                            int                           
	SET @v_lbl_printno = 1 		
	DECLARE @v_lbl_lno                                int                           
	SET @v_lbl_lno = 0 

	declare @v_per_copy_wt       numeric(15,3)
	declare @v_pkt_weight        numeric(10)
	declare @v_adjust_copy		  numeric(10)
	declare @v_cir_wieght_calc_req   varchar(1)

	select @v_cir_wieght_calc_req=cir_wieght_calc_req from preferrences where "comp_code"=@pcomp_code
	
	SET @vsupdate  = @psupdate
	
	DELETE FROM   cir_lblmast WHERE  comp_code  = @pcomp_code AND unit_code  = @punit_code AND	lbl_dt  = @vsupdate
	AND	(publ  = @ppubl_code OR	@ppubl_code  is null OR @ppubl_code='') AND (edtn  = @pextra2 OR @pextra2  is null OR @pextra2='')
	AND	publ  in(SELECT DISTINCT publ FROM  cir_publ_mast WHERE	 comp_code  = @pcomp_code AND (publ  = @ppubl_code OR @ppubl_code is null OR @ppubl_code='') AND period  = @pperiod) 
		
	DECLARE sup_cur cursor LOCAL FOR 
	SELECT DISTINCT x.comp_code comp_code, x.unit_code unit_code, x.publ publ, x.edtn edtn, min(x.route_code) route_code, min(x.subroute_code) subroute_code,
	min(x.subsubroute_code) subsubroute_code, x.supdate supdate, x.agcd agcd, x.dpcd dpcd, x.agency_ty_code agency_ty_code,
	SUM(CONVERT(int, ISNULL(x.rsup, 0))) as rsup, x.sup_rate, 
	x.supply_seqno supply_seqno,
	x.route_seqno route_seqno, 
	x.edtn_seqno edtn_seqno,
	x.dist_seqno dist_seqno, 
	x.dist_code dist_code, x.print_seq print_seq,x.per_copy_weight per_copy_weight
	from(SELECT DISTINCT d.comp_code comp_code, d.unit_code unit_code, d.publ publ, d.edtn edtn, d.route_code route_code, d.subroute_code subroute_code,
	d.subsubroute_code subsubroute_code, d.supdate supdate, d.agcd agcd, d.dpcd dpcd, d.agency_ty_code agency_ty_code,
	SUM(CONVERT(int, ISNULL(d.sup_copy, 0))) as rsup, d.sup_rate, 
	DBO.cir_get_supply_seqno(d.comp_code, d.unit_code, d.publ, d.edtn, d.agcd, d.dpcd) supply_seqno,
	DBO.cir_get_route_seqno(d.comp_code, d.unit_code, d.route_code) route_seqno,
	DBO.cir_get_edtn_seqno(d.comp_code, d.edtn) edtn_seqno,
	DBO.cir_get_dist_seqno(d.comp_code, m.dist_code) dist_seqno, 
	m.dist_code dist_code, m.print_seq print_seq,d.per_copy_weight per_copy_weight
	FROM  cir_dbksup d, cir_agmast m 
	WHERE d.comp_code  = @pcomp_code AND	d.comp_code  = m.comp_code AND	d.unit_code  = @punit_code AND	d.unit_code  = m.unit
	AND	d.supdate  = @vsupdate AND	d.edtn  in
	(SELECT DISTINCT edtn FROM  cir_edtn_mast WHERE	 comp_code  = d.comp_code AND	publ  = d.publ AND	edtn  = d.edtn AND (edtn=@pextra2 OR @pextra2 IS NULL OR @pextra2='')
	AND	((ISNULL(main_edtn, edtn)  = @pedtn_code) OR	(@pedtn_code  is null)))
	AND	d.publ  in(SELECT DISTINCT publ	FROM  cir_publ_mast WHERE	 comp_code  = d.comp_code AND	(publ  = @ppubl_code
	OR	@ppubl_code  is null) AND	period  = @pperiod)
	AND	d.agcd  = m.agcd AND	d.dpcd  = m.dpcd AND	ISNULL(m.print_label, 'N')  = 'Y' AND	(d.agcd  = @pagcd
	OR	@pagcd  is null or @pagcd='''') AND	(d.dpcd  = @pdpcd OR	@pdpcd  is null or @pdpcd='''') AND	ISNULL(d.sup_copy, 0)  > 0 AND	(route_code  = @proute_code OR	@proute_code  is null)
	GROUP BY d.comp_code, d.unit_code, d.publ, d.edtn, d.route_code, d.subroute_code, d.subsubroute_code,
 d.supdate,
	d.agcd, d.dpcd, d.agency_ty_code, d.sup_rate, m.dist_code, m.print_seq,d.per_copy_weight ) x
	GROUP BY x.comp_code, x.unit_code, x.publ, x.edtn, x.supdate,
	x.agcd, x.dpcd, x.agency_ty_code, x.sup_rate, x.dist_code, x.print_seq,x.supply_seqno,
	x.route_seqno,x.edtn_seqno,x.dist_seqno,x.per_copy_weight
	ORDER BY x.comp_code,x.unit_code,x.publ,edtn_seqno,x.edtn,route_seqno,supply_seqno,x.print_seq,x.agcd,x.dpcd


	OPEN sup_cur 
			
		fetch NEXT FROM sup_cur INTO @vcomp_code1 ,@vunit_code1 ,@vpubl1 , @vedtn1 ,@vroute_code1, @vsubroute_code1, @vsubsubroute_code1 , @vsupdate1 , @vagcd1 , @vdpcd1 , @vagency_ty_code1 ,
	        @vrsup1 , @vsup_rate1,@vsupply_seqno1 , @vroute_seqno1, @vedtn_seqno1 ,@vdist_seqno1, @vdist_code1, @vprint_seq1 ,@sup_rec_per_copy_weight

        WHILE (@@FETCH_STATUS = 0) 
	BEGIN

		--if define packet size in agency master1

		/*************        DECLARE VARIABLES FOR packet  CURSOR        *****************/

		DECLARE  @vpacket_size5    numeric(6,0)
		DECLARE  @vlbl_printno5    numeric(10,0)
		
		/*****************************************************************************************/


		DECLARE packet cursor LOCAL FOR 
		SELECT DISTINCT ISNULL(packet_size, 0), lbl_printno FROM  cir_supply 
		WHERE	 comp_code  = @pcomp_code AND	unit  = @punit_code AND	publ  = @vpubl1 AND	edtn  = @vedtn1
		AND	agcd  = @vagcd1 AND	dpcd  = @vdpcd1
						                   

		OPEN packet 
		fetch NEXT FROM packet INTO  @vpacket_size5 , @v_lbl_printno
		close packet
        DEALLOCATE packet

		IF ISNULL(@vpacket_size5, 0)<= 0 
	            -------------------paket size in grams
            if @ppkt_copy_wt='Y' and @v_cir_wieght_calc_req='Y' and isnull(@sup_rec_per_copy_weight,0)>0 Begin
                set @v_pkt_weight    =@ppkt_size;
                set @vpacket_size    =floor(@v_pkt_weight/@sup_rec_per_copy_weight)
                set @v_adjust_copy   =floor(@padjust_copy/@sup_rec_per_copy_weight)
                If @vpacket_size = 0 begin
                    set @vpacket_size = 1
                End
            End   
            -------------------paket size in grams
            else BEGIN 
				SET @vpacket_size  = ISNULL(@ppkt_size, 0)
			END
		ELSE
			BEGIN 
				SET @vpacket_size  = ISNULL(@vpacket_size5, 0)
			END
			   
			IF (@pperiod = 7) 
				BEGIN 
					SET @curr_agcd  = @vagcd1 +  @vdpcd1 
				END
			ELSE
				BEGIN 
					SET @curr_agcd  =  @vagcd1 +  @vdpcd1 +  @vedtn1 +  @vdist_seqno1
				END
			   
				IF (@curr_agcd <> @prev_agcd) 
					BEGIN 
						SET @mpin  = null 
					/*************        DECLARE VARIABLES FOR master1  CURSOR        *****************/

					DECLARE  @vag_name6   varchar(50)
					DECLARE  @vname_on_label6   varchar(75)
					DECLARE  @vag_name_oth_lang6   varchar(100)
					DECLARE  @vcity_code6   varchar(10)
					DECLARE  @vprint_label6   varchar(1)
					DECLARE  @vstation_code6   varchar(10)
					DECLARE  @valert_text6   varchar(70)
					DECLARE  @vpin_open_inside6   varchar(1)

					/*****************************************************************************************/
					DECLARE master1 cursor LOCAL FOR 
					select ag_name,name_on_label, ag_name_oth_lang,city_code,print_label,station_code,alert_text,pin_open_inside from cir_agmast a where a.comp_code = @pcomp_code and a.unit = @punit_code and 
					a.agcd = @vagcd1 and a.dpcd = @vdpcd1


					OPEN master1
		     				fetch NEXT FROM master1 INTO  @vag_name6 , @vname_on_label6,@vag_name_oth_lang6,@vcity_code6,@vprint_label6,@vstation_code6,@valert_text6,@vpin_open_inside6
					close master1
                    deallocate  master1
										
										
					SET @mroute  =  @vroute_code1
                    declare @t_rtnm1 varchar(2000)
					
					--SET @t_rtnm1  = DBO.cir_get_route(@pcomp_code, @punit_code, @mroute)
					SET @t_rtnm1  = DBO.cir_get_name_cir_route(@pcomp_code, @punit_code, @mroute,'1',NULL,NULL,NULL)
					SET @t_hrtnm = DBO.cir_get_name_cir_route(@pcomp_code, @punit_code, @mroute,'2',NULL,NULL,NULL)
					/*************************        changes for split a string value       *****************************/                                        
										
					SET @msubrt  =  @vsubroute_code1 

					/*declare @t_subrtnm1 varchar(2000)
					SET @t_subrtnm1  = DBO.cir_get_subroute(@pcomp_code, @punit_code, @vroute_code1,@vsubroute_code1)
					SET @msubsubrt  =  @vsubsubroute_code1


					declare @t_subsubrtnm1 varchar(2000)
					SET @t_subsubrtnm1  = DBO.cir_get_sub_subroute(@pcomp_code, @punit_code,@vroute_code1, @vsubsubroute_code1, @vsubsubroute_code1)*/
					
					SET @t_subrtnm  = DBO.cir_get_subroute_name(@pcomp_code, @punit_code, @vroute_code1,@vsubroute_code1)
					SET @t_subrtonm  =dbo.cir_get_name_cir_subroute(@pcomp_code,@punit_code,@vroute_code1,@vsubroute_code1,2,@pdateformat,null,null) 
					SET @msubsubrt  =  @vsubsubroute_code1


					SET @t_subsubrtnm	= DBO.cir_get_sub_subroute_name(@pcomp_code, @punit_code,@vroute_code1, @vsubsubroute_code1, @vsubsubroute_code1)
					SET @t_subsubrtonm	= dbo.cir_get_name_cir_subsubroute(@pcomp_code,@punit_code,@vroute_code1,@vsubroute_code1, @vsubsubroute_code1,2,@pdateformat,null,null) 
					SET @mname  = @vag_name6					
					
					If @vname_on_label6='' or @vname_on_label6  is null Begin
						SET @mhname  = @vag_name_oth_lang6
					End	
					Else Begin
						SET @mhname  = ISNULL( @vname_on_label6,@vag_name_oth_lang6)
					End
					
					--SET @mastn  = DBO.cir_get_city_name(@pcomp_code, @vcity_code6)
					SET @mastn			= DBO.CIR_GET_NAME_cir_city(@pcomp_code,@vcity_code6,'1',NULL,NULL,NULL)
					SET @vcity_oname	= DBO.CIR_GET_NAME_cir_city(@pcomp_code,@vcity_code6,'2',NULL,NULL,NULL)
					SET @mlblty			=  @vprint_label6
					SET @vstation_name  = DBO.cir_get_drop_point_name(@pcomp_code, @punit_code, @vstation_code6, 1)
					SET @vstation_oname = DBO.cir_get_drop_point_name(@pcomp_code, @punit_code,@vstation_code6, 2)
					SET @route_print_slno =  @vroute_seqno1
						 
					print ('---------------')

					print (@vstation_oname)
					print ('---------------')									
					SET @astn_print_slno  = DBO.cir_get_drop_seqno(@pcomp_code, @punit_code,  @vstation_code6)

					SET @vdist_seqno=  @vdist_seqno1
					SET @vagty		=  @vagency_ty_code1
					SET @v_alert_text  = @valert_text6
					SET @vpin_open_in  =   @vpin_open_inside6
										
					IF @vlblty = 'O' BEGIN 
						SET @vpacket_size5  = 99999 
					END
					ELSE BEGIN 
						SET @vpacket_size5  = ISNULL(@vpacket_size, 0)
					END
						   
						--update for a agcd and dpcd;  -- will not be useful 1st time
										
					IF @pperiod = 7 BEGIN 
						SET @vsup_1  = 0 
						SET @vsup_2  = 0 
						SET @vsup_3  = 0 
						SET @vsup_4  = 0 
						SET @vpubl_1  = null 
						SET @vpubl_2  = null 
						SET @vpubl_3  = null 
						SET @vpubl_4  = null 

						/*************        DECLARE VARIABLES FOR sum_cur  CURSOR        *****************/

						 DECLARE  @vsum_supply12    numeric(6,0)
						 DECLARE  @vsum_supply22    numeric(6,0)
						 DECLARE  @vsum_supply32    numeric(6,0)
						 DECLARE  @vsum_supply42    numeric(6,0)
						 DECLARE  @vpubl_12		varchar(5)
						 DECLARE  @vpubl_22		varchar(5)
						 DECLARE  @vpubl_32		varchar(5)
						 DECLARE  @vpubl_42		varchar(5)
						 DECLARE  @vagcd2		varchar(10)
						 DECLARE  @vdpcd2		varchar(10)


						/*****************************************************************************************/


						  DECLARE sum_cur CURSOR LOCAL FOR 
							  SELECT ISNULL(supply_1, 0) sum_supply1, ISNULL(supply_2, 0) sum_supply2, ISNULL(supply_3, 0) sum_supply3, ISNULL(supply_4, 0) sum_supply4, publ_1, publ_2,
							  publ_3, publ_4, agcd, dpcd FROM  cir_lblmast 
							  WHERE	 comp_code  = @pcomp_code AND	unit_code  = @punit_code AND	lbl_dt  = @vsupdate AND	agcd + dpcd  = @prev_agcd
								AND seq_no  = @vseq_no
				
					
					      OPEN sum_cur 
						
						  fetch NEXT FROM sum_cur INTO 
						  @vsup_1, @vsup_2, @vsup_3, @vsup_4, @vpubl_1, @vpubl_2, @vpubl_3, @vpubl_4, @AGCD1, @DPCD1
						
						  close sum_cur
                          deallocate  sum_cur
													
						  SET @current_publ_1  = null 
						  SET @current_publ_2  = null 
						  SET @current_publ_3  = null 
						  SET @current_publ_4  = null 
													
				 /*************        DECLARE VARIABLES FOR daily_publ_cur  CURSOR        *****************/


						  DECLARE  @vpubl_13    varchar(5)
						  DECLARE  @vpubl_23    varchar(5)
						  DECLARE  @vpubl_33    varchar(5)
						  DECLARE  @vpubl_43    varchar(5)
						  DECLARE  @vagcd3    varchar(10)
						  DECLARE  @vdpcd3    varchar(10)


				/*****************************************************************************************/


													                   
						  DECLARE daily_publ_cur CURSOR LOCAL FOR 
						  SELECT publ_1, publ_2, publ_3, publ_4, agcd, dpcd
						  FROM  cir_lblmast WHERE	 comp_code  = @pcomp_code AND	unit_code  = @punit_code
						  AND	lbl_dt  = @vsupdate AND	agcd + dpcd  = @prev_agcd AND	seq_no  = @vseq_no - 1 /*and (FEDN=pedtn_code OR pedtn_code IS NULL)*/

						  OPEN daily_publ_cur 
						
						  fetch NEXT FROM daily_publ_cur INTO 
						  @current_publ_1, @current_publ_2, @current_publ_3, 
						  @current_publ_4, @AGCD2, @DPCD2
						
						  close daily_publ_cur
						deallocate daily_publ_cur
						END
					ELSE
						BEGIN 
											

				    /*************        DECLARE VARIABLES FOR sum_week_cur  CURSOR        *****************/

						DECLARE  @vsum_supply14    numeric(6,0)
						DECLARE  @vsum_supply24    numeric(6,0)
						DECLARE  @vsum_supply34    numeric(6,0)
						DECLARE  @vsum_supply44    numeric(6,0)
						 

						/*****************************************************************************************/

							    

						DECLARE sum_week_cur cursor LOCAL FOR 
						SELECT ISNULL(supply_1, 0), ISNULL(supply_2, 0), ISNULL(supply_3, 0), ISNULL(supply_4, 0) FROM  cir_lblmast 
						WHERE	 comp_code  = @pcomp_code AND	unit_code  = @punit_code AND	lbl_dt  = @vsupdate AND	agcd + dpcd + publ  = @prev_agcd
						AND	seq_no  = @vseq_no 


						
						OPEN sum_week_cur 
						fetch NEXT FROM sum_week_cur INTO @vsup_1, @vsup_2, @vsup_3, @vsup_4
						
						close sum_week_cur
						deallocate sum_week_cur
						
					END
						   
					------CASE 1 :  WRITE
					
					SELECT @last_label_copy  = ISNULL(@vsup_1, 0)+ ISNULL(@vsup_2, 0)+ ISNULL(@vsup_3, 0)+ ISNULL(@vsup_4, 0)
					SET @tot_count_rec  = 0 
					SELECT @tot_count_rec  =  COUNT(*) FROM  cir_lblmast 
					WHERE	 comp_code  = @pcomp_code AND	unit_code  = @punit_code AND	agcd + dpcd  = @prev_agcd AND	lbl_dt  = @vsupdate
										
					IF ( ISNULL(@last_label_copy, 0)> 0 and ISNULL(@last_label_copy, 0)< 25 ) and ISNULL(@tot_count_rec, 0)> 1 
						BEGIN 
							IF @pperiod = 7 
								BEGIN 
								--	WHILE 1 <> 1	CONTINUE
								IF @vpubl_1 is null 
									BEGIN 
										SET @vpubl_1  = @current_publ_1 
									END
												   
									IF @vpubl_2 is null 
									BEGIN 
										SET @vpubl_2  = @current_publ_2 
									END
			   
									IF @vpubl_3 is null 
									BEGIN 
											SET @vpubl_3  = @current_publ_3 
									END
			   
									IF @vpubl_4 is null BEGIN 
										SET @vpubl_4  = @current_publ_4 
									END
			   
									UPDATE  cir_lblmast   
									SET	supply_1 = ISNULL(supply_1, 0) + @vsup_1,	 supply_2 = ISNULL(supply_2, 0) + @vsup_2,	
										supply_3 = ISNULL(supply_3, 0) + @vsup_3,	supply_4 = ISNULL(supply_4, 0) + @vsup_4,	
										publ_1 = @vpubl_1,	 publ_2 = @vpubl_2,	 publ_3 = @vpubl_3,	 publ_4 = @vpubl_4 
									WHERE  comp_code  = @pcomp_code AND	unit_code  = @punit_code AND	lbl_dt  = @vsupdate
										AND	agcd + dpcd  = @prev_agcd AND	((edtn  = @pedtn_code) OR	(@pedtn_code  is null))
										AND	seq_no  = @vseq_no - 1 /*week_dl = :week_daily and */ 

									IF (@@FETCH_STATUS = 0) BEGIN 
										DELETE FROM cir_lblmast    WHERE  comp_code  = @pcomp_code AND	unit_code  = @punit_code
										AND	lbl_dt  = @vsupdate AND	agcd + dpcd  = @prev_agcd AND	seq_no  = @vseq_no /*and (FEDN=pedtn_code OR pedtn_code is null)*/ 
										
										SET @vseq_no  = ISNULL(@vseq_no, 0)- 1 
										SET @count_lbl  = ISNULL(@count_lbl, 0)- 1 
									END
   								END
								ELSE BEGIN 
									UPDATE  cir_lblmast SET	supply_1 = ISNULL(supply_1, 0) + ISNULL(@vsup_1, 0), supply_2 = ISNULL(supply_2, 0) + ISNULL(@vsup_2, 0),	
									supply_3 = ISNULL(supply_3, 0) + ISNULL(@vsup_3, 0), supply_4 = ISNULL(supply_4, 0) + ISNULL(@vsup_4, 0) 
									WHERE  comp_code  = @pcomp_code AND	unit_code  = @punit_code AND	lbl_dt  = @vsupdate AND	agcd + dpcd  = @prev_agcd
									AND	seq_no  = ISNULL(@vseq_no, 0) - 1 /*and (FEDN=pedtn_code OR pedtn_code IS NULL)*/ 
									
									IF (@@FETCH_STATUS = 0) BEGIN 
												DELETE FROM   cir_lblmast    WHERE  comp_code  = @pcomp_code AND	unit_code  = @punit_code
												AND	lbl_dt  = @vsupdate AND	agcd + dpcd  = @prev_agcd AND	seq_no  = @vseq_no /*and (FEDN=pedtn_code OR pedtn_code IS NULL)*/ 
												
												SET @vseq_no  = ISNULL(@vseq_no, 0)- 1 
												SET @count_lbl  = ISNULL(@count_lbl, 0)- 1 
									END
   
								END
						   
							END
						   
							IF (@mpin = 'Y') BEGIN 
											SET @vseq_no  = ISNULL(@vseq_no, 0)+ 1 
											DECLARE @FunctionInExec VARCHAR(15)
											SET @FunctionInExec = ISNULL(@pktsize, 0)
											DECLARE @FunctionInExec_1 VARCHAR(15)
											SET @FunctionInExec_1 = ISNULL(@pktsize, 0)
											DECLARE @FunctionInExec_2 VARCHAR(15)
											SET @FunctionInExec_2 = ISNULL(@pktsize, 0)
											DECLARE @FunctionInExec_3 VARCHAR(15)
											SET @FunctionInExec_3 = DBO.cir_get_publ_name(@pcomp_code, @vpubl1)
											print(@vdist_code1)
											EXEC cir_gen_lbl_ad_lblmst  @vagcd1 , @vdpcd1 , @vedtn1  ,  @mroute  ,  @msubrt  ,  @msubsubrt  ,  @mname  ,  @mhname  ,  @mastn  ,  @vsupdate  ,  @t_rtnm1  ,  @t_hrtnm  ,  '1'  ,  '1'  ,  'PIN   '  ,  null  ,  null  ,  @FunctionInExec  ,  0  ,  0  ,  @FunctionInExec_1  ,  @v_alert_text  ,  0  ,  0  ,  @FunctionInExec_2  ,  @mlblln7  ,  null  ,  null  ,  null  ,  null  ,  1  ,  null  ,  @vcoag  ,  @vcodp  ,  @vagty  ,  @pperiod  ,  @route_print_slno  ,  @astn_print_slno  ,  @mlblty  ,  @punit_code  ,  @pcomp_code  ,  @t_subrtnm  ,  @t_subrtonm  ,  @t_subsubrtnm  ,  @t_subsubrtonm  ,  @vcity_oname  ,  @vstation_name  ,  @vstation_oname  ,  @FunctionInExec_3  , @vsup_rate1 ,  @vpin_open_in  ,  @v_lbl_printno  ,  @vdist_seqno  ,   @vdist_code1,@v_unpaid_copy,@taluka_name,@v_per_copy_wt,@v_pkt_weight
							END

						/********************************************************************************/
							SET @vmessage  = '' 
							IF @mpinag is not null BEGIN 
						/*************        DECLARE VARIABLES FOR cr_pin_cur  CURSOR        *****************/

								DECLARE  @vname11    VARCHAR(500)
						/*****************************************************************************************/		


								DECLARE cr_pin_cur cursor LOCAL FOR 
									select substring(ag_name,1,40) name1 from cir_agmast where comp_code = @pcomp_code and 
										unit  = @punit_code and agcd = @mpinag and dpcd  = @mpindp
							
								OPEN cr_pin_cur 
								fetch NEXT FROM cr_pin_cur INTO @vname11
														
								close cr_pin_cur
								deallocate cr_pin_cur
														
								SET @vmessage  = 'PIN WITH' +  @vname11
							END
						   
							IF @pperiod = 7 BEGIN 
								UPDATE  cir_lblmast   SET	lbl_tno = @count_lbl WHERE  comp_code  = @pcomp_code AND	unit_code  = @punit_code
									AND	lbl_dt  = @vsupdate AND	agcd + dpcd  = @prev_agcd AND	((edtn  = @pedtn_code) OR	(@pedtn_code  is null)) 
											
							END
							ELSE BEGIN 
								UPDATE  cir_lblmast   SET	lbl_tno = ISNULL(@count_lbl, 0) WHERE  comp_code  = @pcomp_code AND	unit_code  = @punit_code
									AND	lbl_dt  = @vsupdate AND	agcd + dpcd  = @prev_agcd AND	((edtn  = @pedtn_code) OR	(@pedtn_code  is null)) 
							END
						   
							SET @count_pub  = 1 
							SET @count_lbl  = 0 
							SET @bal_sup	=  @vrsup1
 
			--------for unpaid copy
            select @v_unpaid_copy = sum(sup_copy)   from cir_dbksup a,cir_supply_type_mast b
                where a.comp_code=@pcomp_code and a.comp_code=b.comp_code and a.unit_code=@punit_code and agcd=@vagcd1 and dpcd= @vdpcd1  and
                    a.publ= @vpubl1 and a.edtn=@vedtn1 and a.supdate=@vsupdate and a.sup_type_code=b.sup_ty_code and b.bill_pay='N';
            set @v_unpaid_bal    =@v_unpaid_copy
            --------for unpaid copy
            select @taluka_code=TEHSIL_TALUKA  from CIR_AGMAST where COMP_CODE=@pcomp_code and UNIT=@punit_code and AGCD=@vagcd1  and DPCD=@vdpcd1 
			
			set @taluka_name=dbo.cir_get_taluka(@pcomp_code,@taluka_code)
			
			/*************       DUE TO THIS WHILE BLOCK PROCEDUER GOES TO INFINITE LOOP          ***********************/
										
										WHILE (@bal_sup > 0 ) BEGIN 
					      
										IF @bal_sup > ISNULL(@vpacket_size5, 0) BEGIN 
											SET @actual_sup  = ISNULL(@vpacket_size5, 0)
											SET @bal_sup  = @bal_sup - ISNULL(@vpacket_size5, 0)
	 
											IF @bal_sup <= @v_adjust_copy BEGIN 
												SET @actual_sup  = @actual_sup + @bal_sup 
												SET @bal_sup  = 0 
											END
					   
										END
										ELSE BEGIN 
											SET @actual_sup  = @bal_sup 
											SET @bal_sup  = 0 
										END
							    
										SET @vseq_no  = ISNULL(@vseq_no, 0)+ 1 
										SET @count_lbl  = ISNULL(@count_lbl, 0)+ 1 
													   
										--inserting record;
														
							DECLARE @FunctionInExec_4 int
							SET @FunctionInExec_4 = ISNULL(@vpacket_size5, 0)

							DECLARE @FunctionInExec_5 int
							SET @FunctionInExec_5 = ISNULL(@vpacket_size5, 0)

							DECLARE @FunctionInExec_6 int
							SET @FunctionInExec_6 = ISNULL(@vpacket_size5, 0)

							DECLARE @FunctionInExec_7 VARCHAR(2000)
							SET @FunctionInExec_7 = DBO.cir_get_publ_name(@pcomp_code,  @vpubl1)
 
							--EXEC cir_gen_lbl_ad_lblmst  @vagcd1 ,  @vdpcd1 , @vedtn1 ,  @mroute  ,  @msubrt  ,  @msubsubrt  ,  @mname  ,  @mhname  ,  @mastn  ,  @vsupdate  ,  @t_rtnm  ,  @t_hrtnm  ,  @count_lbl  ,  null  ,  @vmessage  ,  null  ,  null  ,  @FunctionInExec_4  ,  0  ,  0  ,  @FunctionInExec_5  ,  @v_alert_text  ,  0  ,  0  ,  @FunctionInExec_6  ,  @mlblln7  ,  @vpubl1  ,  @vedtn1  ,  @actual_sup  ,  @vseq_no  ,  @count_pub  ,  @vpubl1 ,  @vcoag  ,  @vcodp  ,  @vagty  ,  @pperiod  ,  @route_print_slno  ,  @astn_print_slno  ,  @mlblty  ,  @punit_code  ,  @pcomp_code  ,  @t_subrtnm  ,  @t_subrtonm  ,  @t_subsubrtnm  ,  @t_subsubrtonm  ,  @vcity_oname  ,  @vstation_name  ,  @vstation_oname  ,  @FunctionInExec_7  ,  @vsup_rate1 ,  @vpin_open_in  ,  @v_lbl_printno  ,  @vdist_seqno  ,  @vdist_code1


							--------for unpaid copy   

                if ISNULL(@v_unpaid_bal,0)>0 begin
                    if isnull(@v_unpaid_bal,0)>@actual_sup begin  
                       set @v_unpaid_bal    =@v_unpaid_bal-@actual_sup
                       set @v_unpaid_copy   =@actual_sup;
                    end
                    else begin
                        set @v_unpaid_copy   =@v_unpaid_bal;
                        set @v_unpaid_bal    =0;
                    end 
                  end                      
                 else begin
					set  @v_unpaid_copy=0;
					set @v_unpaid_bal =0;
                 end
                  

		print(@vdist_code1)
		EXEC cir_gen_lbl_ad_lblmst  @vagcd1 ,  @vdpcd1 , @vedtn1 ,  @mroute  ,  @msubrt  ,  @msubsubrt  ,  @mname  ,  @mhname  ,  @mastn  ,  @vsupdate  ,  @t_rtnm1  ,  @t_hrtnm  ,  @count_lbl  ,  1  ,  @vmessage  ,  null  ,  null  ,  @FunctionInExec_4  ,  0  ,  0  ,  @FunctionInExec_5  ,  0  ,  0  ,  0  ,  @FunctionInExec_6  ,  @mlblln7  ,  @vpubl1  ,  @vedtn1  ,  @actual_sup  ,  @vseq_no  ,  @count_pub  ,  @vpubl1 ,  @vcoag  ,  @vcodp  ,  @vagty  ,  @pperiod  ,  @route_print_slno  ,  @astn_print_slno  ,  @mlblty  ,  @punit_code  ,  @pcomp_code  ,  @t_subrtnm  ,  @t_subrtonm  ,  @t_subsubrtnm  ,  @t_subsubrtonm  ,  @vcity_oname  ,  @vstation_name  ,  @vstation_oname  ,  @FunctionInExec_7  ,  @vsup_rate1 ,  @vpin_open_in  ,  @v_lbl_printno  ,  @vdist_seqno  ,  @vdist_code1,@v_unpaid_copy,@taluka_name,@v_per_copy_wt,@v_pkt_weight
		
                
		END
							
		END
		ELSE BEGIN 
				-- 2nd time onwards
									
				SET @count_pub  = ISNULL(@count_pub, 0)+ 1 
				SET @bal_sup  = @vrsup1 
				
				WHILE (@bal_sup > 0 ) BEGIN 							
													   --consumed_sup should come by cursor;
											
					SELECT (ISNULL(supply_1, 0) + ISNULL(supply_2, 0) + ISNULL(supply_3, 0) + ISNULL(supply_4, 0)) FROM  cir_lblmast 
					WHERE	 comp_code  = @pcomp_code AND	unit_code  = @punit_code AND	lbl_dt  = @vsupdate AND	agcd + dpcd  = @prev_agcd AND	seq_no  = @vseq_no 
				


					/*************        DECLARE VARIABLES FOR con_sup_cur  CURSOR        *****************/

					DECLARE  @vtot_supply11    VARCHAR(500)


					/*****************************************************************************************/


														DECLARE con_sup_cur cursor LOCAL FOR 
														select (isnull(supply_1,0) + isnull(supply_2,0) +isnull(supply_3,0) +isnull(supply_4,0)) tot_supply1  from cir_lblmast 
														where comp_code  = @pcomp_code and unit_code  =  @punit_code and  lbl_dt     = @vsupdate and
														agcd+dpcd = @prev_agcd and   seq_no     = @vseq_no



														OPEN con_sup_cur 
													
														fetch NEXT FROM con_sup_cur INTO @vtot_supply11
													
														close con_sup_cur
                                                        deallocate con_sup_cur


													
														SET @bal_pktsize  = ISNULL(@pktsize, 0)- @consumed_sup 
					            						IF @bal_sup > @bal_pktsize BEGIN 
																	SET @actual_sup  = @bal_pktsize 
																	SET @bal_sup  = @bal_sup - @bal_pktsize 
																	IF @bal_sup <= @v_adjust_copy BEGIN 
																		SET @actual_sup  = @actual_sup + @bal_sup 
																		SET @bal_sup  = 0 
																	END
								   
											     		END
														ELSE BEGIN 
																	SET @actual_sup  = @bal_sup 
																	SET @bal_sup  = 0 
														END
								   
														IF @consumed_sup < ISNULL(@pktsize, 0)BEGIN 
                                                               
																	EXEC cir_gen_lbl_update_rec @pcomp_code  ,  @punit_code  ,  @vpubl1  ,   @vedtn1  ,  @vsupdate  ,  @actual_sup  ,  @count_pub  ,  @vseq_no 
																	
		
														END
											        	ELSE BEGIN 
															IF @bal_pktsize = 0 BEGIN 
																IF @bal_sup > ISNULL(@pktsize, 0) BEGIN 
																	SET @actual_sup  = ISNULL(@pktsize, 0)
																	SET @bal_sup  = @bal_sup - ISNULL(@pktsize, 0)
																	IF @bal_sup <= @v_adjust_copy  BEGIN 
																		SET @actual_sup  = @actual_sup + @bal_sup 
																		SET @bal_sup  = 0 
																	END

																END
															ELSE BEGIN 
																SET @actual_sup  = @bal_sup 
																SET @bal_sup  = 0 
															END
														   
														END
												   
														SET @vseq_no  = ISNULL(@vseq_no, 0)+ 1 
														SET @count_lbl  = ISNULL(@count_lbl, 0)+ 1 
														--message('before insert last111 ');
																				
														DECLARE @FunctionInExec_8 VARCHAR(15)
														SET @FunctionInExec_8 = ISNULL(@pktsize, 0)
														DECLARE @FunctionInExec_9 VARCHAR(15)
														SET @FunctionInExec_9 = ISNULL(@pktsize, 0)
														DECLARE @FunctionInExec_10 VARCHAR(15)
														SET @FunctionInExec_10 = ISNULL(@pktsize, 0)
														DECLARE @FunctionInExec_11 VARCHAR(15)
														SET @FunctionInExec_11 = DBO.cir_get_edtn_name(@pcomp_code, @vedtn1)
														print(@vdist_code1)
														EXEC cir_gen_lbl_ad_lblmst  @vagcd1  ,  @vdpcd1 , @vedtn1 ,  @mroute  ,  @msubrt  ,  @msubsubrt  ,  @mname  ,  @mhname  ,  @mastn  ,  @vsupdate  ,  @t_rtnm1  ,  @t_hrtnm  ,  @count_lbl  ,  null  ,  @vmessage  ,  null  ,  null  ,  @FunctionInExec_8  ,  0  ,  0  ,  @FunctionInExec_9  ,  @v_alert_text  ,  0  ,  0  ,  @FunctionInExec_10  ,  @mlblln7  ,  @vpubl1 , @vedtn1,  @actual_sup  ,  @vseq_no  ,  @count_pub  ,@vpubl1 ,  @vcoag  ,  @vcodp  ,  @vagty  ,  @pperiod  ,  @route_print_slno  ,  @astn_print_slno  ,  @mlblty  ,  @punit_code  ,  @pcomp_code  ,  @t_subrtnm  ,  @t_subrtonm  ,  @t_subsubrtnm  ,  @t_subsubrtonm  ,  @vcity_oname  ,  @vstation_name  ,  @vstation_oname  ,  @FunctionInExec_11  ,   @vsup_rate1 ,  @vpin_open_in  ,  @v_lbl_printno  ,  @vdist_seqno  ,@vdist_code1,@v_unpaid_copy,@taluka_name,@v_per_copy_wt,@v_pkt_weight
												      END
						END 
				END
			   
				IF @pperiod = 7  BEGIN 
					SET @prev_agcd  =@vagcd1 +  @vdpcd1
				END
				ELSE BEGIN 
					SET @prev_agcd  =  @vagcd1 +  @vdpcd1 +  @vedtn1 +   @vdist_seqno1
				END
	   
				SET @v_lbl_printno  = 1 
					
				fetch NEXT FROM sup_cur INTO @vcomp_code1 ,@vunit_code1 ,@vpubl1 , @vedtn1 ,@vroute_code1, @vsubroute_code1, @vsubsubroute_code1 , @vsupdate1 , @vagcd1 , @vdpcd1 , @vagency_ty_code1 ,
				@vrsup1 , @vsup_rate1,@vsupply_seqno1 , @vroute_seqno1, @vedtn_seqno1 ,@vdist_seqno1, @vdist_code1, @vprint_seq1 ,@sup_rec_per_copy_weight
		
		END 
		
		close sup_cur
        deallocate  sup_cur
		
		SET @v_lbl_lno  = 1 


/*************        DECLARE VARIABLES FOR c_route  CURSOR        *****************/

 DECLARE  @vroute_seqno7   NUMERIC(5,0)
 DECLARE  @vroute17    VARCHAR(10)
 DECLARE  @vpubl7    VARCHAR(20)
 DECLARE  @vedtn7    VARCHAR(20)
 DECLARE  @vagcd7    VARCHAR(20)
 DECLARE  @vdpcd7    VARCHAR(20)
 DECLARE  @vseq_no7    VARCHAR(20)

 
 

/*****************************************************************************************/		

		DECLARE c_route CURSOR LOCAL FOR 
		SELECT route_seqno, route1, publ, edtn, agcd, dpcd, seq_no FROM  cir_lblmast  WHERE	 comp_code  = @pcomp_code
		AND	unit_code  = @punit_code AND	lbl_dt  = @vsupdate AND	(publ  = @ppubl_code OR	@ppubl_code  is null)
		ORDER BY route_seqno, route1,publ, seq_no, agcd, dpcd 
	
	
		OPEN c_route 
		fetch NEXT FROM c_route INTO @vroute_seqno7,@vroute17,@vpubl7,@vedtn7,@vagcd7,@vdpcd7,@vseq_no7		
		WHILE (@@FETCH_STATUS = 0) BEGIN 
					

					SET @curr_agcd  =  @vroute17 +  @vpubl7 
					IF @curr_agcd <> @prev_agcd BEGIN 
						SET @v_lbl_lno  = 1 
						SET @prev_agcd  = @vroute17 +  @vpubl7
					END
					ELSE BEGIN 
						SET @v_lbl_lno  = ISNULL(@v_lbl_lno, 0)+ 1 
					END
		   
					UPDATE  cir_lblmast   
					SET	lbl_lno = @v_lbl_lno 
					WHERE  comp_code  = @pcomp_code AND	unit_code  = @punit_code AND	lbl_dt  = @vsupdate AND	agcd  = @vagcd7
					AND	dpcd  = @vdpcd7 AND	publ  = @vpubl7 AND	route1  = @vroute17 AND	seq_no  =@vroute_seqno7
				

					 fetch NEXT FROM c_route INTO @vroute_seqno7,@vroute17,@vpubl7,@vedtn7,@vagcd7,@vdpcd7,@vseq_no7	
			
		END 
		
		
		close c_route

 DEALLOCATE c_route/////////////////////////////////////

///--------Neha -17-04-2012-------------------------//

create FUNCTION  [dbo].[FA_get_drcr_name] (@pcomp_code as varchar(100),@pcdp_code as varchar(100))  returns varchar(200) 

AS  

BEGIN 
DECLARE @v_desc VARCHAR(4000)
select @v_desc=ACC_NAME from fa_acc_mast where comp_code=@pcomp_code and CDP=@pcdp_code
	   
RETURN isnull(@v_desc,'')
END


//////////////////////////////////Deepika 18/04/2012 sent by Laxman Sir //////////////////////////////////////////////////
                                                                                                                                                                                                                                                      
CREATE FUNCTION cir_get_waste_rate_catg
(@pcomp_code		VARCHAR(20) ,
 @punit_code        VARCHAR(20) ,
 @pedtn_code        VARCHAR(20) ,
 @psup_date         DATETIME  ,
 @pdateformat       VARCHAR(20),
 @pwaste_catg		VARCHAR(20),
 @pextra1			VARCHAR(200),
 @pextra2			VARCHAR(200))
RETURNS  NUMERIC(10,4) 
AS 

BEGIN
	If @pwaste_catg='' Begin
		set @pwaste_catg = null
	End
	
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
			publ  = @v_publ AND	edtn  = @pedtn_code AND	valid_from  <= @psup_date
			and ISNULL(waste_catg_code,'/')=ISNULL(@pwaste_catg,ISNULL(waste_catg_code,'/')))
            and ISNULL(waste_catg_code,'/')=ISNULL(@pwaste_catg,ISNULL(waste_catg_code,'/'))			

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

////////////////////////////////////////////////////////////////

                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE CIR_SUPPLY_POST_FOR_NEXT_DAY_cir_supply_posting_p
	@pcomp_code			VARCHAR(20) ,
	@punit_code			VARCHAR(20) ,
	@ppubl_code         VARCHAR(20) ,
	@pedtn_code         VARCHAR(20) ,
	@pagcd				VARCHAR(20) ,
	@pdpcd				VARCHAR(20) ,
	@puserid			VARCHAR(20) ,
	@psup_date			varchar(500) ,
	--@psup_date1       VARCHAR(20),
	@psup_ty			VARCHAR(20) ,
	@pdateformat		VARCHAR(20) ,
	@pextra1			VARCHAR(20) ,
	@pextra2			VARCHAR(20), --issue date
	@pper_copy_wt		numeric(15,3)
AS 
DECLARE  @vsup_date   DATETIME
DECLARE  @vh_date1    DATETIME
DECLARE  @vh_name1    VARCHAR(500)

DECLARE cur_holiday cursor  LOCAL FOR 
		select h_date,h_name from cir_holiday_mast
			where comp_code=@pcomp_code and unit=@punit_code and 
				h_publ=@ppubl_code and h_date=@vsup_date and 
				ISNULL(freeze_flag,'N')='N';

DECLARE @vedtn1			VARCHAR(500)
DECLARE @vedtn_name1    VARCHAR(500)

DECLARE	@v_spl_rate    NUMERIC(10,4)
SET @v_spl_rate = 0

   
/*************        DECLARE VARIABLES FOR cur_supply  CURSOR        *****************/

DECLARE  @vunit1				VARCHAR(500)
DECLARE  @vagcd1				VARCHAR(500)
DECLARE  @vdpcd1				VARCHAR(500)
DECLARE  @vpubl1				VARCHAR(500)
DECLARE  @vedtn11				VARCHAR(500)
DECLARE  @vsupply_type_code1	VARCHAR(500)
DECLARE  @vbase_supply1			numeric(7,0)
DECLARE  @vsupply_sun1			numeric(7,0)
DECLARE  @vsupply_mon1			numeric(7,0)
DECLARE  @vsupply_tue1			numeric(7,0)
DECLARE  @vsupply_wed1			numeric(7,0)
DECLARE  @vsupply_thu1			numeric(7,0)
DECLARE  @vsupply_fri1			numeric(7,0)
DECLARE  @vsupply_sat1			numeric(7,0)
DECLARE  @vsupply_spl11			numeric(7,0)
DECLARE  @vsupply_spl21			numeric(7,0)
DECLARE  @vag_type1				VARCHAR(500)
DECLARE  @vsupply_start_dt1		VARCHAR(500)
DECLARE  @vsuspend_date1		VARCHAR(500)
DECLARE  @vpacket_size1			VARCHAR(500)
DECLARE  @vcomm_code1			VARCHAR(500)
DECLARE  @vcomm_flag1			VARCHAR(500)
DECLARE  @vbill_agcd1			VARCHAR(500)
DECLARE  @vroute_code1			VARCHAR(500)
DECLARE  @vsubroute_code1		VARCHAR(500)
DECLARE  @vsub_subroute_code1	VARCHAR(500)
DECLARE  @vsurch_cd1			VARCHAR(500)
DECLARE  @vwaste_catg_code		VARCHAR(500)

DECLARE  @vbill_dpcd1			VARCHAR(500)
DECLARE @v_supply_copy_dt		varchar(20)
/*****************************************************************************************/

set @psup_date	=dbo.convert_user_date('/',@psup_date,@pdateformat)
set @pextra2	=dbo.convert_user_date('/',@pextra2,@pdateformat)

if @pextra1 is not null begin
	set @v_supply_copy_dt=dbo.convert_user_date('/',@pextra1,@pdateformat)
end


DECLARE cur_surcharge cursor LOCAL FOR 
            select * from cir_surcharge_mast 
            where comp_code  =@pcomp_code and 
                  unit       =@punit_code and
                  publ       =@ppubl_code and
                  edtn       =@vedtn1 and
                  surch_cd   =@vsurch_cd1 and 
                  valid_from = (select max(valid_from) from cir_surcharge_mast 
                                            where comp_code  =@pcomp_code and 
                                                  unit       =@punit_code and
                                                  publ       =@ppubl_code and
                                                  edtn       =@vedtn1 and
                                                  surch_cd   =@vsurch_cd1 and
                                                  valid_from<=@psup_date);
DECLARE	@v_sup_copy			NUMERIC(7)
DECLARE @v_edtn_rate		NUMERIC(10,4)
DECLARE @vreccnt			NUMERIC(5,0)
DECLARE @v_old_sup_copy		NUMERIC(7)

   
/*********************       SEND CONVERTED DATE FROM SQL CLASS     ************/
-- vsup_date:=to_date(psup_date,''''||pdateformat||'''');
SET  @vsup_date = @psup_date

/*******************************************************************************/

open cur_holiday;
fetch NEXT FROM cur_holiday into @vh_date1 , @vh_name1
close cur_holiday
    
if (@vsup_date=@vh_date1) BEGIN
	PRINT('Please Check The  Holiday Today Is  '+' '+   @vh_name1)
	PRINT('Please Check The  Holiday Today Is  '+' '+   @vh_name1)
end 
    
if ((@vsup_date<>@vh_date1) or @vh_date1 is null) BEGIN

	DECLARE cir_edtn_cur cursor LOCAL FOR 
          select distinct edtn,edtn_name from cir_edtn_mast 
			where comp_code=@pcomp_code and publ = @ppubl_code and
		     ((ISNULL(main_edtn,edtn) = @pedtn_code) or (@pedtn_code is null) or (@pedtn_code='')) and ISNULL(freeze_flag,'N')='N'
  
		open cir_edtn_cur
		fetch NEXT FROM cir_edtn_cur into @vedtn1 , @vedtn_name1
		WHILE @@FETCH_STATUS = 0 BEGIN
              
        delete from cir_dbksup where comp_code=@pcomp_code and unit_code=@punit_code and
			publ=@ppubl_code and edtn=@vedtn1 and supdate=@vsup_date and 
			(agcd=@pagcd or @pagcd is null OR @pagcd='') and (dpcd=@pdpcd or @pdpcd is null OR @pdpcd='')

		/*************DECLARE VARIABLES FOR cur_spl_rate  CURSOR        *****************/

		DECLARE  @vspl_day_rate1    FLOAT

		/*****************************************************************************************/     
					        
		DECLARE cur_spl_rate cursor LOCAL FOR
			select spl_day_rate from cir_special_rate_mast
			where comp_code=@pcomp_code and unit=@punit_code and
				publ=@ppubl_code and edtn=@vedtn1 and spl_day_date=@vsup_date;


		open cur_spl_rate
		fetch NEXT FROM cur_spl_rate into @vspl_day_rate1;
		close cur_spl_rate;
        
        deallocate cur_spl_rate
        
  		if (ISNULL(@vspl_day_rate1,0)=0 )BEGIN

			 DECLARE  @vsun_rate1   FLOAT
			 DECLARE  @vmon_rate1   FLOAT
			 DECLARE  @vtue_rate1   FLOAT
			 DECLARE  @vwed_rate1   FLOAT
			 DECLARE  @vthu_rate1   FLOAT
			 DECLARE  @vfri_rate1   FLOAT
			 DECLARE  @vsat_rate1   FLOAT
							 

			DECLARE cur_rate cursor LOCAL FOR 
				select sun_rate,mon_rate,tue_rate,wed_rate,thu_rate,fri_rate,sat_rate from cir_rate_mast
				where comp_code=@pcomp_code and unit=@punit_code and publ=@ppubl_code and edtn=@vedtn1 and
				valid_from=(select max(valid_from) from cir_rate_mast where comp_code=@pcomp_code and
				unit=@punit_code and publ=@ppubl_code and edtn=@vedtn1 and valid_from<=@vsup_date and 
				ISNULL(freeze_flag,'N')='N');
			
			open cur_rate;
			fetch NEXT FROM cur_rate into @vsun_rate1, @vmon_rate1, @vtue_rate1, @vwed_rate1, @vthu_rate1, @vfri_rate1, @vsat_rate1
			close cur_rate;
					
			deallocate  cur_rate;
                  
			DECLARE @SUP_DAY11    varchar(20)
			SET @SUP_DAY11 = CONVERT(VARCHAR(20) , DATENAME(WEEKDAY, @psup_date),20)

			if (@SUP_DAY11 = 'Sunday' )begin          
				set  @v_edtn_rate      =    @vsun_rate1 ;
            end

			else if (@SUP_DAY11 = 'Monday') begin
				set  @v_edtn_rate      =    @vmon_rate1;
			end
			else if (@SUP_DAY11 = 'Tuesday')begin 
				set  @v_edtn_rate      =    @vtue_rate1;
			end
			else if (@SUP_DAY11 = 'Wednesday') begin
				set  @v_edtn_rate      =    @vwed_rate1;
            end
			else if (@SUP_DAY11 = 'Thursday')begin
				set  @v_edtn_rate      =    @vthu_rate1;
			end
			else if (@SUP_DAY11 = 'Friday' )begin
				set  @v_edtn_rate      =    @vfri_rate1;
			end
			else if (@SUP_DAY11 = 'Saturday')begin
				set  @v_edtn_rate      =    @vsat_rate1;
			end
			else begin
				set @v_edtn_rate        =    0
			end 
		end
		else begin
			set @v_edtn_rate  =  @v_spl_rate;
		end 
		
		if (@v_edtn_rate=0)begin
			print('Please Check,The Rate Today Is not Define for '+' '+  @vedtn_name1)
		end 

		DECLARE  cur_supply cursor LOCAL FOR 
		select a.unit unit,a.agcd agcd,a.dpcd dpcd,a.publ publ,a.edtn edtn,a.supply_type_code supply_type_code,a.base_supply base_supply,a.supply_sun supply_sun,
		a.supply_mon supply_mon,a.supply_tue supply_tue,a.supply_wed supply_wed,
		a.supply_thu supply_thu,a.supply_fri supply_fri,a.supply_sat supply_sat,a.supply_spl1 supply_spl1,
		a.supply_spl2 supply_spl2, b.ag_type ag_type,b.supply_start_dt    supply_start_dt,b.suspend_date suspend_date, ISNULL(a.packet_size,0) packet_size,
		a.comm_code comm_code,a.comm_flag comm_flag,b.bill_agcd bill_agcd,b.bill_dpcd bill_dpcd,
		a.route_code route_code,a.subroute_code subroute_code,a.sub_subroute_code sub_subroute_code,
		a.surch_cd surch_cd,a.waste_catg_code waste_catg_code
		from cir_supply a,cir_agmast b
		where a.comp_code=b.comp_code and a.unit=b.unit and 
				  a.agcd=b.agcd and a.dpcd=b.dpcd and (a.agcd=@pagcd or @pagcd is null or @pagcd='') 
				  and (a.dpcd=@pdpcd or @pdpcd is null OR @pdpcd='') and 
				  a.unit=@punit_code and (a.publ=@ppubl_code) and
				  ISNULL(base_supply,0)>0 and
				  a.edtn=@vedtn1 and
				  ISNULL(a.supply_flag,'N')='Y' and ISNULL(b.suspend,'N')='N'
		order by a.agcd,a.dpcd,a.edtn,a.supply_type_code;


		 open cur_supply 

		 fetch next from cur_supply into @vunit1 ,@vagcd1 ,@vdpcd1 ,@vpubl1 ,@vedtn11 ,@vsupply_type_code1,@vbase_supply1,
		 @vsupply_sun1 ,@vsupply_mon1 ,@vsupply_tue1 ,@vsupply_wed1 ,@vsupply_thu1 ,@vsupply_fri1,@vsupply_sat1 ,@vsupply_spl11,
		 @vsupply_spl21, @vag_type1 ,@vsupply_start_dt1, @vsuspend_date1 ,@vpacket_size1 ,@vcomm_code1 ,@vcomm_flag1 ,@vbill_agcd1 ,@vbill_dpcd1,
		 @vroute_code1 ,@vsubroute_code1 ,@vsub_subroute_code1 ,@vsurch_cd1 ,@vwaste_catg_code
	       
         
		SET @vsup_date= CONVERT(VARCHAR(10),@vsup_date,10)
                 
		WHILE @@FETCH_STATUS = 0 begin
			
			DECLARE @SUP_DAY112    varchar(20)
 
            SET  @SUP_DAY112 = CONVERT(VARCHAR(20) , DATENAME(WEEKDAY, @vsup_date),20)
			
			if (@vsup_date>=@vsupply_start_dt1 or @vsupply_start_dt1 is null) and (@vsup_date<=@vsuspend_date1 or @vsuspend_date1 is null) begin 
				if (@psup_ty='R' and @SUP_DAY112 = 'Sunday' ) begin   
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_sun1,0)>0  begin
					
						set @v_sup_copy   =  ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_sun1,0);
													    
                    end
					else begin
						set @v_sup_copy   = 0;
					end 
				end
				else if (@psup_ty='R' and @SUP_DAY112 = 'Monday') begin    
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_mon1,0)>0 begin
					
						set @v_sup_copy    =     ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_mon1,0);
					
					end
					else begin
						set @v_sup_copy    = 0
					end
				end
				else if (@psup_ty='R' and @SUP_DAY112 = 'Tuesday')begin  
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_tue1,0)>0 begin
						set  @v_sup_copy  =  ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_tue1,0);
					end
					else begin
						set @v_sup_copy       = 0;
                    end 
				end
				else if (@psup_ty='R' and @SUP_DAY112 = 'Wednesday') begin   
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_wed1,0)>0 begin 
						
						set @v_sup_copy =  ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_wed1,0)
						
	                end
					else begin
						set @v_sup_copy  = 0
					end 
				end 
				else if (@psup_ty='R' and @SUP_DAY112 = 'Thursday')begin   
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_thu1,0)>0 begin
						set @v_sup_copy  = ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_thu1,0)
					end
                    else begin
						set @v_sup_copy  = 0
                    end 
				end   
				else if (@psup_ty='R' and @SUP_DAY112 = 'Friday' )begin   
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_fri1,0)>0 begin
				
						set @v_sup_copy   =  ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_fri1,0);
                
                    end                
					else
						set @v_sup_copy   = 0
                    end 
				else if (@psup_ty='R' and @SUP_DAY112 = 'Saturday') begin    
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_sat1,0)>0 begin
						set @v_sup_copy   =  ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_sat1,0);
                    end
					else begin
						set @v_sup_copy   = 0
					end
				end 
				else if @psup_ty='S1' begin    
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_spl11,0)>0 begin
						
						set @v_sup_copy   =     ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_spl11,0);
                                                              
					end
					else begin
						set @v_sup_copy   = 0
                                                               													end
					end 
				else if @psup_ty='S2' begin    
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_spl21,0)>0 begin
					
						set @v_sup_copy   =     ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_spl21,0);
                    
                    end
                    else begin
						set @v_sup_copy   = 0
                    end 
				end

			--------change for supply copy--------
					           
            if @psup_ty='R' and @v_supply_copy_dt is not null begin
                set @v_old_sup_copy=0;
                select @v_old_sup_copy = sum(sup_copy) from cir_dbksup where comp_code=@pcomp_code and unit_code=@punit_code and publ=@ppubl_code and edtn=@vedtn11 and
                    agcd=@vagcd1 and dpcd=@vdpcd1 and supdate=@v_supply_copy_dt and sup_type_code=@vsupply_type_code1;
   
            end

            if isnull(@v_old_sup_copy,0)>0 begin
                set @v_sup_copy=@v_old_sup_copy;
            end
           
            --------change for supply copy--------
					            
			if ISNULL(@v_sup_copy,0)>0 Begin
				print('22tytr')
				print( @v_sup_copy)
				
				insert into cir_dbksup (comp_code,unit_code,publ,edtn,agcd,dpcd,supdate,sup_type_code,sup_copy,agency_ty_code,
										agency_pkt_size,comm_code,comm_fix_auto_spl,sup_rate,billagcd,billdpcd,
										route_code,subroute_code,subsubroute_code,userid,surch_cd,issue_date,per_copy_weight,waste_catg_code)
								values (@pcomp_code,@punit_code,@ppubl_code,@vedtn11,@vagcd1,@vdpcd1,@vsup_date,
									 @vsupply_type_code1,
									 @v_sup_copy,@vag_type1,@vpacket_size1,@vcomm_code1,@vcomm_flag1,
									 @v_edtn_rate,@vbill_agcd1,@vbill_dpcd1,@vroute_code1,
									 @vsubroute_code1,@vsub_subroute_code1,@puserid,@vsurch_cd1,@pextra2,@pper_copy_wt,@vwaste_catg_code);

				select @vreccnt	= count(*)  from cir_dbksup where comp_code=@pcomp_code and unit_code=@punit_code 
				and publ=@ppubl_code and edtn=@vedtn1 and supdate=@vsup_date and (agcd=@pagcd or @pagcd is null) and (dpcd=@pdpcd or @pdpcd is null);
					               
			End;                     
		end 
    

         fetch next from cur_supply into @vunit1 ,@vagcd1 ,@vdpcd1 ,@vpubl1 ,@vedtn11 ,@vsupply_type_code1,@vbase_supply1,
		 @vsupply_sun1 ,@vsupply_mon1 ,@vsupply_tue1 ,@vsupply_wed1 ,@vsupply_thu1 ,@vsupply_fri1,@vsupply_sat1 ,@vsupply_spl11,
		 @vsupply_spl21, @vag_type1 ,@vsupply_start_dt1, @vsuspend_date1 ,@vpacket_size1 ,@vcomm_code1 ,@vcomm_flag1 ,@vbill_agcd1 ,@vbill_dpcd1,
		 @vroute_code1 ,@vsubroute_code1 ,@vsub_subroute_code1 ,@vsurch_cd1,@vwaste_catg_code 

	end 
	close cur_supply;
	deallocate cur_supply
	   
	set @v_edtn_rate = 0;
	set @v_spl_rate  =0;
	set @vedtn1=NULL;

fetch NEXT FROM cir_edtn_cur into @vedtn1 , @vedtn_name1
end
close cir_edtn_cur
deallocate  cir_edtn_cur  
end 
  
    select case b.bill_pay
              when 'Y' then 'PAID'
              when 'N' then 'UNPAID'
              else  'UNPAID' 
              end  BILL_PAY,
   sum(a.sup_copy) SUP_COPY
    from cir_dbksup a,cir_supply_type_mast b,CIR_EDTN_MAST e
    where a.comp_code=@pcomp_code and a.comp_code=b.comp_code and a.comp_code=e.comp_code and  a.unit_code=@punit_code and 
          a.publ=@ppubl_code and a.publ = e.publ and a.edtn= e.edtn and 
          (ISNULL(e.main_edtn,e.edtn) = @pedtn_code or @pedtn_code is null OR  @pedtn_code='') and 
          a.sup_type_code=b.sup_ty_code and a.supdate=@vsup_date and 
          (a.agcd=@pagcd or @pagcd is null OR @pagcd='') and (a.dpcd=@pdpcd or @pdpcd is null or @pdpcd ='')
    group by b.bill_pay
    order by b.bill_pay desc
  
deallocate cur_holiday
deallocate cur_surcharge 


////////////////////////////////////////////////////////////////////


                                                                     
                                                                     
                                                                     
                                             
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
	DECLARE  @vwaste_catg_code	VARCHAR(500)
	
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
			  a.surch_cd surch_cd,a.waste_catg_code waste_catg_code
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
			@vroute_code1 ,@vsubroute_code1 ,@vsub_subroute_code1 ,@vsurch_cd1 ,@vwaste_catg_code
        WHILE @@FETCH_STATUS = 0
        Begin
        
			if (@vsup_date>=@vsupply_start_dt1 or @vsupply_start_dt1 is null) and (@vsup_date<=@vsuspend_date1 or @vsuspend_date1 is null) 
			Begin 
				set @v_sup_copy=@pextra2
				if ISNULL(@v_sup_copy,0)>0 
				Begin
					 insert into cir_dbksup_resale (comp_code,unit_code,publ,edtn,agcd,dpcd,supdate,sup_type_code,sup_copy,agency_ty_code,
							agency_pkt_size,comm_code,comm_fix_auto_spl,sup_rate,billagcd,billdpcd,
							route_code,subroute_code,subsubroute_code,userid,surch_cd,issue_date,return_copy_sale,RESALE_BRANCH,waste_catg_code)
					 values (@pcomp_code,@punit_code,@ppubl_code,@vedtn11,@vagcd1,@vdpcd1,@vsup_date,
							 @vsupply_type_code1,
							 @v_sup_copy,@vag_type1,@vpacket_size1,@vcomm_code1,@vcomm_flag1,
							 @v_edtn_rate,@vbill_agcd1,@vbill_dpcd1,@vroute_code1,
							 @vsubroute_code1,@vsub_subroute_code1,@puserid,@vsurch_cd1,@pissue_date,'Y',@pextra3,@vwaste_catg_code);

							 select @vreccnt    = count(*)  from cir_dbksup_resale where comp_code=@pcomp_code and unit_code=@punit_code and 
							 publ=@ppubl_code and edtn=@vedtn1 and supdate=@vsup_date and (agcd=@pagcd or @pagcd is null) and (dpcd=@pdpcd or @pdpcd is null);
	                                   
				End
			End 
		fetch next from cur_supply into @vunit1 ,@vagcd1 ,@vdpcd1 ,@vpubl1 ,@vedtn11 ,@vsupply_type_code1,@vbase_supply1,
			@vsupply_sun1 ,@vsupply_mon1 ,@vsupply_tue1 ,@vsupply_wed1 ,@vsupply_thu1 ,@vsupply_fri1,@vsupply_sat1 ,
			@vag_type1 ,@vsupply_start_dt1, @vsuspend_date1 ,@vpacket_size1 ,@vcomm_code1 ,@vcomm_flag1 ,@vbill_agcd1 ,@vbill_dpcd1,
			@vroute_code1 ,@vsubroute_code1 ,@vsub_subroute_code1 ,@vsurch_cd1 ,@vwaste_catg_code
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


////////////////////////////////////////////////////////////


                                                                     
                                                                     
                                                                     
                                             
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
        substring(z.comm_rate,1,1) AS "COMM_CATEG_TYPE",substring(z.comm_rate,2,len(z.comm_rate)-1) AS "COMM_RATE",z.supply_copy AS "SUPPLY_COPY",z.rate_supply AS "RATE_SUPPLY", 
        z.RETURNABLE as "RETURNABLE",z.per_copy_weight per_copy_weight from--P30,C0.5
        (select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,p.publ_name publ_name,
        d.edtn edtn,edition_nick edtn_name,d.supdate supply_date,
        d.sup_rate copy_rate,d.comm_fix_auto_spl comm_fix_auto_spl,d.comm_code comm_code,
		dbo.cir_get_waste_rate_catg(d.comp_code,d.unit_code,d.edtn,supdate,''''+@pdateformat+'''',d.waste_catg_code,null,null) waste_rate,
        dbo.cir_get_commission(d.comp_code,d.unit_code,d.publ,d.edtn,d.comm_fix_auto_spl ,d.comm_code,d.supdate,''''+@pdateformat+'''',sum(d.sup_copy),'','') comm_rate,
		'P' comm_catg_type, sum(d.sup_copy) supply_copy,sum(d.sup_copy) rate_supply,
		0 as RETURNABLE,d.per_copy_weight per_copy_weight,d.waste_catg_code waste_catg_code
        from cir_dbksup_dis d,cir_publ_mast p,cir_edtn_mast e
        where d.comp_code=@pcomp_code and d.comp_code=p.comp_code and d.comp_code=e.comp_code and
              d.unit_code=@punit_code and d.publ=p.publ and d.publ=e.publ and
              (d.publ=@ppubl_code or @ppubl_code is null or @ppubl_code='') and
              d.edtn=e.edtn and (d.edtn = @pedtn_code or @pedtn_code is null or @pedtn_code='') and
            d.supdate between @psup_fromdate and @psup_todate and
            d.billagcd=@pagcd_code and d.billdpcd=@pdpcd_code and upper(isnull(@pextra1,'D'))='D'
            group by d.comp_code,d.unit_code,d.publ,p.publ_name,e.edition_nick,d.edtn,d.supdate,d.sup_rate,d.comm_fix_auto_spl,d.comm_code,d.per_copy_weight,d.waste_catg_code)z
        union
        select distinct z.comp_code AS "COMP_CODE",z.unit_code AS "UNIT_CODE",z.publ AS "PUBL",z.publ_name AS "PUBL_NAME",z.edtn AS "EDTN",z.edtn_name AS "EDTN_NAME",
		MAX(z.supply_date) AS "SUPPLY_DATE",dbo.GetLastDayOfMonth(z.supply_date) AS "SUPPLY_DATEMON",
        z.copy_rate AS "COPY_RATE",z.comm_fix_auto_spl AS "COMM_FIX_AUTO_SPL",z.comm_code AS "COMM_CODE",z.waste_rate AS "WASTE_RATE",
        z.comm_catg_type AS "COMM_CATEG_TYPE",z.comm_rate AS "COMM_RATE",sum(z.supply_copy) AS "SUPPLY_COPY",sum(z.supply_copy) rate_supply,
        z.RETURNABLE RETURNABLE,max(z.per_copy_weight) per_copy_weight from
        (select distinct y.comp_code,y.unit_code,y.publ,y.publ_name,y.edtn,y.edtn_name,y.supply_date,y.copy_rate,y.comm_fix_auto_spl,y.comm_code,y.waste_rate,
        substring(y.comm_rate,1,1) comm_catg_type,substring(y.comm_rate,2,len(y.comm_rate)-1) comm_rate,y.supply_copy,y.rate_supply ,
        y.RETURNABLE RETURNABLE,y.per_copy_weight per_copy_weight from--P30,C0.5
        (select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,p.publ_name publ_name,
        d.edtn edtn,edition_nick edtn_name,d.supdate supply_date,
        d.sup_rate copy_rate,d.comm_fix_auto_spl comm_fix_auto_spl,d.comm_code comm_code,
		dbo.cir_get_waste_rate_catg(d.comp_code,d.unit_code,d.edtn,d.supdate,''''+@pdateformat+'''',d.waste_catg_code,null,null) waste_rate,
        dbo.cir_get_commission(d.comp_code,d.unit_code,d.publ,d.edtn,d.comm_fix_auto_spl ,d.comm_code,d.supdate,''''+@pdateformat+'''',sum(d.sup_copy),'','') comm_rate,'P' comm_catg_type, 
		sum(d.sup_copy) supply_copy,
        (select sum(u.sup_copy) from cir_dbksup_dis u where u.comp_code=d.comp_code and u.unit_code=d.unit_code and 
        (u.publ=d.publ) and u.edtn=d.edtn and u.supdate between @psup_fromdate and @psup_todate and 
        u.billagcd=@pagcd_code and u.billdpcd=@pdpcd_code and u.sup_rate=d.sup_rate) rate_supply,
        0 as RETURNABLE,d.per_copy_weight per_copy_weight,d.waste_catg_code waste_catg_code
        from cir_dbksup_dis d,cir_publ_mast p,cir_edtn_mast e
        where d.comp_code=@pcomp_code and d.comp_code=p.comp_code and d.comp_code=e.comp_code and
              d.unit_code=@punit_code and d.publ=p.publ and d.publ=e.publ and
              (d.publ=@ppubl_code or @ppubl_code is null or @ppubl_code='') and
              d.edtn=e.edtn and (d.edtn = @pedtn_code or @pedtn_code is null or @pedtn_code='') and
            d.supdate between @psup_fromdate and @psup_todate and
            d.billagcd=@pagcd_code and d.billdpcd=@pdpcd_code and upper(isnull(@pextra1,'D'))='R'
            group by d.comp_code,d.unit_code,d.publ,p.publ_name,e.edition_nick,d.edtn,d.supdate,d.sup_rate,d.comm_fix_auto_spl,d.comm_code,d.per_copy_weight,d.waste_catg_code)y) z
            group by z.comp_code,z.unit_code,z.publ,z.publ_name,z.edtn,z.edtn_name,dbo.GetLastDayOfMonth(z.supply_date),
                z.copy_rate,z.comm_fix_auto_spl,z.comm_code,z.waste_rate,z.comm_catg_type,z.comm_rate,z.RETURNABLE
			order by publ_name,edtn,supply_date
	End
	Else Begin
            select z.comp_code AS "COMP_CODE",z.unit_code AS "UNIT_CODE",z.publ AS "PUBL",z.publ_name AS "PUBL_NAME",z.edtn AS "EDTN",z.edtn_name AS "EDTN_NAME",
			z.supply_date AS "SUPPLY_DATE",z.supply_date AS "SUPPLY_DATEMON",
            z.copy_rate AS "COPY_RATE",z.comm_fix_auto_spl AS "COMM_FIX_AUTO_SPL",z.comm_code AS "COMM_CODE",z.waste_rate AS "WASTE_RATE",
            substring(z.comm_rate,1,1) AS "COMM_CATEG_TYPE",substring(z.comm_rate,2,len(z.comm_rate)-1) AS "COMM_RATE",z.supply_copy AS "SUPPLY_COPY",z.rate_supply AS "RATE_SUPPLY",
            z.RETURNABLE as "RETURNABLE",z.per_copy_weight per_copy_weight from--P30,C0.5
            (select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,p.publ_name publ_name,
            d.edtn edtn,edition_nick edtn_name,d.supdate supply_date,
            d.sup_rate copy_rate,d.comm_fix_auto_spl comm_fix_auto_spl,d.comm_code comm_code,
			dbo.cir_get_waste_rate_catg(d.comp_code,d.unit_code,d.edtn,supdate,''''+@pdateformat+'''',d.waste_catg_code,null,null) waste_rate,
            dbo.cir_get_commission(d.comp_code,d.unit_code,d.publ,d.edtn,d.comm_fix_auto_spl ,d.comm_code,d.supdate,''''+@pdateformat+'''',sum(d.sup_copy),'','') comm_rate,
			'P' comm_catg_type, sum(d.sup_copy) supply_copy,sum(d.sup_copy) rate_supply,
			0 as RETURNABLE,d.per_copy_weight per_copy_weight,d.waste_catg_code waste_catg_code
            from cir_dbksup d,cir_publ_mast p,cir_edtn_mast e
            where d.comp_code=@pcomp_code and d.comp_code=p.comp_code and d.comp_code=e.comp_code and
                  d.unit_code=@punit_code and d.publ=p.publ and d.publ=e.publ and
                  (d.publ=@ppubl_code or @ppubl_code is null or @ppubl_code='') and
                  d.edtn=e.edtn and (d.edtn = @pedtn_code or @pedtn_code is null or @pedtn_code='') and
                d.supdate between @psup_fromdate and @psup_todate and
                d.billagcd=@pagcd_code and d.billdpcd=@pdpcd_code and upper(isnull(@pextra1,'D'))='D'
                group by d.comp_code,d.unit_code,d.publ,p.publ_name,e.edition_nick,d.edtn,d.supdate,d.sup_rate,d.comm_fix_auto_spl,d.comm_code,d.per_copy_weight,d.waste_catg_code) z
            union
            select distinct z.comp_code AS "COMP_CODE",z.unit_code AS "UNIT_CODE",z.publ AS "PUBL",z.publ_name AS "PUBL_NAME",z.edtn AS "EDTN",z.edtn_name AS "EDTN_NAME",
			MAX(z.supply_date) AS "SUPPLY_DATE",dbo.GetLastDayOfMonth(z.supply_date) AS "SUPPLY_DATEMON",
            z.copy_rate AS "COPY_RATE",z.comm_fix_auto_spl AS "COMM_FIX_AUTO_SPL",z.comm_code AS "COMM_CODE",z.waste_rate AS "WASTE_RATE",
            z.comm_catg_type AS "COMM_CATEG_TYPE",z.comm_rate AS "COMM_RATE",sum(z.supply_copy) AS "SUPPLY_COPY",sum(z.supply_copy) AS "RATE_SUPPLY" ,
            z.RETURNABLE as "RETURNABLE",max(z.per_copy_weight) per_copy_weight from
            (select distinct y.comp_code,y.unit_code,y.publ,y.publ_name,y.edtn,y.edtn_name,y.supply_date,y.copy_rate,y.comm_fix_auto_spl,y.comm_code,y.waste_rate,
            substring(y.comm_rate,1,1) comm_catg_type,substring(y.comm_rate,2,len(y.comm_rate)-1) comm_rate,y.supply_copy,y.rate_supply,
            y.RETURNABLE RETURNABLE,y.per_copy_weight per_copy_weight from--P30,C0.5
            (select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,p.publ_name publ_name,d.edtn edtn,edition_nick edtn_name,d.supdate supply_date,
            d.sup_rate copy_rate,d.comm_fix_auto_spl comm_fix_auto_spl,d.comm_code comm_code,
			dbo.cir_get_waste_rate_catg(d.comp_code,d.unit_code,d.edtn,d.supdate,''''+@pdateformat+'''',d.waste_catg_code,null,null) waste_rate,
            dbo.cir_get_commission(d.comp_code,d.unit_code,d.publ,d.edtn,d.comm_fix_auto_spl ,d.comm_code,d.supdate,''''+@pdateformat+'''',sum(d.sup_copy),'','') comm_rate,
			'P' comm_catg_type, sum(d.sup_copy) supply_copy,
            (select sum(u.sup_copy) from cir_dbksup u where u.comp_code=d.comp_code and u.unit_code=d.unit_code and 
            (u.publ=d.publ) and u.edtn=d.edtn and u.supdate between @psup_fromdate and @psup_todate and 
            u.billagcd=@pagcd_code and u.billdpcd=@pdpcd_code and u.sup_rate=d.sup_rate) rate_supply,
            0 as RETURNABLE,d.per_copy_weight per_copy_weight,d.waste_catg_code waste_catg_code
            from cir_dbksup d,cir_publ_mast p,cir_edtn_mast e
            where d.comp_code=@pcomp_code and d.comp_code=p.comp_code and d.comp_code=e.comp_code and
                  d.unit_code=@punit_code and d.publ=p.publ and d.publ=e.publ and
                  (d.publ=@ppubl_code or @ppubl_code is null or @ppubl_code='') and
                  d.edtn=e.edtn and (d.edtn = @pedtn_code or @pedtn_code is null or @pedtn_code='') and
                d.supdate between @psup_fromdate and @psup_todate and
                d.billagcd=@pagcd_code and d.billdpcd=@pdpcd_code and upper(isnull(@pextra1,'D'))='R'
                group by d.comp_code,d.unit_code,d.publ,p.publ_name,e.edition_nick,d.edtn,d.supdate,d.sup_rate,d.comm_fix_auto_spl,d.comm_code,d.per_copy_weight,d.waste_catg_code) y) z
                group by z.comp_code,z.unit_code,z.publ,z.publ_name,z.edtn,z.edtn_name,dbo.GetLastDayOfMonth(z.supply_date),
                    z.copy_rate,z.comm_fix_auto_spl,z.comm_code,z.waste_rate,z.comm_catg_type,z.comm_rate,z.RETURNABLE
                order by publ_name,edtn,supply_date
	End
End



////////////////////////////////////////////////////////


create PROCEDURE [dbo].[Cir_Gen_Code_wasterate_catg_p]
	@pcompcode                                VARCHAR(20) ,
	--@pcomm_type                               VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS 

	DECLARE @vno        NUMERIC(5) 
	DECLARE @vtype_code VARCHAR(15) 
	DECLARE @v_sess_id  NUMERIC(20) 
	DECLARE @vcomm_type VARCHAR(1) 

	set @v_sess_id=(SELECT top 1 session_id  FROM sys.dm_exec_requests where sql_handle is not null);

		SELECT @vno  =  isnull( MAX(CATG_CODE),100) + 1
		FROM  CIR_WASTE_CATG_MAST 
		WHERE comp_code  = @pcompcode
		
		
   
		
   
		SELECT @vno as VAR_CODE


////////////////////////////////////////////////

create PROCEDURE [dbo].[cir_wasterate_catg_bind_p]
	@pcomp_code                               VARCHAR(20) ,
	@pdateformate                             VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS 

		SELECT *
		FROM  CIR_WASTE_CATG_MAST 
		WHERE	 comp_code  = @pcomp_code
		
/////////////////////////////////////////////////////end of all procedures sent by Laxman Sir////////////////////////////////////////////////////////////////


//--------------------Transfer closing to opening balance 18/04/2012---------------------------------//


                                                                     
                                                                     
                                                                     
                                             
ALTER procedure cir_trf_closing_opening_cir_trf_closing_opening_p
    @pcompcode           as varchar(20),
    @punitcode           as varchar(20),
    @ppublcode           as varchar(20),
    @pfromdate           as datetime,
    @ptodate             as datetime,
    @popdate             as datetime,
    @pagcd               as varchar(20),
    @pdpcd               as varchar(20),
    @puserid             as varchar(20),
    @pdateformat         as varchar(20),
    @pextra1             as varchar(20),
    @pextra2             as varchar(20)
  As
   declare @v_frdt       datetime
   declare @v_todt       datetime
   declare @v_opbal      numeric(15,2)
   declare @v_sec_opbal  numeric(15,2)
   
      declare c1 cursor for
       select comp_code,unit,agcd ,dpcd,ag_name from cir_agmast
       where comp_code=@pcompcode and unit=@punitcode and
       (agcd=@pagcd or @pagcd is null or @pagcd='') and (dpcd=@pdpcd or @pdpcd is null or @pdpcd='')
      order by ag_name
      
	declare @v1_comp_code	varchar(20)
	declare @v1_unit		varchar(20)
	declare @v1_agcd		varchar(20)
	declare @v1_dpcd		varchar(20)
	declare @v1_ag_name		varchar(200)
	
    declare @v_recno		numeric
    declare @v_findt        datetime
    declare @v_amt          numeric(15,2)
    declare @v_secamt       numeric(15,2)
   Begin

      /*for finance date*/
    set @v_findt  =@popdate
    
    open c1
      fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit,@v1_agcd,@v1_dpcd	,@v1_ag_name
		WHILE (@@FETCH_STATUS = 0)  
		Begin
			  /* opening on financial date*/
			select @v_opbal=isnull(sum(opbal),0),@v_sec_opbal=isnull(sum(sec_opbal),0) from cir_agomast 
			where comp_code=@v1_comp_code and unit_code=@v1_unit and agcd=@v1_agcd and dpcd=@v1_dpcd and 
				  for_month=@popdate

          /* Transaction amount from financial date to  date*/
			set @v_amt     =dbo.cir_accounts_cir_agency_ytodt(@v1_comp_code,@v1_unit,null,@v1_agcd,@v1_dpcd,@pfromdate,@ptodate+1,'NM',@pdateformat,null,null)    
			set @v_secamt  =dbo.cir_accounts_cir_agency_ytodt(@v1_comp_code,@v1_unit,null,@v1_agcd,@v1_dpcd,@pfromdate,@ptodate+1,'SC',@pdateformat,null,null);

			set @v_amt     =isnull(@v_opbal,0)+isnull(@v_amt,0)
			set @v_secamt  =isnull(@v_sec_opbal,0)+isnull(@v_secamt,0)
      
			select @v_recno =count(*) from cir_agomast
				where comp_code=@v1_comp_code and unit_code=@v1_unit and agcd=@v1_agcd and dpcd=@v1_dpcd and 
                for_month=@popdate
                
			If @v_recno>0 Begin 
				update cir_agomast set opbal=@v_amt,SEC_OPBAL=@v_secamt,LAST_UPDATED_USERID=@puserid,LAST_UPDATED_DATE=getdate()
				where comp_code=@v1_comp_code and unit_code=@v1_unit and agcd=@v1_agcd and dpcd=@v1_dpcd and 
					for_month=@popdate
			End
			ELSE Begin
				If @v_amt<>0 or @v_secamt<>0 Begin
					insert into cir_agomast(comp_code,unit_code,publ,AGCD,DPCD,for_month,opbal,SEC_opbal,creation_userid,creation_date)
					values(@v1_comp_code,@v1_unit,'P01',@v1_agcd,@v1_dpcd,@popdate,@v_amt,@v_secamt,@puserid,getdate())
				End
			End	
		fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit,@v1_agcd,@v1_dpcd	,@v1_ag_name
      set @v_opbal=0 
      set @v_SEC_opbal=0
      set @v_amt =0
      set @v_secamt =0
    end
    close c1
    deallocate c1
    
    select (select "Comp_Name" from comp_mst where "Comp_Code"=@pcompcode)  as "CNAME"

End


//----------------------------------------------add by ritu---------------------------------------//


/////////////////////////////////////////////add by deepika 19/04/2012//////////////////////////////////////////
                                                                                                                                                                                                                                                        
ALTER FUNCTION [dbo].[cir_get_waste_rate_catg]
(@pcomp_code		VARCHAR(20) ,
 @punit_code        VARCHAR(20) ,
 @pedtn_code        VARCHAR(20) ,
 @psup_date         DATETIME  ,
 @pdateformat       VARCHAR(20),
 @pwaste_catg		VARCHAR(20),
 @pextra1			VARCHAR(200),
 @pextra2			VARCHAR(200))
RETURNS  NUMERIC(10,4) 
AS 

BEGIN
	If @pwaste_catg='' Begin
		set @pwaste_catg = null
	End
	
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
			publ  = @v_publ AND	edtn  = @pedtn_code AND	valid_from  <= @psup_date
			and ISNULL(waste_catg_code,0)=ISNULL(@pwaste_catg,ISNULL(waste_catg_code,0)))
            and ISNULL(waste_catg_code,0)=ISNULL(@pwaste_catg,ISNULL(waste_catg_code,0))			

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


//////////////////////////////////////////////////////end //////////////////////////////////////////////////////////////



/////////////////////////////////////add by deepika for issue no. 6845 19/04/2012 //////////////////////////////



ALTER PROCEDURE [dbo].[cir_rep_ageing]
@pcomp_code varchar(20),
@punit_code varchar(20),
@pbran_code varchar(20),
@pzone_code varchar(30),
@pregion_code varchar(30),
@pdist_code varchar(20),
@ptaluka_code varchar(20),
@pagtype      varchar(50),
@pagclass      varchar(50),
@pag_main_code varchar(50),
@pag_sub_code varchar(50),
@paging_by varchar(50),
@pasondt datetime,
@pdebitupto_date datetime,
@pcreditupto_date datetime,
@ptill_days1 varchar(20),
@ptill_days2 varchar(20),
@ptill_days3 varchar(30),
@ptill_days4 varchar(30),
@ptill_days5 varchar(50),
@ptill_days6 varchar(50),
@pdateformat varchar(20),
@puserid varchar(20),
@pextra1 varchar(20),
@pextra2 varchar(20),
@pextra3 varchar(30),
@pextra4 varchar(30),
@pextra5 varchar(50)

AS

declare  @vtodt   as datetime
declare  @vasondt  as datetime     
declare  @v_dt    as datetime
declare  @v_ondt  as datetime
declare  @v_days numeric(10);

declare  @v_pending_rcpt_amt as numeric(14,2) 

declare  @v_amt     as    numeric(14,2);
declare  @v_amt030  as   numeric(14,2);
declare  @v_amt3160 as   numeric(14,2);
declare  @v_amt6190 as   numeric(14,2);
declare  @v_amt91120 as numeric(14,2);
declare  @v_amt121180   as numeric(14,2);
declare  @v_amt181   as numeric(14,2);

declare  @debit_amt_030  as  numeric(14,2)  --debit amt  for slab  1 days
declare  @debit_amt_3160 as  numeric(14,2)  --debit amt  for slab  2 days
declare  @debit_amt_6190 as  numeric(14,2)  --debit amt  for slab  3 days
declare  @debit_amt_91120 as numeric(14,2)  --debit amt  for slab  4 days
declare  @debit_amt_121180  as  numeric(14,2)  --debit amt  for >slab 5 days
declare  @debit_amt_181  as  numeric(14,2)  --debit amt  for >slab 6 days
declare  @bill_pending_amt as numeric(14,2)
declare  @rcpt_pending_amt  as numeric(14,2) --pending receipt amount

CREATE TABLE #cir_temp_ageing
(
  COMP_CODE     VARCHAR(8),
  UNIT_CODE     VARCHAR(8),
  BRAN_CODE     VARCHAR(8),
  AGCD          VARCHAR(8),
  DPCD          VARCHAR(8),
  AG_NAME       VARCHAR(100),
  CITY_NAME     VARCHAR(100),
  PENDING_AMT   NUMERIC(14,2),
  SLAB_1        NUMERIC(14,2),
  SLAB_2        NUMERIC(14,2),
  SLAB_3        NUMERIC(14,2),
  SLAB_4        NUMERIC(14,2),
  SLAB_5        NUMERIC(14,2),
  SLAB_6        NUMERIC(14,2),
  ON_ACAMT      NUMERIC(14,2),
  RECT_PENDING  NUMERIC(14,2),
  SESSIONID     NUMERIC(14)
)

set @vtodt=@pdebitupto_date
set @vasondt=@pcreditupto_date

set @debit_amt_030  =0  --debit amt  for slab  1 days
set @debit_amt_3160  =0  --debit amt  for slab  2 days
set  @debit_amt_6190  =0  --debit amt  for slab  3 days
set   @debit_amt_91120  =0 --debit amt  for slab  4 days
set   @debit_amt_121180   =0  --debit amt  for >slab 4 days
set   @debit_amt_181   =0  --debit amt  for >slab 4 days
set   @bill_pending_amt  =0
set   @rcpt_pending_amt  =0  --pending receipt amount


	declare cur_agency cursor for
			select m.Comp_Code comp_code,m.agcd agcd,m.dpcd dpcd,m.ag_name agency_name,
			m.City_Code city_code,c.city_name city_name,m.credit_days credit_days,m.branch_code branch_name
			from cir_agmast m,cir_city_mast c
			where m.comp_code=c.comp_code and m.comp_code=@pcomp_code 
			and m.unit=@punit_code and m.city_code=c.city_code 
			and (c.zone_code=@pzone_code or @pzone_code is null or @pzone_code ='') 
			and (m.Dist_Code=@pdist_code or @pdist_code is null or @pdist_code ='') 
			and (m.tehsil_taluka=@ptaluka_code or @ptaluka_code is null or @ptaluka_code ='') 
			and (m.agcd=@pag_main_code or @pag_main_code is null or @pag_main_code ='') 
			and (m.dpcd=@pag_sub_code or @pag_sub_code is null or @pag_sub_code ='')
			order by branch_name,agency_name; 
		

-- cursor cur_agency variables
declare @rec_agency_comp_code as varchar(30)
declare @rec_agency_agcd as varchar(20)
declare @rec_agency_dpcd as varchar(30)
declare @rec_agency_agency_name as varchar(300)
declare @rec_agency_city_code as varchar(200)
declare @rec_agency_city_name as varchar(200)
declare @rec_agency_credit_days as int
declare @rec_agency_branch_name as varchar(50)

-- cursor v_bill variables
declare @v_bill_billno as varchar(50)
declare @v_bill_billdt as varchar(30)
declare @v_bill_bill_amt as numeric(15,2)

-- cursor v_pending_rcpt variables  
declare @v_pending_rcpt_ag_main_code as varchar(30)
declare @v_pending_rcpt_ag_sub_code as varchar(50)
declare @v_pending_rcpt_amount as numeric(15,2)



--SELECT 'cursor has ' + CAST(@@CURSOR_ROWS AS VARCHAR) + ' rows'
open cur_agency
		fetch NEXT FROM cur_agency INTO @rec_agency_comp_code,@rec_agency_agcd,@rec_agency_dpcd,@rec_agency_agency_name ,@rec_agency_city_code ,@rec_agency_city_name ,@rec_agency_credit_days ,@rec_agency_branch_name
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN
			--SELECT 'cursor has ' + CAST(@@CURSOR_ROWS AS VARCHAR) + ' rows'
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
					agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
					billdt<=@vtodt and isnull(amount,0)>0
					group by comp_code,billno,billdt
					union
					select distinct recptno billno,recptdt billdt,sum(amount) bill_amt from cir_outmast
					where comp_code=@pcomp_code and unit_code=@punit_code and
					agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
					recptdt<=@vtodt and isnull(amount,0)>0 and billno is null
					group by comp_code,recptno,recptdt order by 2,1
                          
				     --having  sum(amount)<0
					open c_bill
							fetch NEXT FROM c_bill INTO @v_bill_billno,@v_bill_billdt,@v_bill_bill_amt
							WHILE (@@FETCH_STATUS = 0) 
							begin
								print('enter second')
								set @v_dt    = @v_bill_billdt
								set @v_ondt  = @vtodt
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
								set @v_amt               =0;
								set @v_amt030            =0;
								set @v_amt3160           =0;
								set @v_amt6190           =0;
								set @v_amt91120          =0;
								set @v_amt121180         =0;
								set @v_amt181            =0;	

								if @v_days between 0 and @ptill_days1 begin
									select @v_amt030=sum(amount) from cir_outmast 
									where comp_code=@pcomp_code and unit_code=@punit_code and
										  agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
										  billno=@v_bill_billno and billdt=@v_bill_billdt and 
										  recptdt<=@vasondt and amount<0

									set @v_amt030 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt030,0);
									set @debit_amt_030 =isnull(@debit_amt_030,0)+isnull(@v_amt030,0)
								end
								else if @v_days between isnull(@ptill_days1,0)+1 and @ptill_days2 begin
									select @v_amt3160=sum(amount) from cir_outmast 
									where comp_code=@pcomp_code and unit_code=@punit_code and
										  agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
										  billno=@v_bill_billno and billdt=@v_bill_billdt and 
										  recptdt<=@vasondt and amount<0
									--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
									set @v_amt3160 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt3160,0);
									set @debit_amt_3160 =isnull(@debit_amt_3160,0)+isnull(@v_amt3160,0)
								end
								else if @v_days between isnull(@ptill_days2,0)+1 and @ptill_days3 begin
									select @v_amt6190=sum(amount) from cir_outmast 
									where comp_code=@pcomp_code and unit_code=@punit_code and
										  agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
										  billno=@v_bill_billno and billdt=@v_bill_billdt and 
										  recptdt<=@vasondt and amount<0
									--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
									set @v_amt6190 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt6190,0);
									set @debit_amt_6190 =isnull(@debit_amt_6190,0)+isnull(@v_amt6190,0)
								end
								else if @v_days between isnull(@ptill_days3,0)+1 and @ptill_days4 begin
									select @v_amt91120=sum(amount) from cir_outmast 
									where comp_code=@pcomp_code and unit_code=@punit_code and
										  agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
										  billno=@v_bill_billno and billdt=@v_bill_billdt and 
										  recptdt<=@vasondt and amount<0
									--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
									set @v_amt91120 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt91120,0);
									set @debit_amt_91120 =isnull(@debit_amt_91120,0)+isnull(@v_amt91120,0)
								end  
								else if @v_days between isnull(@ptill_days4,0)+1 and @ptill_days5 begin
									select @v_amt121180=sum(amount) from cir_outmast 
									where comp_code=@pcomp_code and unit_code=@punit_code and
										  agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
										  billno=@v_bill_billno and billdt=@v_bill_billdt and 
										  recptdt<=@vasondt and amount<0
									--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
									set @v_amt121180 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt121180,0);
									set @debit_amt_121180 =isnull(@debit_amt_121180,0)+isnull(@v_amt121180,0)
								end        
								else
								begin
									select @v_amt181=sum(amount) from cir_outmast 
									where comp_code=@pcomp_code and unit_code=@punit_code and
										  agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
										  billno=@v_bill_billno and billdt=@v_bill_billdt and 
										  recptdt<=@vasondt and amount<0
									--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
									set @v_amt181 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt181,0);
									set @debit_amt_181 =isnull(@debit_amt_181,0)+isnull(@v_amt181,0)
								end
								

							fetch NEXT FROM c_bill INTO @v_bill_billno,@v_bill_billdt,@v_bill_bill_amt
							end
					close c_bill		
				deallocate c_bill
		
		select @v_pending_rcpt_amt=sum(amount) from cir_outmast 
        where comp_code=@pcomp_code and unit_code=@punit_code and
          agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
          (billno is null or billdt>@vasondt) and 
          recptdt<=@vasondt and 
          doctyp+recptno+cast(recptdt as varchar) not in 
          (select distinct doctyp+recptno+cast(recptdt as varchar) from ad_outstand
           where comp_code=@pcomp_code and unit_code=@punit_code and
                 agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
                 recptdt<=@vtodt and isnull(amount,0)<0 and billno IS NULL)
	
		set @v_amt=isnull(@debit_amt_030,0)+isnull(@debit_amt_3160,0)+isnull(@debit_amt_6190,0)+isnull(@debit_amt_91120,0)+isnull(@debit_amt_121180,0)+isnull(@debit_amt_181,0)

		if @v_amt=0 begin
			set @debit_amt_030    = 0
			set @debit_amt_3160   = 0
			set @debit_amt_6190   = 0
			set @debit_amt_91120  = 0
			set @debit_amt_121180 = 0
			set @debit_amt_181    = 0
			set @rcpt_pending_amt = 0
		end
		else
		begin
			set @rcpt_pending_amt=isnull(@v_pending_rcpt_amount,0)
			set @bill_pending_amt=isnull(@v_amt,0)
		end
		print('zzz')
		insert into #cir_temp_ageing (comp_code,unit_code,agcd,dpcd,ag_name,
                city_name,pending_amt,slab_1,slab_2,slab_3,slab_4,slab_5,
                slab_6,rect_pending,on_acamt,sessionid)
        values (@rec_agency_comp_code,@punit_code,@rec_agency_agcd, @rec_agency_dpcd, @rec_agency_agency_name,
               @rec_agency_city_name,isnull(@bill_pending_amt,0),isnull(@debit_amt_030,0),isnull(@debit_amt_3160,0), isnull(@debit_amt_6190,0), isnull(@debit_amt_121180,0), isnull(@debit_amt_181,0),
               0,isnull(@rcpt_pending_amt,0),0,@@spid);
		print('xxx')
		fetch NEXT FROM cur_agency INTO @rec_agency_comp_code,@rec_agency_agcd,@rec_agency_dpcd,@rec_agency_agency_name ,@rec_agency_city_code ,@rec_agency_city_name ,@rec_agency_credit_days ,@rec_agency_branch_name
		    set @debit_amt_030    = 0
			set @debit_amt_3160   = 0
			set @debit_amt_6190   = 0
			set @debit_amt_91120  = 0
			set @debit_amt_121180 = 0
			set @debit_amt_181    = 0
			set @rcpt_pending_amt = 0
			set @bill_pending_amt = 0
		end
		
close cur_agency;
--SELECT 'cursor has ' + CAST(@@CURSOR_ROWS AS VARCHAR) + ' rows'
deallocate cur_agency

select comp_code,unit_code,agcd,dpcd,ag_name,city_name,pending_amt,slab_1,slab_2,slab_3,slab_4,slab_5,
slab_6,rect_pending from #cir_temp_ageing 
/*where (PENDING_AMT>0 or SLAB_1>0 or SLAB_2>0 or SLAB_3>0 or SLAB_4>0 or SLAB_5>0 or ABS(RECT_PENDING)>0  )  
 and sessionid=@@SPID  */
 order by ag_name;
drop table #cir_temp_ageing


//////////////////////////////////////////////////end/////////////////////////////////////////////////////////////////////
	
//--------------------------------------7312---19/04/2012  add by ritu-------------------------------------------//


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO

alter  procedure  [dbo].[cir_del_drop_point_entry]
(

@compcode			as varchar(8),
@unit_code			as varchar(8),
@taxi_id			as varchar(5),
@route_code			as varchar(8),
@sub_route			as varchar(10),
@subsub_route		as varchar(10),
@drop_point_code	as varchar(10),
@arr_date			as datetime,
@exp_arr_time		as varchar(50),
@exp_stop_time		as varchar(50),
@act_arr_time		as varchar(5),
@act_stop_time		as varchar(50),
@extra1				as varchar(20),
@extra2				as varchar(20),
@extra3				as varchar(20),
@extra4				as varchar(20),
@extra5				as varchar(20)
)

as
--select * from CIR_ROUTE_TAXI_MAST

delete from CIR_TAXI_DP_TRANS where COMP_CODE=@compcode and UNIT_CODE=@unit_code and TAXI_ID=@taxi_id and ROUTE_CODE=@route_code and SUB_ROUTECODE=@sub_route and SUB_SUBROUTE_CODE=@subsub_route  and DROP_POINT_CODE=@drop_point_code and ARR_DATE=@arr_date



///////////////////////////////////////////////////////////////////////////////////////////////


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[cir_taxi_dp_trans_save]
	@pcomp_code                               VARCHAR(4000) ,
	@punit_code                               VARCHAR(4000) ,
	@ptaxi_id                                 VARCHAR(4000) ,
	@proute_code                              VARCHAR(4000) ,
	@psub_routecode                           VARCHAR(4000) ,
	@psub_subroute_code                       VARCHAR(4000) ,
	@pdrop_point_code                         VARCHAR(4000) ,
	@pexp_arr_time                            VARCHAR(4000) ,
	@pexp_dep_time                            VARCHAR(4000) ,
	@parr_time                                VARCHAR(4000) ,
	@pdep_time                                VARCHAR(4000) ,
	@parr_date                                datetime,
	@pstopage_time                            VARCHAR(4000) ,
	@pcreated_date                            VARCHAR(4000) ,
	@pcreated_by                              VARCHAR(4000) ,
	@plast_updated_by                         VARCHAR(4000) ,
	@plast_updated_date                       VARCHAR(4000) ,
	@pexp_stop_time                           VARCHAR(4000) ,
	@pdep_date                                datetime,
	@pextra                                   VARCHAR(4000) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) ,
	@pextra3                                  VARCHAR(4000) 
AS 
	BEGIN
		SET NOCOUNT ON
		
		INSERT INTO  cir_taxi_dp_trans   
				( comp_code , 
				unit_code , 
				taxi_id , 
				route_code , 
				sub_routecode , 
				sub_subroute_code , 
				drop_point_code , 
				exp_arr_time , 
				exp_dep_time , 
				arr_time , 
				dep_time , 
				arr_date , 
				stopage_time , 
				created_date , 
				created_by , 
				last_updated_by , 
				last_updated_date , 
				exp_stop_time , 
				dep_date )  
		 VALUES 		( @pcomp_code , 
				@punit_code , 
				@ptaxi_id , 
				@proute_code , 
				@psub_routecode , 
				@psub_subroute_code , 
				@pdrop_point_code , 
				@pexp_arr_time , 
				@pexp_dep_time , 
				@parr_time , 
				@pdep_time , 
				@parr_date , 
				@pstopage_time , 
				@pcreated_date , 
				@pcreated_by , 
				@plast_updated_by , 
				@plast_updated_date , 
				@pexp_stop_time , 
				@pdep_date )  
		
		
		-- IMPLICIT_TRANSACTIONS is set to OFF

		SET NOCOUNT OFF

	END




//-------------------------------------------------------------------------------------------



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[cir_get_route_name](@pcomp_code  varchar(20),@punit_code  varchar(20),@proute  varchar(20)) 
RETURNs varchar(200) AS

   Begin

      declare  @vroute_name      varchar(200)
    select @vroute_name = route_name  from cir_route_mast
            where comp_code=@pcomp_code and unit=@punit_code and route_code=@proute;
  
    Return isnull(@vroute_name,'');
END;



//---------------------------------------------------------------------------------------------

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
                                                                     
                                                                     
                                                                     
                                             
ALTER  FUNCTION [dbo].[cir_get_subroute_name](
@pcomp_code		varchar(20),
@punit_code		varchar(20),
@proute_code	varchar(20),
@psubrt_code	varchar(20)) 
RETURNS varchar(200) 
AS
Begin

 DECLARE @vsubrt_name             VARCHAR (400)
    

        select @vsubrt_name = subrt_name 
        from cir_sub_route_mast 
         where comp_code  = @pcomp_code and
               unit       = @punit_code and
               route_code = @proute_code and
               subrt_code = @psubrt_code;
     
  return isnull(@vsubrt_name,'');
END;


//--------------------------------------------------------------------

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
                                                                     
                                                                     
                                                                     
                                             
ALTER  FUNCTION [dbo].[cir_get_sub_subroute_name](
@pcomp_code		varchar(20),
@punit_code		varchar(20),
@proute_code	varchar(20),
@psubrt_code	varchar(20),
@psubsubrt_code varchar(20)) 
RETURNS varchar(200) as
BEGIN
	
	declare  @vsubsubrt_name   varchar(200)

     select   @vsubsubrt_name = sub_subrt_name 
        from cir_sub_subroute_mast
         where comp_code      = @pcomp_code and
               unit           = @punit_code and
               route_code     = @proute_code and
               subrt_code     = @psubrt_code and
               sub_subrt_code = @psubsubrt_code;
      
  return isnull(@vsubsubrt_name,'');
END;


//----------------------------------------------------------


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[cir_exe_taxidaily_entry]
(
@pcompcode			as	varchar(8),
@punit				as	varchar(8),
@pvehicleno			as	varchar(50),
@pvehicle_name		as	varchar(30),
@proute_code		as	varchar(10),
@psub_route			as	varchar(10),
@psub_subroute		as	varchar(10),
@pfromdep_date		as	datetime,
@ptodep_date		as	datetime,
@pdateformat		as	varchar(20),
@ptaxi_id			as	varchar(5),
@pfreeze_flag		as	varchar(1),
@pextra1			as	varchar(10),
@pextra2			as	varchar(10),
@pextra3			as	varchar(10),
@pextra4			as	varchar(10),
@pextra5			as	varchar(10)
		
)
as
begin
select * from cir_route_taxi_mast
where comp_code=@pcompcode and unit_code=@punit and route_code=@proute_code and 
(sub_routecode=@psub_route or @psub_route is null or @psub_route='')and
(sub_subroute_code=@psub_subroute or @psub_subroute is null or @psub_subroute='') 
and (vehicle_no=@pvehicleno or @pvehicleno is null or @pvehicleno='') and
(dep_date between @pfromdep_date and @ptodep_date) and 
taxi_id=@ptaxi_id and freezze_flag= @pfreeze_flag
end


//----------------------------------------------------------------------------


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[cir_route_drop_point_del]
   (
    @pcomp_code          as varchar(50),
    @punit_code          as varchar(50),
    @ptaxi_code          as varchar(50),
    @proute_code         as varchar(50),
    @psubroutecode       as varchar(50),
    @psub_subroutecode   as varchar(50),
    @puserid             as varchar(50),
    @pdateformat         as varchar(50),
    @pextra1             as varchar(50),--Departure Date
    @pextra2             as varchar(50),
    @pextra3             as varchar(50),
    @pextra4             as varchar(50),
    @pextra5             as varchar(50)
    --p_accounts          OUT Cur_Type_New1.cursor_type)
)
AS
BEGIN
declare @cnt as numeric

select @cnt=count(*) from  cir_taxi_dp_trans
where comp_code=@pcomp_code and unit_code=@punit_code
 and taxi_id=@ptaxi_code
  and 	(route_code=@proute_code or @proute_code='') and (sub_routecode=@psubroutecode  or  @psubroutecode='') and
						(sub_subroute_code=@psub_subroutecode or @psub_subroutecode='') and dep_date=@pextra1

--if @cnt>0 
--begin
--select '1' as output-
	--end
--else begin
--select '0' as output
--	end


if @pextra2='C' begin
if @cnt=0 begin

delete from CIR_ROUTE_TAXI_MAST
where comp_code=@pcomp_code and unit_code=@punit_code
 and taxi_id=@ptaxi_code
  and 	(route_code=@proute_code or @proute_code='') and (sub_routecode=@psubroutecode  or  @psubroutecode='') and
						(sub_subroute_code=@psub_subroutecode or @psub_subroutecode='') and dep_date=@pextra1

end

else
begin

delete from CIR_ROUTE_TAXI_MAST
where comp_code=@pcomp_code and unit_code=@punit_code
 and taxi_id=@ptaxi_code
  and 	(route_code=@proute_code or @proute_code='') and (sub_routecode=@psubroutecode  or  @psubroutecode='') and
						(sub_subroute_code=@psub_subroutecode or @psub_subroutecode='') and dep_date=@pextra1


delete from CIR_TAXI_DP_TRANS
where comp_code=@pcomp_code and unit_code=@punit_code
 and taxi_id=@ptaxi_code
  and 	(route_code=@proute_code or @proute_code='') and (sub_routecode=@psubroutecode  or  @psubroutecode='') and
						(sub_subroute_code=@psub_subroutecode or @psub_subroutecode='') and dep_date=@pextra1



end
end
else

begin
if @cnt>0 
begin
	select '1' as output
end
	else begin
delete from CIR_ROUTE_TAXI_MAST
where comp_code=@pcomp_code and unit_code=@punit_code
 and taxi_id=@ptaxi_code
  and 	(route_code=@proute_code or @proute_code='') and (sub_routecode=@psubroutecode  or  @psubroutecode='') and
						(sub_subroute_code=@psub_subroutecode or @psub_subroutecode='') and dep_date=@pextra1


select '0' as output
	end

end

end


//---------------------------------------------------------------------------------------------------------------------

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[cir_route_drop_point_mod_check]
   (
    @pcomp_code          as varchar(50),
    @punit_code          as varchar(50),
    @ptaxi_code          as varchar(50),
    @proute_code         as varchar(50),
    @psubroutecode       as varchar(50),
    @psub_subroutecode   as varchar(50),
    @puserid             as varchar(50),
    @pdateformat         as varchar(50),
    @pextra1             as varchar(50),--Departure Date
    @pextra2             as varchar(50),
    @pextra3             as varchar(50),
    @pextra4             as varchar(50),
    @pextra5             as varchar(50)
    --p_accounts          OUT Cur_Type_New1.cursor_type)
)
AS
BEGIN
declare @cnt as numeric

select @cnt=count(*) from  cir_taxi_dp_trans
where comp_code=@pcomp_code and unit_code=@punit_code
 and taxi_id=@ptaxi_code
  and 	(route_code=@proute_code or @proute_code='') and (sub_routecode=@psubroutecode  or  @psubroutecode='') and
						(sub_subroute_code=@psub_subroutecode or @psub_subroutecode='') and dep_date=@pextra1

if @cnt>0 
begin
select '1' as output
end
else
begin
select '0' as output
end
end


//-----------------------------------------------------------------------------------------------------------

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[cir_route_drop_point_mod]
   (
    @pcomp_code          as varchar(50),
    @punit_code          as varchar(50),
    @ptaxi_code          as varchar(50),
    @proute_code         as varchar(50),
    @psubroutecode       as varchar(50),
    @psub_subroutecode   as varchar(50),
	@pact_arr			 as varchar(5),
	@pact_dep			 as varchar(5),
    @puserid             as varchar(50),
    @pdateformat         as varchar(50),
    @pextra1             as varchar(50),--Departure Date
    @pextra2             as varchar(50),
    @pextra3             as varchar(50),
    @pextra4             as varchar(50),
    @pextra5             as varchar(50)
    --p_accounts          OUT Cur_Type_New1.cursor_type)
)
as
begin 

declare @cnt as numeric

select @cnt=count(*) from  cir_taxi_dp_trans
where comp_code=@pcomp_code and unit_code=@punit_code
 and taxi_id=@ptaxi_code
  and 	(route_code=@proute_code or @proute_code='') and (sub_routecode=@psubroutecode  or  @psubroutecode='') and
						(sub_subroute_code=@psub_subroutecode or @psub_subroutecode='') and dep_date=@pextra1
if @cnt>0 
begin


update cir_route_taxi_mast set arr_time=@pact_arr , dep_time=@pact_dep 
where comp_code=@pcomp_code and unit_code=@punit_code
 and taxi_id=@ptaxi_code
  and 	(route_code=@proute_code or @proute_code='') and (sub_routecode=@psubroutecode  or  @psubroutecode='') and
						(sub_subroute_code=@psub_subroutecode or @psub_subroutecode='') and dep_date=@pextra1

	end
else begin


update cir_route_taxi_mast set arr_time=@pact_arr , dep_time=@pact_dep , dep_date=@pextra1
where comp_code=@pcomp_code and unit_code=@punit_code
 and taxi_id=@ptaxi_code
  and 	(route_code=@proute_code or @proute_code='') and (sub_routecode=@psubroutecode  or  @psubroutecode='') and
						(sub_subroute_code=@psub_subroutecode or @psub_subroutecode='') and dep_date=@pextra1


update cir_taxi_dp_trans set arr_time=@pact_arr , dep_time=@pact_dep , dep_date=@pextra1
where comp_code=@pcomp_code and unit_code=@punit_code
 and taxi_id=@ptaxi_code
  and 	(route_code=@proute_code or @proute_code='') and (sub_routecode=@psubroutecode  or  @psubroutecode='') and
						(sub_subroute_code=@psub_subroutecode or @psub_subroutecode='') and dep_date=@pextra1


end
end

//-----------------------------------------end by ritu------------------------------------------








      


















/////////////////////////////issue no 6439///////////////////////////////


USE [abhi]
GO
/****** Object:  StoredProcedure [dbo].[cir_rep_supply_cir_supply_comp]    Script Date: 04/20/2012 17:19:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[cir_rep_supply_cir_supply_comp]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@ppublication                             VARCHAR(20) ,
	@psupdate                                 DATETIME ,
	@psupdate1                                DATETIME ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(200) ,
	@pextra2                                  VARCHAR(200)
AS 
	
		
		DECLARE @vsupdate                                 DATETIME 
		DECLARE @vsupdate1                                DATETIME 
		SELECT @vsupdate  = @psupdate
		SELECT @vsupdate1  =  @psupdate1
		--insert into test1(vstring,vstring2) values(pcomp_code||','||punit_code||','||ppublication,psupdate||','||pdateformat||','||pextra1||','||','||pextra2); commit;
		
	if @punit_code =''
	begin
		set @punit_code=null
	end	
	if @ppublication =''
	begin
		set @ppublication=null
	end	
	if @pextra1 =''
	begin
		set @pextra1=null
	end	
	if @pextra2 =''
	begin
		set @pextra2=null
	end	
	
		SELECT
				 comp_code,
				 unit_code,
				 publ,
				 DBO.cir_get_publ_name(comp_code, publ) publ_name,
				 edtn,
				 edtn_name,
				 edtn_name_oth_lang,
				 main_edtn,
				 DBO.cir_get_edtn_name(comp_code, main_edtn) main_edtn_name,
				 prev_sup,
				 curr_sup,
				 ISNULL(curr_sup, 0) - ISNULL(prev_sup, 0) diff,
				 DBO.cir_get_publ_seqno(comp_code, publ) publ_seqno,
				 DBO.cir_get_edtn_seqno(comp_code, main_edtn) mainedtn_seqno,
				 DBO.cir_get_edtn_seqno(comp_code, edtn) edtn_seqno
		FROM (	SELECT DISTINCT
					 comp_code,
					 unit_code,
					 publ,
					 edtn,
					 edtn_name,
					 edtn_name_oth_lang,
					 main_edtn,
					 (			SELECT ISNULL(SUM(CONVERT(FLOAT, sup_copy)), 0)
					FROM  cir_dbksup 
					WHERE	 comp_code  = cir_edtn_mast.comp_code
					 AND	(unit_code  = @punit_code
					 OR	@punit_code  is null)
					 AND	publ  = cir_edtn_mast.publ
					 AND	edtn  = cir_edtn_mast.edtn
					 AND	supdate  = @vsupdate1
		) prev_sup,
					 (			SELECT ISNULL(SUM(CONVERT(FLOAT, sup_copy)), 0)
					FROM  cir_dbksup 
					WHERE	 comp_code  = cir_edtn_mast.comp_code
					 AND	(unit_code  = @punit_code
					 OR	@punit_code  is null)
					 AND	publ  = cir_edtn_mast.publ
					 AND	edtn  = cir_edtn_mast.edtn
					 AND	supdate  = @vsupdate
		) curr_sup
			FROM  cir_edtn_mast 
			WHERE	 comp_code  = @pcomp_code
			 AND	(publ  = @ppublication
			 OR	@ppublication  is null)
			 AND	ISNULL(freeze_flag, 'N')  = 'N'
 and (@pextra1 in (select SUP_TYPE_CODE from cir_dbksup
                               where comp_code  =cir_edtn_mast.comp_code and
                                     unit_code =cir_edtn_mast.unit_code and
                                     publ       =cir_edtn_mast.publ and
                                     edtn       =cir_edtn_mast.edtn )
                                     or @pextra1 is null or @pextra1='')
		) AdventNet_ALIAS1 
		WHERE	 ISNULL(prev_sup, 0) + ISNULL(curr_sup, 0)  > 0
		ORDER BY publ_seqno,
			 unit_code,
			 mainedtn_seqno,
			 edtn_seqno,
			 publ_name,
			 main_edtn_name,
			 edtn_name 
		
		
	
		SELECT
				 comp_code,
				 unit_code,
				 publ,
				 DBO.cir_get_publ_name(comp_code, publ) publ_name,
				 main_edtn,
				 DBO.cir_get_edtn_name(comp_code, main_edtn) main_edtn_name,
				 SUM(CONVERT(FLOAT, prev_sup)) prev_sup,
				 SUM(CONVERT(FLOAT, curr_sup)) curr_sup,
				 SUM(CONVERT(FLOAT, ISNULL(curr_sup, 0) - ISNULL(prev_sup, 0))) diff,
				 DBO.cir_get_publ_seqno(comp_code, publ) publ_seqno,
				 DBO.cir_get_edtn_seqno(comp_code, main_edtn) mainedtn_seqno
		FROM (	SELECT DISTINCT
					 comp_code,
					 unit_code,
					 publ,
					 main_edtn,
					 (			SELECT ISNULL(SUM(CONVERT(FLOAT, sup_copy)), 0)
					FROM  cir_dbksup 
					WHERE	 comp_code  = cir_edtn_mast.comp_code
					 AND	(unit_code  = @punit_code
					 OR	@punit_code  is null)
					 AND	publ  = cir_edtn_mast.publ
					 AND	edtn  = cir_edtn_mast.edtn
					 AND	supdate  = @vsupdate1
		) prev_sup,
					 (			SELECT ISNULL(SUM(CONVERT(FLOAT, sup_copy)), 0)
					FROM  cir_dbksup 
					WHERE	 comp_code  = cir_edtn_mast.comp_code
					 AND	(unit_code  = @punit_code
					 OR	@punit_code  is null)
					 AND	publ  = cir_edtn_mast.publ
					 AND	edtn  = cir_edtn_mast.edtn
					 AND	supdate  =  @vsupdate
		) curr_sup
			FROM  cir_edtn_mast 
			WHERE	 comp_code  = @pcomp_code
			 AND	(publ  = @ppublication
			 OR	@ppublication  is null)
			 AND	ISNULL(freeze_flag, 'N')  = 'N'
 and (@pextra1 in (select SUP_TYPE_CODE from cir_dbksup
                               where comp_code  =cir_edtn_mast.comp_code and
                                     unit_code =cir_edtn_mast.unit_code and
                                     publ       =cir_edtn_mast.publ and
                                     edtn       =cir_edtn_mast.edtn )
                                     or @pextra1 is null or @pextra1='')
		) AdventNet_ALIAS1 
		WHERE	 ISNULL(prev_sup, 0) + ISNULL(curr_sup, 0)  > 0
		GROUP BY comp_code,
			 publ,
			 unit_code,
			  main_edtn 
		ORDER BY publ_seqno,
			 unit_code,
			 mainedtn_seqno,
			 publ_name,
			 main_edtn_name 
		
		
	
		SELECT
				 comp_code,
				 unit_code,
				 publ,
				 DBO.cir_get_publ_name(comp_code, publ) publ_name,
				 SUM(CONVERT(FLOAT, prev_sup)) prev_sup,
				 SUM(CONVERT(FLOAT, curr_sup)) curr_sup,
				 SUM(CONVERT(FLOAT, ISNULL(curr_sup, 0) - ISNULL(prev_sup, 0))) diff,
				 DBO.cir_get_publ_seqno(comp_code, publ) publ_seqno
		FROM (	SELECT DISTINCT
					 comp_code,
					 unit_code,
					 publ,
					 main_edtn,
					 (			SELECT ISNULL(SUM(CONVERT(FLOAT, sup_copy)), 0)
					FROM  cir_dbksup 
					WHERE	 comp_code  = cir_edtn_mast.comp_code
					 AND	(unit_code  = @punit_code
					 OR	@punit_code  is null)
					 AND	publ  = cir_edtn_mast.publ
					 AND	edtn  = cir_edtn_mast.edtn
					 AND	supdate  = @vsupdate1
		) prev_sup,
					 (			SELECT ISNULL(SUM(CONVERT(FLOAT, sup_copy)), 0)
					FROM  cir_dbksup 
					WHERE	 comp_code  = cir_edtn_mast.comp_code
					 AND	(unit_code  = @punit_code
					 OR	@punit_code  is null)
					 AND	publ  = cir_edtn_mast.publ
					 AND	edtn  = cir_edtn_mast.edtn
					 AND	supdate  = @vsupdate
		) curr_sup
			FROM  cir_edtn_mast 
			WHERE	 comp_code  = @pcomp_code
			 AND	(publ  = @ppublication
			 OR	@ppublication  is null)
			 AND	ISNULL(freeze_flag, 'N')  = 'N'
 and (@pextra1 in (select SUP_TYPE_CODE from cir_dbksup
                               where comp_code  =cir_edtn_mast.comp_code and
                                     unit_code =cir_edtn_mast.unit_code and
                                     publ       =cir_edtn_mast.publ and
                                     edtn       =cir_edtn_mast.edtn )
                                     or @pextra1 is null or @pextra1='')
		) AdventNet_ALIAS1 
		WHERE	 ISNULL(prev_sup, 0) + ISNULL(curr_sup, 0)  > 0
		GROUP BY comp_code,
			 publ,
			  unit_code 
		ORDER BY publ_seqno,
			 unit_code,
			 publ_name 
		
		
	
		SELECT
				 comp_code,
				 publ,
				 DBO.cir_get_publ_name(comp_code, publ) publ_name,
				 SUM(CONVERT(FLOAT, prev_sup)) prev_sup,
				 SUM(CONVERT(FLOAT, curr_sup)) curr_sup,
				 SUM(CONVERT(FLOAT, ISNULL(curr_sup, 0) - ISNULL(prev_sup, 0))) diff,
				 DBO.cir_get_publ_seqno(comp_code, publ) publ_seqno
		FROM (	SELECT DISTINCT
					 comp_code,
					 unit_code,
					 publ,
					 edtn,
					 edtn_name,
					 edtn_name_oth_lang,
					 (			SELECT ISNULL(SUM(CONVERT(FLOAT, sup_copy)), 0)
					FROM  cir_dbksup 
					WHERE	 comp_code  = cir_edtn_mast.comp_code
					 AND	(unit_code  = @punit_code
					 OR	@punit_code  is null)
					 AND	publ  = cir_edtn_mast.publ
					 AND	edtn  = cir_edtn_mast.edtn
					 AND	supdate  = @vsupdate1
		) prev_sup,
					 (			SELECT ISNULL(SUM(CONVERT(FLOAT, sup_copy)), 0)
					FROM  cir_dbksup 
					WHERE	 comp_code  = cir_edtn_mast.comp_code
					 AND	(unit_code  = @punit_code
					 OR	@punit_code  is null)
					 AND	publ  = cir_edtn_mast.publ
					 AND	edtn  = cir_edtn_mast.edtn
					 AND	supdate  = @vsupdate
		) curr_sup
			FROM  cir_edtn_mast 
			WHERE	 comp_code  = @pcomp_code
			 AND	(publ  = @ppublication
			 OR	@ppublication  is null)
			 AND	(unit_code  = @punit_code
			 OR	@punit_code  is null)
			 AND	ISNULL(freeze_flag, 'N')  = 'N'
 and (@pextra1 in (select SUP_TYPE_CODE from cir_dbksup
                               where comp_code  =cir_edtn_mast.comp_code and
                                     unit_code =cir_edtn_mast.unit_code and
                                     publ       =cir_edtn_mast.publ and
                                     edtn       =cir_edtn_mast.edtn )
                                     or @pextra1 is null or @pextra1='')
		) AdventNet_ALIAS1 
		WHERE	 ISNULL(prev_sup, 0) + ISNULL(curr_sup, 0)  > 0
		GROUP BY comp_code,
			  publ 
		ORDER BY publ_seqno,
			 publ_name 
		


//////////////////////////////////////////end of issue 6439///////////////////////

/////////////////////////Deepika 21/04/2012 sent by Laxman Sir//////////////////////////////////////////////////////
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
create  procedure [dbo].[cir_cn_transfer_process_p]
    @pcompcode       as varchar(20),
    @punitcode       as varchar(20),
    @pagcode         as varchar(20),
    @pdepocode       as varchar(20),
    @pdatefrom       as datetime,
    @pdatetill       as datetime,
    @precptno        as varchar(2000),
    @preason         as varchar(20),
    @pdn_reason      as varchar(20),
    @pcn_reason      as varchar(20),
    @premark         as varchar(200),
    @puserid         as varchar(20),
    @pdateformat     as varchar(20),
    @pextra1         as varchar(200),
    @pextra2         as varchar(200),
    @pextra3         as varchar(200),
    @pextra4         as varchar(200),
    @pextra5         as varchar(200)
As
    declare @v_recptdt		datetime
    declare @a				int
    declare @v1_comp_code   varchar(20)
    declare @v1_unit_code   varchar(20)
    declare @v1_branch_code varchar(20)
    declare @v1_agcd        varchar(20)
    declare @v1_dpcd        varchar(20)
    declare @v1_amt         numeric(15,2)

    declare @v_dn_reason_name    varchar(200)
    declare @v_cn_reason_name    varchar(200)
    declare @v_cn_doctype        varchar(20)
    declare @v_dn_doctype        varchar(20)
    declare @vcn_ccdp            varchar(20)
    declare @vcn_rcdp            varchar(20)
    declare @vdn_ccdp            varchar(20)
    declare @vdn_rcdp            varchar(20)
        
        
         create table #Results(SegmentNum INT, Edition_Name  VARCHAR(255))
	insert into #Results select * from dbo.Fn_Splitfield(@precptno,',')
     
    declare c1 cursor for
        select comp_code,unit_code,branch_code,agcd,dpcd,abs(sum(amount)) amt from cir_rcphdr
            where comp_code=@pcompcode and unit_code=isnull(@punitcode,unit_code) and 
                agcd=@pagcode and dpcd=@pdepocode and recptdt between @pdatefrom and @pdatetill and 
                reason=@preason and doctype='CN' and achd='NM' and isnull(trf_note_type,'N')<>'Y'
                and recptno in(select edition_name from #results)
                group by comp_code,unit_code,branch_code,agcd,dpcd
                
    declare @v_recptno		varchar(50)
    declare @v_rec_no		int
Begin

    set @v_recptdt   =GETDATE()

   
        
    set @v_cn_doctype ='CN'
    set @v_dn_doctype='DN'
        

    open c1
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN
        fetch c1 into @v1_comp_code,@v1_unit_code,@v1_branch_code,@v1_agcd,@v1_dpcd,@v1_amt
        
        select distinct @v_dn_reason_name=reason_name from cir_reason_mst where reason_code=@pdn_reason
        
        select distinct @v_cn_reason_name =reason_name from cir_reason_mst where reason_code=@pcn_reason
        
        /************************************for Security Deposit**************************/
		
		set @v_recptno  = null
		
		SELECT @v_rec_no  =  CAST( MAX(SUBSTRING(recptno, 5, 8))AS NUMERIC) + 1 FROM  cir_rcphdr 
		WHERE comp_code  = @v1_comp_code AND doctype  = @v_cn_doctype
		AND CONVERT(VARCHAR(23), recptdt) = CONVERT(VARCHAR(23), @v_recptdt) AND branch_code  = @v1_branch_code
		
		IF ISNULL(@v_rec_no, 0)= 0 BEGIN 
			SET @v_recptno  = @v1_branch_code + '-' + REPLACE(CONVERT(VARCHAR(5), GETDATE(), 2), '.', '')+ '0001' 
		END
		ELSE BEGIN 
			SET @v_recptno  = @v1_branch_code + '-' + dbo.fnPadLeft('0',8,@v_rec_no) 
		END

       
          insert into cir_rcphdr(comp_code,unit_code,agcd,dpcd,doctype,
                                 recptno,recptdt,amount,reason,remark,
                                 achd,voucherno,voucherdt,userid,creation_date,branch_code,ccdp,rcdp)
                          values(@v1_comp_code, @v1_unit_code,@v1_agcd, @v1_dpcd,@v_cn_doctype,
                                 @v_recptno,@v_recptdt,-1*@v1_amt,@pcn_reason,@v_cn_reason_name,
                                 'SC',@v_recptno,@v_recptdt,@puserid,GETDATE(),@v1_branch_code,@vcn_ccdp,@vcn_rcdp)

          insert into cir_rcpdet(comp_code,unit_code,agcd,dpcd,doctyp,publ,
                                 recptno,recptdt,payfor,achd,amount,
                                 reason,remark,voucherno,voucherdt,usrid,
                                 creation_date,branch_code)
                          values(@v1_comp_code, @v1_unit_code,@v1_agcd, @v1_dpcd,@v_cn_doctype,null,
                                 @v_recptno,@v_recptdt,@v1_unit_code,'SC',-1*@v1_amt,
                                 @pcn_reason,@v_cn_reason_name,@v_recptno,@v_recptdt,@puserid,
                                 GETDATE(),@v1_branch_code)

          insert into cir_outmast(comp_code,unit_code,agcd,dpcd,doctyp,publ,
                                  recptno,recptdt,achd,amount,reason,
                                  remark,voucherno,voucherdt,usrid,creation_date,branch_code)
                           values(@v1_comp_code, @v1_unit_code,@v1_agcd, @v1_dpcd,@v_cn_doctype,null,
                                  @v_recptno,@v_recptdt,'SC',-1*@v1_amt,@pcn_reason,
                                  @v_cn_reason_name,@v_recptno,@v_recptdt,@puserid,GETDATE(),@v1_branch_code)

        /************************************Credit Note for Security Deposit**************************/

        /************************************Debit Note For Normal**************************/
		
		set @v_recptno  = null
		
		SELECT @v_rec_no  =  CAST( MAX(SUBSTRING(recptno, 5, 8))AS NUMERIC) + 1 FROM  cir_rcphdr 
		WHERE comp_code  = @v1_comp_code AND doctype  = @v_dn_doctype
		AND CONVERT(VARCHAR(23), recptdt) = CONVERT(VARCHAR(23), @v_recptdt) AND branch_code  = @v1_branch_code

		IF ISNULL(@v_rec_no, 0)= 0 BEGIN 
			SET @v_recptno  = @v1_branch_code + '-' + REPLACE(CONVERT(VARCHAR(5), GETDATE(), 2), '.', '')+ '0001' 
		END
		ELSE BEGIN 
			SET @v_recptno  = @v1_branch_code + '-' + dbo.fnPadLeft('0',8,@v_rec_no) 
		END

        
          insert into cir_rcphdr(comp_code,unit_code,agcd,dpcd,doctype,
                                 recptno,recptdt,amount,reason,remark,
                                 achd,voucherno,voucherdt,userid,creation_date,branch_code,ccdp,rcdp)
                          values(@v1_comp_code, @v1_unit_code,@v1_agcd, @v1_dpcd,@v_dn_doctype,
                                 @v_recptno,@v_recptdt,@v1_amt,@pdn_reason,@v_dn_reason_name,
                                 'NM',@v_recptno,@v_recptdt,@puserid,GETDATE(),@v1_branch_code,@vdn_ccdp,@vdn_rcdp)

          insert into cir_rcpdet(comp_code,unit_code,agcd,dpcd,doctyp,publ,
                                 recptno,recptdt,payfor,achd,amount,
                                 reason,remark,voucherno,voucherdt,usrid,
                                 creation_date,branch_code)
                          values(@v1_comp_code, @v1_unit_code,@v1_agcd, @v1_dpcd,@v_dn_doctype,null,
                                 @v_recptno,@v_recptdt,@v1_unit_code,'NM',@v1_amt,
                                 @pdn_reason,@v_dn_reason_name,@v_recptno,@v_recptdt,@puserid,
                                 GETDATE(),@v1_branch_code)
                                 
          insert into cir_outmast(comp_code,unit_code,agcd,dpcd,doctyp,publ,
                                  recptno,recptdt,achd,amount,reason,
                                  remark,voucherno,voucherdt,usrid,creation_date,branch_code)
                           values(@v1_comp_code, @v1_unit_code,@v1_agcd, @v1_dpcd,@v_dn_doctype,null,
                                  @v_recptno,@v_recptdt,'NM',@v1_amt,@pdn_reason,
                                  @v_dn_reason_name,@v_recptno,@v_recptdt,@puserid,GETDATE(),@v1_branch_code)

        update cir_rcphdr set trf_note_type='Y'
            where comp_code=@v1_comp_code and unit_code=@v1_unit_code and 
                agcd=@v1_agcd and dpcd=@v1_dpcd and recptdt between @pdatefrom and @pdatetill and 
                reason=@preason and doctype='CN' and achd='NM' and isnull(trf_note_type,'N')<>'Y'
                and branch_code=@v1_branch_code
                and recptno in(select edition_name from #results)
        /************************************Debit Note For Normal**************************/
		fetch c1 into @v1_comp_code,@v1_unit_code,@v1_branch_code,@v1_agcd,@v1_dpcd,@v1_amt                                  
    end
    close c1;
    select GETDATE() as "CUR_DATE"

End


////////////////////////////////
                                                                                                                                                                                                                                                  
create procedure cir_trans_cn_to_security_cir_rcpdet_bind
    @pcompcode   as varchar(20),
    @punitcode   as varchar(20),
    @preason     as varchar(20),
    @pfromdt     as varchar(20),
    @ptodt       as varchar(20),
    @pagcd       as varchar(20),
    @pdpcd       as varchar(20),
    @pdroctyp    as varchar(20),
    @pdateformat as varchar(20),
    @pextra1     as varchar(200),
    @pextra2     as varchar(200),
    @pextra3     as varchar(200),
    @pextra4     as varchar(200),
    @pextra5     as varchar(200)
as
    declare @v_frdt    datetime
    declare @v_todt    datetime
begin
   
   set @v_frdt	=	DBO.CONVERT_USEr_DATE('/', @pfromdt,@pdateformat)
   set @v_todt	=	DBO.CONVERT_USEr_DATE('/', @ptodt,@pdateformat)
    
    select * from cir_rcphdr
    where comp_code=@pcompcode and unit_code=isnull(@punitcode,unit_code) and 
        agcd=@pagcd and dpcd=@pdpcd and recptdt between @v_frdt and @v_todt and 
        reason=@preason and doctype=@pdroctyp and achd='NM' and isnull(trf_note_type,'N')<>'Y'

end 


///////////////////////////////////////End of procedures sent by Laxman Sir 21/04/2012/////////////////////////////


/**********************Neha**21-04-2012***************************************/

create function [dbo].[cir_get_branch]
(
@pcomp_code as varchar(50),
@branch_code as varchar(50))

RETURNs varchar(4000) 
AS

BEGIN
  declare @vbranch_name as varchar(4000)
     
         select @vbranch_name =BRANCH_NAME from branch_mst where Branch_Code=@branch_code;
  
    return isnull(@vbranch_name,'');
end


==========================7092========avinash=======start=========21apr2012===============================


 alter procedure cir_rep_routemode_cir_dist_taluka_wise_p
     @pcompcode          as varchar(20),
     @punitcode          as varchar(20),
     @pbrancode          as varchar(20),
     @ppublcode          as varchar(20),
     @proutemode         as varchar(20),
     @proutecode         as varchar(20),
     @pdistcode          as varchar(20),
     @ptaluka            as varchar(20),
     @pfrom_supdate      as varchar(20),
     @ptill_supdate      as varchar(20),
     @pcopy_packet       as int,
     @padj_copy          as int,
     @pperpkt_rate       as numeric(12,2),
     @plangtype          as int,
     @pdateformat        as varchar(200),
     @pextra1            as varchar(200),--IT IS USED FOR BREAK ON DISTRICT TALUKA AND ROUTE WISE(1/2)
     @pextra2            as varchar(200)
as
     declare @vsupdate       datetime
     declare @vsupdate1      datetime
Begin
	If @punitcode='' Begin
		set @punitcode=null
	End
	If @pbrancode='' Begin
		set @pbrancode=null
	End
	If @ppublcode='' Begin
		set @ppublcode=null
	End
	If @proutemode='' Begin
		set @proutemode=null
	End
	If @proutecode='' Begin
		set @proutecode=null
	End
	If @pdistcode='' Begin
		set @pdistcode=null
	End
	If @ptaluka='' Begin
		set @ptaluka=null
	End

	SET @vsupdate  = DBO.CONVERT_USEr_DATE('/', @pfrom_supdate,@pdateformat)
	SET @vsupdate1 = DBO.CONVERT_USEr_DATE('/', @ptill_supdate,@pdateformat)
     
	if isnull(@pextra1,'1')='1' Begin
        select cir_dbksup.comp_code comp_code,cir_dbksup.unit_code unit_code,
        cir_agmast.dist_code dist_code,
        case when @plangtype=2 then
            cir_dist_mast.dist_oname 
        else
            cir_dist_mast.dist_name 
        end dist_name,
               cir_dist_mast.dist_seqno dist_seqno,
               cir_agmast.tehsil_taluka tehsil_taluka,
        case when @plangtype=2 then
            dbo.cir_get_name_cir_taluka(cir_dbksup.comp_code,cir_agmast.tehsil_taluka,'2',@pdateformat,null,null)
        else
            dbo.cir_get_taluka(cir_dbksup.comp_code,cir_agmast.tehsil_taluka)
        end taluka_name,
               dbo.cir_get_taluka_seqno(cir_dbksup.comp_code,cir_agmast.tehsil_taluka) taluka_seqno,
               isnull(cir_dbksup.subsubroute_code,cir_dbksup.subroute_code) route_code,
               case when cir_dbksup.subsubroute_code is null then
                dbo.cir_get_name_cir_subroute(cir_dbksup.comp_code,cir_dbksup.unit_code,cir_dbksup.route_code,cir_dbksup.subroute_code,@plangtype,@pdateformat,null,null)
               else
                dbo.cir_get_name_cir_subsubroute(cir_dbksup.comp_code,cir_dbksup.unit_code,cir_dbksup.route_code,cir_dbksup.subroute_code,cir_dbksup.subsubroute_code,@plangtype,@pdateformat,null,null)
               end route_name,
               case when cir_dbksup.subsubroute_code is null then
                dbo.cir_get_subroute_seqno(cir_dbksup.comp_code,cir_dbksup.unit_code,cir_dbksup.route_code,cir_dbksup.subroute_code)
               else
                dbo.cir_get_subsubroute_seqno(cir_dbksup.comp_code,cir_dbksup.unit_code,cir_dbksup.route_code,cir_dbksup.subroute_code,cir_dbksup.subsubroute_code)
               end  route_seqno,
                case when (sum(sup_copy)%@pcopy_packet)<=@padj_copy then
                    case when (ceiling(sum(sup_copy)/@pcopy_packet))=0 then
                        1*isnull(@pperpkt_rate,0)
                    else
                        (ceiling(sum(sup_copy)/@pcopy_packet))*isnull(@pperpkt_rate,0)
                    end 
                else
                    (ceiling(sum(sup_copy)/@pcopy_packet)+1)*isnull(@pperpkt_rate,0)
                end bundle_amount,
               cir_dbksup.agcd agcd,cir_dbksup.dpcd dpcd,isnull(cir_agmast.print_seq,1) agency_seqno,
               cir_agmast.ag_name ag_name,cir_agmast.ag_name_oth_lang ag_name_oth_lang,sum(sup_copy) supply,
               dbo.cir_get_drop_point_name(cir_dbksup.comp_code,cir_dbksup.unit_code,cir_agmast.station_code,@plangtype) drop_point_name
               from cir_dbksup,cir_agmast,cir_dist_mast
               where cir_dbksup.comp_code    = cir_agmast.comp_code and
                     cir_agmast.comp_code    = cir_dist_mast.comp_code and
                     cir_dbksup.unit_code    = cir_agmast.unit and
                     cir_dbksup.agcd         = cir_agmast.agcd and
                     cir_dbksup.dpcd         = cir_agmast.dpcd and
                     cir_dbksup.comp_code    = @pcompcode and
                     cir_dbksup.unit_code    = @punitcode and
                     cir_dbksup.publ         = @ppublcode and
                     cir_dbksup.supdate between @vsupdate and @vsupdate1 and
                     ((cir_agmast.dist_code  = @pdistcode) or (@pdistcode is null)) and
                     cir_agmast.dist_code  = cir_dist_mast.dist_code and
                     ((cir_agmast.tehsil_taluka = @ptaluka) or (@ptaluka is null)) and
                     cir_dbksup.subroute_code in(select subrt_code from cir_sub_route_mast where comp_code=@pcompcode and unit_code=@punitcode and 
                     (route_code=@proutecode or @proutecode is null) and (subrt_mode=@proutemode))
                  group by cir_dbksup.comp_code,cir_dbksup.unit_code,
                           cir_agmast.state_code,cir_agmast.dist_code,cir_agmast.tehsil_taluka,
                           cir_dbksup.route_code,cir_dbksup.subroute_code,cir_dbksup.subsubroute_code,
                           cir_dbksup.agcd,cir_dbksup.dpcd,isnull(cir_agmast.print_seq,1),cir_agmast.ag_name,cir_agmast.ag_name_oth_lang,
                           cir_dist_mast.dist_name,cir_dist_mast.dist_oname,cir_dist_mast.dist_seqno,cir_agmast.station_code
                  order by cir_dbksup.comp_code,cir_dbksup.unit_code,dist_seqno,dist_name,taluka_seqno,taluka_name,agency_seqno,ag_name;
	End
    Else Begin

        select cir_dbksup.comp_code comp_code,cir_dbksup.unit_code unit_code,
        cir_agmast.dist_code dist_code,
        case when @plangtype=2 then
            cir_dist_mast.dist_oname 
        else
            cir_dist_mast.dist_name 
        end dist_name,
               cir_dist_mast.dist_seqno dist_seqno,
               cir_agmast.tehsil_taluka tehsil_taluka,
        case when @plangtype=2 then
            dbo.cir_get_name_cir_taluka(cir_dbksup.comp_code,cir_agmast.tehsil_taluka,'2',@pdateformat,null,null)
        else
            dbo.cir_get_taluka(cir_dbksup.comp_code,cir_agmast.tehsil_taluka)
        end taluka_name,
               dbo.cir_get_taluka_seqno(cir_dbksup.comp_code,cir_agmast.tehsil_taluka) taluka_seqno,
               isnull(cir_dbksup.subsubroute_code,cir_dbksup.subroute_code) route_code,
               case when cir_dbksup.subsubroute_code is null then
                dbo.cir_get_name_cir_subroute(cir_dbksup.comp_code,cir_dbksup.unit_code,cir_dbksup.route_code,cir_dbksup.subroute_code,@plangtype,@pdateformat,null,null)
               else
                dbo.cir_get_name_cir_subsubroute(cir_dbksup.comp_code,cir_dbksup.unit_code,cir_dbksup.route_code,cir_dbksup.subroute_code,cir_dbksup.subsubroute_code,@plangtype,@pdateformat,null,null)
               end route_name,
               case when cir_dbksup.subsubroute_code is null then
                dbo.cir_get_subroute_seqno(cir_dbksup.comp_code,cir_dbksup.unit_code,cir_dbksup.route_code,cir_dbksup.subroute_code)
               else
                dbo.cir_get_subsubroute_seqno(cir_dbksup.comp_code,cir_dbksup.unit_code,cir_dbksup.route_code,cir_dbksup.subroute_code,cir_dbksup.subsubroute_code)
               end  route_seqno,
                case when (sum(sup_copy)%@pcopy_packet)<=@padj_copy then
                    case when (ceiling(sum(sup_copy)/@pcopy_packet))=0 then
                        1*isnull(@pperpkt_rate,0)
                    else
                        (ceiling(sum(sup_copy)/@pcopy_packet))*isnull(@pperpkt_rate,0)
                    end 
                else
                    (ceiling(sum(sup_copy)/@pcopy_packet)+1)*isnull(@pperpkt_rate,0)
                end bundle_amount,
               cir_dbksup.agcd agcd,cir_dbksup.dpcd dpcd,isnull(cir_agmast.print_seq,1) agency_seqno,
               cir_agmast.ag_name ag_name,cir_agmast.ag_name_oth_lang ag_name_oth_lang,sum(sup_copy) supply,
               dbo.cir_get_drop_point_name(cir_dbksup.comp_code,cir_dbksup.unit_code,cir_agmast.station_code,@plangtype) drop_point_name
               from cir_dbksup,cir_agmast,cir_dist_mast
               where cir_dbksup.comp_code    = cir_agmast.comp_code and
                     cir_agmast.comp_code    = cir_dist_mast.comp_code and
                     cir_dbksup.unit_code    = cir_agmast.unit and
                     cir_dbksup.agcd         = cir_agmast.agcd and
                     cir_dbksup.dpcd         = cir_agmast.dpcd and
                     cir_dbksup.comp_code    = @pcompcode and
                     cir_dbksup.unit_code    = @punitcode and
                     cir_dbksup.publ         = @ppublcode and
                     cir_dbksup.supdate between @vsupdate and @vsupdate1 and
                     ((cir_agmast.dist_code  = @pdistcode) or (@pdistcode is null)) and
                     cir_agmast.dist_code  = cir_dist_mast.dist_code and
                     cir_dbksup.subroute_code in(select subrt_code from cir_sub_route_mast where comp_code=@pcompcode and unit_code=@punitcode and 
                     (route_code=@proutecode or @proutecode is null) and (subrt_mode=@proutemode))
                  group by cir_dbksup.comp_code,cir_dbksup.unit_code,
                           cir_agmast.state_code,cir_agmast.dist_code,cir_agmast.tehsil_taluka,
                           cir_dbksup.route_code,cir_dbksup.subroute_code,cir_dbksup.subsubroute_code,
                           cir_dbksup.agcd,cir_dbksup.dpcd,isnull(cir_agmast.print_seq,1),cir_agmast.ag_name,cir_agmast.ag_name_oth_lang,
                           cir_dist_mast.dist_name,cir_dist_mast.dist_oname,cir_dist_mast.dist_seqno,cir_agmast.station_code
                  order by cir_dbksup.comp_code,cir_dbksup.unit_code,route_name,agency_seqno,ag_name;                              
	End
            
    if isnull(@pextra1,'1')='1' Begin
            select cir_dbksup.comp_code,cir_dbksup.unit_code,
                case when @plangtype=2 then
                    cir_dist_mast.dist_oname 
                else
                    cir_dist_mast.dist_name 
                end dist_name,
                   cir_agmast.tehsil_taluka,
                   cir_dist_mast.dist_seqno dist_seqno,
				case when @plangtype=2 then
					dbo.cir_get_name_cir_taluka(cir_dbksup.comp_code,cir_agmast.tehsil_taluka,'2',@pdateformat,null,null)
				else
					dbo.cir_get_taluka(cir_dbksup.comp_code,cir_agmast.tehsil_taluka)
				end taluka_name,
					   dbo.cir_get_taluka_seqno(cir_dbksup.comp_code,cir_agmast.tehsil_taluka) taluka_seqno,
                   sum(sup_copy) supply from cir_dbksup,cir_agmast,cir_dist_mast
                   where cir_dbksup.comp_code    = cir_agmast.comp_code and
                         cir_agmast.comp_code    = cir_dist_mast.comp_code and
                         cir_dbksup.unit_code    = cir_agmast.unit and
                         cir_dbksup.agcd         = cir_agmast.agcd and
                         cir_dbksup.dpcd         = cir_agmast.dpcd and
                         cir_dbksup.comp_code    = @pcompcode and
                         cir_dbksup.unit_code    = @punitcode and
                         cir_dbksup.publ         = @ppublcode and
                         cir_dbksup.supdate between @vsupdate and @vsupdate1 and
                         cir_agmast.dist_code  = cir_dist_mast.dist_code and
                         ((cir_agmast.dist_code = @pdistcode) or (@pdistcode is null)) and
                         ((cir_agmast.tehsil_taluka = @ptaluka) or (@ptaluka is null)) and
                         cir_dbksup.subroute_code in(select subrt_code from cir_sub_route_mast where comp_code=@pcompcode and unit_code=@punitcode and 
                         (route_code=@proutecode or @proutecode is null) and (subrt_mode=@proutemode))                     
                      group by cir_dbksup.comp_code,cir_dbksup.unit_code,
                               cir_agmast.state_code,cir_agmast.dist_code,cir_agmast.tehsil_taluka,
                               cir_dist_mast.dist_name,cir_dist_mast.dist_oname,cir_dist_mast.dist_seqno
                      order by cir_dbksup.comp_code,cir_dbksup.unit_code,dist_seqno,dist_name,taluka_seqno,taluka_name;
    End
    Else Begin
        
        select cir_dbksup.comp_code,cir_dbksup.unit_code,
           isnull(cir_dbksup.subsubroute_code,cir_dbksup.subroute_code) route_code,
           case when cir_dbksup.subsubroute_code is null then
            dbo.cir_get_name_cir_subroute(cir_dbksup.comp_code,cir_dbksup.unit_code,cir_dbksup.route_code,cir_dbksup.subroute_code,@plangtype,@pdateformat,null,null)
           else
            dbo.cir_get_name_cir_subsubroute(cir_dbksup.comp_code,cir_dbksup.unit_code,cir_dbksup.route_code,cir_dbksup.subroute_code,cir_dbksup.subsubroute_code,@plangtype,@pdateformat,null,null)
           end route_name,
           case when cir_dbksup.subsubroute_code is null then
            dbo.cir_get_subroute_seqno(cir_dbksup.comp_code,cir_dbksup.unit_code,cir_dbksup.route_code,cir_dbksup.subroute_code)
           else
            dbo.cir_get_subsubroute_seqno(cir_dbksup.comp_code,cir_dbksup.unit_code,cir_dbksup.route_code,cir_dbksup.subroute_code,cir_dbksup.subsubroute_code)
           end  route_seqno,
               sum(sup_copy) supply from cir_dbksup,cir_agmast,cir_drop_point_mast
               where cir_dbksup.comp_code    = cir_agmast.comp_code and
                     cir_agmast.comp_code    = cir_drop_point_mast.comp_code and
                     cir_dbksup.unit_code    = cir_agmast.unit and
                     cir_dbksup.unit_code    = cir_drop_point_mast.unit_code and
                     cir_dbksup.agcd         = cir_agmast.agcd and
                     cir_dbksup.dpcd         = cir_agmast.dpcd and
                     cir_dbksup.comp_code    = @pcompcode and
                     cir_dbksup.unit_code    = @punitcode and
                     cir_dbksup.publ         = @ppublcode and
                     cir_dbksup.supdate between @vsupdate and @vsupdate1 and
                     cir_agmast.station_code  = cir_drop_point_mast.drop_point and
                     ((cir_agmast.dist_code = @pdistcode) or (@pdistcode is null)) and
                     ((cir_agmast.tehsil_taluka = @ptaluka) or (@ptaluka is null)) and
                     cir_dbksup.subroute_code in(select subrt_code from cir_sub_route_mast where cir_sub_route_mast.comp_code=@pcompcode and cir_sub_route_mast.unit=@punitcode and 
                     (cir_sub_route_mast.route_code=@proutecode or @proutecode is null) and (cir_sub_route_mast.subrt_mode=@proutemode))                     
                  group by cir_dbksup.comp_code,cir_dbksup.unit_code,
                           cir_dbksup.route_code,cir_dbksup.subroute_code,cir_dbksup.subsubroute_code
                  order by cir_dbksup.comp_code,cir_dbksup.unit_code,route_name;            
    End
            
    if isnull(@pextra1,'1')='1' Begin
        select cir_dbksup.comp_code,cir_dbksup.unit_code,cir_agmast.dist_code,
            case when @plangtype=2 then
                cir_dist_mast.dist_oname 
            else
                cir_dist_mast.dist_name 
            end dist_name,
               cir_dist_mast.dist_seqno dist_seqno,
               sum(sup_copy) supply from cir_dbksup,cir_agmast,cir_dist_mast,cir_taluka_mast
               where cir_dbksup.comp_code    = cir_agmast.comp_code and
                     cir_agmast.comp_code    = cir_dist_mast.comp_code and
                     cir_agmast.comp_code    = cir_taluka_mast.comp_code and
                     cir_dbksup.unit_code    = cir_agmast.unit and
                     cir_dbksup.agcd         = cir_agmast.agcd and
                     cir_dbksup.dpcd         = cir_agmast.dpcd and
                     cir_dbksup.comp_code    = @pcompcode and
                     cir_dbksup.unit_code    = @punitcode and
                     cir_dbksup.publ         = @ppublcode and
                     cir_dbksup.supdate between @vsupdate and @vsupdate1 and
                     cir_agmast.dist_code  = cir_dist_mast.dist_code and
                     cir_agmast.tehsil_taluka  = cir_taluka_mast.talu_code and
                     ((cir_agmast.dist_code = @pdistcode) or (@pdistcode is null)) and
                     ((cir_agmast.tehsil_taluka = @ptaluka) or (@ptaluka is null)) and
                     cir_dbksup.subroute_code in(select subrt_code from cir_sub_route_mast where comp_code=@pcompcode and unit_code=@punitcode and 
                     (route_code=@proutecode or @proutecode is null) and (subrt_mode=@proutemode))
                  group by cir_dbksup.comp_code,cir_dbksup.unit_code,
                           cir_agmast.state_code,cir_agmast.dist_code,cir_dist_mast.dist_name,cir_dist_mast.dist_oname,cir_dist_mast.dist_seqno
                  order by cir_dbksup.comp_code,cir_dbksup.unit_code,dist_seqno,dist_name;
	End
    Else Begin
		select GETDATE()
	End
        select cir_dbksup.comp_code,cir_dbksup.unit_code,
               sum(sup_copy) supply from cir_dbksup,cir_agmast,cir_dist_mast,cir_taluka_mast
               where cir_dbksup.comp_code    = cir_agmast.comp_code and
                     cir_agmast.comp_code    = cir_dist_mast.comp_code and
                     cir_agmast.comp_code    = cir_taluka_mast.comp_code and
                     cir_dbksup.unit_code    = cir_agmast.unit and
                     cir_dbksup.agcd         = cir_agmast.agcd and
                     cir_dbksup.dpcd         = cir_agmast.dpcd and
                     cir_dbksup.comp_code    = @pcompcode and
                     cir_dbksup.unit_code    = @punitcode and
                     cir_dbksup.publ         = @ppublcode and
                     cir_dbksup.supdate between @vsupdate and @vsupdate1 and
                     ((cir_agmast.dist_code = @pdistcode) or (@pdistcode is null)) and
                     cir_agmast.dist_code  = cir_dist_mast.dist_code and
                     cir_agmast.tehsil_taluka  = cir_taluka_mast.talu_code and
                     ((cir_agmast.tehsil_taluka = @ptaluka) or (@ptaluka is null)) and
                     cir_dbksup.subroute_code in(select subrt_code from cir_sub_route_mast where comp_code=@pcompcode and unit_code=@punitcode and 
                     (route_code=@proutecode or @proutecode is null) and (subrt_mode=@proutemode))
                  group by cir_dbksup.comp_code,cir_dbksup.unit_code
                  order by cir_dbksup.comp_code,cir_dbksup.unit_code;

     End


==========================7092========avinash=======end=========21apr2012===============================

//------------------------------start 21/04/2012------------------------------------//

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO


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
    @pextra3								  VARCHAR(4000),---------commsion category
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
			BEGIN print('*')
				IF @pcopy_percent_flag = 'C' 
				BEGIN print('**')
					update cir_supply set cir_supply.supply_spl1=isnull(cir_supply.supply_sun,0)+isnull(@pcopy_percent,0)
						where cir_supply.comp_code= @pcompcode and cir_supply.unit= @punitcode and cir_supply.publ= @ppublcode and cir_supply.edtn in(select e.edtn from cir_edtn_mast e 
							where e.comp_code=cir_supply.comp_code and e.unit_code=cir_supply.unit and e.publ=cir_supply.publ and e.main_edtn=isnull(@pedtncode,e.main_edtn)) and
						cir_supply.edtn=isnull(@pextra1,cir_supply.edtn) and 
						cir_supply.supply_type_code= @psup_type and cir_supply.agcd=@vagcd1 and cir_supply.dpcd=@vdpcd1 and isnull(cir_supply.supply_flag,'N')='Y' and 
						(cir_supply.route_code= @proute or @proute is null) and   
						isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_sun,0)>=isnull(@psupply_from,0) and isnull(cir_supply.base_supply,0)+isnull(cir_supply.supply_sun,0)<=isnull(@psupply_till,0)
				END
				
				IF (@pcopy_percent_flag = 'P' )
				BEGIN print('***') print(@pcopy_percent) print(@vagcd1) print(@vdpcd1)
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
	IF (@pspl_type = '1' )
	begin	print('Q')
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
                   isnull(b.supply_spl1,0)!=0 and @pspl_type='1' and 
                   ((isnull(b.base_supply,0)+isnull(b.supply_sun,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_sun,0)<=isnull( @psupply_till,0) and upper( @pextra2)='SUN') or
                    (isnull(b.base_supply,0)+isnull(b.supply_mon,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_mon,0)<=isnull( @psupply_till,0) and upper( @pextra2)='MON') or
                    (isnull(b.base_supply,0)+isnull(b.supply_tue,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_tue,0)<=isnull( @psupply_till,0) and upper( @pextra2)='TUE') or
                    (isnull(b.base_supply,0)+isnull(b.supply_wed,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_wed,0)<=isnull( @psupply_till,0) and upper( @pextra2)='WED') or
                    (isnull(b.base_supply,0)+isnull(b.supply_thu,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_thu,0)<=isnull( @psupply_till,0) and upper( @pextra2)='THU') or
                    (isnull(b.base_supply,0)+isnull(b.supply_fri,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_fri,0)<=isnull( @psupply_till,0) and upper( @pextra2)='FRI') or
                    (isnull(b.base_supply,0)+isnull(b.supply_sat,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_sat,0)<=isnull( @psupply_till,0) and upper( @pextra2)='SAT'))
            /* union
             select b.comp_code comp_code,b.unit unit,b.publ publ,b.edtn edtn,e.edtn_name edtn_name,
             b.supply_type_code supply_type_code,b.agcd agcd,b.dpcd,
             a.ag_name agency_name,dbo.cir_get_city(a.comp_code,a.city_code) city_name,b.base_supply base_supply,b.supply_spl1 special_supply,
             isnull(c.route_seq,1) route_seq,b.lbl_printno supply_seq 
             from cir_agmast a,cir_supply b ,cir_route_mast c ,cir_edtn_mast e
             where a.comp_code= @pcompcode and a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=e.comp_code and a.unit= @punitcode and a.unit=b.unit and a.unit=c.unit and a.unit=e.unit_code and 
                   a.agcd=b.agcd and a.dpcd=b.dpcd and
                   b.publ= @ppublcode and b.publ=e.publ and b.edtn=e.edtn and b.edtn=isnull( @pextra1,b.edtn) and e.main_edtn=isnull( @pedtncode,e.main_edtn) and b.supply_type_code= @psup_type and isnull(b.supply_flag,'N')='Y' and
                   b.route_code=c.route_code and (b.route_code= @proute or  @proute is null) and 
                   isnull(a.suspend,'N')='N' and (a.ag_type= @pag_type or  @pag_type is null) and (a.ag_class= @pag_class or  @pag_class is null) and 
                   (a.state_code= @pstate or  @pstate is null) and (a.dist_code= @pdistcode or  @pdistcode is null) and (a.tehsil_taluka= @ptalukacode or  @ptalukacode is null) and 
                   isnull(b.supply_spl1,0)>0 and @pspl_type='1' and
                   ((isnull(b.base_supply,0)+isnull(b.supply_sun,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_sun,0)<=isnull( @psupply_till,0) and upper( @pextra2)='SUN') or
                    (isnull(b.base_supply,0)+isnull(b.supply_mon,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_mon,0)<=isnull( @psupply_till,0) and upper( @pextra2)='MON') or
                    (isnull(b.base_supply,0)+isnull(b.supply_tue,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_tue,0)<=isnull( @psupply_till,0) and upper( @pextra2)='TUE') or
                    (isnull(b.base_supply,0)+isnull(b.supply_wed,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_wed,0)<=isnull( @psupply_till,0) and upper( @pextra2)='WED') or
                    (isnull(b.base_supply,0)+isnull(b.supply_thu,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_thu,0)<=isnull( @psupply_till,0) and upper( @pextra2)='THU') or
                    (isnull(b.base_supply,0)+isnull(b.supply_fri,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_fri,0)<=isnull( @psupply_till,0) and upper( @pextra2)='FRI') or
                    (isnull(b.base_supply,0)+isnull(b.supply_sat,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_sat,0)<=isnull( @psupply_till,0) and upper( @pextra2)='SAT'))*/) z
             order by route_seq,supply_seq,edtn_name,city_name,agency_name 
	end
	else
	begin print('Z')
	SELECT Z.COMP_CODE COMP_CODE,Z.UNIT UNIT,Z.PUBL PUBL,Z.EDTN EDTN,Z.EDTN_NAME EDTN_NAME,
             Z.SUPPLY_TYPE_CODE SUPPLY_TYPE_CODE,Z.AGCD AGCD,Z.DPCD,
             Z.AGENCY_NAME AGENCY_NAME,Z.CITY_NAME CITY_NAME,Z.BASE_SUPPLY BASE_SUPPLY,Z.SPECIAL_SUPPLY SPECIAL_SUPPLY,
             Z.ROUTE_SEQ ROUTE_SEQ,Z.SUPPLY_SEQ SUPPLY_SEQ
			 from(select b.comp_code comp_code,b.unit unit,b.publ publ,b.edtn edtn,e.edtn_name edtn_name,
             b.supply_type_code supply_type_code,b.agcd agcd,b.dpcd,
             a.ag_name agency_name,dbo.cir_get_city(a.comp_code,a.city_code) city_name,b.base_supply base_supply,b.supply_spl2 special_supply,
             isnull(c.route_seq,1) route_seq,b.lbl_printno supply_seq 
             from cir_agmast a,cir_supply b,cir_route_mast c ,cir_edtn_mast e
             where a.comp_code= @pcompcode and a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=e.comp_code and a.unit= @punitcode and a.unit=b.unit and a.unit=c.unit and a.unit=e.unit_code and 
                   a.agcd=b.agcd and a.dpcd=b.dpcd and
                   b.publ= @ppublcode and b.publ=e.publ and b.edtn=e.edtn and b.edtn=isnull(@pextra1,b.edtn) and e.main_edtn=isnull( @pedtncode,e.main_edtn) and b.supply_type_code= @psup_type and isnull(b.supply_flag,'N')='Y' and
                   b.route_code=c.route_code and (b.route_code= @proute or @proute is null) and 
                   isnull(a.suspend,'N')='N' and (a.ag_type= @pag_type or @pag_type is null) and (a.ag_class= @pag_class or  @pag_class is null) and 
                   (a.state_code= @pstate or @pstate is null) and (a.dist_code= @pdistcode or  @pdistcode is null) and (a.tehsil_taluka= @ptalukacode or  @ptalukacode is null) and 
                   isnull(b.supply_spl2,0)!=0 and @pspl_type='2' and 
                   ((isnull(b.base_supply,0)+isnull(b.supply_sun,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_sun,0)<=isnull( @psupply_till,0) and upper( @pextra2)='SUN') or
                    (isnull(b.base_supply,0)+isnull(b.supply_mon,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_mon,0)<=isnull( @psupply_till,0) and upper( @pextra2)='MON') or
                    (isnull(b.base_supply,0)+isnull(b.supply_tue,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_tue,0)<=isnull( @psupply_till,0) and upper( @pextra2)='TUE') or
                    (isnull(b.base_supply,0)+isnull(b.supply_wed,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_wed,0)<=isnull( @psupply_till,0) and upper( @pextra2)='WED') or
                    (isnull(b.base_supply,0)+isnull(b.supply_thu,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_thu,0)<=isnull( @psupply_till,0) and upper( @pextra2)='THU') or
                    (isnull(b.base_supply,0)+isnull(b.supply_fri,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_fri,0)<=isnull( @psupply_till,0) and upper( @pextra2)='FRI') or
                    (isnull(b.base_supply,0)+isnull(b.supply_sat,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_sat,0)<=isnull( @psupply_till,0) and upper( @pextra2)='SAT'))
            /* union
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
                    (isnull(b.base_supply,0)+isnull(b.supply_sat,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_sat,0)<=isnull( @psupply_till,0) and upper( @pextra2)='SAT'))*/) z
             order by route_seq,supply_seq,edtn_name,city_name,agency_name 
	end	
 DEALLOCATE c1





//--------------------------------------------------------------------------------------------------------

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO

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
                   isnull(b.supply_spl1,0)!=0 and @pspl_type='1' and 
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
                   isnull(b.supply_spl2,0)!=0 and @pspl_type='2' and
                   ((isnull(b.base_supply,0)+isnull(b.supply_sun,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_sun,0)<=isnull( @psupply_till,0) and upper( @pextra2)='SUN') or
                    (isnull(b.base_supply,0)+isnull(b.supply_mon,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_mon,0)<=isnull( @psupply_till,0) and upper( @pextra2)='MON') or
                    (isnull(b.base_supply,0)+isnull(b.supply_tue,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_tue,0)<=isnull( @psupply_till,0) and upper( @pextra2)='TUE') or
                    (isnull(b.base_supply,0)+isnull(b.supply_wed,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_wed,0)<=isnull( @psupply_till,0) and upper( @pextra2)='WED') or
                    (isnull(b.base_supply,0)+isnull(b.supply_thu,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_thu,0)<=isnull( @psupply_till,0) and upper( @pextra2)='THU') or
                    (isnull(b.base_supply,0)+isnull(b.supply_fri,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_fri,0)<=isnull( @psupply_till,0) and upper( @pextra2)='FRI') or
                    (isnull(b.base_supply,0)+isnull(b.supply_sat,0)>=isnull( @psupply_from,0) and isnull(b.base_supply,0)+isnull(b.supply_sat,0)<=isnull( @psupply_till,0) and upper( @pextra2)='SAT'))) z
             order by route_seq,supply_seq,edtn_name,city_name,agency_name


//--------------------------------------------------------------------------------------------------------


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
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
		

//----------------------------------------------------------------------------------------------------

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[cir_rep_supply_cir_branch_wise_supply]
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
   
//------------------------------------------------------------------------------------------

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
create function [dbo].[cir_get_branch]
(
@pcomp_code as varchar(50),
@branch_code as varchar(50))

RETURNs varchar(4000) 
AS

BEGIN
  declare @vbranch_name as varchar(4000)
     
         select @vbranch_name =BRANCH_NAME from branch_mst where Branch_Code=@branch_code;
  
    return isnull(@vbranch_name,'');
end

//--------------------------------------------------------------------------------------------

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
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
		 and (m.ag_class=@pextra2 or @pextra2 is null) and 
                    (d.sup_type_code=@pextra3 or @pextra3 is null) and 
                    (m.ag_type=@pextra4 or @pextra4 is null)      
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
			 and (d.sup_type_code=@pextra3 or @pextra3 is null) and 
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
			 and (d.sup_type_code=@pextra3 or @pextra3 is null) and 
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
			 and (d.sup_type_code=@pextra3 or @pextra3 is null) and 
                    (m.ag_type=@pextra4 or @pextra4 is null)
		  group by d.comp_code
		  order by comp_code;
		




//------------------------------------------------------------------------------------------------

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
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




//---------------------------------------------------------------------------------------------------

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[cir_rep_billing_cir_billing_outstanding_p]
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
            
            set @v_city_name	=	dbo.cir_get_city(@v1_comp_code,@v1_city_code)
     
			set @v_taluka_name	=	dbo.cir_get_name_cir_taluka(@v1_comp_code,@v1_taluka_code,'1','','','')
           
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
            ABS(SUM(ISNULL(A.SEC_OPBAL,0))) DEPOSIT_BALANCE,A.REMARKS DROP_POINT,A.CITY_CODE CITY_NAME
            from #cir_temp_bill_collection a
            group by a.comp_code,a.unit_code,a.agcd,a.dpcd,a.agname,a.agname_oth_lang,a.state_code,a.remarks,A.CITY_CODE 
            order by comp_code,unit_code,state_name,ag_name;

            SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.STATE_CODE STATE_NAME,
            SUM(ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)) BILL_AMT,SUM(A.COMM_AMT) COMM_AMT,SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))) NET_BILL,
            SUM(A.RETURN_COPY) RETURN_COPY,SUM(ISNULL(A.RETURN_AMT,0)+ISNULL(RET_COMM_AMT,0)) RETURN_AMT,SUM(ISNULL(A.RETURN_AMT,0))  NET_RETURN_AMT,
            SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)) TOTAL_BILL,ABS(SUM(ISNULL(A.BILL_SEC_AMT,0))) DEP_ADJ,
            SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0)) TOTAL_NET,
            SUM(A.PREV_BAL) PREV_BAL, ABS(SUM(A.REC_AMT)) REC_AMT,SUM(ISNULL(A.DN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0)) DN_AMT, SUM(A.CN_AMT) CN_AMT,SUM(ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0)) DR_CR_AMT,
            SUM(((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0)+ISNULL(A.PREV_BAL,0)+ISNULL(A.REC_AMT,0)+ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0))) NET_BAL,
            ABS(SUM(ISNULL(A.SEC_OPBAL,0))) DEPOSIT_BALANCE,A.CITY_CODE CITY_NAME
            from #cir_temp_bill_collection a
            group by a.comp_code,a.unit_code,a.state_code,A.CITY_CODE 
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
            ABS(SUM(ISNULL(A.SEC_OPBAL,0))) DEPOSIT_BALANCE,A.REMARKS DROP_POINT,A.CITY_CODE CITY_NAME
            from #cir_temp_bill_collection a
            group by a.comp_code,a.unit_code,a.agcd,a.dpcd,a.agname,a.agname_oth_lang,a.state_code,a.dist_code,a.remarks,A.CITY_CODE 
            order by comp_code,unit_code,state_name,district_name,ag_name;

            SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.DIST_CODE DISTRICT_NAME,
            A.STATE_CODE STATE_NAME,
            SUM(A.SUPPLY_COPY) SUPPLY_CODE,SUM(ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)) BILL_AMT,SUM(A.COMM_AMT) COMM_AMT,SUM(ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0)) NET_BILL,
            SUM(A.RETURN_COPY) RETURN_COPY,SUM(ISNULL(A.RETURN_AMT,0)+ISNULL(A.RET_COMM_AMT,0)) RETURN_AMT,SUM(A.RETURN_AMT) NET_RETURN_AMT,
            SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)) TOTAL_BILL,ABS(SUM(ISNULL(A.BILL_SEC_AMT,0))) DEP_ADJ,
            SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0)) TOTAL_NET,
            SUM(A.PREV_BAL) PREV_BAL, ABS(SUM(A.REC_AMT)) REC_AMT,SUM(ISNULL(A.DN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0)) DN_AMT, SUM(A.CN_AMT) CN_AMT,SUM(ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0)) DR_CR_AMT,
            SUM(((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0)+ISNULL(A.PREV_BAL,0)+ISNULL(A.REC_AMT,0)+ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0))) NET_BAL,
            ABS(SUM(ISNULL(A.SEC_OPBAL,0))) DEPOSIT_BALANCE,A.CITY_CODE CITY_NAME
            from #cir_temp_bill_collection a
            group by a.comp_code,a.unit_code,a.state_code,a.dist_code,A.CITY_CODE 
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
            ABS(SUM(ISNULL(A.SEC_OPBAL,0))) DEPOSIT_BALANCE,A.REMARKS DROP_POINT,A.CITY_CODE CITY_NAME
            from #cir_temp_bill_collection a
            group by a.comp_code,a.unit_code,a.agcd,a.dpcd,a.agname,a.agname_oth_lang,a.state_code,a.dist_code,a.city_code,a.remarks,A.CITY_CODE 
            order by comp_code,unit_code,state_name,district_name,city_name,ag_name;

            SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.CITY_CODE CITY_NAME,
            A.DIST_CODE DISTRICT_NAME,A.STATE_CODE STATE_NAME,
            SUM(ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)) BILL_AMT,A.COMM_AMT COMM_AMT,(ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0)) NET_BILL,
            SUM(ISNULL(A.RETURN_AMT,0)+ISNULL(RET_COMM_AMT,0)) RETURN_AMT,SUM(A.RETURN_AMT) NET_RETURN_AMT,
            SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)) TOTAL_BILL,ABS(SUM(ISNULL(A.BILL_SEC_AMT,0))) DEP_ADJ,
            SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0)) TOTAL_NET,
            SUM(A.PREV_BAL) PREV_BAL, ABS(SUM(A.REC_AMT)) REC_AMT,SUM(ISNULL(A.DN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0)) DN_AMT, SUM(A.CN_AMT) CN_AMT,SUM(ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0)) DR_CR_AMT,
            SUM(((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0)+ISNULL(A.PREV_BAL,0)+ISNULL(A.REC_AMT,0)+ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0))) NET_BAL,
            ABS(SUM(ISNULL(A.SEC_OPBAL,0))) DEPOSIT_BALANCE,A.CITY_CODE CITY_NAME
            from #cir_temp_bill_collection a
            group by a.comp_code,a.unit_code,a.city_code,a.dist_code,a.state_code,A.CITY_CODE 
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
            ABS(SUM(ISNULL(A.SEC_OPBAL,0))) DEPOSIT_BALANCE,A.REMARKS DROP_POINT,A.CITY_CODE CITY_NAME
            from #cir_temp_bill_collection a
            group by a.comp_code,a.unit_code,a.agcd,a.dpcd,a.agname,a.agname_oth_lang,a.taluka_code,a.dist_code,a.remarks,a.state_code,A.CITY_CODE 
            order by comp_code,unit_code,state_name,district_name,taluka_name,ag_name;

            SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.STATE_CODE STATE_NAME,A.DIST_CODE DISTRICT_NAME,
            A.TALUKA_CODE+'('+A.DIST_CODE+')' TALUKA_NAME,
            SUM(ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)) BILL_AMT,SUM(A.COMM_AMT) COMM_AMT,SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))) NET_BILL,
            SUM(ISNULL(A.RETURN_AMT,0)+ISNULL(RET_COMM_AMT,0)) RETURN_AMT,SUM(A.RETURN_AMT) NET_RETURN_AMT,
            SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)) TOTAL_BILL,ABS(SUM(ISNULL(A.BILL_SEC_AMT,0))) DEP_ADJ,
            SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0)) TOTAL_NET,
            SUM(A.PREV_BAL) PREV_BAL, ABS(SUM(A.REC_AMT)) REC_AMT,SUM(ISNULL(A.DN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0)) DN_AMT, SUM(A.CN_AMT) CN_AMT,SUM(ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0)) DR_CR_AMT,
            SUM(((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0)+ISNULL(A.PREV_BAL,0)+ISNULL(A.REC_AMT,0)+ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0))) NET_BAL,
            ABS(SUM(ISNULL(A.SEC_OPBAL,0))) DEPOSIT_BALANCE,A.CITY_CODE CITY_NAME
            from #cir_temp_bill_collection a
            group by a.comp_code,a.unit_code,a.taluka_code,a.dist_code,a.state_code,A.CITY_CODE 
            order by comp_code,unit_code,state_name,district_name,taluka_name;
        End	

		
 DEALLOCATE cur_bill
deallocate cur_type


//-----------------------------------------------------------------------------------------------------------

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
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
             AND c.dist_code  = b.dist_code) r
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
             AND c.dist_code  = b.dist_code) q
        WHERE ISNULL(second_sup, 0) - ISNULL(first_sup, 0)  <> 0
        GROUP BY  q.comp_code         ORDER BY q.comp_code
end        

//-----------------------------------------------------------------------------------------------
/************************issue no 7240** neha*****************************************/
ALTER PROCEDURE [dbo].[cir_account_mast_fa_receipt_debit_head_p]
    @pcompcode                                VARCHAR(20) ,
    @pdoctype                                 VARCHAR(20) ,
    @pdateformat                              VARCHAR(20) ,
    @pextra1                                  VARCHAR(4000) ,
    @pextra2                                  VARCHAR(4000) ,
    @pextra3                                  VARCHAR(4000) ,
    @pextra4                                  VARCHAR(4000) ,
    @pextra5                                  VARCHAR(4000) ,
    @pextra6                                  VARCHAR(4000)
AS
   
        SELECT *
        FROM  fa_acc_mast
        WHERE     comp_code  = @pcompcode
         AND    ((UPPER(acc_name)  like  UPPER(@pextra1) + '%') OR    (@pextra1  is null))
        ORDER BY acc_name 
/**************end***********************/
//--------------------------------------------------------------------------------------------------

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[cir_rep_ageing]
@pcomp_code varchar(20),
@punit_code varchar(20),
@pbran_code varchar(20),
@pzone_code varchar(30),
@pregion_code varchar(30),
@pdist_code varchar(20),
@ptaluka_code varchar(20),
@pagtype      varchar(50),
@pagclass      varchar(50),
@pag_main_code varchar(50),
@pag_sub_code varchar(50),
@paging_by varchar(50),
@pasondt datetime,
@pdebitupto_date datetime,
@pcreditupto_date datetime,
@ptill_days1 varchar(20),
@ptill_days2 varchar(20),
@ptill_days3 varchar(30),
@ptill_days4 varchar(30),
@ptill_days5 varchar(50),
@ptill_days6 varchar(50),
@pdateformat varchar(20),
@puserid varchar(20),
@pextra1 varchar(20),
@pextra2 varchar(20),
@pextra3 varchar(30),
@pextra4 varchar(30),
@pextra5 varchar(50)

AS

declare  @vtodt   as datetime
declare  @vasondt  as datetime     
declare  @v_dt    as datetime
declare  @v_ondt  as datetime
declare  @v_days numeric(10);

declare  @v_pending_rcpt_amt as numeric(14,2) 

declare  @v_amt     as    numeric(14,2);
declare  @v_amt030  as   numeric(14,2);
declare  @v_amt3160 as   numeric(14,2);
declare  @v_amt6190 as   numeric(14,2);
declare  @v_amt91120 as numeric(14,2);
declare  @v_amt121180   as numeric(14,2);
declare  @v_amt181   as numeric(14,2);

declare  @debit_amt_030  as  numeric(14,2)  --debit amt  for slab  1 days
declare  @debit_amt_3160 as  numeric(14,2)  --debit amt  for slab  2 days
declare  @debit_amt_6190 as  numeric(14,2)  --debit amt  for slab  3 days
declare  @debit_amt_91120 as numeric(14,2)  --debit amt  for slab  4 days
declare  @debit_amt_121180  as  numeric(14,2)  --debit amt  for >slab 5 days
declare  @debit_amt_181  as  numeric(14,2)  --debit amt  for >slab 6 days
declare  @bill_pending_amt as numeric(14,2)
declare  @rcpt_pending_amt  as numeric(14,2) --pending receipt amount

CREATE TABLE #cir_temp_ageing
(
  COMP_CODE     VARCHAR(8),
  UNIT_CODE     VARCHAR(8),
  BRAN_CODE     VARCHAR(8),
  AGCD          VARCHAR(8),
  DPCD          VARCHAR(8),
  AG_NAME       VARCHAR(100),
  CITY_NAME     VARCHAR(100),
  PENDING_AMT   NUMERIC(14,2),
  SLAB_1        NUMERIC(14,2),
  SLAB_2        NUMERIC(14,2),
  SLAB_3        NUMERIC(14,2),
  SLAB_4        NUMERIC(14,2),
  SLAB_5        NUMERIC(14,2),
  SLAB_6        NUMERIC(14,2),
  ON_ACAMT      NUMERIC(14,2),
  RECT_PENDING  NUMERIC(14,2),
  SESSIONID     NUMERIC(14)
)

set @vtodt=@pdebitupto_date
set @vasondt=@pcreditupto_date

set @debit_amt_030  =0  --debit amt  for slab  1 days
set @debit_amt_3160  =0  --debit amt  for slab  2 days
set  @debit_amt_6190  =0  --debit amt  for slab  3 days
set   @debit_amt_91120  =0 --debit amt  for slab  4 days
set   @debit_amt_121180   =0  --debit amt  for >slab 4 days
set   @debit_amt_181   =0  --debit amt  for >slab 4 days
set   @bill_pending_amt  =0
set   @rcpt_pending_amt  =0  --pending receipt amount


	declare cur_agency cursor for
			select m.Comp_Code comp_code,m.agcd agcd,m.dpcd dpcd,m.ag_name agency_name,
			m.City_Code city_code,c.city_name city_name,m.credit_days credit_days,m.branch_code branch_name
			from cir_agmast m,cir_city_mast c
			where m.comp_code=c.comp_code and m.comp_code=@pcomp_code 
			and m.unit=@punit_code and m.city_code=c.city_code 
			and (c.zone_code=@pzone_code or @pzone_code is null or @pzone_code ='') 
			and (m.Dist_Code=@pdist_code or @pdist_code is null or @pdist_code ='') 
			and (m.tehsil_taluka=@ptaluka_code or @ptaluka_code is null or @ptaluka_code ='') 
			and (m.agcd=@pag_main_code or @pag_main_code is null or @pag_main_code ='') 
			and (m.dpcd=@pag_sub_code or @pag_sub_code is null or @pag_sub_code ='')
			order by branch_name,agency_name; 
		

-- cursor cur_agency variables
declare @rec_agency_comp_code as varchar(30)
declare @rec_agency_agcd as varchar(20)
declare @rec_agency_dpcd as varchar(30)
declare @rec_agency_agency_name as varchar(300)
declare @rec_agency_city_code as varchar(200)
declare @rec_agency_city_name as varchar(200)
declare @rec_agency_credit_days as int
declare @rec_agency_branch_name as varchar(50)

-- cursor v_bill variables
declare @v_bill_billno as varchar(50)
declare @v_bill_billdt as varchar(30)
declare @v_bill_bill_amt as numeric(15,2)

-- cursor v_pending_rcpt variables  
declare @v_pending_rcpt_ag_main_code as varchar(30)
declare @v_pending_rcpt_ag_sub_code as varchar(50)
declare @v_pending_rcpt_amount as numeric(15,2)



--SELECT 'cursor has ' + CAST(@@CURSOR_ROWS AS VARCHAR) + ' rows'
open cur_agency
		fetch NEXT FROM cur_agency INTO @rec_agency_comp_code,@rec_agency_agcd,@rec_agency_dpcd,@rec_agency_agency_name ,@rec_agency_city_code ,@rec_agency_city_name ,@rec_agency_credit_days ,@rec_agency_branch_name
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN
			--SELECT 'cursor has ' + CAST(@@CURSOR_ROWS AS VARCHAR) + ' rows'
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
					agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
					billdt<=@vtodt and isnull(amount,0)>0
					group by comp_code,billno,billdt
					union
					select distinct recptno billno,recptdt billdt,sum(amount) bill_amt from cir_outmast
					where comp_code=@pcomp_code and unit_code=@punit_code and
					agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
					recptdt<=@vtodt and isnull(amount,0)>0 and billno is null
					group by comp_code,recptno,recptdt order by 2,1
                          
				     --having  sum(amount)<0
					open c_bill
							fetch NEXT FROM c_bill INTO @v_bill_billno,@v_bill_billdt,@v_bill_bill_amt
							WHILE (@@FETCH_STATUS = 0) 
							begin
								print('enter second')
								set @v_dt    = @v_bill_billdt
								set @v_ondt  = @vtodt
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
								set @v_amt               =0;
								set @v_amt030            =0;
								set @v_amt3160           =0;
								set @v_amt6190           =0;
								set @v_amt91120          =0;
								set @v_amt121180         =0;
								set @v_amt181            =0;	

								if @v_days between 0 and @ptill_days1 begin
									select @v_amt030=sum(amount) from cir_outmast 
									where comp_code=@pcomp_code and unit_code=@punit_code and
										  agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
										  billno=@v_bill_billno and billdt=@v_bill_billdt and 
										  recptdt<=@vasondt and amount<0

									set @v_amt030 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt030,0);
									set @debit_amt_030 =isnull(@debit_amt_030,0)+isnull(@v_amt030,0)
								end
								else if @v_days between isnull(@ptill_days1,0)+1 and @ptill_days2 begin
									select @v_amt3160=sum(amount) from cir_outmast 
									where comp_code=@pcomp_code and unit_code=@punit_code and
										  agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
										  billno=@v_bill_billno and billdt=@v_bill_billdt and 
										  recptdt<=@vasondt and amount<0
									--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
									set @v_amt3160 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt3160,0);
									set @debit_amt_3160 =isnull(@debit_amt_3160,0)+isnull(@v_amt3160,0)
								end
								else if @v_days between isnull(@ptill_days2,0)+1 and @ptill_days3 begin
									select @v_amt6190=sum(amount) from cir_outmast 
									where comp_code=@pcomp_code and unit_code=@punit_code and
										  agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
										  billno=@v_bill_billno and billdt=@v_bill_billdt and 
										  recptdt<=@vasondt and amount<0
									--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
									set @v_amt6190 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt6190,0);
									set @debit_amt_6190 =isnull(@debit_amt_6190,0)+isnull(@v_amt6190,0)
								end
								else if @v_days between isnull(@ptill_days3,0)+1 and @ptill_days4 begin
									select @v_amt91120=sum(amount) from cir_outmast 
									where comp_code=@pcomp_code and unit_code=@punit_code and
										  agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
										  billno=@v_bill_billno and billdt=@v_bill_billdt and 
										  recptdt<=@vasondt and amount<0
									--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
									set @v_amt91120 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt91120,0);
									set @debit_amt_91120 =isnull(@debit_amt_91120,0)+isnull(@v_amt91120,0)
								end  
								else if @v_days between isnull(@ptill_days4,0)+1 and @ptill_days5 begin
									select @v_amt121180=sum(amount) from cir_outmast 
									where comp_code=@pcomp_code and unit_code=@punit_code and
										  agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
										  billno=@v_bill_billno and billdt=@v_bill_billdt and 
										  recptdt<=@vasondt and amount<0
									--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
									set @v_amt121180 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt121180,0);
									set @debit_amt_121180 =isnull(@debit_amt_121180,0)+isnull(@v_amt121180,0)
								end        
								else
								begin
									select @v_amt181=sum(amount) from cir_outmast 
									where comp_code=@pcomp_code and unit_code=@punit_code and
										  agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
										  billno=@v_bill_billno and billdt=@v_bill_billdt and 
										  recptdt<=@vasondt and amount<0
									--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
									set @v_amt181 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt181,0);
									set @debit_amt_181 =isnull(@debit_amt_181,0)+isnull(@v_amt181,0)
								end
								

							fetch NEXT FROM c_bill INTO @v_bill_billno,@v_bill_billdt,@v_bill_bill_amt
							end
					close c_bill		
				deallocate c_bill
		
		select @v_pending_rcpt_amt=sum(amount) from cir_outmast 
        where comp_code=@pcomp_code and unit_code=@punit_code and
          agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
          (billno is null or billdt>@vasondt) and 
          recptdt<=@vasondt and 
          doctyp+recptno+cast(recptdt as varchar) not in 
          (select distinct doctyp+recptno+cast(recptdt as varchar) from ad_outstand
           where comp_code=@pcomp_code and unit_code=@punit_code and
                 agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
                 recptdt<=@vtodt and isnull(amount,0)<0 and billno IS NULL)
	
		set @v_amt=isnull(@debit_amt_030,0)+isnull(@debit_amt_3160,0)+isnull(@debit_amt_6190,0)+isnull(@debit_amt_91120,0)+isnull(@debit_amt_121180,0)+isnull(@debit_amt_181,0)

		if @v_amt=0 begin
			set @debit_amt_030    = 0
			set @debit_amt_3160   = 0
			set @debit_amt_6190   = 0
			set @debit_amt_91120  = 0
			set @debit_amt_121180 = 0
			set @debit_amt_181    = 0
			set @rcpt_pending_amt = 0
		end
		else
		begin
			set @rcpt_pending_amt=isnull(@v_pending_rcpt_amount,0)
			set @bill_pending_amt=isnull(@v_amt,0)
		end
		print('zzz')
		insert into #cir_temp_ageing (comp_code,unit_code,agcd,dpcd,ag_name,
                city_name,pending_amt,slab_1,slab_2,slab_3,slab_4,slab_5,
                slab_6,rect_pending,on_acamt,sessionid)
        values (@rec_agency_comp_code,@punit_code,@rec_agency_agcd, @rec_agency_dpcd, @rec_agency_agency_name,
               @rec_agency_city_name,isnull(@bill_pending_amt,0),isnull(@debit_amt_030,0),isnull(@debit_amt_3160,0), isnull(@debit_amt_6190,0), isnull(@debit_amt_121180,0), isnull(@debit_amt_181,0),
               0,isnull(@rcpt_pending_amt,0),0,@@spid);
		print('xxx')
		fetch NEXT FROM cur_agency INTO @rec_agency_comp_code,@rec_agency_agcd,@rec_agency_dpcd,@rec_agency_agency_name ,@rec_agency_city_code ,@rec_agency_city_name ,@rec_agency_credit_days ,@rec_agency_branch_name
		    set @debit_amt_030    = 0
			set @debit_amt_3160   = 0
			set @debit_amt_6190   = 0
			set @debit_amt_91120  = 0
			set @debit_amt_121180 = 0
			set @debit_amt_181    = 0
			set @rcpt_pending_amt = 0
			set @bill_pending_amt = 0
		end
		
close cur_agency;
--SELECT 'cursor has ' + CAST(@@CURSOR_ROWS AS VARCHAR) + ' rows'
deallocate cur_agency

select comp_code,unit_code,agcd,dpcd,ag_name,city_name,pending_amt,slab_1,slab_2,slab_3,slab_4,slab_5,
slab_6,rect_pending from #cir_temp_ageing 
/*where (PENDING_AMT>0 or SLAB_1>0 or SLAB_2>0 or SLAB_3>0 or SLAB_4>0 or SLAB_5>0 or ABS(RECT_PENDING)>0  )  
 and sessionid=@@SPID  */
 order by ag_name;
drop table #cir_temp_ageing


//----------------------------------------------------------------------------------------
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[cir_branchlisting_commcat]
@pcomp_code       as varchar(200),
@punit            as varchar(200),
@pbranch_code     as varchar(200),
@pagcd            as varchar(200),
@pdpcd            as varchar(200),
@pag_type         as varchar(200),
@pag_class        as varchar(200),
@pcomm_code       as varchar(200),
@pextra1          as varchar(200),
@pextra2          as varchar(200)

AS 
	
select x.branch_code,x.branch_name,x.comm_catg_desc
,
max(x.comm_catg_desc),
sum(x.upline)main ,
sum (isnull(x.sub,0)) sub,
sum(isnull(x.upline,0))+sum(isnull(x.sub,0))
 total from(
 select  b.branch_code, 
dbo.cir_get_branch(a.comp_code,b.branch_code) branch_name ,
c.comm_catg_desc,count(*) "UPLINE",null "SUB"  
from cir_supply a,cir_agmast b,cir_comm_catg_mast c
		where a.comp_code=@pcomp_code 
		and a.comp_code=b.comp_code 
		and a.comp_code=c.comp_code 
		and (a.unit=@punit or @punit is null or @punit ='') 
		and a.unit=b.unit 
		and (b.branch_code=@pbranch_code or @pbranch_code is null or @pbranch_code ='') 
		and a.agcd=b.agcd and a.dpcd=b.dpcd and a.dpcd='0001'
		and (a.agcd=@pagcd or @pagcd is null or @pagcd ='') 
		and (a.dpcd=@pdpcd or @pdpcd is null or @pdpcd ='') 
		and (b.ag_type=@pag_type or @pag_type is null or @pag_type ='')
		and (b.ag_class=@pag_class or @pag_class is null or @pag_class ='') 
		and (a.comm_code=@pcomm_code or @pcomm_code is null or @pcomm_code ='') 
		and a.comm_code=c.comm_catg_code
		group by a.comp_code,b.branch_code,c.comm_catg_desc
union
select  b.branch_code, dbo.cir_get_branch(a.comp_code,b.branch_code) branch_name ,c.comm_catg_desc,count(*) "UPLINE",null "SUB"  from cir_supply a,cir_agmast b,cir_comm_catg_mast c
		where a.comp_code=@pcomp_code 
		and a.comp_code=b.comp_code 
		and a.comp_code=c.comp_code 
		and (a.unit=@punit or @punit is null or @punit ='') 
		and a.unit=b.unit 
		and (b.branch_code=@pbranch_code or @pbranch_code is null or @pbranch_code ='') 
		and a.agcd=b.agcd and a.dpcd=b.dpcd and a.dpcd!='0001'
		and (a.agcd=@pagcd or @pagcd is null or @pagcd ='') 
		and (a.dpcd=@pdpcd or @pdpcd is null or @pdpcd ='') 
		and (b.ag_type=@pag_type or @pag_type is null or @pag_type ='')
		and (b.ag_class=@pag_class or @pag_class is null or @pag_class ='') 
		and (a.comm_code=@pcomm_code or @pcomm_code is null or @pcomm_code ='') 
		and a.comm_code=c.comm_catg_code
		group by a.comp_code,b.branch_code,c.comm_catg_desc) x 
		group by x.branch_code,x.branch_name,x.comm_catg_desc 
		order by x.branch_code,x.branch_name,x.comm_catg_desc


//----------------------------------------------------------------------------------------------------

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[cir_rep_abc_summ_bill_return]
	@pcompcode          as varchar(4000),
    @punitcode          as varchar(4000),
    @ppublcode          as varchar(4000),
    @pmedtncode         as varchar(4000),
    @pedtncode          as varchar(4000),
    @pagtype            as varchar(4000),
    @pagclass           as varchar(4000),     
    @pfromdate          as datetime,
    @ptilldate          as datetime,
    @pinsertion_fee     as varchar(4000),--Include Insertion fee yes Y and No N
    @pbreakon           as varchar(4000),--It is used for report break on 1 for State,2 for District , 3 for Taluka, 4 for zone,5 Region
    @preptype           as varchar(4000),--B for Blling and R for Return unsold
    @pdateformat        as varchar(4000),
    @pextra1            as varchar(4000),
    @pextra2            as varchar(4000),
    @pextra3            as varchar(4000),
    @pextra4            as varchar(4000),
    @pextra5            as varchar(4000)
AS 

BEGIN
		
	declare @v_frdt    datetime
	declare @v_todt    datetime

	declare @v_comp_code     varchar(20)
	declare @v_unit_code     varchar(20)
	declare @v_publ          varchar(20)
	declare @v_medtn         varchar(20)
	declare @v_edtn          varchar(20)
	declare @v_edtn_name     varchar(20)
	declare @v_state_code    varchar(20)
	declare @v_dist_code     varchar(20)
	declare @v_tehsil_taluka varchar(20)
	declare @v_city_code     varchar(20)
	declare @v_city_name     varchar(20)
	declare @v_zone_code     varchar(20)
	declare @v_region_code   varchar(20)
	declare @v_bill_copy     numeric(10)
	declare @v_gross_amt     numeric(15,2)
	declare @v_comm_amt      numeric(15,2)
	declare @v_sur_amt       numeric(15,2)
	declare @v_bill_amt      numeric(15,2)	

	set @v_frdt =@pfromdate
	set @v_frdt =@ptilldate
declare @v_cnt      numeric(4)
set @v_cnt=0

CREATE TABLE #cir_ledger_report
(
  COMP_CODE      VARCHAR(10),
  UNIT_CODE      VARCHAR(10),
  BRANCH_CODE    VARCHAR(10),
  DOCTYPE        VARCHAR(10),
  AGCD           VARCHAR(50),
  DPCD           VARCHAR(50),
  RECPTNO        VARCHAR(50),
  RECPTDT        DATEtime,
  AMOUNT         NUMeric(14,2),
  CHQNO          VARCHAR(50),
  CHQDT          DATEtime,
  CHQ_BANK       VARCHAR(100),
  EXEC_CODE      VARCHAR(20),
  REMARKS        VARCHAR(500),
  REASON         VARCHAR(30),
  BILLNO         VARCHAR(50),
  BILLDT         DATEtime,
  BILLAMT        NUMeric(14,2),
  ADJAMT         NUMeric(14,2),
  LEFTAMT        NUMeric(14,2),
  DEBIT_HEAD     VARCHAR(200),
  CREDIT_HEAD    VARCHAR(200),
  REC_SEQNO      NUMeric(10),
  RECOVARY_DAYS  NUMeric(5),
  AGNAME         VARCHAR(500),
  OPBAL_SEC      NUMeric(14,2),
  SESS_ID        NUMeric(10)                     DEFAULT @@spid,
  NARR_LINE      NUMeric(3),
  CITY_CODE      VARCHAR(10)
)


declare  c1 cursor for
		select b.comp_code,b.unit_code,b.publ,e.main_edtn,b.edtn,e.edtn_name,dbo.cir_get_state(b.comp_code,m.country_code,m.state_code) state_name, 
        m.dist_code,m.tehsil_taluka,m.city_code,c.city_name,c.zone_code,c.region_code, 
        sum(b.bill_copy), sum(b.gross_amount) gross_amt, sum(b.comm_amt) comm_amt, sum(b.sur_amt) sur_amt,sum(b.bill_amount) bill_amt
        from cir_bill_det b,cir_agmast m,cir_edtn_mast e ,cir_city_mast c
        where b.comp_code=@pcompcode and b.comp_code=m.comp_code and b.comp_code=e.comp_code and b.comp_code=c.comp_code and 
        b.unit_code=@punitcode and b.unit_code=m.unit 
        --and        b.billdt between @v_frdt and @v_todt 
        and b.agcd=m.agcd and b.dpcd=m.dpcd and
        b.publ=e.publ and b.publ=isnull(@ppublcode,b.publ) and b.edtn=e.edtn and b.edtn=isnull(@pedtncode,b.edtn) and e.main_edtn=isnull(@pmedtncode,e.main_edtn) and (m.ag_type=@pagtype or @pagtype is null)
        and (m.ag_class=@pagclass or @pagclass is null) and m.city_code=c.city_code and @preptype='B'
        group by b.comp_code,b.unit_code,b.publ,e.main_edtn,b.edtn,m.state_code,m.country_code,m.dist_code,m.tehsil_taluka,
        m.city_code,c.city_name,c.zone_code,c.region_code,e.edtn_name
        union
        select b.comp_code,b.unit_code,b.publ,e.main_edtn,b.edtn,e.edtn_name,dbo.cir_get_state(b.comp_code,m.country_code,m.state_code) state_name, 
        m.dist_code,m.tehsil_taluka,m.city_code,c.city_name,c.zone_code,c.region_code, 
        sum(isnull(b.apr_unsold,0)+isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_damage,0)), 
        sum(b.copy_rate*(isnull(b.apr_unsold,0)+isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_damage,0))) gross_amt, 
        sum(b.comm_amt) comm_amt, 0 sur_amt,sum(b.copy_amt) bill_amt
        from cir_unsold_dtl b,cir_agmast m,cir_edtn_mast e ,cir_city_mast c
        where b.comp_code=@pcompcode 
        and b.comp_code=m.comp_code and b.comp_code=e.comp_code and b.comp_code=c.comp_code 
        and 
        b.unit_code=@punitcode and b.unit_code=m.unit 
        --and         b.app_dt between @v_frdt and @v_todt 
        and b.agcd=m.agcd and b.dpcd=m.dpcd 
        and
        b.publ=e.publ and b.publ=isnull(@ppublcode,b.publ) 
        and b.edtn=e.edtn and b.edtn=isnull(@pedtncode,b.edtn) 
        and e.main_edtn=isnull(@pmedtncode,e.main_edtn) 
        and (m.ag_type=@pagtype or @pagtype is null)
         and (m.ag_class=@pagclass or @pagclass is null) 
       and m.city_code=c.city_code and @preptype='R'
        group by b.comp_code,b.unit_code,b.publ,e.main_edtn,b.edtn,m.state_code,m.country_code,m.dist_code,m.tehsil_taluka,
        m.city_code,c.city_name,c.zone_code,c.region_code,e.edtn_name




	DELETE FROM   #cir_ledger_report WHERE  sess_id  = @@spid

		open c1
			fetch NEXT FROM c1 INTO @v_comp_code,@v_unit_code,@v_publ,@v_medtn,@v_edtn,@v_edtn_name,@v_state_code,@v_dist_code,@v_tehsil_taluka,@v_city_code,@v_city_name,@v_zone_code,@v_region_code, @v_bill_copy, @v_gross_amt, @v_comm_amt, @v_sur_amt,@v_bill_amt
			WHILE (@@FETCH_STATUS = 0) 
			BEGIN
				if(@@FETCH_STATUS = -1)
				break
					insert into #cir_ledger_report
					(comp_code, unit_code, branch_code, agcd, dpcd,billno, recptno, debit_head,chqno,chq_bank, exec_code, remarks,  
					rec_seqno,amount, billamt, adjamt, leftamt,opbal_sec, city_code,sess_id)
					values
					(@v_comp_code,@v_unit_code,@v_publ,@v_medtn,@v_edtn,@v_edtn_name,@v_state_code,@v_dist_code,@v_tehsil_taluka,@v_zone_code,@v_region_code,@v_city_name,
					@v_bill_copy, @v_gross_amt,@v_bill_amt,@v_comm_amt,@v_sur_amt,0,@v_city_code,@@spid);

			fetch NEXT FROM c1 INTO @v_comp_code,@v_unit_code,@v_publ,@v_medtn,@v_edtn,@v_edtn_name,@v_state_code,@v_dist_code,@v_tehsil_taluka,@v_city_code,@v_city_name,@v_zone_code,@v_region_code, @v_bill_copy, @v_gross_amt, @v_comm_amt, @v_sur_amt,@v_bill_amt
			end 
		close c1		
		deallocate c1


		
		If @pbreakon='1' --for State  
		begin      
			select a.comp_code as COMP_CODE,(select Comp_Name from comp_mst where Comp_Code=a.comp_code) as COMP_NAME,
			a.unit_code as UNIT_CODE,(select Pub_Cent_name from pub_cent_mast where Pub_cent_Code=a.unit_code) as UNIT_NAME, 
			a.branch_code as PUBL_CODE,dbo.cir_get_publ_name(a.comp_code,a.branch_code) as PUBL_NAME, a.agcd as MEDTN,dbo.cir_get_edtn_name(a.comp_code,a.agcd) as MEDTN_NAME, 
			a.dpcd as EDTN, a.billno as EDTN_NAME,a.recptno as STATE_NAME, a.debit_head as DIST_CODE,dbo.cir_get_name_cir_district(a.comp_code,a.debit_head,'1',@pdateformat,null,null) as DIST_NAME,
			a.city_code as CITY_CODE, a.remarks as CITY_NAME,a.chqno as TALUKA_CODE,dbo.cir_get_taluka(a.comp_code,a.chqno) as TALUKA_NAME, 
			a.chq_bank as ZONE_CODE,dbo.cir_get_zone_name(a.comp_code,a.chq_bank) as ZONE_NAME, 
			a.exec_code as REGION_CODE,dbo.cir_get_zone_name(a.comp_code,a.exec_code) as REGION_NAME,   
			a.rec_seqno as BILL_COPY,a.amount as GROSS_AMT, a.adjamt as COMM_AMT, a.leftamt as SUR_AMT, a.billamt as BILL_AMT,
			a.opbal_sec as INSERTION_FEE
			from #cir_ledger_report a 
			where sess_id=@@spid order by comp_name,unit_name,state_name,publ_name,medtn_name,edtn_name
	        
			select a.comp_code as COMP_CODE,(select Comp_Name from comp_mst where Comp_Code=a.comp_code) as COMP_NAME,
			a.unit_code as UNIT_CODE,(select Pub_Cent_name from pub_cent_mast where Pub_cent_Code=a.unit_code) as UNIT_NAME, 
			a.recptno as STATE_NAME, sum(a.rec_seqno) as BILL_COPY,sum(a.amount) as GROSS_AMT, sum(a.adjamt) as COMM_AMT, 
			sum(a.leftamt) as SUR_AMT, sum(a.billamt) as BILL_AMT,sum(a.opbal_sec) as INSERTION_FEE 
			from #cir_ledger_report a 
			where sess_id=@@spid
			group by a.comp_code ,a.unit_code , a.recptno
			order by comp_name,unit_name,state_name;
        end
		Else if @pbreakon='2' --for District
		begin 
			select a.comp_code as COMP_CODE,(select Comp_Name from comp_mst where Comp_Code=a.comp_code) as COMP_NAME,
			a.unit_code as UNIT_CODE,(select Pub_Cent_name from pub_cent_mast where Pub_cent_Code=a.unit_code) as UNIT_NAME, 
			a.branch_code as PUBL_CODE,dbo.cir_get_publ_name(a.comp_code,a.branch_code) as PUBL_NAME, a.agcd as MEDTN,dbo.cir_get_edtn_name(a.comp_code,a.agcd) as MEDTN_NAME, 
			a.dpcd as EDTN, a.billno as EDTN_NAME,a.recptno as STATE_NAME, a.debit_head as DIST_CODE,dbo.cir_get_name_cir_district(a.comp_code,a.debit_head,'1',@pdateformat,null,null) as DIST_NAME,
			a.city_code as CITY_CODE, a.remarks as CITY_NAME,a.chqno as TALUKA_CODE,dbo.cir_get_taluka(a.comp_code,a.chqno) as TALUKA_NAME, 
			a.chq_bank as ZONE_CODE,dbo.cir_get_zone_name(a.comp_code,a.chq_bank) as ZONE_NAME, 
			a.exec_code as REGION_CODE,dbo.cir_get_zone_name(a.comp_code,a.exec_code) as REGION_NAME,   
			a.rec_seqno as BILL_COPY,a.amount as GROSS_AMT, a.adjamt as COMM_AMT, a.leftamt as SUR_AMT, a.billamt as BILL_AMT,
			a.opbal_sec as INSERTION_FEE 
			from #cir_ledger_report a 
			where sess_id=@@spid order by comp_name,unit_name,state_name,dist_name,publ_name,medtn_name,edtn_name;
        
			select a.comp_code as COMP_CODE,(select Comp_Name from comp_mst where Comp_Code=a.comp_code) as COMP_NAME,
			a.unit_code as UNIT_CODE,(select Pub_Cent_name from pub_cent_mast where Pub_cent_Code=a.unit_code) as UNIT_NAME, 
			a.recptno as STATE_NAME,a.debit_head as DIST_CODE,dbo.cir_get_name_cir_district(a.comp_code,a.debit_head,'1',@pdateformat,null,null) as DIST_NAME, 
			sum(a.rec_seqno) as BILL_COPY,sum(a.amount) as GROSS_AMT, sum(a.adjamt) as COMM_AMT, 
			sum(a.leftamt) as SUR_AMT, sum(a.billamt) as BILL_AMT,sum(a.opbal_sec) as INSERTION_FEE 
			from #cir_ledger_report a 
			where sess_id=@@spid
			group by a.comp_code ,a.unit_code , a.recptno,a.debit_head
			order by comp_name,unit_name,state_name,dist_name;
        end
		Else if @pbreakon='3'--for Taluka
		begin
			select a.comp_code as COMP_CODE,(select Comp_Name from comp_mst where Comp_Code=a.comp_code) as COMP_NAME,
			a.unit_code as UNIT_CODE,(select Pub_Cent_name from pub_cent_mast where Pub_cent_Code=a.unit_code) as UNIT_NAME, 
			a.branch_code as PUBL_CODE,dbo.cir_get_publ_name(a.comp_code,a.branch_code) as PUBL_NAME, a.agcd as MEDTN,dbo.cir_get_edtn_name(a.comp_code,a.agcd) as MEDTN_NAME, 
			a.dpcd as EDTN, a.billno as EDTN_NAME,a.recptno as STATE_NAME, a.debit_head as DIST_CODE,dbo.cir_get_name_cir_district(a.comp_code,a.debit_head,'1',@pdateformat,null,null) as DIST_NAME,
			a.city_code as CITY_CODE, a.remarks as CITY_NAME,a.chqno as TALUKA_CODE,dbo.cir_get_taluka(a.comp_code,a.chqno) as TALUKA_NAME, 
			a.chq_bank as ZONE_CODE,dbo.cir_get_zone_name(a.comp_code,a.chq_bank) as ZONE_NAME, 
			a.exec_code as REGION_CODE,dbo.cir_get_zone_name(a.comp_code,a.exec_code) as REGION_NAME,   
			a.rec_seqno as BILL_COPY,a.amount as GROSS_AMT, a.adjamt as COMM_AMT, a.leftamt as SUR_AMT, a.billamt as BILL_AMT,
			a.opbal_sec as INSERTION_FEE 
			from #cir_ledger_report a 
			where sess_id=@@spid order by comp_name,unit_name,state_name,dist_name,taluka_name,publ_name,medtn_name,edtn_name;
        
			select a.comp_code as COMP_CODE,(select Comp_Name from comp_mst where Comp_Code=a.comp_code) as COMP_NAME,
			a.unit_code as UNIT_CODE,(select Pub_Cent_name from pub_cent_mast where Pub_cent_Code=a.unit_code) as UNIT_NAME, 
			a.recptno as STATE_NAME,a.debit_head as DIST_CODE,dbo.cir_get_name_cir_district(a.comp_code,a.debit_head,'1',@pdateformat,null,null) as DIST_NAME,
			a.chqno as TALUKA_CODE,dbo.cir_get_taluka(a.comp_code,a.chqno) as TALUKA_NAME, 
			sum(a.rec_seqno) as BILL_COPY,sum(a.amount) as GROSS_AMT, sum(a.adjamt) as COMM_AMT, 
			sum(a.leftamt) as SUR_AMT, sum(a.billamt) as BILL_AMT,sum(a.opbal_sec) as INSERTION_FEE 
			from #cir_ledger_report a 
			where sess_id=@@spid
			group by a.comp_code ,a.unit_code , a.recptno,a.debit_head,a.chqno
			order by comp_name,unit_name,state_name,dist_name,taluka_name;
        end
		Else if @pbreakon='4'--for Zone
        begin
			select a.comp_code as COMP_CODE,(select Comp_Name from comp_mst where Comp_Code=a.comp_code) as COMP_NAME,
			a.unit_code as UNIT_CODE,(select Pub_Cent_name from pub_cent_mast where Pub_cent_Code=a.unit_code) as UNIT_NAME, 
			a.branch_code as PUBL_CODE,dbo.cir_get_publ_name(a.comp_code,a.branch_code) as PUBL_NAME, a.agcd as MEDTN,dbo.cir_get_edtn_name(a.comp_code,a.agcd) as MEDTN_NAME, 
			a.dpcd as EDTN, a.billno as EDTN_NAME,a.recptno as STATE_NAME, a.debit_head as DIST_CODE,dbo.cir_get_name_cir_district(a.comp_code,a.debit_head,'1',@pdateformat,null,null) as DIST_NAME,
			a.city_code as CITY_CODE, a.remarks as CITY_NAME,a.chqno as TALUKA_CODE,dbo.cir_get_taluka(a.comp_code,a.chqno) as TALUKA_NAME, 
			a.chq_bank as ZONE_CODE,dbo.cir_get_zone_name(a.comp_code,a.chq_bank) as ZONE_NAME, 
			a.exec_code as REGION_CODE,dbo.cir_get_zone_name(a.comp_code,a.exec_code) as REGION_NAME,   
			a.rec_seqno as BILL_COPY,a.amount as GROSS_AMT, a.adjamt as COMM_AMT, a.leftamt as SUR_AMT, a.billamt as BILL_AMT,
			a.opbal_sec as INSERTION_FEE 
			from #cir_ledger_report a 
			where sess_id=@@spid order by comp_name,unit_name,zone_name,publ_name,medtn_name,edtn_name;
        
			select a.comp_code as COMP_CODE,(select Comp_Name from comp_mst where Comp_Code=a.comp_code) as COMP_NAME,
			a.unit_code as UNIT_CODE,(select Pub_Cent_name from pub_cent_mast where Pub_cent_Code=a.unit_code) as UNIT_NAME, 
			a.chq_bank as ZONE_CODE,dbo.cir_get_zone_name(a.comp_code,a.chq_bank) as ZONE_NAME,
			sum(a.rec_seqno) as BILL_COPY,sum(a.amount) as GROSS_AMT, sum(a.adjamt) as COMM_AMT, 
			sum(a.leftamt) as SUR_AMT, sum(a.billamt) as BILL_AMT,sum(a.opbal_sec) as INSERTION_FEE 
			from #cir_ledger_report a 
			where sess_id=@@spid
			group by a.comp_code ,a.unit_code , a.chq_bank
			order by comp_name,unit_name,zone_name;
		end
		Else--for Region Wise                
		begin
			select a.comp_code as COMP_CODE,(select Comp_Name from comp_mst where Comp_Code=a.comp_code) as COMP_NAME,
			a.unit_code as UNIT_CODE,(select Pub_Cent_name from pub_cent_mast where Pub_cent_Code=a.unit_code) as UNIT_NAME, 
			a.branch_code as PUBL_CODE,dbo.cir_get_publ_name(a.comp_code,a.branch_code) as PUBL_NAME, a.agcd as MEDTN,dbo.cir_get_edtn_name(a.comp_code,a.agcd) as MEDTN_NAME, 
			a.dpcd as EDTN, a.billno as EDTN_NAME,a.recptno as STATE_NAME, a.debit_head as DIST_CODE,dbo.cir_get_name_cir_district(a.comp_code,a.debit_head,'1',@pdateformat,null,null) as DIST_NAME,
			a.city_code as CITY_CODE, a.remarks as CITY_NAME,a.chqno as TALUKA_CODE,dbo.cir_get_taluka(a.comp_code,a.chqno) as TALUKA_NAME, 
			a.chq_bank as ZONE_CODE,dbo.cir_get_zone_name(a.comp_code,a.chq_bank) as ZONE_NAME, 
			a.exec_code as REGION_CODE,dbo.cir_get_zone_name(a.comp_code,a.exec_code) as REGION_NAME,   
			a.rec_seqno as BILL_COPY,a.amount as GROSS_AMT, a.adjamt as COMM_AMT, a.leftamt as SUR_AMT, a.billamt as BILL_AMT,
			a.opbal_sec as INSERTION_FEE 
			from #cir_ledger_report a 
			where sess_id=@@spid order by comp_name,unit_name,zone_name,region_name,publ_name,medtn_name,edtn_name;
        
			select a.comp_code as COMP_CODE,(select Comp_Name from comp_mst where Comp_Code=a.comp_code) as COMP_NAME,
			a.unit_code as UNIT_CODE,(select Pub_Cent_name from pub_cent_mast where Pub_cent_Code=a.unit_code) as UNIT_NAME, 
			a.chq_bank as ZONE_CODE,dbo.cir_get_zone_name(a.comp_code,a.chq_bank) as ZONE_NAME,
			a.exec_code as REGION_CODE,dbo.cir_get_zone_name(a.comp_code,a.exec_code) as REGION_NAME,
			sum(a.rec_seqno) as BILL_COPY,sum(a.amount) as GROSS_AMT, sum(a.adjamt) as COMM_AMT, 
			sum(a.leftamt) as SUR_AMT, sum(a.billamt) as BILL_AMT,sum(a.opbal_sec) as INSERTION_FEE 
			from #cir_ledger_report a 
			where sess_id=@@spid
			group by a.comp_code ,a.unit_code , a.chq_bank,a.exec_code
			order by comp_name,unit_name,zone_name,region_name;
		End

		drop table #cir_ledger_report

end

//----------------------------------------------------------------------------------------------------



alter function [dbo].[cir_get_branch]
(
@pcomp_code as varchar(50),
@branch_code as varchar(50))

RETURNs varchar(4000) 
AS

BEGIN
  declare @vbranch_name as varchar(4000)
     
         select @vbranch_name =BRANCH_NAME from branch_mst where Branch_Code=@branch_code;
  
    return isnull(@vbranch_name,'');
end

//-------------------------------add by ritu------------------------------------//


/////////////////////////  /////////add by deepika 21/04/2012////////////////////////////////////////////////////////////////////////////


                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE [dbo].[cir_rep_collection_cir_rep_collection_det_p]
	@pcompcode                                VARCHAR(20) ,
	@punitcode                                VARCHAR(20) ,
	@pbrachcode                               VARCHAR(20) ,
	@pdoctype                                 VARCHAR(20) ,
	@ppaymode                                 VARCHAR(20) ,
	@pactype                                  VARCHAR(20) ,
	@pfromdate                                datetime ,
	@ptodate                                  datetime ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(200) ,
	@pextra2                                  VARCHAR(200) 
AS 
		DECLARE @v_frdt		DATETIME 
		DECLARE @v_todt     DATETIME 
		DECLARE	@A			INT
		DECLARE	@v_a		as varchar(1000)
	Begin
		SET @v_frdt  = @pfromdate--DBO.CONVERT_USER_DATE('/', @pfromdate,@pdateformat)
		--SET @v_frdt  = DBO.CONVERT_USER_DATE('/', @pfromdate,@pdateformat)
		SET @v_todt  =@ptodate--- DBO.CONVERT_USER_DATE('/', @ptodate,@pdateformat)
		/*if @pdoctype is not null Begin
            SET @a=dbo.FN_SPLITFIELD(@pdoctype ,',')
        end*/
		create  table #Results(SegmentNum INT, EditionName  VARCHAR(255))
		Begin
			if (@pdoctype is not null) begin
			insert into #Results select * from dbo.Fn_Splitfield(@pdoctype,',')
			End
		End
print 'amit'
        select A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.RECPTDT RECPTDT,A.RECPTNO RECPTNO,A.DOCTYPE DOCTYP,A.AGCD AGCD,
        A.DPCD DPCD,B.AG_NAME AS AGENCY_NAME,B.AG_NAME_OTH_LANG AGNAME_OTH_LANG,B.CITY_CODE,dbo.CIR_GET_CITY(B.COMP_CODE,B.CITY_CODE) CITY_NAME,
        B.TEHSIL_TALUKA TALUKA_CODE,dbo.CIR_GET_TALUKA(B.COMP_CODE,B.TEHSIL_TALUKA) TALUKA_NAME,A.VOUCHERNO VOUCHERNO,A.CHNO CHNO,A.CHDT CHDT,
       SUBSTRING(ISNULL((SELECT BANKNAME AS "bankname" FROM CIR_BANK_MAST WHERE COMP_CODE=A.COMP_CODE AND BANKCODE=A.CHBANK),A.CHBANK),1,15) AS BANK,ABS(A.AMOUNT) AMOUNT,
         dbo.INITCAP(A.REMARK) REMARK,A.ACHD ACHD,
       CASE WHEN A.DOCTYPE='RCR' THEN 
        (SELECT "Payment_Mode_Name" FROM PAYMENT_MODE_MAST WHERE "Pay_Mode_Code"=A.REASON)
        ELSE 
        (SELECT REASON_NAME FROM CIR_REASON_MST WHERE COMP_CODE=A.COMP_CODE AND REASON_CODE=A.REASON) END AS REASON,
        A.BRANCH_CODE BRANCH_CODE,(SELECT DISTINCT "Branch_Name" FROM BRANCH_MST WHERE "Branch_Code"=A.BRANCH_CODE) BRANCH_NAME,
        SUBSTRING(dbo.FA_GET_ACCOUNT_NAME(A.COMP_CODE,A.RCDP),1,15) DEBIT_HEAD,(SELECT DISTINCT CASE WHEN DSIGN=-1 THEN 'C' ELSE 'D' END DSIGN FROM CIR_DOCMST WHERE DOC_TYPE=A.DOCTYPE) DSIGN,
        A.USERID,(SELECT isnull(FIRSTNAME,"username")+' '+LASTNAME FROM LOGIN WHERE "userid"=A.USERID) CREATED_BY, A.CREATION_DATE CREATION_DATE, A.PROV_REC_NO PROV_REC_NO, A.PROV_REC_DT PROV_REC_DATE,
        A.REMARK_OTH REMARK_OTH
        from cir_rcphdr a,cir_agmast b
        where a.comp_code=b.comp_code and a.comp_code=@pcompcode  and a.unit_code=b.unit and a.unit_code =@punitcode and
              a.agcd=b.agcd and a.dpcd=b.dpcd and (a.agcd=@pextra1 or @pextra1 is null or @pextra1='') and (a.dpcd=@pextra2 or @pextra2 is null or @pextra2='') and
              a.recptdt between @v_frdt and @v_todt and --(a.doctype  = @pdoctype or @pdoctype is null or @pdoctype='' )
			 -- (a.doctype=@pdoctype or @pdoctype is null OR @pdoctype='') 
			  (a.doctype in (SELECT EditionName FROM #Results) or @pdoctype is null OR @pdoctype='')
			   and
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
			AND	(a.doctype  = @pdoctype or @pdoctype is null or @pdoctype='' )
			--AND (a.doctype  in (SELECT EditionName FROM #Results) or @pdoctype is null OR @pdoctype='')
			AND	(a.reason  = @ppaymode OR	@ppaymode  is null OR	@ppaymode = '')
			AND	(ISNULL(a.achd, 'NM')  = @pactype OR	@pactype  is null OR	@pactype = '')
			AND	(a.branch_code  = @pbrachcode OR	@pbrachcode  is null  OR	@pbrachcode = '')
		 ORDER BY a.comp_code, a.recptdt,a.doctype, a.recptno */
		
	print 'amit1'	
		SELECT e.comp_code, e.doctype, e.reason, SUM(CONVERT(FLOAT, e.db_amount)) db_amount, 
        SUM(CONVERT(FLOAT, e.cr_amount)) cr_amount  FROM 
               (SELECT d.comp_code, d.doctype, d.reason,
		        CASE d.debit WHEN 'D' THEN SUM(CONVERT(FLOAT, d.amount)) END db_amount,				 
		        CASE d.credit WHEN 'C' THEN SUM(CONVERT(FLOAT, d.amount)) END cr_amount
		        FROM (SELECT a.comp_code comp_code, a.doctype doctype, --a.reason reason,
		        CASE WHEN A.DOCTYPE='RCR' THEN (SELECT "Payment_Mode_Name" FROM PAYMENT_MODE_MAST WHERE "Pay_Mode_Code"=A.REASON)
        ELSE (SELECT REASON_NAME FROM CIR_REASON_MST WHERE COMP_CODE=A.COMP_CODE AND REASON_CODE=A.REASON) END AS REASON,
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
				--AND	 (a.doctype=@pdoctype or @pdoctype is null OR @pdoctype='')
				AND (a.doctype  in (SELECT EditionName FROM #Results) or @pdoctype is null OR @pdoctype='')
				AND	(a.reason  = @ppaymode OR	@ppaymode  is null  OR	@ppaymode  = '')
				AND	(ISNULL(a.achd, 'NM')  = @pactype  OR	@pactype  is null OR	@pactype  = '')
				AND	(a.branch_code  = @pbrachcode OR	@pbrachcode  is null OR	 @pbrachcode  = '')) d
                 GROUP BY d.comp_code, d.doctype, d.reason, d.debit, d.credit ) e
		GROUP BY e.comp_code, e.doctype,  e.reason 
		ORDER BY e.comp_code, e.doctype, e.reason 
		
		drop table #Results

End

/////////////////////////////////////////End///////////////////////////////////////////////////////////////////////////
/////////////////////////////////// label generation
                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE cir_gen_lbl_ad_lblmst
	@magcd                                    VARCHAR(20) ,
	@mdpcd                                    VARCHAR(20) ,
	@medtn                                    VARCHAR(20) ,
	@mroute                                   VARCHAR(20) ,
	@msubrt                                   VARCHAR(20) ,
	@msubsubrt                                VARCHAR(20) ,
	@mname                                    VARCHAR(4000) ,
	@mhname                                   VARCHAR(4000) ,
	@mastn                                    VARCHAR(4000) ,
	@p_ldt                                    DATETIME ,
	@p_rtnm                                   VARCHAR(4000) ,
	@p_rthnm                                  VARCHAR(4000) ,
	@p_sno                                    int ,
	@p_tno                                    int ,
	@p_msg1                                   VARCHAR(4000) ,
	@p_msg2                                   VARCHAR(4000) ,
	@p_msg3                                   VARCHAR(4000) ,
	@p_tcp1                                   int ,
	@p_tcp2                                   int ,
	@p_tcp3                                   int ,
	@p_cp1                                    int ,
	@p_cp2                                    int ,
	@p_cp3                                    int ,
	@rem_copy                                 int ,
	@pkt_size                                 int ,
	@mlblln7                                  VARCHAR(4000) ,
	@ppub                                     VARCHAR(4000) ,
	@pedtn                                    VARCHAR(4000) ,
	@pactual_sup                              int ,
	@pseq_no                                  int ,
	@pcount_pub                               int ,
	@ppubl                                    VARCHAR(4000) ,
	@p_coag                                   VARCHAR(4000) ,
	@p_codp                                   VARCHAR(4000) ,
	@p_agty                                   VARCHAR(4000) ,
	@pweek_dl                                 VARCHAR(4000) ,
	@proute_print_slno                        int ,
	@pastn_print_slno                         int ,
	@plblty                                   VARCHAR(4000) ,
	@punit_code                               VARCHAR(4000) ,
	@pcomp_code                               VARCHAR(4000) ,
	@psubrtnm                                 VARCHAR(4000) ,
	@psubrtonm                                VARCHAR(4000) ,
	@psubsubrtnm                              VARCHAR(4000) ,
	@psubsubrtonm                             VARCHAR(4000) ,
	@pcity_oname                              VARCHAR(4000) ,
	@pstation_name                            VARCHAR(4000) ,
	@pstation_oname                           VARCHAR(4000) ,
	@ppubl_name                               VARCHAR(4000) ,
	@psup_rate                                int ,
	@ppin_open_in                             VARCHAR(4000) ,
	@plbl_printno                             int ,
	@pdistseqno                               int ,
	@pdistcode                                VARCHAR(4000),
	@punpaid_copy							  int,
	@taluka_name                              varchar(200),
	@pper_copy_wt							  numeric(15,3),
    @ppkt_weight							  numeric(10)
	as 
	
		
		DECLARE @v_edtnonm                                VARCHAR(200) 
		DECLARE @mdistnm                                  VARCHAR (400) 
		DECLARE @mdistonm                                 VARCHAR (400) 

		SET @mdistnm  = null 
		SET @mdistonm  = null 

		SELECT @v_edtnonm  =  ISNULL(edtn_name_oth_lang, edtn_name) FROM  cir_edtn_mast 
		WHERE	 comp_code  = @pcomp_code AND	edtn  = @pedtn
		
		BEGIN
		     SET @v_edtnonm  = @ppubl_name 
		END
		
		SELECT @mdistnm  =  ISNULL(dist_alias, dist_name), @mdistonm  =  dist_oname FROM  cir_dist_mast 
		WHERE comp_code  = @pcomp_code AND	dist_code  = @pdistcode
		
	
		IF @pcount_pub = 1 BEGIN 
			
			INSERT INTO  cir_lblmast   ( unit_code ,agcd , dpcd , lbl_dt , edtn , route1 ,subrt , sub_subrt , rtnm , rtonm , 
			lbl_sno , lbl_tno , msg_1 , msg_2 , msg_3 , agname , agoname , city_name , tcp1 , tcp2 , tcp3 , cp1 , cp2 , cp3 , 
			lbl_lno , pkt_size , lblln5 , publ_1 , edtn_1 , supply_1 , seq_no , publ , coag , codp , agty , period , route_seqno , 
			city_seqno , lblty , comp_code , subrtnm , subrtonm , subsubrtnm , subsubrtonm , city_oname , station_name , station_oname , 
			publ_name , sup_rate , pin_open_inside , lbl_print_no , dist_seqno , distname , distoname , distcode,unpaid_copy,taluka_name,per_copy_weight,pkt_weight)  
			VALUES 	( @punit_code , @magcd , @mdpcd , CONVERT(DATETIME, CONVERT(VARCHAR(23), @p_ldt)) , @medtn , @mroute , @msubrt , 
			@msubsubrt , @p_rtnm , @p_rthnm , @p_sno , @p_tno , @p_msg1 , @p_msg2 , @p_msg3 , @mname , @mhname , @mastn , @p_tcp1 , 
			@p_tcp2 , @p_tcp3 , @p_cp1 , @p_cp2 , @p_cp3 , @rem_copy ,@pkt_size , @mlblln7 , @ppub , @pedtn , @pactual_sup , @pseq_no , 
			@ppubl , @p_coag , @p_codp , @p_agty , @pweek_dl , @proute_print_slno , @pastn_print_slno , @plblty , @pcomp_code , @psubrtnm , 
			@psubrtonm , @psubsubrtnm , @psubsubrtonm , @pcity_oname , @pstation_name , @pstation_oname , @v_edtnonm , 
			@psup_rate , @ppin_open_in , @plbl_printno , @pdistseqno , @mdistnm , @mdistonm , @pdistcode,@punpaid_copy,@taluka_name,@pper_copy_wt,@ppkt_weight )  
			
			
		
		END
		IF @pcount_pub = 2  
		BEGIN 
					INSERT INTO  cir_lblmast   ( unit_code , agcd , dpcd , lbl_dt , edtn , route1 , subrt , sub_subrt , rtnm , 
					rtonm , lbl_sno , lbl_tno , msg_1 , msg_2 , msg_3 , agname , agoname , city_name , tcp1 , tcp2 , tcp3 , cp1 , 
					cp2 , cp3 , LBL_LNO , pkt_size , lblln5 , publ_2 , edtn_2 , supply_2 , seq_no , publ , coag , codp , agty , 
					period , route_seqno , city_seqno , lblty ,comp_code , subrtnm , subrtonm , subsubrtnm , subsubrtonm , city_oname , 
					station_name , station_oname , publ_name , sup_rate , pin_open_inside , lbl_print_no , dist_seqno , distname , 
					distoname , distcode,unpaid_copy,taluka_name,per_copy_weight,pkt_weight )  
					VALUES 	( @punit_code , @magcd , @mdpcd , CONVERT(DATETIME, CONVERT(VARCHAR(23), @p_ldt)) , @medtn , @mroute , 
					@msubrt , @msubsubrt , @p_rtnm , @p_rthnm , @p_sno , @p_tno , @p_msg1 , @p_msg2 , @p_msg3 , @mname , @mhname , 
					@mastn ,@p_tcp1 , @p_tcp2 , @p_tcp3 , @p_cp1 , @p_cp2 ,@p_cp3 , @rem_copy , @pkt_size , @mlblln7 ,@ppub , @pedtn , 
					@pactual_sup , @pseq_no , @ppubl , @p_coag , @p_codp , @p_agty , @pweek_dl , @proute_print_slno , @pastn_print_slno , 
					@plblty , @pcomp_code , @psubrtnm ,@psubrtonm , @psubsubrtnm , @psubsubrtonm , @pcity_oname , @pstation_name , 
					@pstation_oname , @v_edtnonm , @psup_rate , @ppin_open_in , @plbl_printno , @pdistseqno , @mdistnm ,@mdistonm , @pdistcode,@punpaid_copy,@taluka_name,@pper_copy_wt,@ppkt_weight )  
			
			
			
		END
		IF @pcount_pub = 3  
		BEGIN 
					INSERT INTO  cir_lblmast   ( unit_code , agcd , dpcd , lbl_dt , edtn , route1 , subrt , sub_subrt , rtnm , rtonm , 
					lbl_sno , lbl_tno , msg_1 , msg_2 , msg_3 , agname , agoname , city_name , tcp1 , tcp2 , tcp3 , cp1 , cp2 , 
					cp3 , LBL_LNO , pkt_size , lblln5 , publ_3 , edtn_3 , supply_3 , seq_no , publ , coag , codp , agty , period , 
					route_seqno , city_seqno , lblty , comp_code , subrtnm , subrtonm , subsubrtnm , subsubrtonm , city_oname , 
					station_name , station_oname , publ_name , sup_rate , pin_open_inside , lbl_print_no , dist_seqno , distname , distoname , distcode,unpaid_copy,taluka_name,per_copy_weight,pkt_weight )  
					VALUES 	( @punit_code , @magcd , @mdpcd , CONVERT(DATETIME, CONVERT(VARCHAR(23), @p_ldt)) , @medtn , @mroute , @msubrt , 
					@msubsubrt , @p_rtnm , @p_rthnm , @p_sno ,@p_tno , @p_msg1 , @p_msg2 , @p_msg3 , @mname , @mhname , @mastn , 
					@p_tcp1 , @p_tcp2 , @p_tcp3 , @p_cp1 , @p_cp2 , @p_cp3 , @rem_copy , @pkt_size , @mlblln7 , @ppub , @pedtn , 
					@pactual_sup , @pseq_no , @ppubl , @p_coag , @p_codp , @p_agty , @pweek_dl , @proute_print_slno , @pastn_print_slno , 
					@plblty , @pcomp_code , @psubrtnm , @psubrtonm , @psubsubrtnm , @psubsubrtonm , @pcity_oname , @pstation_name , 
					@pstation_oname , @v_edtnonm , @psup_rate , @ppin_open_in , @plbl_printno , @pdistseqno , @mdistnm , @mdistonm , @pdistcode,@punpaid_copy,@taluka_name,@pper_copy_wt,@ppkt_weight )  
			
			
			
		END
		IF @pcount_pub = 4  
		BEGIN 
			INSERT INTO  cir_lblmast   ( unit_code , agcd , dpcd , lbl_dt , edtn , route1 , subrt , sub_subrt , rtnm , rtonm , 
			lbl_sno , lbl_tno , msg_1 , msg_2 , msg_3 , agname , agoname , city_name , tcp1 , tcp2 , tcp3 , cp1 , cp2 , 
			cp3 , LBL_LNO , pkt_size , lblln5 , publ_4 , edtn_4 , supply_4 , seq_no , publ , coag , codp , agty , period , 
			route_seqno , city_seqno , lblty , comp_code , subrtnm , subrtonm , subsubrtnm ,subsubrtonm , city_oname , station_name , station_oname , 
			publ_name , sup_rate , pin_open_inside , lbl_print_no , dist_seqno , distname , distoname , distcode,unpaid_copy,taluka_name ,per_copy_weight,pkt_weight)  
			VALUES ( @punit_code , @magcd ,@mdpcd , CONVERT(DATETIME, CONVERT(VARCHAR(23), @p_ldt)) , @medtn , @mroute , 
			@msubrt , @msubsubrt , @p_rtnm , @p_rthnm , @p_sno , @p_tno , @p_msg1 , @p_msg2 , @p_msg3 , @mname , @mhname , 
			@mastn , @p_tcp1 , @p_tcp2 , @p_tcp3 , @p_cp1 , @p_cp2 , @p_cp3 , @rem_copy , @pkt_size , @mlblln7 , @ppub , 
			@pedtn , @pactual_sup , @pseq_no , @ppubl , @p_coag , @p_codp , @p_agty , @pweek_dl , @proute_print_slno , 
			@pastn_print_slno , @plblty , @pcomp_code , @psubrtnm ,@psubrtonm , @psubsubrtnm , @psubsubrtonm , @pcity_oname , 
			@pstation_name , @pstation_oname , @v_edtnonm , @psup_rate , @ppin_open_in , @plbl_printno , @pdistseqno , 
			@mdistnm , @mdistonm , @pdistcode,@punpaid_copy,@taluka_name,@pper_copy_wt,@ppkt_weight )  
		
		END
   
--		update cir_lblmast set lbl_tno = ( select count ( *) from cir_lblmast 
--        where comp_code = pcomp_code and unit_code = punit_code and  edtn = medtn and agcd = magcd  and dpcd = mdpcd 
--        and lbl_dt =convert(varchar,p_ldt,101) --to_date ( to_char ( p_ldt) , 'dd-mon-yy')) 
--        where comp_code = pcomp_code and unit_code = punit_code and --publ=ppubl and  edtn = medtn and agcd = magcd and dpcd = mdpcd and lbl_dt = to_date ( to_char ( p_ldt) , 'dd-mon-yy')
		
        
         update cir_lblmast set lbl_tno=(select count(*) from cir_lblmast 
                                            where comp_code=@pcomp_code and 
                                                  unit_code=@punit_code and 
                                                  edtn=@medtn and 
                                                  agcd=@magcd and
                                                  dpcd=@mdpcd and 
                                                  lbl_dt=convert(varchar,@p_ldt,101))--to_date(to_char(p_ldt),'dd-mon-yy')) 
                         where comp_code=@pcomp_code and 
                              unit_code=@punit_code and 
                           
                              edtn=@medtn and 
                              agcd=@magcd and
                              dpcd=@mdpcd and
                              lbl_dt=convert(varchar,@p_ldt,101)
///////////////////////////////////////////////////////////////////////////end of label generation///////////////

*************************** issue 6377 (Publication Master) ******************************

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER PROCEDURE  [dbo].[Cir_Gen_Code_publ_mast]

    @pcompcode                                VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS 
		DECLARE @vno                                      NUMERIC(5) 
		DECLARE @vpubl_code                               VARCHAR(15) 
		DECLARE @v_sess_id                                NUMERIC(20) 

		set @v_sess_id=(SELECT top 1 session_id  FROM sys.dm_exec_requests where sql_handle is not null);

		SELECT @vno  =  max(cast(substring(publ,2,len(publ))as int))+1
		FROM  cir_publ_mast 
		WHERE	 comp_code  = @pcompcode
	
		IF ISNULL(@vno, 0)= 0 
			BEGIN 
				SET @vpubl_code  = 'P' + '01' 
			END
		ELSE
			BEGIN 
				SET @vpubl_code  = 'P' + dbo.fnPadLeft('0',2,@vno)  
			END
   
		SELECT @vpubl_code as VAR_CODE


***************** end of issue 6377 *******************************************************




///////////////////////issue no 6771/////////////////////////////////////////////



USE [abhi]
GO
/****** Object:  StoredProcedure [dbo].[cir_citywise_supply]    Script Date: 04/23/2012 18:14:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER procedure [dbo].[cir_citywise_supply](
@pcomp_code        as varchar(50),
@punit_code       as varchar(50),
@pbrancode         as varchar(50),
@ppublcode        as varchar(50),
@pagtype          as varchar(50),
@pstatecode        as varchar(50),
@pcitycode         as varchar(50),
@pfrom_supdate     as varchar(50),
@ptill_supdate     as varchar(50),
@pdateformat       as varchar(50),
@pextra1           as varchar(50),
@pextra2            as varchar(50)

)
as
SET CONCAT_NULL_YIELDS_NULL OFF
CREATE TABLE #CIR_TEMP_DT
(
  SQNO  NUMeric,
  DT    DATEtime
)

declare @vfrdt  as  datetime;
declare @vtodt  as datetime;
declare @v_dt   as  datetime;
declare @v_cnt   as numeric(5)
declare @vvar    as varchar(4000);
declare @vvar_sum   as  varchar(4000);
declare @vvar_sum1  as  varchar(4000);
declare @v_query  as  varchar(max);
declare @v_query1  as  varchar(max);

set @v_cnt=0;

set @vfrdt=dbo.GetLastDayOfMonth (@pfrom_supdate)  --@pfrom_supdate;
set @vtodt=dbo.GetFirstDayOfMonth (@ptill_supdate) --@ptill_supdate;


print('abcd')
print(@v_dt)


if @v_dt is null or @v_dt = '' 
begin
print('abc')
set @v_dt=@vfrdt
end
print('@vfrdt')print(@vfrdt)
WHILE (@v_dt < @vtodt)
BEGIN
	if @v_dt>=@vtodt begin
       break;
    end
	print('@v_dt') print(@v_dt)
	if @v_dt is null or @v_dt = '' begin
	--if @v_dt=@vfrdt begin
		set @v_dt=dbo.GetLastDayOfMonth (@vfrdt);
		print('@v_dt1') print(@v_dt)
	end
	else
	begin
	print('@v_dt2')
		set @v_dt=DATEADD(mm,1,@v_dt)
		print(@v_dt)
	end
	set @v_cnt=@v_cnt+1
	print(@v_cnt)
	insert into #cir_temp_dt(sqno,dt) values(@v_cnt,@v_dt);
END
print('x')

declare c1 cursor for
select sqno,dt from #cir_temp_dt order by sqno,dt;

declare @c1_sqno as numeric
declare @c1_dt as datetime



OPEN c1 
	fetch NEXT FROM c1 INTO @c1_sqno , @v_dt
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN
		print('1')
			set @v_cnt= @v_cnt+1 
			if (@vvar is null or @vvar = '') begin print('2')
				--set @vvar        ='sum(decode(last_day(b.billdt),'+''''+@v_dt+''''+',b.bill_copy,0))"'+to_char(v_dt,'Mon/YYYY')+'"';
				set @vvar        ='sum(case(dbo.GetLastDayOfMonth(b.billdt)) when '+''''+cast(@v_dt as varchar)+''''+' then b.bill_copy else 0 end) "'+SUBSTRING(CONVERT(VARCHAR(11), @v_dt, 113), 4, 8)+'"';
				print('3')--set @vvar_sum    ='sum('+'"'+to_char(v_dt,'Mon/YYYY')+'") "'+to_char(v_dt,'Mon/YYYY')+'"';
				set @vvar_sum    ='sum(d.'+'"'+SUBSTRING(CONVERT(VARCHAR(11), @v_dt, 113), 4, 8)+'") "'+SUBSTRING(CONVERT(VARCHAR(11), @v_dt, 113), 4, 8)+'"';
				set @vvar_sum1   ='sum(d.'+'"'+SUBSTRING(CONVERT(VARCHAR(11), @v_dt, 113), 4, 8)+'"';
			end
			else
			begin
				--set @vvar        =@vvar+','+'sum(decode(last_day(b.billdt),'+''''+v_dt+''''+',b.bill_copy,0))"'+SUBSTRING(CONVERT(VARCHAR(11), @v_dt, 113), 4, 8)+'"';
				set @vvar        =@vvar+','+'sum(case(dbo.GetLastDayOfMonth(b.billdt)) when '+''''+cast(@v_dt as varchar)+''''+' then b.bill_copy else 0 end) "'+SUBSTRING(CONVERT(VARCHAR(11), @v_dt, 113), 4, 8)+'"';
				set @vvar_sum    =@vvar_sum+','+'sum(d.'+'"'+SUBSTRING(CONVERT(VARCHAR(11), @v_dt, 113), 4, 8)+'") "'+SUBSTRING(CONVERT(VARCHAR(11), @v_dt, 113), 4, 8)+'"';
				set @vvar_sum1   =@vvar_sum1+'+d."'+SUBSTRING(CONVERT(VARCHAR(11), @v_dt, 113), 4, 8)+'"';
			end
				
				
	fetch NEXT FROM c1 INTO @c1_sqno , @v_dt
END 	
close c1
DEALLOCATE c1
if @vvar_sum1 is not null or @vvar_sum1 !='' begin
            set @vvar_sum1=@vvar_sum1+') "Total"'
end
print('a')


if @vvar is not null and @vvar !='' begin

set  @v_query='select d.comp_code comp_code,d.unit_code unit_code,s."State_Name" state_name,dbo.cir_get_city(d.comp_code,d.city_code) city_name,'+@vvar_sum+','+@vvar_sum1+' from (select b.comp_code comp_code,b.unit_code unit_code,a.state_code state_code,
        a.city_code city_code,'+@vvar+' from cir_agmast a, cir_bill_det b
        where a.comp_code=b.comp_code and b.comp_code='+''''+@pcomp_code+''''+' and a.unit=b.unit_code 
and 
(b.unit_code='''+@punit_code+''' or  '''+@punit_code+''' is null or '''+@punit_code+''' ='''' )
 and 
        a.agcd=b.agcd and a.dpcd=b.dpcd 
and (a.branch_code='''+@pbrancode+''' or '''+@pbrancode+'''='''' or  '''+@pbrancode+''' is null) 

and (a.ag_type='''+@pagtype+''' or '''+@pagtype+'''='''' or  '''+@pagtype+''' is null ) 
and (b.publ ='''+@ppublcode+'''  or '''+@ppublcode+'''='''' or  '''+@ppublcode+''' is null) 
and (a.state_code='''+@pstatecode+'''   or '''+@pstatecode+'''='''' or  '''+@pstatecode+''' is null) 
and (a.city_code='''+@pcitycode+'''  or '''+@pcitycode+'''='''' or  '''+@pcitycode+''' is null)

 and
        b.billdt between '+''''+cast(@vfrdt as varchar)+''''+' and '+''''+cast(@vtodt as varchar)+''''+' group by b.comp_code,b.unit_code,b.billdt,a.city_code,a.state_code) d,state_mst s
        where d.state_code=s."State_Code" 
        group by d.comp_code,d.unit_code,s."State_Name",d.city_code order by comp_code,unit_code,state_name,city_name';
        --insert into test1(vstring,vstring2) values('cir_citywise_supply ',v_query);commit;
      
print(@v_query)
exec(@v_query)
        
		set      @v_query1='select d.comp_code comp_code,d.unit_code unit_code,s."State_Name" state_name,'+@vvar_sum+','+@vvar_sum1+' from (select b.comp_code comp_code,b.unit_code unit_code,a.state_code state_code,
		a.city_code city_code,'+@vvar+' from cir_agmast a, cir_bill_det b
		where a.comp_code=b.comp_code and b.comp_code='+''''+@pcomp_code+''''+' 
		and a.unit=b.unit_code 

and 
(b.unit_code='''+@punit_code+''' or  '''+@punit_code+''' is null or '''+@punit_code+''' ='''' )
 and 
        a.agcd=b.agcd and a.dpcd=b.dpcd 
and (a.branch_code='''+@pbrancode+''' or '''+@pbrancode+'''='''' or  '''+@pbrancode+''' is null) 

and (a.ag_type='''+@pagtype+''' or '''+@pagtype+'''='''' or  '''+@pagtype+''' is null ) 
and (b.publ ='''+@ppublcode+'''  or '''+@ppublcode+'''='''' or  '''+@ppublcode+''' is null) 
and (a.state_code='''+@pstatecode+'''   or '''+@pstatecode+'''='''' or  '''+@pstatecode+''' is null) 
and (a.city_code='''+@pcitycode+'''  or '''+@pcitycode+'''='''' or  '''+@pcitycode+''' is null)

 and


		 b.billdt between '+''''+cast(@vfrdt as varchar)+''''+' 
		and '+''''+cast(@vtodt as varchar)+''''+' 
		group by b.comp_code,b.unit_code,b.billdt,a.city_code,a.state_code) d,state_mst s
		where d.state_code=s."State_Code"
		group by d.comp_code,d.unit_code,s."State_Name" order by comp_code,unit_code,state_name';
        --insert into test1(vstring,vstring2) values('cir_citywise_supply ',v_query);commit;
        --open p_accounts1 for v_query;
print(@v_query1)
exec(@v_query1) 
end
else
begin
set  @v_query='select d.comp_code comp_code,d.unit_code unit_code,s."State_Name" state_name,dbo.cir_get_city(d.comp_code,d.city_code) city_name from (select b.comp_code comp_code,b.unit_code unit_code,a.state_code state_code,
        a.city_code city_code from cir_agmast a, cir_bill_det b
        where a.comp_code=b.comp_code and b.comp_code='+''''+@pcomp_code+''''+' and a.unit=b.unit_code 
and 
(b.unit_code='''+@punit_code+''' or  '''+@punit_code+''' is null or '''+@punit_code+''' ='''' )
 and 
        a.agcd=b.agcd and a.dpcd=b.dpcd 
and (a.branch_code='''+@pbrancode+''' or '''+@pbrancode+'''='''' or  '''+@pbrancode+''' is null) 

and (a.ag_type='''+@pagtype+''' or '''+@pagtype+'''='''' or  '''+@pagtype+''' is null ) 
and (b.publ ='''+@ppublcode+'''  or '''+@ppublcode+'''='''' or  '''+@ppublcode+''' is null) 
and (a.state_code='''+@pstatecode+'''   or '''+@pstatecode+'''='''' or  '''+@pstatecode+''' is null) 
and (a.city_code='''+@pcitycode+'''  or '''+@pcitycode+'''='''' or  '''+@pcitycode+''' is null)

 and
        b.billdt between '+''''+cast(@vfrdt as varchar)+''''+' and '+''''+cast(@vtodt as varchar)+''''+' group by b.comp_code,b.unit_code,b.billdt,a.city_code,a.state_code) d,state_mst s
        where d.state_code=s."State_Code" 
        group by d.comp_code,d.unit_code,s."State_Name",d.city_code order by comp_code,unit_code,state_name,city_name';
        --insert into test1(vstring,vstring2) values('cir_citywise_supply ',v_query);commit;
      
print(@v_query)
exec(@v_query)
        
		set      @v_query1='select d.comp_code comp_code,d.unit_code unit_code,s."State_Name" state_name from (select b.comp_code comp_code,b.unit_code unit_code,a.state_code state_code,
		a.city_code city_code from cir_agmast a, cir_bill_det b
		where a.comp_code=b.comp_code and b.comp_code='+''''+@pcomp_code+''''+' 
		and a.unit=b.unit_code 

and 
(b.unit_code='''+@punit_code+''' or  '''+@punit_code+''' is null or '''+@punit_code+''' ='''' )
 and 
        a.agcd=b.agcd and a.dpcd=b.dpcd 
and (a.branch_code='''+@pbrancode+''' or '''+@pbrancode+'''='''' or  '''+@pbrancode+''' is null) 

and (a.ag_type='''+@pagtype+''' or '''+@pagtype+'''='''' or  '''+@pagtype+''' is null ) 
and (b.publ ='''+@ppublcode+'''  or '''+@ppublcode+'''='''' or  '''+@ppublcode+''' is null) 
and (a.state_code='''+@pstatecode+'''   or '''+@pstatecode+'''='''' or  '''+@pstatecode+''' is null) 
and (a.city_code='''+@pcitycode+'''  or '''+@pcitycode+'''='''' or  '''+@pcitycode+''' is null)

 and


		 b.billdt between '+''''+cast(@vfrdt as varchar)+''''+' 
		and '+''''+cast(@vtodt as varchar)+''''+' 
		group by b.comp_code,b.unit_code,b.billdt,a.city_code,a.state_code) d,state_mst s
		where d.state_code=s."State_Code"
		group by d.comp_code,d.unit_code,s."State_Name" order by comp_code,unit_code,state_name';
        --insert into test1(vstring,vstring2) values('cir_citywise_supply ',v_query);commit;
        --open p_accounts1 for v_query;
print(@v_query1)
exec(@v_query1) 
end

    


SET CONCAT_NULL_YIELDS_NULL On



////////////////////////////////end of issue 6771////////////////////////


///////////////////////////////Deepika 23/04/2012  sent by Laxman sir////////////////////////////////////////////

                                                                                                                                                                                                                                                       
create PROCEDURE CIR_SUPPLY_POST_FOR_NEXT_DIS_cir_check_supply_posting_p
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

    select @v_bill_exist=count(*) from cir_bill_det_dis d,cir_publ_mast p,cir_edtn_mast e
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
					from cir_dbksup_dis a,cir_edtn_mast e
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
					from cir_dbksup_dis a,cir_edtn_mast e
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


/////////////////////////////////////////////////////
                                                                     
                                                                     
                                                                     
                                             
create PROCEDURE CIR_SUPPLY_POST_FOR_NEXT_DIS_cir_supply_posting_p
	@pcomp_code			VARCHAR(20) ,
	@punit_code			VARCHAR(20) ,
	@ppubl_code         VARCHAR(20) ,
	@pedtn_code         VARCHAR(20) ,
	@pagcd				VARCHAR(20) ,
	@pdpcd				VARCHAR(20) ,
	@puserid			VARCHAR(20) ,
	@psup_date			varchar(500) ,
	--@psup_date1       VARCHAR(20),
	@psup_ty			VARCHAR(20) ,
	@pdateformat		VARCHAR(20) ,
	@pextra1			VARCHAR(20) ,
	@pextra2			VARCHAR(20)
AS 
DECLARE  @vsup_date   DATETIME
DECLARE  @vh_date1    DATETIME
DECLARE  @vh_name1    VARCHAR(500)

DECLARE cur_holiday cursor  LOCAL FOR 
		select h_date,h_name from cir_holiday_mast
			where comp_code=@pcomp_code and unit=@punit_code and 
				h_publ=@ppubl_code and h_date=@vsup_date and 
				ISNULL(freeze_flag,'N')='N';

DECLARE @vedtn1			VARCHAR(500)
DECLARE @vedtn_name1    VARCHAR(500)

DECLARE	@v_spl_rate    NUMERIC(10,4)
SET @v_spl_rate = 0

   
/*************        DECLARE VARIABLES FOR cur_supply  CURSOR        *****************/

DECLARE  @vunit1				VARCHAR(500)
DECLARE  @vagcd1				VARCHAR(500)
DECLARE  @vdpcd1				VARCHAR(500)
DECLARE  @vpubl1				VARCHAR(500)
DECLARE  @vedtn11				VARCHAR(500)
DECLARE  @vsupply_type_code1	VARCHAR(500)
DECLARE  @vbase_supply1			numeric(7,0)
DECLARE  @vsupply_sun1			numeric(7,0)
DECLARE  @vsupply_mon1			numeric(7,0)
DECLARE  @vsupply_tue1			numeric(7,0)
DECLARE  @vsupply_wed1			numeric(7,0)
DECLARE  @vsupply_thu1			numeric(7,0)
DECLARE  @vsupply_fri1			numeric(7,0)
DECLARE  @vsupply_sat1			numeric(7,0)
DECLARE  @vsupply_spl11			numeric(7,0)
DECLARE  @vsupply_spl21			numeric(7,0)
DECLARE  @vag_type1				VARCHAR(500)
DECLARE  @vsupply_start_dt1		VARCHAR(500)
DECLARE  @vsuspend_date1		VARCHAR(500)
DECLARE  @vpacket_size1			VARCHAR(500)
DECLARE  @vcomm_code1			VARCHAR(500)
DECLARE  @vcomm_flag1			VARCHAR(500)
DECLARE  @vbill_agcd1			VARCHAR(500)
DECLARE  @vroute_code1			VARCHAR(500)
DECLARE  @vsubroute_code1		VARCHAR(500)
DECLARE  @vsub_subroute_code1	VARCHAR(500)
DECLARE  @vsurch_cd1			VARCHAR(500)
DECLARE  @vwaste_catg_code		VARCHAR(500)

DECLARE  @vbill_dpcd1			VARCHAR(500)
DECLARE @v_supply_copy_dt		varchar(20)
/*****************************************************************************************/

set @psup_date	=dbo.convert_user_date('/',@psup_date,@pdateformat)
set @pextra2	=dbo.convert_user_date('/',@pextra2,@pdateformat)

if @pextra1 is not null begin
	set @v_supply_copy_dt=dbo.convert_user_date('/',@pextra1,@pdateformat)
end


DECLARE cur_surcharge cursor LOCAL FOR 
            select * from cir_surcharge_mast 
            where comp_code  =@pcomp_code and 
                  unit       =@punit_code and
                  publ       =@ppubl_code and
                  edtn       =@vedtn1 and
                  surch_cd   =@vsurch_cd1 and 
                  valid_from = (select max(valid_from) from cir_surcharge_mast 
                                            where comp_code  =@pcomp_code and 
                                                  unit       =@punit_code and
                                                  publ       =@ppubl_code and
                                                  edtn       =@vedtn1 and
                                                  surch_cd   =@vsurch_cd1 and
                                                  valid_from<=@psup_date);
DECLARE	@v_sup_copy			NUMERIC(7)
DECLARE @v_edtn_rate		NUMERIC(10,4)
DECLARE @vreccnt			NUMERIC(5,0)
DECLARE @v_old_sup_copy		NUMERIC(7)

   
/*********************       SEND CONVERTED DATE FROM SQL CLASS     ************/
-- vsup_date:=to_date(psup_date,''''||pdateformat||'''');
SET  @vsup_date = @psup_date

/*******************************************************************************/

open cur_holiday;
fetch NEXT FROM cur_holiday into @vh_date1 , @vh_name1
close cur_holiday
    
if (@vsup_date=@vh_date1) BEGIN
	PRINT('Please Check The  Holiday Today Is  '+' '+   @vh_name1)
	PRINT('Please Check The  Holiday Today Is  '+' '+   @vh_name1)
end 
    
if ((@vsup_date<>@vh_date1) or @vh_date1 is null) BEGIN

	DECLARE cir_edtn_cur cursor LOCAL FOR 
          select distinct edtn,edtn_name from cir_edtn_mast 
			where comp_code=@pcomp_code and publ = @ppubl_code and
		     ((ISNULL(main_edtn,edtn) = @pedtn_code) or (@pedtn_code is null) or (@pedtn_code='')) and ISNULL(freeze_flag,'N')='N'
  
		open cir_edtn_cur
		fetch NEXT FROM cir_edtn_cur into @vedtn1 , @vedtn_name1
		WHILE @@FETCH_STATUS = 0 BEGIN
              
        delete from cir_dbksup_dis where comp_code=@pcomp_code and unit_code=@punit_code and
			publ=@ppubl_code and edtn=@vedtn1 and supdate=@vsup_date and 
			(agcd=@pagcd or @pagcd is null OR @pagcd='') and (dpcd=@pdpcd or @pdpcd is null OR @pdpcd='')


		/*****************************************************************************************/     
					        
		DECLARE cur_spl_rate cursor LOCAL FOR
			select spl_day_rate from cir_special_rate_mast
			where comp_code=@pcomp_code and unit=@punit_code and
				publ=@ppubl_code and edtn=@vedtn1 and spl_day_date=@vsup_date;


		open cur_spl_rate
			fetch NEXT FROM cur_spl_rate into @v_spl_rate;
		close cur_spl_rate;
        
        deallocate cur_spl_rate
        
  		if (ISNULL(@v_spl_rate,0)=0 )BEGIN

			 DECLARE  @vsun_rate1   FLOAT
			 DECLARE  @vmon_rate1   FLOAT
			 DECLARE  @vtue_rate1   FLOAT
			 DECLARE  @vwed_rate1   FLOAT
			 DECLARE  @vthu_rate1   FLOAT
			 DECLARE  @vfri_rate1   FLOAT
			 DECLARE  @vsat_rate1   FLOAT
							 

			DECLARE cur_rate cursor LOCAL FOR 
				select sun_rate,mon_rate,tue_rate,wed_rate,thu_rate,fri_rate,sat_rate from cir_rate_mast
				where comp_code=@pcomp_code and unit=@punit_code and publ=@ppubl_code and edtn=@vedtn1 and
				valid_from=(select max(valid_from) from cir_rate_mast where comp_code=@pcomp_code and
				unit=@punit_code and publ=@ppubl_code and edtn=@vedtn1 and valid_from<=@vsup_date and 
				ISNULL(freeze_flag,'N')='N');
			
			open cur_rate;
			fetch NEXT FROM cur_rate into @vsun_rate1, @vmon_rate1, @vtue_rate1, @vwed_rate1, @vthu_rate1, @vfri_rate1, @vsat_rate1
			close cur_rate;
					
			deallocate  cur_rate;
                  
			DECLARE @SUP_DAY11    varchar(20)
			SET @SUP_DAY11 = CONVERT(VARCHAR(20) , DATENAME(WEEKDAY, @psup_date),20)

			if (@SUP_DAY11 = 'Sunday' )begin          
				set  @v_edtn_rate      =    @vsun_rate1 ;
            end

			else if (@SUP_DAY11 = 'Monday') begin
				set  @v_edtn_rate      =    @vmon_rate1;
			end
			else if (@SUP_DAY11 = 'Tuesday')begin 
				set  @v_edtn_rate      =    @vtue_rate1;
			end
			else if (@SUP_DAY11 = 'Wednesday') begin
				set  @v_edtn_rate      =    @vwed_rate1;
            end
			else if (@SUP_DAY11 = 'Thursday')begin
				set  @v_edtn_rate      =    @vthu_rate1;
			end
			else if (@SUP_DAY11 = 'Friday' )begin
				set  @v_edtn_rate      =    @vfri_rate1;
			end
			else if (@SUP_DAY11 = 'Saturday')begin
				set  @v_edtn_rate      =    @vsat_rate1;
			end
			else begin
				set @v_edtn_rate        =    0
			end 
		end
		else begin
			set @v_edtn_rate  =  @v_spl_rate;
		end 
		
		if (@v_edtn_rate=0)begin
			print('Please Check,The Rate Today Is not Define for '+' '+  @vedtn_name1)
		end 

		DECLARE  cur_supply cursor LOCAL FOR 
		select a.unit unit,a.agcd agcd,a.dpcd dpcd,a.publ publ,a.edtn edtn,a.supply_type_code supply_type_code,a.base_supply base_supply,a.supply_sun supply_sun,
		a.supply_mon supply_mon,a.supply_tue supply_tue,a.supply_wed supply_wed,
		a.supply_thu supply_thu,a.supply_fri supply_fri,a.supply_sat supply_sat,a.supply_spl1 supply_spl1,
		a.supply_spl2 supply_spl2, b.ag_type ag_type,b.supply_start_dt    supply_start_dt,b.suspend_date suspend_date, ISNULL(a.packet_size,0) packet_size,
		a.comm_code comm_code,a.comm_flag comm_flag,b.bill_agcd bill_agcd,b.bill_dpcd bill_dpcd,
		a.route_code route_code,a.subroute_code subroute_code,a.sub_subroute_code sub_subroute_code,
		a.surch_cd surch_cd,a.waste_catg_code waste_catg_code
		from cir_supply_dis a,cir_agmast_dis b
		where a.comp_code=b.comp_code and a.unit=b.unit and 
				  a.agcd=b.agcd and a.dpcd=b.dpcd and (a.agcd=@pagcd or @pagcd is null or @pagcd='') 
				  and (a.dpcd=@pdpcd or @pdpcd is null OR @pdpcd='') and 
				  a.unit=@punit_code and (a.publ=@ppubl_code) and
				  ISNULL(base_supply,0)>0 and
				  a.edtn=@vedtn1 and
				  ISNULL(a.supply_flag,'N')='Y' and ISNULL(b.suspend,'N')='N'
		order by a.agcd,a.dpcd,a.edtn,a.supply_type_code;


		 open cur_supply 

		 fetch next from cur_supply into @vunit1 ,@vagcd1 ,@vdpcd1 ,@vpubl1 ,@vedtn11 ,@vsupply_type_code1,@vbase_supply1,
		 @vsupply_sun1 ,@vsupply_mon1 ,@vsupply_tue1 ,@vsupply_wed1 ,@vsupply_thu1 ,@vsupply_fri1,@vsupply_sat1 ,@vsupply_spl11,
		 @vsupply_spl21, @vag_type1 ,@vsupply_start_dt1, @vsuspend_date1 ,@vpacket_size1 ,@vcomm_code1 ,@vcomm_flag1 ,@vbill_agcd1 ,@vbill_dpcd1,
		 @vroute_code1 ,@vsubroute_code1 ,@vsub_subroute_code1 ,@vsurch_cd1 ,@vwaste_catg_code
	       
         
		SET @vsup_date= CONVERT(VARCHAR(10),@vsup_date,10)
                 
		WHILE @@FETCH_STATUS = 0 begin
			
			DECLARE @SUP_DAY112    varchar(20)
 
            SET  @SUP_DAY112 = CONVERT(VARCHAR(20) , DATENAME(WEEKDAY, @vsup_date),20)
			
			if (@vsup_date>=@vsupply_start_dt1 or @vsupply_start_dt1 is null) and (@vsup_date<=@vsuspend_date1 or @vsuspend_date1 is null) begin 
				if (@psup_ty='R' and @SUP_DAY112 = 'Sunday' ) begin   
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_sun1,0)>0  begin
						set @v_sup_copy   =  ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_sun1,0);
                    end
					else begin
						set @v_sup_copy   = 0;
					end 
				end
				else if (@psup_ty='R' and @SUP_DAY112 = 'Monday') begin    
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_mon1,0)>0 begin
						set @v_sup_copy    =     ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_mon1,0);
					end
					else begin
						set @v_sup_copy    = 0
					end
				end
				else if (@psup_ty='R' and @SUP_DAY112 = 'Tuesday')begin  
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_tue1,0)>0 begin
						set  @v_sup_copy  =  ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_tue1,0);
					end
					else begin
						set @v_sup_copy       = 0;
                    end 
				end
				else if (@psup_ty='R' and @SUP_DAY112 = 'Wednesday') begin   
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_wed1,0)>0 begin 
						
						set @v_sup_copy =  ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_wed1,0)
						
	                end
					else begin
						set @v_sup_copy  = 0
					end 
				end 
				else if (@psup_ty='R' and @SUP_DAY112 = 'Thursday')begin   
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_thu1,0)>0 begin
						set @v_sup_copy  = ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_thu1,0)
					end
                    else begin
						set @v_sup_copy  = 0
                    end 
				end   
				else if (@psup_ty='R' and @SUP_DAY112 = 'Friday' )begin   
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_fri1,0)>0 begin
				
						set @v_sup_copy   =  ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_fri1,0);
                
                    end                
					else
						set @v_sup_copy   = 0
                    end 
				else if (@psup_ty='R' and @SUP_DAY112 = 'Saturday') begin    
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_sat1,0)>0 begin
						set @v_sup_copy   =  ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_sat1,0);
                    end
					else begin
						set @v_sup_copy   = 0
					end
				end 
				else if @psup_ty='S1' begin    
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_spl11,0)>0 begin
						set @v_sup_copy   =     ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_spl11,0);
					end
					else begin
						set @v_sup_copy   = 0
					end 
				end	
				else if @psup_ty='S2' begin    
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_spl21,0)>0 begin
						set @v_sup_copy   =     ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_spl21,0);
                    end
                    else begin
						set @v_sup_copy   = 0
                    end 
				end

			--------change for supply copy--------
					           
            if @psup_ty='R' and @v_supply_copy_dt is not null begin
                set @v_old_sup_copy=0;
                select @v_old_sup_copy = sum(sup_copy) from cir_dbksup_dis where comp_code=@pcomp_code and unit_code=@punit_code and publ=@ppubl_code and edtn=@vedtn11 and
                    agcd=@vagcd1 and dpcd=@vdpcd1 and supdate=@v_supply_copy_dt and sup_type_code=@vsupply_type_code1;
   
            end

            if isnull(@v_old_sup_copy,0)>0 begin
                set @v_sup_copy=@v_old_sup_copy;
            end
           
            --------change for supply copy--------
					            
			if ISNULL(@v_sup_copy,0)>0 Begin
				print('22tytr')
				print( @v_sup_copy)
				
				insert into cir_dbksup_dis (comp_code,unit_code,publ,edtn,agcd,dpcd,supdate,sup_type_code,sup_copy,agency_ty_code,
										agency_pkt_size,comm_code,comm_fix_auto_spl,sup_rate,billagcd,billdpcd,
										route_code,subroute_code,subsubroute_code,userid,surch_cd,issue_date,waste_catg_code)
								values (@pcomp_code,@punit_code,@ppubl_code,@vedtn11,@vagcd1,@vdpcd1,@vsup_date,
									 @vsupply_type_code1,
									 @v_sup_copy,@vag_type1,@vpacket_size1,@vcomm_code1,@vcomm_flag1,
									 @v_edtn_rate,@vbill_agcd1,@vbill_dpcd1,@vroute_code1,
									 @vsubroute_code1,@vsub_subroute_code1,@puserid,@vsurch_cd1,@pextra2,@vwaste_catg_code);

				select @vreccnt	= count(*)  from cir_dbksup_dis where comp_code=@pcomp_code and unit_code=@punit_code 
				and publ=@ppubl_code and edtn=@vedtn1 and supdate=@vsup_date and (agcd=@pagcd or @pagcd is null) and (dpcd=@pdpcd or @pdpcd is null);
					               
			End;                     
		end 
    

         fetch next from cur_supply into @vunit1 ,@vagcd1 ,@vdpcd1 ,@vpubl1 ,@vedtn11 ,@vsupply_type_code1,@vbase_supply1,
		 @vsupply_sun1 ,@vsupply_mon1 ,@vsupply_tue1 ,@vsupply_wed1 ,@vsupply_thu1 ,@vsupply_fri1,@vsupply_sat1 ,@vsupply_spl11,
		 @vsupply_spl21, @vag_type1 ,@vsupply_start_dt1, @vsuspend_date1 ,@vpacket_size1 ,@vcomm_code1 ,@vcomm_flag1 ,@vbill_agcd1 ,@vbill_dpcd1,
		 @vroute_code1 ,@vsubroute_code1 ,@vsub_subroute_code1 ,@vsurch_cd1,@vwaste_catg_code 

	end 
	close cur_supply;
	deallocate cur_supply
	   
	set @v_edtn_rate = 0;
	set @v_spl_rate  =0;
	set @vedtn1=NULL;

fetch NEXT FROM cir_edtn_cur into @vedtn1 , @vedtn_name1
end
close cir_edtn_cur
deallocate  cir_edtn_cur  
end 
  
    select case b.bill_pay
              when 'Y' then 'PAID'
              when 'N' then 'UNPAID'
              else  'UNPAID' 
              end  BILL_PAY,
   sum(a.sup_copy) SUP_COPY
    from cir_dbksup_dis a,cir_supply_type_mast b,CIR_EDTN_MAST e
    where a.comp_code=@pcomp_code and a.comp_code=b.comp_code and a.comp_code=e.comp_code and  a.unit_code=@punit_code and 
          a.publ=@ppubl_code and a.publ = e.publ and a.edtn= e.edtn and 
          (ISNULL(e.main_edtn,e.edtn) = @pedtn_code or @pedtn_code is null OR  @pedtn_code='') and 
          a.sup_type_code=b.sup_ty_code and a.supdate=@vsup_date and 
          (a.agcd=@pagcd or @pagcd is null OR @pagcd='') and (a.dpcd=@pdpcd or @pdpcd is null or @pdpcd ='')
    group by b.bill_pay
    order by b.bill_pay desc
  
deallocate cur_holiday
deallocate cur_surcharge 


//////////////////////////////////

                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE CIR_SUPPLY_POST_FOR_NEXT_DAY_cir_supply_posting_p
	@pcomp_code			VARCHAR(20) ,
	@punit_code			VARCHAR(20) ,
	@ppubl_code         VARCHAR(20) ,
	@pedtn_code         VARCHAR(20) ,
	@pagcd				VARCHAR(20) ,
	@pdpcd				VARCHAR(20) ,
	@puserid			VARCHAR(20) ,
	@psup_date			varchar(500) ,
	--@psup_date1       VARCHAR(20),
	@psup_ty			VARCHAR(20) ,
	@pdateformat		VARCHAR(20) ,
	@pextra1			VARCHAR(20) ,
	@pextra2			VARCHAR(20), --issue date
	@pper_copy_wt		numeric(15,3)
AS 
DECLARE  @vsup_date   DATETIME
DECLARE  @vh_date1    DATETIME
DECLARE  @vh_name1    VARCHAR(500)

DECLARE cur_holiday cursor  LOCAL FOR 
		select h_date,h_name from cir_holiday_mast
			where comp_code=@pcomp_code and unit=@punit_code and 
				h_publ=@ppubl_code and h_date=@vsup_date and 
				ISNULL(freeze_flag,'N')='N';

DECLARE @vedtn1			VARCHAR(500)
DECLARE @vedtn_name1    VARCHAR(500)

DECLARE	@v_spl_rate    NUMERIC(10,4)
SET @v_spl_rate = 0

   
/*************        DECLARE VARIABLES FOR cur_supply  CURSOR        *****************/

DECLARE  @vunit1				VARCHAR(500)
DECLARE  @vagcd1				VARCHAR(500)
DECLARE  @vdpcd1				VARCHAR(500)
DECLARE  @vpubl1				VARCHAR(500)
DECLARE  @vedtn11				VARCHAR(500)
DECLARE  @vsupply_type_code1	VARCHAR(500)
DECLARE  @vbase_supply1			numeric(7,0)
DECLARE  @vsupply_sun1			numeric(7,0)
DECLARE  @vsupply_mon1			numeric(7,0)
DECLARE  @vsupply_tue1			numeric(7,0)
DECLARE  @vsupply_wed1			numeric(7,0)
DECLARE  @vsupply_thu1			numeric(7,0)
DECLARE  @vsupply_fri1			numeric(7,0)
DECLARE  @vsupply_sat1			numeric(7,0)
DECLARE  @vsupply_spl11			numeric(7,0)
DECLARE  @vsupply_spl21			numeric(7,0)
DECLARE  @vag_type1				VARCHAR(500)
DECLARE  @vsupply_start_dt1		VARCHAR(500)
DECLARE  @vsuspend_date1		VARCHAR(500)
DECLARE  @vpacket_size1			VARCHAR(500)
DECLARE  @vcomm_code1			VARCHAR(500)
DECLARE  @vcomm_flag1			VARCHAR(500)
DECLARE  @vbill_agcd1			VARCHAR(500)
DECLARE  @vroute_code1			VARCHAR(500)
DECLARE  @vsubroute_code1		VARCHAR(500)
DECLARE  @vsub_subroute_code1	VARCHAR(500)
DECLARE  @vsurch_cd1			VARCHAR(500)
DECLARE  @vwaste_catg_code		VARCHAR(500)

DECLARE  @vbill_dpcd1			VARCHAR(500)
DECLARE @v_supply_copy_dt		varchar(20)
/*****************************************************************************************/

set @psup_date	=dbo.convert_user_date('/',@psup_date,@pdateformat)
set @pextra2	=dbo.convert_user_date('/',@pextra2,@pdateformat)

if @pextra1 is not null begin
	set @v_supply_copy_dt=dbo.convert_user_date('/',@pextra1,@pdateformat)
end


DECLARE cur_surcharge cursor LOCAL FOR 
            select * from cir_surcharge_mast 
            where comp_code  =@pcomp_code and 
                  unit       =@punit_code and
                  publ       =@ppubl_code and
                  edtn       =@vedtn1 and
                  surch_cd   =@vsurch_cd1 and 
                  valid_from = (select max(valid_from) from cir_surcharge_mast 
                                            where comp_code  =@pcomp_code and 
                                                  unit       =@punit_code and
                                                  publ       =@ppubl_code and
                                                  edtn       =@vedtn1 and
                                                  surch_cd   =@vsurch_cd1 and
                                                  valid_from<=@psup_date);
DECLARE	@v_sup_copy			NUMERIC(7)
DECLARE @v_edtn_rate		NUMERIC(10,4)
DECLARE @vreccnt			NUMERIC(5,0)
DECLARE @v_old_sup_copy		NUMERIC(7)

   
/*********************       SEND CONVERTED DATE FROM SQL CLASS     ************/
-- vsup_date:=to_date(psup_date,''''||pdateformat||'''');
SET  @vsup_date = @psup_date

/*******************************************************************************/

open cur_holiday;
fetch NEXT FROM cur_holiday into @vh_date1 , @vh_name1
close cur_holiday
    
if (@vsup_date=@vh_date1) BEGIN
	PRINT('Please Check The  Holiday Today Is  '+' '+   @vh_name1)
	PRINT('Please Check The  Holiday Today Is  '+' '+   @vh_name1)
end 
    
if ((@vsup_date<>@vh_date1) or @vh_date1 is null) BEGIN

	DECLARE cir_edtn_cur cursor LOCAL FOR 
          select distinct edtn,edtn_name from cir_edtn_mast 
			where comp_code=@pcomp_code and publ = @ppubl_code and
		     ((ISNULL(main_edtn,edtn) = @pedtn_code) or (@pedtn_code is null) or (@pedtn_code='')) and ISNULL(freeze_flag,'N')='N'
  
		open cir_edtn_cur
		fetch NEXT FROM cir_edtn_cur into @vedtn1 , @vedtn_name1
		WHILE @@FETCH_STATUS = 0 BEGIN
              
        delete from cir_dbksup where comp_code=@pcomp_code and unit_code=@punit_code and
			publ=@ppubl_code and edtn=@vedtn1 and supdate=@vsup_date and 
			(agcd=@pagcd or @pagcd is null OR @pagcd='') and (dpcd=@pdpcd or @pdpcd is null OR @pdpcd='')


		/*****************************************************************************************/     
					        
		DECLARE cur_spl_rate cursor LOCAL FOR
			select spl_day_rate from cir_special_rate_mast
			where comp_code=@pcomp_code and unit=@punit_code and
				publ=@ppubl_code and edtn=@vedtn1 and spl_day_date=@vsup_date;


		open cur_spl_rate
			fetch NEXT FROM cur_spl_rate into @v_spl_rate;
		close cur_spl_rate;
        
        deallocate cur_spl_rate
        
  		if (ISNULL(@v_spl_rate,0)=0 )BEGIN

			 DECLARE  @vsun_rate1   FLOAT
			 DECLARE  @vmon_rate1   FLOAT
			 DECLARE  @vtue_rate1   FLOAT
			 DECLARE  @vwed_rate1   FLOAT
			 DECLARE  @vthu_rate1   FLOAT
			 DECLARE  @vfri_rate1   FLOAT
			 DECLARE  @vsat_rate1   FLOAT
							 

			DECLARE cur_rate cursor LOCAL FOR 
				select sun_rate,mon_rate,tue_rate,wed_rate,thu_rate,fri_rate,sat_rate from cir_rate_mast
				where comp_code=@pcomp_code and unit=@punit_code and publ=@ppubl_code and edtn=@vedtn1 and
				valid_from=(select max(valid_from) from cir_rate_mast where comp_code=@pcomp_code and
				unit=@punit_code and publ=@ppubl_code and edtn=@vedtn1 and valid_from<=@vsup_date and 
				ISNULL(freeze_flag,'N')='N');
			
			open cur_rate;
			fetch NEXT FROM cur_rate into @vsun_rate1, @vmon_rate1, @vtue_rate1, @vwed_rate1, @vthu_rate1, @vfri_rate1, @vsat_rate1
			close cur_rate;
					
			deallocate  cur_rate;
                  
			DECLARE @SUP_DAY11    varchar(20)
			SET @SUP_DAY11 = CONVERT(VARCHAR(20) , DATENAME(WEEKDAY, @psup_date),20)

			if (@SUP_DAY11 = 'Sunday' )begin          
				set  @v_edtn_rate      =    @vsun_rate1 ;
            end

			else if (@SUP_DAY11 = 'Monday') begin
				set  @v_edtn_rate      =    @vmon_rate1;
			end
			else if (@SUP_DAY11 = 'Tuesday')begin 
				set  @v_edtn_rate      =    @vtue_rate1;
			end
			else if (@SUP_DAY11 = 'Wednesday') begin
				set  @v_edtn_rate      =    @vwed_rate1;
            end
			else if (@SUP_DAY11 = 'Thursday')begin
				set  @v_edtn_rate      =    @vthu_rate1;
			end
			else if (@SUP_DAY11 = 'Friday' )begin
				set  @v_edtn_rate      =    @vfri_rate1;
			end
			else if (@SUP_DAY11 = 'Saturday')begin
				set  @v_edtn_rate      =    @vsat_rate1;
			end
			else begin
				set @v_edtn_rate        =    0
			end 
		end
		else begin
			set @v_edtn_rate  =  @v_spl_rate;
		end 
		
		if (@v_edtn_rate=0)begin
			print('Please Check,The Rate Today Is not Define for '+' '+  @vedtn_name1)
		end 

		DECLARE  cur_supply cursor LOCAL FOR 
		select a.unit unit,a.agcd agcd,a.dpcd dpcd,a.publ publ,a.edtn edtn,a.supply_type_code supply_type_code,a.base_supply base_supply,a.supply_sun supply_sun,
		a.supply_mon supply_mon,a.supply_tue supply_tue,a.supply_wed supply_wed,
		a.supply_thu supply_thu,a.supply_fri supply_fri,a.supply_sat supply_sat,a.supply_spl1 supply_spl1,
		a.supply_spl2 supply_spl2, b.ag_type ag_type,b.supply_start_dt    supply_start_dt,b.suspend_date suspend_date, ISNULL(a.packet_size,0) packet_size,
		a.comm_code comm_code,a.comm_flag comm_flag,b.bill_agcd bill_agcd,b.bill_dpcd bill_dpcd,
		a.route_code route_code,a.subroute_code subroute_code,a.sub_subroute_code sub_subroute_code,
		a.surch_cd surch_cd,a.waste_catg_code waste_catg_code
		from cir_supply a,cir_agmast b
		where a.comp_code=b.comp_code and a.unit=b.unit and 
				  a.agcd=b.agcd and a.dpcd=b.dpcd and (a.agcd=@pagcd or @pagcd is null or @pagcd='') 
				  and (a.dpcd=@pdpcd or @pdpcd is null OR @pdpcd='') and 
				  a.unit=@punit_code and (a.publ=@ppubl_code) and
				  ISNULL(base_supply,0)>0 and
				  a.edtn=@vedtn1 and
				  ISNULL(a.supply_flag,'N')='Y' and ISNULL(b.suspend,'N')='N'
		order by a.agcd,a.dpcd,a.edtn,a.supply_type_code;


		 open cur_supply 

		 fetch next from cur_supply into @vunit1 ,@vagcd1 ,@vdpcd1 ,@vpubl1 ,@vedtn11 ,@vsupply_type_code1,@vbase_supply1,
		 @vsupply_sun1 ,@vsupply_mon1 ,@vsupply_tue1 ,@vsupply_wed1 ,@vsupply_thu1 ,@vsupply_fri1,@vsupply_sat1 ,@vsupply_spl11,
		 @vsupply_spl21, @vag_type1 ,@vsupply_start_dt1, @vsuspend_date1 ,@vpacket_size1 ,@vcomm_code1 ,@vcomm_flag1 ,@vbill_agcd1 ,@vbill_dpcd1,
		 @vroute_code1 ,@vsubroute_code1 ,@vsub_subroute_code1 ,@vsurch_cd1 ,@vwaste_catg_code
	       
         
		SET @vsup_date= CONVERT(VARCHAR(10),@vsup_date,10)
                 
		WHILE @@FETCH_STATUS = 0 begin
			
			DECLARE @SUP_DAY112    varchar(20)
 
            SET  @SUP_DAY112 = CONVERT(VARCHAR(20) , DATENAME(WEEKDAY, @vsup_date),20)
			
			if (@vsup_date>=@vsupply_start_dt1 or @vsupply_start_dt1 is null) and (@vsup_date<=@vsuspend_date1 or @vsuspend_date1 is null) begin 
				if (@psup_ty='R' and @SUP_DAY112 = 'Sunday' ) begin   
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_sun1,0)>0  begin
					
						set @v_sup_copy   =  ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_sun1,0);
													    
                    end
					else begin
						set @v_sup_copy   = 0;
					end 
				end
				else if (@psup_ty='R' and @SUP_DAY112 = 'Monday') begin    
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_mon1,0)>0 begin
					
						set @v_sup_copy    =     ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_mon1,0);
					
					end
					else begin
						set @v_sup_copy    = 0
					end
				end
				else if (@psup_ty='R' and @SUP_DAY112 = 'Tuesday')begin  
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_tue1,0)>0 begin
						set  @v_sup_copy  =  ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_tue1,0);
					end
					else begin
						set @v_sup_copy       = 0;
                    end 
				end
				else if (@psup_ty='R' and @SUP_DAY112 = 'Wednesday') begin   
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_wed1,0)>0 begin 
						
						set @v_sup_copy =  ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_wed1,0)
						
	                end
					else begin
						set @v_sup_copy  = 0
					end 
				end 
				else if (@psup_ty='R' and @SUP_DAY112 = 'Thursday')begin   
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_thu1,0)>0 begin
						set @v_sup_copy  = ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_thu1,0)
					end
                    else begin
						set @v_sup_copy  = 0
                    end 
				end   
				else if (@psup_ty='R' and @SUP_DAY112 = 'Friday' )begin   
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_fri1,0)>0 begin
				
						set @v_sup_copy   =  ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_fri1,0);
                
                    end                
					else
						set @v_sup_copy   = 0
                    end 
				else if (@psup_ty='R' and @SUP_DAY112 = 'Saturday') begin    
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_sat1,0)>0 begin
						set @v_sup_copy   =  ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_sat1,0);
                    end
					else begin
						set @v_sup_copy   = 0
					end
				end 
				else if @psup_ty='S1' begin    
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_spl11,0)>0 begin
						
						set @v_sup_copy   =     ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_spl11,0);
                                                              
					end
					else begin
						set @v_sup_copy   = 0
                                                               													end
					end 
				else if @psup_ty='S2' begin    
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_spl21,0)>0 begin
					
						set @v_sup_copy   =     ISNULL(@vbase_supply1,0)+ISNULL(@vsupply_spl21,0);
                    
                    end
                    else begin
						set @v_sup_copy   = 0
                    end 
				end

			--------change for supply copy--------
					           
            if @psup_ty='R' and @v_supply_copy_dt is not null begin
                set @v_old_sup_copy=0;
                select @v_old_sup_copy = sum(sup_copy) from cir_dbksup where comp_code=@pcomp_code and unit_code=@punit_code and publ=@ppubl_code and edtn=@vedtn11 and
                    agcd=@vagcd1 and dpcd=@vdpcd1 and supdate=@v_supply_copy_dt and sup_type_code=@vsupply_type_code1;
   
            end

            if isnull(@v_old_sup_copy,0)>0 begin
                set @v_sup_copy=@v_old_sup_copy;
            end
           
            --------change for supply copy--------
					            
			if ISNULL(@v_sup_copy,0)>0 Begin
				print('22tytr')
				print( @v_sup_copy)
				
				insert into cir_dbksup (comp_code,unit_code,publ,edtn,agcd,dpcd,supdate,sup_type_code,sup_copy,agency_ty_code,
										agency_pkt_size,comm_code,comm_fix_auto_spl,sup_rate,billagcd,billdpcd,
										route_code,subroute_code,subsubroute_code,userid,surch_cd,issue_date,per_copy_weight,waste_catg_code)
								values (@pcomp_code,@punit_code,@ppubl_code,@vedtn11,@vagcd1,@vdpcd1,@vsup_date,
									 @vsupply_type_code1,
									 @v_sup_copy,@vag_type1,@vpacket_size1,@vcomm_code1,@vcomm_flag1,
									 @v_edtn_rate,@vbill_agcd1,@vbill_dpcd1,@vroute_code1,
									 @vsubroute_code1,@vsub_subroute_code1,@puserid,@vsurch_cd1,@pextra2,@pper_copy_wt,@vwaste_catg_code);

				select @vreccnt	= count(*)  from cir_dbksup where comp_code=@pcomp_code and unit_code=@punit_code 
				and publ=@ppubl_code and edtn=@vedtn1 and supdate=@vsup_date and (agcd=@pagcd or @pagcd is null) and (dpcd=@pdpcd or @pdpcd is null);
					               
			End;                     
		end 
    

         fetch next from cur_supply into @vunit1 ,@vagcd1 ,@vdpcd1 ,@vpubl1 ,@vedtn11 ,@vsupply_type_code1,@vbase_supply1,
		 @vsupply_sun1 ,@vsupply_mon1 ,@vsupply_tue1 ,@vsupply_wed1 ,@vsupply_thu1 ,@vsupply_fri1,@vsupply_sat1 ,@vsupply_spl11,
		 @vsupply_spl21, @vag_type1 ,@vsupply_start_dt1, @vsuspend_date1 ,@vpacket_size1 ,@vcomm_code1 ,@vcomm_flag1 ,@vbill_agcd1 ,@vbill_dpcd1,
		 @vroute_code1 ,@vsubroute_code1 ,@vsub_subroute_code1 ,@vsurch_cd1,@vwaste_catg_code 

	end 
	close cur_supply;
	deallocate cur_supply
	   
	set @v_edtn_rate = 0;
	set @v_spl_rate  =0;
	set @vedtn1=NULL;

fetch NEXT FROM cir_edtn_cur into @vedtn1 , @vedtn_name1
end
close cir_edtn_cur
deallocate  cir_edtn_cur  
end 
  
    select case b.bill_pay
              when 'Y' then 'PAID'
              when 'N' then 'UNPAID'
              else  'UNPAID' 
              end  BILL_PAY,
   sum(a.sup_copy) SUP_COPY
    from cir_dbksup a,cir_supply_type_mast b,CIR_EDTN_MAST e
    where a.comp_code=@pcomp_code and a.comp_code=b.comp_code and a.comp_code=e.comp_code and  a.unit_code=@punit_code and 
          a.publ=@ppubl_code and a.publ = e.publ and a.edtn= e.edtn and 
          (ISNULL(e.main_edtn,e.edtn) = @pedtn_code or @pedtn_code is null OR  @pedtn_code='') and 
          a.sup_type_code=b.sup_ty_code and a.supdate=@vsup_date and 
          (a.agcd=@pagcd or @pagcd is null OR @pagcd='') and (a.dpcd=@pdpcd or @pdpcd is null or @pdpcd ='')
    group by b.bill_pay
    order by b.bill_pay desc
  
deallocate cur_holiday
deallocate cur_surcharge 


///////////////////////////////////end of procedures sent by laxman sir 23/04/2012//////////////////////////////

///////////////////////////////////Deepika sent by laxman sir 24/04/2012////////////////////////////////////////

                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE cir_unsold_credit_note_process
	  @pcomp_code 		as varchar(20),
	  @punit_code 		as varchar(20),
	  @prec_fromdate    as varchar(20),
	  @prec_todate 	    as varchar(20),
	  @pagtype_code     as varchar(20),
      @pagcd_code 		as varchar(20),
	  @pdpcd_code 		as varchar(20),
	  @puserid          as varchar(20),
      @pdateformat 	    as varchar(20),
	  @pextra1 			as varchar(20),
	  @pextra2 			as varchar(20)
AS 
	declare @v_frdt		datetime                                  
	declare @v_todt		datetime                          
	declare @v_doctype  varchar(5)                                 
	declare @v_tot_amt  numeric(15,2)                                  
	declare @v_count	numeric
	declare @v_dsign	numeric
	declare @v_recptdt  datetime
	declare @v_amt		numeric(15,2)                  

	set @v_doctype='UCN'
	set @v_tot_amt=0
	set @v_count = 0 
	set @v_frdt  = dbo.convert_user_date('/',@prec_fromdate,@pdateformat)
	set @v_todt  = dbo.convert_user_date('/', @prec_todate,@pdateformat)
	set @v_recptdt  = @v_todt

print(@v_frdt)
print(@v_todt)

		declare @v_recptno varchar(20)
		declare @v_remark varchar(200)
--		variable for cursor
		declare @v1_comp_code varchar(20)
		declare @v1_unit_code varchar(20)
		declare @v1_branch_code varchar(20)
		declare @v1_agcd varchar(20)
		declare @v1_dpcd varchar(20)
		declare @v1_unsold_copy		numeric(8)
		declare @v1_missing_copy	numeric(8)
		declare @v1_late_copy		numeric(8)
		declare @v1_short_copy		numeric(8)
		declare @v1_damage_copy		numeric(8)
		declare @v1_amount			numeric(15,2)
		declare @v_rcdt				varchar(10)		
		declare @v_rcdp				varchar(20)
		declare @v_ccdp				varchar(20)
		declare c1 cursor for
			select h.comp_code comp_code,h.unit_code unit_code,m.branch_code branch_code,h.agcd agcd,h.dpcd dpcd,sum(isnull(apr_unsold,0)) unsold_copy,sum(isnull(d.apr_bnr,0)) missing_copy , sum(isnull(apr_late_recpt,0)) late_copy,sum(isnull(d.apr_short_recpt,0)) short_copy,sum(isnull(d.apr_damage,0)) damage_copy,
            sum(((isnull(apr_unsold,0)+isnull(d.apr_bnr,0)+isnull(apr_late_recpt,0)+isnull(d.apr_short_recpt,0)+isnull(d.apr_damage,0))*isnull(copy_rate,0))-isnull(comm_amt,0)-isnull(waste_amt,0)) amount 
            from cir_unsold_hdr_dis h,cir_unsold_dtl_dis d,cir_agmast_dis m
            where h.comp_code=@pcomp_code and h.comp_code=d.comp_code and h.comp_code=m.comp_code and
            h.unit_code=@punit_code and h.unit_code=d.unit_code and h.unit_code=m.unit and h.doctype=@v_doctype and h.doctype=d.doctype and 
            (h.agcd=@pagcd_code or @pagcd_code is null) and (h.dpcd=@pdpcd_code or @pdpcd_code is null) and 
            h.agcd=d.agcd and h.dpcd=d.dpcd and h.agcd=m.agcd and h.dpcd=m.dpcd and (m.ag_type=@pagtype_code or @pagtype_code is null or @pagtype_code ='') and
            h.app_dt between @v_frdt and @v_todt and h.app_userid is not null and h.process_crno is null and 
            (isnull(apr_unsold,0)+isnull(d.apr_bnr,0)+isnull(apr_late_recpt,0)+isnull(d.apr_short_recpt,0)+isnull(d.apr_damage,0))>0 and upper(isnull(@pextra2,'/'))='D'
            group by h.comp_code,h.unit_code,m.branch_code,h.agcd,h.dpcd
			union
			select h.comp_code comp_code,h.unit_code unit_code,m.branch_code branch_code,h.agcd agcd,h.dpcd dpcd,sum(isnull(apr_unsold,0)) unsold_copy,sum(isnull(d.apr_bnr,0)) missing_copy , sum(isnull(apr_late_recpt,0)) late_copy,sum(isnull(d.apr_short_recpt,0)) short_copy,sum(isnull(d.apr_damage,0)) damage_copy,
						sum(((isnull(apr_unsold,0)+isnull(d.apr_bnr,0)+isnull(apr_late_recpt,0)+isnull(d.apr_short_recpt,0)+isnull(d.apr_damage,0))*isnull(copy_rate,0))-isnull(comm_amt,0)-isnull(waste_amt,0)) amount 
						from cir_unsold_hdr h,cir_unsold_dtl d,cir_agmast m
						where h.comp_code=@pcomp_code and h.comp_code=d.comp_code and h.comp_code=m.comp_code and
						h.unit_code=@punit_code and h.unit_code=d.unit_code and h.unit_code=m.unit and h.doctype=@v_doctype and h.doctype=d.doctype and 
						(h.agcd=@pagcd_code or @pagcd_code is null) and (h.dpcd=@pdpcd_code or @pdpcd_code is null) and 
						h.agcd=d.agcd and h.dpcd=d.dpcd and h.agcd=m.agcd and h.dpcd=m.dpcd and (m.ag_type=@pagtype_code or @pagtype_code is null or @pagtype_code ='') and
						h.app_dt between @v_frdt and @v_todt and h.app_userid is not null and h.process_crno is null and 
						(isnull(apr_unsold,0)+isnull(d.apr_bnr,0)+isnull(apr_late_recpt,0)+isnull(d.apr_short_recpt,0)+isnull(d.apr_damage,0))>0 and upper(isnull(@pextra2,'/'))!='D'
						group by h.comp_code,h.unit_code,m.branch_code,h.agcd,h.dpcd
						order by comp_code,unit_code,branch_code,agcd,dpcd
		open c1
		fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit_code,@v1_branch_code,@v1_agcd,@v1_dpcd,@v1_unsold_copy,@v1_missing_copy,@v1_late_copy,@v1_short_copy,@v1_damage_copy,@v1_amount
			print(@@FETCH_STATUS)
		WHILE (@@FETCH_STATUS = 0) BEGIN
			print(@v1_agcd)print(@v1_dpcd)print(@v1_amount)
				
			if(@@FETCH_STATUS=-1)
				break;
				select @v_dsign=Dsign from cir_docmst where Comp_code=@pcomp_code AND doc_type=@v_doctype;

				set @v_amt=@v1_amount*@v_dsign;
		            
				select distinct @v_rcdp=dr_cdp,@v_ccdp=cr_cdp from FA_FIN_LINK_MAST where comp_code=@v1_comp_code and unit_code=@v1_unit_code and 
					branch_code=@v1_branch_code and modual_alias='CCOL' and doctype=@v_doctype and getdate() BETWEEN ISNULL(EFF_FR_DATE,GETDATE()) AND ISNULL(EFF_TO_DATE,GETDATE())
					
				set @v_remark='Being amount credited against unsold return';
					
				if isnull(@v1_unsold_copy,0)>0 begin
					set @v_remark=@v_remark+' Unsold Copy:- '+ cast(@v1_unsold_copy as varchar);
				end
					
				if isnull(@v1_missing_copy,0)>0 begin
					set @v_remark=@v_remark+' Missing Copy:- '+cast(@v1_missing_copy as varchar);
				end
					
				if isnull(@v1_late_copy,0)>0 begin
					set @v_remark=@v_remark+' Late Copy:- '+cast(@v1_late_copy as varchar);
				end
					
				if isnull(@v1_short_copy,0)>0 begin
					set @v_remark=@v_remark+' Short Copy:- '+cast(@v1_short_copy as varchar);
				end
				
				if isnull(@v1_damage_copy,0)>0 begin
					set @v_remark=@v_remark+' Damage Copy:- '+cast(@v1_damage_copy as varchar);
				end
				print('3')print(@v_remark)
				--set @v_rcdt='10/29/2010'
				
				set @v_rcdt= case @pdateformat when 'mm/dd/yyyy' then convert(varchar(10), @v_recptdt,101)
											   when 'dd/mm/yyyy' then convert(varchar(10), @v_recptdt,103)			
											   when 'yyyy/mm/dd' then convert(varchar(10), @v_recptdt,111) end
				print('4')print(@v_rcdt)print(@v1_comp_code)print(@v1_branch_code)print(@v_doctype)


				if upper(@pextra2)='D' begin
	                select @v_recptno = CONVERT(NUMERIC(8, 2), MAX(SUBSTRING(recptno, 5, 8))) + 1 from cir_rcphdr_dis 
		            where comp_code=@v1_comp_code  and doctype=@v_doctype AND  
		            replace(substring(CONVERT(VARCHAR(10), recptdt,2),1,5),'.','') = replace(substring(CONVERT(VARCHAR(10), @v_recptdt,2),1,5),'.','') and 
                    branch_code=@v1_branch_code
				end

				else begin
					select @v_recptno = CONVERT(NUMERIC(8, 2), MAX(SUBSTRING(recptno, 5, 8))) + 1 from cir_rcphdr 
					where comp_code=@v1_comp_code  and doctype=@v_doctype AND 
					replace(substring(CONVERT(VARCHAR(10), recptdt,2),1,5),'.','') = replace(substring(CONVERT(VARCHAR(10), @v_recptdt,2),1,5),'.','') and 
					branch_code=@v1_branch_code             
				end
					print('5')print(@v_recptno)
					
					If isnull(@v_recptno,0)=0 Begin
					  set @v_recptno=@v1_branch_code+'-'+replace(substring(CONVERT(VARCHAR(10), @v_recptdt,2),1,5),'.','')+'0001'
					End  
					Else Begin
					  set @v_recptno=@v1_branch_code+'-'+RIGHT ('00000000'+ CAST (@v_recptno AS varchar), 8)
					End
					
					--set @v_recptno=dbo.Cir_Genrate_Id_receipt_cndn_id_p (@pcomp_code,@v_doctype,@punit_code,@v_rcdt,@pdateformat,@pextra1,@pextra2)
					if upper(@pextra2)='D' begin
						if @v_recptno is not null and isnull(@v_amt,0)<>0 begin

						insert into cir_rcphdr_dis(comp_code,unit_code,agcd,dpcd,doctype,
									 recptno,recptdt,amount,reason,remark,
									 achd,voucherno,voucherdt,userid,creation_datetime,branch_code,CCDP,RCDP)
								values(@v1_comp_code, @v1_unit_code,@v1_agcd, @v1_dpcd,@v_doctype,
									 @v_recptno,@v_recptdt,@v_amt,'UNSOLD CREDIT NOTE',@v_remark,
									 'NM',@v_recptno,@v_recptdt,@puserid,getdate(),@v1_branch_code,@v_CCDP,@v_RCDP);
						insert into cir_rcpdet_dis(comp_code,unit_code,agcd,dpcd,doctyp,
									 recptno,recptdt,payfor,achd,amount,
									 reason,remark,voucherno,voucherdt,usrid,
									 creation_datetime,branch_code)
							  values(@v1_comp_code, @v1_unit_code,@v1_agcd, @v1_dpcd,@v_doctype,
									 @v_recptno,@v_recptdt,@v1_branch_code,'NM',@v_amt,
									 'UNSOLD CREDIT NOTE',@v_remark,@v_recptno,@v_recptdt,@puserid,
									 getdate(),@v1_branch_code);
						insert into cir_outmast_dis(comp_code,unit_code,agcd,dpcd,doctyp,
									  recptno,recptdt,achd,amount,reason,
									  remark,voucherno,voucherdt,usrid,creation_datetime,branch_code)
							   values(@v1_comp_code, @v1_unit_code,@v1_agcd, @v1_dpcd,@v_doctype,
									  @v_recptno,@v_recptdt,'NM',@v_amt,'UNSOLD CREDIT NOTE',
									  @v_remark,@v_recptno,@v_recptdt,@puserid,getdate(),@v1_branch_code);
						
						set @v_count     =isnull(@v_count,0)+1;
						set @v_tot_amt   =isnull(@v_tot_amt,0)+isnull(@v1_amount,0);
						
						update cir_unsold_hdr_dis set process_crno=@v_recptno,process_crdt=@v_recptdt
							where comp_code=@v1_comp_code and unit_code=@v1_unit_code and doctype=@v_doctype and 
							recptdt between @v_frdt and @v_todt and app_userid is not null and agcd=@v1_agcd and dpcd=@v1_dpcd and 
							process_crno is null and process_crdt is null;
	            
						update cir_unsold_dtl_dis set process_crno=@v_recptno,process_crdt=@v_recptdt
							where comp_code=@v1_comp_code and unit_code=@v1_unit_code and doctype=@v_doctype and 
							recptdt between @v_frdt and @v_todt and agcd=@v1_agcd and dpcd=@v1_dpcd and 
							process_crno is null and process_crdt is null and recptno in(select distinct recptno from cir_unsold_hdr 
							where comp_code=@v1_comp_code and unit_code=@v1_unit_code and doctype=@v_doctype and 
							recptdt between @v_frdt and @v_todt and app_userid is not null and agcd=@v1_agcd and dpcd=@v1_dpcd and 
							process_crno is null and process_crdt is null);               
					end
				end
				else begin
					if @v_recptno is not null and isnull(@v_amt,0)<>0 begin

						insert into cir_rcphdr(comp_code,unit_code,agcd,dpcd,doctype,
									 recptno,recptdt,amount,reason,remark,
									 achd,voucherno,voucherdt,userid,creation_date,branch_code,CCDP,RCDP)
								values(@v1_comp_code, @v1_unit_code,@v1_agcd, @v1_dpcd,@v_doctype,
									 @v_recptno,@v_recptdt,@v_amt,'UNSOLD CREDIT NOTE',@v_remark,
									 'NM',@v_recptno,@v_recptdt,@puserid,getdate(),@v1_branch_code,@v_CCDP,@v_RCDP);
						insert into cir_rcpdet(comp_code,unit_code,agcd,dpcd,doctyp,
									 recptno,recptdt,payfor,achd,amount,
									 reason,remark,voucherno,voucherdt,usrid,
									 creation_date,branch_code)
							  values(@v1_comp_code, @v1_unit_code,@v1_agcd, @v1_dpcd,@v_doctype,
									 @v_recptno,@v_recptdt,@v1_branch_code,'NM',@v_amt,
									 'UNSOLD CREDIT NOTE',@v_remark,@v_recptno,@v_recptdt,@puserid,
									 getdate(),@v1_branch_code);
						insert into cir_outmast(comp_code,unit_code,agcd,dpcd,doctyp,
									  recptno,recptdt,achd,amount,reason,
									  remark,voucherno,voucherdt,usrid,creation_date,branch_code)
							   values(@v1_comp_code, @v1_unit_code,@v1_agcd, @v1_dpcd,@v_doctype,
									  @v_recptno,@v_recptdt,'NM',@v_amt,'UNSOLD CREDIT NOTE',
									  @v_remark,@v_recptno,@v_recptdt,@puserid,getdate(),@v1_branch_code);
						set @v_count     =isnull(@v_count,0)+1;
						set @v_tot_amt   =isnull(@v_tot_amt,0)+isnull(@v1_amount,0);
						update cir_unsold_hdr set process_crno=@v_recptno,process_crdt=@v_recptdt
							where comp_code=@v1_comp_code and unit_code=@v1_unit_code and doctype=@v_doctype and 
							recptdt between @v_frdt and @v_todt and app_userid is not null and agcd=@v1_agcd and dpcd=@v1_dpcd and 
							process_crno is null and process_crdt is null;
	            
						update cir_unsold_dtl set process_crno=@v_recptno,process_crdt=@v_recptdt
							where comp_code=@v1_comp_code and unit_code=@v1_unit_code and doctype=@v_doctype and 
							recptdt between @v_frdt and @v_todt and agcd=@v1_agcd and dpcd=@v1_dpcd and 
							process_crno is null and process_crdt is null and recptno in(select distinct recptno from cir_unsold_hdr 
							where comp_code=@v1_comp_code and unit_code=@v1_unit_code and doctype=@v_doctype and 
							recptdt between @v_frdt and @v_todt and app_userid is not null and agcd=@v1_agcd and dpcd=@v1_dpcd and 
							process_crno is null and process_crdt is null);               
					end
				end

			fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit_code,@v1_branch_code,@v1_agcd,@v1_dpcd,@v1_unsold_copy,@v1_missing_copy,@v1_late_copy,@v1_short_copy,@v1_damage_copy,@v1_amount
			end
		close c1
		deallocate c1

        select @v_count as "TOTAL_CREDIT_NOTE",@v_tot_amt as "TOTAL_CREDIT_NOTE_AMOUNT"

///////////////////////////////////////////////////////end ////////////////////////////////////////////////////////////


///////////////////////////////////////////add by Deepika 24/04/2012///////////////////////////////////

                                                                                                                                                                                                                                                     
ALTER FUNCTION [dbo].[cir_get_waste_rate_catg]
(@pcomp_code		VARCHAR(20) ,
 @punit_code        VARCHAR(20) ,
 @pedtn_code        VARCHAR(20) ,
 @psup_date         DATETIME  ,
 @pdateformat       VARCHAR(20),
 @pwaste_catg		VARCHAR(20),
 @pextra1			VARCHAR(200),
 @pextra2			VARCHAR(200))
RETURNS  NUMERIC(10,4) 
AS 

BEGIN
	If @pwaste_catg='' Begin
		set @pwaste_catg = null
	End
	
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
			publ  = @v_publ AND	edtn  = @pedtn_code AND	valid_from  <= @psup_date
			and ISNULL(waste_catg_code,0)=ISNULL(@pwaste_catg,ISNULL(waste_catg_code,0)))
            and ISNULL(waste_catg_code,0)=ISNULL(@pwaste_catg,ISNULL(waste_catg_code,0))			

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

////////////////////////////////////////////////////////end/////////////////////////////////////////////////////

////////////////////issue number 7322//////////////////////
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[cir_comm_category]
(
@comp_code as varchar(50)


)

as
select CATG_CODE as COMM_CATG_CODE, CATEG_DESC as COMM_CATG_DESC from CIR_WASTE_CATG_MAST  where STATUS ='N'

--select * from CIR_WASTE_CATG_MAST


///////////////////////////////////
/////////////////////////////////////issue number 7104
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER PROCEDURE [dbo].[cir_agency_bind_cir_branch_billagency_p]
	@pcompcode				VARCHAR(20) ,
	@punit                  VARCHAR(20) ,
	@pbranchcode            VARCHAR(20) ,
	@pdateformat            VARCHAR(20) ,
	@pextra1                VARCHAR(400) ,
	@pextra2                VARCHAR(400),
	@pdistcode				VARCHAR(10)
AS 
	If upper(@pextra2)='D' Begin
            select cir_agmast_dis.* ,dbo.cir_get_city(cir_agmast_dis.comp_code,cir_agmast_dis.city_code) "CITY_NAME" from cir_agmast_dis
              where comp_code = @pcompcode and unit = @punit and
                        (branch_code=@pbranchcode or @pbranchcode is null or @pbranchcode='') and (dist_code =@pdistcode or @pdistcode is null) and
                        ((upper(ag_name) like upper(@pextra1+'%')) or (@pextra1 is null) or (@pextra1='')) and
                  isnull(freeze_flag,'N')='N'
            union
           select cir_agmast_dis.* ,dbo.cir_get_city(cir_agmast_dis.comp_code,cir_agmast_dis.city_code) "CITY_NAME" from cir_agmast_dis
              where comp_code = @pcompcode and
                        unit = @punit and
                      (branch_code=@pbranchcode or @pbranchcode is null or @pbranchcode='') and (dist_code =@pdistcode or @pdistcode is null) and
                       ((upper(agcd) like upper(@pextra1+'%')) or (@pextra1 is null) or (@pextra1='')) and
                 isnull(freeze_flag,'N')='N'      
            order by 5
      End     
       Else Begin
           select cir_agmast.* ,dbo.cir_get_city(cir_agmast.comp_code,cir_agmast.city_code) "CITY_NAME" from cir_agmast
            where comp_code = @pcompcode and
                       unit = @punit and
                       (branch_code=@pbranchcode or @pbranchcode is null or @pbranchcode='') and (dist_code =@pdistcode or @pdistcode is null) and
                     ((upper(ag_name) like upper(@pextra1+'%')) or (@pextra1 is null) or (@pextra1='')) and
                isnull(freeze_flag,'N')='N'
          union
          select cir_agmast.* ,dbo.cir_get_city(cir_agmast.comp_code,cir_agmast.city_code) "CITY_NAME" from cir_agmast
            where comp_code = @pcompcode and
                       unit = @punit and
                       (branch_code=@pbranchcode or @pbranchcode is null or @pbranchcode='') and (dist_code =@pdistcode or @pdistcode is null OR  @pdistcode='') and
                       ((upper(agcd) like upper(@pextra1+'%')) or (@pextra1 is null) or (@pextra1='')) and
                 isnull(freeze_flag,'N')='N'      
           order by 5
       End
/////////////////////////////////////////////////////////////////////
*********************************** ISSUE 6362 *************************
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER  PROCEDURE [dbo].[cir_user_bind_for_bl_unblk] (
   @pcomp_code          VARCHAR(50),
   @punit_code          VARCHAR(50),
   @pextra1             VARCHAR(50),
   @pextra2             VARCHAR(50),
   @pextra3             VARCHAR(50),
   @pextra4             VARCHAR(50),
   @pextra5             VARCHAR(50)


)
AS
BEGIN
  SELECT "username" AS USERNAME, "userid" AS USERID
    FROM login
   WHERE com_code = @pcomp_code
     AND "userid" IN (
            SELECT DISTINCT userid
                       FROM cir_suspend_tran
                      WHERE comp_code = @pcomp_code
                        AND ((unit = @punit_code) OR (@punit_code IS NULL) OR (@punit_code = '')));
END;



********************** END OF ISSUE 6362****************************



////////////////////////////////////add by deepika for issue no. 7313 27/04/2012////////////////////////////////
USE [abhi]
GO
/****** Object:  StoredProcedure [dbo].[cir_rep_challan_cir_rep_route_challan]    Script Date: 04/26/2012 14:29:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[cir_rep_challan_cir_rep_route_challan]
	@pcompcode			VARCHAR(20) ,
	@punitcode          VARCHAR(20) ,
	@ppublcode          VARCHAR(20) ,
	@proutemode         VARCHAR(20) ,
	@proutetype         VARCHAR(20) ,---1 for route,2 for subroute & 3 for sub subroute	
	@proutecode         VARCHAR(20) ,
	@psupdate           DATETIME ,
	@pchallan_type      VARCHAR(20) ,---1 for bundle and 2 for supply	
	@plangtype          VARCHAR(20) ,---1 for enlish and 2 for other language	
	@pdateformat        VARCHAR(20) ,
	@pextra1            VARCHAR(200),
	@pextra2            VARCHAR(200) 
AS 

	DECLARE @vsupdate			DATETIME 
	DECLARE @vsupdate1			VARCHAR(20)
	DECLARE @vcomp_code1        VARCHAR(8)
	DECLARE @vpubl1             VARCHAR(3)
	DECLARE @vpubl_seqno1       numeric(3,0)
	DECLARE @vpubl_name1        VARCHAR(50)
	

	DECLARE cur_edtn cursor FOR 
	select distinct x.comp_code comp_code,x.publ publ,x.publ_seqno publ_seqno,x.publ_name publ_name
    from(select distinct p.comp_code,p.publ,p.publ_seqno,
    case when @plangtype='1' then substring(p.publ_name,1,15) else substring(p.publ_name_oth_lang,1,25) end publ_name 
    from cir_publ_mast p,cir_lblmast l ,cir_route_mast r
    where p.comp_code=l.comp_code and p.comp_code=@pcompcode and p.comp_code =r.comp_code and p.publ=l.publ and
    l.unit_code = r.unit and l.unit_code = @punitcode and (p.publ = isnull(@ppublcode,p.publ) or @ppublcode ='') and l.lbl_dt   = @psupdate and --'12/01/2011' and 
    l.route1 =r.route_code and (r.route_code = isnull(@proutecode,r.route_code) or @proutecode='') and (r.route_mode = isnull(@proutemode,r.route_mode) or @proutemode='')  and 
    @proutetype='1' 
    union
    select distinct p.comp_code,p.publ,p.publ_seqno,
    case when @plangtype='1' then substring(p.publ_name,1,15) else substring(p.publ_name_oth_lang,1,25) end publ_name 
    from cir_publ_mast p,cir_lblmast l ,cir_sub_route_mast r
    where p.comp_code=l.comp_code and p.comp_code=@pcompcode and p.comp_code =r.comp_code and p.publ=l.publ and
    l.unit_code = r.unit and l.unit_code = @punitcode and (p.publ = isnull(@ppublcode,p.publ)  or @ppublcode ='') and l.lbl_dt = @psupdate and 
    r.route_code=l.route1 and r.subrt_code=l.subrt and (CAST(r.route_code AS VARCHAR) + CAST(r.subrt_code AS VARCHAR) = isnull(@proutecode,CAST(r.route_code AS VARCHAR) + CAST(r.subrt_code AS VARCHAR)) or @proutecode='') and 
    (r.subrt_mode = isnull(@proutemode,r.subrt_mode) or @proutemode='') and @proutetype='2'        
    union
    select distinct p.comp_code,p.publ,p.publ_seqno,
    case when @plangtype='1' then substring(p.publ_name,1,15) else substring(p.publ_name_oth_lang,1,25) end publ_name 
    from cir_publ_mast p,cir_lblmast l ,cir_sub_subroute_mast r
    where p.comp_code=l.comp_code and p.comp_code=@pcompcode and p.comp_code =r.comp_code and p.publ=l.publ and
    l.unit_code = r.unit and l.unit_code = @punitcode and (p.publ = isnull(@ppublcode,p.publ)  or @ppublcode ='') and l.lbl_dt = @psupdate and 
    r.route_code=l.route1 and r.subrt_code=l.subrt and r.sub_subrt_code=l.sub_subrt and
    (r.route_code+r.subrt_code+r.sub_subrt_code = isnull(@proutecode,r.route_code+r.subrt_code+r.sub_subrt_code) or @proutecode='') and 
    (r.sub_subrt_mode = isnull(@proutemode,r.sub_subrt_mode) or @proutemode='') and @proutetype='3') x
    order by publ_seqno,publ;
        
	DECLARE @vvar                                     VARCHAR(4000) 
	DECLARE @vvar_sum                                 VARCHAR(4000) 
	DECLARE @vvar_sum1                                VARCHAR(4000) 
	DECLARE @vvar_sum2                                VARCHAR(4000) 
	DECLARE @vquery                                   VARCHAR(8000) 
Begin
	If @punitcode=null Begin
		set @punitcode=''
	End	
	If @ppublcode=null Begin
		set @ppublcode=''
	End	
	If @proutemode=null Begin
		set @proutemode=''
	End	
	If @proutetype=null Begin
		set @proutetype=''
	End
	If @proutecode=null Begin
		set @proutecode=''
	End

		
	SET @vsupdate  =@psupdate-- dbo.convert_user_date('/', @psupdate,@pdateformat)
	print('@vsupdate')
	print(@vsupdate)
	set @vsupdate1 = convert(varchar(10),@vsupdate,101)
	
	print('hi')
	print('@vsupdate')
	print(@vsupdate1)		
		
	print('OPEN cur_edtn ')
	
		OPEN cur_edtn 
        fetch NEXT FROM cur_edtn INTO @vcomp_code1 ,@vpubl1 , @vpubl_seqno1 , @vpubl_name1

		WHILE (@@FETCH_STATUS = 0) BEGIN 

			IF @vvar is null or @vvar='' 
			BEGIN 
				IF @pchallan_type = '1' 
				BEGIN 			
					SET @vvar  = '(case publ when' + '''' +  @vpubl1 + '''' + 'then lbl_tno else 0 end)"' +  @vpubl_name1 + '"' 
					SET @vvar_sum  = 'sum('+'"'+@vpubl_name1 + '") "' +   @vpubl_name1 + '"' 
					SET @vvar_sum1  = 'sum('+'"'+@vpubl_name1 + '"' 
				END
				ELSE IF @pchallan_type = '2' 
				BEGIN 
					SET @vvar  = '(case publ when' + '''' +  @vpubl1 + '''' + ' then sum(supply_1) else 0 end)"' + @vpubl_name1 + '"' 
					SET @vvar_sum  = 'sum('+'"'+@vpubl_name1 + '") "' +   @vpubl_name1 + '"' 
					SET @vvar_sum1  = 'sum('+'"'+@vpubl_name1 + '"' 
				END
				ELSE 
				BEGIN
					SET @vvar        =' case when publ='+''''+@vpubl1+''''+' then lbl_tno else 0 end "'+'B#'+@vpubl_name1+'"'
					SET @vvar        =@vvar+','+' case when publ='+''''+@vpubl1+''''+' then sum(supply_1) else 0 end "'+'S#'+@vpubl_name1+'"'
					SET @vvar_sum    ='sum('+'"'+'B#'+@vpubl_name1+'") "'+'B#'+@vpubl_name1+'"'
					SET @vvar_sum    =@vvar_sum+','+'sum('+'"'+'S#'+@vpubl_name1+'") "'+'S#'+@vpubl_name1+'"'
					SET @vvar_sum1   ='sum('+'"'+'B#'+@vpubl_name1+'"'
					SET @vvar_sum2   ='sum('+'"'+'S#'+@vpubl_name1+'"'					
				END
				
			END
			ELSE 
			BEGIN 
				IF @pchallan_type = '1' BEGIN 
					SET @vvar  = @vvar + ',' + '(case publ when ' + '''' + @vpubl1 + '''' + 'then lbl_tno else 0 end)"' +   @vpubl_name1 + '"' 
					SET @vvar_sum  =@vvar_sum+','+ 'sum('+'"'+@vpubl_name1 + '") "' +   @vpubl_name1 + '"' 
					SET @vvar_sum1  = @vvar_sum1+','+'sum('+'"'+@vpubl_name1 + '"' 
				END
				ELSE IF @pchallan_type = '2' BEGIN 
					SET @vvar  = @vvar + ',' + '(case publ when' + '''' + @vpubl1 + '''' + 'then sum(supply_1) else 0 end)"' + @vpubl_name1 + '"' 
					SET @vvar_sum  = @vvar_sum+','+'sum('+'"'+@vpubl_name1 + '") "' +   @vpubl_name1 + '"' 
					SET @vvar_sum1  = @vvar_sum1+','+'sum('+'"'+@vpubl_name1 + '"' 
				END				
				ELSE 
				BEGIN 
					--SET @vvar		 =@vvar + ',' + '(case publ when' + '''' + @vpubl1 + '''' + 'then sum(supply_1) else 0 end)"' + @vpubl_name1 + '"' 
					SET @vvar        =@vvar+','+'case when publ='+''''+@vpubl1+''''+' then lbl_tno else 0 end "'+'B#'+@vpubl_name1+'"';
					SET @vvar        =@vvar+','+'case when publ='+''''+@vpubl1+''''+' then sum(supply_1) else 0 end "'+'S#'+@vpubl_name1+'"';
					SET @vvar_sum    =@vvar_sum+','+'sum('+'"'+'B#'+@vpubl_name1+'") "'+'B#'+@vpubl_name1+'"';
					SET @vvar_sum    =@vvar_sum+','+'sum('+'"'+'S#'+@vpubl_name1+'") "'+'S#'+@vpubl_name1+'"';
					SET @vvar_sum1   =@vvar_sum1+'+"'+'B#'+@vpubl_name1+'"';
					SET @vvar_sum2   =@vvar_sum2+'+"'+'S#'+@vpubl_name1+'"';					
				END
			END
   
		fetch NEXT FROM cur_edtn INTO @vcomp_code1 ,@vpubl1 , @vpubl_seqno1 , @vpubl_name1	
		END
		close cur_edtn
		print('close cur_edtn ')
		print(@vvar_sum)print(@vvar_sum1)
		
		if @pchallan_type =1 begin
			set @vvar_sum1=@vvar_sum1+') "TOTAL"';
		end
		else if @pchallan_type =2 begin
			set @vvar_sum1=@vvar_sum1+') "TOTAL"';
		end
		else
		begin
			set @vvar_sum1=@vvar_sum1+')"'+'B#TOTAL"';
			set @vvar_sum2=@vvar_sum2+')"'+'S#TOTAL"';
		end 
		
		print(@proutetype)print(@pchallan_type)
		
		print('*****')
		
		IF @proutetype = '1' BEGIN 
		print('prachi1')
				IF @vvar is null or @vvar='' 
				BEGIN 
						IF @pchallan_type = '1'
						BEGIN 
							print('1')
							SET @vquery  = 'select x.comp_code as "COMP_CODE",unit_code as "UNIT_CODE",route_code as "ROUTE_CODE",x.route_name as "ROUTE_NAME",x.route_oname as "ROUTE_ONAME",dbo.cir_get_route_seqno(x.comp_code,x.unit_code,x.route_code) as "ROUTE_SEQNO", x.agcd as "AGCD",x.dpcd as "DPCD",x.agency_name as "AGENCY_NAME",x.agency_oname as "AGENCY_ONAME",x.city_name as "CITY_NAME",x.city_oname as "CITY_ONAME",x.station_name as "STATION_NAME" ,station_oname as "STATION_ONAME",x.distname as "DISTNAME",x.distoname as "DISTONAME",x.print_seq as "PRINT_SEQ", 0 as "TOTAL_PACKET" from(select a.comp_code comp_code,unit_code unit_code,a.route1 route_code,a.rtnm route_name,a.rtonm route_oname, a.agcd agcd,a.dpcd dpcd,b.ag_name agency_name,b.ag_name_oth_lang agency_oname,a.city_name city_name,a.city_oname city_oname,a.station_name station_name,a.station_oname station_oname, max(a.lbl_print_no) print_seq,a.publ publ,a.edtn edtn,a.distname distname,a.distoname distoname from cir_lblmast a,cir_agmast b  where a.comp_code = b.comp_code and a.comp_code =' + '''' + @pcompcode + '''' + ' and a.unit_code = b.unit and a.unit_code =' + '''' + @punitcode + '''' + ' and (a.publ =' + '''' + @ppublcode + '''' + ' or' + '''' + @ppublcode + '''' + ' is null' + ' or ' +   '''' + @ppublcode + '''' +' = '''+ ''') and a.agcd = b.agcd and a.dpcd = b.dpcd  and a.lbl_dt =' + '''' + @vsupdate1 + '''' + ' and  a.route1 in (select route_code from cir_route_mast where comp_code =' + '''' + @pcompcode + '''' + ' and unit =' + '''' + @punitcode + '''' + ' and (route_code =' + '''' + @proutecode + '''' + ' or ' + '''' + @proutecode + '''' + ' is null' + ' or ' + '''' + @proutecode + '''' +' = '''+ ''') and (route_mode =' + '''' + @proutemode + '''' + ' or ' + '''' + @proutemode + '''' + ' is null'+ ' or ' + '''' + @proutemode + '''' +' = '''+ ''')) and isnull(a.supply_1,0)>0  group by a.comp_code,a.unit_code,a.route1,a.rtnm,a.rtonm,a.publ,a.edtn,a.lbl_tno,a.agcd,a.dpcd,b.ag_name,b.ag_name_oth_lang,a.city_name,a.city_oname,a.station_name,a.station_oname,a.distname,a.distoname,lbl_tno) x  group by x.comp_code,x.unit_code,x.route_code,x.route_oname,x.route_name,x.agcd,x.dpcd,x.print_seq,x.agency_name,x.agency_oname,x.city_name,x.city_oname,x.station_name,x.station_oname,x.distname,x.distoname order by route_seqno,route_name,print_seq,agency_name' 
						END
						ELSE 
						BEGIN 
							print('2')
							SET @vquery  = 'select x.comp_code as "COMP_CODE",unit_code as "UNIT_CODE",route_code as "ROUTE_CODE",x.route_name as "ROUTE_NAME",x.route_oname as "ROUTE_ONAME",dbo.cir_get_route_seqno(x.comp_code,x.unit_code,x.route_code) as "ROUTE_SEQNO", x.agcd as "AGCD",x.dpcd as "DPCD",x.agency_name as "AGENCY_NAME",x.agency_oname as "AGENCY_ONAME",x.city_name as "CITY_NAME",x.city_oname as "CITY_ONAME",x.station_name as "STATION_NAME" ,station_oname as "STATION_ONAME",x.distname as "DISTNAME",x.distoname as "DISTONAME",x.print_seq as "PRINT_SEQ", 0 as "TOTAL_PACKET" from(select a.comp_code comp_code,unit_code unit_code,a.route1 route_code,a.rtnm route_name,a.rtonm route_oname, a.agcd agcd,a.dpcd dpcd,b.ag_name agency_name,b.ag_name_oth_lang agency_oname,a.city_name city_name,a.city_oname city_oname,a.station_name station_name,a.station_oname station_oname, max(a.lbl_print_no) print_seq,a.publ publ,a.edtn edtn,a.distname distname,a.distoname distoname from cir_lblmast a,cir_agmast b  where a.comp_code = b.comp_code and a.comp_code =' + '''' + @pcompcode + '''' + ' and a.unit_code = b.unit and a.unit_code =' + '''' + @punitcode + '''' + ' and  (a.publ =' + '''' + @ppublcode + '''' + ' or' + '''' + @ppublcode + '''' + ' is null' + ' or ' +   '''' + @ppublcode + '''' +' = '''+ ''') and a.agcd = b.agcd and a.dpcd = b.dpcd  and a.lbl_dt =' + '''' + @vsupdate1 + '''' + ' and a.route1 in (select route_code from cir_route_mast where comp_code =' + '''' + @pcompcode + '''' + ' and unit =' + '''' + @punitcode + '''' + ' and (route_code =' + '''' + @proutecode + '''' + ' or ' + '''' + @proutecode + '''' + ' is null' + ' or ' + '''' + @proutecode + '''' +' = '''+ ''') and  (route_mode =' + '''' + @proutemode + '''' + ' or ' + '''' + @proutemode + '''' + ' is null'+ ' or ' + '''' + @proutemode + '''' +' = '''+ ''')) and isnull(a.supply_1,0)>0 group by a.comp_code,a.unit_code,a.route1,a.rtnm,a.rtonm,a.publ,a.edtn,a.agcd,a.dpcd,b.ag_name,b.ag_name_oth_lang,a.city_name,a.city_oname,a.station_name,a.station_oname,a.distname,a.distoname,lbl_tno) x group by x.comp_code,x.unit_code,x.route_code,x.route_oname,x.route_name,x.agcd,x.dpcd,x.print_seq,x.agency_name,x.agency_oname,x.city_name,x.city_oname,x.station_name,x.station_oname,x.distname,x.distoname order by route_seqno,route_name,print_seq,agency_name' 
						END
				END
				ELSE 
				BEGIN 
						IF @pchallan_type = '1'  -- for bundle
						BEGIN 
							print('3')
							SET @vquery  = 'select x.comp_code as "COMP_CODE",unit_code as "UNIT_CODE",route_code as "ROUTE_CODE",x.route_name as "ROUTE_NAME",x.route_oname as "ROUTE_ONAME",dbo.cir_get_route_seqno(x.comp_code,x.unit_code,x.route_code) as "ROUTE_SEQNO", x.agcd as "AGCD",x.dpcd as "DPCD",x.agency_name as "AGENCY_NAME",x.agency_oname as "AGENCY_ONAME",x.city_name as "CITY_NAME",x.city_oname as "CITY_ONAME",x.station_name as "STATION_NAME" ,station_oname as "STATION_ONAME",x.distname as "DISTNAME",x.distoname as "DISTONAME",x.print_seq as "PRINT_SEQ", 0 as "TOTAL_PACKET",' + @vvar_sum + ',' + @vvar_sum1 + ' from(select a.comp_code comp_code,unit_code unit_code,a.route1 route_code,a.rtnm route_name,a.rtonm route_oname,  a.agcd agcd,a.dpcd dpcd,b.ag_name agency_name,b.ag_name_oth_lang agency_oname,a.city_name city_name,a.city_oname city_oname,a.station_name station_name,a.station_oname station_oname,a.distname distname,a.distoname distoname,  max(a.lbl_print_no) print_seq,a.publ publ,a.edtn edtn,' + @vvar + ' from cir_lblmast a,cir_agmast b  where a.comp_code = b.comp_code and a.comp_code =' + '''' + @pcompcode + '''' + ' and a.unit_code = b.unit and a.unit_code =' + '''' + @punitcode + '''' + ' and  (a.publ =' + '''' + @ppublcode + '''' + ' or ' + '''' + @ppublcode + '''' + ' is null' + ' or ' +   '''' + @ppublcode + '''' +' = '''+ ''') and a.agcd = b.agcd and a.dpcd = b.dpcd  and a.lbl_dt =' + '''' + @vsupdate1 + '''' + ' and  a.route1 in (select route_code from cir_route_mast where comp_code =' + '''' + @pcompcode + '''' + ' and unit =' + '''' + @punitcode + '''' + ' and (route_code =' + '''' + @proutecode + '''' + ' or ' + '''' + @proutecode + '''' + ' is null' + ' or' + '''' + @proutecode + '''' +' = '''+ ''') and (route_mode =' + '''' + @proutemode + '''' + ' or ' + '''' + @proutemode + '''' + ' is null'+ ' or ' + '''' + @proutemode + '''' +' = '''+ ''')) and isnull(a.supply_1,0)>0 group by a.comp_code,a.unit_code,a.route1,a.rtnm,a.rtonm,a.publ,a.edtn,a.lbl_tno,a.agcd,a.dpcd,b.ag_name,b.ag_name_oth_lang,a.city_name,a.city_oname,a.station_name,a.station_oname,a.distname,a.distoname,lbl_tno) x group by x.comp_code,x.unit_code,x.route_code,x.route_oname,x.route_name,x.agcd,x.dpcd,x.print_seq,x.agency_name,x.agency_oname,x.city_name,x.city_oname,x.station_name,x.station_oname,x.distname,x.distoname  order by route_seqno,route_name,print_seq,agency_name' 
						END
						ELSE IF @pchallan_type = '2' -- for supply
						BEGIN 
							print('4')
							SET @vquery  = 'select x.comp_code as "COMP_CODE",unit_code as "UNIT_CODE",route_code as "ROUTE_CODE",x.route_name as "ROUTE_NAME",x.route_oname as "ROUTE_ONAME",dbo.cir_get_route_seqno(x.comp_code,x.unit_code,x.route_code) as "ROUTE_SEQNO", x.agcd as "AGCD",x.dpcd as "DPCD",x.agency_name as "AGENCY_NAME",x.agency_oname as "AGENCY_ONAME",x.city_name as "CITY_NAME",x.city_oname as "CITY_ONAME",x.station_name as "STATION_NAME" ,station_oname as "STATION_ONAME",x.distname as "DISTNAME",x.distoname as "DISTONAME",x.print_seq as "PRINT_SEQ", 0 as "TOTAL_PACKET",' + @vvar_sum + ',' + @vvar_sum1 + ' from(select a.comp_code comp_code,unit_code unit_code,a.route1 route_code,a.rtnm route_name,a.rtonm route_oname, a.agcd agcd,a.dpcd dpcd,b.ag_name agency_name,b.ag_name_oth_lang agency_oname,a.city_name city_name,a.city_oname city_oname,a.station_name station_name,a.station_oname station_oname,a.distname distname,a.distoname distoname, max(a.lbl_print_no) print_seq,a.publ publ,a.edtn edtn,' + @vvar + ' from cir_lblmast a,cir_agmast b   where a.comp_code = b.comp_code and a.comp_code =' + '''' + @pcompcode + '''' + ' and a.unit_code = b.unit and a.unit_code =' + '''' + @punitcode + '''' + ' and  (a.publ =' + '''' + @ppublcode + '''' + ' or ' + '''' + @ppublcode + '''' + ' is null' + ' or ' +   '''' + @ppublcode + '''' +' = '''+ ''') and a.agcd = b.agcd and a.dpcd = b.dpcd  and a.lbl_dt =' + '''' + @vsupdate1 + '''' + ' and a.route1 in (select route_code from cir_route_mast where comp_code =' + '''' + @pcompcode + '''' + ' and unit =' + '''' + @punitcode + '''' + ' and (route_code =' + '''' + @proutecode + '''' + ' or ' + '''' + @proutecode + '''' + ' is null' + ' or' + '''' + @proutecode + '''' +' = '''+ ''') and  (route_mode =' + '''' + @proutemode + '''' + ' or ' + '''' + @proutemode + '''' + ' is null'+ ' or ' + '''' + @proutemode + '''' +' = '''+ ''')) and isnull(a.supply_1,0)>0  group by a.comp_code,a.unit_code,a.route1,a.rtnm,a.rtonm,a.publ,a.edtn,a.agcd,a.dpcd,b.ag_name,b.ag_name_oth_lang,a.city_name,a.city_oname,a.station_name,a.station_oname,a.distname,a.distoname,lbl_tno) x group by x.comp_code,x.unit_code,x.route_code,x.route_oname,x.route_name,x.agcd,x.dpcd,x.print_seq,x.agency_name,x.agency_oname,x.city_name,x.city_oname,x.station_name,x.station_oname,x.distname,x.distoname order by route_seqno,route_name,print_seq,agency_name' 
						END
						ELSE -- for both
						BEGIN 
							SET @vquery  = 'select x.comp_code as "COMP_CODE",unit_code as "UNIT_CODE",route_code as "ROUTE_CODE",x.route_name as "ROUTE_NAME",x.route_oname as "ROUTE_ONAME",dbo.cir_get_route_seqno(x.comp_code,x.unit_code,x.route_code) as "ROUTE_SEQNO", x.agcd as "AGCD",x.dpcd as "DPCD",x.agency_name as "AGENCY_NAME",x.agency_oname as "AGENCY_ONAME",x.city_name as "CITY_NAME",x.city_oname as "CITY_ONAME",x.station_name as "STATION_NAME" ,station_oname as "STATION_ONAME",x.distname as "DISTNAME",x.distoname as "DISTONAME",x.print_seq as "PRINT_SEQ", 0 as "TOTAL_PACKET",' + @vvar_sum + ',' + @vvar_sum1 +',' + @vvar_sum2 + ' from(select a.comp_code comp_code,unit_code unit_code,a.route1 route_code,a.rtnm route_name,a.rtonm route_oname, a.agcd agcd,a.dpcd dpcd,b.ag_name agency_name,b.ag_name_oth_lang agency_oname,a.city_name city_name,a.city_oname city_oname,a.station_name station_name,a.station_oname station_oname,a.distname distname,a.distoname distoname, max(a.lbl_print_no) print_seq,a.publ publ,a.edtn edtn,' + @vvar + ' from cir_lblmast a,cir_agmast b   where a.comp_code = b.comp_code and a.comp_code =' + '''' + @pcompcode + '''' + ' and a.unit_code = b.unit and a.unit_code =' + '''' + @punitcode + '''' + ' and  (a.publ =' + '''' + @ppublcode + '''' + ' or ' + '''' + @ppublcode + '''' + ' is null' + ' or ' +   '''' + @ppublcode + '''' +' = '''+ ''') and a.agcd = b.agcd and a.dpcd = b.dpcd  and a.lbl_dt =' + '''' + @vsupdate1 + '''' + ' and a.route1 in (select route_code from cir_route_mast where comp_code =' + '''' + @pcompcode + '''' + ' and unit =' + '''' + @punitcode + '''' + ' and (route_code =' + '''' + @proutecode + '''' + ' or ' + '''' + @proutecode + '''' + ' is null' + ' or' + '''' + @proutecode + '''' +' = '''+ ''') and  (route_mode =' + '''' + @proutemode + '''' + ' or ' + '''' + @proutemode + '''' + ' is null'+ ' or ' + '''' + @proutemode + '''' +' = '''+ ''')) and isnull(a.supply_1,0)>0  group by a.comp_code,a.unit_code,a.route1,a.rtnm,a.rtonm,a.publ,a.edtn,a.agcd,a.dpcd,b.ag_name,b.ag_name_oth_lang,a.city_name,a.city_oname,a.station_name,a.station_oname,a.distname,a.distoname,lbl_tno) x group by x.comp_code,x.unit_code,x.route_code,x.route_oname,x.route_name,x.agcd,x.dpcd,x.print_seq,x.agency_name,x.agency_oname,x.city_name,x.city_oname,x.station_name,x.station_oname,x.distname,x.distoname order by route_seqno,route_name,print_seq,agency_name' 
						END
				END
		END
		IF @proutetype = '2' 
		BEGIN 
		
				IF @vvar is null or  @vvar =''
				BEGIN 
				
						IF @pchallan_type = '1' 
						BEGIN 
						
							print('5')
							SET @vquery  = 'select x.comp_code as "COMP_CODE",unit_code as "UNIT_CODE",route_code as "ROUTE_CODE",x.route_name as "ROUTE_NAME",x.route_oname as "ROUTE_ONAME",dbo.cir_get_route_seqno(x.comp_code,x.unit_code,x.route_code) as "ROUTE_SEQNO", x.subroute_code as "SUBROUTE_CODE",x.subroute_name as "SUBROUTE_NAME",subroute_oname as "SUBROUTE_ONAME",dbo.cir_get_subroute_seqno(x.comp_code,x.unit_code,x.route_code,x.subroute_code) as "SUBROUTE_SEQNO", x.agcd as "AGCD",x.dpcd as "DPCD",x.agency_name as "AGENCY_NAME",x.agency_oname as "AGENCY_ONAME",x.city_name as "CITY_NAME",x.city_oname as "CITY_ONAME",x.station_name as "STATION_NAME" ,station_oname as "STATION_ONAME",x.distname as "DISTNAME",x.distoname as "DISTONAME",x.print_seq as "PRINT_SEQ", 0 as "TOTAL_PACKET" from(select a.comp_code comp_code,unit_code unit_code,a.route1 route_code,a.rtnm route_name,a.rtonm route_oname,  a.subrt subroute_code,a.subrtnm subroute_name,a.subrtonm subroute_oname, a.agcd agcd,a.dpcd dpcd,b.ag_name agency_name,b.ag_name_oth_lang agency_oname,a.city_name city_name,a.city_oname city_oname,a.station_name station_name,a.station_oname station_oname, max(a.lbl_print_no) print_seq,a.publ publ,a.edtn edtn,a.distname distname,a.distoname distoname from cir_lblmast a,cir_agmast b where a.comp_code = b.comp_code and a.comp_code =' + '''' + @pcompcode + '''' + ' and a.unit_code = b.unit and a.unit_code =' + '''' + @punitcode + '''' + ' and (a.publ =' + '''' + @ppublcode + '''' + ' or ' + '''' + @ppublcode + '''' + ' is null' + ' or ' +   '''' + @ppublcode + '''' +' = '''+ ''') and a.agcd = b.agcd and a.dpcd = b.dpcd  and a.lbl_dt =' + '''' + @vsupdate1 + '''' + ' and  a.route1+a.subrt in (select route_code+subrt_code from cir_sub_route_mast where comp_code =' + '''' + @pcompcode + '''' + ' and unit =' + '''' + @punitcode + '''' + ' and (route_code+subrt_code =' + '''' + @proutecode + '''' + ' or ''' + '' + @proutecode + '''' + ' is null' + ' or ' + '' + @proutecode + '''' +''' = '''+ ''') and  (subrt_mode =' + '''' + @proutemode + '''' + ' or ' + '''' + @proutemode + '''' + ' is null'+ ' or ' + '''' + @proutemode + '''' +' = '''+ ''')) and isnull(a.supply_1,0)>0  group by a.comp_code,a.unit_code,a.route1,a.rtnm,a.rtonm,a.subrt,a.subrtnm,a.subrtonm,a.publ,a.edtn,a.lbl_tno,a.agcd,a.dpcd,b.ag_name,b.ag_name_oth_lang,a.city_name,a.city_oname,a.station_name,a.station_oname,a.distname,a.distoname) x group by x.comp_code,x.unit_code,x.route_code,x.route_oname,x.route_name,x.subroute_code,x.subroute_name,x.subroute_oname,x.agcd,x.dpcd,x.print_seq,x.agency_name,x.agency_oname,x.city_name,x.city_oname,x.station_name,x.station_oname,x.distname,x.distoname  order by route_seqno,route_name,subroute_seqno,subroute_name,print_seq,agency_name' 
						END
						ELSE 
						BEGIN 
							print('6')
							SET @vquery  = 'select x.comp_code as "COMP_CODE",unit_code as "UNIT_CODE",route_code as "ROUTE_CODE",x.route_name as "ROUTE_NAME",x.route_oname as "ROUTE_ONAME",dbo.cir_get_route_seqno(x.comp_code,x.unit_code,x.route_code) as "ROUTE_SEQNO", x.subroute_code as "SUBROUTE_CODE",x.subroute_name as "SUBROUTE_NAME",x.subroute_oname as "SUBROUTE_ONAME",dbo.cir_get_subroute_seqno(x.comp_code,x.unit_code,x.route_code,x.subroute_code) as "SUBROUTE_SEQNO",x.agcd as "AGCD",x.dpcd as "DPCD",x.agency_name as "AGENCY_NAME",x.agency_oname as "AGENCY_ONAME",x.city_name as "CITY_NAME",x.city_oname as "CITY_ONAME",x.station_name as "STATION_NAME" ,station_oname as "STATION_ONAME",x.distname as "DISTNAME",x.distoname as "DISTONAME",x.print_seq as "PRINT_SEQ", 0 as "TOTAL_PACKET"  from(select a.comp_code comp_code,unit_code unit_code,a.route1 route_code,a.rtnm route_name,a.rtonm route_oname, a.subrt subroute_code,a.subrtnm subroute_name,a.subrtonm subroute_oname,a.agcd agcd,a.dpcd dpcd,b.ag_name agency_name,b.ag_name_oth_lang agency_oname,a.city_name city_name,a.city_oname city_oname,a.station_name station_name,a.station_oname station_oname,  max(a.lbl_print_no) print_seq,a.publ publ,a.edtn edtn,a.distname distname,a.distoname distoname from cir_lblmast a,cir_agmast b  where a.comp_code = b.comp_code and a.comp_code =' + '''' + @pcompcode + '''' + ' and a.unit_code = b.unit and a.unit_code =' + '''' + @punitcode + '''' + ' and (a.publ =' + '''' + @ppublcode + '''' + ' or ' + '''' + @ppublcode + '''' + ' is null' + ' or ' +   '''' + @ppublcode + '''' +' = '''+ ''') and a.agcd = b.agcd and a.dpcd = b.dpcd  and a.lbl_dt =' + '''' + @vsupdate1 + '''' + ' and  a.route1+a.subrt in (select route_code+subrt_code from cir_sub_route_mast where comp_code =' + '''' + @pcompcode + '''' + ' and unit =' + '''' + @punitcode + '''' + ' and (route_code+subrt_code =' + '''' + @proutecode + '''' + ' or ''' + '' + @proutecode + '''' + ' is null' + ' or ' + '' + @proutecode + '''' +''' = '''+ ''') and  (subrt_mode =' + '''' + @proutemode + '''' + ' or ' + '''' + @proutemode + '''' + ' is null'+ ' or ' + '''' + @proutemode + '''' +' = '''+ ''')) and isnull(a.supply_1,0)>0 group by a.comp_code,a.unit_code,a.route1,a.rtnm,a.rtonm,a.subrt,a.subrtnm,a.subrtonm,a.publ,a.edtn,a.agcd,a.dpcd,b.ag_name,b.ag_name_oth_lang,a.city_name,a.city_oname,a.station_name,a.station_oname,a.distname,a.distoname) x group by x.comp_code,x.unit_code,x.route_code,x.route_oname,x.route_name,x.subroute_code,x.subroute_name,x.subroute_oname,x.agcd,x.dpcd,x.print_seq,x.agency_name,x.agency_oname,x.city_name,x.city_oname,x.station_name,x.station_oname,x.distname,x.distoname  order by route_seqno,route_name,subroute_seqno,subroute_name,print_seq,agency_name' 
						END
   				END
				ELSE 
				BEGIN 
				
						IF @pchallan_type = '1' 
						BEGIN 
						
							print('7')
							SET @vquery  = 'select x.comp_code as "COMP_CODE",unit_code as "UNIT_CODE",route_code as "ROUTE_CODE",x.route_name as "ROUTE_NAME",x.route_oname as "ROUTE_ONAME",dbo.cir_get_route_seqno(x.comp_code,x.unit_code,x.route_code) as "ROUTE_SEQNO", x.subroute_code  as "SUBROUTE_CODE",x.subroute_name as "SUBROUTE_NAME",x.subroute_oname as "SUBROUTE_ONAME",dbo.cir_get_subroute_seqno(x.comp_code,x.unit_code,x.route_code,x.subroute_code) as "SUBROUTE_SEQNO", x.agcd as "AGCD",x.dpcd as "DPCD",x.agency_name as "AGENCY_NAME",x.agency_oname as "AGENCY_ONAME",x.city_name as "CITY_NAME",x.city_oname as "CITY_ONAME",x.station_name as "STATION_NAME" ,station_oname as "STATION_ONAME",x.distname as "DISTNAME",x.distoname as "DISTONAME",x.print_seq as "PRINT_SEQ", 0 as "TOTAL_PACKET",' + @vvar_sum + ',' + @vvar_sum1 + ' from(select a.comp_code comp_code,unit_code unit_code,a.route1 route_code,a.rtnm route_name,a.rtonm route_oname, a.subrt subroute_code,a.subrtnm subroute_name,a.subrtonm subroute_oname,  a.agcd agcd,a.dpcd dpcd,b.ag_name agency_name,b.ag_name_oth_lang agency_oname,a.city_name city_name,a.city_oname city_oname,a.station_name station_name,a.station_oname station_oname,a.distname distname,a.distoname distoname,  max(a.lbl_print_no) print_seq,publ,' + @vvar + '  from cir_lblmast a,cir_agmast b where a.comp_code = b.comp_code and a.comp_code =' + '''' + @pcompcode + '''' + ' and a.unit_code = b.unit and a.unit_code =' + '''' + @punitcode + '''' + ' and  (a.publ =' + '''' + @ppublcode + '''' + ' or' + '''' + @ppublcode + '''' + ' is null' + ' or ' +   '''' + @ppublcode + '''' +' = '''+ ''') and a.agcd = b.agcd and a.dpcd = b.dpcd  and a.lbl_dt =' + '''' + @vsupdate1 + '''' + ' and  a.route1+a.subrt in (select route_code+subrt_code from cir_sub_route_mast where comp_code =' + '''' + @pcompcode + '''' + ' and unit =' + '''' + @punitcode + '''' + ' and (route_code+subrt_code =' + '''' + @proutecode + '''' + ' or' + '''' + @proutecode + '''' + ' is null' + ' or ' + '''' + @proutecode + '''' +' = '''+ ''') and  (subrt_mode =' + '''' + @proutemode + '''' + ' or' + '''' + @proutemode + '''' + ' is null'+ ' or ' + '''' + @proutemode + '''' +' = '''+ ''')) and isnull(a.supply_1,0)>0  group by a.comp_code,a.unit_code,a.route1,a.rtnm,a.rtonm,a.subrt,a.subrtnm,a.subrtonm,a.publ,a.edtn,a.lbl_tno,a.agcd,a.dpcd,b.ag_name,b.ag_name_oth_lang,a.city_name,a.city_oname,a.station_name,a.station_oname,a.distname,a.distoname) x group by x.comp_code,x.unit_code,x.route_code,x.route_oname,x.route_name,x.subroute_code,x.subroute_name,x.subroute_oname,x.agcd,x.dpcd,x.print_seq,x.agency_name,x.agency_oname,x.city_name,x.city_oname,x.station_name,x.station_oname,x.distname,x.distoname order by route_seqno,route_name,subroute_seqno,subroute_name,print_seq,agency_name' 
						END
						ELSE IF @pchallan_type = '2' 
						BEGIN
						
							print('8')
							SET @vquery  = 'select x.comp_code as "COMP_CODE",unit_code as "UNIT_CODE",route_code as "ROUTE_CODE",x.route_name as "ROUTE_NAME",x.route_oname as "ROUTE_ONAME",dbo.cir_get_route_seqno(x.comp_code,x.unit_code,x.route_code) as "ROUTE_SEQNO", x.subroute_code  as "SUBROUTE_CODE",x.subroute_name as "SUBROUTE_NAME",x.subroute_oname as "SUBROUTE_ONAME",dbo.cir_get_subroute_seqno(x.comp_code,x.unit_code,x.route_code,x.subroute_code) as "SUBROUTE_SEQNO", x.agcd as "AGCD",x.dpcd as "DPCD",x.agency_name as "AGENCY_NAME",x.agency_oname as "AGENCY_ONAME",x.city_name as "CITY_NAME",x.city_oname as "CITY_ONAME",x.station_name as "STATION_NAME" ,station_oname as "STATION_ONAME",x.distname as "DISTNAME",x.distoname as "DISTONAME",x.print_seq as "PRINT_SEQ", 0 as "TOTAL_PACKET",' + @vvar_sum + ',' + @vvar_sum1 + ' from(select a.comp_code comp_code,unit_code unit_code,a.route1 route_code,a.rtnm route_name,a.rtonm route_oname, a.subrt subroute_code,a.subrtnm subroute_name,a.subrtonm subroute_oname,  a.agcd agcd,a.dpcd dpcd,b.ag_name agency_name,b.ag_name_oth_lang agency_oname,a.city_name city_name,a.city_oname city_oname,a.station_name station_name,a.station_oname station_oname,a.distname distname,a.distoname distoname, max(a.lbl_print_no) print_seq,publ,' + @vvar + '  from cir_lblmast a,cir_agmast b where a.comp_code = b.comp_code and a.comp_code =' + '''' + @pcompcode + '''' + ' and a.unit_code = b.unit and a.unit_code =' + '''' + @punitcode + '''' + ' and (a.publ =' + '''' + @ppublcode + '''' + ' or' + '''' + @ppublcode + '''' + ' is null' + ' or ' +   '''' + @ppublcode + '''' +' = '''+ ''') and a.agcd = b.agcd and a.dpcd = b.dpcd  and a.lbl_dt =' + '''' + @vsupdate1 + '''' + ' and a.route1+a.subrt in (select route_code+subrt_code from cir_sub_route_mast where comp_code =' + '''' + @pcompcode + '''' + ' and unit =' + '''' + @punitcode + '''' + ' and (route_code+subrt_code =' + '''' + @proutecode + '''' + ' or' + '''' + @proutecode + '''' + ' is null' + ' or ' + '''' + @proutecode + '''' +' = '''+ ''') and  (subrt_mode =' + '''' + @proutemode + '''' + ' or' + '''' + @proutemode + '''' + ' is null'+ ' or ' + '''' + @proutemode + '''' +' = '''+ ''')) and isnull(a.supply_1,0)>0   group by a.comp_code,a.unit_code,a.route1,a.rtnm,a.rtonm,a.subrt,a.subrtnm,a.subrtonm,a.publ,a.edtn,a.agcd,a.dpcd,b.ag_name,b.ag_name_oth_lang,a.city_name,a.city_oname,a.station_name,a.station_oname,a.distname,a.distoname) x group by x.comp_code,x.unit_code,x.route_code,x.route_oname,x.route_name,x.subroute_code,x.subroute_name,x.subroute_oname,x.agcd,x.dpcd,x.print_seq,x.agency_name,x.agency_oname,x.city_name,x.city_oname,x.station_name,x.station_oname,x.distname,x.distoname  order by route_seqno,route_name,subroute_seqno,subroute_name,print_seq,agency_name' 
						END
						ELSE 
						BEGIN
						print('prachi33')
							SET @vquery  = 'select x.comp_code as "COMP_CODE",unit_code as "UNIT_CODE",route_code as "ROUTE_CODE",x.route_name as "ROUTE_NAME",x.route_oname as "ROUTE_ONAME",dbo.cir_get_route_seqno(x.comp_code,x.unit_code,x.route_code) as "ROUTE_SEQNO", x.subroute_code  as "SUBROUTE_CODE",x.subroute_name as "SUBROUTE_NAME",x.subroute_oname as "SUBROUTE_ONAME",dbo.cir_get_subroute_seqno(x.comp_code,x.unit_code,x.route_code,x.subroute_code) as "SUBROUTE_SEQNO", x.agcd as "AGCD",x.dpcd as "DPCD",x.agency_name as "AGENCY_NAME",x.agency_oname as "AGENCY_ONAME",x.city_name as "CITY_NAME",x.city_oname as "CITY_ONAME",x.station_name as "STATION_NAME" ,station_oname as "STATION_ONAME",x.distname as "DISTNAME",x.distoname as "DISTONAME",x.print_seq as "PRINT_SEQ", 0 as "TOTAL_PACKET",' + @vvar_sum + ',' + @vvar_sum1 +',' + @vvar_sum2 + ' from(select a.comp_code comp_code,unit_code unit_code,a.route1 route_code,a.rtnm route_name,a.rtonm route_oname, a.subrt subroute_code,a.subrtnm subroute_name,a.subrtonm subroute_oname,  a.agcd agcd,a.dpcd dpcd,b.ag_name agency_name,b.ag_name_oth_lang agency_oname,a.city_name city_name,a.city_oname city_oname,a.station_name station_name,a.station_oname station_oname,a.distname distname,a.distoname distoname, max(a.lbl_print_no) print_seq,publ,' + @vvar + '  from cir_lblmast a,cir_agmast b where a.comp_code = b.comp_code and a.comp_code =' + '''' + @pcompcode + '''' + ' and a.unit_code = b.unit and a.unit_code =' + '''' + @punitcode + '''' + ' and (a.publ =' + '''' + @ppublcode + '''' + ' or' + '''' + @ppublcode + '''' + ' is null' + ' or ' +   '''' + @ppublcode + '''' +' = '''+ ''') and a.agcd = b.agcd and a.dpcd = b.dpcd  and a.lbl_dt =' + '''' + @vsupdate1 + '''' + ' and a.route1+a.subrt in (select route_code+subrt_code from cir_sub_route_mast where comp_code =' + '''' + @pcompcode + '''' + ' and unit =' + '''' + @punitcode + '''' + ' and (route_code+subrt_code =' + '''' + @proutecode + '''' + ' or' + '''' + @proutecode + '''' + ' is null' + ' or ' + '''' + @proutecode + '''' +' = '''+ ''') and  (subrt_mode =' + '''' + @proutemode + '''' + ' or' + '''' + @proutemode + '''' + ' is null'+ ' or ' + '''' + @proutemode + '''' +' = '''+ ''')) and isnull(a.supply_1,0)>0   group by a.comp_code,a.unit_code,a.route1,a.rtnm,a.rtonm,a.subrt,a.subrtnm,a.subrtonm,a.publ,a.edtn,a.agcd,a.dpcd,b.ag_name,b.ag_name_oth_lang,a.city_name,a.city_oname,a.station_name,a.station_oname,a.distname,a.distoname,lbl_tno) x group by x.comp_code,x.unit_code,x.route_code,x.route_oname,x.route_name,x.subroute_code,x.subroute_name,x.subroute_oname,x.agcd,x.dpcd,x.print_seq,x.agency_name,x.agency_oname,x.city_name,x.city_oname,x.station_name,x.station_oname,x.distname,x.distoname  order by route_seqno,route_name,subroute_seqno,subroute_name,print_seq,agency_name' 
						END
				END
		END
		IF @proutetype = '3' 
		BEGIN 
		
			IF @vvar is null or @vvar =''
			BEGIN 
					IF @pchallan_type = '1' 
					BEGIN 
						print('9')
						SET @vquery  = 'select x.comp_code as "COMP_CODE",unit_code as "UNIT_CODE",route_code as "ROUTE_CODE",x.route_name as "ROUTE_NAME",x.route_oname as "ROUTE_ONAME",dbo.cir_get_route_seqno(x.comp_code,x.unit_code,x.route_code) as "ROUTE_SEQNO", x.subroute_code  as "SUBROUTE_CODE",x.subroute_name as "SUBROUTE_NAME",x.subroute_oname as "SUBROUTE_ONAME",dbo.cir_get_subroute_seqno(x.comp_code,x.unit_code,x.route_code,x.subroute_code) as "SUBROUTE_SEQNO",  x.subsubrt_code as "SUBSUBRT_CODE",x.subsubrt_name as "SUBSUBRT_NAME",x.subsubrt_oname as "SUBSUBRT_ONAME",dbo.cir_get_subsubroute_seqno(x.comp_code,x.unit_code,x.route_code,x.subroute_code,x.subsubrt_code) as "SUBSUBRT_SEQNO",  x.agcd as "AGCD",x.dpcd as "DPCD",x.agency_name as "AGENCY_NAME",x.agency_oname as "AGENCY_ONAME",x.city_name as "CITY_NAME",x.city_oname as "CITY_ONAME",x.station_name as "STATION_NAME" ,station_oname as "STATION_ONAME",x.distname as "DISTNAME",x.distoname as "DISTONAME",x.print_seq as "PRINT_SEQ", 0 as "TOTAL_PACKET"  from(select a.comp_code comp_code,unit_code unit_code,a.route1 route_code,a.rtnm route_name,a.rtonm route_oname,  a.subrt subroute_code,a.subrtnm subroute_name,a.subrtonm subroute_oname, a.sub_subrt subsubrt_code,a.subsubrtnm subsubrt_name,a.subsubrtonm subsubrt_oname, a.agcd agcd,a.dpcd dpcd,b.ag_name agency_name,b.ag_name_oth_lang agency_oname,a.city_name city_name,a.city_oname city_oname,a.station_name station_name,a.station_oname station_oname, max(a.lbl_print_no) print_seq,a.publ publ,a.edtn edtn,a.distname distname,a.distoname distoname  from cir_lblmast a,cir_agmast b  where a.comp_code = b.comp_code and a.comp_code =' + '''' + @pcompcode + '''' + ' and a.unit_code = b.unit and a.unit_code =' + '''' + @punitcode + '''' + ' and  (a.publ =' + '''' + @ppublcode + '''' + ' or' + '''' + @ppublcode + '''' + ' is null' + ' or ' +   '''' + @ppublcode + '''' +' = '''+ ''') and a.agcd = b.agcd and a.dpcd = b.dpcd  and a.lbl_dt =' + '''' + @vsupdate1 + '''' + ' and  a.route1+a.subrt+a.sub_subrt in (select route_code+subrt_code+sub_subrt_code from cir_sub_subroute_mast where comp_code =' + '''' + @pcompcode + '''' + ' and unit =' + '''' + @punitcode + '''' + ' and (route_code+subrt_code+sub_subrt_code =' + '''' + @proutecode + '''' + ' or' + '''' + @proutecode + '''' + ' is null' + ' or ' + '''' + @proutecode + '''' +' = '''+ ''') and  (sub_subrt_mode =' + '''' + @proutemode + '''' + ' or ' + '''' + @proutemode + '''' + ' is null'+ ' or ' + '''' + @proutemode + '''' +' = '''+ ''')) and isnull(a.supply_1,0)>0  group by a.comp_code,a.unit_code,a.route1,a.rtnm,a.rtonm,a.subrt,a.subrtnm,a.subrtonm,a.sub_subrt,a.subsubrtnm,a.subsubrtonm,a.publ,a.edtn,a.lbl_tno,a.agcd,a.dpcd,b.ag_name,b.ag_name_oth_lang,a.city_name,a.city_oname,a.station_name,a.station_oname,a.distname,a.distoname) x group by x.comp_code,x.unit_code,x.route_code,x.route_oname,x.route_name,x.subroute_code,x.subroute_name,x.subroute_oname,x.subsubrt_code,x.subsubrt_name,x.subsubrt_oname,  x.agcd,x.dpcd,x.print_seq,x.agency_name,x.agency_oname,x.city_name,x.city_oname,x.station_name,x.station_oname,x.distname,x.distoname  order by route_seqno,route_name,subroute_seqno,subroute_name,subsubrt_seqno,subsubrt_name,print_seq,agency_name' 
					END
					ELSE 
					BEGIN 
						print('10')
						SET @vquery  = 'select x.comp_code as "COMP_CODE",unit_code as "UNIT_CODE",route_code as "ROUTE_CODE",x.route_name as "ROUTE_NAME",x.route_oname as "ROUTE_ONAME",dbo.cir_get_route_seqno(x.comp_code,x.unit_code,x.route_code) as "ROUTE_SEQNO",  x.subroute_code  as "SUBROUTE_CODE",x.subroute_name as "SUBROUTE_NAME",x.subroute_oname as "SUBROUTE_ONAME",dbo.cir_get_subroute_seqno(x.comp_code,x.unit_code,x.route_code,x.subroute_code) as "SUBROUTE_SEQNO",  x.subsubrt_code as "SUBSUBRT_CODE",x.subsubrt_name as "SUBSUBRT_NAME",x.subsubrt_oname as "SUBSUBRT_ONAME",dbo.cir_get_subsubroute_seqno(x.comp_code,x.unit_code,x.route_code,x.subroute_code,x.subsubrt_code) as "SUBSUBRT_SEQNO", x.agcd as "AGCD",x.dpcd as "DPCD",x.agency_name as "AGENCY_NAME",x.agency_oname as "AGENCY_ONAME",x.city_name as "CITY_NAME",x.city_oname as "CITY_ONAME",x.station_name as "STATION_NAME" ,station_oname as "STATION_ONAME",x.distname as "DISTNAME",x.distoname as "DISTONAME",x.print_seq as "PRINT_SEQ", 0 as "TOTAL_PACKET" from(select a.comp_code comp_code,unit_code unit_code,a.route1 route_code,a.rtnm route_name,a.rtonm route_oname,  a.subrt subroute_code,a.subrtnm subroute_name,a.subrtonm subroute_oname, a.sub_subrt subsubrt_code,a.subsubrtnm subsubrt_name,a.subsubrtonm subsubrt_oname, a.agcd agcd,a.dpcd dpcd,b.ag_name agency_name,b.ag_name_oth_lang agency_oname,a.city_name city_name,a.city_oname city_oname,a.station_name station_name,a.station_oname station_oname, max(a.lbl_print_no) print_seq,a.publ publ,a.edtn edtn,a.distname distname,a.distoname distoname   from cir_lblmast a,cir_agmast b  where a.comp_code = b.comp_code and a.comp_code =' + '''' + @pcompcode + '''' + ' and a.unit_code = b.unit and a.unit_code =' + '''' + @punitcode + '''' + ' and  (a.publ =' + '''' + @ppublcode + '''' + ' or' + '''' + @ppublcode + '''' + ' is null' + ' or ' +   '''' + @ppublcode + '''' +' = '''+ ''') and a.agcd = b.agcd and a.dpcd = b.dpcd  and a.lbl_dt =' + '''' + @vsupdate1+ '''' + ' and  a.route1+a.subrt+a.sub_subrt in (select route_code+subrt_code+sub_subrt_code from cir_sub_subroute_mast where comp_code =' + '''' + @pcompcode + '''' + ' and unit =' + '''' + @punitcode + '''' + ' and (route_code+subrt_code+sub_subrt_code =' + '''' + @proutecode + '''' + ' or' + '''' + @proutecode + '''' + ' is null' + ' or ' + '''' + @proutecode + '''' +' = '''+ ''') and  (sub_subrt_mode =' + '''' + @proutemode + '''' + ' or ' + '''' + @proutemode + '''' + ' is null'+ ' or ' + '''' + @proutemode + '''' +' = '''+ ''')) and isnull(a.supply_1,0)>0  group by a.comp_code,a.unit_code,a.route1,a.rtnm,a.rtonm,a.subrt,a.subrtnm,a.subrtonm,a.sub_subrt,a.subsubrtnm,a.subsubrtonm,a.publ,a.edtn,/*a.supply_1,*/a.agcd,a.dpcd,b.ag_name,b.ag_name_oth_lang,a.city_name,a.city_oname,a.station_name,a.station_oname,a.distname,a.distoname) x group by x.comp_code,x.unit_code,x.route_code,x.route_oname,x.route_name,x.subroute_code,x.subroute_name,x.subroute_oname,x.subsubrt_code,x.subsubrt_name,x.subsubrt_oname,  x.agcd,x.dpcd,x.print_seq,x.agency_name,x.agency_oname,x.city_name,x.city_oname,x.station_name,x.station_oname,x.distname,x.distoname order by route_seqno,route_name,subroute_seqno,subroute_name,subsubrt_seqno,subsubrt_name,print_seq,agency_name' 
					END
   			END
			ELSE 
			BEGIN 
					IF @pchallan_type = '1' 
					BEGIN 
						print('11')
						SET @vquery  = 'select x.comp_code as "COMP_CODE",unit_code as "UNIT_CODE",route_code as "ROUTE_CODE",x.route_name as "ROUTE_NAME",x.route_oname as "ROUTE_ONAME",dbo.cir_get_route_seqno(x.comp_code,x.unit_code,x.route_code) as "ROUTE_SEQNO", x.subroute_code  as "SUBROUTE_CODE",x.subroute_name as "SUBROUTE_NAME",x.subroute_oname as "SUBROUTE_ONAME",dbo.cir_get_subroute_seqno(x.comp_code,x.unit_code,x.route_code,x.subroute_code) as "SUBROUTE_SEQNO",  x.subsubrt_code as "SUBSUBRT_CODE",x.subsubrt_name as "SUBSUBRT_NAME",x.subsubrt_oname as "SUBSUBRT_ONAME",dbo.cir_get_subsubroute_seqno(x.comp_code,x.unit_code,x.route_code,x.subroute_code,x.subsubrt_code) as "SUBSUBRT_SEQNO",  x.agcd as "AGCD",x.dpcd as "DPCD",x.agency_name as "AGENCY_NAME",x.agency_oname as "AGENCY_ONAME",x.city_name as "CITY_NAME",x.city_oname as "CITY_ONAME",x.station_name as "STATION_NAME" ,station_oname as "STATION_ONAME",x.distname as "DISTNAME",x.distoname as "DISTONAME",x.print_seq as "PRINT_SEQ", 0 as "TOTAL_PACKET",' + @vvar_sum + ',' + @vvar_sum1 + ' from(select a.comp_code comp_code,unit_code unit_code,a.route1 route_code,a.rtnm route_name,a.rtonm route_oname, a.subrt subroute_code,a.subrtnm subroute_name,a.subrtonm subroute_oname,  a.sub_subrt subsubrt_code,a.subsubrtnm subsubrt_name,a.subsubrtonm subsubrt_oname,  a.agcd agcd,a.dpcd dpcd,b.ag_name agency_name,b.ag_name_oth_lang agency_oname,a.city_name city_name,a.city_oname city_oname,a.station_name station_name,a.station_oname station_oname,a.distname distname,a.distoname distoname, max(a.lbl_print_no) print_seq,a.publ publ,a.edtn edtn,' + @vvar + '  from cir_lblmast a,cir_agmast b  where a.comp_code = b.comp_code and a.comp_code =' + '''' + @pcompcode + '''' + ' and a.unit_code = b.unit and a.unit_code =' + '''' + @punitcode + '''' + ' and  (a.publ =' + '''' + @ppublcode + '''' + ' or ' + '''' + @ppublcode + '''' + ' is null' + ' or ' +   '''' + @ppublcode + '''' +' = '''+ ''') and a.agcd = b.agcd and a.dpcd = b.dpcd  and a.lbl_dt =' + '''' + @vsupdate1 + '''' + ' and  a.route1+a.subrt+a.sub_subrt in (select route_code+subrt_code+sub_subrt_code from cir_sub_subroute_mast where comp_code =' + '''' + @pcompcode + '''' + ' and unit =' + '''' + @punitcode + '''' + ' and (route_code+subrt_code+sub_subrt_code =' + '''' + @proutecode + '''' + ' or' + '''' + @proutecode + '''' + ' is null' + ' or ' + '''' + @proutecode + '''' +' = '''+ ''') and  (sub_subrt_mode =' + '''' + @proutemode + '''' + ' or ' + '''' + @proutemode + '''' + ' is null'+ ' or ' + '''' + @proutemode + '''' +' = '''+ ''')) and isnull(a.supply_1,0)>0  group by a.comp_code,a.unit_code,a.route1,a.rtnm,a.rtonm,a.subrt,a.subrtnm,a.subrtonm,a.sub_subrt,a.subsubrtnm,a.subsubrtonm,a.publ,a.edtn,a.lbl_tno,a.agcd,a.dpcd,b.ag_name,b.ag_name_oth_lang,a.city_name,a.city_oname,a.station_name,a.station_oname,a.distname,a.distoname) x group by x.comp_code,x.unit_code,x.route_code,x.route_oname,x.route_name,x.subroute_code,x.subroute_name,x.subroute_oname,x.subsubrt_code,x.subsubrt_name,x.subsubrt_oname,  x.agcd,dpcd,x.print_seq,x.agency_name,x.agency_oname,x.city_name,x.city_oname,x.station_name,x.station_oname,x.distname,x.distoname  order by route_seqno,route_name,subroute_seqno,subroute_name,subsubrt_seqno,subsubrt_name,print_seq,agency_name' 
					END
					ELSE 
					IF @pchallan_type = '2' 
					BEGIN 
						print('12')
						SET @vquery  = 'select x.comp_code as "COMP_CODE",unit_code as "UNIT_CODE",route_code as "ROUTE_CODE",x.route_name as "ROUTE_NAME",x.route_oname as "ROUTE_ONAME",dbo.cir_get_route_seqno(x.comp_code,x.unit_code,x.route_code) as "ROUTE_SEQNO", x.subroute_code  as "SUBROUTE_CODE",x.subroute_name as "SUBROUTE_NAME",x.subroute_oname as "SUBROUTE_ONAME",dbo.cir_get_subroute_seqno(x.comp_code,x.unit_code,x.route_code,x.subroute_code) as "SUBROUTE_SEQNO",  x.subsubrt_code as "SUBSUBRT_CODE",x.subsubrt_name as "SUBSUBRT_NAME",x.subsubrt_oname as "SUBSUBRT_ONAME",dbo.cir_get_subsubroute_seqno(x.comp_code,x.unit_code,x.route_code,x.subroute_code,x.subsubrt_code) as "SUBSUBRT_SEQNO",,  x.agcd as "AGCD",x.dpcd as "DPCD",x.agency_name as "AGENCY_NAME",x.agency_oname as "AGENCY_ONAME",x.city_name as "CITY_NAME",x.city_oname as "CITY_ONAME",x.station_name as "STATION_NAME" ,station_oname as "STATION_ONAME",x.distname as "DISTNAME",x.distoname as "DISTONAME",x.print_seq as "PRINT_SEQ", 0 as "TOTAL_PACKET",' + @vvar_sum + ',' + @vvar_sum1 + ' from(select a.comp_code comp_code,unit_code unit_code,a.route1 route_code,a.rtnm route_name,a.rtonm route_oname,  a.subrt subroute_code,a.subrtnm subroute_name,a.subrtonm subroute_oname, a.sub_subrt subsubrt_code,a.subsubrtnm subsubrt_name,a.subsubrtonm subsubrt_oname,  a.agcd agcd,a.dpcd dpcd,b.ag_name agency_name,b.ag_name_oth_lang agency_oname,a.city_name city_name,a.city_oname city_oname,a.station_name station_name,a.station_oname station_oname,a.distname distname,a.distoname distoname,  max(a.lbl_print_no) print_seq,a.publ publ,a.edtn edtn,' + @vvar + ' from cir_lblmast a,cir_agmast b   where a.comp_code = b.comp_code and a.comp_code =' + '''' + @pcompcode + '''' + ' and a.unit_code = b.unit and a.unit_code =' + '''' + @punitcode + '''' + ' and  (a.publ =' + '''' + @ppublcode + '''' + ' or ' + '''' + @ppublcode + '''' + ' is null' + ' or ' +   '''' + @ppublcode + '''' +' = '''+ ''') and a.agcd = b.agcd and a.dpcd = b.dpcd  and a.lbl_dt =' + '''' + @vsupdate1 + '''' + ' and  a.route1+a.subrt+a.sub_subrt in (select route_code+subrt_code+sub_subrt_code from cir_sub_subroute_mast where comp_code =' + '''' + @pcompcode + '''' + ' and unit =' + '''' + @punitcode + '''' + ' and (route_code+subrt_code+sub_subrt_code =' + '''' + @proutecode + '''' + ' or' + '''' + @proutecode + '''' + ' is null' + ' or ' + '''' + @proutecode + '''' +' = '''+ ''') and  (sub_subrt_mode =' + '''' + @proutemode + '''' + ' or ' + '''' + @proutemode + '''' + ' is null'+ ' or ' + '''' + @proutemode + '''' +' = '''+ ''')) and isnull(a.supply_1,0)>0  group by a.comp_code,a.unit_code,a.route1,a.rtnm,a.rtonm,a.subrt,a.subrtnm,a.subrtonm,a.sub_subrt,a.subsubrtnm,a.subsubrtonm,a.publ,a.edtn,/*a.supply_1,*/a.agcd,a.dpcd,b.ag_name,b.ag_name_oth_lang,a.city_name,a.city_oname,a.station_name,a.station_oname,a.distname,a.distoname) x group by x.comp_code,x.unit_code,x.route_code,x.route_oname,x.route_name,x.subroute_code,x.subroute_name,x.subroute_oname,x.subsubrt_code,x.subsubrt_name,x.subsubrt_oname,  x.agcd,x.dpcd,x.print_seq,x.agency_name,x.agency_oname,x.city_name,x.city_oname,x.station_name,x.station_oname,x.distname,x.distoname  order by route_seqno,route_name,subroute_seqno,subroute_name,subsubrt_seqno,subsubrt_name,print_seq,agency_name' 
					END
					ELSE 
					BEGIN 
						SET @vquery  = 'select x.comp_code as "COMP_CODE",unit_code as "UNIT_CODE",route_code as "ROUTE_CODE",x.route_name as "ROUTE_NAME",x.route_oname as "ROUTE_ONAME",dbo.cir_get_route_seqno(x.comp_code,x.unit_code,x.route_code) as "ROUTE_SEQNO", x.subroute_code  as "SUBROUTE_CODE",x.subroute_name as "SUBROUTE_NAME",x.subroute_oname as "SUBROUTE_ONAME",dbo.cir_get_subroute_seqno(x.comp_code,x.unit_code,x.route_code,x.subroute_code) as "SUBROUTE_SEQNO",  x.subsubrt_code as "SUBSUBRT_CODE",x.subsubrt_name as "SUBSUBRT_NAME",x.subsubrt_oname as "SUBSUBRT_ONAME",dbo.cir_get_subsubroute_seqno(x.comp_code,x.unit_code,x.route_code,x.subroute_code,x.subsubrt_code) as "SUBSUBRT_SEQNO",,  x.agcd as "AGCD",x.dpcd as "DPCD",x.agency_name as "AGENCY_NAME",x.agency_oname as "AGENCY_ONAME",x.city_name as "CITY_NAME",x.city_oname as "CITY_ONAME",x.station_name as "STATION_NAME" ,station_oname as "STATION_ONAME",x.distname as "DISTNAME",x.distoname as "DISTONAME",x.print_seq as "PRINT_SEQ", 0 as "TOTAL_PACKET",' + @vvar_sum + ',' + @vvar_sum1 +',' + @vvar_sum2 + ' from(select a.comp_code comp_code,unit_code unit_code,a.route1 route_code,a.rtnm route_name,a.rtonm route_oname,  a.subrt subroute_code,a.subrtnm subroute_name,a.subrtonm subroute_oname, a.sub_subrt subsubrt_code,a.subsubrtnm subsubrt_name,a.subsubrtonm subsubrt_oname,  a.agcd agcd,a.dpcd dpcd,b.ag_name agency_name,b.ag_name_oth_lang agency_oname,a.city_name city_name,a.city_oname city_oname,a.station_name station_name,a.station_oname station_oname,a.distname distname,a.distoname distoname,  max(a.lbl_print_no) print_seq,a.publ publ,a.edtn edtn,' + @vvar + ' from cir_lblmast a,cir_agmast b   where a.comp_code = b.comp_code and a.comp_code =' + '''' + @pcompcode + '''' + ' and a.unit_code = b.unit and a.unit_code =' + '''' + @punitcode + '''' + ' and  (a.publ =' + '''' + @ppublcode + '''' + ' or ' + '''' + @ppublcode + '''' + ' is null' + ' or ' +   '''' + @ppublcode + '''' +' = '''+ ''') and a.agcd = b.agcd and a.dpcd = b.dpcd  and a.lbl_dt =' + '''' + @vsupdate1 + '''' + ' and  a.route1+a.subrt+a.sub_subrt in (select route_code+subrt_code+sub_subrt_code from cir_sub_subroute_mast where comp_code =' + '''' + @pcompcode + '''' + ' and unit =' + '''' + @punitcode + '''' + ' and (route_code+subrt_code+sub_subrt_code =' + '''' + @proutecode + '''' + ' or' + '''' + @proutecode + '''' + ' is null' + ' or ' + '''' + @proutecode + '''' +' = '''+ ''') and  (sub_subrt_mode =' + '''' + @proutemode + '''' + ' or ' + '''' + @proutemode + '''' + ' is null'+ ' or ' + '''' + @proutemode + '''' +' = '''+ ''')) and isnull(a.supply_1,0)>0  group by a.comp_code,a.unit_code,a.route1,a.rtnm,a.rtonm,a.subrt,a.subrtnm,a.subrtonm,a.sub_subrt,a.subsubrtnm,a.subsubrtonm,a.publ,a.edtn,/*a.supply_1,*/a.agcd,a.dpcd,b.ag_name,b.ag_name_oth_lang,a.city_name,a.city_oname,a.station_name,a.station_oname,a.distname,a.distoname) x group by x.comp_code,x.unit_code,x.route_code,x.route_oname,x.route_name,x.subroute_code,x.subroute_name,x.subroute_oname,x.subsubrt_code,x.subsubrt_name,x.subsubrt_oname,  x.agcd,x.dpcd,x.print_seq,x.agency_name,x.agency_oname,x.city_name,x.city_oname,x.station_name,x.station_oname,x.distname,x.distoname  order by route_seqno,route_name,subroute_seqno,subroute_name,subsubrt_seqno,subsubrt_name,print_seq,agency_name' 
					END
   			END
   		END
   
		--insert into test1(vstring,vstring2) values('2 '+vquery,null);commit;
		print(@vquery)
		EXEC (@vquery)
		DEALLOCATE cur_edtn
End

///////////////////////////////////////////////////////////end/////////////////////////////////////////////////


/////////////////////////// deepika 27/04/2012 sent by Laxman sir////////////////////////////////////////////


                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE adacct_party_out_summary
@pcomp_code		as varchar(20),
@punit_code		as varchar(20),
@ppcenter_code	as varchar(20),
@preg_code		as varchar(30),
@pagency_code	as varchar(30),
@pag_main_code	as varchar(30),
@pag_sub_code	as varchar(30),
@pdistcode		as varchar(30),
@ptalukacode	as varchar(20),
@pfrom_date		as datetime,--complete bills or outstanding bills(Y/N)
@pason_date		as datetime,
@pmainag_flag	as varchar(50),
@pdateformat	as varchar(20),
@pextra1		as varchar(50),
@pextra2		as varchar(50)
AS

declare @v_frdt			as datetime
declare @v_asondt		as datetime
declare @v_findt		as datetime
declare @v_opbal		as decimal(15,2)
declare @v_amt			as decimal(15,2)
declare @v_billamt		as decimal(15,2)
declare @v_other_dbamt	as decimal(15,2)
declare @v_rctamt		as decimal(15,2)
declare @v_other_cramt  as decimal(15,2)
declare @v_dsign		as int

declare @v_agcity       as varchar(100);
declare @v_agregion     as varchar(100);
declare @v_agtaluka     as varchar(100);

-- cursor c1 variables
declare @v1_AGENCY_CODE		as varchar(30)
declare @v1_AGENCY_SUB_CODE as varchar(30)
declare @v1_AGENCY_NAME		as varchar(500)
declare @v1_AGENCY_ALIAS	as varchar(500)
declare @v1_CITY_CODE		as varchar(50)
declare @v1_CITY_NAME		as varchar(100)
declare @v1_REGION			as varchar(50)
declare @v1_branch_code		as varchar(50)
declare @v1_branch_name		as varchar(50)
declare @v1_dist_code		as varchar(100)
declare @v1_taluka			as varchar(100)
--cursor c2---
declare @v2_doctype			as varchar(30)
declare @v2_amount			as decimal(15,2)
-----------------------
declare @vfrdt varchar(20)
if(@pdateformat='dd/mm/yyyy')
begin
	set @vfrdt= convert(varchar(10),@pfrom_date,103)
end
else if(@pdateformat='mm/dd/yyyy')
begin
	set @vfrdt= convert(varchar(10),@pfrom_date,101)
end
else
begin
	set @vfrdt= convert(varchar(10),@pfrom_date,111)
end
set @v_frdt= @pfrom_date
set @v_asondt= @pason_date
declare c1 cursor for
		 SELECT a.Agency_Code AS AGENCY_CODE,a.SUB_Agency_Code AS AGENCY_SUB_CODE,a.Agency_Name AS AGENCY_NAME,
		a.Agency_Alias AGENCY_ALIAS,a.City_Code AS CITY_CODE,c.City_Name AS CITY_NAME,a.region AS REGION,
		a.Branch_code branch_code,b.Branch_Name branch_name,a.Dist_Code dist_code,a.taluka taluka
		FROM  agency_mast a  LEFT OUTER JOIN  city_mst c  ON  a.Comp_Code  = c.Comp_Code
		AND	a.City_Code  = c.City_Code   LEFT OUTER JOIN  branch_mst b  ON  a.Branch_code  = b.Branch_Code  
		WHERE	 a.Comp_Code  = @pcomp_code 
		AND	(a.Agency_Code  = @pag_main_code OR	@pag_main_code  is null OR	@pag_main_code  ='') 
		AND	(a.SUB_Agency_Code  = @pag_sub_code OR	@pag_sub_code  is null OR	@pag_sub_code  ='') 
		AND	(a.Dist_Code  = @pdistcode OR	@pdistcode  is null  OR	@pdistcode  ='') 
		AND	(a.region  = @preg_code OR	@preg_code  is null OR	@preg_code  ='') 
		AND	(a.taluka  = @ptalukacode OR	@ptalukacode  is null OR	@ptalukacode  ='') 
		AND	(a.Branch_code  = @punit_code OR	@punit_code  is null OR	@punit_code  ='') 
		AND	(b.pub_center  = @ppcenter_code OR	@ppcenter_code  is null OR	@ppcenter_code  ='')
		--a.Branch_code in(select lb.branch_code from login_branch_mast lb where  lb.user_code=@pextra1 and isnull(lb.user_flag,'N')='Y')
		and  (a.Agency_Type_Code=@pextra2 or @pextra2 is null or @pextra2 ='')
		ORDER BY AGENCY_NAME 

CREATE table #AD_AGNECY_BAL
(
  COMP_CODE  VARCHAR(8),
  UNIT_CODE  VARCHAR(30),
  PRIPUB     VARCHAR(30),
  AGCODE     VARCHAR(30),
  AGSUBCODE  VARCHAR(30),
  AGNAME     VARCHAR(500),
  CITY_CODE  VARCHAR(50),
  REG_CODE   VARCHAR(50),
  OP_AMT     decimal(15,2),
  BILL_AMT   decimal(15,2),
  OTH_DBAMT  decimal(15,2),
  REC_AMT    decimal(15,2),
  OTH_CRAMT  decimal(15,2),
  BAL_AMT    VARCHAR(50),
  DT         DATEtime,
  PCENTER      VARCHAR(100),
  ZONE_CODE    VARCHAR(100),
  STATE_CODE   VARCHAR(100),
  DIST_CODE    VARCHAR(100),
  TALUKA_CODE  VARCHAR(100)
)

print (@v_frdt)
set @v_opbal=0
set @v_amt=0
set @v_findt = dbo.finan_dt(@pcomp_code,@vfrdt,@pdateformat);

open c1
		fetch NEXT FROM c1 INTO @v1_AGENCY_CODE,@v1_AGENCY_SUB_CODE,@v1_AGENCY_NAME,@v1_AGENCY_ALIAS,@v1_CITY_CODE,@v1_CITY_NAME ,@v1_REGION,@v1_branch_code,@v1_branch_name,@v1_dist_code,@v1_taluka
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN
		print(@@FETCH_STATUS)

			set @v_agcity    =isnull(@v1_city_name,'N/A');--ad_get_cityname(pcomp_code,v1.city_code);
			set @v_agregion  =dbo.ad_get_regionname(@pcomp_code,@v1_region);
			
			select distinct @v_agtaluka=talu_name from taluka_mast 
			where comp_code=@pcomp_code and talu_code=@v1_taluka;
			
			if(@v_agtaluka is null or @v_agtaluka = '')
			begin
				set @v_agtaluka='N/A'
			end
			if @pmainag_flag='Y' begin
				set @v1_AGENCY_SUB_CODE=null;
			end
			
     		/* opening on financial date*/
			set @v_opbal =dbo.agency_opbal(@pcomp_code,'',@v1_AGENCY_CODE,@v1_AGENCY_SUB_CODE,@v_findt,'Y',@pdateformat);
			/* Transaction amount from financial date to as on date*/
			set @v_amt  =dbo.agency_ytodt(@pcomp_code,'',@v1_AGENCY_CODE,@v1_AGENCY_SUB_CODE,@v_findt,@v_frdt,@pdateformat);

			/*select @v_billamt=sum(a.amount) from ad_outstand a---for billing data
			where (a.comp_code=@pcomp_code ) and (a.unit=@punit_code or @punit_code is null) and a.doctype='BILL' and
			a.ag_main_code=@v1_agency_code and (a.ag_sub_code=@v1_agency_sub_code or @v1_agency_sub_code is null) and
			a.billdt>=@v_frdt and a.billdt<=@v_asondt and a.recptno is null and a.recptdt is null;*/

			declare c2 cursor for
						select doctype doctype,abs(sum(amount)) amount from ad_outstand
						where comp_code=@pcomp_code and ((doctype<>'BILL' and recptdt>=@v_frdt and recptdt<=@v_asondt) 
						or (doctype='BILL' and billdt>=@v_frdt and billdt<=@v_asondt)) and 
						ag_main_code=@v1_agency_code and ag_sub_code=@v1_agency_sub_code
						group by doctype;

			open c2
					fetch NEXT FROM c2 INTO @v2_doctype,@v2_amount
					WHILE (@@FETCH_STATUS = 0) 
					BEGIN
						select @v_dsign=Dsign from fa_docmst where Comp_code=@pcomp_code and doc_type=@v2_doctype;
						if @v_dsign=-1 BEGIN
							if (@v2_doctype ='RCR' or @v2_doctype ='RCP') begin   
								set @v_rctamt=isnull(@v_rctamt,0)+isnull(@v2_amount,0)
							end
							else
							begin 
								set @v_other_cramt=isnull(@v_other_cramt,0)+isnull(@v2_amount,0);
							end
						end
						else
						begin
							if (@v2_doctype = 'BILL') begin
								set @v_billamt=isnull(@v_billamt,0)+isnull(@v2_amount,0);
							end
							else
							begin
								set @v_other_dbamt=isnull(@v_other_dbamt,0)+isnull(@v2_amount,0);
							end
						end  

					fetch NEXT FROM c2 INTO @v2_doctype,@v2_amount
					end
			close c2;		
		deallocate c2
		if isnull(@v_opbal,0)+isnull(@v_amt,0)=0 and isnull(@v_billamt,0)=0 and isnull(@v_other_dbamt,0)=0 and isnull(@v_rctamt,0)=0 and isnull(@v_other_cramt,0)=0 begin
		print('hi')	
		end
		else
		begin
			 insert into #ad_agnecy_bal(comp_code,unit_code,agcode,agsubcode,agname,city_code,reg_code,dist_code,taluka_code,
                         op_amt,bill_amt,oth_dbamt,rec_amt,oth_cramt)
             values(@pcomp_code,@v1_branch_code,@v1_agency_code,@v1_agency_sub_code,@v1_agency_name,@v_agcity,@v_agregion,@v1_dist_code,@v_agtaluka,
                         isnull(@v_opbal,0)+isnull(@v_amt,0),isnull(@v_billamt,0),isnull(@v_other_dbamt,0),isnull(@v_rctamt,0),isnull(@v_other_cramt,0));
		end
		set @v_opbal=0;set @v_amt=0;set @v_billamt=0;set @v_other_dbamt=0;set @v_rctamt=0;set @v_other_cramt=0;
		fetch NEXT FROM c1 INTO @v1_AGENCY_CODE,@v1_AGENCY_SUB_CODE,@v1_AGENCY_NAME,@v1_AGENCY_ALIAS,@v1_CITY_CODE,@v1_CITY_NAME ,@v1_REGION,@v1_branch_code,@v1_branch_name,@v1_dist_code,@v1_taluka
		end
close c1;

	select a.comp_code,a.unit_code,a.agcode,a.agsubcode,substring(a.agname,1,37) agname,a.op_amt,a.bill_amt,a.oth_dbamt,a.rec_amt,a.oth_cramt,
   isnull(a.op_amt,0)+isnull(a.bill_amt,0)+isnull(a.oth_dbamt,0)-isnull(a.rec_amt,0)-isnull(a.oth_cramt,0) ag_bal,
   a.city_code,substring(a.city_name,1,20) city_name,a.reg_code,substring(a.region_name,1,20) region_name,a.dist_code,a.taluka_code,BRANCH_NAME,AGENCY_TYPE from
   (select comp_code,unit_code,agcode,agsubcode,agname,sum(op_amt) op_amt,sum(bill_amt) bill_amt,sum(oth_dbamt) oth_dbamt,
   sum(rec_amt) rec_amt,sum(oth_cramt) oth_cramt,
   city_code,city_code city_name,reg_code,reg_code region_name,--ad_get_regionname(comp_code,reg_code)
   dist_code as DIST_CODE,taluka_code AS TALUKA_CODE,pcenter AS BRANCH_NAME,zone_code AS AGENCY_TYPE
   from #ad_agnecy_bal
   group by comp_code,unit_code,agcode,agsubcode,agname,city_code,reg_code,dist_code,taluka_code,zone_code,pcenter) a
   order by a.comp_code,a.unit_code,a.region_name,a.agname;

 select a.comp_code,a.unit_code,a.op_amt,a.bill_amt,a.oth_dbamt,a.rec_amt,a.oth_cramt,
   isnull(a.op_amt,0)+isnull(a.bill_amt,0)+isnull(a.oth_dbamt,0)-isnull(a.rec_amt,0)-isnull(a.oth_cramt,0) ag_bal,
   a.reg_code,substring(a.region_name,1,20) region_name from
   (select comp_code,unit_code,sum(op_amt) op_amt,sum(bill_amt) bill_amt,sum(oth_dbamt) oth_dbamt,
   sum(rec_amt) rec_amt,sum(oth_cramt) oth_cramt,reg_code,reg_code region_name
   from #ad_agnecy_bal 
   group by comp_code,unit_code,reg_code) a
   order by a.comp_code,a.unit_code,a.region_name;

deallocate c1

--drop table #AD_AGNECY_BAL_temp      
--drop table #AD_AGNECY_BAL

/

/////////////////////////////////////////////////end ////////////////////////////////////////////////////////////////


////////////////////////////////////////////////national sales report//////by rahul 26 april 2012///////////////////////////////////



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROCEDURE [dbo].[cir_rep_national_sale_cir_rep_national_zone]
    @pcomp_code                               varchar(4000) ,
    @punit_code                               varchar(4000) ,
    @pbranch_code                             varchar(4000) ,
    @ppubl                                    varchar(4000) ,
    @pedtn                                    varchar(4000) ,
    @pag_type                                 varchar(4000) ,
    @pag_class                                varchar(4000) ,
    @preport_type                             varchar(4000) ,
    @pbill_pay                                varchar(4000) ,
    @pfrom_supdate                            varchar(4000) ,
    @ptill_supdate                            varchar(4000) ,
    @pdateformat                              varchar(4000) ,
    @pextra1                                  varchar(4000) ,
    @pextra2                                  varchar(4000) ,
    @pextra3                                  varchar(4000) ,
    @pextra4                                  varchar(4000) ,
    @pextra5                                  varchar(4000) ,
    @pextra6                                  varchar(4000) ,
    @pextra7                                  varchar(4000) ,
    @pextra8                                  varchar(4000) ,
    @pextra9                                  varchar(4000) ,
    @pextra10                                 varchar(4000)  
AS 
    DECLARE @LOOPPROCESSINGFLAG BIT 
    BEGIN
        SET NOCOUNT ON
        
        DECLARE @VFROM_SUPDATE                            DATETIME 
        DECLARE @VTILL_SUPDATE                            DATETIME 
        SELECT @VFROM_SUPDATE  = CONVERT(DATETIME, @pfrom_supdate)
        SELECT @VTILL_SUPDATE  = CONVERT(DATETIME, @ptill_supdate)
        ---BRANCH WISE
        
        SET @LOOPPROCESSINGFLAG = 0
        IF @preport_type = '1' 
        BEGIN 
            

                            SELECT
                                     A.COMP_CODE,
                                     A.UNIT_CODE,
                                     A.PUBL,
                                     A.EDTN,
                                     DBO.CIR_GET_PUBL_NAME(A.COMP_CODE, A.PUBL) AS "PUBL_NAME",
                                     DBO.CIR_GET_EDTN_NAME(A.COMP_CODE, A.EDTN) AS "EDITION",
                                     SUM(CONVERT(FLOAT, A.SUP_COPY)) AS "SUP_COPY",
                                     A.SUP_RATE,
                                     COUNT(A.EDTN) AS "DAYS",
                                     DBO.CIR_GET_BRANCH(A.COMP_CODE, M.BRANCH_CODE) AS "BRANCH_NAME",
                                     CAST(ROUND(SUM(CONVERT(FLOAT, A.SUP_COPY)) / CONVERT(FLOAT, COUNT(A.EDTN)),0) AS INTEGER) AVG_COPY,
                                     ROUND(SUM(CONVERT(FLOAT, A.SUP_COPY)) * SUP_RATE, 2) AS "COPY_AMT"
                            FROM  CIR_DBKSUP A,
                                 CIR_SUPPLY_TYPE_MAST B,
                                 CIR_AGMAST M,
                                 CIR_CITY_MAST K 
                            WHERE     A.COMP_CODE  = B.COMP_CODE
                             AND    A.COMP_CODE  = M.COMP_CODE
                             AND    (A.COMP_CODE  = @pcomp_code
                             OR    @pcomp_code  IS NULL)
                             AND    A.UNIT_CODE  = M.UNIT
                             AND    (A.UNIT_CODE  = @punit_code
                             OR    @punit_code  IS NULL)
                             AND    (M.BRANCH_CODE  = @pbranch_code
                             OR    @pbranch_code  IS NULL)
                             AND    (A.PUBL  = @ppubl
                             OR    @ppubl  IS NULL)
                             AND    (A.EDTN  = @pedtn
                             OR    @pedtn  IS NULL)
                             AND    (M.AG_TYPE  = @pag_type
                             OR    @pag_type  IS NULL)
                             AND    (M.AG_CLASS  = @pag_class
                             OR    @pag_class  IS NULL)
                             AND    A.AGCD  = M.AGCD
                             AND    A.DPCD  = M.DPCD
                             AND    A.SUP_TYPE_CODE  = B.SUP_TY_CODE
                             AND    (B.BILL_PAY  = @pbill_pay
                             OR    @pbill_pay  IS NULL)
                             AND    (A.SUPDATE  BETWEEN @VFROM_SUPDATE  AND  @VTILL_SUPDATE)
                            GROUP BY A.COMP_CODE,
                                 A.UNIT_CODE,
                                 A.PUBL,
                                 A.EDTN,
                                 M.BRANCH_CODE,
                                  A.SUP_RATE 
            ORDER BY A.COMP_CODE,
                                 A.UNIT_CODE,
                                 A.PUBL,
                                 A.EDTN,
                                 M.BRANCH_CODE,
                                 A.SUP_RATE 
            
            

                            SELECT
                                     A.COMP_CODE,
                                     A.UNIT_CODE,
                                     A.PUBL,
                                     DBO.CIR_GET_PUBL_NAME(A.COMP_CODE, A.PUBL) AS "PUBL_NAME",
                                     A.SUP_RATE,
                                     C.COPY_RATE,
                                     A.EDTN,
                                     DBO.CIR_GET_EDTN_NAME(A.COMP_CODE, A.EDTN) AS "EDITION",
                                     SUM(CONVERT(FLOAT, A.SUP_COPY)) AS "SUP_COPY",
                                     COUNT(A.EDTN) AS "DAYS",
                                     CAST(ROUND(SUM(CONVERT(FLOAT, A.SUP_COPY)) / CONVERT(FLOAT, COUNT(A.EDTN)),0) AS INTEGER) AVG_COPY,
                                     ROUND(SUM(CONVERT(FLOAT, A.SUP_COPY)) * SUP_RATE, 2) AS "COPY_AMT",
                                     SUM(CONVERT(FLOAT, ISNULL(C.APR_SHORT_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_UNSOLD, 0) + ISNULL(C.APR_BNR, 0))) AS "UNSOLD_COPY",
                                     SUM(CONVERT(FLOAT, ISNULL(C.APR_SHORT_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_UNSOLD, 0) + ISNULL(C.APR_BNR, 0))) * C.COPY_RATE AS "UNSOLD_AMT",
                                     ROUND((SUM(CONVERT(FLOAT, ISNULL(C.APR_SHORT_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_UNSOLD, 0) + ISNULL(C.APR_BNR, 0))) * 100) / CONVERT(FLOAT, SUM(CONVERT(FLOAT, A.SUP_COPY))), 2) AS "UNS_PER"
                            FROM  CIR_DBKSUP A,
                                 CIR_SUPPLY_TYPE_MAST B,
                                 CIR_UNSOLD_DTL C,
                                 CIR_AGMAST M 
                            WHERE     A.COMP_CODE  = B.COMP_CODE
                             AND    A.COMP_CODE  = M.COMP_CODE
                             AND    (A.COMP_CODE  = @pcomp_code
                             OR    @pcomp_code  IS NULL)
                             AND    A.COMP_CODE  = C.COMP_CODE
                             AND    A.UNIT_CODE  = C.UNIT_CODE
                             AND    A.UNIT_CODE  = M.UNIT
                             AND    (A.UNIT_CODE  = @punit_code
                             OR    @punit_code  IS NULL)
                             AND    A.PUBL  = C.PUBL
                             AND    (A.PUBL  = @ppubl
                             OR    @ppubl  IS NULL)
                             AND    A.EDTN  = C.EDTN
                             AND    (A.EDTN  = @pedtn
                             OR    @pedtn  IS NULL)
                             AND    (M.AG_TYPE  = @pag_type
                             OR    @pag_type  IS NULL)
                             AND    (M.AG_CLASS  = @pag_class
                             OR    @pag_class  IS NULL)
                             AND    A.AGCD  = M.AGCD
                             AND    A.DPCD  = M.DPCD
                             AND    A.SUP_RATE  = C.COPY_RATE
                             AND    A.SUP_TYPE_CODE  = B.SUP_TY_CODE
                             AND    (B.BILL_PAY  = @pbill_pay
                             OR    @pbill_pay  IS NULL)
                             AND    (A.SUPDATE  BETWEEN @VFROM_SUPDATE  AND  @VTILL_SUPDATE)
                            GROUP BY A.COMP_CODE,
                                 A.UNIT_CODE,
                                 A.PUBL,
                                 A.EDTN,
                                 A.SUP_RATE,
                                  C.COPY_RATE 
            ORDER BY A.COMP_CODE,
                                 A.UNIT_CODE,
                                 A.PUBL,
                                 A.EDTN,
                                 A.SUP_RATE 
            
            SET @LOOPPROCESSINGFLAG = 1
        END
        IF @preport_type = '2'  AND (@LOOPPROCESSINGFLAG = 0)
        BEGIN 
            

                            SELECT
                                     A.COMP_CODE,
                                     A.UNIT_CODE,
                                     A.PUBL,
                                     A.EDTN,
                                     DBO.CIR_GET_PUBL_NAME(A.COMP_CODE, A.PUBL) AS "PUBL_NAME",
                                     DBO.CIR_GET_EDTN_NAME(A.COMP_CODE, A.EDTN) AS "EDITION",
                                     SUM(CONVERT(FLOAT, A.SUP_COPY)) AS "SUP_COPY",
                                     A.SUP_RATE,
                                     COUNT(A.EDTN) AS "DAYS",
                                     DBO.CIR_GET_ZONE_NAME(A.COMP_CODE, K.ZONE_CODE) AS "ZONE_NAME",
                                     CAST(ROUND(SUM(CONVERT(FLOAT, A.SUP_COPY)) / CONVERT(FLOAT, COUNT(A.EDTN)),0) AS INTEGER) AVG_COPY,
                                     ROUND(SUM(CONVERT(FLOAT, A.SUP_COPY)) * SUP_RATE, 2) AS "COPY_AMT"
                            FROM  CIR_DBKSUP A,
                                 CIR_SUPPLY_TYPE_MAST B,
                                 CIR_AGMAST M,
                                 CIR_CITY_MAST K 
                            WHERE     A.COMP_CODE  = B.COMP_CODE
                             AND    A.COMP_CODE  = M.COMP_CODE
                             AND    (A.COMP_CODE  = @pcomp_code
                             OR    @pcomp_code  IS NULL)
                             AND    A.UNIT_CODE  = M.UNIT
                             AND    (A.UNIT_CODE  = @punit_code
                             OR    @punit_code  IS NULL)
                             AND    (M.BRANCH_CODE  = @pbranch_code
                             OR    @pbranch_code  IS NULL)
                             AND    (A.PUBL  = @ppubl
                             OR    @ppubl  IS NULL)
                             AND    (A.EDTN  = @pedtn
                             OR    @pedtn  IS NULL)
                             AND    (M.AG_TYPE  = @pag_type
                             OR    @pag_type  IS NULL)
                             AND    (M.AG_CLASS  = @pag_class
                             OR    @pag_class  IS NULL)
                             AND    A.AGCD  = M.AGCD
                             AND    A.DPCD  = M.DPCD
                             AND    A.SUP_TYPE_CODE  = B.SUP_TY_CODE
                             AND    (B.BILL_PAY  = @pbill_pay
                             OR    @pbill_pay  IS NULL)
                             AND    (A.SUPDATE  BETWEEN @VFROM_SUPDATE  AND  @VTILL_SUPDATE)
                            GROUP BY A.COMP_CODE,
                                 A.UNIT_CODE,
                                 A.PUBL,
                                 A.EDTN,
                                 K.ZONE_CODE,
                                  A.SUP_RATE 
            ORDER BY A.COMP_CODE,
                                 A.UNIT_CODE,
                                 A.PUBL,
                                 A.EDTN,
                                 K.ZONE_CODE,
                                 A.SUP_RATE 
            
            

                            SELECT
                                     A.COMP_CODE,
                                     A.UNIT_CODE,
                                     A.PUBL,
                                     DBO.CIR_GET_PUBL_NAME(A.COMP_CODE, A.PUBL) AS "PUBL_NAME",
                                     A.SUP_RATE,
                                     C.COPY_RATE,
                                     A.EDTN,
                                     DBO.CIR_GET_EDTN_NAME(A.COMP_CODE, A.EDTN) AS "EDITION",
                                     SUM(CONVERT(FLOAT, A.SUP_COPY)) AS "SUP_COPY",
                                     A.SUP_RATE,
                                     COUNT(A.EDTN) AS "DAYS",
                                     CAST(ROUND(SUM(CONVERT(FLOAT, A.SUP_COPY)) / CONVERT(FLOAT, COUNT(A.EDTN)),0) AS INTEGER) AVG_COPY,
                                     ROUND(SUM(CONVERT(FLOAT, A.SUP_COPY)) * SUP_RATE, 2) AS "COPY_AMT",
                                     SUM(CONVERT(FLOAT, ISNULL(C.APR_SHORT_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_UNSOLD, 0) + ISNULL(C.APR_BNR, 0))) AS "UNSOLD_COPY",
                                     C.COPY_RATE,
                                     SUM(CONVERT(FLOAT, ISNULL(C.APR_SHORT_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_UNSOLD, 0) + ISNULL(C.APR_BNR, 0))) * C.COPY_RATE AS "UNSOLD_AMT",
                                     ROUND((SUM(CONVERT(FLOAT, ISNULL(C.APR_SHORT_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_UNSOLD, 0) + ISNULL(C.APR_BNR, 0))) * 100) / CONVERT(FLOAT, SUM(CONVERT(FLOAT, A.SUP_COPY))), 2) AS "UNS_PER"
                            FROM  CIR_DBKSUP A,
                                 CIR_SUPPLY_TYPE_MAST B,
                                 CIR_UNSOLD_DTL C,
                                 CIR_AGMAST M 
                            WHERE     A.COMP_CODE  = B.COMP_CODE
                             AND    A.COMP_CODE  = M.COMP_CODE
                             AND    (A.COMP_CODE  = @pcomp_code
                             OR    @pcomp_code  IS NULL)
                             AND    A.COMP_CODE  = C.COMP_CODE
                             AND    A.UNIT_CODE  = C.UNIT_CODE
                             AND    A.UNIT_CODE  = M.UNIT
                             AND    (A.UNIT_CODE  = @punit_code
                             OR    @punit_code  IS NULL)
                             AND    A.PUBL  = C.PUBL
                             AND    (A.PUBL  = @ppubl
                             OR    @ppubl  IS NULL)
                             AND    A.EDTN  = C.EDTN
                             AND    (A.EDTN  = @pedtn
                             OR    @pedtn  IS NULL)
                             AND    (M.AG_TYPE  = @pag_type
                             OR    @pag_type  IS NULL)
                             AND    (M.AG_CLASS  = @pag_class
                             OR    @pag_class  IS NULL)
                             AND    A.AGCD  = M.AGCD
                             AND    A.DPCD  = M.DPCD
                             AND    A.SUP_RATE  = C.COPY_RATE
                             AND    A.SUP_TYPE_CODE  = B.SUP_TY_CODE
                             AND    (B.BILL_PAY  = @pbill_pay
                             OR    @pbill_pay  IS NULL)
                             AND    (A.SUPDATE  BETWEEN @VFROM_SUPDATE  AND  @VTILL_SUPDATE)
                            GROUP BY A.COMP_CODE,
                                 A.UNIT_CODE,
                                 A.PUBL,
                                 A.EDTN,
                                 A.SUP_RATE,
                                  C.COPY_RATE 
            ORDER BY A.COMP_CODE,
                                 A.UNIT_CODE,
                                 A.PUBL,
                                 A.EDTN,
                                 A.SUP_RATE 
            
            SET @LOOPPROCESSINGFLAG = 1
        END
        IF @preport_type = '3'  AND (@LOOPPROCESSINGFLAG = 0)
        BEGIN 
            

                            SELECT
                                     A.COMP_CODE,
                                     A.UNIT_CODE,
                                     A.PUBL,
                                     A.EDTN,
                                     DBO.CIR_GET_PUBL_NAME(A.COMP_CODE, A.PUBL) AS "PUBL_NAME",
                                     DBO.CIR_GET_EDTN_NAME(A.COMP_CODE, A.EDTN) AS "EDITION",
                                     SUM(CONVERT(FLOAT, A.SUP_COPY)) AS "SUP_COPY",
                                     A.SUP_RATE,
                                     COUNT(A.EDTN) AS "DAYS",
                                     DBO.CIR_GET_REGION_NAME(A.COMP_CODE, K.REGION_CODE) AS "REGION_NAME",
                                     CAST(ROUND(SUM(CONVERT(FLOAT, A.SUP_COPY)) / CONVERT(FLOAT, COUNT(A.EDTN)),0) AS INTEGER) AVG_COPY,
                                     ROUND(SUM(CONVERT(FLOAT, A.SUP_COPY)) * SUP_RATE, 2) AS "COPY_AMT"
                            FROM  CIR_DBKSUP A,
                                 CIR_SUPPLY_TYPE_MAST B,
                                 CIR_AGMAST M,
                                 CIR_CITY_MAST K 
                            WHERE     A.COMP_CODE  = B.COMP_CODE
                             AND    A.COMP_CODE  = M.COMP_CODE
                             AND    (A.COMP_CODE  = @pcomp_code
                             OR    @pcomp_code  IS NULL)
                             AND    A.UNIT_CODE  = M.UNIT
                             AND    (A.UNIT_CODE  = @punit_code
                             OR    @punit_code  IS NULL)
                             AND    (M.BRANCH_CODE  = @pbranch_code
                             OR    @pbranch_code  IS NULL)
                             AND    (A.PUBL  = @ppubl
                             OR    @ppubl  IS NULL)
                             AND    (A.EDTN  = @pedtn
                             OR    @pedtn  IS NULL)
                             AND    (M.AG_TYPE  = @pag_type
                             OR    @pag_type  IS NULL)
                             AND    (M.AG_CLASS  = @pag_class
                             OR    @pag_class  IS NULL)
                             AND    A.AGCD  = M.AGCD
                             AND    A.DPCD  = M.DPCD
                             AND    A.SUP_TYPE_CODE  = B.SUP_TY_CODE
                             AND    (B.BILL_PAY  = @pbill_pay
                             OR    @pbill_pay  IS NULL)
                             AND    (A.SUPDATE  BETWEEN @VFROM_SUPDATE  AND  @VTILL_SUPDATE)
                            GROUP BY A.COMP_CODE,
                                 A.UNIT_CODE,
                                 A.PUBL,
                                 A.EDTN,
                                 K.REGION_CODE,
                                  A.SUP_RATE 
            ORDER BY A.COMP_CODE,
                                 A.UNIT_CODE,
                                 A.PUBL,
                                 A.EDTN,
                                 K.REGION_CODE,
                                 A.SUP_RATE 
            
            

                            SELECT
                                     A.COMP_CODE,
                                     A.UNIT_CODE,
                                     A.PUBL,
                                     DBO.CIR_GET_PUBL_NAME(A.COMP_CODE, A.PUBL) AS "PUBL_NAME",
                                     A.SUP_RATE,
                                     C.COPY_RATE,
                                     A.EDTN,
                                     DBO.CIR_GET_EDTN_NAME(A.COMP_CODE, A.EDTN) AS "EDITION",
                                     SUM(CONVERT(FLOAT, A.SUP_COPY)) AS "SUP_COPY",
                                     COUNT(A.EDTN) AS "DAYS",
                                     CAST(ROUND(SUM(CONVERT(FLOAT, A.SUP_COPY)) / CONVERT(FLOAT, COUNT(A.EDTN)),0) AS INTEGER) AVG_COPY,
                                     ROUND(SUM(CONVERT(FLOAT, A.SUP_COPY)) * SUP_RATE, 2) AS "COPY_AMT",
                                     SUM(CONVERT(FLOAT, ISNULL(C.APR_SHORT_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_UNSOLD, 0) + ISNULL(C.APR_BNR, 0))) AS "UNSOLD_COPY",
                                     SUM(CONVERT(FLOAT, ISNULL(C.APR_SHORT_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_UNSOLD, 0) + ISNULL(C.APR_BNR, 0))) * C.COPY_RATE AS "UNSOLD_AMT",
                                     ROUND((SUM(CONVERT(FLOAT, ISNULL(C.APR_SHORT_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_UNSOLD, 0) + ISNULL(C.APR_BNR, 0))) * 100) / CONVERT(FLOAT, SUM(CONVERT(FLOAT, A.SUP_COPY))), 2) AS "UNS_PER"
                            FROM  CIR_DBKSUP A,
                                 CIR_SUPPLY_TYPE_MAST B,
                                 CIR_UNSOLD_DTL C,
                                 CIR_AGMAST M 
                            WHERE     A.COMP_CODE  = B.COMP_CODE
                             AND    A.COMP_CODE  = M.COMP_CODE
                             AND    (A.COMP_CODE  = @pcomp_code
                             OR    @pcomp_code  IS NULL)
                             AND    A.COMP_CODE  = C.COMP_CODE
                             AND    A.UNIT_CODE  = C.UNIT_CODE
                             AND    A.UNIT_CODE  = M.UNIT
                             AND    (A.UNIT_CODE  = @punit_code
                             OR    @punit_code  IS NULL)
                             AND    A.PUBL  = C.PUBL
                             AND    (A.PUBL  = @ppubl
                             OR    @ppubl  IS NULL)
                             AND    A.EDTN  = C.EDTN
                             AND    (A.EDTN  = @pedtn
                             OR    @pedtn  IS NULL)
                             AND    (M.AG_TYPE  = @pag_type
                             OR    @pag_type  IS NULL)
                             AND    (M.AG_CLASS  = @pag_class
                             OR    @pag_class  IS NULL)
                             AND    A.AGCD  = M.AGCD
                             AND    A.DPCD  = M.DPCD
                             AND    A.SUP_RATE  = C.COPY_RATE
                             AND    A.SUP_TYPE_CODE  = B.SUP_TY_CODE
                             AND    (B.BILL_PAY  = @pbill_pay
                             OR    @pbill_pay  IS NULL)
                             AND    (A.SUPDATE  BETWEEN @VFROM_SUPDATE  AND  @VTILL_SUPDATE)
                            GROUP BY A.COMP_CODE,
                                 A.UNIT_CODE,
                                 A.PUBL,
                                 A.EDTN,
                                 A.SUP_RATE,
                                  C.COPY_RATE 
            ORDER BY A.COMP_CODE,
                                 A.UNIT_CODE,
                                 A.PUBL,
                                 A.EDTN,
                                 A.SUP_RATE 
            
            SET @LOOPPROCESSINGFLAG = 1
        END
        IF @preport_type = '4'  AND (@LOOPPROCESSINGFLAG = 0)
        BEGIN 
            

                            SELECT
                                     A.COMP_CODE,
                                     A.UNIT_CODE,
                                     A.PUBL,
                                     A.EDTN,
                                     DBO.CIR_GET_PUBL_NAME(A.COMP_CODE, A.PUBL) AS "PUBL_NAME",
                                     DBO.CIR_GET_EDTN_NAME(A.COMP_CODE, A.EDTN) AS "EDITION",
                                     SUM(CONVERT(FLOAT, A.SUP_COPY)) AS "SUP_COPY",
                                     A.SUP_RATE,
                                     COUNT(A.EDTN) AS "DAYS",
                                     DBO.CIR_GET_STATE(A.COMP_CODE, K.COUNTRY_CODE, K.STATE_CODE) AS "STATE_NAME",
                                     CAST(ROUND(SUM(CONVERT(FLOAT, A.SUP_COPY)) / CONVERT(FLOAT, COUNT(A.EDTN)),0) AS INTEGER) AVG_COPY,
                                     ROUND(SUM(CONVERT(FLOAT, A.SUP_COPY)) * SUP_RATE, 2) AS "COPY_AMT"
                            FROM  CIR_DBKSUP A,
                                 CIR_SUPPLY_TYPE_MAST B,
                                 CIR_AGMAST M,
                                 CIR_CITY_MAST K 
                            WHERE     A.COMP_CODE  = B.COMP_CODE
                             AND    A.COMP_CODE  = M.COMP_CODE
                             AND    (A.COMP_CODE  = @pcomp_code
                             OR    @pcomp_code  IS NULL)
                             AND    A.UNIT_CODE  = M.UNIT
                             AND    (A.UNIT_CODE  = @punit_code
                             OR    @punit_code  IS NULL)
                             AND    (M.BRANCH_CODE  = @pbranch_code
                             OR    @pbranch_code  IS NULL)
                             AND    (A.PUBL  = @ppubl
                             OR    @ppubl  IS NULL)
                             AND    (A.EDTN  = @pedtn
                             OR    @pedtn  IS NULL)
                             AND    (M.AG_TYPE  = @pag_type
                             OR    @pag_type  IS NULL)
                             AND    (M.AG_CLASS  = @pag_class
                             OR    @pag_class  IS NULL)
                             AND    A.AGCD  = M.AGCD
                             AND    A.DPCD  = M.DPCD
                             AND    A.SUP_TYPE_CODE  = B.SUP_TY_CODE
                             AND    (B.BILL_PAY  = @pbill_pay
                             OR    @pbill_pay  IS NULL)
                             AND    (A.SUPDATE  BETWEEN @VFROM_SUPDATE  AND  @VTILL_SUPDATE)
                            GROUP BY A.COMP_CODE,
                                 A.UNIT_CODE,
                                 A.PUBL,
                                 A.EDTN,
                                 K.COUNTRY_CODE,
                                 K.STATE_CODE,
                                  A.SUP_RATE 
            ORDER BY A.COMP_CODE,
                                 A.UNIT_CODE,
                                 A.PUBL,
                                 A.EDTN,
                                 K.COUNTRY_CODE,
                                 K.STATE_CODE,
                                 A.SUP_RATE 
            
            

                            SELECT
                                     A.COMP_CODE,
                                     A.UNIT_CODE,
                                     A.PUBL,
                                     DBO.CIR_GET_PUBL_NAME(A.COMP_CODE, A.PUBL) AS "PUBL_NAME",
                                     A.EDTN,
                                     DBO.CIR_GET_EDTN_NAME(A.COMP_CODE, A.EDTN) AS "EDITION",
                                     SUM(CONVERT(FLOAT, A.SUP_COPY)) AS "SUP_COPY",
                                     COUNT(A.EDTN) AS "DAYS",
                                     CAST(ROUND(SUM(CONVERT(FLOAT, A.SUP_COPY)) / CONVERT(FLOAT, COUNT(A.EDTN)),0) AS INTEGER) AVG_COPY,
                                     ROUND(SUM(CONVERT(FLOAT, A.SUP_COPY)) * SUP_RATE, 2) AS "COPY_AMT",
                                     A.SUP_RATE,
                                     C.COPY_RATE,
                                     SUM(CONVERT(FLOAT, ISNULL(C.APR_SHORT_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_UNSOLD, 0) + ISNULL(C.APR_BNR, 0))) AS "UNSOLD_COPY",
                                     SUM(CONVERT(FLOAT, ISNULL(C.APR_SHORT_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_UNSOLD, 0) + ISNULL(C.APR_BNR, 0))) * C.COPY_RATE AS "UNSOLD_AMT",
                                     ROUND((SUM(CONVERT(FLOAT, ISNULL(C.APR_SHORT_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_UNSOLD, 0) + ISNULL(C.APR_BNR, 0))) * 100) / CONVERT(FLOAT, SUM(CONVERT(FLOAT, A.SUP_COPY))), 2) AS "UNS_PER"
                            FROM  CIR_DBKSUP A,
                                 CIR_SUPPLY_TYPE_MAST B,
                                 CIR_UNSOLD_DTL C,
                                 CIR_AGMAST M 
                            WHERE     A.COMP_CODE  = B.COMP_CODE
                             AND    A.COMP_CODE  = M.COMP_CODE
                             AND    (A.COMP_CODE  = @pcomp_code
                             OR    @pcomp_code  IS NULL)
                             AND    A.COMP_CODE  = C.COMP_CODE
                             AND    A.UNIT_CODE  = C.UNIT_CODE
                             AND    A.UNIT_CODE  = M.UNIT
                             AND    (A.UNIT_CODE  = @punit_code
                             OR    @punit_code  IS NULL)
                             AND    A.PUBL  = C.PUBL
                             AND    (A.PUBL  = @ppubl
                             OR    @ppubl  IS NULL)
                             AND    A.EDTN  = C.EDTN
                             AND    (A.EDTN  = @pedtn
                             OR    @pedtn  IS NULL)
                             AND    (M.AG_TYPE  = @pag_type
                             OR    @pag_type  IS NULL)
                             AND    (M.AG_CLASS  = @pag_class
                             OR    @pag_class  IS NULL)
                             AND    A.AGCD  = M.AGCD
                             AND    A.DPCD  = M.DPCD
                             AND    A.SUP_RATE  = C.COPY_RATE
                             AND    A.SUP_TYPE_CODE  = B.SUP_TY_CODE
                             AND    (B.BILL_PAY  = @pbill_pay
                             OR    @pbill_pay  IS NULL)
                             AND    (A.SUPDATE  BETWEEN @VFROM_SUPDATE  AND  @VTILL_SUPDATE)
                            GROUP BY A.COMP_CODE,
                                 A.UNIT_CODE,
                                 A.PUBL,
                                 A.EDTN,
                                 A.SUP_RATE,
                                  C.COPY_RATE 
            ORDER BY A.COMP_CODE,
                                 A.UNIT_CODE,
                                 A.PUBL,
                                 A.EDTN,
                                 A.SUP_RATE
                                
            
            SET @LOOPPROCESSINGFLAG = 1
        END
        IF @preport_type = '5'  AND (@LOOPPROCESSINGFLAG = 0)
        BEGIN 
            

                            SELECT
                                     A.COMP_CODE,
                                     A.UNIT_CODE,
                                     A.PUBL,
                                     A.EDTN,
                                     DBO.CIR_GET_PUBL_NAME(A.COMP_CODE, A.PUBL) AS "PUBL_NAME",
                                     DBO.CIR_GET_EDTN_NAME(A.COMP_CODE, A.EDTN) AS "EDITION",
                                     SUM(CONVERT(FLOAT, A.SUP_COPY)) AS "SUP_COPY",
                                     A.SUP_RATE,
                                     COUNT(A.EDTN) AS "DAYS",
                                     DBO.CIR_GET_DIST(A.COMP_CODE, K.STATE_CODE, K.DIST_CODE) AS "DIST_NAME",
                                     CAST(ROUND(SUM(CONVERT(FLOAT, A.SUP_COPY)) / CONVERT(FLOAT, COUNT(A.EDTN)),0) AS INTEGER) AVG_COPY,
                                     ROUND(SUM(CONVERT(FLOAT, A.SUP_COPY)) * SUP_RATE, 2) AS "COPY_AMT"
                            FROM  CIR_DBKSUP A,
                                 CIR_SUPPLY_TYPE_MAST B,
                                 CIR_AGMAST M,
                                 CIR_CITY_MAST K 
                            WHERE     A.COMP_CODE  = B.COMP_CODE
                             AND    A.COMP_CODE  = M.COMP_CODE
                             AND    (A.COMP_CODE  = @pcomp_code
                             OR    @pcomp_code  IS NULL)
                             AND    A.UNIT_CODE  = M.UNIT
                             AND    (A.UNIT_CODE  = @punit_code
                             OR    @punit_code  IS NULL)
                             AND    (M.BRANCH_CODE  = @pbranch_code
                             OR    @pbranch_code  IS NULL)
                             AND    (A.PUBL  = @ppubl
                             OR    @ppubl  IS NULL)
                             AND    (A.EDTN  = @pedtn
                             OR    @pedtn  IS NULL)
                             AND    (M.AG_TYPE  = @pag_type
                             OR    @pag_type  IS NULL)
                             AND    (M.AG_CLASS  = @pag_class
                             OR    @pag_class  IS NULL)
                             AND    A.AGCD  = M.AGCD
                             AND    A.DPCD  = M.DPCD
                             AND    A.SUP_TYPE_CODE  = B.SUP_TY_CODE
                             AND    (B.BILL_PAY  = @pbill_pay
                             OR    @pbill_pay  IS NULL)
                             AND    (A.SUPDATE  BETWEEN @VFROM_SUPDATE  AND  @VTILL_SUPDATE)
                            GROUP BY A.COMP_CODE,
                                 A.UNIT_CODE,
                                 A.PUBL,
                                 A.EDTN,
                                 K.STATE_CODE,
                                 K.DIST_CODE,
                                  A.SUP_RATE 
            ORDER BY A.COMP_CODE,
                                 A.UNIT_CODE,
                                 A.PUBL,
                                 A.EDTN,
                                 K.STATE_CODE,
                                 K.DIST_CODE,
                                 A.SUP_RATE 
            
            

                            SELECT
                                     A.COMP_CODE,
                                     A.UNIT_CODE,
                                     A.PUBL,
                                     DBO.CIR_GET_PUBL_NAME(A.COMP_CODE, A.PUBL) AS "PUBL_NAME",
                                     A.SUP_RATE,
                                     C.COPY_RATE,
                                     A.EDTN,
                                     DBO.CIR_GET_EDTN_NAME(A.COMP_CODE, A.EDTN) AS "EDITION",
                                     SUM(CONVERT(FLOAT, A.SUP_COPY)) AS "SUP_COPY",
                                     COUNT(A.EDTN) AS "DAYS",
                                     CAST(ROUND(SUM(CONVERT(FLOAT, A.SUP_COPY)) / CONVERT(FLOAT, COUNT(A.EDTN)),0) AS INTEGER) AVG_COPY,
                                     ROUND(SUM(CONVERT(FLOAT, A.SUP_COPY)) * SUP_RATE, 2) AS "COPY_AMT",
                                     SUM(CONVERT(FLOAT, ISNULL(C.APR_SHORT_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_UNSOLD, 0) + ISNULL(C.APR_BNR, 0))) AS "UNSOLD_COPY",
                                     SUM(CONVERT(FLOAT, ISNULL(C.APR_SHORT_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_UNSOLD, 0) + ISNULL(C.APR_BNR, 0))) * C.COPY_RATE AS "UNSOLD_AMT",
                                     ROUND((SUM(CONVERT(FLOAT, ISNULL(C.APR_SHORT_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_UNSOLD, 0) + ISNULL(C.APR_BNR, 0))) * 100) / CONVERT(FLOAT, SUM(CONVERT(FLOAT, A.SUP_COPY))), 2) AS "UNS_PER"
                            FROM  CIR_DBKSUP A,
                                 CIR_SUPPLY_TYPE_MAST B,
                                 CIR_UNSOLD_DTL C,
                                 CIR_AGMAST M 
                            WHERE     A.COMP_CODE  = B.COMP_CODE
                             AND    A.COMP_CODE  = M.COMP_CODE
                             AND    (A.COMP_CODE  = @pcomp_code
                             OR    @pcomp_code  IS NULL)
                             AND    A.COMP_CODE  = C.COMP_CODE
                             AND    A.UNIT_CODE  = C.UNIT_CODE
                             AND    A.UNIT_CODE  = M.UNIT
                             AND    (A.UNIT_CODE  = @punit_code
                             OR    @punit_code  IS NULL)
                             AND    A.PUBL  = C.PUBL
                             AND    (A.PUBL  = @ppubl
                             OR    @ppubl  IS NULL)
                             AND    A.EDTN  = C.EDTN
                             AND    (A.EDTN  = @pedtn
                             OR    @pedtn  IS NULL)
                             AND    (M.AG_TYPE  = @pag_type
                             OR    @pag_type  IS NULL)
                             AND    (M.AG_CLASS  = @pag_class
                             OR    @pag_class  IS NULL)
                             AND    A.AGCD  = M.AGCD
                             AND    A.DPCD  = M.DPCD
                             AND    A.SUP_RATE  = C.COPY_RATE
                             AND    A.SUP_TYPE_CODE  = B.SUP_TY_CODE
                             AND    (B.BILL_PAY  = @pbill_pay
                             OR    @pbill_pay  IS NULL)
                             AND    (A.SUPDATE  BETWEEN @VFROM_SUPDATE  AND  @VTILL_SUPDATE)
                            GROUP BY A.COMP_CODE,
                                 A.UNIT_CODE,
                                 A.PUBL,
                                 A.EDTN,
                                 A.SUP_RATE,
                                  C.COPY_RATE 
            ORDER BY A.COMP_CODE,
                                 A.UNIT_CODE,
                                 A.PUBL,
                                 A.EDTN,
                                 A.SUP_RATE 
            
            SET @LOOPPROCESSINGFLAG = 1
        END
        IF (@LOOPPROCESSINGFLAG = 0)
        BEGIN 
            ---NONE
            
            

                            SELECT
                                     A.COMP_CODE,
                                     A.UNIT_CODE,
                                     A.PUBL,
                                     A.EDTN,
                                     DBO.CIR_GET_PUBL_NAME(A.COMP_CODE, A.PUBL) AS "PUBL_NAME",
                                     DBO.CIR_GET_EDTN_NAME(A.COMP_CODE, A.EDTN) AS "EDITION",
                                     SUM(CONVERT(FLOAT, A.SUP_COPY)) AS "SUP_COPY",
                                     A.SUP_RATE,
                                     COUNT(A.EDTN) AS "DAYS",
                                     CAST(ROUND(SUM(CONVERT(FLOAT, A.SUP_COPY)) / CONVERT(FLOAT, COUNT(A.EDTN)),0) AS INTEGER) AVG_COPY,
                                     ROUND(SUM(CONVERT(FLOAT, A.SUP_COPY)) * SUP_RATE, 2) AS "COPY_AMT"
                            FROM  CIR_DBKSUP A,
                                 CIR_SUPPLY_TYPE_MAST B,
                                 CIR_AGMAST M,
                                 CIR_CITY_MAST K 
                            WHERE     A.COMP_CODE  = B.COMP_CODE
                             AND    A.COMP_CODE  = M.COMP_CODE
                             AND    (A.COMP_CODE  = @pcomp_code
                             OR    @pcomp_code  IS NULL)
                             AND    A.UNIT_CODE  = M.UNIT
                             AND    (A.UNIT_CODE  = @punit_code
                             OR    @punit_code  IS NULL)
                             AND    (M.BRANCH_CODE  = @pbranch_code
                             OR    @pbranch_code  IS NULL)
                             AND    (A.PUBL  = @ppubl
                             OR    @ppubl  IS NULL)
                             AND    (A.EDTN  = @pedtn
                             OR    @pedtn  IS NULL)
                             AND    (M.AG_TYPE  = @pag_type
                             OR    @pag_type  IS NULL)
                             AND    (M.AG_CLASS  = @pag_class
                             OR    @pag_class  IS NULL)
                             AND    A.AGCD  = M.AGCD
                             AND    A.DPCD  = M.DPCD
                             AND    A.SUP_TYPE_CODE  = B.SUP_TY_CODE
                             AND    (B.BILL_PAY  = @pbill_pay
                             OR    @pbill_pay  IS NULL)
                             AND    (A.SUPDATE  BETWEEN @VFROM_SUPDATE  AND  @VTILL_SUPDATE)
                            GROUP BY A.COMP_CODE,
                                 A.UNIT_CODE,
                                 A.PUBL,
                                 A.EDTN,
                                  A.SUP_RATE 
            ORDER BY A.COMP_CODE,
                                 A.UNIT_CODE,
                                 A.PUBL,
                                 A.EDTN,
                                 A.SUP_RATE 
            
            

                            SELECT
                                     A.COMP_CODE,
                                     A.UNIT_CODE,
                                     A.PUBL,
                                     DBO.CIR_GET_PUBL_NAME(A.COMP_CODE, A.PUBL) AS "PUBL_NAME",
                                     A.SUP_RATE,
                                     C.COPY_RATE,
                                     A.EDTN,
                                     DBO.CIR_GET_EDTN_NAME(A.COMP_CODE, A.EDTN) AS "EDITION",
                                     SUM(CONVERT(FLOAT, A.SUP_COPY)) AS "SUP_COPY",
                                     COUNT(A.EDTN) AS "DAYS",
                                     CAST(ROUND(SUM(CONVERT(FLOAT, A.SUP_COPY)) / CONVERT(FLOAT, COUNT(A.EDTN)),0) AS INTEGER) AVG_COPY,
                                     ROUND(SUM(CONVERT(FLOAT, A.SUP_COPY)) * SUP_RATE, 2) AS "COPY_AMT",
                                     SUM(CONVERT(FLOAT, ISNULL(C.APR_SHORT_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_UNSOLD, 0) + ISNULL(C.APR_BNR, 0))) AS "UNSOLD_COPY",
                                     SUM(CONVERT(FLOAT, ISNULL(C.APR_SHORT_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_UNSOLD, 0) + ISNULL(C.APR_BNR, 0))) * C.COPY_RATE AS "UNSOLD_AMT",
                                     ROUND((SUM(CONVERT(FLOAT, ISNULL(C.APR_SHORT_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_UNSOLD, 0) + ISNULL(C.APR_BNR, 0))) * 100) / CONVERT(FLOAT, SUM(CONVERT(FLOAT, A.SUP_COPY))), 2) AS "UNS_PER"
                            FROM  CIR_DBKSUP A,
                                 CIR_SUPPLY_TYPE_MAST B,
                                 CIR_UNSOLD_DTL C,
                                 CIR_AGMAST M 
                            WHERE     A.COMP_CODE  = B.COMP_CODE
                             AND    A.COMP_CODE  = M.COMP_CODE
                             AND    (A.COMP_CODE  = @pcomp_code
                             OR    @pcomp_code  IS NULL)
                             AND    A.COMP_CODE  = C.COMP_CODE
                             AND    A.UNIT_CODE  = C.UNIT_CODE
                             AND    A.UNIT_CODE  = M.UNIT
                             AND    (A.UNIT_CODE  = @punit_code
                             OR    @punit_code  IS NULL)
                             AND    A.PUBL  = C.PUBL
                             AND    (A.PUBL  = @ppubl
                             OR    @ppubl  IS NULL)
                             AND    A.EDTN  = C.EDTN
                             AND    (A.EDTN  = @pedtn
                             OR    @pedtn  IS NULL)
                             AND    (M.AG_TYPE  = @pag_type
                             OR    @pag_type  IS NULL)
                             AND    (M.AG_CLASS  = @pag_class
                             OR    @pag_class  IS NULL)
                             AND    A.AGCD  = M.AGCD
                             AND    A.DPCD  = M.DPCD
                             AND    A.SUP_RATE  = C.COPY_RATE
                             AND    A.SUP_TYPE_CODE  = B.SUP_TY_CODE
                             AND    (B.BILL_PAY  = @pbill_pay
                             OR    @pbill_pay  IS NULL)
                             AND    (A.SUPDATE  BETWEEN @VFROM_SUPDATE  AND  @VTILL_SUPDATE)
                            GROUP BY A.COMP_CODE,
                                 A.UNIT_CODE,
                                 A.PUBL,
                                 A.EDTN,
                                 A.SUP_RATE,
                                  C.COPY_RATE 
            ORDER BY A.COMP_CODE,
                                 A.UNIT_CODE,
                                 A.PUBL,
                                 A.EDTN,
                                 A.SUP_RATE 
            
        END
   

        SET NOCOUNT OFF

    END







//////////////////////////////////////////////////////////end//////////////////////////////////////

/////////////////////isseue no 7240/////////////////

USE [abhi]
GO
/****** Object:  StoredProcedure [dbo].[cir_account_mast_fa_receipt_credit_head_p]    Script Date: 04/27/2012 11:33:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[cir_account_mast_fa_receipt_credit_head_p]
	@pcompcode                                VARCHAR(20) ,
	@pdoctype                                 VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000),
	@pextra3                                  VARCHAR(4000) ,
	@pextra4                                  VARCHAR(4000) ,
	@pextra5                                  VARCHAR(4000) ,
	@pextra6                                  VARCHAR(4000)
AS 

		SELECT *
		FROM  fa_acc_mast 
		WHERE	 comp_code  = @pcompcode
		 AND	((UPPER(acc_name)  like  UPPER(@pextra1) + '%') OR	(@pextra1  is null))
		ORDER BY acc_name 
		
////////////end of isseue no 7240////////////////////////

////////////////////////////////////deepika 28/04/2012 sent by Laxman sir////////////////////////////


                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE Cir_Gen_Code_receipt_p
    @pcompcode			VARCHAR(40) ,
    @pbranchcode        VARCHAR(40) ,
    @pdoctype           VARCHAR(40) ,
    @precptdt           VARCHAR(40) ,
    @pdateformat        VARCHAR(40) ,
    @pextra1            VARCHAR(200) ,
    @pextra2            VARCHAR(20) --for distribution agency
AS 
    DECLARE @vno                                      NUMERIC(20) 
    DECLARE @vrecptno                                 VARCHAR(15) 
    DECLARE @v_dt                                     DATETIME 
    DECLARE @v_sess_id                                NUMERIC(20) 

    set @v_sess_id=(SELECT top 1 session_id  FROM sys.dm_exec_requests where sql_handle is not null);
    
    SET @v_dt  =   dbo.convert_user_date('/', @precptdt,@pdateformat) 

    if UPPER(@pextra2)='D' begin
		SELECT @vno  =  CONVERT(NUMERIC(8, 2), MAX(SUBSTRING(recptno, 5, 8))) + 1
		FROM  cir_rcphdr_dis 
		WHERE     comp_code  = @pcompcode
		 AND    doctype  = @pdoctype
		 --AND    CONVERT(VARCHAR(23), recptdt)  = CONVERT(VARCHAR(23), @v_dt)
		 and replace(substring(CONVERT(VARCHAR(10), recptdt,2),1,5),'.','') = replace(substring(CONVERT(VARCHAR(10), @v_dt,2),1,5),'.','')
		 AND branch_code  = @pbranchcode
	end
    else begin
		SELECT @vno  =  CAST( MAX(SUBSTRING(recptno, 5, 8))AS NUMERIC) + 1--CONVERT(NUMERIC(8, 2), MAX(SUBSTRING(recptno, 5, 8))) + 1
		FROM  cir_rcphdr 
		WHERE comp_code  = @pcompcode
		AND doctype  = @pdoctype
		--AND  CONVERT(VARCHAR(23), recptdt)  = CONVERT(VARCHAR(23), @v_dt)
		and replace(substring(CONVERT(VARCHAR(10), recptdt,2),1,5),'.','') = replace(substring(CONVERT(VARCHAR(10), @v_dt,2),1,5),'.','')
		AND  branch_code  = @pbranchcode
	end
    
    IF ISNULL(@vno, 0)= 0 BEGIN 
			SET @vrecptno  = @pbranchcode + '-' + REPLACE(CONVERT(VARCHAR(5), @v_dt, 2), '.', '')+ '0001' 
	END
    ELSE BEGIN 
		SET @vrecptno  = @pbranchcode + '-' + dbo.fnPadLeft('0',8,@vno) 
	END

    SELECT @vrecptno as VAR_CODE

/////////////////////////////////////////////////////end////////////////////////////////////////////////////////


///////////////////////////////////Deepika 30/04/2012 sent by Ashok sahani sir/////////////////////////////////////

ALTER
PROCEDURE [dbo].[cir_edtion_bind_cir_sub_edtion_bind_p]

@pcomp_code
VARCHAR(20) ,

@ppubl_code
VARCHAR(20) ,

@pedtn_code
VARCHAR(20) ,

@psubedtn_code
VARCHAR(20) ,

@pdateformat
VARCHAR(20) ,

@pextra1
VARCHAR(4000) ,

@pextra2
VARCHAR(4000)

AS

BEGIN

select
* from cir_edtn_mast

where
comp_code = @pcomp_code

and
(publ = @ppubl_code or @ppubl_code is null OR @ppubl_code = '' )

and
(edtn=@psubedtn_code or @psubedtn_code is null OR @psubedtn_code = '' )

and
(main_edtn=@pedtn_code or @pedtn_code is null OR @pedtn_code = '')

and
edtn<>main_edtn and ISNULL(freeze_flag,'N')='N'

and
(unit_code=@pextra2 or @pextra2 is null or @pextra2 = '')

order
by edtn_name;

END


//////////////////////////////////////////////end/////////////////////////////////////////////////////////////////

//////////////////////////////////////Deepika 30/04/2012 Sent By Amit Tomer Sir////////////////////////////


ALTER
PROCEDURE [dbo].[cir_drop_point_bind]

@pcomp_code
as varchar(200),

@punit_code
as varchar(200),

@pcity_code
as varchar(200),

@pdateformat
as varchar(200),

@pextra1
as varchar(200),

@pextra2
as varchar(200)

AS

select cir_drop_point_mast.*,dbo.cir_get_dist(@pcomp_code,cir_city_mast.state_code,cir_city_mast.dist_code) DIST_NAME

from
cir_drop_point_mast,cir_city_mast

where cir_drop_point_mast.comp_code=cir_city_mast.comp_code and

cir_drop_point_mast
.comp_code='HT001'

and
cir_drop_point_mast.city_code=cir_city_mast.city_code and

cir_drop_point_mast
.unit_code='DEL' and

(( cir_drop_point_mast.city_code = @pcity_code) or (replace(@pcity_code,null,'0')='0') or (@pcity_code=''))

-- and ISNULL(freeze_flag,'N')='N'

and
((upper(DROP_POINT_NAME) like upper(@pextra1)+'%') or (@pextra1 is null))

order by drop_point_name


//////////////////////////////////////////end/////////////////////////////////////////////////////////////////////////


///////////////////////////////Deepika 30/04/2012 sent By Laxman Sir//////////////////////////////////////////////////////////

CREATE FUNCTION  cir_get_state1(
@pcomp_code		as varchar(100),
@pstate_code as varchar(100))  
returns varchar(200) 
AS  
BEGIN 

DECLARE @vstate_name VARCHAR(4000)

select @vstate_name=State_Name FROM state_mst where Comp_Code=@pcomp_code 
	and State_Code=@pstate_code
	   
RETURN isnull(@vstate_name,'NA')
END


/////////////////////////////////////////


                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE cir_rep_supply_cir_rep_supply1
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
	@pextra9            VARCHAR(40) ,
	@pextra10           VARCHAR(40)
AS 
BEGIN
	DECLARE @vfrom_supdate	varchar(20);
	DECLARE @vtill_supdate  varchar(20);
	declare @vsup_seq_no	int
	
	DECLARE cur_sup_type cursor LOCAL FOR 
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

if @pextra8='1' Begin--for route
	set @vquery='select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,d.route_code ROUTE_CODE,dbo.cir_get_route_name(d.comp_code,d.unit_code,d.route_code) ROUTE_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
		substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",dbo.cir_get_city(d.comp_code,m.city_code) "CITY NAME",
		isnull(dbo.CIR_GET_NAME_CIR_CITY(d.comp_code,m.city_code,2,null,null,null),''NA'') "CITY ONAME", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) "DROP_POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
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
			group by d.comp_code,d.unit_code,d.publ,d.edtn,d.route_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code 
			order by d.comp_code,d.unit_code,d.publ,d.edtn,d.route_code,d.agcd,d.dpcd'
                
		print @vquery 
		EXEC (@vquery)
end
if @pextra8='2' Begin----for  branch
	set @vquery='select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.branch_code BRANCH_CODE,dbo.cir_get_branch(d.comp_code,m.branch_code) BRANCH_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
		substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",dbo.cir_get_city(d.comp_code,m.city_code) "CITY NAME",
		isnull(dbo.CIR_GET_NAME_CIR_CITY(d.comp_code,m.city_code,2,null,null,null),''NA'') "CITY ONAME", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) "DROP_POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
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
		    group by d.comp_code,d.unit_code,d.publ,d.edtn,m.branch_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code 
		    order by d.comp_code,d.unit_code,d.publ,d.edtn,branch_name,d.agcd,d.dpcd'
                
		print @vquery 
		EXEC (@vquery)
end

if @pextra8='3' Begin----for  zone
	set @vquery='select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,c.zone_code ZONE_CODE,
	dbo.cir_get_zone_name(d.comp_code,c.zone_code) ZONE_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
		substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",dbo.cir_get_city(d.comp_code,m.city_code) "CITY NAME",
		isnull(dbo.CIR_GET_NAME_CIR_CITY(d.comp_code,m.city_code,2,null,null,null),''NA'') "CITY ONAME", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) "DROP_POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
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
			group by d.comp_code,d.unit_code,d.publ,d.edtn,c.zone_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code 
			order by d.comp_code,d.unit_code,d.publ,d.edtn,zone_code,d.agcd,d.dpcd'
                
		print @vquery 
		EXEC (@vquery)
end

if @pextra8='4' Begin----for  region
	set @vquery='select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.branch_code BRANCH_CODE,dbo.cir_get_branch(d.comp_code,m.branch_code) BRANCH_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
		substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",dbo.cir_get_city(d.comp_code,m.city_code) "CITY NAME",
		isnull(dbo.CIR_GET_NAME_CIR_CITY(d.comp_code,m.city_code,2,null,null,null),''NA'') "CITY ONAME", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) "DROP_POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
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
        group by d.comp_code,d.unit_code,d.publ,d.edtn,m.branch_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code order by d.comp_code,d.unit_code,d.publ,d.edtn,branch_name,d.agcd,d.dpcd'
                
		print @vquery 
		EXEC (@vquery)
end

if @pextra8='5' Begin----for  district
	set @vquery='select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.dist_code DIST_CODE,dbo.cir_get_name_cir_district(d.comp_code,m.dist_code,''1'',null,null,null) DIST_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
		substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",dbo.cir_get_city(d.comp_code,m.city_code) "CITY NAME",
		isnull(dbo.CIR_GET_NAME_CIR_CITY(d.comp_code,m.city_code,2,null,null,null),''NA'') "CITY ONAME", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) "DROP_POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
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
        group by d.comp_code,d.unit_code,d.publ,d.edtn,m.dist_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code order by d.comp_code,d.unit_code,d.publ,d.edtn,dist_code,d.agcd,d.dpcd'
                
		print @vquery 
		EXEC (@vquery)
end

if @pextra8='6' Begin----for Taluka
	set @vquery='select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.tehsil_taluka TALUKA_CODE,dbo.cir_get_taluka(d.comp_code,m.tehsil_taluka) TALUKA_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
		substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",dbo.cir_get_city(d.comp_code,m.city_code) "CITY NAME",
		isnull(dbo.CIR_GET_NAME_CIR_CITY(d.comp_code,m.city_code,2,null,null,null),''NA'') "CITY ONAME", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) "DROP_POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
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
        group by d.comp_code,d.unit_code,d.publ,d.edtn,m.tehsil_taluka,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code order by d.comp_code,d.unit_code,d.publ,d.edtn,taluka_code,d.agcd,d.dpcd'
                
		print @vquery 
		EXEC (@vquery)
end
if @pextra8='7' Begin----for State
	set @vquery='select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.state_code STATE_CODE,dbo.cir_get_state1(d.comp_code,m.state_code) STATE_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
		substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",c.city_name "CITY NAME",
		c.city_oname "CITY ONAME", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) "DROP_POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
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
        group by d.comp_code,d.unit_code,d.publ,d.edtn,m.state_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code,c.city_name,c.city_Oname order by d.comp_code,d.unit_code,d.publ,d.edtn,m.state_code,d.agcd,d.dpcd'
                
		print @vquery 
		EXEC (@vquery)
end
		SET @vquery1  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
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
		group by d.comp_code,d.unit_code order by d.comp_code,d.unit_code'
		print @vquery1
		EXEC (@vquery1)
		
if @pextra8='1' Begin--for route
		SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,d.route_code ROUTE_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
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
		group by d.comp_code,d.unit_code,d.publ,d.edtn,d.route_code order by d.comp_code,d.unit_code,d.publ,d.edtn,d.route_code'
		print @vquery2
		EXEC (@vquery2)
end

if @pextra8='2' Begin--for branch
		SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.branch_code BRANCH_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
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
		group by d.comp_code,d.unit_code,d.publ,d.edtn,m.branch_code order by d.comp_code,d.unit_code,d.publ,d.edtn,m.branch_code'
		print @vquery2
		EXEC (@vquery2)
end

if @pextra8='3' Begin--for Zone
		SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,c.zone_code ZONE_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
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
		group by d.comp_code,d.unit_code,d.publ,d.edtn,c.zone_code order by d.comp_code,d.unit_code,d.publ,d.edtn,c.zone_code'
		print @vquery2
		EXEC (@vquery2)
end

if @pextra8='4' Begin--for region
	SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,c.region_code REGION_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
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
	group by d.comp_code,d.unit_code,d.publ,d.edtn,c.region_code order by d.comp_code,d.unit_code,d.publ,d.edtn,c.region_code'
	print @vquery2
	EXEC (@vquery2)
end

if @pextra8='5' Begin--for District
		SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.dist_code DIST_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
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
		group by d.comp_code,d.unit_code,d.publ,d.edtn,m.dist_code order by d.comp_code,d.unit_code,d.publ,d.edtn,m.dist_code'
		print @vquery2
		EXEC (@vquery2)
end

if @pextra8='6' Begin--for Taluka
	SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.tehsil_taluka TALUKA_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
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
	group by d.comp_code,d.unit_code,d.publ,d.edtn,m.tehsil_taluka order by d.comp_code,d.unit_code,d.publ,d.edtn,m.tehsil_taluka'
	print @vquery2
	EXEC (@vquery2)
end

if @pextra8='7' Begin--for state
	SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.state_code STATE_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
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
	group by d.comp_code,d.unit_code,d.publ,d.edtn,m.state_code order by d.comp_code,d.unit_code,d.publ,d.edtn,m.state_code'
	print @vquery2
	EXEC (@vquery2)
end

SET @vquery3  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,'+@vvar+','+@vvar_sum+' TOTAL 
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
			group by d.comp_code,d.unit_code,d.publ,d.edtn order by d.comp_code,d.unit_code,d.publ,d.edtn'
print @vquery3
EXEC (@vquery3)

SET @vquery4  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,'+@vvar+','+@vvar_sum+' TOTAL 
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
		group by d.comp_code,d.unit_code,d.publ order by d.comp_code,d.unit_code,d.publ'
print @vquery4
EXEC (@vquery4)


DEALLOCATE cur_sup_type

END

///////////////////////////////////////////////////////

                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE cir_rep_supply_temp
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
@pextra8            as varchar(200),--report type filter 1 for routewise,2 for branchwise,3 for zonewise,4 for regionwise,5 for district,6 for talukaiwse,other than statewise
@pextra9            as varchar(200),
@pextra10           as varchar(200)

AS

declare @vfrom_supdate    varchar(20);
declare @vtill_supdate    varchar(20);
declare @rec_sup_type		as varchar(200) 
declare @rec_sup_type_sum	as varchar(200) 
declare @rec_sup_seq_no		as int

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

	declare @vvar		varchar(4000)
	declare @vvar_sum	varchar(4000)
	declare @vquery		varchar(8000)

	set @vvar=''
	set @vvar_sum=''
 
	set @vfrom_supdate=convert(varchar(20),@pfrom_supdate,101)
	set @vtill_supdate=convert(varchar(20),@ptill_supdate,101)

	print('@vfrom_supdate')print(@vfrom_supdate);
	print('@vtill_supdate')print(@vtill_supdate);

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

	print('@vvar')print(@vvar)
	print('@vvar_sum')print(@vvar_sum)

	set @vvar    =substring(@vvar,1,len(@vvar)-1)
	set @vvar_sum=substring(@vvar_sum,1,len(@vvar_sum)-1)
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

if @pextra8='1' begin----for route 

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
		group by d.comp_code,d.unit_code,d.publ,d.route_code
		order by d.comp_code,d.unit_code,d.publ,route_name';

end ------ route	
else if @pextra8='2' begin----for  branch
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
 group by d.comp_code,d.unit_code,m.branch_code
order by d.comp_code,d.unit_code,branch_name'

end ---- branch		
else if @pextra8='3' begin----for  zone  
 
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
	group by d.comp_code,d.unit_code,c.zone_code
	order by d.comp_code,d.unit_code,zone_name';

end  ---- zone
else if @pextra8='4' begin----for  region   
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
	group by d.comp_code,d.unit_code,c.region_code
	order by d.comp_code,d.unit_code,region_name';

end ---- end  region
else if @pextra8='5' begin----for  district

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
		group by d.comp_code,d.unit_code,m.state_code,m.dist_code
		order by d.comp_code,d.unit_code,m.state_code,district_name	'

end  ---- district
else if @pextra8='6' begin----for  tehsil_taluka

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
	group by d.comp_code,d.unit_code,m.tehsil_taluka
	order by d.comp_code,d.unit_code,taluka_name';
end  ----for  tehsil_taluka

else begin
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
	group by d.comp_code,d.unit_code,m.country_code,m.state_code
	order by d.comp_code,d.unit_code,m.country_code,state_name';
end


print(@vquery)
exec(@vquery)


/////////////////////////////////////////////////////end///////////////////////////////////////////////////////////////


///////////////////////////Deepika 02/04/2012 sent by Laxman Sir////////////////////////////////////////////////////////

                                                                     
                                                                     
                                                                     
                                             
ALTER FUNCTION cir_get_waste_rate_catg
(@pcomp_code		VARCHAR(20) ,
 @punit_code        VARCHAR(20) ,
 @pedtn_code        VARCHAR(20) ,
 @psup_date         DATETIME  ,
 @pdateformat       VARCHAR(20),
 @pwaste_catg		int,
 @pextra1			VARCHAR(200),
 @pextra2			VARCHAR(200))
RETURNS  NUMERIC(10,4) 
AS 

BEGIN
	If @pwaste_catg='' Begin
		set @pwaste_catg = null
	End
	
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
			publ  = @v_publ AND	edtn  = @pedtn_code AND	valid_from  <= @psup_date
			and ISNULL(waste_catg_code,0)=ISNULL(@pwaste_catg,ISNULL(waste_catg_code,0)))
            and ISNULL(waste_catg_code,0)=ISNULL(@pwaste_catg,ISNULL(waste_catg_code,0))			

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

////////////////////////////////////////
                                                                     
                                                                     
                                                                     
                                             
CREATE FUNCTION AD_GET_EXEC_TEAMNAME (
	@pcomp_code as varchar(20),
	@pteam_code as varchar(20))
	RETURNS VARCHAR(200) AS
Begin
declare @vteam_name  varchar(200)

	select  @vteam_name="Team_Name" from adv_exec_master 
		where "Comp_Code"=@pcomp_code and "Team_Code"=@pteam_code

  return isnull(@vteam_name,'NOT DEFINE')
END

//////////////////////////////////////////////////////

                                                                     
                                                                     
                                                                     
                                             
ALTER procedure cir_fetch_edtnwise_rate_change
    @pcompcode       as varchar(20),
    @punitcode       as varchar(20),
    @ppublcode       as varchar(20),
    @pmedtncode      as varchar(20),
    @pedtncode       as varchar(20),
    @pdatefrom       as varchar(20),
    @pdatetill       as varchar(20),
    @puserid         as varchar(20),
    @pdateformat     as varchar(20),
    @pextra1         as varchar(200),
    @pextra2         as varchar(200),
    @pextra3         as varchar(200),
    @pextra4         as varchar(200),
    @pextra5         as varchar(200)
As
    declare @v_frdt      datetime
    declare @v_todt      datetime
Begin

	If @punitcode='' Begin
		set @punitcode=null
	End	
	
	If @ppublcode='' Begin
		set @ppublcode=null
	End	
	
	If @pmedtncode='' Begin
		set @pmedtncode=null
	End

	If @pedtncode='' Begin
		set @pedtncode=null
	End	
    set @v_frdt      =dbo.convert_user_date('/',@pdatefrom,@pdateformat)
    set @v_todt      =dbo.convert_user_date('/',@pdatetill,@pdateformat)
    
    select distinct x.comp_code as "COMP_CODE",x.unit_code AS "UNIT_CODE",x.publ AS "PUBL",x.publ_name AS "PUBL_NAME", 
    x.edtn AS "EDTN",x.edtn_name AS "EDTN_NAME",x.main_edtn AS "MAIN_EDTN",x.main_edtn_name AS "MAIN_EDTN_NAME", 
    x.supdate AS "SUPDATE",x.sup_rate AS "SUP_RATE" ,x.act_rate as "ACT_RATE"
    from (select distinct d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",d.publ AS "PUBL",p.publ_name AS "PUBL_NAME", 
    d.edtn AS "EDTN",e.edtn_name AS "EDTN_NAME",e.main_edtn AS "MAIN_EDTN",dbo.cir_get_edtn_name(d.comp_code,e.main_edtn) AS "MAIN_EDTN_NAME", 
    d.supdate AS "SUPDATE",d.sup_rate AS "SUP_RATE" ,dbo.cir_get_edtn_rate(d.comp_code,d.unit_code,d.edtn,
    CASE WHEN @pdateformat='mm/dd/yyyy' THEN CONVERT(varchar(20),d.supdate,101)
	WHEN @pdateformat='dd/mm/yyyy' THEN CONVERT(varchar(20),d.supdate,103)
	WHEN @pdateformat='yyyy/mm/dd' THEN CONVERT(varchar(20),d.supdate,111) END,@pdateformat) AS "ACT_RATE"
    from cir_dbksup d,cir_agmast m,cir_edtn_mast e,cir_publ_mast p
    where d.comp_code=m.comp_code and d.comp_code=p.comp_code and d.comp_code=e.comp_code and d.comp_code=@pcompcode and
    d.unit_code=m.unit and d.unit_code=isnull(@punitcode,d.unit_code) and d.publ=p.publ and d.publ=e.publ and d.publ=isnull(@ppublcode,d.publ) and 
    d.edtn=e.edtn and d.edtn=isnull(@pedtncode,d.edtn) and d.agcd=m.agcd and d.dpcd=m.dpcd and supdate between @v_frdt and @v_todt and 
    e.main_edtn=isnull(@pmedtncode,e.main_edtn))x
    where isnull(x.sup_rate,0)<>isnull(x.act_rate,0)
    order by comp_code,unit_code,publ_name,main_edtn_name,edtn_name,supdate;


End

////////////////////////////////////////////////////////end///////////////////////////////////////////////////////////

////////////////////////////////for Issue no 6655 03/04/2012////////////////////////////////////////////////////////////////////



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

set @v_frdt   =@pfromdate
set @v_todt   =@ptilldate

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
and        b.supdate>=@v_frdt and b.supdate<=@v_todt 
and b.publ=c.publ 
--and b.publ=isnull(@ppublcode,b.publ) 
and b.edtn=c.edtn and  b.edtn=isnull(@pedtncode, b.edtn) 
and c.main_edtn=isnull(@pmedtncode, c.main_edtn) 
--and        isnull(a.abc_citycode,a.city_code)=d.city_code 
and (d.zone_code=@pzonecode or @pzonecode is null OR  @pzonecode='') 
and (d.region_code=@pregioncode  or @pregioncode is null OR  @pregioncode='')
  /*******************new added*************/
        and (d.dist_code=@pdistcode  or @pdistcode is null or @pdistcode='')
        and (d.state_code=@pstatecode  or @pstatecode is null or @pstatecode='')
        and (a.branch_code=@pbrancode  or @pbrancode is null or @pbrancode='')
         and (a.ag_type=@pagtype  or @pagtype is null or @pagtype='')
           and (b.sup_copy=@psup_copy  or @psup_copy is null or @psup_copy='')
           /*******************new added*************/
        group by a.comp_code,a.unit,a.agcd,a.dpcd,a.ag_name,a.country_code,a.state_code,a.dist_code,isnull(a.abc_citycode,a.city_code),d.city_name,d.zone_code,d.region_code,a.tehsil_taluka,a.branch_code;
 



begin


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
   
IF (@PBREAKON='3')
 BEGIN --STATE WISE
       
        SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,
        A.STATE_CODE STATE_NAME,
        A.DIST_CODE DIST_NAME,
        A.CITY_CODE CITY_NAME,
        A.TALUKA_CODE TALUKA_NAME,SUM(A.SUPPLY_COPY) GROSS_COPY,
        0 LESS_COPY,0 ABOVE_COPY
        FROM #CIR_TEMP_BILL_COLLECTION A 

        GROUP BY A.COMP_CODE,A.UNIT_CODE,A.STATE_CODE,A.CITY_CODE,A.DIST_CODE,
        A.TALUKA_CODE
        ORDER BY COMP_CODE,UNIT_CODE,STATE_NAME,CITY_NAME;

       
        SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,
        A.STATE_CODE STATE_NAME,SUM(A.SUPPLY_COPY) GROSS_COPY,
        0 LESS_COPY,0 ABOVE_COPY
        FROM #CIR_TEMP_BILL_COLLECTION A 

        GROUP BY A.COMP_CODE,A.UNIT_CODE,A.STATE_CODE
        ORDER BY COMP_CODE,UNIT_CODE,STATE_NAME;
END
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



//////////////////////////////////////end/////////////////////////////////////////////////////////////////////

////////////////////add by prachi for 5360 (03-may-2012)///////////////////


ALTER PROCEDURE [dbo].[CIR_get_report_table_bind]
	@compcode			VARCHAR(400) ,
	@punit              VARCHAR(400) ,
	@pchannel           VARCHAR(400) ,
	@pextra1            VARCHAR(400) ,
	@pextra2            VARCHAR(400) ,
	@pextra3            VARCHAR(400) ,
	@pextra4            VARCHAR(400) ,
	@pextra5            VARCHAR(400) ,
	@pextra6            VARCHAR(400) ,
	@pextra7            VARCHAR(400) ,
	@pextra8            VARCHAR(400) ,
	@pextra9            VARCHAR(400) ,
	@pextra10           VARCHAR(400) 
AS 
	BEGIN
		SELECT
				 SEQ_NO,
				 TABLE_NAME,
				 TABLE_DESC
		FROM  cir_select_table 
		WHERE	 flag  = 'Y' and (upper( table_desc) like upper(@pextra1) +'%' or @pextra1 is null or @pextra1 ='') 
		ORDER BY order_seq_no 
		
		
		SELECT GETDATE()
	
		SELECT GETDATE()
		
		SELECT GETDATE()
		SELECT GETDATE()

END


////////////////////add by prachi for 5360 (03-may-2012)///////////////////


///////////////////////////////////////Issue no 7294 03/05/2012////////////////////////////////////////

                                                         
                                                                     
                                             
ALTER PROCEDURE [dbo].[cir_rep_collection_cir_rep_collection_det_p]
	@pcompcode                                VARCHAR(20) ,
	@punitcode                                VARCHAR(20) ,
	@pbrachcode                               VARCHAR(20) ,
	@pdoctype                                 VARCHAR(20) ,
	@ppaymode                                 VARCHAR(20) ,
	@pactype                                  VARCHAR(20) ,
	@pfromdate                                datetime ,
	@ptodate                                  datetime ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(200) ,
	@pextra2                                  VARCHAR(200) 
AS 
		DECLARE @v_frdt		DATETIME 
		DECLARE @v_todt     DATETIME 
		DECLARE	@A			INT
		DECLARE	@v_a		as varchar(1000)
	Begin
		SET @v_frdt  = @pfromdate--DBO.CONVERT_USER_DATE('/', @pfromdate,@pdateformat)
		--SET @v_frdt  = DBO.CONVERT_USER_DATE('/', @pfromdate,@pdateformat)
		SET @v_todt  =@ptodate--- DBO.CONVERT_USER_DATE('/', @ptodate,@pdateformat)
		/*if @pdoctype is not null Begin
            SET @a=dbo.FN_SPLITFIELD(@pdoctype ,',')
        end*/
		create  table #Results(SegmentNum INT, EditionName  VARCHAR(255))
		Begin
			if (@pdoctype is not null) begin
			insert into #Results select * from dbo.Fn_Splitfield(@pdoctype,',')
			End
		End
print 'amit'
        select A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.RECPTDT RECPTDT,A.RECPTNO RECPTNO,A.DOCTYPE DOCTYP,A.AGCD AGCD,
        A.DPCD DPCD,B.AG_NAME AS AGENCY_NAME,B.AG_NAME_OTH_LANG AGNAME_OTH_LANG,B.CITY_CODE,dbo.CIR_GET_CITY(B.COMP_CODE,B.CITY_CODE) CITY_NAME,
        B.TEHSIL_TALUKA TALUKA_CODE,dbo.CIR_GET_TALUKA(B.COMP_CODE,B.TEHSIL_TALUKA) TALUKA_NAME,A.VOUCHERNO VOUCHERNO,A.CHNO CHNO,A.CHDT CHDT,
       SUBSTRING(ISNULL((SELECT BANKNAME AS "bankname" FROM CIR_BANK_MAST WHERE COMP_CODE=A.COMP_CODE AND BANKCODE=A.CHBANK),A.CHBANK),1,15) AS BANK,ABS(A.AMOUNT) AMOUNT,
         dbo.INITCAP(A.REMARK) REMARK,A.ACHD ACHD,
       CASE WHEN A.DOCTYPE='RCR' THEN 
        (SELECT "Payment_Mode_Name" FROM PAYMENT_MODE_MAST WHERE "Pay_Mode_Code"=A.REASON)
        ELSE 
        (SELECT REASON_NAME FROM CIR_REASON_MST WHERE COMP_CODE=A.COMP_CODE AND REASON_CODE=A.REASON) END AS REASON,
        A.BRANCH_CODE BRANCH_CODE,(SELECT DISTINCT "Branch_Name" FROM BRANCH_MST WHERE "Branch_Code"=A.BRANCH_CODE) BRANCH_NAME,
        SUBSTRING(dbo.FA_GET_ACCOUNT_NAME(A.COMP_CODE,A.RCDP),1,15) DEBIT_HEAD,(SELECT DISTINCT CASE WHEN DSIGN=-1 THEN 'C' ELSE 'D' END DSIGN FROM CIR_DOCMST WHERE DOC_TYPE=A.DOCTYPE) DSIGN,
        A.USERID,(SELECT isnull(FIRSTNAME,"username")+' '+LASTNAME FROM LOGIN WHERE "userid"=A.USERID) CREATED_BY, A.CREATION_DATE CREATION_DATE, A.PROV_REC_NO PROV_REC_NO, A.PROV_REC_DT PROV_REC_DATE,
        A.REMARK_OTH REMARK_OTH
        from cir_rcphdr a,cir_agmast b
        where a.comp_code=b.comp_code and a.comp_code=@pcompcode  and a.unit_code=b.unit and a.unit_code =@punitcode and
              a.agcd=b.agcd and a.dpcd=b.dpcd and (a.agcd=@pextra1 or @pextra1 is null or @pextra1='') and (a.dpcd=@pextra2 or @pextra2 is null or @pextra2='') and
              a.recptdt between @v_frdt and @v_todt and --(a.doctype  = @pdoctype or @pdoctype is null or @pdoctype='' )
			 -- (a.doctype=@pdoctype or @pdoctype is null OR @pdoctype='') 
			  (a.doctype in (SELECT EditionName FROM #Results) or @pdoctype is null OR @pdoctype='')
			   and
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
			AND	(a.doctype  = @pdoctype or @pdoctype is null or @pdoctype='' )
			--AND (a.doctype  in (SELECT EditionName FROM #Results) or @pdoctype is null OR @pdoctype='')
			AND	(a.reason  = @ppaymode OR	@ppaymode  is null OR	@ppaymode = '')
			AND	(ISNULL(a.achd, 'NM')  = @pactype OR	@pactype  is null OR	@pactype = '')
			AND	(a.branch_code  = @pbrachcode OR	@pbrachcode  is null  OR	@pbrachcode = '')
		 ORDER BY a.comp_code, a.recptdt,a.doctype, a.recptno */
		
	print 'amit1'	
		SELECT e.comp_code, e.doctype, e.reason, SUM(CONVERT(FLOAT, e.db_amount)) db_amount, 
        SUM(CONVERT(FLOAT, e.cr_amount)) cr_amount  FROM 
               (SELECT d.comp_code, d.doctype, d.reason,
		        CASE d.debit WHEN 'D' THEN SUM(CONVERT(FLOAT, d.amount)) END db_amount,				 
		        CASE d.credit WHEN 'C' THEN SUM(CONVERT(FLOAT, d.amount)) END cr_amount
		        FROM (SELECT a.comp_code comp_code,
		        (SELECT DOC_NAME  FROM dbo.CIR_DOCMST WHERE COMP_CODE=a.comp_code  AND DOC_TYPE=a.doctype)
		          doctype, --a.reason reason,
		        CASE WHEN A.DOCTYPE='RCR' THEN (SELECT "Payment_Mode_Name" FROM PAYMENT_MODE_MAST WHERE "Pay_Mode_Code"=A.REASON)
        ELSE (SELECT REASON_NAME FROM CIR_REASON_MST WHERE COMP_CODE=A.COMP_CODE AND REASON_CODE=A.REASON) END AS REASON,
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
				--AND	 (a.doctype=@pdoctype or @pdoctype is null OR @pdoctype='')
				AND (a.doctype  in (SELECT EditionName FROM #Results) or @pdoctype is null OR @pdoctype='')
				AND	(a.reason  = @ppaymode OR	@ppaymode  is null  OR	@ppaymode  = '')
				AND	(ISNULL(a.achd, 'NM')  = @pactype  OR	@pactype  is null OR	@pactype  = '')
				AND	(a.branch_code  = @pbrachcode OR	@pbrachcode  is null OR	 @pbrachcode  = '')) d
                 GROUP BY d.comp_code, d.doctype, d.reason, d.debit, d.credit ) e
		GROUP BY e.comp_code, e.doctype,  e.reason 
		ORDER BY e.comp_code, e.doctype, e.reason 
		
		drop table #Results

End

////////////////////////////////////////////////////end///////////////////////////////////////////////////////////


/////////////////////////////////////Issue No. 7101 07/05/2012/////////////////////////////////////////////////


                                                           
                                             
ALTER PROCEDURE [dbo].[cir_rep_billing_cir_unitwise_p]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@ppubl_code                               VARCHAR(20) ,
	@pbill_freq                               VARCHAR(20) ,
	@pfrom_billdt                             VARCHAR(20) ,
	@ptill_billdt                             VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(200) ,
	@pextra2                                  VARCHAR(200)



AS 
	

		
		DECLARE @vquery                                   VARCHAR(4000) 
		DECLARE @vquery_all                               VARCHAR(4000) 
		DECLARE @v_bill_frdt                              DATETIME 
		DECLARE @v_bill_todt                              DATETIME 

        DECLARE @v_bill_frdt11                            VARCHAR(40)
		DECLARE @v_bill_todt11                            VARCHAR(40)

DECLARE @v_mon_date1                              DATETIME 
DECLARE @v_mon1                                   VARCHAR(40) 

		DECLARE cur_mon cursor LOCAL FOR 
		SELECT DISTINCT mon_date, REPLACE(RIGHT(CONVERT(VARCHAR(9), mon_date , 6), 6), ' ', '-')  mon FROM  col_dates 
		
	--	DECLARE @rec_mon                                  VARCHAR(200) /* SwisSQL (Oracle To SQL Server) : Table used in Cursor referenced here is not found in Metadata or Metadata not Updated*/ 
		SET @vquery  = null 
		SET @v_bill_frdt  = DBO.CONVERT_USER_DATE('/', @pfrom_billdt,@pdateformat)
		SET @v_bill_todt  = DBO.CONVERT_USER_DATE('/', @ptill_billdt,@pdateformat)
		DELETE FROM   col_dates    
		
		print(@v_bill_frdt)
         print(@v_bill_todt)

  set @v_bill_frdt11 = convert(varchar(40), @v_bill_frdt)	
  set @v_bill_todt11 = convert(varchar(40), @v_bill_todt)	

		-- IMPLICIT_TRANSACTIONS is set to OFF
DECLARE @VBILLDTNEW   DATETIME


         SELECT distinct  @VBILLDTNEW  = CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(billdt)-1),billdt),101)
		 FROM  cir_bill 
		 WHERE	 comp_code  = @pcomp_code
		 AND	((unit_code  = @punit_code) OR	(@punit_code  is null)  OR	(@punit_code = ''))
		 AND	((publ  = @ppubl_code) OR	(@ppubl_code  is null) OR	(@ppubl_code = ''))
		 AND	((bill_flag  = @pbill_freq) OR	(@pbill_freq  is null) OR	(@pbill_freq = ''))
		 AND	billdt  between @v_bill_frdt  and  @v_bill_todt 


		INSERT INTO  col_dates   
				( mon_date )  VALUES 
		(@VBILLDTNEW)
		
		
		OPEN cur_mon 

			fetch NEXT FROM cur_mon INTO @v_mon_date1 , @v_mon1

		WHILE (@@FETCH_STATUS = 0) 
		BEGIN 
			print('56')
            declare @v_mon_date11 varchar(40);		
            set @v_mon_date11 = convert(varchar(40), @v_mon_date1)	
		    
			/*vquery:=vquery||'cir_get_unit_billamt(a.comp_code,a.unit_code,'||''''||ppubl_code||''''||','||''''||pbill_freq||''''||',
			to_date('||''''||rec_mon.mon_date||''''||','||''''||pdateformat||''''||'))'||'"'||rec_mon.mon||'",';*/
		
  --      COALESCE(@vvar+'', SPACE(0)) + '' + COALESCE(@supply_type_name + '', SPACE(0))
			SET @vquery  = COALESCE(@vquery+'', SPACE(0)) + COALESCE('dbo.cir_get_unit_billamt(a.comp_code,a.unit_code,' + '''' + @ppubl_code + '''' + ',' + '''' + @pbill_freq + '''' + ',' + '''' +  @v_mon_date11 + '''' + ') "' + @v_mon1 + '",'+'', SPACE(0)) 
		
		
        fetch NEXT FROM cur_mon INTO @v_mon_date1 , @v_mon1

        END 
		
			
		close cur_mon

 print('rte')
 print(@vquery)


		IF @vquery is null or @vquery=''
		BEGIN 

           print('1')
			SET @vquery_all  = 'select distinct a.unit_code,b."Pub_Cent_name" unit_name from cir_bill a,pub_cent_mast b  where a.comp_code=b."Comp_Code" and a.unit_code=b."Pub_cent_Code" and a.comp_code=' + '''' + @pcomp_code + '''' + ' and ((a.unit_code=' + '''' + @punit_code + '''' + ') or (' + '''' + @punit_code + '''' + ' is null)  or (' + '''' + @punit_code + '''' + ' = '''')  ) and ((a.publ  =' + '''' + @ppubl_code + '''' + ') or (' + '''' + @ppubl_code + '''' + ' is null)  or (' + '''' + @ppubl_code + '''' + ' = '''') ) and   ((a.bill_flag=' + '''' + @pbill_freq + '''' + ') or (' + '''' + @pbill_freq + '''' + ' is null)  or (' + '''' + @pbill_freq + '''' + ' = '''')) and    a.billdt between' + '''' + @v_bill_frdt11 + '''' + ' and' + '''' + @v_bill_todt11 + '''' 
          print('11')

		END
		ELSE
		BEGIN 
                print('2')
				declare @len as int	
				set @len=	LEN(@vquery) - 1
				print(@len)

				SET @vquery  = SUBSTRING(@vquery, 1, @len)
				print(@vquery)
				
			SET @vquery_all  = 'select distinct a.unit_code,b."Pub_Cent_name" unit_name,' + @vquery + ' from cir_bill a,pub_cent_mast b   where a.unit_code=b."Pub_cent_Code" and a.comp_code=' + '''' + @pcomp_code + '''' + ' and ((a.unit_code=' + '''' + @punit_code + '''' + ') or (' + '''' + @punit_code + '''' + ' is null)  or (' + '''' + @punit_code + '''' + ' = '''')  ) and ((a.publ  =' + '''' + @ppubl_code + '''' + ') or (' + '''' + @ppubl_code + '''' + ' is null)  or (' + '''' + @ppubl_code + '''' + ' = '''') ) and  ((a.bill_flag=' + '''' + @pbill_freq + '''' + ') or (' + '''' + @pbill_freq + '''' + ' is null)  or (' + '''' + @pbill_freq + '''' + ' = '''')) and   a.billdt between' + '''' + @v_bill_frdt11 + '''' + ' and' + '''' + @v_bill_todt11 + '''' 
               print('12')
                print(@vquery_all)
		END
   
		--insert into test1(vstring) values(vquery_all);commit;
		print(@vquery_all)
		EXEC (@vquery_all) 
 DEALLOCATE cur_mon


//////////////////////////////////////////////////////end////////////////////////////////////////////////////////


///////////////////////////////////////For issue no.6819 06/05/2012///////////////////////////////////////////////////////////////

                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE cir_billing_p
	@pcomp_code			VARCHAR(20) ,
	@punit_code         VARCHAR(20) ,
	@pbill_freq         VARCHAR(20) ,
	@ppubl_freq         VARCHAR(20) ,--for publication type
	@ppubl              VARCHAR(20) ,--for publication 
	@pfrdt              DATETIME ,
	@ptodt              DATETIME ,
	@pbilldt            DATETIME ,
	@pdateformat        VARCHAR(20) ,
	@puserid            VARCHAR(20) ,
	@pextra1            VARCHAR(400) ,
	@pextra2            VARCHAR(400) 
AS 
	DECLARE @vbill_publwise			varchar(1)
	set @vbill_publwise='N'
    DECLARE @vrec_publ				varchar(20);
    DECLARE @v_bill_publwise		varchar(20);
	DECLARE @ln_count               NUMERIC(10)
	DECLARE @vsrch_amt              FLOAT 
	DECLARE @daily_gross_amount     NUMERIC(12,2)
	DECLARE @daily_net_amount       NUMERIC(12,2) 
	DECLARE @tot_surcharge_amt      NUMERIC(12,2) 
	DECLARE @vcomm_per              FLOAT 
	DECLARE @vcomm_amt              NUMERIC(12,2) 
	DECLARE @curr_bilagcd           VARCHAR(30)                     
	SET @curr_bilagcd = 'DUMMY_CURR' 
	DECLARE @prev_bilagcd           VARCHAR(30)                     
	SET @prev_bilagcd = 'DUMMY_PREV' 
	DECLARE @curr_record            VARCHAR(100)                    
	SET @curr_record = 'DUMMY_CURR' 
	--new add

	DECLARE @prev_record            VARCHAR(100)                    
	SET @prev_record = 'DUMMY_PREV' 
	--new add
	
	DECLARE @SUP_DAY				varchar(25)

	DECLARE @tot_copy               NUMERIC(12)                     
	SET @tot_copy = 0 
	DECLARE @vbill_no               VARCHAR(20) 
	DECLARE @vid                    NUMERIC(10)
	DECLARE @v_frdt                 DATETIME 
	DECLARE @v_todt                 DATETIME 
	DECLARE @v_billdt               DATETIME 
	DECLARE @v_agcd_sec_per         FLOAT                           
	SET @v_agcd_sec_per = 0 
	DECLARE @v_agcd_sec_amt_limt    FLOAT                           
	SET @v_agcd_sec_amt_limt = 0 
	DECLARE @v_sec_limit            NUMERIC(10,2) 
	DECLARE @v_bill_dbn_amt         NUMERIC(10,2) 
	DECLARE @v_bill_sec_amt         NUMERIC(10,2) 
	DECLARE @v_remark               VARCHAR(200) 
	DECLARE @v_reptno               VARCHAR(25) 
	DECLARE @v_rec_no               NUMERIC(10) 
	DECLARE @v_daily_comm_amt       NUMERIC(10,2) 
	DECLARE @v_daily_sur_amt        NUMERIC(10,2) 
	DECLARE @v_daily_gross_amt      NUMERIC(10,2) 
	DECLARE @v_daily_bill_amt       NUMERIC(10,2) 

	DECLARE @vcomp_code1			varchar(20)
	DECLARE @vunit1					varchar(20)
	DECLARE @vbill_agcd1			varchar(20)
	DECLARE @vbill_dpcd1			varchar(20)
	DECLARE @vbranch_code1			varchar(20)
	DECLARE @vcity_name1			varchar(400)
	DECLARE @vag_name1				varchar(400)
	DECLARE @vprint_seqno1			float
	DECLARE @vagbill_publ1			varchar(20)
	
	DECLARE @vcomp_code11			varchar(20)
	DECLARE @vunit_code11			varchar(20)
	DECLARE @vpubl11				varchar(20)
	DECLARE @vedtn11				varchar(20)
	DECLARE @vcomm_fix_auto_spl11	varchar(20)
	DECLARE @vcomm_code11			varchar(400)
	DECLARE @vsup_rate11			float
	DECLARE @vsupdate11				datetime
	DECLARE @vsurch_cd11			varchar(400)
	DECLARE @sup_copy11				float
	DECLARE @avg_sup                FLOAT 
	DECLARE @vcomm_catg_type2       varchar(10)
	DECLARE @vsun_comm_rate2        float
	DECLARE @vsun_comm_rate1        float
	DECLARE @vmon_comm_rate1        float
	DECLARE @vtue_comm_rate1        float
	DECLARE @vwed_comm_rate1        float
	DECLARE @vthu_comm_rate1        float
	DECLARE @vfri_comm_rate1        float
	DECLARE @vsat_comm_rate1        float
	DECLARE @vcomm_catg_type1       varchar(10)
	DECLARE @vsun_rate1				float
	DECLARE @vmon_rate1				float
	DECLARE @vtue_rate1				float
	DECLARE @vwed_rate1				float
	DECLARE @vthu_rate1				float
	DECLARE @vfri_rate1				float
	DECLARE @vsat_rate1				float
	
	declare @v_bill_exist			numeric(10)

	SET @v_frdt		=	@pfrdt
	SET @v_todt		=	@ptodt
	SET @v_billdt	=	@v_todt
	
	create table #temp_dual
	(temp_publ	varchar(20))
	
	insert into #temp_dual(temp_publ) values(null)
	
	CREATE TABLE #CIR_BILL_DET_TEMP
	(COMP_CODE    VARCHAR(8),
	UNIT_CODE     VARCHAR(8),
	BILLNO        VARCHAR(20),
	BILLDT        DATETIME,
	AGCD          VARCHAR(8),
	DPCD          VARCHAR(8),
	PUBL          VARCHAR(3),
	EDTN          VARCHAR(3),
	BILL_COPY     NUMERIC(7),
	COPY_RATE     NUMERIC(10,4),
	COMM_FLAG     VARCHAR(1),
	COMM_RATE     NUMERIC(10,4),
	COMM_AMT      NUMERIC(10,4),
	SUR_RATE      NUMERIC(10,4),
	SUR_AMT       NUMERIC(10,4),
	GROSS_AMOUNT  NUMERIC(14,2),
	BILL_AMOUNT   NUMERIC(14,2),
	FROMDT        DATETIME,
	TODT          DATETIME,
	COAG          VARCHAR(8),
	CODP          VARCHAR(8),
	SESSIONID     NUMERIC(15),
	COMM_TYPE     VARCHAR(1))
    
    select @vbill_publwise=cir_bill_publwise from preferrences where "comp_code"=@pcomp_code

    select @v_bill_exist=count(*) from cir_bill_det d,cir_publ_mast p
        where d.comp_code = p.comp_code and d.comp_code=@pcomp_code and d.unit_code=@punit_code and
        d.billdt between @v_frdt and @v_todt and d.publ=p.publ and (p.pro_type = @ppubl_freq or @ppubl_freq is null);
	PRINT('@v_bill_exist')PRINT(@v_bill_exist)PRINT('@vbill_publwise')PRINT(@vbill_publwise)
    declare cur_publ cursor for
        select x.publ publ from 
        (select distinct publ from cir_publ_mast 
        where comp_code=@pcomp_code and publ = isnull(@ppubl,publ) and (pro_type=@ppubl_freq or @ppubl_freq is null) and 
        @vbill_publwise='Y' 
        union
        select null publ from #temp_dual where isnull(@vbill_publwise,'N')='N')x 
        order by publ
		PRINT('OPEN cur_publ')
		OPEN cur_publ 
		fetch NEXT FROM cur_publ INTO @vrec_publ
		WHILE (@@FETCH_STATUS = 0) BEGIN                
			
			PRINT('@vrec_publ')PRINT(@vrec_publ)
			
			DECLARE agency_cur cursor LOCAL FOR 
			select a.comp_code comp_code,a.unit unit,a.bill_agcd bill_agcd,a.bill_dpcd bill_dpcd,
			m.branch_code branch_code,dbo.cir_get_city(a.comp_code,m.city_code) city_name,
			m.ag_name ag_name,m.print_seq print_seqno,@vrec_publ agbill_publ from
			(select distinct a.comp_code,a.unit,a.bill_agcd,a.bill_dpcd
			from cir_agmast a,cir_supply s
			where  a.comp_code = @pcomp_code and a.comp_code = s.comp_code and a.unit  = s.unit and a.unit  = @punit_code and
			a.agcd=s.agcd and a.dpcd=s.dpcd and a.agcd+a.dpcd in (select distinct CAST(x.agcddpcd AS VARCHAR) from
			(select distinct CAST(d.agcd AS VARCHAR) + CAST(d.dpcd AS VARCHAR)as agcddpcd from cir_dbksup d,cir_publ_mast p
			where d.comp_code = @pcomp_code and d.comp_code = p.comp_code and d.unit_code = @punit_code and
			d.publ = isnull(@vrec_publ,d.publ) and d.publ = p.publ and
			d.supdate between @v_frdt  and  @v_todt and isnull(d.sup_copy,0)>0 
			union
			select distinct CAST(d.agcd AS VARCHAR) + CAST(d.dpcd AS VARCHAR) as agcddpcd from cir_dbksup_resale d,cir_publ_mast p
			where d.comp_code = @pcomp_code and d.comp_code = p.comp_code and d.unit_code = @punit_code and
			d.publ = isnull(@vrec_publ,d.publ) and d.publ = p.publ and
			d.supdate between @v_frdt  and  @v_todt and isnull(d.sup_copy,0)>0 ) x) and
			a.bill_agcd is not null and a.bill_agcd<>'' and a.bill_dpcd is not null and a.bill_dpcd<>'' and 
			--bill_agcd = 'A0002' and bill_dpcd = '0001' and
			isnull(a.to_bill,'N')='Y' and
			--isnull(a.unsold_valid_flag,'M')=@pbill_freq
			isnull(s.billing_cycle,'M')=@pbill_freq
			) a,cir_agmast m
			where a.comp_code=m.comp_code and a.unit=m.unit and a.bill_agcd=m.agcd and a.bill_dpcd=m.dpcd and
			@v_bill_exist=0
			order by comp_code,unit,branch_code,print_seqno,city_name,ag_name
           
		/*SELECT a.comp_code comp_code, a.unit unit, a.bill_agcd bill_agcd, a.bill_dpcd bill_dpcd, m.branch_code branch_code,
		dbo.cir_get_name_cir_city(a.comp_code, m.city_code, '1', '', '', '') city_name,m.ag_name ag_name, m.print_seq print_seqno
		FROM (	SELECT DISTINCT a.comp_code, a.unit, a.bill_agcd, a.bill_dpcd FROM  cir_agmast a WHERE	 a.comp_code  = @pcomp_code
		AND	a.unit  = @punit_code AND	a.agcd + a.dpcd  in(SELECT DISTINCT CAST(agcd AS VARCHAR) + CAST(dpcd AS VARCHAR)
		FROM  cir_dbksup WHERE	 comp_code  = @pcomp_code AND	unit_code  = @punit_code AND (publ  = @ppubl OR @ppubl  is null OR @ppubl='')
        AND	supdate  between @v_frdt  and  @v_todt AND	isnull(sup_copy, 0)  > 0) AND	a.bill_agcd  is not null AND	a.bill_dpcd  is not null
		AND	isnull(a.to_bill, 'N')  = 'Y' and isnull(a.unsold_valid_flag,'M')=@pbill_freq) a, cir_agmast m 
		WHERE	 a.comp_code  = m.comp_code AND	a.unit  = m.unit AND	a.bill_agcd  = m.agcd AND	a.bill_dpcd  = m.dpcd
		ORDER BY comp_code, unit, branch_code, print_seqno, city_name, ag_name */

		OPEN agency_cur 
		fetch NEXT FROM agency_cur INTO @vcomp_code1 , @vunit1 ,@vbill_agcd1, @vbill_dpcd1 , @vbranch_code1, @vcity_name1, @vag_name1,@vprint_seqno1,@vagbill_publ1
		WHILE (@@FETCH_STATUS = 0) BEGIN
			print('cursor_Agency_open')
			SET @curr_bilagcd  =  @vbill_agcd1 +  @vbill_dpcd1 
			SET @curr_record  =  @vbill_agcd1 +  @vbill_dpcd1 
			---------------------------------------------- add new code ------------------------------------------------------
					
			IF @curr_record <> @prev_record BEGIN 
				SET @daily_gross_amount  = 0 
				SET @tot_copy  = 0 
				SET @tot_surcharge_amt  = 0 
				SET @vsrch_amt  = 0 
				SET @vcomm_amt  = 0 
			END
			print('BILLING1')
            print(@vcomp_code1)
            print(@vunit1)
            print(@vbill_agcd1)
            print(@vbill_dpcd1)
            print(@vrec_publ)
            print(@v_frdt)
            print(@v_todt)
			
			        
			DECLARE cur_supply cursor LOCAL FOR
			select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,u.comm_fix_auto_spl comm_fix_auto_spl,
			u.comm_code comm_code,u.sup_rate sup_rate,u.supdate supdate,u.surch_cd surch_cd,sum(u.sup_copy) sup_copy from
			(select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,d.edtn edtn,d.comm_fix_auto_spl comm_fix_auto_spl,
			d.comm_code comm_code,d.sup_rate sup_rate,d.supdate supdate,d.surch_cd surch_cd,d.agcd agcd,d.dpcd dpcd,d.sup_copy sup_copy
			from cir_dbksup d,cir_supply_type_mast s,cir_publ_mast p
			where d.comp_code = @vcomp_code1 and d.comp_code = s.comp_code and d.comp_code = p.comp_code and
			d.unit_code = @vunit1 and d.sup_type_code=s.sup_ty_code and isnull(s.bill_pay,'N') = 'Y' and
			d.publ = isnull(@vrec_publ,d.publ) and d.publ =p.publ and
			d.supdate between @v_frdt and @v_todt and isnull(d.sup_copy,0)>0
			union all
			select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,d.edtn edtn,d.comm_fix_auto_spl comm_fix_auto_spl,
			d.comm_code comm_code,d.sup_rate sup_rate,d.supdate supdate,d.surch_cd surch_cd,d.agcd agcd,d.dpcd dpcd,d.sup_copy sup_copy
			from cir_dbksup_resale d,cir_supply_type_mast s,cir_publ_mast p
			where d.comp_code = @vcomp_code1 and d.comp_code = s.comp_code and d.comp_code = p.comp_code and
			d.unit_code = @vunit1 and d.sup_type_code=s.sup_ty_code and isnull(s.bill_pay,'N') = 'Y' and
			d.publ = isnull(@vrec_publ,d.publ) and d.publ =p.publ and 
			d.supdate between @pfrdt and @ptodt and isnull(d.sup_copy,0)>0) u
			where u.agcd+u.dpcd in (select CAST(agcd AS VARCHAR) + CAST(dpcd AS VARCHAR) from cir_agmast
			where comp_code = @vcomp_code1 and unit = @vunit1 and bill_agcd = @vbill_agcd1 and bill_dpcd = @vbill_dpcd1)
			group by u.comp_code,u.unit_code,u.publ,u.edtn,u.comm_fix_auto_spl,u.comm_code,u.sup_rate,u.supdate,u.surch_cd;
       
			/*SELECT comp_code, unit_code, publ, edtn, comm_fix_auto_spl, comm_code, sup_rate, supdate, surch_cd, SUM(CONVERT(FLOAT, sup_copy)) sup_copy
			FROM  cir_dbksup WHERE comp_code  = @pcomp_code AND	unit_code  = @punit_code AND	sup_type_code  in(
			SELECT sup_ty_code FROM cir_supply_type_mast 	WHERE	 comp_code  = @pcomp_code AND	isnull(bill_pay, 'N')  = 'Y') AND	publ  in
			(SELECT publ	FROM  cir_publ_mast WHERE	 comp_code  = @pcomp_code )AND	agcd + dpcd  in(SELECT CAST(agcd AS VARCHAR) + CAST(dpcd AS VARCHAR)
			FROM  cir_agmast WHERE comp_code  = @vcomp_code1 AND	unit  = @vunit1 AND	bill_agcd  = @vbill_agcd1 AND	bill_dpcd  = @vbill_dpcd1)
			AND	supdate  between @v_frdt and @v_todt AND	isnull(sup_copy, 0)  > 0 GROUP BY comp_code, unit_code, publ, edtn, comm_fix_auto_spl, comm_code,sup_rate, supdate,  surch_cd */

			OPEN cur_supply 
			fetch NEXT FROM cur_supply INTO @vcomp_code11 , @vunit_code11,@vpubl11 , @vedtn11,@vcomm_fix_auto_spl11 , @vcomm_code11 ,@vsup_rate11 ,@vsupdate11 , @vsurch_cd11,@sup_copy11
			WHILE (@@FETCH_STATUS = 0) begin
				print 'cursor_supply_open'
				SET @tot_copy			= isnull(@tot_copy, 0)+ isnull(@sup_copy11, 0)
				SET @daily_gross_amount = isnull(@daily_gross_amount, 0)+ isnull(@sup_copy11, 0)* isnull( @vsup_rate11, 0)
				SET @v_daily_gross_amt  = isnull(@sup_copy11, 0)* isnull( @vsup_rate11, 0)
				SET	@SUP_DAY = CONVERT(VARCHAR(20) , DATENAME(WEEKDAY, @vsupdate11),20)
				
				IF  @vcomm_fix_auto_spl11 != 'A'  BEGIN 
					DECLARE comm_fix_spl cursor LOCAL FOR 
					select sun_comm_rate,mon_comm_rate,tue_comm_rate,wed_comm_rate,thu_comm_rate,fri_comm_rate,sat_comm_rate,comm_catg_type
					from cir_comm_mast  where comp_code = @pcomp_code and  unit_code = @punit_code and  publ = @vpubl11 and
					edtn = @vedtn11 and comm_type = @vcomm_fix_auto_spl11 and  comm_catg_code = @vcomm_code11 and  
					valid_from = (select max(valid_from) from cir_comm_mast where comp_code = @pcomp_code and unit_code = @punit_code and
					publ = @vpubl11 and  edtn = @vedtn11 and comm_type = @vcomm_fix_auto_spl11 and comm_catg_code = @vcomm_code11 and 
					valid_from <= @vsupdate11)	 
											
						OPEN comm_fix_spl
						fetch NEXT FROM comm_fix_spl INTO @vsun_comm_rate1,@vmon_comm_rate1 ,@vtue_comm_rate1,@vwed_comm_rate1,@vthu_comm_rate1,@vfri_comm_rate1 ,@vsat_comm_rate1 ,@vcomm_catg_type1

						IF (@SUP_DAY = 'Sunday' )BEGIN 
							SET @vcomm_per  =  @vsun_comm_rate1 
						END
						ELSE IF (@SUP_DAY = 'Monday') BEGIN 
							SET @vcomm_per  =   @vmon_comm_rate1
						END
						ELSE IF (@SUP_DAY = 'Tuesday')BEGIN 
							SET @vcomm_per  =   @vtue_comm_rate1
						END
						ELSE IF (@SUP_DAY = 'Wednesday') BEGIN 
							SET @vcomm_per  =   @vwed_comm_rate1 
						END
						ELSE IF (@SUP_DAY = 'Thursday') BEGIN 
							SET @vcomm_per  =   @vthu_comm_rate1 
						END
						ELSE IF (@SUP_DAY = 'Friday' )BEGIN 
							SET @vcomm_per  =   @vfri_comm_rate1
						END
						ELSE IF (@SUP_DAY = 'Saturday') BEGIN 
							SET @vcomm_per  =   @vsat_comm_rate1
						END
						ELSE BEGIN 
							SET @vcomm_per  = 0 
						END

						IF isnull( @vcomm_catg_type1, 'N')= 'P' BEGIN 
							SET @vcomm_amt			= isnull(@vcomm_amt, 0)+ ( isnull( @sup_copy11, 0)* isnull( @vsup_rate11, 0)) * isnull(@vcomm_per, 0)/ 100 
							SET @v_daily_comm_amt	= ( isnull(@sup_copy11, 0)* isnull(@vsup_rate11, 0)) * isnull(@vcomm_per, 0)/ 100 
						END
						ELSE IF isnull(@vcomm_catg_type1, 'N')= 'C' BEGIN 
							SET @vcomm_amt			= isnull(@vcomm_amt, 0)+ isnull(@sup_copy11, 0)* isnull(@vcomm_per, 0)
							SET @v_daily_comm_amt	= isnull(@sup_copy11, 0)* isnull(@vcomm_per, 0)
						END
						ELSE BEGIN 
							SET @vcomm_amt  = 0 
							SET @v_daily_comm_amt	= 0 
						END

						close comm_fix_spl
						DEALLOCATE comm_fix_spl
					END

					DECLARE cur_surcharge cursor LOCAL FOR 
					SELECT sun_rate,mon_rate,tue_rate,wed_rate,thu_rate,fri_rate,sat_rate FROM  cir_surcharge_mast WHERE	 comp_code  = @pcomp_code AND	unit  = @punit_code AND	publ  = @vpubl11
					AND	edtn  = @vedtn11 AND	surch_cd  = @vsurch_cd11 AND	valid_from  =(SELECT MAX(valid_from)FROM  cir_surcharge_mast 
					WHERE comp_code  = @pcomp_code AND	unit  = @punit_code AND	publ  = @vpubl11 AND	edtn  = @vedtn11
					AND	surch_cd = @vsurch_cd11 AND	valid_from <= @vsupdate11)
		
					OPEN cur_surcharge 
					fetch NEXT FROM cur_surcharge INTO @vsun_rate1 ,@vmon_rate1,@vtue_rate1 ,@vwed_rate1,@vthu_rate1,@vfri_rate1,@vsat_rate1
					print('cursor_surcharge')
					
					IF (@SUP_DAY = 'Sunday' ) BEGIN 
						SET @vsrch_amt  =    @vsun_rate1
					END
					ELSE IF (@SUP_DAY = 'Monday') BEGIN 
						SET @vsrch_amt  =    @vmon_rate1
					END
					ELSE IF (@SUP_DAY = 'Tuesday') BEGIN 
						SET @vsrch_amt  =   @vtue_rate1
					END
					ELSE IF (@SUP_DAY = 'Wednesday')BEGIN 
						SET @vsrch_amt  =    @vwed_rate1
					END
					ELSE IF (@SUP_DAY = 'Thursday') BEGIN 
						SET @vsrch_amt  =   @vthu_rate1
					END
					ELSE IF (@SUP_DAY = 'Friday' )BEGIN 
						SET @vsrch_amt  =   @vfri_rate1
					END
					ELSE IF (@SUP_DAY = 'Saturday') BEGIN 
						SET @vsrch_amt  =    @vsat_rate1
					END
					ELSE BEGIN 
						SET @vsrch_amt  = 0 
					END
					
					close cur_surcharge
							
					DEALLOCATE cur_surcharge

					SET @tot_surcharge_amt  = isnull(@tot_surcharge_amt, 0)+ isnull( @sup_copy11, 0)* isnull(@vsrch_amt, 0)
					SET @v_daily_sur_amt	= isnull( @sup_copy11, 0)* isnull(@vsrch_amt, 0)
					SET @v_daily_bill_amt	= isnull(@v_daily_gross_amt, 0)+ isnull(@v_daily_sur_amt, 0)- isnull(@v_daily_comm_amt, 0)
										 

					INSERT INTO  #cir_bill_det_temp ( comp_code , unit_code , billdt , agcd , dpcd , publ , edtn , bill_copy , copy_rate , 
										comm_flag , comm_rate , comm_amt , sur_rate , sur_amt , gross_amount , bill_amount , fromdt , todt , coag , codp ,comm_type )  
										VALUES ( @vcomp_code11 ,@vunit_code11 , @v_billdt , @vbill_agcd1,@vbill_dpcd1 ,@vpubl11 , @vedtn11,@sup_copy11, 
										@vsup_rate11, @vcomm_fix_auto_spl11 , isnull(@vcomm_per, 0) , isnull(@v_daily_comm_amt, 0) , isnull(@vsrch_amt, 0) , isnull(@v_daily_sur_amt, 0) , 
										isnull(@v_daily_gross_amt, 0) , isnull(@v_daily_bill_amt, 0) , @vsupdate11 , @vsupdate11 , @vbill_agcd1 , @vbill_dpcd1 ,@vcomm_catg_type1)							
					fetch NEXT FROM cur_supply INTO @vcomp_code11 , @vunit_code11,@vpubl11 , @vedtn11,@vcomm_fix_auto_spl11 , @vcomm_code11 ,@vsup_rate11 ,@vsupdate11 , @vsurch_cd11,@sup_copy11
				END 
						
				SET @avg_sup  = isnull(@tot_copy, 0)
						
				IF   @vcomm_fix_auto_spl11 = 'A' BEGIN 
					IF @tot_copy > 0 BEGIN 

               			DECLARE comm_auto cursor LOCAL FOR 
						select sun_comm_rate,comm_catg_type from cir_comm_mast where comp_code = @pcomp_code and unit_code = @punit_code and publ = @vpubl11 and
						edtn = @vedtn11 and comm_type = @vcomm_fix_auto_spl11 and comm_catg_code = @vcomm_code11 and  valid_from = (select max(valid_from) from cir_comm_mast
						where comp_code = @pcomp_code and unit_code = @punit_code and  publ = @vpubl11 and  edtn = @vedtn11 and comm_type = @vcomm_fix_auto_spl11 and
						comm_catg_code = @vcomm_code11 and   valid_from <= @v_billdt and @avg_sup between isnull(sup_copy_from,0) and isnull(sup_copy_to,0)) and
						@avg_sup between isnull(sup_copy_from,0) and isnull(sup_copy_to,0);

						OPEN comm_auto 
						fetch NEXT FROM comm_auto INTO  @vsun_comm_rate2  ,@vcomm_catg_type2 

						SET @vcomm_per  =  @vsun_comm_rate2 
															
						IF isnull( @vcomm_catg_type2, 'N')= 'P' BEGIN 
							SET @vcomm_amt  = isnull(@daily_gross_amount, 0)* isnull(@vcomm_per, 0)/ 100 
						END
						ELSE IF isnull( @vcomm_catg_type2, 'N')= 'C' BEGIN 
							SET @vcomm_amt  = isnull(@tot_copy, 0)* isnull(@vcomm_per, 0)
						END
						ELSE BEGIN 
							SET @vcomm_amt  = 0 
						END
		
						close comm_auto
					    DEALLOCATE comm_auto
					END
				END
   
				close cur_supply
                DEALLOCATE  cur_supply 

				SET @daily_net_amount  = isnull(@daily_gross_amount, 0)+ isnull(@tot_surcharge_amt, 0)- isnull(@vcomm_amt, 0)

				SET @vbill_no  = DBO.cir_generate_billno( @vcomp_code1, @vunit1, @v_billdt, @pdateformat, '', '')

                IF isnull(@tot_copy, 0)> 0 Begin	
					SELECT @v_sec_limit  =  ABS(SUM(CONVERT(FLOAT, amount))) FROM  cir_rcphdr WHERE	 comp_code  =@vcomp_code1
					AND	unit_code  = @vunit1 AND	agcd  = @vbill_agcd1 AND	dpcd  = @vbill_dpcd1 AND	achd  = 'SC'
											
					SET @v_sec_limit  = 0 
									
					DECLARE @v_bran_code VARCHAR(8)

					SELECT DISTINCT @v_agcd_sec_per  =  security_per, @v_agcd_sec_amt_limt  =  sec_amt_limt, @v_bran_code  =  branch_code
					FROM  cir_agmast WHERE comp_code  = @pcomp_code AND	unit  = @punit_code AND	agcd  = @vbill_agcd1 AND dpcd  = @vbill_dpcd1
							
					PRINT(@v_agcd_sec_per)
                    PRINT(@v_agcd_sec_amt_limt)
							
					IF isnull(@v_agcd_sec_amt_limt, 0)> isnull(@v_sec_limit, 0)and isnull(@v_agcd_sec_per, 0)> 0 BEGIN 
						SET @v_bill_dbn_amt  = isnull(@v_agcd_sec_per, 0)* isnull(@daily_net_amount, 0)/ 100 
					END
			   
					IF isnull(@v_agcd_sec_amt_limt, 0)- isnull(@v_sec_limit, 0)< isnull(@v_bill_dbn_amt, 0)BEGIN 
						SET @v_bill_sec_amt  = isnull(@v_agcd_sec_amt_limt, 0)- isnull(@v_sec_limit, 0)
					END
					ELSE BEGIN 
						SET @v_bill_sec_amt  = isnull(@v_bill_dbn_amt, 0)
					END

					INSERT INTO  cir_bill   ( comp_code , unit_code ,billno , 	billdt , agcd , dpcd , publ , bill_copy , gross_amount , 
					sur_amount , comm_amount , bill_amount , bill_frdt ,bill_todt , bill_flag , bill_remark , userid , creation_date , bill_sec_amt , branch_code,sec_per_rate )  
					VALUES ( @vcomp_code1 , @vunit1 , @vbill_no , @v_billdt , @vbill_agcd1 , @vbill_dpcd1 ,@vpubl11 , isnull(@tot_copy, 0) , 
					isnull(@daily_gross_amount, 0) , isnull(@tot_surcharge_amt, 0) , isnull(@vcomm_amt, 0) , @daily_net_amount , 
					@v_frdt , @v_todt , @pbill_freq , CAST(CONVERT(VARCHAR(23), @v_billdt) AS VARCHAR) + ' Billing' , @puserid , 
					GETDATE() , isnull(@v_bill_sec_amt, 0) , @v_bran_code,@v_agcd_sec_per ) 

					INSERT INTO  cir_outmast   ( comp_code , unit_code , agcd , dpcd , doctyp , billno , billdt , publ , amount , 
					remark , voucherno , usrid , creation_date , bill_sec_amt , branch_code )  
					VALUES ( @vcomp_code1 , @vunit1, @vbill_agcd1 , @vbill_dpcd1 , 'BIL' , @vbill_no , @v_billdt , @vpubl11 , 
					@daily_net_amount , CAST(CONVERT(VARCHAR(23), @v_billdt) AS VARCHAR) + ' Billing' , @vbill_no , @puserid , 
					GETDATE() , isnull(@v_bill_sec_amt, 0) , @v_bran_code )  
					
					INSERT INTO  cir_bill_det   ( comp_code , unit_code , billno , billdt ,agcd , dpcd ,coag , 	codp , publ , edtn , 
					copy_rate , comm_flag , comm_rate , sur_rate , fromdt , todt , bill_copy , gross_amount , comm_amt , sur_amt , 
					bill_amount , bill_flag , branch_code,comm_type )  
					SELECT comp_code, unit_code, @vbill_no billno, billdt, agcd, dpcd, agcd, dpcd, publ, edtn, copy_rate, comm_flag,
					comm_rate, sur_rate, MIN(fromdt) fromdt, MAX(todt) todt, SUM(bill_copy) bill_copy,
					SUM(CONVERT(FLOAT, gross_amount)) gross_amount,SUM(CONVERT(FLOAT, comm_amt)) comm_amt,SUM(CONVERT(FLOAT, sur_amt)) sur_amt,
					SUM(CONVERT(FLOAT, bill_amount)) bill_amount, @pbill_freq, @v_bran_code,comm_type
					FROM  #cir_bill_det_temp 
					GROUP BY comp_code, unit_code, billdt, agcd, dpcd, publ, edtn, copy_rate, comm_flag, comm_rate,  sur_rate ,comm_type

					IF isnull(@v_bill_sec_amt, 0)> 0 BEGIN 
                                 
						SET @v_remark  = 'Being amount auto debited against security deposit against bill number' + @vbill_no + ' dated' + CONVERT(VARCHAR(23), @v_billdt)
									
						SELECT @v_rec_no  =  max(convert(int,SUBSTRING(RECPTNO,(len(RECPTNO) -7),len(RECPTNO)))) + 1 FROM cir_rcphdr 
							WHERE comp_code = @vcomp_code1 AND	doctype  = 'DN'
					
						IF @v_rec_no is null or @v_rec_no = '0' BEGIN 
							SET @v_reptno  =   @v_bran_code + '-' + REPLACE(CONVERT(VARCHAR(5), GETDATE(), 2), '.', '')+ '0001'   --'DN' + '0001' 
						END
						ELSE BEGIN 
							SET @v_reptno  =   @v_bran_code + '-' + dbo.fnPadLeft('0',8,@v_rec_no)   -- 'DN ' + CASE WHEN LEN(@v_rec_no) >= 4 THEN SUBSTRING(CONVERT(VARCHAR(4000), @v_rec_no),1,4) ELSE SUBSTRING(REPLICATE('0',4),1,4-LEN(@v_rec_no)) + CONVERT(VARCHAR(4000),@v_rec_no) END  
						END

                        insert into cir_rcphdr(comp_code,unit_code,agcd,dpcd,doctype,
                         recptno,recptdt,amount,reason,remark,
                         achd,voucherno,voucherdt,userid,creation_date,branch_code)
                         values( @vcomp_code1 , @vunit1  , @vbill_agcd1 , @vbill_dpcd1 , 'DN' , @v_reptno , @v_billdt , 
							isnull(@v_bill_sec_amt, 0) , 'SEC DEBIT',@v_remark,
                         'NM',@v_reptno,@v_billdt,@puserid,GETDATE(),@v_bran_code);
							
							
						insert into cir_rcpdet(comp_code,unit_code,agcd,dpcd,doctyp,
							recptno,recptdt,payfor,achd,amount,
							reason,remark,voucherno,voucherdt,usrid,
							creation_date,branch_code)
						values(@vcomp_code1, @vunit1,@vbill_agcd1 , @vbill_dpcd1 ,'DN',
							@v_reptno,@v_billdt,@vunit1,'NM',isnull(@v_bill_sec_amt, 0),
							'SEC DEBIT',@v_remark,@v_reptno,@v_billdt,@puserid,
							GETDATE(),@v_bran_code);    
							
							PRINT('25')

							INSERT INTO  cir_outmast ( comp_code , unit_code , agcd , dpcd , doctyp , recptno , recptdt , achd , amount , 
							reason , remark , voucherno , voucherdt , usrid , creation_date , branch_code )  
							VALUES ( @vcomp_code1 ,  @vunit1 , @vbill_agcd1, @vbill_dpcd1 , 'DN' , @v_reptno , @v_billdt , 'NM' , 
							isnull(@v_bill_sec_amt, 0) , 'SEC DEBIT' , @v_remark , @v_reptno , @v_billdt , @puserid , GETDATE() , @v_bran_code )  
								
							SET @v_remark  = 'Being amount auto credited against security deposit against bill number' + @vbill_no + ' dated' + CONVERT(VARCHAR(23), @v_billdt)+ ' and debit note number' + @v_reptno 
								
							SELECT @v_rec_no  =  max(convert(int,SUBSTRING(RECPTNO,(len(RECPTNO) -7),len(RECPTNO)))) + 1  FROM  cir_rcphdr 	WHERE	 comp_code  = @vcomp_code1 AND	doctype  = 'CN'
						
							IF @v_rec_no is null or @v_rec_no = '0' BEGIN 
								SET @v_reptno  =   @v_bran_code + '-' + REPLACE(CONVERT(VARCHAR(5), GETDATE(), 2), '.', '')+ '0001'   --'DN' + '0001' 
							END
							ELSE BEGIN 
								SET @v_reptno  =   @v_bran_code + '-' + dbo.fnPadLeft('0',8,@v_rec_no)   -- 'DN ' + CASE WHEN LEN(@v_rec_no) >= 4 THEN SUBSTRING(CONVERT(VARCHAR(4000), @v_rec_no),1,4) ELSE SUBSTRING(REPLICATE('0',4),1,4-LEN(@v_rec_no)) + CONVERT(VARCHAR(4000),@v_rec_no) END  
							END

							INSERT INTO  cir_rcphdr ( comp_code , unit_code , agcd , dpcd , doctype , recptno , recptdt , amount , reason , remark , 
							achd , voucherno , voucherdt , userid , creation_date , branch_code )  
							 VALUES ( @vcomp_code1 , @vunit1 , @vbill_agcd1, @vbill_dpcd1, 'CN' , @v_reptno , @v_billdt , 
							- 1 * isnull(@v_bill_sec_amt, 0) , 'SEC DEBIT' , @v_remark , 'SC' , @v_reptno , @v_billdt , @puserid , GETDATE() , @v_bran_code )  
								
							INSERT INTO  cir_rcpdet( comp_code , unit_code , agcd , dpcd , doctyp , recptno , recptdt , payfor , achd , amount , reason , 
							remark , voucherno , voucherdt , usrid , creation_date , branch_code )  
							VALUES 	( @vcomp_code1 , @vunit1 , @vbill_agcd1 , @vbill_dpcd1 , 'CN' , @v_reptno , @v_billdt , 
							@vunit1 , 'SC' , - 1 * isnull(@v_bill_sec_amt, 0) , 'SEC DEBIT' , @v_remark , @v_reptno , @v_billdt , @puserid , GETDATE() , @v_bran_code )  

							INSERT INTO  cir_outmast   ( comp_code , unit_code , agcd , dpcd , doctyp , recptno , recptdt , achd , amount , 
							reason , remark , voucherno , voucherdt , usrid , creation_date , branch_code )  
							VALUES 	( @vcomp_code1 , @vunit1 , @vbill_agcd1 , @vbill_dpcd1 , 'CN' , @v_reptno , @v_billdt , 'SC' , - 1 * isnull(@v_bill_sec_amt, 0) , 
							'SEC DEBIT' , @v_remark , @v_reptno , @v_billdt , @puserid , GETDATE() , @v_bran_code )  
			
				        END
   
						SET @v_sec_limit  = 0 
						SET @v_bill_dbn_amt  = 0 
						SET @v_bill_sec_amt  = 0 
						SET @v_remark  = '' 
						SET @v_reptno  = '' 
						SET @v_rec_no  = 0 
						SET @v_daily_comm_amt  = 0 
						SET @v_daily_sur_amt  = 0 
						SET @v_daily_gross_amt  = 0 
						SET @v_daily_bill_amt  = 0 
			    END
   
			fetch NEXT FROM agency_cur INTO @vcomp_code1 , @vunit1 ,@vbill_agcd1, @vbill_dpcd1 , @vbranch_code1, @vcity_name1, @vag_name1,@vprint_seqno1,@vagbill_publ1	
		
END
close agency_cur
DEALLOCATE agency_cur
	set @vrec_publ=null
	fetch NEXT FROM cur_publ into @vrec_publ
	END
close cur_publ


DEALLOCATE cur_publ
DROP TABLE #cir_bill_det_temp;
DROP TABLE #temp_dual;

///////////////////////////////////////////////end//////////////////////////////////////////////////////////////


//////////////////////////////////////////add by deepika 08/05/2012 sent by Laxman sir///////////////////////////////

                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE cir_unsold_credit_note_process
	  @pcomp_code 		as varchar(20),
	  @punit_code 		as varchar(20),
	  @prec_fromdate    as varchar(20),
	  @prec_todate 	    as varchar(20),
	  @pagtype_code     as varchar(20),
      @pagcd_code 		as varchar(20),
	  @pdpcd_code 		as varchar(20),
	  @puserid          as varchar(20),
      @pdateformat 	    as varchar(20),
	  @pextra1 			as varchar(20),
	  @pextra2 			as varchar(20)
AS 
	declare @v_frdt		datetime                                  
	declare @v_todt		datetime                          
	declare @v_doctype  varchar(5)                                 
	declare @v_tot_amt  numeric(15,2)                                  
	declare @v_count	numeric
	declare @v_dsign	numeric
	declare @v_recptdt  datetime
	declare @v_amt		numeric(15,2)                  

	set @v_doctype='UCN'
	set @v_tot_amt=0
	set @v_count = 0 
	set @v_frdt  = dbo.convert_user_date('/',@prec_fromdate,@pdateformat)
	set @v_todt  = dbo.convert_user_date('/', @prec_todate,@pdateformat)
	set @v_recptdt  = @v_todt

print(@v_frdt)
print(@v_todt)

		declare @v_recptno varchar(20)
		declare @v_remark varchar(200)
--		variable for cursor
		declare @v1_comp_code varchar(20)
		declare @v1_unit_code varchar(20)
		declare @v1_branch_code varchar(20)
		declare @v1_agcd varchar(20)
		declare @v1_dpcd varchar(20)
		declare @v1_unsold_copy		numeric(8)
		declare @v1_missing_copy	numeric(8)
		declare @v1_late_copy		numeric(8)
		declare @v1_short_copy		numeric(8)
		declare @v1_damage_copy		numeric(8)
		declare @v1_amount			numeric(15,2)
		declare @v_rcdt				varchar(10)		
		declare @v_rcdp				varchar(20)
		declare @v_ccdp				varchar(20)
		declare c1 cursor for
			select h.comp_code comp_code,h.unit_code unit_code,m.branch_code branch_code,h.agcd agcd,h.dpcd dpcd,sum(isnull(apr_unsold,0)) unsold_copy,sum(isnull(d.apr_bnr,0)) missing_copy , sum(isnull(apr_late_recpt,0)) late_copy,sum(isnull(d.apr_short_recpt,0)) short_copy,sum(isnull(d.apr_damage,0)) damage_copy,
            sum(((isnull(apr_unsold,0)+isnull(d.apr_bnr,0)+isnull(apr_late_recpt,0)+isnull(d.apr_short_recpt,0)+isnull(d.apr_damage,0))*isnull(copy_rate,0))-isnull(comm_amt,0)-isnull(waste_amt,0)) amount 
            from cir_unsold_hdr_dis h,cir_unsold_dtl_dis d,cir_agmast_dis m
            where h.comp_code=@pcomp_code and h.comp_code=d.comp_code and h.comp_code=m.comp_code and
            h.unit_code=@punit_code and h.unit_code=d.unit_code and h.unit_code=m.unit and h.doctype=@v_doctype and h.doctype=d.doctype and 
            h.recptno=d.recptno and h.recptdt=d.recptdt and 
            (h.agcd=@pagcd_code or @pagcd_code is null) and (h.dpcd=@pdpcd_code or @pdpcd_code is null) and 
            h.agcd=d.agcd and h.dpcd=d.dpcd and h.agcd=m.agcd and h.dpcd=m.dpcd and (m.ag_type=@pagtype_code or @pagtype_code is null or @pagtype_code ='') and
            h.app_dt between @v_frdt and @v_todt and (h.app_userid is not null or h.app_userid<>'') and (h.process_crno is null or h.process_crno='') and 
            (isnull(apr_unsold,0)+isnull(d.apr_bnr,0)+isnull(apr_late_recpt,0)+isnull(d.apr_short_recpt,0)+isnull(d.apr_damage,0))>0 and upper(isnull(@pextra2,'/'))='D'
            group by h.comp_code,h.unit_code,m.branch_code,h.agcd,h.dpcd
			union
			select h.comp_code comp_code,h.unit_code unit_code,m.branch_code branch_code,h.agcd agcd,h.dpcd dpcd,sum(isnull(apr_unsold,0)) unsold_copy,sum(isnull(d.apr_bnr,0)) missing_copy , sum(isnull(apr_late_recpt,0)) late_copy,sum(isnull(d.apr_short_recpt,0)) short_copy,sum(isnull(d.apr_damage,0)) damage_copy,
						sum(((isnull(apr_unsold,0)+isnull(d.apr_bnr,0)+isnull(apr_late_recpt,0)+isnull(d.apr_short_recpt,0)+isnull(d.apr_damage,0))*isnull(copy_rate,0))-isnull(comm_amt,0)-isnull(waste_amt,0)) amount 
						from cir_unsold_hdr h,cir_unsold_dtl d,cir_agmast m
						where h.comp_code=@pcomp_code and h.comp_code=d.comp_code and h.comp_code=m.comp_code and
						h.unit_code=@punit_code and h.unit_code=d.unit_code and h.unit_code=m.unit and h.doctype=@v_doctype and h.doctype=d.doctype and 
						h.recptno=d.recptno and h.recptdt=d.recptdt and 
						(h.agcd=@pagcd_code or @pagcd_code is null) and (h.dpcd=@pdpcd_code or @pdpcd_code is null) and 
						h.agcd=d.agcd and h.dpcd=d.dpcd and h.agcd=m.agcd and h.dpcd=m.dpcd and (m.ag_type=@pagtype_code or @pagtype_code is null or @pagtype_code ='') and
						h.app_dt between @v_frdt and @v_todt and (h.app_userid is not null or h.app_userid<>'') and (h.process_crno is null or h.process_crno='') and 
						(isnull(apr_unsold,0)+isnull(d.apr_bnr,0)+isnull(apr_late_recpt,0)+isnull(d.apr_short_recpt,0)+isnull(d.apr_damage,0))>0 and upper(isnull(@pextra2,'/'))!='D'
						group by h.comp_code,h.unit_code,m.branch_code,h.agcd,h.dpcd
						order by comp_code,unit_code,branch_code,agcd,dpcd
		open c1
		fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit_code,@v1_branch_code,@v1_agcd,@v1_dpcd,@v1_unsold_copy,@v1_missing_copy,@v1_late_copy,@v1_short_copy,@v1_damage_copy,@v1_amount
			print(@@FETCH_STATUS)
		WHILE (@@FETCH_STATUS = 0) BEGIN
			print(@v1_agcd)print(@v1_dpcd)print(@v1_amount)
				
			if(@@FETCH_STATUS=-1)
				break;
				select @v_dsign=Dsign from cir_docmst where Comp_code=@pcomp_code AND doc_type=@v_doctype;

				set @v_amt=@v1_amount*@v_dsign;
		            
				select distinct @v_rcdp=dr_cdp,@v_ccdp=cr_cdp from FA_FIN_LINK_MAST where comp_code=@v1_comp_code and unit_code=@v1_unit_code and 
					branch_code=@v1_branch_code and modual_alias='CCOL' and doctype=@v_doctype and getdate() BETWEEN ISNULL(EFF_FR_DATE,GETDATE()) AND ISNULL(EFF_TO_DATE,GETDATE())
					
				set @v_remark='Being amount credited against unsold return';
					
				if isnull(@v1_unsold_copy,0)>0 begin
					set @v_remark=@v_remark+' Unsold Copy:- '+ cast(@v1_unsold_copy as varchar);
				end
					
				if isnull(@v1_missing_copy,0)>0 begin
					set @v_remark=@v_remark+' Missing Copy:- '+cast(@v1_missing_copy as varchar);
				end
					
				if isnull(@v1_late_copy,0)>0 begin
					set @v_remark=@v_remark+' Late Copy:- '+cast(@v1_late_copy as varchar);
				end
					
				if isnull(@v1_short_copy,0)>0 begin
					set @v_remark=@v_remark+' Short Copy:- '+cast(@v1_short_copy as varchar);
				end
				
				if isnull(@v1_damage_copy,0)>0 begin
					set @v_remark=@v_remark+' Damage Copy:- '+cast(@v1_damage_copy as varchar);
				end
				print('3')print(@v_remark)
				--set @v_rcdt='10/29/2010'
				
				set @v_rcdt= case @pdateformat when 'mm/dd/yyyy' then convert(varchar(10), @v_recptdt,101)
											   when 'dd/mm/yyyy' then convert(varchar(10), @v_recptdt,103)			
											   when 'yyyy/mm/dd' then convert(varchar(10), @v_recptdt,111) end
				print('4')print(@v_rcdt)print(@v1_comp_code)print(@v1_branch_code)print(@v_doctype)


				if upper(@pextra2)='D' begin
	                select @v_recptno = CONVERT(NUMERIC(10), MAX(SUBSTRING(recptno,charindex('-',recptno)+1, 8)))+1 from cir_rcphdr_dis 
		            where comp_code=@v1_comp_code  and doctype=@v_doctype AND  
		            replace(substring(CONVERT(VARCHAR(10), recptdt,2),1,5),'.','') = replace(substring(CONVERT(VARCHAR(10), @v_recptdt,2),1,5),'.','') and 
                    branch_code=@v1_branch_code
				end

				else begin
					select @v_recptno = CONVERT(NUMERIC(10), MAX(SUBSTRING(recptno,charindex('-',recptno)+1, 8))) + 1 from cir_rcphdr 
					where comp_code=@v1_comp_code  and doctype=@v_doctype AND 
					replace(substring(CONVERT(VARCHAR(10), recptdt,2),1,5),'.','') = replace(substring(CONVERT(VARCHAR(10), @v_recptdt,2),1,5),'.','') and 
					branch_code=@v1_branch_code             
				end
					print('5')print(@v_recptno)
					
					If isnull(@v_recptno,0)=0 Begin
					  set @v_recptno=@v1_branch_code+'-'+replace(substring(CONVERT(VARCHAR(10), @v_recptdt,2),1,5),'.','')+'0001'
					End  
					Else Begin
					  set @v_recptno=@v1_branch_code+'-'+RIGHT ('00000000'+ CAST (@v_recptno AS varchar), 8)
					End
					
					--set @v_recptno=dbo.Cir_Genrate_Id_receipt_cndn_id_p (@pcomp_code,@v_doctype,@punit_code,@v_rcdt,@pdateformat,@pextra1,@pextra2)
					if upper(@pextra2)='D' begin
						if @v_recptno is not null and isnull(@v_amt,0)<>0 begin

						insert into cir_rcphdr_dis(comp_code,unit_code,agcd,dpcd,doctype,
									 recptno,recptdt,amount,reason,remark,
									 achd,voucherno,voucherdt,userid,creation_datetime,branch_code,CCDP,RCDP)
								values(@v1_comp_code, @v1_unit_code,@v1_agcd, @v1_dpcd,@v_doctype,
									 @v_recptno,@v_recptdt,@v_amt,'UNSOLD CREDIT NOTE',@v_remark,
									 'NM',@v_recptno,@v_recptdt,@puserid,getdate(),@v1_branch_code,@v_CCDP,@v_RCDP);
						insert into cir_rcpdet_dis(comp_code,unit_code,agcd,dpcd,doctyp,
									 recptno,recptdt,payfor,achd,amount,
									 reason,remark,voucherno,voucherdt,usrid,
									 creation_datetime,branch_code)
							  values(@v1_comp_code, @v1_unit_code,@v1_agcd, @v1_dpcd,@v_doctype,
									 @v_recptno,@v_recptdt,@v1_branch_code,'NM',@v_amt,
									 'UNSOLD CREDIT NOTE',@v_remark,@v_recptno,@v_recptdt,@puserid,
									 getdate(),@v1_branch_code);
						insert into cir_outmast_dis(comp_code,unit_code,agcd,dpcd,doctyp,
									  recptno,recptdt,achd,amount,reason,
									  remark,voucherno,voucherdt,usrid,creation_datetime,branch_code)
							   values(@v1_comp_code, @v1_unit_code,@v1_agcd, @v1_dpcd,@v_doctype,
									  @v_recptno,@v_recptdt,'NM',@v_amt,'UNSOLD CREDIT NOTE',
									  @v_remark,@v_recptno,@v_recptdt,@puserid,getdate(),@v1_branch_code);
						
						set @v_count     =isnull(@v_count,0)+1;
						set @v_tot_amt   =isnull(@v_tot_amt,0)+isnull(@v1_amount,0);
						
						update cir_unsold_hdr_dis set process_crno=@v_recptno,process_crdt=@v_recptdt
							where comp_code=@v1_comp_code and unit_code=@v1_unit_code and doctype=@v_doctype and 
							recptdt between @v_frdt and @v_todt and app_userid is not null and agcd=@v1_agcd and dpcd=@v1_dpcd and 
							process_crno is null and process_crdt is null;
	            
						update cir_unsold_dtl_dis set process_crno=@v_recptno,process_crdt=@v_recptdt
							where comp_code=@v1_comp_code and unit_code=@v1_unit_code and doctype=@v_doctype and 
							recptdt between @v_frdt and @v_todt and agcd=@v1_agcd and dpcd=@v1_dpcd and 
							process_crno is null and process_crdt is null and recptno in(select distinct recptno from cir_unsold_hdr 
							where comp_code=@v1_comp_code and unit_code=@v1_unit_code and doctype=@v_doctype and 
							recptdt between @v_frdt and @v_todt and app_userid is not null and agcd=@v1_agcd and dpcd=@v1_dpcd and 
							process_crno is null and process_crdt is null);               
					end
				end
				else begin
					if @v_recptno is not null and isnull(@v_amt,0)<>0 begin

						insert into cir_rcphdr(comp_code,unit_code,agcd,dpcd,doctype,
									 recptno,recptdt,amount,reason,remark,
									 achd,voucherno,voucherdt,userid,creation_date,branch_code,CCDP,RCDP)
								values(@v1_comp_code, @v1_unit_code,@v1_agcd, @v1_dpcd,@v_doctype,
									 @v_recptno,@v_recptdt,@v_amt,'UNSOLD CREDIT NOTE',@v_remark,
									 'NM',@v_recptno,@v_recptdt,@puserid,getdate(),@v1_branch_code,@v_CCDP,@v_RCDP);
						insert into cir_rcpdet(comp_code,unit_code,agcd,dpcd,doctyp,
									 recptno,recptdt,payfor,achd,amount,
									 reason,remark,voucherno,voucherdt,usrid,
									 creation_date,branch_code)
							  values(@v1_comp_code, @v1_unit_code,@v1_agcd, @v1_dpcd,@v_doctype,
									 @v_recptno,@v_recptdt,@v1_branch_code,'NM',@v_amt,
									 'UNSOLD CREDIT NOTE',@v_remark,@v_recptno,@v_recptdt,@puserid,
									 getdate(),@v1_branch_code);
						insert into cir_outmast(comp_code,unit_code,agcd,dpcd,doctyp,
									  recptno,recptdt,achd,amount,reason,
									  remark,voucherno,voucherdt,usrid,creation_date,branch_code)
							   values(@v1_comp_code, @v1_unit_code,@v1_agcd, @v1_dpcd,@v_doctype,
									  @v_recptno,@v_recptdt,'NM',@v_amt,'UNSOLD CREDIT NOTE',
									  @v_remark,@v_recptno,@v_recptdt,@puserid,getdate(),@v1_branch_code);
						set @v_count     =isnull(@v_count,0)+1;
						set @v_tot_amt   =isnull(@v_tot_amt,0)+isnull(@v1_amount,0);

												update cir_unsold_hdr set process_crno=@v_recptno,process_crdt=@v_recptdt
							where comp_code=@v1_comp_code and unit_code=@v1_unit_code and doctype=@v_doctype and 
							recptdt between @v_frdt and @v_todt and (app_userid is not null or app_userid<>'') and agcd=@v1_agcd and dpcd=@v1_dpcd and 
							(process_crno is null or process_crno='') and process_crdt is null;
	            
						update cir_unsold_dtl set process_crno=@v_recptno,process_crdt=@v_recptdt
							where comp_code=@v1_comp_code and unit_code=@v1_unit_code and doctype=@v_doctype and 
							recptdt between @v_frdt and @v_todt and agcd=@v1_agcd and dpcd=@v1_dpcd and 
							(process_crno is null or process_crno='') and process_crdt is null and 
							recptno in(select distinct recptno from cir_unsold_hdr 
							where comp_code=@v1_comp_code and unit_code=@v1_unit_code and doctype=@v_doctype and 
							recptdt between @v_frdt and @v_todt and (app_userid is not null or app_userid<>'') and 
							agcd=@v1_agcd and dpcd=@v1_dpcd and 
							(process_crno is not null or process_crno<>''));
					end
				end
				set @v1_comp_code=null
				set @v1_unit_code=null
				set @v1_branch_code=null
				set @v1_agcd=null
				set @v1_dpcd=null
				set @v1_unsold_copy=0
				set @v1_missing_copy=0
				set @v1_late_copy=0
				set @v1_short_copy=0
				set @v1_damage_copy=0
				set @v1_amount=0
				set @v_remark=null
				set @v_recptno=null
				set @v1_branch_code=null
			fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit_code,@v1_branch_code,@v1_agcd,@v1_dpcd,@v1_unsold_copy,@v1_missing_copy,@v1_late_copy,@v1_short_copy,@v1_damage_copy,@v1_amount
			end
		close c1
		deallocate c1

        select @v_count as "TOTAL_CREDIT_NOTE",@v_tot_amt as "TOTAL_CREDIT_NOTE_AMOUNT"


//////////////////////////////////////////////end//////////////////////////////////////////////////////////////////////


/////////////////////////////////add by deepika for unsold control master 08/05/2012 sent by amit tomer sir///////////////

ALTER procedure [dbo].[cir_Publ_unsold_return_p] (
     @pcomp_code as varchar(50),
     @pbillfreq as varchar(50),
     @pdateformat as varchar(50),
     @pextra1 as varchar(50),
     @pextra2 as varchar(50)
     ) as
   Begin
      
      --select * from CIR_UNSOLD_RETURN_CONTROL where (BILL_FREQ=@pbillfreq OR @pbillfreq IS NULL or @pbillfreq='');
      select z.COMP_CODE, z.BILL_FREQ, z.PUBL_CODE, z.NO_OF_DAYS, z.INSERT_ID, z.CREATED_BY, z.CREATED_DT, z.UPDATED_BY, z.UPDATED_DT, 
      z.UNIT_CODE, z.BRANCH_CODE, z.REG_CODE, z.EDTN_CODE, z.PERM_PER ,(SELECT CLASS_DESC FROM CIR_AGENCY_CLASS_MAST c where c.COMP_CODE=@pcomp_code and c.CLASS_CODE = z.ag_class) as "AGCLASSN",
      (select AGENCY_TYPE_DESC  from CIR_AGENCY_TYP_MAST t where t.COMP_CODE = @pcomp_code AND t.AGENCY_TYPE_CODE =z.AG_TYPE)as "AGTYPNAME",(select Pub_Cent_name from pub_cent_mast x where z.COMP_CODE=@pcomp_code and x.Pub_cent_Code= z.UNIT_CODE) as "UNIT", 
      (select Branch_Name from branch_mst x where z.COMP_CODE=@pcomp_code and x.Branch_Code= z.BRANCH_CODE) as "BRANCH", 
      dbo.cir_get_region_name(z.COMP_CODE ,z.REG_CODE) as "REG" ,
      x.EDTN_NAME as "SEDTN",
      dbo.cir_get_edtn_name(z.COMP_CODE,x.main_edtn) as "MEDTN",
      dbo.cir_get_publ_name(z.COMP_CODE ,z.PUBL_CODE) as "PUBL"
      ,x.MAIN_EDTN as "EDTN", z.ZONE_CODE AS "ZONE_CODE",dbo.cir_get_zone_name(z.COMP_CODE ,z.ZONE_CODE) as "ZONE" 
      from CIR_UNSOLD_RETURN_CONTROL z,cir_edtn_mast x where z.COMP_CODE=@pcomp_code 
      and x.EDTN=z.EDTN_CODE and x.cOMP_CODE=z.cOMP_CODE and (BILL_FREQ=@pbillfreq OR @pbillfreq IS NULL);
      
     
     select * from cir_publ_mast  order by publ;
     
     
     SELECT MAX(INSERT_ID) INSERT_ID FROM CIR_UNSOLD_RETURN_CONTROL where (BILL_FREQ=@pbillfreq OR @pbillfreq IS NULL or @pbillfreq='');
     
   
     select distinct BILL_FREQ  from CIR_UNSOLD_RETURN_CONTROL where (BILL_FREQ=@pbillfreq OR @pbillfreq IS NULL or @pbillfreq='');
         
         
   End 

//////////////////////////////////////////////////////////////end////////////////////////////////////////////

/*****prachi 6591    7-may-2012************************/

ALTER PROCEDURE [dbo].[cir_branch_received_p1]
	@pcompcode       as	varchar(20),
	@punitcode       as	varchar(20),
	@pbranchcode     as	varchar(20),
	@pfrombranch     as	varchar(20),
	@pdoctypeout     as	varchar(20),
	@pdoctypein      as	varchar(20),
	@pfromdate       as	varchar(20),
	@ptilldate       as	varchar(20),
	@pdateformat     as	varchar(20),
	@pextra1         as	varchar(20),
	@pextra2         as	varchar(20), 
	@pextra3         as	varchar(20),
	@pextra4         as	varchar(20), 
	@pextra5         as	varchar(20),
	@pextra6         as	varchar(20), 
	@pextra7         as	varchar(20),
	@pextra8         as	varchar(20), 
	@pextra9         as	varchar(20),
	@pextra10        as	varchar(20) 				
AS 
	DECLARE @v_frdt  DATETIME
	DECLARE @v_todt  DATETIME
	
	if @pfromdate is not null or @pfromdate<>'' Begin	
		SET @v_frdt =  DBO.convert_user_date('/', @pfromdate,@pdateformat)
		SET @v_todt =  DBO.convert_user_date('/', @ptilldate,@pdateformat)
	End

	If @pfrombranch='' Begin
		set @pfrombranch=null
	End
	
    select distinct h.comp_code as "COMP_CODE",h.unit_code as "UNIT_CODE",d.branch_code as "BRANCH_CODE",(select "Branch_Name" from branch_mst where "Branch_Code"=d.branch_code) as "BRANCH_NAME",
    d.oth_branch_code as "OTH_BRANCH",(select "Branch_Name" from branch_mst where "Branch_Code"=d.oth_branch_code) as "OTH_BRANCH_NAME",
    d.recptno as "REF_RECPTNO" ,d.recptdt as "REF_RECPTDT",h.taxi_route_name as "TAXI_ROUTE_NAME", h.taxi_no as "TAXI_NO"
,h.packet_size "PACKET_SIZE"
    from cir_branch_return_det d,cir_branch_return_hdr h 
    where h.comp_code=@pcompcode and h.comp_code=d.comp_code and h.unit_code=@punitcode and h.unit_code=d.unit_code and 
    h.doctype=d.doctype and ((h.recptdt between @v_frdt and @v_todt) or (@v_frdt is null)) and h.recptno=d.recptno and d.branch_code=isnull(@pfrombranch,d.branch_code) and 
    d.oth_branch_code=isnull(@pbranchcode,d.oth_branch_code) and d.doctype=@pdoctypeout and d.recptno+CAST(d.recptdt AS VARCHAR) not in(select branch_refno+CAST(branch_refdt AS VARCHAR) from cir_branch_return_hdr 
    where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctypein)
    order by comp_code,unit_code,ref_recptdt,ref_recptno;





/*****prachi 6591    7-may-2012************************/


////////////////issue no.7434 08/05/2012///////////////////////////////////


ALTER PROCEDURE [dbo].[cir_rep_abc_summ_bill_return]
	@pcompcode          as varchar(4000),
    @punitcode          as varchar(4000),
    @ppublcode          as varchar(4000),
    @pmedtncode         as varchar(4000),
    @pedtncode          as varchar(4000),
    @pagtype            as varchar(4000),
    @pagclass           as varchar(4000),     
    @pfromdate          as datetime,
    @ptilldate          as datetime,
    @pinsertion_fee     as varchar(4000),--Include Insertion fee yes Y and No N
    @pbreakon           as varchar(4000),--It is used for report break on 1 for State,2 for District , 3 for Taluka, 4 for zone,5 Region
    @preptype           as varchar(4000),--B for Blling and R for Return unsold
    @pdateformat        as varchar(4000),
    @pextra1            as varchar(4000),
    @pextra2            as varchar(4000),
    @pextra3            as varchar(4000),
    @pextra4            as varchar(4000),
    @pextra5            as varchar(4000)
AS 

BEGIN
		
	declare @v_frdt    datetime
	declare @v_todt    datetime

	declare @v_comp_code     varchar(20)
	declare @v_unit_code     varchar(20)
	declare @v_publ          varchar(20)
	declare @v_medtn         varchar(20)
	declare @v_edtn          varchar(20)
	declare @v_edtn_name     varchar(20)
	declare @v_state_code    varchar(20)
	declare @v_dist_code     varchar(20)
	declare @v_tehsil_taluka varchar(20)
	declare @v_city_code     varchar(20)
	declare @v_city_name     varchar(20)
	declare @v_zone_code     varchar(20)
	declare @v_region_code   varchar(20)
	declare @v_bill_copy     numeric(10)
	declare @v_gross_amt     numeric(15,2)
	declare @v_comm_amt      numeric(15,2)
	declare @v_sur_amt       numeric(15,2)
	declare @v_bill_amt      numeric(15,2)	

	set @v_frdt =@pfromdate
	set @v_frdt =@ptilldate
declare @v_cnt      numeric(4)
set @v_cnt=0

CREATE TABLE #cir_ledger_report
(
  COMP_CODE      VARCHAR(10),
  UNIT_CODE      VARCHAR(10),
  BRANCH_CODE    VARCHAR(10),
  DOCTYPE        VARCHAR(10),
  AGCD           VARCHAR(50),
  DPCD           VARCHAR(50),
  RECPTNO        VARCHAR(50),
  RECPTDT        DATEtime,
  AMOUNT         NUMeric(14,2),
  CHQNO          VARCHAR(50),
  CHQDT          DATEtime,
  CHQ_BANK       VARCHAR(100),
  EXEC_CODE      VARCHAR(20),
  REMARKS        VARCHAR(500),
  REASON         VARCHAR(30),
  BILLNO         VARCHAR(50),
  BILLDT         DATEtime,
  BILLAMT        NUMeric(14,2),
  ADJAMT         NUMeric(14,2),
  LEFTAMT        NUMeric(14,2),
  DEBIT_HEAD     VARCHAR(200),
  CREDIT_HEAD    VARCHAR(200),
  REC_SEQNO      NUMeric(10),
  RECOVARY_DAYS  NUMeric(5),
  AGNAME         VARCHAR(500),
  OPBAL_SEC      NUMeric(14,2),
  SESS_ID        NUMeric(10)                     DEFAULT @@spid,
  NARR_LINE      NUMeric(3),
  CITY_CODE      VARCHAR(10)
)


declare  c1 cursor for
		select b.comp_code,b.unit_code,b.publ,e.main_edtn,b.edtn,e.edtn_name,dbo.cir_get_state(b.comp_code,m.country_code,m.state_code) state_name, 
        m.dist_code,m.tehsil_taluka,m.city_code,c.city_name,c.zone_code,c.region_code, 
        sum(b.bill_copy), sum(b.gross_amount) gross_amt, sum(b.comm_amt) comm_amt, sum(b.sur_amt) sur_amt,sum(b.bill_amount) bill_amt
        from cir_bill_det b,cir_agmast m,cir_edtn_mast e ,cir_city_mast c
        where b.comp_code=@pcompcode and b.comp_code=m.comp_code and b.comp_code=e.comp_code and b.comp_code=c.comp_code and 
        b.unit_code=@punitcode and b.unit_code=m.unit 
        --and        b.billdt between @v_frdt and @v_todt 
        and b.agcd=m.agcd and b.dpcd=m.dpcd and
        b.publ=e.publ and b.publ=isnull(@ppublcode,b.publ) and b.edtn=e.edtn and b.edtn=isnull(@pedtncode,b.edtn) and e.main_edtn=isnull(@pmedtncode,e.main_edtn) and (m.ag_type=@pagtype or @pagtype is null)
        and (m.ag_class=@pagclass or @pagclass is null) and m.city_code=c.city_code and @preptype='B'
        group by b.comp_code,b.unit_code,b.publ,e.main_edtn,b.edtn,m.state_code,m.country_code,m.dist_code,m.tehsil_taluka,
        m.city_code,c.city_name,c.zone_code,c.region_code,e.edtn_name
        union
        select b.comp_code,b.unit_code,b.publ,e.main_edtn,b.edtn,e.edtn_name,dbo.cir_get_state(b.comp_code,m.country_code,m.state_code) state_name, 
        m.dist_code,m.tehsil_taluka,m.city_code,c.city_name,c.zone_code,c.region_code, 
        sum(isnull(b.apr_unsold,0)+isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_damage,0)), 
        sum(b.copy_rate*(isnull(b.apr_unsold,0)+isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_damage,0))) gross_amt, 
        sum(b.comm_amt) comm_amt, 0 sur_amt,sum(b.copy_amt) bill_amt
        from cir_unsold_dtl b,cir_agmast m,cir_edtn_mast e ,cir_city_mast c
        where b.comp_code=@pcompcode 
        and b.comp_code=m.comp_code and b.comp_code=e.comp_code and b.comp_code=c.comp_code 
        and 
        b.unit_code=@punitcode and b.unit_code=m.unit 
        --and         b.app_dt between @v_frdt and @v_todt 
        and b.agcd=m.agcd and b.dpcd=m.dpcd 
        and
        b.publ=e.publ and b.publ=isnull(@ppublcode,b.publ) 
        and b.edtn=e.edtn and b.edtn=isnull(@pedtncode,b.edtn) 
        and e.main_edtn=isnull(@pmedtncode,e.main_edtn) 
        and (m.ag_type=@pagtype or @pagtype is null)
         and (m.ag_class=@pagclass or @pagclass is null) 
       and m.city_code=c.city_code and @preptype='R'
        group by b.comp_code,b.unit_code,b.publ,e.main_edtn,b.edtn,m.state_code,m.country_code,m.dist_code,m.tehsil_taluka,
        m.city_code,c.city_name,c.zone_code,c.region_code,e.edtn_name




	DELETE FROM   #cir_ledger_report WHERE  sess_id  = @@spid

		open c1
			fetch NEXT FROM c1 INTO @v_comp_code,@v_unit_code,@v_publ,@v_medtn,@v_edtn,@v_edtn_name,@v_state_code,@v_dist_code,@v_tehsil_taluka,@v_city_code,@v_city_name,@v_zone_code,@v_region_code, @v_bill_copy, @v_gross_amt, @v_comm_amt, @v_sur_amt,@v_bill_amt
			WHILE (@@FETCH_STATUS = 0) 
			BEGIN
				if(@@FETCH_STATUS = -1)
				break
					insert into #cir_ledger_report
					(comp_code, unit_code, branch_code, agcd, dpcd,billno, recptno, debit_head,chqno,chq_bank, exec_code, remarks,  
					rec_seqno,amount, billamt, adjamt, leftamt,opbal_sec, city_code,sess_id)
					values
					(@v_comp_code,@v_unit_code,@v_publ,@v_medtn,@v_edtn,@v_edtn_name,@v_state_code,@v_dist_code,@v_tehsil_taluka,@v_zone_code,@v_region_code,@v_city_name,
					@v_bill_copy, @v_gross_amt,@v_bill_amt,@v_comm_amt,@v_sur_amt,0,@v_city_code,@@spid);

			fetch NEXT FROM c1 INTO @v_comp_code,@v_unit_code,@v_publ,@v_medtn,@v_edtn,@v_edtn_name,@v_state_code,@v_dist_code,@v_tehsil_taluka,@v_city_code,@v_city_name,@v_zone_code,@v_region_code, @v_bill_copy, @v_gross_amt, @v_comm_amt, @v_sur_amt,@v_bill_amt
			end 
		close c1		
		deallocate c1


		
		If @pbreakon='1' --for State  
		begin      
			select a.comp_code as COMP_CODE,(select Comp_Name from comp_mst where Comp_Code=a.comp_code) as COMP_NAME,
			a.unit_code as UNIT_CODE,(select Pub_Cent_name from pub_cent_mast where Pub_cent_Code=a.unit_code) as UNIT_NAME, 
			a.branch_code as PUBL_CODE,dbo.cir_get_publ_name(a.comp_code,a.branch_code) as PUBL_NAME, a.agcd as MEDTN,dbo.cir_get_edtn_name(a.comp_code,a.agcd) as MEDTN_NAME, 
			a.dpcd as EDTN, a.billno as EDTN_NAME,a.recptno as STATE_NAME, a.debit_head as DIST_CODE,dbo.cir_get_name_cir_district(a.comp_code,a.debit_head,'1',@pdateformat,null,null) as DIST_NAME,
			a.city_code as CITY_CODE, a.remarks as CITY_NAME,a.chqno as TALUKA_CODE,dbo.cir_get_taluka(a.comp_code,a.chqno) as TALUKA_NAME, 
			a.chq_bank as ZONE_CODE,dbo.cir_get_zone_name(a.comp_code,a.chq_bank) as ZONE_NAME, 
			a.exec_code as REGION_CODE,dbo.cir_get_zone_name(a.comp_code,a.exec_code) as REGION_NAME,   
			a.rec_seqno as BILL_COPY,a.amount as GROSS_AMT, a.adjamt as COMM_AMT, a.leftamt as SUR_AMT, a.billamt as BILL_AMT,
			a.opbal_sec as INSERTION_FEE
			from #cir_ledger_report a 
			where sess_id=@@spid order by comp_name,unit_name,state_name,publ_name,medtn_name,edtn_name
	        
			select a.comp_code as COMP_CODE,(select Comp_Name from comp_mst where Comp_Code=a.comp_code) as COMP_NAME,
			a.unit_code as UNIT_CODE,(select Pub_Cent_name from pub_cent_mast where Pub_cent_Code=a.unit_code) as UNIT_NAME, 
			a.recptno as STATE_NAME, sum(a.rec_seqno) as BILL_COPY,sum(a.amount) as GROSS_AMT, sum(a.adjamt) as COMM_AMT, 
			sum(a.leftamt) as SUR_AMT, sum(a.billamt) as BILL_AMT,sum(a.opbal_sec) as INSERTION_FEE 
			from #cir_ledger_report a 
			where sess_id=@@spid
			group by a.comp_code ,a.unit_code , a.recptno
			order by comp_name,unit_name,state_name;
        end
		Else if @pbreakon='2' --for District
		begin 
			select a.comp_code as COMP_CODE,(select Comp_Name from comp_mst where Comp_Code=a.comp_code) as COMP_NAME,
			a.unit_code as UNIT_CODE,(select Pub_Cent_name from pub_cent_mast where Pub_cent_Code=a.unit_code) as UNIT_NAME, 
			a.branch_code as PUBL_CODE,dbo.cir_get_publ_name(a.comp_code,a.branch_code) as PUBL_NAME, a.agcd as MEDTN,dbo.cir_get_edtn_name(a.comp_code,a.agcd) as MEDTN_NAME, 
			a.dpcd as EDTN, a.billno as EDTN_NAME,a.recptno as STATE_NAME, a.debit_head as DIST_CODE,dbo.cir_get_name_cir_district(a.comp_code,a.debit_head,'1',@pdateformat,null,null) as DIST_NAME,
			a.city_code as CITY_CODE, a.remarks as CITY_NAME,a.chqno as TALUKA_CODE,dbo.cir_get_taluka(a.comp_code,a.chqno) as TALUKA_NAME, 
			a.chq_bank as ZONE_CODE,dbo.cir_get_zone_name(a.comp_code,a.chq_bank) as ZONE_NAME, 
			a.exec_code as REGION_CODE,dbo.cir_get_zone_name(a.comp_code,a.exec_code) as REGION_NAME,   
			a.rec_seqno as BILL_COPY,a.amount as GROSS_AMT, a.adjamt as COMM_AMT, a.leftamt as SUR_AMT, a.billamt as BILL_AMT,
			a.opbal_sec as INSERTION_FEE 
			from #cir_ledger_report a 
			where sess_id=@@spid order by comp_name,unit_name,state_name,dist_name,publ_name,medtn_name,edtn_name;
        
			select a.comp_code as COMP_CODE,(select Comp_Name from comp_mst where Comp_Code=a.comp_code) as COMP_NAME,
			a.unit_code as UNIT_CODE,(select Pub_Cent_name from pub_cent_mast where Pub_cent_Code=a.unit_code) as UNIT_NAME, 
			a.recptno as STATE_NAME,a.debit_head as DIST_CODE,dbo.cir_get_name_cir_district(a.comp_code,a.debit_head,'1',@pdateformat,null,null) as DIST_NAME, 
			sum(a.rec_seqno) as BILL_COPY,sum(a.amount) as GROSS_AMT, sum(a.adjamt) as COMM_AMT, 
			sum(a.leftamt) as SUR_AMT, sum(a.billamt) as BILL_AMT,sum(a.opbal_sec) as INSERTION_FEE 
			from #cir_ledger_report a 
			where sess_id=@@spid
			group by a.comp_code ,a.unit_code , a.recptno,a.debit_head
			order by comp_name,unit_name,state_name,dist_name;
        end
		Else if @pbreakon='3'--for Taluka
		begin
			select a.comp_code as COMP_CODE,(select Comp_Name from comp_mst where Comp_Code=a.comp_code) as COMP_NAME,
			a.unit_code as UNIT_CODE,(select Pub_Cent_name from pub_cent_mast where Pub_cent_Code=a.unit_code) as UNIT_NAME, 
			a.branch_code as PUBL_CODE,dbo.cir_get_publ_name(a.comp_code,a.branch_code) as PUBL_NAME, a.agcd as MEDTN,dbo.cir_get_edtn_name(a.comp_code,a.agcd) as MEDTN_NAME, 
			a.dpcd as EDTN, a.billno as EDTN_NAME,a.recptno as STATE_NAME, a.debit_head as DIST_CODE,dbo.cir_get_name_cir_district(a.comp_code,a.debit_head,'1',@pdateformat,null,null) as DIST_NAME,
			a.city_code as CITY_CODE, a.remarks as CITY_NAME,a.chqno as TALUKA_CODE,dbo.cir_get_taluka(a.comp_code,a.chqno) as TALUKA_NAME, 
			a.chq_bank as ZONE_CODE,dbo.cir_get_zone_name(a.comp_code,a.chq_bank) as ZONE_NAME, 
			a.exec_code as REGION_CODE,dbo.cir_get_zone_name(a.comp_code,a.exec_code) as REGION_NAME,   
			a.rec_seqno as BILL_COPY,a.amount as GROSS_AMT, a.adjamt as COMM_AMT, a.leftamt as SUR_AMT, a.billamt as BILL_AMT,
			a.opbal_sec as INSERTION_FEE 
			from #cir_ledger_report a 
			where sess_id=@@spid order by comp_name,unit_name,state_name,dist_name,taluka_name,publ_name,medtn_name,edtn_name;
        
			select a.comp_code as COMP_CODE,(select Comp_Name from comp_mst where Comp_Code=a.comp_code) as COMP_NAME,
			a.unit_code as UNIT_CODE,(select Pub_Cent_name from pub_cent_mast where Pub_cent_Code=a.unit_code) as UNIT_NAME, 
			a.recptno as STATE_NAME,a.debit_head as DIST_CODE,dbo.cir_get_name_cir_district(a.comp_code,a.debit_head,'1',@pdateformat,null,null) as DIST_NAME,
			a.chqno as TALUKA_CODE,dbo.cir_get_taluka(a.comp_code,a.chqno) as TALUKA_NAME, 
			sum(a.rec_seqno) as BILL_COPY,sum(a.amount) as GROSS_AMT, sum(a.adjamt) as COMM_AMT, 
			sum(a.leftamt) as SUR_AMT, sum(a.billamt) as BILL_AMT,sum(a.opbal_sec) as INSERTION_FEE 
			from #cir_ledger_report a 
			where sess_id=@@spid
			group by a.comp_code ,a.unit_code , a.recptno,a.debit_head,a.chqno
			order by comp_name,unit_name,state_name,dist_name,taluka_name;
        end
		Else if @pbreakon='4'--for Zone
        begin
			select a.comp_code as COMP_CODE,(select Comp_Name from comp_mst where Comp_Code=a.comp_code) as COMP_NAME,
			a.unit_code as UNIT_CODE,(select Pub_Cent_name from pub_cent_mast where Pub_cent_Code=a.unit_code) as UNIT_NAME, 
			a.branch_code as PUBL_CODE,dbo.cir_get_publ_name(a.comp_code,a.branch_code) as PUBL_NAME, a.agcd as MEDTN,dbo.cir_get_edtn_name(a.comp_code,a.agcd) as MEDTN_NAME, 
			a.dpcd as EDTN, a.billno as EDTN_NAME,a.recptno as STATE_NAME, a.debit_head as DIST_CODE,dbo.cir_get_name_cir_district(a.comp_code,a.debit_head,'1',@pdateformat,null,null) as DIST_NAME,
			a.city_code as CITY_CODE, a.remarks as CITY_NAME,a.chqno as TALUKA_CODE,dbo.cir_get_taluka(a.comp_code,a.chqno) as TALUKA_NAME, 
			a.chq_bank as ZONE_CODE,dbo.cir_get_zone_name(a.comp_code,a.chq_bank) as ZONE_NAME, 
			a.exec_code as REGION_CODE,dbo.cir_get_zone_name(a.comp_code,a.exec_code) as REGION_NAME,   
			a.rec_seqno as BILL_COPY,a.amount as GROSS_AMT, a.adjamt as COMM_AMT, a.leftamt as SUR_AMT, a.billamt as BILL_AMT,
			a.opbal_sec as INSERTION_FEE 
			from #cir_ledger_report a 
			where sess_id=@@spid order by comp_name,unit_name,zone_name,publ_name,medtn_name,edtn_name;
        
			select a.comp_code as COMP_CODE,(select Comp_Name from comp_mst where Comp_Code=a.comp_code) as COMP_NAME,
			a.unit_code as UNIT_CODE,(select Pub_Cent_name from pub_cent_mast where Pub_cent_Code=a.unit_code) as UNIT_NAME, 
			a.chq_bank as ZONE_CODE,dbo.cir_get_zone_name(a.comp_code,a.chq_bank) as ZONE_NAME,
			sum(a.rec_seqno) as BILL_COPY,sum(a.amount) as GROSS_AMT, sum(a.adjamt) as COMM_AMT, 
			sum(a.leftamt) as SUR_AMT, sum(a.billamt) as BILL_AMT,sum(a.opbal_sec) as INSERTION_FEE 
			from #cir_ledger_report a 
			where sess_id=@@spid
			group by a.comp_code ,a.unit_code , a.chq_bank
			order by comp_name,unit_name,zone_name;
		end
		Else--for Region Wise                
		begin
			select a.comp_code as COMP_CODE,(select Comp_Name from comp_mst where Comp_Code=a.comp_code) as COMP_NAME,
			a.unit_code as UNIT_CODE,(select Pub_Cent_name from pub_cent_mast where Pub_cent_Code=a.unit_code) as UNIT_NAME, 
			a.branch_code as PUBL_CODE,dbo.cir_get_publ_name(a.comp_code,a.branch_code) as PUBL_NAME, a.agcd as MEDTN,dbo.cir_get_edtn_name(a.comp_code,a.agcd) as MEDTN_NAME, 
			a.dpcd as EDTN, a.billno as EDTN_NAME,a.recptno as STATE_NAME, a.debit_head as DIST_CODE,dbo.cir_get_name_cir_district(a.comp_code,a.debit_head,'1',@pdateformat,null,null) as DIST_NAME,
			a.city_code as CITY_CODE, a.remarks as CITY_NAME,a.chqno as TALUKA_CODE,dbo.cir_get_taluka(a.comp_code,a.chqno) as TALUKA_NAME, 
			a.chq_bank as ZONE_CODE,dbo.cir_get_zone_name(a.comp_code,a.chq_bank) as ZONE_NAME, 
			a.exec_code as REGION_CODE,dbo.cir_get_zone_name(a.comp_code,a.exec_code) as REGION_NAME,   
			a.rec_seqno as BILL_COPY,a.amount as GROSS_AMT, a.adjamt as COMM_AMT, a.leftamt as SUR_AMT, a.billamt as BILL_AMT,
			a.opbal_sec as INSERTION_FEE 
			from #cir_ledger_report a 
			where sess_id=@@spid order by comp_name,unit_name,zone_name,region_name,publ_name,medtn_name,edtn_name;
        
			select a.comp_code as COMP_CODE,(select Comp_Name from comp_mst where Comp_Code=a.comp_code) as COMP_NAME,
			a.unit_code as UNIT_CODE,(select Pub_Cent_name from pub_cent_mast where Pub_cent_Code=a.unit_code) as UNIT_NAME, 
			a.chq_bank as ZONE_CODE,dbo.cir_get_zone_name(a.comp_code,a.chq_bank) as ZONE_NAME,
			a.exec_code as REGION_CODE,dbo.cir_get_zone_name(a.comp_code,a.exec_code) as REGION_NAME,
			sum(a.rec_seqno) as BILL_COPY,sum(a.amount) as GROSS_AMT, sum(a.adjamt) as COMM_AMT, 
			sum(a.leftamt) as SUR_AMT, sum(a.billamt) as BILL_AMT,sum(a.opbal_sec) as INSERTION_FEE 
			from #cir_ledger_report a 
			where sess_id=@@spid
			group by a.comp_code ,a.unit_code , a.chq_bank,a.exec_code
			order by comp_name,unit_name,zone_name,region_name;
		End

		drop table #cir_ledger_report

end


//////////////////////////////////////end///////////////////////////////////////////////


//////////////////////add by deepika 08/05/2012 sent by Laxman sir/////////////////////////////////////////
                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE [dbo].[cir_rep_billing_cir_bill_register_p]
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
/*select getdate()*/

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
		order by comp_code, state_name,billdt,billno,agency_name
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
		order by comp_code, state_name,dist_name,billdt,billno,agency_name
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
		order by comp_code, state_name,taluka_name,billdt,billno,agency_name
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
		order by comp_code, state_name,"CITY NAME",billdt,billno,agency_name
	end

/////////////////////////////////////////////////////////////end//////////////////////////////////////////////////////

////////////////////////////////////add by deepika 09/05/2012 sent by Laxman sir//////////////////////

                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE cir_rep_supply_temp
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
@pextra10           as varchar(200)--for executive

AS

declare @vfrom_supdate    varchar(20);
declare @vtill_supdate    varchar(20);
declare @rec_sup_type		as varchar(200) 
declare @rec_sup_type_sum	as varchar(200) 
declare @rec_sup_seq_no		as int

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

	declare @vvar		varchar(4000)
	declare @vvar_sum	varchar(4000)
	declare @vquery		varchar(8000)

	set @vvar=''
	set @vvar_sum=''
 
	set @vfrom_supdate=convert(varchar(20),@pfrom_supdate,101)
	set @vtill_supdate=convert(varchar(20),@ptill_supdate,101)

	print('@vfrom_supdate')print(@vfrom_supdate);
	print('@vtill_supdate')print(@vtill_supdate);

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

if @vvar='' or @vvar is null begin
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
            and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
            and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
		group by d.comp_code,d.unit_code,d.publ,d.route_code
		order by d.comp_code,d.unit_code,d.publ,route_name';

end
else begin
if @pextra8='1' begin----for route 

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
            and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
            and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
		group by d.comp_code,d.unit_code,d.publ,d.route_code
		order by d.comp_code,d.unit_code,d.publ,route_name';

end ------ route	
else if @pextra8='2' begin----for  branch
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
            and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
            and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
 group by d.comp_code,d.unit_code,m.branch_code
order by d.comp_code,d.unit_code,branch_name'

end ---- branch		
else if @pextra8='3' begin----for  zone  
 
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
            and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
            and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
	group by d.comp_code,d.unit_code,c.zone_code
	order by d.comp_code,d.unit_code,zone_name';

end  ---- zone
else if @pextra8='4' begin----for  region   
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
            and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
            and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
	group by d.comp_code,d.unit_code,c.region_code
	order by d.comp_code,d.unit_code,region_name';

end ---- end  region
else if @pextra8='5' begin----for  district

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
            and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
            and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
		group by d.comp_code,d.unit_code,m.state_code,m.dist_code
		order by d.comp_code,d.unit_code,m.state_code,district_name	'

end  ---- district
else if @pextra8='6' begin----for  tehsil_taluka

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
            and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
            and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
	group by d.comp_code,d.unit_code,m.tehsil_taluka
	order by d.comp_code,d.unit_code,taluka_name';
end  ----for  tehsil_taluka

else if @pextra8='7' begin----for  State

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
            and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
            and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
	group by d.comp_code,d.unit_code,m.country_code,m.state_code
	order by d.comp_code,d.unit_code,m.country_code,state_name';
end  ----for  state

else begin--for executive
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
            and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
            and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
	group by d.comp_code,d.unit_code,m.country_code,m.executive_code
	order by d.comp_code,d.unit_code,m.country_code,executive_name';
end
end

print(@vquery)
exec(@vquery)


////////////////////////////////////////

                                                                     
                                                                     
                                                                     
                                             
CREATE procedure [dbo].[cir_exec_editionwise_print]
    @pcompcode      as varchar(500),
    @punitcode      as varchar(500),
    @ppublcode      as varchar(500),
    @pmainedtn      as varchar(500),
    @pedtncode      as varchar(500),
    @proute         as varchar(500),
    @pfrom_supdate  as datetime,
    @ptill_supdate  as datetime,
    @plangtype      as varchar(500),
    @pdateformat    as varchar(500),
    @pextra1        as varchar(500),
    @pextra2        as varchar(500),
    @pextra3        as varchar(500),--------supply posted final and un final
    @pextra4        as varchar(500),
    @pextra5        as varchar(500),
    @pextra6        as varchar(500),
    @pextra7        as varchar(500),
    @pextra8        as varchar(500),
    @pextra9        as varchar(500),
    @pextra10       as varchar(500)
as
SET CONCAT_NULL_YIELDS_NULL OFF

declare @vsupdate	as  datetime;
declare @vsupdate1  as datetime;
declare @vvar		as varchar(max);
declare @vvar_sum   as  varchar(max);
declare @vvar_sum1  as  varchar(max);
declare @v_query	as  varchar(max);
declare @v_query1	as  varchar(max);

set @vsupdate =@pfrom_supdate
set @vsupdate1=@ptill_supdate

declare cur_edtn cursor for
    select distinct d.publ publ,d.edtn edtn,p.edtn_seq_no edtn_seqno,
    case @plangtype when '1' then substring(isnull(p.edition_nick,p.edtn_name),1,15)
    else substring(p.edtn_name_oth_lang,1,20) end edtn_name
    ,d.sup_rate sup_rate,p.main_edtn main_edtn
    from cir_route_mast m,cir_dbksup d ,cir_edtn_mast p ,cir_supply_type_mast k,cir_agmast a
    where m.comp_code=@pcompcode and m.comp_code=d.comp_code and d.comp_code=p.comp_code and d.comp_code=a.comp_code and 
    d.comp_code=k.comp_code  and m.unit=d.unit_code and a.unit=d.unit_code and m.unit=p.unit_code and 
    d.unit_code = @punitcode and d.sup_type_code=k.sup_ty_code and d.agcd=a.agcd and d.dpcd=a.dpcd and
    d.supdate >= @pfrom_supdate and d.supdate <=@ptill_supdate and
    m.route_code=d.route_code and (m.route_code=@proute or @proute is null)
    and d.publ=isnull(@ppublcode,d.publ) and
    d.publ=p.publ and d.edtn=p.edtn --and k.bill_pay='Y'
    order by publ,main_edtn,edtn_seqno,edtn,sup_rate
print('a')
-- cursor variable for cur_edtn
declare @rec_edtn_publ as varchar(200)
declare @rec_edtn_edtn as varchar(200)
declare @rec_edtn_edtn_seqno as numeric(5)
declare @rec_edtn_edtn_name as varchar(500)
declare @rec_edtn_sup_rate as numeric(14,2)
declare @rec_edtn_main_edtn as varchar(200)
-- end here --

OPEN cur_edtn 
    fetch NEXT FROM cur_edtn INTO @rec_edtn_publ , @rec_edtn_edtn,@rec_edtn_edtn_seqno,@rec_edtn_edtn_name,@rec_edtn_sup_rate,@rec_edtn_main_edtn
        WHILE (@@FETCH_STATUS = 0) 
        BEGIN
            if (@vvar is null or @vvar = '') begin 
                set @vvar        ='sum(case edtn when '+''''+@rec_edtn_edtn+''''+' then sup_copy else 0 end) "'+@rec_edtn_edtn_name+'"';
                set @vvar_sum    ='sum('+'"'+@rec_edtn_edtn_name+'") "'+@rec_edtn_edtn_name+'"';
                set @vvar_sum1   ='sum('+'"'+@rec_edtn_edtn_name+'"';
            end
            else
            begin
                set @vvar        =@vvar+','+'sum(case edtn when '+''''+@rec_edtn_edtn+''''+' then sup_copy else 0 end) "'+@rec_edtn_edtn_name+'"';
                set @vvar_sum    =@vvar_sum+','+'sum('+'"'+@rec_edtn_edtn_name+'") "'+@rec_edtn_edtn_name+'"';
                set @vvar_sum1   =@vvar_sum1+'+"'+@rec_edtn_edtn_name+'"';
            end
                
                
    fetch NEXT FROM cur_edtn INTO @rec_edtn_publ , @rec_edtn_edtn,@rec_edtn_edtn_seqno,@rec_edtn_edtn_name,@rec_edtn_sup_rate,@rec_edtn_main_edtn
END     
close cur_edtn
DEALLOCATE cur_edtn

if @vvar_sum1 is not null or @vvar_sum1 !='' begin
    set @vvar_sum1=@vvar_sum1+') "Total"'
end
print(@vvar)
 if @vvar is null or @vvar ='' begin
    set @v_query='select x.comp_code,x.unit_code,x.route_code,x.route_name from(select d.comp_code,d.unit_code,a.executive_code route_code,
            case '''+@plangtype+''' when ''1'' then substring(isnull((select executive_desc from cir_executive_mast where comp_code=d.comp_code and executive_code=a.executive_code),''NOT DEFINE''),1,25)
            else substring(isnull((select executive_desc from cir_executive_mast where comp_code=d.comp_code and executive_code=a.executive_code),''NOT DEFINE''),1,25) end route_name 
            from cir_dbksup d,cir_route_mast m ,cir_supply_type_mast k,cir_agmast a
            where d.comp_code = m.comp_code and d.comp_code=k.comp_code  and d.comp_code=a.comp_code and 
            d.comp_code = '+''''+@pcompcode+''''+' and 
            d.unit_code = m.unit and d.unit_code = a.unit and d.unit_code = '+''''+@punitcode+''''+' and 
            d.sup_type_code=k.sup_ty_code and 
            d.publ = isnull('+''''+@ppublcode+''''+',d.publ) and d.route_code = m.route_code  and 
            d.supdate >= '+''''+cast(@vsupdate as varchar)+''''+' and d.supdate <='+''''+cast(@vsupdate1 as varchar)+''''+' 
            and k.bill_pay=''Y'' 
            and (d.final_supply_flag='+''''+@pextra3+''''+' or '+''''+@pextra3+''''+' ='''') and
            d.agcd=a.agcd and d.dpcd=a.dpcd
            group by d.comp_code,d.unit_code,a.executive_code) x
            group by x.comp_code,x.unit_code,x.route_code,x.route_name
            order by x.comp_code,x.unit_code,x.route_code,x.route_name';
end
else
begin        
    set @v_query='select x.comp_code,x.unit_code,x.route_code,x.route_name,'+@vvar_sum+','+@vvar_sum1+' from(select d.comp_code,d.unit_code,a.executive_code route_code,
            case '''+@plangtype+''' when ''1'' then substring(isnull((select executive_desc from cir_executive_mast where comp_code=d.comp_code and executive_code=a.executive_code),''NOT DEFINE''),1,25)
            else substring(isnull((select executive_desc from cir_executive_mast where comp_code=d.comp_code and executive_code=a.executive_code),''NOT DEFINE''),1,25) end route_name
            ,'+@vvar+' from cir_dbksup d,cir_route_mast m,cir_supply_type_mast k,cir_agmast a
            where d.comp_code = m.comp_code and d.comp_code=k.comp_code  and d.comp_code=a.comp_code and 
            d.comp_code = '+''''+@pcompcode+''''+' and 
            d.unit_code = m.unit and d.unit_code = a.unit and d.unit_code = '+''''+@punitcode+''''+' and 
            d.sup_type_code=k.sup_ty_code and 
            d.publ = isnull('+''''+@ppublcode+''''+',d.publ) and d.route_code = m.route_code  and 
            d.supdate >= '+''''+cast(@vsupdate as varchar)+''''+' and d.supdate <='+''''+cast(@vsupdate1 as varchar)+''''+' 
            and k.bill_pay=''Y'' 
            and (d.final_supply_flag='+''''+@pextra3+''''+' or '+''''+@pextra3+''''+' ='''') and
            d.agcd=a.agcd and d.dpcd=a.dpcd
            group by d.comp_code,d.unit_code,a.executive_code) x
            group by x.comp_code,x.unit_code,x.route_code,x.route_name
            order by x.comp_code,x.unit_code,x.route_code,x.route_name';       
end
print(@v_query)
exec(@v_query)  
print('q')
-- for free supply

        if @vvar is null or @vvar ='' begin
            set @v_query1='select x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name from(select d.comp_code,d.unit_code,k.sup_ty_code,
            substring(k.sup_ty_name,1,25) supply_name
            from cir_dbksup d,cir_supply_type_mast k,cir_agmast a
            where d.comp_code=k.comp_code  and d.comp_code=a.comp_code and 
            d.comp_code = '+''''+@pcompcode+''''+' and 
            d.unit_code = a.unit and d.unit_code = '+''''+@punitcode+''''+' and 
            d.sup_type_code=k.sup_ty_code and 
            d.publ = isnull('+''''+@ppublcode+''''+',d.publ) and 
            d.supdate >= '+''''+cast(@vsupdate as varchar)+''''+' and d.supdate <='+''''+cast(@vsupdate1 as varchar)+''''+' 
            and k.bill_pay=''N'' 
            and (d.final_supply_flag='+''''+@pextra3+''''+' or '+''''+@pextra3+''''+' ='''') and
            d.agcd=a.agcd and d.dpcd=a.dpcd
            group by d.comp_code,d.unit_code,k.sup_ty_code,k.sup_ty_name) x
            group by x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name
            order by x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name';
        end
        else
        begin
            set @v_query1='select x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name,'+@vvar_sum+','+@vvar_sum1+' from
            (select d.comp_code,d.unit_code,k.sup_ty_code sup_ty_code,
            substring(k.sup_ty_name,1,25) supply_name
            ,'+@vvar+' from cir_dbksup d,cir_supply_type_mast k,cir_agmast a
            where d.comp_code=k.comp_code  and d.comp_code=a.comp_code and 
            d.comp_code = '+''''+@pcompcode+''''+' and 
            d.unit_code = a.unit and d.unit_code = '+''''+@punitcode+''''+' and 
            d.sup_type_code=k.sup_ty_code and 
            d.publ = isnull('+''''+@ppublcode+''''+',d.publ) and
            d.supdate >= '+''''+cast(@vsupdate as varchar)+''''+' and d.supdate <='+''''+cast(@vsupdate1 as varchar)+''''+' 
            and k.bill_pay=''N'' 
            and (d.final_supply_flag='+''''+@pextra3+''''+' or '+''''+@pextra3+''''+' ='''') and
            d.agcd=a.agcd and d.dpcd=a.dpcd
            group by d.comp_code,d.unit_code,k.sup_ty_code,k.sup_ty_name) x
            group by x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name
            order by x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name';
        end

print(@v_query1)
exec(@v_query1)

        if @vvar is null or @vvar ='' begin
            set @v_query1='select x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name from(select d.comp_code,unit_code,null as sup_ty_code, null as supply_name
            from cir_dbksup d,cir_supply_type_mast k,cir_agmast a
            where d.comp_code=k.comp_code  and d.comp_code=a.comp_code and 
            d.comp_code = '+''''+@pcompcode+''''+' and 
            d.unit_code = a.unit and d.unit_code = '+''''+@punitcode+''''+' and 
            d.sup_type_code=k.sup_ty_code and 
            d.publ = isnull('+''''+@ppublcode+''''+',d.publ) and
            d.supdate >= '+''''+cast(@vsupdate as varchar)+''''+' and d.supdate <='+''''+cast(@vsupdate1 as varchar)+''''+' 
            and k.bill_pay=''Y'' 
            and (d.final_supply_flag='+''''+@pextra3+''''+' or '+''''+@pextra3+''''+' ='''') and
            d.agcd=a.agcd and d.dpcd=a.dpcd
            group by d.comp_code,d.unit_code) x
            group by x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name
            order by x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name';
        end
        else
        begin
            set @v_query1='select x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name,'+@vvar_sum+','+@vvar_sum1+' from
            (select d.comp_code,d.unit_code   ,null as sup_ty_code, null as supply_name
            ,'+@vvar+' from cir_dbksup d,cir_supply_type_mast k,cir_agmast a
            where d.comp_code=k.comp_code  and d.comp_code=a.comp_code and 
            d.comp_code = '+''''+@pcompcode+''''+' and 
            d.unit_code = a.unit and d.unit_code = '+''''+@punitcode+''''+' and 
            d.sup_type_code=k.sup_ty_code and 
            d.publ = isnull('+''''+@ppublcode+''''+',d.publ) and 
            d.supdate >= '+''''+cast(@vsupdate as varchar)+''''+' and d.supdate <='+''''+cast(@vsupdate1 as varchar)+''''+' 
            and (d.final_supply_flag='+''''+@pextra3+''''+' or '+''''+@pextra3+''''+' ='''') and
            d.agcd=a.agcd and d.dpcd=a.dpcd
            group by d.comp_code,d.unit_code) x
            group by x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name
            order by x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name';
        end

print(@v_query1)
exec(@v_query1)

SET CONCAT_NULL_YIELDS_NULL On

////////////////////////////////////

                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE cir_rep_supply_cir_rep_supply1
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
	@pextra10           VARCHAR(40)--for executive
AS 
BEGIN
	DECLARE @vfrom_supdate	varchar(20);
	DECLARE @vtill_supdate  varchar(20);
	declare @vsup_seq_no	int
	
	DECLARE cur_sup_type cursor LOCAL FOR 
	select distinct ' sum(case sup_type_code when '+''''+sup_ty_code+''''+' then sup_copy else 0 end ) "'+sup_ty_name+'",' vty,
	'sum(case sup_type_code when '+''''+sup_ty_code+''''+' then sup_copy else 0 end ) +' vty_sum,sup_seq_no
	from cir_supply_type_mast s, cir_dbksup d,cir_edtn_mast e,cir_publ_mast p
    where s.comp_code=@pcomp_code and s.comp_code=d.comp_code and s.comp_code=e.comp_code and s.comp_code=p.comp_code and s.sup_ty_code =d.sup_type_code and
    (d.unit_code=isnull(@punit_code,d.unit_code) or @punit_code='') and d.publ=e.publ and d.publ=p.publ and 
    (d.publ=isnull(@ppubl,d.publ) or @ppubl='') and 
    d.edtn=e.edtn and (d.edtn=isnull(@pedtn,d.edtn) or @pedtn='') and 
    d.supdate between @pfrom_supdate and @ptill_supdate and
    (e.main_edtn=isnull(@pmainedtn,e.main_edtn) or @pmainedtn='') and (p.pro_type=@pextra9 or @pextra9  is null or @pextra9 ='')
    order by sup_seq_no;

	
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

if @pextra8='1' Begin--for route
	set @vquery='select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,d.route_code ROUTE_CODE,dbo.cir_get_route_name(d.comp_code,d.unit_code,d.route_code) ROUTE_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
		substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",dbo.cir_get_city(d.comp_code,m.city_code) "CITY NAME",
		isnull(dbo.CIR_GET_NAME_CIR_CITY(d.comp_code,m.city_code,2,null,null,null),''NA'') "CITY ONAME", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) "DROP_POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
		,dbo.cir_get_mode_name(d.comp_code,d.unit_code+d.route_code) as "MODE_NAME"
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
			group by d.comp_code,d.unit_code,d.publ,d.edtn,d.route_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code 
			order by d.comp_code,d.unit_code,d.publ,d.edtn,d.route_code,d.agcd,d.dpcd'
                
		print @vquery 
		EXEC (@vquery)
end
if @pextra8='2' Begin----for  branch
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

if @pextra8='3' Begin----for  zone
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

if @pextra8='4' Begin----for  region
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
        group by d.comp_code,d.unit_code,d.publ,d.edtn,m.branch_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code order by d.comp_code,d.unit_code,d.publ,d.edtn,branch_name,d.agcd,d.dpcd'
                
		print @vquery 
		EXEC (@vquery)
end

if @pextra8='5' Begin----for  district
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

if @pextra8='6' Begin----for Taluka
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
if @pextra8='7' Begin----for State
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

if @pextra8='8' Begin----for Executive
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
		
if @pextra8='1' Begin--for route
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

if @pextra8='2' Begin--for branch
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

if @pextra8='3' Begin--for Zone
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

if @pextra8='4' Begin--for region
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

if @pextra8='5' Begin--for District
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

if @pextra8='6' Begin--for Taluka
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

if @pextra8='7' Begin--for state
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

if @pextra8='8' Begin--for executive
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


DEALLOCATE cur_sup_type

END

////////////////////////////////////////////////////////////end//////////////////////////////////////////////////////
/***********21 june    by laxman sir******************/
                                                                     
                                                                     
                                                                     
                                             
ALTER procedure [dbo].[cir_rep_unsold_stock_p]
      @pcompcode          varchar(20),
      @punitcode          varchar(20),
      @pbrancode          varchar(20),
      @ppublcode          varchar(20),
      @pfromdt            datetime,
      @ptilldt            datetime,
      @pdateformat        varchar(20),
      @pextra1            varchar(200),
      @pextra2            varchar(200)
    As
	declare @v_frdt datetime;
        declare @v_todt datetime;
	declare @v1_publ	varchar(20)
	declare @v1_edtn	varchar(20)
	declare @v1_copy_rate	decimal(10,2)

        declare c1 cursor  for
        select z.publ publ,z.edtn edtn,z.copy_rate copy_rate from
        (select publ,edtn,copy_rate from cir_unsold_dtl 
        where comp_code= @pcompcode and unit_code= @punitcode and doctype='UCN' and recptdt <= @ptilldt and 
        (publ= @ppublcode or @ppublcode is null) and branch_code=isnull(@pbrancode,branch_code) and (isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))>0
        group by publ,edtn,copy_rate
        union
        select publ_code publ,edtn_code edtn, edtn_rate copy_rate from cir_branch_return_det 
        where comp_code= @pcompcode and unit_code= @punitcode and recptdt <= @ptilldt and branch_code=isnull(@pbrancode,branch_code) and
        (publ_code= @ppublcode or @ppublcode is null)
        group by publ_code,edtn_code,edtn_rate
        union
        select publ_code publ,edtn_code edtn, edtn_rate copy_rate from cir_return_sale_det
        where comp_code= @pcompcode and unit_code= @punitcode and recptdt <= @ptilldt and branch_code=isnull(@pbrancode,branch_code) and
        (publ_code= @ppublcode or @ppublcode is null)
        union
        select publ,edtn,copy_rate from cir_unsold_dtl_dis--for company return  
        where comp_code= @pcompcode and unit_code= @punitcode and doctype='UCN' and recptdt <= @ptilldt and 
        (publ= @ppublcode or @ppublcode is null) and branch_code=isnull(@pbrancode,branch_code) and (isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))>0
        group by publ,edtn,copy_rate
        union
        select publ_code publ,edtn_code edtn, edtn_rate copy_rate from cir_physical_ver_det
        where comp_code= @pcompcode and unit_code= @punitcode and recptdt <= @ptilldt and branch_code=isnull(@pbrancode,branch_code) and
        (publ_code= @ppublcode or @ppublcode is null)
        union
        select a.publ publ,a.edtn edtn, a.sup_rate copy_rate from cir_dbksup_resale a,cir_agmast b 
        where a.comp_code= @pcompcode and a.comp_code=b.comp_code and a.unit_code= @punitcode and a.unit_code=b.unit and 
        (a.publ= @ppublcode or @ppublcode is null) and a.agcd=b.agcd and a.dpcd=b.dpcd and a.supdate <= @ptilldt and isnull(a.return_copy_sale,'N')='Y' and b.branch_code=isnull(@pbrancode,branch_code))z
        order by publ,edtn,copy_rate

      declare @v_opbal_unsold   int
      declare @v_op_branch_rec  int
      declare @v_op_branch_trf  int
      declare @v_op_sale	int
      declare @v_op_resale	int 
      declare @v_op_comp_ret	int 
      declare @v_op_short_excess int
      declare @v_opbal		int
      
      declare @v_branch_rec_copy int 
      declare @v_branch_trf_copy int
      declare @v_unsold_copy	int
      declare @v_sale_copy	int 
      declare @v_resale_copy	int
      declare @v_comp_ret_copy	int
      declare @v_short_excess	int
    Begin
       set @v_frdt    = @pfromdt
       set @v_todt    = @ptilldt
        
	CREATE TABLE #CIR_TEMP_UNSOLD_STOCK
	(COMP_CODE      VARCHAR(8),
	 UNIT_CODE      VARCHAR(8),
	BRANCH_CODE    VARCHAR(8),
	PUBL_CODE      VARCHAR(8),
	EDTN_CODE      VARCHAR(8),
	ASON_DT        DATETIME,
	COPY_RATE      decimal(10,2),
	OPBAL          INT,
	UNSOLD_RETURN  INT,
	BRANCH_REC     INT,
	UNSOLD_SALE    INT,
	UNSOLD_RESALE  INT,
	COMP_RETURN    INT,
	BRANCH_TRAN    INT,
	SHORT_EXCESS   INT,
	SESS_ID        INT )
            
            
        print('before open cursor')
	open c1
            fetch NEXT FROM C1 INTO @v1_publ, @v1_edtn, @v1_copy_rate
            
            print(@v1_publ)print( @v1_edtn)print( @v1_copy_rate)
            print('after fetch')
		WHILE (@@FETCH_STATUS = 0) BEGIN
            
            set @v_opbal_unsold=0      set @v_op_branch_rec =0    set @v_op_branch_trf=0     set @v_op_sale=0
            set @v_op_resale=0         set @v_op_comp_ret   =0    set @v_op_short_excess=0   set @v_opbal=0
            set @v_branch_rec_copy=0   set @v_branch_trf_copy=0   set @v_unsold_copy=0       set @v_sale_copy=0
            set @v_resale_copy=0       set @v_comp_ret_copy =0    set @v_short_excess=0

            /*-------for opening balance ----------*/            
            select @v_opbal_unsold = isnull(sum(isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0)),0) 
            from cir_unsold_dtl 
            where comp_code = @pcompcode and unit_code = @punitcode and doctype='UCN' and recptdt < @v_frdt and publ=@v1_publ and edtn = @v1_edtn and
            copy_rate = @v1_copy_rate and (branch_code = @pbrancode or @pbrancode is null)

            select @v_op_branch_rec=isnull(sum(edtn_copy),0) from cir_branch_return_det 
                where comp_code = @pcompcode and unit_code = @punitcode and doctype='TI' and recptdt<@v_frdt and
                publ_code=@v1_publ and edtn_code=@v1_edtn and edtn_rate=@v1_copy_rate and (branch_code = @pbrancode or @pbrancode is null)

            select @v_op_branch_trf=isnull(sum(edtn_copy),0) from cir_branch_return_det 
                where comp_code = @pcompcode and unit_code = @punitcode and doctype='TRF' and recptdt<@v_frdt and
                publ_code=@v1_publ and edtn_code=@v1_edtn and edtn_rate=@v1_copy_rate and (branch_code = @pbrancode or @pbrancode is null)
            
            select @v_op_sale=isnull(sum(no_of_copy),0) from cir_return_sale_det
                where comp_code = @pcompcode and unit_code = @punitcode and doctype='RET' and recptdt<@v_frdt and
                publ_code=@v1_publ and edtn_code=@v1_edtn and edtn_rate=@v1_copy_rate and (branch_code = @pbrancode or @pbrancode is null)

            /*select isnull(sum(return_copy),0) into v_op_comp_ret from cir_company_return_det
                where comp_code = @pcompcode and unit_code = @punitcode and doctype='RET' and recptdt<@v_frdt and
                publ_code = @v_publ and edtn_code = @v1_edtn and edtn_rate = @v1_copy_rate and (branch_code = @pbrancode or @pbrancode is null);*/

            select @v_op_comp_ret=isnull(sum(isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0)),0) 
            from cir_unsold_dtl_dis 
                where comp_code = @pcompcode and unit_code = @punitcode and doctype='UCN' and recptdt < @v_frdt and publ = @v1_publ and edtn = @v1_edtn and
                copy_rate = @v1_copy_rate and (branch_code = @pbrancode or @pbrancode is null)
            
            select @v_op_resale=isnull(sum(sup_copy),0) from cir_dbksup_resale 
                where comp_code = @pcompcode and unit_code = @punitcode and publ = @v1_publ and edtn = @v1_edtn and
                      supdate < @v_frdt and sup_rate = @v1_copy_rate and isnull(return_copy_sale,'N')='Y'
            
            select @v_op_short_excess = isnull(sum(isnull(short_excess,1)*no_of_copy),0) from cir_physical_ver_det
                where comp_code = @pcompcode and unit_code = @punitcode and doctype='VR' and recptdt<@v_frdt and
                publ_code=@v1_publ and edtn_code=@v1_edtn and edtn_rate=@v1_copy_rate and (branch_code = @pbrancode or @pbrancode is null)
            /*-------for opening balance ----------*/

            
            set @v_opbal=isnull(@v_opbal_unsold,0)+isnull(@v_op_branch_rec,0)-isnull(@v_op_branch_trf,0)-isnull(@v_op_sale,0)-isnull(@v_op_comp_ret,0)-isnull(@v_op_resale,0)+isnull(@v_op_short_excess,0);
            
            /*-------for Period from to till date----------*/    
            select @v_unsold_copy =isnull(sum(isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0)),0) 
            from cir_unsold_dtl 
            where comp_code = @pcompcode and unit_code = @punitcode and doctype='UCN' and recptdt >= @v_frdt and recptdt <= @v_todt and
             publ = @v1_publ and edtn=@v1_edtn and copy_rate = @v1_copy_rate and (branch_code = @pbrancode or @pbrancode is null)
            
            select @v_branch_rec_copy=isnull(sum(edtn_copy),0) from cir_branch_return_det 
                where comp_code = @pcompcode and unit_code = @punitcode and doctype='TI' and recptdt >= @v_frdt and recptdt <= @v_todt and
                publ_code = @v1_publ and edtn_code = @v1_edtn and edtn_rate=@v1_copy_rate and (branch_code = @pbrancode or @pbrancode is null)                   

            select @v_branch_trf_copy=isnull(sum(edtn_copy),0)  from cir_branch_return_det 
                where comp_code = @pcompcode and unit_code = @punitcode and doctype='TRF' and recptdt >= @v_frdt and recptdt <= @v_todt and
                publ_code = @v1_publ and edtn_code = @v1_edtn and edtn_rate = @v1_copy_rate and (branch_code = @pbrancode or @pbrancode is null)

            select @v_sale_copy=isnull(sum(no_of_copy),0) from cir_return_sale_det
                where comp_code = @pcompcode and unit_code = @punitcode and doctype='RET' and recptdt >= @v_frdt and recptdt <= @v_todt and
                publ_code = @v1_publ and edtn_code = @v1_edtn and edtn_rate = @v1_copy_rate and (branch_code = @pbrancode or @pbrancode is null)

            /*select isnull(sum(return_copy),0) into v_comp_ret_copy from cir_company_return_det
                where comp_code = @pcompcode and unit_code = @punitcode and doctype='RET' and recptdt >= @v_frdt and recptdt <= @v_todt and
                publ_code = @v1_publ and edtn_code = @v1_edtn and edtn_rate = @v1_copy_rate and (branch_code = @pbrancode or @pbrancode is null)*/

            select @v_comp_ret_copy = isnull(sum(isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0)),0) 
            from cir_unsold_dtl_dis
                where comp_code = @pcompcode and unit_code = @punitcode and doctype='UCN' and recptdt >= @v_frdt and recptdt <= @v_todt and
                publ = @v1_publ and edtn = @v1_edtn and copy_rate = @v1_copy_rate and (branch_code = @pbrancode or @pbrancode is null) 
                                         
            select @v_resale_copy=isnull(sum(sup_copy),0) from cir_dbksup_resale 
                where comp_code = @pcompcode and unit_code = @punitcode and publ = @v1_publ and edtn = @v1_edtn and
                      supdate >= @v_frdt and supdate >= @v_todt and sup_rate = @v1_copy_rate and isnull(return_copy_sale,'N')='Y'

            select @v_short_excess = isnull(sum(isnull(short_excess,1)*no_of_copy),0)  from cir_physical_ver_det
                where comp_code = @pcompcode and unit_code = @punitcode and doctype='VR' and recptdt >= @v_frdt and recptdt <= @v_todt and
                publ_code = @v1_publ and edtn_code = @v1_edtn and edtn_rate = @v1_copy_rate and (branch_code = @pbrancode or @pbrancode is null)
		print(@v_opbal)
		print('1')print(@v_unsold_copy)
		print('2')print(@v_branch_rec_copy)
		print('3')print(@v_short_excess)
		print('4')print(@v_branch_trf_copy)
		print('5')print(@v_sale_copy)
		print('6')print(@v_resale_copy)
	    /*-------for Period from to till date----------*/                 
            if abs(isnull(@v_opbal,0))+isnull(@v_unsold_copy,0)+isnull(@v_branch_rec_copy,0)+isnull(@v_sale_copy,0)+isnull(@v_resale_copy,0)+isnull(@v_comp_ret_copy,0)+
                isnull(@v_branch_trf_copy,0)+abs(isnull(@v_short_excess,0))<>0 Begin

				insert into #cir_temp_unsold_stock(comp_code,unit_code,branch_code,publ_code,edtn_code,ason_dt,copy_rate,
						opbal,unsold_return,branch_rec,unsold_sale,unsold_resale,comp_return,branch_tran,short_excess)
                values(@pcompcode, @punitcode, @pbrancode, @v1_publ, @v1_edtn, @v_todt, @v1_copy_rate, @v_opbal, @v_unsold_copy, @v_branch_rec_copy,
						@v_sale_copy, @v_resale_copy, @v_comp_ret_copy, @v_branch_trf_copy, @v_short_excess)
            end
	    fetch NEXT FROM C1 INTO @v1_publ, @v1_edtn, @v1_copy_rate
        end
	close c1
	deallocate c1
        
    select a.comp_code comp_code,a.unit_code unit_code,a.branch_code branch_code,a.publ_code publ_code,dbo.cir_get_publ_seqno(a.comp_code,a.publ_code) publ_seqno,
    dbo.cir_get_name_cir_publ(a.comp_code,a.publ_code,'1',@pdateformat,null,null) publ_name,
    b.main_edtn main_edtn_code,dbo.cir_get_edtn_seqno(a.comp_code,b.main_edtn) main_edtn_seqno,
    a.edtn_code edtn_code,dbo.cir_get_edtn_seqno(a.comp_code,a.edtn_code) edtn_seqno,dbo.cir_get_name_cir_edtn(a.comp_code,a.unit_code,a.edtn_code,'1',@pdateformat,null,null) edtn_name,
    a.copy_rate copy_rate,
    a.opbal opbal,a.unsold_return unsold_return,a.branch_rec branch_rec,a.unsold_sale unsold_sale,
    isnull(a.opbal,0)+isnull(a.unsold_return,0)+isnull(a.branch_rec,0) tot,
    a.unsold_resale unsold_resale,a.comp_return comp_return,a.branch_tran branch_tran,
    ((isnull(a.opbal,0)+isnull(a.unsold_return,0)+isnull(a.branch_rec,0))-(isnull(a.unsold_sale,0)+isnull(a.unsold_resale,0)+isnull(a.comp_return,0)+isnull(a.branch_tran,0))) total_bal,
    a.short_excess short_excess,((isnull(a.opbal,0)+isnull(a.unsold_return,0)+isnull(a.branch_rec,0))-(isnull(a.unsold_sale,0)+isnull(a.unsold_resale,0)+isnull(a.comp_return,0)+isnull(a.branch_tran,0)))+isnull(a.short_excess,0) closing_bal 
    from #cir_temp_unsold_stock a,cir_edtn_mast b where a.comp_code=b.comp_code and a.edtn_code=b.edtn
    order by publ_seqno,publ_code,main_edtn_seqno,edtn_seqno,edtn_code,copy_rate
    
    drop table #cir_temp_unsold_stock

End