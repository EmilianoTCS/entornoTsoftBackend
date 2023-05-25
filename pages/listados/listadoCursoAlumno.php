<?php

include("../../model/conexion.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['listadoCursoAlumno'])) {
    $data = json_decode(file_get_contents("php://input"));
    $data->num_boton = "" || null ? $num_boton = 1 : $num_boton = $data->num_boton;
    $data->cantidadPorPagina = "" || null ? $cantidadPorPagina = 10 : $cantidadPorPagina = $data->cantidadPorPagina;
    $inicio = ($num_boton - 1) * $cantidadPorPagina;


    $query = "CALL SP_listadoCursoAlumno('$inicio', '$cantidadPorPagina')";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    $json = array();
    while ($row = mysqli_fetch_array($result)) {
        $json[] = array(
            'idCursoAlumno' => $row['idCursoAlumno'],
            'fechaIni' => $row['fechaIni'],
            'horaIni' => $row['horaIni'],
            'fechaFin' => $row['fechaFin'],
            'horaFin' => $row['horaFin'],
            'porcAsistencia' => $row['porcAsistencia'],
            'porcParticipacion' => $row['porcParticipacion'],
            'claseAprobada' => $row['UPPER(curAl.claseAprobada)'],
            'porcAprobacion' => $row['porcAprobacion'],
            'estadoCurso' => $row['UPPER(curAl.estadoCurso)'],
            'nomAlumno' => $row['UPPER(al.nomAlumno)'],
            'nomCurso' => $row['UPPER(cur.nomCurso)']
        );
    }
    $jsonstring = json_encode($json);
    echo $jsonstring;
}
