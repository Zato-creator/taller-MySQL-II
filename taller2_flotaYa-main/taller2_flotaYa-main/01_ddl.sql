-- =========================================================================
-- TALLER 2 · FLOTAYA
-- FASE 2: DEFINICIÓN DE ESTRUCTURA Y RESTRICCIONES (DDL)
-- Archivo: 01_ddl.sql
-- =========================================================================

DROP DATABASE IF EXISTS flotaya;
CREATE DATABASE flotaya CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE flotaya;

-- 1. Sedes / Sucursales de operación
CREATE TABLE branches (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    address VARCHAR(255) NOT NULL,
    phone VARCHAR(30) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Empleados (Conductores, Logística, Administrativos)
CREATE TABLE employees (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    document_number VARCHAR(30) UNIQUE NOT NULL,
    role ENUM('ADMINISTRADOR', 'CONDUCTOR', 'LOGISTICA', 'ATENCION_CLIENTE') NOT NULL,
    branch_id BIGINT NOT NULL,
    status ENUM('ACTIVO', 'VACACIONES', 'INACTIVO') DEFAULT 'ACTIVO',
    CONSTRAINT fk_employee_branch FOREIGN KEY (branch_id) REFERENCES branches(id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- 3. Clientes (Remitentes y Destinatarios)
CREATE TABLE clients (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    document_number VARCHAR(30) UNIQUE NOT NULL,
    phone VARCHAR(30) NOT NULL,
    email VARCHAR(100),
    address VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Flota de Vehículos
CREATE TABLE vehicles (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    plate VARCHAR(20) UNIQUE NOT NULL,
    brand VARCHAR(50) NOT NULL,
    model_year INT NOT NULL,
    capacity_kg DECIMAL(10,2) NOT NULL,
    status ENUM('DISPONIBLE', 'EN_RUTA', 'MANTENIMIENTO', 'FUERA_DE_SERVICIO') DEFAULT 'DISPONIBLE',
    branch_id BIGINT NOT NULL,
    CONSTRAINT chk_vehicle_capacity CHECK (capacity_kg > 0),
    CONSTRAINT chk_vehicle_year CHECK (model_year >= 2000),
    CONSTRAINT fk_vehicle_branch FOREIGN KEY (branch_id) REFERENCES branches(id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- 5. Rutas Predefinidas
CREATE TABLE routes (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    origin_city VARCHAR(100) NOT NULL,
    destination_city VARCHAR(100) NOT NULL,
    estimated_hours DECIMAL(5,2) NOT NULL,
    base_cost DECIMAL(10,2) NOT NULL,
    CONSTRAINT chk_route_hours CHECK (estimated_hours > 0),
    CONSTRAINT chk_route_cost CHECK (base_cost >= 0)
);

-- 6. Envíos / Paquetes (Núcleo del negocio)
CREATE TABLE shipments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    tracking_code VARCHAR(50) UNIQUE NOT NULL,
    sender_id BIGINT NOT NULL,
    receiver_id BIGINT NOT NULL,
    origin_branch_id BIGINT NOT NULL,
    destination_branch_id BIGINT NOT NULL,
    route_id BIGINT NOT NULL,
    weight_kg DECIMAL(8,2) NOT NULL,
    declared_value DECIMAL(12,2) NOT NULL,
    status ENUM('REGISTRADO', 'EN_TRANSITO', 'EN_REPARTO', 'ENTREGADO', 'DEVUELTO') DEFAULT 'REGISTRADO',
    shipping_date DATE NOT NULL,
    estimated_delivery_date DATE NOT NULL,
    CONSTRAINT chk_shipment_weight CHECK (weight_kg > 0),
    CONSTRAINT chk_shipment_value CHECK (declared_value >= 0),
    CONSTRAINT chk_shipment_dates CHECK (estimated_delivery_date >= shipping_date),
    CONSTRAINT fk_shipment_sender FOREIGN KEY (sender_id) REFERENCES clients(id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_shipment_receiver FOREIGN KEY (receiver_id) REFERENCES clients(id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_shipment_origin FOREIGN KEY (origin_branch_id) REFERENCES branches(id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_shipment_destination FOREIGN KEY (destination_branch_id) REFERENCES branches(id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_shipment_route FOREIGN KEY (route_id) REFERENCES routes(id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- 7. Asignación de Viajes (Vehículo + Conductor en ruta)
CREATE TABLE trip_assignments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    shipment_id BIGINT NOT NULL,
    vehicle_id BIGINT NOT NULL,
    driver_id BIGINT NOT NULL,
    dispatch_date DATETIME NOT NULL,
    arrival_date DATETIME NULL,
    status ENUM('ASIGNADO', 'EN_CAMINO', 'COMPLETADO', 'INCIDENCIA') DEFAULT 'ASIGNADO',
    CONSTRAINT chk_trip_dates CHECK (arrival_date IS NULL OR arrival_date >= dispatch_date),
    CONSTRAINT fk_trip_shipment FOREIGN KEY (shipment_id) REFERENCES shipments(id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_trip_vehicle FOREIGN KEY (vehicle_id) REFERENCES vehicles(id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_trip_driver FOREIGN KEY (driver_id) REFERENCES employees(id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);
