-- C2B B01 GATE A - RETAIL ORDERS - PROTECTED FIRST ATTEMPT - INTERNAL QA
-- CLOSED: lesson book, practice review, tutorials and AI solving.
-- Allowed: this case file + your own PostgreSQL client + explicitly permitted syntax reference if needed.
-- Evidence: query + input/output grain + independent validation + concise defense.
DROP SCHEMA IF EXISTS c2b_b01_gate_a CASCADE;
CREATE SCHEMA c2b_b01_gate_a;
SET search_path TO c2b_b01_gate_a;

CREATE TABLE customers(customer_id int PRIMARY KEY, customer_name text NOT NULL, region text NOT NULL);
CREATE TABLE orders(order_id int PRIMARY KEY, customer_id int NOT NULL REFERENCES customers(customer_id), order_date date NOT NULL, status text NOT NULL, shipping_fee numeric(10,2) NOT NULL);
CREATE TABLE order_items(item_id int PRIMARY KEY, order_id int NOT NULL REFERENCES orders(order_id), sku text NOT NULL, qty int NOT NULL, unit_price numeric(10,2) NOT NULL, discount_pct numeric(6,4) NOT NULL);
CREATE TABLE order_promotions(promo_id int PRIMARY KEY, order_id int NOT NULL REFERENCES orders(order_id), channel text NOT NULL);
CREATE TABLE order_events(event_id int PRIMARY KEY, order_id int NOT NULL, event_type text NOT NULL, event_ts timestamp NOT NULL);

INSERT INTO customers (customer_id,customer_name,region) VALUES
(1,'Retail Customer 01','North'),
(2,'Retail Customer 02','South'),
(3,'Retail Customer 03','East'),
(4,'Retail Customer 04','West'),
(5,'Retail Customer 05','North'),
(6,'Retail Customer 06','South'),
(7,'Retail Customer 07','East'),
(8,'Retail Customer 08','West'),
(9,'Retail Customer 09','North'),
(10,'Retail Customer 10','South');

INSERT INTO orders (order_id,customer_id,order_date,status,shipping_fee) VALUES
(1,8,'2026-03-03','Completed',125),
(2,5,'2026-03-05','Completed',150),
(3,2,'2026-03-07','Cancelled',175),
(4,9,'2026-03-09','Pending',100),
(5,6,'2026-03-11','Completed',125),
(6,3,'2026-03-13','Completed',150),
(7,10,'2026-03-15','Completed',175),
(8,7,'2026-03-17','Cancelled',100),
(9,4,'2026-03-19','Pending',125),
(10,1,'2026-03-21','Completed',150),
(11,8,'2026-03-23','Completed',175),
(12,5,'2026-03-25','Completed',100),
(13,2,'2026-03-27','Cancelled',125),
(14,9,'2026-03-29','Pending',150),
(15,6,'2026-03-31','Completed',175),
(16,3,'2026-04-02','Completed',100),
(17,10,'2026-04-04','Completed',125),
(18,7,'2026-04-06','Cancelled',150),
(19,4,'2026-04-08','Pending',175),
(20,1,'2026-03-01','Completed',100),
(21,8,'2026-03-03','Completed',125),
(22,5,'2026-03-05','Completed',150),
(23,2,'2026-03-07','Cancelled',175),
(24,9,'2026-03-09','Pending',100);

INSERT INTO order_items (item_id,order_id,sku,qty,unit_price,discount_pct) VALUES
(1,1,'SKU2',2,750,0.05),
(2,1,'SKU3',3,1100,0.1),
(3,2,'SKU3',3,1100,0.1),
(4,2,'SKU4',4,1600,0),
(5,2,'SKU5',1,2200,0.05),
(6,3,'SKU4',4,1600,0),
(7,4,'SKU5',1,2200,0.05),
(8,4,'SKU6',2,500,0.1),
(9,5,'SKU6',2,500,0.1),
(10,5,'SKU7',3,750,0),
(11,5,'SKU1',4,1100,0.05),
(12,6,'SKU7',3,750,0),
(13,7,'SKU1',4,1100,0.05),
(14,7,'SKU2',1,1600,0.1),
(15,8,'SKU2',1,1600,0.1),
(16,8,'SKU3',2,2200,0),
(17,8,'SKU4',3,500,0.05),
(18,9,'SKU3',2,2200,0),
(19,10,'SKU4',3,500,0.05),
(20,10,'SKU5',4,750,0.1),
(21,11,'SKU5',4,750,0.1),
(22,11,'SKU6',1,1100,0),
(23,11,'SKU7',2,1600,0.05),
(24,12,'SKU6',1,1100,0),
(25,13,'SKU7',2,1600,0.05),
(26,13,'SKU1',3,2200,0.1),
(27,14,'SKU1',3,2200,0.1),
(28,14,'SKU2',4,500,0),
(29,14,'SKU3',1,750,0.05),
(30,15,'SKU2',4,500,0),
(31,16,'SKU3',1,750,0.05),
(32,16,'SKU4',2,1100,0.1),
(33,17,'SKU4',2,1100,0.1),
(34,17,'SKU5',3,1600,0),
(35,17,'SKU6',4,2200,0.05),
(36,18,'SKU5',3,1600,0),
(37,19,'SKU6',4,2200,0.05),
(38,19,'SKU7',1,500,0.1),
(39,20,'SKU7',1,500,0.1),
(40,20,'SKU1',2,750,0),
(41,20,'SKU2',3,1100,0.05),
(42,21,'SKU1',2,750,0),
(43,22,'SKU2',3,1100,0.05),
(44,22,'SKU3',4,1600,0.1),
(45,23,'SKU3',4,1600,0.1),
(46,23,'SKU4',1,2200,0),
(47,23,'SKU5',2,500,0.05),
(48,24,'SKU4',1,2200,0);

