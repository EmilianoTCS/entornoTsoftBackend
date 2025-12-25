DROP PROCEDURE IF EXISTS `SP_ihh_insertarTipoPeriodo`;

DELIMITER $$
CREATE PROCEDURE `SP_ihh_insertarTipoPeriodo`(
    IN `IN_nomTipoPeriodo` VARCHAR(100), 
    IN `IN_dias` INT, 
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

          SET str_mjeInterno = CONCAT('SP_ihh_insertarTipoPeriodo: Error al insertar registro --> IN_nomTipoPeriodo: [', IN_nomTipoPeriodo, '] - IN_dias: [', IN_dias, '] - IN_descripcion: [', IN_descripcion, '] - IN_isActive: [', IN_isActive, '] - IN_usuarioCreacion: [', IN_usuarioCreacion, ']');


          INSERT INTO logErroresObj (idLogErrorObj, nomObjeto, codError, descError, fechaHoraError, codErrorInterno, descErrorInterno) 
          VALUES(null, 'SP_ihh_insertarTipoPeriodo', str_codMySQL, str_msgMySQL, now(), '13', str_mjeInterno);
          COMMIT;

          SET OUT_CODRESULT = '13';
         SET OUT_MJERESULT = concat(str_codMySQL, ' - ', str_msgMySQL);
        SELECT OUT_MJERESULT, OUT_CODRESULT;

  END;

            IF IN_nomTipoPeriodo IS NULL 
            OR IN_dias IS NULL 
            OR IN_isActive IS NULL 
            OR IN_usuarioCreacion IS NULL 
           
            THEN
                SET OUT_MJERESULT = "Uno o más parámetros de entrada vienen nulos / vacíos";
                SET OUT_CODRESULT = '01';
                SELECT OUT_MJERESULT, OUT_CODRESULT;

            ELSEIF TRIM(IN_nomTipoPeriodo) = '' THEN
                SET OUT_CODRESULT = '02';
                SET OUT_MJERESULT = 'El tipo de periodo no debe estar vacío';
                SELECT OUT_MJERESULT, OUT_CODRESULT;

            ELSEIF IN_dias < 1 THEN
                SET OUT_CODRESULT = '03';
                SET OUT_MJERESULT = 'La cantidad de días debe ser mayor a cero';
                SELECT OUT_MJERESULT, OUT_CODRESULT;


            ELSE

                SET AUTOCOMMIT = 0;
                START TRANSACTION;

            
             INSERT INTO ihhtipoperiodo (
                 nomTipoPeriodo, 
                 dias, 
                 descripcion, 
                 isActive, 
                 fechaCreacion, 
                 usuarioCreacion, 
                 fechaModificacion, 
                 usuarioModificacion) VALUES 
                 (IN_nomTipoPeriodo, 
                  IN_dias, 
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
           tp.idTipoPeriodo,
           UPPER(tp.nomTipoPeriodo) nomTipoPeriodo,
           tp.dias,
           UPPER(tp.descripcion) descripcion
           FROM ihhtipoperiodo tp
           WHERE tp.isActive = 1 AND tp.idTipoPeriodo = LAST_INSERT_ID()
           ORDER BY tp.nomTipoPeriodo;  
     END IF;
END$$
DELIMITER ;