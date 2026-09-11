-- C2B B01 GATE C - SUBSCRIPTION BILLING - SECOND FRESH FULL RETEST ONLY - INTERNAL QA
-- DO NOT OPEN unless explicitly routed after Gate B instability/repair.
DROP SCHEMA IF EXISTS c2b_b01_gate_c CASCADE;
CREATE SCHEMA c2b_b01_gate_c;
SET search_path TO c2b_b01_gate_c;

CREATE TABLE accounts(account_id int PRIMARY KEY, account_name text NOT NULL, segment text NOT NULL);
CREATE TABLE invoices(invoice_id int PRIMARY KEY, account_id int NOT NULL REFERENCES accounts(account_id), invoice_date date NOT NULL, status text NOT NULL);
CREATE TABLE invoice_lines(line_id int PRIMARY KEY, invoice_id int NOT NULL REFERENCES invoices(invoice_id), plan_code text NOT NULL, amount numeric(10,2) NOT NULL);
CREATE TABLE invoice_adjustments(adjustment_id int PRIMARY KEY, invoice_id int NOT NULL REFERENCES invoices(invoice_id), adjustment_type text NOT NULL, amount numeric(10,2) NOT NULL);
CREATE TABLE payments(payment_id int PRIMARY KEY, invoice_id int NOT NULL, payment_date date NOT NULL, amount numeric(10,2) NOT NULL);

INSERT INTO accounts (account_id,account_name,segment) VALUES
(1,'Account 01','SMB'),
(2,'Account 02','Mid'),
(3,'Account 03','Enterprise'),
(4,'Account 04','SMB'),
(5,'Account 05','Mid'),
(6,'Account 06','Enterprise'),
(7,'Account 07','SMB'),
(8,'Account 08','Mid'),
(9,'Account 09','Enterprise');

INSERT INTO invoices (invoice_id,account_id,invoice_date,status) VALUES
(1,5,'2026-05-04','Paid'),
(2,9,'2026-05-07','Open'),
(3,4,'2026-05-10','Paid'),
(4,8,'2026-05-13','Void'),
(5,3,'2026-05-16','Paid'),
(6,7,'2026-05-19','Paid'),
(7,2,'2026-05-22','Open'),
(8,6,'2026-05-25','Paid'),
(9,1,'2026-05-28','Void'),
(10,5,'2026-05-31','Paid'),
(11,9,'2026-06-03','Paid'),
(12,4,'2026-06-06','Open'),
(13,8,'2026-06-09','Paid'),
(14,3,'2026-06-12','Void'),
(15,7,'2026-06-15','Paid'),
(16,2,'2026-06-18','Paid'),
(17,6,'2026-05-02','Open'),
(18,1,'2026-05-05','Paid'),
(19,5,'2026-05-08','Void'),
(20,9,'2026-05-11','Paid'),
(21,4,'2026-05-14','Paid'),
(22,8,'2026-05-17','Open'),
(23,3,'2026-05-20','Paid'),
(24,7,'2026-05-23','Void');

INSERT INTO invoice_lines (line_id,invoice_id,plan_code,amount) VALUES
(1,1,'PLAN2',900),
(2,1,'PLAN3',1300),
(3,2,'PLAN3',1300),
(4,2,'PLAN4',1800),
(5,2,'PLAN1',2400),
(6,3,'PLAN4',1800),
(7,4,'PLAN1',2400),
(8,4,'PLAN2',600),
(9,5,'PLAN2',600),
(10,5,'PLAN3',900),
(11,5,'PLAN4',1300),
(12,6,'PLAN3',900),
(13,7,'PLAN4',1300),
(14,7,'PLAN1',1800),
(15,8,'PLAN1',1800),
(16,8,'PLAN2',2400),
(17,8,'PLAN3',600),
(18,9,'PLAN2',2400),
(19,10,'PLAN3',600),
(20,10,'PLAN4',900),
(21,11,'PLAN4',900),
(22,11,'PLAN1',1300),
(23,11,'PLAN2',1800),
(24,12,'PLAN1',1300),
(25,13,'PLAN2',1800),
(26,13,'PLAN3',2400),
(27,14,'PLAN3',2400),
(28,14,'PLAN4',600),
(29,14,'PLAN1',900),
(30,15,'PLAN4',600),
(31,16,'PLAN1',900),
(32,16,'PLAN2',1300),
(33,17,'PLAN2',1300),
(34,17,'PLAN3',1800),
(35,17,'PLAN4',2400),
(36,18,'PLAN3',1800),
(37,19,'PLAN4',2400),
(38,19,'PLAN1',600),
(39,20,'PLAN1',600),
(40,20,'PLAN2',900),
(41,20,'PLAN3',1300),
(42,21,'PLAN2',900),
(43,22,'PLAN3',1300),
(44,22,'PLAN4',1800),
(45,23,'PLAN4',1800),
(46,23,'PLAN1',2400),
(47,23,'PLAN2',600),
(48,24,'PLAN1',2400);

INSERT INTO invoice_adjustments (adjustment_id,invoice_id,adjustment_type,amount) VALUES
(1,3,'credit',-100),
(2,6,'credit',-100),
(3,6,'manual_review',0),
(4,9,'credit',-100),
(5,12,'credit',-100),
(6,12,'manual_review',0),
(7,15,'credit',-100),
(8,18,'credit',-100),
(9,18,'manual_review',0),
(10,21,'credit',-100),
(11,24,'credit',-100),
(12,24,'manual_review',0),
(13,12,'manual_review',0);

INSERT INTO payments (payment_id,invoice_id,payment_date,amount) VALUES
(1,1,'2026-05-05',2200),
(2,3,'2026-05-13',1800),
(3,5,'2026-05-21',2800),
(4,6,'2026-05-25',900),
(5,8,'2026-05-25',4800),
(6,10,'2026-06-02',1500),
(7,11,'2026-06-06',4000),
(8,13,'2026-06-14',4200),
(9,15,'2026-06-22',600),
(10,16,'2026-06-18',2200),
(11,18,'2026-05-07',1800),
(12,20,'2026-05-15',2800),
(13,21,'2026-05-19',900),
(14,23,'2026-05-27',4800),
(15,999,'2026-06-10',500);


-- G1: State grain and prove fan-out for invoices -> lines and invoices -> adjustments.
-- G2: One row/invoice with gross invoice value; preserve invoice grain and reconcile to raw lines.
-- G3: CTE architecture: one row/segment for Paid invoices, paid invoice value, payment received and collection gap.
-- G4: Window: one row/Paid invoice with segment average invoice value and rank within segment.
-- G5: LAG: one row/month with Paid invoice value and month-over-month change.
-- G6: Conditional aggregation: Paid/Open/Void invoice counts and Paid value by segment; denominator explicit.
-- G7: Date boundary: payments in [2026-05-20, 2026-06-10); save count/min/max.
-- G8: Detect orphan payments and duplicate business adjustments on (invoice_id, adjustment_type, amount).
-- G9: Repair unsafe joining of lines + adjustments before invoice aggregation; prove corrected totals.
-- G10: EXPLAIN a selective account/status/date query; justify candidate index, no unmeasured speed claim.
-- G11: 8-line engineering handoff/defense.
