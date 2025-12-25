DROP PROCEDURE IF EXISTS `SP_ihh_insertarPeriodo`;

DELIMITER $$
CREATE PROCEDURE `SP_ihh_insertarPeriodo`(
    IN `IN_idTipoPeriodo` INT, 
    IN `IN_nomPeriodo` VARCHAR(50), 
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

          SET str_mjeInterno = CONCAT('SP_ihh_insertarPeriodo: Error al insertar registro --> IN_idTipoPeriodo: [', IN_idTipoPeriodo, '] - IN_nomPeriodo: [', IN_nomPeriodo, '] - IN_descripcion: [', IN_descripcion, '] - IN_isActive: [', IN_isActive, '] - IN_usuarioCreacion: [', IN_usuarioCreacion, ']');


          INSERT INTO logErroresObj (idLogErrorObj, nomObjeto, codError, descError, fechaHoraError, codErrorInterno, descErrorInterno) 
          VALUES(null, 'SP_ihh_insertarPeriodo', str_codMySQL, str_msgMySQL, now(), '13', str_mjeInterno);
          COMMIT;

          SET OUT_CODRESULT = '13';
         SET OUT_MJERESULT = concat(str_codMySQL, ' - ', str_msgMySQL);
        SELECT OUT_MJERESULT, OUT_CODRESULT;

  END;

            IF IN_idTipoPeriodo IS NULL 
            OR IN_nomPeriodo IS NULL 
            OR IN_descripcion IS NULL 
            OR IN_isActive IS NULL 
            OR IN_usuarioCreacion IS NULL 
           
            THEN
                SET OUT_MJERESULT = "Uno o más parámetros de entrada vienen nulos / vacíos";
                SET OUT_CODRESULT = '01';
                SELECT OUT_MJERESULT, OUT_CODRESULT;

            ELSEIF IN_idTipoPeriodo < 1 THEN
                SET OUT_CODRESULT = '02';
                SET OUT_MJERESULT = 'EL id del idImpugnacionEmp debe ser mayor a cero';
                SELECT OUT_MJERESULT, OUT_CODRESULT;

            ELSEIF TRIM(IN_nomPeriodo) = '' THEN
                SET OUT_CODRESULT = '03';
                SET OUT_MJERESULT = 'EL nombre del periodo no debe estar vacío.';
                SELECT OUT_MJERESULT, OUT_CODRESULT;

            ELSEIF IN_isActive NOT IN (1,0) THEN
                SET OUT_CODRESULT = '04';
                SET OUT_MJERESULT = 'El estado del registro debe ser 1 (activo) o 0 (inactivo)';
                SELECT OUT_MJERESULT, OUT_CODRESULT;

            ELSEIF TRIM(IN_usuarioCreacion) = '' THEN
                SET OUT_CODRESULT = '05';
                SET OUT_MJERESULT = 'El usuario administrador no puede estar vacío';
                SELECT OUT_MJERESULT, OUT_CODRESULT;                  

            ELSE

                SET AUTOCOMMIT = 0;
                START TRANSACTION;

            
             INSERT INTO ihhperiodo (
                 idTipoPeriodo, 
                 nomPeriodo, 
                 descripcion, 
                 isActive, 
                 fechaCreacion, 
                 usuarioCreacion, 
                 fechaModificacion, 
                 usuarioModificacion) VALUES 
                 (IN_idTipoPeriodo, 
                  IN_nomPeriodo, 
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
           p.idPeriodo,
           p.idTipoPeriodo,
           UPPER(tp.nomTipoPeriodo) nomTipoPeriodo,
           UPPER(p.descripcion) descripcion
           FROM ihhperiodo p
           INNER JOIN ihhtipoperiodo tp ON (tp.idTipoPeriodo = p.idTipoPeriodo AND p.isActive = 1 AND tp.isActive = 1)
            WHERE p.idPeriodo = LAST_INSERT_ID()   
           ORDER BY tp.nomTipoPeriodo;
     END IF;
END$$
DELIMITER ;