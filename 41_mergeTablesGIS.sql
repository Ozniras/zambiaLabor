
drop table if exists censuswardlabor1524gis;
create table censuswardlabor1524gis as
select dist, const, ward, wardid, population, pop12plus, lf7days, lf12months, empl7days, empl12months, unem7days, unem12months,
  gid, objectid, id, provincena, districtna, const_name, ward_name, area_sqkm, perimeter, shape_leng, shape_area, geom
from censuswardlabor1524 as c full outer join wardshapefile as w on (c.wardid = w.id)
;

drop table if exists censuswardlabor1564gis;
create table censuswardlabor1564gis as
select dist, const, ward, wardid, population, pop12plus, lf7days, lf12months, empl7days, empl12months, unem7days, unem12months,
  gid, objectid, id, provincena, districtna, const_name, ward_name, area_sqkm, perimeter, shape_leng, shape_area, geom
from censuswardlabor1564 as c full outer join wardshapefile as w on (c.wardid = w.id)
;

drop table if exists censuswardlabor2564gis;
create table censuswardlabor2564gis as
select dist, const, ward, wardid, population, pop12plus, lf7days, lf12months, empl7days, empl12months, unem7days, unem12months,
  gid, objectid, id, provincena, districtna, const_name, ward_name, area_sqkm, perimeter, shape_leng, shape_area, geom
from censuswardlabor2564 as c full outer join wardshapefile as w on (c.wardid = w.id)
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

drop table if exists censuswardlaborsemiskilledgis;
create table censuswardlaborsemiskilledgis as
select dist, const, ward, wardid, population, pop12plus, lf7days, lf12months, empl7days, empl12months, unem7days, unem12months,
  gid, objectid, id, provincena, districtna, const_name, ward_name, area_sqkm, perimeter, shape_leng, shape_area, geom
from censuswardlaborsemiskilled as c full outer join wardshapefile as w on (c.wardid = w.id)
;

drop table if exists censuswardlaboragriculturegis;
create table censuswardlaboragriculturegis as
select dist, const, ward, wardid, population, pop12plus, lf7days, lf12months, empl7days, empl12months, unem7days, unem12months,
  gid, objectid, id, provincena, districtna, const_name, ward_name, area_sqkm, perimeter, shape_leng, shape_area, geom
from censuswardlaboragriculture as c full outer join wardshapefile as w on (c.wardid = w.id)
;
drop table if exists censuswardlaborempstatemployeepaidgis;
create table censuswardlaborempstatemployeepaidgis as
select dist, const, ward, wardid, population, pop12plus, lf7days, lf12months, empl7days, empl12months, unem7days, unem12months,
  gid, objectid, id, provincena, districtna, const_name, ward_name, area_sqkm, perimeter, shape_leng, shape_area, geom
from censuswardlaborempstatemployeepaid as c full outer join wardshapefile as w on (c.wardid = w.id)
;

drop table if exists censuswardlaborempstatemployeeunpaidgis;
create table censuswardlaborempstatemployeeunpaidgis as
select dist, const, ward, wardid, population, pop12plus, lf7days, lf12months, empl7days, empl12months, unem7days, unem12months,
  gid, objectid, id, provincena, districtna, const_name, ward_name, area_sqkm, perimeter, shape_leng, shape_area, geom
from censuswardlaborempstatemployeeunpaid as c full outer join wardshapefile as w on (c.wardid = w.id)
;

drop table if exists censuswardlaborempstatemployergis;
create table censuswardlaborempstatemployergis as
select dist, const, ward, wardid, population, pop12plus, lf7days, lf12months, empl7days, empl12months, unem7days, unem12months,
  gid, objectid, id, provincena, districtna, const_name, ward_name, area_sqkm, perimeter, shape_leng, shape_area, geom
from censuswardlaborempstatemployer as c full outer join wardshapefile as w on (c.wardid = w.id)
;

drop table if exists censuswardlaborempstatselfagricgis;
create table censuswardlaborempstatselfagricgis as
select dist, const, ward, wardid, population, pop12plus, lf7days, lf12months, empl7days, empl12months, unem7days, unem12months,
  gid, objectid, id, provincena, districtna, const_name, ward_name, area_sqkm, perimeter, shape_leng, shape_area, geom
from censuswardlaborempstatselfagric as c full outer join wardshapefile as w on (c.wardid = w.id)
;

drop table if exists censuswardlaborempstatselfnonagricgis;
create table censuswardlaborempstatselfnonagricgis as
select dist, const, ward, wardid, population, pop12plus, lf7days, lf12months, empl7days, empl12months, unem7days, unem12months,
  gid, objectid, id, provincena, districtna, const_name, ward_name, area_sqkm, perimeter, shape_leng, shape_area, geom
from censuswardlaborempstatselfnonagric as c full outer join wardshapefile as w on (c.wardid = w.id)
;

drop table if exists censuswardlabormanufacturegis;
create table censuswardlabormanufacturegis as
select dist, const, ward, wardid, population, pop12plus, lf7days, lf12months, empl7days, empl12months, unem7days, unem12months,
  gid, objectid, id, provincena, districtna, const_name, ward_name, area_sqkm, perimeter, shape_leng, shape_area, geom
from censuswardlabormanufacture as c full outer join wardshapefile as w on (c.wardid = w.id)
;

drop table if exists censuswardlabormininggis;
create table censuswardlabormininggis as
select dist, const, ward, wardid, population, pop12plus, lf7days, lf12months, empl7days, empl12months, unem7days, unem12months,
  gid, objectid, id, provincena, districtna, const_name, ward_name, area_sqkm, perimeter, shape_leng, shape_area, geom
from censuswardlabormining as c full outer join wardshapefile as w on (c.wardid = w.id)
;



