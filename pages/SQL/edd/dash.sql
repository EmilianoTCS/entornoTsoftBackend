BEGIN
  DECLARE numTotalEvaluados INT;
  DECLARE numTotalEvaluaciones INT;
  DECLARE numTotalEvalResp INT;
  DECLARE numCantResp INT;
  DECLARE numCantRespBuenas INT;
  DECLARE dblTiempoTotEnMin DOUBLE;
  DECLARE str_codMySQL CHAR(5) DEFAULT '00000';
  DECLARE str_msgMySQL VARCHAR(100);
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      GET DIAGNOSTICS CONDITION 1
        str_codMySQL = RETURNED_SQLSTATE, str_msgMySQL = MESSAGE_TEXT;      

      SET out_codResp = '01';
      SET out_msjResp = str_msgMySQL;
    END;

    -- Obtiene contando todas las preguntas con alternativas, luego se cuentan las que tengan seleccionada 
  -- respuestas BUENO(A) o MUY BUENO(A) y se saca el porcentaje de satisfacción del total.
  SELECT count(*), sum(a.totEval) totEval, sum(a.totEvalResp) totEvalResp, sum(a.tiempoTotEnMin) / count(*) tiempoTotEnMin INTO numTotalEvaluados, numTotalEvaluaciones, numTotalEvalResp, dblTiempoTotEnMin
  FROM (
    SELECT idEDDEvaluacion, idEDDProyEmpEvaluado, count(*) totEval, sum(IF(evalRespondida = 1, 1, 0)) totEvalResp, round(sum(IF(evalRespondida = 1, timestampdiff(SECOND, fechaIni, fechaFin), 0)) / 60, 2) tiempoTotEnMin-- INTO numTotalEval, numTotalEvalResp, dblTiempoTotEnMin 
    FROM eddEvalProyEmp 
    WHERE idEDDEvaluacion = in_idEvaluacion AND isActive = 1
    GROUP BY idEDDEvaluacion, idEDDProyEmpEvaluado) a
  GROUP BY a.idEDDEvaluacion;

 

  -- Obtiene el total de respuestas tipo alternativa y tb, el total de respuestas tipo alternativa con respuestas BUENO y MUY BUENO. 
  SELECT sum(a.cantResp) cantResp, sum(a.respBuenas) respBuenas INTO numCantResp, numCantRespBuenas
  FROM (
    SELECT epe.idEDDEvaluacion, count(*) cantResp, sum(IF(erp.nomRespPreg IN('BUENA', 'BUENO', 'MUY BUENA', 'MUY BUENO'), 1, 0)) respBuenas
    FROM eddEvalProyEmp epe
      INNER JOIN eddEvalProyResp epr ON (epr.idEDDEvaluacion = in_idEvaluacion AND epr.idEDDEvalProyEmp = epe.idEDDEvalProyEmp AND epe.EvalRespondida = 1 AND epe.isActive = 1)  
      INNER JOIN eddEvalRespPreg erp ON (erp.idEDDEvalRespPreg = epr.idEDDEvalRespPreg AND epr.isActive = 1)
    GROUP BY epe.idEDDEvaluacion, epe.idEDDProyEmpEvaluado) a
  GROUP BY a.idEDDEvaluacion;

  SET out_porcSatisfaccion = round(numCantRespBuenas * 100 / numCantResp, 2);
  SET out_referentesEvaluados = concat(IF(numTotalEvaluados = 1, IF(numTotalEvaluaciones - numTotalEvalResp = 0, 1, 0), numTotalEvaluaciones), '/', numTotalEvaluados);
  SET out_tiempoPromedio = round(dblTiempoTotEnMin / numTotalEvalResp, 2);

  -- Obtiene la cantida de competencias a evaluar.
  SELECT count(*) INTO out_competenciasEvaluadas FROM
    (SELECT ec.nomCompetencia
      FROM eddEvalProyEmp epe
        INNER JOIN eddEvalProyResp epr ON (epr.idEDDEvaluacion = in_idEvaluacion AND epe.EvalRespondida = 1 AND epe.isActive = 1)
        INNER JOIN eddEvalPregunta ep ON (ep.idEDDEvalPregunta = epr.idEDDEvalPregunta AND epr.isActive = 1)
        INNER JOIN eddEvalCompetencia ec ON (ec.idEDDEvalCompetencia = ep.idEDDEvalCompetencia AND ep.isActive = 1)
      GROUP BY ec.nomCompetencia) a;

  -- Obtiene cantidad de evaluadores pertenecientes a Tsoft.
  SELECT count(*) INTO out_cantEvaluadoresTsoft 
  FROM eddEvalProyEmp epe
    INNER JOIN eddProyEmp pe ON (epe.idEDDEvaluacion = in_idEvaluacion AND epe.isActive = 1 AND pe.idEDDProyEmp = epe.idEDDProyEmpEvaluado)
    INNER JOIN empleado e ON (e.idEmpleado = pe.idEmpleado and pe.isActive = 1)
    INNER JOIN cliente cl ON (cl.idCliente = e.idCliente and e.isActive = 1)
  WHERE cl.nomCliente like '%TSOFT%' and cl.isActive = 1;

  SET out_codResp = '00';
  SET out_msjResp = 'Success';

 

  SELECT out_porcSatisfaccion, out_referentesEvaluados, out_competenciasEvaluadas, out_cantEvaluadoresTsoft, out_tiempoPromedio, out_codResp, out_msjResp;
END