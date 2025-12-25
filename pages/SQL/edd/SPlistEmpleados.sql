BEGIN CASE
    -- CUANDO TODAS LAS VARIABLES SON NULAS
    WHEN IN_idPais = 0
    AND IN_idArea = 0
    AND IN_idCargo = 0 THEN
    SET
        @temp_cantRegistros = (
            SELECT
                COUNT(idEmpleado)
            FROM
                empleado
            WHERE
                isActive = true
        );

SELECT
    @temp_cantRegistros,
    emp.idEmpleado,
    UPPER(emp.nomEmpleado),
    UPPER(emp.correoEmpleado),
    emp.telefonoEmpleado,
    UPPER(ar.nomArea),
    UPPER(pa.nomPais),
    UPPER(ca.nomCargo)
FROM
    empleado emp
    INNER JOIN area ar ON (emp.idArea = ar.idArea)
    INNER JOIN pais pa ON (emp.idPais = pa.idPais)
    INNER JOIN cargo ca ON (emp.idCargo = ca.idCargo)
WHERE
    emp.isActive = true
ORDER BY
    emp.nomEmpleado ASC
LIMIT
    IN_inicio, IN_cantidadPorPagina;

-- CUANDO TODAS SON NULAS EXCEPTO PAIS
WHEN IN_idPais != 0
AND IN_idArea = 0
AND IN_idCargo = 0 THEN
SET
    @temp_cantRegistros = (
        SELECT
            COUNT(idEmpleado)
        FROM
            empleado
        WHERE
            isActive = true
            AND idPais = IN_idPais
    );

SELECT
    @temp_cantRegistros,
    emp.idEmpleado,
    UPPER(emp.nomEmpleado),
    UPPER(emp.correoEmpleado),
    emp.telefonoEmpleado,
    UPPER(ar.nomArea),
    UPPER(pa.nomPais),
    UPPER(ca.nomCargo)
FROM
    empleado emp
    INNER JOIN area ar ON (emp.idArea = ar.idArea)
    INNER JOIN pais pa ON (emp.idPais = pa.idPais)
    INNER JOIN cargo ca ON (emp.idCargo = ca.idCargo)
WHERE
    emp.isActive = true
    AND emp.idPais = IN_idPais
ORDER BY
    emp.nomEmpleado ASC
LIMIT
    IN_inicio, IN_cantidadPorPagina;

-- CUANDO TODAS SON NULAS EXCEPTO AREA
WHEN IN_idPais = 0
AND IN_idArea != 0
AND IN_idCargo = 0 THEN
SET
    @temp_cantRegistros = (
        SELECT
            COUNT(idEmpleado)
        FROM
            empleado
        WHERE
            isActive = true
            AND idArea = IN_idArea
    );

SELECT
    @temp_cantRegistros,
    emp.idEmpleado,
    UPPER(emp.nomEmpleado),
    UPPER(emp.correoEmpleado),
    emp.telefonoEmpleado,
    UPPER(ar.nomArea),
    UPPER(pa.nomPais),
    UPPER(ca.nomCargo)
FROM
    empleado emp
    INNER JOIN area ar ON (emp.idArea = ar.idArea)
    INNER JOIN pais pa ON (emp.idPais = pa.idPais)
    INNER JOIN cargo ca ON (emp.idCargo = ca.idCargo)
WHERE
    emp.isActive = true
    AND emp.idArea = IN_idArea
ORDER BY
    emp.nomEmpleado ASC
LIMIT
    IN_inicio, IN_cantidadPorPagina;

-- CUANDO TODAS SON NULAS EXCEPTO CARGO
WHEN IN_idPais = 0
AND IN_idArea = 0
AND IN_idCargo != 0 THEN
SET
    @temp_cantRegistros = (
        SELECT
            COUNT(idEmpleado)
        FROM
            empleado
        WHERE
            isActive = true
            AND idCargo = IN_idCargo
    );

SELECT
    @temp_cantRegistros,
    emp.idEmpleado,
    UPPER(emp.nomEmpleado),
    UPPER(emp.correoEmpleado),
    emp.telefonoEmpleado,
    UPPER(ar.nomArea),
    UPPER(pa.nomPais),
    UPPER(ca.nomCargo)
FROM
    empleado emp
    INNER JOIN area ar ON (emp.idArea = ar.idArea)
    INNER JOIN pais pa ON (emp.idPais = pa.idPais)
    INNER JOIN cargo ca ON (emp.idCargo = ca.idCargo)
WHERE
    emp.isActive = true
    AND emp.idCargo = IN_idCargo
ORDER BY
    emp.nomEmpleado ASC
LIMIT
    IN_inicio, IN_cantidadPorPagina;

