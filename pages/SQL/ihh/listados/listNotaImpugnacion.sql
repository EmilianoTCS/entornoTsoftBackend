DROP PROCEDURE IF EXISTS `SP_ihh_listadoNotaImpugnacion`;
DELIMITER $$
CREATE PROCEDURE `SP_ihh_listadoNotaImpugnacion`(
    IN `IN_idImpugnacionEmp` INT, 
    IN `IN_inicio` INT, 
    IN `IN_cantidadPorPagina` INT)

BEGIN
        DECLARE temp_cantRegistros INT;

    -- Si no se especifica el filtro
    IF IN_idImpugnacionEmp = 0 THEN

            SELECT COUNT(ni.idNotaImpugnacion) INTO temp_cantRegistros 
            FROM ihhnotaimpugnacion ni 
            INNER JOIN ihhimpugnacionemp ie ON (ie.idImpugnacionEmp = ni.idImpugnacionEmp AND ie.isActive = 1 AND ni.isActive = 1);

            SELECT 
            temp_cantRegistros,
            ni.idNotaImpugnacion,
            ni.idImpugnacionEmp, 
            UPPER(ni.nota) nota
            FROM ihhnotaimpugnacion ni 
            INNER JOIN ihhimpugnacionemp ie ON (ie.idImpugnacionEmp = ni.idImpugnacionEmp AND ie.isActive = 1 AND ni.isActive = 1)
            LIMIT IN_inicio, IN_cantidadPorPagina;

       -- Si es especificado
        ELSE

            SELECT COUNT(ni.idNotaImpugnacion) INTO temp_cantRegistros 
            FROM ihhnotaimpugnacion ni 
            INNER JOIN ihhimpugnacionemp ie ON (ie.idImpugnacionEmp = ni.idImpugnacionEmp 
                                                AND ni.idImpugnacionEmp = IN_idImpugnacionEmp 
                                                AND ie.isActive = 1 
                                                AND ni.isActive = 1);

            SELECT
            temp_cantRegistros,
            ni.idNotaImpugnacion, ni.idImpugnacionEmp, UPPER(ni.nota) nota
            FROM ihhnotaimpugnacion ni 
            INNER JOIN ihhimpugnacionemp ie ON (ie.idImpugnacionEmp = ni.idImpugnacionEmp 
                                                AND ni.idImpugnacionEmp = IN_idImpugnacionEmp 
                                                AND ie.isActive = 1 
                                                AND ni.isActive = 1)
            LIMIT IN_inicio, IN_cantidadPorPagina;
        END IF;         
    END$$
DELIMITER ;