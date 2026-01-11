SELECT 
    Team,
    -- TOTAL
    COUNT(*) AS Games_Total,
    ROUND(AVG(Goals), 2) AS Avg_Goals_Total,
    
    -- HOME
    SUM(CASE WHEN Location = 'Home' THEN 1 ELSE 0 END) AS Games_Home,
    ROUND(AVG(CASE WHEN Location = 'Home' THEN Goals END), 2) AS Avg_Goals_Home,
    
    -- AWAY
    SUM(CASE WHEN Location = 'Away' THEN 1 ELSE 0 END) AS Games_Away,
    ROUND(AVG(CASE WHEN Location = 'Away' THEN Goals END), 2) AS Avg_Goals_Away
FROM (
    SELECT HomeTeam AS Team, FTHG AS Goals, 'Home' AS Location 
    FROM premier_league
    UNION ALL
    SELECT AwayTeam AS Team, FTAG AS Goals, 'Away' AS Location 
    FROM premier_league
) AS AllMatches
GROUP BY Team
ORDER BY Avg_Goals_Total DESC;