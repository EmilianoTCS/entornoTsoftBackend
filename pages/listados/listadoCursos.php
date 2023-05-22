<?php

include("../../model/conexion.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['listadoCursos'])) {

    $data = json_decode(file_get_contents("php://input"));

    $data->num_boton = "" || null ? $num_boton = 1 : $data->num_boton;
    $data->cantidadPorPagina = "" || null ? $cantidadPorPagina = 10 : $data->cantidadPorPagina;
    $inicio = ($num_boton - 1) * $cantidadPorPagina;


    $query = "CALL SP_listadoCursos('$inicio', '$cantidadPorPagina')";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    $json = array();
    while ($row = mysqli_fetch_array($result)) {
        $json[] = array(
            'idCurso' => $row['idCurso'],
            'codCurso' => $row['codCurso'],
            'nomCurso' => $row['nomCurso'],
            'tipoHH' => $row['tipoHH'],
            'duracionCursoHH' => $row['duracionCursoHH'],
            'cantSesionesCurso' => $row['cantSesionesCurso']

        );
    }
    $jsonstring = json_encode($json);
    echo $jsonstring;
}
