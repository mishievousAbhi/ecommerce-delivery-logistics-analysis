
USE ecommerce_logistics;


-- =====================================================
-- WEEK 3: DEEPER ANALYSIS & OPERATIONAL OPPORTUNITIES
-- Project: E-commerce Delivery & Logistics Performance
-- =====================================================


-- TASK 1: Weekday-wise Cancellation Analysis
-- Purpose: Identify which weekdays have higher cancellation rates.

SELECT
    DAYNAME(order_purchase_timestamp) AS order_day,
    COUNT(*) AS total_orders,
    SUM(LOWER(order_status) = 'canceled') AS cancelled_orders,
    ROUND(
        100.0 * SUM(LOWER(order_status) = 'canceled')
        / NULLIF(COUNT(*), 0),
        2
    ) AS cancellation_rate_pct
FROM orders
WHERE order_purchase_timestamp IS NOT NULL
GROUP BY
    DAYOFWEEK(order_purchase_timestamp),
    DAYNAME(order_purchase_timestamp)
ORDER BY DAYOFWEEK(order_purchase_timestamp);


-- TASK 2: Weekday-wise Delivery Delay Analysis
-- Purpose: Compare average delay and late-delivery rates by order weekday.
-- Negative average delay means delivery was earlier than estimated.

SELECT
    DAYNAME(order_purchase_timestamp) AS order_day,
    COUNT(*) AS delivered_orders,
    ROUND(
        AVG(
            DATEDIFF(
                order_delivered_customer_date,
                order_estimated_delivery_date
            )
        ),
        2
    ) AS average_delay_days,
    ROUND(
        100.0 * SUM(
            order_delivered_customer_date >
            order_estimated_delivery_date
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS late_delivery_rate_pct
FROM orders
WHERE LOWER(order_status) = 'delivered'
  AND order_purchase_timestamp IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL
  AND order_delivered_customer_date >= order_purchase_timestamp
GROUP BY
    DAYOFWEEK(order_purchase_timestamp),
    DAYNAME(order_purchase_timestamp)
ORDER BY DAYOFWEEK(order_purchase_timestamp);


-- TASK 3: Processing Time vs Transit Time
-- Purchase to carrier = time until carrier handover.
-- Carrier to customer = time from handover until delivery.

SELECT
    COUNT(*) AS eligible_orders,
    ROUND(
        AVG(
            TIMESTAMPDIFF(
                HOUR,
                order_purchase_timestamp,
                order_delivered_carrier_date
            )
        ) / 24,
        2
    ) AS purchase_to_carrier_days,
    ROUND(
        AVG(
            TIMESTAMPDIFF(
                HOUR,
                order_delivered_carrier_date,
                order_delivered_customer_date
            )
        ) / 24,
        2
    ) AS carrier_to_customer_days
FROM orders
WHERE LOWER(order_status) = 'delivered'
  AND order_purchase_timestamp IS NOT NULL
  AND order_delivered_carrier_date IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
  AND order_delivered_carrier_date >= order_purchase_timestamp
  AND order_delivered_customer_date >= order_delivered_carrier_date;


-- TASK 4: Overall Order and Missing-Date Validation
-- Purpose: Check order totals and missing delivery-related dates.

SELECT
    COUNT(*) AS total_orders,
    SUM(LOWER(order_status) = 'delivered') AS delivered_orders,
    SUM(LOWER(order_status) = 'canceled') AS cancelled_orders,
    SUM(
        order_purchase_timestamp IS NULL
    ) AS missing_purchase_date,
    SUM(
        LOWER(order_status) = 'delivered'
        AND order_delivered_customer_date IS NULL
    ) AS delivered_without_delivery_date,
    SUM(
        LOWER(order_status) = 'delivered'
        AND order_estimated_delivery_date IS NULL
    ) AS delivered_without_estimated_date
FROM orders;
