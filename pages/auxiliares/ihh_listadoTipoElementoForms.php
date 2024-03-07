<?php

include("../../model/conexion.php");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['listados'])) {
    $query = "CALL SP_ihh_aux_listadoTipoElemento(@p0, @p1)";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }
    $json = array();


    while ($row = mysqli_fetch_array($result)) {
        $json[] = array(
            'idTipoElemento' => $row['idTipoElemento'],
            'nomTipoElemento' => $row['nomTipoElemento']
        );
    }
    $jsonstring = json_encode(($json)); 
    echo $jsonstring;
    mysqli_close($conection);
} else {
    echo json_encode("Error");
}
