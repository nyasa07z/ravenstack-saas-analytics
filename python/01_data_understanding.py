import pandas as pd

accounts = pd.read_csv("data/raw/ravenstack_accounts.csv")
subscriptions = pd.read_csv("data/raw/ravenstack_subscriptions.csv")
feature_usage = pd.read_csv("data/raw/ravenstack_feature_usage.csv")
support_tickets = pd.read_csv("data/raw/ravenstack_support_tickets.csv")
churn_events = pd.read_csv("data/raw/ravenstack_churn_events.csv")

def explore_dataset(df, name):
    print("=" * 70)
    print(name.upper())
    print("=" * 70)

    print("\nShape:")
    print(df.shape)

    print("\nColumns:")
    print(df.columns.tolist())

    print("\nData Types:")
    print(df.dtypes)

    print("\nMissing Values:")
    print(df.isnull().sum())

    print("\nDuplicate Rows:")
    print(df.duplicated().sum())

    print("\nFirst Five Rows:")
    print(df.head())


explore_dataset(accounts, "Accounts")
explore_dataset(subscriptions, "Subscriptions")
explore_dataset(feature_usage, "Feature Usage")
explore_dataset(support_tickets, "Support Tickets")
explore_dataset(churn_events, "Churn Events")


print("\nUnique Account IDs in Accounts")
print(accounts["account_id"].nunique())

print("\nUnique Account IDs in Subscriptions")
print(subscriptions["account_id"].nunique())