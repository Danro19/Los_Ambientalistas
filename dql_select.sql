use Ambientalistas;

-- consultas

--  1 Mirar la cantidad de parques por departamento
SELECT d.nombre AS departamento, COUNT(dp.idParque) AS cantidad_parques
FROM departamento d
LEFT JOIN departamentoParque dp ON d.id = dp.idDepartamento
GROUP BY d.nombre;

-- 2 Mirar la superficie Total de un Area 
SELECT p.nombre AS parque, SUM(a.extencionArea) AS superficie_total
FROM parque p
LEFT JOIN area a ON p.id = a.idParque
GROUP BY p.nombre;

-- 3 cantidad y tipo de especie por su area
SELECT a.nombre AS area, e.tipoEspecie, COUNT(e.id) AS cantidad_especies
FROM area a
JOIN especie e ON a.id = e.idArea
GROUP BY a.nombre, e.tipoEspecie;

-- 4 cantidad de especies por su tipo
SELECT e.tipoEspecie, COUNT(DISTINCT e.id) AS total_especies
FROM especie e
GROUP BY e.tipoEspecie;

-- 5 cantidad de personal por su tipo de trabajo y su sueldo promedio
SELECT tipoPersonal, COUNT(*) AS cantidad_personal, AVG(sueldo) AS sueldo_promedio
FROM personal
GROUP BY tipoPersonal;

-- 6 personal de vigilancia con su sueldo y la area asignada
SELECT p.nombre, p.sueldo, a.nombre AS area_asignada
FROM personal p
JOIN vigilancia v ON p.id = v.idPersonal
JOIN vigilanciaArea va ON v.id = va.idVigilancia
JOIN area a ON va.idArea = a.id;

-- 7 Presupuesto de proyectos con investigadores asociados ordenado del mas pequeño al mas grande
SELECT pr.nombre AS proyecto, ROUND(SUM(pr.presupuesto), 2) AS costo_total
FROM proyecto pr
JOIN investigadorProyecto ip ON pr.id = ip.idProyecto
JOIN investigador i ON ip.idInvestigador = i.id
GROUP BY pr.nombre
ORDER by costo_total asc;

-- 8 cantidad de especies por proyecto
SELECT pr.nombre AS proyecto, COUNT(DISTINCT e.id) AS especies_involucradas
FROM proyecto pr
JOIN proyectoEspecie pe ON pr.id = pe.idProyecto 
JOIN especie e on e.id =pe.idEspecie 
GROUP BY pr.nombre;

-- 9 cantidad de visitantes
SELECT COUNT(*) AS total_visitantes FROM visitante;

-- 10 lista de alojamientos con los visitantes actuales
SELECT a.nombre AS alojamiento, COUNT(va.idVisitante) AS ocupacion_actual
FROM alojamiento a
LEFT JOIN visitanteAlojamiento va ON a.id = va.idAlojamiento
GROUP BY a.nombre;

-- 11 Consulta el total del parque, total de areas y total de especies
SELECT p.nombre AS parque, 
       (SELECT COUNT(a.id) FROM area a WHERE a.idParque = p.id) AS total_areas,
       (SELECT COUNT(e.id) FROM especie e JOIN area a ON e.idArea = a.id WHERE a.idParque = p.id) AS total_especies
FROM parque p;

-- 12 lista de los vigilantes con almenos un vehiculo
SELECT v.idPersonal, COUNT(v.idVehiculo) AS cantidad_vehiculos
FROM vigilancia v
GROUP BY v.idPersonal
HAVING COUNT(v.idVehiculo) > 0;

-- 13 Promedio de superficie de parques por entidad
SELECT e.nombre AS entidad, ROUND(AVG(p.superficieTotal), 2)  AS superficie_promedio
FROM entidad e
JOIN departamento d ON e.id = d.idEntidad
JOIN departamentoParque dp ON d.id = dp.idDepartamento
JOIN parque p ON dp.idParque = p.id
GROUP BY e.nombre;

-- 14 Cantidad de áreas protegidas por parque
SELECT p.nombre AS parque, COUNT(a.id) AS cantidad_areas
FROM parque p
JOIN area a ON p.id = a.idParque
GROUP BY p.nombre;


-- 15 Top 5 parques con mayor superficie
SELECT nombre, superficieTotal
FROM parque
ORDER BY superficieTotal DESC
LIMIT 5;

-- 16 Tipos de especies más frecuentes
SELECT tipoEspecie, COUNT(*) AS cantidad
FROM especie
GROUP BY tipoEspecie
ORDER BY cantidad DESC;

