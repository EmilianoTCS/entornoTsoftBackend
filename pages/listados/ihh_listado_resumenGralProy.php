<?php
include("../../model/conexion.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['ihh_listadoResumenGralProy'])) {
    $data = json_decode(file_get_contents("php://input"));
    $fechaInicio = $data->fechaInicio === "" ? null : $data->fechaInicio;
    $fechaFin = $data->fechaFin === "" ? null : $data->fechaFin;
    $tipoImpugnacion = $data->tipoImpugnacion;
    $estadoProyecto = $data->estadoProyecto;

    $query = "CALL SP_ihh_resumenGralProy('$fechaInicio', '$fechaFin', '$tipoImpugnacion', '$estadoProyecto', @p0, @p1)";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    $json = array();

    if (mysqli_num_rows($result) > 0) {
        while ($row = mysqli_fetch_array($result)) {

            $json[] = array(
                'idEDDProyecto' => $row['idEDDProyecto'],
                'nomProyecto' => $row['nomProyecto'],
                'fechaInicio' => $row['fechaInicio'],
                'fechaFin' => $row['fechaFin'],
                'pptoOperativo' => $row['pptoOperativo'],
                'costoTotal' => $row['costoTotal'],
                'saldoPresupuesto' => $row['saldoPresupuesto'],
                'cantColaboradores' => $row['cantColaboradores'],
                'cantMonetizados' => $row['cantMonetizados'],
                'cantNoMonetizados' => $row['cantNoMonetizados'],

            );
        }

        $jsonstring = json_encode($json);
        echo $jsonstring;
    }else{
        $jsonstring = json_encode([]);
        echo $jsonstring;
    }
}
