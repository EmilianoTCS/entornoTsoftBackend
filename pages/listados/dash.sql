  
  -- PORC GENERAL POR REFERENTE
  -- Obtiene el total de respuestas tipo alternativa y tb, el total de respuestas tipo alternativa con respuestas BUENO y MUY BUENO. 
  SELECT sum(a.cantResp) cantResp, sum(a.respBuenas) respBuenas INTO numCantResp, numCantRespBuenas
  FROM (
    SELECT epe.idEDDEvaluacion, count(*) cantResp, sum(IF(erp.nomRespPreg IN('BUENA', 'BUENO', 'MUY BUENA', 'MUY BUENO'), 1, 0)) respBuenas
    FROM eddEvalProyEmp epe
      INNER JOIN eddEvalProyResp epr ON (epr.idEDDEvaluacion = in_idEvaluacion AND epr.idEDDEvalProyEmp = epe.idEDDEvalProyEmp AND epe.EvalRespondida = 1 AND epe.isActive = 1)  
      INNER JOIN eddEvalRespPreg erp ON (erp.idEDDEvalRespPreg = epr.idEDDEvalRespPreg AND epr.isActive = 1)
    GROUP BY epe.idEDDEvaluacion, epe.idEDDProyEmpEvaluado) a
  GROUP BY a.idEDDEvaluacion;




--- COMPETENCIAS
  -- Obtiene las competencias incluidas en una encuesta, asociadas a cada evaluado y
  -- los porcentajes de satisfacción (BUENO / MUY BUENO) por evaluado para cada una de estas.
    SET out_codResp = '00';
    SET out_msjResp = 'Success';
  
  SELECT out_codResp, out_msjResp, em.nomEmpleado, a.nomCompetencia, a.cantPregComp, a.cantRespOK, a.porcAprobComp
  FROM (
    SELECT epe.idEDDProyEmpEvaluado, ec.nomCompetencia, count(*) cantPregComp, sum(IF(erp.nomRespPreg IN('BUENA', 'BUENO', 'MUY BUENA', 'MUY BUENO'), 1, 0)) cantRespOK, round(sum(IF(erp.nomRespPreg IN('BUENA', 'BUENO', 'MUY BUENA', 'MUY BUENO'), 1, 0)) * 100 / count(*), 2) porcAprobComp
    FROM eddEvalProyEmp epe
      INNER JOIN eddEvalProyResp epr ON (epe.idEDDEvaluacion = in_idEvaluacion AND epe.evalRespondida = 1 AND epe.isActive = 1 AND epr.idEDDEvalProyEmp = epe.idEDDEvalProyEmp)  
      INNER JOIN eddEvalRespPreg erp ON (erp.idEDDEvalRespPreg = epr.idEDDEvalRespPreg AND epr.isActive = 1)
      INNER JOIN eddEvalPregunta ep ON (ep.idEDDEvalPregunta = erp.idEDDEvalPregunta and ep.isActive = 1)
      INNER JOIN eddEvalCompetencia ec ON (ec.idEDDEvalCompetencia = ep.idEDDEvalCompetencia and ec.isActive = 1)
    GROUP BY epe.idEDDProyEmpEvaluado, ec.nomCompetencia
    ORDER BY ec.nomCompetencia) a
    INNER JOIN eddProyEmp pe ON (pe.idEDDProyEmp = a.idEDDProyEmpEvaluado)
    INNER JOIN empleado em ON (em.idEmpleado = pe.idEmpleado);