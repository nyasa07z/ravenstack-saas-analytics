-- Project: SaaS Customer Churn Analysis
-- File: 02_data_validation.sql
-- Description:
-- Validate the quality of data before performing business analysis.
-- Checks include:
-- Row counts, Missing values, Duplicate primary keys, Invalid values, Referential integrity
-- ============================================================

-- How many records exist in each table?
SELECT 'accounts' AS table_name, COUNT(*) AS rows
FROM accounts
UNION ALL
SELECT 'subscriptions', COUNT(*)
FROM subscriptions
UNION ALL
SELECT 'feature_usage', COUNT(*)
FROM feature_usage
UNION ALL
SELECT 'support_tickets', COUNT(*)
FROM support_tickets
UNION ALL
SELECT 'churn_events', COUNT(*)
FROM churn_events;

-- Are there any missing Account IDs?
SELECT *
FROM accounts
WHERE account_id IS NULL;

-- Are Account IDs unique?
SELECT
    account_id,
    COUNT(*) AS occurrences
FROM accounts
GROUP BY account_id
HAVING COUNT(*) > 1;

-- Are any customers missing signup dates?
SELECT *
FROM accounts
WHERE signup_date IS NULL;

-- Are there any subscriptions with zero or negative seats?
SELECT *
FROM subscriptions
WHERE seats <= 0;

-- Are there any subscriptions missing revenue values?
SELECT *
FROM subscriptions
WHERE mrr_amount IS NULL;

-- Are there subscriptions that end before they start?
SELECT *
FROM subscriptions
WHERE end_date < start_date;

-- How many support tickets have no satisfaction score?
SELECT COUNT(*) AS missing_scores
FROM support_tickets
WHERE satisfaction_score IS NULL;

-- Are Subscription IDs unique?
SELECT
    subscription_id,
    COUNT(*)
FROM subscriptions
GROUP BY subscription_id
HAVING COUNT(*) > 1;

-- Are Usage IDs unique after data cleaning?
SELECT
    usage_id,
    COUNT(*)
FROM feature_usage
GROUP BY usage_id
HAVING COUNT(*) > 1;

-- Are there subscriptions without a matching account?
SELECT s.*
FROM subscriptions s
LEFT JOIN accounts a
ON s.account_id = a.account_id
WHERE a.account_id IS NULL;

-- Are there feature usage records without a valid subscription?
SELECT f.*
FROM feature_usage f
LEFT JOIN subscriptions s
ON f.subscription_id = s.subscription_id
WHERE s.subscription_id IS NULL;

-- Are there support tickets linked to nonexistent accounts?
SELECT t.*
FROM support_tickets t
LEFT JOIN accounts a
ON t.account_id = a.account_id
WHERE a.account_id IS NULL;

-- Are there churn events linked to nonexistent accounts?
SELECT c.*
FROM churn_events c
LEFT JOIN accounts a
ON c.account_id = a.account_id
WHERE a.account_id IS NULL;

-- Summary
-- No duplicate Account IDs
-- No duplicate Subscription IDs
-- Feature Usage duplicate IDs removed during preprocessing
-- No missing revenue values
-- No invalid seat counts
-- Foreign key relationships validated
-- Satisfaction Score contains NULL values