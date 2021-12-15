create  table Location (
locationId int primary key identity not null,
locationName nvarchar(250) null);

create table MachineTable (
machineId int not null primary key identity,
machineName nvarchar (250) null, 
status bit null, 
locationId int FOREIGN KEY REFERENCES Location(locationId));

create table Sensor (
sensorId int not null primary key identity,
sensorName nvarchar(250) null, 
min_value int null, 
max_value int null,
unit nvarchar(10) null, 
machineId int FOREIGN KEY REFERENCES [dbo].[MachineTable](machineId));

create table Measurement(
measurementId int not null identity primary key,
value bigint null,
timestamp bigint null,
sensorId int FOREIGN KEY REFERENCES [dbo].[Sensor](sensorId));

create table Alarm (
alarmId int identity primary key not null,
alarmType nvarchar(250) null,
measurementId int FOREIGN KEY REFERENCES Measurement(measurementId)
);

create table UserTable(
userId int not null primary key identity,
email nvarchar (250) null,
locationId int  FOREIGN KEY REFERENCES  [dbo].[Location](locationId)
);

create table Comment (
commentId int not null identity primary key,
message nvarchar (250) null,
messageTimestamp bigint null,
userId int FOREIGN KEY REFERENCES UserTable(userId),
machineId int FOREIGN KEY REFERENCES MachineTable(machineId)
);



