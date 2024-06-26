<?php

include("../../model/conexion.php");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['listados'])) {
    $data = json_decode(file_get_contents("php://input"));
    $data->idProyecto = "" || null ? $idProyecto = null : $idProyecto = $data->idProyecto;
    $data->mes = "" || null ? $mes = null : $mes = $data->mes;
    
    $query = "CALL SP_ihh_aux_listadoValorHH('$idProyecto', '$mes')";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }
    $json = array();

    while ($row = mysqli_fetch_array($result)) {
        $json[] = array(
            'idEmpleado' => $row['idEmpleado'],
            'nomEmpleado' => $row['nomEmpleado'],
            'valorHH' => $row['valorHH']
        );
    }
    $jsonstring = json_encode(($json)); 
    echo $jsonstring;
    mysqli_close($conection);
} else {
    echo json_encode("Error");
}