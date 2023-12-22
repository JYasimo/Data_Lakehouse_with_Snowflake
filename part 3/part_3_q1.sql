/*assignment 1/ big data engineering
Student Name:Yasaman Mohammadi
Student ID:24612626

PART 3/Question 1
What are the 3 most viewed videos for each country in the “Sports” category for the trending_date = ‘'2021-10-17'’. Order the result by country and the rank */

SELECT *
FROM (
    SELECT country, 
    title, 
    channeltitle, 
    view_count,
    row_number() over (partition BY country ORDER BY view_count DESC) AS RK
    FROM 
    table_youtube_final
    WHERE
    category_title = 'Sports' AND trending_date = '2021-10-17'
)
WHERE RK <=3;