BEGIN -- si ninguna es nula
IF IN_idEDDEvaluacion = 0
AND IN_idEDDEvalCompetencia = 0
AND IN_idEDDEvalPregunta = 0 THEN
SET
    @temp_cantRegistros = (
        SELECT
            COUNT(idEDDEvalPregunta)
        FROM
            eddevalpregunta
        WHERE
            isActive = true
    );

SELECT
    @temp_cantRegistros,
    preg.idEDDEvalPregunta,
    UPPER(preg.nomPregunta) as nomPregunta,
    preg.ordenPregunta,
    preg.idEDDEvaluacion,
    preg.idEDDEvalCompetencia,
    UPPER(eval.nomEvaluacion) as nomEvaluacion,
    UPPER(comp.nomCompetencia) as nomCompetencia
FROM
    eddevalpregunta preg
    INNER JOIN eddevaluacion eval ON (preg.idEDDEvaluacion = eval.idEDDEvaluacion)
    INNER JOIN eddevalcompetencia comp ON (
        preg.idEDDEvalCompetencia = comp.idEDDEvalCompetencia
    )
WHERE
    preg.isActive = true
ORDER BY
    preg.nomPregunta,
    eval.nomEvaluacion,
    comp.nomCompetencia ASC
LIMIT
    IN_inicio, IN_cantidadPorPagina;

-- si idEDDEvaluacion no es nulo    	
ELSEIF IN_idEDDEvaluacion != 0
AND IN_idEDDEvalCompetencia = 0
AND IN_idEDDEvalPregunta = 0 THEN
SET
    @temp_cantRegistros = (
        SELECT
            COUNT(idEDDEvalPregunta)
        FROM
            eddevalpregunta
        WHERE
            isActive = true
            AND idEDDEvaluacion = IN_idEDDEvaluacion
    );

SELECT
    @temp_cantRegistros,
    preg.idEDDEvalPregunta,
    UPPER(preg.nomPregunta) as nomPregunta,
    preg.ordenPregunta,
    preg.idEDDEvaluacion,
    preg.idEDDEvalCompetencia,
    UPPER(eval.nomEvaluacion) as nomEvaluacion,
    UPPER(comp.nomCompetencia) as nomCompetencia
FROM
    eddevalpregunta preg
    INNER JOIN eddevaluacion eval ON (preg.idEDDEvaluacion = eval.idEDDEvaluacion)
    INNER JOIN eddevalcompetencia comp ON (
        preg.idEDDEvalCompetencia = comp.idEDDEvalCompetencia
    )
WHERE
    preg.isActive = true
    AND preg.idEDDEvaluacion = IN_idEDDEvaluacion
ORDER BY
    preg.nomPregunta,
    eval.nomEvaluacion,
    comp.nomCompetencia ASC
LIMIT
    IN_inicio, IN_cantidadPorPagina;

-- si idEDDEvalCompetencia no es nulo   
ELSEIF IN_idEDDEvaluacion = 0
AND IN_idEDDEvalCompetencia != 0
AND IN_idEDDEvalPregunta = 0 THEN
SET
    @temp_cantRegistros = (
        SELECT
            COUNT(idEDDEvalPregunta)
        FROM
            eddevalpregunta
        WHERE
            isActive = true
            AND idEDDEvalCompetencia = IN_idEDDEvalCompetencia
    );

SELECT
    @temp_cantRegistros,
    preg.idEDDEvalPregunta,
    UPPER(preg.nomPregunta) as nomPregunta,
    preg.ordenPregunta,
    preg.idEDDEvaluacion,
    preg.idEDDEvalCompetencia,
    UPPER(eval.nomEvaluacion) as nomEvaluacion,
    UPPER(comp.nomCompetencia) as nomCompetencia
FROM
    eddevalpregunta preg
    INNER JOIN eddevaluacion eval ON (preg.idEDDEvaluacion = eval.idEDDEvaluacion)
    INNER JOIN eddevalcompetencia comp ON (
        preg.idEDDEvalCompetencia = comp.idEDDEvalCompetencia
    )
WHERE
    preg.isActive = true
    AND preg.idEDDEvalCompetencia = IN_idEDDEvalCompetencia
ORDER BY
    preg.nomPregunta,
    eval.nomEvaluacion,
    comp.nomCompetencia ASC
