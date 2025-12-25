<?php

include("../../model/conexion.php");
include("../paginador/cantPaginas.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['listadoEddEvalProyResp'])) {
    $data = json_decode(file_get_contents("php://input"));
    $data->num_boton = "" || null ? $num_boton = 1 : $num_boton = $data->num_boton;
    $data->idEDDEvaluacion = "" || null ? $idEDDEvaluacion = null : $idEDDEvaluacion = $data->idEDDEvaluacion;
    $data->idEDDProyEmp = "" || null ? $idEDDProyEmp = null : $idEDDProyEmp = $data->idEDDProyEmp;
    $data->idEDDEvalProyEmp = "" || null ? $idEDDEvalProyEmp = null : $idEDDEvalProyEmp = $data->idEDDEvalProyEmp;
    $data->idEDDEvalPregunta = "" || null ? $idEDDEvalPregunta = null : $idEDDEvalPregunta = $data->idEDDEvalPregunta;
    $data->idEDDEvalRespPreg = "" || null ? $idEDDEvalRespPreg = null : $idEDDEvalRespPreg = $data->idEDDEvalRespPreg;
    $data->cantidadPorPagina = "" || null ? $cantidadPorPagina = 10 : $cantidadPorPagina = $data->cantidadPorPagina;
    $inicio = ($num_boton - 1) * $cantidadPorPagina;

    $query = "CALL SP_listadoEddEvalProyResp('$inicio', '$cantidadPorPagina', '$idEDDEvaluacion', '$idEDDProyEmp','$idEDDEvalProyEmp','$idEDDEvalPregunta','$idEDDEvalRespPreg')";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    $json = array();
    if (mysqli_num_rows($result) > 0) {

        while ($row = mysqli_fetch_array($result)) {
            $json[] = array(
                'idEDDEvalProyResp' => $row['idEDDEvalProyResp'],
                'idEDDEvaluacion' => $row['idEDDEvaluacion'],
                'idEDDProyEmp' => $row['idEDDProyEmp'],
                'respuesta' => $row['respuesta'],
                'idEDDEvalProyEmp' => $row['idEDDEvalProyEmp'],
                'idEDDEvalPregunta' => $row['idEDDEvalPregunta'],
                'idEDDEvalRespPreg' => $row['idEDDEvalRespPreg'],
                'nomEvaluacion' => $row['nomEvaluacion'],
                'nomPregunta' => $row['nomPregunta'],
                'nomRespPreg' => $row['nomRespPreg'],
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
            'idEDDEvalProyResp' => 'empty / vacio',
            'idEDDEvaluacion' => 'empty / vacio',
            'idEDDProyEmp' => 'empty / vacio',
            'respuesta' => 'empty / vacio',
            'idEDDEvalProyEmp' => 'empty / vacio',
            'idEDDEvalPregunta' => 'empty / vacio',
            'idEDDEvalRespPreg' => 'empty / vacio',
            'nomEvaluacion' => 'empty / vacio',
            'nomPregunta' => 'empty / vacio',
            'nomRespPreg' => 'empty / vacio',
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
