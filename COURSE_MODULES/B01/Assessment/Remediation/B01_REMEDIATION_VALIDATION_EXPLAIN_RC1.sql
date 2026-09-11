-- TARGETED REMEDIATION: validation/EXPLAIN/handoff
SET search_path TO c2b_b01_lab;
-- 1) Restore one wrong-but-plausible query.
-- 2) Design an independent control that FAILS on it.
-- 3) Repair the first failing contract and prove PASS.
-- 4) EXPLAIN a selective query; record plan facts only.
-- 5) Add purpose/grain/assumptions/validation/limitation/owner handoff notes.
