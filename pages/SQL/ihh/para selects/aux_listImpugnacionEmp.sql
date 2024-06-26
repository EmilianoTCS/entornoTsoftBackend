DROP PROCEDURE IF EXISTS `SP_ihh_aux_listadoImpugnacionEmp`;
DELIMITER $$
CREATE PROCEDURE `SP_ihh_aux_listadoImpugnacionEmp`(
    OUT `OUT_CODRESULT` CHAR(2), 
    OUT `OUT_MJERESULT` VARCHAR(200))

BEGIN
        SET OUT_CODRESULT = "00";
        SET OUT_MJERESULT = "Operación exitosa.";
        
           SELECT 
           OUT_CODRESULT, OUT_MJERESULT,
           ie.idImpugnacionEmp,
           CONCAT (UPPER(emp.nomEmpleado), ' - ', UPPER(p.nomProyecto), ' - ', UPPER(per.nomPeriodo)) nomImpugnacionEmp
           FROM ihhimpugnacionemp ie
           INNER JOIN empleado emp ON (emp.idEmpleado = ie.idEmpleado AND emp.isActive = 1 AND ie.isActive = 1)
           INNER JOIN ihhacop a ON (a.idAcop = ie.idAcop AND a.isActive = 1)
           INNER JOIN eddproyecto p ON (p.idEDDProyecto = a.idProyecto AND p.isActive = 1)
           INNER JOIN ihhperiodo per ON (per.idPeriodo = ie.idPeriodo AND per.isActive = 1);
        
    END$$
DELIMITER ;