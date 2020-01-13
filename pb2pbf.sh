#!/bin/bash
echo_time() {
    date +"%F-%R $*"
}

for level in building floor room reference
do
    echo_time "converting $level"
	docker run -it \
    -v ~/data/geojson:/tmp osgeo/gdal:ubuntu-small-latest \
    ogr2ogr -f GeoJSON /tmp/$level.geojson  \
		"PG:host=pg10-3.chqhemsu7ovp.us-east-1.rds.amazonaws.com dbname=gis user=reader password=$DBPWD" \
		-sql "select * from $level"
done

echo_time "creating tiles"
docker run -it \
-v ~/data/geojson:/tmp yonghah/tippecanoe-ubuntu:latest \
tippecanoe \
/tmp/building.geojson /tmp/floor.geojson /tmp/room.geojson /tmp/reference.geojson \
-e /tmp/tile -z18 -pf -pk -f -pC

echo_time "uploading tiles to $S3BUCKET"
aws s3 sync /home/ec2-user/data/geojson/tile s3://$S3BUCKET/tile

echo_time "update finished."