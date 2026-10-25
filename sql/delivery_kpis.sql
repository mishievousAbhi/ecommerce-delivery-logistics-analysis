
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
