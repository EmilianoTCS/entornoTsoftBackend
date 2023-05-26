<?php

include("../../model/conexion.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['editarRelatorRamo'])) {

    $data = json_decode(file_get_contents("php://input"));
    $idRelatorRamo = $data->idRelatorRamo;
    $fechaIni = $data->fechaIni;
    $fechaFin = $data->fechaFin;
    $isActive = $data->isActive;
    $idEmpleado = $data->idEmpleado;
    $idRamo = $data->idRamo;
    $usuarioCreacion = $data->usuarioCreacion;


    $query = "CALL SP_editarRelatorRamo($idRelatorRamo,'$fechaIni', '$fechaFin', '$isActive',$idEmpleado, $idRamo, '$usuarioCreacion', @p0, @p1)";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    $json = array();
    while ($row = mysqli_fetch_array($result)) {
        $json[] = array(
            'idRelatorRamo' => $row['idRelatorRamo'],
            'fechaIni' => $row['fechaIni'],
            'fechaFin' => $row['fechaFin'],
            'nomEmpleado' => $row['UPPER(emp.nomEmpleado)'],
            'nomRamo' => $row['UPPER(ram.nomRamo)']
        );
    }
    $jsonstring = json_encode($json);
    echo $jsonstring;
}
