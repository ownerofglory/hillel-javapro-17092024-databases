#!/bin/bash

osmosis --read-pbf stuttgart-regbez-latest.osm.pbf \
        --tf accept-nodes "amenity=*" "shop=*" "tourism=*" "leisure=*" "office=*" "craft=*" "historic=*" "emergency=*" "healthcare=*" "man_made=*" "power=*" "public_transport=*" "railway=*" "sport=*" "barrier=*" "building=*" "natural=*" "place=*" "military=*" \
        --tf reject-ways \
        --tf reject-relations \
        --used-node \
        --write-xml file=Stuttgart_pois.osm

ogr2ogr -f GeoJSON Stuttgart.json Stuttgart.pois.osm points

