-- procedimientos
CREATE TABLE historial_especies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    idEspecie INT,
    cantidad_anterior INT,
    cantidad_nueva INT,
    fecha_cambio DATETIME,
    FOREIGN KEY (idEspecie) REFERENCES especie(id)
);
CREATE TABLE historial_presupuestos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    idProyecto INT,
    presupuesto_anterior FLOAT,
    presupuesto_nuevo FLOAT,
    fecha_cambio DATETIME,
    FOREIGN KEY (idProyecto) REFERENCES proyecto(id)
);


-- Procedimiento 1: Registrar nuevo parque
DELIMITER //
CREATE PROCEDURE registrar_parque(
    IN p_nombre VARCHAR(50),
    IN p_fechaDeclaracion DATE,
    IN p_superficieTotal FLOAT
)
BEGIN
    INSERT INTO parque (nombre, fechaDeclaracion, superficieTotal)
    VALUES (p_nombre, p_fechaDeclaracion, p_superficieTotal);
    
    SELECT LAST_INSERT_ID() AS id_parque, 'Parque registrado exitosamente' AS mensaje;
END //
DELIMITER ;

CALL registrar_parque('Parque Nacional Agumon', '2025-03-09', 1500.5);


-- Procedimiento 2: Registrar nueva área en un parque
DELIMITER //
CREATE PROCEDURE registrar_area(
    IN p_nombre VARCHAR(50),
    IN p_extension FLOAT,
    IN p_idParque INT
)
BEGIN
    DECLARE parque_existe INT;
    
    SELECT COUNT(*) INTO parque_existe FROM parque WHERE id = p_idParque;
    
    IF parque_existe = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El parque especificado no existe';
    ELSE
        INSERT INTO area (nombre, extencionArea, idParque)
        VALUES (p_nombre, p_extension, p_idParque);
        
        SELECT LAST_INSERT_ID() AS id_area, 'Área registrada exitosamente' AS mensaje;
    END IF;
END //
DELIMITER ;
CALL registrar_area('Cercado de monteredondo', 500.75, 5);  



-- Procedimiento 3: Registrar nueva especie
DELIMITER //
CREATE PROCEDURE registrar_especie(
    IN p_tipoEspecie ENUM("vegetales", "animales", "minerales"),
    IN p_nombreCientifico VARCHAR(50),
    IN p_nombreVulgar VARCHAR(50),
    IN p_cantidad INT,
    IN p_idArea INT
)
BEGIN
    DECLARE area_existe INT;
    
    SELECT COUNT(*) INTO area_existe FROM area WHERE id = p_idArea;
    
    IF area_existe = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El área especificada no existe';
    ELSE
        INSERT INTO especie (tipoEspecie, nombreCientifico, nombreVulgar, cantidad, idArea)
        VALUES (p_tipoEspecie, p_nombreCientifico, p_nombreVulgar, p_cantidad, p_idArea);
        
        SELECT LAST_INSERT_ID() AS id_especie, 'Especie registrada exitosamente' AS mensaje;
    END IF;
END //
DELIMITER ;

CALL registrar_especie('vegetales', 'Ficus', 'Higuera', 21, 4); 

-- Procedimiento 4: Registrar nuevo personal
DELIMITER //
CREATE PROCEDURE registrar_personal(
    IN p_cedula VARCHAR(20),
    IN p_nombre VARCHAR(50),
    IN p_direccion VARCHAR(100),
    IN p_telefonoFijo VARCHAR(15),
    IN p_telefonoMovil VARCHAR(15),
    IN p_sueldo DECIMAL(10,2),
    IN p_tipoPersonal ENUM("001", "002", "003", "004")
)
BEGIN
    DECLARE cedula_existe INT;
    
    SELECT COUNT(*) INTO cedula_existe FROM personal WHERE cedula = p_cedula;
    
    IF cedula_existe > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ya existe un empleado con esta cédula';
    ELSE
        INSERT INTO personal (cedula, nombre, direccion, telefonoFijo, telefonoMovil, sueldo, tipoPersonal)
        VALUES (p_cedula, p_nombre, p_direccion, p_telefonoFijo, p_telefonoMovil, p_sueldo, p_tipoPersonal);
        
        -- Registrar en la tabla correspondiente según el tipo de personal
        CASE p_tipoPersonal
            WHEN '001' THEN
                INSERT INTO gestion (idPersonal) VALUES (LAST_INSERT_ID());
            WHEN '003' THEN
                INSERT INTO conservacion (idPersonal) VALUES (LAST_INSERT_ID());
            WHEN '004' THEN
                INSERT INTO investigador (idPersonal) VALUES (LAST_INSERT_ID());
        END CASE;
        
        SELECT LAST_INSERT_ID() AS id_personal, 'Personal registrado exitosamente' AS mensaje;
    END IF;
