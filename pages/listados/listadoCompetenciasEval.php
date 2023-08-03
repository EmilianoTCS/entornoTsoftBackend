<?php

include("../../model/conexion.php");
include("../paginador/cantPaginas.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['listadoCompetenciasEval'])) {
    $data = json_decode(file_get_contents("php://input"));
    $idEvaluacion = $data->idEvaluacion;

    $query = "CALL SP_COMPETENCIAS_EVAL($idEvaluacion, @p0, @p1)";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    $json = array();
    while ($row = mysqli_fetch_array($result)) {
        if ($row['out_codResp'] != '00') {
            $json[] = array(
                'nomEmpleado' => '0 / vacío',
                'nomCompetencia' => '0 / vacío',
                'cantPregComp' => '0 / vacío',
                'cantRespOK' => '0 / vacío',
                'porcAprobComp' => '0 / vacío',
                'codResp' => $row['out_codResp'],
                'msjResp' => $row['out_msjResp']
            );
        } else {
            $json[] = array(
                'nomEmpleado' => $row['nomEmpleado'],
                'nomCompetencia' => $row['nomCompetencia'],
                'cantPregComp' => $row['cantPregComp'],
                'cantRespOK' => $row['cantRespOK'],
                'porcAprobComp' => $row['porcAprobComp']
            );
        }
    }
    $jsonstring = json_encode(($json));
    echo $jsonstring;
    mysqli_close($conection);
}
