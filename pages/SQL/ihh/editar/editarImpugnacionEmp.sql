DROP PROCEDURE IF EXISTS `SP_ihh_editarImpugnacionEmp`;
}
DELIMITER $$
CREATE PROCEDURE `SP_ihh_editarImpugnacionEmp`(
    IN `IN_idImpugnacionEmp` INT, 
    IN `IN_idEmpleado` INT, 
    IN `IN_idElemento` INT, 
    IN `IN_idPeriodo` INT, 
    IN `IN_cantHorasPeriodo` INT, 
    IN `IN_cantHorasExtra` INT, 
    IN `IN_factor` FLOAT, 
    IN `IN_idAcop` FLOAT, 
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

          SET str_mjeInterno = CONCAT('SP_ihh_editarImpugnacionEmp: Error al insertar registro --> IN_idImpugnacionEmp: [', IN_idImpugnacionEmp, '] - IN_idEmpleado: [', IN_idEmpleado, '] - IN_idElemento: [', IN_idElemento, '] - IN_idPeriodo: [', IN_idPeriodo, '] - IN_cantHorasPeriodo: [', IN_cantHorasPeriodo, '] - IN_cantHorasExtra: [', IN_cantHorasExtra, '] - IN_factor: [', IN_factor, '] - IN_idAcop: [', IN_idAcop, '] - IN_isActive: [', IN_isActive, '] - IN_usuarioModificacion: [', IN_usuarioModificacion, ']');


          INSERT INTO logErroresObj (idLogErrorObj, nomObjeto, codError, descError, fechaHoraError, codErrorInterno, descErrorInterno) 
          VALUES(null, 'SP_ihh_editarImpugnacionEmp', str_codMySQL, str_msgMySQL, now(), '13', str_mjeInterno);
          COMMIT;

          SET OUT_CODRESULT = '13';
         SET OUT_MJERESULT = concat(str_codMySQL, ' - ', str_msgMySQL);
        SELECT OUT_MJERESULT, OUT_CODRESULT;

  END;

            IF IN_idImpugnacionEmp IS NULL 
            OR IN_idEmpleado IS NULL 
            OR IN_idElemento IS NULL 
            OR IN_idPeriodo IS NULL 
            OR IN_cantHorasPeriodo IS NULL 
            OR IN_factor IS NULL 
            OR IN_idAcop IS NULL 
            OR IN_isActive IS NULL 
            OR IN_usuarioModificacion IS NULL 
           

            THEN
                SET OUT_MJERESULT = "Uno o más parámetros de entrada vienen nulos / vacíos";
                SET OUT_CODRESULT = '01';
                SELECT OUT_MJERESULT, OUT_CODRESULT;

            ELSEIF IN_idEmpleado < 1 THEN
                SET OUT_CODRESULT = '02';
                SET OUT_MJERESULT = 'El id del empleado debe ser mayor a cero';
                SELECT OUT_MJERESULT, OUT_CODRESULT;
                
            ELSEIF IN_idElemento < 1 THEN
                SET OUT_CODRESULT = '03';
                SET OUT_MJERESULT = 'El id del elemento debe ser mayor a cero';
                SELECT OUT_MJERESULT, OUT_CODRESULT;

            ELSEIF IN_idPeriodo < 1 THEN
                SET OUT_CODRESULT = '04';
                SET OUT_MJERESULT = 'El id del periodo debe ser mayor a cero';
                SELECT OUT_MJERESULT, OUT_CODRESULT;
                
            ELSEIF IN_cantHorasPeriodo < 1 THEN
                SET OUT_CODRESULT = '05';
                SET OUT_MJERESULT = 'La cantidad de horas del periodo debe ser mayor a cero';
                SELECT OUT_MJERESULT, OUT_CODRESULT;
  
            ELSEIF IN_factor < 1 THEN
                SET OUT_CODRESULT = '06';
                SET OUT_MJERESULT = 'El factor del empleado debe ser mayor a cero';
                SELECT OUT_MJERESULT, OUT_CODRESULT;  

            ELSEIF IN_idAcop < 1 THEN
                SET OUT_CODRESULT = '07';
                SET OUT_MJERESULT = 'EL id del acop debe ser mayor a cero';
                SELECT OUT_MJERESULT, OUT_CODRESULT;  

            ELSEIF IN_isActive NOT IN (1,0) THEN
                SET OUT_CODRESULT = '08';
                SET OUT_MJERESULT = 'El estado del registro debe ser 1 (activo) o 0 (inactivo)';
                SELECT OUT_MJERESULT, OUT_CODRESULT;

            ELSEIF TRIM(IN_usuarioModificacion) = '' THEN
                SET OUT_CODRESULT = '09';
                SET OUT_MJERESULT = 'El usuario administrador no puede estar vacío';
                SELECT OUT_MJERESULT, OUT_CODRESULT;

            ELSEIF IN_idImpugnacionEmp < 1 THEN
                SET OUT_CODRESULT = '10';
                SET OUT_MJERESULT = 'El id impugnacionEmp debe ser mayor a cero';
                SELECT OUT_MJERESULT, OUT_CODRESULT;

            ELSE

                SET AUTOCOMMIT = 0;
                START TRANSACTION;

            
             UPDATE ihhimpugnacionemp SET
                 idEmpleado = IN_idEmpleado,
                 idElemento = IN_idElemento,
                 idPeriodo = IN_idPeriodo,
                 cantHorasPeriodo = IN_cantHorasPeriodo, 
                 cantHorasExtra = IN_cantHorasExtra,
                 factor = IN_factor,
                 idAcop = IN_idAcop,
                 isActive = IN_isActive, 
                 fechaModificacion = CURRENT_TIMESTAMP(),
                 usuarioModificacion = IN_usuarioModificacion

                 WHERE idImpugnacionEmp = IN_idImpugnacionEmp
                 ;
                  
             COMMIT;
                SET OUT_CODRESULT = '00';
                SET OUT_MJERESULT = 'Success';

          SELECT 
            OUT_CODRESULT, OUT_MJERESULT,
            ie.idImpugnacionEmp,
            ie.idEmpleado,
            UPPER(emp.nomEmpleado) nomEmpleado,
            ie.idElemento,
            UPPER(ei.nomElemento) nomElemento,
            ie.cantHorasPeriodo,
            ie.cantHorasExtra,
            ie.factor,
            ie.idAcop
            FROM ihhimpugnacionemp ie
            INNER JOIN empleado emp ON (emp.idEmpleado = ie.idEmpleado AND emp.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhelementoimp ei ON (ei.idElementoImp = ie.idElemento AND ei.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhperiodo p ON (p.idPeriodo = ie.idPeriodo AND p.isActive = 1 AND ie.isActive = 1)
            WHERE ei.idImpugnacionEmp = IN_idImpugnacionEmp    
            ORDER BY emp.nomEmpleado, ei.nomElemento;
     END IF;
END$$
DELIMITER ;