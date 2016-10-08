select hhn, count, cast(cast(count as real) / (select count(hhn) from zambiacensus2010rec2) * 100 as decimal(6,2)) as freq from (
select hhn, count(hhn) as count from zambiacensus2010rec2 group by grouping sets (hhn, ()) order by hhn
) as subquery;

/*
3 hhn with '**'
Most are 01 (13'122,930 or 98.99%), then 02-09.
Then jump to 81 - 99 with several k's at 81 - 85 (but these are < 0.24%) (???)
 dist | const | ward | region | sea | csa | cbn | hun | hhn | household_size 
------+-------+------+--------+-----+-----+-----+-----+-----+----------------
  406 |    66 |    7 |      2 |   2 |   4 | 270 |   0 | **  |              2
  406 |    66 |    7 |      2 |   2 |   4 | 270 |   0 | **  |              2
  406 |    66 |    7 |      2 |   2 |   4 | 274 |   0 | **  |              1
*/


select max(dist), max(const), max(ward), max(region) from zambiacensus2010rec2;
-- 1007 150 33 2

-- Create master table for our project, with wardId and regionId 
-- Correct hhn = ** and create household id
drop table if exists censuslabor;
create table censuslabor as 
select prov, dist, const, ward, region, csa, sea, cbn, hun, hhn,
p2_membership, p3_rel, p4_sex, p5_age,
p28_highest_level, p29_high_vocation, 
p31_activity_last_7_days, p32_activity_last_12_months, p33_employment_status, p34_occupation, p35_industry,
household_size
from zambiacensus2010rec2;

update censuslabor
set hhn = '00'
where hhn = '**';

select p2_membership, count(p2_membership), avg(household_size)
from censuslabor
group by p2_membership; 
/*
Usual member absent: 730k; vs Visitor: 164k
 p2_membership |  count   |        avg         
---------------+----------+--------------------
             1 | 12362720 | 6.6462245363479881
             2 |   729946 | 7.0771098136026501
             3 |   163594 | 7.8993544995537734

*/

select p2_membership, p3_rel, count(p3_rel)
from censuslabor
group by p2_membership, p3_rel
order by p2_membership, p3_rel;

alter table censuslabor 
  add column wardId integer,
  add column wardregionId integer,
  add column hhdId  numeric(23, 0),
  alter column hhn set data type smallint using hhn::smallint
;
update censuslabor set wardId = ward + 100 * ( const + 1000 * dist),
  wardregionId = region + 10 * ( ward + 100* ( const + 1000 * dist)),
  hhdId = hhn + 100 * (hun + 1000 * (cbn + 10000 * (sea + 10 * (csa + 100 * cast(wardregionId as numeric(10,0))))))
;

drop table if exists censuswardcounts;
create table censuswardcounts as
select max(dist) as dist, max(const) as const, max(ward) as ward,
  wardid, count(wardid) as population
from censuslabor
where p2_membership <= 2
group by wardid;

create temporary table censuswardcounts12plus as
select wardid, count(wardid) as age12plus
from censuslabor
where p5_age >= 12 and p2_membership <= 2
group by wardid;

create temporary table censuswardlf7days as
select wardid, count(wardid) as lf7days
from censuslabor
where p5_age >= 12 and p31_activity_last_7_days >= 1 and p31_activity_last_7_days <= 7
 and p2_membership <= 2
group by wardid;

create temporary table censuswardlf12months as
select wardid, count(wardid) as lf12months
from censuslabor
where p5_age >= 12 and p32_activity_last_12_months >= 1 and p32_activity_last_12_months <= 7
 and p2_membership <= 2
group by wardid;

create temporary table censuswardemployed as
select wardid, count(wardid) as employed
from censuslabor
where p5_age >= 12 and p32_activity_last_12_months >= 1 and p32_activity_last_12_months <= 6
 and p2_membership <= 2
group by wardid;

create temporary table censuswardunemployed as
select wardid, count(wardid) as unemployed
from censuslabor
where p5_age >= 12 and p32_activity_last_12_months = 7
 and p2_membership <= 2
group by wardid;

drop table if exists censuswardlfemployed;
create table censuswardlfemployed as
select dist, const, ward, wardid, population, age12plus, 
 lf7days, lf12months, employed, unemployed
 from censuswardcounts full outer join censuswardcounts12plus 
using(wardid)
full outer join censuswardlf7days 
using(wardid)
full outer join censuswardlf12months 
using(wardid)
full outer join censuswardemployed 
using(wardid)
full outer join censuswardunemployed
using(wardid)
;
drop table if exists censuswardunemployed;
drop table if exists censuswardemployed;
drop table if exists censuswardlf12months;
drop table if exists censuswardlf7days;
drop table if exists censuswardcounts12plus;



