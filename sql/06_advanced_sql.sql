--Which customers generate the highest Monthly Recurring Revenue?
SELECT
    a.account_name,
    SUM(s.mrr_amount) AS total_mrr,
    RANK() OVER (
        ORDER BY SUM(s.mrr_amount) DESC
    ) AS revenue_rank
FROM accounts a
JOIN subscriptions s
ON a.account_id = s.account_id
GROUP BY a.account_name
ORDER BY revenue_rank
LIMIT 10;

--Which Industry generate the highest Monthly Recurring Revenue?
WITH industry_revenue AS (
SELECT
    a.industry,
    a.account_name,
    SUM(s.mrr_amount) AS revenue,
    ROW_NUMBER() OVER(
        PARTITION BY a.industry
        ORDER BY SUM(s.mrr_amount) DESC
    ) AS rn
FROM accounts a
JOIN subscriptions s
ON a.account_id=s.account_id
GROUP BY
a.industry,
a.account_name
)
SELECT *
FROM industry_revenue
WHERE rn=1;

--Customer Lifetime Ranking
SELECT
account_name,
MAX(end_date-start_date) AS lifetime,
DENSE_RANK() OVER(
ORDER BY MAX(end_date-start_date) DESC
) AS lifetime_rank
FROM accounts a
JOIN subscriptions s
ON a.account_id=s.account_id
WHERE end_date IS NOT NULL
GROUP BY account_name;

--Active vs Churned Revenue
SELECT
CASE
WHEN churn_flag THEN 'Churned'
ELSE 'Active'
END AS customer_status,
SUM(mrr_amount) AS revenue
FROM subscriptions
GROUP BY customer_status;

--Running Total Revenue
SELECT
start_date,
SUM(mrr_amount) AS daily_revenue,
SUM(SUM(mrr_amount))
OVER(
ORDER BY start_date
) AS cumulative_revenue
FROM subscriptions
GROUP BY start_date
ORDER BY start_date;

--Monthly Revenue
SELECT
DATE_TRUNC('month',start_date) AS month,
SUM(mrr_amount) AS revenue
FROM subscriptions
GROUP BY month
ORDER BY month;

--Create a View
CREATE VIEW customer_summary AS
SELECT
a.account_id,
a.account_name,
a.industry,
COUNT(s.subscription_id) AS subscriptions,
SUM(s.mrr_amount) AS total_mrr,
AVG(s.seats) AS average_seats
FROM accounts a
JOIN subscriptions s
ON a.account_id=s.account_id
GROUP BY 
a.account_id,
a.account_name,
a.industry;