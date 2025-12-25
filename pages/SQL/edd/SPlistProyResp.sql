BEGIN CASE
  -- CUANDO TODAS LAS VARIABLES SON NULAS
  WHEN IN_idEDDEvaluacion = 0
  AND IN_idEDDProyEmp = 0
  AND IN_idEDDEvalProyEmp = 0
  AND IN_idEDDEvalPregunta = 0
  AND IN_idEDDEvalRespPreg = 0 THEN
  SET
    @temp_cantRegistros = (
      SELECT
        COUNT(idEDDEvalProyResp)
      FROM
        eddevalproyresp
      WHERE
        isActive = true
    );


SELECT
  @temp_cantRegistros,
  proyResp.idEDDEvalProyResp,
  proyResp.idEDDEvaluacion,
  proyResp.idEDDProyEmp,
  UPPER(proyResp.respuesta) as respuesta,
  proyResp.idEDDEvalProyEmp,
  proyResp.idEDDEvalPregunta,
  proyResp.idEDDEvalRespPreg,
  UPPER(eval.nomEvaluacion) as nomEvaluacion,
  UPPER(evalPregunta.nomPregunta) as nomPregunta,
  UPPER(evalRespPreg.nomRespPreg) as nomRespPreg
FROM
  eddevalproyresp proyResp
  INNER JOIN eddevaluacion eval ON (proyResp.idEDDEvaluacion = eval.idEDDEvaluacion)
  INNER JOIN eddproyemp proyEmp ON (proyResp.idEDDProyEmp = proyEmp.idEDDProyEmp)
  INNER JOIN eddevalproyemp evalProyEmp ON (
    proyResp.idEDDEvalProyEmp = evalProyEmp.idEDDEvalProyEmp
  )
  INNER JOIN eddevalpregunta evalPregunta ON (
    proyResp.idEDDEvalPregunta = evalPregunta.idEDDEvalPregunta
  )
  INNER JOIN eddevalresppreg evalRespPreg ON (
    proyResp.idEDDEvalRespPreg = evalRespPreg.idEDDEvalRespPreg
  )
WHERE
  proyResp.isActive = true
ORDER BY
  eval.nomEvaluacion ASC
LIMIT
  IN_inicio, IN_cantidadPorPagina;


-- CUANDO idEDDEvaluacion no es nula
WHEN IN_idEDDEvaluacion != 0
AND IN_idEDDProyEmp = 0
AND IN_idEDDEvalProyEmp = 0
AND IN_idEDDEvalPregunta = 0
AND IN_idEDDEvalRespPreg = 0 THEN
SET
  @temp_cantRegistros = (
    SELECT
      COUNT(idEDDEvalProyResp)
    FROM
      eddevalproyresp
    WHERE
      isActive = true
      AND idEDDEvaluacion = IN_idEDDEvaluacion
  );


SELECT
  @temp_cantRegistros,
  proyResp.idEDDEvalProyResp,
  proyResp.idEDDEvaluacion,
  proyResp.idEDDProyEmp,
  UPPER(proyResp.respuesta) as respuesta,
  proyResp.idEDDEvalProyEmp,
  proyResp.idEDDEvalPregunta,
  proyResp.idEDDEvalRespPreg,
  UPPER(eval.nomEvaluacion) as nomEvaluacion,
  UPPER(evalPregunta.nomPregunta) as nomPregunta,
  UPPER(evalRespPreg.nomRespPreg) as nomRespPreg
FROM
  eddevalproyresp proyResp
  INNER JOIN eddevaluacion eval ON (proyResp.idEDDEvaluacion = eval.idEDDEvaluacion)
  INNER JOIN eddproyemp proyEmp ON (proyResp.idEDDProyEmp = proyEmp.idEDDProyEmp)
  INNER JOIN eddevalproyemp evalProyEmp ON (
    proyResp.idEDDEvalProyEmp = evalProyEmp.idEDDEvalProyEmp
  )
  INNER JOIN eddevalpregunta evalPregunta ON (
    proyResp.idEDDEvalPregunta = evalPregunta.idEDDEvalPregunta
  )
  INNER JOIN eddevalresppreg evalRespPreg ON (
    proyResp.idEDDEvalRespPreg = evalRespPreg.idEDDEvalRespPreg
  )
WHERE
  proyResp.isActive = true
  AND proyResp.idEDDEvaluacion = IN_idEDDEvaluacion
ORDER BY
  eval.nomEvaluacion ASC
LIMIT
  IN_inicio, IN_cantidadPorPagina;


-- CUANDO idEDDProyEmp no es nula
WHEN IN_idEDDEvaluacion = 0
AND IN_idEDDProyEmp != 0
AND IN_idEDDEvalProyEmp = 0
AND IN_idEDDEvalPregunta = 0
AND IN_idEDDEvalRespPreg = 0 THEN
SET
  @temp_cantRegistros = (
    SELECT
      COUNT(idEDDEvalProyResp)
    FROM
      eddevalproyresp
    WHERE
      isActive = true
      AND idEDDProyEmp = IN_idEDDProyEmp
  );


SELECT
  @temp_cantRegistros,
  proyResp.idEDDEvalProyResp,
  proyResp.idEDDEvaluacion,
  proyResp.idEDDProyEmp,
  UPPER(proyResp.respuesta) as respuesta,
  proyResp.idEDDEvalProyEmp,
  proyResp.idEDDEvalPregunta,
  proyResp.idEDDEvalRespPreg,
  UPPER(eval.nomEvaluacion) as nomEvaluacion,
  UPPER(evalPregunta.nomPregunta) as nomPregunta,
  UPPER(evalRespPreg.nomRespPreg) as nomRespPreg
FROM
  eddevalproyresp proyResp
  INNER JOIN eddevaluacion eval ON (proyResp.idEDDEvaluacion = eval.idEDDEvaluacion)
  INNER JOIN eddproyemp proyEmp ON (proyResp.idEDDProyEmp = proyEmp.idEDDProyEmp)
  INNER JOIN eddevalproyemp evalProyEmp ON (
    proyResp.idEDDEvalProyEmp = evalProyEmp.idEDDEvalProyEmp
  )
  INNER JOIN eddevalpregunta evalPregunta ON (
    proyResp.idEDDEvalPregunta = evalPregunta.idEDDEvalPregunta
  )
  INNER JOIN eddevalresppreg evalRespPreg ON (
    proyResp.idEDDEvalRespPreg = evalRespPreg.idEDDEvalRespPreg
  )
WHERE
  proyResp.isActive = true
  AND proyResp.idEDDProyEmp = IN_idEDDProyEmp
ORDER BY
  eval.nomEvaluacion ASC
LIMIT
  IN_inicio, IN_cantidadPorPagina;


-- CUANDO idEDDEvalProyEmp no es nula
WHEN IN_idEDDEvaluacion = 0
AND IN_idEDDProyEmp = 0
AND IN_idEDDEvalProyEmp != 0
AND IN_idEDDEvalPregunta = 0
AND IN_idEDDEvalRespPreg = 0 THEN
SET
  @temp_cantRegistros = (
    SELECT
      COUNT(idEDDEvalProyResp)
    FROM
      eddevalproyresp
    WHERE
      isActive = true
      AND idEDDEvalProyEmp = IN_idEDDEvalProyEmp
  );


SELECT
  @temp_cantRegistros,
  proyResp.idEDDEvalProyResp,
  proyResp.idEDDEvaluacion,
  proyResp.idEDDProyEmp,
  UPPER(proyResp.respuesta) as respuesta,
  proyResp.idEDDEvalProyEmp,
  proyResp.idEDDEvalPregunta,
  proyResp.idEDDEvalRespPreg,
  UPPER(eval.nomEvaluacion) as nomEvaluacion,
  UPPER(evalPregunta.nomPregunta) as nomPregunta,
  UPPER(evalRespPreg.nomRespPreg) as nomRespPreg
FROM
  eddevalproyresp proyResp
  INNER JOIN eddevaluacion eval ON (proyResp.idEDDEvaluacion = eval.idEDDEvaluacion)
  INNER JOIN eddproyemp proyEmp ON (proyResp.idEDDProyEmp = proyEmp.idEDDProyEmp)
  INNER JOIN eddevalproyemp evalProyEmp ON (
    proyResp.idEDDEvalProyEmp = evalProyEmp.idEDDEvalProyEmp
  )
  INNER JOIN eddevalpregunta evalPregunta ON (
    proyResp.idEDDEvalPregunta = evalPregunta.idEDDEvalPregunta
  )
  INNER JOIN eddevalresppreg evalRespPreg ON (
    proyResp.idEDDEvalRespPreg = evalRespPreg.idEDDEvalRespPreg
  )
WHERE
  proyResp.isActive = true
  AND proyResp.idEDDEvalProyEmp = IN_idEDDEvalProyEmp
ORDER BY
  eval.nomEvaluacion ASC
LIMIT
  IN_inicio, IN_cantidadPorPagina;


-- CUANDO idEDDEvalPregunta no es nula
WHEN IN_idEDDEvaluacion = 0
AND IN_idEDDProyEmp = 0
AND IN_idEDDEvalProyEmp = 0
AND IN_idEDDEvalPregunta != 0
AND IN_idEDDEvalRespPreg = 0 THEN
SET
  @temp_cantRegistros = (
    SELECT
      COUNT(idEDDEvalProyResp)
    FROM
      eddevalproyresp
    WHERE
      isActive = true
      AND idEDDEvalPregunta = IN_idEDDEvalPregunta
  );


