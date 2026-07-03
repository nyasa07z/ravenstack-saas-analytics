import pandas as pd

# Load data
df = pd.read_csv("ravenstack_feature_usage.csv")

print("Original rows:", len(df))
print("Duplicate usage IDs:", df["usage_id"].duplicated().sum())

# Keep the first occurrence of each usage_id
df = df.drop_duplicates(subset="usage_id", keep="first")

print("Rows after cleaning:", len(df))

# Save cleaned file
df.to_csv("ravenstack_feature_usage_clean.csv", index=False)

print("Cleaned file saved successfully!")