import pandas as pd
accounts = pd.read_csv("ravenstack_accounts.csv")
churn_rate = (
    accounts["churn_flag"].mean()
) * 100
print(f"Overall Churn Rate: {churn_rate:.2f}%")