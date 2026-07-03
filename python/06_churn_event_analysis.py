import pandas as pd

accounts = pd.read_csv("ravenstack_accounts.csv")
churn_events = pd.read_csv("ravenstack_churn_events.csv")

customer_churn = pd.merge(
    accounts,
    churn_events,
    on="account_id",
    how="left"
)

#Why do customers churn?
reason_summary = (
    churn_events["reason_code"]
    .value_counts()
)

print(reason_summary)

#Average refund by reason
refund_summary = (
    churn_events
    .groupby("reason_code")
    .agg(
        customers=("churn_event_id","count"),
        avg_refund=("refund_amount_usd","mean")
    )
    .sort_values("avg_refund", ascending=False)
)

print(refund_summary)

#Reactivation Rate
reactivation_rate = (
    churn_events["is_reactivation"]
    .mean()
) * 100

print(f"Reactivation Rate: {reactivation_rate:.2f}%")

#Upgrade before churn
print(churn_events["preceding_upgrade_flag"].value_counts())

#Downgrade before churn
print(churn_events["preceding_downgrade_flag"].value_counts())