DROP FUNCTION IF EXISTS `FN_EXISTE_CODCURSO`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `FN_EXISTE_CODCURSO`(`IN_CODCURSO` VARCHAR(20)) RETURNS tinyint DETERMINISTIC
BEGIN
  DECLARE boo_existe TINYINT;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      RETURN False;
    END;
  
  SET boo_existe = False;
  IF IN_CODCURSO IS NULL OR IN_CODCURSO = '' THEN
    RETURN False;
  ELSE
    SELECT True INTO boo_existe FROM CURSO WHERE CODCURSO = IN_CODCURSO LIMIT 1;
  END IF;
  
  RETURN boo_existe;
END$$
DELIMITER ;

DROP FUNCTION IF EXISTS `FN_EXISTE_CODRAMO`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `FN_EXISTE_CODRAMO`(`IN_CODRAMO` VARCHAR(20)) RETURNS tinyint DETERMINISTIC
BEGIN
  DECLARE boo_existe TINYINT;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      RETURN False;
    END;
  
  SET boo_existe = False;
  IF IN_CODRAMO IS NULL OR IN_CODRAMO = '' THEN
    RETURN False;
  ELSE
    SELECT True INTO boo_existe FROM RAMO WHERE CODRAMO = IN_CODRAMO LIMIT 1;
  END IF;
  
  RETURN boo_existe;
END$$
DELIMITER ;

DROP FUNCTION IF EXISTS `FN_EXISTE_CORREOCONTACTO`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `FN_EXISTE_CORREOCONTACTO`(`IN_correoContacto` VARCHAR(100)) RETURNS tinyint DETERMINISTIC
BEGIN
  DECLARE boo_existe TINYINT;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      RETURN False;
    END;
  
  SET boo_existe = False;
  IF IN_correoContacto IS NULL OR IN_correoContacto = '' THEN
    RETURN False;
  ELSE
    SELECT True INTO boo_existe FROM contacto WHERE correoContacto = IN_correoContacto LIMIT 1;
  END IF;
  
  RETURN boo_existe;
END$$
DELIMITER ;

DROP FUNCTION IF EXISTS `FN_EXISTE_CORREOEMP`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `FN_EXISTE_CORREOEMP`(`IN_correoEmpleado` VARCHAR(100)) RETURNS TINYINT DETERMINISTIC
BEGIN
  DECLARE boo_existe TINYINT;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      RETURN False;
    END;
  
  SET boo_existe = False;
  IF IN_correoEmpleado IS NULL OR IN_correoEmpleado = '' THEN
    RETURN False;
  ELSE
    SELECT True INTO boo_existe FROM empleado WHERE correoEmpleado = IN_correoEmpleado LIMIT 1;
  END IF;
  
  RETURN boo_existe;
END$$
DELIMITER ;

DROP FUNCTION IF EXISTS `FN_EXISTE_CORREOLOGIN`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `FN_EXISTE_CORREOLOGIN`(`IN_correoEmpleado` VARCHAR(100)) RETURNS tinyint DETERMINISTIC
BEGIN
  DECLARE boo_existe TINYINT;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      RETURN False;
    END;
  
  SET boo_existe = False;
  IF IN_correoEmpleado IS NULL OR IN_correoEmpleado = '' THEN
    RETURN False;
  ELSE
    SELECT True INTO boo_existe FROM empleado WHERE correoEmpleado = IN_correoEmpleado LIMIT 1;
  END IF;
  
  RETURN boo_existe;
END$$
DELIMITER ;

DROP FUNCTION IF EXISTS `FN_EXISTE_EDDEvalProyEmp`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `FN_EXISTE_EDDEvalProyEmp`(`IN_idEDDEvaluacion` INT, `IN_idEDDProyEmpEvaluador` INT, `IN_idEDDProyEmpEvaluado` INT) 
RETURNS tinyint DETERMINISTIC
BEGIN
  DECLARE boo_existe TINYINT;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      RETURN False;
    END;
  
  SET boo_existe = False;
  IF IN_idEDDEvaluacion IS NULL OR TRIM(IN_idEDDEvaluacion) = '' THEN
  RETURN False;
  ELSEIF IN_idEDDProyEmpEvaluador IS NULL OR TRIM(IN_idEDDProyEmpEvaluador) = '' THEN
  RETURN False;
  ELSEIF IN_idEDDProyEmpEvaluado IS NULL OR TRIM(IN_idEDDProyEmpEvaluado) = '' THEN
    RETURN False;
  ELSE
    SELECT True INTO boo_existe FROM eddevalproyemp WHERE idEDDEvaluacion = IN_idEDDEvaluacion AND idEDDProyEmpEvaluador = IN_idEDDProyEmpEvaluador AND idEDDProyEmpEvaluado = IN_idEDDProyEmpEvaluado LIMIT 1;
  END IF;
  
  RETURN boo_existe;
