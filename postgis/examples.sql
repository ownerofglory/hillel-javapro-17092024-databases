-- search restaurants within 1km radius
-- from certain location
-- sorted by distance
WITH location AS (
    SELECT ST_SetSRID(
                   ST_MakePoint(
                           9.1638107, -- lng
                           48.7727245), -- lat
                   4326) AS geom
)
SELECT
    id,
    name,
    type,
    geometry,
    ST_Distance(places.geometry::geography, location.geom::geography) AS distance
FROM
    places, location
WHERE
    ST_DWithin(
            places.geometry::geography,
            location.geom::geography,
            1000 -- Radius in meters
    )
ORDER BY
    distance ASC;