-- 17 Total de individuos por especie
SELECT nombreVulgar, SUM(cantidad) AS total_individuos
FROM especie
GROUP BY nombreVulgar;


-- 18 Promedio de individuos por área
SELECT a.nombre AS area, AVG(e.cantidad) AS promedio_individuos
FROM area a
JOIN especie e ON a.id = e.idArea
GROUP BY a.nombre;

-- 19 Áreas con mayor diversidad de especies
SELECT a.nombre AS area, COUNT(DISTINCT e.nombreCientifico) AS diversidad
FROM area a
JOIN especie e ON a.id = e.idArea
GROUP BY a.nombre
ORDER BY diversidad DESC
LIMIT 5;

-- 20 Total de personal vigilancia asignado por área
SELECT a.nombre AS area, COUNT(p.cedula) AS cantidad_personal
FROM area a
JOIN vigilanciaArea va ON a.id = va.idArea
JOIN vigilancia v ON va.idVigilancia = v.id
JOIN personal p ON v.idPersonal = p.id
GROUP BY a.nombre;


-- 21 Personal con sueldo mayor al promedio
SELECT nombre, sueldo
FROM personal
WHERE sueldo > (SELECT AVG(sueldo) FROM personal);


-- 22 Cantidad de proyectos en curso
SELECT COUNT(*) AS total_proyectos
FROM proyecto;


-- 23 Costo promedio de los proyectos
SELECT ROUND(AVG(presupuesto),2)  AS costo_promedio
FROM proyecto;

-- 24 Proyectos con más especies involucradas
SELECT p.nombre AS proyecto, COUNT(e.id) AS especies_involucradas
FROM proyecto p
JOIN proyectoEspecie pe  ON p.id = pe.idProyecto
JOIN especie e ON pe.idEspecie  = e.id
GROUP BY p.nombre
ORDER BY especies_involucradas DESC;

-- 25 Ocupación total de alojamientos
SELECT COUNT(*) AS alojamientos_ocupados
FROM visitanteAlojamiento;


-- 26 Alojamiento con más visitantes
SELECT a.nombre AS alojamiento, COUNT(va.idVisitante) AS total_visitantes
FROM alojamiento a
JOIN visitanteAlojamiento va ON a.id = va.idAlojamiento
GROUP BY a.nombre
ORDER BY total_visitantes DESC
LIMIT 1;

-- 27 Visitantes sin alojamiento asignado
SELECT v.nombre 
FROM visitante v
LEFT JOIN visitanteAlojamiento va ON v.id = va.idVisitante
WHERE va.idVisitante is  null;


-- 28 Parque con mayor cantidad de especies registradas
SELECT p.nombre
FROM parque p
JOIN area a ON p.id = a.idParque
JOIN especie e ON a.id = e.idArea
GROUP BY p.nombre
ORDER BY COUNT(e.id) DESC
LIMIT 1;

-- 29 Parque con mayor cantidad de visitantes
SELECT p.nombre, count(va.idVisitante) 
FROM parque p
JOIN area a ON p.id = a.idParque
JOIN visitanteAlojamiento va ON a.id = va.idAlojamiento
GROUP BY p.nombre
ORDER BY COUNT(va.idVisitante) DESC
LIMIT 1;



-- 30 Parque con la mayor superficie registrada
SELECT nombre, superficieTotal 
FROM parque 
ORDER BY superficieTotal DESC 
LIMIT 1;

-- 31 Parque con la menor superficie registrada
SELECT nombre, superficieTotal 
FROM parque 
ORDER BY superficieTotal ASC 
LIMIT 1;



-- 32 Departamentos sin parques registrados
SELECT d.nombre AS departamento
FROM departamento d
LEFT JOIN departamentoParque dp ON d.id = dp.idDepartamento
WHERE dp.idParque IS NULL;

-- 33 Parques con más de 2,000 hectáreas de superficie
SELECT nombre, superficieTotal 
FROM parque 
WHERE superficieTotal > 3000;

-- 34 Parques con menos de 1,500 hectáreas de superficie
SELECT nombre, superficieTotal 
FROM parque 
WHERE superficieTotal < 1500;


-- 35 Total de hectáreas protegidas a nivel nacional
SELECT ROUND(SUM(superficieTotal),2)   AS hectareas_protegidas FROM parque;

-- 36 Parque con la mayor cantidad de áreas registradas
SELECT p.nombre AS parque, COUNT(a.id) AS cantidad_areas
FROM parque p
JOIN area a ON p.id = a.idParque
GROUP BY p.nombre
ORDER BY cantidad_areas DESC
LIMIT 1;