END //
DELIMITER ;

CALL registrar_personal('1234567890', 'Juan Pérez', 'Calle Ficticia 123', '555-1234', '555-5678', 2500.00, '003');


-- Procedimiento 5: Registrar nuevo proyecto
DELIMITER //
CREATE PROCEDURE registrar_proyecto(
    IN p_nombre VARCHAR(100),
    IN p_presupuesto FLOAT,
    IN p_fechaInicio DATE,
    IN p_fechaFin DATE
)
BEGIN
    IF p_fechaInicio >= p_fechaFin THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La fecha de inicio debe ser anterior a la fecha de fin';
    ELSE
        INSERT INTO proyecto (nombre, presupuesto, fechaInicio, fechaFin)
        VALUES (p_nombre, p_presupuesto, p_fechaInicio, p_fechaFin);
        
        SELECT LAST_INSERT_ID() AS id_proyecto, 'Proyecto registrado exitosamente' AS mensaje;
    END IF;
END //
DELIMITER ;
CALL registrar_proyecto('Proyecto de Conservación natural', 100000.00, '2025-04-01', '2028-12-31');


-- Procedimiento 6: Asignar especie a proyecto
DELIMITER //
CREATE PROCEDURE asignar_especie_proyecto(
    IN p_idEspecie INT,
    IN p_idProyecto INT
)
BEGIN
    DECLARE especie_existe INT;
    DECLARE proyecto_existe INT;
    DECLARE asignacion_existe INT;
    
    SELECT COUNT(*) INTO especie_existe FROM especie WHERE id = p_idEspecie;
    SELECT COUNT(*) INTO proyecto_existe FROM proyecto WHERE id = p_idProyecto;
    SELECT COUNT(*) INTO asignacion_existe FROM proyectoEspecie 
    WHERE idEspecie = p_idEspecie AND idProyecto = p_idProyecto;
    
    IF especie_existe = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La especie especificada no existe';
    ELSEIF proyecto_existe = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El proyecto especificado no existe';
    ELSEIF asignacion_existe > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Esta especie ya está asignada a este proyecto';
    ELSE
        INSERT INTO proyectoEspecie (idEspecie, idProyecto)
        VALUES (p_idEspecie, p_idProyecto);
        
        SELECT 'Especie asignada al proyecto exitosamente' AS mensaje;
    END IF;
END //
DELIMITER ;
CALL asignar_especie_proyecto(5, 4);  


-- Procedimiento 7: Asignar investigador a proyecto
DELIMITER //
CREATE PROCEDURE asignar_investigador_proyecto(
    IN p_idInvestigador INT,
    IN p_idProyecto INT
)
BEGIN
    DECLARE investigador_existe INT;
    DECLARE proyecto_existe INT;
    DECLARE asignacion_existe INT;
    
    SELECT COUNT(*) INTO investigador_existe FROM investigador WHERE id = p_idInvestigador;
    SELECT COUNT(*) INTO proyecto_existe FROM proyecto WHERE id = p_idProyecto;
    SELECT COUNT(*) INTO asignacion_existe FROM investigadorProyecto 
    WHERE idInvestigador = p_idInvestigador AND idProyecto = p_idProyecto;
    
    IF investigador_existe = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El investigador especificado no existe';
    ELSEIF proyecto_existe = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El proyecto especificado no existe';
    ELSEIF asignacion_existe > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Este investigador ya está asignado a este proyecto';
    ELSE
        INSERT INTO investigadorProyecto (idInvestigador, idProyecto)
        VALUES (p_idInvestigador, p_idProyecto);
        
        SELECT 'Investigador asignado al proyecto exitosamente' AS mensaje;
    END IF;
