
# NBA SQL Analysis Project

## Overview

This project explores player and team performance data from the 2020–2025 NBA seasons using SQL. The analyses cover various aspects of the game including scoring trends, efficiency metrics, consistency, clutch performance, and correlations between shooting and winning. It is intended for use in portfolio development, data storytelling, and exploratory sports analytics.

## Datasets

All queries are run on the following SQL tables:

- `PlayerPerGame` – Player-level per-game stats
- `PlayerTotals` – Player-level season totals
- `TeamStatsPerGame` – Team-level per-game stats
- `TeamSummaries` – Team win/loss records
- `PlayerSeasonInfo` – Player metadata (e.g., experience, position)
- `NBA_2025_Shots` – Shot location data for the 2024–2025 season

## Analyses and Insights

### 1. Top 10 Unique Scorers (2024–2025)
- Ranks the league’s top scorers based on points per game.
- **Key Insight**: The top scorers — Shai Gilgeous-Alexander, Giannis Antetokounmpo, and Nikola Jokić — were also MVP candidates, linking scoring prowess to award recognition.

### 2. True Shooting Percentage Leaders
- Identifies the top 10 players in TS% with at least 450 shot attempts.
- **Key Insight**: Centers dominate the list due to high-efficiency scoring near the rim and strong free throw percentages.

### 3. Team Scoring Trends Over Time (2020–2025)
- Tracks point-per-game changes year-over-year.
- **Key Insight**: Oklahoma City’s +13.8 PPG jump in 2023 marked a breakout. Portland’s declines aligned with Damian Lillard’s injury and eventual trade.

### 4. Player Scoring Over Time
- Shows scoring development of selected players over five seasons.
- **Key Insight**: Shai Gilgeous-Alexander's rise from 19.0 to 32.7 PPG mirrors his MVP ascension in 2025.

### 5. Shooting Efficiency by Zone
- Calculates shot percentage by zone range for each team.
- **Key Insight**: Teams prioritize shots within 8 feet and from 3-point range, reflecting modern offensive trends.

### 6. Shai Gilgeous-Alexander Shot Chart (2024–2025)
- Provides detailed shot location data for the MVP season.
- Used for visualizing hot zones and shot types.

### 7. Top Rookie Scorers (2024–2025)
- Ranks first-year players by PPG.
- **Key Insight**: Jared McCain led in scoring but missed time due to injury, allowing Stephon Castle to win Rookie of the Year.

### 8. Scoring Consistency (3+ Seasons, 10+ PPG)
- Measures standard deviation in PPG to evaluate consistency.
- **Key Insight**: Jeremy Sochan had the lowest variance, while others like Zion Williamson showed more fluctuation due to injuries or role changes.

### 9. Clutch Scoring Breakdown
- Analyzes player performance in the final 5 minutes of 4th quarters.
- **Key Insight**: Darius Garland led in total clutch points. Jalen Brunson’s efficiency and leadership earned him Clutch Player of the Year despite not topping the scoring list.

### 10. Field Goal % vs Win % Correlation
- Examines statistical relationship between FG% and team success.
- **Key Insight**: A correlation of 0.62 suggests that better shooting teams tend to win more, though other factors still play significant roles.

## Tableau Dashboard

[**View Interactive Dashboard on Tableau Public**](https://public.tableau.com/app/profile/andy.nguyen4739/viz/NBADashboardProject_17532232901420/NBADashboard)  

## Tools Used

- **SQL Server**: All queries written and tested in SQL Server Management Studio (SSMS).

---

## Data Sources

- [Kaggle – NBA, ABA, BAA Stats Dataset](https://www.kaggle.com/datasets/sumitrodatta/nba-aba-baa-stats)  
  Used for player and team-level statistics (per game, totals, summaries, etc.)

- [GitHub – NBA Shot Data (April 2025)](https://github.com/DomSamangy/NBA_Shots_04_25/tree/main)  
  Used for detailed shot location data and shot types for the 2024–2025 season
