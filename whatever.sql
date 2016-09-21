drop table if exists zambiaCensusSample;

create table zambiaCensusSample as
select *
from zambiacensus2012rec2 tablesample system (1) repeatable (20160920);

select prov, count(*) from zambiacensussample group by prov;
select region, count(*) from zambiacensussample group by region;
select ward, count(*) from zambiacensussample group by ward;

select prov, ward, region, count(*) 
from zambiacensussample group by prov, ward, region
sort by prov, ward, region;

