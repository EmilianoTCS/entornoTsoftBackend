BEGIN 

-- SI TODAS LAS VARIABLES SON NULAS, RETORNA TODOS LOS DATOS SIN FILTROS
CASE
    WHEN IN_idPais IS NULL
    OR IN_idPais = 0
    AND IN_idServicio IS NULL
    OR IN_idServicio = 0
    AND IN_idArea IS NULL
    OR IN_idArea = 0
    AND IN_idCargo IS NULL
    OR IN_idCargo = 0 THEN
    SET
        @temp_cantRegistros = (
            SELECT
                COUNT(idAlumno)
            FROM
                alumno
            WHERE
                isActive = true
        );

SELECT
    @temp_cantRegistros,
    alum.idAlumno,
    UPPER(alum.nomAlumno),
    UPPER(alum.correoAlumno),
    UPPER(alum.telefonoAlumno),
    UPPER(serv.nomServicio),
    UPPER(ar.nomArea),
    UPPER(pa.nomPais),
    UPPER(car.nomCargo)
FROM
    alumno alum
    INNER JOIN area ar ON (alum.idArea = ar.idArea)
    INNER JOIN pais pa ON (alum.idPais = pa.idPais)
    INNER JOIN cargo car ON (alum.idCargo = car.idCargo)
    INNER JOIN servicio serv ON (alum.idServicio = serv.idServicio)
WHERE
    alum.isActive = true
ORDER BY
    alum.nomAlumno ASC
LIMIT
    IN_inicio, IN_cantidadPorPagina;

-- SI TODAS LAS VARIABLES EXCEPTO PAIS SON NULAS
WHEN IN_idPais IS NOT NULL
OR IN_idPais != 0
AND IN_idServicio IS NULL
OR IN_idServicio = 0
AND IN_idArea IS NULL
OR IN_idArea = 0
AND IN_idCargo IS NULL
OR IN_idCargo = 0 THEN
SET
    @temp_cantRegistros = (
        SELECT
            COUNT(idAlumno)
        FROM
            alumno
        WHERE
            isActive = true
            AND idPais = IN_idPais
    );

SELECT
    @temp_cantRegistros,
    alum.idAlumno,
    UPPER(alum.nomAlumno),
    UPPER(alum.correoAlumno),
    UPPER(alum.telefonoAlumno),
    UPPER(serv.nomServicio),
    UPPER(ar.nomArea),
    UPPER(pa.nomPais),
    UPPER(car.nomCargo)
FROM
    alumno alum
    INNER JOIN area ar ON (alum.idArea = ar.idArea)
    INNER JOIN pais pa ON (alum.idPais = pa.idPais)
    INNER JOIN cargo car ON (alum.idCargo = car.idCargo)
    INNER JOIN servicio serv ON (alum.idServicio = serv.idServicio)
WHERE
    alum.isActive = true
    AND alum.idPais = IN_idPais
ORDER BY
    alum.nomAlumno ASC
LIMIT
    IN_inicio, IN_cantidadPorPagina;

-- SI TODAS LAS VARIABLES EXCEPTO SERVICIO SON NULAS
WHEN IN_idPais IS NULL
OR IN_idPais = 0
AND IN_idServicio IS NOT NULL
OR IN_idServicio != 0
AND IN_idArea IS NULL
OR IN_idArea = 0
AND IN_idCargo IS NULL
OR IN_idCargo = 0 THEN
SET
    @temp_cantRegistros = (
        SELECT
            COUNT(idAlumno)
        FROM
            alumno
        WHERE
            isActive = true
            AND idServicio = IN_idServicio
    );

SELECT
    @temp_cantRegistros,
    alum.idAlumno,
    UPPER(alum.nomAlumno),
    UPPER(alum.correoAlumno),
    UPPER(alum.telefonoAlumno),
    UPPER(serv.nomServicio),
    UPPER(ar.nomArea),
    UPPER(pa.nomPais),
    UPPER(car.nomCargo)
FROM
    alumno alum
    INNER JOIN area ar ON (alum.idArea = ar.idArea)
    INNER JOIN pais pa ON (alum.idPais = pa.idPais)
    INNER JOIN cargo car ON (alum.idCargo = car.idCargo)
    INNER JOIN servicio serv ON (alum.idServicio = serv.idServicio)
WHERE
    alum.isActive = true
    AND alum.idServicio = IN_idServicio
ORDER BY
    alum.nomAlumno ASC
LIMIT
    IN_inicio, IN_cantidadPorPagina;

