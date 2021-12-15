/*drop trigger [dbo].[trigger_new_measurement1]*/
create or alter trigger [dbo].[trigger_new_measurement1]on [dbo].[StreamMeasurements]
 after insert
 AS begin
 set nocount on; 
 declare @v_hum_value bigint, @v_pres_value bigint,  @v_temp_value bigint,  @v_location nvarchar(250), @v_machineId nvarchar(250),  @v_timestamp bigint,  @v_locationId int, @v_hum_sensorId int, @v_pres_sensorId int, @v_temp_sensorId int, @v_new_machineId int 
 set @v_timestamp = (select top 1 t from inserted) 
 set @v_machineId = (select top 1 machine from inserted) 
 set @v_location = (select top 1 location from inserted) 
 set @v_hum_value = (select v from inserted where inserted.sensor ='Hum') 
 set @v_pres_value = (select v from inserted where inserted.sensor ='Pres') 
 set @v_temp_value = (select v from inserted where inserted.sensor ='Temp') 
 -- check if location already exists - if not; create new location record
 if exists (select [dbo].[Location].locationName from [dbo].[Location] 
 where [dbo].[Location].locationName = @v_location) 
 Begin
 print @v_location
 end
 else 
 begin 
 INSERT INTO [dbo].[Location](locationName) values(@v_location) 
 end
 -- check if machine already exists - if not; create new machine record
 if exists (select [dbo].[MachineTable].machineName from [dbo].[MachineTable] 
 where [dbo].[MachineTable].machineName = @v_machineId) 
Begin
 print @v_location
 end 
 else 
 begin 
 set @v_locationId = (select locationId from [dbo].[Location]
  where locationName = @v_location) 
  INSERT INTO [dbo].[MachineTable](machineName, locationId) 
  values(@v_machineId, @v_locationId)
  -- create 3 sensor records for machine ( Temperature, Humididty, Pressure) 
   set @v_new_machineId= (select machineId from [dbo].[MachineTable]
   where machineName = @v_machineId) 
  INSERT INTO [dbo].[Sensor](sensorName, min_value, max_value, unit,machineId) 
  values ('Temp', 200, 240, 'C',@v_new_machineId), ('Hum', 20, 65, '% HR',@v_new_machineId)
  , ('Pres', 700, 900, 'hPa',@v_new_machineId); 
  end
  -- populate measurements table with sensor measurements 
   set @v_new_machineId= (select machineId from [dbo].[MachineTable]
   where machineName = @v_machineId) 
   set @v_hum_sensorId = (select sensorId from [dbo].[Sensor] 
   where [dbo].[Sensor].machineId = @v_new_machineId and [dbo].[Sensor].sensorName = 'Hum') 
   set @v_temp_sensorId = (select sensorId from [dbo].[Sensor] 
   where [dbo].[Sensor].machineId = @v_new_machineId and [dbo].[Sensor].sensorName = 'Temp') 
   set @v_pres_sensorId = (select sensorId from [dbo].[Sensor] 
   where [dbo].[Sensor].machineId = @v_new_machineId and [dbo].[Sensor].sensorName = 'Pres')
   INSERT INTO [dbo].[Measurement](value, timestamp ,sensorId) 
	values (@v_hum_value, @v_timestamp, @v_hum_sensorId), (@v_pres_value, @v_timestamp, @v_pres_sensorId), (@v_temp_value, @v_timestamp, @v_temp_sensorId);
	end

