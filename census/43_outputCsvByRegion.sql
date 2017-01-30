drop table if exists censuswardurbanlaborall;
create table censuswardurbanlaborall as
select * from censuswardregionlaborall
where region = 2;

copy censuswardurbanlaborall to '/home/ram22/dataDrive/dataProjects/povMap/zambiaLFSmapping/3_csvOutput/censuswardurbanlaborall.csv' with csv header;

drop table if exists censuswardrurallaborall;
create table censuswardrurallaborall as
select * from censuswardregionlaborall
where region = 1;

copy censuswardrurallaborall to '/home/ram22/dataDrive/dataProjects/povMap/zambiaLFSmapping/3_csvOutput/censuswardrurallaborall.csv' with csv header;

