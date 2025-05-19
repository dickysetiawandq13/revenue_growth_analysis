/*
  Description:  
  This SQL query calculates the monthly Customer Acquisition Cost (CAC), segmented by 'Registration' and 'Referral' actions.  
  It returns the total commission paid, total new users acquired, and the CAC per user for each acquisition action type up to March 2025.

  Author: Dicky Setiawan
*/

SELECT
    DATE_TRUNC('month', date) AS month,
    action,
    SUM(cash_sent) AS total_cash_sent,
    COUNT(DISTINCT uid) AS total_new_users,
    ROUND(SUM(cash_sent) / NULLIF(COUNT(DISTINCT uid), 0)::NUMERIC, 2) AS cac_value
FROM agent_commission_2025
WHERE action IN ('Registration', 'Referral')
    AND date < '2025-04-01'
GROUP BY DATE_TRUNC('month', date), action;
