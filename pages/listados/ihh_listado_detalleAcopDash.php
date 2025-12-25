<?php
include("../../model/conexion.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['ihh_listado_detalleAcopDash'])) {
    $data = json_decode(file_get_contents("php://input"));
    $idProyecto = $data->idProyecto;

    $query = "CALL SP_ihh_detalleAcopDash('$idProyecto')";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    $json = array();
    if (mysqli_num_rows($result) > 0) {
        while ($row = mysqli_fetch_array($result)) {

            $json[] = array(
                'idAcop' => $row['idAcop'],
                'nomAcop' => $row['nomAcop'],
                'fechaInicio' => $row['fechaIni'],
                'fechaFin' => $row['fechaFin'],
                'presupuestoTotal' => $row['presupuestoTotal'],
                'porcRentabilidad' => $row['porcRentabilidad'],
                'presupuestoGeneral' => $row['presupuestoGeneral'],
                'presupuestoMiscelaneo' => $row['presupuestoMiscelaneo'],
                'presupuestoHH' => $row['presupuestoHH'],

            );
        }

        $jsonstring = json_encode($json);
        echo $jsonstring;
    }
}
