<?php

include("../../model/conexion.php");
include("../paginador/cantPaginas.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['listadoEddResumenEval'])) {
    $data = json_decode(file_get_contents("php://input"));
    $idCliente = $data->idCliente;
    $idServicio = $data->idServicio;
    $idProyecto = $data->idProyecto;
    $cicloEvaluacion = $data->cicloEvaluacion;
    $fechaIni = $data->fechaIni;
    $fechaFin = $data->fechaFin;
    $tipoCargo = $data->tipoCargo;

    $query = "CALL SP_listadoEddResumenEval('$idCliente', '$idServicio', '$idProyecto', '$cicloEvaluacion', '$fechaIni','$fechaFin', '$tipoCargo', @p0, @p1)";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    $json = array();
    while ($row = mysqli_fetch_array($result)) {
        if ($row['OUT_CODRESULT'] != '00') {
            $json[] = array(
                'idCliente' => 'vacío',
                'nomCliente' => 'vacío',
                'idServicio' => 'vacío',
                'nomServicio' => '0 / vacío',
                'idProyecto' => '0 / vacío',
                'nomProyecto' => '0 / vacío',
                'idEDDProyEmp' => '0 / vacío',
                'idEDDEvalProyEmp' => '0 / vacío',
                'cantReferentes' => '0 / vacío',
                'cantColaboradores' => '0 / vacío',
                'cantEvalRespondidas' => '0 / vacío',
                'cantEvalRespondidasRef' => '0 / vacío',
                'cantEvalRespondidasColab' => '0 / vacío',
                'fechaIniVigenciaEvalRef' => '0 / vacío',
                'fechaIniVigenciaEvalColab' => '0 / vacío',
                'cicloEvaluacion' => '0 / vacío',
                'OUT_CODRESULT' => $row['OUT_CODRESULT'],
                'OUT_MJERESULT' => $row['OUT_MJERESULT']
            );
        } else {
            $json[] = array(
                'idCliente' => $row['idCliente'],
                'nomCliente' => $row['nomCliente'],
                'idServicio' => $row['idServicio'],
                'nomServicio' => $row['nomServicio'],
                'idEDDProyecto' => $row['idEDDProyecto'],
                'nomProyecto' => $row['nomProyecto'],
                'idEDDProyEmp' => $row['idEDDProyEmp'],
                'idEDDEvalProyEmp' => $row['idEDDEvalProyEmp'],
                'proyFechaIni' => $row['proyFechaIni'],
                'proyFechaFin' => $row['proyFechaFin'],
                'estadoProyecto' => $row['estadoProyecto'],
                'cantEmpleados' => $row['cantEmpleados'],
                'cantEvalRespondidas' => $row['cantEvalRespondidas'],
                'cicloEvaluacion' => $row['cicloEvaluacion'],
                'fechaIniVigenciaEvalColab' => $row['fechaIniVigenciaEvalColab'],
                'fechaIniVigenciaEvalRef' => $row['fechaIniVigenciaEvalRef'],
                'OUT_CODRESULT' => $row['OUT_CODRESULT'],
                'OUT_MJERESULT' => $row['OUT_MJERESULT']
            );
        }
    }
    $jsonstring = json_encode(($json));
    echo $jsonstring;
    mysqli_close($conection);
}
