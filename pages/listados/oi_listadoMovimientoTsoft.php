<?php
include("../../model/conexion.php");
include("../paginador/cantPaginas.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['oi_listadoMovimientoTsoft'])) {
    $data = json_decode(file_get_contents("php://input"));

    $idEmpleado = $data->idEmpleado === '' ? null : $data->idEmpleado;
    $idMotivo = $data->idMotivo === '' ? null : $data->idMotivo;
    $fechaIni = $data->fechaIni === '' ? null : $data->fechaIni;
    $fechaFin = $data->fechaFin === '' ? null : $data->fechaFin;
    $data->num_boton = "" || null ? $num_boton = 1 : $num_boton = $data->num_boton;
    $data->cantidadPorPagina = "" || null ? $cantidadPorPagina = 10 : $cantidadPorPagina = $data->cantidadPorPagina;
    $inicio = ($num_boton - 1) * $cantidadPorPagina;

    $query = "CALL SP_oi_listadoMovimientoTsoft(
    " . ($idEmpleado === null ? "null" : "'$idEmpleado'") . ",
    " . ($idMotivo === null ? "null" : "'$idMotivo'") . ",
    " . ($fechaIni === null ? "null" : "'$fechaIni'") . ",
    " . ($fechaFin === null ? "null" : "'$fechaFin'") . ",
    '$inicio', 
    '$cantidadPorPagina')";



    // printf($query);

    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    $json = array();

    if (mysqli_num_rows($result) > 0) {
        while ($row = mysqli_fetch_array($result)) {
            $json[] = array(
                'idMovimientoColabTsoft' => $row['idMovimientoColabTsoft'],
                'idEmpleado' => $row['idEmpleado'],
                'idMotivo' => $row['idMotivo'],
                'fechaIni' => $row['fechaIni'],
                'fechaFin' => $row['fechaFin'],
                'nombreMotivo' => $row['nombreMotivo'],
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
            'idMovimientoColabTsoft' => 'empty / vacio',
            'idEmpleado' => 'empty / vacio',
            'idMotivo' => 'empty / vacio',
            'fechaIni' => 'empty / vacio',
            'fechaFin' => 'empty / vacio',
            'observaciones' => 'empty / vacio',
            'nombreMotivo' => 'empty / vacio',
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
