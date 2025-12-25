DROP PROCEDURE IF EXISTS `SP_ihh_insertarAcop`;
DELIMITER $$
CREATE PROCEDURE `SP_ihh_insertarAcop`(
    IN `IN_idProyecto` INT, 
    IN `IN_presupuestoTotal` FLOAT, 
    IN `IN_cantTotalMeses` INT, 
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

          SET str_mjeInterno = CONCAT('SP_ihh_insertarAcop: Error al insertar registro --> IN_idProyecto: [', IN_idProyecto, '] - IN_presupuestoTotal: [', IN_presupuestoTotal, '] - IN_cantTotalMeses: [', IN_cantTotalMeses, '] - IN_isActive: [', IN_isActive, '] - IN_usuarioCreacion: [', IN_usuarioCreacion, ']');


          INSERT INTO logErroresObj (idLogErrorObj, nomObjeto, codError, descError, fechaHoraError, codErrorInterno, descErrorInterno) 
          VALUES(null, 'SP_ihh_insertarAcop', str_codMySQL, str_msgMySQL, now(), '13', str_mjeInterno);
          COMMIT;

          SET OUT_CODRESULT = '13';
         SET OUT_MJERESULT = concat(str_codMySQL, ' - ', str_msgMySQL);
        SELECT OUT_MJERESULT, OUT_CODRESULT;

  END;

            IF IN_idProyecto IS NULL 
            OR IN_presupuestoTotal IS NULL 
            OR IN_cantTotalMeses IS NULL 
            OR IN_isActive IS NULL 
            OR IN_usuarioCreacion IS NULL 
           
            OR IN_usuarioCreacion = "%null%" 

            THEN
                SET OUT_MJERESULT = "Uno o más parámetros de entrada vienen nulos / vacíos";
                SET OUT_CODRESULT = '01';
                SELECT OUT_MJERESULT, OUT_CODRESULT;

            ELSEIF IN_idProyecto < 1 THEN
                SET OUT_CODRESULT = '02';
                SET OUT_MJERESULT = 'EL id del proyecto debe ser mayor a cero';
                SELECT OUT_MJERESULT, OUT_CODRESULT;

            ELSEIF IN_presupuestoTotal < 0 THEN
                SET OUT_CODRESULT = '03';
                SET OUT_MJERESULT = 'El presupuesto total debe ser mayor a cero';  
                SELECT OUT_MJERESULT, OUT_CODRESULT;

            ELSEIF IN_cantTotalMeses < 1 THEN
                SET OUT_CODRESULT = '04';
                SET OUT_MJERESULT = 'La cantidad de meses del acop debe ser mayor a cero';
                SELECT OUT_MJERESULT, OUT_CODRESULT;

            ELSEIF IN_isActive NOT IN (1,0) THEN
                SET OUT_CODRESULT = '05';
                SET OUT_MJERESULT = 'El estado del registro debe ser 1 (activo) o 0 (inactivo)';
                SELECT OUT_MJERESULT, OUT_CODRESULT;

            ELSEIF TRIM(IN_usuarioCreacion) = '' THEN
                SET OUT_CODRESULT = '06';
                SET OUT_MJERESULT = 'El usuario administrador no puede estar vacío';
                SELECT OUT_MJERESULT, OUT_CODRESULT;


            ELSE

                SET AUTOCOMMIT = 0;
                START TRANSACTION;

            
             INSERT INTO ihhacop (
                 idProyecto, 
                 presupuestoTotal, 
                 cantTotalMeses,  
                 isActive, 
                 fechaCreacion, 
                 usuarioCreacion, 
                 fechaModificacion, 
                 usuarioModificacion) VALUES 
                 (IN_idProyecto, 
                  IN_presupuestoTotal, 
                  IN_cantTotalMeses, 
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
            ac.idProyecto, 
            UPPER(ep.nomProyecto) nomProyecto, 
            DATE_FORMAT(ep.fechaInicio, "%d/%m/%Y") as fechaIniProy, 
            DATE_FORMAT(ep.fechaFin, "%d/%m/%Y") as fechaFinProy,
            ac.presupuestoTotal,
            ROUND( ac.presupuestoTotal / ac.cantTotalMeses , 2) presupuestoMen,
            ac.cantTotalMeses
            FROM ihhacop ac
            INNER JOIN eddproyecto ep ON (
                        ep.idEDDProyecto = ac.idProyecto AND
                        ep.isActive = 1 AND 
                        ac.isActive = 1)
            WHERE ac.idAcop = LAST_INSERT_ID();           
     END IF;
END$$
DELIMITER ;