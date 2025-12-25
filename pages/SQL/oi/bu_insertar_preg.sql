CREATE DEFINER=`root`@`localhost` PROCEDURE `entornotsoft`.`SP_oi_insertarPregunta`(
		IN `IN_nomPregunta` varchar(100), 
		IN `IN_ordenPregunta` int,
		IN `IN_tipoResp` varchar(30),
		IN `IN_preguntaObligatoria` tinyint,
		IN `IN_idFormulario` int,
		IN `IN_isActive` TINYINT, 
		IN `IN_usuarioCreacion` VARCHAR(30), 
		OUT `OUT_CODRESULT` CHAR(2), OUT `OUT_MJERESULT` VARCHAR(500))
BEGIN
          DECLARE str_codMySQL CHAR(5) DEFAULT '00000';
          DECLARE str_msgMySQL VARCHAR(100);
          DECLARE str_mjeInterno VARCHAR(500);

          DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
           GET DIAGNOSTICS CONDITION 1
                str_codMySQL = RETURNED_SQLSTATE, str_msgMySQL = MESSAGE_TEXT;
           ROLLBACK;

          SET str_mjeInterno = CONCAT('SP_oi_insertarPregunta: Error al insertar registro --> 
			IN_nomPregunta: [', IN_nomPregunta, '] - 
			IN_ordenPregunta: [', IN_ordenPregunta, '] - 	
			IN_tipoResp: [', IN_tipoResp, '] -
			IN_preguntaObligatoria: [', IN_preguntaObligatoria, '] -
			IN_idFormulario: [', IN_idFormulario, '] -
			IN_isActive: [', IN_isActive, '] - 
			IN_usuarioCreacion: [', IN_usuarioCreacion, ']');


          INSERT INTO logErroresObj (idLogErrorObj, nomObjeto, codError, descError, fechaHoraError, codErrorInterno, descErrorInterno) 
          VALUES(null, 'SP_oi_insertarPregunta', str_codMySQL, str_msgMySQL, now(), '13', str_mjeInterno);
          COMMIT;

            SET OUT_CODRESULT = '13';
        	SET OUT_MJERESULT = concat(str_codMySQL, ' - ', str_msgMySQL);
        	SELECT OUT_MJERESULT, OUT_CODRESULT;

  END;

            IF IN_nomPregunta IS null
            OR IN_ordenPregunta IS NULL 
            OR IN_tipoResp IS NULL 
            OR IN_preguntaObligatoria IS null
            OR IN_idFormulario IS NULL
            OR IN_isActive IS NULL 
            OR IN_usuarioCreacion IS NULL 
           
            THEN
                SET OUT_MJERESULT = "Uno o más parámetros de entrada vienen nulos / vacíos";
                SET OUT_CODRESULT = '01';
                SELECT OUT_MJERESULT, OUT_CODRESULT;

            ELSEIF TRIM(IN_nomPregunta) = '' THEN
                SET OUT_CODRESULT = '02';
                SET OUT_MJERESULT = 'El nombre de la pregunta no puede estar vacío.';
                SELECT OUT_MJERESULT, OUT_CODRESULT;
            
            ELSEIF TRIM(IN_ordenPregunta) = '' THEN
                SET OUT_CODRESULT = '03';
                SET OUT_MJERESULT = 'El orden de la pregunta no puede estar vacío.';
                SELECT OUT_MJERESULT, OUT_CODRESULT;
            
            ELSEIF TRIM(IN_tipoResp) = '' THEN
                SET OUT_CODRESULT = '04';
                SET OUT_MJERESULT = 'El tipo de respuesta de la pregunta no puede estar vacío.';
                SELECT OUT_MJERESULT, OUT_CODRESULT;
            
            ELSEIF TRIM(IN_preguntaObligatoria) = '' THEN
                SET OUT_CODRESULT = '05';
                SET OUT_MJERESULT = 'El estdo de pregunta obligatoria debe ser 1 (activo) o 0 (inactivo)';
                SELECT OUT_MJERESULT, OUT_CODRESULT;
            
            ELSEIF IN_isActive NOT IN (1,0) THEN
                SET OUT_CODRESULT = '06';
                SET OUT_MJERESULT = 'El estado del registro debe ser 1 (activo) o 0 (inactivo)';
                SELECT OUT_MJERESULT, OUT_CODRESULT;

            ELSEIF TRIM(IN_usuarioCreacion) = '' THEN
                SET OUT_CODRESULT = '07';
                SET OUT_MJERESULT = 'El usuario administrador no puede estar vacío';
                SELECT OUT_MJERESULT, OUT_CODRESULT;                   
			
            ELSEIF IN_idFormulario < 1 THEN
                SET OUT_CODRESULT = '09';
                SET OUT_MJERESULT = 'El ID del formulario no puede estar vacío';
                SELECT OUT_MJERESULT, OUT_CODRESULT;
            
            ELSE

                SET AUTOCOMMIT = 0;
                START TRANSACTION;

            
             INSERT INTO oipreguntas (
                 nomPregunta   , 
                 ordenPregunta   , 
                 tipoResp   ,
                 preguntaObligatoria ,
                 idFormulario,
                 isActive, 
                 fechaCreacion, 
                 usuarioCreacion, 
                 fechaModificacion, 
                 usuarioModificacion) VALUES 
                 (UPPER(TRIM(IN_nomPregunta)), 
                  IN_ordenPregunta, 
                  LOWER(TRIM(IN_tipoResp)),
                  IN_preguntaObligatoria,
                  IN_idFormulario,
                  IN_isActive,
                  CURRENT_TIMESTAMP, 
                  IN_usuarioCreacion, 
                  CURRENT_TIMESTAMP, 
                  IN_usuarioCreacion);
             COMMIT;
                SET OUT_CODRESULT = '00';
                SET OUT_MJERESULT = 'Success';

           SELECT 
           OUT_CODRESULT, OUT_MJERESULT;
     END IF;
end;