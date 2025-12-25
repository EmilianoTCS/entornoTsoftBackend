<?php

include("../../model/conexion.php");
include("../paginador/cantPaginas.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['listadoEddEvaluacion'])) {
    $data = json_decode(file_get_contents("php://input"));
    $data->num_boton = "" || null ? $num_boton = 1 : $num_boton = $data->num_boton;
    $data->idEDDEvaluacion = "" || null ? $idEDDEvaluacion = null : $idEDDEvaluacion = $data->idEDDEvaluacion;
    $data->cantidadPorPagina = "" || null ? $cantidadPorPagina = 10 : $cantidadPorPagina = $data->cantidadPorPagina;
    $inicio = ($num_boton - 1) * $cantidadPorPagina;


    $query = "CALL SP_listadoEddEvaluacion('$inicio', '$cantidadPorPagina', '$idEDDEvaluacion')";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    $json = array();
    if (mysqli_num_rows($result) > 0) {

        while ($row = mysqli_fetch_array($result)) {
            $json[] = array(
                'idEDDEvaluacion' => $row['idEDDEvaluacion'],
                'nomEvaluacion' => $row['nomEvaluacion'],
                'tipoEvaluacion' => $row['tipoEvaluacion'],
                'fechaIni' => $row['fechaIni'],
                'fechaFin' => $row['fechaFin'],
                'disponibilidadEvaluacion' => $row['disponibilidadEvaluacion'],
                'descFormulario' => $row['descFormulario'],
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
            'idCurso' => 'empty / vacio',
            'codCurso' => 'empty / vacio',
            'nomCurso' => 'empty / vacio',
            'tipoHH' => 'empty / vacio',
            'duracionCursoHH' => 'empty / vacio',
            'cantSesionesCurso' => 'empty / vacio',
            'disponibilidadEvaluacion' => 'empty / disponibilidadEvaluacion'
        );

        $FN_cantPaginas = cantPaginas(1, $cantidadPorPagina);
        $jsonstring = json_encode([
            'datos' => $json,
            'paginador' => $FN_cantPaginas
        ]);
        echo $jsonstring;
    }
}
