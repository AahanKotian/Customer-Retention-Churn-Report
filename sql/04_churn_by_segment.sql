-- =============================================================
-- 04_churn_by_segment.sql
-- Break down churn by plan type, acquisition source, country
-- "Which segments churn the most?"
--
-- Concepts: GROUP BY multiple columns, HAVING to filter
--           high-churn segments, percentage calculations,
--           ranking with ORDER BY
-- =============================================================

-- ---------------------------------------------------------------
-- Query 1: Churn rate by plan type
-- Usually the most impactful segmentation to show
-- ---------------------------------------------------------------
WITH user_status AS (
    SELECT
        u.user_id,
        u.plan_type,
        CASE WHEN MIN(s.session_date) IS NULL THEN 1 ELSE 0 END AS churned
    FROM users u
    LEFT JOIN sessions s
        ON  s.user_id      = u.user_id
        AND s.session_date > u.signed_up_at
    GROUP BY u.user_id, u.plan_type
)

SELECT
    plan_type,
    COUNT(*)                                                        AS total_users,
    SUM(churned)                                                    AS churned_users,
    COUNT(*) - SUM(churned)                                         AS retained_users,
    ROUND(100.0 * SUM(churned) / CAST(COUNT(*) AS REAL), 1)         AS churn_rate_pct
FROM user_status
GROUP BY plan_type
ORDER BY churn_rate_pct DESC;


-- ---------------------------------------------------------------
-- Query 2: Churn rate by acquisition source
-- "Which channel brings in the most loyal users?"
-- ---------------------------------------------------------------
WITH user_status AS (
    SELECT
        u.user_id,
        u.acquisition_source,
        CASE WHEN MIN(s.session_date) IS NULL THEN 1 ELSE 0 END AS churned
    FROM users u
    LEFT JOIN sessions s
        ON  s.user_id      = u.user_id
        AND s.session_date > u.signed_up_at
    GROUP BY u.user_id, u.acquisition_source
)

SELECT
    acquisition_source,
    COUNT(*)                                                        AS total_users,
    SUM(churned)                                                    AS churned_users,
    ROUND(100.0 * SUM(churned) / CAST(COUNT(*) AS REAL), 1)         AS churn_rate_pct
FROM user_status
GROUP BY acquisition_source
ORDER BY churn_rate_pct DESC;


-- ---------------------------------------------------------------
-- Query 3: Churn rate by country (filter to countries with 5+ users)
-- HAVING filters out small sample sizes
-- ---------------------------------------------------------------
WITH user_status AS (
    SELECT
        u.user_id,
        u.country,
        CASE WHEN MIN(s.session_date) IS NULL THEN 1 ELSE 0 END AS churned
    FROM users u
    LEFT JOIN sessions s
        ON  s.user_id      = u.user_id
        AND s.session_date > u.signed_up_at
    GROUP BY u.user_id, u.country
)

SELECT
    country,
    COUNT(*)                                                        AS total_users,
    SUM(churned)                                                    AS churned_users,
    ROUND(100.0 * SUM(churned) / CAST(COUNT(*) AS REAL), 1)         AS churn_rate_pct
FROM user_status
GROUP BY country
HAVING total_users >= 5
ORDER BY churn_rate_pct DESC;


-- ---------------------------------------------------------------
-- Query 4: Worst segment combinations (plan + source)
-- Surfaces the highest-risk user profiles
-- ---------------------------------------------------------------
WITH user_status AS (
    SELECT
        u.user_id,
        u.plan_type,
        u.acquisition_source,
        CASE WHEN MIN(s.session_date) IS NULL THEN 1 ELSE 0 END AS churned
    FROM users u
    LEFT JOIN sessions s
        ON  s.user_id      = u.user_id
        AND s.session_date > u.signed_up_at
    GROUP BY u.user_id, u.plan_type, u.acquisition_source
)

SELECT
    plan_type,
    acquisition_source,
    COUNT(*)                                                        AS users,
    ROUND(100.0 * SUM(churned) / CAST(COUNT(*) AS REAL), 1)         AS churn_rate_pct
FROM user_status
GROUP BY plan_type, acquisition_source
HAVING users >= 3
ORDER BY churn_rate_pct DESC
LIMIT 10;
