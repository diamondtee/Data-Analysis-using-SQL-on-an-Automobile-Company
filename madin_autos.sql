CREATE DATABASE Madin_Automobile;
USE Madin_Automobile;

-- Drop tables if they exist
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS salespersons;
DROP TABLE IF EXISTS cars;

-- Create cars table
CREATE TABLE cars (
    car_id INT PRIMARY KEY,
    make VARCHAR(50),
    type VARCHAR(50),
    style VARCHAR(50),
    cost_$ INT
);

-- Insert data into cars table
INSERT INTO cars (car_id, make, type, style, cost_$)
VALUES 
    (1, 'Honda', 'Civic', 'Sedan', 30000),
    (2, 'Toyota', 'Corolla', 'Hatchback', 25000),
    (3, 'Ford', 'Explorer', 'SUV', 40000),
    (4, 'Chevrolet', 'Camaro', 'Coupe', 36000),
    (5, 'BMW', 'X5', 'SUV', 55000),
    (6, 'Audi', 'A4', 'Sedan', 48000),
    (7, 'Mercedes', 'C-Class', 'Coupe', 60000),
    (8, 'Nissan', 'Altima', 'Sedan', 26000),
    (9, 'Toyota', 'RAV4', 'SUV', 32000), 
    (10, 'Honda', 'Accord', 'Sedan', 35000);

-- Create salespersons table
CREATE TABLE salespersons (
    salesman_id INT PRIMARY KEY,
    name VARCHAR(50),
    age INT,
    city VARCHAR(50)
);

-- Insert data into salespersons table
INSERT INTO salespersons (salesman_id, name, age, city)
VALUES 
    (1, 'John Smith', 28, 'New York'),
    (2, 'Emily Wong', 35, 'San Francisco'), -- Changed city from 'San Fran' to 'San Francisco'
    (3, 'Tom Lee', 42, 'Seattle'),
    (4, 'Lucy Chen', 31, 'Los Angeles'); -- Changed city from 'LA' to 'Los Angeles'

-- Create sales table
CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    car_id INT,
    salesman_id INT,
    purchase_date DATE,
    FOREIGN KEY (car_id) REFERENCES cars(car_id),
    FOREIGN KEY (salesman_id) REFERENCES salespersons(salesman_id)
);

-- Insert data into sales table
INSERT INTO sales (sale_id, car_id, salesman_id, purchase_date)
VALUES 
    (1, 1, 1, '2021-01-01'),
    (2, 3, 3, '2021-02-03'),
    (3, 2, 2, '2021-02-10'),
    (4, 5, 4, '2021-03-01'),
    (5, 8, 1, '2021-04-02'),
    (6, 2, 1, '2021-05-05'),
    (7, 4, 2, '2021-06-07'),
    (8, 5, 3, '2021-07-09'),
    (9, 2, 4, '2022-01-01'),
    (10, 1, 3, '2022-02-03'),
    (11, 8, 2, '2022-02-10'),
    (12, 7, 2, '2022-03-01'),
    (13, 5, 3, '2022-04-02'),
    (14, 3, 1, '2022-05-05'),
    (15, 5, 4, '2022-06-07'),
    (16, 1, 2, '2022-07-09'),
    (17, 2, 3, '2023-01-01'),
    (18, 6, 3, '2023-02-03'),
    (19, 7, 1, '2023-02-10'),
    (20, 4, 4, '2023-03-01'),
    (21, 9, 1, '2023-04-02'),
    (22, 10, 2, '2023-05-05'); 

SELECT * from cars;
SELECT * from sales;
SELECT * from salespersons;

# 1.  How many sales have been made by Madin's company?
SELECT COUNT(*) as Total_Sales
FROM sales;

# 2 What is the average cost of cars sold by our company?
SELECT ROUND(AVG(c.cost_$),2) AS Average_Cost_of_Cars_Sold
FROM cars AS c
JOIN sales AS s
ON c.car_id = s.car_id;

# 3. Who is the salesperson with the highest number of sales?
SELECT sp.name , COUNT(*)
FROM sales AS s
JOIN salespersons AS sp
ON sp.salesman_id = s.salesman_id
GROUP BY sp.name 
ORDER BY COUNT(*) DESC; 

#4 How much revenue has each salesperson generated for the company?
SELECT sp.name, SUM(c.cost_$)
FROM salespersons AS sp
JOIN sales AS s
ON sp.salesman_id = s.salesman_id
JOIN cars AS c
ON c.car_id = s.car_id
GROUP BY sp.name
ORDER BY SUM(c.cost_$);

#5 How many sales have been made for each car make?
SELECT c.make, COUNT(s.sale_id)
FROM sales AS s
JOIN cars AS c
ON c.car_id= s.car_id	
GROUP BY c.make;

#6 What is the average age of salespersons in each city?
SELECT name, city, AVG(age)
FROM salespersons
GROUP BY name, city;

#7 How have our sales trended over time?
SELECT EXTRACT(YEAR FROM s.purchase_date) AS Sales_Year,
	MONTHNAME(s.purchase_date) AS Sales_Month,
       SUM(c.cost_$) as Total_Sales
FROM sales s
JOIN cars c
ON s.car_id= c.car_id
GROUP BY Sales_Year, Sales_Month
ORDER BY Sales_Year, FIELD(Sales_Month, 'January', 'February', 'March', 'April', 'May', 'June', 
'July', 'August', 'September', 'October', 'November', 'December');

#8 Which car styles are the most popular among our customers?
SELECT c.style, COUNT(*) AS popular
FROM sales s
JOIN cars c
ON s.car_id= c.car_id
GROUP BY c.style
ORDER BY popular DESC;

# 9 Which specific car models are the top sellers?
SELECT c.make,c.type, COUNT(*) AS Top_Sellers
FROM sales s
JOIN cars c
ON s.car_id= c.car_id
GROUP BY c.make, c.type
ORDER BY Top_Sellers DESC;

#10 How is the performance of salespersons vary across different cities?
SELECT sp.name, sp.city,SUM(c.cost_$) AS Sales 
FROM salespersons sp
JOIN sales s
ON sp.salesman_id=s.salesman_id
JOIN cars c
ON c.car_id = s.car_id
GROUP BY sp.name, sp.city;