SELECT
  @temp_cantRegistros,
  proyResp.idEDDEvalProyResp,
  proyResp.idEDDEvaluacion,
  proyResp.idEDDProyEmp,
  UPPER(proyResp.respuesta) as respuesta,
  proyResp.idEDDEvalProyEmp,
  proyResp.idEDDEvalPregunta,
  proyResp.idEDDEvalRespPreg,
  UPPER(eval.nomEvaluacion) as nomEvaluacion,
  UPPER(evalPregunta.nomPregunta) as nomPregunta,
  UPPER(evalRespPreg.nomRespPreg) as nomRespPreg
FROM
  eddevalproyresp proyResp
  INNER JOIN eddevaluacion eval ON (proyResp.idEDDEvaluacion = eval.idEDDEvaluacion)
  INNER JOIN eddproyemp proyEmp ON (proyResp.idEDDProyEmp = proyEmp.idEDDProyEmp)
  INNER JOIN eddevalproyemp evalProyEmp ON (
    proyResp.idEDDEvalProyEmp = evalProyEmp.idEDDEvalProyEmp
  )
  INNER JOIN eddevalpregunta evalPregunta ON (
    proyResp.idEDDEvalPregunta = evalPregunta.idEDDEvalPregunta
  )
  INNER JOIN eddevalresppreg evalRespPreg ON (
    proyResp.idEDDEvalRespPreg = evalRespPreg.idEDDEvalRespPreg
  )
WHERE
  proyResp.isActive = true
  AND proyResp.idEDDEvalPregunta = IN_idEDDEvalPregunta
ORDER BY
  eval.nomEvaluacion ASC
LIMIT
  IN_inicio, IN_cantidadPorPagina;


-- CUANDO idEDDEvalRespPreg no es nula
WHEN IN_idEDDEvaluacion = 0
AND IN_idEDDProyEmp = 0
AND IN_idEDDEvalProyEmp = 0
AND IN_idEDDEvalPregunta = 0
AND IN_idEDDEvalRespPreg != 0 THEN
SET
  @temp_cantRegistros = (
    SELECT
      COUNT(idEDDEvalProyResp)
    FROM
      eddevalproyresp
    WHERE
      isActive = true
      AND idEDDEvalRespPreg = IN_idEDDEvalRespPreg
  );


SELECT
  @temp_cantRegistros,
  proyResp.idEDDEvalProyResp,
  proyResp.idEDDEvaluacion,
  proyResp.idEDDProyEmp,
  UPPER(proyResp.respuesta) as respuesta,
  proyResp.idEDDEvalProyEmp,
  proyResp.idEDDEvalPregunta,
  proyResp.idEDDEvalRespPreg,
  UPPER(eval.nomEvaluacion) as nomEvaluacion,
  UPPER(evalPregunta.nomPregunta) as nomPregunta,
  UPPER(evalRespPreg.nomRespPreg) as nomRespPreg
FROM
  eddevalproyresp proyResp
  INNER JOIN eddevaluacion eval ON (proyResp.idEDDEvaluacion = eval.idEDDEvaluacion)
  INNER JOIN eddproyemp proyEmp ON (proyResp.idEDDProyEmp = proyEmp.idEDDProyEmp)
  INNER JOIN eddevalproyemp evalProyEmp ON (
    proyResp.idEDDEvalProyEmp = evalProyEmp.idEDDEvalProyEmp
  )
  INNER JOIN eddevalpregunta evalPregunta ON (
    proyResp.idEDDEvalPregunta = evalPregunta.idEDDEvalPregunta
  )
  INNER JOIN eddevalresppreg evalRespPreg ON (
    proyResp.idEDDEvalRespPreg = evalRespPreg.idEDDEvalRespPreg
  )
WHERE
  proyResp.isActive = true
  AND proyResp.idEDDEvalRespPreg = IN_idEDDEvalRespPreg
ORDER BY
  eval.nomEvaluacion ASC
LIMIT
  IN_inicio, IN_cantidadPorPagina;


-- CUANDO idEDDEvaluacion y idEDDProyEmpy no son nulos
WHEN IN_idEDDEvaluacion != 0
AND IN_idEDDProyEmp != 0
AND IN_idEDDEvalProyEmp = 0
AND IN_idEDDEvalPregunta = 0
AND IN_idEDDEvalRespPreg = 0 THEN
SET
  @temp_cantRegistros = (
    SELECT
      COUNT(idEDDEvalProyResp)
    FROM
      eddevalproyresp
    WHERE
      isActive = true
      AND idEDDEvaluacion = IN_idEDDEvaluacion
      AND idEDDProyEmpy = IN_idEDDProyEmp
  );


SELECT
  @temp_cantRegistros,
  proyResp.idEDDEvalProyResp,
  proyResp.idEDDEvaluacion,
  proyResp.idEDDProyEmp,
  UPPER(proyResp.respuesta) as respuesta,
  proyResp.idEDDEvalProyEmp,
  proyResp.idEDDEvalPregunta,
  proyResp.idEDDEvalRespPreg,
  UPPER(eval.nomEvaluacion) as nomEvaluacion,
  UPPER(evalPregunta.nomPregunta) as nomPregunta,
  UPPER(evalRespPreg.nomRespPreg) as nomRespPreg
FROM
  eddevalproyresp proyResp
  INNER JOIN eddevaluacion eval ON (proyResp.idEDDEvaluacion = eval.idEDDEvaluacion)
  INNER JOIN eddproyemp proyEmp ON (proyResp.idEDDProyEmp = proyEmp.idEDDProyEmp)
  INNER JOIN eddevalproyemp evalProyEmp ON (
    proyResp.idEDDEvalProyEmp = evalProyEmp.idEDDEvalProyEmp
  )
  INNER JOIN eddevalpregunta evalPregunta ON (
    proyResp.idEDDEvalPregunta = evalPregunta.idEDDEvalPregunta
  )
  INNER JOIN eddevalresppreg evalRespPreg ON (
    proyResp.idEDDEvalRespPreg = evalRespPreg.idEDDEvalRespPreg
  )
WHERE
  proyResp.isActive = true
  AND proyResp.idEDDEvaluacion = IN_idEDDEvaluacion
  AND proyResp.idEDDProyEmpy = IN_idEDDProyEmp
ORDER BY
  eval.nomEvaluacion ASC
LIMIT
  IN_inicio, IN_cantidadPorPagina;


-- CUANDO idEDDEvaluacion y idEDDEvalProyEmp no son nulos
WHEN IN_idEDDEvaluacion != 0
AND IN_idEDDProyEmp = 0
AND IN_idEDDEvalProyEmp != 0
AND IN_idEDDEvalPregunta = 0
AND IN_idEDDEvalRespPreg = 0 THEN
SET
  @temp_cantRegistros = (
    SELECT
      COUNT(idEDDEvalProyResp)
    FROM
      eddevalproyresp
    WHERE
      isActive = true
      AND idEDDEvaluacion = IN_idEDDEvaluacion
      AND idEDDEvalProyEmp = IN_idEDDEvalProyEmp
  );


SELECT
  @temp_cantRegistros,
  proyResp.idEDDEvalProyResp,
  proyResp.idEDDEvaluacion,
  proyResp.idEDDProyEmp,
  UPPER(proyResp.respuesta) as respuesta,
  proyResp.idEDDEvalProyEmp,
  proyResp.idEDDEvalPregunta,
  proyResp.idEDDEvalRespPreg,
  UPPER(eval.nomEvaluacion) as nomEvaluacion,
  UPPER(evalPregunta.nomPregunta) as nomPregunta,
  UPPER(evalRespPreg.nomRespPreg) as nomRespPreg
FROM
  eddevalproyresp proyResp
  INNER JOIN eddevaluacion eval ON (proyResp.idEDDEvaluacion = eval.idEDDEvaluacion)
  INNER JOIN eddproyemp proyEmp ON (proyResp.idEDDProyEmp = proyEmp.idEDDProyEmp)
  INNER JOIN eddevalproyemp evalProyEmp ON (
    proyResp.idEDDEvalProyEmp = evalProyEmp.idEDDEvalProyEmp
  )
  INNER JOIN eddevalpregunta evalPregunta ON (
    proyResp.idEDDEvalPregunta = evalPregunta.idEDDEvalPregunta
  )
  INNER JOIN eddevalresppreg evalRespPreg ON (
    proyResp.idEDDEvalRespPreg = evalRespPreg.idEDDEvalRespPreg
  )
WHERE
  proyResp.isActive = true
  AND proyResp.idEDDEvaluacion = IN_idEDDEvaluacion
  AND proyResp.idEDDEvalProyEmp = IN_idEDDEvalProyEmp
ORDER BY
  eval.nomEvaluacion ASC
LIMIT
  IN_inicio, IN_cantidadPorPagina;


-- CUANDO idEDDEvaluacion y idEDDEvalPregunta no son nulos
WHEN IN_idEDDEvaluacion != 0
AND IN_idEDDProyEmp = 0
AND IN_idEDDEvalProyEmp = 0
AND IN_idEDDEvalPregunta != 0
AND IN_idEDDEvalRespPreg = 0 THEN
SET
  @temp_cantRegistros = (
    SELECT
      COUNT(idEDDEvalProyResp)
    FROM
      eddevalproyresp
    WHERE
      isActive = true
      AND idEDDEvaluacion = IN_idEDDEvaluacion
      AND idEDDEvalPregunta = IN_idEDDEvalPregunta
  );


SELECT
  @temp_cantRegistros,
  proyResp.idEDDEvalProyResp,
  proyResp.idEDDEvaluacion,
  proyResp.idEDDProyEmp,
  UPPER(proyResp.respuesta) as respuesta,
  proyResp.idEDDEvalProyEmp,
  proyResp.idEDDEvalPregunta,
  proyResp.idEDDEvalRespPreg,
  UPPER(eval.nomEvaluacion) as nomEvaluacion,
  UPPER(evalPregunta.nomPregunta) as nomPregunta,
  UPPER(evalRespPreg.nomRespPreg) as nomRespPreg
