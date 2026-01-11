SELECT 
    Team,
    -- TOTAL
    COUNT(*) AS Games_Total,
    ROUND(AVG(YellowCards), 2) AS Avg_YellowCards_Total,
    
    -- HOME
    SUM(CASE WHEN Location = 'Home' THEN 1 ELSE 0 END) AS Games_Home,
    ROUND(AVG(CASE WHEN Location = 'Home' THEN YellowCards END), 2) AS Avg_YellowCards_Home,
    
    -- AWAY
    SUM(CASE WHEN Location = 'Away' THEN 1 ELSE 0 END) AS Games_Away,
    ROUND(AVG(CASE WHEN Location = 'Away' THEN YellowCards END), 2) AS Avg_YellowCards_Away
FROM (
    SELECT 
    HomeTeam AS Team, 
    HY AS YellowCards, 
    'Home' AS Location 
    FROM premier_league
    UNION ALL
    SELECT 
    AwayTeam AS Team, 
    AY AS YellowCards, 
    'Away' AS Location 
    FROM premier_league
) AS AllMatches
GROUP BY Team
ORDER BY Avg_YellowCards_Total DESC;