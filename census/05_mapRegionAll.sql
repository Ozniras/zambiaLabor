-- Totals for the population by region

drop table if exists thiscase;
create temporary table thiscase as
select *
from censuslabor
where p2_membership <= 2 and p5_age >= 15 and p5_age <= 64;

drop table if exists censuswardregioncounts;
create temporary table censuswardregioncounts as
select max(dist) as dist, max(const) as const, max(ward) as ward, max(region) as region,
  max(wardid) as wardid, wardregionid, count(wardregionid) as population1564
from censuslabor
where p2_membership <= 2 and p5_age >= 15 and p5_age <= 64
group by wardregionid;

drop table if exists censuswardregioncountsthiscase;
create temporary table censuswardregioncountsthiscase as
select wardregionid, count(wardregionid) as popthiscase
from thiscase
group by wardregionid;

drop table if exists censuswardregionlf7days;
create temporary table censuswardregionlf7days as
select wardregionid, count(wardregionid) as lf7days
from thiscase
where p31_activity_last_7_days >= 1 and p31_activity_last_7_days <= 7
group by wardregionid;

drop table if exists censuswardregionlf12months;
create temporary table censuswardregionlf12months as
select wardregionid, count(wardregionid) as lf12months
from thiscase
where p32_activity_last_12_months >= 1 and p32_activity_last_12_months <= 7
group by wardregionid;

drop table if exists censuswardregionempl7days;
create temporary table censuswardregionempl7days as
select wardregionid, count(wardregionid) as empl7days
from thiscase
where p31_activity_last_7_days >= 1 and p31_activity_last_7_days <= 6
group by wardregionid;

drop table if exists censuswardregionempl12months;
create temporary table censuswardregionempl12months as
select wardregionid, count(wardregionid) as empl12months
from thiscase
where p32_activity_last_12_months >= 1 and p32_activity_last_12_months <= 6
group by wardregionid;

drop table if exists censuswardregionunem7days;
create temporary table censuswardregionunem7days as
select wardregionid, count(wardregionid) as unem7days
from thiscase
where p31_activity_last_7_days = 7
group by wardregionid;

drop table if exists censuswardregionunem12months;
create temporary table censuswardregionunem12months as
select wardregionid, count(wardregionid) as unem12months
from thiscase
where p32_activity_last_12_months = 7
group by wardregionid;

drop table if exists censuswardregionLabor1564;
create table censuswardregionLabor1564 as
select dist, const, ward, region, wardid, wardregionid, population1564, popthiscase, 
 lf7days, lf12months, empl7days, empl12months, unem7days, unem12months
 from censuswardregioncounts full outer join censuswardregioncountsthiscase 
using(wardregionid)
full outer join censuswardregionlf7days 
using(wardregionid)
full outer join censuswardregionlf12months 
using(wardregionid)
full outer join censuswardregionempl7days
using(wardregionid)
full outer join censuswardregionempl12months
using(wardregionid)
full outer join censuswardregionunem7days
using(wardregionid)
full outer join censuswardregionunem12months
using(wardregionid)
;

drop table if exists censuswardregionLaborAll1564;

drop table if exists censuswardregionunem7days;
drop table if exists censuswardregionempl7days;
drop table if exists censuswardregionunem12months;
drop table if exists censuswardregionempl12months;
drop table if exists censuswardregionlf12months;
drop table if exists censuswardregionlf7days;
drop table if exists censuswardregioncounts12plus;
drop table if exists censuswardregioncounts;
drop table if exists thiscase;

