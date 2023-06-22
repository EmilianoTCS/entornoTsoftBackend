<?php

include("../../model/conexion.php");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['editarEddEvalRespPreg'])) {
    $data = json_decode(file_get_contents("php://input"));
    $idEDDEvalRespPreg = $data->idEDDEvalRespPreg;
    $nomRespPreg = $data->nomRespPreg;
    $ordenRespPreg = $data->ordenRespPreg;
    $isActive = $data->isActive;
    $idEDDEvalPregunta = $data->idEDDEvalPregunta;
    $usuarioCreacion = $data->usuarioCreacion;


    $query = "CALL SP_editarEddEvalRespPreg('$idEDDEvalRespPreg','$nomRespPreg','$ordenRespPreg', '$isActive', $idEDDEvalPregunta, '$usuarioCreacion', @p0, @p1)";
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
                'idEDDEvalRespPreg' => $row['idEDDEvalRespPreg'],
                'nomRespPreg' => $row['nomRespPreg'],
                'ordenRespPreg' => $row['ordenRespPreg'],
                'idEDDEvalPregunta' => $row['idEDDEvalPregunta'],
                'nomPregunta' => $row['nomPregunta'],

            );
        }
    }
    $jsonstring = json_encode($json);
    echo $jsonstring;
} else {
    echo json_encode("Error");
}