END //
DELIMITER ;

CALL asignar_investigador_proyecto(34, 24);  


-- Procedimiento 8: Registrar visitante
DELIMITER //
CREATE PROCEDURE registrar_visitante(
    IN p_cedula VARCHAR(20),
    IN p_nombre VARCHAR(50),
    IN p_direccion VARCHAR(100),
    IN p_profesion VARCHAR(100),
    IN p_idGestion INT
)
BEGIN
    DECLARE gestion_existe INT;
    DECLARE cedula_existe INT;
    
    SELECT COUNT(*) INTO gestion_existe FROM gestion WHERE id = p_idGestion;
    SELECT COUNT(*) INTO cedula_existe FROM visitante WHERE cedula = p_cedula;
    
    IF gestion_existe = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La gestión especificada no existe';
    ELSEIF cedula_existe > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ya existe un visitante con esta cédula';
    ELSE
        INSERT INTO visitante (cedula, nombre, direccion, profesion, idGestion)
        VALUES (p_cedula, p_nombre, p_direccion, p_profesion, p_idGestion);
        
        SELECT LAST_INSERT_ID() AS id_visitante, 'Visitante registrado exitosamente' AS mensaje;
    END IF;
END //
DELIMITER ;
CALL registrar_visitante('9876543210', 'Ana López', 'Avenida Santafe 456', 'Bióloga', 1); 

-- Procedimiento 9: Asignar alojamiento a visitante
DELIMITER //
CREATE PROCEDURE asignar_alojamiento(
    IN p_idVisitante INT,
    IN p_idAlojamiento INT
)
BEGIN
    DECLARE visitante_existe INT;
    DECLARE alojamiento_existe INT;
    DECLARE alojamiento_disponible BOOLEAN;
    DECLARE asignacion_existe INT;
    
    SELECT COUNT(*) INTO visitante_existe FROM visitante WHERE id = p_idVisitante;
    SELECT COUNT(*) INTO alojamiento_existe FROM alojamiento WHERE id = p_idAlojamiento;
    SELECT estadoAlojamiento INTO alojamiento_disponible FROM alojamiento WHERE id = p_idAlojamiento;
    SELECT COUNT(*) INTO asignacion_existe FROM visitanteAlojamiento 
    WHERE idVisitante = p_idVisitante AND idAlojamiento = p_idAlojamiento;
    
    IF visitante_existe = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El visitante especificado no existe';
    ELSEIF alojamiento_existe = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El alojamiento especificado no existe';
    ELSEIF NOT alojamiento_disponible THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El alojamiento no está disponible';
    ELSEIF asignacion_existe > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Este visitante ya está asignado a este alojamiento';
    ELSE
        INSERT INTO visitanteAlojamiento (idVisitante, idAlojamiento)
        VALUES (p_idVisitante, p_idAlojamiento);
        
        -- Actualizar estado del alojamiento
        UPDATE alojamiento SET estadoAlojamiento = FALSE WHERE id = p_idAlojamiento;
        
        SELECT 'Alojamiento asignado al visitante exitosamente' AS mensaje;
    END IF;
END //
DELIMITER ;

CALL asignar_alojamiento(51, 19);  


