-- C2B B01 ENGINEERING SQL TRANSITION - PRACTICE RC1 - INTERNAL QA
-- Run B01_POSTGRESQL_LAB_SETUP_RC1.sql first.
-- RULE: save a genuine attempt before opening the protected review.
-- For every task: FOLLOW -> REPRODUCE -> CHANGE -> DEBUG -> VALIDATE -> EXPLAIN.
SET search_path TO c2b_b01_lab;


-- ================================================================
-- P-B01-L01 | Grain and cardinality contracts
-- BEFORE SQL: write grain of orders, order_items, customer_region_history and desired output.
-- FOLLOW: compare orders row count vs orders JOIN order_items.
-- REPRODUCE: aggregate item revenue to one row/order, then attach order-level fields.
-- CHANGE: add a second one-to-many source and predict fan-out before running.
-- DEBUG: intentionally make shipping_fee multiply, then catch it.
-- VALIDATE: order_id uniqueness + raw item revenue reconciliation + order-only shipping control.
-- EXPLAIN: 45-60 sec grain -> cardinality -> failure -> control.
-- YOUR ATTEMPT:

-- INDEPENDENT CONTROLS:

-- FAILURE / RECOVERY NOTE:


-- ================================================================
-- P-B01-L02 | Staged transformations with CTEs and subqueries
-- Build: base_completed_items -> order_level -> benchmark -> regional_summary.
-- Requirement: identify completed orders above average completed-order revenue and summarize by region.
-- Each stage must have a written purpose + grain. Run at least two stages independently.
-- CHANGE: alter the date/status condition and predict which stages should change.
-- DEBUG: create one wrong stage grain and locate the first invariant that fails.
-- VALIDATE: order uniqueness + raw revenue + one region total.
-- YOUR ATTEMPT:

-- STAGE CHECKS:

-- FAILURE / RECOVERY NOTE:


-- ================================================================
-- P-B01-L03 | Window patterns
-- Part A: one row/completed order with regional average revenue and deterministic rank.
-- Part B: daily running completed revenue using an explicit ROWS frame.
-- Part C: one row/month completed revenue + LAG previous observed month.
-- CHANGE: create/identify a tie and add a stable tie-break.
-- DEBUG: remove the tie-break or frame and explain what becomes ambiguous.
-- VALIDATE: pre/post-window row count; manual rank check; monthly reconciliation.
-- STATE: what does LAG mean if a calendar month is missing?
-- YOUR ATTEMPT:

-- CONTROLS / TIE TEST:


-- ================================================================
-- P-B01-L04 | Conditional + date transformation rules
-- Write business rules in English before SQL.
-- Part A: one row/region with all/completed/cancelled orders, completed revenue, completion_rate.
-- Part B: events in [2026-01-15 00:00, 2026-02-01 00:00); save count/min/max.
-- Part C: one row/month of completed revenue using PostgreSQL date_trunc.
-- CHANGE: use a different status rule and date window.
-- DEBUG: test an inclusive upper boundary and show why adjacent windows can overlap.
-- VALIDATE: single-region denominator control + boundary evidence + monthly reconciliation.
-- YOUR ATTEMPT:

-- WRITTEN RULES / CONTROLS:


-- ================================================================
-- P-B01-L05 | Data-quality investigation queries
-- Rule 1: duplicate business event on (order_id,event_type,event_ts).
-- Rule 2: orphan order_event.
-- Rule 3: invalid qty/unit_price/discount range.
-- Rule 4: customer with >1 active/open-ended region-history row.
-- For each: RULE -> SQL -> VIOLATION COUNT -> SAMPLE -> BLOCK/WARN -> WHY -> OWNER/NEXT ACTION.
-- CHANGE: define one fresh quality rule on a changed key/threshold.
-- DEBUG: show why SELECT DISTINCT is not a root-cause repair.
-- VALIDATE: known bad row is caught; known good row is not.
-- YOUR ATTEMPT:


-- ================================================================
-- P-B01-L06 | Reconciliation and validation SQL
-- Repair three deliberately broken baseline queries below.
-- For each: symptom -> first failing stage -> repair -> independent control that catches original defect.
-- Add a completed-revenue source-to-output reconciliation using a different logical path.
-- CHANGE: construct one fresh plausible-but-wrong fan-out/filter defect.
-- DEBUG: prove your control fails on bad logic and passes on repaired logic.
-- YOUR ATTEMPT:

-- BROKEN A - syntax
-- SELECT region, COUNT(*) FROM orders WHERE status='Completed' GROUP region;

-- BROKEN B - wrong filter stage
-- SELECT booked_region, SUM(shipping_fee) AS fee
-- FROM orders WHERE SUM(shipping_fee) > 500 GROUP BY booked_region;

-- BROKEN C - fan-out
-- SELECT o.booked_region, SUM(o.shipping_fee)
-- FROM orders o JOIN customer_region_history h ON h.customer_id=o.customer_id
-- GROUP BY o.booked_region;


-- ================================================================
-- P-B01-L07 | EXPLAIN, scans and index awareness
-- EXPLAIN a selective Completed + customer_id + order_date query.
-- Record: scan node, filter/index condition, estimated rows, and any join node.
-- Propose ONE candidate composite index based on the query shape; create it; EXPLAIN again.
-- CHANGE: use a different customer/date selectivity and compare the plan.
-- DEBUG: write one false claim you must avoid (for example, 'Seq Scan is always bad').
-- VALIDATE: query result is unchanged; no speed claim unless runtime was actually measured.
-- YOUR ATTEMPT / PLAN NOTES:


-- ================================================================
-- P-B01-L08 | Maintainable deterministic SQL handoff
-- PURPOSE: completed revenue by region-month.
-- Required header before SQL: source grains, output grain, assumptions, owner/next step.
-- Use named stages and explicit columns.
-- Final output: region, month, completed_orders, completed_revenue.
-- Add deterministic ORDER BY and a separate reconciliation query.
-- Add: highest-risk join, one quality limitation, one recovery note.
-- CHANGE: close review and build a customer-segment/month variant.
-- VALIDATE: final revenue ties to trusted control; stage grains are documented.
-- YOUR ATTEMPT:

