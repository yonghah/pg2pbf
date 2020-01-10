docker run -it \
-v ~/data/geojson:/tmp yonghah/tippecanoe-ubuntu:latest \
tippecanoe \
/tmp/building.geojson /tmp/floor.geojson /tmp/room.geojson /tmp/reference.geojson \
-e /tmp/tile -z18 -pf -pk -f -pC