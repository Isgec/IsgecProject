/////////////// issue 6403 //// Reason Master/////////// for four row add in table/////////////// 

alter table cir_reason_mst add [DOC_TYPE] numeric(3)
alter table cir_reason_mst add [CHQ_RETURN_FLAG] numeric(1)
alter table cir_reason_mst add [NO_OF_TIMES] numeric(5,0)
alter table cir_reason_mst add VALID_DAYS numeric(5,0)

/////////////////////// end of    /////////////////////////////////////////
///////////issue 6403////procedure//////////////////Reason Master///////////

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




ALTER PROCEDURE [dbo].[Cir_Dynamic_DML_variable_insert_stmt]
	@ptable_name                              VARCHAR(8000) ,
	@pcolname                                 VARCHAR(8000) ,
	@pcolvalue                                VARCHAR(8000) ,
	@pdelimiter                               VARCHAR(8000) ,
	@pdateformat                              VARCHAR(8000) ,
	@pextra1                                  VARCHAR(8000) ,
	@pextra2                                  VARCHAR(8000) 
AS
    	DECLARE @pstmt_str                                VARCHAR(8000) 
		DECLARE @v_sess_id                                FLOAT 
		DECLARE @rec_stmt								  VARCHAR(8000)		
		DECLARE @vlength                                  NUMERIC(5) 
		DECLARE @vcolval                                  VARCHAR(8000) 
		DECLARE @vrunval                                  VARCHAR(1) 
		DECLARE @vcol_name                                VARCHAR(8000) 
		DECLARE @vno                                      NUMERIC(5) 
		DECLARE @vrec                                     VARCHAR(8000) 
		DECLARE @vrec_upd                                 VARCHAR(8000) 
		DECLARE @vformat                                  VARCHAR(20) 
		DECLARE @v_col_exists                             NUMERIC(5) 
        DECLARE	 @COL_DATA_TYPE1						  VARCHAR(8000) 
        DECLARE	 @COL_VALUE1							  VARCHAR(8000) 
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




////////////////////////end of issue 6403////////////////////////////////////

/////////////////////22 FEB 2012 UPDATE TABLE CIR_TAXI_ROUTE////////////////////////////
alter table CIR_TAXI_ROUTE add LATITUDE varchar(10)

alter table CIR_TAXI_ROUTE add LONGITUDE varchar(10)

/////////////////////////////END OF 22 FEB 2012///////////////////////////////////