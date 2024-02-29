-- 1 Select the first name, last name, and email address of all the customers who have rented a movie.
-- 2 What is the average payment made by each customer (display the customer id, customer name (concatenated), 
   -- and the average payment made).
-- 3 Select the name and email address of all the customers who have rented the "Action" movies.
   -- 3.1 Write the query using multiple join statements
   -- 3.2 Write the query using sub queries with multiple WHERE clause and IN condition
   -- 3.3 Verify if the above two queries produce the same results or not
-- 4 Use the case statement to create a new column classifying existing columns as either or high value transactions
   --  based on the amount of payment. If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, 
   -- the label should be medium, and if it is more than 4, then it should be high.
   
use sakila;

-- 1
SELECT c.first_name, c.last_name, c.email, c.customer_id
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id;

-- 2
SELECT 
    p.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    AVG(p.amount) AS average_payment
FROM 
    payment p
JOIN 
    customer c ON c.customer_id = p.customer_id
GROUP BY 
    p.customer_id, c.first_name, c.last_name;

-- 3  
SELECT first_name, email
FROM customer
WHERE customer_id IN (
    SELECT r.customer_id
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film_category fc ON i.film_id = fc.film_id
    JOIN category cat ON fc.category_id = cat.category_id
    WHERE cat.name = 'Action'
);

-- 4
ALTER TABLE payment
ADD COLUMN high_low VARCHAR(20);
UPDATE payments
SET high_low = 
    CASE 
        WHEN amount BETWEEN 0 AND 2 THEN 'Low value'
        WHEN amount BETWEEN 2 AND 4 THEN 'Medium value'
        ELSE 'High value'
    END;