INSERT INTO order_promotions (promo_id,order_id,channel) VALUES
(1,2,'EMAIL'),
(2,4,'EMAIL'),
(3,6,'EMAIL'),
(4,6,'PARTNER'),
(5,8,'EMAIL'),
(6,10,'EMAIL'),
(7,12,'EMAIL'),
(8,12,'PARTNER'),
(9,14,'EMAIL'),
(10,16,'EMAIL'),
(11,18,'EMAIL'),
(12,18,'PARTNER'),
(13,20,'EMAIL'),
(14,22,'EMAIL'),
(15,24,'EMAIL'),
(16,24,'PARTNER'),
(17,12,'EMAIL');

INSERT INTO order_events (event_id,order_id,event_type,event_ts) VALUES
(1,1,'created','2026-03-03 09:00:00'),
(2,1,'completed','2026-03-04 11:00:00'),
(3,2,'created','2026-03-05 09:00:00'),
(4,2,'completed','2026-03-06 11:00:00'),
(5,3,'created','2026-03-07 09:00:00'),
(6,4,'created','2026-03-09 09:00:00'),
(7,5,'created','2026-03-11 09:00:00'),
(8,5,'completed','2026-03-12 11:00:00'),
(9,6,'created','2026-03-13 09:00:00'),
(10,6,'completed','2026-03-14 11:00:00'),
(11,7,'created','2026-03-15 09:00:00'),
(12,7,'completed','2026-03-16 11:00:00'),
(13,8,'created','2026-03-17 09:00:00'),
(14,9,'created','2026-03-19 09:00:00'),
(15,10,'created','2026-03-21 09:00:00'),
(16,10,'completed','2026-03-22 11:00:00'),
(17,11,'created','2026-03-23 09:00:00'),
(18,11,'completed','2026-03-24 11:00:00'),
(19,12,'created','2026-03-25 09:00:00'),
(20,12,'completed','2026-03-26 11:00:00'),
(21,13,'created','2026-03-27 09:00:00'),
(22,14,'created','2026-03-29 09:00:00'),
(23,15,'created','2026-03-31 09:00:00'),
(24,15,'completed','2026-04-01 11:00:00'),
(25,16,'created','2026-04-02 09:00:00'),
(26,16,'completed','2026-04-03 11:00:00'),
(27,17,'created','2026-04-04 09:00:00'),
(28,17,'completed','2026-04-05 11:00:00'),
(29,18,'created','2026-04-06 09:00:00'),
(30,19,'created','2026-04-08 09:00:00'),
(31,20,'created','2026-03-01 09:00:00'),
(32,20,'completed','2026-03-02 11:00:00'),
(33,21,'created','2026-03-03 09:00:00'),
(34,21,'completed','2026-03-04 11:00:00'),
(35,22,'created','2026-03-05 09:00:00'),
(36,22,'completed','2026-03-06 11:00:00'),
(37,23,'created','2026-03-07 09:00:00'),
(38,24,'created','2026-03-09 09:00:00'),
(39,999,'completed','2026-03-25 11:00:00');


-- G1 CONTRACT + FAN-OUT
-- State grain of all five tables. Prove what happens to row count when orders joins order_items and when orders joins order_promotions.
-- Do not call duplication a defect until you explain the intended output grain.

-- G2 SAFE ORDER REVENUE
-- Produce exactly one row/order with item revenue. Include customer/region/status/shipping_fee without multiplying shipping_fee.
-- Independent check: reconcile total item revenue from raw item grain.

-- G3 CTE ARCHITECTURE
-- One row/region for Completed orders: completed_order_count, completed_item_revenue, shipping_fee_total, avg_completed_order_revenue.
-- Use named stages and validate at least one stage independently.

-- G4 WINDOWS / RANKING
-- One row/completed order with regional average order revenue and rank within region by order revenue.
-- Define tie behavior intentionally.

-- G5 LAG
-- One row/month with completed revenue, previous month revenue and change.
-- State what happens if a calendar month has no completed orders.

-- G6 CONDITIONAL AGGREGATION
-- One row/region: all orders, completed orders, cancelled orders, completed revenue, completion_rate.
-- Validate one region using a separate query.

-- G7 DATE/TIME
-- Count events in [2026-03-10 00:00, 2026-03-25 00:00). Save count/min/max.

-- G8 QUALITY
-- Detect orphan events and duplicate business promotion records on (order_id,channel).
-- Explain BLOCK vs WARN severity for each.

-- G9 DEBUG
-- Explain why this is unsafe for order-level shipping totals:
-- SELECT SUM(o.shipping_fee) FROM orders o JOIN order_promotions p ON p.order_id=o.order_id;
-- Write a corrected approach and a control that proves it.

-- G10 EXECUTION AWARENESS
-- EXPLAIN a selective Completed + order_date query. Propose a candidate index and explain what plan evidence you would inspect.
-- No unmeasured speed claim.

-- G11 HANDOFF / DEFENSE
-- 8 lines max: input grains, output grain, highest-risk join, two validations, one limitation, one index/plan observation, production handoff note.
