<?php

include("../../model/conexion.php");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['insertarCursoAlumnoRamoSesion'])) {
    $data = json_decode(file_get_contents("php://input"));
    $fechaIni = $data->fechaIni;
    $fechaFin = $data->fechaFin;
    $horaIni = $data->horaIni;
    $horaFin = $data->horaFin;
    $data->asistencia = "" || $data->asistencia = null || $data->asistencia = 0 ? $asistencia = 0 : $asistencia = $data->asistencia;
    $data->participacion = "" || $data->participacion = null || $data->participacion =  0 ? $participacion = 0 : $participacion = $data->participacion;
    $isActive = $data->isActive;
    $idSesion = $data->idSesion;
    $idCursoAlumnoRamo = $data->idCursoAlumnoRamo;
    $usuarioCreacion = $data->usuarioCreacion;


    $query = "CALL SP_insertarCursoAlumnoRamoSesion('$fechaIni','$fechaFin', $asistencia, $participacion, $isActive, $idSesion, $idCursoAlumnoRamo, '$usuarioCreacion', @p0, @p1, '$horaIni', '$horaFin')";
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
                // 'idCursoAlumnoRamoSesion' => $row['idCursoAlumnoRamoSesion'],
                // 'fechaIni' => $row['fechaIni'],
                // 'fechaFin' => $row['fechaFin'],
                // 'horaIni' => $row['horaIni'],
                // 'horaFin' => $row['horaFin'],
                // 'asistencia' => $row['asistencia'],
                // 'participacion' => $row['participacion'],
                // 'oi' => $row['UPPER(se.nomSesion)'],
                // 'idCursoAlumnoRamo' => $row['idCursoAlumnoRamo']
            );
        }
    }
    $jsonstring = json_encode($json);
    echo $jsonstring;
} else {
    echo json_encode("Error");
}
