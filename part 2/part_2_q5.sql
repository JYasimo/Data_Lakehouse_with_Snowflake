--PART 2/QUESTION 5
--In “table_youtube_final”, which video doesn’t have a channeltitle?
SELECT
video_id,
title,
channeltitle
FROM 
table_youtube_final
WHERE
channeltitle IS NULL;

--VIDEO ID:9b9MovPPewk
--ANSWER:Kala Official Teaser | Tovino Thomas | Rohith V S | Juvis Productions | Adventure Company