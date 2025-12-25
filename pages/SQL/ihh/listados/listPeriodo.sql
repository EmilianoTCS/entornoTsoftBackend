DROP PROCEDURE IF EXISTS `SP_ihh_listadoPeriodo`;
DELIMITER $$
CREATE PROCEDURE `SP_ihh_listadoPeriodo`(
    IN `IN_idTipoPeriodo` INT, 
    IN `IN_inicio` INT, 
    IN `IN_cantidadPorPagina` INT)

BEGIN
        DECLARE temp_cantRegistros INT;

       -- Si no se especifica el filtro
        IF IN_idTipoPeriodo = 0 THEN

            SELECT COUNT(p.idPeriodo) INTO temp_cantRegistros 
            FROM ihhperiodo p
            INNER JOIN ihhtipoperiodo tp ON (tp.idTipoPeriodo = p.idTipoPeriodo AND p.isActive = 1 AND tp.isActive = 1);

           SELECT 
           temp_cantRegistros,
           p.idPeriodo,
           UPPER(p.nomPeriodo) nomPeriodo,
           p.idTipoPeriodo,
           UPPER(tp.nomTipoPeriodo) nomTipoPeriodo,
           UPPER(p.descripcion) descripcion
           FROM ihhperiodo p
           INNER JOIN ihhtipoperiodo tp ON (tp.idTipoPeriodo = p.idTipoPeriodo AND p.isActive = 1 AND tp.isActive = 1)
           ORDER BY tp.nomTipoPeriodo
           LIMIT IN_inicio, IN_cantidadPorPagina;
       -- Si es especificado
        ELSE
            SELECT COUNT(p.idPeriodo) INTO temp_cantRegistros 
            FROM ihhperiodo p
           INNER JOIN ihhtipoperiodo tp ON (tp.idTipoPeriodo = p.idTipoPeriodo AND p.isActive = 1 AND tp.isActive = 1)
           WHERE p.idTipoPeriodo = IN_idTipoPeriodo;

           SELECT 
           temp_cantRegistros,
           p.idPeriodo,
           UPPER(p.nomPeriodo) nomPeriodo,
           p.idTipoPeriodo,
           UPPER(tp.nomTipoPeriodo) nomTipoPeriodo,
           UPPER(p.descripcion) descripcion
           FROM ihhperiodo p
           INNER JOIN ihhtipoperiodo tp ON (tp.idTipoPeriodo = p.idTipoPeriodo AND p.isActive = 1 AND tp.isActive = 1)
           WHERE p.idTipoPeriodo = IN_idTipoPeriodo
           ORDER BY tp.nomTipoPeriodo
           LIMIT IN_inicio, IN_cantidadPorPagina;
        END IF;         
    END$$
DELIMITER ;