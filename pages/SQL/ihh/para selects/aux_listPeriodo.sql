DROP PROCEDURE IF EXISTS `SP_ihh_aux_listadoPeriodos`;
DELIMITER $$
CREATE PROCEDURE `SP_ihh_aux_listadoPeriodos`(
    OUT `OUT_CODRESULT` CHAR(2), 
    OUT `OUT_MJERESULT` VARCHAR(200))

BEGIN
        SET OUT_CODRESULT = "00";
        SET OUT_MJERESULT = "Operación exitosa.";
        
           SELECT 
           OUT_CODRESULT, OUT_MJERESULT,
           p.idPeriodo,
           UPPER(p.nomPeriodo) nomPeriodo
           FROM ihhperiodo p
           WHERE p.isActive = 1
           ORDER BY p.nomPeriodo;
        
    END$$
DELIMITER ;