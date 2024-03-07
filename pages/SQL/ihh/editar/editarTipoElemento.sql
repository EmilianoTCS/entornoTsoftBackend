DROP PROCEDURE IF EXISTS `SP_ihh_editarTipoElemento`;

DELIMITER $$
CREATE PROCEDURE `SP_ihh_editarTipoElemento`(
    IN `IN_idTipoElemento` INT, 
    IN `IN_nomTipoElemento` VARCHAR(100), 
    IN `IN_descripcion` TEXT, 
    IN `IN_isActive` TINYINT, 
    IN `IN_usuarioModificacion` VARCHAR(30), 
    OUT `OUT_CODRESULT` CHAR(2), 
    OUT `OUT_MJERESULT` VARCHAR(500))
BEGIN
          DECLARE str_codMySQL CHAR(5) DEFAULT '00000';
          DECLARE str_msgMySQL VARCHAR(100);
          DECLARE str_mjeInterno VARCHAR(500);

          DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
           GET DIAGNOSTICS CONDITION 1
                str_codMySQL = RETURNED_SQLSTATE, str_msgMySQL = MESSAGE_TEXT;
           ROLLBACK;

          SET str_mjeInterno = CONCAT('SP_ihh_editarTipoElemento: Error al insertar registro --> IN_idTipoElemento: [', IN_idTipoElemento, '] - IN_nomTipoElemento: [', IN_nomTipoElemento, '] - IN_descripcion: [', IN_descripcion, '] - IN_isActive: [', IN_isActive, '] - IN_usuarioModificacion: [', IN_usuarioModificacion, ']');


          INSERT INTO logErroresObj (idLogErrorObj, nomObjeto, codError, descError, fechaHoraError, codErrorInterno, descErrorInterno) 
          VALUES(null, 'SP_ihh_editarTipoElemento', str_codMySQL, str_msgMySQL, now(), '13', str_mjeInterno);
          COMMIT;

          SET OUT_CODRESULT = '13';
         SET OUT_MJERESULT = concat(str_codMySQL, ' - ', str_msgMySQL);
        SELECT OUT_MJERESULT, OUT_CODRESULT;

  END;

            IF IN_idTipoElemento IS NULL 
            OR IN_nomTipoElemento IS NULL 
            OR IN_isActive IS NULL 
            OR IN_usuarioModificacion IS NULL 
           
            THEN
                SET OUT_MJERESULT = "Uno o más parámetros de entrada vienen nulos / vacíos";
                SET OUT_CODRESULT = '01';
                SELECT OUT_MJERESULT, OUT_CODRESULT;

            ELSEIF TRIM(IN_nomTipoElemento) = '' THEN
                SET OUT_CODRESULT = '02';
                SET OUT_MJERESULT = 'El tipo de elemento no debe estar vacío';
                SELECT OUT_MJERESULT, OUT_CODRESULT;
            ELSEIF IN_idTipoElemento < 1 THEN
                SET OUT_CODRESULT = '03';
                SET OUT_MJERESULT = 'El id del tipo de elemento debe ser mayor a cero';
                SELECT OUT_MJERESULT, OUT_CODRESULT;


            ELSE

                SET AUTOCOMMIT = 0;
                START TRANSACTION;

            
             UPDATE ihhtipoelemento SET
                 nomTipoElemento = IN_nomTipoElemento, 
                 descripcion = IN_descripcion,
                 isActive = IN_isActive,
                 fechaModificacion = CURRENT_TIMESTAMP, 
                 usuarioModificacion = IN_usuarioModificacion
             WHERE idTipoElemento = IN_idTipoElemento;

             COMMIT;
                SET OUT_CODRESULT = '00';
                SET OUT_MJERESULT = 'Success';

           SELECT 
           OUT_CODRESULT, OUT_MJERESULT,
           te.idTipoElemento,
           UPPER(te.nomTipoElemento) nomTipoElemento,
           UPPER(te.descripcion) descripcion
           FROM ihhtipoelemento te
           WHERE te.isActive = 1 AND te.idTipoElemento = IN_idTipoElemento
           ORDER BY te.nomTipoElemento;   
     END IF;
END$$
DELIMITER ;