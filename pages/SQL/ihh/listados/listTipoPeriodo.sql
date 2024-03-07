DROP PROCEDURE IF EXISTS `SP_ihh_listadoTipoPeriodo`;
DELIMITER $$
CREATE PROCEDURE `SP_ihh_listadoTipoPeriodo`(
    IN `IN_inicio` INT, 
    IN `IN_cantidadPorPagina` INT)

BEGIN
     DECLARE temp_cantRegistros INT;
            SELECT COUNT(tp.idTipoPeriodo) INTO temp_cantRegistros 
            FROM ihhtipoperiodo tp
            WHERE tp.isActive = 1;
           SELECT 
            temp_cantRegistros,
           tp.idTipoPeriodo,
           UPPER(tp.nomTipoPeriodo) nomTipoPeriodo,
           tp.dias,
           UPPER(tp.descripcion) descripcion
           FROM ihhtipoperiodo tp
           WHERE tp.isActive = 1
           ORDER BY tp.nomTipoPeriodo
           LIMIT IN_inicio, IN_cantidadPorPagina;
        
    END$$
DELIMITER ;