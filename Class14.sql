-- 1) Clientes en Argentina
SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS 'Nombre Completo',
    a.address AS 'Dirección',
    ci.city AS 'Ciudad'
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
WHERE co.country = 'Argentina';

-- 2) Películas con idioma y clasificación
SELECT 
    f.title AS 'Título',
    l.name AS 'Idioma',
    CASE f.rating
        WHEN 'G' THEN 'General Audiences - Apto para todo público'
        WHEN 'PG' THEN 'Parental Guidance - Se sugiere orientación de los padres'
        WHEN 'PG-13' THEN 'Parents Strongly Cautioned - Mayores de 13 años con orientación'
        WHEN 'R' THEN 'Restricted - Menores de 17 requieren acompañante adulto'
        WHEN 'NC-17' THEN 'Adults Only - Solo adultos (17 y mayores)'
        ELSE 'Sin clasificación'
    END AS 'Clasificación'
FROM film f
JOIN language l ON f.language_id = l.language_id
ORDER BY f.title;

-- 3) Películas con Penelope o Guiness
SELECT DISTINCT
    f.title AS 'Título',
    f.release_year AS 'Año de Estreno',
    CONCAT(a.first_name, ' ', a.last_name) AS 'Actor'
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
WHERE 
    CONCAT(a.first_name, ' ', a.last_name) LIKE '%PENELOPE%'
    OR a.first_name LIKE '%PENELOPE%'
    OR a.last_name LIKE '%GUINESS%'
ORDER BY f.release_year DESC;

-- 4) Alquileres en mayo y junio
SELECT 
    f.title AS 'Título de la Película',
    CONCAT(c.first_name, ' ', c.last_name) AS 'Cliente',
    r.rental_date AS 'Fecha de Alquiler',
    CASE 
        WHEN r.return_date IS NOT NULL THEN 'Sí'
        ELSE 'No'
    END AS 'Devuelto'
FROM rental r
JOIN customer c ON r.customer_id = c.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE 
    MONTH(r.rental_date) IN (5, 6)
ORDER BY r.rental_date;

-- 5) CAST y CONVERT ejemplos
SELECT 
    customer_id,
    CAST(customer_id AS CHAR) AS 'ID como texto',
    CAST('2023-07-09' AS DATE) AS 'Fecha Independencia Argentina',
    CAST(25.50 AS DECIMAL(10,2)) AS 'Precio en Pesos'
FROM customer 
LIMIT 3;

SELECT 
    customer_id,
    CONVERT(customer_id, CHAR) AS 'ID como texto',
    CONVERT('2023-07-09', DATE) AS 'Fecha Independencia',
    CONVERT(25.50, DECIMAL(10,2)) AS 'Precio en Pesos'
FROM customer 
LIMIT 3;

SELECT 
    rental_date,
    CAST(rental_date AS DATE) AS 'Solo Fecha CAST',
    CONVERT(rental_date, DATE) AS 'Solo Fecha CONVERT',
    CAST(rental_date AS CHAR) AS 'Fecha como Texto CAST',
    CONVERT(rental_date, CHAR) AS 'Fecha como Texto CONVERT'
FROM rental
LIMIT 5;

-- 6) Manejo de valores NULL
SELECT 
    CONCAT(first_name, ' ', last_name) AS 'Cliente',
    IFNULL(email, 'sin-email@argentina.com') AS 'Email'
FROM customer
LIMIT 5;

SELECT 
    title AS 'Película',
    COALESCE(
        description, 
        'Película argentina sin descripción disponible',
        'Sin información'
    ) AS 'Descripción'
FROM film
LIMIT 5;

SELECT 
    customer_id,
    first_name,
    last_name,
    email,
    ISNULL(email) AS 'Es NULL (1=Sí, 0=No)',
    CASE 
        WHEN ISNULL(email) = 1 THEN 'Cliente sin email'
        ELSE 'Email disponible'
    END AS 'Estado Email'
FROM customer
LIMIT 5;

SELECT 
    CONCAT(
        IFNULL(first_name, 'Sin nombre'), 
        ' ', 
        IFNULL(last_name, 'Sin apellido')
    ) AS 'Cliente Completo',
    COALESCE(email, 'Sin contacto disponible') AS 'Información de Contacto',
    CASE 
        WHEN ISNULL(email) = 1 THEN 'Requiere actualización de datos'
        ELSE 'Datos completos'
    END AS 'Estado del Registro'
FROM customer
WHERE customer_id BETWEEN 1 AND 10
ORDER BY last_name;
