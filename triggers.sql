
-- DISPARADORES (TRIGGERS)

-- 1. Actualizar la fecha de modificación de un producto
DELIMITER //

CREATE TRIGGER before_update_producto
BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
  SET NEW.updated_at = NOW();
END;
//

DELIMITER ;


-- 2. Registrar log cuando un cliente califica un producto
DELIMITER //

CREATE TRIGGER after_insert_rate_log
AFTER INSERT ON rates
FOR EACH ROW
BEGIN
  INSERT INTO log_acciones(cliente_id, empresa_id, accion, fecha)
  VALUES (NEW.customer_id, NEW.company_id, 'Calificación empresa', NOW());
END;
//

DELIMITER ;

-- 3. Impedir insertar productos sin unidad de medida
DELIMITER //

CREATE TRIGGER before_insert_company_product_unit
BEFORE INSERT ON company_products
FOR EACH ROW
BEGIN
  IF NEW.unitmeasure_id IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Debe especificar unidad de medida';
  END IF;
END;
//

DELIMITER ;


-- 4. Validar calificaciones no mayores a 5
DELIMITER //
CREATE TRIGGER before_insert_rate_validacion
BEFORE INSERT ON rates
FOR EACH ROW
BEGIN
  IF NEW.rating > 5 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La calificación no puede ser mayor a 5';
  END IF;
END;//
DELIMITER ;

-- 5. Actualizar estado de membresía cuando vence
DELIMITER //
CREATE TRIGGER update_membresia_estado
BEFORE UPDATE ON membership_periods
FOR EACH ROW
BEGIN
  IF NEW.end_date < CURDATE() THEN
    SET NEW.status = 'INACTIVA';
  END IF;
END;//
DELIMITER ;

-- 6. Evitar duplicados de productos por empresa
DELIMITER //
CREATE TRIGGER before_insert_companyproduct_unique
BEFORE INSERT ON company_products
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1 FROM company_products
    WHERE company_id = NEW.company_id AND product_id = NEW.product_id
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Producto ya asociado a esta empresa';
  END IF;
END;//
DELIMITER ;

-- 7. Enviar notificación al añadir un favorito
DELIMITER //
CREATE TRIGGER after_insert_favorito
AFTER INSERT ON details_favorites
FOR EACH ROW
BEGIN
  INSERT INTO notificaciones(cliente_id, mensaje, fecha)
  SELECT f.customer_id, CONCAT('Has añadido el producto ID ', NEW.product_id, ' a favoritos'), NOW()
  FROM favorites f WHERE f.id = NEW.favorite_id;
END;//
DELIMITER ;

-- 8. Insertar fila en quality_products tras calificación
DELIMITER //
CREATE TRIGGER after_insert_rate_quality
AFTER INSERT ON rates
FOR EACH ROW
BEGIN
  INSERT INTO quality_products(product_id, customer_id, poll_id, rating, date_rating, company_id)
  VALUES (NEW.product_id, NEW.customer_id, NEW.poll_id, NEW.rating, NOW(), NEW.company_id);
END;
//
DELIMITER ;


-- 9. Eliminar favoritos si se elimina el producto
DELIMITER //
CREATE TRIGGER after_delete_producto_favoritos
AFTER DELETE ON products
FOR EACH ROW
BEGIN
  DELETE FROM details_favorites WHERE product_id = OLD.id;
END;//
DELIMITER ;

-- 10. Bloquear modificación de audiencias activas
DELIMITER //
CREATE TRIGGER before_update_audiencia
BEFORE UPDATE ON audiences
FOR EACH ROW
BEGIN
  IF OLD.status = 'ACTIVA' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede modificar una audiencia activa';
  END IF;
END;
//
DELIMITER ;


