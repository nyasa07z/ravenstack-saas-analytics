-- Project: SaaS Customer Churn Analysis
-- File: 04_revenue_analysis.sql
-- Description:
-- Analyzes revenue performance across different customer
-- segments, plans, industries, and countries.
-- ============================================================

-- What is the total Monthly Recurring Revenue (MRR)?
SELECT
    SUM(mrr_amount) AS total_mrr
FROM subscriptions;

-- What is the average Monthly Recurring Revenue per subscription?
SELECT
    ROUND(AVG(mrr_amount),2) AS average_mrr
FROM subscriptions;

-- Which subscription plan generates the highest revenue?
SELECT
    plan_tier,
    COUNT(*) AS subscriptions,
    SUM(mrr_amount) AS total_mrr,
    ROUND(AVG(mrr_amount),2) AS average_mrr
FROM subscriptions
GROUP BY plan_tier
ORDER BY total_mrr DESC;

-- Which industries generate the highest revenue?
SELECT
    a.industry,
    COUNT(s.subscription_id) AS subscriptions,
    SUM(s.mrr_amount) AS total_mrr,
    ROUND(AVG(s.mrr_amount),2) AS average_mrr
FROM accounts a
JOIN subscriptions s
ON a.account_id = s.account_id
GROUP BY a.industry
ORDER BY total_mrr DESC;

-- Which countries contribute the most revenue?
SELECT
    a.country,
    COUNT(s.subscription_id) AS subscriptions,
    SUM(s.mrr_amount) AS total_mrr
FROM accounts a
JOIN subscriptions s
ON a.account_id = s.account_id
GROUP BY a.country
ORDER BY total_mrr DESC;

-- Which customer acquisition channels generate the most revenue?
SELECT
    a.referral_source,
    COUNT(s.subscription_id) AS subscriptions,
    SUM(s.mrr_amount) AS total_mrr,
    ROUND(AVG(s.mrr_amount),2) AS average_mrr
FROM accounts a
JOIN subscriptions s
ON a.account_id = s.account_id
GROUP BY a.referral_source
ORDER BY total_mrr DESC;

-- Who are RavenStack's highest-value customers?
SELECT
    a.account_name,
    a.industry,
    SUM(s.mrr_amount) AS total_mrr
FROM accounts a
JOIN subscriptions s
ON a.account_id = s.account_id
GROUP BY
    a.account_name,
    a.industry
ORDER BY total_mrr DESC
LIMIT 10;

-- What is the average revenue generated per customer?
SELECT
    ROUND(
        SUM(mrr_amount) /
        COUNT(DISTINCT account_id),
        2
    ) AS average_customer_revenue
FROM subscriptions;

-- How does revenue differ between monthly and annual billing?
SELECT
    billing_frequency,
    COUNT(*) AS subscriptions,
    SUM(mrr_amount) AS total_mrr,
    ROUND(AVG(mrr_amount),2) AS average_mrr
FROM subscriptions
GROUP BY billing_frequency
ORDER BY total_mrr DESC;

-- How much revenue comes from churned versus active customers?
SELECT
    a.churn_flag,
    COUNT(DISTINCT a.account_id) AS customers,
    SUM(s.mrr_amount) AS total_mrr
FROM accounts a
JOIN subscriptions s
ON a.account_id = s.account_id
GROUP BY a.churn_flag;

-- Summary
-- Enterprise subscriptions contribute the majority of MRR.
-- FinTech customers generate the highest total revenue.
-- The US is the largest revenue-generating market.
-- Annual billing contributes a significant share of revenue.