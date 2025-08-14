-- Find the total loan amount and number of loans issued per state
SELECT 
    address_state,
    COUNT(*) AS total_number_loan,
    SUM(loan_amount) AS total_loan_amount
FROM
    loan_dataset
GROUP BY address_state
ORDER BY total_number_loan DESC;

-- Find the total number of loans, average interest rate and total loan amount for each loan purpose, sorted by the highest interest rate
SELECT 
    purpose,
    COUNT(*) AS total_number_loan,
    sum(loan_amount) AS total_loan_amount,
    ROUND(AVG(int_rate), 3) AS interest_rate
FROM
    loan_dataset
GROUP BY purpose
ORDER BY interest_rate DESC;


-- Analyze total loan amount and average interest rate by loan grade
SELECT 
    sum(loan_amount) AS total_loan_amount,
    ROUND(AVG(int_rate), 2) AS avg_int_rate,
    grade
FROM
    loan_dataset
GROUP BY grade
ORDER BY grade ASC;

-- Calculate the default rate for each loan grade
SELECT 
    grade,
    COUNT(*) AS total_number_loan,
    SUM(CASE
        WHEN loan_status = 'Charged Off' THEN 1
        ELSE 0
    END) AS defaults,
    ROUND(SUM(CASE
                WHEN loan_status = 'Charged Off' THEN 1
                ELSE 0
            END) * 100 / COUNT(*),
            2) AS default_rate
FROM
    loan_dataset
GROUP BY grade
HAVING ROUND(SUM(CASE
            WHEN loan_status = 'Charged Off' THEN 1
            ELSE 0
        END) * 100 / COUNT(*),
        2) > 10
ORDER BY default_rate DESC;

-- Compare default rates between short-term loans (36 months) and long-term loans (60 months). Which term has a higher percentage of defaults?
SELECT 
    term,
    COUNT(*) AS total_loans,
    SUM(CASE
        WHEN loan_status = 'Charged Off' THEN 1
        ELSE 0
    END) AS defaults,
    SUM(CASE
        WHEN loan_status = 'Charged Off' THEN 1
        ELSE 0
    END) / COUNT(*) * 100 AS default_rate_percentage
FROM
    loan_dataset
GROUP BY term;
    
-- Which employment lengths have the highest number and rate of loan defaults?
with emp_cte as 
( select emp_length_numeric,
 count(*) as total_loan,
 sum(case when loan_status='Charged Off' then 1 else 0 end) as defaults
 from loan_dataset
 group by emp_length_numeric)
 select emp_length_numeric, total_loan, defaults, round(defaults/total_loan*100,2) as default_rate
 from emp_cte 
 order by default_rate desc;

-- Find out how loan defaults vary based on a borrower’s home ownership status 
SELECT 
    home_ownership,
    SUM(CASE
        WHEN loan_status = 'Charged Off' THEN 1
        ELSE 0
    END) AS defaults,
    ROUND(SUM(CASE
                WHEN loan_status = 'Charged Off' THEN 1
                ELSE 0
            END) / COUNT(*) * 100,
            2) AS default_rate
FROM
    loan_dataset
GROUP BY home_ownership;


-- CREATE VIEW 'Loan Purpose Summary View'
CREATE VIEW loan_purpose_summary AS
    SELECT 
        purpose,
        AVG(loan_amount) AS avg_loan_amount,
        ROUND(AVG(int_rate), 2) AS avg_int_rate
    FROM
        loan_dataset
    GROUP BY purpose;
    
  