-- Procedimiento 10: Asignar vehículo a vigilante
DELIMITER //
CREATE PROCEDURE asignar_vehiculo_vigilante(
    IN p_idPersonal INT,
    IN p_idVehiculo INT
)
BEGIN
    DECLARE personal_existe INT;
    DECLARE es_vigilante INT;
    DECLARE vehiculo_existe INT;
    DECLARE vigilancia_id INT;
    
    SELECT COUNT(*) INTO personal_existe FROM personal WHERE id = p_idPersonal;
    SELECT COUNT(*) INTO es_vigilante FROM personal WHERE id = p_idPersonal AND tipoPersonal = '003';
    SELECT COUNT(*) INTO vehiculo_existe FROM vehiculo WHERE id = p_idVehiculo;
    
    IF personal_existe = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El personal especificado no existe';
    ELSEIF es_vigilante = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El personal especificado no es vigilante';
    ELSEIF vehiculo_existe = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El vehículo especificado no existe';
    ELSE
        -- Verificar si ya existe un registro de vigilancia para este personal
        SELECT id INTO vigilancia_id FROM vigilancia WHERE idPersonal = p_idPersonal LIMIT 1;
        
        IF vigilancia_id IS NULL THEN
            -- Crear nuevo registro de vigilancia
            INSERT INTO vigilancia (idPersonal, idVehiculo)
            VALUES (p_idPersonal, p_idVehiculo);
            
            SELECT LAST_INSERT_ID() AS id_vigilancia, 'Vehículo asignado al vigilante exitosamente' AS mensaje;
        ELSE
            -- Actualizar registro existente
            UPDATE vigilancia SET idVehiculo = p_idVehiculo WHERE id = vigilancia_id;
            
            SELECT vigilancia_id AS id_vigilancia, 'Vehículo actualizado para el vigilante exitosamente' AS mensaje;
        END IF;
    END IF;
END //
DELIMITER ;
CALL asignar_vehiculo_vigilante(3, 1);


-- Procedimiento 11: Asignar área a vigilante
DELIMITER //
CREATE PROCEDURE asignar_area_vigilante(
    IN p_idVigilancia INT,
    IN p_idArea INT
)
BEGIN
    DECLARE vigilancia_existe INT;
    DECLARE area_existe INT;
    DECLARE asignacion_existe INT;
    
    SELECT COUNT(*) INTO vigilancia_existe FROM vigilancia WHERE id = p_idVigilancia;
    SELECT COUNT(*) INTO area_existe FROM area WHERE id = p_idArea;
    SELECT COUNT(*) INTO asignacion_existe FROM vigilanciaArea 
    WHERE idVigilancia = p_idVigilancia AND idArea = p_idArea;
    
    IF vigilancia_existe = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La vigilancia especificada no existe';
    ELSEIF area_existe = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El área especificada no existe';
    ELSEIF asignacion_existe > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Esta área ya está asignada a esta vigilancia';
    ELSE
        INSERT INTO vigilanciaArea (idVigilancia, idArea)
        VALUES (p_idVigilancia, p_idArea);
        
        SELECT 'Área asignada al vigilante exitosamente' AS mensaje;
    END IF;
END //
DELIMITER ;
CALL asignar_area_vigilante(3, 24);  

-- Procedimiento 12: Asignar área a conservación
DELIMITER //
CREATE PROCEDURE asignar_area_conservacion(
    IN p_idConservacion INT,
    IN p_idArea INT
)
BEGIN
    DECLARE conservacion_existe INT;
    DECLARE area_existe INT;
    DECLARE asignacion_existe INT;
    
    SELECT COUNT(*) INTO conservacion_existe FROM conservacion WHERE id = p_idConservacion;
    SELECT COUNT(*) INTO area_existe FROM area WHERE id = p_idArea;
    SELECT COUNT(*) INTO asignacion_existe FROM conservacionArea 
    WHERE idConservacion = p_idConservacion AND idArea = p_idArea;
    
    IF conservacion_existe = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La conservación especificada no existe';
    ELSEIF area_existe = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El área especificada no existe';
    ELSEIF asignacion_existe > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Esta área ya está asignada a esta conservación';
    ELSE
        INSERT INTO conservacionArea (idConservacion, idArea)
        VALUES (p_idConservacion, p_idArea);
        
        SELECT 'Área asignada a conservación exitosamente' AS mensaje;
    END IF;
END //
DELIMITER ;
CALL asignar_area_conservacion(1, 25);  

