

## 1. Descripción del Proyecto

El proyecto "los Ambientalistas" se creo con el fin de poder administrar los parques naturales, sus áreas y las especies que habitan en ellas, se pretende facilitar el seguimiento y el control de los parques naturales, su biodiversidad, personal asignado, proyectos y la gestión de los visitantes.

El principal proposito de la base de datos es proporcionar una herramienta que permita:

- Registrar y hacer un control a los parques naturales y sus áreas protegidas
- Poder catalogar y gestionar a especies vegetales, animales y minerales
- Gestionar el personal encargado de la conservación, vigilancia e investigación
- Administrar proyectos de conservación e investigación
- Gestionar las visitas y sus alojamientos


El sistema permite la generación de reportes estadísticos, seguimiento de indicadores ambientales, y facilita la toma de decisiones para la conservación de ecosistemas y especies en peligro.

## 2. Requisitos del Sistema

Para poder ejecutar la base de datos "Ambientalistas", se requiere:

- **Servidor de base de datos**: Un servidor MySQL 8.0 o superior (puede ser local, remoto o incluido en tu paquete de instalación)
- **DBeaver**: Como tu aplicación principal para gestionar bases de datos 
- **Espacio en disco**: Mínimo 500 MB para la base de datos inicial y su crecimiento
- **Memoria RAM**: Mínimo 4 GB para un rendimiento óptimo
- **Sistema Operativo**: Cualquier SO compatible con DBeaver (Windows, Linux, macOS)


## 3. Instalación y Configuración

Siga estos pasos para configurar y poner en marcha el sistema "Ambientalistas" utilizando exclusivamente DBeaver:

### 3.1. Creación de la Base de Datos

1. Abra DBeaver y asegúrese de tener una conexión configurada a un servidor MySQL:
2. Si aún no tiene una conexión, haga clic en el ícono "Nueva conexión" en la barra de herramientas
3. Seleccione "MySQL" como tipo de conexión
4. Complete los datos de conexión al servidor MySQL que utiliza
5. Ingrese el usuario como Campus2023 y la contraseña Campus2023
6. Pruebe la conexión antes de guardarla.
7. Con su conexión MySQL activa en DBeaver:
8. Haga clic derecho en la conexión y seleccione "Crear" → "Base de datos"
9. Introduzca "Ambientalistas" como nombre de la base de datos
10. Seleccione el conjunto de caracteres y collation adecuados (recomendamos utf8mb4_unicode_ci)
11. Haga clic en "OK" para crear la base de datos
12. Alternativamente, puede crear la base de datos mediante script SQL, en el documento DDL esta el script  para crearla.
13. Haga clic derecho en su conexión y seleccione "Abrir editor SQL"
14. Escriba y ejecute:


```sql
CREATE DATABASE IF NOT EXISTS Ambientalistas;
```

1. Para trabajar con la nueva base de datos:

2. En el navegador de DBeaver, expanda su conexión MySQL

3. Haga clic derecho en la base de datos "Ambientalistas" y seleccione "Establecer como predeterminada"

4. En el DDL ya se establece como predeterminada con el siguiente comando;


```sql
USE Ambientalistas;
```

1. Verifique que la base de datos esté seleccionada:

2. La base de datos activa generalmente se muestra en negrita en el navegador de DBeaver

3. O puede ejecutar `SELECT DATABASE();` para confirmar


### 3.2. Ejecución del Archivo DDL (Estructura)

1. Abra el archivo `ddl.sql` en su cliente MySQL.
2. Ejecute el script completo para crear todas las tablas y relaciones.
3. Verifique que todas las tablas se hayan creado correctamente con:

```sql
SHOW TABLES;
```

4. En caso de cualquier inconveniente comunicarse al correo Danrodri1911@gmail.com


### 3.3. Carga de Datos Iniciales (DML)

1. Abra el archivo `dml.sql` en su cliente MySQL.
2. Ejecute el script para cargar los datos iniciales en todas las tablas.
3. Verifique que los datos se hayan cargado correctamente con consultas básicas:

```sql
select count(id) as departamento from departamento d ;
select count(id) as area from area;
select count(id) as alojamiento from alojamiento a ; 
select count(id) as conservacion from conservacion c;
select count(*) as ca from conservacionArea ca ;  
select count(*) as dp from departamentoParque dp ;
SELECT count(id)as entidad from entidad e ;
select count(id) as especie from especie;
select count(id) as gestion from gestion;
select count(id)as investigador from investigador i;
select count(*) as invp from investigadorProyecto ip ; 
select count(id) as parque from parque;
select count(id) as personal from personal;
select count(id) as proyecto from proyecto p ;
select count(*) as prye from proyectoEspecie pe ;
SELECT count(id)as vehiculo from vehiculo v ;
select count(id) as vigilancia from vigilancia v ;
select count(*) as viga from vigilanciaArea va; 
select count(id) as visitante from visitante v; 
select count(*) as va from visitanteAlojamiento va  ; 
```

4. Estas consultas se encuentran al final del documento para rectificar los datos.


