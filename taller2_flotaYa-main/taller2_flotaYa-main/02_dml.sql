-- =========================================================================
-- TALLER 2 · FLOTAYA
-- FASE 3: MANIPULACIÓN DE DATOS Y PRUEBAS DE INTEGRIDAD (DML)
-- Archivo: 02_dml.sql
-- =========================================================================

USE flotaya;

-- -------------------------------------------------------------------------
-- 1. POBLAMIENTO INICIAL DE DATOS (INSERT)
-- -------------------------------------------------------------------------

-- Sedes de operación
INSERT INTO branches (name, city, address, phone) VALUES
('Sede Principal Bucaramanga', 'Bucaramanga', 'Calle 36 # 15-40 Centro', '6076341200'),
('Centro Logístico Bogotá', 'Bogotá', 'Avenida El Dorado # 68B-85', '6014258900'),
('Terminal Norte Medellín', 'Medellín', 'Carrera 64C # 78-580', '6043204510'),
('Sucursal Costa Barranquilla', 'Barranquilla', 'Vía 40 # 73-290', '6053851120');

-- Empleados (Administrativos, Logística y Conductores)
INSERT INTO employees (first_name, last_name, document_number, role, branch_id, status) VALUES
('Carlos', 'Mendoza', '1098654321', 'ADMINISTRADOR', 1, 'ACTIVO'),
('Laura', 'Gómez', '1095812345', 'LOGISTICA', 1, 'ACTIVO'),
('Andrés', 'Rojas', '91234567', 'CONDUCTOR', 1, 'ACTIVO'),
('Jhonatan', 'Pérez', '1098741258', 'CONDUCTOR', 2, 'ACTIVO'),
('Diana', 'Castillo', '52987654', 'ATENCION_CLIENTE', 2, 'ACTIVO'),
('Luis', 'Fernández', '79456123', 'CONDUCTOR', 3, 'VACACIONES'),
('Miguel', 'Torres', '1098321654', 'CONDUCTOR', 1, 'ACTIVO');

-- Clientes (Remitentes y Destinatarios)
INSERT INTO clients (full_name, document_number, phone, email, address) VALUES
('Distribuidora Santander S.A.S', '900456789-1', '3152345678', 'logistica@distsantander.com', 'Parque Industrial Etapa 2 Bodega 4, Bucaramanga'),
('Comercializadora El Sol', '901123456-4', '3109876543', 'compras@elsolbogota.com', 'Zona Franca Fontibón Bodega 12, Bogotá'),
('María Fernanda Silva', '63541289', '3184561230', 'mafe.silva@correo.com', 'Carrera 33 # 48-12 Cabecera, Bucaramanga'),
('Jorge Iván Restrepo', '71258963', '3007418529', 'jirestrepo@correo.com', 'Calle 10 # 43A-25 El Poblado, Medellín'),
('Suministros del Caribe Ltda', '800963852-7', '3018529634', 'despachos@sumicaribe.co', 'Calle 72 # 54-35, Barranquilla');

-- Flota de Vehículos
INSERT INTO vehicles (plate, brand, model_year, capacity_kg, status, branch_id) VALUES
('WXY-451', 'Chevrolet NHR', 2022, 2500.00, 'DISPONIBLE', 1),
('TRK-892', 'Hino FC9J', 2021, 5200.00, 'EN_RUTA', 1),
('LMP-104', 'JAC X200', 2023, 1800.00, 'DISPONIBLE', 2),
('BGT-773', 'Foton Aumark', 2020, 4500.00, 'MANTENIMIENTO', 3),
('KLM-339', 'Renault Master', 2024, 1500.00, 'DISPONIBLE', 2);

-- Rutas Predefinidas
INSERT INTO routes (origin_city, destination_city, estimated_hours, base_cost) VALUES
('Bucaramanga', 'Bogotá', 8.50, 185000.00),
('Bucaramanga', 'Medellín', 7.00, 165000.00),
('Bogotá', 'Medellín', 9.00, 195000.00),
('Bucaramanga', 'Barranquilla', 10.50, 230000.00),
('Bogotá', 'Bucaramanga', 8.50, 185000.00);

