-- 1. ADMINISTRADOR: Acceso total al sistema

CREATE USER IF NOT EXISTS 'admin'@'localhost' IDENTIFIED BY 'Admin123?';

GRANT ALL PRIVILEGES ON Ambientalistas.* TO 'admin'@'localhost';

show grants for 'admin'@'localhost';


-- 2. GESTOR DE PARQUES: Gestión de parques, áreas y especies

CREATE USER IF NOT EXISTS 'gestor_parques'@'localhost' IDENTIFIED BY 'Gestion123?';


GRANT SELECT, INSERT, UPDATE, DELETE ON Ambientalistas.parque TO 'gestor_parques'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON Ambientalistas.area TO 'gestor_parques'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON Ambientalistas.especie TO 'gestor_parques'@'localhost';


GRANT SELECT, INSERT, UPDATE, DELETE ON Ambientalistas.departamentoParque TO 'gestor_parques'@'localhost';


GRANT SELECT ON Ambientalistas.departamento TO 'gestor_parques'@'localhost';
GRANT SELECT ON Ambientalistas.entidad TO 'gestor_parques'@'localhost';
GRANT SELECT ON Ambientalistas.conservacionArea TO 'gestor_parques'@'localhost';
GRANT SELECT ON Ambientalistas.vigilanciaArea TO 'gestor_parques'@'localhost';
GRANT SELECT ON Ambientalistas.proyectoEspecie TO 'gestor_parques'@'localhost';

-- Permisos para ejecutar procedimientos relacionados con parques y especies
GRANT EXECUTE ON PROCEDURE Ambientalistas.registrar_parque TO 'gestor_parques'@'localhost';
GRANT EXECUTE ON PROCEDURE Ambientalistas.registrar_area TO 'gestor_parques'@'localhost';
GRANT EXECUTE ON PROCEDURE Ambientalistas.registrar_especie TO 'gestor_parques'@'localhost';
GRANT EXECUTE ON PROCEDURE Ambientalistas.actualizar_cantidad_especie TO 'gestor_parques'@'localhost';
GRANT EXECUTE ON PROCEDURE Ambientalistas.obtener_estadisticas_parque TO 'gestor_parques'@'localhost';
GRANT EXECUTE ON PROCEDURE Ambientalistas.buscar_especies TO 'gestor_parques'@'localhost';
show grants for 'gestor_parques'@'localhost';

-- 3. INVESTIGADOR: Acceso a datos de proyectos y especies

CREATE USER IF NOT EXISTS 'investigador'@'localhost' IDENTIFIED BY 'Investigador123?';

-- Permisos de lectura para tablas de investigación
GRANT SELECT ON Ambientalistas.proyecto TO 'investigador'@'localhost';
GRANT SELECT ON Ambientalistas.especie TO 'investigador'@'localhost';
GRANT SELECT ON Ambientalistas.area TO 'investigador'@'localhost';
GRANT SELECT ON Ambientalistas.parque TO 'investigador'@'localhost';
GRANT SELECT ON Ambientalistas.proyectoEspecie TO 'investigador'@'localhost';
GRANT SELECT ON Ambientalistas.investigadorProyecto TO 'investigador'@'localhost';
GRANT SELECT ON Ambientalistas.investigador TO 'investigador'@'localhost';

-- Permisos para actualizar datos de proyectos específicos
GRANT UPDATE ON Ambientalistas.proyecto TO 'investigador'@'localhost';
GRANT INSERT, UPDATE ON Ambientalistas.proyectoEspecie TO 'investigador'@'localhost';

-- Permisos para actualizar cantidad de especies (para registrar cambios en investigaciones)
GRANT UPDATE (cantidad) ON Ambientalistas.especie TO 'investigador'@'localhost';

-- Permisos para ejecutar procedimientos relacionados con investigación
GRANT EXECUTE ON PROCEDURE Ambientalistas.obtener_proyectos_activos TO 'investigador'@'localhost';
GRANT EXECUTE ON PROCEDURE Ambientalistas.buscar_especies TO 'investigador'@'localhost';
GRANT EXECUTE ON PROCEDURE Ambientalistas.actualizar_cantidad_especie TO 'investigador'@'localhost';
GRANT EXECUTE ON PROCEDURE Ambientalistas.generar_reporte_biodiversidad TO 'investigador'@'localhost';
show grants for 'investigador'@'localhost';
-- 4. AUDITOR: Acceso a reportes financieros
CREATE USER IF NOT EXISTS 'auditor'@'localhost' IDENTIFIED BY 'Auditor123?';

-- Permisos de solo lectura para tablas financieras y de recursos
GRANT SELECT ON Ambientalistas.proyecto TO 'auditor'@'localhost';
GRANT SELECT ON Ambientalistas.personal TO 'auditor'@'localhost';
GRANT SELECT ON Ambientalistas.historial_presupuestos TO 'auditor'@'localhost';
GRANT SELECT ON Ambientalistas.historial_sueldos TO 'auditor'@'localhost';

