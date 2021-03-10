/////////////////update by garima
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER procedure [dbo].[cir_check_duplicacy_late_fee]
    @pcompcode       as varchar(200),
    @punitcode       as varchar(200),
    @ppublcode       as varchar(200),
    @pedtncode       as varchar(200),
    @peffdate        as datetime,
    @pdateformat     as varchar(200),
    @pextra1         as varchar(200),
    @pextra2         as varchar(200)
as
begin

    select count(*) "REC_COUNT" from cir_late_fee_mast 
    where comp_code=@pcompcode and unit_code=@punitcode and publ_code=@ppublcode and 
    edtn_code=@pedtncode and valid_from=@peffdate;

 
end
/////////////////////

/***********************updated by Neha for receipt entry*****************/

 SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cir_circulation_accounts_cir_upd_recpt_amt]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[cir_circulation_accounts_cir_upd_recpt_amt]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@pdoctyp                                  VARCHAR(20) ,
	@pagcd                                    VARCHAR(20) ,
	@pdpcd                                    VARCHAR(20) ,
	@precptno                                 VARCHAR(20) ,
	@precptdt                                 VARCHAR(20) ,
	@pnock_amt                                FLOAT ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS 
	
		
		DECLARE @vrecpt_balamt                            NUMERIC(10,2) 
		DECLARE @vquery                                   VARCHAR(4000) 


		set @vquery = ''update cir_outmast set amount=isnull(amount,0)+abs(isnull(''+''''''''+@pnock_amt+''''''''+ '',0)) 
								  where comp_code= ''+''''''''+@pcomp_code+''''''''+'' and 
										unit_code= ''+''''''''+@punit_code+''''''''+'' and
										doctyp   = ''+''''''''+@pdoctyp+''''''''+'' and
										agcd     = ''+''''''''+@pagcd+''''''''+'' and
										dpcd     = ''+''''''''+@pdpcd+''''''''+'' and
										recptno  = ''+''''''''+@precptno+''''''''+'' and
										recptdt  = to_date(''+''''''''+@precptdt+''''''''+'',''+''''''''+@pdateformat+''''''''+'') and
										billno is null and
										billdt is null'';


/*

	SELECT @vquery  = ''update cir_outmast set amount=nvl(amount,0)+abs(nvl('' + @pnock_amt + '',0)) 
 where comp_code='' + @pcomp_code + '' and  unit_code='' + @punit_code + '' and doctyp   ='' + @pdoctyp + '' and   
 agcd  ='' + @pagcd + '' and  dpcd     ='' + @pdpcd + '' and  recptno  ='' + @precptno + '' 
and  recptdt  = to_date('' + @precptdt + '','' + @pdateformat + '') and  billno is null and  billdt is null'' 

*/



print(@vquery)
exec(@vquery)

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cir_doc_bind_cir_doc_view_p]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[cir_doc_bind_cir_doc_view_p]
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
		 OR	@pdoctyp  is null  OR	@pdoctyp  = '''')
		 AND	((UPPER(doc_Name)  like UPPER(@pextra1) + ''%'')
		 OR	(@pextra1  is null)  OR	(@pextra1  = '''' ))
		

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnNumToWords]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE   FUNCTION [dbo].[fnNumToWords](@Number Numeric(18,2),@CPaise Char(1))
RETURNS varchar(100) AS  
BEGIN
	
	Declare @StrNumber varchar(10), @SLacs char(2), @SThou char(2), @SHun char(2)
	Declare @STenUnt char(2), @STen char(2), @SUnt char(2), @SDecimal char(2)
	Declare @ILacs Int, @IThou Int, @IHun Int, @ITenUnt Int, @ITen Int, @IUnt Int, @IDecimal Int
	Declare @SNumToWords varchar(100), @Wwords varchar(10)

	Select @StrNumber = Replicate(''0'',10-Len(LTrim(RTrim(convert(varchar,@Number))))) + LTrim(RTrim(Convert(varchar,@Number)))
	--Print @StrNumber
	--Print Len(@StrNumber)
	Select @SNumToWords = ''''

	--Print Len(LTrim(RTrim(convert(varchar,@Number))))
	If Len(LTrim(RTrim(convert(varchar,@Number)))) > 4
	Begin
		--Print Len(@StrNumber)
		Select @SLacs = Substring(@StrNumber,1,2)
		--Print @SLacs
		Select @ILacs = Convert(int,@SLacs)
		If @ILacs > 0
		Begin
			Select @STen = Substring(@StrNumber,1,1)
			Select @SUnt = Substring(@StrNumber,2,1)

			if Convert(int,@STen) = 1 
			Begin
				Select @ITen = Convert(int,Substring(@StrNumber,1,2))
				Select @IUnt = 0
			End
			Else
			Begin
				Select @ITen = Convert(int,@STen)*10
				Select @IUnt = Convert(int,@SUnt)
			End

			If @ITen > 0 
			Begin			
				Select @Wwords = ''''
				Select @Wwords = Wwords From M_Words Where WNumber = @ITen
				--Print @Wwords
				Select @SNumToWords = @SNumToWords + Space(1) + @Wwords --'' Tens''
			End

			If @IUnt > 0 
			Begin			
				Select @Wwords = ''''
				Select @Wwords = Wwords From M_Words Where WNumber = @IUnt
				--Print @Wwords
				Select @SNumToWords = @SNumToWords + Space(1) + @Wwords --'' Unit''
			End

			--Select @Wwords = ''''
			--Select @Wwords = Wwords From M_Words Where WNumber = @ILacs
			--Print @Wwords
			Select @SNumToWords = @SNumToWords + '' Lacs''
		End

		Select @SThou = Substring(@StrNumber,3,2)
		--Print @SThou
		Select @IThou = Convert(int,@SThou)
		If @IThou > 0
		Begin
			Select @STen = Substring(@StrNumber,3,1)
			Select @SUnt = Substring(@StrNumber,4,1)

			if Convert(int,@STen) = 1 
			Begin
				Select @ITen = Convert(int,Substring(@StrNumber,3,2))
				Select @IUnt = 0
			End
			Else
			Begin
				Select @ITen = Convert(int,@STen)*10
				Select @IUnt = Convert(int,@SUnt)
			End
			
			If @ITen > 0 
			Begin			
				Select @Wwords = ''''
				Select @Wwords = Wwords From M_Words Where WNumber = @ITen
				--Print @Wwords
				Select @SNumToWords = @SNumToWords + Space(1) + @Wwords --'' Tens''
			End

			If @IUnt > 0 
			Begin			
				Select @Wwords = ''''
				Select @Wwords = Wwords From M_Words Where WNumber = @IUnt
				--Print @Wwords
				Select @SNumToWords = @SNumToWords + Space(1) + @Wwords --'' Unit''
			End

			--Select @Wwords = ''''
			--Select @Wwords = Wwords From M_Words Where WNumber = @IThou
			--Print @Wwords
			--Select @SNumToWords = @SNumToWords + @Wwords + '' Thousand ''
			Select @SNumToWords = @SNumToWords + '' Thousand ''
		End

		Select @SHun = Substring(@StrNumber,5,1)
		--Print @SHun
		Select @IHun = Convert(int,@SHun)
		If @IHun > 0
		Begin
			Select @Wwords = ''''
			Select @Wwords = Wwords From M_Words Where WNumber = @IHun
			--Print @Wwords
			Select @SNumToWords = @SNumToWords + @Wwords + '' Hundred''
		End

		Select @STenUnt = Substring(@StrNumber,6,2)
		---Print @STenUnt

		Select @ITenUnt = Convert(int,@STenUnt)

		If @ITenUnt > 0
		Begin
			Select @STen = Substring(@StrNumber,6,1)
			Select @SUnt = Substring(@StrNumber,7,1)

			if Convert(int,@STen) = 1 
			Begin
				Select @ITen = Convert(int,Substring(@StrNumber,6,2))
				Select @IUnt = 0
			End
			Else
			Begin
				Select @ITen = Convert(int,@STen)*10
				Select @IUnt = Convert(int,@SUnt)
			End

			
			If @ITen > 0 
			Begin			
				Select @Wwords = ''''
				Select @Wwords = Wwords From M_Words Where WNumber = @ITen
				--Print @Wwords
				Select @SNumToWords = @SNumToWords + Space(1) + @Wwords --'' Tens''
			End

			If @IUnt > 0 
			Begin			
				Select @Wwords = ''''
				Select @Wwords = Wwords From M_Words Where WNumber = @IUnt
				--Print @Wwords
				Select @SNumToWords = @SNumToWords + Space(1) + @Wwords --'' Unit''
			End
		End

		Select @SNumToWords = @SNumToWords + Space(1) + ''Rupees''		--Only/-



	End
	Else
	Begin
		--Print Len(@StrNumber)
		--Print LTrim(RTrim(convert(varchar,@Number)))
		Select @SLacs = Substring(LTrim(RTrim(convert(varchar,@Number))),1,1)
		--Print @SLacs
		Select @ILacs = Convert(int,@SLacs)
		If @ILacs > 0 and @ILacs <> 1
		Begin
			Select @Wwords = ''''
			Select @Wwords = Wwords From M_Words Where WNumber = @ILacs
			--Print @Wwords
			Select @SNumToWords = @SNumToWords + Space(1) + @Wwords + Space(1) + ''Rupees''
		End
		Else
		Begin
			Select @Wwords = ''''
			Select @Wwords = Wwords From M_Words Where WNumber = @ILacs
			--Print @Wwords
			Select @SNumToWords = @SNumToWords + @Wwords + Space(1) + ''Rupee''
		End
	End

	If @CPaise = ''Y''
	Begin
		Select @SDecimal = Substring(@StrNumber,9,2)
		Select @IDecimal = Convert(int,@SDecimal)
		If @IDecimal > 0
		Begin
			Select @SNumToWords = @SNumToWords + '' and''
			Select @STen = Substring(@SDecimal,1,1)
			Select @SUnt = Substring(@SDecimal,2,1)
	
			if Convert(int,@STen) = 1 
			Begin
				Select @ITen = Convert(int,Substring(@StrNumber,9,2))
				Select @IUnt = 0
			End
			Else
			Begin
				Select @ITen = Convert(int,@STen)*10
				Select @IUnt = Convert(int,@SUnt)
			End
			
			If @ITen > 0 
			Begin			
				Select @Wwords = ''''
				Select @Wwords = Wwords From M_Words Where WNumber = @ITen
				--Print @Wwords
				Select @SNumToWords = @SNumToWords + Space(1) + @Wwords --'' Tens''
			End
	
			If @IUnt > 0 
			Begin			
				Select @Wwords = ''''
				Select @Wwords = Wwords From M_Words Where WNumber = @IUnt
				--Print @Wwords
				Select @SNumToWords = @SNumToWords + Space(1) + @Wwords --'' Unit''
			End
	
			Select @SNumToWords = @SNumToWords + Space(1) + ''Paise''	
	
		End
	End

	--Print LTrim(RTrim(@SNumToWords))
	Return LTrim(RTrim(@SNumToWords))

End
' 
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cir_account_mast_fa_receipt_credit_head_p]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[cir_account_mast_fa_receipt_credit_head_p]
	@pcompcode                                VARCHAR(20) ,
	@pdoctype                                 VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000)
AS 

		SELECT *
		FROM  fa_acc_mast 
		WHERE	 comp_code  = @pcompcode
		 AND	((UPPER(acc_name)  like ''%'' + UPPER(@pextra1) + ''%'') OR	(@pextra1  is null))
		ORDER BY acc_name 
		


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cir_account_mast_fa_receipt_debit_head_p]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[cir_account_mast_fa_receipt_debit_head_p]
	@pcompcode                                VARCHAR(20) ,
	@pdoctype                                 VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS 
	
		SELECT *
		FROM  fa_acc_mast 
		WHERE	 comp_code  = @pcompcode
		 AND	((UPPER(acc_name)  like ''%'' + UPPER(@pextra1) + ''%'') OR	(@pextra1  is null))
		ORDER BY acc_name 
		

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CIR_bankbind_p]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CIR_bankbind_p]
	@pcompcode                                VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS 

		
		SELECT
				 bankcode  bankcode,
				 bankname  bankname
		FROM  cir_bank_mast 
		WHERE	 comp_code  = @pcompcode
		 AND	((UPPER(bankname)  like UPPER(@pextra1) + ''%'')
		 OR	(@pextra1  is null))
		ORDER BY bankname 
		


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cir_paymode_bind_p]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'                                                                     
                                                                     
                                                                     
                                             
