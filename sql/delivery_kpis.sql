
-- =====================================================
-- Project: E-commerce Delivery & Logistics Performance Analysis
-- File: delivery_kpis.sql
-- Purpose: Calculate delivery and cancellation KPIs
-- Database: MySQL - ecommerce_logistics
-- =====================================================

USE ecommerce_logistics;

-- KPI 1: Total orders and cancellation rate
SELECT
    COUNT(*) AS total_orders,
    SUM(LOWER(order_status) = 'canceled') AS cancelled_orders,
    ROUND(
        100.0 * SUM(LOWER(order_status) = 'canceled')
        / NULLIF(COUNT(*), 0),
        2
    ) AS cancellation_rate_pct
FROM orders;

-- KPI 2: Average delivery duration in days
SELECT
    COUNT(*) AS eligible_orders,
    ROUND(
        AVG(
            TIMESTAMPDIFF(
                SECOND,
                order_purchase_timestamp,
                order_delivered_customer_date
            ) / 86400.0
        ),
        2
    ) AS average_delivery_days
FROM orders
WHERE LOWER(order_status) = 'delivered'
  AND order_purchase_timestamp IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
  AND order_delivered_customer_date >= order_purchase_timestamp;

-- KPI 3: Average delivery delay in days
-- Positive = late; negative = early
SELECT
    COUNT(*) AS eligible_orders,
    ROUND(
        AVG(
            TIMESTAMPDIFF(
                SECOND,
                order_estimated_delivery_date,
                order_delivered_customer_date
            ) / 86400.0
        ),
        2
    ) AS average_delay_days
FROM orders
WHERE LOWER(order_status) = 'delivered'
  AND order_purchase_timestamp IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL
  AND order_delivered_customer_date >= order_purchase_timestamp;

-- KPI 4: On-time delivery rate
-- Denominator: delivered orders with valid actual and estimated dates
SELECT
    COUNT(*) AS eligible_orders,
    SUM(
        order_delivered_customer_date <= order_estimated_delivery_date
    ) AS on_time_orders,
    SUM(
        order_delivered_customer_date > order_estimated_delivery_date
    ) AS late_orders,
    ROUND(
        100.0 * SUM(
            order_delivered_customer_date <= order_estimated_delivery_date
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS on_time_rate_pct
FROM orders
WHERE LOWER(order_status) = 'delivered'
  AND order_purchase_timestamp IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL
  AND order_delivered_customer_date >= order_purchase_timestamp;


-- =====================================================
-- KPI 5: Data quality validation
-- =====================================================
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS unique_orders,
    SUM(order_id IS NULL) AS missing_order_ids,
    SUM(order_purchase_timestamp IS NULL) AS missing_purchase_dates,
    SUM(order_delivered_customer_date IS NULL) AS missing_delivery_dates,
    SUM(order_estimated_delivery_date IS NULL) AS missing_estimated_dates
FROM orders;

-- =====================================================
-- KPI 6: Order status distribution
-- =====================================================
SELECT
    order_status,
    COUNT(*) AS order_count
FROM orders
GROUP BY order_status
ORDER BY order_count DESC;

-- =====================================================
-- KPI 7: Monthly delivery performance
-- =====================================================
SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS order_month,
    COUNT(*) AS delivered_orders,
    ROUND(
        AVG(TIMESTAMPDIFF(
            SECOND,
            order_purchase_timestamp,
            order_delivered_customer_date
        ) / 86400.0), 2
    ) AS avg_delivery_days,
    ROUND(
        AVG(TIMESTAMPDIFF(
            SECOND,
            order_estimated_delivery_date,
            order_delivered_customer_date
        ) / 86400.0), 2
    ) AS avg_delay_days,
    SUM(
        order_delivered_customer_date <= order_estimated_delivery_date
    ) AS on_time_orders,
    SUM(
        order_delivered_customer_date > order_estimated_delivery_date
    ) AS late_orders
FROM orders
WHERE LOWER(order_status) = 'delivered'
  AND order_purchase_timestamp IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL
  AND order_delivered_customer_date >= order_purchase_timestamp
GROUP BY DATE_FORMAT(order_purchase_timestamp, '%Y-%m')
ORDER BY order_month;

-- =====================================================
-- KPI 8: Monthly late delivery percentage
-- =====================================================
SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS order_month,
    COUNT(*) AS delivered_orders,
    SUM(
        order_delivered_customer_date > order_estimated_delivery_date
    ) AS late_orders,
    ROUND(
        100.0 * SUM(
            order_delivered_customer_date > order_estimated_delivery_date
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS late_delivery_pct
FROM orders
WHERE LOWER(order_status) = 'delivered'
  AND order_purchase_timestamp IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL
  AND order_delivered_customer_date >= order_purchase_timestamp
GROUP BY DATE_FORMAT(order_purchase_timestamp, '%Y-%m')
ORDER BY late_delivery_pct DESC;
