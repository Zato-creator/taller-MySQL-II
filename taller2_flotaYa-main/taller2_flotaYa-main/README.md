Markdown
# 🚚 Taller 2: Sistema de Gestión Logística · FlotaYa

Repositorio oficial para el desarrollo del segundo taller práctico de bases de datos, enfocado en el diseño, estructuración, manipulación y control transaccional para la empresa de transporte y encomiendas **FlotaYa**.

---

## 📂 Estructura del Repositorio

El proyecto se encuentra organizado modularmente en la siguiente estructura de archivos dentro de la carpeta de trabajo:

* **`00_diagrama.png`** ➔ Imagen gráfica completa del Modelo Entidad-Relación (DER) diseñado en DrawSQL.
* **`00_diagrama.md`** ➔ Documentación conceptual y justificación de la normalización del modelo relacional.
* **`01_ddl.sql`** ➔ Script de creación de la base de datos, tablas, tipos de datos, restricciones (`CHECK`, `ENUM`, `UNIQUE`) y llaves foráneas con integridad referencial.
* **`02_dml.sql`** ➔ Poblamiento inicial de datos semilla (sedes, empleados, clientes, flota, rutas, envíos y viajes) junto con operaciones de mantenimiento y pruebas de error.
* **`03_dql.sql`** ➔ Consultas y reportes lógicos básicos y medios utilizando filtros, ordenamientos, uniones (`JOIN`) y agrupaciones (`GROUP BY`).
* **`04_dql_avanzado.sql`** ➔ Consultas avanzadas utilizando Subconsultas, Funciones de Ventana (`RANK()`, `SUM() OVER`) y Vistas (`VIEW`) operativas.
* **`05_tcl.sql`** ➔ Manejo de transacciones seguras mediante `START TRANSACTION`, `COMMIT`, `ROLLBACK` y puntos de salvado (`SAVEPOINT`).

---

## 🛠️ Tecnologías y Entorno
* **Gestor de Base de Datos:** MySQL / MariaDB (Compatible con MySQL 8.0+).
* **Herramienta de Modelado:** DrawSQL.
* **Entorno de Desarrollo:** Visual Studio Code.
* **Control de Versiones:** Git y GitHub.

---