drop table if exists censuswardlfemployedgis;
create table censuswardlfemployedgis as 
select dist, const, ward, wardid, population, age12plus, lf7days, lf12months, employed, unemployed,
  gid, objectid, id, provincena, districtna, const_name, ward_name, area_sqkm, perimeter, shape_leng, shape_area, geom 
from censuswardlfemployed as c full outer join wardshapefile as w on (c.wardid = w.id)
;

----------
/*
Education level 1: 
None, Primary incomplete, Primary comlete, Secondary incomplete, 
Secondary complete, post-secondary, adult education or literacy classes

Education level 2:
No education, Primary, Secondary, Post-secondary
Map into (None), (Certificate), (Diploma), (Bachelor degree, Masters Degree, PhD)

THESE MAATCH
	gen byte edulevel1=1 if S2Q2==2 | (S2Q3==0 & S2Q5 != 1)
	replace edulevel1=2 if S2Q3>=1 & S2Q3<=7 | (S2Q3==0 & S2Q5==1)
	replace edulevel1=3 if S2Q3==8 & S2Q5!=9
	replace edulevel1=4 if S2Q3>=9 & S2Q3<=11 | (S2Q3==8 & S2Q5==9)
	replace edulevel1=5 if S2Q3==12 & (S2Q5<13 | S2Q5==.)
	replace edulevel1=6 if S2Q3>12 & S2Q3 !=. | S2Q3==12 & S2Q5>=13 & S2Q5<=16
	replace edulevel1=. if age<ed_mod_age & age!=.
	label var edulevel1 "Level of education 1"
	la de lbledulevel1 1 "No education" 2 "Primary incomplete" 3 "Primary complete" 4 "Secondary incomplete" 5 "Secondary complete" 6 "Post-secondary" 7 "Adult education or literacy classes"
	label values edulevel1 lbledulevel1


LABOR STATUS 
Employed:
-In paid employment / business
-In paid employment but temporarily not working due to illness, leave, industrial dispute or on study leave
-Working without pay

OR:
At least one hour per day in last 7 days paid in cash / kind
Any work in household or business of any kind in last 7 with or without pay
Agric activities (sale or household consumption) last 7 days
Fishing
Gather fruits, firweood, etc

Unemployed:
Not any of the aboven and YES to 
Made any effort to look for work / start business / subsistence farming or any other income generating activity in last 7 days

Non-LF:
Not any employed and NO to above

EMPLOYMENT STATUS
Paid employee
Non-paid employee (unpaid family worker)
Employer
Self employed
Other


INDUSTRY CODE: checked that match and that <3 digits areok with table

*/
select dist, count(dist) from censuslabor group by dist order by dist;

select count(prov), count(dist), count(const), count(ward), count(region), 
count(p2_membership), count(p3_rel), count(p4_sex), count(p5_age),
count(p28_highest_level), count(p29_high_vocation), 
count(p31_activity_last_7_days), count(p32_activity_last_12_months), count(p33_employment_status), count(p34_occupation), count(p35_industry),
count(household_size)
from censuslabor;

select count(prov), 
count(p28_highest_level), count(p29_high_vocation)
from censuslabor
where p5_age >= 5;
-- There are 10'974,677, but only 8'124,869 and 10'311,427

select count (prov), 
count(p31_activity_last_7_days), count(p32_activity_last_12_months), count(p33_employment_status), count(p34_occupation), count(p35_industry)
from censuslabor
where p5_age >= 12;
-- There are 8'269,365, but only 7'715,022 have on activity (but then OK for last three based on activity)

select count (prov), 
count(p31_activity_last_7_days), count(p32_activity_last_12_months), count(p33_employment_status), count(p34_occupation), count(p35_industry)
from censuslabor
where p5_age >= 12 and p32_activity_last_12_months <= 6;
-- for all (3'887,052)



drop table if exists zambiaCensusSample;

create table zambiaCensusSample as
select *
from zambiacensus2010rec2 tablesample system (1) repeatable (20160920);

select prov, count(*) from zambiacensussample group by prov;
select region, count(*) from zambiacensussample group by region;
select ward, count(*) from zambiacensussample group by ward;

select prov, ward, region, count(*) 
from zambiacensussample group by prov, ward, region
order by prov, ward, region;










insert into (
select prov, ward, region, count(*) as frequency
from zambiacensussample group by prov, ward, region
order by prov, ward, region
)
select count(*) as frequency from zambiacensussample;
