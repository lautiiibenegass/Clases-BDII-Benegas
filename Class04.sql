USE sakila;

#1
SELECT title, special_features 
FROM film 
WHERE rating = 'PG-13';

#2
SELECT length AS duration
FROM film;

#3
SELECT title, rental_rate, replacement_cost
FROM film
WHERE replacement_cost >= 20.00 AND replacement_cost <= 24.00;

#4
SELECT f.title, c.name AS category_name, f.rating
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE f.special_features LIKE '%Behind the Scenes%';

#5
SELECT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title = 'ZOOLANDER FICTION';

#6
SELECT a.address, c.city, co.country
FROM store s
JOIN address a ON s.address_id = a.address_id
JOIN city c ON a.city_id = c.city_id
JOIN country co ON c.country_id = co.country_id
WHERE s.store_id = 1;

#7
SELECT f1.title AS movie_1, f2.title AS movie_2, f1.rating
FROM film f1
JOIN film f2 ON f1.rating = f2.rating AND f1.film_id < f2.film_id
ORDER BY f1.rating;

#8
SELECT f.title, st.first_name AS manager_first_name, st.last_name AS manager_last_name
FROM inventory i
JOIN film f ON i.film_id = f.film_id
JOIN store s ON i.store_id = s.store_id
JOIN staff st ON s.manager_staff_id = st.staff_id
WHERE i.store_id = 2;
