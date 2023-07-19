
-- OBTIENE LAS EVALUACIONES PENDIENTES POR USUARIO / ID EMPLEADO PARA EL MAPEADO, ASIGNANDO IDEDDEVALUACION COMO VALUE
SELECT evalProyEmp.idEDDEvaluacion, emp.nomEmpleado,
    CONCAT(UPPER(eval.nomEvaluacion), ' - ', UPPER(eval.tipoEvaluacion), ' - ' ) as nomEvaluacion
    FROM empleado emp
    INNER JOIN eddproyemp proyEmp ON (emp.idEmpleado = proyEmp.idEmpleado)
    INNER JOIN eddevalproyemp evalProyEmp ON (proyEmp.idEDDProyEmp = evalProyEmp.idEDDProyEmpEvaluador OR 
                                              proyEmp.idEDDProyEmp = evalProyEmp.idEDDProyEmpEvaluado)
    INNER JOIN eddevaluacion eval ON (eval.idEDDEvaluacion = evalProyEmp.idEDDEvaluacion)
    WHERE 
    emp.idEmpleado = 1
    AND emp.isActive = true
    AND proyEmp.isActive = true
    AND evalProyEmp.isActive = true
    AND evalProyEmp.evalRespondida = 0;


--OBTENGO LAS PREGUNTAS Y LAS RESPUESTAS DE UNA EVALUACION, USANDO EL VALUE IDDEVALUACION COMO FILTRO (se obtiene por frontend)
SELECT ep.ordenPregunta, ep.idEDDEvalPregunta, ep.nomPregunta, ep.tipoResp, erp.ordenRespPreg, erp.idEDDEvalRespPreg, erp.nomRespPreg
FROM eddEvalPregunta ep
  INNER JOIN eddEvalRespPreg erp ON (erp.idEDDEvalPregunta = ep.idEDDEvalPregunta AND ep.isActive = 1 AND erp.isActive = 1)
WHERE ep.idEDDEvaluacion = 1
ORDER BY ep.ordenPregunta, erp.ordenRespPreg