CREATE PROCEDURE [dbo].[cir_paymode_bind_p]
	@pcomp_code                               VARCHAR(20) ,
	@pdoc_type                                VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS 
		DECLARE @vflagforreceiptentry                     VARCHAR(600) 
		IF ( @pdoc_type != ''RCR'' ) 
		BEGIN 
			
			SELECT
					 reason_code REASON_CODE,
					 reason_name REASON_NAME,
					 ''N'' MODE_TYPE
			FROM  cir_reason_mst 
			WHERE	 comp_code  = @pcomp_code
			 AND	((UPPER(reason_name)  like UPPER(@pextra1) + ''%'') OR	(@pextra1  is null) OR (@pextra1 =''''))
			ORDER BY reason_name 
		END
		ELSE
		BEGIN 
			SELECT
					 Pay_Mode_Code Pay_Mode_Code,
					 Payment_Mode_Name Payment_Mode_Name,
					 payment_mode_type MODE_TYPE
			FROM  Payment_Mode_Mast 
			WHERE	 Comp_Code  = @pcomp_code
			 AND	((UPPER(Payment_Mode_Name)  like UPPER(@pextra1) + ''%'') OR	(@pextra1  is null) OR (@pextra1 =''''))
			ORDER BY Payment_Mode_Name 
END' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cir_get_payreason]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'                                                              
                                             
CREATE FUNCTION [dbo].[cir_get_payreason](
    @pcomp_code  as varchar(20),
    @pdoc_type   as varchar(20),
    @ppayreason  as varchar(20),
    @pdateformat as varchar(20),
    @pextra1     as varchar(200),
    @pextra2     as varchar(200),
    @pextra3     as varchar(200),
    @pextra4     as varchar(200),
    @pextra5     as varchar(200))  returns varchar(100) as
   
Begin
	 DECLARE @v_desc   AS	varchar(100)
    if(@pdoc_type !=''RCR'') Begin
        select @v_desc=reason_name from cir_reason_mst 
            where comp_code = @pcomp_code and upper(reason_code) =@ppayreason
		End
    else
		Begin
        select distinct @v_desc="Payment_Mode_Name" from Payment_Mode_Mast 
            where /*"Comp_Code"=@pcomp_code and*/ upper("Pay_Mode_Code") =@ppayreason
		End
    return ISNULL(@v_desc,@ppayreason)
END

' 
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cir_publ_bind_p]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[cir_publ_bind_p]
	@pcomp_code                               VARCHAR(4000) ,
	@pdateformat                              VARCHAR(4000) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
	
AS 
	
		SELECT *
		FROM  cir_publ_mast 
		WHERE	 comp_code  = @pcomp_code
		 AND	((UPPER(publ_name)  like UPPER(@pextra1) + ''%'')
		 OR	(@pextra1  is null)  OR	(@pextra1  = '''') );
		

		



' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cir_publ_bind1]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE  [dbo].[cir_publ_bind1]

 @pcomp_code as varchar(200),
 @ppubl_code as varchar(200),
 @pdateformat as varchar(200),
 @pextra1 as varchar(200),
 @pextra2 as varchar(200)

 AS
   
    select * from cir_publ_mast
                 where comp_code = @pcomp_code and 
                       (publ=@ppubl_code or @ppubl_code is null) and 
                        ISNULL(freeze_flag,''N'')=''N''
                 order by publ_name




' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cir_company_detail_p]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N' CREATE Procedure [dbo].[cir_company_detail_p]


     @pcompcode           VARCHAR(20) ,
     @plangtype           VARCHAR(20) ,---1 for enlish and 2 for other language
     @pdateformat         VARCHAR(20) ,
     @pextra1             VARCHAR(200) ,
     @pextra2             VARCHAR(200) 


  As
 


        select comp_mst.*,(select distinct "City_Name" from city_mst where City_Code=comp_mst."City_Code")  CITY_NAME,
        (SELECT distinct "Country_Name" FROM count_mst where "Country_Code"=comp_mst."Country_Code") COUNTRY_NAME from comp_mst 
        where ("Comp_Code"=@pcompcode or @pcompcode is null or @pcompcode = '''')
        order by "Comp_Code";

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cir_get_login]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE  FUNCTION [dbo].[cir_get_login](@puserid as varchar(20))RETURNs VARCHAR(800) as

BEGIN

	declare	 c1 cursor for
	select "username" as username  from login where userid=@puserid

	declare @username11 as varchar(400)

	open c1
	FETCH NEXT FROM c1 INTO @username11
	close c1
	
	return isnull (@username11,'''')
End
' 
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cir_receipt_ref_receipt_P]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'                                                                     
                                                                     
                                                                     
                                             
CREATE PROCEDURE [dbo].[cir_receipt_ref_receipt_P]
    @pcompcode       as varchar(20),
    @punitcode       as varchar(20),
    @pdoctype        as varchar(20),
    @precptno        as varchar(20),
    @precptdt        as datetime,
    @preasoncode     as varchar(20),
    @puserid         as varchar(20),
    @pdateformat     as varchar(20),
    @pextra1         as varchar(20),
    @pextra2         as varchar(20)
    as
begin
    
    select h.comp_code comp_code,h.unit_code unit_code,h.agcd agcd,h.dpcd dpcd,m.ag_name ag_name,h.doctype doctype,h.recptno recptno,h.recptdt recptdt,
    abs(h.amount) AS amount,h.chno chno,h.chdt chdt,h.chbank chbank,h.reason reason,h.prov_rec_no prov_rec_no,
    h.prov_rec_dt prov_rec_dt,h.received_from received_from,h.achd achd,h.ccdp debit_head,
	(select acc_name from fa_acc_mast where comp_code=h.comp_code and cdp=h.ccdp) as credit_head_name,
	h.rcdp credit_head,(select acc_name from fa_acc_mast where comp_code=h.comp_code and cdp=h.rcdp) as debit_head_name
    from cir_rcphdr h,cir_agmast m
    where h.comp_code=m.comp_code and h.comp_code=@pcompcode and h.unit_code=m.unit and h.unit_code=@punitcode and 
    h.doctype=@pdoctype and h.recptno=@precptno and h.recptdt=@precptdt and h.agcd=m.agcd and h.dpcd=m.dpcd and h.chno is not null
    
End


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cir_receiptmodify]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'                                                                     
                                                                     
                                                                     
                                             
CREATE PROCEDURE [dbo].[cir_receiptmodify]
    @pcompcode       as varchar(20),
    @punitcode       as varchar(20),
    @pbrancode       as varchar(20),
    @pdoctype        as varchar(20),
    @pagcd           as varchar(20),
    @pdpcd           as varchar(20),
    @precptno        as varchar(50),
    @precptdt        as datetime,
    @pamount         as numeric(14,2),
    @pchno           as varchar(50),
    @pchdt           as datetime,
    @pchbank         as varchar(20),
    @pothamount      as numeric(14,2),
    @pccdp           as varchar(20),
    @pccds           as varchar(20),
    @prcdp           as varchar(20),
    @prcds           as varchar(20),
    @pocdp           as varchar(20),
    @pocds           as varchar(20),
    @preason         as varchar(20),
    @premark         as varchar(2000),
    @pvoucherno      as varchar(50),
    @pvoucherdt      as datetime,
    @pvchtype        as varchar(20),
    @ppubl           as varchar(20),
    @preceived_from  as varchar(200),
    @ptdsrate        as numeric(14,2),
    @ptdsamt         as numeric(14,2),
    @pstaxrate       as numeric(14,2),
    @pstaxamt        as numeric(14,2),
    @pref_recptno    as varchar(20),
    @pref_recptdt    as datetime,
    @pref_amount     as numeric(14,2),
    @pref_doctype    as varchar(20),
    @pprov_rec_no    as varchar(20),
    @pprov_rec_dt    as datetime,
    @premark_oth     as varchar(2000),
    @puserid         as varchar(20),
    @pdateformat     as varchar(20),
    @pextra1         as varchar(200),
    @pextra2         as varchar(200),
    @pextra3         as varchar(200),
    @pextra4         as varchar(200),
    @pextra5         as varchar(200)
    As
	declare @vquery   as   int
        declare @vamount  as   numeric(14,2)
        declare @v_cnt    as   int
    Begin
        select @vquery=Dsign from cir_docmst where comp_code=@pcompcode and doc_type=@pdoctype

        set @vamount=@pamount*@vquery
        
        select @v_cnt=count(*) from cir_outmast 
            where comp_code=@pcompcode and unit_code = @punitcode and doctyp = @pdoctype and recptno=@precptno and 
            billno is not null
        
        if isnull(@v_cnt,0)=0 Begin--if no any bill adjustment in entires     
            update cir_rcphdr set agcd=@pagcd,  dpcd=@pdpcd, recptdt=@precptdt, chno=@pchno, chdt=@pchdt, chbank=@pchbank,  amount=@vamount,oth_amount=@pothamount,
                reason = @preason, remark =@premark,received_from = @preceived_from , ccdp=@pccdp, rcdp=@prcdp, ocdp=@pocdp,
                publ=@ppubl,tdsrate=@ptdsrate, tdsamt=@ptdsamt, staxrate= @pstaxrate , staxamt=@pstaxamt ,
                ref_recptno=@pref_recptno ,ref_recptdt =ref_recptdt,ref_amount=@pref_amount, ref_doctype=@pref_doctype, 
                prov_rec_no=@pprov_rec_no, prov_rec_dt= @pprov_rec_dt, remark_oth= @premark_oth
                where comp_code=@pcompcode and unit_code = @punitcode and doctype = @pdoctype and recptno=@precptno
            
            update cir_rcpdet set agcd=@pagcd,  dpcd=@pdpcd, recptdt=@precptdt, chno=@pchno, chdt=@pchdt, chbnk=@pchbank,  amount=@vamount,
                reason = @preason, remark =@premark,publ=@ppubl  
                where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and recptno=@precptno
                
            update cir_outmast set agcd=@pagcd,  dpcd=@pdpcd, recptdt=@precptdt, chno=@pchno, chdt=@pchdt, chbnk=@pchbank,  amount=@vamount,
                reason = @preason, remark =@premark,publ=@ppubl 
                    where comp_code =@pcompcode and unit_code = @punitcode and doctyp=@pdoctype and recptno =@precptno
	End
        else
	Begin   
	    update cir_rcphdr set remark=@premark, reason=@preason , received_from=@preceived_from ,chno=@pchno, chdt=@pchdt, chbank=@pchbank,
            ccdp=@pccdp, rcdp=@prcdp, ocdp=@pocdp,publ=@ppubl,ref_recptno=@pref_recptno ,ref_recptdt =@pref_recptdt,ref_amount=@pref_amount, ref_doctype=@pref_doctype, 
                prov_rec_no=@pprov_rec_no, prov_rec_dt= @pprov_rec_dt, remark_oth= @premark_oth
                where comp_code=@pcompcode and unit_code = @punitcode and doctype = @pdoctype and recptno=@precptno

            update cir_rcpdet  set remark=@premark ,reason = @preason,chno=@pchno, chdt=@pchdt, chbnk=@pchbank 
                where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and recptno=@precptno;

            update cir_outmast set remark =@premark,reason = @preason,chno=@pchno, chdt=@pchdt, chbnk=@pchbank
                   where comp_code =@pcompcode and unit_code = @punitcode and doctyp=@pdoctype and recptno =@precptno

        End 
    End 
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cir_get_receipt_exist]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[cir_get_receipt_exist]
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
	if upper(@pextra2)=''D'' Begin
		select @v_rec_exist = count(*) from cir_rcphdr_dis where comp_code=@pcomp_code and unit_code=@punit_code and 
		doctype=@pdoctype and recptno=@precptno and agcd=@pagcd and dpcd=@pdpcd and branch_code=@pbran_code
	End	
	else Begin
	select @v_rec_exist = count(*) from cir_rcphdr where comp_code=@pcomp_code and unit_code=@punit_code and 
		doctype=@pdoctype and recptno=@precptno and agcd=@pagcd and dpcd=@pdpcd and branch_code=@pbran_code	
	End     
  return @v_rec_exist;
END
' 
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cir_get_backdays_validate]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'                                                                  
                                                                     
                                                                     
                                             
CREATE FUNCTION [dbo].[cir_get_backdays_validate](
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

	set @v_validate      =''N''
    set @v_dt=@pentry_date
	set @v_curr_dt= CONVERT(VARCHAR(10), GETDATE(), 101)

	IF @v_curr_dt >= @v_dt and @v_dt is not null 
	Begin
		set @v_backdays  = DATEDIFF(dd,@v_curr_dt , @v_dt )

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
				return ''Y''
			End
	    Else 
			Begin
				return ''N''
			End
	End
    Else 
	Begin
        If upper(@pformname)=upper(''cir_supplyposting'') 
			Begin
				return ''Y''
			End
        Else 
			Begin
				return ''N''
			End
    End
	return ''N''
End
' 
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cir_doc_bind_cir_doc_bind_p]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'                                                                     
                                                                     
                                                                     
                                             
CREATE PROCEDURE [dbo].[cir_doc_bind_cir_doc_bind_p]
	@pcompcode                                VARCHAR(20) ,
	@pflag                                    VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS 
		SELECT
				 comp_code  "Comp_code",
				 userid  "userid",
				 doc_type  "doc_type",
				 doc_name  "doc_Name",
				 dsign  "Dsign",
				 creation_datetime  "Creation_Datetime",
				 flagforreceiptentry  "flagforreceiptentry"
		FROM  cir_docmst 
		WHERE	 Comp_code  = @pcompcode
		 AND	(flagforreceiptentry  = @pflag or @pflag is null or @pflag='''')
		 AND	((UPPER(doc_Name)  like UPPER(@pextra1) + ''%'') OR	(@pextra1  is null))
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cir_chk_doc_permission]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
                                                                     
                                                                     
                                                                     
                                             
CREATE PROCEDURE [dbo].[cir_chk_doc_permission](
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
		DOCTYPE=@pdoctypes and USER_ID=@loginid and (AMOUNT<@pamount or @pamount is null or @pamount='''');
       
      if(  @vcount='''' or @vcount is null)begin
		set @vcount=0
		end
  

    if(@vcount=0) begin
     
        select ''ok'' as "output" 
	end
    else begin
       
        select ''novalue'' as "output" 
    end 
end

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cir_city_bind_p1]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[cir_city_bind_p1]
	@pcomp_code                               VARCHAR(20) ,
	@pcity_code                               VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS 
	
		SELECT *
		FROM  cir_city_mast 
		WHERE	 comp_code  = @pcomp_code
		 AND	((city_code  = @pcity_code)
		 OR	(@pcity_code  is null) OR	(@pcity_code  = ''''))
		 AND	((UPPER(city_name)  like UPPER(@pextra1) + ''%'')
		 OR	(@pextra1  is null) OR	(@pextra1  = ''''))
		


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cir_get_recpt_balamt]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[cir_get_recpt_balamt]
(
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@pdoctyp                                  VARCHAR(20) ,
	@pagcd                                    VARCHAR(20) ,
	@pdpcd                                    VARCHAR(20) ,
	@precptno                                 VARCHAR(20) ,
	@precptdt                                 DATETIME , -------- SEND COVERTED DATE
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
)
RETURNS FLOAT 
AS 
	BEGIN
		
		 --v_rcptdt    date;
		
		DECLARE @vrecpt_balamt                            NUMERIC(10,2) 
		--   v_rcptdt:=to_date(precptdt,''''''''||pdateformat||'''''''');
		
SET @vrecpt_balamt = 0
	if upper(@pextra2)=''D''
	begin

		SELECT @vrecpt_balamt  =  ABS(SUM(CONVERT(FLOAT, amount)))
		FROM  cir_outmast_dis 
		WHERE	 comp_code  = @pcomp_code
		 AND	unit_code  = @punit_code
		 AND	doctyp  = @pdoctyp
		 AND	agcd  = @pagcd
		 AND	dpcd  = @pdpcd
		 AND	recptno  = @precptno
		 AND	recptdt  = CONVERT(DATETIME, @precptdt)
		 AND	billno  is null
		 AND	billdt  is null
		
end
else

begin
SELECT @vrecpt_balamt  =  ABS(SUM(CONVERT(FLOAT, amount)))
		FROM  cir_outmast 
		WHERE	 comp_code  = @pcomp_code
		 AND	unit_code  = @punit_code
		 AND	doctyp  = @pdoctyp
		 AND	agcd  = @pagcd
		 AND	dpcd  = @pdpcd
		 AND	recptno  = @precptno
		 AND	recptdt  = CONVERT(DATETIME, @precptdt)
		 AND	billno  is null
		 AND	billdt  is null
end
--		SELECT @adv_error = @@ERROR, @adv_rowcount=@@ROWCOUNT
--		IF @adv_error != 0 
--		BEGIN
--			GOTO Exception2
--		END
--
--		GOTO ExitLabel2
--		Exception2:
			
--			IF @adv_rowcount = 0 
--			BEGIN
--			
--			SET @vrecpt_balamt  = 0 
--	
--			END
--			ELSE   
--			BEGIN
--			
--			SET @vrecpt_balamt  = 0 
--			
--			END
		
		
	        SET @vrecpt_balamt =	 ISNULL(@vrecpt_balamt, 0) 
       
            RETURN @vrecpt_balamt

	END' 
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cir_executive_bind1]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE  [dbo].[cir_executive_bind1]

 @pcompcode as varchar(200),
 @pexecode as varchar(200),
 @pdateformat as varchar(200),
 @pextra1 as varchar(200),
 @pextra2 as varchar(200)

 AS
   select * from cir_executive_mast
                    where comp_code=@pcompcode and 
                          (executive_code=@pexecode or @pexecode is null) and
                          	ISNULL(freeze_flag,''N'')=''N''
                    order by executive_desc




' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cir_executive_bind]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE  [dbo].[cir_executive_bind]

 @pcompcode as varchar(200),
 @pdateformat as varchar(200),
 @pextra1 as varchar(200),
 @pextra2 as varchar(200)

 AS
   select * from cir_executive_mast
                    where comp_code=@pcompcode and
                           	ISNULL(freeze_flag,''N'')=''N''
                    order by executive_desc




' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cir_agency_bind_cir_agency_bind_p1]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[cir_agency_bind_cir_agency_bind_p1]
	@pcompcode			VARCHAR(20) ,
	@punit              VARCHAR(20) ,
	@pagcd              VARCHAR(20) ,
	@pdpcd              VARCHAR(20) ,
	@pdateformat        VARCHAR(20) ,
	@pextra1            VARCHAR(400) ,
	@pextra2            VARCHAR(400) 
AS 
BEGIN
	
 if upper(@pextra2)=''D'' begin
      
            select * from cir_agmast_dis
             where comp_code = @pcompcode and
                   unit = @punit and 
                   agcd=@pagcd and 
                   dpcd=@pdpcd 
                   --and ISNULL(freeze_flag,''N'')=''N''
             order by ag_name;
   end  else
        begin
            select * from cir_agmast
             where comp_code = @pcompcode and
                   unit = @punit and 
                   agcd=@pagcd and 
                   dpcd=@pdpcd 
                   --and ISNULL(freeze_flag,''N'')=''N''
             order by ag_name;
     end 	
END



' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cir_get_agency_opening]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[cir_get_agency_opening](
    @pcomp_code  as  varchar(20),
    @punit_code  as  varchar(20),
    @ppubl_code  as  varchar(20),
    @pagcd       as  varchar(20),
    @pdpcd       as  varchar(20),
    @pason_date  as  datetime,
    @pac_type    as  varchar(20),
    @pdateformat as  varchar(20),
    @puserid     as  varchar(20),
    @pextra1     as  varchar(200),
    @pextra2     as  varchar(200)) returns numeric(15,2) as


Begin
    declare @v_findt     datetime
    declare @v_ason      datetime
    declare @v_opbal     numeric(15,2)
    declare @v_amt       numeric(15,2)
    
    set @v_ason      =@pason_date       
    set @v_findt     =dbo.cir_get_finandt(@pcomp_code,@pason_date,@pdateformat,'''','''');--for financial date
    
    set @v_opbal     =dbo.cir_accounts_cir_agency_opbal(@pcomp_code,@punit_code,@ppubl_code,@pagcd,@pdpcd,@v_findt,@pac_type,@pdateformat,null,null);
    
    set @v_amt       =dbo.cir_accounts_cir_agency_ytodt(@pcomp_code,@punit_code,@ppubl_code,@pagcd,@pdpcd,@v_findt,@v_ason,@pac_type,@pdateformat,null,null);
    
    return isnull(@v_opbal,0)+isnull(@v_amt,0)
End' 
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cir_publwise_outstanding_p]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[cir_publwise_outstanding_p]
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
                where comp_code=@pcompcode and unit=isnull(@punitcode,unit) and agcd=isnull(@pagcd,agcd) and dpcd=isnull(@pdpcd,dpcd)
                order by ag_name
        
        DECLARE cur_publ cursor for
            select publ from cir_publ_mast where comp_code=@pcompcode and publ=isnull(@ppublcode,publ) order by publ;
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
	
		SET @v_opdate  = DBO.cir_get_finandt(@pcompcode, dbo.convert_user_date(''/'', @pason_date, @pdateformat), @pdateformat, '''', '''')--for financial date
		
        delete from #cir_temp_outstanding;

        open c1;
            fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit,@v1_agcd,@v1_dpcd,@v1_ag_name,@v1_ag_name_oth_lang,@v1_city_code,@v1_tehsil_taluka,@v1_dist_code,@v1_state_code,@v1_country_code    
            WHILE (@@FETCH_STATUS = 0) 
			BEGIN 
            
				open cur_publ
                fetch NEXT FROM cur_publ INTO @v_publ
                WHILE (@@FETCH_STATUS = 0) 
				BEGIN     
				
					set @v_opbal     =	dbo.cir_accounts_cir_agency_opbal(@v1_comp_code,@v1_unit,@v_publ,@v1_agcd,@v1_dpcd,@v_opdate,@pactype,@pdateformat,null,null);
	            
					set @v_amt       =	dbo.cir_accounts_cir_agency_ytodt(@v1_comp_code,@v1_unit,@v_publ,@v1_agcd,@v1_dpcd,@v_opdate,@pason_date+1,@pactype,@pdateformat,null,null)
	            
					set @v_clbal=isnull(@v_opbal,0)+isnull(@v_amt,0)
	            
					If @v_clbal<>0 Begin
	            
						insert into #cir_temp_outstanding(comp_code,unit_code,dt,publ_code,agcd,dpcd,bill_amt,
										agname,agname_oth_lang,city_code,taluka_code,dist_code,state_code,country_code)
								 values(@v1_comp_code,@v1_unit,@pason_date,@v_publ,@v1_agcd,@v1_dpcd,@v_clbal,
										@v1_ag_name,@v1_ag_name_oth_lang,@v1_city_code,@v1_tehsil_taluka,@v1_dist_code,@v1_state_code,@v1_country_code)
					End
				fetch NEXT FROM cur_publ INTO @v_publ
				
				set @v_amt=0 set @v_opbal    =0 set @v_clbal=0 set @v_publ=null
				End
				close cur_publ
				
				fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit,@v1_agcd,@v1_dpcd,@v1_ag_name,@v1_ag_name_oth_lang,@v1_city_code,@v1_tehsil_taluka,@v1_dist_code,@v1_state_code,@v1_country_code
			End
        close c1
		DEALLOCATE c1
		DEALLOCATE cur_publ
        select a.comp_code as "COMP_CODE",a.unit_code as "UNIT_CODE",a.agcd as "AGCD",a.dpcd as "DPCD",
        a.bill_amt as "CL_BAL",a.agname as "AGNAME",a.agname_oth_lang as "AGNAME_OTH_LANG",
        a.city_code as "CITY_CODE",dbo.cir_get_city(a.comp_code,a.city_code) as "CITY_NAME",
        a.publ_code as "PUBL",dbo.cir_get_publ_name(a.comp_code,a.publ_code) as "PUBL_NAME"
        from #cir_temp_outstanding a
        order by comp_code,unit_code,publ_name
        
        select getdate() as "CUR_DATE"
         drop table #cir_temp_outstanding
     
End' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cir_receipt_for_chqbounce]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[cir_receipt_for_chqbounce]
    @pcompcode			as varchar(20),
    @punitcode			as varchar(20),
    @pdoctype			as varchar(20),
    @pagcd				as varchar(20),
    @pdpcd				as varchar(20),
    @precptno			as varchar(200),
    @prpt_fromdt		as datetime,
    @prpt_tilldt		as datetime,
    @pchqno				as varchar(200),
    @pchq_fromdt		as datetime,
    @pchq_tilldt		as datetime,
    @pchqbnk_code		as varchar(20),
    @puserid			as varchar(20),
    @pdateformat		as varchar(20),
    @pextra1			as varchar(200),
    @pextra2			as varchar(200),
    @pextra3			as varchar(200),
    @pextra4			as varchar(200),
    @pextra5			as varchar(200),
    @pextra6			as varchar(200),
    @pextra7			as varchar(200),
    @pextra8			as varchar(200),
    @pextra9			as varchar(200),
    @pextra10			as varchar(200)
as

begin
    If	@punitcode='''' Begin
		set @punitcode=null
	End	
    If	@precptno='''' Begin
		set @precptno=null
	End	
    If	@pchqno='''' Begin
		set @pchqno=null
	End	
    If	@pchq_fromdt='''' Begin
		set @pchq_fromdt=null
	End	
    If	@pchq_tilldt='''' Begin
		set @pchq_tilldt=null
	End	
    If	@pchqbnk_code='''' Begin
		set @pchqbnk_code=null
	End					
    If	@pchq_tilldt='''' Begin
		set @pchq_tilldt=null
	End	
    If	@pchqbnk_code='''' Begin
		set @pchqbnk_code=null
	End

    select h.comp_code as "COMP_CODE",h.unit_code as "UNIT_CODE",h.agcd as "AGCD",h.dpcd as "DPCD",m.ag_name as "AG_NAME",dbo.cir_get_city(h.comp_code,m.city_code) as "CITY_NAME",
    h.doctype as "DOCTYPE",h.recptno as "RECPTNO",h.recptdt as "RECPTDT",abs(h.amount) AS "AMOUNT",h.chno as "CHNO",h.chdt as "CHDT",h.chbank as "CHBANK",
    (select bankname from cir_bank_mast where comp_code=h.comp_code and bankcode=h.chbank) as "CHQBANK_NMAE",
    h.reason as "REASON",h.prov_rec_no as "PROV_REC_NO",h.prov_rec_dt as "PROV_REC_DT",h.received_from as "RECEIVED_FROM",h.achd as "ACHD",
    h.ccdp as "DEBIT_HEAD",(select acc_name from fa_acc_mast where comp_code=h.comp_code and cdp=h.ccdp) as "CREDIT_HEAD_NAME",
    h.rcdp as "CREDIT_HEAD",(select acc_name from fa_acc_mast where comp_code=h.comp_code and cdp=h.rcdp) as "DEBIT_HEAD_NAME"
    from cir_rcphdr h,cir_agmast m
    where h.comp_code=m.comp_code and h.comp_code=@pcompcode and h.unit_code=m.unit and h.unit_code=isnull(@punitcode,h.unit_code) and 
    h.doctype=@pdoctype and h.recptno=isnull(@precptno,h.recptno) and h.recptdt>=@prpt_fromdt and h.recptdt<=@prpt_tilldt and 
    h.agcd=m.agcd and h.agcd=@pagcd and h.dpcd=m.dpcd and h.dpcd=@pdpcd and 
    (h.chno=@pchqno or @pchqno is null) and 
    ((h.chdt between @pchq_fromdt and @pchq_tilldt) or @pchq_fromdt is null or @pchq_tilldt is null) and
    (h.chbank=@pchqbnk_code or @pchqbnk_code is null) and h.reason=''CH0'' and not exists(select ''x'' from cir_rcphdr where comp_code=h.comp_code and 
    unit_code=h.unit_code and ref_doctype=h.doctype and ref_recptno=h.recptno and ref_recptdt=h.recptdt and agcd=h.agcd and dpcd=h.dpcd)
    order by recptdt desc,recptno
    
End' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cir_receipt_for_provision]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[cir_receipt_for_provision]
    @pcompcode       as varchar(20),
    @punitcode       as varchar(20),
    @pdoctype        as varchar(20),
    @ppayreason      as varchar(20),
    @pagcd           as varchar(20),
    @pdpcd           as varchar(20),
    @prpt_fromdt     as datetime,
    @prpt_tilldt     as datetime,
    @puserid         as varchar(200),
    @pdateformat     as varchar(200),
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
    as
begin


    If @punitcode='''' Begin
		set @punitcode =null
	End	
    If @ppayreason='''' Begin
		set @ppayreason =null
	End	
    If @pagcd='''' Begin
		set @pagcd =null
	End
    If @pdpcd='''' Begin
		set @pdpcd =null
	End	

    select h.comp_code as "COMP_CODE",h.unit_code as "UNIT_CODE",h.agcd as "AGCD",h.dpcd as "DPCD",m.ag_name as "AG_NAME",
    dbo.cir_get_city(h.comp_code,m.city_code) as "CITY_NAME",dbo.cir_get_drop_point_name(h.comp_code,h.unit_code,m.station_code,1) as "DROP_POINT_NAME",
    h.doctype as "DOCTYPE",h.recptno as "RECPTNO",h.recptdt as "RECPTDT",abs(h.amount) AS "AMOUNT",h.chno as "CHNO",h.chdt as "CHDT",h.chbank as "CHBANK",
    (select bankname from cir_bank_mast where comp_code=h.comp_code and bankcode=h.chbank) as "CHQBANK_NMAE",
    h.reason as "REASON",case when h.doctype=''RCR'' then (select "Payment_Mode_Name" from payment_mode_mast where "Pay_Mode_Code"=h.reason)
    else (select reason_name from cir_reason_mst where comp_code=h.comp_code and reason_code=h.reason) end as "REASON_NAME",
    h.received_from as "RECEIVED_FROM",(select executive_desc from cir_executive_mast where comp_code=h.comp_code and executive_code=h.received_from) as "RECEIVED_FROM_NAME"
    from cir_rcphdr_prov h,cir_agmast m
    where h.comp_code=m.comp_code and h.comp_code=@pcompcode and h.unit_code=m.unit and h.unit_code=isnull(@punitcode,h.unit_code) and 
    h.doctype=@pdoctype and h.recptdt>=@prpt_fromdt and h.recptdt<=@prpt_tilldt and 
    h.agcd=m.agcd and h.agcd=isnull(@pagcd,h.agcd) and h.dpcd=m.dpcd and h.dpcd=isnull(@pdpcd,h.dpcd) and not exists(select ''x'' from cir_rcphdr where comp_code=h.comp_code and 
    unit_code=h.unit_code and ref_doctype=h.doctype and ref_recptno=h.recptno and ref_recptdt=h.recptdt and agcd=h.agcd and dpcd=h.dpcd)
    order by recptdt desc,recptno
    
End' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CIR_RECEIPT_DATA_MOVE]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[CIR_RECEIPT_DATA_MOVE]
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
    set @v_dt=dbo.convert_user_date(''/'', @precptdt,@pdateformate)
    
    if upper(@prectype)=''D'' Begin
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
		
			select @v_recno=count(*) from cir_rcpt_document_dis_temp
			where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
						recptno=@precptno and recptdt=@v_dt
			If @v_recno>0 Begin		                    
				insert into cir_rcpt_document_dis(comp_code, unit_code, doctype, recptno, recptdt, filename, created_by, created_dt)
				select comp_code, unit_code, doctype, recptno, recptdt, filename, created_by, created_dt from cir_rcpt_document_dis_temp
				where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
							recptno=@precptno and recptdt=@v_dt
			End						
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
		
		select @v_recno=count(*) from cir_rcpt_document_temp
        where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
                    recptno=@precptno and recptdt=@v_dt
        If @v_recno>0 Begin            		
			insert into cir_rcpt_document(comp_code, unit_code, doctype, recptno, recptdt, filename, created_by, created_dt)
			select comp_code, unit_code, doctype, recptno, recptdt, filename, created_by, created_dt from cir_rcpt_document_temp
			where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
						recptno=@precptno and recptdt=@v_dt
		End						
    end           
    
    if upper(@prectype)=''D'' Begin
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
		if upper(@prectype)=''D'' Begin
			delete from cir_rcphdr_dis_temp 
				where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
					recptno=@precptno and recptdt=@v_dt
			End
		else Begin
			delete from cir_rcphdr_temp 
				where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
					recptno=@precptno and recptdt=@v_dt
		End
        select @v_recno as "RECNO"
		End
     else Begin
        select 0 as "RECNO"
     End

end' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cir_Gen_Code_receipt_p]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE PROCEDURE [dbo].[Cir_Gen_Code_receipt_p]
    @pcompcode                                VARCHAR(4000) ,
    @pbranchcode                              VARCHAR(4000) ,
    @pdoctype                                 VARCHAR(4000) ,
    @precptdt                                 VARCHAR(4000) ,
    @pdateformat                              VARCHAR(4000) ,
    @pextra1                                  VARCHAR(4000) ,
    @pextra2                                  VARCHAR(4000) 
AS 
        DECLARE @vno                                      NUMERIC(20) 
        DECLARE @vrecptno                                 VARCHAR(15) 
        DECLARE @v_dt                                     DATETIME 
        DECLARE @v_sess_id                                NUMERIC(20) 

        set @v_sess_id=(SELECT top 1 session_id  FROM sys.dm_exec_requests where sql_handle is not null);
        
        SET @v_dt  =   dbo.convert_user_date(''/'', @precptdt,@pdateformat) 
        if UPPER(@pextra2)=''D''
			begin
				SELECT @vno  =  CONVERT(NUMERIC(8, 2), MAX(SUBSTRING(recptno, 5, 8))) + 1
				FROM  cir_rcphdr_dis 
				WHERE     comp_code  = @pcompcode
				 AND    doctype  = @pdoctype
				 AND    CONVERT(VARCHAR(23), recptdt)  = CONVERT(VARCHAR(23), @v_dt)
				 AND    branch_code  = @pbranchcode
			end
        else
			begin
				SELECT @vno  =  CAST( MAX(SUBSTRING(recptno, 5, 8))AS NUMERIC) + 1--CONVERT(NUMERIC(8, 2), MAX(SUBSTRING(recptno, 5, 8))) + 1
				FROM  cir_rcphdr 
				WHERE comp_code  = @pcompcode
				AND doctype  = @pdoctype
				AND  CONVERT(VARCHAR(23), recptdt)  = CONVERT(VARCHAR(23), @v_dt)
				AND  branch_code  = @pbranchcode
			end
        
        IF ISNULL(@vno, 0)= 0 
			BEGIN 
				SET @vrecptno  = @pbranchcode + ''-'' + REPLACE(CONVERT(VARCHAR(5), GETDATE(), 2), ''.'', '''')+ ''0001'' 
			END
        ELSE
			BEGIN 
				SET @vrecptno  = @pbranchcode + ''-'' + dbo.fnPadLeft(''0'',8,@vno) 
			END
   
        SELECT @vrecptno as VAR_CODE


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cir_agency_bind_cir_branch_billagency_p]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[cir_agency_bind_cir_branch_billagency_p]
	@pcompcode				VARCHAR(20) ,
	@punit                  VARCHAR(20) ,
	@pbranchcode            VARCHAR(20) ,
	@pdateformat            VARCHAR(20) ,
	@pextra1                VARCHAR(400) ,
	@pextra2                VARCHAR(400) 
AS 
	If upper(@pextra2)=''D'' Begin
            select cir_agmast_dis.* ,dbo.cir_get_city(cir_agmast_dis.comp_code,cir_agmast_dis.city_code) "CITY_NAME" from cir_agmast_dis
              where comp_code = @pcompcode and unit = @punit and
                        (branch_code=@pbranchcode or @pbranchcode is null or @pbranchcode='''') and
                        ((upper(ag_name) like upper(@pextra1+''%'')) or (@pextra1 is null) or (@pextra1='''')) and
                  isnull(freeze_flag,''N'')=''N''
            union
            select cir_agmast_dis.* ,dbo.cir_get_city(cir_agmast_dis.comp_code,cir_agmast_dis.city_code) "CITY_NAME" from cir_agmast_dis
              where comp_code = @pcompcode and
                        unit = @punit and
                        (branch_code=@pbranchcode or @pbranchcode is null or @pbranchcode='''') and
                        ((upper(agcd) like upper(@pextra1+''%'')) or (@pextra1 is null) or (@pextra1='''')) and
                  isnull(freeze_flag,''N'')=''N''      
            order by 5
       End     
       Else Begin
            select cir_agmast.* ,dbo.cir_get_city(cir_agmast.comp_code,cir_agmast.city_code) "CITY_NAME" from cir_agmast
              where comp_code = @pcompcode and
                        unit = @punit and
                        (branch_code=@pbranchcode or @pbranchcode is null or @pbranchcode='''') and
                        ((upper(ag_name) like upper(@pextra1+''%'')) or (@pextra1 is null) or (@pextra1='''')) and
                  isnull(freeze_flag,''N'')=''N''
            union
            select cir_agmast.* ,dbo.cir_get_city(cir_agmast.comp_code,cir_agmast.city_code) "CITY_NAME" from cir_agmast
              where comp_code = @pcompcode and
                        unit = @punit and
                        (branch_code=@pbranchcode or @pbranchcode is null or @pbranchcode='''') and
                        ((upper(agcd) like upper(@pextra1+''%'')) or (@pextra1 is null) or (@pextra1='''')) and
                  isnull(freeze_flag,''N'')=''N''      
            order by 5
       End' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cir_circulation_accounts_cir_pendingbills_p]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[cir_circulation_accounts_cir_pendingbills_p]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@ppubl                                    VARCHAR(20) ,
	@pagcd                                    VARCHAR(20) ,
	@pdpcd                                    VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS 

		SELECT
				 billno as BILLNO,billdt as BILLDT,publ PUBL,
				 DBO.cir_get_publ_name(comp_code, publ) PUBL_NAME,
				 SUM(CONVERT(FLOAT, amount)) as AMOUNT
		FROM  cir_outmast 
		WHERE comp_code  = @pcomp_code
		 AND (unit_code  = @punit_code)
		 AND agcd  = @pagcd AND	dpcd  = @pdpcd
		 AND publ  = @ppubl AND billno  is not null
		GROUP BY billno,billdt,publ,DBO.cir_get_publ_name(comp_code, publ) 
		HAVING SUM(CONVERT(FLOAT, amount))  > 0  
		

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cir_circulation_accounts_cir_pendingbills_p1]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[cir_circulation_accounts_cir_pendingbills_p1]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@ppubl                                    VARCHAR(20) ,
	@pagcd                                    VARCHAR(20) ,
	@pdpcd                                    VARCHAR(20) ,
	@pfrdt                                    VARCHAR(20) ,
	@ptodt                                    VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(400) ,
	@pextra2                                  VARCHAR(400) 
AS 
/* ***************            SEND       from date and todate in date format from datetime in sql class           ***************************/

declare 	@pfrdt11                                   datetime
declare	    @ptodt11                                   datetime

set @pfrdt11 = dbo.convert_user_date(''/'',@pfrdt,@pdateformat)
set @ptodt11 = dbo.convert_user_date(''/'',@ptodt,@pdateformat)

print(@pfrdt11)
print(@ptodt11)

		SELECT o.comp_code as "COMP_CODE",o.billno as "BILLNO",o.billdt as "BILLDT",o.publ as "PUBL",
			 DBO.cir_get_publ_name(o.comp_code, o.publ) as "PUBL_NAME",
			 dbo.cir_get_publ_type(o.comp_code,o.publ,null,null) as "PUBL_TYPE",
			 SUM(CONVERT(FLOAT, o.amount)) as "AMOUNT",
			 (select distinct ISNULL(b.dispute_flag,''N'') from cir_outmast b 
			 where b.comp_code=@pcomp_code and b.unit_code=@punit_code and 
                b.doctyp=''BIL'' and b.agcd =@pagcd and b.dpcd =@pdpcd and b.billno=o.billno and
                b.billdt=o.billdt) as "DISPUTE_FLAG"
		FROM  cir_outmast o
		WHERE o.comp_code  = @pcomp_code
		 AND (o.unit_code  = @punit_code)
		 AND o.agcd  = @pagcd AND o.dpcd = @pdpcd
		 AND ((o.publ = @ppubl) OR (@ppubl is null) OR (@ppubl=''''))
		 AND o.billno is not null AND o.billno<>''''
		 AND o.billdt  between  @pfrdt11 and @ptodt11
		GROUP BY o.comp_code,o.billno,o.billdt,o.publ 
		HAVING SUM(CONVERT(FLOAT, o.amount)) > 0 order by publ_type,publ_name,billdt,BILLNO 

' 
END
/**************************end*******************************************************************


//==============================Issue no. 4832=============================================


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
ALTER  PROCEDURE [dbo].[cir_rep_billing_cir_before_bill_print_p1]
	@pcompcode        as varchar(4000),
    @punitcode        as varchar(4000),
    @ppubl_freq       as varchar(4000),
    @ppubl            as varchar(4000),
    @pagencytype      as varchar(4000),
    @pagencyclass     as varchar(4000),
    @pbranchcode      as varchar(4000),
    @pdistcode        as varchar(4000),
    @ptaluka          as varchar(4000),
    @pbillagcd        as varchar(4000),
    @pbilldpcd        as varchar(4000),
    @pfrom_date       as datetime,
    @ptill_date       as datetime,
    @plangtype        as varchar(4000),
    @pdateformat      as varchar(4000),
    @pextra1          as varchar(4000),
    @pextra2          as varchar(4000)
AS 
	BEGIN
		SET NOCOUNT ON
		SET CONCAT_NULL_YIELDS_NULL OFF	
	
	declare @v_frdt  datetime
	declare @v_todt  datetime
	declare @v_start_date    datetime

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
	(
		COMP_CODE VARCHAR (8) , 
		UNIT_CODE VARCHAR (8) , 
		BILLNO VARCHAR (20) , 
		BILLDT DATETIME  , 
		PUBL_CODE VARCHAR (8) , 
		EDTN_CODE VARCHAR (8) , 
		AGCD VARCHAR (8) , 
		DPCD VARCHAR (8) , 
		SUPPLY_DATE DATETIME  , 
		SUPPLY_COPY NUMERIC (10) , 
		SUPPLY_RATE NUMERIC (10, 2) , 
		COMM_RATE NUMERIC (12, 2) , 
		SUR_RATE NUMERIC (10, 2) , 
		RETURN_COPY NUMERIC (10) , 
		RETURN_AMT NUMERIC (14, 2) , 
		CUR_SESSIONID NUMERIC  , 
		GROSS_AMT NUMERIC (15, 2) DEFAULT  0 , 
		COMM_AMT NUMERIC (15, 5) DEFAULT  0 , 
		SUR_AMT NUMERIC (15, 2) , 
		SEC_AMT NUMERIC (15, 2) DEFAULT  0 , 
		BRANCH_CODE VARCHAR (8) , 
		REC_AMT NUMERIC (15, 2) DEFAULT  0 
	)
	CREATE TABLE #CIR_BILL_RETURN_PRINT 
	(
		COMP_CODE VARCHAR (8) , 
		UNIT_CODE VARCHAR (8) , 
		BRANCH_CODE VARCHAR (8) , 
		BILLNO VARCHAR (20) , 
		BILLDT DATETIME  , 
		PUBL_CODE VARCHAR (8) , 
		EDTN_CODE VARCHAR (8) , 
		AGCD VARCHAR (8) , 
		DPCD VARCHAR (8) , 
		RECEIPT_DATE DATETIME  , 
		RETURN_COPY NUMERIC (10) , 
		SUPPLY_RATE NUMERIC (10, 2) , 
		COMM_RATE NUMERIC (12, 2) , 
		SUR_RATE NUMERIC (10, 2) , 
		GROSS_AMT NUMERIC (15, 2) DEFAULT  0 , 
		COMM_AMT NUMERIC (15, 5) DEFAULT  0 , 
		SUR_AMT NUMERIC (15, 2) DEFAULT  0 , 
		CUR_SESSIONID NUMERIC  DEFAULT  @@SPID 
	)
-- parameters for cursor cur_not_supply start
declare @rec_not_supply_comp_code as varchar(50)
declare @rec_not_supply_unit_code as varchar(50)
declare @rec_not_supply_agcd as varchar(50)
declare @rec_not_supply_dpcd as varchar(50)
declare @rec_not_supply_publ as varchar(50)
declare @rec_not_supply_edtn as varchar(50)
declare @rec_not_supply_supply_date as datetime
declare @rec_not_supply_copy_rate as varchar(50)
-- @rec_not_supply_comp_code,@rec_not_supply_unit_code,@rec_not_supply_agcd,@rec_not_supply_dpcd,@rec_not_supply_publ,@rec_not_supply_edtn,@rec_not_supply_supply_date,@rec_not_supply_copy_rate
-- end here cur_not_supply end




-- parameters for cursor cur_agcd start
declare @rec_agcd_comp_code as varchar(50)
declare @rec_agcd_unit_code as varchar(50)
declare @rec_agcd_publ as varchar(50)
declare @rec_agcd_billagcd as varchar(50)
declare @rec_agcd_billdpcd as varchar(50)
-- @rec_agcd_comp_code,@rec_agcd_unit_code,@rec_agcd_publ,@rec_agcd_billagcd,@rec_agcd_billdpcd
-- end here cur_agcd end
		declare @v_return_copy     numeric(10)
        declare @v_return_amt      numeric(10,2)
        declare @vbill_no          varchar(20)
        declare @v_rec_amt         numeric
        set @v_rec_amt=0
        declare @v_rcp_count       numeric
        set @v_rcp_count=0
        declare @v_prev_agcd       varchar(30)
        set @v_prev_agcd=  'XX'
        declare @v_cur_agcd        varchar(30)
        set @v_cur_agcd=  'XX'
        declare @v_opdate          datetime
        declare @v_opbal           numeric(14,2)
        set @v_opbal=0
        declare @v_billamt         numeric(14,2)
        set @v_billamt=0
        declare @v_dbcramt         numeric(14,2)
        set @v_dbcramt=0
        declare @v_dbamt           numeric(14,2)
        set @v_dbamt=0
        declare @v_cramt           numeric(14,2)
        set @v_cramt=0
        declare @v_recamt          numeric(14,2)
        set @v_recamt=0
        declare @v_secamt          numeric(14,2)
        set @v_secamt=0
        declare @v_psecamt          numeric(14,2)
        set @v_psecamt=0
        declare @v_csecamt          numeric(14,2)
        set @v_csecamt=0


		set @v_frdt      =@pfrom_date
		set @v_todt      =@ptill_date
		set @v_opdate    =dbo.cir_get_finandt(@pcompcode,@pfrom_date,@pdateformat,'','');
        set @v_start_date =[dbo].[GetFirstDayOfMonth] ( @v_frdt)
        
		delete from #cir_temp_outstanding
		delete from #cir_bill_print
		delete from #cir_bill_return_print 

		if @v_frdt=@v_start_date begin
			exec cir_rep_billing_cir_before_bill_process_p @pcompcode,@punitcode,@ppubl_freq,@ppubl,@pfrom_date,@ptill_date,@pbillagcd,@pbilldpcd,@pagencytype,@pagencyclass ,@pbranchcode, @pdistcode , @ptaluka,@pdateformat,'','',''
		end
		else
		begin
			exec cir_rep_billing_cir_before_bill_process_p @pcompcode,@punitcode,@ppubl_freq,@ppubl,@v_start_date,@ptill_date,@pbillagcd,@pbilldpcd,@pagencytype,@pagencyclass ,@pbranchcode, @pdistcode , ptaluka,@pdateformat,'','',''
		end

DECLARE cur_not_supply CURSOR LOCAL FOR 
	SELECT DISTINCT
				 u.comp_code comp_code,
				 u.unit_code unit_code,
				 u.agcd agcd,
				 u.dpcd dpcd,
				 u.publ publ,
				 u.edtn edtn,
				 u.supply_date supply_date,
				 u.copy_rate copy_rate
		FROM (	SELECT DISTINCT
					 d.comp_code,
					 d.unit_code,
					 d.agcd,
					 d.dpcd,
					 d.publ,
					 d.edtn,
					 d.recptdt supply_date,
					 d.copy_rate
			FROM  cir_agmast m,
				 cir_unsold_dtl d 
			WHERE	 d.comp_code  = m.comp_code
			 AND	d.comp_code  = @pcompcode
			 AND	d.unit_code  = m.unit
			 AND	d.unit_code  = @punitcode
			 AND	d.app_dt  >= @v_start_date
			 AND	d.app_dt  <= @v_todt
			 AND	d.agcd  = m.agcd
			 AND	d.dpcd  = m.dpcd
			 AND	d.agcd  = ISNULL(@pbillagcd, d.agcd)
			 AND	d.dpcd  = ISNULL(@pbilldpcd, d.dpcd)
			 AND	(m.ag_type  = @pagencytype
			 OR	@pagencytype  is null)
			 AND	(m.ag_class  = @pagencyclass
			 OR	@pagencyclass  is null)
			 AND	(m.dist_code  = @pdistcode
			 OR	@pdistcode  is null)
			 AND	(m.tehsil_taluka  = @ptaluka
			 OR	@ptaluka  is null)
			 AND	d.supply_copy  > 0
			 AND	(m.branch_code  = @pbranchcode
			 OR	@pbranchcode  is null)
			 AND	(ISNULL(d.apr_late_recpt, 0) + ISNULL(d.apr_short_recpt, 0) + ISNULL(d.apr_bnr, 0) + ISNULL(d.apr_unsold, 0))  > 0
			 AND	 NOT EXISTS
				(
	 			SELECT
						 ADV_INNER_ALIAS_0.comp_code,
						 ADV_INNER_ALIAS_0.unit_code,
						 ADV_INNER_ALIAS_0.agcd,
						 ADV_INNER_ALIAS_0.dpcd,
						 ADV_INNER_ALIAS_0.publ_code publ,
						 ADV_INNER_ALIAS_0.edtn_code edtn,
						 ADV_INNER_ALIAS_0.supply_date,
						 ADV_INNER_ALIAS_0.supply_rate copy_rate
				FROM  cir_bill_print ADV_INNER_ALIAS_0 
				WHERE	 comp_code  = @pcompcode
				 AND	unit_code  = @punitcode
				 AND	supply_date  >= @v_start_date
				 AND	supply_date  <= @v_todt
				 AND	agcd  = ISNULL(@pbillagcd, agcd)
				 AND	dpcd  = ISNULL(@pbilldpcd, dpcd)
				 AND	supply_copy  > 0
				 AND	d.comp_code  = ADV_INNER_ALIAS_0.comp_code
				 AND	d.unit_code  = ADV_INNER_ALIAS_0.unit_code
				 AND	d.agcd  = ADV_INNER_ALIAS_0.agcd
				 AND	d.dpcd  = ADV_INNER_ALIAS_0.dpcd
				 AND	d.publ  = ADV_INNER_ALIAS_0.publ_code
				 AND	d.edtn  = ADV_INNER_ALIAS_0.edtn_code
				 AND	d.recptdt  = ADV_INNER_ALIAS_0.supply_date
				 AND	d.copy_rate  = ADV_INNER_ALIAS_0.supply_rate
				)
		) u 

		OPEN cur_not_supply 
			FETCH NEXT FROM cur_not_supply INTO @rec_not_supply_comp_code,@rec_not_supply_unit_code,@rec_not_supply_agcd,@rec_not_supply_dpcd,@rec_not_supply_publ,@rec_not_supply_edtn,@rec_not_supply_supply_date,@rec_not_supply_copy_rate
			WHILE (@@FETCH_STATUS = 0) 
			BEGIN
				set @v_cur_agcd  =@rec_not_supply_agcd+@rec_not_supply_dpcd	
				
				if @v_prev_agcd<>@v_cur_agcd begin--XX & A0002
					set @v_prev_agcd =@v_cur_agcd
					select @vbill_no=max(cast(billno as numeric))  from #cir_bill_print 
					where comp_code=@pcompcode and unit_code=@punitcode and supply_date>= @v_start_date and supply_date<=@v_todt and 
					agcd=isnull(@pbillagcd,agcd) and dpcd=isnull(@pbilldpcd,dpcd) 				            
					
					if cast(@vbill_no as numeric)=0 begin
						select @vbill_no=max(cast(billno as numeric)) from #cir_bill_print 
						where comp_code=@pcompcode and unit_code=@punitcode and 
						supply_date>= @v_start_date and supply_date<=@v_todt 						
					end
				end
				SELECT
				@v_return_copy  =  SUM(CONVERT(FLOAT, ISNULL(apr_late_recpt, 0) + ISNULL(apr_short_recpt, 0) + ISNULL(apr_bnr, 0) + ISNULL(apr_unsold, 0))),
				@v_return_amt  =  SUM(CONVERT(FLOAT, ISNULL(copy_amt, 0) - ISNULL(waste_amt, 0)))
				FROM  cir_unsold_dtl 
				WHERE	 comp_code  = @rec_not_supply_comp_code
				AND	unit_code  = @rec_not_supply_unit_code
				AND	doctype  = 'UCN'
				AND	app_dt  = @rec_not_supply_supply_date
				AND	publ  = @rec_not_supply_publ
				AND	edtn  = @rec_not_supply_edtn
				AND	agcd  = @rec_not_supply_agcd
				AND	dpcd  = @rec_not_supply_dpcd
				AND	copy_rate  = @rec_not_supply_copy_rate
				AND	(ISNULL(apr_late_recpt, 0) + ISNULL(apr_short_recpt, 0) + ISNULL(apr_bnr, 0) + ISNULL(apr_unsold, 0))  > 0		
				
				SELECT @v_rec_amt  =  ABS(SUM(CONVERT(FLOAT, amount)))
				FROM  cir_rcphdr 
				WHERE	 comp_code  = @rec_not_supply_comp_code
				AND	unit_code  = @rec_not_supply_unit_code
				AND	doctype  = 'RCR'
				AND	recptdt  = @rec_not_supply_supply_date
				AND	agcd  = @rec_not_supply_agcd
				AND	dpcd  = @rec_not_supply_dpcd
				AND	achd  = 'NM'
				
				SELECT @v_rcp_count  =  COUNT(*)
				FROM  cir_bill_return_print 
				WHERE	 comp_code  = @rec_not_supply_comp_code
				AND	unit_code  = @rec_not_supply_unit_code
				AND	receipt_date  = @rec_not_supply_supply_date
				AND	agcd  = @rec_not_supply_agcd
				AND	dpcd  = @rec_not_supply_dpcd
				
				if isnull(@v_rcp_count,0)>0 begin
					set @v_rec_amt=0
				end
				else
				begin
					insert into #cir_bill_return_print(comp_code,unit_code,agcd,dpcd,receipt_date,sur_amt)
					values(@rec_not_supply_comp_code,@rec_not_supply_unit_code,@rec_not_supply_agcd,@rec_not_supply_dpcd,@rec_not_supply_supply_date,@v_rec_amt);
				end
				
			INSERT INTO  #cir_bill_print   
			( comp_code , 
			unit_code , 
			billno , 
			billdt , 
			publ_code , 
			edtn_code , 
			agcd , 
			dpcd , 
			supply_date , 
			supply_copy , 
			supply_rate , 
			gross_amt , 
			comm_rate , 
			comm_amt , 
			sur_rate , 
			sur_amt , 
			return_copy , 
			return_amt , 
			cur_sessionid , 
			rec_amt )  
			VALUES 		( @rec_not_supply_comp_code , 
			@rec_not_supply_unit_code , 
			@vbill_no , 
			@v_todt , 
			@rec_not_supply_publ , 
			@rec_not_supply_edtn , 
			@rec_not_supply_agcd , 
			@rec_not_supply_dpcd , 
			@rec_not_supply_supply_date , 
			0 , 
			@rec_not_supply_copy_rate , 
			0 , 
			0 , 
			0 , 
			0 , 
			0 , 
			@v_return_copy , 
			@v_return_amt , 
			@@SPID , 
			@v_rec_amt )  
			set @v_return_copy=0
			set @v_return_amt=0
			set @v_rcp_count=0
					
			FETCH NEXT FROM cur_not_supply INTO @rec_not_supply_comp_code,@rec_not_supply_unit_code,@rec_not_supply_agcd,@rec_not_supply_dpcd,@rec_not_supply_publ,@rec_not_supply_edtn,@rec_not_supply_supply_date,@rec_not_supply_copy_rate
			END	

		CLOSE cur_not_supply
		DEALLOCATE cur_not_supply

	DECLARE cur_agcd CURSOR LOCAL FOR 
		SELECT DISTINCT
		 d.comp_code comp_code,
		 d.unit_code unit_code,
		 '' publ,
		 d.agcd billagcd,
		 d.dpcd billdpcd
		FROM  cir_bill_print d 
		WHERE	 d.comp_code  = @pcompcode
		AND	d.unit_code  = @punitcode
		AND	d.supply_date  >= @v_start_date
		AND	d.supply_date  <= @v_todt
		AND	d.agcd  = ISNULL(@pbillagcd, d.agcd)
		AND	d.dpcd  = ISNULL(@pbilldpcd, d.dpcd)
		AND	(ISNULL(d.supply_copy, 0) + ISNULL(return_copy, 0))  > 0
		GROUP BY d.comp_code,
		d.unit_code,
		d.agcd,
		d.dpcd 
		ORDER BY d.comp_code,
		d.unit_code,
		d.agcd,
		d.dpcd 

		OPEN cur_agcd 
			FETCH NEXT FROM cur_agcd INTO @rec_agcd_comp_code,@rec_agcd_unit_code,@rec_agcd_publ,@rec_agcd_billagcd,@rec_agcd_billdpcd
			WHILE (@@FETCH_STATUS = 0) 
			BEGIN
				set @v_opbal=0
				set @v_billamt=0
				set @v_dbcramt =0
				set @v_dbamt =0
				set @v_cramt =0
				set @v_recamt =0
				set @v_secamt =0
				set @v_psecamt =0
				set @v_csecamt =0
				set @v_opbal = dbo.cir_accounts_cir_agency_opbal (@rec_agcd_comp_code,@rec_agcd_unit_code,'',@rec_agcd_billagcd,@rec_agcd_billdpcd,@v_opdate,'NM',@pdateformat,@pextra1,@pextra2)
			
				SELECT @v_billamt  =  SUM(CONVERT(FLOAT, bill_amount))
				FROM  cir_bill 
				WHERE	 comp_code  = @rec_agcd_comp_code
				AND	unit_code  = @rec_agcd_unit_code
				AND	agcd  = @rec_agcd_billagcd
				AND	dpcd  = @rec_agcd_billdpcd
				AND	billdt  >= @v_opdate
				AND	billdt  < @v_frdt
				
				SELECT @v_dbcramt  =  SUM(CONVERT(FLOAT, amount))
				FROM  cir_outmast 
				WHERE	 comp_code  = @rec_agcd_comp_code
				AND	unit_code  = @rec_agcd_unit_code
				AND	achd  = 'NM'
				AND	doctyp  <> 'BIL'
				AND	recptdt  >= @v_opdate
				AND	recptdt  < @v_frdt
				AND	agcd  = @rec_agcd_billagcd
				AND	dpcd  = @rec_agcd_billdpcd
				
				SELECT @v_dbamt  =  SUM(CONVERT(FLOAT, amount))
				FROM  cir_outmast 
				WHERE	 comp_code  = @rec_agcd_comp_code
				AND	unit_code  = @rec_agcd_unit_code
				AND	achd  = 'NM'
				AND	doctyp  not in ( 'BIL'  , 'RCR'  )
				AND	recptdt  >= @v_frdt
				AND	recptdt  <= @v_todt
				AND	agcd  = @rec_agcd_billagcd
				AND	dpcd  = @rec_agcd_billdpcd
				AND	amount  > 0
				
				SELECT @v_cramt  =  SUM(CONVERT(FLOAT, amount))
				FROM  cir_outmast 
				WHERE	 comp_code  = @rec_agcd_comp_code
				AND	unit_code  = @rec_agcd_unit_code
				AND	achd  = 'NM'
				AND	doctyp  not in ( 'BIL'  , 'RCR'  )
				AND	recptdt  >= @v_frdt
				AND	recptdt  <= @v_todt
				AND	agcd  = @rec_agcd_billagcd
				AND	dpcd  = @rec_agcd_billdpcd
				AND	amount  < 0
				
				SELECT @v_recamt  =  SUM(CONVERT(FLOAT, amount))
				FROM  cir_outmast 
				WHERE	 comp_code  = @rec_agcd_comp_code
				AND	unit_code  = @rec_agcd_unit_code
				AND	achd  = 'NM'
				AND	doctyp  = 'RCR'
				AND	recptdt  >= @v_frdt
				AND	recptdt  <= @v_todt
				AND	agcd  = @rec_agcd_billagcd
				AND	dpcd  = @rec_agcd_billdpcd
				
				set @v_opbal =isnull(@v_opbal,0)+isnull(@v_billamt,0)+isnull(@v_dbcramt,0);
                set @v_dbcramt=0
                set @v_dbcramt = dbo.cir_accounts_cir_agency_opbal(@rec_agcd_comp_code,@rec_agcd_unit_code,'',@rec_agcd_billagcd,@rec_agcd_billdpcd,@v_opdate,'SC',@pdateformat,@pextra1,@pextra2);
				
				SELECT @v_psecamt  =  SUM(CONVERT(FLOAT, amount))
				FROM  cir_rcphdr 
				WHERE	 comp_code  = @rec_agcd_comp_code
				AND	unit_code  = @rec_agcd_unit_code
				AND	achd  = 'SC'
				AND	recptdt  >= @v_opdate
				AND	recptdt  <= @v_todt
				AND	agcd  = @rec_agcd_billagcd
				AND	dpcd  = @rec_agcd_billdpcd
				
				set @v_secamt=isnull(@v_dbcramt,0)+isnull(@v_psecamt,0);
				
				SELECT @v_csecamt  =  ABS(SUM(CONVERT(FLOAT, sec_amt)))
				FROM  #cir_bill_print 
				WHERE	 comp_code  = @rec_agcd_comp_code
				AND	unit_code  = @rec_agcd_unit_code
				AND	agcd  = @rec_agcd_billagcd
				AND	dpcd  = @rec_agcd_billdpcd
				AND	supply_date  >= [dbo].GetFirstDayOfMonth ( @v_frdt)
				AND	supply_date  <=@v_todt
				
				set @v_secamt=isnull(@v_secamt,0)-isnull(@v_csecamt,0);
                set @v_dbcramt=0
                
				SELECT @v_dbcramt  =  SUM(CONVERT(FLOAT, ISNULL(gross_amt, 0) - ISNULL(comm_amt, 0) + ISNULL(sur_amt, 0) - ISNULL(return_amt, 0) + ISNULL(sec_amt, 0)))
				FROM  #cir_bill_print 
				WHERE	 comp_code  = @rec_agcd_comp_code
				AND	unit_code  = @rec_agcd_unit_code
				AND	agcd  = @rec_agcd_billagcd
				AND	dpcd  = @rec_agcd_billdpcd
				AND	supply_date  >= [dbo].GetFirstDayOfMonth ( @v_frdt)
				AND	supply_date  < @v_frdt
				
				set @v_opbal=isnull(@v_opbal,0)+isnull(@v_dbcramt,0)
				
				insert into #cir_temp_outstanding(comp_code,unit_code,dt,agname,publ_code,
				agcd,dpcd,dn_amt,cn_amt,rec_amt,op_amt,return_amt)
				values(@rec_agcd_comp_code,@rec_agcd_unit_code,@v_todt,dbo.cir_get_name_cir_agname(@rec_agcd_comp_code,@rec_agcd_unit_code,@rec_agcd_billagcd,@rec_agcd_billdpcd,1,@pdateformat,'','') ,@rec_agcd_publ,
				@rec_agcd_billagcd,@rec_agcd_billdpcd,@v_dbamt,@v_cramt,abs(@v_recamt),@v_opbal,@v_secamt)
	
			FETCH NEXT FROM cur_agcd INTO @rec_agcd_comp_code,@rec_agcd_unit_code,@rec_agcd_publ,@rec_agcd_billagcd,@rec_agcd_billdpcd
			END	

		CLOSE cur_agcd
		DEALLOCATE cur_agcd
		
		
		
		select alias.comp_code,alias.unit_code,alias.publ,alias.edtn,dbo.cir_get_name_cir_edtn(alias.comp_code,alias.unit_code,alias.edtn,@plangtype,@pdateformat,'','') edition_name,min(alias.sup_rate) edtn_rate
		,alias.billagcd,alias.billdpcd,dbo.cir_get_name_cir_agname(alias.comp_code,alias.unit_code,alias.billagcd,alias.billdpcd,@plangtype,@pdateformat,'','') agency_name,
		sum(alias.p01) as "SUN",sum(alias.p02) as "MON",sum(alias.p03) as "TUE",sum(alias.p04) as "WED",sum(alias.p05) as "THU",sum(alias.p06) as "FRI",sum(alias.p07) as "SAT",
		sum(isnull(alias.p02,0)+isnull(alias.p03,0)+isnull(alias.p04,0)+isnull(alias.p05,0)+isnull(alias.p06,0)+isnull(alias.p07,0)) as "TOTAL_COPY"
		,sum(isnull(alias.p01,0)*isnull(alias.sup_rate,0)+isnull(alias.p02,0)*isnull(alias.sup_rate,0)+isnull(alias.p03,0)*isnull(alias.sup_rate,0)+isnull(alias.p04,0)*isnull(alias.sup_rate,0)+isnull(alias.p05,0)*isnull(alias.sup_rate,0)+isnull(alias.p06,0)*isnull(alias.sup_rate,0)+isnull(alias.p07,0)*isnull(alias.sup_rate,0)) as "TOTAL_AMT",
		sum(alias.daily_return) as "DAILY_RETURN",sum(alias.sun_return) as "SUN_RETURN"
		from(
		select d.comp_code comp_code,d.unit_code unit_code,d.publ_code publ,d.edtn_code edtn,d.agcd billagcd,d.dpcd billdpcd,
		d.supply_date supdate,
		case [dbo].[get_week_day](d.supply_date) 
		when 'SUN' then sum(isnull(d.supply_copy,0)) else 0 end p01,
		case [dbo].[get_week_day](d.supply_date)
		when 'MON' then sum(isnull(d.supply_copy,0)) else 0 end p02,
		case [dbo].[get_week_day](d.supply_date)
		when 'TUE' then sum(isnull(d.supply_copy,0)) else 0 end p03,
		case [dbo].[get_week_day](d.supply_date)
		when 'WED' then sum(isnull(d.supply_copy,0)) else 0 end p04,
		case [dbo].[get_week_day](d.supply_date)
		when 'THU' then sum(isnull(d.supply_copy,0)) else 0 end p05,
		case [dbo].[get_week_day](d.supply_date)
		when 'FRI' then sum(isnull(d.supply_copy,0)) else 0 end p06,
		case [dbo].[get_week_day](d.supply_date)
		when 'SAT' then sum(isnull(d.supply_copy,0)) else 0 end p07,
		d.supply_rate sup_rate,d.comm_rate,
		CASE [dbo].[get_week_day_no](d.supply_date) 
		WHEN '1' THEN SUM(return_copy) else 0  end sun_return,
		CASE [dbo].[get_week_day_no](d.supply_date)
		WHEN '2' THEN SUM(return_copy) 
		WHEN '3' THEN SUM(return_copy) 
		WHEN '4' THEN SUM(return_copy) 
		WHEN '5' THEN SUM(return_copy) 
		WHEN '6' THEN SUM(return_copy) 
		WHEN '7' THEN SUM(return_copy) 
		else 0  end daily_return
		from cir_agmast m,#cir_bill_print d
		where d.comp_code=@pcompcode and d.comp_code=m.comp_code and d.unit_code=m.unit and d.unit_code=@punitcode and d.supply_date >= @v_frdt and d.supply_date<=@v_todt 
		and m.agcd=d.agcd and m.dpcd=d.dpcd and d.agcd=isnull(@pbillagcd,d.agcd) and d.dpcd=isnull(@pbilldpcd,d.dpcd) and (m.ag_type=@pagencytype or @pagencytype is null) 
		and (m.ag_class=@pagencyclass or @pagencyclass is null) and (m.dist_code=@pdistcode or @pdistcode is null) and (m.tehsil_taluka=@ptaluka or @ptaluka is null) and 
		(isnull(d.supply_copy,0)+isnull(return_copy,0))>0 and 
		(m.branch_code=@pbranchcode or @pbranchcode is null) --and d.cur_sessionid=userenv('sessionid')
		group by d.comp_code,d.unit_code,d.publ_code,d.edtn_code,d.agcd,d.dpcd,d.supply_date,d.supply_rate,d.comm_rate ) alias
		group by alias.comp_code,alias.unit_code,alias.publ,alias.edtn,alias.billagcd,alias.billdpcd
		order by alias.comp_code,alias.unit_code,alias.agency_name,alias.publ,alias.edtn


		SELECT
		 comp_code,
		 unit_code,
		 dt billdt,
		 agname billno,
		 publ_code publ,
		 agcd,
		 dpcd,
		 dn_amt as "Debit Amt",
		 ABS(cn_amt) as "Credit Amt",
		 ABS(rec_amt) as "Receipt Amount",
		 op_amt as "Previous Balance",
		 return_amt as "Deposit Balance"
		FROM  #cir_temp_outstanding 
		WHERE	 comp_code + unit_code + agcd + dpcd  in
		(
		SELECT DISTINCT CAST(comp_code AS VARCHAR) + CAST(unit_code AS VARCHAR) + CAST(agcd AS VARCHAR) + CAST(dpcd AS VARCHAR)
		FROM  cir_bill_print 
		WHERE	 comp_code  = @pcompcode
		AND	unit_code  = @punitcode
		AND	agcd  = ISNULL(@pbillagcd, agcd)
		AND	dpcd  = ISNULL(@pbilldpcd, dpcd)
		AND	supply_date  >= @v_frdt
		AND	supply_date  <= @v_todt
		)
		ORDER BY comp_code,
		unit_code,
		agname 

		SELECT
		h.comp_code comp_code,
		h.unit_code unit_code,
		CAST(h.doctype AS VARCHAR) + '\' + CAST(h.recptno AS VARCHAR) recptno,
		h.recptdt recptdt,
		h.agcd agcd,
		h.dpcd dpcd,
		m.ag_name agname,
		h.amount amount,
		case
		when h.doctype  = 'RCR' then (				SELECT 'Payment_Mode_Name'
		FROM  payment_mode_mast 
		WHERE	 'Pay_Mode_Code'  = h.reason
		)
		else (				SELECT reason_name
		FROM  cir_reason_mst 
		WHERE	 comp_code  = h.comp_code
		AND	reason_code  = h.reason
		)
		end as reason,
		h.remark remark
		FROM  cir_rcphdr h,
		cir_agmast m 
		WHERE	 h.comp_code  = m.comp_code
		AND	h.comp_code  = @pcompcode
		AND	h.unit_code  = @punitcode
		AND	h.unit_code  = m.unit
		AND	h.doctype  in ( 'CN'  , 'DN'  )
		AND	h.recptdt  >= @v_frdt
		AND	h.recptdt  <= @v_todt
		AND	h.achd  = 'NM'
		AND	h.amount  <> 0
		AND	h.agcd  = m.agcd
		AND	h.dpcd  = m.dpcd
		AND	h.agcd  = ISNULL(@pbillagcd, h.agcd)
		AND	h.dpcd  = ISNULL(@pbilldpcd, h.dpcd)
		AND	h.branch_code  = ISNULL(@pbranchcode, h.branch_code)
		AND	(m.ag_type  = @pagencytype
		OR	@pagencytype  is null)
		AND	(m.ag_class  = @pagencyclass
		OR	@pagencyclass  is null)
		AND	(m.dist_code  = @pdistcode
		OR	@pdistcode  is null)
		AND	(m.tehsil_taluka  = @ptaluka
		OR	@ptaluka  is null)
		AND	(m.branch_code  = @pbranchcode
		OR	@pbranchcode  is null)
		AND	ISNULL(m.to_bill, 'N')  = 'Y'
		ORDER BY m.ag_name,
		h.recptdt,
		h.recptno 
		
		SELECT
		comp_code,
		unit_code,
		agcd billagcd,
		dpcd billdpcd,
		dbo.cir_get_name_cir_agname(comp_code, unit_code, agcd, dpcd, @plangtype, '''' + CAST(@pdateformat AS VARCHAR) + '''', '', '') agency_name,
		(SELECT SUM(CONVERT(FLOAT, ISNULL(supply_copy, 0) * ISNULL(supply_rate, 0))) FROM  #cir_bill_print adv_alias_1  WHERE  adv_alias_1.comp_code  = cir_bill_print.comp_code  AND adv_alias_1.unit_code  = cir_bill_print.unit_code  AND adv_alias_1.agcd  = cir_bill_print.agcd  AND adv_alias_1.dpcd  = cir_bill_print.dpcd ) gross_amt,
		ISNULL(SUM(CONVERT(FLOAT, comm_amt)), 0) comm_amt,
		ISNULL(SUM(CONVERT(FLOAT, return_amt)), 0) return_amt,
		ABS(SUM(CONVERT(FLOAT, ISNULL(sec_amt, 0)))) sec_amt
		FROM  #cir_bill_print 
		WHERE	 comp_code  = @pcompcode
		AND	unit_code  = @punitcode
		AND	agcd  = ISNULL(@pbillagcd, agcd)
		AND	dpcd  = ISNULL(@pbilldpcd, dpcd)
		AND	supply_date  >= @v_frdt
		AND	supply_date  <= @v_todt
		ORDER BY comp_code,
		unit_code,
		agency_name,
		agcd,
		dpcd 

	select getdate()
	select getdate()
	select getdate()
	select getdate()
	select getdate()
	select getdate()
	select getdate()

	/*insert into ERRORMESSAGE(message) values('Weekly bill print p1 Complete ')
    exception when others then
    insert into ERRORMESSAGE(message) values('Weekly bill print p1 error ')
select * from ERRORMESSAGE*/
	END





//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////update by Garima


/****** Object:  StoredProcedure [dbo].[cir_rep_unsold_stock_p]    Script Date: 01/10/2012 12:15:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
        where comp_code= @pcompcode and unit_code= @punitcode and doctype='UCN' and recptdt <= @v_todt and 
        (publ= @ppublcode or @ppublcode is null) and branch_code=isnull(@pbrancode,branch_code) and (isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))>0
        group by publ,edtn,copy_rate
        union
        select publ_code publ,edtn_code edtn, edtn_rate copy_rate from cir_branch_return_det 
        where comp_code= @pcompcode and unit_code= @punitcode and recptdt <= @v_todt and branch_code=isnull(@pbrancode,branch_code) and
        (publ_code= @ppublcode or @ppublcode is null)
        group by publ_code,edtn_code,edtn_rate
        union
        select publ_code publ,edtn_code edtn, edtn_rate copy_rate from cir_return_sale_det
        where comp_code= @pcompcode and unit_code= @punitcode and recptdt <= @v_todt and branch_code=isnull(@pbrancode,branch_code) and
        (publ_code= @ppublcode or @ppublcode is null)
        union
        select publ,edtn,copy_rate from cir_unsold_dtl_dis--for company return  
        where comp_code= @pcompcode and unit_code= @punitcode and doctype='UCN' and recptdt <= @v_todt and 
        (publ= @ppublcode or @ppublcode is null) and branch_code=isnull(@pbrancode,branch_code) and (isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))>0
        group by publ,edtn,copy_rate
        union
        select publ_code publ,edtn_code edtn, edtn_rate copy_rate from cir_physical_ver_det
        where comp_code= @pcompcode and unit_code= @punitcode and recptdt <= @v_todt and branch_code=isnull(@pbrancode,branch_code) and
        (publ_code= @ppublcode or @ppublcode is null)
        union
        select a.publ publ,a.edtn edtn, a.sup_rate copy_rate from cir_dbksup_resale a,cir_agmast b 
        where a.comp_code= @pcompcode and a.comp_code=b.comp_code and a.unit_code= @punitcode and a.unit_code=b.unit and 
        (a.publ= @ppublcode or @ppublcode is null) and a.agcd=b.agcd and a.dpcd=b.dpcd and a.supdate <= @v_todt and isnull(a.return_copy_sale,'N')='Y' and b.branch_code=isnull(@pbrancode,branch_code))z
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
        
	open c1
            fetch NEXT FROM C1 INTO @v1_publ, @v1_edtn, @v1_copy_rate
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN

            
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
        dbo.cir_get_name_cir_publ(a.comp_code,a.publ_code,'1',@pdateformat,'','') publ_name,
        b.main_edtn main_edtn_code,dbo.cir_get_edtn_seqno(a.comp_code,b.main_edtn) main_edtn_seqno,
        a.edtn_code edtn_code,dbo.cir_get_edtn_seqno(a.comp_code,a.edtn_code) edtn_seqno,dbo.cir_get_name_cir_edtn(a.comp_code,a.unit_code,a.edtn_code,'1',@pdateformat,'','') edtn_name,
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
    
    /**********************Neha******10-jan-2012****************************************/
    
    ALTER PROCEDURE [dbo].[cir_pending_installment]
   @pcompcode      as	VARCHAR(20),
   @punitcode      as	VARCHAR(20),
   @pagcd          as	VARCHAR(20),
   @pdpcd          as	VARCHAR(20),
   @pachd          as	VARCHAR(20),
   @pdateformat    as	VARCHAR(20),
   @pextra         as	VARCHAR(20),
   @pextra1        as	VARCHAR(200),
   @pextra2        as	VARCHAR(200),
   @pextra3        as	VARCHAR(200),
   @pextra4        as	VARCHAR(200),   
   @pextra5        as	VARCHAR(200),
   @pextra6        as	VARCHAR(200),
   @pextra7        as	VARCHAR(200),
   @pextra8        as	VARCHAR(200),   
   @pextra9        as	VARCHAR(200),
   @pextra10       as	VARCHAR(200)

AS

	declare @v_dt		datetime    
	declare @v_expdt	datetime
BEGIN

    select m.comp_code as"COMP_CODE",m.unit_code as "UNIT_CODE",m.inst_code as "INST_CODE",m.inst_date as "INST_DATE",
    m.agcd as "AGCD",m.dpcd as "DPCD",a.ag_name as "AG_NAME",dbo.cir_get_drop_point_name(m.comp_code,m.unit_code,a.station_code,1) as "DROP_POINT_NAME",
    dbo.cir_get_city(m.comp_code,a.city_code) as "CITY_NAME",d.inst_duedt as "INST_DUEDT",d.inst_amt as "INST_AMT",
    (select sum(inst_due_amt) from cir_inst_bill_det where comp_code=m.comp_code and inst_code=m.inst_code and agcd=m.agcd and dpcd=m.dpcd and 
    inst_billdt=d.inst_duedt) as "INST_DUE_AMT" 
    from cir_installment_mast m,cir_installment_det d,cir_agmast a
    where m.comp_code=d.comp_code and m.comp_code=a.comp_code and m.comp_code=@pcompcode and 
    m.unit_code=d.unit_code and m.unit_code=a.unit and m.unit_code=isnull(@punitcode,m.unit_code) and
    m.agcd=d.agcd and m.agcd=a.agcd and m.agcd=isnull(@pagcd,m.agcd) and m.dpcd=d.dpcd and m.dpcd=a.dpcd and m.dpcd=isnull(@pdpcd,m.dpcd) and 
    m.inst_code=d.inst_code and m.achd=@pachd
    order by comp_code,unit_code,ag_name,inst_duedt
    
END



ALTER procedure [dbo].[cir_payreason_for_receipt]
    @pcompcode       as varchar(200),
    @punitcode       as varchar(200),
    @pdoctype        as varchar(200),
    @pagcd           as varchar(200),
    @pdpcd           as varchar(200),
    @pdateformat     as varchar(200),
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
as
begin

    if(@pdoctype !='RCR') Begin
        select distinct reason_code as "PAY_MODE_CODE",reason_name as "PAYMENT_MODE_NAME",'N' as "MODE_TYPE" ,chq_return_flag as "CHQ_RETURN_FLAG",
        no_of_times as "NO_OF_TIMES",valid_days as "VALID_DAYS"
        from cir_reason_mst where comp_code = @pcompcode and ((upper(reason_name) like upper(@pextra1)+'%') or (@pextra1 is null) or (@pextra1='')) and 
        ((doc_type=@pdoctype) or doc_type is null or doc_type='') 
        order by payment_mode_name
    End
    if(@pdoctype ='RCR') Begin
        select distinct x.PAY_MODE_CODE as "PAY_MODE_CODE" ,x."PAYMENT_MODE_NAME" as "PAYMENT_MODE_NAME",x."MODE_TYPE" as "MODE_TYPE" ,x."CHQ_RETURN_FLAG" as "CHQ_RETURN_FLAG",
        x."NO_OF_TIMES" as "NO_OF_TIMES",x."VALID_DAYS" as "VALID_DAYS" from 
        (select distinct p."Pay_Mode_Code" as "PAY_MODE_CODE" ,p."Payment_Mode_Name" as "PAYMENT_MODE_NAME",p.payment_mode_type as "MODE_TYPE" ,'N' as "CHQ_RETURN_FLAG",
        0 as "NO_OF_TIMES",0 as "VALID_DAYS"
        from payment_mode_mast p,cir_agency_paymode a
        where a.comp_code=@pcompcode and a.unit_code=@punitcode and a.agcd=@pagcd and a.dpcd=@pdpcd and 
        a.paymode=p."Pay_Mode_Code" and ((upper(p."Payment_Mode_Name") like upper(@pextra1)+'%') or (@pextra1 is null) or (@pextra1='')) and
        isnull(a.paymode_active,'N')='Y'
        union
        select distinct p."Pay_Mode_Code" as "PAY_MODE_CODE" ,p."Payment_Mode_Name" as "PAYMENT_MODE_NAME",p.payment_mode_type as "MODE_TYPE" ,'N' as "CHQ_RETURN_FLAG",
        0 as "NO_OF_TIMES",0 as "VALID_DAYS"
        from payment_mode_mast p
        where ((upper(p."Payment_Mode_Name") like upper(@pextra1)+'%') or (@pextra1 is null) or (@pextra1='')) and p."Pay_Mode_Code"='CA0') x
        order by payment_mode_name
    End
    
    select getdate() as "CUR_DATE"
    
End
/*************************************end******************************************************************/



//////////////////////////////////////////////////Issue No. 6216 10/01/2012///////////////////////////////////////////////

ALTER PROCEDURE [dbo].[cir_rep_lbl_prn_utusan_p]
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
	@pextra1                                  VARCHAR(400) ,
	@pextra2                                  VARCHAR(400) 
AS 
		DECLARE @vdate      DATETIME 
     	SET @vdate  =  dbo.convert_user_date('/',@plbldt,@pdateformat)

	select cir_lblmast.*,DBO.cir_get_mode_name(comp_code, route1) MODE_NAME,
          SUBSTRING(DBO.cir_get_name_cir_edtn(comp_code,unit_code,edtn  ,'1',@pdateformat,'',''),1,30) EDTN_NAME,
          (select distinct reg_no from cir_edtn_mast where comp_code = @pcomp_code and edtn=cir_lblmast.edtn_1) AS "REG_NO",
          ((cir_lblmast.lbl_tno*pkt_size)+isnull(supply_1,0)) as "TOTAL_SUPPLY_COPY",(select station_code from cir_agmast where cir_agmast.comp_code=cir_lblmast.comp_code and
          cir_agmast.unit=cir_lblmast.unit_code and cir_agmast.agcd=cir_lblmast.agcd  and cir_agmast.dpcd=cir_lblmast.dpcd) as "STATION_CODE" 
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
					ORDER BY unit_code,seq_no,route1,edtn,agname

ALTER PROCEDURE [dbo].[Cir_Gen_Code_cir_unsold_scnction_p]
	@pcompcode			VARCHAR(20),
	@pdoctype           VARCHAR(20),
	@pdateformat        VARCHAR(20),
	@pextra1            VARCHAR(400),--for unsold receipt date
	@pextra2            VARCHAR(400) --for agency or distribution
AS 

	DECLARE @vtype_code		VARCHAR(15) 
    DECLARE @v_prefix		varchar(20)
    DECLARE @v_no			varchar(20)
    DECLARE @v_dt			datetime
    DECLARE @v_chkdt		datetime	

	set @v_dt =dbo.convert_user_date('/', @pextra1, @pdateformat)

    set @v_prefix='SN'+replace(substring(convert(varchar(20), @v_dt, 2),1,5), '.', '')

	set @v_chkdt =dbo.GetFirstDayOfMonth( @v_dt)

    select @v_no=curr_no from cir_series
		where comp_code=@pcompcode and ty=ISNULL(@pdoctype,'SCN') and dbo.GetFirstDayOfMonth( year_monid)=@v_chkdt and 
		prefix=@v_prefix

    If @v_no is null or @v_no='0' or @v_no='' Begin
        set @vtype_code=@v_prefix+'00001'
        insert into cir_series(comp_code,unit_code,branch_code,ty,year_monid,prefix, curr_no)
			values(@pcompcode,null,null,ISNULL(@pdoctype,'SCN'),@v_chkdt,@v_prefix,1)
	End		
    Else Begin
        set @v_no        =convert(int,@v_no)+1

        set @vtype_code  =@v_prefix+cast(dbo.fnPadLeft('0',5,@v_no) as varchar(50))
        
        update cir_series set curr_no=isnull(curr_no,0)+1
            where comp_code=@pcompcode and ty=ISNULL(@pdoctype,'SCN') and dbo.GetFirstDayOfMonth(year_monid)=@v_chkdt and 
            prefix=@v_prefix
    End

    select @vtype_code as "VAR_CODE"

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////update by garima  5451
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER PROCEDURE  [dbo].[cir_one_day_supply_change_p]
	@pcomp_code		as varchar(200),
	@punit_code     as varchar(200),
	@ppubl_code     as varchar(200),
	@pedtn_code     as varchar(200),
	@psup_type      as varchar(200),
	@psup_date      as datetime,
	@pagcd_code     as varchar(200),
	@pdpcd_code     as varchar(200),
	@pzone_code     as varchar(200),--for zone
	@pregion_code   as varchar(200),--for region
	@pcomm_category as varchar(200),--for commition category
	@pstate_code    as varchar(200),--for state
	@pdist_code     as varchar(200),--for district
	@ptaluka_code   as varchar(200),--for taluka
	@pcity_code     as varchar(200),--for city
	@proute_code    as varchar(200),--for route
	@pbran_code     as varchar(200),--for branch
	@pagency_type   as varchar(200),--for agency type
	@pagency_class  as varchar(200),--for agency class
	@pdateformat    as varchar(200),
	@pextra1        as varchar(200),--1 for  edition route wise,2 for edition district wise
	@pextra2        as varchar(200),--D for distribution agency
	@pextra3        as varchar(200),
	@pextra4        as varchar(200),
	@pextra5        as varchar(200),
	@pextra6        as varchar(200),
	@pextra7        as varchar(200),
	@pextra8        as varchar(200),
	@pextra9        as varchar(200),
	@pextra10       as varchar(200)
AS 
	If @punit_code='' Begin
		set @punit_code=null
	End
	If @ppubl_code='' Begin
		set @ppubl_code=null
	End
	If @pedtn_code='' Begin
		set @pedtn_code=null
	End
	If @psup_type='' Begin
		set @psup_type=null
	End
	If @pagcd_code='' Begin
		set @pagcd_code=null
	End
	If @pdpcd_code='' Begin
		set @pdpcd_code=null
	End
	If @pzone_code='' Begin
		set @pzone_code=null
	End
	If @pregion_code='' Begin
		set @pregion_code=null
	End
	If @pcomm_category='' Begin
		set @pcomm_category=null
	End
	If @pstate_code='' Begin
		set @pstate_code=null
	End
	
	If @pdist_code='' Begin
		set @pdist_code=null
	End
	If @ptaluka_code='' Begin
		set @ptaluka_code=null
	End
	If @pcity_code='' Begin
		set @pcity_code=null
	End
	If @proute_code='' Begin
		set @proute_code=null
	End
	If @pbran_code='' Begin
		set @pbran_code=null
	End
	If @pagency_type='' Begin
		set @pagency_type=null
	End
	If @pagency_class='' Begin
		set @pagency_class=null
	End
	If @proute_code='' Begin
		set @proute_code=null
	End		

  if upper(@pextra2)='D' Begin
      select c.comp_code as "COMP_CODE",c.unit_code as "UNIT_CODE",a.agcd as "AGCD",a.dpcd as "DPCD",a.ag_name as "AGENCY_NAME",
      a.ag_name_oth_lang as "AGENCY_NAME_OTHER_LANG",a.city_code as "CITY_CODE",
        dbo.cir_get_city(a.comp_code,a.city_code) as "CITY_NAME",a.station_code as "DROP_POINT_CODE",
        dbo.cir_get_drop_point_name(a.comp_code,a.unit,a.station_code,'1') as "DROP_POINT_NAME",
        c.sup_copy as "SUP_COPY",dbo.cir_get_route_seqno(c.comp_code,c.unit_code,c.route_code) as "ROUTE_SEQ",
        dbo.cir_get_supply_seqno(c.comp_code,c.unit_code,c.publ,c.edtn,c.agcd,c.dpcd) as "SUPPLY_SEQ",
        c.publ as "PUBL",p.publ_name as "PUBL_NAME",e.main_edtn as "MAIN_EDTN",dbo.cir_get_edtn_name(c.comp_code,e.main_edtn) as "MAIN_EDTN_NAME",
        c.edtn as "EDTN",e.edtn_name as "EDTN_NAME",c.sup_type_code as "SUP_TYPE_CODE", b.sup_ty_name as "SUP_TY_NAME",
        s.base_supply as "BASE_SUPPLY", s.supply_sun as "SUPPLY_SUN", s.supply_mon as "SUPPLY_MON", s.supply_tue as "SUPPLY_TUE", 
        s.supply_wed as "SUPPLY_WED", s.supply_thu as "SUPPLY_THU", s.supply_fri as "SUPPLY_FRI", s.supply_sat as "SUPPLY_SAT",upper(CONVERT(VARCHAR(20),DATENAME(WEEKDAY, c.supdate),20)) as "SUPDAY", 
        (select sum(c.sup_copy) sup_copy from cir_agmast_dis a,cir_supply_type_mast b,cir_dbksup_dis c
        where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=@pcomp_code and
              a.unit=c.unit_code and a.unit=isnull(@punit_code,a.unit) and b.sup_ty_code=c.sup_type_code and
              c.publ=isnull(@ppubl_code,c.publ) and c.edtn = isnull(@pedtn_code,c.edtn) and c.supdate=@psup_date and 
              a.agcd=c.agcd and a.dpcd=c.dpcd and a.agcd=isnull(@pagcd_code,a.agcd) and a.dpcd=isnull(@pdpcd_code,a.dpcd) and c.sup_type_code=isnull(@psup_type,c.sup_type_code)) as "TOTAL_SUPPLY",
         c.final_supply_flag as "FINAL_SUPPLY_FLAG"
      from cir_agmast_dis a,cir_supply_type_mast b,cir_dbksup_dis c,cir_publ_mast p,cir_edtn_mast e,cir_supply_dis s
      where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=p.comp_code and a.comp_code=e.comp_code and a.comp_code=s.comp_code and a.comp_code=@pcomp_code and
         a.unit=c.unit_code and a.unit=s.unit and a.unit=isnull(@punit_code,a.unit) and b.sup_ty_code=c.sup_type_code and
         c.publ=p.publ and c.publ=e.publ and c.publ=s.publ and c.publ=isnull(@ppubl_code,c.publ) and c.edtn=e.edtn and c.edtn=s.edtn and c.edtn = isnull(@pedtn_code,c.edtn) and 
         c.supdate=@psup_date and a.agcd=c.agcd and a.dpcd=c.dpcd and
         a.agcd=s.agcd and a.agcd=isnull(@pagcd_code,a.agcd) and a.dpcd=s.dpcd and a.dpcd=isnull(@pdpcd_code,a.dpcd) and c.sup_type_code=s.supply_type_code and c.sup_type_code=isnull(@psup_type,c.sup_type_code) and
         (c.agency_ty_code = @pagency_type or @pagency_type is null) and
         (c.comm_code = @pcomm_category or @pcomm_category is null) and
         (c.route_code = @proute_code or @proute_code is null) and
         (a.state_code = @pstate_code or @pstate_code is null) and
         (a.dist_code = @pdist_code or @pdist_code is null) and
         (a.tehsil_taluka = @ptaluka_code or @ptaluka_code is null) and
         (a.branch_code = @pbran_code or @pbran_code is null) and
         a.city_code in (select city_code from cir_city_mast where a.comp_code=@pcomp_code and city_code = isnull(@pcity_code,city_code) and 
         (zone_code = @pzone_code or @pzone_code is null) and (region_code = @pregion_code or @pregion_code is null))
         order by route_seq,supply_seq,agency_name
  End       
  else Begin
      if @pextra1=2 Begin---for edition district and agency wise
          select c.comp_code as "COMP_CODE",c.unit_code as "UNIT_CODE",a.agcd as "AGCD",a.dpcd as "DPCD",a.ag_name as "AGENCY_NAME",a.ag_name_oth_lang as "AGENCY_NAME_OTHER_LANG",a.city_code as "CITY_CODE",
                dbo.cir_get_city(a.comp_code,a.city_code) as "CITY_NAME",a.station_code as "DROP_POINT_CODE",dbo.cir_get_drop_point_name(a.comp_code,a.unit,a.station_code,'1') as "DROP_POINT_NAME",
                c.sup_copy as "SUP_COPY",dbo.cir_get_route_seqno(c.comp_code,c.unit_code,c.route_code) as "ROUTE_SEQ",
                dbo.cir_get_supply_seqno(c.comp_code,c.unit_code,c.publ,c.edtn,c.agcd,c.dpcd) as "SUPPLY_SEQ",
                c.publ as "PUBL",p.publ_name as "PUBL_NAME",e.main_edtn as "MAIN_EDTN",dbo.cir_get_edtn_name(c.comp_code,e.main_edtn) as "MAIN_EDTN_NAME",
                c.edtn as "EDTN",e.edtn_name as "EDTN_NAME",c.sup_type_code as "SUP_TYPE_CODE", b.sup_ty_name as "SUP_TY_NAME",
                s.base_supply as "BASE_SUPPLY", s.supply_sun as "SUPPLY_SUN", s.supply_mon as "SUPPLY_MON", s.supply_tue as "SUPPLY_TUE", 
                s.supply_wed as "SUPPLY_WED", s.supply_thu as "SUPPLY_THU", s.supply_fri as "SUPPLY_FRI", s.supply_sat as "SUPPLY_SAT",upper(CONVERT(VARCHAR(20),DATENAME(WEEKDAY, c.supdate),20)) as "SUPDAY",
                (select sum(c.sup_copy) sup_copy from cir_agmast a,cir_supply_type_mast b,cir_dbksup c
        where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=@pcomp_code and
              a.unit=c.unit_code and a.unit=isnull(@punit_code,a.unit) and b.sup_ty_code=c.sup_type_code and
              c.publ=isnull(@ppubl_code,c.publ) and c.edtn = isnull(@pedtn_code,c.edtn) and c.supdate=@psup_date and 
              a.agcd=c.agcd and a.dpcd=c.dpcd and a.agcd=isnull(@pagcd_code,a.agcd) and a.dpcd=isnull(@pdpcd_code,a.dpcd) and 
              c.sup_type_code=isnull(@psup_type,c.sup_type_code)) as "TOTAL_SUPPLY",c.final_supply_flag as "FINAL_SUPPLY_FLAG",
              d.dist_name as "DIST_NAME"
          from cir_agmast a left outer join cir_dist_mast d on a.comp_code=d.comp_code and a.dist_code=d.dist_code,
               cir_supply_type_mast b,cir_dbksup c,cir_publ_mast p,cir_edtn_mast e,cir_supply s
          where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=p.comp_code and a.comp_code=e.comp_code and a.comp_code=s.comp_code and a.comp_code=@pcomp_code and
         a.unit=c.unit_code and a.unit=s.unit and a.unit=isnull(@punit_code,a.unit) and b.sup_ty_code=c.sup_type_code and
         c.publ=p.publ and c.publ=e.publ and c.publ=s.publ and c.publ=isnull(@ppubl_code,c.publ) and c.edtn=e.edtn and c.edtn=s.edtn and c.edtn = isnull(@pedtn_code,c.edtn) and 
         c.supdate=@psup_date and a.agcd=c.agcd and a.dpcd=c.dpcd and
         a.agcd=s.agcd and a.agcd=isnull(@pagcd_code,a.agcd) and a.dpcd=s.dpcd and a.dpcd=isnull(@pdpcd_code,a.dpcd) and c.sup_type_code=s.supply_type_code and c.sup_type_code=isnull(@psup_type,c.sup_type_code) and
         (c.agency_ty_code = @pagency_type or @pagency_type is null) and
         (c.comm_code = @pcomm_category or @pcomm_category is null) and
         (c.route_code = @proute_code or @proute_code is null) and
         (a.state_code = @pstate_code or @pstate_code is null) and
         (a.dist_code = @pdist_code or @pdist_code is null) and
         (a.tehsil_taluka = @ptaluka_code or @ptaluka_code is null) and
         (a.branch_code = @pbran_code or @pbran_code is null) and
         a.city_code in (select city_code from cir_city_mast where a.comp_code=@pcomp_code and city_code = isnull(@pcity_code,city_code) and 
         (zone_code = @pzone_code or @pzone_code is null) and (region_code = @pregion_code or @pregion_code is null))
         order by dist_name,agency_name,supply_seq
          
   End         
      else Begin
		select c.comp_code as "COMP_CODE",c.unit_code as "UNIT_CODE",a.agcd as "AGCD",a.dpcd as "DPCD",a.ag_name as "AGENCY_NAME",
		  a.ag_name_oth_lang as "AGENCY_NAME_OTHER_LANG",a.city_code as "CITY_CODE",
			dbo.cir_get_city(a.comp_code,a.city_code) as "CITY_NAME",a.station_code as "DROP_POINT_CODE",
			dbo.cir_get_drop_point_name(a.comp_code,a.unit,a.station_code,'1') as "DROP_POINT_NAME",
			c.sup_copy as "SUP_COPY",dbo.cir_get_route_seqno(c.comp_code,c.unit_code,c.route_code) as "ROUTE_SEQ",
			dbo.cir_get_supply_seqno(c.comp_code,c.unit_code,c.publ,c.edtn,c.agcd,c.dpcd) as "SUPPLY_SEQ",
			c.publ as "PUBL",p.publ_name as "PUBL_NAME",e.main_edtn as "MAIN_EDTN",dbo.cir_get_edtn_name(c.comp_code,e.main_edtn) as "MAIN_EDTN_NAME",
			c.edtn as "EDTN",e.edtn_name as "EDTN_NAME",c.sup_type_code as "SUP_TYPE_CODE", b.sup_ty_name as "SUP_TY_NAME",
			s.base_supply as "BASE_SUPPLY", s.supply_sun as "SUPPLY_SUN", s.supply_mon as "SUPPLY_MON", s.supply_tue as "SUPPLY_TUE", 
			s.supply_wed as "SUPPLY_WED", s.supply_thu as "SUPPLY_THU", s.supply_fri as "SUPPLY_FRI", s.supply_sat as "SUPPLY_SAT",upper(CONVERT(VARCHAR(20),DATENAME(WEEKDAY, c.supdate),20)) as "SUPDAY", 
			(select sum(c.sup_copy) sup_copy from cir_agmast a,cir_supply_type_mast b,cir_dbksup c
			where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=@pcomp_code and
				  a.unit=c.unit_code and a.unit=isnull(@punit_code,a.unit) and b.sup_ty_code=c.sup_type_code and
				  c.publ=isnull(@ppubl_code,c.publ) and c.edtn = isnull(@pedtn_code,c.edtn) and c.supdate=@psup_date and 
				  a.agcd=c.agcd and a.dpcd=c.dpcd and
				  a.agcd=isnull(@pagcd_code,a.agcd) and a.dpcd=isnull(@pdpcd_code,a.dpcd) and c.sup_type_code=isnull(@psup_type,c.sup_type_code)) as "TOTAL_SUPPLY",
			 c.final_supply_flag as "FINAL_SUPPLY_FLAG"
		  from cir_agmast a,cir_supply_type_mast b,cir_dbksup c,cir_publ_mast p,cir_edtn_mast e,cir_supply s
		  where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=p.comp_code and a.comp_code=e.comp_code and a.comp_code=s.comp_code and a.comp_code=@pcomp_code and
			 a.unit=c.unit_code and a.unit=s.unit and a.unit=isnull(@punit_code,a.unit) and b.sup_ty_code=c.sup_type_code and
			 c.publ=p.publ and c.publ=e.publ and c.publ=s.publ and c.publ=isnull(@ppubl_code,c.publ) and c.edtn=e.edtn and c.edtn=s.edtn and c.edtn = isnull(@pedtn_code,c.edtn) and 
			 c.supdate=@psup_date and a.agcd=c.agcd and a.dpcd=c.dpcd and
			 a.agcd=s.agcd and a.agcd=isnull(@pagcd_code,a.agcd) and a.dpcd=s.dpcd and a.dpcd=isnull(@pdpcd_code,a.dpcd) and c.sup_type_code=s.supply_type_code and c.sup_type_code=isnull(@psup_type,c.sup_type_code) and
			 (c.agency_ty_code = @pagency_type or @pagency_type is null) and
			 (c.comm_code = @pcomm_category or @pcomm_category is null) and
			 (c.route_code = @proute_code or @proute_code is null) and
			 (a.state_code = @pstate_code or @pstate_code is null) and
			 (a.dist_code = @pdist_code or @pdist_code is null) and
			 (a.tehsil_taluka = @ptaluka_code or @ptaluka_code is null) and
			 (a.branch_code = @pbran_code or @pbran_code is null) and
			 a.city_code in (select city_code from cir_city_mast where a.comp_code=@pcomp_code and city_code = isnull(@pcity_code,city_code) and 
			 (zone_code = @pzone_code or @pzone_code is null) and (region_code = @pregion_code or @pregion_code is null))
			 order by route_seq,supply_seq,agency_name
	End
End   

/////////////////////////////////////////////////////////////////update by Garima
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
when 'yyyy/mm/dd' then convert(varchar(10),m.SUSPEND_DATE,111)  end as "SUSPEND_DATE" 




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
when 'yyyy/mm/dd' then convert(varchar(10),m.SUSPEND_DATE,111)  end as "SUSPEND_DATE" 




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


//////////////////////////////////////////////////////////////////////////////////////////////////////update by Garima



*********************************************issue no:6089********************start ******************************************************************
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
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

		IF @vcol_name is not null BEGIN 
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
         while(@@FETCH_STATUS = 0) BEGIN  
				IF(@COL_DATA_TYPE1 = 'datetime') BEGIN 
					declare @finaldate varchar(4000)
					declare @count_dat int
					set @count_dat=0					
					if @COL_VALUE1!='' and @COL_VALUE1 is not null and @COL_VALUE1 !='null' begin
						print '1ankur_test'
						print('datetime') print(@COL_VALUE1)print(@pdateformat)print (@finaldate)
						set @finaldate=dbo.convert_user_date('/',@COL_VALUE1,@pdateformat)
						print '21ankur_test'
						print @finaldate
						print 'ankur_testrr'
					end
					if @finaldate='/' begin
						set @finaldate=''''
					end
					set @finaldate=''''+replace(@finaldate,'''','')+''''
					--declare @xdt as datetime
					--if (@finaldate  is null or @finaldate ='')
					--begin
					--	set @xdt=null
					--end
					--else
					--begin
					--	set @xdt=cast(@finaldate as datetime)
					--end
					SET @col_val = COALESCE(@col_val + ',', SPACE(0)) + '' + COALESCE(@finaldate + '', SPACE(0))
					print @col_val
				END;
				else if(@COL_DATA_TYPE1 = 'numeric') OR (@COL_DATA_TYPE1 = 'decimal') begin						
					SET @col_val = COALESCE(@col_val + ',', SPACE(0)) + '' + 'convert( float,' + COALESCE(@COL_VALUE1 + '', SPACE(0))+')'
				end
				ELSE BEGIN
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

*************************************************************


alter table CIR_PUBL_MAST add PUBLISHER VARCHAR(50)
*************************************************end******issue no:6089********************************************************************************



/***********************************mimoh******6136**********************************/

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
s.start_date as "BLOCK_UNBLOCK_DATE",convert(varchar(25),s.CREATION_DATE,108) as "BLOCK_UNBLOCK_TIME",
         (SELECT SUSPEND_DESC FROM CIR_SUSPEND_TYPE_MAST WHERE COMP_CODE=s.COMP_CODE AND SUSPEND_TYPE_CODE=s.suspty) as "BLOCK_REASON",s.suspty as "SUSPTY",
         (SELECT max("username") from login where com_code = s.comp_code  and "userid"=s.userid) as "UNBLOCK_BY",s.suspty as "SUSPEND_TYPE",
         s.agency_unblock_approval as "AGENCY_UNBLOCK_APPROVAL",s.userid as "USERID",isnull(s.trn_date,convert(varchar(20),creation_date,103)) as "TRN_DATE" 
         from cir_suspend_tran s,cir_agmast m
      where s.comp_code = m.comp_code and s.comp_code = @pcomp_code
        and s.unit=m.unit and s.unit      = isnull(@punit_code,s.unit)
        and s.susp      = @pstatus
        and s.trn_date between @pfrdt and @ptodt
        and s.agcd=m.agcd and s.agcd    = isnull(@pagcd,s.agcd)
        and s.dpcd=m.dpcd and s.dpcd    = isnull(@pdpcd,s.dpcd)
        and s.userid  = isnull(@puserid,s.userid)
        and isnull(s.agency_unblock_approval,'N')='N'    
  
End 

/***********************************mimoh******6136**********************************/

//****************************by nand on 19th jan ************************************************************
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER procedure [dbo].[cir_unapproved_unsold_receipt]
    @pcompcode       as  varchar(20),
    @punitcode       as  varchar(20),
    @pbrancode       as  varchar(20),
    @pagcd           as  varchar(20),
    @pdpcd           as  varchar(20),
    @puserid         as  varchar(20), 
    @pdateformat     as  varchar(20),
    @pextra1         as  varchar(200),
    @pextra2         as  varchar(200),--it is used for agency or distribution
    @pextra3         as  varchar(200),
    @pextra4         as  varchar(200),
    @pextra5         as  varchar(200),
    @pextra6         as  varchar(200),
    @pextra7         as  varchar(200),
    @pextra8         as  varchar(200),
    @pextra9         as  varchar(200),
    @pextra10        as  varchar(200)
as

begin
    if upper(@pextra2)='D' Begin
        select distinct d.comp_code as "COMP_CODE",d.unit_code as "UNIT_CODE",d.recptno as "RECPTNO",d.recptdt as "RECPTDT" ,h.doctype as "DOCTYPE",
        h.app_dt as "APP_DT",getdate() as "ENTRYDT",h.frdt as "FRDT",h.todt as "TODT",h.agcd as "AGCD",h.dpcd as "DPCD",
		h.publ as "PUBL",h.edtn as "EDTN",@puserid as "APP_USERID",@puserid as "VAR_USERID"
        from cir_unsold_hdr_dis h,cir_unsold_dtl_dis d
        where h.comp_code=d.comp_code and h.comp_code=@pcompcode and h.unit_code=d.unit_code and 
        h.unit_code=@punitcode and h.doctype='UCN' and h.doctype=d.doctype and h.recptno=d.recptno and h.recptdt=d.recptdt and
        h.agcd=d.agcd and h.sup_agcd=@pagcd and h.dpcd=d.dpcd and h.sup_dpcd=@pdpcd and 
        (isnull(var_short_recpt,0)+isnull(var_late_recpt,0)+isnull(var_bnr,0)+isnull(var_unsold,0)+isnull(var_damage,0))-
        (isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0)+isnull(apr_damage,0))>0 and
        (h.recptno like @pextra1+'%' or @pextra1 is null or @pextra1='')
        order by recptdt,recptno;
     End   
     Else Begin
        select distinct d.comp_code as "COMP_CODE",d.unit_code as "UNIT_CODE",d.recptno as "RECPTNO",d.recptdt as "RECPTDT" ,h.doctype as "DOCTYPE",
        h.app_dt as "APP_DT",getdate() as "ENTRYDT",h.frdt as "FRDT",h.todt as "TODT",h.agcd as "AGCD",h.dpcd as "DPCD",
		h.publ as "PUBL",h.edtn as "EDTN",@puserid as "APP_USERID",@puserid as "VAR_USERID"
        from cir_unsold_hdr h,cir_unsold_dtl d
        where h.comp_code=d.comp_code and h.comp_code=@pcompcode and h.unit_code=d.unit_code and 
        h.unit_code=@punitcode and h.doctype='UCN' and h.doctype=d.doctype and h.recptno=d.recptno and h.recptdt=d.recptdt and
        h.agcd=d.agcd and h.sup_agcd=@pagcd and h.dpcd=d.dpcd and h.sup_dpcd=@pdpcd and 
        (isnull(var_short_recpt,0)+isnull(var_late_recpt,0)+isnull(var_bnr,0)+isnull(var_unsold,0)+isnull(var_damage,0))-
        (isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0)+isnull(apr_damage,0))>0 and
        (h.recptno like @pextra1+'%' or @pextra1 is null or @pextra1='')
        order by recptdt,recptno
     End
End

--------------------------------------------------------------------------------------------------------------------------------

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




ALTER procedure [dbo].[Cir_unsold_breakup_details](
	@puserid         as  varchar(20), 
    @pcompcode       as  varchar(20),
    @punitcode       as  varchar(20),
	@pd_branch		as	varchar(100),
	@pd_rcptno		as varchar(100),
	@pd_rcptdate	as varchar(100),
	@pd_supdate		as varchar(100),
    @pd_agcode       as  varchar(20),
    @pd_agsubcode    as  varchar(20),
	@pdoctype		as varchar(20),
    @pdateformat    as  varchar(200),
    @pextra1         as  varchar(200),
    @pextra2         as  varchar(200)--it is used for agency or distribution
    )
as

	declare @v_recptdt   datetime
	declare @v_supdt   datetime
begin
    set @v_recptdt =dbo.convert_user_date('/', @pd_rcptdate, @pdateformat)
	set @v_supdt =dbo.convert_user_date('/', @pd_supdate, @pdateformat)

	If upper(@pextra2)='D' Begin
        select distinct isnull(var_unsold,0) as "V_UNSOLD",isnull(var_short_recpt,0) as "V_SHORT",
		isnull(var_damage,0) as "V_DAMAGE",isnull(var_late_recpt,0) as "V_LATEREC",isnull(var_bnr,0) as "V_BNR",
		isnull(apr_unsold,0) as "A_UNSOLD",isnull(apr_short_recpt,0) as "A_SHORT",
		isnull(apr_damage,0) as "A_DAMAGE",isnull(apr_late_recpt,0) as "A_LATEREC",isnull(apr_bnr,0) as "A_BNR"
		from cir_unsold_dtl_dis
        where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and supdate=@v_supdt
		and recptno=@pd_rcptno and recptdt=@v_recptdt and agcd=@pd_agcode and dpcd=@pd_agsubcode;
	End
    Else Begin
        select distinct isnull(var_unsold,0) as "V_UNSOLD",isnull(var_short_recpt,0) as "V_SHORT",
		isnull(var_damage,0) as "V_DAMAGE",isnull(var_late_recpt,0) as "V_LATEREC",isnull(var_bnr,0) as "V_BNR",
		isnull(apr_unsold,0) as "A_UNSOLD",isnull(apr_short_recpt,0) as "A_SHORT",
		isnull(apr_damage,0) as "A_DAMAGE",isnull(apr_late_recpt,0) as "A_LATEREC",isnull(apr_bnr,0) as "A_BNR"
		from cir_unsold_dtl
        where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and supdate=@v_supdt
		and recptno=@pd_rcptno and recptdt=@v_recptdt 
		and agcd=@pd_agcode and dpcd=@pd_agsubcode;
	End
           

End

---------------------------------------------------------------------------------------------

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




ALTER procedure [dbo].[cir_unsold_detail_for_sanction](
    @pcompcode       as  varchar(20),
    @punitcode       as  varchar(20),
    @pagcd           as  varchar(20),
    @pdpcd           as  varchar(20),
    @precptno        as  varchar(200),
    @precptdt        as  varchar(200),    
    @puserid         as  varchar(200), 
    @pdateformate    as  varchar(200),
    @pextra1         as  varchar(200),
    @pextra2         as  varchar(200),--it is used for agency or distribution
    @pextra3         as  varchar(200),
    @pextra4         as  varchar(200),
    @pextra5         as  varchar(200),
    @pextra6         as  varchar(200),
    @pextra7         as  varchar(200),
    @pextra8         as  varchar(200),
    @pextra9         as  varchar(200),
    @pextra10        as  varchar(200))
as
	declare @v_recptdt   datetime
begin
    set @v_recptdt =dbo.convert_user_date('/', @precptdt, @pdateformate)
    
	If upper(@pextra2)='D' Begin
        select distinct d.comp_code as "COMP_CODE",d.unit_code as "UNIT_CODE",d.recptno as "RECPTNO",d.recptdt as "RECPTDT",h.doctype as "DOCTYPE",
        d.agcd as "AGCD",d.dpcd as "DPCD", d.branch_code as "BRANCH_CODE",d.publ as "PUBL", d.edtn as "EDTN",
        d.supdate as "SUPDATE", d.supply_copy as "SUPPLY_COPY", d.rate_supply as "RATE_SUPPLY", 
        d.var_short_recpt as "SHORT_RECPT", d.var_late_recpt as "LATE_RECPT",d.damage as "DAMAGE", 
        d."VAR_BNR" as BNR, d.var_unsold as "UNSOLD", d.apr_short_recpt as "APR_SHORT_RECPT", d.apr_late_recpt as "APR_LATE_RECPT", d.apr_bnr as "APR_BNR",
        d.apr_unsold as "APR_UNSOLD",d.apr_damage as "APR_DAMAGE",d.copy_rate as "COPY_RATE",d.comm_rate as "COMM_RATE", d.waste_alw as "WASTE_ALW", d.waste_rate as "WASTE_RATE", 
        d.comm_catg_type as "COMM_CATG_TYPE", d.return_per as "RETURN_PER", d.sup_agcd as "SUP_AGCD", d.sup_dpcd as "SUP_DPCD" ,
		d.copy_amt as "COPY_AMT",d.comm_amt as "COMM_AMT",d.waste_amt as "WASTE_AMT",
        isnull(d.var_short_recpt,0)+isnull(d.var_late_recpt,0)+isnull(d.var_bnr,0)+isnull(d.var_unsold,0)+isnull(d.var_damage,0) as "NET_UNSOLD",
        isnull(d.apr_short_recpt,0)+isnull(d.apr_late_recpt,0)+isnull(d.apr_bnr,0)+isnull(d.apr_unsold,0)+isnull(d.apr_damage,0) as "NET_APPROVED"
        from cir_unsold_hdr_dis h,cir_unsold_dtl_dis d
        where h.comp_code=d.comp_code and h.comp_code=@pcompcode and h.unit_code=d.unit_code and 
        h.unit_code=@punitcode and h.doctype=d.doctype and h.recptno=d.recptno and h.recptno=isnull(@precptno,h.recptno) and
        h.recptdt=d.recptdt and h.recptdt=isnull(@v_recptdt,h.recptdt) and
        h.agcd=d.agcd and h.agcd=@pagcd and h.dpcd=d.dpcd and h.dpcd=@pdpcd and 
        (isnull(d.var_short_recpt,0)+isnull(d.var_late_recpt,0)+isnull(d.var_bnr,0)+isnull(d.var_unsold,0)+isnull(d.var_damage,0))-
        (isnull(d.apr_short_recpt,0)+isnull(d.apr_late_recpt,0)+isnull(d.apr_bnr,0)+isnull(d.apr_unsold,0)+isnull(d.apr_damage,0))>0
        
		order by recptdt,recptno,publ,edtn,supdate;
	End
    Else Begin
        select distinct d.comp_code as "COMP_CODE",d.unit_code as "UNIT_CODE",d.recptno as "RECPTNO",d.recptdt as "RECPTDT",h.doctype as "DOCTYPE", 
        d.agcd as "AGCD",d.dpcd as "DPCD", d.branch_code as "BRANCH_CODE",d.publ as "PUBL", d.edtn as "EDTN",
        d.supdate as "SUPDATE", d.supply_copy as "SUPPLY_COPY", d.rate_supply as "RATE_SUPPLY", 
        d.var_short_recpt as "SHORT_RECPT", d.var_late_recpt as "LATE_RECPT",d.damage as "DAMAGE", 
        d.VAR_BNR as "BNR", d.var_unsold as "UNSOLD", d.apr_short_recpt as "APR_SHORT_RECPT", d.apr_late_recpt as "APR_LATE_RECPT", d.apr_bnr as "APR_BNR",
        d.apr_unsold as "APR_UNSOLD",d.apr_damage as "APR_DAMAGE",d.copy_rate as "COPY_RATE",d.comm_rate as "COMM_RATE", d.waste_alw as "WASTE_ALW", d.waste_rate as "WASTE_RATE", 
        d.comm_catg_type as "COMM_CATG_TYPE", d.return_per as "RETURN_PER", d.sup_agcd as "SUP_AGCD", d.sup_dpcd as "SUP_DPCD",
		d.copy_amt as "COPY_AMT",d.comm_amt as "COMM_AMT",d.waste_amt as "WASTE_AMT",
        isnull(d.var_short_recpt,0)+isnull(d.var_late_recpt,0)+isnull(d.var_bnr,0)+isnull(d.var_unsold,0)+isnull(d.var_damage,0) as "NET_UNSOLD",
        isnull(d.apr_short_recpt,0)+isnull(d.apr_late_recpt,0)+isnull(d.apr_bnr,0)+isnull(d.apr_unsold,0)+isnull(d.apr_damage,0) as "NET_APPROVED"
		from cir_unsold_hdr h,cir_unsold_dtl d
        where h.comp_code=d.comp_code and h.comp_code=@pcompcode and h.unit_code=d.unit_code and 
        h.unit_code=@punitcode and h.doctype=d.doctype and h.recptno=d.recptno and h.recptno=isnull(@precptno,h.recptno) and 
        h.recptdt=d.recptdt and h.recptdt=isnull(@v_recptdt,h.recptdt) and
        h.agcd=d.agcd and h.agcd=@pagcd and h.dpcd=d.dpcd and h.dpcd=@pdpcd and 
        (isnull(d.var_short_recpt,0)+isnull(d.var_late_recpt,0)+isnull(d.var_bnr,0)+isnull(d.var_unsold,0)+isnull(d.var_damage,0))-
        (isnull(d.apr_short_recpt,0)+isnull(d.apr_late_recpt,0)+isnull(d.apr_bnr,0)+isnull(d.apr_unsold,0)+isnull(d.apr_damage,0))>0
        order by recptdt,recptno,publ,edtn,supdate;
	End
           

End

----------------------------------------------------------------------------------------------
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




ALTER PROCEDURE  [dbo].[Cir_update_sanction_details]
  	@puserid as varchar(100),
	@pcompcode as varchar(10),
    @punitcode as varchar(10),
	@psup_agcode as varchar(20),
	@psup_agsubcode as varchar(20),
    @pbranch as varchar(100),
	@preceiptno as varchar(100),
	@preceiptdate as varchar(50),
	@psup_date as varchar(50),
    @pa_unsold as	varchar(20),
	@pa_short as	varchar(20),
	@pa_damage as	varchar(20),
	@pa_bnr as	varchar(20),
	@pa_laterec as	varchar(20),
	@pdoctype	as varchar(20),
	@pdateformat as varchar(20),
    @pextra1 as	varchar(100),
    @pextra2 as varchar(100) 

 AS  
	declare @v_recptdt   datetime
	declare @v_supdt   datetime 

begin
    set @v_recptdt =dbo.convert_user_date('/', @preceiptdate, @pdateformat)
	set @v_supdt =dbo.convert_user_date('/', @psup_date, @pdateformat)
	If upper(@pextra2)='D' 
	begin
		UPDATE cir_unsold_dtl_dis set apr_short_recpt=apr_short_recpt+@pa_short,apr_late_recpt=apr_late_recpt+@pa_laterec,
		apr_bnr=apr_bnr+@pa_bnr,apr_unsold=apr_unsold+@pa_unsold,apr_damage=apr_damage+@pa_damage,userid=@puserid  
		WHERE comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype
		and branch_code=@pbranch and recptno=@preceiptno and recptdt=@v_recptdt
		and supdate=@v_supdt and agcd=@psup_agcode and dpcd=@psup_agsubcode;
	end
	else
	begin
		UPDATE cir_unsold_dtl set apr_short_recpt=apr_short_recpt+@pa_short,apr_late_recpt=apr_late_recpt+@pa_laterec,
		apr_bnr=apr_bnr+@pa_bnr,apr_unsold=apr_unsold+@pa_unsold,apr_damage=apr_damage+@pa_damage,userid=@puserid  
		WHERE comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype
		and branch_code=@pbranch and recptno=@preceiptno and recptdt=@v_recptdt
		and supdate=@v_supdt and agcd=@psup_agcode and dpcd=@psup_agsubcode;
end
end

--------------------------------------------------------------------------------------------
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER PROCEDURE  [dbo].[Cir_user_privilege]
  	@puserid as varchar(100),
	@pcompcode as varchar(10),
    @punitcode as varchar(10),
    @pbranch as varchar(200),
    @ppub as	varchar(30),
	@pedn as	varchar(30),
    @pextra1 as	varchar(100),
    @pextra2 as varchar(100)

 AS   
	SELECT approval_per as "APPROVAL_PER" FROM cir_unsold_apr_permission 
	WHERE user_id = @puserid and comp_code=@pcompcode and printing_center=@punitcode 
	and branch_code=@pbranch and publ=@ppub and sub_edtn=@pedn


-------------------------------------------------------------------------------------------------------
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROCEDURE [dbo].[Cir_Gen_Code_cir_unsold_scnction_p]
	@pcompcode			VARCHAR(20),
	@punitcode			VARCHAR(20),
	@pdoctype           VARCHAR(20),
	@pdateformat        VARCHAR(20),
	@pextra1            VARCHAR(400),--for unsold receipt date
	@pextra2            VARCHAR(400) --for agency or distribution
AS 

	DECLARE @vtype_code		VARCHAR(15) 
    DECLARE @v_prefix		varchar(20)
    DECLARE @v_no			varchar(20)
    DECLARE @v_dt			datetime
    DECLARE @v_chkdt		datetime	

	set @v_dt =dbo.convert_user_date('/', @pextra1, @pdateformat)

    set @v_prefix='SN'+replace(substring(convert(varchar(20), @v_dt, 2),1,5), '.', '')

	set @v_chkdt =dbo.GetFirstDayOfMonth( @v_dt)

    select @v_no=curr_no from cir_series
		where comp_code=@pcompcode and unit_code=@punitcode
		and ty=ISNULL(@pdoctype,'SCN') and dbo.GetFirstDayOfMonth( year_monid)=@v_chkdt 
		and prefix=@v_prefix

    If @v_no is null or @v_no='0' or @v_no='' Begin
        set @vtype_code=@v_prefix+'00001'
        insert into cir_series(comp_code,unit_code,branch_code,ty,year_monid,prefix, curr_no)
		values(@pcompcode,@punitcode,null,ISNULL(@pdoctype,'SCN'),@v_chkdt,@v_prefix,1)
	End		
    Else 
	Begin
        set @v_no =convert(int,@v_no)+1

        set @vtype_code  =@v_prefix+cast(dbo.fnPadLeft('0',5,@v_no) as varchar(50))
        
        update cir_series set curr_no=isnull(curr_no,0)+1
        where comp_code=@pcompcode and unit_code=@punitcode 
		and ty=ISNULL(@pdoctype,'SCN') and dbo.GetFirstDayOfMonth(year_monid)=@v_chkdt 
		and prefix=@v_prefix
    End

    select @vtype_code as "VAR_CODE"


/******************nand**************************************************************************************


/*************************issue no. 6357****************************start 23 jan by rahul********************/
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER FUNCTION  [dbo].[cir_get_dist] (@pcomp_code as varchar(100),@pstate_code as varchar(100),@pdist_code as varchar(100))  returns varchar(200) 

AS  

BEGIN 
DECLARE @vdist_name VARCHAR(4000)
select @vdist_name=dist_name from cir_dist_mast where comp_code=@pcomp_code and state_code=@pstate_code and dist_code=@pdist_code
	   
RETURN isnull(@vdist_name,'')
END











set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER FUNCTION  [dbo].[cir_get_state](@pcomp_code as varchar(100),@pcount_code as varchar(100),@pstate_code as varchar(100))  returns varchar(200) 
AS  
BEGIN 
DECLARE @vstate_name VARCHAR(4000)
select @vstate_name=State_Name FROM state_mst where Comp_Code=@pcomp_code 
and (Country_Code=@pcount_code or @pcount_code=null or @pcount_code='')
 and State_Code=@pstate_code
	   
RETURN isnull(@vstate_name,'NA')
END



/*******************************************************************end************************************/
/********************************************* start 03- feb - 2012  ************************************/
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
									 achd,voucherno,voucherdt,userid,creation_datetime,branch_code)
								values(@v1_comp_code, @v1_unit_code,@v1_agcd, @v1_dpcd,@v_doctype,
									 @v_recptno,@v_recptdt,@v_amt,'UNSOLD CREDIT NOTE',@v_remark,
									 'NM',@v_recptno,@v_recptdt,@puserid,getdate(),@v1_branch_code);
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
									 achd,voucherno,voucherdt,userid,creation_date,branch_code)
								values(@v1_comp_code, @v1_unit_code,@v1_agcd, @v1_dpcd,@v_doctype,
									 @v_recptno,@v_recptdt,@v_amt,'UNSOLD CREDIT NOTE',@v_remark,
									 'NM',@v_recptno,@v_recptdt,@puserid,getdate(),@v1_branch_code);
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
/********************************************* end 03- feb - 2012  ************************************/


//================================================Issue No. 6654,6653 10/10/2012 FOR DELIVERY CHALLAN REPORT================================================



ALTER PROCEDURE cir_rep_challan_cir_rep_route_challan
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

			IF @vvar is null or @vvar='' BEGIN 
				IF @pchallan_type = '1' BEGIN 
					print('in cur_edtn')
					SET @vvar  = '(case publ when' + '''' +  @vpubl1 + '''' + 'then lbl_tno else 0 end)"' +  @vpubl_name1 + '"' 
				    --vvar_sum    :='sum('+'"'+rec_edtn.publ_name+'") "'+rec_edtn.publ_name+'"';
					--vvar_sum1   :='sum('+'"'+rec_edtn.publ_name+'"';
				END
				ELSE IF @pchallan_type = '2' BEGIN 
					SET @vvar  = '(case publ when' + '''' +  @vpubl1 + '''' + ' then sum(supply_1) else 0 end)"' + @vpubl_name1 + '"' 
				END
				ELSE BEGIN 
					SET @vvar        =' case when publ='+''''+@vpubl1+''''+' then lbl_tno else 0 end "'+'B#'+@vpubl_name1+'"'
					SET @vvar        =@vvar+','+' case when publ='+''''+@vpubl1+''''+' then sum(supply_1) else 0 end "'+'S#'+@vpubl_name1+'"'
					SET @vvar_sum    ='sum('+'"'+'B#'+@vpubl_name1+'") "'+'B#'+@vpubl_name1+'"'
					SET @vvar_sum    =@vvar_sum+','+'sum('+'"'+'S#'+@vpubl_name1+'") "'+'S#'+@vpubl_name1+'"'
					SET @vvar_sum1   ='sum('+'"'+'B#'+@vpubl_name1+'"'
					SET @vvar_sum2   ='sum('+'"'+'S#'+@vpubl_name1+'"'					
				END
   
				SET @vvar_sum  = 'sum(' + '"' +  @vpubl_name1 + '") "' +   @vpubl_name1 + '"' 
				SET @vvar_sum1  = 'sum(' + '"' + @vpubl_name1 + '"' 
			END
			ELSE BEGIN 
				IF @pchallan_type = '1' BEGIN 
					SET @vvar  = @vvar + ',' + '(case publ when ' + '''' + @vpubl1 + '''' + 'then lbl_tno else 0 end)"' +   @vpubl_name1 + '"' 
				END
				ELSE IF @pchallan_type = '2' BEGIN 
					SET @vvar  = @vvar + ',' + '(case publ when' + '''' + @vpubl1 + '''' + 'then sum(supply_1) else 0 end)"' + @vpubl_name1 + '"' 
				END				
				ELSE BEGIN 
					SET @vvar		 = @vvar + ',' + '(case publ when' + '''' + @vpubl1 + '''' + 'then sum(supply_1) else 0 end)"' + @vpubl_name1 + '"' 
					SET @vvar        =@vvar+','+'case when publ='+''''+@vpubl1+''''+' then lbl_tno else 0 end "'+'B#'+@vpubl_name1+'"';
					SET @vvar        =@vvar+','+'case when publ='+''''+@vpubl1+''''+' then sum(supply_1) else 0 end "'+'S#'+@vpubl_name1+'"';
					SET @vvar_sum    =@vvar_sum+','+'sum('+'"'+'B#'+@vpubl_name1+'") "'+'B#'+@vpubl_name1+'"';
					SET @vvar_sum    =@vvar_sum+','+'sum('+'"'+'S#'+@vpubl_name1+'") "'+'S#'+@vpubl_name1+'"';
					SET @vvar_sum1   =@vvar_sum1+'+"'+'B#'+@vpubl_name1+'"';
					SET @vvar_sum2   =@vvar_sum2+'+"'+'S#'+@vpubl_name1+'"';					
				END
				print('in cur_edtn2')
				SET @vvar_sum  = @vvar_sum + ',' + 'sum(' + '"' +  @vpubl_name1 + '") "' +  @vpubl_name1 + '"' 
				SET @vvar_sum1  = @vvar_sum1 + '+"' +   @vpubl_name1 + '"' 
			END
   
		fetch NEXT FROM cur_edtn INTO @vcomp_code1 ,@vpubl1 , @vpubl_seqno1 , @vpubl_name1	
		END
		close cur_edtn
		print('close cur_edtn ')
		print(@vvar_sum)print(@vvar_sum1)
		SET @vvar_sum1  = @vvar_sum1 + ') Total' 
		--vvar:=substr(vvar,1,length(vvar)-1);
		print(@proutetype)print(@pchallan_type)
		IF @proutetype = '1' BEGIN 
			IF @vvar is null or @vvar='' BEGIN 
				IF @pchallan_type = '1' BEGIN 
					print('1')
					SET @vquery  = 'select x.comp_code as "COMP_CODE",unit_code as "UNIT_CODE",route_code as "ROUTE_CODE",x.route_name as "ROUTE_NAME",x.route_oname as "ROUTE_ONAME",dbo.cir_get_route_seqno(x.comp_code,x.unit_code,x.route_code) as "ROUTE_SEQNO", x.agcd as "AGCD",x.dpcd as "DPCD",x.agency_name as "AGENCY_NAME",x.agency_oname as "AGENCY_ONAME",x.city_name as "CITY_NAME",x.city_oname as "CITY_ONAME",x.station_name as "STATION_NAME" ,station_oname as "STATION_ONAME",x.distname as "DISTNAME",x.distoname as "DISTONAME",x.print_seq as "PRINT_SEQ", 0 as "TOTAL_PACKET" from(select a.comp_code comp_code,unit_code unit_code,a.route1 route_code,a.rtnm route_name,a.rtonm route_oname, a.agcd agcd,a.dpcd dpcd,b.ag_name agency_name,b.ag_name_oth_lang agency_oname,a.city_name city_name,a.city_oname city_oname,a.station_name station_name,a.station_oname station_oname, max(a.lbl_print_no) print_seq,a.publ publ,a.edtn edtn,a.distname distname,a.distoname distoname from cir_lblmast a,cir_agmast b  where a.comp_code = b.comp_code and a.comp_code =' + '''' + @pcompcode + '''' + ' and a.unit_code = b.unit and a.unit_code =' + '''' + @punitcode + '''' + ' and (a.publ =' + '''' + @ppublcode + '''' + ' or' + '''' + @ppublcode + '''' + ' is null' + ' or ' +   '''' + @ppublcode + '''' +' = '''+ ''') and a.agcd = b.agcd and a.dpcd = b.dpcd  and a.lbl_dt =' + '''' + @vsupdate1 + '''' + ' and  a.route1 in (select route_code from cir_route_mast where comp_code =' + '''' + @pcompcode + '''' + ' and unit =' + '''' + @punitcode + '''' + ' and (route_code =' + '''' + @proutecode + '''' + ' or ' + '''' + @proutecode + '''' + ' is null' + ' or ' + '''' + @proutecode + '''' +' = '''+ ''') and (route_mode =' + '''' + @proutemode + '''' + ' or ' + '''' + @proutemode + '''' + ' is null'+ ' or ' + '''' + @proutemode + '''' +' = '''+ ''')) and isnull(a.supply_1,0)>0  group by a.comp_code,a.unit_code,a.route1,a.rtnm,a.rtonm,a.publ,a.edtn,a.lbl_tno,a.agcd,a.dpcd,b.ag_name,b.ag_name_oth_lang,a.city_name,a.city_oname,a.station_name,a.station_oname,a.distname,a.distoname) x  group by x.comp_code,x.unit_code,x.route_code,x.route_oname,x.route_name,x.agcd,x.dpcd,x.print_seq,x.agency_name,x.agency_oname,x.city_name,x.city_oname,x.station_name,x.station_oname,x.distname,x.distoname order by route_seqno,route_name,print_seq,agency_name' 
				END
				ELSE BEGIN 
					print('2')
					SET @vquery  = 'select x.comp_code as "COMP_CODE",unit_code as "UNIT_CODE",route_code as "ROUTE_CODE",x.route_name as "ROUTE_NAME",x.route_oname as "ROUTE_ONAME",dbo.cir_get_route_seqno(x.comp_code,x.unit_code,x.route_code) as "ROUTE_SEQNO", x.agcd as "AGCD",x.dpcd as "DPCD",x.agency_name as "AGENCY_NAME",x.agency_oname as "AGENCY_ONAME",x.city_name as "CITY_NAME",x.city_oname as "CITY_ONAME",x.station_name as "STATION_NAME" ,station_oname as "STATION_ONAME",x.distname as "DISTNAME",x.distoname as "DISTONAME",x.print_seq as "PRINT_SEQ", 0 as "TOTAL_PACKET" from(select a.comp_code comp_code,unit_code unit_code,a.route1 route_code,a.rtnm route_name,a.rtonm route_oname, a.agcd agcd,a.dpcd dpcd,b.ag_name agency_name,b.ag_name_oth_lang agency_oname,a.city_name city_name,a.city_oname city_oname,a.station_name station_name,a.station_oname station_oname, max(a.lbl_print_no) print_seq,a.publ publ,a.edtn edtn,a.distname distname,a.distoname distoname from cir_lblmast a,cir_agmast b  where a.comp_code = b.comp_code and a.comp_code =' + '''' + @pcompcode + '''' + ' and a.unit_code = b.unit and a.unit_code =' + '''' + @punitcode + '''' + ' and  (a.publ =' + '''' + @ppublcode + '''' + ' or' + '''' + @ppublcode + '''' + ' is null' + ' or ' +   '''' + @ppublcode + '''' +' = '''+ ''') and a.agcd = b.agcd and a.dpcd = b.dpcd  and a.lbl_dt =' + '''' + @vsupdate1 + '''' + ' and a.route1 in (select route_code from cir_route_mast where comp_code =' + '''' + @pcompcode + '''' + ' and unit =' + '''' + @punitcode + '''' + ' and (route_code =' + '''' + @proutecode + '''' + ' or ' + '''' + @proutecode + '''' + ' is null' + ' or ' + '''' + @proutecode + '''' +' = '''+ ''') and  (route_mode =' + '''' + @proutemode + '''' + ' or ' + '''' + @proutemode + '''' + ' is null'+ ' or ' + '''' + @proutemode + '''' +' = '''+ ''')) and isnull(a.supply_1,0)>0 group by a.comp_code,a.unit_code,a.route1,a.rtnm,a.rtonm,a.publ,a.edtn,a.agcd,a.dpcd,b.ag_name,b.ag_name_oth_lang,a.city_name,a.city_oname,a.station_name,a.station_oname,a.distname,a.distoname) x group by x.comp_code,x.unit_code,x.route_code,x.route_oname,x.route_name,x.agcd,x.dpcd,x.print_seq,x.agency_name,x.agency_oname,x.city_name,x.city_oname,x.station_name,x.station_oname,x.distname,x.distoname order by route_seqno,route_name,print_seq,agency_name' 
				END
			END
			ELSE BEGIN 
				IF @pchallan_type = '1' BEGIN 
					print('3')
					SET @vquery  = 'select x.comp_code as "COMP_CODE",unit_code as "UNIT_CODE",route_code as "ROUTE_CODE",x.route_name as "ROUTE_NAME",x.route_oname as "ROUTE_ONAME",dbo.cir_get_route_seqno(x.comp_code,x.unit_code,x.route_code) as "ROUTE_SEQNO", x.agcd as "AGCD",x.dpcd as "DPCD",x.agency_name as "AGENCY_NAME",x.agency_oname as "AGENCY_ONAME",x.city_name as "CITY_NAME",x.city_oname as "CITY_ONAME",x.station_name as "STATION_NAME" ,station_oname as "STATION_ONAME",x.distname as "DISTNAME",x.distoname as "DISTONAME",x.print_seq as "PRINT_SEQ", 0 as "TOTAL_PACKET",' + @vvar_sum + ',' + @vvar_sum1 + ' from(select a.comp_code comp_code,unit_code unit_code,a.route1 route_code,a.rtnm route_name,a.rtonm route_oname,  a.agcd agcd,a.dpcd dpcd,b.ag_name agency_name,b.ag_name_oth_lang agency_oname,a.city_name city_name,a.city_oname city_oname,a.station_name station_name,a.station_oname station_oname,a.distname distname,a.distoname distoname,  max(a.lbl_print_no) print_seq,a.publ publ,a.edtn edtn,' + @vvar + ' from cir_lblmast a,cir_agmast b  where a.comp_code = b.comp_code and a.comp_code =' + '''' + @pcompcode + '''' + ' and a.unit_code = b.unit and a.unit_code =' + '''' + @punitcode + '''' + ' and  (a.publ =' + '''' + @ppublcode + '''' + ' or ' + '''' + @ppublcode + '''' + ' is null' + ' or ' +   '''' + @ppublcode + '''' +' = '''+ ''') and a.agcd = b.agcd and a.dpcd = b.dpcd  and a.lbl_dt =' + '''' + @vsupdate1 + '''' + ' and  a.route1 in (select route_code from cir_route_mast where comp_code =' + '''' + @pcompcode + '''' + ' and unit =' + '''' + @punitcode + '''' + ' and (route_code =' + '''' + @proutecode + '''' + ' or ' + '''' + @proutecode + '''' + ' is null' + ' or' + '''' + @proutecode + '''' +' = '''+ ''') and (route_mode =' + '''' + @proutemode + '''' + ' or ' + '''' + @proutemode + '''' + ' is null'+ ' or ' + '''' + @proutemode + '''' +' = '''+ ''')) and isnull(a.supply_1,0)>0 group by a.comp_code,a.unit_code,a.route1,a.rtnm,a.rtonm,a.publ,a.edtn,a.lbl_tno,a.agcd,a.dpcd,b.ag_name,b.ag_name_oth_lang,a.city_name,a.city_oname,a.station_name,a.station_oname,a.distname,a.distoname) x group by x.comp_code,x.unit_code,x.route_code,x.route_oname,x.route_name,x.agcd,x.dpcd,x.print_seq,x.agency_name,x.agency_oname,x.city_name,x.city_oname,x.station_name,x.station_oname,x.distname,x.distoname  order by route_seqno,route_name,print_seq,agency_name' 
				END
				ELSE BEGIN 
					print('4')
					SET @vquery  = 'select x.comp_code as "COMP_CODE",unit_code as "UNIT_CODE",route_code as "ROUTE_CODE",x.route_name as "ROUTE_NAME",x.route_oname as "ROUTE_ONAME",dbo.cir_get_route_seqno(x.comp_code,x.unit_code,x.route_code) as "ROUTE_SEQNO", x.agcd as "AGCD",x.dpcd as "DPCD",x.agency_name as "AGENCY_NAME",x.agency_oname as "AGENCY_ONAME",x.city_name as "CITY_NAME",x.city_oname as "CITY_ONAME",x.station_name as "STATION_NAME" ,station_oname as "STATION_ONAME",x.distname as "DISTNAME",x.distoname as "DISTONAME",x.print_seq as "PRINT_SEQ", 0 as "TOTAL_PACKET",' + @vvar_sum + ',' + @vvar_sum1 + ' from(select a.comp_code comp_code,unit_code unit_code,a.route1 route_code,a.rtnm route_name,a.rtonm route_oname, a.agcd agcd,a.dpcd dpcd,b.ag_name agency_name,b.ag_name_oth_lang agency_oname,a.city_name city_name,a.city_oname city_oname,a.station_name station_name,a.station_oname station_oname,a.distname distname,a.distoname distoname, max(a.lbl_print_no) print_seq,a.publ publ,a.edtn edtn,' + @vvar + ' from cir_lblmast a,cir_agmast b   where a.comp_code = b.comp_code and a.comp_code =' + '''' + @pcompcode + '''' + ' and a.unit_code = b.unit and a.unit_code =' + '''' + @punitcode + '''' + ' and  (a.publ =' + '''' + @ppublcode + '''' + ' or ' + '''' + @ppublcode + '''' + ' is null' + ' or ' +   '''' + @ppublcode + '''' +' = '''+ ''') and a.agcd = b.agcd and a.dpcd = b.dpcd  and a.lbl_dt =' + '''' + @vsupdate1 + '''' + ' and a.route1 in (select route_code from cir_route_mast where comp_code =' + '''' + @pcompcode + '''' + ' and unit =' + '''' + @punitcode + '''' + ' and (route_code =' + '''' + @proutecode + '''' + ' or ' + '''' + @proutecode + '''' + ' is null' + ' or' + '''' + @proutecode + '''' +' = '''+ ''') and  (route_mode =' + '''' + @proutemode + '''' + ' or ' + '''' + @proutemode + '''' + ' is null'+ ' or ' + '''' + @proutemode + '''' +' = '''+ ''')) and isnull(a.supply_1,0)>0  group by a.comp_code,a.unit_code,a.route1,a.rtnm,a.rtonm,a.publ,a.edtn,a.agcd,a.dpcd,b.ag_name,b.ag_name_oth_lang,a.city_name,a.city_oname,a.station_name,a.station_oname,a.distname,a.distoname) x group by x.comp_code,x.unit_code,x.route_code,x.route_oname,x.route_name,x.agcd,x.dpcd,x.print_seq,x.agency_name,x.agency_oname,x.city_name,x.city_oname,x.station_name,x.station_oname,x.distname,x.distoname order by route_seqno,route_name,print_seq,agency_name' 
				END
			END
		END
		IF @proutetype = '2' BEGIN 
			IF @vvar is null BEGIN 
				IF @pchallan_type = '1' BEGIN 
					print('5')
					SET @vquery  = 'select x.comp_code as "COMP_CODE",unit_code as "UNIT_CODE",route_code as "ROUTE_CODE",x.route_name as "ROUTE_NAME",x.route_oname as "ROUTE_ONAME",dbo.cir_get_route_seqno(x.comp_code,x.unit_code,x.route_code) as "ROUTE_SEQNO", x.subroute_code as "SUBROUTE_CODE",x.subroute_name as "SUBROUTE_NAME",subroute_oname as "SUBROUTE_ONAME",dbo.cir_get_subroute_seqno(x.comp_code,x.unit_code,x.route_code,x.subroute_code) as "SUBROUTE_SEQNO", x.agcd as "AGCD",x.dpcd as "DPCD",x.agency_name as "AGENCY_NAME",x.agency_oname as "AGENCY_ONAME",x.city_name as "CITY_NAME",x.city_oname as "CITY_ONAME",x.station_name as "STATION_NAME" ,station_oname as "STATION_ONAME",x.distname as "DISTNAME",x.distoname as "DISTONAME",x.print_seq as "PRINT_SEQ", 0 as "TOTAL_PACKET" from(select a.comp_code comp_code,unit_code unit_code,a.route1 route_code,a.rtnm route_name,a.rtonm route_oname,  a.subrt subroute_code,a.subrtnm subroute_name,a.subrtonm subroute_oname, a.agcd agcd,a.dpcd dpcd,b.ag_name agency_name,b.ag_name_oth_lang agency_oname,a.city_name city_name,a.city_oname city_oname,a.station_name station_name,a.station_oname station_oname, max(a.lbl_print_no) print_seq,a.publ publ,a.edtn edtn,a.distname distname,a.distoname distoname from cir_lblmast a,cir_agmast b where a.comp_code = b.comp_code and a.comp_code =' + '''' + @pcompcode + '''' + ' and a.unit_code = b.unit and a.unit_code =' + '''' + @punitcode + '''' + ' and (a.publ =' + '''' + @ppublcode + '''' + ' or ' + '''' + @ppublcode + '''' + ' is null' + ' or ' +   '''' + @ppublcode + '''' +' = '''+ ''') and a.agcd = b.agcd and a.dpcd = b.dpcd  and a.lbl_dt =' + '''' + @vsupdate1 + '''' + ' and  a.route1+a.subrt in (select route_code+subrt_code from cir_sub_route_mast where comp_code =' + '''' + @pcompcode + '''' + ' and unit =' + '''' + @punitcode + '''' + ' and (route_code+subrt_code =' + '''' + @proutecode + '''' + ' or ''' + '' + @proutecode + '''' + ' is null' + ' or ' + '' + @proutecode + '''' +''' = '''+ ''') and  (subrt_mode =' + '''' + @proutemode + '''' + ' or ' + '''' + @proutemode + '''' + ' is null'+ ' or ' + '''' + @proutemode + '''' +' = '''+ ''')) and isnull(a.supply_1,0)>0  group by a.comp_code,a.unit_code,a.route1,a.rtnm,a.rtonm,a.subrt,a.subrtnm,a.subrtonm,a.publ,a.edtn,a.lbl_tno,a.agcd,a.dpcd,b.ag_name,b.ag_name_oth_lang,a.city_name,a.city_oname,a.station_name,a.station_oname,a.distname,a.distoname) x group by x.comp_code,x.unit_code,x.route_code,x.route_oname,x.route_name,x.subroute_code,x.subroute_name,x.subroute_oname,x.agcd,x.dpcd,x.print_seq,x.agency_name,x.agency_oname,x.city_name,x.city_oname,x.station_name,x.station_oname,x.distname,x.distoname  order by route_seqno,route_name,subroute_seqno,subroute_name,print_seq,agency_name' 
				END
				ELSE BEGIN 
					print('6')
					SET @vquery  = 'select x.comp_code as "COMP_CODE",unit_code as "UNIT_CODE",route_code as "ROUTE_CODE",x.route_name as "ROUTE_NAME",x.route_oname as "ROUTE_ONAME",dbo.cir_get_route_seqno(x.comp_code,x.unit_code,x.route_code) as "ROUTE_SEQNO", x.subroute_code as "SUBROUTE_CODE",x.subroute_name as "SUBROUTE_NAME",x.subroute_oname as "SUBROUTE_ONAME",dbo.cir_get_subroute_seqno(x.comp_code,x.unit_code,x.route_code,x.subroute_code) as "SUBROUTE_SEQNO",x.agcd as "AGCD",x.dpcd as "DPCD",x.agency_name as "AGENCY_NAME",x.agency_oname as "AGENCY_ONAME",x.city_name as "CITY_NAME",x.city_oname as "CITY_ONAME",x.station_name as "STATION_NAME" ,station_oname as "STATION_ONAME",x.distname as "DISTNAME",x.distoname as "DISTONAME",x.print_seq as "PRINT_SEQ", 0 as "TOTAL_PACKET"  from(select a.comp_code comp_code,unit_code unit_code,a.route1 route_code,a.rtnm route_name,a.rtonm route_oname, a.subrt subroute_code,a.subrtnm subroute_name,a.subrtonm subroute_oname,a.agcd agcd,a.dpcd dpcd,b.ag_name agency_name,b.ag_name_oth_lang agency_oname,a.city_name city_name,a.city_oname city_oname,a.station_name station_name,a.station_oname station_oname,  max(a.lbl_print_no) print_seq,a.publ publ,a.edtn edtn,a.distname distname,a.distoname distoname from cir_lblmast a,cir_agmast b  where a.comp_code = b.comp_code and a.comp_code =' + '''' + @pcompcode + '''' + ' and a.unit_code = b.unit and a.unit_code =' + '''' + @punitcode + '''' + ' and (a.publ =' + '''' + @ppublcode + '''' + ' or ' + '''' + @ppublcode + '''' + ' is null' + ' or ' +   '''' + @ppublcode + '''' +' = '''+ ''') and a.agcd = b.agcd and a.dpcd = b.dpcd  and a.lbl_dt =' + '''' + @vsupdate1 + '''' + ' and  a.route1+a.subrt in (select route_code+subrt_code from cir_sub_route_mast where comp_code =' + '''' + @pcompcode + '''' + ' and unit =' + '''' + @punitcode + '''' + ' and (route_code+subrt_code =' + '''' + @proutecode + '''' + ' or ''' + '' + @proutecode + '''' + ' is null' + ' or ' + '' + @proutecode + '''' +''' = '''+ ''') and  (subrt_mode =' + '''' + @proutemode + '''' + ' or ' + '''' + @proutemode + '''' + ' is null'+ ' or ' + '''' + @proutemode + '''' +' = '''+ ''')) and isnull(a.supply_1,0)>0 group by a.comp_code,a.unit_code,a.route1,a.rtnm,a.rtonm,a.subrt,a.subrtnm,a.subrtonm,a.publ,a.edtn,a.agcd,a.dpcd,b.ag_name,b.ag_name_oth_lang,a.city_name,a.city_oname,a.station_name,a.station_oname,a.distname,a.distoname) x group by x.comp_code,x.unit_code,x.route_code,x.route_oname,x.route_name,x.subroute_code,x.subroute_name,x.subroute_oname,x.agcd,x.dpcd,x.print_seq,x.agency_name,x.agency_oname,x.city_name,x.city_oname,x.station_name,x.station_oname,x.distname,x.distoname  order by route_seqno,route_name,subroute_seqno,subroute_name,print_seq,agency_name' 
				END
   			END
			ELSE BEGIN 
				IF @pchallan_type = '1' BEGIN 
					print('7')
					SET @vquery  = 'select x.comp_code as "COMP_CODE",unit_code as "UNIT_CODE",route_code as "ROUTE_CODE",x.route_name as "ROUTE_NAME",x.route_oname as "ROUTE_ONAME",dbo.cir_get_route_seqno(x.comp_code,x.unit_code,x.route_code) as "ROUTE_SEQNO", x.subroute_code  as "SUBROUTE_CODE",x.subroute_name as "SUBROUTE_NAME",x.subroute_oname as "SUBROUTE_ONAME",dbo.cir_get_subroute_seqno(x.comp_code,x.unit_code,x.route_code,x.subroute_code) as "SUBROUTE_SEQNO", x.agcd as "AGCD",x.dpcd as "DPCD",x.agency_name as "AGENCY_NAME",x.agency_oname as "AGENCY_ONAME",x.city_name as "CITY_NAME",x.city_oname as "CITY_ONAME",x.station_name as "STATION_NAME" ,station_oname as "STATION_ONAME",x.distname as "DISTNAME",x.distoname as "DISTONAME",x.print_seq as "PRINT_SEQ", 0 as "TOTAL_PACKET",' + @vvar_sum + ',' + @vvar_sum1 + ' from(select a.comp_code comp_code,unit_code unit_code,a.route1 route_code,a.rtnm route_name,a.rtonm route_oname, a.subrt subroute_code,a.subrtnm subroute_name,a.subrtonm subroute_oname,  a.agcd agcd,a.dpcd dpcd,b.ag_name agency_name,b.ag_name_oth_lang agency_oname,a.city_name city_name,a.city_oname city_oname,a.station_name station_name,a.station_oname station_oname,a.distname distname,a.distoname distoname,  max(a.lbl_print_no) print_seq,publ,' + @vvar + '  from cir_lblmast a,cir_agmast b where a.comp_code = b.comp_code and a.comp_code =' + '''' + @pcompcode + '''' + ' and a.unit_code = b.unit and a.unit_code =' + '''' + @punitcode + '''' + ' and  (a.publ =' + '''' + @ppublcode + '''' + ' or' + '''' + @ppublcode + '''' + ' is null' + ' or ' +   '''' + @ppublcode + '''' +' = '''+ ''') and a.agcd = b.agcd and a.dpcd = b.dpcd  and a.lbl_dt =' + '''' + @vsupdate1 + '''' + ' and  a.route1+a.subrt in (select route_code+subrt_code from cir_sub_route_mast where comp_code =' + '''' + @pcompcode + '''' + ' and unit =' + '''' + @punitcode + '''' + ' and (route_code+subrt_code =' + '''' + @proutecode + '''' + ' or' + '''' + @proutecode + '''' + ' is null' + ' or ' + '''' + @proutecode + '''' +' = '''+ ''') and  (subrt_mode =' + '''' + @proutemode + '''' + ' or' + '''' + @proutemode + '''' + ' is null'+ ' or ' + '''' + @proutemode + '''' +' = '''+ ''')) and isnull(a.supply_1,0)>0  group by a.comp_code,a.unit_code,a.route1,a.rtnm,a.rtonm,a.subrt,a.subrtnm,a.subrtonm,a.publ,a.edtn,a.lbl_tno,a.agcd,a.dpcd,b.ag_name,b.ag_name_oth_lang,a.city_name,a.city_oname,a.station_name,a.station_oname,a.distname,a.distoname) x group by x.comp_code,x.unit_code,x.route_code,x.route_oname,x.route_name,x.subroute_code,x.subroute_name,x.subroute_oname,x.agcd,x.dpcd,x.print_seq,x.agency_name,x.agency_oname,x.city_name,x.city_oname,x.station_name,x.station_oname,x.distname,x.distoname order by route_seqno,route_name,subroute_seqno,subroute_name,print_seq,agency_name' 
				END
				ELSE BEGIN
					print('8')
					SET @vquery  = 'select x.comp_code as "COMP_CODE",unit_code as "UNIT_CODE",route_code as "ROUTE_CODE",x.route_name as "ROUTE_NAME",x.route_oname as "ROUTE_ONAME",dbo.cir_get_route_seqno(x.comp_code,x.unit_code,x.route_code) as "ROUTE_SEQNO", x.subroute_code  as "SUBROUTE_CODE",x.subroute_name as "SUBROUTE_NAME",x.subroute_oname as "SUBROUTE_ONAME",dbo.cir_get_subroute_seqno(x.comp_code,x.unit_code,x.route_code,x.subroute_code) as "SUBROUTE_SEQNO", x.agcd as "AGCD",x.dpcd as "DPCD",x.agency_name as "AGENCY_NAME",x.agency_oname as "AGENCY_ONAME",x.city_name as "CITY_NAME",x.city_oname as "CITY_ONAME",x.station_name as "STATION_NAME" ,station_oname as "STATION_ONAME",x.distname as "DISTNAME",x.distoname as "DISTONAME",x.print_seq as "PRINT_SEQ", 0 as "TOTAL_PACKET",' + @vvar_sum + ',' + @vvar_sum1 + ' from(select a.comp_code comp_code,unit_code unit_code,a.route1 route_code,a.rtnm route_name,a.rtonm route_oname, a.subrt subroute_code,a.subrtnm subroute_name,a.subrtonm subroute_oname,  a.agcd agcd,a.dpcd dpcd,b.ag_name agency_name,b.ag_name_oth_lang agency_oname,a.city_name city_name,a.city_oname city_oname,a.station_name station_name,a.station_oname station_oname,a.distname distname,a.distoname distoname, max(a.lbl_print_no) print_seq,publ,' + @vvar + '  from cir_lblmast a,cir_agmast b where a.comp_code = b.comp_code and a.comp_code =' + '''' + @pcompcode + '''' + ' and a.unit_code = b.unit and a.unit_code =' + '''' + @punitcode + '''' + ' and (a.publ =' + '''' + @ppublcode + '''' + ' or' + '''' + @ppublcode + '''' + ' is null' + ' or ' +   '''' + @ppublcode + '''' +' = '''+ ''') and a.agcd = b.agcd and a.dpcd = b.dpcd  and a.lbl_dt =' + '''' + @vsupdate1 + '''' + ' and a.route1+a.subrt in (select route_code+subrt_code from cir_sub_route_mast where comp_code =' + '''' + @pcompcode + '''' + ' and unit =' + '''' + @punitcode + '''' + ' and (route_code+subrt_code =' + '''' + @proutecode + '''' + ' or' + '''' + @proutecode + '''' + ' is null' + ' or ' + '''' + @proutecode + '''' +' = '''+ ''') and  (subrt_mode =' + '''' + @proutemode + '''' + ' or' + '''' + @proutemode + '''' + ' is null'+ ' or ' + '''' + @proutemode + '''' +' = '''+ ''')) and isnull(a.supply_1,0)>0   group by a.comp_code,a.unit_code,a.route1,a.rtnm,a.rtonm,a.subrt,a.subrtnm,a.subrtonm,a.publ,a.edtn,a.agcd,a.dpcd,b.ag_name,b.ag_name_oth_lang,a.city_name,a.city_oname,a.station_name,a.station_oname,a.distname,a.distoname) x group by x.comp_code,x.unit_code,x.route_code,x.route_oname,x.route_name,x.subroute_code,x.subroute_name,x.subroute_oname,x.agcd,x.dpcd,x.print_seq,x.agency_name,x.agency_oname,x.city_name,x.city_oname,x.station_name,x.station_oname,x.distname,x.distoname  order by route_seqno,route_name,subroute_seqno,subroute_name,print_seq,agency_name' 
				END
			END
		END
		IF @proutetype = '3' BEGIN 
		--ELSE BEGIN 
			IF @vvar is null BEGIN 
				IF @pchallan_type = '1' BEGIN 
					print('9')
					SET @vquery  = 'select x.comp_code as "COMP_CODE",unit_code as "UNIT_CODE",route_code as "ROUTE_CODE",x.route_name as "ROUTE_NAME",x.route_oname as "ROUTE_ONAME",dbo.cir_get_route_seqno(x.comp_code,x.unit_code,x.route_code) as "ROUTE_SEQNO", x.subroute_code  as "SUBROUTE_CODE",x.subroute_name as "SUBROUTE_NAME",x.subroute_oname as "SUBROUTE_ONAME",dbo.cir_get_subroute_seqno(x.comp_code,x.unit_code,x.route_code,x.subroute_code) as "SUBROUTE_SEQNO",  x.subsubrt_code as "SUBSUBRT_CODE",x.subsubrt_name as "SUBSUBRT_NAME",x.subsubrt_oname as "SUBSUBRT_ONAME",dbo.cir_get_subsubroute_seqno(x.comp_code,x.unit_code,x.route_code,x.subroute_code,x.subsubrt_code) as "SUBSUBRT_SEQNO",  x.agcd as "AGCD",x.dpcd as "DPCD",x.agency_name as "AGENCY_NAME",x.agency_oname as "AGENCY_ONAME",x.city_name as "CITY_NAME",x.city_oname as "CITY_ONAME",x.station_name as "STATION_NAME" ,station_oname as "STATION_ONAME",x.distname as "DISTNAME",x.distoname as "DISTONAME",x.print_seq as "PRINT_SEQ", 0 as "TOTAL_PACKET"  from(select a.comp_code comp_code,unit_code unit_code,a.route1 route_code,a.rtnm route_name,a.rtonm route_oname,  a.subrt subroute_code,a.subrtnm subroute_name,a.subrtonm subroute_oname, a.sub_subrt subsubrt_code,a.subsubrtnm subsubrt_name,a.subsubrtonm subsubrt_oname, a.agcd agcd,a.dpcd dpcd,b.ag_name agency_name,b.ag_name_oth_lang agency_oname,a.city_name city_name,a.city_oname city_oname,a.station_name station_name,a.station_oname station_oname, max(a.lbl_print_no) print_seq,a.publ publ,a.edtn edtn,a.distname distname,a.distoname distoname  from cir_lblmast a,cir_agmast b  where a.comp_code = b.comp_code and a.comp_code =' + '''' + @pcompcode + '''' + ' and a.unit_code = b.unit and a.unit_code =' + '''' + @punitcode + '''' + ' and  (a.publ =' + '''' + @ppublcode + '''' + ' or' + '''' + @ppublcode + '''' + ' is null' + ' or ' +   '''' + @ppublcode + '''' +' = '''+ ''') and a.agcd = b.agcd and a.dpcd = b.dpcd  and a.lbl_dt =' + '''' + @vsupdate1 + '''' + ' and  a.route1+a.subrt+a.sub_subrt in (select route_code+subrt_code+sub_subrt_code from cir_sub_subroute_mast where comp_code =' + '''' + @pcompcode + '''' + ' and unit =' + '''' + @punitcode + '''' + ' and (route_code+subrt_code+sub_subrt_code =' + '''' + @proutecode + '''' + ' or' + '''' + @proutecode + '''' + ' is null' + ' or ' + '''' + @proutecode + '''' +' = '''+ ''') and  (sub_subrt_mode =' + '''' + @proutemode + '''' + ' or ' + '''' + @proutemode + '''' + ' is null'+ ' or ' + '''' + @proutemode + '''' +' = '''+ ''')) and isnull(a.supply_1,0)>0  group by a.comp_code,a.unit_code,a.route1,a.rtnm,a.rtonm,a.subrt,a.subrtnm,a.subrtonm,a.sub_subrt,a.subsubrtnm,a.subsubrtonm,a.publ,a.edtn,a.lbl_tno,a.agcd,a.dpcd,b.ag_name,b.ag_name_oth_lang,a.city_name,a.city_oname,a.station_name,a.station_oname,a.distname,a.distoname) x group by x.comp_code,x.unit_code,x.route_code,x.route_oname,x.route_name,x.subroute_code,x.subroute_name,x.subroute_oname,x.subsubrt_code,x.subsubrt_name,x.subsubrt_oname,  x.agcd,x.dpcd,x.print_seq,x.agency_name,x.agency_oname,x.city_name,x.city_oname,x.station_name,x.station_oname,x.distname,x.distoname  order by route_seqno,route_name,subroute_seqno,subroute_name,subsubrt_seqno,subsubrt_name,print_seq,agency_name' 
				END
				ELSE BEGIN 
					print('10')
					SET @vquery  = 'select x.comp_code as "COMP_CODE",unit_code as "UNIT_CODE",route_code as "ROUTE_CODE",x.route_name as "ROUTE_NAME",x.route_oname as "ROUTE_ONAME",dbo.cir_get_route_seqno(x.comp_code,x.unit_code,x.route_code) as "ROUTE_SEQNO",  x.subroute_code  as "SUBROUTE_CODE",x.subroute_name as "SUBROUTE_NAME",x.subroute_oname as "SUBROUTE_ONAME",dbo.cir_get_subroute_seqno(x.comp_code,x.unit_code,x.route_code,x.subroute_code) as "SUBROUTE_SEQNO",  x.subsubrt_code as "SUBSUBRT_CODE",x.subsubrt_name as "SUBSUBRT_NAME",x.subsubrt_oname as "SUBSUBRT_ONAME",dbo.cir_get_subsubroute_seqno(x.comp_code,x.unit_code,x.route_code,x.subroute_code,x.subsubrt_code) as "SUBSUBRT_SEQNO", x.agcd as "AGCD",x.dpcd as "DPCD",x.agency_name as "AGENCY_NAME",x.agency_oname as "AGENCY_ONAME",x.city_name as "CITY_NAME",x.city_oname as "CITY_ONAME",x.station_name as "STATION_NAME" ,station_oname as "STATION_ONAME",x.distname as "DISTNAME",x.distoname as "DISTONAME",x.print_seq as "PRINT_SEQ", 0 as "TOTAL_PACKET" from(select a.comp_code comp_code,unit_code unit_code,a.route1 route_code,a.rtnm route_name,a.rtonm route_oname,  a.subrt subroute_code,a.subrtnm subroute_name,a.subrtonm subroute_oname, a.sub_subrt subsubrt_code,a.subsubrtnm subsubrt_name,a.subsubrtonm subsubrt_oname, a.agcd agcd,a.dpcd dpcd,b.ag_name agency_name,b.ag_name_oth_lang agency_oname,a.city_name city_name,a.city_oname city_oname,a.station_name station_name,a.station_oname station_oname, max(a.lbl_print_no) print_seq,a.publ publ,a.edtn edtn,a.distname distname,a.distoname distoname   from cir_lblmast a,cir_agmast b  where a.comp_code = b.comp_code and a.comp_code =' + '''' + @pcompcode + '''' + ' and a.unit_code = b.unit and a.unit_code =' + '''' + @punitcode + '''' + ' and  (a.publ =' + '''' + @ppublcode + '''' + ' or' + '''' + @ppublcode + '''' + ' is null' + ' or ' +   '''' + @ppublcode + '''' +' = '''+ ''') and a.agcd = b.agcd and a.dpcd = b.dpcd  and a.lbl_dt =' + '''' + @vsupdate1+ '''' + ' and  a.route1+a.subrt+a.sub_subrt in (select route_code+subrt_code+sub_subrt_code from cir_sub_subroute_mast where comp_code =' + '''' + @pcompcode + '''' + ' and unit =' + '''' + @punitcode + '''' + ' and (route_code+subrt_code+sub_subrt_code =' + '''' + @proutecode + '''' + ' or' + '''' + @proutecode + '''' + ' is null' + ' or ' + '''' + @proutecode + '''' +' = '''+ ''') and  (sub_subrt_mode =' + '''' + @proutemode + '''' + ' or ' + '''' + @proutemode + '''' + ' is null'+ ' or ' + '''' + @proutemode + '''' +' = '''+ ''')) and isnull(a.supply_1,0)>0  group by a.comp_code,a.unit_code,a.route1,a.rtnm,a.rtonm,a.subrt,a.subrtnm,a.subrtonm,a.sub_subrt,a.subsubrtnm,a.subsubrtonm,a.publ,a.edtn,/*a.supply_1,*/a.agcd,a.dpcd,b.ag_name,b.ag_name_oth_lang,a.city_name,a.city_oname,a.station_name,a.station_oname,a.distname,a.distoname) x group by x.comp_code,x.unit_code,x.route_code,x.route_oname,x.route_name,x.subroute_code,x.subroute_name,x.subroute_oname,x.subsubrt_code,x.subsubrt_name,x.subsubrt_oname,  x.agcd,x.dpcd,x.print_seq,x.agency_name,x.agency_oname,x.city_name,x.city_oname,x.station_name,x.station_oname,x.distname,x.distoname order by route_seqno,route_name,subroute_seqno,subroute_name,subsubrt_seqno,subsubrt_name,print_seq,agency_name' 
				END
   			END
			ELSE BEGIN 
				IF @pchallan_type = '1' BEGIN 
					print('11')
					SET @vquery  = 'select x.comp_code as "COMP_CODE",unit_code as "UNIT_CODE",route_code as "ROUTE_CODE",x.route_name as "ROUTE_NAME",x.route_oname as "ROUTE_ONAME",dbo.cir_get_route_seqno(x.comp_code,x.unit_code,x.route_code) as "ROUTE_SEQNO", x.subroute_code  as "SUBROUTE_CODE",x.subroute_name as "SUBROUTE_NAME",x.subroute_oname as "SUBROUTE_ONAME",dbo.cir_get_subroute_seqno(x.comp_code,x.unit_code,x.route_code,x.subroute_code) as "SUBROUTE_SEQNO",  x.subsubrt_code as "SUBSUBRT_CODE",x.subsubrt_name as "SUBSUBRT_NAME",x.subsubrt_oname as "SUBSUBRT_ONAME",dbo.cir_get_subsubroute_seqno(x.comp_code,x.unit_code,x.route_code,x.subroute_code,x.subsubrt_code) as "SUBSUBRT_SEQNO",  x.agcd as "AGCD",x.dpcd as "DPCD",x.agency_name as "AGENCY_NAME",x.agency_oname as "AGENCY_ONAME",x.city_name as "CITY_NAME",x.city_oname as "CITY_ONAME",x.station_name as "STATION_NAME" ,station_oname as "STATION_ONAME",x.distname as "DISTNAME",x.distoname as "DISTONAME",x.print_seq as "PRINT_SEQ", 0 as "TOTAL_PACKET",' + @vvar_sum + ',' + @vvar_sum1 + ' from(select a.comp_code comp_code,unit_code unit_code,a.route1 route_code,a.rtnm route_name,a.rtonm route_oname, a.subrt subroute_code,a.subrtnm subroute_name,a.subrtonm subroute_oname,  a.sub_subrt subsubrt_code,a.subsubrtnm subsubrt_name,a.subsubrtonm subsubrt_oname,  a.agcd agcd,a.dpcd dpcd,b.ag_name agency_name,b.ag_name_oth_lang agency_oname,a.city_name city_name,a.city_oname city_oname,a.station_name station_name,a.station_oname station_oname,a.distname distname,a.distoname distoname, max(a.lbl_print_no) print_seq,a.publ publ,a.edtn edtn,' + @vvar + '  from cir_lblmast a,cir_agmast b  where a.comp_code = b.comp_code and a.comp_code =' + '''' + @pcompcode + '''' + ' and a.unit_code = b.unit and a.unit_code =' + '''' + @punitcode + '''' + ' and  (a.publ =' + '''' + @ppublcode + '''' + ' or ' + '''' + @ppublcode + '''' + ' is null' + ' or ' +   '''' + @ppublcode + '''' +' = '''+ ''') and a.agcd = b.agcd and a.dpcd = b.dpcd  and a.lbl_dt =' + '''' + @vsupdate1 + '''' + ' and  a.route1+a.subrt+a.sub_subrt in (select route_code+subrt_code+sub_subrt_code from cir_sub_subroute_mast where comp_code =' + '''' + @pcompcode + '''' + ' and unit =' + '''' + @punitcode + '''' + ' and (route_code+subrt_code+sub_subrt_code =' + '''' + @proutecode + '''' + ' or' + '''' + @proutecode + '''' + ' is null' + ' or ' + '''' + @proutecode + '''' +' = '''+ ''') and  (sub_subrt_mode =' + '''' + @proutemode + '''' + ' or ' + '''' + @proutemode + '''' + ' is null'+ ' or ' + '''' + @proutemode + '''' +' = '''+ ''')) and isnull(a.supply_1,0)>0  group by a.comp_code,a.unit_code,a.route1,a.rtnm,a.rtonm,a.subrt,a.subrtnm,a.subrtonm,a.sub_subrt,a.subsubrtnm,a.subsubrtonm,a.publ,a.edtn,a.lbl_tno,a.agcd,a.dpcd,b.ag_name,b.ag_name_oth_lang,a.city_name,a.city_oname,a.station_name,a.station_oname,a.distname,a.distoname) x group by x.comp_code,x.unit_code,x.route_code,x.route_oname,x.route_name,x.subroute_code,x.subroute_name,x.subroute_oname,x.subsubrt_code,x.subsubrt_name,x.subsubrt_oname,  x.agcd,dpcd,x.print_seq,x.agency_name,x.agency_oname,x.city_name,x.city_oname,x.station_name,x.station_oname,x.distname,x.distoname  order by route_seqno,route_name,subroute_seqno,subroute_name,subsubrt_seqno,subsubrt_name,print_seq,agency_name' 
				END
				ELSE BEGIN 
					print('12')
					SET @vquery  = 'select x.comp_code as "COMP_CODE",unit_code as "UNIT_CODE",route_code as "ROUTE_CODE",x.route_name as "ROUTE_NAME",x.route_oname as "ROUTE_ONAME",dbo.cir_get_route_seqno(x.comp_code,x.unit_code,x.route_code) as "ROUTE_SEQNO", x.subroute_code  as "SUBROUTE_CODE",x.subroute_name as "SUBROUTE_NAME",x.subroute_oname as "SUBROUTE_ONAME",dbo.cir_get_subroute_seqno(x.comp_code,x.unit_code,x.route_code,x.subroute_code) as "SUBROUTE_SEQNO",  x.subsubrt_code as "SUBSUBRT_CODE",x.subsubrt_name as "SUBSUBRT_NAME",x.subsubrt_oname as "SUBSUBRT_ONAME",dbo.cir_get_subsubroute_seqno(x.comp_code,x.unit_code,x.route_code,x.subroute_code,x.subsubrt_code) as "SUBSUBRT_SEQNO",,  x.agcd as "AGCD",x.dpcd as "DPCD",x.agency_name as "AGENCY_NAME",x.agency_oname as "AGENCY_ONAME",x.city_name as "CITY_NAME",x.city_oname as "CITY_ONAME",x.station_name as "STATION_NAME" ,station_oname as "STATION_ONAME",x.distname as "DISTNAME",x.distoname as "DISTONAME",x.print_seq as "PRINT_SEQ", 0 as "TOTAL_PACKET",' + @vvar_sum + ',' + @vvar_sum1 + ' from(select a.comp_code comp_code,unit_code unit_code,a.route1 route_code,a.rtnm route_name,a.rtonm route_oname,  a.subrt subroute_code,a.subrtnm subroute_name,a.subrtonm subroute_oname, a.sub_subrt subsubrt_code,a.subsubrtnm subsubrt_name,a.subsubrtonm subsubrt_oname,  a.agcd agcd,a.dpcd dpcd,b.ag_name agency_name,b.ag_name_oth_lang agency_oname,a.city_name city_name,a.city_oname city_oname,a.station_name station_name,a.station_oname station_oname,a.distname distname,a.distoname distoname,  max(a.lbl_print_no) print_seq,a.publ publ,a.edtn edtn,' + @vvar + ' from cir_lblmast a,cir_agmast b   where a.comp_code = b.comp_code and a.comp_code =' + '''' + @pcompcode + '''' + ' and a.unit_code = b.unit and a.unit_code =' + '''' + @punitcode + '''' + ' and  (a.publ =' + '''' + @ppublcode + '''' + ' or ' + '''' + @ppublcode + '''' + ' is null' + ' or ' +   '''' + @ppublcode + '''' +' = '''+ ''') and a.agcd = b.agcd and a.dpcd = b.dpcd  and a.lbl_dt =' + '''' + @vsupdate1 + '''' + ' and  a.route1+a.subrt+a.sub_subrt in (select route_code+subrt_code+sub_subrt_code from cir_sub_subroute_mast where comp_code =' + '''' + @pcompcode + '''' + ' and unit =' + '''' + @punitcode + '''' + ' and (route_code+subrt_code+sub_subrt_code =' + '''' + @proutecode + '''' + ' or' + '''' + @proutecode + '''' + ' is null' + ' or ' + '''' + @proutecode + '''' +' = '''+ ''') and  (sub_subrt_mode =' + '''' + @proutemode + '''' + ' or ' + '''' + @proutemode + '''' + ' is null'+ ' or ' + '''' + @proutemode + '''' +' = '''+ ''')) and isnull(a.supply_1,0)>0  group by a.comp_code,a.unit_code,a.route1,a.rtnm,a.rtonm,a.subrt,a.subrtnm,a.subrtonm,a.sub_subrt,a.subsubrtnm,a.subsubrtonm,a.publ,a.edtn,/*a.supply_1,*/a.agcd,a.dpcd,b.ag_name,b.ag_name_oth_lang,a.city_name,a.city_oname,a.station_name,a.station_oname,a.distname,a.distoname) x group by x.comp_code,x.unit_code,x.route_code,x.route_oname,x.route_name,x.subroute_code,x.subroute_name,x.subroute_oname,x.subsubrt_code,x.subsubrt_name,x.subsubrt_oname,  x.agcd,x.dpcd,x.print_seq,x.agency_name,x.agency_oname,x.city_name,x.city_oname,x.station_name,x.station_oname,x.distname,x.distoname  order by route_seqno,route_name,subroute_seqno,subroute_name,subsubrt_seqno,subsubrt_name,print_seq,agency_name' 
				END
   			END
   		END
   
		--insert into test1(vstring,vstring2) values('2 '+vquery,null);commit;
		print(@vquery)
		EXEC (@vquery)
		DEALLOCATE cur_edtn
End

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE cir_gen_lbl_cir_gen_lbl_p
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@ppubl_code                               VARCHAR(20) ,
	@pedtn_code                               VARCHAR(20) ,
	@proute_code                              VARCHAR(20) ,
	@pagcd                                    VARCHAR(20) ,
	@pdpcd                                    VARCHAR(20) ,
	@psupdate                                 datetime ,
	@ppkt_size                                int ,
	@padjust_copy                             int ,
	@pperiod                                  int ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,--it is used for lable type ---Combined(C)/Supply Type Wise(S)
	@pextra2                                  VARCHAR(4000)  --for sub edition
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


	SET @vsupdate  = @psupdate
	
	DELETE FROM   cir_lblmast WHERE  comp_code  = @pcomp_code AND unit_code  = @punit_code AND	lbl_dt  = @vsupdate
	AND	(publ  = @ppubl_code OR	@ppubl_code  is null OR @ppubl_code='') AND (edtn  = @pextra2 OR @pextra2  is null OR @pextra2='')
	AND	publ  in(SELECT DISTINCT publ FROM  cir_publ_mast WHERE	 comp_code  = @pcomp_code AND (publ  = @ppubl_code OR @ppubl_code is null OR @ppubl_code='') AND period  = @pperiod) 
		
	DECLARE sup_cur cursor LOCAL FOR 
	SELECT DISTINCT d.comp_code comp_code, d.unit_code unit_code, d.publ publ, d.edtn edtn, d.route_code route_code, d.subroute_code subroute_code,
	d.subsubroute_code subsubroute_code, d.supdate supdate, d.agcd agcd, d.dpcd dpcd, d.agency_ty_code agency_ty_code,
	SUM(CONVERT(int, ISNULL(d.sup_copy, 0))) as rsup, d.sup_rate, 
	DBO.cir_get_supply_seqno(d.comp_code, d.unit_code, d.publ, d.edtn, d.agcd, d.dpcd) supply_seqno,
	DBO.cir_get_route_seqno(d.comp_code, d.unit_code, d.route_code) route_seqno, 
	DBO.cir_get_edtn_seqno(d.comp_code, d.edtn) edtn_seqno,
	DBO.cir_get_dist_seqno(d.comp_code, m.dist_code) dist_seqno, 
	m.dist_code dist_code, m.print_seq print_seq
	FROM  cir_dbksup d, cir_agmast m 
	WHERE d.comp_code  = @pcomp_code AND	d.comp_code  = m.comp_code AND	d.unit_code  = @punit_code AND	d.unit_code  = m.unit
	AND	d.supdate  = @vsupdate AND	d.edtn  in
	(SELECT DISTINCT edtn FROM  cir_edtn_mast WHERE	 comp_code  = d.comp_code AND	publ  = d.publ AND	edtn  = d.edtn AND (edtn=@pextra2 OR @pextra2 IS NULL OR @pextra2='')
	AND	((ISNULL(main_edtn, edtn)  = @pedtn_code) OR	(@pedtn_code  is null)))
	AND	d.publ  in(SELECT DISTINCT publ	FROM  cir_publ_mast WHERE	 comp_code  = d.comp_code AND	(publ  = @ppubl_code
	OR	@ppubl_code  is null) AND	period  = @pperiod)
	AND	d.agcd  = m.agcd AND	d.dpcd  = m.dpcd AND	ISNULL(m.print_label, 'N')  = 'Y' AND	(d.agcd  = @pagcd
	OR	@pagcd  is null or @pagcd='''') AND	(d.dpcd  = @pdpcd OR	@pdpcd  is null or @pdpcd='''') AND	ISNULL(d.sup_copy, 0)  > 0 AND	(route_code  = @proute_code OR	@proute_code  is null)
	GROUP BY d.comp_code, d.unit_code, d.publ, d.edtn, d.route_code, d.subroute_code, d.subsubroute_code, d.supdate,
	d.agcd, d.dpcd, d.agency_ty_code, d.sup_rate, m.dist_code, m.print_seq 
	ORDER BY d.comp_code,d.unit_code,d.publ,edtn_seqno,d.edtn,route_seqno,d.route_code,supply_seqno,m.print_seq,d.agcd,d.dpcd


	OPEN sup_cur 
			
		fetch NEXT FROM sup_cur INTO @vcomp_code1 ,@vunit_code1 ,@vpubl1 , @vedtn1 ,@vroute_code1, @vsubroute_code1, @vsubsubroute_code1 , @vsupdate1 , @vagcd1 , @vdpcd1 , @vagency_ty_code1 ,
	        @vrsup1 , @vsup_rate1,@vsupply_seqno1 , @vroute_seqno1, @vedtn_seqno1 ,@vdist_seqno1, @vdist_code1, @vprint_seq1 

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

		IF ISNULL(@vpacket_size5, 0)<= 0  BEGIN 
				SET @vpacket_size  = ISNULL(@ppkt_size, 0)
			END
		ELSE BEGIN 
				SET @vpacket_size  = ISNULL(@vpacket_size5, 0)
			END
			   
			IF (@pperiod = 7) BEGIN 
					SET @curr_agcd  = @vagcd1 +  @vdpcd1 
				END
			ELSE BEGIN 
					SET @curr_agcd  =  @vagcd1 +  @vdpcd1 +  @vedtn1 +  @vdist_seqno1
				END
			   
				IF (@curr_agcd <> @prev_agcd) BEGIN 
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
					SET @t_rtnm1 = DBO.cir_get_name_cir_route(@pcomp_code, @punit_code, @mroute,'1',NULL,NULL,NULL)
					SET @t_hrtnm = DBO.cir_get_name_cir_route(@pcomp_code, @punit_code, @mroute,'2',NULL,NULL,NULL)
					/*************************        changes for split a string value       *****************************/                                        
										
					SET @msubrt  =  @vsubroute_code1 

					SET @t_subrtnm  = DBO.cir_get_subroute_name(@pcomp_code, @punit_code, @vroute_code1,@vsubroute_code1)
					SET @t_subrtonm  =dbo.cir_get_name_cir_subroute(@pcomp_code,@punit_code,@vroute_code1,@vsubroute_code1,2,@pdateformat,null,null) 
					SET @msubsubrt  =  @vsubsubroute_code1


					SET @t_subsubrtnm	= DBO.cir_get_sub_subroute_name(@pcomp_code, @punit_code,@vroute_code1, @vsubsubroute_code1, @vsubsubroute_code1)
					SET @t_subsubrtonm	=	dbo.cir_get_name_cir_subsubroute(@pcomp_code,@punit_code,@vroute_code1,@vsubroute_code1, @vsubsubroute_code1,2,@pdateformat,null,null) 
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
						
						fetch NEXT FROM sum_week_cur INTO 
											@vsup_1, @vsup_2, @vsup_3, 
											@vsup_4
						
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
			   
									IF @vpubl_4 is null 
									BEGIN 
											SET @vpubl_4  = @current_publ_4 
									END
			   
									UPDATE  cir_lblmast   
									SET	supply_1 = ISNULL(supply_1, 0) + @vsup_1,	 supply_2 = ISNULL(supply_2, 0) + @vsup_2,	
									supply_3 = ISNULL(supply_3, 0) + @vsup_3,	supply_4 = ISNULL(supply_4, 0) + @vsup_4,	
									publ_1 = @vpubl_1,	 publ_2 = @vpubl_2,	 publ_3 = @vpubl_3,	 publ_4 = @vpubl_4 
									WHERE  comp_code  = @pcomp_code AND	unit_code  = @punit_code AND	lbl_dt  = @vsupdate
									AND	agcd + dpcd  = @prev_agcd AND	((edtn  = @pedtn_code) OR	(@pedtn_code  is null))
									AND	seq_no  = @vseq_no - 1 /*week_dl = :week_daily and */ 

									IF (@@FETCH_STATUS = 0) 
									BEGIN 
												DELETE FROM   cir_lblmast    WHERE  comp_code  = @pcomp_code AND	unit_code  = @punit_code
												AND	lbl_dt  = @vsupdate AND	agcd + dpcd  = @prev_agcd AND	seq_no  = @vseq_no /*and (FEDN=pedtn_code OR pedtn_code is null)*/ 
												
												SET @vseq_no  = ISNULL(@vseq_no, 0)- 1 
												SET @count_lbl  = ISNULL(@count_lbl, 0)- 1 
									END
   
								END
								ELSE
								BEGIN 
									UPDATE  cir_lblmast SET	supply_1 = ISNULL(supply_1, 0) + ISNULL(@vsup_1, 0), supply_2 = ISNULL(supply_2, 0) + ISNULL(@vsup_2, 0),	
									supply_3 = ISNULL(supply_3, 0) + ISNULL(@vsup_3, 0), supply_4 = ISNULL(supply_4, 0) + ISNULL(@vsup_4, 0) 
									WHERE  comp_code  = @pcomp_code AND	unit_code  = @punit_code AND	lbl_dt  = @vsupdate AND	agcd + dpcd  = @prev_agcd
									AND	seq_no  = ISNULL(@vseq_no, 0) - 1 /*and (FEDN=pedtn_code OR pedtn_code IS NULL)*/ 
									
									IF (@@FETCH_STATUS = 0) 
									BEGIN 
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
						EXEC cir_gen_lbl_ad_lblmst  @vagcd1 , @vdpcd1 , @vedtn1  ,  @mroute  ,  @msubrt  ,  @msubsubrt  ,  @mname  ,  @mhname  ,  @mastn  ,  @vsupdate  ,  @t_rtnm1  ,  @t_hrtnm  ,  '1'  ,  '1'  ,  'PIN   '  ,  null  ,  null  ,  @FunctionInExec  ,  0  ,  0  ,  @FunctionInExec_1  ,  @v_alert_text  ,  0  ,  0  ,  @FunctionInExec_2  ,  @mlblln7  ,  null  ,  null  ,  null  ,  null  ,  1  ,  null  ,  @vcoag  ,  @vcodp  ,  @vagty  ,  @pperiod  ,  @route_print_slno  ,  @astn_print_slno  ,  @mlblty  ,  @punit_code  ,  @pcomp_code  ,  @t_subrtnm  ,  @t_subrtonm  ,  @t_subsubrtnm  ,  @t_subsubrtonm  ,  @vcity_oname  ,  @vstation_name  ,  @vstation_oname  ,  @FunctionInExec_3  , @vsup_rate1 ,  @vpin_open_in  ,  @v_lbl_printno  ,  @vdist_seqno  ,   @vdist_code1,@v_unpaid_copy,@taluka_name
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
					UPDATE  cir_lblmast SET lbl_tno = @count_lbl WHERE  comp_code  = @pcomp_code AND	unit_code  = @punit_code
					AND	lbl_dt  = @vsupdate AND	agcd + dpcd  = @prev_agcd AND	((edtn  = @pedtn_code) OR	(@pedtn_code  is null)) 
					
				END
				ELSE BEGIN 
					UPDATE  cir_lblmast   SET	lbl_tno = ISNULL(@count_lbl, 0) WHERE  comp_code  = @pcomp_code AND	unit_code  = @punit_code
					AND	lbl_dt  = @vsupdate AND	agcd + dpcd  = @prev_agcd AND	((edtn  = @pedtn_code) OR	(@pedtn_code  is null)) 
					
				END
   
				SET @count_pub  = 1 
				SET @count_lbl  = 0 
				SET @bal_sup  =  @vrsup1

 
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

					IF @bal_sup <= @padjust_copy BEGIN 
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
                    if isnull(@v_unpaid_bal,0)>@actual_sup  begin  
                       set @v_unpaid_bal    =@v_unpaid_bal-@actual_sup
                       set @v_unpaid_copy   =@actual_sup;
                    end
                    else begin
                        set @v_unpaid_copy   =@v_unpaid_bal;
                        set @v_unpaid_bal    =0;
                    end 
                  end                      
                 else begin
					set @v_unpaid_copy=0;
					set @v_unpaid_bal =0;
                 end
                  

		print(@vdist_code1)
		EXEC cir_gen_lbl_ad_lblmst  @vagcd1 ,  @vdpcd1 , @vedtn1 ,  @mroute  ,  @msubrt  ,  @msubsubrt  ,  @mname  ,  @mhname  ,  @mastn  ,  @vsupdate  ,  @t_rtnm1  ,  @t_hrtnm  ,  @count_lbl  ,  1  ,  @vmessage  ,  null  ,  null  ,  @FunctionInExec_4  ,  0  ,  0  ,  @FunctionInExec_5  ,  0  ,  0  ,  0  ,  @FunctionInExec_6  ,  @mlblln7  ,  @vpubl1  ,  @vedtn1  ,  @actual_sup  ,  @vseq_no  ,  @count_pub  ,  @vpubl1 ,  @vcoag  ,  @vcodp  ,  @vagty  ,  @pperiod  ,  @route_print_slno  ,  @astn_print_slno  ,  @mlblty  ,  @punit_code  ,  @pcomp_code  ,  @t_subrtnm  ,  @t_subrtonm  ,  @t_subsubrtnm  ,  @t_subsubrtonm  ,  @vcity_oname  ,  @vstation_name  ,  @vstation_oname  ,  @FunctionInExec_7  ,  @vsup_rate1 ,  @vpin_open_in  ,  @v_lbl_printno  ,  @vdist_seqno  ,  @vdist_code1,@v_unpaid_copy,@taluka_name
 
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
				IF @bal_sup <= @padjust_copy BEGIN 
					SET @actual_sup  = @actual_sup + @bal_sup 
					SET @bal_sup  = 0 
				END
								   
			END
			ELSE BEGIN 
				SET @actual_sup  = @bal_sup 
				SET @bal_sup  = 0 
			END
								   
			IF @consumed_sup < ISNULL(@pktsize, 0) BEGIN 
                                                              
				EXEC cir_gen_lbl_update_rec @pcomp_code  ,  @punit_code  ,  @vpubl1  ,   @vedtn1  ,  @vsupdate  ,  @actual_sup  ,  @count_pub  ,  @vseq_no 
																	
			END
			ELSE BEGIN 
			IF @bal_pktsize = 0 BEGIN 
				IF @bal_sup > ISNULL(@pktsize, 0) BEGIN 
					SET @actual_sup  = ISNULL(@pktsize, 0)
					SET @bal_sup  = @bal_sup - ISNULL(@pktsize, 0)
					IF @bal_sup <= @padjust_copy BEGIN 
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
			EXEC cir_gen_lbl_ad_lblmst  @vagcd1  ,  @vdpcd1 , @vedtn1 ,  @mroute  ,  @msubrt  ,  @msubsubrt  ,  @mname  ,  @mhname  ,  @mastn  ,  @vsupdate  ,  @t_rtnm1  ,  @t_hrtnm  ,  @count_lbl  ,  null  ,  @vmessage  ,  null  ,  null  ,  @FunctionInExec_8  ,  0  ,  0  ,  @FunctionInExec_9  ,  @v_alert_text  ,  0  ,  0  ,  @FunctionInExec_10  ,  @mlblln7  ,  @vpubl1 , @vedtn1,  @actual_sup  ,  @vseq_no  ,  @count_pub  ,@vpubl1 ,  @vcoag  ,  @vcodp  ,  @vagty  ,  @pperiod  ,  @route_print_slno  ,  @astn_print_slno  ,  @mlblty  ,  @punit_code  ,  @pcomp_code  ,  @t_subrtnm  ,  @t_subrtonm  ,  @t_subsubrtnm  ,  @t_subsubrtonm  ,  @vcity_oname  ,  @vstation_name  ,  @vstation_oname  ,  @FunctionInExec_11  ,   @vsup_rate1 ,  @vpin_open_in  ,  @v_lbl_printno  ,  @vdist_seqno  ,@vdist_code1,@v_unpaid_copy,@taluka_name
		END
	END 
	END


   
			IF @pperiod = 7 BEGIN 
				SET @prev_agcd  =@vagcd1 +  @vdpcd1
			END
			ELSE BEGIN 
				SET @prev_agcd  =  @vagcd1 +  @vdpcd1 +  @vedtn1 +   @vdist_seqno1
			END
   
			SET @v_lbl_printno  = 1 
		
			fetch NEXT FROM sup_cur INTO @vcomp_code1 ,@vunit_code1 ,@vpubl1 , @vedtn1 ,@vroute_code1, @vsubroute_code1, @vsubsubroute_code1 , @vsupdate1 , @vagcd1 , @vdpcd1 , @vagency_ty_code1 ,
			@vrsup1 , @vsup_rate1,@vsupply_seqno1 , @vroute_seqno1, @vedtn_seqno1 ,@vdist_seqno1, @vdist_code1, @vprint_seq1 

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

 DEALLOCATE c_route

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


                                                                     
                                                                     
                                                                     
                                             
ALTER FUNCTION cir_get_sub_subroute
(@pcomp_code                               VARCHAR(20) ,
 @punit_code                               VARCHAR(20) ,
 @proute_code                              VARCHAR(20) ,
 @psubrt_code                              VARCHAR(20) ,
 @psubsubrt_code                           VARCHAR(20))
RETURNS VARCHAR(200) 
AS 
BEGIN
		
	DECLARE @vsubsubrt_name			VARCHAR (400) 
	DECLARE @psubsubrt_oname        VARCHAR (400)

	SELECT
		 @vsubsubrt_name  =  sub_subrt_name,
		 @psubsubrt_oname  =  ISNULL(sub_subrt_name_oth_lang, '')
	FROM  cir_sub_subroute_mast 
	WHERE	 comp_code  = @pcomp_code
	AND	unit  = @punit_code
	AND	route_code  = @proute_code
	AND	subrt_code  = @psubrt_code
	AND	sub_subrt_code  = @psubsubrt_code
		

set @vsubsubrt_name = ISNULL(@vsubsubrt_name, '') 
set @psubsubrt_oname = ISNULL(@psubsubrt_oname, '') 

declare @comb_value11     varchar(1000)


set @comb_value11 = @vsubsubrt_name + ',' + @psubsubrt_oname
		
return @comb_value11

END



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                                                                     
                                                                     
                                                                     
                                             
ALTER  FUNCTION cir_get_sub_subroute_name(
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


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                     
                                                                     
                                                                     
                                             
ALTER  FUNCTION cir_get_subroute_name(
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


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                     
                                                                     
                                                                     
                                             
ALTER FUNCTION cir_get_sub_subroute
(@pcomp_code                               VARCHAR(20) ,
 @punit_code                               VARCHAR(20) ,
 @proute_code                              VARCHAR(20) ,
 @psubrt_code                              VARCHAR(20) ,
 @psubsubrt_code                           VARCHAR(20))
RETURNS VARCHAR(200) 
AS 
BEGIN
		
	DECLARE @vsubsubrt_name			VARCHAR (400) 
	DECLARE @psubsubrt_oname        VARCHAR (400)

	SELECT
		 @vsubsubrt_name  =  sub_subrt_name,
		 @psubsubrt_oname  =  ISNULL(sub_subrt_name_oth_lang, '')
	FROM  cir_sub_subroute_mast 
	WHERE	 comp_code  = @pcomp_code
	AND	unit  = @punit_code
	AND	route_code  = @proute_code
	AND	subrt_code  = @psubrt_code
	AND	sub_subrt_code  = @psubsubrt_code
		

set @vsubsubrt_name = ISNULL(@vsubsubrt_name, '') 
set @psubsubrt_oname = ISNULL(@psubsubrt_oname, '') 

declare @comb_value11     varchar(1000)


set @comb_value11 = @vsubsubrt_name + ',' + @psubsubrt_oname
		
return @comb_value11

END

///////////////////////////////////////////////////////END procedures for challan report//////////////////////////////////////////////////////////////////









