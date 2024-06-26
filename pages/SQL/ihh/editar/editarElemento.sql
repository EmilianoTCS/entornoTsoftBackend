DROP PROCEDURE IF EXISTS `SP_ihh_editarElemento`;

DELIMITER $$
CREATE PROCEDURE `SP_ihh_editarElemento`(
    IN `IN_idElementoImp` INT, 
    IN `IN_idTipoElemento` INT, 
    IN `IN_nomElemento` TEXT, 
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

          SET str_mjeInterno = CONCAT('SP_ihh_editarElemento: Error al insertar registro --> IN_idElementoImp: [', IN_idElementoImp, '] - IN_idTipoElemento: [', IN_idTipoElemento, '] - IN_nomElemento: [', IN_nomElemento, '] - IN_descripcion: [', IN_descripcion, '] - IN_isActive: [', IN_isActive, '] - IN_usuarioModificacion: [', IN_usuarioModificacion, ']');


          INSERT INTO logErroresObj (idLogErrorObj, nomObjeto, codError, descError, fechaHoraError, codErrorInterno, descErrorInterno) 
          VALUES(null, 'SP_ihh_editarElemento', str_codMySQL, str_msgMySQL, now(), '13', str_mjeInterno);
          COMMIT;

          SET OUT_CODRESULT = '13';
         SET OUT_MJERESULT = concat(str_codMySQL, ' - ', str_msgMySQL);
        SELECT OUT_MJERESULT, OUT_CODRESULT;

  END;

            IF IN_idElementoImp IS NULL 
            OR IN_idTipoElemento IS NULL 
            OR IN_nomElemento IS NULL 
            OR IN_isActive IS NULL 
            OR IN_usuarioModificacion IS NULL 
           
            OR IN_usuarioModificacion = "%null%" 

            THEN
                SET OUT_MJERESULT = "Uno o más parámetros de entrada vienen nulos / vacíos";
                SET OUT_CODRESULT = '01';
                SELECT OUT_MJERESULT, OUT_CODRESULT;

            ELSEIF IN_idTipoElemento < 1 THEN
                SET OUT_CODRESULT = '02';
                SET OUT_MJERESULT = 'EL id del tipoElemento debe ser mayor a cero';
                SELECT OUT_MJERESULT, OUT_CODRESULT;

            ELSEIF TRIM(IN_nomElemento) = '' THEN
                SET OUT_CODRESULT = '03';
                SET OUT_MJERESULT = 'El nombre del elemento no debe estar vacío';  
                SELECT OUT_MJERESULT, OUT_CODRESULT;

            ELSEIF IN_isActive NOT IN (1,0) THEN
                SET OUT_CODRESULT = '05';
                SET OUT_MJERESULT = 'El estado del registro debe ser 1 (activo) o 0 (inactivo)';
                SELECT OUT_MJERESULT, OUT_CODRESULT;

            ELSEIF TRIM(IN_usuarioModificacion) = '' THEN
                SET OUT_CODRESULT = '06';
                SET OUT_MJERESULT = 'El usuario administrador no puede estar vacío';
                SELECT OUT_MJERESULT, OUT_CODRESULT;

            ELSEIF IN_idElementoImp < 1 THEN
                SET OUT_CODRESULT = '07';
                SET OUT_MJERESULT = 'El id del elemento no puede ser menor a cero';
                SELECT OUT_MJERESULT, OUT_CODRESULT;


            ELSE

                SET AUTOCOMMIT = 0;
                START TRANSACTION;

            
             UPDATE ihhelementoimp SET
                 idTipoElemento = IN_idTipoElemento,
                 nomElemento = IN_nomElemento,
                 descripcion = IN_descripcion, 
                 isActive = IN_isActive,
                 fechaModificacion = CURRENT_TIMESTAMP(),
                 usuarioModificacion = IN_usuarioModificacion
            WHERE idElementoImp = IN_idElementoImp ;
                   
                  
                  
                   
                  
             COMMIT;
                SET OUT_CODRESULT = '00';
                SET OUT_MJERESULT = 'Success';

           SELECT 
            OUT_CODRESULT, OUT_MJERESULT,
            ei.idElementoImp, 
            ei.idTipoElemento, 
            UPPER(te.nomTipoElemento) nomTipoElemento, 
            UPPER(ei.nomElemento) nomElemento, 
            UPPER(ei.descripcion) descripcion 
            FROM ihhelementoImp ei
            INNER JOIN ihhtipoelemento te ON (
                te.idTipoElemento = ei.idTipoElemento 
                AND ei.isActive = 1 
                AND te.isActive = 1) 
            WHERE ei.idElementoImp = IN_idElementoImp;    
     END IF;
END$$
DELIMITER ;