-- Procedimiento 13: Actualizar cantidad de especie
DELIMITER //
CREATE PROCEDURE actualizar_cantidad_especie(
    IN p_idEspecie INT,
    IN p_nuevaCantidad INT
)
BEGIN
    DECLARE especie_existe INT;
    DECLARE cantidad_actual INT;
    
    SELECT COUNT(*) INTO especie_existe FROM especie WHERE id = p_idEspecie;
    
    IF especie_existe = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La especie especificada no existe';
    ELSEIF p_nuevaCantidad < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La cantidad no puede ser negativa';
    ELSE
        SELECT cantidad INTO cantidad_actual FROM especie WHERE id = p_idEspecie;
        
        UPDATE especie SET cantidad = p_nuevaCantidad WHERE id = p_idEspecie;
        
        -- Registrar el cambio en un historial
        INSERT INTO historial_especies (idEspecie, cantidad_anterior, cantidad_nueva, fecha_cambio)
        VALUES (p_idEspecie, cantidad_actual, p_nuevaCantidad, NOW());
        
        SELECT 'Cantidad de especie actualizada exitosamente' AS mensaje;
    END IF;
END //
DELIMITER ;
CALL actualizar_cantidad_especie(6, 520);  

-- Procedimiento 14: Actualizar presupuesto de proyecto
DELIMITER //
CREATE PROCEDURE actualizar_presupuesto_proyecto(
    IN p_idProyecto INT,
    IN p_nuevoPresupuesto FLOAT
)
BEGIN
    DECLARE proyecto_existe INT;
    DECLARE presupuesto_actual FLOAT;
    
    SELECT COUNT(*) INTO proyecto_existe FROM proyecto WHERE id = p_idProyecto;
    
    IF proyecto_existe = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El proyecto especificado no existe';
    ELSEIF p_nuevoPresupuesto <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El presupuesto debe ser mayor que cero';
    ELSE
        SELECT presupuesto INTO presupuesto_actual FROM proyecto WHERE id = p_idProyecto;
        
        UPDATE proyecto SET presupuesto = p_nuevoPresupuesto WHERE id = p_idProyecto;
        
        -- Registrar el cambio en un historial
        INSERT INTO historial_presupuestos (idProyecto, presupuesto_anterior, presupuesto_nuevo, fecha_cambio)
        VALUES (p_idProyecto, presupuesto_actual, p_nuevoPresupuesto, NOW());
        
        SELECT 'Presupuesto de proyecto actualizado exitosamente' AS mensaje;
    END IF;
END //
DELIMITER ;
CALL actualizar_presupuesto_proyecto(9, 1200000.00);  


-- Procedimiento 15: Obtener estadísticas de parque
DELIMITER //
CREATE PROCEDURE obtener_estadisticas_parque(
    IN p_idParque INT
)
BEGIN
    DECLARE parque_existe INT;
    
    SELECT COUNT(*) INTO parque_existe FROM parque WHERE id = p_idParque;
    
    IF parque_existe = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El parque especificado no existe';
    ELSE
        -- Estadísticas generales
        SELECT 
            p.nombre AS parque,
            p.superficieTotal,
            COUNT(DISTINCT a.id) AS total_areas,
            SUM(a.extencionArea) AS superficie_areas,
            COUNT(DISTINCT e.id) AS total_especies,
            SUM(e.cantidad) AS total_individuos
        FROM parque p
        LEFT JOIN area a ON p.id = a.idParque
        LEFT JOIN especie e ON a.id = e.idArea
        WHERE p.id = p_idParque
        GROUP BY p.id, p.nombre, p.superficieTotal;
        
        -- Distribución de especies por tipo
        SELECT 
            e.tipoEspecie,
            COUNT(e.id) AS cantidad_especies,
            SUM(e.cantidad) AS total_individuos
        FROM parque p
        JOIN area a ON p.id = a.idParque
        JOIN especie e ON a.id = e.idArea
        WHERE p.id = p_idParque
        GROUP BY e.tipoEspecie;
    END IF;
END //
DELIMITER ;

CALL obtener_estadisticas_parque(1);  


