-- C2B B01 GATE B - SUPPORT TICKETS - FRESH FULL RETEST ONLY - INTERNAL QA
-- DO NOT OPEN unless explicitly routed after Gate A repair.
DROP SCHEMA IF EXISTS c2b_b01_gate_b CASCADE;
CREATE SCHEMA c2b_b01_gate_b;
SET search_path TO c2b_b01_gate_b;

CREATE TABLE agents(agent_id int PRIMARY KEY, agent_name text NOT NULL, team text NOT NULL);
CREATE TABLE tickets(ticket_id int PRIMARY KEY, agent_id int NOT NULL REFERENCES agents(agent_id), created_date date NOT NULL, closed_date date, priority text NOT NULL, status text NOT NULL);
CREATE TABLE ticket_events(event_id int PRIMARY KEY, ticket_id int NOT NULL REFERENCES tickets(ticket_id), event_type text NOT NULL, event_ts timestamp NOT NULL);
CREATE TABLE ticket_tags(tag_id int PRIMARY KEY, ticket_id int NOT NULL REFERENCES tickets(ticket_id), tag text NOT NULL);
CREATE TABLE sla_targets(priority text PRIMARY KEY, target_days int NOT NULL);

INSERT INTO agents (agent_id,agent_name,team) VALUES
(1,'Agent 01','North'),
(2,'Agent 02','South'),
(3,'Agent 03','East'),
(4,'Agent 04','North'),
(5,'Agent 05','South'),
(6,'Agent 06','East'),
(7,'Agent 07','North');

INSERT INTO tickets (ticket_id,agent_id,created_date,closed_date,priority,status) VALUES
(1,6,'2026-04-03','2026-04-05','P2','Closed'),
(2,4,'2026-04-05',NULL,'P3','Open'),
(3,2,'2026-04-07','2026-04-11','P1','Closed'),
(4,7,'2026-04-09','2026-04-14','P2','Closed'),
(5,5,'2026-04-11','2026-04-17','P3','Closed'),
(6,3,'2026-04-13',NULL,'P1','Open'),
(7,1,'2026-04-15','2026-04-17','P2','Closed'),
(8,6,'2026-04-17','2026-04-20','P3','Closed'),
(9,4,'2026-04-19','2026-04-23','P1','Closed'),
(10,2,'2026-04-21',NULL,'P2','Open'),
(11,7,'2026-04-23','2026-04-29','P3','Closed'),
(12,5,'2026-04-25','2026-04-26','P1','Closed'),
(13,3,'2026-04-27','2026-04-29','P2','Closed'),
(14,1,'2026-04-29',NULL,'P3','Open'),
(15,6,'2026-05-01','2026-05-05','P1','Closed'),
(16,4,'2026-05-03','2026-05-08','P2','Closed'),
(17,2,'2026-05-05','2026-05-11','P3','Closed'),
(18,7,'2026-04-02',NULL,'P1','Open'),
(19,5,'2026-04-04','2026-04-06','P2','Closed'),
(20,3,'2026-04-06','2026-04-09','P3','Closed'),
(21,1,'2026-04-08','2026-04-12','P1','Closed'),
(22,6,'2026-04-10',NULL,'P2','Open'),
(23,4,'2026-04-12','2026-04-18','P3','Closed'),
(24,2,'2026-04-14','2026-04-15','P1','Closed'),
(25,7,'2026-04-16','2026-04-18','P2','Closed'),
(26,5,'2026-04-18',NULL,'P3','Open');

