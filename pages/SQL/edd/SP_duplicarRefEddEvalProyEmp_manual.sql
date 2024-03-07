


DROP PROCEDURE IF EXISTS `SP_duplicarRefEddEvalProyEmp_manual`;
DELIMITER $$
CREATE PROCEDURE `SP_duplicarRefEddEvalProyEmp_manual`(
  IN `IN_idProyecto` INT,
  IN `IN_cargoEnProy` VARCHAR(40),
  OUT `out_codResp` CHAR(2), 
  OUT `out_msjResp` VARCHAR(200))
BEGIN
  DECLARE num_cantDiasIntervalo INT;
  DECLARE int_idEDDEvaluacion INT;
  DECLARE int_idEDDEvalProyEmp INT;
  DECLARE int_idEDDProyEmpEvaluador INT;  
  DECLARE int_idEDDProyEmpEvaluado INT;  
  DECLARE int_cicloEvaluacion INT;  
  DECLARE date_fechaIniVigenciaProyecto DATE;
  DECLARE int_nuevoCicloEvaluacion INT;
  DECLARE tinyint_vigenciaProyecto TINYINT;
  DECLARE int_idProyecto INT;
  DECLARE varchar_cargoEnProy VARCHAR(50);
  
  
  DECLARE done INT;
  DECLARE num_contadorResp INT;
  DECLARE num_auxIdEvaluado INT;
  DECLARE num_contReg INT DEFAULT 0;
  DECLARE str_codMySQL CHAR(5) DEFAULT '00000';
  DECLARE str_msgMySQL VARCHAR(100);
  
  DECLARE cur1 CURSOR FOR 
  SELECT 
  epe.idEDDEvalProyEmp, 
  epe.idEDDEvaluacion, 
  epe.idEDDProyEmpEvaluador, 
  epe.idEDDProyEmpEvaluado, 
  MAX(epe.cicloEvaluacion) cicloEvaluacion,
  p.fechaInicio fechaIniProyecto,
  p.idEDDProyecto idEDDProyecto,
  UPPER(ed.cargoEnProy) cargoEnProy,
  IF(p.fechaFin is not null,
      IF(DATE(p.fechaInicio) < CURRENT_DATE() AND CURRENT_DATE < DATE(p.fechaFin), 1, 0), -- fecha fin definida. Se verifica que la fecha actual esté entre el periodo establecido
      1 -- fecha fin indefinida, se considera como proyecto vigente
    ) AS vigenciaProyecto
  FROM eddevalproyemp epe 
  INNER JOIN eddproyemp ed ON (ed.idEDDProyEmp = epe.idEDDProyEmpEvaluador AND ed.isActive = 1)
  INNER JOIN eddproyecto p ON (p.idEDDProyecto = ed.idProyecto AND 
                               ed.idProyecto = IN_idProyecto AND 
                               UPPER(ed.cargoEnProy) = UPPER(IN_cargoEnProy) AND 
                               p.isActive = 1)
  WHERE epe.isActive = 1
  GROUP BY epe.idEDDEvaluacion, epe.idEDDProyEmpEvaluador, epe.idEDDProyEmpEvaluado;
  
    
  DECLARE CONTINUE HANDLER FOR NOT FOUND 
    BEGIN
      GET DIAGNOSTICS CONDITION 1
        str_codMySQL = RETURNED_SQLSTATE, str_msgMySQL = MESSAGE_TEXT;

      IF num_contReg <= 0 THEN
        SET done = 1;
        SET out_codResp = '02';
        SET out_msjResp = concat('SIN DATOS (', str_msgMySQL, ')');
        SELECT out_codResp, out_msjResp;

      ELSE
        SET done = 2;
      END IF;
    END;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      GET DIAGNOSTICS CONDITION 1
        str_codMySQL = RETURNED_SQLSTATE, str_msgMySQL = MESSAGE_TEXT;      

      SET out_codResp = '01';
      SET out_msjResp = str_msgMySQL;
        SELECT out_codResp, out_msjResp;

    END;

     -- DROP TABLE IF EXISTS tmpComentarios;
  CREATE TEMPORARY TABLE tmpCiclosEval (
    numCicloEval INT
  ) Engine=InnoDB;


 
  OPEN cur1;
  loop_duplicarRegistros:LOOP
    
    FETCH cur1 INTO int_idEDDEvalProyEmp, int_idEDDEvaluacion, int_idEDDProyEmpEvaluador, int_idEDDProyEmpEvaluado, int_cicloEvaluacion, date_fechaIniVigenciaProyecto, int_idProyecto, varchar_cargoEnProy, tinyint_vigenciaProyecto;
    
    -- Si no encuentra más registros, sale del loop.
    IF done = 1 OR done = 2 THEN
      LEAVE loop_duplicarRegistros;
    END IF;

    SET num_contReg = num_contReg + 1;  

    -- Obtiene el valor del nuevo ciclo
    SELECT FN_EXISTE_REGEDDEVALPROYEMP(int_idEDDEvaluacion, int_idEDDProyEmpEvaluador, int_idEDDProyEmpEvaluado) INTO int_nuevoCicloEvaluacion;

    
    -- Primero valida si el proyecto está vigente, consutla si el ciclo es 0, es decir, no se realizó ninguna evaluación, actualiza el valor a 1, si no continúa con otro ciclo.
    IF tinyint_vigenciaProyecto = 1 THEN -- Proyecto vigente?
        IF int_nuevoCicloEvaluacion < 1 THEN -- Ya se inició un ciclo?
      
          INSERT INTO tmpCiclosEval (numCicloEval) VALUES (int_nuevoCicloEvaluacion);

         -- CALL `SP_editarEddEvalProyEmp`(int_idEDDEvalProyEmp, int_idEDDEvaluacion, int_idEDDProyEmpEvaluador, int_idEDDProyEmpEvaluado, 1, 0, 1, 'admin_SYSTEM', @p0,@p1);

        ELSEIF int_nuevoCicloEvaluacion > 1 THEN

          INSERT INTO tmpCiclosEval (numCicloEval) VALUES (int_nuevoCicloEvaluacion);

         -- CALL `SP_insertarEddEvalProyEmp`(int_idEDDEvaluacion, int_idEDDProyEmpEvaluador, int_idEDDProyEmpEvaluado, int_nuevoCicloEvaluacion, 0, 1, 'admin_SYSTEM', @p0,@p1);

      END IF;
    END IF;




   
  END LOOP;

  CLOSE cur1;

  IF done = 2 THEN
    SET out_codResp = '00';
    SET out_msjResp = 'Success';
    SELECT *, out_codResp, out_msjResp from tmpCiclosEval;

    DROP TABLE IF EXISTS tmpCiclosEval;
  END IF;

END$$
DELIMITER ;


