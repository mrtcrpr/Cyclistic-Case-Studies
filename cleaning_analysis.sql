---------------------------------------------------------------------------------CLEAN---------------------------------------------------------------------------------
/*
RIDE_ID
We need to clean 457 rows that are not 16 characters.
*/
delete from [2021_combined_data]
where len(ride_id) != 16;
-- 457 rows cleaned.

/*
RIDEABLE_TYPE
We will convert docked_bike to classic_bike. Because these are same thing.
*/
update [2021_combined_data] 
set rideable_type = 'classic_bike'
where rideable_type = 'docked_bike';
-- 312316 docked_bike rows converted to classic_bike.

/*
STARTED_AT and ENDED_AT
If you remember, we need to delete some lines.
In these lines, some ended_at data has an earlier date than started_at data.
*/
delete from [2021_combined_data]
where ended_at <= started_at;
-- 653 rows deleted.
-- In addition, driving times should not be less than 1 minute and more than 1 day. Such values are outliers.
delete from [2021_combined_data]
where cast(ended_at - started_at as time) < '00:01:00';
-- 84577 rows deleted for driving times less than 1 minute.

delete from [2021_combined_data]
where DATEDIFF(MINUTE, started_at, ended_at) > 1440;
-- 4012 rows deleted for driving times more than 1 day.


/*
START_STATION_NAME and START_STATION_ID and END_STATION_NAME and END_STATION_ID
We have a lot off null values of these columns. 
Regardless of the rideable_type, this data needs to be deleted.
Also there is 3 missing rows. It should be fixed. 
And we have 'Temp' values trailing of the station names. We need to delete this rows.
*/
update [2021_combined_data]
set start_station_name = 'Wood St & Milwaukee Ave'
where start_station_id = '13221';

update [2021_combined_data]
set start_station_name = 'Hegewisch Metra Station'
where start_station_id = '20215';

update [2021_combined_data]
set start_station_name = 'Clinton St & Roosevelt Rd'
where start_station_id = 'WL-008';
-- 3 missing rows fixed.

delete from [2021_combined_data]
where start_station_name is null or start_station_id is null
or end_station_name is null or end_station_id is null;
-- At least 1 null value in these columns has been deleted.

delete from [2021_combined_data]
where start_station_name like '%temp%' or end_station_name like '%temp%';
-- 47307 'Temp' rows deleted from start and end station names. 


/*
START_LAT and START_LNG and END_LAT and END_LNG
These columns have some null values. These null values need to be deleted.
*/
delete from [2021_combined_data]
where start_lat is null or start_lng is null
or end_lat is null or end_lng is null;
--Null latitude and longitude values deleted.

------------------------------------------------------------------------------ANALYSIS---------------------------------------------------------------------------------
/*
We need to start our analysis by determining the number of member and casual riders and which bike they prefer more.
*/
select  
member_casual,
rideable_type,
count(*)
from [2021_combined_data]
group by member_casual, rideable_type;
/*
There are 2468584 drivers that are members and there are 2007196 drivers that are casual.
Member riders prefer classic bikes more than electric bikes. Classic = 1929291 Electric = 539293
Also casual riders prefer classic bikes too. Classic = 1544585 Electric = 462611
*/

--Amount of rides per hour.
select member_casual,
datepart(HOUR from started_at) as time_of_day,
count(*)
from [2021_combined_data]
group by member_casual, datepart(HOUR from started_at)
order by datepart(HOUR from started_at);

--Amount of rides per day.
select member_casual,
day,
count(*)
from(
select 
member_casual,
case
when DATEPART(WEEKDAY from started_at) = 1 then 'Sunday'
when DATEPART(WEEKDAY from started_at) = 2 then 'Monday'
when DATEPART(WEEKDAY from started_at) = 3 then 'Tuesday'
when DATEPART(WEEKDAY from started_at) = 4 then 'Wednesday'
when DATEPART(WEEKDAY from started_at) = 5 then 'Thursday'
when DATEPART(WEEKDAY from started_at) = 6 then 'Friday'
when DATEPART(WEEKDAY from started_at) = 7 then 'Saturday'
end as "day"
from [2021_combined_data]
) days
group by member_casual, day;

