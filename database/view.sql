-- Leaderboard view ordered by the net value of each player

CREATE VIEW leaderboard AS
SELECT
    P.Name AS 'name', 
    L.Name AS 'location', 
    P.Balance AS 'credits',
    COALESCE(GROUP_CONCAT(LB.Name, ', '), 'None') AS 'buildings', 
    (2 * COALESCE(SUM(B.TuitionFee), 0) + P.Balance) AS 'net_worth'
FROM Players P
INNER JOIN Locations L
    ON P.Location = L.ID
LEFT JOIN Buildings B
    ON B.Owner = P.Token
LEFT JOIN Locations LB
    ON B.ID = LB.ID
GROUP BY P.Name, P.Balance, L.Name
ORDER BY net_worth DESC;
