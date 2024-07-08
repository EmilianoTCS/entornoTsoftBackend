<?php

include("../../model/conexion.php");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['insertarEddProyecto'])) {
    $data = json_decode(file_get_contents("php://input"));
    $nomProyecto = $data->nomProyecto;
    $fechaIni = $data->fechaIni;
    $fechaFin = $data->fechaFin;
    $isActive = $data->isActive;
    $presupuestoTotal = $data->presupuestoTotal;
    $valorUSD = $data->valorUSD;
    $idServicio = $data->idServicio;
    $usuarioCreacion = $data->usuarioCreacion;
    $tipoProyecto = $data->tipoProyecto;


    $query = "CALL SP_insertarEddProyecto('$nomProyecto','$fechaIni','$fechaFin','$tipoProyecto','$presupuestoTotal', $isActive, $idServicio,'$valorUSD', '$usuarioCreacion', @p0, @p1)";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }


    $json = array();
    while ($row = mysqli_fetch_array($result)) {
        if ($row['OUT_CODRESULT'] != '00') {
            $json[] = array(
                'OUT_CODRESULT' => $row['OUT_CODRESULT'],
                'OUT_MJERESULT' => $row['OUT_MJERESULT'],
            );
        } else {
            $json[] = array(
                'OUT_CODRESULT' => $row['OUT_CODRESULT'],
                'OUT_MJERESULT' => $row['OUT_MJERESULT'],
                'idEDDProyecto' => $row['idEDDProyecto'],
                'nomProyecto' => $row['nomProyecto'],
                'fechaIni' => $row['fechaIni'],
                'fechaFin' => $row['fechaFin'],
                'nomServicio' => $row['nomServicio'],
                'idresumenperproy' => $row['idresumenperproy'],
                'mes' => $row['mes'],
                'presupuestoMensualUSD' => $row['presupuestoMensualUSD'],
                'presupuestoMensualpesos' => $row['presupuestoMensualpesos'],
                'presupuestoTotal' => $row['presupuestoTotal'],
            );
        }
    }
    $jsonstring = json_encode($json);
    echo $jsonstring;
} else {
    echo json_encode("Error");
}
