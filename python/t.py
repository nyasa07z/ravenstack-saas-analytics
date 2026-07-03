import pandas as pd

df = pd.read_csv("ravenstack_feature_usage.csv")

print("Rows:", len(df))
print("Unique usage IDs:", df["usage_id"].nunique())
print("Duplicate usage IDs:", df["usage_id"].duplicated().sum())

duplicates = df[df["usage_id"].duplicated(keep=False)]

print("\nDuplicate IDs:")
print(duplicates.sort_values("usage_id").head(20))