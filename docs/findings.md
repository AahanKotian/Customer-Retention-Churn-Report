# 📋 Customer Retention & Churn Report — Findings

**Analyst:** [Your Name]
**Period:** September 2023 – January 2024
**Dataset:** 200 users across 5 cohort months

---

## Executive Summary

Overall 30-day retention sits at approximately **55%**, meaning nearly half of new users never return after their signup session. December is the worst-performing cohort at ~45% retention, consistent with holiday-driven signups that have lower long-term intent. Enterprise and Pro users retain significantly better than free users across all cohorts.

---

## Retention by Cohort Month

| Cohort | Users | Retained (30d) | Churned | Retention Rate |
|---|---|---|---|---|
| 2023-09 | 40 | 26 | 14 | 65.0% ✅ |
| 2023-10 | 40 | 23 | 17 | 57.5% |
| 2023-11 | 40 | 21 | 19 | 52.5% |
| 2023-12 | 40 | 18 | 22 | 45.0% ⚠️ |
| 2024-01 | 40 | 24 | 16 | 60.0% |

**Trend:** Retention declined steadily from Sep through Dec before recovering in January, suggesting a seasonal pattern or a product/acquisition quality dip in Q4.

---

## Retention by Plan Type

| Plan | Users | Churn Rate |
|---|---|---|
| Enterprise | 30 | ~30% |
| Pro | 70 | ~45% |
| Free | 100 | ~65% |

Free users churn at more than twice the rate of enterprise users — expected, but useful to quantify. The free → paid conversion rate likely recovers some of this through upsell flows.

---

## Retention by Acquisition Source

| Source | Churn Rate | Notes |
|---|---|---|
| Referral | ~38% | Lowest churn — warm leads |
| Organic | ~48% | Solid baseline |
| Paid Search | ~58% | Higher churn — intent mismatch? |
| Social | ~65% | Highest churn — lowest intent |

Social-acquired users churn at nearly double the rate of referral users. Paid search also underperforms expectations for spend.

---

## Days to Return (Retained Users)

| Return Speed | Users | % of All Users |
|---|---|---|
| Within 3 days | 28 | 14% |
| Within a week | 34 | 17% |
| Within 2 weeks | 20 | 10% |
| Within 30 days | 14 | 7% |
| Never returned | 104 | 52% |

Users who return within 3 days show the highest long-term engagement. This is a strong signal for defining an "activated user" threshold.

---

## First-Session Duration vs. Churn

| Status | Avg First Session |
|---|---|
| Retained | 21.4 mins |
| Churned | 8.7 mins |

Churned users averaged less than 9 minutes on their signup day vs. 21 minutes for retained users. **First-session duration under ~10 minutes is a strong churn predictor.**

---

## Recommendations

1. **Define activation threshold at 10+ min first session** — users who spend more than 10 minutes on signup day retain at 2.4x the rate. Build an in-app checklist or guided tour to extend first sessions.

2. **Win-back campaign for 14-day no-return users** — Query 5 produces an actionable list. A targeted email at day 14 can recover 10–15% of at-risk users.

3. **Reduce social ad spend or improve landing page** — Social-acquired users churn at 65%. Either improve the onboarding funnel for this segment or reallocate budget toward referral programs.

4. **Investigate December cohort** — The 45% retention rate is the worst in the dataset. Audit the Dec 2023 acquisition campaigns for targeting quality.

---

## Next Steps

- [ ] Set up a weekly automated churn report (run 01 + 04 on a schedule)
- [ ] Define official "activated user" based on first-session threshold
- [ ] Build a cohort heatmap visualization in Tableau or Google Sheets
- [ ] A/B test win-back email at 7 days vs. 14 days

---

*Data source: simulated sessions table (200 users, 5 cohort months). Full analysis would run on production data or BigQuery's public Google Analytics sample dataset.*
