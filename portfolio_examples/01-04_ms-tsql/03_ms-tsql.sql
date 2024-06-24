/*
Peter Jungers
SQL Portfolio Examples 3
MS T-SQL
*/



USE DISCUSSIONS
GO



PRINT 'Popular Posts [3pts possible]:
-------------
For each post, show the title, content, date, total number of upvotes, total number of downvotes, and total karma 
(upvotes minus downvotes). Order in descending order of karma. If karma values are tied, order in descending order 
by total number of upvotes. Use subqueries in the SELECT clause, NO JOINS.

Use 30 characters for the title, 70 characters for the content, and 10 characters each for upvotes/downvotes/karma. 
Display Date as MM/DD/YYYY.

Hint: Match FK_PostID in the Ratings table in the subqueries to PostID in the Posts table in the outer query. 

Hint 2: To format upvotes/downvotes/karma, you can use something like:

     CONVERT(CHAR(10), ISNUL( (<subquery goes here>), 0)) AS "ColumnName"

Hint 3: Make sure your are sorting numerically by karma instead of alphabetically, and that the negative karma posts are
at the bottom! You may need to repeat the subquery for karma in the ORDER BY clause without converting to CHAR(10), and
you''ll need to use ISNULL to make sure that posts with no upvotes or downvotes are ranked using a karma value of 0 instead
of NULL (NULL comes after -1 but 0 comes before -1).

Title                          Content                                                                Date       Upvotes    Downvotes  Karma
------------------------------ ---------------------------------------------------------------------- ---------- ---------- ---------- ----------
The ominous (or not so ominous <p>Hardware - scary to some, but to others more fun than Christmas. I  11/29/2016 4          1          3         
Lesson#4 Discussion            <p>I don''t necessarily disagree with you, but that raises two questio 12/14/2016 3          0          3         
Download and set up successful <p>I got python and pycharm downloaded and running. but in pycharm the 10/04/2016 3          0          3         
How Much Is Too Much? --Jordon <p>Hey Fox, thanks for the response.</p><p>With a computer science rel 10/09/2016 3          0          3         
JavaScript Jobs                <p>I decided to search with JavaScript on indeed. I already know a bit 10/17/2016 3          0          3         
Viewpoint                      <p>I think that it''s essentially to have some basic knowledge on how  10/17/2016 2          0          2         
David Green                    <p>Hey classmates name is David I''m working on my CIS transfer degree 09/27/2016 2          0          2         
Objects....                    <p>Well I''m a little reluctant to upload my masterpiece, especially a 12/14/2016 2          0          2         
Lesson 7                       <p>Through this course, I have grown a deep respect for programmers. I 11/28/2016 2          0          2         
My Thoughts                    <p>Some of the characteristics and qualities that some need to be a ha 11/18/2016 2          0          2         
...
Simplicity                     <p>I usually don''t consider myself dumb, but I have trouble understan 11/06/2016 0          1          -1        
Arrays                         <p><img src="/d2l/le/150271/discussions/posts/7201029/ViewAttachment?f 12/14/2016 0          1          -1        
Lesson#4 Discussion            <p>Unfortunately I disagree with how much the class focused on Pseudoc 12/14/2016 0          1          -1             
' + CHAR(10)

GO


SELECT CAST(Title AS varchar(30)) AS "Title",
    CAST(Content AS varchar(70)) AS "Content",
    CONVERT(varchar, PostedDate, 101) AS "Date",
    CONVERT(varchar(10),
        ISNULL((
            SELECT SUM(Upvote)
            FROM Ratings
            WHERE FK_PostID = Posts.PostID
                AND Upvote > 0
        ), 0)
    ) AS "Upvotes",
    CONVERT(varchar(10),
        ISNULL((
            SELECT SUM(ABS(Upvote))
            FROM Ratings
            WHERE FK_PostID = Posts.PostID
                AND Upvote < 0
        ), 0)
    ) AS "Downvotes",
    CONVERT(varchar(10),
        ISNULL((
            SELECT SUM(Upvote)
            FROM Ratings
            WHERE FK_PostID = Posts.PostID
        ), 0)
    ) AS "Karma"
FROM Posts
ORDER BY CONVERT(int,
        ISNULL((
            SELECT SUM(Upvote)
            FROM Ratings
            WHERE FK_PostID = Posts.PostID
        ), 0)
    ) DESC, "Upvotes" DESC;

GO



PRINT 'Karma  [3pts possible]:
-----
For each user, show the username, the total number of posts made by that user, the total karma given to 
other users (sum of upvotes less downvotes given by the user), and total karma received (sum of upvotes
less downvotes received on posts made by that user). Use subqueries in the FROM/JOIN clauses (it
is possible to write this using subqueries in the SELECT clause, but use the subqueries in FROM/JOIN
instead). It is OK to use JOINs for this one (it''s impossible to write this query without both JOINs
and subqueries).

Format username as 20 characters wide and the other values as 10 characters wide. Order in descending 
order by total posts, then by total karma received, then by total karma given.

Hint: Start by writing separate queries to calculate total posts, total karma given and total karma 
received. Then, use those queries as subqueries in a SELECT statement that JOINs all those tables with
the Users table. Use outer JOINs to make sure that all users make it into the final list, even if those
users have no posts, and have given or received no upvotes.

Correct answers will have 21 rows and will look like this:

Username             Total Posts Total Karma Given Total Karma Received
-------------------- ----------- ----------------- --------------------
Alan.Turing          35          12                7         
jordon.fuchs         14          3                 5         
scott.ashley         12          8                 9         
matthew.johnson      12          5                 5         
solomon.oconnor      10          7                 4         
mohammad.abduallah   9           5                 7         
melissa.aizawa       9           1                 6         
dorothy.emmerson     9           3                 3         
brian.smith          7           3                 2         
...      
william.kareda       1           0                 1         
dick.phelps          1           1                 0         
jason.tyler          1           1                 0         
' + CHAR(10)

GO


SELECT CAST(Username AS varchar(20)) AS "Username",
    CONVERT(varchar(10), ISNULL(("Total Posts"), 0))
        AS "Total Posts",
    CONVERT(varchar(10), ISNULL(("Total Karma Given"), 0))
        AS "Total Karma Given",
    CONVERT(varchar(10), ISNULL(("Total Karma Received"), 0))
        AS "Total Karma Received"
FROM Users
LEFT JOIN (
        SELECT DISTINCT FK_UserID,
            COUNT(FK_UserID) OVER (PARTITION BY FK_UserID)
                AS "Total Posts"
        FROM Posts
    ) AS "Post Count"
    ON Users.UserID = "Post Count".FK_UserID
LEFT JOIN (
        SELECT FK_UserID,
            SUM(Upvote) AS "Total Karma Given"
        FROM Ratings
        GROUP BY FK_UserID
    ) AS "Given Count"
    ON Users.UserID = "Given Count".FK_UserID
LEFT JOIN (
        SELECT Posts.FK_UserID,
            SUM(Ratings.Upvote) AS "Total Karma Received"
        FROM Posts
        JOIN Ratings
            ON Ratings.FK_PostID = Posts.PostID
        WHERE Ratings.FK_PostID = Posts.PostID
        GROUP BY Posts.FK_UserID
    ) AS "Received Count"
    ON Users.UserID = "Received Count".FK_UserID
WHERE "Total Posts" > 0
ORDER BY CAST("Total Posts" AS int) DESC,
    CAST("Total Karma Received" AS int) DESC,
    CAST("Total Karma Given" AS int) DESC,
    Username;
    
GO