### 3.4. Configuración de Procedimientos, Funciones, Eventos y Triggers

1. Abra el archivo `procedimientos.sql` y ejecútelo para crear todos los procedimientos almacenados.
2. Abra el archivo `funciones.sql` y ejecútelo para crear todas las funciones.
3. Abra el archivo `eventos.sql` y ejecútelo para configurar los eventos programados.
4. Abra el archivo `triggers.sql` y ejecútelo para implementar los triggers.
5. Verifique la correcta creación con:

```sql
SHOW PROCEDURE STATUS WHERE Db = 'Ambientalistas';
SHOW FUNCTION STATUS WHERE Db = 'Ambientalistas';
SHOW TRIGGERS FROM Ambientalistas;
SHOW EVENTS FROM Ambientalistas;
```




### 3.5. Configuración de Usuarios y Permisos

1. Abra el archivo `usuarios.sql` y ejecútelo para crear los roles de usuario con sus respectivos permisos.
2. Verifique la creación de usuarios con:

```sql
SELECT user FROM mysql.user WHERE user LIKE '%ambiental%' OR user LIKE '%gestor%' OR user LIKE '%investigador%' OR user LIKE '%auditor%' OR user LIKE '%visitantes%';
```




## 4. Estructura de la Base de Datos

El sistema "Ambientalistas" está compuesto por las siguientes tablas principales:

### Tablas Principales

- **parque**: Almacena información sobre los parques naturales, incluyendo nombre, fecha de declaración y superficie total.
- **entidad**: Registra las entidades responsables de la gestión de los parques.
- **departamento**: Contiene los departamentos geográficos donde se ubican los parques.
- **departamentoParque**: Tabla de relación entre departamentos y parques.
- **area**: Registra las áreas específicas dentro de cada parque, con su extensión en kilometros.
- **especie**: Cataloga las especies (vegetales, animales, minerales) presentes en las áreas, con su cantidad.
- **proyecto**: Almacena los proyectos de conservación e investigación, con presupuesto y fechas.
- **proyectoEspecie**: Relaciona proyectos con las especies que estudian o protegen.
- **personal**: Registra el personal que trabaja en el sistema, con sus datos y tipo de trabajador.
- **gestion**: Personal encargado de la gestión administrativa y las visitas.
- **vigilancia**: Personal encargado de la vigilancia de áreas.
- **conservacion**: Personal dedicado a la conservación de especies y áreas.
- **investigador**: Personal científico que realiza investigaciones.
- **vehiculo**: Registra los vehículos utilizados por el personal de vigilancia.
- **visitante**: Almacena información sobre los visitantes a los parques.
- **alojamiento**: Registra las opciones de alojamiento disponibles para visitantes.
- **visitanteAlojamiento**: Relaciona visitantes con sus alojamientos asignados.


### Tablas de Soporte y Registro

- **historial_especies**: Registra cambios en la cantidad de especies.
- **historial_presupuestos**: Almacena modificaciones en presupuestos de proyectos.
- **historial_sueldos**: Guarda cambios en los sueldos del personal.
- **log_sistema**: Registra eventos importantes del sistema.
- **alertas_conservacion**: Almacena alertas sobre especies en peligro.
- **estadisticas_visitantes**: Guarda estadísticas periódicas de visitantes.
- **estadisticas_especies**: Almacena datos estadísticos sobre especies.
- **indicadores_ambientales**: Registra indicadores de calidad ambiental.


## 5. Ejemplos de Consultas

### Consultas Básicas

1. **Cantidad de parques por departamento**:

```sql
SELECT d.nombre AS departamento, COUNT(dp.idParque) AS cantidad_parques
FROM departamento d
LEFT JOIN departamentoParque dp ON d.id = dp.idDepartamento
GROUP BY d.nombre;
```

Esta consulta muestra cuántos parques hay en cada departamento geográfico.


2. **Superficie total por área**:

```sql
SELECT p.nombre AS parque, SUM(a.extencionArea) AS superficie_total
FROM parque p
LEFT JOIN area a ON p.id = a.idParque
GROUP BY p.nombre;
```

Muestra la superficie total de cada parque sumando sus áreas.


3. **Distribución de especies por tipo**:

```sql
SELECT tipoEspecie, COUNT(*) AS cantidad
FROM especie
GROUP BY tipoEspecie
ORDER BY cantidad DESC;
```

Muestra cuántas especies hay de cada tipo (vegetales, animales, minerales).




### Consultas Avanzadas

1. **Especies en peligro (menos de 30 individuos)**:

```sql
SELECT tipoEspecie, nombreCientifico, nombreVulgar, cantidad
FROM especie
WHERE cantidad < 30
ORDER BY cantidad ASC;
```

Identifica especies con poblaciones reducidas que requieren atención especial.


2. **Áreas con mayor densidad de especies**:

