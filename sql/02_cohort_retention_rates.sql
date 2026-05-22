-- =============================================================
-- 02_cohort_retention_rates.sql
-- Monthly cohort retention analysis
-- "Which signup months produced the most loyal users?"
--
-- Concepts: strftime() for date bucketing, CTEs, GROUP BY,
--           ROUND/CAST for percentages, cohort patterns
-- =============================================================

-- ---------------------------------------------------------------
-- Query 1: 30-day retention rate per cohort month
-- The headline metric for any retention dashboard
-- ---------------------------------------------------------------
WITH user_retention AS (
    SELECT
        u.user_id,
        strftime('%Y-%m', u.signed_up_at)   AS cohort_month,
        u.plan_type,
        u.acquisition_source,
        MIN(s.session_date)                 AS first_return_date,
        CASE
            WHEN MIN(s.session_date) IS NULL THEN 0
            WHEN JULIANDAY(MIN(s.session_date)) - JULIANDAY(u.signed_up_at) <= 30
                 THEN 1
            ELSE 0
        END                                 AS retained_30d
    FROM users u
    LEFT JOIN sessions s
        ON  s.user_id      = u.user_id
        AND s.session_date > u.signed_up_at
    GROUP BY u.user_id, u.signed_up_at, u.plan_type, u.acquisition_source
)

SELECT
    cohort_month,
    COUNT(*)                                      AS total_users,
    SUM(retained_30d)                             AS retained_users,
    COUNT(*) - SUM(retained_30d)                  AS churned_users,
    ROUND(
        100.0 * SUM(retained_30d) / CAST(COUNT(*) AS REAL),
        1
    )                                             AS retention_rate_pct,
    ROUND(
        100.0 * (COUNT(*) - SUM(retained_30d)) / CAST(COUNT(*) AS REAL),
        1
    )                                             AS churn_rate_pct
FROM user_retention
GROUP BY cohort_month
ORDER BY cohort_month;


-- ---------------------------------------------------------------
-- Query 2: 30 / 60 / 90-day retention side by side
-- Shows how retention degrades over time for each cohort
-- ---------------------------------------------------------------
WITH user_days AS (
    SELECT
        u.user_id,
        strftime('%Y-%m', u.signed_up_at)    AS cohort_month,
        ROUND(
            JULIANDAY(MIN(s.session_date)) - JULIANDAY(u.signed_up_at),
            0
        )                                    AS days_to_first_return
    FROM users u
    LEFT JOIN sessions s
        ON  s.user_id      = u.user_id
        AND s.session_date > u.signed_up_at
    GROUP BY u.user_id, u.signed_up_at
)

SELECT
    cohort_month,
    COUNT(*)                                                              AS total_users,
    ROUND(100.0 * SUM(CASE WHEN days_to_first_return <= 30  THEN 1 ELSE 0 END)
          / COUNT(*), 1)                                                  AS ret_30d_pct,
    ROUND(100.0 * SUM(CASE WHEN days_to_first_return <= 60  THEN 1 ELSE 0 END)
          / COUNT(*), 1)                                                  AS ret_60d_pct,
    ROUND(100.0 * SUM(CASE WHEN days_to_first_return <= 90  THEN 1 ELSE 0 END)
          / COUNT(*), 1)                                                  AS ret_90d_pct,
    ROUND(100.0 * SUM(CASE WHEN days_to_first_return IS NULL THEN 1 ELSE 0 END)
          / COUNT(*), 1)                                                  AS never_returned_pct
FROM user_days
GROUP BY cohort_month
ORDER BY cohort_month;


-- ---------------------------------------------------------------
-- Query 3: Retention rate by plan type within each cohort
-- "Do pro users retain better than free users?"
-- ---------------------------------------------------------------
WITH user_retention AS (
    SELECT
        u.user_id,
        strftime('%Y-%m', u.signed_up_at)    AS cohort_month,
        u.plan_type,
        CASE
            WHEN MIN(s.session_date) IS NULL THEN 0
            WHEN JULIANDAY(MIN(s.session_date)) - JULIANDAY(u.signed_up_at) <= 30
                 THEN 1
            ELSE 0
        END                                  AS retained_30d
    FROM users u
    LEFT JOIN sessions s
        ON  s.user_id = u.user_id
        AND s.session_date > u.signed_up_at
    GROUP BY u.user_id, u.signed_up_at, u.plan_type
)

SELECT
    cohort_month,
    plan_type,
    COUNT(*)                                                           AS users,
    SUM(retained_30d)                                                  AS retained,
    ROUND(100.0 * SUM(retained_30d) / CAST(COUNT(*) AS REAL), 1)      AS retention_pct
FROM user_retention
GROUP BY cohort_month, plan_type
ORDER BY cohort_month, plan_type;
