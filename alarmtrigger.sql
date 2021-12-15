create or alter trigger [dbo].[trigger_alert_invalid_value]on [dbo].[Measurement]
 after insert
 AS begin
 set nocount off; 
 declare 		
                @v_measurementId int,
				@v_alert_type nvarchar(250),
				@v_max int,
				@v_min int,
				@value bigint,
				@sensorId int
				
 set @v_alert_type ='VALUE_OUT_OF_RANGE'

 /*set @v_measurementId =  (select *from(select measurementId ,row_number() over(order by measurementId) as 'row'  from inserted )as temp where row=1)
 */
 set @v_measurementId =(select top 1 measurementId as temp from inserted)
 set @value = (select value from inserted where inserted.measurementId = @v_measurementId)
 set @sensorId = (select sensorId from inserted where inserted.measurementId = @v_measurementId)
 set @v_min = (select min_value from [dbo].[Sensor] where [dbo].[Sensor].sensorId = @sensorId)
 set @v_max = (select max_value from [dbo].[Sensor] where [dbo].[Sensor].sensorId = @sensorId)
 if @value not between @v_min and @v_max
 begin 
 insert into [dbo].[Alarm](alarmType, measurementId) 
 values(@v_alert_type, @v_measurementId) 
 end 





end

