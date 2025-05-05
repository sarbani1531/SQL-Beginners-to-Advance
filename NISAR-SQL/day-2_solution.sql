-- Active: 1746370038192@@127.0.0.1@3306@local

-- 1- write a update statement to update city as null for order ids :  CA-2020-161389 , US-2021-156909
UPDATE superstore_orders
SET city = NULL
WHERE `Order_ID` IN ('CA-2020-161389' , 'US-2021-156909') ;

-- 2- write a query to find orders where city is null (2 rows)

SELECT * FROM superstore_orders
WHERE `City` IS NULL ;

-- 3- write a query to get total profit, first order date and latest order date for each category
SELECT  
`Category`, round(SUM(`Profit`), 2) `total profit`, 
MIN(`Orders_Date`) `first order date`, max(`Orders_Date`) `latest order date`
FROM superstore_orders
GROUP BY `Category` ; 

-- 4- write a query to find sub-categories where average profit is more than the half of the total profit in that sub-category

SELECT  
`Sub_Category`
FROM superstore_orders 
GROUP BY `Sub_Category`
HAVING AVG(`Profit`) > SUM(`Profit`)/2

-- 5- write a query to find total number of products in each category.

SELECT  
`Category`, COUNT(`Product_ID`) `total number of products`
FROM superstore_orders 
GROUP BY `Category`;

-- 6- write a query to find top 5 sub categories in west region by total quantity sold

SELECT  
`Sub_Category` 
FROM superstore_orders
WHERE `Region` = "West"
GROUP BY `Sub_Category`
ORDER BY SUM(`Quantity`) DESC limit 5 ;

-- 7- write a query to find total sales for each region and ship mode combination for orders in year 2020

SELECT  
`Region`, `Ship_Mode`, ROUND(SUM(`Sales`), 2) `total sales`
FROM superstore_orders
WHERE YEAR(`Orders_Date`) = 2020 
GROUP BY `Region`, `Ship_Mode`
ORDER BY `Region`;