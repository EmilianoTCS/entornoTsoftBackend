DROP PROCEDURE IF EXISTS `SP_AUX_linksEvaluacionDashboard`;
DELIMITER $$
CREATE PROCEDURE `SP_AUX_linksEvaluacionDashboard`( IN `IN_idProyecto` INT, IN `IN_cargoEnProy` INT, OUT `OUT_CODRESULT` VARCHAR(3), OUT `OUT_MJERESULT` VARCHAR(100))
BEGIN    
  IF IN_idProyecto <= 0 THEN
      SET OUT_CODRESULT = '01';    
      SET OUT_MJERESULT = 'El ID de la proyecto debe ser mayor a cero.';    
      SELECT OUT_CODRESULT, OUT_MJERESULT;
  ELSEIF TRIM(IN_cargoEnProy) = "" THEN
      SET OUT_CODRESULT = '01';    
      SET OUT_MJERESULT = 'El cargo en proyecto no debe estar vacío.';    
      SELECT OUT_CODRESULT, OUT_MJERESULT;
    
  ELSE    
    SET OUT_CODRESULT = '00';
    SET OUT_MJERESULT = 'Success';

    SELECT OUT_CODRESULT, OUT_MJERESULT, epe.idEDDEvaluacion, UPPER(ev.nomEvaluacion) nomEvaluacion, pe.idProyecto, epe.cicloEvaluacion, UPPER(pe.cargoEnProy) cargoEnProy
    FROM eddevalproyemp epe 
    INNER JOIN eddproyemp pe ON (pe.idEDDProyEmp = epe.idEDDProyEmpEvaluado 
                                AND pe.idProyecto = IN_idProyecto 
                                AND UPPER(pe.cargoEnProy) = IN_cargoEnProy
                                AND pe.isActive = 1  
                                AND epe.isActive = 1)
    INNER JOIN eddevaluacion ev ON (ev.idEDDEvaluacion = epe.idEDDEvaluacion AND ev.isActive = 1)
    ;
  END IF;
END$$
DELIMITER ;

CALL SP_AUX_linksEvaluacionDashboard(7,'REFERENTE', @p0, @p1);