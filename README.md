# Sales Pipeline Analytics | Pipeline Leakage, Deal Ageing & Revenue Intelligence

## Project Overview

This project analyzes a fictional B2B software company's sales pipeline using SQL and Power BI. The objective is to evaluate pipeline health, understand closed-deal conversion, compare lead-source performance, identify ageing opportunities, and provide actionable recommendations for sales management.

The analysis uses a synthetic dataset of 400 sales opportunities and presents the results through an interactive Power BI dashboard.

## Business Problem

A large sales pipeline does not necessarily translate into realized revenue. Sales leadership needs visibility into opportunity outcomes, pipeline ageing, lead-source performance, loss reasons, and customer-segment contribution to identify potential risks and improve sales-process efficiency.

This project translates CRM-style opportunity data into measurable KPIs, visual insights, and practical business recommendations.

## Business Objectives

- Measure total opportunities, open pipeline value, and closed-deal win rate.
- Identify ageing opportunities and quantify their associated pipeline value.
- Compare opportunity volume and closed-deal win rates across lead sources.
- Analyze pipeline distribution by sales owner and customer segment.
- Examine recorded loss reasons and opportunity-stage distribution.
- Recommend actions to improve pipeline hygiene, lead qualification, and sales follow-up.

## Tools & Technologies

- **SQLite / SQL:** Data querying, aggregation, and KPI calculations.
- **Microsoft Power BI Service:** Interactive dashboard and data visualization.
- **Google Sheets / CSV:** Data preparation and source-data handling.
- **Business Analytics:** KPI definition, descriptive analysis, and business recommendations.

## Dataset

- **Total records:** 400 sales opportunities.
- **Business context:** Fictional B2B software company.
- **Primary table:** Opportunities.
- **Key fields:** opportunity_id, created_date, lead_source, sales_owner, customer_segment, deal_amount, current_stage, stage_probability, expected_close_date, closed_date, loss_reason, days_open, is_closed_won, and is_closed_lost.

The dataset is synthetic; the findings are illustrative and do not represent the performance of a real company.

## Key Performance Indicators

| KPI | Result |
|---|---:|
| Total Opportunities | 400 |
| Closed-Won Opportunities | 98 |
| Closed-Lost Opportunities | 74 |
| Open Opportunities | 228 |
| Closed-Deal Win Rate | 57.0% |
| Open Pipeline Value | $8.14M |
| Stale Open Deals | 196 |
| Stale Pipeline Value | $7.15M |

### KPI Definitions

- **Open Opportunities:** Total opportunities minus closed-won and closed-lost opportunities.
- **Closed-Deal Win Rate:** Closed-won opportunities divided by total closed-won and closed-lost opportunities.
- **Stale Open Deals:** Open opportunities with `days_open > 90`.
- **Stale Pipeline Value:** Sum of deal amounts for open opportunities older than 90 days.

The closed-deal win rate is calculated as 98 / (98 + 74) = 56.98%, rounded to 57.0%.

## Key Business Insights

### 1. Pipeline Ageing Is the Primary Risk Signal

196 of 228 open opportunities are older than 90 days, representing approximately 86% of open deals. These opportunities account for $7.15M, or approximately 88% of the $8.14M open pipeline.

**Business implication:** A substantial portion of the recorded pipeline requires validation. Ageing does not automatically mean a deal is lost, but it signals the need to verify buyer engagement, next steps, and expected close dates.

### 2. Lead-Source Performance Varies

| Lead Source | Total Opportunities | Won | Lost | Closed-Deal Win Rate |
|---|---:|---:|---:|---:|
| Webinar | 56 | 19 | 6 | 76.0% |
| Partner Referral | 80 | 23 | 12 | 65.7% |
| LinkedIn | 56 | 11 | 10 | 52.4% |
| Outbound | 107 | 25 | 25 | 50.0% |
| Website | 101 | 20 | 21 | 48.8% |

**Business implication:** Webinar and Partner Referral have the highest observed closed-deal win rates. Outbound generates the largest opportunity volume but has a 50.0% closed-deal win rate. These patterns justify further investigation, not a conclusion that a particular channel causes better conversion.

