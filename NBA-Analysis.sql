-- Overview of our Tables

SELECT * 
FROM [NBA-Analysis]..PlayerPerGame

SELECT * 
FROM [NBA-Analysis]..PlayerSeasonInfo

SELECT * 
FROM [NBA-Analysis]..PlayerTotals

SELECT * 
FROM [NBA-Analysis]..TeamStatsPerGame

SELECT *
FROM [NBA-Analysis]..NBA_2025_Shots

SELECT *
FROM [NBA-Analysis]..TeamSummaries



-- Visualization Query: Top 10 Unique Scorers in the 2024-2025 Season
WITH RankedPlayers AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY player ORDER BY pts_per_game DESC) AS rn
    FROM [NBA-Analysis]..PlayerPerGame
    WHERE season = 2025
)
SELECT TOP 10 player, ROUND(pts_per_game, 2) AS pts_per_game
FROM RankedPlayers
WHERE rn = 1
ORDER BY pts_per_game DESC;

-- Takeaway: The top 3 scorers — Shai Gilgeous-Alexander, Giannis Antetokounmpo, 
-- and Nikola Jokić — were also top contenders in 2024–25 MVP voting, highlighting
-- how elite scoring output is closely tied to MVP recognition.




-- Non-Visualization Query: Top 10 True Shooting (TS) Percentages 2024-2025 Season (Minimum 450 Shot Attempts)
SELECT TOP 10 player, pos, pts, fga, fg_percent, fta, ft_percent, CAST(ROUND(pts * 1.0 / (2 * (fga + 0.44 * fta)), 3) AS FLOAT) * 100 AS ts_percent
FROM [NBA-Analysis]..PlayerTotals
WHERE season = 2025 AND (fga + 0.44 * fta) > 450
ORDER BY ts_percent DESC

-- Takeaways: Centers like Jarrett Allen, Daniel Gafford, etc. seem to dominate in TS%
-- due to efficient scoring near the rim and solid free throw percentages.




-- Non-Visualization Query: Team Scoring Trends Over Time
SELECT team, season, ROUND(pts_per_game, 2) as pts_per_game, pts_per_game - LAG(pts_per_game) OVER (PARTITION BY team ORDER BY season) AS ppg_change
FROM [NBA-Analysis]..TeamStatsPerGame
WHERE season BETWEEN 2020 AND 2025


-- Takeaways: Most teams had relatively stable scoring trends (±3 PPG).
-- Notable insights include:

-- Oklahoma City Thunder: +13.8 jump in 2023 suggests a breakout year.

-- Portland Trailblazers: -9.9 in 2022 and -7 declines which is 
-- largely due to Damian Lillard’s extended absence from injury in 2022
-- followed by the Lillard trade in 2024. This significant decline reflects
-- the team's reliance on Lillard as their primary offensive engine.

-- Charlotte Hornets: steady decline from 115.3 (2022) to 105.1 (2025).




-- Visualization Query: Player Scoring Over Time
SELECT season, player, ROUND(pts_per_game, 2) AS pts_per_game, pts_per_game - LAG(pts_per_game) OVER (PARTITION BY player ORDER BY season) AS ppg_change
FROM [NBA-Analysis]..PlayerPerGame
WHERE season BETWEEN 2020 AND 2025 AND player IN ('Anthony Edwards', 'LeBron James', 'Shai Gilgeous-Alexander')

-- Takeaways:

-- Anthony Edwards: Showed steady offensive growth, reflecting his evolution
-- from a young talent to a primary scoring option for the Timberwolves

-- LeBron James: Despite aging, James has maintained elite-level scoring. 
-- However, his steady decline from 2022 to 2025 suggests that his age
-- may finally be catching up to him.

-- Shai Gilgeous-Alexander: Experienced a dramatic scoring breakout from 19.0 PPG
-- in 2020 to 32.7 PPG in 2025. His significant jumps in scoring highlights his
-- emergence as one of the league's top offensive weapons, culminating in 
-- an MVP award in 2025.




-- Visualization Query: Shot Percentage Per Zone Range by Each Team
SELECT TEAM_NAME, ZONE_RANGE, ROUND((CAST(COUNT(CASE WHEN SHOT_MADE = 1 THEN 1 END) AS FLOAT) / COUNT(*)) * 100, 2) AS SHOT_PERCENTAGE,
    COUNT(*) AS SHOT_ATTEMPTS, COUNT(CASE WHEN SHOT_MADE = 1 THEN 1 END) AS NUM_SHOTS_MADE
FROM [NBA-Analysis]..NBA_2025_Shots
GROUP BY TEAM_NAME, ZONE_RANGE
ORDER BY TEAM_NAME, ZONE_RANGE

-- Takeaways:
-- Shots taken from less than 8 ft. yield the highest shooting percentages 
-- while also being the most frequently attempted, reflecting teams’ emphasis on 
-- high-percentage looks near the basket through cuts, drives, and post-ups.

-- Field goal attempts from 24+ ft. are the second highest in volume, underscoring 
-- the central role of the three-point shot in modern offensive strategy, 
-- despite a lower shooting percentage compared to closer zones.




