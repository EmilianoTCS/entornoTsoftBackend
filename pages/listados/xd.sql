DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_insertarEddEvalProyResp`(
    IN `IN_idEDDEvaluacion` INT, 
    IN `IN_fechaIniEvaluacion` DATETIME, 
    IN `IN_fechaFinEvaluacion` DATETIME, 
    IN `IN_idEDDProyEmp` INT, 
    IN `IN_respuesta` VARCHAR(500), 
    IN `IN_isActive` TINYINT, 
    IN `IN_idEDDEvalProyEmp` INT, 
    IN `IN_idEDDEvalPregunta` INT, 
    IN `IN_idEDDEvalRespPreg` INT, 
    IN `IN_usuarioCreacion` VARCHAR(15), 
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
        
      	SET str_mjeInterno = CONCAT('SP_insertarEddEvalProyResp: Error al insertar registro --> 
        IN_idEDDEvaluacion: [', IN_idEDDEvaluacion, '] - 
        IN_idEDDProyEmp: [', IN_idEDDProyEmp, '] - 
        IN_respuesta: [', IN_respuesta, '] - 
        IN_isActive: [', IN_isActive, '] - 
        IN_idEDDEvalProyEmp: [', IN_idEDDEvalProyEmp, '] - 
        IN_idEDDEvalPregunta: [', IN_idEDDEvalPregunta, '] - 
        IN_idEDDEvalRespPreg: [', IN_idEDDEvalRespPreg, '] - 
        IN_usuarioCreacion: [', IN_usuarioCreacion, ']');

      	INSERT INTO logErroresObj (idLogErrorObj, nomObjeto, codError, descError, fechaHoraError, codErrorInterno, descErrorInterno) 
      	VALUES(null, 'SP_insertarEddEvalProyResp', str_codMySQL, str_msgMySQL, now(), '13', str_mjeInterno);
      	COMMIT;
        
      	SET OUT_CODRESULT = '13';
     	SET OUT_MJERESULT = concat(str_codMySQL, ' - ', str_msgMySQL);
        SELECT OUT_MJERESULT, OUT_CODRESULT;
        
  END;

            IF IN_idEDDEvaluacion IS NULL 
            OR IN_idEDDProyEmp IS NULL 
            OR IN_respuesta IS NULL 
            OR IN_isActive IS NULL 
            OR IN_idEDDEvalProyEmp IS NULL 
            OR IN_idEDDEvalPregunta IS NULL 
            OR IN_idEDDEvalRespPreg IS NULL
            OR IN_usuarioCreacion is NULL
            
            OR IN_idEDDEvaluacion = "%null%"
            OR IN_idEDDProyEmp = "%null%"
            OR IN_respuesta = "%null%"
            OR IN_isActive = "%null%"
            OR IN_idEDDEvalProyEmp = "%null%"
            OR IN_idEDDEvalPregunta = "%null%"
            OR IN_idEDDEvalRespPreg = "%null%"
            OR IN_usuarioCreacion = "%null%" 
            
            THEN
             SET OUT_MJERESULT = "Uno o más parámetros de entrada vienen nulos";
             SET OUT_CODRESULT = '01';
             SELECT OUT_MJERESULT, OUT_CODRESULT;
            
			 ELSEIF IN_idEDDEvaluacion <= 0 THEN
   				SET OUT_CODRESULT = '02';
				SET OUT_MJERESULT = 'El idEDDEvaluacion debe ser mayor a cero';
                SELECT OUT_MJERESULT, OUT_CODRESULT;
             
             ELSEIF IN_idEDDProyEmp <= 0 THEN
   				SET OUT_CODRESULT = '03';
				SET OUT_MJERESULT = 'El idEDDProyEmp debe ser mayor a cero';
                SELECT OUT_MJERESULT, OUT_CODRESULT;
                
             ELSEIF TRIM(IN_respuesta) = '' THEN
   				SET OUT_CODRESULT = '04';
				SET OUT_MJERESULT = 'La respuesta a la pregunta viene vacía';
                SELECT OUT_MJERESULT, OUT_CODRESULT;   

             ELSEIF IN_isActive NOT IN (0, 1) THEN
   				SET OUT_CODRESULT = '05';
				SET OUT_MJERESULT = 'El estado del registro debe ser verdadero o falso';  
                SELECT OUT_MJERESULT, OUT_CODRESULT;
                
             ELSEIF IN_idEDDEvalProyEmp <= 0 THEN
   				SET OUT_CODRESULT = '06';
				SET OUT_MJERESULT = 'El idEDDEvalProyEmp debe ser mayor a cero';
                SELECT OUT_MJERESULT, OUT_CODRESULT;
                
             ELSEIF IN_idEDDEvalPregunta <= 0 THEN
   				SET OUT_CODRESULT = '07';
				SET OUT_MJERESULT = 'El idEDDEvalPregunta debe ser mayor a cero';
                SELECT OUT_MJERESULT, OUT_CODRESULT;
                
             ELSEIF IN_idEDDEvalRespPreg <= 0 THEN
   				SET OUT_CODRESULT = '08';
				SET OUT_MJERESULT = 'El idEDDEvalRespPreg debe ser mayor a cero';
                SELECT OUT_MJERESULT, OUT_CODRESULT;   

             ELSEIF TRIM(IN_usuarioCreacion) = '' THEN
   				SET OUT_CODRESULT = '09';
				SET OUT_MJERESULT = 'El usuario administrador quien crea el registro viene vacío';
                SELECT OUT_MJERESULT, OUT_CODRESULT;
                
                
            ELSE
            
                SET AUTOCOMMIT = 0;
                START TRANSACTION;
                
            INSERT INTO eddevalproyresp (
                idEDDEvaluacion, 
                idEDDProyEmp, 
                respuesta, 
                isActive, 
                idEDDEvalProyEmp, 
                idEDDEvalPregunta, 
                idEDDEvalRespPreg, 
                fechaCreacion, 
                usuarioCreacion, 
                fechaModificacion, 
                usuarioModificacion) 
            VALUES (
                IN_idEDDEvaluacion, 
                IN_idEDDProyEmp, 
                IN_respuesta, 
                IN_isActive, 
                IN_idEDDEvalProyEmp, 
                IN_idEDDEvalPregunta, 
                IN_idEDDEvalRespPreg, 
                now(), 
                IN_usuarioCreacion, 
                now(), 
                IN_usuarioCreacion);

             FN_CambiarEvalRespondida(IN_idEDDEvalProyEmp, IN_fechaIniEvaluacion, IN_fechaFinEvaluacion);

             COMMIT;
                SET OUT_CODRESULT = '00';
    			SET OUT_MJERESULT = 'Success';
                
               SELECT OUT_CODRESULT, OUT_MJERESULT, proyResp.idEDDEvalProyResp, proyResp.idEDDEvaluacion, proyResp.idEDDProyEmp, UPPER(proyResp.respuesta) as respuesta, proyResp.idEDDEvalProyEmp, proyResp.idEDDEvalPregunta, proyResp.idEDDEvalRespPreg,
               UPPER(eval.nomEvaluacion) as nomEvaluacion, UPPER(evalPregunta.nomPregunta) as nomPregunta, UPPER(evalRespPreg.nomRespPreg) as nomRespPreg
               FROM eddevalproyresp proyResp
               INNER JOIN eddevaluacion eval ON (proyResp.idEDDEvaluacion = eval.idEDDEvaluacion)
               INNER JOIN eddproyemp proyEmp ON (proyResp.idEDDProyEmp = proyEmp.idEDDProyEmp)
               INNER JOIN eddevalproyemp evalProyEmp ON (proyResp.idEDDEvalProyEmp = evalProyEmp.idEDDEvalProyEmp)
               INNER JOIN eddevalpregunta evalPregunta ON (proyResp.idEDDEvalPregunta = evalPregunta.idEDDEvalPregunta)
               INNER JOIN eddevalresppreg evalRespPreg ON (proyResp.idEDDEvalRespPreg = evalRespPreg.idEDDEvalRespPreg)
               WHERE proyResp.idEDDEvalProyResp = LAST_INSERT_ID();
     END IF;

 END$$
DELIMITER ;