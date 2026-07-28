-- 1. display all customer details who have made more than 5 payments.

SHOW DATABASES;
USE sakila;
SHOW TABLES;

SELECT * FROM customer;
SELECT * FROM payment;

SELECT c.*, COUNT(p.payment_id) AS total_payments
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id
HAVING COUNT(p.payment_id) > 5;

-- 2. Find the names of actors who have acted in more than 10 films.

select * from actor;
select * from film_actor;


SELECT a.actor_id, a.first_name, a.last_name,
COUNT(fa.film_id) AS film_count
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
HAVING COUNT(fa.film_id) > 10;

-- 3. Find the names of customers who never made a payment.

SELECT c.customer_id, c.first_name, c.last_name
FROM customer c
LEFT JOIN payment p ON c.customer_id = p.customer_id
WHERE p.payment_id IS NULL;

SELECT c.customer_id, c.first_name, p.payment_id
FROM customer c
LEFT JOIN payment p ON c.customer_id = p.customer_id
ORDER BY p.payment_id IS NULL DESC;

-- LEFT JOIN keeps every customer, even those with no matching payment. For customers with no payments, all the payment columns come back as NULL
-- WHERE p.payment_id IS NULL keeps only those unmatched customers — the ones who never paid

-- 4. List all films whose rental rate is higher than the average rental rate of all films.

SELECT film_id, title, rental_rate
FROM film
WHERE rental_rate > (SELECT AVG(rental_rate) FROM film);

-- 5. List the titles of films that were never rented.

SELECT f.film_id, f.title
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_id IS NULL;

SELECT title FROM film
WHERE film_id NOT IN (
    SELECT i.film_id
    FROM inventory i
    JOIN rental r ON i.inventory_id = r.inventory_id
);

-- 6. Display the customers who rented films in the same month as customer with ID 5.

SELECT DISTINCT c.customer_id, c.first_name, c.last_name
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
WHERE MONTH(r.rental_date) IN (
    SELECT MONTH(rental_date) FROM rental WHERE customer_id = 5
);

-- 7. Find all staff members who handled a payment greater than the average payment amount.

SELECT DISTINCT s.staff_id, s.first_name, s.last_name
FROM staff s
JOIN payment p ON s.staff_id = p.staff_id
WHERE p.amount > (SELECT AVG(amount) FROM payment);

-- 8. Show the title and rental duration of films whose rental duration is greater than the average.

SELECT title, rental_duration
FROM film
WHERE rental_duration > (SELECT AVG(rental_duration) FROM film);

-- 9. Find all customers who have the same address as customer with ID 1.

SELECT customer_id, first_name, last_name
FROM customer
WHERE address_id = (SELECT address_id FROM customer WHERE customer_id = 1);

-- 10. List all payments that are greater than the average of all payments.

SELECT payment_id, customer_id, amount, payment_date
FROM payment
WHERE amount > (SELECT AVG(amount) FROM payment);



