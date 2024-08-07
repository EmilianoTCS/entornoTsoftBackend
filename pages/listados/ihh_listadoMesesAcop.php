<?php
include("../../model/conexion.php");
include("../paginador/cantPaginas.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['ihh_listadoMesesAcop'])) {
    $data = json_decode(file_get_contents("php://input"));
    $data->idAcop = "" || null ? $idAcop = 0 : $idAcop = $data->idAcop;

    $query = "CALL SP_ihh_listadoMesesAcop('$idAcop')";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    $json = array();

    if (mysqli_num_rows($result) > 0) {
        while ($row = mysqli_fetch_array($result)) {
            $json[] = array(
                'idAcop' => $row['idAcop'],
                'idAcopMes' => $row['idAcopMes'],
                'mes' => $row['mes'],
                'presupuestoMensualUSD' => $row['presupuestoMensualUSD'],
                'presupuestoMensualPesos' => $row['presupuestoMensualPesos'],
                'valorUSD' => $row['valorUSD'],
                'nomAcop' => $row['nomAcop'],
                'presupuestoTotalUSD' => $row['presupuestoTotalUSD'],
                'presupuestoTotalPesos' => $row['presupuestoTotalPesos'],
                'fechaIni' => $row['fechaIni'],
                'fechaFin' => $row['fechaFin'],
            );
        }

        $jsonstring = json_encode($json);
        echo $jsonstring;
    } else {
        $json[] = array(
            'idAcop' => 'empty / vacio',
            'idAcopMes' => 'empty / vacio',
            'mes' => 'empty / vacio',
            'presupuestoMensualUSD' => 'empty / vacio',
            'presupuestoMensualPesos' => 'empty / vacio',
            'valorUSD' => 'empty / vacio',
            'nomAcop' => 'empty / vacio',
            'presupuestoTotalUSD' => 'empty / vacio',
            'presupuestoTotalPesos' => 'empty / vacio',
            'fechaIni' => 'empty / vacio',
            'fechaFin' => 'empty / vacio',

        );
        $jsonstring = json_encode($json);
        echo $jsonstring;
    }
}