-- CUANDO TODAS SON NULAS EXCEPTO PAIS Y AREA
WHEN IN_idPais != 0
AND IN_idArea != 0
AND IN_idCargo = 0 THEN
SET
    @temp_cantRegistros = (
        SELECT
            COUNT(idEmpleado)
        FROM
            empleado
        WHERE
            isActive = true
            AND idPais = IN_idPais
            AND idArea = IN_idArea
    );

SELECT
    @temp_cantRegistros,
    emp.idEmpleado,
    UPPER(emp.nomEmpleado),
    UPPER(emp.correoEmpleado),
    emp.telefonoEmpleado,
    UPPER(ar.nomArea),
    UPPER(pa.nomPais),
    UPPER(ca.nomCargo)
FROM
    empleado emp
    INNER JOIN area ar ON (emp.idArea = ar.idArea)
    INNER JOIN pais pa ON (emp.idPais = pa.idPais)
    INNER JOIN cargo ca ON (emp.idCargo = ca.idCargo)
WHERE
    emp.isActive = true
    AND emp.idPais = IN_idPais
    AND emp.idArea = IN_idArea
ORDER BY
    emp.nomEmpleado ASC
LIMIT
    IN_inicio, IN_cantidadPorPagina;

-- CUANDO TODAS SON NULAS EXCEPTO PAIS Y CARGO
WHEN IN_idPais != 0
AND IN_idArea = 0
AND IN_idCargo != 0 THEN
SET
    @temp_cantRegistros = (
        SELECT
            COUNT(idEmpleado)
        FROM
            empleado
        WHERE
            isActive = true
            AND idPais = IN_idPais
            AND idCargo = IN_idCargo
    );

SELECT
    @temp_cantRegistros,
    emp.idEmpleado,
    UPPER(emp.nomEmpleado),
    UPPER(emp.correoEmpleado),
    emp.telefonoEmpleado,
    UPPER(ar.nomArea),
    UPPER(pa.nomPais),
    UPPER(ca.nomCargo)
FROM
    empleado emp
    INNER JOIN area ar ON (emp.idArea = ar.idArea)
    INNER JOIN pais pa ON (emp.idPais = pa.idPais)
    INNER JOIN cargo ca ON (emp.idCargo = ca.idCargo)
WHERE
    emp.isActive = true
    AND emp.idPais = IN_idPais
    AND emp.idCargo = IN_idCargo
ORDER BY
    emp.nomEmpleado ASC
LIMIT
    IN_inicio, IN_cantidadPorPagina;

-- CUANDO TODAS SON NULAS EXCEPTO AREA Y CARGO
WHEN IN_idPais = 0
AND IN_idArea != 0
AND IN_idCargo != 0 THEN
SET
    @temp_cantRegistros = (
        SELECT
            COUNT(idEmpleado)
        FROM
            empleado
        WHERE
            isActive = true
            AND idArea = IN_idArea
            AND idCargo = IN_idCargo
    );

SELECT
    @temp_cantRegistros,
    emp.idEmpleado,
    UPPER(emp.nomEmpleado),
    UPPER(emp.correoEmpleado),
    emp.telefonoEmpleado,
    UPPER(ar.nomArea),
    UPPER(pa.nomPais),
    UPPER(ca.nomCargo)
FROM
    empleado emp
    INNER JOIN area ar ON (emp.idArea = ar.idArea)
    INNER JOIN pais pa ON (emp.idPais = pa.idPais)
    INNER JOIN cargo ca ON (emp.idCargo = ca.idCargo)
WHERE
    emp.isActive = true
    AND emp.idArea = IN_idArea
    AND emp.idCargo = IN_idCargo
ORDER BY
    emp.nomEmpleado ASC
LIMIT
    IN_inicio, IN_cantidadPorPagina;

-- CUANDO NINGUNA ES NULA
WHEN IN_idPais != 0
AND IN_idArea != 0
AND IN_idCargo != 0 THEN
SET
    @temp_cantRegistros = (
        SELECT
            COUNT(idEmpleado)
        FROM
            empleado
        WHERE
            isActive = true
            AND idArea = IN_idArea
            AND idCargo = IN_idCargo
            AND idPais = IN_idPais
    );

SELECT
    @temp_cantRegistros,
    emp.idEmpleado,
    UPPER(emp.nomEmpleado),
    UPPER(emp.correoEmpleado),
    emp.telefonoEmpleado,
    UPPER(ar.nomArea),
    UPPER(pa.nomPais),
    UPPER(ca.nomCargo)
FROM
    empleado emp
    INNER JOIN area ar ON (emp.idArea = ar.idArea)
    INNER JOIN pais pa ON (emp.idPais = pa.idPais)
    INNER JOIN cargo ca ON (emp.idCargo = ca.idCargo)
WHERE
    emp.isActive = true
    AND emp.idArea = IN_idArea
    AND emp.idCargo = IN_idCargo
    AND emp.idPais = IN_idPais
ORDER BY
    emp.nomEmpleado ASC
LIMIT
    IN_inicio, IN_cantidadPorPagina;

END CASE
;

END