LIMIT
    IN_inicio, IN_cantidadPorPagina;


-- si IN_idEDDEvalPregunta no es nulo   
ELSEIF IN_idEDDEvaluacion = 0
AND IN_idEDDEvalCompetencia = 0
AND IN_idEDDEvalPregunta != 0 THEN
SET
    @temp_cantRegistros = (
        SELECT
            COUNT(idEDDEvalPregunta)
        FROM
            eddevalpregunta
        WHERE
            isActive = true
            AND idEDDEvalPregunta = IN_idEDDEvalPregunta
    );

SELECT
    @temp_cantRegistros,
    preg.idEDDEvalPregunta,
    UPPER(preg.nomPregunta) as nomPregunta,
    preg.ordenPregunta,
    preg.idEDDEvaluacion,
    preg.idEDDEvalCompetencia,
    UPPER(eval.nomEvaluacion) as nomEvaluacion,
    UPPER(comp.nomCompetencia) as nomCompetencia
FROM
    eddevalpregunta preg
    INNER JOIN eddevaluacion eval ON (preg.idEDDEvaluacion = eval.idEDDEvaluacion)
    INNER JOIN eddevalcompetencia comp ON (
        preg.idEDDEvalCompetencia = comp.idEDDEvalCompetencia
    )
WHERE
    preg.isActive = true
    AND preg.idEDDEvalPregunta = IN_idEDDEvalPregunta
ORDER BY
    preg.nomPregunta,
    eval.nomEvaluacion,
    comp.nomCompetencia ASC
LIMIT
    IN_inicio, IN_cantidadPorPagina;


-- si IN_idEDDEvaluacion y IN_idEDDEvalCompetencia no son nulas   
ELSEIF IN_idEDDEvaluacion != 0
AND IN_idEDDEvalCompetencia != 0
AND IN_idEDDEvalPregunta = 0 THEN
SET
    @temp_cantRegistros = (
        SELECT
            COUNT(idEDDEvalPregunta)
        FROM
            eddevalpregunta
        WHERE
            isActive = true
            AND idEDDEvaluacion = IN_idEDDEvaluacion
            AND idEDDEvalCompetencia = IN_idEDDEvalCompetencia
    );

SELECT
    @temp_cantRegistros,
    preg.idEDDEvalPregunta,
    UPPER(preg.nomPregunta) as nomPregunta,
    preg.ordenPregunta,
    preg.idEDDEvaluacion,
    preg.idEDDEvalCompetencia,
    UPPER(eval.nomEvaluacion) as nomEvaluacion,
    UPPER(comp.nomCompetencia) as nomCompetencia
FROM
    eddevalpregunta preg
    INNER JOIN eddevaluacion eval ON (preg.idEDDEvaluacion = eval.idEDDEvaluacion)
    INNER JOIN eddevalcompetencia comp ON (
        preg.idEDDEvalCompetencia = comp.idEDDEvalCompetencia
    )
WHERE
    preg.isActive = true
    AND preg.idEDDEvaluacion = IN_idEDDEvaluacion
    AND preg.idEDDEvalCompetencia = IN_idEDDEvalCompetencia
ORDER BY
    preg.nomPregunta,
    eval.nomEvaluacion,
    comp.nomCompetencia ASC
LIMIT
    IN_inicio, IN_cantidadPorPagina;


-- si IN_idEDDEvaluacion y IN_idEDDEvalCompetencia no son nulas   
ELSEIF IN_idEDDEvaluacion != 0
AND IN_idEDDEvalCompetencia = 0
AND IN_idEDDEvalPregunta != 0 THEN
SET
    @temp_cantRegistros = (
        SELECT
            COUNT(idEDDEvalPregunta)
        FROM
            eddevalpregunta
        WHERE
            isActive = true
            AND idEDDEvaluacion = IN_idEDDEvaluacion
            AND idEDDEvalPregunta = IN_idEDDEvalPregunta
    );

SELECT
    @temp_cantRegistros,
    preg.idEDDEvalPregunta,
    UPPER(preg.nomPregunta) as nomPregunta,
    preg.ordenPregunta,
    preg.idEDDEvaluacion,
    preg.idEDDEvalCompetencia,
    UPPER(eval.nomEvaluacion) as nomEvaluacion,
    UPPER(comp.nomCompetencia) as nomCompetencia
