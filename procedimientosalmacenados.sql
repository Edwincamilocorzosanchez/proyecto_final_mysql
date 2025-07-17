
-- PROCEDIMIENTOS ALMACENADOS

-- 1. Registrar una nueva calificación y actualizar el promedio del producto
DELIMITER //
CREATE PROCEDURE RegistrarCalificacion(IN prod_id INT, IN cust_id INT, IN poll_id INT, IN rating_val DOUBLE)
BEGIN
  INSERT INTO quality_products(product_id, customer_id, poll_id, company_id, date_rating, rating)
  VALUES (prod_id, cust_id, poll_id, NULL, NOW(), rating_val);
END;//
DELIMITER ;

-- 2. Insertar empresa y asociar productos por defecto
DELIMITER //
CREATE PROCEDURE InsertarEmpresaConProductos(
  IN nombre_empresa VARCHAR(80), IN tipo_id INT, IN categoria_id INT,
  IN ciudad_id INT, IN audiencia_id INT, IN celular VARCHAR(15), IN correo VARCHAR(80))
BEGIN
  DECLARE nueva_empresa_id INT;
  INSERT INTO companies(name, type_id, category_id, city_id, audience_id, cellphone, email)
  VALUES (nombre_empresa, tipo_id, categoria_id, ciudad_id, audiencia_id, celular, correo);
  SET nueva_empresa_id = LAST_INSERT_ID();

  INSERT INTO company_products(company_id, product_id, price, unitmeasure_id)
  SELECT nueva_empresa_id, id, price, NULL FROM products;
END;//
DELIMITER ;

-- 3. Añadir producto favorito validando duplicados
DELIMITER //
CREATE PROCEDURE AñadirFavorito(IN cust_id INT, IN prod_id INT)
BEGIN
  DECLARE fav_id INT;
  SELECT id INTO fav_id FROM favorites WHERE customer_id = cust_id LIMIT 1;
  IF fav_id IS NULL THEN
    INSERT INTO favorites(customer_id, company_id) VALUES (cust_id, NULL);
    SET fav_id = LAST_INSERT_ID();
  END IF;
  IF NOT EXISTS (SELECT 1 FROM details_favorites WHERE favorite_id = fav_id AND product_id = prod_id) THEN
    INSERT INTO details_favorites(favorite_id, product_id) VALUES (fav_id, prod_id);
  END IF;
END;//
DELIMITER ;

-- 4. Generar resumen mensual de calificaciones por empresa
DELIMITER //
CREATE PROCEDURE ResumenMensualCalificaciones()
BEGIN
  CREATE TEMPORARY TABLE IF NOT EXISTS resumen_calificaciones (
    empresa_id INT,
    mes VARCHAR(10),
    promedio DOUBLE
  );

  INSERT INTO resumen_calificaciones(empresa_id, mes, promedio)
  SELECT company_id, DATE_FORMAT(date_rating, '%Y-%m'), AVG(rating)
  FROM quality_products
  GROUP BY company_id, DATE_FORMAT(date_rating, '%Y-%m');
END;//
DELIMITER ;

-- 5. Calcular beneficios activos por membresía
DELIMITER //
CREATE PROCEDURE BeneficiosActivosPorMembresia()
BEGIN
  SELECT mb.membership_id, b.description
  FROM membership_benefits mb
  JOIN benefits b ON mb.benefit_id = b.id
  JOIN membership_periods mp ON mb.membership_id = mp.membership_id AND mb.period_id = mp.period_id
  WHERE CURDATE() BETWEEN mp.id AND mp.id; -- ajustar según fechas reales
END;//
DELIMITER ;

-- 6. Eliminar productos huérfanos
DELIMITER //
CREATE PROCEDURE EliminarProductosHuerfanos()
BEGIN
  DELETE FROM products
  WHERE id NOT IN (SELECT product_id FROM company_products)
  AND id NOT IN (SELECT product_id FROM quality_products);
END;//
DELIMITER ;

