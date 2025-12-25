DROP PROCEDURE IF EXISTS `SP_ihh_aux_listadoTipoElemento`;
DELIMITER $$
CREATE PROCEDURE `SP_ihh_aux_listadoTipoElemento`(
    OUT `OUT_CODRESULT` CHAR(2), 
    OUT `OUT_MJERESULT` VARCHAR(200))

BEGIN
        SET OUT_CODRESULT = "00";
        SET OUT_MJERESULT = "Operación exitosa.";
        
           SELECT 
           OUT_CODRESULT, OUT_MJERESULT,
           te.idTipoElemento,
           UPPER(te.nomTipoElemento) nomTipoElemento
           FROM ihhtipoelemento te
           WHERE te.isActive = 1
           ORDER BY te.nomTipoElemento;
        
    END$$
DELIMITER ;