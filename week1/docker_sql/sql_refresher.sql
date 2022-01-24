SELECT
    t.tpep_pickup_datetime,
    t.tpep_dropoff_datetime,
    t.total_amount,
    CONCAT(zpu."Borough", '/', zpu."Zone") AS "pickup_loc",
    CONCAT(zdu."Borough", '/', zdu."Zone") AS "dropoff_loc"
FROM
    yellow_taxi_trips t,
    taxi_zone_lookups zpu,
    taxi_zone_lookups zdu
WHERE
    t."PULocationID" = zpu."LocationID"
    AND t."DOLocationID" = zdu."LocationID"
LIMIT
    100;

SELECT
    CAST(tpep_dropoff_datetime AS DATE) AS "day",
    "DOLocationID",
    COUNT(1),
    MAX(total_amount) AS "max_fee",
    MAX(passenger_count) AS "max_passengers"
FROM
    yellow_taxi_trips t
GROUP BY
    1,
    2
ORDER BY
    "day" ASC,
    "DOLocationID" ASC;