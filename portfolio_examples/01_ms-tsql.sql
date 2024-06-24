/*
Peter Jungers
SQL Portfolio Examples 1
MS T-SQL
*/



USE TV
GO



PRINT 'Best SF?  [3pts possible]:
--------
Find the top rated family safe sci fi shows in the SHOW table. Include all shows where the Genre is sci fi, the 
StarRating is 8 or over, and the Classification is either G, PG, or PG-13. Use IN with a set of values to match
the Classification.

Produce the following columns: Title, Description, StarRating, Classification. Title should be no more than 20 
characters wide and Description should be no more than 50 characters wide. Classification should be no more
than 5 characters wide. Don''t forget to give all columns names!

Order in descending order by star rating. For shows with the same star rating, order by title alphabetically (A-Z).

Hint: Use the results in the previous query to determine the correct spelling for the sci fi genre.

Hint 2: Correct results will have 24 rows and will look like this (I did a bit of minor editing because
of apostrophes):

Title                Description                                        StarRating  Classification
-------------------- -------------------------------------------------- ----------- --------------
Avatar               On an alien planet, a former Marine (Sam Worthingt 10          PG-13
Gravity              The destruction of their shuttle leaves two astron 10          PG-13
Minority Report      A policeman (Tom Cruise) tries to establish his in 10          PG-13
Star Wars: The Force Thirty years after the defeat of the Galactic Empi 10          PG-13
The Day the Earth St Klaatu (Michael Rennie) and his guardian robot, Go 10          G    
Dawn of the Planet o Human survivors of a plague threaten Caesar''s gro 8           PG-13
Fantastic Planet     The 39-foot-tall pastel Draags keep leashes on the 8           PG   
Gattaca              An outcast (Ethan Hawke) takes part in a complicat 8           PG-13
Guardians of the Gal A space adventurer (Chris Pratt) becomes the quarr 8           PG-13
I Am Legend          After a man-made plague transforms Earth''s popula 8           PG-13
Independence Day     A fighter pilot (Will Smith), a computer whiz (Jef 8           PG-13
Interstellar         As mankind''s time on Earth comes to an end, a gro 8           PG-13
Invasion of the Body San Francisco health inspectors (Donald Sutherland 8           PG   
Midnight Special     The government and a group of religious extremists 8           PG-13
Pacific Rim          A washed-up ex-pilot (Charlie Hunnam) and an untes 8           PG-13
Rise of the Planet o A scientist''s (James Franco) quest to find a cur  8           PG-13
Serenity             Crew members (Nathan Fillion, Gina Torres, Alan Tu 8           PG-13
Solaris              A widowed psychologist (George Clooney) arrives at 8           PG-13
The Abyss            Oil-platform workers, including an estranged coupl 8           PG-13
The Fifth Element    A New York City cabdriver (Bruce Willis) tries to  8           PG-13
The Hunger Games     A resourceful teen (Jennifer Lawrence) takes her y 8           PG-13
The Hunger Games: Ca After their unprecedented victory in the 74th Hung 8           PG-13
Twilight Zone: The M Four tales include a bigot (Vic Morrow), oldsters  8           PG   
Westworld            Androids go haywire with guests (Richard Benjamin, 8           PG   
' + CHAR(10)

GO


SELECT CONVERT(varchar(20), Title) AS "Title",
    CONVERT(varchar(50), Description) AS "Description",
    StarRating,
    CONVERT(varchar(5), Classification) AS "Classification"
FROM SHOW
WHERE Genre = 'Science fiction'
    AND StarRating >= 8
    AND Classification IN ('G', 'PG', 'PG-13')
ORDER BY StarRating DESC, Title;

GO



PRINT 'Couch Potato Achievement  [3pts possible]:
------------------------
Produce a list of the 10 longest shows. Exclude sports-related genres and shows where the title 
is "To Be Announced" or "SIGN OFF". Format your results to look like this:

Channel Name Title                Episode              Date         Time                Length
------------ -------------------- -------------------- ------------ ------------------- --------
BBCAPH       Doctor Who           Deep Breath          Sep 08, 2017 04:30:00 - 12:30:00 08:00:00
BBCAPH       Doctor Who           Deep Breath          Sep 08, 2017 12:30:00 - 20:30:00 08:00:00
BBCAPH       Doctor Who           Deep Breath          Sep 08, 2017 20:30:00 - 04:30:00 08:00:00
CSPAN2       Public Affairs Event N/A                  Sep 08, 2017 21:00:00 - 05:00:00 08:00:00
CSPAN2       Book TV              N/A                  Sep 10, 2017 10:00:00 - 18:00:00 08:00:00
BBCAP        Doctor Who           Deep Breath          Sep 08, 2017 04:30:00 - 12:30:00 08:00:00
BBCAP        Doctor Who           Deep Breath          Sep 08, 2017 12:30:00 - 20:30:00 08:00:00
BBCAP        Doctor Who           Deep Breath          Sep 08, 2017 20:30:00 - 04:30:00 08:00:00
TVMRT        Beyond Today         N/A                  Sep 03, 2017 19:30:00 - 03:30:00 08:00:00
TVMRT        Beyond Today         N/A                  Sep 04, 2017 03:30:00 - 11:30:00 08:00:00

Hint: Use ISNULL to display NULL values in Episode as N/A, and restrict them to no more than 20
characters wide.
' + CHAR(10)

GO


SELECT TOP 10
    DisplayName AS "Channel Name",
    Title,
    ISNULL(CONVERT(varchar(20), EpisodeName), 'N/A') AS "Episode",
    CONVERT(varchar, StartTime, 107) AS "Date",
    CONVERT(varchar, StartTime, 8)
        + ' - '
        + CONVERT(varchar, EndTime, 8) AS "Time",
    CONVERT(varchar, (EndTime - StartTime), 8) AS "Length"
FROM all_data
WHERE NOT Genre LIKE '%[Ss]ports%'
    AND NOT Title IN ('To Be Announced', 'SIGN OFF')
ORDER BY  "Length" DESC;

GO
