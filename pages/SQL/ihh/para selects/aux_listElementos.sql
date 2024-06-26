DROP PROCEDURE IF EXISTS `SP_ihh_aux_listadoElementos`;
DELIMITER $$
CREATE PROCEDURE `SP_ihh_aux_listadoElementos`(
    OUT `OUT_CODRESULT` CHAR(2), 
    OUT `OUT_MJERESULT` VARCHAR(200))

BEGIN
        SET OUT_CODRESULT = "00";
        SET OUT_MJERESULT = "Operación exitosa.";
        
           SELECT 
           OUT_CODRESULT, OUT_MJERESULT,
           ei.idElementoImp,
           UPPER(ei.nomElemento) nomElemento
           FROM ihhelementoimp ei
           WHERE ei.isActive = 1
           ORDER BY ei.nomElemento;
        
    END$$
DELIMITER ;