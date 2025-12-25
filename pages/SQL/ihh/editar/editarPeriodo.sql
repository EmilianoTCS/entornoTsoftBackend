DROP PROCEDURE IF EXISTS `SP_ihh_editarPeriodo`;

DELIMITER $$
CREATE PROCEDURE `SP_ihh_editarPeriodo`(
    IN `IN_idPeriodo` INT, 
    IN `IN_idTipoPeriodo` INT, 
    IN `IN_nomPeriodo` VARCHAR(50), 
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

          SET str_mjeInterno = CONCAT('SP_ihh_editarPeriodo: Error al insertar registro --> IN_idPeriodo: [', IN_idPeriodo, '] - IN_idTipoPeriodo: [', IN_idTipoPeriodo, '] - IN_nomPeriodo: [', IN_nomPeriodo, '] - IN_descripcion: [', IN_descripcion, '] - IN_isActive: [', IN_isActive, '] - IN_usuarioModificacion: [', IN_usuarioModificacion, ']');


          INSERT INTO logErroresObj (idLogErrorObj, nomObjeto, codError, descError, fechaHoraError, codErrorInterno, descErrorInterno) 
          VALUES(null, 'SP_ihh_editarPeriodo', str_codMySQL, str_msgMySQL, now(), '13', str_mjeInterno);
          COMMIT;

          SET OUT_CODRESULT = '13';
         SET OUT_MJERESULT = concat(str_codMySQL, ' - ', str_msgMySQL);
        SELECT OUT_MJERESULT, OUT_CODRESULT;

  END;

            IF IN_idPeriodo IS NULL 
            OR IN_idTipoPeriodo IS NULL 
            OR IN_nomPeriodo IS NULL 
            OR IN_descripcion IS NULL 
            OR IN_isActive IS NULL 
            OR IN_usuarioModificacion IS NULL 
           
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

            ELSEIF TRIM(IN_usuarioModificacion) = '' THEN
                SET OUT_CODRESULT = '05';
                SET OUT_MJERESULT = 'El usuario administrador no puede estar vacío';
                SELECT OUT_MJERESULT, OUT_CODRESULT;                  

            ELSEIF IN_idPeriodo < 1 THEN
                SET OUT_CODRESULT = '06';
                SET OUT_MJERESULT = 'El id del periodo debe ser mayor a cero';
                SELECT OUT_MJERESULT, OUT_CODRESULT;  

            ELSE

                SET AUTOCOMMIT = 0;
                START TRANSACTION;

            
             UPDATE ihhperiodo SET
                 idTipoPeriodo = IN_idTipoPeriodo,
                 nomPeriodo = IN_nomPeriodo,
                 descripcion = IN_descripcion,
                 isActive = IN_isActive,
                 fechaModificacion = CURRENT_TIMESTAMP(),
                 usuarioModificacion = IN_usuarioModificacion
                 WHERE idPeriodo = IN_idPeriodo;

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
            WHERE p.idPeriodo = IN_idPeriodo   
           ORDER BY tp.nomTipoPeriodo;
     END IF;
END$$
DELIMITER ;