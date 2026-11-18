CREATE DATABASE banking;
USE banking; 

-- Display the first 10 customers.
SELECT * FROM customers LIMIT 10;

-- Display the first 10 accounts.
SELECT * FROM accounts LIMIT 10;

-- Display the first 10 cards.
SELECT * FROM cards LIMIT 10;

-- Display the first 10 loans.
SELECT * FROM loans LIMIT 10;

-- Display the first 10 branches.
SELECT * FROM branches LIMIT 10;

-- Display the first 10 merchants.
SELECT * FROM merchants LIMIT 10;

-- Count records in each table.
SELECT 'customers' AS table_name, COUNT(*) AS total FROM customers
UNION ALL
SELECT 'accounts', COUNT(*) FROM accounts
UNION ALL
SELECT 'cards', COUNT(*) FROM cards
UNION ALL
SELECT 'loans', COUNT(*) FROM loans
UNION ALL
SELECT 'branches', COUNT(*) FROM branches
UNION ALL
SELECT 'merchants', COUNT(*) FROM merchants;

-- Understand the table structures
-- Check the customers table structure and data types.
DESCRIBE customers;

-- Check the accounts table structure and data types.
DESCRIBE accounts;

-- Check the cards table structure and data types.
DESCRIBE cards;

-- Check the loans table structure and data types.
DESCRIBE loans;

-- Check the branches table structure and data types.
DESCRIBE branches;

-- Check the merchants table structure and data types.
DESCRIBE merchants;

-- Check distinct values
-- Find the number of account types.
SELECT COUNT(DISTINCT account_type) AS total_types
FROM accounts;

-- Display all account types.
SELECT DISTINCT account_type FROM accounts;

-- Find the different card types.
SELECT DISTINCT card_type FROM cards;

-- Count unique customer cities.
SELECT COUNT(DISTINCT city) AS unique_cities
FROM customers;

-- Count unique merchant cities.
SELECT COUNT(DISTINCT city) AS unique_cities
FROM merchants;

-- Count unique branch names.
SELECT COUNT(DISTINCT branch_name) AS unique_branches
FROM branches;

-- Check NULL and missing values
-- Count missing values in every customers column.
SELECT
    SUM(customer_id IS NULL OR TRIM(customer_id) = '') AS customer_id_nulls,
    SUM(first_name IS NULL OR TRIM(first_name) = '') AS first_name_nulls,
    SUM(last_name IS NULL OR TRIM(last_name) = '') AS last_name_nulls,
    SUM(email IS NULL OR TRIM(email) = '') AS email_nulls,
    SUM(city IS NULL OR TRIM(city) = '') AS city_nulls,
    SUM(credit_score IS NULL) AS credit_score_nulls,
    SUM(created_at IS NULL) AS created_at_nulls
FROM customers;

-- Count missing values in every accounts column.
SELECT
    SUM(account_id IS NULL OR TRIM(account_id) = '') AS account_id_nulls,
    SUM(customer_id IS NULL OR TRIM(customer_id) = '') AS customer_id_nulls,
    SUM(account_type IS NULL OR TRIM(account_type) = '') AS account_type_nulls,
    SUM(balance_usd IS NULL) AS balance_nulls,
    SUM(open_date IS NULL) AS open_date_nulls
FROM accounts;

-- Count missing values in every cards column.
SELECT
    SUM(card_id IS NULL OR TRIM(card_id) = '') AS card_id_nulls,
    SUM(account_id IS NULL OR TRIM(account_id) = '') AS account_id_nulls,
    SUM(card_type IS NULL OR TRIM(card_type) = '') AS card_type_nulls,
    SUM(expiration_date IS NULL) AS expiration_date_nulls
FROM cards;

-- Count missing values in every loans column.
SELECT
    SUM(loan_id IS NULL OR TRIM(loan_id) = '') AS loan_id_nulls,
    SUM(customer_id IS NULL OR TRIM(customer_id) = '') AS customer_id_nulls,
    SUM(loan_amount IS NULL) AS loan_amount_nulls,
    SUM(interest_rate IS NULL) AS interest_rate_nulls,
    SUM(start_date IS NULL) AS start_date_nulls
FROM loans;

-- Count missing values in every branches column.
SELECT
    SUM(branch_id IS NULL OR TRIM(branch_id) = '') AS branch_id_nulls,
    SUM(branch_name IS NULL OR TRIM(branch_name) = '') AS branch_name_nulls,
    SUM(manager_name IS NULL OR TRIM(manager_name) = '') AS manager_name_nulls
FROM branches;

-- Count missing values in every merchants column.
SELECT
    SUM(merchant_id IS NULL OR TRIM(merchant_id) = '') AS merchant_id_nulls,
    SUM(merchant_name IS NULL OR TRIM(merchant_name) = '') AS merchant_name_nulls,
    SUM(city IS NULL OR TRIM(city) = '') AS city_nulls
FROM merchants;

-- Check duplicate records

-- Find duplicate customer IDs.
SELECT customer_id, COUNT(*) AS total
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Find duplicate account IDs.
SELECT account_id, COUNT(*) AS total
FROM accounts
GROUP BY account_id
HAVING COUNT(*) > 1;

-- Find duplicate card IDs.
SELECT card_id, COUNT(*) AS total
FROM cards
GROUP BY card_id
HAVING COUNT(*) > 1;

-- Find duplicate loan IDs.
SELECT loan_id, COUNT(*) AS total
FROM loans
GROUP BY loan_id
HAVING COUNT(*) > 1;

-- Find duplicate branch IDs.
SELECT branch_id, COUNT(*) AS total
FROM branches
GROUP BY branch_id
HAVING COUNT(*) > 1;

