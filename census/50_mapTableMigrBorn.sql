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
select max(dist) as dist, max(const) as const, max(ward) as ward, wardid, count(wardid) as lf12months
from thiscase
-- and p5_age >= 12 and p32_activity_last_12_months >= 1 and p32_activity_last_12_months <= 7
group by wardid;

drop table if exists censuswardlfMigrBorn;
create temporary table censuswardlfMigrBorn as
select wardid, count(wardid) as lfMigrBorn
from thiscase
where p6_pob != dist
group by wardid;

drop table if exists censuswardempl12months;
create temporary table censuswardempl12months as
select wardid, count(wardid) as empl12months
from thiscase
where p5_age >= 12 and p32_activity_last_12_months >= 1 and p32_activity_last_12_months <= 6
group by wardid;

drop table if exists censuswardemplMigrBorn;
create temporary table censuswardemplMigrBorn as
select wardid, count(wardid) as emplMigrBorn
from thiscase
where p5_age >= 12 and p32_activity_last_12_months >= 1 and p32_activity_last_12_months <= 6
and p6_pob != dist
group by wardid;

drop table if exists censuswardunem12months;
create temporary table censuswardunem12months as
select wardid, count(wardid) as unem12months
from thiscase
where p5_age >= 12 and p32_activity_last_12_months = 7
group by wardid;

drop table if exists censuswardunemMigrBorn;
create temporary table censuswardunemMigrBorn as
select wardid, count(wardid) as unemMigrBorn
from thiscase
where p5_age >= 12 and p32_activity_last_12_months = 7
and p6_pob != dist
group by wardid;

drop table if exists censuswardMigrBorn;
create table censuswardMigrBorn as
select dist, const, ward, wardid, 
 lf12months, empl12months, unem12months,
 lfMigrBorn, emplMigrBorn, unemMigrBorn
 from censuswardlf12months 
full outer join censuswardlfMigrBorn
using(wardid)
full outer join censuswardempl12months
using(wardid)
full outer join censuswardemplMigrBorn
using(wardid)
full outer join censuswardunem12months
using(wardid)
full outer join censuswardunemMigrBorn
using(wardid)
;
drop table if exists censuswardunem12months;
drop table if exists censuswardunemMigrBorn;
drop table if exists censuswardempl12months;
drop table if exists censuswardemplMigrBorn;
drop table if exists censuswardlf12months;
drop table if exists censuswardlfMigrBorn;
drop table if exists thiscase;

