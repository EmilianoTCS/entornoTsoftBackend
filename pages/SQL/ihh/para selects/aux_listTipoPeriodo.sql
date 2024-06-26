DROP PROCEDURE IF EXISTS `SP_ihh_aux_listadoTipoPeriodo`;
DELIMITER $$
CREATE PROCEDURE `SP_ihh_aux_listadoTipoPeriodo`(
    OUT `OUT_CODRESULT` CHAR(2), 
    OUT `OUT_MJERESULT` VARCHAR(200))

BEGIN
        SET OUT_CODRESULT = "00";
        SET OUT_MJERESULT = "Operación exitosa.";
        
           SELECT 
           OUT_CODRESULT, OUT_MJERESULT,
           tp.idTipoPeriodo,
           UPPER(tp.nomTipoPeriodo) nomTipoPeriodo
           FROM ihhtipoPeriodo tp
           WHERE tp.isActive = 1
           ORDER BY tp.nomTipoPeriodo;
        
    END$$
DELIMITER ;