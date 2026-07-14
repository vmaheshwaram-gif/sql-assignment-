SHOW DATABASES;
USE sakila;
SHOW TABLES;

-- Get all customers whose first name starts with 'J' and who are active.
USE sakila;

SELECT  first_name, active
FROM customer
WHERE first_name LIKE 'J%'
  AND active = 1;
  
  SELECT COUNT(*)
FROM customer
WHERE first_name LIKE 'J%' AND active = 1;

-- Find all films where the title contains the word 'ACTION' or the description contains 'WAR'.
 SELECT title, description
FROM film
WHERE title LIKE '%ACTION%'
   OR description LIKE '%WAR%';
  
  select count(*)
  from film
  where title LIKE '%ACTION%'
     OR description LIKE '%WAR%';
   
-- List all customers whose last name is not 'SMITH' and whose first name ends with 'a'.

SELECT  first_name, last_name
FROM customer
WHERE NOT last_name = 'SMITH'
  AND first_name LIKE '%a';
  
  --  Get all films where the rental rate is greater than 3.0 and the replacement cost is not null.
   
    SELECT  rental_rate, replacement_cost
FROM film
WHERE rental_rate > 3.0
  AND replacement_cost IS NOT NULL;
  
  -- Count how many customers exist in each store who have active status = 1.
  
  SELECT  COUNT(*) 
FROM customer
WHERE active = 1;

-- Show distinct film ratings available in the film table.

SELECT DISTINCT rating
FROM film;

-- Find the number of films for each rental duration where the average length is more than 100 minutes.

SELECT rental_duration, COUNT(*)
FROM film
GROUP BY rental_duration
HAVING AVG(length) > 100;

-- List payment dates and total amount paid per date, but only include days where more than 100 payments were made.
  
 SELECT DATE(payment_date), COUNT(*), SUM(amount)
FROM payment
GROUP BY DATE(payment_date)
HAVING COUNT(*) > 100;

-- Find customers whose email address is null or ends with '.org'.

SELECT  email FROM customer
WHERE email IS NULL
   OR email LIKE '%.org';
   
-- List all films with rating 'PG' or 'G', and order them by rental rate in descending order

  SELECT  rating, rental_rate
FROM film
WHERE rating IN ('PG', 'G')
ORDER BY rental_rate DESC;

-- Count how many films exist for each length where the film title starts with 'T' and the count is more than 5.

SELECT length, COUNT(*)
FROM film
WHERE title LIKE 'T%'
GROUP BY length
HAVING COUNT(*) > 5;
   
--  List all actors who have appeared in more than 10 films.
USE sakila;
SELECT * FROM actor;
SELECT * FROM film_actor;

SELECT  a.first_name, a.last_name, COUNT(*) AS film_count
FROM sakila.actor a
JOIN sakila.film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
HAVING COUNT(*) > 10;

-- Find the top 5 films with the highest rental rates and longest lengths combined, ordering by rental rate first and length second.

SELECT title, rental_rate, length
FROM film
ORDER BY rental_rate DESC, length DESC
LIMIT 5;

--  Show all customers along with the total number of rentals they have made, ordered from most to least rentals.
SELECT * FROM customer;
SELECT * FROM rental;

SELECT c.customer_id, c.first_name, c.last_name, COUNT(*) AS total_rentals
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id
ORDER BY total_rentals DESC;


--  List the film titles that have never been rented.

SELECT * FROM film;
SELECT * FROM inventory;
SELECT * FROM rental;

SELECT f.title, i.inventory_id, r.rental_id
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
ORDER BY r.rental_id IS NULL DESC;

-- Assignment2 
-- Identify if there are duplicates in Customer table. Don't use customer id to check the duplicates

SELECT* FROM customer;

SELECT first_name, last_name, email, COUNT(*) AS occurrences
FROM customer
GROUP BY first_name, last_name, email
HAVING COUNT(*) > 1;

--  Number of times letter 'a' is repeated in film descriptions

SELECT SUM(LENGTH(description) - LENGTH(REPLACE(description, 'a', ''))) AS total_a
FROM film;

-- length before minus length after removing 'a' = how many a's there were.
--  example:'Cat sat' is 7 characters → remove a's → 'Ct st' is 5 → difference = 2 a's.

--  3. Number of times each vowel is repeated in film descriptions 

SELECT
    SUM(LENGTH(description) - LENGTH(REPLACE(description, 'a', ''))) AS a_count,
    SUM(LENGTH(description) - LENGTH(REPLACE(description, 'e', ''))) AS e_count,
    SUM(LENGTH(description) - LENGTH(REPLACE(description, 'i', ''))) AS i_count,
    SUM(LENGTH(description) - LENGTH(REPLACE(description, 'o', ''))) AS o_count,
    SUM(LENGTH(description) - LENGTH(REPLACE(description, 'u', ''))) AS u_count
FROM film;

--  Display the payments made by each customer
      --  1. Month wise

SELECT * FROM customer;
SELECT * FROM payment;

SELECT c.first_name, c.last_name,
       DATE_FORMAT(p.payment_date, '%Y-%m') AS pay_month,
       SUM(p.amount) AS total_paid
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, pay_month
ORDER BY c.customer_id, pay_month;
  
      --   2. Year wise
      
      SELECT c.first_name, c.last_name,
       YEAR(p.payment_date) AS pay_year,
       SUM(p.amount) AS total_paid
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, pay_year
ORDER BY c.customer_id, pay_year;

    -- 3. Week wise
    
    SELECT c.first_name, c.last_name,
       YEARWEEK(p.payment_date) AS pay_week,
       SUM(p.amount) AS total_paid
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, pay_week
ORDER BY c.customer_id, pay_week;

--   Check if any given year is a leap year or not. You need not consider any table from sakila database. Write within the select query with hardcoded date

SELECT IF( (1998 % 4 = 0 AND 1998 % 100 <> 0) OR 1998 % 400 = 0,
           'Leap Year', 'Not a Leap Year') AS result;
           
--  (divisible by 4 AND not by 100) OR divisible by 400.

--  Display number of days remaining in the current year from today.

SELECT DATEDIFF( CONCAT(YEAR(CURDATE()), '-12-31'), CURDATE() ) AS days_remaining;

-- CURDATE() — today's date: 2026-07-14
-- YEAR(CURDATE()) — extracts 2026
-- CONCAT(2026, '-12-31') — glues it into '2026-12-31', the last day of whatever year it currently is (no hardcoding, so the query works forever)
-- DATEDIFF(later, earlier) — days between two dates: Dec 31 minus today = 170

-- Display quarter number(Q1,Q2,Q3,Q4) for the payment dates from payment table.

SELECT payment_date,
       CONCAT('Q', QUARTER(payment_date)) AS quarter
FROM payment;




