## 1) Create a view named list_of_customers, it should contain the following columns: customer id, customer full name, address, zip code, phone, city, country, status (when active column is 1 show it as 'active', otherwise is 'inactive'), store id
CREATE VIEW list_of_customers AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_full_name,
    a.address,
    a.postal_code AS zip_code,
    a.phone,
    ci.city,
    co.country,
    CASE 
        WHEN c.active = 1 THEN 'active'
        ELSE 'inactive'
    END AS status,
    c.store_id
FROM customer c
INNER JOIN address a ON c.address_id = a.address_id
INNER JOIN city ci ON a.city_id = ci.city_id
INNER JOIN country co ON ci.country_id = co.country_id;



## 2) Create a view named film_details, it should contain the following columns: film id, title, description, category, price, length, rating, actors - as a string of all the actors separated by comma. Hint use GROUP_CONCAT
CREATE VIEW film_details AS
SELECT 
    f.film_id,
    f.title,
    f.description,
    c.name AS category,
    f.rental_rate AS price,
    f.length,
    f.rating,
    GROUP_CONCAT(CONCAT(a.first_name, ' ', a.last_name) SEPARATOR ', ') AS actors
FROM film f
LEFT JOIN film_category fc ON f.film_id = fc.film_id
LEFT JOIN category c ON fc.category_id = c.category_id
LEFT JOIN film_actor fa ON f.film_id = fa.film_id
LEFT JOIN actor a ON fa.actor_id = a.actor_id
GROUP BY f.film_id, f.title, f.description, c.name, f.rental_rate, f.length, f.rating;


## 3) Create view sales_by_film_category, it should return 'category' and 'total_rental' columns.
CREATE VIEW sales_by_film_category AS
SELECT 
    c.name AS category,
    SUM(p.amount) AS total_rental
FROM category c
INNER JOIN film_category fc ON c.category_id = fc.category_id
INNER JOIN film f ON fc.film_id = f.film_id
INNER JOIN inventory i ON f.film_id = i.film_id
INNER JOIN rental r ON i.inventory_id = r.inventory_id
INNER JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.category_id, c.name
ORDER BY total_rental DESC;


## 4) Create a view called actor_information where it should return, actor id, first name, last name and the amount of films he/she acted on.
CREATE VIEW actor_information AS
SELECT 
    a.actor_id,
    a.first_name,
    a.last_name,
    COUNT(fa.film_id) AS amount_of_films
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY amount_of_films DESC;


## 5) Analyze view actor_info, explain the entire query and specially how the sub query works. Be very specific, take some time and decompose each part and give an explanation for each.

