DROP PROCEDURE IF EXISTS `SP_editarEddProyecto`;
DELIMITER $$
CREATE PROCEDURE `SP_editarEddProyecto`(IN `IN_idEDDProyecto` INT, IN `IN_nomProyecto` VARCHAR(50), IN `IN_fechaIni` DATE, IN `IN_fechaFin` DATE, IN `IN_tipoProyecto` INT, IN `IN_isActive` BOOLEAN, IN `IN_idServicio` INT, IN `IN_usuarioModificacion` VARCHAR(15), OUT `OUT_CODRESULT` CHAR(2), OUT `OUT_MJERESULT` VARCHAR(500))
BEGIN
  		DECLARE str_codMySQL CHAR(5) DEFAULT '00000';
  		DECLARE str_msgMySQL VARCHAR(100);
  		DECLARE str_mjeInterno VARCHAR(500);
 
  		DECLARE EXIT HANDLER FOR SQLEXCEPTION
    	BEGIN
      	 GET DIAGNOSTICS CONDITION 1
       		 str_codMySQL = RETURNED_SQLSTATE, str_msgMySQL = MESSAGE_TEXT;
      	 ROLLBACK;
        
      	SET str_mjeInterno = CONCAT('SP_insertarEddProyecto: Error al insertar registro --> IN_idEDDProyecto: [', IN_idEDDProyecto, '] - IN_nomProyecto: [', IN_nomProyecto, '] - IN_fechaInicio: [', IN_fechaIni, '] - IN_fechaIni: [', IN_fechaFin, '] - IN_isActive: [', IN_isActive, '] - IN_usuarioModificacion: [', IN_usuarioModificacion, ']');

      	INSERT INTO logErroresObj (idLogErrorObj, nomObjeto, codError, descError, fechaHoraError, codErrorInterno, descErrorInterno) 
      	VALUES(null, 'SP_editarEddProyecto', str_codMySQL, str_msgMySQL, now(), '13', str_mjeInterno);
      	COMMIT;
        
      	SET OUT_CODRESULT = '13';
     	SET OUT_MJERESULT = concat(str_codMySQL, ' - ', str_msgMySQL);
        SELECT OUT_MJERESULT, OUT_CODRESULT;
        
  END;

            IF IN_nomProyecto IS NULL 
            OR IN_idEDDProyecto IS NULL
            OR IN_fechaIni IS NULL
            OR IN_isActive is NULL
            OR IN_idServicio is NULL
            OR IN_usuarioModificacion is NULL
            
            OR IN_nomProyecto = "%null%"
            OR IN_fechaIni = "%null%"
            OR IN_isActive = "%null%" 
            OR IN_idServicio = "%null%" 
            OR IN_usuarioModificacion = "%null%" 
            
            THEN
             SET OUT_MJERESULT = "Uno o más parámetros de entrada vienen nulos";
             SET OUT_CODRESULT = '01';
             SELECT OUT_MJERESULT, OUT_CODRESULT;
                
            ELSEIF IN_fechaIni < CURRENT_DATE() THEN
             	SET OUT_CODRESULT = '02';
				SET OUT_MJERESULT = 'Fecha de inicio inválida, no puede ser menor a la fecha actual.';
                SELECT OUT_MJERESULT, OUT_CODRESULT;

            ELSEIF IN_fechaFin IS NOT NULL THEN

                IF IN_fechaFin < CURRENT_DATE() THEN
                    SET OUT_CODRESULT = '03';
                    SET OUT_MJERESULT = 'Fecha de fin inválida, no puede ser menor a la fecha actual.';
                    SELECT OUT_MJERESULT, OUT_CODRESULT;
                        
                ELSEIF IN_fechaIni > IN_fechaFin THEN 
                    SET OUT_CODRESULT = '04';
                    SET OUT_MJERESULT = 'La fecha de inicio no puede ser mayor a la fecha final.';   
                    SELECT OUT_MJERESULT, OUT_CODRESULT;
                END IF;     

            ELSEIF TRIM(IN_isActive) NOT IN (0, 1) THEN
   				SET OUT_CODRESULT = '06';
				SET OUT_MJERESULT = 'Estado activo/inactivo del contacto viene vacío o es inválido (TRUE o FALSE)';
                SELECT OUT_MJERESULT, OUT_CODRESULT;

            ELSEIF TRIM(IN_idServicio) <= 0 THEN
   				SET OUT_CODRESULT = '07';
				SET OUT_MJERESULT = 'IDServicio del proyecto debe ser mayor a cero';  
                SELECT OUT_MJERESULT, OUT_CODRESULT;
   
            ELSEIF TRIM(IN_usuarioModificacion) = '' THEN
   				SET OUT_CODRESULT = '08';
				SET OUT_MJERESULT = 'El usuario administrador quien modifica el registro viene vacío';
                SELECT OUT_MJERESULT, OUT_CODRESULT;
             
            ELSEIF TRIM(IN_nomProyecto) = '' THEN
   				SET OUT_CODRESULT = '09';
				SET OUT_MJERESULT = 'El nombre del proyecto viene vacío';
                SELECT OUT_MJERESULT, OUT_CODRESULT;
                
            ELSEIF IN_idEDDProyecto <= 0 THEN
    			SET OUT_CODRESULT = '10';
				SET OUT_MJERESULT = 'El IN_idEDDProyecto debe ser mayor a cero';
                SELECT OUT_MJERESULT, OUT_CODRESULT;
                
            ELSEIF TRIM(IN_tipoProyecto) = '' THEN
    			SET OUT_CODRESULT = '11';
				SET OUT_MJERESULT = 'El tipo de proyecto viene vacío.';
                SELECT OUT_MJERESULT, OUT_CODRESULT;    
   
            ELSE
            
                SET AUTOCOMMIT = 0;
                START TRANSACTION;
                
             UPDATE eddproyecto SET 
             nomProyecto = IN_nomProyecto, 
             fechaInicio = IN_fechaIni, 
             fechaFin = IN_fechaFin, 
             tipoProyecto = IN_tipoProyecto, 
             isActive = IN_isActive, 
             idServicio = IN_idServicio, 
             fechaModificacion = CURRENT_TIMESTAMP, 
             usuarioModificacion = IN_usuarioModificacion 
             WHERE idEDDProyecto = IN_idEDDProyecto;
     		 
             COMMIT;
                SET OUT_CODRESULT = '00';
    			SET OUT_MJERESULT = 'Success';
            	
                SELECT OUT_CODRESULT, OUT_MJERESULT, proy.idEDDProyecto, UPPER(nomProyecto) as nomProyecto, DATE_FORMAT(proy.fechaInicio, "%d-%m-%Y") as fechaIni, DATE_FORMAT(proy.fechaFin, "%d-%m-%Y") as fechaFin, UPPER(serv.nomServicio) as nomServicio, UPPER(proy.tipoProyecto) tipoProyecto
                FROM eddproyecto proy 
                INNER JOIN servicio serv ON (proy.idServicio = serv.idServicio)
                WHERE proy.idEDDProyecto = IN_idEDDProyecto; 
                
     END IF;

 END$$
DELIMITER ;