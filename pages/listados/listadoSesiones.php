<?php

include("../../model/conexion.php");
include("../paginador/cantPaginas.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['listadoSesiones'])) {

    $data = json_decode(file_get_contents("php://input"));
    $data->num_boton = "" || null ? $num_boton = 1 : $num_boton = $data->num_boton;
    $data->cantidadPorPagina = "" || null ? $cantidadPorPagina = 10 : $cantidadPorPagina = $data->cantidadPorPagina;
    $inicio = ($num_boton - 1) * $cantidadPorPagina;


    $query = "CALL SP_listadoSesiones('$inicio', '$cantidadPorPagina')";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    $json = array();
    while ($row = mysqli_fetch_array($result)) {
        $json[] = array(
            'idSesion' => $row['idSesion'],
            'nroSesion' => $row['nroSesion'],
            'nomSesion' => $row['UPPER(se.nomSesion)'],
            'tipoSesion' => $row['UPPER(se.tipoSesion)'],
            'tipoSesionHH' => $row['UPPER(se.tipoSesionHH)'],
            'duracionSesionHH' => $row['UPPER(se.duracionSesionHH)'],
            'nomRamo' => $row['UPPER(ram.nomRamo)']
        );
        $FN_cantPaginas = cantPaginas($row['@temp_cantRegistros'], $cantidadPorPagina);
    }
    $jsonstring = json_encode([
        'datos' => $json,
        'paginador' => $FN_cantPaginas
    ]);
    echo $jsonstring;
}
