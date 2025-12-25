<?php

include("../../model/conexion.php");
include("../paginador/cantPaginas.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['listadoCompetenciasGeneralEval'])) {
    $data = json_decode(file_get_contents("php://input"));
    $idCliente = $data->idCliente;
    $idServicio = $data->idServicio;
    $idProyecto = $data->idProyecto;
    $tipoComparacion = $data->tipoComparacion;
    $tipoCargo = $data->tipoCargo;
    $fechaIni = $data->fechaIni;
    $fechaFin = $data->fechaFin;
    $cicloEvaluacion = $data->cicloEvaluacion;

    $query = "CALL SP_COMPETENCIAS_GENERAL_EVAL('$idCliente', '$idServicio', '$idProyecto', '$tipoComparacion', '$tipoCargo', '$fechaIni', '$fechaFin', '$cicloEvaluacion', @p0, @p1)";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    $json = array();
    while ($row = mysqli_fetch_array($result)) {
        if ($row['out_codResp'] != '00') {
            $json[] = array(
                'idCliente' => 'vacío',
                'nomCliente' => 'vacío',
                'idServicio' => 'vacío',
                'nomServicio' => '0 / vacío',
                'idProyecto' => '0 / vacío',
                'nomProyecto' => '0 / vacío',
                'epeFechaIni' => '0 / vacío',
                'epeFechaFin' => '0 / vacío',
                'cantReferentes' => '0 / vacío',
                'cantColaboradores' => '0 / vacío',
                'porcAprobRef' => '0 / vacío',
                'porcAprobColab' => '0 / vacío',
                'cantRespRefOK' => '0 / vacío',
                'cantRespColabOK' => '0 / vacío',
                'cantPregComp' => '0 / vacío',
                'cantResp' => '0 / vacío',
                'nomCompetencia' => '0 / vacío',
                'cicloEvaluacion' => '0 / vacío',
                'codResp' => $row['out_codResp'],
                'msjResp' => $row['out_msjResp']
            );
        } else {
            $json[] = array(
                'idCliente' => $row['idCliente'],
                'nomCliente' => $row['nomCliente'],
                'idServicio' => $row['idServicio'],
                'nomServicio' => $row['nomServicio'],
                'idProyecto' => $row['idProyecto'],
                'nomProyecto' => $row['nomProyecto'],
                'tipoProyecto' => $row['tipoProyecto'],
                'epeFechaIni' => $row['epeFechaIni'],
                'epeFechaFin' => $row['epeFechaFin'],
                'cantReferentes' => $row['cantReferentes'],
                'cantColaboradores' => $row['cantColaboradores'],
                'cantRespOK' => $row['cantRespOK'],
                'cantPregComp' => $row['cantPregComp'],
                'cantResp' => $row['cantResp'],
                'nomCompetencia' => $row['nomCompetencia'],
                'cicloEvaluacion' => $row['cicloEvaluacion']
            );
        }
    }
    $jsonstring = json_encode(($json));
    echo $jsonstring;
    mysqli_close($conection);
}