END$$
DELIMITER ;

DROP FUNCTION IF EXISTS `FN_EXISTE_EDDProyEmp`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `FN_EXISTE_EDDProyEmp`(`IN_idProyecto` INT, `IN_idEmpleado` INT, `IN_cargoEnProy` VARCHAR(15)) 
RETURNS tinyint DETERMINISTIC
BEGIN
  DECLARE boo_existe TINYINT;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      RETURN False;
    END;
  
  SET boo_existe = False;
  IF IN_idProyecto IS NULL OR IN_idProyecto = '' THEN
  RETURN False;
  ELSEIF IN_idEmpleado IS NULL OR IN_idEmpleado = '' THEN
  RETURN False;
  ELSEIF IN_cargoEnProy IS NULL OR IN_cargoEnProy = '' THEN
    RETURN False;
  ELSE
    SELECT True INTO boo_existe FROM eddproyemp WHERE idProyecto = IN_idProyecto AND idEmpleado = IN_idEmpleado AND cargoEnProy = IN_cargoEnProy LIMIT 1;
  END IF;
  
  RETURN boo_existe;
END$$
DELIMITER ;

DROP FUNCTION IF EXISTS `FN_EXISTE_NOMCURSO`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `FN_EXISTE_NOMCURSO`(`IN_NOMCURSO` VARCHAR(50))
RETURNS tinyint DETERMINISTIC
BEGIN
  DECLARE boo_existe TINYINT;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      RETURN False;
    END;
  
  SET boo_existe = False;
  IF IN_NOMCURSO IS NULL OR IN_NOMCURSO = '' THEN
    RETURN False;
  ELSE
    SELECT True INTO boo_existe FROM CURSO WHERE NOMCURSO = IN_NOMCURSO LIMIT 1;
  END IF;
  
  RETURN boo_existe;
END$$
DELIMITER ;

DROP FUNCTION IF EXISTS `FN_EXISTE_NOMPROYECTO`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `FN_EXISTE_NOMPROYECTO`(`IN_nomProyecto` VARCHAR(20), `IN_idServicio` INT) 
RETURNS tinyint DETERMINISTIC
BEGIN
  DECLARE boo_existe TINYINT;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      RETURN False;
    END;
  
  SET boo_existe = False;
  IF IN_nomProyecto IS NULL OR IN_nomProyecto = '' OR IN_idServicio IS NULL OR IN_idServicio = '' THEN
    RETURN False;
  ELSE
    SELECT True INTO boo_existe FROM eddproyecto WHERE nomProyecto = IN_nomProyecto AND idServicio = IN_idServicio LIMIT 1;
  END IF;
  
  RETURN boo_existe;
END$$
DELIMITER ;

DROP FUNCTION IF EXISTS `FN_EXISTE_NOMRAMO`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `FN_EXISTE_NOMRAMO`(`IN_NOMRAMO` VARCHAR(50)) 
RETURNS tinyint DETERMINISTIC
BEGIN
  DECLARE boo_existe TINYINT;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      RETURN False;
    END;
  
  SET boo_existe = False;
  IF IN_NOMRAMO IS NULL OR IN_NOMRAMO = '' THEN
    RETURN False;
  ELSE
    SELECT True INTO boo_existe FROM RAMO WHERE NOMRAMO = IN_NOMRAMO LIMIT 1;
  END IF;
  
  RETURN boo_existe;
END$$
DELIMITER ;

DROP FUNCTION IF EXISTS `FN_EXISTE_NOMSESION`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `FN_EXISTE_NOMSESION`(`IN_NOMSESION` VARCHAR(50), `IN_idRamo` INT) 
RETURNS tinyint DETERMINISTIC
BEGIN
  DECLARE boo_existe TINYINT;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      RETURN False;
    END;
  
  SET boo_existe = False;
  IF IN_NOMSESION IS NULL OR IN_NOMSESION = '' THEN
    RETURN False;
  ELSE
    SELECT True INTO boo_existe FROM SESION WHERE NOMSESION = IN_NOMSESION AND idRamo = IN_idRamo LIMIT 1;
  END IF;
  
  RETURN boo_existe;
END$$
DELIMITER ;

DROP FUNCTION IF EXISTS `FN_EXISTE_NROSESION`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `FN_EXISTE_NROSESION`(`IN_NROSESION` INT, `IN_idRamo` INT) RETURNS tinyint DETERMINISTIC
BEGIN
  DECLARE boo_existe TINYINT;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      RETURN False;
    END;
  
  SET boo_existe = False;
  IF IN_NROSESION IS NULL OR IN_NROSESION <= 0 THEN
    RETURN False;
  ELSE
    SELECT True INTO boo_existe FROM SESION WHERE NROSESION = IN_NROSESION AND idRamo = IN_idRamo LIMIT 1;
  END IF;
  
  RETURN boo_existe;