FROM
  eddevalproyresp proyResp
  INNER JOIN eddevaluacion eval ON (proyResp.idEDDEvaluacion = eval.idEDDEvaluacion)
  INNER JOIN eddproyemp proyEmp ON (proyResp.idEDDProyEmp = proyEmp.idEDDProyEmp)
  INNER JOIN eddevalproyemp evalProyEmp ON (
    proyResp.idEDDEvalProyEmp = evalProyEmp.idEDDEvalProyEmp
  )
  INNER JOIN eddevalpregunta evalPregunta ON (
    proyResp.idEDDEvalPregunta = evalPregunta.idEDDEvalPregunta
  )
  INNER JOIN eddevalresppreg evalRespPreg ON (
    proyResp.idEDDEvalRespPreg = evalRespPreg.idEDDEvalRespPreg
  )
WHERE
  proyResp.isActive = true
  AND proyResp.idEDDEvaluacion = IN_idEDDEvaluacion
  AND proyResp.idEDDEvalPregunta = IN_idEDDEvalPregunta
ORDER BY
  eval.nomEvaluacion ASC
LIMIT
  IN_inicio, IN_cantidadPorPagina;

-- CUANDO idEDDEvaluacion y idEDDEvalRespPreg no son nulos
WHEN IN_idEDDEvaluacion != 0
AND IN_idEDDProyEmp = 0
AND IN_idEDDEvalProyEmp = 0
AND IN_idEDDEvalPregunta = 0
AND IN_idEDDEvalRespPreg != 0 THEN
SET
  @temp_cantRegistros = (
    SELECT
      COUNT(idEDDEvalProyResp)
    FROM
      eddevalproyresp
    WHERE
      isActive = true
      AND idEDDEvaluacion = IN_idEDDEvaluacion
      AND idEDDEvalRespPreg = IN_idEDDEvalRespPreg
  );


SELECT
  @temp_cantRegistros,
  proyResp.idEDDEvalProyResp,
  proyResp.idEDDEvaluacion,
  proyResp.idEDDProyEmp,
  UPPER(proyResp.respuesta) as respuesta,
  proyResp.idEDDEvalProyEmp,
  proyResp.idEDDEvalPregunta,
  proyResp.idEDDEvalRespPreg,
  UPPER(eval.nomEvaluacion) as nomEvaluacion,
  UPPER(evalPregunta.nomPregunta) as nomPregunta,
  UPPER(evalRespPreg.nomRespPreg) as nomRespPreg
FROM
  eddevalproyresp proyResp
  INNER JOIN eddevaluacion eval ON (proyResp.idEDDEvaluacion = eval.idEDDEvaluacion)
  INNER JOIN eddproyemp proyEmp ON (proyResp.idEDDProyEmp = proyEmp.idEDDProyEmp)
  INNER JOIN eddevalproyemp evalProyEmp ON (
    proyResp.idEDDEvalProyEmp = evalProyEmp.idEDDEvalProyEmp
  )
  INNER JOIN eddevalpregunta evalPregunta ON (
    proyResp.idEDDEvalPregunta = evalPregunta.idEDDEvalPregunta
  )
  INNER JOIN eddevalresppreg evalRespPreg ON (
    proyResp.idEDDEvalRespPreg = evalRespPreg.idEDDEvalRespPreg
  )
WHERE
  proyResp.isActive = true
  AND proyResp.idEDDEvaluacion = IN_idEDDEvaluacion
  AND proyResp.idEDDEvalRespPreg = IN_idEDDEvalRespPreg
ORDER BY
  eval.nomEvaluacion ASC
LIMIT
  IN_inicio, IN_cantidadPorPagina;


-- CUANDO idEDDProyEmp y idEDDEvalProyEmp no son nulos
WHEN IN_idEDDEvaluacion = 0
AND IN_idEDDProyEmp != 0
AND IN_idEDDEvalProyEmp != 0
AND IN_idEDDEvalPregunta = 0
AND IN_idEDDEvalRespPreg = 0 THEN
SET
  @temp_cantRegistros = (
    SELECT
      COUNT(idEDDEvalProyResp)
    FROM
      eddevalproyresp
    WHERE
      isActive = true
      AND idEDDProyEmp = IN_idEDDProyEmp
      AND idEDDEvalProyEmp = IN_idEDDEvalProyEmp
  );


SELECT
  @temp_cantRegistros,
  proyResp.idEDDEvalProyResp,
  proyResp.idEDDEvaluacion,
  proyResp.idEDDProyEmp,
  UPPER(proyResp.respuesta) as respuesta,
  proyResp.idEDDEvalProyEmp,
  proyResp.idEDDEvalPregunta,
  proyResp.idEDDEvalRespPreg,
  UPPER(eval.nomEvaluacion) as nomEvaluacion,
  UPPER(evalPregunta.nomPregunta) as nomPregunta,
  UPPER(evalRespPreg.nomRespPreg) as nomRespPreg
FROM
  eddevalproyresp proyResp
  INNER JOIN eddevaluacion eval ON (proyResp.idEDDEvaluacion = eval.idEDDEvaluacion)
  INNER JOIN eddproyemp proyEmp ON (proyResp.idEDDProyEmp = proyEmp.idEDDProyEmp)
  INNER JOIN eddevalproyemp evalProyEmp ON (
    proyResp.idEDDEvalProyEmp = evalProyEmp.idEDDEvalProyEmp
  )
  INNER JOIN eddevalpregunta evalPregunta ON (
    proyResp.idEDDEvalPregunta = evalPregunta.idEDDEvalPregunta
  )
  INNER JOIN eddevalresppreg evalRespPreg ON (
    proyResp.idEDDEvalRespPreg = evalRespPreg.idEDDEvalRespPreg
  )
WHERE
  proyResp.isActive = true
  AND proyResp.idEDDProyEmp = IN_idEDDProyEmp
  AND proyResp.idEDDEvalProyEmp = IN_idEDDEvalProyEmp
ORDER BY
  eval.nomEvaluacion ASC
LIMIT
  IN_inicio, IN_cantidadPorPagina;

-- CUANDO idEDDProyEmp y idEDDEvalPregunta no son nulos
WHEN IN_idEDDEvaluacion = 0
AND IN_idEDDProyEmp != 0
AND IN_idEDDEvalProyEmp = 0
AND IN_idEDDEvalPregunta != 0
AND IN_idEDDEvalRespPreg = 0 THEN
SET
  @temp_cantRegistros = (
    SELECT
      COUNT(idEDDEvalProyResp)
    FROM
      eddevalproyresp
    WHERE
      isActive = true
      AND idEDDProyEmp = IN_idEDDProyEmp
      AND idEDDEvalPregunta = IN_idEDDEvalPregunta
  );


SELECT
  @temp_cantRegistros,
  proyResp.idEDDEvalProyResp,
  proyResp.idEDDEvaluacion,
  proyResp.idEDDProyEmp,
  UPPER(proyResp.respuesta) as respuesta,
  proyResp.idEDDEvalProyEmp,
  proyResp.idEDDEvalPregunta,
  proyResp.idEDDEvalRespPreg,
  UPPER(eval.nomEvaluacion) as nomEvaluacion,
  UPPER(evalPregunta.nomPregunta) as nomPregunta,
  UPPER(evalRespPreg.nomRespPreg) as nomRespPreg
FROM
  eddevalproyresp proyResp
  INNER JOIN eddevaluacion eval ON (proyResp.idEDDEvaluacion = eval.idEDDEvaluacion)
  INNER JOIN eddproyemp proyEmp ON (proyResp.idEDDProyEmp = proyEmp.idEDDProyEmp)
  INNER JOIN eddevalproyemp evalProyEmp ON (
    proyResp.idEDDEvalProyEmp = evalProyEmp.idEDDEvalProyEmp
  )
  INNER JOIN eddevalpregunta evalPregunta ON (
    proyResp.idEDDEvalPregunta = evalPregunta.idEDDEvalPregunta
  )
  INNER JOIN eddevalresppreg evalRespPreg ON (
    proyResp.idEDDEvalRespPreg = evalRespPreg.idEDDEvalRespPreg
  )
WHERE
  proyResp.isActive = true
  AND proyResp.idEDDProyEmp = IN_idEDDProyEmp
  AND proyResp.idEDDEvalPregunta = IN_idEDDEvalPregunta
ORDER BY
  eval.nomEvaluacion ASC
LIMIT
  IN_inicio, IN_cantidadPorPagina;

-- CUANDO idEDDProyEmp y idEDDEvalRespPreg no son nulos
WHEN IN_idEDDEvaluacion = 0
AND IN_idEDDProyEmp != 0
AND IN_idEDDEvalProyEmp = 0
AND IN_idEDDEvalPregunta = 0
AND IN_idEDDEvalRespPreg != 0 THEN
SET
  @temp_cantRegistros = (
    SELECT
      COUNT(idEDDEvalProyResp)
    FROM
      eddevalproyresp
    WHERE
      isActive = true
      AND idEDDProyEmp = IN_idEDDProyEmp
      AND idEDDEvalRespPreg = IN_idEDDEvalRespPreg
  );


SELECT
  @temp_cantRegistros,
  proyResp.idEDDEvalProyResp,
  proyResp.idEDDEvaluacion,
  proyResp.idEDDProyEmp,
  UPPER(proyResp.respuesta) as respuesta,
  proyResp.idEDDEvalProyEmp,
  proyResp.idEDDEvalPregunta,
  proyResp.idEDDEvalRespPreg,
  UPPER(eval.nomEvaluacion) as nomEvaluacion,
  UPPER(evalPregunta.nomPregunta) as nomPregunta,
  UPPER(evalRespPreg.nomRespPreg) as nomRespPreg
