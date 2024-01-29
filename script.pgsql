-- Count Records → 15612

SELECT 
    COUNT(*)
FROM 
    green_taxi_data
WHERE
	"lpep_pickup_datetime"::DATE::TEXT = '2019-09-18' AND
	"lpep_dropoff_datetime"::DATE::TEXT = '2019-09-18';

-- Largest trip for the day → 2019-09-26

SELECT
	"lpep_pickup_datetime",
	MAX("trip_distance") as Maximum_Distance
FROM
	green_taxi_data
GROUP BY 
	"lpep_pickup_datetime"
ORDER BY 
	MAX("trip_distance") DESC
LIMIT 1;

-- Three biggest pick up Boroughs → "Brooklyn" "Manhattan" "Queens"

SELECT
	z."Borough"
FROM green_taxi_data g
INNER JOIN zones z
	ON g."PULocationID" = z."LocationID"
WHERE 
	g."lpep_pickup_datetime"::DATE::TEXT = '2019-09-18'
GROUP BY z."Borough"
HAVING SUM(g."total_amount") > 50000
ORDER BY z."Borough";

-- Largest tip → JFK Airport

WITH CTE AS (
    SELECT 
        g."DOLocationID",
        MAX(g."tip_amount")
    FROM green_taxi_data g
    INNER JOIN zones z
        ON g."PULocationID" = z."LocationID"
    WHERE 
        EXTRACT(YEAR FROM g."lpep_dropoff_datetime"::TIMESTAMP) = 2019 AND
        EXTRACT(MONTH FROM g."lpep_dropoff_datetime"::TIMESTAMP) = 9 AND
        z."Zone" = 'Astoria'
    GROUP BY 
        g."DOLocationID"
    ORDER BY MAX(g."tip_amount") DESC
    LIMIT 1
)

SELECT 
	nz."Zone" as Dropoff_Zone
FROM CTE
INNER JOIN zones nz
	ON CTE."DOLocationID" = nz."LocationID";