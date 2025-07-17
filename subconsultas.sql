
-- SUBCONSULTAS

-- 1. Como gerente, quiero ver los productos cuyo precio esté por encima del promedio de su categoría.
SELECT name, price FROM products p
WHERE price > (
  SELECT AVG(price) FROM products WHERE category_id = p.category_id
);

-- 2. Como administrador, deseo listar las empresas que tienen más productos que la media de empresas.
SELECT name FROM companies
WHERE id IN (
  SELECT company_id FROM company_products
  GROUP BY company_id
  HAVING COUNT(*) > (
    SELECT AVG(cantidad) FROM (
      SELECT COUNT(*) AS cantidad FROM company_products GROUP BY company_id
    ) AS sub
  )
);

-- 3. Como cliente, quiero ver mis productos favoritos que han sido calificados por otros clientes.
SELECT DISTINCT p.name FROM details_favorites df
JOIN favorites f ON df.favorite_id = f.id
JOIN products p ON df.product_id = p.id
WHERE f.customer_id = 1 -- Cliente actual
AND df.product_id IN (
  SELECT DISTINCT product_id FROM quality_products WHERE customer_id != 1
);

-- 4. Como supervisor, deseo obtener los productos con el mayor número de veces añadidos como favoritos.
SELECT name FROM products
WHERE id IN (
  SELECT product_id FROM details_favorites
  GROUP BY product_id
  HAVING COUNT(*) = (
    SELECT MAX(total) FROM (
      SELECT COUNT(*) AS total FROM details_favorites GROUP BY product_id
    ) AS sub
  )
);

-- 5. Como técnico, quiero listar los clientes cuyo correo no aparece en la tabla rates ni en quality_products.
SELECT name FROM customers c
WHERE email IS NOT NULL
AND c.id NOT IN (SELECT customer_id FROM rates)
AND c.id NOT IN (SELECT customer_id FROM quality_products);

-- 6. Como gestor de calidad, quiero obtener los productos con una calificación inferior al mínimo de su categoría.
SELECT name FROM products p
WHERE id IN (
  SELECT product_id FROM quality_products
  GROUP BY product_id
  HAVING AVG(rating) < (
    SELECT MIN(avg_cat) FROM (
      SELECT AVG(rating) AS avg_cat
      FROM quality_products qp
      JOIN products pr ON qp.product_id = pr.id
      WHERE pr.category_id = p.category_id
      GROUP BY qp.product_id
    ) AS cat_avg
  )
);

-- 7. Como desarrollador, deseo listar las ciudades que no tienen clientes registrados.
SELECT name FROM cities_municipalities
WHERE id NOT IN (
  SELECT DISTINCT city_id FROM customers
);

-- 8. Como administrador, quiero ver los productos que no han sido evaluados en ninguna encuesta.
SELECT name FROM products
WHERE id NOT IN (
  SELECT DISTINCT product_id FROM quality_products
);

-- 9. Como auditor, quiero listar los beneficios que no están asignados a ninguna audiencia.
SELECT description FROM benefits
WHERE id NOT IN (
  SELECT benefit_id FROM audience_benefits
);

-- 10. Como cliente, deseo obtener mis productos favoritos que no están disponibles actualmente en ninguna empresa.
SELECT name FROM products p
WHERE id IN (
  SELECT product_id FROM details_favorites
)
AND id NOT IN (
  SELECT product_id FROM company_products
);

-- 11. Como director, deseo consultar los productos vendidos en empresas cuya ciudad tenga menos de tres empresas registradas.
SELECT name FROM products
WHERE id IN (
  SELECT cp.product_id FROM company_products cp
  JOIN companies c ON cp.company_id = c.id
  WHERE c.city_id IN (
    SELECT city_id FROM companies GROUP BY city_id HAVING COUNT(*) < 3
  )
);

-- 12. Como analista, quiero ver los productos con calidad superior al promedio de todos los productos.
SELECT name FROM products p
WHERE id IN (
  SELECT product_id FROM quality_products
  GROUP BY product_id
  HAVING AVG(rating) > (
    SELECT AVG(rating) FROM quality_products
  )
);

-- 13. Como gestor, quiero ver empresas que sólo venden productos de una única categoría.
SELECT name FROM companies
WHERE id IN (
  SELECT company_id FROM company_products cp
  JOIN products p ON cp.product_id = p.id
  GROUP BY cp.company_id
  HAVING COUNT(DISTINCT p.category_id) = 1
);

-- 14. Como gerente comercial, quiero consultar los productos con el mayor precio entre todas las empresas.
SELECT name FROM products
WHERE id IN (
  SELECT product_id FROM company_products
  WHERE price = (
    SELECT MAX(price) FROM company_products
  )
);

-- 15.Como cliente, quiero saber si algún producto de mis favoritos ha sido calificado por otro cliente con más de 4 estrellas.
SELECT name FROM products p
WHERE id IN (
  SELECT product_id FROM details_favorites df
  JOIN favorites f ON df.favorite_id = f.id
  WHERE f.customer_id = 1
)
AND id IN (
  SELECT product_id FROM quality_products WHERE rating > 4 AND customer_id != 1
);

-- 16. Como operador, quiero saber qué productos no tienen imagen asignada pero sí han sido calificados.
SELECT name FROM products
WHERE (image IS NULL OR image = '')
AND id IN (
  SELECT DISTINCT product_id FROM quality_products
);

-- 17. Como auditor, quiero ver los planes de membresía sin periodo vigente.
SELECT name FROM memberships
WHERE id NOT IN (
  SELECT membership_id FROM membership_periods
);

-- 18.Como especialista, quiero identificar los beneficios compartidos por más de una audiencia.
SELECT b.description FROM benefits b
WHERE id IN (
  SELECT benefit_id FROM audience_benefits
  GROUP BY benefit_id
  HAVING COUNT(*) > 1
);

-- 19. Como técnico, quiero encontrar empresas cuyos productos no tengan unidad de medida definida.
SELECT DISTINCT comp.name FROM companies comp
JOIN company_products cp ON comp.id = cp.company_id
WHERE cp.unitmeasure_id IS NULL;

-- 20. Como gestor de campañas, deseo obtener los clientes con membresía activa y sin productos favoritos.
SELECT DISTINCT cu.name FROM customers cu
WHERE cu.id NOT IN (
  SELECT customer_id FROM favorites
)
AND cu.audience_id IN (
  SELECT DISTINCT audience_id FROM membership_benefits
);