FROM
  eddevalproyresp proyResp
  INNER JOIN eddevaluacion eval ON (proyResp.idEDDEvaluacion = eval.idEDDEvaluacion)
  INNER JOIN eddproyemp proyEmp ON (proyResp.idEDDProyEmp = proyEmp.idEDDProyEmp)
  INNER JOIN eddevalproyemp evalProyEmp ON (
    proyResp.idEDDEvalProyEmp = evalProyEmp.idEDDEvalProyEmp
  )
  INNER JOIN eddevalpregunta evalPregunta ON (
    proyResp.idEDDEvalPregunta = evalPregunta.idEDDEvalPregunta
  )
  INNER JOIN eddevalresppreg evalRespPreg ON (
    proyResp.idEDDEvalRespPreg = evalRespPreg.idEDDEvalRespPreg
  )
WHERE
  proyResp.isActive = true
  AND proyResp.idEDDProyEmp = IN_idEDDProyEmp
  AND proyResp.idEDDEvalRespPreg = IN_idEDDEvalRespPreg
ORDER BY
  eval.nomEvaluacion ASC
LIMIT
  IN_inicio, IN_cantidadPorPagina;

-- CUANDO idEDDEvalProyEmp y idEDDEvalPregunta no son nulos
WHEN IN_idEDDEvaluacion = 0
AND IN_idEDDProyEmp = 0
AND IN_idEDDEvalProyEmp != 0
AND IN_idEDDEvalPregunta != 0
AND IN_idEDDEvalRespPreg = 0 THEN
SET
  @temp_cantRegistros = (
    SELECT
      COUNT(idEDDEvalProyResp)
    FROM
      eddevalproyresp
    WHERE
      isActive = true
      AND idEDDEvalProyEmp = IN_idEDDEvalProyEmp
      AND idEDDEvalPregunta = IN_idEDDEvalPregunta
  );


SELECT
  @temp_cantRegistros,
  proyResp.idEDDEvalProyResp,
  proyResp.idEDDEvaluacion,
  proyResp.idEDDProyEmp,
  UPPER(proyResp.respuesta) as respuesta,
  proyResp.idEDDEvalProyEmp,
  proyResp.idEDDEvalPregunta,
  proyResp.idEDDEvalRespPreg,
  UPPER(eval.nomEvaluacion) as nomEvaluacion,
  UPPER(evalPregunta.nomPregunta) as nomPregunta,
  UPPER(evalRespPreg.nomRespPreg) as nomRespPreg
FROM
  eddevalproyresp proyResp
  INNER JOIN eddevaluacion eval ON (proyResp.idEDDEvaluacion = eval.idEDDEvaluacion)
  INNER JOIN eddproyemp proyEmp ON (proyResp.idEDDProyEmp = proyEmp.idEDDProyEmp)
  INNER JOIN eddevalproyemp evalProyEmp ON (
    proyResp.idEDDEvalProyEmp = evalProyEmp.idEDDEvalProyEmp
  )
  INNER JOIN eddevalpregunta evalPregunta ON (
    proyResp.idEDDEvalPregunta = evalPregunta.idEDDEvalPregunta
  )
  INNER JOIN eddevalresppreg evalRespPreg ON (
    proyResp.idEDDEvalRespPreg = evalRespPreg.idEDDEvalRespPreg
  )
WHERE
  proyResp.isActive = true
  AND proyResp.idEDDEvalProyEmp = IN_idEDDEvalProyEmp
  AND proyResp.idEDDEvalPregunta = IN_idEDDEvalPregunta
ORDER BY
  eval.nomEvaluacion ASC
LIMIT
  IN_inicio, IN_cantidadPorPagina;


-- CUANDO idEDDEvalProyEmp y idEDDEvalRespPreg no son nulos
WHEN IN_idEDDEvaluacion = 0
AND IN_idEDDProyEmp = 0
AND IN_idEDDEvalProyEmp != 0
AND IN_idEDDEvalPregunta = 0
AND IN_idEDDEvalRespPreg != 0 THEN
SET
  @temp_cantRegistros = (
    SELECT
      COUNT(idEDDEvalProyResp)
    FROM
      eddevalproyresp
    WHERE
      isActive = true
      AND idEDDEvalProyEmp = IN_idEDDEvalProyEmp
      AND idEDDEvalRespPreg = IN_idEDDEvalRespPreg
  );


SELECT
  @temp_cantRegistros,
  proyResp.idEDDEvalProyResp,
  proyResp.idEDDEvaluacion,
  proyResp.idEDDProyEmp,
  UPPER(proyResp.respuesta) as respuesta,
  proyResp.idEDDEvalProyEmp,
  proyResp.idEDDEvalPregunta,
  proyResp.idEDDEvalRespPreg,
  UPPER(eval.nomEvaluacion) as nomEvaluacion,
  UPPER(evalPregunta.nomPregunta) as nomPregunta,
  UPPER(evalRespPreg.nomRespPreg) as nomRespPreg
FROM
  eddevalproyresp proyResp
  INNER JOIN eddevaluacion eval ON (proyResp.idEDDEvaluacion = eval.idEDDEvaluacion)
  INNER JOIN eddproyemp proyEmp ON (proyResp.idEDDProyEmp = proyEmp.idEDDProyEmp)
  INNER JOIN eddevalproyemp evalProyEmp ON (
    proyResp.idEDDEvalProyEmp = evalProyEmp.idEDDEvalProyEmp
  )
  INNER JOIN eddevalpregunta evalPregunta ON (
    proyResp.idEDDEvalPregunta = evalPregunta.idEDDEvalPregunta
  )
  INNER JOIN eddevalresppreg evalRespPreg ON (
    proyResp.idEDDEvalRespPreg = evalRespPreg.idEDDEvalRespPreg
  )
WHERE
  proyResp.isActive = true
  AND proyResp.idEDDEvalProyEmp = IN_idEDDEvalProyEmp
  AND proyResp.idEDDEvalRespPreg = IN_idEDDEvalRespPreg
ORDER BY
  eval.nomEvaluacion ASC
LIMIT
  IN_inicio, IN_cantidadPorPagina;


-- CUANDO idEDDEvalPregunta y idEDDEvalRespPreg no son nulos
WHEN IN_idEDDEvaluacion = 0
AND IN_idEDDProyEmp = 0
AND IN_idEDDEvalProyEmp = 0
AND IN_idEDDEvalPregunta != 0
AND IN_idEDDEvalRespPreg != 0 THEN
SET
  @temp_cantRegistros = (
    SELECT
      COUNT(idEDDEvalProyResp)
    FROM
      eddevalproyresp
    WHERE
      isActive = true
      AND idEDDEvalPregunta = IN_idEDDEvalPregunta
      AND idEDDEvalRespPreg = IN_idEDDEvalRespPreg
  );


SELECT
  @temp_cantRegistros,
  proyResp.idEDDEvalProyResp,
  proyResp.idEDDEvaluacion,
  proyResp.idEDDProyEmp,
  UPPER(proyResp.respuesta) as respuesta,
  proyResp.idEDDEvalProyEmp,
  proyResp.idEDDEvalPregunta,
  proyResp.idEDDEvalRespPreg,
  UPPER(eval.nomEvaluacion) as nomEvaluacion,
  UPPER(evalPregunta.nomPregunta) as nomPregunta,
  UPPER(evalRespPreg.nomRespPreg) as nomRespPreg
FROM
  eddevalproyresp proyResp
  INNER JOIN eddevaluacion eval ON (proyResp.idEDDEvaluacion = eval.idEDDEvaluacion)
  INNER JOIN eddproyemp proyEmp ON (proyResp.idEDDProyEmp = proyEmp.idEDDProyEmp)
  INNER JOIN eddevalproyemp evalProyEmp ON (
    proyResp.idEDDEvalProyEmp = evalProyEmp.idEDDEvalProyEmp
  )
  INNER JOIN eddevalpregunta evalPregunta ON (
    proyResp.idEDDEvalPregunta = evalPregunta.idEDDEvalPregunta
  )
  INNER JOIN eddevalresppreg evalRespPreg ON (
    proyResp.idEDDEvalRespPreg = evalRespPreg.idEDDEvalRespPreg
  )
WHERE
  proyResp.isActive = true
  AND proyResp.idEDDEvalPregunta = IN_idEDDEvalPregunta
  AND proyResp.idEDDEvalRespPreg = IN_idEDDEvalRespPreg
ORDER BY
  eval.nomEvaluacion ASC
LIMIT
  IN_inicio, IN_cantidadPorPagina;

-- CUANDO idEDDEvaluacion y idEDDProyEmp y idEDDEvalProyEmp no son nulos
WHEN IN_idEDDEvaluacion != 0
AND IN_idEDDProyEmp != 0
AND IN_idEDDEvalProyEmp != 0
AND IN_idEDDEvalPregunta = 0
AND IN_idEDDEvalRespPreg = 0 THEN
SET
  @temp_cantRegistros = (
    SELECT
      COUNT(idEDDEvalProyResp)
    FROM
      eddevalproyresp
    WHERE
      isActive = true
      AND idEDDEvaluacion = IN_idEDDEvaluacion
      AND idEDDProyEmp = IN_idEDDProyEmp
      AND idEDDEvalProyEmp = IN_idEDDEvalProyEmp
  );


SELECT
  @temp_cantRegistros,
  proyResp.idEDDEvalProyResp,
  proyResp.idEDDEvaluacion,
  proyResp.idEDDProyEmp,
  UPPER(proyResp.respuesta) as respuesta,
  proyResp.idEDDEvalProyEmp,
  proyResp.idEDDEvalPregunta,
  proyResp.idEDDEvalRespPreg,
  UPPER(eval.nomEvaluacion) as nomEvaluacion,
  UPPER(evalPregunta.nomPregunta) as nomPregunta,
  UPPER(evalRespPreg.nomRespPreg) as nomRespPreg
