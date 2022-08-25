FROM osgeo/gdal:alpine-small-3.4.1 as gdal
WORKDIR /processing
COPY original_files /original_files
RUN ogr2ogr -f GeoJSON texas_counties.json -t_srs EPSG:4326 /original_files/texas_counties/texas_counties.shp
RUN ogr2ogr -f GeoJSON texas_census_tracts.json -t_srs EPSG:4326 /original_files/texas_census_tracts/census_tracts_2019.shp
RUN ogr2ogr -f GeoJSON dfps_regions.json -t_srs EPSG:4326 /original_files/texas_dfps_regions_2019/dfps_regions.shp


FROM morlov/tippecanoe:1.35.0 as tippecanoe
WORKDIR /result
COPY --from=gdal /processing/ /jsons 
RUN mkdir -p county
RUN /usr/bin/tippecanoe --no-tile-compression --coalesce-densest-as-needed --maximum-tile-bytes=250000 --include GEO_ID -e /result/county/2019 -l singleLayer -n "county" /jsons/texas_counties.json
RUN mkdir -p tract
RUN /usr/bin/tippecanoe --no-tile-compression --coalesce-densest-as-needed --maximum-tile-bytes=250000 --include GEOID -e /result/tract/2019 -l singleLayer -n "tract" /jsons/texas_census_tracts.json
RUN mkdir -p dfps_region
RUN /usr/bin/tippecanoe --no-tile-compression --coalesce-densest-as-needed --maximum-tile-bytes=250000 --include Sheet1__Re -e /result/dfps_region/2019 -l singleLayer -n "dfps_region" /jsons/dfps_regions.json


FROM postgis/postgis:13-3.2 as postgis-data-builder
RUN apt update
RUN apt install -y postgis
RUN which shp2pgsql
WORKDIR /postgis_data
COPY original_files/ /original_files
RUN shp2pgsql -I -s 4326 /original_files/texas_counties/texas_counties.shp > counties.sql
RUN shp2pgsql -I -s 4326 /original_files/texas_census_tracts/census_tracts_2019.shp > census_tracts.sql
RUN shp2pgsql -I -s 4326 /original_files/texas_dfps_regions_2019/dfps_regions.shp > dfps_regions.sql

from postgis/postgis:13-3.2

WORKDIR /data

# Add uncompressed vector tiles that we created via tippecanoe/gdal 
COPY --from=tippecanoe /result /data/vector 

# Add non-processed outline of texas
ADD original_files/Texas_State_Boundary.geojson .

# Add data for database init
COPY --from=postgis-data-builder /postgis_data/*.sql /docker-entrypoint-initdb.d/
