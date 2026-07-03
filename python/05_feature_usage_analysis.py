import pandas as pd

accounts = pd.read_csv("ravenstack_accounts.csv")
subscriptions = pd.read_csv("ravenstack_subscriptions.csv")
feature_usage = pd.read_csv("ravenstack_feature_usage.csv")

usage_summary = (
    feature_usage
    .groupby("subscription_id")
    .agg(
        total_usage=("usage_count", "sum"),
        total_duration=("usage_duration_secs", "sum"),
        total_errors=("error_count", "sum"),
        beta_features_used=("is_beta_feature", "sum"),
        unique_features=("feature_name", "nunique")
    )
    .reset_index()
)
print(usage_summary.head())
print(usage_summary.shape)

subscription_usage = pd.merge(
    subscriptions,
    usage_summary,
    on="subscription_id",
    how="left"
)
print(subscription_usage.shape)
print(subscription_usage.head())

usage_analysis = (
    subscription_usage
    .groupby("churn_flag")
    .agg(
        avg_usage=("total_usage", "mean"),
        avg_duration=("total_duration", "mean"),
        avg_errors=("total_errors", "mean"),
        avg_beta_features=("beta_features_used", "mean"),
        avg_unique_features=("unique_features", "mean")
    )
)

print(usage_analysis)

missing_usage = subscription_usage[
    subscription_usage["total_usage"].isna()
]

print(f"Subscriptions with no usage: {len(missing_usage)}")
print(missing_usage[[
    "subscription_id",
    "account_id",
    "plan_tier",
    "is_trial",
    "churn_flag"
]].head(20))