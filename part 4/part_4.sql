/*assignment 1/ big data engineering
Student Name:Yasaman Mohammadi
Student ID:24612626

PART 4/part 1
If you were to launch a new Youtube channel tomorrow, which category (
excluding “Music” and “Entertainment”) of video will you be trying to create to have them appear in the top trend of Youtube? 
Will this strategy work in every country?*/
SELECT
  category_title,
  SUM(view_count) AS total_view_count,
  ROUND(sum(likes)*100/sum(view_count),2) as Likes_ratio
FROM
  table_youtube_final
GROUP BY
  category_title
ORDER BY
  total_view_count DESC;

/*Answer: With the exception of "Music" and "Entertainment", the best category to appear in
 top trends is "Gaming". This strategy will be tested in the following part to determine whether it is also successful in other countries. */


 --PART 4/part 2

 WITH ranked_categories AS (
    SELECT
        country,
        category_title,
        SUM(view_count) AS total_view_count,
        ROUND(SUM(likes) * 100 / SUM(view_count), 2) AS Likes_ratio,
        ROUND(SUM(likes) / SUM(dislikes), 2) AS Likes_vs_dislikes_ratio,
        AVG(TIMESTAMPDIFF(DAY, publishedAt, trending_date)) AS mean_time_to_trend_in_days,
        ROW_NUMBER() OVER (PARTITION BY country ORDER BY SUM(view_count) DESC) AS category_rank
    FROM
        table_youtube_final
    WHERE
        country IN ('BR', 'US', 'CA', 'DE', 'FR', 'GB', 'IN', 'JP', 'KR', 'MX', 'RU')
        AND category_title NOT IN ('Music', 'Entertainment')
    GROUP BY
        country, category_title
)
SELECT
    country,
    category_title,
    total_view_count,
    Likes_ratio,
    Likes_vs_dislikes_ratio,
    mean_time_to_trend_in_days
FROM
    ranked_categories
WHERE
    category_rank <= 2
ORDER BY
    country ASC, total_view_count DESC;

/*Selecting the "Gaming" category on YouTube will not always result in your video appearing in the top trending videos in every country. Excluding "Music" and "Entertainment", some countries have different preferences, 
such as DE, IN, JP and KR, where "People and Blogs" is the top trend category after music and entertainment. Therefore, "People and Blogs" would be a better choice to appear in top trends in these countries.
--Since likes vs dislikes ratios are also important, this factor should be taken into consideration as well. In IN, JP, RU and DE, the like vs dislike ratios of "People and Blogs" are lower than "Gaming", suggesting 
that people are more likely to like "Gaming" category. However, in KR, both view counts and like vs dislike ratios are higher for the "People and Blogs" category."*/
