
-- 1- write a query to get region wise count of return orders

SELECT  
`Region`, COUNT(so.`Order_ID`) `count of return orders`
FROM returns re
INNER JOIN
superstore_orders so
on re.`Order Id` = so.`Order_ID`
GROUP BY so.`Region`;

-- 2- write a query to get category wise sales of orders that were not returned

SELECT 
so.`Category`, round(sum(so.`Sales`), 2) `total sales`
FROM superstore_orders so
INNER JOIN
returns re
ON so.`Order_ID` != re.`Order Id`
GROUP BY so.`Category`;


-- 3- write a query to print dep name and average salary of employees in that dep .
SELECT  
d.dep_name, round(AVG(salary), 2) `average salary`
FROM employee e
INNER JOIN dept d
on e.dept_id = d.dep_id
GROUP BY d.dep_name  ;

-- 4- write a query to print dep names where none of the emplyees have same salary.

SELECT *
FROM dept 
WHERE dept.dep_id NOT IN (select e1.dept_id
                        FROM employee e1
                        JOIN employee e2 
                        ON e1.dept_id = e2.dept_id  
                        AND e1.emp_id < e2.emp_id 
                        AND e1.salary = e2.salary) ;


-- 5- write a query to print sub categories where we have all 3 kinds of returns (others,bad quality,wrong items)

SELECT 
so.`Sub_Category`
FROM superstore_orders so
INNER JOIN returns re
on so.`Order_ID` = re.`Order Id`
GROUP BY so.`Sub_Category`
HAVING count(DISTINCT re.`Return Reason`) = 3 ;

-- 6- write a query to find cities where not even a single order was returned.
SELECT  
`City`
FROM superstore_orders so
LEFT JOIN  
returns re 
on so.`Order_ID` = re.`Order Id`
WHERE `City` IS NOT NULL
GROUP BY `City` HAVING COUNT(re.`Order Id`) = 0;


-- 7- write a query to find top 3 subcategories by sales of returned orders in east region

SELECT 
`Sub_Category`
FROM superstore_orders so
INNER JOIN returns re
ON so.`Order_ID` = re.`Order Id` 
WHERE `Region` = "East"
GROUP BY `Sub_Category`
ORDER BY SUM(`Sales`) DESC limit 3;

-- 8- write a query to print dep name for which there is no employee
SELECT dep_name 
FROM dept 
WHERE dep_id NOT IN (
    SELECT DISTINCT dept_id FROM employee) ;

-- 9- write a query to print employees name for dep id is not avaiable in dept table
SELECT emp_name 
FROM employee 
WHERE dept_id NOT IN (
    SELECT dep_id FROM dept
)