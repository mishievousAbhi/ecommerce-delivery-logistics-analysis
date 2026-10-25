"""Audit the quality of the e-commerce logistics dataset."""
from pathlib import Path
import pandas as pd

# Locate the project and raw data folders
PROJECT_DIR = Path(__file__).resolve().parent.parent
RAW_DIR = PROJECT_DIR / "Data" / "raw"
REPORT_DIR = PROJECT_DIR / "reports"

REPORT_DIR.mkdir(parents=True, exist_ok=True)

csv_files = sorted(RAW_DIR.glob("*.csv"))

if not csv_files:
    raise FileNotFoundError(
        f"No CSV files found in: {RAW_DIR}. "
        "Please place your 9 CSV files in Data/raw."
    )

summary = []
column_details = []

for file_path in csv_files:
    print(f"\nAuditing: {file_path.name}")

    df = pd.read_csv(file_path, low_memory=False)

    summary.append({
        "file_name": file_path.name,
        "rows": len(df),
        "columns": len(df.columns),
        "duplicate_rows": int(df.duplicated().sum()),
        "missing_cells": int(df.isna().sum().sum()),
    })

    for column in df.columns:
        column_details.append({
            "file_name": file_path.name,
            "column": column,
            "data_type": str(df[column].dtype),
            "missing_count": int(df[column].isna().sum()),
            "missing_percent": round(
                df[column].isna().mean() * 100, 2
            ),
            "unique_values": int(df[column].nunique()),
        })

    print(f"Rows: {len(df):,}")
    print(f"Columns: {len(df.columns)}")
    print(f"Duplicate rows: {df.duplicated().sum():,}")
    print(f"Missing cells: {df.isna().sum().sum():,}")

pd.DataFrame(summary).to_csv(
    REPORT_DIR / "data_quality_summary.csv", index=False
)

pd.DataFrame(column_details).to_csv(
    REPORT_DIR / "column_quality_details.csv", index=False
)

print("\nAudit completed successfully!")
print(f"Reports saved in: {REPORT_DIR}")
