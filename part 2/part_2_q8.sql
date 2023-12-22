//PART 2/QUESTION 8
--Delete the duplicates in “table_youtube_final“ by using “table_youtube_duplicates”

DELETE 
FROM table_youtube_final
USING table_youtube_duplicates
WHERE table_youtube_final.id = table_youtube_duplicates.id;