```sql
SELECT 
    a.nombre AS area, 
    p.nombre AS parque,
    a.extencionArea AS hectareas,
    SUM(e.cantidad) AS total_individuos,
    ROUND(SUM(e.cantidad) / a.extencionArea, 2) AS densidad_por_hectarea
FROM area a
JOIN parque p ON a.idParque = p.id
JOIN especie e ON a.id = e.idArea
GROUP BY a.id, a.nombre, p.nombre, a.extencionArea
ORDER BY densidad_por_hectarea DESC
LIMIT 10;
```

Muestra las áreas con mayor concentración de individuos por hectárea.


3. **Relación entre antigüedad del parque y biodiversidad**:

```sql
SELECT 
    p.nombre AS parque,
    YEAR(CURDATE()) - YEAR(p.fechaDeclaracion) AS años_protegido,
    COUNT(DISTINCT e.id) AS total_especies,
    ROUND(COUNT(DISTINCT e.id) / (YEAR(CURDATE()) - YEAR(p.fechaDeclaracion)), 2) AS especies_por_año
FROM parque p
JOIN area a ON p.id = a.idParque
JOIN especie e ON a.id = e.idArea
GROUP BY p.id, p.nombre, p.fechaDeclaracion
ORDER BY especies_por_año DESC;
```

Analiza si existe correlación entre los años de protección de un parque y su biodiversidad.




## 6. Procedimientos, Funciones, Triggers y Eventos

### Procedimientos Almacenados Destacados

1. **registrar_parque**: Permite registrar un nuevo parque en el sistema.

```sql
CALL registrar_parque('Nuevo Parque Nacional', '2023-01-15', 2500.75);
```


2. **registrar_especie**: Registra una nueva especie en un área específica.

```sql
CALL registrar_especie('vegetales', 'Quercus suber', 'Alcornoque', 150, 5);
```


3. **asignar_alojamiento**: Asigna un alojamiento disponible a un visitante.

```sql
CALL asignar_alojamiento(12, 8);
```


4. **generar_reporte_biodiversidad**: Genera un reporte completo sobre la biodiversidad del sistema.

```sql
CALL generar_reporte_biodiversidad();
```




### Funciones Destacadas

1. **calcular_edad_parque**: Calcula los años desde la declaración de un parque.

```sql
SELECT nombre, calcular_edad_parque(id) AS años_protegido FROM parque;
```


2. **calcular_densidad_especies**: Calcula la densidad de especies por hectárea en un área.

```sql
SELECT nombre, calcular_densidad_especies(id) AS densidad FROM area;
```


3. **parque_tiene_especies_peligro**: Verifica si un parque tiene especies en peligro.

```sql
SELECT nombre, parque_tiene_especies_peligro(id) AS tiene_especies_peligro FROM parque;
```




### Triggers Importantes

1. **actualizar_estado_alojamiento_insert**: Actualiza automáticamente el estado de un alojamiento a ocupado cuando se asigna a un visitante.
2. **registrar_cambio_especie**: Registra en el historial cualquier cambio en la cantidad de una especie.
3. **validar_fechas_proyecto**: Valida que la fecha de inicio de un proyecto sea anterior a la fecha de fin.


### Eventos Programados

1. **actualizar_estadisticas_parques**: Actualiza diariamente las estadísticas de parques.
2. **verificar_especies_peligro**: Verifica trimestralmente las especies con poblaciones críticas y genera alertas.
3. **actualizar_sueldos_personal**: Actualiza anualmente los sueldos del personal con un incremento del 5%.


## 7. Roles de Usuario y Permisos

El sistema "Ambientalistas" implementa 5 roles de usuario con permisos específicos:

### 1. Administrador (admin_ambiental)

- **Descripción**: Acceso total al sistema.
- **Permisos**: Todos los privilegios sobre todas las tablas y operaciones.
- **Uso típico**: Configuración del sistema, gestión de usuarios, mantenimiento de la base de datos.


### 2. Gestor de Parques (gestor_parques)

- **Descripción**: Gestión de parques, áreas y especies.
- **Permisos**: SELECT, INSERT, UPDATE, DELETE  sobre las siguientes tablas de parques, áreas y especies. Lectura en tablas relacionadas.
- **Uso típico**: Registro de nuevos parques, actualización de información sobre especies, gestión de áreas protegidas.


### 3. Investigador (investigador)

- **Descripción**: Acceso a datos de proyectos y especies.
- **Permisos**: Lectura en tablas de proyectos y especies. Actualización limitada a datos de investigación.
- **Uso típico**: Consulta de información sobre especies, actualización de resultados de investigación.


### 4. Auditor (auditor)

- **Descripción**: Acceso a reportes financieros.
- **Permisos**: Lectura en tablas financieras y de recursos. Sin permisos de modificación.
- **Uso típico**: Generación de informes financieros, auditoría de presupuestos y gastos.


### 5. Encargado de Visitantes (encargado_visitantes)

- **Descripción**: Gestión de visitantes y alojamientos.
- **Permisos**: SELECT, INSERT, UPDATE, DELETE completo sobre tablas de visitantes y alojamientos. Lectura en tablas relacionadas.
- **Uso típico**: Registro de visitantes, asignación de alojamientos, gestión de ocupación.

