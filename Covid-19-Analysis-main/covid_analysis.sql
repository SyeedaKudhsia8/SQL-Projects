
-- SQL Queries for COVID-19 India Dataset

-- Q1. State with highest average daily new cases in peak month
WITH daily_new_cases AS (
  SELECT
    state_ut,
    date,
    confirmed - LAG(confirmed) OVER (PARTITION BY state_ut ORDER BY date) AS new_cases
  FROM covid_india
),
monthly_avg AS (
  SELECT
    state_ut,
    DATE_TRUNC('month', date) AS month,
    AVG(new_cases) AS avg_new_cases
  FROM daily_new_cases
  WHERE new_cases IS NOT NULL
  GROUP BY state_ut, month
)
SELECT *
FROM monthly_avg
ORDER BY avg_new_cases DESC
LIMIT 1;

-- Q2. State with highest mortality rate
SELECT
  state_ut,
  MAX(deaths) AS total_deaths,
  MAX(confirmed) AS total_confirmed,
  ROUND((MAX(deaths)::NUMERIC / NULLIF(MAX(confirmed), 0)) * 100, 2) AS mortality_rate
FROM covid_india
GROUP BY state_ut
ORDER BY mortality_rate DESC
LIMIT 1;

-- Q3. Active cases over time nationwide
SELECT
  date,
  SUM(confirmed - cured - deaths) AS active_cases
FROM covid_india
GROUP BY date
ORDER BY date;

-- Q4. Top 5 dates with highest spike in new confirmed cases
WITH national_trend AS (
  SELECT
    date,
    SUM(confirmed) AS total_confirmed
  FROM covid_india
  GROUP BY date
),
daily_spike AS (
  SELECT
    date,
    total_confirmed - LAG(total_confirmed) OVER (ORDER BY date) AS daily_spike
  FROM national_trend
)
SELECT *
FROM daily_spike
ORDER BY daily_spike DESC
LIMIT 5;

-- Q5. States with highest recovery rate
SELECT
  state_ut,
  MAX(cured) AS total_cured,
  MAX(confirmed) AS total_confirmed,
  ROUND((MAX(cured)::NUMERIC / NULLIF(MAX(confirmed), 0)) * 100, 2) AS recovery_rate
FROM covid_india
GROUP BY state_ut
HAVING MAX(confirmed) > 1000
ORDER BY recovery_rate DESC
LIMIT 5;
