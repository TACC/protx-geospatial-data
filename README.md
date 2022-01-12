# Protx Geospatial Data

Docker image containing geospatial data for Protx portal.

Used for:
 - [Protx - forked from CepV2](https://github.com/TACC/protx)
 - [Protx - dashboard](https://github.com/TACC/protx-dashboard)

## Background 

The initial work was described in [confluence](https://confluence.tacc.utexas.edu/display/UP/Demo+map+notes+for+April+15%2C+2021).

The basic steps are:
- convert shapefiles to geojson (using gdal's `ogr2ogr`)
- use `tippecanoe` to create static vector tiles

## Status and next steps


### Vector tiles
These tippecanoe uncompressed files work but there are some shortcomings: (i) frontend gets a lot of missing errors when zooming to places outside the bounds of our generated vector tiles and (ii) the size of the data is large.  COOKS-27 details a possible approach to improve things by serving the tiles (see ticket for more info: "To create mbtiles and then serve them through tileserver-gl (TileServer-GL, https://github.com/klokantech/tileserver-gl)) . Or there are other ways to do this (postgis?)


### Geospatial database

We need a geospatial database (postgis) and endpoint to handle queries like (1) searching through names (e.g. is any county named "Bexar"?) and (2) what is the extent of my selected region (e.g. what is the outline of this county)


## Original data

This folder contains the original data used in this docker image.

### Vector files

In early versions of the portal, we were also presenting census tracs, urban areas, zip codes and dfps regions. Currently, we are only using county data with an outline of texas but a complete list of other geographic regions used in earlier demos can be found in [confluence](https://confluence.tacc.utexas.edu/display/UP/Demo+map+notes+for+April+15%2C+2021).

* `texas_counties.shp` is from `/corral-secure/projects/Cooks-ProTX/spatial/tigris/texas_counties/`
* `Texas_State_Boundary.geojson` is from https://gis-txdot.opendata.arcgis.com/datasets/texas-state-boundary/explore 
