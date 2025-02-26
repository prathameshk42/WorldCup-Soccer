use phk7955;
-- Section 1
SELECT W.Country, W.Year, M.City AS Place
FROM worldcups W
JOIN worldcupmatches M ON W.Year = M.Year
WHERE W.Country = (
    SELECT Winner
    FROM worldcups
    GROUP BY Winner
    ORDER BY COUNT(Winner) DESC
    LIMIT 1);

-- Section 2
SELECT
    M.Year,
    P.PlayerName,
    P.TeamInitials,
    SUM(P.Event LIKE '%G%') AS GoalsScored
FROM worldcupmatches M
JOIN worldcupplayers P ON M.MatchID = P.MatchID
WHERE M.WinConditions LIKE '%Win%'
GROUP BY M.Year, P.PlayerName, P.TeamInitials
HAVING GoalsScored = (
    SELECT MAX(GoalsScored)
    FROM (
        SELECT
            M.Year,
            P.PlayerName,
            P.TeamInitials,
            SUM(P.Event LIKE '%G%') AS GoalsScored
        FROM worldcupmatches M
        JOIN worldcupplayers P ON M.MatchID = P.MatchID
        WHERE M.WinConditions LIKE '%Win%'
        GROUP BY M.Year, P.PlayerName, P.TeamInitials
    ) AS GoalCounts
);

-- Section 3
SELECT
    M.Year,
    P.PlayerName,
    MAX(GoalsScored) AS MaxGoalsScored
FROM worldcupmatches M
JOIN (
    SELECT
        MatchID,
        PlayerName,
        SUM(CASE WHEN Event LIKE 'G%' THEN 1 ELSE 0 END) AS GoalsScored
    FROM worldcupplayers
    GROUP BY MatchID, PlayerName
) P ON M.MatchID = P.MatchID
GROUP BY M.Year, P.PlayerName
Order By MaxGoalsScored Desc;

-- Section 4
SELECT WC.Country, COUNT(*) AS ParticipationCount
FROM worldcups AS WC
JOIN worldcupmatches AS M ON WC.Year = M.Year
WHERE WC.Year >= 2000 AND WC.Year <= 2099
GROUP BY WC.Country
ORDER BY ParticipationCount DESC
LIMIT 1;

-- Section 5
SELECT COUNT(DISTINCT Year) AS Qualifications FROM worldcups where Country='USA';

-- Section 6
SELECT Count(MatchID) as Total_Matches FROM worldcupmatches Where AwayTeamName='USA';

-- Section 7
SELECT Team, SUM(TotalGoals) AS TotalGoalsScored
FROM (
    SELECT HomeTeamName AS Team, HomeTeamGoals AS TotalGoals
    FROM worldcupmatches
    UNION ALL
    SELECT AwayTeamName AS Team, AwayTeamGoals AS TotalGoals
    FROM worldcupmatches
) AS CombinedGoals
GROUP BY Team
ORDER BY TotalGoalsScored DESC
LIMIT 1;

-- Section 8
SELECT City, COUNT(*) AS HostedGames
FROM worldcupmatches
GROUP BY City
ORDER BY HostedGames DESC 
Limit 1;

-- Section 9
SELECT WM.Year, WM.Stage, WM.Stadium, WM.City, WM.HomeTeamName, WM.HomeTeamGoals, WM.AwayTeamGoals, WM.AwayTeamName
FROM worldcupmatches WM
WHERE WM.HomeTeamName = 'Brazil' OR WM.AwayTeamName = 'Brazil';

-- Section 10
SELECT
    P.PlayerName,
    M.HomeTeamName AS Country,
    SUM(CASE WHEN P.Event LIKE 'G%' THEN 1 ELSE 0 END) AS GoalsScored
FROM worldcupplayers P
JOIN worldcupmatches M ON P.MatchID = M.MatchID
GROUP BY P.PlayerName, M.HomeTeamName
HAVING GoalsScored > 0
ORDER BY GoalsScored DESC;

-- Section 11
SELECT
    P.PlayerName,
    M.HomeTeamName AS Country,
    SUM(CASE WHEN P.Event LIKE 'G%' THEN 1 ELSE 0 END) AS GoalsScored
FROM worldcupplayers P
JOIN worldcupmatches M ON P.MatchID = M.MatchID
GROUP BY P.PlayerName, M.HomeTeamName
HAVING GoalsScored > 2
ORDER BY GoalsScored DESC;

-- Section 12
SELECT W.Country, SUM(M.Attendance) AS Population
FROM worldcupmatches AS M
INNER JOIN worldcups AS W ON M.Year = W.Year
GROUP BY W.Country
ORDER BY Population DESC;
