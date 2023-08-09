<?php

include("../../model/conexion.php");
include("../paginador/cantPaginas.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['listadoResumenEval'])) {
    $data = json_decode(file_get_contents("php://input"));
    $idEvaluacion = $data->idEvaluacion;

    $query = "CALL SP_RESUMEN_EVAL(1, @p0, @p1, @p2, @p3, @p4, @p5, @p6)";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    $json = array();
    while ($row = mysqli_fetch_array($result)) {
        if ($row['out_codResp'] != '00') {
            $json[] = array(
                'porcSatisfaccion' => '0 / vacío',
                'referentesEvaluados' => '0 / vacío',
                'competenciasEvaluadas' => '0 / vacío',
                'cantEvaluadoresTsoft' => '0 / vacío',
                'tiempoPromedio' => '0 / vacío',
                'codResp' => $row['out_codResp'],
                'msjResp' => $row['out_msjResp']
            );
        } else {
            $json[] = array(
                'porcSatisfaccion' => $row['out_porcSatisfaccion'],
                'referentesEvaluados' => $row['out_referentesEvaluados'],
                'competenciasEvaluadas' => $row['out_competenciasEvaluadas'],
                'cantEvaluadoresTsoft' => $row['out_cantEvaluadoresTsoft'],
                'tiempoPromedio' => $row['out_tiempoPromedio']
            );
        }
    }
    $jsonstring = json_encode(($json));
    echo $jsonstring;
    mysqli_close($conection);
}
