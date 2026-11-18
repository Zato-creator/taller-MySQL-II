SQL
-- =========================================================================
-- TALLER 2 · FLOTAYA
-- FASE 5: CONSULTAS AVANZADAS, VISTAS Y FUNCIONES DE VENTANA (DQL AVANZADO)
-- Archivo: 04_dql_avanzado.sql
-- =========================================================================

USE flotaya;

-- -------------------------------------------------------------------------
-- 1. SUBCONSULTAS (SUBQUERIES)
-- -------------------------------------------------------------------------

-- Encontrar los envíos cuyo valor declarado sea superior al promedio de todos los envíos registrados
SELECT 
    tracking_code AS guia,
    weight_kg AS peso_kg,
    declared_value AS valor_declarado,
    status AS estado
FROM shipments
WHERE declared_value > (
    SELECT AVG(declared_value) 
    FROM shipments
)
ORDER BY declared_value DESC;

-- Listar los clientes que han realizado al menos un envío con un valor declarado mayor a 2,000,000
SELECT 
    id AS cliente_id,
    full_name AS nombre_cliente,
    document_number AS cedula,
    phone AS telefono
FROM clients
WHERE id IN (
    SELECT sender_id 
    FROM shipments 
    WHERE declared_value > 2000000.00
);

-- -------------------------------------------------------------------------
-- 2. FUNCIONES DE VENTANA (WINDOW FUNCTIONS)
-- -------------------------------------------------------------------------

-- Ranking de los envíos más costosos dentro de cada ruta específica usando RANK()
SELECT 
    r.origin_city AS origen,
    r.destination_city AS destino,
    s.tracking_code AS guia,
    s.declared_value AS valor_declarado,
    RANK() OVER (PARTITION BY s.route_id ORDER BY s.declared_value DESC) AS ranking_valor_en_ruta
FROM shipments s
JOIN routes r ON s.route_id = r.id;

-- Calcular el acumulado progresivo (running total) del peso de los envíos ordenados por fecha de despacho
SELECT 
    shipping_date AS fecha,
    tracking_code AS guia,
    weight_kg AS peso_paquete,
    SUM(weight_kg) OVER (ORDER BY shipping_date, id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS peso_acumulado_red
FROM shipments;

-- -------------------------------------------------------------------------
-- 3. CREACIÓN DE VISTAS (VIEWS) PARA REPORTES EJECUTIVOS
-- -------------------------------------------------------------------------

-- Eliminar la vista si ya existe para evitar conflictos al reejecutar el script
DROP VIEW IF EXISTS vw_detalle_operativo_envios;

-- Crear una vista consolidada que une toda la información clave de un envío para los tableros de control
CREATE VIEW vw_detalle_operativo_envios AS
SELECT 
    s.id AS shipment_id,
    s.tracking_code,
    s.status AS estado_envio,
    s.shipping_date,
    s.estimated_delivery_date,
    sc.full_name AS remitente,
    rc.full_name AS destinatario,
    bo.city AS ciudad_origen,
    bd.city AS ciudad_destino,
    rt.estimated_hours,
    s.weight_kg,
    s.declared_value
FROM shipments s
JOIN clients sc ON s.sender_id = sc.id
JOIN clients rc ON s.receiver_id = rc.id
JOIN branches bo ON s.origin_branch_id = bo.id
JOIN branches bd ON s.destination_branch_id = bd.id
JOIN routes rt ON s.route_id = rt.id;

-- Consulta de prueba utilizando la vista recién creada
SELECT 
    tracking_code,
    remitente,
    destinatario,
    CONCAT(ciudad_origen, ' ➔ ', ciudad_destino) AS trayecto,
    estado_envio,
    CONCAT('$', FORMAT(declared_value, 2)) AS valor
FROM vw_detalle_operativo_envios
WHERE estado_envio != 'ENTREGADO';