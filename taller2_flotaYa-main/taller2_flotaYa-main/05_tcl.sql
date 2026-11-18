SQL
-- =========================================================================
-- TALLER 2 · FLOTAYA
-- FASE 6: CONTROL DE TRANSACCIONES (TCL)
-- Archivo: 05_tcl.sql
-- =========================================================================

USE flotaya;

-- -------------------------------------------------------------------------
-- ESCENARIO TRANSACCIONAL: REGISTRO INTEGRAL DE UN NUEVO ENVÍO Y SU VIAJE
-- Garantiza que si falla la asignación del vehículo, no quede el envío huérfano.
-- -------------------------------------------------------------------------

-- 1. Iniciar la transacción formal
START TRANSACTION;

-- Paso A: Insertar un nuevo envío urgente
INSERT INTO shipments (
    tracking_code, sender_id, receiver_id, origin_branch_id, destination_branch_id, 
    route_id, weight_kg, declared_value, status, shipping_date, estimated_delivery_date
) VALUES (
    'FY-2026-9999', 1, 3, 1, 1, 
    2, 125.00, 1850000.00, 'REGISTRADO', '2026-11-17', '2026-11-18'
);

-- Obtener el ID del envío recién insertado para usarlo en la asignación
SET @nuevo_envio_id = LAST_INSERT_ID();

-- Crear un punto de salvado (Savepoint) justo antes de la asignación del vehículo
SAVEPOINT antes_de_asignar_viaje;

-- Paso B: Asignar el vehículo disponible y el conductor al envío
INSERT INTO trip_assignments (
    shipment_id, vehicle_id, driver_id, dispatch_date, status
) VALUES (
    @nuevo_envio_id, 1, 7, '2026-11-17 08:00:00', 'ASIGNADO'
);

-- Paso C: Actualizar el estado del vehículo a 'EN_RUTA'
UPDATE vehicles 
SET status = 'EN_RUTA' 
WHERE id = 1;

-- Simulación de validación (Si todo sale bien, confirmamos los cambios de forma permanente)
COMMIT;

-- Nota: Si ocurriera algún error lógico o falta de inventario/capacidad, 
-- se ejecutaría un ROLLBACK TO antes_de_asignar_viaje o un ROLLBACK general.


-- -------------------------------------------------------------------------
-- EJEMPLO DE TRANSACCIÓN CON ROLLBACK (Simulando una anomalía o cancelación)
-- -------------------------------------------------------------------------

START TRANSACTION;

-- Intentamos registrar un envío de prueba crítico
INSERT INTO shipments (
    tracking_code, sender_id, receiver_id, origin_branch_id, destination_branch_id, 
    route_id, weight_kg, declared_value, status, shipping_date, estimated_delivery_date
) VALUES (
    'FY-FAIL-001', 2, 4, 2, 3, 
    3, 50.00, 500000.00, 'REGISTRADO', '2026-11-17', '2026-11-18'
);

SAVEPOINT envio_registrado;

-- Simulamos que el vehículo seleccionado presenta una falla mecánica imprevista 
-- y decidimos abortar la operación de despacho revirtiendo hasta el savepoint:
ROLLBACK TO envio_registrado;

-- El envío queda retenido o se cancela formalmente haciendo un ROLLBACK total de la TX:
ROLLBACK;