INSERT INTO ticket_events (event_id,ticket_id,event_type,event_ts) VALUES
(1,1,'created','2026-04-03 08:00:00'),
(2,1,'assigned','2026-04-03 09:00:00'),
(3,1,'closed','2026-04-05 17:00:00'),
(4,2,'created','2026-04-05 08:00:00'),
(5,2,'assigned','2026-04-05 09:00:00'),
(6,3,'created','2026-04-07 08:00:00'),
(7,3,'assigned','2026-04-07 09:00:00'),
(8,3,'closed','2026-04-11 17:00:00'),
(9,4,'created','2026-04-09 08:00:00'),
(10,4,'assigned','2026-04-09 09:00:00'),
(11,4,'closed','2026-04-14 17:00:00'),
(12,5,'created','2026-04-11 08:00:00'),
(13,5,'assigned','2026-04-11 09:00:00'),
(14,5,'closed','2026-04-17 17:00:00'),
(15,6,'created','2026-04-13 08:00:00'),
(16,6,'assigned','2026-04-13 09:00:00'),
(17,7,'created','2026-04-15 08:00:00'),
(18,7,'assigned','2026-04-15 09:00:00'),
(19,7,'closed','2026-04-17 17:00:00'),
(20,8,'created','2026-04-17 08:00:00'),
(21,8,'assigned','2026-04-17 09:00:00'),
(22,8,'closed','2026-04-20 17:00:00'),
(23,9,'created','2026-04-19 08:00:00'),
(24,9,'assigned','2026-04-19 09:00:00'),
(25,9,'closed','2026-04-23 17:00:00'),
(26,10,'created','2026-04-21 08:00:00'),
(27,10,'assigned','2026-04-21 09:00:00'),
(28,11,'created','2026-04-23 08:00:00'),
(29,11,'assigned','2026-04-23 09:00:00'),
(30,11,'closed','2026-04-29 17:00:00'),
(31,12,'created','2026-04-25 08:00:00'),
(32,12,'assigned','2026-04-25 09:00:00'),
(33,12,'closed','2026-04-26 17:00:00'),
(34,13,'created','2026-04-27 08:00:00'),
(35,13,'assigned','2026-04-27 09:00:00'),
(36,13,'closed','2026-04-29 17:00:00'),
(37,14,'created','2026-04-29 08:00:00'),
(38,14,'assigned','2026-04-29 09:00:00'),
(39,15,'created','2026-05-01 08:00:00'),
(40,15,'assigned','2026-05-01 09:00:00'),
(41,15,'closed','2026-05-05 17:00:00'),
(42,16,'created','2026-05-03 08:00:00'),
(43,16,'assigned','2026-05-03 09:00:00'),
(44,16,'closed','2026-05-08 17:00:00'),
(45,17,'created','2026-05-05 08:00:00'),
(46,17,'assigned','2026-05-05 09:00:00'),
(47,17,'closed','2026-05-11 17:00:00'),
(48,18,'created','2026-04-02 08:00:00'),
(49,18,'assigned','2026-04-02 09:00:00'),
(50,19,'created','2026-04-04 08:00:00'),
(51,19,'assigned','2026-04-04 09:00:00'),
(52,19,'closed','2026-04-06 17:00:00'),
(53,20,'created','2026-04-06 08:00:00'),
(54,20,'assigned','2026-04-06 09:00:00'),
(55,20,'closed','2026-04-09 17:00:00'),
(56,21,'created','2026-04-08 08:00:00'),
(57,21,'assigned','2026-04-08 09:00:00'),
(58,21,'closed','2026-04-12 17:00:00'),
(59,22,'created','2026-04-10 08:00:00'),
(60,22,'assigned','2026-04-10 09:00:00'),
(61,23,'created','2026-04-12 08:00:00'),
(62,23,'assigned','2026-04-12 09:00:00'),
(63,23,'closed','2026-04-18 17:00:00'),
(64,24,'created','2026-04-14 08:00:00'),
(65,24,'assigned','2026-04-14 09:00:00'),
(66,24,'closed','2026-04-15 17:00:00'),
(67,25,'created','2026-04-16 08:00:00'),
(68,25,'assigned','2026-04-16 09:00:00'),
(69,25,'closed','2026-04-18 17:00:00'),
(70,26,'created','2026-04-18 08:00:00'),
(71,26,'assigned','2026-04-18 09:00:00');

INSERT INTO ticket_tags (tag_id,ticket_id,tag) VALUES
(1,1,'access'),
(2,2,'performance'),
(3,3,'billing'),
(4,4,'access'),
(5,5,'performance'),
(6,5,'vip'),
(7,6,'billing'),
(8,7,'access'),
(9,8,'performance'),
(10,9,'billing'),
(11,10,'access'),
(12,10,'vip'),
(13,11,'performance'),
(14,12,'billing'),
(15,13,'access'),
(16,14,'performance'),
(17,15,'billing'),
(18,15,'vip'),
(19,16,'access'),
(20,17,'performance'),
(21,18,'billing'),
(22,19,'access'),
(23,20,'performance'),
(24,20,'vip'),
(25,21,'billing'),
(26,22,'access'),
(27,23,'performance'),
(28,24,'billing'),
(29,25,'access'),
(30,25,'vip'),
(31,26,'performance'),
(32,10,'vip');

INSERT INTO sla_targets (priority,target_days) VALUES
('P1',2),
('P2',4),
('P3',7);


-- G1: State grain and prove fan-out for tickets -> events and tickets -> tags.
-- G2: One row/closed ticket with resolution_days and SLA met flag; reconcile closed-ticket count.
-- G3: CTE architecture: one row/team with closed tickets, avg resolution days and SLA-met rate.
-- G4: Window: one row/closed ticket with team average + rank slowest within team.
-- G5: LAG: one row/week with closed-ticket count and change vs previous observed week; state missing-week limitation.
-- G6: Conditional aggregation: P1/P2/P3 closed counts, open count and SLA-met rate by team.
-- G7: Half-open event timestamp window; save count/min/max.
-- G8: Detect duplicate business tag rows on (ticket_id,tag). Explain why SELECT DISTINCT after joining tags is not a quality fix.
-- G9: Repair a naive SLA/team summary that multiplies tickets through tags; add an independent control.
-- G10: EXPLAIN a selective priority/status/date query; justify a candidate index without claiming measured speed.
-- G11: 8-line engineering handoff/defense: grains, highest-risk join, controls, limitation, plan evidence, production next step.
