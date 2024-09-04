<?php

include("../../model/conexion.php");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['ihh_editarAcop'])) {
    $data = json_decode(file_get_contents("php://input"));
    $idAcop = $data->idAcop;
    $numAcop = $data->numAcop;
    $nomAcop = $data->nomAcop;
    $fechaIni = $data->fechaIni;
    $fechaFin = $data->fechaFin;
    $valorUSD = $data->valorUSD;
    $fechaValorUSD = $data->fechaValorUSD;
    $presupuestoGeneral = $data->presupuestoGeneral;
    $presupuestoTotal = $data->presupuestoTotal;
    $isActive = $data->isActive;
    $usuarioModificacion = $data->usuarioModificacion;

    $query = "CALL SP_ihh_editarAcop(
    '$idAcop',
    '$numAcop',
    '$nomAcop',
    '$fechaIni', 
    '$fechaFin',
    '$valorUSD',
    '$fechaValorUSD',
    '$presupuestoGeneral',
    '$presupuestoTotal',
    '$isActive', 
    '$usuarioModificacion', @p0, @p1)";

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

            $json[] = array(
                'OUT_CODRESULT' => $row['OUT_CODRESULT'],
                'OUT_MJERESULT' => $row['OUT_MJERESULT'],
                'idAcop' => $row['idAcop'],
                'numAcop' => $row['numAcop'],
                'nomAcop' => $row['nomAcop'],
                'presupuestoTotal' => $row['presupuestoTotal'],
                'presupuestoHH' => $row['presupuestoHH'],
                'presupuestoMiscelaneo' => $row['presupuestoMiscelaneo'],
                'idacopmes' => $row['idacopmes'],
                'mes' => $row['mes'],
                'presupuestoMensual' => $row['presupuestoMensual'],
                'presupuestoMensualMiscelaneo' => $row['presupuestoMensualMiscelaneo'],
                'valorUSD' => $row['valorUSD'],
                'fechaValorUSD' => $row['fechaValorUSD'],
                'fechaIni' => $row['fechaIni'],
                'fechaFin' => $row['fechaFin'],
                'fechaIniFormat' => $row['fechaIniFormat'],
                'fechaFinFormat' => $row['fechaFinFormat'],
                'observaciones' => $row['observaciones'],
            );
        }
    }
    $jsonstring = json_encode($json);
    echo $jsonstring;
} else {
    echo json_encode("Error");
}