-- SI TODAS LAS VARIABLES EXCEPTO AREA SON NULAS
WHEN IN_idPais IS NULL
OR IN_idPais = 0
AND IN_idServicio IS NULL
OR IN_idServicio = 0
AND IN_idArea IS NOT NULL
OR IN_idArea != 0
AND IN_idCargo IS NULL
OR IN_idCargo = 0 THEN
SET
    @temp_cantRegistros = (
        SELECT
            COUNT(idAlumno)
        FROM
            alumno
        WHERE
            isActive = true
            AND idArea = IN_idArea
    );

SELECT
    @temp_cantRegistros,
    alum.idAlumno,
    UPPER(alum.nomAlumno),
    UPPER(alum.correoAlumno),
    UPPER(alum.telefonoAlumno),
    UPPER(serv.nomServicio),
    UPPER(ar.nomArea),
    UPPER(pa.nomPais),
    UPPER(car.nomCargo)
FROM
    alumno alum
    INNER JOIN area ar ON (alum.idArea = ar.idArea)
    INNER JOIN pais pa ON (alum.idPais = pa.idPais)
    INNER JOIN cargo car ON (alum.idCargo = car.idCargo)
    INNER JOIN servicio serv ON (alum.idServicio = serv.idServicio)
WHERE
    alum.isActive = true
    AND alum.idArea = IN_idArea
ORDER BY
    alum.nomAlumno ASC
LIMIT
    IN_inicio, IN_cantidadPorPagina;

-- SI TODAS LAS VARIABLES EXCEPTO CARGO SON NULAS
WHEN IN_idPais IS NULL
OR IN_idPais = 0
AND IN_idServicio IS NULL
OR IN_idServicio = 0
AND IN_idArea IS NULL
OR IN_idArea = 0
AND IN_idCargo IS NOT NULL
OR IN_idCargo != 0 THEN
SET
    @temp_cantRegistros = (
        SELECT
            COUNT(idAlumno)
        FROM
            alumno
        WHERE
            isActive = true
            AND idCargo = IN_idCargo
    );

SELECT
    @temp_cantRegistros,
    alum.idAlumno,
    UPPER(alum.nomAlumno),
    UPPER(alum.correoAlumno),
    UPPER(alum.telefonoAlumno),
    UPPER(serv.nomServicio),
    UPPER(ar.nomArea),
    UPPER(pa.nomPais),
    UPPER(car.nomCargo)
FROM
    alumno alum
    INNER JOIN area ar ON (alum.idArea = ar.idArea)
    INNER JOIN pais pa ON (alum.idPais = pa.idPais)
    INNER JOIN cargo car ON (alum.idCargo = car.idCargo)
    INNER JOIN servicio serv ON (alum.idServicio = serv.idServicio)
WHERE
    alum.isActive = true
    AND alum.idCargo = IN_idCargo
ORDER BY
    alum.nomAlumno ASC
LIMIT
    IN_inicio, IN_cantidadPorPagina;

-- SI TODAS LAS VARIABLES EXCEPTO PAIS Y SERVICIO SON NULAS
WHEN IN_idPais IS NOT NULL
OR IN_idPais != 0
AND IN_idServicio IS NOT NULL
OR IN_idServicio != 0
AND IN_idArea IS NULL
OR IN_idArea = 0
AND IN_idCargo IS NULL
OR IN_idCargo = 0 THEN
SET
    @temp_cantRegistros = (
        SELECT
            COUNT(idAlumno)
        FROM
            alumno
        WHERE
            isActive = true
            AND idPais = IN_idPais
            AND idServicio = IN_idServicio
    );

SELECT
    @temp_cantRegistros,
    alum.idAlumno,
    UPPER(alum.nomAlumno),
    UPPER(alum.correoAlumno),
    UPPER(alum.telefonoAlumno),
    UPPER(serv.nomServicio),
    UPPER(ar.nomArea),
    UPPER(pa.nomPais),
    UPPER(car.nomCargo)
FROM
    alumno alum
    INNER JOIN area ar ON (alum.idArea = ar.idArea)
    INNER JOIN pais pa ON (alum.idPais = pa.idPais)
    INNER JOIN cargo car ON (alum.idCargo = car.idCargo)
    INNER JOIN servicio serv ON (alum.idServicio = serv.idServicio)
WHERE
    alum.isActive = true
    AND alum.idPais = IN_idPais
    AND alum.idServicio = IN_idServicio
