select hhn, count, cast(cast(count as real) / (select count(hhn) from zambiacensus2010rec2) * 100 as decimal(6,2)) as freq from (
select hhn, count(hhn) as count from zambiacensus2010rec2 group by grouping sets (hhn, ()) order by hhn
) as subquery;

/*
3 hhn with '**'
Most are 01 (13'122,930 or 98.99%), then 02-09.
Then jump to 81 - 99 with several k's at 81 - 85 (but these are < 0.24%) (???)
*/

select max(dist), max(const), max(ward), max(region) from zambiacensus2010rec2;
-- 1007 150 33 2

create table censuslabor as 
select prov, dist, const, ward, region, 
p2_membership, p3_rel, p4_sex, p5_age,
p28_highest_level, p29_high_vocation, 
p31_activity_last_7_days, p32_activity_last_12_months, p33_employment_status, p34_occupation, p35_industry,
household_size
from zambiacensus2010rec2;

alter table censuslabor add column wardId integer;
update censuslabor set wardId = ward + 100 * ( const + 1000 * dist)
--, wregionId = region + 10 * ( ward + 100* ( const + 1000 * dist))
;


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
