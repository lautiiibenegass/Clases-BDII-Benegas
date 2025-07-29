## 1) Get the amount of cities per country in the database. Sort them by country, country_id.
SELECT 
    co.country,
    co.country_id,
    COUNT(ci.city_id) AS amount_of_cities
FROM country co
INNER JOIN city ci ON co.country_id = ci.country_id
GROUP BY co.country_id, co.country
ORDER BY co.country, co.country_id;


## 2) Get the amount of cities per country in the database. Show only the countries with more than 10 cities, order from the highest amount of cities to the lowest
SELECT 
    co.country,
    co.country_id,
    COUNT(ci.city_id) AS amount_of_cities
FROM country co
INNER JOIN city ci ON co.country_id = ci.country_id
GROUP BY co.country_id, co.country
HAVING COUNT(ci.city_id) > 10
ORDER BY amount_of_cities DESC;


## 3) Generate a report with customer (first, last) name, address, total films rented and the total money spent renting films. Show the ones who spent more money first.
SELECT 
    c.first_name,
    c.last_name,
    a.address,
    COUNT(r.rental_id) AS total_films_rented,
    SUM(p.amount) AS total_money_spent
FROM customer c
INNER JOIN address a ON c.address_id = a.address_id
INNER JOIN rental r ON c.customer_id = r.customer_id
INNER JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.customer_id, c.first_name, c.last_name, a.address
ORDER BY total_money_spent DESC;


## 4) Which film categories have the larger film duration (comparing average)? Order by average in descending order
SELECT 
    cat.name AS category,
    AVG(f.length) AS average_duration
FROM category cat
INNER JOIN film_category fc ON cat.category_id = fc.category_id
INNER JOIN film f ON fc.film_id = f.film_id
WHERE f.length IS NOT NULL
GROUP BY cat.category_id, cat.name
HAVING AVG(f.length) > (
    SELECT AVG(length) 
    FROM film 
    WHERE length IS NOT NULL
)
ORDER BY average_duration DESC;


## 5) Show sales per film rating
SELECT 
    f.rating,
    SUM(p.amount) AS total_sales
FROM film f
INNER JOIN inventory i ON f.film_id = i.film_id
INNER JOIN rental r ON i.inventory_id = r.inventory_id
INNER JOIN payment p ON r.rental_id = p.rental_id
GROUP BY f.rating
ORDER BY total_sales DESC;
