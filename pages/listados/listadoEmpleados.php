<?php

include("../../model/conexion.php");
include("../paginador/cantPaginas.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['listadoEmpleados'])) {

    $data = json_decode(file_get_contents("php://input"));
    $data->num_boton = "" || null ? $num_boton = 1 : $num_boton = $data->num_boton;
    $data->idPais = "" || null ? $idPais = null : $idPais = $data->idPais;
    $data->idArea = "" || null ? $idArea = null : $idArea = $data->idArea;
    $data->idCargo = "" || null ? $idCargo = null : $idCargo = $data->idCargo;
    $data->idEmpleado = "" || null ? $idEmpleado = null : $idEmpleado = $data->idEmpleado;
    $data->cantidadPorPagina = "" || null ? $cantidadPorPagina = 10 : $cantidadPorPagina = $data->cantidadPorPagina;


    $inicio = ($num_boton - 1) * $cantidadPorPagina;


    $query = "CALL SP_listadoEmpleados($inicio, $cantidadPorPagina, '$idPais', '$idArea', '$idCargo', '$idEmpleado')";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    $json = array();
    if (mysqli_num_rows($result) > 0) {

        while ($row = mysqli_fetch_array($result)) {
            $json[] = array(
                'idEmpleado' => $row['idEmpleado'],
                'nomEmpleado' => $row['UPPER(emp.nomEmpleado)'],
                'correoEmpleado' => $row['UPPER(emp.correoEmpleado)'],
                'telefonoEmpleado' => $row['telefonoEmpleado'],
                'nomArea' => $row['UPPER(ar.nomArea)'],
                'nomPais' => $row['UPPER(pa.nomPais)'],
                'nomCargo' => $row['UPPER(ca.nomCargo)'],
                'nomCliente' => $row['nomCliente'],

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
            'idEmpleado' => 'empty / vacio',
            'nomEmpleado' => 'empty / vacio',
            'correoEmpleado' => 'empty / vacio',
            'telefonoEmpleado' => 'empty / vacio',
            'nomArea' => 'empty / vacio',
            'nomPais' => 'empty / vacio',
            'nomCargo' => 'empty / vacio',
            'nomCliente' => 'empty / vacio',
        );

        $FN_cantPaginas = cantPaginas(1, $cantidadPorPagina);
        $jsonstring = json_encode([
            'datos' => $json,
            'paginador' => $FN_cantPaginas
        ]);
        echo $jsonstring;
    }
}