-- Envíos / Paquetes
INSERT INTO shipments (
    tracking_code, sender_id, receiver_id, origin_branch_id, destination_branch_id, 
    route_id, weight_kg, declared_value, status, shipping_date, estimated_delivery_date
) VALUES
('FY-2026-0001', 1, 2, 1, 2, 1, 450.50, 3500000.00, 'EN_TRANSITO', '2026-11-15', '2026-11-16'),
('FY-2026-0002', 3, 4, 1, 3, 2, 12.80, 450000.00, 'REGISTRADO', '2026-11-17', '2026-11-18'),
('FY-2026-0003', 2, 1, 2, 1, 5, 820.00, 6200000.00, 'ENTREGADO', '2026-11-10', '2026-11-11'),
('FY-2026-0004', 1, 5, 1, 4, 4, 310.00, 2800000.00, 'EN_REPARTO', '2026-11-16', '2026-11-17'),
('FY-2026-0005', 4, 2, 3, 2, 3, 95.40, 1100000.00, 'REGISTRADO', '2026-11-17', '2026-11-19');

-- Asignación de Viajes
INSERT INTO trip_assignments (shipment_id, vehicle_id, driver_id, dispatch_date, arrival_date, status) VALUES
(1, 2, 3, '2026-11-15 06:30:00', NULL, 'EN_CAMINO'),
(3, 3, 4, '2026-11-10 07:00:00', '2026-11-10 16:15:00', 'COMPLETADO'),
(4, 1, 7, '2026-11-16 05:45:00', NULL, 'EN_CAMINO');

-- -------------------------------------------------------------------------
-- 2. OPERACIONES DE ACTUALIZACIÓN Y MANTENIMIENTO (UPDATE / DELETE)
-- -------------------------------------------------------------------------

-- Actualizar estado de un envío que acaba de llegar y marcar su viaje como completado
UPDATE shipments 
SET status = 'ENTREGADO' 
WHERE tracking_code = 'FY-2026-0001';

UPDATE trip_assignments 
SET arrival_date = '2026-11-16 15:20:00', status = 'COMPLETADO' 
WHERE shipment_id = 1;

-- Liberar el vehículo TRK-892 una vez finalizada la ruta
UPDATE vehicles 
SET status = 'DISPONIBLE' 
WHERE plate = 'TRK-892';

-- Reajustar tarifa base en un 5% para rutas largas mayores a 9 horas
UPDATE routes 
SET base_cost = ROUND(base_cost * 1.05, 2) 
WHERE estimated_hours > 9.00;

-- Eliminar un envío recién registrado por cancelación del cliente (sin viajes asignados)
DELETE FROM shipments 
WHERE tracking_code = 'FY-2026-0005' AND status = 'REGISTRADO';

-- -------------------------------------------------------------------------
-- 3. PRUEBAS DE VALIDACIÓN DE RESTRICCIONES (BLOQUE DE VERIFICACIÓN)
-- Descomentar individualmente para comprobar que el motor rechaza errores
-- -------------------------------------------------------------------------

/*
-- Prueba 1: Intentar registrar un vehículo con capacidad negativa (Debe fallar por chk_vehicle_capacity)
INSERT INTO vehicles (plate, brand, model_year, capacity_kg, branch_id) 
VALUES ('ERR-001', 'Chevrolet', 2022, -500.00, 1);

-- Prueba 2: Intentar registrar un envío con fecha de entrega anterior al envío (Debe fallar por chk_shipment_dates)
INSERT INTO shipments (tracking_code, sender_id, receiver_id, origin_branch_id, destination_branch_id, route_id, weight_kg, declared_value, shipping_date, estimated_delivery_date)
VALUES ('FY-ERR-01', 1, 2, 1, 2, 1, 10.00, 100000.00, '2026-11-20', '2026-11-18');

-- Prueba 3: Intentar asignar un rol inexistente en el ENUM (Debe fallar por restricción de dominio)
INSERT INTO employees (first_name, last_name, document_number, role, branch_id) 
VALUES ('Pedro', 'Test', '999888777', 'PILOTO_AVION', 1);

-- Prueba 4: Intentar borrar una sede que tiene vehículos y empleados asociados (Debe fallar por ON DELETE RESTRICT)
DELETE FROM branches WHERE id = 1;
*/