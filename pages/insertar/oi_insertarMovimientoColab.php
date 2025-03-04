<?php

include("../../model/conexion.php");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['oi_insertarMovimientoColab'])) {
    $data = json_decode(file_get_contents("php://input"));
    $idEmpleado = $data->idEmpleado;
    $idMotivo = $data->idMotivo;
    $fechaIni = $data->fechaIni;
    $fechaFin = $data->fechaFin;
    $isActive = $data->isActive;
    $usuarioCreacion = $data->usuarioCreacion;

    $query = "CALL SP_oi_insertarMovimientoColab(
    '$idEmpleado',
    '$fechaIni',
    '$fechaFin',
    '$idMotivo',
    '$isActive', 
    '$usuarioCreacion', @p0, @p1)";

    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }


    $json = array();
    while ($row = mysqli_fetch_array($result)) {
        $json[] = array(
            'OUT_CODRESULT' => $row['OUT_CODRESULT'],
            'OUT_MJERESULT' => $row['OUT_MJERESULT']
        );
    }
    $jsonstring = json_encode($json);
    echo $jsonstring;
} else {
    echo json_encode("Error");
}