END$$
DELIMITER ;

DROP FUNCTION IF EXISTS `FN_EXISTE_REQCURSO`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `FN_EXISTE_REQCURSO`(`IN_idReqCurso` INT, `IN_idCurso` INT) 
RETURNS tinyint DETERMINISTIC
BEGIN
  DECLARE boo_existe TINYINT;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      RETURN False;
    END;
  
  SET boo_existe = False;
  IF IN_idReqCurso IS NULL OR IN_idCurso IS NULL OR IN_idCurso = '' OR IN_idReqCurso = '' THEN
    RETURN False;
  ELSE
    SELECT True INTO boo_existe FROM reqcurso WHERE idCurso = IN_idCurso AND idCursoRequisito = IN_idReqCurso LIMIT 1;
  END IF;
  
  RETURN boo_existe;
END$$
DELIMITER ;

DROP FUNCTION IF EXISTS `FN_EXISTE_USUARIOLOGIN`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `FN_EXISTE_USUARIOLOGIN`(`IN_usuario` VARCHAR(20))
RETURNS tinyint DETERMINISTIC
BEGIN
  DECLARE boo_existe TINYINT;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      RETURN False;
    END;
  
  SET boo_existe = False;
  IF IN_usuario IS NULL OR IN_usuario = '' THEN
    RETURN False;
  ELSE
    SELECT True INTO boo_existe FROM loginusuario WHERE usuario = IN_usuario LIMIT 1;
  END IF;
  
  RETURN boo_existe;
END$$
DELIMITER ;

DROP FUNCTION IF EXISTS `FN_REQCURSO_APROBADOS`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `FN_REQCURSO_APROBADOS`(`IN_IDCURSO` INT, `IN_IDEMPLEADO` INT)
 RETURNS tinyint DETERMINISTIC
BEGIN
  DECLARE done INT DEFAULT 0;
  DECLARE num_cantCursoReq INT;
  DECLARE num_idCursoReq INT;
  DECLARE boo_cursoAprobado TINYINT DEFAULT 0;
  DECLARE boo_existeCurso TINYINT;
  DECLARE boo_existeEmp TINYINT;
  DECLARE boo_reqCursosOK TINYINT DEFAULT 0;
  DECLARE str_codMySQL CHAR(5) DEFAULT '00000';
  DECLARE str_msgMySQL VARCHAR(100);
  -- Query que trae todos los cursos-requisitos para el ID del curso recibido. Loop.
  DECLARE cur1 CURSOR FOR SELECT idCursoRequisito FROM reqCurso WHERE idCurso = IN_IDCURSO AND isActive = 1;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      GET DIAGNOSTICS CONDITION 1
        str_codMySQL = RETURNED_SQLSTATE, str_msgMySQL = MESSAGE_TEXT;      
      RETURN 0;
    END;
    
  SELECT 1 INTO boo_existeCurso FROM curso WHERE idCurso = IN_IDCURSO AND isActive = 1;
  IF boo_existeCurso = 1 THEN  -- Si existe el curso activo para el ID recibido, continúa. Si no, retorna 0 (falso).
    SELECT 1 INTO boo_existeEmp FROM empleado WHERE idEmpleado = IN_IDEMPLEADO AND isActive = 1;
    IF boo_existeEmp = 1 THEN  -- Si existe el empleado activo para el ID recibido, continúa. Si no, retorna 0 (falso).
      BEGIN
        DECLARE CONTINUE HANDLER FOR NOT FOUND RETURN 1;  -- Si no encuentra registros de cursos-requisito, devuelve 1 (OK). 
        SELECT count(*) INTO num_cantCursoReq FROM reqCurso WHERE idCurso = IN_IDCURSO AND isActive = 1;       
      END;
      
      IF num_cantCursoReq > 0 THEN
        SET done = 0;
            
        OPEN cur1;
        loop_reqCurso: LOOP
          SET num_idCursoReq = 0;  -- Inicializa variable en cada iteración.
          FETCH cur1 INTO num_idCursoReq;
          -- Si no encuentra más registros, sale del loop.
          IF done = 1 THEN
            SET boo_reqCursosOK = boo_cursoAprobado;  -- Asigna resultado de búsqueda, pudiendo ser 1: Todos los cursos-requisitos OK / 0: NOK.
            LEAVE loop_reqCurso;
          END IF;
          
          BEGIN
            DECLARE CONTINUE HANDLER FOR NOT FOUND
              BEGIN
                SET done = 2;
              END;
            -- Verifica que el curso requisito actual esté aprobado por el alumno (empleado). Si aprobado, devuelve 1. Si no existe registro, done = 2.
            SELECT IF(estadoCurso = 'APROBADO', 1, 0) INTO boo_cursoAprobado FROM cursoAlumno WHERE idCurso = num_idCursoReq AND idEmpleado = IN_IDEMPLEADO AND isActive = 1;
          END;
          
          -- Si el curso-requisito no está aprobado o no encontró registro, sale del loop indicando que no están cursados todos los cursos-requisito.
          IF boo_cursoAprobado = 0 OR done = 2 THEN
            SET boo_reqCursosOK = 0;
            LEAVE loop_reqCurso;
          END IF;
            
        END LOOP;
        CLOSE cur1;
      ELSE
        SET boo_reqCursosOK = 1;
      END IF;
    END IF;
  END IF;

  -- 1: Todos los cursos requisito aprobados / 0: Al menos 1 curso no aprobabo o no cursado o en curso.
  IF boo_reqCursosOK = 1 THEN
    RETURN 1; 
  ELSE
    RETURN 0;
  END IF;  
