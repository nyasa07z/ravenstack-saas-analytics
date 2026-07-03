-- Project: SaaS Customer Churn Analysis
-- File: 05_churn_analysis.sql
-- Description:
-- Analyzes customer churn across industries, plans,
-- countries, acquisition channels, customer behavior, and subscription characteristics.
-- ============================================================

-- What percentage of customers have churned?
SELECT
    ROUND(
        AVG(
            CASE
                WHEN churn_flag THEN 1
                ELSE 0
            END
        ) * 100,
        2
    ) AS churn_rate
FROM accounts;

-- Which industries experience the highest churn?
SELECT
    industry,
    COUNT(*) AS customers,
    SUM(CASE WHEN churn_flag THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        AVG(
            CASE
                WHEN churn_flag THEN 1
                ELSE 0
            END
        ) * 100,
        2
    ) AS churn_rate
FROM accounts
GROUP BY industry
ORDER BY churn_rate DESC;

--Churn by Country
SELECT
    country,
    COUNT(*) AS customers,
    SUM(CASE WHEN churn_flag THEN 1 ELSE 0 END) AS churned,
    ROUND(
        AVG(
            CASE
                WHEN churn_flag THEN 1
                ELSE 0
            END
        ) * 100,
        2
    ) AS churn_rate
FROM accounts
GROUP BY country
ORDER BY churn_rate DESC;

--Churn by Plan
SELECT
    plan_tier,
    COUNT(*) AS customers,
    SUM(CASE WHEN churn_flag THEN 1 ELSE 0 END) AS churned,
    ROUND(
        AVG(
            CASE
                WHEN churn_flag THEN 1
                ELSE 0
            END
        ) * 100,
        2
    ) AS churn_rate
FROM accounts
GROUP BY plan_tier
ORDER BY churn_rate DESC;

--Trial vs Paid Churn
SELECT
    is_trial,
    COUNT(*) AS customers,
    SUM(CASE WHEN churn_flag THEN 1 ELSE 0 END) AS churned,
    ROUND(
        AVG(
            CASE
                WHEN churn_flag THEN 1
                ELSE 0
            END
        ) * 100,
        2
    ) AS churn_rate
FROM accounts
GROUP BY is_trial;

--Churn by Referral Source
SELECT
    referral_source,
    COUNT(*) AS customers,
    SUM(CASE WHEN churn_flag THEN 1 ELSE 0 END) AS churned,
    ROUND(
        AVG(
            CASE
                WHEN churn_flag THEN 1
                ELSE 0
            END
        ) * 100,
        2
    ) AS churn_rate
FROM accounts
GROUP BY referral_source
ORDER BY churn_rate DESC;

--Churn Reasons
SELECT
    reason_code,
    COUNT(*) AS customers
FROM churn_events
GROUP BY reason_code
ORDER BY customers DESC;

--Average Refund by Churn Reason
SELECT
    reason_code,
    ROUND(AVG(refund_amount_usd),2) AS average_refund,
    COUNT(*) AS customers
FROM churn_events
GROUP BY reason_code
ORDER BY average_refund DESC;

--Reactivation Rate
SELECT
    ROUND(
        AVG(
            CASE
                WHEN is_reactivation THEN 1
                ELSE 0
            END
        ) * 100,
        2
    ) AS reactivation_rate
FROM churn_events;

--Did Customers Upgrade Before Churning?
SELECT
    preceding_upgrade_flag,
    COUNT(*) AS customers
FROM churn_events
GROUP BY preceding_upgrade_flag;

--Did Customers Downgrade Before Churning?
SELECT
    preceding_downgrade_flag,
    COUNT(*) AS customers
FROM churn_events
GROUP BY preceding_downgrade_flag;

--Does support quality relate to churn?
SELECT
    a.churn_flag,
    ROUND(AVG(s.resolution_time_hours),2) AS avg_resolution_time,
    ROUND(AVG(s.first_response_time_minutes),2) AS avg_first_response,
    ROUND(AVG(s.satisfaction_score),2) AS avg_satisfaction
FROM accounts a
JOIN support_tickets s
ON a.account_id = s.account_id
GROUP BY a.churn_flag;

--Does feature usage relate to churn?
SELECT
    a.churn_flag,
    ROUND(AVG(f.usage_count),2) AS avg_usage,
    ROUND(AVG(f.usage_duration_secs),2) AS avg_duration,
    ROUND(AVG(f.error_count),2) AS avg_errors
FROM accounts a
JOIN subscriptions s
ON a.account_id = s.account_id
JOIN feature_usage f
ON s.subscription_id = f.subscription_id
GROUP BY a.churn_flag;

--Customer lifetime (days)
SELECT
    ROUND(
        AVG(end_date - start_date),
        2
    ) AS avg_customer_lifetime_days
FROM subscriptions
WHERE end_date IS NOT NULL;
-- Summary
-- 1. Overall churn rate is 22%, meaning approximately one in five customers discontinue their subscription.
-- 2. DevTools customers have the highest churn rate, followed by FinTech customers, indicating these industries require closer attention.
-- 3. Germany has the highest churn rate among all countries, followed by the United States and France.
-- 4. Enterprise customers exhibit the highest churn rate, slightly exceeding Basic and Pro plans.
-- 5. Trial customers churn more frequently (25.77%) than non-trial customers (21.09%), suggesting challenges in trial-to-paid conversion.
-- 6. Customers acquired through Events experience the highest churn, while Partner referrals have the lowest churn rate.
-- 7. Missing product features are the leading reason customers leave, followed by support-related issues and budget constraints.
-- 8. Customers with an unknown churn reason receive the highest average refunds, followed by customers citing missing features and pricing concerns.
-- 9. Approximately 10.17% of churned customers eventually reactivate, highlighting an opportunity for targeted win-back campaigns.
-- 10. Most churned customers did not upgrade or downgrade before leaving, suggesting churn is often unrelated to plan changes.
-- 11. Support metrics such as response time and customer satisfaction show only minor differences between churned and retained customers, indicating support quality alone is unlikely to be the primary driver of churn.
-- 12. Product usage metrics such as feature usage, usage duration, and error counts show only minor differences between churned and retained customers, suggesting that overall product engagement alone is not a strong predictor of churn.
-- 13. The average customer lifetime before churn is approximately 88 days, indicating that many customers discontinue relatively early in their subscription journey.