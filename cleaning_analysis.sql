---------------------------------------------------------------------------------CLEAN---------------------------------------------------------------------------------
/*
 RIDE_ID
 We need to clean 457 rows that are not 16 characters.
 */
DELETE FROM
  [2021_combined_data]
WHERE
  len(ride_id) != 16;
-- 457 rows cleaned.

/*
 RIDEABLE_TYPE
 We will convert docked_bike to classic_bike. Because these are same thing.
 */
UPDATE
  [2021_combined_data]
SET
  rideable_type = 'classic_bike'
WHERE
  rideable_type = 'docked_bike';
-- 312316 docked_bike rows converted to classic_bike.

/*
 STARTED_AT and ENDED_AT
 If you remember, we need to delete some lines.
 In these lines, some ended_at data has an earlier date than started_at data.
 */
DELETE FROM
  [2021_combined_data]
WHERE
  ended_at <= started_at;
-- 653 rows deleted.
-- In addition, driving times should not be less than 1 minute and more than 1 day. Such values are outliers.
DELETE FROM
  [2021_combined_data]
WHERE
  cast(ended_at - started_at AS time) < '00:01:00';
-- 84577 rows deleted for driving times less than 1 minute.

DELETE FROM
  [2021_combined_data]
WHERE
  DATEDIFF(MINUTE, started_at, ended_at) > 1440;
-- 4012 rows deleted for driving times more than 1 day.

/*
 START_STATION_NAME and START_STATION_ID and END_STATION_NAME and END_STATION_ID
 We have a lot off null values of these columns. 
 Regardless of the rideable_type, this data needs to be deleted.
 Also there is 3 missing rows. It should be fixed. 
 And we have 'Temp' values trailing of the station names. We need to delete this rows.
 */
UPDATE
  [2021_combined_data]
SET
  start_station_name = 'Wood St & Milwaukee Ave'
WHERE
  start_station_id = '13221';

UPDATE
  [2021_combined_data]
SET
  start_station_name = 'Hegewisch Metra Station'
WHERE
  start_station_id = '20215';

UPDATE
  [2021_combined_data]
SET
  start_station_name = 'Clinton St & Roosevelt Rd'
WHERE
  start_station_id = 'WL-008';
-- 3 missing rows fixed.

DELETE FROM
  [2021_combined_data]
WHERE
  start_station_name IS NULL
  OR start_station_id IS NULL
  OR end_station_name IS NULL
  OR end_station_id IS NULL;
-- At least 1 null value in these columns has been deleted.

DELETE FROM
  [2021_combined_data]
WHERE
  start_station_name LIKE '%temp%'
  OR end_station_name LIKE '%temp%';
-- 47307 'Temp' rows deleted from start and end station names. 

/*
 START_LAT and START_LNG and END_LAT and END_LNG
 These columns have some null values. These null values need to be deleted.
 */
DELETE FROM
  [2021_combined_data]
WHERE
  start_lat IS NULL
  OR start_lng IS NULL
  OR end_lat IS NULL
  OR end_lng IS NULL;
--Null latitude and longitude values deleted.

------------------------------------------------------------------------------ANALYSIS---------------------------------------------------------------------------------
/*
 We need to start our analysis by determining the number of member and casual riders and which bike they prefer more.
 */
SELECT
  member_casual,
  rideable_type,
  count(*)
FROM
  [2021_combined_data]
GROUP BY
  member_casual,
  rideable_type;
/*
 There are 2468584 drivers that are members and there are 2007196 drivers that are casual.
 Member riders prefer classic bikes more than electric bikes. Classic = 1929291 Electric = 539293
 Also casual riders prefer classic bikes too. Classic = 1544585 Electric = 462611
 */
 
--Amount of rides per hour.
SELECT
  member_casual,
  datepart(
    HOUR
    FROM
      started_at
  ) AS time_of_day,
  count(*)
FROM
  [2021_combined_data]
GROUP BY
  member_casual,
  datepart(
    HOUR
    FROM
      started_at
  )
ORDER BY
  datepart(
    HOUR
    FROM
      started_at
  );

--Amount of rides per day.
SELECT
  member_casual,
  DAY,
  count(*)
FROM
(
    SELECT
      member_casual,
      CASE
        WHEN DATEPART(
          WEEKDAY
          FROM
            started_at
        ) = 1 THEN 'Sunday'
        WHEN DATEPART(
          WEEKDAY
          FROM
            started_at
        ) = 2 THEN 'Monday'
        WHEN DATEPART(
          WEEKDAY
          FROM
            started_at
        ) = 3 THEN 'Tuesday'
        WHEN DATEPART(
          WEEKDAY
          FROM
            started_at
        ) = 4 THEN 'Wednesday'
        WHEN DATEPART(
          WEEKDAY
          FROM
            started_at
        ) = 5 THEN 'Thursday'
        WHEN DATEPART(
          WEEKDAY
          FROM
            started_at
        ) = 6 THEN 'Friday'
        WHEN DATEPART(
          WEEKDAY
          FROM
            started_at
        ) = 7 THEN 'Saturday'
      END AS "day"
    FROM
      [2021_combined_data]
  ) days
GROUP BY
  member_casual,
  DAY;

--Amount of rides per month
SELECT
  member_casual,
  MONTH,
  count(*)
