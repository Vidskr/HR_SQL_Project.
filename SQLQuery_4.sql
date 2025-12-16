Vidya Kumari_22479
USE HR_DATA
--List the department name, employee ID, and last name for all employees in the 'Sales' and 'IT' departments.
SELECT d.DEPARTMENT_NAME, e.employee_id, e.last_name
FROM OEHR_EMPLOYEES e
JOIN OEHR_DEPARTMENTS d ON e.department_id = d.department_id
WHERE d.department_name IN ('Sales', 'IT');
--Find the highest salary in the 'IT' department.
SELECT MAX(e.salary) AS highest_salary
FROM OEHR_EMPLOYEES e
JOIN OEHR_DEPARTMENTS d ON e.department_id = d.department_id
WHERE d.department_name = 'IT';
-- Show the number of employees in each department, but only for departments with more than 3 employees.
SELECT d.department_name, COUNT(e.employee_id) AS num_employees
FROM OEHR_EMPLOYEES e
JOIN OEHR_DEPARTMENTS d ON e.department_id = d.department_id
GROUP BY d.department_name
HAVING COUNT(e.employee_id) > 3;
--List all employees who were hired in 2005. Those employees who were hired first should come first in your rows.
SELECT employee_id, first_name, last_name, hire_date
FROM OEHR_EMPLOYEES
WHERE YEAR(hire_date) = 2005
ORDER BY hire_date;
--Display the average salary of each department, ordered by average salary in ascending order.
SELECT d.department_name, AVG(e.salary) AS average_salary
FROM OEHR_EMPLOYEES e
JOIN OEHR_DEPARTMENTS d ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY average_salary ASC;
-- Identify the departments where the lowest salary is above $3000.
SELECT d.department_name
FROM OEHR_DEPARTMENTS d
JOIN OEHR_EMPLOYEES e ON d.department_id = e.department_id
GROUP BY d.department_name
HAVING MIN(e.salary) > 3000;
--List the job title and the difference between the highest and lowest salaries for that job.
SELECT JOB_ID, MAX(salary) - MIN(salary) AS salary_difference
FROM OEHR_EMPLOYEES
GROUP BY JOB_ID;
--Find all employees whose last name starts with 'S' and sort them by hire date in descending order.
SELECT *
FROM OEHR_EMPLOYEES
WHERE LAST_NAME LIKE 'S%'
ORDER BY hire_date DESC;
--Show each department's name along with the count of employees who earn more than $5000, only for departments with such employees.
SELECT d.department_name, COUNT(*) AS high_earners_count
FROM OEHR_EMPLOYEES e
JOIN OEHR_DEPARTMENTS d ON e.department_id = d.department_id
WHERE e.salary > 5000
GROUP BY d.department_name
HAVING COUNT(*) > 0;

SELECT DEPARTMENT_NAME, SUM(CASE WHEN a.SALARY > 5000 THEN 1 ELSE 0 END) AS NO_OF_EMPLOYEE FROM OEHR_EMPLOYEES a
INNER JOIN OEHR_DEPARTMENTS b ON a.DEPARTMENT_ID = b.DEPARTMENT_ID
GROUP BY DEPARTMENT_NAME
HAVING SUM(CASE WHEN a.SALARY > 5000 THEN 1 ELSE 0 END) > 0
--For every employee, display their ID, last name, and a case statement that shows 'High Earner' if their salary is above 5000. Otherwise ‘Low Earner’.
SELECT employee_id, last_name,
    CASE
        WHEN salary > 5000 THEN 'High Earner'
        ELSE 'Low Earner'
    END AS earner_status
FROM OEHR_EMPLOYEES;
