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

    $idEDDEvaluacion = intval($datosExtra->idEDDEvaluacion);
    $fechaInicioExamen = date('Y-m-d H:i:s', strtotime($datosExtra->fechaInicioExamen));
    $fechaFinExamen = date('Y-m-d H:i:s', strtotime($datosExtra->fechaFinExamen));
    $usuarioCreacion = mysqli_real_escape_string($conection, $datosExtra->usuarioCreacion);
    $isActive = 1; // Asumo que `true` en PHP es equivalente a 1 en SQL.

    foreach ($respuestas as $item) {
        $idEDDProyEmpEvaluador = intval($item->idEDDProyEmpEvaluador);
        $respuesta = mysqli_real_escape_string($conection, $item->respuesta);
        $idEDDEvalProyEmp = intval($item->idEDDEvalProyEmp);
        $idEDDEvalPregunta = intval($item->idEDDEvalPregunta);
        $idEDDEvalRespPreg = intval($item->idEDDEvalRespPreg);

        $query = "CALL SP_insertarEddEvalProyResp(
            $idEDDEvaluacion,
            $idEDDProyEmpEvaluador,
            '$fechaInicioExamen',
            '$fechaFinExamen',
            '$respuesta',
            $isActive,
            $idEDDEvalProyEmp,
            $idEDDEvalPregunta,
            $idEDDEvalRespPreg,
            '$usuarioCreacion',
            @p0,
            @p1
        )";

        $result = mysqli_query($conection, $query);

        if (!$result) {
            die('Query Failed: ' . mysqli_error($conection));
        } else {
            $json = array();
            while ($row = mysqli_fetch_array($result)) {
                $json[] = array(
                    'OUT_CODRESULT' => $row['OUT_CODRESULT'],
                    'OUT_MJERESULT' => $row['OUT_MJERESULT'],
                );
            }
            echo json_encode($json);
        }
        mysqli_next_result($conection);
    }
    echo json_encode("success");
} else {
    echo json_encode("Error");
}