ORDER BY
    alum.nomAlumno ASC
LIMIT
    IN_inicio, IN_cantidadPorPagina;

-- SI TODAS LAS VARIABLES EXCEPTO PAIS Y AREA SON NULAS
WHEN IN_idPais IS NOT NULL
OR IN_idPais != 0
AND IN_idServicio IS NULL
OR IN_idServicio = 0
AND IN_idArea IS NOT NULL
OR IN_idArea != 0
AND IN_idCargo IS NULL
OR IN_idCargo = 0 THEN
SET
    @temp_cantRegistros = (
        SELECT
            COUNT(idAlumno)
        FROM
            alumno
        WHERE
            isActive = true
            AND idPais = IN_idPais
            AND idArea = IN_idArea
    );

SELECT
    @temp_cantRegistros,
    alum.idAlumno,
    UPPER(alum.nomAlumno),
    UPPER(alum.correoAlumno),
    UPPER(alum.telefonoAlumno),
    UPPER(serv.nomServicio),
    UPPER(ar.nomArea),
    UPPER(pa.nomPais),
    UPPER(car.nomCargo)
FROM
    alumno alum
    INNER JOIN area ar ON (alum.idArea = ar.idArea)
    INNER JOIN pais pa ON (alum.idPais = pa.idPais)
    INNER JOIN cargo car ON (alum.idCargo = car.idCargo)
    INNER JOIN servicio serv ON (alum.idServicio = serv.idServicio)
WHERE
    alum.isActive = true
    AND alum.idPais = IN_idPais
    AND alum.idArea = IN_idArea
ORDER BY
    alum.nomAlumno ASC
LIMIT
    IN_inicio, IN_cantidadPorPagina;

-- SI TODAS LAS VARIABLES EXCEPTO PAIS Y CARGO SON NULAS
WHEN IN_idPais IS NOT NULL
OR IN_idPais != 0
AND IN_idServicio IS NULL
OR IN_idServicio = 0
AND IN_idArea IS NULL
OR IN_idArea = 0
AND IN_idCargo IS NOT NULL
OR IN_idCargo != 0 THEN
SET
    @temp_cantRegistros = (
        SELECT
            COUNT(idAlumno)
        FROM
            alumno
        WHERE
            isActive = true
            AND idPais = IN_idPais
            AND idCargo = IN_idCargo
    );

SELECT
    @temp_cantRegistros,
    alum.idAlumno,
    UPPER(alum.nomAlumno),
    UPPER(alum.correoAlumno),
    UPPER(alum.telefonoAlumno),
    UPPER(serv.nomServicio),
    UPPER(ar.nomArea),
    UPPER(pa.nomPais),
    UPPER(car.nomCargo)
FROM
    alumno alum
    INNER JOIN area ar ON (alum.idArea = ar.idArea)
    INNER JOIN pais pa ON (alum.idPais = pa.idPais)
    INNER JOIN cargo car ON (alum.idCargo = car.idCargo)
    INNER JOIN servicio serv ON (alum.idServicio = serv.idServicio)
WHERE
    alum.isActive = true
    AND alum.idPais = IN_idPais
    AND alum.idCargo = IN_idCargo
ORDER BY
    alum.nomAlumno ASC
LIMIT
    IN_inicio, IN_cantidadPorPagina;

-- --> SI TODAS LAS VARIABLES EXCEPTO SERVICIO Y PAIS SON NULAS --> SE REPITE LA MISMA OPERACION QUE EN PAIS - SERVICIO, POR LO TANTO SE OMITE.
-- SI TODAS LAS VARIABLES EXCEPTO SERVICIO Y AREA SON NULAS
WHEN IN_idPais IS NULL
OR IN_idPais = 0
AND IN_idServicio IS NOT NULL
OR IN_idServicio != 0
AND IN_idArea IS NOT NULL
OR IN_idArea != 0
AND IN_idCargo IS NULL
OR IN_idCargo = 0 THEN
SET
    @temp_cantRegistros = (
        SELECT
            COUNT(idAlumno)
        FROM
            alumno
        WHERE
            isActive = true
            AND idServicio = IN_idServicio
            AND idArea = IN_idArea
    );

SELECT
    @temp_cantRegistros,
    alum.idAlumno,
    UPPER(alum.nomAlumno),
    UPPER(alum.correoAlumno),
    UPPER(alum.telefonoAlumno),
    UPPER(serv.nomServicio),
    UPPER(ar.nomArea),
    UPPER(pa.nomPais),
    UPPER(car.nomCargo)
