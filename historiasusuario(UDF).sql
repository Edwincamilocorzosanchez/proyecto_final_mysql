


-- FUNCIONES DEFINIDAS POR EL USUARIO (UDF)

-- 1. Como analista, quiero una función que calcule el promedio ponderado de calidad de un producto basado en sus calificaciones y fecha de evaluación.
DELIMITER //
CREATE FUNCTION calcular_promedio_ponderado(prod_id INT)
RETURNS DOUBLE
DETERMINISTIC
BEGIN
  
  RETURN (
    SELECT SUM(rating * (1/(1 + TIMESTAMPDIFF(MONTH,date_rating,NOW())))) /
           SUM(1/(1 + TIMESTAMPDIFF(MONTH,date_rating,NOW())))
    FROM   quality_products
    WHERE  product_id = prod_id
  );
END;//
DELIMITER ;

-- 2. Como auditor, deseo una función que determine si un producto ha sido calificado recientemente (últimos 30 días).
DELIMITER //
CREATE FUNCTION es_calificacion_reciente(fecha DATETIME)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
  RETURN DATEDIFF(NOW(), fecha) <= 30;
END;//
DELIMITER ;

-- 3. Como desarrollador, quiero una función que reciba un product_id y devuelva el nombre completo de la empresa que lo vende.
DELIMITER //
CREATE FUNCTION obtener_empresa_producto(prod_id INT)
RETURNS VARCHAR(80)
DETERMINISTIC
BEGIN
  RETURN (
    SELECT comp.name
    FROM   company_products cp
    JOIN   companies comp ON cp.company_id = comp.id
    WHERE  cp.product_id = prod_id
    LIMIT 1
  );
END;//
DELIMITER ;

