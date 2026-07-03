import pandas as pd

accounts = pd.read_csv("ravenstack_accounts.csv")
support = pd.read_csv("ravenstack_support_tickets.csv")

#Count support tickets per customer
ticket_summary = (
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

#Merge with Accounts
customer_support = pd.merge(
    accounts,
    ticket_summary,
    on="account_id",
    how="left"
)

#Fill missing values
customer_support = customer_support.fillna({
    "total_tickets": 0,
    "avg_resolution_time": 0,
    "avg_first_response": 0,
    "avg_satisfaction": 0,
    "escalations": 0
})

#Compare churn vs non-churn
support_analysis = (
    customer_support
    .groupby("churn_flag")
    .agg(
        avg_tickets=("total_tickets", "mean"),
        avg_resolution=("avg_resolution_time", "mean"),
        avg_first_response=("avg_first_response", "mean"),
        avg_satisfaction=("avg_satisfaction", "mean"),
        avg_escalations=("escalations", "mean")
    )
)

print(support_analysis)