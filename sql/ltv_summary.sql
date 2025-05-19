/*
  Description:  
  This SQL script calculates monthly ARPPU (Average Revenue Per Paying User), Average User Lifetime, 
  and LTV (Lifetime Value) for users acquired through the agent channel in Q1 2025. 
  The analysis focuses on measuring user revenue contribution and engagement duration after acquisition.

  Author: Dicky Setiawan
*/

-- Step 1: Filter users acquired via agent commissions through 'Registration' or 'Referral' actions
WITH
agent_users AS (
    SELECT DISTINCT uid 
    FROM player_list_2025 
    WHERE user_tags = 'Agents' 
        AND registration_time BETWEEN '2025-01-01' AND '2025-03-31'
)
,
-- Step 2: Calculate total deposits and user lifetime from registration to last login
cohort_player_list_2025_q1 AS (
    SELECT 
        p.uid,
        p.total_deposit,
        DATE_TRUNC('month', p.registration_time) AS month,
        EXTRACT(year FROM AGE(p.last_login_time, p.registration_time)) * 12 +
        EXTRACT(month FROM AGE(p.last_login_time, p.registration_time)) AS lifetime
    FROM player_list_2025 p
    JOIN agent_users a ON p.uid = a.uid
    WHERE p.registration_time BETWEEN '2025-01-01' AND '2025-03-31'
)
-- Step 3: Aggregate ARPPU, average lifetime, and LTV metrics by month
SELECT 
    month,
    ROUND(SUM(total_deposit) * 1.0 / COUNT(uid)::NUMERIC, 2) AS arppu,
    ROUND(AVG(lifetime)::NUMERIC, 2) AS avg_lifetime,
    ROUND(
        (SUM(total_deposit) * 1.0 / COUNT(uid)::NUMERIC) * NULLIF(AVG(lifetime)::NUMERIC, 0), 
        2
    ) AS life_time_value
FROM cohort_player_list_2025_q1
GROUP BY month
ORDER BY month;
