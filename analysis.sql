-- Sales Pipeline Leakage & Revenue Forecasting
-- Dataset is synthetic and created for portfolio practice.
-- Run in SQLite after importing opportunities.csv and stage_history.csv
-- as tables named opportunities and stage_history.

-- 1. Basic data quality checks
SELECT COUNT(*) AS total_opportunities,
       COUNT(DISTINCT opportunity_id) AS unique_opportunities
FROM opportunities;

SELECT
  SUM(CASE WHEN deal_amount IS NULL OR deal_amount <= 0 THEN 1 ELSE 0 END) AS invalid_amounts,
  SUM(CASE WHEN created_date IS NULL THEN 1 ELSE 0 END) AS missing_created_dates
FROM opportunities;

-- 2. Pipeline snapshot: open pipeline value and probability-weighted forecast
SELECT
  COUNT(*) AS open_opportunities,
  ROUND(SUM(deal_amount), 2) AS open_pipeline_value,
  ROUND(SUM(deal_amount * stage_probability), 2) AS weighted_pipeline_forecast
FROM opportunities
WHERE is_closed_won = 0 AND is_closed_lost = 0;

-- 3. Win rate among closed opportunities
SELECT
  ROUND(100.0 * SUM(is_closed_won) / NULLIF(SUM(is_closed_won + is_closed_lost), 0), 2) AS closed_deal_win_rate_pct,
  SUM(is_closed_won) AS won_deals,
  SUM(is_closed_lost) AS lost_deals
FROM opportunities;

-- 4. Pipeline by current stage
SELECT current_stage,
       COUNT(*) AS opportunity_count,
       ROUND(SUM(deal_amount), 2) AS pipeline_amount,
       ROUND(SUM(deal_amount * stage_probability), 2) AS weighted_amount
FROM opportunities
WHERE current_stage NOT IN ('Closed Won', 'Closed Lost')
GROUP BY current_stage
ORDER BY weighted_amount DESC;

-- 5. Win rate and pipeline by lead source
SELECT lead_source,
       COUNT(*) AS total_opportunities,
       SUM(is_closed_won) AS won_deals,
       SUM(is_closed_lost) AS lost_deals,
       ROUND(100.0 * SUM(is_closed_won) / NULLIF(SUM(is_closed_won + is_closed_lost), 0), 2) AS closed_win_rate_pct,
       ROUND(SUM(CASE WHEN is_closed_won = 0 AND is_closed_lost = 0 THEN deal_amount ELSE 0 END), 2) AS open_pipeline_value
FROM opportunities
GROUP BY lead_source
ORDER BY open_pipeline_value DESC;

-- 6. Stage conversion: count opportunities that reached each main stage.
-- Closed Won is shown as the final successful outcome; Closed Lost is not
-- treated as the next sequential stage because it is an alternative outcome.
WITH funnel_stages AS (
  SELECT 'Lead' AS stage, 1 AS stage_order UNION ALL
  SELECT 'Qualified', 2 UNION ALL
  SELECT 'Demo', 3 UNION ALL
  SELECT 'Proposal', 4 UNION ALL
  SELECT 'Negotiation', 5 UNION ALL
  SELECT 'Closed Won', 6
),
stage_counts AS (
  SELECT fs.stage, fs.stage_order,
         COUNT(DISTINCT sh.opportunity_id) AS opportunities_reached
  FROM funnel_stages fs
  LEFT JOIN stage_history sh ON sh.stage = fs.stage
  GROUP BY fs.stage, fs.stage_order
)
SELECT stage, opportunities_reached,
       LAG(opportunities_reached) OVER (ORDER BY stage_order) AS previous_stage_count,
       CASE WHEN LAG(opportunities_reached) OVER (ORDER BY stage_order) IS NULL THEN NULL
            ELSE ROUND(100.0 * opportunities_reached /
                 NULLIF(LAG(opportunities_reached) OVER (ORDER BY stage_order), 0), 2)
       END AS conversion_from_previous_stage_pct
FROM stage_counts
ORDER BY stage_order;

-- 7. Average days spent in each stage
SELECT stage,
       ROUND(AVG(julianday(stage_exit_date) - julianday(stage_entry_date)), 1) AS avg_days_in_stage,
       COUNT(*) AS stage_records
FROM stage_history
GROUP BY stage
ORDER BY AVG(julianday(stage_exit_date) - julianday(stage_entry_date)) DESC;

-- 8. Deal ageing buckets for open deals
SELECT
  CASE
    WHEN days_open < 15 THEN '0-14 days'
    WHEN days_open < 31 THEN '15-30 days'
    WHEN days_open < 61 THEN '31-60 days'
    ELSE '61+ days'
  END AS ageing_bucket,
  COUNT(*) AS deals,
  ROUND(SUM(deal_amount), 2) AS pipeline_value
FROM opportunities
WHERE is_closed_won = 0 AND is_closed_lost = 0
GROUP BY ageing_bucket
ORDER BY MIN(days_open);

-- 9. Lost deal reasons
SELECT loss_reason, COUNT(*) AS lost_deals,
       ROUND(SUM(deal_amount), 2) AS lost_deal_value
FROM opportunities
WHERE is_closed_lost = 1
GROUP BY loss_reason
ORDER BY lost_deals DESC;

-- 10. Monthly closed-won revenue (recognized here as closed-won deal amount; not accounting revenue)
SELECT substr(closed_date, 1, 7) AS close_month,
       COUNT(*) AS won_deals,
       ROUND(SUM(deal_amount), 2) AS closed_won_value
FROM opportunities
WHERE is_closed_won = 1 AND closed_date IS NOT NULL
GROUP BY substr(closed_date, 1, 7)
ORDER BY close_month;

-- Important limitation:
-- The weighted pipeline uses illustrative stage probabilities, not calibrated historical win rates.
-- Do not call it a validated forecast until stage probabilities are calibrated on historical data.
