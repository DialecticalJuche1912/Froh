CREATE TABLE Employment Stats 
	REF_DATE VARCHAR(255), 
	GEO VARCHAR(255), 
	DGUID INT,
	Stats VARCHAR(255),
	UOM VARCHAR(255), 
	UOM_ID VARCHAR(255),
	SCALAR_FACTOR VARCHAR(255),
	SCALAR_ID INT,
	VECTOR VARCHAR(255),
	COORDINATE FLOAT PRIMARY KEY, 
	VALUE1 FLOAT,
	STATUS1 CHAR(1),
	SYMBOL NULL, 
	TERMINATED1 NULL, 
	DECIMALS INT

LOAD DATA INFILE 'https://raw.githubusercontent.com/DialecticalJuche1912/Employment-stats/main/employment%20stats%202015-2023.csv'
  INTO TABLE Employment Stats
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Create a new table with the desired columns
CREATE TABLE Employment_Stats_Updated (
    REF_DATE VARCHAR(255),
    GEO VARCHAR(255),
    Stats VARCHAR(255),
    UOM VARCHAR(255),
    COORDINATE FLOAT PRIMARY KEY,
    VALUE1 FLOAT
);

-- Copy the data from the original table to the new table
INSERT INTO Employment_Stats_Updated (REF_DATE, GEO, Stats, UOM, COORDINATE, VALUE1)
SELECT REF_DATE, GEO, Stats, UOM, COORDINATE, VALUE1
FROM Employment_Stats;

-- Drop the original table
DROP TABLE Employment_Stats;

-- Rename the new table to the original table name
ALTER TABLE Employment_Stats_Updated RENAME TO Employment_Stats;

CREATE TABLE Employment Stats 
	REF_DATE VARCHAR(255), 
	GEO VARCHAR(255), 
	DGUID INT,
	Stats VARCHAR(255),
	UOM VARCHAR(255), 
	UOM_ID VARCHAR(255),
	SCALAR_FACTOR VARCHAR(255),
	SCALAR_ID INT,
	VECTOR VARCHAR(255),
	COORDINATE FLOAT PRIMARY KEY, 
	VALUE1 FLOAT,
	STATUS1 CHAR(1),
	SYMBOL NULL, 
	TERMINATED1 NULL, 
	DECIMALS INT

LOAD DATA INFILE 'https://raw.githubusercontent.com/DialecticalJuche1912/Employment-stats/main/employment%20stats%202015-2023.csv'
  INTO TABLE Employment Stats
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Create a new table with the desired columns
CREATE TABLE Employment_Stats_Updated (
    REF_DATE VARCHAR(255),
    GEO VARCHAR(255),
    Stats VARCHAR(255),
    UOM VARCHAR(255),
    COORDINATE FLOAT PRIMARY KEY,
    VALUE1 FLOAT
);

-- Copy the data from the original table to the new table
INSERT INTO Employment_Stats_Updated (REF_DATE, GEO, Stats, UOM, COORDINATE, VALUE1)
SELECT REF_DATE, GEO, Stats, UOM, COORDINATE, VALUE1
FROM Employment_Stats;

-- Drop the original table
DROP TABLE Employment_Stats;

-- Rename the new table to the original table name
ALTER TABLE Employment_Stats_Updated RENAME TO Employment_Stats;

-- Querying:
-- Job vacancies by province (bar chart), excluding "Canada":
SELECT REF_DATE,
       GEO,
       AVG(CASE WHEN Stats = 'Job vacancies' THEN VALUE1 ELSE 0 END) as Average_Job_Vacancies
FROM Employment_Stats
WHERE GEO <> 'Canada'
GROUP BY REF_DATE, GEO
ORDER BY REF_DATE, GEO;

-- Payroll employees by province (bar chart), excluding "Canada":
SELECT REF_DATE,
       GEO,
       AVG(CASE WHEN Stats = 'Payroll Employees' THEN VALUE1 ELSE 0 END) as Average_Payroll_Employees
FROM Employment_Stats
WHERE GEO <> 'Canada'
GROUP BY REF_DATE, GEO
ORDER BY REF_DATE, GEO;

-- Job vacancy rate by province (bar chart), excluding "Canada":
SELECT REF_DATE,
       GEO,
       AVG(CASE WHEN Stats = 'Job Vacancy rate' AND UOM = 'Percent' THEN VALUE1 ELSE 0 END) as Average_Job_Vacancy_Rate
FROM Employment_Stats
WHERE GEO <> 'Canada'
GROUP BY REF_DATE, GEO
ORDER BY REF_DATE, GEO;

-- Impact of COVID-19 on job vacancies (line chart), after March 2020:
SELECT REF_DATE,
       GEO,
       VALUE1 as Job_Vacancies
FROM Employment_Stats
WHERE Stats = 'Job vacancies'
  AND REF_DATE >= '2020-03'
ORDER BY REF_DATE, GEO;

-- Impact of 2022-2023 tech layoffs on technology jobs in Ontario (line chart), starting from October 2022:
SELECT REF_DATE,
       GEO,
       VALUE1 as Payroll_Employees
FROM Employment_Stats
WHERE Stats = 'Payroll Employees'
  AND REF_DATE >= '2022-10'
  AND GEO = 'Ontario'
ORDER BY REF_DATE;