-- 7. Actualizar precios de productos por categoría
DELIMITER //
CREATE PROCEDURE ActualizarPreciosPorCategoria(IN categoria INT, IN factor DECIMAL(5,2))
BEGIN
  UPDATE company_products cp
  JOIN products p ON cp.product_id = p.id
  SET cp.price = cp.price * factor
  WHERE p.category_id = categoria;
END;//
DELIMITER ;

-- 8. Validar inconsistencias entre rates y quality_products
DELIMITER //
CREATE PROCEDURE ValidarInconsistencias()
BEGIN
  CREATE TEMPORARY TABLE errores_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    descripcion TEXT
  );

  INSERT INTO errores_log(descripcion)
  SELECT CONCAT('Rate sin quality: ID=', r.id)
  FROM rates r
  LEFT JOIN quality_products q ON r.customer_id = q.customer_id AND r.company_id = q.company_id
  WHERE q.id IS NULL;
END;//
DELIMITER ;

-- 9. Asignar beneficios a nuevas audiencias
DELIMITER //
CREATE PROCEDURE AsignarBeneficios(IN beneficio_id INT, IN audiencia_id INT)
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM audience_benefits WHERE benefit_id = beneficio_id AND audience_id = audiencia_id
  ) THEN
    INSERT INTO audience_benefits(audience_id, benefit_id)
    VALUES (audiencia_id, beneficio_id);
  END IF;
END;//
DELIMITER ;

-- 10. Activar planes de membresía vencidos con pago confirmado
UPDATE membership_periods
SET activo = TRUE
WHERE pago_confirmado = TRUE
  AND fecha_fin < CURDATE();



-- 11. Listar productos favoritos del cliente por su calificación 
DELIMITER //
CREATE PROCEDURE ProductosFavoritosConRating(IN cliente_id INT)
BEGIN
  SELECT p.name, AVG(q.rating) AS promedio
  FROM favorites f
  JOIN details_favorites df ON f.id = df.favorite_id
  JOIN products p ON df.product_id = p.id
  LEFT JOIN quality_products q ON q.product_id = p.id AND q.customer_id = f.customer_id
  WHERE f.customer_id = cliente_id
  GROUP BY p.name;
END;//
DELIMITER ;

-- 12. Registrar encuesta y preguntas asociadas 
DELIMITER $$

CREATE PROCEDURE registrar_encuesta_con_preguntas (
    IN p_nombre_encuesta VARCHAR(80),
    IN p_descripcion TEXT,
    IN p_activa BOOLEAN,
    IN p_categoria_id INT,
    IN p_preguntas TEXT
)
BEGIN
    DECLARE encuesta_id INT;
    DECLARE pregunta TEXT;
    DECLARE posicion_inicio INT DEFAULT 1;
    DECLARE posicion_delimitador INT;
    

    INSERT INTO polls (name, description, is_active, categorypoll_id)
    VALUES (p_nombre_encuesta, p_descripcion, p_activa, p_categoria_id);
    
    SET encuesta_id = LAST_INSERT_ID();


    WHILE posicion_inicio <= CHAR_LENGTH(p_preguntas) DO
        SET posicion_delimitador = LOCATE(';', p_preguntas, posicion_inicio);
        
        IF posicion_delimitador = 0 THEN
            SET pregunta = TRIM(SUBSTRING(p_preguntas, posicion_inicio));
            SET posicion_inicio = CHAR_LENGTH(p_preguntas) + 1;
        ELSE
            SET pregunta = TRIM(SUBSTRING(p_preguntas, posicion_inicio, posicion_delimitador - posicion_inicio));
            SET posicion_inicio = posicion_delimitador + 1;
        END IF;
        
        IF pregunta != '' THEN
            INSERT INTO poll_questions (poll_id, question)
            VALUES (encuesta_id, pregunta);
        END IF;
    END WHILE;
END $$

DELIMITER ;


