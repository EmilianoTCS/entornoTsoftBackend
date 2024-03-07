DROP PROCEDURE IF EXISTS `SP_ihh_insertarNotaImpugnacion`;

DELIMITER $$
CREATE PROCEDURE `SP_ihh_insertarNotaImpugnacion`(
    IN `IN_idImpugnacionEmp` INT, 
    IN `IN_nota` TEXT, 
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

          SET str_mjeInterno = CONCAT('SP_ihh_insertarNotaImpugnacion: Error al insertar registro --> IN_idImpugnacionEmp: [', IN_idImpugnacionEmp, '] - IN_nota: [', IN_nota, '] - IN_isActive: [', IN_isActive, '] - IN_usuarioCreacion: [', IN_usuarioCreacion, ']');


          INSERT INTO logErroresObj (idLogErrorObj, nomObjeto, codError, descError, fechaHoraError, codErrorInterno, descErrorInterno) 
          VALUES(null, 'SP_ihh_insertarNotaImpugnacion', str_codMySQL, str_msgMySQL, now(), '13', str_mjeInterno);
          COMMIT;

          SET OUT_CODRESULT = '13';
         SET OUT_MJERESULT = concat(str_codMySQL, ' - ', str_msgMySQL);
        SELECT OUT_MJERESULT, OUT_CODRESULT;

  END;

            IF IN_idImpugnacionEmp IS NULL 
            OR IN_isActive IS NULL 
            OR IN_usuarioCreacion IS NULL 
           
            THEN
                SET OUT_MJERESULT = "Uno o más parámetros de entrada vienen nulos / vacíos";
                SET OUT_CODRESULT = '01';
                SELECT OUT_MJERESULT, OUT_CODRESULT;

            ELSEIF IN_idImpugnacionEmp < 1 THEN
                SET OUT_CODRESULT = '02';
                SET OUT_MJERESULT = 'EL id del idImpugnacionEmp debe ser mayor a cero';
                SELECT OUT_MJERESULT, OUT_CODRESULT;


            ELSE

                SET AUTOCOMMIT = 0;
                START TRANSACTION;

            
             INSERT INTO ihhnotaimpugnacion (
                 idImpugnacionEmp, 
                 nota, 
                 isActive, 
                 fechaCreacion, 
                 usuarioCreacion, 
                 fechaModificacion, 
                 usuarioModificacion) VALUES 
                 (IN_idImpugnacionEmp, 
                  IN_nota, 
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
             ni.idNotaImpugnacion, ni.idImpugnacionEmp, UPPER(ni.nota) nota
            FROM ihhnotaimpugnacion ni 
            INNER JOIN ihhimpugnacionemp ie ON (ie.idImpugnacionEmp = ni.idImpugnacionEmp 
                                                AND ie.isActive = 1 
                                                AND ni.isActive = 1)
            WHERE ni.idNotaImpugnacion = LAST_INSERT_ID();    
     END IF;
END$$
DELIMITER ;