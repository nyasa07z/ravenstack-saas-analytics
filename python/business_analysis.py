#What characteristics are associated with churn?

#Does company size affect churn?
import pandas as pd

accounts = pd.read_csv("ravenstack_accounts.csv")

seat_analysis = (
    accounts
    .groupby("churn_flag")
    .agg(
        average_seats=("seats", "mean"),
        median_seats=("seats", "median"),
        customers=("account_id", "count")
    )
)

print(seat_analysis)

#Which industries churn the most?
industry_churn = (
    accounts
    .groupby("industry")
    .agg(
        total_customers=("account_id", "count"),
        churned=("churn_flag", "sum")
    )
)

industry_churn["churn_rate"] = (
    industry_churn["churned"]
    / industry_churn["total_customers"]
) * 100

print(industry_churn.sort_values("churn_rate", ascending=False))

#Which countries churn the most?
country_churn = (
    accounts
    .groupby("country")
    .agg(
        customers=("account_id", "count"),
        churned=("churn_flag", "sum")
    )
)

country_churn["churn_rate"] = (
    country_churn["churned"]
    / country_churn["customers"]
) * 100

print(country_churn.sort_values("churn_rate", ascending=False))


#Which referral source brings the best customers?
referral_summary = (
    accounts
    .groupby("referral_source")
    .agg(
        customers=("account_id", "count"),
        average_seats=("seats", "mean"),
        churn_rate=("churn_flag", "mean")
    )
)

referral_summary["churn_rate"] *= 100

print(referral_summary)