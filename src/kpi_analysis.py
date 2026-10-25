
from pathlib import Path
import pandas as pd

# Project paths
PROJECT_ROOT = Path(__file__).resolve().parents[1]
DATA_PATH = PROJECT_ROOT / "data" / "raw" / "olist_orders_dataset.csv"
OUTPUT_PATH = PROJECT_ROOT / "reports" / "delivery_kpi_summary.csv"


def main():
    # Load orders dataset
    orders = pd.read_csv(DATA_PATH)

    # Parse timestamps
    date_columns = [
        "order_purchase_timestamp",
        "order_delivered_customer_date",
        "order_estimated_delivery_date",
    ]

    for col in date_columns:
        orders[col] = pd.to_datetime(orders[col], errors="coerce")

    status = orders["order_status"].astype("string").str.lower()

    total_orders = len(orders)
    cancelled_orders = int(status.eq("canceled").sum())

    cancellation_rate = (
        cancelled_orders / total_orders * 100
        if total_orders else 0
    )

    # Eligible delivered orders
    delivered = orders.loc[status.eq("delivered")].copy()

    # Delivery duration: purchase to actual delivery
    valid_duration = (
        delivered["order_purchase_timestamp"].notna()
        & delivered["order_delivered_customer_date"].notna()
        & (
            delivered["order_delivered_customer_date"]
            >= delivered["order_purchase_timestamp"]
        )
    )

    duration_orders = delivered.loc[valid_duration].copy()

    duration_days = (
        duration_orders["order_delivered_customer_date"]
        - duration_orders["order_purchase_timestamp"]
    ).dt.total_seconds() / 86400

    average_delivery_days = duration_days.mean()

    # Delay: actual delivery minus estimated delivery
    valid_delay = (
        delivered["order_purchase_timestamp"].notna()
        & delivered["order_delivered_customer_date"].notna()
        & delivered["order_estimated_delivery_date"].notna()
        & (
            delivered["order_delivered_customer_date"]
            >= delivered["order_purchase_timestamp"]
        )
    )

    delay_orders = delivered.loc[valid_delay].copy()

    delay_days = (
        delay_orders["order_delivered_customer_date"]
        - delay_orders["order_estimated_delivery_date"]
    ).dt.total_seconds() / 86400

    average_delay_days = delay_days.mean()

    # On-time delivery: actual delivery <= estimated delivery
    on_time_orders = int(
        (
            delay_orders["order_delivered_customer_date"]
            <= delay_orders["order_estimated_delivery_date"]
        ).sum()
    )

    late_orders = int(
        (
            delay_orders["order_delivered_customer_date"]
            > delay_orders["order_estimated_delivery_date"]
        ).sum()
    )

    eligible_delivery_orders = len(delay_orders)

    on_time_rate = (
        on_time_orders / eligible_delivery_orders * 100
        if eligible_delivery_orders else 0
    )

    # Build summary
    summary = pd.DataFrame([
        {
            "kpi": "total_orders",
            "value": total_orders,
            "eligible_orders": total_orders,
        },
        {
            "kpi": "cancelled_orders",
            "value": cancelled_orders,
            "eligible_orders": total_orders,
        },
        {
            "kpi": "cancellation_rate_pct",
            "value": round(cancellation_rate, 2),
            "eligible_orders": total_orders,
        },
        {
            "kpi": "average_delivery_days",
            "value": round(average_delivery_days, 2)
            if pd.notna(average_delivery_days) else None,
            "eligible_orders": len(duration_orders),
        },
        {
            "kpi": "average_delay_days",
            "value": round(average_delay_days, 2)
            if pd.notna(average_delay_days) else None,
            "eligible_orders": eligible_delivery_orders,
        },
        {
            "kpi": "on_time_orders",
            "value": on_time_orders,
            "eligible_orders": eligible_delivery_orders,
        },
        {
            "kpi": "late_orders",
            "value": late_orders,
            "eligible_orders": eligible_delivery_orders,
        },
        {
            "kpi": "on_time_rate_pct",
            "value": round(on_time_rate, 2),
            "eligible_orders": eligible_delivery_orders,
        },
    ])

    OUTPUT_PATH.parent.mkdir(parents=True, exist_ok=True)
    summary.to_csv(OUTPUT_PATH, index=False)

    print("\nDelivery KPI Summary")
    print(summary.to_string(index=False))
    print(f"\nSaved report to: {OUTPUT_PATH}")


if __name__ == "__main__":
    main()
