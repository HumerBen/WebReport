create database WebReport

use WebReport
create table dbo.BrokerApplicationInstance
(
ID int identity(1,1) primary key,
ApplicationName varchar(255),
MachineName varchar(255),
SessionKey varchar(255),
UserName varchar(255),
GetTime datetime
)

use WebReport
select * from dbo.BrokerApplicationInstance

use WebReport
drop table dbo.BrokerApplicationInstance


use WebReport
create table dbo.BrokerSession
(
ID int identity(1,1) primary key,
AppState varchar(255),
ApplicationsInUse varchar(255),
ConnectedViaHostName varchar(255),
ConnectedViaIP varchar(255),
DesktopGroupName varchar(255),
MachineName varchar(255),
SessionKey varchar(255),
SessionState varchar(255),
UserFullName varchar(255),
UserName varchar(255),
GetTime datetime
)

use WebReport
select * from dbo.BrokerSession

use WebReport
drop table dbo.BrokerSession