<?php

include("../../model/conexion.php");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['listados'])) {
    $data = json_decode(file_get_contents("php://input"));
    $fechaIni = $data->fechaIni;
    $fechaFin = $data->fechaFin;
    $query = "CALL SP_ihh_aux_cantDiasNoLaborables('$fechaIni', '$fechaFin', @p0, @p1)";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }
    $json = array();    


    while ($row = mysqli_fetch_array($result)) {
        $json[] = array(
            'cantDias' => $row['cantDias'],
            'mes' => $row['mes'],
        );
    }
    $jsonstring = json_encode(($json)); 
    echo $jsonstring;
    mysqli_close($conection);
} else {
    echo json_encode("Error");
}