-- 4. Como operador, deseo una función que, dado un customer_id, me indique si el cliente tiene una membresía activa.
DELIMITER //
CREATE FUNCTION tiene_membresia_activa(cust_id INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
  RETURN EXISTS (
    SELECT 1
    FROM   membership_periods mp
    WHERE  mp.membership_id = (SELECT audience_id FROM customers WHERE id = cust_id)
      AND  CURDATE() BETWEEN mp.start_date AND mp.end_date
  );
END;//
DELIMITER ;

-- 5. Como administrador, quiero una función que valide si una ciudad tiene más de X empresas registradas, recibiendo la ciudad y el número como
DELIMITER //
CREATE FUNCTION ciudad_supera_empresas(city INT, limite INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
  RETURN (
    SELECT COUNT(*) FROM companies WHERE city_id = city
  ) > limite;
END;//
DELIMITER ;

-- 6.Como gerente, deseo una función que, dado un rate_id, me devuelva una descripción textual de la calificación (por ejemplo, “Muy bueno”, “Regular”).
DELIMITER //
CREATE FUNCTION descripcion_calificacion(valor DOUBLE)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
  RETURN CASE
    WHEN valor >= 4.5 THEN 'Excelente'
    WHEN valor >= 4   THEN 'Muy bueno'
    WHEN valor >= 3   THEN 'Regular'
    WHEN valor >= 2   THEN 'Malo'
    ELSE 'Pésimo'
  END;
END;//
DELIMITER ;

-- 7. Como técnico, quiero una función que devuelva el estado de un producto en función de su evaluación (ej. “Aceptable”, “Crítico”).
DELIMITER //
CREATE FUNCTION estado_producto(prod_id INT)
RETURNS VARCHAR(15)
DETERMINISTIC
BEGIN
  DECLARE prom DOUBLE;
  SELECT AVG(rating) INTO prom FROM quality_products WHERE product_id = prod_id;
  RETURN CASE
    WHEN prom IS NULL      THEN 'Sin datos'
    WHEN prom < 2.5        THEN 'Crítico'
    WHEN prom < 4          THEN 'Aceptable'
    ELSE 'Óptimo'
  END;
END;//
DELIMITER ;

-- 8. Como cliente, deseo una función que indique si un producto está entre mis favoritos, recibiendo el product_id y mi customer_id.
DELIMITER //
CREATE FUNCTION es_favorito(cust_id INT, prod_id INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM details_favorites df
    JOIN   favorites f ON df.favorite_id = f.id
    WHERE  f.customer_id = cust_id AND df.product_id = prod_id
  );
END;//
DELIMITER ;

-- 9. Como gestor de beneficios, quiero una función que determine si un beneficio está asignado a una audiencia específica, retornando verdadero o falso.
DELIMITER //
CREATE FUNCTION beneficio_asignado_audiencia(ben_id INT, aud_id INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM audience_benefits
    WHERE  benefit_id = ben_id AND audience_id = aud_id
  );
END;//
DELIMITER ;

-- 10.Como auditor, deseo una función que reciba una fecha y determine si se encuentra dentro de un rango de membresía activa.
DELIMITER //
CREATE FUNCTION fecha_en_membresia(fecha DATETIME, cust_id INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM membership_periods mp
    WHERE  mp.membership_id = (SELECT audience_id FROM customers WHERE id = cust_id)
      AND  fecha BETWEEN mp.start_date AND mp.end_date
  );
END;//
DELIMITER ;

-- 11.Como desarrollador, quiero una función que calcule el porcentaje de calificaciones positivas de un producto respecto al total.
DELIMITER //
CREATE FUNCTION porcentaje_positivas(prod_id INT)
RETURNS DOUBLE
DETERMINISTIC
BEGIN
  DECLARE total INT;
  DECLARE positivas INT;
  SELECT COUNT(*) INTO total FROM rates WHERE product_id = prod_id;
  IF total = 0 THEN RETURN NULL; END IF;
  SELECT COUNT(*) INTO positivas FROM rates WHERE product_id = prod_id AND rating >= 4;
  RETURN positivas / total * 100;
END;//
DELIMITER ;

-- 12. Como supervisor, deseo una función que calcule la edad de una calificación, en días, desde la fecha actual.
DELIMITER //
CREATE FUNCTION edad_calificacion(rate_fecha DATETIME)
RETURNS INT
DETERMINISTIC
BEGIN
  RETURN DATEDIFF(CURDATE(), DATE(rate_fecha));
END;//
DELIMITER ;

-- 13.Como operador, quiero una función que, dado un company_id, devuelva la cantidad de productos únicos asociados a esa empresa.
DELIMITER //
CREATE FUNCTION productos_por_empresa(comp_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
  RETURN (
    SELECT COUNT(DISTINCT product_id) FROM company_products WHERE company_id = comp_id
  );
END;//
DELIMITER ;

-- 14. Como gerente, deseo una función que retorne el nivel de actividad de un cliente (frecuente, esporádico, inactivo), según su número de calificaciones.
DELIMITER //
CREATE FUNCTION nivel_actividad_cliente(cust_id INT)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT COUNT(*) INTO total FROM rates WHERE customer_id = cust_id;
  RETURN CASE
    WHEN total >= 20 THEN 'Frecuente'
    WHEN total >= 5  THEN 'Esporádico'
    ELSE 'Inactivo'
  END;
END;//
DELIMITER ;

-- 15. Como administrador, quiero una función que calcule el precio promedio ponderado de un producto, tomando en cuenta su uso en favoritos.
DELIMITER //
CREATE FUNCTION precio_promedio_ponderado(prod_id INT)
RETURNS DOUBLE
DETERMINISTIC
BEGIN
  DECLARE favs INT;
  SELECT COUNT(*) INTO favs FROM details_favorites WHERE product_id = prod_id;
  RETURN (
    SELECT AVG(price) FROM company_products WHERE product_id = prod_id
  ) * (1 + favs * 0.01);
END;//
DELIMITER ;

-- 16.Como técnico, deseo una función que me indique si un benefit_id está asignado a más de una audiencia o membresía (valor booleano).
DELIMITER //
CREATE FUNCTION beneficio_multiaudiencia(ben_id INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
  RETURN (
    SELECT COUNT(DISTINCT audience_id) FROM audience_benefits WHERE benefit_id = ben_id
  ) > 1;
END;//
DELIMITER ;

-- 17. Como cliente, quiero una función que, dada mi ciudad, retorne un índice de variedad basado en número de empresas y productos.
DELIMITER //
CREATE FUNCTION indice_variedad(ciudad INT)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE empresas INT;
  DECLARE productos INT;
  SELECT COUNT(*) INTO empresas FROM companies WHERE city_id = ciudad;
  SELECT COUNT(DISTINCT cp.product_id) INTO productos
  FROM companies c
  JOIN company_products cp ON c.id = cp.company_id
  WHERE c.city_id = ciudad;
  RETURN empresas * productos;
END;//
DELIMITER ;

-- 18. Como gestor de calidad, deseo una función que evalúe si un producto debe ser desactivado por tener baja calificación histórica.
DELIMITER //
CREATE FUNCTION desactivar_por_baja_calidad(prod_id INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
  RETURN (
    SELECT AVG(rating) FROM quality_products WHERE product_id = prod_id
  ) < 2.5;
END;//
DELIMITER ;

-- 19.Como desarrollador, quiero una función que calcule el índice de popularidad de un producto (combinando favoritos y ratings).
DELIMITER //
CREATE FUNCTION indice_popularidad(prod_id INT)
RETURNS DOUBLE
DETERMINISTIC
BEGIN
  DECLARE favs INT;
  DECLARE prom DOUBLE;
  SELECT COUNT(*) INTO favs FROM details_favorites WHERE product_id = prod_id;
  SELECT AVG(rating) INTO prom FROM quality_products WHERE product_id = prod_id;
  RETURN favs * 0.5 + IFNULL(prom,0) * 2;
END;//
DELIMITER ;

-- 20.Como auditor, deseo una función que genere un código único basado en el nombre del producto y su fecha de creación.
DELIMITER //
CREATE FUNCTION codigo_unico_producto(prod_id INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
  RETURN (
    SELECT CONCAT(UCASE(SUBSTRING(name,1,3)), DATE_FORMAT(created_at,'%Y%m%d'), prod_id)
    FROM   products WHERE id = prod_id
  );
END;//
DELIMITER ;
