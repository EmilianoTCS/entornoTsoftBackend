
DROP FUNCTION IF EXISTS `FN_EXISTE_REGEDDEVALPROYEMP`;
DELIMITER $$
CREATE FUNCTION `FN_EXISTE_REGEDDEVALPROYEMP`(`IN_idEDDEvaluacion` INT, `IN_idEDDProyEmpEvaluador` INT, `IN_idEDDProyEmpEvaluado` INT) RETURNS tinyint(4)
    DETERMINISTIC
BEGIN
  DECLARE temp_cicloEval TINYINT;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      RETURN False;
    END;
  	
    SELECT MAX(cicloEvaluacion) INTO temp_cicloEval from eddevalproyemp epe 
    WHERE epe.idEDDEvaluacion = IN_idEDDEvaluacion AND epe.idEDDProyEmpEvaluador = IN_idEDDProyEmpEvaluador AND epe.idEDDProyEmpEvaluado = IN_idEDDProyEmpEvaluado AND epe.isActive = 1;
	
    IF temp_cicloEval < 1 THEN
    	RETURN 	1;
    ELSE
    	RETURN temp_cicloEval + 1;
  	END IF;
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS `SP_duplicarRefEddEvalProyEmp`;
DELIMITER $$
CREATE PROCEDURE `SP_duplicarRefEddEvalProyEmp`(OUT `out_codResp` CHAR(2), OUT `out_msjResp` VARCHAR(200))
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
  INNER JOIN eddproyecto p ON (p.idEDDProyecto = ed.idProyecto AND p.isActive = 1)
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
    numCicloEval INT,
    idProyecto INT,
    cargoEnProy VARCHAR(50)
  ) Engine=InnoDB;



  -- Obtiene cantidad de dias de intervalo entre ciclos 
  SELECT datoNoVisible INTO num_cantDiasIntervalo 
  FROM confDatos WHERE tipoConfDato = 'EDD' AND subTipoConfDato = 'INTERVALO_EVALUACIONES' AND isActive = 1;

 
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

    

    -- Primero valida si el proyecto está vigente, si es así, verifica que hayan transcurrido 6 meses desde el anterior ciclo y por último si el ciclo es 0, es decir, no se realizó ninguna evaluación, actualiza el valor a 1, si no continúa con otro ciclo.
    IF tinyint_vigenciaProyecto = 1 THEN -- Proyecto vigente?
      IF DATE_ADD(DATE(date_fechaIniVigenciaProyecto), INTERVAL (num_cantDiasIntervalo * int_nuevoCicloEvaluacion) DAY) = CURDATE() THEN -- Pasaron 6 meses?
        IF int_nuevoCicloEvaluacion < 1 THEN -- Ya se inició un ciclo?
              
          INSERT INTO tmpCiclosEval (numCicloEval, idProyecto, cargoEnProy) VALUES (int_nuevoCicloEvaluacion, int_idProyecto, varchar_cargoEnProy);
          CALL `SP_editarEddEvalProyEmp`(int_idEDDEvalProyEmp, int_idEDDEvaluacion, int_idEDDProyEmpEvaluador, int_idEDDProyEmpEvaluado, 1, 0, 1, 'admin_SYSTEM', @p0,@p1);

        ELSEIF int_nuevoCicloEvaluacion > 1 THEN

          INSERT INTO tmpCiclosEval (numCicloEval, idProyecto, cargoEnProy) VALUES (int_nuevoCicloEvaluacion, int_idProyecto, varchar_cargoEnProy);
          CALL `SP_insertarEddEvalProyEmp`(int_idEDDEvaluacion, int_idEDDProyEmpEvaluador, int_idEDDProyEmpEvaluado, int_nuevoCicloEvaluacion, 0, 1, 'admin_SYSTEM', @p0,@p1);

        END IF;
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


