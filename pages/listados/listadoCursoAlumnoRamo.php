<?php

include("../../model/conexion.php");
include("../paginador/cantPaginas.php");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['listadoCursoAlumnoRamo'])) {
    $data = json_decode(file_get_contents("php://input"));
    $data->num_boton = "" || null ? $num_boton = 1 : $num_boton = $data->num_boton;
    $data->idCurso = "" || null ? $idCurso = null : $idCurso = $data->idCurso;
    $data->idEmpleado = "" || null ? $idEmpleado = null : $idEmpleado = $data->idEmpleado;
    $data->cantidadPorPagina = "" || null ? $cantidadPorPagina = 10 : $cantidadPorPagina = $data->cantidadPorPagina;
    $inicio = ($num_boton - 1) * $cantidadPorPagina;


    $query = "CALL SP_listadoCursoAlumnoRamo('$inicio', '$cantidadPorPagina','$idCurso', '$idEmpleado')";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    $json = array();
    if (mysqli_num_rows($result) > 0) {

        while ($row = mysqli_fetch_array($result)) {
            $json[] = array(
                'idCursoAlumnoRamo' => $row['idCursoAlumnoRamo'],
                'fechaIni' => $row['fechaIni'],
                'horaIni' => $row['horaIni'],
                'fechaFin' => $row['fechaFin'],
                'horaFin' => $row['horaFin'],
                'porcAsistencia' => $row['porcAsistencia'],
                'porcParticipacion' => $row['porcParticipacion'],
                'ramoAprobado' => $row['ramoAprobado'],
                'porcAprobacion' => $row['porcAprobacion'],
                'estadoRamo' => $row['estadoRamo'],
                'idCursoAlumno' => $row['idCursoAlumno'],
                'idRamo' => $row['idRamo'],
                'nomRamo' => $row['nomRamo'],
                'nomEmpleado' => $row['nomEmpleado'],
                'nomCurso' => $row['nomCurso']
            );
            $FN_cantPaginas = cantPaginas($row['totalRegistros'], $cantidadPorPagina);
        }
        $jsonstring = json_encode([
            'datos' => $json,
            'paginador' => $FN_cantPaginas
        ]);
        echo $jsonstring;
    } else {
        $json[] = array(
            'idCursoAlumno' => 'empty / vacio',
            'fechaIni' => 'empty / vacio',
            'horaIni' => 'empty / vacio',
            'fechaFin' => 'empty / vacio',
            'horaFin' => 'empty / vacio',
            'porcAsistencia' => 'empty / vacio',
            'porcParticipacion' => 'empty / vacio',
            'claseAprobada' => 'empty / vacio',
            'porcAprobacion' => 'empty / vacio',
            'estadoCurso' => 'empty / vacio',
            'nomAlumno' => 'empty / vacio',
            'nomCurso' => 'empty / vacio',
        );

        $FN_cantPaginas = cantPaginas(1, $cantidadPorPagina);
        $jsonstring = json_encode([
            'datos' => $json,
            'paginador' => $FN_cantPaginas
        ]);
        echo $jsonstring;
    }
}
