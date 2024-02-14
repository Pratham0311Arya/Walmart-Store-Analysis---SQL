CREATE DATABASE Walmart;

USE Walmart;

CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct DECIMAL(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct DECIMAL(11,9),
    gross_income DECIMAL(12, 4),
	rating DECIMAL(2, 1)
);

SHOW TABLES;

DESC sales;

-- imported data through excel file

//Adding new column according to the time 

ALTER TABLE sales 
ADD COLUMN time_of_day VARCHAR(20);

//filling the time_of_day column

UPDATE Sales SET
 time_of_day = ( CASE
				 WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
				 WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
				 ELSE "Evening"
				 END 
			   );
               
select time_of_day from sales;

// Adding day_name column

ALTER TABLE Sales
ADD COLUMN day_name varchar(20);

// Updating the day_name column using date

UPDATE Sales SET 
day_name=DAYNAME(date);

// Adding month column

ALTER TABLE Sales 
ADD COLUMN month_name varchar(20);

UPDATE Sales SET
month_name=MONTHNAME(date);

____________________________________________
____________________________________________

#Q1  How many unique cities does the data have?

SELECT DISTINCT CITY FROM Sales;


#Q2  Which city have which branches?

SELECT DISTINCT City,Branch FROM Sales;


#Q3 How many unique product lines does the data have?

SELECT DISTINCT Product_line FROM Sales

#cout of number of product lineup
SELECT COUNT(DISTINCT Product_line) FROM Sales;


#Q4  Which  is the most selling product line

SELECT Product_line,SUM(Quantity) as Total_Quantity_Sold 
FROM Sales
GROUP BY Product_line
LIMIT 1;

#Q5 Most common payment method

SELECT Payment,COUNT(PAYMENT) as Frequency
FROM Sales
GROUP BY Payment
ORDER BY Frequency desc;

#Q6  Which is the total revenue by month

SELECT Month_name,SUM(Total) as Revenue
FROM Sales
GROUP By month_name
ORDER by Revenue;

#Q7 Which month had the largest COGS?

SELECT month_name,SUM(Cogs) as COGS
FROM Sales
GROUP BY month_name
ORDER BY COGS desc
LIMIT 1;


#Q8 Which product line had the largest revenue?

SELECT Product_line as Product,SUM(Total) as Revenue
FROM Sales
GROUP BY Product
ORDER BY Revenue
LIMIT 1;

#Q9 Which is the city with the largest revenue?

SELECT City,SUM(Total) as Revenue
FROM Sales
GROUP BY City
ORDER BY Revenue
LIMIT 1;

#Q10 What product line had the largest VAT?

SELECT Product_line,AVG(tax_pct) as VAT
FROM Sales
GROUP BY Product_line
ORDER BY VAT
LIMIT 1;

-- Q11 Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales 

SELECT AVG(Total) as Avg_Rev
FROM Sales;  -- its approx 322.4

SELECT Product_line,AVG(Total)
FROM Sales 
GROUP BY Product_line;

SELECT Product_line,
	CASE
		WHEN AVG(Total) > 322.4 THEN "Good"
        ELSE "Bad"
    END AS review
FROM Sales
GROUP BY Product_line;

#Q12 Which branch sold more products than average product sold?
        
SELECT Branch,SUM(Quantity) as qty
FROM Sales
GROUP BY Branch
HAVING SUM(Quantity) > (SELECT AVG(Quantity) FROM Sales);

#Q13 What is the most common product line by gender?

SELECT 	gender, product_line,COUNT(gender) AS total_cnt
FROM sales
GROUP BY gender, product_line
ORDER BY total_cnt DESC;

#Q14 What is the average rating of each product line?

SELECT Product_line, AVG(rating) as AvgR
FROM Sales
GROUP BY Product_line
ORDER BY AvgR DESC;

#Q15Number of sales made in each time of the day per weekday

SELECT time_of_day,SUM(Quantity) 
FROM Sales
GROUP BY time_of_day;

-- **Stored Procedure** to find 

call WeekDaySales("Tuesday")


#Q16 Which of the customer types brings the most revenue?

SELECT Customer_type,SUM(total) as Revenue
FROM Sales
GROUP BY Customer_type
ORDER BY Revenue;


#Q17 Which city has the largest tax percent/ VAT (Value Added Tax)?

SELECT City,ROUND(AVG(tax_pct),2) as VAT
FROM Sales
GROUP BY City
ORDER BY VAT DESC
LIMIT 1;


#Q18 Which customer type pays the most in VAT?

SELECT Customer_type,ROUND(AVG(tax_pct),2) as VAT
FROM Sales
GROUP BY Customer_type
ORDER BY VAT DESC
LIMIT 1;

#Q19 How many unique customer types does the data have?

SELECT DISTINCT Customer_type
FROM Sales;

#Q20 How many unique payment methods does the data have?

SELECT DISTINCT payment
FROM Sales; 

#Q21 What is the most common customer type?

SELECT Customer_type,Count(Customer_type)
FROM Sales
GROUP BY Customer_type;

#Q22 Which customer type spends the most in terms of Revenue per order

SELECT Customer_type,ROUND(AVG(Total),0) as Revenue
FROM Sales
GROUP BY Customer_type;

#Q23 What is the gender of most of the customers?

SELECT Gender,COUNT(Gender) as cnt
FROM Sales
GROUP BY Gender
ORDER BY cnt DESC;

SELECT Gender,Customer_type,COUNT(Gender) as Count
FROM Sales
GROUP BY Customer_type,Gender;

#Q24 What is the gender distribution per branch?

SELECT Gender,Branch,COUNT(Gender) as Count
FROM Sales
GROUP BY Gender,Branch;

-- stored procedure 

call genderDistributionBranch("A")


#Q25 Which time of the day do customers give most ratings?

SELECT time_of_day,AVG(Rating)
FROM Sales
GROUP BY time_of_day;

#Q26 Which time of the day do customers give most ratings per branch?

SELECT time_of_day,Branch,AVG(Rating)
FROM Sales
GROUP BY time_of_day,Branch;

-- stored procedure

call ratingbranch("A")


#Q27 Which day of the week has the best avg ratings?

SELECT day_name,AVG(Rating) as rating
FROM Sales
GROUP BY day_name
ORDER BY rating desc
LIMIT 1;

#Q28 Which day of the week has the best average ratings per branch?

SELECT day_name,Branch,AVG(Rating) as rating
FROM Sales
GROUP BY day_name,Branch
ORDER BY rating desc;

-- stored procedure 

call daybranchrating("B")














