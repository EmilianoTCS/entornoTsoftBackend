<?php

include("../../model/conexion.php");
include("../paginador/cantPaginas.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['listadoCursoAlumnoRamoSesion'])) {
    $data = json_decode(file_get_contents("php://input"));
    $data->num_boton = "" || null ? $num_boton = 1 : $num_boton = $data->num_boton;
    $data->idSesion = "" || null ? $idSesion = null : $idSesion = $data->idSesion;
    $data->idEmpleado = "" || null ? $idEmpleado = null : $idEmpleado = $data->idEmpleado;
    $data->cantidadPorPagina = "" || null ? $cantidadPorPagina = 10 : $cantidadPorPagina = $data->cantidadPorPagina;
    $inicio = ($num_boton - 1) * $cantidadPorPagina;


    $query = "CALL SP_listadoCursoAlumnoRamoSesion('$inicio', '$cantidadPorPagina', '$idSesion', '$idEmpleado')";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    $json = array();
    if (mysqli_num_rows($result) > 0) {

        while ($row = mysqli_fetch_array($result)) {
            $json[] = array(
                'idCursoAlumnoRamoSesion' => $row['idCursoAlumnoRamoSesion'],
                'fechaIni' => $row['fechaIni'],
                'fechaFin' => $row['fechaFin'],
                'horaIni' => $row['horaIni'],
                'horaFin' => $row['horaFin'],
                'asistencia' => $row['asistencia'],
                'participacion' => $row['participacion'],
                'nomSesion' => $row['UPPER(se.nomSesion)'],
                'idCursoAlumnoRamo' => $row['idCursoAlumnoRamo'],
                'nomEmpleado' => $row['nomEmpleado']
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
            'idCursoAlumnoRamoSesion' => 'empty / vacio',
            'fechaIni' => 'empty / vacio',
            'fechaFin' => 'empty / vacio',
            'asistencia' => 'empty / vacio',
            'participacion' => 'empty / vacio',
            'nomSesion' => 'empty / vacio',
            'idCursoAlumno' => 'empty / vacio',
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