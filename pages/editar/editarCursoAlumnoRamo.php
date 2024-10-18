<?php

include("../../model/conexion.php");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['editarCursoAlumnoRamo'])) {
    $data = json_decode(file_get_contents("php://input"));
    $fechaIni = $data->fechaIni;
    $horaIni = $data->horaIni;
    $fechaFin = $data->fechaFin;
    $horaFin = $data->horaFin;

    $data->porcAsistencia = "" || $data->porcAsistencia = null || $data->porcAsistencia = 0 ? $porcAsistencia = 0 : $porcAsistencia = $data->porcAsistencia;
    $data->porcParticipacion = "" || $data->porcParticipacion = null || $data->porcParticipacion =  0 ? $porcParticipacion = 0 : $porcParticipacion = $data->porcParticipacion;
    $data->ramoAprobado = "" || $data->ramoAprobado = null || $data->ramoAprobado = 0 ? $ramoAprobado = 'N' : $ramoAprobado = $data->ramoAprobado;
    $data->porcAprobacion = "" || $data->porcAprobacion = null || $data->porcAprobacion = 0 ? $porcAprobacion = 0 : $porcAprobacion = $data->porcAprobacion;
    $data->estadoRamo = "" || $data->estadoRamo = null || $data->estadoRamo = 0 ? $estadoRamo = 'reprobado' : $estadoRamo = $data->estadoRamo;

    $isActive = $data->isActive;
    $idRamo = $data->idRamo;
    $idCursoAlumno = $data->idCursoAlumno;
    $idCursoAlumnoRamo = $data->idCursoAlumnoRamo;
    $usuarioCreacion = $data->usuarioCreacion;


    $query = "CALL SP_editarCursoAlumnoRamo($idCursoAlumnoRamo, '$fechaIni','$fechaFin','$horaIni','$horaFin', $porcAsistencia, $porcParticipacion, '$ramoAprobado', $porcAprobacion,'$estadoRamo',$idCursoAlumno,$idRamo,'$isActive','$usuarioCreacion', @p0, @p1)";
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
                'OUT_CODRESULT' => $row['OUT_CODRESULT'],
                'OUT_MJERESULT' => $row['OUT_MJERESULT'],
                // 'idCursoAlumno' => $row['idCursoAlumno'],
                // 'fechaIni' => $row['fechaIni'],
                // 'horaIni' => $row['horaIni'],
                // 'fechaFin' => $row['fechaFin'],
                // 'horaFin' => $row['horaFin'],
                // 'porcAsistencia' => $row['porcAsistencia'],
                // 'porcParticipacion' => $row['porcParticipacion'],
                // 'claseAprobada' => $row['claseAprobada'],
                // 'porcAprobacion' => $row['porcAprobacion'],
                // 'estadoCurso' => $row['estadoCurso'],
                // 'nomEmpleado' => $row['UPPER(emp.nomEmpleado)'],
                // 'nomCurso' => $row['UPPER(cur.nomCurso)']
            );
        }
    }
    $jsonstring = json_encode($json);
    echo $jsonstring;
} else {
    echo json_encode("Error");
}