### 3. Enterprise Accounts Contribute the Largest Pipeline Value

The customer-segment visualization shows Enterprise as the largest pipeline-value contributor, followed by Mid-Market and SMB.

**Business implication:** High-value Enterprise opportunities warrant close-date validation and account-level reviews. Concentration in larger deals may also expose the pipeline to material slippage risk.

### 4. No Response Is the Leading Displayed Loss Reason

The loss-reason visualization identifies “No response” as the largest displayed category.

**Business implication:** Review contact cadence, follow-up timing, multichannel outreach, and lead qualification. Validate loss-reason counts and data completeness before changing sales policy.

### 5. Sales-Owner Metrics Need Context

The dashboard compares open pipeline value and average deal age across sales owners.

**Business implication:** These views can support coaching and workload prioritization. They should not be treated as standalone performance rankings because deal size, territory, account mix, lead source, tenure, and stage distribution may influence the results.

## Dashboard Features

The Power BI dashboard includes:

- KPI cards for opportunity volume, pipeline value, win rate, stale deals, and won opportunities.
- Opportunity distribution by current stage.
- Opportunity volume by lead source.
- Closed-deal win rate by lead source.
- Opportunity counts by recorded loss reason.
- Open pipeline value by sales owner.
- Pipeline value by customer segment.
- Average deal-age comparisons.
- Interactive slicers for sales owner and customer segment.

## Business Recommendations

1. **Launch a weekly stale-deal review:** Review all 196 open opportunities older than 90 days, prioritizing high-value and overdue deals.
2. **Improve pipeline hygiene:** Require updated buyer status, last-contact information, documented next steps, and realistic expected close dates.
3. **Test lead-source investments:** Investigate Webinar and Partner Referral performance using qualified-lead rates, average deal size, sales-cycle duration, and acquisition cost alongside win rate.
4. **Improve follow-up governance:** Establish a documented multichannel follow-up cadence and standardize closed-lost reasons.
5. **Define stage-entry and exit criteria:** Establish consistent requirements for progressing opportunities through the sales process.
6. **Validate forecasting assumptions:** Compare stage probabilities with historical conversion outcomes before using probability-weighted pipeline as a forecast.
7. **Use owner-level analysis responsibly:** Support coaching and workload balancing while accounting for differences in opportunity mix.

## Suggested Success Metrics

- Reduce the share of open opportunities older than 90 days from approximately 86% to below 60% over an agreed 8–12 week period.
- Ensure at least 95% of open opportunities have a documented next step and updated close date.
- Achieve 100% standardized loss-reason completion for closed-lost opportunities.
- Track closed-deal win rates by lead source monthly, alongside sample sizes and average deal values.
- Establish a baseline for forecast accuracy before setting an improvement target.

These are proposed targets, not measured project outcomes.

## Analytical Approach

1. Defined the business problem and translated it into measurable questions.
2. Inspected opportunity fields and prepared the data.
3. Loaded 400 opportunity records into SQLite.
4. Used SQL aggregation and conditional logic to analyze opportunity outcomes, lead sources, and stale deals.
5. Built KPI cards, comparative charts, and interactive filters in Power BI Service.
6. Interpreted the results and documented business recommendations and validation requirements.

## Limitations & Data Integrity

- The dataset is synthetic and represents a fictional business.
- The analysis is descriptive; it does not establish causation or constitute a validated predictive forecast.
- The dashboard primarily uses the Opportunities table. Stage-history data is not fully incorporated into the dashboard, so current-stage counts should not be interpreted as stage-to-stage conversion rates.
- Total Pipeline Value and Open Pipeline Value both display $8.14M. This discrepancy requires reconciliation against the underlying rows before both figures can be considered validated.
- Exact loss-reason counts and owner-level comparisons should be validated before drawing strong operational conclusions.
- Stage probabilities should not be treated as validated forecasting probabilities without historical calibration.

## Project Deliverables

- Power BI sales pipeline dashboard.
- SQL-based opportunity analysis.
- KPI definitions and business insights.
- Executive project report.
- Detailed step-by-step project report.
- Dashboard change log and analytical rationale.

## Author

**Zen**  
Business Analytics | SQL | Power BI | Business Intelligence
