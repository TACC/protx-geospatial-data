# Protx Geospatial Data

Docker image containing geospatial data for Protx portal.

## Background 

A first pass of this work was described in [confluence](https://confluence.tacc.utexas.edu/display/UP/Demo+map+notes+for+April+15%2C+2021).

The basic steps are:
* convert shapefiles to geojson (using gdal's `ogr2ogr`)
* use `tippecanoe` to create static vector tiles 

### Status and next steps

This works but (i) frontend gets a lot of missing errors when zooming to places outside the bounds of our data and (ii) the size of the data is large.  COOKS-27 details a possible approach to improve things by serving the tiles (see ticket for more info: "To create mbtiles adn then serve them through tileserver-gl (TileServer-GL, https://github.com/klokantech/tileserver-gl)) 


## Original data

This folder contains the original data used in this docker image.

### Vector files

In early versions of the portal, we were also presenting census tracs, urban areas, zip codes and dfps regions. Currently, we are only using county data with an outline of texas.

* `texas_counties.shp` is from `/corral-secure/projects/Cooks-ProTX/spatial/tigris/texas_counties/`
* `Texas_State_Boundary.geojson` is from https://gis-txdot.opendata.arcgis.com/datasets/texas-state-boundary/explore 
