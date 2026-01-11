SELECT 
    Team,
    -- TOTAL
    COUNT(*) AS Games_Total,
    ROUND(AVG(GoalsConceded), 2) AS Avg_Conceded_Total,
    
    -- HOME
    SUM(CASE WHEN Location = 'Home' THEN 1 ELSE 0 END) AS Games_Home,
    ROUND(AVG(CASE WHEN Location = 'Home' THEN GoalsConceded END), 2) AS Avg_Conceded_Home,
    
    -- AWAY
    SUM(CASE WHEN Location = 'Away' THEN 1 ELSE 0 END) AS Games_Away,
    ROUND(AVG(CASE WHEN Location = 'Away' THEN GoalsConceded END), 2) AS Avg_Conceded_Away
FROM (
    -- 1. When Home, you concede the AWAY team's goals (FTAG)
    SELECT HomeTeam AS Team, FTAG AS GoalsConceded, 'Home' AS Location 
    FROM premier_league
    
    UNION ALL
    
    -- 2. When Away, you concede the HOME team's goals (FTHG)
    SELECT AwayTeam AS Team, FTHG AS GoalsConceded, 'Away' AS Location 
    FROM premier_league
) AS AllMatches
GROUP BY Team
ORDER BY Avg_Conceded_Total DESC;