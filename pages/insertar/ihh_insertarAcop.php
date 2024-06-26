<?php

include("../../model/conexion.php");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['ihh_insertarAcop'])) {
    $data = json_decode(file_get_contents("php://input"));
    $idProyecto = $data->idProyecto;
    $presupuestoTotal = $data->presupuestoTotal;
    $cantTotalMeses = $data->cantTotalMeses;
    $isActive = $data->isActive;
    $usuarioCreacion = $data->usuarioCreacion;

    $query = "CALL SP_ihh_insertarAcop('$idProyecto','$presupuestoTotal','$cantTotalMeses', '$isActive', '$usuarioCreacion', @p0, @p1)";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }


    $json = array();
    while ($row = mysqli_fetch_array($result)) {
        if ($row['OUT_CODRESULT'] != '00') {
            $json[] = array(
                'OUT_CODRESULT' => $row['OUT_CODRESULT'],
                'OUT_MJERESULT' => $row['OUT_MJERESULT']
            );
        } else {
            $hoy = new DateTime();
            $hoyFormat = $hoy->format('d-m-Y');
            $fechaFin = new DateTime($row['fechaFinProy']);
            $fechaFinFormat = $fechaFin->format('d-m-Y');

            if ($hoy < $fechaFin && $row['fechaFinProy'] !== null) {
                $apiUrl = 'https://mindicador.cl/api/uf/' . $hoyFormat;
                $jsonUF = json_decode(file_get_contents($apiUrl));
            } else {
                $apiUrl = 'https://mindicador.cl/api/uf/' . $fechaFinFormat;
                $jsonUF = json_decode(file_get_contents($apiUrl));
            }
            $json[] = array(
                'OUT_CODRESULT' => $row['OUT_CODRESULT'],
                'OUT_MJERESULT' => $row['OUT_MJERESULT'],
                'idProyecto' => $row['idProyecto'],
                'idAcop' => $row['idAcop'],
                'nomProyecto' => $row['nomProyecto'],
                'fechaIniProy' => $row['fechaIniProy'],
                'fechaFinProy' => $row['fechaFinProy'],
                'presupuestoTotal' => $row['presupuestoTotal'],
                'presupuestoMen' => $row['presupuestoMen'],
                'cantTotalMeses' => $row['cantTotalMeses'],
                'valorUF' => $jsonUF->serie[0]->valor
            );
        }
    }
    $jsonstring = json_encode($json);
    echo $jsonstring;
} else {
    echo json_encode("Error");
}
