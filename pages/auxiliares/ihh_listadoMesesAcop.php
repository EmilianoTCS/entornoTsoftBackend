<?php

include("../../model/conexion.php");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['listados'])) {
    $data = json_decode(file_get_contents("php://input"));
    $idAcop = $data->idAcop;
    $query = "CALL SP_ihh_aux_listadoMesesAcops('$idAcop', @p0, @p1)";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }
    $json = array();


    while ($row = mysqli_fetch_array($result)) {
        $json[] = array(
            'OUT_CODRESULT' => $row['OUT_CODRESULT'],
            'OUT_MJERESULT' => $row['OUT_MJERESULT'],
            'idAcop' => $row['idAcop'],
            'numAcop' => $row['numAcop'],
            'nomAcop' => $row['nomAcop'],
            'presupuestoTotal' => $row['presupuestoTotal'],
            'presupuestoMiscelaneo' => $row['presupuestoMiscelaneo'],
            'idacopmes' => $row['idacopmes'],
            'mes' => $row['mes'],
            'presupuestoMensual' => $row['presupuestoMensual'],
            'presupuestoMensualMiscelaneo' => $row['presupuestoMensualMiscelaneo'],
            'presupuestoHH' => $row['presupuestoHH'],
            'valorUSD' => $row['valorUSD'],
            'fechaValorUSD' => $row['fechaValorUSD'],
            'fechaIni' => $row['fechaIni'],
            'fechaFin' => $row['fechaFin'],
            'fechaIniFormat' => $row['fechaIniFormat'],
            'fechaFinFormat' => $row['fechaFinFormat'],
            'observaciones' => $row['observaciones'],
        );
    }
    $jsonstring = json_encode(($json));
    echo $jsonstring;
    mysqli_close($conection);
} else {
    echo json_encode("Error");
}
