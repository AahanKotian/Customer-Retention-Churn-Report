-- =============================================================
-- 03_retention_curve.sql
-- Week-by-week retention curve
-- "What % of users are still active N weeks after signup?"
--
-- Concepts: JULIANDAY arithmetic, integer division for week
--           buckets, CTEs, cumulative patterns
-- =============================================================

-- ---------------------------------------------------------------
-- Query 1: Retention by week number after signup (weeks 1–12)
-- Classic retention curve used in product analytics
-- ---------------------------------------------------------------
WITH user_weeks AS (
    -- Find the earliest return session week for each user
    SELECT
        u.user_id,
        strftime('%Y-%m', u.signed_up_at)  AS cohort_month,
        CAST(
            (JULIANDAY(MIN(s.session_date)) - JULIANDAY(u.signed_up_at)) / 7
            AS INTEGER
        )                                  AS return_week   -- NULL if never returned
    FROM users u
    LEFT JOIN sessions s
        ON  s.user_id      = u.user_id
        AND s.session_date > u.signed_up_at
    GROUP BY u.user_id, u.signed_up_at
)

SELECT
    return_week,
    COUNT(*)                                       AS users_returning_this_week,
    ROUND(
        100.0 * COUNT(*) / (SELECT COUNT(*) FROM users),
        1
    )                                              AS pct_of_all_users
FROM user_weeks
WHERE return_week IS NOT NULL
  AND return_week <= 12
GROUP BY return_week
ORDER BY return_week;


-- ---------------------------------------------------------------
-- Query 2: Cumulative retention — what % still active by week N?
-- This is what you plot as the classic retention curve
-- ---------------------------------------------------------------
WITH user_weeks AS (
    SELECT
        u.user_id,
        CAST(
            (JULIANDAY(MIN(s.session_date)) - JULIANDAY(u.signed_up_at)) / 7
            AS INTEGER
        ) AS return_week
    FROM users u
    LEFT JOIN sessions s
        ON  s.user_id      = u.user_id
        AND s.session_date > u.signed_up_at
    GROUP BY u.user_id, u.signed_up_at
),
total AS (SELECT COUNT(*) AS n FROM users),
weeks(w) AS (
    VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12)
)

SELECT
    w.w                                         AS week_number,
    SUM(CASE WHEN uw.return_week <= w.w THEN 1 ELSE 0 END) AS cumulative_retained,
    ROUND(
        100.0 * SUM(CASE WHEN uw.return_week <= w.w THEN 1 ELSE 0 END)
        / (SELECT n FROM total),
        1
    )                                           AS cumulative_retention_pct
FROM weeks w
CROSS JOIN user_weeks uw
GROUP BY w.w
ORDER BY w.w;


-- ---------------------------------------------------------------
-- Query 3: Never-returned users count and % (the churn floor)
-- ---------------------------------------------------------------
SELECT
    COUNT(*)                                              AS total_users,
    SUM(CASE WHEN s.user_id IS NULL THEN 1 ELSE 0 END)   AS never_returned,
    ROUND(
        100.0 * SUM(CASE WHEN s.user_id IS NULL THEN 1 ELSE 0 END)
        / CAST(COUNT(*) AS REAL),
        1
    )                                                     AS pct_never_returned
FROM users u
LEFT JOIN (
    SELECT DISTINCT user_id
    FROM sessions s2
    JOIN users u2 ON s2.user_id = u2.user_id
    WHERE s2.session_date > u2.signed_up_at
) s ON u.user_id = s.user_id;
