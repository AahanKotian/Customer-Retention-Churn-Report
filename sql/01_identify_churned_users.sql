-- =============================================================
-- 01_identify_churned_users.sql
-- Core logic: flag every user as churned or retained
-- Definition: churned = no session after their first one
--
-- Concepts: self-JOIN, LEFT JOIN, NULL handling (IS NULL),
--           MIN() for first session, CASE WHEN for churn flag
-- =============================================================

-- ---------------------------------------------------------------
-- Query 1: Find each user's first and last session date
-- Uses MIN() and MAX() — no JOIN needed yet
-- ---------------------------------------------------------------
SELECT
    u.user_id,
    u.acquisition_channel,
    u.plan_type,
    u.signed_up_at,
    MIN(s.session_date)   AS first_session,
    MAX(s.session_date)   AS last_session,
    COUNT(s.session_id)   AS total_sessions
FROM users u
JOIN sessions s ON u.user_id = s.user_id
GROUP BY u.user_id, u.acquisition_channel, u.plan_type, u.signed_up_at
ORDER BY u.user_id;


-- ---------------------------------------------------------------
-- Query 2: Self-JOIN to detect return visits
-- Join each user's first session to any later session.
-- If no later session exists → NULL → churned.
--
-- This is the core churn identification pattern.
-- ---------------------------------------------------------------
WITH first_sessions AS (
    SELECT
        user_id,
        MIN(session_date) AS first_session_date
    FROM sessions
    GROUP BY user_id
),
return_sessions AS (
    SELECT DISTINCT
        fs.user_id,
        fs.first_session_date,
        s.session_date        AS return_session_date
    FROM first_sessions fs
    LEFT JOIN sessions s
        ON  fs.user_id         = s.user_id
        AND s.session_date     > fs.first_session_date   -- any session AFTER first
)

SELECT
    u.user_id,
    u.acquisition_channel,
    u.plan_type,
    u.signed_up_at,
    rs.first_session_date,
    rs.return_session_date,                              -- NULL if no return
    CASE
        WHEN rs.return_session_date IS NULL THEN 'Churned'
        ELSE                                    'Retained'
    END                             AS churn_status
FROM users u
JOIN return_sessions rs ON u.user_id = rs.user_id
-- Keep only one row per user (their first return, or NULL)
WHERE rs.return_session_date = (
    SELECT MIN(s2.session_date)
    FROM sessions s2
    WHERE s2.user_id     = rs.user_id
      AND s2.session_date > rs.first_session_date
)
OR rs.return_session_date IS NULL
ORDER BY churn_status, u.user_id;


-- ---------------------------------------------------------------
-- Query 3: Summary counts — how many churned vs retained?
-- ---------------------------------------------------------------
WITH first_sessions AS (
    SELECT user_id, MIN(session_date) AS first_session_date
    FROM sessions
    GROUP BY user_id
),
churn_flags AS (
    SELECT
        fs.user_id,
        CASE
            WHEN EXISTS (
                SELECT 1 FROM sessions s
                WHERE s.user_id = fs.user_id
                  AND s.session_date > fs.first_session_date
            )
            THEN 'Retained'
            ELSE 'Churned'
        END AS churn_status
    FROM first_sessions fs
)

SELECT
    churn_status,
    COUNT(*)                                          AS user_count,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM users), 1) AS pct_of_total
FROM churn_flags
GROUP BY churn_status
ORDER BY churn_status;
