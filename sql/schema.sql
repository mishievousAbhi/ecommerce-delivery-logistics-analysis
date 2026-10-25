
-- =====================================================
-- Project: E-commerce Delivery & Logistics Performance Analysis
-- Owner: Mahima Prajapati
-- File: schema.sql
-- Database: MySQL - ecommerce_logistics
-- =====================================================

USE ecommerce_logistics;

-- Create orders table
CREATE TABLE IF NOT EXISTS orders (
    order_id VARCHAR(50) NOT NULL,
    customer_id VARCHAR(50),
    order_status VARCHAR(30),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME,
    CONSTRAINT pk_orders PRIMARY KEY (order_id)
);

-- Verify table structure
DESCRIBE orders;

-- Verify primary key
SHOW KEYS FROM orders
WHERE Key_name = 'PRIMARY';

-- Verify imported row count
SELECT COUNT(*) AS total_orders
FROM orders;

-- Check duplicate order IDs
SELECT order_id, COUNT(*) AS occurrences
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;
