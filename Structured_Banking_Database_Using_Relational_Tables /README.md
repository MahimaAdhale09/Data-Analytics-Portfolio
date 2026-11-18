 Structured Banking Database Using Relational Tables

**Banking Data Analytics | MySQL 8.0 | Power BI | Data Modeling | DAX**

An end-to-end banking analytics portfolio project that explores customer, account, card, and loan records using a relational data model, SQL exploratory data analysis (EDA), and an interactive **one-page Power BI report**.

> **Project status:** An editable Power BI Project (`.pbip`) is available. The report must be opened, refreshed, and validated in Power BI Desktop before saving it as a `.pbix` file. A separate dashboard reference image is a *design mockup*, not a functioning report.

## Project objectives

- Organize multiple banking CSV files into a structured relational model.
- Inspect data quality, summarize records, and analyze banking KPIs with SQL.
- Examine customer credit scores, account balances, card types, and lending patterns.
- Build an interactive, single-page Power BI report using calculated DAX measures, charts, gauges, and slicers.
- Present useful business observations without assuming that account balances represent revenue or profit.

## Dataset overview

The project uses **six CSV files** containing **260,500 rows** in total.

| Table / CSV | Records | Key fields | Purpose |
|---|---:|---|---|
| `customers.csv` | 50,000 | `customer_id`, `first_name`, `last_name`, `email`, `city`, `credit_score`, `created_at` | Customer profile and credit score analysis |
| `accounts.csv` | 75,000 | `account_id`, `customer_id`, `account_type`, `balance_usd`, `open_date` | Accounts, product mix, and balances |
| `cards.csv` | 100,000 | `card_id`, `account_id`, `card_type`, `expiration_date` | Credit/debit card portfolio |
| `loans.csv` | 30,000 | `loan_id`, `customer_id`, `loan_amount`, `interest_rate`, `start_date` | Loans and interest rate analysis |
| `branches.csv` | 500 | `branch_id`, `branch_name`, `manager_name` | Standalone branch directory |
| `merchants.csv` | 5,000 | `merchant_id`, `merchant_name`, `city` | Standalone merchant directory |

**Data notes:** These appear to be synthetic/demo-style records. The CSVs do not contain customer age, transaction history, defaults, branch-to-customer links, or verified geographic coordinates. Account balances explicitly use USD; the source does not specify a currency for `loan_amount`.

## Relational data model

```text
customers (customer_id PK)
   ├──< accounts (account_id PK, customer_id FK)
   │       └──< cards (card_id PK, account_id FK)
   └──< loans (loan_id PK, customer_id FK)

branches (branch_id PK)     [standalone]
merchants (merchant_id PK)  [standalone]
```

- **Customers → Accounts:** one-to-many on `customer_id`.
- **Customers → Loans:** one-to-many on `customer_id`.
- **Accounts → Cards:** one-to-many on `account_id`.
- `branches` and `merchants` remain independent because the uploaded data has no keys that reliably connect them to the other tables.

## Project KPIs

| KPI | Observed value |
|---|---:|
| Total customers | 50,000 |
| Total accounts | 75,000 |
| Total cards | 100,000 |
| Total loans | 30,000 |
| Total account balances | **$7.51B USD** |
| Sum of loan amounts | **4.50B** (currency unspecified in CSV) |
| Average account balance | **$100,181.72 USD** |
| Average credit score | **574.49** |
| Average loan interest rate | **8.51%** |
| Debit cards | **50,281 (50.28%)** |
| Credit cards | **49,719 (49.72%)** |

These are descriptive totals from the supplied files, not financial-statement revenue, profit, or lending performance.

## SQL analysis performed

The MySQL EDA work covers:

- Database/table creation and CSV import
- Structure checks, row counts, distinct values, NULLs, and duplicate detection
- `MIN`, `MAX`, `SUM`, `AVG`, `COUNT`, `GROUP BY`, and `HAVING`
- Conditional segmentation with `CASE WHEN`
- Subqueries and common table expressions (`WITH`)
- `INNER JOIN`, `LEFT JOIN`, and self joins
- `ROW_NUMBER`, `RANK`, `DENSE_RANK`, `LAG`, `LEAD`, and running totals
- Date and string functions

Example MySQL query:

```sql
-- Compare account counts and average balances by account type.
SELECT
    account_type,
    COUNT(*) AS total_accounts,
    ROUND(AVG(balance_usd), 2) AS average_balance_usd
FROM accounts
GROUP BY account_type
ORDER BY total_accounts DESC;
```

## Power BI dashboard — single page

**Title:** *Structured Banking Database Using Relational Tables*

The editable Power BI project includes:

- **KPI cards:** customer, account, card and loan counts; account balance; loan amount
- **Gauges:** average credit score, average interest rate, debit-card share
- **Charts:** annual account and loan trends, account/card mix, credit score segments
- **City analysis:** categorical city charts/treemaps rather than unsupported geospatial pins
- **Slicers:** interactive filtering of report visuals
- **Detail table:** customer/account records
- **Data hierarchy:** account open date Year → Quarter → Month → Day, available in the model; assign it to a chart axis in Power BI Desktop to enable drill-down

The separate reference image suggests India/world maps, but the data lacks verified country, region, state, latitude, or longitude fields. **Geographic maps must not be interpreted as real banking locations unless validated geographic data is added.**

### Example DAX measures

```dax
Total Customers = DISTINCTCOUNT(customers[customer_id])
Total Accounts = DISTINCTCOUNT(accounts[account_id])
Total Cards = DISTINCTCOUNT(cards[card_id])
Total Loans = DISTINCTCOUNT(loans[loan_id])
Total Account Balance = SUM(accounts[balance_usd])
Total Loan Amount = SUM(loans[loan_amount])
Average Credit Score = AVERAGE(customers[credit_score])
Average Interest Rate = AVERAGE(loans[interest_rate])
```

## How to run the Power BI report

1. Download and **extract** the Power BI project ZIP.
2. Confirm the extracted `data/` folder contains all six CSVs.
3. Open `Structured_Banking_Database_Using_Relational_Tables.pbip` in **Power BI Desktop**.
4. Select **Home → Transform data → Transform data** and choose the `DataFolder` query.
5. Change its value to the **full Windows path of your extracted `data` folder** (not to a CSV filename). For example:

   ```powerquery
   let
       Source = "C:\Users\YourName\Downloads\Banking_Project\data"
   in
       Source
   ```

6. Confirm the `customers`, `accounts`, `cards`, `loans`, `branches`, and `merchants` queries show data.
7. Select **Close & Apply**, then **Refresh**.
8. Review the report, optionally apply the included purple/lavender theme, and save from Desktop as a **`.pbix`** file if needed.

> The programmatically authored `.pbip` package has not been fully validated inside Power BI Desktop. If a visual or formatting option is incompatible with your Desktop version, adjust it there before publishing.

## Suggested repository structure

```text
Structured-Banking-Database/
├── README.md
├── data/
│   ├── customers.csv
│   ├── accounts.csv
│   ├── cards.csv
│   ├── loans.csv
│   ├── branches.csv
│   └── merchants.csv
├── Structured_Banking_Database_Using_Relational_Tables.pbip
├── Structured_Banking_Database_Using_Relational_Tables.Report/
├── Structured_Banking_Database_Using_Relational_Tables.SemanticModel/
├── Structured_Banking_Lavender_Theme.json
└── REFERENCE_DESIGN_ONLY.png
```

*The tree shows the recommended GitHub structure for the latest editable one-page Power BI project. Folder names may vary across earlier ZIP versions.*

## Key insights

1. Account types are nearly evenly distributed: **Checking 25,090**, **Savings 24,962**, and **Business 24,948**.
2. **Debit (50,281)** and **Credit (49,719)** cards have an almost equal share.
3. The dataset contains approximately **$7.51B USD in account balances**, with an average of **$100.18K per account**.
4. There are **30,000 loans** with an average principal of about **150.09K** (source currency unspecified) and an average interest rate of **8.51%**.
5. The average customer credit score is approximately **574.49**, suggesting credit-score segmentation is an important analytical view.

## Future improvements

- Add validated region/state/country or coordinates before using real Power BI map visuals.
- Add a proper Date dimension for richer time intelligence.
- Introduce transactions, repayments, loan status, and branch links to support operational performance metrics.
- Validate all native visuals in Desktop and save a final `.pbix` release.

---

**Portfolio focus:** Relational database design · MySQL EDA · Data cleaning · SQL joins and window functions · Power BI dashboards · DAX · KPI reporting

**Author:**
**Mahima Adhale**