FROM
  eddevalproyresp proyResp
  INNER JOIN eddevaluacion eval ON (proyResp.idEDDEvaluacion = eval.idEDDEvaluacion)
  INNER JOIN eddproyemp proyEmp ON (proyResp.idEDDProyEmp = proyEmp.idEDDProyEmp)
  INNER JOIN eddevalproyemp evalProyEmp ON (
    proyResp.idEDDEvalProyEmp = evalProyEmp.idEDDEvalProyEmp
  )
  INNER JOIN eddevalpregunta evalPregunta ON (
    proyResp.idEDDEvalPregunta = evalPregunta.idEDDEvalPregunta
  )
  INNER JOIN eddevalresppreg evalRespPreg ON (
    proyResp.idEDDEvalRespPreg = evalRespPreg.idEDDEvalRespPreg
  )
WHERE
  proyResp.isActive = true
  AND proyResp.idEDDEvaluacion = IN_idEDDEvaluacion
  AND proyResp.idEDDProyEmp = IN_idEDDProyEmp
  AND proyResp.idEDDEvalProyEmp = IN_idEDDEvalProyEmp
ORDER BY
  eval.nomEvaluacion ASC
LIMIT
  IN_inicio, IN_cantidadPorPagina;

-- CUANDO idEDDEvaluacion y idEDDProyEmp y idEDDEvalPregunta no son nulos
WHEN IN_idEDDEvaluacion != 0
AND IN_idEDDProyEmp != 0
AND IN_idEDDEvalProyEmp = 0
AND IN_idEDDEvalPregunta != 0
AND IN_idEDDEvalRespPreg = 0 THEN
SET
  @temp_cantRegistros = (
    SELECT
      COUNT(idEDDEvalProyResp)
    FROM
      eddevalproyresp
    WHERE
      isActive = true
      AND idEDDEvaluacion = IN_idEDDEvaluacion
      AND idEDDProyEmp = IN_idEDDProyEmp
      AND idEDDEvalPregunta = IN_idEDDEvalPregunta
  );


SELECT
  @temp_cantRegistros,
  proyResp.idEDDEvalProyResp,
  proyResp.idEDDEvaluacion,
  proyResp.idEDDProyEmp,
  UPPER(proyResp.respuesta) as respuesta,
  proyResp.idEDDEvalProyEmp,
  proyResp.idEDDEvalPregunta,
  proyResp.idEDDEvalRespPreg,
  UPPER(eval.nomEvaluacion) as nomEvaluacion,
  UPPER(evalPregunta.nomPregunta) as nomPregunta,
  UPPER(evalRespPreg.nomRespPreg) as nomRespPreg
FROM
  eddevalproyresp proyResp
  INNER JOIN eddevaluacion eval ON (proyResp.idEDDEvaluacion = eval.idEDDEvaluacion)
  INNER JOIN eddproyemp proyEmp ON (proyResp.idEDDProyEmp = proyEmp.idEDDProyEmp)
  INNER JOIN eddevalproyemp evalProyEmp ON (
    proyResp.idEDDEvalProyEmp = evalProyEmp.idEDDEvalProyEmp
  )
  INNER JOIN eddevalpregunta evalPregunta ON (
    proyResp.idEDDEvalPregunta = evalPregunta.idEDDEvalPregunta
  )
  INNER JOIN eddevalresppreg evalRespPreg ON (
    proyResp.idEDDEvalRespPreg = evalRespPreg.idEDDEvalRespPreg
  )
WHERE
  proyResp.isActive = true
  AND proyResp.idEDDEvaluacion = IN_idEDDEvaluacion
  AND proyResp.idEDDProyEmp = IN_idEDDProyEmp
  AND proyResp.idEDDEvalPregunta = IN_idEDDEvalPregunta
ORDER BY
  eval.nomEvaluacion ASC
LIMIT
  IN_inicio, IN_cantidadPorPagina;

-- CUANDO idEDDEvaluacion y idEDDProyEmp y idEDDEvalRespPreg no son nulos
WHEN IN_idEDDEvaluacion != 0
AND IN_idEDDProyEmp != 0
AND IN_idEDDEvalProyEmp = 0
AND IN_idEDDEvalPregunta = 0
AND IN_idEDDEvalRespPreg != 0 THEN
SET
  @temp_cantRegistros = (
    SELECT
      COUNT(idEDDEvalProyResp)
    FROM
      eddevalproyresp
    WHERE
      isActive = true
      AND idEDDEvaluacion = IN_idEDDEvaluacion
      AND idEDDProyEmp = IN_idEDDProyEmp
      AND idEDDEvalRespPreg = IN_idEDDEvalRespPreg
  );


SELECT
  @temp_cantRegistros,
  proyResp.idEDDEvalProyResp,
  proyResp.idEDDEvaluacion,
  proyResp.idEDDProyEmp,
  UPPER(proyResp.respuesta) as respuesta,
  proyResp.idEDDEvalProyEmp,
  proyResp.idEDDEvalPregunta,
  proyResp.idEDDEvalRespPreg,
  UPPER(eval.nomEvaluacion) as nomEvaluacion,
  UPPER(evalPregunta.nomPregunta) as nomPregunta,
  UPPER(evalRespPreg.nomRespPreg) as nomRespPreg
FROM
  eddevalproyresp proyResp
  INNER JOIN eddevaluacion eval ON (proyResp.idEDDEvaluacion = eval.idEDDEvaluacion)
  INNER JOIN eddproyemp proyEmp ON (proyResp.idEDDProyEmp = proyEmp.idEDDProyEmp)
  INNER JOIN eddevalproyemp evalProyEmp ON (
    proyResp.idEDDEvalProyEmp = evalProyEmp.idEDDEvalProyEmp
  )
  INNER JOIN eddevalpregunta evalPregunta ON (
    proyResp.idEDDEvalPregunta = evalPregunta.idEDDEvalPregunta
  )
  INNER JOIN eddevalresppreg evalRespPreg ON (
    proyResp.idEDDEvalRespPreg = evalRespPreg.idEDDEvalRespPreg
  )
WHERE
  proyResp.isActive = true
  AND proyResp.idEDDEvaluacion = IN_idEDDEvaluacion
  AND proyResp.idEDDProyEmp = IN_idEDDProyEmp
  AND proyResp.idEDDEvalRespPreg = IN_idEDDEvalRespPreg
ORDER BY
  eval.nomEvaluacion ASC
LIMIT
  IN_inicio, IN_cantidadPorPagina;

-- CUANDO idEDDProyEmp y idEDDEvalProyEmp y idEDDEvalPregunta no son nulos
WHEN IN_idEDDEvaluacion = 0
AND IN_idEDDProyEmp != 0
AND IN_idEDDEvalProyEmp != 0
AND IN_idEDDEvalPregunta != 0
AND IN_idEDDEvalRespPreg = 0 THEN
SET
  @temp_cantRegistros = (
    SELECT
      COUNT(idEDDEvalProyResp)
    FROM
      eddevalproyresp
    WHERE
      isActive = true
      AND idEDDProyEmp = IN_idEDDProyEmp
      AND idEDDEvalProyEmp = IN_idEDDEvalProyEmp
      AND idEDDEvalPregunta = IN_idEDDEvalPregunta
  );


SELECT
  @temp_cantRegistros,
  proyResp.idEDDEvalProyResp,
  proyResp.idEDDEvaluacion,
  proyResp.idEDDProyEmp,
  UPPER(proyResp.respuesta) as respuesta,
  proyResp.idEDDEvalProyEmp,
  proyResp.idEDDEvalPregunta,
  proyResp.idEDDEvalRespPreg,
  UPPER(eval.nomEvaluacion) as nomEvaluacion,
  UPPER(evalPregunta.nomPregunta) as nomPregunta,
  UPPER(evalRespPreg.nomRespPreg) as nomRespPreg
FROM
  eddevalproyresp proyResp
  INNER JOIN eddevaluacion eval ON (proyResp.idEDDEvaluacion = eval.idEDDEvaluacion)
  INNER JOIN eddproyemp proyEmp ON (proyResp.idEDDProyEmp = proyEmp.idEDDProyEmp)
  INNER JOIN eddevalproyemp evalProyEmp ON (
    proyResp.idEDDEvalProyEmp = evalProyEmp.idEDDEvalProyEmp
  )
  INNER JOIN eddevalpregunta evalPregunta ON (
    proyResp.idEDDEvalPregunta = evalPregunta.idEDDEvalPregunta
  )
  INNER JOIN eddevalresppreg evalRespPreg ON (
    proyResp.idEDDEvalRespPreg = evalRespPreg.idEDDEvalRespPreg
  )
WHERE
  proyResp.isActive = true
  AND proyResp.idEDDProyEmp = IN_idEDDProyEmp
  AND proyResp.idEDDEvalProyEmp = IN_idEDDEvalProyEmp
  AND proyResp.idEDDEvalPregunta = IN_idEDDEvalPregunta
ORDER BY
  eval.nomEvaluacion ASC
LIMIT
  IN_inicio, IN_cantidadPorPagina;

-- CUANDO idEDDProyEmp y idEDDEvalProyEmp y idEDDEvalRespPreg no son nulos
WHEN IN_idEDDEvaluacion = 0
AND IN_idEDDProyEmp != 0
AND IN_idEDDEvalProyEmp != 0
AND IN_idEDDEvalPregunta = 0
AND IN_idEDDEvalRespPreg != 0 THEN
SET
  @temp_cantRegistros = (
    SELECT
      COUNT(idEDDEvalProyResp)
    FROM
      eddevalproyresp
    WHERE
      isActive = true
      AND idEDDProyEmp = IN_idEDDProyEmp
      AND idEDDEvalProyEmp = IN_idEDDEvalProyEmp
      AND idEDDEvalRespPreg = IN_idEDDEvalRespPreg
  );