-- 37 Departamentos con más de 5 parques registrados
SELECT d.nombre AS departamento, COUNT(dp.idParque) AS cantidad_parques
FROM departamento d
JOIN departamentoParque dp ON d.id = dp.idDepartamento
GROUP BY d.nombre
HAVING COUNT(dp.idParque) > 5;

-- 38 Entidades con parques que tienen más de 3 áreas registradas
SELECT e.nombre AS entidad, COUNT(a.id) AS total_areas
FROM entidad e
JOIN departamento d ON e.id = d.idEntidad
JOIN departamentoParque dp ON d.id = dp.idDepartamento
JOIN parque p ON dp.idParque = p.id
JOIN area a ON p.id = a.idParque
GROUP BY e.nombre
HAVING COUNT(a.id) > 3;

-- 39 Cantidad de parques por rango de superficie
SELECT 
    CASE 
        WHEN superficieTotal < 5000 THEN 'Menos de 5,000 ha'
        WHEN superficieTotal BETWEEN 5000 AND 20000 THEN 'Entre 5,000 y 20,000 ha'
        WHEN superficieTotal BETWEEN 20000 AND 50000 THEN 'Entre 20,000 y 50,000 ha'
        ELSE 'Más de 50,000 ha'
    END AS rango_superficie,
    COUNT(*) AS cantidad_parques
FROM parque
GROUP BY rango_superficie;

-- 40 Parques con superficie entre 1000 y 3000 hectáreas
SELECT * FROM parque WHERE superficieTotal BETWEEN 1000 AND 3000;

-- 41 Parques declarados en un año específico (ej. 2005)
SELECT * FROM parque WHERE YEAR(fechaDeclaracion) = 2005;

-- 42 Parques con nombre que contiene "Bosque"
SELECT * FROM parque WHERE nombre LIKE '%Bosque%';

-- 43 Parques sin áreas asignadas
SELECT p.* 
FROM parque p
LEFT JOIN area a ON p.id = a.idParque
WHERE a.id IS NULL;

-- 44 Parques con más de 3 áreas
SELECT p.nombre, COUNT(a.id) AS cantidad_areas
FROM parque p
JOIN area a ON p.id = a.idParque
GROUP BY p.nombre
HAVING COUNT(a.id) > 3;

-- 45 Especies con nombre científico que comienza con "A"
SELECT * FROM especie WHERE nombreCientifico LIKE 'A%';

-- 46 Especies con cantidad menor a 100
SELECT * FROM especie WHERE cantidad < 100;

-- 47 Especies en áreas con extensión mayor a 500 hectáreas
SELECT e.* 
FROM especie e
JOIN area a ON e.idArea = a.id
WHERE a.extencionArea > 500;

-- 48 Especies con nombre vulgar que contiene "rojo"
SELECT * FROM especie WHERE nombreVulgar LIKE '%rojo%';

-- 49 Especies agrupadas por tipo y ordenadas por cantidad
SELECT tipoEspecie, nombreVulgar, cantidad
FROM especie
ORDER BY tipoEspecie, cantidad DESC;

-- 50 Personal con sueldo entre $3000 y $5000
SELECT nombre, tipoPersonal, sueldo  FROM personal WHERE sueldo BETWEEN 3000 AND 5000;

-- 51 Personal con teléfono móvil nulo
SELECT * FROM personal WHERE telefonoMovil IS NULL;

-- 52 Personal con dirección que contiene "Calle"
SELECT * FROM personal WHERE direccion LIKE '%Calle%';

-- 53 Personal ordenado por sueldo (de mayor a menor)
SELECT * FROM personal ORDER BY sueldo DESC;

-- 54 Personal con tipo "001" y sueldo mayor a $4000
SELECT * FROM personal WHERE tipoPersonal = '001' AND sueldo > 4000;

-- 55 Proyectos que finalizan en 2024
SELECT * FROM proyecto WHERE YEAR(fechaFin) = 2024;

-- 56 Proyectos con presupuesto menor a $800,000
SELECT * FROM proyecto p  WHERE p.presupuesto  < 800000;

-- 57 Proyectos que comienzaron en 2023
SELECT * FROM proyecto WHERE YEAR(fechaInicio) = 2023;

-- 58 Proyectos con nombre que contiene "Conservación"
SELECT * FROM proyecto WHERE nombre LIKE '%Conservación%';

-- 59 Proyectos con más de 3 especies involucradas
SELECT p.nombre, COUNT(pe.idEspecie) AS especies_involucradas
FROM proyecto p
JOIN proyectoEspecie pe ON p.id = pe.idProyecto
GROUP BY p.nombre
HAVING COUNT(pe.idEspecie) > 2;

