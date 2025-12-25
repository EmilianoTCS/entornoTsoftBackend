<?php

include("../../model/conexion.php");
include("../paginador/cantPaginas.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['ihh_listadoPeriodo'])) {
    $data = json_decode(file_get_contents("php://input"));
    $data->num_boton = "" || null ? $num_boton = 1 : $num_boton = $data->num_boton;
    $data->idPeriodo = "" || null ? $idPeriodo = null : $idPeriodo = $data->idPeriodo;
    $data->idTipoPeriodo = "" || null ? $idTipoPeriodo = null : $idTipoPeriodo = $data->idTipoPeriodo;
    $data->cantidadPorPagina = "" || null ? $cantidadPorPagina = 10 : $cantidadPorPagina = $data->cantidadPorPagina;
    $inicio = ($num_boton - 1) * $cantidadPorPagina;

    $query = "CALL SP_ihh_listadoPeriodo('$idPeriodo','$idTipoPeriodo', '$inicio', '$cantidadPorPagina')";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    $json = array();
    if (mysqli_num_rows($result) > 0) {

        while ($row = mysqli_fetch_array($result)) {
            $json[] = array(
                'idPeriodo' => $row['idPeriodo'],
                'idTipoPeriodo' => $row['idTipoPeriodo'],
                'nomTipoPeriodo' => $row['nomTipoPeriodo'],
                'nomPeriodo' => $row['nomPeriodo'],
                'descripcion' => $row['descripcion'],
                'idRandom' => uniqid(),
            );

            $FN_cantPaginas = cantPaginas($row['temp_cantRegistros'], $cantidadPorPagina);
        }
        $jsonstring = json_encode([
            'datos' => $json,
            'paginador' => $FN_cantPaginas
        ]);
        echo $jsonstring;
    } else {
        $json[] = array(
            'idPeriodo' => 'empty / vacio',
            'idTipoPeriodo' => 'empty / vacio',
            'nomTipoPeriodo' => 'empty / vacio',
            'nomPeriodo' => 'empty / vacio',
            'descripcion' => 'empty / vacio',
        );

        $FN_cantPaginas = cantPaginas(1, $cantidadPorPagina);
        $jsonstring = json_encode([
            'datos' => $json,
            'paginador' => $FN_cantPaginas
        ]);
        echo $jsonstring;
    }
}
