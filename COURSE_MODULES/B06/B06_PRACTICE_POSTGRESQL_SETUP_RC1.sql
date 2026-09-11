-- B06 PRACTICE POSTGRESQL SETUP - HOME SERVICES NETWORK
-- Use only when PostgreSQL is available. This file creates a dedicated schema boundary; the learner loads supplied CSVs using their local safe import method.
CREATE SCHEMA IF NOT EXISTS c2b_b06_capstone;
SET search_path TO c2b_b06_capstone;

-- Before loading, write the grain and business key of each source in the evidence workbook.
-- Do not invent one giant flat schema. Create tables that preserve source grains.
