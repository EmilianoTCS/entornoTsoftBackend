<?php

include("../../model/conexion.php");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
date_default_timezone_set("America/Argentina/Buenos_Aires");
if (isset($_GET['insertarEddEvalProyResp'])) {
    $data = json_decode(file_get_contents("php://input"));
    $datosExtra = $data->datosExtra;
    $respuestas = $data->respuestas;


    $idEDDEvaluacion = $datosExtra->idEDDEvaluacion;
    $idEDDProyEmpEvaluador = $datosExtra->idEDDProyEmpEvaluador;
    $fechaInicioExamen = date('Y-m-d H:i:s', strtotime($datosExtra->fechaInicioExamen));
    $fechaFinExamen = date('Y-m-d H:i:s', strtotime($datosExtra->fechaFinExamen));
    $usuarioCreacion = $datosExtra->usuarioCreacion;
    $isActive = true;


    foreach ($respuestas as $item) {
        $query = "CALL SP_insertarEddEvalProyResp(
            $idEDDEvaluacion,
            $idEDDProyEmpEvaluador,
            '$fechaInicioExamen',
            '$fechaFinExamen',
            '$item->respuesta',
            $isActive,
            $idEDDProyEmpEvaluador,
            $item->idEDDEvalPregunta,
            $item->idEDDEvalRespPreg,
            '$usuarioCreacion',
            @p0,
            @p1
            )";

        $result = mysqli_query($conection, $query);
        if (!$result) {
            die('Query Failed' . mysqli_error($conection));
        }
        mysqli_next_result($conection);
    }
    echo json_encode("success");
} else {
    echo json_encode("Error");
}
