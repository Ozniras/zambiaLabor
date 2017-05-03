drop table if exists censuswardurbanlaborall1564;
create table censuswardurbanlaborall1564 as
select * from censuswardregionlaborall1564
where region = 2;

copy censuswardurbanlaborall to '/home/ram22/dataDrive/dataProjects/postgresql/tempOutput/censuswardurbanlaborall1564.csv' with csv header;

drop table if exists censuswardrurallaborall1564;
create table censuswardrurallaborall1564 as
select * from censuswardregionlaborall1564
where region = 1;

copy censuswardrurallaborall to '/home/ram22/dataDrive/dataProjects/postgresql/tempOutput/censuswardrurallaborall1564.csv' with csv header;

drop table if exists censuswardurbanlaborall;
drop table if exists censuswardrurallaborall;

