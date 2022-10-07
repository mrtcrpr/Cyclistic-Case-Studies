/*
 First of all, we need to connect 12 separate data sets of 2021 and turn them into a single table.
 I created a new table with the same number of columns and the same column names as the datasets I have and ı named '[2021_combined_data]'.
 Then ı connected the 12 month datasets together using union all.
 */
 
INSERT INTO
  [2021_combined_data]
SELECT
  *
FROM
  [2021Jan]
UNION
ALL
SELECT
  *
FROM
  [2021Feb]
UNION
ALL
SELECT
  *
FROM
  [2021Mar]
UNION
ALL
SELECT
  *
FROM
  [2021Apr]
UNION
ALL
SELECT
  *
FROM
  [2021May]
UNION
ALL
SELECT
  *
FROM
  [2021Jun]
UNION
ALL
SELECT
  *
FROM
  [2021Jul]
UNION
ALL
SELECT
  *
FROM
  [2021Aug]
UNION
ALL
SELECT
  *
FROM
  [2021Sep]
UNION
ALL
SELECT
  *
FROM
  [2021Oct]
UNION
ALL
SELECT
  *
FROM
  [2021Nov]
UNION
ALL
SELECT
  *
FROM
  [2021Dec]
SELECT
  *
FROM
  [2021_combined_data];

/*
 When we run the select query, it returns 5,595,063 rows. Since we use union all, all rows in the tables we include will be merged.
 The columns in the [2021_combined_data] table will be pre-cleaned.
 */
 
/*
 RIDE_ID
 The first column we need to check is ride_id. Each value in the ride_id column must be 16 characters. 
 Except for 16 character data, outliers are data. Also, each row must be unique.
 */
 
SELECT
  len(ride_id),
  COUNT(*)
FROM
  [2021_combined_data]
GROUP BY
  len(ride_id);

SELECT
  COUNT(DISTINCT ride_id)
FROM
  [2021_combined_data];

--There are 457 rows that are not 16 characters, this data needs to be cleaned and each row has a unique value.

/*
 RIDEABLE_TYPE
 Next column we need to check is rideable_type.
 */
 
SELECT
  DISTINCT rideable_type
FROM
  [2021_combined_data];

/*We come across 3 unique values. These are electric_bike, classic_bike and docked_bike.
 classic_bike and docked_bike can basically be described as the same because both are not powered by electricity.
 The docked_bike needs to be converted to the classic_bike.
 */
 
/*
 STARTED_AT and ENDED_AT
 Next column we need to check is started_ended_at columns. 
 In this part, the journey will not be less than 1 minute and more than 1 day.
 Also there is a weird problem in here. The problem is some ended_at rows less than started_at rows.
 */
 
SELECT
  ride_id,
  started_at,
  ended_at
FROM
  [2021_combined_data]
WHERE
  ended_at < started_at;

SELECT
  ride_id,
  started_at,
  ended_at,
  CAST(ended_at - started_at AS time)
FROM
  [2021_combined_data]
WHERE
  CAST(ended_at - started_at AS time) > '00:01:00';

SELECT
  ride_id,
  started_at,
  ended_at,
  CAST(ended_at - started_at AS time)
FROM
  [2021_combined_data]
WHERE
  DATEDIFF(MINUTE, started_at, ended_at) > 1440;

/*
 This rows should be deleted.
 Because this rows are inconsistent.
 */
 
/*
 STATION_NAME and STATION_ID
 The next columns to check are station_name and station_id. 
 There were 3 rows in the table where the start_station_name column was null but the start_station_id column was not null.
 Also there is some 'Temp' values trailing of the station name columns. They need to be deleted.
 */
 
SELECT
  start_station_name,
  start_station_id
FROM
  [2021_combined_data]
WHERE
  start_station_name IS NULL
  AND start_station_id IS NOT NULL;

SELECT
  *
FROM
  [2021_combined_data]
WHERE
  start_station_name IS NULL
  AND start_station_id IS NULL
  OR end_station_name IS NULL
  AND end_station_id IS NULL;

SELECT
  *
FROM
  [2021_combined_data]
WHERE
  start_station_name LIKE '%temp%'
  OR end_station_name LIKE '%temp%';

--Regardless of the rideable_type, all rows with at least 1 null value should be deleted.

/*
 LAT and LNG
 Other columns to examine are the latitude and longitude columns.
 */
 
SELECT
  *
FROM
  [2021_combined_data]
WHERE
  start_lat IS NULL
  OR start_lng IS NULL
  OR end_lat IS NULL
  OR end_lng IS NULL;

--Since these latitude and longitude values will be mapped later, null values need to be eliminated.

/*
 MEMBER_CASUAL
 The next column to be evaluated is the member_casual column and must contain two values. These are member and casual.
 */
 
SELECT
  DISTINCT member_casual
FROM
  [2021_combined_data];

--No values to delete were found in this column.






































