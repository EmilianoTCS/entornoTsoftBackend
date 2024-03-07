<?php

include("../../model/conexion.php");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['listadoEvaluadoresEvaluados'])) {
    $queryEvaluados = "CALL SP_AUX_listadoEPEEvaluados()";
    $resultEvaluados = mysqli_query($conection, $queryEvaluados);
    if (!$resultEvaluados) {
        die('Query Failed' . mysqli_error($conection));
    } else {
        $evaluados = array();
        while ($row = mysqli_fetch_array($resultEvaluados)) {
            $evaluados[] = array(
                'idEDDProyEmpEvaluado' => $row['idEDDProyEmpEvaluado'],
                'idEDDEvaluacion' => $row['idEDDEvaluacion'],
                'nomEmpleado' => $row['nomEmpleado'],
                'idEmpleadoEvaluado' => $row['idEmpleadoEvaluado'],
            );
        }
    }
    mysqli_next_result($conection);

    $queryEvaluadores = "CALL SP_AUX_listadoEPEEvaluadores()";
    $resultEvaluadores = mysqli_query($conection, $queryEvaluadores);
    if (!$resultEvaluadores) {
        die('Query Failed' . mysqli_error($conection));
    } else {
        $evaluadores = array();
        while ($row = mysqli_fetch_array($resultEvaluadores)) {
            $evaluadores[] = array(
                'idEDDProyEmpEvaluador' => $row['idEDDProyEmpEvaluador'],
                'idEDDEvaluacion' => $row['idEDDEvaluacion'],
                'nomEmpleado' => $row['nomEmpleado'],
                'idEmpleadoEvaluador' => $row['idEmpleadoEvaluador'],

            );
        }
    }


    $jsonstring = json_encode([
        'evaluadores' => $evaluadores,
        'evaluados' => $evaluados
    ]);
    
    echo $jsonstring;
    mysqli_close($conection);
} else {
    echo json_encode("Error");
}
