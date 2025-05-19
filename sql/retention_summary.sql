/*
  Description:  
  This SQL script calculates monthly user retention for users acquired through the agent channel in Q1 2025. 
  The analysis focuses on measuring how many new users acquired by agents return and stay active in the following month.

  Author: Dicky Setiawan
*/

-- Step 1: Get users acquired by agents within Q1 2025
WITH 
agent_users AS (
	SELECT DISTINCT uid 
    FROM player_list_2025 
    WHERE user_tags = 'Agents' 
        AND registration_time BETWEEN '2025-01-01' AND '2025-03-31'
)
,
-- Step 2: Get player registration cohorts and last login time
cohort_player_list_2025_q1_retention AS (
    SELECT 
        p.uid,
        DATE_TRUNC('month', p.registration_time) AS month,
        p.last_login_time
    FROM player_list_2025 p
    JOIN agent_users a ON p.uid = a.uid
    WHERE DATE_TRUNC('month', p.registration_time) <= '2025-03-01'
        AND p.user_tags = 'Agents'
)
,
-- Step 3: Calculate total new users and retained users (who logged in again after 1 month)
retention_summary AS (
    SELECT 
        month,
        COUNT(DISTINCT uid) AS total_new_users,
        COUNT(DISTINCT CASE 
            WHEN last_login_time >= month + INTERVAL '1 month' 
             AND last_login_time < month + INTERVAL '2 month' 
            THEN uid 
        END) AS total_retained_users
    FROM cohort_player_list_2025_q1_retention
    GROUP BY month
)

-- Step 4: Calculate retention rate
SELECT 
    month,
    total_new_users,
    total_retained_users,
    ROUND(
        (total_retained_users * 100.0) / NULLIF(total_new_users, 0), 
        2
    ) AS retention_rate
FROM retention_summary
ORDER BY month;