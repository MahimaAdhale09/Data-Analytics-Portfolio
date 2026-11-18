# RFM Customer Segmentation – BigQuery + BI

Customer segmentation using **RFM analysis** (Recency, Frequency, Monetary) on 2025 sales data. Monthly sales files are loaded into Google BigQuery, appended into one table, scored in deciles with SQL, and turned into a BI-ready segment table.

---

## Table of Contents
1. [Project Overview](#project-overview)
2. [Business Problem](#business-problem)
3. [Dataset](#dataset)
4. [Tech Stack](#tech-stack)
5. [Project Structure](#project-structure)
6. [Methodology](#methodology)
7. [SQL Pipeline (Step by Step)](#sql-pipeline-step-by-step)
8. [Segment Definitions](#segment-definitions)
9. [Output Tables](#output-tables)
10. [How to Run](#how-to-run)
11. [Dashboard Suggestions](#dashboard-suggestions)
12. [Assumptions and Limitations](#assumptions-and-limitations)
13. [Future Improvements](#future-improvements)

---

## Project Overview
RFM analysis ranks customers by:

| Metric | Question it answers | Definition used here |
|---|---|---|
| **Recency (R)** | How recently did the customer buy? | Days between the analysis date and the customer's last order |
| **Frequency (F)** | How often do they buy? | Number of orders in 2025 |
| **Monetary (M)** | How much do they spend? | Sum of `OrderValue` in 2025 |

Each metric is scored from 1 to 10 (10 = best). The three scores are added into a **total RFM score (3–30)**, and each customer is assigned to a named segment (VIP, Loyal, At Risk, and so on).

## Business Problem
Marketing treats all customers the same, which wastes budget. The goals are to:
- Identify the highest-value customers to protect and reward.
- Spot customers drifting away before they are lost.
- Target campaigns (loyalty offers, win-back, upsell) by segment.

## Dataset
**Source:** 12 monthly sales files (`202501.csv` to `202512.csv`), one row per order.

| Column | Type | Description |
|---|---|---|
| `OrderID` | STRING | Unique order identifier (e.g. `ORDER00102`) |
| `CustomerID` | STRING | Customer identifier (e.g. `CUST0038`) |
| `OrderDate` | DATE | Order date (source format is `M/D/YYYY`) |
| `ProductType` | STRING | Product category (6 types, e.g. Flyer, Canvas Print, Greeting Card) |
| `OrderValue` | FLOAT | Order amount (range about 4.01 to 48.00) |

**Dataset size**
- Total orders: **994**
- Unique customers: **287**
- Period: **1 Jan 2025 to 31 Dec 2025**
- Average order value: about **17.17**

| Month | Rows | Month | Rows |
|---|---|---|---|
| Jan | 59 | Jul | 84 |
| Feb | 86 | Aug | 79 |
| Mar | 100 | Sep | 74 |
| Apr | 79 | Oct | 85 |
| May | 76 | Nov | 72 |
| Jun | 102 | Dec | 98 |

## Tech Stack
- **Google BigQuery** (SQL, views, tables)
- **CSV** monthly source files
- **BI tool** (Power BI / Looker Studio / Tableau) for the final dashboard

## Project Structure
```
rfm-segmentation/
├── data/
│   ├── 202501.csv … 202512.csv     # monthly sales files
├── sql/
│   └── query.sql                   # full RFM pipeline
├── dashboard/                      # BI file / screenshots (optional)
└── README.md
```

## Methodology
1. **Load** each monthly CSV as its own BigQuery table (`sales202501` … `sales202512_new`).
2. **Append** all 12 tables into one table, `sales_2025`.
3. **Aggregate per customer** into recency, frequency and monetary values.
4. **Rank** customers on each metric with `ROW_NUMBER()`.
5. **Score** each rank in deciles with `NTILE(10)` (10 = best, 1 = worst).
6. **Sum** the three scores into a total from 3 to 30.
7. **Segment** customers with a `CASE` statement on the total score.
8. **Publish** the final table for the BI tool.

## SQL Pipeline (Step by Step)

### Step 1 – Append the monthly tables
Combines the 12 monthly tables into one (`UNION ALL`):
`rfm-analysis-495110.sales.sales_2025`

### Step 2 – Calculate R, F, M and ranks (`rfm_metrics` view)
- An analysis date is fixed at `2026-05-02`.
- `recency` = days from the analysis date to the customer's last order.
- `frequency` = `COUNT(*)` of orders.
- `monetary` = `SUM(OrderValue)`.
- Ranks use `ROW_NUMBER()`:
  - `r_rank`: lowest recency (most recent buyer) = rank 1.
  - `f_rank`: highest frequency = rank 1.
  - `m_rank`: highest spend = rank 1.

### Step 3 – Decile scores (`rfm_scores` view)
`NTILE(10) OVER (ORDER BY rank DESC)` splits customers into 10 equal groups. The best-ranked group gets score **10**, the worst gets **1**.

### Step 4 – Total score (`rfm_total_score` view)
`rfm_total_score = r_score + f_score + m_score` (min 3, max 30).

### Step 5 – Segment table (`rfm_final_segement_table`)
Applies the segment rules below and stores a BI-ready table.

## Segment Definitions

| Total RFM Score | Segment | Meaning / Recommended action |
|---|---|---|
| 28 – 30 | **VIP Champions** (labelled `VIP Campions Customers` in the SQL) | Best customers. Reward, early access, referral asks |
| 24 – 27 | **Loyal Customers** | Buy often and recently. Loyalty program, upsell |
| 20 – 23 | **Potential Loyalists** | Recent, moderate spend. Encourage repeat purchase |
| 16 – 19 | **Promising** | Newer or lighter buyers. Nurture, bundle offers |
| 12 – 15 | **Engaged** | Average activity. Keep warm with content and offers |
| 8 – 11 | **Need Attention** | Declining activity. Reminder and re-engagement |
| 4 – 7 | **At Risk** | Haven't bought in a while. Win-back campaigns |
| 3 | **Lost / In-active** | Likely churned. Last-chance offer or suppress |

## Output Tables

| Object | Type | Purpose |
|---|---|---|
| `sales.sales_2025` | Table | All 2025 orders appended |
| `sales.rfm_metrics` | View | Recency, frequency, monetary, and ranks |
| `sales.rfm_scores` | View | Decile scores (1–10) for R, F and M |
| `sales.rfm_total_score` | View | Total score per customer |
| `sales.rfm_final_segement_table` | Table | **Final BI-ready segments** |

**Final table columns:** `CustomerID, recency, frequency, monetary, r_score, f_score, m_score, rfm_total_score, rfm_segement`

## How to Run
1. Create a BigQuery dataset named `sales` in project `rfm-analysis-495110`.
2. Upload each CSV as a table (Create table → Upload → CSV → Auto-detect schema):
   - `202501.csv` → `sales202501` … `202511.csv` → `sales202511`
   - `202512.csv` → `sales202512_new`
3. Make sure `OrderDate` is stored as **DATE** (see Assumptions).
4. Open `query.sql` in the BigQuery console and run it top to bottom.
5. Check the result:
   ```sql
   SELECT rfm_segement, COUNT(*) AS customers, ROUND(SUM(monetary),2) AS revenue
   FROM `rfm-analysis-495110.sales.rfm_final_segement_table`
   GROUP BY rfm_segement
   ORDER BY customers DESC;
   ```
6. Connect your BI tool to `rfm_final_segement_table`.

## Dashboard Suggestions
- **KPI cards:** Total customers, total revenue, average order value, VIP count.
- **Bar chart:** Customers per segment.
- **Bar/donut:** Revenue share per segment.
- **Scatter:** Frequency vs. monetary, colored by segment.
- **Table:** Top 20 customers by RFM score.
- **Slicers:** Segment, score range.

## Assumptions and Limitations
- **Fixed analysis date:** Recency is measured against `2026-05-02`, not the data end (31 Dec 2025). This adds the same offset to every customer, so the ranking is unaffected, but the raw "days since last order" numbers are inflated. Use `2025-12-31` (or `CURRENT_DATE()`) if you want realistic day counts.
- **Date format:** The CSVs use `M/D/YYYY` text. BigQuery may load it as STRING, so convert it with `PARSE_DATE('%m/%d/%Y', OrderDate)` or set the column type to DATE before running Step 2.
- **Tie-breaking:** `ROW_NUMBER()` gives tied customers different ranks arbitrarily, so customers with identical recency or frequency can land in different deciles and the result may shift slightly between runs. `RANK()` or `DENSE_RANK()` or scoring directly with `NTILE` on the metric would be deterministic.
- **Small sample:** With 287 customers, each decile holds about 28–29 customers, and segment sizes can be uneven.
- **Segment thresholds** are business rules chosen manually, not statistically derived. Adjust them to your data.
- **Naming:** The SQL uses `rfm_segement` and `VIP Campions Customers` (typos). Fix these in the SQL for cleaner dashboards, or keep them for consistency with existing views.
- **December table name:** The final union uses `sales202512_new`, while the others follow `salesYYYYMM`. Keep the table names and the SQL in sync.
- **No returns or cancellations** are modeled. All orders are treated as valid revenue.

## Future Improvements
- Make the analysis date dynamic: `DATE_ADD(MAX(OrderDate), INTERVAL 1 DAY)`.
- Replace `ROW_NUMBER()` with `NTILE` directly on recency, frequency and monetary values.
- Add product-level analysis by `ProductType`.
- Track segment migration month by month.
- Automate monthly loading and refresh with scheduled queries.
- Compare against K-means clustering.

## Author
**Mahima Adhale**


## License
This project is for educational and portfolio use.