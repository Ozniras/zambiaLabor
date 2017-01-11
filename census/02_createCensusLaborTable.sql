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
p6_pob, p7_region_at_birth, p8_zambian, p14_prev_res,
p28_highest_level, p29_high_vocation, 
p31_activity_last_7_days, p32_activity_last_12_months, p33_employment_status, p34_occupation, p35_industry,
household_size
from zambiacensus2010rec2;

update censuslabor
set hhn = '00'
where hhn = '**';

select count(p2_membership) from zambiacensus2010rec2 where p2_membership is not null;

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

-- overkill: p6_pob is set as char3 so no spaces in front or behind above 3 characters
select count(case when trim(both ' ' from p6_pob) ~ '^[0-9]+$' then 1 end) as proper, 
count(case when trim(both ' ' from p6_pob) !~ '^[0-9]+$' then 1 end) as improper 
from zambiacensus2010rec2
where p5_age >= 5;

select count(case when trim(both ' ' from p14_prev_res) ~ '^[0-9]+$' then 1 end) as proper, 
count(case when trim(both ' ' from p14_prev_res) !~ '^[0-9]+$' then 1 end) as improper 
from zambiacensus2010rec2
where p5_age >= 5;

select p8_zambian, count(p8_zambian) 
from zambiacensus2010rec2 
where p5_age >= 5
group by p8_zambian;

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

update censuslabor set
p6_pob = case when p6_pob ~ '^[0-9]+$' then p6_pob end,
p14_prev_res = case when p14_prev_res ~ '^[0-9]+$' then p14_prev_res end
;

alter table censuslabor
 alter column p6_pob set data type smallint using p6_pob::smallint,
 alter column p14_prev_res set data type smallint using p14_prev_res::smallint
;
