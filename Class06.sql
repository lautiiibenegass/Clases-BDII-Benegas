
-- 1
SELECT first_name, last_name
FROM actor
WHERE last_name IN (
    SELECT last_name
    FROM actor
    GROUP BY last_name
    HAVING COUNT(*) > 1
)
ORDER BY last_name, first_name;

-- 2
SELECT actor_id, first_name, last_name
FROM actor
WHERE actor_id NOT IN (
    SELECT DISTINCT actor_id FROM film_actor
);

-- 3
SELECT customer_id
FROM rental
WHERE inventory_id IS NOT NULL
GROUP BY customer_id
HAVING COUNT(DISTINCT inventory_id) = 1;

-- 4
SELECT customer_id
FROM rental
WHERE inventory_id IS NOT NULL
GROUP BY customer_id
HAVING COUNT(DISTINCT inventory_id) > 1;

-- 5
SELECT actor_id, first_name, last_name
FROM actor
WHERE actor_id IN (
    SELECT actor_id
    FROM film_actor
    WHERE film_id IN (
        SELECT film_id FROM film
        WHERE title IN ('BETRAYED REAR', 'CATCH AMISTAD')
    )
);

-- 6
SELECT actor_id, first_name, last_name
FROM actor
WHERE actor_id IN (
    SELECT actor_id
    FROM film_actor
    WHERE film_id = (
        SELECT film_id FROM film WHERE title = 'BETRAYED REAR'
    )
)
AND actor_id NOT IN (
    SELECT actor_id
    FROM film_actor
    WHERE film_id = (
        SELECT film_id FROM film WHERE title = 'CATCH AMISTAD'
    )
);

-- 7
SELECT actor_id, first_name, last_name
FROM actor
WHERE actor_id IN (
    SELECT actor_id
    FROM film_actor
    WHERE film_id = (
        SELECT film_id FROM film WHERE title = 'BETRAYED REAR'
    )
)
AND actor_id IN (
    SELECT actor_id
    FROM film_actor
    WHERE film_id = (
        SELECT film_id FROM film WHERE title = 'CATCH AMISTAD'
    )
);

-- 8
SELECT actor_id, first_name, last_name
FROM actor
WHERE actor_id NOT IN (
    SELECT actor_id
    FROM film_actor
    WHERE film_id IN (
        SELECT film_id FROM film
        WHERE title IN ('BETRAYED REAR', 'CATCH AMISTAD')
    )
);
