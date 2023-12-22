
/*assignment 1/ big data engineering
Student Name:Yasaman Mohammadi
Student ID:24612626

PART 3/Question 3
Question : For each country, year and month (in a single column), which video is the most viewed and what is its likes_ratio (defined as the percentage of likes against view_count) truncated to 2 decimals. Order the result by year_month and country. */
SELECT 
country,
DATE_TRUNC ('month', trending_date) AS year_month,
title,
channeltitle,
category_title,
sum(view_count) AS view__count, 
CAST(ROUND(SUM(likes * 100) / SUM(view_count), 2) AS VARCHAR(10)) AS likes_ratio --This ensures that the resulting string has trailing zeros in the decimal representation
FROM 
table_youtube_final
WHERE 
VIEW_COUNT IS NOT NULL AND VIEW_COUNT > 0
GROUP BY 
country,trending_date,title,channeltitle,category_title

QUALIFY row_number() over (partition BY year_month, country ORDER BY view__count DESC)=1;