/*
ANÁLISIS DETALLADO DE LA VISTA actor_info:

La vista actor_info es una vista compleja que muestra información detallada de cada actor 
y las películas en las que ha participado, organizadas por categoría.

ESTRUCTURA GENERAL:
CREATE DEFINER=CURRENT_USER SQL SECURITY INVOKER VIEW actor_info AS
SELECT
    a.actor_id,
    a.first_name,
    a.last_name,
    GROUP_CONCAT(DISTINCT CONCAT(c.name, ': ',
        (SELECT GROUP_CONCAT(f.title ORDER BY f.title SEPARATOR ', ')
         FROM sakila.film f
         INNER JOIN sakila.film_category fc ON f.film_id = fc.film_id
         INNER JOIN sakila.film_actor fa ON f.film_id = fa.film_id
         WHERE fc.category_id = c.category_id
         AND fa.actor_id = a.actor_id
        )
    ) ORDER BY c.name SEPARATOR '; ') AS film_info
FROM sakila.actor a
LEFT JOIN sakila.film_actor fa ON a.actor_id = fa.actor_id
LEFT JOIN sakila.film_category fc ON fa.film_id = fc.film_id
LEFT JOIN sakila.category c ON fc.category_id = c.category_id
GROUP BY a.actor_id, a.first_name, a.last_name;

DESGLOSE POR PARTES:

1. SELECCIÓN PRINCIPAL:
   - a.actor_id, a.first_name, a.last_name: Información básica del actor

2. SUBCONSULTA CORRELACIONADA (la parte más compleja):
   La subconsulta se ejecuta para cada combinación de actor y categoría:
   
   (SELECT GROUP_CONCAT(f.title ORDER BY f.title SEPARATOR ', ')
    FROM sakila.film f
    INNER JOIN sakila.film_category fc ON f.film_id = fc.film_id
    INNER JOIN sakila.film_actor fa ON f.film_id = fa.film_id
    WHERE fc.category_id = c.category_id
    AND fa.actor_id = a.actor_id)
   
   Esta subconsulta:
   - Busca todas las películas (f.title) 
   - Que pertenecen a una categoría específica (fc.category_id = c.category_id)
   - Y en las que actúa un actor específico (fa.actor_id = a.actor_id)
   - Las ordena alfabéticamente (ORDER BY f.title)
   - Las concatena separadas por comas (SEPARATOR ', ')

3. GROUP_CONCAT EXTERNO:
   GROUP_CONCAT(DISTINCT CONCAT(c.name, ': ', [subconsulta]) ORDER BY c.name SEPARATOR '; ')
   
   - Toma cada categoría (c.name)
   - La concatena con ':' y el resultado de la subconsulta
   - DISTINCT evita duplicados
   - ORDER BY c.name ordena las categorías alfabéticamente
   - SEPARATOR '; ' separa cada categoría con punto y coma

4. JOINS PRINCIPALES:
   - LEFT JOIN film_actor: Conecta actores con películas
   - LEFT JOIN film_category: Conecta películas con categorías  
   - LEFT JOIN category: Obtiene nombres de categorías
   - Se usan LEFT JOIN para incluir actores sin películas

5. GROUP BY:
   Agrupa por actor para que cada actor aparezca una sola vez

EJEMPLO DE RESULTADO:
actor_id: 1
first_name: PENELOPE
last_name: GUINESS
film_info: "Action: ACADEMY DINOSAUR, ANACONDA CONFESSIONS; Comedy: ANGELS LIFE, BULWORTH COMMANDMENTS; Drama: CHAMBER ITALIAN, CHAPLIN LICENSE"

FUNCIONAMIENTO DE LA SUBCONSULTA:
Para cada fila del resultado principal (cada combinación actor-categoría), 
la subconsulta se ejecuta independientemente y devuelve una lista de películas 
de esa categoría específica en la que actúa ese actor específico.

Es una consulta correlacionada porque usa variables de la consulta externa 
(a.actor_id y c.category_id) en su cláusula WHERE.
*/

-- Consulta para probar la vista
SELECT * FROM actor_info LIMIT 5;



## 6) Materialized views, write a description, why they are used, alternatives, DBMS were they exist, etc.

