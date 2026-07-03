import pandas as pd

# Load dataset
accounts = pd.read_csv("ravenstack_accounts.csv")

print("="*50)
print("DATASET OVERVIEW")
print("="*50)
print("\nShape:")
print(accounts.shape)

print("\nColumn Names:")
print(accounts.columns.tolist())

print("\nData Types:")
print(accounts.dtypes)

# -----------------------------
# Missing Values
# -----------------------------
print("\n" + "="*50)
print("MISSING VALUES")
print("="*50)
print(accounts.isnull().sum())

# -----------------------------
# Duplicate Rows
# -----------------------------
print("\n" + "="*50)
print("DUPLICATES")
print("="*50)
print("Duplicate Rows:", accounts.duplicated().sum())

# -----------------------------
# Duplicate Account IDs
# -----------------------------
print("\n" + "="*50)
print("DUPLICATE ACCOUNT IDs")
print("="*50)
print("Duplicate account_ids:", accounts["account_id"].duplicated().sum())

# -----------------------------
# Unique Values in Categories
# -----------------------------
categorical_cols = [
    "industry",
    "country",
    "referral_source",
    "plan_tier",
    "is_trial",
    "churn_flag"
]

for col in categorical_cols:
    print("\n" + "="*50)
    print(f"UNIQUE VALUES: {col}")
    print("="*50)
    print(accounts[col].value_counts(dropna=False))

# -----------------------------
# Check Seats Column
# -----------------------------
print("\n" + "="*50)
print("SEATS SUMMARY")
print("="*50)
print(accounts["seats"].describe())

print("\nRows with invalid seats (<=0):")
print(accounts[accounts["seats"] <= 0])

# -----------------------------
# Date Column Check
# -----------------------------
print("\n" + "="*50)
print("DATE CHECK")
print("="*50)

accounts["signup_date"] = pd.to_datetime(
    accounts["signup_date"],
    errors="coerce"
)

print("Invalid dates:")
print(accounts[accounts["signup_date"].isna()])

# -----------------------------
# Summary
# -----------------------------
print("\n" + "="*50)
print("CLEANING SUMMARY")
print("="*50)

print("Missing Values:", accounts.isnull().sum().sum())
print("Duplicate Rows:", accounts.duplicated().sum())
print("Duplicate Account IDs:", accounts["account_id"].duplicated().sum())
print("Invalid Seats:", len(accounts[accounts["seats"] <= 0]))
print("Invalid Dates:", accounts["signup_date"].isna().sum())