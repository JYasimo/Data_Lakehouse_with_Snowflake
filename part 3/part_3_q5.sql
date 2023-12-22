/*assignment 1/ big data engineering
Student Name:Yasaman Mohammadi
Student ID:24612626

PART 3/Question 5
Which channeltitle has produced the most distinct videos and what is this number? 
*/
SELECT
    channeltitle,
    COUNT(DISTINCT video_id) AS total_distinct_videos
FROM
    table_youtube_final
GROUP BY
    channeltitle
ORDER BY
    total_distinct_videos DESC
LIMIT 1;

--Answer: Colors TV/806
