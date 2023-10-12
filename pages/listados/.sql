DROP PROCEDURE IF EXISTS `SP_COMPETENCIAS_GENERAL_EVAL`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_COMPETENCIAS_GENERAL_EVAL`(IN `IN_idCliente` VARCHAR(30), IN `IN_idServicio` VARCHAR(30), IN `IN_idProyecto` VARCHAR(30), IN `IN_tipoComparacion` VARCHAR(30), IN `IN_tipoCargo` VARCHAR(30), IN `IN_fechaIni` DATETIME, IN `IN_fechaFin` DATETIME, OUT `out_codResp` CHAR(2), OUT `out_msjResp` VARCHAR(200))
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

        IF FN_validarMultiIDS(IN_idCliente) = 0 THEN 
            SET out_codResp = '02';
            SET out_msjResp = 'El/los id los clientes son inválidos';
            SELECT out_codResp, out_msjResp;
        ELSEIF FN_validarMultiIDS(IN_idServicio) = 0 THEN
            SET out_codResp = '03';
            SET out_msjResp = 'El/los id del servicio son inválidos';
            SELECT out_codResp, out_msjResp;
        ELSEIF FN_validarMultiIDS(IN_idProyecto) = 0 THEN
            SET out_codResp = '03';
            SET out_msjResp = 'El/los id del proyecto son inválidos';
            SELECT out_codResp, out_msjResp;
        ELSEIF TRIM(UPPER(IN_tipoComparacion)) NOT IN ('GENERAL','MES', 'AÑO') THEN
            SET out_codResp = '04';
            SET out_msjResp = 'El IN_tipoComparacion debe ser "GENERAL" o "MES".';
            SELECT out_codResp, out_msjResp;
        ELSEIF TRIM(UPPER(IN_tipoCargo)) NOT IN ('REFERENTE','COLABORADOR', 'TODOS') THEN
            SET out_codResp = '05';
            SET out_msjResp = 'El IN_tipoCargo debe ser "REFERENTE","COLABORADOR" O "TODOS"(sin filtro).';
            SELECT out_codResp, out_msjResp;    

        ELSE    

    -- Obtiene las competencias incluidas en una encuesta, asociadas a cada evaluado y
    -- los porcentajes de satisfacción (BUENO / MUY BUENO) por evaluado para cada una de estas.

        IF TRIM(UPPER(IN_tipoComparacion)) = 'GENERAL' AND TRIM(UPPER(IN_tipoCargo)) = 'TODOS' THEN

            SET out_codResp = '00';
            SET out_msjResp = 'Success'; 

            SELECT out_codResp, out_msjResp,a.idCliente, a.nomCliente, a.idServicio, a.nomServicio, a.idProyecto, a.nomProyecto, a.epeFechaIni, a.epeFechaFin,
            SUM(IF(UPPER(pe2.cargoEnProy) IN ('REFERENTE','REFERENTES'), 1,0 )) cantReferentes,
            SUM(IF(UPPER(pe2.cargoEnProy) IN ('COLABORADOR','COLABORADORES'), 1,0 )) cantColaboradores,
            round((a.cantRespRefOK * 100) /a.cantRespOK, 2) porcAprobRef,
            round((a.cantRespColabOK * 100) /a.cantRespOK, 2) porcAprobColab,
            a.cantRespRefOK, a.cantRespColabOK,
            a.cantPregComp, a.cantRespOK, a.porcAprobComp
            FROM (
                SELECT
                cli.idCliente,
                UPPER(cli.nomCliente) nomCliente,
                ser.idServicio,
                UPPER(ser.nomServicio) nomServicio,
                pe.idProyecto,
                UPPER(proy.nomProyecto) nomProyecto,
                DATE_FORMAT(epe.fechaIni, "%d/%m/%Y %H:%i:%s") as epeFechaIni, 
                DATE_FORMAT(epe.fechaFin, "%d/%m/%Y %H:%i:%s") as epeFechaFin,
                count(*) cantPregComp,
                sum(IF(erp.nomRespPreg IN('BUENA', 'BUENO', 'MUY BUENA', 'MUY BUENO'), 1, 0)) cantRespOK,
                sum(IF(pe.cargoEnProy = 'REFERENTE' AND erp.nomRespPreg IN('BUENA', 'BUENO', 'MUY BUENA', 'MUY BUENO'), 1, 0)) cantRespRefOK,
                sum(IF(pe.cargoEnProy = 'COLABORADOR' AND erp.nomRespPreg IN('BUENA', 'BUENO', 'MUY BUENA', 'MUY BUENO'), 1, 0)) cantRespColabOK,
                round(sum(IF(erp.nomRespPreg IN('BUENA', 'BUENO', 'MUY BUENA', 'MUY BUENO'), 1, 0)) * 100 / count(*), 2) porcAprobComp
                FROM eddproyemp pe
                INNER JOIN cliente cli ON (FIND_IN_SET (cli.idCliente , IN_idCliente) AND cli.isActive = 1)
                INNER JOIN servicio ser ON (FIND_IN_SET (ser.idServicio , IN_idServicio) AND ser.idCliente = cli.idCliente AND ser.isActive = 1)
                INNER JOIN eddproyecto proy ON (FIND_IN_SET (proy.idEDDProyecto , IN_idProyecto) AND proy.idServicio = ser.idServicio AND proy.isActive = 1)
                INNER JOIN eddevalproyemp epe ON (pe.idProyecto = proy.idEDDProyecto AND epe.idEDDProyEmpEvaluado = pe.idEDDProyEmp AND pe.isActive = 1)
                INNER JOIN eddEvalProyResp epr ON (epr.idEDDEvaluacion = epe.idEDDEvaluacion AND epe.evalRespondida = 1 AND epe.isActive = 1)  
                INNER JOIN eddEvalRespPreg erp ON (erp.idEDDEvalRespPreg = epr.idEDDEvalRespPreg AND epr.isActive = 1)

                WHERE epe.fechaIni BETWEEN IN_fechaIni AND IN_fechaFin
                GROUP BY  cli.nomCliente, ser.nomServicio, pe.idProyecto
                ORDER BY cli.nomCliente, ser.nomServicio, pe.idProyecto ) a
            INNER JOIN eddProyEmp pe2 ON (pe2.idProyecto = a.idProyecto)
            GROUP BY a.nomCliente, a.nomServicio, a.idProyecto;


        ELSEIF TRIM(UPPER(IN_tipoComparacion)) = 'MES' AND TRIM(UPPER(IN_tipoCargo)) = 'TODOS' THEN

            SET out_codResp = '00';
            SET out_msjResp = 'Success'; 

            SELECT out_codResp, out_msjResp,a.idCliente, a.nomCliente, a.idServicio, a.nomServicio, a.idProyecto, a.nomProyecto, a.epeFechaIni, a.epeFechaFin,
            SUM(IF(UPPER(pe2.cargoEnProy) IN ('REFERENTE','REFERENTES'), 1,0 )) cantReferentes,
            SUM(IF(UPPER(pe2.cargoEnProy) IN ('COLABORADOR','COLABORADORES'), 1,0 )) cantColaboradores,
            round((a.cantRespRefOK * 100) /a.cantRespOK, 2) porcAprobRef,
            round((a.cantRespColabOK * 100) /a.cantRespOK, 2) porcAprobColab,
            a.cantRespRefOK, a.cantRespColabOK,
            a.cantPregComp, a.cantRespOK, a.porcAprobComp
            FROM (
                SELECT
                cli.idCliente,
                UPPER(cli.nomCliente) nomCliente,
                ser.idServicio,
                UPPER(ser.nomServicio) nomServicio,
                pe.idProyecto,
                UPPER(proy.nomProyecto) nomProyecto,
                DATE_FORMAT(epe.fechaIni, "%d/%m/%Y %H:%i:%s") as epeFechaIni, 
                DATE_FORMAT(epe.fechaFin, "%d/%m/%Y %H:%i:%s") as epeFechaFin,
                count(*) cantPregComp,
                sum(IF(erp.nomRespPreg IN('BUENA', 'BUENO', 'MUY BUENA', 'MUY BUENO'), 1, 0)) cantRespOK,
                sum(IF(pe.cargoEnProy = 'REFERENTE' AND erp.nomRespPreg IN('BUENA', 'BUENO', 'MUY BUENA', 'MUY BUENO'), 1, 0)) cantRespRefOK,
                sum(IF(pe.cargoEnProy = 'COLABORADOR' AND erp.nomRespPreg IN('BUENA', 'BUENO', 'MUY BUENA', 'MUY BUENO'), 1, 0)) cantRespColabOK,
                round(sum(IF(erp.nomRespPreg IN('BUENA', 'BUENO', 'MUY BUENA', 'MUY BUENO'), 1, 0)) * 100 / count(*), 2) porcAprobComp
                FROM eddproyemp pe
                INNER JOIN cliente cli ON (FIND_IN_SET (cli.idCliente , IN_idCliente) AND cli.isActive = 1)
                INNER JOIN servicio ser ON (FIND_IN_SET (ser.idServicio , IN_idServicio) AND ser.idCliente = cli.idCliente AND ser.isActive = 1)
                INNER JOIN eddproyecto proy ON (FIND_IN_SET (proy.idEDDProyecto , IN_idProyecto) AND proy.idServicio = ser.idServicio AND proy.isActive = 1)
                INNER JOIN eddevalproyemp epe ON (pe.idProyecto = proy.idEDDProyecto  AND epe.idEDDProyEmpEvaluado = pe.idEDDProyEmp AND pe.isActive = 1)
                INNER JOIN eddEvalProyResp epr ON (epr.idEDDEvaluacion = epe.idEDDEvaluacion AND epe.evalRespondida = 1 AND epe.isActive = 1)  
                INNER JOIN eddEvalRespPreg erp ON (erp.idEDDEvalRespPreg = epr.idEDDEvalRespPreg AND epr.isActive = 1)

                WHERE epe.fechaIni BETWEEN IN_fechaIni AND IN_fechaFin
                GROUP BY cli.nomCliente, ser.nomServicio, pe.idServicio, YEAR(epe.fechaIni)*100 + MONTH(epe.fechaIni)
                ORDER BY cli.nomCliente,ser.nomServicio, pe.idServicio) a
            INNER JOIN eddProyEmp pe2 ON (pe2.idProyecto = a.idProyecto)
            GROUP BY a.nomCliente, a.nomServicio, a.idProyecto;


        ELSEIF TRIM(UPPER(IN_tipoComparacion)) = 'AÑO' AND TRIM(UPPER(IN_tipoCargo)) = 'TODOS' THEN

            SET out_codResp = '00';
            SET out_msjResp = 'Success'; 

            SELECT out_codResp, out_msjResp,a.idCliente, a.nomCliente, a.idServicio, a.nomServicio, a.idProyecto, a.nomProyecto, a.epeFechaIni, a.epeFechaFin,
            SUM(IF(UPPER(pe2.cargoEnProy) IN ('REFERENTE','REFERENTES'), 1,0 )) cantReferentes,
            SUM(IF(UPPER(pe2.cargoEnProy) IN ('COLABORADOR','COLABORADORES'), 1,0 )) cantColaboradores,
            round((a.cantRespRefOK * 100) /a.cantRespOK, 2) porcAprobRef,
            round((a.cantRespColabOK * 100) /a.cantRespOK, 2) porcAprobColab,
            a.cantRespRefOK, a.cantRespColabOK,
            a.cantPregComp, a.cantRespOK, a.porcAprobComp
            FROM (
                SELECT
                cli.idCliente,
                UPPER(cli.nomCliente) nomCliente,
                ser.idServicio,
                UPPER(ser.nomServicio) nomServicio,
                pe.idProyecto,
                UPPER(proy.nomProyecto) nomProyecto,
                DATE_FORMAT(epe.fechaIni, "%d/%m/%Y %H:%i:%s") as epeFechaIni, 
                DATE_FORMAT(epe.fechaFin, "%d/%m/%Y %H:%i:%s") as epeFechaFin,
                count(*) cantPregComp,
                sum(IF(erp.nomRespPreg IN('BUENA', 'BUENO', 'MUY BUENA', 'MUY BUENO'), 1, 0)) cantRespOK,
                sum(IF(pe.cargoEnProy = 'REFERENTE' AND erp.nomRespPreg IN('BUENA', 'BUENO', 'MUY BUENA', 'MUY BUENO'), 1, 0)) cantRespRefOK,
                sum(IF(pe.cargoEnProy = 'COLABORADOR' AND erp.nomRespPreg IN('BUENA', 'BUENO', 'MUY BUENA', 'MUY BUENO'), 1, 0)) cantRespColabOK,
                round(sum(IF(erp.nomRespPreg IN('BUENA', 'BUENO', 'MUY BUENA', 'MUY BUENO'), 1, 0)) * 100 / count(*), 2) porcAprobComp
                FROM eddproyemp pe
                INNER JOIN cliente cli ON (FIND_IN_SET (cli.idCliente , IN_idCliente) AND cli.isActive = 1)
                INNER JOIN servicio ser ON (FIND_IN_SET (ser.idServicio , IN_idServicio) AND ser.idCliente = cli.idCliente AND ser.isActive = 1)
                INNER JOIN eddproyecto proy ON (FIND_IN_SET (proy.idEDDProyecto , IN_idProyecto) AND proy.idServicio = ser.idServicio AND proy.isActive = 1)
                INNER JOIN eddevalproyemp epe ON (pe.idProyecto = proy.idEDDProyecto  AND epe.idEDDProyEmpEvaluado = pe.idEDDProyEmp AND pe.isActive = 1)
                INNER JOIN eddEvalProyResp epr ON (epr.idEDDEvaluacion = epe.idEDDEvaluacion AND epe.evalRespondida = 1 AND epe.isActive = 1)  
                INNER JOIN eddEvalRespPreg erp ON (erp.idEDDEvalRespPreg = epr.idEDDEvalRespPreg AND epr.isActive = 1)

                WHERE epe.fechaIni BETWEEN IN_fechaIni AND IN_fechaFin
                GROUP BY cli.nomCliente,ser.nomServicio,pe.idServicio, YEAR(epe.fechaIni)
                ORDER BY cli.nomCliente,ser.nomServicio, pe.idServicio) a
            INNER JOIN eddProyEmp pe2 ON (pe2.idProyecto = a.idProyecto)
            GROUP BY a.nomCliente, a.nomServicio, a.idProyecto;

        ELSEIF TRIM(UPPER(IN_tipoComparacion)) = 'GENERAL' AND TRIM(UPPER(IN_tipoCargo)) = 'REFERENTE' THEN

            SET out_codResp = '00';
            SET out_msjResp = 'Success'; 

            SELECT out_codResp, out_msjResp,a.idCliente, a.nomCliente, a.idServicio, a.nomServicio, a.idProyecto, a.nomProyecto, a.epeFechaIni, a.epeFechaFin,
            SUM(IF(UPPER(pe2.cargoEnProy) IN ('REFERENTE','REFERENTES'), 1,0 )) cantReferentes,
            SUM(IF(UPPER(pe2.cargoEnProy) IN ('COLABORADOR','COLABORADORES'), 1,0 )) cantColaboradores,
            round((a.cantRespRefOK * 100) /a.cantRespOK, 2) porcAprobRef,
            round((a.cantRespColabOK * 100) /a.cantRespOK, 2) porcAprobColab,
            a.cantRespRefOK, a.cantRespColabOK,
            a.cantPregComp, a.cantRespOK, a.porcAprobComp
            FROM (
                SELECT
                cli.idCliente,
                UPPER(cli.nomCliente) nomCliente,
                ser.idServicio,
                UPPER(ser.nomServicio) nomServicio,
                pe.idProyecto,
                UPPER(proy.nomProyecto) nomProyecto,
                DATE_FORMAT(epe.fechaIni, "%d/%m/%Y %H:%i:%s") as epeFechaIni, 
                DATE_FORMAT(epe.fechaFin, "%d/%m/%Y %H:%i:%s") as epeFechaFin,
                count(*) cantPregComp,
                sum(IF(erp.nomRespPreg IN('BUENA', 'BUENO', 'MUY BUENA', 'MUY BUENO'), 1, 0)) cantRespOK,
                sum(IF(pe.cargoEnProy = 'REFERENTE' AND erp.nomRespPreg IN('BUENA', 'BUENO', 'MUY BUENA', 'MUY BUENO'), 1, 0)) cantRespRefOK,
                sum(IF(pe.cargoEnProy = 'COLABORADOR' AND erp.nomRespPreg IN('BUENA', 'BUENO', 'MUY BUENA', 'MUY BUENO'), 1, 0)) cantRespColabOK,
                round(sum(IF(erp.nomRespPreg IN('BUENA', 'BUENO', 'MUY BUENA', 'MUY BUENO'), 1, 0)) * 100 / count(*), 2) porcAprobComp
                FROM eddproyemp pe
                INNER JOIN cliente cli ON (FIND_IN_SET (cli.idCliente , IN_idCliente) AND cli.isActive = 1)
                INNER JOIN servicio ser ON (FIND_IN_SET (ser.idServicio , IN_idServicio) AND ser.idCliente = cli.idCliente AND ser.isActive = 1)
                INNER JOIN eddproyecto proy ON (FIND_IN_SET (proy.idEDDProyecto , IN_idProyecto) AND proy.idServicio = ser.idServicio AND proy.isActive = 1)
                INNER JOIN eddevalproyemp epe ON (pe.idProyecto = proy.idEDDProyecto  AND epe.idEDDProyEmpEvaluado = pe.idEDDProyEmp AND pe.isActive = 1)
                INNER JOIN eddEvalProyResp epr ON (epr.idEDDEvaluacion = epe.idEDDEvaluacion AND epe.evalRespondida = 1 AND epe.isActive = 1)  
                INNER JOIN eddEvalRespPreg erp ON (erp.idEDDEvalRespPreg = epr.idEDDEvalRespPreg AND epr.isActive = 1)

                WHERE pe.cargoEnProy IN ('REFERENTE') AND epe.fechaIni BETWEEN IN_fechaIni AND IN_fechaFin
                GROUP BY cli.nomCliente,ser.nomServicio, pe.idServicio
                ORDER BY cli.nomCliente,ser.nomServicio, pe.idServicio) a
            INNER JOIN eddProyEmp pe2 ON (pe2.idProyecto = a.idProyecto)
            GROUP BY a.nomCliente, a.nomServicio, a.idProyecto;       

        ELSEIF TRIM(UPPER(IN_tipoComparacion)) = 'MES' AND TRIM(UPPER(IN_tipoCargo)) = 'REFERENTE' THEN

            SET out_codResp = '00';
            SET out_msjResp = 'Success'; 

            SELECT out_codResp, out_msjResp,a.idCliente, a.nomCliente, a.idServicio, a.nomServicio, a.idProyecto, a.nomProyecto, a.epeFechaIni, a.epeFechaFin,
            SUM(IF(UPPER(pe2.cargoEnProy) IN ('REFERENTE','REFERENTES'), 1,0 )) cantReferentes,
            SUM(IF(UPPER(pe2.cargoEnProy) IN ('COLABORADOR','COLABORADORES'), 1,0 )) cantColaboradores,
            round((a.cantRespRefOK * 100) /a.cantRespOK, 2) porcAprobRef,
            round((a.cantRespColabOK * 100) /a.cantRespOK, 2) porcAprobColab,
            a.cantRespRefOK, a.cantRespColabOK,
            a.cantPregComp, a.cantRespOK, a.porcAprobComp
            FROM (
                SELECT
                cli.idCliente,
                UPPER(cli.nomCliente) nomCliente,
                ser.idServicio,
                UPPER(ser.nomServicio) nomServicio,
                pe.idProyecto,
                UPPER(proy.nomProyecto) nomProyecto,
                DATE_FORMAT(epe.fechaIni, "%d/%m/%Y %H:%i:%s") as epeFechaIni, 
                DATE_FORMAT(epe.fechaFin, "%d/%m/%Y %H:%i:%s") as epeFechaFin,
                count(*) cantPregComp,
                sum(IF(erp.nomRespPreg IN('BUENA', 'BUENO', 'MUY BUENA', 'MUY BUENO'), 1, 0)) cantRespOK,
                sum(IF(pe.cargoEnProy = 'REFERENTE' AND erp.nomRespPreg IN('BUENA', 'BUENO', 'MUY BUENA', 'MUY BUENO'), 1, 0)) cantRespRefOK,
                sum(IF(pe.cargoEnProy = 'COLABORADOR' AND erp.nomRespPreg IN('BUENA', 'BUENO', 'MUY BUENA', 'MUY BUENO'), 1, 0)) cantRespColabOK,
                round(sum(IF(erp.nomRespPreg IN('BUENA', 'BUENO', 'MUY BUENA', 'MUY BUENO'), 1, 0)) * 100 / count(*), 2) porcAprobComp
                FROM eddproyemp pe
                INNER JOIN cliente cli ON (FIND_IN_SET (cli.idCliente , IN_idCliente) AND cli.isActive = 1)
                INNER JOIN servicio ser ON (FIND_IN_SET (ser.idServicio , IN_idServicio) AND ser.idCliente = cli.idCliente AND ser.isActive = 1)
                INNER JOIN eddproyecto proy ON (FIND_IN_SET (proy.idEDDProyecto , IN_idProyecto) AND proy.idServicio = ser.idServicio AND proy.isActive = 1)
                INNER JOIN eddevalproyemp epe ON (pe.idProyecto = proy.idEDDProyecto  AND epe.idEDDProyEmpEvaluado = pe.idEDDProyEmp AND pe.isActive = 1)
                INNER JOIN eddEvalProyResp epr ON (epr.idEDDEvaluacion = epe.idEDDEvaluacion AND epe.evalRespondida = 1 AND epe.isActive = 1)  
                INNER JOIN eddEvalRespPreg erp ON (erp.idEDDEvalRespPreg = epr.idEDDEvalRespPreg AND epr.isActive = 1)

                WHERE pe.cargoEnProy IN ('REFERENTE') AND epe.fechaIni BETWEEN IN_fechaIni AND IN_fechaFin
                GROUP BY cli.nomCliente,ser.nomServicio, pe.idServicio, YEAR(epe.fechaIni)*100 + MONTH(epe.fechaIni)
                ORDER BY cli.nomCliente,ser.nomServicio, pe.idServicio) a 
            INNER JOIN eddProyEmp pe2 ON (pe2.idProyecto = a.idProyecto)
            GROUP BY a.nomCliente, a.nomServicio, a.idProyecto;  


        ELSEIF TRIM(UPPER(IN_tipoComparacion)) = 'AÑO' AND TRIM(UPPER(IN_tipoCargo)) = 'REFERENTE' THEN

            SET out_codResp = '00';
            SET out_msjResp = 'Success'; 

            SELECT out_codResp, out_msjResp,a.idCliente, a.nomCliente, a.idServicio, a.nomServicio, a.idProyecto, a.nomProyecto, a.epeFechaIni, a.epeFechaFin,
            SUM(IF(UPPER(pe2.cargoEnProy) IN ('REFERENTE','REFERENTES'), 1,0 )) cantReferentes,
            SUM(IF(UPPER(pe2.cargoEnProy) IN ('COLABORADOR','COLABORADORES'), 1,0 )) cantColaboradores,
            round((a.cantRespRefOK * 100) /a.cantRespOK, 2) porcAprobRef,
            round((a.cantRespColabOK * 100) /a.cantRespOK, 2) porcAprobColab,
            a.cantRespRefOK, a.cantRespColabOK,
            a.cantPregComp, a.cantRespOK, a.porcAprobComp
            FROM (
                SELECT
                cli.idCliente,
                UPPER(cli.nomCliente) nomCliente,
                ser.idServicio,
                UPPER(ser.nomServicio) nomServicio,
                pe.idProyecto,
                UPPER(proy.nomProyecto) nomProyecto,
                DATE_FORMAT(epe.fechaIni, "%d/%m/%Y %H:%i:%s") as epeFechaIni, 
                DATE_FORMAT(epe.fechaFin, "%d/%m/%Y %H:%i:%s") as epeFechaFin,
                count(*) cantPregComp,
                sum(IF(erp.nomRespPreg IN('BUENA', 'BUENO', 'MUY BUENA', 'MUY BUENO'), 1, 0)) cantRespOK,
                sum(IF(pe.cargoEnProy = 'REFERENTE' AND erp.nomRespPreg IN('BUENA', 'BUENO', 'MUY BUENA', 'MUY BUENO'), 1, 0)) cantRespRefOK,
                sum(IF(pe.cargoEnProy = 'COLABORADOR' AND erp.nomRespPreg IN('BUENA', 'BUENO', 'MUY BUENA', 'MUY BUENO'), 1, 0)) cantRespColabOK,
                round(sum(IF(erp.nomRespPreg IN('BUENA', 'BUENO', 'MUY BUENA', 'MUY BUENO'), 1, 0)) * 100 / count(*), 2) porcAprobComp
                FROM eddproyemp pe
                INNER JOIN cliente cli ON (FIND_IN_SET (cli.idCliente , IN_idCliente) AND cli.isActive = 1)
                INNER JOIN servicio ser ON (FIND_IN_SET (ser.idServicio , IN_idServicio) AND ser.idCliente = cli.idCliente AND ser.isActive = 1)
                INNER JOIN eddproyecto proy ON (FIND_IN_SET (proy.idEDDProyecto , IN_idProyecto) AND proy.idServicio = ser.idServicio AND proy.isActive = 1)
                INNER JOIN eddevalproyemp epe ON (pe.idProyecto = proy.idEDDProyecto  AND epe.idEDDProyEmpEvaluado = pe.idEDDProyEmp AND pe.isActive = 1)
                INNER JOIN eddEvalProyResp epr ON (epr.idEDDEvaluacion = epe.idEDDEvaluacion AND epe.evalRespondida = 1 AND epe.isActive = 1)  
                INNER JOIN eddEvalRespPreg erp ON (erp.idEDDEvalRespPreg = epr.idEDDEvalRespPreg AND epr.isActive = 1)
        

                WHERE pe.cargoEnProy IN ('REFERENTE') AND epe.fechaIni BETWEEN IN_fechaIni AND IN_fechaFin
                GROUP BY cli.nomCliente,ser.nomServicio, pe.idServicio, YEAR(epe.fechaIni)
                ORDER BY cli.nomCliente,ser.nomServicio, pe.idServicio) a 
            INNER JOIN eddProyEmp pe2 ON (pe2.idProyecto = a.idProyecto)
            GROUP BY a.nomCliente, a.nomServicio, a.idProyecto;  


        ELSEIF TRIM(UPPER(IN_tipoComparacion)) = 'GENERAL' AND TRIM(UPPER(IN_tipoCargo)) = 'COLABORADOR' THEN

            SET out_codResp = '00';
            SET out_msjResp = 'Success'; 

            SELECT out_codResp, out_msjResp,a.idCliente, a.nomCliente, a.idServicio, a.nomServicio, a.idProyecto, a.nomProyecto, a.epeFechaIni, a.epeFechaFin,
            SUM(IF(UPPER(pe2.cargoEnProy) IN ('REFERENTE','REFERENTES'), 1,0 )) cantReferentes,
            SUM(IF(UPPER(pe2.cargoEnProy) IN ('COLABORADOR','COLABORADORES'), 1,0 )) cantColaboradores,
            round((a.cantRespRefOK * 100) /a.cantRespOK, 2) porcAprobRef,
            round((a.cantRespColabOK * 100) /a.cantRespOK, 2) porcAprobColab,
            a.cantRespRefOK, a.cantRespColabOK,
            a.cantPregComp, a.cantRespOK, a.porcAprobComp
            FROM (
                SELECT
                cli.idCliente,
                UPPER(cli.nomCliente) nomCliente,
                ser.idServicio,
                UPPER(ser.nomServicio) nomServicio,
                pe.idProyecto,
                UPPER(proy.nomProyecto) nomProyecto,
                DATE_FORMAT(epe.fechaIni, "%d/%m/%Y %H:%i:%s") as epeFechaIni, 
                DATE_FORMAT(epe.fechaFin, "%d/%m/%Y %H:%i:%s") as epeFechaFin,
                count(*) cantPregComp,
                sum(IF(erp.nomRespPreg IN('BUENA', 'BUENO', 'MUY BUENA', 'MUY BUENO'), 1, 0)) cantRespOK,
                sum(IF(pe.cargoEnProy = 'REFERENTE' AND erp.nomRespPreg IN('BUENA', 'BUENO', 'MUY BUENA', 'MUY BUENO'), 1, 0)) cantRespRefOK,
                sum(IF(pe.cargoEnProy = 'COLABORADOR' AND erp.nomRespPreg IN('BUENA', 'BUENO', 'MUY BUENA', 'MUY BUENO'), 1, 0)) cantRespColabOK,
                round(sum(IF(erp.nomRespPreg IN('BUENA', 'BUENO', 'MUY BUENA', 'MUY BUENO'), 1, 0)) * 100 / count(*), 2) porcAprobComp
                FROM eddproyemp pe
                INNER JOIN cliente cli ON (FIND_IN_SET (cli.idCliente , IN_idCliente) AND cli.isActive = 1)
                INNER JOIN servicio ser ON (FIND_IN_SET (ser.idServicio , IN_idServicio) AND ser.idCliente = cli.idCliente AND ser.isActive = 1)
                INNER JOIN eddproyecto proy ON (FIND_IN_SET (proy.idEDDProyecto , IN_idProyecto) AND proy.idServicio = ser.idServicio AND proy.isActive = 1)
                INNER JOIN eddevalproyemp epe ON (pe.idProyecto = proy.idEDDProyecto  AND epe.idEDDProyEmpEvaluado = pe.idEDDProyEmp AND pe.isActive = 1)
                INNER JOIN eddEvalProyResp epr ON (epr.idEDDEvaluacion = epe.idEDDEvaluacion AND epe.evalRespondida = 1 AND epe.isActive = 1)  
                INNER JOIN eddEvalRespPreg erp ON (erp.idEDDEvalRespPreg = epr.idEDDEvalRespPreg AND epr.isActive = 1)

                WHERE pe.cargoEnProy IN ('COLABORADOR') AND epe.fechaIni BETWEEN IN_fechaIni AND IN_fechaFin
                GROUP BY cli.nomCliente,ser.nomServicio, pe.idServicio
                ORDER BY cli.nomCliente,ser.nomServicio, pe.idServicio) a
            INNER JOIN eddProyEmp pe2 ON (pe2.idProyecto = a.idProyecto)
            GROUP BY a.nomCliente, a.nomServicio, a.idProyecto;
  

        ELSEIF TRIM(UPPER(IN_tipoComparacion)) = 'MES' AND TRIM(UPPER(IN_tipoCargo)) = 'COLABORADOR' THEN

            SET out_codResp = '00';
            SET out_msjResp = 'Success'; 

            SELECT out_codResp, out_msjResp,a.idCliente, a.nomCliente, a.idServicio, a.nomServicio, a.idProyecto, a.nomProyecto, a.epeFechaIni, a.epeFechaFin,
            SUM(IF(UPPER(pe2.cargoEnProy) IN ('REFERENTE','REFERENTES'), 1,0 )) cantReferentes,
            SUM(IF(UPPER(pe2.cargoEnProy) IN ('COLABORADOR','COLABORADORES'), 1,0 )) cantColaboradores,
            round((a.cantRespRefOK * 100) /a.cantRespOK, 2) porcAprobRef,
            round((a.cantRespColabOK * 100) /a.cantRespOK, 2) porcAprobColab,
            a.cantRespRefOK, a.cantRespColabOK,
            a.cantPregComp, a.cantRespOK, a.porcAprobComp
            FROM (
                SELECT
                cli.idCliente,
                UPPER(cli.nomCliente) nomCliente,
                ser.idServicio,
                UPPER(ser.nomServicio) nomServicio,
                pe.idProyecto,
                UPPER(proy.nomProyecto) nomProyecto,
                DATE_FORMAT(epe.fechaIni, "%d/%m/%Y %H:%i:%s") as epeFechaIni, 
                DATE_FORMAT(epe.fechaFin, "%d/%m/%Y %H:%i:%s") as epeFechaFin,
                count(*) cantPregComp,
                sum(IF(erp.nomRespPreg IN('BUENA', 'BUENO', 'MUY BUENA', 'MUY BUENO'), 1, 0)) cantRespOK,
                sum(IF(pe.cargoEnProy = 'REFERENTE' AND erp.nomRespPreg IN('BUENA', 'BUENO', 'MUY BUENA', 'MUY BUENO'), 1, 0)) cantRespRefOK,
                sum(IF(pe.cargoEnProy = 'COLABORADOR' AND erp.nomRespPreg IN('BUENA', 'BUENO', 'MUY BUENA', 'MUY BUENO'), 1, 0)) cantRespColabOK,
                round(sum(IF(erp.nomRespPreg IN('BUENA', 'BUENO', 'MUY BUENA', 'MUY BUENO'), 1, 0)) * 100 / count(*), 2) porcAprobComp
                FROM eddproyemp pe
                INNER JOIN cliente cli ON (FIND_IN_SET (cli.idCliente , IN_idCliente) AND cli.isActive = 1)
                INNER JOIN servicio ser ON (FIND_IN_SET (ser.idServicio , IN_idServicio) AND ser.idCliente = cli.idCliente AND ser.isActive = 1)
                INNER JOIN eddproyecto proy ON (FIND_IN_SET (proy.idEDDProyecto , IN_idProyecto) AND proy.idServicio = ser.idServicio AND proy.isActive = 1)
                INNER JOIN eddevalproyemp epe ON (pe.idProyecto = proy.idEDDProyecto  AND epe.idEDDProyEmpEvaluado = pe.idEDDProyEmp AND pe.isActive = 1)
                INNER JOIN eddEvalProyResp epr ON (epr.idEDDEvaluacion = epe.idEDDEvaluacion AND epe.evalRespondida = 1 AND epe.isActive = 1)  
                INNER JOIN eddEvalRespPreg erp ON (erp.idEDDEvalRespPreg = epr.idEDDEvalRespPreg AND epr.isActive = 1)

                WHERE pe.cargoEnProy IN ('COLABORADOR') AND epe.fechaIni BETWEEN IN_fechaIni AND IN_fechaFin
                GROUP BY cli.nomCliente,ser.nomServicio,pe.idServicio, YEAR(epe.fechaIni)*100 + MONTH(epe.fechaIni)
                ORDER BY cli.nomCliente,ser.nomServiciol, pe.idServicio) a
            INNER JOIN eddProyEmp pe2 ON (pe2.idProyecto = a.idProyecto)
            GROUP BY a.nomCliente, a.nomServicio, a.idProyecto;


        ELSEIF TRIM(UPPER(IN_tipoComparacion)) = 'AÑO' AND TRIM(UPPER(IN_tipoCargo)) = 'COLABORADOR' THEN

            SET out_codResp = '00';
            SET out_msjResp = 'Success'; 

            SELECT out_codResp, out_msjResp,a.idCliente, a.nomCliente, a.idServicio, a.nomServicio, a.idProyecto, a.nomProyecto, a.epeFechaIni, a.epeFechaFin,
            SUM(IF(UPPER(pe2.cargoEnProy) IN ('REFERENTE','REFERENTES'), 1,0 )) cantReferentes,
            SUM(IF(UPPER(pe2.cargoEnProy) IN ('COLABORADOR','COLABORADORES'), 1,0 )) cantColaboradores,
            round((a.cantRespRefOK * 100) /a.cantRespOK, 2) porcAprobRef,
            round((a.cantRespColabOK * 100) /a.cantRespOK, 2) porcAprobColab,
            a.cantRespRefOK, a.cantRespColabOK,
            a.cantPregComp, a.cantRespOK, a.porcAprobComp
            FROM (
                SELECT
                cli.idCliente,
                UPPER(cli.nomCliente) nomCliente,
                ser.idServicio,
                UPPER(ser.nomServicio) nomServicio,
                pe.idProyecto,
                UPPER(proy.nomProyecto) nomProyecto,
                DATE_FORMAT(epe.fechaIni, "%d/%m/%Y %H:%i:%s") as epeFechaIni, 
                DATE_FORMAT(epe.fechaFin, "%d/%m/%Y %H:%i:%s") as epeFechaFin,
                count(*) cantPregComp,
                sum(IF(erp.nomRespPreg IN('BUENA', 'BUENO', 'MUY BUENA', 'MUY BUENO'), 1, 0)) cantRespOK,
                sum(IF(pe.cargoEnProy = 'REFERENTE' AND erp.nomRespPreg IN('BUENA', 'BUENO', 'MUY BUENA', 'MUY BUENO'), 1, 0)) cantRespRefOK,
                sum(IF(pe.cargoEnProy = 'COLABORADOR' AND erp.nomRespPreg IN('BUENA', 'BUENO', 'MUY BUENA', 'MUY BUENO'), 1, 0)) cantRespColabOK,
                round(sum(IF(erp.nomRespPreg IN('BUENA', 'BUENO', 'MUY BUENA', 'MUY BUENO'), 1, 0)) * 100 / count(*), 2) porcAprobComp
                FROM eddproyemp pe
                INNER JOIN cliente cli ON (FIND_IN_SET (cli.idCliente , IN_idCliente) AND cli.isActive = 1)
                INNER JOIN servicio ser ON (FIND_IN_SET (ser.idServicio , IN_idServicio) AND ser.idCliente = cli.idCliente AND ser.isActive = 1)
                INNER JOIN eddproyecto proy ON (FIND_IN_SET (proy.idEDDProyecto , IN_idProyecto) AND proy.idServicio = ser.idServicio AND proy.isActive = 1)
                INNER JOIN eddevalproyemp epe ON (pe.idProyecto = proy.idEDDProyecto  AND epe.idEDDProyEmpEvaluado = pe.idEDDProyEmp AND pe.isActive = 1)
                INNER JOIN eddEvalProyResp epr ON (epr.idEDDEvaluacion = epe.idEDDEvaluacion AND epe.evalRespondida = 1 AND epe.isActive = 1)  
                INNER JOIN eddEvalRespPreg erp ON (erp.idEDDEvalRespPreg = epr.idEDDEvalRespPreg AND epr.isActive = 1)

                WHERE pe.cargoEnProy IN ('COLABORADOR') AND epe.fechaIni BETWEEN IN_fechaIni AND IN_fechaFin
                GROUP BY cli.nomCliente,ser.nomServicio, pe.idServicio, YEAR(epe.fechaIni)
                ORDER BY cli.nomCliente,ser.nomServicio, pe.idServicio) a
            INNER JOIN eddProyEmp pe2 ON (pe2.idProyecto = a.idProyecto)
            GROUP BY a.nomCliente, a.nomServicio, a.idProyecto;     

        END IF;
    END IF;
END$$
DELIMITER ;