SELECT
  @temp_cantRegistros,
  proyResp.idEDDEvalProyResp,
  proyResp.idEDDEvaluacion,
  proyResp.idEDDProyEmp,
  UPPER(proyResp.respuesta) as respuesta,
  proyResp.idEDDEvalProyEmp,
  proyResp.idEDDEvalPregunta,
  proyResp.idEDDEvalRespPreg,
  UPPER(eval.nomEvaluacion) as nomEvaluacion,
  UPPER(evalPregunta.nomPregunta) as nomPregunta,
  UPPER(evalRespPreg.nomRespPreg) as nomRespPreg
FROM
  eddevalproyresp proyResp
  INNER JOIN eddevaluacion eval ON (proyResp.idEDDEvaluacion = eval.idEDDEvaluacion)
  INNER JOIN eddproyemp proyEmp ON (proyResp.idEDDProyEmp = proyEmp.idEDDProyEmp)
  INNER JOIN eddevalproyemp evalProyEmp ON (
    proyResp.idEDDEvalProyEmp = evalProyEmp.idEDDEvalProyEmp
  )
  INNER JOIN eddevalpregunta evalPregunta ON (
    proyResp.idEDDEvalPregunta = evalPregunta.idEDDEvalPregunta
  )
  INNER JOIN eddevalresppreg evalRespPreg ON (
    proyResp.idEDDEvalRespPreg = evalRespPreg.idEDDEvalRespPreg
  )
WHERE
  proyResp.isActive = true
  AND proyResp.idEDDProyEmp = IN_idEDDProyEmp
  AND proyResp.idEDDEvalProyEmp = IN_idEDDEvalProyEmp
  AND proyResp.idEDDEvalRespPreg = IN_idEDDEvalRespPreg
ORDER BY
  eval.nomEvaluacion ASC
LIMIT
  IN_inicio, IN_cantidadPorPagina;

-- CUANDO idEDDEvalProyEmp y idEDDEvalPregunta y idEDDEvalRespPreg no son nulos
WHEN IN_idEDDEvaluacion = 0
AND IN_idEDDProyEmp = 0
AND IN_idEDDEvalProyEmp != 0
AND IN_idEDDEvalPregunta != 0
AND IN_idEDDEvalRespPreg != 0 THEN
SET
  @temp_cantRegistros = (
    SELECT
      COUNT(idEDDEvalProyResp)
    FROM
      eddevalproyresp
    WHERE
      isActive = true
      AND idEDDEvalProyEmp = IN_idEDDEvalProyEmp
      AND idEDDEvalPregunta = IN_idEDDEvalPregunta
      AND idEDDEvalRespPreg = IN_idEDDEvalRespPreg
  );


SELECT
  @temp_cantRegistros,
  proyResp.idEDDEvalProyResp,
  proyResp.idEDDEvaluacion,
  proyResp.idEDDProyEmp,
  UPPER(proyResp.respuesta) as respuesta,
  proyResp.idEDDEvalProyEmp,
  proyResp.idEDDEvalPregunta,
  proyResp.idEDDEvalRespPreg,
  UPPER(eval.nomEvaluacion) as nomEvaluacion,
  UPPER(evalPregunta.nomPregunta) as nomPregunta,
  UPPER(evalRespPreg.nomRespPreg) as nomRespPreg
FROM
  eddevalproyresp proyResp
  INNER JOIN eddevaluacion eval ON (proyResp.idEDDEvaluacion = eval.idEDDEvaluacion)
  INNER JOIN eddproyemp proyEmp ON (proyResp.idEDDProyEmp = proyEmp.idEDDProyEmp)
  INNER JOIN eddevalproyemp evalProyEmp ON (
    proyResp.idEDDEvalProyEmp = evalProyEmp.idEDDEvalProyEmp
  )
  INNER JOIN eddevalpregunta evalPregunta ON (
    proyResp.idEDDEvalPregunta = evalPregunta.idEDDEvalPregunta
  )
  INNER JOIN eddevalresppreg evalRespPreg ON (
    proyResp.idEDDEvalRespPreg = evalRespPreg.idEDDEvalRespPreg
  )
WHERE
  proyResp.isActive = true
  AND proyResp.idEDDEvalProyEmp = IN_idEDDEvalProyEmp
  AND proyResp.idEDDEvalPregunta = IN_idEDDEvalPregunta
  AND proyResp.idEDDEvalRespPreg = IN_idEDDEvalRespPreg
ORDER BY
  eval.nomEvaluacion ASC
LIMIT
  IN_inicio, IN_cantidadPorPagina;
  
-- CUANDO idEDDEvalProyEmp y idEDDEvalPregunta y idEDDEvaluacion no son nulos
WHEN IN_idEDDEvaluacion != 0
AND IN_idEDDProyEmp = 0
AND IN_idEDDEvalProyEmp != 0
AND IN_idEDDEvalPregunta != 0
AND IN_idEDDEvalRespPreg = 0 THEN
SET
  @temp_cantRegistros = (
    SELECT
      COUNT(idEDDEvalProyResp)
    FROM
      eddevalproyresp
    WHERE
      isActive = true
      AND idEDDEvalProyEmp = IN_idEDDEvalProyEmp
      AND idEDDEvalPregunta = IN_idEDDEvalPregunta
      AND idEDDEvaluacion = IN_idEDDEvaluacion
  );


SELECT
  @temp_cantRegistros,
  proyResp.idEDDEvalProyResp,
  proyResp.idEDDEvaluacion,
  proyResp.idEDDProyEmp,
  UPPER(proyResp.respuesta) as respuesta,
  proyResp.idEDDEvalProyEmp,
  proyResp.idEDDEvalPregunta,
  proyResp.idEDDEvalRespPreg,
  UPPER(eval.nomEvaluacion) as nomEvaluacion,
  UPPER(evalPregunta.nomPregunta) as nomPregunta,
  UPPER(evalRespPreg.nomRespPreg) as nomRespPreg
FROM
  eddevalproyresp proyResp
  INNER JOIN eddevaluacion eval ON (proyResp.idEDDEvaluacion = eval.idEDDEvaluacion)
  INNER JOIN eddproyemp proyEmp ON (proyResp.idEDDProyEmp = proyEmp.idEDDProyEmp)
  INNER JOIN eddevalproyemp evalProyEmp ON (
    proyResp.idEDDEvalProyEmp = evalProyEmp.idEDDEvalProyEmp
  )
  INNER JOIN eddevalpregunta evalPregunta ON (
    proyResp.idEDDEvalPregunta = evalPregunta.idEDDEvalPregunta
  )
  INNER JOIN eddevalresppreg evalRespPreg ON (
    proyResp.idEDDEvalRespPreg = evalRespPreg.idEDDEvalRespPreg
  )
WHERE
  proyResp.isActive = true
  AND proyResp.idEDDEvalProyEmp = IN_idEDDEvalProyEmp
  AND proyResp.idEDDEvalPregunta = IN_idEDDEvalPregunta
  AND proyResp.idEDDEvaluacion = IN_idEDDEvaluacion
ORDER BY
  eval.nomEvaluacion ASC
LIMIT
  IN_inicio, IN_cantidadPorPagina;

-- CUANDO idEDDEvalPregunta y idEDDEvalRespPreg y idEDDProyEmp no son nulos
WHEN IN_idEDDEvaluacion = 0
AND IN_idEDDProyEmp != 0
AND IN_idEDDEvalProyEmp = 0
AND IN_idEDDEvalPregunta != 0
AND IN_idEDDEvalRespPreg != 0 THEN
SET
  @temp_cantRegistros = (
    SELECT
      COUNT(idEDDEvalProyResp)
    FROM
      eddevalproyresp
    WHERE
      isActive = true
      AND idEDDEvalPregunta = IN_idEDDEvalPregunta
      AND idEDDEvalRespPreg = IN_idEDDEvalRespPreg
      AND idEDDProyEmp = IN_idEDDProyEmp
  );


SELECT
  @temp_cantRegistros,
  proyResp.idEDDEvalProyResp,
  proyResp.idEDDEvaluacion,
  proyResp.idEDDProyEmp,
  UPPER(proyResp.respuesta) as respuesta,
  proyResp.idEDDEvalProyEmp,
  proyResp.idEDDEvalPregunta,
  proyResp.idEDDEvalRespPreg,
  UPPER(eval.nomEvaluacion) as nomEvaluacion,
  UPPER(evalPregunta.nomPregunta) as nomPregunta,
  UPPER(evalRespPreg.nomRespPreg) as nomRespPreg
FROM
  eddevalproyresp proyResp
  INNER JOIN eddevaluacion eval ON (proyResp.idEDDEvaluacion = eval.idEDDEvaluacion)
  INNER JOIN eddproyemp proyEmp ON (proyResp.idEDDProyEmp = proyEmp.idEDDProyEmp)
  INNER JOIN eddevalproyemp evalProyEmp ON (
    proyResp.idEDDEvalProyEmp = evalProyEmp.idEDDEvalProyEmp
  )
  INNER JOIN eddevalpregunta evalPregunta ON (
    proyResp.idEDDEvalPregunta = evalPregunta.idEDDEvalPregunta
  )
  INNER JOIN eddevalresppreg evalRespPreg ON (
    proyResp.idEDDEvalRespPreg = evalRespPreg.idEDDEvalRespPreg
  )
WHERE
  proyResp.isActive = true
  AND proyResp.idEDDEvalPregunta = IN_idEDDEvalPregunta
  AND proyResp.idEDDEvalRespPreg = IN_idEDDEvalRespPreg
  AND proyResp.idEDDProyEmp = IN_idEDDProyEmp
ORDER BY
  eval.nomEvaluacion ASC
LIMIT
  IN_inicio, IN_cantidadPorPagina;

