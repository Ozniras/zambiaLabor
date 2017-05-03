drop table if exists censuswardurbanlabor1564;
create table censuswardurbanlabor1564 as
select * from censuswardregionlabor1564
where region = 2;

copy censuswardurbanlabor1564 to '/home/ram22/dataDrive/dataProjects/postgresql/tempOutput/censuswardurbanlabor1564.csv' with csv header;

drop table if exists censuswardrurallabor1564;
create table censuswardrurallabor1564 as
select * from censuswardregionlabor1564
where region = 1;

copy censuswardrurallabor1564 to '/home/ram22/dataDrive/dataProjects/postgresql/tempOutput/censuswardrurallabor1564.csv' with csv header;

drop table if exists censuswardurbanlaborall1564;
drop table if exists censuswardrurallaborall1564;