-- Procedimiento 16: Obtener personal por tipo
DELIMITER //
CREATE PROCEDURE obtener_personal_por_tipo(
    IN p_tipoPersonal ENUM("001", "002", "003", "004")
)
BEGIN
    SELECT 
        id,
        cedula,
        nombre,
        direccion,
        telefonoFijo,
        telefonoMovil,
        sueldo
    FROM personal
    WHERE tipoPersonal = p_tipoPersonal
    ORDER BY nombre;
END //
DELIMITER ;
CALL obtener_personal_por_tipo('002'); 

-- Procedimiento 17: Obtener proyectos activos
DELIMITER //
CREATE PROCEDURE obtener_proyectos_activos()
BEGIN
    SELECT 
        id,
        nombre,
        presupuesto,
        fechaInicio,
        fechaFin,
        DATEDIFF(fechaFin, CURDATE()) AS dias_restantes
    FROM proyecto
    WHERE fechaFin >= CURDATE()
    ORDER BY dias_restantes;
END //
DELIMITER ;
CALL obtener_proyectos_activos();

-- Procedimiento 18: Obtener ocupación de alojamientos
DELIMITER //
CREATE PROCEDURE obtener_ocupacion_alojamientos()
BEGIN
    SELECT 
        a.id,
        a.nombre,
        a.capacidad,
        a.estadoAlojamiento,
        COUNT(va.idVisitante) AS visitantes_actuales,
        GROUP_CONCAT(v.nombre SEPARATOR ', ') AS nombres_visitantes
    FROM alojamiento a
    LEFT JOIN visitanteAlojamiento va ON a.id = va.idAlojamiento
    LEFT JOIN visitante v ON va.idVisitante = v.id
    GROUP BY a.id, a.nombre, a.capacidad, a.estadoAlojamiento
    ORDER BY a.nombre;
END //
DELIMITER ;
CALL obtener_ocupacion_alojamientos();

-- Procedimiento 19: Buscar especies por nombre
DELIMITER //
CREATE PROCEDURE buscar_especies(
    IN p_termino VARCHAR(50)
)
BEGIN
    SELECT 
        e.id,
        e.tipoEspecie,
        e.nombreCientifico,
        e.nombreVulgar,
        e.cantidad,
        a.nombre AS area,
        p.nombre AS parque
    FROM especie e
    JOIN area a ON e.idArea = a.id
    JOIN parque p ON a.idParque = p.id
    WHERE e.nombreCientifico LIKE CONCAT('%', p_termino, '%')
       OR e.nombreVulgar LIKE CONCAT('%', p_termino, '%')
    ORDER BY e.nombreCientifico;
END //
DELIMITER ;
CALL buscar_especies('Higuera');

-- Procedimiento 20: Generar reporte de biodiversidad
DELIMITER //
CREATE PROCEDURE generar_reporte_biodiversidad()
BEGIN
    -- Resumen general
    SELECT 
        COUNT(DISTINCT p.id) AS total_parques,
        COUNT(DISTINCT a.id) AS total_areas,
        COUNT(DISTINCT e.id) AS total_especies,
        SUM(e.cantidad) AS total_individuos
    FROM parque p
    LEFT JOIN area a ON p.id = a.idParque
    LEFT JOIN especie e ON a.id = e.idArea;
    
    -- Distribución por tipo de especie
    SELECT 
        e.tipoEspecie,
        COUNT(DISTINCT e.id) AS cantidad_especies,
        SUM(e.cantidad) AS total_individuos,
        ROUND(COUNT(DISTINCT e.id) * 100.0 / (SELECT COUNT(*) FROM especie), 2) AS porcentaje_especies
    FROM especie e
    GROUP BY e.tipoEspecie;
    
    -- Top 10 áreas con mayor biodiversidad
    SELECT 
        a.nombre AS area,
        p.nombre AS parque,
        COUNT(DISTINCT e.id) AS total_especies,
        SUM(e.cantidad) AS total_individuos
    FROM area a
    JOIN parque p ON a.idParque = p.id
    JOIN especie e ON a.id = e.idArea
    GROUP BY a.id, a.nombre, p.nombre
    ORDER BY total_especies DESC, total_individuos DESC
    LIMIT 10;
END //
DELIMITER ;

CALL generar_reporte_biodiversidad();




