/*
First of all, we need to connect 12 separate data sets of 2021 and turn them into a single table.
I created a new table with the same number of columns and the same column names as the datasets I have and ı named '[2021_combined_data]'.
Then ı connected the 12 month datasets together using union all.
*/

insert into [2021_combined_data]
select * from [2021Jan]
union all
select * from [2021Feb]
union all
select * from [2021Mar]
union all
select * from [2021Apr]
union all
select * from [2021May]
union all
select * from [2021Jun]
union all
select * from [2021Jul]
union all
select * from [2021Aug]
union all
select * from [2021Sep]
union all
select * from [2021Oct]
union all
select * from [2021Nov]
union all
select * from [2021Dec]

select * from [2021_combined_data];
/*
When we run the select query, it returns 5,595,063 rows. Since we use union all, all rows in the tables we include will be merged.
The columns in the [2021_combined_data] table will be pre-cleaned.
*/

/*
RIDE_ID
The first column we need to check is ride_id. Each value in the ride_id column must be 16 characters. 
Except for 16 character data, outliers are data. Also, each row must be unique.
*/

select 
len(ride_id),
count(*)
from [2021_combined_data]
group by len(ride_id);

select 
count(distinct ride_id)
from [2021_combined_data];

--There are 457 rows that are not 16 characters, this data needs to be cleaned and each row has a unique value.

/*
RIDEABLE_TYPE
Next column we need to check is rideable_type.
*/

select 
distinct rideable_type
from [2021_combined_data];

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

select 
ride_id,
started_at,
ended_at
from [2021_combined_data]
where ended_at < started_at;

select 
ride_id,
started_at,
ended_at,
Cast(ended_at - started_at as time)
from [2021_combined_data]
where Cast(ended_at - started_at as time) > '00:01:00';

select 
ride_id,
started_at,
ended_at,
Cast(ended_at - started_at as time)
from [2021_combined_data]
where DATEDIFF(MINUTE, started_at, ended_at) > 1440;

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

select 
start_station_name,
start_station_id
from [2021_combined_data]
where start_station_name is null and start_station_id is not null;


select * from [2021_combined_data] 
where start_station_name is null and start_station_id is null
or end_station_name is null and end_station_id is null;

select * from [2021_combined_data]
where start_station_name like '%temp%' or end_station_name like '%temp%';
--Regardless of the rideable_type, all rows with at least 1 null value should be deleted.

/*
LAT and LNG
Other columns to examine are the latitude and longitude columns.
*/

select * from [2021_combined_data]
where start_lat is null or start_lng is null
or end_lat is null or end_lng is null;

--Since these latitude and longitude values will be mapped later, null values need to be eliminated.

/*
MEMBER_CASUAL
The next column to be evaluated is the member_casual column and must contain two values. These are member and casual.
*/

select 
distinct member_casual
from [2021_combined_data];

--No values to delete were found in this column.