FROM
    alumno alum
    INNER JOIN area ar ON (alum.idArea = ar.idArea)
    INNER JOIN pais pa ON (alum.idPais = pa.idPais)
    INNER JOIN cargo car ON (alum.idCargo = car.idCargo)
    INNER JOIN servicio serv ON (alum.idServicio = serv.idServicio)
WHERE
    alum.isActive = true
    AND alum.idServicio = IN_idServicio
    AND alum.idArea = IN_idArea
ORDER BY
    alum.nomAlumno ASC
LIMIT
    IN_inicio, IN_cantidadPorPagina;

-- SI TODAS LAS VARIABLES EXCEPTO SERVICIO Y CARGO SON NULAS
WHEN IN_idPais IS NULL
OR IN_idPais = 0
AND IN_idServicio IS NOT NULL
OR IN_idServicio != 0
AND IN_idArea IS NULL
OR IN_idArea = 0
AND IN_idCargo IS NOT NULL
OR IN_idCargo != 0 THEN
SET
    @temp_cantRegistros = (
        SELECT
            COUNT(idAlumno)
        FROM
            alumno
        WHERE
            isActive = true
            AND idServicio = IN_idServicio
            AND idCargo = IN_idCargo
    );

SELECT
    @temp_cantRegistros,
    alum.idAlumno,
    UPPER(alum.nomAlumno),
    UPPER(alum.correoAlumno),
    UPPER(alum.telefonoAlumno),
    UPPER(serv.nomServicio),
    UPPER(ar.nomArea),
    UPPER(pa.nomPais),
    UPPER(car.nomCargo)
FROM
    alumno alum
    INNER JOIN area ar ON (alum.idArea = ar.idArea)
    INNER JOIN pais pa ON (alum.idPais = pa.idPais)
    INNER JOIN cargo car ON (alum.idCargo = car.idCargo)
    INNER JOIN servicio serv ON (alum.idServicio = serv.idServicio)
WHERE
    alum.isActive = true
    AND alum.idServicio = IN_idServicio
    AND alum.idCargo = IN_idCargo
ORDER BY
    alum.nomAlumno ASC
LIMIT
    IN_inicio, IN_cantidadPorPagina;

-- SI TODAS LAS VARIABLES EXCEPTO AREA Y CARGO SON NULAS
WHEN IN_idPais IS NULL
OR IN_idPais = 0
AND IN_idServicio IS NULL
OR IN_idServicio = 0
AND IN_idArea IS NOT NULL
OR IN_idArea != 0
AND IN_idCargo IS NOT NULL
OR IN_idCargo != 0 THEN
SET
    @temp_cantRegistros = (
        SELECT
            COUNT(idAlumno)
        FROM
            alumno
        WHERE
            isActive = true
            AND idArea = IN_idArea
            AND idCargo = IN_idCargo
    );

SELECT
    @temp_cantRegistros,
    alum.idAlumno,
    UPPER(alum.nomAlumno),
    UPPER(alum.correoAlumno),
    UPPER(alum.telefonoAlumno),
    UPPER(serv.nomServicio),
    UPPER(ar.nomArea),
    UPPER(pa.nomPais),
    UPPER(car.nomCargo)
FROM
    alumno alum
    INNER JOIN area ar ON (alum.idArea = ar.idArea)
    INNER JOIN pais pa ON (alum.idPais = pa.idPais)
    INNER JOIN cargo car ON (alum.idCargo = car.idCargo)
    INNER JOIN servicio serv ON (alum.idServicio = serv.idServicio)
WHERE
    alum.isActive = true
    AND alum.idArea = IN_idArea
    AND alum.idCargo = IN_idCargo
ORDER BY
    alum.nomAlumno ASC
LIMIT
    IN_inicio, IN_cantidadPorPagina;

-- SI TODAS LAS VARIABLES EXCEPTO SERVICIO AREA Y CARGO SON NULAS
WHEN IN_idPais IS NULL
OR IN_idPais = 0
AND IN_idServicio IS NOT NULL
OR IN_idServicio != 0
AND IN_idArea IS NOT NULL
OR IN_idArea != 0
AND IN_idCargo IS NOT NULL
OR IN_idCargo != 0 THEN
SET
    @temp_cantRegistros = (
        SELECT
            COUNT(idAlumno)
        FROM
            alumno
        WHERE
            isActive = true
            AND idServicio = IN_idServicio
            AND idArea = IN_idArea
            AND idCargo = IN_idCargo
    );

