# 📊 Data Analytics Portfolio

Hi, I'm **Mahima Adhale** 👋
I turn raw data into clear insights using **SQL, Power BI, BigQuery and Python**. This repository collects my end-to-end analytics projects, from data cleaning and modelling to dashboards and business recommendations.

---

## 🧰 Skills & Tools

| Area | Tools |
|---|---|
| **Languages** | SQL, Python (Pandas, NumPy), DAX |
| **BI & Visualization** | Power BI, [Tableau / Looker Studio] |
| **Databases / Cloud** | Google BigQuery, [MySQL / PostgreSQL] |
| **Data Preparation** | Power Query, Excel, CSV/ETL workflows |
| **Concepts** | Data modelling, RFM analysis, KPI design, data cleaning, dashboard storytelling |

---

## 📁 Projects

### 1. 🧮 RFM Analysis – Customer Segmentation using SQL
**Folder:** `RFM_Analysis_(Customer_Segmentation_using_...)`

**Goal:** Group customers by buying behaviour so marketing can target the right people (reward VIPs, win back at-risk customers).

**What I did**
- Loaded 12 monthly sales files (994 orders, 287 customers) into Google BigQuery and appended them into one table.
- Calculated **Recency, Frequency and Monetary** values per customer.
- Ranked customers and scored each metric in deciles (1–10) using `ROW_NUMBER()` and `NTILE(10)`.
- Added the three scores into a total (3–30) and assigned 8 segments, from *VIP Champions* to *Lost/In-active*.
- Published a BI-ready segment table for dashboarding.

**Skills used:** BigQuery SQL, CTEs, window functions, views, customer segmentation

**Key outputs:** Segment table, segment-wise customer and revenue split, recommended action per segment

---

### 2. 🏥 Healthcare Coverage & Cost Analysis
**Folder:** `Healthcare_Coverage_&_Cost_Analysis`

**Goal:** [One line, e.g. "Analyze how healthcare coverage relates to patient costs to find where costs are highest."]

**What I did**
- [Cleaned and prepared the dataset (describe source and size)]
- [Analyzed coverage vs. cost by patient group / provider / region]
- [Built KPIs and visuals (e.g. average cost per patient, coverage %)]
- [Key finding or recommendation]

**Skills used:** [SQL / Power BI / Python, etc.]

---

### 3. 🏦 Structured Banking Database Using Relational Tables
**Folder:** `Structured_Banking_Database_Using_Relational...`

**Goal:** Design and analyze a relational banking database and present it as an executive-style Power BI dashboard.

**What I did**
- Worked with relational tables: `customers`, `loans`, `cards`, `merchants` and `branches` (50K customers, 30K loans, 100K cards).
- Built the data model with primary/foreign key relationships and a date table for time analysis.
- Wrote DAX measures: Total Customers, Total Loan Amount ($4.50B), Average Credit Score (574), Average Interest Rate (8.51%), Debit Card Share (50.3%) and year-over-year %.
- Created credit-score segments (Poor to Excellent) and loan-size bands.
- Designed KPI cards, gauges, trend charts, donut charts and a customer detail table, with year, city, card type and loan size slicers.

**Skills used:** Power BI, DAX, data modelling, Power Query, dashboard design

---

## 📌 Project Summary

| # | Project | Tools | Focus |
|---|---|---|---|
| 1 | RFM Customer Segmentation | BigQuery SQL | Customer analytics |
| 2 | Healthcare Coverage & Cost Analysis | [Tools] | Healthcare analytics |
| 3 | Structured Banking Database | Power BI, DAX | Banking / BI dashboarding |

---

## 🗂️ Repository Structure

```
Data-Analytics-Portfolio/
├── RFM_Analysis_(Customer_Segmentation_using_SQL)/
├── Healthcare_Coverage_&_Cost_Analysis/
├── Structured_Banking_Database_Using_Relational_Tables/
├── LICENSE
└── README.md
```

Each project folder contains its own data, queries/notebooks, dashboard files and a detailed README.

---

## 🚀 How to Explore
1. Open a project folder from the list above.
2. Read its README for the problem, method and results.
3. Run the SQL scripts or open the dashboard files to reproduce the analysis.

---

## 📬 Contact
Open to data analyst opportunities and collaborations.

- 📧 Email: adhalemahima09@gmail.com
- 🐙 GitHub: https://github.com/MahimaAdhale09

---

⭐ If you find this useful, feel free to star the repo!

## 📄 License
Released under the terms in the [LICENSE](LICENSE) file.