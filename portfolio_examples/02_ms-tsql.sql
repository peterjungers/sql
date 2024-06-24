/*
Peter Jungers
SQL Portfolio Examples 2
MS T-SQL
*/



-- The following four queries have aspects that relate to each other:



USE IMDB
GO



PRINT 'Popular Genres  [3pts possible]:
--------------
We will start with the IMDB database.

For each genre, show the total number of shows that are listed in that genre. Format genre as
15 characters wide. Order in descending order of popularity.

Correct results will have 28 rows and will look like this:

Genre           Count
--------------- -----------
Drama           1183422
Comedy          1049517
Short           670864
Documentary     499078
Talk-Show       452645
Romance         398779
Family          339665
News            338804
Animation       255212
Reality-TV      232633
...
Western         25128
War             20984
Film-Noir       852
' + CHAR(10)

GO


SELECT CAST(genre AS varchar(15)) AS "Genre",
    COUNT(*) AS "Count"
FROM title_genre
GROUP BY genre
ORDER BY "Count" DESC;

GO



PRINT 'Again Popular Genres  [3pts possible]:
--------------------
Repeat the query from Question 1, but this time express the popularity as a percentage of the total number 
of shows. Format the percentage to two decimal places and add a % sign to the end.

Hint: Start by adding the Total column to the SELECT clause. You''ll need to use a windowed function.
If you use ... OVER () that will window over the entire contents of the table. Once you have that working,
the percent is 100 * the expression that gives you Count / the expression that gives you Total. Use STR
to convert that to 6 characters with two digits after the decimal point, then add a % to the end.

Hint 2: Percent is a reserved keyword in SQL, so you''ll need to quote it if you want to use it as a column name.

Correct results will have 28 rows and look like this:

Genre           Count       Total       Percent
--------------- ----------- ----------- -------
Drama           1183422     7297619      16.22%
Comedy          1049517     7297619      14.38%
Short           670864      7297619       9.19%
Documentary     499078      7297619       6.84%
Talk-Show       452645      7297619       6.20%
Romance         398779      7297619       5.46%
Family          339665      7297619       4.65%
News            338804      7297619       4.64%
Animation       255212      7297619       3.50%
Reality-TV      232633      7297619       3.19%
...
Western         25128       7297619       0.34%
War             20984       7297619       0.29%
Film-Noir       852         7297619       0.01%
' + CHAR(10)

GO


SELECT CAST(genre AS varchar(15)) AS "Genre",
    COUNT(*) AS "Count",
    SUM(COUNT(*)) OVER (PARTITION BY 'Genre', 'Count') AS "Total",
    STR(COUNT(*) *
        CAST(100 AS DECIMAL) /
        SUM(COUNT(*)) OVER (PARTITION BY 'Genre', 'Count'),
    6, 2) + '%' AS "Percent"
FROM title_genre
GROUP BY genre
ORDER BY "Count" DESC;

GO



USE TV
GO



PRINT 'Popular Genres on TV  [3pts possible]:
--------------------
JOIN the SHOW table to the SCHEDULE table.

For each genre, calculate the total minutes spent airing shows in that genre.
Let''s switch to the TV database for the last two problems. Then, calculate the total
percent of time dedicated to that genre. Show the genre formatted to 20 characters wide,
the total number of minutes, and the percentage of minutes. Only include rows where
the total number of minutes was 1000 or more. Display in descending order by total minutes.
In the case of ties, order alphabetically by genre.

Hint: Review the hints and your answer to Question 2. Your calculation of the percentage
will be similar here.

Hint 2: Use DATEDIFF(mi, StartTime, EndTime) to get the total number of minutes that a show
was on. Total minutes will be the sum of those values for all the shows in a particular genre.

Correct results will have 88 rows that look like this:

Genre                Total Minutes Percent
-------------------- ------------- -------
Special              1257851        14.33%
Sports non-event     959388         10.93%
Reality              680033          7.75%
Children             412604          4.70%
Sitcom               393738          4.49%
Drama                377146          4.30%
Shopping             375642          4.28%
Sports event         362470          4.13%
Comedy               282608          3.22%
Crime drama          247615          2.82%
...
Baseball             1200            0.01%
Collectibles         1200            0.01%
Rodeo                1200            0.01%
Medical              1100            0.01%
' + CHAR(10)

GO


SELECT CAST(SHOW.Genre AS varchar(20)) AS "Genre",
    SUM(DATEDIFF(mi, SCHEDULE.StartTime, SCHEDULE.EndTime))
        AS "Total Minutes",
    STR(
        SUM(DATEDIFF(mi, SCHEDULE.StartTime, SCHEDULE.EndTime)) *
        CAST(100 AS DECIMAL) /
        SUM(SUM(DATEDIFF(mi, SCHEDULE.StartTime, SCHEDULE.EndTime)))
        OVER (PARTITION BY 'Total Minutes'),
    6, 2) + '%' AS "Percent"
FROM SCHEDULE
JOIN SHOW
    ON SHOW.ShowID = SCHEDULE.FK_ShowID
GROUP BY SHOW.Genre
HAVING SUM(DATEDIFF(mi, SCHEDULE.StartTime, SCHEDULE.EndTime)) >= 1000
ORDER BY "Total Minutes" DESC, "Genre";

GO



PRINT '0.4% of TV is SpongeBob SquarePants  [3pts possible]:
-----------------------------------
Do the same thing as in the previous query, except group by SeriesNum instead of Genre. This time, only show
series where the total minutes is 10,000 or more. Display the Title formatted to be 20 characters wide instead
of the genre.

Add another column for the total number of episodes aired.

Correct results will have 98 rows and look like this:

Title                Total Minutes Total Episodes Percent
-------------------- ------------- -------------- -------
MLB Extra Innings    258240        658             10.06%
Paid Programming     218507        7292             8.51%
NBA League Pass      103200        215              4.02%
MLS Direct Kick      100620        221              3.92%
College Football     73575         421              2.86%
MLB Baseball         69510         390              2.71%
Programa Pagado      54940         1792             2.14%
SIGN OFF             43025         119              1.68%
SportsCenter         36580         596              1.42%
Public Affairs Event 24362         93               0.95%
To Be Announced      23770         161              0.93%
2017 U.S. Open Tenni 23520         98               0.92%
Law & Order          22727         379              0.88%
Forensic Files       22140         738              0.86%
...
SpongeBob SquarePant 10295         353              0.40%
Politics and Public  10186         60               0.40%
SEC Now              10080         174              0.39%
Keeping Up With the  10080         172              0.39%
' + CHAR(10)

GO


SELECT CAST(SHOW.Title AS varchar(20)) AS "Title",
    SUM(DATEDIFF(mi, SCHEDULE.StartTime, SCHEDULE.EndTime))
        AS "Total Minutes",
    COUNT(SHOW.Title) AS "Total Episodes",
    STR(
        SUM(DATEDIFF(mi, SCHEDULE.StartTime, SCHEDULE.EndTime)) *
        CAST(100 AS DECIMAL) /
        SUM(SUM(DATEDIFF(mi, SCHEDULE.StartTime, SCHEDULE.EndTime)))
        OVER (PARTITION BY 'Total Minutes'),
    6, 2) + '%' AS "Percent"
FROM SCHEDULE
JOIN SHOW
    ON SHOW.ShowID = SCHEDULE.FK_ShowID
GROUP BY SHOW.Title, SHOW.SeriesNum
HAVING SUM(DATEDIFF(mi, SCHEDULE.StartTime, SCHEDULE.EndTime)) >= 10000
ORDER BY "Total Minutes" DESC;

GO