SELECT
    @temp_cantRegistros,
    alum.idAlumno,
    UPPER(alum.nomAlumno),
    UPPER(alum.correoAlumno),
    UPPER(alum.telefonoAlumno),
    UPPER(serv.nomServicio),
    UPPER(ar.nomArea),
    UPPER(pa.nomPais),
    UPPER(car.nomCargo)
FROM
    alumno alum
    INNER JOIN area ar ON (alum.idArea = ar.idArea)
    INNER JOIN pais pa ON (alum.idPais = pa.idPais)
    INNER JOIN cargo car ON (alum.idCargo = car.idCargo)
    INNER JOIN servicio serv ON (alum.idServicio = serv.idServicio)
WHERE
    alum.isActive = true
    AND alum.idArea = IN_idArea
    AND alum.idCargo = IN_idCargo
    AND alum.idServicio = IN_idServicio
ORDER BY
    alum.nomAlumno ASC
LIMIT
    IN_inicio, IN_cantidadPorPagina;

-- SI TODAS LAS VARIABLES EXCEPTO PAIS, AREA Y CARGO SON NULAS
WHEN IN_idPais IS NOT NULL
OR IN_idPais != 0
AND IN_idServicio IS NULL
OR IN_idServicio = 0
AND IN_idArea IS NOT NULL
OR IN_idArea != 0
AND IN_idCargo IS NOT NULL
OR IN_idCargo != 0 THEN
SET
    @temp_cantRegistros = (
        SELECT
            COUNT(idAlumno)
        FROM
            alumno
        WHERE
            isActive = true
            AND idPais = IN_idPais
            AND idArea = IN_idArea
            AND idCargo = IN_idCargo
    );

SELECT
    @temp_cantRegistros,
    alum.idAlumno,
    UPPER(alum.nomAlumno),
    UPPER(alum.correoAlumno),
    UPPER(alum.telefonoAlumno),
    UPPER(serv.nomServicio),
    UPPER(ar.nomArea),
    UPPER(pa.nomPais),
    UPPER(car.nomCargo)
FROM
    alumno alum
    INNER JOIN area ar ON (alum.idArea = ar.idArea)
    INNER JOIN pais pa ON (alum.idPais = pa.idPais)
    INNER JOIN cargo car ON (alum.idCargo = car.idCargo)
    INNER JOIN servicio serv ON (alum.idServicio = serv.idServicio)
WHERE
    alum.isActive = true
    AND alum.idArea = IN_idArea
    AND alum.idCargo = IN_idCargo
    AND alum.idPais = IN_idPais
ORDER BY
    alum.nomAlumno ASC
LIMIT
    IN_inicio, IN_cantidadPorPagina;

-- SI TODAS LAS VARIABLES EXCEPTO PAIS, SERVICIO Y CARGO SON NULAS
WHEN IN_idPais IS NOT NULL
OR IN_idPais != 0
AND IN_idServicio IS NOT NULL
OR IN_idServicio != 0
AND IN_idArea IS NULL
OR IN_idArea = 0
AND IN_idCargo IS NOT NULL
OR IN_idCargo != 0 THEN
SET
    @temp_cantRegistros = (
        SELECT
            COUNT(idAlumno)
        FROM
            alumno
        WHERE
            isActive = true
            AND idPais = IN_idPais
            AND idServicio = IN_idServicio
            AND idCargo = IN_idCargo
    );

SELECT
    @temp_cantRegistros,
    alum.idAlumno,
    UPPER(alum.nomAlumno),
    UPPER(alum.correoAlumno),
    UPPER(alum.telefonoAlumno),
    UPPER(serv.nomServicio),
    UPPER(ar.nomArea),
    UPPER(pa.nomPais),
    UPPER(car.nomCargo)
FROM
    alumno alum
    INNER JOIN area ar ON (alum.idArea = ar.idArea)
    INNER JOIN pais pa ON (alum.idPais = pa.idPais)
    INNER JOIN cargo car ON (alum.idCargo = car.idCargo)
    INNER JOIN servicio serv ON (alum.idServicio = serv.idServicio)
WHERE
    alum.isActive = true
    AND alum.idServicio = IN_idServicio
    AND alum.idCargo = IN_idCargo
    AND alum.idPais = IN_idPais
ORDER BY
    alum.nomAlumno ASC
LIMIT
    IN_inicio, IN_cantidadPorPagina;

