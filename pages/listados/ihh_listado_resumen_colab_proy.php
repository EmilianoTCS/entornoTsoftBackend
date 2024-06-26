<?php

include("../../model/conexion.php");
include("../paginador/cantPaginas.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['ihh_listado_resumen_colab_proy'])) {
    $data = json_decode(file_get_contents("php://input"));
    $data->idColaborador = "" || null ? $idColaborador = null : $idColaborador = $data->idColaborador;
    $data->idProyecto = "" || null ? $idProyecto = null : $idProyecto = $data->idProyecto;
    $data->fechaInicio = "" || null ? $fechaInicio = null : $fechaInicio = $data->fechaInicio;
    $data->fechaFin = "" || null ? $fechaFin = null : $fechaFin = $data->fechaFin;

    $query = "CALL SP_ihh_listado_resumen_colab_proy('$idColaborador','$idProyecto', '$fechaInicio', '$fechaFin', @p0, @p1)";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }
    $datosTabla = array();
    if (mysqli_num_rows($result) > 0) {

        while ($row = mysqli_fetch_array($result)) {
            $datosTabla[] = array(
                'nomProyecto' => $row['nomProyecto'],
                'idProyecto' => $row['idProyecto'],
                'cantHH' => $row['cantHH'],
                'cantHHEE' => $row['cantHHEE']
            );
        }

        $jsonstring = json_encode(
            $datosTabla
        );
        echo $jsonstring;
    } else {
        $datosTabla[] = array(
            'nomProyecto' => null,
            'idProyecto' => null,
            'cantHH' => null,
            'cantHHEE' => null
        );
        $jsonstring = json_encode(
            $datosTabla
        );
        echo $jsonstring;
    }
}
