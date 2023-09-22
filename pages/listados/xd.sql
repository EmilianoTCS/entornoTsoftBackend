BEGIN
	-- Si ambas son cero
	IF IN_idEDDEvaluacion = 0 AND IN_idEDDProyEmpEvaluador = 0 AND IN_idEDDProyEmpEvaluado = 0 AND IN_idProyecto = 0 THEN 
    
        SET @temp_cantRegistros = (SELECT COUNT(idEDDEvalProyEmp) FROM eddevalproyemp WHERE isActive = true);
               
              SELECT @temp_cantRegistros,
               evalProyEmp.idEDDEvalProyEmp, 
               evalProyEmp.idEDDEvaluacion, 
               evalProyEmp.idEDDProyEmpEvaluador, 
               evalProyEmp.idEDDProyEmpEvaluado, 
               UPPER(proyEmpEvaluador.cargoEnProy) cargoEnProy,
               IF(evalProyEmp.evalRespondida = 1, "SÍ", "NO") as evalRespondida, 
               DATE_FORMAT(evalProyEmp.fechaIni, "%d/%m/%Y %H:%i:%s") as fechaIni, 
               DATE_FORMAT(evalProyEmp.fechaFin, "%d/%m/%Y %H:%i:%s") as fechaFin,
			   FN_tiempoPromedio(evalProyEmp.fechaIni, evalproyEmp.fechaFin) as tiempoTotalEnMin,
               UPPER(eval.nomEvaluacion) as nomEvaluacion,
               UPPER(proy.nomProyecto) as nomProyecto,
               proy.idEDDProyecto,
               UPPER(empEvaluador.nomEmpleado) as nomEmpleadoEvaluador,
               UPPER(empEvaluado.nomEmpleado) as nomEmpleadoEvaluado,
               DATE_FORMAT(eval.fechaIni, "%d/%m/%Y %H:%i:%s") as fechaInicioPeriodoEvaluacion,
               DATE_FORMAT(eval.fechaFin, "%d/%m/%Y %H:%i:%s") as fechaFinPeriodoEvaluacion,
               IF(eval.fechaIni < now() AND eval.fechaFin > now(), 1, 0) as disponibilidadEvaluacion,

               DATE_FORMAT(evalProyEmp.fechaIniVigenciaEvalRef, "%d/%m/%Y %H:%i:%s") as fechaIniVigenciaEvalRef,
               evalProyEmp.diasVigenciaEvalRef,
               IF(evalProyEmp.CorreoLinkEnviadoRef = 1, "SÍ", "NO") as CorreoLinkEnviadoRef,
               DATE_FORMAT(evalProyEmp.fechaIniVigenciaEvalColab, "%d/%m/%Y %H:%i:%s") as fechaIniVigenciaEvalColab,
               evalProyEmp.diasVigenciaEvalColab,
               IF(evalProyEmp.CorreoLinkEnviadoColab = 1, "SÍ", "NO") as CorreoLinkEnviadoColab

               FROM eddevalproyemp evalProyEmp
               INNER JOIN eddevaluacion eval ON (evalProyEmp.idEDDEvaluacion = eval.idEDDEvaluacion)
               INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
               INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
               INNER JOIN eddproyecto proy ON (proyEmpEvaluador.idProyecto = proy.idEDDProyecto)
               INNER JOIN empleado empEvaluador ON (proyEmpEvaluador.idEmpleado = empEvaluador.idEmpleado)
               INNER JOIN empleado empEvaluado ON (proyEmpEvaluado.idEmpleado = empEvaluado.idEmpleado)
               WHERE evalProyEmp.isActive = true
               ORDER BY eval.nomEvaluacion ASC
               LIMIT IN_inicio, IN_cantidadPorPagina;
               
        -- Si idEvaluacion no es nulo
    ELSEIF IN_idEDDEvaluacion != 0 AND IN_idEDDProyEmpEvaluador = 0 AND IN_idEDDProyEmpEvaluado = 0 AND IN_idProyecto = 0 THEN 
    
        SET @temp_cantRegistros = (SELECT COUNT(idEDDEvalProyEmp) FROM eddevalproyemp WHERE isActive = true AND idEDDEvaluacion = IN_idEDDEvaluacion);
               
              SELECT @temp_cantRegistros,
               evalProyEmp.idEDDEvalProyEmp, 
               evalProyEmp.idEDDEvaluacion, 
               evalProyEmp.idEDDProyEmpEvaluador, 
               evalProyEmp.idEDDProyEmpEvaluado, 
               UPPER(proyEmpEvaluador.cargoEnProy) cargoEnProy,
               IF(evalProyEmp.evalRespondida = 1, "SÍ", "NO") as evalRespondida, 
               DATE_FORMAT(evalProyEmp.fechaIni, "%d/%m/%Y %H:%i:%s") as fechaIni, 
               DATE_FORMAT(evalProyEmp.fechaFin, "%d/%m/%Y %H:%i:%s") as fechaFin, 
               FN_tiempoPromedio(evalProyEmp.fechaIni, evalproyEmp.fechaFin) as tiempoTotalEnMin,
               UPPER(eval.nomEvaluacion) as nomEvaluacion,
               UPPER(proy.nomProyecto) as nomProyecto,
               proy.idEDDProyecto,
               UPPER(empEvaluador.nomEmpleado) as nomEmpleadoEvaluador,
               UPPER(empEvaluado.nomEmpleado) as nomEmpleadoEvaluado,
               DATE_FORMAT(eval.fechaIni, "%d/%m/%Y %H:%i:%s") as fechaInicioPeriodoEvaluacion,
               DATE_FORMAT(eval.fechaFin, "%d/%m/%Y %H:%i:%s") as fechaFinPeriodoEvaluacion,
               IF(eval.fechaIni < now() AND eval.fechaFin > now(), 1, 0) as disponibilidadEvaluacion,
               DATE_FORMAT(evalProyEmp.fechaIniVigenciaEvalRef, "%d/%m/%Y %H:%i:%s") as fechaIniVigenciaEvalRef,
               evalProyEmp.diasVigenciaEvalRef,
               IF(evalProyEmp.CorreoLinkEnviadoRef = 1, "SÍ", "NO") as CorreoLinkEnviadoRef,
               DATE_FORMAT(evalProyEmp.fechaIniVigenciaEvalColab, "%d/%m/%Y %H:%i:%s") as fechaIniVigenciaEvalColab,
               evalProyEmp.diasVigenciaEvalColab,
               IF(evalProyEmp.CorreoLinkEnviadoColab = 1, "SÍ", "NO") as CorreoLinkEnviadoColab
               FROM eddevalproyemp evalProyEmp
               INNER JOIN eddevaluacion eval ON (evalProyEmp.idEDDEvaluacion = eval.idEDDEvaluacion)
               INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
               INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
               INNER JOIN eddproyecto proy ON (proyEmpEvaluador.idProyecto = proy.idEDDProyecto)
               INNER JOIN empleado empEvaluador ON (proyEmpEvaluador.idEmpleado = empEvaluador.idEmpleado)
               INNER JOIN empleado empEvaluado ON (proyEmpEvaluado.idEmpleado = empEvaluado.idEmpleado)
               WHERE evalProyEmp.isActive = true 
               AND evalProyEmp.idEDDEvaluacion = IN_idEDDEvaluacion
               ORDER BY eval.nomEvaluacion ASC
               LIMIT IN_inicio, IN_cantidadPorPagina;
               
  	 -- Si IN_idEDDProyEmpEvaluador no es nulo
    ELSEIF IN_idEDDEvaluacion = 0 AND IN_idEDDProyEmpEvaluador != 0 AND IN_idEDDProyEmpEvaluado = 0 AND IN_idProyecto = 0 THEN 
    
        SET @temp_cantRegistros = (
              SELECT COUNT(idEDDEvalProyEmp) 
              FROM eddevalproyemp 
              WHERE isActive = true 
              AND idEDDProyEmpEvaluador = IN_idEDDProyEmpEvaluador);
               
              SELECT @temp_cantRegistros,
               evalProyEmp.idEDDEvalProyEmp, 
               evalProyEmp.idEDDEvaluacion, 
               evalProyEmp.idEDDProyEmpEvaluador, 
               evalProyEmp.idEDDProyEmpEvaluado, 
               UPPER(proyEmpEvaluador.cargoEnProy) cargoEnProy,
               IF(evalProyEmp.evalRespondida = 1, "SÍ", "NO") as evalRespondida,
               DATE_FORMAT(evalProyEmp.fechaIni, "%d/%m/%Y %H:%i:%s") as fechaIni, 
               DATE_FORMAT(evalProyEmp.fechaFin, "%d/%m/%Y %H:%i:%s") as fechaFin, 
               FN_tiempoPromedio(evalProyEmp.fechaIni, evalproyEmp.fechaFin) as tiempoTotalEnMin,
               UPPER(eval.nomEvaluacion) as nomEvaluacion,
               UPPER(proy.nomProyecto) as nomProyecto,
               proy.idEDDProyecto,
               UPPER(empEvaluador.nomEmpleado) as nomEmpleadoEvaluador,
               UPPER(empEvaluado.nomEmpleado) as nomEmpleadoEvaluado,
               DATE_FORMAT(eval.fechaIni, "%d/%m/%Y %H:%i:%s") as fechaInicioPeriodoEvaluacion,
               DATE_FORMAT(eval.fechaFin, "%d/%m/%Y %H:%i:%s") as fechaFinPeriodoEvaluacion,
               IF(eval.fechaIni < now() AND eval.fechaFin > now(), 1, 0) as disponibilidadEvaluacion,
               DATE_FORMAT(evalProyEmp.fechaIniVigenciaEvalRef, "%d/%m/%Y %H:%i:%s") as fechaIniVigenciaEvalRef,
               evalProyEmp.diasVigenciaEvalRef,
               IF(evalProyEmp.CorreoLinkEnviadoRef = 1, "SÍ", "NO") as CorreoLinkEnviadoRef,
               DATE_FORMAT(evalProyEmp.fechaIniVigenciaEvalColab, "%d/%m/%Y %H:%i:%s") as fechaIniVigenciaEvalColab,
               evalProyEmp.diasVigenciaEvalColab,
               IF(evalProyEmp.CorreoLinkEnviadoColab = 1, "SÍ", "NO") as CorreoLinkEnviadoColab
               FROM eddevalproyemp evalProyEmp
               INNER JOIN eddevaluacion eval ON (evalProyEmp.idEDDEvaluacion = eval.idEDDEvaluacion)
               INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
               INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
               INNER JOIN eddproyecto proy ON (proyEmpEvaluador.idProyecto = proy.idEDDProyecto)
               INNER JOIN empleado empEvaluador ON (proyEmpEvaluador.idEmpleado = empEvaluador.idEmpleado)
               INNER JOIN empleado empEvaluado ON (proyEmpEvaluado.idEmpleado = empEvaluado.idEmpleado)
               WHERE evalProyEmp.isActive = true 
               AND proyEmpEvaluador.idEDDEvalProyEmp = IN_idEDDProyEmpEvaluador
               ORDER BY eval.nomEvaluacion ASC
               LIMIT IN_inicio, IN_cantidadPorPagina;


        -- Si IN_idEDDProyEmpEvaluado no es nulo
    ELSEIF IN_idEDDEvaluacion = 0 AND IN_idEDDProyEmpEvaluador = 0 AND IN_idEDDProyEmpEvaluado != 0 AND IN_idProyecto = 0 THEN 
    
        SET @temp_cantRegistros = (
          SELECT COUNT(idEDDEvalProyEmp) 
          FROM eddevalproyemp 
          WHERE isActive = true 
          AND idEDDProyEmpEvaluado = IN_idEDDProyEmpEvaluado);
               
              SELECT @temp_cantRegistros,
               evalProyEmp.idEDDEvalProyEmp, 
               evalProyEmp.idEDDEvaluacion, 
               evalProyEmp.idEDDProyEmpEvaluador, 
               evalProyEmp.idEDDProyEmpEvaluado, 
               UPPER(proyEmpEvaluador.cargoEnProy) cargoEnProy,
               IF(evalProyEmp.evalRespondida = 1, "SÍ", "NO") as evalRespondida, 
               DATE_FORMAT(evalProyEmp.fechaIni, "%d/%m/%Y %H:%i:%s") as fechaIni, 
               DATE_FORMAT(evalProyEmp.fechaFin, "%d/%m/%Y %H:%i:%s") as fechaFin, 
               FN_tiempoPromedio(evalProyEmp.fechaIni, evalproyEmp.fechaFin) as tiempoTotalEnMin,
               UPPER(eval.nomEvaluacion) as nomEvaluacion,
               UPPER(proy.nomProyecto) as nomProyecto,
               proy.idEDDProyecto,
               UPPER(empEvaluador.nomEmpleado) as nomEmpleadoEvaluador,
               UPPER(empEvaluado.nomEmpleado) as nomEmpleadoEvaluado,
               DATE_FORMAT(eval.fechaIni, "%d/%m/%Y %H:%i:%s") as fechaInicioPeriodoEvaluacion,
               DATE_FORMAT(eval.fechaFin, "%d/%m/%Y %H:%i:%s") as fechaFinPeriodoEvaluacion,
               IF(eval.fechaIni < now() AND eval.fechaFin > now(), 1, 0) as disponibilidadEvaluacion,
               DATE_FORMAT(evalProyEmp.fechaIniVigenciaEvalRef, "%d/%m/%Y %H:%i:%s") as fechaIniVigenciaEvalRef,
               evalProyEmp.diasVigenciaEvalRef,
               IF(evalProyEmp.CorreoLinkEnviadoRef = 1, "SÍ", "NO") as CorreoLinkEnviadoRef,
               DATE_FORMAT(evalProyEmp.fechaIniVigenciaEvalColab, "%d/%m/%Y %H:%i:%s") as fechaIniVigenciaEvalColab,
               evalProyEmp.diasVigenciaEvalColab,
               IF(evalProyEmp.CorreoLinkEnviadoColab = 1, "SÍ", "NO") as CorreoLinkEnviadoColab
               FROM eddevalproyemp evalProyEmp
               INNER JOIN eddevaluacion eval ON (evalProyEmp.idEDDEvaluacion = eval.idEDDEvaluacion)
               INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
               INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
               INNER JOIN eddproyecto proy ON (proyEmpEvaluador.idProyecto = proy.idEDDProyecto)
               INNER JOIN empleado empEvaluador ON (proyEmpEvaluador.idEmpleado = empEvaluador.idEmpleado)
               INNER JOIN empleado empEvaluado ON (proyEmpEvaluado.idEmpleado = empEvaluado.idEmpleado)
               WHERE evalProyEmp.isActive = true 
               AND proyEmpEvaluado.idEDDProyEmp = IN_idEDDProyEmpEvaluado
               ORDER BY eval.nomEvaluacion ASC
               LIMIT IN_inicio, IN_cantidadPorPagina;


    ELSEIF IN_idEDDEvaluacion = 0 AND IN_idEDDProyEmpEvaluador = 0 AND IN_idEDDProyEmpEvaluado = 0 AND IN_idProyecto != 0 THEN 
    
        SET @temp_cantRegistros = (SELECT COUNT(idEDDEvalProyEmp) FROM eddevalproyemp evalProyEmp
                                        INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
                                        INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
                                        WHERE 
                                        evalProyEmp.isActive = true 
                                        AND proyEmpEvaluador.idProyecto = IN_idProyecto 
                                        AND proyEmpEvaluado.idProyecto = IN_idProyecto
                                    );
               
              SELECT @temp_cantRegistros,
               evalProyEmp.idEDDEvalProyEmp, 
               evalProyEmp.idEDDEvaluacion, 
               evalProyEmp.idEDDProyEmpEvaluador, 
               evalProyEmp.idEDDProyEmpEvaluado, 
               UPPER(proyEmpEvaluador.cargoEnProy) cargoEnProy,
               IF(evalProyEmp.evalRespondida = 1, "SÍ", "NO") as evalRespondida, 
               DATE_FORMAT(evalProyEmp.fechaIni, "%d/%m/%Y %H:%i:%s") as fechaIni, 
               DATE_FORMAT(evalProyEmp.fechaFin, "%d/%m/%Y %H:%i:%s") as fechaFin, 
               FN_tiempoPromedio(evalProyEmp.fechaIni, evalproyEmp.fechaFin) as tiempoTotalEnMin,
               UPPER(eval.nomEvaluacion) as nomEvaluacion,
               UPPER(proy.nomProyecto) as nomProyecto,
               proy.idEDDProyecto,
               UPPER(empEvaluador.nomEmpleado) as nomEmpleadoEvaluador,
               UPPER(empEvaluado.nomEmpleado) as nomEmpleadoEvaluado,
               DATE_FORMAT(eval.fechaIni, "%d/%m/%Y %H:%i:%s") as fechaInicioPeriodoEvaluacion,
               DATE_FORMAT(eval.fechaFin, "%d/%m/%Y %H:%i:%s") as fechaFinPeriodoEvaluacion,
               IF(eval.fechaIni < now() AND eval.fechaFin > now(), 1, 0) as disponibilidadEvaluacion,
               DATE_FORMAT(evalProyEmp.fechaIniVigenciaEvalRef, "%d/%m/%Y %H:%i:%s") as fechaIniVigenciaEvalRef,
               evalProyEmp.diasVigenciaEvalRef,
               IF(evalProyEmp.CorreoLinkEnviadoRef = 1, "SÍ", "NO") as CorreoLinkEnviadoRef,
               DATE_FORMAT(evalProyEmp.fechaIniVigenciaEvalColab, "%d/%m/%Y %H:%i:%s") as fechaIniVigenciaEvalColab,
               evalProyEmp.diasVigenciaEvalColab,
               IF(evalProyEmp.CorreoLinkEnviadoColab = 1, "SÍ", "NO") as CorreoLinkEnviadoColab
               FROM eddevalproyemp evalProyEmp
               INNER JOIN eddevaluacion eval ON (evalProyEmp.idEDDEvaluacion = eval.idEDDEvaluacion)
               INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
               INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
               INNER JOIN eddproyecto proy ON (proyEmpEvaluador.idProyecto = proy.idEDDProyecto)
               INNER JOIN empleado empEvaluador ON (proyEmpEvaluador.idEmpleado = empEvaluador.idEmpleado)
               INNER JOIN empleado empEvaluado ON (proyEmpEvaluado.idEmpleado = empEvaluado.idEmpleado)
               
               WHERE evalProyEmp.isActive = true 
               AND proyEmpEvaluador.idProyecto = IN_idProyecto 
               AND proyEmpEvaluado.idProyecto = IN_idProyecto
               ORDER BY eval.nomEvaluacion ASC
               LIMIT IN_inicio, IN_cantidadPorPagina; 



    
                

         -- Si IN_idEDDEvaluacion y IN_idEDDProyEmpEvaluador no son nulas
    ELSEIF IN_idEDDEvaluacion != 0 AND IN_idEDDProyEmpEvaluador != 0 AND IN_idEDDProyEmpEvaluado = 0 AND IN_idProyecto = 0 THEN 
    
        SET @temp_cantRegistros = (
            SELECT COUNT(idEDDEvalProyEmp) 
            FROM eddevalproyemp 
            WHERE isActive = true 
            AND idEDDEvaluacion = IN_idEDDEvaluacion
            AND idEDDProyEmpEvaluador = IN_idEDDProyEmpEvaluador);
               
              SELECT @temp_cantRegistros,
               evalProyEmp.idEDDEvalProyEmp, 
               evalProyEmp.idEDDEvaluacion, 
               evalProyEmp.idEDDProyEmpEvaluador, 
               evalProyEmp.idEDDProyEmpEvaluado, 
               UPPER(proyEmpEvaluador.cargoEnProy) cargoEnProy,
               IF(evalProyEmp.evalRespondida = 1, "SÍ", "NO") as evalRespondida,
               DATE_FORMAT(evalProyEmp.fechaIni, "%d/%m/%Y %H:%i:%s") as fechaIni, 
               DATE_FORMAT(evalProyEmp.fechaFin, "%d/%m/%Y %H:%i:%s") as fechaFin, 
               FN_tiempoPromedio(evalProyEmp.fechaIni, evalproyEmp.fechaFin) as tiempoTotalEnMin,
               UPPER(eval.nomEvaluacion) as nomEvaluacion,
               UPPER(proy.nomProyecto) as nomProyecto,
               proy.idEDDProyecto,
               UPPER(empEvaluador.nomEmpleado) as nomEmpleadoEvaluador,
               UPPER(empEvaluado.nomEmpleado) as nomEmpleadoEvaluado,
               DATE_FORMAT(eval.fechaIni, "%d/%m/%Y %H:%i:%s") as fechaInicioPeriodoEvaluacion,
               DATE_FORMAT(eval.fechaFin, "%d/%m/%Y %H:%i:%s") as fechaFinPeriodoEvaluacion,
               IF(eval.fechaIni < now() AND eval.fechaFin > now(), 1, 0) as disponibilidadEvaluacion,
               DATE_FORMAT(evalProyEmp.fechaIniVigenciaEvalRef, "%d/%m/%Y %H:%i:%s") as fechaIniVigenciaEvalRef,
               evalProyEmp.diasVigenciaEvalRef,
               IF(evalProyEmp.CorreoLinkEnviadoRef = 1, "SÍ", "NO") as CorreoLinkEnviadoRef,
               DATE_FORMAT(evalProyEmp.fechaIniVigenciaEvalColab, "%d/%m/%Y %H:%i:%s") as fechaIniVigenciaEvalColab,
               evalProyEmp.diasVigenciaEvalColab,
               IF(evalProyEmp.CorreoLinkEnviadoColab = 1, "SÍ", "NO") as CorreoLinkEnviadoColab
               FROM eddevalproyemp evalProyEmp
               INNER JOIN eddevaluacion eval ON (evalProyEmp.idEDDEvaluacion = eval.idEDDEvaluacion)
               INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
               INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
               INNER JOIN eddproyecto proy ON (proyEmpEvaluador.idProyecto = proy.idEDDProyecto)
               INNER JOIN empleado empEvaluador ON (proyEmpEvaluador.idEmpleado = empEvaluador.idEmpleado)
               INNER JOIN empleado empEvaluado ON (proyEmpEvaluado.idEmpleado = empEvaluado.idEmpleado)
               WHERE evalProyEmp.isActive = true 
               AND evalProyEmp.idEDDEvaluacion = IN_idEDDEvaluacion
               AND proyEmpEvaluador.idEDDProyEmp = IN_idEDDProyEmpEvaluador
               ORDER BY eval.nomEvaluacion ASC
               LIMIT IN_inicio, IN_cantidadPorPagina; 


         -- Si IN_idEDDEvaluacion y IN_idEDDProyEmpEvaluado no son nulas
    ELSEIF IN_idEDDEvaluacion != 0 AND IN_idEDDProyEmpEvaluador = 0 AND IN_idEDDProyEmpEvaluado != 0 AND IN_idProyecto = 0 THEN 
    
        SET @temp_cantRegistros = (
            SELECT COUNT(idEDDEvalProyEmp) 
            FROM eddevalproyemp 
            WHERE isActive = true 
            AND idEDDEvaluacion = IN_idEDDEvaluacion
            AND idEDDProyEmpEvaluado = IN_idEDDProyEmpEvaluado);
               
              SELECT @temp_cantRegistros,
               evalProyEmp.idEDDEvalProyEmp, 
               evalProyEmp.idEDDEvaluacion, 
               evalProyEmp.idEDDProyEmpEvaluador, 
               evalProyEmp.idEDDProyEmpEvaluado, 
               UPPER(proyEmpEvaluador.cargoEnProy) cargoEnProy,
               IF(evalProyEmp.evalRespondida = 1, "SÍ", "NO") as evalRespondida,
               DATE_FORMAT(evalProyEmp.fechaIni, "%d/%m/%Y %H:%i:%s") as fechaIni, 
               DATE_FORMAT(evalProyEmp.fechaFin, "%d/%m/%Y %H:%i:%s") as fechaFin, 
               FN_tiempoPromedio(evalProyEmp.fechaIni, evalproyEmp.fechaFin) as tiempoTotalEnMin,
               UPPER(eval.nomEvaluacion) as nomEvaluacion,
               UPPER(proy.nomProyecto) as nomProyecto,
               proy.idEDDProyecto,
               UPPER(empEvaluador.nomEmpleado) as nomEmpleadoEvaluador,
               UPPER(empEvaluado.nomEmpleado) as nomEmpleadoEvaluado,
               DATE_FORMAT(eval.fechaIni, "%d/%m/%Y %H:%i:%s") as fechaInicioPeriodoEvaluacion,
               DATE_FORMAT(eval.fechaFin, "%d/%m/%Y %H:%i:%s") as fechaFinPeriodoEvaluacion,
               IF(eval.fechaIni < now() AND eval.fechaFin > now(), 1, 0) as disponibilidadEvaluacion,
               DATE_FORMAT(evalProyEmp.fechaIniVigenciaEvalRef, "%d/%m/%Y %H:%i:%s") as fechaIniVigenciaEvalRef,
               evalProyEmp.diasVigenciaEvalRef,
               IF(evalProyEmp.CorreoLinkEnviadoRef = 1, "SÍ", "NO") as CorreoLinkEnviadoRef,
               DATE_FORMAT(evalProyEmp.fechaIniVigenciaEvalColab, "%d/%m/%Y %H:%i:%s") as fechaIniVigenciaEvalColab,
               evalProyEmp.diasVigenciaEvalColab,
               IF(evalProyEmp.CorreoLinkEnviadoColab = 1, "SÍ", "NO") as CorreoLinkEnviadoColab
               FROM eddevalproyemp evalProyEmp
               INNER JOIN eddevaluacion eval ON (evalProyEmp.idEDDEvaluacion = eval.idEDDEvaluacion)
               INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
               INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
               INNER JOIN eddproyecto proy ON (proyEmpEvaluador.idProyecto = proy.idEDDProyecto)
               INNER JOIN empleado empEvaluador ON (proyEmpEvaluador.idEmpleado = empEvaluador.idEmpleado)
               INNER JOIN empleado empEvaluado ON (proyEmpEvaluado.idEmpleado = empEvaluado.idEmpleado)
               WHERE evalProyEmp.isActive = true 
               AND evalProyEmp.idEDDEvaluacion = IN_idEDDEvaluacion
               AND proyEmpEvaluado.idEDDProyEmp = IN_idEDDProyEmpEvaluado
               ORDER BY eval.nomEvaluacion ASC
               LIMIT IN_inicio, IN_cantidadPorPagina; 



          -- Si IN_idEDDEvaluacion y IN_idEDDProyEmpEvaluado no son nulas
    ELSEIF IN_idEDDEvaluacion != 0 AND IN_idEDDProyEmpEvaluador = 0 AND IN_idEDDProyEmpEvaluado = 0 AND IN_idProyecto != 0 THEN 
    
        SET @temp_cantRegistros = (
            SELECT COUNT(idEDDEvalProyEmp) 
            FROM eddevalproyemp evalProyEmp
             INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
             INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
            WHERE evalProyEmp.isActive = true 
            AND evalProyEmp.idEDDEvaluacion = IN_idEDDEvaluacion
            AND proyEmpEvaluado.idProyecto = IN_idProyecto
            AND proyEmpEvaluador.idProyecto = IN_idProyecto);
               
              SELECT @temp_cantRegistros,
               evalProyEmp.idEDDEvalProyEmp, 
               evalProyEmp.idEDDEvaluacion, 
               evalProyEmp.idEDDProyEmpEvaluador, 
               evalProyEmp.idEDDProyEmpEvaluado, 
               UPPER(proyEmpEvaluador.cargoEnProy) cargoEnProy,
               IF(evalProyEmp.evalRespondida = 1, "SÍ", "NO") as evalRespondida,
               DATE_FORMAT(evalProyEmp.fechaIni, "%d/%m/%Y %H:%i:%s") as fechaIni, 
               DATE_FORMAT(evalProyEmp.fechaFin, "%d/%m/%Y %H:%i:%s") as fechaFin, 
               FN_tiempoPromedio(evalProyEmp.fechaIni, evalproyEmp.fechaFin) as tiempoTotalEnMin,
               UPPER(eval.nomEvaluacion) as nomEvaluacion,
               UPPER(proy.nomProyecto) as nomProyecto,
               proy.idEDDProyecto,
               UPPER(empEvaluador.nomEmpleado) as nomEmpleadoEvaluador,
               UPPER(empEvaluado.nomEmpleado) as nomEmpleadoEvaluado,
               DATE_FORMAT(eval.fechaIni, "%d/%m/%Y %H:%i:%s") as fechaInicioPeriodoEvaluacion,
               DATE_FORMAT(eval.fechaFin, "%d/%m/%Y %H:%i:%s") as fechaFinPeriodoEvaluacion,
               IF(eval.fechaIni < now() AND eval.fechaFin > now(), 1, 0) as disponibilidadEvaluacion,
               DATE_FORMAT(evalProyEmp.fechaIniVigenciaEvalRef, "%d/%m/%Y %H:%i:%s") as fechaIniVigenciaEvalRef,
               evalProyEmp.diasVigenciaEvalRef,
               IF(evalProyEmp.CorreoLinkEnviadoRef = 1, "SÍ", "NO") as CorreoLinkEnviadoRef,
               DATE_FORMAT(evalProyEmp.fechaIniVigenciaEvalColab, "%d/%m/%Y %H:%i:%s") as fechaIniVigenciaEvalColab,
               evalProyEmp.diasVigenciaEvalColab,
               IF(evalProyEmp.CorreoLinkEnviadoColab = 1, "SÍ", "NO") as CorreoLinkEnviadoColab
               FROM eddevalproyemp evalProyEmp
               INNER JOIN eddevaluacion eval ON (evalProyEmp.idEDDEvaluacion = eval.idEDDEvaluacion)
               INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
               INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
               INNER JOIN eddproyecto proy ON (proyEmpEvaluador.idProyecto = proy.idEDDProyecto)
               INNER JOIN empleado empEvaluador ON (proyEmpEvaluador.idEmpleado = empEvaluador.idEmpleado)
               INNER JOIN empleado empEvaluado ON (proyEmpEvaluado.idEmpleado = empEvaluado.idEmpleado)
               WHERE evalProyEmp.isActive = true 
               AND evalProyEmp.idEDDEvaluacion = IN_idEDDEvaluacion
               AND proyEmpEvaluado.idProyecto = IN_idProyecto
               AND proyEmpEvaluador.idProyecto = IN_idProyecto
               ORDER BY eval.nomEvaluacion ASC
               LIMIT IN_inicio, IN_cantidadPorPagina; 


       -- Si IN_idEDDProyEmpEvaluador y IN_idEDDProyEmpEvaluado no son nulas
    ELSEIF IN_idEDDEvaluacion = 0 AND IN_idEDDProyEmpEvaluador != 0 AND IN_idEDDProyEmpEvaluado != 0 AND IN_idProyecto = 0 THEN 
    
        SET @temp_cantRegistros = (
            SELECT COUNT(idEDDEvalProyEmp) 
            FROM eddevalproyemp evalProyEmp
            WHERE evalProyEmp.isActive = true 
            AND evalProyEmp.idEDDProyEmpEvaluado = IN_idEDDProyEmpEvaluado
            AND evalProyEmp.idEDDProyEmpEvaluador = IN_idEDDProyEmpEvaluador);
               
              SELECT @temp_cantRegistros,
               evalProyEmp.idEDDEvalProyEmp, 
               evalProyEmp.idEDDEvaluacion, 
               evalProyEmp.idEDDProyEmpEvaluador, 
               evalProyEmp.idEDDProyEmpEvaluado, 
               UPPER(proyEmpEvaluador.cargoEnProy) cargoEnProy,
               IF(evalProyEmp.evalRespondida = 1, "SÍ", "NO") as evalRespondida,
               DATE_FORMAT(evalProyEmp.fechaIni, "%d/%m/%Y %H:%i:%s") as fechaIni, 
               DATE_FORMAT(evalProyEmp.fechaFin, "%d/%m/%Y %H:%i:%s") as fechaFin, 
               FN_tiempoPromedio(evalProyEmp.fechaIni, evalproyEmp.fechaFin) as tiempoTotalEnMin,
               UPPER(eval.nomEvaluacion) as nomEvaluacion,
               UPPER(proy.nomProyecto) as nomProyecto,
               proy.idEDDProyecto,
               UPPER(empEvaluador.nomEmpleado) as nomEmpleadoEvaluador,
               UPPER(empEvaluado.nomEmpleado) as nomEmpleadoEvaluado,
               DATE_FORMAT(eval.fechaIni, "%d/%m/%Y %H:%i:%s") as fechaInicioPeriodoEvaluacion,
               DATE_FORMAT(eval.fechaFin, "%d/%m/%Y %H:%i:%s") as fechaFinPeriodoEvaluacion,
               IF(eval.fechaIni < now() AND eval.fechaFin > now(), 1, 0) as disponibilidadEvaluacion,
               DATE_FORMAT(evalProyEmp.fechaIniVigenciaEvalRef, "%d/%m/%Y %H:%i:%s") as fechaIniVigenciaEvalRef,
               evalProyEmp.diasVigenciaEvalRef,
               IF(evalProyEmp.CorreoLinkEnviadoRef = 1, "SÍ", "NO") as CorreoLinkEnviadoRef,
               DATE_FORMAT(evalProyEmp.fechaIniVigenciaEvalColab, "%d/%m/%Y %H:%i:%s") as fechaIniVigenciaEvalColab,
               evalProyEmp.diasVigenciaEvalColab,
               IF(evalProyEmp.CorreoLinkEnviadoColab = 1, "SÍ", "NO") as CorreoLinkEnviadoColab
               FROM eddevalproyemp evalProyEmp
               INNER JOIN eddevaluacion eval ON (evalProyEmp.idEDDEvaluacion = eval.idEDDEvaluacion)
               INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
               INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
               INNER JOIN eddproyecto proy ON (proyEmpEvaluador.idProyecto = proy.idEDDProyecto)
               INNER JOIN empleado empEvaluador ON (proyEmpEvaluador.idEmpleado = empEvaluador.idEmpleado)
               INNER JOIN empleado empEvaluado ON (proyEmpEvaluado.idEmpleado = empEvaluado.idEmpleado)
               WHERE evalProyEmp.isActive = true 
               AND evalProyEmp.idEDDProyEmpEvaluado = IN_idEDDProyEmpEvaluado
               AND evalProyEmp.idEDDProyEmpEvaluador = IN_idEDDProyEmpEvaluador
               ORDER BY eval.nomEvaluacion ASC
               LIMIT IN_inicio, IN_cantidadPorPagina; 

          -- Si IN_idEDDProyEmpEvaluador y IN_idProyecto no son nulas
    ELSEIF IN_idEDDEvaluacion = 0 AND IN_idEDDProyEmpEvaluador != 0 AND IN_idEDDProyEmpEvaluado = 0 AND IN_idProyecto != 0 THEN 
    
        SET @temp_cantRegistros = (
            SELECT COUNT(idEDDEvalProyEmp) 
            FROM eddevalproyemp evalProyEmp
                INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
                INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
            WHERE evalProyEmp.isActive = true 
            AND proyEmpEvaluador.idEDDProyEmp = IN_idEDDProyEmpEvaluador
            AND proyEmpEvaluador.idProyecto = IN_idProyecto
            );
               
              SELECT @temp_cantRegistros,
               evalProyEmp.idEDDEvalProyEmp, 
               evalProyEmp.idEDDEvaluacion, 
               evalProyEmp.idEDDProyEmpEvaluador, 
               evalProyEmp.idEDDProyEmpEvaluado, 
               UPPER(proyEmpEvaluador.cargoEnProy) cargoEnProy,
               IF(evalProyEmp.evalRespondida = 1, "SÍ", "NO") as evalRespondida,
               DATE_FORMAT(evalProyEmp.fechaIni, "%d/%m/%Y %H:%i:%s") as fechaIni, 
               DATE_FORMAT(evalProyEmp.fechaFin, "%d/%m/%Y %H:%i:%s") as fechaFin, 
               FN_tiempoPromedio(evalProyEmp.fechaIni, evalproyEmp.fechaFin) as tiempoTotalEnMin,
               UPPER(eval.nomEvaluacion) as nomEvaluacion,
               UPPER(proy.nomProyecto) as nomProyecto,
               proy.idEDDProyecto,
               UPPER(empEvaluador.nomEmpleado) as nomEmpleadoEvaluador,
               UPPER(empEvaluado.nomEmpleado) as nomEmpleadoEvaluado,
               DATE_FORMAT(eval.fechaIni, "%d/%m/%Y %H:%i:%s") as fechaInicioPeriodoEvaluacion,
               DATE_FORMAT(eval.fechaFin, "%d/%m/%Y %H:%i:%s") as fechaFinPeriodoEvaluacion,
               IF(eval.fechaIni < now() AND eval.fechaFin > now(), 1, 0) as disponibilidadEvaluacion,
               DATE_FORMAT(evalProyEmp.fechaIniVigenciaEvalRef, "%d/%m/%Y %H:%i:%s") as fechaIniVigenciaEvalRef,
               evalProyEmp.diasVigenciaEvalRef,
               IF(evalProyEmp.CorreoLinkEnviadoRef = 1, "SÍ", "NO") as CorreoLinkEnviadoRef,
               DATE_FORMAT(evalProyEmp.fechaIniVigenciaEvalColab, "%d/%m/%Y %H:%i:%s") as fechaIniVigenciaEvalColab,
               evalProyEmp.diasVigenciaEvalColab,
               IF(evalProyEmp.CorreoLinkEnviadoColab = 1, "SÍ", "NO") as CorreoLinkEnviadoColab
               FROM eddevalproyemp evalProyEmp
               INNER JOIN eddevaluacion eval ON (evalProyEmp.idEDDEvaluacion = eval.idEDDEvaluacion)
               INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
               INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
               INNER JOIN eddproyecto proy ON (proyEmpEvaluador.idProyecto = proy.idEDDProyecto)
               INNER JOIN empleado empEvaluador ON (proyEmpEvaluador.idEmpleado = empEvaluador.idEmpleado)
               INNER JOIN empleado empEvaluado ON (proyEmpEvaluado.idEmpleado = empEvaluado.idEmpleado)
               WHERE evalProyEmp.isActive = true 
               AND proyEmpEvaluador.idEDDProyEmp = IN_idEDDProyEmpEvaluador
               AND proyEmpEvaluador.idProyecto = IN_idProyecto
               ORDER BY eval.nomEvaluacion ASC
               LIMIT IN_inicio, IN_cantidadPorPagina; 

  
        -- Si IN_idEDDProyEmpEvaluado y IN_idProyecto no son nulas
    ELSEIF IN_idEDDEvaluacion = 0 AND IN_idEDDProyEmpEvaluador = 0 AND IN_idEDDProyEmpEvaluado != 0 AND IN_idProyecto != 0 THEN 
    
        SET @temp_cantRegistros = (
            SELECT COUNT(idEDDEvalProyEmp) 
            FROM eddevalproyemp evalProyEmp
                INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
                INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
            WHERE evalProyEmp.isActive = true 
            AND proyEmpEvaluado.idEDDProyEmp = IN_idEDDProyEmpEvaluado
            AND proyEmpEvaluado.idProyecto = IN_idProyecto 
            );
               
              SELECT @temp_cantRegistros,
               evalProyEmp.idEDDEvalProyEmp, 
               evalProyEmp.idEDDEvaluacion, 
               evalProyEmp.idEDDProyEmpEvaluador, 
               evalProyEmp.idEDDProyEmpEvaluado, 
               UPPER(proyEmpEvaluador.cargoEnProy) cargoEnProy,
               IF(evalProyEmp.evalRespondida = 1, "SÍ", "NO") as evalRespondida,
               DATE_FORMAT(evalProyEmp.fechaIni, "%d/%m/%Y %H:%i:%s") as fechaIni, 
               DATE_FORMAT(evalProyEmp.fechaFin, "%d/%m/%Y %H:%i:%s") as fechaFin, 
               FN_tiempoPromedio(evalProyEmp.fechaIni, evalproyEmp.fechaFin) as tiempoTotalEnMin,
               UPPER(eval.nomEvaluacion) as nomEvaluacion,
               UPPER(proy.nomProyecto) as nomProyecto,
               proy.idEDDProyecto,
               UPPER(empEvaluador.nomEmpleado) as nomEmpleadoEvaluador,
               UPPER(empEvaluado.nomEmpleado) as nomEmpleadoEvaluado,
               DATE_FORMAT(eval.fechaIni, "%d/%m/%Y %H:%i:%s") as fechaInicioPeriodoEvaluacion,
               DATE_FORMAT(eval.fechaFin, "%d/%m/%Y %H:%i:%s") as fechaFinPeriodoEvaluacion,
               IF(eval.fechaIni < now() AND eval.fechaFin > now(), 1, 0) as disponibilidadEvaluacion,
               DATE_FORMAT(evalProyEmp.fechaIniVigenciaEvalRef, "%d/%m/%Y %H:%i:%s") as fechaIniVigenciaEvalRef,
               evalProyEmp.diasVigenciaEvalRef,
               IF(evalProyEmp.CorreoLinkEnviadoRef = 1, "SÍ", "NO") as CorreoLinkEnviadoRef,
               DATE_FORMAT(evalProyEmp.fechaIniVigenciaEvalColab, "%d/%m/%Y %H:%i:%s") as fechaIniVigenciaEvalColab,
               evalProyEmp.diasVigenciaEvalColab,
               IF(evalProyEmp.CorreoLinkEnviadoColab = 1, "SÍ", "NO") as CorreoLinkEnviadoColab
               FROM eddevalproyemp evalProyEmp
               INNER JOIN eddevaluacion eval ON (evalProyEmp.idEDDEvaluacion = eval.idEDDEvaluacion)
               INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
               INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
               INNER JOIN eddproyecto proy ON (proyEmpEvaluador.idProyecto = proy.idEDDProyecto)
               INNER JOIN empleado empEvaluador ON (proyEmpEvaluador.idEmpleado = empEvaluador.idEmpleado)
               INNER JOIN empleado empEvaluado ON (proyEmpEvaluado.idEmpleado = empEvaluado.idEmpleado)
               WHERE evalProyEmp.isActive = true 
               AND proyEmpEvaluado.idEDDProyEmp = IN_idEDDProyEmpEvaluado
               AND proyEmpEvaluado.idProyecto = IN_idProyecto 
               ORDER BY eval.nomEvaluacion ASC
               LIMIT IN_inicio, IN_cantidadPorPagina; 




        -- Si IN_idEDDEvaluacion y IN_idEDDProyEmpEvaluador y IN_idEDDProyEmpEvaluado no son nulas
    ELSEIF IN_idEDDEvaluacion != 0 AND IN_idEDDProyEmpEvaluador != 0 AND IN_idEDDProyEmpEvaluado != 0 AND IN_idProyecto = 0 THEN 
    
        SET @temp_cantRegistros = (
            SELECT COUNT(idEDDEvalProyEmp) 
            FROM eddevalproyemp evalProyEmp
            WHERE evalProyEmp.isActive = true 
            AND evalProyEmp.idEDDEvaluacion = IN_idEDDProyEmpEvaluado
            AND evalProyEmp.idEDDProyEmpEvaluador = IN_idEDDProyEmpEvaluador
            AND evalProyEmp.idEDDProyEmpEvaluado = IN_idEDDProyEmpEvaluado
            );
               
              SELECT @temp_cantRegistros,
               evalProyEmp.idEDDEvalProyEmp, 
               evalProyEmp.idEDDEvaluacion, 
               evalProyEmp.idEDDProyEmpEvaluador, 
               evalProyEmp.idEDDProyEmpEvaluado, 
               UPPER(proyEmpEvaluador.cargoEnProy) cargoEnProy,
               IF(evalProyEmp.evalRespondida = 1, "SÍ", "NO") as evalRespondida,
               DATE_FORMAT(evalProyEmp.fechaIni, "%d/%m/%Y %H:%i:%s") as fechaIni, 
               DATE_FORMAT(evalProyEmp.fechaFin, "%d/%m/%Y %H:%i:%s") as fechaFin, 
               FN_tiempoPromedio(evalProyEmp.fechaIni, evalproyEmp.fechaFin) as tiempoTotalEnMin,
               UPPER(eval.nomEvaluacion) as nomEvaluacion,
               UPPER(proy.nomProyecto) as nomProyecto,
               proy.idEDDProyecto,
               UPPER(empEvaluador.nomEmpleado) as nomEmpleadoEvaluador,
               UPPER(empEvaluado.nomEmpleado) as nomEmpleadoEvaluado,
               DATE_FORMAT(eval.fechaIni, "%d/%m/%Y %H:%i:%s") as fechaInicioPeriodoEvaluacion,
               DATE_FORMAT(eval.fechaFin, "%d/%m/%Y %H:%i:%s") as fechaFinPeriodoEvaluacion,
               IF(eval.fechaIni < now() AND eval.fechaFin > now(), 1, 0) as disponibilidadEvaluacion,
               DATE_FORMAT(evalProyEmp.fechaIniVigenciaEvalRef, "%d/%m/%Y %H:%i:%s") as fechaIniVigenciaEvalRef,
               evalProyEmp.diasVigenciaEvalRef,
               IF(evalProyEmp.CorreoLinkEnviadoRef = 1, "SÍ", "NO") as CorreoLinkEnviadoRef,
               DATE_FORMAT(evalProyEmp.fechaIniVigenciaEvalColab, "%d/%m/%Y %H:%i:%s") as fechaIniVigenciaEvalColab,
               evalProyEmp.diasVigenciaEvalColab,
               IF(evalProyEmp.CorreoLinkEnviadoColab = 1, "SÍ", "NO") as CorreoLinkEnviadoColab
               FROM eddevalproyemp evalProyEmp
                INNER JOIN eddevaluacion eval ON (evalProyEmp.idEDDEvaluacion = eval.idEDDEvaluacion)
                INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
                INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
                INNER JOIN eddproyecto proy ON (proyEmpEvaluador.idProyecto = proy.idEDDProyecto)
                INNER JOIN empleado empEvaluador ON (proyEmpEvaluador.idEmpleado = empEvaluador.idEmpleado)
                INNER JOIN empleado empEvaluado ON (proyEmpEvaluado.idEmpleado = empEvaluado.idEmpleado)
               WHERE evalProyEmp.isActive = true 
                AND evalProyEmp.idEDDEvaluacion = IN_idEDDProyEmpEvaluado
                AND evalProyEmp.idEDDProyEmpEvaluador = IN_idEDDProyEmpEvaluador
                AND evalProyEmp.idEDDProyEmpEvaluado = IN_idEDDProyEmpEvaluado
               ORDER BY eval.nomEvaluacion ASC
               LIMIT IN_inicio, IN_cantidadPorPagina; 


             -- Si IN_idEDDProyEmpEvaluador y IN_idEDDProyEmpEvaluado y IN_idProyecto no son nulas
    ELSEIF IN_idEDDEvaluacion = 0 AND IN_idEDDProyEmpEvaluador != 0 AND IN_idEDDProyEmpEvaluado != 0 AND IN_idProyecto != 0 THEN 
    
        SET @temp_cantRegistros = (
            SELECT COUNT(idEDDEvalProyEmp) 
            FROM eddevalproyemp evalProyEmp
                INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
                INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
            WHERE evalProyEmp.isActive = true 
            AND proyEmpEvaluador.idEDDProyEmp = IN_idEDDProyEmpEvaluador
            AND proyEmpEvaluado.idEDDProyEmp = IN_idEDDProyEmpEvaluado
            AND proyEmpEvaluado.idProyecto = IN_idProyecto 
            AND proyEmpEvaluador.idProyecto = IN_idProyecto
            );
               
              SELECT @temp_cantRegistros,
               evalProyEmp.idEDDEvalProyEmp, 
               evalProyEmp.idEDDEvaluacion, 
               evalProyEmp.idEDDProyEmpEvaluador, 
               evalProyEmp.idEDDProyEmpEvaluado, 
               UPPER(proyEmpEvaluador.cargoEnProy) cargoEnProy,
               IF(evalProyEmp.evalRespondida = 1, "SÍ", "NO") as evalRespondida,
               DATE_FORMAT(evalProyEmp.fechaIni, "%d/%m/%Y %H:%i:%s") as fechaIni, 
               DATE_FORMAT(evalProyEmp.fechaFin, "%d/%m/%Y %H:%i:%s") as fechaFin, 
               FN_tiempoPromedio(evalProyEmp.fechaIni, evalproyEmp.fechaFin) as tiempoTotalEnMin,
               UPPER(eval.nomEvaluacion) as nomEvaluacion,
               UPPER(proy.nomProyecto) as nomProyecto,
               proy.idEDDProyecto,
               UPPER(empEvaluador.nomEmpleado) as nomEmpleadoEvaluador,
               UPPER(empEvaluado.nomEmpleado) as nomEmpleadoEvaluado,
               DATE_FORMAT(eval.fechaIni, "%d/%m/%Y %H:%i:%s") as fechaInicioPeriodoEvaluacion,
               DATE_FORMAT(eval.fechaFin, "%d/%m/%Y %H:%i:%s") as fechaFinPeriodoEvaluacion,
               IF(eval.fechaIni < now() AND eval.fechaFin > now(), 1, 0) as disponibilidadEvaluacion,
               DATE_FORMAT(evalProyEmp.fechaIniVigenciaEvalRef, "%d/%m/%Y %H:%i:%s") as fechaIniVigenciaEvalRef,
               evalProyEmp.diasVigenciaEvalRef,
               IF(evalProyEmp.CorreoLinkEnviadoRef = 1, "SÍ", "NO") as CorreoLinkEnviadoRef,
               DATE_FORMAT(evalProyEmp.fechaIniVigenciaEvalColab, "%d/%m/%Y %H:%i:%s") as fechaIniVigenciaEvalColab,
               evalProyEmp.diasVigenciaEvalColab,
               IF(evalProyEmp.CorreoLinkEnviadoColab = 1, "SÍ", "NO") as CorreoLinkEnviadoColab
               FROM eddevalproyemp evalProyEmp
               INNER JOIN eddevaluacion eval ON (evalProyEmp.idEDDEvaluacion = eval.idEDDEvaluacion)
               INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
               INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
               INNER JOIN eddproyecto proy ON (proyEmpEvaluador.idProyecto = proy.idEDDProyecto)
               INNER JOIN empleado empEvaluador ON (proyEmpEvaluador.idEmpleado = empEvaluador.idEmpleado)
               INNER JOIN empleado empEvaluado ON (proyEmpEvaluado.idEmpleado = empEvaluado.idEmpleado)
               WHERE evalProyEmp.isActive = true 
               AND proyEmpEvaluador.idEDDProyEmp = IN_idEDDProyEmpEvaluador
               AND proyEmpEvaluado.idEDDProyEmp = IN_idEDDProyEmpEvaluado
               AND proyEmpEvaluado.idProyecto = IN_idProyecto 
               AND proyEmpEvaluador.idProyecto = IN_idProyecto
               ORDER BY eval.nomEvaluacion ASC
               LIMIT IN_inicio, IN_cantidadPorPagina; 


          -- Si IN_idEDDEvaluacion y IN_idEDDProyEmpEvaluado y IN_idProyecto no son nulas
    ELSEIF IN_idEDDEvaluacion != 0 AND IN_idEDDProyEmpEvaluador = 0 AND IN_idEDDProyEmpEvaluado != 0 AND IN_idProyecto != 0 THEN 
    
        SET @temp_cantRegistros = (
            SELECT COUNT(idEDDEvalProyEmp) 
            FROM eddevalproyemp evalProyEmp
                INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
                INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
            WHERE evalProyEmp.isActive = true 
            AND evalProyEmp.idEDDEvaluacion = IN_idEDDProyEmpEvaluado
            AND proyEmpEvaluado.idEDDProyEmp = IN_idEDDProyEmpEvaluado
            AND proyEmpEvaluado.idProyecto = IN_idProyecto 
            );
               
              SELECT @temp_cantRegistros,
               evalProyEmp.idEDDEvalProyEmp, 
               evalProyEmp.idEDDEvaluacion, 
               evalProyEmp.idEDDProyEmpEvaluador, 
               evalProyEmp.idEDDProyEmpEvaluado, 
               UPPER(proyEmpEvaluador.cargoEnProy) cargoEnProy,
               IF(evalProyEmp.evalRespondida = 1, "SÍ", "NO") as evalRespondida,
               DATE_FORMAT(evalProyEmp.fechaIni, "%d/%m/%Y %H:%i:%s") as fechaIni, 
               DATE_FORMAT(evalProyEmp.fechaFin, "%d/%m/%Y %H:%i:%s") as fechaFin, 
               FN_tiempoPromedio(evalProyEmp.fechaIni, evalproyEmp.fechaFin) as tiempoTotalEnMin,
               UPPER(eval.nomEvaluacion) as nomEvaluacion,
               UPPER(proy.nomProyecto) as nomProyecto,
               proy.idEDDProyecto,
               UPPER(empEvaluador.nomEmpleado) as nomEmpleadoEvaluador,
               UPPER(empEvaluado.nomEmpleado) as nomEmpleadoEvaluado,
               DATE_FORMAT(eval.fechaIni, "%d/%m/%Y %H:%i:%s") as fechaInicioPeriodoEvaluacion,
               DATE_FORMAT(eval.fechaFin, "%d/%m/%Y %H:%i:%s") as fechaFinPeriodoEvaluacion,
               IF(eval.fechaIni < now() AND eval.fechaFin > now(), 1, 0) as disponibilidadEvaluacion,
               DATE_FORMAT(evalProyEmp.fechaIniVigenciaEvalRef, "%d/%m/%Y %H:%i:%s") as fechaIniVigenciaEvalRef,
               evalProyEmp.diasVigenciaEvalRef,
               IF(evalProyEmp.CorreoLinkEnviadoRef = 1, "SÍ", "NO") as CorreoLinkEnviadoRef,
               DATE_FORMAT(evalProyEmp.fechaIniVigenciaEvalColab, "%d/%m/%Y %H:%i:%s") as fechaIniVigenciaEvalColab,
               evalProyEmp.diasVigenciaEvalColab,
               IF(evalProyEmp.CorreoLinkEnviadoColab = 1, "SÍ", "NO") as CorreoLinkEnviadoColab
               FROM eddevalproyemp evalProyEmp
               INNER JOIN eddevaluacion eval ON (evalProyEmp.idEDDEvaluacion = eval.idEDDEvaluacion)
               INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
               INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
               INNER JOIN eddproyecto proy ON (proyEmpEvaluador.idProyecto = proy.idEDDProyecto)
               INNER JOIN empleado empEvaluador ON (proyEmpEvaluador.idEmpleado = empEvaluador.idEmpleado)
               INNER JOIN empleado empEvaluado ON (proyEmpEvaluado.idEmpleado = empEvaluado.idEmpleado)
               WHERE evalProyEmp.isActive = true 
               AND evalProyEmp.idEDDEvaluacion = IN_idEDDEvaluacion
               AND proyEmpEvaluado.idEDDProyEmp = IN_idEDDProyEmpEvaluado
               AND proyEmpEvaluado.idProyecto = IN_idProyecto 
               ORDER BY eval.nomEvaluacion ASC
               LIMIT IN_inicio, IN_cantidadPorPagina; 

       -- Si IN_idEDDEvaluacion y IN_idEDDProyEmpEvaluador y IN_idProyecto no son nulas
    ELSEIF IN_idEDDEvaluacion != 0 AND IN_idEDDProyEmpEvaluador != 0 AND IN_idEDDProyEmpEvaluado = 0 AND IN_idProyecto != 0 THEN 
    
        SET @temp_cantRegistros = (
            SELECT COUNT(idEDDEvalProyEmp) 
            FROM eddevalproyemp evalProyEmp
                INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
                INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
            WHERE evalProyEmp.isActive = true 
            AND evalProyEmp.idEDDEvaluacion = IN_idEDDProyEmpEvaluado
            AND proyEmpEvaluador.idEDDProyEmp = IN_idEDDProyEmpEvaluador
            AND proyEmpEvaluador.idProyecto = IN_idProyecto
            );
               
              SELECT @temp_cantRegistros,
               evalProyEmp.idEDDEvalProyEmp, 
               evalProyEmp.idEDDEvaluacion, 
               evalProyEmp.idEDDProyEmpEvaluador, 
               evalProyEmp.idEDDProyEmpEvaluado, 
               UPPER(proyEmpEvaluador.cargoEnProy) cargoEnProy,
               IF(evalProyEmp.evalRespondida = 1, "SÍ", "NO") as evalRespondida,
               DATE_FORMAT(evalProyEmp.fechaIni, "%d/%m/%Y %H:%i:%s") as fechaIni, 
               DATE_FORMAT(evalProyEmp.fechaFin, "%d/%m/%Y %H:%i:%s") as fechaFin, 
               FN_tiempoPromedio(evalProyEmp.fechaIni, evalproyEmp.fechaFin) as tiempoTotalEnMin,
               UPPER(eval.nomEvaluacion) as nomEvaluacion,
               UPPER(proy.nomProyecto) as nomProyecto,
               proy.idEDDProyecto,
               UPPER(empEvaluador.nomEmpleado) as nomEmpleadoEvaluador,
               UPPER(empEvaluado.nomEmpleado) as nomEmpleadoEvaluado,
               DATE_FORMAT(eval.fechaIni, "%d/%m/%Y %H:%i:%s") as fechaInicioPeriodoEvaluacion,
               DATE_FORMAT(eval.fechaFin, "%d/%m/%Y %H:%i:%s") as fechaFinPeriodoEvaluacion,
               IF(eval.fechaIni < now() AND eval.fechaFin > now(), 1, 0) as disponibilidadEvaluacion,
               DATE_FORMAT(evalProyEmp.fechaIniVigenciaEvalRef, "%d/%m/%Y %H:%i:%s") as fechaIniVigenciaEvalRef,
               evalProyEmp.diasVigenciaEvalRef,
               IF(evalProyEmp.CorreoLinkEnviadoRef = 1, "SÍ", "NO") as CorreoLinkEnviadoRef,
               DATE_FORMAT(evalProyEmp.fechaIniVigenciaEvalColab, "%d/%m/%Y %H:%i:%s") as fechaIniVigenciaEvalColab,
               evalProyEmp.diasVigenciaEvalColab,
               IF(evalProyEmp.CorreoLinkEnviadoColab = 1, "SÍ", "NO") as CorreoLinkEnviadoColab
               FROM eddevalproyemp evalProyEmp
               INNER JOIN eddevaluacion eval ON (evalProyEmp.idEDDEvaluacion = eval.idEDDEvaluacion)
               INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
               INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
               INNER JOIN eddproyecto proy ON (proyEmpEvaluador.idProyecto = proy.idEDDProyecto)
               INNER JOIN empleado empEvaluador ON (proyEmpEvaluador.idEmpleado = empEvaluador.idEmpleado)
               INNER JOIN empleado empEvaluado ON (proyEmpEvaluado.idEmpleado = empEvaluado.idEmpleado)
               WHERE evalProyEmp.isActive = true 
               AND evalProyEmp.idEDDEvaluacion = IN_idEDDEvaluacion
               AND proyEmpEvaluador.idEDDProyEmp = IN_idEDDProyEmpEvaluador
               AND proyEmpEvaluador.idProyecto = IN_idProyecto
               ORDER BY eval.nomEvaluacion ASC
               LIMIT IN_inicio, IN_cantidadPorPagina; 


      
        -- Si ninguna es nula
    ELSEIF IN_idEDDEvaluacion != 0 AND IN_idEDDProyEmpEvaluador != 0 AND IN_idEDDProyEmpEvaluado != 0 AND IN_idProyecto != 0 THEN 
    
        SET @temp_cantRegistros = (
            SELECT COUNT(idEDDEvalProyEmp) 
            FROM eddevalproyemp evalProyEmp
                INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
                INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
            WHERE evalProyEmp.isActive = true 
            AND evalProyEmp.idEDDEvaluacion = IN_idEDDProyEmpEvaluado
            AND proyEmpEvaluador.idEDDProyEmp = IN_idEDDProyEmpEvaluador
            AND proyEmpEvaluado.idEDDProyEmp = IN_idEDDProyEmpEvaluado
            AND proyEmpEvaluado.idProyecto = IN_idProyecto 
            AND proyEmpEvaluador.idProyecto = IN_idProyecto
            );
               
              SELECT @temp_cantRegistros,
               evalProyEmp.idEDDEvalProyEmp, 
               evalProyEmp.idEDDEvaluacion, 
               evalProyEmp.idEDDProyEmpEvaluador, 
               evalProyEmp.idEDDProyEmpEvaluado, 
               UPPER(proyEmpEvaluador.cargoEnProy) cargoEnProy,
               IF(evalProyEmp.evalRespondida = 1, "SÍ", "NO") as evalRespondida,
               DATE_FORMAT(evalProyEmp.fechaIni, "%d/%m/%Y %H:%i:%s") as fechaIni, 
               DATE_FORMAT(evalProyEmp.fechaFin, "%d/%m/%Y %H:%i:%s") as fechaFin, 
               FN_tiempoPromedio(evalProyEmp.fechaIni, evalproyEmp.fechaFin) as tiempoTotalEnMin,
               UPPER(eval.nomEvaluacion) as nomEvaluacion,
               UPPER(proy.nomProyecto) as nomProyecto,
               proy.idEDDProyecto,
               UPPER(empEvaluador.nomEmpleado) as nomEmpleadoEvaluador,
               UPPER(empEvaluado.nomEmpleado) as nomEmpleadoEvaluado,
               DATE_FORMAT(eval.fechaIni, "%d/%m/%Y %H:%i:%s") as fechaInicioPeriodoEvaluacion,
               DATE_FORMAT(eval.fechaFin, "%d/%m/%Y %H:%i:%s") as fechaFinPeriodoEvaluacion,
               IF(eval.fechaIni < now() AND eval.fechaFin > now(), 1, 0) as disponibilidadEvaluacion,
               DATE_FORMAT(evalProyEmp.fechaIniVigenciaEvalRef, "%d/%m/%Y %H:%i:%s") as fechaIniVigenciaEvalRef,
               evalProyEmp.diasVigenciaEvalRef,
               IF(evalProyEmp.CorreoLinkEnviadoRef = 1, "SÍ", "NO") as CorreoLinkEnviadoRef,
               DATE_FORMAT(evalProyEmp.fechaIniVigenciaEvalColab, "%d/%m/%Y %H:%i:%s") as fechaIniVigenciaEvalColab,
               evalProyEmp.diasVigenciaEvalColab,
               IF(evalProyEmp.CorreoLinkEnviadoColab = 1, "SÍ", "NO") as CorreoLinkEnviadoColab
               FROM eddevalproyemp evalProyEmp
               INNER JOIN eddevaluacion eval ON (evalProyEmp.idEDDEvaluacion = eval.idEDDEvaluacion)
               INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
               INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
               INNER JOIN eddproyecto proy ON (proyEmpEvaluador.idProyecto = proy.idEDDProyecto)
               INNER JOIN empleado empEvaluador ON (proyEmpEvaluador.idEmpleado = empEvaluador.idEmpleado)
               INNER JOIN empleado empEvaluado ON (proyEmpEvaluado.idEmpleado = empEvaluado.idEmpleado)
               WHERE evalProyEmp.isActive = true 
               AND evalProyEmp.idEDDEvaluacion = IN_idEDDEvaluacion
               AND proyEmpEvaluador.idEDDProyEmp = IN_idEDDProyEmpEvaluador
               AND proyEmpEvaluado.idEDDProyEmp = IN_idEDDProyEmpEvaluado
               AND proyEmpEvaluado.idProyecto = IN_idProyecto 
               AND proyEmpEvaluador.idProyecto = IN_idProyecto
               ORDER BY eval.nomEvaluacion ASC
               LIMIT IN_inicio, IN_cantidadPorPagina; 
               
        END IF;
        
    END