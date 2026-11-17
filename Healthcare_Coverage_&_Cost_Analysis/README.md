# 🏥 Healthcare Coverage & Cost Analysis

An end-to-end **Exploratory Data Analysis (EDA)** project on a medical insurance dataset of **100,000 policyholders**. The project covers data loading from MySQL, cleaning, visualization, outlier treatment, and business insights on what drives healthcare costs.

---

## 📌 Project Overview

Insurance companies need to understand which customer traits drive medical costs so they can price plans fairly and identify high-risk customers early. This project analyzes demographic, lifestyle, health, policy, and claims data to answer those questions.

**Objectives**
- Load and understand a large real-world style dataset using Python and MySQL
- Check data quality (missing values, duplicates, outliers)
- Explore distributions and relationships using visualizations
- Find the key factors that affect `annual_medical_cost` and `risk_score`
- Present clear, business-focused insights

---

## 🗂️ Dataset Description

| Detail | Value |
|---|---|
| Source | MySQL database (`Project` → table `medical`) |
| Records | 100,000 |
| Columns | 54 |
| Target variable | `annual_medical_cost` |

**Feature groups**

| Category | Example columns |
|---|---|
| Demographics | age, sex, region, urban_rural, income, education, marital_status, employment_status, household_size, dependents |
| Lifestyle & health | bmi, smoker, alcohol_freq, systolic_bp, diastolic_bp, ldl, hba1c |
| Medical conditions | hypertension, diabetes, asthma, copd, cardiovascular_disease, cancer_history, kidney_disease, liver_disease, arthritis, mental_health, chronic_count |
| Healthcare usage | visits_last_year, hospitalizations_last_3yrs, days_hospitalized_last_3yrs, medication_count |
| Procedures | proc_imaging_count, proc_surgery_count, proc_physio_count, proc_consult_count, proc_lab_count |
| Policy details | plan_type, network_tier, deductible, copay, policy_term_years, policy_changes_last_2yrs, provider_quality |
| Cost & claims | annual_premium, monthly_premium, claims_count, avg_claim_amount, total_claims_paid, annual_medical_cost |
| Risk | risk_score, is_high_risk, had_major_procedure |

---

## 🛠️ Tools & Technologies

- **Python:** Pandas, NumPy
- **Visualization:** Matplotlib, Seaborn
- **Database:** MySQL Workbench with `mysql-connector-python`
- **Environment:** Jupyter Notebook (Anaconda)

---

## 🔄 Project Workflow

### 1. Database Connection
Connected MySQL Workbench to Jupyter Notebook using `mysql-connector-python` and loaded the `medical` table into a Pandas DataFrame.

### 2. Initial Data Exploration
Checked shape, columns, data types, `info()`, `describe()`, categorical summary, and unique value counts.

### 3. Data Preparation
Converted 12 binary columns (0/1) to readable labels (**No / Yes**) using `map()`, for example hypertension, diabetes, asthma, copd, is_high_risk.

### 4. Data Quality Checks
- **Missing values:** `isna().sum()` returned 0 for all 54 columns. **There are no null values present in the dataset.**
- **Duplicates:** `duplicated().sum()` returned 0. **There are no duplicate records present in the dataset.**

### 5. Univariate Analysis
- Histograms with KDE for age, BMI, income, and annual medical cost
- Bar plots for all binary health conditions
- Pie charts for region, sex, marital status, and urban/rural

### 6. Bivariate Analysis
- Group-wise average cost by diabetes, sex, smoker, and risk level
- Age group (Young / Middle / Old) vs smoker, diabetes, and gender
- Scatter plots of HbA1c, LDL, systolic BP, visits, and income against medical cost
- Pair plot of age, income, BMI, and annual medical cost

### 7. Correlation Analysis
Heatmap showing the correlation of all numeric features with `annual_medical_cost`.

### 8. Outlier Detection & Treatment
- Detected outliers using boxplots for all numeric columns
- Treated outliers using the **IQR method with winsorization** (capping values at Q1 − 1.5×IQR and Q3 + 1.5×IQR) on 13 columns, including income, BMI, deductible, premium, and claim amounts
- Saved the cleaned data as `cleaned_medical_insurence.csv`

### 9. Business Insights
Answered **39 business questions** using aggregations and visualizations.

---

## 📊 Key Insights

**Customer profile**
- Average policyholder age is about **47.5 years**
- Gender split is balanced: **Female 49.2%, Male 48.8%, Other 2.0%**
- **South** is the largest region (28,029 customers), followed by North and East
- **PPO (35,167)** and **HMO (34,723)** are the most preferred plan types
- About **36.8%** of customers are marked **high risk**
- **69.7%** are non-smokers, **18.2%** former smokers, **12.1%** current smokers
- Average BMI is about **27**, and the average annual medical cost is about **₹/$2,726**

**What drives cost and risk**
- **Chronic conditions are a major cost driver:** average cost rises from about **2,086** (no chronic condition) to about **5,022** (4 conditions)
- **Diabetes increases cost sharply:** about **4,100** for diabetic customers vs about **2,900** for non-diabetic
- **Smoking matters:** current smokers average about **3,623** vs **2,537** for non-smokers
- **High-risk customers file almost twice the claims:** 2.33 vs 1.21 on average
- **Age and risk score have a strong positive correlation (0.72):** risk increases with age

**Factors with little or no effect**
- Region, urban/rural, gender, marital status, and plan type show almost the same average cost
- BMI has only a weak correlation with cost (0.05) and almost none with HbA1c
- Education level has no meaningful effect on risk score

> 💡 **Takeaway for insurers:** Chronic condition count, diabetes, smoking status, and age are far better pricing indicators than region, gender, or plan type.

---

## 📁 Repository Structure

```
Medical-Insurance-EDA/
│
├── EDA_FINAL.ipynb                    # Main analysis notebook
├── cleaned_medical_insurence.csv      # Cleaned dataset after outlier treatment
└── README.md                          # Project documentation
```

---

## ▶️ How to Run

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/Medical-Insurance-EDA.git
   cd Medical-Insurance-EDA
   ```

2. **Install the required libraries**
   ```bash
   pip install numpy pandas matplotlib seaborn mysql-connector-python jupyter
   ```

3. **Set up the data**
   - Load the dataset into a MySQL database named `Project` in a table named `medical`, **or**
   - Skip MySQL and read the CSV directly:
     ```python
     mi = pd.read_csv('cleaned_medical_insurence.csv')
     ```

4. **Update the database credentials** in the connection cell (use your own username and password, and never upload real credentials to GitHub).

5. **Launch the notebook**
   ```bash
   jupyter notebook EDA_FINAL.ipynb
   ```

---

## ✅ Skills Demonstrated

- SQL to Python data integration
- Data cleaning and quality checks
- Univariate, bivariate, and multivariate analysis
- Outlier detection and treatment (IQR + winsorization)
- Data visualization and storytelling
- Translating data into business insights

---

## 🚀 Future Improvements

- Build a Power BI / Tableau dashboard from the cleaned data
- Train regression models to predict `annual_medical_cost`
- Perform feature importance analysis
- Build a classification model to predict `is_high_risk`

---

## 👩‍💻 Author

**Mahima Adhale**
Aspiring Data Scientist / Data Analyst

- 📧 Email: adhalemahima09@gmail.com
- 💻 GitHub: (https://github.com/MahimaAdhale09)

---

⭐ If you found this project useful, consider giving it a star!