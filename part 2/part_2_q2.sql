--PART2/QUESTION 2
--In “table_youtube_category” which category_title only appears in one country?

SELECT category_title, COUNT(country)
FROM table_youtube_category
GROUP BY category_title
HAVING COUNT(country) =1;
--Answer:Nonprofits & Activism
--finding the country
SELECT category_title,country
FROM table_youtube_category
WHERE category_title = 'Nonprofits & Activism';
--US is the only country that has this category