-- CUANDO idEDDEvalPregunta y idEDDEvalRespPreg y idEDDEvaluacion no son nulos
WHEN IN_idEDDEvaluacion != 0
AND IN_idEDDProyEmp = 0
AND IN_idEDDEvalProyEmp = 0
AND IN_idEDDEvalPregunta != 0
AND IN_idEDDEvalRespPreg != 0 THEN
SET
  @temp_cantRegistros = (
    SELECT
      COUNT(idEDDEvalProyResp)
    FROM
      eddevalproyresp
    WHERE
      isActive = true
      AND idEDDEvalPregunta = IN_idEDDEvalPregunta
      AND idEDDEvalRespPreg = IN_idEDDEvalRespPreg
      AND idEDDEvaluacion = IN_idEDDEvaluacion
  );


SELECT
  @temp_cantRegistros,
  proyResp.idEDDEvalProyResp,
  proyResp.idEDDEvaluacion,
  proyResp.idEDDProyEmp,
  UPPER(proyResp.respuesta) as respuesta,
  proyResp.idEDDEvalProyEmp,
  proyResp.idEDDEvalPregunta,
  proyResp.idEDDEvalRespPreg,
  UPPER(eval.nomEvaluacion) as nomEvaluacion,
  UPPER(evalPregunta.nomPregunta) as nomPregunta,
  UPPER(evalRespPreg.nomRespPreg) as nomRespPreg
FROM
  eddevalproyresp proyResp
  INNER JOIN eddevaluacion eval ON (proyResp.idEDDEvaluacion = eval.idEDDEvaluacion)
  INNER JOIN eddproyemp proyEmp ON (proyResp.idEDDProyEmp = proyEmp.idEDDProyEmp)
  INNER JOIN eddevalproyemp evalProyEmp ON (
    proyResp.idEDDEvalProyEmp = evalProyEmp.idEDDEvalProyEmp
  )
  INNER JOIN eddevalpregunta evalPregunta ON (
    proyResp.idEDDEvalPregunta = evalPregunta.idEDDEvalPregunta
  )
  INNER JOIN eddevalresppreg evalRespPreg ON (
    proyResp.idEDDEvalRespPreg = evalRespPreg.idEDDEvalRespPreg
  )
WHERE
  proyResp.isActive = true
  AND proyResp.idEDDEvalPregunta = IN_idEDDEvalPregunta
  AND proyResp.idEDDEvalRespPreg = IN_idEDDEvalRespPreg
  AND proyResp.idEDDEvaluacion = IN_idEDDEvaluacion
ORDER BY
  eval.nomEvaluacion ASC
LIMIT
  IN_inicio, IN_cantidadPorPagina;

-- CUANDO idEDDEvaluacion y idEDDProyEmp y idEDDEvalProyEmp y idEDDEvalPregunta no son nulos
WHEN IN_idEDDEvaluacion != 0
AND IN_idEDDProyEmp != 0
AND IN_idEDDEvalProyEmp != 0
AND IN_idEDDEvalPregunta != 0
AND IN_idEDDEvalRespPreg = 0 THEN
SET
  @temp_cantRegistros = (
    SELECT
      COUNT(idEDDEvalProyResp)
    FROM
      eddevalproyresp
    WHERE
      isActive = true
      AND idEDDEvaluacion = IN_idEDDEvaluacion
      AND idEDDProyEmp = IN_idEDDProyEmp
      AND idEDDEvalProyEmp = IN_idEDDEvalProyEmp
      AND idEDDEvalPregunta = IN_idEDDEvalPregunta
  );


SELECT
  @temp_cantRegistros,
  proyResp.idEDDEvalProyResp,
  proyResp.idEDDEvaluacion,
  proyResp.idEDDProyEmp,
  UPPER(proyResp.respuesta) as respuesta,
  proyResp.idEDDEvalProyEmp,
  proyResp.idEDDEvalPregunta,
  proyResp.idEDDEvalRespPreg,
  UPPER(eval.nomEvaluacion) as nomEvaluacion,
  UPPER(evalPregunta.nomPregunta) as nomPregunta,
  UPPER(evalRespPreg.nomRespPreg) as nomRespPreg
FROM
  eddevalproyresp proyResp
  INNER JOIN eddevaluacion eval ON (proyResp.idEDDEvaluacion = eval.idEDDEvaluacion)
  INNER JOIN eddproyemp proyEmp ON (proyResp.idEDDProyEmp = proyEmp.idEDDProyEmp)
  INNER JOIN eddevalproyemp evalProyEmp ON (
    proyResp.idEDDEvalProyEmp = evalProyEmp.idEDDEvalProyEmp
  )
  INNER JOIN eddevalpregunta evalPregunta ON (
    proyResp.idEDDEvalPregunta = evalPregunta.idEDDEvalPregunta
  )
  INNER JOIN eddevalresppreg evalRespPreg ON (
    proyResp.idEDDEvalRespPreg = evalRespPreg.idEDDEvalRespPreg
  )
WHERE
  proyResp.isActive = true
  AND proyResp.idEDDEvaluacion = IN_idEDDEvaluacion
  AND proyResp.idEDDProyEmp = IN_idEDDProyEmp
  AND proyResp.idEDDEvalProyEmp = IN_idEDDEvalProyEmp
  AND proyResp.idEDDEvalPregunta = IN_idEDDEvalPregunta
ORDER BY
  eval.nomEvaluacion ASC
LIMIT
  IN_inicio, IN_cantidadPorPagina;

-- CUANDO idEDDEvaluacion y idEDDProyEmp y idEDDEvalProyEmp y idEDDEvalRespPreg no son nulos
WHEN IN_idEDDEvaluacion != 0
AND IN_idEDDProyEmp != 0
AND IN_idEDDEvalProyEmp != 0
AND IN_idEDDEvalPregunta = 0
AND IN_idEDDEvalRespPreg != 0 THEN
SET
  @temp_cantRegistros = (
    SELECT
      COUNT(idEDDEvalProyResp)
    FROM
      eddevalproyresp
    WHERE
      isActive = true
      AND idEDDEvaluacion = IN_idEDDEvaluacion
      AND idEDDProyEmp = IN_idEDDProyEmp
      AND idEDDEvalProyEmp = IN_idEDDEvalProyEmp
      AND idEDDEvalRespPreg = IN_idEDDEvalRespPreg
  );


SELECT
  @temp_cantRegistros,
  proyResp.idEDDEvalProyResp,
  proyResp.idEDDEvaluacion,
  proyResp.idEDDProyEmp,
  UPPER(proyResp.respuesta) as respuesta,
  proyResp.idEDDEvalProyEmp,
  proyResp.idEDDEvalPregunta,
  proyResp.idEDDEvalRespPreg,
  UPPER(eval.nomEvaluacion) as nomEvaluacion,
  UPPER(evalPregunta.nomPregunta) as nomPregunta,
  UPPER(evalRespPreg.nomRespPreg) as nomRespPreg
FROM
  eddevalproyresp proyResp
  INNER JOIN eddevaluacion eval ON (proyResp.idEDDEvaluacion = eval.idEDDEvaluacion)
  INNER JOIN eddproyemp proyEmp ON (proyResp.idEDDProyEmp = proyEmp.idEDDProyEmp)
  INNER JOIN eddevalproyemp evalProyEmp ON (
    proyResp.idEDDEvalProyEmp = evalProyEmp.idEDDEvalProyEmp
  )
  INNER JOIN eddevalpregunta evalPregunta ON (
    proyResp.idEDDEvalPregunta = evalPregunta.idEDDEvalPregunta
  )
  INNER JOIN eddevalresppreg evalRespPreg ON (
    proyResp.idEDDEvalRespPreg = evalRespPreg.idEDDEvalRespPreg
  )
WHERE
  proyResp.isActive = true
  AND proyResp.idEDDEvaluacion = IN_idEDDEvaluacion
  AND proyResp.idEDDProyEmp = IN_idEDDProyEmp
  AND proyResp.idEDDEvalProyEmp = IN_idEDDEvalProyEmp
  AND proyResp.idEDDEvalRespPreg = IN_idEDDEvalRespPreg
ORDER BY
  eval.nomEvaluacion ASC
LIMIT
  IN_inicio, IN_cantidadPorPagina;

-- CUANDO idEDDEvaluacion y idEDDProyEmp y idEDDEvalPregunta y idEDDEvalRespPreg no son nulos
WHEN IN_idEDDEvaluacion != 0
AND IN_idEDDProyEmp != 0
AND IN_idEDDEvalProyEmp = 0
AND IN_idEDDEvalPregunta != 0
AND IN_idEDDEvalRespPreg != 0 THEN
SET
  @temp_cantRegistros = (
    SELECT
      COUNT(idEDDEvalProyResp)
    FROM
      eddevalproyresp
    WHERE
      isActive = true
      AND idEDDEvaluacion = IN_idEDDEvaluacion
      AND idEDDProyEmp = IN_idEDDProyEmp
      AND idEDDEvalPregunta = IN_idEDDEvalPregunta
      AND idEDDEvalRespPreg = IN_idEDDEvalRespPreg
  );


SELECT
  @temp_cantRegistros,
  proyResp.idEDDEvalProyResp,
  proyResp.idEDDEvaluacion,
  proyResp.idEDDProyEmp,
  UPPER(proyResp.respuesta) as respuesta,
  proyResp.idEDDEvalProyEmp,
  proyResp.idEDDEvalPregunta,
  proyResp.idEDDEvalRespPreg,
  UPPER(eval.nomEvaluacion) as nomEvaluacion,
  UPPER(evalPregunta.nomPregunta) as nomPregunta,
  UPPER(evalRespPreg.nomRespPreg) as nomRespPreg
