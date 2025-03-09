-- Función 1: Calcular edad del parque en años
DELIMITER //
CREATE FUNCTION calcular_edad_parque(p_idParque INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE fecha_declaracion DATE;
    
    SELECT fechaDeclaracion INTO fecha_declaracion
    FROM parque
    WHERE id = p_idParque;
    
    IF fecha_declaracion IS NULL THEN
        RETURN NULL;
    ELSE
        RETURN TIMESTAMPDIFF(YEAR, fecha_declaracion, CURDATE());
    END IF;
END //
DELIMITER ;
SELECT calcular_edad_parque(1);
-- Función 2: Calcular densidad de especies por hectárea
DELIMITER //
CREATE FUNCTION calcular_densidad_especies(p_idArea INT) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total_especies INT;
    DECLARE extension_area FLOAT;
    
    SELECT COUNT(e.id), a.extencionArea
    INTO total_especies, extension_area
    FROM area a
    LEFT JOIN especie e ON a.id = e.idArea
    WHERE a.id = p_idArea
    GROUP BY a.id, a.extencionArea;
    
    IF extension_area IS NULL OR extension_area = 0 THEN
        RETURN 0;
    ELSE
        RETURN ROUND(total_especies / extension_area, 2);
    END IF;
END //
DELIMITER ;
SELECT calcular_densidad_especies(1);
-- Función 3: Calcular presupuesto diario de proyecto
DELIMITER //
CREATE FUNCTION calcular_presupuesto_diario(p_idProyecto INT) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE presupuesto_total FLOAT;
    DECLARE dias_duracion INT;
    DECLARE fecha_inicio DATE;
    DECLARE fecha_fin DATE;
    
    SELECT presupuesto, fechaInicio, fechaFin
    INTO presupuesto_total, fecha_inicio, fecha_fin
    FROM proyecto
    WHERE id = p_idProyecto;
    
    IF fecha_inicio IS NULL OR fecha_fin IS NULL THEN
        RETURN 0;
    ELSE
        SET dias_duracion = DATEDIFF(fecha_fin, fecha_inicio);
        
        IF dias_duracion <= 0 THEN
            RETURN 0;
        ELSE
            RETURN ROUND(presupuesto_total / dias_duracion, 2);
        END IF;
    END IF;
END //
DELIMITER ;
SELECT calcular_presupuesto_diario(8);   

-- Función 4: Calcular porcentaje de ocupación de alojamientos
DELIMITER //
CREATE FUNCTION calcular_porcentaje_ocupacion() 
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE total_alojamientos INT;
    DECLARE alojamientos_ocupados INT;
    
    SELECT COUNT(*) INTO total_alojamientos FROM alojamiento;
    
    SELECT COUNT(DISTINCT idAlojamiento) 
    INTO alojamientos_ocupados 
    FROM visitanteAlojamiento;
    
    IF total_alojamientos = 0 THEN
        RETURN 0;
    ELSE
        RETURN ROUND((alojamientos_ocupados / total_alojamientos) * 100, 2);
    END IF;
END //
DELIMITER ;
SELECT calcular_porcentaje_ocupacion();

-- Función 5: Calcular sueldo promedio por tipo de personal
DELIMITER //
CREATE FUNCTION calcular_sueldo_promedio(p_tipoPersonal ENUM("001", "002", "003", "004")) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE sueldo_promedio DECIMAL(10,2);
    
    SELECT AVG(sueldo) INTO sueldo_promedio
    FROM personal
    WHERE tipoPersonal = p_tipoPersonal;
    
    RETURN ROUND(sueldo_promedio, 2);
END //
DELIMITER ;
SELECT calcular_sueldo_promedio('001');  

-- Función 6: Verificar si un parque tiene especies en peligro
DELIMITER //
CREATE FUNCTION parque_tiene_especies_peligro(p_idParque INT) 
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE especies_peligro INT;
    
    SELECT COUNT(*) INTO especies_peligro
    FROM parque p
    JOIN area a ON p.id = a.idParque
    JOIN especie e ON a.id = e.idArea
    WHERE p.id = p_idParque AND e.cantidad < 30;
    
    RETURN especies_peligro > 0;
END //
DELIMITER ;
SELECT parque_tiene_especies_peligro(4); 

-- Función 7: Calcular total de especies por parque
DELIMITER //
CREATE FUNCTION total_especies_parque(p_idParque INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    
    SELECT COUNT(DISTINCT e.id) INTO total
    FROM parque p
    JOIN area a ON p.id = a.idParque
    JOIN especie e ON a.id = e.idArea
    WHERE p.id = p_idParque;
    
    RETURN total;
END //
DELIMITER ;
SELECT total_especies_parque(5);  

-- Función 8: Calcular total de individuos por parque
DELIMITER //
CREATE FUNCTION total_individuos_parque(p_idParque INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    
    SELECT SUM(e.cantidad) INTO total
    FROM parque p
    JOIN area a ON p.id = a.idParque
    JOIN especie e ON a.id = e.idArea
    WHERE p.id = p_idParque;
    
    RETURN IFNULL(total, 0);
END //
DELIMITER ;
SELECT total_individuos_parque(6);  -- 

-- Función 9: Verificar disponibilidad de alojamiento
DELIMITER //
CREATE FUNCTION alojamiento_disponible(p_idAlojamiento INT) 
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE estado BOOLEAN;
    
    SELECT estadoAlojamiento INTO estado
    FROM alojamiento
    WHERE id = p_idAlojamiento;
    
    RETURN IFNULL(estado, FALSE);
END //
DELIMITER ;
SELECT alojamiento_disponible(7);

-- Función 10: Calcular días restantes de proyecto
DELIMITER //
CREATE FUNCTION dias_restantes_proyecto(p_idProyecto INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE fecha_fin DATE;
    
    SELECT fechaFin INTO fecha_fin
    FROM proyecto
    WHERE id = p_idProyecto;
    
    IF fecha_fin IS NULL THEN
        RETURN NULL;
    ELSEIF fecha_fin < CURDATE() THEN
        RETURN 0;
    ELSE
        RETURN DATEDIFF(fecha_fin, CURDATE());
    END IF;
END //
DELIMITER ;
SELECT dias_restantes_proyecto(8); 

-- Función 11: Calcular porcentaje de avance de proyecto
DELIMITER //
CREATE FUNCTION porcentaje_avance_proyecto(p_idProyecto INT) 
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE fecha_inicio DATE;
    DECLARE fecha_fin DATE;
    DECLARE dias_totales INT;
    DECLARE dias_transcurridos INT;
    
    SELECT fechaInicio, fechaFin INTO fecha_inicio, fecha_fin
    FROM proyecto
    WHERE id = p_idProyecto;
    
    IF fecha_inicio IS NULL OR fecha_fin IS NULL THEN
        RETURN 0;
    ELSE
        SET dias_totales = DATEDIFF(fecha_fin, fecha_inicio);
        
        IF CURDATE() < fecha_inicio THEN
            RETURN 0;
        ELSEIF CURDATE() > fecha_fin THEN
            RETURN 100;
        ELSE
            SET dias_transcurridos = DATEDIFF(CURDATE(), fecha_inicio);
            RETURN ROUND((dias_transcurridos / dias_totales) * 100, 2);
        END IF;
    END IF;
END //
DELIMITER ;
SELECT porcentaje_avance_proyecto(9); 

-- Función 12: Contar proyectos activos
DELIMITER //
CREATE FUNCTION contar_proyectos_activos() 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    
    SELECT COUNT(*) INTO total
    FROM proyecto
    WHERE fechaInicio <= CURDATE() AND fechaFin >= CURDATE();
    
    RETURN total;
END //
DELIMITER ;
SELECT contar_proyectos_activos();

-- Función 13: Calcular índice de biodiversidad de área
DELIMITER //
CREATE FUNCTION indice_biodiversidad_area(p_idArea INT) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE num_especies INT;
    DECLARE num_individuos INT;
    DECLARE extension FLOAT;
    
    SELECT COUNT(DISTINCT e.id), SUM(e.cantidad), a.extencionArea
    INTO num_especies, num_individuos, extension
    FROM area a
    LEFT JOIN especie e ON a.id = e.idArea
    WHERE a.id = p_idArea
    GROUP BY a.id, a.extencionArea;
    
    IF num_especies IS NULL OR num_especies = 0 OR extension IS NULL OR extension = 0 THEN
        RETURN 0;
    ELSE
        -- Fórmula simple para índice de biodiversidad: (especies * individuos) / área
        RETURN ROUND((num_especies * num_individuos) / extension, 2);
    END IF;
END //
DELIMITER ;
SELECT indice_biodiversidad_area(10);  

-- Función 14: Verificar si un personal es investigador
DELIMITER //
CREATE FUNCTION es_investigador(p_idPersonal INT) 
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE es_inv BOOLEAN;
    
    SELECT EXISTS(
        SELECT 1 FROM investigador WHERE idPersonal = p_idPersonal
    ) INTO es_inv;
    
    RETURN es_inv;
END //
DELIMITER ;
SELECT es_investigador(8);


-- Función 15: Contar áreas asignadas a vigilante
DELIMITER //
CREATE FUNCTION areas_asignadas_vigilante(p_idVigilancia INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    
    SELECT COUNT(*) INTO total
    FROM vigilanciaArea
    WHERE idVigilancia = p_idVigilancia;
    
    RETURN total;
END //
DELIMITER ;
SELECT areas_asignadas_vigilante(12);  

-- Función 16: Calcular superficie total de áreas asignadas a conservación
DELIMITER //
CREATE FUNCTION superficie_areas_conservacion(p_idConservacion INT) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    
    SELECT SUM(a.extencionArea) INTO total
    FROM conservacionArea ca
    JOIN area a ON ca.idArea = a.id
    WHERE ca.idConservacion = p_idConservacion;
    
    RETURN IFNULL(total, 0);
END //
DELIMITER ;
SELECT superficie_areas_conservacion(13);  

-- Función 17: Calcular promedio de especies por área en un parque
DELIMITER //
CREATE FUNCTION promedio_especies_por_area(p_idParque INT) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total_areas INT;
    DECLARE total_especies INT;
    
    SELECT COUNT(DISTINCT a.id), COUNT(DISTINCT e.id)
    INTO total_areas, total_especies
    FROM parque p
    JOIN area a ON p.id = a.idParque
    LEFT JOIN especie e ON a.id = e.idArea
    WHERE p.id = p_idParque;
    
    IF total_areas IS NULL OR total_areas = 0 THEN
        RETURN 0;
    ELSE
        RETURN ROUND(total_especies / total_areas, 2);
    END IF;
END //
DELIMITER ;
SELECT promedio_especies_por_area(14);  

-- Función 18: Calcular costo total de proyectos por investigador
DELIMITER //
CREATE FUNCTION costo_proyectos_investigador(p_idInvestigador INT) 
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(12,2);
    
    SELECT SUM(p.presupuesto) INTO total
    FROM investigadorProyecto ip
    JOIN proyecto p ON ip.idProyecto = p.id
    WHERE ip.idInvestigador = p_idInvestigador;
    
    RETURN IFNULL(total, 0);
END //
DELIMITER ;
SELECT costo_proyectos_investigador(15);  

-- Función 19: Verificar si un departamento tiene parques
DELIMITER //
CREATE FUNCTION departamento_tiene_parques(p_idDepartamento INT) 
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE tiene_parques BOOLEAN;
    
    SELECT EXISTS(
        SELECT 1 FROM departamentoParque WHERE idDepartamento = p_idDepartamento
    ) INTO tiene_parques;
    
    RETURN tiene_parques;
END //
DELIMITER ;
SELECT departamento_tiene_parques(16);  

-- Función 20: Calcular porcentaje de especies por tipo
DELIMITER //
CREATE FUNCTION porcentaje_especies_por_tipo(p_tipoEspecie ENUM("vegetales", "animales", "minerales")) 
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE total_especies INT;
    DECLARE especies_tipo INT;
    
    SELECT COUNT(*) INTO total_especies FROM especie;
    
    SELECT COUNT(*) INTO especies_tipo
    FROM especie
    WHERE tipoEspecie = p_tipoEspecie;
    
    IF total_especies = 0 THEN
        RETURN 0;
    ELSE
        RETURN ROUND((especies_tipo / total_especies) * 100, 2);
    END IF;
END //
DELIMITER ;
SELECT porcentaje_especies_por_tipo('minerales');






