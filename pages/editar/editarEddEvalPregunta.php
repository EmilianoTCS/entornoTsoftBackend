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
    $preguntaObligatoria = $data->preguntaObligatoria;
    $tipoResp = $data->tipoResp;
    $usuarioModificacion = $data->usuarioModificacion;


    $query = "CALL SP_editarEddEvalPregunta( $idEDDEvalPregunta, '$nomPregunta', '$ordenPregunta', '$isActive', '$idEDDEvaluacion','$idEDDEvalCompetencia', '$preguntaObligatoria','$tipoResp', '$usuarioModificacion', @p0, @p1)";
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
                'OUT_CODRESULT' => $row['OUT_CODRESULT'],
                'OUT_MJERESULT' => $row['OUT_MJERESULT'],
                'idEDDEvalProyResp' => $row['idEDDEvalProyResp'],
                'idEDDEvaluacion' => $row['idEDDEvaluacion'],
                'idEDDProyEmp' => $row['idEDDProyEmp'],
                'respuesta' => $row['respuesta'],
                'idEDDEvalProyEmp' => $row['idEDDEvalProyEmp'],
                'idEDDEvalRespPreg' => $row['idEDDEvalRespPreg'],
                'pregunta' => $row['pregunta'],
                'ordenPregunta' => $row['ordenPregunta'],
                'nomEvaluado' => $row['nomEvaluado'],
                'nomEvaluador' => $row['nomEvaluador'],
                'nomEvaluacion' => $row['nomEvaluacion'],
                'nomCompetencia' => $row['nomCompetencia'],
                'verEnDashboard' => $row['verEnDashboard'],
                'ordenDashboard' => $row['ordenDashboard'],
            );
        }
    }
    $jsonstring = json_encode($json);
    echo $jsonstring;
} else {
    echo json_encode("Error");
}
