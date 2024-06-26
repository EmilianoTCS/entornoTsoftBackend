<?php

include("../../model/conexion.php");
include("../paginador/cantPaginas.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['listadoEvaluacionesPorEmpleado'])) {
    $data = json_decode(file_get_contents("php://input"));
    $idEmpleado = $data->idEmpleado;
    
    $query = "CALL SP_listadoEvaluacionesPorEmpleado('$idEmpleado')";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    $json = array();
    while ($row = mysqli_fetch_array($result)) {
        $json[] = array(
            'idEDDEvaluacion' => $row['idEDDEvaluacion'],
            'nomEvaluacion' => $row['nomEvaluacion']
        );
    }
    $jsonstring = json_encode(($json)); 
    echo $jsonstring;
    mysqli_close($conection);
}
