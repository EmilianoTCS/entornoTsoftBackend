<?php

include("../../model/conexion.php");
include("../paginador/cantPaginas.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['listadoComentariosEval'])) {
    $data = json_decode(file_get_contents("php://input"));
    $idEvaluacion = $data->idEvaluacion;

    $query = "CALL SP_COMENTARIOS_EVAL($idEvaluacion, @p0, @p1)";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    $json = array();
    while ($row = mysqli_fetch_array($result)) {
        if ($row['out_codResp'] != '00') {
            $json[] = array(
                'idEDDProyEmpEvaluado' => '0 / vacío',
                'idEvaluador' => '0 / vacío',
                'nomEvaluador' => '0 / vacío',
                'idEvaluado' => '0 / vacío',
                'nomEvaluado' => '0 / vacío',
                'ordenDashboard' => '0 / vacío',
                'respuesta' => '0 / vacío',
                'codResp' => $row['out_codResp'],
                'msjResp' => $row['out_msjResp']
            );
        } else {
            $json[] = array(
                'idEDDProyEmpEvaluado' => $row['idEDDProyEmpEvaluado'],
                'idEvaluador' => $row['idEvaluador'],
                'nomEvaluador' => $row['nomEvaluador'],
                'idEvaluado' => $row['idEvaluado'],
                'nomEvaluado' => $row['nomEvaluado'],
                'ordenDashboard' => $row['ordenDashboard'],
                'respuesta' => $row['respuesta'],
                'codResp' => $row['out_codResp'],
                'msjResp' => $row['out_msjResp']
            );
        }
    }
    $jsonstring = json_encode(($json));
    echo $jsonstring;
    mysqli_close($conection);
}
