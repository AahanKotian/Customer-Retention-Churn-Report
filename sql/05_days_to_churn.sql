-- =============================================================
-- 05_days_to_churn.sql
-- How fast do churned users leave? And how engaged are retained
-- users in their first session?
--
-- Concepts: NULL handling with COALESCE/NULLIF, AVG/MIN/MAX,
--           date math, bucketing with CASE WHEN
-- =============================================================

-- ---------------------------------------------------------------
-- Query 1: For retained users — how long before they returned?
-- Shows whether quick returners stick around differently
-- ---------------------------------------------------------------
WITH return_timing AS (
    SELECT
        u.user_id,
        u.plan_type,
        ROUND(
            JULIANDAY(MIN(s.session_date)) - JULIANDAY(u.signed_up_at),
            0
        ) AS days_to_return
    FROM users u
    JOIN sessions s
        ON  s.user_id      = u.user_id
        AND s.session_date > u.signed_up_at
    GROUP BY u.user_id, u.plan_type, u.signed_up_at
)

SELECT
    plan_type,
    COUNT(*)                             AS retained_users,
    ROUND(AVG(days_to_return), 1)        AS avg_days_to_return,
    MIN(days_to_return)                  AS fastest_return_days,
    MAX(days_to_return)                  AS slowest_return_days
FROM return_timing
GROUP BY plan_type
ORDER BY avg_days_to_return;


-- ---------------------------------------------------------------
-- Query 2: Bucket retained users by how fast they returned
-- Quick returners are usually your most engaged users
-- ---------------------------------------------------------------
WITH return_timing AS (
    SELECT
        u.user_id,
        ROUND(
            JULIANDAY(MIN(s.session_date)) - JULIANDAY(u.signed_up_at),
            0
        ) AS days_to_return
    FROM users u
    JOIN sessions s
        ON  s.user_id = u.user_id
        AND s.session_date > u.signed_up_at
    GROUP BY u.user_id, u.signed_up_at
)

SELECT
    CASE
        WHEN days_to_return <= 3   THEN '1 - Within 3 days (Highly engaged)'
        WHEN days_to_return <= 7   THEN '2 - Within a week'
        WHEN days_to_return <= 14  THEN '3 - Within 2 weeks'
        WHEN days_to_return <= 30  THEN '4 - Within 30 days'
        ELSE                            '5 - After 30 days (At-risk)'
    END                            AS return_speed,
    COUNT(*)                       AS user_count,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM users), 1) AS pct_of_all_users
FROM return_timing
GROUP BY return_speed
ORDER BY return_speed;


-- ---------------------------------------------------------------
-- Query 3: First-session duration vs. churn
-- Did churned users have shorter first sessions?
-- Low first-session duration often predicts churn.
-- ---------------------------------------------------------------
WITH first_sessions AS (
    SELECT
        s.user_id,
        s.session_duration_mins
    FROM sessions s
    JOIN users u ON s.user_id = u.user_id
    WHERE s.session_date = u.signed_up_at   -- signup-day session only
),
churn_labels AS (
    SELECT
        u.user_id,
        CASE WHEN MIN(s2.session_date) IS NULL THEN 'Churned'
             ELSE 'Retained' END AS churn_status
    FROM users u
    LEFT JOIN sessions s2
        ON  s2.user_id      = u.user_id
        AND s2.session_date > u.signed_up_at
    GROUP BY u.user_id
)

SELECT
    cl.churn_status,
    COUNT(*)                                        AS users,
    ROUND(AVG(fs.session_duration_mins), 1)         AS avg_first_session_mins,
    MIN(fs.session_duration_mins)                   AS min_mins,
    MAX(fs.session_duration_mins)                   AS max_mins
FROM churn_labels cl
JOIN first_sessions fs ON cl.user_id = fs.user_id
GROUP BY cl.churn_status
ORDER BY avg_first_session_mins DESC;


-- ---------------------------------------------------------------
-- Query 4: Users at risk — signed up 14+ days ago, no return yet
-- This is an actionable list: send them a win-back email!
-- ---------------------------------------------------------------
SELECT
    u.user_id,
    u.plan_type,
    u.country,
    u.acquisition_source,
    u.signed_up_at,
    ROUND(JULIANDAY('now') - JULIANDAY(u.signed_up_at), 0) AS days_since_signup
FROM users u
LEFT JOIN sessions s
    ON  s.user_id      = u.user_id
    AND s.session_date > u.signed_up_at
WHERE s.user_id IS NULL    -- no return session at all
  AND JULIANDAY('now') - JULIANDAY(u.signed_up_at) >= 14
ORDER BY days_since_signup DESC;
