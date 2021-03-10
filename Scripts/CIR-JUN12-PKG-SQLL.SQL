
////////////////add by Deepika  07/06/2012 Sent by Amit sir///////////////////////////////////////////

ALTER PROCEDURE [dbo].[cir_ledger_ageing]   
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
@pdateformat varchar(20),
@puserid varchar(20),
@pextra1 varchar(20),
@pextra2 varchar(20),
@pextra3 varchar(30),
@pextra4 varchar(30),
@pextra5 varchar(50)
As
 
--------- slabs end 
declare  @ptill_days1 as varchar(20)
declare  @ptill_days2 as varchar(20)
declare  @ptill_days3 as varchar(30)
declare  @ptill_days4 as varchar(30)
declare  @ptill_days5 as varchar(50)
declare  @ptill_days6 as varchar(50)
declare  @ptill_current as varchar(50)
  --------------  slabs  
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
declare  @v_amtcur   as numeric(14,2);


declare  @debit_amt_030  as  numeric(14,2)  --debit amt  for slab  1 days
declare  @debit_amt_3160 as  numeric(14,2)  --debit amt  for slab  2 days
declare  @debit_amt_6190 as  numeric(14,2)  --debit amt  for slab  3 days
declare  @debit_amt_91120 as numeric(14,2)  --debit amt  for slab  4 days
declare  @debit_amt_121180  as  numeric(14,2)  --debit amt  for >slab 5 days
declare  @debit_amt_181  as  numeric(14,2)  --debit amt  for >slab 6 days
declare  @debit_amt_cur  as  numeric(14,2)  --debit amt  for >current

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
  CUR_AMT        NUMERIC(14,2),
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



set @debit_amt_030  =0  --debit amt  for slab  1 days
set @debit_amt_3160  =0  --debit amt  for slab  2 days
set  @debit_amt_6190  =0  --debit amt  for slab  3 days
set   @debit_amt_91120  =0 --debit amt  for slab  4 days
set   @debit_amt_121180   =0  --debit amt  for >slab 4 days
set   @debit_amt_181   =0  --debit amt  for >slab 4 days
set   @debit_amt_cur   =0  --debit amt  for >current
set   @bill_pending_amt  =0
set   @rcpt_pending_amt  =0  --pending receipt amount

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

	select @rec_agency_comp_code=m.Comp_Code ,@rec_agency_agcd=m.agcd ,@rec_agency_dpcd=m.dpcd 
	,@rec_agency_agency_name=m.ag_name ,@rec_agency_city_code=m.City_Code
	,@rec_agency_city_name=c.city_name,@rec_agency_credit_days=m.credit_days
	,@rec_agency_branch_name=m.branch_code,@rec_agency_ageing_type=m.ageing_type
	from cir_agmast m,cir_city_mast c
	where m.comp_code=c.comp_code and m.comp_code=@pcomp_code 
	and m.unit=@punit_code and m.city_code=c.city_code 			
	and (m.Dist_Code=@pdist_code or @pdist_code is null or @pdist_code ='') 
	and (m.tehsil_taluka=@ptaluka_code or @ptaluka_code is null or @ptaluka_code ='') 
	and (m.agcd=@pag_main_code or @pag_main_code is null or @pag_main_code ='') 
	and (m.dpcd=@pag_sub_code or @pag_sub_code is null or @pag_sub_code ='')


set @pdebitupto_date =@pasondt
set @pcreditupto_date =@pasondt


declare @day as int
print('gaurav')
print(@rec_agency_ageing_type)
print(@pasondt)
print(dbo.GetLastDayOfMonth(@pasondt))
print('debug')
if upper(@rec_agency_ageing_type) = 'D' 
begin
	set @vtodt=dateadd(dd,-1,@pasondt)
end
else if upper(@rec_agency_ageing_type) = 'W' 
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
	declare cur_agency cursor for
			select publ from cir_supply where comp_code=@pcomp_code and agcd=@pag_main_code and dpcd=@pag_sub_code
			order by publ
			
		
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
open cur_agency
		fetch NEXT FROM cur_agency INTO @fetch_pub
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN
			
			select distinct @fetch_protype=pro_type,@fetch_pubname=PUBL_NAME,@fetch_protype=
			(Select pubname from pub_type_mast where Comp_Code=@pcomp_code and pub_type_mast.pubtypecode=CIR_PUBL_MAST.PRO_TYPE)
			from CIR_PUBL_MAST where COMP_CODE=@pcomp_code and publ=@fetch_pub
			select @ptill_days1=SLAB_TILL1,@ptill_days2=SLAB_TILL2,@ptill_days3=SLAB_TILL3,@ptill_days4=SLAB_TILL4
			,@ptill_days5=SLAB_TILL5,@ptill_days6=SLAB_TILL6 from CIR_AGEING_SLAB_MAST 
			where COMP_CODE=@pcomp_code and AGEING_TYPE=@rec_agency_ageing_type and PRO_TYPE=@fetch_protype
			

			
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
					agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
					billdt<=@vtodt and isnull(amount,0)>0
					group by comp_code,billno,billdt
					union
					select distinct recptno billno,recptdt billdt,sum(amount) bill_amt from cir_outmast
					where comp_code=@pcomp_code and unit_code=@punit_code and
					agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd  and publ=@fetch_pub and
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
										  agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
										  billno=@v_bill_billno and billdt=@v_bill_billdt and 
										  recptdt<=@vasondt and amount<0

									set @v_amt030 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt030,0);
									set @debit_amt_030 =isnull(@debit_amt_030,0)+isnull(@v_amt030,0)
								end
								else if @v_days between isnull(@ptill_days1,0)+1 and @ptill_days2 begin
									select @v_amt3160=sum(amount) from cir_outmast 
									where comp_code=@pcomp_code and unit_code=@punit_code and
										  agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
										  billno=@v_bill_billno and billdt=@v_bill_billdt and 
										  recptdt<=@vasondt and amount<0
									--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
									set @v_amt3160 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt3160,0);
									set @debit_amt_3160 =isnull(@debit_amt_3160,0)+isnull(@v_amt3160,0)
								end
								else if @v_days between isnull(@ptill_days2,0)+1 and @ptill_days3 begin
									select @v_amt6190=sum(amount) from cir_outmast 
									where comp_code=@pcomp_code and unit_code=@punit_code and
										  agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
										  billno=@v_bill_billno and billdt=@v_bill_billdt and 
										  recptdt<=@vasondt and amount<0
									--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
									set @v_amt6190 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt6190,0);
									set @debit_amt_6190 =isnull(@debit_amt_6190,0)+isnull(@v_amt6190,0)
								end
								else if @v_days between isnull(@ptill_days3,0)+1 and @ptill_days4 begin
									select @v_amt91120=sum(amount) from cir_outmast 
									where comp_code=@pcomp_code and unit_code=@punit_code and
										  agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
										  billno=@v_bill_billno and billdt=@v_bill_billdt and 
										  recptdt<=@vasondt and amount<0
									--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
									set @v_amt91120 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt91120,0);
									set @debit_amt_91120 =isnull(@debit_amt_91120,0)+isnull(@v_amt91120,0)
								end  
								else if @v_days between isnull(@ptill_days4,0)+1 and @ptill_days5 begin
									select @v_amt121180=sum(amount) from cir_outmast 
									where comp_code=@pcomp_code and unit_code=@punit_code and
										  agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
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
										  agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
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
		agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
		billdt between @cur_from_dt and @pasondt  
		and RECPTNO is null and RECPTDT is null
		--and recptdt<=@pasondt and amount<0
		
		
		select @v_pending_rcpt_amt=sum(amount) from cir_outmast 
        where comp_code=@pcomp_code and unit_code=@punit_code and
          agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
          (billno is null or billdt>@pcreditupto_date) and 
          recptdt<=@pcreditupto_date and 
          doctyp+recptno+cast(recptdt as varchar) not in 
          (select distinct doctyp+recptno+cast(recptdt as varchar) from ad_outstand
           where comp_code=@pcomp_code and unit_code=@punit_code and
                 agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
                 recptdt<=@vtodt and isnull(amount,0)<0 and billno IS NULL)
	
		set @v_amt=isnull(@v_amtcur,0)+ isnull(@debit_amt_030,0)+isnull(@debit_amt_3160,0)+isnull(@debit_amt_6190,0)+isnull(@debit_amt_91120,0)+isnull(@debit_amt_121180,0)+isnull(@debit_amt_181,0)

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
                city_name,pending_amt,CUR_AMT, SLAB_1 ,slab_2,slab_3,slab_4,slab_5,
                slab_6,rect_pending,on_acamt,sessionid)
        values (@rec_agency_comp_code,@punit_code,@rec_agency_agcd, @rec_agency_dpcd, @fetch_protype,
               @fetch_pubname,isnull(@bill_pending_amt,0),isnull(@v_amtcur,0),isnull(@debit_amt_030,0),isnull(@debit_amt_3160,0), isnull(@debit_amt_6190,0), isnull(@debit_amt_121180,0), isnull(@debit_amt_181,0),
               0,isnull(@rcpt_pending_amt,0),0,@@spid);
		print('xxx')
		fetch NEXT FROM cur_agency INTO @fetch_pub
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

select comp_code,unit_code,agcd,dpcd,ag_name PRO_TYPE,city_name PUBL_NAME,pending_amt,cur_amt,slab_1,slab_2,slab_3,slab_4,slab_5,
slab_6,rect_pending from #cir_temp_ageing  --
 order by ag_name;
 
drop table #cir_temp_ageing


/////////////////////////next


ALTER procedure [dbo].[agency_reason_close_p] (
    @pcompcode    varchar(8),
    @pdateformat  varchar(20),
    @pextra1      varchar(20),
    @pextra2      varchar(20)
   )
       
   

AS
   declare @vno varchar(50)
	declare @vtype_code 	varchar(15)
	declare @v_sess_id numeric(18,0) 
declare @ptype_code varchar(200)
select @v_sess_id=@@spid
 select  @vno=max(substring(REASON_CODE,3,5))+1  from cir_ag_close_reason where comp_code=@pcompcode
If ISNULL(@vno,0)=0 
begin

  	set @vtype_code='CR'+'001'
end
 	Else
begin
declare @vlen int
set @vlen=len(@vno)
if(@vlen=1)
begin
set @vno='00'+@vno
end
if(@vlen=2)
begin
set @vno='0'+@vno
end

    set @vtype_code='CR'+@vno
 	End
create table #package1 (var_code varchar (100),vsessionid varchar (100))
 delete from #package1 where vsessionid=@v_sess_id
  insert into #package1(var_code,vsessionid) values(@vtype_code,@v_sess_id)
 select var_code as "VAR_CODE",vsessionid  from #package1  where vsessionid=@v_sess_id



////////////////////////////////////////////////end////////////////////////////////////////////////////////////////


//////////////////////////add by Deepika  08/06/2012 sent by Amit sir///////////////////////////////////////////////////////


create function [dbo].[getlableformate]
(
	@compcode as varchar(8),
	@pub_cent as varchar(8),
	@extra1 as varchar(10),
	@extra2 as varchar(10)) returns varchar(5)
As
	begin
	declare @lable_formate as varchar(5)
	
		select @lable_formate=cir_lable_print from Pub_Cent_Mast where Comp_Code=@compcode
		and Pub_cent_Code=@pub_cent 
		
	return(@lable_formate)
	end

///////////////////////////////////////////end/////////////////////////////////////

******************************** Rikkee Garg 9/6/12***************************



ALTER PROCEDURE [dbo].[cir_billing_p]
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
	DECLARE @agency_rec_agcd		varchar(20)
	DECLARE @agency_rec_dpcd		varchar(20)
	DECLARE @agency_rec_route_code	varchar(20)
	
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
	
	declare @v_bill_exist	numeric(10)
	declare @v_vat_allow    varchar(1);
	declare @v_tax_calc_type    varchar(1);
	declare @v_tax_amt      numeric(15,2);
	declare @v_tax_prate    numeric(15,3);   
	declare @v_tax_frate    numeric(15,3);

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
    
    select @vbill_publwise=cir_bill_publwise,@v_vat_allow=cir_vat_allow from preferrences where "comp_code"=@pcomp_code

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
			m.ag_name ag_name,m.print_seq print_seqno,@vrec_publ agbill_publ,
			a.acc_agcd acc_agcd,a.acc_dpcd acc_dpcd,a.route_code route_code
			from
			(select distinct a.comp_code,a.unit,a.bill_agcd,a.bill_dpcd,
			isnull(a.account_agcd,a.bill_agcd) acc_agcd,isnull(a.account_dpcd,a.bill_dpcd) acc_dpcd,
			max(s.route_code) route_code
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
			group by a.comp_code,a.unit,a.bill_agcd,a.bill_dpcd,
                isnull(a.account_agcd,a.bill_agcd),isnull(a.account_dpcd,a.bill_dpcd)) a,cir_agmast m
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
		fetch NEXT FROM agency_cur INTO @vcomp_code1 , @vunit1 ,@vbill_agcd1, @vbill_dpcd1 , @vbranch_code1, @vcity_name1, @vag_name1,@vprint_seqno1,@vagbill_publ1,@agency_rec_agcd,@agency_rec_dpcd,@agency_rec_route_code
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
					
					declare @rec_tax_tax_rate		numeric(15,3)
					declare @rec_tax_tax_calc_type	varchar(1)
					
					declare cur_tax cursor for
						select tax_rate,tax_calc_type from cir_tax_mast 
							where comp_code=@pcomp_code and tax_type_id=1 and tax_status='Y' and 
								valid_from=(select max(valid_from) from cir_tax_mast
								where comp_code=@pcomp_code and tax_type_id=1 and tax_status='Y' and 
								valid_from<=@ptodt);

                if @v_vat_allow='Y' begin
                    open cur_tax
                    fetch NEXT FROM cur_tax INTO @rec_tax_tax_rate,@rec_tax_tax_calc_type
						WHILE (@@FETCH_STATUS = 0) begin
                        if @rec_tax_tax_calc_type='P' begin
                            set @v_tax_amt	=isnull(@v_tax_amt,0)+round((isnull(@daily_net_amount,0)*isnull(@rec_tax_tax_rate,0))/100,2);
                            set @v_tax_prate=isnull(@v_tax_prate,0)+isnull(@rec_tax_tax_rate,0);
                            set @v_tax_calc_type=@rec_tax_tax_calc_type
                        end
                        else begin
                            set @v_tax_amt=isnull(@v_tax_amt,0)+round(isnull(@daily_net_amount,0)+isnull(@rec_tax_tax_rate,0),2);
                            set @v_tax_frate=isnull(@v_tax_frate,0)+isnull(@rec_tax_tax_rate,0);
                              set @v_tax_calc_type=@rec_tax_tax_calc_type
                        end
						fetch NEXT FROM cur_tax INTO @rec_tax_tax_rate,@rec_tax_tax_calc_type
                    end
                    close cur_tax
                end
                else begin
                    set @v_tax_amt   =0;
                    set @v_tax_prate =0;
                    set @v_tax_frate =0;
                end

					INSERT INTO  cir_bill(comp_code , unit_code ,billno , 	billdt , agcd , dpcd , publ , bill_copy , gross_amount , 
					sur_amount , comm_amount, bill_amount , bill_frdt ,bill_todt , bill_flag , bill_remark , userid , creation_date , bill_sec_amt , branch_code,sec_per_rate,
					route_code,tax_rate,tax_amt,accagcd,accdpcd,tax_calc_type)
					VALUES (@vcomp_code1 , @vunit1 , @vbill_no , @v_billdt , @vbill_agcd1 , @vbill_dpcd1 ,@vpubl11 , isnull(@tot_copy, 0) , 
					isnull(@daily_gross_amount, 0)+isnull(@v_tax_amt, 0) , isnull(@tot_surcharge_amt, 0) , isnull(@vcomm_amt, 0) , @daily_net_amount , 
					@v_frdt , @v_todt , @pbill_freq , CAST(CONVERT(VARCHAR(23), @v_billdt) AS VARCHAR) + ' Billing' , @puserid , 
					GETDATE() , isnull(@v_bill_sec_amt, 0) , @v_bran_code,@v_agcd_sec_per,
					@agency_rec_route_code,isnull(@v_tax_prate,isnull(@v_tax_frate,0)),@v_tax_amt,@agency_rec_agcd,@agency_rec_dpcd,@v_tax_calc_type) 
					

					INSERT INTO  cir_outmast( comp_code , unit_code , agcd , dpcd , doctyp , billno , billdt , publ , amount , 
					remark , voucherno , usrid , creation_date , bill_sec_amt , branch_code )  
					VALUES ( @vcomp_code1 , @vunit1, @vbill_agcd1 , @vbill_dpcd1 , 'BIL' , @vbill_no , @v_billdt , @vpubl11 , 
					isnull(@daily_gross_amount, 0)+isnull(@v_tax_amt, 0) , CAST(CONVERT(VARCHAR(23), @v_billdt) AS VARCHAR) + ' Billing' , @vbill_no , @puserid , 
					GETDATE() , isnull(@v_bill_sec_amt, 0) , @v_bran_code )
					
					INSERT INTO  cir_bill_det   ( comp_code , unit_code , billno , billdt ,agcd , dpcd ,coag , 	codp , publ , edtn , 
					copy_rate , comm_flag , comm_rate , sur_rate , fromdt , todt , bill_copy , gross_amount , comm_amt , sur_amt , 
					bill_amount , bill_flag , branch_code,comm_type,accagcd,accdpcd )  
					SELECT comp_code, unit_code, @vbill_no billno, billdt, agcd, dpcd, agcd, dpcd, publ, edtn, copy_rate, comm_flag,
					comm_rate, sur_rate, MIN(fromdt) fromdt, MAX(todt) todt, SUM(bill_copy) bill_copy,
					SUM(CONVERT(FLOAT, gross_amount)) gross_amount,SUM(CONVERT(FLOAT, comm_amt)) comm_amt,SUM(CONVERT(FLOAT, sur_amt)) sur_amt,
					SUM(CONVERT(FLOAT, bill_amount)) bill_amount, @pbill_freq, @v_bran_code,comm_type,@agency_rec_agcd,@agency_rec_dpcd
					FROM  #cir_bill_det_temp 
					GROUP BY comp_code, unit_code, billdt, agcd, dpcd, publ, edtn, copy_rate, comm_flag, comm_rate,  sur_rate ,comm_type
					
					delete FROM  #cir_bill_det_temp;
					
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
						SET @v_tax_amt   =0
						SET @v_tax_prate =NULL
						SET @v_tax_frate =NULL
			    END
   
			fetch NEXT FROM agency_cur INTO @vcomp_code1 , @vunit1 ,@vbill_agcd1, @vbill_dpcd1 , @vbranch_code1, @vcity_name1, @vag_name1,@vprint_seqno1,@vagbill_publ1,@agency_rec_agcd,@agency_rec_dpcd,@agency_rec_route_code
		
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



**************************************end*******************************************

*********************************** Rikkee Garg Bill register 12/6/12***************************

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
	@pextra2            VARCHAR(400) --order by
AS 
/*select getdate()*/
DECLARE @vquery			varchar(8000) 
	DECLARE @vfrdt			DATETIME 
	DECLARE @vtodt			DATETIME 
	declare @v_statecode	VARCHAR(20)
	declare @v_distcode		VARCHAR(20)
	declare @v_citycode		VARCHAR(20)
	declare @v_taluka		VARCHAR(20)

	--SET @vfrdt  = dbo.convert_user_date('/', @pfrom_billdt,@pdateformat)
	--SET @vtodt  = dbo.convert_user_date('/', @ptill_billdt,@pdateformat)
declare @v_route as varchar(20)
declare @v_exec as varchar(20)
set @v_statecode	=''
	set @v_distcode	=''
	set @v_citycode		=''
	set @v_taluka		=''
	set @v_route		=''
	set @v_exec		=''

SET @vfrdt  = @pfrom_billdt
	SET @vtodt  = @ptill_billdt
	If @repty='1' Begin--State
        set @v_statecode=@pextra1
	End
    Else if @repty='2' Begin    --District
        set @v_distcode=@pextra1
    End
    Else if @repty='3' Begin    --Taluka
        set @v_taluka=@pextra1
    End
    Else if @repty='4' Begin    --route
        set @v_route=@pextra1
    End
    Else if @repty='5' Begin    --exec
        set @v_exec=@pextra1
    End
    Else Begin--City
        set @v_citycode=@pextra1
	End

print(@v_distcode)
	IF ISNULL(@repty, 'N')= '1' BEGIN --FOR STATE
		set @vquery='select b.comp_code AS "COMP_CODE", b.unit_code AS "UNIT_CODE", b.billno AS "BILLNO", b.billdt AS "BILLDT", b.agcd AS "AGCD", b.dpcd AS "DPCD", 
		min(b.publ) AS "PUBL", sum(b.bill_copy) AS "BILL_COPY", sum(b.gross_amount) AS "GROSS_AMOUNT", sum(b.sur_amt) AS "SUR_AMOUNT", sum(b.comm_amt) AS "COMM_AMOUNT",
		sum(b.bill_amount) AS "BILL_AMOUNT",max(b.bill_flag) AS "BILL_FLAG",null as  "BILL_REMARK", max(b.userid) AS "USERID", max(b.creation_date) AS "CREATION_DATE", 
		b.branch_code AS "BRANCH_CODE",m.ag_name AS "AGENCY_NAME",DBO.cir_get_city(b.comp_code,m.city_code) as "CITY_NAME" ,
		DBO.cir_get_state(b.comp_code, m.country_code, m.state_code) as "STATE_NAME"
		from cir_bill_det b,cir_agmast m
		where b.comp_code = '''+@pcomp_code+''' and m.comp_code=b.comp_code and (b.unit_code = isnull('''+@punit_code+''',b.unit_code) OR '''+@punit_code+'''='''') and 
		m.unit=b.unit_code and (b.agcd = isnull('''+@pbillagcd+''',b.agcd) OR '''+@pbillagcd+'''='''')
 and m.agcd=b.agcd and (b.dpcd = isnull('''+@pbilldpcd+''',b.dpcd) OR '''+@pbilldpcd+'''='''') and  
m.dpcd=b.dpcd and b.billdt >= '''+@pfrom_billdt+''' and billdt <='''+@ptill_billdt+'''
and (b.bill_flag = isnull('''+@pbill_freq+''',b.bill_flag) OR '''+@pbill_freq+'''='''') 
and 
		(b.publ = isnull('''+@ppubl+''',b.publ) OR '''+@ppubl+'''='''') 
and (m.state_code='''+@v_statecode+''' or '''+@v_statecode+''' is null OR '''+@v_statecode+'''='''') 
and (m.dist_code='''+@v_distcode+''' or '''+@v_distcode+''' is null OR '''+@v_distcode+'''='''')
and 
		(m.tehsil_taluka='''+@v_taluka+''' or '''+@v_taluka+''' is null or '''+@v_taluka+'''='''') 
and (m.city_code='''+@v_citycode+''' or '''+@v_citycode+''' is null or '''+@v_citycode+'''='''')
		group by b.comp_code, b.unit_code, b.billno ,b.billdt,b.agcd, b.dpcd,m.ag_name,b.branch_code,m.city_code,m.country_code,m.state_code
		order by comp_code, state_name,'+@pextra2+'' --billdt,billno,agency_name


/*

 
*/
--		 
	END	
    else IF ISNULL(@repty, 'N')= '2'  BEGIN--FOR DISTRICT
		set @vquery='select b.comp_code AS "COMP_CODE", b.unit_code AS "UNIT_CODE", b.billno AS "BILLNO", b.billdt AS "BILLDT", b.agcd AS "AGCD", b.dpcd AS "DPCD", 
		min(b.publ) AS "PUBL", sum(b.bill_copy) AS "BILL_COPY", sum(b.gross_amount) AS "GROSS_AMOUNT", sum(b.sur_amt) AS "SUR_AMOUNT", sum(b.comm_amt) AS "COMM_AMOUNT",
		sum(b.bill_amount) AS "BILL_AMOUNT",max(b.bill_flag) AS "BILL_FLAG",null as  "BILL_REMARK", max(b.userid) AS "USERID", max(b.creation_date) AS "CREATION_DATE", 
		b.branch_code AS "BRANCH_CODE",m.ag_name AS "AGENCY_NAME",DBO.cir_get_city(b.comp_code,m.city_code) as "CITY_NAME" ,
		DBO.cir_get_state(b.comp_code, m.country_code, m.state_code) as "STATE_NAME",
		DBO.cir_get_dist(b.comp_code, m.state_code, m.dist_code) as "DIST_NAME"
		from cir_bill_det b,cir_agmast m
		where b.comp_code = '''+@pcomp_code+''' and m.comp_code=b.comp_code and (b.unit_code = isnull('''+@punit_code+''',b.unit_code) OR '''+@punit_code+'''='''') and 
		m.unit=b.unit_code and (b.agcd = isnull('''+@pbillagcd+''',b.agcd) OR '''+@pbillagcd+'''='''') and m.agcd=b.agcd and (b.dpcd = isnull('''+@pbilldpcd+''',b.dpcd) OR '''+@pbilldpcd+'''='''') and  
		m.dpcd=b.dpcd and b.billdt >= '''+@pfrom_billdt+''' and billdt <='''+@ptill_billdt+''' and (b.bill_flag = isnull('''+@pbill_freq+''',b.bill_flag) OR '''+@pbill_freq+'''='''') and 
		(b.publ = isnull('''+@ppubl+''',b.publ) OR '''+@ppubl+'''='''') and (m.state_code='''+@v_statecode+''' or '''+@v_statecode+''' is null OR '''+@v_statecode+'''='''') and (m.dist_code='''+@v_distcode+''' or '''+@v_distcode+''' is null OR '''+@v_distcode+'''='''') and 
		(m.tehsil_taluka='''+@v_taluka+''' or '''+@v_taluka+''' is null or '''+@v_taluka+'''='''') and (m.city_code='''+@v_citycode+''' or '''+@v_citycode+''' is null or '''+@v_citycode+'''='''')
		group by b.comp_code, b.unit_code, b.billno ,b.billdt,b.agcd, b.dpcd,m.ag_name,b.branch_code,m.city_code,m.country_code,m.state_code,m.dist_code
		order by comp_code, state_name,dist_name,'+@pextra2+''--billdt,billno,agency_name
	END
	else IF ISNULL(@repty, 'N')= '3' BEGIN 		
		set @vquery='select b.comp_code AS "COMP_CODE", b.unit_code AS "UNIT_CODE", b.billno AS "BILLNO", b.billdt AS "BILLDT", b.agcd AS "AGCD", b.dpcd AS "DPCD", 
		min(b.publ) AS "PUBL", sum(b.bill_copy) AS "BILL_COPY", sum(b.gross_amount) AS "GROSS_AMOUNT", sum(b.sur_amt) AS "SUR_AMOUNT", sum(b.comm_amt) AS "COMM_AMOUNT",
		sum(b.bill_amount) AS "BILL_AMOUNT",max(b.bill_flag) AS "BILL_FLAG",null as  "BILL_REMARK", max(b.userid) AS "USERID", max(b.creation_date) AS "CREATION_DATE", 
		b.branch_code AS "BRANCH_CODE",m.ag_name AS "AGENCY_NAME",DBO.cir_get_city(b.comp_code,m.city_code) as "CITY_NAME" ,
		DBO.cir_get_state(b.comp_code, m.country_code, m.state_code) as "STATE_NAME",
		DBO.cir_get_taluka(b.comp_code, m.tehsil_taluka) as "TALUKA_NAME"
		from cir_bill_det b,cir_agmast m
		where b.comp_code = '''+@pcomp_code+''' and m.comp_code=b.comp_code and (b.unit_code = isnull('''+@punit_code+''',b.unit_code) OR '''+@punit_code+'''='''') and 
		m.unit=b.unit_code and (b.agcd = isnull('''+@pbillagcd+''',b.agcd) OR '''+@pbillagcd+'''='''') and m.agcd=b.agcd and (b.dpcd = isnull('''+@pbilldpcd+''',b.dpcd) OR '''+@pbilldpcd+'''='''') and  
		m.dpcd=b.dpcd and b.billdt >= '''+@pfrom_billdt+''' and billdt <='''+@ptill_billdt+''' and (b.bill_flag = isnull('''+@pbill_freq+''',b.bill_flag) OR '''+@pbill_freq+'''='''') and 
		(b.publ = isnull('''+@ppubl+''',b.publ) OR '''+@ppubl+'''='''') and (m.state_code='''+@v_statecode+''' or '''+@v_statecode+''' is null OR '''+@v_statecode+'''='''') and (m.dist_code='''+@v_distcode+''' or '''+@v_distcode+''' is null OR '''+@v_distcode+'''='''') and 
		(m.tehsil_taluka='''+@v_taluka+''' or '''+@v_taluka+''' is null or '''+@v_taluka+'''='''') and (m.city_code='''+@v_citycode+''' or '''+@v_citycode+''' is null or '''+@v_citycode+'''='''')
		group by b.comp_code, b.unit_code, b.billno ,b.billdt,b.agcd, b.dpcd,m.ag_name,b.branch_code,m.city_code,m.country_code,m.state_code,m.tehsil_taluka
		order by comp_code, state_name,taluka_name,'+@pextra2+''--billdt,billno,agency_name
	END	
	else IF ISNULL(@repty, 'N')= '4'  BEGIN--FOR Route
		set @vquery='select b.comp_code AS "COMP_CODE", b.unit_code AS "UNIT_CODE", b.billno AS "BILLNO", b.billdt AS "BILLDT", b.agcd AS "AGCD", b.dpcd AS "DPCD", 
		min(b.publ) AS "PUBL", sum(b.bill_copy) AS "BILL_COPY", sum(b.gross_amount) AS "GROSS_AMOUNT", sum(b.sur_amt) AS "SUR_AMOUNT", sum(b.comm_amt) AS "COMM_AMOUNT",
		sum(b.bill_amount) AS "BILL_AMOUNT",max(b.bill_flag) AS "BILL_FLAG",null as  "BILL_REMARK", max(b.userid) AS "USERID", max(b.creation_date) AS "CREATION_DATE", 
		b.branch_code AS "BRANCH_CODE",m.ag_name AS "AGENCY_NAME",DBO.cir_get_city(b.comp_code,m.city_code) as "CITY_NAME" ,
		DBO.cir_get_state(b.comp_code, m.country_code, m.state_code) as "STATE_NAME",
		p.route_code,DBO.cir_get_route_name(b.comp_code, b.unit_code, p.route_code) as "ROUTE_NAME"
		from cir_bill_det b,cir_agmast m,cir_dbksup p
		where b.comp_code = '''+@pcomp_code+''' 
		and m.comp_code=p.comp_code and m.agcd=p.agcd and m.dpcd=p.dpcd and b.comp_code=p.comp_code and b.agcd=p.agcd and b.dpcd=p.dpcd
		and m.comp_code=b.comp_code and (b.unit_code = isnull('''+@punit_code+''',b.unit_code) OR '''+@punit_code+'''='''') and 
		m.unit=b.unit_code and (b.agcd = isnull('''+@pbillagcd+''',b.agcd) OR '''+@pbillagcd+'''='''') and m.agcd=b.agcd and (b.dpcd = isnull('''+@pbilldpcd+''',b.dpcd) OR '''+@pbilldpcd+'''='''') and  
		m.dpcd=b.dpcd and b.billdt >= '''+@pfrom_billdt+''' and billdt <='''+@ptill_billdt+''' and (b.bill_flag = isnull('''+@pbill_freq+''',b.bill_flag) OR '''+@pbill_freq+'''='''') and 
		(b.publ = isnull('''+@ppubl+''',b.publ) OR '''+@ppubl+'''='''') and (m.state_code='''+@v_statecode+''' or '''+@v_statecode+''' is null OR '''+@v_statecode+'''='''') and (m.dist_code='''+@v_distcode+''' or '''+@v_distcode+''' is null OR '''+@v_distcode+'''='''') and 
		(m.city_code='''+@v_citycode+''' or '''+@v_citycode+''' is null or '''+@v_citycode+'''='''')
		and (p.route_code='''+@v_route+''' or '''+@v_route+''' is null or '''+@v_route+'''='''')
		group by b.comp_code, b.unit_code, b.billno ,b.billdt,b.agcd, b.dpcd,m.ag_name,b.branch_code,m.city_code,m.country_code,m.state_code,p.route_code
		order by comp_code, state_name,ROUTE_NAME,'+@pextra2+''--billdt,billno,agency_name
	END
	else IF ISNULL(@repty, 'N')= '5'  BEGIN--FOR executive
		set @vquery='select b.comp_code AS "COMP_CODE", b.unit_code AS "UNIT_CODE", b.billno AS "BILLNO", b.billdt AS "BILLDT", b.agcd AS "AGCD", b.dpcd AS "DPCD", 
		min(b.publ) AS "PUBL", sum(b.bill_copy) AS "BILL_COPY", sum(b.gross_amount) AS "GROSS_AMOUNT", sum(b.sur_amt) AS "SUR_AMOUNT", sum(b.comm_amt) AS "COMM_AMOUNT",
		sum(b.bill_amount) AS "BILL_AMOUNT",max(b.bill_flag) AS "BILL_FLAG",null as  "BILL_REMARK", max(b.userid) AS "USERID", max(b.creation_date) AS "CREATION_DATE", 
		b.branch_code AS "BRANCH_CODE",m.ag_name AS "AGENCY_NAME",DBO.cir_get_city(b.comp_code,m.city_code) as "CITY_NAME" ,
		DBO.cir_get_state(b.comp_code, m.country_code, m.state_code) as "STATE_NAME",
		m.executive_code,DBO.cir_get_executive(b.comp_code, m.executive_code) as "EXEC_NAME"
		from cir_bill_det b,cir_agmast m
		where b.comp_code = '''+@pcomp_code+''' and m.comp_code=b.comp_code and (b.unit_code = isnull('''+@punit_code+''',b.unit_code) OR '''+@punit_code+'''='''') and 
		m.unit=b.unit_code and (b.agcd = isnull('''+@pbillagcd+''',b.agcd) OR '''+@pbillagcd+'''='''') and m.agcd=b.agcd and (b.dpcd = isnull('''+@pbilldpcd+''',b.dpcd) OR '''+@pbilldpcd+'''='''') and  
		m.dpcd=b.dpcd and b.billdt >= '''+@pfrom_billdt+''' and billdt <='''+@ptill_billdt+''' 
		and (b.bill_flag = isnull('''+@pbill_freq+''',b.bill_flag) OR '''+@pbill_freq+'''='''') 
		and (b.publ = isnull('''+@ppubl+''',b.publ) OR '''+@ppubl+'''='''') 
		and (m.state_code='''+@v_statecode+''' or '''+@v_statecode+''' is null OR '''+@v_statecode+'''='''') 
		and (m.dist_code='''+@v_distcode+''' or '''+@v_distcode+''' is null OR '''+@v_distcode+'''='''') 
		and (m.executive_code='''+@v_exec+''' or '''+@v_exec+''' is null or '''+@v_exec+'''='''') 
		and	(m.city_code='''+@v_citycode+''' or '''+@v_citycode+''' is null or '''+@v_citycode+'''='''')
		group by b.comp_code, b.unit_code, b.billno ,b.billdt,b.agcd, b.dpcd,m.ag_name,b.branch_code,m.city_code,m.country_code,m.state_code,m.executive_code
		order by comp_code, state_name,EXEC_NAME,'+@pextra2+''
	END
	ELSE BEGIN
print('11')
		set @vquery='select b.comp_code AS "COMP_CODE", b.unit_code AS "UNIT_CODE", b.billno AS "BILLNO", b.billdt AS "BILLDT", b.agcd AS "AGCD", b.dpcd AS "DPCD", 
		min(b.publ) AS "PUBL", sum(b.bill_copy) AS "BILL_COPY", sum(b.gross_amount) AS "GROSS_AMOUNT", sum(b.sur_amt) AS "SUR_AMOUNT", sum(b.comm_amt) AS "COMM_AMOUNT",
		sum(b.bill_amount) AS "BILL_AMOUNT",max(b.bill_flag) AS "BILL_FLAG",null as  "BILL_REMARK", max(b.userid) AS "USERID", max(b.creation_date) AS "CREATION_DATE", 
		b.branch_code AS "BRANCH_CODE",m.ag_name AS "AGENCY_NAME",DBO.cir_get_city(b.comp_code,m.city_code) as "CITY_NAME" ,
		DBO.cir_get_state(b.comp_code, m.country_code, m.state_code) as "STATE_NAME"
		from cir_bill_det b,cir_agmast m
		where b.comp_code = '''+@pcomp_code+''' and m.comp_code=b.comp_code and (b.unit_code = isnull('''+@punit_code+''',b.unit_code) OR '''+@punit_code+'''='''') and 
		m.unit=b.unit_code and (b.agcd = isnull('''+@pbillagcd+''',b.agcd) OR '''+@pbillagcd+'''='''') and m.agcd=b.agcd and (b.dpcd = isnull('''+@pbilldpcd+''',b.dpcd) OR '''+@pbilldpcd+'''='''') and  
		m.dpcd=b.dpcd and b.billdt >= '''+@pfrom_billdt+''' and billdt <='''+@ptill_billdt+''' and (b.bill_flag = isnull('''+@pbill_freq+''',b.bill_flag) OR '''+@pbill_freq+'''='''') and 
		(b.publ = isnull('''+@ppubl+''',b.publ) OR '''+@ppubl+'''='') and (m.state_code='''+@v_statecode+''' or '''+@v_statecode+''' is null OR '''+@v_statecode+'''='') and (m.dist_code='''+@v_distcode+''' or '''+@v_distcode+''' is null OR '''+@v_distcode+'''='''') and 
		(m.tehsil_taluka='''+@v_taluka+''' or '''+@v_taluka+''' is null or '''+@v_taluka+'''='''') and (m.city_code='''+@v_citycode+''' or '''+@v_citycode+''' is null or '''+@v_citycode+'''='''')
		group by b.comp_code, b.unit_code, b.billno ,b.billdt,b.agcd, b.dpcd,m.ag_name,b.branch_code,m.city_code,m.country_code,m.state_code
		order by comp_code, state_name,'+@pextra2+''--billdt,billno,agency_name
	end
PRINT(@vquery)
exec(@vquery)


*********************************** end of bill register**********************************


/////////////////add by Deepika 13/05/2012 sent By amit sir////////////////////////

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
    when period='15' then 'Fortnightly' when period='90' then 'Quarterly' 
    when period='365' then 'Yearly' else convert(varchar(50),period) end publ_frequancy,
    case when pro_type='NE0' then 'Newspaper' when pro_type='MA0' then 'Magzine' else pro_type end product,0 credit_days,0 credit_limit
    from cir_publ_mast 
    where comp_code=@pcompcode and publ not in(select publ_code from cir_overdue_mast where comp_code=@pcompcode and 
    bill_cycle=@pbill_cycle)
    union all
    select distinct 'U' trans_ty,p.comp_code comp_code, p.publ publ, p.publ_name publ_name, p.pnick pnick, 
    case when p.period='1' then 'Daily' when p.period='7' then 'Weekly' when p.period='30' then 'Monthly' 
    when p.period='15' then 'Fortnightly' when p.period='90' then 'Quarterly' 
    when p.period='365' then 'Yearly' else convert(varchar(50),p.period) end publ_frequancy,
    case when p.pro_type='NE0' then 'Newspaper' when p.pro_type='MA0' then 'Magzine' else p.pro_type end product,
    o.credit_days credit_days,o.credit_limit credit_limit
    from cir_publ_mast p,cir_overdue_mast o
    where p.comp_code=o.comp_code and p.comp_code=@pcompcode and o.bill_cycle=@pbill_cycle) x 
    order by comp_code,publ_name

end 


//////////////////////next 



ALTER
function [dbo].[cir_get_unsold_permissable_days]

(

@pcompcode
as varchar(20),

@ppublcode
as varchar(20),

@puserid
as varchar(20),

@pagcd
as varchar(20),

@pdpcd
as varchar(20),

@pflag
as varchar(1),

@pchkdate
as datetime,

@preceivedt
as datetime,

@pextra1
as varchar(20),

@pextra2
as varchar(20)

) returns varchar(500)

As

Begin

-------

declare @v_bill_freq as varchar(1)

declare @v_unit as varchar(20)

declare @v_branch as varchar(20)

declare @v_region as varchar(20)

declare @v_zone as varchar(20)

declare @v_agtype as varchar(20)

declare @v_agclass as varchar(20)

declare @v_citycode as varchar(20)

declare @v_cnt as int

declare @v_output as int

declare @v_value as varchar(500)

select distinct @v_bill_freq=billing_cycle from CIR_SUPPLY where comp_code= @pcompcode

and agcd=@pagcd and dpcd=@pdpcd and publ=@ppublcode

and (EDTN=@pextra1 or @pextra1 is null or @pextra1 ='')

select @v_unit=unit,@v_branch=branch_code,@v_citycode=city_code,@v_agtype=ag_type,@v_agclass=ag_class from cir_agmast

where comp_code=@pcompcode and agcd=@pagcd and dpcd=@pdpcd

select distinct @v_zone=zone_code,@v_region=region_code from cir_city_mast c where c.city_code=@v_citycode

if @v_unit = '' begin

set @v_unit=null

end

if @v_branch ='' begin

set @v_branch=null

end

if @v_region ='' begin

set @v_region=null

end

if @v_zone='' begin

set @v_zone=null

end

if @v_agtype='' begin

set @v_agtype=null

end

if @v_agclass ='' begin

set @v_agclass=null

end

select @v_cnt= count(*) from CIR_UNSOLD_RETURN_CONTROL where comp_code=@pcompcode

and publ_code=@ppublcode and bill_freq=@v_bill_freq

and (unit_code=@v_unit or unit_code is null or unit_code ='')

and (branch_code=@v_branch or branch_code is null or branch_code ='')

and (reg_code=@v_region or reg_code is null or reg_code ='')

and (zone_code=@v_zone or zone_code is null or zone_code ='')

and (ag_type=@v_agtype or ag_type is null or ag_type ='')

and (ag_class=@v_agclass or ag_class is null or ag_class ='')

--and (EDTN_CODE=@pextra1 or EDTN_CODE is null or EDTN_CODE ='')

--select @v_cnt= count(*) from CIR_UNSOLD_RETURN_CONTROL where comp_code=@pcompcode

--and publ_code=@ppublcode and bill_freq=@v_bill_freq

--and (unit_code=@v_unit or @v_unit is null)

--and (branch_code=@v_branch or @v_branch is null)

--and (reg_code=@v_region or @v_region is null)

--and (zone_code=@v_zone or @v_zone is null)

--and (ag_type=@v_agtype or @v_agtype is null)

--and (ag_class=@v_agclass or @v_agclass is null)

--and (EDTN_CODE=@pextra1 or @pextra1 is null or @pextra1 ='')

--select @v_output= isnull(no_of_days,0) from CIR_UNSOLD_RETURN_CONTROL p

--where comp_code=@pcompcode

--and publ_code=@ppublcode and bill_freq=@v_bill_freq

--and (unit_code=@v_unit or @v_unit is null)

--and (branch_code=@v_branch or @v_branch is null)

--and (reg_code=@v_region or @v_region is null)

--and (zone_code=@v_zone or @v_zone is null)

--and (ag_type=@v_agtype or @v_agtype is null)

--and (ag_class=@v_agclass or @v_agclass is null)

--and (EDTN_CODE=@pextra1 or @pextra1 is null or @pextra1 ='')

select @v_output= isnull(no_of_days,0) from CIR_UNSOLD_RETURN_CONTROL p

where comp_code=@pcompcode

and publ_code=@ppublcode and bill_freq=@v_bill_freq

and (unit_code=@v_unit or unit_code is null or unit_code ='')

and (branch_code=@v_branch or branch_code is null or branch_code ='')

and (reg_code=@v_region or reg_code is null or reg_code ='')

and (zone_code=@v_zone or zone_code is null or zone_code ='')

and (ag_type=@v_agtype or ag_type is null or ag_type ='')

and (ag_class=@v_agclass or ag_class is null or ag_class ='')

--and (EDTN_CODE=@pextra1 or EDTN_CODE is null or EDTN_CODE ='')

declare @diff_days as int

set @diff_days=datediff(dd,@preceivedt,@pchkdate)

if @v_cnt =0 begin

set @v_output= 0

end

if @pflag = 'D'

begin

--@v_output -- contains permissable days allowed

if @diff_days > @v_output

begin

set @v_value='You are not authorized to receive unsold more than '+ cast (@v_output as varchar) + ' days.'

end

else

begin

set @v_value='OK'

end

end

else

begin

set @v_value='OK'

end

-------

return isnull(@v_value,0)

End

////////////////////////////////next




ALTER
PROCEDURE [dbo].[cir_unsold_credit_note_cir_unsold_supply_p]

@pcomp_code
as varchar(40),

@punit_code
as varchar(40),

@ppubl_code
as varchar(40),

@pedtn_code
as varchar(40),

@psup_fromdate
as datetime,

@psup_todate
as datetime,

@pagcd_code
as varchar(20),

@pdpcd_code
as varchar(20),

@pdateformat
as varchar(20),

@preceiptdt
as datetime,

@pextra1
as varchar(20),--it is use for datewise or ratewise

@pextra2
as varchar(20)

As

Begin

if upper(@pextra2)='D' Begin

PRINT 'A'

select z.comp_code AS "COMP_CODE",z.unit_code AS "UNIT_CODE",z.publ AS "PUBL",z.publ_name AS "PUBL_NAME",z.edtn AS "EDTN" , z.edtn_name AS "EDTN_NAME",

z
.supply_date AS "SUPPLY_DATE", z.supply_date AS "SUPPLY_DATEMON",z.copy_rate AS "COPY_RATE",z.comm_fix_auto_spl AS "COMM_FIX_AUTO_SPL" ,z.comm_code AS "COMM_CODE",z.waste_rate AS "WASTE_RATE",

substring(z.comm_rate,1,1) AS "COMM_CATEG_TYPE",substring(z.comm_rate,2,len(z.comm_rate)-1) AS "COMM_RATE",z.supply_copy AS "SUPPLY_COPY",z.rate_supply AS "RATE_SUPPLY",

z
.RETURNABLE as "RETURNABLE",z.per_copy_weight per_copy_weight

,z.RETURNABLEper

as "RETURNABLEper" from--P30,C0.5

(select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,p.publ_name publ_name,

d
.edtn edtn,edition_nick edtn_name,d.supdate supply_date,

d
.sup_rate copy_rate,d.comm_fix_auto_spl comm_fix_auto_spl,d.comm_code comm_code,

dbo
.cir_get_waste_rate_catg(d.comp_code,d.unit_code,d.edtn,supdate,''''+@pdateformat+'''',d.waste_catg_code,null,null) waste_rate,

dbo
.cir_get_commission(d.comp_code,d.unit_code,d.publ,d.edtn,d.comm_fix_auto_spl ,d.comm_code,d.supdate,''''+@pdateformat+'''',sum(d.sup_copy),'','') comm_rate,

'P' comm_catg_type, sum(d.sup_copy) supply_copy,sum(d.sup_copy) rate_supply,

d
.per_copy_weight per_copy_weight,d.waste_catg_code waste_catg_code

,dbo.cir_get_unsold_returnable(d.comp_code,d.publ,sum(d.sup_copy),'A01',@pagcd_code,@pdpcd_code,'Q','','') as "RETURNABLE"

,dbo.cir_get_unsold_returnable(d.comp_code,d.publ,sum(d.sup_copy),'A01',@pagcd_code,@pdpcd_code,'P','','') as "RETURNABLEper"

from cir_dbksup_dis d,cir_publ_mast p,cir_edtn_mast e

where d.comp_code=@pcomp_code and d.comp_code=p.comp_code and d.comp_code=e.comp_code and

d
.unit_code=@punit_code and d.publ=p.publ and d.publ=e.publ and

(d.publ=@ppubl_code or @ppubl_code is null or @ppubl_code='') and

d
.edtn=e.edtn and (d.edtn = @pedtn_code or @pedtn_code is null or @pedtn_code='') and

d
.supdate between @psup_fromdate and @psup_todate and

d
.billagcd=@pagcd_code and d.billdpcd=@pdpcd_code and upper(isnull(@pextra1,'D'))='D'

group by d.comp_code,d.unit_code,d.publ,p.publ_name,e.edition_nick,d.edtn,d.supdate,d.sup_rate,d.comm_fix_auto_spl,d.comm_code,d.per_copy_weight,d.waste_catg_code)z

union

select distinct z.comp_code AS "COMP_CODE",z.unit_code AS "UNIT_CODE",z.publ AS "PUBL",z.publ_name AS "PUBL_NAME",z.edtn AS "EDTN",z.edtn_name AS "EDTN_NAME",

MAX(z.supply_date) AS "SUPPLY_DATE",dbo.GetLastDayOfMonth(z.supply_date) AS "SUPPLY_DATEMON",

z
.copy_rate AS "COPY_RATE",z.comm_fix_auto_spl AS "COMM_FIX_AUTO_SPL",z.comm_code AS "COMM_CODE",z.waste_rate AS "WASTE_RATE",

z
.comm_catg_type AS "COMM_CATEG_TYPE",z.comm_rate AS "COMM_RATE",sum(z.supply_copy) AS "SUPPLY_COPY",sum(z.supply_copy) rate_supply,

dbo
.cir_get_unsold_returnable(z.comp_code,z.publ,sum(z.supply_copy),'A01',@pagcd_code,@pdpcd_code,'Q','','') RETURNABLE,

max(z.per_copy_weight) per_copy_weight

,dbo.cir_get_unsold_returnable(z.comp_code,z.publ,sum(z.supply_copy),'A01',@pagcd_code,@pdpcd_code,'P','','') as "RETURNABLEper"

from (select distinct y.comp_code,y.unit_code,y.publ,y.publ_name,y.edtn,y.edtn_name,y.supply_date,y.copy_rate,y.comm_fix_auto_spl,y.comm_code,y.waste_rate,

substring(y.comm_rate,1,1) comm_catg_type,substring(y.comm_rate,2,len(y.comm_rate)-1) comm_rate,y.supply_copy,y.rate_supply ,

y
.per_copy_weight per_copy_weight from--P30,C0.5

(select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,p.publ_name publ_name,

d
.edtn edtn,edition_nick edtn_name,d.supdate supply_date,

d
.sup_rate copy_rate,d.comm_fix_auto_spl comm_fix_auto_spl,d.comm_code comm_code,

dbo
.cir_get_waste_rate_catg(d.comp_code,d.unit_code,d.edtn,d.supdate,''''+@pdateformat+'''',d.waste_catg_code,null,null) waste_rate,

dbo
.cir_get_commission(d.comp_code,d.unit_code,d.publ,d.edtn,d.comm_fix_auto_spl ,d.comm_code,d.supdate,''''+@pdateformat+'''',sum(d.sup_copy),'','') comm_rate,'P' comm_catg_type,

sum(d.sup_copy) supply_copy,

(select sum(u.sup_copy) from cir_dbksup_dis u where u.comp_code=d.comp_code and u.unit_code=d.unit_code and

(u.publ=d.publ) and u.edtn=d.edtn and u.supdate between @psup_fromdate and @psup_todate and

u
.billagcd=@pagcd_code and u.billdpcd=@pdpcd_code and u.sup_rate=d.sup_rate) rate_supply,

d
.per_copy_weight per_copy_weight,d.waste_catg_code waste_catg_code

from cir_dbksup_dis d,cir_publ_mast p,cir_edtn_mast e

where d.comp_code=@pcomp_code and d.comp_code=p.comp_code and d.comp_code=e.comp_code and

d
.unit_code=@punit_code and d.publ=p.publ and d.publ=e.publ and

(d.publ=@ppubl_code or @ppubl_code is null or @ppubl_code='') and

d
.edtn=e.edtn and (d.edtn = @pedtn_code or @pedtn_code is null or @pedtn_code='') and

d
.supdate between @psup_fromdate and @psup_todate and

d
.billagcd=@pagcd_code and d.billdpcd=@pdpcd_code and upper(isnull(@pextra1,'D'))='R'

group by d.comp_code,d.unit_code,d.publ,p.publ_name,e.edition_nick,d.edtn,d.supdate,d.sup_rate,d.comm_fix_auto_spl,d.comm_code,d.per_copy_weight,d.waste_catg_code)y) z

group by z.comp_code,z.unit_code,z.publ,z.publ_name,z.edtn,z.edtn_name,dbo.GetLastDayOfMonth(z.supply_date),

z
.copy_rate,z.comm_fix_auto_spl,z.comm_code,z.waste_rate,z.comm_catg_type,z.comm_rate

order by publ_name,edtn,supply_date

End

Else Begin

PRINT 'B'

select z.comp_code AS "COMP_CODE",z.unit_code AS "UNIT_CODE",z.publ AS "PUBL",z.publ_name AS "PUBL_NAME",z.edtn AS "EDTN",z.edtn_name AS "EDTN_NAME",

z
.supply_date AS "SUPPLY_DATE",z.supply_date AS "SUPPLY_DATEMON",

z
.copy_rate AS "COPY_RATE",z.comm_fix_auto_spl AS "COMM_FIX_AUTO_SPL",z.comm_code AS "COMM_CODE",z.waste_rate AS "WASTE_RATE",

substring(z.comm_rate,1,1) AS "COMM_CATEG_TYPE",substring(z.comm_rate,2,len(z.comm_rate)-1) AS "COMM_RATE",z.supply_copy AS "SUPPLY_COPY",z.rate_supply AS "RATE_SUPPLY",

z
.RETURNABLE

as "RETURNABLE" ,z.per_copy_weight per_copy_weight

,z.RETURNABLEper

as "RETURNABLEper" from--P30,C0.5

(select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,p.publ_name publ_name,

d
.edtn edtn,edition_nick edtn_name,d.supdate supply_date,

d
.sup_rate copy_rate,d.comm_fix_auto_spl comm_fix_auto_spl,d.comm_code comm_code,

dbo
.cir_get_waste_rate_catg(d.comp_code,d.unit_code,d.edtn,supdate,''''+@pdateformat+'''',d.waste_catg_code,null,null) waste_rate,

dbo
.cir_get_commission(d.comp_code,d.unit_code,d.publ,d.edtn,d.comm_fix_auto_spl ,d.comm_code,d.supdate,''''+@pdateformat+'''',sum(d.sup_copy),'','') comm_rate,

'P' comm_catg_type, sum(d.sup_copy) supply_copy,sum(d.sup_copy) rate_supply,

d
.per_copy_weight per_copy_weight,d.waste_catg_code waste_catg_code,

dbo
.cir_get_unsold_returnable(d.comp_code,d.publ,sum(d.sup_copy),'A01',@pagcd_code,@pdpcd_code,'Q','','')

as "RETURNABLE"

,dbo.cir_get_unsold_returnable(d.comp_code,d.publ,sum(d.sup_copy),'A01',@pagcd_code,@pdpcd_code,'P','','') as "RETURNABLEper"

from cir_dbksup d,cir_publ_mast p,cir_edtn_mast e

where d.comp_code=@pcomp_code and d.comp_code=p.comp_code and d.comp_code=e.comp_code and

d
.unit_code=@punit_code and d.publ=p.publ and d.publ=e.publ and

(d.publ=@ppubl_code or @ppubl_code is null or @ppubl_code='') and

d
.edtn=e.edtn and (d.edtn = @pedtn_code or @pedtn_code is null or @pedtn_code='') and

d
.supdate between @psup_fromdate and @psup_todate and

d
.billagcd=@pagcd_code and d.billdpcd=@pdpcd_code and upper(isnull(@pextra1,'D'))='D'

group by d.comp_code,d.unit_code,d.publ,p.publ_name,e.edition_nick,d.edtn,d.supdate,d.sup_rate,d.comm_fix_auto_spl,d.comm_code,d.per_copy_weight,d.waste_catg_code) z

union

select distinct z.comp_code AS "COMP_CODE",z.unit_code AS "UNIT_CODE",z.publ AS "PUBL",z.publ_name AS "PUBL_NAME",z.edtn AS "EDTN",z.edtn_name AS "EDTN_NAME",

MAX(z.supply_date) AS "SUPPLY_DATE",dbo.GetLastDayOfMonth(z.supply_date) AS "SUPPLY_DATEMON",

z
.copy_rate AS "COPY_RATE",z.comm_fix_auto_spl AS "COMM_FIX_AUTO_SPL",z.comm_code AS "COMM_CODE",z.waste_rate AS "WASTE_RATE",

z
.comm_catg_type AS "COMM_CATEG_TYPE",z.comm_rate AS "COMM_RATE",sum(z.supply_copy) AS "SUPPLY_COPY",sum(z.supply_copy) AS "RATE_SUPPLY" ,

dbo
.cir_get_unsold_returnable(z.comp_code,z.publ,sum(z.supply_copy),'A01',@pagcd_code,@pdpcd_code,'Q','','')

as "RETURNABLE",max(z.per_copy_weight) per_copy_weight

,dbo.cir_get_unsold_returnable(z.comp_code,z.publ,sum(z.supply_copy),'A01',@pagcd_code,@pdpcd_code,'P','','') as "RETURNABLEper" from

(select distinct y.comp_code,y.unit_code,y.publ,y.publ_name,y.edtn,y.edtn_name,y.supply_date,y.copy_rate,y.comm_fix_auto_spl,y.comm_code,y.waste_rate,

substring(y.comm_rate,1,1) comm_catg_type,substring(y.comm_rate,2,len(y.comm_rate)-1) comm_rate,y.supply_copy,y.rate_supply,

y
.per_copy_weight per_copy_weight from--P30,C0.5

(select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,p.publ_name publ_name,d.edtn edtn,edition_nick edtn_name,d.supdate supply_date,

d
.sup_rate copy_rate,d.comm_fix_auto_spl comm_fix_auto_spl,d.comm_code comm_code,

dbo
.cir_get_waste_rate_catg(d.comp_code,d.unit_code,d.edtn,d.supdate,''''+@pdateformat+'''',d.waste_catg_code,null,null) waste_rate,

dbo
.cir_get_commission(d.comp_code,d.unit_code,d.publ,d.edtn,d.comm_fix_auto_spl ,d.comm_code,d.supdate,''''+@pdateformat+'''',sum(d.sup_copy),'','') comm_rate,

'P' comm_catg_type, sum(d.sup_copy) supply_copy,

(select sum(u.sup_copy) from cir_dbksup u where u.comp_code=d.comp_code and u.unit_code=d.unit_code and

(u.publ=d.publ) and u.edtn=d.edtn and u.supdate between @psup_fromdate and @psup_todate and

u
.billagcd=@pagcd_code and u.billdpcd=@pdpcd_code and u.sup_rate=d.sup_rate) rate_supply,

d
.per_copy_weight per_copy_weight,d.waste_catg_code waste_catg_code

from cir_dbksup d,cir_publ_mast p,cir_edtn_mast e

where d.comp_code=@pcomp_code and d.comp_code=p.comp_code and d.comp_code=e.comp_code and

d
.unit_code=@punit_code and d.publ=p.publ and d.publ=e.publ and

(d.publ=@ppubl_code or @ppubl_code is null or @ppubl_code='') and

d
.edtn=e.edtn and (d.edtn = @pedtn_code or @pedtn_code is null or @pedtn_code='') and

d
.supdate between @psup_fromdate and @psup_todate and

d
.billagcd=@pagcd_code and d.billdpcd=@pdpcd_code and upper(isnull(@pextra1,'D'))='R'

group by d.comp_code,d.unit_code,d.publ,p.publ_name,e.edition_nick,d.edtn,d.supdate,d.sup_rate,d.comm_fix_auto_spl,d.comm_code,d.per_copy_weight,d.waste_catg_code) y) z

group by z.comp_code,z.unit_code,z.publ,z.publ_name,z.edtn,z.edtn_name,dbo.GetLastDayOfMonth(z.supply_date),

z
.copy_rate,z.comm_fix_auto_spl,z.comm_code,z.waste_rate,z.comm_catg_type,z.comm_rate

order by publ_name,edtn,supply_date

End

-- this table for permissable days---------

print('q')

print(@pcomp_code)

print(@ppubl_code)

print(@pagcd_code)

print(@pdpcd_code)

print(@preceiptdt)

print(@psup_fromdate)

select top 1 ISNULL(z.output,'OK') as OUTPUT from(

select distinct dbo.cir_get_unsold_permissable_days

(@pcomp_code,isnull(@ppubl_code,d.PUBL),'A01',@pagcd_code,@pdpcd_code,'D',@preceiptdt,@psup_fromdate,d.EDTN,'') as output

,publ,d.EDTN from cir_dbksup d

where d.comp_code=@pcomp_code and

d
.unit_code=@punit_code and

(d.publ=@ppubl_code or @ppubl_code is null or @ppubl_code='')

and (d.edtn = @pedtn_code or @pedtn_code is null or @pedtn_code='')

and d.supdate between @psup_fromdate and @psup_todate and

d
.billagcd=@pagcd_code and d.billdpcd=@pdpcd_code

group by d.PUBL,d.EDTN) z where z.output not like 'OK%'

End


////////////////////////////////////next 



ALTER PROCEDURE [dbo].[CIR_IMP_DAYS_UPDATE]
@pcompcode                                VARCHAR(20),
@pproduct_type                            VARCHAR(20),
@pdays                                    numeric(7,0),
@ppubl                                    varchar(3),
@puser_id                                 VARCHAR(20),
@pupdatedt                                datetime,
@pflag                                    VARCHAR(20),
@pextra1                                  VARCHAR(4000),
@pextra2                                  VARCHAR(4000)

As
	if(@pflag='1')
		begin
			select PUBL,PUBL_NAME,PERIOD,IMP_DAYS from CIR_PUBL_MAST 
			WHERE COMP_CODE=@pcompcode  
			AND PRO_TYPE=@pproduct_type order by PUBL_NAME
		end
	else
		begin
			update CIR_PUBL_MAST set imp_days=@pdays 
			where COMP_CODE=@pcompcode and PUBL=@ppubl 
			AND PRO_TYPE=@pproduct_type
		end





///////////////////////////////next/////////////////////




create
FUNCTION [dbo].[cir_get_mainedtn_name] (@pcomp_code as varchar(10),@psubedtn as varchar(10)) returns varchar(200)

AS

BEGIN

DECLARE
@vmainedtn_name VARCHAR(4000)

select @vmainedtn_name=EDTN_NAME from CIR_EDTN_MAST

where EDTN in(select MAIN_EDTN from CIR_EDTN_MAST

where COMP_CODE=@pcomp_code AND EDTN =@psubedtn)

RETURN
isnull(@vmainedtn_name,'')

END


////////////////////////////next 



                                                                     
                                                                     
                                             

ALTER function [dbo].[cir_get_unsold_returnable]
(
  @pcompcode         as varchar(20),      
  @ppublcode         as varchar(20),      
  @psupcopy  		 as int,      
  @puserid           as varchar(20),
  @pagcd             as varchar(20),
  @pdpcd             as varchar(20),
  @pflag             as varchar(1),
  @pextra1           as varchar(20),
  @pextra2           as varchar(20)
 )					returns numeric

As
Begin
	-------
	declare @v_bill_freq as varchar(1)
	declare @v_unit      as varchar(20)
	declare @v_branch   as varchar(20)
	declare @v_region    as varchar(20)
	declare @v_zone      as varchar(20)
	declare @v_agtype    as varchar(20)
	declare @v_agclass   as varchar(20)
	declare @v_citycode  as varchar(20)
	declare @v_cnt       as int
	declare @v_output    as numeric(14,2)
	declare @v_value     as numeric(14,2)
	
	select distinct @v_bill_freq=billing_cycle from CIR_SUPPLY where comp_code= @pcompcode 
	and agcd=@pagcd and dpcd=@pdpcd and publ=@ppublcode
	and (EDTN=@pextra1 or @pextra1 is null or @pextra1 ='')
	
	select @v_unit=unit,@v_branch=branch_code,@v_citycode=city_code,@v_agtype=ag_type,@v_agclass=ag_class from cir_agmast
	where comp_code=@pcompcode and agcd=@pagcd and dpcd=@pdpcd
	
	select distinct @v_zone=zone_code,@v_region=region_code from cir_city_mast c where c.city_code=@v_citycode
	
	
	
	if @v_unit = '' begin
		set @v_unit=null
	end
	if @v_branch ='' begin
		set @v_branch=null
	end
	if @v_region ='' begin
		set @v_region=null
	end
	if @v_zone='' begin
		set @v_zone=null
	end
	if @v_agtype='' begin
		set @v_agtype=null
	end
	if @v_agclass ='' begin
		set @v_agclass=null
	end
	
	select @v_cnt= count(*) from CIR_UNSOLD_RETURN_CONTROL where comp_code=@pcompcode
	and publ_code=@ppublcode and bill_freq=@v_bill_freq 
	and (unit_code=@v_unit or unit_code is null or unit_code ='') 
	and (branch_code=@v_branch or branch_code is null or branch_code ='')
	and (reg_code=@v_region or reg_code is null or reg_code='') 
	and (zone_code=@v_zone or zone_code is null or zone_code='') 
	and (ag_type=@v_agtype or ag_type is null or ag_type='') 
	and (ag_class=@v_agclass or ag_class is null or ag_class='')
	and (EDTN_CODE=@pextra1 or EDTN_CODE is null or EDTN_CODE ='')
	
	select @v_output= isnull(perm_per,0) from CIR_UNSOLD_RETURN_CONTROL p--,cir_dbksup x
	where comp_code=@pcompcode
	--and x.comp_code=p.comp_code and x.publ=p.publ and x.edtn=p.edtn
	and publ_code=@ppublcode and bill_freq=@v_bill_freq 
	and (unit_code=@v_unit or unit_code is null or unit_code ='') 
	and (branch_code=@v_branch or branch_code is null or branch_code ='')
	and (reg_code=@v_region or reg_code is null or reg_code='') 
	and (zone_code=@v_zone or zone_code is null or zone_code='') 
	and (ag_type=@v_agtype or ag_type is null or ag_type='') 
	and (ag_class=@v_agclass or ag_class is null or ag_class='')
	and (EDTN_CODE=@pextra1 or EDTN_CODE is null or EDTN_CODE ='')
	
	if @v_cnt =0 begin
		set @v_output= 0
	end		

	if @pflag = 'P'
	begin
		set @v_value=@v_output
	end	
	else
	begin
		set @v_value=round(((@psupcopy*@v_output)/100),0)
		
	end
/*	-------	 */
	return isnull(@v_value,0)

End 
	


////////////////////////////////next


                                                                     
                                                                     
                                             

ALTER PROCEDURE [dbo].[cir_unsold_credit_note_cir_unsold_supply_p]
	@pcomp_code			as varchar(40),
	@punit_code			as varchar(40),
	@ppubl_code			as varchar(40),
	@pedtn_code			as varchar(40),
	@psup_fromdate		as datetime,
	@psup_todate        as datetime,
	@pagcd_code			as varchar(20),
	@pdpcd_code			as varchar(20),
	@pdateformat        as varchar(20),
	@preceiptdt         as datetime,
	@pextra1            as varchar(20),--it is use for datewise or ratewise
	@pextra2            as varchar(20)
As
Begin
	if upper(@pextra2)='D' Begin
	PRINT 'A'
 
		select z.comp_code AS "COMP_CODE",z.unit_code AS "UNIT_CODE",z.publ AS "PUBL",z.publ_name AS "PUBL_NAME",z.edtn AS "EDTN" , z.edtn_name AS "EDTN_NAME",
		z.supply_date AS "SUPPLY_DATE", z.supply_date AS "SUPPLY_DATEMON",z.copy_rate AS "COPY_RATE",z.comm_fix_auto_spl AS "COMM_FIX_AUTO_SPL" ,z.comm_code AS "COMM_CODE",z.waste_rate AS "WASTE_RATE",
        substring(z.comm_rate,1,1) AS "COMM_CATEG_TYPE",substring(z.comm_rate,2,len(z.comm_rate)-1) AS "COMM_RATE",z.supply_copy AS "SUPPLY_COPY",z.rate_supply AS "RATE_SUPPLY", 
        z.RETURNABLE as "RETURNABLE",z.per_copy_weight per_copy_weight 
        ,z.RETURNABLEper
            as "RETURNABLEper" from--P30,C0.5
        (select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,p.publ_name publ_name,
        d.edtn edtn,edition_nick edtn_name,d.supdate supply_date,
        d.sup_rate copy_rate,d.comm_fix_auto_spl comm_fix_auto_spl,d.comm_code comm_code,
		dbo.cir_get_waste_rate_catg(d.comp_code,d.unit_code,d.edtn,supdate,''''+@pdateformat+'''',d.waste_catg_code,null,null) waste_rate,
        dbo.cir_get_commission(d.comp_code,d.unit_code,d.publ,d.edtn,d.comm_fix_auto_spl ,d.comm_code,d.supdate,''''+@pdateformat+'''',sum(d.sup_copy),'','') comm_rate,
		'P' comm_catg_type, sum(d.sup_copy) supply_copy,sum(d.sup_copy) rate_supply,
		d.per_copy_weight per_copy_weight,d.waste_catg_code waste_catg_code
		,dbo.cir_get_unsold_returnable(d.comp_code,d.publ,sum(d.sup_copy),'A01',@pagcd_code,@pdpcd_code,'Q',d.edtn,'')  as "RETURNABLE" 
		,dbo.cir_get_unsold_returnable(d.comp_code,d.publ,sum(d.sup_copy),'A01',@pagcd_code,@pdpcd_code,'P',d.edtn,'')   as "RETURNABLEper"
        from cir_dbksup_dis d,cir_publ_mast p,cir_edtn_mast e
        where d.comp_code=@pcomp_code and d.comp_code=p.comp_code and d.comp_code=e.comp_code and
              d.unit_code=@punit_code and d.publ=p.publ and d.publ=e.publ and
              (d.publ=@ppubl_code or @ppubl_code is null or @ppubl_code='') and
              d.edtn=e.edtn and (d.edtn = @pedtn_code or @pedtn_code is null or @pedtn_code='') and
            d.supdate between @psup_fromdate and @psup_todate and
            d.billagcd=@pagcd_code and d.billdpcd=@pdpcd_code and upper(isnull(@pextra1,'D'))='D'
            group by d.comp_code,d.unit_code,d.publ,p.publ_name,e.edition_nick,d.edtn,d.supdate,d.sup_rate,d.comm_fix_auto_spl,d.comm_code,d.per_copy_weight,d.waste_catg_code)z
     union all
        select distinct z.comp_code AS "COMP_CODE",z.unit_code AS "UNIT_CODE",z.publ AS "PUBL",z.publ_name AS "PUBL_NAME",z.edtn AS "EDTN",z.edtn_name AS "EDTN_NAME",
		MAX(z.supply_date) AS "SUPPLY_DATE",dbo.GetLastDayOfMonth(z.supply_date) AS "SUPPLY_DATEMON",
        z.copy_rate AS "COPY_RATE",z.comm_fix_auto_spl AS "COMM_FIX_AUTO_SPL",z.comm_code AS "COMM_CODE",z.waste_rate AS "WASTE_RATE",
        z.comm_catg_type AS "COMM_CATEG_TYPE",z.comm_rate AS "COMM_RATE",sum(z.supply_copy) AS "SUPPLY_COPY",sum(z.supply_copy) rate_supply,
        dbo.cir_get_unsold_returnable(z.comp_code,z.publ,sum(z.supply_copy),'A01',@pagcd_code,@pdpcd_code,'Q',z.edtn,'')  RETURNABLE,
        max(z.per_copy_weight) per_copy_weight 
        ,dbo.cir_get_unsold_returnable(z.comp_code,z.publ,sum(z.supply_copy),'A01',@pagcd_code,@pdpcd_code,'P',z.edtn,'') as "RETURNABLEper"  
        from (select distinct y.comp_code,y.unit_code,y.publ,y.publ_name,y.edtn,y.edtn_name,y.supply_date,y.copy_rate,y.comm_fix_auto_spl,y.comm_code,y.waste_rate,
        substring(y.comm_rate,1,1) comm_catg_type,substring(y.comm_rate,2,len(y.comm_rate)-1) comm_rate,y.supply_copy,y.rate_supply ,
        y.per_copy_weight per_copy_weight from--P30,C0.5
        (select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,p.publ_name publ_name,
        d.edtn edtn,edition_nick edtn_name,d.supdate supply_date,
        d.sup_rate copy_rate,d.comm_fix_auto_spl comm_fix_auto_spl,d.comm_code comm_code,
		dbo.cir_get_waste_rate_catg(d.comp_code,d.unit_code,d.edtn,d.supdate,''''+@pdateformat+'''',d.waste_catg_code,null,null) waste_rate,
        dbo.cir_get_commission(d.comp_code,d.unit_code,d.publ,d.edtn,d.comm_fix_auto_spl ,d.comm_code,d.supdate,''''+@pdateformat+'''',sum(d.sup_copy),'','') comm_rate,'P' comm_catg_type, 
		sum(d.sup_copy) supply_copy,
        (select sum(u.sup_copy) from cir_dbksup_dis u where u.comp_code=d.comp_code and u.unit_code=d.unit_code and 
        (u.publ=d.publ) and u.edtn=d.edtn and u.supdate between @psup_fromdate and @psup_todate and 
        u.billagcd=@pagcd_code and u.billdpcd=@pdpcd_code and u.sup_rate=d.sup_rate) rate_supply,
        d.per_copy_weight per_copy_weight,d.waste_catg_code waste_catg_code
        from cir_dbksup_dis d,cir_publ_mast p,cir_edtn_mast e
        where d.comp_code=@pcomp_code and d.comp_code=p.comp_code and d.comp_code=e.comp_code and
              d.unit_code=@punit_code and d.publ=p.publ and d.publ=e.publ and
              (d.publ=@ppubl_code or @ppubl_code is null or @ppubl_code='') and
              d.edtn=e.edtn and (d.edtn = @pedtn_code or @pedtn_code is null or @pedtn_code='') and
            d.supdate between @psup_fromdate and @psup_todate and
            d.billagcd=@pagcd_code and d.billdpcd=@pdpcd_code and upper(isnull(@pextra1,'D'))='R'
            group by d.comp_code,d.unit_code,d.publ,p.publ_name,e.edition_nick,d.edtn,d.supdate,d.sup_rate,d.comm_fix_auto_spl,d.comm_code,d.per_copy_weight,d.waste_catg_code)y) z
            group by z.comp_code,z.unit_code,z.publ,z.publ_name,z.edtn,z.edtn_name,dbo.GetLastDayOfMonth(z.supply_date),
                z.copy_rate,z.comm_fix_auto_spl,z.comm_code,z.waste_rate,z.comm_catg_type,z.comm_rate
			order by publ_name,edtn,supply_date
	End
	Else Begin
	PRINT 'B'
            select z.comp_code AS "COMP_CODE",z.unit_code AS "UNIT_CODE",z.publ AS "PUBL",z.publ_name AS "PUBL_NAME",z.edtn AS "EDTN",z.edtn_name AS "EDTN_NAME",
			z.supply_date AS "SUPPLY_DATE",z.supply_date AS "SUPPLY_DATEMON",
            z.copy_rate AS "COPY_RATE",z.comm_fix_auto_spl AS "COMM_FIX_AUTO_SPL",z.comm_code AS "COMM_CODE",z.waste_rate AS "WASTE_RATE",
            substring(z.comm_rate,1,1) AS "COMM_CATEG_TYPE",substring(z.comm_rate,2,len(z.comm_rate)-1) AS "COMM_RATE",z.supply_copy AS "SUPPLY_COPY",z.rate_supply AS "RATE_SUPPLY",
           z.RETURNABLE
            as "RETURNABLE" ,z.per_copy_weight per_copy_weight 
            ,z.RETURNABLEper
            as "RETURNABLEper"  from--P30,C0.5
            (select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,p.publ_name publ_name,
            d.edtn edtn,edition_nick edtn_name,d.supdate supply_date,
            d.sup_rate copy_rate,d.comm_fix_auto_spl comm_fix_auto_spl,d.comm_code comm_code,
			dbo.cir_get_waste_rate_catg(d.comp_code,d.unit_code,d.edtn,supdate,''''+@pdateformat+'''',d.waste_catg_code,null,null) waste_rate,
            dbo.cir_get_commission(d.comp_code,d.unit_code,d.publ,d.edtn,d.comm_fix_auto_spl ,d.comm_code,d.supdate,''''+@pdateformat+'''',sum(d.sup_copy),'','') comm_rate,
			'P' comm_catg_type, sum(d.sup_copy) supply_copy,sum(d.sup_copy) rate_supply,
			d.per_copy_weight per_copy_weight,d.waste_catg_code waste_catg_code,
			dbo.cir_get_unsold_returnable(d.comp_code,d.publ,sum(d.sup_copy),'A01',@pagcd_code,@pdpcd_code,'Q',d.edtn,'')  
            as "RETURNABLE"
            ,dbo.cir_get_unsold_returnable(d.comp_code,d.publ,sum(d.sup_copy),'A01',@pagcd_code,@pdpcd_code,'P',d.edtn,'')   as "RETURNABLEper"
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
            dbo.cir_get_unsold_returnable(z.comp_code,z.publ,sum(z.supply_copy),'A01',@pagcd_code,@pdpcd_code,'Q',z.edtn,'') 
            as "RETURNABLE",max(z.per_copy_weight) per_copy_weight 
            ,dbo.cir_get_unsold_returnable(z.comp_code,z.publ,sum(z.supply_copy),'A01',@pagcd_code,@pdpcd_code,'P',z.edtn,'') as "RETURNABLEper" from
            (select distinct y.comp_code,y.unit_code,y.publ,y.publ_name,y.edtn,y.edtn_name,y.supply_date,y.copy_rate,y.comm_fix_auto_spl,y.comm_code,y.waste_rate,
            substring(y.comm_rate,1,1) comm_catg_type,substring(y.comm_rate,2,len(y.comm_rate)-1) comm_rate,y.supply_copy,y.rate_supply,
            y.per_copy_weight per_copy_weight from--P30,C0.5
            (select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,p.publ_name publ_name,d.edtn edtn,edition_nick edtn_name,d.supdate supply_date,
            d.sup_rate copy_rate,d.comm_fix_auto_spl comm_fix_auto_spl,d.comm_code comm_code,
			dbo.cir_get_waste_rate_catg(d.comp_code,d.unit_code,d.edtn,d.supdate,''''+@pdateformat+'''',d.waste_catg_code,null,null) waste_rate,
            dbo.cir_get_commission(d.comp_code,d.unit_code,d.publ,d.edtn,d.comm_fix_auto_spl ,d.comm_code,d.supdate,''''+@pdateformat+'''',sum(d.sup_copy),'','') comm_rate,
			'P' comm_catg_type, sum(d.sup_copy) supply_copy,
            (select sum(u.sup_copy) from cir_dbksup u where u.comp_code=d.comp_code and u.unit_code=d.unit_code and 
            (u.publ=d.publ) and u.edtn=d.edtn and u.supdate between @psup_fromdate and @psup_todate and 
            u.billagcd=@pagcd_code and u.billdpcd=@pdpcd_code and u.sup_rate=d.sup_rate) rate_supply,
            d.per_copy_weight per_copy_weight,d.waste_catg_code waste_catg_code
            from cir_dbksup d,cir_publ_mast p,cir_edtn_mast e
            where d.comp_code=@pcomp_code and d.comp_code=p.comp_code and d.comp_code=e.comp_code and
                  d.unit_code=@punit_code and d.publ=p.publ and d.publ=e.publ and
                  (d.publ=@ppubl_code or @ppubl_code is null or @ppubl_code='') and
                  d.edtn=e.edtn and (d.edtn = @pedtn_code or @pedtn_code is null or @pedtn_code='') and
                d.supdate between @psup_fromdate and @psup_todate and
                d.billagcd=@pagcd_code and d.billdpcd=@pdpcd_code and upper(isnull(@pextra1,'D'))='R'
                group by d.comp_code,d.unit_code,d.publ,p.publ_name,e.edition_nick,d.edtn,d.supdate,d.sup_rate,d.comm_fix_auto_spl,d.comm_code,d.per_copy_weight,d.waste_catg_code) y) z
                group by z.comp_code,z.unit_code,z.publ,z.publ_name,z.edtn,z.edtn_name,dbo.GetLastDayOfMonth(z.supply_date),
                    z.copy_rate,z.comm_fix_auto_spl,z.comm_code,z.waste_rate,z.comm_catg_type,z.comm_rate
                order by publ_name,edtn,supply_date
	End
	
	--  this table for permissable days---------
	print('q')
	print(@pcomp_code)
	print(@ppubl_code)
	print(@pagcd_code)
	print(@pdpcd_code)
	print(@preceiptdt)
	print(@psup_fromdate)

	select top 1 ISNULL(z.output,'OK') as OUTPUT from(	
	select distinct dbo.cir_get_unsold_permissable_days
	(@pcomp_code,isnull(@ppubl_code,d.PUBL),'A01',@pagcd_code,@pdpcd_code,'D',@preceiptdt,@psup_fromdate,d.EDTN,'') as output
	,publ,d.EDTN from cir_dbksup d 
	where d.comp_code=@pcomp_code and
	d.unit_code=@punit_code and
	(d.publ=@ppubl_code or @ppubl_code is null or @ppubl_code='')  
	and (d.edtn = @pedtn_code or @pedtn_code is null or @pedtn_code='') 
	and d.supdate between @psup_fromdate and @psup_todate and
	d.billagcd=@pagcd_code and d.billdpcd=@pdpcd_code
	group by d.PUBL,d.EDTN) z where z.output not like 'OK%'
	

                
End




////////////////////////////////////////////end///////////////////////////////////////////////////

*************************************Rikkee Garg **************15/6/12*** Agency wise outstanding summary********
ALTER PROCEDURE [dbo].[cir_rep_outstanding_cir_rep_outstanding_summ_p]
	@pcompcode                                VARCHAR(20) ,
	@punitcode                                VARCHAR(20) ,
	@ppublcode                                VARCHAR(20) ,
	@pactype                                  VARCHAR(20) ,
	@pagency_type                             VARCHAR(20) ,
	@pagcd                                    VARCHAR(20) ,
	@pdpcd                                    VARCHAR(20) ,
	@prep_type                                VARCHAR(20) ,--statewise or districtwise or talukawise or branchwise
	@pcode                                    VARCHAR(20) ,
	@pfromdate                                datetime ,
	@pasondate                                datetime,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000),--it is used for executive
	@pextra2                                  VARCHAR(4000) 
AS
	
Begin 
	
	DECLARE @v_frdt                           DATETIME 
	DECLARE @v_todt                           DATETIME 
	DECLARE @v_opdate                         DATETIME 
	DECLARE @v_opbal                          NUMERIC(15,2)                   
	SET @v_opbal = 0 
	DECLARE @v_clbal                          NUMERIC(15,2)
	SET @v_clbal = 0 
	DECLARE @v_billamt                        NUMERIC(15,2)                           
	SET @v_billamt = 0 
	DECLARE @v_dbcramt                        NUMERIC(15,2)                           
	SET @v_dbcramt = 0 
	DECLARE @v_recamt                         NUMERIC(15,2)                           
	SET @v_recamt = 0 
	DECLARE @v_othdbamt                       NUMERIC(15,2)                           
	SET @v_othdbamt = 0 
	DECLARE @v_othcramt                       NUMERIC(15,2)                           
	SET @v_othcramt = 0 


	DECLARE @v_comp_code1                             varchar(10)
	DECLARE @v_unit1                                  varchar(10)
	DECLARE @v_agcd1                                  varchar(10)
	DECLARE @v_dpcd1                                  varchar(10)
	DECLARE @v_ag_name1                               varchar(50)
	DECLARE @v_ag_name_oth_lang1                      varchar(200)
	DECLARE @v_city_code1                             varchar(200)
	DECLARE @v_tehsil_taluka1                         varchar(200)
	DECLARE @v_dist_code1                             varchar(200)
	DECLARE @v_state_code1                            varchar(200)
	DECLARE @v_country_code1                          varchar(200)

if @ppublcode='' begin
	set @ppublcode=null
end
if @pagency_type=''
begin
	set @pagency_type=null
end
if @pagcd=''
begin
	set @pagcd=null
end
if @pdpcd=''
begin
	set @pdpcd=null
end
if	@pcode=''
begin
	set @pcode=null
end
if	@pextra1=''
begin
	set @pextra1=null
end
if	@pextra2=''
begin
	set @pextra2=null
end
print('0')

CREATE TABLE #CIR_TEMP_OUTSTANDING
( COMP_CODE        VARCHAR(100),
  UNIT_CODE        VARCHAR(100),
  DT               DATETIME,
  PUBL_CODE        VARCHAR(100),
  AGCD             VARCHAR(100),
  DPCD             VARCHAR(100),
  BILL_AMT         NUMERIC(15,2)	DEFAULT 0,
  RETURN_AMT       NUMERIC(15,2)	DEFAULT 0,
  DN_AMT           NUMERIC(15,2)	DEFAULT 0,
  CN_AMT           NUMERIC(15,2)	DEFAULT 0,
  REC_AMT          NUMERIC(15,2)	DEFAULT 0,
  AGNAME           VARCHAR(200),
  AGNAME_OTH_LANG  VARCHAR(250),
  CITY_CODE        VARCHAR(200),
  TALUKA_CODE      VARCHAR(200),
  DIST_CODE        VARCHAR(200),
  STATE_CODE       VARCHAR(200),
  COUNTRY_CODE     VARCHAR(200),
  OP_AMT           NUMERIC(15,2),
  BRANCH_CODE      VARCHAR(8)
);
declare @v_branch_code varchar(8)
	SET @v_opdate  = DBO.cir_get_finandt(@pcompcode, @pfromdate, @pdateformat, '', '')--DBO.cir_get_finandt(@pcompcode, dbo.convert_user_date('/', @pfromdate , @pdateformat), @pdateformat, '', '')

	SET @v_frdt  = @pfromdate--dbo.convert_user_date('/', @pfromdate, @pdateformat)
	SET @v_todt  = @pasondate--dbo.convert_user_date('/', @pasondate, @pdateformat)
	
	
	DECLARE c1 cursor LOCAL FOR 
		SELECT DISTINCT comp_code, unit, agcd, dpcd, ag_name, ag_name_oth_lang, city_code, tehsil_taluka, dist_code,
		state_code, country_code,branch_code
		FROM  cir_agmast 
		WHERE comp_code  = @pcompcode AND unit  = @punitcode 
		AND	(ag_type  = @pagency_type OR	@pagency_type  is null or @pagency_type='')
		AND	(EXECUTIVE_CODE  = @pextra1 OR	@pextra1  is null or @pextra1='')
		/*AND	agcd + dpcd  in
			(SELECT DISTINCT CAST(agcd AS VARCHAR) + CAST(dpcd AS VARCHAR)
			FROM  cir_outmast 
			WHERE comp_code  = @pcompcode AND	unit_code  = @punitcode	AND	achd  = @pactype
			AND	(publ  = @ppublcode OR	@ppublcode  is null OR	@ppublcode = '')) */
			and agcd=isnull(@pagcd,agcd) and dpcd=isnull(@pdpcd,dpcd) and
			(((state_code=@pcode or @pcode is null) and @prep_type='1') or
			((dist_code=@pcode or @pcode is null) and @prep_type='2') or
			((tehsil_taluka=@pcode or @pcode is null) and @prep_type='3')or
			((branch_code=@pcode or @pcode is null) and @prep_type='4'));
		
	OPEN c1 
	fetch NEXT FROM c1 INTO @v_comp_code1 ,@v_unit1, @v_agcd1,@v_dpcd1 ,@v_ag_name1,@v_ag_name_oth_lang1,@v_city_code1,
            @v_tehsil_taluka1, @v_dist_code1, @v_state_code1,@v_country_code1,@v_branch_code

	WHILE (@@FETCH_STATUS = 0) 
	BEGIN 
		SET @v_opbal  = DBO.cir_accounts_cir_agency_opbal(@pcompcode, @punitcode, @ppublcode, @v_agcd1, @v_dpcd1, @v_opdate, @pactype, @pdateformat, @pextra1, @pextra2)
			select @v_billamt =sum(amount) from cir_outmast
                where comp_code=@pcompcode and unit_code=@punitcode and 
                    agcd=@v_agcd1 and dpcd=@v_dpcd1 and billdt >= @v_opdate and billdt<@v_frdt and 
                    achd=@pactype and (publ=@ppublcode or @ppublcode is null OR @ppublcode = '') and recptno is null
                                
            select @v_dbcramt=sum(amount) from cir_rcphdr
                where comp_code=@pcompcode and unit_code=@punitcode  and 
                    agcd=@v_agcd1 and dpcd=@v_dpcd1 and recptdt>= @v_opdate and recptdt<@v_frdt and 
                    achd=@pactype and (publ=@ppublcode or @ppublcode is null OR	@ppublcode = '')
            
			
			select @v_billamt=sum(amount)  from cir_outmast
                where comp_code=@pcompcode and unit_code=@punitcode and 
					agcd=@v_agcd1 and dpcd=@v_dpcd1 and billdt >= @v_frdt and billdt<=@v_todt and 
					achd=@pactype and (publ=@ppublcode or @ppublcode is null OR @ppublcode = '') and recptno is null
            
            select @v_othdbamt=sum(amount) from cir_rcphdr
                where comp_code=@pcompcode and unit_code=@punitcode and 
                            agcd=@v_agcd1 and dpcd=@v_dpcd1 and recptdt>= @v_frdt and recptdt<=@v_todt and 
                            achd=@pactype and (publ=@ppublcode or @ppublcode is null OR @ppublcode = '') and isnull(amount,0)>0;

            select @v_recamt =sum(amount) from cir_rcphdr
                where comp_code=@pcompcode and unit_code=@punitcode and 
                            agcd=@v_agcd1 and dpcd=@v_dpcd1 and recptdt>= @v_frdt and recptdt<=@v_todt and doctype='RCR' and 
                            achd=@pactype and (publ=@ppublcode or @ppublcode is null OR @ppublcode = '') and isnull(amount,0)<0

            select  @v_othcramt=sum(amount) from cir_rcphdr
                where comp_code=@pcompcode and unit_code=@punitcode and 
                            agcd=@v_agcd1 and dpcd=@v_dpcd1 and recptdt>= @v_frdt and recptdt<=@v_todt and doctype<>'RCR' and 
                            achd=@pactype and (publ=@ppublcode or @ppublcode is null OR @ppublcode = '') and isnull(amount,0)<0
			
			set @v_clbal=isnull(@v_opbal,0)+isnull(@v_billamt,0)+isnull(@v_othdbamt,0)+isnull(@v_recamt,0)+isnull(@v_othcramt,0)
			
			if (@v_clbal<>0  or @v_opbal<>0 or @v_billamt<>0 or @v_othdbamt<>0 or @v_recamt<>0 or @v_othcramt<>0)
			BEGIN 
				INSERT INTO  #cir_temp_outstanding (comp_code ,unit_code , dt , publ_code , agcd , dpcd , op_amt , 
				bill_amt , dn_amt , rec_amt , cn_amt , agname , agname_oth_lang , city_code , taluka_code , dist_code , 
				state_code , country_code,BRANCH_CODE )  
				VALUES 	( @v_comp_code1 , @v_unit1 , @v_frdt , @ppublcode , @v_agcd1 , @v_dpcd1 , isnull(@v_opbal, 0) , 
				isnull(@v_billamt, 0) , isnull(@v_othdbamt, 0) , isnull(@v_recamt, 0) , isnull(@v_othcramt, 0) , @v_ag_name1 , 
				@v_ag_name_oth_lang1 , @v_city_code1 , @v_tehsil_taluka1 , @v_dist_code1 , @v_state_code1 , @v_country_code1,@v_branch_code )  
				

			END
   
			SET @v_billamt  = 0 
			SET @v_dbcramt  = 0 
			SET @v_opbal  = 0 
			SET @v_clbal  = 0 
			SET @v_recamt  = 0 
			SET @v_othdbamt  = 0 
			SET @v_othcramt  = 0 
			
            fetch NEXT FROM c1 INTO @v_comp_code1 ,@v_unit1, @v_agcd1,@v_dpcd1 ,@v_ag_name1,@v_ag_name_oth_lang1,@v_city_code1,
            @v_tehsil_taluka1, @v_dist_code1, @v_state_code1,@v_country_code1,@v_branch_code

		END 
		close c1
		
		print('1')
		IF @prep_type = '1' --for statewise group
		BEGIN 
			print('2')
			select a.comp_code comp_code,a.unit_code unit_code,a.state_code rep_type_code,substring(dbo.cir_get_state(a.comp_code,a.country_code,a.state_code),1,30) rep_type_name,
                    a.agcd agcd,a.dpcd dpcd,a.op_amt op_amt,a.bill_amt billamt,a.dn_amt other_dbamt,a.rec_amt recamt,a.cn_amt other_cramt,
                    isnull(a.op_amt,0)+isnull(a.bill_amt,0)+isnull(a.dn_amt,0)+isnull(a.rec_amt,0)+isnull(a.cn_amt,0) cl_amt,
                    a.agname agname,a.agname_oth_lang agname_oth_lang,
                    a.city_code city_code,substring(dbo.cir_get_city(a.comp_code,a.city_code),1,30) city_name
                    from #cir_temp_outstanding a
            order by a.comp_code,a.unit_code,rep_type_name,a.agname
			
			select x.comp_code comp_code,x.unit_code unit_code,x.state_code rep_type_code,x.state_name rep_type_name,sum(x.op_amt) op_amt,sum(x.bill_amt) billamt,sum(x.dn_amt) other_dbamt,
                    sum(x.rec_amt) recamt,sum(x.cn_amt) other_cramt,
                    sum(isnull(x.op_amt,0)+isnull(x.bill_amt,0)+isnull(x.dn_amt,0)+isnull(x.rec_amt,0)+isnull(x.cn_amt,0)) cl_amt from
        (select a.comp_code comp_code,a.unit_code unit_code,a.state_code state_code,substring(dbo.cir_get_state(a.comp_code,a.country_code,a.state_code),1,30) state_name,
                    sum(a.op_amt) op_amt,sum(a.bill_amt) bill_amt,sum(a.dn_amt) dn_amt,sum(a.rec_amt) rec_amt,sum(a.cn_amt) cn_amt,
                    sum(isnull(a.op_amt,0)+isnull(a.bill_amt,0)+isnull(a.dn_amt,0)+isnull(a.rec_amt,0)+isnull(a.cn_amt,0)) cl_amt
                    from #cir_temp_outstanding a
                    group by a.comp_code,a.unit_code,a.state_code,a.country_code) x
                    group by x.comp_code,x.unit_code,x.state_code,x.state_name
            order by comp_code,unit_code,rep_type_name
		END
		else IF @prep_type = '2' 
		BEGIN 
		print('3')
			--for district wise group
			select a.comp_code comp_code,a.unit_code unit_code,a.dist_code rep_type_code,substring(dbo.cir_get_dist(a.comp_code,a.state_code,a.dist_code),1,30) rep_type_name,
                    a.agcd agcd,a.dpcd dpcd,a.op_amt op_amt,a.bill_amt billamt,a.dn_amt other_dbamt,a.rec_amt recamt,a.cn_amt other_cramt,
                    isnull(a.op_amt,0)+isnull(a.bill_amt,0)+isnull(a.dn_amt,0)+isnull(a.rec_amt,0)+isnull(a.cn_amt,0) cl_amt,
                    a.agname agname,a.agname_oth_lang agname_oth_lang,
                    a.city_code city_code,substring(dbo.cir_get_city(a.comp_code,a.city_code),1,30) city_name
                    from #cir_temp_outstanding a
            order by a.comp_code,a.unit_code,rep_type_name,a.agname
		
			select x.comp_code comp_code, x.unit_code unit_code,x.dist_code rep_type_code,x.dist_name rep_type_name,sum(x.op_amt) op_amt,sum(x.bill_amt) billamt,sum(x.dn_amt) other_dbamt,
                    sum(x.rec_amt) recamt,sum(x.cn_amt) other_cramt,
                    sum(isnull(x.op_amt,0)+isnull(x.bill_amt,0)+isnull(x.dn_amt,0)+isnull(x.rec_amt,0)+isnull(x.cn_amt,0)) cl_amt from(
        select a.comp_code comp_code,a.unit_code unit_code,a.dist_code dist_code,substring(dbo.cir_get_dist(a.comp_code,a.state_code,a.dist_code),1,30) dist_name,
                    sum(a.op_amt) op_amt,sum(a.bill_amt) bill_amt,sum(a.dn_amt) dn_amt,sum(a.rec_amt) rec_amt,sum(a.cn_amt) cn_amt,
                    sum(isnull(a.op_amt,0)+isnull(a.bill_amt,0)+isnull(a.dn_amt,0)+isnull(a.rec_amt,0)+isnull(a.cn_amt,0)) cl_amt
                    from #cir_temp_outstanding a
                    group by a.comp_code,a.unit_code,a.state_code,a.dist_code) x
                    group by x.comp_code,x.unit_code,x.dist_code,x.dist_name
            order by comp_code,unit_code,rep_type_name
		
		END
		else IF @prep_type = '3' 
		BEGIN 
			--for talukawise group
			print('4')
			select a.comp_code comp_code,a.unit_code unit_code,a.taluka_code rep_type_code,substring(dbo.cir_get_taluka(a.comp_code,a.taluka_code),1,30) rep_type_name,
                    a.agcd agcd,a.dpcd dpcd,a.op_amt op_amt,a.bill_amt billamt,a.dn_amt other_dbamt,a.rec_amt recamt,a.cn_amt other_cramt,
                    isnull(a.op_amt,0)+isnull(a.bill_amt,0)+isnull(a.dn_amt,0)+isnull(a.rec_amt,0)+isnull(a.cn_amt,0) cl_amt,a.agname agname,a.agname_oth_lang agname_oth_lang,
                    a.city_code city_code,substring(dbo.cir_get_city(a.comp_code,a.city_code),1,30) city_name
                    from #cir_temp_outstanding a
	           order by a.comp_code,a.unit_code,rep_type_name,a.agname
			
			select x.comp_code comp_code,x.unit_code unit_code,x.taluka_code rep_type_code,x.taluka_name rep_type_name,
			sum(x.op_amt) op_amt,sum(x.bill_amt) billamt,sum(x.dn_amt) other_dbamt,sum(x.rec_amt) recamt,sum(x.cn_amt) other_cramt,
                    sum(isnull(x.op_amt,0)+isnull(x.bill_amt,0)+isnull(x.dn_amt,0)+isnull(x.rec_amt,0)+isnull(x.cn_amt,0)) cl_amt from
        (select a.comp_code comp_code,a.unit_code unit_code,a.taluka_code taluka_code,substring(dbo.cir_get_taluka(a.comp_code,a.taluka_code),1,30) taluka_name,
                    sum(a.op_amt) op_amt,sum(a.bill_amt) bill_amt,sum(a.dn_amt) dn_amt,sum(a.rec_amt) rec_amt,sum(a.cn_amt) cn_amt,
                    sum(isnull(a.op_amt,0)+isnull(a.bill_amt,0)+isnull(a.dn_amt,0)+isnull(a.rec_amt,0)+isnull(a.cn_amt,0)) cl_amt
                    from #cir_temp_outstanding a
                    group by a.comp_code,a.unit_code,a.taluka_code)x
                    group by x.comp_code,x.unit_code,x.taluka_code,x.taluka_name
            order by comp_code,unit_code,rep_type_name;
			
		END
		else 
		begin
		print('8')

			select a.comp_code comp_code,a.unit_code unit_code,a.branch_code branch_code,dbo.AD_GET_BRANCHNAME (a.comp_code,a.branch_code) rep_type_name,
			a.agcd agcd,a.dpcd dpcd,a.op_amt op_amt,a.bill_amt billamt,a.dn_amt other_dbamt,a.rec_amt recamt,a.cn_amt other_cramt,
			isnull(a.op_amt,0)+isnull(a.bill_amt,0)+isnull(a.dn_amt,0)+isnull(a.rec_amt,0)+isnull(a.cn_amt,0) cl_amt,
			a.agname agname,a.agname_oth_lang agname_oth_lang,
			a.city_code city_code,substring(dbo.cir_get_city(a.comp_code,a.city_code),1,30) city_name
			from #cir_temp_outstanding a
			order by a.comp_code,a.unit_code,a.branch_code,a.agname;

			select x.comp_code comp_code,x.unit_code unit_code,x.branch_code rep_type_code,x.branch_Name rep_type_name,
			sum(x.op_amt) op_amt,sum(x.bill_amt) billamt,sum(x.dn_amt) other_dbamt,
			sum(x.rec_amt) recamt,sum(x.cn_amt) other_cramt,
			sum(isnull(x.op_amt,0)+isnull(x.bill_amt,0)+isnull(x.dn_amt,0)+isnull(x.rec_amt,0)+isnull(x.cn_amt,0)) cl_amt from
			(select a.comp_code comp_code,a.unit_code unit_code,a.branch_code branch_code,dbo.AD_GET_BRANCHNAME (a.comp_code,a.branch_code) branch_name,
			sum(a.op_amt) op_amt,sum(a.bill_amt) bill_amt,sum(a.dn_amt) dn_amt,sum(a.rec_amt) rec_amt,sum(a.cn_amt) cn_amt,
			sum(isnull(a.op_amt,0)+isnull(a.bill_amt,0)+isnull(a.dn_amt,0)+isnull(a.rec_amt,0)+isnull(a.cn_amt,0)) cl_amt
			from #cir_temp_outstanding a
			group by a.comp_code,a.unit_code,a.country_code,a.branch_code) x
			group by x.comp_code,x.unit_code ,x.branch_code ,x.branch_Name 
			order by comp_code,unit_code,rep_type_name;

		end



 DEALLOCATE c1
	drop table #cir_temp_outstanding;
End



***************************end of Agency wise outstanding summary**************************************************

*************************** Rikkee Garg tax master 18/6/12 ********************


alter procedure [dbo].[cir_bostwana_tax_mast]

@pcomo_code   varchar(8),
@ptaxtypeid   varchar(20),
@ptaxid        varchar(20),
@pvaliddate    date,
@ptaxcalctype    varchar(20),
@ptaxrate         varchar(20),
@ptaxstatus      varchar(20),
@pquery_type     varchar(20),
@pextra1        varchar(20),
@pextra2       varchar(20),
@pextra3       varchar(20),
@pextra4        varchar(20),
@puserid        varchar(20)


AS
begin
if (@pquery_type = 'I')

Begin
insert into CIR_TAX_MAST(COMP_CODE,TAX_TYPE_ID,TAX_ID,VALID_FROM,TAX_CALC_TYPE,TAX_RATE,TAX_STATUS,CREATED_BY,CREATED_DT)
values(@pcomo_code,@ptaxtypeid,@ptaxid,@pvaliddate,@ptaxcalctype,@ptaxrate,@ptaxstatus,@puserid,GETDATE())

end
if(@pquery_type = 'U')
begin
update CIR_TAX_MAST set  TAX_TYPE_ID =@ptaxtypeid,VALID_FROM = @pvaliddate,TAX_CALC_TYPE = @ptaxcalctype,TAX_RATE = @ptaxrate ,TAX_STATUS = @ptaxstatus,UPDATED_BY = @puserid,UPDATED_DT=GETDATE()

where TAX_ID = @ptaxid
end
end

******************************** end of tax master******************************

*********************Rikkee Garg **********issue no.6589***************************21/6/12****

USE [abhi]
GO
/****** Object:  StoredProcedure [dbo].[cir_unsold_supply_for_transfer]    Script Date: 06/21/2012 10:38:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER procedure [dbo].[cir_unsold_supply_for_transfer]
    @pcomp_code         as varchar(20),
    @punit_code         as varchar(20),
    @pbran_code         as varchar(20),
    @pfromdate          as varchar(20),
    @ptilldate          as varchar(20),
    @puserid            as varchar(20),   
    @pdateformat        as varchar(20),
    @pextra1            as varchar(200),--for publication
    @pextra2            as varchar(200),
    @pextra3            as varchar(200),
    @pextra4            as varchar(200),
    @pextra5            as varchar(200),
    @pextra6            as varchar(200),
    @pextra7            as varchar(200),
    @pextra8            as varchar(200),               
    @pextra9            as varchar(200),
    @pextra10           as varchar(200)
As
Begin
	
    declare @v_process_id    numeric(30)
	DECLARE @v_frdt  DATETIME
	DECLARE @v_todt  DATETIME

	SET @v_frdt  =  DBO.convert_user_date('/', @pfromdate,@pdateformat)
	SET @v_todt   =  DBO.convert_user_date('/', @ptilldate,@pdateformat)

PRINT(@v_frdt)
PRINT(@v_todt)
    exec cir_generate_processid @pcomp_code,@puserid,@pdateformat,null,null,null,null,null,@v_process_id OUTPUT
    
    select distinct d.comp_code as "COMP_CODE",d.unit_code as "UNIT_CODE",d.branch_code as "BRANCH_CODE",d.doctype as "DOCTYPE",
    d.recptno as "RECPTNO",d.recptdt as "RECPTDT",d.sup_agcd as "SUP_AGCD" ,d.sup_dpcd as "SUP_DPCD",m.ag_name as "SUPPLY_AGENCY",
    dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) drop_point_name, dbo.cir_get_city(d.comp_code,m.city_code) city_name,
    dbo.cir_get_agency(d.comp_code,d.unit_code,d.agcd,d.dpcd) as "BILLING_AGENCY",
    sum(isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0)+isnull(apr_damage,0)) as "TOTAL_UNSOLD",
    @v_process_id as "PROCESS_IDNO" 
    from cir_unsold_hdr h,cir_unsold_dtl d,cir_agmast m
    where h.comp_code=d.comp_code and h.comp_code=m.comp_code and h.comp_code=@pcomp_code and h.unit_code=d.unit_code and h.unit_code=m.unit and h.unit_code=@punit_code and 
    h.doctype=d.doctype and h.doctype='UCN' and h.recptno=d.recptno and h.recptdt=d.recptdt and h.recptdt between @v_frdt and @v_todt and --@pfromdate and @ptilldate and 
    h.agcd=isnull(d.sup_agcd,d.agcd) and h.agcd=m.agcd and h.dpcd=isnull(d.sup_dpcd,d.dpcd) and h.dpcd=m.dpcd and 
    d.branch_code=isnull(@pbran_code,d.branch_code) and (isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0)+isnull(apr_damage,0))>0 and
    (h.branch_trfno is null or h.branch_trfno='') and (h.PUBL=@pextra1 or @pextra1 is null or @pextra1='')
    group by d.comp_code,d.unit_code,d.branch_code,d.doctype,d.recptno,d.recptdt,d.sup_agcd,d.sup_dpcd,m.ag_name,m.station_code, m.city_code,d.agcd,d.dpcd
    order by comp_code,unit_code,recptdt,recptno;
	
        
End




*************************end of issue 6589***************************************



////////////////////////////////////add by Deepika 22/06/2012 sent by amit sir////////////////////////////////////

ALTER PROCEDURE [dbo].[cir_unsold_credit_note_cir_notapproval_unsold_p]
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
		SELECT *,cast(round((RETURN_PER*SUPPLY_COPY)/100,0) as int) as RETURNABLE FROM  cir_unsold_dtl 
		WHERE comp_code  = @pcomp_code AND unit_code  = @punit_code
		 AND doctype  = @pdoc_type AND recptno  = @precptno
		 --AND (agcd  = @pagcd_code or @pagcd_code='' or @pagcd_code is null) 
		 --AND (dpcd  = @pdpcd_code or @pdpcd_code='' or @pdpcd_code is null)
		ORDER BY recptdt,recptno,supdate 
	End
End

/////////////////////////////////////

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
		dbo.cir_get_agency(cir_agmast_dis.comp_code,cir_agmast_dis.unit,cir_agmast_dis.BILL_AGCD,cir_agmast_dis.BILL_AGCD) "BILL_AGENCY",
		dbo.cir_get_agency_city(cir_agmast_dis.comp_code,cir_agmast_dis.unit,cir_agmast_dis.agcd,cir_agmast_dis.dpcd) "BILL_AGENCY_CITY",
		dbo.cir_get_drop_point_name(cir_agmast_dis.comp_code,cir_agmast_dis.unit,cir_agmast_dis.station_code,1) as "DROP_POINT_NAME"
		FROM  cir_agmast_dis 
		WHERE comp_code  = @pcompcode AND unit  = @punit and(dist_code =@pdistcode or @pdistcode is null)
		 AND ((UPPER(ag_name)  like UPPER(CAST(@pextra1 AS VARCHAR) + '%')) OR	(@pextra1  is null) OR	(@pextra1  = ''))
		 /*AND ISNULL(freeze_flag, 'N')  = 'N'*/
		union
		SELECT cir_agmast_dis.*,dbo.cir_get_city(cir_agmast_dis.comp_code,cir_agmast_dis.city_code) "CITY_NAME",
		dbo.cir_get_agency(cir_agmast_dis.comp_code,cir_agmast_dis.unit,cir_agmast_dis.BILL_AGCD,cir_agmast_dis.BILL_AGCD) "BILL_AGENCY",
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
		dbo.cir_get_agency(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.BILL_AGCD,cir_agmast.BILL_DPCD) "BILL_AGENCY",
		dbo.cir_get_agency_city(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.agcd,cir_agmast.dpcd) "BILL_AGENCY_CITY",
		dbo.cir_get_drop_point_name(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.station_code,1) as "DROP_POINT_NAME"
			FROM  cir_agmast 
			WHERE comp_code  = @pcompcode AND unit  = @punit and(dist_code =@pdistcode or @pdistcode is null)
			 AND ((UPPER(ag_name)  like UPPER(CAST(@pextra1 AS VARCHAR) + '%')) OR	(@pextra1  is null) OR	(@pextra1  = ''))
			 /*AND ISNULL(freeze_flag, 'N')  = 'N'*/
		union
		SELECT cir_agmast.*,dbo.cir_get_city(cir_agmast.comp_code,cir_agmast.city_code) "CITY_NAME",
		dbo.cir_get_agency(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.BILL_AGCD,cir_agmast.BILL_DPCD) "BILL_AGENCY",
		dbo.cir_get_agency_city(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.agcd,cir_agmast.dpcd) "BILL_AGENCY_CITY",
		dbo.cir_get_drop_point_name(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.station_code,1) as "DROP_POINT_NAME"
			FROM  cir_agmast 
			WHERE comp_code  = @pcompcode AND unit  = @punit and(dist_code =@pdistcode or @pdistcode is null)
			 AND ((UPPER(agcd)  like UPPER(CAST(@pextra1 AS VARCHAR) + '%')) OR	(@pextra1  is null) OR	(@pextra1  = ''))
			 /*AND ISNULL(freeze_flag, 'N')  = 'N'*/			 
			ORDER BY 5
	End
END



///////////////////////////////////////////////////////////////

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
        h.SUP_AGCD=d.SUP_AGCD and h.SUP_AGCD=@pagcd and h.SUP_DPCD=d.SUP_DPCD and h.SUP_DPCD=@pdpcd and 
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
        h.SUP_AGCD=d.SUP_AGCD and h.SUP_AGCD=@pagcd and h.SUP_DPCD=d.SUP_DPCD and h.SUP_DPCD=@pdpcd and 
        (isnull(d.var_short_recpt,0)+isnull(d.var_late_recpt,0)+isnull(d.var_bnr,0)+isnull(d.var_unsold,0)+isnull(d.var_damage,0))-
        (isnull(d.apr_short_recpt,0)+isnull(d.apr_late_recpt,0)+isnull(d.apr_bnr,0)+isnull(d.apr_unsold,0)+isnull(d.apr_damage,0))>0
        order by recptdt,recptno,publ,edtn,supdate;
	End
           

End

////////////////////////////////////




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
		and recptno=@pd_rcptno and recptdt=@v_recptdt and SUP_AGCD=@pd_agcode and SUP_DPCD=@pd_agsubcode;
	End
    Else Begin
        select distinct isnull(var_unsold,0) as "V_UNSOLD",isnull(var_short_recpt,0) as "V_SHORT",
		isnull(var_damage,0) as "V_DAMAGE",isnull(var_late_recpt,0) as "V_LATEREC",isnull(var_bnr,0) as "V_BNR",
		isnull(apr_unsold,0) as "A_UNSOLD",isnull(apr_short_recpt,0) as "A_SHORT",
		isnull(apr_damage,0) as "A_DAMAGE",isnull(apr_late_recpt,0) as "A_LATEREC",isnull(apr_bnr,0) as "A_BNR"
		from cir_unsold_dtl
        where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and supdate=@v_supdt
		and recptno=@pd_rcptno and recptdt=@v_recptdt 
		and SUP_AGCD=@pd_agcode and SUP_DPCD=@pd_agsubcode;
	End
           

End








////////////////////////////////////////////////////end////////////////////////////////////////////////////////////



///////////////////////////////////////////add by Deepika 22/06/2012 for lable print///////////////////////////////////




                                                              
                                             
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
	@pextra1                                  VARCHAR(400) , -- flag
	@pextra2                                  VARCHAR(400) 
AS 
		DECLARE @vdate      DATETIME 
     	SET @vdate  =  dbo.convert_user_date('/',@plbldt,@pdateformat)


if(@pextra1='P')
begin
	select  a.*,DBO.cir_get_mode_name(comp_code, route1) MODE_NAME,
          SUBSTRING(DBO.cir_get_name_cir_edtn(comp_code,unit_code,edtn  ,'1',@pdateformat,'',''),1,30) EDTN_NAME,
          (select distinct reg_no from cir_edtn_mast where comp_code = @pcomp_code and edtn=a.edtn_1) AS "REG_NO",
          (select sum(supply_1) from cir_lblmast t where t.comp_code=a.comp_code and t.unit_code=a.unit_code and 
           t.lbl_dt=a.lbl_dt and t.agcd=a.agcd and t.dpcd=a.dpcd and t.publ=a.publ and a.edtn=a.edtn) as "TOTAL_SUPPLY_COPY",
          (select station_code from cir_agmast where cir_agmast.comp_code=a.comp_code and
          cir_agmast.unit=a.unit_code and cir_agmast.agcd=a.agcd  and cir_agmast.dpcd=a.dpcd) as "STATION_CODE" 
          from cir_lblMAST a
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
					
end
else if(@pextra1='F')
begin  --  %2440+93KS+40260509KS+95090526!
	select distinct upper('%2440+93' +substring(e.EDITION_NICK,1,2)+ '          ' +  '+40'+replace(CONVERT(varchar(8),a.lbl_dt,3),'/','')
	 +substring(e.EDITION_NICK,1,2) + '+95' + CONVERT(varchar(6),a.lbl_dt,12) + '!') as VAL
	 ,upper(replace(CONVERT(varchar(8),a.lbl_dt,3),'/','') +substring(e.EDITION_NICK,1,2)) as FILENAME
	 from cir_lblMAST a,CIR_EDTN_MAST e
             where a.comp_code = @pcomp_code and a.COMP_CODE=e.COMP_CODE and a.EDTN=e.EDTN and
                   a.unit_code = @punit_code and 
                   lbl_dt    =@vdate and 
                   ((a.publ    = @ppubl) or (@ppubl is null) or (@ppubl ='')) and 
                   ((isnull(a.edtn,edtn_1)    = @pedtn) or (@pedtn is null) or (@pedtn='')) and
                   isnull(a.edtn,edtn_1) in(select edtn from cir_edtn_mast where comp_code=@pcomp_code and 
                   (a.unit_code=@punit_code or @punit_code is null or @punit_code='') and ((edtn = @pedtn) or (@pedtn is null) or (@pedtn='')) and 
					(main_edtn=@pmainedtn or @pmainedtn is null) or @pmainedtn ='') and
                   ((route1   = @proute) or (@proute is null) or (@proute='')) and 
                   ((agcd    = @pagcd) or (@pagcd is null) or (@pagcd='')) and 
                   ((dpcd    = @pdpcd) or (@pdpcd is null) or (@pdpcd=''))
                   
    select distinct '%2401+11'+ a.ROUTE1+'         '+'+7900'+ substring(a.ROUTE1,2,LEN(a.route1))+'!' as VAL   from cir_lblMAST a
             where a.comp_code = @pcomp_code and
                   a.unit_code = @punit_code and 
                   lbl_dt    =@vdate and 
                   ((a.publ    = @ppubl) or (@ppubl is null) or (@ppubl ='')) and 
                   ((isnull(a.edtn,edtn_1)    = @pedtn) or (@pedtn is null) or (@pedtn='')) and
                   isnull(a.edtn,edtn_1) in(select edtn from cir_edtn_mast where comp_code=@pcomp_code and 
                   (a.unit_code=@punit_code or @punit_code is null or @punit_code='') and ((edtn = @pedtn) or (@pedtn is null) or (@pedtn='')) and 
					(main_edtn=@pmainedtn or @pmainedtn is null) or @pmainedtn ='') and
                   ((route1   = @proute) or (@proute is null) or (@proute='')) and 
                   ((agcd    = @pagcd) or (@pagcd is null) or (@pagcd='')) and 
                   ((dpcd    = @pdpcd) or (@pdpcd is null) or (@pdpcd=''))	
					
	select '%2402+11'+ a.ROUTE1+'         '+'+30'+dbo.fnPadLeft('0',4,a.PKT_SIZE)+'+31'+dbo.fnPadLeft('0',4,a.PKT_SIZE)+
	'+32'+dbo.fnPadLeft('0',4,a.PKT_SIZE)+'+33'+dbo.fnPadLeft('0',4,a.PKT_SIZE)+'+34'+dbo.fnPadLeft('0',4,a.PKT_SIZE)+
	'+350000+591+91000000+56001+20'+upper(dbo.fnPadright(' ',30, e.EDITION_NICK+' - '+e.EDTN_NAME))+'!' as VAL
	  from cir_lblMAST a,CIR_EDTN_MAST e
             where a.comp_code = @pcomp_code and a.COMP_CODE=e.COMP_CODE and a.EDTN=e.EDTN and
                   a.unit_code = @punit_code and 
                   lbl_dt    =@vdate and 
                   ((a.publ    = @ppubl) or (@ppubl is null) or (@ppubl ='')) and 
                   ((isnull(a.edtn,edtn_1)    = @pedtn) or (@pedtn is null) or (@pedtn='')) and
                   isnull(a.edtn,edtn_1) in(select edtn from cir_edtn_mast where comp_code=@pcomp_code and 
                   (a.unit_code=@punit_code or @punit_code is null or @punit_code='') and ((edtn = @pedtn) or (@pedtn is null) or (@pedtn='')) and 
					(main_edtn=@pmainedtn or @pmainedtn is null) or @pmainedtn ='') and
                   ((route1   = @proute) or (@proute is null) or (@proute='')) and 
                   ((agcd    = @pagcd) or (@pagcd is null) or (@pagcd='')) and 
                   ((dpcd    = @pdpcd) or (@pdpcd is null) or (@pdpcd=''))	
                   
                   
	select  '%2403+12'+upper(dbo.fnPadright(' ',10, a.AGCD))+'+13' + 
	dbo.fnPadright('0',5, 
	(select sum(supply_1) from cir_lblmast t where t.comp_code=a.comp_code and t.unit_code=a.unit_code and 
           t.lbl_dt=a.lbl_dt and t.agcd=a.agcd and t.dpcd=a.dpcd and t.publ=a.publ and a.edtn=a.edtn)
	)+
	'+08'+dbo.fnPadright(' ',50,a.agname)+'+56001!' as "VAL1",
	'%2414+580204'+dbo.fnPadright(' ',30,upper(SUBSTRING(DBO.cir_get_name_cir_edtn(comp_code,unit_code,edtn  ,'1',@pdateformat,'',''),1,30)))
	+dbo.fnPadright(' ',30,CONVERT(varchar(10),a.lbl_dt,103))+a.ROUTE1+ dbo.fnPadright(' ',30,a.RTNM)+'.         '+
	+dbo.fnPadright(' ',6,CONVERT(varchar(10),a.AGCD,103))	+ dbo.fnPadright(' ',50,a.agname)+	
	dbo.fnPadright('0',10, 
	(select sum(supply_1) from cir_lblmast t where t.comp_code=a.comp_code and t.unit_code=a.unit_code and 
           t.lbl_dt=a.lbl_dt and t.agcd=a.agcd and t.dpcd=a.dpcd and t.publ=a.publ and a.edtn=a.edtn)
	)
	+'.                             !'
	as "VAL2"
          from cir_lblMAST a
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
end
else if(@pextra1='W')
begin
	select a.ROUTE1 as "Route_Code"
	,(Select z.DROP_POINT_SEQNO from CIR_DROP_POINT_MAST z where z.COMP_CODE=a.Comp_Code and z.DROP_POINT= 
	(Select distinct x.STATION_CODE from cir_agmast x where x.COMP_CODE=a.Comp_Code and x.AGCD=a.agcd ) ) as "Drop_point_seq_no"
	,(Select x.STATION_CODE from cir_agmast x where x.COMP_CODE=a.Comp_Code and x.AGCD=a.agcd ) as "Drop_Point_Code"
	,a.AGCD as "Dealer_Code",
	(select sum(supply_1) from cir_lblmast t where t.comp_code=a.comp_code and t.unit_code=a.unit_code and 
    t.lbl_dt=a.lbl_dt and t.agcd=a.agcd and t.dpcd=a.dpcd and t.publ=a.publ and a.edtn=a.edtn) as "Order_Qty"
    ,'L' as "Default_text" from cir_lblMAST a
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
			ORDER BY edtn,lbl_dt
					
	select top 1 replace(CONVERT(varchar(5),@plbldt,103),'/','')+ upper(substring(x.EDITION_NICK,1,2)) as FILENAME
	from CIR_EDTN_MAST X where x.COMP_CODE=@pcomp_code and x.EDTN=@pedtn
end
else -- M
begin
	select '\105:'+cir_lblmast.PUBL_NAME As "F5"
	,'\106:'+SUBSTRING(DBO.cir_get_name_cir_edtn(comp_code,unit_code,edtn  
	,'1',@pdateformat,'',''),1,30) AS "F6"
	 , AGCD+DPCD as "D2"
	 ,';\101:'+cast(cir_lblmast.unpaid_copy as varchar) as "F1"
	 ,'\102:'+ cast (((cir_lblmast.lbl_tno*pkt_size)+isnull(supply_1,0)) - isnull(cir_lblmast.unpaid_copy,0) as varchar) as "F2"
	 ,'\103:'+cast(cir_lblmast.LBL_SNO as varchar) as "F3"
	 ,'\104:'+cir_lblmast.RTNM as "F4"
	 ,'\107:'+cir_lblmast.AGNAME as "F7"
	 ,'\108:'+cir_lblmast.STATION_NAME as "F8"
	 ,'\109:'+'remark' as "F9"
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
	ORDER BY 1,2
	
	select top 1 replace(CONVERT(varchar(5),@plbldt,103),'/','')+ upper(substring(x.EDITION_NICK,1,2))+'_T' as FILENAME
	from CIR_EDTN_MAST X where x.COMP_CODE=@pcomp_code and x.EDTN=@pedtn
	

end


////////////////////////////////////////////////////////end/////////////////////////////////////////////////////////////





//************************Report No.37*****Average To Date[Report]*****Added By Meenakshi***********************************


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
ALTER procedure  [dbo].[cir_rep_netsales_avg_p](
     @pcomp_code          varchar(8),
     @punit_code          varchar(8),
     @ppubl               varchar(200),
     @pmainedtn           varchar(200),
     @pedtn               varchar(200),
     @pfromdate           varchar(200),
     @ptilldate           varchar(200),
     @pagency_type        varchar(200),
     @pagency_class       varchar(200),
     @pstatecode          varchar(200),
     @pdistcode           varchar(200),
     @ptaluka             varchar(200),
     @pbranch             varchar(200),
     @pagcd               varchar(200),
     @pdpcd               varchar(200),
     @preptype            int,--1 for branch 
     @pbreak_on           varchar(200),--branch b 
     @preturn_based       varchar(200),--it is use for return date or supply date(r/s)
     @plangtype           varchar(200),
     @pdateformat         varchar(200),
     @pextra1             varchar(200),---for zone 
     @pextra2             varchar(200),---for region
     @pextra3             varchar(200),---for commission
     @pextra4             varchar(200),---for publication type
     @pextra5             varchar(200)
     )
  as     
  	
  begin
	declare @v_frdt    datetime;
	declare  @v_todt   datetime;

	print('sdfsdfsd')
	set @v_frdt  = @pfromdate
	set @v_todt  = @ptilldate

		
		declare  @v_reg_code varchar(200);
		declare @v_zone_code varchar(200);
		declare @v_publ_code varchar(200);
		declare  @v_avg_sale numeric(10);

/*****declare for cursor*************/
declare  @v1_net_sale_copy  numeric(20)
declare  @v1_unit_code       varchar(500)
declare  @v1_comp_code     varchar(500)
declare  @v1_publ          varchar(500)
declare  @v1_city_code     varchar(500)
declare  @v1_branch_name     varchar(500)
declare  @v1_publ_name       varchar(500)
declare  @v1_main_edtn_code   varchar(500)
declare  @v1_main_edtn_name   varchar(500)
declare  @v1_edtn_name        varchar(500)
declare  @v1_agname          varchar(500)
declare  @v1_agname_oth_lang     varchar(500)
declare  @v1_city_name     varchar(500)
declare  @v1_taluka_name     varchar(500)
declare  @v1_dist_name     varchar(500)
declare  @v1_state_name     varchar(500)
declare  @v1_supply_copy  numeric(20)
declare  @v1_return_copy  numeric(20)
declare  @v1_copy_rate  numeric(20,2)
declare  @v1_no_of_days  numeric(20)
declare  @v1_route_name     varchar(500)
declare  @v1_print_center     varchar(500)
declare  @v1_supply_avg_todt  numeric(20,2)
declare  @v1_ret_avg_todt  numeric(20,2)
declare  @v1_net_avg_todt  numeric(20,2)
declare  @v1_per_avg_todt  numeric(20,2)
declare  @v1_branch_code  varchar(500)
declare  @v1_edtn_code  varchar(500)
declare  @v1_agcd  varchar(500)
declare  @v1_dpcd  varchar(500)

declare  @v1_state_code  varchar(500)
declare  @v1_dist_code  varchar(500)
declare  @v1_talu_code  varchar(500)
declare  @v1_route_code  varchar(500)

CREATE TABLE #CIR_TEMP_BILL_COLLECTION
(
  COMP_CODE           VARCHAR(100),
  UNIT_CODE           VARCHAR(100),
  BILLNO              VARCHAR(200),
  BILLDT              DATEtime,
  PUBL_CODE           VARCHAR(100),
  AGCD                VARCHAR(100),
  DPCD                VARCHAR(100),
  SUPPLY_COPY         NUMERIC(10)                DEFAULT 0,
  GROSS_AMT           NUMERIC(15,2)              DEFAULT 0,
  COMM_AMT            NUMERIC(15,2)              DEFAULT 0,
  SUR_AMT             NUMERIC(15,2)              DEFAULT 0,
  RETURN_COPY         NUMERIC(10)                DEFAULT 0,
  RETURN_AMT          NUMERIC(15,2)              DEFAULT 0,
  DN_AMT              NUMERIC(15,2)              DEFAULT 0,
  CN_AMT              NUMERIC(15,2)              DEFAULT 0,
  REC_AMT             NUMERIC(15,2)              DEFAULT 0,
  PREV_BAL            NUMERIC(15,2)              DEFAULT 0,
  CUR_SESSIONID       integer,
  AGNAME              VARCHAR(200),
  AGNAME_OTH_LANG     VARCHAR(250),
  CITY_CODE           VARCHAR(200),
  TALUKA_CODE         VARCHAR(200),
  DIST_CODE           VARCHAR(200),
  STATE_CODE          VARCHAR(200),
  REMARKS             VARCHAR(500),
  RET_COMM_AMT        NUMERIC(15,2),
  BILL_SEC_AMT        NUMERIC(15,2),
  SEC_OPBAL           NUMERIC(15,2),
  ZONE_CODE           VARCHAR(200),
  REGION_CODE         VARCHAR(200),
  PRO_TYPE            VARCHAR(200),
  COMM_CODE           VARCHAR(200),
  ROUTE_CODE          VARCHAR(200),
  PRINTING_CENT_CODE  VARCHAR(200),
  SUPPLY_AVG_TODT     NUMERIC(15,2),
  RETURN_AVG_TODT     NUMERIC(15,2),
  NET_AVG_TODT        NUMERIC(15,2),
  PER_AVG_TODT        NUMERIC(15,2),
  BILL_COUNT          INTEGER
)

declare c1 cursor for
    select u.comp_code,u.unit_code,dbo.fa_get_print_cent_name(u.comp_code,u.unit_code) "CENTER_NAME",
    u.branch_code branch_code,(select distinct "Branch_Name" from branch_mst where "Branch_Code"=u.branch_code) branch_name,
    u.publ,u.publ_name,u.main_edtn,
    dbo.cir_get_edtn_name(u.comp_code,u.main_edtn) main_edtn_name,u.edtn edtn,u.edtn_name,u.copy_rate,
    u.agcd agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang agname_oth_lang,
    u.state_code,dbo.cir_get_state(u.comp_code,u.country_code,u.state_code) state_name,
    u.dist_code ,dbo.cir_get_name_cir_district(u.comp_code,u.dist_code,@plangtype,null,null,null) dist_name,
    u.city_code city_code,dbo.cir_get_name_cir_city(u.comp_code,u.city_code,@plangtype,null,null,null) city_name,
    u.tehsil_taluka,dbo.cir_get_name_cir_taluka(u.comp_code,u.tehsil_taluka,@plangtype,null,null,null) taluka_name,
	u.route_code,dbo.cir_get_route_name(u.comp_code,u.unit_code,u.route_code ) route_name,
	dbo.fa_get_print_cent_name(u.comp_code,u.unit_code) print_center,
	sum(supply_copy) supply_copy,     
    round(sum(supply_copy)/  sum(no_of_days),2) supply_avg_todt,    
    sum(return_copy) return_copy,	
	round(sum(return_copy)/sum(no_of_days),2) ret_avg_todt,    
    sum(supply_copy)-sum(return_copy) net_sale_copy,    
    sum(supply_copy)-sum(return_copy)/sum(no_of_days) net_avg_todt,	
	sum(no_of_days) no_of_days,0 per_avg_todt
    from (
    select b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.sup_rate copy_rate,
    b.agcd,b.dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
    a.branch_code,a.city_code,a.dist_code, a.state_code,a.country_code,a.tehsil_taluka,b.route_code, 
    sum(isnull(b.sup_copy,0)) supply_copy,0 return_copy, count(distinct supdate) no_of_days 
	from cir_agmast a,cir_dbksup b,cir_edtn_mast e,cir_publ_mast p,cir_city_mast c
    where b.comp_code =a.comp_code and b.comp_code=e.comp_code and b.comp_code=p.comp_code and a.comp_code=c.comp_code and
    b.comp_code =@pcomp_code and 
    b.unit_code=a.unit and b.unit_code=@punit_code and 
    b.publ=p.publ and (b.publ=isnull(@ppubl,b.publ) or @ppubl='') and b.edtn=e.edtn and (b.edtn=isnull(@pedtn,b.edtn) or @pedtn='') and
    a.agcd=b.agcd and (b.agcd=isnull(@pagcd,b.agcd) or @pagcd='') and a.dpcd=b.dpcd and (b.dpcd=isnull(@pdpcd,b.dpcd) or @pdpcd='') and
	a.city_code=c.city_code and 
    b.supdate >= @v_frdt and b.supdate <=@v_todt and 
    (a.ag_type=@pagency_type or @pagency_type is null or @pagency_type='') and(a.ag_class=@pagency_class or @pagency_class is null or @pagency_class='') and
    (a.branch_code=@pbranch or @pbranch is null or @pbranch='') and (a.state_code=@pstatecode or @pstatecode is null or @pstatecode='') and
    (a.dist_code=@pdistcode or @pdistcode is null or @pdistcode='') and (a.tehsil_taluka=@ptaluka or @ptaluka is null or @ptaluka='') and
    (e.main_edtn=@pmainedtn or @pmainedtn is null or @pmainedtn='')
	and (c.zone_code=@pextra1   or @pextra1  is null or @pextra1='') 
	and (c.region_code=@pextra2 or @pextra2 is null or @pextra2='')
	and (b.comm_code=@pextra3 or @pextra3 is null or @pextra3='')
	and (p.pro_type=@pextra4 or @pextra4 is null or @pextra4='')
    group by b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.sup_rate,
    b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.branch_code,a.city_code,a.dist_code, a.state_code,
    a.country_code,a.tehsil_taluka,b.route_code
    union all
    select b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.copy_rate,
    b.agcd,b.dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
    a.branch_code,a.city_code,a.dist_code, a.state_code,a.country_code,a.tehsil_taluka,d.route_code, 
    0 supply_copy,sum(isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0)) return_copy,0 no_of_days
    from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e,cir_publ_mast p,cir_city_mast c,cir_dbksup d
    where b.comp_code =a.comp_code and b.comp_code=e.comp_code and b.comp_code=p.comp_code and b.comp_code =@pcomp_code 
	and a.comp_code=c.comp_code and b.comp_code=d.comp_code and
    b.unit_code=a.unit and b.unit_code=d.unit_code and b.unit_code=@punit_code and 
    b.doctype='UCN' and b.recptdt >= @v_frdt and b.recptdt <=@v_todt and 
    b.publ=e.publ and b.publ=p.publ and b.publ=d.publ and (b.publ=isnull(@ppubl,b.publ) or @ppubl='') and b.edtn=e.edtn and 
b.edtn=d.edtn and (b.edtn=isnull(@pedtn,b.edtn) or @pedtn='') and 
    a.agcd=b.agcd and a.agcd=d.agcd and (b.agcd=isnull(@pagcd,b.agcd) or @pagcd='') and a.dpcd=b.dpcd and a.dpcd=d.dpcd 
and (b.dpcd=isnull(@pdpcd,b.dpcd) or @pdpcd='') and 
	a.city_code=c.city_code and 
    (a.ag_type=@pagency_type or @pagency_type is null or @pagency_type='') and(a.ag_class=@pagency_class or @pagency_class is null or @pagency_class='') and
    (a.branch_code=@pbranch or @pbranch is null) and (a.state_code=@pstatecode or @pstatecode is null or @pstatecode='') and
    (a.dist_code=@pdistcode or @pdistcode is null or @pdistcode='') and (a.tehsil_taluka=@ptaluka or @ptaluka is null or @ptaluka='') and
    (isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))>0 and
    (e.main_edtn=@pmainedtn or @pmainedtn is null or @pmainedtn='')
	and (c.zone_code=@pextra1   or @pextra1  is null or @pextra1='') 
	and (c.region_code=@pextra2 or @pextra2 is null or @pextra2='')
	and (p.pro_type=@pextra4 or @pextra4 is null or @pextra4='')
    group by b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.copy_rate,
    b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.branch_code,a.city_code,a.dist_code, a.state_code,
    a.country_code,a.tehsil_taluka,d.route_code) u
    where (u.supply_copy+u.return_copy)>0
    group by u.comp_code,u.unit_code,
    u.branch_code,u.publ,u.publ_name,u.main_edtn,u.edtn,u.edtn_name,u.copy_rate,
    u.agcd,u.dpcd,u.agname,u.agname_oth_lang,
    u.state_code,u.dist_code ,u.city_code,u.tehsil_taluka,u.route_code,u.country_code;


        delete from cir_temp_bill_collection where cur_sessionid=@@spid;
        open c1;
      
            fetch next from c1 into @v1_comp_code,@v1_unit_code,@v1_print_center,@v1_branch_code,@v1_branch_name,@v1_publ,@v1_publ_name,@v1_main_edtn_code,@v1_main_edtn_name,@v1_edtn_code,@v1_edtn_name,@v1_copy_rate,@v1_agcd,@v1_dpcd,@v1_agname,@v1_agname_oth_lang,@v1_state_code,@v1_state_name,@v1_dist_code,@v1_dist_name,@v1_city_code,@v1_city_name,@v1_talu_code,@v1_taluka_name,@v1_route_code,@v1_route_name,@v1_print_center,@v1_supply_copy,@v1_supply_avg_todt,@v1_return_copy,@v1_ret_avg_todt,@v1_net_sale_copy,@v1_net_avg_todt,@v1_no_of_days,@v1_per_avg_todt
            while @@FETCH_STATUS=0 begin
         print('@@cursor_rows')
         print(@@cursor_rows)
            if isnull(@v1_no_of_days,0)>0 begin
                set @v_avg_sale=round(isnull(@v1_net_sale_copy,0)/(isnull(@v1_no_of_days,0)),2);
end
            else begin
               set @v_avg_sale=isnull(@v1_net_sale_copy,0);
            end 
            
select distinct @v_reg_code=region_code   from cir_city_mast where comp_code=@v1_comp_code and city_code=@v1_city_code;
select distinct @v_zone_code=zone_code   from cir_city_mast where comp_code=@v1_comp_code and city_code=@v1_city_code;
select distinct @v_publ_code=pro_type   from cir_publ_mast where comp_code=@v1_comp_code and publ=@v1_publ;
          
            set @v_reg_code=dbo.cir_get_region_name(@v1_comp_code,@v_reg_code); 
			set @v_zone_code=dbo.cir_get_zone_name(@v1_comp_code, @v_zone_code); 
			set @v_publ_code=dbo.cir_publ_type(@v1_comp_code,@v_publ_code,null,null);
            insert into #CIR_TEMP_BILL_COLLECTION
            (comp_code, unit_code, billno, publ_code, agcd, dpcd,agname,agname_oth_lang, city_code, 
            taluka_code, dist_code, state_code, remarks,supply_copy, return_copy ,comm_amt,gross_amt,cur_sessionid,zone_code, region_code,pro_type,route_code,
			printing_cent_code,supply_avg_todt, return_avg_todt, net_avg_todt, per_avg_todt)  
            values(@v1_comp_code,@v1_unit_code,@v1_branch_name,@v1_publ_name,@v1_main_edtn_name,@v1_edtn_name,@v1_agname,@v1_agname_oth_lang,@v1_city_name,
            @v1_taluka_name,@v1_dist_name,@v1_state_name,@v_reg_code,@v1_supply_copy,@v1_return_copy,@v1_copy_rate,@v1_no_of_days,@@spid,
			@v_zone_code,@v_reg_code,@v_publ_code,@v1_route_name,@v1_print_center,@v1_supply_avg_todt,@v1_ret_avg_todt,@v1_net_avg_todt,@v1_per_avg_todt);
        fetch next from c1 into @v1_comp_code,@v1_unit_code,@v1_print_center,@v1_branch_code,@v1_branch_name,@v1_publ,@v1_publ_name,@v1_main_edtn_code,@v1_main_edtn_name,@v1_edtn_code,@v1_edtn_name,@v1_copy_rate,@v1_agcd,@v1_dpcd,@v1_agname,@v1_agname_oth_lang,@v1_state_code,@v1_state_name,@v1_dist_code,@v1_dist_name,@v1_city_code,@v1_city_name,@v1_talu_code,@v1_taluka_name,@v1_route_code,@v1_route_name,@v1_print_center,@v1_supply_copy,@v1_supply_avg_todt,@v1_return_copy,@v1_ret_avg_todt,@v1_net_sale_copy,@v1_net_avg_todt,@v1_no_of_days,@v1_per_avg_todt
end
        close c1;
      
        if @preptype=1 begin
if @pbreak_on='B' begin
               
                select comp_code as "COMP_CODE", unit_code as "UNIT",dbo.fa_get_print_cent_name(comp_code,unit_code) "CENTER_NAME",
                agname as "AGNAME",agname_oth_lang as "AGNAME_OTH_LANG",city_code as "CITY_NAME", 
                billno as "BRANCH_NAME",comm_amt as "COPY_RATE",supply_copy as "SUPPLY_COPY", return_copy as "RETURN_COPY" ,(supply_copy-return_copy) as "NET_SALE",
                case when isnull(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as "NET_PER",
                gross_amt as "NO_OF_DAYS",case when isnull(gross_amt,0)>0 then round((supply_copy-return_copy)/gross_amt,2) else 0 end as "AVG_NET_SALE",
				supply_avg_todt, return_avg_todt, net_avg_todt, 
				(isnull(return_copy,0)/ISNULL(supply_copy,0))*100   per_avg_todt
                from #CIR_TEMP_BILL_COLLECTION 
             
                order by branch_name,agname,city_name,comm_amt;
              
                select comp_code as "COMP_CODE",unit_code as unit,dbo.fa_get_print_cent_name(comp_code,unit_code) "CENTER_NAME",  
                billno as "BRANCH_NAME",sum(supply_copy) as "SUPPLY_COPY", sum(return_copy) as "RETURN_COPY" ,sum(supply_copy-return_copy) as "NET_SALE_COPY",
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as "NET_PER",
                0 as "NO_OF_DAYS", 0 as "AVG_NET_SALE",sum(supply_avg_todt) AS "SUPPLY_AVG_TODT", 
				sum(return_avg_todt) AS "RETURN_AVG_TODT", sum(net_avg_todt) AS "NET_AVG_TODT", 
				(sum(isnull(return_copy,0))/sum(ISNULL(supply_copy,0)))*100 AS "PER_AVG_TODT"
                from #CIR_TEMP_BILL_COLLECTION 
                --where cur_sessionid=userenv('sessionid') 
                group by comp_code,unit_code,billno order by branch_name;
            end 
END 
       select getdate() as "CUR_DATE" 
      select getdate() as "CUR_DATE" 
deallocate c1
 delete from #CIR_TEMP_BILL_COLLECTION where cur_sessionid=@@spid;
 drop table #CIR_TEMP_BILL_COLLECTION
  end 




//*****************************End Report No.37**************************************************************************



//******************************Report No-115*****Added By Meenakshi*******Net Sale Report Day Wise************************** 


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[cir_daywise_net_paid_sale_new]
	 @pcomp_code         as varchar(200),
     @punit_code         as varchar(200),
     @ppubl              as varchar(200),
     @pmainedtn          as varchar(200),
     @pedtn              as varchar(200),
     @pfromdate          as datetime,
     @ptilldate          as datetime,
     @pagency_type       as varchar(200),
     @pagency_class      as varchar(200),
     @pstatecode         as varchar(200),
     @pdistcode          as varchar(200),
     @ptaluka            as varchar(200),
     @pbranch            as varchar(200),
     @pagcd              as varchar(200),
     @pdpcd              as varchar(200),
     @preptype           as varchar(4),--1 for Agency Wise,2 for Main Edition wise,3 for District Taluka wise
     @pbreak_on          as varchar(200),--Region R/State S/District D/Branch B / ZONE  Z /REGION R / PUBL TYPR P / O ROUTE / PRINTING CENTER C
     @preturn_based      as varchar(200),--it is use for return date or supply date(R/S)
     @plangtype          as varchar(200),
     @pdateformat        as varchar(200),
     @pextra1            as varchar(200),---for zone 
     @pextra2            as varchar(200),---for region
     @pextra3            as varchar(200),---for commission
     @pextra4            as varchar(200),---for publication type
     @pextra5            as varchar(200)

AS 

begin
----- parameters for execution------------
--exec cir_rep_branch_collection_summary 'UM001','BA0','BA1','','','NM','','','','','05/01/2012','05/31/2012','','A01','dd/mm/yyyy','','' 
-------------------------------------------
	 declare @v_frdt    datetime;
     declare @v_todt    datetime;
     declare @v_reg_code varchar(200);
	 declare @v_zone_code varchar(200);
	 declare @v_publ_code varchar(200);
     declare @v_avg_sale numeric(10);
	
	set @v_frdt         =@pfromdate
	set @v_todt         =@ptilldate
	
CREATE TABLE #CIR_TEMP_BILL_COLLECTION
(
  COMP_CODE           VARCHAR(100),
  UNIT_CODE           VARCHAR(100),
  BILLNO              VARCHAR(200),
  BILLDT              DATEtime,
  PUBL_CODE           VARCHAR(100),
  AGCD                VARCHAR(100),
  DPCD                VARCHAR(100),
  SUPPLY_COPY         NUMeric(10)                DEFAULT 0,
  GROSS_AMT           NUMeric(15,2)              DEFAULT 0,
  COMM_AMT            NUMeric(15,2)              DEFAULT 0,
  SUR_AMT             NUMeric(15,2)              DEFAULT 0,
  RETURN_COPY         NUMeric(10)                DEFAULT 0,
  RETURN_AMT          NUMeric(15,2)              DEFAULT 0,
  DN_AMT              NUMeric(15,2)              DEFAULT 0,
  CN_AMT              NUMeric(15,2)              DEFAULT 0,
  REC_AMT             NUMeric(15,2)              DEFAULT 0,
  PREV_BAL            NUMeric(15,2)              DEFAULT 0,
  CUR_SESSIONID       NUMeric,
  AGNAME              VARCHAR(200),
  AGNAME_OTH_LANG     VARCHAR(250),
  CITY_CODE           VARCHAR(200),
  TALUKA_CODE         VARCHAR(200),
  DIST_CODE           VARCHAR(200),
  STATE_CODE          VARCHAR(200),
  REMARKS             VARCHAR(500),
  RET_COMM_AMT        NUMeric(15,2),
  BILL_SEC_AMT        NUMeric(15,2),
  SEC_OPBAL           NUMeric(15,2),
  ZONE_CODE           VARCHAR(200),
  REGION_CODE         VARCHAR(200),
  PRO_TYPE            VARCHAR(200),
  COMM_CODE           VARCHAR(200),
  ROUTE_CODE          VARCHAR(200),
  PRINTING_CENT_CODE  VARCHAR(200),
  SUPPLY_AVG_TODT     NUMeric(15,2),
  RETURN_AVG_TODT     NUMeric(15,2),
  NET_AVG_TODT        NUMeric(15,2),
  PER_AVG_TODT        NUMeric(15,2),
  BILL_COUNT          INTEGER,
  issue_date          datetime,
  issue_day           varchar(20),
  PUBL           VARCHAR(100),
  AGCD1                VARCHAR(100),
  DPCD1                VARCHAR(100)
)
	


	
	DECLARE c1 cursor LOCAL FOR 
	select u.comp_code,u.unit_code,u.supdate,u.supdate_day,
    u.branch_code branch_code,(select distinct Branch_Name from branch_mst where Branch_Code=u.branch_code) branch_name,
    u.publ,u.publ_name,u.main_edtn,
    dbo.cir_get_edtn_name(u.comp_code,u.main_edtn) main_edtn_name,u.edtn edtn,u.edtn_name,u.copy_rate,
    u.agcd agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang agname_oth_lang,
    u.state_code,dbo.cir_get_state(u.comp_code,u.country_code,u.state_code) state_name,
    u.dist_code ,dbo.cir_get_name_cir_district(u.comp_code,u.dist_code,@plangtype,null,null,null) dist_name,
    u.city_code city_code,dbo.cir_get_name_cir_city(u.comp_code,u.city_code,@plangtype,null,null,null) city_name,
    u.tehsil_taluka,dbo.cir_get_name_cir_taluka(u.comp_code,u.tehsil_taluka,@plangtype,null,null,null) taluka_name,
	u.route_code,dbo.cir_get_route_name(u.comp_code,u.unit_code,u.route_code ) route_name,
	dbo.fa_get_print_cent_name(u.comp_code,u.unit_code) print_center,
    sum(supply_copy) supply_copy,sum(return_copy) return_copy,
    sum(supply_copy)-sum(return_copy) net_sale_copy,sum(no_of_days) no_of_days
    from (
    select b.comp_code,b.unit_code,b.supdate,dbo.cir_DayOfWeek(b.supdate) supdate_day,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.sup_rate copy_rate,
    b.agcd,b.dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
    a.branch_code,a.city_code,a.dist_code, a.state_code,a.country_code,a.tehsil_taluka,b.route_code, 
    sum(isnull(b.sup_copy,0)) supply_copy,0 return_copy, count(distinct supdate) no_of_days 
	from cir_agmast a,cir_dbksup b,cir_edtn_mast e,cir_publ_mast p,cir_city_mast c
    where b.comp_code =a.comp_code and b.comp_code=e.comp_code and b.comp_code=p.comp_code and a.comp_code=c.comp_code and
    b.comp_code =@pcomp_code and 
    b.unit_code=a.unit and b.unit_code=@punit_code and 
    b.publ=p.publ and b.publ=isnull(@ppubl,b.publ) and b.edtn=e.edtn and b.edtn=isnull(@pedtn,b.edtn) and
    a.agcd=b.agcd and b.agcd=isnull(@pagcd,b.agcd) and a.dpcd=b.dpcd and b.dpcd=isnull(@pdpcd,b.dpcd) and
	a.city_code=c.city_code and 
    b.supdate >= @v_frdt and b.supdate <=@v_todt and 
    (a.ag_type=@pagency_type or @pagency_type is null) and(a.ag_class=@pagency_class or @pagency_class is null) and
    (a.branch_code=@pbranch or @pbranch is null) and (a.state_code=@pstatecode or @pstatecode is null) and
    (a.dist_code=@pdistcode or @pdistcode is null) and (a.tehsil_taluka=@ptaluka or @ptaluka is null) and
    (e.main_edtn=@pmainedtn or @pmainedtn is null)
	and (c.zone_code=@pextra1   or @pextra1  is null) 
	and (c.region_code=@pextra2 or @pextra2 is null)
	and (b.comm_code=@pextra3 or @pextra3 is null)
	and (p.pro_type=@pextra4 or @pextra4 is null)
    group by b.comp_code,b.unit_code,b.supdate,dbo.cir_DayOfWeek(b.supdate) ,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.sup_rate,
    b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.branch_code,a.city_code,a.dist_code, a.state_code,
    a.country_code,a.tehsil_taluka,b.route_code
    union all
    select b.comp_code,b.unit_code,d.supdate,dbo.cir_DayOfWeek(b.supdate) ,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.copy_rate,
    b.agcd,b.dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
    a.branch_code,a.city_code,a.dist_code, a.state_code,a.country_code,a.tehsil_taluka,d.route_code, 
    0 supply_copy,sum(isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0)) return_copy,0 no_of_days
    from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e,cir_publ_mast p,cir_city_mast c,cir_dbksup d
    where b.comp_code =a.comp_code and b.comp_code=e.comp_code and b.comp_code=p.comp_code and b.comp_code =@pcomp_code 
	and a.comp_code=c.comp_code and b.comp_code=d.comp_code and
    b.unit_code=a.unit and b.unit_code=d.unit_code and b.unit_code=@punit_code and 
    b.doctype='UCN' and b.recptdt >= @v_frdt and b.recptdt <=@v_todt and 
    b.publ=e.publ and b.publ=p.publ and b.publ=d.publ and b.publ=isnull(@ppubl,b.publ) and b.edtn=e.edtn and b.edtn=d.edtn and b.edtn=isnull(@pedtn,b.edtn) and 
    a.agcd=b.agcd and a.agcd=d.agcd and b.agcd=isnull(@pagcd,b.agcd) and a.dpcd=b.dpcd and a.dpcd=d.dpcd and b.dpcd=isnull(@pdpcd,b.dpcd) and 
	a.city_code=c.city_code and 
    (a.ag_type=@pagency_type or @pagency_type is null) and(a.ag_class=@pagency_class or @pagency_class is null) and
    (a.branch_code=@pbranch or @pbranch is null) and (a.state_code=@pstatecode or @pstatecode is null) and
    (a.dist_code=@pdistcode or @pdistcode is null) and (a.tehsil_taluka=@ptaluka or @ptaluka is null) and
    (isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))>0 and
    (e.main_edtn=@pmainedtn or @pmainedtn is null)
	and (c.zone_code=@pextra1   or @pextra1  is null) 
	and (c.region_code=@pextra2 or @pextra2 is null)
	and (p.pro_type=@pextra4 or @pextra4 is null)
    group by b.comp_code,b.unit_code,d.supdate,dbo.cir_DayOfWeek(b.supdate),b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.copy_rate,
    b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.branch_code,a.city_code,a.dist_code, a.state_code,
    a.country_code,a.tehsil_taluka,d.route_code) u
    where (u.supply_copy+u.return_copy)>0
    group by u.comp_code,u.unit_code,u.supdate,u.supdate_day,
    u.branch_code,u.publ,u.publ_name,u.main_edtn,u.edtn,u.edtn_name,u.copy_rate,
    u.agcd,u.dpcd,u.agname,u.agname_oth_lang,
    u.state_code,u.dist_code ,u.city_code,u.tehsil_taluka,u.route_code,u.country_code
	order by u.comp_code,u.unit_code,DATEPART(weekday,u.supdate),
    u.branch_code,u.publ,u.publ_name,u.main_edtn;
    
declare @v1_comp_code as varchar(200)
declare @v1_unit_code as varchar(200)
declare @v1_supdate as datetime
declare @v1_supdate_day as varchar(200)
declare @v1_branch_code as varchar(200)
declare @v1_branch_name as varchar(200)
declare @v1_publ as varchar(200)
declare @v1_publ_name as varchar(200)
declare @v1_main_edtn as varchar(200)
declare @v1_main_edtn_name as varchar(200)
declare @v1_edtn as varchar(200)
declare @v1_edtn_name as varchar(200)
declare @v1_copy_rate as numeric(14,2)
declare @v1_agcd as varchar(200)
declare @v1_dpcd as varchar(200)
declare @v1_agname as varchar(200)
declare @v1_agname_oth_lang as varchar(200)
declare @v1_state_code as varchar(200)
declare @v1_state_name as varchar(200)
declare @v1_dist_code as varchar(200)
declare @v1_dist_name as varchar(200)
declare @v1_city_code as varchar(200)
declare @v1_city_name as varchar(200)
declare @v1_tehsil_taluka as varchar(200)
declare @v1_taluka_name as varchar(200)
declare @v1_route_code as varchar(200)
declare @v1_route_name as varchar(200)
declare @v1_print_center as varchar(200)
declare @v1_supply_copy as numeric(14)
declare @v1_return_copy as numeric(14)
declare @v1_net_sale_copy as numeric(14)
declare @v1_no_of_days as numeric(14)
    
    
    OPEN c1 
        fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit_code,@v1_supdate,@v1_supdate_day,@v1_branch_code,@v1_branch_name,@v1_publ,@v1_publ_name,
								@v1_main_edtn,@v1_main_edtn_name,@v1_edtn,@v1_edtn_name,@v1_copy_rate,@v1_agcd,@v1_dpcd,@v1_agname,@v1_agname_oth_lang,
								@v1_state_code,@v1_state_name,@v1_dist_code,@v1_dist_name,@v1_city_code,@v1_city_name,@v1_tehsil_taluka,@v1_taluka_name,
								@v1_route_code,@v1_route_name,@v1_print_center,@v1_supply_copy,@v1_return_copy,@v1_net_sale_copy,@v1_no_of_days
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN 
		print(@@Cursor_Rows)
		if isnull(@v1_no_of_days,0)>0 
		begin
               set @v_avg_sale=round(isnull(@v1_net_sale_copy,0)/(isnull(@v1_no_of_days,0)),2);
        end
        else
        begin
             set @v_avg_sale=isnull(@v1_net_sale_copy,0);
        end        
        
            select distinct @v_reg_code=region_code  from cir_city_mast where comp_code=@v1_comp_code 
            and city_code=@v1_city_code;
			
			if @v_reg_code = ''			
			begin
				set @v_reg_code=null;
            end
		
		   select distinct @v_zone_code=zone_code from cir_city_mast where comp_code=@v1_comp_code 
		   and city_code=@v1_city_code
			if @v_zone_code =''			
			begin
				set @v_zone_code=null;
			end
			
			
			select distinct @v_publ_code=pro_type  from cir_publ_mast where comp_code=@v1_comp_code and publ=@v1_publ;            
            if @v_publ_code =''			
			begin
				set @v_publ_code=null
			end
			
            set @v_reg_code=dbo.cir_get_region_name(@v1_comp_code,@v_reg_code); 
			set @v_zone_code=dbo.cir_get_zone_name(@v1_comp_code, @v_zone_code); 
			set @v_publ_code=dbo.cir_publ_type(@v1_comp_code,@v_publ_code,null,null);
			
            insert into #cir_temp_bill_collection
            (comp_code, unit_code, billno, publ_code, agcd, dpcd,agname,agname_oth_lang, city_code, 
            taluka_code, dist_code, state_code, remarks,supply_copy, return_copy ,comm_amt,gross_amt,cur_sessionid,zone_code, region_code,pro_type,route_code,printing_cent_code,issue_date, issue_day,PUBL,agcd1,dpcd1)  
            values(@v1_comp_code,@v1_unit_code,@v1_branch_name,@v1_publ_name,@v1_main_edtn_name,@v1_edtn_name,@v1_agname,@v1_agname_oth_lang,@v1_city_name,
            @v1_taluka_name,@v1_dist_name,@v1_state_name,@v_reg_code,@v1_supply_copy,@v1_return_copy,@v1_copy_rate,@v1_no_of_days,@@spid,@v_zone_code,@v_reg_code,@v_publ_code,@v1_route_name,@v1_print_center,@v1_supdate,@v1_supdate_day,@v1_publ,@v1_agcd,@v1_dpcd);
		
		fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit_code,@v1_supdate,@v1_supdate_day,@v1_branch_code,@v1_branch_name,@v1_publ,@v1_publ_name,
								@v1_main_edtn,@v1_main_edtn_name,@v1_edtn,@v1_edtn_name,@v1_copy_rate,@v1_agcd,@v1_dpcd,@v1_agname,@v1_agname_oth_lang,
								@v1_state_code,@v1_state_name,@v1_dist_code,@v1_dist_name,@v1_city_code,@v1_city_name,@v1_tehsil_taluka,@v1_taluka_name,
								@v1_route_code,@v1_route_name,@v1_print_center,@v1_supply_copy,@v1_return_copy,@v1_net_sale_copy,@v1_no_of_days
		END 
	close c1
    DEALLOCATE c1
 --select * from   #cir_temp_bill_collection
			if @preptype='A' begin
				
				select comp_code, unit_code,agcd1,dpcd1,agname,issue_day,publ,publ_code,issue_date,
				sum(isnull(supply_copy,0)) AS SUPPLY_COPY, sum(isnull(return_copy,0)) AS RETURN_COPY
				,(sum(isnull(supply_copy,0))-sum(isnull(return_copy,0))) AS NET_SALE
				,case when sum(isnull(supply_copy,0))>0 then round((sum(isnull(return_copy,0))/sum(isnull(supply_copy,0)))*100,2) else 0 end as NET_PER 
				,DATEPART(weekday,issue_date)
				from #cir_temp_bill_collection 
				group by comp_code, unit_code,agcd1,dpcd1,agname,issue_day,publ,publ_code,issue_date,DATEPART(weekday,issue_date)
				order by  comp_code, unit_code,agname,DATEPART(dw,issue_date)
			end     
			else if @preptype='S' begin

				select comp_code, unit_code,state_code,issue_day,publ,publ_code,issue_date,
				sum(isnull(supply_copy,0)) AS SUPPLY_COPY, sum(isnull(return_copy,0)) AS RETURN_COPY
				,(sum(isnull(supply_copy,0))-sum(isnull(return_copy,0))) AS NET_SALE
				,case when sum(isnull(supply_copy,0))>0 then round((sum(isnull(return_copy,0))/sum(isnull(supply_copy,0)))*100,2) else 0 end as NET_PER 
				,DATEPART(weekday,issue_date)
				from #cir_temp_bill_collection 
				group by comp_code, unit_code,state_code,issue_day,publ,publ_code,issue_date,DATEPART(weekday,issue_date)
				order by  comp_code, unit_code,state_code,DATEPART(dw,issue_date)     
			end               
			else if @preptype='D' begin

				select comp_code, unit_code,dist_code,issue_day,publ,publ_code,issue_date,
				sum(isnull(supply_copy,0)) AS SUPPLY_COPY, sum(isnull(return_copy,0)) AS RETURN_COPY
				,(sum(isnull(supply_copy,0))-sum(isnull(return_copy,0))) AS NET_SALE
				,case when sum(isnull(supply_copy,0))>0 then round((sum(isnull(return_copy,0))/sum(isnull(supply_copy,0)))*100,2) else 0 end as NET_PER 
				,DATEPART(weekday,issue_date)
				from #cir_temp_bill_collection 
				group by comp_code, unit_code,dist_code,issue_day,publ,publ_code,issue_date,DATEPART(weekday,issue_date)
				order by  comp_code, unit_code,dist_code,DATEPART(dw,issue_date)  
			end
			else if @preptype='Z' begin  ---ZONE WISE
				select comp_code, unit_code,zone_code,issue_day,publ,publ_code,issue_date,
				sum(isnull(supply_copy,0)) AS SUPPLY_COPY, sum(isnull(return_copy,0)) AS RETURN_COPY
				,(sum(isnull(supply_copy,0))-sum(isnull(return_copy,0))) AS NET_SALE
				,case when sum(isnull(supply_copy,0))>0 then round((sum(isnull(return_copy,0))/sum(isnull(supply_copy,0)))*100,2) else 0 end as NET_PER 
				,DATEPART(weekday,issue_date)
				from #cir_temp_bill_collection 
				group by comp_code, unit_code,zone_code,issue_day,publ,publ_code,issue_date,DATEPART(weekday,issue_date)
				order by  comp_code, unit_code,zone_code,DATEPART(dw,issue_date)  
			end
			else if @preptype='R' begin  ---REGION WISE
				select comp_code, unit_code,region_code,issue_day,publ,publ_code,issue_date,
				sum(isnull(supply_copy,0)) AS SUPPLY_COPY, sum(isnull(return_copy,0)) AS RETURN_COPY
				,(sum(isnull(supply_copy,0))-sum(isnull(return_copy,0))) AS NET_SALE
				,case when sum(isnull(supply_copy,0))>0 then round((sum(isnull(return_copy,0))/sum(isnull(supply_copy,0)))*100,2) else 0 end as NET_PER 
				,DATEPART(weekday,issue_date)
				from #cir_temp_bill_collection 
				group by comp_code, unit_code,region_code,issue_day,publ,publ_code,issue_date,DATEPART(weekday,issue_date)
				order by  comp_code, unit_code,region_code,DATEPART(dw,issue_date)  
			end
			else if @preptype='O' begin  --- ROUTE WISE

				select comp_code, unit_code,route_code,issue_day,publ,publ_code,issue_date,
				sum(isnull(supply_copy,0)) AS SUPPLY_COPY, sum(isnull(return_copy,0)) AS RETURN_COPY
				,(sum(isnull(supply_copy,0))-sum(isnull(return_copy,0))) AS NET_SALE
				,case when sum(isnull(supply_copy,0))>0 then round((sum(isnull(return_copy,0))/sum(isnull(supply_copy,0)))*100,2) else 0 end as NET_PER 
				,DATEPART(weekday,issue_date)
				from #cir_temp_bill_collection 
				group by comp_code, unit_code,route_code,issue_day,publ,publ_code,issue_date,DATEPART(weekday,issue_date)
				order by  comp_code, unit_code,route_code,DATEPART(dw,issue_date)  
		 end
		 else if @preptype='B' begin

				select comp_code, unit_code,billno branch,issue_day,publ,publ_code,issue_date,
				sum(isnull(supply_copy,0)) AS SUPPLY_COPY, sum(isnull(return_copy,0)) AS RETURN_COPY
				,(sum(isnull(supply_copy,0))-sum(isnull(return_copy,0))) AS NET_SALE
				,case when sum(isnull(supply_copy,0))>0 then round((sum(isnull(return_copy,0))/sum(isnull(supply_copy,0)))*100,2) else 0 end as NET_PER 
				,DATEPART(weekday,issue_date)
				from #cir_temp_bill_collection 
				group by comp_code, unit_code,billno,issue_day,publ,publ_code,issue_date,DATEPART(weekday,issue_date)
				order by  comp_code, unit_code,billno,DATEPART(dw,issue_date)  
		  end
		  else --if @preptype='C'     ---AGENCY WISE
			 begin
				select comp_code, unit_code,agcd1,dpcd1,agname,issue_day,publ,publ_code,issue_date,
				sum(isnull(supply_copy,0)) AS SUPPLY_COPY, sum(isnull(return_copy,0)) AS RETURN_COPY
				,(sum(isnull(supply_copy,0))-sum(isnull(return_copy,0))) AS NET_SALE
				,case when sum(isnull(supply_copy,0))>0 then round((sum(isnull(return_copy,0))/sum(isnull(supply_copy,0)))*100,2) else 0 end as NET_PER 
				,DATEPART(weekday,issue_date)
				from #cir_temp_bill_collection 
				group by comp_code, unit_code,agcd1,dpcd1,agname,issue_day,publ,publ_code,issue_date,DATEPART(weekday,issue_date)
				order by  comp_code, unit_code,agname,DATEPART(dw,issue_date)
		end
        --open p_accounts1 for select sysdate as CUR_DATE from dual;
        select GETDATE() as CUR_DATE
        select GETDATE() as CUR_DATE
    
    drop table #cir_temp_bill_collection
    
end





//*****************************End Report No.115***************************Net Sale Report Day Wise**********************************

************************* rikkee ********late factor fee process************************

ALTER procedure [dbo].[cir_late_factor_aglist]
    @pcompcode       as varchar(200),
    @punitcode       as varchar(200),
    @ppublcode       as varchar(200),
    @pissuedate      as datetime, 
    @platerate			 as numeric(14,2), 
    @puserid         as varchar(200), 
    @pdateformate    as varchar(200),
    @processby       as varchar(200),---- 1/branch , 2/route , 3/zone , 4/region , 5/district
    @pvar_sel		 as varchar(max),---- value in ['a','b','c','d'] format
    @pagcd			 as varchar(20),
    @pdpcd			 as varchar(20),
    @pagtype		 as varchar(20),
    @pagclass    	 as varchar(20),
    @psuptype		 as varchar(20),
    @preason 		 as varchar(20),
    @pextra1         as varchar(200),
    @pextra2         as varchar(200),
    @pextra3         as varchar(200),
    @pextra4         as varchar(200),
    @pextra5         as varchar(200)
as
    
begin

declare @v1_agcd as varchar(20)
declare @v1_dpcd as varchar(20)
declare @v1_branch_code as varchar(20)
declare @v1_ag_type as varchar(20)
declare @v1_ag_class as varchar(20)
declare @v1_ag_name as varchar(200)
declare @v1_station_code as varchar(20)
declare @v1_route_code as varchar(20)

create table #Results(SegmentNum INT, Edition_Name  VARCHAR(255))

insert into #Results select * from dbo.Fn_Splitfield(@pvar_sel,',')

    declare c1 cursor for
		select distinct a.agcd,a.dpcd,a.branch_code,a.ag_type,a.ag_class,a.ag_name,a.station_code,b.route_code 
		from cir_agmast a,cir_supply b
		where a.comp_code=@pcompcode 
		and a.comp_code=b.comp_code and a.agcd=b.agcd and a.dpcd=b.dpcd --and a.unit=b.unit
		and isnull(b.late_fee,'N')='Y'
		and (a.unit= @punitcode or @punitcode is null or @punitcode ='')    
		and (
			(@processby='1' and a.branch_code in (select Edition_Name from #Results) ) or
			(@processby='2' and b.route_code in (select Edition_Name from #Results)  ) or
			(@processby='3' and dbo.cir_get_zone_by_city(a.comp_code,a.city_code,'C') in (select Edition_Name from #Results) ) or
			(@processby='4' and dbo.cir_get_region_by_city(a.comp_code,a.city_code,'C') in (select Edition_Name from #Results) ) or
			(@processby='5' and a.dist_code   in (select Edition_Name from #Results) )
			)
		and (a.agcd=@pagcd or @pagcd is null or @pagcd ='')
		and (a.dpcd=@pdpcd or @pdpcd is null or @pdpcd ='')
		and (a.ag_type=@pagtype or @pagtype is null or @pagtype ='')
		and (a.ag_class=@pagclass or @pagclass is null or @pagclass ='')
    


   CREATE TABLE #CIR_late_factor_fee
	(COMP_CODE       VARCHAR(100),
	UNIT_CODE        VARCHAR(100),	
	BRANCH_CODE      varchar(200),
	AGCD             VARCHAR(100),
	DPCD             VARCHAR(100),
	AGNAME           VARCHAR(250),
	AG_TYPE          VARCHAR(20),
	AG_CLASS         VARCHAR(20),
	AG_DROP          VARCHAR(20),
	AG_ROUTE         VARCHAR(20),
	ISSUE_DAY        VARCHAR(20),	
	ISSUE_DT         DATETIME,
	SUPPLY_COPY      NUMERIC(10)                   DEFAULT 0,
	LATE_RATE        NUMERIC(15,2)                 DEFAULT 0,
	LATE_AMT         NUMERIC(15,2)                 DEFAULT 0,
	lateby			 varchar(5),
	dep_time		 varchar(5),
	act_dep_time     varchar(5)
	)

    
declare @vsecond as numeric(14)
declare @v_time_line as varchar(20)
declare @v_supply as numeric(14)
declare @v_day as varchar(20)
declare @v_dep_time as varchar(5)
declare @v_exp_dep as varchar(5)
declare @vtimediff as varchar(6)
set @v_day=CONVERT(VARCHAR(20) , DATENAME(WEEKDAY, @pissuedate),20)

open c1
        fetch NEXT FROM c1 INTO @v1_agcd,@v1_dpcd,@v1_branch_code,@v1_ag_type,@v1_ag_class,@v1_ag_name,@v1_station_code,@v1_route_code
     
        WHILE (@@FETCH_STATUS = 0) 
		BEGIN
		print(@v1_route_code)
		print(@pissuedate)
		
		select @v_time_line=isnull(time_line,'00:00') from cir_route_mast where comp_code=@pcompcode 
		and unit=@punitcode and route_code=@v1_route_code
			
		select distinct @v_exp_dep=EXP_DEP_TIME,@v_dep_time=DEP_TIME, @vtimediff=replace(DBO.time_diff(dep_time, exp_dep_time),'S','') from CIR_ROUTE_TAXI_MAST
		where comp_code=@pcompcode and (unit_code=@punitcode or @punitcode is null or @punitcode='')
		and route_code=	@v1_route_code and dep_date= @pissuedate
		
		print(@v_time_line)	
		print(@v_exp_dep)	
		print(@v_dep_time)
		print(@vtimediff)
		print('22222222222')
		print(@v_day)
		if @v_day='Sunday' Begin 
		   select distinct @v_supply=sum(isnull(base_supply,0))+sum(isnull(supply_sun,0)) from cir_supply 
		   where comp_code=@pcompcode and (unit=@punitcode or @punitcode is null or @punitcode='')
		   and agcd=@v1_agcd and dpcd=@v1_dpcd 
		   and (publ=@ppublcode or @ppublcode is null or @ppublcode ='')
		   and (publ=@psuptype or @psuptype is null or @psuptype ='')
		   
		End    
		Else if @v_day='Monday' Begin
			select distinct @v_supply=sum(isnull(base_supply,0))+sum(isnull(supply_mon,0)) from cir_supply 
		   where comp_code=@pcompcode and (unit=@punitcode or @punitcode is null or @punitcode='')
		   and agcd=@v1_agcd and dpcd=@v1_dpcd 
		   and (publ=@ppublcode or @ppublcode is null or @ppublcode ='')
		   and (publ=@psuptype or @psuptype is null or @psuptype ='')
		End    
		Else if @v_day='Tuesday' Begin
			select distinct @v_supply=sum(isnull(base_supply,0))+sum(isnull(supply_tue,0)) from cir_supply 
		   where comp_code=@pcompcode and (unit=@punitcode or @punitcode is null or @punitcode='')
		   and agcd=@v1_agcd and dpcd=@v1_dpcd 
		   and (publ=@ppublcode or @ppublcode is null or @ppublcode ='')
		   and (publ=@psuptype or @psuptype is null or @psuptype ='')
		End 
		Else If @v_day='Wednesday' Begin
			select distinct @v_supply=sum(isnull(base_supply,0))+sum(isnull(supply_wed,0)) from cir_supply 
		   where comp_code=@pcompcode and (unit=@punitcode or @punitcode is null or @punitcode='')
		   and agcd=@v1_agcd and dpcd=@v1_dpcd 
		   and (publ=@ppublcode or @ppublcode is null or @ppublcode ='')
		   and (publ=@psuptype or @psuptype is null or @psuptype ='')
		End    
		Else If @v_day='Thursday' Begin
			select distinct @v_supply=sum(isnull(base_supply,0))+sum(isnull(supply_thu,0)) from cir_supply 
		   where comp_code=@pcompcode and (unit=@punitcode or @punitcode is null or @punitcode='')
		   and agcd=@v1_agcd and dpcd=@v1_dpcd 
		   and (publ=@ppublcode or @ppublcode is null or @ppublcode ='')
		   and (publ=@psuptype or @psuptype is null or @psuptype ='')
		End    
		Else if @v_day='Friday' Begin
			select distinct @v_supply=sum(isnull(base_supply,0))+sum(isnull(supply_fri,0)) from cir_supply 
		   where comp_code=@pcompcode and (unit=@punitcode or @punitcode is null or @punitcode='')
		   and agcd=@v1_agcd and dpcd=@v1_dpcd 
		   and (publ=@ppublcode or @ppublcode is null or @ppublcode ='')
		   and (publ=@psuptype or @psuptype is null or @psuptype ='')
		End
		Else Begin
			select distinct @v_supply=sum(isnull(base_supply,0))+sum(isnull(supply_sat,0)) from cir_supply 
		   where comp_code=@pcompcode and (unit=@punitcode or @punitcode is null or @punitcode='')
		   and agcd=@v1_agcd and dpcd=@v1_dpcd 
		   and (publ=@ppublcode or @ppublcode is null or @ppublcode ='')
		   and (publ=@psuptype or @psuptype is null or @psuptype ='')
		End
		set @vsecond=datediff(ss,@v_exp_dep,@v_time_line )	
		
		print('debug')

		print(@v_supply)
		print('3434')
		print(@vsecond)
		print('end')
		
		if @vsecond >0 begin
			insert into #CIR_late_factor_fee
				(COMP_CODE, UNIT_CODE, BRANCH_CODE,AGCD, DPCD, AGNAME,AG_TYPE,AG_CLASS, 
			AG_DROP,AG_ROUTE,ISSUE_DAY,ISSUE_DT,SUPPLY_COPY,LATE_RATE,LATE_AMT,lateby,dep_time,act_dep_time)
			values(@pcompcode,@punitcode,@v1_branch_code,@v1_agcd,@v1_dpcd,@v1_ag_name,@v1_ag_type,@v1_ag_class,
			@v1_station_code,@v1_route_code,upper(@v_day),@pissuedate,@v_supply,@platerate,isnull(@v_supply,0)*isnull(@platerate,0)
			,@vtimediff,@v_dep_time,@v_exp_dep)
		end
			
        fetch NEXT FROM c1 INTO @v1_agcd,@v1_dpcd,@v1_branch_code,@v1_ag_type,@v1_ag_class,@v1_ag_name,@v1_station_code,@v1_route_code
    end
    close c1;
    deallocate c1
           
select COMP_CODE, UNIT_CODE,--dbo.cir_get_unit_name(COMP_CODE,UNIT_CODE) as UNIT, 
BRANCH_CODE,dbo.cir_get_branch(COMP_CODE,BRANCH_CODE) BRANCH ,
AGCD, DPCD, AGNAME,AG_TYPE,AG_CLASS, 
AG_DROP,AG_ROUTE,dbo.cir_get_route_name(COMP_CODE,UNIT_CODE,AG_ROUTE) ROUTE
,ISSUE_DAY,ISSUE_DT,SUPPLY_COPY,LATE_RATE,LATE_AMT,lateby 
,dep_time,act_dep_time
from #CIR_late_factor_fee x
where x.comp_code+x.AGCD+x.DPCD--+CAST(ISSUE_DT as varchar) 
not in
(select t.comp_code+t.AGCD+t.DPCD from cir_late_factor_fee_process t --+CAST(ISSUE_DT as varchar)
where t.comp_code=@pcompcode and t.docno is not null and t.docdt is not null and t.flag='Y' )


drop table #CIR_late_factor_fee
drop table #Results
End
**************************************end of issue********************************************

///////////////////////////////add by Deepika 26/06/2012 sent by amit sir/////////////////////////////




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
		and recptno=@pd_rcptno and recptdt=@v_recptdt and SUP_AGCD=@pd_agcode and SUP_DPCD=@pd_agsubcode;
	End
    Else Begin
        select distinct isnull(var_unsold,0) as "V_UNSOLD",isnull(var_short_recpt,0) as "V_SHORT",
		isnull(var_damage,0) as "V_DAMAGE",isnull(var_late_recpt,0) as "V_LATEREC",isnull(var_bnr,0) as "V_BNR",
		isnull(apr_unsold,0) as "A_UNSOLD",isnull(apr_short_recpt,0) as "A_SHORT",
		isnull(apr_damage,0) as "A_DAMAGE",isnull(apr_late_recpt,0) as "A_LATEREC",isnull(apr_bnr,0) as "A_BNR"
		from cir_unsold_dtl
        where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and supdate=@v_supdt
		and recptno=@pd_rcptno and recptdt=@v_recptdt 
		and SUP_AGCD=@pd_agcode and SUP_DPCD=@pd_agsubcode;
	End
           

End



//////////////////////////////

ALTER PROCEDURE [dbo].[cir_unsold_credit_note_cir_unsold_check_p]
    @pcomp_code                               VARCHAR(20) ,
    @punit_code                               VARCHAR(20) ,
    @ppubl_code                               VARCHAR(20) ,
    @pedtn_code                               VARCHAR(20) ,
    @psup_date                                DATETIME  ,
    @pagcd_code                               VARCHAR(20) ,
    @pdpcd_code                               VARCHAR(20) ,
    @pdoc_type                                VARCHAR(20) ,
    @precptno                                 VARCHAR(20) ,
    @pmissing_recpt                           VARCHAR(20) ,
    @plate_recpt                              VARCHAR(20) ,
    @pbnr_recpt                               VARCHAR(20) ,
    @punsold                                  VARCHAR(20) ,
    @pcopy_rate                               VARCHAR(20) ,
    @pcomm_per                                VARCHAR(20) ,
    @pcomm_type                               VARCHAR(20) ,
    @pwaste_flag                              VARCHAR(20) ,
    @pwaste_rate                              VARCHAR(20) ,
    @pdateformat                              VARCHAR(20) ,
    @pextra1                                  VARCHAR(40) ,--for damaged copies
    @pextra2                                  VARCHAR(40) --for Distribution
AS 

	DECLARE @v_supdt			DATETIME 
	DECLARE @v_tot_copy         FLOAT 
	DECLARE @v_waste_amt        FLOAT 
	DECLARE @v_gross_amt        FLOAT 
	DECLARE @v_comm_amt         FLOAT 
	DECLARE @v_total_amt        FLOAT 
	DECLARE @v_query            VARCHAR(4000) 

    SET @v_supdt  = @psup_date
        
	If UPPER(@pextra2)='D' Begin
	        
		SELECT ISNULL(SUM(ISNULL(apr_short_recpt,short_recpt) + ISNULL(apr_late_recpt, late_recpt) + ISNULL(apr_bnr, bnr) + ISNULL(apr_unsold, unsold)+ ISNULL(apr_damage, damage)), 0) as TOTAL
			FROM  cir_unsold_dtl_dis WHERE comp_code  = @pcomp_code AND unit_code  = @punit_code AND    doctype  = @pdoc_type AND    publ  = @ppubl_code AND 
				edtn  = @pedtn_code AND supdate  = @v_supdt AND agcd  = @pagcd_code AND dpcd  = @pdpcd_code AND recptno  <> ISNULL(@precptno, '/')
	End
    Else Begin
        SELECT ISNULL(SUM(ISNULL(apr_short_recpt,short_recpt) + ISNULL(apr_late_recpt, late_recpt) + ISNULL(apr_bnr, bnr) + ISNULL(apr_unsold, unsold)+ ISNULL(apr_damage, damage)), 0) as TOTAL
        FROM cir_unsold_dtl WHERE comp_code  = @pcomp_code AND    unit_code  = @punit_code AND    doctype  = @pdoc_type AND    publ  = @ppubl_code
        AND edtn  = @pedtn_code AND supdate  = @v_supdt AND    agcd  = @pagcd_code AND    dpcd  = @pdpcd_code AND    recptno  <> ISNULL(@precptno, '/')
    End
        
    IF ISNULL(@pwaste_flag, 'N')= 'Y' BEGIN 
		SET @v_waste_amt  = ROUND((ISNULL(@punsold, 0) * ISNULL(convert(float,@pwaste_rate), 0)), 2)
	END
    ELSE BEGIN 
		SET @v_waste_amt  = 0 
    END

    SET @v_tot_copy  = ISNULL(CONVERT(FLOAT,@pmissing_recpt), 0)+ ISNULL(CONVERT(FLOAT,@plate_recpt), 0)+ ISNULL(CONVERT(FLOAT,@pbnr_recpt), 0)+ ISNULL(CONVERT(FLOAT,@punsold), 0)+ISNULL(CONVERT(float,@pextra1),'')
   
    SET @v_gross_amt  = ISNULL(CONVERT(FLOAT,@v_tot_copy), 0)* ISNULL(CONVERT(FLOAT,@pcopy_rate), 0)

	If (@pcomm_type='C') --for per copy rate
		Begin
			SET @v_comm_amt  =round((CONVERT(FLOAT,@v_tot_copy)*ISNULL(CONVERT(FLOAT,@pcomm_per),0)),2);
		End
	Else Begin
		SET @v_comm_amt  = ROUND((CONVERT(FLOAT,@v_gross_amt) * ISNULL(CONVERT(FLOAT,@pcomm_per), 0) / CONVERT(FLOAT, 100)), 2)
	End

	SET @v_total_amt  = ROUND((CONVERT(FLOAT,@v_gross_amt) - CONVERT(FLOAT,@v_comm_amt) - CONVERT(FLOAT,@v_waste_amt)), 2)

    SET @v_query  = 'SELECT' + ' ' +CONVERT(varchar(20),@v_tot_copy) + 'as "TOTAL_COPY" ,' +' '+ CONVERT(varchar(20),@v_waste_amt) +' '+ ' as "WASTE_AMOUNT" ,' +' '+ CONVERT(varchar(20),@v_comm_amt) +' '+ ' as "COMM_AMOUNT" ,' +' '+ CONVERT(varchar(20),@v_total_amt) + ' as "TOTAL_AMOUNT"' 
PRINT(@v_query)        
EXEC (@v_query) 

///////////////////////////////////////////////////

ALTER procedure [dbo].[cir_fetch_for_unsold_transfer]
    @pcomp_code      as varchar(20),
    @punit_code      as varchar(20),
    @pbran_code      as varchar(20),
    @pprocess_idno   as numeric(20),
    @ppacket_szie    as int,
    @puserid         as varchar(20), 
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
as
begin

    select distinct x.comp_code as "COMP_CODE",x.unit_code as "UNIT_CODE",x.branch_code as "BRANCH_CODE",x.doctype as "DOCTYPE",
    x.publ as "PUBL",x.publ_name as"PUBL_NAME", x.main_edtn as "MAIN_EDTN",x.main_edtn_name as "MAIN_EDTN_NAME",
    x.edtn as "EDTN",x.edtn_name as "EDTN_NAME",x.copy_rate as "COPY_RATE",x.total_unsold as "TOTAL_UNSOLD",
    ceiling(cast(x.total_unsold as numeric)/@ppacket_szie) AS "PKT"
    from(
    select distinct d.comp_code,d.unit_code,d.branch_code,d.doctype,
    d.publ,p.publ_name, e.main_edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) main_edtn_name,
    d.edtn,e.edtn_name,d.copy_rate,sum(isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0)+isnull(apr_damage,0)) as TOTAL_UNSOLD
    from cir_unsold_hdr h,cir_unsold_dtl d,cir_agmast m,cir_publ_mast p,cir_edtn_mast e,cir_bill_return_print b
    where h.comp_code=d.comp_code and h.comp_code=m.comp_code
     and h.comp_code=p.comp_code and h.comp_code=e.comp_code and h.comp_code=b.comp_code
      and h.comp_code=@pcomp_code 
    and 
    h.unit_code=d.unit_code and h.unit_code=m.unit
     and h.unit_code=b.unit_code 
    and h.unit_code=@punit_code and 
    h.doctype=d.doctype and h.doctype='UCN'
     and h.recptno=d.recptno and h.recptno=b.billno
     and h.recptdt=d.recptdt and h.recptdt=b.billdt
     and
    h.SUP_AGCD=isnull(d.sup_agcd,d.agcd) and h.agcd=m.agcd 
    and h.SUP_DPCD=isnull(d.sup_dpcd,d.dpcd) and h.dpcd=m.dpcd and d.publ=p.publ and d.publ=e.publ and d.edtn=e.edtn
     and  
    d.branch_code=@pbran_code 
    and (isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0)+isnull(apr_damage,0))>0 and b.return_copy=@pprocess_idno
    group by d.comp_code,d.unit_code,d.branch_code,d.doctype,d.publ,p.publ_name,e.main_edtn,d.edtn,e.edtn_name,d.copy_rate) x
    order by comp_code,unit_code,publ_name,main_edtn_name,edtn_name,copy_rate;
    
    select getdate() as "CUR_DATE"
    
    delete from cir_bill_return_print where return_copy=@pprocess_idno
    
End

///////////////////////////////////////////


ALTER procedure [dbo].[cir_unsold_supply_for_transfer]
    @pcomp_code         as varchar(20),
    @punit_code         as varchar(20),
    @pbran_code         as varchar(20),
    @pfromdate          as varchar(20),
    @ptilldate          as varchar(20),
    @puserid            as varchar(20),   
    @pdateformat        as varchar(20),
    @pextra1            as varchar(200),--for publication
    @pextra2            as varchar(200),
    @pextra3            as varchar(200),
    @pextra4            as varchar(200),
    @pextra5            as varchar(200),
    @pextra6            as varchar(200),
    @pextra7            as varchar(200),
    @pextra8            as varchar(200),               
    @pextra9            as varchar(200),
    @pextra10           as varchar(200)
As
Begin
	
    declare @v_process_id    numeric(30)
	DECLARE @v_frdt  DATETIME
	DECLARE @v_todt  DATETIME

	SET @v_frdt  =  DBO.convert_user_date('/', @pfromdate,@pdateformat)
	SET @v_todt   =  DBO.convert_user_date('/', @ptilldate,@pdateformat)

PRINT(@v_frdt)
PRINT(@v_todt)
    exec cir_generate_processid @pcomp_code,@puserid,@pdateformat,null,null,null,null,null,@v_process_id OUTPUT
    
    select distinct d.comp_code as "COMP_CODE",d.unit_code as "UNIT_CODE",d.branch_code as "BRANCH_CODE",d.doctype as "DOCTYPE",
    d.recptno as "RECPTNO",d.recptdt as "RECPTDT",d.sup_agcd as "SUP_AGCD" ,d.sup_dpcd as "SUP_DPCD",m.ag_name as "SUPPLY_AGENCY",
    dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) drop_point_name, dbo.cir_get_city(d.comp_code,m.city_code) city_name,
    dbo.cir_get_agency(d.comp_code,d.unit_code,d.agcd,d.dpcd) as "BILLING_AGENCY",
    sum(isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0)+isnull(apr_damage,0)) as "TOTAL_UNSOLD",
    @v_process_id as "PROCESS_IDNO" 
    from cir_unsold_hdr h,cir_unsold_dtl d,cir_agmast m
    where h.comp_code=d.comp_code and h.comp_code=m.comp_code and h.comp_code=@pcomp_code and h.unit_code=d.unit_code and h.unit_code=m.unit and h.unit_code=@punit_code and 
    h.doctype=d.doctype and h.doctype='UCN' and h.recptno=d.recptno and h.recptdt=d.recptdt and h.recptdt between @v_frdt and @v_todt and --@pfromdate and @ptilldate and 
    h.SUP_AGCD=isnull(d.sup_agcd,d.agcd) and h.SUP_AGCD=m.agcd and h.SUP_DPCD=isnull(d.sup_dpcd,d.dpcd) and h.SUP_DPCD=m.dpcd and 
    d.branch_code=isnull(@pbran_code,d.branch_code) and (isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0)+isnull(apr_damage,0))>0 and
    (h.branch_trfno is null or h.branch_trfno='') and (h.PUBL=@pextra1 or @pextra1 is null or @pextra1='')
    group by d.comp_code,d.unit_code,d.branch_code,d.doctype,d.recptno,d.recptdt,d.sup_agcd,d.sup_dpcd,m.ag_name,m.station_code, m.city_code,d.agcd,d.dpcd
    order by comp_code,unit_code,recptdt,recptno;
	
        
End

/////////////////////////////////////////////////////end/////////////////////////////////////////////

**********************Rikkee Garg issue no.7425 27/6/12******************************

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
	@pextra2            VARCHAR(400) --order by
AS 
/*select getdate()*/
DECLARE @vquery			varchar(8000) 
	DECLARE @vfrdt			DATETIME 
	DECLARE @vtodt			DATETIME 
	declare @v_statecode	VARCHAR(20)
	declare @v_distcode		VARCHAR(20)
	declare @v_citycode		VARCHAR(20)
	declare @v_taluka		VARCHAR(20)

	--SET @vfrdt  = dbo.convert_user_date('/', @pfrom_billdt,@pdateformat)
	--SET @vtodt  = dbo.convert_user_date('/', @ptill_billdt,@pdateformat)
declare @v_route as varchar(20)
declare @v_exec as varchar(20)
set @v_statecode	=''
	set @v_distcode	=''
	set @v_citycode		=''
	set @v_taluka		=''
	set @v_route		=''
	set @v_exec		=''

SET @vfrdt  = @pfrom_billdt
	SET @vtodt  = @ptill_billdt
	If @repty='1' Begin--State
        set @v_statecode=@pextra1
	End
    Else if @repty='2' Begin    --District
        set @v_distcode=@pextra1
    End
    Else if @repty='3' Begin    --Taluka
        set @v_taluka=@pextra1
    End
    Else if @repty='4' Begin    --route
        set @v_route=@pextra1
    End
    Else if @repty='5' Begin    --exec
        set @v_exec=@pextra1
    End
    Else Begin--City
        set @v_citycode=@pextra1
	End

print(@v_distcode)
	IF ISNULL(@repty, 'N')= '1' BEGIN --FOR STATE
		set @vquery='select b.comp_code AS "COMP_CODE", b.unit_code AS "UNIT_CODE", b.billno AS "BILLNO", b.billdt AS "BILLDT", b.agcd AS "AGCD", b.dpcd AS "DPCD", 
		min(b.publ) AS "PUBL", sum(b.bill_copy) AS "BILL_COPY", sum(b.gross_amount) AS "GROSS_AMOUNT", sum(b.sur_amt) AS "SUR_AMOUNT", sum(b.comm_amt) AS "COMM_AMOUNT",
		sum(b.bill_amount) AS "BILL_AMOUNT",max(b.bill_flag) AS "BILL_FLAG",null as  "BILL_REMARK", max(b.userid) AS "USERID", max(b.creation_date) AS "CREATION_DATE", 
		b.branch_code AS "BRANCH_CODE",m.ag_name AS "AGENCY_NAME",DBO.cir_get_city(b.comp_code,m.city_code) as "CITY_NAME" ,
		DBO.cir_get_state(b.comp_code, m.country_code, m.state_code) as "STATE_NAME"
	
,case	(select max(tax_calc_type) from cir_tax_mast 
							where comp_code='''+@pcomp_code+''' and tax_type_id=1 and tax_status=''Y'' and 
								valid_from=(select max(valid_from) from cir_tax_mast
								where comp_code='''+@pcomp_code+''' and tax_type_id=1 and tax_status=''Y'' and 
								valid_from<='''+@ptill_billdt+'''))
when ''F'' then   (select max(tax_rate) from cir_tax_mast 
							where comp_code='''+@pcomp_code+''' and tax_type_id=1 and tax_status=''Y'' and 
								valid_from=(select max(valid_from) from cir_tax_mast
								where comp_code='''+@pcomp_code+''' and tax_type_id=1 and tax_status=''Y'' and 
								valid_from<='''+@ptill_billdt+''')+sum(b.bill_amount) )
else  (round(((select max(tax_rate) from cir_tax_mast 
							where comp_code='''+@pcomp_code+''' and tax_type_id=1 and tax_status=''Y'' and 
								valid_from=(select max(valid_from) from cir_tax_mast
								where comp_code='''+@pcomp_code+''' and tax_type_id=1 and tax_status=''Y'' and 
								valid_from<='''+@ptill_billdt+'''))/100)*sum(b.bill_amount),2))+sum(b.bill_amount) end tax_amt



		from cir_bill_det b,cir_agmast m
		where b.comp_code = '''+@pcomp_code+''' and m.comp_code=b.comp_code and (b.unit_code = isnull('''+@punit_code+''',b.unit_code) OR '''+@punit_code+'''='''') and 
		m.unit=b.unit_code and (b.agcd = isnull('''+@pbillagcd+''',b.agcd) OR '''+@pbillagcd+'''='''')
 and m.agcd=b.agcd and (b.dpcd = isnull('''+@pbilldpcd+''',b.dpcd) OR '''+@pbilldpcd+'''='''') and  
m.dpcd=b.dpcd and b.billdt >= '''+@pfrom_billdt+''' and billdt <='''+@ptill_billdt+'''
and (b.bill_flag = isnull('''+@pbill_freq+''',b.bill_flag) OR '''+@pbill_freq+'''='''') 
and 
		(b.publ = isnull('''+@ppubl+''',b.publ) OR '''+@ppubl+'''='''') 
and (m.state_code='''+@v_statecode+''' or '''+@v_statecode+''' is null OR '''+@v_statecode+'''='''') 
and (m.dist_code='''+@v_distcode+''' or '''+@v_distcode+''' is null OR '''+@v_distcode+'''='''')
and 
		(m.tehsil_taluka='''+@v_taluka+''' or '''+@v_taluka+''' is null or '''+@v_taluka+'''='''') 
and (m.city_code='''+@v_citycode+''' or '''+@v_citycode+''' is null or '''+@v_citycode+'''='''')
		group by b.comp_code, b.unit_code, b.billno ,b.billdt,b.agcd, b.dpcd,m.ag_name,b.branch_code,m.city_code,m.country_code,m.state_code
		order by comp_code, state_name,'+@pextra2+'' --billdt,billno,agency_name


/*

 
*/
--		 
	END	
    else IF ISNULL(@repty, 'N')= '2'  BEGIN--FOR DISTRICT
		set @vquery='select b.comp_code AS "COMP_CODE", b.unit_code AS "UNIT_CODE", b.billno AS "BILLNO", b.billdt AS "BILLDT", b.agcd AS "AGCD", b.dpcd AS "DPCD", 
		min(b.publ) AS "PUBL", sum(b.bill_copy) AS "BILL_COPY", sum(b.gross_amount) AS "GROSS_AMOUNT", sum(b.sur_amt) AS "SUR_AMOUNT", sum(b.comm_amt) AS "COMM_AMOUNT",
		sum(b.bill_amount) AS "BILL_AMOUNT",max(b.bill_flag) AS "BILL_FLAG",null as  "BILL_REMARK", max(b.userid) AS "USERID", max(b.creation_date) AS "CREATION_DATE", 
		b.branch_code AS "BRANCH_CODE",m.ag_name AS "AGENCY_NAME",DBO.cir_get_city(b.comp_code,m.city_code) as "CITY_NAME" ,
		DBO.cir_get_state(b.comp_code, m.country_code, m.state_code) as "STATE_NAME",
		DBO.cir_get_dist(b.comp_code, m.state_code, m.dist_code) as "DIST_NAME"

,case	(select max(tax_calc_type) from cir_tax_mast 
							where comp_code='''+@pcomp_code+''' and tax_type_id=1 and tax_status=''Y'' and 
								valid_from=(select max(valid_from) from cir_tax_mast
								where comp_code='''+@pcomp_code+''' and tax_type_id=1 and tax_status=''Y'' and 
								valid_from<='''+@ptill_billdt+'''))
when ''F'' then   (select max(tax_rate) from cir_tax_mast 
							where comp_code='''+@pcomp_code+''' and tax_type_id=1 and tax_status=''Y'' and 
								valid_from=(select max(valid_from) from cir_tax_mast
								where comp_code='''+@pcomp_code+''' and tax_type_id=1 and tax_status=''Y'' and 
								valid_from<='''+@ptill_billdt+''')+sum(b.bill_amount) )
else  (round(((select max(tax_rate) from cir_tax_mast 
							where comp_code='''+@pcomp_code+''' and tax_type_id=1 and tax_status=''Y'' and 
								valid_from=(select max(valid_from) from cir_tax_mast
								where comp_code='''+@pcomp_code+''' and tax_type_id=1 and tax_status=''Y'' and 
								valid_from<='''+@ptill_billdt+'''))/100)*sum(b.bill_amount),2))+sum(b.bill_amount) end tax_amt



		from cir_bill_det b,cir_agmast m
		where b.comp_code = '''+@pcomp_code+''' and m.comp_code=b.comp_code and (b.unit_code = isnull('''+@punit_code+''',b.unit_code) OR '''+@punit_code+'''='''') and 
		m.unit=b.unit_code and (b.agcd = isnull('''+@pbillagcd+''',b.agcd) OR '''+@pbillagcd+'''='''') and m.agcd=b.agcd and (b.dpcd = isnull('''+@pbilldpcd+''',b.dpcd) OR '''+@pbilldpcd+'''='''') and  
		m.dpcd=b.dpcd and b.billdt >= '''+@pfrom_billdt+''' and billdt <='''+@ptill_billdt+''' and (b.bill_flag = isnull('''+@pbill_freq+''',b.bill_flag) OR '''+@pbill_freq+'''='''') and 
		(b.publ = isnull('''+@ppubl+''',b.publ) OR '''+@ppubl+'''='''') and (m.state_code='''+@v_statecode+''' or '''+@v_statecode+''' is null OR '''+@v_statecode+'''='''') and (m.dist_code='''+@v_distcode+''' or '''+@v_distcode+''' is null OR '''+@v_distcode+'''='''') and 
		(m.tehsil_taluka='''+@v_taluka+''' or '''+@v_taluka+''' is null or '''+@v_taluka+'''='''') and (m.city_code='''+@v_citycode+''' or '''+@v_citycode+''' is null or '''+@v_citycode+'''='''')
		group by b.comp_code, b.unit_code, b.billno ,b.billdt,b.agcd, b.dpcd,m.ag_name,b.branch_code,m.city_code,m.country_code,m.state_code,m.dist_code
		order by comp_code, state_name,dist_name,'+@pextra2+''--billdt,billno,agency_name
	END
	else IF ISNULL(@repty, 'N')= '3' BEGIN 		
		set @vquery='select b.comp_code AS "COMP_CODE", b.unit_code AS "UNIT_CODE", b.billno AS "BILLNO", b.billdt AS "BILLDT", b.agcd AS "AGCD", b.dpcd AS "DPCD", 
		min(b.publ) AS "PUBL", sum(b.bill_copy) AS "BILL_COPY", sum(b.gross_amount) AS "GROSS_AMOUNT", sum(b.sur_amt) AS "SUR_AMOUNT", sum(b.comm_amt) AS "COMM_AMOUNT",
		sum(b.bill_amount) AS "BILL_AMOUNT",max(b.bill_flag) AS "BILL_FLAG",null as  "BILL_REMARK", max(b.userid) AS "USERID", max(b.creation_date) AS "CREATION_DATE", 
		b.branch_code AS "BRANCH_CODE",m.ag_name AS "AGENCY_NAME",DBO.cir_get_city(b.comp_code,m.city_code) as "CITY_NAME" ,
		DBO.cir_get_state(b.comp_code, m.country_code, m.state_code) as "STATE_NAME",
		DBO.cir_get_taluka(b.comp_code, m.tehsil_taluka) as "TALUKA_NAME"

,case	(select max(tax_calc_type) from cir_tax_mast 
							where comp_code='''+@pcomp_code+''' and tax_type_id=1 and tax_status=''Y'' and 
								valid_from=(select max(valid_from) from cir_tax_mast
								where comp_code='''+@pcomp_code+''' and tax_type_id=1 and tax_status=''Y'' and 
								valid_from<='''+@ptill_billdt+'''))
when ''F'' then   (select max(tax_rate) from cir_tax_mast 
							where comp_code='''+@pcomp_code+''' and tax_type_id=1 and tax_status=''Y'' and 
								valid_from=(select max(valid_from) from cir_tax_mast
								where comp_code='''+@pcomp_code+''' and tax_type_id=1 and tax_status=''Y'' and 
								valid_from<='''+@ptill_billdt+''')+sum(b.bill_amount) )
else  (round(((select max(tax_rate) from cir_tax_mast 
							where comp_code='''+@pcomp_code+''' and tax_type_id=1 and tax_status=''Y'' and 
								valid_from=(select max(valid_from) from cir_tax_mast
								where comp_code='''+@pcomp_code+''' and tax_type_id=1 and tax_status=''Y'' and 
								valid_from<='''+@ptill_billdt+'''))/100)*sum(b.bill_amount),2))+sum(b.bill_amount) end tax_amt



		from cir_bill_det b,cir_agmast m
		where b.comp_code = '''+@pcomp_code+''' and m.comp_code=b.comp_code and (b.unit_code = isnull('''+@punit_code+''',b.unit_code) OR '''+@punit_code+'''='''') and 
		m.unit=b.unit_code and (b.agcd = isnull('''+@pbillagcd+''',b.agcd) OR '''+@pbillagcd+'''='''') and m.agcd=b.agcd and (b.dpcd = isnull('''+@pbilldpcd+''',b.dpcd) OR '''+@pbilldpcd+'''='''') and  
		m.dpcd=b.dpcd and b.billdt >= '''+@pfrom_billdt+''' and billdt <='''+@ptill_billdt+''' and (b.bill_flag = isnull('''+@pbill_freq+''',b.bill_flag) OR '''+@pbill_freq+'''='''') and 
		(b.publ = isnull('''+@ppubl+''',b.publ) OR '''+@ppubl+'''='''') and (m.state_code='''+@v_statecode+''' or '''+@v_statecode+''' is null OR '''+@v_statecode+'''='''') and (m.dist_code='''+@v_distcode+''' or '''+@v_distcode+''' is null OR '''+@v_distcode+'''='''') and 
		(m.tehsil_taluka='''+@v_taluka+''' or '''+@v_taluka+''' is null or '''+@v_taluka+'''='''') and (m.city_code='''+@v_citycode+''' or '''+@v_citycode+''' is null or '''+@v_citycode+'''='''')
		group by b.comp_code, b.unit_code, b.billno ,b.billdt,b.agcd, b.dpcd,m.ag_name,b.branch_code,m.city_code,m.country_code,m.state_code,m.tehsil_taluka
		order by comp_code, state_name,taluka_name,'+@pextra2+''--billdt,billno,agency_name
	END	
	else IF ISNULL(@repty, 'N')= '4'  BEGIN--FOR Route
		set @vquery='select b.comp_code AS "COMP_CODE", b.unit_code AS "UNIT_CODE", b.billno AS "BILLNO", b.billdt AS "BILLDT", b.agcd AS "AGCD", b.dpcd AS "DPCD", 
		min(b.publ) AS "PUBL", sum(b.bill_copy) AS "BILL_COPY", sum(b.gross_amount) AS "GROSS_AMOUNT", sum(b.sur_amt) AS "SUR_AMOUNT", sum(b.comm_amt) AS "COMM_AMOUNT",
		sum(b.bill_amount) AS "BILL_AMOUNT",max(b.bill_flag) AS "BILL_FLAG",null as  "BILL_REMARK", max(b.userid) AS "USERID", max(b.creation_date) AS "CREATION_DATE", 
		b.branch_code AS "BRANCH_CODE",m.ag_name AS "AGENCY_NAME",DBO.cir_get_city(b.comp_code,m.city_code) as "CITY_NAME" ,
		DBO.cir_get_state(b.comp_code, m.country_code, m.state_code) as "STATE_NAME",
		p.route_code,DBO.cir_get_route_name(b.comp_code, b.unit_code, p.route_code) as "ROUTE_NAME"

,case	(select max(tax_calc_type) from cir_tax_mast 
							where comp_code='''+@pcomp_code+''' and tax_type_id=1 and tax_status=''Y'' and 
								valid_from=(select max(valid_from) from cir_tax_mast
								where comp_code='''+@pcomp_code+''' and tax_type_id=1 and tax_status=''Y'' and 
								valid_from<='''+@ptill_billdt+'''))
when ''F'' then   (select max(tax_rate) from cir_tax_mast 
							where comp_code='''+@pcomp_code+''' and tax_type_id=1 and tax_status=''Y'' and 
								valid_from=(select max(valid_from) from cir_tax_mast
								where comp_code='''+@pcomp_code+''' and tax_type_id=1 and tax_status=''Y'' and 
								valid_from<='''+@ptill_billdt+''')+sum(b.bill_amount) )
else  (round(((select max(tax_rate) from cir_tax_mast 
							where comp_code='''+@pcomp_code+''' and tax_type_id=1 and tax_status=''Y'' and 
								valid_from=(select max(valid_from) from cir_tax_mast
								where comp_code='''+@pcomp_code+''' and tax_type_id=1 and tax_status=''Y'' and 
								valid_from<='''+@ptill_billdt+'''))/100)*sum(b.bill_amount),2))+sum(b.bill_amount) end tax_amt



		from cir_bill_det b,cir_agmast m,cir_dbksup p
		where b.comp_code = '''+@pcomp_code+''' 
		and m.comp_code=p.comp_code and m.agcd=p.agcd and m.dpcd=p.dpcd and b.comp_code=p.comp_code and b.agcd=p.agcd and b.dpcd=p.dpcd
		and m.comp_code=b.comp_code and (b.unit_code = isnull('''+@punit_code+''',b.unit_code) OR '''+@punit_code+'''='''') and 
		m.unit=b.unit_code and (b.agcd = isnull('''+@pbillagcd+''',b.agcd) OR '''+@pbillagcd+'''='''') and m.agcd=b.agcd and (b.dpcd = isnull('''+@pbilldpcd+''',b.dpcd) OR '''+@pbilldpcd+'''='''') and  
		m.dpcd=b.dpcd and b.billdt >= '''+@pfrom_billdt+''' and billdt <='''+@ptill_billdt+''' and (b.bill_flag = isnull('''+@pbill_freq+''',b.bill_flag) OR '''+@pbill_freq+'''='''') and 
		(b.publ = isnull('''+@ppubl+''',b.publ) OR '''+@ppubl+'''='''') and (m.state_code='''+@v_statecode+''' or '''+@v_statecode+''' is null OR '''+@v_statecode+'''='''') and (m.dist_code='''+@v_distcode+''' or '''+@v_distcode+''' is null OR '''+@v_distcode+'''='''') and 
		(m.city_code='''+@v_citycode+''' or '''+@v_citycode+''' is null or '''+@v_citycode+'''='''')
		and (p.route_code='''+@v_route+''' or '''+@v_route+''' is null or '''+@v_route+'''='''')
		group by b.comp_code, b.unit_code, b.billno ,b.billdt,b.agcd, b.dpcd,m.ag_name,b.branch_code,m.city_code,m.country_code,m.state_code,p.route_code
		order by comp_code, state_name,ROUTE_NAME,'+@pextra2+''--billdt,billno,agency_name
	END
	else IF ISNULL(@repty, 'N')= '5'  BEGIN--FOR executive
		set @vquery='select b.comp_code AS "COMP_CODE", b.unit_code AS "UNIT_CODE", b.billno AS "BILLNO", b.billdt AS "BILLDT", b.agcd AS "AGCD", b.dpcd AS "DPCD", 
		min(b.publ) AS "PUBL", sum(b.bill_copy) AS "BILL_COPY", sum(b.gross_amount) AS "GROSS_AMOUNT", sum(b.sur_amt) AS "SUR_AMOUNT", sum(b.comm_amt) AS "COMM_AMOUNT",
		sum(b.bill_amount) AS "BILL_AMOUNT",max(b.bill_flag) AS "BILL_FLAG",null as  "BILL_REMARK", max(b.userid) AS "USERID", max(b.creation_date) AS "CREATION_DATE", 
		b.branch_code AS "BRANCH_CODE",m.ag_name AS "AGENCY_NAME",DBO.cir_get_city(b.comp_code,m.city_code) as "CITY_NAME" ,
		DBO.cir_get_state(b.comp_code, m.country_code, m.state_code) as "STATE_NAME",
		m.executive_code,DBO.cir_get_executive(b.comp_code, m.executive_code) as "EXEC_NAME"

,case	(select max(tax_calc_type) from cir_tax_mast 
							where comp_code='''+@pcomp_code+''' and tax_type_id=1 and tax_status=''Y'' and 
								valid_from=(select max(valid_from) from cir_tax_mast
								where comp_code='''+@pcomp_code+''' and tax_type_id=1 and tax_status=''Y'' and 
								valid_from<='''+@ptill_billdt+'''))
when ''F'' then   (select max(tax_rate) from cir_tax_mast 
							where comp_code='''+@pcomp_code+''' and tax_type_id=1 and tax_status=''Y'' and 
								valid_from=(select max(valid_from) from cir_tax_mast
								where comp_code='''+@pcomp_code+''' and tax_type_id=1 and tax_status=''Y'' and 
								valid_from<='''+@ptill_billdt+''')+sum(b.bill_amount) )
else  (round(((select max(tax_rate) from cir_tax_mast 
							where comp_code='''+@pcomp_code+''' and tax_type_id=1 and tax_status=''Y'' and 
								valid_from=(select max(valid_from) from cir_tax_mast
								where comp_code='''+@pcomp_code+''' and tax_type_id=1 and tax_status=''Y'' and 
								valid_from<='''+@ptill_billdt+'''))/100)*sum(b.bill_amount),2))+sum(b.bill_amount) end tax_amt



		from cir_bill_det b,cir_agmast m
		where b.comp_code = '''+@pcomp_code+''' and m.comp_code=b.comp_code and (b.unit_code = isnull('''+@punit_code+''',b.unit_code) OR '''+@punit_code+'''='''') and 
		m.unit=b.unit_code and (b.agcd = isnull('''+@pbillagcd+''',b.agcd) OR '''+@pbillagcd+'''='''') and m.agcd=b.agcd and (b.dpcd = isnull('''+@pbilldpcd+''',b.dpcd) OR '''+@pbilldpcd+'''='''') and  
		m.dpcd=b.dpcd and b.billdt >= '''+@pfrom_billdt+''' and billdt <='''+@ptill_billdt+''' 
		and (b.bill_flag = isnull('''+@pbill_freq+''',b.bill_flag) OR '''+@pbill_freq+'''='''') 
		and (b.publ = isnull('''+@ppubl+''',b.publ) OR '''+@ppubl+'''='''') 
		and (m.state_code='''+@v_statecode+''' or '''+@v_statecode+''' is null OR '''+@v_statecode+'''='''') 
		and (m.dist_code='''+@v_distcode+''' or '''+@v_distcode+''' is null OR '''+@v_distcode+'''='''') 
		and (m.executive_code='''+@v_exec+''' or '''+@v_exec+''' is null or '''+@v_exec+'''='''') 
		and	(m.city_code='''+@v_citycode+''' or '''+@v_citycode+''' is null or '''+@v_citycode+'''='''')
		group by b.comp_code, b.unit_code, b.billno ,b.billdt,b.agcd, b.dpcd,m.ag_name,b.branch_code,m.city_code,m.country_code,m.state_code,m.executive_code
		order by comp_code, state_name,EXEC_NAME,'+@pextra2+''
	END
	ELSE BEGIN
print('11')
		set @vquery='select b.comp_code AS "COMP_CODE", b.unit_code AS "UNIT_CODE", b.billno AS "BILLNO", b.billdt AS "BILLDT", b.agcd AS "AGCD", b.dpcd AS "DPCD", 
		min(b.publ) AS "PUBL", sum(b.bill_copy) AS "BILL_COPY", sum(b.gross_amount) AS "GROSS_AMOUNT", sum(b.sur_amt) AS "SUR_AMOUNT", sum(b.comm_amt) AS "COMM_AMOUNT",
		sum(b.bill_amount) AS "BILL_AMOUNT",max(b.bill_flag) AS "BILL_FLAG",null as  "BILL_REMARK", max(b.userid) AS "USERID", max(b.creation_date) AS "CREATION_DATE", 
		b.branch_code AS "BRANCH_CODE",m.ag_name AS "AGENCY_NAME",DBO.cir_get_city(b.comp_code,m.city_code) as "CITY_NAME" ,
		DBO.cir_get_state(b.comp_code, m.country_code, m.state_code) as "STATE_NAME"
,case	(select max(tax_calc_type) from cir_tax_mast 
							where comp_code='''+@pcomp_code+''' and tax_type_id=1 and tax_status=''Y'' and 
								valid_from=(select max(valid_from) from cir_tax_mast
								where comp_code='''+@pcomp_code+''' and tax_type_id=1 and tax_status=''Y'' and 
								valid_from<='''+@ptill_billdt+'''))
when ''F'' then   (select max(tax_rate) from cir_tax_mast 
							where comp_code='''+@pcomp_code+''' and tax_type_id=1 and tax_status=''Y'' and 
								valid_from=(select max(valid_from) from cir_tax_mast
								where comp_code='''+@pcomp_code+''' and tax_type_id=1 and tax_status=''Y'' and 
								valid_from<='''+@ptill_billdt+''')+sum(b.bill_amount) )
else  (round(((select max(tax_rate) from cir_tax_mast 
							where comp_code='''+@pcomp_code+''' and tax_type_id=1 and tax_status=''Y'' and 
								valid_from=(select max(valid_from) from cir_tax_mast
								where comp_code='''+@pcomp_code+''' and tax_type_id=1 and tax_status=''Y'' and 
								valid_from<='''+@ptill_billdt+'''))/100)*sum(b.bill_amount),2))+sum(b.bill_amount) end tax_amt



		from cir_bill_det b,cir_agmast m
		where b.comp_code = '''+@pcomp_code+''' and m.comp_code=b.comp_code and (b.unit_code = isnull('''+@punit_code+''',b.unit_code) OR '''+@punit_code+'''='''') and 
		m.unit=b.unit_code and (b.agcd = isnull('''+@pbillagcd+''',b.agcd) OR '''+@pbillagcd+'''='''') and m.agcd=b.agcd and (b.dpcd = isnull('''+@pbilldpcd+''',b.dpcd) OR '''+@pbilldpcd+'''='''') and  
		m.dpcd=b.dpcd and b.billdt >= '''+@pfrom_billdt+''' and billdt <='''+@ptill_billdt+''' and (b.bill_flag = isnull('''+@pbill_freq+''',b.bill_flag) OR '''+@pbill_freq+'''='''') and 
		(b.publ = isnull('''+@ppubl+''',b.publ) OR '''+@ppubl+'''='') and (m.state_code='''+@v_statecode+''' or '''+@v_statecode+''' is null OR '''+@v_statecode+'''='') and (m.dist_code='''+@v_distcode+''' or '''+@v_distcode+''' is null OR '''+@v_distcode+'''='''') and 
		(m.tehsil_taluka='''+@v_taluka+''' or '''+@v_taluka+''' is null or '''+@v_taluka+'''='''') and (m.city_code='''+@v_citycode+''' or '''+@v_citycode+''' is null or '''+@v_citycode+'''='''')
		group by b.comp_code, b.unit_code, b.billno ,b.billdt,b.agcd, b.dpcd,m.ag_name,b.branch_code,m.city_code,m.country_code,m.state_code
		order by comp_code, state_name,'+@pextra2+''--billdt,billno,agency_name
	end
PRINT(@vquery)
exec(@vquery)
*********************************************************************************************
ALTER PROCEDURE [dbo].[cir_billing_p]
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
	DECLARE @agency_rec_agcd		varchar(20)
	DECLARE @agency_rec_dpcd		varchar(20)
	DECLARE @agency_rec_route_code	varchar(20)
	
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
	
	declare @v_bill_exist	numeric(10)
	declare @v_vat_allow    varchar(1);
	declare @v_tax_calc_type    varchar(1);
	declare @v_tax_amt      numeric(15,2);
	declare @v_tax_prate    numeric(15,3);   
	declare @v_tax_frate    numeric(15,3);

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
    
    select @vbill_publwise=cir_bill_publwise,@v_vat_allow=cir_vat_allow from preferrences where "comp_code"=@pcomp_code

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
			m.ag_name ag_name,m.print_seq print_seqno,@vrec_publ agbill_publ,
			a.acc_agcd acc_agcd,a.acc_dpcd acc_dpcd,a.route_code route_code
			from
			(select distinct a.comp_code,a.unit,a.bill_agcd,a.bill_dpcd,
			isnull(a.account_agcd,a.bill_agcd) acc_agcd,isnull(a.account_dpcd,a.bill_dpcd) acc_dpcd,
			max(s.route_code) route_code
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
			group by a.comp_code,a.unit,a.bill_agcd,a.bill_dpcd,
                isnull(a.account_agcd,a.bill_agcd),isnull(a.account_dpcd,a.bill_dpcd)) a,cir_agmast m
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
		fetch NEXT FROM agency_cur INTO @vcomp_code1 , @vunit1 ,@vbill_agcd1, @vbill_dpcd1 , @vbranch_code1, @vcity_name1, @vag_name1,@vprint_seqno1,@vagbill_publ1,@agency_rec_agcd,@agency_rec_dpcd,@agency_rec_route_code
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
					
					declare @rec_tax_tax_rate		numeric(15,3)
					declare @rec_tax_tax_calc_type	varchar(1)
					
					declare cur_tax cursor for
						select tax_rate,tax_calc_type from cir_tax_mast 
							where comp_code=@pcomp_code and tax_type_id=1 and tax_status='Y' and 
								valid_from=(select max(valid_from) from cir_tax_mast
								where comp_code=@pcomp_code and tax_type_id=1 and tax_status='Y' and 
								valid_from<=@ptodt);

                if @v_vat_allow='Y' begin
                    open cur_tax
                    fetch NEXT FROM cur_tax INTO @rec_tax_tax_rate,@rec_tax_tax_calc_type
						WHILE (@@FETCH_STATUS = 0) begin
                        if @rec_tax_tax_calc_type='P' begin
                            set @v_tax_amt	=isnull(@v_tax_amt,0)+round((isnull(@daily_net_amount,0)*isnull(@rec_tax_tax_rate,0))/100,2);
                            set @v_tax_prate=isnull(@v_tax_prate,0)+isnull(@rec_tax_tax_rate,0);
                            set @v_tax_calc_type=@rec_tax_tax_calc_type
                        end
                        else begin
                            set @v_tax_amt=isnull(@v_tax_amt,0)+round(isnull(@daily_net_amount,0)+isnull(@rec_tax_tax_rate,0),2);
                            set @v_tax_frate=isnull(@v_tax_frate,0)+isnull(@rec_tax_tax_rate,0);
                              set @v_tax_calc_type=@rec_tax_tax_calc_type
                        end
						fetch NEXT FROM cur_tax INTO @rec_tax_tax_rate,@rec_tax_tax_calc_type
                    end
                    close cur_tax
deallocate  cur_tax
                end
                else begin
                    set @v_tax_amt   =0;
                    set @v_tax_prate =0;
                    set @v_tax_frate =0;
                end

					INSERT INTO  cir_bill(comp_code , unit_code ,billno , 	billdt , agcd , dpcd , publ , bill_copy , gross_amount , 
					sur_amount , comm_amount, bill_amount , bill_frdt ,bill_todt , bill_flag , bill_remark , userid , creation_date , bill_sec_amt , branch_code,sec_per_rate,
					route_code,tax_rate,tax_amt,accagcd,accdpcd,tax_calc_type)
					VALUES (@vcomp_code1 , @vunit1 , @vbill_no , @v_billdt , @vbill_agcd1 , @vbill_dpcd1 ,@vpubl11 , isnull(@tot_copy, 0) , 
					isnull(@daily_gross_amount, 0)+isnull(@v_tax_amt, 0) , isnull(@tot_surcharge_amt, 0) , isnull(@vcomm_amt, 0) , @daily_net_amount , 
					@v_frdt , @v_todt , @pbill_freq , CAST(CONVERT(VARCHAR(23), @v_billdt) AS VARCHAR) + ' Billing' , @puserid , 
					GETDATE() , isnull(@v_bill_sec_amt, 0) , @v_bran_code,@v_agcd_sec_per,
					@agency_rec_route_code,isnull(@v_tax_prate,isnull(@v_tax_frate,0)),@v_tax_amt,@agency_rec_agcd,@agency_rec_dpcd,@v_tax_calc_type) 
					

					INSERT INTO  cir_outmast( comp_code , unit_code , agcd , dpcd , doctyp , billno , billdt , publ , amount , 
					remark , voucherno , usrid , creation_date , bill_sec_amt , branch_code )  
					VALUES ( @vcomp_code1 , @vunit1, @vbill_agcd1 , @vbill_dpcd1 , 'BIL' , @vbill_no , @v_billdt , @vpubl11 , 
					isnull(@daily_gross_amount, 0)+isnull(@v_tax_amt, 0) , CAST(CONVERT(VARCHAR(23), @v_billdt) AS VARCHAR) + ' Billing' , @vbill_no , @puserid , 
					GETDATE() , isnull(@v_bill_sec_amt, 0) , @v_bran_code )
					
					INSERT INTO  cir_bill_det   ( comp_code , unit_code , billno , billdt ,agcd , dpcd ,coag , 	codp , publ , edtn , 
					copy_rate , comm_flag , comm_rate , sur_rate , fromdt , todt , bill_copy , gross_amount , comm_amt , sur_amt , 
					bill_amount , bill_flag , branch_code,comm_type,accagcd,accdpcd )  
					SELECT comp_code, unit_code, @vbill_no billno, billdt, agcd, dpcd, agcd, dpcd, publ, edtn, copy_rate, comm_flag,
					comm_rate, sur_rate, MIN(fromdt) fromdt, MAX(todt) todt, SUM(bill_copy) bill_copy,
					SUM(CONVERT(FLOAT, gross_amount)) gross_amount,SUM(CONVERT(FLOAT, comm_amt)) comm_amt,SUM(CONVERT(FLOAT, sur_amt)) sur_amt,
					SUM(CONVERT(FLOAT, bill_amount)) bill_amount, @pbill_freq, @v_bran_code,comm_type,@agency_rec_agcd,@agency_rec_dpcd
					FROM  #cir_bill_det_temp 
					GROUP BY comp_code, unit_code, billdt, agcd, dpcd, publ, edtn, copy_rate, comm_flag, comm_rate,  sur_rate ,comm_type
					
					delete FROM  #cir_bill_det_temp;
					
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
						SET @v_tax_amt   =0
						SET @v_tax_prate =NULL
						SET @v_tax_frate =NULL
			    END
   
			fetch NEXT FROM agency_cur INTO @vcomp_code1 , @vunit1 ,@vbill_agcd1, @vbill_dpcd1 , @vbranch_code1, @vcity_name1, @vag_name1,@vprint_seqno1,@vagbill_publ1,@agency_rec_agcd,@agency_rec_dpcd,@agency_rec_route_code
		
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

************************************************************************
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
DECLARE  @vwaste_catg_code		VARCHAR(500)

/************add by prachi***/
DECLARE  @vsp_supply_mon1 VARCHAR(500)
DECLARE  @vsp_supply_tue1 VARCHAR(500)
DECLARE  @vsp_supply_wed1 VARCHAR(500)
DECLARE  @vsp_supply_thu1 VARCHAR(500)
DECLARE  @vsp_supply_fri1 VARCHAR(500)
DECLARE  @vsp_supply_sat1 VARCHAR(500)
DECLARE  @vsp_supply_sun1 VARCHAR(500)
DECLARE  @vsp_supply_mon2 VARCHAR(500)
DECLARE  @vsp_supply_tue2 VARCHAR(500)
DECLARE  @vsp_supply_wed2 VARCHAR(500)
DECLARE  @vsp_supply_thu2 VARCHAR(500)
DECLARE  @vsp_supply_fri2 VARCHAR(500)
DECLARE  @vsp_supply_sat2 VARCHAR(500)
DECLARE  @vsp_supply_sun2 VARCHAR(500)
/************add by prachi***/
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
print('prachi')
print(@vthu_rate1)
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
		a.supply_spl2 supply_spl2
/************add by prachi***/
, a.sp_supply_mon1 sp_supply_mon1,a.sp_supply_tue1 sp_supply_tue1,a.sp_supply_wed1 sp_supply_wed1,a.sp_supply_thu1 sp_supply_thu1,
a.sp_supply_fri1 sp_supply_fri1,a.sp_supply_sat1 sp_supply_sat1,a.sp_supply_sun1 sp_supply_sun1,a.sp_supply_mon2 sp_supply_mon2,
a.sp_supply_tue2 sp_supply_tue2,a.sp_supply_wed2 sp_supply_wed2,a.sp_supply_thu2 sp_supply_thu2,a.sp_supply_fri2 sp_supply_fri2,
a.sp_supply_sat2 sp_supply_sat2,a.sp_supply_sun2 sp_supply_sun2
/************add by prachi***/


, b.ag_type ag_type,b.supply_start_dt    supply_start_dt,b.suspend_date suspend_date, ISNULL(a.packet_size,0) packet_size,
		a.comm_code comm_code,a.comm_flag comm_flag,b.bill_agcd bill_agcd,b.bill_dpcd bill_dpcd,
		a.route_code route_code,a.subroute_code subroute_code,a.sub_subroute_code sub_subroute_code,
		a.surch_cd surch_cd,a.waste_catg_code waste_catg_code
		from cir_supply a,cir_agmast b
		where a.comp_code=b.comp_code and a.unit=b.unit and 
				  a.agcd=b.agcd and a.dpcd=b.dpcd and (a.agcd=@pagcd or @pagcd is null or @pagcd='') 
				  and (a.dpcd=@pdpcd or @pdpcd is null OR @pdpcd='') and 
				  a.unit=@punit_code and (a.publ=@ppubl_code) and
				  /*ISNULL(base_supply,0)>0 and*/
				  a.edtn=@vedtn1 and
				  ISNULL(a.supply_flag,'N')='Y' and ISNULL(b.suspend,'N')='N'
		order by a.agcd,a.dpcd,a.edtn,a.supply_type_code;


		 open cur_supply 

		 fetch next from cur_supply into @vunit1 ,@vagcd1 ,@vdpcd1 ,@vpubl1 ,@vedtn11 ,@vsupply_type_code1,@vbase_supply1,
		 @vsupply_sun1 ,@vsupply_mon1 ,@vsupply_tue1 ,@vsupply_wed1 ,@vsupply_thu1 ,@vsupply_fri1,@vsupply_sat1 ,@vsupply_spl11,
		 @vsupply_spl21,

/************add by prachi***/
 @vsp_supply_mon1,
 @vsp_supply_tue1,
 @vsp_supply_wed1,
 @vsp_supply_thu1,
 @vsp_supply_fri1,
 @vsp_supply_sat1,
 @vsp_supply_sun1,
 @vsp_supply_mon2,
 @vsp_supply_tue2,
 @vsp_supply_wed2,
 @vsp_supply_thu2,
 @vsp_supply_fri2,
 @vsp_supply_sat2,
 @vsp_supply_sun2,
/************add by prachi***/

@vag_type1 ,@vsupply_start_dt1, @vsuspend_date1 ,@vpacket_size1 ,@vcomm_code1 ,@vcomm_flag1 ,@vbill_agcd1 ,@vbill_dpcd1,
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
/***********************add by prachi****************************/

else if @psup_ty='SM1' begin    
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsp_supply_mon1,0)>0 begin
					
						set @v_sup_copy   =     ISNULL(@vbase_supply1,0)+ISNULL(@vsp_supply_mon1,0);
                    
                    end
                    else begin
						set @v_sup_copy   = 0
                    end 
end
else if @psup_ty='ST1' begin    
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsp_supply_tue1,0)>0 begin
					
						set @v_sup_copy   =     ISNULL(@vbase_supply1,0)+ISNULL(@vsp_supply_tue1,0);
                    
                    end
                    else begin
						set @v_sup_copy   = 0
                    end 
end
else if @psup_ty='SW1' begin    
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsp_supply_wed1,0)>0 begin
					
						set @v_sup_copy   =     ISNULL(@vbase_supply1,0)+ISNULL(@vsp_supply_wed1,0);
                    
                    end
                    else begin
						set @v_sup_copy   = 0
                    end 
end
else if @psup_ty='STH1' begin    
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsp_supply_thu1,0)>0 begin
					
						set @v_sup_copy   =     ISNULL(@vbase_supply1,0)+ISNULL(@vsp_supply_thu1,0);
                    
                    end
                    else begin
						set @v_sup_copy   = 0
                    end 

end
else if @psup_ty='SF1' begin    
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsp_supply_fri1,0)>0 begin
					
						set @v_sup_copy   =     ISNULL(@vbase_supply1,0)+ISNULL(@vsp_supply_fri1,0);
                    
                    end
                    else begin
						set @v_sup_copy   = 0
                    end 
end
else if @psup_ty='SST1' begin    
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsp_supply_sat1,0)>0 begin
					
						set @v_sup_copy   =     ISNULL(@vbase_supply1,0)+ISNULL(@vsp_supply_sat1,0);
                    
                    end
                    else begin
						set @v_sup_copy   = 0
                    end 
end
else if @psup_ty='SSN1' begin    
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsp_supply_sun1,0)>0 begin
					
						set @v_sup_copy   =     ISNULL(@vbase_supply1,0)+ISNULL(@vsp_supply_sun1,0);
                    
                    end
                    else begin
						set @v_sup_copy   = 0
                    end 
end
else if @psup_ty='SM2' begin    
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsp_supply_mon2,0)>0 begin
					
						set @v_sup_copy   =     ISNULL(@vbase_supply1,0)+ISNULL(@vsp_supply_mon2,0);
                    
                    end
                    else begin
						set @v_sup_copy   = 0
                    end 
end
else if @psup_ty='ST2' begin    
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsp_supply_tue2,0)>0 begin
					
						set @v_sup_copy   =     ISNULL(@vbase_supply1,0)+ISNULL(@vsp_supply_tue2,0);
                    
                    end
                    else begin
						set @v_sup_copy   = 0
                    end 
end
else if @psup_ty='SW2' begin    
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsp_supply_wed2,0)>0 begin
					
						set @v_sup_copy   =     ISNULL(@vbase_supply1,0)+ISNULL(@vsp_supply_wed2,0);
                    
                    end
                    else begin
						set @v_sup_copy   = 0
                    end 

end
else if @psup_ty='STH2' begin    
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsp_supply_thu2,0)>0 begin
					
						set @v_sup_copy   =     ISNULL(@vbase_supply1,0)+ISNULL(@vsp_supply_thu2,0);
                    
                    end
                    else begin
						set @v_sup_copy   = 0
                    end 
end
else if @psup_ty='SF2' begin    
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsp_supply_fri2,0)>0 begin
					
						set @v_sup_copy   =     ISNULL(@vbase_supply1,0)+ISNULL(@vsp_supply_fri2,0);
                    
                    end
                    else begin
						set @v_sup_copy   = 0
                    end 

end
else if @psup_ty='SST2' begin    
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsp_supply_sat2,0)>0 begin
					
						set @v_sup_copy   =     ISNULL(@vbase_supply1,0)+ISNULL(@vsp_supply_sat2,0);
                    
                    end
                    else begin
						set @v_sup_copy   = 0
                    end 

end
else if @psup_ty='SSN2' begin    
					if ISNULL(@vbase_supply1,0)+ISNULL(@vsp_supply_sun2,0)>0 begin
					
						set @v_sup_copy   =     ISNULL(@vbase_supply1,0)+ISNULL(@vsp_supply_sun2,0);
                    
                    end
                    else begin
						set @v_sup_copy   = 0
                    end 
end

/*****************add by prachi************************************************/
		
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
									 @vsubroute_code1,@vsub_subroute_code1,@puserid,@vsurch_cd1,@pextra2,@pper_copy_wt,isnull(@vwaste_catg_code,0));

				select @vreccnt	= count(*)  from cir_dbksup where comp_code=@pcomp_code and unit_code=@punit_code 
				and publ=@ppubl_code and edtn=@vedtn1 and supdate=@vsup_date and (agcd=@pagcd or @pagcd is null) and (dpcd=@pdpcd or @pdpcd is null);
				print('cdcd')
					               
			End;                     
		end 
    

         fetch next from cur_supply into @vunit1 ,@vagcd1 ,@vdpcd1 ,@vpubl1 ,@vedtn11 ,@vsupply_type_code1,@vbase_supply1,
		 @vsupply_sun1 ,@vsupply_mon1 ,@vsupply_tue1 ,@vsupply_wed1 ,@vsupply_thu1 ,@vsupply_fri1,@vsupply_sat1 ,@vsupply_spl11,
		 @vsupply_spl21, 
/************add by prachi***/
 @vsp_supply_mon1,
 @vsp_supply_tue1,
 @vsp_supply_wed1,
 @vsp_supply_thu1,
 @vsp_supply_fri1,
 @vsp_supply_sat1,
 @vsp_supply_sun1,
 @vsp_supply_mon2,
 @vsp_supply_tue2,
 @vsp_supply_wed2,
 @vsp_supply_thu2,
 @vsp_supply_fri2,
 @vsp_supply_sat2,
 @vsp_supply_sun2,
/************add by prachi***/
@vag_type1 ,@vsupply_start_dt1, @vsuspend_date1 ,@vpacket_size1 ,@vcomm_code1 ,@vcomm_flag1 ,@vbill_agcd1 ,@vbill_dpcd1,
		 @vroute_code1 ,@vsubroute_code1 ,@vsub_subroute_code1 ,@vsurch_cd1,@vwaste_catg_code 

	end 
	close cur_supply;
	deallocate cur_supply
	   
	set @v_edtn_rate = 0;
	set @v_spl_rate  =0;
	set @vedtn1=NULL;
  print('3333333333')
fetch NEXT FROM cir_edtn_cur into @vedtn1 , @vedtn_name1
end
close cir_edtn_cur
deallocate  cir_edtn_cur  
end 
  print('rerere')
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


************************************end of issue 7425********************************************
************************Rikkee Garg sended by Gaurav Sir for supply Correction 27/6/2012**********


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
        -- (a.branch_code = @pbran_code or @pbran_code is null) and
       --  a.city_code in (select city_code from cir_city_mast where a.comp_code=@pcomp_code and city_code = isnull(@pcity_code,city_code) and 
--(zone_code = @pzone_code or @pzone_code is null or @pzone_code='') and (region_code = @pregion_code or @pregion_code is null or @pregion_code=''))
  (a.branch_code in(select  distinct l.branch_code from login_branch_mast l where a.branch_code=l.branch_code and (a.branch_code=@pbran_code or @pbran_code is null or @pbran_code='')and  l.user_code=@pextra2 and isnull(l.user_flag,'N')='Y' ))  and
 a.city_code in (select city_code from cir_city_mast where a.comp_code=@pcomp_code and city_code = isnull(@pcity_code,city_code) and 
        (zone_code in(select  distinct l.zone_code from login_zone_mast l where zone_code=l.zone_code and (zone_code=@pzone_code or @pzone_code is null or @pzone_code='')and  l.user_code=@pextra2 and isnull(l.user_flag,'N')='Y' ))  and
        (region_code in(select  distinct l.region_code from login_region_mast l where region_code=l.region_code and (region_code=@pregion_code or @pregion_code is null or @pregion_code='')and  l.user_code=@pextra2 and isnull(l.user_flag,'N')='Y' ))  
         )

         
         order by route_seq,supply_seq,agency_name
  End       
  else Begin
      if @pextra1=2 Begin---for edition district and agency wise
					if @pextra3 ='M' begin
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
			(a.branch_code in(select  distinct l.branch_code from login_branch_mast l where a.branch_code=l.branch_code and (a.branch_code=@pbran_code or @pbran_code is null or @pbran_code='')and  l.user_code=@pextra2 and isnull(l.user_flag,'N')='Y' ))  and
			 a.city_code in (select city_code from cir_city_mast where a.comp_code=@pcomp_code and city_code = isnull(@pcity_code,city_code) and 
					(zone_code in(select  distinct l.zone_code from login_zone_mast l where zone_code=l.zone_code and (zone_code=@pzone_code or @pzone_code is null or @pzone_code='')and  l.user_code=@pextra2 and isnull(l.user_flag,'N')='Y' ))  and
					(region_code in(select  distinct l.region_code from login_region_mast l where region_code=l.region_code and (region_code=@pregion_code or @pregion_code is null or @pregion_code='')and  l.user_code=@pextra2 and isnull(l.user_flag,'N')='Y' ))  
					and (c.SUP_COPY > CAST(@pextra4 as int) or @pextra4 is null or @pextra4 ='')
			        
					 )
					 order by dist_name,agency_name,supply_seq
					 
			end
			else
			begin
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
(a.branch_code in(select  distinct l.branch_code from login_branch_mast l where a.branch_code=l.branch_code and (a.branch_code=@pbran_code or @pbran_code is null or @pbran_code='')and  l.user_code=@pextra2 and isnull(l.user_flag,'N')='Y' ))  and
 a.city_code in (select city_code from cir_city_mast where a.comp_code=@pcomp_code and city_code = isnull(@pcity_code,city_code) and 
        (zone_code in(select  distinct l.zone_code from login_zone_mast l where zone_code=l.zone_code and (zone_code=@pzone_code or @pzone_code is null or @pzone_code='')and  l.user_code=@pextra2 and isnull(l.user_flag,'N')='Y' ))  and
        (region_code in(select  distinct l.region_code from login_region_mast l where region_code=l.region_code and (region_code=@pregion_code or @pregion_code is null or @pregion_code='')and  l.user_code=@pextra2 and isnull(l.user_flag,'N')='Y' ))  
        and (c.SUP_COPY < CAST(@pextra4 as int) or @pextra4 is null or @pextra4 ='')
        
         )
         order by dist_name,agency_name,supply_seq
 end
          
   End         
      else Begin
		if @pextra3 = 'M' begin
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
					-- (a.branch_code = @pbran_code or @pbran_code is null) and
					-- a.city_code in (select city_code from cir_city_mast where a.comp_code=@pcomp_code and city_code = isnull(@pcity_code,city_code) and 
					-- (zone_code = @pzone_code or @pzone_code is null) and (region_code = @pregion_code or @pregion_code is null))
		(a.branch_code in(select  distinct l.branch_code from login_branch_mast l where a.branch_code=l.branch_code and (a.branch_code=@pbran_code or @pbran_code is null or @pbran_code='')and  l.user_code=@pextra2 and isnull(l.user_flag,'N')='Y' ))  and
		 a.city_code in (select city_code from cir_city_mast where a.comp_code=@pcomp_code and city_code = isnull(@pcity_code,city_code) and 
				(zone_code in(select  distinct l.zone_code from login_zone_mast l where zone_code=l.zone_code and (zone_code=@pzone_code or @pzone_code is null or @pzone_code='')and  l.user_code=@pextra2 and isnull(l.user_flag,'N')='Y' ))  and
				(region_code in(select  distinct l.region_code from login_region_mast l where region_code=l.region_code and (region_code=@pregion_code or @pregion_code is null or @pregion_code='')and  l.user_code=@pextra2 and isnull(l.user_flag,'N')='Y' ))  
				and (c.SUP_COPY > CAST(@pextra4 as int) or @pextra4 is null or @pextra4 ='')
				 )
					 order by route_seq,supply_seq,agency_name
		end
		else
		begin
		
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
			-- (a.branch_code = @pbran_code or @pbran_code is null) and
			-- a.city_code in (select city_code from cir_city_mast where a.comp_code=@pcomp_code and city_code = isnull(@pcity_code,city_code) and 
			-- (zone_code = @pzone_code or @pzone_code is null) and (region_code = @pregion_code or @pregion_code is null))
(a.branch_code in(select  distinct l.branch_code from login_branch_mast l where a.branch_code=l.branch_code and (a.branch_code=@pbran_code or @pbran_code is null or @pbran_code='')and  l.user_code=@pextra2 and isnull(l.user_flag,'N')='Y' ))  and
 a.city_code in (select city_code from cir_city_mast where a.comp_code=@pcomp_code and city_code = isnull(@pcity_code,city_code) and 
        (zone_code in(select  distinct l.zone_code from login_zone_mast l where zone_code=l.zone_code and (zone_code=@pzone_code or @pzone_code is null or @pzone_code='')and  l.user_code=@pextra2 and isnull(l.user_flag,'N')='Y' ))  and
        (region_code in(select  distinct l.region_code from login_region_mast l where region_code=l.region_code and (region_code=@pregion_code or @pregion_code is null or @pregion_code='')and  l.user_code=@pextra2 and isnull(l.user_flag,'N')='Y' ))  
        and (c.SUP_COPY < CAST(@pextra4 as int) or @pextra4 is null or @pextra4 ='')
         )
			 order by route_seq,supply_seq,agency_name
	end
	End
End   

***************************end ******************************************************************

*********************** Rikkee Garg sended by Gaurav sir Editionwise net billing 27/6/2012******

ALTER procedure [dbo].[cir_rep_edtnwise_billing_p]
(
    @pcompcode        as varchar(50),
    @punitcode        as varchar(50),
    @pbranchcode      as varchar(50),
    @ppublcode        as varchar(50),
    @pmedtncode       as varchar(50),
    @pedtncode        as varchar(50),
    @pdistcode        as varchar(50),
    @ptaluka          as varchar(50),
    @pfrom_date       as datetime,--for supply from date
    @ptill_date       as datetime,--for supply till date
    @pagencytype      as varchar(50),
    @pagencyclass     as varchar(50),
    @ptrantype        as varchar(50),--for Type Agency(A)/Distribution(D) 
    @preptype         as varchar(50),--for Datewise(D)/Edition Rate Wise(S)
    @prettype         as varchar(50),--for Return Based Received Date(R)/Supply Date(S)
    @pretsup_frdt     as varchar(50),--for return based on from supply date 
    @pretsup_todt     as varchar(50),--for return based on till supply date
    @puserid          as varchar(50),
    @pdateformat      as varchar(50),
    @pextra1          as varchar(50),
    @pextra2          as varchar(50),
    @pextra3          as varchar(50),
    @pextra4          as varchar(50),
    @pextra5          as varchar(50)
)

as


declare @v_frdt     as datetime
declare  @v_todt    as datetime

declare  @v_ret_frdt  datetime;
declare  @v_ret_todt  datetime 

declare @v_return_copy     numeric(10);
declare @v_return_amt      numeric(10,2)
declare @vbill_no          varchar(20)
declare @v_rec_amt         numeric
declare @v_rcp_count       numeric
declare @v_prev_agcd       varchar(30) 
declare @v_cur_agcd        varchar(30)

set @v_prev_agcd='XX'; 
set @v_cur_agcd='XX';
set @v_rec_amt=0;
set @v_rcp_count=0;



set @v_frdt=@pfrom_date
set @v_todt=@ptill_date

 if @prettype='R' begin
        set @v_ret_frdt = @pretsup_frdt
        set @v_ret_todt = @pretsup_todt
 end

declare @cur_not_sup_comp_code as varchar(10)
declare @cur_not_sup_unit_code as varchar(10)
declare @cur_not_sup_agcd as varchar(10)
declare @cur_not_sup_dpcd as varchar(10)
declare @cur_not_sup_publ as varchar(100)
declare @cur_not_sup_edtn as varchar(100)
declare @cur_not_sup_supply_date as datetime
declare @cur_not_sup_copy_rate as numeric(14,2)
--

declare @cur_agcd_comp_code as varchar(10)
declare @cur_agcd_unit_code as varchar(10)
declare @cur_agcd_publ as varchar(100)
declare @cur_agcd_billagcd as varchar(10)
declare @cur_agcd_billdpcd as varchar(10)
--@cur_agcd_comp_code,@cur_agcd_unit_code,@cur_agcd_publ,@cur_agcd_billagcd,@cur_agcd_billdpcd



DECLARE cur_not_supply cursor LOCAL FOR 
		select distinct u.comp_code comp_code,u.unit_code unit_code,u.publ agcd,u.edtn dpcd,u.publ publ,u.edtn edtn,
		u.supply_date supply_date,u.copy_rate copy_rate from
		(
			select d.comp_code,d.unit_code,d.publ,d.edtn,d.recptdt supply_date,d.copy_rate from cir_agmast m,cir_unsold_dtl d,cir_edtn_mast e
			where d.comp_code=m.comp_code and d.comp_code=e.comp_code and d.comp_code=@pcompcode and d.unit_code=m.unit and 
			d.unit_code=e.unit_code and d.unit_code=@punitcode and 
			d.publ=e.publ and (d.publ=isnull(@ppublcode,d.publ)or @ppublcode ='') 
			and d.edtn=e.edtn and (d.edtn=isnull(@pedtncode,d.edtn) or @pedtncode='') 		 
			and  (
			(@prettype='S' and d.app_dt >= @v_frdt  and d.app_dt<=@v_todt) 
			or 
			(@prettype='R' and d.app_dt >= @v_ret_frdt  and d.app_dt<@v_ret_todt and d.supdate >= @v_frdt  and d.supdate<=@v_todt)
			)			 
			 and d.agcd=m.agcd  and d.dpcd=m.dpcd and (m.ag_type=@pagencytype or @pagencytype is null OR	@pagencytype ='') and 
			(m.ag_class=@pagencyclass or @pagencyclass is null or @pagencyclass ='') 
			and (m.dist_code=@pdistcode or @pdistcode is null or @pdistcode ='') and 
			(m.tehsil_taluka=@ptaluka or @ptaluka is null or @ptaluka='') 
			and (m.branch_code=@pbranchcode or @pbranchcode is null or @pbranchcode='') and
			(e.main_edtn=isnull(@pmedtncode,e.main_edtn) or @pmedtncode ='') and d.supply_copy>0 and 
			(isnull(d.apr_late_recpt,0)+isnull(d.apr_short_recpt,0)+isnull(d.apr_bnr,0)+isnull(d.apr_unsold,0))>0 
			 AND NOT EXISTS
			(
				SELECT f.comp_code,f.unit_code,f.publ_code publ,f.edtn_code edtn,f.supply_date,f.supply_rate copy_rate
				FROM  cir_bill_print f WHERE	 comp_code  = @pcompcode
				AND	unit_code  = @punitcode AND	supply_date  >= @v_frdt
				AND	supply_date  <= @v_todt AND	supply_copy  > 0
				AND	cur_sessionid  = @@SPID AND	d.comp_code  = f.comp_code AND	d.unit_code  = f.unit_code
				AND	d.publ  = f.publ_code AND	d.edtn  = f.edtn_code AND	d.recptdt  = f.supply_date
				AND	d.copy_rate  = f.supply_rate
			)
			) u
            where (@ptrantype<>'D' or @ptrantype is null)			
         union all
			select distinct u.comp_code comp_code,u.unit_code unit_code,u.publ agcd,u.edtn dpcd,u.publ publ,u.edtn edtn,
			u.supply_date supply_date,u.copy_rate copy_rate from
			(select d.comp_code,d.unit_code,d.publ,d.edtn,d.recptdt supply_date,d.copy_rate from cir_agmast_dis m,cir_unsold_dtl_dis d,cir_edtn_mast e
			where d.comp_code=m.comp_code and d.comp_code=e.comp_code and d.comp_code=@pcompcode and d.unit_code=m.unit and 
			d.unit_code=e.unit_code and d.unit_code=@punitcode and 
			d.publ=e.publ and (d.publ=isnull(@ppublcode,d.publ) or @ppublcode ='') 
			and d.edtn=e.edtn and (d.edtn=isnull(@pedtncode,d.edtn) or @pedtncode ='') and                  
			((@prettype='S' and d.app_dt >= @v_frdt  and d.app_dt<=@v_todt) or 
			(@prettype='R' and d.app_dt >= @v_ret_frdt  and d.app_dt<@v_ret_todt 
			and d.supdate >= @v_frdt  and d.supdate<=@v_todt)) and
			d.agcd=m.agcd  and d.dpcd=m.dpcd 
			and (m.ag_type=@pagencytype or @pagencytype is null or @pagencytype ='') and 
			(m.ag_class=@pagencyclass or @pagencyclass is null or @pagencyclass ='') 
			and (m.dist_code=@pdistcode or @pdistcode is null or @pdistcode ='') and 
			(m.tehsil_taluka=@ptaluka or @ptaluka is null or @ptaluka='') 
			and (m.branch_code=@pbranchcode or @pbranchcode is null or @pbranchcode ='') and
			(e.main_edtn=isnull(@pmedtncode,e.main_edtn) or @pmedtncode='') and d.supply_copy>0 and 
			(isnull(d.apr_late_recpt,0)+isnull(d.apr_short_recpt,0)+isnull(d.apr_bnr,0)+isnull(d.apr_unsold,0))>0            
			AND NOT EXISTS
			(
				SELECT f.comp_code,f.unit_code,f.publ_code publ,f.edtn_code edtn,f.supply_date,f.supply_rate copy_rate
				FROM  cir_bill_print f WHERE	 comp_code  = @pcompcode
				AND	unit_code  = @punitcode AND	supply_date  >= @v_frdt
				AND	supply_date  <= @v_todt AND	supply_copy  > 0
				AND	cur_sessionid  = @@SPID AND	d.comp_code  = f.comp_code AND	d.unit_code  = f.unit_code
				AND	d.publ  = f.publ_code AND	d.edtn  = f.edtn_code AND	d.recptdt  = f.supply_date
				AND	d.copy_rate  = f.supply_rate
			)
       ) u where @ptrantype='D'             

   

declare cur_agcd cursor LOCAL FOR 
        select distinct d.comp_code comp_code,d.unit_code unit_code,'' publ,d.publ_code billagcd,d.edtn_code billdpcd  
        from cir_bill_print d 
        where d.comp_code=@pcompcode and d.unit_code=@punitcode and d.supply_date>= @v_frdt  and d.supply_date<=@v_todt and 
        (d.publ_code=@ppublcode or @ppublcode is null or @ppublcode ='') and 
        (isnull(d.supply_copy,0)+isnull(return_copy,0))>0 and d.cur_sessionid=@@spid
        group by d.comp_code,d.unit_code,d.publ_code,d.edtn_code
        order by d.comp_code,d.unit_code,d.publ_code,d.edtn_code;    



print('a')
print(@ptrantype) -- A 
print(@prettype) ----  S

delete from cir_bill_print where cur_sessionid=@@spid
/*if @ptrantype='D' begin
    exec cir_rep_dis_before_bill_p pcompcode,punitcode,'',ppublcode,pmedtncode,pedtncode,pfrom_date,ptill_date,'','',pagencytype,pagencyclass ,pbranchcode, pdistcode , ptaluka,pdateformat,puserid,prettype,v_ret_frdt,v_ret_todt,'',''
end
else
begin
    exec cir_rep_agency_before_bill_p pcompcode,punitcode,'',ppublcode,pmedtncode,pedtncode,pfrom_date,ptill_date,'','',pagencytype,pagencyclass ,pbranchcode, pdistcode , ptaluka,pdateformat,puserid,prettype,v_ret_frdt,v_ret_todt,'',''
end
*/

	OPEN cur_not_supply 
		fetch NEXT FROM cur_not_supply INTO @cur_not_sup_comp_code,@cur_not_sup_unit_code ,@cur_not_sup_agcd ,@cur_not_sup_dpcd ,@cur_not_sup_publ, @cur_not_sup_edtn,@cur_not_sup_supply_date,@cur_not_sup_copy_rate
		WHILE (@@FETCH_STATUS = 0) BEGIN print('P')print(@cur_not_sup_agcd)
			set @v_cur_agcd  =@cur_not_sup_agcd+@cur_not_sup_agcd;
			
			if @v_prev_agcd<>@v_cur_agcd begin--XX & A0002
				set @v_prev_agcd =@v_cur_agcd;
	        
				select @vbill_no=max(cast(billno as numeric))  from cir_bill_print 
				where comp_code=@pcompcode and unit_code=@punitcode and supply_date>= @v_frdt and supply_date<=@v_todt and 
				cur_sessionid=@@spid       
		        
				if cast(@vbill_no as numeric)=0 begin
					select @vbill_no=max(cast(billno as numeric)) from cir_bill_print 
					where comp_code=@pcompcode and unit_code=@punitcode and 
					supply_date>= @v_frdt and supply_date<=@v_todt and 
					cur_sessionid=@@spid
				end
	            
			end
			
			if @ptrantype='D' begin
				if @prettype='S' begin
					select @v_return_copy=sum(isnull(apr_late_recpt,0)+isnull(apr_short_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))
					,@v_return_amt=sum(isnull(copy_amt,0)-isnull(waste_amt,0)) ,
					@v_rec_amt=sum(isnull(comm_amt,0))  from cir_unsold_dtl_dis
						where comp_code=@cur_not_sup_comp_code and unit_code=@cur_not_sup_unit_code and doctype='UCN' and
							app_dt=@cur_not_sup_supply_date and publ=@cur_not_sup_publ and edtn=@cur_not_sup_edtn and 
							copy_rate=@cur_not_sup_copy_rate and
							(isnull(apr_late_recpt,0)+isnull(apr_short_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))>0;
				end
				else
				begin
					select @v_return_copy=sum(isnull(apr_late_recpt,0)+isnull(apr_short_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0)),
					@v_return_amt=sum(isnull(copy_amt,0)-isnull(waste_amt,0)) ,
					@v_rec_amt=sum(isnull(comm_amt,0)) 
						from cir_unsold_dtl_dis
						where comp_code=@cur_not_sup_comp_code and unit_code=@cur_not_sup_unit_code and doctype='UCN' and
							app_dt between @v_ret_frdt and @v_ret_todt and publ=@cur_not_sup_publ and edtn=@cur_not_sup_edtn and 
							copy_rate=@cur_not_sup_copy_rate and supdate=@cur_not_sup_supply_date and 
							(isnull(apr_late_recpt,0)+isnull(apr_short_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))>0;
				end
		end                        
        else
        begin
            if @prettype='S' begin
                select @v_return_copy=sum(isnull(apr_late_recpt,0)+isnull(apr_short_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0)),
                @v_return_amt=sum(isnull(copy_amt,0)-isnull(waste_amt,0)) , 
                @v_rec_amt=sum(isnull(comm_amt,0))
                    from cir_unsold_dtl
                    where comp_code=@cur_not_sup_comp_code and unit_code=@cur_not_sup_unit_code and doctype='UCN' and
                        app_dt=@cur_not_sup_supply_date and publ=@cur_not_sup_publ and edtn=@cur_not_sup_edtn and 
                        copy_rate=@cur_not_sup_copy_rate and
                        (isnull(apr_late_recpt,0)+isnull(apr_short_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))>0;        
            end
            else
            begin
                select @v_return_copy=sum(isnull(apr_late_recpt,0)+isnull(apr_short_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0)),
                @v_return_amt=sum(isnull(copy_amt,0)-isnull(waste_amt,0)) , 
                    @v_rec_amt=sum(isnull(comm_amt,0)) 
                        from cir_unsold_dtl
                        where comp_code=@cur_not_sup_comp_code and unit_code=@cur_not_sup_unit_code and doctype='UCN' and
                            app_dt between @v_ret_frdt and @v_ret_todt and publ=@cur_not_sup_publ and edtn=@cur_not_sup_edtn and 
                            copy_rate=@cur_not_sup_copy_rate and supdate =@cur_not_sup_supply_date and 
                            (isnull(apr_late_recpt,0)+isnull(apr_short_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))>0;
            end
        end
		print('insert') print(@v_return_copy) print(@v_return_amt) print(@v_rec_amt)
		insert into cir_bill_print(comp_code,unit_code,billno,billdt,publ_code,edtn_code,agcd,dpcd,
                                supply_date,supply_copy,supply_rate,gross_amt,comm_rate,comm_amt,sur_rate,sur_amt,
                                return_copy,return_amt,cur_sessionid,rec_amt)
                  values(@cur_not_sup_comp_code,@cur_not_sup_unit_code,@vbill_no,@v_todt,@cur_not_sup_publ,@cur_not_sup_edtn,@cur_not_sup_agcd,@cur_not_sup_dpcd,
                                @cur_not_sup_supply_date,0,@cur_not_sup_copy_rate,0,0,0,0,0,
                                @v_return_copy,@v_return_amt,@@spid,@v_rec_amt);
			
		set @v_return_copy=0
		set @v_return_amt=0
		set @v_rcp_count=0
		set @v_rec_amt=0;	
		fetch NEXT FROM cur_not_supply INTO @cur_not_sup_comp_code,@cur_not_sup_unit_code ,@cur_not_sup_agcd ,@cur_not_sup_dpcd ,@cur_not_sup_publ, @cur_not_sup_edtn,@cur_not_sup_supply_date,@cur_not_sup_copy_rate 
		END
	close cur_not_supply
	DEALLOCATE  cur_not_supply 

if @preptype='D' begin--for datewise

        select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,dbo.cir_get_publ_name(u.comp_code,u.publ) publ_name, 
        u.main_edtn edtn,dbo.cir_get_edtn_name(u.comp_code,u.main_edtn) edtn_name, u.edtn sub_edtn,u.edtn_name sub_edtn_name,
        u.supply_date supply_date,u.supply_rate supply_rate,
        sum(u.supply_copy) supply_copy,sum(u.return_copy) return_copy,sum(u.net_copy) net_copy,
        sum(isnull(u.net_gamt,0)) net_gamt,sum(isnull(u.comm_amt,0)) comm_amt,sum(isnull(u.net_gamt,0))-sum(isnull(u.comm_amt,0)) net_amount
        from(select d.comp_code comp_code,d.unit_code unit_code,d.publ_code publ,e.main_edtn main_edtn,d.edtn_code edtn,e.edtn_name edtn_name,d.supply_date supply_date,d.supply_rate supply_rate,
        sum(isnull(d.supply_copy,0)) supply_copy,sum(isnull(d.return_copy,0)) return_copy,sum(isnull(d.supply_copy,0)-isnull(d.return_copy,0)) net_copy,
        sum(isnull(d.gross_amt,0))-sum(isnull(d.return_amt,0)+isnull(rec_amt,0)) net_gamt,sum(isnull(d.comm_amt,0)-isnull(d.rec_amt,0)) comm_amt  
        from cir_bill_print d,cir_edtn_mast e 
        where d.comp_code=@pcompcode and d.comp_code=e.comp_code and d.unit_code=e.unit_code and  d.unit_code=@punitcode and 
        d.supply_date >= @v_frdt and d.supply_date<=@v_todt and d.publ_code=e.publ and d.edtn_code=e.edtn and  
        (isnull(d.supply_copy,0)+isnull(return_copy,0))>0 and d.cur_sessionid=@@spid 
        group by d.comp_code,d.unit_code,d.publ_code,e.main_edtn,d.edtn_code,e.edtn_name,d.supply_date,d.supply_rate)u
        group by u.comp_code,u.unit_code,u.publ,u.main_edtn,u.edtn,u.edtn_name,u.supply_date,u.supply_rate
        order by comp_code,unit_code,publ_name,edtn_name,sub_edtn_name,supply_date,supply_rate;
     end
     else--for edition rate wise
     begin
       
        select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,dbo.cir_get_publ_name(u.comp_code,u.publ) publ_name, 
        u.main_edtn edtn,dbo.cir_get_edtn_name(u.comp_code,u.main_edtn) edtn_name, u.edtn sub_edtn,u.edtn_name sub_edtn_name,
        u.supply_rate supply_rate,
        sum(u.supply_copy) supply_copy,sum(u.return_copy) return_copy,sum(u.net_copy) net_copy,
        sum(isnull(u.net_gamt,0)) net_gamt,sum(isnull(u.comm_amt,0)) comm_amt,sum(isnull(u.net_gamt,0))-sum(isnull(u.comm_amt,0)) net_amount
        from(select d.comp_code comp_code,d.unit_code unit_code,d.publ_code publ,e.main_edtn main_edtn,d.edtn_code edtn,e.edtn_name edtn_name,d.supply_date supply_date,d.supply_rate supply_rate,
        sum(isnull(d.supply_copy,0)) supply_copy,sum(isnull(d.return_copy,0)) return_copy,sum(isnull(d.supply_copy,0)-isnull(d.return_copy,0)) net_copy,
        sum(isnull(d.gross_amt,0))-sum(isnull(d.return_amt,0)+isnull(rec_amt,0)) net_gamt,sum(isnull(d.comm_amt,0)-isnull(d.rec_amt,0)) comm_amt  
        from cir_bill_print d,cir_edtn_mast e 
        where d.comp_code=@pcompcode and d.comp_code=e.comp_code and d.unit_code=e.unit_code and  d.unit_code=@punitcode and 
        d.supply_date >= @v_frdt and d.supply_date<=@v_todt and 
        d.publ_code=e.publ and d.edtn_code=e.edtn and (isnull(d.supply_copy,0)+isnull(return_copy,0))>0 and 
        d.cur_sessionid=@@spid 
        group by d.comp_code,d.unit_code,d.publ_code,e.main_edtn,d.edtn_code,e.edtn_name,d.supply_date,d.supply_rate)u
        group by u.comp_code,u.unit_code,u.publ,u.main_edtn,u.edtn,u.edtn_name,u.supply_rate
        order by comp_code,unit_code,publ_name,edtn_name,sub_edtn_name,supply_rate;     
     end  
    
   
    select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,dbo.cir_get_publ_name(u.comp_code,u.publ) publ_name, 
    u.main_edtn edtn,dbo.cir_get_edtn_name(u.comp_code,u.main_edtn) edtn_name,
    sum(u.supply_copy) supply_copy,sum(u.return_copy) return_copy,sum(u.net_copy) net_copy,
    sum(isnull(u.net_gamt,0)) net_gamt,sum(isnull(u.comm_amt,0)) comm_amt,sum(isnull(u.net_gamt,0))-sum(isnull(u.comm_amt,0)) net_amount
    from(select d.comp_code comp_code,d.unit_code unit_code,d.publ_code publ,e.main_edtn main_edtn,d.edtn_code edtn,e.edtn_name edtn_name,d.supply_date supply_date,d.supply_rate supply_rate,
    sum(isnull(d.supply_copy,0)) supply_copy,sum(isnull(d.return_copy,0)) return_copy,sum(isnull(d.supply_copy,0)-isnull(d.return_copy,0)) net_copy,
    sum(isnull(d.gross_amt,0))-sum(isnull(d.return_amt,0)+isnull(rec_amt,0)) net_gamt,sum(isnull(d.comm_amt,0)-isnull(d.rec_amt,0)) comm_amt  
    from cir_bill_print d,cir_edtn_mast e 
    where d.comp_code=@pcompcode and d.comp_code=e.comp_code and d.unit_code=e.unit_code and  d.unit_code=@punitcode and 
    d.supply_date >= @v_frdt and d.supply_date<=@v_todt and 
    d.publ_code=e.publ and d.edtn_code=e.edtn and (isnull(d.supply_copy,0)+isnull(return_copy,0))>0 and 
    d.cur_sessionid=@@spid
    group by d.comp_code,d.unit_code,d.publ_code,e.main_edtn,d.edtn_code,e.edtn_name,d.supply_date,d.supply_rate)u
    group by u.comp_code,u.unit_code,u.publ,u.main_edtn
    order by comp_code,unit_code,publ_name,edtn_name;    

    
    select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,dbo.cir_get_publ_name(u.comp_code,u.publ) publ_name, 
    sum(u.supply_copy) supply_copy,sum(u.return_copy) return_copy,sum(u.net_copy) net_copy,
    sum(isnull(u.net_gamt,0)) net_gamt,sum(isnull(u.comm_amt,0)) comm_amt,sum(isnull(u.net_gamt,0))-sum(isnull(u.comm_amt,0)) net_amount
    from(select d.comp_code comp_code,d.unit_code unit_code,d.publ_code publ,e.main_edtn main_edtn,d.edtn_code edtn,e.edtn_name edtn_name,d.supply_date supply_date,d.supply_rate supply_rate,
    sum(isnull(d.supply_copy,0)) supply_copy,sum(isnull(d.return_copy,0)) return_copy,sum(isnull(d.supply_copy,0)-isnull(d.return_copy,0)) net_copy,
    sum(isnull(d.gross_amt,0))-sum(isnull(d.return_amt,0)+isnull(rec_amt,0)) net_gamt,sum(isnull(d.comm_amt,0)-isnull(d.rec_amt,0)) comm_amt  
    from cir_bill_print d,cir_edtn_mast e 
    where d.comp_code=@pcompcode and d.comp_code=e.comp_code and d.unit_code=e.unit_code and  d.unit_code=@punitcode and 
    d.supply_date >= @v_frdt and d.supply_date<=@v_todt and 
    d.publ_code=e.publ and d.edtn_code=e.edtn and (isnull(d.supply_copy,0)+isnull(return_copy,0))>0 and 
    d.cur_sessionid=@@spid
    group by d.comp_code,d.unit_code,d.publ_code,e.main_edtn,d.edtn_code,e.edtn_name,d.supply_date,d.supply_rate)u
    group by u.comp_code,u.unit_code,u.publ
    order by comp_code,unit_code,publ_name;
    
    
    select u.comp_code comp_code,u.unit_code unit_code, 
    sum(u.supply_copy) supply_copy,sum(u.return_copy) return_copy,sum(u.net_copy) net_copy,
    sum(isnull(u.net_gamt,0)) net_gamt,sum(isnull(u.comm_amt,0)) comm_amt,sum(isnull(u.net_gamt,0))-sum(isnull(u.comm_amt,0)) net_amount
    from(select d.comp_code comp_code,d.unit_code unit_code,d.publ_code publ,e.main_edtn main_edtn,d.edtn_code edtn,e.edtn_name edtn_name,d.supply_date supply_date,d.supply_rate supply_rate,
    sum(isnull(d.supply_copy,0)) supply_copy,sum(isnull(d.return_copy,0)) return_copy,sum(isnull(d.supply_copy,0)-isnull(d.return_copy,0)) net_copy,
    sum(isnull(d.gross_amt,0))-sum(isnull(d.return_amt,0)+isnull(rec_amt,0)) net_gamt,sum(isnull(d.comm_amt,0)-isnull(d.rec_amt,0)) comm_amt  
    from cir_bill_print d,cir_edtn_mast e 
    where d.comp_code=@pcompcode and d.comp_code=e.comp_code and d.unit_code=e.unit_code and  d.unit_code=@punitcode and 
    d.supply_date >= @v_frdt and d.supply_date<=@v_todt and d.publ_code=e.publ and d.edtn_code=e.edtn and 
    (isnull(d.supply_copy,0)+isnull(return_copy,0))>0 and d.cur_sessionid=@@spid
    group by d.comp_code,d.unit_code,d.publ_code,e.main_edtn,d.edtn_code,e.edtn_name,d.supply_date,d.supply_rate)u
    group by u.comp_code,u.unit_code
    order by comp_code,unit_code;
    
    select getdAte() as "CUR DATE"


*********************end*****************************************************

///////////////////////issue 7133  Anuj  28-jun-2012//////////////////////////////////////////////


USE [abhi]
GO
/****** Object:  StoredProcedure [dbo].[cir_rep_national_sale_cir_rep_national_zone]    Script Date: 06/28/2012 14:20:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

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
                             OR    @pcomp_code  IS NULL or @pcomp_code ='')
                             AND    A.UNIT_CODE  = M.UNIT
                             AND    (A.UNIT_CODE  = @punit_code
                             OR    @punit_code  IS NULL or @punit_code='')
                             AND    (M.BRANCH_CODE  = @pbranch_code
                             OR    @pbranch_code  IS NULL or @pbranch_code='')
                             AND    (A.PUBL  = @ppubl
                             OR    @ppubl  IS NULL or @ppubl='')
                             AND    (A.EDTN  = @pedtn
                             OR    @pedtn  IS NULL or @pedtn='')
                             AND    (M.AG_TYPE  = @pag_type
                             OR    @pag_type  IS NULL or @pag_type='')
                             AND    (M.AG_CLASS  = @pag_class
                             OR    @pag_class  IS NULL or @pag_class='')
                             AND    A.AGCD  = M.AGCD
                             AND    A.DPCD  = M.DPCD
                             AND    A.SUP_TYPE_CODE  = B.SUP_TY_CODE
                             AND    (B.BILL_PAY  = @pbill_pay
                             OR    @pbill_pay  IS NULL or @pbill_pay='')
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
                             OR    @pcomp_code  IS NULL or @pcomp_code='')
                             AND    A.COMP_CODE  = C.COMP_CODE
                             AND    A.UNIT_CODE  = C.UNIT_CODE
                             AND    A.UNIT_CODE  = M.UNIT
                             AND    (A.UNIT_CODE  = @punit_code
                             OR    @punit_code  IS NULL or @punit_code='')
                             AND    A.PUBL  = C.PUBL
                             AND    (A.PUBL  = @ppubl
                             OR    @ppubl  IS NULL or @ppubl='')
                             AND    A.EDTN  = C.EDTN
                             AND    (A.EDTN  = @pedtn
                             OR    @pedtn  IS NULL or @pedtn='')
                             AND    (M.AG_TYPE  = @pag_type
                             OR    @pag_type  IS NULL or @pag_type='')
                             AND    (M.AG_CLASS  = @pag_class
                             OR    @pag_class  IS NULL or @pag_class='')
                             AND    A.AGCD  = M.AGCD
                             AND    A.DPCD  = M.DPCD
                             AND    A.SUP_RATE  = C.COPY_RATE
                             AND    A.SUP_TYPE_CODE  = B.SUP_TY_CODE
                             AND    (B.BILL_PAY  = @pbill_pay
                             OR    @pbill_pay  IS NULL or @pbill_pay='')
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
                             OR    @pcomp_code  IS NULL or @pcomp_code='')
                             AND    A.UNIT_CODE  = M.UNIT
                             AND    (A.UNIT_CODE  = @punit_code
                             OR    @punit_code  IS NULL or  @punit_code='')
                             AND    (M.BRANCH_CODE  = @pbranch_code
                             OR    @pbranch_code  IS NULL or @pbranch_code='')
                             AND    (A.PUBL  = @ppubl
                             OR    @ppubl  IS NULL or  @ppubl='')
                             AND    (A.EDTN  = @pedtn
                             OR    @pedtn  IS NULL or @pedtn='')
                             AND    (M.AG_TYPE  = @pag_type
                             OR    @pag_type  IS NULL or @pag_type='')
                             AND    (M.AG_CLASS  = @pag_class
                             OR    @pag_class  IS NULL or @pag_class='')
                             AND    A.AGCD  = M.AGCD
                             AND    A.DPCD  = M.DPCD
                             AND    A.SUP_TYPE_CODE  = B.SUP_TY_CODE
                             AND    (B.BILL_PAY  = @pbill_pay
                             OR    @pbill_pay  IS NULL or @pbill_pay='')
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
                             OR    @pcomp_code  IS NULL or @pcomp_code='')
                             AND    A.COMP_CODE  = C.COMP_CODE
                             AND    A.UNIT_CODE  = C.UNIT_CODE
                             AND    A.UNIT_CODE  = M.UNIT
                             AND    (A.UNIT_CODE  = @punit_code
                             OR    @punit_code  IS NULL or @punit_code='')
                             AND    A.PUBL  = C.PUBL
                             AND    (A.PUBL  = @ppubl
                             OR    @ppubl  IS NULL or @ppubl='')
                             AND    A.EDTN  = C.EDTN
                             AND    (A.EDTN  = @pedtn
                             OR    @pedtn  IS NULL or @pedtn='')
                             AND    (M.AG_TYPE  = @pag_type
                             OR    @pag_type  IS NULL or @pag_type='')
                             AND    (M.AG_CLASS  = @pag_class
                             OR    @pag_class  IS NULL or @pag_class='')
                             AND    A.AGCD  = M.AGCD
                             AND    A.DPCD  = M.DPCD
                             AND    A.SUP_RATE  = C.COPY_RATE
                             AND    A.SUP_TYPE_CODE  = B.SUP_TY_CODE
                             AND    (B.BILL_PAY  = @pbill_pay
                             OR    @pbill_pay  IS NULL or @pbill_pay='')
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
                             OR    @pcomp_code  IS NULL or @pcomp_code='')
                             AND    A.UNIT_CODE  = M.UNIT
                             AND    (A.UNIT_CODE  = @punit_code
                             OR    @punit_code  IS NULL or @punit_code='')
                             AND    (M.BRANCH_CODE  = @pbranch_code
                             OR    @pbranch_code  IS NULL or @pbranch_code='')
                             AND    (A.PUBL  = @ppubl
                             OR    @ppubl  IS NULL or @ppubl='')
                             AND    (A.EDTN  = @pedtn
                             OR    @pedtn  IS NULL or @pedtn='')
                             AND    (M.AG_TYPE  = @pag_type
                             OR    @pag_type  IS NULL or @pag_type='')
                             AND    (M.AG_CLASS  = @pag_class
                             OR    @pag_class  IS NULL or @pag_class='')
                             AND    A.AGCD  = M.AGCD
                             AND    A.DPCD  = M.DPCD
                             AND    A.SUP_TYPE_CODE  = B.SUP_TY_CODE
                             AND    (B.BILL_PAY  = @pbill_pay
                             OR    @pbill_pay  IS NULL or @pbill_pay='')
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
                             OR    @pcomp_code  IS NULL or @pcomp_code='')
                             AND    A.COMP_CODE  = C.COMP_CODE
                             AND    A.UNIT_CODE  = C.UNIT_CODE
                             AND    A.UNIT_CODE  = M.UNIT
                             AND    (A.UNIT_CODE  = @punit_code
                             OR    @punit_code  IS NULL or @punit_code='')
                             AND    A.PUBL  = C.PUBL
                             AND    (A.PUBL  = @ppubl
                             OR    @ppubl  IS NULL or @ppubl='')
                             AND    A.EDTN  = C.EDTN
                             AND    (A.EDTN  = @pedtn
                             OR    @pedtn  IS NULL or @pedtn='')
                             AND    (M.AG_TYPE  = @pag_type
                             OR    @pag_type  IS NULL or @pag_type='')
                             AND    (M.AG_CLASS  = @pag_class
                             OR    @pag_class  IS NULL or @pag_class='')
                             AND    A.AGCD  = M.AGCD
                             AND    A.DPCD  = M.DPCD
                             AND    A.SUP_RATE  = C.COPY_RATE
                             AND    A.SUP_TYPE_CODE  = B.SUP_TY_CODE
                             AND    (B.BILL_PAY  = @pbill_pay
                             OR    @pbill_pay  IS NULL or @pbill_pay='')
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
                             OR    @pcomp_code  IS NULL or @pcomp_code='')
                             AND    A.UNIT_CODE  = M.UNIT
                             AND    (A.UNIT_CODE  = @punit_code
                             OR    @punit_code  IS NULL or @punit_code='')
                             AND    (M.BRANCH_CODE  = @pbranch_code
                             OR    @pbranch_code  IS NULL or @pbranch_code='')
                             AND    (A.PUBL  = @ppubl
                             OR    @ppubl  IS NULL or @ppubl='')
                             AND    (A.EDTN  = @pedtn
                             OR    @pedtn  IS NULL or @pedtn='')
                             AND    (M.AG_TYPE  = @pag_type
                             OR    @pag_type  IS NULL or @pag_type='')
                             AND    (M.AG_CLASS  = @pag_class
                             OR    @pag_class  IS NULL or @pag_class='')
                             AND    A.AGCD  = M.AGCD
                             AND    A.DPCD  = M.DPCD
                             AND    A.SUP_TYPE_CODE  = B.SUP_TY_CODE
                             AND    (B.BILL_PAY  = @pbill_pay
                             OR    @pbill_pay  IS NULL or @pbill_pay='')
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
                             OR    @pcomp_code  IS NULL or @pcomp_code='')
                             AND    A.COMP_CODE  = C.COMP_CODE
                             AND    A.UNIT_CODE  = C.UNIT_CODE
                             AND    A.UNIT_CODE  = M.UNIT
                             AND    (A.UNIT_CODE  = @punit_code
                             OR    @punit_code  IS NULL or @pcomp_code='')
                             AND    A.PUBL  = C.PUBL
                             AND    (A.PUBL  = @ppubl
                             OR    @ppubl  IS NULL or @ppubl='')
                             AND    A.EDTN  = C.EDTN
                             AND    (A.EDTN  = @pedtn
                             OR    @pedtn  IS NULL or @pedtn='')
                             AND    (M.AG_TYPE  = @pag_type
                             OR    @pag_type  IS NULL or @pag_type='')
                             AND    (M.AG_CLASS  = @pag_class
                             OR    @pag_class  IS NULL or @pag_class='')
                             AND    A.AGCD  = M.AGCD
                             AND    A.DPCD  = M.DPCD
                             AND    A.SUP_RATE  = C.COPY_RATE
                             AND    A.SUP_TYPE_CODE  = B.SUP_TY_CODE
                             AND    (B.BILL_PAY  = @pbill_pay
                             OR    @pbill_pay  IS NULL or @pbill_pay='')
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
                             OR    @pcomp_code  IS NULL or @pcomp_code='')
                             AND    A.UNIT_CODE  = M.UNIT
                             AND    (A.UNIT_CODE  = @punit_code
                             OR    @punit_code  IS NULL or @punit_code='')
                             AND    (M.BRANCH_CODE  = @pbranch_code
                             OR    @pbranch_code  IS NULL or @pbranch_code='')
                             AND    (A.PUBL  = @ppubl
                             OR    @ppubl  IS NULL or @ppubl='')
                             AND    (A.EDTN  = @pedtn
                             OR    @pedtn  IS NULL or @pedtn='')
                             AND    (M.AG_TYPE  = @pag_type
                             OR    @pag_type  IS NULL or @pag_type='')
                             AND    (M.AG_CLASS  = @pag_class
                             OR    @pag_class  IS NULL or @pag_class='')
                             AND    A.AGCD  = M.AGCD
                             AND    A.DPCD  = M.DPCD
                             AND    A.SUP_TYPE_CODE  = B.SUP_TY_CODE
                             AND    (B.BILL_PAY  = @pbill_pay
                             OR    @pbill_pay  IS NULL or @pbill_pay='')
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
                             OR    @pcomp_code  IS NULL or @pcomp_code='')
                             AND    A.COMP_CODE  = C.COMP_CODE
                             AND    A.UNIT_CODE  = C.UNIT_CODE
                             AND    A.UNIT_CODE  = M.UNIT
                             AND    (A.UNIT_CODE  = @punit_code
                             OR    @punit_code  IS NULL or @punit_code='')
                             AND    A.PUBL  = C.PUBL
                             AND    (A.PUBL  = @ppubl
                             OR    @ppubl  IS NULL or @ppubl='')
                             AND    A.EDTN  = C.EDTN
                             AND    (A.EDTN  = @pedtn
                             OR    @pedtn  IS NULL or @pedtn='')
                             AND    (M.AG_TYPE  = @pag_type
                             OR    @pag_type  IS NULL or @pag_type='')
                             AND    (M.AG_CLASS  = @pag_class
                             OR    @pag_class  IS NULL or @pag_class='')
                             AND    A.AGCD  = M.AGCD
                             AND    A.DPCD  = M.DPCD
                             AND    A.SUP_RATE  = C.COPY_RATE
                             AND    A.SUP_TYPE_CODE  = B.SUP_TY_CODE
                             AND    (B.BILL_PAY  = @pbill_pay
                             OR    @pbill_pay  IS NULL or @pbill_pay='')
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



////////////////////////////////////////////end//////////////////////////////////////////////////




////////////////////////////////add by Deepika 29/06/2012/////////////////////////////////



                                                                     
                                                                     
                                             
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
      @puserid			 as varchar(20),
      @pextra1           as varchar(200),--agency type
      @pextra2           as varchar(200),--for agency--A and distribution--D
      @pextra3           as varchar(200),--agency class
      @pextra4           as varchar(200),
      @pextra5           as varchar(200),
      @pextra6           as varchar(200),--for suspend Y/N
      @pextra7           as varchar(200),--for commition category
      @pextra8           as varchar(200),
      @pextra9           as varchar(200),
      @pextra10          as varchar(200)
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
			C.EDTN EDTN,E.EDTN_NAME EDTN_NAME,B.SUP_SEQ_NO SUP_SEQ_NO,
			A.SUSPEND SUSPEND,C.PUBL PUBL,DB0.CIR_GET_PUBL_NAME(A.COMP_CODE,C.PUBL) PUBL_NAME
,ISNULL(c.SP_SUPPLY_MON1,0)  SP_SUPPLY_MON1
,ISNULL(c.SP_SUPPLY_TUE1,0)  SP_SUPPLY_TUE1
,ISNULL(c.SP_SUPPLY_WED1,0)  SP_SUPPLY_WED1
,ISNULL(c.SP_SUPPLY_THU1,0)  SP_SUPPLY_THU1
,ISNULL(c.SP_SUPPLY_FRI1,0)  SP_SUPPLY_FRI1
,ISNULL(c.SP_SUPPLY_SAT1,0)  SP_SUPPLY_SAT1
,ISNULL(c.SP_SUPPLY_SUN1,0)  SP_SUPPLY_SUN1
,ISNULL(c.SP_SUPPLY_MON2,0)  SP_SUPPLY_MON2
,ISNULL(c.SP_SUPPLY_TUE2,0)  SP_SUPPLY_TUE2
,ISNULL(c.SP_SUPPLY_WED2,0)  SP_SUPPLY_WED2
,ISNULL(c.SP_SUPPLY_THU2,0)  SP_SUPPLY_THU2
,ISNULL(c.SP_SUPPLY_FRI2,0)  SP_SUPPLY_FRI2
,ISNULL(c.SP_SUPPLY_SAT2,0)  SP_SUPPLY_SAT2
,ISNULL(c.SP_SUPPLY_SUN2,0)  SP_SUPPLY_SUN2
,ISNULL(P.CIR_SUP_ORDER_DEC_LIMIT,0) CIR_SUP_ORDER_DEC_LIMIT
            from cir_agmast_dis a left outer join cir_dist_mast d on a.comp_code=d.comp_code and a.dist_code=d.dist_code,cir_supply_type_mast b,cir_supply c,cir_edtn_mast e,preferrences p
            where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=e.comp_code and  a.comp_code= @pcomp_code and p.comp_code= @pcomp_code and
            a.unit=c.unit and a.unit=e.unit_code and a.unit= @punit_code and b.sup_ty_code=c.supply_type_code and
            c.publ=e.publ 
and (c.publ= @ppubl_code or @ppubl_code is null)
 and c.edtn=e.edtn and (c.edtn = isnull(@pedtn_code,c.edtn) or @pedtn_code='') and (e.main_edtn = isnull(@pmedtn_code,e.main_edtn) or @pmedtn_code='') and 
            a.agcd=c.agcd and (a.bill_agcd=isnull(@pagcd_code,a.bill_agcd) or @pagcd_code='') and a.dpcd=c.dpcd and (a.bill_dpcd=isnull(@pdpcd_code,a.bill_dpcd) or @pdpcd_code='') and (c.supply_type_code= @psup_type or @psup_type is null or @psup_type='') and 
			(a.state_code=@pstate or @pstate is null or @pstate='') and
            (a.dist_code=@pdistcode or @pdistcode is null  or @pdistcode='') and (a.tehsil_taluka = @ptaluka or @ptaluka is null or @ptaluka='') and
            --(a.city_code=@pcitycode or @pcitycode is null) and 
            --(a.branch_code = @pbrancode or @pbrancode is null or @pbrancode='') and

a.city_code in (select city_code from cir_city_mast where a.comp_code=@pcomp_code and city_code = isnull(@pcitycode,city_code) and 
         (zone_code in(select  distinct l.zone_code from login_zone_mast l where zone_code=l.zone_code and (zone_code=@pextra4 or @pextra4 is null or @pextra4='')and  l.user_code=@puserid and isnull(l.user_flag,'N')='Y' ))  and
        (region_code in(select  distinct l.region_code from login_region_mast l where region_code=l.region_code and (region_code=@pextra5 or @pextra5 is null or @pextra5='')and  l.user_code=@puserid and isnull(l.user_flag,'N')='Y' ))
        )and

 (a.branch_code in(select  distinct l.branch_code from login_branch_mast l where a.branch_code=l.branch_code and (a.branch_code=@pbrancode or @pbrancode is null or @pbrancode='')and  l.user_code=@puserid and isnull(l.user_flag,'N')='Y' ))  and


            (c.route_code=@proutecode or @proutecode is null) and isnull(c.supply_flag,'N') ='Y' and 
            ((isnull(a.suspend,'N')=isnull(@pextra6,'N')) or (@pextra6 is null) or (@pextra6='')) and
            a.freeze_flag='N' and
            ((c.comm_code = @pextra7) or (@pextra7 is null) or (@pextra7 = '')) and 
            (a.ag_type=@pextra1 or @pextra1 is null or @pextra1='') and 
			(a.ag_class=@pextra3 or @pextra3 is null or @pextra3='')
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
			C.EDTN EDTN,E.EDTN_NAME EDTN_NAME,B.SUP_SEQ_NO SUP_SEQ_NO,
			A.SUSPEND SUSPEND,C.PUBL PUBL,DB0.CIR_GET_PUBL_NAME(A.COMP_CODE,C.PUBL) PUBL_NAME
,ISNULL(c.SP_SUPPLY_MON1,0)  SP_SUPPLY_MON1
,ISNULL(c.SP_SUPPLY_TUE1,0)  SP_SUPPLY_TUE1
,ISNULL(c.SP_SUPPLY_WED1,0)  SP_SUPPLY_WED1
,ISNULL(c.SP_SUPPLY_THU1,0)  SP_SUPPLY_THU1
,ISNULL(c.SP_SUPPLY_FRI1,0)  SP_SUPPLY_FRI1
,ISNULL(c.SP_SUPPLY_SAT1,0)  SP_SUPPLY_SAT1
,ISNULL(c.SP_SUPPLY_SUN1,0)  SP_SUPPLY_SUN1
,ISNULL(c.SP_SUPPLY_MON2,0)  SP_SUPPLY_MON2
,ISNULL(c.SP_SUPPLY_TUE2,0)  SP_SUPPLY_TUE2
,ISNULL(c.SP_SUPPLY_WED2,0)  SP_SUPPLY_WED2
,ISNULL(c.SP_SUPPLY_THU2,0)  SP_SUPPLY_THU2
,ISNULL(c.SP_SUPPLY_FRI2,0)  SP_SUPPLY_FRI2
,ISNULL(c.SP_SUPPLY_SAT2,0)  SP_SUPPLY_SAT2
,ISNULL(c.SP_SUPPLY_SUN2,0)  SP_SUPPLY_SUN2
,ISNULL(P.CIR_SUP_ORDER_DEC_LIMIT,0) CIR_SUP_ORDER_DEC_LIMIT
            from cir_agmast_dis a left outer join cir_dist_mast d on a.comp_code=d.comp_code and a.dist_code=d.dist_code,cir_supply_type_mast b,cir_supply c,cir_edtn_mast e,preferrences p
            where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=e.comp_code and  a.comp_code= @pcomp_code and p.comp_code= @pcomp_code and
            a.unit=c.unit and a.unit=e.unit_code and a.unit= @punit_code and b.sup_ty_code=c.supply_type_code and
            c.publ=e.publ 
and (c.publ= @ppubl_code  or @ppubl_code is null)
and c.edtn=e.edtn and (c.edtn = isnull(@pedtn_code,c.edtn) or @pedtn_code='') and (e.main_edtn = isnull(@pmedtn_code,e.main_edtn) or @pmedtn_code='') and 
            a.agcd=c.agcd and (a.bill_agcd=isnull(@pagcd_code,a.bill_agcd) or @pagcd_code='') and a.dpcd=c.dpcd and (a.bill_dpcd=isnull(@pdpcd_code,a.bill_dpcd) or @pdpcd_code='') and (c.supply_type_code= @psup_type or @psup_type is null or @psup_type='') and 
			(a.state_code=@pstate or @pstate is null or @pstate='') and
            (a.dist_code=@pdistcode or @pdistcode is null  or @pdistcode='') and (a.tehsil_taluka = @ptaluka or @ptaluka is null or @ptaluka='') and
          --  (a.city_code=@pcitycode or @pcitycode is null) and (a.branch_code = @pbrancode or @pbrancode is null or @pbrancode='') and

a.city_code in (select city_code from cir_city_mast where a.comp_code=@pcomp_code and city_code = isnull(@pcitycode,city_code) and 
         (zone_code in(select  distinct l.zone_code from login_zone_mast l where zone_code=l.zone_code and (zone_code=@pextra4 or @pextra4 is null or @pextra4='')and  l.user_code=@puserid and isnull(l.user_flag,'N')='Y' ))  and
        (region_code in(select  distinct l.region_code from login_region_mast l where region_code=l.region_code and (region_code=@pextra5 or @pextra5 is null or @pextra5='')and  l.user_code=@puserid and isnull(l.user_flag,'N')='Y' ))
        )and 
            
            
           -- (a.branch_code = pbrancode or pbrancode is null) and
           (a.branch_code in(select  distinct l.branch_code from login_branch_mast l where a.branch_code=l.branch_code and (a.branch_code=@pbrancode or @pbrancode is null or @pbrancode='')and  l.user_code=@puserid and isnull(l.user_flag,'N')='Y' ))  and



            (c.route_code=@proutecode or @proutecode is null) and isnull(c.supply_flag,'N') ='Y' and 
            ((isnull(a.suspend,'N')=isnull(@pextra6,'N')) or (@pextra6 is null) or (@pextra6='')) and
            a.freeze_flag='N' and
            ((c.comm_code = @pextra7) or (@pextra7 is null) or (@pextra7 = '')) and 
            (a.ag_type=@pextra1 or @pextra1 is null or @pextra1='') and 
            (a.ag_class=@pextra3 or @pextra3 is null or @pextra3='')
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
			C.EDTN EDTN,E.EDTN_NAME EDTN_NAME,B.SUP_SEQ_NO SUP_SEQ_NO,
			A.SUSPEND SUSPEND,C.PUBL PUBL,DB0.CIR_GET_PUBL_NAME(A.COMP_CODE,C.PUBL) PUBL_NAME
,ISNULL(c.SP_SUPPLY_MON1,0)  SP_SUPPLY_MON1
,ISNULL(c.SP_SUPPLY_TUE1,0)  SP_SUPPLY_TUE1
,ISNULL(c.SP_SUPPLY_WED1,0)  SP_SUPPLY_WED1
,ISNULL(c.SP_SUPPLY_THU1,0)  SP_SUPPLY_THU1
,ISNULL(c.SP_SUPPLY_FRI1,0)  SP_SUPPLY_FRI1
,ISNULL(c.SP_SUPPLY_SAT1,0)  SP_SUPPLY_SAT1
,ISNULL(c.SP_SUPPLY_SUN1,0)  SP_SUPPLY_SUN1
,ISNULL(c.SP_SUPPLY_MON2,0)  SP_SUPPLY_MON2
,ISNULL(c.SP_SUPPLY_TUE2,0)  SP_SUPPLY_TUE2
,ISNULL(c.SP_SUPPLY_WED2,0)  SP_SUPPLY_WED2
,ISNULL(c.SP_SUPPLY_THU2,0)  SP_SUPPLY_THU2
,ISNULL(c.SP_SUPPLY_FRI2,0)  SP_SUPPLY_FRI2
,ISNULL(c.SP_SUPPLY_SAT2,0)  SP_SUPPLY_SAT2
,ISNULL(c.SP_SUPPLY_SUN2,0)  SP_SUPPLY_SUN2
,ISNULL(P.CIR_SUP_ORDER_DEC_LIMIT,0) CIR_SUP_ORDER_DEC_LIMIT
            from cir_agmast a left outer join cir_dist_mast d on a.comp_code=d.comp_code and a.dist_code=d.dist_code,
            cir_supply_type_mast b,cir_supply c,cir_edtn_mast e,preferrences p
            where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=e.comp_code and  a.comp_code= @pcomp_code and p.comp_code= @pcomp_code and
            a.unit=c.unit and a.unit=e.unit_code and a.unit= @punit_code and b.sup_ty_code=c.supply_type_code and
            c.publ=e.publ 
and (c.publ= @ppubl_code  or @ppubl_code is null)
and c.edtn=e.edtn and (c.edtn = isnull(@pedtn_code,c.edtn) or @pedtn_code='') and (e.main_edtn = isnull(@pmedtn_code,e.main_edtn) or @pmedtn_code='') and 
            a.agcd=c.agcd and (a.bill_agcd=isnull(@pagcd_code,a.bill_agcd) or @pagcd_code='') and a.dpcd=c.dpcd and (a.bill_dpcd=isnull(@pdpcd_code,a.bill_dpcd) or @pdpcd_code='') and (c.supply_type_code= @psup_type or @psup_type is null or @psup_type='') and 
			(a.state_code=@pstate or @pstate is null or @pstate='') and
            (a.dist_code=@pdistcode or @pdistcode is null  or @pdistcode='') and (a.tehsil_taluka = @ptaluka or @ptaluka is null or @ptaluka='') and
            --(a.city_code=@pcitycode or @pcitycode is null) and (a.branch_code = @pbrancode or @pbrancode is null or @pbrancode='') and

a.city_code in (select city_code from cir_city_mast where a.comp_code=@pcomp_code and city_code = isnull(@pcitycode,city_code) and 
         (zone_code in(select  distinct l.zone_code from login_zone_mast l where zone_code=l.zone_code and (zone_code=@pextra4 or @pextra4 is null or @pextra4='')and  l.user_code=@puserid and isnull(l.user_flag,'N')='Y' ))  and
        (region_code in(select  distinct l.region_code from login_region_mast l where region_code=l.region_code and (region_code=@pextra5 or @pextra5 is null or @pextra5='')and  l.user_code=@puserid and isnull(l.user_flag,'N')='Y' ))
        )and 
            
          --  (a.branch_code = pbrancode or pbrancode is null) and
          (a.branch_code in(select  distinct l.branch_code from login_branch_mast l where a.branch_code=l.branch_code and (a.branch_code=@pbrancode or @pbrancode is null or @pbrancode='')and  l.user_code=@puserid and isnull(l.user_flag,'N')='Y' ))  and

            (c.route_code=@proutecode or @proutecode is null) and isnull(c.supply_flag,'N') ='Y' and 
            ((isnull(a.suspend,'N')=isnull(@pextra6,'N')) or (@pextra6 is null) or (@pextra6='')) and
            a.freeze_flag='N' and
            ((c.comm_code = @pextra7) or (@pextra7 is null) or (@pextra7 = '')) and 
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
			C.EDTN EDTN,E.EDTN_NAME EDTN_NAME,B.SUP_SEQ_NO SUP_SEQ_NO,
			A.SUSPEND SUSPEND,C.PUBL PUBL,dbo.cir_get_publ_name(A.COMP_CODE,C.PUBL) PUBL_NAME
,ISNULL(c.SP_SUPPLY_MON1,0)  SP_SUPPLY_MON1
,ISNULL(c.SP_SUPPLY_TUE1,0)  SP_SUPPLY_TUE1
,ISNULL(c.SP_SUPPLY_WED1,0)  SP_SUPPLY_WED1
,ISNULL(c.SP_SUPPLY_THU1,0)  SP_SUPPLY_THU1
,ISNULL(c.SP_SUPPLY_FRI1,0)  SP_SUPPLY_FRI1
,ISNULL(c.SP_SUPPLY_SAT1,0)  SP_SUPPLY_SAT1
,ISNULL(c.SP_SUPPLY_SUN1,0)  SP_SUPPLY_SUN1
,ISNULL(c.SP_SUPPLY_MON2,0)  SP_SUPPLY_MON2
,ISNULL(c.SP_SUPPLY_TUE2,0)  SP_SUPPLY_TUE2
,ISNULL(c.SP_SUPPLY_WED2,0)  SP_SUPPLY_WED2
,ISNULL(c.SP_SUPPLY_THU2,0)  SP_SUPPLY_THU2
,ISNULL(c.SP_SUPPLY_FRI2,0)  SP_SUPPLY_FRI2
,ISNULL(c.SP_SUPPLY_SAT2,0)  SP_SUPPLY_SAT2
,ISNULL(c.SP_SUPPLY_SUN2,0)  SP_SUPPLY_SUN2
,ISNULL(P.CIR_SUP_ORDER_DEC_LIMIT,0) CIR_SUP_ORDER_DEC_LIMIT
            from cir_agmast a left outer join cir_dist_mast d on a.comp_code=d.comp_code and a.dist_code=d.dist_code,cir_supply_type_mast b,cir_supply c,cir_edtn_mast e,preferrences p
			where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=e.comp_code and  a.comp_code= @pcomp_code and p.comp_code= @pcomp_code and
            a.unit=c.unit and a.unit=e.unit_code and a.unit= @punit_code and b.sup_ty_code=c.supply_type_code and
            c.publ=e.publ 
and (c.publ= @ppubl_code or @ppubl_code is null)
and c.edtn=e.edtn and (c.edtn = isnull(@pedtn_code,c.edtn) or @pedtn_code='') and (e.main_edtn = isnull(@pmedtn_code,e.main_edtn) or @pmedtn_code='') 
and 
            a.agcd=c.agcd and (a.bill_agcd=isnull(@pagcd_code,a.bill_agcd) or @pagcd_code='') 
and a.dpcd=c.dpcd and (a.bill_dpcd=isnull(@pdpcd_code,a.bill_dpcd) or @pdpcd_code='') and (c.supply_type_code= @psup_type or @psup_type is null or @psup_type='') 
	and 
		(a.state_code=@pstate or @pstate is null or @pstate='')
 and
            (a.dist_code=@pdistcode or @pdistcode is null  or @pdistcode='') and (a.tehsil_taluka = @ptaluka or @ptaluka is null or @ptaluka='') and
           -- (a.city_code=@pcitycode or @pcitycode is null) and (a.branch_code = @pbrancode or @pbrancode is null or @pbrancode='') and
a.city_code in (select city_code from cir_city_mast where a.comp_code=@pcomp_code and city_code = isnull(@pcitycode,city_code) and 
         (zone_code in(select  distinct l.zone_code from login_zone_mast l where zone_code=l.zone_code and (zone_code=@pextra4 or @pextra4 is null or @pextra4='')and  l.user_code=@puserid and isnull(l.user_flag,'N')='Y' ))  and
        (region_code in(select  distinct l.region_code from login_region_mast l where region_code=l.region_code and (region_code=@pextra5 or @pextra5 is null or @pextra5='')and  l.user_code=@puserid and isnull(l.user_flag,'N')='Y' ))
        )and 
            
          --  (a.branch_code = pbrancode or pbrancode is null) and
          (a.branch_code in(select  distinct l.branch_code from login_branch_mast l where a.branch_code=l.branch_code and (a.branch_code=@pbrancode or @pbrancode is null or @pbrancode='')and  l.user_code=@puserid and isnull(l.user_flag,'N')='Y' ))  and

            (c.route_code=@proutecode or @proutecode is null) and isnull(c.supply_flag,'N') ='Y' and 
            ((isnull(a.suspend,'N')=isnull(@pextra6,'N')) or (@pextra6 is null) or (@pextra6='')) and
            a.freeze_flag='N' 
and
            ((c.comm_code = @pextra7) or (@pextra7 is null) or (@pextra7 = '')) and 
            (a.ag_type=@pextra1 or @pextra1 is null or @pextra1='') 
and 
			(a.ag_class=@pextra3 or @pextra3 is null or @pextra3='')

             order by route_seq,supply_seq,agency_name,edtn_name,sup_seq_no,supply_type_name
	End
End
End




//////////////////////////////////////


                                                                     
                                                                     
                                             
ALTER PROCEDURE [dbo].[cir_supply_populate_p]
    @pcomp_code                               VARCHAR(20) ,
    @punit                                    VARCHAR(20) ,
    @pagcd                                    VARCHAR(20) ,
    @pdpcd                                    VARCHAR(20) ,
    @ppubl                                    VARCHAR(20) ,
    @pedtn                                    VARCHAR(20) ,
    @pdateformat                              VARCHAR(20) ,
    @pextra1                                  VARCHAR(4000) ,--userid
    @pextra2                                  VARCHAR(4000) 
AS 
Begin
	if upper(@pextra2)='D' Begin
         select SUPPLY_TYPE_CODE,DBO.CIR_GET_SUPPLY_NAME(s.COMP_CODE,SUPPLY_TYPE_CODE) SUPPLY_TYPE_NAME,BASE_SUPPLY,SUPPLY_SUN,SUPPLY_MON,SUPPLY_TUE,
                SUPPLY_WED,SUPPLY_THU,SUPPLY_FRI,SUPPLY_SAT,SUPPLY_SPL1,SUPPLY_SPL2,SUPPLY_FLAG,BASE_SUPPLY,PACKET_SIZE,COMM_CODE,COMM_FLAG,
                LBL_PRINTNO SUPPLY_SEQ,ROUTE_CODE,DBO.CIR_GET_NAME_CIR_ROUTE(s.COMP_CODE,s.UNIT,ROUTE_CODE,1,@PDATEFORMAT,'','') ROUTE_NAME, 
                SUBROUTE_CODE ,DBO.CIR_GET_NAME_CIR_SUBROUTE(s.COMP_CODE,s.UNIT,ROUTE_CODE,SUBROUTE_CODE,1,@PDATEFORMAT,'','') SUBROUTE_NAME,
                SUB_SUBROUTE_CODE,DBO.CIR_GET_NAME_CIR_SUBSUBROUTE(s.COMP_CODE,s.UNIT,ROUTE_CODE,SUBROUTE_CODE,SUB_SUBROUTE_CODE,1,@PDATEFORMAT,'','') SUBSUBROUTE_NAME,
                (select isnull(CIR_SUP_ORDER_LIMIT,0) from preferrences where "comp_code"=@pcomp_code) as "CIR_SUP_ORDER_LIMIT"
                ,(select isnull(CIR_SUP_ORDER_DEC_LIMIT,0) from preferrences where "comp_code"=@pcomp_code) as "CIR_SUP_ORDER_DEC_LIMIT"
                from cir_supply_dis s ,cir_agmast_dis a
              where s.comp_code=@pcomp_code and s.unit=@punit and s.agcd=@pagcd and s.dpcd=@pdpcd and publ=@ppubl and edtn=@pedtn
and a.comp_code=s.comp_code and s.unit=a.unit and s.agcd=a.agcd and s.dpcd=a.dpcd and
a.city_code in (select city_code from cir_city_mast where a.comp_code=@pcomp_code  and 
         (zone_code in(select  distinct l.zone_code from login_zone_mast l where zone_code=l.zone_code 
and  l.user_code=@pextra1 and isnull(l.user_flag,'N')='Y' ))  and
        (region_code in(select  distinct l.region_code from login_region_mast l where region_code=l.region_code 
and  l.user_code=@pextra1 and isnull(l.user_flag,'N')='Y' ))
        )and
(a.branch_code in(select  distinct l.branch_code from login_branch_mast l where a.branch_code=l.branch_code 
and  l.user_code=@pextra1 and isnull(l.user_flag,'N')='Y' )) 
              order by supply_type_name
		End
    else 
    Begin
         select SUPPLY_TYPE_CODE,DBO.CIR_GET_SUPPLY_NAME(s.COMP_CODE,SUPPLY_TYPE_CODE) SUPPLY_TYPE_NAME,BASE_SUPPLY,SUPPLY_SUN,SUPPLY_MON,SUPPLY_TUE,
                SUPPLY_WED,SUPPLY_THU,SUPPLY_FRI,SUPPLY_SAT,SUPPLY_SPL1,SUPPLY_SPL2,SUPPLY_FLAG,BASE_SUPPLY,PACKET_SIZE,COMM_CODE,COMM_FLAG,
                LBL_PRINTNO SUPPLY_SEQ,ROUTE_CODE,DBO.CIR_GET_NAME_CIR_ROUTE(s.COMP_CODE,s.UNIT,ROUTE_CODE,1,@PDATEFORMAT,'','') ROUTE_NAME, 
                SUBROUTE_CODE ,DBO.CIR_GET_NAME_CIR_SUBROUTE(s.COMP_CODE,s.UNIT,ROUTE_CODE,SUBROUTE_CODE,1,@PDATEFORMAT,'','') SUBROUTE_NAME,
                SUB_SUBROUTE_CODE,DBO.CIR_GET_NAME_CIR_SUBSUBROUTE(s.COMP_CODE,s.UNIT,ROUTE_CODE,SUBROUTE_CODE,SUB_SUBROUTE_CODE,1,@PDATEFORMAT,'','') SUBSUBROUTE_NAME,
                (select isnull(CIR_SUP_ORDER_LIMIT,0) from preferrences where "comp_code"=@pcomp_code) as "CIR_SUP_ORDER_LIMIT"
                ,(select isnull(CIR_SUP_ORDER_DEC_LIMIT,0) from preferrences where "comp_code"=@pcomp_code) as "CIR_SUP_ORDER_DEC_LIMIT"
                from cir_supply s ,cir_agmast a
              where s.comp_code=@pcomp_code and s.unit=@punit and s.agcd=@pagcd and s.dpcd=@pdpcd and publ=@ppubl and edtn=@pedtn
and a.comp_code=s.comp_code and s.unit=a.unit and s.agcd=a.agcd and s.dpcd=a.dpcd and
a.city_code in (select city_code from cir_city_mast where a.comp_code=@pcomp_code  and 
         (zone_code in(select  distinct l.zone_code from login_zone_mast l where zone_code=l.zone_code 
and  l.user_code=@pextra1 and isnull(l.user_flag,'N')='Y' ))  and
        (region_code in(select  distinct l.region_code from login_region_mast l where region_code=l.region_code 
and  l.user_code=@pextra1 and isnull(l.user_flag,'N')='Y' ))
        )and
(a.branch_code in(select  distinct l.branch_code from login_branch_mast l where a.branch_code=l.branch_code 
and  l.user_code=@pextra1 and isnull(l.user_flag,'N')='Y' )) 
              order by supply_type_name
	End
end

//////////////////////////////////////////////////end////////////////////////////////////////////////////////////


******************Rikkee Garg Changed By Gaurav sir in Bill Print 29/06/2012  issue 7674***********************
ALTER PROCEDURE [dbo].[cir_rep_billing_cir_bill_print_bhaskar]
	@pcomp_code                               VARCHAR(40) ,
	@punit_code                               VARCHAR(40) ,
	@ppubl                                    VARCHAR(40) ,
	@pbill_freq                               VARCHAR(40) ,
	@pfrom_billdt                             DATETIME,
	@ptill_billdt                             DATETIME ,
	@pfrom_billno                             VARCHAR(40) ,
	@ptill_billno                             VARCHAR(40) ,
	@pbillagcd                                VARCHAR(40) ,
	@pbilldpcd                                VARCHAR(40) ,
	@pdateformat                              VARCHAR(40) ,
	@pextra1                                  VARCHAR(40) ,--for Agency Class
	@pextra2                                  VARCHAR(40),--for Agency Type 
	@pextra3                                  VARCHAR(40)=null--for District filter 
AS 

	If @ppubl='' Begin
		set @ppubl=null
	End
	If @pfrom_billno='' Begin
		set @pfrom_billno=null
	End
	If @pbillagcd='' Begin
		set @pbillagcd=null
	End
	If @pbilldpcd='' Begin
		set @pbilldpcd=null
	End
	If @punit_code='' Begin
		set @punit_code=null
	End			
	DECLARE @v_bill_frdt                              DATETIME 
	DECLARE @v_bill_todt                              DATETIME 
	DECLARE @v_dt                                     DATETIME 

	DECLARE @rec_bill_comp_code                       VARCHAR(8) 
	DECLARE @rec_bill_unit_code                       VARCHAR(8) 
	DECLARE @rec_bill_publ                            VARCHAR(10) 
	DECLARE @rec_bill_agcd                            VARCHAR(8) 
	DECLARE @rec_bill_dpcd                            VARCHAR(8) 
	DECLARE @rec_bill_billno                          VARCHAR(40) 
	DECLARE @rec_bill_billdt                          DATETIME 
	DECLARE @rec_bill_frdt                            DATETIME 
	DECLARE @rec_bill_todt                            DATETIME 

	DECLARE cur_bill CURSOR FOR
	select distinct b.comp_code,b.unit_code,b.publ,b.agcd,b.dpcd,b.billno,b.billdt,min(b.bill_frdt) frdt,max(b.bill_todt) todt 
	from cir_bill b,cir_agmast m
                where b.comp_code=m.comp_code and b.comp_code=@pcomp_code and b.unit_code=isnull(@punit_code,b.unit_code) and b.unit_code=m.unit and 
                b.billdt between @pfrom_billdt and @ptill_billdt and
                b.bill_flag=@pbill_freq and ((b.billno between @pfrom_billno and @ptill_billno) or (@pfrom_billno is null)) and-- 
                            b.publ=isnull(@ppubl,b.publ) and b.agcd=isnull(@pbillagcd,b.agcd) and b.agcd=m.agcd and
                            b.dpcd=isnull(@pbilldpcd,b.dpcd) and b.dpcd=m.dpcd and (m.ag_class=@pextra1 or @pextra1 is null or @pextra1='') and
                            (m.ag_type=@pextra2 or @pextra2 is null  or @pextra2='') 
                            --new add
                            and (m.dist_code=@pextra3 or @pextra3 is null or @pextra3='') 
                            
            group by b.comp_code,b.unit_code,b.publ,b.agcd,b.dpcd,b.billno,b.billdt
            order by b.comp_code,b.unit_code,b.publ,b.billdt,b.billno,b.agcd,b.dpcd; 
		

    	DECLARE @rec_dbksup_comp_code                     VARCHAR(8) 
		DECLARE @rec_dbksup_unit_code                     VARCHAR(8) 
		DECLARE @rec_dbksup_publ                          VARCHAR(10) 
		DECLARE @rec_dbksup_edtn                          VARCHAR(10) 
		DECLARE @rec_dbksup_supdate                       DATETIME 
		DECLARE @rec_dbksup_copy_rate                     NUMERIC(10,4) 
		DECLARE @rec_dbksup_comm_fix_auto_spl             VARCHAR(1) 
		DECLARE @rec_dbksup_comm_code                     VARCHAR(6) 
		DECLARE @rec_dbksup_supply_copy                   NUMERIC(10) 
		DECLARE @count									  INT

CREATE TABLE #CIR_BILL_PRINT
( COMP_CODE      VARCHAR(8),
  UNIT_CODE      VARCHAR(8),
  BILLNO         VARCHAR(20),
  BILLDT         DATETIME,
  PUBL_CODE      VARCHAR(8),
  EDTN_CODE      VARCHAR(8),
  AGCD           VARCHAR(8),
  DPCD           VARCHAR(8),
  SUPPLY_DATE    DATETIME,
  SUPPLY_COPY    NUMERIC(10),
  SUPPLY_RATE    NUMERIC(10,2),
  COMM_RATE      NUMERIC(12,2),
  SUR_RATE       NUMERIC(10,2),
  RETURN_COPY    NUMERIC(10),
  RETURN_AMT     NUMERIC(14,2),
  CUR_SESSIONID  NUMERIC(10),
  GROSS_AMT      NUMERIC(15,2)                   DEFAULT 0,
  COMM_AMT       NUMERIC(15,5)                   DEFAULT 0,
  SUR_AMT        NUMERIC(15,2),
  SEC_AMT        NUMERIC(15,2)                   DEFAULT 0,
  BRANCH_CODE    VARCHAR(8),
  REC_AMT        NUMERIC(15,2)                   DEFAULT 0)
  
		DECLARE cur_publ_edtn CURSOR FOR 
		SELECT DISTINCT
				 comp_code, unit_code, publ_code,
				 DBO.cir_get_publ_name(comp_code, publ_code) publ_name,
				 edtn_code edtn,
				 DBO.cir_get_edtn_name(comp_code, edtn_code) edtn_name
		FROM  #cir_bill_print 
		ORDER BY comp_code, unit_code, publ_code, edtn_code 
		
		DECLARE @v1						VARCHAR(200)
		DECLARE @v_cnt                  INT                           
		DECLARE @v_return_copy          INT
		DECLARE @v_return_amt           NUMERIC(14,2)
		DECLARE @v_gross_amt            NUMERIC(14,2)                   
		DECLARE @v_comm_rate            FLOAT 
		DECLARE @v_comm_amt             NUMERIC(14,2)                   
		DECLARE @v_sur_rate             FLOAT 
		DECLARE @v_sur_amt              NUMERIC(14,2)                   
		DECLARE @v_opdate               DATETIME 
		DECLARE @v_opbal                NUMERIC(14,2)                   
		DECLARE @v_billamt              NUMERIC(14,2)                   
		DECLARE @v_dbcramt              NUMERIC(14,2)                   
		DECLARE @v_dbamt                NUMERIC(14,2)                   
		DECLARE @v_cramt                NUMERIC(14,2)                   
		DECLARE @v_recamt               NUMERIC(14,2)                   
BEGIN
		
		SET @v_cnt			= 0 
		SET @v_return_amt	= 0
		SET @v_gross_amt	= 0 
		SET @v_comm_amt		= 0 
		SET @v_sur_amt		= 0 
		SET @v_opbal		= 0 
		SET @v_billamt		= 0 
		SET @v_dbcramt		= 0 
		SET @v_dbamt		= 0 
		SET @v_cramt		= 0 
		SET @v_recamt		= 0 
		SET @count			= 1 
		SET @v_bill_frdt	= @pfrom_billdt--DBO.convert_user_date('/', @pfrom_billdt,@pdateformat)
        SET @v_bill_todt	= @ptill_billdt--DBO.convert_user_date('/', @ptill_billdt,@pdateformat)
		SET @v_opdate		= DBO.cir_get_finandt(@pcomp_code, @v_bill_frdt, @pdateformat, '', '')



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

		CREATE TABLE #CIR_TEMP_BILL_COLLECTION(
		COMP_CODE	varchar(8),	UNIT_CODE	varchar(8),	BILLNO	varchar(20),
		BILLDT		datetime ,PUBL_CODE	varchar(8),	AGCD	varchar(8) ,
		DPCD		varchar(8) ,SUPPLY_COPY numeric(10,0)	DEFAULT 0,GROSS_AMT	numeric(15,2)	DEFAULT 0,
		COMM_AMT	numeric(15,2)	DEFAULT 0,SUR_AMT		numeric(15,2)	DEFAULT 0,
		RETURN_COPY numeric(10,0)	DEFAULT 0,RETURN_AMT	numeric(15,2)	DEFAULT 0,
		DN_AMT		numeric(15,2)	DEFAULT 0,CN_AMT		numeric(15,2)	DEFAULT 0,
		REC_AMT		numeric(15,2)	DEFAULT 0,PREV_BAL		numeric(15,2)	DEFAULT 0,
		CUR_SESSIONID numeric(18,0),AGNAME		varchar(200),AGNAME_OTH_LANG varchar(250),
		CITY_CODE	varchar(20),TALUKA_CODE varchar(20),DIST_CODE	varchar(20),STATE_CODE	varchar(20),REMARKS		varchar(500))
		
		OPEN cur_bill 
			fetch NEXT FROM cur_bill INTO 
								@rec_bill_comp_code, @rec_bill_unit_code, @rec_bill_publ, 
								@rec_bill_agcd, @rec_bill_dpcd, @rec_bill_billno, @rec_bill_billdt, @rec_bill_frdt, @rec_bill_todt
			WHILE (@@FETCH_STATUS = 0) BEGIN

				--print('1')print(@v_dt)

				WHILE (0 = 0) BEGIN 
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

					DECLARE cur_dbksup CURSOR local FOR 
					SELECT d.comp_code comp_code, d.unit_code unit_code, d.publ publ,d.edtn edtn , d.supdate supdate, d.sup_rate copy_rate, 
					d.comm_fix_auto_spl comm_fix_auto_spl,d.comm_code comm_code,SUM(d.sup_copy) supply_copy
					FROM  cir_dbksup d,cir_supply_type_mast s
					WHERE d.comp_code=s.comp_code and d.comp_code  = @rec_bill_comp_code
					AND d.unit_code  = @rec_bill_unit_code	 AND d.publ  = ISNULL(@ppubl ,d.publ) AND 
					d.supdate  = @v_dt AND d.billagcd	 = @rec_bill_agcd AND d.billdpcd  = @rec_bill_dpcd
					AND d.sup_type_code=s.sup_ty_code and UPPER(s.bill_pay)  = 'Y'
					GROUP BY d.comp_code, d.unit_code, d.publ, d.edtn, d.supdate, d.sup_rate, d.comm_fix_auto_spl, d.comm_code 
					ORDER BY comp_code, unit_code, publ, edtn, supdate 

					OPEN cur_dbksup 
						FETCH NEXT FROM cur_dbksup INTO 
										@rec_dbksup_comp_code, @rec_dbksup_unit_code, @rec_dbksup_publ, 
										@rec_dbksup_edtn, @rec_dbksup_supdate, @rec_dbksup_copy_rate, 
										@rec_dbksup_comm_fix_auto_spl, @rec_dbksup_comm_code, @rec_dbksup_supply_copy
					WHILE (@@FETCH_STATUS = 0) BEGIN

						SELECT @v_return_copy  =  SUM(ISNULL(apr_late_recpt, 0) + ISNULL(apr_short_recpt, 0) + ISNULL(apr_bnr, 0) + ISNULL(apr_unsold, 0)),@v_return_amt  =  0
						FROM  cir_unsold_dtl 
						WHERE comp_code  = @rec_bill_comp_code AND unit_code  = @rec_bill_unit_code AND doctype  = 'UCN'
						AND recptdt  = @rec_dbksup_supdate AND publ  = @rec_dbksup_publ AND edtn  = @rec_dbksup_edtn
						AND agcd  = @rec_bill_agcd AND dpcd  = @rec_bill_dpcd
						AND (ISNULL(apr_late_recpt, 0) + ISNULL(apr_short_recpt, 0) + ISNULL(apr_bnr, 0) + ISNULL(apr_unsold, 0))  > 0
					
						SET @v_gross_amt  = ISNULL(ROUND((@rec_dbksup_supply_copy * @rec_dbksup_copy_rate), 2), 0)
						SET @v_comm_rate  = 0 
						SET @v_comm_amt   = ISNULL(ROUND((@rec_dbksup_supply_copy * @v_comm_rate), 2), 0)
						SET @v_sur_rate   = 0 
						SET @v_sur_amt  = ISNULL(ROUND((@rec_dbksup_supply_copy * @v_sur_rate), 2), 0)
					
						INSERT INTO  #cir_bill_print   
							(comp_code , unit_code , billno , billdt , publ_code , 
							edtn_code , agcd , dpcd , supply_date , supply_copy , supply_rate , 
							gross_amt , comm_rate , comm_amt , sur_rate , sur_amt , return_copy , return_amt)  
						VALUES ( @rec_bill_comp_code , @rec_bill_unit_code , @rec_bill_billno , @rec_bill_billdt , @rec_dbksup_publ , 
							@rec_dbksup_edtn , @rec_bill_agcd , @rec_bill_dpcd , @rec_dbksup_supdate , 
							@rec_dbksup_supply_copy , @rec_dbksup_copy_rate , @v_gross_amt , @v_comm_rate , 
							@v_comm_amt , @v_sur_rate , @v_sur_amt , @v_return_copy , @v_return_amt )  
					
						FETCH NEXT FROM cur_dbksup INTO 
										@rec_dbksup_comp_code, @rec_dbksup_unit_code, @rec_dbksup_publ, 
										@rec_dbksup_edtn, @rec_dbksup_supdate, @rec_dbksup_copy_rate, 
										@rec_dbksup_comm_fix_auto_spl, @rec_dbksup_comm_code, @rec_dbksup_supply_copy
					END

				CLOSE cur_dbksup
				DEALLOCATE cur_dbksup
			END

			SET @v_opbal  = DBO.cir_accounts_cir_agency_opbal(@rec_bill_comp_code, @rec_bill_unit_code, null, @rec_bill_agcd, @rec_bill_dpcd, @v_opdate, 'NM', @pdateformat, '', '')+ DBO.cir_accounts_cir_agency_ytodt(@rec_bill_comp_code, @rec_bill_unit_code, null, @rec_bill_agcd, @rec_bill_dpcd, @v_opdate, @rec_bill_frdt, 'NM', @pdateformat, '', '')
			
			SELECT @v_billamt  =  SUM(bill_amount) FROM  cir_bill 
			WHERE comp_code = @rec_bill_comp_code AND unit_code  = @rec_bill_unit_code
			 AND agcd  = @rec_bill_agcd AND dpcd  = @rec_bill_dpcd
			 AND billdt  >= @rec_bill_frdt AND billdt  <= @rec_bill_todt /* and publ=rec_bill_publ*/
			
			SELECT @v_dbcramt  =  SUM(amount) FROM  cir_outmast 
			WHERE comp_code  = @rec_bill_comp_code AND unit_code  = @rec_bill_unit_code
			 AND agcd  = @rec_bill_agcd AND dpcd  = @rec_bill_dpcd AND recptdt  >= @rec_bill_frdt
			 AND recptdt  <= @rec_bill_todt AND doctyp  <> 'BIL' AND achd  = 'NM' /*and publ=rec_bill_publ*/
			
			SELECT @v_dbamt  =  SUM(amount) FROM cir_outmast 
			WHERE comp_code  = @rec_bill_comp_code AND unit_code  = @rec_bill_unit_code
			 AND agcd  = @rec_bill_agcd AND dpcd  = @rec_bill_dpcd AND recptdt  >= @rec_bill_frdt
			 AND recptdt  <= @rec_bill_billdt AND doctyp  NOT IN ( 'BIL'  , 'RCR'  ) AND achd  = 'NM'
			 AND amount  > 0
			
			SELECT @v_cramt  =  SUM(amount) FROM  cir_outmast 
			WHERE comp_code  = @rec_bill_comp_code AND unit_code  = @rec_bill_unit_code
			 AND agcd  = @rec_bill_agcd AND dpcd  = @rec_bill_dpcd
			 AND recptdt  >= @rec_bill_frdt AND recptdt  <= @rec_bill_billdt
			 AND doctyp  NOT IN ( 'BIL'  , 'RCR'  )
			 AND achd  = 'NM' AND amount  < 0
			
			SELECT @v_recamt  =  SUM(amount) FROM  cir_outmast 
			WHERE comp_code  = @rec_bill_comp_code AND unit_code  = @rec_bill_unit_code
			 AND agcd  = @rec_bill_agcd AND dpcd  = @rec_bill_dpcd
			 AND recptdt  >= @rec_bill_frdt AND recptdt  <= @rec_bill_billdt
			 AND doctyp  = 'RCR' AND achd  = 'NM' /*and publ=rec_bill_publ*/

			SET @v_opbal  = ISNULL(@v_opbal, 0)+ ISNULL(@v_recamt, 0)
			
			INSERT INTO  #cir_temp_outstanding (comp_code , unit_code , dt , agname , publ_code , agcd , dpcd , dn_amt , cn_amt , rec_amt , op_amt )  
			 VALUES (@rec_bill_comp_code , @rec_bill_unit_code , 
					@rec_bill_billdt , @rec_bill_billno , '' , /*rec_bill_publ,*/ /*rec_bill_publ,*/ @rec_bill_agcd , 
					@rec_bill_dpcd , @v_dbamt , @v_cramt ,@v_recamt , @v_opbal )  
			
			INSERT INTO  #cir_temp_bill_collection   
					(comp_code , unit_code , billno , billdt , remarks , cur_sessionid )  
			 VALUES (@rec_bill_comp_code , @rec_bill_unit_code , @rec_bill_billno , @rec_bill_billdt , '' , @@SPID )  
			
			SET @v_opbal	= 0 
			SET @v_billamt  = 0 
			SET @v_dbcramt  = 0 
			SET @v_dbamt	= 0 
			SET @v_cramt	= 0 
			SET @v_recamt	= 0
			SET @v_dt		=NULL
				FETCH NEXT FROM cur_bill INTO 
								@rec_bill_comp_code, @rec_bill_unit_code, @rec_bill_publ, 
								@rec_bill_agcd, @rec_bill_dpcd, @rec_bill_billno, @rec_bill_billdt, @rec_bill_frdt, @rec_bill_todt
		END
		CLOSE cur_bill

		SELECT b.comp_code comp_code, b.unit_code unit_code,
				 b.agcd agcd,b.dpcd dpcd,a.ag_name ag_name, a.ag_name_oth_lang ag_name_oth_lang,
				 a.addr1 addr1, a.addr2 addr2,a.addr3 addr3,
				 DBO.cir_get_city(b.comp_code, a.city_code) city_name,
				 b.billno billno,b.billdt billdt, SUM(b.bill_copy) bill_copy,SUM(b.gross_amount) gross_amount,
				 SUM(b.sur_amount) sur_amount, SUM(b.comm_amount) comm_amount,SUM(b.bill_amount) bill_amount,
				 (SELECT MAX(d.comm_rate) FROM  cir_bill_det d 
				WHERE d.comp_code  = b.comp_code AND	d.unit_code  = b.unit_code
				 AND d.agcd  = b.agcd AND d.dpcd  = b.dpcd
				 AND d.billno  = b.billno AND	d.billdt  = b.billdt) comm_rate
		FROM  cir_agmast a, cir_bill b 
		WHERE a.comp_code  = @pcomp_code
		 AND a.unit  = b.unit_code
		 and (a.dist_code=@pextra3 or @pextra3 is null or @pextra3='') 
		 AND b.unit_code  = ISNULL(@punit_code,b.unit_code)
		 AND b.billdt  BETWEEN @v_bill_frdt  AND  @v_bill_todt
		 AND b.bill_flag  = @pbill_freq
		 AND ((b.billno BETWEEN @pfrom_billno  AND  @ptill_billno) OR (@pfrom_billno  IS NULL) OR (@pfrom_billno=''))
		 AND b.publ  = ISNULL(@ppubl,b.publ)
		 AND a.agcd  = b.agcd AND a.dpcd  = b.dpcd
		 AND b.agcd  = ISNULL(@pbillagcd,b.agcd)
		 AND b.dpcd  = ISNULL(@pbilldpcd,b.dpcd)
		GROUP BY b.comp_code, b.unit_code, b.agcd, b.dpcd, a.ag_name, a.ag_name_oth_lang,a.addr1, a.addr2, a.addr3,a.city_code,b.billno, b.billdt 
		ORDER BY b.comp_code, b.unit_code, b.billdt, b.billno, b.agcd, b.dpcd 
		INSERT INTO CIR_BILL_PRINT(COMP_CODE,BILLDT) VALUES('8',GETDATE());
		SELECT x.comp_code comp_code, x.unit_code unit_code, x.billno billno, x.billdt billdt,x.agcd agcd,x.dpcd dpcd,x.supdate supdate,
		x.supply_rate copy_rate,SUM(x.supply_copy) supply
		FROM (SELECT u.comp_code comp_code, u.unit_code unit_code, u.billno billno, u.billdt billdt, u.agcd agcd, u.dpcd dpcd, u.supply_date supdate, u.supply_rate supply_rate, SUM(u.supply_copy) supply_copy
			FROM  #cir_bill_print u 
			GROUP BY u.comp_code,u.unit_code,u.agcd,u.dpcd, u.supply_date, u.billno,u.billdt, u.supply_rate) x 
		GROUP BY x.comp_code, x.unit_code,x.billno,x.billdt,x.agcd, x.dpcd, x.supdate, x.supply_rate 
		ORDER BY comp_code, unit_code, billdt,billno, supdate, agcd,dpcd 

		SELECT x.comp_code comp_code, x.unit_code unit_code, x.billno billno, x.billdt billdt, x.agcd agcd, x.dpcd dpcd,
				 SUM(x.supply_copy) tot_supply, SUM(x.gross) gross_amt, SUM(x.return_copy) return_copy,
				 SUM(x.return_amt) return_amt,SUM(x.tot_amt) tot_amt, SUM(x.tot_comm) tot_comm,
				 SUM(x.tot_surcharge) tot_surcharge, SUM(x.net_amt) net_amt
		FROM (	SELECT u.comp_code comp_code,u.unit_code unit_code,u.billno billno,u.billdt billdt,u.agcd agcd,u.dpcd dpcd,
					 SUM(u.supply_copy) supply_copy,SUM(u.gross_amt) gross,
					 SUM(u.return_copy) return_copy,SUM(u.return_amt) return_amt,
					 SUM(u.gross_amt - u.return_amt) tot_amt,
					 SUM(u.comm_amt) tot_comm, SUM(u.sur_amt) tot_surcharge,
					 SUM(u.gross_amt - u.return_amt - u.comm_amt + u.sur_amt) net_amt
			FROM  #cir_bill_print u 
		GROUP BY u.comp_code, u.unit_code, u.agcd, u.dpcd,u.billno, u.billdt) x
		GROUP BY x.comp_code,x.unit_code,x.billno,x.billdt, x.agcd, x.dpcd 
		ORDER BY comp_code, unit_code, billdt, billno, agcd,dpcd 

		SELECT x.comp_code comp_code,x.unit_code unit_code, x.billno billno, x.billdt billdt, x.agcd agcd, x.dpcd dpcd,SUM(x.gross) gross_amt
		FROM (SELECT u.comp_code comp_code,u.unit_code unit_code,u.billno billno,u.billdt billdt,u.agcd agcd,u.dpcd dpcd,
			 SUM(u.gross_amt) gross
			FROM  #cir_bill_print u 
 		GROUP BY u.comp_code, u.unit_code, u.agcd, u.dpcd,u.billno, u.billdt) x
		GROUP BY x.comp_code, x.unit_code, x.billno,x.billdt, x.agcd, x.dpcd 
		ORDER BY comp_code, unit_code, billdt,billno, agcd, dpcd 
		
		SELECT comp_code, unit_code, billno, billdt, agcd,dpcd,SUM(return_copy) return_copy
		FROM (SELECT u.comp_code comp_code, u.unit_code unit_code,u.billno billno,u.billdt billdt,u.agcd agcd,u.dpcd dpcd,SUM(u.return_copy) return_copy
			FROM  #cir_bill_print u 
			GROUP BY u.comp_code, u.unit_code,u.agcd,u.dpcd,u.billno, u.billdt )x
		GROUP BY comp_code, unit_code, billno, billdt,agcd, dpcd 
		ORDER BY comp_code, unit_code, billdt, billno, agcd,dpcd 
		
		SELECT x.comp_code comp_code, x.unit_code unit_code,x.billno billno,x.billdt billdt,x.agcd agcd,x.dpcd dpcd,SUM(x.return_amt) return_amt
		FROM (SELECT u.comp_code comp_code,u.unit_code unit_code,u.billno billno,u.billdt billdt,u.agcd agcd,u.dpcd dpcd,SUM(u.return_amt) return_amt
			FROM  #cir_bill_print u 
		GROUP BY u.comp_code, u.unit_code, u.agcd, u.dpcd, u.billno, u.billdt )x
		GROUP BY x.comp_code,x.unit_code, x.billno, x.billdt, x.agcd,x.dpcd 
		ORDER BY comp_code, unit_code, billdt, billno, agcd,dpcd 

		SELECT x.comp_code comp_code,x.unit_code unit_code, x.billno billno, x.billdt billdt, x.agcd agcd, x.dpcd dpcd,SUM(x.tot_amt) tot_amt
		FROM (SELECT u.comp_code comp_code, u.unit_code unit_code,u.billno billno,u.billdt billdt,u.agcd agcd,u.dpcd dpcd,SUM(u.gross_amt - u.return_amt) tot_amt
			FROM  #cir_bill_print u 
			GROUP BY u.comp_code,u.unit_code,u.agcd,u.dpcd, u.billno, u.billdt )x
		GROUP BY x.comp_code, x.unit_code, x.billno, x.billdt, x.agcd, x.dpcd 
		ORDER BY comp_code, unit_code, billdt, billno, agcd, dpcd
---- district		
		SELECT x.comp_code comp_code, x.unit unit, x.billno billno, x.billdt billdt, x.agcd agcd, x.dpcd dpcd, SUM(x.tot_comm) tot_comm
		FROM (SELECT u.comp_code comp_code, u.unit_code unit, u.billno billno,u.billdt billdt,u.agcd agcd,u.dpcd dpcd,SUM(u.comm_amt) tot_comm
			FROM  cir_bill_det u ,cir_agmast x
			WHERE u.comp_code  = @pcomp_code AND	u.unit_code  = @punit_code
			and u.comp_code=x.comp_code and u.agcd=x.agcd and u.dpcd=x.dpcd
			 AND u.billdt  BETWEEN @v_bill_frdt  AND  @v_bill_todt
			 AND u.bill_flag  = @pbill_freq
			 and (x.dist_code=@pextra3 or @pextra3 is null or @pextra3='')
			 AND ((billno  BETWEEN @pfrom_billno  AND  @ptill_billno) OR (@pfrom_billno  IS NULL))
			 AND (u.agcd  = @pbillagcd OR	@pbillagcd IS NULL OR @pbillagcd='')
			 AND (u.dpcd  = @pbilldpcd OR	@pbilldpcd IS NULL OR @pbilldpcd='')
			GROUP BY u.comp_code, u.unit_code, u.agcd,u.dpcd,u.billno, u.billdt )x
		GROUP BY x.comp_code, x.unit,x.billno,x.billdt, x.agcd,x.dpcd 
		ORDER BY comp_code, unit, billdt,billno,agcd,dpcd 
		
		SELECT x.comp_code comp_code,x.unit_code unit_code, x.billno billno,x.billdt billdt,x.agcd agcd,x.dpcd dpcd,SUM(x.tot_surcharge) tot_surcharge
		FROM (SELECT u.comp_code comp_code,u.unit_code unit_code,u.billno billno,u.billdt billdt,u.agcd agcd,u.dpcd dpcd,SUM(u.sur_amt) tot_surcharge
			FROM  #cir_bill_print u 
		GROUP BY u.comp_code,u.unit_code,u.agcd,u.dpcd, u.billno, u.billdt ) x
		GROUP BY x.comp_code, x.unit_code, x.billno, x.billdt, x.agcd, x.dpcd 
		ORDER BY comp_code, unit_code, billdt, billno, agcd, dpcd 
		
		SELECT comp_code,unit_code, billno, billdt,agcd,dpcd,SUM(net_amt) net_amt
		FROM (SELECT u.comp_code comp_code,u.unit_code unit_code,u.billno billno,u.billdt billdt,u.agcd agcd,u.dpcd dpcd,
			 SUM(u.gross_amt - u.return_amt - u.comm_amt + u.sur_amt) net_amt
			FROM  #cir_bill_print u 
		GROUP BY u.comp_code,u.unit_code, u.agcd, u.dpcd, u.billno,u.billdt )x
		GROUP BY comp_code, unit_code, billno,billdt, agcd,dpcd 
		ORDER BY comp_code, unit_code, billdt,billno, agcd,dpcd 
		
		SELECT comp_code,unit_code, dt billdt, agname billno,publ_code publ,agcd, dpcd,dn_amt AS "Debit Amt", cn_amt AS "Credit Amt",rec_amt AS "Receipt Amount",
		op_amt AS "Previous Balance"
		FROM  #cir_temp_outstanding
---- district		
		SELECT u.comp_code,u.unit_code, u.billno,u.billdt,u.agcd, u.dpcd,u.copy_rate,SUM(u.bill_copy) bill_copy,SUM(ISNULL(u.copy_rate, 0) * ISNULL(u.bill_copy, 0)) gross_amt
		FROM  cir_bill_det u,cir_agmast x
		WHERE u.comp_code  = @pcomp_code AND unit_code  = @punit_code
		 AND u.billdt  BETWEEN @v_bill_frdt  AND  @v_bill_todt
		 and u.comp_code=x.comp_code and u.agcd=x.agcd and u.dpcd=x.dpcd
		 AND u.bill_flag  = @pbill_freq
		 AND ((u.billno  BETWEEN @pfrom_billno  AND  @ptill_billno) OR (@pfrom_billno  IS NULL) OR (@pfrom_billno=''))
		 AND (u.agcd  = @pbillagcd OR	@pbillagcd IS NULL OR @pbillagcd='')
		 AND (u.dpcd  = @pbilldpcd OR	@pbilldpcd  IS NULL OR @pbilldpcd='')
		GROUP BY u.comp_code,u.unit_code, u.billno,u.billdt,u.agcd, u.dpcd,u.copy_rate 
		ORDER BY u.comp_code,u.unit_code, u.billdt,u.billno,u.agcd, u.dpcd 
---- district
		SELECT DISTINCT	 b.comp_code comp_code,b.unit_code unit_code,b.billno billno,b.billdt billdt,b.agcd agcd,b.dpcd dpcd,
				 (SELECT ISNULL(SUM(a.sup_copy), 0)
				FROM cir_dbksup a ,cir_supply_type_mast s
				WHERE b.comp_code  = a.comp_code AND a.comp_code  = s.comp_code AND a.unit_code  = b.unit_code
				 AND b.publ  = a.publ AND a.edtn  = b.edtn
				 AND a.sup_type_code=s.sup_ty_code
     			 AND s.bill_pay  = 'N' AND a.supdate BETWEEN @v_bill_frdt  AND  @v_bill_todt
				 AND a.billagcd  = b.agcd AND a.billdpcd  = b.dpcd) unpaid_copy
		FROM  cir_bill_det b 
		WHERE b.comp_code  = @pcomp_code AND	b.unit_code  = @punit_code
		 AND b.billdt  BETWEEN @v_bill_frdt  AND  @v_bill_todt
		 AND b.bill_flag  = @pbill_freq
		 AND ((b.billno  BETWEEN @pfrom_billno  AND  @ptill_billno) OR (@pfrom_billno  IS NULL) OR (@pfrom_billno=''))
		 AND (b.publ  = @ppubl OR @ppubl IS NULL OR @ppubl='') AND (b.agcd  = @pbillagcd OR @pbillagcd IS NULL OR @pbillagcd='')
		 AND (b.dpcd  = @pbilldpcd OR @pbilldpcd  IS NULL OR @pbilldpcd='') AND b.billdt  BETWEEN  @v_bill_frdt  AND  @v_bill_todt
		ORDER BY b.comp_code, b.unit_code, b.billno,b.billdt, b.agcd,b.dpcd 
		
		DROP TABLE #cir_BILL_PRINT;
		DROP TABLE #cir_temp_outstanding;
		DROP TABLE #cir_temp_bill_collection;
 DEALLOCATE cur_bill
 DEALLOCATE cur_publ_edtn

END

***************************************




create PROCEDURE [dbo].[cir_rep_billing_dist_list_p]
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
	SET @v_bill_frdt  = dbo.convert_user_date('/', @pfrom_billdt,@pdateformat)
	SET @v_bill_todt  = dbo.convert_user_date('/', @ptill_billdt,@pdateformat)
	
	SELECT distinct
	a.dist_code DIST_CODE, DBO.cir_get_dist(a.comp_code,a.state_code,a.dist_code) DIST_NAME
	from cir_agmast a,cir_bill_det b
		where a.comp_code=@pcomp_code and a.comp_code=b.comp_code and a.unit=b.unit_code and a.unit=@punit_code and 
              b.billdt >=@v_bill_frdt and b.billdt<=@v_bill_todt and a.agcd=b.agcd and a.dpcd=b.dpcd and 
              (b.publ=isnull(@ppubl,b.publ) or @ppubl='') and 
              ((upper(DBO.cir_get_dist(a.comp_code,a.state_code,a.dist_code)) like upper(@pextra1)+'%') or (@pextra1 is null) or (@pextra1=''))
	union
	SELECT distinct
	a.dist_code DIST_CODE, DBO.cir_get_dist(a.comp_code,a.state_code,a.dist_code) DIST_NAME
	from cir_agmast a,cir_bill_det b
		where a.comp_code=@pcomp_code and a.comp_code=b.comp_code and a.unit=b.unit_code and a.unit=@punit_code and 
              b.billdt >=@v_bill_frdt and b.billdt<=@v_bill_todt and a.agcd=b.agcd and a.dpcd=b.dpcd and 
              (b.publ=isnull(@ppubl,b.publ) or @ppubl='') and 
              upper(a.dist_code) = upper(@pextra1) order by dist_name


****************************** end of issue 7674********************************************************

**************** Rikkee Garg **************** issue 7768 *************************29/6/2012*****


ALTER procedure [dbo].[cir_rep_datewise_po_summ]
     @pcomp_code     as varchar(20),
     @punit_code     as varchar(20),
     @ppubl          as varchar(20),
     @pfromdate      as datetime,
     @ptilldate      as datetime,
     @pdateformat    as varchar(20),
     @preptype       as varchar(20),--1 for supply type wise 2 for edition wise
     @pextra1        as varchar(20),
     @pextra2        as varchar(20),
     @pextra3        as varchar(20),
     @pextra4        as varchar(20),
     @pextra5        as varchar(20) as
begin

    create table #cir_temp_bill_collection
    (comp_code        varchar(200),
     unit_code        varchar(200), 
     billdt            datetime, 
     publ_code        varchar(200),
     supply_copy    int,
     gross_amt        numeric(15,4), 
     agname            varchar(200),
cur_sessionid    numeric(18,0) 
)

    declare cur_dbk cursor for
            select distinct x.comp_code comp_code,x.unit_code unit_code,x.supdate supdate,x.publ_name publ_name,
            x.sup_ty_name sup_ty_name,x.sup_seqno sup_seqno,x.supply_copy supply_copy 
            from
            (select d.comp_code comp_code,d.unit_code unit_code,d.supdate supdate,p.publ_name publ_name,
            t.sup_ty_name sup_ty_name,t.sup_seq_no sup_seqno, sum(d.sup_copy) supply_copy
            from cir_dbksup d,cir_edtn_mast e,cir_publ_mast p,cir_supply_type_mast t
            where d.comp_code=e.comp_code and d.comp_code=p.comp_code 
            and d.comp_code=t.comp_code and d.comp_code=@pcomp_code and
            d.unit_code=e.unit_code and d.unit_code=isnull(@punit_code,d.unit_code) and d.publ=p.publ 
            and d.publ=e.publ and (d.publ=isnull(@ppubl,d.publ) or @ppubl='') and 
            d.edtn=e.edtn and d.supdate >= @pfromdate and d.supdate <=@ptilldate and d.sup_type_code=t.sup_ty_code and 
            isnull(@preptype,'1')='1'
            group by d.comp_code,d.unit_code,d.supdate,p.publ_name,t.sup_ty_name,t.sup_seq_no
            union
            select d.comp_code comp_code,d.unit_code unit_code,d.supdate supdate,p.publ_name publ_name,
            e.edtn_name sup_ty_name,e.edtn_seq_no sup_seqno, sum(d.sup_copy) supply_copy
            from cir_dbksup d,cir_edtn_mast e,cir_publ_mast p,cir_supply_type_mast t
            where d.comp_code=e.comp_code and d.comp_code=p.comp_code 
            and d.comp_code=t.comp_code and d.comp_code=@pcomp_code and
            d.unit_code=e.unit_code and d.unit_code=isnull(@punit_code,d.unit_code) and d.publ=p.publ 
            and d.publ=e.publ and (d.publ=isnull(@ppubl,d.publ) or @ppubl='') and 
            d.edtn=e.edtn and d.supdate >= @pfromdate and d.supdate <=@ptilldate and d.sup_type_code=t.sup_ty_code and
            isnull(@preptype,'1')='2' 
            group by d.comp_code,d.unit_code,d.supdate,p.publ_name,e.edtn_name,e.edtn_seq_no)x;

declare @rec_dbk_comp_code        varchar(100)
declare @rec_dbk_unit_code        varchar(100)
declare @rec_dbk_supdate        datetime
declare @rec_dbk_publ_name        varchar(100)
declare @rec_dbk_sup_ty_name    varchar(100)
declare @rec_dbk_sup_seqno        int
declare @rec_dbk_supply_copy    int

     declare cur_sup_type cursor for
        select distinct gross_amt sup_seq_no,agname supply_type_name 
        from #cir_temp_bill_collection
        order by gross_amt,agname;

declare @rec_sup_type_sup_seq_no        int
declare @rec_sup_type_supply_type_name  varchar(100)    
declare @vvar        varchar(4000)
declare @vvar_sum    varchar(4000)
declare @vquery      varchar(8000)
declare @v_count     int
     
    open cur_dbk
        fetch NEXT FROM cur_dbk into @rec_dbk_comp_code,@rec_dbk_unit_code,@rec_dbk_supdate,@rec_dbk_publ_name,
            @rec_dbk_sup_ty_name,@rec_dbk_sup_seqno,@rec_dbk_supply_copy
    WHILE (@@FETCH_STATUS = 0) BEGIN
        insert into #cir_temp_bill_collection
        (comp_code, unit_code, billdt, publ_code, supply_copy, gross_amt, 
        agname)
        values(@rec_dbk_comp_code,@rec_dbk_unit_code,@rec_dbk_supdate,@rec_dbk_publ_name,@rec_dbk_supply_copy,NULL,
        @rec_dbk_sup_ty_name)
        
        fetch NEXT FROM cur_dbk into @rec_dbk_comp_code,@rec_dbk_unit_code,@rec_dbk_supdate,@rec_dbk_publ_name,
            @rec_dbk_sup_ty_name,@rec_dbk_sup_seqno,@rec_dbk_supply_copy
    end
    close cur_dbk;
        
    open cur_sup_type;
        fetch next from cur_sup_type into @rec_sup_type_sup_seq_no,@rec_sup_type_supply_type_name
        WHILE (@@FETCH_STATUS = 0) BEGIN
        if @vvar is null or @vvar ='' begin
            set @vvar       ='case when d.agname='+''''+@rec_sup_type_supply_type_name+''''+' then d.supply_copy else 0 end "'+@rec_sup_type_supply_type_name+'"'
            set @vvar_sum   ='sum("'+@rec_sup_type_supply_type_name+'")'+' "'+@rec_sup_type_supply_type_name+'"'
        end
        else Begin
            set @vvar       =@vvar+','+'case when d.agname='+''''+@rec_sup_type_supply_type_name+''''+' then d.supply_copy else 0 end "'+@rec_sup_type_supply_type_name+'"'
            set @vvar_sum   =@vvar_sum+','+'sum("'+@rec_sup_type_supply_type_name+'")'+' "'+@rec_sup_type_supply_type_name+'"'
        end
        fetch next from cur_sup_type into @rec_sup_type_sup_seq_no,@rec_sup_type_supply_type_name
    end
    close cur_sup_type;
    print(@vvar)
    deallocate cur_sup_type
    
    deallocate cur_dbk
    if @vvar is null or @vvar ='' begin
        set @vquery=' select x.comp_code comp_code,x.unit_code unit_code,x.publ publ,x.publ_name publ_name,
                x.supdate supdate, sum(x.supply_copy) TOTAL from
                (select d.comp_code comp_code,d.unit_code unit_code,d.publ_code publ,d.publ_code publ_name,
                case '''+@pdateformat+'''
                when ''mm/dd/yyyy'' then convert(varchar(20),d.billdt,101)
                when ''dd/mm/yyyy'' then convert(varchar(20),d.billdt,103)
                when ''yyyy/mm/dd'' then convert(varchar(20),d.billdt,111) end as supdate,
                d.supply_copy supply_copy 
                from #cir_temp_bill_collection d
                where d.cur_sessionid=@@spid) x  group by x.comp_code,x.unit_code,x.publ,x.publ_name,x.supdate
                order by comp_code,unit_code,supdate,publ_name';
    end
    else begin
        set @vquery=' select x.comp_code comp_code,x.unit_code unit_code,x.publ publ,x.publ_name publ_name,
                x.supdate supdate,'+@vvar_sum+', sum(x.supply_copy) TOTAL
                from
                (select d.comp_code comp_code,d.unit_code unit_code,d.publ_code publ,d.publ_code publ_name,
                case '''+@pdateformat+'''
                when ''mm/dd/yyyy'' then convert(varchar(20),d.billdt,101)
                when ''dd/mm/yyyy'' then convert(varchar(20),d.billdt,103)
                when ''yyyy/mm/dd'' then convert(varchar(20),d.billdt,111) end as supdate,
                '+@vvar+',d.supply_copy supply_copy
                from #cir_temp_bill_collection d) x  group by x.comp_code,x.unit_code,x.publ,x.publ_name,x.supdate
                order by comp_code,unit_code,supdate,publ_name';
    end               

    print(@vquery)
    exec(@vquery)
    
    if @vvar is null or @vvar ='' begin
        set @vquery=' select x.comp_code comp_code,x.unit_code unit_code,x.publ publ,x.publ_name publ_name,sum(x.supply_copy) TOTAL from
                (select d.comp_code comp_code,d.unit_code unit_code,d.publ_code publ,d.publ_code publ_name,
                case '''+@pdateformat+'''
                when ''mm/dd/yyyy'' then convert(varchar(20),d.billdt,101)
                when ''dd/mm/yyyy'' then convert(varchar(20),d.billdt,103)
                when ''yyyy/mm/dd'' then convert(varchar(20),d.billdt,111) end as supdate,
                d.supply_copy supply_copy from #cir_temp_bill_collection d) x group by x.comp_code,x.unit_code,x.publ,x.publ_name
                order by comp_code,unit_code,publ_name';                
    end
    else begin
        set @vquery=' select x.comp_code comp_code,x.unit_code unit_code,x.publ publ,x.publ_name publ_name,
                '+@vvar_sum+', sum(x.supply_copy) TOTAL from
                (select d.comp_code comp_code,d.unit_code unit_code,d.publ_code publ,d.publ_code publ_name,
                case '''+@pdateformat+'''
                when ''mm/dd/yyyy'' then convert(varchar(20),d.billdt,101)
                when ''dd/mm/yyyy'' then convert(varchar(20),d.billdt,103)
                when ''yyyy/mm/dd'' then convert(varchar(20),d.billdt,111) end as supdate,
                '+@vvar+',d.supply_copy supply_copy from #cir_temp_bill_collection d) x 
                group by x.comp_code,x.unit_code,x.publ,x.publ_name
                order by comp_code,unit_code,publ_name';    
    end
    
    print(@vquery)
    exec(@vquery)
    
    drop table #cir_temp_bill_collection
End


**************************** end of issue 7768***************************************************

///////30june by laxman sir*************/
                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE cir_rep_outstanding_cir_rep_outstanding_summ_p
    @pcompcode                                VARCHAR(20) ,
    @punitcode                                VARCHAR(20) ,
    @ppublcode                                VARCHAR(20) ,
    @pactype                                  VARCHAR(20) ,
    @pagency_type                             VARCHAR(20) ,
    @pagcd                                    VARCHAR(20) ,
    @pdpcd                                    VARCHAR(20) ,
    @prep_type                                VARCHAR(20) ,--statewise or districtwise or talukawise or branchwise
    @pcode                                    VARCHAR(20) ,
    @pfromdate                                datetime ,
    @pasondate                                datetime,
    @pdateformat                              VARCHAR(20) ,
    @pextra1                                  VARCHAR(4000),--it is used for executive
    @pextra2                                  VARCHAR(4000)
AS
   
Begin
   
    DECLARE @v_frdt                           DATETIME
    DECLARE @v_todt                           DATETIME
    DECLARE @v_opdate                         DATETIME
    DECLARE @v_opbal                          NUMERIC(15,2)                  
    SET @v_opbal = 0
    DECLARE @v_clbal                          NUMERIC(15,2)
    SET @v_clbal = 0
    DECLARE @v_billamt                        NUMERIC(15,2)                          
    SET @v_billamt = 0
    DECLARE @v_dbcramt                        NUMERIC(15,2)                          
    SET @v_dbcramt = 0
    DECLARE @v_recamt                         NUMERIC(15,2)                          
    SET @v_recamt = 0
    DECLARE @v_othdbamt                       NUMERIC(15,2)                          
    SET @v_othdbamt = 0
    DECLARE @v_othcramt                       NUMERIC(15,2)                          
    SET @v_othcramt = 0


    DECLARE @v_comp_code1                             varchar(10)
    DECLARE @v_unit1                                  varchar(10)
    DECLARE @v_agcd1                                  varchar(10)
    DECLARE @v_dpcd1                                  varchar(10)
    DECLARE @v_ag_name1                               varchar(50)
    DECLARE @v_ag_name_oth_lang1                      varchar(200)
    DECLARE @v_city_code1                             varchar(200)
    DECLARE @v_tehsil_taluka1                         varchar(200)
    DECLARE @v_dist_code1                             varchar(200)
    DECLARE @v_state_code1                            varchar(200)
    DECLARE @v_country_code1                          varchar(200)

if @ppublcode='' begin
    set @ppublcode=null
end
if @pagency_type=''
begin
    set @pagency_type=null
end
if @pagcd=''
begin
    set @pagcd=null
end
if @pdpcd=''
begin
    set @pdpcd=null
end
if    @pcode=''
begin
    set @pcode=null
end
if    @pextra1=''
begin
    set @pextra1=null
end
if    @pextra2=''
begin
    set @pextra2=null
end
print('0')

CREATE TABLE #CIR_TEMP_OUTSTANDING
( COMP_CODE        VARCHAR(100),
  UNIT_CODE        VARCHAR(100),
  DT               DATETIME,
  PUBL_CODE        VARCHAR(100),
  AGCD             VARCHAR(100),
  DPCD             VARCHAR(100),
  BILL_AMT         NUMERIC(15,2)    DEFAULT 0,
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
  OP_AMT           NUMERIC(15,2),
  BRANCH_CODE      VARCHAR(8)
);
declare @v_branch_code varchar(8)
    SET @v_opdate  = DBO.cir_get_finandt(@pcompcode, @pfromdate, @pdateformat, '', '')--DBO.cir_get_finandt(@pcompcode, dbo.convert_user_date('/', @pfromdate , @pdateformat), @pdateformat, '', '')

    SET @v_frdt  = @pfromdate--dbo.convert_user_date('/', @pfromdate, @pdateformat)
    SET @v_todt  = @pasondate--dbo.convert_user_date('/', @pasondate, @pdateformat)
   
   
    DECLARE c1 cursor LOCAL FOR
        SELECT DISTINCT comp_code, unit, agcd, dpcd, ag_name, ag_name_oth_lang, city_code, tehsil_taluka, dist_code,
        state_code, country_code,branch_code
        FROM  cir_agmast
        WHERE comp_code  = @pcompcode AND unit  = @punitcode
        AND    (ag_type  = @pagency_type OR    @pagency_type  is null or @pagency_type='')
        AND    (EXECUTIVE_CODE  = @pextra1 OR    @pextra1  is null or @pextra1='')
        /*AND    agcd + dpcd  in
            (SELECT DISTINCT CAST(agcd AS VARCHAR) + CAST(dpcd AS VARCHAR)
            FROM  cir_outmast
            WHERE comp_code  = @pcompcode AND    unit_code  = @punitcode    AND    achd  = @pactype
            AND    (publ  = @ppublcode OR    @ppublcode  is null OR    @ppublcode = '')) */
            and agcd=isnull(@pagcd,agcd) and dpcd=isnull(@pdpcd,dpcd) and
            (((state_code=@pcode or @pcode is null) and @prep_type='1') or
            ((dist_code=@pcode or @pcode is null) and @prep_type='2') or
            ((tehsil_taluka=@pcode or @pcode is null) and @prep_type='3')or
            ((branch_code=@pcode or @pcode is null) and @prep_type='4'));
       
    OPEN c1
    fetch NEXT FROM c1 INTO @v_comp_code1 ,@v_unit1, @v_agcd1,@v_dpcd1 ,@v_ag_name1,@v_ag_name_oth_lang1,@v_city_code1,
            @v_tehsil_taluka1, @v_dist_code1, @v_state_code1,@v_country_code1,@v_branch_code

    WHILE (@@FETCH_STATUS = 0)
    BEGIN
        SET @v_opbal  = DBO.cir_accounts_cir_agency_opbal(@pcompcode, @punitcode, @ppublcode, @v_agcd1, @v_dpcd1, @v_opdate, @pactype, @pdateformat, @pextra1, @pextra2)
            select @v_billamt =sum(amount) from cir_outmast
                where comp_code=@pcompcode and unit_code=@punitcode and
                    agcd=@v_agcd1 and dpcd=@v_dpcd1 and billdt >= @v_opdate and billdt<@v_frdt and
                    achd=@pactype and (publ=@ppublcode or @ppublcode is null OR @ppublcode = '') and recptno is null
                               
            select @v_dbcramt=sum(amount) from cir_rcphdr
                where comp_code=@pcompcode and unit_code=@punitcode  and
                    agcd=@v_agcd1 and dpcd=@v_dpcd1 and recptdt>= @v_opdate and recptdt<@v_frdt and
                    achd=@pactype and (publ=@ppublcode or @ppublcode is null OR    @ppublcode = '')
            
            set @v_opbal=isnull(@v_opbal,0)+isnull(@v_billamt,0)+isnull(@v_dbcramt,0);
            set @v_billamt=0           
           
            select @v_billamt=sum(amount)  from cir_outmast
                where comp_code=@pcompcode and unit_code=@punitcode and
                    agcd=@v_agcd1 and dpcd=@v_dpcd1 and billdt >= @v_frdt and billdt<=@v_todt and
                    achd=@pactype and (publ=@ppublcode or @ppublcode is null OR @ppublcode = '') and recptno is null
           
            select @v_othdbamt=sum(amount) from cir_rcphdr
                where comp_code=@pcompcode and unit_code=@punitcode and
                            agcd=@v_agcd1 and dpcd=@v_dpcd1 and recptdt>= @v_frdt and recptdt<=@v_todt and
                            achd=@pactype and (publ=@ppublcode or @ppublcode is null OR @ppublcode = '') and isnull(amount,0)>0;

            select @v_recamt =sum(amount) from cir_rcphdr
                where comp_code=@pcompcode and unit_code=@punitcode and
                            agcd=@v_agcd1 and dpcd=@v_dpcd1 and recptdt>= @v_frdt and recptdt<=@v_todt and doctype='RCR' and
                            achd=@pactype and (publ=@ppublcode or @ppublcode is null OR @ppublcode = '') and isnull(amount,0)<0

            select  @v_othcramt=sum(amount) from cir_rcphdr
                where comp_code=@pcompcode and unit_code=@punitcode and
                            agcd=@v_agcd1 and dpcd=@v_dpcd1 and recptdt>= @v_frdt and recptdt<=@v_todt and doctype<>'RCR' and
                            achd=@pactype and (publ=@ppublcode or @ppublcode is null OR @ppublcode = '') and isnull(amount,0)<0
           
            set @v_clbal=isnull(@v_opbal,0)+isnull(@v_billamt,0)+isnull(@v_othdbamt,0)+isnull(@v_recamt,0)+isnull(@v_othcramt,0)
           
            if (@v_clbal<>0  or @v_opbal<>0 or @v_billamt<>0 or @v_othdbamt<>0 or @v_recamt<>0 or @v_othcramt<>0)
            BEGIN
                INSERT INTO  #cir_temp_outstanding (comp_code ,unit_code , dt , publ_code , agcd , dpcd , op_amt ,
                bill_amt , dn_amt , rec_amt , cn_amt , agname , agname_oth_lang , city_code , taluka_code , dist_code ,
                state_code , country_code,BRANCH_CODE ) 
                VALUES     ( @v_comp_code1 , @v_unit1 , @v_frdt , @ppublcode , @v_agcd1 , @v_dpcd1 , isnull(@v_opbal, 0) ,
                isnull(@v_billamt, 0) , isnull(@v_othdbamt, 0) , isnull(@v_recamt, 0) , isnull(@v_othcramt, 0) , @v_ag_name1 ,
                @v_ag_name_oth_lang1 , @v_city_code1 , @v_tehsil_taluka1 , @v_dist_code1 , @v_state_code1 , @v_country_code1,@v_branch_code ) 
               

            END
  
            SET @v_billamt  = 0
            SET @v_dbcramt  = 0
            SET @v_opbal  = 0
            SET @v_clbal  = 0
            SET @v_recamt  = 0
            SET @v_othdbamt  = 0
            SET @v_othcramt  = 0
           
            fetch NEXT FROM c1 INTO @v_comp_code1 ,@v_unit1, @v_agcd1,@v_dpcd1 ,@v_ag_name1,@v_ag_name_oth_lang1,@v_city_code1,
            @v_tehsil_taluka1, @v_dist_code1, @v_state_code1,@v_country_code1,@v_branch_code

        END
        close c1
       
        print('1')
        IF @prep_type = '1' --for statewise group
        BEGIN
            print('2')
            select a.comp_code comp_code,a.unit_code unit_code,a.state_code rep_type_code,substring(dbo.cir_get_state(a.comp_code,a.country_code,a.state_code),1,30) rep_type_name,
                    a.agcd agcd,a.dpcd dpcd,a.op_amt op_amt,a.bill_amt billamt,a.dn_amt other_dbamt,a.rec_amt recamt,a.cn_amt other_cramt,
                    isnull(a.op_amt,0)+isnull(a.bill_amt,0)+isnull(a.dn_amt,0)+isnull(a.rec_amt,0)+isnull(a.cn_amt,0) cl_amt,
                    a.agname agname,a.agname_oth_lang agname_oth_lang,
                    a.city_code city_code,substring(dbo.cir_get_city(a.comp_code,a.city_code),1,30) city_name
                    from #cir_temp_outstanding a
            order by a.comp_code,a.unit_code,rep_type_name,a.agname
           
            select x.comp_code comp_code,x.unit_code unit_code,x.state_code rep_type_code,x.state_name rep_type_name,sum(x.op_amt) op_amt,sum(x.bill_amt) billamt,sum(x.dn_amt) other_dbamt,
                    sum(x.rec_amt) recamt,sum(x.cn_amt) other_cramt,
                    sum(isnull(x.op_amt,0)+isnull(x.bill_amt,0)+isnull(x.dn_amt,0)+isnull(x.rec_amt,0)+isnull(x.cn_amt,0)) cl_amt from
        (select a.comp_code comp_code,a.unit_code unit_code,a.state_code state_code,substring(dbo.cir_get_state(a.comp_code,a.country_code,a.state_code),1,30) state_name,
                    sum(a.op_amt) op_amt,sum(a.bill_amt) bill_amt,sum(a.dn_amt) dn_amt,sum(a.rec_amt) rec_amt,sum(a.cn_amt) cn_amt,
                    sum(isnull(a.op_amt,0)+isnull(a.bill_amt,0)+isnull(a.dn_amt,0)+isnull(a.rec_amt,0)+isnull(a.cn_amt,0)) cl_amt
                    from #cir_temp_outstanding a
                    group by a.comp_code,a.unit_code,a.state_code,a.country_code) x
                    group by x.comp_code,x.unit_code,x.state_code,x.state_name
            order by comp_code,unit_code,rep_type_name
        END
        else IF @prep_type = '2'
        BEGIN
        print('3')
            --for district wise group
            select a.comp_code comp_code,a.unit_code unit_code,a.dist_code rep_type_code,substring(dbo.cir_get_dist(a.comp_code,a.state_code,a.dist_code),1,30) rep_type_name,
                    a.agcd agcd,a.dpcd dpcd,a.op_amt op_amt,a.bill_amt billamt,a.dn_amt other_dbamt,a.rec_amt recamt,a.cn_amt other_cramt,
                    isnull(a.op_amt,0)+isnull(a.bill_amt,0)+isnull(a.dn_amt,0)+isnull(a.rec_amt,0)+isnull(a.cn_amt,0) cl_amt,
                    a.agname agname,a.agname_oth_lang agname_oth_lang,
                    a.city_code city_code,substring(dbo.cir_get_city(a.comp_code,a.city_code),1,30) city_name
                    from #cir_temp_outstanding a
            order by a.comp_code,a.unit_code,rep_type_name,a.agname
       
            select x.comp_code comp_code, x.unit_code unit_code,x.dist_code rep_type_code,x.dist_name rep_type_name,sum(x.op_amt) op_amt,sum(x.bill_amt) billamt,sum(x.dn_amt) other_dbamt,
                    sum(x.rec_amt) recamt,sum(x.cn_amt) other_cramt,
                    sum(isnull(x.op_amt,0)+isnull(x.bill_amt,0)+isnull(x.dn_amt,0)+isnull(x.rec_amt,0)+isnull(x.cn_amt,0)) cl_amt from(
        select a.comp_code comp_code,a.unit_code unit_code,a.dist_code dist_code,substring(dbo.cir_get_dist(a.comp_code,a.state_code,a.dist_code),1,30) dist_name,
                    sum(a.op_amt) op_amt,sum(a.bill_amt) bill_amt,sum(a.dn_amt) dn_amt,sum(a.rec_amt) rec_amt,sum(a.cn_amt) cn_amt,
                    sum(isnull(a.op_amt,0)+isnull(a.bill_amt,0)+isnull(a.dn_amt,0)+isnull(a.rec_amt,0)+isnull(a.cn_amt,0)) cl_amt
                    from #cir_temp_outstanding a
                    group by a.comp_code,a.unit_code,a.state_code,a.dist_code) x
                    group by x.comp_code,x.unit_code,x.dist_code,x.dist_name
            order by comp_code,unit_code,rep_type_name
       
        END
        else IF @prep_type = '3'
        BEGIN
            --for talukawise group
            print('4')
            select a.comp_code comp_code,a.unit_code unit_code,a.taluka_code rep_type_code,substring(dbo.cir_get_taluka(a.comp_code,a.taluka_code),1,30) rep_type_name,
                    a.agcd agcd,a.dpcd dpcd,a.op_amt op_amt,a.bill_amt billamt,a.dn_amt other_dbamt,a.rec_amt recamt,a.cn_amt other_cramt,
                    isnull(a.op_amt,0)+isnull(a.bill_amt,0)+isnull(a.dn_amt,0)+isnull(a.rec_amt,0)+isnull(a.cn_amt,0) cl_amt,a.agname agname,a.agname_oth_lang agname_oth_lang,
                    a.city_code city_code,substring(dbo.cir_get_city(a.comp_code,a.city_code),1,30) city_name
                    from #cir_temp_outstanding a
               order by a.comp_code,a.unit_code,rep_type_name,a.agname
           
            select x.comp_code comp_code,x.unit_code unit_code,x.taluka_code rep_type_code,x.taluka_name rep_type_name,
            sum(x.op_amt) op_amt,sum(x.bill_amt) billamt,sum(x.dn_amt) other_dbamt,sum(x.rec_amt) recamt,sum(x.cn_amt) other_cramt,
                    sum(isnull(x.op_amt,0)+isnull(x.bill_amt,0)+isnull(x.dn_amt,0)+isnull(x.rec_amt,0)+isnull(x.cn_amt,0)) cl_amt from
        (select a.comp_code comp_code,a.unit_code unit_code,a.taluka_code taluka_code,substring(dbo.cir_get_taluka(a.comp_code,a.taluka_code),1,30) taluka_name,
                    sum(a.op_amt) op_amt,sum(a.bill_amt) bill_amt,sum(a.dn_amt) dn_amt,sum(a.rec_amt) rec_amt,sum(a.cn_amt) cn_amt,
                    sum(isnull(a.op_amt,0)+isnull(a.bill_amt,0)+isnull(a.dn_amt,0)+isnull(a.rec_amt,0)+isnull(a.cn_amt,0)) cl_amt
                    from #cir_temp_outstanding a
                    group by a.comp_code,a.unit_code,a.taluka_code)x
                    group by x.comp_code,x.unit_code,x.taluka_code,x.taluka_name
            order by comp_code,unit_code,rep_type_name;
           
        END
        else
        begin
        print('8')

            select a.comp_code comp_code,a.unit_code unit_code,a.branch_code branch_code,dbo.AD_GET_BRANCHNAME (a.comp_code,a.branch_code) rep_type_name,
            a.agcd agcd,a.dpcd dpcd,a.op_amt op_amt,a.bill_amt billamt,a.dn_amt other_dbamt,a.rec_amt recamt,a.cn_amt other_cramt,
            isnull(a.op_amt,0)+isnull(a.bill_amt,0)+isnull(a.dn_amt,0)+isnull(a.rec_amt,0)+isnull(a.cn_amt,0) cl_amt,
            a.agname agname,a.agname_oth_lang agname_oth_lang,
            a.city_code city_code,substring(dbo.cir_get_city(a.comp_code,a.city_code),1,30) city_name
            from #cir_temp_outstanding a
            order by a.comp_code,a.unit_code,a.branch_code,a.agname;

            select x.comp_code comp_code,x.unit_code unit_code,x.branch_code rep_type_code,x.branch_Name rep_type_name,
            sum(x.op_amt) op_amt,sum(x.bill_amt) billamt,sum(x.dn_amt) other_dbamt,
            sum(x.rec_amt) recamt,sum(x.cn_amt) other_cramt,
            sum(isnull(x.op_amt,0)+isnull(x.bill_amt,0)+isnull(x.dn_amt,0)+isnull(x.rec_amt,0)+isnull(x.cn_amt,0)) cl_amt from
            (select a.comp_code comp_code,a.unit_code unit_code,a.branch_code branch_code,dbo.AD_GET_BRANCHNAME (a.comp_code,a.branch_code) branch_name,
            sum(a.op_amt) op_amt,sum(a.bill_amt) bill_amt,sum(a.dn_amt) dn_amt,sum(a.rec_amt) rec_amt,sum(a.cn_amt) cn_amt,
            sum(isnull(a.op_amt,0)+isnull(a.bill_amt,0)+isnull(a.dn_amt,0)+isnull(a.rec_amt,0)+isnull(a.cn_amt,0)) cl_amt
            from #cir_temp_outstanding a
            group by a.comp_code,a.unit_code,a.country_code,a.branch_code) x
            group by x.comp_code,x.unit_code ,x.branch_code ,x.branch_Name
            order by comp_code,unit_code,rep_type_name;

        end

	DEALLOCATE c1
	drop table #cir_temp_outstanding;
End
/*********5 july by sushil sir*******/

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
          (billno is null or isnull(billdt,@vtodt)>@vasondt) and 
          recptdt<=@vasondt /*and 
          doctyp+recptno+cast(recptdt as varchar) not in 
          (select distinct doctyp+recptno+cast(recptdt as varchar) from cir_outmast
           where comp_code=@pcomp_code and unit_code=@punit_code and
                 agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
                 recptdt<=@vtodt and isnull(amount,0)<0 and billno IS NULL)*/
    
    PRINT '@v_pending_rcpt_amt'
    PRINT  @v_pending_rcpt_amt
    
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
                                      city_name,pending_amt,slab_1,slab_2,slab_3,
                                      slab_4,slab_5,slab_6,rect_pending,on_acamt,
                                      sessionid)
                              values (@rec_agency_comp_code,@punit_code,@rec_agency_agcd, @rec_agency_dpcd, @rec_agency_agency_name,
                                      @rec_agency_city_name,isnull(@bill_pending_amt,0),isnull(@debit_amt_030,0),isnull(@debit_amt_3160,0), isnull(@debit_amt_6190,0), 
                                      isnull(@debit_amt_121180,0), isnull(@debit_amt_181,0),0,isnull(@rcpt_pending_amt,0),isnull(@v_pending_rcpt_amt,0),@@spid);
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
slab_6,rect_pending,on_acamt from #cir_temp_ageing 
/*where (PENDING_AMT>0 or SLAB_1>0 or SLAB_2>0 or SLAB_3>0 or SLAB_4>0 or SLAB_5>0 or ABS(RECT_PENDING)>0  )  
 and sessionid=@@SPID  */
 order by ag_name;
drop table #cir_temp_ageing

////////////////////////////////////add by Deepika )6/07/2012 sent by Gaurav sir////////////////////////////



                                                                     
                                                                     
                                             
ALTER function [dbo].[cir_get_unsold_permissable_days]
(
  @pcompcode         as varchar(20),      
  @ppublcode         as varchar(20),      
  @puserid           as varchar(20),
  @pagcd             as varchar(20),
  @pdpcd             as varchar(20),
  @pflag             as varchar(1),
  @pchkdate          as datetime,
  @preceivedt        as datetime,
  @pextra1           as varchar(20),
  @pextra2           as varchar(20)
 )					returns varchar(500)

As
Begin
	-------
	declare @v_bill_freq as varchar(1)
	declare @v_unit      as varchar(20)
	declare @v_branch   as varchar(20)
	declare @v_region    as varchar(20)
	declare @v_zone      as varchar(20)
	declare @v_agtype    as varchar(20)
	declare @v_agclass   as varchar(20)
	declare @v_citycode  as varchar(20)
	declare @v_cnt       as int
	declare @v_output    as int
	declare @v_value     as varchar(500)
	
	select distinct @v_bill_freq=billing_cycle from CIR_SUPPLY where comp_code= @pcompcode 
	and agcd=@pagcd and dpcd=@pdpcd and publ=@ppublcode
	and (EDTN=@pextra1 or @pextra1 is null or @pextra1 ='')

	select @v_unit=unit,@v_branch=branch_code,@v_citycode=city_code,@v_agtype=ag_type,@v_agclass=ag_class from cir_agmast
	where comp_code=@pcompcode and agcd=@pagcd and dpcd=@pdpcd
	
	select distinct @v_zone=zone_code,@v_region=region_code from cir_city_mast c where c.city_code=@v_citycode
	
	if @v_unit = '' begin
		set @v_unit=null
	end
	if @v_branch ='' begin
		set @v_branch=null
	end
	if @v_region ='' begin
		set @v_region=null
	end
	if @v_zone='' begin
		set @v_zone=null
	end
	if @v_agtype='' begin
		set @v_agtype=null
	end
	if @v_agclass ='' begin
		set @v_agclass=null
	end
	
	select @v_cnt= count(*) from CIR_UNSOLD_RETURN_CONTROL where comp_code=@pcompcode	
	and publ_code=@ppublcode and bill_freq=@v_bill_freq 
	--and (unit_code=@v_unit or unit_code is null or unit_code ='') 
	and (branch_code=@v_branch or branch_code is null or branch_code ='')
	and (reg_code=@v_region or reg_code is null or reg_code ='') 
	and (zone_code=@v_zone or zone_code is null or zone_code ='') 
	and (ag_type=@v_agtype or ag_type is null or ag_type ='') 
	and (ag_class=@v_agclass or ag_class is null or ag_class ='')

	
	select @v_output= isnull(no_of_days,0) from CIR_UNSOLD_RETURN_CONTROL p
	where comp_code=@pcompcode	
	and publ_code=@ppublcode and bill_freq=@v_bill_freq 
	and (unit_code=@v_unit or unit_code is null or unit_code ='') 
	and (branch_code=@v_branch or branch_code is null or branch_code ='')
	and (reg_code=@v_region or reg_code is null or reg_code ='') 
	and (zone_code=@v_zone or zone_code is null or zone_code ='') 
	and (ag_type=@v_agtype or ag_type is null or ag_type ='') 
	and (ag_class=@v_agclass or ag_class is null or ag_class ='')

	
	declare @diff_days as int
	set @diff_days=datediff(dd,@preceivedt,@pchkdate)
	
	if @v_cnt =0 begin
		set @v_output= 0
	end		

--- for checking the holidays from holiday master
declare @v_holidays as int
			select @v_holidays=count(*) from cir_holiday_mast where comp_code=@pcompcode 
			and (unit=@v_unit or @v_unit is null or @v_unit ='') 
			and (h_publ=@ppublcode or @ppublcode is null or @ppublcode ='')
			and isnull(freeze_flag,'N') ='N'
			and h_date between @preceivedt and  @pchkdate
if @v_holidays is not null or @v_holidays !=0
begin
	set @v_output=isnull(@v_output,0) + isnull(@v_holidays,0)
end

-- for checking by issue date
declare @v_d_cnt as int
declare @v_dt1 as datetime
declare @v_dt2 as datetime
declare @v_first_iss as varchar(3)
declare @v_second_iss as varchar(3)
declare @v_freq_pub as int
select @v_first_iss=first_issue,@v_second_iss=second_issue,@v_freq_pub=frequency_code from Cir_Edition_Issue_Date 
where comp_code=@pcompcode 
and (pub_code=@ppublcode or @ppublcode is null or @ppublcode ='')
and (edition_code=@pextra1 or @pextra1 is null or @pextra1='')

set @v_d_cnt =0

if @v_bill_freq != 'D'
begin
	if @v_freq_pub ='7'
	begin
		/*
		SELECT dbo.f_countweekdays(1, '2012-07-01', '2012-07-31'),dbo.f_countweekdays(2, '2012-07-01', '2012-07-31')
		  ,dbo.f_countweekdays(3, '2012-07-01', '2012-07-31'),dbo.f_countweekdays(4, '2012-07-01', '2012-07-31')
		  ,dbo.f_countweekdays(5, '2012-07-01', '2012-07-31'),dbo.f_countweekdays(6, '2012-07-01', '2012-07-31')
		  ,dbo.f_countweekdays(7, '2012-07-01', '2012-07-31')
		  */
			if @v_first_iss = 'SUN'
			begin
				set @v_d_cnt=dbo.f_countweekdays(1, @preceivedt, @pchkdate)
			end
			else
			if @v_first_iss = 'MON'
			begin
				set @v_d_cnt=dbo.f_countweekdays(2, @preceivedt, @pchkdate)
			end
			else
			if @v_first_iss = 'TUE'
			begin
				set @v_d_cnt=dbo.f_countweekdays(3, @preceivedt, @pchkdate)
			end
			else
			if @v_first_iss = 'WED'
			begin
				set @v_d_cnt=dbo.f_countweekdays(4, @preceivedt, @pchkdate)
			end
			else
			if @v_first_iss = 'THU'
			begin
				set @v_d_cnt=dbo.f_countweekdays(5, @preceivedt, @pchkdate)
			end
			else
			if @v_first_iss = 'FRI'
			begin
				set @v_d_cnt=dbo.f_countweekdays(6, @preceivedt, @pchkdate)
			end
			else
			if @v_first_iss = 'SAT'
			begin
				set @v_d_cnt=dbo.f_countweekdays(7, @preceivedt, @pchkdate)
			end
	end
	else if @v_freq_pub='15'
	begin
		if cast(@v_first_iss as int) >= DATEPART ( dd , @preceivedt ) and cast(@v_first_iss as int) <= DATEPART ( dd , @pchkdate )
		begin
			set @v_d_cnt=@v_d_cnt+1
		end
		if cast(@v_second_iss as int) >= DATEPART ( dd , @preceivedt ) and cast(@v_second_iss as int) <= DATEPART ( dd , @pchkdate )
		begin
			set @v_d_cnt=@v_d_cnt+1
		end
		
	end
	else if @v_freq_pub='30'
	begin
		if cast(@v_first_iss as int) >= DATEPART ( dd , @preceivedt ) and cast(@v_first_iss as int) <= DATEPART ( dd , @pchkdate )
		begin
			set @v_d_cnt=@v_d_cnt+1
		end
	end
	else
	begin
		set @v_first_iss='1'
	end
	set @v_output=isnull(@v_output,0) + isnull(@v_d_cnt,0)
end
else
begin 
	-- for checking in preferrences 
declare @v_holiday_sun as varchar(1)
declare @v_holiday_mon as varchar(1)
declare @v_holiday_tue as varchar(1)
declare @v_holiday_wed as varchar(1)
declare @v_holiday_thu as varchar(1)
declare @v_holiday_fri as varchar(1)
declare @v_holiday_sat as varchar(1)
			select @v_holiday_sun=isnull(cir_allow_holiday_sun,'N'),
			@v_holiday_mon=isnull(CIR_ALLOW_HOLIDAY_MON,'N'),
			@v_holiday_tue=isnull(CIR_ALLOW_HOLIDAY_TUE,'N'),
			@v_holiday_wed=isnull(CIR_ALLOW_HOLIDAY_WED,'N'),
			@v_holiday_thu=isnull(CIR_ALLOW_HOLIDAY_THU,'N'),
			@v_holiday_fri=isnull(CIR_ALLOW_HOLIDAY_FRI,'N'),
			@v_holiday_fri=isnull(CIR_ALLOW_HOLIDAY_SAT,'N')
			from preferrences where comp_code=@pcompcode 

		if	@v_holiday_sun ='Y'
		begin
			set @v_d_cnt=@v_d_cnt+dbo.f_countweekdays(1, @preceivedt, @pchkdate)
		end
		if	@v_holiday_mon ='Y'
		begin
				set @v_d_cnt=@v_d_cnt+dbo.f_countweekdays(2, @preceivedt, @pchkdate)
		end
		if	@v_holiday_tue ='Y'
		begin
				set @v_d_cnt=@v_d_cnt+dbo.f_countweekdays(3, @preceivedt, @pchkdate)
		end
		if	@v_holiday_wed ='Y'
		begin
				set @v_d_cnt=@v_d_cnt+dbo.f_countweekdays(4, @preceivedt, @pchkdate)
		end
		if	@v_holiday_thu ='Y'
		begin
				set @v_d_cnt=@v_d_cnt+dbo.f_countweekdays(5, @preceivedt, @pchkdate)
		end
		if	@v_holiday_fri ='Y'
		begin
				set @v_d_cnt=@v_d_cnt+dbo.f_countweekdays(6, @preceivedt, @pchkdate)
		end
		if	@v_holiday_sat ='Y'
		begin
				set @v_d_cnt=@v_d_cnt+dbo.f_countweekdays(7, @preceivedt, @pchkdate)
		end
		set @v_output=isnull(@v_output,0) + isnull(@v_d_cnt,0)
end


	if @pflag = 'D'
	begin
		--@v_output -- contains permissable days allowed
		if @diff_days > @v_output
		begin
			set @v_value='You are not authorized to receive unsold more than '+ cast (@v_output as varchar) + ' days.'
		end
		else
		begin
			set @v_value='OK'		
		end
	end	
	else
	begin
		set @v_value='OK'
		
	end
-------	 
	return isnull(@v_value,0)

End 
	

/////////////////////////////////////////next


                                                                     
                                                                     
                                             
ALTER FUNCTION dbo.f_countweekdays (@day int, @fromdate datetime, @todate datetime)
RETURNS int
AS BEGIN

declare @StartDate as datetime
declare @EndDate as datetime
declare @Dow as int

set @StartDate=@fromdate
set @EndDate=@todate
set @Dow=@day

  RETURN (
    SELECT
      DATEDIFF(wk, DATEADD(DAY, -@@DATEFIRST % 7, @StartDate),
                   DATEADD(DAY, -@@DATEFIRST % 7, @EndDate))
      - CASE WHEN DATEPART(dw, @StartDate) > @Dow THEN 1 ELSE 0 END
      - CASE WHEN DATEPART(dw, @EndDate)   < @Dow THEN 1 ELSE 0 END
      + 1
  )
END
  
  
  
  
/////////////////////////////////////////////////end///////////////////////////////////////////////////////




///////////////////////////////add by Deepika 06/07/2012///////////////////////////////////////

ALTER procedure [dbo].[cir_late_factor_aglist]
    @pcompcode       as varchar(200),
    @punitcode       as varchar(200),
    @ppublcode       as varchar(200),
    @pissuedate      as datetime, 
    @platerate			 as numeric(14,2), 
    @puserid         as varchar(200), 
    @pdateformate    as varchar(200),
    @processby       as varchar(200),---- 1/branch , 2/route , 3/zone , 4/region , 5/district
    @pvar_sel		 as varchar(max),---- value in ['a','b','c','d'] format
    @pagcd			 as varchar(20),
    @pdpcd			 as varchar(20),
    @pagtype		 as varchar(20),
    @pagclass    	 as varchar(20),
    @psuptype		 as varchar(20),
    @preason 		 as varchar(20),
    @pextra1         as varchar(200),
    @pextra2         as varchar(200),
    @pextra3         as varchar(200),
    @pextra4         as varchar(200),
    @pextra5         as varchar(200)
as
    
begin

declare @v1_agcd as varchar(20)
declare @v1_dpcd as varchar(20)
declare @v1_branch_code as varchar(20)
declare @v1_ag_type as varchar(20)
declare @v1_ag_class as varchar(20)
declare @v1_ag_name as varchar(200)
declare @v1_station_code as varchar(20)
declare @v1_route_code as varchar(20)
declare @v1_billagcd as varchar(20)
create table #Results(SegmentNum INT, Edition_Name  VARCHAR(255))

insert into #Results select * from dbo.Fn_Splitfield(@pvar_sel,',')

    declare c1 cursor for
		select distinct a.agcd,a.dpcd,dbo.cir_get_agency(@pcompcode,@punitcode,a.BILL_AGCD,a.BILL_DPCD)as billagname,a.branch_code,a.ag_type,a.ag_class,a.ag_name,a.station_code,b.route_code 
		from cir_agmast a,cir_supply b
		where a.comp_code=@pcompcode 
		and a.comp_code=b.comp_code and a.agcd=b.agcd and a.dpcd=b.dpcd --and a.unit=b.unit
		and isnull(b.late_fee,'N')='Y'
		and (a.unit= @punitcode or @punitcode is null or @punitcode ='')    
		and (
			(@processby='1' and a.branch_code in (select Edition_Name from #Results) ) or
			(@processby='2' and b.route_code in (select Edition_Name from #Results)  ) or
			(@processby='3' and dbo.cir_get_zone_by_city(a.comp_code,a.city_code,'C') in (select Edition_Name from #Results) ) or
			(@processby='4' and dbo.cir_get_region_by_city(a.comp_code,a.city_code,'C') in (select Edition_Name from #Results) ) or
			(@processby='5' and a.dist_code   in (select Edition_Name from #Results) )
			)
		and (a.agcd=@pagcd or @pagcd is null or @pagcd ='')
		and (a.dpcd=@pdpcd or @pdpcd is null or @pdpcd ='')
		and (a.ag_type=@pagtype or @pagtype is null or @pagtype ='')
		and (a.ag_class=@pagclass or @pagclass is null or @pagclass ='')
		and (b.publ=@ppublcode or @ppublcode is null or @ppublcode='')
    


   CREATE TABLE #CIR_late_factor_fee
	(COMP_CODE       VARCHAR(100),
	UNIT_CODE        VARCHAR(100),	
	BRANCH_CODE      varchar(200),
	AGCD             VARCHAR(100),
	DPCD             VARCHAR(100),
	BILL_AGNAME        VARCHAR(100),
	AGNAME           VARCHAR(250),
	AG_TYPE          VARCHAR(20),
	AG_CLASS         VARCHAR(20),
	AG_DROP          VARCHAR(20),
	AG_ROUTE         VARCHAR(20),
	ISSUE_DAY        VARCHAR(20),	
	ISSUE_DT         DATETIME,
	SUPPLY_COPY      NUMERIC(10)                   DEFAULT 0,
	LATE_RATE        NUMERIC(15,2)                 DEFAULT 0,
	LATE_AMT         NUMERIC(15,2)                 DEFAULT 0,
	lateby			 varchar(5),
	dep_time		 varchar(5),
	act_dep_time     varchar(5)
	)

    
declare @vsecond as numeric(14)
declare @v_time_line as varchar(20)
declare @v_supply as numeric(14)
declare @v_day as varchar(20)
declare @v_dep_time as varchar(5)
declare @v_exp_dep as varchar(5)
declare @vtimediff as varchar(6)
set @v_day=CONVERT(VARCHAR(20) , DATENAME(WEEKDAY, @pissuedate),20)


open c1
        fetch NEXT FROM c1 INTO @v1_agcd,@v1_dpcd,@v1_billagcd,@v1_branch_code,@v1_ag_type,@v1_ag_class,@v1_ag_name,@v1_station_code,@v1_route_code
     
        WHILE (@@FETCH_STATUS = 0) 
		BEGIN
		print(@v1_route_code)
		print(@pissuedate)
		
		select @v_time_line=isnull(time_line,'00:00') from cir_route_mast where comp_code=@pcompcode 
		and unit=@punitcode and route_code=@v1_route_code
			
		select distinct @v_exp_dep=EXP_DEP_TIME,@v_dep_time=DEP_TIME, @vtimediff=replace(DBO.time_diff(dep_time, exp_dep_time),'S','') from CIR_ROUTE_TAXI_MAST
		where comp_code=@pcompcode and (unit_code=@punitcode or @punitcode is null or @punitcode='')
		and route_code=	@v1_route_code and dep_date= @pissuedate
		
		print(@v_time_line)	
		print(@v_exp_dep)	
		print(@v_dep_time)
		print(@vtimediff)
		print('22222222222')
		print(@v_day)
		if @v_day='Sunday' Begin 
		   select distinct @v_supply=sum(isnull(base_supply,0))+sum(isnull(supply_sun,0)) from cir_supply 
		   where comp_code=@pcompcode and (unit=@punitcode or @punitcode is null or @punitcode='')
		   and agcd=@v1_agcd and dpcd=@v1_dpcd 
		   and (publ=@ppublcode or @ppublcode is null or @ppublcode ='')
		   and (publ=@psuptype or @psuptype is null or @psuptype ='')
		   
		End    
		Else if @v_day='Monday' Begin
			select distinct @v_supply=sum(isnull(base_supply,0))+sum(isnull(supply_mon,0)) from cir_supply 
		   where comp_code=@pcompcode and (unit=@punitcode or @punitcode is null or @punitcode='')
		   and agcd=@v1_agcd and dpcd=@v1_dpcd 
		   and (publ=@ppublcode or @ppublcode is null or @ppublcode ='')
		   and (publ=@psuptype or @psuptype is null or @psuptype ='')
		End    
		Else if @v_day='Tuesday' Begin
			select distinct @v_supply=sum(isnull(base_supply,0))+sum(isnull(supply_tue,0)) from cir_supply 
		   where comp_code=@pcompcode and (unit=@punitcode or @punitcode is null or @punitcode='')
		   and agcd=@v1_agcd and dpcd=@v1_dpcd 
		   and (publ=@ppublcode or @ppublcode is null or @ppublcode ='')
		   and (publ=@psuptype or @psuptype is null or @psuptype ='')
		End 
		Else If @v_day='Wednesday' Begin
			select distinct @v_supply=sum(isnull(base_supply,0))+sum(isnull(supply_wed,0)) from cir_supply 
		   where comp_code=@pcompcode and (unit=@punitcode or @punitcode is null or @punitcode='')
		   and agcd=@v1_agcd and dpcd=@v1_dpcd 
		   and (publ=@ppublcode or @ppublcode is null or @ppublcode ='')
		   and (publ=@psuptype or @psuptype is null or @psuptype ='')
		End    
		Else If @v_day='Thursday' Begin
			select distinct @v_supply=sum(isnull(base_supply,0))+sum(isnull(supply_thu,0)) from cir_supply 
		   where comp_code=@pcompcode and (unit=@punitcode or @punitcode is null or @punitcode='')
		   and agcd=@v1_agcd and dpcd=@v1_dpcd 
		   and (publ=@ppublcode or @ppublcode is null or @ppublcode ='')
		   and (publ=@psuptype or @psuptype is null or @psuptype ='')
		End    
		Else if @v_day='Friday' Begin
			select distinct @v_supply=sum(isnull(base_supply,0))+sum(isnull(supply_fri,0)) from cir_supply 
		   where comp_code=@pcompcode and (unit=@punitcode or @punitcode is null or @punitcode='')
		   and agcd=@v1_agcd and dpcd=@v1_dpcd 
		   and (publ=@ppublcode or @ppublcode is null or @ppublcode ='')
		   and (publ=@psuptype or @psuptype is null or @psuptype ='')
		End
		Else Begin
			select distinct @v_supply=sum(isnull(base_supply,0))+sum(isnull(supply_sat,0)) from cir_supply 
		   where comp_code=@pcompcode and (unit=@punitcode or @punitcode is null or @punitcode='')
		   and agcd=@v1_agcd and dpcd=@v1_dpcd 
		   and (publ=@ppublcode or @ppublcode is null or @ppublcode ='')
		   and (publ=@psuptype or @psuptype is null or @psuptype ='')
		End
		set @vsecond=datediff(ss,@v_exp_dep,@v_time_line )	
		
		print('debug')

		print(@v_supply)
		print('3434')
		print(@vsecond)
		print('end')
		
		if @vsecond >0 begin
			insert into #CIR_late_factor_fee
				(COMP_CODE, UNIT_CODE, BRANCH_CODE,AGCD, DPCD,BILL_AGNAME, AGNAME,AG_TYPE,AG_CLASS, 
			AG_DROP,AG_ROUTE,ISSUE_DAY,ISSUE_DT,SUPPLY_COPY,LATE_RATE,LATE_AMT,lateby,dep_time,act_dep_time)
			values(@pcompcode,@punitcode,@v1_branch_code,@v1_agcd,@v1_dpcd,@v1_billagcd,@v1_ag_name,@v1_ag_type,@v1_ag_class,
			@v1_station_code,@v1_route_code,upper(@v_day),@pissuedate,@v_supply,@platerate,isnull(@v_supply,0)*isnull(@platerate,0)
			,@vtimediff,@v_dep_time,@v_exp_dep)
		end
			
        fetch NEXT FROM c1 INTO @v1_agcd,@v1_dpcd,@v1_billagcd,@v1_branch_code,@v1_ag_type,@v1_ag_class,@v1_ag_name,@v1_station_code,@v1_route_code
    end
    close c1;
    deallocate c1
           
select COMP_CODE, UNIT_CODE,--dbo.cir_get_unit_name(COMP_CODE,UNIT_CODE) as UNIT, 
BRANCH_CODE,dbo.cir_get_branch(COMP_CODE,BRANCH_CODE) BRANCH ,
AGCD, DPCD,BILL_AGNAME, AGNAME,AG_TYPE,AG_CLASS, 
AG_DROP,AG_ROUTE,dbo.cir_get_route_name(COMP_CODE,UNIT_CODE,AG_ROUTE) ROUTE
,ISSUE_DAY,ISSUE_DT,SUPPLY_COPY,LATE_RATE,LATE_AMT,lateby 
,dep_time,act_dep_time,dbo.cir_get_drop_point_name(COMP_CODE,UNIT_CODE,AG_DROP,'1') AG_DROP_NAME
from #CIR_late_factor_fee x
where x.comp_code+x.AGCD+x.DPCD--+CAST(ISSUE_DT as varchar) 
not in
(select t.comp_code+t.AGCD+t.DPCD from cir_late_factor_fee_process t --+CAST(ISSUE_DT as varchar)
where t.comp_code=@pcompcode and t.docno is not null and t.docdt is not null and t.flag='Y' )


drop table #CIR_late_factor_fee
drop table #Results
End



//////////////////////////////////////////////next


ALTER procedure [dbo].[cir_trans_cn_to_security_cir_rcpdet_bind]
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
    
    select  *,dbo.cir_get_agency(comp_code,unit_code,agcd,dpcd)as AGENCY_NAME from cir_rcphdr
    where comp_code=@pcompcode and unit_code=isnull(@punitcode,unit_code)
        and agcd=@pagcd or @pagcd=null or @pagcd='' and dpcd=@pdpcd or @pdpcd=null or @pdpcd=''
        and recptdt between @v_frdt and @v_todt and 
        reason=@preason and doctype=@pdroctyp and achd='NM' and isnull(trf_note_type,'N')<>'Y'

end       
//////////////////////////////////////////end/////////////////////////////////////////////////////////

////////////////////////////add by Deepika 06/07/2012///////////////////////////////////////



                                                                     
                                                                     
                                             
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

CREATE TABLE #CIR_TEMP_OUTSTANDING
(
  COMP_CODE        VARCHAR(8),
  UNIT_CODE        VARCHAR(8),
  DT               DATETIME,
  PUBL_CODE        VARCHAR(8),
  AGCD             VARCHAR(8),
  DPCD             VARCHAR(8),
  BILL_AMT         numeric(15,2)                 DEFAULT 0,
  RETURN_AMT       numeric(15,2)                 DEFAULT 0,
  DN_AMT           numeric(15,2)                 DEFAULT 0,
  CN_AMT           numeric(15,2)                 DEFAULT 0,
  REC_AMT          numeric(15,2)                 DEFAULT 0,
  AGNAME           VARCHAR(200),
  AGNAME_OTH_LANG  VARCHAR(250),
  CITY_CODE        VARCHAR(20),
  TALUKA_CODE      VARCHAR(20),
  DIST_CODE        VARCHAR(20),
  STATE_CODE       VARCHAR(20),
  COUNTRY_CODE     VARCHAR(20),
  OP_AMT           numeric(15,2),
  BRANCH_CODE      VARCHAR(8),
  AGENCY_COMM      VARCHAR(8)
)

 declare  @v_ason    as     datetime;
 declare  @v_opdate  as   datetime;
 declare  @v_opbal   as    numeric(15,2)
 declare  @v_clbal   as    numeric(15,2)
 declare  @v_billamt as   numeric(15,2)
 declare  @v_dbcramt as   numeric(15,2)
 declare  @v_diff    as    numeric(15,2)



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
--declare @v1_datefield as varchar(50)


 
declare @v1_comm_code as varchar(50)

declare c1 cursor for

select distinct a.comp_code,a.unit,a.agcd,a.dpcd,a.ag_name,a.ag_name_oth_lang,a.city_code,
a.tehsil_taluka,
a.dist_code,a.state_code,
a.country_code,c.comm_catg_desc comm_catg_desc 
from cir_agmast a,cir_supply s,CIR_COMM_CATG_MAST c
where a.comp_code=@pcomp_code and (a.unit=@punit_code or @punit_code is null or @punit_code ='') and 
(a.ag_type=@pagtype or @pagtype is null) 
/*and a.agcd+a.dpcd in(select distinct agcd+dpcd from cir_outmast 
where comp_code=@pcomp_code and (unit_code=@punit_code or @punit_code is null) 
and achd='NM')*/
and c.comp_code=a.comp_code
and c.comp_code=s.comp_code
and c.comm_catg_code=s.comm_code
and a.comp_code=s.comp_code
and a.unit=s.unit
and a.agcd=s.agcd
and a.dpcd=s.dpcd

--set @v1_datefield =@pason_date;

--where datefield >= dateadd(yy,datediff(yy,0,getdate())-1,0)
--and datefield <dateadd(mm,datediff(mm,0,getdate())+1,0)
--)
set @v_ason=@pason_date
set @v_opdate    =dbo.cir_get_finandt(@pcomp_code,@v_ason,@pdateformat,'','');--for financial date
print(@v_ason)
print(@v_opdate)

print('a')
	open c1			
	fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit,@v1_agcd,@v1_dpcd,@v1_ag_name,@v1_ag_name_oth_lang,	@v1_city_code,@v1_tehsil_taluka,@v1_dist_code,@v1_state_code,@v1_country_code,@v1_comm_code
	WHILE (@@FETCH_STATUS = 0) 
	BEGIN 
	print('s')
	print(@v1_agcd)
	print(@v1_dpcd)
		/*select  @v_billamt =sum(amount)  from cir_outmast
		where comp_code=@pcomp_code and (unit_code=@punit_code or @punit_code is null or @punit_code ='')
		and agcd=@v1_agcd and dpcd=@v1_dpcd and billdt >= @v_opdate and billdt<=@v_ason 
		and  achd='NM' and (recptno is null or RECPTNO=''); 
		
		select  @v_dbcramt= sum(amount)   from cir_rcphdr
		where comp_code=@pcomp_code and (unit_code=@punit_code or @punit_code is null or @punit_code ='')
		and agcd=@v1_agcd and dpcd=@v1_dpcd 
		and recptdt>= @v_opdate and recptdt<=@v_ason and 
		achd='NM';
		
		set @v_clbal=isnull(@v_opbal,0)+isnull(@v_billamt,0)+isnull(@v_dbcramt,0);*/
		set @v_opbal        =dbo.cir_accounts_cir_agency_opbal(@pcomp_code,@punit_code,'',@v1_agcd,@v1_dpcd,@v_opdate,'NM',@pdateformat,@pextra1,@pextra2);

            select @v_billamt=sum(amount) from cir_outmast
                where comp_code=@pcomp_code and (unit_code=@punit_code or @punit_code is null or @punit_code='') and 
                            agcd=@v1_agcd and dpcd=@v1_dpcd and billdt >= @v_opdate and billdt<=@v_ason and 
                            achd='NM' and( recptno is null or RECPTNO='');
            
            select @v_dbcramt=sum(amount)  from cir_rcphdr
                where comp_code=@pcomp_code and (unit_code=@punit_code or @punit_code is null or @punit_code='') and 
                            agcd=@v1_agcd and dpcd=@v1_dpcd and recptdt>= @v_opdate and recptdt<=@v_ason and 
                            achd='NM';
            
            set @v_clbal=isnull(@v_opbal,0)+isnull(@v_billamt,0)+isnull(@v_dbcramt,0);
		set @v_billamt=0;
		set @v_dbcramt=0;
		
		select  @v_dbcramt= sum(bill_amount)  from cir_bill ----previous bill amount
		where comp_code=@pcomp_code and (unit_code=@punit_code or @punit_code is null or @punit_code ='')	
		and billdt between DATEADD(mm,-1,@v_ason) and dbo.GetLastDayOfMonth(DATEADD(mm,-1,@v_ason))
		and  agcd=@v1_agcd and dpcd=@v1_dpcd;

		select @v_billamt= sum(bill_amount)   from cir_bill--------current bill amount 
		where comp_code=@pcomp_code and (unit_code=@punit_code or @punit_code is null or @punit_code ='') and
		billdt=dbo.GetLastDayOfMonth ( @v_ason) 
		and agcd=@v1_agcd  and dpcd=@v1_dpcd;
print('start')
print(@v_clbal)
print(@v_billamt)
print(@v_dbcramt)
print('end')
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

			insert into #CIR_TEMP_OUTSTANDING(comp_code,unit_code,dt,publ_code,agcd,dpcd,op_amt,bill_amt,dn_amt,cn_amt,
			agname,agname_oth_lang,city_code,taluka_code,dist_code,state_code,country_code,AGENCY_COMM)
			values(@v1_comp_code,@v1_unit,@v_ason,'',@v1_agcd,@v1_dpcd,@v_clbal,@v_billamt,@v_dbcramt,@v_diff,
			@v1_ag_name,@v1_ag_name_oth_lang,@v1_city_code,@v1_tehsil_taluka,@v1_dist_code,@v1_state_code,@v1_country_code,@v1_comm_code);
		end 
		set @v_billamt=0;
		set @v_dbcramt=0;
		set @v_opbal=0;
		set @v_clbal=0;
		set @v_diff=0;
	fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit,@v1_agcd,@v1_dpcd,@v1_ag_name,@v1_ag_name_oth_lang,@v1_city_code,@v1_tehsil_taluka,@v1_dist_code,@v1_state_code,@v1_country_code,@v1_comm_code
	End
	close c1
deallocate c1


select comp_code,unit_code,dt,publ_code,agcd,dpcd,agname,agname_oth_lang,
op_amt as outstanding_amt,bill_amt as curr_billamt,dn_amt as prev_billamt,cn_amt as diff_amt,
city_code,dbo.cir_get_city(comp_code,city_code) city_name,taluka_code,dbo.cir_get_taluka(comp_code,taluka_code) taluka_name,
dist_code,dbo.cir_get_dist(comp_code,state_code,dist_code) dist_name, state_code,country_code,AGENCY_COMM
from #CIR_TEMP_OUTSTANDING where comp_code=@pcomp_code and (unit_code=@punit_code or @punit_code is null or @punit_code ='')
order by comp_code,unit_code,city_name,agname

drop table #CIR_TEMP_OUTSTANDING

/////////////////////////////////////////////////////////END//////////////////////////////////////////////////////////