--Amount of rides per month
select member_casual,
month,
count(*)
from(
select 
member_casual,
case
when DATEPART(MONTH from started_at) = 1 then 'January'
when DATEPART(MONTH from started_at) = 2 then 'February'
when DATEPART(MONTH from started_at) = 3 then 'March'
when DATEPART(MONTH from started_at) = 4 then 'April'
when DATEPART(MONTH from started_at) = 5 then 'May'
when DATEPART(MONTH from started_at) = 6 then 'June'
when DATEPART(MONTH from started_at) = 7 then 'July'
when DATEPART(MONTH from started_at) = 8 then 'August'
when DATEPART(MONTH from started_at) = 9 then 'September'
when DATEPART(MONTH from started_at) = 10 then 'October'
when DATEPART(MONTH from started_at) = 11 then 'November'
when DATEPART(MONTH from started_at) = 12 then 'December'
end as "month"
from [2021_combined_data]
) months
group by member_casual, month;

/*
It also has 2,968,539 weekday data.
*/
select member_casual,
day
from(
select 
member_casual,
case
when DATEPART(WEEKDAY from started_at) = 1 then 'Sunday'
when DATEPART(WEEKDAY from started_at) = 2 then 'Monday'
when DATEPART(WEEKDAY from started_at) = 3 then 'Tuesday'
when DATEPART(WEEKDAY from started_at) = 4 then 'Wednesday'
when DATEPART(WEEKDAY from started_at) = 5 then 'Thursday'
when DATEPART(WEEKDAY from started_at) = 6 then 'Friday'
when DATEPART(WEEKDAY from started_at) = 7 then 'Saturday'
end as "day"
from [2021_combined_data]
) days
where day in ('Monday','Tuesday','Wednesday','Thursday','Friday');

/*
There is also 1,507,241 weekend data.
*/
select member_casual,
day
from(
select 
member_casual,
case
when DATEPART(WEEKDAY from started_at) = 1 then 'Sunday'
when DATEPART(WEEKDAY from started_at) = 2 then 'Monday'
when DATEPART(WEEKDAY from started_at) = 3 then 'Tuesday'
when DATEPART(WEEKDAY from started_at) = 4 then 'Wednesday'
when DATEPART(WEEKDAY from started_at) = 5 then 'Thursday'
when DATEPART(WEEKDAY from started_at) = 6 then 'Friday'
when DATEPART(WEEKDAY from started_at) = 7 then 'Saturday'
end as "day"
from [2021_combined_data]
) days
where day in ('Sunday','Saturday');

/*
I want to analyze which seasons the demand for bicycles increases by dividing the months into seasons and quarters.
*/
select Q1,
Q2,
Q3,
Q4,
count(*)
from(
select 
member_casual,
case 
when DATEPART(MONTH from started_at) = 12 then 'Winter'
when DATEPART(MONTH from started_at) = 1 then 'Winter'
when DATEPART(MONTH from started_at) = 2 then 'Winter'
end as "Q1",
case
when DATEPART(MONTH from started_at) = 3 then 'Spring'
when DATEPART(MONTH from started_at) = 4 then 'Spring'
when DATEPART(MONTH from started_at) = 5 then 'Spring'
end as "Q2",
case
when DATEPART(MONTH from started_at) = 6 then 'Summer'
when DATEPART(MONTH from started_at) = 7 then 'Summer'
when DATEPART(MONTH from started_at) = 8 then 'Summer'
end as "Q3",
case
when DATEPART(MONTH from started_at) = 9 then 'Autumn'
when DATEPART(MONTH from started_at) = 10 then 'Autumn'
when DATEPART(MONTH from started_at) = 11 then 'Autumn'
end as "Q4"
from [2021_combined_data]
) months
group by Q1,Q2, Q3, Q4;
/*
According to the results of my analysis, in the winter months: 292644, in the spring: 932564, in the summer: 1929394, in the autumn: 1321178.
As I predicted, there is a significant increase in the number of rides, especially in the summer and autumn months.
*/
