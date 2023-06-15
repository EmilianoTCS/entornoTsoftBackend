<?php

include("../../model/conexion.php");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['insertarRamo'])) {
    $data = json_decode(file_get_contents("php://input"));
    $codRamo = $data->codRamo;
    $nomRamo = $data->nomRamo;
    $tipoRamo = $data->tipoRamo;
    $tipoRamoHH = $data->tipoRamoHH;
    $duracionRamoHH = $data->duracionRamoHH;
    $cantSesionesRamo = $data->cantSesionesRamo;
    $isActive = $data->isActive;
    $idCurso = $data->idCurso;
    $usuarioCreacion = $data->usuarioCreacion;

    $query = "CALL SP_insertarRamo('$codRamo','$nomRamo','$tipoRamo', $tipoRamoHH, $duracionRamoHH , $cantSesionesRamo, $isActive, $idCurso, '$usuarioCreacion', @p0, @p1, @p2)";
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
                'idRamo' => $row['idRamo'],
                'codRamo' => $row['UPPER(ram.codRamo)'],
                'nomRamo' => $row['UPPER(ram.nomRamo)'],
                'tipoRamo' => $row['UPPER(ram.tipoRamo)'],
                'tipoRamoHH' => $row['UPPER(ram.tipoRamoHH)'],
                'duracionRamoHH' => $row['duracionRamoHH'],
                'cantSesionesRamo' => $row['cantSesionesRamo'],
                'nomCurso' => $row['UPPER(cur.nomCurso)']
            );
        }
    }
    $jsonstring = json_encode($json);
    echo $jsonstring;
} else {
    echo json_encode("Error");
}
