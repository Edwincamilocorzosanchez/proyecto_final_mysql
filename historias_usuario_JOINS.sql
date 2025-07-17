



-- CONSULTAS CON JOINs (Historias de Usuario)

-- 1. Ver productos con la empresa que los vende

SELECT comp.name  AS empresa,
       p.name     AS producto,
       cp.price   AS precio
FROM   companies comp
JOIN   company_products cp ON comp.id = cp.company_id
JOIN   products p         ON cp.product_id = p.id
ORDER  BY comp.name, p.name;

-- 2. Productos favoritos con su empresa y categoría 
SELECT p.name          AS producto,
       cat.name        AS categoria,
       comp.name       AS empresa
FROM   favorites f
JOIN   details_favorites df ON f.id = df.favorite_id
JOIN   products p           ON df.product_id = p.id
JOIN   categories cat       ON p.category_id = cat.id
JOIN   company_products cp  ON p.id = cp.product_id
JOIN   companies comp       ON cp.company_id = comp.id
WHERE  f.customer_id = 4;


-- 3. Ver empresas aunque no tengan productos 
SELECT comp.name  AS empresa,
       cp.product_id
FROM   companies comp
LEFT   JOIN company_products cp ON comp.id = cp.company_id
ORDER  BY comp.name;

-- 4. Ver todos los productos con calificación (o no) 
SELECT p.name  AS producto,
       r.rating,
       r.date_rating
FROM   products p
RIGHT  JOIN rates r ON p.id = r.product_id
ORDER  BY p.name;

-- 5. ver productos con promedio de calificación y empresa
SELECT comp.name                       AS empresa,
       p.name                          AS producto,
       ROUND(AVG(r.rating),2)          AS promedio
FROM   rates r
JOIN   products p          ON r.product_id = p.id
JOIN   company_products cp ON p.id = cp.product_id
JOIN   companies comp      ON cp.company_id = comp.id
GROUP  BY comp.name, p.name;

-- 6.  verclientes y sus calificaciones (si las tienen)
SELECT cu.name       AS cliente,
       r.product_id,
       r.rating
FROM   customers cu
LEFT   JOIN rates r ON cu.id = r.customer_id
ORDER  BY cu.name;

-- 7. Favoritos con la última calificación del cliente 
SELECT p.name  AS producto,
       r.rating,
       r.date_rating
FROM   favorites f
JOIN   details_favorites df ON f.id = df.favorite_id
JOIN   products p           ON df.product_id = p.id
LEFT   JOIN rates r ON r.product_id = p.id AND r.customer_id = f.customer_id
WHERE  f.customer_id = 5
ORDER  BY r.date_rating DESC;

-- 8.Ver beneficios incluidos en cada plan de membresía
SELECT m.name       AS membresia,
       b.description AS beneficio
FROM   membership_benefits mb
JOIN   memberships m ON mb.membership_id = m.id
JOIN   benefits b    ON mb.benefit_id   = b.id
ORDER  BY m.name;

-- 9. Ver clientes con membresía activa y sus beneficios
SELECT cu.name  AS cliente,
       b.description AS beneficio
FROM   customers cu
JOIN   membership_periods mp ON cu.audience_id = mp.membership_id
JOIN   membership_benefits mb ON mp.membership_id = mb.membership_id
JOIN   benefits b            ON mb.benefit_id = b.id
WHERE  CURDATE() BETWEEN mp.start_date AND mp.end_date;

-- 10.Ver ciudades con cantidad de empresas
SELECT cm.name  AS ciudad,
       COUNT(comp.id) AS total_empresas
FROM   cities_municipalities cm
LEFT   JOIN companies comp ON comp.city_id = cm.id
GROUP  BY cm.id;

-- 11. Ver encuestas con calificaciones
SELECT po.name  AS encuesta,
       r.rating,
       r.date_rating
FROM   polls po
JOIN   rates r ON po.id = r.poll_id;

-- 12. Ver productos evaluados con datos del cliente
SELECT p.name        AS producto,
       cu.name       AS cliente,
       r.rating,
       r.date_rating
FROM   rates r
JOIN   products p  ON r.product_id = p.id
JOIN   customers cu ON r.customer_id = cu.id;

-- 13.Ver productos con audiencia de la empresa
SELECT p.name    AS producto,
       a.description AS audiencia
FROM   products p
JOIN   company_products cp ON p.id = cp.product_id
JOIN   companies comp      ON cp.company_id = comp.id
JOIN   audiences a         ON comp.audience_id = a.id;

-- 14. Ver clientes con sus productos favoritos
SELECT cu.name  AS cliente,
       p.name   AS producto
FROM   customers cu
JOIN   favorites f          ON cu.id = f.customer_id
JOIN   details_favorites df ON f.id = df.favorite_id
JOIN   products p           ON df.product_id = p.id;

-- 15.  Ver planes, periodos, precios y beneficios
SELECT m.name       AS plan,
       p2.name      AS periodo,
       mp.price,
       b.description AS beneficio
FROM   membership_periods mp
JOIN   memberships m ON mp.membership_id = m.id
JOIN   periods p2    ON mp.period_id     = p2.id
LEFT   JOIN membership_benefits mb ON mb.membership_id = m.id AND mb.period_id = p2.id
LEFT   JOIN benefits b            ON mb.benefit_id    = b.id;

-- 16. Ver combinaciones empresa-producto-cliente calificados
SELECT comp.name  AS empresa,
       p.name     AS producto,
       cu.name    AS cliente,
       r.rating
FROM   rates r
JOIN   companies comp ON r.company_id  = comp.id
JOIN   customers cu   ON r.customer_id = cu.id
JOIN   products p     ON r.product_id  = p.id;

-- 17. Comparar favoritos con productos calificados
FROM   details_favorites df
JOIN   favorites f ON df.favorite_id = f.id
JOIN   products p  ON df.product_id = p.id
LEFT   JOIN rates r ON r.product_id = p.id AND r.customer_id = f.customer_id
WHERE  f.customer_id = 5;

-- 18. Ver productos ordenados por categoría
SELECT cat.name AS categoria,
       p.name   AS producto
FROM   categories cat
JOIN   products p ON p.category_id = cat.id
ORDER  BY cat.name, p.name;

-- 19.Ver beneficios por audiencia, incluso vacíos
SELECT a.description AS audiencia,
       b.description AS beneficio
FROM   audiences a
LEFT   JOIN audience_benefits ab ON ab.audience_id = a.id
LEFT   JOIN benefits b          ON ab.benefit_id  = b.id;

-- 20. Ver datos cruzados entre calificaciones, encuestas, productos y clientes
SELECT r.id         AS rate_id,
       cu.name      AS cliente,
       p.name       AS producto,
       po.name      AS encuesta,
       r.rating,
       r.date_rating
FROM   rates r
JOIN   customers cu ON r.customer_id = cu.id
JOIN   products p   ON r.product_id  = p.id
JOIN   polls po     ON r.poll_id     = po.id;