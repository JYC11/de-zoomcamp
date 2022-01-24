-- Question 3: How many taxi trips were there on January 15?
SELECT
    COUNT(1)
FROM
    yellow_taxi_trips
WHERE
    CAST(tpep_pickup_datetime AS DATE) = '2021-01-15';

-- Question 4: On which day it was the largest tip in January?
SELECT
    CAST(tpep_pickup_datetime AS DATE) AS "pickup_date",
    MAX(tip_amount) AS "max_tip"
FROM
    yellow_taxi_trips
WHERE
    EXTRACT(
        MONTH
        FROM
            CAST(tpep_pickup_datetime AS DATE)
    ) = 1
GROUP BY
    CAST(tpep_pickup_datetime AS DATE)
ORDER BY
    2 DESC
LIMIT
    1;

-- Question 5: What was the most popular destination for passengers picked up in central park on January 14?
SELECT
    zdu."Zone" AS "dropoff_loc",
    COUNT(1) AS "count"
FROM
    yellow_taxi_trips t,
    taxi_zone_lookups zpu,
    taxi_zone_lookups zdu
WHERE
    t."PULocationID" = zpu."LocationID"
    AND t."DOLocationID" = zdu."LocationID"
    AND CAST(t.tpep_pickup_datetime AS DATE) = '2021-01-14'
    AND zpu."Zone" = 'Central Park'
GROUP BY
    zdu."Zone"
ORDER BY
    2 DESC
LIMIT
    1;

-- Question 6: What's the pickup-dropoff pair with the largest average price for a ride (calculated based on total_amount)?
SELECT
    CONCAT(zpu."Zone", '/', zdu."Zone") AS "pickup_dropoff",
    AVG(total_amount)
FROM
    yellow_taxi_trips t,
    taxi_zone_lookups zpu,
    taxi_zone_lookups zdu
WHERE
    t."PULocationID" = zpu."LocationID"
    AND t."DOLocationID" = zdu."LocationID"
GROUP BY
    CONCAT(zpu."Zone", '/', zdu."Zone")
ORDER BY
    2 DESC
LIMIT
    1;