<?php

include("../../model/conexion.php");
include("../paginador/cantPaginas.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['ihh_listadoImpEmp'])) {
    $data = json_decode(file_get_contents("php://input"));
    $data->idEmpleado = "" || null ? $idEmpleado = null : $idEmpleado = $data->idEmpleado;
    $data->mes = "" || null ? $mes = null : $mes = $data->mes;

    $query = "CALL SP_ihh_listadoImpEmp('$idEmpleado', '$mes')";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    $datosResumen = array();
    $datosTabla = array();
    if (mysqli_num_rows($result) > 0) {

        while ($row = mysqli_fetch_array($result)) {
            $datosTabla[] = array(
                'idImpugnacionEmp' => $row['idImpugnacionEmp'],
                'idEmpleado' => $row['idEmpleado'],
                'nomEmpleado' => $row['nomEmpleado'],
                'cantHorasPeriodo' => $row['cantHorasPeriodo'],
                'cantHorasExtra' => $row['cantHorasExtra'],
                'idresumenperproy' => $row['idresumenperproy'],
                'idProyecto' => $row['idProyecto'],
                'nomProyecto' => $row['nomProyecto'],
                'valorHH' => $row['valorHH'],
                'idElemento' => $row['idElemento'],
                'nomElemento' => $row['nomElemento'],
                'idAcop' => $row['idAcop'],
                'idPeriodo' => 1,
                'idRandom' => uniqid(),
            );
        }

        $jsonstring = json_encode(
            $datosTabla
        );
        echo $jsonstring;
    } else {
        $datosTabla[] = array(
            'idImpugnacionEmp' => null,
            'idEmpleado' => null,
            'nomEmpleado' => null,
            'cantHorasPeriodo' => null,
            'cantHorasExtra' => null,
            'idProyecto' => null,
            'nomProyecto' => null,
            'valorHH' => null,
            'idElemento' => null,
            'nomElemento' => null,
            'idAcop' => null,
            'idPeriodo' => null,
            'idRandom' => uniqid(),
        );
        $jsonstring = json_encode(
            $datosTabla
        );
        echo $jsonstring;
    }
}
