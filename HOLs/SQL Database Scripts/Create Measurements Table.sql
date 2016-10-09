-- Drop the dbo.Measurement table if it exists 
if exists(select object_id from sys.objects where type='U' and name = 'Measurement')
  drop table dbo.measurement;
go
-- Create the dbo.Measurement TABLE
-- this will store all the measurements received from iot hub
create table dbo.Measurement
(
    MeasurementID int IDENTITY(1,1) not null
      constraint PK_Measurement_MeasurementID 
      primary key CLUSTERED,
    deviceID nvarchar(15) not null
      constraint DF_Measurement_deviceID
      default '',
    [timestamp] datetime  null,
    temperature float(53) 
);
go
-- Query the table to ensure it EXISTS
-- the table was just created so there shouldn't
-- be any rows in it
select * from dbo.Measurement;
go
-- Drop the dbo.RecentMeasurements view if it exists 
if exists(select object_id from sys.objects where type='V' and name = 'RecentMeasurements')
  drop view dbo.RecentMeasurements;
go
-- Create the dbo.RecentMeasurements view
-- this return all recent (last 20) readings
create view dbo.RecentMeasurements as
select top 20
  deviceid,
  [timestamp],
  temperature 
from dbo.Measurement 
order by [timestamp] desc;
go
-- Query the view to make sure it works
select * from dbo.RecentMeasurements;
go
-- Drop the dbo.LastMeasurements view if it exists 
if exists(select object_id from sys.objects where type='V' and name = 'LastMeasurements')
  drop view dbo.LastMeasurements;
go
-- Create the dbo.LastMeasurements view
-- this return just the last measurement for each device
create view dbo.LastMeasurements as
select
  latest.deviceid,
  latest.[timestamp],
  latest.temperature
from measurement as latest
left join measurement as allrows
on latest.deviceid = allrows.deviceid and latest.measurementid < allrows.measurementid
where allrows.measurementid is null;
go
-- Query the view to make sure it works
select * from dbo.LastMeasurements;
go

select top 20 * from dbo.Measurement order by [timestamp] desc;
select count(*) from dbo.Measurement
select deviceid, timestamp, temperature from dbo.Measurement group by deviceid desc;


--select 
--  getdate() as Now,
--  dateadd(hh,1,getdate()) as InAnHour;

--insert into dbo.measurement
--select
--  'Basement' as deviceid,
--  dateadd(hh,-1,[timestamp]) as [timestamp],
--  temperature - 1 as temperature
--from dbo.Measurement
  



go
--truncate table dbo.Measurement;
