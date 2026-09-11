-- C2B B01 Advanced SQL - PostgreSQL lab setup - INTERNAL QA
-- Target dialect: PostgreSQL 18-compatible analytical SQL.
-- Re-runnable: drops only this course schema.

DROP SCHEMA IF EXISTS c2b_b01_lab CASCADE;
CREATE SCHEMA c2b_b01_lab;
SET search_path TO c2b_b01_lab;

CREATE TABLE customers (
  customer_id integer PRIMARY KEY,
  customer_name text NOT NULL,
  region text NOT NULL,
  segment text NOT NULL
);
CREATE TABLE orders (
  order_id integer PRIMARY KEY,
  customer_id integer NOT NULL REFERENCES customers(customer_id),
  order_date date NOT NULL,
  status text NOT NULL CHECK (status IN ('Completed','Cancelled','Pending')),
  booked_region text NOT NULL,
  shipping_fee numeric(10,2) NOT NULL CHECK (shipping_fee >= 0)
);
CREATE TABLE order_items (
  order_item_id integer PRIMARY KEY,
  order_id integer NOT NULL REFERENCES orders(order_id),
  product_id integer NOT NULL,
  qty integer NOT NULL CHECK (qty > 0),
  unit_price numeric(10,2) NOT NULL CHECK (unit_price > 0),
  discount_pct numeric(6,4) NOT NULL CHECK (discount_pct BETWEEN 0 AND 1)
);
CREATE TABLE customer_region_history (
  history_id integer PRIMARY KEY,
  customer_id integer NOT NULL REFERENCES customers(customer_id),
  region text NOT NULL,
  valid_from date NOT NULL,
  valid_to date
);
CREATE TABLE order_events (
  event_id integer PRIMARY KEY,
  order_id integer NOT NULL,
  event_type text NOT NULL,
  event_ts timestamp NOT NULL
);

INSERT INTO customers (customer_id,customer_name,region,segment) VALUES
(1,'Aarav Retail','North','SMB'),
(2,'Bright Mart','West','SMB'),
(3,'Cedar Stores','South','Mid'),
(4,'Delta Wholesale','East','Enterprise'),
(5,'Evergreen Shop','West','Mid'),
(6,'Fusion Retail','North','Mid'),
(7,'Galaxy Outlet','East','SMB'),
(8,'Harbor Traders','South','Enterprise'),
(9,'Indigo Mart','West','SMB'),
(10,'Jupiter Retail','North','Enterprise');

INSERT INTO orders (order_id,customer_id,order_date,status,booked_region,shipping_fee) VALUES
(1,4,'2026-01-05','Completed','East',150),
(2,7,'2026-01-08','Completed','East',180),
(3,10,'2026-01-11','Cancelled','North',200),
(4,3,'2026-01-14','Pending','South',120),
(5,6,'2026-01-17','Completed','North',150),
(6,9,'2026-01-20','Completed','West',180),
(7,2,'2026-01-23','Completed','West',200),
(8,5,'2026-01-26','Cancelled','West',120),
(9,8,'2026-01-29','Pending','South',150),
(10,1,'2026-02-01','Completed','North',180),
(11,4,'2026-02-04','Completed','East',200),
(12,7,'2026-02-07','Completed','East',120),
(13,10,'2026-02-10','Cancelled','North',150),
(14,3,'2026-02-13','Pending','South',180),
(15,6,'2026-02-16','Completed','North',200),
(16,9,'2026-02-19','Completed','West',120),
(17,2,'2026-02-22','Completed','West',150),
(18,5,'2026-02-25','Cancelled','West',180),
(19,8,'2026-02-28','Pending','South',200),
(20,1,'2026-03-03','Completed','North',120),
(21,4,'2026-03-06','Completed','East',150),
(22,7,'2026-03-09','Completed','East',180),
(23,10,'2026-03-12','Cancelled','North',200),
(24,3,'2026-03-15','Pending','South',120);