-- Job vacancies by province and year (stacked column chart), excluding "Canada":
SELECT YEAR(REF_DATE) as Year,
       GEO,
       AVG(CASE WHEN Stats = 'Job vacancies' THEN VALUE1 ELSE 0 END) as Average_Job_Vacancies
FROM Employment_Stats
WHERE GEO <> 'Canada'
GROUP BY Year, GEO
ORDER BY Year, GEO;

-- Job vacancies vs. payroll employees by year (scatter plot), only including columns where GEO says "Canada":
SELECT YEAR(REF_DATE) as Year,
       AVG(CASE WHEN Stats = 'Job vacancies' THEN VALUE1 ELSE 0 END) as Average_Job_Vacancies,
       AVG(CASE WHEN Stats = 'Payroll Employees' THEN VALUE1 ELSE 0 END) as Average_Payroll_Employees
FROM Employment_Stats
WHERE GEO = 'Canada'
GROUP BY Year
ORDER BY Year;

-- Year-over-year change in job vacancies (waterfall chart), only including columns where GEO says "Canada":
SELECT YEAR(REF_DATE) as Year,
       AVG(CASE WHEN Stats = 'Job vacancies' THEN VALUE1 ELSE 0 END) as Average_Job_Vacancies
FROM Employment_Stats
WHERE GEO = 'Canada'
GROUP BY Year
ORDER BY Year;

-- Job vacancy rate distribution in British Columbia (box and whisker chart), only including columns where GEO says "British Columbia":
SELECT YEAR(REF_DATE) as Year,
       AVG(CASE WHEN Stats = 'Job Vacancy rate' THEN VALUE1 ELSE 0 END) as Average_Job_Vacancy_Rate
FROM Employment_Stats
WHERE GEO = 'British Columbia'
GROUP BY Year
ORDER BY Year;

-- Nationwide job vacancies and payroll employees by year (stacked area chart): This query calculates the average job vacancies and payroll employees per year for Canada.
SELECT YEAR(REF_DATE) as Year,
       AVG(CASE WHEN Stats = 'Job vacancies' THEN VALUE1 ELSE 0 END) as Average_Job_Vacancies,
       AVG(CASE WHEN Stats = 'Payroll Employees' THEN VALUE1 ELSE 0 END) as Average_Payroll_Employees
FROM Employment_Stats
WHERE GEO = 'Canada'
GROUP BY Year
ORDER BY Year;

-- Nationwide average job vacancy rate by year (line chart): This query calculates the average job vacancy rate per year for Canada.
SELECT YEAR(REF_DATE) as Year,
       AVG(CASE WHEN Stats = 'Job vacancy rate' THEN VALUE1 ELSE 0 END) as Average_Job_Vacancy_Rate
FROM Employment_Stats
WHERE GEO = 'Canada'
GROUP BY Year
ORDER BY Year;

-- Nationwide job market trends: job vacancies, payroll employees, and job vacancy rate (combination chart): This query calculates the average job vacancies, payroll employees, and job vacancy rate per year for Canada.
SELECT YEAR(REF_DATE) as Year,
       AVG(CASE WHEN Stats = 'Job vacancies' THEN VALUE1 ELSE 0 END) as Average_Job_Vacancies,
       AVG(CASE WHEN Stats = 'Payroll Employees' THEN VALUE1 ELSE 0 END) as Average_Payroll_Employees,
       AVG(CASE WHEN Stats = 'Job vacancy rate' THEN VALUE1 ELSE 0 END) as Average_Job_Vacancy_Rate
FROM Employment_Stats
WHERE GEO = 'Canada'
GROUP BY Year
ORDER BY Year;

-- Average Job Vacancy by Province for 2020 2021 and 2022 in order to show contrasts
-- Average job vacancy rate by province for 2020 (map)
SELECT GEO, AVG(VALUE1) as avg_job_vacancy_rate
FROM Employment_Stats
WHERE STATS = 'Job Vacancy rate' AND GEO != 'Canada' AND YEAR(STR_TO_DATE(REF_DATE, '%Y-%m')) = 2020
GROUP BY GEO
ORDER BY GEO;
-- Average job vacancy rate by province for 2021 (map)
SELECT GEO, AVG(VALUE1) as avg_job_vacancy_rate
FROM Employment_Stats
WHERE STATS = 'Job Vacancy rate' AND GEO != 'Canada' AND YEAR(STR_TO_DATE(REF_DATE, '%Y-%m')) = 2021
GROUP BY GEO
ORDER BY GEO;
-- Average job vacancy rate by province for 2022 (map)
SELECT GEO, AVG(VALUE1) as avg_job_vacancy_rate
FROM Employment_Stats
WHERE STATS = 'Job Vacancy rate' AND GEO != 'Canada' AND YEAR(STR_TO_DATE(REF_DATE, '%Y-%m')) = 2022
GROUP BY GEO
ORDER BY GEO;
-- Each of these queries filters the data based on the specific year 
-- (2020, 2021, or 2022) and calculates the average job vacancy rate for 
-- each province in that year. The YEAR(STR_TO_DATE(REF_DATE, '%Y-%m')) 
-- function is used to extract the year from the REF_DATE column, and the WHERE 
-- clause filters the rows accordingly. The GROUP BY and ORDER BY clauses are 
-- used to group the results by province and order them accordingly.