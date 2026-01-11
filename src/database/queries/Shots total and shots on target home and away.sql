SELECT 
    Team,
    COUNT(*) AS Games_Total,
    
    -- --- TOTAL ---
    ROUND(AVG(Shots), 1) AS Avg_Shots_Total,
    ROUND(AVG(ShotsTarget), 1) AS Avg_Target_Total,
    
    -- --- HOME ---
    ROUND(AVG(CASE WHEN Location = 'Home' THEN Shots END), 1) AS Avg_Shots_Home,
    ROUND(AVG(CASE WHEN Location = 'Home' THEN ShotsTarget END), 1) AS Avg_Target_Home,
    
    -- --- AWAY ---
    ROUND(AVG(CASE WHEN Location = 'Away' THEN Shots END), 1) AS Avg_Shots_Away,
    ROUND(AVG(CASE WHEN Location = 'Away' THEN ShotsTarget END), 1) AS Avg_Target_Away

FROM (
    -- 1. When Home: Take Home Shots (HS) and Home Shots on Target (HST)
    SELECT 
    HomeTeam AS Team, 
    HS AS Shots, 
    HST AS ShotsTarget, 
    'Home' AS Location 
    FROM premier_league
    
    UNION ALL
    
    -- 2. When Away: Take Away Shots ("AS") and Away Shots on Target (AST)
    SELECT 
    AwayTeam AS Team, 
    "AS" AS Shots, 
    AST AS ShotsTarget, 
    'Away' AS Location 
    FROM premier_league
) AS AllMatches
GROUP BY Team
ORDER BY Avg_Target_Total DESC;