INSERT INTO order_items (order_item_id,order_id,product_id,qty,unit_price,discount_pct) VALUES
(1,1,2,2,700,0.05),
(2,1,3,3,950,0.1),
(3,2,3,3,950,0.1),
(4,2,4,4,1200,0),
(5,2,5,1,1600,0.05),
(6,3,4,4,1200,0),
(7,4,5,1,1600,0.05),
(8,4,6,2,2100,0.1),
(9,5,6,2,2100,0.1),
(10,5,7,3,2800,0),
(11,5,8,4,3400,0.05),
(12,6,7,3,2800,0),
(13,7,8,4,3400,0.05),
(14,7,1,1,450,0.1),
(15,8,1,1,450,0.1),
(16,8,2,2,700,0),
(17,8,3,3,950,0.05),
(18,9,2,2,700,0),
(19,10,3,3,950,0.05),
(20,10,4,4,1200,0.1),
(21,11,4,4,1200,0.1),
(22,11,5,1,1600,0),
(23,11,6,2,2100,0.05),
(24,12,5,1,1600,0),
(25,13,6,2,2100,0.05),
(26,13,7,3,2800,0.1),
(27,14,7,3,2800,0.1),
(28,14,8,4,3400,0),
(29,14,1,1,450,0.05),
(30,15,8,4,3400,0),
(31,16,1,1,450,0.05),
(32,16,2,2,700,0.1),
(33,17,2,2,700,0.1),
(34,17,3,3,950,0),
(35,17,4,4,1200,0.05),
(36,18,3,3,950,0),
(37,19,4,4,1200,0.05),
(38,19,5,1,1600,0.1),
(39,20,5,1,1600,0.1),
(40,20,6,2,2100,0),
(41,20,7,3,2800,0.05),
(42,21,6,2,2100,0),
(43,22,7,3,2800,0.05),
(44,22,8,4,3400,0.1),
(45,23,8,4,3400,0.1),
(46,23,1,1,450,0),
(47,23,2,2,700,0.05),
(48,24,1,1,450,0);

INSERT INTO customer_region_history (history_id,customer_id,region,valid_from,valid_to) VALUES
(1,1,'North','2025-01-01','2025-12-31'),
(2,1,'North','2026-01-01',NULL),
(3,2,'East','2025-01-01','2025-09-30'),
(4,2,'West','2025-10-01',NULL),
(5,3,'South','2025-01-01',NULL),
(6,4,'East','2025-01-01',NULL),
(7,5,'West','2025-01-01',NULL),
(8,6,'North','2025-01-01',NULL),
(9,7,'East','2025-01-01',NULL),
(10,8,'South','2025-01-01',NULL),
(11,9,'West','2025-01-01',NULL),
(12,10,'North','2025-01-01',NULL);

INSERT INTO order_events (event_id,order_id,event_type,event_ts) VALUES
(1,1,'created','2026-01-05 09:00:00'),
(2,1,'completed','2026-01-06 12:00:00'),
(3,2,'created','2026-01-08 09:00:00'),
(4,2,'completed','2026-01-09 12:00:00'),
(5,3,'created','2026-01-11 09:00:00'),
(6,4,'created','2026-01-14 09:00:00'),
(7,5,'created','2026-01-17 09:00:00'),
(8,5,'completed','2026-01-18 12:00:00'),
(9,6,'created','2026-01-20 09:00:00'),
(10,6,'completed','2026-01-21 12:00:00'),
(11,7,'created','2026-01-23 09:00:00'),
(12,7,'completed','2026-01-24 12:00:00'),
(13,8,'created','2026-01-26 09:00:00'),
(14,9,'created','2026-01-29 09:00:00'),
(15,10,'created','2026-02-01 09:00:00'),
(16,10,'completed','2026-02-02 12:00:00'),
(17,11,'created','2026-02-04 09:00:00'),
(18,11,'completed','2026-02-05 12:00:00'),
(19,12,'created','2026-02-07 09:00:00'),
(20,12,'completed','2026-02-08 12:00:00'),
(21,13,'created','2026-02-10 09:00:00'),
(22,14,'created','2026-02-13 09:00:00'),
(23,15,'created','2026-02-16 09:00:00'),
(24,15,'completed','2026-02-17 12:00:00'),
(25,16,'created','2026-02-19 09:00:00'),
(26,16,'completed','2026-02-20 12:00:00'),
(27,17,'created','2026-02-22 09:00:00'),
(28,17,'completed','2026-02-23 12:00:00'),
(29,18,'created','2026-02-25 09:00:00'),
(30,19,'created','2026-02-28 09:00:00'),
(31,20,'created','2026-03-03 09:00:00'),
(32,20,'completed','2026-03-04 12:00:00'),
(33,21,'created','2026-03-06 09:00:00'),
(34,21,'completed','2026-03-07 12:00:00'),
(35,22,'created','2026-03-09 09:00:00'),
(36,22,'completed','2026-03-10 12:00:00'),
(37,23,'created','2026-03-12 09:00:00'),
(38,24,'created','2026-03-15 09:00:00'),
(39,5,'created','2026-01-17 09:00:00');


-- TRUSTED RAW CONTROLS: record these before practice.
SELECT COUNT(*) AS customers_rows FROM customers;          -- 10
SELECT COUNT(*) AS orders_rows FROM orders;                -- 24
SELECT COUNT(*) AS order_items_rows FROM order_items;      -- 48
SELECT COUNT(*) AS region_history_rows FROM customer_region_history; -- 12
SELECT COUNT(*) AS event_rows FROM order_events;           -- 39
SELECT COUNT(DISTINCT order_id) AS orders_with_items FROM order_items; -- 24

-- Purposeful trap:
-- customer_region_history is historical and can have >1 row/customer.
-- A naive join on customer_id alone can multiply current-order rows.
