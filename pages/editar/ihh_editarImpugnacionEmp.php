<?php

include("../../model/conexion.php");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['ihh_editarImpugnacionEmp'])) {
    $data = json_decode(file_get_contents("php://input"));
    $idImpugnacionEmp = $data->idImpugnacionEmp;
    $idEmpleado = $data->idEmpleado;
    $idElemento = $data->idElemento;
    $idPeriodo = $data->idPeriodo;
    $cantHorasPeriodo = $data->cantHorasPeriodo;
    $cantHorasExtra = $data->cantHorasExtra;
    $factor = $data->factor;
    $idAcop = $data->idAcop;
    $isActive = $data->isActive;
    $usuarioCreacion = $data->usuarioCreacion;

    $query = "CALL SP_ihh_editarImpugnacionEmp($idImpugnacionEmp, '$idEmpleado','$idElemento','$idPeriodo','$cantHorasPeriodo','$cantHorasExtra','$factor','$idAcop', '$isActive', '$usuarioCreacion', @p0, @p1)";
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
                'idPeriodo' => $row['idPeriodo'],
                'nomPeriodo' => $row['nomPeriodo'],
            );
        }
    }
    $jsonstring = json_encode($json);
    echo $jsonstring;
} else {
    echo json_encode("Error");
}