-- 60 Áreas con extensión menor a 300 hectáreas
SELECT * FROM area WHERE extencionArea < 300;

-- 61 Áreas sin especies registradas
SELECT a.*, e.nombreCientifico  
FROM area a
LEFT JOIN especie e ON a.id = e.idArea
WHERE e.id IS NULL;

-- 62 Áreas con más de 5 especies
SELECT a.nombre, COUNT(e.id) AS cantidad_especies
FROM area a
JOIN especie e ON a.id = e.idArea
GROUP BY a.nombre
HAVING COUNT(e.id) < 2;

-- 63 Áreas ordenadas por extensión (de menor a mayor)
SELECT * FROM area ORDER BY extencionArea ASC;

-- 64 Áreas con nombre que contiene "Laguna"
SELECT * FROM area WHERE nombre LIKE '%Laguna%';

-- 65 Vehículos de tipo "SUV"
SELECT * FROM vehiculo WHERE tipo = 'SUV';

-- 66 Vehículos de marca "Toyota"
SELECT * FROM vehiculo WHERE marca = 'Toyota';

-- 67 Vehículos asignados a personal de vigilancia
SELECT v.* 
FROM vehiculo v
JOIN vigilancia vig ON v.id = vig.idVehiculo;

-- 68 Vehículos no asignados a ningún personal
SELECT v.* 
FROM vehiculo v
LEFT JOIN vigilancia vig ON v.id = vig.idVehiculo
WHERE vig.idVehiculo IS NULL;

-- 69 Vehículos ordenados por tipo y marca
SELECT * FROM vehiculo ORDER BY tipo, marca;

-- 70 Alojamientos con capacidad mayor a 5
SELECT * FROM alojamiento WHERE capacidad > 5;

-- 71 Alojamientos no ocupados
SELECT * FROM alojamiento WHERE estadoAlojamiento = FALSE;

-- 72 Alojamientos ordenados por capacidad (de mayor a menor)
SELECT * FROM alojamiento ORDER BY capacidad DESC;

-- 73 Alojamientos con nombre que contiene "Cabaña"
SELECT * FROM alojamiento WHERE nombre LIKE '%Cabaña%';

-- 74 Alojamientos con más de 2 visitantes asignados
SELECT a.nombre, COUNT(va.idVisitante) AS cantidad_visitantes
FROM alojamiento a
JOIN visitanteAlojamiento va ON a.id = va.idAlojamiento
GROUP BY a.nombre
HAVING COUNT(va.idVisitante) > 2;

-- 75 Departamentos con más de 3 parques
SELECT d.nombre, COUNT(dp.idParque) AS cantidad_parques
FROM departamento d
JOIN departamentoParque dp ON d.id = dp.idDepartamento
GROUP BY d.nombre
HAVING COUNT(dp.idParque) > 2;

-- 76 Departamentos sin parques asignados
SELECT d.* 
FROM departamento d
LEFT JOIN departamentoParque dp ON d.id = dp.idDepartamento
WHERE dp.idDepartamento IS NULL;

-- 77 Departamentos ordenados por nombre
SELECT * FROM departamento ORDER BY nombre ASC;

-- 78 Departamentos con nombre que contiene "Norte"
SELECT * FROM departamento WHERE nombre LIKE '%Norte%';

-- 79 Departamentos con más de 5 áreas
SELECT d.nombre, COUNT(a.id) AS cantidad_areas
FROM departamento d
JOIN departamentoParque dp ON d.id = dp.idDepartamento
JOIN parque p ON dp.idParque = p.id
JOIN area a ON p.id = a.idParque
GROUP BY d.nombre
HAVING COUNT(a.id) > 5;

-- 80 Entidades con más de 3 departamentos
SELECT e.nombre, COUNT(d.id) AS cantidad_departamentos
FROM entidad e
JOIN departamento d ON e.id = d.idEntidad
GROUP BY e.nombre
HAVING COUNT(d.id) > 3;

-- 81 Entidades sin departamentos asignados
SELECT e.* 
FROM entidad e
LEFT JOIN departamento d ON e.id = d.idEntidad
WHERE d.idEntidad IS NULL;

-- 82 Entidades ordenadas por nombre
SELECT * FROM entidad ORDER BY nombre ASC;

-- 83 Entidades con nombre que contiene "Fundación"
SELECT * FROM entidad WHERE nombre LIKE '%Fundación%';

