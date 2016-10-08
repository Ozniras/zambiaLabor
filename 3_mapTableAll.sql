-- Totals for the population

drop table if exists thiscase;
create temporary table this case
select *
from censuslabor
where p2_membership <= 2;

drop table if exists censuswardcounts;
create temporary table censuswardcounts as
select max(dist) as dist, max(const) as const, max(ward) as ward,
  wardid, count(wardid) as population
from thiscase
group by wardid;

drop table if exists censuswardcounts12plus;
create temporary table censuswardcounts12plus as
select wardid, count(wardid) as age12plus
from thiscase
where p5_age >= 12
group by wardid;

drop table if exists censuswardlf7days;
create temporary table censuswardlf7days as
select wardid, count(wardid) as lf7days
from thiscase
where p5_age >= 12 and p31_activity_last_7_days >= 1 and p31_activity_last_7_days <= 7
group by wardid;

drop table if exists censuswardlf12months;
create temporary table censuswardlf12months as
select wardid, count(wardid) as lf12months
from thiscase
where p5_age >= 12 and p32_activity_last_12_months >= 1 and p32_activity_last_12_months <= 7
group by wardid;

drop table if exists censuswardempl7days;
create temporary table censuswardempl7days as
select wardid, count(wardid) as employed
from thiscase
where p5_age >= 12 and p31_activity_last_7_days >= 1 and p31_activity_last_7_days <= 6
group by wardid;

drop table if exists censuswardempl12months;
create temporary table censuswardempl12months as
select wardid, count(wardid) as employed
from thiscase
where p5_age >= 12 and p32_activity_last_12_months >= 1 and p32_activity_last_12_months <= 6
group by wardid;

drop table if exists censuswardunem7days;
create temporary table censuswardunem7days as
select wardid, count(wardid) as unemployed
from thiscase
where p5_age >= 12 and p31_activity_last_7_days = 7
group by wardid;

drop table if exists censuswardunem12months;
create temporary table censuswardunem12months as
select wardid, count(wardid) as unemployed
from thiscase
where p5_age >= 12 and p32_activity_last_12_months = 7
group by wardid;

drop table if exists censuswardLaborAll;
create table censuswardLaborAll as
select dist, const, ward, wardid, population, age12plus, 
 lf7days, lf12months, employed, unemployed
 from censuswardcounts full outer join censuswardcounts12plus 
using(wardid)
full outer join censuswardlf7days 
using(wardid)
full outer join censuswardlf12months 
using(wardid)
full outer join censuswardempl7days
using(wardid)
full outer join censuswardempl12months
using(wardid)
full outer join censuswardunem7days
using(wardid)
full outer join censuswardunem12months
using(wardid)
;
drop table if exists censuswardunem7days;
drop table if exists censuswardempl7days;
drop table if exists censuswardunem12months;
drop table if exists censuswardempl12months;
drop table if exists censuswardlf12months;
drop table if exists censuswardlf7days;
drop table if exists censuswardcounts12plus;
drop table if exists censuswardcounts;
drop table if exists thiscase;

