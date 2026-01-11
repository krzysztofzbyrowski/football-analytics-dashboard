SELECT 
    Team,
    COUNT(*) AS Games_Total,

    -- --- CORNERS MADE (Attack) ---
    ROUND(AVG(CornersMade), 1) AS Avg_Made_Total,
    ROUND(AVG(CASE WHEN Location = 'Home' THEN CornersMade END), 1) AS Avg_Made_Home,
    ROUND(AVG(CASE WHEN Location = 'Away' THEN CornersMade END), 1) AS Avg_Made_Away,

    -- --- CORNERS CONCEDED (Defense) ---
    ROUND(AVG(CornersConceded), 1) AS Avg_Conceded_Total,
    ROUND(AVG(CASE WHEN Location = 'Home' THEN CornersConceded END), 1) AS Avg_Conceded_Home,
    ROUND(AVG(CASE WHEN Location = 'Away' THEN CornersConceded END), 1) AS Avg_Conceded_Away

FROM (
    -- 1. When Home: You Make HC, You Concede AC
    SELECT HomeTeam AS Team, HC AS CornersMade, AC AS CornersConceded, 'Home' AS Location 
    FROM premier_league
    
    UNION ALL
    
    -- 2. When Away: You Make AC, You Concede HC
    SELECT AwayTeam AS Team, AC AS CornersMade, HC AS CornersConceded, 'Away' AS Location 
    FROM premier_league
) AS AllMatches
GROUP BY Team
ORDER BY Avg_Made_Total DESC;