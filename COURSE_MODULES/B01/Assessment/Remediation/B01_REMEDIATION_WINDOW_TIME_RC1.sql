-- TARGETED REMEDIATION: deterministic windows/time
SET search_path TO c2b_b01_lab;
-- 1) Build one partitioned rank with a stable tie-break.
-- 2) Build one running aggregate with explicit ROWS frame.
-- 3) Build one LAG sequence and state missing-period behavior.
-- 4) Test a half-open timestamp interval with exact boundary rows.
-- 5) Changed retry on new partition/time window.
