/*
  Description:
  This SQL query calculates the monthly Customer Acquisition Cost (CAC) by aggregating agent commission data 
  for 'Registration' and 'Referral' actions up to March 2025. It returns the total cash paid, total new users acquired,
  and the average CAC per user.

  Author: Dicky Setiawan
*/

SELECT
    DATE_TRUNC('month', date) AS month,
    SUM(cash_sent) AS total_cash_sent,
    COUNT(DISTINCT uid) AS total_new_users,
    ROUND(SUM(cash_sent) / NULLIF(COUNT(DISTINCT uid), 0)::NUMERIC, 2) AS cac_value
FROM agent_commission_2025
WHERE action IN ('Registration', 'Referral')
  AND date < '2025-04-01'
GROUP BY DATE_TRUNC('month', date);
