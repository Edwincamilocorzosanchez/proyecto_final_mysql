
-- EVENTOS PROGRAMADOS

-- 1. Borrar productos sin actividad cada 6 meses
CREATE EVENT IF NOT EXISTS borrar_productos_inactivos
ON SCHEDULE EVERY 6 MONTH
DO
  DELETE FROM products
  WHERE id NOT IN (SELECT product_id FROM rates)
    AND id NOT IN (SELECT product_id FROM favorites)
    AND id NOT IN (SELECT product_id FROM company_products);

-- 2. Recalcular el promedio de calificaciones semanalmente
CREATE EVENT IF NOT EXISTS recalcular_promedios
ON SCHEDULE EVERY 1 WEEK
DO
  UPDATE products p
  SET detail = CONCAT('Promedio actualizado: ', IFNULL((
    SELECT ROUND(AVG(rating),2)
    FROM quality_products
    WHERE product_id = p.id
  ), '0'));

-- 3. Actualizar precios según inflación mensual
CREATE EVENT IF NOT EXISTS actualizar_precios_inflacion
ON SCHEDULE EVERY 1 MONTH
DO
  UPDATE company_products
  SET price = price * 1.03;

-- 4. Crear backups lógicos diariamente
CREATE EVENT IF NOT EXISTS backup_diario
ON SCHEDULE EVERY 1 DAY STARTS CURRENT_DATE + INTERVAL 1 DAY
DO
  INSERT INTO products_backup (SELECT * FROM products);

-- 5. Notificar sobre productos favoritos sin calificar
CREATE EVENT IF NOT EXISTS notificar_favoritos_sin_calificar
ON SCHEDULE EVERY 1 WEEK
DO
  INSERT INTO user_reminders (customer_id, product_id)
  SELECT f.customer_id, df.product_id
  FROM favorites f
  JOIN details_favorites df ON f.id = df.favorite_id
  LEFT JOIN rates r ON r.product_id = df.product_id AND r.customer_id = f.customer_id
  WHERE r.id IS NULL;

-- 6. Revisar inconsistencias entre empresa y productos
CREATE EVENT IF NOT EXISTS revisar_inconsistencias
ON SCHEDULE EVERY 1 WEEK
DO
  INSERT INTO errores_log(descripcion)
  SELECT CONCAT('Producto sin empresa: ', p.name)
  FROM products p
  WHERE NOT EXISTS (SELECT 1 FROM company_products cp WHERE cp.product_id = p.id);

-- 7. Archivar membresías vencidas diariamente
CREATE EVENT IF NOT EXISTS archivar_membresias
ON SCHEDULE EVERY 1 DAY
DO
  UPDATE membership_periods
  SET status = 'INACTIVA'
  WHERE end_date < CURDATE();

-- 8. Notificar beneficios nuevos a usuarios semanalmente
CREATE EVENT IF NOT EXISTS notificar_nuevos_beneficios
ON SCHEDULE EVERY 1 WEEK
DO
  INSERT INTO notificaciones (mensaje, created_at)
  SELECT CONCAT('Nuevo beneficio disponible: ', name), NOW()
  FROM benefits
  WHERE created_at >= NOW() - INTERVAL 7 DAY;

-- 9. Calcular cantidad de favoritos por cliente mensualmente
CREATE EVENT IF NOT EXISTS resumen_favoritos_clientes
ON SCHEDULE EVERY 1 MONTH
DO
  INSERT INTO favoritos_resumen (customer_id, total)
  SELECT f.customer_id, COUNT(df.product_id)
  FROM favorites f
  JOIN details_favorites df ON f.id = df.favorite_id
  GROUP BY f.customer_id;

-- 10. Validar claves foráneas semanalmente
CREATE EVENT IF NOT EXISTS validar_fk_rates
ON SCHEDULE EVERY 1 WEEK
DO
  INSERT INTO inconsistencias_fk (descripcion)
  SELECT CONCAT('Rate con poll inexistente ID: ', r.id)
  FROM rates r
  LEFT JOIN polls p ON r.poll_id = p.id
  WHERE p.id IS NULL;

