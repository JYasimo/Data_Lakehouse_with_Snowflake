--PART 2 /QUESTION 4
--QUESTION 4 Update the table_youtube_final to replace the NULL values in category_title with the answer from the previous question.
UPDATE table_youtube_final
SET category_title = 'Nonprofits & Activism'
WHERE category_title is NULL;