-- SI TODAS LAS VARIABLES EXCEPTO PAIS, SERVICIO Y AREA SON NULAS
WHEN IN_idPais IS NOT NULL
OR IN_idPais != 0
AND IN_idServicio IS NOT NULL
OR IN_idServicio != 0
AND IN_idArea IS NOT NULL
OR IN_idArea != 0
AND IN_idCargo IS NULL
OR IN_idCargo = 0 THEN
SET
    @temp_cantRegistros = (
        SELECT
            COUNT(idAlumno)
        FROM
            alumno
        WHERE
            isActive = true
            AND idPais = IN_idPais
            AND idServicio = IN_idServicio
            AND idArea = IN_idArea
    );

SELECT
    @temp_cantRegistros,
    alum.idAlumno,
    UPPER(alum.nomAlumno),
    UPPER(alum.correoAlumno),
    UPPER(alum.telefonoAlumno),
    UPPER(serv.nomServicio),
    UPPER(ar.nomArea),
    UPPER(pa.nomPais),
    UPPER(car.nomCargo)
FROM
    alumno alum
    INNER JOIN area ar ON (alum.idArea = ar.idArea)
    INNER JOIN pais pa ON (alum.idPais = pa.idPais)
    INNER JOIN cargo car ON (alum.idCargo = car.idCargo)
    INNER JOIN servicio serv ON (alum.idServicio = serv.idServicio)
WHERE
    alum.isActive = true
    AND alum.idServicio = IN_idServicio
    AND alum.idArea = IN_idArea
    AND alum.idPais = IN_idPais
ORDER BY
    alum.nomAlumno ASC
LIMIT
    IN_inicio, IN_cantidadPorPagina;

-- SI NINGUNA VARIABLE ES NULA
WHEN IN_idPais IS NOT NULL
OR IN_idPais != 0
AND IN_idServicio IS NOT NULL
OR IN_idServicio != 0
AND IN_idArea IS NOT NULL
OR IN_idArea != 0
AND IN_idCargo IS NOT NULL
OR IN_idCargo != 0 THEN
SET
    @temp_cantRegistros = (
        SELECT
            COUNT(idAlumno)
        FROM
            alumno
        WHERE
            isActive = true
            AND idPais = IN_idPais
            AND idServicio = IN_idServicio
            AND idArea = IN_idArea
            AND idCargo = IN_idCargo
    );

SELECT
    @temp_cantRegistros,
    alum.idAlumno,
    UPPER(alum.nomAlumno),
    UPPER(alum.correoAlumno),
    UPPER(alum.telefonoAlumno),
    UPPER(serv.nomServicio),
    UPPER(ar.nomArea),
    UPPER(pa.nomPais),
    UPPER(car.nomCargo)
FROM
    alumno alum
    INNER JOIN area ar ON (alum.idArea = ar.idArea)
    INNER JOIN pais pa ON (alum.idPais = pa.idPais)
    INNER JOIN cargo car ON (alum.idCargo = car.idCargo)
    INNER JOIN servicio serv ON (alum.idServicio = serv.idServicio)
WHERE
    alum.isActive = true
    AND alum.idServicio = IN_idServicio
    AND alum.idArea = IN_idArea
    AND alum.idPais = IN_idPais
    AND alum.idCargo = IN_idCargo
ORDER BY
    alum.nomAlumno ASC
LIMIT
    IN_inicio, IN_cantidadPorPagina;

END CASE;

END 


--------------------------------------------------------------------
BEGIN
SET
    @temp_cantRegistros = (
        SELECT
            COUNT(idAlumno)
        FROM
            alumno
        WHERE
            isActive = true
    );

SELECT
    @temp_cantRegistros,
    alum.idAlumno,
    UPPER(alum.nomAlumno),
    UPPER(alum.correoAlumno),
    UPPER(alum.telefonoAlumno),
    UPPER(serv.nomServicio),
    UPPER(ar.nomArea),
    UPPER(pa.nomPais),
    UPPER(car.nomCargo)
FROM
    alumno alum
    INNER JOIN area ar ON (alum.idArea = ar.idArea)
    INNER JOIN pais pa ON (alum.idPais = pa.idPais)
    INNER JOIN cargo car ON (alum.idCargo = car.idCargo)
    INNER JOIN servicio serv ON (alum.idServicio = serv.idServicio)
WHERE
    alum.isActive = true
ORDER BY
    alum.nomAlumno ASC
LIMIT
    IN_inicio, IN_cantidadPorPagina;

END ----------------------------------------------------------