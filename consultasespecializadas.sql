
-- CONSULTAS SQL ESPECIALIZADAS

-- 1. Como analista, quiero listar todos los productos con su empresa asociada y el precio más bajo por ciudad.
SELECT 
    c.name AS ciudad, 
    p.name AS producto, 
    comp.name AS empresa, 
    MIN(cp.price) AS precio_min
FROM company_products cp
JOIN companies comp ON cp.company_id = comp.id
JOIN products p ON cp.product_id = p.id
JOIN cities_municipalities c ON comp.city_id = c.id
GROUP BY c.name, p.name, comp.name;


-- 2. Como administrador, deseo obtener el top 5 de clientes que más productos han calificado en los últimos 6 meses.
SELECT cu.name, COUNT(*) AS total_calificaciones
FROM quality_products qp
JOIN customers cu ON qp.customer_id = cu.id
WHERE date_rating >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY cu.id
ORDER BY total_calificaciones DESC
LIMIT 5;

-- 3. Como gerente de ventas, quiero ver la distribución de productos por categoría y unidad de medida.
SELECT cat.name AS categoria, um.description AS unidad, COUNT(cp.id) AS total
FROM company_products cp
JOIN products p ON cp.product_id = p.id
JOIN categories cat ON p.category_id = cat.id
JOIN unit_of_measure um ON cp.unitmeasure_id = um.id
GROUP BY cat.name, um.description;

-- 4. Productos con calificaciones superiores al promedio general
SELECT p.name, AVG(qp.rating) AS promedio
FROM quality_products qp
JOIN products p ON qp.product_id = p.id
GROUP BY p.id
HAVING AVG(qp.rating) > (SELECT AVG(rating) FROM quality_products);

-- 5. Empresas que no han recibido ninguna calificación
SELECT comp.name
FROM companies comp
LEFT JOIN rates r ON comp.id = r.company_id
WHERE r.id IS NULL;

-- 6. Productos añadidos como favoritos por más de 10 clientes distintos
SELECT p.name, COUNT(DISTINCT f.customer_id) AS total
FROM details_favorites df
JOIN favorites f ON df.favorite_id = f.id
JOIN products p ON df.product_id = p.id
GROUP BY p.id
HAVING total > 10;

-- 7. Empresas activas por ciudad y categoría (asumimos activas = tienen productos)
SELECT ci.name AS ciudad, cat.name AS categoria, COUNT(DISTINCT comp.id) AS total_empresas
FROM companies comp
JOIN cities_municipalities ci ON comp.city_id = ci.id
JOIN categories cat ON comp.category_id = cat.id
JOIN company_products cp ON comp.id = cp.company_id
GROUP BY ci.name, cat.name;

-- 8. 10 productos más calificados en cada ciudad
SELECT ciudad, producto, promedio FROM (
  SELECT ci.name AS ciudad, p.name AS producto, AVG(qp.rating) AS promedio,
         RANK() OVER (PARTITION BY ci.name ORDER BY AVG(qp.rating) DESC) AS ranking
  FROM quality_products qp
  JOIN companies comp ON qp.company_id = comp.id
  JOIN cities_municipalities ci ON comp.city_id = ci.id
  JOIN products p ON qp.product_id = p.id
  GROUP BY ciudad, producto
) AS sub
WHERE ranking <= 10;

-- 9. Productos sin unidad de medida asignada
SELECT p.name
FROM products p
WHERE p.id NOT IN (SELECT product_id FROM company_products WHERE unitmeasure_id IS NOT NULL);

-- 10. Planes de membresía sin beneficios registrados
SELECT m.name
FROM memberships m
LEFT JOIN membership_benefits mb ON m.id = mb.membership_id
WHERE mb.id IS NULL;

-- 11. Productos de una categoría específica con su promedio de calificación
SELECT p.name, AVG(qp.rating) AS promedio
FROM products p
JOIN quality_products qp ON p.id = qp.product_id
WHERE p.category_id = 1 -- Cambiar por ID deseado
GROUP BY p.id;

-- 12. Clientes que han comprado productos de más de una empresa
SELECT f.customer_id, c.name, COUNT(DISTINCT cp.company_id) AS empresas
FROM favorites f
JOIN details_favorites df ON f.id = df.favorite_id
JOIN company_products cp ON df.product_id = cp.product_id
JOIN customers c ON f.customer_id = c.id
GROUP BY f.customer_id
HAVING empresas > 1;

-- 13. Ciudades con más clientes activos
SELECT cm.name AS ciudad, COUNT(*) AS total_clientes
FROM customers cu
JOIN cities_municipalities cm ON cu.city_id = cm.id
GROUP BY cu.city_id
ORDER BY total_clientes DESC;

-- 14. Ranking de productos por empresa basado en media de calidad
SELECT comp.name AS empresa, p.name AS producto, AVG(qp.rating) AS promedio
FROM quality_products qp
JOIN companies comp ON qp.company_id = comp.id
JOIN products p ON qp.product_id = p.id
GROUP BY comp.name, p.name
ORDER BY comp.name, promedio DESC;

-- 15. Empresas que ofrecen más de cinco productos distintos
SELECT comp.name, COUNT(DISTINCT cp.product_id) AS total
FROM company_products cp
JOIN companies comp ON cp.company_id = comp.id
GROUP BY comp.id
HAVING total > 5;

-- 16. Productos favoritos que aún no han sido calificados
SELECT p.name
FROM details_favorites df
JOIN favorites f ON df.favorite_id = f.id
JOIN products p ON df.product_id = p.id
WHERE p.id NOT IN (
  SELECT DISTINCT product_id FROM quality_products
);

-- 17. Beneficios asignados a cada audiencia
SELECT a.description AS audiencia, b.description AS beneficio
FROM audience_benefits ab
JOIN audiences a ON ab.audience_id = a.id
JOIN benefits b ON ab.benefit_id = b.id;

-- 18. Ciudades con empresas sin productos
SELECT cm.name AS ciudad
FROM cities_municipalities cm
JOIN companies c ON c.city_id = cm.id
LEFT JOIN company_products cp ON c.id = cp.company_id
WHERE cp.id IS NULL;

-- 19. Empresas con productos duplicados por nombre
SELECT comp.name, p.name, COUNT(*) AS repeticiones
FROM company_products cp
JOIN products p ON cp.product_id = p.id
JOIN companies comp ON cp.company_id = comp.id
GROUP BY comp.id, p.name
HAVING repeticiones > 1;

-- 20. Resumen de clientes, favoritos y promedio de rating
SELECT cu.name AS cliente, COUNT(df.product_id) AS total_favoritos, AVG(qp.rating) AS promedio_rating
FROM customers cu
LEFT JOIN favorites f ON cu.id = f.customer_id
LEFT JOIN details_favorites df ON f.id = df.favorite_id
LEFT JOIN quality_products qp ON df.product_id = qp.product_id AND cu.id = qp.customer_id
GROUP BY cu.id;
