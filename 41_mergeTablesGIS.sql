
drop table if exists censuswardlabor1635gis;
create table censuswardlabor1635gis as
select dist, const, ward, wardid, population, pop12plus, lf7days, lf12months, empl7days, empl12months, unem7days, unem12months,
  gid, objectid, id, provincena, districtna, const_name, ward_name, area_sqkm, perimeter, shape_leng, shape_area, geom
from censuswardlabor1635 as c full outer join wardshapefile as w on (c.wardid = w.id)
;

drop table if exists censuswardlabor1665gis;
create table censuswardlabor1665gis as
select dist, const, ward, wardid, population, pop12plus, lf7days, lf12months, empl7days, empl12months, unem7days, unem12months,
  gid, objectid, id, provincena, districtna, const_name, ward_name, area_sqkm, perimeter, shape_leng, shape_area, geom
from censuswardlabor1665 as c full outer join wardshapefile as w on (c.wardid = w.id)
;

drop table if exists censuswardlabor3665gis;
create table censuswardlabor3665gis as
select dist, const, ward, wardid, population, pop12plus, lf7days, lf12months, empl7days, empl12months, unem7days, unem12months,
  gid, objectid, id, provincena, districtna, const_name, ward_name, area_sqkm, perimeter, shape_leng, shape_area, geom
from censuswardlabor3665 as c full outer join wardshapefile as w on (c.wardid = w.id)
;

drop table if exists censuswardlaborallgis;
create table censuswardlaborallgis as
select dist, const, ward, wardid, population, pop12plus, lf7days, lf12months, empl7days, empl12months, unem7days, unem12months,
  gid, objectid, id, provincena, districtna, const_name, ward_name, area_sqkm, perimeter, shape_leng, shape_area, geom
from censuswardlaborall as c full outer join wardshapefile as w on (c.wardid = w.id)
;

drop table if exists censuswardlaborfemalegis;
create table censuswardlaborfemalegis as
select dist, const, ward, wardid, population, pop12plus, lf7days, lf12months, empl7days, empl12months, unem7days, unem12months,
  gid, objectid, id, provincena, districtna, const_name, ward_name, area_sqkm, perimeter, shape_leng, shape_area, geom
from censuswardlaborfemale as c full outer join wardshapefile as w on (c.wardid = w.id)
;

drop table if exists censuswardlabormalegis;
create table censuswardlabormalegis as
select dist, const, ward, wardid, population, pop12plus, lf7days, lf12months, empl7days, empl12months, unem7days, unem12months,
  gid, objectid, id, provincena, districtna, const_name, ward_name, area_sqkm, perimeter, shape_leng, shape_area, geom
from censuswardlabormale as c full outer join wardshapefile as w on (c.wardid = w.id)
;

drop table if exists censuswardlaborskilledgis;
create table censuswardlaborskilledgis as
select dist, const, ward, wardid, population, pop12plus, lf7days, lf12months, empl7days, empl12months, unem7days, unem12months,
  gid, objectid, id, provincena, districtna, const_name, ward_name, area_sqkm, perimeter, shape_leng, shape_area, geom
from censuswardlaborskilled as c full outer join wardshapefile as w on (c.wardid = w.id)
;

drop table if exists censuswardlaborunskilledgis;
create table censuswardlaborunskilledgis as
select dist, const, ward, wardid, population, pop12plus, lf7days, lf12months, empl7days, empl12months, unem7days, unem12months,
  gid, objectid, id, provincena, districtna, const_name, ward_name, area_sqkm, perimeter, shape_leng, shape_area, geom
from censuswardlaborunskilled as c full outer join wardshapefile as w on (c.wardid = w.id)
;