END$$
DELIMITER ;

DROP FUNCTION IF EXISTS `FN_tiempoPromedio`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `FN_tiempoPromedio`(`IN_fechaIni` DATETIME, `IN_fechaFin` DATETIME) 
RETURNS varchar(10) DETERMINISTIC
BEGIN
  DECLARE tiempoPromedio VARCHAR(10);
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      RETURN False;
    END;
   SELECT concat(
       lpad(truncate(round((timestampdiff(SECOND, IN_fechaIni, IN_fechaFin) / 60), 2), 0),2, 0)

        , ':',

        lpad(round((round(
        timestampdiff(SECOND, IN_fechaIni, IN_fechaFin) / 60
        , 2) - 
        truncate(round(
        (timestampdiff(SECOND, IN_fechaIni, IN_fechaFin) / 60),
        2),
        0)) * 60, 0),2, 0)
        ) INTO tiempoPromedio;

  RETURN tiempoPromedio;
END$$
DELIMITER ;

DROP FUNCTION IF EXISTS `FN_validarFechaCorreo`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `FN_validarFechaCorreo`(`IN_idProyecto` INT, `IN_idEDDProyEmpEvaluador` INT, `IN_cargoEnProy` VARCHAR(30)) 
RETURNS tinyint DETERMINISTIC
BEGIN
  DECLARE boo_existe TINYINT;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      RETURN False;
    END;
  
  SET boo_existe = False;
  IF IN_idProyecto  <= 0 THEN
    RETURN False;
  ELSEIF TRIM(IN_cargoEnProy) = "" THEN
  	RETURN False;
  ELSE
        IF TRIM(UPPER(IN_cargoEnProy)) IN ('REFERENTE', 'REFERENTES') THEN
            SELECT IF(epe.fechaIniVigenciaEvalRef < now() AND now() < DATE(DATE_ADD(epe.fechaIniVigenciaEvalRef, INTERVAL epe.diasVigenciaEvalRef DAY)), TRUE, FALSE) INTO boo_existe FROM eddevalproyemp epe
            INNER JOIN eddproyemp ep ON (ep.idEDDProyEmp = epe.idEDDProyEmpEvaluador 
                                         AND epe.idEDDProyEmpEvaluador = IN_idEDDProyEmpEvaluador
                                         AND ep.idProyecto = IN_idProyecto 
                                         AND ep.cargoEnProy = IN_cargoEnProy)
            LIMIT 1;
            
        ELSEIF TRIM(UPPER(IN_cargoEnProy)) IN ('COLABORADOR', 'COLABORADORES') THEN
            SELECT IF(epe.fechaIniVigenciaEvalColab < now() AND now() < DATE(DATE_ADD(epe.fechaIniVigenciaEvalColab, INTERVAL epe.diasVigenciaEvalRefColab DAY)), TRUE, FALSE) INTO boo_existe FROM eddevalproyemp epe
            INNER JOIN eddproyemp ep ON (ep.idEDDProyEmp = epe.idEDDProyEmpEvaluador 
                                     AND epe.idEDDProyEmpEvaluador = IN_idEDDProyEmpEvaluador
                                     AND ep.idProyecto = IN_idProyecto 
                                     AND ep.cargoEnProy = IN_cargoEnProy)
            LIMIT 1;

         END IF; 
  END IF;
  
  RETURN boo_existe;
END$$
DELIMITER ;

DROP FUNCTION IF EXISTS `FN_validarMultiIDS`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `FN_validarMultiIDS`(`IN_IDS` VARCHAR(30)) 
RETURNS tinyint DETERMINISTIC
BEGIN
  DECLARE boo_existe TINYINT;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      RETURN False;
    END;
  
  SET boo_existe = False;

    SELECT IN_IDS REGEXP "^[0-9\,]" INTO boo_existe
            LIMIT 1;
  
  RETURN boo_existe;
END$$
DELIMITER ;
