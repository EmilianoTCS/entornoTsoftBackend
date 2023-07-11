<?php

include("../../model/conexion.php");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['editarCursoAlumno'])) {
    $data = json_decode(file_get_contents("php://input"));
    $idCursoAlumno = $data->idCursoAlumno;
    $fechaIni = $data->fechaIni;
    $horaIni = $data->horaIni;
    $fechaFin = $data->fechaFin;
    $horaFin = $data->horaFin;
    $porcAsistencia = $data->porcAsistencia;
    $porcParticipacion = $data->porcParticipacion;
    $claseAprobada = $data->claseAprobada;
    $porcAprobacion = $data->porcAprobacion;
    $estadoCurso = $data->estadoCurso;
    $isActive = $data->isActive;
    $idEmpleado = $data->idEmpleado;
    $idCurso = $data->idCurso;
    $usuarioModificacion = $data->usuarioModificacion;


    $query = "CALL SP_editarCursoAlumno($idCursoAlumno, '$fechaIni','$horaIni','$fechaFin','$horaFin', $porcAsistencia, $porcParticipacion, '$claseAprobada', $porcAprobacion,'$estadoCurso','$isActive', $idEmpleado, $idCurso,'$usuarioModificacion', @p0, @p1)";
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
                'nomEmpleado' => $row['UPPER(emp.nomEmpleado)'],
                'nomCurso' => $row['UPPER(cur.nomCurso)']
            );
        }
    }
    $jsonstring = json_encode($json);
    echo $jsonstring;
} else {
    echo json_encode("Error");
}
