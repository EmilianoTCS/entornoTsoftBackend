<?php

include("../../model/conexion.php");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['listados'])) {
    $query = "CALL SP_AUX_listadoSesionForms()";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }


    while ($row = mysqli_fetch_array($result)) {
        $json[] = array(
            'idSesion' => $row['idSesion'],
            'nomSesion' => $row['UPPER(nomSesion)']
        );
    }
    $jsonstring = json_encode(($json));
    echo $jsonstring;
    mysqli_close($conection);
} else {
    echo json_encode("Error");
}