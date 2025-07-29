## class 11

## 1) Find all the film titles that are not in the inventory.
SELECT f.title
FROM film f
WHERE f.film_id NOT IN (
    SELECT DISTINCT i.film_id 
    FROM inventory i);

## 2) Find all the films that are in the inventory but were never rented.
## 		Show title and inventory_id.
## 		This exercise is complicated.
## 		hint: use sub-queries in FROM and in WHERE or use left join and ask if one of the fields is null
SELECT f.title, i.inventory_id
FROM film f
INNER JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_id IS NULL;

## 3) Generate a report with:
##		customer (first, last) name, store id, film title,
##		when the film was rented and returned for each of these customers
##		order by store_id, customer last_name
SELECT 
    c.first_name,
    c.last_name,
    c.store_id,
    f.title,
    r.rental_date,
    r.return_date
FROM customer c
INNER JOIN rental r ON c.customer_id = r.customer_id
INNER JOIN inventory i ON r.inventory_id = i.inventory_id
INNER JOIN film f ON i.film_id = f.film_id
ORDER BY c.store_id, c.last_name;

## 4) Show sales per store (money of rented films)
##		show store's city, country, manager info and total sales (money)
##		(optional) Use concat to show city and country and manager first and last name
SELECT 
    s.store_id,
    CONCAT(ci.city, ', ', co.country) AS store_location,
    CONCAT(st.first_name, ' ', st.last_name) AS manager_name,
    SUM(p.amount) AS total_sales
FROM store s
INNER JOIN address a ON s.address_id = a.address_id
INNER JOIN city ci ON a.city_id = ci.city_id
INNER JOIN country co ON ci.country_id = co.country_id
INNER JOIN staff st ON s.manager_staff_id = st.staff_id
INNER JOIN inventory i ON s.store_id = i.store_id
INNER JOIN rental r ON i.inventory_id = r.inventory_id
INNER JOIN payment p ON r.rental_id = p.rental_id
GROUP BY s.store_id, store_location, manager_name
ORDER BY total_sales DESC;

## 5) Which actor has appeared in the most films?
SELECT 
    a.actor_id,
    CONCAT(a.first_name, ' ', a.last_name) AS actor_name,
    COUNT(fa.film_id) AS film_count
FROM actor a
INNER JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY film_count DESC
LIMIT 1;