-- =============================================================
-- 01_label_churned_retained.sql
-- The foundational churn query: label every user as retained
-- or churned based on whether they ever returned after signup.
--
-- Concepts: LEFT JOIN, NULL handling (IS NULL), CASE WHEN,
--           self-referencing subquery, date filtering
-- =============================================================

-- ---------------------------------------------------------------
-- Query 1: The core churn detection pattern
-- LEFT JOIN sessions to find users with NO return visit
-- A NULL on the right side = no matching return session = churned
-- ---------------------------------------------------------------
SELECT
    u.user_id,
    u.plan_type,
    u.country,
    u.signed_up_at,
    u.acquisition_source,

    -- Date of first return visit (NULL if they never came back)
    MIN(s.session_date)       AS first_return_date,

    -- Days between signup and first return (NULL if churned)
    ROUND(
        JULIANDAY(MIN(s.session_date)) - JULIANDAY(u.signed_up_at),
        0
    )                         AS days_to_return,

    -- The churn label itself
    CASE
        WHEN MIN(s.session_date) IS NULL THEN 'Churned'
        ELSE                                  'Retained'
    END                       AS churn_status

FROM users u
LEFT JOIN sessions s
    ON  s.user_id      = u.user_id
    AND s.session_date > u.signed_up_at   -- exclude signup-day session
GROUP BY u.user_id, u.plan_type, u.country, u.signed_up_at, u.acquisition_source
ORDER BY u.signed_up_at;


-- ---------------------------------------------------------------
-- Query 2: Summary — how many churned vs retained overall?
-- ---------------------------------------------------------------
WITH user_status AS (
    SELECT
        u.user_id,
        CASE WHEN MIN(s.session_date) IS NULL THEN 'Churned'
             ELSE 'Retained' END AS churn_status
    FROM users u
    LEFT JOIN sessions s
        ON  s.user_id      = u.user_id
        AND s.session_date > u.signed_up_at
    GROUP BY u.user_id
)

SELECT
    churn_status,
    COUNT(*)                                          AS user_count,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM users), 1) AS pct_of_total
FROM user_status
GROUP BY churn_status
ORDER BY user_count DESC;


-- ---------------------------------------------------------------
-- Query 3: 30-day retention window
-- "Did the user return within 30 days of signing up?"
-- More strict than lifetime retained — commonly used in SaaS
-- ---------------------------------------------------------------
SELECT
    u.user_id,
    u.plan_type,
    u.signed_up_at,
    MIN(s.session_date)   AS first_return_date,
    CASE
        WHEN MIN(s.session_date) IS NULL                                   THEN 'Churned'
        WHEN JULIANDAY(MIN(s.session_date)) - JULIANDAY(u.signed_up_at)
             <= 30                                                          THEN 'Retained (30d)'
        ELSE                                                                     'Late return (30d+)'
    END                   AS retention_30d_status
FROM users u
LEFT JOIN sessions s
    ON  s.user_id      = u.user_id
    AND s.session_date > u.signed_up_at
GROUP BY u.user_id, u.plan_type, u.signed_up_at
ORDER BY u.signed_up_at;