-- 11. Eliminar calificaciones inválidas antiguas
CREATE EVENT IF NOT EXISTS eliminar_rates_invalidas
ON SCHEDULE EVERY 1 MONTH
DO
  DELETE FROM rates
  WHERE (rating IS NULL OR rating < 0)
    AND created_at < NOW() - INTERVAL 3 MONTH;

-- 12. Cambiar estado de encuestas inactivas
CREATE EVENT IF NOT EXISTS inactivar_encuestas
ON SCHEDULE EVERY 1 MONTH
DO
  UPDATE polls
  SET status = 'INACTIVA'
  WHERE id NOT IN (
    SELECT DISTINCT poll_id FROM rates
    WHERE created_at >= NOW() - INTERVAL 6 MONTH
  );

-- 13. Registrar auditorías diarias de forma periódica
CREATE EVENT IF NOT EXISTS registrar_auditorias
ON SCHEDULE EVERY 1 DAY
DO
  INSERT INTO auditorias_diarias (fecha, total_productos, total_usuarios)
  VALUES (CURDATE(), (SELECT COUNT(*) FROM products), (SELECT COUNT(*) FROM customers));

-- 14. Notificar métricas de calidad a empresas
CREATE EVENT IF NOT EXISTS notificar_metricas_calidad
ON SCHEDULE EVERY 1 WEEK STARTS CURRENT_DATE + INTERVAL 1 WEEK
DO
  INSERT INTO notificaciones_empresa (empresa_id, mensaje)
  SELECT c.id, CONCAT('Su producto ', p.name, ' tiene promedio ', ROUND(AVG(q.rating),2))
  FROM companies c
  JOIN company_products cp ON c.id = cp.company_id
  JOIN products p ON cp.product_id = p.id
  JOIN quality_products q ON q.product_id = p.id
  GROUP BY c.id, p.name;

-- 15. Recordar renovación de membresías
CREATE EVENT IF NOT EXISTS recordar_renovacion_membresias
ON SCHEDULE EVERY 1 WEEK
DO
  INSERT INTO recordatorios (customer_id, mensaje)
  SELECT customer_id, 'Tu membresía está próxima a vencer'
  FROM membership_periods
  WHERE end_date BETWEEN CURDATE() AND CURDATE() + INTERVAL 7 DAY;

-- 16. Reordenar estadísticas generales cada semana
CREATE EVENT IF NOT EXISTS actualizar_estadisticas_generales
ON SCHEDULE EVERY 1 WEEK
DO
  UPDATE estadisticas
  SET total_productos = (SELECT COUNT(*) FROM products),
      total_empresas = (SELECT COUNT(*) FROM companies),
      total_clientes = (SELECT COUNT(*) FROM customers);

-- 17. Crear resúmenes temporales de uso por categoría
CREATE EVENT IF NOT EXISTS resumen_uso_por_categoria
ON SCHEDULE EVERY 1 MONTH
DO
  INSERT INTO resumen_categoria (categoria_id, total)
  SELECT category_id, COUNT(*)
  FROM products
  JOIN quality_products USING(product_id)
  GROUP BY category_id;

-- 18. Actualizar beneficios caducados
CREATE EVENT IF NOT EXISTS desactivar_beneficios_expirados
ON SCHEDULE EVERY 1 DAY
DO
  UPDATE benefits
  SET status = 'INACTIVO'
  WHERE expires_at IS NOT NULL AND expires_at < CURDATE();

-- 19. Alertar productos sin evaluación anual
CREATE EVENT IF NOT EXISTS alertar_sin_evaluacion
ON SCHEDULE EVERY 1 MONTH
DO
  INSERT INTO alertas_productos(product_id, mensaje)
  SELECT id, 'Producto sin evaluación anual'
  FROM products
  WHERE id NOT IN (
    SELECT DISTINCT product_id FROM quality_products
    WHERE date_rating >= NOW() - INTERVAL 1 YEAR
  );

-- 20. Actualizar precios con índice externo
CREATE EVENT IF NOT EXISTS actualizar_precio_por_indice
ON SCHEDULE EVERY 1 MONTH
DO
  UPDATE company_products cp
  JOIN inflacion_indice ii ON 1=1
  SET cp.price = cp.price * ii.valor
  WHERE ii.fecha = (SELECT MAX(fecha) FROM inflacion_indice);
