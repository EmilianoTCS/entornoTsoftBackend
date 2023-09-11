<?php

include("../../model/conexion.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['emailEDD.php'])) {

    $data = json_decode(file_get_contents("php://input"));
    $idProyecto = $data->idProyecto;
    $cargoEnProy = $data->cargoEnProy;
    $tipoConfDato = $data->tipoConfDato;
    $subTipoConfDato = $data->subTipoConfDato;

    $queryEmpleados = "CALL SP_AUX_listadoEmpCargoProy('$idProyecto', '$cargoEnProy', @p0, @p1)";
    $resultEmpleados = mysqli_query($conection, $queryEmpleados);
    if (!$resultEmpleados) {
        die('Query Failed' . mysqli_error($conection));
    }
    if (mysqli_num_rows($resultEmpleados) > 0) {
        while ($rowEmpleados = mysqli_fetch_array($resultEmpleados)) {
            $datosEmpleado[] = array(
                'idEDDProyEmp' => $rowEmpleados['idEDDProyEmp'],
                'idEDDProyecto' => $rowEmpleados['idEDDProyecto'],
                'nomProyecto' => $rowEmpleados['nomProyecto'],
                'idServicio' => $rowEmpleados['idServicio'],
                'nomServicio' => $rowEmpleados['nomServicio'],
                'idCliente' => $rowEmpleados['idCliente'],
                'nomCliente' => $rowEmpleados['nomCliente'],
                'idEmpleado' => $rowEmpleados['idEmpleado'],
                'nomEmpleado' => $rowEmpleados['nomEmpleado'],
                'correoEmpleado' => $rowEmpleados['correoEmpleado'],
                'idEDDEvaluacion' => $rowEmpleados['idEDDEvaluacion'],
                'nomEvaluacion' => $rowEmpleados['nomEvaluacion'],
                'fechaIni' => $rowEmpleados['fechaIni'],
                'fechaFin' => $rowEmpleados['fechaFin'],
                'idEDDEvalProyEmp' => $rowEmpleados['idEDDEvalProyEmp'],
            );
        }
    }
    mysqli_next_result($conection);


    $queryConfig = "CALL SP_listadoConfigDatos('$tipoConfDato','', @p0, @p1)";
    $resultConfig = mysqli_query($conection, $queryConfig);
    if (!$resultConfig) {
        die('Query Failed' . mysqli_error($conection));
    }
    if (mysqli_num_rows($resultConfig) > 0) {
        while ($rowConfigs = mysqli_fetch_array($resultConfig)) {
            $datosConfig[] = array(
                'idConfDatos' => $rowConfigs['idConfDatos'],
                'tipoConfDato' => $rowConfigs['tipoConfDato'],
                'subTipoConfDato' => $rowConfigs['subTipoConfDato'],
                'orden' => $rowConfigs['orden'],
                'datoVisible' => $rowConfigs['datoVisible'],
                'datoNoVisible' => $rowConfigs['datoNoVisible']
            );
        }
    }
}
