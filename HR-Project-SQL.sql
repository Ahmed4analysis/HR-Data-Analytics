use HR;
--------------------Distribtion of employees by state
SELECT 
    state, COUNT(employeeid) AS employee_count
FROM 
    hrcd
GROUP BY 
    state
ORDER BY 
    state;
--------------------Distribtion of employees by Gender
SELECT 
    gender, COUNT(employeeid) AS employee_count
FROM 
    hrcd
GROUP BY 
    gender
ORDER BY 
    gender;
--------------------Distribtion of employees by Deparment
SELECT 
    department, COUNT(employeeid) AS employee_count
FROM 
    hrcd
GROUP BY 
    department
ORDER BY 
    department;
--------------------Distribtion of employees by Position
SELECT 
    jobrole as Position, COUNT(employeeid) AS employee_count
FROM 
    hrcd
GROUP BY 
    jobrole
ORDER BY 
    jobrole;
----------------- Average Salary Range Distribution by job role
SELECT DISTINCT jobrole AS 'Job Role', avg(salary)    
FROM 
    hrcd
GROUP BY 
    jobrole;
----------------------attrition by department
SELECT 
    department,
    COUNT(employeeid) AS total_employees,
    SUM(CASE WHEN attrition = 1 THEN 1 ELSE 0 END) AS employees_left,
    CAST(SUM(CASE WHEN attrition = 1 THEN 1 ELSE 0 END) * 100 / 
        COUNT(employeeid) AS DECIMAL(5,2)) AS attrition_rate_percentage
FROM 
    hrcd
GROUP BY 
    department
ORDER BY 
    attrition_rate_percentage DESC;
----------------------attrition by gender
SELECT 
    gender,
    COUNT(employeeid) AS total_employees,
    SUM(CASE WHEN attrition = 1 THEN 1 ELSE 0 END) AS employees_left,
    CAST(SUM(CASE WHEN attrition = 1 THEN 1 ELSE 0 END) * 100 / 
        COUNT(employeeid) AS DECIMAL(5,2)) AS attrition_rate_percentage
FROM 
    hrcd
GROUP BY 
    gender
ORDER BY 
    attrition_rate_percentage DESC;
-----------------------attrition by job roles
SELECT 
    jobrole as 'job role',
    COUNT(employeeid) AS total_employees,
    SUM(CASE WHEN attrition = 1 THEN 1 ELSE 0 END) AS employees_left,
    CAST(SUM(CASE WHEN attrition = 1 THEN 1 ELSE 0 END) * 100 / 
        COUNT(employeeid) AS DECIMAL(5,2)) AS attrition_rate_percentage
FROM 
    hrcd
GROUP BY 
    jobrole
ORDER BY 
    attrition_rate_percentage DESC;
----------------------attrition by education level
SELECT 
    education as 'Education Level',
    COUNT(employeeid) AS total_employees,
    SUM(CASE WHEN attrition = 1 THEN 1 ELSE 0 END) AS employees_left,
    CAST(SUM(CASE WHEN attrition = 1 THEN 1 ELSE 0 END) * 100 / 
        COUNT(employeeid) AS DECIMAL(5,2)) AS attrition_rate_percentage
FROM 
    hrcd
GROUP BY 
    education
ORDER BY 
    education;
-------- Overall satisfaction scores employees performance rating
SELECT 
    AVG(environmentsatisfaction) AS avg_environment_satisfaction,
    AVG(jobsatisfaction) AS avg_job_satisfaction,
    AVG(relationshipsatisfaction) AS avg_relationship_satisfaction,
    AVG(worklifebalance) AS avg_worklife_balance,    
    CAST(SUM(CASE WHEN environmentsatisfaction IN (4,5) THEN 1 ELSE 0 END) * 100.0 / 
         COUNT(*) AS DECIMAL(5,2)) AS percent_high_env_satisfaction,
    CAST(SUM(CASE WHEN jobsatisfaction IN (4,5) THEN 1 ELSE 0 END) * 100.0 / 
         COUNT(*) AS DECIMAL(5,2)) AS percent_high_job_satisfaction,    
    department,
    AVG(environmentsatisfaction) AS dept_avg_env_satisfaction,
    AVG(jobsatisfaction) AS dept_avg_job_satisfaction
FROM 
    hrcd
GROUP BY 
    department
ORDER BY 
    avg_job_satisfaction DESC;
-----------------the association between gender and job role distribution
-- Pivot table view of gender distribution across roles
SELECT 
    jobrole,
    [Male],
    [Female],
    [Non-Binary],
    [Male] + [Female] + [Non-Binary] AS total_employees
FROM 
    (
    SELECT 
        jobrole,
        gender,
        COUNT(employeeid) AS employee_count
    FROM 
        hrcd
    GROUP BY 
        jobrole, gender
    ) AS SourceTable
PIVOT(
	SUM(employee_count)
    FOR gender IN ([Male], [Female], [Non-Binary])
    ) AS PivotTable
ORDER BY 
    total_employees DESC;
