LOAD DATA
   APPEND INTO TABLE IMPORTCOMMENTS
   	(
   	IMPORTCOMMENTID INTEGER EXTERNAL TERMINATED BY "," ENCLOSED BY '"',
	LIBQUALRECID INTEGER EXTERNAL TERMINATED BY "," ENCLOSED BY '"',
   	COMMENTS CHAR TERMINATED BY "," ENCLOSED BY '"'
	)
