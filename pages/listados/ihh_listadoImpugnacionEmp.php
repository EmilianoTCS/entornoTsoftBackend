<?php

include("../../model/conexion.php");
include("../paginador/cantPaginas.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['ihh_listadoImpugnacionEmp'])) {
    $data = json_decode(file_get_contents("php://input"));
    $data->num_boton = "" || null ? $num_boton = 1 : $num_boton = $data->num_boton;
    $data->idEmpleado = "" || null ? $idEmpleado = null : $idEmpleado = $data->idEmpleado;
    $data->idElemento = "" || null ? $idElemento = null : $idElemento = $data->idElemento;
    $data->idPeriodo = "" || null ? $idPeriodo = null : $idPeriodo = $data->idPeriodo;
    $data->idAcop = "" || null ? $idAcop = null : $idAcop = $data->idAcop;
    $data->cantidadPorPagina = "" || null ? $cantidadPorPagina = 10 : $cantidadPorPagina = $data->cantidadPorPagina;
    $inicio = ($num_boton - 1) * $cantidadPorPagina;

    $query = "CALL SP_ihh_listadoImpugnacionEmp('$idEmpleado', '$idElemento', '$idPeriodo', '$idAcop', '$inicio', '$cantidadPorPagina')";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    $json = array();
    if (mysqli_num_rows($result) > 0) {

        while ($row = mysqli_fetch_array($result)) {
            $json[] = array(
                'idImpugnacionEmp' => $row['idImpugnacionEmp'],
                'idEmpleado' => $row['idEmpleado'],
                'nomEmpleado' => $row['nomEmpleado'],
                'idElemento' => $row['idElemento'],
                'nomElemento' => $row['nomElemento'],
                'cantHorasPeriodo' => $row['cantHorasPeriodo'],
                'cantHorasExtra' => $row['cantHorasExtra'],
                'factor' => $row['factor'],
                'idAcop' => $row['idAcop'],
                'nomProyecto' => $row['nomProyecto'],
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
            'idImpugnacionEmp' => 'empty / vacio',
            'idEmpleado' => 'empty / vacio',
            'nomEmpleado' => 'empty / vacio',
            'idElemento' => 'empty / vacio',
            'nomElemento' => 'empty / vacio',
            'cantHorasPeriodo' => 'empty / vacio',
            'cantHorasExtra' => 'empty / vacio',
            'factor' => 'empty / vacio',
            'idAcop' => 'empty / vacio',
            'nomProyecto' => 'empty / vacio',
        );

        $FN_cantPaginas = cantPaginas(1, $cantidadPorPagina);
        $jsonstring = json_encode([
            'datos' => $json,
            'paginador' => $FN_cantPaginas
        ]);
        echo $jsonstring;
    }
}
