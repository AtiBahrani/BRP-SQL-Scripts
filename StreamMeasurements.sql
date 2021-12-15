create table StreamMeasurements(
id int  not null primary key identity,
location nvarchar (250) null,
machine nvarchar(250) null, 
sensor nvarchar(250) null,
v bigint null,
q bit null, 
t bigint null)

insert into dbo.StreamMeasurements(location,machine, sensor, v,q,t )
values('Vejle', 'Machine2', 'Temp', 150, 1, 1777272729)
insert into dbo.StreamMeasurements(location,machine, sensor, v,q,t )
values('Aarhus', 'Machine4', 'Temp', 135, 1, 1787272730),
('Aarhus', 'Machine4', 'Pres', 1020, 1, 1787272730),
('Aarhus', 'Machine4', 'Hum', 45, 1, 1787272730)