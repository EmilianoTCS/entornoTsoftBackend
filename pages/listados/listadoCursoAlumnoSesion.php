<?php

include("../../model/conexion.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['listadoCursoAlumnoSesion'])) {
    $data = json_decode(file_get_contents("php://input"));
    $data->num_boton = "" || null ? $num_boton = 1 : $num_boton = $data->num_boton;
    $data->cantidadPorPagina = "" || null ? $cantidadPorPagina = 10 : $cantidadPorPagina = $data->cantidadPorPagina;
    $inicio = ($num_boton - 1) * $cantidadPorPagina;


    $query = "CALL SP_listadoCursoAlumnoSesion('$inicio', '$cantidadPorPagina')";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    $json = array();
    while ($row = mysqli_fetch_array($result)) {
        $json[] = array(
            'idCursoAlumnoSesion' => $row['idCursoAlumnoSesion'],
            'fechaIni' => $row['fechaIni'],
            'fechaFin' => $row['fechaFin'],
            'asistencia' => $row['asistencia'],
            'participacion' => $row['participacion'],
            'nomSesion' => $row['nomSesion'],
            'idCursoAlumno' => $row['idCursoAlumno']
        );
    }
    $jsonstring = json_encode($json);
    echo $jsonstring;
}
