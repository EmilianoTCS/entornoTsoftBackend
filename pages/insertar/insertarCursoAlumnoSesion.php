<?php

include("../../model/conexion.php");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['insertarCursoAlumnoSesion'])) {
    $data = json_decode(file_get_contents("php://input"));
    $fechaIni = $data->fechaIni;
    $fechaFin = $data->fechaFin;
  $data->porcAsistencia = "" || $data->porcAsistencia = null || $data->porcAsistencia = 0 ? $porcAsistencia = 0 : $porcAsistencia = $data->porcAsistencia;
    $data->porcParticipacion = "" || $data->porcParticipacion = null || $data->porcParticipacion =  0 ? $porcParticipacion = 0 : $porcParticipacion = $data->porcParticipacion;
    $isActive = $data->isActive;
    $idSesion = $data->idSesion;
    $idCursoAlumno = $data->idCursoAlumno;
    $usuarioCreacion = $data->usuarioCreacion;





    $query = "CALL SP_insertarCursoAlumnoSesion('$fechaIni','$fechaFin', $porcAsistencia, $porcParticipacion, $isActive, $idSesion, $idCursoAlumno, '$usuarioCreacion', @p0, @p1)";
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
                'idCursoAlumnoSesion' => $row['idCursoAlumnoSesion'],
                'fechaIni' => $row['fechaIni'],
                'fechaFin' => $row['fechaFin'],
                'asistencia' => $row['asistencia'],
                'participacion' => $row['participacion'],
                'oi' => $row['UPPER(se.nomSesion)'],
                'idCursoAlumno' => $row['idCursoAlumno']
            );
        }
    }
    $jsonstring = json_encode($json);
    echo $jsonstring;
} else {
    echo json_encode("Error");
}
