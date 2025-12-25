    -- Eliminar el procedimiento almacenado si ya existe
    DROP PROCEDURE IF EXISTS `SP_ihh_listadoElementoImp`;

    -- Cambiar el delimitador para manejar la creación del procedimiento
    DELIMITER $$

    -- Crear el procedimiento almacenado
    CREATE PROCEDURE `SP_ihh_listadoElementoImp`(
        IN `IN_idTipoElemento` INT, 
        IN `IN_inicio` INT, 
        IN `IN_cantidadPorPagina` INT)
    BEGIN
        DECLARE temp_cantRegistros INT;


        -- Verificar si no se especifica un tipo de elemento
        IF IN_idTipoElemento = 0 THEN
            -- Recuperar los datos de todos los elementos de importancia

            SELECT COUNT(ei.idElementoImp) INTO temp_cantRegistros 
            FROM ihhelementoimp ei
            INNER JOIN ihhtipoelemento te ON (
                te.idTipoElemento = ei.idTipoElemento 
                AND ei.isActive = 1 
                AND te.isActive = 1);
        
            SELECT 
                temp_cantRegistros,
                ei.idElementoImp, 
                ei.idTipoElemento, 
                UPPER(te.nomTipoElemento) nomTipoElemento, 
                UPPER(ei.nomElemento) nomElemento, 
                UPPER(ei.descripcion) descripcion 
            FROM ihhelementoimp ei
            INNER JOIN ihhtipoelemento te ON (
                te.idTipoElemento = ei.idTipoElemento 
                AND ei.isActive = 1 
                AND te.isActive = 1) 
            ORDER BY ei.nomElemento, te.nomTipoElemento
            LIMIT IN_inicio, IN_cantidadPorPagina;

        -- Si se especifica un tipo de elemento
        ELSE
            -- Recuperar los datos de los elementos del tipo especificado   
            SELECT COUNT(ei.idElementoImp) INTO temp_cantRegistros 
            FROM ihhelementoImp ei
            INNER JOIN ihhtipoelemento te ON (
                te.idTipoElemento = ei.idTipoElemento 
                AND te.idTipoElemento = IN_idTipoElemento 
                AND ei.isActive = 1 
                AND te.isActive = 1);
        
            SELECT 
                temp_cantRegistros,
                ei.idElementoImp, 
                ei.idTipoElemento, 
                UPPER(te.nomTipoElemento) nomTipoElemento, 
                UPPER(ei.nomElemento) nomElemento, 
                UPPER(ei.descripcion) descripcion 
            FROM ihhelementoImp ei
            INNER JOIN ihhtipoelemento te ON (
                te.idTipoElemento = ei.idTipoElemento 
                AND te.idTipoElemento = IN_idTipoElemento 
                AND ei.isActive = 1 
                AND te.isActive = 1) 
            ORDER BY ei.nomElemento, te.nomTipoElemento
            LIMIT IN_inicio, IN_cantidadPorPagina;   
        END IF;         
    END $$

    -- Restaurar el delimitador por defecto
    DELIMITER ;
