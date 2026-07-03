import pandas as pd

# Load datasets
accounts = pd.read_csv("ravenstack_accounts.csv")
subscriptions = pd.read_csv("ravenstack_subscriptions.csv")
feature_usage = pd.read_csv("ravenstack_feature_usage.csv")
support_tickets = pd.read_csv("ravenstack_support_tickets.csv")
churn_events = pd.read_csv("ravenstack_churn_events.csv")

# Convert dates
accounts["signup_date"] = pd.to_datetime(accounts["signup_date"])

subscriptions["start_date"] = pd.to_datetime(subscriptions["start_date"])
subscriptions["end_date"] = pd.to_datetime(subscriptions["end_date"])

feature_usage["usage_date"] = pd.to_datetime(feature_usage["usage_date"])

support_tickets["submitted_at"] = pd.to_datetime(support_tickets["submitted_at"])
support_tickets["closed_at"] = pd.to_datetime(support_tickets["closed_at"])

churn_events["churn_date"] = pd.to_datetime(churn_events["churn_date"])

print("All date columns converted successfully!")

#How much Monthly Recurring Revenue (MRR) does RavenStack generate?
print("\n" + "="*60)
print("MONTHLY RECURRING REVENUE")
print("="*60)
total_mrr = subscriptions["mrr_amount"].sum()
print(f"Total Monthly Recurring Revenue: ${total_mrr:,.2f}")

print("\nAverage MRR per Subscription")
avg_mrr = subscriptions["mrr_amount"].mean()
print(f"${avg_mrr:.2f}")

revenue_by_plan = (
    subscriptions
    .groupby("plan_tier")["mrr_amount"]
    .sum()
    .sort_values(ascending=False)
)
print(revenue_by_plan)

subscriptions["plan_tier"].value_counts()
print(subscriptions["plan_tier"].value_counts())