#!/bin/sh

shp2pgsql -c -D -s 3785 -I buildingPerimeters.shp public.building_perimeters  > building_perimeters.sql
