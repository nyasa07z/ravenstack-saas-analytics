import pandas as pd

# Load datasets
accounts = pd.read_csv("data/raw/ravenstack_accounts.csv")
subscriptions = pd.read_csv("data/raw/ravenstack_subscriptions.csv")
support = pd.read_csv("data/raw/ravenstack_support_tickets.csv")
feature_usage = pd.read_csv("data/raw/ravenstack_feature_usage.csv")

# -------------------------
# Subscription Summary
# -------------------------
subscription_summary = (
    subscriptions
    .groupby("account_id")
    .agg(
        total_subscriptions=("subscription_id", "count"),
        total_mrr=("mrr_amount", "sum"),
        total_arr=("arr_amount", "sum"),
        avg_mrr=("mrr_amount", "mean"),
        avg_seats=("seats", "mean"),
        subscription_churn_rate=("churn_flag", "mean")
    )
    .reset_index()
)

subscription_summary["subscription_churn_rate"] *= 100

# -------------------------
# Support Summary
# -------------------------
support_summary = (
    support
    .groupby("account_id")
    .agg(
        total_tickets=("ticket_id", "count"),
        avg_resolution_time=("resolution_time_hours", "mean"),
        avg_first_response=("first_response_time_minutes", "mean"),
        avg_satisfaction=("satisfaction_score", "mean"),
        escalations=("escalation_flag", "sum")
    )
    .reset_index()
)

# -------------------------
# Feature Usage Summary
# -------------------------
usage_summary = (
    feature_usage
    .groupby("subscription_id")
    .agg(
        total_usage=("usage_count", "sum"),
        total_duration=("usage_duration_secs", "sum"),
        total_errors=("error_count", "sum")
    )
    .reset_index()
)

usage_account = (
    subscriptions[["subscription_id", "account_id"]]
    .merge(usage_summary, on="subscription_id", how="left")
)

usage_account_summary = (
    usage_account
    .groupby("account_id")
    .agg(
        total_usage=("total_usage", "sum"),
        total_duration=("total_duration", "sum"),
        total_errors=("total_errors", "sum")
    )
    .reset_index()
)

# -------------------------
# Final Dashboard Dataset
# -------------------------
dashboard_data = (
    accounts
    .merge(subscription_summary, on="account_id", how="left")
    .merge(support_summary, on="account_id", how="left")
    .merge(usage_account_summary, on="account_id", how="left")
)

# Fill missing numeric values
dashboard_data = dashboard_data.fillna(0)

# Save dataset
dashboard_data.to_csv("dashboard_dataset.csv", index=False)

print("Dashboard dataset created successfully!")
print(dashboard_data.head())
print(dashboard_data.shape)