FROM
  eddevalproyresp proyResp
  INNER JOIN eddevaluacion eval ON (proyResp.idEDDEvaluacion = eval.idEDDEvaluacion)
  INNER JOIN eddproyemp proyEmp ON (proyResp.idEDDProyEmp = proyEmp.idEDDProyEmp)
  INNER JOIN eddevalproyemp evalProyEmp ON (
    proyResp.idEDDEvalProyEmp = evalProyEmp.idEDDEvalProyEmp
  )
  INNER JOIN eddevalpregunta evalPregunta ON (
    proyResp.idEDDEvalPregunta = evalPregunta.idEDDEvalPregunta
  )
  INNER JOIN eddevalresppreg evalRespPreg ON (
    proyResp.idEDDEvalRespPreg = evalRespPreg.idEDDEvalRespPreg
  )
WHERE
  proyResp.isActive = true
  AND proyResp.idEDDEvaluacion = IN_idEDDEvaluacion
  AND proyResp.idEDDProyEmp = IN_idEDDProyEmp
  AND proyResp.idEDDEvalPregunta = IN_idEDDEvalPregunta
  AND proyResp.idEDDEvalRespPreg = IN_idEDDEvalRespPreg
ORDER BY
  eval.nomEvaluacion ASC
LIMIT
  IN_inicio, IN_cantidadPorPagina;

-- CUANDO idEDDEvaluacion y idEDDEvalProyEmp y idEDDEvalPregunta y idEDDEvalRespPreg no son nulos
WHEN IN_idEDDEvaluacion != 0
AND IN_idEDDProyEmp = 0
AND IN_idEDDEvalProyEmp != 0
AND IN_idEDDEvalPregunta != 0
AND IN_idEDDEvalRespPreg != 0 THEN
SET
  @temp_cantRegistros = (
    SELECT
      COUNT(idEDDEvalProyResp)
    FROM
      eddevalproyresp
    WHERE
      isActive = true
      AND idEDDEvaluacion = IN_idEDDEvaluacion
      AND idEDDEvalProyEmp = IN_idEDDEvalProyEmp
      AND idEDDEvalPregunta = IN_idEDDEvalPregunta
      AND idEDDEvalRespPreg = IN_idEDDEvalRespPreg
  );


SELECT
  @temp_cantRegistros,
  proyResp.idEDDEvalProyResp,
  proyResp.idEDDEvaluacion,
  proyResp.idEDDProyEmp,
  UPPER(proyResp.respuesta) as respuesta,
  proyResp.idEDDEvalProyEmp,
  proyResp.idEDDEvalPregunta,
  proyResp.idEDDEvalRespPreg,
  UPPER(eval.nomEvaluacion) as nomEvaluacion,
  UPPER(evalPregunta.nomPregunta) as nomPregunta,
  UPPER(evalRespPreg.nomRespPreg) as nomRespPreg
FROM
  eddevalproyresp proyResp
  INNER JOIN eddevaluacion eval ON (proyResp.idEDDEvaluacion = eval.idEDDEvaluacion)
  INNER JOIN eddproyemp proyEmp ON (proyResp.idEDDProyEmp = proyEmp.idEDDProyEmp)
  INNER JOIN eddevalproyemp evalProyEmp ON (
    proyResp.idEDDEvalProyEmp = evalProyEmp.idEDDEvalProyEmp
  )
  INNER JOIN eddevalpregunta evalPregunta ON (
    proyResp.idEDDEvalPregunta = evalPregunta.idEDDEvalPregunta
  )
  INNER JOIN eddevalresppreg evalRespPreg ON (
    proyResp.idEDDEvalRespPreg = evalRespPreg.idEDDEvalRespPreg
  )
WHERE
  proyResp.isActive = true
  AND proyResp.idEDDEvaluacion = IN_idEDDEvaluacion
  AND proyResp.idEDDEvalProyEmp = IN_idEDDEvalProyEmp
  AND proyResp.idEDDEvalPregunta = IN_idEDDEvalPregunta
  AND proyResp.idEDDEvalRespPreg = IN_idEDDEvalRespPreg
ORDER BY
  eval.nomEvaluacion ASC
LIMIT
  IN_inicio, IN_cantidadPorPagina;


 -- CUANDO idEDDProyEmp y idEDDEvalProyEmp y idEDDEvalPregunta y idEDDEvalRespPreg no son nulos
WHEN IN_idEDDEvaluacion = 0
AND IN_idEDDProyEmp != 0
AND IN_idEDDEvalProyEmp != 0
AND IN_idEDDEvalPregunta != 0
AND IN_idEDDEvalRespPreg != 0 THEN
SET
  @temp_cantRegistros = (
    SELECT
      COUNT(idEDDEvalProyResp)
    FROM
      eddevalproyresp
    WHERE
      isActive = true
      AND idEDDProyEmp = IN_idEDDProyEmp
      AND idEDDEvalProyEmp = IN_idEDDEvalProyEmp
      AND idEDDEvalPregunta = IN_idEDDEvalPregunta
      AND idEDDEvalRespPreg = IN_idEDDEvalRespPreg
  );


SELECT
  @temp_cantRegistros,
  proyResp.idEDDEvalProyResp,
  proyResp.idEDDEvaluacion,
  proyResp.idEDDProyEmp,
  UPPER(proyResp.respuesta) as respuesta,
  proyResp.idEDDEvalProyEmp,
  proyResp.idEDDEvalPregunta,
  proyResp.idEDDEvalRespPreg,
  UPPER(eval.nomEvaluacion) as nomEvaluacion,
  UPPER(evalPregunta.nomPregunta) as nomPregunta,
  UPPER(evalRespPreg.nomRespPreg) as nomRespPreg
FROM
  eddevalproyresp proyResp
  INNER JOIN eddevaluacion eval ON (proyResp.idEDDEvaluacion = eval.idEDDEvaluacion)
  INNER JOIN eddproyemp proyEmp ON (proyResp.idEDDProyEmp = proyEmp.idEDDProyEmp)
  INNER JOIN eddevalproyemp evalProyEmp ON (
    proyResp.idEDDEvalProyEmp = evalProyEmp.idEDDEvalProyEmp
  )
  INNER JOIN eddevalpregunta evalPregunta ON (
    proyResp.idEDDEvalPregunta = evalPregunta.idEDDEvalPregunta
  )
  INNER JOIN eddevalresppreg evalRespPreg ON (
    proyResp.idEDDEvalRespPreg = evalRespPreg.idEDDEvalRespPreg
  )
WHERE
  proyResp.isActive = true
  AND proyResp.idEDDProyEmp = IN_idEDDProyEmp
  AND proyResp.idEDDEvalProyEmp = IN_idEDDEvalProyEmp
  AND proyResp.idEDDEvalPregunta = IN_idEDDEvalPregunta
  AND proyResp.idEDDEvalRespPreg = IN_idEDDEvalRespPreg
ORDER BY
  eval.nomEvaluacion ASC
LIMIT
  IN_inicio, IN_cantidadPorPagina;
 
 -- CUANDO NINGUNA ES NULA
WHEN IN_idEDDEvaluacion != 0
AND IN_idEDDProyEmp != 0
AND IN_idEDDEvalProyEmp != 0
AND IN_idEDDEvalPregunta != 0
AND IN_idEDDEvalRespPreg != 0 THEN
SET
  @temp_cantRegistros = (
    SELECT
      COUNT(idEDDEvalProyResp)
    FROM
      eddevalproyresp
    WHERE
      isActive = true
      AND idEDDEvaluacion = IN_idEDDEvaluacion
      AND idEDDProyEmp = IN_idEDDProyEmp
      AND idEDDEvalProyEmp = IN_idEDDEvalProyEmp
      AND idEDDEvalPregunta = IN_idEDDEvalPregunta
      AND idEDDEvalRespPreg = IN_idEDDEvalRespPreg
  );


SELECT
  @temp_cantRegistros,
  proyResp.idEDDEvalProyResp,
  proyResp.idEDDEvaluacion,
  proyResp.idEDDProyEmp,
  UPPER(proyResp.respuesta) as respuesta,
  proyResp.idEDDEvalProyEmp,
  proyResp.idEDDEvalPregunta,
  proyResp.idEDDEvalRespPreg,
  UPPER(eval.nomEvaluacion) as nomEvaluacion,
  UPPER(evalPregunta.nomPregunta) as nomPregunta,
  UPPER(evalRespPreg.nomRespPreg) as nomRespPreg
FROM
  eddevalproyresp proyResp
  INNER JOIN eddevaluacion eval ON (proyResp.idEDDEvaluacion = eval.idEDDEvaluacion)
  INNER JOIN eddproyemp proyEmp ON (proyResp.idEDDProyEmp = proyEmp.idEDDProyEmp)
  INNER JOIN eddevalproyemp evalProyEmp ON (
    proyResp.idEDDEvalProyEmp = evalProyEmp.idEDDEvalProyEmp
  )
  INNER JOIN eddevalpregunta evalPregunta ON (
    proyResp.idEDDEvalPregunta = evalPregunta.idEDDEvalPregunta
  )
  INNER JOIN eddevalresppreg evalRespPreg ON (
    proyResp.idEDDEvalRespPreg = evalRespPreg.idEDDEvalRespPreg
  )
WHERE
  proyResp.isActive = true
  AND proyResp.idEDDEvaluacion = IN_idEDDEvaluacion
  AND proyResp.idEDDProyEmp = IN_idEDDProyEmp
  AND proyResp.idEDDEvalProyEmp = IN_idEDDEvalProyEmp
  AND proyResp.idEDDEvalPregunta = IN_idEDDEvalPregunta
  AND proyResp.idEDDEvalRespPreg = IN_idEDDEvalRespPreg
ORDER BY
  eval.nomEvaluacion ASC
LIMIT
  IN_inicio, IN_cantidadPorPagina;



END CASE
;


END