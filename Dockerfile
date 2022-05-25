FROM osgeo/gdal:alpine-small-3.4.1 as gdal
WORKDIR /processing
COPY original_files /original_files
RUN ogr2ogr -f GeoJSON texas_counties.json -t_srs EPSG:4326 /original_files/texas_counties/texas_counties.shp

FROM morlov/tippecanoe:1.35.0 as tippecanoe
WORKDIR /result
COPY --from=gdal /processing/ /jsons 
RUN mkdir -p county
RUN /usr/bin/tippecanoe --no-tile-compression --coalesce-densest-as-needed --maximum-tile-bytes=250000 -e /result/county/2019 -l singleLayer -n "county" /jsons/texas_counties.json

FROM postgis/postgis:13-3.2 as postgis-tool-builder
RUN apt update
RUN apt install -y postgis
RUN which shp2pgsql

from postgis/postgis:13-3.2

WORKDIR /data

COPY --from=postgis-tool-builder /usr/bin/shp2pgsql /usr/bin/shp2pgsql

# Add uncompressed vector tiles that we created via tippecanoe/gdal 
COPY --from=tippecanoe /result /data/vector 

# Add non-processed outline of texas
ADD original_files/Texas_State_Boundary.geojson .

# Adding shapefiles (via init scripts) to be added to db
COPY original_files/ /original_files
RUN shp2pgsql -I -s 4326 /original_files/texas_counties/texas_counties.shp > /docker-entrypoint-initdb.d/counties.sql
