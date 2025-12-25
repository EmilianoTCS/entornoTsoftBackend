<?php

include("../../model/conexion.php");
include("../paginador/cantPaginas.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['listadoRelatorRamo'])) {

    $data = json_decode(file_get_contents("php://input"));
    $data->num_boton = "" || null ? $num_boton = 1 : $num_boton = $data->num_boton;
    $data->idEmpleado = "" || null ? $idEmpleado = null : $idEmpleado = $data->idEmpleado;
    $data->idRamo = "" || null ? $idRamo = null : $idRamo = $data->idRamo;
    $isActive = (!isset($data->isActive) || $data->isActive === '' || $data->isActive === null) ? null : $data->isActive;

    $data->cantidadPorPagina = "" || null ? $cantidadPorPagina = 10 : $cantidadPorPagina = $data->cantidadPorPagina;
    $inicio = ($num_boton - 1) * $cantidadPorPagina;

    // echo json_encode($isActive);    
    $query = "CALL SP_listadoRelatorRamo(
        '" . $inicio . "', 
        '" . $cantidadPorPagina . "', 
        " . ($idEmpleado === '' || $idEmpleado === null ? "NULL" : "'" . $idEmpleado . "'") . ", 
        " . ($idRamo === '' || $idRamo === null ? "NULL" : "'" . $idRamo . "'") . ", 
        " . ($isActive === '' || $isActive === null ? "NULL" : "'" . $isActive . "'") . 
    ")";

    // echo json_encode($query);
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    $json = array();
    if (mysqli_num_rows($result) > 0) {

        while ($row = mysqli_fetch_array($result)) {
            $json[] = array(
                'idRelatorRamo' => $row['idRelatorRamo'],
                'fechaIni' => $row['fechaIni'],
                'fechaFin' => $row['fechaFin'],
                'nomEmpleado' => $row['nomEmpleado'],
                'nomRamo' => $row['nomRamo'],
                'isActive' => $row['isActive'],
            );
            $FN_cantPaginas = cantPaginas($row['@temp_cantRegistros'], $cantidadPorPagina);
        }
        $jsonstring = json_encode([
            'datos' => $json,
            'paginador' => $FN_cantPaginas
        ]);
        echo $jsonstring;
    } else {
        $json[] = array(
            'idRelatorRamo' => 'empty / vacio',
            'fechaIni' => 'empty / vacio',
            'fechaFin' => 'empty / vacio',
            'nomEmpleado' => 'empty / vacio',
            'nomRamo' => 'empty / vacio',

        );

        $FN_cantPaginas = cantPaginas(1, $cantidadPorPagina);
        $jsonstring = json_encode([
            'datos' => $json,
            'paginador' => $FN_cantPaginas
        ]);
        echo $jsonstring;
    }
}
