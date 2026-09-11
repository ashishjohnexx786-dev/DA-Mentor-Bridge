-- B06 PRACTICE SQL WORKSPACE - HOME SERVICES NETWORK
SET search_path TO c2b_b06_capstone;

-- SQL-1 SOURCE CONTRACT / FAN-OUT PROOF
-- State grain of orders, items, events, technician changes, targets and skills.
-- Demonstrate one wrong-but-plausible join that multiplies an order-level measure; save the failed control, then correct it.
-- YOUR SQL:

-- SQL-2 ORDER-LEVEL ECONOMICS
-- Return one row per service order with item_value, base_fee, total_value, customer, technician, region and status.
-- Independently reconcile item_value to service_items.

-- SQL-3 WINDOWS / TIME
-- For completed orders: region average total_value beside each order; technician revenue rank within region; monthly completed revenue + LAG previous month/change.

-- SQL-4 QUALITY INVESTIGATION
-- Detect orphan service_events, duplicate technician/effective-date changes, duplicate technician-skill memberships, and invalid quantity/unit_price/base_fee rules.

-- SQL-5 HISTORY / MODEL HANDOFF
-- Document business key + surrogate/version key reasoning and the effective-date lookup needed for historical technician region.
-- Do not use current region to rewrite history without an explicit business decision.

-- SQL-6 MAINTAINABLE HANDOFF
-- Refactor final region-month analysis into named CTEs. Add deterministic ordering, grain comments and a separate reconciliation query.

-- SQL-7 EXECUTION AWARENESS
-- EXPLAIN one selective order-date/technician/status query. Propose one candidate index and state which observed plan evidence would justify/deny it.
