<?php
include("../../model/conexion.php");
include("../paginador/cantPaginas.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['oi_listadoSeniority'])) {
    $data = json_decode(file_get_contents("php://input"));
    $idEmpleado = $data->idEmpleado;
    $idMotivo = $data->idMotivo;
    $fechaIni = $data->fechaIni;
    $fechaFin = $data->fechaFin;
    $data->num_boton = "" || null ? $num_boton = 1 : $num_boton = $data->num_boton;
    $data->cantidadPorPagina = "" || null ? $cantidadPorPagina = 10 : $cantidadPorPagina = $data->cantidadPorPagina;
    $inicio = ($num_boton - 1) * $cantidadPorPagina;

    $query = "CALL SP_oi_listadoSeniority(
    " . ($idEmpleado === "" ? "null" : "'$idEmpleado'") . ",
    " . ($idMotivo === "" ? "null" : "'$idMotivo'") . ",
    " . ($fechaIni === "" ? "null" : "'$fechaIni'") . ",
    " . ($fechaFin === "" ? "null" : "'$fechaFin'") . ",
    '$inicio', 
    '$cantidadPorPagina')";

    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    $json = array();

    if (mysqli_num_rows($result) > 0) {
        while ($row = mysqli_fetch_array($result)) {

            $json[] = array(
                'idSeniority' => $row['idSeniority'],
                'idEmpleado' => $row['idEmpleado'],
                'idMotivo' => $row['idMotivo'],
                'fechaIni' => $row['fechaIni'],
                'fechaFin' => $row['fechaFin'],
                'observaciones' => $row['observaciones'],
                'nombreMotivo' => $row['nombreMotivo'],
                'tipo' => $row['tipo'],
                'nomEmpleado' => $row['nomEmpleado'],
                'isActive' => $row['isActive'],
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
            'idSeniority' => 'empty / vacio',
            'idEmpleado' => 'empty / vacio',
            'idMotivo' => 'empty / vacio',
            'fechaIni' => 'empty / vacio',
            'fechaFin' => 'empty / vacio',
            'observaciones' => 'empty / vacio',
            'nombreMotivo' => 'empty / vacio',
            'tipo' => 'empty / vacio',
            'nomEmpleado' => 'empty / vacio',
            'isActive' => 'empty / vacio',
        );
        $FN_cantPaginas = cantPaginas(1, $cantidadPorPagina);
        $jsonstring = json_encode([
            'datos' => $json,
            'paginador' => $FN_cantPaginas
        ]);
        echo $jsonstring;
    }
}
