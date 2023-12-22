--PART2/QUESTION 7
--Create a new table called “table_youtube_duplicates”  containing only the “bad” duplicates by using the row_number() function.
CREATE TABLE table_youtube_duplicates AS (
WITH count_view AS (
    SELECT row_number() over (partition BY video_id,country,trending_date  ORDER BY view_count DESC) AS row_number,
    final.*
    FROM table_youtube_final AS final
    )
    SELECT * 
    FROM count_view
    WHERE row_number > 1
);

SELECT * 
FROM table_youtube_duplicates;