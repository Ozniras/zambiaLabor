-- Totals for the labor force living elsewhere one year ago

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
select max(dist) as dist, max(const) as const, max(ward) as ward, wardid, count(wardid) as lf12months
from thiscase
-- and p5_age >= 12 and p32_activity_last_12_months >= 1 and p32_activity_last_12_months <= 7
group by wardid;

drop table if exists censuswardlfMigrYear;
create temporary table censuswardlfMigrYear as
select wardid, count(wardid) as lfMigrYear
from thiscase
where p14_prev_res != dist
group by wardid;

drop table if exists censuswardempl12months;
create temporary table censuswardempl12months as
select wardid, count(wardid) as empl12months
from thiscase
where p5_age >= 12 and p32_activity_last_12_months >= 1 and p32_activity_last_12_months <= 6
group by wardid;

drop table if exists censuswardemplMigrYear;
create temporary table censuswardemplMigrYear as
select wardid, count(wardid) as emplMigrYear
from thiscase
where p5_age >= 12 and p32_activity_last_12_months >= 1 and p32_activity_last_12_months <= 6
and p14_prev_res != dist
group by wardid;

drop table if exists censuswardunem12months;
create temporary table censuswardunem12months as
select wardid, count(wardid) as unem12months
from thiscase
where p5_age >= 12 and p32_activity_last_12_months = 7
group by wardid;

drop table if exists censuswardunemMigrYear;
create temporary table censuswardunemMigrYear as
select wardid, count(wardid) as unemMigrYear
from thiscase
where p5_age >= 12 and p32_activity_last_12_months = 7
and p14_prev_res != dist
group by wardid;

drop table if exists censuswardMigrYear;
create table censuswardMigrYear as
select dist, const, ward, wardid, 
 lf12months, empl12months, unem12months,
 lfMigrYear, emplMigrYear, unemMigrYear
 from censuswardlf12months 
full outer join censuswardlfMigrYear
using(wardid)
full outer join censuswardempl12months
using(wardid)
full outer join censuswardemplMigrYear
using(wardid)
full outer join censuswardunem12months
using(wardid)
full outer join censuswardunemMigrYear
using(wardid)
;
drop table if exists censuswardunem12months;
drop table if exists censuswardunemMigrYear;
drop table if exists censuswardempl12months;
drop table if exists censuswardemplMigrYear;
drop table if exists censuswardlf12months;
drop table if exists censuswardlfMigrYear;
drop table if exists thiscase;

