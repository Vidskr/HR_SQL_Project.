--Vidya Kumari
USE HR_DATA
--Q1 List all orders where the customer's email domain is 'gmail.com' the order mode 
--is direct, and customers first three digits of the phone number (AFTER +1) are 517.
SELECT O.*
FROM OEHR_ORDERS O
JOIN OEHR_CUSTOMERS C ON O.CUSTOMER_ID = C.CUSTOMER_ID
WHERE C.CUST_EMAIL LIKE '%@gmail.com'
AND O.ORDER_MODE = 'DIRECT'
AND SUBSTRING(C.PHONE_NUMBER, 3, 3) = '517';
--Q2 Find the names of employees whose last name has exactly 5 characters and 
--contains the substring 'man' anywhere in the name.
SELECT FIRST_NAME, LAST_NAME
FROM OEHR_EMPLOYEES
WHERE LEN(LAST_NAME) = 5
AND LAST_NAME LIKE '%MAN%';
--Q3 List all employees whose manager's first name contains 'an' and 
--have a salary above the average salary of their department.
	SELECT E.EMPLOYEE_ID, E.FIRST_NAME, E.LAST_NAME, E.SALARY
FROM OEHR_EMPLOYEES E
JOIN OEHR_EMPLOYEES M ON E.MANAGER_ID = M.EMPLOYEE_ID AND LOWER(M.FIRST_NAME) LIKE '%an%'
JOIN (SELECT DEPARTMENT_ID, AVG(SALARY) AS AVG_SALARY FROM OEHR_EMPLOYEES
    GROUP BY DEPARTMENT_ID) 
	D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID AND E.SALARY > D.AVG_SALARY;
--Q4 Retrieve the product IDs and names of products that have been sold more than three times and have 'for' in their translated name, 
--considering only the first 6 characters after trimming any leading or trailing spaces
SELECT A.PRODUCT_ID, TRANSLATED_NAME, QUANTITY
FROM OEHR_PRODUCT_DESCRIPTIONS A
INNER JOIN OEHR_ORDER_ITEMS B ON A.PRODUCT_ID = B.PRODUCT_ID
WHERE QUANTITY > 3
AND TRIM(LEFT(A.TRANSLATED_NAME, 6)) LIKE '%for%'
--Q5: Find the customer names and their total purchase amounts for customers who have made more than 3 orders, using CTEs.
WITH CustomerOrderCounts AS (SELECT o.CUSTOMER_ID, COUNT(o.ORDER_ID) AS OrderCount,
        SUM(o.ORDER_TOTAL) AS TotalPurchaseAmount FROM OEHR_ORDERS o
    GROUP BY o.CUSTOMER_ID
    HAVING COUNT(o.ORDER_ID) > 3)
SELECT c.CUST_FIRST_NAME, c.CUST_LAST_NAME, coc.TotalPurchaseAmount
FROM CustomerOrderCounts coc
JOIN OEHR_CUSTOMERS c ON coc.CUSTOMER_ID = c.CUSTOMER_ID;

--Q6: Retrieve the product IDs and names of products that have been sold more than 4 times and have 'wireless' in their name, considering only the first 8 characters after trimming any leading or trailing spaces, using CTEs.
WITH ProductSales AS (SELECT oi.PRODUCT_ID, COUNT(oi.PRODUCT_ID) AS SaleCount
FROM OEHR_ORDER_ITEMS oi GROUP BY oi.PRODUCT_ID HAVING COUNT(oi.PRODUCT_ID) > 4),
FilteredProducts AS (SELECT p.PRODUCT_ID,
        TRIM(p.PRODUCT_NAME) AS TrimmedProductName
    FROM OEHR_PRODUCT_INFORMATION p
    WHERE LOWER(SUBSTRING(TRIM(p.PRODUCT_NAME), 1, 8)) LIKE '%wireless%')
SELECT fp.PRODUCT_ID, fp.TrimmedProductName AS PRODUCT_NAME
FROM FilteredProducts fp
JOIN ProductSales ps ON fp.PRODUCT_ID = ps.PRODUCT_ID;

--Q7: Retrieve all orders placed by customers who have spent more than the average amount.
SELECT o.*
FROM OEHR_ORDERS o
WHERE o.ORDER_TOTAL > (
    SELECT AVG(ORDER_TOTAL) FROM OEHR_ORDERS);
--Q8: Find all customers (customer ID and customer name) along with the total spending of each customer compared to the maximum spending among all customers. (two columns for customer id and customer name, one column for total spending of each customer, one column for maximum spending among all customers, total 4 columns).
SELECT c.CUSTOMER_ID, c.CUST_FIRST_NAME, c.CUST_LAST_NAME, 
       SUM(o.ORDER_TOTAL) AS total_spending, 
       (SELECT MAX(total_spending) FROM (SELECT SUM(o.ORDER_TOTAL) AS total_spending FROM OEHR_ORDERS o GROUP BY o.CUSTOMER_ID) AS max_spending) AS max_spending
FROM OEHR_CUSTOMERS c
JOIN OEHR_ORDERS o ON c.CUSTOMER_ID = o.CUSTOMER_ID
GROUP BY c.CUSTOMER_ID, c.CUST_FIRST_NAME, c.CUST_LAST_NAME;
--Q9: Find all employees and their corresponding salaries. If an employee's salary is below the average salary of their department, display 'Below Average' instead of the salary.
SELECT e.EMPLOYEE_ID, e.FIRST_NAME, e.LAST_NAME,
       CASE 
   WHEN e.SALARY < AVG(e.SALARY) OVER (PARTITION BY e.DEPARTMENT_ID) THEN 'Below Average'
   ELSE CAST(e.SALARY AS VARCHAR)
       END AS salary FROM OEHR_EMPLOYEES e
	    
--Q10: List all employees along with the number of employees they manage. If an employee does not manage any employees, display '0' instead of the count.
SELECT e.EMPLOYEE_ID, e.FIRST_NAME, e.LAST_NAME, 
       COALESCE(em.count_managed, 0) AS employees_managed
FROM OEHR_EMPLOYEES e
LEFT JOIN (SELECT MANAGER_ID, COUNT(*) AS count_managed FROM OEHR_EMPLOYEES
    GROUP BY MANAGER_ID) em ON e.EMPLOYEE_ID = em.MANAGER_ID


 






