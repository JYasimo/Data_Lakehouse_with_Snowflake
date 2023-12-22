--PART2 /QUESTION1
--In “table_youtube_category” which category_title has duplicates if we don’t take into account the categoryid?

SELECT category_title, country, COUNT (category_title)   
FROM table_youtube_category
GROUP BY category_title, country --we don’t take into account the categoryid 
HAVING COUNT(category_title)>1;

--Answer:Comedy