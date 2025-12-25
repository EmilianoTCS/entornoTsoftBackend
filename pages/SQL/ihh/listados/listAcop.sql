-- Eliminar el procedimiento almacenado si ya existe
DROP PROCEDURE IF EXISTS `SP_ihh_listadoAcop`;

-- Cambiar el delimitador para manejar la creación del procedimiento
DELIMITER $$

-- Crear el procedimiento almacenado
CREATE PROCEDURE `SP_ihh_listadoAcop`(
    IN `IN_idProyecto` INT, 
    IN `IN_inicio` INT, 
    IN `IN_cantidadPorPagina` INT)
BEGIN
  DECLARE temp_cantRegistros INT;

    -- Verificar si no se especifica un proyecto
    IF IN_idProyecto = 0 THEN
        -- Recuperar los datos de todos los proyectos activos
        SELECT COUNT(ac.idAcop) INTO temp_cantRegistros FROM ihhacop ac INNER JOIN eddproyecto ep ON (
            ep.idEDDProyecto = ac.idProyecto AND 
            ac.isActive = 1 AND ep.isActive = 1);

        SELECT
            temp_cantRegistros,
            ac.idAcop, 
            ac.idProyecto, 
            UPPER(ep.nomProyecto) nomProyecto, 
            DATE_FORMAT(ep.fechaInicio, "%d/%m/%Y") as fechaIniProy, 
            DATE_FORMAT(ep.fechaFin, "%d/%m/%Y") as fechaFinProy,
            ac.presupuestoTotal,
            ROUND(ac.presupuestoTotal / ac.cantTotalMeses, 2) presupuestoMen,
            ac.cantTotalMeses
        FROM ihhacop ac
        INNER JOIN eddproyecto ep ON (
            ep.idEDDProyecto = ac.idProyecto AND 
            ac.isActive = 1 AND ep.isActive = 1)
        ORDER BY ep.nomProyecto
        LIMIT IN_inicio, IN_cantidadPorPagina;
    
    -- Si se especifica un proyecto
    ELSE
        -- Recuperar los datos del proyecto específico

        SELECT COUNT(ac.idAcop) INTO temp_cantRegistros FROM ihhacop ac INNER JOIN eddproyecto ep ON (
            ep.idEDDProyecto = ac.idProyecto AND
            ac.idProyecto = IN_idProyecto AND 
            ep.isActive = 1 AND 
            ac.isActive = 1);

        SELECT
            ac.idAcop, 
            ac.idProyecto, 
            UPPER(ep.nomProyecto) nomProyecto, 
            temp_cantRegistros,
            DATE_FORMAT(ep.fechaInicio, "%d/%m/%Y") as fechaIniProy, 
            DATE_FORMAT(ep.fechaFin, "%d/%m/%Y") as fechaFinProy,
            ac.presupuestoTotal,
            ROUND(ac.presupuestoTotal / ac.cantTotalMeses, 2) presupuestoMen,
            ac.cantTotalMeses
        FROM ihhacop ac
        INNER JOIN eddproyecto ep ON (
            ep.idEDDProyecto = ac.idProyecto AND
            ac.idProyecto = IN_idProyecto AND 
            ep.isActive = 1 AND 
            ac.isActive = 1)
        ORDER BY ep.nomProyecto
        LIMIT  IN_inicio , IN_cantidadPorPagina;
    END IF;
END $$

-- Restaurar el delimitador por defecto
DELIMITER ;
