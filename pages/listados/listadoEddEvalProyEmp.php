<?php

include("../../model/conexion.php");
include("../paginador/cantPaginas.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['listadoEddEvalProyEmp'])) {
    $data = json_decode(file_get_contents("php://input"));
    $data->num_boton = "" || null ? $num_boton = 1 : $num_boton = $data->num_boton;
    $data->idEDDEvaluacion = "" || null ? $idEDDEvaluacion = null : $idEDDEvaluacion = $data->idEDDEvaluacion;
    $data->idEDDProyEmp = "" || null ? $idEDDProyEmp = null : $idEDDProyEmp = $data->idEDDProyEmp;
    $data->cantidadPorPagina = "" || null ? $cantidadPorPagina = 10 : $cantidadPorPagina = $data->cantidadPorPagina;
    $inicio = ($num_boton - 1) * $cantidadPorPagina;


    $query = "CALL SP_listadoEddEvalProyEmp('$inicio', '$cantidadPorPagina', '$idEDDEvaluacion', '$idEDDProyEmp')";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    $json = array();
    if (mysqli_num_rows($result) > 0) {

        while ($row = mysqli_fetch_array($result)) {
            $json[] = array(
                'idEDDEvalProyEmp' => $row['idEDDEvalProyEmp'],
                'idEDDEvaluacion' => $row['idEDDEvaluacion'],
                'idEDDProyEmp' => $row['idEDDProyEmp'],
                'evalRespondida' => $row['evalRespondida'],
                'fechaIni' => $row['fechaIni'],
                'fechaFin' => $row['fechaFin'],
                'nomEvaluacion' => $row['nomEvaluacion'],
                'nomProyecto' => $row['nomProyecto'],
                'nomEmpleado' => $row['nomEmpleado'],

            );

            $FN_cantPaginas = cantPaginas($row['@temp_cantRegistros'], $cantidadPorPagina);
        }
        $jsonstring = json_encode([
            'datos' => $json,
            'paginador' => $FN_cantPaginas
        ]);
        echo $jsonstring;
    } else {
        $json[] = array(
            'idEDDEvalProyEmp' => 'empty / vacio',
            'idEDDEvaluacion' => 'empty / vacio',
            'idEDDProyEmp' => 'empty / vacio',
            'evalRespondida' => 'empty / vacio',
            'fechaIni' => 'empty / vacio',
            'fechaFin' => 'empty / vacio',
            'nomEvaluacion' => 'empty / vacio',
            'nomProyecto' => 'empty / vacio',
            'nomEmpleado' => 'empty / vacio',
        );

        $FN_cantPaginas = cantPaginas(1, $cantidadPorPagina);
        $jsonstring = json_encode([
            'datos' => $json,
            'paginador' => $FN_cantPaginas
        ]);
        echo $jsonstring;
    }
}
