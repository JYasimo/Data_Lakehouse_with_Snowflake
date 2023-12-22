/*Assignment 1/ big data engineering
Student Name:Yasaman Mohammadi
Student ID:24612626

Part 1*/

-- Create a new database called bde1
CREATE DATABASE bde1;


--switch to database assignment1
USE DATABASE bde1;

--Create a storage integration called bde1
CREATE STORAGE INTEGRATION azure_bde1
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = AZURE
  ENABLED = TRUE
  AZURE_TENANT_ID = 'e8911c26-cf9f-4a9c-878e-527807be8791'
  STORAGE_ALLOWED_LOCATIONS = ('azure://bdemohammadiyasaman.blob.core.windows.net/youtube');


  
-- Use the DESC STORAGE INTEGRATION command to retrieve the AZURE_CONSENT_URL
DESC STORAGE INTEGRATION azure_bde1;

----Create a Stage called  stage_bde1
CREATE OR REPLACE STAGE stage_bde1
STORAGE_INTEGRATION = azure_bde1
URL='azure://bdemohammadiyasaman.blob.core.windows.net/youtube';

--list all the files inside the storage
list @stage_bde1;

--Create an external table called ex_BR_youtube_trending
CREATE OR REPLACE EXTERNAL TABLE ex_BR_youtube_trending_columns_name
WITH LOCATION = @stage_bde1
FILE_FORMAT = (TYPE=CSV)
PATTERN = 'BR_youtube_trending_data.csv';

--Display the first rows of ex_BR_youtube_trending_columns_name
SELECT *
FROM bde1.PUBLIC.ex_BR_youtube_trending_columns_name
LIMIT 1;

--Parse the value into 16 columns as varchar and display the first row of ex_BR_youtube_trending_columns_name
SELECT
value:c1::varchar,
value:c2::varchar,
value:c3::varchar,
value:c4::varchar,
value:c5::varchar,
value:c6::varchar,
value:c7::varchar,
value:c8::varchar,
value:c9::varchar,
value:c10::varchar,
value:c11::varchar,
value:c12::varchar,
value:c13::varchar,
value:c14::varchar,
value:c15::varchar,
value:c16::varchar
FROM ex_BR_youtube_trending_columns_name
LIMIT 1;


-- Create a file format called file_format_csv 
CREATE OR REPLACE FILE FORMAT file_format_csv
TYPE = 'CSV'
FIELD_DELIMITER = ','
SKIP_HEADER = 1
NULL_IF = ('\\N', 'NULL', 'NUL', '')
FIELD_OPTIONALLY_ENCLOSED_BY = '"'
;

--Create an external table called ex_youtube_trending
CREATE OR REPLACE EXTERNAL TABLE ex_youtube_trending
WITH LOCATION = @stage_bde1
FILE_FORMAT = file_format_csv
PATTERN = '.*[.]csv';

--Display the first 10 rows of ex_youtube_trending:
SELECT *
FROM bde1.PUBLIC.ex_youtube_trending
LIMIT 10;

//Parse the value into 16 columns as
//c1 as a varchar as VIDEO_ID,
// c2 as a varchar as TITLE,
//c3 as a varchar as PUBLISHEDAT,
// c4 as a varchar as channelId,
// c5 as a varchar as channeltitle,
// c6 as a int as categoryId,
// c7 as a varchar as trending_date,
// c8 as a varchar as tags,
// c9 as a int as view_count,
// c10 as a int as likes,
// c11 as a int as dislikes,
// c12 as a int as comment_count,
// c13 as a varchar as thumbnail_link,
// c14 as a BOOLEAN as comments_disabled,
// c16 as a varchar as description,


CREATE OR REPLACE TABLE table_youtube_trending as
SELECT
value:c1::varchar as VIDEO_ID,
value:c2::varchar as TITLE,
value:c3::datetime as publishedat,
value:c4::varchar as channelId,
value:c5::varchar as channeltitle,
value:c6::int as categoryId,
value:c7::date as trending_date,
value:c8::int as view_count,
value:c9::int as likes,
value:c10::int as dislikes,
value:c11::int as comment_count,
value:c12::BOOLEAN as comments_disabled,
split_part(metadata$filename, '_', 1)::varchar as country -- extracting country name from each csv file name
FROM ex_youtube_trending;

-- see if the created table has correct format 
SELECT * 
FROM table_youtube_trending;


// table_youtube_category


---Create an external table called table_youtube_category
CREATE OR REPLACE EXTERNAL TABLE ex_table_youtube_category
WITH LOCATION = @stage_bde1
FILE_FORMAT = (TYPE=JSON)
PATTERN = '.*[.]json';

--Display the first rows of table_youtube_category
SELECT *
FROM bde1.PUBLIC.ex_table_youtube_category
LIMIT 1;

--Create a new table called'table_youtube_category'containing the correct data format
CREATE OR REPLACE TABLE table_youtube_category as 
SELECT 
split_part(metadata$filename, '_', 1)::varchar as country,
l.value:id::int as categoryid,
l.value:snippet:title::varchar as category_title
FROM ex_table_youtube_category,
LATERAL FLATTEN(value:items) l; --retrieving the columns from 'ex_table_youtube_category' by using Lateral Flatten function 

--checking the rows of table_youtube_category by Displaying them
SELECT * 
FROM table_youtube_category;

//Combining trending table and category table into one table called 'table_youtube_final' . 
//Adding a new field called 'id' 
CREATE OR REPLACE TABLE table_youtube_final as 
SELECT
UUID_STRING() as id,
video_id,
title,
publishedat,
channelid,
channeltitle,
tr.categoryid,
category_title,
trending_date,
view_count,
likes,
dislikes,
comment_count,
comments_disabled,
tr.country
FROM table_youtube_trending tr LEFT OUTER JOIN table_youtube_category cat ON (tr.country = cat.country and tr.categoryid = cat.categoryid);


--Display all the rows of the final table
SELECT * 
FROM table_youtube_final; 

--check the total record
SELECT count(*) FROM table_youtube_final;


-- the total record is equal to 1,175,478
