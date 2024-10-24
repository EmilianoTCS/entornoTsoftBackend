<?php

include("../../model/conexion.php");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['editarCursoAlumnoRamoSesion'])) {
    $data = json_decode(file_get_contents("php://input"));
    $idCursoAlumnoRamoSesion = $data->idCursoAlumnoRamoSesion;
    $fechaIni = $data->fechaIni;
    $fechaFin = $data->fechaFin;
    $horaIni = $data->horaIni;
    $horaFin = $data->horaFin;
    $asistencia = $data->asistencia;
    $participacion = $data->participacion;
    $isActive = $data->isActive;
    $idSesion = $data->idSesion;
    $idCursoAlumnoRamo = $data->idCursoAlumnoRamo;
    $usuarioModificacion = $data->usuarioModificacion;

    $query = "CALL SP_editarCursoAlumnoRamoSesion($idCursoAlumnoRamoSesion, '$fechaIni','$fechaFin', $asistencia, $participacion, $isActive, $idSesion, $idCursoAlumnoRamo, '$usuarioModificacion', @p0, @p1, '$horaFin', '$horaIni')";
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
                // 'nomSesion' => $row['UPPER(se.nomSesion)'],
                // 'idCursoAlumnoRamo' => $row['idCursoAlumnoRamo']
            );
        }
    }
    $jsonstring = json_encode($json);
    echo $jsonstring;
} else {
    echo json_encode("Error");
}