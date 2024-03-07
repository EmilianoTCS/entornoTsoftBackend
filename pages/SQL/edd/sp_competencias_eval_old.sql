DELIMITER $$
CREATE PROCEDURE `SP_COMPETENCIAS_EVAL`(IN `in_idEvaluacion` INT, IN `IN_idProyecto` INT, OUT `out_codResp` CHAR(2), OUT `out_msjResp` VARCHAR(200))
BEGIN
  DECLARE str_codMySQL CHAR(5) DEFAULT '00000';
  DECLARE str_msgMySQL VARCHAR(100);
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      GET DIAGNOSTICS CONDITION 1
        str_codMySQL = RETURNED_SQLSTATE, str_msgMySQL = MESSAGE_TEXT;      

      SET out_codResp = '01';
      SET out_msjResp = str_msgMySQL;
    END;

    -- Obtiene las competencias incluidas en una encuesta, asociadas a cada evaluado y
  -- los porcentajes de satisfacción (BUENO / MUY BUENO) por evaluado para cada una de estas.
    
    SET out_codResp = '00';
  SET out_msjResp = 'Success'; 

 SELECT out_codResp, out_msjResp, UPPER(em1.nomEmpleado) nomEvaluador, UPPER(em2.nomEmpleado) nomEmpleado, a.nomCompetencia, a.cantPregComp, a.cantRespOK, a.porcAprobComp
  FROM (
      
    SELECT epe.idEDDProyEmpEvaluador, epe.idEDDProyEmpEvaluado, ec.nomCompetencia, count(*) cantPregComp, sum(IF(erp.nomRespPreg IN('BUENA', 'BUENO', 'MUY BUENA', 'MUY BUENO'), 1, 0)) cantRespOK, round(sum(IF(erp.nomRespPreg IN('BUENA', 'BUENO', 'MUY BUENA', 'MUY BUENO'), 1, 0)) * 100 / count(*), 2) porcAprobComp
    FROM eddproyemp pe
     inner join eddevalproyemp epe on (pe.idProyecto = IN_idProyecto and epe.idEDDProyEmpEvaluado = pe.idEDDProyEmp and pe.isActive = 1) 
      INNER JOIN eddEvalProyResp epr ON (epe.idEDDEvaluacion = in_idEvaluacion AND epe.evalRespondida = 1 AND epe.isActive = 1 AND epr.idEDDEvalProyEmp = epe.idEDDEvalProyEmp)  
      INNER JOIN eddEvalRespPreg erp ON (erp.idEDDEvalRespPreg = epr.idEDDEvalRespPreg AND epr.isActive = 1)
      INNER JOIN eddEvalPregunta ep ON (ep.idEDDEvalPregunta = erp.idEDDEvalPregunta and ep.isActive = 1)
      INNER JOIN eddEvalCompetencia ec ON (ec.idEDDEvalCompetencia = ep.idEDDEvalCompetencia and ec.isActive = 1)
    GROUP BY epe.idEDDProyEmpEvaluador, epe.idEDDProyEmpEvaluado, ec.nomCompetencia
    ORDER BY ec.nomCompetencia, epe.idEDDProyEmpEvaluador) a
    
    INNER JOIN eddProyEmp pe1 ON (pe1.idEDDProyEmp = a.idEDDProyEmpEvaluador)
    INNER JOIN eddProyEmp pe2 ON (pe2.idEDDProyEmp = a.idEDDProyEmpEvaluado)
    INNER JOIN empleado em1 ON (em1.idEmpleado = pe1.idEmpleado)
    INNER JOIN empleado em2 ON (em2.idEmpleado = pe2.idEmpleado);

END$$
DELIMITER ;