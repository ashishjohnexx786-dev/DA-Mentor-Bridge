-- TARGETED REMEDIATION: grain/cardinality
SET search_path TO c2b_b01_lab;
-- 1) State grain of orders and order_items.
-- 2) Predict rows after join.
-- 3) Build one row/order without multiplying shipping_fee.
-- 4) Prove uniqueness + raw item revenue + order-only shipping controls.
-- 5) Changed retry: use a different one-to-many source.
-- Do not open a fresh full Gate unless explicitly assigned.
