SQL
-- =========================================================================
-- TALLER 2 · FLOTAYA
-- FASE 4: CONSULTAS Y REPORTES LOGÍSTICOS (DQL BÁSICO Y MEDIO)
-- Archivo: 03_dql.sql
-- =========================================================================

USE flotaya;

-- -------------------------------------------------------------------------
-- 1. CONSULTAS BÁSICAS Y FILTRADAS (SELECT, WHERE, ORDER BY)
-- -------------------------------------------------------------------------

-- Listar todos los vehículos que se encuentran actualmente disponibles para asignación
SELECT 
    id AS vehiculo_id,
    plate AS placa,
    brand AS marca,
    model_year AS modelo,
    capacity_kg AS capacidad_carga
FROM vehicles
WHERE status = 'DISPONIBLE'
ORDER BY capacity_kg DESC;

-- Consultar los envíos que se encuentran en tránsito o reparto actualmente
SELECT 
    tracking_code AS codigo_rastreo,
    weight_kg AS peso_kg,
    declared_value AS valor_declarado,
    status AS estado_actual,
    shipping_date AS fecha_envio,
    estimated_delivery_date AS entrega_estimada
FROM shipments
WHERE status IN ('EN_TRANSITO', 'EN_REPARTO')
ORDER BY shipping_date ASC;

-- -------------------------------------------------------------------------
-- 2. CONSULTAS CON UNIONES (JOIN) PARA TRAZABILIDAD LOGÍSTICA
-- -------------------------------------------------------------------------

-- Ver el detalle completo de un envío: remitente, destinatario, ruta y ciudades origen/destino
SELECT 
    s.tracking_code AS guia,
    c_sender.full_name AS remitente,
    c_receiver.full_name AS destinatario,
    b_orig.city AS ciudad_origen,
    b_dest.city AS ciudad_destino,
    r.estimated_hours AS horas_ruta,
    s.status AS estado_envio
FROM shipments s
JOIN clients c_sender ON s.sender_id = c_sender.id
JOIN clients c_receiver ON s.receiver_id = c_receiver.id
JOIN branches b_orig ON s.origin_branch_id = b_orig.id
JOIN branches b_dest ON s.destination_branch_id = b_dest.id
JOIN routes r ON s.route_id = r.id;

-- Consultar la asignación de viajes actual (Qué conductor lleva qué vehículo y qué envío)
SELECT 
    ta.id AS id_asignacion,
    s.tracking_code AS guia_envio,
    CONCAT(e.first_name, ' ', e.last_name) AS nombre_conductor,
    e.document_number AS cedula_conductor,
    v.plate AS placa_vehiculo,
    ta.dispatch_date AS fecha_despacho,
    ta.status AS estado_viaje
FROM trip_assignments ta
JOIN shipments s ON ta.shipment_id = s.id
JOIN employees e ON ta.driver_id = e.id
JOIN vehicles v ON ta.vehicle_id = v.id;

-- -------------------------------------------------------------------------
-- 3. CONSULTAS DE RESUMEN Y ESTADÍSTICAS (GROUP BY, SUM, COUNT, AVG)
-- -------------------------------------------------------------------------

-- Calcular el peso total de encomiendas y cantidad de envíos gestionados por cada sede de origen
SELECT 
    b.name AS sede_origen,
    b.city AS ciudad,
    COUNT(s.id) AS total_envios_realizados,
    SUM(s.weight_kg) AS peso_acumulado_kg,
    AVG(s.declared_value) AS valor_promedio_declarado
FROM branches b
LEFT JOIN shipments s ON b.id = s.origin_branch_id
GROUP BY b.id, b.name, b.city;

-- Conteo de vehículos agrupados por su estado operativo en la flota
SELECT 
    status AS estado_vehiculo,
    COUNT(*) AS cantidad_vehiculos,
    SUM(capacity_kg) AS capacidad_total_kg
FROM vehicles
GROUP BY status;

-- Consultar los ingresos base estimados acumulados por cada ruta logística
SELECT 
    CONCAT(r.origin_city, ' ➔ ', r.destination_city) AS ruta_trayecto,
    r.estimated_hours AS tiempo_estimado_horas,
    r.base_cost AS costo_base,
    COUNT(s.id) AS total_encomiendas_enviadas,
    (r.base_cost * COUNT(s.id)) AS ingreso_teorico_generado
FROM routes r
LEFT JOIN shipments s ON r.id = s.route_id
GROUP BY r.id, r.origin_city, r.destination_city, r.estimated_hours, r.base_cost;