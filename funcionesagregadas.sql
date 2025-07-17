
-- FUNCIONES AGREGADAS

-- 1. Obtener el promedio de calificación por producto
SELECT p.name, AVG(qp.rating) AS promedio
FROM quality_products qp
JOIN products p ON qp.product_id = p.id
GROUP BY p.id;

-- 2. Contar cuántos productos ha calificado cada cliente
SELECT c.name, COUNT(*) AS total_calificados
FROM rates r
JOIN customers c ON r.customer_id = c.id
GROUP BY c.id;

-- 3. Sumar el total de beneficios asignados por audiencia
SELECT a.description, COUNT(*) AS total_beneficios
FROM audience_benefits ab
JOIN audiences a ON ab.audience_id = a.id
GROUP BY ab.audience_id;

-- 4. Calcular la media de productos por empresa
SELECT AVG(productos) AS promedio_productos
FROM (
  SELECT company_id, COUNT(*) AS productos
  FROM company_products
  GROUP BY company_id
) AS sub;

-- 5. Contar el total de empresas por ciudad
SELECT cm.name AS ciudad, COUNT(*) AS total_empresas
FROM companies c
JOIN cities_municipalities cm ON c.city_id = cm.id
GROUP BY c.city_id;

-- 6. Calcular el promedio de precios por unidad de medida
SELECT um.description, AVG(cp.price) AS promedio_precio
FROM company_products cp
JOIN unit_of_measure um ON cp.unitmeasure_id = um.id
GROUP BY cp.unitmeasure_id;

-- 7. Contar cuántos clientes hay por ciudad
SELECT cm.name AS ciudad, COUNT(*) AS total_clientes
FROM customers c
JOIN cities_municipalities cm ON c.city_id = cm.id
GROUP BY c.city_id;

-- 8.  Calcular planes de membresía por periodo
SELECT p.name AS periodo, COUNT(*) AS total_planes
FROM membership_periods mp
JOIN periods p ON mp.period_id = p.id
GROUP BY mp.period_id;

-- 9. Ver el promedio de calificaciones dadas por un cliente a sus favoritos
SELECT AVG(qp.rating) AS promedio
FROM favorites f
JOIN details_favorites df ON f.id = df.favorite_id
JOIN quality_products qp ON df.product_id = qp.product_id AND f.customer_id = qp.customer_id
WHERE f.customer_id = 1; -- ID del cliente

-- 10. Consultar la fecha más reciente en que se calificó un producto
SELECT p.name, MAX(date_rating) AS ultima_calificacion
FROM quality_products qp
JOIN products p ON qp.product_id = p.id
GROUP BY p.id;

-- 11.Obtener la desviación estándar de precios por categoría
SELECT cat.name AS categoria, STDDEV(cp.price) AS desviacion
FROM company_products cp
JOIN products p ON cp.product_id = p.id
JOIN categories cat ON p.category_id = cat.id
GROUP BY cat.name;

-- 12.  Contar cuántas veces un producto fue favorito
SELECT p.name, COUNT(*) AS veces_favorito
FROM details_favorites df
JOIN products p ON df.product_id = p.id
GROUP BY df.product_id;

-- 13. Calcular el porcentaje de productos evaluados
SELECT ROUND((
  (SELECT COUNT(DISTINCT product_id) FROM quality_products) * 100.0 /
  (SELECT COUNT(*) FROM products)
), 2) AS porcentaje_evaluados;

-- 14. Calcular el porcentaje de productos evaluados
SELECT po.name, AVG(r.rating) AS promedio
FROM rates r
JOIN polls po ON r.poll_id = po.id
GROUP BY r.poll_id;

-- 15.  Calcular el promedio y total de beneficios por plan
SELECT m.name, COUNT(mb.benefit_id) AS total_beneficios
FROM membership_benefits mb
JOIN memberships m ON mb.membership_id = m.id
GROUP BY mb.membership_id;

-- 16. Obtener media y varianza de precios por empresa
SELECT c.name, AVG(cp.price) AS media, VARIANCE(cp.price) AS varianza
FROM company_products cp
JOIN companies c ON cp.company_id = c.id
GROUP BY cp.company_id;

-- 17. Ver total de productos disponibles en la ciudad del cliente
SELECT cu.name AS cliente, COUNT(DISTINCT cp.product_id) AS total_productos
FROM customers cu
JOIN companies c ON cu.city_id = c.city_id
JOIN company_products cp ON c.id = cp.company_id
GROUP BY cu.id;

-- 18. Contar productos únicos por tipo de empresa
SELECT ti.description AS tipo_empresa, COUNT(DISTINCT cp.product_id) AS total_productos
FROM companies c
JOIN company_products cp ON c.id = cp.company_id
JOIN type_identifications ti ON c.type_id = ti.id
GROUP BY ti.id;

-- 19. Ver total de clientes sin correo electrónico registrado
SELECT COUNT(*) AS clientes_sin_correo
FROM customers
WHERE email IS NULL OR email = '';

-- 20. Empresa con más productos calificados
SELECT c.name, COUNT(DISTINCT qp.product_id) AS total
FROM quality_products qp
JOIN companies c ON qp.company_id = c.id
GROUP BY qp.company_id
ORDER BY total DESC
LIMIT 1;