-- Find duplicate merchant IDs.
SELECT merchant_id, COUNT(*) AS total
FROM merchants
GROUP BY merchant_id
HAVING COUNT(*) > 1;

-- Numeric statistic
-- Calculate account balance statistics.
SELECT
    COUNT(*) AS total_accounts,
    MIN(balance_usd) AS min_balance,
    MAX(balance_usd) AS max_balance,
    ROUND(AVG(balance_usd), 2) AS avg_balance,
    ROUND(SUM(balance_usd), 2) AS total_balance
FROM accounts;

-- Calculate customer credit score statistics.
SELECT
    COUNT(*) AS total_customers,
    MIN(credit_score) AS min_score,
    MAX(credit_score) AS max_score,
    ROUND(AVG(credit_score), 2) AS avg_score
FROM customers;

-- Calculate loan amount and interest rate statistics.
SELECT
    COUNT(*) AS total_loans,
    MIN(loan_amount) AS min_loan,
    MAX(loan_amount) AS max_loan,
    ROUND(AVG(loan_amount), 2) AS avg_loan,
    ROUND(SUM(loan_amount), 2) AS total_loan_amount,
    MIN(interest_rate) AS min_rate,
    MAX(interest_rate) AS max_rate,
    ROUND(AVG(interest_rate), 2) AS avg_rate
FROM loans;

-- Data cleaning
-- Count customer names containing extra surrounding spaces.
SELECT
    SUM(first_name <> TRIM(first_name)) AS first_name_issues,
    SUM(last_name <> TRIM(last_name)) AS last_name_issues
FROM customers;

-- Check account type labels after normalization.
SELECT DISTINCT TRIM(account_type) AS clean_account_type
FROM accounts;

-- Check standardized card type labels.
SELECT DISTINCT LOWER(TRIM(card_type)) AS clean_card_type
FROM cards;

-- Display cleaned customer text and handle empty city values.
SELECT
    customer_id,
    TRIM(first_name) AS first_name,
    TRIM(last_name) AS last_name,
    LOWER(TRIM(email)) AS email,
    COALESCE(NULLIF(TRIM(city), ''), 'Unknown') AS city
FROM customers
LIMIT 10;

-- Basic relationship analysis using GROUP BY
-- Compare average balances for different account types.
SELECT
    account_type,
    ROUND(AVG(balance_usd), 2) AS avg_balance
FROM accounts
GROUP BY account_type;

-- Compare average loan interest rates across credit score groups.
SELECT
    CASE
        WHEN c.credit_score < 580 THEN 'Low'
        WHEN c.credit_score < 670 THEN 'Fair'
        WHEN c.credit_score < 740 THEN 'Good'
        ELSE 'Very Good / Excellent'
    END AS score_group,
    ROUND(AVG(l.interest_rate), 2) AS avg_interest_rate
FROM loans l
JOIN customers c ON l.customer_id = c.customer_id
GROUP BY score_group;

-- Compare average customer scores across account types.
SELECT
    a.account_type,
    ROUND(AVG(c.credit_score), 2) AS avg_credit_score
FROM accounts a
JOIN customers c ON a.customer_id = c.customer_id
GROUP BY a.account_type;

-- 30 SQL Business Insights

-- Insight 1 | Which account type has the most accounts?
-- Count accounts by type from highest to lowest.
SELECT account_type, COUNT(*) AS total_accounts
FROM accounts
GROUP BY account_type
ORDER BY total_accounts DESC;
-- Insight: Checking accounts lead with 25,090 accounts, slightly ahead of Savings and Business accounts.

-- Which account types have over 20,000 accounts, and what is their average balance?
-- Find large account categories and their average balances.
SELECT
    account_type,
    COUNT(*) AS total_accounts,
    ROUND(AVG(balance_usd), 2) AS avg_balance
FROM accounts
GROUP BY account_type
HAVING COUNT(*) > 20000
ORDER BY avg_balance DESC;
-- Insight: All three account types meet the threshold, and Savings accounts have the highest average balance.

-- Insight 3 | Which customer cities have at least 20 customers?

SELECT city, COUNT(*) AS total_customers
FROM customers
GROUP BY city
HAVING COUNT(*) >= 20
ORDER BY total_customers DESC
LIMIT 10;
-- Insight: South Michael has the most customers (51), helping identify the largest customer concentrations in this dataset.

-- Insight 5 | How are customers distributed across credit score groups?
-- Categorize customers based on their credit scores.
SELECT
    CASE
        WHEN credit_score < 580 THEN 'Poor'
        WHEN credit_score < 670 THEN 'Fair'
        WHEN credit_score < 740 THEN 'Good'
        WHEN credit_score < 800 THEN 'Very Good'
        ELSE 'Excellent'
    END AS score_group,
    COUNT(*) AS total_customers
FROM customers
GROUP BY score_group
ORDER BY total_customers DESC;

-- Insight: The largest group is below 580, with 25,414 customers, highlighting the importance of analyzing lower credit-score segments.


-- Insight 9 | How many customers have at least one loan?
-- Count customers whose IDs appear in the loans table.
SELECT COUNT(*) AS customers_with_loans
FROM customers
WHERE customer_id IN
    (SELECT customer_id FROM loans);
    
-- Insight: 22,586 customers have at least one loan, providing a measure of loan participation.

-- Insight 11 | How many customers have a credit score of at least 750?
-- Create a temporary result containing high-score customers.
WITH high_scores AS (
    SELECT *
    FROM customers
    WHERE credit_score >= 750
)
SELECT COUNT(*) AS total_customers
FROM high_scores;
-- Insight: 9,039 customers have scores of 750 or higher, representing a useful segment for further credit analysis.




