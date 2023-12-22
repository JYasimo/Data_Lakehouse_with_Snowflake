--PART2/QUESTION 3
--Question3 :In “table_youtube_final”, what is the categoryid of the missing category_title?

SELECT categoryid ,category_title
FROM table_youtube_final
WHERE category_title IS NULL;

--ANSWER of Q3: CATEGORY 29

--Lets see category 29 represent which cat
SELECT DISTINCT categoryid, category_title 
FROM table_youtube_category;
--Answer:Nonprofits & Activism category title