FROM osgeo/gdal:alpine-small-3.4.1 as gdal
WORKDIR /processing
COPY original_files /original_files
RUN ogr2ogr -f GeoJSON texas_counties.json -t_srs EPSG:4326 /original_files/texas_counties/texas_counties.shp

FROM morlov/tippecanoe:1.35.0 as tippecanoe
WORKDIR /result
COPY --from=gdal /processing/ /jsons 
RUN mkdir -p county
RUN /usr/bin/tippecanoe --no-tile-compression --coalesce-densest-as-needed --maximum-tile-bytes=250000 -e /result/county/2019 -l singleLayer -n "county" /jsons/texas_counties.json

from alpine:latest
WORKDIR /data
# Add uncompressed vector tiles that we created via tippecanoe/gdal 
COPY --from=tippecanoe /result /data/vector 

# Add non-processed outline of texas
ADD original_files/Texas_State_Boundary.geojson .