-- 84 Entidades con más de 5 proyectos
SELECT e.nombre, COUNT(p.id) AS cantidad_proyectos
FROM entidad e
JOIN departamento d ON e.id = d.idEntidad
JOIN departamentoParque dp ON d.id = dp.idDepartamento
JOIN parque p ON dp.idParque = p.id
JOIN proyecto pr ON p.id = pr.id
GROUP BY e.nombre
HAVING COUNT(p.id) >= 1;

-- 85 Gestiones con más de 5 visitantes
SELECT g.id, COUNT(v.id) AS cantidad_visitantes
FROM gestion g
JOIN visitante v ON g.id = v.idGestion
GROUP BY g.id
HAVING COUNT(v.id) > 5;

-- 86 Gestiones ordenadas por ID
SELECT * FROM gestion ORDER BY id ASC;

-- 87 Gestiones con más de 3 alojamientos asignados
SELECT g.id, COUNT(a.id) AS cantidad_alojamientos
FROM gestion g
JOIN visitante v ON g.id = v.idGestion
JOIN visitanteAlojamiento va ON v.id = va.idVisitante
JOIN alojamiento a ON va.idAlojamiento = a.id
GROUP BY g.id
HAVING COUNT(a.id) > 3;

-- 88 Gestiones con nombre que contiene "Protección"
SELECT g.* 
FROM gestion g
JOIN personal p ON g.idPersonal = p.id
WHERE p.nombre LIKE '%Carlos%';


-- 89 Áreas con más de 3 proyectos de conservación
SELECT a.nombre, COUNT(c.id) AS cantidad_proyectos
FROM area a
JOIN conservacionArea ca ON a.id = ca.idArea
JOIN conservacion c ON ca.idConservacion = c.id
GROUP BY a.nombre
HAVING COUNT(c.id) > 3;

-- 90 Personal asignado a conservación
SELECT p.* 
FROM personal p
JOIN conservacion c ON p.id = c.idPersonal;

-- 91 Conservación sin áreas asignadas
SELECT c.* 
FROM conservacion c
LEFT JOIN conservacionArea ca ON c.id = ca.idConservacion
WHERE ca.idConservacion IS NULL;

-- 92 Conservación ordenada por ID
SELECT * FROM conservacion ORDER BY id ASC;

-- 93 Conservación con nombre que contiene "Reforestación"
SELECT c.* 
FROM conservacion c
JOIN personal p ON c.idPersonal = p.id
WHERE p.nombre LIKE '%Daniel%';

-- 94 Especies con nombre científico que contiene "panthera"
SELECT * 
FROM especie 
WHERE nombreCientifico LIKE '%Ercus%';

-- 95 Proyectos con fecha de inicio en el último año
SELECT * 
FROM proyecto 
WHERE fechaInicio >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR);


-- 96 Visitantes con profesión "Biólogo" 
SELECT v.* 
FROM visitante v
JOIN visitanteAlojamiento va ON v.id = va.idVisitante
JOIN alojamiento a ON va.idAlojamiento = a.id
WHERE v.profesion = 'Biólogo';

-- 97 Especies con cantidad menor al promedio de su tipo
SELECT e.* 
FROM especie e
WHERE e.cantidad < (
    SELECT AVG(cantidad) 
    FROM especie 
    WHERE tipoEspecie = e.tipoEspecie
);

-- 98 Proyectos con mayor presupuesto y su duración en días
SELECT nombre, presupuesto, 
       DATEDIFF(fechaFin, fechaInicio) AS duracion_dias,
       ROUND(presupuesto / DATEDIFF(fechaFin, fechaInicio), 2) AS presupuesto_diario
FROM proyecto
ORDER BY presupuesto DESC
LIMIT 10;

-- 99 Proyectos que involucran especies en peligro (cantidad < 50)
SELECT DISTINCT p.nombre AS proyecto, e.nombreVulgar AS especie_en_peligro
FROM proyecto p
JOIN proyectoEspecie pe ON p.id = pe.idProyecto
JOIN especie e ON pe.idEspecie = e.id
WHERE e.cantidad < 50;

-- 100 Áreas con mayor densidad de especies (cantidad de individuos por hectárea)
SELECT 
    a.nombre AS area, p.nombre AS parque, a.extencionArea AS hectareas, SUM(e.cantidad) AS total_individuos, ROUND(SUM(e.cantidad) / a.extencionArea, 2) AS densidad_por_hectarea
FROM area a
JOIN parque p ON a.idParque = p.id
JOIN especie e ON a.id = e.idArea
GROUP BY a.id, a.nombre, p.nombre, a.extencionArea
ORDER BY densidad_por_hectarea DESC
LIMIT 10;







