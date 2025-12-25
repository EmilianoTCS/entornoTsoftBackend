DROP PROCEDURE IF EXISTS `SP_ihh_aux_listadoAcops`;
DELIMITER $$
CREATE PROCEDURE `SP_ihh_aux_listadoAcops`(
    OUT `OUT_CODRESULT` CHAR(2), 
    OUT `OUT_MJERESULT` VARCHAR(200))

BEGIN
        SET OUT_CODRESULT = "00";
        SET OUT_MJERESULT = "Operación exitosa.";
        
           SELECT 
           OUT_CODRESULT, OUT_MJERESULT,
           a.idAcop,
           UPPER(p.nomProyecto) nomProyecto
           FROM ihhacop a
           INNER JOIN eddproyecto p ON (p.idEDDProyecto = a.idProyecto AND p.isActive = 1 AND a.isActive = 1)
           ORDER BY p.nomProyecto;
        
    END$$
DELIMITER ;