#!/bin/bash
for level in building floor room reference
do
	docker run -it \
    -v ~/data/geojson:/tmp osgeo/gdal:ubuntu-small-latest \
    ogr2ogr -f GeoJSON /tmp/$level.geojson  \
		"PG:host=pg10-3.chqhemsu7ovp.us-east-1.rds.amazonaws.com dbname=gis user=reader password=$DBPWD" \
		-sql "select * from $level"
done
