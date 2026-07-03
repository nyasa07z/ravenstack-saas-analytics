-- Project: SaaS Customer Churn Analysis
-- File: 03_customer_overview.sql
-- Description:
-- Provides an overview of RavenStack's customer base,
-- including customer distribution, churn, and acquisition.

-- ============================================================
-- How many customers does RavenStack currently have?
SELECT COUNT(*) AS total_customers
FROM accounts;

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

-- Which industries use RavenStack the most?
SELECT
    industry,
    COUNT(*) AS customers
FROM accounts
GROUP BY industry
ORDER BY customers DESC;

-- Which countries have the largest customer base?
SELECT
    country,
    COUNT(*) AS customers
FROM accounts
GROUP BY country
ORDER BY customers DESC;

-- Which subscription plans are most popular?
SELECT
    plan_tier,
    COUNT(*) AS customers
FROM accounts
GROUP BY plan_tier
ORDER BY customers DESC;

-- Which marketing channels acquire the most customers?
SELECT
    referral_source,
    COUNT(*) AS customers
FROM accounts
GROUP BY referral_source
ORDER BY customers DESC;

-- How many customers are on a trial?
SELECT
    is_trial,
    COUNT(*) AS customers
FROM accounts
GROUP BY is_trial;

-- How many seats does the average customer purchase?
SELECT
    ROUND(AVG(seats),2) AS average_seats,
    MIN(seats) AS minimum_seats,
    MAX(seats) AS maximum_seats
FROM accounts;

-- Which industries purchase the largest number of seats?
SELECT
    industry,
    ROUND(AVG(seats),2) AS average_seats
FROM accounts
GROUP BY industry
ORDER BY average_seats DESC;

-- How many customers signed up each year?
SELECT
    EXTRACT(YEAR FROM signup_date) AS signup_year,
    COUNT(*) AS customers
FROM accounts
GROUP BY signup_year
ORDER BY signup_year;

-- Summary
-- Most customers belong to the DevTools and FinTech industries.
-- The United States contributes the largest customer base.
-- Basic is the most commonly adopted plan.
-- Organic and Partner channels drive a significant share of customers.