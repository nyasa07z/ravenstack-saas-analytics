import pandas as pd

files = [
    "ravenstack_accounts.csv",
    "ravenstack_subscriptions.csv",
    "ravenstack_feature_usage.csv",
    "ravenstack_support_tickets.csv",
    "ravenstack_churn_events.csv"
]

for file in files:
    print("\n" + "="*60)
    print(file.upper())
    print("="*60)

    df = pd.read_csv(file)

    print("\nShape:", df.shape)

    print("\nMissing Values:")
    print(df.isnull().sum())

    print("\nDuplicate Rows:")
    print(df.duplicated().sum())