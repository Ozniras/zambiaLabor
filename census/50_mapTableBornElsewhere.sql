-- Totals for the laboer force born elsewhere

-- In labor force over last 12 months
drop table if exists thiscase;
create temporary table thiscase as
select *
from censuslabor
where p2_membership <= 2
and p5_age >= 12 and p32_activity_last_12_months >= 1 and p32_activity_last_12_months <= 7
;

-- Population in lf for 12 months
drop table if exists censuswardlf12months;
create temporary table censuswardlf12months as
select wardid, count(wardid) as lf12months
from thiscase
-- and p5_age >= 12 and p32_activity_last_12_months >= 1 and p32_activity_last_12_months <= 7
group by wardid;

drop table if exists censuswardlfbornelsewhere;
create temporary table censuswardlfbornelsewhere as
select wardid, count(wardid) as lf12months
from thiscase
and p6_pob != dist
group by wardid;

drop table if exists censuswardempl12months;
create temporary table censuswardempl12months as
select wardid, count(wardid) as empl12months
from thiscase
where p5_age >= 12 and p32_activity_last_12_months >= 1 and p32_activity_last_12_months <= 6
group by wardid;

drop table if exists censuswardunem12months;
create temporary table censuswardunem12months as
select wardid, count(wardid) as unem12months
from thiscase
where p5_age >= 12 and p32_activity_last_12_months = 7
group by wardid;

drop table if exists censuswardLaborUnskilled;
create table censuswardLaborUnskilled as
select dist, const, ward, wardid, population, pop12plus, 
 lf7days, lf12months, empl7days, empl12months, unem7days, unem12months
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

