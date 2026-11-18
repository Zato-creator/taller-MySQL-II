"Para FlotaYa organicé el sistema pensando en el flujo real de una empresa de envíos. Lo dividí en 7 tablas principales bien relacionadas:

Tenemos las sedes y los empleados (donde filtramos roles como conductores o administrativos).

Los clientes, que hacen las veces de remitentes y destinatarios.

La flota de vehículos y las rutas predefinidas con sus costos base.

El corazón del negocio que son los envíos (shipments), amarrados a quién lo manda, quién lo recibe, por dónde viaja y cuál es su estado actual.

Y finalmente la tabla de asignación de viajes, que une al vehículo y al conductor con el envío específico para tener trazabilidad en tiempo real de la mercancía."



# Diseño del Modelo Entidad-Relación · FlotaYa

Para este segundo taller de **FlotaYa**, diseñé una base de datos que resuelve la operación logística de una empresa de transporte de encomiendas. Me enfoqué en que la información esté bien ordenada, que no se repita y que las tablas se conecten de forma lógica.

---

## 📋 Estructura General y Tablas Principales

El modelo consta de **7 tablas principales** que representan los actores y procesos del negocio:

1. **`branches` (Sedes):** Almacena las sucursales u oficinas físicas de la empresa en distintas ciudades.
2. **`employees` (Empleados):** Contiene al personal registrado (administrativos, personal de logística y conductores), enlazado directamente a su sucursal de origen mediante una llave foránea.
3. **`clients` (Clientes):** Guarda los datos tanto de los remitentes (quienes envían) como de los destinatarios (quienes reciben).
4. **`vehicles` (Flota):** Registra los vehículos de carga de la empresa (placa, marca, modelo, capacidad en kg) y su sede asignada.
5. **`routes` (Rutas):** Define las rutas preestablecidas entre ciudades, incluyendo las horas estimadas y el costo base.
6. **`shipments` (Envíos - Núcleo del negocio):** Es la tabla central donde se registra cada paquete. Conecta al remitente, al destinatario, la sede de origen, la sede de destino, la ruta elegida, el peso, el valor declarado y el estado actual del envío.
7. **`trip_assignments` (Asignación de Viajes):** Vincula el envío directamente con el vehículo y el conductor asignado, permitiendo llevar un control de cuándo salió y cuándo llegó a su destino.

---

## 📐 Justificación de la Normalización

Para evitar dolores de cabeza con los datos y mantener la base de datos limpia, apliqué los principios de normalización:

* **1FN (Primera Forma Normal):** Me aseguré de que cada columna guarde un solo valor atómico. Por ejemplo, los datos de contacto, las direcciones o los estados no se amontonan en una sola celda, sino que cada atributo vive en su propia columna específica.
* **2FN (Segunda Forma Normal):** Todos los datos detallados de una entidad dependen exclusivamente de su llave principal (`id`). Por ejemplo, en la tabla de envíos o de vehículos no repetimos la información completa de la sede o de las rutas; en su lugar, utilizamos llaves foráneas (`branch_id`, `route_id`) para apuntar al registro correcto sin duplicar texto.
* **3FN (Tercera Forma Normal):** No hay dependencias transitivas ocultas. Los costos base, los tiempos de ruta o las capacidades de los vehículos están en sus tablas independientes, garantizando que si cambia una tarifa o un dato, solo debamos actualizarlo en un único lugar.

---

## 🖼️ Visualización del Modelo

El diagrama gráfico completo de la base de datos se encuentra guardado en la imagen **`00_diagrama.png`** dentro de esta misma carpeta, el cual fue diseñado para ilustrar claramente las relaciones de uno a muchos (`1:N`) entre sedes, vehículos, empleados y envíos.