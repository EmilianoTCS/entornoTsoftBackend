BEGIN IF IN_idEDDEvalPregunta = 0 THEN
SET
    @temp_cantRegistros = (
        SELECT
            COUNT(idEDDEvalRespPreg)
        FROM
            eddevalresppreg
        WHERE
            isActive = true
    );

SELECT
    @temp_cantRegistros,
    respPreg.idEDDEvalRespPreg,
    UPPER(respPreg.nomRespPreg) as nomRespPreg,
    respPreg.ordenRespPreg,
    respPreg.idEDDEvalPregunta,
    UPPER(evaPreg.nomPregunta) as nomPregunta
FROM
    eddevalresppreg respPreg
    INNER JOIN eddevalpregunta evaPreg ON (
        respPreg.idEDDEvalPregunta = evaPreg.idEDDEvalPregunta
    )
     INNER JOIN eddevalpregunta evaPreg ON (
        respPreg.idEDDEvalPregunta = evaPreg.idEDDEvalPregunta
    )
WHERE
    respPreg.isActive = true
ORDER BY
    respPreg.nomRespPreg ASC
LIMIT
    IN_inicio, IN_cantidadPorPagina;

ELSE
SET
    @temp_cantRegistros = (
        SELECT
            COUNT(idEDDEvalRespPreg)
        FROM
            eddevalresppreg
        WHERE
            isActive = true
            AND idEDDEvalPregunta = IN_idEDDEvalPregunta
    );

SELECT
    @temp_cantRegistros,
    respPreg.idEDDEvalRespPreg,
    UPPER(respPreg.nomRespPreg) as nomRespPreg,
    respPreg.ordenRespPreg,
    respPreg.idEDDEvalPregunta,
    UPPER(evaPreg.nomPregunta) as nomPregunta
FROM
    eddevalresppreg respPreg
    INNER JOIN eddevalpregunta evaPreg ON (
        respPreg.idEDDEvalPregunta = evaPreg.idEDDEvalPregunta
    )
WHERE
    respPreg.isActive = true
    AND respPreg.idEDDEvalPregunta = IN_idEDDEvalPregunta
ORDER BY
    respPreg.nomRespPreg ASC
LIMIT
    IN_inicio, IN_cantidadPorPagina;

END IF;

END