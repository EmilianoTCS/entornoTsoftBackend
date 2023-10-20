ALTER TABLE `entornotsoft`.`eddevalproyemp` 
ADD COLUMN `cicloEvaluacion` INT NOT NULL AFTER `idEDDProyEmpEvaluado`;

CREATE INDEX `ndx_eddEvalProyEmp_cicloEvaluacion` ON `entornotsoft`.`eddevalproyemp`(`cicloEvaluacion`);





DROP PROCEDURE IF EXISTS `SP_listadoEddEvalProyEmp`;
DELIMITER $$
CREATE PROCEDURE `SP_listadoEddEvalProyEmp`(
  IN `IN_inicio` INT, 
  IN `IN_cantidadPorPagina` INT, 
  IN `IN_idEDDEvaluacion` INT, 
  IN `IN_idEDDProyEmpEvaluador` INT, 
  IN `IN_idEDDProyEmpEvaluado` INT, 
  IN `IN_idProyecto` INT,
  IN `IN_cicloEvaluacion` INT
  )
BEGIN
	-- Si ambas son cero
	 IF IN_idEDDEvaluacion = 0 AND IN_idEDDProyEmpEvaluador = 0 AND IN_idEDDProyEmpEvaluado = 0 AND IN_idProyecto = 0 AND IN_cicloEvaluacion = 0 THEN 
    
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
               evalProyEmp.diasVigenciaEvalRefColab,
               IF(evalProyEmp.CorreoLinkEnviadoColab = 1, "SÍ", "NO") as CorreoLinkEnviadoColab,
               evalProyEmp.cicloEvaluacion

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
    ELSEIF IN_idEDDEvaluacion != 0 AND IN_idEDDProyEmpEvaluador = 0 AND IN_idEDDProyEmpEvaluado = 0 AND IN_idProyecto = 0 AND IN_cicloEvaluacion = 0 THEN 
    
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
               evalProyEmp.diasVigenciaEvalRefColab,
               IF(evalProyEmp.CorreoLinkEnviadoColab = 1, "SÍ", "NO") as CorreoLinkEnviadoColab,
               evalProyEmp.cicloEvaluacion
               
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
    ELSEIF IN_idEDDEvaluacion = 0 AND IN_idEDDProyEmpEvaluador != 0 AND IN_idEDDProyEmpEvaluado = 0 AND IN_idProyecto = 0 AND IN_cicloEvaluacion = 0 THEN 
    
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
               evalProyEmp.diasVigenciaEvalRefColab,
               IF(evalProyEmp.CorreoLinkEnviadoColab = 1, "SÍ", "NO") as CorreoLinkEnviadoColab,
               evalProyEmp.cicloEvaluacion
               
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
    ELSEIF IN_idEDDEvaluacion = 0 AND IN_idEDDProyEmpEvaluador = 0 AND IN_idEDDProyEmpEvaluado != 0 AND IN_idProyecto = 0 AND IN_cicloEvaluacion = 0 THEN 
    
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
               evalProyEmp.diasVigenciaEvalRefColab,
               IF(evalProyEmp.CorreoLinkEnviadoColab = 1, "SÍ", "NO") as CorreoLinkEnviadoColab,
               evalProyEmp.cicloEvaluacion
               
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
    
    -- Si IN_idProyecto no es nulo
    ELSEIF IN_idEDDEvaluacion = 0 AND IN_idEDDProyEmpEvaluador = 0 AND IN_idEDDProyEmpEvaluado = 0 AND IN_idProyecto != 0 AND IN_cicloEvaluacion = 0 THEN 
    
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
               evalProyEmp.diasVigenciaEvalRefColab,
               IF(evalProyEmp.CorreoLinkEnviadoColab = 1, "SÍ", "NO") as CorreoLinkEnviadoColab,
               evalProyEmp.cicloEvaluacion
               
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
    
    -- Si IN_cicloEvaluacion no es nulo
    ELSEIF IN_idEDDEvaluacion = 0 AND IN_idEDDProyEmpEvaluador = 0 AND IN_idEDDProyEmpEvaluado = 0 AND IN_idProyecto = 0 AND IN_cicloEvaluacion != 0 THEN 
    
        SET @temp_cantRegistros = (SELECT COUNT(idEDDEvalProyEmp) FROM eddevalproyemp evalProyEmp WHERE cicloEvaluacion = IN_cicloEvaluacion AND isActive = 1);
               
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
               evalProyEmp.diasVigenciaEvalRefColab,
               IF(evalProyEmp.CorreoLinkEnviadoColab = 1, "SÍ", "NO") as CorreoLinkEnviadoColab,
               evalProyEmp.cicloEvaluacion
               FROM eddevalproyemp evalProyEmp
               INNER JOIN eddevaluacion eval ON (evalProyEmp.idEDDEvaluacion = eval.idEDDEvaluacion)
               INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
               INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
               INNER JOIN eddproyecto proy ON (proyEmpEvaluador.idProyecto = proy.idEDDProyecto)
               INNER JOIN empleado empEvaluador ON (proyEmpEvaluador.idEmpleado = empEvaluador.idEmpleado)
               INNER JOIN empleado empEvaluado ON (proyEmpEvaluado.idEmpleado = empEvaluado.idEmpleado)
               
               WHERE evalProyEmp.isActive = true 
               AND evalProyEmp.cicloEvaluacion = IN_cicloEvaluacion
               ORDER BY eval.nomEvaluacion ASC
               LIMIT IN_inicio, IN_cantidadPorPagina; 
    


    -- Si IN_idEDDEvaluacion y IN_idEDDProyEmpEvaluador no es nulo
    ELSEIF IN_idEDDEvaluacion != 0 AND IN_idEDDProyEmpEvaluador != 0 AND IN_idEDDProyEmpEvaluado = 0 AND IN_idProyecto = 0 AND IN_cicloEvaluacion = 0 THEN 
    
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
               evalProyEmp.diasVigenciaEvalRefColab,
               IF(evalProyEmp.CorreoLinkEnviadoColab = 1, "SÍ", "NO") as CorreoLinkEnviadoColab,
               evalProyEmp.cicloEvaluacion
               
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

    -- Si IN_idEDDEvaluacion y IN_idEDDProyEmpEvaluado no es nulo
    ELSEIF IN_idEDDEvaluacion != 0 AND IN_idEDDProyEmpEvaluador = 0 AND IN_idEDDProyEmpEvaluado != 0 AND IN_idProyecto = 0 AND IN_cicloEvaluacion = 0 THEN 
    
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
               evalProyEmp.diasVigenciaEvalRefColab,
               IF(evalProyEmp.CorreoLinkEnviadoColab = 1, "SÍ", "NO") as CorreoLinkEnviadoColab,
               evalProyEmp.cicloEvaluacion
               
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

    -- Si IN_idEDDEvaluacion y IN_idProyecto no es nulo
    ELSEIF IN_idEDDEvaluacion != 0 AND IN_idEDDProyEmpEvaluador = 0 AND IN_idEDDProyEmpEvaluado = 0 AND IN_idProyecto != 0 AND IN_cicloEvaluacion = 0 THEN 
    
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
               evalProyEmp.diasVigenciaEvalRefColab,
               IF(evalProyEmp.CorreoLinkEnviadoColab = 1, "SÍ", "NO") as CorreoLinkEnviadoColab,
               evalProyEmp.cicloEvaluacion
               
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

    -- Si IN_idEDDEvaluacion y IN_cicloEvaluacion no es nulo
    ELSEIF IN_idEDDEvaluacion != 0 AND IN_idEDDProyEmpEvaluador = 0 AND IN_idEDDProyEmpEvaluado = 0 AND IN_idProyecto = 0 AND IN_cicloEvaluacion != 0 THEN 
    
        SET @temp_cantRegistros = (
            SELECT COUNT(idEDDEvalProyEmp) 
            FROM eddevalproyemp evalProyEmp
             INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
             INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
            WHERE evalProyEmp.isActive = true 
            AND evalProyEmp.idEDDEvaluacion = IN_idEDDEvaluacion
            AND evalProyEmp.cicloEvaluacion = IN_cicloEvaluacion
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
               evalProyEmp.diasVigenciaEvalRefColab,
               IF(evalProyEmp.CorreoLinkEnviadoColab = 1, "SÍ", "NO") as CorreoLinkEnviadoColab,
               evalProyEmp.cicloEvaluacion
               
               FROM eddevalproyemp evalProyEmp
               INNER JOIN eddevaluacion eval ON (evalProyEmp.idEDDEvaluacion = eval.idEDDEvaluacion)
               INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
               INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
               INNER JOIN eddproyecto proy ON (proyEmpEvaluador.idProyecto = proy.idEDDProyecto)
               INNER JOIN empleado empEvaluador ON (proyEmpEvaluador.idEmpleado = empEvaluador.idEmpleado)
               INNER JOIN empleado empEvaluado ON (proyEmpEvaluado.idEmpleado = empEvaluado.idEmpleado)
               WHERE evalProyEmp.isActive = true 
               AND evalProyEmp.idEDDEvaluacion = IN_idEDDEvaluacion
               AND evalProyEmp.cicloEvaluacion = IN_cicloEvaluacion
               ORDER BY eval.nomEvaluacion ASC
               LIMIT IN_inicio, IN_cantidadPorPagina; 
    


    -- Si IN_idEDDProyEmpEvaluador y IN_idEDDProyEmpEvaluado no es nulo
    ELSEIF IN_idEDDEvaluacion = 0 AND IN_idEDDProyEmpEvaluador != 0 AND IN_idEDDProyEmpEvaluado != 0 AND IN_idProyecto = 0 AND IN_cicloEvaluacion = 0 THEN 
    
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
               evalProyEmp.diasVigenciaEvalRefColab,
               IF(evalProyEmp.CorreoLinkEnviadoColab = 1, "SÍ", "NO") as CorreoLinkEnviadoColab,
               evalProyEmp.cicloEvaluacion
               
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
    ELSEIF IN_idEDDEvaluacion = 0 AND IN_idEDDProyEmpEvaluador != 0 AND IN_idEDDProyEmpEvaluado = 0 AND IN_idProyecto != 0 AND IN_cicloEvaluacion = 0 THEN 
    
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
               evalProyEmp.diasVigenciaEvalRefColab,
               IF(evalProyEmp.CorreoLinkEnviadoColab = 1, "SÍ", "NO") as CorreoLinkEnviadoColab,
               evalProyEmp.cicloEvaluacion
               
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

    -- Si IN_idEDDProyEmpEvaluador y IN_cicloEvaluacion no son nulas
    ELSEIF IN_idEDDEvaluacion = 0 AND IN_idEDDProyEmpEvaluador != 0 AND IN_idEDDProyEmpEvaluado = 0 AND IN_idProyecto = 0 AND IN_cicloEvaluacion != 0 THEN 
    
        SET @temp_cantRegistros = (
            SELECT COUNT(idEDDEvalProyEmp) FROM eddevalproyemp evalProyEmp
                INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
            WHERE evalProyEmp.isActive = true 
            AND proyEmpEvaluador.idEDDProyEmp = IN_idEDDProyEmpEvaluador
            AND evalProyEmp.cicloEvaluacion = IN_cicloEvaluacion
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
               evalProyEmp.diasVigenciaEvalRefColab,
               IF(evalProyEmp.CorreoLinkEnviadoColab = 1, "SÍ", "NO") as CorreoLinkEnviadoColab,
               evalProyEmp.cicloEvaluacion
               
               FROM eddevalproyemp evalProyEmp
               INNER JOIN eddevaluacion eval ON (evalProyEmp.idEDDEvaluacion = eval.idEDDEvaluacion)
               INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
               INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
               INNER JOIN eddproyecto proy ON (proyEmpEvaluador.idProyecto = proy.idEDDProyecto)
               INNER JOIN empleado empEvaluador ON (proyEmpEvaluador.idEmpleado = empEvaluador.idEmpleado)
               INNER JOIN empleado empEvaluado ON (proyEmpEvaluado.idEmpleado = empEvaluado.idEmpleado)
               WHERE evalProyEmp.isActive = true 
               AND proyEmpEvaluador.idEDDProyEmp = IN_idEDDProyEmpEvaluador
               AND evalProyEmp.cicloEvaluacion = IN_cicloEvaluacion
               ORDER BY eval.nomEvaluacion ASC
               LIMIT IN_inicio, IN_cantidadPorPagina; 
    
    -- Si IN_idEDDProyEmpEvaluado y IN_idProyecto no son nulas
    ELSEIF IN_idEDDEvaluacion = 0 AND IN_idEDDProyEmpEvaluador = 0 AND IN_idEDDProyEmpEvaluado != 0 AND IN_idProyecto != 0 AND IN_cicloEvaluacion = 0 THEN 
    
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
               evalProyEmp.diasVigenciaEvalRefColab,
               IF(evalProyEmp.CorreoLinkEnviadoColab = 1, "SÍ", "NO") as CorreoLinkEnviadoColab,
               evalProyEmp.cicloEvaluacion
               
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

    -- Si IN_idEDDProyEmpEvaluado y IN_cicloEvaluacion no son nulas
    ELSEIF IN_idEDDEvaluacion = 0 AND IN_idEDDProyEmpEvaluador = 0 AND IN_idEDDProyEmpEvaluado != 0 AND IN_idProyecto = 0 AND IN_cicloEvaluacion != 0 THEN 
    
        SET @temp_cantRegistros = (
            SELECT COUNT(idEDDEvalProyEmp) 
            FROM eddevalproyemp evalProyEmp
                INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
                INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
            WHERE evalProyEmp.isActive = true 
            AND proyEmpEvaluado.idEDDProyEmp = IN_idEDDProyEmpEvaluado
            AND evalProyEmp.cicloEvaluacion = IN_cicloEvaluacion 
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
               evalProyEmp.diasVigenciaEvalRefColab,
               IF(evalProyEmp.CorreoLinkEnviadoColab = 1, "SÍ", "NO") as CorreoLinkEnviadoColab,
               evalProyEmp.cicloEvaluacion
               
               FROM eddevalproyemp evalProyEmp
               INNER JOIN eddevaluacion eval ON (evalProyEmp.idEDDEvaluacion = eval.idEDDEvaluacion)
               INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
               INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
               INNER JOIN eddproyecto proy ON (proyEmpEvaluador.idProyecto = proy.idEDDProyecto)
               INNER JOIN empleado empEvaluador ON (proyEmpEvaluador.idEmpleado = empEvaluador.idEmpleado)
               INNER JOIN empleado empEvaluado ON (proyEmpEvaluado.idEmpleado = empEvaluado.idEmpleado)
               WHERE evalProyEmp.isActive = true 
               AND proyEmpEvaluado.idEDDProyEmp = IN_idEDDProyEmpEvaluado
               AND evalProyEmp.cicloEvaluacion = IN_cicloEvaluacion 
               ORDER BY eval.nomEvaluacion ASC
               LIMIT IN_inicio, IN_cantidadPorPagina; 
    
    -- Si IN_idProyecto y IN_cicloEvaluacion no son nulas
    ELSEIF IN_idEDDEvaluacion = 0 AND IN_idEDDProyEmpEvaluador = 0 AND IN_idEDDProyEmpEvaluado = 0 AND IN_idProyecto != 0 AND IN_cicloEvaluacion != 0 THEN  
    
        SET @temp_cantRegistros = (
            SELECT COUNT(idEDDEvalProyEmp) 
            FROM eddevalproyemp evalProyEmp
                INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
                INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
            WHERE evalProyEmp.isActive = true 
            AND evalProyEmp.cicloEvaluacion = IN_cicloEvaluacion
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
               evalProyEmp.diasVigenciaEvalRefColab,
               IF(evalProyEmp.CorreoLinkEnviadoColab = 1, "SÍ", "NO") as CorreoLinkEnviadoColab,
               evalProyEmp.cicloEvaluacion
               
               FROM eddevalproyemp evalProyEmp
               INNER JOIN eddevaluacion eval ON (evalProyEmp.idEDDEvaluacion = eval.idEDDEvaluacion)
               INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
               INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
               INNER JOIN eddproyecto proy ON (proyEmpEvaluador.idProyecto = proy.idEDDProyecto)
               INNER JOIN empleado empEvaluador ON (proyEmpEvaluador.idEmpleado = empEvaluador.idEmpleado)
               INNER JOIN empleado empEvaluado ON (proyEmpEvaluado.idEmpleado = empEvaluado.idEmpleado)
               WHERE evalProyEmp.isActive = true 
                AND evalProyEmp.cicloEvaluacion = IN_cicloEvaluacion
                AND proyEmpEvaluador.idProyecto = IN_idProyecto
                AND proyEmpEvaluado.idProyecto = IN_idProyecto
               ORDER BY eval.nomEvaluacion ASC
               LIMIT IN_inicio, IN_cantidadPorPagina; 
    
    
    -- Si IN_idEDDEvaluacion y IN_idEDDProyEmpEvaluador y IN_idEDDProyEmpEvaluado no son nulas
    ELSEIF IN_idEDDEvaluacion != 0 AND IN_idEDDProyEmpEvaluador != 0 AND IN_idEDDProyEmpEvaluado != 0 AND IN_idProyecto = 0 AND IN_cicloEvaluacion = 0 THEN 
    
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
               evalProyEmp.diasVigenciaEvalRefColab,
               IF(evalProyEmp.CorreoLinkEnviadoColab = 1, "SÍ", "NO") as CorreoLinkEnviadoColab,
               evalProyEmp.cicloEvaluacion
               
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
    
    -- Si IN_idEDDProyEmpEvaluador y IN_idEDDProyEmpEvaluado y IN_idProyecto no son nulas
    ELSEIF IN_idEDDEvaluacion = 0 AND IN_idEDDProyEmpEvaluador != 0 AND IN_idEDDProyEmpEvaluado != 0 AND IN_idProyecto != 0 AND IN_cicloEvaluacion = 0 THEN  
    
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
               evalProyEmp.diasVigenciaEvalRefColab,
               IF(evalProyEmp.CorreoLinkEnviadoColab = 1, "SÍ", "NO") as CorreoLinkEnviadoColab,
               evalProyEmp.cicloEvaluacion
               
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
    
    -- Si IN_idEDDProyEmpEvaluado y IN_idProyecto y IN_cicloEvaluacion no son nulas
    ELSEIF IN_idEDDEvaluacion = 0 AND IN_idEDDProyEmpEvaluador = 0 AND IN_idEDDProyEmpEvaluado != 0 AND IN_idProyecto != 0 AND IN_cicloEvaluacion != 0 THEN  
    
        SET @temp_cantRegistros = (
            SELECT COUNT(idEDDEvalProyEmp) 
            FROM eddevalproyemp evalProyEmp
                INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
                INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
            WHERE evalProyEmp.isActive = true 
            AND evalProyEmp.cicloEvaluacion = IN_cicloEvaluacion
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
               evalProyEmp.diasVigenciaEvalRefColab,
               IF(evalProyEmp.CorreoLinkEnviadoColab = 1, "SÍ", "NO") as CorreoLinkEnviadoColab,
               evalProyEmp.cicloEvaluacion
               
               FROM eddevalproyemp evalProyEmp
               INNER JOIN eddevaluacion eval ON (evalProyEmp.idEDDEvaluacion = eval.idEDDEvaluacion)
               INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
               INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
               INNER JOIN eddproyecto proy ON (proyEmpEvaluador.idProyecto = proy.idEDDProyecto)
               INNER JOIN empleado empEvaluador ON (proyEmpEvaluador.idEmpleado = empEvaluador.idEmpleado)
               INNER JOIN empleado empEvaluado ON (proyEmpEvaluado.idEmpleado = empEvaluado.idEmpleado)
               WHERE evalProyEmp.isActive = true 
               AND evalProyEmp.cicloEvaluacion = IN_cicloEvaluacion
               AND proyEmpEvaluado.idEDDProyEmp = IN_idEDDProyEmpEvaluado
               AND proyEmpEvaluado.idProyecto = IN_idProyecto
               ORDER BY eval.nomEvaluacion ASC
               LIMIT IN_inicio, IN_cantidadPorPagina; 
    
    -- Si IN_idEDDEvaluacion y IN_idProyecto y IN_cicloEvaluacion no son nulas
    ELSEIF IN_idEDDEvaluacion != 0 AND IN_idEDDProyEmpEvaluador = 0 AND IN_idEDDProyEmpEvaluado = 0 AND IN_idProyecto != 0 AND IN_cicloEvaluacion != 0 THEN  
    
        SET @temp_cantRegistros = (
            SELECT COUNT(idEDDEvalProyEmp) 
            FROM eddevalproyemp evalProyEmp
                INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
                INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
            WHERE evalProyEmp.isActive = true 
            AND evalProyEmp.cicloEvaluacion = IN_cicloEvaluacion
            AND evalProyEmp.idEDDEvaluacion = IN_idEDDEvaluacion
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
               evalProyEmp.diasVigenciaEvalRefColab,
               IF(evalProyEmp.CorreoLinkEnviadoColab = 1, "SÍ", "NO") as CorreoLinkEnviadoColab,
               evalProyEmp.cicloEvaluacion
               
               FROM eddevalproyemp evalProyEmp
               INNER JOIN eddevaluacion eval ON (evalProyEmp.idEDDEvaluacion = eval.idEDDEvaluacion)
               INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
               INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
               INNER JOIN eddproyecto proy ON (proyEmpEvaluador.idProyecto = proy.idEDDProyecto)
               INNER JOIN empleado empEvaluador ON (proyEmpEvaluador.idEmpleado = empEvaluador.idEmpleado)
               INNER JOIN empleado empEvaluado ON (proyEmpEvaluado.idEmpleado = empEvaluado.idEmpleado)
               WHERE evalProyEmp.isActive = true 
               AND evalProyEmp.cicloEvaluacion = IN_cicloEvaluacion
               AND evalProyEmp.idEDDEvaluacion = IN_idEDDEvaluacion
               AND proyEmpEvaluado.idProyecto = IN_idProyecto
               ORDER BY eval.nomEvaluacion ASC
               LIMIT IN_inicio, IN_cantidadPorPagina; 
    
    -- Si IN_idEDDEvaluacion y IN_idEDDProyEmpEvaluador y IN_cicloEvaluacion no son nulas
    ELSEIF IN_idEDDEvaluacion != 0 AND IN_idEDDProyEmpEvaluador != 0 AND IN_idEDDProyEmpEvaluado = 0 AND IN_idProyecto = 0 AND IN_cicloEvaluacion != 0 THEN  
    
        SET @temp_cantRegistros = (
            SELECT COUNT(idEDDEvalProyEmp) 
            FROM eddevalproyemp evalProyEmp
                INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
                INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
            WHERE evalProyEmp.isActive = true 
            AND evalProyEmp.cicloEvaluacion = IN_cicloEvaluacion
            AND proyEmpEvaluador.idEDDProyEmp = IN_idEDDProyEmpEvaluador
            AND evalProyEmp.idEDDEvaluacion = IN_idEDDEvaluacion
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
               evalProyEmp.diasVigenciaEvalRefColab,
               IF(evalProyEmp.CorreoLinkEnviadoColab = 1, "SÍ", "NO") as CorreoLinkEnviadoColab,
               evalProyEmp.cicloEvaluacion
               
               FROM eddevalproyemp evalProyEmp
               INNER JOIN eddevaluacion eval ON (evalProyEmp.idEDDEvaluacion = eval.idEDDEvaluacion)
               INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
               INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
               INNER JOIN eddproyecto proy ON (proyEmpEvaluador.idProyecto = proy.idEDDProyecto)
               INNER JOIN empleado empEvaluador ON (proyEmpEvaluador.idEmpleado = empEvaluador.idEmpleado)
               INNER JOIN empleado empEvaluado ON (proyEmpEvaluado.idEmpleado = empEvaluado.idEmpleado)
               WHERE evalProyEmp.isActive = true 
               AND evalProyEmp.cicloEvaluacion = IN_cicloEvaluacion
               AND proyEmpEvaluador.idEDDProyEmp = IN_idEDDProyEmpEvaluador
               AND evalProyEmp.idEDDEvaluacion = IN_idEDDEvaluacion
               ORDER BY eval.nomEvaluacion ASC
               LIMIT IN_inicio, IN_cantidadPorPagina; 

    
    
    -- Si IN_idEDDEvaluacion y IN_idEDDProyEmpEvaluador y IN_idEDDProyEmpEvaluado y IN_idProyecto no son nulas
    ELSEIF IN_idEDDEvaluacion != 0 AND IN_idEDDProyEmpEvaluador != 0 AND IN_idEDDProyEmpEvaluado != 0 AND IN_idProyecto != 0 AND IN_cicloEvaluacion = 0 THEN  
    
        SET @temp_cantRegistros = (
            SELECT COUNT(idEDDEvalProyEmp) 
            FROM eddevalproyemp evalProyEmp
                INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
                INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
            WHERE evalProyEmp.isActive = true 
            AND evalProyEmp.idEDDEvaluacion = IN_idEDDEvaluacion
            AND proyEmpEvaluador.idEDDProyEmp = IN_idEDDProyEmpEvaluador
            AND proyEmpEvaluador.idProyecto = IN_idProyecto
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
               evalProyEmp.diasVigenciaEvalRefColab,
               IF(evalProyEmp.CorreoLinkEnviadoColab = 1, "SÍ", "NO") as CorreoLinkEnviadoColab,
               evalProyEmp.cicloEvaluacion
               
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
                AND proyEmpEvaluado.idEDDProyEmp = IN_idEDDProyEmpEvaluado
                AND proyEmpEvaluado.idProyecto = IN_idProyecto
               ORDER BY eval.nomEvaluacion ASC
               LIMIT IN_inicio, IN_cantidadPorPagina; 
    
    -- Si IN_idEDDProyEmpEvaluador y IN_idEDDProyEmpEvaluado y IN_idProyecto y IN_cicloEvaluacion no son nulas
    ELSEIF IN_idEDDEvaluacion = 0 AND IN_idEDDProyEmpEvaluador != 0 AND IN_idEDDProyEmpEvaluado != 0 AND IN_idProyecto != 0 AND IN_cicloEvaluacion != 0 THEN  
    
        SET @temp_cantRegistros = (
            SELECT COUNT(idEDDEvalProyEmp) 
            FROM eddevalproyemp evalProyEmp
                INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
                INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
            WHERE evalProyEmp.isActive = true 
            AND evalProyEmp.cicloEvaluacion = IN_cicloEvaluacion
            AND proyEmpEvaluador.idEDDProyEmp = IN_idEDDProyEmpEvaluador
            AND proyEmpEvaluador.idProyecto = IN_idProyecto
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
               evalProyEmp.diasVigenciaEvalRefColab,
               IF(evalProyEmp.CorreoLinkEnviadoColab = 1, "SÍ", "NO") as CorreoLinkEnviadoColab,
               evalProyEmp.cicloEvaluacion
               
               FROM eddevalproyemp evalProyEmp
               INNER JOIN eddevaluacion eval ON (evalProyEmp.idEDDEvaluacion = eval.idEDDEvaluacion)
               INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
               INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
               INNER JOIN eddproyecto proy ON (proyEmpEvaluador.idProyecto = proy.idEDDProyecto)
               INNER JOIN empleado empEvaluador ON (proyEmpEvaluador.idEmpleado = empEvaluador.idEmpleado)
               INNER JOIN empleado empEvaluado ON (proyEmpEvaluado.idEmpleado = empEvaluado.idEmpleado)
               WHERE evalProyEmp.isActive = true 
                AND evalProyEmp.cicloEvaluacion = IN_cicloEvaluacion
                AND proyEmpEvaluador.idEDDProyEmp = IN_idEDDProyEmpEvaluador
                AND proyEmpEvaluador.idProyecto = IN_idProyecto
                AND proyEmpEvaluado.idEDDProyEmp = IN_idEDDProyEmpEvaluado
                AND proyEmpEvaluado.idProyecto = IN_idProyecto
               ORDER BY eval.nomEvaluacion ASC
               LIMIT IN_inicio, IN_cantidadPorPagina; 

    -- Si IN_idEDDEvaluacion y IN_idEDDProyEmpEvaluado y IN_idProyecto y IN_cicloEvaluacion no son nulas
    ELSEIF IN_idEDDEvaluacion != 0 AND IN_idEDDProyEmpEvaluador = 0 AND IN_idEDDProyEmpEvaluado != 0 AND IN_idProyecto != 0 AND IN_cicloEvaluacion != 0 THEN  
    
        SET @temp_cantRegistros = (
            SELECT COUNT(idEDDEvalProyEmp) 
            FROM eddevalproyemp evalProyEmp
                INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
                INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
            WHERE evalProyEmp.isActive = true 
            AND evalProyEmp.idEDDEvaluacion = IN_idEDDEvaluacion
            AND evalProyEmp.cicloEvaluacion = IN_cicloEvaluacion
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
               evalProyEmp.diasVigenciaEvalRefColab,
               IF(evalProyEmp.CorreoLinkEnviadoColab = 1, "SÍ", "NO") as CorreoLinkEnviadoColab,
               evalProyEmp.cicloEvaluacion
               
               FROM eddevalproyemp evalProyEmp
               INNER JOIN eddevaluacion eval ON (evalProyEmp.idEDDEvaluacion = eval.idEDDEvaluacion)
               INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
               INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
               INNER JOIN eddproyecto proy ON (proyEmpEvaluador.idProyecto = proy.idEDDProyecto)
               INNER JOIN empleado empEvaluador ON (proyEmpEvaluador.idEmpleado = empEvaluador.idEmpleado)
               INNER JOIN empleado empEvaluado ON (proyEmpEvaluado.idEmpleado = empEvaluado.idEmpleado)
               WHERE evalProyEmp.isActive = true 
                AND evalProyEmp.idEDDEvaluacion = IN_idEDDEvaluacion
                AND evalProyEmp.cicloEvaluacion = IN_cicloEvaluacion
                AND proyEmpEvaluado.idEDDProyEmp = IN_idEDDProyEmpEvaluado
                AND proyEmpEvaluado.idProyecto = IN_idProyecto
               ORDER BY eval.nomEvaluacion ASC
               LIMIT IN_inicio, IN_cantidadPorPagina; 

    -- Si IN_idEDDEvaluacion y IN_idEDDProyEmpEvaluador y IN_idProyecto y IN_cicloEvaluacion no son nulas
    ELSEIF IN_idEDDEvaluacion != 0 AND IN_idEDDProyEmpEvaluador != 0 AND IN_idEDDProyEmpEvaluado = 0 AND IN_idProyecto != 0 AND IN_cicloEvaluacion != 0 THEN  
    
        SET @temp_cantRegistros = (
            SELECT COUNT(idEDDEvalProyEmp) 
            FROM eddevalproyemp evalProyEmp
                INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
                INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
            WHERE evalProyEmp.isActive = true 
            AND evalProyEmp.idEDDEvaluacion = IN_idEDDEvaluacion
            AND evalProyEmp.cicloEvaluacion = IN_cicloEvaluacion
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
               evalProyEmp.diasVigenciaEvalRefColab,
               IF(evalProyEmp.CorreoLinkEnviadoColab = 1, "SÍ", "NO") as CorreoLinkEnviadoColab,
               evalProyEmp.cicloEvaluacion
               
               FROM eddevalproyemp evalProyEmp
               INNER JOIN eddevaluacion eval ON (evalProyEmp.idEDDEvaluacion = eval.idEDDEvaluacion)
               INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
               INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
               INNER JOIN eddproyecto proy ON (proyEmpEvaluador.idProyecto = proy.idEDDProyecto)
               INNER JOIN empleado empEvaluador ON (proyEmpEvaluador.idEmpleado = empEvaluador.idEmpleado)
               INNER JOIN empleado empEvaluado ON (proyEmpEvaluado.idEmpleado = empEvaluado.idEmpleado)
               WHERE evalProyEmp.isActive = true 
               AND evalProyEmp.idEDDEvaluacion = IN_idEDDEvaluacion
               AND evalProyEmp.cicloEvaluacion = IN_cicloEvaluacion
               AND proyEmpEvaluador.idEDDProyEmp = IN_idEDDProyEmpEvaluador
               AND proyEmpEvaluador.idProyecto = IN_idProyecto
               ORDER BY eval.nomEvaluacion ASC
               LIMIT IN_inicio, IN_cantidadPorPagina; 

    -- Si IN_idEDDEvaluacion y IN_idEDDProyEmpEvaluador y IN_idEDDProyEmpEvaluado y IN_cicloEvaluacion no son nulas
    ELSEIF IN_idEDDEvaluacion != 0 AND IN_idEDDProyEmpEvaluador != 0 AND IN_idEDDProyEmpEvaluado != 0 AND IN_idProyecto = 0 AND IN_cicloEvaluacion != 0 THEN  
    
        SET @temp_cantRegistros = (
            SELECT COUNT(idEDDEvalProyEmp) 
            FROM eddevalproyemp evalProyEmp
                INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
                INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
            WHERE evalProyEmp.isActive = true 
            AND evalProyEmp.idEDDEvaluacion = IN_idEDDEvaluacion
            AND evalProyEmp.cicloEvaluacion = IN_cicloEvaluacion
            AND proyEmpEvaluador.idEDDProyEmp = IN_idEDDProyEmpEvaluador
            AND proyEmpEvaluado.idEDDProyEmp = IN_idEDDProyEmpEvaluado
            
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
               evalProyEmp.diasVigenciaEvalRefColab,
               IF(evalProyEmp.CorreoLinkEnviadoColab = 1, "SÍ", "NO") as CorreoLinkEnviadoColab,
               evalProyEmp.cicloEvaluacion
               
               FROM eddevalproyemp evalProyEmp
               INNER JOIN eddevaluacion eval ON (evalProyEmp.idEDDEvaluacion = eval.idEDDEvaluacion)
               INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
               INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
               INNER JOIN eddproyecto proy ON (proyEmpEvaluador.idProyecto = proy.idEDDProyecto)
               INNER JOIN empleado empEvaluador ON (proyEmpEvaluador.idEmpleado = empEvaluador.idEmpleado)
               INNER JOIN empleado empEvaluado ON (proyEmpEvaluado.idEmpleado = empEvaluado.idEmpleado)
               WHERE evalProyEmp.isActive = true 
                AND evalProyEmp.idEDDEvaluacion = IN_idEDDEvaluacion
                AND evalProyEmp.cicloEvaluacion = IN_cicloEvaluacion
                AND proyEmpEvaluador.idEDDProyEmp = IN_idEDDProyEmpEvaluador
                AND proyEmpEvaluado.idEDDProyEmp = IN_idEDDProyEmpEvaluado
               ORDER BY eval.nomEvaluacion ASC
               LIMIT IN_inicio, IN_cantidadPorPagina; 


    -- Si ninguna es nula
    ELSEIF IN_idEDDEvaluacion != 0 AND IN_idEDDProyEmpEvaluador != 0 AND IN_idEDDProyEmpEvaluado != 0 AND IN_idProyecto != 0 AND IN_cicloEvaluacion != 0 THEN 
    
        SET @temp_cantRegistros = (
            SELECT COUNT(idEDDEvalProyEmp) 
            FROM eddevalproyemp evalProyEmp
                INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
                INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
            WHERE evalProyEmp.isActive = true 
            AND evalProyEmp.idEDDEvaluacion = IN_idEDDProyEmpEvaluado
            AND evalProyEmp.cicloEvaluacion = IN_cicloEvaluacion
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
               evalProyEmp.diasVigenciaEvalRefColab,
               IF(evalProyEmp.CorreoLinkEnviadoColab = 1, "SÍ", "NO") as CorreoLinkEnviadoColab,
               evalProyEmp.cicloEvaluacion
               
               FROM eddevalproyemp evalProyEmp
               INNER JOIN eddevaluacion eval ON (evalProyEmp.idEDDEvaluacion = eval.idEDDEvaluacion)
               INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
               INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
               INNER JOIN eddproyecto proy ON (proyEmpEvaluador.idProyecto = proy.idEDDProyecto)
               INNER JOIN empleado empEvaluador ON (proyEmpEvaluador.idEmpleado = empEvaluador.idEmpleado)
               INNER JOIN empleado empEvaluado ON (proyEmpEvaluado.idEmpleado = empEvaluado.idEmpleado)
               WHERE evalProyEmp.isActive = true 
               AND evalProyEmp.idEDDEvaluacion = IN_idEDDProyEmpEvaluado
               AND evalProyEmp.cicloEvaluacion = IN_cicloEvaluacion
               AND proyEmpEvaluador.idEDDProyEmp = IN_idEDDProyEmpEvaluador
               AND proyEmpEvaluado.idEDDProyEmp = IN_idEDDProyEmpEvaluado
               AND proyEmpEvaluado.idProyecto = IN_idProyecto 
               AND proyEmpEvaluador.idProyecto = IN_idProyecto
               ORDER BY eval.nomEvaluacion ASC
               LIMIT IN_inicio, IN_cantidadPorPagina; 
               
        END IF;
        
END$$
DELIMITER ;




DROP PROCEDURE IF EXISTS `SP_insertarEddEvalProyEmp`;
DELIMITER $$
CREATE PROCEDURE `SP_insertarEddEvalProyEmp`(
  IN `IN_idEDDEvaluacion` INT, 
  IN `IN_idEDDProyEmpEvaluador` INT, 
  IN `IN_idEDDProyEmpEvaluado` INT, 
  IN `IN_cicloEvaluacion` INT, 
  IN `IN_evalRespondida` TINYINT, 
  IN `IN_isActive` TINYINT, 
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

          SET str_mjeInterno = CONCAT('SP_insertarEddEvalProyEmp: Error al insertar registro --> IN_idEDDEvaluacion: [', IN_idEDDEvaluacion, '] - IN_idEDDProyEmpEvaluador: [', IN_idEDDProyEmpEvaluador, '] - IN_idEDDProyEmpEvaluado: [', IN_idEDDProyEmpEvaluado, '] - IN_evalRespondida: [', IN_evalRespondida, '] - IN_isActive: [', IN_isActive, '] - IN_usuarioCreacion: [', IN_usuarioCreacion, ']');

          INSERT INTO logErroresObj (idLogErrorObj, nomObjeto, codError, descError, fechaHoraError, codErrorInterno, descErrorInterno) 
          VALUES(null, 'SP_insertarEddEvalProyEmp', str_codMySQL, str_msgMySQL, now(), '13', str_mjeInterno);
          COMMIT;

          SET OUT_CODRESULT = '13';
          SET OUT_MJERESULT = concat(str_codMySQL, ' - ', str_msgMySQL);
          SELECT OUT_MJERESULT, OUT_CODRESULT;

  END;

          IF IN_idEDDEvaluacion IS NULL 
            OR IN_idEDDProyEmpEvaluador IS NULL 
            OR IN_idEDDProyEmpEvaluado IS NULL 
            OR IN_isActive IS NULL 
            OR IN_usuarioCreacion is NULL

            OR IN_idEDDEvaluacion = "%null%"
            OR IN_idEDDProyEmpEvaluador = "%null%"
            OR IN_idEDDProyEmpEvaluado = "%null%"
            OR IN_isActive = "%null%"
            OR IN_usuarioCreacion = "%null%"

            THEN
             SET OUT_MJERESULT = "Uno o más parámetros de entrada vienen nulos";
             SET OUT_CODRESULT = '01'; 
             SELECT OUT_MJERESULT, OUT_CODRESULT;

          ELSEIF IN_idEDDEvaluacion <= 0 THEN
                SET OUT_CODRESULT = '02';
                SET OUT_MJERESULT = 'El idEDDEvaluacion debe ser mayor a cero';
                SELECT OUT_MJERESULT, OUT_CODRESULT;
          ELSEIF IN_idEDDProyEmpEvaluador <= 0 THEN
                SET OUT_CODRESULT = '03';
                SET OUT_MJERESULT = 'El IN_idEDDProyEmpEvaluador debe ser mayor a cero';
                SELECT OUT_MJERESULT, OUT_CODRESULT;
          ELSEIF IN_idEDDProyEmpEvaluado <= 0 THEN
                SET OUT_CODRESULT = '04';
                SET OUT_MJERESULT = 'El IN_idEDDProyEmpEvaluado debe ser mayor a cero';
                SELECT OUT_MJERESULT, OUT_CODRESULT;
          ELSEIF IN_evalRespondida NOT IN (0, 1) THEN
                SET OUT_CODRESULT = '05';
                SET OUT_MJERESULT = 'La evalRespondida debe ser verdadero o falso';
                SELECT OUT_MJERESULT, OUT_CODRESULT;
          ELSEIF IN_isActive NOT IN (0, 1) THEN
                SET OUT_CODRESULT = '06';
                SET OUT_MJERESULT = 'El estado del registro debe ser verdadero o falso';  
                SELECT OUT_MJERESULT, OUT_CODRESULT;             
          ELSEIF TRIM(IN_usuarioCreacion) = '' THEN
                SET OUT_CODRESULT = '07';
                SET OUT_MJERESULT = 'El usuario administrador quien crea el registro viene vacío';
                SELECT OUT_MJERESULT, OUT_CODRESULT;
          ELSEIF FN_EXISTE_EDDEvalProyEmp(IN_idEDDEvaluacion, IN_idEDDProyEmpEvaluador, IN_idEDDProyEmpEvaluado) = true THEN
                SET OUT_CODRESULT = '08';
                SET OUT_MJERESULT = 'Ya existen registros con esos valores.';
                SELECT OUT_MJERESULT, OUT_CODRESULT;   
          ELSEIF IN_idEDDProyEmpEvaluador = IN_idEDDProyEmpEvaluado THEN
                SET OUT_CODRESULT = '09';
                SET OUT_MJERESULT = 'El Evaluador no debe ser igual al evaluado';
                SELECT OUT_MJERESULT, OUT_CODRESULT;   

            ELSE
                SET AUTOCOMMIT = 0;
                START TRANSACTION;

            INSERT INTO eddevalproyemp (
                idEDDEvaluacion, 
                idEDDProyEmpEvaluador, 
                idEDDProyEmpEvaluado, 
                cicloEvaluacion, 
                evalRespondida, 
                isActive, 
                fechaCreacion,
                usuarioCreacion,
                fechaModificacion,
                usuarioModificacion)
            VALUES (
                IN_idEDDEvaluacion, 
                IN_idEDDProyEmpEvaluador, 
                IN_idEDDProyEmpEvaluado, 
                IN_cicloEvaluacion, 
                IN_evalRespondida, 
                IN_isActive, 
                now(), 
                IN_usuarioCreacion,
                now(),
                IN_usuarioCreacion);
             COMMIT;
                SET OUT_CODRESULT = '00';
                SET OUT_MJERESULT = 'Success';


               SELECT OUT_CODRESULT, OUT_MJERESULT,
               evalProyEmp.idEDDEvalProyEmp, 
               evalProyEmp.idEDDEvaluacion, 
               evalProyEmp.idEDDProyEmpEvaluador, 
               evalProyEmp.idEDDProyEmpEvaluado, 
               IF(evalProyEmp.evalRespondida = 1, "SÍ", "NO") as evalRespondida, 
               DATE_FORMAT(evalProyEmp.fechaIni, "%d/%m/%Y %H:%m:%i") as fechaIni, 
               DATE_FORMAT(evalProyEmp.fechaFin, "%d/%m/%Y %H:%m:%i") as fechaFin, 
               UPPER(eval.nomEvaluacion) as nomEvaluacion,
               UPPER(proy.nomProyecto) as nomProyecto,
               UPPER(empEvaluador.nomEmpleado) as nomEmpleadoEvaluador,
               UPPER(empEvaluado.nomEmpleado) as nomEmpleadoEvaluado,
               evalProyEmp.cicloEvaluacion
               FROM eddevalproyemp evalProyEmp
               INNER JOIN eddevaluacion eval ON (evalProyEmp.idEDDEvaluacion = eval.idEDDEvaluacion)
               INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
               INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
               INNER JOIN eddproyecto proy ON (proyEmpEvaluador.idProyecto = proy.idEDDProyecto)
               INNER JOIN empleado empEvaluador ON (proyEmpEvaluador.idEmpleado = empEvaluador.idEmpleado)
               INNER JOIN empleado empEvaluado ON (proyEmpEvaluado.idEmpleado = empEvaluado.idEmpleado)
               WHERE evalProyEmp.idEDDEvalProyEmp = LAST_INSERT_ID();

     END IF;

END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS `SP_editarEddEvalProyEmp`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_editarEddEvalProyEmp`(
  IN `IN_idEDDEvalProyEmp` INT, 
  IN `IN_idEDDEvaluacion` INT, 
  IN `IN_idEDDProyEmpEvaluador` INT, 
  IN `IN_idEDDProyEmpEvaluado` INT, 
  IN `IN_cicloEvaluacion` INT, 
  IN `IN_evalRespondida` TINYINT, 
  IN `IN_isActive` TINYINT, 
  IN `IN_usuarioModificacion` VARCHAR(15), 
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

          SET str_mjeInterno = CONCAT('SP_editarEddEvalProyEmp: Error al insertar registro --> IN_idEDDEvalProyEmp: [', IN_idEDDEvalProyEmp, '] - IN_idEDDEvaluacion: [', IN_idEDDEvaluacion, '] - IN_idEDDProyEmpEvaluador: [', IN_idEDDProyEmpEvaluador, '] - IN_idEDDProyEmpEvaluado: [', IN_idEDDProyEmpEvaluado, '] - IN_evalRespondida: [', IN_evalRespondida, '] - IN_isActive: [', IN_isActive, '] - IN_usuarioModificacion: [', IN_usuarioModificacion, ']');

          INSERT INTO logErroresObj (idLogErrorObj, nomObjeto, codError, descError, fechaHoraError, codErrorInterno, descErrorInterno) 
          VALUES(null, 'SP_editarEddEvalProyEmp', str_codMySQL, str_msgMySQL, now(), '13', str_mjeInterno);
          COMMIT;

          SET OUT_CODRESULT = '13';
          SET OUT_MJERESULT = concat(str_codMySQL, ' - ', str_msgMySQL);
          SELECT OUT_MJERESULT, OUT_CODRESULT;

  END;

            IF IN_idEDDEvalProyEmp IS NULL 
            OR IN_idEDDEvaluacion IS NULL 
            OR IN_idEDDProyEmpEvaluador IS NULL 
            OR IN_idEDDProyEmpEvaluado IS NULL  
            OR IN_isActive IS NULL 
            OR IN_usuarioModificacion is NULL

            OR IN_idEDDEvalProyEmp = "%null%"
            OR IN_idEDDEvaluacion = "%null%"
            OR IN_idEDDProyEmpEvaluador = "%null%"
            OR IN_idEDDProyEmpEvaluado = "%null%"
            OR IN_isActive = "%null%"
            OR IN_usuarioModificacion = "%null%"

            THEN
             SET OUT_MJERESULT = "Uno o más parámetros de entrada vienen nulos";
             SET OUT_CODRESULT = '01';
             SELECT OUT_MJERESULT, OUT_CODRESULT;

             ELSEIF IN_idEDDEvaluacion <= 0 THEN
                SET OUT_CODRESULT = '02';
                SET OUT_MJERESULT = 'El idEDDEvaluacion debe ser mayor a cero';
                SELECT OUT_MJERESULT, OUT_CODRESULT;

             ELSEIF IN_idEDDProyEmpEvaluador <= 0 THEN
                SET OUT_CODRESULT = '03';
                SET OUT_MJERESULT = 'El IN_idEDDProyEmpEvaluador debe ser mayor a cero';
                SELECT OUT_MJERESULT, OUT_CODRESULT;

             ELSEIF IN_idEDDProyEmpEvaluado <= 0 THEN
                SET OUT_CODRESULT = '04';
                SET OUT_MJERESULT = 'El IN_idEDDProyEmpEvaluado debe ser mayor a cero';
                SELECT OUT_MJERESULT, OUT_CODRESULT;
             ELSEIF IN_evalRespondida NOT IN (0, 1) THEN
                SET OUT_CODRESULT = '05';
                SET OUT_MJERESULT = 'La evalRespondida debe ser verdadero o falso';
                SELECT OUT_MJERESULT, OUT_CODRESULT;

             ELSEIF IN_isActive NOT IN (0, 1) THEN
                SET OUT_CODRESULT = '06';
                SET OUT_MJERESULT = 'El estado del registro debe ser verdadero o falso';  
                SELECT OUT_MJERESULT, OUT_CODRESULT;             

             ELSEIF TRIM(IN_usuarioModificacion) = '' THEN
                SET OUT_CODRESULT = '07';
                SET OUT_MJERESULT = 'El usuario administrador quien crea el registro viene vacío';
                SELECT OUT_MJERESULT, OUT_CODRESULT;

              ELSEIF IN_idEDDEvalProyEmp <= 0 THEN
                SET OUT_CODRESULT = '08';
                SET OUT_MJERESULT = 'El idEDDEvalProyEmp debe ser mayor a cero';
                SELECT OUT_MJERESULT, OUT_CODRESULT;

              ELSEIF IN_idEDDProyEmpEvaluador = IN_idEDDProyEmpEvaluado THEN
                SET OUT_CODRESULT = '09';
                SET OUT_MJERESULT = 'El Evaluador no debe ser igual al evaluado';
                SELECT OUT_MJERESULT, OUT_CODRESULT;  

              ELSEIF FN_EXISTE_EDDEvalProyEmp(IN_idEDDEvaluacion, IN_idEDDProyEmpEvaluador, IN_idEDDProyEmpEvaluado) = true THEN
                SET OUT_CODRESULT = '10';
                SET OUT_MJERESULT = 'Ya existen registros con esos valores.';
                SELECT OUT_MJERESULT, OUT_CODRESULT;         

            ELSE

                SET AUTOCOMMIT = 0;
                START TRANSACTION;

            UPDATE eddevalproyemp SET
            idEDDEvaluacion = IN_idEDDEvaluacion,
            idEDDProyEmpEvaluador = IN_idEDDProyEmpEvaluador,
            idEDDProyEmpEvaluado = IN_idEDDProyEmpEvaluado,
            cicloEvaluacion = IN_cicloEvaluacion,
            evalRespondida = IN_evalRespondida,
            isActive = IN_isActive,
            fechaModificacion = now(),
            usuarioModificacion = IN_usuarioModificacion
            WHERE idEDDEvalProyEmp = IN_idEDDEvalProyEmp;

             COMMIT;
                SET OUT_CODRESULT = '00';
                SET OUT_MJERESULT = 'Success';

               SELECT OUT_CODRESULT, OUT_MJERESULT,
               evalProyEmp.idEDDEvalProyEmp, 
               evalProyEmp.idEDDEvaluacion, 
               evalProyEmp.idEDDProyEmpEvaluador, 
               evalProyEmp.idEDDProyEmpEvaluado, 
               IF(evalProyEmp.evalRespondida = 1, "SÍ", "NO") as evalRespondida,
               DATE_FORMAT(evalProyEmp.fechaIni, "%d/%m/%Y %H:%m:%i") as fechaIni, 
               DATE_FORMAT(evalProyEmp.fechaFin, "%d/%m/%Y %H:%m:%i") as fechaFin, 
               UPPER(eval.nomEvaluacion) as nomEvaluacion,
               UPPER(proy.nomProyecto) as nomProyecto,
               UPPER(empEvaluador.nomEmpleado) as nomEmpleadoEvaluador,
               UPPER(empEvaluado.nomEmpleado) as nomEmpleadoEvaluado,
               evalProyEmp.cicloEvaluacion
               FROM eddevalproyemp evalProyEmp
               INNER JOIN eddevaluacion eval ON (evalProyEmp.idEDDEvaluacion = eval.idEDDEvaluacion)
               INNER JOIN eddproyemp proyEmpEvaluador ON (evalProyEmp.idEDDProyEmpEvaluador = proyEmpEvaluador.idEDDProyEmp)
               INNER JOIN eddproyemp proyEmpEvaluado ON (evalProyEmp.idEDDProyEmpEvaluado = proyEmpEvaluado.idEDDProyEmp)
               INNER JOIN eddproyecto proy ON (proyEmpEvaluador.idProyecto = proy.idEDDProyecto)
               INNER JOIN empleado empEvaluador ON (proyEmpEvaluador.idEmpleado = empEvaluador.idEmpleado)
               INNER JOIN empleado empEvaluado ON (proyEmpEvaluado.idEmpleado = empEvaluado.idEmpleado)
               WHERE evalProyEmp.idEDDEvalProyEmp = IN_idEDDEvalProyEmp;
     END IF;

END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS `SP_seleccionarDatos`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_seleccionarDatos`(IN `IN_nombreTabla` VARCHAR(40), IN `IN_idRegistro` INT, OUT `OUT_CODRESULT` CHAR(2), OUT `OUT_MJERESULT` VARCHAR(500))
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
                
            ELSEIF UPPER(IN_nombreTabla) NOT IN ('ALUMNO','AREA','CARGO','CLIENTE','CONTACTO','CURSO','CURSOALUMNO','CURSOALUMNO_SESION','EMPLEADO','NOTAEXAMEN','RAMO','RAMOEXAMEN','RELATORRAMO','REQCURSO','SERVICIO','SESION', 'EDDPROYECTO', 'EDDPROYEMP', 'EMPTIPOPERFIL', 'EMPSUBSIST', 'EDDEVALCOMPETENCIA', 'EDDEVALRESPPREG', 'EDDEVALPREGUNTA', 'EDDEVALPROYRESP', 'EDDEVALUACION', 'EDDEVALPROYEMP') THEN
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
                       proy.fechaInicio as fechaIni, proy.fechaFin, UPPER(serv.nomServicio) as nomServicio
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

                END IF;
            END IF;          			
        END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS `SP_AUX_listadoCiclosEval`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_AUX_listadoCiclosEval`()
BEGIN
SELECT idEDDEvalProyEmp, cicloEvaluacion FROM eddevalproyemp WHERE isActive = 1 group by cicloEvaluacion order by cicloEvaluacion;
END$$
DELIMITER ;