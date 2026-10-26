
import csv
from pathlib import Path
import mysql.connector

PROJECT_ROOT = Path(__file__).resolve().parents[1]
CSV_PATH = PROJECT_ROOT / "data" / "raw" / "olist_orders_dataset.csv"
BATCH_SIZE = 2000

COLUMNS = [
    "order_id",
    "customer_id",
    "order_status",
    "order_purchase_timestamp",
    "order_approved_at",
    "order_delivered_carrier_date",
    "order_delivered_customer_date",
    "order_estimated_delivery_date",
]


def main():
    if not CSV_PATH.exists():
        raise FileNotFoundError(f"CSV not found: {CSV_PATH}")

    conn = mysql.connector.connect(
        host="localhost",
        user="root",
        password="password",
        database="ecommerce_logistics",
    )

    cursor = conn.cursor()

    try:
        # Clear only the staging table before a fresh import.
        cursor.execute("TRUNCATE TABLE orders_staging")
        conn.commit()

        placeholders = ", ".join(["%s"] * len(COLUMNS))
        column_names = ", ".join(f"`{col}`" for col in COLUMNS)

        insert_sql = (
            f"INSERT INTO orders_staging ({column_names}) "
            f"VALUES ({placeholders})"
        )

        total = 0
        batch = []

        with CSV_PATH.open(
            "r", encoding="utf-8-sig", newline=""
        ) as file:
            reader = csv.DictReader(file)

            for row in reader:
                values = tuple(
                    row.get(col) or None for col in COLUMNS
                )
                batch.append(values)

                if len(batch) >= BATCH_SIZE:
                    cursor.executemany(insert_sql, batch)
                    conn.commit()
                    total += len(batch)
                    print(f"Imported {total:,} rows")
                    batch.clear()

            if batch:
                cursor.executemany(insert_sql, batch)
                conn.commit()
                total += len(batch)

        cursor.execute("SELECT COUNT(*) FROM orders_staging")
        count = cursor.fetchone()[0]

        print(f"\nImport complete! Rows imported: {total:,}")
        print(f"Rows verified in staging: {count:,}")

    except Exception:
        conn.rollback()
        raise

    finally:
        cursor.close()
        conn.close()


if __name__ == "__main__":
    main()