FROM
(
    SELECT
      member_casual,
      CASE
        WHEN DATEPART(
          MONTH
          FROM
            started_at
        ) = 1 THEN 'January'
        WHEN DATEPART(
          MONTH
          FROM
            started_at
        ) = 2 THEN 'February'
        WHEN DATEPART(
          MONTH
          FROM
            started_at
        ) = 3 THEN 'March'
        WHEN DATEPART(
          MONTH
          FROM
            started_at
        ) = 4 THEN 'April'
        WHEN DATEPART(
          MONTH
          FROM
            started_at
        ) = 5 THEN 'May'
        WHEN DATEPART(
          MONTH
          FROM
            started_at
        ) = 6 THEN 'June'
        WHEN DATEPART(
          MONTH
          FROM
            started_at
        ) = 7 THEN 'July'
        WHEN DATEPART(
          MONTH
          FROM
            started_at
        ) = 8 THEN 'August'
        WHEN DATEPART(
          MONTH
          FROM
            started_at
        ) = 9 THEN 'September'
        WHEN DATEPART(
          MONTH
          FROM
            started_at
        ) = 10 THEN 'October'
        WHEN DATEPART(
          MONTH
          FROM
            started_at
        ) = 11 THEN 'November'
        WHEN DATEPART(
          MONTH
          FROM
            started_at
        ) = 12 THEN 'December'
      END AS "month"
    FROM
      [2021_combined_data]
  ) months
GROUP BY
  member_casual,
  MONTH;

/*
 It also has 2,968,539 weekday data.
 */
SELECT
  member_casual,
  DAY
FROM
(
    SELECT
      member_casual,
      CASE
        WHEN DATEPART(
          WEEKDAY
          FROM
            started_at
        ) = 1 THEN 'Sunday'
        WHEN DATEPART(
          WEEKDAY
          FROM
            started_at
        ) = 2 THEN 'Monday'
        WHEN DATEPART(
          WEEKDAY
          FROM
            started_at
        ) = 3 THEN 'Tuesday'
        WHEN DATEPART(
          WEEKDAY
          FROM
            started_at
        ) = 4 THEN 'Wednesday'
        WHEN DATEPART(
          WEEKDAY
          FROM
            started_at
        ) = 5 THEN 'Thursday'
        WHEN DATEPART(
          WEEKDAY
          FROM
            started_at
        ) = 6 THEN 'Friday'
        WHEN DATEPART(
          WEEKDAY
          FROM
            started_at
        ) = 7 THEN 'Saturday'
      END AS "day"
    FROM
      [2021_combined_data]
  ) days
WHERE
  DAY IN (
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday'
  );

/*
 There is also 1,507,241 weekend data.
 */
SELECT
  member_casual,
  DAY
FROM
(
    SELECT
      member_casual,
      CASE
        WHEN DATEPART(
          WEEKDAY
          FROM
            started_at
        ) = 1 THEN 'Sunday'
        WHEN DATEPART(
          WEEKDAY
          FROM
            started_at
        ) = 2 THEN 'Monday'
        WHEN DATEPART(
          WEEKDAY
          FROM
            started_at
        ) = 3 THEN 'Tuesday'
        WHEN DATEPART(
          WEEKDAY
          FROM
            started_at
        ) = 4 THEN 'Wednesday'
        WHEN DATEPART(
          WEEKDAY
          FROM
            started_at
        ) = 5 THEN 'Thursday'
        WHEN DATEPART(
          WEEKDAY
          FROM
            started_at
        ) = 6 THEN 'Friday'
        WHEN DATEPART(
          WEEKDAY
          FROM
            started_at
        ) = 7 THEN 'Saturday'
      END AS "day"
    FROM
      [2021_combined_data]
  ) days
WHERE
  DAY IN ('Sunday', 'Saturday');

/*
 I want to analyze which seasons the demand for bicycles increases by dividing the months into seasons and quarters.
 */
SELECT
  Q1,
  Q2,
  Q3,
  Q4,
  count(*)
FROM
(
    SELECT
      member_casual,
      CASE
        WHEN DATEPART(
          MONTH
          FROM
            started_at
        ) = 12 THEN 'Winter'
        WHEN DATEPART(
          MONTH
          FROM
            started_at
        ) = 1 THEN 'Winter'
        WHEN DATEPART(
          MONTH
          FROM
            started_at
        ) = 2 THEN 'Winter'
      END AS "Q1",
      CASE
        WHEN DATEPART(
          MONTH
          FROM
            started_at
        ) = 3 THEN 'Spring'
        WHEN DATEPART(
          MONTH
          FROM
            started_at
        ) = 4 THEN 'Spring'
        WHEN DATEPART(
          MONTH
          FROM
            started_at
        ) = 5 THEN 'Spring'
      END AS "Q2",
      CASE
        WHEN DATEPART(
          MONTH
          FROM
            started_at
        ) = 6 THEN 'Summer'
        WHEN DATEPART(
          MONTH
          FROM
            started_at
        ) = 7 THEN 'Summer'
        WHEN DATEPART(
          MONTH
          FROM
            started_at
        ) = 8 THEN 'Summer'
      END AS "Q3",
      CASE
        WHEN DATEPART(
          MONTH
          FROM
            started_at
        ) = 9 THEN 'Autumn'
        WHEN DATEPART(
          MONTH
          FROM
            started_at
        ) = 10 THEN 'Autumn'
        WHEN DATEPART(
          MONTH
          FROM
            started_at
        ) = 11 THEN 'Autumn'
      END AS "Q4"
    FROM
      [2021_combined_data]
  ) months
GROUP BY
  Q1,
  Q2,
  Q3,
  Q4;
/*
 According to the results of my analysis, in the winter months: 292644, in the spring: 932564, in the summer: 1929394, in the autumn: 1321178.
 As I predicted, there is a significant increase in the number of rides, especially in the summer and autumn months.
 */
