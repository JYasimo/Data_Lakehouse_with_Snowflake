
/*assignment 1/ big data engineering
Student Name:Yasaman Mohammadi
Student ID:24612626

PART 3/Question 4
For each country, which category_title has the most distinct videos and what is its percentage (2 decimals) out of the total distinct number of videos of that country? Order the result by category_title and country.*/
SELECT 
cat.country, 
category_title, 
total_category_video, 
total_country_video,
ROUND((total_category_video*100/total_country_video),2) AS percentage
FROM (
    SELECT
    country, 
    category_title,
    COUNT(DISTINCT video_id) AS total_category_video FROM table_youtube_final GROUP BY country, category_title) cat -- cat: category videos

LEFT JOIN ( --returns all records from the left table (first table), and the matching records from the right table
    SELECT 
    country, 
    COUNT(DISTINCT video_id) AS total_country_video
    FROM 
    table_youtube_final
    GROUP BY country) cv --cv:country videos
    ON 
cat.country = cv.country
QUALIFY row_number() over (partition BY cat.country ORDER BY percentage DESC)=1;