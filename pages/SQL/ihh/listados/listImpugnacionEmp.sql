DROP PROCEDURE IF EXISTS `SP_ihh_listadoImpugnacionEmp`;
DELIMITER $$
CREATE PROCEDURE `SP_ihh_listadoImpugnacionEmp`(
    IN `IN_idEmpleado` INT, 
    IN `IN_idElemento` INT, 
    IN `IN_idPeriodo` INT, 
    IN `IN_idAcop` INT, 
    IN `IN_inicio` INT, 
    IN `IN_cantidadPorPagina` INT)

BEGIN
        DECLARE temp_cantRegistros INT;

        -- Si no se aplica ningún filtro
        IF IN_idEmpleado = 0 AND IN_idElemento = 0 AND IN_idPeriodo = 0 AND IN_idAcop = 0 THEN
            
            SELECT COUNT(ie.idImpugnacionEmp) INTO temp_cantRegistros 
            FROM ihhimpugnacionemp ie
            INNER JOIN empleado emp ON (emp.idEmpleado = ie.idEmpleado AND emp.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhelementoimp ei ON (ei.idElementoImp = ie.idElemento AND ei.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhperiodo p ON (p.idPeriodo = ie.idPeriodo AND p.isActive = 1 AND ie.isActive = 1);
                
            SELECT 
            ie.idImpugnacionEmp,
            ie.idEmpleado,
            temp_cantRegistros,
            UPPER(emp.nomEmpleado) nomEmpleado,
            ie.idElemento,
            UPPER(ei.nomElemento) nomElemento,
            ie.cantHorasPeriodo,
            ie.cantHorasExtra,
            ie.factor,
            ie.idAcop,
            UPPER(proy.nomProyecto) nomProyecto
            FROM ihhimpugnacionemp ie
            INNER JOIN empleado emp ON (emp.idEmpleado = ie.idEmpleado AND emp.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhelementoimp ei ON (ei.idElementoImp = ie.idElemento AND ei.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhperiodo p ON (p.idPeriodo = ie.idPeriodo AND p.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhacop a ON (a.idAcop = ie.idAcop AND a.isActive = 1)
            INNER JOIN eddproyecto proy ON (proy.idEDDProyecto = a.idProyecto AND proy.isActive = 1)
            ORDER BY emp.nomEmpleado, ei.nomElemento
            LIMIT IN_inicio, IN_cantidadPorPagina;

        -- Si se busca por empleado
        ELSEIF IN_idEmpleado != 0 AND IN_idElemento = 0 AND IN_idPeriodo = 0 AND IN_idAcop = 0 THEN

            SELECT COUNT(ie.idImpugnacionEmp) INTO temp_cantRegistros 
            FROM ihhimpugnacionemp ie
            INNER JOIN empleado emp ON (emp.idEmpleado = ie.idEmpleado AND emp.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhelementoimp ei ON (ei.idElementoImp = ie.idElemento AND ei.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhperiodo p ON (p.idPeriodo = ie.idPeriodo AND p.isActive = 1 AND ie.isActive = 1)
            WHERE ie.idEmpleado = IN_idEmpleado;

            SELECT 
            OUT_CODRESULT, OUT_MJERESULT,
            ie.idImpugnacionEmp,
            ie.idEmpleado,
            UPPER(emp.nomEmpleado) nomEmpleado,
            ie.idElemento,
            temp_cantRegistros,
            UPPER(ei.nomElemento) nomElemento,
            ie.cantHorasPeriodo,
            ie.cantHorasExtra,
            ie.factor,
            ie.idAcop,
            UPPER(proy.nomProyecto) nomProyecto
            FROM ihhimpugnacionemp ie
            INNER JOIN empleado emp ON (emp.idEmpleado = ie.idEmpleado AND emp.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhelementoimp ei ON (ei.idElementoImp = ie.idElemento AND ei.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhperiodo p ON (p.idPeriodo = ie.idPeriodo AND p.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhacop a ON (a.idAcop = ie.idAcop AND a.isActive = 1)
            INNER JOIN eddproyecto proy ON (proy.idEDDProyecto = a.idProyecto AND proy.isActive = 1)
            WHERE ie.idEmpleado = IN_idEmpleado
            ORDER BY emp.nomEmpleado, ei.nomElemento
            LIMIT IN_inicio, IN_cantidadPorPagina;
            
        -- Si se busca por elemento
        ELSEIF IN_idEmpleado = 0 AND IN_idElemento != 0 AND IN_idPeriodo = 0 AND IN_idAcop = 0 THEN

            SELECT COUNT(ie.idImpugnacionEmp) INTO temp_cantRegistros 
            FROM ihhimpugnacionemp ie
            INNER JOIN empleado emp ON (emp.idEmpleado = ie.idEmpleado AND emp.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhelementoimp ei ON (ei.idElementoImp = ie.idElemento AND ei.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhperiodo p ON (p.idPeriodo = ie.idPeriodo AND p.isActive = 1 AND ie.isActive = 1)
            WHERE ie.idElemento = IN_idElemento;

            SELECT 
            ie.idImpugnacionEmp,
            ie.idEmpleado,
            UPPER(emp.nomEmpleado) nomEmpleado,
            ie.idElemento,
            UPPER(ei.nomElemento) nomElemento,
            temp_cantRegistros,
            ie.cantHorasPeriodo,
            ie.cantHorasExtra,
            ie.factor,
            ie.idAcop,
            UPPER(proy.nomProyecto) nomProyecto            
            FROM ihhimpugnacionemp ie
            INNER JOIN empleado emp ON (emp.idEmpleado = ie.idEmpleado AND emp.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhelementoimp ei ON (ei.idElementoImp = ie.idElemento AND ei.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhperiodo p ON (p.idPeriodo = ie.idPeriodo AND p.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhacop a ON (a.idAcop = ie.idAcop AND a.isActive = 1)
            INNER JOIN eddproyecto proy ON (proy.idEDDProyecto = a.idProyecto AND proy.isActive = 1)
            WHERE ie.idElemento = IN_idElemento
            ORDER BY emp.nomEmpleado, ei.nomElemento
            LIMIT IN_inicio, IN_cantidadPorPagina;
             
        -- Si se busca por periodo
        ELSEIF IN_idEmpleado = 0 AND IN_idElemento = 0 AND IN_idPeriodo != 0 AND IN_idAcop = 0 THEN

            SELECT COUNT(ie.idImpugnacionEmp) INTO temp_cantRegistros 
            FROM ihhimpugnacionemp ie
            INNER JOIN empleado emp ON (emp.idEmpleado = ie.idEmpleado AND emp.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhelementoimp ei ON (ei.idElementoImp = ie.idElemento AND ei.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhperiodo p ON (p.idPeriodo = ie.idPeriodo AND p.isActive = 1 AND ie.isActive = 1)
            WHERE ie.idPeriodo = IN_idPeriodo;

            SELECT 
            ie.idImpugnacionEmp,
            ie.idEmpleado,
            UPPER(emp.nomEmpleado) nomEmpleado,
            ie.idElemento,
            UPPER(ei.nomElemento) nomElemento,
            temp_cantRegistros,
            ie.cantHorasPeriodo,
            ie.cantHorasExtra,
            ie.factor,
            ie.idAcop,
            UPPER(proy.nomProyecto) nomProyecto
            FROM ihhimpugnacionemp ie
            INNER JOIN empleado emp ON (emp.idEmpleado = ie.idEmpleado AND emp.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhelementoimp ei ON (ei.idElementoImp = ie.idElemento AND ei.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhperiodo p ON (p.idPeriodo = ie.idPeriodo AND p.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhacop a ON (a.idAcop = ie.idAcop AND a.isActive = 1)
            INNER JOIN eddproyecto proy ON (proy.idEDDProyecto = a.idProyecto AND proy.isActive = 1)
            WHERE ie.idPeriodo = IN_idPeriodo
            ORDER BY emp.nomEmpleado, ei.nomElemento
            LIMIT IN_inicio, IN_cantidadPorPagina;
            
        -- Si se busca por acop
        ELSEIF IN_idEmpleado = 0 AND IN_idElemento = 0 AND IN_idPeriodo = 0 AND IN_idAcop != 0 THEN

            SELECT COUNT(ie.idImpugnacionEmp) INTO temp_cantRegistros 
            FROM ihhimpugnacionemp ie
            INNER JOIN empleado emp ON (emp.idEmpleado = ie.idEmpleado AND emp.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhelementoimp ei ON (ei.idElementoImp = ie.idElemento AND ei.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhperiodo p ON (p.idPeriodo = ie.idPeriodo AND p.isActive = 1 AND ie.isActive = 1)
            WHERE ie.idAcop = IN_idAcop;


            SELECT 
            ie.idImpugnacionEmp,
            ie.idEmpleado,
            UPPER(emp.nomEmpleado) nomEmpleado,
            ie.idElemento,
            UPPER(ei.nomElemento) nomElemento,
            temp_cantRegistros,
            ie.cantHorasPeriodo,
            ie.cantHorasExtra,
            ie.factor,
            ie.idAcop,
            UPPER(proy.nomProyecto) nomProyecto
            FROM ihhimpugnacionemp ie
            INNER JOIN empleado emp ON (emp.idEmpleado = ie.idEmpleado AND emp.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhelementoimp ei ON (ei.idElementoImp = ie.idElemento AND ei.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhperiodo p ON (p.idPeriodo = ie.idPeriodo AND p.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhacop a ON (a.idAcop = ie.idAcop AND a.isActive = 1)
            INNER JOIN eddproyecto proy ON (proy.idEDDProyecto = a.idProyecto AND proy.isActive = 1)
            WHERE ie.idAcop = IN_idAcop
            ORDER BY emp.nomEmpleado, ei.nomElemento
            LIMIT IN_inicio, IN_cantidadPorPagina;
                
        -- Si se busca por empleado y elemento
        ELSEIF IN_idEmpleado != 0 AND IN_idElemento != 0 AND IN_idPeriodo = 0 AND IN_idAcop = 0 THEN
        
            SELECT COUNT(ie.idImpugnacionEmp) INTO temp_cantRegistros 
            FROM ihhimpugnacionemp ie
            INNER JOIN empleado emp ON (emp.idEmpleado = ie.idEmpleado AND emp.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhelementoimp ei ON (ei.idElementoImp = ie.idElemento AND ei.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhperiodo p ON (p.idPeriodo = ie.idPeriodo AND p.isActive = 1 AND ie.isActive = 1)
            WHERE 
            ie.idEmpleado = IN_idEmpleado AND
            ie.idElemento = IN_idElemento;

            SELECT 
            ie.idImpugnacionEmp,
            ie.idEmpleado,
            UPPER(emp.nomEmpleado) nomEmpleado,
            ie.idElemento,
            UPPER(ei.nomElemento) nomElemento,
            temp_cantRegistros,
            ie.cantHorasPeriodo,
            ie.cantHorasExtra,
            ie.factor,
            ie.idAcop,
            UPPER(proy.nomProyecto) nomProyecto
            FROM ihhimpugnacionemp ie
            INNER JOIN empleado emp ON (emp.idEmpleado = ie.idEmpleado AND emp.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhelementoimp ei ON (ei.idElementoImp = ie.idElemento AND ei.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhperiodo p ON (p.idPeriodo = ie.idPeriodo AND p.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhacop a ON (a.idAcop = ie.idAcop AND a.isActive = 1)
            INNER JOIN eddproyecto proy ON (proy.idEDDProyecto = a.idProyecto AND proy.isActive = 1)
            WHERE 
            ie.idEmpleado = IN_idEmpleado AND
            ie.idElemento = IN_idElemento
            ORDER BY emp.nomEmpleado, ei.nomElemento
            LIMIT IN_inicio, IN_cantidadPorPagina;
           
        -- Si se busca por empleado y periodo
        ELSEIF IN_idEmpleado != 0 AND IN_idElemento = 0 AND IN_idPeriodo != 0 AND IN_idAcop = 0 THEN

            SELECT COUNT(ie.idImpugnacionEmp) INTO temp_cantRegistros 
             FROM ihhimpugnacionemp ie
            INNER JOIN empleado emp ON (emp.idEmpleado = ie.idEmpleado AND emp.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhelementoimp ei ON (ei.idElementoImp = ie.idElemento AND ei.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhperiodo p ON (p.idPeriodo = ie.idPeriodo AND p.isActive = 1 AND ie.isActive = 1)
            WHERE 
            ie.idEmpleado = IN_idEmpleado AND
            ie.idPeriodo = IN_idPeriodo;

            SELECT 
            ie.idImpugnacionEmp,
            ie.idEmpleado,
            UPPER(emp.nomEmpleado) nomEmpleado,
            ie.idElemento,
            UPPER(ei.nomElemento) nomElemento,
            temp_cantRegistros,
            ie.cantHorasPeriodo,
            ie.cantHorasExtra,
            ie.factor,
            ie.idAcop,
            UPPER(proy.nomProyecto) nomProyecto
            FROM ihhimpugnacionemp ie
            INNER JOIN empleado emp ON (emp.idEmpleado = ie.idEmpleado AND emp.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhelementoimp ei ON (ei.idElementoImp = ie.idElemento AND ei.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhperiodo p ON (p.idPeriodo = ie.idPeriodo AND p.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhacop a ON (a.idAcop = ie.idAcop AND a.isActive = 1)
            INNER JOIN eddproyecto proy ON (proy.idEDDProyecto = a.idProyecto AND proy.isActive = 1)
            WHERE 
            ie.idEmpleado = IN_idEmpleado AND
            ie.idPeriodo = IN_idPeriodo
            ORDER BY emp.nomEmpleado, ei.nomElemento
            LIMIT IN_inicio, IN_cantidadPorPagina;
                 
        -- Si se busca por empleado y acop
        ELSEIF IN_idEmpleado != 0 AND IN_idElemento = 0 AND IN_idPeriodo = 0 AND IN_idAcop != 0 THEN

            SELECT COUNT(ie.idImpugnacionEmp) INTO temp_cantRegistros 
            FROM ihhimpugnacionemp ie
            INNER JOIN empleado emp ON (emp.idEmpleado = ie.idEmpleado AND emp.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhelementoimp ei ON (ei.idElementoImp = ie.idElemento AND ei.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhperiodo p ON (p.idPeriodo = ie.idPeriodo AND p.isActive = 1 AND ie.isActive = 1)
            WHERE 
            ie.idEmpleado = IN_idEmpleado AND
            ie.idAcop = IN_idAcop;

            SELECT 
            ie.idImpugnacionEmp,
            ie.idEmpleado,
            UPPER(emp.nomEmpleado) nomEmpleado,
            ie.idElemento,
            UPPER(ei.nomElemento) nomElemento,
            temp_cantRegistros,
            ie.cantHorasPeriodo,
            ie.cantHorasExtra,
            ie.factor,
            ie.idAcop,
            UPPER(proy.nomProyecto) nomProyecto
            FROM ihhimpugnacionemp ie
            INNER JOIN empleado emp ON (emp.idEmpleado = ie.idEmpleado AND emp.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhelementoimp ei ON (ei.idElementoImp = ie.idElemento AND ei.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhperiodo p ON (p.idPeriodo = ie.idPeriodo AND p.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhacop a ON (a.idAcop = ie.idAcop AND a.isActive = 1)
            INNER JOIN eddproyecto proy ON (proy.idEDDProyecto = a.idProyecto AND proy.isActive = 1)
            WHERE 
            ie.idEmpleado = IN_idEmpleado AND
            ie.idAcop = IN_idAcop
            ORDER BY emp.nomEmpleado, ei.nomElemento
            LIMIT IN_inicio, IN_cantidadPorPagina;
            
        -- Si se busca por elemento y periodo
        ELSEIF IN_idEmpleado = 0 AND IN_idElemento != 0 AND IN_idPeriodo != 0 AND IN_idAcop = 0 THEN

            SELECT COUNT(ie.idImpugnacionEmp) INTO temp_cantRegistros 
            FROM ihhimpugnacionemp ie
            INNER JOIN empleado emp ON (emp.idEmpleado = ie.idEmpleado AND emp.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhelementoimp ei ON (ei.idElementoImp = ie.idElemento AND ei.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhperiodo p ON (p.idPeriodo = ie.idPeriodo AND p.isActive = 1 AND ie.isActive = 1)
            WHERE 
            ie.idElemento = IN_idElemento AND
            ie.idPeriodo = IN_idPeriodo;

            SELECT 
            ie.idImpugnacionEmp,
            ie.idEmpleado,
            UPPER(emp.nomEmpleado) nomEmpleado,
            ie.idElemento,
            UPPER(ei.nomElemento) nomElemento,
            temp_cantRegistros,
            ie.cantHorasPeriodo,
            ie.cantHorasExtra,
            ie.factor,
            ie.idAcop,
            UPPER(proy.nomProyecto) nomProyecto
            FROM ihhimpugnacionemp ie
            INNER JOIN empleado emp ON (emp.idEmpleado = ie.idEmpleado AND emp.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhelementoimp ei ON (ei.idElementoImp = ie.idElemento AND ei.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhperiodo p ON (p.idPeriodo = ie.idPeriodo AND p.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhacop a ON (a.idAcop = ie.idAcop AND a.isActive = 1)
            INNER JOIN eddproyecto proy ON (proy.idEDDProyecto = a.idProyecto AND proy.isActive = 1)
            WHERE 
            ie.idElemento = IN_idElemento AND
            ie.idPeriodo = IN_idPeriodo
            ORDER BY emp.nomEmpleado, ei.nomElemento
            LIMIT IN_inicio, IN_cantidadPorPagina;
            
        -- Si se busca por elemento y acop
        ELSEIF IN_idEmpleado = 0 AND IN_idElemento != 0 AND IN_idPeriodo = 0 AND IN_idAcop != 0 THEN

            SELECT COUNT(ie.idImpugnacionEmp) INTO temp_cantRegistros 
            FROM ihhimpugnacionemp ie
            INNER JOIN empleado emp ON (emp.idEmpleado = ie.idEmpleado AND emp.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhelementoimp ei ON (ei.idElementoImp = ie.idElemento AND ei.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhperiodo p ON (p.idPeriodo = ie.idPeriodo AND p.isActive = 1 AND ie.isActive = 1)
            WHERE 
            ie.idElemento = IN_idElemento AND
            ie.idAcop = IN_idAcop;

            SELECT 
            ie.idImpugnacionEmp,
            ie.idEmpleado,
            UPPER(emp.nomEmpleado) nomEmpleado,
            ie.idElemento,
            UPPER(ei.nomElemento) nomElemento,
            temp_cantRegistros,
            ie.cantHorasPeriodo,
            ie.cantHorasExtra,
            ie.factor,
            ie.idAcop,
            UPPER(proy.nomProyecto) nomProyecto
            FROM ihhimpugnacionemp ie
            INNER JOIN empleado emp ON (emp.idEmpleado = ie.idEmpleado AND emp.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhelementoimp ei ON (ei.idElementoImp = ie.idElemento AND ei.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhperiodo p ON (p.idPeriodo = ie.idPeriodo AND p.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhacop a ON (a.idAcop = ie.idAcop AND a.isActive = 1)
            INNER JOIN eddproyecto proy ON (proy.idEDDProyecto = a.idProyecto AND proy.isActive = 1)
            WHERE 
            ie.idElemento = IN_idElemento AND
            ie.idAcop = IN_idAcop
            ORDER BY emp.nomEmpleado, ei.nomElemento
            LIMIT IN_inicio, IN_cantidadPorPagina;
            

         -- Si se busca por elemento y acop
        
        -- Si se busca por periodo y acop
        ELSEIF IN_idEmpleado = 0 AND IN_idElemento = 0 AND IN_idPeriodo != 0 AND IN_idAcop != 0 THEN

            SELECT COUNT(ie.idImpugnacionEmp) INTO temp_cantRegistros 
            FROM ihhimpugnacionemp ie
            INNER JOIN empleado emp ON (emp.idEmpleado = ie.idEmpleado AND emp.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhelementoimp ei ON (ei.idElementoImp = ie.idElemento AND ei.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhperiodo p ON (p.idPeriodo = ie.idPeriodo AND p.isActive = 1 AND ie.isActive = 1)
            WHERE 
            ie.idPeriodo = IN_idPeriodo AND
            ie.idAcop = IN_idAcop;

            SELECT 
            ie.idImpugnacionEmp,
            ie.idEmpleado,
            UPPER(emp.nomEmpleado) nomEmpleado,
            ie.idElemento,
            UPPER(ei.nomElemento) nomElemento,
            temp_cantRegistros,
            ie.cantHorasPeriodo,
            ie.cantHorasExtra,
            ie.factor,
            ie.idAcop,
            UPPER(proy.nomProyecto) nomProyecto
            FROM ihhimpugnacionemp ie
            INNER JOIN empleado emp ON (emp.idEmpleado = ie.idEmpleado AND emp.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhelementoimp ei ON (ei.idElementoImp = ie.idElemento AND ei.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhperiodo p ON (p.idPeriodo = ie.idPeriodo AND p.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhacop a ON (a.idAcop = ie.idAcop AND a.isActive = 1)
            INNER JOIN eddproyecto proy ON (proy.idEDDProyecto = a.idProyecto AND proy.isActive = 1)
            WHERE 
            ie.idPeriodo = IN_idPeriodo AND
            ie.idAcop = IN_idAcop
            ORDER BY emp.nomEmpleado, ei.nomElemento
            LIMIT IN_inicio, IN_cantidadPorPagina;
            

         -- Si se busca por periodo y acop
        
        -- Si se busca por empleado, elemento y periodo
        ELSEIF IN_idEmpleado != 0 AND IN_idElemento != 0 AND IN_idPeriodo != 0 AND IN_idAcop = 0 THEN

            SELECT COUNT(ie.idImpugnacionEmp) INTO temp_cantRegistros 
            FROM ihhimpugnacionemp ie
            INNER JOIN empleado emp ON (emp.idEmpleado = ie.idEmpleado AND emp.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhelementoimp ei ON (ei.idElementoImp = ie.idElemento AND ei.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhperiodo p ON (p.idPeriodo = ie.idPeriodo AND p.isActive = 1 AND ie.isActive = 1)
            WHERE 
            ie.idEmpleado = IN_idEmpleado AND
            ie.idElemento = IN_idElemento AND
            ie.idPeriodo = IN_idPeriodo ;

            SELECT 
            ie.idImpugnacionEmp,
            ie.idEmpleado,
            UPPER(emp.nomEmpleado) nomEmpleado,
            ie.idElemento,
            UPPER(ei.nomElemento) nomElemento,
            temp_cantRegistros,
            ie.cantHorasPeriodo,
            ie.cantHorasExtra,
            ie.factor,
            ie.idAcop,
            UPPER(proy.nomProyecto) nomProyecto
            FROM ihhimpugnacionemp ie
            INNER JOIN empleado emp ON (emp.idEmpleado = ie.idEmpleado AND emp.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhelementoimp ei ON (ei.idElementoImp = ie.idElemento AND ei.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhperiodo p ON (p.idPeriodo = ie.idPeriodo AND p.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhacop a ON (a.idAcop = ie.idAcop AND a.isActive = 1)
            INNER JOIN eddproyecto proy ON (proy.idEDDProyecto = a.idProyecto AND proy.isActive = 1)
            WHERE 
            ie.idEmpleado = IN_idEmpleado AND
            ie.idElemento = IN_idElemento AND
            ie.idPeriodo = IN_idPeriodo 
            ORDER BY emp.nomEmpleado, ei.nomElemento
            LIMIT IN_inicio, IN_cantidadPorPagina;
            
        -- Si se busca por elemento, periodo y acop
        ELSEIF IN_idEmpleado = 0 AND IN_idElemento != 0 AND IN_idPeriodo != 0 AND IN_idAcop != 0 THEN
   
            SELECT COUNT(ie.idImpugnacionEmp) INTO temp_cantRegistros 
            FROM ihhimpugnacionemp ie
            INNER JOIN empleado emp ON (emp.idEmpleado = ie.idEmpleado AND emp.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhelementoimp ei ON (ei.idElementoImp = ie.idElemento AND ei.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhperiodo p ON (p.idPeriodo = ie.idPeriodo AND p.isActive = 1 AND ie.isActive = 1)
            WHERE 
            ie.idElemento = IN_idElemento AND
            ie.idPeriodo = IN_idPeriodo AND
            ie.idAcop = IN_idAcop;

            SELECT 
            ie.idImpugnacionEmp,
            ie.idEmpleado,
            UPPER(emp.nomEmpleado) nomEmpleado,
            ie.idElemento,
            UPPER(ei.nomElemento) nomElemento,
            temp_cantRegistros,
            ie.cantHorasPeriodo,
            ie.cantHorasExtra,
            ie.factor,
            ie.idAcop,
            UPPER(proy.nomProyecto) nomProyecto
            FROM ihhimpugnacionemp ie
            INNER JOIN empleado emp ON (emp.idEmpleado = ie.idEmpleado AND emp.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhelementoimp ei ON (ei.idElementoImp = ie.idElemento AND ei.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhperiodo p ON (p.idPeriodo = ie.idPeriodo AND p.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhacop a ON (a.idAcop = ie.idAcop AND a.isActive = 1)
            INNER JOIN eddproyecto proy ON (proy.idEDDProyecto = a.idProyecto AND proy.isActive = 1)
            WHERE 
            ie.idElemento = IN_idElemento AND
            ie.idPeriodo = IN_idPeriodo AND
            ie.idAcop = IN_idAcop  
            ORDER BY emp.nomEmpleado, ei.nomElemento
            LIMIT IN_inicio, IN_cantidadPorPagina;
            
        -- Si se busca por empleado, periodo y acop
        ELSEIF IN_idEmpleado != 0 AND IN_idElemento = 0 AND IN_idPeriodo != 0 AND IN_idAcop != 0 THEN

            SELECT COUNT(ie.idImpugnacionEmp) INTO temp_cantRegistros 
            FROM ihhimpugnacionemp ie
            INNER JOIN empleado emp ON (emp.idEmpleado = ie.idEmpleado AND emp.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhelementoimp ei ON (ei.idElementoImp = ie.idElemento AND ei.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhperiodo p ON (p.idPeriodo = ie.idPeriodo AND p.isActive = 1 AND ie.isActive = 1)
            WHERE 
            ie.idEmpleado = IN_idEmpleado AND
            ie.idPeriodo = IN_idPeriodo AND
            ie.idAcop = IN_idAcop  ;

            SELECT 
            ie.idImpugnacionEmp,
            ie.idEmpleado,
            UPPER(emp.nomEmpleado) nomEmpleado,
            ie.idElemento,
            UPPER(ei.nomElemento) nomElemento,
            temp_cantRegistros,
            ie.cantHorasPeriodo,
            ie.cantHorasExtra,
            ie.factor,
            ie.idAcop,
            UPPER(proy.nomProyecto) nomProyecto
            FROM ihhimpugnacionemp ie
            INNER JOIN empleado emp ON (emp.idEmpleado = ie.idEmpleado AND emp.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhelementoimp ei ON (ei.idElementoImp = ie.idElemento AND ei.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhperiodo p ON (p.idPeriodo = ie.idPeriodo AND p.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhacop a ON (a.idAcop = ie.idAcop AND a.isActive = 1)
            INNER JOIN eddproyecto proy ON (proy.idEDDProyecto = a.idProyecto AND proy.isActive = 1)
            WHERE 
            ie.idEmpleado = IN_idEmpleado AND
            ie.idPeriodo = IN_idPeriodo AND
            ie.idAcop = IN_idAcop  
            ORDER BY emp.nomEmpleado, ei.nomElemento
            LIMIT IN_inicio, IN_cantidadPorPagina;

        -- Si se busca por empleado, elemento y acop
        ELSEIF IN_idEmpleado != 0 AND IN_idElemento != 0 AND IN_idPeriodo = 0 AND IN_idAcop != 0 THEN

            SELECT COUNT(ie.idImpugnacionEmp) INTO temp_cantRegistros 
            FROM ihhimpugnacionemp ie
            INNER JOIN empleado emp ON (emp.idEmpleado = ie.idEmpleado AND emp.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhelementoimp ei ON (ei.idElementoImp = ie.idElemento AND ei.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhperiodo p ON (p.idPeriodo = ie.idPeriodo AND p.isActive = 1 AND ie.isActive = 1)
            WHERE 
            ie.idEmpleado = IN_idEmpleado AND
            ie.idElemento = IN_idElemento AND
            ie.idAcop = IN_idAcop;

            SELECT 
            ie.idImpugnacionEmp,
            ie.idEmpleado,
            UPPER(emp.nomEmpleado) nomEmpleado,
            ie.idElemento,
            UPPER(ei.nomElemento) nomElemento,
            temp_cantRegistros,
            ie.cantHorasPeriodo,
            ie.cantHorasExtra,
            ie.factor,
            ie.idAcop,
            UPPER(proy.nomProyecto) nomProyecto
            FROM ihhimpugnacionemp ie
            INNER JOIN empleado emp ON (emp.idEmpleado = ie.idEmpleado AND emp.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhelementoimp ei ON (ei.idElementoImp = ie.idElemento AND ei.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhperiodo p ON (p.idPeriodo = ie.idPeriodo AND p.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhacop a ON (a.idAcop = ie.idAcop AND a.isActive = 1)
            INNER JOIN eddproyecto proy ON (proy.idEDDProyecto = a.idProyecto AND proy.isActive = 1)
            WHERE 
            ie.idEmpleado = IN_idEmpleado AND
            ie.idElemento = IN_idElemento AND
            ie.idAcop = IN_idAcop  
            ORDER BY emp.nomEmpleado, ei.nomElemento
            LIMIT IN_inicio, IN_cantidadPorPagina;
            
        -- Si se aplican todos los filtros
        ELSEIF IN_idEmpleado != 0 AND IN_idElemento != 0 AND IN_idPeriodo != 0 AND IN_idAcop != 0 THEN


            SELECT COUNT(ie.idImpugnacionEmp) INTO temp_cantRegistros 
            FROM ihhimpugnacionemp ie
            INNER JOIN empleado emp ON (emp.idEmpleado = ie.idEmpleado AND emp.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhelementoimp ei ON (ei.idElementoImp = ie.idElemento AND ei.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhperiodo p ON (p.idPeriodo = ie.idPeriodo AND p.isActive = 1 AND ie.isActive = 1)
            WHERE 
            ie.idEmpleado = IN_idEmpleado AND
            ie.idElemento = IN_idElemento AND
            ie.idPeriodo = IN_idPeriodo AND
            ie.idAcop = IN_idAcop ;

            SELECT 
            ie.idImpugnacionEmp,
            ie.idEmpleado,
            UPPER(emp.nomEmpleado) nomEmpleado,
            ie.idElemento,
            UPPER(ei.nomElemento) nomElemento,
            temp_cantRegistros,
            ie.cantHorasPeriodo,
            ie.cantHorasExtra,
            ie.factor,
            ie.idAcop,
            UPPER(proy.nomProyecto) nomProyecto
            FROM ihhimpugnacionemp ie
            INNER JOIN empleado emp ON (emp.idEmpleado = ie.idEmpleado AND emp.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhelementoimp ei ON (ei.idElementoImp = ie.idElemento AND ei.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhperiodo p ON (p.idPeriodo = ie.idPeriodo AND p.isActive = 1 AND ie.isActive = 1)
            INNER JOIN ihhacop a ON (a.idAcop = ie.idAcop AND a.isActive = 1)
            INNER JOIN eddproyecto proy ON (proy.idEDDProyecto = a.idProyecto AND proy.isActive = 1)
            WHERE 
            ie.idEmpleado = IN_idEmpleado AND
            ie.idElemento = IN_idElemento AND
            ie.idPeriodo = IN_idPeriodo AND
            ie.idAcop = IN_idAcop  
            ORDER BY emp.nomEmpleado, ei.nomElemento
            LIMIT IN_inicio, IN_cantidadPorPagina;

        END IF;         
    END$$
DELIMITER ;