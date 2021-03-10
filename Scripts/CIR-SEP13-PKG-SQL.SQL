//================ADD BY DEEPIKA 09/10/2013=========================


                                              
                                             
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
	@pper_copy_wt		numeric(15,3),
	@pbranchcode        varchar(20),
	@pextra3            varchar(20),
	@pextra4            varchar(20)
AS 
DECLARE  @vsup_date   DATETIME
DECLARE  @vh_date1    DATETIME
DECLARE  @vh_name1    VARCHAR(500)
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

/************add by ***/
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
/************add by ***/
DECLARE  @vbill_dpcd1			VARCHAR(500)
DECLARE  @v_supply_copy_dt		varchar(20)
DECLARE  @v_unsold_copies       numeric(10)
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
DECLARE @v_freq_day  		NUMERIC(7)

   
/*********************       SEND CONVERTED DATE FROM SQL CLASS     ************/
-- vsup_date:=to_date(psup_date,''''||pdateformat||'''');
SET  @vsup_date = @psup_date

/*******************************************************************************/
DECLARE cur_holiday cursor  LOCAL FOR 
		select h_date,h_name from cir_holiday_mast
			where comp_code=@pcomp_code and unit=@punit_code and 
				h_publ=@ppubl_code and h_date=@vsup_date and 
				ISNULL(freeze_flag,'N')='N';
				
open cur_holiday;
fetch NEXT FROM cur_holiday into @vh_date1 , @vh_name1
close cur_holiday
    
if (@vsup_date=@vh_date1) BEGIN
	PRINT('Please Check The  Holiday Today Is  '+' '+   @vh_name1)
	PRINT('Please Check The  Holiday Today Is  '+' '+   @vh_name1)
end 
Begin
    select @v_freq_day=count(*) from cir_edition_issue_date 
	    WHERE COMP_CODE    = @pcomp_code 
		  AND PUB_CODE     = @ppubl_code 
		  --AND EDITION_CODE = @vedtn1 
		  AND FIRST_ISSUE=SUBSTRING(UPPER(datename(dw,@vsup_date)),1,3)
		  AND Frequency_code IN (SELECT PERIOD FROM CIR_PUBL_MAST 
		                            WHERE COMP_CODE=@pcomp_code 
									  AND PUBL=@ppubl_code)
          
End  

if (((@vsup_date<>@vh_date1) or (@vh_date1 is null)) and (isnull(@v_freq_day,0)>0)) BEGIN


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
print('@vedtn1')print(@vedtn1)
print('newad')
		DECLARE  cur_supply cursor LOCAL FOR 
		select a.unit unit,a.agcd agcd,a.dpcd dpcd,a.publ publ,a.edtn edtn,a.supply_type_code supply_type_code,a.base_supply base_supply,a.supply_sun supply_sun,
		a.supply_mon supply_mon,a.supply_tue supply_tue,a.supply_wed supply_wed,
		a.supply_thu supply_thu,a.supply_fri supply_fri,a.supply_sat supply_sat,a.supply_spl1 supply_spl1,
		a.supply_spl2 supply_spl2
/************add by ***/
, a.sp_supply_mon1 sp_supply_mon1,a.sp_supply_tue1 sp_supply_tue1,a.sp_supply_wed1 sp_supply_wed1,a.sp_supply_thu1 sp_supply_thu1,
a.sp_supply_fri1 sp_supply_fri1,a.sp_supply_sat1 sp_supply_sat1,a.sp_supply_sun1 sp_supply_sun1,a.sp_supply_mon2 sp_supply_mon2,
a.sp_supply_tue2 sp_supply_tue2,a.sp_supply_wed2 sp_supply_wed2,a.sp_supply_thu2 sp_supply_thu2,a.sp_supply_fri2 sp_supply_fri2,
a.sp_supply_sat2 sp_supply_sat2,a.sp_supply_sun2 sp_supply_sun2
/************add by ***/


, b.ag_type ag_type,b.supply_start_dt    supply_start_dt,b.suspend_date suspend_date, ISNULL(a.packet_size,0) packet_size,
		a.comm_code comm_code,a.comm_flag comm_flag,b.bill_agcd bill_agcd,b.bill_dpcd bill_dpcd,
		a.route_code route_code,a.subroute_code subroute_code,a.sub_subroute_code sub_subroute_code,
		a.surch_cd surch_cd,a.waste_catg_code waste_catg_code
		from cir_supply a,cir_agmast b
		where a.comp_code=b.comp_code and a.unit=b.unit and 
				  a.agcd=b.agcd and a.dpcd=b.dpcd and (a.agcd=@pagcd or @pagcd is null or @pagcd='') 
				  and (a.dpcd=@pdpcd or @pdpcd is null OR @pdpcd='') and 
				  a.unit=@punit_code and (a.publ=@ppubl_code) and
				  (b.branch_code=@pbranchcode or @pbranchcode is null or @pbranchcode='') and
				  a.edtn=@vedtn1 and
				  ISNULL(a.supply_flag,'N')='Y' and ISNULL(b.suspend,'N')='N'
		order by a.agcd,a.dpcd,a.edtn,a.supply_type_code;







		 open cur_supply 

		 fetch next from cur_supply into @vunit1 ,@vagcd1 ,@vdpcd1 ,@vpubl1 ,@vedtn11 ,@vsupply_type_code1,@vbase_supply1,
		 @vsupply_sun1 ,@vsupply_mon1 ,@vsupply_tue1 ,@vsupply_wed1 ,@vsupply_thu1 ,@vsupply_fri1,@vsupply_sat1 ,@vsupply_spl11,
		 @vsupply_spl21,

/************add by ***/
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
/************add by ***/

@vag_type1 ,@vsupply_start_dt1, @vsuspend_date1 ,@vpacket_size1 ,@vcomm_code1 ,@vcomm_flag1 ,@vbill_agcd1 ,@vbill_dpcd1,
		 @vroute_code1 ,@vsubroute_code1 ,@vsub_subroute_code1 ,@vsurch_cd1 ,@vwaste_catg_code
	       
   print('Q')      
		SET @vsup_date= CONVERT(VARCHAR(10),@vsup_date,10)
                 
		WHILE @@FETCH_STATUS = 0 begin
			
			DECLARE @SUP_DAY112    varchar(20)
 
            SET  @SUP_DAY112 = CONVERT(VARCHAR(20) , DATENAME(WEEKDAY, @vsup_date),20)
print(@vsup_date)
	print('@psup_ty') print(@psup_ty) print(@vsup_date) print(@vsupply_start_dt1)	print(@vsuspend_date1) print('@vsuspend_date1')	
			if (@vsup_date>=@vsupply_start_dt1 or @vsupply_start_dt1 is null) --and (@vsup_date<=@vsuspend_date1 or @vsuspend_date1 is null) 
			begin 
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
/***********************add by ****************************/

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

/*****************add by ************************************************/

			--------change for supply copy--------
print('@psup_ty') print(@psup_ty)	print(@v_supply_copy_dt) print('W')				           
            if @psup_ty='R' and @v_supply_copy_dt is not null begin
                set @v_old_sup_copy=0;
                select @v_old_sup_copy = sum(sup_copy) from cir_dbksup 
				   where comp_code     = @pcomp_code 
				     and unit_code     = @punit_code 
					 and publ          = @ppubl_code 
					 and edtn          = @vedtn11 
					 and agcd          = @vagcd1 
					 and dpcd          = @vdpcd1 
					 and supdate       = @v_supply_copy_dt 
					 and sup_type_code = @vsupply_type_code1;
   
            end
			if @psup_ty='R' and @v_supply_copy_dt is not null 
			   begin
			      set  @v_unsold_copies = 0
				   select @v_unsold_copies = CAST((floor(sum(isnull(short_recpt,0)+isnull(late_recpt,0)+isnull(bnr,0)+isnull(unsold,0))/2)) AS NUMERIC) from CIR_UNSOLD_DTL 
						where comp_code = @pcomp_code 
						and unit_code   = @punit_code
						and doctype     = 'UCN'
						and publ          = @ppubl_code 
					    and edtn          = @vedtn11 
						and agcd        = @vagcd1 
						and dpcd        = @vdpcd1 
						and supdate     = @v_supply_copy_dt;
               end
			   PRINT '@v_unsold_copies'
			   PRINT @v_unsold_copies
			   PRINT @v_old_sup_copy
            if isnull(@v_old_sup_copy,0)>0 begin
                set @v_sup_copy=isnull(@v_old_sup_copy,0)-isnull(@v_unsold_copies,0);
            end
           
            --------change for supply copy--------

/*******************add for sponsership agency********************/
declare @v_cnt				int
declare @v_consum_copy		int
declare @v_remaining_copy	int
declare @v_SPONS_COPY		int
declare @v_SPONS_COPY_RATE	numeric(12,2)
declare @v_SPONS_LIMIT_AMT	numeric(15,2)
declare @v_SPONS_AMT		numeric(15,2)
declare @v_spons_st_date	datetime
declare @v_spons_end_date	datetime
declare @v_consum_rate  	numeric(15,2)
declare @v_rate_amt numeric(15,2)
select @v_cnt= count(*) from cir_spons_det a 
where comp_code=@pcomp_code and unit_code=@punit_code
and spons_agcd=@vagcd1 and spons_dpcd=@vdpcd1
and @vsup_date between spons_st_date and spons_end_date
and publ=@ppubl_code and edtn=@vedtn11 and sup_ty_code=@vsupply_type_code1

if ISNULL(@v_cnt,0)>0 begin

select @v_SPONS_COPY=SPONS_COPY,@v_SPONS_COPY_RATE = SPONS_COPY_RATE,@v_SPONS_LIMIT_AMT=SPONS_LIMIT_AMT,
@v_SPONS_AMT=SPONS_AMT,@v_spons_st_date=spons_st_date, @v_spons_end_date=spons_end_date  from cir_spons_det a 
where comp_code=@pcomp_code and unit_code=@punit_code
and spons_agcd=@vagcd1 and spons_dpcd=@vdpcd1
and @vsup_date between spons_st_date and spons_end_date
and publ=@ppubl_code and edtn=@vedtn11 and sup_ty_code=@vsupply_type_code1

select @v_consum_copy= SUM(sup_copy),@v_consum_rate= SUM(sup_rate) from cir_dbksup
where comp_code=@pcomp_code and unit_code=@punit_code and publ=@ppubl_code and edtn=@vedtn11 and
	agcd=@vagcd1 and dpcd=@vdpcd1 and supdate between @v_spons_st_date and @v_spons_end_date and 
	sup_type_code=@vsupply_type_code1;


	set @v_remaining_copy=isnull(@v_SPONS_COPY,0)-ISNULL(@v_consum_copy,0)   
			if @v_remaining_copy<ISNULL(@v_sup_copy,0) begin		
				set @v_sup_copy=@v_remaining_copy
			end

set @v_rate_amt=isnull(@v_SPONS_COPY_RATE,0)*ISNULL(@v_consum_copy,0)
		if @v_rate_amt<(ISNULL(@v_sup_copy,0)*ISNULL(@v_edtn_rate,0)) begin	
          SET @v_edtn_rate=@v_SPONS_COPY_RATE
		 end
end
/*******************add for sponsership agency********************/
     /*** FOR SINGLE AGENCY SUPPLY POSTING ***/
	 IF @pextra3 = '' BEGIN SET @pextra3 = '0' END
	 IF @pextra3 = NULL BEGIN SET @pextra3 = '0' END
	 IF CAST(REPLACE(ISNULL(@pextra3,'0'),'','0') AS NUMERIC(10))>0 
	    BEGIN
		   SET @v_sup_copy = CAST(@pextra3 AS NUMERIC(10))
		END
     /*** FOR SINGLE AGENCY SUPPLY POSTING ***/
	print('Z44444444') print(@v_sup_copy)				            
			if ISNULL(@v_sup_copy,0)>0 Begin
				
				insert into cir_dbksup (comp_code,unit_code,publ,edtn,agcd,dpcd,supdate,sup_type_code,sup_copy,agency_ty_code,
										agency_pkt_size,comm_code,comm_fix_auto_spl,sup_rate,billagcd,billdpcd,
										route_code,subroute_code,subsubroute_code,userid,surch_cd,issue_date,per_copy_weight,
                                        waste_catg_code)
								values (@pcomp_code,@punit_code,@ppubl_code,@vedtn11,@vagcd1,@vdpcd1,@vsup_date,
									 @vsupply_type_code1,
									 @v_sup_copy,@vag_type1,@vpacket_size1,@vcomm_code1,@vcomm_flag1,
									 @v_edtn_rate,@vbill_agcd1,@vbill_dpcd1,@vroute_code1,
									 @vsubroute_code1,@vsub_subroute_code1,@puserid,@vsurch_cd1,@pextra2,@pper_copy_wt,
                                     isnull(@vwaste_catg_code,0));

				select @vreccnt	= count(*)  from cir_dbksup where comp_code=@pcomp_code and unit_code=@punit_code 
				and publ=@ppubl_code and edtn=@vedtn1 and supdate=@vsup_date and (agcd=@pagcd or @pagcd is null) and (dpcd=@pdpcd or @pdpcd is null);
				print('cdcd')
					               
			End;                     
		end 
    

         fetch next from cur_supply into @vunit1 ,@vagcd1 ,@vdpcd1 ,@vpubl1 ,@vedtn11 ,@vsupply_type_code1,@vbase_supply1,
		 @vsupply_sun1 ,@vsupply_mon1 ,@vsupply_tue1 ,@vsupply_wed1 ,@vsupply_thu1 ,@vsupply_fri1,@vsupply_sat1 ,@vsupply_spl11,
		 @vsupply_spl21, 
/************add by ***/
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
/************add by ***/
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



*****************************************

USE [THENIBERP]
GO
/****** Object:  StoredProcedure [dbo].[cir_update_supply]    Script Date: 9/11/2013 12:21:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER procedure [dbo].[cir_update_supply] (@pcomp_code     as varchar(50),
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

	/* if(isnull(@check_type,'')='SUPPLYUPDATE')
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
	     
		END */
			
  End
  
  
  /////////////////////////////////////END////////////////////////////

///==============add by Deepika 12-sep-2013///////////////////



                                                                     
                                                                     
                                                                     
                                             
ALTER procedure CIR_RECEIPT_DATA_MOVE
    @pcompcode       as varchar(200),
    @punitcode       as varchar(200),
    @pdoctype        as varchar(200),
    @precptdt        as varchar(200),
    @precptno        as varchar(200),
    @pdateformate    as varchar(200),
    @puserid         as varchar(200),
    @prectype        as varchar(200),--it is for agency receipt or distraibution receipt
    @pextra1         as varchar(200), -- It is using for prefix suffix in receipt no generation
    @pextra2         as varchar(200), 
    @pextra3         as varchar(200),-- It is using for branch code  in receipt no generation
    @pextra4         as varchar(200),
    @pextra5         as varchar(200)
as
	declare @v_recno1  numeric(10)
	DECLARE @vrecptno  VARCHAR(15)
	DECLARE @v_prefix  VARCHAR(8)
	DECLARE @vno       NUMERIC(20) 
	declare @v_dt      datetime
begin

	BEGIN TRANSACTION;	
		BEGIN TRY 
    
					set @v_dt=dbo.convert_user_date('/', @precptdt,@pdateformate)
				    
					if upper(@prectype)='D' 
					Begin
						---- for receipt No Generation -------
							SELECT @vno  =  CONVERT(NUMERIC(8, 2), MAX(SUBSTRING(recptno, charindex('-',recptno)+1, 8))) + 1
							FROM  cir_rcphdr_dis WHERE     comp_code  = @pcompcode AND    doctype  = @pdoctype
							 and replace(substring(CONVERT(VARCHAR(10), recptdt,2),1,5),'.','') = replace(substring(CONVERT(VARCHAR(10), @v_dt,2),1,5),'.','')
							 AND branch_code  = @pextra3
							
							if(@pextra1 is not null and @pextra1 !='' ) 
							begin							
								set @v_prefix=@pextra1
							end	
							else
							begin
								set @v_prefix=@pextra3+'-';
							end
							 
							IF ISNULL(@vno, 0)= 0 
							BEGIN 
									SET @vrecptno  = @v_prefix + '-' + REPLACE(CONVERT(VARCHAR(5), @v_dt, 2), '.', '')+ '0001' 
							END
							ELSE 
							BEGIN 
								SET @vrecptno  = @v_prefix + '-' + dbo.fnPadLeft('0',8,@vno) 
							END
						---- for receipt No Generation -------
				    
						insert into cir_rcphdr_dis(comp_code,unit_code,doctype,agcd,dpcd,recptno,
							recptdt,chno,chdt,chbank,amount,oth_amount,ccdp,ccds,rcdp,rcds,ocdp,ocds,reason,
							remark,achd,voucherno,voucherdt,vchtype,publ,received_from,tdsrate,tdsamt,staxrate,
							  staxamt,status,ref_recptno,ref_recptdt,ref_amount,ref_doctype,cancel_user,cancel_datetime,
							  cancel_remark,userid,creation_datetime,branch_code,prov_rec_no,prov_rec_dt,remark_oth,MANNUALRECPTNO)
						  select comp_code,unit_code,doctype,agcd,dpcd,@vrecptno,
						  recptdt,chno,
						  CASE chdt WHEN '1900-01-01 00:00:00.000' THEN NULL else chdt END chdt,
						  chbank,amount,oth_amount,ccdp,ccds,rcdp,rcds,ocdp,ocds,reason,
						  remark,achd,voucherno,voucherdt,vchtype,publ,received_from,tdsrate,tdsamt,staxrate,
						  staxamt,status,ref_recptno,
						  CASE ref_recptdt WHEN '1900-01-01 00:00:00.000' THEN NULL else ref_recptdt END ref_recptdt,
						  ref_amount,ref_doctype,cancel_user,cancel_date,
						  cancel_remark,userid,creation_date,branch_code,prov_rec_no,
						  CASE prov_rec_dt WHEN '1900-01-01 00:00:00.000' THEN NULL else prov_rec_dt END prov_rec_dt,
						  remark_oth,MANNUALRECPTNO from cir_rcphdr_dis_temp
							where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
									recptno=@precptno and recptdt=@v_dt
				      
					  delete from CIR_RCPHDR_DIS_TEMP where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
									recptno=@precptno and recptdt=@v_dt
				      
						  insert into cir_rcpdet_dis(comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, recptno, recptdt, 
											payfor, achd, publ, chno, chbnk, chdt, amount, reason, remark, voucherno, voucherdt, 
											tds, stax, status, usrid, creation_datetime, branch_code)
						  select comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, @vrecptno, recptdt, 
											payfor, achd, publ, chno, chbnk, 
											CASE chdt WHEN '1900-01-01 00:00:00.000' THEN NULL else chdt END chdt, 
											amount, reason, remark, voucherno, voucherdt, 
											tds, stax, status, usrid, creation_date, branch_code from cir_rcpdet_dis_temp
							where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and 
									recptno=@precptno and recptdt=@v_dt

						delete from cir_rcpdet_dis_temp
							where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and 
									recptno=@precptno and recptdt=@v_dt

						insert into cir_outmast_dis (comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, recptno, recptdt, 
										achd, publ, chno, chbnk, chdt, amount, reason, remark, voucherno, voucherdt, balance, 
										tds, stax, status, cancel_userid, cancel_dt, cancel_remark, usrid, creation_datetime, bill_sec_amt, branch_code)
						select comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, @vrecptno, recptdt, 
										achd, publ, chno, chbnk, 
										CASE chdt WHEN '1900-01-01 00:00:00.000' THEN NULL else chdt END chdt, 
										amount, reason, remark, voucherno, voucherdt, balance, 
										tds, stax, status, cancel_userid, cancel_dt, cancel_remark, usrid, creation_date, bill_sec_amt, branch_code from cir_outmast_dis_temp
							 where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and 
									recptno=@precptno and recptdt=@v_dt
						
						 delete from cir_outmast_dis_temp
							 where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and 
									recptno=@precptno and recptdt=@v_dt
						
							select @v_recno1=count(*) from cir_rcpt_document_dis_temp
							where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
										recptno=@precptno and recptdt=@v_dt
							If @v_recno1>0 Begin		                    
								insert into cir_rcpt_document_dis(comp_code, unit_code, doctype, recptno, recptdt, filename, created_by, created_dt)
								select comp_code, unit_code, doctype, @vrecptno, recptdt, filename, created_by, created_dt from cir_rcpt_document_dis_temp
								where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
											recptno=@precptno and recptdt=@v_dt
							End

							
							insert into cir_rcp_unadj_dis(comp_code,unit_code,agcd,dpcd,doctyp,recptno,recptdt,publ,amount,created_by,created_date,updated_by,updated_date)
							select comp_code,unit_code,agcd,dpcd,doctyp,@vrecptno,recptdt,publ,amount,created_by,created_date,updated_by,updated_date from cir_rcp_unadj_temp_dis
							where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and recptno=@precptno
							
							delete from cir_rcp_unadj_temp_dis
							where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and recptno=@precptno
							
						End
					else 
					Begin
						---- for receipt No Generation -------
							SELECT @vno  =  CAST( MAX(SUBSTRING(recptno, charindex('-',recptno)+1, 8))AS NUMERIC) + 1--CONVERT(NUMERIC(8, 2), MAX(SUBSTRING(recptno, 5, 8))) + 1
							FROM  cir_rcphdr WHERE comp_code  = @pcompcode AND doctype  = @pdoctype
							and replace(substring(CONVERT(VARCHAR(10), recptdt,2),1,5),'.','') = replace(substring(CONVERT(VARCHAR(10), @v_dt,2),1,5),'.','')
							AND  branch_code  = @pextra3
							 
							IF ISNULL(@vno, 0)= 0 
							BEGIN 
									SET @vrecptno  = @pextra3 + '-' + REPLACE(CONVERT(VARCHAR(5), @v_dt, 2), '.', '')+ '0001' 
							END
							ELSE 
							BEGIN 
								SET @vrecptno  = @pextra3 + '-' + dbo.fnPadLeft('0',8,@vno) 
							END
						---- for receipt No Generation -------    
				    
				    
						insert into cir_rcphdr(comp_code,unit_code,doctype,agcd,dpcd,recptno,
							recptdt,chno,chdt,chbank,amount,oth_amount,ccdp,ccds,rcdp,rcds,ocdp,ocds,reason,
							remark,achd,voucherno,voucherdt,vchtype,publ,received_from,tdsrate,tdsamt,staxrate,
							  staxamt,status,ref_recptno,
							  ref_recptdt,
							  ref_amount,ref_doctype,cancel_user,cancel_date,
							  cancel_remark,userid,creation_date,branch_code,prov_rec_no,prov_rec_dt,remark_oth,MANNUALRECPTNO,SCH_OPT,R_ID,ref_docno,ref_docty)
						  select comp_code,unit_code,doctype,agcd,dpcd,@vrecptno,
						  recptdt,chno,
						  CASE chdt WHEN '1900-01-01 00:00:00.000' THEN NULL else chdt END chdt,
						  chbank,amount,oth_amount,ccdp,ccds,rcdp,rcds,ocdp,ocds,reason,
						  remark,achd,voucherno,voucherdt,vchtype,publ,received_from,tdsrate,tdsamt,staxrate,
						  staxamt,status,ref_recptno,
						  CASE ref_recptdt WHEN '1900-01-01 00:00:00.000' THEN NULL else ref_recptdt END  ref_recptdt,
						  ref_amount,ref_doctype,cancel_user,cancel_date,
						  cancel_remark,userid,creation_date,branch_code,prov_rec_no,
						  CASE prov_rec_dt WHEN '1900-01-01 00:00:00.000' THEN NULL else prov_rec_dt END prov_rec_dt,remark_oth,MANNUALRECPTNO,SCH_OPT,R_ID,ref_docno,ref_docty from cir_rcphdr_temp
							where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
									recptno=@precptno and recptdt=@v_dt
				      
						  insert into cir_rcpdet(comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, recptno, recptdt, 
											payfor, achd, publ, chno, chbnk, chdt, amount, reason, remark, voucherno, voucherdt, 
											tds, stax, status, usrid, creation_date, branch_code,SCH_OPT,R_ID,ref_docno,ref_docty)
						  select comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, @vrecptno, recptdt, 
											payfor, achd, publ, chno, chbnk, 
											CASE chdt WHEN '1900-01-01 00:00:00.000' THEN NULL else chdt END chdt, 
											amount, reason, remark, voucherno, voucherdt, 
											tds, stax, status, usrid, creation_date, branch_code,SCH_OPT,R_ID,ref_docno,ref_docty from cir_rcpdet_temp
							where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and 
									recptno=@precptno and recptdt=@v_dt

						insert into cir_outmast (comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, recptno, recptdt, 
										achd, publ, chno, chbnk, chdt, amount, reason, remark, voucherno, voucherdt, balance, 
										tds, stax, status, cancel_userid, cancel_dt, cancel_remark, usrid, creation_date, bill_sec_amt, branch_code,SCH_OPT,R_ID,ref_docno,ref_docty)
						select comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, @vrecptno, recptdt, 
										achd, publ, chno, chbnk, 
										CASE chdt WHEN '1900-01-01 00:00:00.000' THEN NULL else chdt END chdt, 
										amount, reason, remark, voucherno, voucherdt, balance, 
										tds, stax, status, cancel_userid, cancel_dt, cancel_remark, usrid, creation_date, bill_sec_amt, branch_code ,SCH_OPT,R_ID,ref_docno,ref_docty from cir_outmast_temp
							 where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and 
									recptno=@precptno and recptdt=@v_dt
					
						insert into cir_rcpt_document(comp_code, unit_code, doctype, recptno, recptdt, filename, created_by, created_dt)
						select comp_code, unit_code, doctype, @vrecptno, recptdt, filename, created_by, created_dt from cir_rcpt_document_temp
						where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
     					recptno=@precptno and recptdt=@v_dt
						
						insert into cir_rcp_unadj(comp_code,unit_code,agcd,dpcd,doctyp,recptno,recptdt,publ,amount,created_by,created_date,updated_by,updated_date)
						select comp_code,unit_code,agcd,dpcd,doctyp,@vrecptno,recptdt,publ,amount,created_by,created_date,updated_by,updated_date from cir_rcp_unadj_temp
						where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and recptno=@precptno
						
						delete from cir_rcphdr_temp where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
						recptno=@precptno and recptdt=@v_dt
						    
						delete from cir_rcpdet_temp
						where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and 
						recptno=@precptno and recptdt=@v_dt

						delete from cir_outmast_temp
						where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and 
						recptno=@precptno and recptdt=@v_dt

						delete from cir_rcpt_document_temp
						where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
						recptno=@precptno and recptdt=@v_dt

						delete from cir_rcp_unadj_temp
						where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and recptno=@precptno
					
					end           
				    
				-----  this part starts from here for blocking agency for debit note-----------------
					declare @v_doctype_BU as varchar(10) -- rcpt_hdr table 
					declare @v_reason_BU as varchar(10) -- rcpt_hdr table 
					declare @v_agcd_BU as varchar(10) -- rcpt_hdr table 
					declare @v_dpcd_BU as varchar(10) -- rcpt_hdr table 
					declare @v_nooftimes_BU as int  -- reason_mast	
					declare @v_noofdays_BU as int  -- reason_mast
					declare @v_NO_OF_CHQbnc_pref as int  -- preference table
					declare @v_CIR_DAYS_CHQ_pref as int  -- preference table
					
					declare @v_cnt_specific_reason as int	
					declare @vod_payment as varchar(3)	
					declare @no_of_days_pref as int-- for preferrence / anniversary date
					
					set @vod_payment='N'
					set @no_of_days_pref=365
					
					select @v_doctype_BU = DOCTYPE,@v_agcd_BU=agcd,@v_dpcd_BU=DPCD from cir_rcphdr where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
					recptno=@precptno and recptdt=@v_dt
					
					if @v_doctype_BU ='DN' begin	
						
						select @v_reason_BU = REASON from cir_rcphdr where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
						recptno=@precptno and recptdt=@v_dt
						select @v_nooftimes_BU=isnull(no_of_times,0),@v_noofdays_BU=isnull(VALID_DAYS,0) from CIR_REASON_MST where REASON_CODE=@v_reason_BU and DOC_TYPE='DN'
						select @v_NO_OF_CHQbnc_pref=isnull(CIR_NO_OF_CHQBOUNCE,0),@v_CIR_DAYS_CHQ_pref=isnull(CIR_DAYS_CHQBOUNCE,0) from preferrences where comp_code=@pcompcode
						
						if @v_nooftimes_BU ='' 
						begin
							set @v_nooftimes_BU=0
						end	
						if @v_noofdays_BU ='' 
						begin
							set @v_noofdays_BU=0
						end
						if @v_NO_OF_CHQbnc_pref ='' 
						begin
							set @v_NO_OF_CHQbnc_pref=0
						end
						if @v_CIR_DAYS_CHQ_pref ='' 
						begin
							set @v_CIR_DAYS_CHQ_pref=0
						end
						----------------- in case of immediate effect of any reason to suspend the agency---------------
						select @v_cnt_specific_reason=count(*) from cir_rcphdr where comp_code=@pcompcode 
						and unit_code=@punitcode and doctype=@pdoctype and REASON=@v_reason_BU and
						recptno=@precptno and recptdt between dateadd(dd,-1*@v_noofdays_BU,@v_dt) and @v_dt
						
						if @v_nooftimes_BU =0 or @vod_payment='Y' -- 0 for stop payment and over due payment
						begin
									
							update cir_agmast set SUSPEND='Y',SUSPEND_DATE=GETDATE(),SUSPEND_TYPE='CH0' where COMP_CODE=@pcompcode 
							and AGCD=@v_agcd_BU and DPCD=@v_dpcd_BU			
							update CIR_AGENCY_PAYMODE set PAYMODE_ACTIVE='N',BLOCK_BY_A_M=null,UPDATED_DT = getdate()  where COMP_CODE=@pcompcode and AGCD=@v_agcd_BU and DPCD=@v_dpcd_BU
							and PAYMODE='CH0'
						end
						else if @v_nooftimes_BU < ISNULL(@v_cnt_specific_reason,0) or @vod_payment='Y' -- 0 for stop payment and over due payment
						begin
										
							update cir_agmast set SUSPEND='Y',SUSPEND_DATE=GETDATE(),SUSPEND_TYPE='CH0' where COMP_CODE=@pcompcode 
							and AGCD=@v_agcd_BU and DPCD=@v_dpcd_BU			
							update CIR_AGENCY_PAYMODE set PAYMODE_ACTIVE='N',BLOCK_BY_A_M=null,UPDATED_DT = getdate()  where COMP_CODE=@pcompcode and AGCD=@v_agcd_BU and DPCD=@v_dpcd_BU
							and PAYMODE='CH0'
						end
						-------------  end here ------------------------
						declare @v_cnt_specific_period as int
						----------------- in case of cheque bounce specific times in specic period block chq payments only for tht period---------------
						select @v_cnt_specific_period=count(*) from cir_rcphdr where comp_code=@pcompcode 
						and unit_code=@punitcode and doctype=@pdoctype and
						recptno=@precptno and recptdt between dateadd(dd,-1*@v_CIR_DAYS_CHQ_pref,@v_dt) and @v_dt
						
						if @v_NO_OF_CHQbnc_pref < ISNULL(@v_cnt_specific_period,0) 
						begin
										
							update CIR_AGENCY_PAYMODE set PAYMODE_ACTIVE='N',BLOCK_BY_A_M='A',UPDATED_DT = getdate() where COMP_CODE=@pcompcode and AGCD=@v_agcd_BU and DPCD=@v_dpcd_BU
							and PAYMODE='CH0'
						end
						---------------  end here -----------------------
					end
				       
				-----  this part ends here for blocking agency for debit note  ----------------------


				-----  this part starts from here for cheque dishonoured  debit note reverse entry-----------------       

				declare @v_refrecnum as varchar(20)
				declare @v_refrecdt  as datetime 
				declare @v_refrecamt  as numeric(14,2)
				declare @vrefdoctype as varchar(20)
				declare @v_doctype as varchar(20)
				declare @v_reason as varchar(20)

				declare @rec_count as int
				declare @rec_count1 as int
				declare @vag_main_code as varchar(30)
				declare @vag_sub_code as varchar(30)
				declare @vunit as varchar(30)
				declare @rec_amount as numeric(14,2)
				declare @rem_amount as numeric(14,2)


				/******************************  parameters for cursor*******************************/
				declare @c1_branch			as varchar(20)
				declare @c1_billno			as varchar(50)
				declare @c1_billdt			as datetime
				declare @c1_amount			as float
				declare @c1_unit			as varchar(20)
				declare @c1_agcode			as varchar(30)
				declare @c1_doctype			as varchar(20)
				declare @c1_reason			as varchar(20)
				declare @c1_recptno			as varchar(50)
				declare @c1_recptdt			as datetime
				declare @c1_chno			as varchar(30)
				declare @c1_chdt			as datetime
				declare @c1_bank			as varchar(20)
				declare @c1_voucherno		as varchar(30)
				declare @c1_voucherdate		as datetime
				declare @c1_comp_code		as varchar(20)
				declare @c1_userid			as varchar(20)
				declare @c1_pripub			as varchar(20)
				declare @c1_tds				as float
				declare @c1_received_region as varchar(30)
				declare @c1_stax				as float
				declare @c1_ag_main_code	as varchar(20)
				declare @c1_ag_sub_code		as varchar(30)
				declare @c1_remark			as varchar(200)
				declare @v_print_center as varchar(8)

				select @v_refrecnum= REF_RECPTNO, @v_refrecdt=REF_RECPTDT,@v_refrecamt=AMOUNT,@v_doctype=DOCTYPE,@v_reason=REASON,
				@vag_main_code=AGCD ,@vag_sub_code=DPCD,@vunit=UNIT_CODE,@vrefdoctype=REF_DOCTYPE
				from CIR_RCPHDR where COMP_CODE=@pcompcode and RECPTNO=@precptno and RECPTDT=@v_dt and DOCTYPE='DN'
				print('***')
				print(@precptno)print(@v_dt)print(@v_refrecamt)print(@v_doctype)print(@v_reason)print(@v_refrecnum)print(@v_refrecdt)
				print('start')
				if isnull(@v_refrecamt,0)>0 and @v_doctype ='DN' and  @v_reason='CH0' and @v_refrecnum is not null and @v_refrecdt is not null 
				begin
						select @rec_count=count(*) from cir_rcphdr where comp_code=@pcompcode and UNIT_CODE=@vunit  and recptno=@v_refrecnum and
						AGCD=@vag_main_code and DPCD=@vag_sub_code and amount<>0
						
						print(@vunit)print(@vrefdoctype)print(@v_refrecnum)print(@vag_sub_code)print(@vag_main_code)
				        
						select @rec_count1=count(*) from CIR_OUTMAST where comp_code=@pcompcode and UNIT_CODE=@vunit and doctyp=@vrefdoctype and recptno=@v_refrecnum and
						agcd=@vag_main_code and DPCD=@vag_sub_code and billno is not null and amount<>0
						print('start_1')		
						if isnull(@rec_count,0)>0
						begin
							print('start_2')
							print(@vunit)print(@vrefdoctype)print(@v_refrecnum)print(@vag_sub_code)print(@vag_main_code)
							
							select @rec_amount=abs(amount) from cir_rcphdr where comp_code=@pcompcode and UNIT_CODE=@vunit and recptno=@v_refrecnum and
							agcd=@vag_main_code and dpcd=@vag_sub_code and amount<>0
							
							declare c1 cursor for
								select branch_code,billno,billdt,amount,unit_code,'',doctyp,reason,recptno,recptdt							
								,chno,chdt,chbnk,voucherno,voucherdt,comp_code,usrid,publ,tds						
								,'',stax,agcd,dpcd,remark from cir_outmast
								where comp_code=@pcompcode and unit_code=@vunit and recptno=@v_refrecnum and
								agcd=@vag_main_code and dpcd=@vag_sub_code AND DOCTYP !='DN'--and amount<>0 
								order by recptdt,recptno,billdt,billno
							
							if @rec_amount=@v_refrecamt 
							begin --3
								set @rem_amount=@v_refrecamt
								print('start_3')
								OPEN c1 
								fetch NEXT FROM c1 INTO	@c1_branch,@c1_billno,@c1_billdt,@c1_amount,@c1_unit,@c1_agcode,@c1_doctype,@c1_reason,@c1_recptno,@c1_recptdt,@c1_chno,@c1_chdt,@c1_bank,@c1_voucherno,@c1_voucherdate,@c1_comp_code,@c1_userid,@c1_pripub,@c1_tds,@c1_received_region,@c1_stax,@c1_ag_main_code,@c1_ag_sub_code,@c1_remark
								WHILE (@@FETCH_STATUS = 0) 
								BEGIN
									 --set @vbillamt=abs(@c1_amount)
									 print('start_4')
									 if @c1_billno is not null and @c1_billdt is not null 
									 begin --4
									 print('start_5')print(@c1_billno)print(@c1_billdt)print('AAA')
										delete from CIR_OUTMAST where comp_code=@c1_comp_code and unit_code=@c1_unit 
										and agcd=@c1_ag_main_code and dpcd=@c1_ag_sub_code and BILLNO=@c1_billno and BILLDT=@c1_billdt and RECPTNO is not null
										and RECPTNO=@v_refrecnum					
										delete from CIR_RCPDET where comp_code=@c1_comp_code and unit_code=@c1_unit 
										and agcd=@c1_ag_main_code and dpcd=@c1_ag_sub_code and BILLNO=@c1_billno and BILLDT=@c1_billdt and RECPTNO is not null					
										and RECPTNO=@v_refrecnum
									 end
									 else --if abs(@c1_amount)=ABS(@v_refrecamt) --4
									 begin
										/*---if ref recipt amount in hand greater than zero amount---*/
										print('start_6')
										insert into cir_outmast (UNIT_CODE,doctyp,reason , BRANCH_CODE , billno , billdt , recptno , recptdt ,
																 chno , chdt , chbnk , voucherno , voucherdt , amount , comp_code , USRID ,
																 publ , tds , stax,agcd,dpcd,remark)
														  values(@c1_unit,'RCR',@c1_reason,@c1_branch,@precptno,@v_dt,@c1_recptno,@c1_recptdt,
																 @c1_chno , @c1_chdt ,@c1_bank,@c1_voucherno,@c1_voucherdate,-1*@v_refrecamt,@c1_comp_code,@c1_userid,
																 @c1_pripub,@c1_tds,@c1_stax,@c1_ag_main_code,@c1_ag_sub_code,@c1_remark)                                                 
				                        
										--update cir_outmast set amount=0 where comp_code=@c1_comp_code and unit_code=@c1_unit and recptno=@c1_recptno
										--and recptdt=@c1_recptdt and doctyp='RCR' and billno is null and billdt is null
				                        
										insert into cir_rcpdet(UNIT_CODE,doctyp,reason , BRANCH_CODE , billno , billdt , recptno , recptdt ,
																 chno , chdt , chbnk , voucherno , voucherdt , amount , comp_code , USRID ,
																 publ , tds , stax,agcd,dpcd,remark)
														  values(@c1_unit,'RCR',@c1_reason,@c1_branch,@precptno,@v_dt,@c1_recptno,@c1_recptdt,
																 @c1_chno , @c1_chdt ,@c1_bank,@c1_voucherno,@c1_voucherdate,-1*@v_refrecamt,@c1_comp_code,@c1_userid,
																 @c1_pripub,@c1_tds,@c1_stax,@c1_ag_main_code,@c1_ag_sub_code,@c1_remark)
										print('@v_refrecamt')print(@v_refrecamt)
										/*---if ref recipt amount in hand greater than zero amount---*/
									 end
									 
								
								fetch NEXT FROM c1 INTO	@c1_branch,@c1_billno,@c1_billdt,@c1_amount,@c1_unit,@c1_agcode,@c1_doctype,@c1_reason,@c1_recptno,@c1_recptdt,@c1_chno,@c1_chdt,@c1_bank,@c1_voucherno,@c1_voucherdate,@c1_comp_code,@c1_userid,@c1_pripub,@c1_tds,@c1_received_region,@c1_stax,@c1_ag_main_code,@c1_ag_sub_code,@c1_remark
								END
								close c1
								deallocate c1
								print('start_7')
				                
				                
							end
							print('start_8')
						end
					print('start_9')
				end



				-----  this part ends here for cheque dishonoured  debit note reverse entry -----------------
					if upper(@prectype)='D' Begin
						select @v_recno1=count(*) from cir_rcphdr_dis 
							where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
								recptno=@vrecptno
						End
					else Begin
						select @v_recno1=count(*) from cir_rcphdr 
							where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
								recptno=@vrecptno 
					End

					if isnull(@v_recno1,0)>0 Begin		
						select @vrecptno as "RECNO"
					End
					 else 
					 Begin
						select 0 as "RECNO"
					 End

	COMMIT TRANSACTION ;
	END TRY 
	BEGIN CATCH
		
		ROLLBACK TRANSACTION;
	-- Raise the error with the appropriate message and error severity
        DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int;
        SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY();
        --RAISERROR(@ErrMsg, @ErrSeverity, 1);
        
        if upper(@prectype)='D' 
		Begin
			delete from cir_rcphdr_dis_temp where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
			recptno=@precptno and recptdt=@v_dt

			delete from cir_rcpdet_dis_temp
			where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and 
			recptno=@precptno and recptdt=@v_dt

			delete from cir_outmast_dis_temp
			where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and 
			recptno=@precptno and recptdt=@v_dt

			delete from cir_rcpt_document_dis_temp
			where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
			recptno=@precptno and recptdt=@v_dt

			delete from cir_rcp_unadj_temp_dis
			where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and recptno=@precptno
		end
		else
		begin
			delete from cir_rcphdr_temp where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
			recptno=@precptno and recptdt=@v_dt

			delete from cir_rcpdet_temp
			where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and 
			recptno=@precptno and recptdt=@v_dt

			delete from cir_outmast_temp
			where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and 
			recptno=@precptno and recptdt=@v_dt

			delete from cir_rcpt_document_temp
			where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
			recptno=@precptno and recptdt=@v_dt

			delete from cir_rcp_unadj_temp
			where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and recptno=@precptno
		end	
		select 'There was an error while processing the data. The Transaction has been rolled back' as "RECNO"
		
		
    END CATCH;

end


////////////////////////////////////////////////////end///////////////////////////////////



/////////////////////add by Deepika 23-sep-2013////////////////////////////////


ALTER TABLE CIR_EDTN_MAST ADD VAT_REQ VARCHAR(1) DEFAULT 'N' 




                                                                     
                                                                     
                                                                     
                                             
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
	@pextra1           as varchar(50),--for damaged copies
	@pextra2           as varchar(50)--for unsold receipt date
AS 
Begin
	DECLARE @v_tot_copy			NUMERIC(10)
	DECLARE @v_waste_amt        FLOAT
	DECLARE @v_gross_amt        FLOAT
	DECLARE @v_comm_amt         FLOAT
	DECLARE @v_total_amt        FLOAT
       
	DECLARE @v_vat_allow		varchar(1);
	DECLARE @vbill_tax_on_gross varchar(1);
	DECLARE @v_tax_calc_type    varchar(1);
	DECLARE @v_tax_amt			FLOAT;
	DECLARE @v_tax_prate		FLOAT;   
	DECLARE @v_tax_frate		FLOAT; 
	declare @v_vat_edtn_allow	varchar(1);
	declare @rec_tax_tax_calc_type	varchar(20);
	declare @rec_tax_tax_rate	float
	DECLARE @v_rcpdt datetime;
	
Begin
	declare cur_tax cursor for
		select tax_rate,tax_calc_type from cir_tax_mast 
			where comp_code=@pcomp_code and tax_type_id=1 and tax_status='Y' and valid_from=(select max(valid_from) from cir_tax_mast
				where comp_code=@pcomp_code and tax_type_id=1 and tax_status='Y' and valid_from<=@v_rcpdt);
              
	set @v_vat_edtn_allow='N';
    
    select @v_vat_allow=cir_vat_allow, @vbill_tax_on_gross=cir_vat_on_gross from preferrences where "comp_code"=@pcomp_code;

        select @v_vat_edtn_allow = vat_req from cir_edtn_mast
            where comp_code=@pcomp_code and edtn = @pedtn_code;
    	
    if isnull(@v_vat_edtn_allow,'N')='Y'  begin
        if @v_vat_allow='Y' begin
            set @v_vat_allow	='Y';
        end
        else begin
            set @v_vat_allow ='N'
        End
    end
    else begin
        set @v_vat_allow	='N';
    End    
    
    --pcomp_code,punit_code,ppubl_code,pedtn_code this parameter future use
    if ISNULL(@pwaste_flag,'N')='Y' begin
        set @v_waste_amt =round((ISNULL(@punsold,0)*ISNULL(@pwaste_rate,0)),2);
    end
    else begin
        set @v_waste_amt=0;
    end
        
    set @v_tot_copy=ISNULL(@pmissing_recpt,0)+ISNULL(@plate_recpt,0)+ISNULL(@pbnr_recpt,0)+ISNULL(@punsold,0)+ISNULL(@pextra1,0);
    set @v_gross_amt =ISNULL(@v_tot_copy,0)*ISNULL(@pcopy_rate,0);

    if @pcomm_type='C' begin--for per copy rate
        set @v_comm_amt  =round((@v_tot_copy*ISNULL(@pcomm_per,0)),2);
    end
    else begin
        set @v_comm_amt  =round((@v_gross_amt*ISNULL(@pcomm_per,0)/100),2);
    end  
    set @v_total_amt =round((@v_gross_amt-@v_comm_amt-@v_waste_amt),2);   
         
    
----------------for tax amount--------------------------    
    if @v_vat_allow='Y' begin   
        if @vbill_tax_on_gross='Y' begin
            open cur_tax;
                fetch next from cur_tax into @rec_tax_tax_rate,@rec_tax_tax_calc_type;
				WHILE (@@FETCH_STATUS = 0) 
				BEGIN
					if @rec_tax_tax_calc_type='P' begin
						set @v_tax_amt		=ISNULL(@v_tax_amt,0)+round((ISNULL(@v_gross_amt,0)*ISNULL(@rec_tax_tax_rate,0))/100,2);
						set @v_tax_prate	=ISNULL(@v_tax_prate,0)+ISNULL(@rec_tax_tax_rate,0);
						set @v_tax_calc_type=@rec_tax_tax_calc_type;
					end
					else begin
						set @v_tax_amt		=ISNULL(@v_tax_amt,0)+round(ISNULL(@v_gross_amt,0)+ISNULL(@rec_tax_tax_rate,0),2);
						set @v_tax_frate	=ISNULL(@v_tax_frate,0)+ISNULL(@rec_tax_tax_rate,0);
						set @v_tax_calc_type=@rec_tax_tax_calc_type;
					end
				fetch next from cur_tax into @rec_tax_tax_rate,@rec_tax_tax_calc_type;
				end
            close cur_tax;
        end
        else begin
        
			open cur_tax;
			fetch next from cur_tax into @rec_tax_tax_rate,@rec_tax_tax_calc_type;
				WHILE (@@FETCH_STATUS = 0) 
				BEGIN
				if @rec_tax_tax_calc_type='P' begin
					set @v_tax_amt		=ISNULL(@v_tax_amt,0)+round((ISNULL(@v_total_amt,0)*ISNULL(@rec_tax_tax_rate,0))/100,2);
					set @v_tax_prate	=ISNULL(@v_tax_prate,0)+ISNULL(@rec_tax_tax_rate,0);
					set @v_tax_calc_type=@rec_tax_tax_calc_type;
				end
				else begin
					set @v_tax_amt		=ISNULL(@v_tax_amt,0)+round(ISNULL(@v_total_amt,0)+ISNULL(@rec_tax_tax_rate,0),2);
					set @v_tax_frate	=ISNULL(@v_tax_frate,0)+ISNULL(@rec_tax_tax_rate,0);
					set @v_tax_calc_type=@rec_tax_tax_calc_type;
				end
			fetch next from cur_tax into @rec_tax_tax_rate,@rec_tax_tax_calc_type;
			end
			close cur_tax;
        end 
    end
    else begin
        set @v_tax_amt   =0;
        set @v_tax_prate =0;
        set @v_tax_frate =0;        
    end
    end 
	deallocate cur_tax;
	
    set @v_total_amt =ISNULL(@v_total_amt,0)+ISNULL(@v_tax_amt,0);
        
	SELECT @v_tot_copy as "TOTAL_COPY" ,@v_waste_amt as "WASTE_AMOUNT" ,@v_comm_amt as "COMM_AMOUNT" ,@v_total_amt as "TOTAL_AMOUNT"  ,@v_tax_amt as "TAX_AMOUNT"

	--SET @v_query  = 'SELECT' + @v_tot_copy + 'as "TOTAL_COPY" ,' + @v_waste_amt + ' as "WASTE_AMOUNT" ,' + @v_comm_amt + ' as "COMM_AMOUNT" ,' + @v_total_amt + ' as "TOTAL_AMOUNT"' + ' FROM DUAL' 
	--PRINT (@v_query) 
    --EXEC (@v_query) 

End



/////////////////////////


                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE cir_unsold_credit_note_cir_unsold_check_p
    @pcomp_code				VARCHAR(20) ,
    @punit_code             VARCHAR(20) ,
    @ppubl_code             VARCHAR(20) ,
    @pedtn_code             VARCHAR(20) ,
    @psup_date              DATETIME  ,
    @pagcd_code             VARCHAR(20) ,
    @pdpcd_code             VARCHAR(20) ,
    @pdoc_type              VARCHAR(20) ,
    @precptno               VARCHAR(20) ,
    @pmissing_recpt         VARCHAR(20) ,
    @plate_recpt            VARCHAR(20) ,
    @pbnr_recpt             VARCHAR(20) ,
    @punsold                VARCHAR(20) ,
    @pcopy_rate             VARCHAR(20) ,
    @pcomm_per              VARCHAR(20) ,
    @pcomm_type             VARCHAR(20) ,
    @pwaste_flag            VARCHAR(20) ,
    @pwaste_rate            VARCHAR(20) ,
    @pdateformat            VARCHAR(20) ,
    @pextra1                VARCHAR(40) ,--for damaged copies
    @pextra2                VARCHAR(40)  --for Distribution
AS 
	DECLARE @v_supdt			DATETIME 
	DECLARE @v_tot_copy         INT 
	DECLARE @v_waste_amt        FLOAT 
	DECLARE @v_gross_amt        FLOAT 
	DECLARE @v_comm_amt         FLOAT 
	DECLARE @v_total_amt        FLOAT 
	DECLARE @v_query            VARCHAR(4000) 
    DECLARE @pvat_on_gross		VARCHAR(1);
    DECLARE @ptax_rate			FLOAT;
    DECLARE @ptax_type			VARCHAR(20);
    DECLARE @v_tax_amt			FLOAT;
    DECLARE @v_vat_allow		varchar(20)
    declare @v_vat_edtn_allow	varchar(20)
    
    set @v_vat_allow	='N';
    SET @v_supdt  = @psup_date
	
	select @v_vat_allow=cir_vat_allow, @pvat_on_gross= cir_vat_on_gross from preferrences where "comp_code"=@pcomp_code;
	
	select @v_vat_edtn_allow = VAT_REQ from cir_edtn_mast
		where comp_code = @pcomp_code and edtn = @pedtn_code;
	
	if isnull(@v_vat_edtn_allow,'N')='Y'  begin
		if @v_vat_allow='Y' begin
			set @v_vat_allow	='Y';
		end
		else begin
			set @v_vat_allow	='N';	
		End
	end
	else begin
		set @v_vat_allow	='N';
	End
	
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
	
	set @ptax_rate=0;
	set @ptax_type=null;
	set @v_tax_amt=0;
	if ISNULL(@v_vat_allow,'N') ='Y' begin
		if ISNULL(@pvat_on_gross,'N') ='Y' begin

			select @ptax_rate=tax_rate,@ptax_type=tax_calc_type from cir_tax_mast 
				where comp_code=@pcomp_code and tax_type_id=1 and tax_status='Y' and 
					valid_from=(select max(valid_from) from cir_tax_mast
				where comp_code=@pcomp_code and tax_type_id=1 and tax_status='Y' and valid_from<=getdate());
            
			print('@ptax_rate')print(@ptax_rate)print(@ptax_type);
           
            if @ptax_type='P' begin
                        
				set @v_tax_amt=round((ISNULL(@v_gross_amt,0)*ISNULL(@ptax_rate,0))/100,2);
                        
                print('@v_tax_amt')print(@v_tax_amt);
			end
            else if @ptax_type='F' begin
                        
				set @v_tax_amt=round(ISNULL(@v_gross_amt,0)+ISNULL(@ptax_rate,0),2);
            
            end   
			else begin
				set @v_tax_amt=0;
            end
                     
			if @pcomm_type='C' begin--for per copy rate
				set @v_comm_amt  =round(((@v_tot_copy)*ISNULL(@pcomm_per,0)),2);
			end
			else begin
				set @v_comm_amt  =round(((@v_gross_amt+@v_tax_amt)*ISNULL(@pcomm_per,0)/100),2);
                print('namancccc')print(@v_gross_amt)print(@v_tax_amt)print(@pcomm_per);
			end
                    
			set @v_total_amt =round((@v_gross_amt+@v_tax_amt-@v_comm_amt-@v_waste_amt),2);
        end
		else begin

			if @pcomm_type='C' begin--for per copy rate
				set @v_comm_amt  =round(((@v_tot_copy)*ISNULL(@pcomm_per,0)),2);
			end
			else begin
				set @v_comm_amt  =round(((@v_gross_amt)*ISNULL(@pcomm_per,0)/100),2);
                print('@v_gross_amt')print(@v_gross_amt)print(@v_tax_amt)print(@pcomm_per);
			end
                    
            set @v_total_amt =round((@v_gross_amt-@v_comm_amt-@v_waste_amt),2);
                    
			set @ptax_rate =0;
			set @ptax_type =null;
					
            select @ptax_rate=tax_rate, @ptax_type=tax_calc_type from cir_tax_mast 
            where comp_code=@pcomp_code and tax_type_id=1 and tax_status='Y' and 
            valid_from=(select max(valid_from) from cir_tax_mast
            where comp_code=@pcomp_code and tax_type_id=1 and tax_status='Y' and valid_from<=getdate());
            
            print('@ptax_rate')print(@ptax_rate)print(@ptax_type);
           
            if @ptax_type='P' begin
                set @v_tax_amt =round((ISNULL(@v_total_amt,0)*ISNULL(@ptax_rate,0))/100,2);
                print('@v_tax_amt')print(@v_tax_amt);
            end
            else if @ptax_type='F' begin
				set @v_tax_amt = round(ISNULL(@v_total_amt,0)+ISNULL(@ptax_rate,0),2); 
            end
            else begin
				set @v_tax_amt=0;
            end
                    
			set @v_total_amt =round((@v_gross_amt+@v_tax_amt-@v_comm_amt-@v_waste_amt),2);
                    
		END
	END
	ELSE BEGIN----for no vat calculation
		If (@pcomm_type='C') --for per copy rate
			Begin
				SET @v_comm_amt  =round((@v_tot_copy*ISNULL(CONVERT(FLOAT,@pcomm_per),0)),2);
			End
		Else Begin
			SET @v_comm_amt  = ROUND((CONVERT(FLOAT,@v_gross_amt) * ISNULL(CONVERT(FLOAT,@pcomm_per), 0) / CONVERT(FLOAT, 100)), 2)
		End

		SET @v_total_amt  = ROUND((CONVERT(FLOAT,@v_gross_amt) - CONVERT(FLOAT,@v_comm_amt) - CONVERT(FLOAT,@v_waste_amt)), 2)
	END
    SELECT @v_tot_copy as "TOTAL_COPY" ,@v_waste_amt as "WASTE_AMOUNT" ,@v_comm_amt as "COMM_AMOUNT" ,@v_total_amt as "TOTAL_AMOUNT"  ,@v_tax_amt as "TAX_AMOUNT"
    --SET @v_query  = 'SELECT' + ' ' +CONVERT(varchar(20),@v_tot_copy) + 'as "TOTAL_COPY" ,' +' '+ CONVERT(varchar(20),@v_waste_amt) +' '+ ' as "WASTE_AMOUNT" ,' +' '+ CONVERT(varchar(20),@v_comm_amt) +' '+ ' as "COMM_AMOUNT" ,' +' '+ CONVERT(varchar(20),@v_total_amt) + ' as "TOTAL_AMOUNT"' 
PRINT(@v_query)        

EXEC (@v_query) 



///////////////////////////////////////////////////////////end///////////////////////////////////////////