-- 11. Recalcular promedio de calidad del producto tras nueva evaluación
DELIMITER //
CREATE TRIGGER after_insert_rate_promedio
AFTER INSERT ON rates
FOR EACH ROW
BEGIN
  UPDATE products p
  SET p.detail = CONCAT('Promedio calificación: ', ROUND((
      SELECT AVG(rating) FROM rates WHERE product_id = NEW.product_id
  ),2))
  WHERE p.id = NEW.product_id;
END;//
DELIMITER ;

-- 12. Registrar asignación de nuevo beneficio
DELIMITER //
CREATE TRIGGER after_insert_beneficio_log
AFTER INSERT ON membership_benefits
FOR EACH ROW
BEGIN
  INSERT INTO log_acciones(accion, detalle, fecha)
  VALUES ('Nuevo Beneficio', CONCAT('Beneficio ', NEW.benefit_id, ' asignado a Membresía ', NEW.membership_id), NOW());
END;//
DELIMITER ;

-- 13. Impedir doble calificación por parte del cliente
DELIMITER //
CREATE TRIGGER before_insert_rate_unica
BEFORE INSERT ON rates
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1 FROM rates WHERE customer_id = NEW.customer_id AND product_id = NEW.product_id
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ya calificaste este producto';
  END IF;
END;//
DELIMITER ;

-- 14. Validar correos duplicados en clientes
DELIMITER //
CREATE TRIGGER before_insert_cliente_correo
BEFORE INSERT ON customers
FOR EACH ROW
BEGIN
  IF EXISTS (SELECT 1 FROM customers WHERE email = NEW.email) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Correo ya registrado';
  END IF;
END;//
DELIMITER ;

-- 15. Eliminar detalles de favoritos huérfanos 
DELIMITER //
CREATE TRIGGER after_delete_favorite_cleanup
AFTER DELETE ON favorites
FOR EACH ROW
BEGIN
  DELETE FROM details_favorites WHERE favorite_id = OLD.id;
END;//
DELIMITER ;

-- 16. Actualizar campo updated_at en companies
DELIMITER //
CREATE TRIGGER before_update_company_timestamp
BEFORE UPDATE ON companies
FOR EACH ROW
BEGIN
  SET NEW.updated_at = NOW();
END;
//
DELIMITER ;


-- 17. Impedir borrar ciudad si hay empresas activas
DELIMITER //
CREATE TRIGGER before_delete_city_companies
BEFORE DELETE ON cities_municipalities
FOR EACH ROW
BEGIN
  IF EXISTS (SELECT 1 FROM companies WHERE city_id = OLD.id) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede eliminar la ciudad con empresas registradas';
  END IF;
END;//
DELIMITER ;

-- 18. Registrar cambios de estado en encuestas
DELIMITER //
CREATE TRIGGER after_update_poll_status
AFTER UPDATE ON polls
FOR EACH ROW
BEGIN
  IF OLD.is_active <> NEW.is_active THEN
    INSERT INTO log_acciones(accion, detalle, fecha)
    VALUES('Cambio Estado Encuesta', CONCAT('Poll ', OLD.id, ' estado de ', OLD.is_active, ' a ', NEW.is_active), NOW());
  END IF;
END;//
DELIMITER ;

-- 19. Sincronizar rates y quality_products 
DELIMITER //
CREATE TRIGGER after_insert_rate_sync
AFTER INSERT ON rates
FOR EACH ROW
BEGIN
  UPDATE quality_products
  SET rating = NEW.rating, date_rating = NEW.date_rating
  WHERE product_id = NEW.product_id AND customer_id = NEW.customer_id
  LIMIT 1;
END;//
DELIMITER ;

-- 20. Eliminar productos sin relación a empresas
DELIMITER //
CREATE TRIGGER after_delete_companyproduct_cleanup
AFTER DELETE ON company_products
FOR EACH ROW
BEGIN
  IF NOT EXISTS (SELECT 1 FROM company_products WHERE product_id = OLD.product_id) THEN
    DELETE FROM products WHERE id = OLD.product_id;
  END IF;
END;//
DELIMITER ;

