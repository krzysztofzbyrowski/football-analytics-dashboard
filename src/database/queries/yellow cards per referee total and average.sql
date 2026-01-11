SELECT 
    Referee, 
    COUNT(*) AS Games_Officiated,
    SUM(HY + AY) AS Total_Yellow_Cards,
    ROUND(AVG(HY + AY), 2) AS Avg_Yellow_Cards
FROM premier_league
GROUP BY Referee
ORDER BY Games_Officiated DESC;