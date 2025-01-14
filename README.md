# HR-Dashboard-MySQL-PowerBI

![image](https://user-images.githubusercontent.com/56026296/229609893-b7b1f261-5941-45af-8322-1ccb2535d36b.png)

## Data Used

**Data** - HR Data with over 22000 rows from the year 2000 to 2020.

**Data Cleaning & Analysis** - MySQL Workbench

**Data Visualization** - PowerBI

## Questions

1. What is the gender breakdown of employees in the company?
2. What is the race/ethnicity breakdown of employees in the company?
3. What is the age distribution of employees in the company?
4. How many employees work at headquarters versus remote locations?
5. What is the average length of employment for employees who have been terminated?
6. How does the gender distribution vary across departments and job titles?
7. What is the distribution of job titles across the company?
8. Which department has the highest turnover rate?
9. What is the distribution of employees across locations by state?
10. How has the company's employee count changed over time based on hire and term dates?
11. What is the tenure distribution for each department?

##Solutions
-- QUESTIONS
SELECT * FROM `human resources`;
-- 1. What is the gender breakdown of employees in the company?
SELECT 
    gender, COUNT(gender)
FROM
    `human resources`
WHERE
    termdate = '0000-00-00'
GROUP BY gender;

-- 2. What is the race/ethnicity breakdown of employees in the company?

SELECT 
    race, COUNT(race) AS ETHNICITY_count
FROM
    `human resources`
GROUP BY race
ORDER BY ETHNICITY_count DESC;

-- 3. What is the age distribution of employees in the company?

SELECT 
    CASE
        WHEN age >= 20 AND age <= 30 THEN '20-30'
        WHEN age > 30 AND age <= 40 THEN '31-40'
        WHEN age > 40 AND age <= 50 THEN '41-50'
        ELSE '50+'
    END AS age_group,
    gender,
    COUNT(age)
FROM
    `human resources`
GROUP BY age_group , gender
ORDER BY gender;

-- 4. How many employees work at headquarters versus remote locations?
SELECT 
    location, COUNT(location)
FROM
    `human resources`
GROUP BY location;

-- 5. How does the gender distribution vary across departments and job titles?

SELECT 
    department, gender, COUNT(gender)
FROM
    `human resources`
GROUP BY department , gender
ORDER BY gender;

-- 7. What is the distribution of job titles across the company?
SELECT 
    jobtitle, COUNT(jobtitle)
FROM
    `human resources`
GROUP BY jobtitle
ORDER BY jobtitle DESC;

-- 8. Which department has the highest turnover rate?

SELECT 
    department,
    COUNT(CASE WHEN termdate IS NOT NULL THEN 1 END) AS employees_left,
    COUNT(*) AS total_employees,
    ROUND(
        (COUNT(CASE WHEN termdate IS NOT NULL THEN 1 END) * 100.0) / COUNT(*),
        2
    ) AS turnover_rate
FROM `human resources`
GROUP BY department
ORDER BY turnover_rate DESC
LIMIT 1;

-- 9. What is the distribution of employees across locations by city and state?

SELECT 
    location_city, location_state, COUNT(location_city) AS COUNT
FROM
    `human resources`
GROUP BY location_state , location_city
ORDER BY COUNT DESC;

-- 10. How has the company's employee count changed over time based on hire and term dates?
SELECT 
    event_date,
    SUM(hired_count) OVER (ORDER BY event_date) - SUM(terminated_count) OVER (ORDER BY event_date) AS cumulative_employee_count
FROM (
    SELECT 
        hire_date AS event_date,
        COUNT(*) AS hired_count,
        0 AS terminated_count
    FROM `human resources`
    WHERE hire_date IS NOT NULL
    GROUP BY hire_date

    UNION ALL

    SELECT 
        termdate AS event_date,
        0 AS hired_count,
        COUNT(*) AS terminated_count
    FROM `human resources`
    WHERE termdate IS NOT NULL
    GROUP BY termdate
) events
ORDER BY event_date;

-- 11. What is the tenure distribution for each department?

SELECT 
    department,
    AVG(DATEDIFF(termdate, hire_date) / 365) AS AVG_TENURE
FROM
    `human resources`
WHERE
    termdate <= CURDATE()
        AND termdate <> '0000-00-00'
GROUP BY department;

## Summary of Findings
 - There are more male employees
 - White race is the most dominant while Native Hawaiian and American Indian are the least dominant.
 - The youngest employee is 20 years old and the oldest is 57 years old
 - 5 age groups were created (18-24, 25-34, 35-44, 45-54, 55-64). A large number of employees were between 25-34 followed by 35-44 while the smallest group was 55-64.
 - A large number of employees work at the headquarters versus remotely.
 - The average length of employment for terminated employees is around 7 years.
 - The gender distribution across departments is fairly balanced but there are generally more male than female employees.
 - The Marketing department has the highest turnover rate followed by Training. The least turn over rate are in the Research and development, Support and Legal departments.
 - A large number of employees come from the state of Ohio.
 - The net change in employees has increased over the years.
- The average tenure for each department is about 8 years with Legal and Auditing having the highest and Services, Sales and Marketing having the lowest.

## Limitations

- Some records had negative ages and these were excluded during querying(967 records). Ages used were 18 years and above.
- Some termdates were far into the future and were not included in the analysis(1599 records). The only term dates used were those less than or equal to the current date.
