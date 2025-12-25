DROP PROCEDURE IF EXISTS `SP_ihh_listadoTipoElemento`;
DELIMITER $$
CREATE PROCEDURE `SP_ihh_listadoTipoElemento`(
    IN `IN_inicio` INT, 
    IN `IN_cantidadPorPagina` INT)

BEGIN
           DECLARE temp_cantRegistros INT;
           
           SELECT COUNT(te.idTipoElemento) INTO temp_cantRegistros 
           FROM ihhtipoelemento te
           WHERE te.isActive = 1;

           SELECT
           temp_cantRegistros,
           te.idTipoElemento,
           UPPER(te.nomTipoElemento) nomTipoElemento,
           UPPER(te.descripcion) descripcion
           FROM ihhtipoelemento te
           WHERE te.isActive = 1
           ORDER BY te.nomTipoElemento
           LIMIT IN_inicio, IN_cantidadPorPagina;
        
    END$$
DELIMITER ;