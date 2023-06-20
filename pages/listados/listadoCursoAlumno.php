<?php

include("../../model/conexion.php");
include("../paginador/cantPaginas.php");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['listadoCursoAlumno'])) {
    $data = json_decode(file_get_contents("php://input"));
    $data->num_boton = "" || null ? $num_boton = 1 : $num_boton = $data->num_boton;
    $data->idAlumno = "" || null ? $idAlumno = null : $idAlumno = $data->idAlumno;
    $data->idCurso = "" || null ? $idCurso = null : $idCurso = $data->idCurso;
    $data->cantidadPorPagina = "" || null ? $cantidadPorPagina = 10 : $cantidadPorPagina = $data->cantidadPorPagina;
    $inicio = ($num_boton - 1) * $cantidadPorPagina;


    $query = "CALL SP_listadoCursoAlumno('$inicio', '$cantidadPorPagina','$idAlumno', '$idCurso')";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    $json = array();
    if (mysqli_num_rows($result) > 0) {

        while ($row = mysqli_fetch_array($result)) {
            $json[] = array(
                'idCursoAlumno' => $row['idCursoAlumno'],
                'fechaIni' => $row['fechaIni'],
                'horaIni' => $row['horaIni'],
                'fechaFin' => $row['fechaFin'],
                'horaFin' => $row['horaFin'],
                'porcAsistencia' => $row['porcAsistencia'],
                'porcParticipacion' => $row['porcParticipacion'],
                'claseAprobada' => $row['claseAprobada'],
                'porcAprobacion' => $row['porcAprobacion'],
                'estadoCurso' => $row['UPPER(curAl.estadoCurso)'],
                'nomAlumno' => $row['UPPER(al.nomAlumno)'],
                'nomCurso' => $row['UPPER(cur.nomCurso)']
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
