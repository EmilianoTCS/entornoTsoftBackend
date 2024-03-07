DROP PROCEDURE IF EXISTS `SP_ihh_insertarTipoElemento`;

DELIMITER $$
CREATE PROCEDURE `SP_ihh_insertarTipoElemento`(
    IN `IN_nomTipoElemento` VARCHAR(100), 
    IN `IN_descripcion` TEXT, 
    IN `IN_isActive` TINYINT, 
    IN `IN_usuarioCreacion` VARCHAR(30), 
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

          SET str_mjeInterno = CONCAT('SP_ihh_insertarTipoElemento: Error al insertar registro --> IN_nomTipoElemento: [', IN_nomTipoElemento, '] - IN_descripcion: [', IN_descripcion, '] - IN_isActive: [', IN_isActive, '] - IN_usuarioCreacion: [', IN_usuarioCreacion, ']');


          INSERT INTO logErroresObj (idLogErrorObj, nomObjeto, codError, descError, fechaHoraError, codErrorInterno, descErrorInterno) 
          VALUES(null, 'SP_ihh_insertarTipoElemento', str_codMySQL, str_msgMySQL, now(), '13', str_mjeInterno);
          COMMIT;

          SET OUT_CODRESULT = '13';
         SET OUT_MJERESULT = concat(str_codMySQL, ' - ', str_msgMySQL);
        SELECT OUT_MJERESULT, OUT_CODRESULT;

  END;

            IF IN_nomTipoElemento IS NULL 
            OR IN_isActive IS NULL 
            OR IN_usuarioCreacion IS NULL 
           
            THEN
                SET OUT_MJERESULT = "Uno o más parámetros de entrada vienen nulos / vacíos";
                SET OUT_CODRESULT = '01';
                SELECT OUT_MJERESULT, OUT_CODRESULT;

            ELSEIF TRIM(IN_nomTipoElemento) = '' THEN
                SET OUT_CODRESULT = '02';
                SET OUT_MJERESULT = 'El tipo de elemento no debe estar vacío';
                SELECT OUT_MJERESULT, OUT_CODRESULT;


            ELSE

                SET AUTOCOMMIT = 0;
                START TRANSACTION;

            
             INSERT INTO ihhtipoelemento (
                 nomTipoElemento, 
                 descripcion, 
                 isActive, 
                 fechaCreacion, 
                 usuarioCreacion, 
                 fechaModificacion, 
                 usuarioModificacion) VALUES 
                 (IN_nomTipoElemento, 
                  IN_descripcion, 
                  IN_isActive,
                  CURRENT_TIMESTAMP, 
                  IN_usuarioCreacion, 
                  CURRENT_TIMESTAMP, 
                  IN_usuarioCreacion);
             COMMIT;
                SET OUT_CODRESULT = '00';
                SET OUT_MJERESULT = 'Success';

           SELECT 
           OUT_CODRESULT, OUT_MJERESULT,
           te.idTipoElemento,
           UPPER(te.nomTipoElemento) nomTipoElemento,
           UPPER(te.descripcion) descripcion
           FROM ihhtipoelemento te
           WHERE te.isActive = 1 AND te.idTipoElemento = LAST_INSERT_ID()
           ORDER BY te.nomTipoElemento;   
     END IF;
END$$
DELIMITER ;