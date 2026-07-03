import pandas as pd
accounts = pd.read_csv("ravenstack_accounts.csv")
result = (
    accounts
    .groupby("industry")["churn_flag"]
    .agg(
        total_customers="count",
        churned_customers="sum"
    )
)

result["churn_rate"] = (
    result["churned_customers"]
    / result["total_customers"]
) * 100
print(result.sort_values("churn_rate", ascending=False))