## VISTAS MATERIALIZADAS (MATERIALIZED VIEWS)
##
## DEFINICIÓN:
## Una vista materializada es una vista cuyo resultado se almacena físicamente en disco,
## a diferencia de las vistas regulares que son virtuales y se calculan cada vez que se consultan.
##
## CARACTERÍSTICAS PRINCIPALES:
## 1. Los datos se almacenan físicamente como una tabla
## 2. Se pueden indexar para mejorar el rendimiento
## 3. Requieren actualización periódica para mantener sincronización
## 4. Ocupan espacio de almacenamiento adicional
##
## ¿POR QUÉ SE USAN?
##
## 1. RENDIMIENTO:
##    - Consultas complejas con múltiples JOINs y agregaciones se ejecutan más rápido
##    - Evitan recalcular datos complejos en cada consulta
##    - Especialmente útiles para consultas analíticas y reportes
##
## 2. DISPONIBILIDAD:
##    - Reducen la carga en las tablas base
##    - Permiten consultas rápidas sin afectar sistemas transaccionales
##
## 3. CASOS DE USO TÍPICOS:
##    - Data warehousing y business intelligence
##    - Reportes ejecutivos y dashboards
##    - Consultas de agregación complejas
##    - Sistemas OLAP (Online Analytical Processing)
##
## DESVENTAJAS:
## 1. Espacio de almacenamiento adicional
## 2. Complejidad en la sincronización de datos
## 3. Posible inconsistencia temporal con datos base
## 4. Overhead en actualizaciones
##
## ALTERNATIVAS:
##
## 1. ÍNDICES:
##    - Mejoran rendimiento sin duplicar datos
##    - Menos espacio pero menor ganancia de rendimiento
##
## 2. TABLAS DE RESUMEN (Summary Tables):
##    - Tablas físicas actualizadas por triggers o procesos batch
##    - Mayor control pero más complejidad de mantenimiento
##
## 3. CACHÉ DE APLICACIÓN:
##    - Redis, Memcached para resultados frecuentes
##    - Muy rápido pero volátil
##
## 4. PARTICIONAMIENTO:
##    - Divide tablas grandes en segmentos más pequeños
##    - Mejora rendimiento sin duplicar datos
##
## 5. RÉPLICAS DE LECTURA:
##    - Bases de datos separadas para consultas
##    - Distribuye carga pero no optimiza consultas específicas
##
## SISTEMAS DE GESTIÓN DE BASES DE DATOS QUE LAS SOPORTAN:
##
## SOPORTE NATIVO COMPLETO:
## - Oracle Database (desde versión 8i)
## - PostgreSQL (desde versión 9.3)
## - Microsoft SQL Server (Indexed Views)
## - IBM DB2
## - Teradata
## - Snowflake
## - Amazon Redshift
##
## SOPORTE PARCIAL O MEDIANTE EXTENSIONES:
## - MySQL (no nativo, pero se puede simular con triggers)
## - SQLite (no nativo)
## - MariaDB (no nativo)
##
## IMPLEMENTACIONES EN LA NUBE:
## - Google BigQuery (Materialized Views)
## - Amazon Aurora
## - Azure SQL Database
## - Databricks
##
## ESTRATEGIAS DE ACTUALIZACIÓN:
##
## 1. REFRESH COMPLETE:
##    - Reconstruye completamente la vista
##    - Más lento pero garantiza consistencia
##
## 2. REFRESH INCREMENTAL:
##    - Solo actualiza cambios desde última actualización
##    - Más rápido pero más complejo
##
## 3. REFRESH ON COMMIT:
##    - Actualización automática tras cambios en tablas base
##    - Consistencia inmediata pero impacto en rendimiento
##
## 4. REFRESH ON DEMAND:
##    - Actualización manual o programada
##    - Control total pero posible inconsistencia temporal
##
## EJEMPLO CONCEPTUAL (sintaxis varía por DBMS):
##
## -- Oracle/PostgreSQL
## CREATE MATERIALIZED VIEW sales_summary AS
## SELECT 
##     product_category,
##     EXTRACT(YEAR FROM sale_date) as year,
##     EXTRACT(MONTH FROM sale_date) as month,
##     SUM(amount) as total_sales,
##     COUNT(*) as transaction_count
## FROM sales 
## GROUP BY product_category, EXTRACT(YEAR FROM sale_date), EXTRACT(MONTH FROM sale_date);
##
## -- Actualización
## REFRESH MATERIALIZED VIEW sales_summary;
##
## CONSIDERACIONES DE DISEÑO:
## 1. Identificar consultas costosas y frecuentes
## 2. Evaluar trade-off entre espacio y rendimiento
## 3. Planificar estrategia de actualización
## 4. Monitorear uso y efectividad
## 5. Considerar impacto en operaciones DML
##
## En MySQL, aunque no hay soporte nativo, se pueden simular con:
## - Tablas regulares + triggers para actualización
## - Procedimientos almacenados para refresh manual
## - Eventos programados para actualización periódica

