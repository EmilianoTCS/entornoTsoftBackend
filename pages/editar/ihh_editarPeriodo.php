<?php

include("../../model/conexion.php");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['ihh_editarPeriodo'])) {
    $data = json_decode(file_get_contents("php://input"));
    $idPeriodo = $data->idPeriodo;
    $idTipoPeriodo = $data->idTipoPeriodo;
    $nomPeriodo = $data->nomPeriodo;
    $descripcion = $data->descripcion;
    $isActive = $data->isActive;
    $usuarioCreacion = $data->usuarioCreacion;

    $query = "CALL SP_ihh_editarPeriodo($idPeriodo,'$idTipoPeriodo','$nomPeriodo','$descripcion','$isActive', '$usuarioCreacion', @p0, @p1)";
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
                'idPeriodo' => $row['idPeriodo'],
                'idTipoPeriodo' => $row['idTipoPeriodo'],
                'nomTipoPeriodo' => $row['nomTipoPeriodo'],
                'descripcion' => $row['descripcion'],
            );
        }
    }
    $jsonstring = json_encode($json);
    echo $jsonstring;
} else {
    echo json_encode("Error");
}
