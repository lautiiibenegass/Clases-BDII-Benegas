-- Ejercicio 1: Find the films with less duration, show the title and rating.
SELECT title, rating
  FROM film
 WHERE length = (SELECT MIN(length) FROM film);

-- Ejercicio 2: Write a query that returns the title of the film which duration is the lowest. 
-- If there are more than one film with the lowest duration, the query returns an empty resultset.
SELECT title
  FROM film f
 WHERE length < ALL (
       SELECT length FROM film WHERE film_id <> f.film_id
     );

-- Ejercicio 3: Generate a report with list of customers showing the lowest payments done by each of them.
-- Show customer information, the address and the lowest amount, using a subquery with ALL
SELECT c.customer_id, c.first_name, c.last_name, a.address, p.amount AS min_payment
  FROM customer c
       JOIN address a ON c.address_id = a.address_id
       JOIN payment p ON c.customer_id = p.customer_id
 WHERE p.amount <= ALL (
       SELECT amount FROM payment WHERE customer_id = c.customer_id
     );

-- Ejercicio 3 (alternativa): Usando MIN en lugar de ALL
SELECT c.customer_id, c.first_name, c.last_name, a.address, 
       (SELECT MIN(amount) 
          FROM payment 
         WHERE payment.customer_id = c.customer_id) AS min_payment
  FROM customer c
       JOIN address a ON c.address_id = a.address_id;

-- Ejercicio 4: Generate a report that shows the customer's information with the highest payment 
-- and the lowest payment in the same row.
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       a.address,
       (SELECT MAX(amount) FROM payment p WHERE p.customer_id = c.customer_id) AS max_payment,
       (SELECT MIN(amount) FROM payment p WHERE p.customer_id = c.customer_id) AS min_payment
  FROM customer c
       JOIN address a ON c.address_id = a.address_id;