FROM
    eddevalpregunta preg
    INNER JOIN eddevaluacion eval ON (preg.idEDDEvaluacion = eval.idEDDEvaluacion)
    INNER JOIN eddevalcompetencia comp ON (
        preg.idEDDEvalCompetencia = comp.idEDDEvalCompetencia
    )
WHERE
    preg.isActive = true
    AND preg.idEDDEvaluacion = IN_idEDDEvaluacion
    AND preg.idEDDEvalPregunta = IN_idEDDEvalPregunta
ORDER BY
    preg.nomPregunta,
    eval.nomEvaluacion,
    comp.nomCompetencia ASC
LIMIT
    IN_inicio, IN_cantidadPorPagina;

-- si IN_idEDDEvalPregunta y IN_idEDDEvalCompetencia no son nulas   
ELSEIF IN_idEDDEvaluacion = 0
AND IN_idEDDEvalCompetencia != 0
AND IN_idEDDEvalPregunta != 0 THEN
SET
    @temp_cantRegistros = (
        SELECT
            COUNT(idEDDEvalPregunta)
        FROM
            eddevalpregunta
        WHERE
            isActive = true
            AND idEDDEvalCompetencia = IN_idEDDEvalCompetencia
            AND idEDDEvalPregunta = IN_idEDDEvalPregunta
    );

SELECT
    @temp_cantRegistros,
    preg.idEDDEvalPregunta,
    UPPER(preg.nomPregunta) as nomPregunta,
    preg.ordenPregunta,
    preg.idEDDEvaluacion,
    preg.idEDDEvalCompetencia,
    UPPER(eval.nomEvaluacion) as nomEvaluacion,
    UPPER(comp.nomCompetencia) as nomCompetencia
FROM
    eddevalpregunta preg
    INNER JOIN eddevaluacion eval ON (preg.idEDDEvaluacion = eval.idEDDEvaluacion)
    INNER JOIN eddevalcompetencia comp ON (
        preg.idEDDEvalCompetencia = comp.idEDDEvalCompetencia
    )
WHERE
    preg.isActive = true
    AND preg.idEDDEvalCompetencia = IN_idEDDEvalCompetencia
    AND preg.idEDDEvalPregunta = IN_idEDDEvalPregunta
ORDER BY
    preg.nomPregunta,
    eval.nomEvaluacion,
    comp.nomCompetencia ASC
LIMIT
    IN_inicio, IN_cantidadPorPagina;

-- si ninguna es nula  
ELSEIF IN_idEDDEvaluacion != 0
AND IN_idEDDEvalCompetencia != 0
AND IN_idEDDEvalPregunta != 0 THEN
SET
    @temp_cantRegistros = (
        SELECT
            COUNT(idEDDEvalPregunta)
        FROM
            eddevalpregunta
        WHERE
            isActive = true
            AND idEDDEvalCompetencia = IN_idEDDEvalCompetencia
            AND idEDDEvalPregunta = IN_idEDDEvalPregunta
            AND idEDDEvaluacion = IN_idEDDEvaluacion
    );

SELECT
    @temp_cantRegistros,
    preg.idEDDEvalPregunta,
    UPPER(preg.nomPregunta) as nomPregunta,
    preg.ordenPregunta,
    preg.idEDDEvaluacion,
    preg.idEDDEvalCompetencia,
    UPPER(eval.nomEvaluacion) as nomEvaluacion,
    UPPER(comp.nomCompetencia) as nomCompetencia
FROM
    eddevalpregunta preg
    INNER JOIN eddevaluacion eval ON (preg.idEDDEvaluacion = eval.idEDDEvaluacion)
    INNER JOIN eddevalcompetencia comp ON (
        preg.idEDDEvalCompetencia = comp.idEDDEvalCompetencia
    )
WHERE
    preg.isActive = true
    AND preg.idEDDEvalCompetencia = IN_idEDDEvalCompetencia
    AND preg.idEDDEvalPregunta = IN_idEDDEvalPregunta
    AND preg.idEDDEvaluacion = IN_idEDDEvaluacion
ORDER BY
    preg.nomPregunta,
    eval.nomEvaluacion,
    comp.nomCompetencia ASC
LIMIT
    IN_inicio, IN_cantidadPorPagina;


END IF;

END