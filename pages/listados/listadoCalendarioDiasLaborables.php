<?php

include("../../model/conexion.php");
include("../paginador/cantPaginas.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['listadoCalendarioDiasLaborables'])) {
    $data = json_decode(file_get_contents("php://input"));
    $mes = $data->mes;

    $query = "CALL SP_listadoCalendarioDiasLaborables('$mes')";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    $datosTabla = array();
    if (mysqli_num_rows($result) > 0) {

        while ($row = mysqli_fetch_array($result)) {
            $datosTabla[] = array(
                'totalDiasMes' => $row['totalDiasMes'],
                'totalDiasNoLaborables' => $row['totalDiasNoLaborables'],
                'totalDiasLaborables' => $row['totalDiasLaborables'],
                'totalHorasMes' => $row['totalHorasMes'],
                'totalHorasNoLaborables' => $row['totalHorasNoLaborables'],
                'totalHorasLaborables' => $row['totalHorasLaborables'],
            );
        }

        $jsonstring = json_encode(
            $datosTabla
        );
        echo $jsonstring;
    }
}
