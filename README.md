# 📉 Customer Retention & Churn Report

> **Resume line:** *"Built a churn identification query on 50K+ user records, segmenting retained vs. lapsed users by cohort month. Calculated 30/60/90-day retention rates and identified highest-churn acquisition periods."*

---

## 📌 Project Overview

This project answers the most important question in any subscription or repeat-use product:

> *"Which users came back — and which ones never returned after their first visit?"*

You'll build a full churn analysis pipeline: labeling users as retained or churned, calculating retention rates by cohort, and identifying which signup months produced the most loyal users.

**Business Questions Answered:**
- What % of users return within 30 / 60 / 90 days of signup?
- Which cohort months have the worst churn?
- How quickly do churned users leave — same day, within a week?
- Are certain segments (plan type, country) more likely to churn?
- What does the retention curve look like over 12 weeks?

---

## 🗂️ Project Structure

```
customer-churn-report/
│
├── README.md
├── data/
│   └── seed_data.sql                  # Creates + populates all tables
│
├── sql/
│   ├── 01_label_churned_retained.sql  # Core churn classification
│   ├── 02_cohort_retention_rates.sql  # Monthly cohort retention %
│   ├── 03_retention_curve.sql         # Week-by-week retention curve
│   ├── 04_churn_by_segment.sql        # Churn broken down by segment
│   └── 05_days_to_churn.sql           # How fast do users leave?
│
└── docs/
    └── findings.md                    # Sample executive write-up
```

---

## 🛠️ Skills Demonstrated

| SQL Concept | Where Used |
|---|---|
| `DATE` functions (`strftime`, `julianday`) | Calculating days since signup |
| Self-JOIN | Comparing a user's first session to later sessions |
| `NULL` handling (`IS NULL`, `COALESCE`, `NULLIF`) | Identifying users with no return visit |
| `LEFT JOIN` | The core churn detection pattern |
| `GROUP BY` + aggregations | Cohort counts and rates |
| `CASE WHEN` | Labeling users as churned / retained |
| CTEs (`WITH`) | Chaining cohort logic cleanly |
| `ROUND`, `CAST` | Calculating percentages |

---

## 🗃️ Schema

**`users`** — one row per registered user
```
user_id | plan_type | country | signed_up_at | acquisition_source
```

**`sessions`** — one row per user session (visit/login)
```
session_id | user_id | session_date | session_duration_mins
```

---

## 📊 Sample Output

### 30-Day Retention by Cohort Month

| Cohort Month | Users | Retained (30d) | Churned | Retention Rate |
|---|---|---|---|---|
| 2023-09 | 120 | 74 | 46 | 61.7% |
| 2023-10 | 135 | 79 | 56 | 58.5% |
| 2023-11 | 148 | 80 | 68 | 54.1% |
| 2023-12 | 112 | 55 | 57 | 49.1% ⚠️ |

**Key Finding:** December cohort shows the sharpest retention drop — likely holiday signups with lower long-term intent.

---

## 🚀 How to Run

### Option A — SQLiteOnline (No Setup)
1. Go to [sqliteonline.com](https://sqliteonline.com/)
2. Paste and run `data/seed_data.sql` first
3. Run each file in `sql/` in order (01 → 05)

### Option B — Local SQLite
```bash
sqlite3 churn.db < data/seed_data.sql
sqlite3 churn.db < sql/01_label_churned_retained.sql
sqlite3 churn.db < sql/02_cohort_retention_rates.sql
sqlite3 churn.db < sql/03_retention_curve.sql
sqlite3 churn.db < sql/04_churn_by_segment.sql
sqlite3 churn.db < sql/05_days_to_churn.sql
```

### Option C — BigQuery (Google Merchandise Store)
This project mirrors the structure of BigQuery's public `bigquery-public-data.google_analytics_sample` dataset.
To adapt these queries for BigQuery:
- Replace `sessions` with `bigquery-public-data.google_analytics_sample.ga_sessions_*`
- Replace `strftime('%Y-%m', ...)` with `FORMAT_DATE('%Y-%m', PARSE_DATE('%Y%m%d', date))`
- Replace `julianday()` date math with `DATE_DIFF(date1, date2, DAY)`
- `user_id` maps to `fullVisitorId`

---

## 💡 Extensions (Stretch Goals)

- [ ] Build a 12-week retention cohort heatmap (classic "retention table")
- [ ] Add `revenue` column to sessions and calculate revenue retention vs. user retention
- [ ] Predict churn risk score using session frequency in first 7 days
- [ ] Compare retention of organic vs. paid acquisition sources
- [ ] Reproduce this analysis on the real BigQuery public dataset

---

## 📝 Findings

See [`docs/findings.md`](docs/findings.md) for a sample executive summary framed as a retention health report.

---

*Part of a SQL portfolio series focused on product analytics for tech companies.*
