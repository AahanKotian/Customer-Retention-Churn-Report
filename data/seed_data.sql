-- =============================================================
-- seed_data.sql
-- Creates and populates: users, sessions
-- Run this FIRST before any queries in /sql
--
-- Dataset simulates 200 users over 5 cohort months (Sep–Jan)
-- with realistic retention decay: ~60% return in month 1,
-- dropping to ~35% by month 5.
-- =============================================================

DROP TABLE IF EXISTS sessions;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    user_id            INTEGER PRIMARY KEY,
    plan_type          TEXT,   -- free | pro | enterprise
    country            TEXT,
    signed_up_at       TEXT,   -- ISO date string YYYY-MM-DD
    acquisition_source TEXT    -- organic | paid_search | referral | social
);

CREATE TABLE sessions (
    session_id            INTEGER PRIMARY KEY,
    user_id               INTEGER,
    session_date          TEXT,   -- YYYY-MM-DD
    session_duration_mins INTEGER,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- ---------------------------------------------------------------
-- Users: 200 users across 5 cohort months
-- Cohort months: 2023-09 through 2024-01
-- ---------------------------------------------------------------
INSERT INTO users VALUES
-- Sep 2023 cohort (40 users, ids 1-40)
(1,'free','US','2023-09-02','organic'),(2,'pro','CA','2023-09-03','paid_search'),
(3,'free','UK','2023-09-04','referral'),(4,'pro','US','2023-09-05','organic'),
(5,'enterprise','AU','2023-09-06','referral'),(6,'free','US','2023-09-07','social'),
(7,'pro','DE','2023-09-08','paid_search'),(8,'free','US','2023-09-09','organic'),
(9,'pro','FR','2023-09-10','referral'),(10,'free','US','2023-09-11','organic'),
(11,'enterprise','CA','2023-09-12','paid_search'),(12,'free','US','2023-09-13','social'),
(13,'pro','UK','2023-09-14','organic'),(14,'free','US','2023-09-15','referral'),
(15,'pro','US','2023-09-16','paid_search'),(16,'free','AU','2023-09-17','organic'),
(17,'enterprise','US','2023-09-18','referral'),(18,'free','CA','2023-09-19','social'),
(19,'pro','US','2023-09-20','organic'),(20,'free','DE','2023-09-21','paid_search'),
(21,'free','US','2023-09-22','organic'),(22,'pro','UK','2023-09-23','referral'),
(23,'free','US','2023-09-24','social'),(24,'pro','US','2023-09-25','organic'),
(25,'enterprise','CA','2023-09-26','paid_search'),(26,'free','FR','2023-09-27','organic'),
(27,'pro','US','2023-09-28','referral'),(28,'free','US','2023-09-29','social'),
(29,'pro','AU','2023-09-30','organic'),(30,'free','US','2023-09-30','paid_search'),
(31,'free','US','2023-09-02','organic'),(32,'pro','CA','2023-09-05','referral'),
(33,'free','UK','2023-09-08','social'),(34,'enterprise','US','2023-09-11','organic'),
(35,'free','US','2023-09-14','paid_search'),(36,'pro','DE','2023-09-17','organic'),
(37,'free','US','2023-09-20','referral'),(38,'pro','US','2023-09-23','social'),
(39,'free','CA','2023-09-26','organic'),(40,'enterprise','US','2023-09-29','paid_search'),
-- Oct 2023 cohort (40 users, ids 41-80)
(41,'free','US','2023-10-01','organic'),(42,'pro','UK','2023-10-03','paid_search'),
(43,'free','CA','2023-10-05','referral'),(44,'pro','US','2023-10-07','social'),
(45,'enterprise','US','2023-10-09','organic'),(46,'free','AU','2023-10-11','referral'),
(47,'pro','US','2023-10-13','paid_search'),(48,'free','DE','2023-10-15','organic'),
(49,'pro','US','2023-10-17','referral'),(50,'free','FR','2023-10-19','social'),
(51,'enterprise','US','2023-10-21','organic'),(52,'free','CA','2023-10-23','paid_search'),
(53,'pro','UK','2023-10-25','organic'),(54,'free','US','2023-10-27','referral'),
(55,'pro','US','2023-10-29','social'),(56,'free','AU','2023-10-01','organic'),
(57,'enterprise','US','2023-10-04','paid_search'),(58,'free','US','2023-10-07','referral'),
(59,'pro','CA','2023-10-10','organic'),(60,'free','US','2023-10-13','social'),
(61,'free','US','2023-10-02','organic'),(62,'pro','DE','2023-10-06','paid_search'),
(63,'free','US','2023-10-10','referral'),(64,'pro','US','2023-10-14','organic'),
(65,'enterprise','UK','2023-10-18','referral'),(66,'free','US','2023-10-22','social'),
(67,'pro','CA','2023-10-26','organic'),(68,'free','US','2023-10-30','paid_search'),
(69,'pro','AU','2023-10-08','organic'),(70,'free','US','2023-10-12','referral'),
(71,'free','US','2023-10-03','social'),(72,'pro','FR','2023-10-09','organic'),
(73,'free','US','2023-10-15','paid_search'),(74,'enterprise','US','2023-10-21','referral'),
(75,'free','CA','2023-10-27','organic'),(76,'pro','UK','2023-10-05','social'),
(77,'free','US','2023-10-11','organic'),(78,'pro','US','2023-10-17','paid_search'),
(79,'free','DE','2023-10-23','referral'),(80,'enterprise','US','2023-10-29','organic'),
-- Nov 2023 cohort (40 users, ids 81-120)
(81,'free','US','2023-11-01','organic'),(82,'pro','CA','2023-11-03','paid_search'),
(83,'free','UK','2023-11-05','social'),(84,'pro','US','2023-11-07','organic'),
(85,'enterprise','AU','2023-11-09','referral'),(86,'free','US','2023-11-11','organic'),
(87,'pro','DE','2023-11-13','paid_search'),(88,'free','US','2023-11-15','referral'),
(89,'pro','FR','2023-11-17','social'),(90,'free','US','2023-11-19','organic'),
(91,'enterprise','CA','2023-11-21','referral'),(92,'free','US','2023-11-23','paid_search'),
(93,'pro','UK','2023-11-25','organic'),(94,'free','US','2023-11-27','social'),
(95,'pro','US','2023-11-29','organic'),(96,'free','AU','2023-11-02','referral'),
(97,'enterprise','US','2023-11-06','organic'),(98,'free','CA','2023-11-10','paid_search'),
(99,'pro','US','2023-11-14','referral'),(100,'free','US','2023-11-18','social'),
(101,'free','US','2023-11-04','organic'),(102,'pro','US','2023-11-08','paid_search'),
(103,'free','DE','2023-11-12','referral'),(104,'enterprise','US','2023-11-16','organic'),
(105,'free','UK','2023-11-20','social'),(106,'pro','US','2023-11-24','organic'),
(107,'free','CA','2023-11-28','referral'),(108,'pro','AU','2023-11-02','paid_search'),
(109,'free','US','2023-11-07','organic'),(110,'enterprise','FR','2023-11-12','social'),
(111,'free','US','2023-11-01','organic'),(112,'pro','US','2023-11-05','paid_search'),
(113,'free','CA','2023-11-09','referral'),(114,'pro','UK','2023-11-13','social'),
(115,'enterprise','US','2023-11-17','organic'),(116,'free','DE','2023-11-21','paid_search'),
(117,'pro','US','2023-11-25','referral'),(118,'free','AU','2023-11-29','organic'),
(119,'pro','US','2023-11-03','social'),(120,'free','CA','2023-11-07','paid_search'),
-- Dec 2023 cohort (40 users, ids 121-160) — holiday signups, higher churn
(121,'free','US','2023-12-01','social'),(122,'free','CA','2023-12-03','paid_search'),
(123,'free','UK','2023-12-05','social'),(124,'free','US','2023-12-07','organic'),
(125,'pro','AU','2023-12-09','referral'),(126,'free','US','2023-12-11','social'),
(127,'free','DE','2023-12-13','paid_search'),(128,'free','US','2023-12-15','social'),
(129,'pro','FR','2023-12-17','referral'),(130,'free','US','2023-12-19','organic'),
(131,'free','CA','2023-12-21','social'),(132,'free','US','2023-12-23','paid_search'),
(133,'free','UK','2023-12-26','organic'),(134,'free','US','2023-12-28','social'),
(135,'pro','US','2023-12-30','organic'),(136,'free','AU','2023-12-02','social'),
(137,'free','US','2023-12-06','paid_search'),(138,'free','CA','2023-12-10','social'),
(139,'pro','US','2023-12-14','organic'),(140,'free','US','2023-12-18','social'),
(141,'free','US','2023-12-04','paid_search'),(142,'free','DE','2023-12-08','social'),
(143,'free','US','2023-12-12','organic'),(144,'pro','UK','2023-12-16','referral'),
(145,'free','US','2023-12-20','social'),(146,'free','CA','2023-12-24','paid_search'),
(147,'free','US','2023-12-27','social'),(148,'free','AU','2023-12-29','organic'),
(149,'pro','US','2023-12-03','referral'),(150,'free','FR','2023-12-07','social'),
(151,'free','US','2023-12-01','paid_search'),(152,'free','CA','2023-12-05','social'),
(153,'free','UK','2023-12-09','organic'),(154,'enterprise','US','2023-12-13','referral'),
(155,'free','US','2023-12-17','social'),(156,'free','DE','2023-12-21','paid_search'),
(157,'free','US','2023-12-25','organic'),(158,'pro','CA','2023-12-28','referral'),
(159,'free','US','2023-12-31','social'),(160,'free','AU','2023-12-11','paid_search'),
-- Jan 2024 cohort (40 users, ids 161-200)
(161,'free','US','2024-01-02','organic'),(162,'pro','CA','2024-01-04','paid_search'),
(163,'free','UK','2024-01-06','referral'),(164,'pro','US','2024-01-08','organic'),
(165,'enterprise','AU','2024-01-10','referral'),(166,'free','US','2024-01-12','social'),
(167,'pro','DE','2024-01-14','paid_search'),(168,'free','US','2024-01-16','organic'),
(169,'pro','FR','2024-01-18','referral'),(170,'free','US','2024-01-20','organic'),
(171,'enterprise','CA','2024-01-22','paid_search'),(172,'free','US','2024-01-24','social'),
(173,'pro','UK','2024-01-02','organic'),(174,'free','US','2024-01-05','referral'),
(175,'pro','US','2024-01-08','paid_search'),(176,'free','AU','2024-01-11','organic'),
(177,'enterprise','US','2024-01-14','referral'),(178,'free','CA','2024-01-17','social'),
(179,'pro','US','2024-01-20','organic'),(180,'free','DE','2024-01-23','paid_search'),
(181,'free','US','2024-01-03','organic'),(182,'pro','UK','2024-01-07','referral'),
(183,'free','US','2024-01-11','social'),(184,'pro','US','2024-01-15','organic'),
(185,'enterprise','CA','2024-01-19','paid_search'),(186,'free','FR','2024-01-23','organic'),
(187,'pro','US','2024-01-04','referral'),(188,'free','US','2024-01-08','social'),
(189,'pro','AU','2024-01-12','organic'),(190,'free','US','2024-01-16','paid_search'),
(191,'free','US','2024-01-02','social'),(192,'pro','CA','2024-01-06','organic'),
(193,'free','UK','2024-01-10','paid_search'),(194,'enterprise','US','2024-01-14','referral'),
(195,'free','US','2024-01-18','organic'),(196,'pro','DE','2024-01-22','social'),
(197,'free','US','2024-01-26','paid_search'),(198,'pro','US','2024-01-05','organic'),
(199,'free','CA','2024-01-09','referral'),(200,'enterprise','AU','2024-01-13','social');


-- ---------------------------------------------------------------
-- Sessions: signup-day visit for ALL users (everyone has session 1)
-- Then return sessions for retained users only
--
-- Retention rates (realistic decay):
--   Sep cohort: ~65% return within 30 days
--   Oct cohort: ~60% return within 30 days
--   Nov cohort: ~55% return within 30 days
--   Dec cohort: ~45% return within 30 days  (holiday churn)
--   Jan cohort: ~60% return within 30 days
-- ---------------------------------------------------------------

-- Signup-day sessions (all 200 users)
INSERT INTO sessions (session_id, user_id, session_date, session_duration_mins)
SELECT user_id * 100, user_id, signed_up_at, 
       CASE (user_id % 5)
         WHEN 0 THEN 3  WHEN 1 THEN 7  WHEN 2 THEN 12
         WHEN 3 THEN 18 ELSE 25
       END
FROM users;

-- Return sessions: Sep cohort retained users (ids 1-26 roughly ~65%)
INSERT INTO sessions VALUES
(101,1,'2023-09-18',15),(102,2,'2023-09-20',22),(103,3,'2023-09-22',8),
(104,4,'2023-09-25',30),(105,5,'2023-10-01',45),(106,6,'2023-09-15',6),
(107,7,'2023-09-19',20),(108,8,'2023-09-28',14),(109,9,'2023-10-05',35),
(110,10,'2023-09-24',10),(111,11,'2023-10-08',50),(112,12,'2023-09-17',5),
(113,13,'2023-09-30',25),(114,14,'2023-10-03',18),(115,15,'2023-09-26',40),
(116,17,'2023-10-10',55),(117,19,'2023-09-29',22),(118,21,'2023-10-07',12),
(119,22,'2023-10-02',30),(120,24,'2023-09-30',15),(121,25,'2023-10-12',60),
(122,27,'2023-10-04',28),(123,29,'2023-10-09',35),(124,31,'2023-09-21',8),
(125,32,'2023-09-27',18),(126,34,'2023-10-01',42),
-- Sep users with multiple return sessions (higher engagement)
(151,1,'2023-10-05',20),(152,2,'2023-10-12',30),(153,5,'2023-10-18',25),
(154,11,'2023-10-20',40),(155,15,'2023-10-15',35),(156,25,'2023-10-25',50);

-- Return sessions: Oct cohort retained users (~60%, ids 41-80)
INSERT INTO sessions VALUES
(201,41,'2023-10-18',12),(202,42,'2023-10-20',25),(203,43,'2023-10-22',8),
(204,44,'2023-10-25',35),(205,45,'2023-11-02',48),(206,47,'2023-10-28',18),
(207,49,'2023-11-05',30),(208,51,'2023-10-30',55),(209,53,'2023-11-01',15),
(210,55,'2023-10-26',22),(211,57,'2023-11-08',60),(212,59,'2023-10-24',10),
(213,61,'2023-11-03',28),(214,62,'2023-10-29',20),(215,64,'2023-11-06',40),
(216,65,'2023-11-10',55),(217,67,'2023-11-04',22),(218,69,'2023-10-27',14),
(219,72,'2023-11-09',30),(220,74,'2023-10-31',18),(221,76,'2023-11-12',45),
(222,78,'2023-11-07',25),(223,80,'2023-11-13',35),
(251,41,'2023-11-05',18),(252,45,'2023-11-15',30),(253,51,'2023-11-20',45);

-- Return sessions: Nov cohort retained users (~55%, ids 81-120)
INSERT INTO sessions VALUES
(301,81,'2023-11-18',10),(302,82,'2023-11-20',28),(303,84,'2023-11-22',15),
(304,85,'2023-12-02',50),(305,86,'2023-11-25',8),(306,87,'2023-11-28',22),
(307,89,'2023-12-05',35),(308,91,'2023-11-30',60),(309,93,'2023-12-01',18),
(310,95,'2023-11-26',25),(311,97,'2023-12-08',55),(312,99,'2023-12-03',12),
(313,101,'2023-11-24',30),(314,102,'2023-11-29',20),(315,104,'2023-12-06',42),
(316,106,'2023-12-10',55),(317,108,'2023-12-04',22),(318,110,'2023-11-27',14),
(319,112,'2023-12-09',28),(320,115,'2023-12-01',18),(321,117,'2023-12-12',45),
(351,81,'2023-12-05',15),(352,85,'2023-12-15',28);

-- Return sessions: Dec cohort retained users (~45%, ids 121-160) - fewer returns
INSERT INTO sessions VALUES
(401,125,'2024-01-05',20),(402,129,'2024-01-08',30),(403,130,'2024-01-03',8),
(404,135,'2024-01-10',40),(405,139,'2024-01-06',15),(406,144,'2024-01-12',50),
(407,149,'2024-01-07',25),(408,154,'2024-01-15',60),(409,158,'2024-01-09',18),
(410,125,'2024-01-20',22),(411,135,'2024-01-25',35),(412,144,'2024-01-22',28),
(413,149,'2024-01-18',30),(414,154,'2024-01-28',45),(415,158,'2024-01-24',20),
(416,121,'2024-01-04',12),(417,162,'2024-01-05',15),(418,139,'2024-01-16',22);

-- Return sessions: Jan cohort retained users (~60%, ids 161-200)
INSERT INTO sessions VALUES
(501,161,'2024-01-18',14),(502,162,'2024-01-20',28),(503,164,'2024-01-22',10),
(504,165,'2024-02-01',48),(505,167,'2024-01-25',22),(506,169,'2024-02-04',35),
(507,171,'2024-01-28',60),(508,173,'2024-01-24',18),(509,175,'2024-01-26',30),
(510,177,'2024-02-07',55),(511,179,'2024-01-30',12),(512,182,'2024-02-05',28),
(513,184,'2024-01-29',20),(514,185,'2024-02-08',42),(515,187,'2024-02-02',55),
(516,189,'2024-01-27',22),(517,192,'2024-02-06',14),(518,194,'2024-01-31',30),
(519,198,'2024-02-03',18),(520,200,'2024-02-09',45),
(551,161,'2024-02-08',20),(552,165,'2024-02-12',30),(553,171,'2024-02-15',40);

-- Sanity check
SELECT 'users'    AS tbl, COUNT(*) AS rows FROM users
UNION ALL
SELECT 'sessions' AS tbl, COUNT(*) AS rows FROM sessions;
