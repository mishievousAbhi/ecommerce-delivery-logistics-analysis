

-- =====================================================
-- Project: E-commerce Delivery & Logistics Performance Analysis
-- File: data_validation.sql
-- Purpose: Validate order IDs, timestamps and order status
-- Database: MySQL - ecommerce_logistics
-- =====================================================

USE ecommerce_logistics;

-- 1. Validate total rows and unique order IDs
SELECT
    COUNT(*) AS total_rows,
    COUNT(order_id) AS non_missing_order_ids,
    COUNT(DISTINCT order_id) AS unique_order_ids
FROM orders;

-- 2. Check missing delivery timestamps
SELECT
    COUNT(*) AS total_orders,
    SUM(order_delivered_customer_date IS NULL)
        AS missing_actual_delivery_date,
    SUM(order_estimated_delivery_date IS NULL)
        AS missing_estimated_delivery_date
FROM orders;

-- 3. Count orders by status
SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- 4. Check missing purchase timestamps
SELECT
    COUNT(*) AS total_orders,
    SUM(order_purchase_timestamp IS NULL)
        AS missing_purchase_timestamps
FROM orders;

-- 5. Validate invalid delivery date order
SELECT
    COUNT(*) AS invalid_delivery_date_rows
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_purchase_timestamp IS NOT NULL
  AND order_delivered_customer_date < order_purchase_timestamp;

-- 6. Validate orders-to-customers relationship
SELECT
    COUNT(*) AS total_orders,
    COUNT(c.customer_id) AS matched_customer_rows,
    COUNT(DISTINCT o.customer_id) AS unique_order_customers,
    COUNT(DISTINCT c.customer_id) AS matched_unique_customers
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id;

-- 7. Validate orders-to-order_items relationship
SELECT
    COUNT(*) AS total_order_items,
    COUNT(o.order_id) AS matched_order_items,
    COUNT(DISTINCT oi.order_id) AS unique_orders_in_items,
    COUNT(DISTINCT o.order_id) AS matched_unique_orders
FROM order_items oi
LEFT JOIN orders o
    ON oi.order_id = o.order_id;


-- 8. Validate payments-to-orders relationship
SELECT
    COUNT(*) AS total_payments,
    COUNT(o.order_id) AS matched_payments,
    COUNT(DISTINCT p.order_id) AS unique_payment_orders,
    COUNT(DISTINCT o.order_id) AS matched_unique_orders
FROM payments p
LEFT JOIN orders o
    ON p.order_id = o.order_id;

-- 9. Validate reviews-to-orders relationship
SELECT
    COUNT(*) AS total_reviews,
    COUNT(r.order_id) AS reviews_with_order_id,
    COUNT(o.order_id) AS matched_reviews,
    COUNT(DISTINCT r.order_id) AS unique_review_orders
FROM reviews r
LEFT JOIN orders o
    ON r.order_id = o.order_id;