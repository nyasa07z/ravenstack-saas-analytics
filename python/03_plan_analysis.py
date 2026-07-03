import pandas as pd

subscriptions = pd.read_csv("ravenstack_subscriptions.csv")

#Which subscription plan performs the best overall?
plan_summary = (
    subscriptions
    .groupby("plan_tier")
    .agg(
        total_subscriptions=("subscription_id", "count"),
        total_mrr=("mrr_amount", "sum"),
        average_mrr=("mrr_amount", "mean"),
        average_seats=("seats", "mean"),
        churn_rate=("churn_flag", "mean")
    )
)

plan_summary["churn_rate"] *= 100

plan_summary = plan_summary.round({
    "average_mrr": 2,
    "average_seats": 2,
    "churn_rate": 2
})

print(plan_summary)

#Which Industry Generates the Most Revenue?
accounts = pd.read_csv("ravenstack_accounts.csv")

account_subscription = pd.merge(
    subscriptions,
    accounts,
    on="account_id",
    how="left"
)
print(account_subscription.shape)
print(account_subscription.head())

industry_revenue = (
    account_subscription
    .groupby("industry")
    .agg(
        total_mrr=("mrr_amount", "sum"),
        subscriptions=("subscription_id", "count")
    )
    .sort_values("total_mrr", ascending=False)
)

print(industry_revenue)