<?php

include("../../model/conexion.php");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['editarEddEvalPregunta'])) {
    $data = json_decode(file_get_contents("php://input"));
    $idEDDEvalPregunta = $data->idEDDEvalPregunta;
    $nomPregunta = $data->nomPregunta;
    $ordenPregunta = $data->ordenPregunta;
    $isActive = $data->isActive;
    $idEDDEvaluacion = $data->idEDDEvaluacion;
    $idEDDEvalCompetencia = $data->idEDDEvalCompetencia;
    $usuarioModificacion = $data->usuarioModificacion;


    $query = "CALL SP_editarEddEvalPregunta( $idEDDEvalPregunta, '$nomPregunta', '$ordenPregunta', '$isActive', '$idEDDEvaluacion','$idEDDEvalCompetencia', '$usuarioModificacion', @p0, @p1)";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }


    $json = array();
    while ($row = mysqli_fetch_array($result)) {
        if ($row['OUT_CODRESULT'] != '00') {
            $json[] = array(
                'OUT_CODRESULT' => $row['OUT_CODRESULT'],
                'OUT_MJERESULT' => $row['OUT_MJERESULT']
            );
        } else {
            $json[] = array(
                'idEDDEvalPregunta' => $row['idEDDEvalPregunta'],
                'nomPregunta' => $row['nomPregunta'],
                'ordenPregunta' => $row['ordenPregunta'],
                'idEDDEvaluacion' => $row['idEDDEvaluacion'],
                'idEDDEvalCompetencia' => $row['idEDDEvalCompetencia'],
                'nomEvaluacion' => $row['nomEvaluacion'],
                'nomCompetencia' => $row['nomCompetencia'],

            );
        }
    }
    $jsonstring = json_encode($json);
    echo $jsonstring;
} else {
    echo json_encode("Error");
}
