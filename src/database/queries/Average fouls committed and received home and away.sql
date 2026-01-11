SELECT 
    Team,
    COUNT(*) AS Games_Total,

    -- --- FOULS COMMITTED  ---
    ROUND(AVG(FoulsCommitted), 1) AS Avg_FoulsCommitted,
    ROUND(AVG(CASE WHEN Location = 'Home' THEN FoulsCommitted END), 1) AS Avg_FoulsCommitted_Home,
    ROUND(AVG(CASE WHEN Location = 'Away' THEN FoulsCommitted END), 1) AS Avg_Avg_FoulsCommitted_Away,

    -- --- FOULS RECEIVED  ---
    ROUND(AVG(FoulsReceived), 1) AS Avg_FoulsReceived,
    ROUND(AVG(CASE WHEN Location = 'Home' THEN FoulsReceived END), 1) AS Avg_FoulsReceived_Home,
    ROUND(AVG(CASE WHEN Location = 'Away' THEN FoulsReceived END), 1) AS Avg_FoulsReceived_Away

FROM (
-- 1. When Home: You Commit HF, You Receive AF
    SELECT 
    HomeTeam AS Team, 
    HF AS FoulsCommitted, 
    AF AS FoulsReceived, 
    'Home' AS Location 
    FROM premier_league
    
    UNION ALL

    -- 2. When Away: You Commit AF, You Receive HF
    SELECT 
    AwayTeam AS Team, 
    AF AS FoulsCommitted, 
    HF AS FoulsReceived, 
    'Away' AS Location 
    FROM premier_league
) AS AllMatches
GROUP BY Team
ORDER BY Avg_FoulsCommitted DESC;