-- 13. Eliminar favoritos antiguos sin calificaciones
DELIMITER //
CREATE PROCEDURE BorrarFavoritosAntiguos()
BEGIN
  DELETE df FROM details_favorites df
  JOIN favorites f ON df.favorite_id = f.id
  LEFT JOIN quality_products qp ON df.product_id = qp.product_id
  WHERE qp.id IS NULL AND f.id IN (
    SELECT id FROM favorites
    WHERE DATEDIFF(NOW(), id) > 365
  );
END;//
DELIMITER ;

-- 14. Asociar beneficios automáticamente por audiencia
DELIMITER //
CREATE PROCEDURE AsociarBeneficiosPorAudiencia()
BEGIN
  INSERT IGNORE INTO audience_benefits(audience_id, benefit_id)
  SELECT DISTINCT mb.audience_id, mb.benefit_id
  FROM membership_benefits mb;
END;//
DELIMITER ;

-- 15. Historial de cambios de precio 
DELIMITER $$

CREATE PROCEDURE actualizar_precio_producto (
    IN p_company_product_id INT,
    IN p_nuevo_precio DOUBLE
)
BEGIN
    DECLARE precio_actual DOUBLE;

    SELECT price INTO precio_actual
    FROM company_products
    WHERE id = p_company_product_id;


    IF precio_actual IS NOT NULL AND precio_actual != p_nuevo_precio THEN

        INSERT INTO historial_precios (company_product_id, precio_anterior, precio_nuevo)
        VALUES (p_company_product_id, precio_actual, p_nuevo_precio);
        

        UPDATE company_products
        SET price = p_nuevo_precio
        WHERE id = p_company_product_id;
    END IF;
END $$

DELIMITER ;


-- 16. Registrar encuesta activa automáticamente
DELIMITER //
CREATE PROCEDURE RegistrarEncuestaActiva(IN nombre_encuesta VARCHAR(80), IN descripcion TEXT, IN categoria_id INT)
BEGIN
  INSERT INTO polls(name, description, is_active, categorypoll_id)
  VALUES(nombre_encuesta, descripcion, TRUE, categoria_id);
END;//
DELIMITER ;

-- 17. Actualizar unidad de medida de productos sin afectar ventas
DELIMITER //
CREATE PROCEDURE ActualizarUnidadMedida(IN prod_id INT, IN nueva_unidad INT)
BEGIN
  IF NOT EXISTS (SELECT 1 FROM quality_products WHERE product_id = prod_id) THEN
    UPDATE company_products SET unitmeasure_id = nueva_unidad WHERE product_id = prod_id;
  END IF;
END;//
DELIMITER ;

-- 18. Recalcular promedios de calidad semanalmente
DELIMITER //
CREATE PROCEDURE RecalcularPromedios()
BEGIN
  UPDATE products p
  SET detail = CONCAT('Promedio actualizado: ', IFNULL((
    SELECT ROUND(AVG(rating),2) FROM quality_products WHERE product_id = p.id
  ), '0'));
END;//
DELIMITER ;

-- 19. Validar claves foráneas entre calificaciones y encuestas
DELIMITER //
CREATE PROCEDURE ValidarPollsEnRates()
BEGIN
  SELECT r.id FROM rates r
  LEFT JOIN polls p ON r.poll_id = p.id
  WHERE p.id IS NULL;
END;//
DELIMITER ;

-- 20. Top 10 productos más calificados por ciudad
DELIMITER //
CREATE PROCEDURE Top10ProductosPorCiudad()
BEGIN
  SELECT ciudad, producto, total FROM (
    SELECT ci.name AS ciudad, p.name AS producto, COUNT(*) AS total,
           RANK() OVER (PARTITION BY ci.name ORDER BY COUNT(*) DESC) AS ranking
    FROM quality_products qp
    JOIN products p ON qp.product_id = p.id
    JOIN companies c ON qp.company_id = c.id
    JOIN cities_municipalities ci ON c.city_id = ci.id
    GROUP BY ciudad, producto
  ) AS sub
  WHERE ranking <= 10;
END;//
DELIMITER ;
