<?php

include("../../model/conexion.php");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['insertarCursoAlumno'])) {
    $data = json_decode(file_get_contents("php://input"));
    $fechaIni = $data->fechaIni;
    $horaIni = $data->horaIni;
    $fechaFin = $data->fechaFin;
    $horaFin = $data->horaFin;

    $data->porcAsistencia = "" || $data->porcAsistencia = null || $data->porcAsistencia = 0 ? $porcAsistencia = 0 : $porcAsistencia = $data->porcAsistencia;
    $data->porcParticipacion = "" || $data->porcParticipacion = null || $data->porcParticipacion =  0 ? $porcParticipacion = 0 : $porcParticipacion = $data->porcParticipacion;
    $data->claseAprobada = "" || $data->claseAprobada = null || $data->claseAprobada = 0 ? $claseAprobada = 'N' : $claseAprobada = $data->claseAprobada;
    $data->porcAprobacion = "" || $data->porcAprobacion = null || $data->porcAprobacion = 0 ? $porcAprobacion = 0 : $porcAprobacion = $data->porcAprobacion;
    $data->estadoCurso = "" || $data->estadoCurso = null || $data->estadoCurso = 0 ? $estadoCurso = 'reprobado' : $estadoCurso = $data->estadoCurso;

    $isActive = $data->isActive;
    $idAlumno = $data->idAlumno;
    $idCurso = $data->idCurso;
    $usuarioCreacion = $data->usuarioCreacion;


    $query = "CALL SP_insertarCursoAlumno( '$fechaIni','$horaIni','$fechaFin','$horaFin', $porcAsistencia, $porcParticipacion, '$claseAprobada', $porcAprobacion,'$estadoCurso','$isActive', $idAlumno, $idCurso,'$usuarioCreacion', @p0, @p1)";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }


    $json = array();
    while ($row = mysqli_fetch_array($result)) {
        if ($row['OUT_CODRESULT'] != '00') {
            $json[] = array(
                'OUT_CODRESULT' => $row['OUT_CODRESULT'],
                'OUT_MJERESULT' => $row['OUT_MJERESULT']
            );
        } else {
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
        }
    }
    $jsonstring = json_encode($json);
    echo $jsonstring;
} else {
    echo json_encode("Error");
}