-- Visualization Query: Shot Location Data for 2024-2025 MVP Shai Gilgeous-Alexander
SELECT ZONE_NAME, LOC_X, LOC_Y, SHOT_TYPE, SHOT_MADE
FROM [NBA-Analysis]..NBA_2025_Shots
WHERE PLAYER_NAME = 'Shai Gilgeous-Alexander'




-- Non-Visualization Query: Top 10 Rookies in Scoring in the 2024-2025 Season
SELECT TOP 10 a.player, ROUND(a.pts_per_game, 2)
FROM [NBA-Analysis]..PlayerPerGame a
JOIN [NBA-Analysis]..PlayerSeasonInfo b ON a.player_id = b.player_id
WHERE b.experience = 1 AND b.season = 2025
ORDER BY 2 DESC

-- Takeaways:
-- Jared McCain led all rookies in scoring during the 2024–2025 season with 15.3 PPG.
-- Stephon Castle ranked 2nd in rookie scoring with 14.7 PPG but ultimately won Rookie of the Year.
-- Castle’s ROTY win was likely influenced by McCain’s mid-season injury, which limited his availability.
-- Tolu Smith and Alex Sarr rounded out the top 4, highlighting strong contributions from both guards and bigs.
-- This analysis helps identify early rookie standouts and provides context for award outcomes beyond just scoring.




-- Non-Visualization Query: Player Scoring Consistency (Min 3 Seasons and 10 ppg)
SELECT player, COUNT(season) AS num_seasons, ROUND(AVG(pts_per_game), 1) AS avg_ppg, ROUND(STDEV(pts_per_game), 2) AS scoring_stddev
FROM [NBA-Analysis]..PlayerPerGame
GROUP BY player
HAVING COUNT(season) >= 3 AND AVG(pts_per_game) >= 10
ORDER BY scoring_stddev ASC;

-- Takeaways:
-- Jeremy Sochan had the lowest scoring standard deviation (0.31) among all players with at least 3 seasons and 10+ PPG, 
-- highlighting his remarkable year-to-year consistency. Most players in the list fall within a scoring standard deviation of 0.5–1.5,
-- suggesting that moderate variation in PPG is common even among consistent contributors. Players like Zion Williamson and
-- Josh Giddey had higher variability, possibly due to injuries, changing roles, or team dynamics across seasons.
-- This analysis provides deeper insight beyond raw scoring averages, helping identify reliable scorers versus those with more fluctuating production.




-- Non-Visualization Query: Clutch Scoring Breakdown
SELECT PLAYER_NAME, COUNT(*) AS clutch_shot_attempts,
SUM(CASE WHEN SHOT_MADE = 1 THEN 1 ELSE 0 END) AS clutch_shots_made,
ROUND(CAST(SUM(CASE WHEN SHOT_MADE = 1 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100, 2) AS clutch_fg_percent,
SUM(CASE WHEN SHOT_MADE = 1 THEN
    CASE 
        WHEN SHOT_TYPE = '2PT Field Goal' THEN 2
        WHEN SHOT_TYPE = '3PT Field Goal' THEN 3
        ELSE 0
    END
ELSE 0 END) AS clutch_points
FROM [NBA-Analysis]..NBA_2025_Shots
WHERE QUARTER = 4 AND MINS_LEFT <= 5
GROUP BY PLAYER_NAME
HAVING COUNT(*) >= 20
ORDER BY clutch_points DESC


-- Takeaways:
-- Darius Garland led the league in total clutch points (228) while shooting an efficient 53.26% in clutch situations.
-- Despite ranking 11th in total clutch points (179), Jalen Brunson was awarded the Clutch Player of the Year, likely due to his strong shot selection (48.21% FG), 
-- leadership in key moments, and consistent late-game impact. Nikola Jokic, who was second in Clutch Player of the Year voting, posted the highest clutch FG% (57.41%)
-- Nikola Jokic, who was second in Clutch Player of the Year voting, posted the highest clutch FG% (57.41%) among the top scorers, highlighting his elite shot efficiency in pressure moments.
-- Stars like Trae Young and Tyler Herro scored in volume but had lower clutch FG% (<43%), pointing to higher usage but reduced shot-making under pressure.





-- Non-Visualization Query: FG% vs Win% Correlation
WITH cte AS (
    SELECT a.season, a.team, a.fg_percent, ROUND(CAST(b.w AS FLOAT) / (b.w + b.l) * 100, 2) AS win_percent
    FROM [NBA-Analysis]..TeamStatsPerGame a
    JOIN [NBA-Analysis]..TeamSummaries b ON a.team = b.team AND a.season = b.season
    WHERE a.season BETWEEN 2020 AND 2025
)

SELECT 
    ROUND((AVG(fg_percent * win_percent) - AVG(fg_percent) * AVG(win_percent)) /
    (STDEV(fg_percent) * STDEV(win_percent)), 2) AS correlation
FROM cte;

-- Takeaways:
-- There is a correlation of 0.62 between FG% and Win%, indicating a moderate to strong positive linear relationship
-- across teams and seasons from 2020-2025. This means in general, teams that shoot better tend to win more
-- games, but FG% does not necessarily explain everything. Factors such as defense, turnovers, 3PT shooting, etc.
-- still matter.