-- Permisos de lectura para tablas relacionadas con recursos
GRANT SELECT ON Ambientalistas.vehiculo TO 'auditor'@'localhost';
GRANT SELECT ON Ambientalistas.alojamiento TO 'auditor'@'localhost';
GRANT SELECT ON Ambientalistas.parque TO 'auditor'@'localhost';
GRANT SELECT ON Ambientalistas.area TO 'auditor'@'localhost';

-- Permisos para ejecutar procedimientos de reportes financieros
GRANT EXECUTE ON FUNCTION Ambientalistas.calcular_presupuesto_diario TO 'auditor'@'localhost';
GRANT EXECUTE ON FUNCTION Ambientalistas.calcular_sueldo_promedio TO 'auditor'@'localhost';
GRANT EXECUTE ON FUNCTION Ambientalistas.costo_proyectos_investigador TO 'auditor'@'localhost';
show grants for 'auditor'@'localhost';

-- 5. ENCARGADO DE VISITANTES: Gestión de visitantes y alojamientos
CREATE USER IF NOT EXISTS 'encargado_visitantes'@'localhost' IDENTIFIED BY 'VisitantesG123?';

-- Permisos para gestionar visitantes y alojamientos
GRANT SELECT, INSERT, UPDATE, DELETE ON Ambientalistas.visitante TO 'encargado_visitantes'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON Ambientalistas.alojamiento TO 'encargado_visitantes'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON Ambientalistas.visitanteAlojamiento TO 'encargado_visitantes'@'localhost';

-- Permisos de lectura para tablas relacionadas
GRANT SELECT ON Ambientalistas.gestion TO 'encargado_visitantes'@'localhost';
GRANT SELECT ON Ambientalistas.parque TO 'encargado_visitantes'@'localhost';
GRANT SELECT ON Ambientalistas.area TO 'encargado_visitantes'@'localhost';

-- Permisos para ejecutar procedimientos relacionados con visitantes
GRANT EXECUTE ON PROCEDURE Ambientalistas.registrar_visitante TO 'encargado_visitantes'@'localhost';
GRANT EXECUTE ON PROCEDURE Ambientalistas.asignar_alojamiento TO 'encargado_visitantes'@'localhost';
GRANT EXECUTE ON PROCEDURE Ambientalistas.obtener_ocupacion_alojamientos TO 'encargado_visitantes'@'localhost';
GRANT EXECUTE ON FUNCTION Ambientalistas.alojamiento_disponible TO 'encargado_visitantes'@'localhost';
GRANT EXECUTE ON FUNCTION Ambientalistas.calcular_porcentaje_ocupacion TO 'encargado_visitantes'@'localhost';

show grants for 'encargado_visitantes'@'localhost';

FLUSH PRIVILEGES;



/*
EXPLICACIÓN DE ROLES Y PERMISOS:

1. ADMINISTRADOR (admin_ambiental):
   - Acceso total a todas las tablas y operaciones en la base de datos
   - Puede crear/modificar usuarios y asignar permisos
   - Responsable de la configuración general del sistema

2. GESTOR DE PARQUES (gestor_parques):
   - Gestión completa de parques, áreas y especies (CRUD)
   - Puede registrar nuevos parques y áreas protegidas
   - Puede actualizar información sobre especies y su cantidad
   - Acceso de solo lectura a información relacionada (departamentos, entidades)
   - Puede ejecutar procedimientos específicos para la gestión de parques

3. INVESTIGADOR (investigador):
   - Acceso de lectura a datos de proyectos y especies
   - Puede actualizar información de proyectos específicos
   - Puede actualizar la cantidad de especies (para registrar cambios en investigaciones)
   - Puede ejecutar procedimientos para obtener información sobre biodiversidad
   - No puede modificar información estructural de parques o áreas

4. AUDITOR (auditor):
   - Acceso de solo lectura a información financiera y de recursos
   - Puede ver presupuestos de proyectos y sueldos del personal
   - Puede acceder al historial de cambios en presupuestos y sueldos
   - Puede ejecutar funciones para calcular indicadores financieros
   - No puede modificar ninguna información en la base de datos

5. ENCARGADO DE VISITANTES (encargado_visitantes):
   - Gestión completa de visitantes y alojamientos (CRUD)
   - Puede registrar nuevos visitantes y asignarles alojamiento
   - Puede actualizar el estado de ocupación de los alojamientos
   - Acceso de solo lectura a información relacionada (parques, áreas)
   - Puede ejecutar procedimientos específicos para la gestión de visitantes

NOTAS DE SEGURIDAD:
- Cada usuario tiene una contraseña segura que debe ser cambiada periódicamente
- Los permisos están limitados al mínimo necesario para cada rol
- Se recomienda revisar periódicamente los permisos de cada usuario
- En un entorno de producción, considere usar conexiones cifradas (SSL/TLS)
*/
