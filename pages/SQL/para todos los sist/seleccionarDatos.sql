DROP PROCEDURE IF EXISTS `SP_seleccionarDatos`;
DELIMITER $$
CREATE PROCEDURE `SP_seleccionarDatos`(IN `IN_nombreTabla` VARCHAR(40), IN `IN_idRegistro` INT, OUT `OUT_CODRESULT` CHAR(2), OUT `OUT_MJERESULT` VARCHAR(500))
BEGIN
  		DECLARE str_codMySQL CHAR(5) DEFAULT '00000';
  		DECLARE str_msgMySQL VARCHAR(100);
  		DECLARE str_mjeInterno VARCHAR(500);
  		DECLARE EXIT HANDLER FOR SQLEXCEPTION
    	BEGIN
      	 GET DIAGNOSTICS CONDITION 1
       		 str_codMySQL = RETURNED_SQLSTATE, str_msgMySQL = MESSAGE_TEXT;
      	 ROLLBACK;
        
      	SET str_mjeInterno = CONCAT('SP_seleccionarData: Error al modificar registro --> IN_nombreTabla: [', IN_nombreTabla, '] - IN_idRegistro: [', IN_idRegistro, ']');

      	INSERT INTO logErroresObj (idLogErrorObj, nomObjeto, codError, descError, fechaHoraError, codErrorInterno, descErrorInterno) 
      	VALUES(null, 'SP_seleccionarData', str_codMySQL, str_msgMySQL, now(), '13', str_mjeInterno);
      	COMMIT;
        
      	SET OUT_CODRESULT = '13';
     	SET OUT_MJERESULT = concat(str_codMySQL, ' - ', str_msgMySQL);
  END;
		 -- Validación de parámetros
            IF IN_idRegistro IS NULL 
            OR IN_nombreTabla is NULL 
            OR IN_idRegistro = "%null%" 
            OR IN_nombreTabla = "%null%" 
            
             THEN
               SET OUT_MJERESULT = "Uno o más parámetros de entrada vienen nulos / vacíos";
               SET OUT_CODRESULT = '01';
				SELECT OUT_CODRESULT, OUT_MJERESULT;
                
             ELSEIF TRIM(IN_nombreTabla) = '' THEN
   				SET OUT_CODRESULT = '02';
				SET OUT_MJERESULT = 'El nombre de la tabla viene vacío';
                SELECT OUT_CODRESULT, OUT_MJERESULT;
                
             ELSEIF IN_idRegistro <= 0 THEN
   				SET OUT_CODRESULT = '03';
				SET OUT_MJERESULT = 'El ID del registro debe ser mayor a cero';
                SELECT OUT_CODRESULT, OUT_MJERESULT;
                
            ELSEIF UPPER(IN_nombreTabla) NOT IN ('ALUMNO','AREA','CARGO','CLIENTE','CONTACTO','CURSO','CURSOALUMNO','CURSOALUMNO_SESION','EMPLEADO','NOTAEXAMEN','RAMO','RAMOEXAMEN','RELATORRAMO','REQCURSO','SERVICIO','SESION', 'EDDPROYECTO', 'EDDPROYEMP', 'EMPTIPOPERFIL', 'EMPSUBSIST', 'EDDEVALCOMPETENCIA', 'EDDEVALRESPPREG', 'EDDEVALPREGUNTA', 'EDDEVALPROYRESP', 'EDDEVALUACION', 'EDDEVALPROYEMP', 'IHHACOP', 'IHHELEMENTOIMP','IHHIMPUGNACIONEMP','IHHNOTAIMPUGNACION','IHHPERIODO','IHHTIPOELEMENTO','IHHTIPOPERIODO') THEN
   				SET OUT_CODRESULT = '04';
				SET OUT_MJERESULT = 'La tabla seleccionada no existe.'; 
                SELECT OUT_CODRESULT, OUT_MJERESULT;

            ELSE	
            
            	-- Reconocimiento de tabla para cada caso
                   SET AUTOCOMMIT = 0;
                   START TRANSACTION;
                -- Alumno
            	IF TRIM(IN_nombreTabla) = 'alumno' THEN
       
                    SET OUT_CODRESULT = '00';
                    SET OUT_MJERESULT = 'Success';
                    
                    SELECT OUT_MJERESULT as 'OUT_MJERESULT', OUT_CODRESULT as 'OUT_CODRESULT', alum.idAlumno, UPPER(alum.nomAlumno), UPPER(alum.correoAlumno), UPPER(alum.telefonoAlumno), alum.idServicio, alum.idArea, alum.idPais, alum.idCargo
                    FROM alumno alum                     
                    WHERE alum.idAlumno = IN_idRegistro;
                    
                    -- Cliente
             	ELSEIF TRIM(IN_nombreTabla) = 'cliente' THEN

                    SET OUT_CODRESULT = '00';
                    SET OUT_MJERESULT = 'Success';
   
                SELECT OUT_MJERESULT as 'OUT_MJERESULT', OUT_CODRESULT as 'OUT_CODRESULT', cli.idCliente, UPPER(cli.nomCliente), UPPER(cli.direccionCliente), UPPER(cli.isActive), cli.idPais
                FROM cliente cli
                WHERE cli.idCliente = IN_idRegistro;
                    
                    -- Contacto
                    ELSEIF TRIM(IN_nombreTabla) = 'contacto' THEN

 
                    SET OUT_CODRESULT = '00';
                    SET OUT_MJERESULT = 'Success';
   
                 	SELECT OUT_MJERESULT as 'OUT_MJERESULT', OUT_CODRESULT as 'OUT_CODRESULT', con.idContacto, UPPER(con.nomContacto), UPPER(con.correoContacto), con.telefonoContacto, con.fechaIni, con.fechaFin, con.idServicio
                    FROM contacto con
                    WHERE con.idContacto = IN_idRegistro;
                    
                    -- Curso
                    ELSEIF TRIM(IN_nombreTabla) = 'curso' THEN

                    SET OUT_CODRESULT = '00';
                    SET OUT_MJERESULT = 'Success';
   
                 	SELECT OUT_MJERESULT as 'OUT_MJERESULT', OUT_CODRESULT as 'OUT_CODRESULT', cur.idCurso, UPPER(cur.codCurso), UPPER(cur.nomCurso), UPPER(cur.tipoHH), cur.duracionCursoHH, cur.cantSesionesCurso 
                    FROM curso cur 
                    WHERE cur.idCurso = IN_idRegistro;
                    
                    -- CursoAlumno
                    ELSEIF TRIM(IN_nombreTabla) = 'cursoalumno' THEN
             
                    COMMIT;
                    SET OUT_CODRESULT = '00';
                    SET OUT_MJERESULT = 'Success';
   
                 	SELECT OUT_MJERESULT as 'OUT_MJERESULT', OUT_CODRESULT as 'OUT_CODRESULT', curAl.idCursoAlumno, curAl.fechaIni, curAl.horaIni, curAl.fechaFin, curAl.horaFin, curAl.porcAsistencia, curAl.porcParticipacion, UPPER(curAl.claseAprobada), curAl.porcAprobacion,UPPER(curAl.estadoCurso), curAl.idEmpleado, curAl.idCurso
                    FROM cursoalumno curAl
                    WHERE curAl.isActive = true AND curAl.idCursoAlumno = IN_idRegistro
                    ORDER BY curAl.idCursoAlumno ASC;
                    
                    -- CursoAlumnoSesion
                    ELSEIF TRIM(IN_nombreTabla) = 'cursoalumno_sesion' THEN
             
                    SET OUT_CODRESULT = '00';
                    SET OUT_MJERESULT = 'Success';
   
                 	SELECT OUT_MJERESULT as 'OUT_MJERESULT', OUT_CODRESULT as 'OUT_CODRESULT', curAlSe.idCursoAlumnoSesion, curAlSe.fechaIni, curAlSe.horaIni, curAlSe.horaFin, curAlSe.fechaFin, curAlSe.asistencia, curAlSe.participacion, se.idSesion, curAl.idCursoAlumno
                    FROM cursoalumno_sesion curAlSe
                    INNER JOIN sesion se ON (curAlSe.idSesion = se.idSesion)
                    INNER JOIN cursoalumno curAl ON (curAlSe.idCursoAlumno = curAL.idCursoAlumno)
                    WHERE curAlSe.idCursoAlumnoSesion = IN_idRegistro;
                    
                    -- Empleado
                    ELSEIF TRIM(IN_nombreTabla) = 'empleado' THEN
             
                    SET OUT_CODRESULT = '00';
                    SET OUT_MJERESULT = 'Success';
   
                 	SELECT OUT_MJERESULT as 'OUT_MJERESULT', OUT_CODRESULT as 'OUT_CODRESULT', emp.idEmpleado, UPPER(emp.nomEmpleado), UPPER(emp.correoEmpleado), emp.telefonoEmpleado, emp.idArea, emp.idPais, emp.idCargo	
                    FROM empleado emp 
					WHERE emp.idEmpleado = IN_idRegistro;
                    
                    -- NotaExamen
                    ELSEIF TRIM(IN_nombreTabla) = 'notaexamen' THEN
             
                    SET OUT_CODRESULT = '00';
                    SET OUT_MJERESULT = 'Success';
   
                 	SELECT OUT_MJERESULT as 'OUT_MJERESULT', OUT_CODRESULT as 'OUT_CODRESULT', notaEx.idNotaExamen, notaEx.notaExamen, UPPER(notaEx.apruebaExamen), notaEx.idRamoExamen, notaEx.idCursoAlumno
                    FROM notaexamen notaEx 
                    WHERE notaEx.isActive = true and notaEx.idNotaExamen = IN_idRegistro;
                    
                    -- Ramo
                    ELSEIF TRIM(IN_nombreTabla) = 'ramo' THEN
             
                    SET OUT_CODRESULT = '00';
                    SET OUT_MJERESULT = 'Success';
   
                 	SELECT OUT_MJERESULT as 'OUT_MJERESULT', OUT_CODRESULT as 'OUT_CODRESULT', ram.idRamo, UPPER(ram.codRamo), UPPER(ram.nomRamo), UPPER(ram.tipoRamo), UPPER(ram.tipoRamoHH), ram.duracionRamoHH, ram.cantSesionesRamo, ram.idCurso
                    FROM ramo ram 
                    WHERE ram.idRamo = IN_idRegistro;
                    
                     -- RamoExamen
                    ELSEIF TRIM(IN_nombreTabla) = 'ramoexamen' THEN
             
                    SET OUT_CODRESULT = '00';
                    SET OUT_MJERESULT = 'Success';
   
                 	SELECT OUT_MJERESULT as 'OUT_MJERESULT', OUT_CODRESULT as 'OUT_CODRESULT', ramEx.idRamoExamen, UPPER(ramEx.nomExamen), ramEx.fechaExamen, ramEx.isActive, ramEx.idRamo		  
                    FROM ramoexamen ramEx
                    WHERE ramEx.idRamoExamen = IN_idRegistro;
                    
                    -- RelatorRamo
                    ELSEIF TRIM(IN_nombreTabla) = 'relatorramo' THEN
             
                    SET OUT_CODRESULT = '00';
                    SET OUT_MJERESULT = 'Success';
   
                 	SELECT OUT_MJERESULT as 'OUT_MJERESULT', OUT_CODRESULT as 'OUT_CODRESULT', relRam.idRelatorRamo, relRam.fechaIni, relRam.fechaFin, relRam.idEmpleado, relRam.idRamo
                    FROM relatorramo relRam   
                    WHERE relRam.idRelatorRamo = IN_idRegistro;
                    
                    -- ReqCurso
                    ELSEIF TRIM(IN_nombreTabla) = 'reqcurso' THEN
             
                    SET OUT_CODRESULT = '00';
                    SET OUT_MJERESULT = 'Success';
   
                 	SELECT OUT_MJERESULT as 'OUT_MJERESULT', OUT_CODRESULT as 'OUT_CODRESULT', reCur.idReqCurso, reCur.idCurso, reCur.idCursoRequisito as requisitoCurso 
                    FROM reqcurso reCur
                    WHERE reCur.idReqCurso = IN_idRegistro;
                    
                    -- Servicio
                    ELSEIF TRIM(IN_nombreTabla) = 'servicio' THEN
             
                    SET OUT_CODRESULT = '00';
                    SET OUT_MJERESULT = 'Success';
   
                 	SELECT OUT_MJERESULT as 'OUT_MJERESULT', OUT_CODRESULT as 'OUT_CODRESULT', serv.idServicio, UPPER(serv.nomServicio), serv.isActive, serv.idCliente
                    FROM servicio serv                  
                    WHERE serv.idServicio = IN_idRegistro;
                    
                    -- Sesion
                    ELSEIF TRIM(IN_nombreTabla) = 'sesion' THEN
             
                    SET OUT_CODRESULT = '00';
                    SET OUT_MJERESULT = 'Success';
   
                   SELECT OUT_MJERESULT as 'OUT_MJERESULT', OUT_CODRESULT as 'OUT_CODRESULT', se.idSesion, se.nroSesion, UPPER(se.nomSesion), UPPER(se.tipoSesion), UPPER(se.tipoSesionHH), UPPER(se.duracionSesionHH), se.idRamo
                    FROM sesion se 
                    WHERE se.idSesion = IN_idRegistro;
                    
                    
                    -- EDD PROYECTO
                    ELSEIF TRIM(IN_nombreTabla) = 'eddproyecto' THEN
                    
                         SET OUT_CODRESULT = '00';
                         SET OUT_MJERESULT = 'Success';

                       SELECT OUT_MJERESULT, OUT_CODRESULT,proy.idEDDProyecto, proy.idServicio, UPPER(nomProyecto) as nomProyecto, 
                       proy.fechaInicio as fechaIni, proy.fechaFin, UPPER(serv.nomServicio) as nomServicio, UPPER(proy.tipoProyecto) tipoProyecto
                       FROM eddproyecto proy 
                       INNER JOIN servicio serv ON (proy.idServicio = serv.idServicio)
                       WHERE proy.idEDDProyecto = IN_idRegistro; 
                       
                     -- EDD PROYECTO EMPLEADO
                    ELSEIF TRIM(IN_nombreTabla) = 'eddproyemp' THEN
                    
                         SET OUT_CODRESULT = '00';
                         SET OUT_MJERESULT = 'Success';

                       SELECT OUT_MJERESULT, OUT_CODRESULT, proyEmp.idEDDProyEmp , proyEmp.idProyecto, proyEmp.idEmpleado, UPPER(proyEmp.cargoEnProy) as cargoEnProy
                       FROM eddproyemp proyEmp
                       WHERE proyEmp.idEDDProyEmp = IN_idRegistro;   
                       
                     -- EMPTIPOPERFIL
                    ELSEIF TRIM(IN_nombreTabla) = 'emptipoperfil' THEN
                    
                         SET OUT_CODRESULT = '00';
                         SET OUT_MJERESULT = 'Success';

                       SELECT OUT_MJERESULT, OUT_CODRESULT, etp.idEmpTipoPerfil , etp.idEmpleado, etp.idTipoPerfil
                       FROM emptipoperfil etp
                       WHERE etp.idEmpTipoPerfil = IN_idRegistro;    
                       
                      -- EMPSUBSIST
                    ELSEIF TRIM(IN_nombreTabla) = 'empsubsist' THEN
                    
                         SET OUT_CODRESULT = '00';
                         SET OUT_MJERESULT = 'Success';

                       SELECT OUT_MJERESULT, OUT_CODRESULT, empSub.idEmpSubsist, empSub.idEmpleado, empSub.idSubsistema
                       FROM empsubsist empSub
                       WHERE empSub.idEmpSubsist = IN_idRegistro;
                       
                      -- EDDEVALCOMPETENCIA
                    ELSEIF TRIM(IN_nombreTabla) = 'eddevalcompetencia' THEN
                    
                         SET OUT_CODRESULT = '00';
                         SET OUT_MJERESULT = 'Success';

                       SELECT OUT_MJERESULT, OUT_CODRESULT, UPPER(evalComp.nomCompetencia) as nomCompetencia
                       FROM eddevalcompetencia evalComp
                       WHERE evalComp.idEDDEvalCompetencia = IN_idRegistro;   
                       
                     -- EDDEVALRESPPREG
                    ELSEIF TRIM(IN_nombreTabla) = 'eddevalresppreg' THEN
                    
                         SET OUT_CODRESULT = '00';
                         SET OUT_MJERESULT = 'Success';

                       SELECT OUT_MJERESULT, OUT_CODRESULT, UPPER(RespPreg.nomRespPreg) as nomRespPreg, RespPreg.ordenRespPreg,RespPreg.idEDDEvalPregunta
                       FROM eddevalresppreg RespPreg
                       WHERE RespPreg.idEDDEvalRespPreg = IN_idRegistro;   
                       
                    
                    -- EDDEVALPREG
                    ELSEIF TRIM(IN_nombreTabla) = 'eddevalpregunta' THEN
                    
                         SET OUT_CODRESULT = '00';
                         SET OUT_MJERESULT = 'Success';

                       SELECT OUT_MJERESULT, 
                       OUT_CODRESULT, 
                       UPPER(preg.nomPregunta) as nomPregunta, 
                       preg.ordenPregunta, preg.idEDDEvaluacion, 
                       preg.idEDDEvalCompetencia,
                       preg.tipoResp,
                       preg.preguntaObligatoria
                       FROM eddevalpregunta preg
                       WHERE preg.idEDDEvalPregunta = IN_idRegistro; 
                       
                       
                     -- EDDEVALPROYRESP
                    ELSEIF TRIM(IN_nombreTabla) = 'eddevalproyresp' THEN
                    
                         SET OUT_CODRESULT = '00';
                         SET OUT_MJERESULT = 'Success';

                       SELECT OUT_MJERESULT, OUT_CODRESULT, evalproyresp.idEDDEvalProyResp, evalproyresp.idEDDEvaluacion, evalproyresp.idEDDProyEmp, UPPER(evalproyresp.respuesta) as respuesta, evalproyresp.idEDDEvalProyEmp, evalproyresp.idEDDEvalPregunta, evalproyresp.idEDDEvalRespPreg
                       FROM eddevalproyresp evalproyresp
                       WHERE evalproyresp.idEDDEvalProyResp = IN_idRegistro;  
                       
                     -- EDDEVALUACION
                    ELSEIF TRIM(IN_nombreTabla) = 'eddevaluacion' THEN
                    
                         SET OUT_CODRESULT = '00';
                         SET OUT_MJERESULT = 'Success';

                       SELECT OUT_MJERESULT, OUT_CODRESULT, 
                       idEDDEvaluacion,
                       UPPER(nomEvaluacion) as nomEvaluacion,
                       UPPER(tipoEvaluacion) as tipoEvaluacion,
                       fechaIni,
                       fechaFin
                       FROM eddevaluacion
                       WHERE idEDDEvaluacion = IN_idRegistro;   
                -- EDDEVALPROYEMP
                    ELSEIF TRIM(IN_nombreTabla) = 'eddevalproyemp' THEN
                    
                         SET OUT_CODRESULT = '00';
                         SET OUT_MJERESULT = 'Success';

                       SELECT OUT_MJERESULT, OUT_CODRESULT, 
                       epe.idEDDEvalProyEmp,
                       epe.idEDDEvaluacion,
                       epe.idEDDProyEmpEvaluador,
                       epe.idEDDProyEmpEvaluado,
                       epe.cicloEvaluacion,
                       epe.evalRespondida,
                       epe.fechaIni,
                       epe.fechaFin,
                       ep.idProyecto,
                       UPPER(eproy.nomProyecto) nomProyecto
                       FROM eddevalproyemp epe
                       INNER JOIN eddproyemp ep ON (ep.idEDDProyEmp = epe.idEDDProyEmpEvaluador AND ep.isActive = 1)
                       INNER JOIN eddproyecto eproy ON (eproy.idEDDProyecto = ep.idProyecto AND eproy.isActive = 1)
                       WHERE epe.idEDDEvalProyEmp = IN_idRegistro;

                -- IHH_ACOP
                    ELSEIF TRIM(IN_nombreTabla) = 'ihhacop' THEN
                    
                        SET OUT_CODRESULT = '00';
                        SET OUT_MJERESULT = 'Success';

                        SELECT OUT_MJERESULT, OUT_CODRESULT, 
                        idAcop,
                        idProyecto,
                        presupuestoTotal,
                        cantTotalMeses
                        FROM ihhacop
                        WHERE idAcop = IN_idRegistro; 
                
                -- IHH_ELEMENTOIMP
                    ELSEIF TRIM(IN_nombreTabla) = 'ihhelementoimp' THEN
                    
                        SET OUT_CODRESULT = '00';
                        SET OUT_MJERESULT = 'Success';

                        SELECT OUT_MJERESULT, OUT_CODRESULT, 
                        idElementoImp,
                        idTipoElemento,
                        nomElemento,
                        descripcion
                        FROM ihhelementoimp
                        WHERE idElementoImp = IN_idRegistro; 

                -- IHH_IMPUGNACIONEMP
                    ELSEIF TRIM(IN_nombreTabla) = 'ihhimpugnacionemp' THEN
                    
                        SET OUT_CODRESULT = '00';
                        SET OUT_MJERESULT = 'Success';

                        SELECT OUT_MJERESULT, OUT_CODRESULT, 
                        idImpugnacionEmp,
                        idEmpleado,
                        idElemento,
                        idPeriodo,
                        cantHorasPeriodo,
                        cantHorasExtra,
                        factor,
                        idAcop
                        FROM ihhimpugnacionemp
                        WHERE idImpugnacionEmp = IN_idRegistro; 

                -- IHH_PERIODO
                    ELSEIF TRIM(IN_nombreTabla) = 'ihhperiodo' THEN
                    
                        SET OUT_CODRESULT = '00';
                        SET OUT_MJERESULT = 'Success';

                        SELECT OUT_MJERESULT, OUT_CODRESULT, 
                        idPeriodo,
                        idTipoPeriodo,
                        nomPeriodo,
                        descripcion
                        FROM ihhperiodo
                        WHERE idPeriodo = IN_idRegistro;

                -- IHH_TIPOELEMENTO
                    ELSEIF TRIM(IN_nombreTabla) = 'ihhtipoelemento' THEN
                    
                        SET OUT_CODRESULT = '00';
                        SET OUT_MJERESULT = 'Success';

                        SELECT OUT_MJERESULT, OUT_CODRESULT, 
                        idTipoElemento,
                        nomTipoElemento,
                        descripcion
                        FROM ihhtipoelemento
                        WHERE idTipoElemento = IN_idRegistro;

                -- IHH_TIPOELEMENTO
                    ELSEIF TRIM(IN_nombreTabla) = 'ihhtipoperiodo' THEN
                    
                        SET OUT_CODRESULT = '00';
                        SET OUT_MJERESULT = 'Success';

                        SELECT OUT_MJERESULT, OUT_CODRESULT, 
                        idTipoPeriodo,
                        nomTipoPeriodo,
                        dias,
                        descripcion
                        FROM ihhtipoperiodo
                        WHERE idTipoPeriodo = IN_idRegistro; 

                -- IHH_NOTAIMPUGNACION
                     ELSEIF TRIM(IN_nombreTabla) = 'ihhnotaimpugnacion' THEN
                    
                        SET OUT_CODRESULT = '00';
                        SET OUT_MJERESULT = 'Success';

                        SELECT OUT_MJERESULT, OUT_CODRESULT, 
                        idNotaImpugnacion,
                        idImpugnacionEmp,
                        nota
                        FROM ihhnotaimpugnacion
                        WHERE idNotaImpugnacion = IN_idRegistro;    
                         
                END IF;
            END IF;          			
        END$$
DELIMITER ;